# DbSearchDeliSpec 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchDeliSpec.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 693 라인 |
| 메소드 수 | 1개 (runActivity) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

품질설계 NUI(배치) 프로세스에서 인수도사양(공차 기준)을 편성하는 클래스이다. Service Property `prodSpecKind` 값에 따라 고객인수도사양(1), 규격인수도사양(2), 보증사양(4) 세 가지 처리 경로로 분기하여, 두께/폭/길이 공차 하한/상한값을 Master Data에서 조회하고 PosContext에 저장한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크 Activity. `runActivity(PosContext)`가 진입점.
- `C10NuiConstantsIF` 구현: View명 상수(VI_M00_C10A1023, VI_M00_C10A2181, VI_M00_C10A2182, VI_M00_C10A1010), EasyAccess 정의명(C10B1013, C10B2180), SQL Key 상수(SELECT_DLV), 에러코드 상수 제공.

### 1.2 핵심 입력/출력

**입력**

| 출처 | 키/속성 | 변수명 | 설명 |
|------|--------|--------|------|
| Property | C10PN_PROSPECKIND | prodSpecKind | 인수도사양 종류 (1, 2, 4) |
| Property | DAO | dao | masterdao 또는 m00dao |
| PosContext | COL_CUS_BTH_PAP_NO | cus_bth_pap_no | 고객사양번호 (kind=1) |
| PosContext | COL_ORD_THK_MNG_CD | ord_thk_mng_cd | 주문두께관리코드 (kind=1) |
| PosContext | COL_ORD_WTH_MNG_CD | ord_wth_mng_cd | 주문폭관리코드 (kind=1) |
| PosContext | COL_ORD_LTH_MNG_CD | ord_lth_mng_cd | 주문길이관리코드 (kind=1) |
| PosContext | COL_PRD_NM_CD | prd_nm_cd | 품명코드 |
| PosContext | COL_PRD_SHP | prd_shp | 제품형태 |
| PosContext | COL_ACPT_RT_SPC | acrt_rt_spc | 인수도규격 |
| PosContext | COL_ORD_EDG_ASG_TP | ord_edg_asg_tp | 주문 EDGE 지정구분 |
| PosContext | COL_ORD_EXC_THK | ord_exc_thk | 주문환산두께 |
| PosContext | COL_ORD_EXC_WTH | ord_exc_wth | 주문환산폭 |
| PosContext | COL_ORD_EXC_LTH | ord_exc_lth | 주문환산길이 |
| PosContext | COL_SPC_AVR | spc_avr | 규격약호 (kind=2) |
| PosContext | COL_SPC_YR | spc_yr | 규격연도 (kind=2) |
| PosContext | COL_ORD_NO / COL_ORD_LN | - | 주문번호/라인 (kind=4) |

**출력 (PosContext에 저장)**

| 컬럼키 | 설명 |
|--------|------|
| COL_QLT_DSN_SPC_TP | 품질설계 사양구분 (prodSpecKind) |
| COL_THK_TLN_LLV / COL_THK_TLN_ULV | 두께공차 하한/상한 |
| COL_WTH_TLN_LLV / COL_WTH_TLN_ULV | 폭공차 하한/상한 |
| COL_LTH_TLN_LLV / COL_LTH_TLN_ULV | 길이공차 하한/상한 |
| COL_ORD_GRA | 규격 등급 (kind=2, COL_GRA 값을 여기에 저장) |
| VI_M00_C10A1010 조회 결과 전체 컬럼 | 규격인수도사양 (kind=2) |
| COL_QLT_DSN_ERR_CD | 에러코드 (에러 시) |

**반환값**

- `PosBizControlConstants.SUCCESS`: 정상 처리
- `PosBizControlConstants.FAILURE`: 에러 발생

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

**목적**: prodSpecKind에 따라 인수도사양(공차) 데이터를 조회하고 PosContext에 저장

**복잡도**: 높음 (3방향 분기, EasyAccess 2종, DAO View 5종, 복잡한 공차 합성 로직)

**처리 흐름**

#### 공통 초기화 (라인 97~105)

```
prodSpecKind = this.getProperty(C10PN_PROSPECKIND).trim()
ctx.put(COL_QLT_DSN_SPC_TP, prodSpecKind)
dao = this.getDao(this.getProperty(PosServiceParamIF.DAO))
```

---

#### 경로 1: prodSpecKind = "1" (고객인수도사양) (라인 128~397)

**Step 1-1. PosContext 입력값 추출**
- cus_bth_pap_no, ord_thk_mng_cd, ord_wth_mng_cd, ord_lth_mng_cd, prd_nm_cd 등

