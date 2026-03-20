---
name: generate-legacy
description: "기존 레거시 분석 결과(Phase 1~4 JSON)를 입력으로 레거시 시스템 분석 종합 보고서 생성. Phase 5 통합 문서 생성 + PL/SQL 자동 분석 및 보고서 갱신을 수행한다. 사용 시점: /generate-legacy SERVICE-ID 호출 시, analyze-service 완료 후 레거시 분석 보고서가 필요할 때."
---

# 레거시 시스템 분석 종합 보고서 생성

기존 `/analyze-service`의 Phase 1~4 결과물(JSON)을 **입력**으로 재활용하여, 레거시 시스템의 비즈니스 로직, 데이터 구조, UI 요구사항을 종합하는 **상세 분석 보고서**를 생성한다.

**핵심 목표**: 다른 LLM도 동일한 품질의 상세 분석을 생성할 수 있도록 구체적인 가이드를 제공하는 종합 문서 생성

## 실행 절차

### Step 1: 입력 데이터 확인

서비스 타입 판별:
- `M`으로 시작 → `ui`
- `B`로 시작 → `nui`

필수 JSON 파일 존재 확인:
```
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_structure.json
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_java_analysis.json
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_sql_analysis.json
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_ui_analysis.json
```

- **필수 JSON 중 하나라도 없으면** → `/analyze-service [SERVICE-ID]`를 Skill tool로 자동 실행하여 Phase 1~4 데이터 수집 먼저 수행. 완료 후 Step 2로 진행
- **모두 존재** → Step 2로 진행

> **generate-bpa와의 차이**: generate-bpa는 JSON 없으면 안내 후 중단하지만, generate-legacy는 자동으로 analyze-service를 실행하여 선행 분석을 수행한다.

### Step 2: Phase 5 - 통합 문서 생성

**항상 (재)생성**: 기존 `[SERVICE-ID]_legacy_analysis.md`가 존재하더라도 중간 JSON(structure/java/sql/ui)이 갱신될 수 있으므로 Phase 5는 매번 새로 실행한다.

**[references/phase5.md](references/phase5.md) 참조**

```
Phase 5 지침(references/phase5.md)을 따라 [SERVICE-ID] 통합 문서 생성
```

### Step 3: PL/SQL 자동 분석 및 보고서 갱신

Phase 5 통합 문서 생성 후, 미분석 PL/SQL 오브젝트를 자동으로 분석하고 보고서에 반영한다.

#### 3-1. 미분석 PL/SQL 확인

`sql_analysis.json`의 `plsqlCalls.detectedCalls`에서 `analyzed: false`인 항목 추출.

- `plsqlCalls` 섹션 없음 또는 `detectedCalls` 비어있음 → Step 4로 진행
- 미분석 항목 0개 → Step 4로 진행
- 미분석 항목 있음 → 3-1a로 진행

**분석 제외 목록** (자동 분석하지 않는 오브젝트):
- `PL_M47_QRY_TO_EXCEL` - 엑셀 출력 전용 패키지, 비즈니스 로직 없음

제외 목록에 해당하는 항목은 미분석 목록에서 제거한 후 진행.

#### 3-1a. PL/SQL 소스 일괄 조회 (DB 1회 접속)

미분석 오브젝트의 소스 코드를 **DB 1회 접속으로 일괄 조회**한다. 개별 접속 대신 한번에 가져와 효율성을 높인다.

```sql
-- 1) 오브젝트 정보 일괄 조회
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS
FROM ALL_OBJECTS
WHERE OBJECT_NAME IN ('OBJ1', 'OBJ2', ...)
  AND OWNER IN ('MESAPUSER', 'APSUSER')
  AND OBJECT_TYPE IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
ORDER BY OWNER, OBJECT_NAME;

-- 2) 소스 코드 일괄 조회
SELECT OWNER, NAME, LINE, TEXT
FROM ALL_SOURCE
WHERE (OWNER = 'APSUSER' AND NAME IN ('OBJ1', ...) AND TYPE = 'FUNCTION')
   OR (OWNER = 'MESAPUSER' AND NAME IN ('OBJ2', ...) AND TYPE = 'FUNCTION')
ORDER BY OWNER, NAME, LINE;

-- 3) 의존성 일괄 조회
SELECT OWNER, NAME, REFERENCED_OWNER, REFERENCED_NAME, REFERENCED_TYPE
FROM ALL_DEPENDENCIES
WHERE (OWNER, NAME) IN (('APSUSER','OBJ1'), ('MESAPUSER','OBJ2'), ...)
  AND REFERENCED_TYPE IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
  AND REFERENCED_OWNER IN ('MESAPUSER', 'APSUSER')
ORDER BY OWNER, NAME, REFERENCED_NAME;
```

