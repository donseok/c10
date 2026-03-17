# DbSearchProcData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchProcData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 1426 라인 |
| 메소드 수 | 4개 (runActivity, DelProc, CclShlProc, InsProc, chgtmpass) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

품질설계 NUI(배치) 프로세스에서 통과공정을 편성하는 클래스이다. 주문 정보, 제품군, 칼라 제조사양 등을 기반으로 마스터 데이터(EasyAccess, DAO)를 조회하여 통과공정 순서 및 각 공정의 주공정/대체공정 코드를 결정하고, 품질설계결과 통과공정 테이블에 INSERT한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE 프레임워크 Activity. `runActivity(PosContext)`가 진입점.
- `C10NuiConstantsIF` 구현: 품명코드 상수, SQL 키 상수(INSERT_PROC, UPDATE_TMPASS 등), EasyAccess 정의명(C10B2010, C10B2050, C10B2240), View 명(VI_M00_C10A1054N, VI_M00_C10A1054_PROC_CHK, VI_M00_C10A2030 등), 에러코드 상수 제공.

### 1.2 핵심 입력/출력

**입력 (PosContext에서 추출 및 Property)**

| 컬럼키/Property | 변수명 | 설명 |
|----------------|--------|------|
| COL_PAS_PROC_NO | pas_proc_no | 통과공정번호 |
| COL_MTL_CD | mtl_cd | 재질코드 |
| COL_PRD_NM_CD | prd_nm_cd | 품명코드 |
| COL_PRD_SHP | prd_shp | 제품형태 |
| COL_ORD_NO / COL_ORD_LN | ord_no / ord_ln | 주문번호 / 주문라인 |
| COL_BAK_MRK | bak_mrk | 백마킹 여부 (앞 4자리 = "BACK" → "Y") |
| COL_ORD_COIL_IDIA | ord_coil_idia | 주문 코일 내경 |
| COL_ORD_SLV_KND_TP | ord_slv_knd_tp | 주문 내경링 종류구분 |
| COL_ORD_SUR_HND_CD | ord_sur_hnd_cd | 주문 표면처리코드 |
| COL_GW_ASG_CD | gw_asg_cd | 도금량지정코드 |
| COL_ORD_PAK_UNT_WGT_LLV | ord_pak_unt_wgt_llv | 주문포장단중하한값 |
| COL_ORD_COIL_ODIA | ord_coil_odia | 주문 코일 외경 |
| COL_EMBS_CD | embs_cd | EMBOSS 무늬 |
| COL_ORD_EXC_THK | ord_exc_thk | 주문 환산두께 |
| COL_ORD_EXC_WTH | ord_exc_wth | 주문 환산폭 |
| COL_ORD_EXC_LTH | ord_exc_lth | 주문 환산길이 |
| COL_ORD_SLIT_GRP_CNT | ord_slit_grp_cnt | SLIT 조수 |
| COL_ORD_MIX_WTH1~10 | ord_mix_wth1~10 | 혼합폭 1~10 |
| COL_ORD_EDG_ASG_TP | ord_edg_asg_tp | 주문 EDGE 지정구분 |
| COL_TRST_PROC_YN | trst_proc_yn | 위탁임가공 여부 |
| COL_MQL_CD | mql_cd | 재질추가코드 |
| COL_SPC_AVR | spc_avr | 규격약호 |
| COL_FNL_CUS_CD | fnl_cus_cd | 최종수요가코드 |
| COL_ORD_USG_CD | ord_usg_cd | 주문용도코드 |
| COL_CCL_BOM_NO | ccl_bom_no | CCL BOM 번호 |
| COL_ORD_COILG_MTH | ord_coilg_mth | 권취방법 |
| COL_ORD_SPNL_TP | ord_spnl_tp | 스팽글타입 |
| COL_KISS_CUT_YN | kiss_cut_yn | KISS CUTTING 여부 |
| Property: DAO | - | masterdao |

**출력**

- 품질설계결과 통과공정 테이블에 INSERT (INSERT_PROC SQL Key)
- PosContext의 COL_TM_PASS_CNT 갱신
- 품질설계 제조표준 TM Pass수 UPDATE (UPDATE_TMPASS SQL Key)

**반환값**

- `PosBizControlConstants.SUCCESS`: 정상 완료
- `PosBizControlConstants.FAILURE`: 에러 발생

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

