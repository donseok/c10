# DbSearchWthSizeData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchWthSizeData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 574 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

제품폭 정보를 편성하는 Activity 클래스다. 주문 제품의 폭 관련 설계값(기준적용폭, 목표폭, 조합폭, EDGE 지정, CCL 출측폭, 중간정전목표폭)을 계산하여 PosContext에 등록한다.

내부적으로 5가지 데이터를 순차 편성한다.
1. 칼라제품의 경우 칼라제조사양(SELECT_MNF_CCL_BOM)에서 재단선유무/코팅방식/수지구분전면을 조회
2. 제품폭여유치(VI_M00_C10A1070)에서 폭여유값(mrg_wth) 조회
3. 제품폭범위 하한/상한 = 주문폭 ± 인수도폭공차
4. 제품목표폭(정전목표폭, cor_wth_trv)을 조건별 수식으로 계산
5. 정전폭마진(C10B1079)과 CCL폭수축량(C10B1078)을 EasyAccess로 조회하여 CCL 출측폭/중간정전목표폭 계산

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크 Activity 추상 클래스.
- `C10NuiConstantsIF` 구현: C10 NUI 공통 상수 인터페이스.

### 1.2 핵심 입력/출력

**입력 (PosContext)**

| 컬럼 상수 | 설명 | 비고 |
|-----------|------|------|
| `COL_QLT_DSN_MNF_TP` | 품질설계제조구분 | 반제품 Skip 판단 |
| `COL_RMTL_CD` | 원자재코드 | 반제품 Skip 판단 |
| `COL_PRD_NM_CD` | 품명코드 | 칼라 여부 분기 |
| `COL_PRD_SHP` | 제품형태 | EasyAccess 키 |
| `COL_ORD_NO` | 주문번호 | 칼라제조사양 조회 키 |
| `COL_ORD_LN` | 주문행번 | 칼라제조사양 조회 키 |
| `COL_ORD_EXC_THK` | 주문환산두께 | EasyAccess 키 |
| `COL_ORD_EXC_WTH` | 주문환산폭 | 폭 계산 기준 |
| `COL_ORD_SLIT_GRP_CNT` | 주문Slit조수 | 폭 계산 분기 |
| `COL_ORD_MIX_WTH1~10` | 주문조합폭 1~10 | 조합폭 계산 |
| `COL_ORD_WTH_MNG_CD` | 주문폭관리코드 | 폭여유치 조회 키 |
| `COL_ORD_EDG_ASG_TP` | 주문Edge지정구분 | EDGE 분기 |
| `COL_ORD_SPNL_TP` | 주문스팽글구분 | EasyAccess 키 |
| `COL_MQL_CD` | 재질코드 | CCL폭수축량 키 |
| `COL_PLTCM_SET_THK_TRV` | PLTCM X-Ray Set치 | CCL폭수축량 키 |
| `COL_WTH_TLN_LLV` | 인수도폭공차 하한 | 폭범위 계산 |
| `COL_WTH_TLN_ULV` | 인수도폭공차 상한 | 폭범위 계산 |

**출력 (PosContext)**

| 컬럼 상수 | 설명 |
|-----------|------|
| `COL_PRD_WTH_RNG_LLV` | 제품폭범위 하한 |
| `COL_PRD_WTH_RNG_ULV` | 제품폭범위 상한 |
| `COL_COR_WTH_TRV` | 기준적용폭(제품목표폭) |
| `COL_CCL_WTH_TRV` | CCL 출측폭(CCL목표폭) |
| `COL_MID_COR_WTH_TRV` | 중간정전목표폭 |
| `COL_SLIT_GRP_CNT` | 제조사양Slit조수 |
| `COL_MIX_WTH1~10` | 제조사양조합폭 1~10 |
| `COL_COR_EDG_ASG_TP` | 정전EDGE지정구분 |
| `COL_SEM_RMTL_YN` | 반제품원자재여부 |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 제품폭 관련 전체 설계값 계산 및 등록

**복잡도**: 높음 (다중 분기, 복잡한 폭 계산 수식, EasyAccess 2종, DAO 2종)

**처리 흐름**:

```
1. 파라미터 추출 (17개)
   - Double.parseDouble() 사용: 폭/두께/조수 등 수치형 항목

2. 반제품 원자재 조기 종료 체크
   - 조건: qlt_dsn_mnf_tp != "1" AND rmtl_cd[0] != 'H' AND rmtl_cd[0] != 'M'
             AND prd_nm_cd != "5" AND prd_nm_cd != "7"
   - 해당 시: COL_SEM_RMTL_YN = "Y", SUCCESS 반환 (이후 처리 Skip)

3. 칼라제품의 경우 SELECT_MNF_CCL_BOM 조회
   - PRD_NM_CD IN (1~9) 인 경우
   - 파라미터: 주문번호, 주문행번
   - 결과 0건: ERRCD_KP05 → FAILURE
   - 결과 >=1건: cut_ln_yn, cot_mth, rsn_tp_frn, ccl_bom_no 추출
   - cut_ln_yn = 'Y' 이면 mid_cor_proc = true (중간정전 공정 통과)

4. 제품폭여유치(VI_M00_C10A1070) 조회
   - 파라미터: 주문폭관리코드(ord_wth_mng_cd)
   - 결과 1건: mrg_wth 추출
   - 결과 0건/예외: ERRCD_KT03 → FAILURE
   - 결과 >1건: ERRCD_KT13 → FAILURE

5. 제품폭범위 계산
   - COL_PRD_WTH_RNG_LLV = 주문환산폭(COL_ORD_EXC_WTH) + 인수도폭공차하한(wth_tln_llv)
   - COL_PRD_WTH_RNG_ULV = 주문환산폭(COL_ORD_EXC_WTH) + 인수도폭공차상한(wth_tln_ulv)

6. 기준적용폭(ord_exc_wth) 및 제품목표폭(cor_wth_trv) 계산
   - 분기 A: cut_ln_yn='Y' AND Slit조수=2 AND 주문폭=조합폭1
     - ord_exc_wth = 주문환산폭
     - cor_wth_trv = 주문환산폭 + mrg_wth
   - 분기 B: cut_ln_yn='Y' AND Slit조수=2 AND 주문폭≠조합폭1
     - ord_exc_wth = 조합폭1(ord_mix_wth1)
     - cor_wth_trv = ord_mix_wth1 + mrg_wth
   - 분기 C: Slit조수 > 0 (이전 분기 미해당)  [주석 처리된 복수 분기 대체]
     - ord_exc_wth = ord_mix_wth1 + ... + ord_mix_wth10 (합산)
     - cor_wth_trv = ord_exc_wth + mrg_wth * ord_slit_grp_cnt
   - 분기 D: 그 외
     - ord_exc_wth = 주문환산폭
     - cor_wth_trv = 주문환산폭 + mrg_wth

7. 제조사양 등록
   - COL_SLIT_GRP_CNT = ord_slit_grp_cnt
   - COL_MIX_WTH1~10: 해당 조합폭 > 0이면 조합폭 + mrg_wth, 아니면 원래값

8. 정전EDGE 지정구분
   - ord_edg_asg_tp = SLIT_EDGE 또는 COIL_EDGE 이면 COL_COR_EDG_ASG_TP = 'Y'
   - 그 외: COL_COR_EDG_ASG_TP = 'N'

9. 정전폭마진(C10B1079) EasyAccess 조회
   - 키 8개: 주문Edge구분, 품명코드, 제품형태, 코팅방식, 수지구분전면, 주문두께, CCL BOM번호, 주문스팽글구분
   - 결과 1건: col_wth_mgn 추출
   - 결과 0건: ERRCD_KT28 → FAILURE
   - 결과 >1건: ERRCD_KT29 → FAILURE

10. CCL 출측폭(ccl_wth_trv) 계산 (칼라제품만)
    - 중간정전 통과제(mid_cor_proc=true):
      - ccl_wth_trv = cor_wth_trv (정전목표폭 = 기준적용폭)
      - CCL폭수축량(C10B1078) EasyAccess 조회
        - 키 4개: 품명코드, 재질코드, X-Ray Set치, 기준적용폭
        - 결과 1건: ccl_wth_shr 추출
      - Slit조수=2: mid_cor_wth_trv = (ccl_wth_trv + ccl_wth_shr) * 2
      - 그 외: mid_cor_wth_trv = ccl_wth_trv + ccl_wth_shr
    - 중간정전 미통과제:
      - ccl_wth_trv = cor_wth_trv + col_wth_mgn (정전폭마진 추가)

11. 결과 등록
    - ctx.put(COL_COR_WTH_TRV, cor_wth_trv)
    - ctx.put(COL_CCL_WTH_TRV, ccl_wth_trv)
    - ctx.put(COL_MID_COR_WTH_TRV, mid_cor_wth_trv)
    - ctx.put(COL_SEM_RMTL_YN, "N")

12. SUCCESS 반환
```

---

## 3. 비즈니스 규칙

### 3.1 핵심 계산 공식

**제품폭범위**
```
제품폭범위 하한 = 주문환산폭 + 인수도폭공차 하한
제품폭범위 상한 = 주문환산폭 + 인수도폭공차 상한
```

**기준적용폭 및 제품목표폭(정전목표폭)**

