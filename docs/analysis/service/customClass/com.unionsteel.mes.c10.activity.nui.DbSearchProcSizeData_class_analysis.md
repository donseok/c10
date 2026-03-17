# DbSearchProcSizeData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchProcSizeData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `1651` 라인 |
| 메소드 수 | `1`개 (runActivity) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

공정별 Size 정보(폭·두께 목표값 및 관련 설계 파라미터)를 품명코드·제품유형별 비즈니스 규칙에 따라 연산하고 PosContext에 편성하는 NUI(배치) 액티비티 클래스이다.

칼라/도금/정전 제품군에 대해 주문사양을 입력받아 마스터 데이터(EasyAccess 업무기준)와 DB 조회 결과를 결합하여 제조공정에 필요한 폭·두께 목표값, 수축량, 공차 범위, 설비 Set 기준 등 수십 개의 공정 파라미터를 계산·저장한다.

### 1.1 상속/구현 관계

```
PosActivity
  └── DbSearchProcSizeData
        implements C10NuiConstantsIF  (SQL 키·EasyAccess ID·컬럼명 상수 일괄 제공)
```

### 1.2 핵심 입력/출력

| 구분 | 항목 |
|------|------|
| 입력 (PosContext) | 주문번호(ORD_NO), 주문행번(ORD_LN), 품명코드(PRD_NM_CD), 재질코드(MQL_CD), 원자재코드(RMTL_CD), PLTCM X-Ray Set치(PLTCM_SET_THK_TRV), 주문폭(ORD_EXC_WTH), 주문두께(ORD_EXC_THK), 주문Slit조수(ORD_SLIT_GRP_CNT), 조합폭1~10(ORD_MIX_WTH1~10), EDGE지정구분(ORD_EDG_ASG_TP), 두께구분(ORD_THK_TP), 폭관리코드(ORD_WTH_MNG_CD), 스팽글구분(ORD_SPNL_TP), 최종수요가(FNL_CUS_CD), 고객사양번호(CUS_BTH_PAP_NO), CCL BOM번호(CCL_BOM_NO), 도막두께(PNT_FLM_THK_FRN/BAK_TOT), CCL폭목표(CCL_WTH_TRV), 중간정전목표폭(MID_COR_WTH_TRV) 등 |
| 출력 (PosContext) | CGL목표폭(CGL_WTH_TRV), CGL목표두께(CGL_THK_TRV), EGL목표폭(EGL_WTH_TRV), EGL목표두께(EGL_THK_TRV), TM목표폭/두께(TM_WTH_TRV/TM_THK_TRV), PLTCM목표폭(PLTCM_WTH_TRV), 대체공정1·2 목표폭, PL폭목표(PL_WTH_TRV), CCL목표두께(CCL_THK_TRV), 중간정전목표두께(MID_COR_THK_TRV), PLTCM두께 상하한(PLTCM_THK_LLV/ULV), PLTCM5Stand WR타입(PLTCM_5STD_WR_TP), PLTCM Sleeve유무(PLTCM_SLV_USE_YN), PLTCM EDGE지정구분(PLTCM_EDG_ASG_TP), 정전EDGE지정구분(COR_EDG_ASG_TP), 구매반제품여부(SEM_RMTL_YN) 등 |
| 반환값(transition) | `success` (정상완료) / `failure` (업무기준 조회 실패·에러) |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 품명코드 기반 제품 유형별 공정 Size 파라미터 연산 및 PosContext 등록 |
| 복잡도 | 매우 높음 |
| 파라미터 | `PosContext ctx` (서비스 데이터 컨테이너) |
| 반환 타입 | `String` (PosBizControlConstants.SUCCESS / FAILURE) |

**처리 흐름:**

