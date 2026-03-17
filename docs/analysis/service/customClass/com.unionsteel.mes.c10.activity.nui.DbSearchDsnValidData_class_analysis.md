# DbSearchDsnValidData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchDsnValidData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `2711` 라인 |
| 메소드 수 | `9`개 |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

품질설계 대기 상태인 주문에 대해 설계 정합성(Validation)을 종합 체크하는 NUI(배치) 액티비티 클래스이다. 품질설계 결과의 성분(화학 성분), 재질(기계적 특성), 인수도(치수 공차), 제조사양(두께/폭/도금/소둔) 등 4개 영역의 설계 데이터가 올바르게 설계되었는지 검증하고, 오류 코드를 누적하여 에러 테이블에 등록하며, 최종적으로 품질설계 상태(A/B/E)를 결정한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE Framework의 액티비티 기반 클래스. `runActivity()` 메소드를 구현
- `C10NuiConstantsIF` 구현: SQL 키 상수, 에러 코드 상수, 제품명 코드 상수 등 모든 상수 참조

### 1.2 핵심 입력/출력

**입력 (PosContext)**

| 컬럼 상수 | 업무명 | 비고 |
|-----------|--------|------|
| COL_ORD_NO | 주문번호 | |
| COL_ORD_LN | 주문행번 | |
| COL_PRD_NM_CD | 품명코드 | CR/EG/GI/GA/GL 등 |
| COL_QLT_DSN_CFM_TP | 품질설계확정구분 | A=자동, M=수동 |
| COL_QLT_DSN_ERR_YN | 품질설계에러여부 | |
| COL_GW_ASG_CD | 도금지정코드 | 도금제품 여부 판단 |
| COL_ORD_UNT_WGT | 주문단위중량 | |
| COL_ORD_KND | 주문종류 | |
| COL_ORD_DSN_CFM_TP | OMS주문 자동/수동설계 구분 | |
| COL_FNL_CUS_CD | 최종고객사코드 | |
| COL_CCL_BOM_NO | CCL BOM번호 | 칼라제품 재단선 체크 |
| COL_ORD_EDG_ASG_TP | 주문Edge지정구분 | |
| COL_MQL_CD | 재질코드 | |
| COL_RMTL_CD | 원자재코드 | |
| COL_CRM_MNF_STD_NO | 제조표준번호 | |
| COL_PAS_PROC_NO | 통과공정번호 | |

**출력 (Transition)**

| 반환값 | 조건 |
|--------|------|
| `TRUE` (PosBizControlConstants.TRUE) | 에러 없음 + 자동확정구분 'A' |
| `FALSE` (PosBizControlConstants.FALSE) | 그 외 모든 경우 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 품질설계 정합성 체크 총괄 진입점 |
| 복잡도 | 높음 |
| 반환 타입 | String (PosBizControlConstants.TRUE/FALSE) |

**처리 흐름**:
1. PosContext에서 주문 관련 기본 정보 추출 (주문번호, 품명코드, 확정구분 등)
2. CCL BOM번호가 있으면 재단선(cut_ln_yn) 조회 후 Edge 구분 유효성 체크 (ERRCD_CF84)
3. 공통항목 NULL 체크: 재질코드(CF01), 원자재코드(CF02), 제조표준번호(CF03), 통과공정번호(CF04), 매중량(CF82)
4. `CheckChem()` 호출 - 성분 정합성 체크
5. `CheckMech()` 호출 - 재질 정합성 체크
6. `CheckDeli()` 호출 - 인수도 정합성 체크
7. `CheckMnf()` 호출 - 제조사양 중요항목 체크
8. `ErrProc()` 호출 - 에러 등록 및 품질설계 상태 반영
9. 에러 없음 + 자동확정 'A'인 경우 TRUE 반환, 그 외 FALSE 반환

### 2.2 CheckChem(PosGenericDao dao, String ORD_NO, String ORD_LN, String ERR_CODE)

