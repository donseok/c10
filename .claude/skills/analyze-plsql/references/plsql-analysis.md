# PL/SQL 분석 상세 절차

## Step 0: 사전 검증 (필수)

1. **MCP 서버 확인**
   - `mcp__serena__get_current_config` 호출 확인
   - Serena MCP 없으면 "❌ Serena MCP 필요" 출력 후 종료

2. **파라미터 검증**
   - NAME 필수 입력 확인
   - 빈 값 또는 null 시 에러 메시지 출력 후 종료

---

## Step 1: PL/SQL 소스 검색 (DB 직접 조회)

### 1-1. DB 접속 및 오브젝트 검색

**오브젝트 검색 쿼리**:
```sql
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS
FROM ALL_OBJECTS
WHERE OBJECT_NAME = UPPER(:NAME)
  AND OWNER IN ('MESAPUSER', 'APSUSER')
  AND OBJECT_TYPE IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
ORDER BY OWNER, OBJECT_TYPE;
```

### 1-2. 검색 결과 처리 분기

**케이스 1: 오브젝트 1개 발견** → 자동 선택

**케이스 2: 오브젝트 2개 이상 발견** → AskUserQuestion으로 선택
```javascript
if (foundObjects.length > 1) {
  const options = foundObjects.map(obj => ({
    label: obj.OWNER + "/" + obj.OBJECT_TYPE,
    description: obj.OWNER + "." + obj.OBJECT_NAME + " (" + obj.OBJECT_TYPE + ")",
    value: obj.OWNER + "." + obj.OBJECT_NAME
  }));
  const answer = await AskUserQuestion({
    questions: [{
      question: "'" + NAME + "' 오브젝트가 " + foundObjects.length + "개 발견되었습니다. 분석할 오브젝트를 선택하세요.",
      header: "오브젝트 선택",
      multiSelect: false,
      options: options
    }]
  });
}
```

**케이스 3: 오브젝트 없음** → 종료

### 1-3. 선택된 오브젝트 정보 추출
```javascript
const SCHEMA_NAME = selected.OWNER;          // MESAPUSER or APSUSER
const OBJECT_NAME = selected.OBJECT_NAME;    // PL_M30_STOCK_CSM
const TYPE = selected.OBJECT_TYPE;           // PACKAGE, PROCEDURE, FUNCTION
```

### 1-4. PL/SQL 소스 코드 추출

```sql
-- PACKAGE BODY 소스 코드 조회
SELECT TEXT
FROM ALL_SOURCE
WHERE OWNER = :SCHEMA_NAME
  AND NAME = :OBJECT_NAME
  AND TYPE = :TYPE
ORDER BY LINE;

-- 패키지인 경우 SPEC도 추가 조회
SELECT TEXT
FROM ALL_SOURCE
WHERE OWNER = :SCHEMA_NAME
  AND NAME = :OBJECT_NAME
  AND TYPE = 'PACKAGE'
ORDER BY LINE;
```

### 1-5. 소스 코드 로드
- 조회된 소스 코드를 문자열로 결합하여 분석 대상으로 사용
- SPEC 소스가 있으면 인터페이스 정의 확인용으로 추가 로드

---

## Step 2: 파일 타입별 구조 분석 (Serena 심볼 도구 활용)

### 2-1. 분석 전략 결정
```javascript
if (TYPE === 'PACKAGE') {
  analysisStrategy = 'PACKAGE_ANALYSIS';        // 여러 프로시저/함수 포함
} else if (TYPE === 'PROCEDURE') {
  analysisStrategy = 'SINGLE_PROCEDURE_ANALYSIS'; // 단일 프로시저
} else if (TYPE === 'FUNCTION') {
  analysisStrategy = 'SINGLE_FUNCTION_ANALYSIS';  // 단일 함수
}
```

**Function이거나 위 방법으로 못 찾을 때는 직접 Oracle(sqlcl MCP) 연결해서 찾을 것. DB User는 MESAPUSER 또는 APSUSER.**

### 2-2. 기본 메타데이터 수집

- 오브젝트명, 스키마명, 타입, 서브타입(BODY/SPEC)
- 전체 코드 줄 수, 분석 일시 (KST)
- 파일 수준 주석 파싱 (작성자, 버전, 생성일자)

### 2-3. 프로시저/함수 목록 추출

**PACKAGE 분석 모드**:
```javascript
const symbols = await mcp__serena__get_symbols_overview({
  relative_path: selectedFile
});
const procedures = symbols.filter(s => s.kind === 6 || s.kind === 12);
// kind: 6=method(PROCEDURE), 12=function(FUNCTION)
```

