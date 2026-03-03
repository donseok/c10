# Phase 5 - 통합 문서 생성

레거시 시스템 분석의 마지막 단계로, Phase 1-4의 모든 분석 결과를 통합하여 종합 마크다운 문서를 생성합니다.
최종 분석 문서의 양식을 정확하게 따라서 작성합니다.
❌ 현대화 방안 제언, 추가적인 개선 사항 작성을 금지합니다.

## 실행 알고리즘

### Step 1: 분석 결과 로드
**파일 존재 여부는  `mcp__serena__find_file` 사용할 것**

1. **Phase 1 결과 (structure.json)**: File: `[SERVICE-ID]_structure.json`
2. **Phase 2 결과 (java_analysis.json)**: File: `[SERVICE-ID]_java_analysis.json`
3. **Phase 3 결과 (sql_analysis.json)**: File: `[SERVICE-ID]_sql_analysis.json`
4. **Phase 4 결과 (ui_analysis.json)**: File: `[SERVICE-ID]_ui_analysis.json`

5. **커스텀 클래스 상세 분석 보고서 확인** (java_analysis.json의 customActivities 기반)
   - `java_analysis.json`에서 custom activity 클래스명 목록 추출
   - 각 클래스명에 대해 `docs/analysis/service/customClass/[ClassName]_class_analysis.md` 존재 여부 확인
   - **존재하는 경우**:
     - 보고서에서 비즈니스 로직을 정확히 추출하여 정리:
       - 각 메소드별 처리 로직 (조건 분기, 계산 공식, 데이터 변환 등)
       - 핵심 비즈니스 규칙 및 검증 로직
       - 메소드 간 호출 흐름 및 데이터 전달 구조
     - 헤더 메타 테이블에서: 라인 수, 메소드 수
     - 해당 클래스의 Java 컴포넌트 분석 섹션에 **비즈니스 로직 정리 + 상세 분석 링크** 삽입
     - 링크 경로: `../customClass/[ClassName]_class_analysis.md`
   - **미존재하는 경우**: Phase 2의 java_analysis.json 기반으로 기존 방식대로 분석 내용 작성

6. **서브서비스 분석 보고서 로드** (structure.json의 `subServices` 배열 기반)
   - structure.json에서 `subServices` 배열 확인
   - `subServices`가 비어있거나 없으면 서브서비스 섹션 생략 (`hasSubServices = false`)
   - 존재하면 각 서브서비스의 `[SUB-ID]_legacy_analysis.md` 존재 확인:
     - `mcp__serena__find_file`로 `docs/analysis/service/[ui|nui]/[SUB-ID]_legacy_analysis.md` 검색
     - 존재하면 보고서에서 비즈니스 로직을 정확히 추출하여 정리:
       - 헤더 메타 테이블에서: Activity 수, SQL Key 수
       - 서브서비스의 핵심 비즈니스 로직 정리
       - 주요 Activity별 수행 로직과 데이터 처리 내용
     - 미존재하면 "미분석" 표시7: Oven 폭발 한계 LineSpeed 조회
Actor: CCL 공정 오퍼레이터
목적: CCL BOM 기반 Oven 폭발 한계 LineSpeed를 계산하여 작업지시 조회 화면에 표시
주요 흐름:
한계 L/S 조회 여부 확인 (lsYn → BOM 존재 시 Y)
addBomInfo 쿼리로 CCL BOM 상세 정보 조회
M47OvenBomLsCal Activity에서 CclBomMap 생성 (업무기준 M47A0023/M47A0024 조회)
각 코일별 CCL_BOM_NO, COIL_WTH 기반 건조도막비중 및 한계LS 계산
단면/양면 코팅 구분, 모든 코타 중 최소값 적용
OVN_LIM_LN_SPD 컬럼에 결과 표시
UC-08: 스마트물류 (무인크레인) 제어
Actor: CCL 공정 오퍼레이터
목적: 무인크레인 기반 스마트물류 보급/이동 시 자동 위치 지정 및 권취방법 설정
주요 흐름:
스마트물류 적용 공정 확인 (업무기준 M80A1033)
무인/유인 라디오 선택, 권취방법(일반/UNDER) 설정
자동보급위치 조회 (AutoSplyLocOneRow)
운반기기 위치/번호 조회 및 PosContext 등록
무인위치제한 ON/OFF 업데이트 (TB_M80_ON_OFF_SET)
   - `hasSubServices = true`로 설정