**목적**: 통과공정 편성 전체 흐름 제어. 마스터 조회 → 공정 결정 → DB INSERT

**복잡도**: 매우 높음 (1229라인, EasyAccess 3종 + DAO 다수 조회, 중첩 while/if 구조)

**처리 흐름**

#### Step 1. PosContext 입력값 추출 (라인 201~278)

모든 컬럼을 `DbCommonUtil.isNull()`로 null 체크 후 지역변수에 할당.

BackMarking 처리:
```
ctx.get(COL_BAK_MRK).substring(0,4) = "BACK" → bak_mrk = "Y"
```

#### Step 2. 혼합폭(SLIT) 처리 (라인 280~302)

```
조건: ord_slit_grp_cnt > 0
mix_wth = min(ord_mix_wth1, ord_mix_wth2, ..., ord_mix_wth10)  [0 제외한 최솟값]
그 외: mix_wth = Double.parseDouble(ord_exc_wth)
```

```
조건: ord_slit_grp_cnt > 0
exc_wth = ord_mix_wth1 + ord_mix_wth2 + ... + ord_mix_wth10
그 외: exc_wth = ord_exc_wth
```

#### Step 3. 칼라제품 사전 처리 (라인 317~390)

조건: 품명코드 IN (1,2,3,4,5,6,7,8,9)

- VI_M00_C10A1054_PROC_CHK: 통과공정 기준 존재 확인
- SELECT_MNF_CCL_BOM: 칼라 제조사양 조회
  - 결과에서 추출: ccl_proc_cd(주공정), ccl_proc_cd1~3(대체공정1~3), cot_mth(도장방식), cut_ln_yn, lus_rt_cd_frn, rsn_tp_frn, ptt_flm_dtl_cd

#### Step 4. 통과공정삭제기준 조회 - EasyAccess C10B2010 (라인 407~479)

조건항목 23개: [품명코드, 백마킹, 내경, 내경링종류, 표면처리코드, 도금량지정코드, EMBOSS무늬, 포장단중하한, 코일외경, 두께, 폭, 수지타입전면, 광택코드전면, 보호필름상세코드, 재질코드, 주문EDGE, 길이, 제품형태, 권취방법, 최종수요가, 주문용도, 스팽글, SLIT조수]

결과: DEL_PROC ArrayList에 삭제 대상 공정코드 누적

MasterDataException: 로그만 출력, 에러 반환 없음

#### Step 5. 정전공정추가기준 조회 - EasyAccess C10B2050 (라인 481~533)

조건항목 9개: [품명코드, 제품형태, SLIT조수, 혼합폭최솟값(mix_wth), EDGE, 두께, 재단선유무, 위탁임가공, EMBOSS무늬]

결과: loc(공정 위치 앞/뒤), cor_proc_cd(주공정), cor_proc_cd1~3(대체공정), base_proc_cd(기준공정)

특수 처리: cor_proc_cd1 = "74" AND Double.parseDouble(exc_wth) > 1270 → cor_proc_cd1 = SPACE

MasterDataException: 로그만 출력

#### Step 6. TM 2PASS 기준 조회 - EasyAccess C10B2240 (라인 542~565)

조건항목 9개: [품명코드, 규격약호, 최종수요가, 주문용도, 표면처리코드, 광택코드전면, 두께, 폭, EMBOSS무늬]

결과: TM_PASS_CNT
- TM_PASS_CNT ≠ "1": tm_proc_cd = "51" (TM 2PASS 추가 플래그)

MasterDataException: 로그만 출력

#### Step 7. 통과공정기준 반복 조회 및 INSERT (라인 570~1179)

DAO 조회: VI_M00_C10A1054N (통과공정기준View)
- 조건: (pas_proc_no, base_proc_cd, pas_proc_no)
- 결과=0: 에러 ERRCD_KK23, FAILURE

while 루프로 각 통과공정 순서별 처리:

**7-1. 반제품 MaterialCode 조회 (라인 607~663)**

param = (mtl_cd, 공정코드 또는 첫자리)

조건: 칼라제품 AND main_proc_cd = "72" → SELECT_SEM_MTL1
조건: 칼라제품 AND main_proc_cd 첫자리 = "7" (72 제외) → SELECT_SEM_MTL3
그 외 → SELECT_SEM_MTL2

