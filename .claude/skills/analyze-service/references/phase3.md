# Phase 3 - SQL 쿼리 분석

레거시 시스템 분석의 세 번째 단계로, SQL 쿼리를 분석하여 데이터베이스 스키마와 데이터 흐름을 추출합니다.

## MANDATORY EARLY TERMINATION RULE

**IF NO SQL KEYS FOUND after comprehensive search:**
1. Create empty JSON with serviceInfo only
2. STOP ALL SQL ANALYSIS
3. DO NOT search for SQL files
4. DO NOT parse individual queries
5. TERMINATE immediately

## 실행 알고리즘

### Step 1: structure.json 로드

1. **파일 경로 확인**: `mcp__serena__find_file` 사용
   - 파일 검색: `[SERVICE-ID]_structure.json`
   - 존재 하지 않으면 메시지 출력 후 종료

2. **sql_analysis.json** 파일 유무 확인(재작업 방지)
   - **파일 위치**: `[SERVICE-ID]_sql_analysis.json`
   - 파일이 존재하면 종료하여 다음 Step 진행

### Step 2: 통합 SQL Key 검색 (Phase 2 연동)

#### 2-1. 통합 SQL Key 검색 (세 소스 합치기)
1. **XML SQL 키 추출** (sqlQueries 배열)
   - `dataFlow.sqlQueries` 배열에서 XML 기반 SQL 키 추출
   - Phase 1 스크립트가 `sqlkey` 프로퍼티 + DAO 기반 SQL 프로퍼티(`update-sql`, `insert-sql`, `delete-sql`, `select-sql` 등)를 모두 포함하여 생성

2. **Java SQL 키 추출** (javaSqlQueries 배열)
   - `dataFlow.javaSqlQueries` 배열에서 Java 기반 SQL 키 추출

3. **DAO 기반 SQL 프로퍼티 추출** (potentialSqlQueries 배열 — fallback)
   - `dataFlow.potentialSqlQueries` 배열의 각 항목에서 `sqlKey` 값 추출
   - 이 배열에는 `update-sql`, `insert-sql`, `delete-sql`, `select-sql` 등 DAO Activity의 SQL 프로퍼티가 상세 정보(activityName, propertyKey, sqlKey, source)와 함께 저장됨
   - `sqlQueries`에 이미 포함된 경우가 대부분이나, 누락 방지를 위한 fallback

4. **명시적 sqlkey 검색** (기존 방식 호환)
   - structure.json 내 `activities` 배열의 `properties` 내 `sqlkey` 프로퍼티
   - **추가**: `dao` 프로퍼티가 있는 Activity의 `update-sql`, `insert-sql`, `delete-sql`, `select-sql` 등 SQL 키워드가 포함된 프로퍼티 값도 수집

5. **최종 SQL Key 확정**
   - XML + Java + potentialSql 키 합치기
   - 중복 제거 (set 연산)

```javascript
const xmlSqlKeys = structure.dataFlow.sqlQueries || [];
const javaSqlKeys = structure.dataFlow.javaSqlQueries || [];
const potentialSqlKeys = (structure.dataFlow.potentialSqlQueries || []).map(item => item.sqlKey);

if (javaSqlKeys.length === 0) {
  console.warn("⚠️ javaSqlQueries 배열이 비어있습니다. Phase 2 결과 확인 필요.");
  console.warn("💡 권장 조치: analyze-service 스킬에서 Phase 2 재실행");
  console.warn("🔧 수동 조치: python ./docs/common/tools/sql_mapping_integration.py [SERVICE-ID] [PROCESS-CODE] . ./docs/analysis/service/[ui|nui]");
}

const allSqlKeys = [...new Set([...xmlSqlKeys, ...javaSqlKeys, ...potentialSqlKeys])];
console.log(`✅ XML SQL: ${xmlSqlKeys.length}개, Java SQL: ${javaSqlKeys.length}개, Potential SQL: ${potentialSqlKeys.length}개, 통합: ${allSqlKeys.length}개`);
```