| 조건 | 기준적용폭 | 제품목표폭 |
|------|-----------|----------|
| 재단선='Y' AND Slit=2 AND 주문폭=조합폭1 | 주문환산폭 | 주문환산폭 + mrg_wth |
| 재단선='Y' AND Slit=2 AND 주문폭≠조합폭1 | 조합폭1 | 조합폭1 + mrg_wth |
| Slit > 0 (나머지 경우) | 조합폭1~10 합산 | 합산폭 + mrg_wth × Slit조수 |
| 그 외 | 주문환산폭 | 주문환산폭 + mrg_wth |

**제조사양조합폭 (COL_MIX_WTH1~10)**
```
제조사양조합폭N = 주문조합폭N + mrg_wth (주문조합폭N > 0인 경우)
제조사양조합폭N = 주문조합폭N (주문조합폭N = 0인 경우)
```

**CCL 출측폭 (칼라제품)**
```
중간정전 통과: ccl_wth_trv = cor_wth_trv (정전폭마진 미적용)
중간정전 미통과: ccl_wth_trv = cor_wth_trv + col_wth_mgn (정전폭마진 추가)
```

**중간정전목표폭 (재단선='Y'인 칼라제품)**
```
Slit조수=2: mid_cor_wth_trv = (ccl_wth_trv + ccl_wth_shr) × 2
그 외: mid_cor_wth_trv = ccl_wth_trv + ccl_wth_shr
```

### 3.2 비즈니스 규칙 테이블

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 반제품 원자재 Skip | qlt_dsn_mnf_tp≠"1" AND rmtl_cd[0]≠H/M AND prd_nm_cd≠5/7 | COL_SEM_RMTL_YN="Y", SUCCESS |
| 2 | 칼라제조사양 조회 | PRD_NM_CD IN (1~9) | SELECT_MNF_CCL_BOM 조회 필수 |
| 3 | 재단선 중간정전 | cut_ln_yn='Y' | mid_cor_proc=true, 폭 계산 분기 |
| 4 | 폭여유치 단건 필수 | VI_M00_C10A1070 결과 0건/예외/복수 | FAILURE |
| 5 | 정전폭마진 단건 필수 | C10B1079 결과 0건/복수 | FAILURE |
| 6 | 조합폭 폭여유 적용 | 주문조합폭 > 0 | 조합폭 + mrg_wth |
| 7 | EDGE 지정구분 판별 | ord_edg_asg_tp = SLIT_EDGE 또는 COIL_EDGE | COL_COR_EDG_ASG_TP = 'Y' |
| 8 | CCL폭수축량 조회 | 칼라제품 AND 재단선='Y' | C10B1078 EasyAccess 조회 |
| 9 | 중간정전목표폭 배수 | Slit조수=2 | mid_cor_wth_trv × 2 |

---

## 4. SQL 매핑

| SQL Key / 마스터 코드 | 용도 | 파라미터 | 호출 시점 |
|----------------------|------|---------|---------|
| `SELECT_MNF_CCL_BOM` (DAO) | 칼라제조사양 조회 (재단선, 코팅방식, 수지구분전면) | 주문번호, 주문행번 | 칼라제품인 경우 |
| `VI_M00_C10A1070` (DAO) | 제품폭여유치 조회 | 주문폭관리코드 | 항상 |
| `C10B1079` (EasyAccess) | 정전폭마진기준 | 8개 조건 (Edge구분, 품명, 형태, 코팅, 수지, 두께, BOM번호, 스팽글) | 항상 |
| `C10B1078` (EasyAccess) | CCL폭수축량기준 | 4개 조건 (품명, 재질, X-Ray Set, 기준적용폭) | 칼라제품 AND 재단선='Y' |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

CCL(Color Coated Line) 제품을 포함한 모든 제품의 품질설계 폭 편성 단계에서 사용된다. 주문폭에 폭여유치를 더하여 실제 생산에서 목표로 하는 폭 값들을 계산한다.

핵심 비즈니스 로직은 세 가지다.

첫째, 반제품 원자재(구매 반제품, CCAI/CCUS 제외)의 경우 폭 계산 없이 Skip한다. 이는 반제품 원자재는 이미 가공된 소재로 폭 설계가 불필요하기 때문이다.

둘째, 재단선(cut_ln_yn) 유무에 따라 기준적용폭 계산 방식이 달라진다. 재단선이 있는 제품(중간정전 통과제)은 폭수축이 발생하므로 CCL 라인 통과 후 수축량을 고려한 중간정전목표폭을 별도 계산한다. 재단선이 없는 제품은 정전폭마진을 단순 합산하여 CCL 출측폭을 결정한다.

셋째, Slit 조수(ord_slit_grp_cnt)에 따라 복수의 조합폭이 각각 mrg_wth를 더한 제조사양조합폭으로 변환된다. Slit 조수 2 이상인 경우 중간정전목표폭에 Slit조수를 곱한다.

주석 처리된 코드(라인 359~396)는 이전 버전의 분기 로직으로, 현재는 단순화된 `ord_slit_grp_cnt > 0` 분기로 대체되어 있다.