1. **컨텍스트 파라미터 추출** - PosContext에서 주문사양(폭·두께·품명·재질·원자재·EDGE구분 등) 수십 개 변수 초기화
2. **APS 임시 조치** (2025.10.24 ~ APS 수정 완료 전) - `qlt_dsn_mnf_tp='1'` 이고 원자재코드 첫글자가 'D'인 경우, SELECT_MNF2(차선 칼라제조사양)를 조회하여 'H'로 시작하는 차선 원자재코드로 교체
3. **구매반제품 원자재 조기 반환** - 적정이 아니고(qlt_dsn_mnf_tp≠1) 원자재코드가 H/M 계열도 아니고 품명코드가 5/7도 아닌 경우 `SEM_RMTL_YN=Y`로 설정하고 SUCCESS 즉시 반환
4. **칼라제품 칼라제조사양 조회** (품명코드 1~9) - SELECT_MNF_CCL_BOM으로 재단선유무(cut_ln_yn), 코팅방식(cot_mth), 수지구분전면(rsn_tp_frn) 추출
5. **기준적용폭(ord_exc_wth) / 도금폭수축량기준적용폭(cegl_exc_wth) 계산** - 재단선유무·Slit조수·조합폭 조건 4가지 분기
6. **통과공정 조회** - SELECT_PROC으로 주공정·대체공정1·2 추출, 주공정 코드 첫글자로 CGL(8xx)/EGL(9xx)/정전(6xx·7xx) 구분
7. **정전폭마진량 조회** - EasyAccess C10B1079 (조건: EDGE구분, 품명, 제품형태, 코팅방식, 수지구분, 주문두께, CCL BOM번호, 스팽글구분)
8. **CCL폭수축량 조회** (칼라제품 1~9) - EasyAccess C10B1078 (조건: 품명, 재질, PLTCM두께, 기준폭)
9. **정전폭감소량 조회** (정전공정 통과 시) - EasyAccess C10B1077 (조건: 품명, 재질, PLTCM두께, 기준폭)
10. **CGL폭감소량 조회** (용융도금제품: G/K/J/L/V/W/3/4/6/9) - EasyAccess C10B1075, 주공정·대체공정1·2 각각 조회
11. **PLTCM ST폭보정치 조회** - EasyAccess C10B2191 (조건: 품명, 폭관리코드, CGL공정코드), 에러 시 무시
12. **중간재 적용 여부 판단** (EGL 제품: E/2/N/8) - EasyAccess C10B2230 (조건: 품명, 두께, 폭, 최종수요가, 고객사양, CCL BOM), 해당 시 egl_proc_cd='92' 설정
13. **EGL폭감소량 조회** (전기도금제품: E/2/N/8) - EasyAccess C10B1076, 주공정·대체공정1·2 각각
14. **목표폭·목표두께 계산** - 품명코드별 분기(18개 조합):
    - CGL 칼라(3/4/6/9): cgl_wth_trv = mid_cor_wth_trv/ccl_wth_trv + col_wth_shr ± col_wth_mgn
    - EGL 칼라(2/8): egl_wth_trv = mid_cor_wth_trv/ccl_wth_trv + col_wth_shr ± col_wth_mgn
    - GI/HGI/GL/GA(G/K/J/L/V/W): cgl_wth_trv = cor_wth_trv + col_wth_shr + col_wth_mgn
    - EG/Zn-Ni(E/N): egl_wth_trv = cor_wth_trv + col_wth_shr + col_wth_mgn
    - CCI(1): TM목표폭/PLTCM폭 계산
    - 무도금(C): EDGE구분에 따라 TM/PLTCM폭 계산
    - 기타(D/B/A): PLTCM폭 = 주문폭
