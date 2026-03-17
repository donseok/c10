# FUNC_GET_YEONSAN 분석 보고서

## 기본 정보
| 항목 | 값 |
|------|-----|
| 오브젝트명 | FUNC_GET_YEONSAN |
| 스키마 | M00APUSER |
| 유형 | FUNCTION (스탠드얼론) |
| 상태 | VALID |
| 라인 수 | 18 |
| 분석일 | 2026-03-17 |
| 분석 모델 | Claude Opus 4.6 |

## 함수 개요

연산자 코드(BETWEEN1~BETWEEN4)를 사람이 읽을 수 있는 연산 기호 문자열로 변환하는 유틸리티 함수이다. 주로 Rules Engine(TB_M00_RULES040)의 조건 연산자를 화면에 표시할 때 사용된다.

## 시그니처

```sql
FUNCTION FUNC_GET_YEONSAN(xYEONSAN IN VARCHAR2) RETURN VARCHAR2
```

### 파라미터
| 파라미터 | 방향 | 타입 | 설명 |
|---------|------|------|------|
| xYEONSAN | IN | VARCHAR2 | 연산자 코드 (BETWEEN1~BETWEEN4 등) |

### 반환값
| 타입 | 설명 |
|------|------|
| VARCHAR2 | 변환된 연산 기호 문자열 |

## 비즈니스 로직

### 연산자 코드 → 연산 기호 변환 매핑

| 입력 코드 | 출력 기호 | 의미 |
|-----------|----------|------|
| BETWEEN1 | `<=값<=` | 최소값 이상, 최대값 이하 (양쪽 포함) |
| BETWEEN2 | `<=값<` | 최소값 이상, 최대값 미만 |
| BETWEEN3 | `<값<=` | 최소값 초과, 최대값 이하 |
| BETWEEN4 | `<값<` | 최소값 초과, 최대값 미만 (양쪽 미포함) |
| 기타 | 입력값 그대로 반환 | 매핑되지 않은 연산자는 원본 유지 |

### 예외 처리
- `WHEN OTHERS`: 모든 예외 발생 시 NULL 반환

## 호출 관계

### 호출되는 곳
- `C107000030tab01.select` 쿼리: `M00APUSER.FUNC_GET_YEONSAN(UPPER(RULES040.MD_RULE_CON_OLSTATR_12))`, `FUNC_GET_YEONSAN(UPPER(RULES040.MD_RULE_CON_OLSTATR_13))` 형태로 호출
  - 두께범위(CON12), 폭범위(CON13) 조건의 연산자 코드를 화면 표시용 기호로 변환
- `C107000030tab02.select` 쿼리: `M00APUSER.FUNC_GET_YEONSAN(UPPER(RULES040.MD_RULE_CON_OLSTATR_3))` 형태로 호출
  - 두께그룹 조건의 연산자 코드를 화면 표시용 기호로 변환

### 호출하는 오브젝트
- 없음 (자체 로직만 수행)

## 특이사항
1. 입력값에 UPPER() 함수를 적용한 후 호출하는 패턴이 일반적이므로, 코드 비교는 대문자 기준
2. 매핑되지 않은 코드는 원본을 그대로 반환하여 확장성 확보
3. 단순 변환 함수로 성능 이슈 없음
