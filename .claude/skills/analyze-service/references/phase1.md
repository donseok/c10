# Phase 1 - 구조 파악 및 파일 수집

레거시 시스템 분석의 첫 번째 단계로, Service XML을 파싱하여 전체 구조를 파악하고 관련 파일 경로를 수집합니다.

## 실행 방법

Phase 1은 JavaScript 스크립트를 자동 실행합니다:

```bash
node .claude/skills/analyze-service/scripts/phase1-analyzer.js [SERVICE-ID] .
```

스크립트가 자동으로 다음을 수행합니다:
1. 프로젝트 루트 경로를 `.`로 설정
2. 프로세스 코드 추출
3. Service XML 파싱 및 structure.json 생성

## 실행 알고리즘 (스크립트 실패 시 수동 fallback)

### Step 1: 파일 경로 설정
1. **프로젝트 루트 폴더 파악**
   - 프로젝트 루트: `./` (src/, WebContents/가 프로젝트 루트에 직접 존재)

2. **structure.json(Serena MCP 사용)** : `mcp__serena__find_file`
   - **파일 위치**: `./docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_structure.json`
   - **ui/nui 판정**: SERVICE-ID가 `M`으로 시작하면 `ui`, `B`로 시작하면 `nui`
   - 재작업 방지 위해 파일이 존재하면 종료하여 다음 Step 진행

3. **Service XML 경로 설정** : `mcp__serena__find_file` 사용
   - 경로: `./src/service/[SERVICE-ID]-service.xml`
   - 파일 존재 확인 (없으면 종료)

### Step 2: Service XML 파싱
1. **Service XML 읽기(`mcp__serena__find_file` 사용)**
   - Service XML 파일 읽기
   - XML 구조 파싱

2. **Activity 목록 추출**
   - 각 activity의 name, class 추출
   - Activity 타입 분류(common/custom/framework 으로만 표현):

     **판단 로직:**
     ```
     If class에 ".common."이 포함되면
       → type: "common"
     Else If class에 "com.unionsteel.mes"로 시작하면
       → type: "custom"
     Else
       → type: "framework"
     End If
     ```

     **예시:**
     - `com.poscoict.glue.activity.InitActivity` → ".common." 미포함, "com.unionsteel.mes" 미포함 → **framework**
     - `com.unionsteel.mes.m47.activity.nui.M47DefectJudgementReceiveRun` → ".common." 미포함, "com.unionsteel.mes" 포함 → **custom**

3. **Property 정보 추출**
   - sqlkey, bind-result, resultkey 매핑
   - 각 activity별 property 수집
   - SQL 쿼리 키와 메타데이터 추출

4. **SQL 쿼리 키 추출 (확장)**
   - **전통적 sqlkey**: Property의 `sqlkey` 속성에서 SQL 키 추출
   - **DAO 기반 SQL 프로퍼티**: `dao` 속성이 있는 Activity에서 아래 프로퍼티의 값도 SQL 키로 수집
     - `update-sql`, `insert-sql`, `delete-sql`, `select-sql` 등 키 이름에 SQL 키워드(`select`, `insert`, `update`, `delete`, `sql`)가 포함된 모든 프로퍼티
   - 중복 제거 및 정렬하여 배열 형태로 저장
   - `dataFlow.sqlQueries`에 전통적 sqlkey + DAO 기반 SQL 프로퍼티 값 모두 포함
   - `dataFlow.potentialSqlQueries`에 DAO 기반 SQL 프로퍼티의 상세 정보 별도 저장 (activityName, propertyKey, sqlKey, source)
   - XML 기반 SQL만 저장 (Java는 Phase 2에서 별도 처리)

### Step 3: structure.json 생성
- **중요 내용**: JSON 스키마 철저히 지킬 것
- **출력 위치**: `./docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_structure.json`

**JSON 스키마**:
```json
{
  "serviceId": "M473020030",
  "serviceName": "[Service XML의 name 속성 또는 추론]",
  "process": "[프로세스 코드: SERVICE-ID 앞 3자 소문자]",
  "serviceType": "ui",
  "serviceXmlPath": "./src/service/M473020030-service.xml",
  "activities": [
    {
      "name": "초기화",
      "class": "com.poscoict.glue.activity.InitActivity",
      "type": "common",
      "properties": []
    },
    {
      "name": "배분중량계산",
      "class": "com.unionsteel.mes.m47.activity.nui.M47DefectJudgementReceiveRun",
      "type": "custom",
      "properties": [
        {"sqlkey": "m47.M473020030.selectCoilList", "resultkey": "coilGrid"}
      ]
    }
  ],
  "custom_activities": [
   "./src/com/unionsteel/mes/m47/activity/nui/M47DefectJudgementReceiveRun.java"
  ],
  "serviceStructure": {
    "customActivities": [
      {
        "name": "생산실적등록",
        "className": "com.unionsteel.mes.m47.activity.nui.M47DefectJudgementReceiveRun",
        "filePath": "./src/com/unionsteel/mes/m47/activity/nui/M47DefectJudgementReceiveRun.java"
      }
    ]
  },
  "dataFlow": {
    "sqlQueries": [
      "M473020030.selectCoilList"
    ],
    "javaSqlQueries": [],
    "lastUpdated": "[생성일자]"
  }
}
```

### Step 4: structure.json 확인
- **중요 내용**: JSON 스키마 준수했는지 검사
- **activities** 안의 클래스 type 키가 있는지 확인(무조건 있어야 함)

## 에러 처리
- Service XML 없음 → 즉시 종료
- XML 파싱 오류 → 구조 확인 후 종료
- 디렉토리 생성 실패 → 권한 확인
- `.temp/` 디렉토리 없으면 자동 생성
