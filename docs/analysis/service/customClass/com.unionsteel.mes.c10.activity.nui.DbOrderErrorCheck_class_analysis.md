# DbOrderErrorCheck 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbOrderErrorCheck.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 4,087 라인 |
| 메소드 수 | 5개 |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

생산가부요청의 주문항목들에 대해 정합성 에러 여부를 체크하는 Activity이다. 고객공통기준, 규격공통기준, 마스터 데이터 기준, 코드 정합성 등을 다각도로 검증하여 에러가 발생한 경우 에러내역을 PosContext에 누적 등록한다. 최종적으로 에러가 없으면 `success`, 있으면 `failure`를 반환하여 이후 서비스 전이를 결정한다.

### 1.1 상속/구현 관계

```
PosActivity
    └── DbOrderErrorCheck implements C10NuiConstantsIF
```

- `EasyAccess`: GLUE 마스터데이터 접근 API (코드 검증, 규칙 매핑)

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 (Property) | `dao` | DAO 빈 ID (`mesdao`) |
| 입력 (Property) | `bind-result` | 이전 RowSet Key (현재 주석 처리) |
| 입력 (Context) | 주문 관련 항목 약 20여개 | 최종수요가코드, 고객배치사양번호, 규격약호, 규격년도, 제품형태, 주문두께/폭/길이 등 |
| 출력 (Context) | `COL_XMSGS` | 에러 메시지 누적 (쉼표 구분) |
| 출력 (Context) | `C10STR_QLT_DSN_ERR_CD` | 에러코드 누적 (쉼표 구분) |
| 출력 (Context) | `C10STR_P_ERR_KEY` | 에러 발생 여부 (`NO` 초기화) |
| 반환 | `success` | 에러 없음 |
| 반환 | `failure` | 에러 있음 (`COL_XMSGS` 비어있지 않음) |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 주문 정합성 전체 체크 조율. 3단계 체크(고객공통기준, 규격공통기준, 마스터/코드 체크)를 순서대로 수행하고 에러 여부로 반환값 결정.

**복잡도**: 높음

**처리 흐름**:

1. 에러 초기화: `C10STR_P_ERR_KEY = NO`, `C10STR_QLT_DSN_ERR_CD = 공백`
2. Context에서 주문 항목 약 20여개 null safe 추출
3. **[고객사양번호 체크]**: `cus_bth_pap_no`가 유효한 경우 `fnl_cus_cd`로 시작하는지 검증 (A223 오류)
4. **[고객공통 View 조회]**: `COL_CUS_BTH_PAP_NO`가 null이 아닌 경우 `VI_M00_C10A1020` 조회
   - count = 1: 고객공통기준값과 주문항목 12개 항목 대사 (A243~A254 오류)
   - count > 1: A242 오류
   - count = 0: A241 오류
5. **[규격공통 View 조회]**: `spc_avr`, `spc_yr` 둘 다 유효한 경우 `VI_M00_C10A1010` 조회
   - count = 1: 정상
   - count > 1: A342 오류
   - count = 0: A341 오류
6. **[마스터 체크]**: `ordMasterChk(ctx)` 호출
7. **[코드 체크]**: `ordCodeChk(ctx)` 호출
8. `COL_XMSGS` null 여부로 `SUCCESS` / `FAILURE` 반환

**고객공통기준 대사 항목 (count=1 시)**:

| 컬럼명 | 오류코드 | 체크 내용 |
|--------|---------|-----------|
| `ORD_USG_CD` | A243 | 주문용도코드 상이 |
| `SPC_AVR` | A244 | 규격약호 상이 |
| `SPC_YR` | A245 | 규격년도 상이 |
| `CUS_CD` | A246 | 최종수요가 상이 |
| `PRD_NM_CD` | A247 | 품명 상이 |
| `PRD_THK_RNG_LLV` / `ULV` | A248 | 주문두께 범위 이탈 |
| `PRD_WTH_RNG_LLV` / `ULV` | A249 | 주문폭 범위 이탈 (조합폭 포함) |
| `PRD_LTH_RNG_LLV` / `ULV` | A250 | 주문길이 범위 이탈 (SHEET만) |
| `ORD_THK_TP` | A251 | 두께구분코드 상이 |
| `GW_ASG_CD` | A252 | 도금량 상이 |
| `ORD_SUR_HND_CD` | A253 | 주문표면처리 상이 |
| `CCL_BOM_NO` | A254 | 색상코드 상이 |

