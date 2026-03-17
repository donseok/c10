# C10UiCheckActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C10UiCheckActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 197 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

작업지시변경저장(C104000050) 서비스에서 설계확정 대상 주문의 설계상태가 확정대기(`QLT_DSN_STS_CD = 'B'`) 상태인지 검증하고, 검증 통과 시 설계상태를 업데이트한 후 EAI 인터페이스 테이블에 전송 레코드를 삽입하는 액티비티이다. 세 개의 유사 클래스(C10UiCheckActivity, C10UiCheckActivity2, C10UiCheckActivity3) 중 첫 번째로, 설계 확정 단계(`'B'` 상태 → 확정 완료)를 처리한다.

### 1.1 상속/구현 관계

`PosActivity`를 상속하며 `DhtmlxActivity`가 아닌 `PosActivity`의 직접 구현체이다. 따라서 생명주기 메소드(`doPreActivity`, `doMainActivity`, `doPostActivity`) 대신 `runActivity(PosContext ctx)` 단일 메소드를 구현한다.

### 1.2 핵심 입력/출력

**입력 (PosContext)**
- `SERVICE_NAME`: 서비스 식별자 (`C104000050_SERVICE`)
- `IDS`: 처리 대상 ID 배열 (콤마 구분)
- `{idsValue}_ORD_NO`: 주문번호 배열
- `{idsValue}_ORD_LN`: 주문행번 배열
- `OBJECT_TYPE`, `OBJECT_ID`, `PROGRAM_ID`, `TIMESTAMP`: 감사 속성
- `COL_IF_GRP_ID`: EAI 인터페이스 그룹 ID

**출력 (PosContext)**
- `ERRMSG`: 오류 메시지 (실패 시)

**반환값**: `SUCCESS` 또는 `FAILURE`

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 작업지시변경저장 서비스 내에서 주문별 설계상태 검증 및 EAI 전송을 일괄 처리한다.

**복잡도**: 중간 (다중 루프 + 다중 DB 작업)

**처리 흐름**:

1. `mesdao`(MESAPUSER), `eaidao`(EAIAPUSER) DAO 취득
2. `ctx.get(SERVICE_NAME)`으로 서비스 ID 확인
3. 서비스 ID가 `C104000050_SERVICE`가 아니면 즉시 `FAILURE` 반환
4. `IDS` 배열 null/빈값 체크 → 없으면 `FAILURE` 반환
5. `ids[0]`를 콤마로 분리하여 `idsValue` 배열 생성
6. `idsValue` 배열을 순회하면서 각 항목 처리:
   a. ctx에서 `{idsValue[i]}_ORD_NO`, `{idsValue[i]}_ORD_LN` 추출
   b. `ORD_NO.length > 0 && ORD_LN.length > 0` 조건 검증
   c. `C104000050_CHECK` 쿼리 실행 (QLT_DSN_STS_CD = 'B' 조건 검증)
   d. 결과 0건이면 `ERRMSG` 저장 후 `FAILURE` 반환
   e. `C104000050_UPDATE` 쿼리로 설계상태 업데이트
   f. `IFB10S1010_INSERT` 쿼리로 EAI 테이블에 전송 레코드 삽입 (COL_QLT_DSN_STS = 'A', COL_QLT_DSN_MSG = 'A')
7. TX1, TX2 커밋
8. `SUCCESS` 반환

**예외 처리**: Exception 발생 시 TX1, TX2 롤백 후 `ERRMSG` 저장, `FAILURE` 반환