**SINGLE_PROCEDURE/FUNCTION 분석 모드**:
```javascript
const procedures = [{
  name: OBJECT_NAME,
  kind: TYPE === 'PROCEDURE' ? 6 : 12,
  range: "1-" + totalLines,
  detail: "독립 프로시저/함수 (파일 전체)"
}];
```

### 2-4. 프로시저/함수 카테고리 분류 (PACKAGE 모드만)

1. **진입점 프로시저**: MAIN, EXECUTE, RUN, PROCESS 이름 패턴 / VObjectId, VProgramId, ERR_CODE, MSG 파라미터 패턴
2. **검증 프로시저**: VALIDATE, CHECK, VERIFY, ERROR_CHECK / RAISE_APPLICATION_ERROR 포함
3. **계산/처리 프로시저**: CALC, COMPUTE, MAKE, PROCESS / 수학적 연산 또는 데이터 변환
4. **데이터 접근 함수**: RETURN 타입 있음 / SELECT 문 포함
5. **유틸리티 함수**: GET_, SET_, IS_, HAS_ 접두사

---

## Step 3: 각 프로시저/함수 심층 분석 (Sequential MCP 활용)

**⚠️ 중요**: 각 프로시저/함수마다 Sequential MCP 호출하여 상세 분석. **프로시저/함수를 빠뜨리면 안 된다.**

### 3-1. 프로시저/함수 코드 로드
```javascript
const procedureDetail = await mcp__serena__find_symbol({
  name_path: procedureName,
  relative_path: bodyFile.path,
  include_body: true,
  depth: 1
});
```

### 3-2. Sequential MCP를 통한 심층 로직 분석

**분석 항목**:
1. 비즈니스 목적 추론 (핵심 업무, 입출력)
2. 실행 흐름 분석 (BEGIN-END 단계별)
3. 제어 흐름 분석 (IF/FOR/CASE)
4. 데이터 접근 패턴 (SELECT/INSERT/UPDATE/DELETE)
5. 비즈니스 규칙 추출 (검증, 계산, 특수처리)
6. 트랜잭션 제어 (SAVEPOINT/COMMIT/ROLLBACK)
7. 예외 처리 (RAISE_APPLICATION_ERROR)
8. 외부 의존성 (호출 함수/패키지, 외부 시스템)

```javascript
const analysis = await mcp__sequential_thinking__sequentialthinking({
  thought: "프로시저 [프로시저명]의 비즈니스 로직을 8개 항목으로 단계별 분석",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 15
});
```

### 3-3. 커서 루프 상세 분석

**커서 감지 패턴**:
```sql
FOR cursor_name IN (
  SELECT ...
  FROM ...
  WHERE ...
)
LOOP
  -- 처리 내용
END LOOP;
```

**각 커서별 분석 항목**:
1. 커서 SQL 추출 (SELECT 문 전체)
2. 커서 목적 (조회 데이터 및 용도)
3. 반복 범위 (예상 행 수)
4. 루프 내 작업 (DML, 조건 분기 등)
5. 중첩도 (FOR 안의 FOR)

분석 결과는 템플릿 § 3 "커서 루프 상세 분석" 형식으로 작성

### 3-4. 비즈니스 규칙 표 생성

**검증 규칙 추출 패턴**:
```sql
IF [조건] THEN
  RAISE_APPLICATION_ERROR([에러 코드], [메시지]);
END IF;
```

수집한 규칙들을 템플릿 § 3 "비즈니스 규칙" 표 형식으로 정리

### 3-5. 데이터 플로우 생성

입력 → 처리 → 출력 흐름을 추적하여 템플릿 § 4 "데이터 플로우" 형식으로 작성

### 3-6. 호출 프로시저/함수 감지

**호출 감지 패턴**:
```sql
-- 1. 같은 패키지 내 프로시저/함수 호출
프로시저명(파라미터...);
-- 2. 다른 패키지의 프로시저/함수 호출
패키지명.프로시저명(파라미터...);
-- 3. 독립 프로시저/함수 호출
스키마명.프로시저명(파라미터...);
```

**호출 감지 쿼리** (DB에서 의존성 확인):
```sql
SELECT REFERENCED_OWNER, REFERENCED_NAME, REFERENCED_TYPE
FROM ALL_DEPENDENCIES
WHERE OWNER = :SCHEMA_NAME
  AND NAME = :OBJECT_NAME
  AND REFERENCED_TYPE IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
  AND REFERENCED_OWNER IN ('MESAPUSER', 'APSUSER')
  AND REFERENCED_NAME != :OBJECT_NAME  -- 자기 자신 제외
ORDER BY REFERENCED_OWNER, REFERENCED_NAME;
```

