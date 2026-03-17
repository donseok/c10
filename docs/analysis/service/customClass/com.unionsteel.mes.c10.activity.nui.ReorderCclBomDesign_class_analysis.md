# ReorderCclBomDesign 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/ReorderCclBomDesign.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 524 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

칼라제조사양을 재편성(Reorder)하는 Activity 클래스다. `DbSearchCclBomData`와 로직이 거의 동일하나, 본 클래스는 기존 편성 이후 재편성(재설계) 시 호출된다. CCL BOM 기준 조회, 감량매직체크기준, 지관발주메시지기준, PE-FOAM 적용메시지 기준의 EasyAccess 4종, 그리고 칼라물성기준 4단계 Fallback 조회를 수행하여 PosContext에 등록한다.

`DbSearchCclBomData`와의 핵심 차이점은 칼라물성기준(SELECT_CLR_MPR) 1건 성공 시 `COL_KEY_WRD1~4`를 등록하지 않는다는 점이다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크 Activity 추상 클래스.
- `C10NuiConstantsIF` 구현: C10 NUI 공통 상수 인터페이스.

### 1.2 핵심 입력/출력

**입력 (PosContext)**: `DbSearchCclBomData`와 동일한 17개 항목.

**출력 (PosContext)**: `DbSearchCclBomData`와 동일하나 `COL_KEY_WRD1~4` 미등록.

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 칼라제조사양 재편성 (CCL BOM + EasyAccess 4종 + 칼라물성기준 4단계 Fallback)

**복잡도**: 높음 (`DbSearchCclBomData`와 동일한 구조)

**처리 흐름**:

`DbSearchCclBomData.runActivity`와 동일한 9단계 흐름을 따른다. 유일한 차이는 9단계(칼라물성기준 1건 성공 시)에서 `COL_KEY_WRD1~4`를 등록하지 않는다는 점이다.

```
1~8단계: DbSearchCclBomData와 동일
   - 파라미터 추출 (17개)
   - 칼라 제품 체크 (PRD_NM_CD 1~9)
   - SELECT_CCL_BOM DAO 조회
   - C10B2280 (감량매직체크기준) 조회
   - C10B2290 (지관발주메시지기준) 조회
   - C10B2300 (PE-FOAM메시지기준) 조회
   - CCL BOM 전체 컬럼 PosContext 등록 (QLT_DSN_CFM_TP 특수 처리)
   - 보호필름 코드 5개 분해 등록

9단계: SELECT_CLR_MPR 4단계 Fallback 조회 (DbSearchCclBomData와 차이)
   - 1건 성공 시: 물성값 14종 등록 (COL_KEY_WRD1~4 미등록)
   - DbSearchCclBomData는 COL_KEY_WRD1~4를 추가로 등록

10단계: SUCCESS 반환
```

### 2.2 DbSearchCclBomData와의 비교

| 항목 | DbSearchCclBomData | ReorderCclBomDesign |
|------|-------------------|-------------------|
| 사용 시점 | 신규 편성 (최초) | 재편성 |
| 서비스 | C102100160-service | C102100170-service |
| COL_KEY_WRD1~4 등록 | O | X |
| 나머지 로직 | 동일 | 동일 |

### 2.3 Fallback 조회 로직 (while 루프)

`DbSearchCclBomData`와 동일한 4단계 Fallback 패턴을 사용한다.

| 단계 | fnl_cus_cd | ord_usg_cd | 진입 조건 |
|------|-----------|-----------|---------|
| 1 | 원래값 | 원래값 | 최초 |
| 2 | 원래값 | `******` | 0건이고 fnl이 `******` |
| 3 | `******` | 원래값(복원) | 0건이고 usg가 `******` |
| 4 | `******` | `******` | 0건이고 둘 다 `******` → FAILURE |

---

## 3. 비즈니스 규칙

`DbSearchCclBomData`와 동일한 규칙 적용. 단, COL_KEY_WRD1~4 등록 규칙 미적용.

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 칼라 제품 체크 | PRD_NM_CD NOT IN (1~9) | FALSE (Skip) |
| 2 | CCL BOM 단건 필수 | 결과 0건 또는 >1건 | FAILURE |
| 3 | 지관발주 메시지 억제 | COL_ORD_SLV_KND_TP = 'N' | COL_PPR_RNG_PORD_TXT = "" |
| 4 | 품질설계확정 수동 유지 | CCL BOM의 QLT_DSN_CFM_TP = 'M' AND C10B2260 미조회 | COL_QLT_DSN_CFM_TP = 'M' 유지 |
| 5 | 품질설계확정 null 처리 | CCL BOM의 QLT_DSN_CFM_TP = null | COL_QLT_DSN_CFM_TP = 'M' 설정 |
| 6 | 보호필름 코드 분해 | ord_ptt_flm_dtl_cd 길이에 따라 | 5개 개별 코드로 등록 |
| 7 | 칼라물성기준 4단계 Fallback | 0건 시 순차 ****** 대체 | 최종 0건 시 FAILURE |
| 8 | 키워드 미등록 | 항상 | COL_KEY_WRD1~4 등록 안 함 |

---

## 4. SQL 매핑

`DbSearchCclBomData`와 동일.

| SQL Key / 마스터 코드 | 용도 | 파라미터 | 호출 시점 |
|----------------------|------|---------|---------|
| `SELECT_CCL_BOM` (DAO) | CCL BOM 기준 조회 | CCL_BOM_NO | 최초 CCL BOM 조회 |
| `SELECT_CLR_MPR` (DAO) | 칼라물성기준 조회 | CCL_BOM_NO, fnl_cus_cd, ord_usg_cd | while 루프 (최대 4회) |
| `C10B2280` (EasyAccess) | 감량매직체크기준 | 6개 조건 | CCL BOM 조회 후 |
| `C10B2290` (EasyAccess) | 지관발주메시지기준 | 13개 조건 | C10B2280 후 |
| `C10B2300` (EasyAccess) | PE-FOAM적용메시지기준 | 15개 조건 | C10B2290 후 |
| `C10B2260` (EasyAccess) | 수동확정기준 | 품명코드, 최종수요가코드 (2개) | QLT_DSN_CFM_TP='M'인 경우 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

주문의 품질설계가 이미 수행된 이후, 변경 사유(고객 변경, 사양 변경 등)로 인해 칼라제조사양을 재편성해야 하는 경우에 사용된다. 신규 편성(`DbSearchCclBomData`)과 동일한 마스터 조회 및 편성 로직을 적용하되, 재편성 시에는 키워드 항목(`COL_KEY_WRD1~4`)을 갱신하지 않는다.

두 클래스가 분리된 이유는 동일한 로직이지만 서비스 트랜잭션 흐름에서 다른 후속 서비스로 전환되기 때문이다. 신규는 C102100160-service로, 재편성은 C102100170-service로 연결된다.