#### 2-2. 출처별 SQL 매핑 분석
```javascript
const integratedSqlMappings = {
  "M473020030.selectObj": {
    "queryKey": "M473020030.selectObj",
    "sources": ["XML", "Java"],
    "usageCount": 3,
    "locations": [
      {"file": "M473020030-service.xml", "activity": "이송대상 등록", "sourceType": "XML"},
      {"file": "TrfObjRgs.java", "line": 155, "method": "doMainActivity", "sourceType": "Java", "package": "com.unionsteel.mes.m47.activity.ui"}
    ]
  }
}
```

#### 2-3. **SQL Key 없을 경우 즉시 조기 종료**

1. **빈 JSON 문서 생성**:
   - 출력 위치: `./docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_sql_analysis.json`
   ```json
   {
     "serviceInfo": {
       "serviceId": "string",
       "serviceName": "string",
       "processCode": "string",
       "analysisDate": "date"
     },
     "hasQuery": false,
     "sqlAnalysis": {
       "totalQueries": 0,
       "queryDetails": [],
       "hasQueries": false
     }
   }
   ```

2. **즉시 종료**: SQL 파일 검색 금지, 개별 쿼리 분석 금지, 테이블 스키마 추론 금지

### Step 2.5~3: 쿼리 캐시 기반 SQL 분석

> **query-cache CLI 사용법**: `docs/common/tools/query-cache/README.md` 참조
> **분석 스키마**: `.claude/skills/analyze-queries/references/analysis-schema.md` 참조

analyze-queries 스킬의 orchestrator를 사용하여 쿼리 원문 조회 및 분석 결과 캐싱을 수행합니다.
쿼리 개수에 무관하게 **총 3회 CLI 호출**로 처리합니다 (sync + fetch-queries + save-queries).

```
ORCHESTRATOR=.claude/skills/analyze-queries/scripts/orchestrator.py
```

#### Step 2.5: 쿼리 캐시 동기화 (1회)
```bash
python3 docs/common/tools/query-cache/query_cache.py sync
```

#### Step 3-1: 쿼리 원문 + 분석 캐시 일괄 조회 (1회)
```bash
python3 $ORCHESTRATOR fetch-queries key1 key2 key3 ...
```
출력 JSON의 `queries` 내 각 항목에서:
- `cachedAnalysis`가 **NOT NULL** → **cached** (기존 분석 결과 그대로 사용)
- `cachedAnalysis`가 **NULL** → **missed** (Step 3-2에서 새로 분석)

`summary`의 `cached`/`missed` 수치로 빠르게 확인 가능.

**중요**: cached 항목의 `cachedAnalysis` 값을 보관해 둔다. Step 4/6에서 missed 분석 결과와 합쳐서 사용한다.

#### Step 3-2: missed 쿼리만 분석 수행 (Claude 내부)
missed 목록의 쿼리만 새로 분석한다. cached 쿼리는 재분석하지 않는다.
분석 스키마는 `.claude/skills/analyze-queries/references/analysis-schema.md`를 준수한다.

1. **쿼리 타입 분류**: SELECT/INSERT/UPDATE/DELETE/MERGE
2. **테이블 추출**: FROM 절 파싱, 테이블명 및 Alias 추출, 테이블 역할 추론
3. **컬럼 분석**: SELECT 절 컬럼 추출, WHERE 절 조건 컬럼 추출, 주요 컬럼 타입 추론
4. **JOIN 관계 분석**: INNER/LEFT/RIGHT/FULL JOIN, JOIN 조건 추출, 테이블 간 관계 파악
5. **파라미터 분석**: 바인드 변수 추출 (`:paramName`, `#paramName#` 등), 필수/선택 분류, 용도 추론
6. **결과 컬럼 분석**: SELECT 절 반환 컬럼, 컬럼 별칭 (AS), 집계 함수 (SUM, COUNT, AVG 등)

#### Step 3-3: missed 분석 결과 일괄 저장 (1회)
missed 쿼리의 분석 결과만 캐시에 저장한다 (cached 항목은 이미 DB에 있으므로 저장 불필요).
```bash
echo '{"missed_key1": {...분석결과...}, "missed_key2": {...분석결과...}}' | python3 $ORCHESTRATOR save-queries
```

