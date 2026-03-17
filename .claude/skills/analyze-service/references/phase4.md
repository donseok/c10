# Phase 4 - UI 컴포넌트 분석

레거시 시스템 분석의 네 번째 단계로, JSP 화면과 Form/Grid XML을 분석하여 UI 구조와 인터랙션을 추출합니다.

## MANDATORY EARLY TERMINATION RULE

**IF NO JSP FILE FOUND for the service:**
1. Create empty JSON with hasUI: false
2. STOP ALL UI ANALYSIS
3. DO NOT search for XML components
4. DO NOT parse Form/Grid files
5. TERMINATE immediately

## 실행 알고리즘

### Step 1: structure.json 및 작업파일 확인

1. **structure.json 경로 확인**: `mcp__serena__find_file` 사용
   - 파일 검색: `[SERVICE-ID]_structure.json`
   - 존재 하지 않으면 메시지 출력 후 종료

2. **ui_analysis.json**: `mcp__serena__find_file` 사용
   - **파일 검색**: `[SERVICE-ID]_ui_analysis.json`
   - 재작업 방지 위해 파일이 존재하면 종료하여 다음 Step 진행

### Step 2: JSP 파일 존재 여부 확인

#### 2-1. JSP 파일 검색
- 파일 검색: `./WebContents/[SERVICE-ID].jsp`
- ❌ 검색 실패 시 연관 검색 또는 다른 폴더 검색 금지

#### 2-2. **JSP 파일 없을 경우 즉시 조기 종료**
1. **빈 JSON 문서 생성**:
   - 출력 위치: `./docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_ui_analysis.json`
   ```json
   {
     "serviceInfo": {
       "serviceId": "string",
       "serviceName": "string",
       "processCode": "string",
       "analysisDate": "date",
       "analysisModel": "sonnet",
       "serviceType": "batch"
     },
     "hasUI": false,
     "uiAnalysis": {
       "uiComponents": []
     }
   }
   ```

2. **즉시 종료**: XML 컴포넌트 파일 검색 금지, Form/Grid 파일 분석 금지

#### 2-3. JSP 파일 있을 경우에만 진행

### Step 3: JSP 파일 분석
1. **JSP 파일 읽기** - Serena MCP 사용 할 것

2. **initLayout 분석**
   - JavaScript 코드에서 `initLayout` 오브젝트 추출
   - Layout 구조 파싱

3. **Layout 구조 분석**
   ```javascript
   var initLayout = {
     programId:"M472010020",
     itemType: "layout",
     id: "mainLayout",
     dirType: "row",  // row(세로 배치), col(가로 배치), tab(탭 배치)
     childSize: "80,*,20",  // 하위 컴포넌트 크기 (px, %, *)
     splitter: true,  // 사이즈 조정 가능 여부
     components: [...]  // 하위 컴포넌트 배열
   };
   ```
   **dirType**
   - **row**: 하위 컴포넌트를 세로로 배치 (위→아래)
   - **col**: 하위 컴포넌트를 가로로 배치 (좌→우)
   - **tab**: 탭바에 배치

   **childSize**
   - 하위 컴포넌트 크기 지정 (콤마로 구분)
   - 단위 없으면 px, %는 전체 크기 대비
   - `*`: 나머지 전체 공간(생략 가능)
   - 예: `"55,105,20%,,104"` → 5개 컴포넌트: 55px, 105px, 20%, 나머지 전체, 104px

   **splitter**
   - `true`: 하위 컴포넌트 사이즈 조정 가능 (드래그)
   - `false`: 고정 크기

4. **컴포넌트 타입 분류**
   - **layout**: 하위 레이아웃 (재귀적 구조)
   - **grid**: 그리드 컴포넌트 (데이터 테이블)
   - **form**: 폼 컴포넌트 (입력 필드)
   - **menu**: 메뉴 컴포넌트
   - **tabbar**: 탭바 컴포넌트
   - **htmlObj**: HTML 요소 삽입
   - **messagebox**: 상태바

5. **이벤트 핸들러 추출**
   - JavaScript 함수 목록 추출
   - 버튼 클릭, 데이터 변경 등 이벤트 핸들러
   - Service 호출 패턴 파악

