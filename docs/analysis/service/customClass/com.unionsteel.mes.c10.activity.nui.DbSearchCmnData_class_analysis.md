# DbSearchCmnData 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/DbSearchCmnData.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | `PosActivity` |
| 구현 인터페이스 | `C10NuiConstantsIF` |
| 총 라인 수 | `118` 라인 |
| 메소드 수 | `1`개 (`runActivity`) |
| 분석일자 | `2026-03-16` |

---

## 1. 클래스 개요

`DbSearchCmnData`는 품질설계 NUI(배치) 프로세스에서 주문 코일의 **규격공통사양**을 마스터 DB(M00APUSER)로부터 조회하여 PosContext에 적재하는 액티비티이다.

조회 결과를 통해 규격약호(`SPC_AVR`)의 앞 2자리를 추출하여 규격오피스코드(`SPC_OFC`)를 파생시키는 부가 편집도 수행한다. 서비스 `C102100070-service`의 품질설계 루프(`PROC_LOOP`) 내에서 각 주문 코일 반복 시마다 호출된다.

### 1.1 상속/구현 관계

- `PosActivity` 상속 - GLUE Framework의 기본 액티비티 클래스. `runActivity(PosContext)`를 구현 필수.
- `C10NuiConstantsIF` 구현 - NUI 전역 상수(컬럼명, 에러코드, SQL 키 등) 직접 참조.

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력(Property) | `prodSpecKind` | 품질설계사양구분 (서비스 XML에서 `"2"` 고정 전달) |
| 입력(Property) | `dao` | 사용할 DAO 빈 ID (`masterdao`) |
| 입력(Context) | `SPC_AVR` | 규격약호 (루프에서 세팅) |
| 입력(Context) | `SPC_YR` | 규격년도 (루프에서 세팅) |
| 출력(Context) | `QLT_DSN_SPC_TP` | 품질설계사양구분 (prodSpecKind 값 그대로 전달) |
| 출력(Context) | `SPC_OFC` | 규격오피스코드 (SPC_AVR 앞 2자리) |
| 출력(Context) | `QLT_DSN_ERR_CD` | 에러코드 (`KS01`: 규격 미존재 시) |
| 출력(Context) | `P_ERR_KEY` | 에러 플래그 (`Y`/`N`) |

---

## 2. 메소드 상세 분석

### 2.1 `runActivity(PosContext ctx)`

| 항목 | 내용 |
|------|------|
| 목적 | 규격공통사양 조회 및 컨텍스트 편집 |
| 복잡도 | 낮음 |
| 파라미터 | `ctx` - 서비스 전역 데이터 컨테이너 |
| 반환 타입 | `String` (`"success"` 고정 반환) |
| throws | 없음 (내부 try-catch 처리) |

**처리 흐름**:

1. Property에서 `prodSpecKind` 읽어 ctx에 `QLT_DSN_SPC_TP` 키로 저장
2. Property에서 `dao` 빈 ID 읽어 DAO 획득 (실제 사용 DAO: `masterdao`)
3. ctx에서 `SPC_AVR`(규격약호), `SPC_YR`(규격년도) 읽기
4. 두 값 중 하나라도 null/empty이면 `QLT_DSN_ERR_CD=KS01`, `P_ERR_KEY=Y` 세팅 후 에러 로그 기록 (단, return하지 않고 계속 진행)
5. `PosParameter`에 `SPC_YR`[0], `SPC_AVR`[1] 순으로 WhereClause 파라미터 설정
6. `dao.find("C10A1010", param)` 호출 - `M00APUSER.VI_M00_C10A1010` 뷰 조회
7. 조회 실패 시 rowset=null, 에러 로그 기록
8. `SPC_AVR`이 null/empty가 아니고 길이 > 2이면, 앞 2자리를 `SPC_OFC`로 ctx에 저장
9. `"success"` 반환

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| R01 | 규격 입력 필수 | `SPC_AVR` 또는 `SPC_YR` null/empty | `QLT_DSN_ERR_CD=KS01`, `P_ERR_KEY=Y`, 에러로그 기록 |
| R02 | 규격오피스코드 파생 | `SPC_AVR` 존재하고 길이 > 2 | `SPC_OFC` = `SPC_AVR` substring(0, 2) |
| R03 | 항상 성공 반환 | 조회 실패/에러 여부 무관 | `"success"` 반환 (에러는 P_ERR_KEY로 전달) |
| R04 | 파라미터 순서 | WhereClause 0번 인덱스에 두 값 모두 세팅 | 실질적으로 두 번째 setWhereClauseParameter(0, colValue[0])가 덮어씀 (버그 가능성) |

---

## 4. SQL 매핑

| SQL Key | 뷰/테이블 | 용도 | 호출 시점 |
|---------|-----------|------|-----------|
| `C10A1010` | `M00APUSER.VI_M00_C10A1010` | 규격약호+규격년도로 규격공통사양 단건 조회 | `runActivity` 내 항상 실행 |

**쿼리 조건**: `WHERE SPC_AVR = ? AND SPC_YR = ?`

**주의**: 조회된 rowset은 ctx에 저장하거나 후속 처리에 활용하는 코드가 없음. 조회 자체가 검증 목적이거나, rowset 활용은 후속 액티비티에서 담당.

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

품질설계 자동화 NUI 프로세스(`C102100070-service`)에서 주문 코일별로 반복 수행되는 품질설계 루프의 초기 단계에 위치한다. 각 주문의 규격약호(`SPC_AVR`)와 규격년도(`SPC_YR`)를 기반으로 마스터 규격공통사양 뷰를 조회하여, 후속 서브서비스(성분사양, 인도규격, 실적 처리)들이 필요한 규격 컨텍스트를 준비하는 역할을 수행한다.

### 6.2 핵심 비즈니스 로직

- **규격오피스코드 파생**: `SPC_AVR` (예: `KS1234`) 앞 2자리 → `SPC_OFC` (예: `KS`). 강종의 규격 제정 기관/오피스를 식별하는 코드.
- **품질설계사양구분 전달**: Property `prodSpecKind=2`는 서비스 XML 고정값으로, 품질설계 유형을 구분하는 상수이며 ctx를 통해 후속 액티비티로 전파.
- **에러 패턴**: 에러 발생 시 즉시 실패 반환 대신 `P_ERR_KEY=Y` + `QLT_DSN_ERR_CD` 조합으로 에러를 컨텍스트에 기록하고 계속 진행. 루프 완료 후 에러 라우터에서 일괄 처리.

### 6.3 코드 버그 가능성

파라미터 인덱스 중복: `setWhereClauseParameter(0, colValue[1])` 이후 `setWhereClauseParameter(0, colValue[0])` 호출로 인해 0번 인덱스가 colValue[0](SPC_AVR)으로 덮어써짐. SQL 쿼리가 두 개 바인딩 파라미터를 필요로 한다면 인덱스 0과 1로 분리해야 정상 동작한다.

### 6.4 데이터 영향 범위

- **읽기 전용**: `M00APUSER.VI_M00_C10A1010` 뷰 조회만 수행 (INSERT/UPDATE/DELETE 없음)
- **컨텍스트 수정**: `QLT_DSN_SPC_TP`, `SPC_OFC`, `QLT_DSN_ERR_CD`, `P_ERR_KEY`