#### Step 3-4: cached + missed 결과 통합
Step 4/6의 sql_analysis.json 생성 시 **cached 분석 결과 + missed 분석 결과를 모두 합쳐서** `queryDetails` 배열에 포함한다. cached 결과를 누락하지 않는다.

### Step 4: 데이터베이스 스키마 추론
1. **테이블 목록 생성**: 모든 SQL에서 사용된 테이블 수집, 테이블별 역할 및 설명 추론
2. **컬럼 정보 수집**: 각 테이블별 컬럼 목록, 컬럼 타입 추론, Primary Key 추론
3. **ER 관계도 구성**: JOIN 조건 기반 관계 추출, 1:N/N:1/N:M 관계 분류, 외래키 관계 추론

### Step 5: PL/SQL 호출 감지 및 추가 분석

#### 5-1. PL/SQL 호출 패턴 감지

SQL 쿼리 분석(Step 3) 및 glue_sql 파일 전체에서 PL/SQL 프로시저/패키지 호출 패턴을 검색합니다.

**감지 대상 패턴**:
```sql
CALL package_name.procedure_name(param1, param2);
BEGIN package_name.procedure_name(param1, param2); END;
EXECUTE procedure_name(param1, param2);
{call package_name.procedure_name(?, ?)}
{? = call function_name(?)}
SELECT package_name.function_name(param) FROM DUAL;
```

**감지 로직**:
```javascript
const callPatterns = [
  /CALL\s+([A-Z_][A-Z0-9_]*(?:\.[A-Z_][A-Z0-9_]*)?)[\s(]/gi,
  /BEGIN\s+[\s\S]*?([A-Z_][A-Z0-9_]*\.[A-Z_][A-Z0-9_]*)\s*\(/gi,
  /EXECUTE\s+([A-Z_][A-Z0-9_]*(?:\.[A-Z_][A-Z0-9_]*)?)[\s(]/gi,
  /\{(?:\?\s*=\s*)?call\s+([A-Z_][A-Z0-9_]*(?:\.[A-Z_][A-Z0-9_]*)?)[\s(]/gi,
];
```

#### 5-2. 감지된 PL/SQL 오브젝트 분류

```javascript
// 패키지.프로시저 형태 → PACKAGE_MEMBER
// 독립 프로시저/함수 → STANDALONE
plsqlCalls.forEach(callName => {
  if (callName.includes('.')) {
    const [packageName, procName] = callName.split('.');
    detectedObjects.push({objectName: packageName, procedureName: procName, callType: 'PACKAGE_MEMBER', fullCall: callName});
  } else {
    detectedObjects.push({objectName: callName, procedureName: null, callType: 'STANDALONE', fullCall: callName});
  }
});
```

#### 5-3. 기존 분석 보고서 확인 (중복 방지)

```javascript
// docs/analysis/dbms/ 하위 전체에서 [OBJECT_NAME]_analysis_report.md 검색
for (const obj of uniqueObjects) {
  const existingReport = await findFile(obj.objectName + '_analysis_report.md');
  if (existingReport) {
    obj.reportPath = existingReport;
    obj.analyzed = true;
    console.log(`⏭️ 이미 분석됨 (스킵): ${obj.objectName}`);
  } else {
    pendingAnalysis.push(obj);
  }
}
```

#### 5-4. /analyze-plsql 자동 서브에이전트 호출

**사용자 확인 없이 자동 실행**:

```javascript
if (pendingAnalysis.length > 0) {
  for (const obj of pendingAnalysis) {
    await Task({
      description: `PL/SQL 분석 ${obj.objectName}`,
      subagent_type: "oracle-sql-analyzer",
      prompt: `/analyze-plsql ${obj.objectName}\n\n` +
        `SQL 쿼리 분석 중 감지된 PL/SQL 오브젝트입니다.\n` +
        `호출 형태: ${obj.fullCall}\n호출 타입: ${obj.callType}\n` +
        `analyze-plsql 스킬 파일: .claude/skills/analyze-plsql/SKILL.md 를 먼저 읽고 지침에 따라 수행해주세요.`
    });
  }
}
```

#### 5-5. PL/SQL 호출 정보를 sql_analysis.json에 기록

