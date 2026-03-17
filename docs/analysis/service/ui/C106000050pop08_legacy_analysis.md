<h1 style="font-size: 40px; text-align: center; font-weight:
   bold; margin: 30px 0;">
  C106000050pop08 레거시 시스템 분석 종합 보고서
</h1>


# 1. 시스템 개요
- **서비스 ID**: C106000050pop08
- **업무명**: 미사용 칼라코드 찾기 (팝업)
- **분석 일시**: 2026-03-17 (KST)
- **전체 Activity 수**: 3개 (Built-in 3개)
- **분석자**: Claude Opus 4.6
- **분석 도구**: /analyze-service C106000050pop08
- **문서 버전**: 1.0

# 📊 비즈니스 프로세스 분석

## 시스템 목적

C106000050pop08은 색상 도장 공정에서 사용되는 칼라코드(색상 부자재 코드) 중 아직 등록되지 않은 미사용 코드를 조회하는 팝업 화면이다. 부모 화면(C106000050, 칼라코드 관리)에서 신규 칼라코드를 등록할 때 호출되며, 알파벳 + 숫자 조합으로 생성 가능한 전체 코드 중 TB_C10_CLR_CD_MNG 테이블에 미등록된 코드를 찾아 반환한다.

칼라코드는 알파벳 1자리(A~Z, 색상 계열 구분) + 숫자 4자리로 구성되며, 4자리 모드(10 단위 번호)와 5자리 모드(연속 번호) 두 가지 검색 방식을 지원한다. 사용자가 원하는 미사용 코드를 선택하면 부모 화면의 입력 필드에 자동으로 값이 전달된다.

## 주요 유즈케이스

### UC-01: 4자리 미사용 칼라코드 조회
- **Actor**: 칼라코드 관리 담당자
- **목적**: 10 단위 간격의 미사용 칼라코드를 조회하여 신규 코드 발급에 활용

- **전제조건**:
  - 부모 화면(C106000050)에서 팝업 호출
  - 칼라코드 접두어(알파벳 1자리 이상) 입력

- **주요 흐름**:
  1. 팝업 진입 시 URL 파라미터(CLR_SUB_MTL_CD_SH)가 있으면 자동 설정
  2. 칼라코드 입력란에 검색할 접두어 입력 (예: "A")
  3. "4자리" 라디오 버튼 선택 (기본값)
  4. 조회 버튼 클릭 → CLR_SUB_MTL_CD_SH 1글자 이상 유효성 검증
  5. C106000050pop08.select 쿼리 실행 → A~Z 알파벳 × 0000~9990(10단위) 조합 중 미등록 코드 조회
  6. Grid_1에 UNUSED_CODE 목록 표시

- **대체 흐름**:
  - 입력값 1글자 미만: "칼라코드를 1글자 이상 입력하세요" 경고
  - 조회 결과 없음: 빈 그리드 표시

- **후행조건**:
  - 미사용 코드 목록이 Grid에 표시됨
  - 사용자가 선택 또는 더블클릭으로 코드를 부모 화면에 전달 가능

### UC-02: 5자리 미사용 칼라코드 조회
- **Actor**: 칼라코드 관리 담당자
- **목적**: 연속 번호 범위의 미사용 칼라코드를 세밀하게 조회

- **전제조건**:
  - 부모 화면에서 팝업 호출
  - 칼라코드 접두어(알파벳 + 숫자 4글자 이상) 입력

- **주요 흐름**:
  1. 칼라코드 입력란에 접두어 입력 (예: "A001")
  2. "5자리" 라디오 버튼 선택
  3. 조회 버튼 클릭 → CLR_SUB_MTL_CD_SH 4글자 이상 유효성 검증
  4. C106000050pop08.select2 쿼리 실행 → A~Z × 0000~9999(연속) 조합 중 미등록 코드 조회
  5. Grid_1에 UNUSED_CODE 목록 표시

- **대체 흐름**:
  - 입력값 4글자 미만: "칼라코드를 4글자 이상 입력하세요" 경고

- **후행조건**:
  - 세밀한 번호 범위의 미사용 코드가 표시됨

### UC-03: 미사용 코드 선택 및 부모 화면 전달
- **Actor**: 칼라코드 관리 담당자
- **목적**: 조회된 미사용 코드 중 하나를 선택하여 부모 화면에 전달

