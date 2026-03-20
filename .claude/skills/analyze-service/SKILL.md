---
name: analyze-service
description: "GLUE 프레임워크 기반 레거시 시스템 데이터 수집 자동 실행 (Phase 1-4 오케스트레이션). Phase 1(구조 파악), Phase 2(Java 분석), Phase 2.5(커스텀 클래스), Phase 3(SQL 분석), Phase 4(UI 분석)를 순차 실행하여 중간 JSON을 생성한다. 문서 생성은 /generate-legacy 또는 /generate-bpa를 사용. 사용 시점: /analyze-service SERVICE-ID 호출 시, 레거시 서비스 전체 분석이 필요할 때, 서비스 ID(예: M473020030, B47R1001)에 대한 종합 분석 요청 시. 개별 Phase만 실행 요청도 지원 (예: Phase 3만 실행해줘)"
---

# 레거시 시스템 전체 분석

GLUE Service XML 기반 레거시 서비스를 Phase 1~4 순차 실행하여 비즈니스 로직, 데이터 구조, UI 요구사항을 중간 JSON으로 추출한다. 문서 생성은 `/generate-legacy` 또는 `/generate-bpa`를 사용한다.

**핵심 목표**: Phase 1~4 데이터 수집을 자동화하여 후속 문서 생성 스킬의 입력 데이터를 확보

분석 흐름:
1. Phase 1: 구조 파악 (phase1-analyzer.js) → [references/phase1.md](references/phase1.md)
2. 서브서비스 재귀 분석
3. Phase 2+2.5: Java 심층 분석 (**Fast Path**: phase2-generator.py → 누락 시 /analyze-custom-class) → [references/phase2.md](references/phase2.md)
4. Phase 3: SQL 쿼리 분석 (**Fast Path**: phase3-generator.py → 누락 시 쿼리/PL/SQL 분석) → [references/phase3.md](references/phase3.md)
5. Phase 4: UI 컴포넌트 분석 (general-purpose subagent) → [references/phase4.md](references/phase4.md)

## 공통 사전 준비

```js
// 프로세스 코드 추출
function extractProcessCode(serviceId) {
  const num = serviceId.substring(1, 3).toLowerCase();
  return num === '10' ? 'c10' : 'm' + num;
}
// 서비스 타입: 'M'으로 시작 → 'ui', 'B'로 시작 → 'nui'
```

- **출력 디렉토리**: `docs/analysis/service/[ui|nui]/.temp/` (중간 JSON), `docs/analysis/service/[ui|nui]/` (최종 문서)

## 개별 Phase 실행

사용자가 특정 Phase만 실행을 요청하면 해당 references 파일을 읽고 지침을 따른다:
- Phase 1만 → [references/phase1.md](references/phase1.md) 참조
- Phase 2만 → [references/phase2.md](references/phase2.md) 참조
- Phase 3만 → [references/phase3.md](references/phase3.md) 참조
- Phase 4만 → [references/phase4.md](references/phase4.md) 참조

> **참고**: 개별 Phase는 별도의 독립 스킬/커맨드가 아니라, 이 analyze-service 스킬 내부에서 특정 Phase 지침만 실행하는 방식이다. 커스텀 클래스 분석은 별도 스킬 `/analyze-custom-class`를 사용한다.

## 통합 실행 오케스트레이션

> **자동 스킵**: Phase 1~4 스크립트는 출력 JSON이 이미 존재하면 자동 스킵한다 (exit 0). `--force` 플래그 추가 시 중간 JSON을 무시하고 전체 Phase를 재실행한다.

### 시간 추적

각 Step 시작 전에 Bash로 `date '+[%H:%M:%S]'`를 실행하여 시작 시각을 출력한다. 최초 Step 1 시작 시각을 기록하고, Step 6 완료 보고에서 전체 경과 시간을 함께 표시한다.

```
⏱️ Step N 시작: [HH:MM:SS]
... (작업 수행) ...
✅ Step N 완료: [HH:MM:SS] (소요: Xm Ys)
```

### Step 1: Phase 1 - 구조 파악

**[references/phase1.md](references/phase1.md) 참조**

Bash로 시작 시각 출력: `echo "⏱️ Step 1 (Phase 1 구조 파악) 시작: $(date '+%H:%M:%S')"`

Phase 1 스크립트를 자동 실행하여 SERVICE-ID의 서비스 XML을 파싱한다.

```bash
node .claude/skills/analyze-service/scripts/phase1-analyzer.js [SERVICE-ID] .
```

결과: `[SERVICE-ID]_structure.json` 생성