**Step 1-2. 최초주문입력값 저장 (주문공차 → Context 설정)**
- COL_ORD_THK_TLN_LLV → COL_THK_TLN_LLV
- COL_ORD_THK_TLN_ULV → COL_THK_TLN_ULV
- COL_ORD_WTH_TLN_LLV → COL_WTH_TLN_LLV
- COL_ORD_WTH_TLN_ULV → COL_WTH_TLN_ULV
- COL_ORD_LTH_TLN_LLV → COL_LTH_TLN_LLV
- COL_ORD_LTH_TLN_ULV → COL_LTH_TLN_ULV

**Step 1-3. 고객사양번호가 있는 경우: VI_M00_C10A1023 조회 (고객인수도View)**
- 조건: cus_bth_pap_no
- 처리 시작 시 ord_thk_mng_cd, ord_wth_mng_cd, ord_lth_mng_cd를 SPACE로 강제 초기화
- 결과=1: 각 컬럼명(cname)별 처리
  - THK_TLN_LLV/ULV: ord_thk_mng_cd = SPACE인 경우만 저장
  - WTH_TLN_LLV/ULV: ord_wth_mng_cd = SPACE인 경우만 저장
  - LTH_TLN_LLV/ULV: ord_lth_mng_cd = SPACE인 경우만 저장
  - 나머지 컬럼: 무조건 저장
- 결과>1: 에러 ERRCD_KS18, FAILURE
- 결과=0: 에러 처리 없음 (주석 처리됨)

**Step 1-4. 관리코드 조건 확인**

조건: 두께/폭/길이 관리코드가 모두 SPACE 또는 'Z'
```
(ord_thk_mng_cd = SPACE OR 'Z') AND
(ord_wth_mng_cd = SPACE OR 'Z') AND
(ord_lth_mng_cd = SPACE OR 'Z')
→ SUCCESS 반환 (마스터 미적용)
```

**Step 1-5. 두께 관리코드 처리 (ord_thk_mng_cd ≠ SPACE AND ≠ 'Z')**

EasyAccess C10B1013 조회 (규격인수도 기준):
- 조건항목 7개: [acrt_rt_spc, prd_nm_cd, prd_shp, ord_edg_asg_tp, ord_exc_thk, ord_exc_wth, ord_exc_lth]
- 결과=1:
  - 두께 하한: EasyAccess.getPosCalc(C10B2180, [THK_TLN_LLV, THK_TLN_ULV, ord_thk_mng_cd, "L"])
    → COL_THK_TLN_LLV = posCalcVO.getResultValue()
  - 두께 상한: EasyAccess.getPosCalc(C10B2180, [THK_TLN_LLV, THK_TLN_ULV, ord_thk_mng_cd, "BU"])
    → COL_THK_TLN_ULV = posCalcVO.getResultValue()
- 결과>1: 에러 ERRCD_KS21, FAILURE
- 결과=0 또는 예외: 에러 ERRCD_KS30, FAILURE

**Step 1-6. 폭 관리코드 처리 (ord_wth_mng_cd ≠ SPACE AND ≠ 'Z')**

DAO 조회: VI_M00_C10A2181 (폭공차View)
- 조건: ord_wth_mng_cd
- 결과=1: COL_WTH_TLN_LLV, COL_WTH_TLN_ULV 저장
- 결과>1: 에러 ERRCD_KS19, FAILURE
- 결과=0: 에러 ERRCD_KS09, FAILURE

**Step 1-7. 길이 관리코드 처리 (ord_lth_mng_cd ≠ SPACE AND ≠ 'Z')**

DAO 조회: VI_M00_C10A2182 (길이공차View)
- 조건: ord_lth_mng_cd
- 결과=1: COL_LTH_TLN_LLV, COL_LTH_TLN_ULV 저장
  - 단, 내부 적용 조건이 `ord_wth_mng_cd ≠ SPACE AND ≠ 'Z'`로 코딩되어 있어, 폭관리코드가 없으면 길이공차 저장이 누락될 수 있음 (라인 389 버그 의심)
- 결과>1: 에러 ERRCD_KS20, FAILURE
- 결과=0: 에러 ERRCD_KS10, FAILURE

---

#### 경로 2: prodSpecKind = "2" (규격인수도사양) (라인 399~520)

**Step 2-1. PosContext 입력값 추출**
- spc_avr(규격약호), spc_yr(규격연도), prd_nm_cd, prd_shp, ord_edg_asg_tp, ord_exc_thk/wth/lth

**Step 2-2. VI_M00_C10A1010 조회 (규격공통View)**
- 조건: (spc_avr, spc_yr)
- 결과=1: 모든 컬럼 ctx에 저장
  - 제외 컬럼: COL_SPC_AVR, COL_SPC_YR, COL_GRA, COL_MDL_DEFINE_NM, COL_MDL_DEFINE_EXPLAIN
  - COL_GRA → COL_ORD_GRA로 컬럼명 변환하여 저장