| 항목 | 내용 |
|------|------|
| 목적 | 품질설계결과 성분항목 정합성 체크 |
| 복잡도 | 매우 높음 |
| SQL 사용 | SELECT_CHM (C102100CHM.select) - 구분코드로 규격(2)/보증(4)/고객(1) 조회 |

**체크 내용**:
- 규격사양(NUM2) 존재 여부 → 없으면 ERRCD_CF05
- 보증사양(NUM4) 존재 여부 → 없으면 ERRCD_CF06
- 화학성분 13개 원소(C, Si, Mn, P, S, Cr, Ni, Cu, Al, Ti, Nb, V, N)에 대해:
  - 규격사양: 상한 >= 하한 체크 (ERRCD_C0X3)
  - 규격 vs 보증: 보증하한 >= 규격하한, 보증상한 <= 규격상한 체크 (ERRCD_C0X1)
  - 고객사양 존재 시: 고객 vs 보증 범위 체크 (ERRCD_C0X1), 고객 자체 상하한 체크 (ERRCD_C0X4)
- `chkMinMax()` 호출하여 실제 대소 비교 후 에러코드 누적

### 2.3 CheckMech(PosGenericDao dao, String ORD_NO, String ORD_LN, String ERR_CODE)

| 항목 | 내용 |
|------|------|
| 목적 | 품질설계결과 재질항목(기계적 특성) 정합성 체크 |
| 복잡도 | 매우 높음 |
| SQL 사용 | SELECT_MQL (C102100MQL.select) - 구분코드로 규격/보증/고객 조회 |

**체크 내용**:
- 규격사양 없으면 ERRCD_CF64, 보증사양 없으면 ERRCD_CF66 즉시 반환
- 기계적 특성 5개 항목(TS, YP, 연신율, HRB, ER)에 대해 상하한 체크
- 도금량 3개 항목(전면/후면/전체) 규격 vs 보증 범위 체크
- 굽힘 시험 기준코드(MQL_BND_TST_STD_CD) 규격 vs 보증 일치 여부 체크

### 2.4 CheckDeli(PosGenericDao dao, String ORD_NO, String ORD_LN, String ERR_CODE)

| 항목 | 내용 |
|------|------|
| 목적 | 품질설계결과 인수도항목(치수 공차) 정합성 체크 |
| 복잡도 | 매우 높음 |
| SQL 사용 | SELECT_DLV (C102100DLV.select), SELECT_CHM (고객사양 재사용) |

**체크 내용**:
- 규격사양 없으면 ERRCD_CF65, 보증사양 없으면 ERRCD_CF67 즉시 반환
- 두께/폭/길이 공차 상하한 체크 (규격 vs 보증, 고객 vs 보증)
- 고객사양 없는 경우: 규격 vs 보증의 반곡H, 중곡H, 외곡H, 직선도, 직각도, 대각선차, 급준도, Telescope 등가 여부 체크
- 고객사양 있는 경우: 고객 값이 공백이 아닐 때만 보증과 비교

### 2.5 CheckMnf(PosGenericDao dao, String ORD_NO, String ORD_LN, String PRD_NM_CD, String GW_ASG_CD, String ERR_CODE)

| 항목 | 내용 |
|------|------|
| 목적 | 품질설계 제조사양 중요항목 정합성 체크 |
| 복잡도 | 매우 높음 |
| SQL 사용 | SELECT_MNF, SELECT_PROC, SELECT_RMT, SELECT_MNF_CCL_BOM |

**체크 내용**:
- 품명코드 5, 7번(PRD_NM_CD_5/7) 제외한 제품만 체크
- 제품두께(하한/상한/목표), 제품폭(하한/상한) NULL 및 범위 체크 (CF07~CF10)
- PLTCM X-RAY SET 두께, 목표폭 NULL 체크 (CF25, CF26, CF72)
- 도금제품(GW_ASG_CD != 공백)인 경우:
  - 도금목표두께 (GAL/CGL/EGL): CF18, CF21, CF23
  - 도금목표폭 (CGL/EGL): CF22, CF24
  - 도금두께 상하한 및 작업도금량: CF19, CF11
  - EG/CR 계열(E,2,N,8): 전면/후면 도금량 상하한 (CF12~CF15)
  - GI/GL/GA 계열(G,K,J,L,V,W,3,4,6,9): 전체 도금량 상하한 (CF16, CF17)
