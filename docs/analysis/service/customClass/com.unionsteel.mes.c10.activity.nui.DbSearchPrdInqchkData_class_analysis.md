# DbSearchPrdInqchkData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchPrdInqchkData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 2,095 라인 |
| 메소드 수 | 2개 (`runActivity`, `DelProc`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

생산가부요청 건에 대해 품질설계Key 사항 및 중요 Size(두께, 폭) 를 편성하는 Activity이다. 최대 15단계의 우선순위 조합으로 품질설계KEY(C10B1040 마스터)를 매칭하고, 이를 기반으로 CCL BOM 기준, SP두께 보정, 도금량 기준, 압연두께 Set치, 제품폭여유, 정전폭마진/감소량, 통과공정, 원자재두께/폭, PLTCM 목표폭, 원자재목표폭 등 생산 Size 전체를 설계한다.

### 1.1 상속/구현 관계

```
PosActivity
    └── DbSearchPrdInqchkData implements C10NuiConstantsIF
```

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 (Property) | `dao` | DAO 빈 ID |
| 입력 (Property) | `bind-result` | 이전 RowSet Key |
| 입력 (Context) | `COL_XMSGS` | 선행 에러 여부 확인 |
| 입력 (Context) | `COL_PRD_NM_CD` | 품명코드 |
| 입력 (Context) | `COL_PRD_SHP` | 제품형태 |
| 입력 (Context) | `COL_SPC_AVR` | 규격약호 |
| 입력 (Context) | `COL_ORD_USG_CD` | 주문용도코드 |
| 입력 (Context) | `COL_FNL_CUS_CD` | 최종고객사 |
| 입력 (Context) | `COL_CUS_BTH_PAP_NO` | 고객사양번호 |
| 입력 (Context) | `COL_ORD_EXC_THK` | 주문두께 |
| 입력 (Context) | `COL_ORD_EXC_WTH` | 주문폭 |
| 입력 (Context) | `COL_ORD_SLIT_GRP_CNT` | Slit 조수 |
| 입력 (Context) | `COL_ORD_MIX_WTH1~10` | 조합폭 1~10 |
| 출력 (Context) | `COL_MQL_CD` | 재질코드 |
| 출력 (Context) | `COL_RMTL_CD` | 원자재코드 (적정) |
| 출력 (Context) | `COL_RMTL_CD1`, `COL_RMTL_CD2` | 원자재코드 (차선1,2) |
| 출력 (Context) | `COL_CRM_MNF_STD_NO` | 제조표준번호 |
| 출력 (Context) | `COL_PAS_PROC_NO` | 통과공정번호 |
| 출력 (Context) | `COL_ROL_TAR_THK` | 압연목표두께 |
| 출력 (Context) | `COL_PLTCM_WTH_TRV` | PLTCM 출측폭 |
| 출력 (Context) | `COL_RMTL_TAR_THK` | 원자재목표두께 |
| 출력 (Context) | `COL_RMTL_TAR_WTH` | 원자재목표폭 |
| 출력 (Context) | `COL_XSTAT` | 처리 상태 |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 품질설계KEY 매칭 및 생산 Size 전체(압연목표두께, PLTCM폭, 원자재두께/폭) 설계

**복잡도**: 매우 높음

**처리 흐름 (22단계)**:

#### Phase 0: 선행 에러 처리
- `COL_XMSGS`가 비어있지 않으면 에러 상태 설정 후 `SUCCESS` 조기 반환

#### Phase 1: 입력값 추출
- IF_GRP_ID_REQ 설정 (OMS EAI Call 방식 변경 대응)
- Context에서 약 40개 항목 null safe 추출
- 조합폭 계산:
  - `ord_slit_grp_cnt > 0`: `exc_wth = ord_mix_wth1 + ord_mix_wth2 + ... + ord_mix_wth10`
  - 그 외: `exc_wth = ord_exc_wth`
- 고객사양번호 null 시 `"**********"` 대체, 색상코드(`clr_cd`) = ccl_bom_no 앞 5자리 또는 `"*****"`

#### Phase 2: 품질설계KEY 매칭 (while 루프)

15단계 우선순위로 `EasyAccess.getPosDecisionChecker(C10B1040, null)` 호출:
- 조건값 13개: 품명, 제품형태, 규격약호, 주문용도코드, 최종고객사, 고객사양번호, EMBOSS, Spangle, 도금량, 표면처리, 색상코드(앞5자), 두께, 폭
- 결과 `null` 시 우선순위 강등 전략:
  1. 고객사양번호 지정 → null이면 에러
  2. 고객사양번호 미지정 (끝이 `*`) → 색상코드/고객사코드/주문용도코드 순서로 `*` 확장
  3. 주문용도코드 강등 순서: 원래값 → `XXX***` → `X*****` → `******`
  4. 최종수요가 강등: 원래값 → `******`
  5. 색상코드 강등: 원래값 → `*****`
- 결과 > 1건: 에러 반환
- 결과 1건: 재질코드, 원자재코드(적정/차선1/2), 제조표준번호, 통과공정번호, 품질메시지 편성
- **원자재코드 유효성 체크**:
  - 적정원자재코드 첫 글자가 `D` (구매반제품)이면 차선에 `H`(열연) 반드시 있어야 함
  - 적정원자재코드가 H/M이 아닌데 차선에 H/M이 있으면 에러 (ERRMSG_I38)

#### Phase 3: CCL BOM 기준 (칼라제품군)

품명코드가 PRD_NM_CD_1~9(칼라류)에 해당하면:
- `SELECT_CCL_BOM` View 조회 (조건: `ccl_bom_no`)
- 결과 추출: 코팅방식(COT_MTH), 도막두께전면/후면(PNT_FLM_THK_FRN_TOT/BAK_TOT), 광택도코드(LUS_RT_CD_FRN), 수지구분전면(RSN_TP_FRN), IMPT_ROLL_NO
- **EMBOSS 무늬 체크**:
  - embs_cd = `"1P"`: IMPT_ROLL_NO가 공백이면 에러 (ERRMSG_I41)
  - embs_cd = 공백: IMPT_ROLL_NO가 공백이 아니면 에러 (ERRMSG_I42)

#### Phase 4: SP두께 보정 (알루미늄칼라/스테인레스칼라 제외)

`EasyAccess.getPosDecisionRuleLov(C10B2070, colValue, null)`:
- 조건: 품명, 재질코드(MQL_CD), 주문Spangle, 두께, 폭(조합폭)
- 결과: `COL_THK_CPS_RT` (두께보정률)
- 미존재 시 에러처리 안 함 (logError만)

#### Phase 5: 도금량 기준 (도금제품군)

품명이 도금 관련(G, K, J, L, V, W, E, N, 2, 3, 4, 6, 8, 9)이면:
- `VI_M00_C10A1061` 조회 (조건: 원판품명코드, 도금량지정코드)
- 결과: `COL_GAL_THK_TRV` / 1000 = 도금두께목표 (gal_thk_trv)

#### Phase 6: 압연목표두께 설계

**고객사양 있는 경우** (`VI_M00_C10A1020` 조회):
- 두께구분이 `"3"` (도막+도금포함): `ord_exc_thk -= pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot + gal_thk_trv`
- 두께단위 `CRN`: `crm_thk = ord_exc_thk + 고객요청압연두께, crm_thk += crm_thk × sp_thk / 100`
- 두께단위 `PCN`: `crm_thk = ord_exc_thk + ord_exc_thk × 고객요청압연두께 / 100, crm_thk += crm_thk × sp_thk / 100`
- 두께단위 `TRK`: `crm_thk = 고객요청압연두께`

**고객사양 없거나 crm_thk = 0** (`C10B2060` 마스터 조회):
- 조건: 품명, 규격기관(spc_avr 앞2자), 규격약호, 주문용도, 최종고객사, 두께구분, 두께관리코드, 도금량, 두께범위, 폭범위
- 두께단위 `CRN`: `crm_thk = ord_exc_thk(두께구분2면 -gal_thk_trv) + 두께보정치, crm_thk += crm_thk × sp_thk / 100`
- 두께단위 `PCN`: `crm_thk = ord_exc_thk(두께구분2면 -gal_thk_trv) + ord_exc_thk × 두께보정치 / 100, crm_thk += crm_thk × sp_thk / 100`
- 두께단위 `TRK`: `crm_thk = 두께보정치(두께구분2면 -gal_thk_trv), crm_thk += crm_thk × sp_thk / 100`
- **압연목표두께**: `DbCommonUtil.thk_dot(DbCommonUtil.pltcm_x_Ray(crm_thk))` (소수점 반올림 + X-Ray Set 반영)

**알루미늄칼라/스테인레스칼라** (품명 5, 7): 압연목표두께 = 주문두께

#### Phase 7: 제품폭여유 (`VI_M00_C10A1070`)

조건: `ord_wth_mng_cd` (폭관리코드)
- 결과: `mng_mrg_wth` (폭여유치)
- Slit 조합 시: `mng_mrg_wth × ord_slit_grp_cnt`

#### Phase 8: 정전폭마진 (`C10B1079`)

조건: 주문에지구분, 품명, 제품형태, 코팅방식, 수지타입전면, 두께, CCL_BOM_NO, Spangle구분
- 결과: `col_wth_mgn` (마진폭)

#### Phase 9: 정전폭감소량 (`C10B1077`)

조건: 품명, 재질코드, 압연목표두께, 폭범위
- 결과: `col_wth_shr`

#### Phase 10: CCL폭감소량 (`C10B1078`, 칼라제품군)

조건: 품명, 재질코드, 압연목표두께, 폭범위
- 결과: `ccl_wth_shr`

#### Phase 11: 통과공정삭제기준 (`C10B2010`)

조건 23개: 품명, 백마킹여부, 내경, 내경링종류, 표면처리, 도금량, EMBOSS, 포장단중하한, 코일외경, 두께, 폭, 수지타입전면, 광택코드, 보호필름상세, 재질코드, EDGE지정, 길이, 제품형태, 권취방법, 최종수요가, 주문용도, Spangle, Slit조수
- 삭제 공정 목록 `DEL_PROC` 구성

#### Phase 12: 통과공정기준 (`VI_M00_C10A1054`)

조건: `COL_PAS_PROC_NO` (통과공정번호)
- 삭제기준 적용 후 유효 공정 결정 (`DelProc()` 호출)
- CGL공정코드, EGL공정코드 편성

#### Phase 13: CGL폭감소량 (`C10B1075`, 용융도금)

조건: 품명, 재질코드, 압연목표두께, 폭범위
- 결과: `gal_wth_shr` (CGL 폭감소량)

#### Phase 14: 중간재적용기준 (`C10B2230`, EGL)

EGL공정 포함 시:
- 조건: 품명, 두께, 폭범위
- 미존재 시 에러처리 안 함

#### Phase 15: EGL폭감소량 (`C10B1076`)

조건: 품명, 재질코드, 압연목표두께, 폭범위
- 결과: `gal_wth_shr`

#### Phase 16: PLTCM 출측폭 계산

```
pltcm_wth_trv = wth_trv + col_wth_shr + ccl_wth_shr + gal_wth_shr + col_wth_mgn + mng_mrg_wth
ctx.put(COL_PLTCM_WTH_TRV, Math.round(pltcm_wth_trv))
```

#### Phase 17: 원자재두께 (`C10B1071`)

원자재코드 적정이 `D`(구매반제품)이면:
- 우선순위 매칭 (`C10B2310`): 두께관리코드, 품명, 주문용도코드(4단계 강등), 고객사코드(2단계 강등), 두께
- 결과: `COL_RMTL_TAR_THK = crm_thk`

원자재코드 적정이 D가 아닌 경우:
- `C10B1071` 조회 (조건: 원자재코드, PLTCM두께, PLTCM폭)
- Edge가 `N`(No-Slit) 또는 `C`(Coil Edge): PLTCM폭 + 20mm 적용
- 결과: `COL_RMTL_TAR_THK`

#### Phase 18: PLTCM 폭수축량 (`C10B1074`)

조건: 원자재코드, PLTCM두께, PLTCM폭
- 결과: `tcm_wth_shr_qty`

#### Phase 19: PLTCM 폭마진량 (`C10B1073`)

조건: 원자재코드, 원자재두께, PLTCM폭, 고객사코드
- 결과: `mrg_wth`

#### Phase 20: 원자재목표폭 계산

```
Edge = 'S'(Slit) 또는 'M'(Mill):
    COL_RMTL_TAR_WTH = Math.round(pltcm_wth_trv + tcm_wth_shr_qty + mrg_wth)
Edge = 'C'(Coil Edge):
    COL_RMTL_TAR_WTH = Math.round(pltcm_wth_trv)
Edge = 'N'(No-Slit):
    COL_RMTL_TAR_WTH = Math.round(wth_trv + gal_wth_shr)
```

---

### 2.2 `DelProc(ArrayList<String> DEL_PROC, String MAIN_PROC, String SUB_PROC_CD1, String SUB_PROC_CD2, String SUB_PROC_CD3)`

**목적**: 통과공정(주공정+대체공정3개)에서 삭제대상공정(DEL_PROC)을 제외하고 유효 공정 목록 반환

**복잡도**: 낮음

**처리 흐름**:

1. `DATA_PROC = [MAIN_PROC, SUB_PROC1, SUB_PROC2, SUB_PROC3]` 구성
2. 각 공정 코드를 DEL_PROC와 비교하여 없는 것만 `RESULT_PROC`에 추가
3. `RESULT_PROC` 크기가 4미만이면 공백으로 패딩하여 4개 배열 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 선행 에러 조기 종료 | `COL_XMSGS` 비어있지 않음 | 에러 상태 설정 후 SUCCESS 조기 반환 |
| 2 | 고객사양번호 null 대체 | `cus_bth_pap_no` 공백 | `"**********"` 대체 |
| 3 | 조합폭 계산 | `ord_slit_grp_cnt > 0` | `exc_wth = sum(ord_mix_wth1~10)` |
| 4 | 설계KEY 매칭 없음 (사양번호 미지정) | result = null | 우선순위 강등 후 재시도 |
| 5 | 설계KEY 매칭 없음 (사양번호 지정) | result = null | 에러 반환 (ERRMSG_I01) |
| 6 | 원자재코드 D + 차선 H 없음 | rmtl_cd 첫글자 D, 차선에 H 없음 | ERRMSG_I43 에러 |
| 7 | 구매반제품 적정 + H/M 차선 | rmtl_cd 첫글자 H/M이 아닌데 차선이 H/M | ERRMSG_I38 에러 |
| 8 | CCL BOM EMBOSS 1P | embs_cd="1P", IMPT_ROLL_NO 공백 | ERRMSG_I41 에러 |
| 9 | CCL BOM EMBOSS 없음 | embs_cd=공백, IMPT_ROLL_NO 비공백 | ERRMSG_I42 에러 |
| 10 | 압연목표두께 단위 CRN | `crm_thk = ord_exc_thk + 보정치; crm_thk += crm_thk × sp_thk / 100` | CRN 방식 압연목표두께 |
| 11 | 압연목표두께 단위 PCN | `crm_thk = ord_exc_thk + ord_exc_thk × 보정치 / 100; crm_thk += crm_thk × sp_thk / 100` | PCN 방식 압연목표두께 |
| 12 | 원자재목표폭 Edge S/M | `RMTL_TAR_WTH = round(pltcm_wth_trv + tcm_wth_shr_qty + mrg_wth)` | S/M Edge 원자재폭 |
| 13 | 원자재목표폭 Edge C | `RMTL_TAR_WTH = round(pltcm_wth_trv)` | Coil Edge 원자재폭 |
| 14 | 원자재목표폭 Edge N | `RMTL_TAR_WTH = round(wth_trv + gal_wth_shr)` | No-Slit 원자재폭 |

---

## 4. SQL 매핑

| SQL Key / 마스터 | 용도 | 호출 시점 |
|-----------------|------|-----------|
| `C10B1040` (EasyAccess) | 품질설계KEY 매칭 (15단계 우선순위) | 설계Key 매칭 while 루프 |
| `SELECT_CCL_BOM` | CCL BOM 기준 조회 | 칼라제품군 Phase 3 |
| `C10B2070` (EasyAccess LOV) | SP두께 보정률 | Phase 4 |
| `VI_M00_C10A1061` | 도금량 기준 조회 | 도금제품군 Phase 5 |
| `VI_M00_C10A1020` | 고객공통사양 조회 (압연두께) | Phase 6 (고객사양 있는 경우) |
| `C10B2060` (EasyAccess) | 압연두께Set치보정기준 | Phase 6 (고객사양 없는 경우) |
| `VI_M00_C10A1070` | 제품폭여유기준 | Phase 7 |
| `C10B1079` (EasyAccess) | 정전폭마진량 기준 | Phase 8 |
| `C10B1077` (EasyAccess) | 정전폭감소량 기준 | Phase 9 |
| `C10B1078` (EasyAccess) | CCL폭감소량 기준 | Phase 10 (칼라제품군) |
| `C10B2010` (EasyAccess LOV) | 통과공정삭제기준 | Phase 11 |
| `VI_M00_C10A1054` | 통과공정기준 | Phase 12 |
| `C10B1075` (EasyAccess) | CGL폭감소량 기준 | Phase 13 (용융도금) |
| `C10B2230` (EasyAccess) | 중간재적용기준 | Phase 14 (EGL) |
| `C10B1076` (EasyAccess) | EGL폭감소량 기준 | Phase 15 (EGL) |
| `C10B1071` (EasyAccess) | 원자재두께 기준 | Phase 17 (D가 아닌 경우) |
| `C10B2310` (EasyAccess) | FH두께설계기준 | Phase 17 (D인 경우, 우선순위 4×2=8조합) |
| `C10B1074` (EasyAccess) | PLTCM폭수축량 기준 | Phase 18 |
| `C10B1073` (EasyAccess) | PLTCM폭마진량 기준 | Phase 19 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

생산가부요청에서 수신된 주문 정보를 기반으로 품질설계에 필요한 모든 Size 파라미터를 계산하는 핵심 Activity이다. 압연목표두께 → PLTCM폭 → 원자재두께 → 원자재폭 순서로 역산하여 실제 생산에 필요한 원자재 규격을 결정한다.

### 6.2 PLTCM 출측폭 계산식

```
PLTCM 출측폭 = 주문폭(조합폭 합산)
             + 정전폭감소량(col_wth_shr)
             + CCL폭감소량(ccl_wth_shr, 칼라제품만)
             + CGL/EGL폭감소량(gal_wth_shr, 도금제품만)
             + 정전폭마진량(col_wth_mgn)
             + 제품폭여유치(mng_mrg_wth)
```

### 6.3 원자재목표폭 계산식

```
Edge S/M(슬리팅/밀에지): 원자재폭 = PLTCM폭 + PLTCM폭수축량 + PLTCM폭마진량
Edge C(코일에지):        원자재폭 = PLTCM폭
Edge N(No-Slit):         원자재폭 = 주문폭 + CGL/EGL폭수축량
```

### 6.4 품질설계KEY 우선순위 강등 전략

고객사양번호 미지정 시 조건을 단계적으로 완화하여 최적 매칭을 탐색:
1. 전체 조건 원래값
2. 색상코드 → `*****`
3. 최종수요가 → `******`
4. 주문용도코드 소분류 5자리 → `*`
5. 주문용도코드 소분류 3자리 → `***`
6. 주문용도코드 → `******`
7. 색상코드+최종수요가 조합 강등
8. 이상 조합 반복 (총 15단계)
