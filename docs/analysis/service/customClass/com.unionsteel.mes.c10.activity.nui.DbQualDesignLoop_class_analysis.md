# DbQualDesignLoop 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbQualDesignLoop.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `com.posdata.glue.biz.activity.PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `171` 라인 |
| 메소드 수 | `1`개 (`runActivity`) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

`DbQualDesignLoop`는 GLUE Framework 기반 NUI(배치) 서비스에서 **이전 액티비티가 조회한 ResultSet을 1건씩 순회 처리하기 위한 루프 제어 액티비티**이다.

이전 서비스(주로 `PosSearch`)에서 쿼리 결과로 얻은 `PosRowSet`을 순차적으로 읽으며, 한 건씩 `PosContext`에 세팅한 뒤 후속 액티비티 체인(품질 설계 검증, 실적 처리 등)이 단건 기준으로 동작할 수 있도록 연결한다. 처리 건수가 0이 되면 `"exit"` 전이를 반환하여 루프를 종료한다.

사용 빈도가 매우 높아 DataCheck, C103100020, B10R0040, B10S0010~B10S0050, C102100020~C102100160 등 40개 이상의 서비스 XML에서 참조된다.

### 1.1 상속/구현 관계

```
PosActivity (GLUE SDK 추상 클래스)
    └── DbQualDesignLoop
            implements C10NuiConstantsIF
```

- `PosActivity`: GLUE Framework 추상 액티비티. `runActivity(PosContext ctx)` 추상 메소드를 정의하며, `getProperty()`, `logger` 등을 제공한다.
- `C10NuiConstantsIF`: C10 모듈 공통 상수 인터페이스. 컨텍스트 키명, 파라미터명, 전이 명칭 등 상수를 제공한다.

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 (Property) | `countName` | 처리 건수 카운터 변수명 (예: `QLT_DSN_STS_CD_COUNT`) |
| 입력 (Property) | `bind-result` | 이전 서비스의 ResultSet Key (예: `RK_SEARCH`) |
| 입력 (Property) | `param-count` | 컨텍스트에 바인딩할 컬럼 수 |
| 입력 (Property) | `param0`, `param1`, ... | `저장변수명|대상항목명` 형식 바인딩 목록 |
| 입력 (Context) | `countName` 변수값 | 현재 남은 처리 건수 (최초 null → 전체 건수로 초기화) |
| 출력 (Context) | `P_ERR_KEY` | 오류 발생 여부 플래그 (`"N"` 으로 초기화) |
| 출력 (Context) | `BATCH_JOB` | 배치 잡 실행 구분 플래그 (`"true"` 고정) |
| 출력 (Context) | `QLT_DSN_ERR_YN` | 품질설계 에러 여부 (`""` 으로 초기화) |
| 출력 (Context) | 각 param의 저장변수 | 현재 처리 Row의 컬럼값을 지정 변수에 세팅 |
| 전이 | `success` | 정상 처리 → 후속 액티비티로 진행 |
| 전이 | `exit` | 처리 건수 0 → 루프 종료 |
| 전이 | `failure` | param-count 미설정 또는 예외 발생 |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

| 항목 | 내용 |
|------|------|
| 목적 | ResultSet의 현재 Row를 PosContext에 바인딩하고 루프 카운터 관리 |
| 반환 타입 | `String` (전이 이름) |
| 파라미터 | `PosContext ctx` |
| throws | `PosException` (선언), `Exception` (내부 catch) |
| 복잡도 | 중간 |

**처리 흐름**:

1. `P_ERR_KEY = "N"`, `BATCH_JOB = "true"` 를 ctx에 세팅
2. `param-count`, `countName`, `bind-result` 프로퍼티 읽기
3. `bind-result` 키로 PosRowSet 조회, `total_row = bindSet.count()` 취득
4. 카운터 초기화 판단: ctx에 `countName` 변수가 없으면 `procCount = total_row`, 있으면 ctx 값 사용
5. `procCount == 0` 이면 ctx에서 카운터 제거 후 `"exit"` 반환 (루프 종료)
6. `procCount -= 1`, `this_row = total_row - procCount` (순방향 인덱스 계산)
7. `QLT_DSN_ERR_YN = ""`, `P_ERR_KEY = "N"` 재초기화
8. `bindSet.reset()` 후 while 순회로 `this_row`번째 Row 탐색
9. 해당 Row에서 `param0..N` 파싱 (`|` 구분자로 `저장변수명|대상항목명` 분리) → ctx에 저장
10. `ctx.put(countName, procCount)` 으로 감소된 카운터 저장 후 `"success"` 반환
11. `param-count` null 시 `"failure"`, 예외 시 에러 로그 후 `"failure"` 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-01 | 배치 잡 플래그 설정 | 항상 | `BATCH_JOB = "true"` 세팅. 후속 액티비티에서 UI/배치 처리 구분 가능 |
| BR-02 | 루프 카운터 최초 초기화 | ctx에 `countName` 변수 없을 때 | `procCount = bindSet.count()` (전체 건수로 초기화) |
| BR-03 | 루프 종료 | `procCount == 0` | ctx에서 카운터 변수 제거 후 `"exit"` 반환 |
| BR-04 | 처리 Row 계산 | 매 루프 | `this_row = total_row - procCount` (역방향 카운터 기반 순방향 인덱싱) |
| BR-05 | 에러 플래그 초기화 | 매 루프 진입 | `P_ERR_KEY = "N"`, `QLT_DSN_ERR_YN = ""` 초기화 |
| BR-06 | 파라미터 바인딩 | `param-count` != null | `param0..N`으로 지정된 컬럼값을 현재 Row에서 읽어 ctx에 저장 |
| BR-07 | param-count 미설정 | `param-count` == null | `"failure"` 반환 |

