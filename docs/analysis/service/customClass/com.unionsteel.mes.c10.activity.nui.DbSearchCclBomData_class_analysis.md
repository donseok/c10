# DbSearchCclBomData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchCclBomData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 530 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

칼라제조사양을 편성하는 Activity 클래스다. 칼라 제품(PRD_NM_CD 1~9)에 대해 CCL BOM 기준 조회, 감량매직체크기준, 지관발주메시지기준, PE-FOAM 적용메시지 기준의 EasyAccess 마스터 4종을 순차 조회한다. 이후 DAO로 칼라물성기준(TB_C10_CLR_MPR)을 조회하고, 품질설계 자동/수동 확정 여부를 처리하며, 보호필름 코드를 분해하여 PosContext에 등록한다.

`ReorderCclBomDesign`과 로직이 거의 동일하나, 본 클래스는 신규 설계(최초 편성) 용도로 사용되며 CCL BOM 조회 결과를 PosContext 전체에 반영하고 `COL_KEY_WRD1~4`를 추가로 등록한다는 점이 다르다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크 Activity 추상 클래스.
- `C10NuiConstantsIF` 구현: C10 NUI 공통 상수 인터페이스.

### 1.2 핵심 입력/출력

**입력 (PosContext)**

| 컬럼 상수 | 설명 |
|-----------|------|
| `COL_PRD_NM_CD` | 품명코드 (칼라 여부 분기 기준) |
| `COL_CCL_BOM_NO` | CCL BOM 번호 |
| `COL_CUS_CD` | 고객사코드 |
| `COL_FNL_CUS_CD` | 최종수요가코드 |
| `COL_ACT_CUS_CD` | 수요가코드 |
| `COL_NAT_CD` | 국가코드 |
| `COL_ORD_USG_CD` | 주문용도코드 |
| `COL_QLT_DSN_CFM_TP` | 품질설계확정구분 |
| `COL_ORD_PTT_FLM_DTL_CD` | 주문보호필름상세코드 |
| `COL_PRD_SHP` | 제품형태 |
| `COL_ORD_EXC_THK` | 주문환산두께 |
| `COL_EMBS_CD` | EMBOSS무늬코드 |
| `COL_ORD_EDG_ASG_TP` | 주문Edge지정구분 |
| `COL_ORD_PAK_UNT_WGT_LLV` | 포장단중하한 |
| `COL_ORD_PAK_UNT_WGT_ULV` | 포장단중상한 |
| `COL_HUE_CD_FRN` | 색상코드(전면/TOP) |
| `COL_ORD_SLV_KND_TP` | 주문내경링종류구분 |

**출력 (PosContext)**

- CCL BOM 기준 전체 컬럼 (TB_C10_CCL_BOM rowset 컬럼 전체)
- 품질설계확정구분 (`COL_QLT_DSN_CFM_TP`)
- 보호필름 분해 코드 5종 (`COL_PTT_FLM_LUS_RT_CD`, `COL_PTT_FLM_THK_CD`, `COL_PTT_FLM_MQL_CD`, `COL_PTT_FLM_SUS_ADH_CD`, `COL_PTT_FLM_PRD_ADH_CD`)
- 감량매직체크 텍스트 (`COL_DEF_RED_TXT`)
- 지관발주 텍스트 (`COL_PPR_RNG_PORD_TXT`)
- PE-FOAM 텍스트 (`COL_PE_FOAM_TXT`)
- 칼라물성 기준 14종 + 키워드 4종

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 칼라제조사양 전체 편성 (CCL BOM + 3종 EasyAccess + 칼라물성기준 + 보호필름 분해)

**복잡도**: 높음 (DAO 조회 2회, EasyAccess 4종, while 루프, 다중 분기)

**처리 흐름**:

```
1. 파라미터 추출
   - 17개 항목을 DbCommonUtil.isNull()로 안전하게 추출

2. 칼라 제품 체크
   - PRD_NM_CD NOT IN (1,2,3,4,5,6,7,8,9) 이면 FALSE 반환 (Skip)

3. SELECT_CCL_BOM 조회 (DAO)
   - 파라미터: CCL_BOM_NO
   - 결과 1건: row 보관
   - 결과 >1건: ERRCD_KP13 → FAILURE
   - 결과 0건: ERRCD_KP03 → FAILURE

4. 감량매직체크기준(C10B2280) EasyAccess 조회
   - 키 6개: 국가코드, 고객사코드, 수요가코드, 최종수요가코드, 용도코드, CCL BOM번호
   - 결과 1건: COL_DEF_RED_TXT 등록
   - 결과 >1건: ERRCD_KT34 → FAILURE
   - 결과 0건: 무시 (오류 없이 계속)

5. 지관발주메시지기준(C10B2290) EasyAccess 조회
   - 키 13개: 고객사, 수요가, 최종수요가, 품명, 제품형태, 두께, 보호필름, EMBOSS, Edge, 포장단중하한/상한, 용도, 색상(TOP)
   - 결과 1건: COL_ORD_SLV_KND_TP = 'N' 이면 COL_PPR_RNG_PORD_TXT = "" 처리, 아니면 조회값 등록
   - 결과 >1건: ERRCD_KT35 → FAILURE
   - 결과 0건: 무시

6. PE-FOAM적용메시지기준(C10B2300) EasyAccess 조회
   - 키 15개: 고객사, 수요가, 최종수요가, 품명, 제품형태, 두께, 국가코드, 보호필름, EMBOSS, Edge, 포장단중하한/상한, 용도대분류(substring(0,1)), 용도, CCL BOM번호
   - 결과 1건: COL_PE_FOAM_TXT 등록
   - 결과 >1건: ERRCD_KT36 → FAILURE
   - 결과 0건: 무시

7. CCL BOM rowset 컬럼 전체 PosContext 등록
   - COL_QLT_DSN_CFM_TP 특수 처리:
     - data가 'M'이고 C10B2260(수동확정기준) 조회 성공이면 자동확정으로 변경 불가
     - data가 null이면 'M'으로 설정
     - 나머지는 그대로 등록
   - 나머지 컬럼: ctx.put(cname, data)

8. 보호필름 코드(ord_ptt_flm_dtl_cd) 분해 등록
   - position 0: COL_PTT_FLM_LUS_RT_CD (광택/무광)
   - position 1: COL_PTT_FLM_THK_CD (두께)
   - position 2: COL_PTT_FLM_MQL_CD (재질)
   - position 3: COL_PTT_FLM_SUS_ADH_CD (강판접착)
   - position 4: COL_PTT_FLM_PRD_ADH_CD (제품접착)

9. 칼라물성기준(SELECT_CLR_MPR) 조회 - while 루프 (4단계 Fallback)
   - 1단계: ccl_bom_no, fnl_cus_cd, ord_usg_cd 로 조회
   - 2단계(0건, fnl='******'): ord_usg_cd = '******' 로 재시도
   - 3단계(0건, usg='******'): fnl_cus_cd = '******', ord_usg_cd = 원래값으로 재시도
   - 4단계(0건, 둘 다 '******'): ERRCD_KP04 → FAILURE
   - 결과 1건: 물성값 14종 + COL_KEY_WRD1~4 등록
   - 결과 >1건: ERRCD_KP14 → FAILURE

10. SUCCESS 반환
```

### 2.2 Fallback 조회 로직 (while 루프 상세)

칼라물성기준 조회는 `while(true)` 루프로 최종수요가코드/주문용도코드를 단계적으로 `******`(6자리 별)로 대체하며 4단계 Fallback 조회를 수행한다.

