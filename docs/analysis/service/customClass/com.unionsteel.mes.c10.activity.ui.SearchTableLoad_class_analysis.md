# SearchTableLoad 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/SearchTableLoad.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `C10DhtmlxActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 77 라인 |
| 메소드 수 | 4개 (`doMainActivity`, `getDefaultMsgCode`, `getDefaultMsgParam`, `get`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

EAI 인터페이스 테이블에 대한 동적 SQL 조회를 수행하는 범용 조회 액티비티이다. SQL 쿼리 정의에서 플레이스홀더를 런타임에 ctx 값으로 치환하는 동적 쿼리 패턴을 사용하며, 서비스 XML의 property 설정을 통해 다양한 조회에 재사용 가능한 유연한 구조를 가진다. 일반적인 Named Parameter 방식이 아닌 SQL 문자열 직접 치환 방식을 사용하는 특수 클래스이다.

### 1.1 상속/구현 관계

`C10DhtmlxActivity`를 상속하여 `DhtmlxActivity` 생명주기(`doPreActivity`, `doMainActivity`, `doPostActivity`)를 따른다. `C10NuiConstantsIF` 인터페이스를 구현하여 NUI 관련 상수를 직접 사용한다.

**DhtmlxActivity 생명주기**:
- `doPreActivity()`: 미구현 (C10DhtmlxActivity 기본 동작)
- `doMainActivity()`: 핵심 조회 로직 구현
- `doPostActivity()`: 미구현 (C10DhtmlxActivity 기본 동작)

### 1.2 핵심 입력/출력

**Property (서비스 XML 설정)**
- `C10PN_SQLKEY` (sqlkey): 실행할 SQL 쿼리의 key
- `KEY_COUNT` (key.count): SQL 치환 키 개수
- `C10STR_KEY + i` (key1, key2, ...): `|`(파이프)로 구분된 `플레이스홀더|ctx키` 쌍

**입력 (PosContext)**
- 서비스 XML에 정의된 key1~keyN의 ctx키 값들 (동적)
- SQL Binding 변수들 (Named Parameter)

**출력 (PosContext)**
- `PN_RESULTKEY` (기본값: `PV_XML_RESULT`): 조회 결과 PosRowSet

**반환값**: `SUCCESS` (항상)

---

## 2. 메소드 상세 분석

### 2.1 `doMainActivity(PosContext ctx)`

**목적**: 서비스 XML에 정의된 SQL을 동적으로 치환하고 실행하여 결과를 PosContext에 저장한다.

**복잡도**: 중간 (동적 SQL 치환 + 동적 파라미터 바인딩)

**처리 흐름**:

1. `eaidao` DAO 취득 (`C10STR_EAIDAO` 상수 사용)
2. Property에서 `sqlKey` 취득
3. `dao.getQueryManager().getQueryDefinition(sqlKey).getQueryStatement(true)`로 SQL 문자열 취득
4. `PosParameter` 생성
5. `getBindingNames(ctx, dao, sqlKey)` 호출로 SQL의 Named Parameter 목록 추출
6. `KEY_COUNT` property로 치환 키 개수(`size`) 취득
7. `key1` ~ `keyN` property를 순회하며 SQL 직접 치환:
   - `key[0]` = SQL의 플레이스홀더 문자열
   - `key[1]` = ctx에서 값을 조회할 키
   - `query = query.replace(key[0], (String) get(ctx, key[1]))` 실행
8. Named Parameter 목록을 순회하며 param에 바인딩:
   - `param.setNamedParamter(paramName, get(ctx, paramName))`
9. `dao.findByQueryStatement(query, param, true)` 실행 (치환된 SQL로 조회)
10. 결과 `rowset`을 `ctx.put(PN_RESULTKEY, rowset)` 저장
11. `makeMessage(ctx, rowset)` 호출로 화면 메시지 생성
12. `SUCCESS` 반환

### 2.2 `getDefaultMsgCode()`

**목적**: 기본 메시지 코드 반환

**반환값**: `MSG_MS001024` (상수)

### 2.3 `getDefaultMsgParam(PosContext ctx)`

**목적**: 메시지 파라미터 배열 반환 (조회 건수 포함)

**처리 흐름**:
1. ctx에서 `PN_RESULTKEY` 키로 `PosRowSet` 취득
2. `rowSet.count()`를 `String.valueOf()`로 변환
3. 문자열 배열 크기 1로 생성하여 건수 저장 후 반환

**반환값**: `String[] { "건수" }` 형태

### 2.4 `get(PosContext ctx, Object key)`

**목적**: PosContext에서 값 조회 시 String[] 타입인 경우 첫 번째 요소를 반환하는 유틸 메소드

**처리 흐름**:
1. `ctx.get(key)`로 값 조회
2. 값이 null이 아니고 `String[]` 인스턴스이면 `[0]` 요소 반환
3. 그 외 경우 원본 객체 반환

**비즈니스 의미**: GLUE 프레임워크에서 화면 입력값은 String[]로 전달되므로 단일 값 추출을 위한 공통 처리

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-1 | DAO 고정 | 항상 | eaidao(EAIAPUSER) 사용 |
| BR-2 | SQL 직접 치환 | KEY_COUNT > 0 | query.replace(플레이스홀더, ctx값) 반복 실행 |
| BR-3 | String[] 자동 변환 | ctx 값이 String[] 타입 | 첫 번째 요소([0])만 사용 |
| BR-4 | 결과 항상 성공 | 예외 없을 시 | 항상 SUCCESS 반환 |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| `getProperty(C10PN_SQLKEY)` (동적) | 서비스 XML에 정의된 쿼리 | doMainActivity 실행 시 |

**동적 SQL 치환 패턴**:
```
property: key1=#{PLACEHOLDER}|CTX_KEY_NAME
처리:     query.replace("#{PLACEHOLDER}", ctx.get("CTX_KEY_NAME"))
```

조회 방식: `dao.findByQueryStatement(query, param, true)` - 치환 완료된 SQL 문자열로 직접 실행

---

## 5. Route Transition

| 반환값 | 조건 | 비고 |
|--------|------|------|
| `SUCCESS` | 항상 (예외 발생 없을 시) | C10DhtmlxActivity에서 예외 처리 담당 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

EAI 인터페이스 현황 조회 등 인터페이스 모니터링 화면에서 사용하는 범용 조회 액티비티이다. 클래스를 수정하지 않고 서비스 XML의 property 설정만으로 다양한 SQL 조회를 수행할 수 있어 재사용성이 높다.

### 6.2 동적 SQL 치환 메커니즘

일반적인 Named Parameter(`:paramName`)와 달리, SQL 정의에 있는 임의의 문자열을 런타임에 ctx 값으로 치환한다. 이 방식은 SQL의 FROM 절, 테이블명, 컬럼명 등 Named Parameter로 처리할 수 없는 부분을 동적으로 변경할 때 사용된다. EAI 인터페이스 조회 시 인터페이스 테이블명이나 조건절이 동적으로 결정되는 경우 이 패턴이 적용된다.

### 6.3 C10NuiConstantsIF 활용

NUI(Network UI) 상수 인터페이스를 구현하여 `C10STR_EAIDAO`, `C10PN_SQLKEY`, `KEY_COUNT`, `C10STR_KEY`, `C10STR_REGULAR_EXP_PIPE`, `MSG_MS001024` 등의 상수를 직접 참조한다.