---

## 4. SQL 매핑

이 클래스는 직접 SQL을 실행하지 않는다. SQL 실행은 이전 서비스의 `PosSearch` 액티비티가 담당하며, 그 결과인 PosRowSet을 `bind-result` 프로퍼티로 수신하여 순회한다.

---

## 5. 참조 업무기준

이 클래스는 범용 루프 제어 액티비티이므로 특정 업무기준(EasyAccess)을 직접 참조하지 않는다. 업무기준 참조는 후속 처리 액티비티에서 수행된다.

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질 설계(QualDesign) 처리, 공정 지시 처리, EAI 연동 등 배치 처리 시나리오에서 이전 스텝이 조회한 주문/코일 목록을 **1건씩 순차 처리**하기 위한 공통 루프 컨트롤러이다.

GLUE Framework의 서비스-액티비티 패턴은 단건 처리를 기본 단위로 설계되어, ResultSet 전체를 순회하는 루프 로직이 별도 액티비티로 분리된다. `DbQualDesignLoop`는 이 역할을 담당하는 공통 컴포넌트로서 40개 이상 서비스에서 공유 사용된다.

### 6.2 핵심 비즈니스 로직

1. **역방향 카운터 + 순방향 인덱싱**: `procCount`는 남은 건수(초기=전체, 1씩 감소). `this_row = total_row - procCount` 수식으로 현재 처리 Row 위치(순방향)를 계산한다. 예: 전체 6건이면 1회차 this_row=1, ..., 6회차 this_row=6.

2. **매 루프 전체 커서 재탐색**: `bindSet.reset()` 후 while 전체 순회로 `this_row`를 탐색한다. 순차 커서 방식이 아닌 매회 처음부터 재탐색하므로 처리 건수가 많을수록 탐색 횟수가 누적 증가한다 (O(n²) 특성).

3. **파라미터 바인딩 패턴**: `param#` 프로퍼티는 `저장변수명|대상항목명` 형태로 선언된다. `|` 구분자로 파싱하여 Row의 컬럼값을 지정된 컨텍스트 변수명으로 저장한다. 후속 액티비티는 컬럼명 대신 서비스 정의 변수명으로 값을 참조한다.

4. **루프 종료 후 카운터 정리**: `procCount == 0` 시 `ctx.remove(coutNm)` 호출로 카운터를 정리하여 동일 서비스 재진입 시 오염을 방지한다.

### 6.3 업무기준(EasyAccess) 참조

없음.

### 6.4 타 시스템 연동

없음. 이 클래스 자체는 순수 루프 제어 로직이며 외부 시스템과 직접 연동하지 않는다.

### 6.5 데이터 영향 범위

- **읽기**: PosContext에서 이전 서비스의 ResultSet(`bind-result` 키), 처리 카운터(`countName`)
- **쓰기**: PosContext에 Row 단위 컬럼값, 감소된 카운터, 초기화 플래그
- **DB 직접 영향**: 없음

주로 영향받는 서비스 영역: 품질 설계 처리(C1031000xx), 제조 지시(C1021000xx), 배치 스케줄(B10R/B10S 시리즈)

### 6.6 주의사항 및 제약조건

- **성능 주의**: `bindSet.reset()` + while 전체 순회 방식으로, 처리 건수가 많을수록 탐색 횟수가 누적 증가한다 (100건 처리 시 최대 5,050회 탐색).
- **`param-count` 필수**: null이면 `"failure"` 반환하므로 서비스 XML에서 반드시 선언해야 한다.
- **`bind-result` 유효성**: 지정된 키가 ctx에 없으면 NullPointerException 발생 → `"failure"` 반환.
- **단건 처리 설계 전제**: 후속 액티비티가 처리 완료 후 `PROC_LOOP`(또는 해당 루프 액티비티명)으로 되돌아오는 전이를 설정해야 올바르게 동작한다.
