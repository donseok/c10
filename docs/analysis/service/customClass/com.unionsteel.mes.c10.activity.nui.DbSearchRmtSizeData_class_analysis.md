# DbSearchRmtSizeData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchRmtSizeData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 809 라인 |
| 메소드 수 | 1개 (runActivity) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

품질설계 자동화 프로세스에서 원자재 Size를 편성하는 클래스이다. 주문 정보(품명코드, 두께, 폭)와 공정 목표값을 기반으로 Master Data(EasyAccess 룰 엔진)를 조회하여 원자재 목표 두께와 목표 폭을 계산하고, 그 결과를 PosContext에 저장한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크 Activity 기반 클래스. `runActivity(PosContext)`를 진입점으로 사용한다.
- `C10NuiConstantsIF` 구현: 품명코드 상수(`PRD_NM_CD_5`, `PRD_NM_CD_7`, `PRD_NM_CD_C`, `PRD_NM_CD_D`, `PRD_NM_CD_E` 등), EasyAccess 마스터 정의명 상수(`C10B1071`, `C10B1073`, `C10B1074`, `C10B2230`, `C10B2310`), 에러코드 상수(`ERRCD_KK91`, `ERRCD_KT04` 등)를 제공한다.

### 1.2 핵심 입력/출력

**입력 (PosContext에서 추출)**

| 컬럼키 | 변수명 | 설명 |
|--------|--------|------|
| COL_PRD_NM_CD | prd_nm_cd | 품명코드 |
| COL_RMTL_CD | rmtl_cd | 원자재코드 |
| COL_PLTCM_THK_TRV | pltcm_thk_trv | PLTCM 두께 목표값 |
| COL_PLTCM_SET_THK_TRV | pltcm_set_thk_trv | PLTCM X-Ray Set치 |
| COL_PLTCM_WTH_TRV | pltcm_wth_trv1 | PLTCM 주공정 폭 목표값 |
| COL_PLTCM_WTH_SUB_PROC1_TRV | pltcm_wth_trv2 | PLTCM 대체공정1 폭 목표값 |
| COL_PLTCM_WTH_SUB_PROC2_TRV | pltcm_wth_trv3 | PLTCM 대체공정2 폭 목표값 |
| COL_ORD_EDG_ASG_TP | ord_edg_asg_tp | 주문 EDGE 지정구분 |
| COL_ORD_EXC_THK | ord_exc_thk | 주문 환산두께 |
| COL_ORD_EXC_WTH | ord_exc_wth | 주문 환산폭 |
| COL_COR_WTH_TRV | cor_wth_trv | 제품 목표폭 |
| COL_FNL_CUS_CD | fnl_cus_cd | 최종고객사코드 |
| COL_ORD_SLIT_GRP_CNT | ord_slit_grp_cnt | SLIT 조수 |
| COL_ORD_MIX_WTH1~10 | ord_mix_wth1~10 | 혼합폭 1~10 |
| COL_CGL_THK_TRV / COL_CGL_WTH_TRV | cgl_thk_trv / cgl_wth_trv | CGL 두께/폭 목표값 |
| COL_EGL_THK_TRV / COL_EGL_WTH_TRV | egl_thk_trv / egl_wth_trv | EGL 두께/폭 목표값 |
| COL_TM_THK_TRV / COL_TM_WTH_TRV | tm_thk_trv / tm_wth_trv | TM 두께/폭 목표값 |
| COL_ORD_THK_MNG_CD | ord_thk_mng_cd | 두께관리코드 |
| COL_ORD_USG_CD | ord_usg_cd | 주문용도코드 |
| COL_CUS_CD | cus_cd | 고객사코드 |

**출력 (PosContext에 저장)**

| 컬럼키 | 설명 |
|--------|------|
| COL_RMTL_TAR_THK | 원자재 목표두께 |
| COL_RMTL_TAR_THK_LVL | 원자재 목표두께 하한 |
| COL_RMTL_TAR_THK_UVL | 원자재 목표두께 상한 |
| COL_RMTL_TAR_WTH | 원자재 목표폭 (반올림 정수) |
| COL_RMTL_CD | 원자재코드 (중간재인 경우 갱신) |
| COL_QLT_DSN_ERR_CD | 품질설계 에러코드 (에러 시) |

**반환값**

- `PosBizControlConstants.SUCCESS`: 정상 처리 완료
- `PosBizControlConstants.FAILURE`: 에러 발생 (에러코드 PosContext에 저장됨)

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

**목적**: 원자재 목표 두께 및 목표 폭 계산 전체 흐름 제어

