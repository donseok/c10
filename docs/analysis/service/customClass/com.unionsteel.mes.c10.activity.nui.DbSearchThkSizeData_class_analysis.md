# DbSearchThkSizeData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchThkSizeData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `876` 라인 |
| 메소드 수 | `1`개 (runActivity) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

### 1.1 업무 목적

`DbSearchThkSizeData`는 품질설계 편성 과정에서 **제품두께 관련 정보 일체를 계산·편성**하는 NUI Activity 클래스이다.
주문 코일/시트의 재질, 품명, 두께구분, 고객요청 압연두께, 도금량 등 다양한 입력값을 받아 다음 11개 편성항목을 산출한다:

1. Lamina 두께 (칼라제품)
2. SP 보정율 (알미늄/스테인레스 칼라 제외)
3. 압연목표두께(crm_thk)
4. 제품두께범위 상하한값 (보증·규격)
5. 제품목표두께(cor_thk_trv)
6. PLTCM 출측두께(pltcm_thk_trv)
7. PLTCM X-Ray Set치(pltcm_set_thk_trv)
8. 제품길이범위 상하한값 (Sheet 형태인 경우)
9. 제조표준 설정값 (소둔로유형, 온도, CGL 설정 등)
10. 매중량(ord_unt_wgt) (Coil 형태인 경우)
11. 구매반제품 원자재(SEM_RMTL_YN) 여부

### 1.2 상속/구현 관계

- `PosActivity` 상속: GLUE Framework Activity 기반. `runActivity(PosContext ctx)` 메소드를 구현.
- `C10NuiConstantsIF` 구현: 모든 상수(컬럼명, 업무기준 ID, 오류코드, 품명코드 등)를 인터페이스에서 상속.

### 1.3 핵심 입력/출력

**입력 (PosContext에서 읽기)**

| 변수 | 컬럼 상수 | 설명 |
|------|-----------|------|
| qlt_dsn_mnf_tp | COL_QLT_DSN_MNF_TP | 품질설계 제조유형 |
| prd_nm_cd | COL_PRD_NM_CD | 품명코드 (A,B,C,D,E,G,J,K,L,N,V,W,1~9) |
| rmtl_cd | COL_RMTL_CD | 재질코드 |
| ord_exc_thk | COL_ORD_EXC_THK | 주문두께 |
| ord_exc_wth | COL_ORD_EXC_WTH | 주문폭 |
| cus_req_rol_thk | COL_CUS_REQ_ROL_THK | 고객요청압연두께 |
| ord_thk_tp | COL_ORD_THK_TP | 주문두께구분 (1=BMT, 2=TCT, 3=칼라TCT) |
| thk_cor_unt | COL_THK_COR_UNT | 두께보정단위 (CRN/PCN/TRK) |
| pnt_flm_thk_frn_tot | COL_PNT_FLM_THK_FRN_TOT | 도막두께 전면 합계 (mm x 1000) |
| pnt_flm_thk_bak_tot | COL_PNT_FLM_THK_BAK_TOT | 도막두께 후면 합계 (mm x 1000) |
| gal_thk_trv | COL_GAL_THK_TRV | 목표도금두께 (mm x 1000) |
| spc_gal_thk | COL_SPC_GAL_THK | 규격도금두께 (mm x 1000) |
| thk_tln_llv/ulv | COL_THK_TLN_LLV/ULV | 인수도두께공차 하한/상한 (보증사양) |
| thk_tln_llv2/ulv2 | COL_THK_TLN_LLV2/ULV2 | 인수도두께공차 하한/상한 (규격사양) |
| ord_slit_grp_cnt | COL_ORD_SLIT_GRP_CNT | 슬리팅 그룹수 |
| ord_mix_wth1~10 | COL_ORD_MIX_WTH1~10 | 혼합폭 1~10 |
| prd_shp | COL_PRD_SHP | 제품형태 (C=Coil, S=Sheet) |
| wk_gw_frn/bak/tot_llv | COL_WK_GW_*_LLV | 작업도금량 전면/후면/전체 하한 |

**출력 (PosContext에 등록)**

