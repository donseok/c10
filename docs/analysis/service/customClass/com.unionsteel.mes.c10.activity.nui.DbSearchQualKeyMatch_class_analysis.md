# DbSearchQualKeyMatch 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchQualKeyMatch.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 약 1047 라인 |
| 메소드 수 | 1개 (runActivity) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

Master Data의 설계Key기준(C10B1040)을 읽어 품질설계Key사항을 편성하는 클래스이다.
주문 속성(품명, 형태, 규격약호, 주문용도코드, 고객사코드, 고객사양번호, 주문두께, 주문폭)을 이용해 EasyAccess 규칙 엔진을 통해 최적의 품질설계 Key를 매칭한다.
매칭 실패 시 선택 조건항목을 와일드카드(`*`)로 단계적으로 완화(Fallback)하는 반복 루프 전략을 사용하며, 매칭 성공 후에는 제품군/행선지/재질/표면처리 등 다차원 클래스코드(Class1~6)를 조합하여 최종 품질설계코드(`COL_CLS_CD`)를 생성한다. 코일과 Sheet 형태에 따라 포장재중량도 계산한다.

### 1.1 상속/구현 관계

- `extends PosActivity` : GLUE 프레임워크 Activity 기반 클래스
- `implements C10NuiConstantsIF` : NUI 상수 인터페이스 (SQL key, 컬럼명, 에러코드 등 상수 제공)

### 1.2 핵심 입력/출력

**입력 (PosContext에서 추출)**

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_PRD_NM_CD | 품명코드 |
| COL_PRD_SHP | 제품형태 (코일/Sheet) |
| COL_SPC_AVR | 규격약호 |
| COL_ORD_USG_CD | 주문용도코드 |
| COL_FNL_CUS_CD | 최종수요가(고객사)코드 |
| COL_CUS_BTH_PAP_NO | 고객사양번호 |
| COL_ORD_EXC_THK | 주문두께 |
| COL_ORD_EXC_WTH | 주문폭 |
| COL_ORD_SLIT_GRP_CNT | 조분할 그룹수 |
| COL_ORD_MIX_WTH1~10 | 복합조 폭 1~10 |
| COL_EMBS_CD | EMBOSS 무늬 코드 |
| COL_ORD_SPNL_TP | 주문 Spangle 구분 |
| COL_GW_ASG_CD | 주문도금량지정코드 |
| COL_ORD_SUR_HND_CD | 주문표면처리코드 |
| COL_CCL_BOM_NO | CCL BOM 번호 |
| COL_MTL_CD | Material Code |
| COL_POC_CGL_YN | CGL 위탁임가공 여부 |
| COL_POC_CCL_YN | CCL 위탁임가공 여부 |
| COL_ORD_PAK_MTH | 포장방법 |
| COL_ORD_PAK_UNT_WGT_ULV | 포장단중 최대값 |
| COL_ORD_EXC_LTH | 주문길이 |
| COL_FLOW_CHL | 유통경로 |

**출력 (PosContext에 저장)**

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_MQL_CD | 재질코드 |
| COL_RMTL_CD, COL_RMTL_CD1, COL_RMTL_CD2 | 반제품 Material Code (1~3) |
| COL_CRM_MNF_STD_NO, COL_CRM_MNF_STD_NO1, COL_CRM_MNF_STD_NO2 | 제조규격번호 (1~3) |
| COL_QLT_MSG_NM, COL_QLT_MSG_NM1, COL_QLT_MSG_NM2 | 품질메시지 (1~3) |
| COL_PAS_PROC_NO | 통과공정번호 |
| COL_QLT_DSN_CFM_TP | 품질설계확정구분 |
| COL_APR_INP_BAS_CD | 승인입력기준코드 |
| COL_CLS_CD | 최종 클래스코드 (Class1+Class2+Class3/34+Class4+Class5+Class6 조합) |
| COL_SUB_CLS_CD | 서브 클래스코드 |
| COL_ORD_ROU_CD | 조도코드 (EG/EG칼라 전용) |
| COL_ORD_PAK_MTL_WGT | 포장재중량 |
| COL_QLT_DSN_ERR_CD | 품질설계 에러코드 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 주문 속성 기반 품질설계Key 매칭 및 다차원 클래스코드 생성 |
| 반환 타입 | String |
| 반환값 | PosBizControlConstants.SUCCESS / PosBizControlConstants.FAILURE |
| 복잡도 | 매우 높음 |

