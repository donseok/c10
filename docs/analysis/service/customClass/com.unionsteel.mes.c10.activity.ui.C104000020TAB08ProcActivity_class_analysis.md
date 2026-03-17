# C104000020TAB08ProcActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C104000020TAB08ProcActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 329 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

화면의 탭08(통과공정 편집 탭)에서 저장 요청이 오면, 주문에 해당하는 기존 통과공정을 전량 삭제한 후 화면에서 편집된 통과공정 행을 순서대로 재삽입하는 Activity이다. 삽입 시 반제품 소재코드(SEM_MTL_CD)를 제품유형(PRD_NM_CD) 및 주공정코드(MAIN_PROC_CD) 조합에 따라 동적으로 조회하여 설정하며, 모든 변경이력을 이력 테이블에도 기록한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속 (DhtmlxActivity가 아닌 직접 PosActivity 상속)
- `PosActivity`의 abstract 메소드인 `runActivity(PosContext ctx)`를 구현하며, doPreActivity/doMainActivity/doPostActivity 생명주기와 분리된 단일 메소드 구조이다.
- `C10NuiConstantsIF` 구현으로 SQL key 상수, 컬럼명 상수, 제품유형 코드 상수 등을 직접 참조한다.

### 1.2 핵심 입력/출력

| 구분 | 키 | 설명 |
|------|----|------|
| 입력 (ctx) | `IDS` | 화면 그리드 행 ID 배열 (쉼표 구분) |
| 입력 (ctx) | `{rowId}_ORD_NO` | 주문번호 |
| 입력 (ctx) | `{rowId}_ORD_LN` | 주문행번 |
| 입력 (ctx) | `{rowId}_PROC_SEQ` | 공정순서 |
| 입력 (ctx) | `{rowId}_MAIN_PROC_CD` | 주공정코드 |
| 입력 (ctx) | `{rowId}_SUB_PROC_CD1~6` | 부공정코드 1~6 |
| 입력 (ctx) | `{rowId}_SMS_RCV_YN` | SMS 수신 여부 |
| 입력 (ctx) | `{rowId}_!nativeeditor_status` | 그리드 행 DML 상태 (`deleted` 등) |
| 출력 (ctx) | `ERRMSG` | 오류 발생 시 에러 메시지 |
| 반환값 | `SUCCESS` | 정상 완료 |
| 반환값 | `FAILURE` | IDS 없거나 예외 발생 시 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

**목적**: 통과공정 전체 삭제 후 재삽입 (Delete-then-Insert 패턴)

**복잡도**: 높음 (중첩 조건 분기, 다중 SQL 호출, 반제품 소재코드 결정 로직)

**처리 흐름:**

```
1. mesdao 취득, IDS 유효성 검증 (null 또는 빈 배열이면 FAILURE 반환)
2. IDS 첫 번째 원소를 쉼표로 분리하여 행 ID 배열(idsValue) 구성
3. 루프 시작 (idsValue 전체 순회, i=0~n-1):
   3-1. 각 행 ID를 키로 PosContext에서 컬럼별 String[] 추출
   3-2. i==0 일 때 최초 1회만 실행:
        - SELECT_CMN SQL로 ORD_NO+ORD_LN 기준 PRD_NM_CD, MTL_CD 조회
        - DELETE_PROC SQL로 해당 주문의 통과공정 전량 삭제
   3-3. MAIN_PROC_CD가 공백이거나 STATUS=="deleted"이면 continue (건너뜀)
   3-4. 반제품 소재코드(SEM_MTL_CD) 결정 (아래 별도 설명)
   3-5. INSERT_PROC2 SQL로 통과공정 신규 삽입
   3-6. INSERT_PROC_HST SQL로 통과공정 수정이력 삽입
   3-7. nIvalue 증가 (내역저장 플래그)
4. 루프 종료 후: ORD_NO, ORD_LN이 공백이 아니면
   INSERT_HST SQL로 변경이력 헤더 삽입
5. TX1 커밋
6. SUCCESS 반환
예외 발생 시: TX1 롤백, ERRMSG 설정, FAILURE 반환
```

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | IDS 필수 검증 | `ids == null` 또는 `ids.length < 1` | FAILURE 반환 (즉시 종료) |
| 2 | 주문정보 1회 조회 | 루프의 `i == 0` | SELECT_CMN 조회로 PRD_NM_CD, MTL_CD 취득 / DELETE_PROC로 기존 통과공정 삭제 |
| 3 | 삭제 행 건너뜀 | `MAIN_PROC_CD == " "` 또는 `STATUS == "deleted"` | 해당 행의 통과공정 삽입 건너뜀 (continue) |
| 4 | RCL공정 SEM_MTL 결정 | PRD_NM_CD in (1~9) AND MAIN_PROC_CD == "72" | SELECT_SEM_MTL1 SQL 실행 |
| 5 | R/S공정 SEM_MTL 결정 | PRD_NM_CD in (1~9) AND MAIN_PROC_CD 첫자리 == "7" (72 제외) | SELECT_SEM_MTL3 SQL 실행 |
| 6 | 일반공정 SEM_MTL 결정 (특수 PRD) | PRD_NM_CD in (1~9) AND MAIN_PROC_CD 첫자리 != "7" | SELECT_SEM_MTL2 SQL 실행, param[1]=MAIN_PROC_CD[0] |
| 7 | 일반공정 SEM_MTL 결정 (기타 PRD) | PRD_NM_CD not in (1~9) | SELECT_SEM_MTL2 SQL 실행, param[1]=MAIN_PROC_CD[0] |
| 8 | RCL공정 param 설정 | MAIN_PROC_CD == "72" | param[1] = MAIN_PROC_CD 전체("72") |
| 9 | R/S공정 param 설정 | MAIN_PROC_CD 첫자리 == "7" AND != "72" | param[1] = MAIN_PROC_CD[0] ("7") |
| 10 | 이력 헤더 저장 | 루프 종료 후 ORD_NO, ORD_LN이 공백이 아님 | INSERT_HST 실행 |