### Step 2: 통합 문서 생성
**(중요)** 최종 분석 문서의 양식을 정확하게 따라야 한다.

**출력 위치**: `./docs/analysis/service/[ui|nui]/[SERVICE-ID]_legacy_analysis.md`
**문서 양식** : `.claude/skills/analyze-service/templates/legacy_analysis_report_template.md`

**동적 챕터 처리**:
- 템플릿의 `<!-- CONDITIONAL: [조건] -->` 주석을 기반으로 동적 챕터 생성
- `HAS_CUSTOM_ACTIVITIES_DATA` 조건: `java_analysis.json` 내 customActivities 배열에 데이터 존재
- `HAS_SQL_DATA` 조건: `sql_analysis.json` 파일 존재 및 내용 있을 때 표시
- `HAS_UI_DATA` 조건: `ui_analysis.json` 파일 존재 및 내용 있을 때 표시
- `HAS_SUB_SERVICES` 조건: `structure.json`의 `subServices` 배열이 비어있지 않을 때 표시

### Step 2.1: 조건부 챕터 처리 로직

1. **데이터 파일 검증**:
   ```javascript
   const hasCustomActivities = checkValueExists(javaAnalysis.customActivities) && isJsonNotEmpty(javaAnalysis.customActivities);
   const hasSqlData = checkFileExists(sqlAnalysisPath) && isJsonNotEmpty(sqlAnalysisPath);
   const hasUiData = checkFileExists(uiAnalysisPath) && isJsonNotEmpty(uiAnalysisPath);
   const hasSubServices = structureJson.subServices && structureJson.subServices.length > 0;
   ```

2. **템플릿 조건부 처리**:
   - `<!-- CONDITIONAL: HAS_CUSTOM_ACTIVITIES -->` 블록은 `hasCustomActivities`가 true일 때 포함
   - `<!-- CONDITIONAL: HAS_SQL_DATA -->` 블록은 `hasSqlData`가 true일 때 포함
   - `<!-- CONDITIONAL: HAS_UI_DATA -->` 블록은 `hasUiData`가 true일 때 포함
   - `<!-- CONDITIONAL: HAS_SUB_SERVICES -->` 블록은 `hasSubServices`가 true일 때 포함
   - `<!-- END_CONDITIONAL -->` 주석과 함께 영역을 정확히 닫음

3. **조건별 챕터 생성**:
   - **SQL 데이터 있음**: `## 💾 데이터 요구사항` 섹션 전체 포함
   - **SQL 데이터 없음**: 데이터 요구사항 섹션 전체 생략
   - **UI 데이터 있음**: `## 🖥️ 사용자 인터페이스 요구사항` 섹션 전체 포함
   - **UI 데이터 없음**: UI 요구사항 섹션 전체 생략
   - **서브서비스 있음**: `## 서브서비스` 섹션 포함 (요약 테이블 + 각 서브서비스별 2-3줄 설명 + 링크)
   - **서브서비스 없음**: 서브서비스 섹션 전체 생략

4. **서브서비스 링크 경로 규칙**:
   - 부모와 같은 타입(ui/nui): `./[SUB-ID]_legacy_analysis.md`
   - 부모와 다른 타입: `../nui/[SUB-ID]_legacy_analysis.md` 또는 `../ui/[SUB-ID]_legacy_analysis.md`

### Step 3: Mermaid 다이어그램 생성

#### ⚠️ 단순 서비스 판별 및 워크플로우 생략 규칙

서비스의 Activity 구조가 **단순 조회 위주**인 경우 워크플로우 다이어그램(핵심/상세 모두)을 **생략**한다.