- 결과>1: 에러 ERRCD_KS11, FAILURE
- 결과=0: 에러 ERRCD_KS01, FAILURE

**Step 2-3. EasyAccess C10B1013 조회 (규격인수도 기준)**
- 조건항목 7개: [acrt_rt_spc, prd_nm_cd, prd_shp, ord_edg_asg_tp, ord_exc_thk, ord_exc_wth, ord_exc_lth]
- acrt_rt_spc: ctx.get(COL_ACPT_RT_SPC) 에서 직접 가져옴
- 결과=1: itemNameRow Iterator로 모든 결과 컬럼을 PosContext에 저장
- 결과>1: 에러 ERRCD_KS21, FAILURE
- 결과=0 또는 예외: 에러 ERRCD_KS30, FAILURE

---

#### 경로 3: prodSpecKind = "4" (보증사양) (라인 522~688)

**Step 3-1. 고객사양 조회: SELECT_DLV (조건: ord_no, ord_ln, NUM1)**
- 결과 != 0: 모든 컬럼 PosContext에 저장

**Step 3-2. 규격사양 조회: SELECT_DLV (조건: ord_no, ord_ln, NUM2)**
- 결과 = 0: 에러 ERRCD_KS24, FAILURE

**Step 3-3. 보증사양 편집 - 고객사양 + 규격사양 합성**

각 컬럼별 합성 규칙:

두께공차 (THK_TLN_LLV/ULV):
```
조건: ctx의 상하한 둘 다 NULL인 경우만 규격사양 적용
적용값: DbCommonUtil.numCompare(ctx값, row2값, true) → 더 큰 값
```

폭공차 (WTH_TLN_LLV/ULV) - 품명 E/C/D인 경우 (2024.06.13):
```
하한: DbCommonUtil.numCompare(ctx값, row2값, true) → 더 큰 값
상한 - 둘 중 하나라도 NULL: DbCommonUtil.numCompare(ctx값, row2값, true) → 더 큰 값
상한 - 둘 다 값 있음:
  num1 = Double.parseDouble(ctx.get(COL_WTH_TLN_ULV))
  num2 = Double.parseDouble(row2.getAttribute(COL_WTH_TLN_ULV))
  WTH_TLN_ULV = Math.min(num1, num2)  [더 엄격한(작은) 값]
```

폭공차 (WTH_TLN_LLV/ULV) - 그 외 품명:
```
조건: ctx의 상하한 둘 다 NULL인 경우만 규격사양 적용 (더 큰 값)
```

길이공차 (LTH_TLN_LLV/ULV):
```
조건: ctx의 상하한 둘 다 NULL인 경우만 규격사양 적용 (더 큰 값)
```

그 외 컬럼:
```
조건: DbCommonUtil.isNull(ctx.get(cname)) → NULL인 경우만 규격사양 값으로 설정
```

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 품질설계 사양구분 저장 | 항상 | ctx.put(COL_QLT_DSN_SPC_TP, prodSpecKind) |
| 2 | 관리코드 없으면 SUCCESS 조기 반환 | kind=1, 두께/폭/길이 관리코드 모두 SPACE 또는 Z | SUCCESS 반환 (마스터 미적용) |
| 3 | 고객인수도 두께공차 우선순위 | kind=1, ord_thk_mng_cd = SPACE | 고객인수도(VI_M00_C10A1023) 값 적용 |
| 4 | 두께관리코드 우선순위 | kind=1, ord_thk_mng_cd ≠ SPACE, ≠ Z | C10B1013+C10B2180으로 계산된 공차 적용 |
| 5 | 폭관리코드 처리 | kind=1, ord_wth_mng_cd ≠ SPACE, ≠ Z | VI_M00_C10A2181 조회 후 적용 |
| 6 | 길이관리코드 처리 | kind=1, ord_lth_mng_cd ≠ SPACE, ≠ Z | VI_M00_C10A2182 조회 후 적용 |
| 7 | 규격공통 등급 컬럼 변환 | kind=2, COL_GRA 컬럼 | COL_ORD_GRA로 저장 |
| 8 | 규격사양 제외 컬럼 | kind=2 | SPC_AVR, SPC_YR, GRA, MDL_DEFINE_NM, MDL_DEFINE_EXPLAIN 저장 제외 |
| 9 | 보증사양 두께공차 합성 | kind=4, ctx 두께 상하한 둘 다 NULL | 규격사양 적용 (더 큰 값, numCompare) |
| 10 | 보증사양 폭공차 상한 강화 (2024.06.13) | kind=4, 품명 E/C/D, 양쪽 상한값 모두 존재 | Math.min(고객사양 상한, 규격사양 상한) → 더 엄격한 값 |
| 11 | 보증사양 폭공차 합성 (그 외 품명) | kind=4, ctx 상하한 둘 다 NULL | 규격사양 적용 (더 큰 값) |
| 12 | 보증사양 일반 컬럼 합성 | kind=4, ctx값 NULL | 규격사양 값으로 설정 (고객사양 우선) |
| 13 | C10B2180 하한 계산 | kind=1 두께 처리 | 인자: [THK_TLN_LLV, THK_TLN_ULV, ord_thk_mng_cd, "L"] |
| 14 | C10B2180 상한 계산 | kind=1 두께 처리 | 인자: [THK_TLN_LLV, THK_TLN_ULV, ord_thk_mng_cd, "BU"] |
| 15 | 고객인수도 관리코드 초기화 | kind=1, VI_M00_C10A1023 조회 시작 전 | ord_thk/wth/lth_mng_cd = SPACE 강제화 |