- **전제조건**:
  - UC-01 또는 UC-02를 통해 미사용 코드가 Grid에 표시됨

- **주요 흐름**:
  1. Grid_1에서 원하는 미사용 코드 행 선택
  2. "선택" 버튼 클릭 또는 행 더블클릭
  3. parent.masterSetValue 호출하여 부모 화면(C106000050_Form_1)의 필드에 UNUSED_CODE 값 설정
  4. 팝업 창 자동 닫기

- **대체 흐름**:
  - 선택 없이 닫기: "닫기" 버튼 클릭 시 값 전달 없이 팝업 종료

- **후행조건**:
  - 부모 화면의 칼라코드 입력 필드에 선택된 미사용 코드가 설정됨
  - 팝업 창 닫힘

---
## 비즈니스 로직 상세

### 1. 미사용 칼라코드 생성 알고리즘 (CTE 기반)

- **목적**: 시스템에서 사용 가능한 전체 칼라코드 조합을 동적으로 생성하고, 이미 등록된 코드를 제외하여 미사용 코드만 추출

- **처리 케이스**:

  **[케이스 1: 4자리 모드 - 10단위 코드 생성 (select)]**
  ```
    조건: DISITS = '1' (4자리 라디오 선택)
    처리:
      1. CTE ALPHABET: DUAL에서 CONNECT BY LEVEL <= 26으로 A~Z 26개 알파벳 생성 (CHR(64 + LEVEL))
      2. CTE NUMBERS: DUAL에서 CONNECT BY LEVEL <= 1000으로 0~999 범위 생성,
         MOD(LEVEL-1, 10) = 0 필터로 10단위만 추출 → 0000, 0010, 0020, ..., 9990
         LPAD(4자리) 포맷팅
      3. CTE CODES: ALPHABET × NUMBERS CROSS JOIN → 알파벳+숫자 조합 코드 생성
      4. NOT EXISTS로 TB_C10_CLR_CD_MNG 테이블에 CLR_SUB_MTL_CD로 존재하는 코드 제외
      5. LIKE :CLR_SUB_MTL_CD_SH || '%' 조건으로 입력 접두어 필터링
  ```

  **[케이스 2: 5자리 모드 - 연속 코드 생성 (select2)]**
  ```
    조건: DISITS = '2' (5자리 라디오 선택)
    처리:
      1. CTE ALPHABET: 동일 (A~Z 26개)
      2. CTE NUMBERS: DUAL에서 CONNECT BY LEVEL <= 10000으로 0000~9999 전체 범위 생성
         MOD 필터 없음 → 연속된 모든 번호 포함
      3. CTE CODES: ALPHABET × NUMBERS CROSS JOIN
      4. NOT EXISTS + LIKE 필터 동일
  ```

- **계산 공식**:
  ```
  전체 조합 수 (4자리 모드) = 26 × 1000 = 26,000개
  전체 조합 수 (5자리 모드) = 26 × 10,000 = 260,000개
  미사용 코드 = 전체 조합 - TB_C10_CLR_CD_MNG에 등록된 코드
  ```

### 2. 칼라코드 체계 (색상 분류 규칙)

- **목적**: 알파벳 첫 글자로 색상 계열을 구분하여 체계적인 코드 관리
- **분류 체계**:

  | 코드 | 색상 |
  |------|------|
  | A, B, C | BLUE |
  | D, G, I | GREEN |
  | L, M, N | GRAY |
  | H, W, X | WHITE |
  | E, F | BEIGE |
  | K | BLACK |
  | O | ORANGE |
  | R, S | RED, BROWN |
  | Y | YELLOW |

### 3. 입력값 유효성 검증

- **목적**: 검색 범위 제한으로 과다 조회 방지
- **처리 케이스**:

  **[4자리 모드 검증]**
  ```
    조건: DISITS = '1'
    처리: CLR_SUB_MTL_CD_SH가 1글자 미만이면 경고 메시지 표시 후 조회 중단
  ```

  **[5자리 모드 검증]**
  ```
    조건: DISITS = '2'
    처리: CLR_SUB_MTL_CD_SH가 4글자 미만이면 경고 메시지 표시 후 조회 중단
    사유: 5자리 모드는 260,000개 조합 가능하므로 최소 4글자 접두어로 범위 제한 필요
  ```

