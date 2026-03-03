---
name: analyze-queries
description: "SQL 쿼리 분석 (배치/개별). query-cache 쿼리를 분석하여 L2 캐시에 저장. 배치 모드와 쿼리 ID 모드 지원."
---

# SQL 쿼리 분석

query-cache에 등록된 `.glue_sql` 쿼리를 분석하여 L2 캐시(analysis_json)에 저장한다.
두 가지 모드를 지원한다:

1. **배치 모드**: 전체/필터 대상 쿼리 일괄 분석 (사전 준비용)
2. **쿼리 ID 모드**: 특정 query_id 목록만 분석 (Phase 3 연동용)

## 사용법

### 배치 모드 (기존)
```
/analyze-queries                                    # 미분석 쿼리 전체
/analyze-queries --file M472020010-query.glue_sql   # 특정 파일
/analyze-queries --pattern "M4720%"                 # 패턴 매칭
/analyze-queries --folder nui                       # 폴더 필터
/analyze-queries --force                            # 전체 재분석
/analyze-queries --invalidate-below 2               # 버전 2 미만 재분석
/analyze-queries --dry-run                          # 계획만 표시
/analyze-queries --resume                           # 중단된 작업 재개
```

### 쿼리 ID 모드 (신규)
```
/analyze-queries --query-ids key1 key2 key3         # 특정 쿼리 ID만 분석
```

## 도구 경로

```
ORCHESTRATOR=.claude/skills/analyze-queries/scripts/orchestrator.py
SCHEMA_REF=.claude/skills/analyze-queries/references/analysis-schema.md
```

---

## 시간 추적

각 주요 단계 시작/완료 시 Bash로 `date '+[%H:%M:%S]'`를 실행하여 시각을 출력한다.

## 배치 모드 실행 알고리즘

### Step 0: 인자 파싱

Bash로 시작 시각 출력: `echo "⏱️ 쿼리 분석 시작: $(date '+%H:%M:%S')"`

사용자 입력에서 옵션을 추출한다:
- `scope`: all (기본), file, pattern, folder
- `mode`: update (기본, 미분석만), force (전체 재분석)
- `invalidate-below`: 특정 버전 미만 재분석
- `dry-run`: true/false
- `resume`: true/false

### Step 1: 배치 계획 생성

`orchestrator.py prepare` 실행하여 배치 계획을 생성한다.

```bash
# 기본 (미분석 쿼리 전체)
python3 $ORCHESTRATOR prepare

# 특정 파일
python3 $ORCHESTRATOR prepare --file {파일명}

# 패턴
python3 $ORCHESTRATOR prepare --pattern "{패턴}"

# 폴더
python3 $ORCHESTRATOR prepare --folder {폴더명}

# 전체 재분석
python3 $ORCHESTRATOR prepare --force

# 버전 미만 재분석
python3 $ORCHESTRATOR prepare --invalidate-below {버전}

# dry-run
python3 $ORCHESTRATOR prepare --dry-run
```

출력되는 JSON에서 `totalToAnalyze`, `totalBatches`를 확인한다.

### Step 2: Dry-run 처리

`--dry-run`이면 배치 계획 요약을 사용자에게 보여주고 종료한다.

### Step 3: Resume 처리

`--resume`이면:
```bash
python3 $ORCHESTRATOR status
```
출력에서 `nextPendingBatch`를 확인하여 해당 배치부터 시작한다.

### Step 4: 배치 루프

총 배치 수(`totalBatches`)만큼 반복한다. resume 시 `nextPendingBatch`부터 시작.

각 배치에 대해:

#### 4a. 쿼리 원문 가져오기

```bash
python3 $ORCHESTRATOR fetch-batch {batchId}
```

출력 JSON의 `queries` 객체에서 각 쿼리의 `sql`, `description`, `sourceFile` 정보를 얻는다.

#### 4a-2. 복잡도 사전 분류

배치의 쿼리 ID 목록으로 복잡도를 분류한다:

```bash
python3 $ORCHESTRATOR classify {queryId1} {queryId2} ...
```

출력 JSON의 `groups`로 모델 라우팅:
- `simple` + `medium` → haiku 서브에이전트에 전달
- `complex` → sonnet 서브에이전트에 전달 (complex가 없으면 생략)

#### 4b. 쿼리 분석 (복잡도별 모델 선택)

[references/analysis-schema.md](references/analysis-schema.md)의 스키마를 준수하여 각 쿼리를 분석한다.