**호출 목록 구조**:
```javascript
calledObjects.push({
  owner: "APSUSER",
  name: "PROC_APS_PSLS030",
  type: "PROCEDURE",
  calledFrom: "MAIN_PROCESS",
  callContext: "라인 번호 또는 코드 위치",
  purpose: "호출 맥락에서 추론한 목적"
});
```

---

## Step 3.5: 호출 프로시저 재귀 분석

**⚠️ 중요**: 분석 대상 프로시저가 호출하는 모든 외부 프로시저/패키지를 재귀적으로 분석한다.

### 3.5-1. 재귀 분석 대상 결정

```javascript
for (const called of calledObjects) {
  let reportPath;
  if (called.type === 'PACKAGE' || called.type === 'PACKAGE BODY') {
    reportPath = "docs/analysis/dbms/" + called.owner + "/package/" + called.name + "_analysis_report.md";
  } else if (called.type === 'PROCEDURE') {
    reportPath = "docs/analysis/dbms/" + called.owner + "/storedProcedure/" + called.name + "_analysis_report.md";
  } else if (called.type === 'FUNCTION') {
    reportPath = "docs/analysis/dbms/" + called.owner + "/function/" + called.name + "_analysis_report.md";
  }

  if (fileExists(reportPath)) {
    called.reportPath = reportPath;
    called.alreadyAnalyzed = true;
  } else {
    called.alreadyAnalyzed = false;
  }
}
```

### 3.5-2. 재귀 분석 실행

미분석 오브젝트에 대해 Step 1~6 전체를 재귀적으로 실행한다.

### 3.5-3. 재귀 깊이 제한

```javascript
const MAX_RECURSIVE_DEPTH = 3;

function analyzeWithDepth(objectName, owner, currentDepth) {
  if (currentDepth >= MAX_RECURSIVE_DEPTH) {
    LOG.warn("⚠️ 최대 재귀 깊이(" + MAX_RECURSIVE_DEPTH + ") 도달: "
      + owner + "." + objectName + " - 호출 기록만 남기고 분석 생략");
    return { skipped: true, reason: "최대 재귀 깊이 초과" };
  }
  // ... 분석 수행 (currentDepth + 1 전달)
}
```

### 3.5-4. 순환 참조 방지

```javascript
const analyzedSet = new Set();

function isAlreadyInProgress(owner, name) {
  const key = owner + "." + name;
  if (analyzedSet.has(key)) {
    LOG.warn("⚠️ 순환 참조 감지: " + key + " - 분석 생략");
    return true;
  }
  analyzedSet.add(key);
  return false;
}
```

### 3.5-5. 호출 프로시저 요약 정보 수집

```javascript
for (const called of calledObjects) {
  if (called.reportPath && called.alreadyAnalyzed) {
    const report = readFile(called.reportPath);
    called.summary = extractSummaryFromReport(report);
    // summary: 비즈니스 목적, 주요 입출력 테이블, 프로시저/함수 수, 총 코드 라인 수
  }
}
```

---

## Step 4: 테이블 의존성 및 ER 관계 추출

### 4-1. 테이블 목록 수집

```javascript
const tablePattern = /(?:FROM|JOIN|INTO|UPDATE|DELETE\s+FROM)\s+([A-Z_][A-Z0-9_]*)/gi;
const tables = new Set();
allProcedures.forEach(proc => {
  const matches = proc.body.matchAll(tablePattern);
  for (const match of matches) { tables.add(match[1]); }
});
```

### 4-2. 테이블별 역할 분류

1. **입력 임시 테이블**: `_TEMP_`, `_TMP_` 패턴, 주로 DELETE 대상
2. **마스터 테이블**: `_MASTER`, `_MST` 패턴, SELECT 빈도 높음
3. **상세/이력 테이블**: `_DTL`, `_DETAIL`, `_HST`, `_HISTORY` 패턴, INSERT/UPDATE 대상
4. **전표/문서 테이블**: `_CMN`, `_DOC`, `_HDR` 패턴, 채번 함수 사용

### 4-3. JOIN 관계 추출

```sql
FROM table1 t1
INNER JOIN table2 t2 ON t1.col = t2.col
LEFT JOIN table3 t3 ON t2.col = t3.col
```

추출한 관계를 템플릿 § 5 "ER 다이어그램" 형식으로 작성

---

## Step 5: Mermaid 워크플로우 다이어그램 생성