15. **PLTCM두께공차 조회** (품명코드 5/7 제외) - EasyAccess C10B2190, 두께 상하한 계산 후 컨텍스트 저장
16. **PLTCM 5Stand W/R Type 조회** - EasyAccess C10B2110
17. **PLTCM Sleeve유무 조회** - EasyAccess C10B2120
18. **PLTCM폭수축량 조회** - EasyAccess C10B1074 (주공정·대체공정1·2 각각), PL폭목표 최대값 계산
19. **PL폭목표값 결정** - (PLTCM폭 + 수축량 + ST폭보정치)와 최대값 비교하여 최소값 적용
20. **결과 PosContext 저장** - 모든 계산 결과를 COL_* 상수 키로 ctx.put()
21. **EDGE 구분 변환** - ORD_EDG_ASG_TP를 PLTCM·정전 EDGE구분(Y/N)으로 변환 후 저장
22. `SEM_RMTL_YN=N`, SUCCESS 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-01 | 구매반제품 원자재 조기 반환 | qlt_dsn_mnf_tp≠1 AND rmtl_cd 첫글자≠H,M AND prd_nm_cd≠5,7 | SEM_RMTL_YN=Y, SUCCESS |
| BR-02 | 기준적용폭 (재단선Y, Slit=2, 주문폭=조합폭1) | cut_ln_yn=Y AND ord_slit_grp_cnt=2 AND ord_exc_wth=ord_mix_wth1 | ord_exc_wth=주문폭, cegl_exc_wth=주문폭×2 |
| BR-03 | 기준적용폭 (재단선Y, Slit=2, 주문폭≠조합폭1) | cut_ln_yn=Y AND ord_slit_grp_cnt=2 AND ord_exc_wth≠ord_mix_wth1 | ord_exc_wth=조합폭1, cegl_exc_wth=주문폭 |
| BR-04 | 기준적용폭 (그 외 Slit>0) | ord_slit_grp_cnt>0 (상기 조건 미해당) | ord_exc_wth=cegl_exc_wth=조합폭1~10합계 |
| BR-05 | 기준적용폭 (기본) | ord_slit_grp_cnt=0 | ord_exc_wth=cegl_exc_wth=주문폭 |
| BR-06 | CGL칼라 목표폭 (중간정전 통과) | prd_nm_cd∈{3,4,6,9} AND mid_cor_proc=true | cgl_wth_trv = mid_cor_wth_trv + 정전폭감소량 + 정전폭마진량 |
| BR-07 | CGL칼라 목표폭 (중간정전 미통과) | prd_nm_cd∈{3,4,6,9} AND mid_cor_proc=false | cgl_wth_trv = ccl_wth_trv + ccl_wth_shr |
| BR-08 | EGL칼라 목표폭 (중간정전 통과) | prd_nm_cd∈{2,8} AND mid_cor_proc=true | egl_wth_trv = mid_cor_wth_trv + 정전폭감소량 + 정전폭마진량 |
| BR-09 | EGL칼라 목표폭 (중간정전 미통과) | prd_nm_cd∈{2,8} AND mid_cor_proc=false | egl_wth_trv = ccl_wth_trv + ccl_wth_shr |
| BR-10 | GI·HGI·GL·GA 목표폭 | prd_nm_cd∈{G,K,J,L,V,W} | cgl_wth_trv = cor_wth_trv + 정전폭감소량 + 정전폭마진량 |
| BR-11 | EG·Zn-Ni 목표폭 | prd_nm_cd∈{E,N} | egl_wth_trv = cor_wth_trv + 정전폭감소량 + 정전폭마진량 |
| BR-12 | CCI(1) TM폭 (재단선Y) | prd_nm_cd=1 AND mid_cor_proc=true | tm_wth_trv = mid_cor_wth_trv + 정전폭마진량 |
| BR-13 | CCI(1) TM폭 (재단선N) | prd_nm_cd=1 AND mid_cor_proc=false | tm_wth_trv = ccl_wth_trv + ccl_wth_shr |
| BR-14 | 무도금(C) TM폭 (EDGE=S/C) | prd_nm_cd=C AND ord_edg_asg_tp∈{S,C} | tm_wth_trv = cor_wth_trv + 정전폭마진량 + 정전폭감소량 |
| BR-15 | 무도금(C) TM폭 (기타 EDGE) | prd_nm_cd=C AND ord_edg_asg_tp∉{S,C} | tm_wth_trv = cor_wth_trv + 정전폭감소량 |
| BR-16 | 중간재 적용 (EGL) | C10B2230 결과 1건 | egl_proc_cd='92' (중간재 전기도금 공정) |
| BR-17 | PL폭목표값 결정 | PLTCM폭+수축량+보정치 < 최대값 | PL폭목표 = PLTCM폭+수축량+보정치 |
| BR-18 | PL폭목표값 결정 (최대값 우선) | PLTCM폭+수축량+보정치 > 최대값 | PL폭목표 = 최대값 |
| BR-19 | PLTCM EDGE구분 | ord_edg_asg_tp∈{S,M} | PLTCM_EDG_ASG_TP=Y |
| BR-20 | 정전 EDGE구분 | ord_edg_asg_tp∈{S,C} | COR_EDG_ASG_TP=Y |
| BR-21 | APS 임시 조치 (2025.10.24~) | qlt_dsn_mnf_tp=1 AND rmtl_cd 첫글자=D AND 차선rmtl_cd 첫글자=H | rmtl_cd를 차선 H계열 코드로 교체하여 이후 조회에 사용 |

---

## 4. SQL 매핑