---

# 💾 데이터 요구사항

## 핵심 테이블

### 1. TB_C10_CLR_CD_MNG - (칼라코드 관리)
| 컬럼명 | 타입 | PK | 설명 |
|--------|------|----|------|
| CLR_SUB_MTL_CD | VARCHAR2 | ✅ | 색상 부자재 코드 (알파벳1자리 + 숫자4자리, 예: A0010) |

> 본 서비스에서는 NOT EXISTS 조건에서 CLR_SUB_MTL_CD 컬럼만 참조하여 미사용 코드를 판별한다.

## 데이터 플로우

### 1. 4자리 미사용 코드 조회
```
[4자리 모드 미사용 코드 조회]
조회 버튼 클릭 (DISITS='1')
→ C106000050pop08.select
  WITH ALPHABET AS (DUAL에서 A~Z 생성)
       NUMBERS AS (DUAL에서 0000~9990 10단위 생성)
       CODES AS (ALPHABET × NUMBERS CROSS JOIN)
  SELECT LETTER || NUM AS UNUSED_CODE
  FROM CODES C
  WHERE NOT EXISTS (SELECT 1 FROM TB_C10_CLR_CD_MNG WHERE CLR_SUB_MTL_CD = C.LETTER || C.NUM)
    AND C.LETTER || C.NUM LIKE :CLR_SUB_MTL_CD_SH || '%'
→ Grid_1에 미사용 코드 목록 표시
```

### 2. 5자리 미사용 코드 조회
```
[5자리 모드 미사용 코드 조회]
조회 버튼 클릭 (DISITS='2')
→ C106000050pop08.select2
  WITH ALPHABET AS (DUAL에서 A~Z 생성)
       NUMBERS AS (DUAL에서 0000~9999 연속 생성)
       CODES AS (ALPHABET × NUMBERS CROSS JOIN)
  SELECT LETTER || NUM AS UNUSED_CODE
  FROM CODES C
  WHERE NOT EXISTS (SELECT 1 FROM TB_C10_CLR_CD_MNG WHERE CLR_SUB_MTL_CD = C.LETTER || C.NUM)
    AND C.LETTER || C.NUM LIKE :CLR_SUB_MTL_CD_SH || '%'
→ Grid_1에 미사용 코드 목록 표시
```

## SQL 일람표

| SQL 이름 | 쿼리 ID | 타입 | 출처 | 테이블 |
|---------|---------|-----|-------|-------|
| 4자리 미사용 코드 조회 | C106000050pop08.select | SELECT | Service | TB_C10_CLR_CD_MNG |
| 5자리 미사용 코드 조회 | C106000050pop08.select2 | SELECT | Service | TB_C10_CLR_CD_MNG |

## ER 다이어그램 (핵심 관계)

```mermaid
erDiagram
    TB_C10_CLR_CD_MNG {
        VARCHAR2 CLR_SUB_MTL_CD PK "색상 부자재 코드"
    }
```

관계 설명:
- TB_C10_CLR_CD_MNG은 본 서비스에서 유일하게 참조되는 테이블로, NOT EXISTS 조건을 통해 미사용 코드 판별의 기준이 됨
- CTE(DUAL 기반 동적 생성)와의 비교를 통해 미등록 코드를 필터링

---

# 🖥️ 사용자 인터페이스 요구사항

## 화면 레이아웃 상세

### Layout 구조 (initLayout)
```javascript
{
  itemType: "layout",
  programId: "C106000050pop08",
  messageBox: true,
  dirType: "row",       // 수직 분할 (위→아래)
  childSize: "60,*",    // 상단 60px, 하단 나머지
  splitter: false,
  components: [
    {
      id: "Form_1",
      height: "60px",
      component: {
        itemType: "form",
        formId: "C106000050pop08_Form_1"
      }
    },
    {
      id: "content_area",
      height: "*",
      component: {
        itemType: "layout",
        dirType: "col",       // 수평 분할 (좌→우)
        childSize: "30%,*",   // 좌측 30%, 우측 나머지
        splitter: false,
        children: [
          {
            id: "Grid_1",
            component: {
              itemType: "grid",
              gridId: "C106000050pop08_Grid_1"
            }
          },
          {
            id: "HtmlObj_1",
            component: {
              itemType: "htmlObj",
              renderTo: "HtmlObj_1"
            }
          }
        ]
      }
    }
  ]
}
```

