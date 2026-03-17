# C107000050pop01ProcActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C107000050pop01ProcActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 351 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

C107000050 화면의 pop01 팝업에서 데이터 이행(마이그레이션) 처리를 위해 직접 JDBC Connection을 생성하여 `M00APUSER.TB_M00_ATTRS` 테이블에 MERGE INTO 구문을 실행하는 Activity이다. GLUE 프레임워크의 DAO를 사용하지 않고 `oracle.jdbc.OraclePreparedStatement`를 직접 사용하며, `chk` 프로퍼티 값에 따라 테스트계(`tstdao`) 또는 운영계(`prddao`) 데이터베이스에 접속한다.

### 1.1 상속/구현 관계

- `PosActivity` 직접 상속 (DhtmlxActivity 생명주기 미사용)
- `PosActivity`의 `runActivity(PosContext ctx)` 단일 메소드 구현
- `C10NuiConstantsIF` 구현 (C10STR_SPACE 등 공통 상수 참조)
- 클래스 내 `private static final` 상수로 DB 접속 정보(URL, ID, Password)를 하드코딩

### 1.2 핵심 입력/출력

| 구분 | 키 | 설명 |
|------|----|------|
| 프로퍼티 | `chk` | 대상 DB 구분: `tstdao`(테스트계), `prddao`(운영계) |
| 입력 (ctx) | `IDS` | 화면 그리드 행 ID 배열 (쉼표 구분) |
| 입력 (ctx) | `{rowId}_CH` | 체크 여부 (체크된 행만 처리: CH=="1") |
| 입력 (ctx) | `{rowId}_DT_NM_ID` | 데이터명칭 ID |
| 입력 (ctx) | `{rowId}_STANDARD_ENGLISH_ID` | 표준 영문 ID |
| 입력 (ctx) | `{rowId}_STANDARD_KOREAN_NAME` | 표준 한글 명 |
| 입력 (ctx) | `{rowId}_SYS_TP` | 시스템 유형 |
| 입력 (ctx) | `{rowId}_CHAIN_CODE` | 체인 코드 |
| 입력 (ctx) | `{rowId}_DT_NM_DATA_TP` | 데이터 타입 |
| 입력 (ctx) | `{rowId}_DT_NM_LEN` | 데이터 길이 |
| 입력 (ctx) | `{rowId}_DT_NM_DECIMAL_PREC` | 소수점 정밀도 |
| 입력 (ctx) | `{rowId}_DT_NM_ALIAS` | 별칭 |
| 입력 (ctx) | `{rowId}_USE_TP` | 사용 유형 |
| 입력 (ctx) | `{rowId}_!nativeeditor_status` | 그리드 DML 상태 |
| 출력 (ctx) | `TST` | "테스트계 이행이 완료되었습니다." (성공 시, chk=tstdao) |
| 출력 (ctx) | `PRD` | "운영계 이행이 완료되었습니다." (성공 시, chk=prddao) |
| 출력 (ctx) | `TST` / `PRD` | "이행이 실패했습니다." (실패 시) |
| 출력 (ctx) | `ERRMSG` | 예외 메시지 |
| 반환값 | `SUCCESS` | 정상 완료 |
| 반환값 | `FAILURE` | IDS 없을 때 |
| 예외 | `PosException` | 예외 발생 시 throw |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

**목적**: 화면에서 체크된 행의 데이터를 M00APUSER.TB_M00_ATTRS에 MERGE INTO 처리 (테스트계 또는 운영계 직접 JDBC 접속)

**복잡도**: 중간 (JDBC 직접 사용, 하드코딩 접속정보, 단순 루프)

**처리 흐름:**

