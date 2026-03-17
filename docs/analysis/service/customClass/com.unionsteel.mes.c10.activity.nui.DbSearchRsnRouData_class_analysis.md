# DbSearchRsnRouData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchRsnRouData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 183 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

후처리/조도를 편성하는 Activity 클래스다. 품명코드(PRD_NM_CD)에 따라 제품 군을 두 그룹으로 분류한다. 용융도금 제품군은 CGL 표면처리 유형 Set기준(C10B2160) 마스터를 조회하여 수지부착량(하한/상한)을 편성하고, TM공정통과 제품군은 조도설계기준(C10B2210) 마스터를 조회하여 Ra(하한/상한) 값을 편성한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크의 Activity 추상 클래스. `runActivity(PosContext)` 메소드를 구현한다.
- `C10NuiConstantsIF` 구현: C10 NUI 모듈 공통 상수 인터페이스.

### 1.2 핵심 입력/출력

**입력 (PosContext)**

| 컬럼 상수 | 설명 | 비고 |
|-----------|------|------|
| `COL_PRD_NM_CD` | 품명코드 | 필수. 제품군 분류 기준 |
| `COL_ORD_SUR_HND_CD` | 주문표면처리코드 | 용융도금 제품군 조회 키 |
| `COL_ORD_ROU_CD` | 주문조도코드 | TM공정 제품군 조회 키 |

**출력 (PosContext)**

| 컬럼 상수 | 설명 | 제품군 |
|-----------|------|--------|
| `COL_RSN_ATT_AMT_TRV` | 수지부착량 목표값 | 용융도금 |
| `COL_RSN_ATT_AMT_LLV` | 수지부착량 하한 | 용융도금 |
| `COL_RSN_ATT_AMT_ULV` | 수지부착량 상한 | 용융도금 |
| `COL_ROU_RA_LLV` | Ra 하한 | TM공정 |
| `COL_ROU_RA_ULV` | Ra 상한 | TM공정 |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 품명코드에 따른 후처리(수지부착량) 또는 조도(Ra) 설계값 조회 및 등록

**복잡도**: 낮음 (단순 품명 분기, 단일 마스터 조회)

**처리 흐름**:

```
1. COL_PRD_NM_CD Null 체크
   - Null이면 ERRCD_KS11 설정 후 FAILURE 반환

2. 용융도금 제품군 체크 (PRD_NM_CD = G, K, J, L, V, W)
   - 키: 품명코드, 주문표면처리코드 (2개)
   - 마스터: C10B2160 (CGL 표면처리 유형 Set기준)
   - 결과 1건:
     - COL_RSN_ATT_AMT_TRV, COL_RSN_ATT_AMT_LLV, COL_RSN_ATT_AMT_ULV 등록
     - COL_ROU_RA_LLV, COL_ROU_RA_ULV 를 null로 초기화
   - 결과 >1건: ERRCD_KK61 설정 → FAILURE
   - 결과 0건: FALSE 반환 (Skip)

3. TM공정통과 제품군 체크 (PRD_NM_CD = C, E, N, 1, 2, 8)
   - 키: 품명코드, 주문조도코드 (2개)
   - 마스터: C10B2210 (조도설계기준)
   - 결과 1건:
     - COL_ROU_RA_LLV, COL_ROU_RA_ULV 등록
     - COL_RSN_ATT_AMT_LLV, COL_RSN_ATT_AMT_ULV 를 null로 초기화
   - 결과 >1건: ERRCD_KK65 설정 → FAILURE
   - 결과 0건: FALSE 반환 (Skip)

4. 해당 없는 제품군: FALSE 반환

5. 정상 완료 시 SUCCESS 반환
```

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 품명코드 필수 | COL_PRD_NM_CD Null | FAILURE (ERRCD_KS11) |
| 2 | 용융도금 제품군 분류 | PRD_NM_CD IN (G, K, J, L, V, W) | C10B2160 조회 (수지부착량 편성) |
| 3 | TM공정 제품군 분류 | PRD_NM_CD IN (C, E, N, 1, 2, 8) | C10B2210 조회 (Ra 편성) |
| 4 | 해당 없는 제품군 | 두 그룹 모두 해당 없음 | FALSE 반환 (Skip) |
| 5 | 단건 조회 성공 | 결과 1건 | 해당 값 등록, 타 그룹 값은 null 초기화 |
| 6 | 복수 조회 오류 | 결과 >1건 | FAILURE (ERRCD_KK61 또는 KK65) |
| 7 | 미조회 Skip | 결과 0건 | FALSE 반환 |
| 8 | 상호 배타적 초기화 | 용융도금 성공 시 Ra null, TM공정 성공 시 수지부착량 null | 상호 배타 필드 보장 |

---

## 4. SQL 매핑

본 클래스는 DAO를 직접 사용하지 않고 EasyAccess 마스터 조회만 사용한다.

| 마스터 코드 | 용도 | 키 항목 |
|-------------|------|---------|
| `C10B2160` | CGL 표면처리 유형 Set기준 (수지부착량) | 품명코드, 주문표면처리코드 |
| `C10B2210` | 조도설계기준 Ra/PPI/Rmax | 품명코드, 주문조도코드 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

도금/표면처리 제품의 품질설계에서 제품 종류에 따라 서로 다른 표면 품질 기준을 적용한다. 용융도금(GI, GA 등) 제품은 수지부착량 기준이 적용되며, TM(Temper Mill)을 통과하는 냉연/칼라 제품은 조도(Ra) 기준이 적용된다.

두 그룹은 상호 배타적이므로, 한 그룹의 값이 등록될 때 다른 그룹의 값은 null로 초기화하여 이전 단계에서 설정된 잘못된 값이 남지 않도록 처리한다. 두 그룹 모두에 속하지 않는 품명코드는 FALSE를 반환하여 후처리/조도 설계 단계를 Skip한다.
