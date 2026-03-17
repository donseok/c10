# FUNC_DECODE 분석 보고서

## 기본 정보
| 항목 | 값 |
|------|-----|
| 오브젝트명 | FUNC_DECODE |
| 유형 | FUNCTION (스탠드얼론) |
| 스키마 | MESAPUSER |
| 상태 | VALID |
| 라인 수 | 23 |
| 분석일 | 2026-03-17 |

## 함수 시그니처

```sql
FUNCTION FUNC_DECODE(
    XCD_TP               IN VARCHAR2,   -- 코드유형 (CD_TP)
    XCATEGORY_GROUP_NM   IN VARCHAR2,   -- 카테고리 그룹명
    XCODE                IN VARCHAR2    -- 코드값 (CD_V)
) RETURN VARCHAR2
```

## 기능 요약

공통코드 마스터 뷰(`M00APUSER.VI_M00_CODE_ACCESS`)에서 코드값(CD_V)에 대응하는 **"코드값-코드명"** 형태의 문자열을 반환하는 범용 코드 변환 함수.

## 처리 로직

1. **코드 조회**: `M00APUSER.VI_M00_CODE_ACCESS` 뷰에서 3개 조건(CD_TP, CATEGORY_GROUP_NM, CD_V)으로 PK LOOKUP
2. **결과 생성**: `CD_V || '-' || CD_V_MEANING` 형태로 "코드값-코드의미명" 문자열 조합
3. **반환**: 조합된 문자열 반환

## 예외 처리

- `WHEN OTHERS THEN RETURN NULL` — 코드가 존재하지 않거나 기타 오류 시 NULL 반환 (에러 전파 없음)

## 참조 테이블

| 테이블/뷰 | 스키마 | 용도 | 접근 패턴 |
|-----------|--------|------|----------|
| VI_M00_CODE_ACCESS | M00APUSER | 공통코드 마스터 뷰 | PK LOOKUP (CD_TP + CATEGORY_GROUP_NM + CD_V) |

## 사용 예시

```sql
-- 부자재구분 코드 변환
MESAPUSER.FUNC_DECODE('M47', 'M47_SUB_MTL_TP', sub_mtl_tp)
-- 결과: 'P01-도료' 형태

-- 광택도 코드 변환
MESAPUSER.FUNC_DECODE('M47', 'M47_LUS_RT_CD', lus_rt_cd)
-- 결과: 'G60-60도 광택' 형태
```

## 미사용 변수

함수 내에 선언되었으나 사용되지 않는 변수가 다수 존재:
- `I INT` — 미사용
- `CNT INT` — 미사용
- `XPROC_CD1 VARCHAR2(1)` — 미사용
- `XCCL_FLAG VARCHAR2(1)` — 미사용
- `XCGL_FLAG VARCHAR2(1)` — 미사용
- `XEGL_FLAG VARCHAR2(1)` — 미사용
- `XANN_FLAG VARCHAR2(1)` — 미사용

이는 과거 복잡한 로직이 있었으나 단순화되면서 변수 선언만 남은 것으로 추정됨.

## 특이사항

1. **성능 주의**: 스칼라 서브쿼리로 다수 호출 시 쿼리당 N × M회 (N=행 수, M=컬럼 수) 함수 호출 발생. 대량 데이터 시 성능 저하 가능
2. **WHEN OTHERS 포괄 예외**: 코드 미존재 외의 실제 오류도 NULL로 처리되어 디버깅이 어려울 수 있음
3. **미사용 변수 7개**: 코드 정리가 필요한 레거시 흔적