**7-2. 정전공정 기준공정 이전 추가 (라인 669~722)**

조건: main_proc_cd 첫자리 = base_proc_cd AND loc = "B" AND count = seq
- 정전공정 삽입: InsProc() 호출 (proc_seq를 기존 순서 + add_seq로 설정)
- add_seq 증가

**7-3. 칼라 제품 공정코드 반영 (라인 726~780)**

조건: 품명 IN (1~9) AND main_proc_cd 시작 = "A" AND 2번째 자리 = "X"
- main_proc_cd = ccl_proc_cd (칼라 제조사양 주공정)
- sub_proc_cd1~3 = ccl_proc_cd1~3
- 그 외: View 결과의 sub_proc_cd1~6 사용

**7-4. 통과공정삭제기준 적용 (라인 791~828)**

DEL_PROC 존재 시: DelProc() 메소드 호출
- 삭제 후 주공정 = SPACE: 에러 ERRCD_KK27, FAILURE

**7-5. 정전 6X 공정 처리 (라인 841~1022)**

조건: main_proc_cd 첫자리 = "6" AND 두번째 자리 = "X"
- SELECT_CCL_PROC: 이전 칼라공정 조회 (ord_no, ord_ln)
- CclShlProc()으로 각 공정코드를 SHL(정전) 공정코드로 변환

**7-6. 통과공정 INSERT (라인 1024~1048)**

InsProc() 호출: (ord_no, ord_ln, proc_seq, main_proc_cd, sub_proc_cd1~6, sem_prod_mtl_cd)

**7-7. TM 2PASS 추가 (라인 1050~1078)**

조건: main_proc_cd = "51"
- COL_TM_PASS_CNT = "1" (TM은 무조건 1PASS)
- tm_proc_cd = "51": InsProc() 추가 호출 (add_seq++)

**7-8. 칼라공정 2PASS 추가 (라인 1080~1123)**

조건: main_proc_cd 첫자리 = "A"
- (도장방식 A/B/C/D/E AND ccl_bom_no 첫자리 ≠ "V")
  OR (도장방식 6/7/8/9 AND main_proc_cd IN (A2, A3, A6))
  → InsProc() 추가 호출 (add_seq++)

**7-9. 정전공정 기준공정 이후 추가 (라인 1125~1177)**

조건: main_proc_cd 첫자리 = base_proc_cd AND loc = "A" AND count = seq
- 정전공정 삽입: InsProc() 호출

#### Step 8. TM Pass수 UPDATE (라인 1182~1194)

조건: 품명 IN (C, 1, E, 2, 8)
- chgtmpass() 호출 → UPDATE_TMPASS SQL 실행

#### Step 9. KISS CUTTING 공정 추가 (라인 1205~1226, 2024.10.10)

조건: kiss_cut_yn = "Y"
- InsProc()으로 PROC_CD_INS_SHL(6I 공정) 추가 INSERT

---

### 2.2 DelProc(ArrayList DEL_PROC, String MAIN_PROC, String SUB_PROC_CD1~6)

**목적**: 삭제 대상 공정코드 목록(DEL_PROC)을 기준으로 현재 공정 목록(7개: 주+대체1~6)에서 해당 공정을 제거하고 7개 고정 크기 ArrayList 반환.

**로직**:
1. DATA_PROC = [MAIN_PROC, SUB_PROC_CD1, ..., SUB_PROC_CD6]
2. 각 공정코드에 대해 DEL_PROC에 포함되지 않으면 RESULT_PROC에 추가
3. RESULT_PROC 크기 < 7이면 나머지를 SPACE로 채움

---

### 2.3 CclShlProc(String MAIN_PROC, PosContext ctx, PosGenericDao dao)

**목적**: 칼라 정전라인결정기준(VI_M00_C10A2030)을 조회하여 칼라 공정코드에 해당하는 SHL(정전) 공정코드를 반환.

**로직**:
- DAO 조회: VI_M00_C10A2030 (조건: MAIN_PROC)
- 결과=1: COL_PROC_CD_SHL 값 반환
- 결과>1: 에러 ERRCD_KT31, SPACE2 반환
- 결과=0 또는 예외: 에러 ERRCD_KT30, SPACE 반환

---

### 2.4 InsProc(PosGenericDao dao, PosContext ctx)

