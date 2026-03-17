# DbSearchChemData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchChemData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `534` 라인 |
| 메소드 수 | `1`개 (`runActivity`) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

`DbSearchChemData`는 철강 제품의 **성분사양(Chemical Composition Specification)을 편성**하는 NUI(Network UI) 액티비티 클래스이다. 품질설계 프로세스에서 주문에 대한 성분 규격값(하한/상한)을 고객사양, 규격사양, 사내사양, 보증사양의 4가지 유형별로 조회·편성하여 PosContext에 저장한다.

### 1.1 상속/구현 관계

- `PosActivity` 상속: GLUE Framework의 기본 액티비티 추상 클래스. `runActivity(PosContext)` 메소드 구현 필수
- `C10NuiConstantsIF` 구현: C10 모듈 NUI 전용 상수 인터페이스 (에러코드, 컬럼명, SQL 키, EasyAccess ID 등)

### 1.2 핵심 입력/출력

| 구분 | 항목 |
|------|------|
| 서비스 Property 입력 | `prodSpecKind` (1=고객, 2=규격, 3=사내, 4=보증), `dao` (DAO 빈 ID) |
| Context 공통 입력 | `ORD_NO` (주문번호), `ORD_LN` (주문행번) |
| 고객사양(1) 추가 입력 | `CUS_BTH_PAP_NO` (고객사양번호) |
| 규격사양(2) 추가 입력 | `SPC_AVR` (규격약호), `SPC_YR` (규격년도), `ORD_EXC_THK` (주문환산두께) |
| 사내사양(3) 추가 입력 | `PRD_NM_CD` (품명코드), `MQL_CD` (재질코드), `ORD_EXC_THK` |
| 출력 (Context 저장) | 13종 원소별 하한값(`_LLV`), 상한값(`_ULV`), `QLT_DSN_SPC_TP` (품질설계사양구분) |
| Route Transition | `success` (정상), `failure` (오류/에러), `false` (데이터 없음, 고객사양만) |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

| 항목 | 내용 |
|------|------|
| 목적 | 품질설계사양구분(prodSpecKind)에 따라 해당 성분사양을 조회·편성하여 PosContext에 저장 |
| 복잡도 | **높음** |
| 반환 타입 | `String` (transition 키: "SUCCESS", "FAILURE", "FALSE") |

**처리 흐름**:

1. 서비스 Property에서 `prodSpecKind` 읽기 → `QLT_DSN_SPC_TP`로 ctx에 즉시 저장
2. 서비스 Property `dao` 로 DAO 빈 획득
3. `prodSpecKind` 값에 따라 4개 분기 실행:

   **분기 1: 고객성분사양 (prodSpecKind = "1")**
   - 입력 파라미터 Null 검증: `ORD_NO`, `ORD_LN`, `CUS_BTH_PAP_NO`
   - `VI_M00_C10A1021` 뷰(m00apuser 스키마)에서 고객사양번호로 성분사양 조회
   - 결과 1건: 모든 컬럼을 동적으로 ctx에 등록
   - 결과 0건: "FALSE" 반환 (에러 아님, 단순 미존재)
   - 결과 2건 이상: 에러코드 KC11 설정 후 "FAILURE" 반환

   **분기 2: 규격성분사양 (prodSpecKind = "2")**
   - 입력 파라미터 Null 검증: `ORD_NO`, `ORD_LN`, `SPC_AVR`, `SPC_YR`, `ORD_EXC_THK`
   - `EasyAccess.getPosDecisionChecker(C10B1011)` 호출 → 규격성분 판단기준 조회
   - `checker.getPosRule(colValue[규격약호, 규격년도, 주문환산두께])` 로 규격 매칭
   - 결과 1건: `itemNameRow` Iterator 순회하여 ctx에 등록
   - 결과 0건/2건 이상: 에러코드 KS02/KS12 설정 후 "FAILURE" 반환

   **분기 3: 사내성분사양 (prodSpecKind = "3")**
   - 입력 파라미터 Null 검증: `ORD_NO`, `ORD_LN`, `PRD_NM_CD`, `MQL_CD`, `ORD_EXC_THK`
   - `EasyAccess.getPosDecisionChecker(C10B1031)` 호출 → 사내성분 판단기준 조회
   - `checker.getPosRule(colValue[품명코드, 재질코드, 주문환산두께])` 로 사내사양 매칭
   - 결과 1건: `itemNameRow` Iterator 순회하여 ctx에 등록
   - 결과 0건: 에러코드 KN01, "FAILURE"
   - 결과 2건 이상: 에러코드 KN11, "FAILURE"

   **분기 4: 보증성분사양 (prodSpecKind = "4")**
   - 입력 파라미터 Null 검증: `ORD_NO`, `ORD_LN` 만 검증
   - **고객사양(QLT_DSN_SPC_TP='1') 조회**: `SELECT_CHM`(C102100CHM.select) → ctx에 적재 (없어도 계속 진행)
   - **규격사양(QLT_DSN_SPC_TP='2') 조회**: `SELECT_CHM` → 규격사양 필수. 없으면 에러코드 KS22, "FAILURE"
   - 규격사양 결과로 13종 원소 하한값(`_LLV`): `numCompare(기존ctx값, 규격값, true)` → **큰값** 적용
   - 규격사양 결과로 13종 원소 상한값(`_ULV`): `numCompare(기존ctx값, 규격값, false)` → **작은값(0/NULL 제외)** 적용
   - **사내사양(QLT_DSN_SPC_TP='3') 조회**: `SELECT_CHM` → 사내사양 있으면 동일하게 하한=큰값, 상한=작은값 적용
   - 사내사양 없어도 에러 처리 없이 계속 진행

