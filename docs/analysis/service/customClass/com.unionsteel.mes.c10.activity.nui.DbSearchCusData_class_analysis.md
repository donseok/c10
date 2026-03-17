# DbSearchCusData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchCusData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 137 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

고객공통사양(VI_M00_C10A1020 View)을 조회하여 해당 주문의 품질설계 관련 압연두께 정보를 PosContext에 편성하는 Activity이다. 고객 배치사양번호(`CUS_BTH_PAP_NO`)를 키로 고객공통 View를 검색하여 고객요청압연두께, 두께단위, 두께계산적용코드를 편집한다. 정보가 존재하면 `success`, 없으면 `failure`를 반환한다.

### 1.1 상속/구현 관계

```
PosActivity
    └── DbSearchCusData implements C10NuiConstantsIF
```

- `PosActivity`: GLUE 프레임워크 Activity 추상 클래스. `runActivity(PosContext)`를 구현 의무.
- `C10NuiConstantsIF`: C10 NUI 상수 인터페이스 (에러코드, 컬럼명, SQL Key 상수 정의)

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 (Property) | `prodSpecKind` | 품질설계사양구분 |
| 입력 (Property) | `dao` | DAO 빈 ID (예: `masterdao`) |
| 입력 (Property) | `bind-result` | 이전 Activity 결과 Key |
| 입력 (Context) | `COL_CUS_BTH_PAP_NO` | 고객 배치사양번호 (조회 키) |
| 출력 (Context) | `COL_QLT_DSN_SPC_TP` | 품질설계사양구분 |
| 출력 (Context) | `COL_CUS_REQ_ROL_THK` | 고객요청압연두께 |
| 출력 (Context) | `COL_THK_COR_UNT` | 두께단위 (`COL_CUS_REQ_ROL_THK_UNT` 컬럼 매핑) |
| 출력 (Context) | `COL_PRD_THK_CAL_APL_CD` | 제품두께계산적용코드 |
| 출력 (Context) | `COL_QLT_DSN_ERR_CD` | 품질설계 에러코드 (오류 시) |
| 출력 (Context) | `C10STR_P_ERR_KEY` | 에러 발생 여부 플래그 |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 고객배치사양번호로 고객공통 View를 조회하여 압연두께 관련 항목을 편성

**복잡도**: 낮음

**처리 흐름**:

1. Property `prodSpecKind` 값을 Context에 저장 (`COL_QLT_DSN_SPC_TP`)
2. Property `dao`로 DAO 인스턴스 획득
3. Context에서 `COL_CUS_BTH_PAP_NO` null 체크
   - null이면: 에러코드 `ERRCD_KC01`, 에러플래그 set, 두께 관련 항목 공백 처리, `FAILURE` 반환
4. `VI_M00_C10A1020` View를 `CUS_BTH_PAP_NO`로 조회 (positional param index 0)
5. 조회 결과 분기 처리:
   - count = 1: `CUS_REQ_ROL_THK`, `CUS_REQ_ROL_THK_UNT`, `PRD_THK_CAL_APL_CD` 항목 편성
   - count > 1: 에러코드 `ERRCD_KS14`, 에러플래그 set, 두께 항목 공백 처리 (return 없이 진행)
   - count = 0: 에러코드 `ERRCD_KS04`, 에러플래그 set, 두께 항목 공백 처리 (return 없이 진행)
6. 최종 `SUCCESS` 반환 (에러 발생해도 SUCCESS 반환)

**주의사항**: count > 1 및 count = 0 케이스에서 `return PosBizControlConstants.FAILURE`가 주석 처리되어 있어, 에러가 발생하더라도 항상 `SUCCESS`를 반환한다.

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 고객배치사양번호 필수 | `COL_CUS_BTH_PAP_NO`가 null | 에러코드 `ERRCD_KC01` set, `FAILURE` 반환 |
| 2 | 고객공통 단건 정상 | View 조회 결과 count = 1 | 압연두께, 단위, 계산코드 편성 성공 |
| 3 | 고객공통 중복 | View 조회 결과 count > 1 | 에러코드 `ERRCD_KS14` set (현재 SUCCESS 반환) |
| 4 | 고객공통 미존재 | View 조회 결과 count = 0 | 에러코드 `ERRCD_KS04` set (현재 SUCCESS 반환) |
| 5 | DB 조회 예외 | `dao.find()` Exception 발생 | rowset = null, 에러 로그 (FAILURE 주석 처리) |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| `VI_M00_C10A1020` | M00APUSER 고객공통 View 조회 | `COL_CUS_BTH_PAP_NO` null 체크 통과 후 |

**파라미터**: positional parameter index 0 = `COL_CUS_BTH_PAP_NO` 값

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

생산가부 판단 프로세스에서 주문에 매핑된 고객사양번호를 기준으로 고객이 요청한 압연두께 정보를 조회하는 역할이다. 이 정보는 이후 압연목표두께 계산 시 CRN(보정치), PCN(퍼센트), TRK(절대치) 단위별 계산에 활용된다.

`masterdao`(M00APUSER)의 `VI_M00_C10A1020` View는 고객공통사양 테이블의 조회 뷰로, 고객 배치사양번호 1건에 대해 유일하게 매핑되어야 한다. count가 1이 아닌 경우 데이터 품질 오류로 판단한다.

에러 발생 시에도 `SUCCESS`를 반환하도록 설계된 이유는, 에러 정보를 Context에 누적하여 이후 에러처리 Activity(`DbQltReqErrSet` 등)에서 일괄 처리하기 위한 패턴이다.