**복잡도**: 매우 높음 (중첩 조건 분기 6단계, EasyAccess 4회 이상 호출, 예외 처리 다수)

**처리 흐름**

#### Step 1. PosContext에서 입력값 추출 (라인 181~283)

모든 컬럼을 `DbCommonUtil.isNull()` 로 null 체크 후 지역변수에 할당한다.

PLTCM 폭 최대값 계산:
```
max_pltcm_wth_trv = max(pltcm_wth_trv1, pltcm_wth_trv2, pltcm_wth_trv3)
```

SLIT 혼합폭 합산:
```
조건: ord_slit_grp_cnt > 0
ord_exc_wth = ord_mix_wth1 + ord_mix_wth2 + ... + ord_mix_wth10
그 외: ord_exc_wth = ctx.get(COL_ORD_EXC_WTH)
```

#### Step 2. 중간재 적용기준 조회 - 알루미늄칼라/스테인레스칼라 제외 (라인 288~481)

조건: 품명코드 ≠ PRD_NM_CD_5 AND 품명코드 ≠ PRD_NM_CD_7 (알루미늄칼라, 스테인레스칼라 제외)

**2-1. EasyAccess C10B2230 조회 (중간재 적용기준)**
- 조건항목: [품명코드, 주문두께, 주문폭, 최종고객사, 고객사양번호, CCL_BOM_NO]
- 결과=1: sem_prd_nm_cd = 중간재품명코드 / 원자재코드 갱신: `sem_prd_nm_cd + rmtl_cd.substring(1)`
- 결과>1: 에러 ERRCD_KK91, FAILURE 반환
- MasterDataException: result = null (에러처리 없음)

원자재코드 첫 자리가 'H' 또는 'M'이 아닌 경우:
```
sem_prd_nm_cd = rmtl_cd.substring(0,1)
```

**2-2. sem_prd_nm_cd = SPACE인 경우 (중간재 없음) - EasyAccess C10B1071 조회 (원자재 두께기준)**
- 조건항목: [원자재코드, PLTCM X-Ray Set치, PLTCM 폭]
- 주문EDGE구분이 NO_SLIT 또는 COIL_EDGE인 경우: PLTCM 폭 = max_pltcm_wth_trv + 20
- 그 외: PLTCM 폭 = max_pltcm_wth_trv
- 결과=1: 원자재두께(RMTL_TAR_THK), 원자재두께1~5 중 최솟값(하한), 최댓값(상한) 편집
- 결과>1: 에러 ERRCD_KT11, FAILURE
- 결과=0 또는 예외: 에러 ERRCD_KT06, FAILURE

**2-3. EasyAccess C10B1074 조회 (PLTCM 폭수축량기준)**
- 조건항목: [원자재코드, PLTCM두께, PLTCM폭]
- 결과=1: tcm_wth_shr_qty = PLTCM폭수축량최대값
- 결과≠1: 에러, FAILURE

**2-4. EasyAccess C10B1073 조회 (PLTCM 폭마진량기준)**
- 조건항목: [원자재코드, 원자재두께, PLTCM폭, 최종고객사코드]
- 결과=1: mrg_wth = PLTCM폭마진량
- 결과≠1: 에러, FAILURE

#### Step 3. 원자재 목표두께 및 목표폭 최종 편성 (라인 484~806)

**3-1. 품명코드 = PRD_NM_CD_5 또는 PRD_NM_CD_7 (알루미늄칼라, 스테인레스칼라)**
```
원자재목표두께 = 원자재목표두께하한 = 원자재목표두께상한 = 주문두께(ord_exc_thk)
원자재목표폭 = round(cor_wth_trv)    [제품목표폭 반올림]
```

**3-2. 그 외 품명코드**

(a) sem_prd_nm_cd = SPACE (중간재 없음)
- 품명 A 또는 B인 경우: 두께를 주문두께(ord_exc_thk)로 덮어씀
- 주문EDGE지정구분 = COIL_EDGE(C):
  ```
  원자재목표폭 = round(max_pltcm_wth_trv)
  ```
- 주문EDGE지정구분 = NO_SLIT(N), 품명 G/K/J/L/V/W/3/4/6/9 (CGL 계열):
  ```
  원자재목표폭 = round(max_pltcm_wth_trv)   [C10B1075 주석처리됨]
  ```
- 주문EDGE지정구분 = NO_SLIT(N), 품명 E/2/N/8 (EGL 계열):
  ```
  원자재목표폭 = round(max_pltcm_wth_trv)   [C10B1076 주석처리됨]
  ```
