# DbSearchGwTotData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchGwTotData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 205 라인 |
| 메소드 수 | 1개 (runActivity) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

도금제품에 대한 도금량(Galvanizing Weight) 정보를 편성하는 클래스이다.
품명코드를 기준으로 도금 가능 제품군 여부를 판별하고, 칼라제품의 경우 원판 품명코드로 변환하여 `m00apuser.VI_M00_C10A1061`(도금량 View)를 조회한다.
조회된 도금량 데이터(전면/후면 하한/상한, 목표부착량, 도금두께 최소/최대)를 도금 작업공정 방식에 따라 시험도금량 또는 작업도금량으로 PosContext에 설정한다.

### 1.1 상속/구현 관계

- `extends PosActivity` : GLUE 프레임워크 Activity 기반 클래스
- `implements C10NuiConstantsIF` : NUI 상수 인터페이스

### 1.2 핵심 입력/출력

**입력 (PosContext에서 추출)**

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_PRD_NM_CD | 품명코드 |
| COL_GW_ASG_CD | 도금량지정코드 |

**Service Property**

| Property 명 | 의미 |
|-------------|------|
| dao | 사용할 DAO bean ID (masterdao) |

**출력 (PosContext에 저장)**

도금 작업공정 방식별 시험도금량:

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_TST_GW_TOT_LLV | 시험도금량 합계 하한 |
| COL_TST_GW_TOT_ULV | 시험도금량 합계 상한 |
| COL_TST_GW_FRN_LLV | 시험도금량 전면 하한 |
| COL_TST_GW_FRN_ULV | 시험도금량 전면 상한 |
| COL_TST_GW_BAK_LLV | 시험도금량 후면 하한 |
| COL_TST_GW_BAK_ULV | 시험도금량 후면 상한 |

작업도금량 (공통):

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_WK_GW_TRV | 작업도금량 목표값 |
| COL_WK_GW_FRN_LLV | 작업도금량 전면 하한 |
| COL_WK_GW_FRN_ULV | 작업도금량 전면 상한 |
| COL_WK_GW_BAK_LLV | 작업도금량 후면 하한 |
| COL_WK_GW_BAK_ULV | 작업도금량 후면 상한 |
| COL_WK_GW_TOT_LLV | 작업도금량 합계 하한 |
| COL_WK_GW_TOT_ULV | 작업도금량 합계 상한 |
| COL_GAL_THK_LLV | 도금두께 최소 |
| COL_GAL_THK_ULV | 도금두께 최대 |
| COL_GAL_THK_TRV | 도금두께 목표값 |
| COL_SPC_GAL_THK | 규격도금두께 |
| COL_QLT_DSN_SPC_TP | 품질설계사양구분 (= NUM2 = "2") |

에러 시:

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_QLT_DSN_ERR_CD | 품질설계 에러코드 |
| C10STR_P_ERR_KEY | 에러 발생 여부 플래그 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 도금제품 품명코드 검증, 도금량 View 조회, 도금공정 방식별 시험/작업 도금량 설정 |
| 반환 타입 | String |
| 반환값 | SUCCESS / FALSE / FAILURE |
| 복잡도 | 중간 |

**처리 흐름**

1. DAO bean 획득, 지역변수 초기화 (prd_nm_cd, gw_asg_cd)
2. `COL_PRD_NM_CD` null 체크 → null이면 에러코드 ERRCD_KS11, 에러플래그 YES 설정 후 FAILURE 반환
3. 도금 가능 품명코드 판별 - 14개 품명코드(E,G,K,J,L,V,N,W,2,3,4,6,8,9)에 해당하지 않으면 FALSE 반환 (비도금 제품 정상 종료)
4. 품명코드 편집 (칼라제품은 원판 품명코드로 변환):
   - G, 3 → G
   - K → K
   - J → J
   - L, 4 → L
   - V, 6 → V
   - W, 9 → W
   - E, 2 → E
   - N, 8 → N
5. `COL_GW_ASG_CD`를 `gw_asg_cd` 변수에 저장
6. `VI_M00_C10A1061` View 조회: 키 = (prd_nm_cd, gw_asg_cd)
7. `MasterDataException` 발생 시 에러코드 ERRCD_KK31 설정 후 FAILURE 반환
8. 결과 건수 검증:
   - rowset.count() = 1: 정상 처리 진행
   - rowset.count() > 1: 에러코드 ERRCD_KK32, 에러로그 ERRMSG_R83 후 FAILURE 반환
   - rowset.count() = 0: 에러코드 ERRCD_KK31, 에러로그 ERRMSG_R82 후 FAILURE 반환
