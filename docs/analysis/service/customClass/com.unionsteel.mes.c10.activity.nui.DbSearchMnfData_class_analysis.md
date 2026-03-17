# DbSearchMnfData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchMnfData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `379` 라인 |
| 메소드 수 | `1`개 (`runActivity`) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

`DbSearchMnfData`는 냉연/도금 강판 제품의 **품질설계 결과 제조사양(MNF)을 편성하고 DB에 등록**하는 NUI 액티비티 클래스이다.

제품군(품명코드)별로 EasyAccess 업무기준을 조회하여 ECL C-D 방지 약품, ECL 권취장력, CGL Leveler 사용여부, CGL/EGL 표면처리코드, CGL SkinPass 여부, 정전공정 방청유 코드 등의 제조사양 항목을 결정한 뒤 `TB_C10_QLT_DSN_MNF` 테이블에 INSERT한다.

주문에 대해 최대 3개의 원자재(RMTL_CD, RMTL_CD1, RMTL_CD2)가 존재할 수 있으며, 각 원자재별로 순회하면서 독립적인 제조사양 레코드를 생성한다(`QLT_DSN_MNF_TP` = 1, 2, 3).

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE Framework의 NUI 액티비티 기반 클래스. `runActivity(PosContext)` 메소드로 진입
- `C10NuiConstantsIF` 구현: 모든 컬럼명 상수, 에러코드, EasyAccess 정의명, SQL 키 상수 참조

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력(PosContext) | `RMTL_CD`, `RMTL_CD1`, `RMTL_CD2` | 원자재코드 (최대 3개) |
| 입력(PosContext) | `CRM_MNF_STD_NO`, `CRM_MNF_STD_NO1`, `CRM_MNF_STD_NO2` | 냉연제조표준번호 |
| 입력(PosContext) | `PRD_NM_CD` | 품명코드 (제품군 분기의 핵심 키) |
| 입력(PosContext) | `ORD_EXC_THK` | 주문두께 (ECL C-D 방지약품 조회 조건) |
| 입력(PosContext) | `ORD_SUR_HND_CD` | 주문표면처리코드 |
| 입력(PosContext) | `ORD_SPNL_TP` | 주문Spangle구분 |
| 입력(PosContext) | `PRD_SHP` | 제품형태 |
| 출력(DB) | `TB_C10_QLT_DSN_MNF` | 제조사양 레코드 INSERT |
| 반환 | `SUCCESS` / `FAILURE` | 전이 결과 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 품명코드 기반으로 EasyAccess 업무기준을 조회하여 제조사양 항목을 편성하고 DB에 등록 |
| 복잡도 | 높음 |
| 반환 타입 | `String` (`SUCCESS` / `FAILURE`) |
| throws | `PosException` |

**처리 흐름:**

1. DAO 초기화 (`masterdao` 빈 사용)
2. PosContext에서 원자재코드 1~3개 추출, RMTL 리스트와 CRM_MNF_STD 리스트 구성
3. 원자재 수만큼 반복 (nidx = 0, 1, 2):
   - `QLT_DSN_MNF_TP` = nidx+1 설정
   - **ECL/EGL/EGL 제품군** (C,E,N,1,2,8 = CR, EGI, ZnNi, CCI, CCEI, CCNI) 처리:
     - [C10B2130] ECL C-D 방지 약품 조회 (조건: 주문두께) → `ECL_CDR_CD` 편성
     - [C10B2140] ECL 권취장력 조회 (조건: 품명코드) → `ECL_COILG_TS_CD` 편성
     - 품명이 E(EGI) 또는 N(ZnNi)이면 → `EGL_SUR_HND_CD` = `ORD_SUR_HND_CD` 편성
   - **CGL 제품군** (G,J,K,L,V,W,3,4,6,9 = GI, G/A, Hot GI, G/L, GIX, GLX, CCGI, CCLI, CCGX, CCLX) 처리:
     - [C10B2150] CGL Leveler Set 기준 조회 (조건: 품명코드) → `CGL_LVL_YN` 편성
     - `SPNL_TP` = `ORD_SPNL_TP` 편성
     - SkinPass 여부 결정: Spangle 4, 5, 7번 → `CGL_SP_ASG_YN` = 'Y', 그 외 → 'N'
     - `CGL_SUR_HND_CD` = `ORD_SUR_HND_CD` 편성
   - **CR/CCI 한정** (C, 1 = CR, CCI) 처리:
     - [C10B2170] 정전공정 방청유 Set 기준 조회 (조건: 품명코드, 주문표면처리코드, 제품형태) → `OIL_PNT_CD` 편성
