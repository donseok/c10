# DbSearchPakMtlWgtData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchPakMtlWgtData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 181 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

포장재중량(PAK_MTL_WGT)을 편성하는 Activity 클래스다. 주문 제품의 형태(코일/쉬트)에 따라 해당 마스터 데이터 기준(EasyAccess)을 조회하여 포장재중량 값을 PosContext에 등록한다. 정보가 존재하면 `success`, 존재하지 않으면 `false` 또는 `failure`로 전환한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크의 Activity 추상 클래스. `runActivity(PosContext)` 메소드를 구현한다.
- `C10NuiConstantsIF` 구현: C10 NUI 모듈 공통 상수 인터페이스 (컬럼명, 에러코드, 마스터 테이블 코드 등).

### 1.2 핵심 입력/출력

**입력 (PosContext 필수 항목)**

| 컬럼 상수 | 설명 | 비고 |
|-----------|------|------|
| `COL_ORD_PAK_MTH` | 포장방법 | 공통 필수 |
| `COL_PRD_NM_CD` | 품명코드 | 공통 필수 |
| `COL_PRD_SHP` | 제품형태 | 분기 기준 (COIL/SHEET) |
| `COL_ORD_EXC_THK` | 주문환산두께 | 코일 조회 키 |
| `COL_ORD_EXC_WTH` | 주문환산폭 | 코일 및 쉬트 조회 키 |
| `COL_PAK_UNT_WGT` | 포장단중 | 코일 및 쉬트 조회 키 |
| `COL_ORD_EXC_LTH` | 주문환산길이 | 쉬트 전용 추가 필수 |

**출력 (PosContext 등록 항목)**

| 컬럼 상수 | 설명 |
|-----------|------|
| `COL_ORD_PAK_MTL_WGT` | 포장재중량 (조회 성공 시) |
| `COL_QLT_DSN_ERR_CD` | 품질설계 에러코드 (오류 시) |
| `C10STR_P_ERR_KEY` | 에러 존재 여부 플래그 (오류 시) |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 포장재중량 마스터 조회 및 결과 등록

**복잡도**: 낮음 (단일 메소드, 선형 분기)

**처리 흐름**:

```
1. 공통 파라미터 Null 체크
   - COL_ORD_PAK_MTH, COL_PRD_NM_CD, COL_PRD_SHP, COL_ORD_EXC_THK, COL_ORD_EXC_WTH, COL_PAK_UNT_WGT
   - 하나라도 Null이면 ERRCD_KS11 설정 후 FAILURE 반환

2. 제품형태(PRD_SHP)에 따른 분기
   A. PRD_SHP = PRD_SHP_COIL (코일)
      - 키: 포장방법, 주문두께, 주문폭, 포장단중 (4개)
      - 마스터: C10B1081 (포장재중량 기준 Coil)
      - EasyAccess.getPosDecisionChecker(C10B1081).getPosRule(colValue) 호출
      - 결과 1건: COL_ORD_PAK_MTL_WGT 등록 → SUCCESS
      - 결과 >1건: ERRCD_KK46 설정 → FAILURE
      - 결과 0건: ERRCD_KK45 설정 → FALSE

   B. PRD_SHP = PRD_SHP_SHEET (쉬트)
      - COL_ORD_EXC_LTH 추가 Null 체크
      - 키: 포장방법, 주문폭, 주문길이, 포장단중 (4개)
      - 마스터: C10B1082 (포장재중량 기준 Sheet)
      - EasyAccess.getPosDecisionChecker(C10B1082).getPosRule(colValue) 호출
      - 결과 1건: COL_ORD_PAK_MTL_WGT 등록 → SUCCESS
      - 결과 >1건: ERRCD_KK48 설정 → FAILURE
      - 결과 0건: ERRCD_KK47 설정 → FAILURE

3. 반환: SUCCESS
```

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 공통 파라미터 필수 | 6개 항목 중 하나라도 Null | FAILURE (ERRCD_KS11) |
| 2 | 코일 분기 | PRD_SHP = PRD_SHP_COIL | C10B1081 마스터 조회 |
| 3 | 쉬트 분기 | PRD_SHP = PRD_SHP_SHEET | C10B1082 마스터 조회 + 길이 필수 |
| 4 | 코일 단건 조회 | 결과 1건 | COL_ORD_PAK_MTL_WGT 등록, SUCCESS |
| 5 | 코일 복수 조회 | 결과 >1건 | FAILURE (ERRCD_KK46) |
| 6 | 코일 미조회 | 결과 0건 | FALSE 반환 (FAILURE 아님) |
| 7 | 쉬트 단건 조회 | 결과 1건 | COL_ORD_PAK_MTL_WGT 등록, SUCCESS |
| 8 | 쉬트 복수/미조회 | 결과 !=1건 | FAILURE (ERRCD_KK47/KK48) |

---

## 4. SQL 매핑

본 클래스는 DAO를 직접 사용하지 않고 EasyAccess 마스터 조회만 사용한다.

| 마스터 코드 | 용도 | 키 항목 |
|-------------|------|---------|
| `C10B1081` | 포장재중량 기준 (코일) | 포장방법, 두께, 폭, 포장단중 |
| `C10B1082` | 포장재중량 기준 (쉬트) | 포장방법, 폭, 길이, 포장단중 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

포장재중량 설계 단계에서 주문 제품이 코일 형태인지 쉬트 형태인지에 따라 다른 마스터 기준표를 참조하여 포장에 소요되는 자재 중량을 결정한다. 이 값은 이후 품질설계 결과에 반영된다.

코일과 쉬트는 포장 방식이 다르므로 조회 키 구성도 다르다. 코일은 두께가 추가 키이고, 쉬트는 두께 대신 길이가 추가 키다. 쉬트의 경우 0건 조회 시 FALSE가 아닌 FAILURE를 반환하는 점이 코일과 다르다 (코일은 0건 시 FALSE로 Skip 처리).