완료 후: `echo "✅ Step 1 완료: $(date '+%H:%M:%S')"`

### Step 2: 서브서비스 재귀 분석

Bash로 시작 시각 출력: `echo "⏱️ Step 2 (서브서비스 재귀 분석) 시작: $(date '+%H:%M:%S')"`

structure.json의 `subServices` 배열을 확인한다.

- `subServices`가 비어있으면 → Step 3으로 진행
- 각 서브서비스에 대해:
  - `src/service/[SUB-SERVICE-ID]-service.xml` 미존재 → 스킵
  - `docs/analysis/service/[ui|nui]/[SUB-SERVICE-ID]_legacy_analysis.md` 존재 → 스킵 (이미 분석됨)
  - 미분석 → `/analyze-service [SUB-SERVICE-ID]` 재귀 호출 (Skill tool 사용)
- 순환 참조 방지: 기존 보고서 존재 여부로 자연스럽게 무한루프 차단

완료 후: `echo "✅ Step 2 완료: $(date '+%H:%M:%S')"`

### Step 3: Phase 2 + 2.5 - Java 심층 분석 (Fast Path)

Bash로 시작 시각 출력: `echo "⏱️ Step 3 (Phase 2+2.5 Java 분석) 시작: $(date '+%H:%M:%S')"`

**"없으면 분석, 있으면 사용" 전략으로 class_analysis.md → java_analysis.json 생성**

#### 3-1. Fast Path 1차 실행

```bash
python3 .claude/skills/analyze-service/scripts/phase2-generator.py [SERVICE-ID] [SERVICE-TYPE] .
```

- **exit 0** → java_analysis.json 생성 완료, Step 4로 진행
- **exit 2** → 누락된 클래스 보고서 있음 → Step 3-2로
- **exit 1** → 오류, 중단

#### 3-2. 누락 클래스 분석 (exit 2인 경우)

stderr에서 `{"missing": ["com.xxx.ClassName", ...]}` 파싱.

각 누락 클래스에 대해:
- **풀 클래스명을 파일 경로로 변환**: `fullClassName.replace('.', '/') + '.java'` (예: `com.unionsteel.mes.m26.activity.ui.Foo` → `com/unionsteel/mes/m26/activity/ui/Foo.java`)
- **기존 분석 JSON 확인**: `docs/analysis/service/customClass/.temp/` 하위에서 `*[fullClassName]*_class_analysis.json` 존재 시 → 이미 분석됨, 스킵
- 미분석 클래스만 Task tool로 커스텀 클래스 분석 실행 (`model="sonnet"`, `subagent_type="general-purpose"`):
  - 프롬프트에 `/analyze-custom-class src/[변환된 파일 경로]` 실행 지시 (예: `/analyze-custom-class src/com/unionsteel/mes/m26/activity/ui/Foo.java`)
- 동일 클래스 중복 제거

#### 3-3. Fast Path 2차 실행

모든 누락 클래스 분석 완료 후 다시 실행:
```bash
python3 .claude/skills/analyze-service/scripts/phase2-generator.py [SERVICE-ID] [SERVICE-TYPE] .
```
exit 0 확인. 여전히 exit 2이면 오류 보고 후 중단.

#### Fallback (스크립트 실행 불가 시)

스크립트를 사용할 수 없는 경우 기존 방식으로 진행:
1. [references/phase2.md](references/phase2.md) 참조하여 정책 전달
2. Task tool로 `java-legacy-analyzer` subagent 실행 (`model="sonnet"`)

완료 후: `echo "✅ Step 3 완료: $(date '+%H:%M:%S')"`

### Step 4: Phase 3 - SQL 쿼리 분석 (Fast Path)

Bash로 시작 시각 출력: `echo "⏱️ Step 4 (Phase 3 SQL 분석) 시작: $(date '+%H:%M:%S')"`

**"없으면 분석, 있으면 사용" 전략으로 query-cache + PL/SQL → sql_analysis.json 생성**

#### 4-1. Fast Path 1차 실행

```bash
python3 .claude/skills/analyze-service/scripts/phase3-generator.py [SERVICE-ID] [SERVICE-TYPE] .
```

- **exit 0** → sql_analysis.json 생성 완료, Step 5로 진행
- **exit 2** → 누락 항목 있음 → Step 4-2로
- **exit 1** → 오류, 중단

#### 4-2. 누락 항목 분석 (exit 2인 경우)

stderr에서 `{"missedQueries": [...], "missingPlsql": [...]}` 파싱.