**목적**: 품질설계결과 통과공정 테이블에 1건 INSERT.

**파라미터 구성**:
- [0] COL_ORD_NO
- [1] COL_ORD_LN
- [2] COL_PROC_SEQ
- [3] COL_MAIN_PROC_CD
- [4] COL_SUB_PROC_CD1
- [5] COL_SUB_PROC_CD2
- [6] COL_SUB_PROC_CD3
- [7] COL_SUB_PROC_CD4
- [8] COL_SUB_PROC_CD5
- [9] COL_SUB_PROC_CD6
- [10] COL_SEM_PROD_MTL_CD
- AuditAttributes: ctx.getAuditAttribute()

SQL Key: INSERT_PROC

반환: true(성공) / false(예외 발생)

---

### 2.5 chgtmpass(PosGenericDao dao, PosContext ctx)

**목적**: 품질설계 제조표준의 TM Pass수를 UPDATE.

**파라미터 구성**:
- [0] COL_TM_PASS_CNT
- [1] COL_ORD_NO
- [2] COL_ORD_LN

SQL Key: UPDATE_TMPASS

반환: true(성공) / false(예외 발생)

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | BackMarking 판별 | COL_BAK_MRK.substring(0,4) = "BACK" | bak_mrk = "Y" |
| 2 | SLIT 최솟값 폭 | ord_slit_grp_cnt > 0 | mix_wth = min(MIX_WTH1~10, 0 제외) |
| 3 | SLIT 합산폭 | ord_slit_grp_cnt > 0 | exc_wth = MIX_WTH1+...+MIX_WTH10 |
| 4 | 칼라제품 사전 체크 | 품명 IN (1~9) | VI_M00_C10A1054_PROC_CHK 조회 후 칼라 제조사양 SELECT_MNF_CCL_BOM 조회 |
| 5 | 정전 74공정 폭 제한 | cor_proc_cd1="74" AND exc_wth > 1270 | cor_proc_cd1 = SPACE (74공정 제거) |
| 6 | TM 2PASS 판별 | C10B2240 결과 TM_PASS_CNT ≠ "1" | tm_proc_cd = "51" |
| 7 | 칼라제품 RCL 공정 매칭 | main_proc_cd = "72" | SELECT_SEM_MTL1 (공정코드 전체 비교) |
| 8 | 칼라제품 R/S 공정 매칭 | main_proc_cd 첫자리 = "7" (72 제외) | SELECT_SEM_MTL3 |
| 9 | 일반 공정 매칭 | 그 외 | SELECT_SEM_MTL2 (공정코드 첫자리 비교) |
| 10 | 칼라 AX 공정 대체 | 품명 1~9, main_proc_cd = "AX" 형식 | ccl_proc_cd/ccl_proc_cd1~3으로 대체 |
| 11 | 정전공정 이전 추가 | loc = "B" AND count = seq | InsProc() 호출 (기준공정 이전에 정전공정 삽입) |
| 12 | 정전공정 이후 추가 | loc = "A" AND count = seq | InsProc() 호출 (기준공정 이후에 정전공정 삽입) |
| 13 | 정전 6X 공정 처리 | main_proc_cd 첫자리 "6", 둘째 자리 "X" | SELECT_CCL_PROC로 이전 칼라공정 조회 후 CclShlProc()으로 SHL 공정 결정 |
| 14 | 칼라 2PASS (1-pass형) | main_proc_cd 첫자리 = "A", 도장방식 A/B/C/D/E, ccl_bom_no 첫자리 ≠ "V" | 동일 공정 1회 추가 INSERT |
| 15 | 칼라 2PASS (2-pass형) | 도장방식 6/7/8/9, main_proc_cd IN (A2, A3, A6) | 동일 공정 1회 추가 INSERT |
| 16 | TM 1PASS 고정 | main_proc_cd = "51" | TM_PASS_CNT = "1" 강제 설정 |
| 17 | TM 추가 PASS | main_proc_cd = "51" AND tm_proc_cd = "51" | InsProc() 추가 호출 |
| 18 | KISS CUTTING 공정 추가 | kiss_cut_yn = "Y" | PROC_CD_INS_SHL(6I) INSERT |
| 19 | TM Pass수 UPDATE 대상 | 품명 IN (C, 1, E, 2, 8) | chgtmpass() 호출 |
| 20 | 삭제공정 주공정 공백 | DEL_PROC 적용 후 main_proc_cd = SPACE | 에러 ERRCD_KK27, FAILURE |