**C10UiCheckActivity만의 특징**:
- `ORD_BAK_SND_CAU` 필드를 처리하지 않음 (C10UiCheckActivity2, 3과의 차이점)
- EAI 삽입 시 `COL_QLT_DSN_STS = 'A'`, `COL_QLT_DSN_MSG = 'A'` 고정값 사용

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-1 | 서비스 ID 검증 | SERVICE_NAME != C104000050_SERVICE | FAILURE 반환 (처리 안 함) |
| BR-2 | IDS 존재 검증 | IDS == null OR IDS.length < 1 | FAILURE 반환 |
| BR-3 | 데이터 유효성 검증 | ORD_NO.length == 0 OR ORD_LN.length == 0 | 해당 건 건너뜀 |
| BR-4 | 설계상태 확정대기 검증 | C104000050_CHECK 쿼리 결과 0건 (QLT_DSN_STS_CD != 'B') | ERRMSG 저장 후 FAILURE |
| BR-5 | 설계상태 업데이트 | 검증 통과 시 | mesdao.update(C104000050_UPDATE) 실행 |
| BR-6 | EAI 전송 고정값 | 확정 완료 처리 | COL_QLT_DSN_STS = 'A', COL_QLT_DSN_MSG = 'A' |
| BR-7 | 트랜잭션 커밋 | 전체 루프 완료 후 | TX1, TX2 커밋 |

---

## 4. SQL 매핑

| SQL Key 상수 | 용도 | 호출 시점 | DAO |
|--------------|------|-----------|-----|
| `C104000050_CHECK` | 설계상태 확정대기 여부 조회 (QLT_DSN_STS_CD = 'B') | 각 주문 처리 전 검증 | mesdao |
| `C104000050_UPDATE` | 설계상태 업데이트 | 검증 통과 후 | mesdao |
| `IFB10S1010_INSERT` | EAI 인터페이스 테이블 전송 레코드 삽입 | 업데이트 후 | eaidao |

**쿼리 파라미터 패턴**:
- `C104000050_CHECK`: `setWhereClauseParameter(0, ORD_NO)`, `setWhereClauseParameter(1, ORD_LN)` (위치 기반)
- `C104000050_UPDATE`: Named Parameter (ORD_NO, ORD_LN, OBJECT_TYPE, OBJECT_ID, PROGRAM_ID, TIMESTAMP)
- `IFB10S1010_INSERT`: Named Parameter (COL_IF_GRP_ID, ORD_NO, ORD_LN, COL_QLT_DSN_STS='A', COL_QLT_DSN_MSG='A', 감사속성)

---

## 5. Route Transition

| 반환값 | 조건 | 비고 |
|--------|------|------|
| `SUCCESS` | 모든 주문 처리 완료, TX1/TX2 커밋 성공 | 정상 경로 |
| `FAILURE` | 서비스 ID 불일치 | 서비스 미해당 |
| `FAILURE` | IDS 없음 | 입력 데이터 없음 |
| `FAILURE` | 설계상태 확정대기 미충족 | 상태 검증 실패, ERRMSG 설정 |
| `FAILURE` | Exception 발생 | TX1/TX2 롤백, ERRMSG 설정 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 관리 업무에서 작업지시 변경 저장 처리 중 설계 확정을 수행하는 액티비티이다. 확정 대기 상태(`B`)인 주문에 대해 설계를 확정 처리하고, 그 결과를 EAI를 통해 외부 시스템(MM)으로 전송한다.

### 6.2 C10UiCheckActivity vs C10UiCheckActivity2 vs C10UiCheckActivity3 차이점

| 구분 | C10UiCheckActivity | C10UiCheckActivity2 | C10UiCheckActivity3 |
|------|-------------------|---------------------|---------------------|
| 검증 쿼리 | C104000050_CHECK (QLT_DSN_STS_CD='B') | C104000050_CHECK2 (QLT_DSN_STS_CD IN ('B','E')) | C104000050_CHECK3 (ORD_BAK_SND_TP='R') |
| 업데이트 쿼리 | C104000050_UPDATE | C104000050_UPDATE2 | C104000050_UPDATE3 |
| EAI 삽입 상태값 | COL_QLT_DSN_STS='A' (확정) | COL_QLT_DSN_STS='R' (반려) | COL_QLT_DSN_STS='C' (취소) |
| ORD_BAK_SND_CAU 처리 | 없음 | 있음 (반려 사유) | 있음 (취소 사유) |
| 작성자 | 박재영 (2011.12.09) | 김종범 (2012.06.26) | 김종범 (2012.06.26) |

### 6.3 트랜잭션 구조

TX1은 mesdao(MESAPUSER), TX2는 eaidao(EAIAPUSER) 트랜잭션으로 추정된다. 두 트랜잭션을 동시에 커밋/롤백하여 양쪽 DB의 일관성을 보장한다.
