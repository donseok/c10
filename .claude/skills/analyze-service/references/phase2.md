# Phase 2 - Java 심층 분석

레거시 시스템 분석의 두 번째 단계로, Custom Java 클래스를 심층 분석하여 비즈니스 로직을 추출합니다.

## MANDATORY EARLY TERMINATION RULE

**IF customActivities is empty/undefined/null:**
1. Create `{}`
2. STOP ALL ANALYSIS
3. DO NOT analyze built-in activities
4. DO NOT generate detailed reports
5. TERMINATE immediately

**VIOLATION of this rule will result in:**
- Unnecessary resource consumption
- Inconsistent analysis results
- Extended execution time (40s → 5s expected)

## 실행 알고리즘

### Step 0: Serena MCP 체크 (**필수**)
- `mcp__serena__get_current_config` 호출 확인
- 없으면 "❌ Serena MCP 필요" 출력 후 종료

### Step 1: structure.json 및 작업파일 확인

1. **파일 경로 확인**: `mcp__serena__find_file` 사용
   - 파일 검색: `[SERVICE-ID]_structure.json`
   - 존재 하지 않으면 메시지 출력 후 종료

2. **java_analysis.json**: `mcp__serena__find_file` 사용
   - **파일 위치**: `[SERVICE-ID]_java_analysis.json`
   - 재작업 방지 위해 파일이 존재하면 종료하여 다음 Step 진행

### Step 2: **MANDATORY PRE-VALIDATION** (가장 먼저 실행)

#### 2-1. **structure.json 로드 즉시 실행**

```javascript
// 🚨 MANDATORY: structure.json 로드 후 다음 코드를 반드시 즉시 실행
function validateCustomActivities(structure) {
  const customActivities = structure.serviceStructure?.customActivities || [];

  if (customActivities === undefined ||
      customActivities === null ||
      customActivities.length === 0) {

    const emptyResult = {
      "serviceInfo": {
        "serviceId": "[SERVICE-ID]",
        "processCode": "[PROCESS-CODE]",
        "analysisDate": new Date().toISOString().split('T')[0]
      }
    };

    saveOutputFile(emptyResult);
    LOG.info("MANDATORY: customActivities is empty → early termination");
    PROCESS.TERMINATE();
    return false;
  }

  return true;
}
```

#### 2-2. **조기 종료 조건** (customActivities 배열 기준만 사용)

**✅ 분석 진행 가능**: customActivities 배열에 1개 이상 요소가 있는 경우
**❌ 즉시 조기 종료**: 다음 모든 경우 - 빈 배열/undefined/null

**기준 통일**:
- `activities.type='custom'` 속성과 무관하게 **customActivities 배열만 최종 기준**으로 사용
- activities.type이 'custom'이라도 customActivities 배열에 없으면 분석 금지
- type이 'common', 'built-in'인 activity는 절대 분석 금지

### Step 2.5: ConstantsIF 상수 정의 파싱 (동적 검색) (**SQL 매핑 해석용**)

**목적**: Java 클래스에서 참조하는 SQL 상수(SELECT_SQL, INSERT_SQL 등)를 실제 XML 키로 변환하기 위한 맵핑 테이블 생성

**파싱 대상**: `./src/**/M[숫자]ConstantsIF.java` (동적 검색, 예: m47→M47ConstantsIF)

**검색 방법**: `mcp__serena__find_file`로 `*ConstantsIF.java` 패턴 검색

**추출 항목**:
```javascript
const sqlConstants = {
  "SELECT_SQL": "select-sql",
  "SELECT_SQL2": "select-sql2",
  "SELECT_SQL3": "select-sql3",
  "INSERT_SQL": "insert-sql",
  "INSERT_SQL2": "insert-sql2",
  "UPDATE_SQL": "update-sql",
  "DELETE_SQL": "delete-sql",
  // ... 모든 SQL 관련 상수
};
```