---

## 4. SQL 매핑

| SQL Key / View | 용도 | 호출 시점 |
|----------------|------|-----------|
| VI_M00_C10A1054_PROC_CHK | 통과공정기준 존재 확인 | 칼라제품(1~9) 사전 체크 |
| SELECT_MNF_CCL_BOM | 칼라 제조사양 조회 (주공정, 대체공정1~3, 도장방식 등) | 칼라제품(1~9) 사전 처리 |
| VI_M00_C10A1054N | 통과공정기준View (통과공정순서, 주공정, 대체공정) | 메인 while 루프 진입 시 |
| SELECT_SEM_MTL1 | 반제품 MaterialCode 조회 (RCL 72공정 전용) | while 루프 내 main_proc_cd = "72" |
| SELECT_SEM_MTL2 | 반제품 MaterialCode 조회 (첫자리 비교) | while 루프 내 일반 공정 |
| SELECT_SEM_MTL3 | 반제품 MaterialCode 조회 (7X 공정, 72 제외) | while 루프 내 7X 공정 |
| SELECT_CCL_PROC | 이전 칼라공정 조회 | main_proc_cd = "6X" 처리 시 |
| VI_M00_C10A2030 | 칼라정전라인결정기준View (SHL 공정코드 조회) | CclShlProc() 내부 |
| INSERT_PROC | 품질설계결과 통과공정 INSERT | InsProc() 내부 |
| UPDATE_TMPASS | 품질설계 제조표준 TM Pass수 UPDATE | chgtmpass() 내부 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

수주 품질설계 자동화 배치에서, 주문 사양을 기반으로 생산 통과공정을 자동 결정한다. 단순한 공정 코드 조회가 아니라, 공정 삭제, 정전공정 삽입, 칼라 공정 대체, 2PASS 처리, KISS CUTTING 추가까지 복합적인 공정 편성 로직을 수행한다.

### 6.2 공정 편성 단계

1. **통과공정삭제기준(C10B2010) 조회**: 주문 조건에 따라 삭제할 공정코드 목록 수집
2. **정전공정추가기준(C10B2050) 조회**: 어떤 공정 앞/뒤에 정전공정을 삽입할지 결정
3. **TM 2PASS기준(C10B2240) 조회**: TM 공정을 2PASS로 실행할지 결정
4. **통과공정기준(VI_M00_C10A1054N) 반복 조회**: 공정 순서대로 while 루프
5. 각 공정에 대해: 반제품 Material Code 조회 → 칼라 AX 공정 대체 → 삭제공정 적용 → 6X 정전 처리 → INSERT
6. TM 2PASS, 칼라 2PASS 조건 충족 시 동일 공정 추가 INSERT
7. KISS CUTTING 공정 최후 삽입
8. TM Pass수 UPDATE

### 6.3 공정코드 체계

- 공정코드 첫 자리 "A": 칼라 공정 (A1~A9 등)
- 공정코드 "51": TM (탠덤밀)
- 공정코드 "72": RCL (롤코팅라인)
- 공정코드 첫 자리 "6": 정전 공정 (6X: 칼라정전라인결정기준 적용)
- 공정코드 "6I": KISS CUTTING 삽입 공정 (PROC_CD_INS_SHL)
- 공정코드 첫 자리 "7": R/S 계열 공정

### 6.4 변경 이력 주요 사항

- 2014.08.11: 주문길이(ord_exc_lth) C10B2010 조건 추가
- 2014.11.05: 74공정 폭 1270mm 초과 시 제거 규칙 추가
- 2016.03.24: 제품형태(prd_shp) 조건 추가
- 2016.04.14: 권취방법(ord_coilg_mth) 조건 추가
- 2017.07.17: 최종수요가(fnl_cus_cd), 주문용도(ord_usg_cd) 조건 추가
- 2018.06.20: TM 공정 1PASS 강제화
- 2020.04.17: 스팽글(ord_spnl_tp) 조건 추가
- 2022.12.27: SLIT 조수(ord_slit_grp_cnt) 조건 추가
- 2024.10.10: KISS CUTTING(kiss_cut_yn) 6I 공정 추가
