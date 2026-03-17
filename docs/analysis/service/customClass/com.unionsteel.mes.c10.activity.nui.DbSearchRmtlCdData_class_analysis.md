# DbSearchRmtlCdData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchRmtlCdData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `183` 라인 |
| 메소드 수 | `1`개 (`runActivity`) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

`DbSearchRmtlCdData`는 품질설계 프로세스에서 **원자재코드를 편성(조회 및 저장)**하는 NUI(배치/비UI) Activity 클래스이다. 주문의 원자재코드(최대 3개: RMTL_CD, RMTL_CD1, RMTL_CD2)에 대해 EasyAccess 마스터 기준(C10B1063)을 조회하여 원자재코드·원자재등급을 확정하고, 품질설계 원자재 테이블(`TB_C10_QLT_DSN_RMT`)에 저장한다.

### 1.1 상속/구현 관계

```
PosActivity (GLUE Framework)
    └── DbSearchRmtlCdData implements C10NuiConstantsIF
```

- `PosActivity`: GLUE 프레임워크의 액티비티 추상 클래스. `runActivity(PosContext)`를 구현 필수.
- `C10NuiConstantsIF`: C10 NUI 공통 상수 인터페이스 (컬럼명, 에러코드, 쿼리키, EasyAccess ID 등 정의).

### 1.2 핵심 입력/출력

| 방향 | 항목 | 설명 |
|------|------|------|
| 입력 (PosContext) | `RMTL_CD` | 원자재코드 (필수) |
| 입력 (PosContext) | `RMTL_CD1` | 원자재코드1 (선택) |
| 입력 (PosContext) | `RMTL_CD2` | 원자재코드2 (선택) |
| 입력 (PosContext) | `ORD_EXC_THK` | 주문환산두께 |
| 입력 (PosContext) | `RMTL_PRFR_CD` | 원자재선호코드 |
| 입력 (PosContext) | `ORD_NO`, `ORD_LN` | 주문번호/행번 |
| 출력 (PosContext) | `QLT_DSN_MNF_TP` | 품질설계제조구분 (루프 인덱스 1부터) |
| 출력 (PosContext) | `QLT_DSN_ERR_CD` | 품질설계 에러코드 (실패 시) |
| 출력 (PosContext) | `P_ERR_KEY` | 에러 발생 여부 플래그 (`"Y"`) |
| DB INSERT | `TB_C10_QLT_DSN_RMT` | 품질설계 원자재 결과 저장 |
| transition | `success` / `failure` | 정상 처리 / 에러 발생 |

---

## 2. 메소드 상세 분석

### 2.1 runActivity(PosContext ctx)

| 항목 | 내용 |
|------|------|
| 목적 | 원자재코드 기준 마스터 조회 및 품질설계 원자재 데이터 편성·저장 |
| 복잡도 | 중간 |
| 반환 타입 | `String` (transition key) |
| throws | `PosException` |

**처리 흐름**:

1. **DAO 및 파라미터 초기화**: `getProperty("dao")`로 DAO 빈 취득, 지역 변수 초기화 (공백 문자열 기본값)
2. **PosContext에서 입력값 추출**: `RMTL_CD`, `RMTL_CD1`, `RMTL_CD2`, `ORD_EXC_THK`, `RMTL_PRFR_CD`를 읽어옴
3. **원자재코드 목록 구성**: RMTL_CD는 항상 포함, RMTL_CD1·RMTL_CD2는 값이 있으면 추가 (최대 3개 ArrayList)
4. **원자재코드별 루프 처리** (`nidx = 0..size-1`):
   - `QLT_DSN_MNF_TP` = `nidx + 1` (제조구분 1, 2, 3)
   - EasyAccess `C10B1063` 기준에 원자재코드 + 주문환산두께를 입력값으로 조회
   - 결과 건수 = 1: EasyAccess 결과 항목을 PosContext에 등록 → `TB_C10_QLT_DSN_RMT`에 INSERT
   - 결과 건수 > 1: 에러코드 KT17(중복), `P_ERR_KEY=Y` 설정 → `failure` 반환
   - 결과 건수 = 0 또는 예외: 에러코드 KT16(없음), `P_ERR_KEY=Y` 설정 → `failure` 반환
5. **전체 성공 시** `success` 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| BR-1 | 원자재기준 정보 존재 확인 | EasyAccess C10B1063 결과 건수 = 0 | 에러코드 KT16 설정, failure |
| BR-2 | 원자재기준 중복 방지 | EasyAccess C10B1063 결과 건수 > 1 | 에러코드 KT17 설정, failure |
| BR-3 | 원자재 유효 등록 | 결과 건수 = 1 | EasyAccess 결과를 Context에 반영 후 DB INSERT |
| BR-4 | 다중 원자재 처리 | RMTL_CD1, RMTL_CD2가 공백이 아닌 경우 | 해당 코드도 포함해 순차 처리 |
| BR-5 | 제조구분 자동 부여 | 루프 인덱스 nidx | QLT_DSN_MNF_TP = nidx + 1 (1, 2, 3) |
| BR-6 | DB INSERT 실패 처리 | dao.insert() 예외 발생 | 에러코드 TB05 설정, failure |