- 소둔로/소둔Cycle 체크 (통과공정 조회 후):
  - CR/EG 계열 - 일반/HC 소둔로 Cycle (CF36~CF43)
  - GI/GL/GA 계열 - CGL별(2~5번) 소둔 사양 (CF44~CF63)
- 원자재 목표두께/폭 및 상하한 체크 (CF29~CF32)
- 칼라제품(1~9): CCL BOM 존재 여부 체크 (CF35)

### 2.6 ErrProc(...)

| 항목 | 내용 |
|------|------|
| 목적 | 에러코드 DB 등록, SMS 발송, 품질설계 상태 UPDATE |
| 복잡도 | 매우 높음 |
| SQL 사용 | SELECT_ERR, INSERT_ERR, INSERT_SMS, UPDATE_STS, UPDATE_STS_ATU, UPDATE_MQL, INSERT_ATT_ORD_SMS |
| EasyAccess | C10B9991(SMS발송기준), C10B9990(SMS발송대상), C10B2250(수동확정대상) |

**처리 흐름**:
1. 에러코드 문자열을 ':'로 분리하여 각 에러코드별 중복 체크 후 INSERT_ERR
2. 재설계요청이 아닌 경우(re_qlt_dsn_tp != 'Y'):
   - C10B9991로 SMS 발송 기준 조회 (품명코드, 긴급재구분, 주문행번중량 조건)
   - 기준 존재 시 C10B9990로 SMS 수신자 조회 후 TB_M90_SMS INSERT
3. 품질설계 상태 결정:
   - 에러 있거나 기존에러('Y')인 경우: 'E' 상태 UPDATE_STS
     - 반품주문(ORD_NO 첫글자 'R')이면 예외적으로 자동확정 'A' 처리
   - 에러 없는 경우 복합 조건 판단:
     - QLT_DSN_CFM_TP='A' AND OMS수동(ORD_DSN_CFM_TP != 'A') → 강제 'B' 처리
     - QLT_DSN_CFM_TP='A' AND OMS자동('A') → C10B2250 수동확정대상 체크 → 해당 시 'B', 아니면 계속 'A'
     - 최종 'A'이면 UPDATE_STS_ATU (자동확정)
     - 최종 'B'이면 UPDATE_STS (확정대기), 관심주문 SMS 등록 (att_ord_yn='Y'인 경우)
   - 반품주문 또는 광신스틸 임가공(poc_auto_yn='Y'): 무조건 자동확정 'A' 처리

### 2.7 SetErrorcode(String ERR_CODE, String VALUE)

에러코드 문자열을 ':' 구분자로 누적하는 헬퍼 메소드.
첫 에러이면 VALUE만, 이미 있으면 `기존코드:VALUE` 형식으로 연결.

### 2.8 checkProc(PosRowSet rowset, String PROC_CD)

통과공정 목록에서 특정 공정코드가 MAIN_PROC_CD, SUB_PROC_CD1, SUB_PROC_CD2 중 하나에 존재하는지 확인.

### 2.9 chkMinMax(ArrayList\<String[]\> ROW, String ERRCODE)

MIN_MAX 리스트를 순회하며 하한/상한 비교. VALUE[3]이 TRUE이면 하한<=상한 체크(LLV <= ULV), 아니면 반대 방향 비교.

### 2.10 chkNull(ArrayList\<String[]\> ROW, String ERRCODE)

