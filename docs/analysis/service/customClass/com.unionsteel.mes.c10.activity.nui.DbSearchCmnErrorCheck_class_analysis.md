# DbSearchCmnErrorCheck 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchCmnErrorCheck.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `96` 라인 |
| 메소드 수 | `1`개 |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

품질설계 에러 테이블(`TB_C10_QLT_DSN_ERR`)에 동일한 키 조합(주문번호+주문행번+품질설계에러코드)의 데이터가 이미 존재하는지 중복 여부를 확인하는 NUI Activity 클래스이다. 중복이 있으면 `FAILURE`, 없으면 `SUCCESS`를 반환하여 후속 INSERT 액티비티 실행 여부를 제어한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속 → `runActivity(PosContext ctx)` 메소드 오버라이드
- `C10NuiConstantsIF` 구현 → SQL 키 상수(`C103100140_SELECT_QUERY`) 및 컬럼명 상수(`COL_ORD_NO`, `COL_ORD_LN`, `COL_QLT_DSN_ERR_CD`) 활용

### 1.2 핵심 입력/출력

| 구분 | 키 | 설명 |
|------|-----|------|
| 입력(ctx) | `ORD_NO` | 주문번호 |
| 입력(ctx) | `ORD_LN` | 주문행번 |
| 입력(ctx) | `QLT_DSN_ERR_CD` | 품질설계에러코드 |
| 반환 | `success` | 중복 없음 → INSERT 진행 |
| 반환 | `failure` | 중복 존재 또는 예외 → INSERT 중단 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | TB_C10_QLT_DSN_ERR 중복 키 존재 여부 확인 |
| 복잡도 | 낮음 |
| 파라미터 | `PosContext ctx` |
| 반환 타입 | `String` (라우트 전이 키: `success` / `failure`) |

**처리 흐름**:
1. ctx에서 `ORD_NO`, `ORD_LN`, `QLT_DSN_ERR_CD` 값 추출
2. `PosParameter`에 WHERE 조건 파라미터 설정 (위치 인덱스 방식)
3. `mesdao.find(C103100140.select, param)` 실행 → 중복 레코드 조회
4. 예외 발생 시 `FAILURE` 반환
5. 조회 결과 건수 > 0 이면 `FAILURE` 반환 (이미 존재)
6. 건수 = 0 이면 `SUCCESS` 반환 (삽입 가능)

**주의**: `param.setWhereClauseParameter` 호출 시 인덱스가 모두 `0`으로 설정되어 있으며, 실제 Oracle 위치 파라미터(`?`) 순서는 쿼리의 WHERE 절 순서(`QLT_DSN_ERR_CD`, `ORD_LN`, `ORD_NO`)와 역순으로 매핑됨.

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 중복 데이터 차단 | `TB_C10_QLT_DSN_ERR`에 동일 (ORD_NO, ORD_LN, QLT_DSN_ERR_CD) 존재 | `FAILURE` 반환 → INSERT 미실행 |
| 2 | 예외 시 안전 차단 | DB 조회 중 예외 발생 | `FAILURE` 반환 → INSERT 미실행 |
| 3 | 신규 에러 허용 | 중복 없음 | `SUCCESS` 반환 → INSERT 실행 |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| `C103100140.select` | TB_C10_QLT_DSN_ERR에서 중복 여부 조회 | runActivity() 내부, DAO `find()` 호출 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 에러 등록 NUI 서비스(`C103100140`)에서 INSERT 전에 중복 등록을 방지하기 위해 실행되는 전처리 Activity이다. 주문번호·주문행번·품질설계에러코드 3개 키의 조합이 이미 `TB_C10_QLT_DSN_ERR`에 존재하면 INSERT를 막는다.