| 단계 | fnl_cus_cd | ord_usg_cd | 진입 조건 |
|------|-----------|-----------|---------|
| 1 | 원래값 | 원래값 | 최초 |
| 2 | 원래값 | `******` | 0건이고 fnl이 `******` |
| 3 | `******` | 원래값(복원) | 0건이고 usg가 `******` |
| 4 | `******` | `******` | 0건이고 둘 다 `******` → FAILURE |

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 칼라 제품 체크 | PRD_NM_CD NOT IN (1~9) | FALSE (Skip) |
| 2 | CCL BOM 단건 필수 | 결과 0건 또는 >1건 | FAILURE |
| 3 | 지관발주 메시지 억제 | COL_ORD_SLV_KND_TP = 'N' | COL_PPR_RNG_PORD_TXT = "" |
| 4 | 품질설계확정 수동 유지 | CCL BOM의 QLT_DSN_CFM_TP = 'M' AND C10B2260 미조회 | COL_QLT_DSN_CFM_TP = 'M' 유지 |
| 5 | 품질설계확정 null 처리 | CCL BOM의 QLT_DSN_CFM_TP = null | COL_QLT_DSN_CFM_TP = 'M' 설정 |
| 6 | 보호필름 코드 분해 | ord_ptt_flm_dtl_cd 문자열 | 각 position을 개별 코드로 분해 등록 |
| 7 | 물성기준 Fallback 조회 | 4단계 순차 (원래값→고객사 ******→용도 ******→둘다 ******) | 단계별 재조회, 최종 0건 시 FAILURE |
| 8 | 감량/지관/FOAM 0건 허용 | 결과 0건 | 오류 없이 계속 진행 |

---

## 4. SQL 매핑

| SQL Key / 마스터 코드 | 용도 | 파라미터 | 호출 시점 |
|----------------------|------|---------|---------|
| `SELECT_CCL_BOM` (DAO) | CCL BOM 기준 조회 | CCL_BOM_NO | 최초 CCL BOM 조회 |
| `SELECT_CLR_MPR` (DAO) | 칼라물성기준 조회 | CCL_BOM_NO, 최종수요가코드, 주문용도코드 | while 루프 (최대 4회) |
| `C10B2280` (EasyAccess) | 감량매직체크기준 | 국가, 고객사, 수요가, 최종수요가, 용도, CCL BOM번호 (6개) | CCL BOM 조회 후 |
| `C10B2290` (EasyAccess) | 지관발주메시지기준 | 13개 조건 | C10B2280 후 |
| `C10B2300` (EasyAccess) | PE-FOAM적용메시지기준 | 15개 조건 | C10B2290 후 |
| `C10B2260` (EasyAccess) | 수동확정기준 | 품명코드, 최종수요가코드 (2개) | QLT_DSN_CFM_TP='M'인 경우 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

칼라강판(CCL) 제품의 품질설계 초기 편성 단계에서 사용된다. CCL BOM 번호를 키로 제조사양의 기본 정보를 조회하고, 고객/용도 조합으로 물성시험 기준(색차, 경도, MEK, Bending 등)을 결정한다.

`ReorderCclBomDesign`과 로직이 동일하지만 본 클래스는 신규 편성에 사용되며, `COL_KEY_WRD1~4`(키워드 컬럼) 4개를 추가로 등록한다는 차이가 있다. 또한 본 클래스에서는 CCL BOM 조회 결과의 `QLT_DSN_CFM_TP`가 null이면 'M'으로 처리하는 로직이 포함되어 있다.

감량매직체크, 지관발주메시지, PE-FOAM 메시지는 각각 추가 마스터 기준에서 조회한 안내 문구로, 0건이어도 오류가 아니며 해당 값이 없으면 PosContext에 등록되지 않는다.

보호필름 상세코드(ord_ptt_flm_dtl_cd)는 복합 코드로, 위치별로 5개 코드(광택/무광, 두께, 재질, 강판접착, 제품접착)를 substring으로 분해하여 개별 필드에 등록한다. 길이가 부족한 경우 공백으로 처리한다.