CHK_NULL 리스트를 순회하며 NULL(공백) 여부 체크하여 에러코드 누적.

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | CCL BOM Edge 체크 | CCL BOM 있고 재단선='Y', Edge구분='M'(Mill Edge), 최종고객사 != '320104' | CF84 에러 |
| 2 | 공통항목 필수값 | 재질코드/원자재코드/제조표준번호/통과공정번호 NULL | CF01~CF04 에러 |
| 3 | 매중량 필수 | ord_unt_wgt == 0 | CF82 에러 |
| 4 | 성분 보증사양 필수 | 보증성분 미설계 | CF06 에러 |
| 5 | 성분 상하한 역전 | 성분 하한 >= 상한 | CF0X3/CF0X4 에러 |
| 6 | 성분 규격 vs 보증 범위 | 보증하한 < 규격하한 또는 보증상한 > 규격상한 | CF0X1 에러 |
| 7 | 재질 보증사양 필수 | 보증재질 미설계 | CF66 에러 (즉시 반환) |
| 8 | 인수도 보증사양 필수 | 보증인수도 미설계 | CF67 에러 (즉시 반환) |
| 9 | 도금제품 설계값 필수 | GW_ASG_CD != 공백 | 도금 관련 CF11~CF24 |
| 10 | 소둔 사양 필수 | 통과공정에 소둔공정 포함 시 | CF36~CF63 |
| 11 | 칼라제품 CCL BOM 필수 | PRD_NM_CD 1~9 코드 | CF35 에러 |
| 12 | 반품주문 예외 처리 | ORD_NO 첫글자 'R' | 에러 있어도 자동확정('A') |
| 13 | 광신스틸 임가공 예외 | poc_auto_yn = 'Y' | 무조건 자동확정('A') |
| 14 | OMS 수동설계 강제 수동 | ORD_DSN_CFM_TP != 'A' | 품질설계 자동확정 불가, 강제 'B' |
| 15 | 수동확정대상 기준 체크 | C10B2250 EasyAccess 조회 매칭 시 | 자동확정 불가, 'B'로 변경 |
| 16 | 부산공장 예외 | fnl_cus_cd = '320104' | CF84 에러 제외 |

---

## 4. SQL 매핑

| SQL Key | 상수 | 용도 | 호출 메소드 |
|---------|------|------|------------|
| `C102100CHM.select` | SELECT_CHM | 품질설계결과 성분 조회 (구분코드: 1=고객, 2=규격, 4=보증) | CheckChem, CheckDeli(고객 재사용) |
| `C102100MQL.select` | SELECT_MQL | 품질설계결과 재질 조회 (구분코드: 1=고객, 2=규격, 4=보증) | CheckMech |
| `C102100DLV.select` | SELECT_DLV | 품질설계결과 인수도 조회 (구분코드: 1=고객, 2=규격, 4=보증) | CheckDeli |
| `C102100MNF.select` | SELECT_MNF | 품질설계결과 제조사양 조회 | CheckMnf |
| `C102100PROC.select` | SELECT_PROC | 품질설계결과 통과공정 조회 | CheckMnf |
| `C102100RMTL.select` | SELECT_RMT | 품질설계결과 원자재 조회 | CheckMnf |
| `C102100CCL_BOM.Aselect` | SELECT_MNF_CCL_BOM | 칼라 CCL BOM 조회 (재단선 여부 등) | runActivity, CheckMnf |
| `C103100040.insert` | INSERT_ERR | 품질설계 에러코드 등록 | ErrProc |
| `C103100140.select` | SELECT_ERR | 품질설계 에러코드 중복 조회 | ErrProc |
| `TB_M90.SMSinsert` | INSERT_SMS | SMS 발송 내역 등록 (TB_M90_SMS) | ErrProc |
| `C102100CMN.StsME_modify` | UPDATE_STS | 품질설계 상태 UPDATE ('B' 또는 'E') | ErrProc |
| `C102100CMN.StsA_modify` | UPDATE_STS_ATU | 품질설계 상태 자동확정 UPDATE ('A') | ErrProc |
| `C102100MQL.cs_update` | UPDATE_MQL | 보증사양 최종 수정 (광신스틸 임가공) | ErrProc |
| `C102100CMN.AttSms` | INSERT_ATT_ORD_SMS | 관심주문 SMS 등록 | ErrProc |