9. 도금 작업공정별 시험도금량 설정:
   - 합계도금(G,K,3,J,L,4,V,6,W,9): 시험도금량 합계(LLV/ULV)에 작업도금량 합계값 복사, 시험도금량 전면/후면은 공백
   - 전면/후면도금(E,2,N,8): 시험도금량 합계는 공백, 시험도금량 전면/후면에 작업도금량 전면/후면값 복사
10. 작업도금량 공통 컬럼 ctx 저장: WK_GW_TRV, WK_GW_FRN/BAK LLV/ULV, WK_GW_TOT LLV/ULV, GAL_THK LLV/ULV/TRV, SPC_GAL_THK
11. `COL_QLT_DSN_SPC_TP = NUM2` ("2") 저장
12. SUCCESS 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| R01 | 품명코드 필수 | COL_PRD_NM_CD null | FAILURE (ERRCD_KS11) |
| R02 | 비도금 제품 스킵 | 품명코드가 E,G,K,J,L,V,N,W,2,3,4,6,8,9 에 해당하지 않음 | FALSE 반환 (정상 스킵) |
| R03 | 칼라제품 → 원판 품명코드 변환 (G계열) | 품명코드 G 또는 3 | prd_nm_cd = G |
| R04 | 칼라제품 → 원판 품명코드 변환 (L계열) | 품명코드 L 또는 4 | prd_nm_cd = L |
| R05 | 칼라제품 → 원판 품명코드 변환 (V계열) | 품명코드 V 또는 6 | prd_nm_cd = V |
| R06 | 칼라제품 → 원판 품명코드 변환 (W계열) | 품명코드 W 또는 9 | prd_nm_cd = W |
| R07 | 칼라제품 → 원판 품명코드 변환 (E계열) | 품명코드 E 또는 2 | prd_nm_cd = E |
| R08 | 칼라제품 → 원판 품명코드 변환 (N계열) | 품명코드 N 또는 8 | prd_nm_cd = N |
| R09 | 도금량 조회 결과 0건 | rowset.count() = 0 | FAILURE (ERRCD_KK31, ERRMSG_R82) |
| R10 | 도금량 조회 결과 2건 이상 | rowset.count() > 1 | FAILURE (ERRCD_KK32, ERRMSG_R83) |
| R11 | 합계도금 시험도금량 설정 | 품명코드 G,K,3,J,L,4,V,6,W,9 | TST_GW_TOT = WK_GW_TOT 복사, TST_GW_FRN/BAK = 공백 |
| R12 | 전면/후면도금 시험도금량 설정 | 품명코드 E,2,N,8 | TST_GW_TOT = 공백, TST_GW_FRN/BAK = WK_GW_FRN/BAK 복사 |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| VI_M00_C10A1061 | 도금량 View 조회 (masterdao, m00apuser 스키마) | 도금 가능 품명코드 확인 후 |

**조회 키**: prd_nm_cd (원판 품명코드로 변환 후), gw_asg_cd (도금량지정코드)

**조회 컬럼**: WK_GW_TRV, WK_GW_FRN/BAK LLV/ULV, WK_GW_TOT LLV/ULV, GAL_THK LLV/ULV/TRV, SPC_GAL_THK

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

강판 도금 공정에서 제품의 도금량(용융아연도금, 전기아연도금 등) 설계값을 마스터 데이터에서 조회하여 PosContext에 편성하는 Activity이다.

도금제품에는 크게 두 가지 방식이 있다:
- **합계도금** (G,K,J,L,V,W 및 칼라제품 3,4,6,9): 전면+후면 합계로 도금량을 관리. 시험도금량 합계(TST_GW_TOT)에 작업도금량 합계 값 사용.
- **전면/후면 개별도금** (E,N 및 칼라제품 2,8): 전면과 후면을 각각 관리. 시험도금량 전면(TST_GW_FRN), 후면(TST_GW_BAK)에 각각의 작업도금량 값 사용.

칼라제품(3,4,6,8,9,2)은 도금 후 도색 처리된 제품으로, 도금량 기준은 원판(베이스) 품명코드의 기준을 따른다. 따라서 조회 시 품명코드를 원판 코드로 변환한다.

비도금 제품(A,B,C,D,1 등)은 이 Activity를 거쳐도 FALSE를 반환하여 도금량 설정 없이 이후 흐름으로 진행한다.

`COL_QLT_DSN_SPC_TP = NUM2 ("2")` 설정은 품질설계사양구분을 도금사양으로 명시하는 것이다.
