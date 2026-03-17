# C10UiC106000080UpdateActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C10UiC106000080UpdateActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `C10DhtmlxActivity` |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 193 라인 |
| 메소드 수 | 5개 (`doMainActivity`, `doPostActivity`, `doPreActivity`, `getDefaultMsgCode`, `getDefaultMsgParam`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

품질설계 프린트롤 관리 화면(C106000080)에서 롤코드의 보유라인 변경 시 해당 롤코드의 사용정보(PTN_ROLL_USE_INF)를 업데이트하는 액티비티이다. 단일 레코드의 업데이트만 수행하는 단순한 구조이나, OLD_PROC_CD(이전 공정코드)와 PROC_CD(변경 공정코드)를 함께 처리하여 공정 변경 이력을 관리한다.

### 1.1 상속/구현 관계

`C10DhtmlxActivity`를 상속하여 `DhtmlxActivity` 생명주기를 따른다.

**DhtmlxActivity 생명주기**:
- `doPreActivity(PosContext arg0)`: null 반환 (미구현)
- `doMainActivity(PosContext ctx)`: 업데이트 로직 구현
- `doPostActivity(PosContext arg0)`: null 반환 (미구현)

### 1.2 핵심 입력/출력

**입력 (PosContext)**
- `IDS`: 처리 대상 ID 배열 (콤마 구분, 첫 번째 요소만 사용)
- `{idsValue[0]}_OLD_PROC_CD`: 이전 공정코드 배열
- `{idsValue[0]}_PROC_CD`: 변경 공정코드 배열
- `{idsValue[0]}_ROLL_CD`: 롤코드 배열
- `{idsValue[0]}_ROLL_USE_STR_DD`: 롤 사용 시작일자 배열
- `{idsValue[0]}_ROLL_USE_END_DD`: 롤 사용 종료일자 배열
- `OBJECT_TYPE`, `OBJECT_ID`, `PROGRAM_ID`, `TIMESTAMP`: 감사 속성 (param 키: ObjectType, ObjectId, ProgramId, Timestamp)

**출력**: 없음 (업데이트 결과만 DB에 반영)

**반환값**: `SUCCESS` 또는 PosException 발생

---

## 2. 메소드 상세 분석

### 2.1 `doMainActivity(PosContext ctx)`

**목적**: 롤코드 보유라인 변경 시 PTN_ROLL_USE_INF 테이블의 사용정보를 업데이트한다.

**복잡도**: 낮음 (단일 조건 + 단일 UPDATE)

**처리 흐름**:

1. `mesdao`(MESAPUSER) DAO 취득
2. `IDS` 배열에서 첫 번째 요소를 콤마로 분리하여 `idsValue` 취득
3. `idsValue[0]`을 기준으로 ctx에서 5개 필드 추출:
   - `OLD_PROC_CD`, `PROC_CD`, `ROLL_CD`, `ROLL_USE_STR_DD`, `ROLL_USE_END_DD`
4. 디버그 로그 출력 (각 필드 `[0]` 값)
5. PosParameter에 5개 필드 + 감사속성 설정 (Named Parameter)
6. `OLD_PROC_CD.equals("")` 조건 검사:
   - 조건 충족 시: `C106000080_PTN_ROLL_USE_INF.update` 실행 - **주의: 항상 실행됨 (아래 참조)**
7. `SUCCESS` 반환

**코드 로직 주의사항**:
`if(!OLD_PROC_CD.equals(""))` 조건에서 `OLD_PROC_CD`는 `String[]` 타입이다. `String[]` 객체는 `equals("")`가 항상 `false`이므로 `!false = true`가 되어 **조건에 관계없이 항상 update가 실행**된다. 이는 개발자가 `OLD_PROC_CD[0].equals("")`를 의도했으나 배열 객체 비교가 된 버그로 추정된다.

**예외 처리**:
- Exception 발생 시 `System.out.println(e.getMessage())` + `logger.logDebug(e.getMessage())` 로그 출력
- `PosException(e.getMessage() + "데이타 오류입니다.")` 재발생 (트랜잭션 롤백은 상위 프레임워크에서 처리)

### 2.2 `doPostActivity(PosContext arg0)`

null 반환 (미구현)

### 2.3 `doPreActivity(PosContext arg0)`

null 반환 (미구현)

### 2.4 `getDefaultMsgCode()`

null 반환 (기본 메시지 없음)

### 2.5 `getDefaultMsgParam(PosContext arg0)`

null 반환 (기본 메시지 파라미터 없음)

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-1 | DAO 고정 | 항상 | mesdao(MESAPUSER) 사용 |
| BR-2 | 첫 번째 행만 처리 | idsValue[0] 고정 참조 | 다건 처리 불가, 단건만 처리 |
| BR-3 | OLD_PROC_CD 조건 업데이트 | !OLD_PROC_CD.equals("") (실제로 항상 true) | C106000080_PTN_ROLL_USE_INF.update 실행 |
| BR-4 | 감사속성 키 명명 | C10ConstantsIF 상수 대신 직접 문자열 사용 | "ObjectType", "ObjectId", "ProgramId", "Timestamp" |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 | DAO |
|---------|------|-----------|-----|
| `C106000080_PTN_ROLL_USE_INF.update` | PTN_ROLL_USE_INF 롤 사용정보 업데이트 | doMainActivity 실행 시 (항상) | mesdao |

**파라미터 구성**:
- Named Parameter: OLD_PROC_CD, PROC_CD, ROLL_CD, ROLL_USE_STR_DD, ROLL_USE_END_DD
- 감사속성: ObjectType, ObjectId, ProgramId, Timestamp

---

## 5. Route Transition

| 반환값 | 조건 | 비고 |
|--------|------|------|
| `SUCCESS` | 업데이트 정상 완료 | 정상 경로 |
| PosException | Exception 발생 | 프레임워크에서 failure로 처리, 트랜잭션 롤백 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 프린트롤 관리(C106000080) 화면에서 특정 롤코드의 보유 라인(공정)이 변경될 때, 해당 롤의 사용정보 테이블을 업데이트하는 기능이다. 이전 공정코드(`OLD_PROC_CD`)와 새 공정코드(`PROC_CD`)를 함께 전달하여 SQL에서 이전 공정 대비 변경된 내용을 추적할 수 있도록 한다.

### 6.2 파일 헤더와 클래스명 불일치

헤더의 `@fileName`은 `C10UiC106000020InsertActivity.java`로 다른 파일의 헤더를 복사한 것이다. 실제 클래스명은 `C10UiC106000080UpdateActivity`이다.

### 6.3 감사속성 키 차이

다른 클래스들이 `C10ConstantsIF.OBJECT_TYPE`(="OBJECT_TYPE") 상수를 사용하는 반면, 이 클래스는 `"ObjectType"`, `"ObjectId"`, `"ProgramId"`, `"Timestamp"` 등 카멜케이스 직접 문자열을 사용한다. 서비스 XML 또는 SQL 쿼리의 파라미터명과 매핑되어야 하므로 SQL 쿼리 정의에서도 동일한 키명을 사용해야 한다.