---

## 5. 참조 업무기준 (EasyAccess)

| 업무기준 ID | 조건항목 | 결과 | 용도 |
|-------------|----------|------|------|
| `C10B9991` | 품명코드, 긴급재구분, 주문행번중량 | 발송여부 등 | SMS 발송 기준 판단 |
| `C10B9990` | 품명코드 | SMS수신자명, 수신전화번호, 발송전화번호, 발송내역 | SMS 수신자 목록 조회 |
| `C10B2250` | 품명코드, 용도코드, 최종고객사, 주문행번중량, 주문특기사항 | 수동확정대상 여부 | 자동확정 제외 대상 판단 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 배치 프로세스의 핵심 검증 단계이다. OMS(영업관리시스템)에서 수신된 주문에 대해 품질팀이 설계를 완료하면, MES가 그 설계 결과물이 규격/고객/보증 사양 간의 논리적 정합성을 갖추고 있는지 자동으로 검증한다. 검증 후 에러 여부와 자동확정 조건에 따라 품질설계 상태를 E(에러)/B(확정대기)/A(자동확정)로 분기하여 다음 공정 진행 여부를 결정한다.

### 6.2 핵심 비즈니스 로직

**성분/재질/인수도 정합성 검증 패턴:**
- 3종류의 사양(규격=2, 고객=1, 보증=4)을 각각 조회
- 보증사양은 반드시 존재해야 하며(에러 시 즉시 반환), 규격사양 범위 안에 포함되어야 함
- 고객사양 존재 시 고객사양도 보증사양 범위 안에 있어야 함

**자동확정 결정 로직 (ErrProc):**
```
에러 없음?
├── No  → 'E' 상태 설정
│        └── 반품주문(R*)? → 예외: 자동확정 'A'
└── Yes → OMS수동(ORD_DSN_CFM_TP != 'A')?
          ├── Yes → 강제 'B' (수동 확정 대기)
          └── No  → C10B2250 수동확정대상?
                    ├── 해당 → 'B'
                    └── 미해당 → 'A' (자동확정) UPDATE_STS_ATU

예외: 반품주문(R*) → 무조건 'A'
예외: 광신스틸 임가공(poc_auto_yn='Y') → 무조건 'A'
```

**하드코딩된 비즈니스 값:**
- `"320104"`: 부산공장 일반용 최종고객사 코드 (CF84 Edge 에러 면제)
- `"R"`: 반품주문 주문번호 prefix (자동확정 강제 적용)
- `"Y"`: poc_auto_yn 광신스틸 임가공 여부

### 6.3 주의사항 및 제약조건

- `CheckMnf()`에서 PRD_NM_CD_5(후판?), PRD_NM_CD_7(열연?)은 제조사양 중요항목 체크 제외
- 소둔로 체크 로직(`CF36~CF43`)에서 조건식이 `&&`(AND)로 연결되어 있어 실제로는 절대 True가 될 수 없는 dead code 버그 존재 (예: `PRD_NM_CD.equals(PRD_NM_CD_C) && PRD_NM_CD.equals(PRD_NM_CD_E)`)
- 2013년에 목표두께 관련 로직(CF80) 및 일부 원자재폭 로직(CF33, CF34), 시편 관련 로직(M07X, M08X, M09X)이 주석 처리됨
- 2013년에 자동설계 조건 일부(C10B2270 주문등록자 체크)가 정보기획팀 요청으로 주석 처리됨
- 에러코드는 `:`로 연결된 문자열로 관리되며 ErrProc에서 `split(":")`로 분리 처리
- `chkMinMax` 호출이 `CheckMech`에서 중복 호출(2회)되는 코드 존재 (버그 가능성)