**생략 조건** (아래 조건을 모두 충족 시):
- Custom Activity가 0개 (built-in Activity만 사용)
- 모든 Activity가 SELECT 쿼리 실행만 수행 (INSERT/UPDATE/DELETE/프로시저 호출 없음)
- Activity 체인이 Router → 단일 조회 Activity로만 구성

**생략 시 처리**: "핵심 워크플로우 다이어그램" 및 "상세 워크플로우 다이어그램" 섹션을 제거하고, "시스템 목적" 섹션에서 비즈니스 맥락을 충분히 기술한다.

**⚠️ 단, SQL에 특별한 계산/변환 로직이 포함된 경우**: 워크플로우 다이어그램은 생략하더라도 **"비즈니스 로직 상세" 섹션에 SQL 기반 비즈니스 로직을 반드시 기술**한다. SQL 기반 비즈니스 로직의 예:
- CASE WHEN / DECODE를 활용한 데이터 분류·변환 (예: 공정코드별 중량 PIVOT, 유통경로 내수/수출 분류)
- 수학적 계산 (적치일수 산출, 수율 계산, 배분비율 등)
- WITH(CTE) + UNION을 활용한 집계/소계 패턴
- 스칼라 서브쿼리를 통한 코드값→의미명 변환 규칙
- 복잡한 조건 필터링 (DECODE 패턴 기반 다조건 분기)

이러한 SQL 로직은 Java 없이도 핵심 비즈니스 규칙을 구현하고 있으므로, "비즈니스 로직 상세" 섹션에서 목적, 처리 케이스, 계산 공식 형태로 상세히 기술해야 한다.

#### 워크플로우 다이어그램 작성 (비단순 서비스)

1. **핵심 워크플로우 (Flowchart)** — 비즈니스 관점
   - **기술적 Activity 체인이 아닌, 비즈니스 프로세스 흐름**을 표현한다
   - 업무 담당자(오퍼레이터, 관리자)가 이해할 수 있는 업무 단위로 노드를 구성한다
   - 예시: "투입계획 조회 → 작업순서 변경 → 유효성 검증 → APS 계획시간 재산정 → 순서 확정"
   - UI 초기화, 콤보 로드, Grid 표시 등 기술적 단계는 포함하지 않는다
   - 분기는 비즈니스 판단 기준으로 표현 (예: "MO 내부 이동 / MO 간 이동")

2. **상세 워크플로우 (Flowchart)** — 비즈니스 로직 상세
   - 핵심 워크플로우의 각 단계를 비즈니스 규칙, 데이터 변환, 검증 로직 중심으로 상세 전개
   - 데이터 흐름(어떤 테이블에서 조회 → 어떤 계산/변환 → 어떤 테이블에 저장)을 포함
   - **⚠️ 단순 조회(find 계열) 묶음 규칙**: Router에서 분기하는 단순 조회 Activity(find로 시작하는 명령어 중 단일 Activity로 끝나는 것)는 개별 노드로 나열하지 않고, **하나의 subgraph로 묶어서** 표현한다.
     - **묶음 대상**: Router → 단일 Activity(조회 후 즉시 종료)인 find 명령어
     - **묶음 제외**: find 명령어라도 후속 Activity 체인이 있는 경우 개별 흐름으로 표현

3. **데이터 플로우 (Graph)**
   - Activity → SQL → Table 연결
   - 데이터 흐름 시각화

4. **공통 요구사항**
   - 대괄호([]) 사이의 문자열은 큰 따옴표("내용")로 감쌀 것
   - 예:  H["시간 설정 (등록시)"]

### Step 4: ER 다이어그램 생성

1. **ER 다이어그램**
   - **기본**: Mermaid erDiagram 코드블록으로 문서에 직접 포함 (SVG 파일 생성 안 함)
   - **SVG 생성은 사용자가 명시적으로 요청한 경우에만** 수행 (별도 SVG 파일 생성 + 이미지 링크)
   - 테이블 간 관계 표시 (1:N, N:1, N:M)
   - 각 테이블의 PK/FK 컬럼과 주요 비즈니스 컬럼을 erDiagram 내에 표기

### Step 5: 품질 검증 체크리스트