| SQL Key (상수) | 실제 SQL ID | 용도 | 호출 시점 |
|----------------|-------------|------|-----------|
| `SELECT_MNF2` | `C102100MNF.select2` | 차선 칼라제조사양 조회 (원자재코드 취득) | APS 임시 조치: qlt_dsn_mnf_tp=1, rmtl_cd 첫글자=D |
| `SELECT_MNF_CCL_BOM` | `C102100CCL_BOM.Aselect` | 칼라제조사양 조회 (재단선유무, 코팅방식, 수지구분전면) | 품명코드 1~9 (칼라 제품) |
| `SELECT_PROC` | `C102100PROC.select` | 통과공정 조회 (주공정, 대체공정1·2) | 모든 제품 공통 필수 |

---

## 5. 참조 업무기준 (EasyAccess)

| 업무기준 ID | 명칭 | 조건 항목 | 결과값 | 에러 처리 |
|-------------|------|-----------|--------|-----------|
| C10B1079 | 정전폭마진량기준 | EDGE구분, 품명, 제품형태, 코팅방식, 수지구분전면, 주문두께, CCL BOM번호, 스팽글구분 (8개) | col_wth_mgn (정전폭마진량) | 0건→ERRCD_KT28, 복수→ERRCD_KT29, FAILURE |
| C10B1078 | CCL폭수축량기준 | 품명, 재질코드, PLTCM두께, 기준적용폭 (4개) | ccl_wth_shr (CCL폭수축량) | 0건→ERRCD_KT26, 복수→ERRCD_KT27, FAILURE |
| C10B1077 | 정전폭감소량기준 | 품명, 재질코드, PLTCM두께, 기준적용폭 (4개) | col_wth_shr (정전폭감소량) | 0건→ERRCD_KT24, 복수→ERRCD_KT25, FAILURE |
| C10B1075 | CGL폭감소량기준 | CGL공정코드, 품명, 재질코드, 원자재코드, PLTCM두께, 도금폭수축량기준적용폭 (6개) | cgl_wth_shr (CGL폭감소량) | 0건→ERRCD_KT20, 복수→ERRCD_KT21, FAILURE |
| C10B1076 | EGL폭감소량기준 | EGL공정코드, 품명, 재질코드, 원자재코드, PLTCM두께, 도금폭수축량기준적용폭 (6개) | egl_wth_shr (EGL폭감소량) | 0건→ERRCD_KT22, 복수→ERRCD_KT23, FAILURE |
| C10B1074 | PLTCM폭수축량기준 | 원자재코드, PLTCM두께, PLTCM목표폭 (3개) | tcm_wth_shr_qty (PLTCM폭수축량) | 0건→ERRCD_KT04, 복수→ERRCD_KT14, FAILURE |
| C10B2191 | PLTCM ST폭보정기준 | 품명코드, 폭관리코드, 공정코드 (3개) / EGL 시 폭관리코드, 공정코드 (2개) | pltcm_wth_cor_val (폭보정치) | 에러 무시 (로그만) |
| C10B2190 | PLTCM두께공차기준 | PLTCM X-Ray Set치 (1개) | pltcm_thk_llv/ulv (두께공차 상하한) | 0건→ERRCD_KK80, 복수→ERRCD_KK81, FAILURE |
| C10B2110 | PLTCM 5Stand W/R Type Set기준 | PLTCM X-Ray Set치 (1개) | PLTCM_5STD_WR_TP | 0건→ERRCD_KK52, 복수→ERRCD_KK53, FAILURE |
| C10B2120 | PLTCM Sleeve유무 Set기준 | 품명코드, PLTCM X-Ray Set치 (2개) | PLTCM_SLV_USE_YN | 0건→ERRCD_KK50, 복수→ERRCD_KK51, FAILURE |
| C10B2230 | 중간재적용기준 | 품명코드, 주문두께, 주문폭, 최종수요가, 고객사양번호, CCL BOM번호 (6개) | (존재 시 egl_proc_cd='92') | 에러 무시 (복수→ERRCD_KK91, FAILURE) |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