4. 편성된 모든 항목을 PosParameter에 설정 (13개 파라미터 + 감사속성)
5. `C102100MNF.insert` 쿼리로 `TB_C10_QLT_DSN_MNF`에 INSERT
6. 예외 시 에러코드/에러키 설정 후 `FAILURE` 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-01 | 원자재 다중 처리 | RMTL_CD1, RMTL_CD2가 존재하면 | 각각 별도의 QLT_DSN_MNF_TP(2, 3)으로 레코드 생성 |
| BR-02 | ECL C-D 방지약품 편성 대상 | 품명코드 IN (C,E,N,1,2,8) | EasyAccess C10B2130 조회(조건: 주문두께) |
| BR-03 | ECL 권취장력 편성 대상 | 품명코드 IN (C,E,N,1,2,8) | EasyAccess C10B2140 조회(조건: 품명코드) |
| BR-04 | EGL 표면처리코드 편성 대상 | 품명코드 IN (E,N) | EGL_SUR_HND_CD = 주문표면처리코드 |
| BR-05 | CGL Leveler 편성 대상 | 품명코드 NOT IN (C,E,N,1,2,8) → 도금계열 | EasyAccess C10B2150 조회(조건: 품명코드) |
| BR-06 | CGL SkinPass Y 조건 | Spangle구분 = '4' 또는 '5' 또는 '7' | CGL_SP_ASG_YN = 'Y' |
| BR-07 | CGL SkinPass N 조건 | Spangle구분이 4,5,7이 아닌 경우 | CGL_SP_ASG_YN = 'N' |
| BR-08 | CGL 표면처리코드 편성 | CGL 제품군 처리 시 | CGL_SUR_HND_CD = 주문표면처리코드 |
| BR-09 | 정전공정 방청유 편성 대상 | 품명코드 IN (C,1) 즉 CR, CCI만 | EasyAccess C10B2170 조회(조건: 품명+표면처리+제품형태) |
| BR-10 | EasyAccess 단일 결과 필수 | RecordCount = 1이어야 정상 | Count=0은 "없음" 에러, Count>1은 "중복" 에러 |
| BR-11 | 오류 시 즉시 FAILURE 반환 | MasterDataException 또는 Count != 1 | QLT_DSN_ERR_CD, P_ERR_KEY 설정 후 FAILURE |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 |
|---------|------|-----------|
| `C102100MNF.insert` (`INSERT_MNF`) | `TB_C10_QLT_DSN_MNF`에 제조사양 레코드 INSERT | 원자재별 EasyAccess 조회 완료 후 |

**INSERT 대상 컬럼 (13개 핵심 + 감사속성 8개):**

| 파라미터 번호 | 컬럼명 | 설명 |
|---|---|---|
| 0 | ORD_NO | 주문번호 |
| 1 | ORD_LN | 주문행번 |
| 2 | QLT_DSN_MNF_TP | 품질설계제조구분 (1=적정, 2=차선1, 3=차선2) |
| 3 | RMTL_CD | 원자재코드 |
| 4 | CRM_MNF_STD_NO | 냉연제조표준번호 |
| 5 | ECL_CDR_CD | ECL C-D 방지 약품 |
| 6 | ECL_COILG_TS_CD | ECL 권취장력 |
| 7 | CGL_LVL_YN | CGL Leveler 사용여부 |
| 8 | SPNL_TP | Spangle 구분 |
| 9 | CGL_SP_ASG_YN | CGL SkinPass 여부 |
| 10 | CGL_SUR_HND_CD | CGL 표면처리코드 |
| 11 | EGL_SUR_HND_CD | EGL 표면처리코드 |
| 12 | OIL_PNT_CD | 도유코드 |
| 13~20 | CREATED_*, LAST_UPDATED_* | PosAuditAttributes (감사 속성) |

---

## 5. 참조 업무기준 (EasyAccess)