**missedQueries 처리** (쿼리 캐시에 분석 결과 없음):
- Task tool로 `oracle-sql-analyzer` subagent 실행 (`model="sonnet"`), missed 쿼리만 분석
- `orchestrator.py save-queries`로 캐시 저장

**참고**: PL/SQL 미분석 항목은 `analyzed=false`로 JSON에 포함되며, `/generate-legacy` 실행 시 자동 분석됨

#### 4-3. Fast Path 2차 실행

누락 항목 분석 완료 후 다시 실행:
```bash
python3 .claude/skills/analyze-service/scripts/phase3-generator.py [SERVICE-ID] [SERVICE-TYPE] .
```
exit 0 확인.

#### Fallback (스크립트 실행 불가 시)

스크립트를 사용할 수 없는 경우 기존 방식으로 진행:
1. [references/phase3.md](references/phase3.md) 참조
2. Task tool로 `oracle-sql-analyzer` subagent 실행 (`model="sonnet"`)

완료 후: `echo "✅ Step 4 완료: $(date '+%H:%M:%S')"`

### Step 5: Phase 4 - UI 컴포넌트 분석

Bash로 시작 시각 출력: `echo "⏱️ Step 5 (Phase 4 UI 분석) 시작: $(date '+%H:%M:%S')"`

**[references/phase4.md](references/phase4.md) 참조**

Task tool로 subagent 실행 (`model="sonnet"`, **`team_name`/`name` 파라미터 절대 불포함**):
```
subagent_type="general-purpose", model="sonnet"
Phase 4 지침(references/phase4.md)을 따라 [SERVICE-ID] 분석
```
> ⚠️ `team_name`, `name` 파라미터를 포함하면 서브에이전트가 아닌 팀원이 생성되어 규칙 위반이다.

검증: `[SERVICE-ID]_ui_analysis.json` 존재 및 serviceInfo 필드 확인

완료 후: `echo "✅ Step 5 완료: $(date '+%H:%M:%S')"`

### Step 6: 완료 보고

Bash로 완료 시각 출력: `echo "⏱️ 전체 데이터 수집 완료: $(date '+%H:%M:%S')"`

```
📊 Phase 1~4 데이터 수집 완료:
- Activities: [N]개, Custom 클래스: [M]개, SQL 쿼리: [K]개, UI 컴포넌트: [L]개
- 전체 소요 시간: [Step 1 시작 ~ Step 6 완료 경과 시간]

📁 중간 JSON: docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_*.json

📝 문서 생성은 다음 스킬을 실행하세요:
  - 레거시 분석 보고서: /generate-legacy [SERVICE-ID]
  - 비즈니스 프로세스 분석서: /generate-bpa [SERVICE-ID]
```

## 실행 정책

- **팀원 spawn 절대 금지**: 팀모드(tmux)에서 실행되더라도 TeamCreate 등으로 새 팀원을 spawn하지 않는다. 모든 병렬/위임 작업은 반드시 **Task tool**의 `subagent_type` 파라미터를 지정하여 서브에이전트로 실행한다. **Task tool 호출 시 `team_name`, `name` 파라미터를 절대 포함하지 않는다** — 이 파라미터가 포함되면 서브에이전트가 아닌 팀원이 생성된다. 이 규칙은 재귀 호출(서브서비스 분석, PL/SQL 분석 등) 포함 모든 단계에 적용된다.
- **Fast Path 우선**: Phase 2/3은 스크립트(phase2-generator.py, phase3-generator.py)로 먼저 시도. 캐시 히트 시 수 초 내 완료
- **순차 실행 필수**: Phase 2 → 3 → 4는 이전 Phase 완료 확인 후 다음 시작
- **절대로 동일 메시지에서 여러 Task 동시 호출 금지**
- **Early Termination**: customActivities 비어있으면 Phase 2에서 빈 JSON 생성 후 즉시 종료
- **중간 JSON 자동 스킵**: Phase 1~4 스크립트가 출력 JSON 존재 시 자동 스킵 (exit 0). 중단된 분석 재실행 시 완료된 Phase는 건너뛰고 미완료 Phase부터 재개. `--force` 옵션으로 중간 JSON 강제 재생성 가능
- **MCP 필수**: Serena (Java/XML 심볼 분석), JSON Cache (Phase 3 효율화 권장)

## 에러 처리

| 상황 | 대응 |
|------|------|
| Phase 결과 JSON 미생성 | 해당 Phase 재실행 |
| Phase 2 규칙 위반 | 결과 삭제 후 강화 정책으로 재실행 |
| 서브서비스 XML 미존재 | 스킵 후 계속 진행 |
| MCP 서버 미연결 | 에러 메시지 출력 후 중단 |