### 5-1. 주요 비즈니스 프로세스 식별

진입점 프로시저 기준으로 플로우 추적:
- 진입점 프로시저 (MAIN, EXECUTE 등) 선택
- 호출 순서 추적: A → B → C
- 조건 분기 식별: IF → 분기 1 / 분기 2

### 5-2. Mermaid Flowchart 생성

- 메인 프로시저의 플로우차트를 가장 위에 생성
- 호출되는 서브 프로시저들의 플로우차트를 아래에 순서대로 배치
- 템플릿 § 2 "워크플로우 다이어그램"의 색상 규칙 적용

---

## Step 6: Markdown 보고서 생성

### 6-1. 템플릿 로드
- `.claude/skills/analyze-plsql/templates/plsql_package_analysis_report_template.md`

### 6-2. 플레이스홀더 치환

```javascript
const replacements = {
  "[PACKAGE-ID]": SCHEMA_NAME + "." + PACKAGE_NAME,
  "[PACKAGE_NAME]": PACKAGE_NAME,
  "[SCHEMA_NAME]": SCHEMA_NAME,
  "[분석 수행 시각 (KST)]": new Date().toLocaleString('ko-KR', { timeZone: 'Asia/Seoul' }),
  "[전체 프로시저/함수 수]": procedures.length,
  "[총 줄 수]": totalLines,
  "[LLM 모델명 및 버전]": "Claude Sonnet 4.5 (2025-09-29)"
};
```

### 6-3. 각 섹션별 데이터 삽입

- § 1: 프로시저/패키지 개요 (메타데이터)
- § 2: 비즈니스 프로세스 분석 (목적, 워크플로우, 주요 프로세스)
- § 3: 프로시저/함수 상세 분석 (각 프로시저별 완전한 분석)
- § 4: 데이터 요구사항 (테이블 맵, 데이터 플로우)
- § 5: ER 다이어그램 (관계 텍스트)
- § 6: 특이사항 (복잡도, 성능, 트랜잭션 주의사항)

### 6-3a. 호출 프로시저 요약 및 링크 삽입 (필수)

§ 3 프로시저 상세 분석 내에서, 외부 호출이 있는 경우 해당 위치에 삽입:

```markdown
> **📎 호출 프로시저**: [`{SCHEMA}.{OBJECT_NAME}`]({상대경로_보고서_링크})
> - **목적**: {비즈니스 목적 1줄 요약}
> - **주요 테이블**: {주요 입출력 테이블 목록}
> - **코드 규모**: {프로시저/함수 N개, 총 M라인}
```

**예시**:
```markdown
**라인 245**: `APSUSER.PROC_APS_PSLS030(v_obj_id, v_prog_id, ...)` 호출

> **📎 호출 프로시저**: [`APSUSER.PROC_APS_PSLS030`](../APSUSER/storedProcedure/PROC_APS_PSLS030_analysis_report.md)
> - **목적**: APS 소재 실적 처리
> - **주요 테이블**: TB_APS_PSLS030, TB_APS_PSLS030_DTL, TB_M17_COIL_MST
> - **코드 규모**: 프로시저 12개, 총 7,981라인
```

**상대경로 계산 규칙**:
```javascript
function getRelativePath(currentReportPath, calledReportPath) {
  return path.relative(path.dirname(currentReportPath), calledReportPath);
}
```

**재귀 깊이 초과로 분석 생략된 경우**:
```markdown
> **📎 호출 프로시저**: `{SCHEMA}.{OBJECT_NAME}` (미분석 - 재귀 깊이 초과)
> - **참고**: 최대 재귀 깊이(3) 초과로 상세 분석이 생략되었습니다. 별도로 `/analyze-plsql {OBJECT_NAME}` 실행을 권장합니다.
```

### 6-4. 파일 쓰기 (타입별 출력 경로)

```javascript
let outputPath;
if (TYPE === 'PACKAGE') {
  outputPath = "docs/analysis/dbms/" + SCHEMA_NAME + "/package/" + OBJECT_NAME + "_analysis_report.md";
} else if (TYPE === 'PROCEDURE') {
  outputPath = "docs/analysis/dbms/" + SCHEMA_NAME + "/storedProcedure/" + OBJECT_NAME + "_analysis_report.md";
} else if (TYPE === 'FUNCTION') {
  outputPath = "docs/analysis/dbms/" + SCHEMA_NAME + "/function/" + OBJECT_NAME + "_analysis_report.md";
}
```

디렉토리 없으면 자동 생성. 파일 이미 존재하면 덮어쓰기 진행.