**조합폭 계산식**:
- 조합폭 유효 조건: `ord_slit_grp_cnt > 0 AND ord_exc_wth == ord_mix_wth1`
- 조합폭 = `ord_slit_grp_cnt × ord_mix_wth1`
- 조합폭이 아닌 경우: `ord_exc_wth` 직접 사용

---

### 2.2 `ordCodeChk(PosContext context)`

**목적**: 주문 항목들이 GLUE 마스터 코드에 정의된 유효한 코드값인지 검증

**복잡도**: 중간

**처리 흐름**:

1. Context에서 약 30개 주문 항목 null safe 추출
2. `HashMap codeChkMap`에 유효성 체크 항목 등록:
   - Key: 컬럼명(COL_*), Value: `"에러코드/컬럼코드ID/에러메시지"` 형식
   - 필수 항목: 품명, 제품형태, 유통경로, 주문종류, 주문용도코드, 주문Edge, 수지구분전면 등
   - 비필수 항목: 플랜트구분, 주문표면처리, 주문조도, 주문권취방법 등
3. **고객사코드(CUS_CD) 별도 DB 체크**: `ACT_CUS_CD_SELECT` View 조회
4. **수요가코드(ACT_CUS_CD) 별도 DB 체크**: `ACT_CUS_CD_SELECT` View 조회
5. **최종수요가코드(FNL_CUS_CD) 별도 DB 체크**: `FNL_CUS_CD_SELECT` View 조회
6. **주문포장방법 카테고리 체크**: `ORD_PAK_MTH_SELECT` View (제품형태+포장방법 조합)
7. **품명별 Spangle 구분 체크**: `ORD_SPNL_TP_SELECT` View (품명+Spangle 조합)
8. **품명별 도금량지정 체크**: `GW_ASG_CD_SELECT` View (품명+도금량 조합)
9. `codeChk(ctx, codeChkMap)` 호출로 EasyAccess 코드 일괄 검증
10. 에러 있으면 `info = true` 반환

---

### 2.3 `ordMasterChk(PosContext context)`

**목적**: 주문 마스터 데이터 기준 항목 체크 (필수값 존재여부, 범위값 유효성, CCL BOM 칼라코드 일치 등)

**복잡도**: 매우 높음 (코드 라인 약 2,900여 라인)

**처리 흐름**:

1. Context에서 약 60개 주문 항목 추출 (조합폭 10개 포함)
2. `ArrayList<Double> ord_mix_wth`: 조합폭 값 수집
3. 각 항목별 key 배열(`String[] key1~key30`) 구성: 20개 필드 배열로 항목 식별
4. EasyAccess 규칙(`C10A*`, `C10B*`, `VI_M00_*`) 기반 다수 마스터 체크 수행
5. CCL BOM 칼라코드 일치 여부 체크 (`ccl_bom_hue_cd_frn`, `ccl_bom_hue_cd_bak` 등)
6. 에러 발생 시 `setError()` 호출로 누적

---

### 2.4 `codeChk(PosContext ctx, HashMap codeChkMap)`

**목적**: HashMap으로 전달된 코드 항목들을 EasyAccess를 통해 일괄 검증

**복잡도**: 낮음

**처리 흐름**:

1. `codeChkMap` Iterator 순회
2. 각 항목: `EasyAccess.validateCodeValue(codeID, columnValue, null)` 호출
3. 검증 실패 시: `setError()` 호출
4. `MasterDataException` 시: `setError()` 호출
5. 항상 `true` 반환

---

### 2.5 `setError(PosContext ctx, PosLog logger, String errMsg, String errCode, String[] errParam, String errMsgCD)`

**목적**: 에러 메시지를 쉼표 구분으로 PosContext에 누적 등록

**복잡도**: 낮음

**처리 흐름**:

1. `logger.logError(errMsg)` 에러 로그
2. `C10STR_QLT_DSN_ERR_CD`: 기존 값에 `,에러코드` 누적
3. `COL_XMSGS`: 기존 값에 `,에러메시지` 누적 (null/"" 방어 처리)

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 고객사양번호 접두사 | `cus_bth_pap_no`가 `fnl_cus_cd`로 시작 안 함 | A223 오류 |
| 2 | 주문용도코드 상이 | 주문용도코드 ≠ 고객공통 주문용도코드 | A243 오류 |
| 3 | 규격약호 상이 | 주문규격약호 ≠ 고객공통 규격약호 | A244 오류 |
| 4 | 주문두께 범위 | 주문두께 < 고객공통 두께하한 또는 > 상한 | A248 오류 |
| 5 | 조합폭 범위 | (slit수 × 조합폭) < 폭하한 또는 > 폭상한 | A249 오류 |
| 6 | 주문길이 범위 (Sheet) | 제품형태 = SHEET이고 길이 하한/상한 이탈 | A250 오류 |
| 7 | 두께구분코드 | 고객공통 두께구분 null이면 주문두께구분이 "3"이면 오류 | A251 오류 |
| 8 | 고객사코드 미존재 | `ACT_CUS_CD_SELECT` 조회 결과 0건 | ERRMSG_A231 오류 |
| 9 | 고객사코드 중복 | `ACT_CUS_CD_SELECT` 조회 결과 >1건 | ERRMSG_A232 오류 |
| 10 | 최종 에러 여부 | `COL_XMSGS`가 null이면 SUCCESS | `PosBizControlConstants.SUCCESS` |
| 11 | 최종 에러 여부 | `COL_XMSGS`가 null이 아니면 FAILURE | `PosBizControlConstants.FAILURE` |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 위치 |
|---------|------|-----------|
| `VI_M00_C10A1020` | 고객공통 View 조회 | `runActivity` - 고객공통기준 체크 |
| `VI_M00_C10A1010` | 규격공통 View 조회 | `runActivity` - 규격공통기준 체크 |
| `ACT_CUS_CD_SELECT` | 고객사코드 유효성 체크 | `ordCodeChk` (CUS_CD, ACT_CUS_CD) |
| `FNL_CUS_CD_SELECT` | 최종수요가코드 유효성 체크 | `ordCodeChk` (FNL_CUS_CD) |
| `ORD_PAK_MTH_SELECT` | 제품형태별 포장방법 카테고리 체크 | `ordCodeChk` |
| `ORD_SPNL_TP_SELECT` | 품명별 Spangle구분 체크 | `ordCodeChk` |
| `GW_ASG_CD_SELECT` | 품명별 도금량지정 체크 | `ordCodeChk` |

**EasyAccess 마스터 규칙** (`ordMasterChk` 내에서 다수 사용):
- `C10NuiConstantsIF`에 정의된 마스터 데이터 ID로 `EasyAccess.validateCodeValue()` 호출

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

OMS(주문관리시스템)에서 C10 MES로 전달된 생산가부요청 주문 데이터를 처리하기 전 데이터 정합성을 사전에 검증하는 역할이다. 주문이 고객공통사양과 불일치하거나, 마스터코드에 미등록된 값을 갖거나, 범위를 초과하는 경우를 탐지하여 이후 품질설계 프로세스 진입 전에 오류를 걸러낸다.

**설계 특징**:
- 에러 발생 시 즉시 반환하지 않고 모든 항목 체크 후 에러를 누적하는 방식 (대부분의 `return FAILURE`가 주석 처리)
- 에러 메시지는 `COL_XMSGS`에 쉼표 구분으로 누적되어 한 번의 호출로 모든 오류 파악 가능
- `setError()` 메소드로 에러 누적 패턴 통일

### 6.2 조합폭(Slit 폭) 계산

```
조건: ord_slit_grp_cnt > 0 AND ord_exc_wth == ord_mix_wth1
조합폭 = ord_slit_grp_cnt × ord_mix_wth1  (동일 폭 조합)
기타:  ord_exc_wth 직접 사용
```

이후 2016.08.17 변경으로 조합폭 단순 합산 방식도 지원: `exc_wth = ord_mix_wth1 + ... + ord_mix_wth10`