**분석 가이드:**
1. **queryType 분류**: SQL 문의 첫 키워드로 판단 (SELECT, INSERT, UPDATE, DELETE, MERGE, CALL/{call)
2. **tables 추출**: FROM, JOIN, INTO, UPDATE, MERGE INTO 절에서 테이블명과 별칭 추출
3. **columns 추출**: SELECT 절 컬럼, INSERT 컬럼, UPDATE SET 절 컬럼 추출
4. **joins 추출**: JOIN 절 또는 WHERE 절의 조인 조건 추출
5. **parameters 추출**: `:paramName` 형태의 바인드 변수 추출
6. **businessPurpose**: 테이블명, 컬럼명, 조건을 기반으로 비즈니스 목적 추론 (한글)
7. **queryLogic**: 주요 조건, 정렬, 집계, 서브쿼리 등 로직 요약
8. **performanceInfo**: 조인 수, 서브쿼리 깊이, UNION 등으로 복잡도 판단

**모델별 서브에이전트 분배:**
- **haiku 그룹** (simple + medium 쿼리): `Task(model="haiku", subagent_type="general-purpose", ...)` 로 분석
  - 프롬프트에 `각 쿼리 분석 결과에 "analysisModel": "haiku" 필드를 반드시 포함할 것` 지시
- **sonnet 그룹** (complex 쿼리): `Task(model="sonnet", subagent_type="general-purpose", ...)` 로 분석
  - 프롬프트에 `각 쿼리 분석 결과에 "analysisModel": "sonnet" 필드를 반드시 포함할 것` 지시
- 두 그룹 모두 있으면 병렬 Task 호출 가능
- 한 그룹만 있으면 해당 모델의 Task만 호출

분석 결과를 `{queryId: analysisObject, ...}` 형태의 JSON 딕셔너리로 구성한다.
각 analysisObject에는 `analysisModel` 필드가 포함되어야 한다 (analysis-schema.md 참조).

#### 4c. 분석 결과 저장

haiku 결과 + sonnet 결과를 병합하여 저장:

```bash
echo '{병합된분석결과JSON}' | python3 $ORCHESTRATOR save-batch {batchId}
```

출력에서 진행률을 확인한다.

#### 4d. 진행률 보고

매 배치 완료 후 진행률을 사용자에게 보고한다:
```
[배치 N/M] 완료 (XX.X%) - N개 쿼리 저장 (haiku: X개, sonnet: Y개)
```

### Step 5: 최종 통계

Bash로 완료 시각 출력: `echo "✅ 쿼리 분석 완료: $(date '+%H:%M:%S')"`

모든 배치 완료 후:
```bash
python3 $ORCHESTRATOR status
```

실패한 배치가 있으면 목록을 보여주고 재시도 여부를 사용자에게 묻는다.

---

## 쿼리 ID 모드 실행 알고리즘

Phase 3 등에서 특정 쿼리 ID 목록만 분석할 때 사용한다.
배치 상태 파일을 사용하지 않으며, 3단계로 처리한다.

Bash로 시작 시각 출력: `echo "⏱️ 쿼리 ID 모드 분석 시작: $(date '+%H:%M:%S')"`

### Step 1: 쿼리 원문 + 캐시 상태 조회

```bash
python3 $ORCHESTRATOR fetch-queries key1 key2 key3 ...
```

출력 JSON:
```json
{
  "queries": {
    "key1": {
      "sql": "SELECT ...",
      "description": "...",
      "sourceFile": "...",
      "cachedAnalysis": null
    },
    "key2": {
      "sql": "SELECT ...",
      "description": "...",
      "sourceFile": "...",
      "cachedAnalysis": { "queryId": "key2", "queryType": "SELECT", ... }
    }
  },
  "summary": {
    "total": 3,
    "cached": 1,
    "missed": 2
  }
}
```

- `cachedAnalysis`가 null → missed (분석 필요)
- `cachedAnalysis`가 객체 → cached (분석 불필요)

### Step 2: missed 쿼리 복잡도 분류

missed 쿼리가 있으면 복잡도를 사전 분류한다:

```bash
python3 $ORCHESTRATOR classify {missed_key1} {missed_key2} ...
```

출력 JSON의 `groups`로 모델 라우팅:
- `simple` + `medium` → haiku 서브에이전트에 전달
- `complex` → sonnet 서브에이전트에 전달 (complex가 없으면 생략)

### Step 3: missed 쿼리 분석 (복잡도별 모델 선택)

[references/analysis-schema.md](references/analysis-schema.md)의 스키마를 준수하여 missed 쿼리만 분석한다.
분석 가이드는 배치 모드 Step 4b와 동일.

**모델별 서브에이전트 분배:**
- **haiku 그룹** (simple + medium 쿼리): `Task(model="haiku", subagent_type="general-purpose", ...)` 로 분석
  - 프롬프트에 `각 쿼리 분석 결과에 "analysisModel": "haiku" 필드를 반드시 포함할 것` 지시
- **sonnet 그룹** (complex 쿼리): `Task(model="sonnet", subagent_type="general-purpose", ...)` 로 분석
  - 프롬프트에 `각 쿼리 분석 결과에 "analysisModel": "sonnet" 필드를 반드시 포함할 것` 지시
- 두 그룹 모두 있으면 병렬 Task 호출 가능

### Step 3-2: 분석 결과 저장

missed 쿼리의 분석 결과(haiku + sonnet 병합)를 저장한다:

```bash
echo '{"missed_key1": {...}, "missed_key2": {...}}' | python3 $ORCHESTRATOR save-queries
```

### Step 4: 최종 결과 통합

Bash로 완료 시각 출력: `echo "✅ 쿼리 ID 모드 분석 완료: $(date '+%H:%M:%S')"`

cached 분석 결과 + 새로 분석된 결과를 합쳐서 최종 결과로 사용한다.

---

## 에러 처리

- **배치 분석 실패**: 해당 배치를 skip하고 다음 배치로 진행. 실패 목록은 상태 파일에 기록.
- **개별 쿼리 분석 실패**: 분석 가능한 쿼리만 저장하고, 실패한 쿼리는 에러 로그에 기록.
- **orchestrator.py 실행 실패**: 에러 메시지를 사용자에게 보여주고 중단.
- **중단 후 재개**: `--resume` 옵션으로 마지막 완료 배치 다음부터 이어서 진행 (배치 모드만).

## 실행 정책

- **팀원 spawn 절대 금지**: 팀모드(tmux)에서 실행되더라도 TeamCreate 등으로 새 팀원을 spawn하지 않는다. 모든 병렬/위임 작업(haiku/sonnet 그룹 분석 등)은 반드시 **Task tool**의 `subagent_type` 파라미터를 지정하여 서브에이전트로 실행한다.

## 참고

- 분석 스키마: [references/analysis-schema.md](references/analysis-schema.md)
- query-cache 도구: `docs/common/tools/query-cache/query_cache.py`
- 배치 상태 파일: `docs/common/tools/query-cache/data/batch_state.json` (배치 모드만 사용)