**상수 해석 규칙**:
1. **직접 매핑**: 상수값이 직접 SQL 키인 경우 (예: "select-sql")
2. **Context 기반 추론**: 상수명으로부터 SQL 키 유추 (예: SELECT_SQL2 → "select-sql2")
3. **서비스 ID 조합**: 서비스 ID와 상수값 조합으로 전체 키 생성 (예: "M473020030.select-sql")

### Step 3: Custom Java 클래스 심층 분석 (**validation 통과 시에만 진행**)

**⚠️ 중요**: Step 2-1 validation을 통과한 경우에만 이 단계 진행
- customActivities 배열의 각 항목만 순회하며 Java 클래스 심층 분석
- 기타 activity(type='built-in', 'common')은 절대 분석 금지

#### 3-0. **기존 커스텀 클래스 분석 보고서 활용** (MANDATORY - 반드시 선행)

각 커스텀 클래스에 대해 분석을 시작하기 전, 메인 오케스트레이터(analyze-service)가 이미 생성한 분석 보고서를 확인하고 활용한다.

```javascript
function checkExistingAnalysis(fullClassName) {
  var analysisPath = 'docs/analysis/service/customClass/' + fullClassName + '_class_analysis.md';
  return fileExists(analysisPath);
}
```

| 상태 | 처리 |
|------|------|
| ✅ 분석 보고서 존재 | 기존 보고서를 읽어서 java_analysis.json 데이터 소스로 활용. Serena 재분석 생략. |
| ❌ 분석 보고서 미존재 | 경고 로그 출력 후 스킵 (메인 오케스트레이터에서 선행 생성해야 하므로 비정상 상황) |

**기존 분석 활용 시 데이터 추출 방법**:
1. `[fullClassName]_class_analysis.json` 파일 읽기 (per-class 스키마와 동일 구조)
2. 읽은 JSON 객체를 `java_analysis.json`의 `classes[ClassName]`에 직접 매핑
3. JSON 파일 미존재 시 마크다운 보고서에서 fallback 파싱

**각 클래스별 심층 분석 항목** (분석 보고서가 없는 경우의 fallback으로만 직접 수행):

1. **클래스 구조 분석** (Serena 도구 활용)
   - `mcp__serena__get_symbols_overview` 사용
   - **상속/구현 관계**: extends, implements 분석
   - **클래스 목적**: 클래스 수준 주석에서 역할 추출
   - **중요 상수**: 비즈니스 로직에 사용되는 핵심 상수 식별
   - **멤버 변수**: 상태 저장 변수 분석

2. **핵심 메소드 심층 분석** (Serena 도구 활용)
   - `mcp__serena__find_symbol` 사용
   - **doMainActivity()**: 메인 실행 흐름 상세 분석 (필수)
     - 실행 단계별 로직 상세 기술
     - 각 단계에서 수행하는 구체적인 작업
   - **기타 메소드**: 비즈니스 로직에 핵심적인 모든 메소드
   - **errorCheck()**: 데이터 검증 규칙 상세 분석

3. **SQL 매핑 상세 추출** (Phase 3 연동)
   - **SQL 매핑 패턴**: `getProperty(M[XX]ConstantsIF.SELECT_SQL)` 등 모든 SQL 참조 추출
   - **상수 해석**: M[XX]ConstantsIF의 SQL 상수 정의와 실제 XML 키 매핑 분석
   - **동적 SQL 분석**: setNamedParameter, DAO 메서드 호출 등 동적 SQL 구성 패턴 분석
   - **사용 빈도**: 각 SQL 매핑의 사용 횟수 및 위치 추적
   - **메타데이터 구성**: structure.json의 sqlQueries 배열에 통합할 메타데이터 생성

4. **비즈니스 로직 상세 추출**
   - **수학적 공식**: 모든 계산 로직을 정확한 수식으로 상세히 표현
   - **조건 분기**: 모든 if/else, switch문의 분기 조건과 처리 로직
   - **반복문 패턴**: for/while문의 데이터 처리 방식 상세 기술
   - **데이터 흐름**: 입력→처리→출력의 구체적인 변환 과정
   - **복잡도 평가**: 낮음/중간/높음/매우 높음 (구체적인 사유 기술)

