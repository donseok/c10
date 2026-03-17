# C10UiC106000020InsertActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C10UiC106000020InsertActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `DhtmlxActivity` |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 239 라인 |
| 메소드 수 | 4개 (`doMainActivity`, `doPostActivity`, `doPreActivity`, `getDefaultMsgCode`, `getDefaultMsgParam`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

품질설계 시뮬레이션 데이터를 Excel에서 Import하여 `TB_C10_QLT_DSN_SML` 테이블에 저장하는 Activity이다. 화면 그리드에서 넘어온 코일 데이터를 행별로 순회하며, 각 코일 ID의 중복 여부를 먼저 조회한 후 미존재 시에만 INSERT를 수행하는 Upsert-guard 패턴을 사용한다.

### 1.1 상속/구현 관계

- `DhtmlxActivity` 상속 (POSCO ICT GLUE 프레임워크 DHTMLX 전용 Activity)
- DhtmlxActivity 생명주기: `doPreActivity()` → `doMainActivity()` → `doPostActivity()`
- `doPreActivity()`, `doPostActivity()`, `getDefaultMsgCode()`, `getDefaultMsgParam()`은 모두 null 반환 (미구현)
- 실질적 로직은 `doMainActivity()`에만 집중

### 1.2 핵심 입력/출력

| 구분 | 키 | 설명 |
|------|----|------|
| 입력 (ctx) | `IDS` | 화면 그리드 행 ID 배열 (쉼표 구분) |
| 입력 (ctx) | `{rowId}_COIL_ID` | 코일 ID |
| 입력 (ctx) | `{rowId}_PRD_NM_CD` | 제품유형코드 |
| 입력 (ctx) | `{rowId}_SPC_AVR` | 규격약호 |
| 입력 (ctx) | `{rowId}_ORD_USG_CD` | 주문 용도 코드 |
| 입력 (ctx) | `{rowId}_RMTL_CD` | 원자재 코드 |
| 입력 (ctx) | `{rowId}_MQL_CD` | 재질 코드 |
| 입력 (ctx) | `{rowId}_SP_ASG_YN` | 특별 지정 여부 |
| 입력 (ctx) | `{rowId}_COIL_THK` | 코일 두께 |
| 입력 (ctx) | `{rowId}_COIL_WTH` | 코일 폭 |
| 입력 (ctx) | `{rowId}_COIL_WGT` | 코일 중량 |
| 입력 (ctx) | `{rowId}_PDN_DH` | 생산 기일 |
| 입력 (ctx) | `{rowId}_PROC_CD` | 공정 코드 |
| 입력 (ctx) | `{rowId}_RMTL_MAK_FAC_CD` | 원자재 제조사 코드 |
| 입력 (ctx) | `{rowId}_MQL_ACT_YP_MPA` | 실측 항복강도 (MPa) |
| 입력 (ctx) | `{rowId}_MQL_ACT_TS_MPA` | 실측 인장강도 (MPa) |
| 입력 (ctx) | `{rowId}_MQL_ACT_EL` | 실측 연신율 |
| 입력 (ctx) | `{rowId}_MQL_ACT_HRB_AVG` | 실측 경도 평균 |
| 입력 (ctx) | `{rowId}_MQL_ACT_ERI_AVG` | 실측 내식성 평균 |
| 출력 | `PosException` | 오류 발생 시 throw (`{COIL_ID}데이타 오류입니다.`) |
| 반환값 | `SUCCESS` | 정상 완료 |

---

## 2. 메소드 상세 분석

### 2.1 doPreActivity(PosContext arg0)

**목적**: 전처리 (미구현)
**복잡도**: 없음
**처리 흐름**: `return null;` 즉시 반환

### 2.2 doMainActivity(PosContext ctx)

**목적**: Excel Import 코일 데이터를 TB_C10_QLT_DSN_SML에 저장 (중복 제외)

**복잡도**: 중간 (루프 + 중복체크 후 조건부 INSERT)

**처리 흐름:**

```
1. mesdao(MESDAO) 취득, PosParameter 초기화
2. ctx에서 IDS(String[]) 추출
   - null 또는 비어있으면 PosException("IDS가 존재하지 않습니다.") throw
3. ids[0]을 쉼표 분리하여 idsValue(행 ID 배열) 생성
4. 루프 (i=0 ~ idsValue.length-1):
   4-1. 18개 컬럼(String[]) PosContext에서 추출
        (COIL_ID, PRD_NM_CD, SPC_AVR, ORD_USG_CD, RMTL_CD, MQL_CD, SP_ASG_YN,
         COIL_THK, COIL_WTH, COIL_WGT, PDN_DH, PROC_CD, RMTL_MAK_FAC_CD,
         MQL_ACT_YP_MPA, MQL_ACT_TS_MPA, MQL_ACT_EL, MQL_ACT_HRB_AVG, MQL_ACT_ERI_AVG)
   4-2. param에 COIL_ID 설정 후 "C106000020.coilIdSelect" 조회 (중복 체크)
   4-3. rowset == null 또는 rowset.count() <= 0 이면 (미존재):
        - 18개 컬럼 모두 파라미터 설정
        - "C106000020.insert" 실행 (INSERT)
        - idx 증가
5. SUCCESS 반환
예외 발생 시:
   - PosException("{COIL_ID[idx]}데이타 오류입니다.") throw
   - System.out.println(e.getMessage()) 및 logger.logDebug() 출력
```

### 2.3 doPostActivity(PosContext arg0)

**목적**: 후처리 (미구현)
**복잡도**: 없음
**처리 흐름**: `return null;` 즉시 반환

### 2.4 getDefaultMsgCode()

**목적**: 기본 메시지 코드 반환 (미구현)
**처리 흐름**: `return null;`

### 2.5 getDefaultMsgParam(PosContext arg0)

**목적**: 기본 메시지 파라미터 반환 (미구현)
**처리 흐름**: `return null;`

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | IDS 필수 검증 | `ids == null` 또는 `ids.length < 1` | PosException("IDS가 존재하지 않습니다.") throw |
| 2 | 코일 중복 방지 | `rowset == null` 또는 `rowset.count() <= 0` (coilIdSelect 결과) | INSERT 실행 |
| 3 | 이미 존재하는 코일 | `rowset.count() > 0` | INSERT 건너뜀 (중복 무시) |
| 4 | 오류 코일 ID 표시 | 예외 발생 시 | `COIL_ID[idx]` 값을 오류 메시지에 포함 |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| `C106000020.coilIdSelect` | COIL_ID 기준 중복 여부 조회 | 루프 내 각 행 처리 시 |
| `C106000020.insert` | TB_C10_QLT_DSN_SML INSERT | coilIdSelect 결과 없을 때 |

---

## 5. Route Transition

| 반환값 | 조건 | 설명 |
|--------|------|------|
| `SUCCESS` | 모든 행 처리 완료 | 정상 종료 |
| `PosException` throw | `ids` 없거나 Exception 발생 | 예외 전파 (FAILURE 반환 아님) |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

C106000020 화면에서 Excel로 Import된 품질설계 시뮬레이션 데이터를 `TB_C10_QLT_DSN_SML` 테이블에 저장한다. 동일한 COIL_ID가 이미 존재하는 경우 삽입을 건너뛰는 방식으로 중복 저장을 방지한다. 코일의 실측 품질 데이터(항복강도, 인장강도, 연신율, 경도, 내식성)를 포함하여 품질설계 시뮬레이션에 활용한다.

### 6.2 핵심 비즈니스 로직

**중복 방지 패턴:**

각 COIL_ID에 대해 먼저 `C106000020.coilIdSelect`로 존재 여부를 확인하고, 없는 경우에만 `C106000020.insert`를 실행한다. 이 패턴은 MERGE INTO가 아닌 Select-then-Insert 방식으로 구현되어 있다.

**오류 발생 시 인덱스 추적:**

`idx` 변수를 INSERT 성공 시마다 증가시키며, 예외 발생 시 `COIL_ID[idx]`를 오류 메시지에 포함시켜 어느 코일 처리 중 실패했는지 식별 가능하도록 한다. 단, `idx`는 INSERT된 행 수를 추적하므로 예외 발생 행의 인덱스와 다를 수 있다.

**주의사항:**

- 주석 처리된 `mesdao` 변수 선언이 존재하며, 실제로는 `dao` 변수 사용
- `rollbackTransaction`이 호출되지 않아 트랜잭션 롤백은 프레임워크 또는 상위에서 처리해야 함
- `System.out.println()`이 예외 처리에 사용됨 (운영 환경 출력 주의)
