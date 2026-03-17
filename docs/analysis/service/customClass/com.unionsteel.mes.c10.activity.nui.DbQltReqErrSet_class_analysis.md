# DbQltReqErrSet 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbQltReqErrSet.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 68 라인 |
| 메소드 수 | 1개 (`runActivity`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

품질설계의뢰 처리 중 에러가 발생한 경우 에러 응답 메시지를 편성하는 Activity이다. EAI 연동 결과나 처리 흐름에서 에러 종류(`errKind`)를 받아 해당 에러 메시지를 PosContext에 설정하고, 처리 상태(XSTAT)와 콜백 상태(XSTAT_CALLBACK)를 에러 상태로 지정한다.

### 1.1 상속/구현 관계

```
PosActivity
    └── DbQltReqErrSet implements C10NuiConstantsIF
```

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 (Property) | `C10STR_P_ERR_KEY` | 에러 종류 구분값 (서비스 XML Property) |
| 출력 (Context) | `COL_XSTAT` | 처리 상태 코드 = `C10STR_X` (에러 상태) |
| 출력 (Context) | `COL_XSTAT_CALLBACK` | 콜백 상태 코드 = `C10STR_R` |
| 출력 (Context) | `COL_XMSGS` | 에러 메시지 (`ERRMSG_EAI1` 또는 `ERRMSG_EAI2`) |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

**목적**: 에러 종류에 따라 적절한 EAI 에러 메시지를 PosContext에 설정

**복잡도**: 매우 낮음

**처리 흐름**:

1. Property `C10STR_P_ERR_KEY`에서 에러 종류 문자열(`errKind`) 획득 후 trim
2. Context에 처리 상태 설정:
   - `COL_XSTAT` = `C10STR_X` (에러 상태)
   - `COL_XSTAT_CALLBACK` = `C10STR_R`
3. 에러 메시지 분기:
   - `errKind.equals(NUM1)` (값 = "1") → `COL_XMSGS` = `ERRMSG_EAI1`
   - 그 외 → `COL_XMSGS` = `ERRMSG_EAI2`
4. `SUCCESS` 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | EAI 에러 타입 1 | `errKind` = "1" | `COL_XMSGS` = `ERRMSG_EAI1` 설정 |
| 2 | EAI 에러 타입 기타 | `errKind` ≠ "1" | `COL_XMSGS` = `ERRMSG_EAI2` 설정 |
| 3 | 에러 상태 공통 설정 | 항상 | `COL_XSTAT` = `C10STR_X`, `COL_XSTAT_CALLBACK` = `C10STR_R` |

---

## 4. SQL 매핑

해당 없음. DB 조회 없이 Context 항목만 편성하는 순수 편집 Activity이다.

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계의뢰 NUI 서비스(`C103100050-service` 등)의 에러 핸들링 전용 Activity이다. 서비스 XML에서 에러 전이(`failure`)로 진입하며, Property로 전달된 에러 종류(`1` 또는 기타)에 따라 EAI 연동 에러 메시지(`ERRMSG_EAI1` 또는 `ERRMSG_EAI2`)를 설정한다.

이 클래스는 DB 접근 없이 오직 Context 항목 편성만 수행하는 단순 편집 Activity로, 서비스 흐름에서 에러 응답 포맷을 통일하는 역할을 한다.