**📋 SQL 매핑 추출 가이드**:

```java
// 1. getProperty() 호출 패턴 식별
String sqlKey = getProperty(M[XX]ConstantsIF.SELECT_SQL2);  // line 121
String sqlKey = getProperty(M[XX]ConstantsIF.INSERT_SQL);   // line 170

// 2. setNamedParameter()와 결합된 SQL 사용 패턴
setNamedParameter("SQL_KEY", getProperty(M[XX]ConstantsIF.SELECT_SQL3));

// 3. DAO 메서드와 SQL 키 조합 패턴
dao.find(getProperty(M[XX]ConstantsIF.UPDATE_SQL), params);
```

**상수 해석 프로세스**:
1. M[XX]ConstantsIF 분석: SELECT_SQL2 → "select-sql2" 매핑 확인
2. 서비스 ID 조합: "M473020030" + "select-sql2" → "M473020030.select-sql2"
3. XML과 대조: structure.json의 sqlQueries 배열에 존재하는지 확인
4. 메타데이터 생성: 출처(JAVA), 사용 위치, 빈도 등

5. **예외 처리 상세 분석**
   - **모든 PosException**: 발생 조건, 에러 메시지, 처리 방법
   - **데이터 검증**: null 체크, 유효성 검증의 구체적인 로직
   - **에러 복구**: 각 예외 상황에서의 대응 전략

6. **의존성 및 데이터 구조**
   - **프레임워크 사용**: PosContext, PosRowSet, PosGenericDao 등의 활용 방식
   - **데이터 변환**: Map, List, BigDecimal의 구체적인 사용 패턴
   - **외부 연동**: 다른 클래스/메소드 호출의 목적과 역할

### Step 3.5: SQL 매핑 통합 (Phase 3 연동)

**실행 방법**:
```bash
python ./docs/common/tools/sql_mapping_integration.py [SERVICE-ID] [PROCESS-CODE] . ./docs/analysis/service/[ui|nui]
```

**자동 통합 프로세스**:
- M[XX]ConstantsIF 상수 정의 파싱 (동적 검색)
- Java 클래스에서 SQL 매핑 패턴 추출
- 상수명 → 실제 SQL 키 변환
- structure.json sqlQueries 배열에 통합
- 중복 제거 및 메타데이터 생성

### Step 4: java_analysis.json 생성
**출력 위치**: `./docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_java_analysis.json`

### Step 4.5: SQL 매핑 자동 통합 (structure.json 업데이트)

```bash
python ./docs/common/tools/sql_mapping_integration.py [SERVICE-ID] [PROCESS-CODE] . ./docs/analysis/service/[ui|nui]
```

**업데이트 내용**:
1. structure.dataFlow.javaSqlQueries 배열 확장
2. Custom Activity별 SQL 매핑 정보 추가
3. lastUpdated 타임스탬프 갱신

