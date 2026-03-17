# C10UiC106000010InsertActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C10UiC106000010InsertActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `C10DhtmlxActivity` |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 222 라인 |
| 메소드 수 | 5개 (`doMainActivity`, `doPostActivity`, `doPreActivity`, `getDefaultMsgCode`, `getDefaultMsgParam`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

칼라코드 관리 화면(C106000010) 팝업에서 도료사 권한자 저장 시 영업정보에 등록된 휴대폰 번호로 SMS를 발송하는 액티비티이다. 최대 4개의 수신자 번호(`SMS_RCV_HP1` ~ `SMS_RCV_HP4`)에 대해 각각 11자리 유효성을 검증한 후 EAI 인터페이스 테이블에 SMS 전송 요청 레코드를 삽입한다.

### 1.1 상속/구현 관계

`C10DhtmlxActivity`를 상속하여 `DhtmlxActivity` 생명주기를 따른다.

**DhtmlxActivity 생명주기**:
- `doPreActivity(PosContext arg0)`: null 반환 (미구현)
- `doMainActivity(PosContext ctx)`: SMS 삽입 로직 구현
- `doPostActivity(PosContext arg0)`: null 반환 (미구현)

### 1.2 핵심 입력/출력

**입력 (PosContext)**
- `IDS`: 처리 대상 ID 배열 (첫 번째 요소만 사용)
- `{idsValue[0]}_CUS_CD_TXT`: 고객코드 텍스트
- `{idsValue[0]}_SMS_RCV_HP1` ~ `SMS_RCV_HP4`: SMS 수신 휴대폰 번호 1~4
- `{idsValue[0]}_CUS_REQ_HUE_TXT`: 고객 요청 색상 텍스트
- `{idsValue[0]}_RSN_TP_TXT`: 사유 유형 텍스트
- `{idsValue[0]}_SMPL_DLV_CMP_CD`: 샘플 납품 회사코드
- `{idsValue[0]}_IVC_NO`: 인보이스 번호
- `OBJECT_TYPE`, `OBJECT_ID`, `PROGRAM_ID`, `TIMESTAMP`: 감사 속성 (키: ObjectType, ObjectId, ProgramId, Timestamp)

**출력**: 없음 (EAI SMS 큐 테이블에 레코드 삽입)

**반환값**: `SUCCESS` 또는 PosException 발생

---

## 2. 메소드 상세 분석

### 2.1 `doMainActivity(PosContext ctx)`

**목적**: 칼라코드 도료사 권한자 저장 시 등록된 최대 4개의 휴대폰 번호로 SMS 발송 요청 레코드를 삽입한다.

**복잡도**: 낮음 (다중 조건 독립 처리)

**처리 흐름**:

1. `eaidao`(EAIAPUSER) DAO 취득
2. `IDS` 배열에서 `idsValue[0]`을 기준으로 9개 필드 추출:
   - CUS_CD_TXT, SMS_RCV_HP1~4, CUS_REQ_HUE_TXT, RSN_TP_TXT, SMPL_DLV_CMP_CD, IVC_NO
3. 디버그 로그 출력 (각 필드 `[0]` 값)
4. PosParameter에 9개 필드 + 감사속성 설정 (Named Parameter, String[] 배열 그대로 설정)
5. 4개의 독립적인 SMS 수신자 처리:
   - `SMS_RCV_HP1[0] != null && SMS_RCV_HP1[0].length() == 11` → `C106000010pop01.sms_insert1` 실행
   - `SMS_RCV_HP2[0] != null && SMS_RCV_HP2[0].length() == 11` → `C106000010pop01.sms_insert2` 실행
   - `SMS_RCV_HP3[0] != null && SMS_RCV_HP3[0].length() == 11` → `C106000010pop01.sms_insert3` 실행
   - `SMS_RCV_HP4[0] != null && SMS_RCV_HP4[0].length() == 11` → `C106000010pop01.sms_insert4` 실행
6. `SUCCESS` 반환

**핵심 조건 로직**:
- SMS 수신자 번호 유효성: `null이 아님 AND 길이가 정확히 11자리` (한국 휴대폰 번호 표준)
- 4개의 조건이 독립적으로 평가되므로 최소 0건 ~ 최대 4건의 INSERT 실행 가능
- 하나라도 실패해도 나머지 처리 계속 (각 조건은 독립적)

**예외 처리**:
- Exception 발생 시 `System.out.println(e.getMessage())` + `logger.logDebug(e.getMessage())` 로그 출력
- `PosException(e.getMessage() + "데이타 오류입니다.")` 재발생

### 2.2 `doPostActivity`, `doPreActivity`

null 반환 (미구현)

### 2.3 `getDefaultMsgCode`, `getDefaultMsgParam`

null 반환 (기본 메시지 없음)

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-1 | DAO 고정 | 항상 | eaidao(EAIAPUSER) 사용 (EAI SMS 큐) |
| BR-2 | 첫 번째 행만 처리 | idsValue[0] 고정 참조 | 단건 처리 |
| BR-3 | SMS 수신자 1 유효성 | SMS_RCV_HP1[0] != null AND length == 11 | C106000010pop01.sms_insert1 실행 |
| BR-4 | SMS 수신자 2 유효성 | SMS_RCV_HP2[0] != null AND length == 11 | C106000010pop01.sms_insert2 실행 |
| BR-5 | SMS 수신자 3 유효성 | SMS_RCV_HP3[0] != null AND length == 11 | C106000010pop01.sms_insert3 실행 |
| BR-6 | SMS 수신자 4 유효성 | SMS_RCV_HP4[0] != null AND length == 11 | C106000010pop01.sms_insert4 실행 |
| BR-7 | 독립 처리 | 각 수신자 조건 독립 평가 | 0~4건 INSERT 가능 |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 | DAO |
|---------|------|-----------|-----|
| `C106000010pop01.sms_insert1` | SMS 수신자 1에게 SMS 전송 요청 삽입 | SMS_RCV_HP1 유효 시 | eaidao |
| `C106000010pop01.sms_insert2` | SMS 수신자 2에게 SMS 전송 요청 삽입 | SMS_RCV_HP2 유효 시 | eaidao |
| `C106000010pop01.sms_insert3` | SMS 수신자 3에게 SMS 전송 요청 삽입 | SMS_RCV_HP3 유효 시 | eaidao |
| `C106000010pop01.sms_insert4` | SMS 수신자 4에게 SMS 전송 요청 삽입 | SMS_RCV_HP4 유효 시 | eaidao |

**파라미터 구성** (공통, 4개 SQL 모두 동일):
- Named Parameter: CUS_CD_TXT, SMS_RCV_HP1, SMS_RCV_HP2, SMS_RCV_HP3, SMS_RCV_HP4, CUS_REQ_HUE_TXT, RSN_TP_TXT, SMPL_DLV_CMP_CD, IVC_NO
- 감사속성: ObjectType, ObjectId, ProgramId, Timestamp

---

## 5. Route Transition

| 반환값 | 조건 | 비고 |
|--------|------|------|
| `SUCCESS` | SMS 삽입 완료 (0~4건) | 유효 번호 없어도 SUCCESS |
| PosException | Exception 발생 | 프레임워크에서 failure로 처리 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

칼라코드 관리 화면에서 도료사 권한자를 저장할 때, 관련 담당자(최대 4명)에게 SMS로 알림을 발송하는 기능이다. SMS 발송은 EAI를 통해 외부 SMS 시스템으로 전달되며, eaidao를 통해 EAI 인터페이스 테이블에 레코드를 삽입하는 방식으로 처리된다.

### 6.2 SMS 수신자 유효성 검증

한국 휴대폰 번호 표준(11자리, 예: 01012345678)을 기준으로 검증한다. `length() == 11` 조건을 통해 하이픈 없는 숫자만 허용한다. 번호가 null이거나 11자리가 아닌 경우 해당 수신자에 대한 SMS 삽입은 건너뛴다.

### 6.3 파일 헤더 불일치

헤더의 `@fileName`은 `C10UiC106000020InsertActivity.java`, `설명`은 `품질설계 시물레이션 저장`으로 다른 파일에서 복사한 내용이 수정되지 않았다. 실제 클래스명은 `C10UiC106000010InsertActivity`이며 업무 목적은 SMS 발송이다.

### 6.4 파라미터 설정 방식의 차이

`param.setNamedParamter("CUS_CD_TXT", CUS_CD_TXT)` - String[] 배열을 그대로 파라미터로 설정한다. SMS 수신자 번호 유효성은 `SMS_RCV_HP1[0].length() == 11`로 직접 검증하면서도 파라미터는 배열 전체를 넘기는 구조이다. SQL에서 Named Parameter 처리 시 프레임워크가 배열의 첫 번째 요소를 사용하는 것으로 추정된다.