| 컬럼 상수 | 설명 |
|-----------|------|
| COL_PRD_THK_RNG_LLV/ULV | 제품두께범위 하한/상한 (보증) |
| COL_PRD_THK_SPC_RNG_LLV/ULV | 제품두께규격범위 하한/상한 |
| COL_COR_THK_TRV | 제품목표두께 |
| COL_PLTCM_THK_TRV | PLTCM 출측두께 |
| COL_PLTCM_SET_THK_TRV | PLTCM X-Ray Set치 |
| COL_PRD_LTH_RNG_LLV/ULV | 제품길이범위 하한/상한 (Sheet 전용) |
| COL_ORD_UNT_WGT | 매중량 (Coil 전용) |
| COL_SEM_RMTL_YN | 구매반제품 원자재 여부 (Y/N) |
| COL_QLT_DSN_ERR_CD / C10STR_P_ERR_KEY | 오류코드 / 오류여부 |
| 소둔/CGL 설정값 (CR,EG,GI 등 품명별) | 제조표준 파생값 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 제품 두께 관련 전체 편성 정보 계산 및 PosContext 저장 |
| 복잡도 | 매우 높음 |
| 반환 | `"success"` / `"failure"` |

**처리 흐름:**

1. **입력값 추출** (265~384행): PosContext에서 약 40여 개 입력값을 로컬 변수로 로드. 도막두께·도금두께는 1/1000 단위 변환. 슬리팅 주문이면 혼합폭 합산으로 적용폭 계산.

2. **구매반제품 조기 종료 체크** (387~393행):
   - 조건: `qlt_dsn_mnf_tp != "1"` AND 재질코드 첫글자 != "H","M" AND 품명코드 != "5","7"
   - 조건 충족 시: `SEM_RMTL_YN = "Y"` 설정 후 즉시 SUCCESS 반환

3. **SP 보정율 조회** (395~416행): EasyAccess C10B2070 기준 조회 (품명, 재질, Spangle구분, 두께, 폭). 결과 미존재 시 에러 없이 sp_thk=0.

4. **압연목표두께(crm_thk) 계산** (418~654행):
   - `cus_req_rol_thk == 0 AND ord_thk_tp != "3"` (고객요청 미지정):
     - EasyAccess C10B2060(압연두께Set치보정기준) 조회 (10개 조건항목)
     - 결과 0건 → FAILURE (ERRCD_KK82)
     - 결과 2건 이상 → FAILURE (ERRCD_KK83)
     - 보정단위 CRN/PCN/TRK × 두께구분 NUM2(TCT)/NUM1(BMT) × 두께관리코드 NUM5(TCT→BMT)/NUM6(BMT→TCT) 분기로 crm_thk 산출
   - `cus_req_rol_thk > 0 OR ord_thk_tp == "3"` (고객요청 지정):
     - 두께보정단위 CRN/PCN/TRK, 두께구분 3(칼라TCT) 여부에 따른 crm_thk 산출

5. **제품두께범위 계산** (657~736행):
   - 제품두께계산적용코드(prd_thk_cal_apl_cd)에 따라 도금두께 포함 여부 결정
   - 규격기관(spc_avr)이 KS/JS가 아니면 규격 도금두께 = 0
   - 품명코드별 범위 공식 적용:
     - CR/P/O/F/H(A,B,C,D): 주문두께 ± 공차
     - CR칼라(1,5,7): 주문두께 + 도막두께 ± 공차 - 라미나두께
     - EGI/GI/HGI/G·A/G·L(E,N,G,K,J,L,V,W): 주문두께 + 도금두께 ± 공차
     - 도금칼라(2,3,4,6,8,9): 주문두께 + 도막두께 + 도금두께 ± 공차 - 라미나두께

6. **PLTCM 출측두께 계산** (738~750행):
   - TRK 단위: pltcm_thk_trv = crm_thk
   - 그 외: pltcm_thk_trv = crm_thk + crm_thk * sp_thk / 100
   - `DbCommonUtil.thk_dot()` 로 소수점 3자리 절삭

7. **PLTCM X-Ray Set치 계산** (755~758행):
   - 알미늄(5)/스테인레스(7): pltcm_set_thk_trv = ord_exc_thk
   - 그 외: `DbCommonUtil.pltcm_x_Ray()` 호출 → 소수점 3번째 자리를 0/5/올림으로 변환

8. **결과값 PosContext 저장** (762~778행)

