# DbSearchMtlData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchMtlData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | 105 라인 |
| 메소드 수 | 1개 (runActivity) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

Material Code 수신 데이터에 대해 품질설계사양구분(`prodSpecKind`)에 따라 필수항목을 검증하는 클래스이다.
DB 조회 없이 PosContext에서 값을 읽어 필수항목 null 여부만 체크한 뒤 성공/실패를 반환하는 순수 유효성 검증 Activity이다.
대상 테이블은 `TB_C10_B10R0050` (Material Code 수신 테이블)이다.

### 1.1 상속/구현 관계

- `extends PosActivity` : GLUE 프레임워크 Activity 기반 클래스
- `implements C10NuiConstantsIF` : NUI 상수 인터페이스

### 1.2 핵심 입력/출력

**입력 (Service Property)**

| Property 명 | 의미 |
|-------------|------|
| C10PN_PROSPECKIND (prodSpecKind) | 품질설계사양구분 ("1": Material Code, "2": Semi Material Code) |

**입력 (PosContext에서 검증)**

품질설계사양구분이 "1" (Material Code)인 경우:

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_MTL_CD | Material Code |
| COL_MAT_TYPE | 소재유형 |
| COL_PRD_NM_CD | 품명코드 |
| COL_PRD_SHP | 제품형태 |
| COL_MQL_CD | 재질코드 |
| COL_CUS_REQ_ROL_THK | 고객요구압연두께 |
| COL_ORD_EXC_WTH | 주문폭 |
| COL_ORD_PAK_MTH | 포장방법 |

품질설계사양구분이 "2" (Semi Material Code)인 경우:

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_PLNT_TP | 공장구분 |
| COL_MTL_CD | Material Code |
| COL_PROC_SEQ | 공정순서 |
| COL_PROC_CD | 공정코드 |
| COL_SEM_PROD_MTL_CD | 반제품 Material Code |

**출력 (PosContext에 저장)**

| 컬럼명 상수 | 비즈니스 의미 |
|-------------|---------------|
| COL_QLT_DSN_SPC_TP | 품질설계사양구분 (prodSpecKind 값) |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | Material Code 수신 데이터의 필수항목 유효성 검증 |
| 반환 타입 | String |
| 반환값 | PosBizControlConstants.SUCCESS / PosBizControlConstants.FAILURE |
| 복잡도 | 낮음 |

**처리 흐름**

1. Service Property에서 `C10PN_PROSPECKIND` 읽어 trim 후 `prodSpecKind` 변수에 저장
2. `COL_QLT_DSN_SPC_TP`로 ctx에 저장
3. `prodSpecKind.equals(NUM1)` ("1") 이면 Material Code 필수항목 검증:
   - `COL_MTL_CD`, `COL_MAT_TYPE`, `COL_PRD_NM_CD`, `COL_PRD_SHP`, `COL_MQL_CD`, `COL_CUS_REQ_ROL_THK`, `COL_ORD_EXC_WTH`, `COL_ORD_PAK_MTH` 중 하나라도 null/empty이면 에러로그 출력 후 FAILURE 반환
4. `prodSpecKind.equals(NUM2)` ("2") 이면 Semi Material Code 필수항목 검증:
   - `COL_PLNT_TP`, `COL_MTL_CD`, `COL_PROC_SEQ`, `COL_PROC_CD`, `COL_SEM_PROD_MTL_CD` 중 하나라도 null/empty이면 에러로그 출력 후 FAILURE 반환
5. 검증 통과 시 SUCCESS 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| R01 | Material Code 필수항목 검증 | prodSpecKind = "1" AND 8개 필수항목 중 하나라도 null | FAILURE 반환, 에러로그 ERRMSG_CF74 |
| R02 | Semi Material Code 필수항목 검증 | prodSpecKind = "2" AND 5개 필수항목 중 하나라도 null | FAILURE 반환, 에러로그 ERRMSG_CF74 |
| R03 | prodSpecKind 미대응 | "1"도 "2"도 아닌 경우 | 검증 없이 SUCCESS 반환 |

---

## 4. SQL 매핑

SQL 조회 없음. 순수 유효성 검증 클래스.

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

EAI(`eaidao`)를 통해 외부 시스템에서 수신된 Material Code 데이터(`TB_C10_B10R0050`)에 대해 품질설계 처리를 수행하기 전 필수항목이 모두 존재하는지 검증하는 Gate Keeper 역할의 Activity이다.

`prodSpecKind = "1"`은 완성 제품의 Material Code를 의미하며, 8개의 핵심 주문/제품 속성을 필수로 요구한다.
`prodSpecKind = "2"`는 반제품(Semi Product) Material Code를 의미하며, 공장/공정/반제품 Material Code 5개 항목을 필수로 요구한다.

에러코드(`COL_QLT_DSN_ERR_CD`, `C10STR_P_ERR_KEY`) 설정 코드는 주석 처리되어 있으며 현재는 에러로그 출력과 FAILURE 반환만 수행한다.

DB 조회나 EasyAccess 규칙 호출 없이 PosContext 값만 검증하는 최단순 구조의 Activity이다.