**처리 흐름**

1. DAO 및 변수 초기화 - 품명코드, 형태, 규격약호, 주문용도코드 등 20여 개 변수를 PosContext에서 추출
2. 주문폭 계산 - 조분할(ord_slit_grp_cnt) > 0이면 혼합폭 합산: `ord_exc_wth = sum(ord_mix_wth1 ~ ord_mix_wth10)`; 아니면 원본 폭 그대로 사용
3. 고객사양번호/색상코드 초기 설정 - `cus_bth_pap_no`가 공백이면 `setAstar(10)` (와일드카드 10자리) 설정; `ccl_bom_no` 5자리 앞에서 `clr_cd` 추출
4. **EasyAccess 규칙 매칭 루프 (while(true))** - 13개 조건값으로 `C10B1040` 규칙 조회 → 결과 없으면 선택 조건(주문용도코드, 고객사코드, 색상코드)을 단계적으로 와일드카드(`*`)로 완화 후 재시도 → 최종 실패 시 에러코드 ERRCD_KK01 설정 후 FAILURE 반환
5. 매칭 성공 - 재질코드(COL_MQL_CD), 반제품Material(COL_RMTL_CD), 제조규격번호(COL_CRM_MNF_STD_NO), 품질메시지(COL_QLT_MSG_NM), 통과공정번호(COL_PAS_PROC_NO) 등 Context에 저장
6. 위탁임가공 처리 - `poc_cgl_yn`, `poc_ccl_yn` 조합에 따라 COL_PAS_PROC_NO를 "3OA001"(CGL+CCL), "GOH001"(CGL) 또는 규칙결과값으로 Override
7. 메시지 DB 저장 - COL_CRM_MNF_STD_NO 존재 여부에 따라 최대 3건의 품질메시지를 `INSERT_MSG` SQL로 DB에 Insert
8. 정전메시지 저장 - `INSERT_MSG_COR` SQL로 정전(관리) 메시지 Insert
9. Material Code 유효성 검증 - mtl_cd 공백이면 에러코드 ERRCD_KP06 설정 후 FAILURE 반환
10. 복합조 폭 다양성 판단 - `ord_slit_grp_cnt` > 1이면 혼합폭 배열을 비교하여 `ord_mix_wth_tp` (Y/N) 결정
11. **ClassCode1 (제품군)** - `C10B9980` 규칙 조회, 키: 품명코드, 주문두께구분, 주문EDG, 규격기관 → Class1 설정
12. **ClassCode2 (행선지)** - `C10B9981` 규칙 조회, 키: 품명코드, 제품형태, 조분할, 복합조 여부, 주문종류 → Class2 설정
13. **ClassCode6 (표면처리)** - `C10B9984` 규칙 조회, 키: 품명코드, 주문표면처리코드 → Class6 설정
14. **ClassCode34 (재질, 냉연/원판계)** - 품명코드가 A,B,C,D,1,E,N,2,5,7,8 이면 `C10B9982` 조회, 키: 품명코드, 재질코드 → Class34 설정; Class5는 EG/EG칼라면 gw_asg_cd, 그 외 ord_rou_cd
15. **ClassCode3 (재질, 도금계)** - 품명코드가 G,K,J,L,V,W,3,4,6,9 이면 `C10B9983` 조회, 키: 품명코드, 재질코드, 규격기관 → Class3 설정; Class4=ord_spnl_tp, Class5=gw_asg_cd
16. **최종 클래스코드 조합** - `COL_CLS_CD = Class1 + Class2 + Class34(또는 Class3) + Class4(도금만) + Class5 + Class6`
17. Sub 클래스코드 - 특정 품명코드(1,2,5,7,8,3,4,6,9)에서 mtl_cd 길이 15 이상이면 서브코드 추출: `mtl_cd.substring(7,13)` 또는 `mtl_cd.substring(8,14)` + ccl_bom_no
18. **EG/EG칼라 조도코드 조회** - 품명코드가 E,2,N,8 이면 `C10B2080` 조회, 키: 품명코드, 규격기관, 주문용도코드, 최종수요가, 두께, 폭 → COL_ORD_ROU_CD 설정
19. **포장재중량 계산**
    - 코일(`PRD_SHP_COIL`): `C10B1081` 규칙 조회, 키: 포장방법, 폭, 포장단중, 길이 → COL_ORD_PAK_MTL_WGT 설정
    - Sheet(`PRD_SHP_SHEET`): 폭+길이 합계 계산 후 `C10A2230` 계산식 실행 → BigDecimal 결과를 소수 0자리 반올림 후 COL_ORD_PAK_MTL_WGT 설정