- 그 외 NO_SLIT:
  ```
  원자재목표폭 = round(cor_wth_trv)   [제품목표폭]
  ```
- 주문EDGE지정구분 = 그 외:
  ```
  원자재목표폭 = round(max_pltcm_wth_trv + tcm_wth_shr_qty + mrg_wth)
  ```

(b) sem_prd_nm_cd = PRD_NM_CD_D (F/H 중간재, 2019.03.26~)
- EasyAccess C10B2310 조회 (FH 두께설계기준), 우선순위 조합으로 순차 탐색:
  - 주문용도코드 우선순위: [그대로, 앞3자리+"***", 앞1자리+"*****", "******"]
  - 고객사코드 우선순위: [그대로, "******"]
  - 조건항목: [두께관리코드, 품명, 주문용도코드, 고객사코드, 두께]
  - 결과=1:
    ```
    원자재목표두께하한 = pltcm_thk_trv + fh_thk_llv
    원자재목표두께상한 = pltcm_thk_trv + fh_thk_ulv
    원자재목표두께 = pltcm_thk_trv
    원자재목표폭 = pltcm_wth_trv
    ```
  - 모든 조합 실패 시: 에러 ERRCD_KT37, FAILURE

(c) sem_prd_nm_cd = PRD_NM_CD_C (TM 중간재, CR 구매)
- 원자재코드가 C25/C32/C70/C7B/C7T인 경우:
  ```
  원자재목표두께하한 = round2(tm_thk_trv * 0.98)
  원자재목표두께상한 = round2(tm_thk_trv)
  ```
- 그 외:
  ```
  원자재목표두께하한 = round2(tm_thk_trv * 0.95)
  원자재목표두께상한 = round2(tm_thk_trv * 1.05)
  ```
- 원자재목표두께 = tm_thk_trv
- 품명 E인 경우: `원자재목표폭 = round(tm_wth_trv - 3)`
- 그 외: `원자재목표폭 = round1((tm_wth_trv - 3) * 10) / 10`  [소수점 1자리 반올림]

(d) sem_prd_nm_cd = PRD_NM_CD_G/L/V/W (CGL 중간재)
  ```
  원자재목표두께하한 = round2(cgl_thk_trv * 0.95)
  원자재목표두께상한 = round2(cgl_thk_trv * 1.05)
  원자재목표두께 = cgl_thk_trv
  원자재목표폭 = round1((cgl_wth_trv - 1) * 10) / 10   [소수점 1자리 반올림]
  ```

(e) sem_prd_nm_cd = PRD_NM_CD_E/N (EGL 중간재)
  ```
  원자재목표두께하한 = round2(egl_thk_trv * 0.95)
  원자재목표두께상한 = round2(egl_thk_trv * 1.05)
  원자재목표두께 = egl_thk_trv
  원자재목표폭 = round1((egl_wth_trv - 1) * 10) / 10
  ```

> round2: (값 * 100) → Math.round → / 100 (소수점 2자리 반올림)
> round1: (값 * 10) → Math.round → / 10 (소수점 1자리 반올림)

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | PLTCM 폭 최대값 선택 | 항상 | max(주공정폭, 대체공정1폭, 대체공정2폭) |
| 2 | SLIT 혼합폭 합산 | ord_slit_grp_cnt > 0 | ord_exc_wth = MIX_WTH1~10 합산 |
| 3 | 알루미늄/스테인레스 칼라 두께 | PRD_NM_CD_5 또는 7 | 원자재두께 = 주문두께 |
| 4 | 알루미늄/스테인레스 칼라 폭 | PRD_NM_CD_5 또는 7 | 원자재폭 = round(제품목표폭) |
| 5 | H/C 두께 선정 개선 (2023.6.7) | NO_SLIT 또는 COIL_EDGE | C10B1071 조건폭 = PLTCM폭 + 20 |
| 6 | PO제품 두께 주문두께 적용 | 품명 A 또는 B, 중간재 없음 | 두께 = 주문두께 |
| 7 | COIL_EDGE 원자재폭 | ord_edg_asg_tp = C | round(max_pltcm_wth_trv) |
| 8 | NO_SLIT CGL계열 원자재폭 | ord_edg_asg_tp = N, 품명 G/K/J/L/V/W/3/4/6/9 | round(max_pltcm_wth_trv) |
| 9 | NO_SLIT EGL계열 원자재폭 | ord_edg_asg_tp = N, 품명 E/2/N/8 | round(max_pltcm_wth_trv) |
| 10 | NO_SLIT 그 외 원자재폭 | ord_edg_asg_tp = N, 나머지 품명 | round(제품목표폭) |
| 11 | SLIT 원자재폭 | ord_edg_asg_tp = 그 외 | round(PLTCM폭 + 폭수축량 + 폭마진량) |
| 12 | 구매CR TM 두께범위 좁음 | rmtl_cd = C25/C32/C70/C7B/C7T | 하한=TM두께*0.98, 상한=TM두께 |
| 13 | 구매CR TM 두께범위 넓음 | 그 외 구매CR | 하한=TM두께*0.95, 상한=TM두께*1.05 |
| 14 | CGL 중간재 두께범위 | sem_prd_nm_cd = G/L/V/W | CGL두께*0.95 ~ CGL두께*1.05 |
| 15 | EGL 중간재 두께범위 | sem_prd_nm_cd = E/N | EGL두께*0.95 ~ EGL두께*1.05 |
| 16 | FH 두께설계 우선순위 탐색 | sem_prd_nm_cd = D | 용도코드 4단계 × 고객사코드 2단계 순차탐색 |
| 17 | 중간재 원자재코드 갱신 | C10B2230 결과=1 | rmtl_cd = sem_prd_nm_cd + rmtl_cd.substring(1) |