**보고서 경로 결정 규칙**:
```javascript
function getReportPath(objectName, objectType, schemaName) {
  var subDir;
  if (objectType === 'PACKAGE') subDir = 'package';
  else if (objectType === 'PROCEDURE') subDir = 'storedProcedure';
  else if (objectType === 'FUNCTION') subDir = 'function';
  return 'docs/analysis/dbms/' + schemaName + '/' + subDir + '/' + objectName + '_analysis_report.md';
}
```

### Step 6: sql_analysis.json 생성
**(중요)출력 위치**: `./docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_sql_analysis.json`

**JSON 스키마**:
```json
{
  "serviceInfo": {
    "serviceId": "string",
    "serviceName": "string",
    "processCode": "string",
    "analysisDate": "date",
    "numberOfQuery":"number"
  },
  "sqlAnalysis": {
    "totalQueries": "number",
    "queryDetails": [
      {
        "queryId": "string",
        "description": "string",
        "queryType": "SELECT|INSERT|UPDATE|DELETE|MERGE",
        "sources": ["XML", "Java"],
        "isFromXml": "boolean",
        "isFromJava": "boolean",
        "parameters": [{"name": "string", "type": "string", "required": "boolean", "description": "string"}],
        "tables": [{"tableName": "string", "alias": "string", "role": "메인 테이블|참조 테이블|조인 테이블", "accessPattern": "string"}],
        "columns": [{"name": "string", "tableName": "string", "tableAlias": "string", "dataType": "string", "isPrimaryKey": "boolean", "isForeignKey": "boolean", "expression": "string"}],
        "joins": [{"type": "INNER|LEFT|RIGHT|FULL", "leftTable": "string", "rightTable": "string", "condition": "string"}],
        "businessPurpose": "string",
        "queryLogic": "string",
        "performanceInfo": {"hasIndex": "string", "queryComplexity": "Simple|Medium|Complex", "estimatedRows": "string"}
      }
    ],
    "tables": [
      {"tableName": "string", "tableDescription": "string", "role": "string", "accessPattern": "string",
       "columns": [{"name": "string", "dataType": "string", "isPrimaryKey": "boolean", "isForeignKey": "boolean", "description": "string"}]}
    ],
    "dataFlow": {
      "inputParameters": [{"name": "string", "source": "string", "description": "string"}],
      "outputData": [{"name": "string", "structure": "string", "destination": "string"}]
    },
    "businessRules": [{"rule": "string", "description": "string", "enforcement": "string"}]
  },
  "erDiagram": {
    "relationships": [{"from": "string", "to": "string", "type": "1:N|N:1|N:M", "joinKey": "string", "description": "string"}]
  },
  "plsqlCalls": {
    "totalDetected": "number",
    "totalAnalyzed": "number",
    "totalSkipped": "number",
    "detectedCalls": [
      {"objectName": "string", "procedureName": "string|null", "callType": "PACKAGE_MEMBER|STANDALONE", "fullCall": "string", "analyzed": "boolean", "reportPath": "string|null"}
    ]
  }
}
```

## 주의사항
- **최우선**: SQL Key 종합 검색 후 없으면 즉시 조기 종료
- structure.json 필수 (Phase 1 먼저 실행)
- GLUE 바인드 변수: `:변수명` 인식
- **PL/SQL 호출 감지**: CALL, BEGIN...END 블록, {call ...} 패턴, SELECT 내 패키지.함수() 호출이 감지되면 `/analyze-plsql`을 서브에이전트로 자동 호출
- **PL/SQL 분석 중복 방지**: `docs/analysis/dbms/` 하위에 이미 분석 보고서가 존재하면 스킵
- **PL/SQL 분석 자동 실행**: 사용자 확인 없이 감지된 미분석 오브젝트를 `oracle-sql-analyzer` 서브에이전트로 순차 자동 분석

## 에러 처리
- query-cache sync 실패/structure.json 없음 → 즉시 종료
- SQL Key 없음 → 빈 JSON 생성 후 조기 종료 (정상 처리)
- PL/SQL 오브젝트 DB 검색 실패 → 경고 로그 출력 후 스킵 (Phase 3 중단하지 않음)
- /analyze-plsql 실행 중 오류 → 경고 로그 출력 후 다음 오브젝트 진행