조회 결과가 크면 파일로 저장 후 함수별로 분리하여 `/tmp/plsql_[NAME].txt`에 저장.

#### 3-2. PL/SQL 순차 분석

일괄 조회된 소스 코드를 기반으로, 각 미분석 오브젝트에 대해 분석 보고서를 생성한다.

- **소스 코드가 이미 로드되어 있으므로** Task tool(`model="sonnet"`, `subagent_type="general-purpose"`)로 분석 서브에이전트를 실행하여 보고서를 작성한다
- 또는 소스가 복잡한 경우 Task tool(`model="sonnet"`, `subagent_type="general-purpose"`)로 `/analyze-plsql [objectName]` 실행 — 이 경우 이미 DB 접속이 되어 있으므로 소스 조회 단계를 건너뜀
- **순차 실행 필수** (동일 메시지에서 여러 Skill 동시 호출 금지)
- 개별 분석 실패 시 경고 출력 후 다음 오브젝트 계속 진행
- 분석 완료된 보고서: `docs/analysis/dbms/[SCHEMA]/[package|storedProcedure|function]/[NAME]_analysis_report.md`

#### 3-3. sql_analysis.json 갱신

```bash
python3 .claude/skills/analyze-service/scripts/phase3-generator.py [SERVICE-ID] [SERVICE-TYPE] . --force
```
재실행 시 `--force`로 기존 JSON 덮어쓰기. 새로 생성된 보고서 자동 감지 → `analyzed: true` 갱신.

#### 3-4. Phase 5 보고서 갱신

기존 `[SERVICE-ID]_legacy_analysis.md`의 PL/SQL 테이블에 분석 보고서 링크를 추가한다.

**갱신 대상**: `## PL/SQL 함수/프로시저` 섹션의 테이블

기존 형태:
```markdown
| # | 호출명 | 유형 | 용도 |
|---|--------|------|------|
| 1 | PL_M47_ENT_SPC_TXT_UPSERT.P_ENT_SPC_TXT_INS | 패키지 | 입측 특기사항 UPSERT |
```

갱신 형태 (상세 분석 컬럼 추가):
```markdown
| # | 호출명 | 유형 | 용도 | 상세 분석 |
|---|--------|------|------|----------|
| 1 | PL_M47_ENT_SPC_TXT_UPSERT.P_ENT_SPC_TXT_INS | 패키지 | 입측 특기사항 UPSERT | [분석 보고서](../../../dbms/MESAPUSER/package/PL_M47_ENT_SPC_TXT_UPSERT_analysis_report.md) |
```

- 보고서 링크 경로: `/docs/analysis/dbms/[SCHEMA]/[type]/[NAME]_analysis_report.md` (프로젝트 루트 기준 절대 경로)
- 분석 실패한 항목: "미분석" 표시
- Edit tool로 기존 테이블 교체

### Step 4: 완료 보고

```
📊 레거시 분석 보고서 생성 완료:
- 서비스 ID: [SERVICE-ID]
- Activities: [N]개, Custom 클래스: [M]개, SQL 쿼리: [K]개, UI 컴포넌트: [L]개
- PL/SQL: [감지]개 감지, [분석완료]개 분석 완료

📁 출력: docs/analysis/service/[ui|nui]/[SERVICE-ID]_legacy_analysis.md
```

## 실행 정책

- **Phase 1~4 JSON 자동 확보**: 필수 JSON이 없으면 `/analyze-service`를 자동 실행하여 선행 분석 수행
- **항상 재생성**: 기존 문서가 있어도 최신 JSON 기반으로 재생성
- **팀원 spawn 절대 금지**: 팀모드(tmux)에서 실행되더라도 TeamCreate 등으로 새 팀원을 spawn하지 않는다. 모든 병렬/위임 작업은 반드시 **Task tool**의 `subagent_type` 파라미터를 지정하여 서브에이전트로 실행한다. **Task tool 호출 시 `team_name`, `name` 파라미터를 절대 포함하지 않는다**
- **순차 실행 필수**: PL/SQL 분석은 순차적으로 실행
- **절대로 동일 메시지에서 여러 Task 동시 호출 금지**
- **MCP 필수**: Serena (Java/XML 심볼 분석), JSON Cache (Phase 3 효율화 권장)

## 에러 처리

| 상황 | 대응 |
|------|------|
| Phase 1~4 JSON 미존재 | `/analyze-service` 자동 실행 |
| Phase 5 문서 생성 실패 | 에러 메시지 출력 후 중단 |
| PL/SQL 개별 분석 실패 | 경고 출력 후 다음 오브젝트 계속 진행 |
| MCP 서버 미연결 | 에러 메시지 출력 후 중단 |
