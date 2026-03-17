# DbSearchMechData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchMechData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `497` 라인 |
| 메소드 수 | `1`개 (`runActivity`) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

마스터 데이터에서 재질사양 기준을 조회하여 제품의 재질사양(MQL: Mechanical Quality Level)을 편성하는 NUI(배치/백엔드) Activity 클래스이다. 제품사양설계종류(prodSpecKind)에 따라 고객사양(1), 규격사양(2), 사내사양(3), 보증사양(4) 네 가지 경로로 분기하여 각각 다른 마스터 소스에서 재질 데이터를 읽고 PosContext에 등록한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE Framework의 Activity 기반 클래스. `runActivity(PosContext)` 메소드를 구현
- `C10NuiConstantsIF` 구현: C10 NUI 공통 상수(에러코드, SQL 키, 컬럼명, 마스터 테이블 코드 등) 제공

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 (Property) | `prodSpecKind` | 제품사양설계종류 (`1`=고객, `2`=규격, `3`=사내, `4`=보증) |
| 입력 (Property) | `dao` | DAO bean ID (masterdao 또는 mesdao) |
| 입력 (Context) | `COL_ORD_NO`, `COL_ORD_LN` | 주문번호, 주문행번 (공통 필수) |
| 입력 (Context, kind=1) | `COL_CUS_BTH_PAP_NO` | 고객사양번호 |
| 입력 (Context, kind=2) | `COL_SPC_AVR`, `COL_SPC_YR`, `COL_ORD_EXC_THK` | 규격약호, 규격년도, 주문환산두께 |
| 입력 (Context, kind=3) | `COL_PRD_NM_CD`, `COL_MQL_CD`, `COL_ORD_EXC_THK` | 품명코드, 재질코드, 주문환산두께 |
| 출력 (Context) | 재질사양 컬럼 전체 | TS, YP, ELGN, HRB, ER 등 재질시험 상하한값 및 관련 정보 |
| 출력 (Context) | `COL_QLT_DSN_SPC_TP` | 품질설계사양구분 (prodSpecKind 값) |
| 반환값 | `SUCCESS` / `FAILURE` / `FALSE` | 성공, 오류, 데이터 없음(고객사양 kind=1) |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 제품사양설계종류에 따른 재질사양 마스터 데이터 조회 및 PosContext 등록 |
| 복잡도 | 높음 |
| 파라미터 | `ctx` - 서비스 내 데이터를 관리하는 PosContext 객체 |
| 반환 타입 | `String` (Route Transition 값) |

**처리 흐름**:

1. `prodSpecKind` 프로퍼티 값을 읽어 `COL_QLT_DSN_SPC_TP`로 Context에 등록
2. DAO bean 획득 (`dao` 프로퍼티로 지정)
3. `prodSpecKind` 값에 따라 4가지 분기 처리:
   - `"1"` (고객사양): COL_CUS_BTH_PAP_NO로 `VI_M00_C10A1022` 뷰 조회 → 1건이면 모든 컬럼을 Context에 등록, 0건이면 `FALSE` 반환, 2건 이상이면 `FAILURE`
   - `"2"` (규격사양): EasyAccess `C10B1012` 업무기준으로 규격약호+규격년도+주문환산두께 키 조회 → 1건이면 Context 등록, 그 외는 `FAILURE`
   - `"3"` (사내사양): EasyAccess `C10B1032` 업무기준으로 품명코드+재질코드+주문환산두께 키 조회 → 1건이면 Context 등록, 그 외는 `FAILURE`
   - `"4"` (보증사양): `SELECT_MQL` (C102100MQL.select) 쿼리로 고객사양(kind=1), 규격사양(kind=2), 사내사양(kind=3)을 각각 조회하여 보증사양 합성 로직 적용
4. `SUCCESS` 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|------|------|------|
| 1 | 고객사양 단일 조회 | `VI_M00_C10A1022` 조회 결과 == 1 | 전체 컬럼 Context 등록 |
| 2 | 고객사양 없음 허용 | 조회 결과 == 0 | `FALSE` 반환 (에러 아님, 정상 종료) |
| 3 | 고객사양 중복 오류 | 조회 결과 > 1 | ERRCD_KC11 오류, `FAILURE` |
| 4 | 규격사양 단일 조회 | C10B1012 EasyAccess 결과 == 1 | 전체 컬럼 Context 등록 |
| 5 | 규격사양 없음/중복 오류 | 조회 결과 != 1 | ERRCD_KS03 오류, `FAILURE` |
| 6 | 사내사양 중복 오류 | C10B1032 EasyAccess 결과 > 1 | ERRCD_KN12 오류, `FAILURE` |
| 7 | 사내사양 없음 오류 | C10B1032 EasyAccess 결과 == 0 | ERRCD_KN02 오류, `FAILURE` |
| 8 | 보증사양 규격사양 필수 | SELECT_MQL kind=2 조회 결과 == 0 | ERRCD_KS23 오류, `FAILURE` |
| 9 | 보증사양 하한값 합성 | TS_LLV_MPA, YP_LLV_MPA, ELGN_LLV, HRB_LLV, ER_LLV, TST_GW_*_LLV | 고객/규격/사내 중 큰 값 적용 (`numCompare(..., true)`) |
| 10 | 보증사양 상한값 합성 | TS_ULV_MPA, YP_ULV_MPA, ELGN_ULV, HRB_ULV, ER_ULV, TST_GW_*_ULV | 0/NULL 제외 작은 값 적용 (`numCompare(..., false)`) |
| 11 | 보증사양 기타 컬럼 | 하한/상한 외 컬럼 | 고객사양 우선, 없으면 규격사양 적용 |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 | DAO |
|---------|------|-----------|-----|
| `C10A1022` (VI_M00_C10A1022) | 고객재질 마스터 뷰 조회 | prodSpecKind='1' | masterdao |
| `C102100MQL.select` (SELECT_MQL) | 기존 품질설계결과재질 조회 | prodSpecKind='4' (보증사양, 3회 호출) | mesdao |