---

## 4. SQL 매핑

| SQL Key | 용도 | 호출 시점 | DAO |
|---------|------|-----------|-----|
| `C102100RMTL.insert` (INSERT_RMT) | 품질설계 원자재코드 저장 | 기준 조회 성공(1건) 후 매 원자재코드마다 | `mesdao` (property) |

**INSERT 대상 테이블**: `TB_C10_QLT_DSN_RMT`

| 컬럼 | 값 | 출처 |
|------|----|------|
| ORD_NO | `ctx.get(COL_ORD_NO)` | PosContext |
| ORD_LN | `ctx.get(COL_ORD_LN)` | PosContext |
| QLT_DSN_MNF_TP | `nidx + 1` | 루프 인덱스 |
| RMTL_CD | `rmtl.get(nidx)` | 원자재코드 목록 |
| RMTL_GRD | EasyAccess 결과 | C10B1063 반환값 |
| 감사 컬럼 (5종) | `ctx.getAuditAttribute()` | PosContext |

---

## 5. 참조 업무기준 (EasyAccess)

| 업무기준 ID | 입력 조건 | 결과 | 용도 |
|-------------|----------|------|------|
| `C10B1063` | 원자재코드 (`colValue[0]`), 주문환산두께 (`colValue[1]`) | 원자재코드, 원자재등급 등 | 원자재 편성 기준 마스터 조회 |

- `EasyAccess.getPosDecisionChecker(C10B1063, null).getPosRule(colValue)` 방식으로 호출
- `MasterDataException` 발생 시 에러코드 KT16 처리 (기준 데이터 없음으로 간주)

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 자동화 배치 프로세스(서비스 `C103100010`)의 일부로, 주문에 연결된 원자재코드를 EasyAccess 마스터(`C10B1063`)에서 검증하고, 주문별 품질설계 원자재 정보를 `TB_C10_QLT_DSN_RMT`에 적재한다. 한 주문에 최대 3종의 원자재코드(RMTL_CD/CD1/CD2)가 있을 수 있으며, 각각에 대해 제조구분(1/2/3)을 부여하여 저장한다.

### 6.2 핵심 비즈니스 로직

- RMTL_CD는 반드시 처리 대상이고, RMTL_CD1·RMTL_CD2는 값이 있을 때만 처리한다.
- EasyAccess 기준 조회 결과가 정확히 1건이어야 유효하다 (0건 = 기준 없음, 2건 이상 = 기준 중복 → 모두 에러).
- 기준 조회 성공 시 EasyAccess 결과의 모든 항목을 PosContext에 반영 후 DB에 INSERT 수행.
- 루프 중 하나라도 실패하면 즉시 `failure` 반환하여 후속 서비스로 에러 전파.

### 6.3 업무기준(EasyAccess) 참조

- **C10B1063**: 원자재코드 기준. 원자재코드 + 주문환산두께를 조건으로 원자재등급(`RMTL_GRD`) 등을 반환하는 마스터 테이블 기반 결정 기준.

### 6.4 타 시스템 연동

- EasyAccess(GLUE 프레임워크 내부 마스터 데이터 접근 레이어)를 통해 마스터 기준 데이터 조회. 외부 시스템 연동은 없음.

### 6.5 데이터 영향 범위

- **INSERT 대상**: `TB_C10_QLT_DSN_RMT` (MESAPUSER 스키마, C10 품질설계 원자재 결과 테이블)
- **다운스트림**: 이후 `PROC_LOOP` → `COMMIT` 액티비티로 트랜잭션 커밋. 에러 시 `SUBSERVICE_ERR` → `C103100140-service`로 에러 처리.

### 6.6 주의사항 및 제약조건

- `dao` property는 서비스 XML에서 `mesdao`로 지정되어 있으나, 클래스 주석 예시에는 `masterdao`로도 예시됨. 실제 운영에서는 INSERT가 MESAPUSER 대상이므로 `mesdao` 사용이 맞음.
- `PosValueParameter` 방식 (`isNamed="false"`) 사용 — 파라미터 순서가 SQL과 정확히 일치해야 함.
- EasyAccess 예외(`MasterDataException`) 발생 시 result2가 null로 처리됨에 유의.
- RMTL_CD3는 이 클래스에서 처리하지 않음 (상수 정의만 있고 목록에 미포함).