```
1. chk 프로퍼티 취득 (tstdao / prddao 구분)
2. Class.forName(oracle.jdbc.driver.OracleDriver) 로딩
   - 실패 시 ClassNotFoundException catch 후 printStackTrace (예외 무시하고 계속 진행)
3. chk 값에 따라 DriverManager.getConnection() 직접 호출:
   - tstdao: 210.1.1.139:2020:UBMADQ (M00APUSER/M00APUSER_TST)
   - prddao: 210.1.1.146:2010:USMEAP1 (M00APUSER/M00APUSER_PRD)
4. conn.setAutoCommit(false)
5. StringBuffer로 MERGE INTO M00APUSER.TB_M00_ATTRS SQL 구성 (Named Parameter 방식)
6. conn.prepareStatement() -> OraclePreparedStatement로 캐스팅
7. IDS 유효성 검증 (null 또는 빈 배열이면 FAILURE 반환)
8. ids[0] 쉼표 분리하여 idsValue 구성
9. 루프 (idsValue 전체 순회):
   - 각 컬럼 String[] 추출 (DT_NM_ID, STANDARD_ENGLISH_ID 등 11개 컬럼)
   - 유효성 검증: DT_NM_ID, STANDARD_ENGLISH_ID, STANDARD_KOREAN_NAME, SYS_TP 길이 > 0
   - 값 변수에 [0] 인덱스 할당
   - OraclePreparedStatement.setStringAtName() / setTimestampAtName() 으로 파라미터 바인딩
   - CH == "1" 인 경우만 pstmt.executeUpdate() 실행
10. conn.commit()
11. chk에 따라 TST 또는 PRD 키로 완료 메시지 ctx에 저장
12. SUCCESS 반환
예외 발생 시:
   - conn.rollback() (conn null 체크 포함)
   - TST/PRD 키로 실패 메시지 저장
   - ERRMSG 저장
   - PosException throw
finally:
   - pstmt.close()
   - conn.close()
```

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 대상 DB 선택 | `chk == "tstdao"` | 테스트계 DB 접속 (210.1.1.139:2020:UBMADQ) |
| 2 | 대상 DB 선택 | `chk == "prddao"` | 운영계 DB 접속 (210.1.1.146:2010:USMEAP1) |
| 3 | IDS 필수 검증 | `ids == null` 또는 `ids.length < 1` | FAILURE 반환 |
| 4 | 필수 컬럼 유효성 | `DT_NM_ID.length > 0 AND STANDARD_ENGLISH_ID.length > 0 AND STANDARD_KOREAN_NAME.length > 0 AND SYS_TP.length > 0` | 해당 행 처리 |
| 5 | 체크 행만 실행 | `CH == "1"` | executeUpdate() 실행 (MERGE INTO) |
| 6 | 체크 미선택 행 | `CH != "1"` | executeUpdate() 건너뜀 (파라미터 바인딩은 수행) |
| 7 | 완료 메시지 | 커밋 성공 후 `chk == "tstdao"` | ctx.put("TST", "테스트계 이행이 완료되었습니다.") |
| 8 | 완료 메시지 | 커밋 성공 후 `chk == "prddao"` | ctx.put("PRD", "운영계 이행이 완료되었습니다.") |
| 9 | 실패 메시지 | 예외 발생 `chk == "tstdao"` | ctx.put("TST", "테스트계 이행이 실패했습니다.") |
| 10 | 실패 메시지 | 예외 발생 `chk == "prddao"` | ctx.put("PRD", "운영계 이행이 실패했습니다.") |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| 인라인 MERGE INTO M00APUSER.TB_M00_ATTRS | DT_NM_ID 기준 존재 시 UPDATE, 없으면 INSERT | 루프 내 CH=="1" 인 행마다 |

**MERGE INTO 구조:**

- ON 조건: `DT_NM_ID = :DT_NM_ID`
- MATCHED (UPDATE): `STANDARD_ENGLISH_ID, STANDARD_KOREAN_NAME, DT_NM_DATA_TP, DT_NM_LEN, DT_NM_DECIMAL_PREC, USE_TP, SYS_TP, CHAIN_CODE, LAST_UPDATED_*`
- NOT MATCHED (INSERT): 위 컬럼 + `CREATED_*`, `CREATION_TIMESTAMP` (CREATE/LAST 모두 동일 값 삽입)

> 참고: SQL은 GLUE 쿼리 파일이 아닌 클래스 내 StringBuffer로 직접 구성되어 있다.

---

## 5. Route Transition

| 반환값 | 조건 | 설명 |
|--------|------|------|
| `FAILURE` | `ids == null` 또는 `ids.length < 1` | 입력 데이터 없음 |
| `SUCCESS` | 모든 처리 및 conn.commit() 완료 | 정상 종료 |
| `PosException` throw | `Exception` 발생 시 | 예외를 catch 후 PosException으로 재throw (SUCCESS/FAILURE 반환 아님) |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

C107000050 화면 팝업에서 화면에 조회된 데이터명칭(TB_M00_ATTRS) 데이터를 테스트계 또는 운영계 M00APUSER 스키마로 직접 이행(마이그레이션)하는 일회성 운영 도구 Activity이다. GLUE 프레임워크의 DAO를 우회하여 직접 JDBC 연결을 생성함으로써 현재 애플리케이션 서버와 다른 DB 인스턴스에 접근할 수 있도록 설계되었다.

### 6.2 핵심 비즈니스 로직

**직접 JDBC 사용 이유:**

GLUE 프레임워크의 `mesdao`/`masterdao`는 애플리케이션 서버의 DataSource로 설정된 DB에만 접근할 수 있다. 이 Activity는 테스트계/운영계 두 인스턴스에 선택적으로 접속해야 하므로, `DriverManager.getConnection()`으로 별도 접속을 생성한다.

**DB 접속 정보 (하드코딩):**

| 환경 | URL | Schema |
|------|-----|--------|
| 테스트계 | `jdbc:oracle:thin:@210.1.1.139:2020:UBMADQ` | M00APUSER / M00APUSER_TST |
| 운영계 | `jdbc:oracle:thin:@210.1.1.146:2010:USMEAP1` | M00APUSER / M00APUSER_PRD |

**MERGE INTO 파라미터 바인딩:**

`OraclePreparedStatement.setStringAtName()`을 사용하여 Named Parameter (`:paramName`) 방식으로 바인딩한다. INSERT 절의 CREATED_* 컬럼과 LAST_UPDATED_* 컬럼 모두 동일한 파라미터(ObjectType, ObjectId, ProgramId, Timestamp)로 채워진다.

**주석 처리된 파일 읽기 코드:**

소스 내 주석 블록에 SQL 파일을 파일시스템에서 직접 읽어 실행하는 코드(`FileReader`/`BufferedReader`)가 존재하나 현재 비활성화 상태이다.

**ClassNotFoundException 처리:**

드라이버 로딩 실패 시 `printStackTrace()`만 하고 예외를 무시한 채 계속 진행하므로, 드라이버 미존재 시 다음 단계인 `DriverManager.getConnection()` 호출에서 예외가 발생한다.