---

## 5. 참조 업무기준 (EasyAccess)

| 업무기준 ID | 키 컬럼 | 결과 | 용도 |
|------------|---------|------|------|
| `C10B1012` (규격재질) | 규격약호, 규격년도, 주문환산두께 | 재질시험 상하한값 등 | prodSpecKind='2' 규격사양 조회 |
| `C10B1032` (사내재질) | 품명코드, 재질코드, 주문환산두께 | 재질시험 상하한값 등 | prodSpecKind='3' 사내사양 조회 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

동국제강 MES에서 주문된 제품의 품질설계 프로세스 중 재질사양 편성 단계를 담당한다. 철강 제품은 납품 전 인장강도(TS), 항복점(YP), 연신율(ELGN), 경도(HRB), 탄성계수(ER) 등의 기계적 재질 시험 기준을 확정해야 한다. 이 클래스는 주문의 사양설계종류에 따라 적합한 마스터 데이터 소스에서 재질 기준값을 조회하여 품질설계 결과에 사용될 수 있도록 준비한다.

### 6.2 핵심 비즈니스 로직

**보증사양(kind=4) 합성 알고리즘**이 이 클래스의 핵심이다:

1. **고객사양(kind=1) 조회** - TB_C10_QLT_DSN_MQL에서 이미 설계된 고객사양 데이터 로드 (없어도 계속 진행)
2. **규격사양(kind=2) 조회** - 규격사양은 필수. 없으면 KS23 오류로 종료
3. **사내사양(kind=3) 조회** - 있으면 추가 적용
4. **합성 우선순위 규칙**:
   - 하한값(LLV): `max(고객, 규격, 사내)` → 가장 엄격한(높은) 기준 적용
   - 상한값(ULV): `min(고객, 규격, 사내, 단 0/NULL 제외)` → 가장 엄격한(낮은) 기준 적용
   - 기타 컬럼: 고객사양 우선, 없으면 규격사양 적용 (사내사양도 동일 패턴)

이 로직은 고객과 규격 기준 중 더 엄격한 쪽을 자동으로 선택하여 제품 품질 기준의 준수를 보장한다.

### 6.3 업무기준(EasyAccess) 참조

- **C10B1012 (규격재질)**: POSCO ICT GLUE Framework의 EasyAccess 업무기준 테이블. `PosDecisionChecker`를 통해 규격약호, 규격년도, 주문환산두께의 3-key 룩업으로 재질 시험 기준값 반환
- **C10B1032 (사내재질)**: 동국제강 사내 재질 기준. 품명코드, 재질코드, 주문환산두께의 3-key 룩업

### 6.4 타 시스템 연동

| 시스템 | 방식 | 설명 |
|--------|------|------|
| M00APUSER (마스터 DB) | `masterdao` via `VI_M00_C10A1022` | 고객재질 마스터 뷰 조회 |
| GLUE EasyAccess | `EasyAccess.getPosDecisionChecker()` | 규격재질(C10B1012), 사내재질(C10B1032) 업무기준 조회 |

### 6.5 데이터 영향 범위

- **조회 전용**: 본 클래스는 데이터를 읽어 PosContext에 등록만 함. DB 쓰기는 없음
- **후속 서비스**: 조회한 재질사양 데이터는 다음 Activity(예: `PosInsert`)가 `TB_C10_QLT_DSN_MQL` 테이블에 INSERT/UPDATE하는 데 사용
- **영향 테이블**: `TB_C10_QLT_DSN_MQL` (품질설계결과재질), `VI_M00_C10A1022` (고객재질 마스터뷰, 읽기 전용)

### 6.6 주의사항 및 제약조건

- `prodSpecKind='1'` (고객사양)에서 조회 결과가 0건이면 `FALSE`를 반환하여 서비스 흐름에서 정상 종료(`end`)로 처리됨 - 이는 고객사양이 없는 경우 skip을 의도한 설계
- `prodSpecKind='2'` (규격사양)에서 결과가 0건이어도 `FAILURE`를 반환하여 오류 처리됨 - 규격사양은 필수 데이터로 간주
- 보증사양(kind=4)에서 `numCompare(obj1, obj2, false)`는 상한값 비교 시 0값을 "없음"으로 간주하여 제외하는 로직이 `DbCommonUtil.numCompare`에 구현되어 있음
- `MasterDataException` 발생 시 EasyAccess 오류로 간주하여 해당 오류코드로 `FAILURE` 처리

---

## 7. 사용 서비스

| 서비스 ID | prodSpecKind | DAO | success 전이 |
|-----------|-------------|-----|-------------|
| `C102100050-service` | `1` (고객사양) | mesdao | INSERT |
| `C102100090-service` | - | - | - |
| `C102100120-service` | - | - | - |
| `C102100140-service` | - | - | - |