20. SUCCESS 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| R01 | 주문폭 결정 | ord_slit_grp_cnt > 0 | ord_exc_wth = sum(ord_mix_wth1~10) |
| R02 | 주문폭 결정 | ord_slit_grp_cnt = 0 | ord_exc_wth = COL_ORD_EXC_WTH 원본값 |
| R03 | 고객사양번호 와일드카드 초기화 | cus_bth_pap_no = 공백 | cus_bth_pap_no = "**********" (10자리) |
| R04 | 색상코드 추출 | ccl_bom_no 길이 > 4 | clr_cd = ccl_bom_no.substring(0,5) |
| R05 | 설계Key 매칭 | 13개 조건값으로 C10B1040 조회 결과 0건 AND cus_bth_pap_no 지정 | FAILURE 반환 (ERRCD_KK01) |
| R06 | 설계Key Fallback - 주문용도코드 완화 단계1 | 주문용도코드에 * 없음 | ord_usg_cd = 앞3자리 + "***" |
| R07 | 설계Key Fallback - 주문용도코드 완화 단계2 | 주문용도코드 = "XXX***" 형태 | ord_usg_cd = 앞1자리 + "*****" |
| R08 | 설계Key Fallback - 주문용도코드 완화 단계3 | 주문용도코드 = "X*****" 형태 | ord_usg_cd = "******" |
| R09 | 설계Key Fallback - 고객사코드 완화 | 주문용도코드 = "******" AND 고객사코드 미지정 아님 | fnl_cus_cd = "******" |
| R10 | 설계Key Fallback - 색상코드 완화 | 고객사코드가 와일드카드 AND 색상코드 미지정 아님 | clr_cd = "*****" |
| R11 | 설계Key 매칭 결과 2건 이상 | result.getRecordCount() > 1 | FAILURE 반환 (ERRCD_KK02) |
| R12 | 위탁임가공 통과공정 Override | poc_cgl_yn="Y" AND poc_ccl_yn="Y" | COL_PAS_PROC_NO = "3OA001" |
| R13 | 위탁임가공 통과공정 Override | poc_cgl_yn="Y" AND poc_ccl_yn="N" | COL_PAS_PROC_NO = "GOH001" |
| R14 | 위탁임가공 통과공정 기본 | 그 외 | COL_PAS_PROC_NO = 규칙 결과값 |
| R15 | Material Code 미존재 | mtl_cd = 공백 | FAILURE 반환 (ERRCD_KP06) |
| R16 | 복합조 폭 다양성 | ord_slit_grp_cnt > 1 AND 혼합폭 중 하나라도 다름 | ord_mix_wth_tp = "Y" |
| R17 | 주문두께구분 결정 | spc_avr = "KS" 또는 "JS" | colValue[1] = "1" (주문두께구분) |
| R18 | 주문두께구분 결정 | spc_avr 이 KS/JS 아님 | colValue[1] = "2" |
| R19 | Class5 결정 (냉연계) | 품명코드 E,2,N,8 | Class5 = gw_asg_cd |
| R20 | Class5 결정 (냉연계 외) | 그 외 A,B,C,D,1,5,7 | Class5 = ord_rou_cd |
| R21 | Class4 결정 (도금계) | 품명코드 G,K,J,L,V,W,3,4,6,9 | Class4 = ord_spnl_tp |
| R22 | Sub 클래스코드 추출 | mtl_cd 길이 > 14 AND '-' 없음 | COL_SUB_CLS_CD = mtl_cd.substring(7,13) + ccl_bom_no |
| R23 | Sub 클래스코드 추출 | mtl_cd 길이 > 14 AND '-' 있음 | COL_SUB_CLS_CD = mtl_cd.substring(8,14) + ccl_bom_no |
| R24 | Sheet 포장재중량 계산 | prd_shp = PRD_SHP_SHEET | 폭+길이 합산 후 C10A2230 계산식 실행, 소수 0자리 반올림 |
| R25 | 코일 포장재중량 조회 | prd_shp = PRD_SHP_COIL | C10B1081 규칙 조회 (포장방법, 폭, 포장단중, 길이) |

