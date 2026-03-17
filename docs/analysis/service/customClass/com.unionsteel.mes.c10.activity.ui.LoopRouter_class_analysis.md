# LoopRouter 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/LoopRouter.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `C10GridActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 144 라인 |
| 메소드 수 | 6개 (`doPreActivity`, `doMainActivity`, `doPostActivity`, `getRecordToNormalValue`, `doDaoAction`, `getDefaultMsgCode`, `getDefaultMsgParam`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

화면 그리드에서 DML(INSERT/UPDATE/DELETE)된 행 목록을 하나씩 꺼내어 LOOP를 구동하는 라우팅 전용 Activity이다. Service XML의 activity 체인에서 반복 처리가 필요할 때, 이 Activity가 LOOP_CNT를 관리하며 각 반복마다 DML 타입(INSERT/UPDATE/DELETE)을 반환하여 해당 transition으로 분기시킨다. 모든 행 처리가 완료되면 `endLoop`를 반환하여 루프를 종료한다.

### 1.1 상속/구현 관계

- `C10GridActivity` 상속 (GLUE 그리드 기반 Activity, `DhtmlxActivity` 계열)
- `C10NuiConstantsIF` 구현 (LOOP_END, LOOP_CNT 등 루프 관련 상수 참조)
- `doDaoAction()`: C10GridActivity abstract 메소드 구현 (null 반환, 미사용)
- `getDefaultMsgCode()`, `getDefaultMsgParam()`: null 반환 (미구현)
- `doPreActivity()`, `doPostActivity()`: null 반환 (미구현)

### 1.2 핵심 입력/출력

| 구분 | 키 | 설명 |
|------|----|------|
| 입력 (ctx) | `ids` | 그리드 DML 행 ID 배열 (최초 입력) |
| 입력 (ctx) | `m60Ids` | 전체 행 ID 배열 저장용 (루프 제어) |
| 입력 (ctx) | `LOOP_CNT` | 현재 루프 인덱스 (Integer, 없으면 0으로 시작) |
| 입력 (ctx) | `column-info` | 그리드 컬럼 정보 (쉼표 구분 컬럼명) |
| 입력 (ctx) | `column-info_M60` | 컬럼 정보 저장용 (최초 1회 저장) |
| 출력 (ctx) | `m60Ids` | 원본 ids 저장 (최초 1회) |
| 출력 (ctx) | `ids` | 현재 처리 중인 단일 행 ID (루프 진행 시) |
| 출력 (ctx) | `LOOP_CNT` | 증가된 루프 카운터 |
| 출력 (ctx) | `{columnName}` | 현재 행의 각 컬럼 값 (개별 키) |
| 반환값 | `INSERT` / `UPDATE` / `DELETE` | 해당 행의 DML 타입 (다음 transition 결정) |
| 반환값 | `endLoop` (`LOOP_END`) | 모든 행 처리 완료 시 루프 종료 |
| 예외 | `PosException` | ids null 또는 비어있을 때 |

---

## 2. 메소드 상세 분석

### 2.1 doPreActivity(PosContext poscontext)

**목적**: 전처리 (미구현)
**복잡도**: 없음
**처리 흐름**: `return null;`

### 2.2 doMainActivity(PosContext ctx)

**목적**: 그리드 DML 행 목록을 하나씩 꺼내어 DML 타입을 반환하는 루프 라우터

**복잡도**: 중간 (루프 상태 관리, DML 타입 분기, 컬럼 정규화)

**처리 흐름:**

```
1. ctx에 "m60Ids" 없으면: ctx["m60Ids"] = ctx["ids"] (원본 IDS 보관)
2. ids = ctx["m60Ids"] 취득
3. ids == null 또는 ids.length < 1이면 PosException("There is no edit data!") throw
4. idsValue = ids[0].split(",") (행 ID 배열)
5. i = ctx["LOOP_CNT"] != null ? (Integer)ctx["LOOP_CNT"] : 0
6. i < idsValue.length 이면 (루프 진행):
   6-1. dmlType = getDMLType(ctx, idsValue[i]) (INSERT/UPDATE/DELETE 결정)
   6-2. tmp = new String[]{idsValue[i]}
        ctx["ids"] = tmp (현재 행 ID만 ids로 교체)
   6-3. getRecordToNormalValue(ctx, idsValue[i]) 호출 (컬럼 값 정규화)
   6-4. i++ 후 ctx["LOOP_CNT"] = i
   6-5. return dmlType (INSERT/UPDATE/DELETE 중 하나)
7. i >= idsValue.length 이면 (루프 종료):
   7-1. ctx["ids"] = ctx["m60Ids"] (원본 ids 복원)
   7-2. return LOOP_END ("endLoop")
```

### 2.3 doPostActivity(PosContext poscontext)

**목적**: 후처리 (미구현)
**복잡도**: 없음
**처리 흐름**: `return null;`

### 2.4 getRecordToNormalValue(PosContext ctx, String recordId)

**목적**: 그리드 행 데이터를 `{recordId}_{columnId}` 형식에서 `{columnId}` 형식으로 ctx에 재배치

**복잡도**: 낮음 (컬럼 반복 추출)

**처리 흐름:**

```
1. ctx에 "column-info_M60" 없으면: ctx["column-info_M60"] = ctx["column-info"] 저장
2. columnInfo = ctx["column-info_M60"] (String[] - 첫 원소가 쉼표 구분 컬럼명 목록)
3. colOrder = columnInfo[0].split(",") (컬럼명 배열)
4. 루프 (colOrder 전체 순회):
   - tmp = ctx[recordId + "_" + colOrder[i]] (String[] 값 추출)
   - colOrder[i] != "column-info" 이면: ctx[colOrder[i]] = tmp[0] (개별 컬럼 값 저장)
```

### 2.5 doDaoAction(PosContext arg0, PosParameter arg1)

**목적**: C10GridActivity abstract 메소드 구현 (미사용)
**처리 흐름**: `return null;`

### 2.6 getDefaultMsgCode() / getDefaultMsgParam(PosContext arg0)

**목적**: 기본 메시지 관련 메소드 (미구현)
**처리 흐름**: 각각 `return null;`

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 원본 IDS 보관 | `ctx["m60Ids"] == null` | `ctx["ids"]`를 `ctx["m60Ids"]`에 저장 (루프 진행 중에도 원본 유지) |
| 2 | IDS 필수 검증 | `ids == null` 또는 `ids.length < 1` | `PosException("There is no edit data!")` throw |
| 3 | 루프 카운터 초기화 | `ctx["LOOP_CNT"] == null` | i = 0 으로 시작 |
| 4 | 루프 진행 | `i < idsValue.length` | DML 타입 반환 (INSERT/UPDATE/DELETE) |
| 5 | 루프 종료 | `i >= idsValue.length` | `ctx["ids"]` 원본 복원 후 `LOOP_END` 반환 |
| 6 | 컬럼 정보 보관 | `ctx["column-info_M60"] == null` | `ctx["column-info"]`를 `ctx["column-info_M60"]`에 저장 |
| 7 | column-info 컬럼 제외 | `colOrder[i] == "column-info"` | ctx 저장 건너뜀 (메타 컬럼 제외) |

---

## 4. SQL 매핑

이 Activity는 SQL 조회 및 DML을 수행하지 않는다. 순수 라우팅 및 ctx 데이터 정규화만 수행한다.

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| 해당 없음 | - | - |

---

## 5. Route Transition

| 반환값 | 조건 | 설명 |
|--------|------|------|
| `UPDATE` | `getDMLType()` 결과가 UPDATE | 현재 행이 수정 행 |
| `INSERT` | `getDMLType()` 결과가 INSERT | 현재 행이 신규 행 |
| `DELETE` | `getDMLType()` 결과가 DELETE | 현재 행이 삭제 행 |
| `endLoop` | `i >= idsValue.length` | 모든 행 처리 완료, 루프 종료 |
| `PosException` throw | `ids null` 또는 비어있음 | 입력 데이터 없음 |

**Service XML transition 예시:**

```xml
<activity name="LOOP_ROUTER" class="com.unionsteel.mes.c10.activity.ui.LoopRouter">
    <transition name="endLoop" value="end" />
    <transition name="UPDATE"  value="업데이트처리Activity" />
    <transition name="INSERT"  value="삽입처리Activity" />
    <transition name="DELETE"  value="삭제처리Activity" />
</activity>
```

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

화면 그리드에서 사용자가 여러 행을 INSERT/UPDATE/DELETE로 편집한 후 저장하면, GLUE 프레임워크는 편집된 모든 행의 ID 목록(`ids`)을 PosContext에 담아 Service를 호출한다. 기본 GLUE Activity는 이 목록을 한 번에 처리하지만, 행별로 다른 DML 타입에 따라 분기가 필요할 때 이 LoopRouter를 사용한다.

LoopRouter는 매 호출마다 다음 행의 DML 타입을 반환하고, 해당 처리 Activity들이 완료되면 다시 LoopRouter로 돌아오는 재진입(Re-entrant) 루프 구조를 Service XML로 구현한다.

### 6.2 핵심 비즈니스 로직

**루프 상태 관리 메커니즘:**

```
LOOP_CNT: PosContext에 저장되는 루프 인덱스
  - 최초 호출: LOOP_CNT == null -> i = 0
  - 반복 호출: LOOP_CNT = 이전값 + 1
  - 종료 조건: i >= idsValue.length

m60Ids vs ids:
  - m60Ids: 원본 전체 행 ID 배열 (최초 1회 저장, 보호)
  - ids: 루프 중 현재 처리 행 ID 1개짜리 배열로 교체 (후속 Activity가 현재 행만 처리)
  - 루프 종료 시: ids를 m60Ids로 복원
```

**getRecordToNormalValue 변환 패턴:**

그리드 데이터는 `{recordId}_{columnName}` 형식으로 ctx에 저장되어 있다. 이 메소드는 컬럼 정보(`column-info`)를 참조하여 `{columnName}` 형식으로 ctx에 추가 저장함으로써 후속 Activity가 컬럼명만으로 데이터에 접근 가능하도록 한다.

```
변환 전: ctx["12345_COIL_ID"] = String[]{"A001"}
변환 후: ctx["COIL_ID"] = "A001" (String)
```

**주의사항:**

- 클래스 내 `m60Ids` 키는 M60 모듈에서 이식된 흔적이며, C10 모듈에서 재사용하고 있다.
- Javadoc 예시에서 `com.unionsteel.mes.m60.activity.common.LoopRouter` 로 기재되어 있어 원본이 M60 모듈 클래스임을 알 수 있다.
- `getDMLType()`은 C10GridActivity 또는 상위 클래스에서 제공하는 메소드이다.