PLTCM(도금설비) 스케줄링 前 단계에서 주문사양을 기반으로 각 공정(CGL 용융도금, EGL 전기도금, CCL 정전도장, TM 조질압연, PLTCM 피도금) 단계별 폭·두께 목표값을 사전 계산하여 공정 편성 데이터를 생성한다. 이 클래스는 품질설계결과 데이터와 마스터 업무기준(EasyAccess)을 결합하는 핵심 연산 액티비티로, 후속 서비스(예: C103100010-service 등)의 스케줄 편성에 사용된다.

### 6.2 핵심 비즈니스 로직

- **이중 폭 관리**: `ord_exc_wth`(기준적용폭)와 `cegl_exc_wth`(도금폭수축량기준적용폭)를 별도로 관리한다. Slit 가공 제품(재단선 있음)의 경우 두 값이 다를 수 있으며, 이 차이가 각 공정별 폭 계산의 기준값이 된다.
- **공정 구분 체계**: 주공정코드 첫 자리가 '8'이면 CGL(용융도금), '9'이면 EGL(전기도금), '6' 또는 '7'이면 정전 공정으로 분류한다. (하드코딩 상수 NUM8='8', NUM9='9')
- **PL폭목표 최대값 제한**: 주공정·대체공정1·2의 PLTCM폭+수축량 중 최대값을 상한으로 두고, 실제 PL폭목표는 이 최대값을 초과할 수 없다. 이는 설비 능력 상한선을 업무기준으로 적용하는 로직이다.
- **중간재 적용 EGL**: C10B2230 기준에 해당하면 EGL 공정코드를 '92'(중간재)로 고정하여 이후 EGL폭감소량 조회에 사용한다.
- **APS 임시 조치** (2025.10.24~): APS 시스템 버그 대응을 위해 적정설계(qlt_dsn_mnf_tp=1)에서 원자재코드가 D계열이면 차선 설계의 H계열 원자재코드로 교체하여 ST폭 계산에 적용한다. 주석 처리된 코드로 볼 때 원래는 D32→H32, D36→H36, D37→H39 하드코딩 방식이었으나 현재는 SELECT_MNF2 조회로 동적 처리한다.
- **두께 계산 공식**: 중간정전·CGL·EGL 목표두께 = 제품목표두께 - (도막두께전후면합계/1000) + 라미나두께(해당시)

### 6.3 업무기준(EasyAccess) 참조

총 11개 업무기준 참조. 주요 특징:
- C10B1075·C10B1076은 주공정·대체공정1·2에 대해 각각 3회 호출 (최대 9회)
- C10B2191은 에러 발생 시 처리를 무시(softfail)하므로 선택적 보정값으로 취급
- C10B2230(중간재기준)도 조회 실패 시 무시(softfail)

### 6.4 타 시스템 연동

| 시스템 | 연동 방식 | 내용 |
|--------|-----------|------|
| EasyAccess (마스터 데이터) | GLUE Framework API | 업무기준 11종 조회 |
| DB (masterdao) | GLUE DAO (SELECT) | 칼라제조사양, 통과공정 조회 |
| APS | 간접 (임시 조치 주석 참고) | APS 출력 원자재코드 D계열 보정 |

### 6.5 데이터 영향 범위

- **읽기**: `품질설계결과 제조사양(CCL BOM)`, `품질설계결과 통과공정` 테이블 및 EasyAccess 업무기준 11종
- **쓰기 없음**: DB에 직접 INSERT/UPDATE 없음. 계산 결과는 PosContext에 저장하여 다음 액티비티로 전달

### 6.6 주의사항 및 제약조건

- `prd_nm_cd` 값에 따른 분기가 20개 이상으로 매우 복잡하므로 신규 품명코드 추가 시 모든 분기를 검토해야 한다
- EasyAccess 업무기준 조회 실패(0건 또는 복수) 시 대부분 FAILURE를 반환하여 서비스 체인을 중단하지만, C10B2191(PLTCM ST폭보정치)과 C10B2230(중간재)은 에러를 무시한다
- 대체공정1·2에 대한 EGL 폭감소량(C10B1075 사용) 참조는 실제 상수 설명과 일치하지 않음 (코드상 `C10B1075`를 사용하나 주석에는 `C10B1075`로 EGL용도 표기) — 실제 코드 1096~1200라인에서 EGL 대체공정에도 `C10B1075`를 사용하며, 주석 16번 항목도 `C10B1075`로 기술되어 있어 오타로 판단됨
- APS 임시 조치 코드(라인 478~526)는 APS 수정 완료 후 제거 예정