6. **컴포넌트 파일 읽기**
   - 검색 패턴 : `./WebContents/header/kr/[SERVICE-ID]/[SERVICE-ID]_*.xml`
   - ❌ 검색 실패 시 연관 검색 또는 다른 폴더 검색 금지
   - 컴포넌트 파일
      - **Form**: `[SERVICE-ID]_Form_*.xml` (입력 폼 정의)
      - **Grid**: `[SERVICE-ID]_Grid_*.xml` (데이터 그리드 정의)
      - **Tabbar**: `[SERVICE-ID]_Tabbar_*.xml` (탭바 구조)
      - **Menu**: `[SERVICE-ID]_Menu_*.xml` (메뉴 정의)
      - **기타**: `[SERVICE-ID]_*.xml` (그 외 모든 UI 정의 파일)

### Step 4: Form XML 분석
**각 Form 파일별 분석**:
1. **파일 읽기** - Serena MCP 사용 할 것

2. **Form 필드 추출**
   - 필드 ID, 타입 (text, calendar, combo 등)
   - 필드 라벨 (label)
   - 필드 속성 (required, readonly 등)

3. **Form 레이아웃**
   - 필드 배치 정보
   - 그룹핑 정보

### Step 5: Grid XML 분석
**각 Grid 파일별 분석**:

1. **파일 읽기** - Serena MCP 사용 할 것

2. **Grid 컬럼 추출**
   - 컬럼 ID, 헤더명
   - 컬럼 타입 (text, number, combo 등)
   - 컬럼 너비, 정렬
   - 편집 가능 여부 (editable)

3. **Grid 속성**
   - 고정 컬럼 (split)
   - 정렬 가능 여부
   - 체크박스 컬럼
   - 집계 행 (summary)

### Step 6: 나머지 컴포넌트 읽기
1. **파일 읽기** - Serena MCP 사용 할 것

2. **Tabbar 분석**: Tab ID, Tab 명, Tab href
3. **Menu 분석**: Item ID (JSP의 함수명과 연결됨), Text(메뉴명)
4. **기타 분석**

### Step 7: ui_analysis.json 생성
**출력 위치**: `./docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_ui_analysis.json`

**JSON 스키마**:
```json
{
  "analysisModel": "sonnet",
  "layout": {
    "type": "layout",
    "dirType": "row",
    "totalHeight": "800px",
    "totalWidth": "100%",
    "components": [
      {
        "id": "formSearch",
        "type": "form",
        "height": "80px",
        "fields": [
          {"id": "inDateFrom", "type": "calendar", "label": "입고일자(시작)"},
          {"id": "inDateTo", "type": "calendar", "label": "입고일자(종료)"}
        ],
        "buttons": [
          {"id": "btnSearch", "label": "조회", "event": "onSearch"}
        ]
      },
      {
        "id": "gridResult",
        "type": "grid",
        "height": "600px",
        "editable": true,
        "split": 3,
        "columns": [
          {"id": "COIL_ID", "width": "120", "header": "코일ID", "editable": false},
          {"id": "COIL_WGT", "width": "100", "header": "코일중량", "type": "number"},
          {"id": "AW_WGT", "width": "100", "header": "배분중량", "type": "number", "editable": true}
        ]
      }
    ]
  },
  "events": [
    {
      "handler": "onSearch",
      "trigger": "btnSearch.click",
      "flow": [
        "1. 입력값 검증",
        "2. Service 호출 (초기화 → 조회)",
        "3. Grid 데이터 바인딩"
      ]
    }
  ]
}
```


## 주의사항
- **최우선**: JSP 파일 존재 여부 먼저 확인 - 없으면 즉시 조기 종료
- 해당 jsp 파일이 없을 수 있음 (백엔드 서비스의 경우)
- 메모리 최적화: 한 번에 한 컴포넌트씩만 적재
- Layout 재귀 구조: 하위 Layout 포함 가능

## 에러 처리
- structure.json 없음 → 즉시 종료
- JSP 파일 없음 → 빈 JSON 생성 후 조기 종료 (정상 처리)
- XML 파싱 오류 → 에러 로그 후 다음 파일 진행