**JSON 스키마**:
```json
{
  "classes": {
    "[ClassName]": {
      "purpose": "[클래스의 비즈니스적 목적]",
      "complexity": "[낮음/중간/높음/매우 높음]",
      "filePath": "./src/...",
      "classStructure": {
        "extends": "[상위 클래스명]",
        "implements": ["[인터페이스 목록]"],
        "imports": ["[핵심 import 목록]"],
        "constants": ["[중요 상수 목록]"],
        "memberVariables": ["[멤버 변수 목록]"]
      },
      "classDocumentation": {
        "description": "[클래스 수준 주석 내용]",
        "author": "[작성자]",
        "version": "[버전]",
        "createdDate": "[생성일자]"
      },
      "mainLogic": {
        "method": "[진입점 메소드명]",
        "description": "[메인 로직 설명]",
        "inputType": "[입력 타입]",
        "outputType": "[출력 타입]",
        "steps": ["[실행 단계별 상세 설명]"]
      },
      "keyMethods": [
        {
          "name": "[메소드명]",
          "purpose": "[메소드 목적]",
          "complexity": "[복잡도]",
          "parameters": ["[파라미터 목록]"],
          "returnType": "[반환 타입]",
          "businessLogic": {
            "algorithms": ["[핵심 알고리즘 목록]"],
            "dataStructures": ["[사용 데이터 구조]"],
            "specialCases": ["[특수 처리 케이스]"]
          }
        }
      ],
      "businessRules": [
        {
          "ruleId": "[규칙 ID]",
          "name": "[규칙명]",
          "condition": "[적용 조건]",
          "logic": "[처리 로직]",
          "validation": "[검증 규칙]",
          "exception": "[예외 처리]"
        }
      ],
      "sqlMappings": {
        "extractedPatterns": [
          {"pattern": "[SQL 참조 패턴]", "constantName": "[상수명]", "line": "[라인번호]", "context": "[사용 맥락]"}
        ],
        "constantsResolved": [
          {"constantName": "[상수명]", "resolvedKey": "[실제 SQL 키]", "source": "[M[XX]ConstantsIF 등]", "confidence": "[신뢰도 레벨]"}
        ],
        "dynamicSqlPatterns": [
          {"pattern": "[동적 SQL 구성 패턴]", "method": "[사용 메소드]", "parameters": ["[파라미터 목록]"]}
        ],
        "usageFrequency": [
          {"sqlKey": "[SQL 키]", "usageCount": "[사용 횟수]", "locations": [{"method": "[메소드명]", "line": "[라인번호]", "pattern": "[사용 패턴]"}]}
        ]
      },
      "dataFlow": {
        "input": {"source": "[입력 소스]", "data": ["[입력 데이터 목록]"]},
        "processing": [{"step": "[처리 단계명]", "method": "[사용 메소드]", "output": "[출력 결과]"}],
        "output": {"targets": ["[출력 대상 목록]"], "method": "[출력 메소드]"}
      },
      "dependencies": {
        "framework": ["[프레임워크 의존성 목록]"],
        "business": ["[비즈니스 의존성 목록]"],
        "dataStructures": ["[데이터 구조 의존성 목록]"]
      },
      "exceptionHandling": {
        "checkedExceptions": ["[체크 예외 목록]"],
        "errorCases": [{"case": "[에러 케이스명]", "message": "[에러 메시지]", "action": "[처리 방법]"}]
      },
      "complexityFactors": ["[복잡도 요인 목록]"]
    }
  }
}
```

## 복잡도 평가
- **낮음**: getter/setter, 파라미터 변환
- **중간**: 조건 분기 2-3개, 단순 반복문
- **높음**: 계산 로직, 중첩 반복문, 다중 예외 처리

## 주의사항

### MANDATORY EXECUTION RULES (절대 위반 금지)

1. **Pre-Validation 우선**: structure.json 로드 즉시 `validateCustomActivities()` 함수 실행. validation 통과하지 않으면 절대로 다음 단계 진행 금지
2. **단일 기준 사용**: customActivities 배열만 최종 기준 (activities.type 속성 무시)
3. **조기 종료 강제**: customActivities가 []/undefined/null이면 즉시 TERMINATE
4. **불일치 기준 금지**: activities.type='custom'과 customActivities 배열 혼용 금지
5. **임의적 판단 금지**: Agent가 규칙을 임의로 해석하거나 우회하는 것 엄격 금지
6. **분석 범위 제한**: customActivities에 포함된 activity만 분석, type='built-in'/'common' 절대 금지
7. **장단점/개선점 제안 금지**: 현재 제공된 내용에 대해서만 분석

## 에러 처리

### 즉시 종료 조건 (Early Termination)
- **Serena MCP 없음** → 즉시 종료
- **structure.json 없음** → 즉시 종료
- **customActivities 빈 배열/undefined/null** → 빈 JSON {} 생성 후 조기 종료 (정상 처리)

### 일반 에러 처리
- **Java 파일 없음** → 경로 확인 후 스킵
- **파싱 오류** → 에러 로그 후 다음 클래스 진행
- **심볼 분석 실패** → fallback으로 파일 읽기 시도
