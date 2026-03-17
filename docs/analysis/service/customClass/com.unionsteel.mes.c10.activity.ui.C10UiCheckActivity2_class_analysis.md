# C10UiCheckActivity2 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C10UiCheckActivity2.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 207 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

작업지시변경저장(C104000050) 서비스에서 설계확정 대상 주문의 설계상태가 확정대기 또는 반려(`QLT_DSN_STS_CD IN ('B','E')`) 상태인지 검증하고, 검증 통과 시 설계상태를 업데이트한 후 반려 처리(`COL_QLT_DSN_STS = 'R'`) 레코드를 EAI 인터페이스 테이블에 삽입하는 액티비티이다. 세 개의 유사 클래스 중 두 번째로, 반려 재검토 단계를 처리한다. 반려 사유(`ORD_BAK_SND_CAU`)를 함께 처리한다는 점이 C10UiCheckActivity와의 핵심 차이이다.

### 1.1 상속/구현 관계

`PosActivity`를 상속하며 `runActivity(PosContext ctx)` 단일 메소드를 구현한다. 파일 헤더에는 `C10UiCheckActivity.java`라고 기재되어 있으나 실제 클래스명은 `C10UiCheckActivity2`이다(복사 후 수정 과정의 미반영).

### 1.2 핵심 입력/출력

**입력 (PosContext)**
- `SERVICE_NAME`: 서비스 식별자 (`C104000050_SERVICE`)
- `IDS`: 처리 대상 ID 배열 (콤마 구분)
- `{idsValue}_ORD_NO`: 주문번호 배열
- `{idsValue}_ORD_LN`: 주문행번 배열
- `{idsValue}_ORD_BAK_SND_CAU`: 반려 사유 배열 (C10UiCheckActivity와의 차이)
- `OBJECT_TYPE`, `OBJECT_ID`, `PROGRAM_ID`, `TIMESTAMP`: 감사 속성
- `COL_IF_GRP_ID`: EAI 인터페이스 그룹 ID

**출력 (PosContext)**
- `ERRMSG`: 오류 메시지 (실패 시)

**반환값**: `SUCCESS` 또는 `FAILURE`

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 작업지시변경저장 서비스에서 주문별 반려 처리 상태 검증 및 EAI 반려 전송을 일괄 처리한다.

**복잡도**: 중간 (다중 루프 + 다중 DB 작업 + 반려 사유 처리)

**처리 흐름**:

1. `mesdao`(MESAPUSER), `eaidao`(EAIAPUSER) DAO 취득
2. `ctx.get(SERVICE_NAME)`으로 서비스 ID 확인
3. 서비스 ID가 `C104000050_SERVICE`가 아니면 즉시 `FAILURE` 반환
4. `IDS` 배열 null/빈값 체크 → 없으면 `FAILURE` 반환
5. `ids[0]`를 콤마로 분리하여 `idsValue` 배열 생성
6. `idsValue` 배열을 순회하면서 각 항목 처리:
   a. ctx에서 `{idsValue[i]}_ORD_NO`, `{idsValue[i]}_ORD_LN`, `{idsValue[i]}_ORD_BAK_SND_CAU` 추출
   b. `sORD_BAK_SND_CAU = ORD_BAK_SND_CAU[0]` 추출 (C10UiCheckActivity에는 없음)
   c. `ORD_NO.length > 0 && ORD_LN.length > 0` 조건 검증
   d. `C104000050_CHECK2` 쿼리 실행 (QLT_DSN_STS_CD IN ('B','E') 조건 검증)
   e. 결과 0건이면 `C104000050_CHECK_ERR2` 메시지를 `ERRMSG`에 저장 후 `FAILURE` 반환
   f. `C104000050_UPDATE2` 쿼리로 설계상태 업데이트 (ORD_BAK_SND_CAU 포함)
   g. `IFB10S1010_INSERT` 쿼리로 EAI 테이블에 반려 레코드 삽입 (COL_QLT_DSN_STS='R', COL_QLT_DSN_MSG=sORD_BAK_SND_CAU)
7. TX1, TX2 커밋
8. `SUCCESS` 반환

**예외 처리**: Exception 발생 시 TX1, TX2 롤백 후 `ERRMSG` 저장, `FAILURE` 반환

