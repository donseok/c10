# C10UiC106000050SendActivity 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/ui/C10UiC106000050SendActivity.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.ui` |
| 상위 클래스 | `DhtmlxActivity` (직접 상속, C10DhtmlxActivity가 아님) |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 412 라인 |
| 메소드 수 | 5개 (`doMainActivity`, `doPostActivity`, `doPreActivity`, `getDefaultMsgCode`, `getDefaultMsgParam`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

칼라 부자재(색상 소재) 정보 및 도료사 정보를 MM(자재관리 시스템) 및 FMES로 인터페이스 전송하는 액티비티이다(C106000050). 다건 처리를 지원하며, 선택된 각 항목에 대해 전송일시 업데이트 → MES 조회 → EAI INSERT → (조건부) FMES INSERT → (조건부) MOD_YN 업데이트 순으로 처리한다. 내수/수입 구분 플래그(`ZFLAG`)에 따라 SAP/FMES 전송값을 동적으로 결정하는 비즈니스 로직을 포함한다. 2012년 최초 생성 후 2022년, 2024년, 2025년에 걸쳐 항목이 추가되었다.

### 1.1 상속/구현 관계

`DhtmlxActivity`를 직접 상속한다(C10DhtmlxActivity가 아닌 poscoict 패키지의 `DhtmlxActivity`). 따라서 C10 공통 기능을 사용하지 않고 프레임워크 기본 기능만 사용한다.

**DhtmlxActivity 생명주기**:
- `doPreActivity(PosContext arg0)`: null 반환 (미구현)
- `doMainActivity(PosContext ctx)`: 전송 핵심 로직 구현
- `doPostActivity(PosContext arg0)`: null 반환 (미구현)

### 1.2 핵심 입력/출력

**입력 (PosContext)**
- `IDS`: 처리 대상 ID 배열 (다건, 콤마 구분)
- `{idsValue[i]}_SUB_MTL_TP`: 부자재 유형 (S40=생산Lamina, S49=생산UGS필름 시 FMES 전송)
- `{idsValue[i]}_CLR_SUB_MTL_CD`: 칼라 부자재 코드 (검색/업데이트 키)
- `{idsValue[i]}_CLR_NM`: 칼라명
- `{idsValue[i]}_RSN_TP`, `RSN_TP_NM`: 사유 유형
- `{idsValue[i]}_LUS_RT_CD`, `LUS_RT_NM`: 광택 비율 코드
- `{idsValue[i]}_PRT_INK_TP`, `PRT_INK_TP_NM`: 프린트 잉크 유형
- `{idsValue[i]}_PTT_FLM_MQL_CD`, `_NM`: 보호필름 소재 코드
- `{idsValue[i]}_PTT_FLM_THK_CD`, `_NM`: 보호필름 두께 코드
- `{idsValue[i]}_PTT_FLM_SUS_ADH_CD`, `_NM`: 보호필름 서스 점착력 코드
- `{idsValue[i]}_PTT_FLM_PRD_ADH_CD`, `_NM`: 보호필름 제품 점착력 코드
- `{idsValue[i]}_MOD_YN`: 수정여부 ('M'이면 MOD_YN 업데이트)
- `{idsValue[i]}_RSN_TP_QT`, `_QT_NM`: 사유 유형 품질 (2022.10.5 추가)
- `{idsValue[i]}_PAT_CD`, `_CD_NM`: 패턴 코드 (2022.10.5 추가)
- `{idsValue[i]}_FUNC_CD`, `_CD_NM`: 기능 코드 (2022.10.5 추가)
- `{idsValue[i]}_TTE_CD`, `_CD_NM`: 텍스처 코드 (2022.10.5 추가)
- `{idsValue[i]}_USE_POS_CD`, `_CD_NM`: 사용 위치 코드 (2022.10.5 추가)
- `{idsValue[i]}_WTY_YN`, `_YN_NM`: 보증 여부 (2022.10.5 추가)
- `{idsValue[i]}_RSN_TP_QT_BR`, `_BR_NM`: 사유 유형 품질 브랜드 (2022.12.12 추가)
- `{idsValue[i]}_PCM_SPEC_FILE1`: PCM 스펙 파일 (2022.12.12 추가)
- `{idsValue[i]}_COST_STM_FILE1`: 원가 견적 파일 (2022.12.12 추가)
- `{idsValue[i]}_LAST_UPDATED_OBJECT_ID`: 최종 수정자 ID
- `{idsValue[i]}_PNT_FLM_THK`: 도막 두께 (2024.04.26 추가)
- `{idsValue[i]}_LMN_KND_TP`: Lamina 종류 유형 (2024.04.26 추가)
- `{idsValue[i]}_ZFLAG`: 내수/수입 구분 (2025.07.18 추가, '2'=수입보세)
- `COL_IF_GRP_ID`: EAI 인터페이스 그룹 ID

**출력 (PosContext)**
- `ERRMSG`: 오류 메시지 (rowset 0건 시)

**반환값**: `SUCCESS` 또는 `FAILURE` (rowset 0건 시), PosException (예외 시)

---

## 2. 메소드 상세 분석

### 2.1 `doMainActivity(PosContext ctx)`

**목적**: 칼라 부자재 정보를 EAI(MM 인터페이스) 및 FMES(특정 부자재 유형 시)로 전송하는 다건 처리를 수행한다.

**복잡도**: 높음 (다중 루프, 다중 DB, 조건 분기, 외부 시스템 2개)

**처리 흐름**:

1. `mesdao`(MESAPUSER), `eaidao`(EAIAPUSER) DAO 취득
2. `IDS` null/빈값 체크 → 없으면 PosException("IDS가 존재하지 않습니다.") 발생
3. `idsValue` 배열 순회 (i = 0 ~ n-1):
   a. 해당 행의 모든 필드 ctx에서 추출 (30여 개 String[] 변수)
   b. `CLR_SUB_MTL_CD`로 `C106000050_erp_snd_update` 실행 (전송일시 업데이트)
   c. `C106000050_SELECT`로 MES 칼라 부자재 마스터 조회 (`rowset`)
   d. `IFB10S0150_CHECK`로 FMES 기존 전송 여부 조회 (`sendRowset`)
   e. `rowset.count() == 0`이면 `C106000050_CHECK_ERR` 메시지 저장 후 `FAILURE` 반환
   f. rowset 내부 루프 (j = 0 ~ rowset.count()-1):
      - PosRow에서 `USE_YN`, `PNT_CMP_CD`, `PNT_CMP_NM` 추출
      - `PosAuditAttributes`로 감사속성 취득
      - PosParameter에 30여 개 필드 설정
      - `ZFLAG[i]`가 `"2"` 이면 ZFLAG="X" 설정, 그 외 ZFLAG="" 설정 (내수/수입 구분)
      - `IFB10S0130_INSERT` 실행 (EAI → MM 인터페이스 삽입)
      - `SUB_MTL_TP[i]`가 `"S40"` 또는 `"S49"`이면 FMES I/F 처리:
        - `sendRowset.count() == 0` → XCRUD="C"(신규), PNT_FLM_THK 유지
        - `sendRowset.count() != 0` → XCRUD="U"(수정), PNT_FLM_THK=""(공백)
        - `IFB10S0150_INSERT` 실행 (EAI → FMES 인터페이스 삽입)
   g. rowset 루프 종료 후: `MOD_YN[i]`가 `"M"` 이면 `C106000050.updateModYn` 실행
4. 외부 루프 완료 후 TX1, TX2 커밋
5. `SUCCESS` 반환

**핵심 비즈니스 조건**:
- `ZFLAG = "2"` (수입/보세공장): SAP 전송 시 ZFLAG="X" 설정
- `ZFLAG != "2"` (내수): SAP 전송 시 ZFLAG="" 설정
- `SUB_MTL_TP = "S40"` 또는 `"S49"`: FMES 추가 전송
- `sendRowset.count() == 0`: FMES 신규 전송 (XCRUD="C")
- `sendRowset.count() != 0`: FMES 수정 전송 (XCRUD="U"), PNT_FLM_THK 공백 처리
- `MOD_YN = "M"`: 전송 완료 후 MOD_YN 플래그 업데이트

**예외 처리**:
- IDS 없음: PosException 직접 발생
- 루프 내 Exception: `System.out.println(e.getMessage())`, `logger.logDebug(e.getMessage())` 후 `PosException(CLR_SUB_MTL_CD[idx] + " : 처리중에 오류가 발생했습니다")` 재발생 (idx=0 고정이므로 첫 번째 처리 항목 코드가 항상 표시됨)

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-1 | IDS 필수 | IDS == null OR length < 1 | PosException 발생 |
| BR-2 | 전송일시 선행 업데이트 | 각 항목 처리 전 | C106000050_erp_snd_update 실행 |
| BR-3 | MES 마스터 존재 검증 | rowset.count() == 0 | C106000050_CHECK_ERR 메시지, FAILURE |
| BR-4 | 수입/보세공장 구분 | ZFLAG[i] == "2" | SAP 전송 파라미터 ZFLAG="X" 설정 |
| BR-5 | 내수 구분 | ZFLAG[i] != "2" | SAP 전송 파라미터 ZFLAG="" 설정 |
| BR-6 | MM 인터페이스 항상 전송 | rowset 내 각 행 | IFB10S0130_INSERT 실행 |
| BR-7 | FMES 전송 조건 | SUB_MTL_TP == "S40" OR "S49" | IFB10S0150_INSERT 추가 실행 |
| BR-8 | FMES 신규/수정 판별 | sendRowset.count() == 0 → XCRUD="C", != 0 → XCRUD="U" | FMES I/F 레코드 생성/수정 구분 |
| BR-9 | FMES 수정 시 두께 공백 | XCRUD="U" | PNT_FLM_THK="" 설정 |
| BR-10 | 수정 완료 플래그 업데이트 | MOD_YN[i] == "M" | C106000050.updateModYn 실행 |
| BR-11 | 감사속성 직접 취득 | PosAuditAttributes 사용 | LAST_UPDATED_OBJECT_ID, LAST_UPDATE_PROGRAM_ID, LAST_UPDATED_OBJECT_TYPE |

---

## 4. SQL 매핑

| SQL Key 상수 | 용도 | 호출 시점 | DAO |
|--------------|------|-----------|-----|
| `C106000050_erp_snd_update` | 전송일시 업데이트 | 각 항목 처리 시작 시 | mesdao |
| `C106000050_SELECT` | 칼라 부자재 마스터 조회 (USE_YN, PNT_CMP_CD, PNT_CMP_NM) | 전송일시 업데이트 후 | mesdao |
| `IFB10S0150_CHECK` | FMES 기존 전송 여부 조회 | 마스터 조회와 함께 | mesdao |
| `IFB10S0130_INSERT` | EAI → MM 인터페이스 삽입 | rowset 내부 루프, 항상 | eaidao |
| `IFB10S0150_INSERT` | EAI → FMES 인터페이스 삽입 | SUB_MTL_TP가 S40 또는 S49 시 | eaidao |
| `C106000050.updateModYn` | 수정여부 플래그 업데이트 | MOD_YN=="M" 시 | mesdao |

---

## 5. Route Transition

| 반환값 | 조건 | 비고 |
|--------|------|------|
| `SUCCESS` | 모든 항목 처리 완료, TX1/TX2 커밋 | 정상 경로 |
| `FAILURE` | MES 마스터 조회 결과 0건 | C106000050_CHECK_ERR 메시지 설정 |
| PosException | IDS 없음 또는 Exception 발생 | 프레임워크에서 failure 처리 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

C106000050 화면에서 사용자가 칼라 부자재(색상 소재) 정보를 확정하여 MM(자재관리) 시스템으로 전송하는 기능이다. 2012년 기본 기능 생성 후 2022년 인터페이스 항목 추가, 2024년 FMES 연동, 2025년 내수/수입 구분 처리가 순차적으로 추가된 이력이 있다.

### 6.2 이중 인터페이스 전송 구조

모든 부자재는 EAI(`IFB10S0130_INSERT`)를 통해 MM으로 전송되며, `SUB_MTL_TP`가 `S40`(생산Lamina) 또는 `S49`(생산UGS필름)인 경우에만 FMES(`IFB10S0150_INSERT`)로 추가 전송된다. FMES는 신규/수정 여부를 `XCRUD` 파라미터로 구분하며, 수정 시에는 `PNT_FLM_THK`(도막 두께)를 공백으로 처리하는 특이 로직이 있다.

### 6.3 내수/수입 구분 (ZFLAG)

2025년 7월 추가된 로직으로, 보세공장(수입) 처리 시 SAP에 전달되는 ZFLAG 값을 `"X"`로 설정하고, 내수 시 `""`(공백)으로 설정한다. SAP의 내수/수입 구분 필드에 매핑되는 것으로 추정된다.

### 6.4 코드 특이사항

- `idx = 0` 변수가 선언되었으나 루프 내에서 업데이트되지 않아, 예외 발생 시 오류 메시지에 항상 첫 번째 항목 코드(`CLR_SUB_MTL_CD[0]`)가 표시된다.
- `LAST_UPDATED_OBJECT_ID`가 ctx에서 가져온 값으로 먼저 설정된 후 `audit.getObjectId()`로 덮어씌워진다 (주석: "Audit 값이 안들어가서 임의로 추가해봄").
- `dmlCnt` 변수는 update 결과를 받으나 이후 활용되지 않는다.
- `param` 객체가 rowset 루프 진입 시 재생성(`param = new PosParameter()`)되어, 루프 밖에서 설정한 `CLR_SUB_MTL_CD` 파라미터가 rowset 루프에서는 다시 설정된다.

### 6.5 트랜잭션 구조

TX1은 mesdao(MESAPUSER), TX2는 eaidao(EAIAPUSER) 트랜잭션. 전체 다건 처리 완료 후 일괄 커밋하며, 중간 오류 시 PosException을 통해 프레임워크가 롤백을 처리한다. rowset 0건인 경우 `FAILURE`를 반환하므로 커밋이 이루어지지 않는다.