4. 모든 분기 정상 완료 시 "SUCCESS" 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| R-01 | 고객사양 단건 강제 | 고객사양번호로 조회 시 2건 이상 | ERRCD_KC11, FAILURE |
| R-02 | 고객사양 미존재 허용 | 고객사양번호로 조회 시 0건 | FALSE (에러 아님) |
| R-03 | 규격사양 존재 필수 | 보증사양 편성 시 규격사양 없으면 | ERRCD_KS22, FAILURE |
| R-04 | 보증 하한값 = 최대값 | 고객/규격/사내 하한값 중 | 가장 높은 값 적용 (numCompare true) |
| R-05 | 보증 상한값 = 최소값 | 고객/규격/사내 상한값 중 | 가장 낮은 값 적용, 단 NULL/0 제외 (numCompare false) |
| R-06 | 사내사양 선택적 | 보증사양 편성 시 사내사양 없으면 | 에러 없이 계속 진행 |
| R-07 | 규격사양 단건 강제 | EasyAccess C10B1011 조회 2건 이상 | ERRCD_KS12, FAILURE |
| R-08 | 사내사양 단건 강제 | EasyAccess C10B1031 조회 2건 이상 | ERRCD_KN11, FAILURE |
| R-09 | 사내사양 미존재 오류 | EasyAccess C10B1031 조회 0건 | ERRCD_KN01, FAILURE |

---

## 4. SQL 매핑

| SQL Key | 상수명 | 용도 | 호출 시점 |
|---------|--------|------|-----------|
| `C10A1021` | `VI_M00_C10A1021` | 고객성분 뷰 조회 (m00apuser 스키마) | prodSpecKind=1 고객성분사양 조회 |
| `C102100CHM.select` | `SELECT_CHM` | TB_C10_QLT_DSN_CHM 성분사양 조회 | prodSpecKind=4 보증사양 편성 시 3회 호출 (고객/규격/사내 구분별) |

---

## 5. 참조 업무기준 (EasyAccess)

| 업무기준 ID | 상수명 | 조건 | 결과 | 용도 |
|-------------|--------|------|------|------|
| `C10B1011` | `C10B1011` | 규격약호, 규격년도, 주문환산두께 | 규격성분사양 (13종 원소 하한/상한) | prodSpecKind=2 규격성분사양 편성 |
| `C10B1031` | `C10B1031` | 품명코드, 재질코드, 주문환산두께 | 사내성분사양 (13종 원소 하한/상한) | prodSpecKind=3 사내성분사양 편성 |

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