**C10UiCheckActivity2만의 특징**:
- `ORD_BAK_SND_CAU` (반려 송신 사유) 필드 처리
- `sORD_BAK_SND_CAU` 추출 위치: `ORD_BAK_SND_CAU[0]`를 먼저 추출 후 ORD_NO/ORD_LN 추출 (C10UiCheckActivity3과 순서 다름 - 실제로는 동일 동작)
- 검증 쿼리: `C104000050_CHECK2` (QLT_DSN_STS_CD IN ('B','E'))
- EAI 삽입 시 `COL_QLT_DSN_STS = 'R'` (반려), `COL_QLT_DSN_MSG = sORD_BAK_SND_CAU` (반려 사유 동적값)

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-1 | 서비스 ID 검증 | SERVICE_NAME != C104000050_SERVICE | FAILURE 반환 |
| BR-2 | IDS 존재 검증 | IDS == null OR IDS.length < 1 | FAILURE 반환 |
| BR-3 | 데이터 유효성 검증 | ORD_NO.length == 0 OR ORD_LN.length == 0 | 해당 건 건너뜀 |
| BR-4 | 설계상태 반려 가능 검증 | C104000050_CHECK2 결과 0건 (QLT_DSN_STS_CD NOT IN ('B','E')) | C104000050_CHECK_ERR2 메시지, FAILURE |
| BR-5 | 반려 사유 포함 업데이트 | 검증 통과 시 | mesdao.update(C104000050_UPDATE2) - ORD_BAK_SND_CAU 포함 |
| BR-6 | EAI 반려 상태 전송 | 업데이트 후 | COL_QLT_DSN_STS='R', COL_QLT_DSN_MSG=반려사유(동적) |
| BR-7 | 트랜잭션 커밋 | 전체 루프 완료 후 | TX1, TX2 커밋 |

---

## 4. SQL 매핑

| SQL Key 상수 | 용도 | 호출 시점 | DAO |
|--------------|------|-----------|-----|
| `C104000050_CHECK2` | 설계상태 반려 가능 여부 조회 (QLT_DSN_STS_CD IN ('B','E')) | 각 주문 처리 전 검증 | mesdao |
| `C104000050_UPDATE2` | 설계상태 업데이트 (반려 사유 포함) | 검증 통과 후 | mesdao |
| `IFB10S1010_INSERT` | EAI 인터페이스 테이블 반려 레코드 삽입 | 업데이트 후 | eaidao |

**쿼리 파라미터 패턴**:
- `C104000050_CHECK2`: `setWhereClauseParameter(0, ORD_NO)`, `setWhereClauseParameter(1, ORD_LN)` (위치 기반)
- `C104000050_UPDATE2`: Named Parameter (ORD_NO, ORD_LN, ORD_BAK_SND_CAU, OBJECT_TYPE, OBJECT_ID, PROGRAM_ID, TIMESTAMP)
- `IFB10S1010_INSERT`: Named Parameter (COL_IF_GRP_ID, ORD_NO, ORD_LN, COL_QLT_DSN_STS='R', COL_QLT_DSN_MSG=반려사유, 감사속성)

---

## 5. Route Transition

| 반환값 | 조건 | 비고 |
|--------|------|------|
| `SUCCESS` | 모든 주문 처리 완료, TX1/TX2 커밋 성공 | 정상 경로 |
| `FAILURE` | 서비스 ID 불일치 | 서비스 미해당 |
| `FAILURE` | IDS 없음 | 입력 데이터 없음 |
| `FAILURE` | 설계상태 반려 가능 미충족 | C104000050_CHECK_ERR2 메시지 설정 |
| `FAILURE` | Exception 발생 | TX1/TX2 롤백, ERRMSG 설정 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 관리 업무에서 작업지시 변경 저장 처리 중 설계 반려를 수행하는 액티비티이다. 확정 대기(`B`) 또는 기 반려(`E`) 상태인 주문에 대해 반려 처리를 하고, 반려 사유와 함께 EAI를 통해 외부 시스템으로 전송한다.

### 6.2 C10UiCheckActivity와의 핵심 차이

C10UiCheckActivity(설계 확정)는 `QLT_DSN_STS_CD = 'B'`인 주문만 처리하며 반려 사유 없이 고정 상태값 `'A'`를 EAI에 전송한다. 반면 C10UiCheckActivity2(설계 반려)는 `QLT_DSN_STS_CD IN ('B','E')`인 주문을 처리하며 사용자가 입력한 반려 사유(`ORD_BAK_SND_CAU`)를 함께 EAI에 전송한다.

### 6.3 코드 품질 관찰

파일 헤더 주석(`@FileName : C10UiCheckActivity.java`, `@author : 김종범`)이 C10UiCheckActivity3와 동일하여 복사 생성 시 헤더가 동일하게 유지된 것으로 보인다. `ORD_BAK_SND_CAU` 추출 순서가 C10UiCheckActivity3과 미묘하게 다르나 결과는 동일하다.