## 입출력 요소

### Form 컴포넌트
**C106000050pop08_Form_1**
- CLR_SUB_MTL_CD_SH: Input(60px) - 칼라코드 검색 접두어 입력
- DISITS: Radio - "4자리"(값:1, 기본 선택) / "5자리"(값:2) 선택
- find: Button - 조회 → find 이벤트 (DISITS에 따라 find/find2 액션 분기)
- choice: Button - 선택 → 선택된 미사용 코드를 부모 화면에 전달
- winClose: Button - 닫기 → 팝업 창 닫기

### Grid 컴포넌트

**C106000050pop08_Grid_1 (미사용 코드 목록)**
- 편집 가능 여부: 아니오 (읽기 전용)
- Split: 0 (고정 컬럼 없음)
- 멀티 선택: 가능 (enableMultiselect)
- Smart Rendering: 사용 (대량 데이터 처리 최적화)
- 컨텍스트 메뉴: 사용 (컬럼 이동, 필터, 편집모드, Excel 다운로드)
- 주요 컬럼 (1개):

  **미사용 코드 정보**:
  - UNUSED_CODE: ro - 미사용 코드 (*px, 중앙정렬, 문자열 정렬)

### HTML 컴포넌트

**HtmlObj_1 (칼라코드 생성 규칙 안내)**
- 정적 HTML 테이블로 색상 코드별 색상 매핑 규칙을 안내
- A,B,C→BLUE / D,G,I→GREEN / L,M,N→GRAY / H,W,X→WHITE / E,F→BEIGE / K→BLACK / O→ORANGE / R,S→RED,BROWN / Y→YELLOW

## 화면 동작 흐름

### 1. 화면 초기 로딩
```
1. 부모 화면(C106000050)에서 팝업 호출
2. initLayout으로 레이아웃 초기화 (Form + Grid + HtmlObj)
3. onFormLoadFunction 실행:
   - URL 파라미터 CLR_SUB_MTL_CD_SH 확인
   - 파라미터 있으면 Form의 CLR_SUB_MTL_CD_SH 필드에 자동 설정
4. onGridLoadFunction 실행:
   - find 액션으로 초기 데이터 자동 로드
5. 기본 라디오 선택: "4자리" (DISITS=1)
6. 칼라코드 생성 규칙 안내 테이블 표시 (HtmlObj_1)
```

### 2. 미사용 코드 조회
```
1. 사용자가 칼라코드 접두어 입력 (예: "A")
2. 자리수 모드 선택 (4자리/5자리 라디오)
3. 조회 버튼 클릭
4. find 이벤트 핸들러 실행:
   - DISITS 값 확인
   - 4자리 모드: CLR_SUB_MTL_CD_SH 1글자 이상 검증 → find 액션
   - 5자리 모드: CLR_SUB_MTL_CD_SH 4글자 이상 검증 → find2 액션
5. 서비스 호출 (C106000050pop08-service)
   - find → "4자리 조회" Activity → C106000050pop08.select 실행
   - find2 → "5자리 조회" Activity → C106000050pop08.select2 실행
6. Grid_1에 미사용 코드 목록 표시
```

### 3. 코드 선택 및 부모 화면 전달
```
1. Grid_1에서 원하는 미사용 코드 행 선택
2-A. "선택" 버튼 클릭 → choice 이벤트
2-B. 또는 행 더블클릭 → doOnRowDblClicked 이벤트
3. 선택된 행의 UNUSED_CODE 값(0번 셀) 추출
4. parent.masterSetValue("C106000050_Form_1", "UNUSED_CODE", 값) 호출
5. parent.winObj.winClose()로 팝업 닫기
```

## JavaScript 모듈

