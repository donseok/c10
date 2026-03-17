# FUNC_DECODE01 분석 보고서

## 기본 정보

| 항목 | 값 |
|------|-----|
| 오브젝트명 | FUNC_DECODE01 |
| 스키마 | C10APUSER |
| 유형 | FUNCTION |
| 상태 | VALID |
| 라인 수 | 23 |
| 분석일 | 2026-03-17 |

## 함수 개요

코드값을 의미명으로 변환하는 범용 디코딩 함수. M00APUSER.VI_M00_CODE_ACCESS 뷰에서 코드 타입(CD_TP)과 카테고리 그룹(CATEGORY_GROUP_NM)을 기준으로 코드값(CD_V)에 해당하는 의미명(CD_V_MEANING)을 조회하여 반환한다.

## 시그니처

```sql
FUNCTION FUNC_DECODE01(
    XCD_TP              IN VARCHAR2,   -- 코드 타입 (예: 'PRD_NM_CD', 'GW_ASG_CD', 'CUS_CD')
    XCATEGORY_GROUP_NM  IN VARCHAR2,   -- 카테고리 그룹명 (예: 'SZ0000', 'SV0000')
    XCODE               IN VARCHAR2    -- 변환 대상 코드값
) RETURN VARCHAR2
```

## 처리 로직

1. M00APUSER.VI_M00_CODE_ACCESS 뷰에서 CD_TP, CATEGORY_GROUP_NM, CD_V 3개 조건으로 조회
2. 매칭되는 CD_V_MEANING 값 반환
3. 조회 실패(데이터 없음 포함 모든 예외) 시 NULL 반환

```sql
SELECT CD_V_MEANING
INTO   X
FROM   M00APUSER.VI_M00_CODE_ACCESS
WHERE  CD_TP = XCD_TP
AND    CATEGORY_GROUP_NM = XCATEGORY_GROUP_NM
AND    CD_V = XCODE;
```

## 참조 테이블

| 테이블/뷰 | 스키마 | 접근 패턴 | 용도 |
|-----------|--------|----------|------|
| VI_M00_CODE_ACCESS | M00APUSER | SELECT (PK LOOKUP) | 코드값→의미명 변환 마스터 뷰 |

## 호출 위치 (C105000030 서비스)

| 호출 쿼리 | 파라미터 (CD_TP, CATEGORY_GROUP_NM, CODE) | 변환 대상 |
|-----------|------------------------------------------|----------|
| saveWarPubHst | 'PRD_NM_CD', 'SZ0000', A.PRD_NM_CD | 품명코드 → 품명 |
| saveWarPubHst | 'GW_ASG_CD', 'SV0000', A.GW_ASG_CD | 도금부착량코드 → 도금부착량명 |
| saveWarPubHst | 'CUS_CD', 'SZ0000', A.CUS_CD | 고객사코드 → 고객사명 |
| selectPrdNm | 'PRD_NM_CD', 'SZ0000', A.PRD_NM_CD | 품명코드 → 품명 |

## 특이사항

1. **미사용 변수**: I, CNT, XPROC_CD1, XCCL_FLAG, XCGL_FLAG, XEGL_FLAG, XANN_FLAG 등 7개 변수가 선언되었으나 전혀 사용되지 않음. 과거 복잡한 로직에서 단순화된 것으로 추정.
2. **예외 처리**: `WHEN OTHERS THEN RETURN NULL` — 모든 예외를 잡아 NULL 반환. NO_DATA_FOUND 뿐 아니라 TOO_MANY_ROWS 등도 NULL 처리됨.
3. **성능**: SQL 내 스칼라 서브쿼리로 호출 시 행마다 실행되므로, 대량 데이터 처리 시 성능 영향 가능. 다만 PK LOOKUP이므로 단건 조회는 빠름.