본 클래스는 동국제강 품질설계 NUI 배치 프로세스에서 **성분사양 편성** 단계를 담당한다. 철강 제품 주문 처리 시 해당 주문의 성분 규격(C, Si, Mn, P, S, Cr, Ni, Cu, Al, Ti, Nb, V, N의 13개 원소에 대한 하한/상한값)을 4가지 사양 유형별로 결정하는 업무이다. 하나의 클래스가 `prodSpecKind` Property 하나로 4가지 역할을 수행하는 재사용 설계를 채택하고 있다.

### 6.2 핵심 비즈니스 로직

**보증성분사양 편성 알고리즘** (prodSpecKind=4)이 핵심이다:

```
보증 하한값 = MAX(고객 하한값, 규격 하한값, 사내 하한값)   // 가장 엄격한 최소 기준
보증 상한값 = MIN(고객 상한값, 규격 상한값, 사내 상한값)   // 가장 엄격한 최대 기준
단, NULL 또는 0인 값은 비교에서 제외
```

이는 고객, 규격, 사내 사양 모두를 만족하는 최소 허용 범위를 계산하는 로직으로, 보증사양은 세 사양 중 가장 좁은 범위가 된다.

**조회 우선순위**: 규격사양 필수, 고객사양/사내사양 선택. 규격사양이 없으면 보증사양 편성 불가(에러).

### 6.3 업무기준(EasyAccess) 참조

- `C10B1011`: 규격약호+규격년도+주문환산두께 조합으로 KS/JIS 등 표준 규격의 성분 범위 결정
- `C10B1031`: 품명코드+재질코드+주문환산두께 조합으로 사내 내부 기준의 성분 범위 결정
- 두 기준 모두 GLUE EasyAccess `PosDecisionChecker`를 통해 판단기준 데이터 조회

### 6.4 타 시스템 연동

| 시스템 | 연동 방식 | 설명 |
|--------|-----------|------|
| M00APUSER(마스터 DB) | `masterdao`를 통한 뷰 조회 | `VI_M00_C10A1021` 고객성분사양 뷰 |
| MESAPUSER(MES DB) | `mesdao`를 통한 테이블 조회 | `TB_C10_QLT_DSN_CHM` 품질설계결과성분 |
| GLUE EasyAccess | `PosDecisionChecker.getPosRule()` | C10B1011(규격성분), C10B1031(사내성분) 판단기준 |

### 6.5 데이터 영향 범위

- **읽기 전용**: 이 클래스는 DB를 수정하지 않음. 조회만 수행하고 결과를 PosContext에 저장
- 후속 액티비티(INSERT 전이)가 `TB_C10_QLT_DSN_CHM` 테이블에 실제 INSERT 수행
- 조회 대상 테이블/뷰: `m00apuser.VI_M00_C10A1021`, `TB_C10_QLT_DSN_CHM`

### 6.6 주의사항 및 제약조건

- **고객사양 0건 처리**: `FAILURE`가 아닌 `FALSE` 반환. 호출 서비스(C102100040)에서 `false` 전이가 `end`로 매핑되어 있어 에러 없이 종료됨. 주석 처리된 에러 코드 블록이 있으며 이는 의도적 변경으로 보임
- **보증사양 사내사양 선택**: 사내사양이 없어도 오류 처리 없이 계속 진행 (규격사양과 다른 처리)
- **동적 컬럼 매핑**: 고객사양(prodSpecKind=1) 조회 시 `PosColumnDef[]`로 동적 컬럼 매핑 수행. 뷰 컬럼 구조 변경 시 자동 반영되나 주의 필요
- **서비스별 DAO 분리**: C102100040에서는 `mesdao`(보증사양용 SELECT_CHM) 사용. 고객사양(prodSpecKind=1)의 경우 `masterdao` 사용해야 하나, 실제 서비스 XML에서는 `mesdao`로 설정된 사례도 있어 확인 필요
- **Java 1.6 호환**: raw 타입 `Iterator` 사용 (제네릭 미적용)

---

## 7. 서비스 사용 현황

| 서비스 ID | prodSpecKind | 사양 유형 | DAO |
|-----------|-------------|----------|-----|
| C102100040 | (미설정, 기본값 추정) | 고객성분사양 | mesdao |
| C102100080 | 2 | 규격성분사양 | mesdao |
| C102100110 | 3 | 사내성분사양 | mesdao |
| C102100130 | 4 | 보증성분사양 | mesdao |