---

## 4. SQL 매핑

이 클래스는 SQL(DAO)을 직접 호출하지 않고 EasyAccess 룰 엔진만 사용한다.

| EasyAccess 정의명 | 용도 | 호출 시점 |
|-------------------|------|-----------|
| C10B2230 | 중간재 적용기준: 품명+두께+폭 → 중간재품명코드 | 품명이 5,7이 아닐 때 |
| C10B1071 | 원자재두께기준: 원자재코드+XRay Set치+PLTCM폭 → 원자재두께, 두께1~5 | sem_prd_nm_cd = SPACE 시 |
| C10B1074 | PLTCM폭수축량기준: 원자재코드+PLTCM두께+PLTCM폭 → 폭수축량 | sem_prd_nm_cd = SPACE 시 |
| C10B1073 | PLTCM폭마진량기준: 원자재코드+원자재두께+PLTCM폭+고객사 → 폭마진량 | sem_prd_nm_cd = SPACE 시 |
| C10B2310 | FH두께설계기준: 두께관리코드+품명+용도+고객사+두께 → 두께 하한/상한 | sem_prd_nm_cd = D 시 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 NUI(배치) 프로세스에서, 고객 주문의 최종 제품 사양으로부터 원자재(HR 코일 등)를 구매하거나 중간재 공정을 거쳐야 할 때 원자재의 목표 두께와 목표 폭을 자동으로 계산한다. 제품 종류(품명코드), 중간재 경로, 공정 방법(EDGE 지정구분)에 따라 계산 로직이 달라진다.

### 6.2 핵심 처리 경로 분기

1. **직접 원자재 경로 (sem_prd_nm_cd = SPACE)**: H/C 공정을 직접 원자재로 투입. 원자재 두께는 C10B1071로 결정, 폭은 EDGE 지정구분에 따라 결정.
2. **TM 중간재 경로 (sem_prd_nm_cd = C)**: TM(탠덤밀) 통과 후 연속용융아연도금. TM 목표값을 기준으로 원자재 편성.
3. **FH 중간재 경로 (sem_prd_nm_cd = D)**: 풀하드(Full Hard) 경로. 주문용도+고객사 우선순위 탐색으로 두께 보정값 결정.
4. **CGL 중간재 경로 (sem_prd_nm_cd = G/L/V/W)**: 연속용융아연도금 경로의 중간재.
5. **EGL 중간재 경로 (sem_prd_nm_cd = E/N)**: 전기아연도금 경로의 중간재.
6. **특수 제품 (PRD_NM_CD_5/7, 알루미늄칼라/스테인레스칼라)**: 원자재 치수 = 제품 치수로 직결.

### 6.3 변경 이력 주요 사항

- 2016.3.15: CGL/EGL 폭수축량 반영 로직 추가 (현재는 주석처리됨 - C10B1075, C10B1076 로직 비활성화)
- 2019.10.07: PLTCM 출측폭목표값 중 최대값 사용으로 변경
- 2022.5.02: 최종고객사(COL_FNL_CUS_CD) 조건 추가 (C10B2230, C10B1073)
- 2023.6.7: H/C 두께 선정 개선 - NO_SLIT/COIL_EDGE일 때 C10B1071 조건폭에 +20mm 적용