| 업무기준 ID | 마스터데이터 정의명 | 조건항목 | 결과항목 | 대상 제품군 |
|------------|---------------------|----------|---------|------------|
| `C10B2130` | ECL C-D 방지 약품 Set 기준 | 주문두께(ORD_EXC_THK) | ECL_CDR_CD | CR, EGI, ZnNi, CCI, CCEI, CCNI (C,E,N,1,2,8) |
| `C10B2140` | ECL 권취장력 Set 기준 | 품명코드(PRD_NM_CD) | ECL_COILG_TS_CD | CR, EGI, ZnNi, CCI, CCEI, CCNI (C,E,N,1,2,8) |
| `C10B2150` | CGL Leveler Set 기준 | 품명코드(PRD_NM_CD) | CGL_LVL_YN | GI, G/A, Hot GI, G/L, GIX, GLX, CCGI, CCLI, CCGX, CCLX |
| `C10B2170` | 정전공정 방청류 Set 기준 | 품명코드, 주문표면처리코드, 제품형태 | OIL_PNT_CD | CR, CCI (C,1) |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

이 클래스는 냉연/도금 강판 품질설계 프로세스에서 **제조사양(Manufacturing Specification) 편성** 단계를 담당한다. 주문 수주 후 어떤 공정 파라미터(ECL 약품, CGL Leveler 등)로 제품을 제조할 것인가를 업무기준 DB(EasyAccess)에서 자동으로 조회·결정하는 역할이다.

하나의 주문에 최대 3개의 원자재(적정/차선1/차선2)를 배정할 수 있으며, 각각의 원자재에 대해 독립적인 제조사양 레코드를 생성한다.

### 6.2 핵심 비즈니스 로직

**제품군 분류 체계:**
- **냉연/전기도금 계열** (품명코드: C=CR, 1=CCI, 2=CCEI, E=EGI, N=ZnNi, 8=CCNI): ECL 라인 사양 적용
- **용융도금 계열** (품명코드: G=GI, J=G/A, K=Hot GI, L=G/L, V=GIX, W=GLX, 3=CCGI, 4=CCLI, 6=CCGX, 9=CCLX): CGL 라인 사양 적용
- **CR/CCI 한정**: 정전공정(도유) 사양 추가 적용

**CGL SkinPass 결정 이력:**
- 최초: Spangle 4번만 Y (원래 로직)
- 2014.11.25 변경: Spangle 5번 추가 (우봉우 대리 요청)
- 2018.03.30 변경: Spangle 7번 추가 (전현진 대리 요청)
- 하드코딩된 값 `"4"`, `"5"`, `"7"` (상수 NUM4, NUM5, NUM7 사용)

### 6.3 업무기준(EasyAccess) 참조

총 4개의 EasyAccess 업무기준 참조. 모두 단일 결과(RecordCount=1) 필수.

에러코드 매핑:
- `KK58`: ECL C-D 방지약품 기준 없음 / `KK59`: 중복
- `KK54`: ECL 권취장력 기준 없음 / `KK55`: 중복
- `KK56`: CGL Leveler 기준 없음 / `KK57`: 중복
- `KK68`: 정전공정 방청유 기준 없음 / `KK69`: 중복
- `TB06`: DB INSERT 오류

### 6.4 타 시스템 연동

EasyAccess (업무기준 조회 미들웨어): `masterdao` (M00APUSER 스키마)를 통해 4개의 업무기준 테이블 조회.

### 6.5 데이터 영향 범위

| 테이블 | 스키마 | 조작 | 비고 |
|--------|--------|------|------|
| `TB_C10_QLT_DSN_MNF` | MESAPUSER | INSERT | 주문당 최대 3건 |

### 6.6 주의사항 및 제약조건

- EasyAccess 조회 결과가 정확히 1건이 아닌 경우 즉시 FAILURE 반환 (0건=기준 미설정, 2건 이상=기준 중복)
- 대상 제품군(품명코드 16종)에 속하지 않으면 EasyAccess 조회 없이 INSERT만 수행 (해당 필드는 NULL)
- Spangle SkinPass 조건은 하드코딩 분기이므로 업무 변경 시 소스 수정 필요
- 파일 헤더의 `@FileName`은 `DbSearchRsnRouData.java`로 기재되어 있으나 실제 파일명은 `DbSearchMnfData.java` (복사 후 수정 누락)
