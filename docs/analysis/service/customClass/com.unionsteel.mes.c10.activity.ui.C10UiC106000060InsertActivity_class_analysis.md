# C10UiC106000060InsertActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C10UiC106000060InsertActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `C10DhtmlxActivity` |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 172 라인 |
| 메소드 수 | 5개 (`doMainActivity`, `doPreActivity`, `doPostActivity`, `getDefaultMsgCode`, `getDefaultMsgParam`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

C106000060 화면에서 품질설계 관련 담당자(정/부) 정보를 `PosContext`에서 추출하여 다시 ctx에 저장하는 데이터 중계 Activity이다. DB 조회나 DML을 수행하지 않으며, RK_C10A2200 키의 PosRow에서 `MAIN_EMP_CD`, `SUB_EMP_CD1`, `SUB_EMP_CD2` 값을 꺼내어 개별 ctx 키로 재배치하는 단순 데이터 변환 역할을 한다.

### 1.1 상속/구현 관계

- `C10DhtmlxActivity` 상속 (내부 기반 클래스, `DhtmlxActivity` 재확장)
- DhtmlxActivity 생명주기: `doPreActivity()` → `doMainActivity()` → `doPostActivity()`
- `doPreActivity()`, `doPostActivity()`, `getDefaultMsgCode()`, `getDefaultMsgParam()`은 모두 null 반환 (미구현)
- 실질적 로직은 `doMainActivity()`에만 집중
- `getIndexPosRow(ctx, rowKey, index)` 유틸 메소드는 C10DhtmlxActivity (또는 상위 클래스)에서 제공

### 1.2 핵심 입력/출력

| 구분 | 키 | 설명 |
|------|----|------|
| 입력 (ctx) | `RK_C10A2200` (index=0) | 품질 설계 담당자 정보 PosRow (0번째 행) |
| 입력 (PosRow) | `MAIN_EMP_CD` | 정담당자 사번 |
| 입력 (PosRow) | `SUB_EMP_CD1` | 부담당자1 사번 |
| 입력 (PosRow) | `SUB_EMP_CD2` | 부담당자2 사번 |
| 출력 (ctx) | `MAIN_EMP_CD` | 정담당자 사번 |
| 출력 (ctx) | `SUB_EMP_CD1` | 부담당자1 사번 |
| 출력 (ctx) | `SUB_EMP_CD2` | 부담당자2 사번 |
| 반환값 | `SUCCESS` | 정상 완료 |
| 예외 | `PosException` | 예외 발생 시 throw |

---

## 2. 메소드 상세 분석

### 2.1 doPreActivity(PosContext arg0)

**목적**: 전처리 (미구현)
**복잡도**: 없음
**처리 흐름**: `return null;` 즉시 반환

### 2.2 doMainActivity(PosContext ctx)

**목적**: RK_C10A2200 PosRow에서 담당자 코드를 추출하여 ctx에 개별 키로 저장

**복잡도**: 낮음 (단순 데이터 추출 및 ctx 저장)

**처리 흐름:**

```
1. getIndexPosRow(ctx, "RK_C10A2200", 0) 호출하여 0번째 PosRow 취득
2. logger.logInfo("== 1 " + jRow) 출력
3. mainEmpCd, subEmpCd1, subEmpCd2 초기화 (빈 문자열 "")
4. jRow != null 이면:
   - MAIN_EMP_CD = jRow.getAttribute("MAIN_EMP_CD")
   - SUB_EMP_CD1 = jRow.getAttribute("SUB_EMP_CD1")
   - SUB_EMP_CD2 = jRow.getAttribute("SUB_EMP_CD2")
5. ctx.put("MAIN_EMP_CD", mainEmpCd)
   ctx.put("SUB_EMP_CD1", subEmpCd1)
   ctx.put("SUB_EMP_CD2", subEmpCd2)
6. SUCCESS 반환
예외 발생 시:
   - System.out.println(e.getMessage()) + logger.logDebug()
   - PosException(e.getMessage() + "데이타 오류입니다.") throw
```

### 2.3 doPostActivity(PosContext arg0)

**목적**: 후처리 (미구현)
**복잡도**: 없음
**처리 흐름**: `return null;`

### 2.4 getDefaultMsgCode()

**목적**: 기본 메시지 코드 (미구현)
**처리 흐름**: `return null;`

### 2.5 getDefaultMsgParam(PosContext arg0)

**목적**: 기본 메시지 파라미터 (미구현)
**처리 흐름**: `return null;`

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | jRow null 방어 | `jRow != null` | MAIN_EMP_CD, SUB_EMP_CD1, SUB_EMP_CD2 추출 |
| 2 | jRow null 시 기본값 | `jRow == null` | 빈 문자열("") 사용 (NPE 방지) |
| 3 | ctx 저장 | 항상 실행 | 3개 담당자 코드를 ctx에 저장 (null/empty 포함) |

---

## 4. SQL 매핑

이 Activity는 SQL 조회 및 DML을 수행하지 않는다. 순수 데이터 추출 및 ctx 재배치만 수행한다.

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| 해당 없음 | - | - |

---

## 5. Route Transition

| 반환값 | 조건 | 설명 |
|--------|------|------|
| `SUCCESS` | 정상 처리 완료 | 담당자 코드 ctx 저장 후 반환 |
| `PosException` throw | `Exception` 발생 | 예외 전파 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

C106000060 화면의 저장 처리 흐름에서 이전 Activity가 `RK_C10A2200` 키로 담당자 정보 PosRow를 ctx에 저장한 후, 이 Activity가 해당 Row에서 담당자 코드를 꺼내 후속 Activity가 사용하기 쉬운 개별 키(`MAIN_EMP_CD`, `SUB_EMP_CD1`, `SUB_EMP_CD2`)로 ctx에 재배치한다.

품질설계 담당자 정보는 "정담당자 1명 + 부담당자 최대 2명" 구조로, 이 값들이 이후 INSERT/UPDATE SQL의 파라미터로 사용된다.

### 6.2 핵심 비즈니스 로직

**데이터 변환 흐름:**

```
입력: ctx["RK_C10A2200"][0] (PosRow)
  ↓ getAttribute
출력: ctx["MAIN_EMP_CD"] = String
      ctx["SUB_EMP_CD1"] = String
      ctx["SUB_EMP_CD2"] = String
```

**null 안전 처리:**

`getIndexPosRow`가 null을 반환할 수 있으며, null 체크 후에만 getAttribute를 호출하여 NullPointerException을 방지한다. null인 경우 빈 문자열("")이 ctx에 저장된다.

**주의사항:**

- 클래스 파일 헤더 주석의 `@fileName`이 `C10UiC106000020InsertActivity.java`로 잘못 기재되어 있음 (실제 파일은 C10UiC106000060InsertActivity.java)
- `@author`도 `이민균`으로 기재되어 있으나 Javadoc의 created date는 2019-01-23, 최초 생성자는 JKJ로 표기
- `System.out.println()` 예외 출력 사용
- DB 작업이 없으므로 트랜잭션 처리 불필요