---

## 4. SQL 매핑

| SQL Key / View | 용도 | 조건 파라미터 | 호출 시점 |
|----------------|------|--------------|-----------|
| VI_M00_C10A1023 | 고객인수도View (cus_bth_pap_no로 공차 조회) | cus_bth_pap_no | kind=1, 고객사양번호 있을 때 |
| C10B1013 | 규격인수도 기준 EasyAccess (7개 조건 → 공차 기준값) | acrt_rt_spc, prd_nm_cd, prd_shp, ord_edg_asg_tp, ord_exc_thk, ord_exc_wth, ord_exc_lth | kind=1 두께관리코드 있을 때, kind=2 |
| C10B2180 | 두께 공차 계산 EasyAccess (하한/상한 각 1회) | [THK_TLN_LLV, THK_TLN_ULV, ord_thk_mng_cd, L or BU] | kind=1 두께관리코드 있을 때 |
| VI_M00_C10A2181 | 폭공차View | ord_wth_mng_cd | kind=1, 폭관리코드 있을 때 |
| VI_M00_C10A2182 | 길이공차View | ord_lth_mng_cd | kind=1, 길이관리코드 있을 때 |
| VI_M00_C10A1010 | 규격공통View | spc_avr, spc_yr | kind=2 |
| SELECT_DLV | 품질설계결과인수도 조회 | ord_no, ord_ln, NUM1(고객) / NUM2(규격) | kind=4 (각각 1회) |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 자동화에서 인수도 공차를 결정한다. 인수도는 납품 검사 기준으로, 두께/폭/길이의 허용 오차 범위를 정의한다. 동일 클래스가 세 종류의 인수도사양 편성을 담당한다:

- **고객인수도사양(1)**: 특정 고객과 합의된 별도 사양. 고객사양번호로 마스터 조회 후, 두께/폭/길이 관리코드에 따라 EasyAccess 기준 공차 계산 적용.
- **규격인수도사양(2)**: KS, JIS 등 공개 규격 기반 사양. 규격약호+연도로 공통 View 조회 후 인수도 기준 공차 결정.
- **보증사양(4)**: 고객사양과 규격사양을 합성하여 보증 공차를 결정. 고객사양 우선, 없을 때만 규격사양 적용. 폭 상한은 품명별로 더 엄격한 기준(최솟값) 적용.

### 6.2 핵심 설계 의도

- **관리코드 Z 처리**: 관리코드 'Z'는 "조정 없음"을 의미하여 SPACE와 동일하게 취급.
- **고객인수도 우선원칙**: kind=1에서 VI_M00_C10A1023 조회 시 ord_thk/wth/lth_mng_cd를 SPACE로 강제 초기화하여, 고객사양번호로 조회한 값이 기본 동작하고 주문 관리코드 유무에 따라 공차값 덮어쓰기 여부를 제어.
- **보증사양 폭 상한 강화 (2024.06.13)**: 품명 E(EGI)/C(구매CR)/D(F/H)의 경우 폭 상한은 고객사양과 규격사양 중 더 작은(엄격한) 값을 채택. 아연도금계 제품의 폭 치수 품질 강화 목적.

### 6.3 주의사항

- **라인 389 버그 의심**: kind=1 길이관리코드 처리 블록 내부에서 길이공차 ctx 저장 조건으로 `ord_lth_mng_cd` 대신 `ord_wth_mng_cd`를 사용. 폭관리코드가 SPACE/Z인데 길이관리코드가 있는 경우, 길이공차 저장이 누락될 수 있음.
- **prodSpecKind 1/2/4 외 값**: 해당 경로 없이 바로 SUCCESS 반환.
- **ArrayList raw type**: Java 1.6 코드로 제네릭 없이 raw ArrayList 사용.
- **고객인수도 미존재**: C10A1023 결과 0건은 에러 처리 없이 계속 진행 (주석 처리됨).
