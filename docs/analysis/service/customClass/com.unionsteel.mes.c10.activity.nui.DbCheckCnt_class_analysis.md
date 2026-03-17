# DbCheckCnt 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbCheckCnt.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 105 라인 |
| 메소드 수 | 1개 (runActivity) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

특정 테이블(또는 뷰)에 데이터 존재 유무를 확인하는 범용 카운트 조회 Activity이다.
Service XML의 Property로 SQL Key, 파라미터 수, 파라미터 값을 동적으로 구성하여 `dao.find(sqlkey, param)` 조회 후 결과 건수에 따라 `true` 또는 `false` transition을 반환한다.
특정 비즈니스 로직 없이 범용으로 재사용 가능하도록 설계되어 있다.

### 1.1 상속/구현 관계

- `extends PosActivity` : GLUE 프레임워크 Activity 기반 클래스
- `implements C10NuiConstantsIF` : NUI 상수 인터페이스

### 1.2 핵심 입력/출력

**입력 (Service Property)**

| Property 명 | 의미 |
|-------------|------|
| sqlkey | 조회할 SQL Key |
| dao | 사용할 DAO bean ID |
| param-count | Where절 바인딩 파라미터 수 |
| param0, param1, ... | 각 파라미터의 PosContext Key 명 |

**입력 (PosContext에서 동적 추출)**

`param0` ~ `param(N-1)` Property 값에 해당하는 PosContext Key에서 값 추출. 예: Property `param0=ORD_NO`이면 `ctx.get("ORD_NO")` 값을 파라미터로 사용.

**출력 (transition 반환)**

| 반환값 | 의미 |
|--------|------|
| PosBizControlConstants.TRUE | 조회 결과 1건 이상 존재 |
| PosBizControlConstants.FALSE | 조회 결과 0건 |
| PosBizControlConstants.FAILURE | DB 조회 예외 발생 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 지정 SQL로 데이터 존재 유무 확인 후 true/false transition 반환 |
| 반환 타입 | String |
| 반환값 | TRUE / FALSE / FAILURE |
| 복잡도 | 낮음 |

**처리 흐름**

1. Property에서 `C10PN_SQLKEY` (sqlkey), `PARAM_COUNT` (param-count), DAO bean 획득
2. `param-count`가 null이 아니면 int로 파싱
3. `param-count` 수만큼 반복하여 `PosParameter`에 WhereClauseParameter 설정:
   - `param.setWhereClauseParameter(i, "" + ctx.get(this.getProperty("param" + i)))`
   - Property `param0`, `param1`... 값이 PosContext의 Key로 사용됨
4. `dao.find(sqlkey, param)` 조회
5. 예외 발생 시 rowset=null, 에러로그 출력, FAILURE 반환
6. `rowset.count() > 0`이면 TRUE 반환, 아니면 FALSE 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| R01 | 데이터 존재 | rowset.count() > 0 | TRUE 반환 |
| R02 | 데이터 미존재 | rowset.count() = 0 | FALSE 반환 |
| R03 | 조회 예외 | dao.find() 예외 발생 | FAILURE 반환, 에러로그 |
| R04 | 파라미터 없음 | param-count = null | PosParameter 비어있는 상태로 조회 |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| 동적 (Property sqlkey에 의해 결정) | 데이터 존재 유무 확인용 COUNT 쿼리 | runActivity 내 항상 실행 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

서비스 워크플로우에서 특정 조건의 데이터가 존재하는지 확인하여 후속 처리 분기를 결정하는 범용 Activity이다.
Service XML에서 SQL Key와 파라미터를 Property로 지정하면 별도 Java 클래스 없이 다양한 존재 유무 확인 로직을 처리할 수 있다.

예를 들어 `transition name="true"`에 기존 데이터 존재 시 처리 서비스를, `transition name="false"`에 신규 등록 처리 서비스를 연결하여 중복 체크 패턴으로 활용된다.

파라미터는 `param0`, `param1` ... 형태로 Property를 통해 PosContext Key를 간접 참조하므로, 동일한 클래스를 여러 서비스에서 재사용 가능한 구조이다.
