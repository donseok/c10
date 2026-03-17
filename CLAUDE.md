# CLAUDE.md

이 파일은 Claude Code (claude.ai/code)가 본 저장소의 코드를 다룰 때 참고하는 가이드입니다.

## 프로젝트 개요

동국제강 MES C10 모듈 - POSCO ICT의 GLUE Framework 기반 레거시 제조실행시스템(MES). Java 1.6, Struts 1.1, Spring 2.x, Oracle DB, DHTMLX 프론트엔드.

## 코드 작업 시 주의사항
- 특별한 요청이 없으면 기존 코드(java, xml, sql 등)는 수정하지 않는다.
- 모든 Java 소스는 Java 1.6 호환 필수 (다이아몬드 연산자, try-with-resources, 람다 사용 불가)
- 쿼리 파일 확장자는 `.glue_sql` (`.xml`이 아님)
- 서비스 파일은 `-service.xml` 접미사 사용
- SQL은 Oracle 전용 구문 사용 (TO_DATE, NVL, DECODE, 힌트 `/*+ */` 등)
- 인코딩: Java/XML은 UTF-8, `struts-config.xml`과 `web.xml`은 EUC-KR
- `classes/` 디렉토리는 빌드 산출물 (컴파일 시 삭제 후 재생성)
- `GlueSDK/`는 프레임워크 SDK이므로 수정 금지

## 아키텍처

### GLUE Framework 서비스-액티비티 패턴

핵심 흐름: **JSP → Struts Action → Service XML → Activity 체인 → DAO → Oracle DB**

1. **JSP** (`WebContents/*.jsp`) - DHTMLX 기반 UI, AJAX로 Struts 액션 호출
2. **Struts** (`WEB-INF/struts-config.xml`) - `PosStrutsAction`/`PosLoggingStrutsAction`으로 라우팅, 데이터 처리 JSP로 포워드
3. **Service XML** (`src/service/{ID}-service.xml`) - 액티비티 워크플로우 체인 정의, 전이(success/failure/end) 설정
4. **Activity** (Java 클래스) - 비즈니스 로직, `DhtmlxActivity` 상속. 생명주기: `doPreActivity → doMainActivity → doPostActivity`
5. **Query** (`src/query/{ID}-query.glue_sql`) - XML 내 SQL 정의, 명명 파라미터(`:paramName`) 사용, 서비스에서 `sqlkey`로 참조
6. **DAO** - Spring 관리 `PosJdbcDao` 빈: `mesdao` (MESAPUSER 스키마), `masterdao` (M00APUSER 스키마)
7. 
### DAO 빈 구성

| 빈 ID | 스키마 | 용도 |
|-------|--------|------|
| `mesdao` | MESAPUSER | MES 메인 데이터 |
| `masterdao` | M00APUSER | 마스터/코드 데이터 (`VI_M00_CODE_ACCESS` 등 뷰) |
| `eaidao` | EAIAPUSER | EAI 외부 시스템 연동 |
| `m90dao` | M90APUSER | M90 모듈 간 공유 |

일부 쿼리에서 `C10APUSER` 스키마도 참조됨.

### sqlcl MCP 접속 주의사항

Oracle 버전이 낮아(11.2.0.3.0) `schema-information` 도구가 실패할 수 있다. DB 조회 시 아래 순서를 따를 것:

1. `sqlcl/list-connections` → 연결 이름 확인 (현재: `테스트계`)
2. `sqlcl/connect` → `{"connection_name": "테스트계"}` 로 접속
3. `sqlcl/run-sql` → SQL 직접 실행 (`ALL_TAB_COLUMNS`, `ALL_SOURCE` 등)

**주의**: `sqlcl/schema-information`은 사용하지 말 것 (Oracle 구버전 호환 문제로 실패함). 테이블 구조는 `ALL_TAB_COLUMNS`, `ALL_COL_COMMENTS`, `ALL_CONSTRAINTS`, `ALL_CONS_COLUMNS` 등을 `run-sql`로 직접 조회한다.
### 데이터 흐름 객체