9. **제조표준 조회** (780~855행): 알미늄/스테인레스 제외 품명에 대해 C10B1051 EasyAccess 조회
   - 조건: 제조표준번호, 품명, 재질, PLTCM X-Ray Set치, 폭
   - CR/EG 계열(C,E,N,1,2,8): 소둔로 설정값(일반ANN, HCANN) 저장
   - GI/GA/GL 계열: CGL 라인별(#2~#5) 소둔Cycle·온도·속도 저장
   - 결과 0건/중복 → FAILURE

10. **매중량 계산** (857~871행): Coil 형태인 경우
    - 알미늄(5): 두께 × 2.73 × 폭 / 1000
    - 스테인레스(7): 두께 × 7.74 × 폭 / 1000
    - 그 외: ((PLTCM Set치 × 7.85) + 작업도금량합계/1000) × 폭 / 1000

11. **SEM_RMTL_YN = "N"** 설정 후 SUCCESS 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 구매반제품 조기종료 | qlt_dsn_mnf_tp≠1 AND 재질 H/M 아님 AND 품명 5/7 아님 | SEM_RMTL_YN=Y, SUCCESS |
| 2 | SP보정율 미존재 허용 | C10B2070 조회 결과 없음 | sp_thk=0, 계속 진행 |
| 3 | 압연두께보정기준 필수 | C10B2060 결과 0건 | FAILURE (KK82) |
| 4 | 압연두께보정기준 중복 금지 | C10B2060 결과 2건 이상 | FAILURE (KK83) |
| 5 | 주문두께구분 불일치 오류 | PCN/TRK 단위 + TCT→BMT(5)/BMT→TCT(6) 부적절 조합 | FAILURE (KK94) |
| 6 | 제조표준기준 필수 | C10B1051 결과 0건 | FAILURE (KK13) |
| 7 | 제조표준기준 중복 금지 | C10B1051 결과 2건 이상 | FAILURE (KK14) |
| 8 | TCT 두께구분 시 도금두께 제외 | ord_thk_tp=2 | gal_thk_trv2=0, spc_gal_thk=0 |
| 9 | 제품두께계산코드 'T' | prd_thk_cal_apl_cd="T" | gal_thk_trv2=0 |
| 10 | 제품두께계산코드 'C' | prd_thk_cal_apl_cd="C" | gal_thk_trv2=0, 도막두께 모두 0 |
| 11 | 규격기관 KS/JS 아닌 경우 | spc_avr 앞 2자리 ≠ KS,JS | spc_gal_thk=0 |
| 12 | 슬리팅 주문 폭 계산 | ord_slit_grp_cnt > 0 | 적용폭 = 혼합폭 1~10 합산 |
| 13 | CRN 단위 TCT→BMT 전환 | ord_thk_mng_cd=5 | crm_thk = ord_exc_thk (보정치 미적용) |
| 14 | CRN 단위 BMT→TCT 전환 | ord_thk_mng_cd=6 | crm_thk = ord_exc_thk - gal_thk_trv |
| 15 | 알미늄/스테인레스 X-Ray | prd_nm_cd=5 or 7 | pltcm_set_thk_trv = 주문두께 그대로 |

---

## 4. EasyAccess 업무기준 매핑

| 기준 ID | 기준명 | 조건항목 (개수) | 반환항목 | 조회 시점 |
|---------|--------|----------------|----------|-----------|
| C10B2070 | SP두께보정율기준 | 품명, 재질, Spangle구분, 두께, 폭 (5) | COL_THK_CPS_RT (SP보정율) | 압연목표두께 계산 전 |
| C10B2060 | 압연두께Set치보정기준 | 품명, 규격기관, 규격약호, 용도, 최종고객사, 두께구분, 두께관리코드, 도금량, 두께, 폭 (10) | COL_THK_COR_UNT (보정단위), COL_THK_COR_VAL (보정치) | 고객요청 미지정 시 |
| C10B1051 | 제조표준기준 | 제조표준번호, 품명, 재질, PLTCM X-Ray Set치, 폭 (5) | 소둔로유형, Cycle, 온도 등 10개 항목 | 제품두께 계산 후 |

---

## 5. 비즈니스 분석 상세

### 5.1 업무 목적 및 배경

냉연·도금·칼라 강판 주문의 품질설계 편성 단계에서 압연 목표두께와 제품 규격 허용범위를 자동 계산하는 핵심 Activity이다. 제품 유형(CR/EG/GI/GA/GL/칼라/알미늄/스테인레스)별로 두께 계산 공식이 다르고, 주문두께구분(BMT/TCT/칼라TCT)과 고객요청 압연두께 유무에 따른 분기가 복잡하다.

### 5.2 핵심 비즈니스 로직

**압연목표두께(crm_thk) 계산 핵심 공식 요약**

| 상황 | 보정단위 | 두께구분 | 공식 |
|------|----------|----------|------|
| 고객요청 없음 | CRN | TCT(2) 일반 | 주문두께 - 도금두께 + 보정치 |
| 고객요청 없음 | CRN | BMT(1) 일반 | 주문두께 + 보정치 |
| 고객요청 없음 | PCN | TCT(2) 일반 | 주문두께 - 도금두께 + (주문두께 × 보정치/100) |
| 고객요청 없음 | PCN | BMT(1) 일반 | 주문두께 + (주문두께 × 보정치/100) |
| 고객요청 없음 | TRK | TCT(2) 일반 | 보정치 - 도금두께 |
| 고객요청 없음 | TRK | BMT(1) 일반 | 보정치 |
| 고객요청 있음 | CRN | 칼라TCT(3) | 주문두께 + 고객요청 - 도막두께 - 도금두께 + 라미나두께 |
| 고객요청 있음 | CRN | 그 외 | 주문두께 + 고객요청 |
| 고객요청 있음 | PCN | 칼라TCT(3) | (BMT) + (BMT × 고객요청/100) |
| 고객요청 있음 | PCN | 그 외 | 주문두께 + (주문두께 × 고객요청/100) |
| 고객요청 있음 | TRK | 모든 | 고객요청 그대로 |

**소수점 처리 규칙**

- `thk_dot()`: 소수점 이하 4자리 이상이면 3자리까지 절삭 (버림)
- `pltcm_x_Ray()`: 소수점 3번째 자리를 0/5/올림으로 변환 (반올림하여 0.005 단위로 정규화)
- CRN 단위 TCT 계산 후 `Math.round(crm_thk * 10000) / 10000` 으로 소수점 4자리 반올림

### 5.3 업무기준(EasyAccess) 참조

- **C10B2070**: SP(Skin Pass) 보정율 기준. 조회 실패해도 에러 없이 sp_thk=0으로 계속 진행하는 유일한 기준.
- **C10B2060**: 압연두께Set치보정기준. 고객 요청 없을 때 필수 참조. 결과 미존재·중복 시 FAILURE.
- **C10B1051**: 제조표준기준. 소둔로 유형/온도/CGL 라인 속도 등 공정 파라미터 결정. 알미늄(5)/스테인레스(7) 제외 품명에 필수.

### 5.4 데이터 영향 범위

- 읽기: PosContext (이전 Activity에서 설정된 주문·설계 데이터)
- 쓰기: PosContext (후속 Activity가 사용할 두께 계산 결과값 일체)
- DB 직접 접근 없음 (EasyAccess 캐싱 기반 마스터 조회만 사용)
- DAO 설정: `masterdao` (property 선언), 단 실제 코드 내 직접 사용 없음 (주석 처리된 코드에서만 사용)

### 5.5 주의사항 및 제약조건

1. **주문두께구분 불일치 오류(KK94)**: PCN/TRK 보정단위에서 두께관리코드가 NUM5(TCT→BMT)이면서 두께구분이 TCT(2)이거나, NUM6(BMT→TCT)이면서 두께구분이 BMT(1)인 경우 오류 처리됨.
2. **슬리팅 주문**: 슬리팅 그룹수(ord_slit_grp_cnt)>0이면 적용폭은 혼합폭 10개 합산값을 사용하되, 매중량 계산에는 원래 주문폭(me_exc_wth)을 사용함.
3. **알미늄(5)/스테인레스(7) 예외**: SP보정율·압연두께보정기준·제조표준기준 조회 대상에서 제외. 매중량 계산 공식도 별도 밀도 적용.
4. **구매반제품(SEM_RMTL_YN) 조기종료**: 제조유형이 1이 아니고, 재질코드 첫글자가 H/M이 아니고, 품명코드가 5/7이 아닌 경우, 두께 계산 전체를 건너뛰고 Y로 반환.
5. **도막두께 단위**: Context에서 읽을 때 1/1000으로 나눔 (μm → mm 변환).
6. **CRN 단위 TCT 계산**: 소수점 4자리 반올림 로직 별도 적용 (2013.01.21 추가).