---

## 4. SQL 매핑

| SQL Key 상수 | 용도 | 호출 시점 |
|---|---|---|
| INSERT_MSG | 품질메시지(RMTL, MSG, TP) Insert | 매칭 성공 후, CRM_MNF_STD_NO 존재 건수별 반복 |
| INSERT_MSG_COR | 정전(관리) 메시지 Insert | INSERT_MSG 완료 후 |

---

## 5. EasyAccess 규칙 매핑

| Master Table Code | 용도 | 조건 키 |
|---|---|---|
| C10B1040 | 품질설계Key 매칭 (핵심) | 품명, 형태, 규격약호, 주문용도, 고객사, 고객사양번호, EMBOSS, Spangle, 도금량, 표면처리, 색상코드, 두께, 폭 |
| C10B9980 | ClassCode1 (제품군) | 품명코드, 주문두께구분, 주문EDG, 규격기관 |
| C10B9981 | ClassCode2 (행선지) | 품명코드, 제품형태, 조분할수, 복합조 여부, 주문종류 |
| C10B9982 | ClassCode34 (재질, 냉연/원판) | 품명코드, 재질코드 |
| C10B9983 | ClassCode3 (재질, 도금계) | 품명코드, 재질코드, 규격기관 |
| C10B9984 | ClassCode6 (표면처리) | 품명코드, 주문표면처리코드 |
| C10B2080 | 조도코드 (EG/EG칼라 전용) | 품명코드, 규격기관, 주문용도, 최종수요가, 두께, 폭 |
| C10B1081 | 포장재중량 (코일) | 포장방법, 폭범위, 포장단중, 길이범위 |
| C10A2230 | 포장재중량 계산식 (Sheet) | 유통경로, 폭+길이합계, 제품폭, 제품길이 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

강판 제조 MES에서 수주 주문에 대한 품질설계 핵심 단계이다.
고객 주문의 다양한 속성(제품 종류, 규격, 고객사, 용도 등)을 종합하여 설계 Key를 확정하고, 이를 바탕으로 생산 공정에서 적용할 품질 기준(재질, 제조규격, 통과공정)과 제품 분류코드(CLS_CD)를 결정한다.

### 6.2 와일드카드 Fallback 전략

설계Key 매칭 시 엄격 조건부터 시도하고 매칭 실패 시 선택 조건을 와일드카드(`*`)로 단계적으로 완화하여 재시도한다.
완화 순서: 주문용도코드 3자리 → 5자리 → 전체 → 고객사코드 → 색상코드 순으로 확장되며, 고객사양번호가 지정된 경우에는 Fallback 없이 즉시 실패 처리한다.

### 6.3 클래스코드 조합 구조

- 냉연/원판 계열 (A,B,C,D,1,E,N,2,5,7,8): `Class1 + Class2 + Class34 + Class5 + Class6`
- 도금 계열 (G,K,J,L,V,W,3,4,6,9): `Class1 + Class2 + Class3 + Class4 + Class5 + Class6`

### 6.4 위탁임가공 처리

CGL(연속용융아연도금), CCL(칼라코팅) 공정의 위탁임가공 주문은 규칙 결과와 무관하게 별도 통과공정번호("3OA001" 또는 "GOH001")를 강제 설정한다.

### 6.5 포장재중량 계산

- 코일: EasyAccess 규칙(C10B1081) 기반 조회
- Sheet: 폭+길이 합산 후 EasyAccess 계산식(C10A2230) 실행, BigDecimal 반올림(ROUND_HALF_UP, 소수 0자리)