- **PosContext** - 요청 범위 데이터 컨테이너, 액티비티 체인 전체에서 공유
- **PosRow/PosRowSet** - DAO 조회 결과셋 래퍼
- **PosParameter** - SQL 쿼리용 명명 파라미터 홀더 (`setNamedParamter`)

### 화면 ID 명명 규칙

화면 ID는 `C10XYYYZZZZ` 패턴을 따름:
- `C10` - 모듈 접두사
- `X` - 대분류: `1`=스케줄, `2`=지시, `3`=실적/이력, `4`=기타
- `YYY` - 중분류: `010`=수신, `020`=편집 등
- `ZZZZ` - 일련번호
- 접미사: `tab01`, `tab02`는 탭 콘텐츠, `pop01`은 팝업

`B10R`로 시작하는 서비스 ID는 배치/NUI(Network UI) 프로세스.

### 주요 소스 위치

- `src/com/unionsteel/mes/c10/activity/common/` - 상수(`C10ConstantsIF`), 유틸리티(`C10CommonUtil`), 트랜잭션 액티비티
- `src/com/unionsteel/mes/c10/activity/ui/` - UI 액티비티 (코일 조회, 지시 저장 등)
- `src/com/unionsteel/mes/c10/activity/nui/` - NUI/배치 액티비티 (스케줄 처리, EAI 연동, MO 매칭)
- `src/applicationContext.xml` - Spring 설정 (DB 연결, DAO 빈) - 개발용은 직접 JDBC, 서버용은 JNDI
- `src/applicationContext_server.xml` - 운영 Spring 설정 (`ServerXmlChange` 빌드 타겟에서 교체됨)

### 데이터베이스 스키마

- **MESAPUSER** - MES 주 스키마 (테이블 접두사 `TB_C10_`)
- **M00APUSER** - 마스터 데이터 스키마 (코드 테이블, `VI_M00_CODE_ACCESS` 등의 뷰를 통한 공통 데이터)
- **C10APUSER** - 일부 쿼리에서 참조하는 모듈 간 공유 스키마

### 프론트엔드 패턴

JSP 페이지에서 DHTMLX 컴포넌트(grid, form, tree) 사용. Struts 액션 URL(`/basicGridData.do`, `/handleDataProcess.do`, `/C10FormData.do`)을 통해 데이터 로딩. 그리드 데이터는 JSON 변환 클래스를 통해 교환.

## 팀모드 컨텍스트 초기화 규칙 (필수)

팀원에게 다음 서비스를 할당하기 전, **반드시** 아래 명령어로 컨텍스트를 초기화한다.
**이 명령어를 한 글자도 변경하지 않고 Bash 도구로 그대로 실행해야 한다:**

```bash
tmux send-keys -t {paneId} '/clear' && sleep 10 && tmux send-keys -t {paneId} Enter && sleep 10 && tmux send-keys -t {paneId} Enter
```

- `/clear` 텍스트와 `Enter`는 반드시 **별도 tmux send-keys 호출**로 분리 전송
- `sleep 1`: '/clear' 입력 후 Enter 전 대기 (tmux 전송 안정화)
- `sleep 15`: /clear 처리 완료 대기
- 두 번째 `Enter`: /clear 완료 후 프롬프트 활성화
- 초기화 완료 후 SendMessage로 다음 서비스 할당
- **금지**: SendMessage로 /clear 전송, '/clear' Enter 한 줄 합치기, 이 명령어 생략

## 커밋 규칙

커밋 메시지는 다음 형식을 따른다:

```
feat|fix|refactor: [작업 제목]
변경사항 :
  - [변경 내용 1]
  - [변경 내용 2]
변경사유 :
  - [변경 사유]
참고 :
  [참고 사항 (정보처리의뢰서 번호 등)]
```

- `feat`: 신규 기능 추가
- `fix`: 버그 수정
- `refactor`: 리팩토링 (기능 변경 없음)
- 커밋 시 `Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>` 포함