**C106000050pop08.jsp** (인라인 스크립트)
- find(): 4자리/5자리 분기 조회 (DISITS 값에 따라 find/find2 액션 분기, 입력값 길이 유효성 검증)
- choice(): Grid 선택값을 parent.masterSetValue로 부모 Form에 전달 후 팝업 닫기
- doOnRowDblClicked(rowId, cellInd): Grid 행 더블클릭 시 choice()와 동일 동작
- onFormLoadFunction(): Form 로드 시 URL 파라미터 자동 설정
- onGridLoadFunction(): Grid 로드 시 초기 데이터 자동 조회
- onGridContextMenuClick(id, zoneId, cas): 컨텍스트 메뉴 처리 (컬럼이동, 필터, 편집모드, Excel)
- findMessage(appMsg): 메시지박스에 appMsg 표시

## 주요 이벤트 핸들러

**find (조회 버튼 클릭)**
- 이벤트 타입: Button Click
- 처리 내용:
  1. DISITS 라디오 값 확인 (1: 4자리, 2: 5자리)
  2. 4자리 모드: CLR_SUB_MTL_CD_SH 1글자 이상 검증
  3. 5자리 모드: CLR_SUB_MTL_CD_SH 4글자 이상 검증
  4. 검증 실패 시 경고 메시지 표시 후 중단
  5. 검증 통과 시 Grid_1에 find 또는 find2 액션으로 데이터 로드

**choice / doOnRowDblClicked (코드 선택)**
- 이벤트 타입: Button Click / Grid Row Double Click
- 처리 내용:
  1. Grid_1에서 선택된 행의 UNUSED_CODE(0번 셀) 추출
  2. parent.masterSetValue("C106000050_Form_1", "UNUSED_CODE", 값) 호출
  3. parent.winObj.winClose()로 팝업 닫기

**onGridContextMenuClick (컨텍스트 메뉴)**
- 이벤트 타입: Context Menu Click
- 처리 내용:
  1. move_grid: 컬럼 이동 토글
  2. filter_grid: 헤더 필터 토글
  3. editable_grid: 편집 모드 토글
  4. excel_grid: Excel 다운로드 실행

---

# 📌 특이사항 및 주의사항

## 1. CTE + CROSS JOIN 기반 대량 코드 생성
- **성능 주의**: 5자리 모드에서 26 × 10,000 = 260,000개의 조합을 DUAL 기반 CTE로 동적 생성한 후 NOT EXISTS로 필터링. 대량 데이터 생성 쿼리이므로 DB 부하 가능성 존재
- **4자리 vs 5자리 차이**: 유일한 차이는 NUMBERS CTE의 `MOD(LEVEL-1, 10) = 0` 필터 유무. 4자리 모드는 10단위 간격(1,000개), 5자리 모드는 연속 번호(10,000개)
- **입력값 길이 제한**: 5자리 모드에서 4글자 이상 필수 요구는 260,000개 전체 조회를 방지하기 위한 성능 보호 장치

## 2. 부모-자식 창 간 데이터 전달 패턴
- **parent.masterSetValue 의존**: 팝업이 부모 창의 `masterSetValue` 함수에 직접 의존. 부모 화면(C106000050)의 함수 시그니처가 변경되면 팝업도 수정 필요
- **하드코딩된 부모 Form ID**: `"C106000050_Form_1"`이 JavaScript 코드에 하드코딩됨. 부모 화면의 Form ID 변경 시 팝업 수정 필요

## 3. 비활성화된 이벤트 핸들러 잔존
- **onCheckEvent**: 체크박스 변경 시 row updated 상태 변경 로직이 코드에 존재하나 현재 비활성화 상태. Grid에 체크박스 컬럼이 없어 실질적으로 사용되지 않음
- **onAfterUpdateFinishEvent**: 업데이트 완료 후 재조회 로직이 존재하나 비활성화됨. 본 서비스는 조회 전용이므로 불필요한 코드

## 4. Smart Rendering 적용
- Grid에 enableSmartRendering이 활성화되어 대량 미사용 코드 목록을 효율적으로 렌더링. 26,000개(4자리) 또는 260,000개(5자리) 결과를 처리하기 위한 필수 설정

---

# 📚 참고 문서

- **Service XML**: `src/service/C106000050pop08-service.xml`
- **Query SQL**: `src/query/C106000050pop08-query.glue_sql`
- **JSP**: `WebContents/C106000050pop08.jsp`
- **Grid XML**: `WebContents/header/kr/C106000050pop08/C106000050pop08_Grid_1.xml`
- **Form XML**: `WebContents/header/kr/C106000050pop08/C106000050pop08_Form_1.xml`
