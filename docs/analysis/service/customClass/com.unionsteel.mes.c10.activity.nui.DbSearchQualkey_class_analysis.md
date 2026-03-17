# DbSearchQualkey 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `소스 파일 미존재 (유사 클래스 DbSearchQualKeyMatch 기반 추정)` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 소스 미존재 |
| 메소드 수 | 추정 3개 (doPreActivity, doMainActivity, doPostActivity) |
| 분석일자 | 2026-03-16 |

> **주의**: 이 분석은 소스 파일이 프로젝트에 존재하지 않아 유사 클래스 `DbSearchQualKeyMatch`의 구조와 서비스 XML 설정을 기반으로 추정한 내용입니다.

---

## 1. 클래스 개요

Master Data의 설계Key기준을 읽어 품질설계Key사항을 편성하는 Activity이다. `DbSearchQualKeyMatch`의 이전/변형 버전으로 추정되며, 서비스 XML의 property 설정으로 볼 때 GLUE EasyAccess API를 활용하여 마스터 데이터(C10B1040 설계Key기준)에서 품질설계Key를 매칭하는 역할을 수행한다.

### 1.1 상속/구현 관계

```
PosActivity
    └── DbSearchQualkey implements C10NuiConstantsIF
```

- `EasyAccess`: GLUE 마스터데이터 접근 API (PosCalcVO, PosDecisionChecker, PosRuleVO)

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 (Property) | `dao` | DAO 빈 ID (`mesdao`) |
| 입력 (Property) | `bind-list` | 입력 RowSet Key (`RK_SEARCH`) |
| 입력 (Property) | `prodSpecKind` | 제품사양종류 (`1`) |
| 입력 (Property) | `bind-result` | 결과 RowSet Key (`RK_MAIN`) |
| 출력 (Context) | `RK_MAIN` | 품질설계Key 매칭 결과 RowSet |
| 반환 | `success` | 매칭 성공 → CUS_ORD_ERR_CHK로 전이 |
| 반환 | `failure` | 매칭 실패 → ERROR_LOG1로 전이 |

---

## 2. 메소드 상세 분석

### 2.1 `doMainActivity(PosContext ctx)` (추정)

**목적**: RK_SEARCH에서 검색 조건을 받아 Master Data(설계Key기준 C10B1040)에서 품질설계Key를 매칭하여 RK_MAIN에 결과를 저장한다.

**복잡도**: 높음 (추정)

**처리 흐름** (DbSearchQualKeyMatch 기반 추정):

1. `RK_SEARCH`에서 주문 정보 추출 (품명, 형태, 규격약호, 주문용도코드, 고객사코드, 고객사양번호, 주문두께, 주문폭)
2. EasyAccess API로 마스터 테이블 C10B1040(설계Key기준) 조회
3. 필수 Match 조건: 품명, 형태, 규격약호, 주문두께, 주문폭
4. 선택 Match 조건: 주문용도코드, 고객사코드, 고객사양번호
5. 우선항목 Match 처리 (우선순위에 따른 단계적 조건 완화)
6. 매칭 결과를 `RK_MAIN`에 저장
7. 매칭 성공 시 `SUCCESS`, 실패 시 `FAILURE` 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 설계Key 매칭 | 8개 조건(품명,형태,규격약호,용도,고객사,사양번호,두께,폭) 우선순위 Match | RK_MAIN에 결과 저장 |
| 2 | 매칭 성공 | 매칭 결과 존재 | SUCCESS → CUS_ORD_ERR_CHK로 전이 |
| 3 | 매칭 실패 | 매칭 결과 없음 | FAILURE → ERROR_LOG1로 전이 (KC01 에러) |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 위치 |
|---------|------|-----------|
| (없음 - EasyAccess API 사용) | 마스터 테이블 C10B1040 조회 | doMainActivity |

**EasyAccess 마스터 규칙**:
- 마스터 테이블 코드: `C10B1040` (설계Key기준)
- `prodSpecKind=1`: 제품사양종류 1에 해당하는 설계Key 조회

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

OMS에서 전달된 생산가부요청 주문에 대해 품질설계Key를 편성하는 프로세스의 핵심 Activity이다. Master Data의 설계Key기준(C10B1040)을 조회하여 주문 속성(품명, 형태, 규격 등)에 맞는 품질설계Key를 우선순위 기반으로 매칭한다.

**서비스 흐름 내 위치**:
- 초기 Activity (SEARCH_MD)로서 서비스 시작점
- 성공 → CUS_ORD_ERR_CHK (주문 에러 체크)로 전이
- 실패 → ERROR_LOG1 (에러코드 KC01 설정) → SUBSERVICE(C103100140 에러 로그 서비스) 호출

### 6.2 유사 클래스 참고

`DbSearchQualKeyMatch`가 동일 패키지에 존재하며, 보다 상세한 우선항목 Match 처리 로직을 포함한다. `DbSearchQualkey`는 이 클래스의 초기 버전이거나 단순화된 버전으로 추정된다.