**⚠️ 날림 방지 — 상세도 기준 (반드시 준수)**:

1. **Grid 컬럼**: 모든 컬럼을 빠짐없이 나열하되, 각 컬럼에 `필드명: 타입 - 설명 (너비px, 정렬)` 포맷 적용. 숨김 컬럼도 `(숨김)` 표시하여 포함.
2. **Form 필드**: 모든 필드를 나열하고, 콤보/라디오/버튼 등 입력 유형과 연결 이벤트 명시.
3. **SQL 쿼리**: 단순 "조회" 한 줄로 끝내지 말 것. 각 쿼리의 목적, JOIN 관계, WHERE 조건의 비즈니스 의미, 바인드 변수를 상세히 기술.
4. **비즈니스 로직**: SQL에 DECODE/CASE WHEN/CTE 등 변환/집계 로직이 있으면 반드시 별도 케이스로 기술.
5. **화면 동작 흐름**: 최소 2개 이상의 시나리오로 분화 (초기 로딩, 조회, 화면 이동/팝업 등).
6. **JavaScript**: 실제 JSP/JS에서 확인한 함수만 나열. 프레임워크 함수명(uiCommon.parameters 등) 구체적 명시.
7. **특이사항**: 최소 3건. 코드에서 발견한 하드코딩, 안티패턴, 버그 가능성, 비표준 패턴 등 실제 관찰 기반으로 작성.

**자동 검증 항목**:
- [ ] 모든 Custom 클래스 분석 포함
- [ ] 주요 메소드의 역할이 명확히 기술됨
- [ ] 계산 공식이 수학 표기 또는 의사코드로 표현됨
- [ ] 모든 SQL 쿼리 설명 포함 (목적, 테이블 관계, 바인드 변수, 비즈니스 의미)
- [ ] 핵심 테이블을 표형식으로 표현했는지 확인(DDL 사용금지)
- [ ] UI 컴포넌트 분석 포함(단 UI가 없으면 생략)
- [ ] Grid 컬럼이 `필드명: 타입 - 설명 (너비px, 정렬)` 포맷으로 전수 나열됨
- [ ] 화면 동작 흐름이 2개 이상 시나리오로 분화 기술됨
- [ ] 이벤트 처리 흐름이 단계별로 상세 기술됨(단 UI가 없으면 생략)
- [ ] Mermaid 다이어그램 유효성
- [ ] Mermaid erDiagram 코드블록 포함 여부 및 유효성 (SVG는 사용자 요청 시에만)
- [ ] 특이사항 최소 3건 이상 기술됨

### Step 6: 최종 문서 저장
1. **디렉토리 생성**
   - 경로: `./docs/analysis/service/[ui|nui]/`
   - 없으면 자동 생성

2. **ERD 생성**
   - **기본**: Mermaid erDiagram 코드블록을 문서 내에 직접 포함
   - **SVG 요청 시에만**: SVG 파일을 별도 생성하여 `[문서 저장 경로]/ERD/` 에 저장 + 이미지 링크 첨부
     - 이미지 형태 참고 샘플: `.claude/skills/analyze-service/templates/ERD/`

3. **문서 파일 생성**
   - 파일명: `[SERVICE-ID]_legacy_analysis.md`
   - ERD 다이어그램: Mermaid 코드블록으로 직접 포함 (SVG 요청 시에만 `![ERD](ERD/[SERVICE-ID]_erd.svg)` 형태로 첨부)
   - Write 도구 사용

## 문서 품질 기준
1. **완전성**: 모든 Phase 결과 통합
2. **정확성**: JSON 데이터와 일치
3. **가독성**: 마크다운 형식 준수
4. **시각성**: Mermaid 다이어그램 포함
5. **추적성**: 원본 파일 경로 명시

## 주의사항
- Phase 1-4 선행 필수 (모든 Phase 완료 후 실행)
- analysis 디렉토리 없으면 자동 생성

## 에러 처리
- Phase 결과 누락 → 누락 Phase 안내 후 종료
- 디렉토리 생성 실패 → 권한 확인