### 반제품 소재코드(SEM_MTL_CD) 결정 로직 상세

```
조건 분기 (공정코드 "MAIN_PROC_CD" 기준):
  IF PRD_NM_CD in (1,2,3,4,5,6,7,8,9):
    IF MAIN_PROC_CD == "72"   -> SELECT_SEM_MTL1 (RCL 전용)
    ELSE IF MAIN_PROC_CD[0] == "7" -> SELECT_SEM_MTL3 (R/S 전용, 72 제외)
    ELSE                       -> SELECT_SEM_MTL2 (일반 공정, 첫자리 비교)
  ELSE:
    SELECT_SEM_MTL2 (일반 공정)
```

---

## 4. SQL 매핑

| SQL Key | 상수명 | 용도 | 호출 시점 |
|---------|--------|------|-----------|
| `C102100CMN.select` | `SELECT_CMN` | 주문의 PRD_NM_CD, MTL_CD 조회 | 루프 i==0, WhereParam[0]=ORD_NO, [1]=ORD_LN |
| `C102100000.PROC_DELETE` | `DELETE_PROC` | 주문의 기존 통과공정 전량 삭제 | 루프 i==0 직후 |
| `C102100PROC.SemMtlselect1` | `SELECT_SEM_MTL1` | RCL공정(72) 반제품 소재코드 조회 | 행 처리 시 MAIN_PROC_CD=="72" |
| `C102100PROC.SemMtlselect2` | `SELECT_SEM_MTL2` | 일반공정 반제품 소재코드 조회 | 행 처리 시 (기본) |
| `C102100PROC.SemMtlselect3` | `SELECT_SEM_MTL3` | R/S공정 반제품 소재코드 조회 | 행 처리 시 MAIN_PROC_CD[0]=="7" (72 제외) |
| `C102100PROC.Insert2` | `INSERT_PROC2` | 통과공정 삽입 (대체공정 6개 버전) | 유효 행 처리 완료 시마다 |
| `C104000020TAB08pop02.insertHistory` | `INSERT_PROC_HST` | 통과공정 수정이력 삽입 | INSERT_PROC2 직후 |
| `C104000020TAB08.CHG_HSTinsert` | `INSERT_HST` | 변경이력 헤더 삽입 | 루프 전체 종료 후 (1회) |

> 참고: `INSERT_PROC` (`C102100PROC.Insert`)는 주석 처리된 구버전 SQL이며, 현재는 `INSERT_PROC2`가 사용된다.

---

## 5. Route Transition

| 반환값 | 조건 | 설명 |
|--------|------|------|
| `FAILURE` | `ids == null` 또는 `ids.length < 1` | 입력 데이터 없음 |
| `SUCCESS` | 모든 처리 및 커밋 완료 | 정상 종료 |
| `FAILURE` | `Exception` 발생 | 롤백 후 오류 반환 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

C104000020 화면의 탭08은 품질설계 결과에서 주문별 통과공정을 편집하는 탭이다. 사용자가 화면 그리드에서 통과공정 목록을 수정한 후 저장 버튼을 누르면 이 Activity가 호출된다. 기존 데이터를 전량 삭제하고 화면에서 넘어온 데이터를 새로 삽입하는 Delete-and-Insert 패턴으로 구현되어 있으며, 삽입된 각 공정 행에 대해 반제품 소재코드를 제품유형과 공정코드 조합 규칙에 따라 자동 결정한다.

### 6.2 핵심 비즈니스 로직

**공정 저장 파라미터 구성:**

각 통과공정 행 저장 시 다음 파라미터를 설정한다.
- `ORD_NO`, `ORD_LN`, `PROC_SEQ` : 주문 식별
- `MAIN_PROC_CD` : 주공정코드
- `SUB_PROC_CD1~6` : 부공정코드 (최대 6개 대체공정)
- `MTL_CD` : 반제품 소재코드 (SEM_MTL_CD 조회 결과)
- `SMS_RCV_YN` : SMS 수신 여부
- `VALUE_I` : 내역저장 플래그 (행 순서 인덱스, 0부터 증가)
- `OBJECT_TYPE`, `OBJECT_ID`, `PROGRAM_ID`, `TIMESTAMP` : 감사(Audit) 정보

**`nIvalue` (내역저장 플래그)의 역할:**

루프 내에서 유효하게 저장된 행마다 1씩 증가하며, SQL 파라미터 `VALUE_I`로 전달된다. `deleted` 상태 행 또는 `MAIN_PROC_CD`가 공백인 행은 건너뛰므로 실제 저장된 행의 순번을 나타낸다.

**주의사항:**

소스 내 `logger.logError()`가 디버그 목적으로 사용되고 있다 (일반적으로 logError는 에러 레벨 로그이나 이 클래스에서는 진행상황 추적에 사용). `INSERT_PROC`(원본)에서 `INSERT_PROC2`(테스트)로 전환된 주석이 남아 있으며, 현재 운영 중인 SQL은 `INSERT_PROC2`이다.
