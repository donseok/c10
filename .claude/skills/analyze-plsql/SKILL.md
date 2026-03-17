---
name: analyze-plsql
description: "Oracle PL/SQL 패키지/프로시저/함수 심층 분석 및 종합 보고서 생성. sqlcl MCP로 DB 직접 조회하여 소스 추출, Serena MCP로 심볼 분석, Sequential MCP로 심층 로직 분석 수행. 호출관계에 있는 프로시저 전체를 재귀적으로 분석하여 하나의 통합 보고서 생성. 사용 시점: /analyze-plsql NAME 호출 시, PL/SQL 패키지/프로시저/함수 분석이 필요할 때. 예: /analyze-plsql PL_M30_STOCK_CSM"
---

# PL/SQL 패키지 심층 분석

Oracle PL/SQL 패키지를 심층 분석하여 비즈니스 로직, 데이터 흐름, 프로시저/함수 상세를 추출하고 종합 보고서를 생성한다.
호출관계에 있는 프로시저 전체를 포함하여 하나의 문서로 생성한다.

**출력 형식**: `templates/plsql_package_analysis_report_template.md` 참조

## 매개변수
- `NAME`: 패키지명 또는 프로시저명 (예: PL_M30_STOCK_CSM, PROC_CALCULATE_WGT)
  - 스키마명 불필요 (자동 검색)
  - 패키지/프로시저 구분 불필요 (자동 감지)

## 실행 흐름

**상세 절차**: `references/plsql-analysis.md` 참조

### 시간 추적

각 Step 시작/완료 시 Bash로 `date '+[%H:%M:%S]'`를 실행하여 시각을 출력한다.

### Step 0: 사전 검증

Bash로 시작 시각 출력: `echo "⏱️ PL/SQL 분석 시작: $(date '+%H:%M:%S')"`

1. Serena MCP 확인 (`mcp__serena__get_current_config`)
2. NAME 파라미터 검증

### Step 1: PL/SQL 소스 검색 (DB 직접 조회)

Bash: `echo "⏱️ Step 1 (소스 검색) 시작: $(date '+%H:%M:%S')"`

- sqlcl MCP로 DB 접속하여 ALL_OBJECTS에서 오브젝트 검색
- 오브젝트 1개 → 자동 선택, 2개 이상 → AskUserQuestion으로 선택, 0개 → 종료
- ALL_SOURCE에서 소스 코드 추출 (PACKAGE인 경우 SPEC + BODY 모두)

완료 후: `echo "✅ Step 1 완료: $(date '+%H:%M:%S')"`

### Step 2: 구조 분석 (Serena 심볼 도구)

Bash: `echo "⏱️ Step 2 (구조 분석) 시작: $(date '+%H:%M:%S')"`

- 오브젝트 타입별 분석 전략 결정 (PACKAGE / PROCEDURE / FUNCTION)
- 메타데이터 수집 (오브젝트명, 스키마, 타입, 줄 수)
- 프로시저/함수 목록 추출 및 카테고리 분류

완료 후: `echo "✅ Step 2 완료: $(date '+%H:%M:%S')"`

### Step 3: 각 프로시저/함수 심층 분석 (Sequential MCP)

Bash: `echo "⏱️ Step 3 (심층 분석) 시작: $(date '+%H:%M:%S')"`

- 각 프로시저/함수마다 Sequential MCP로 8개 항목 분석
- 커서 루프 상세 분석
- 비즈니스 규칙 표 생성
- 데이터 플로우 생성
- 호출 프로시저/함수 감지 (ALL_DEPENDENCIES 조회)

완료 후: `echo "✅ Step 3 완료: $(date '+%H:%M:%S')"`

### Step 3.5: 호출 프로시저 재귀 분석

Bash: `echo "⏱️ Step 3.5 (재귀 분석) 시작: $(date '+%H:%M:%S')"`

- 호출하는 외부 프로시저/패키지를 재귀적으로 분석
- 기존 보고서 있으면 재활용, 없으면 Step 1~6 재귀 호출
- **최대 재귀 깊이: 3** (초과 시 호출 기록만 남김)
- **순환 참조 방지**: analyzedSet으로 추적

완료 후: `echo "✅ Step 3.5 완료: $(date '+%H:%M:%S')"`

### Step 4: 테이블 의존성 및 ER 관계 추출
- 전체 프로시저에서 테이블 목록 수집
- 테이블별 역할 분류 (임시/마스터/상세/전표)
- JOIN 관계 추출

### Step 5: Mermaid 워크플로우 다이어그램 생성
- 진입점 프로시저 기준으로 플로우 추적
- 메인 → 서브 프로시저 순서 배치

### Step 6: Markdown 보고서 생성

Bash: `echo "⏱️ Step 6 (보고서 생성) 시작: $(date '+%H:%M:%S')"`

- 템플릿 로드: `templates/plsql_package_analysis_report_template.md`
- 호출 프로시저 요약 및 링크 삽입

완료 후: `echo "✅ PL/SQL 분석 완료: $(date '+%H:%M:%S')"`

**출력 경로**:
| 타입 | 경로 |
|------|------|
| PACKAGE | `docs/analysis/dbms/{SCHEMA}/package/{NAME}_analysis_report.md` |
| PROCEDURE | `docs/analysis/dbms/{SCHEMA}/storedProcedure/{NAME}_analysis_report.md` |
| FUNCTION | `docs/analysis/dbms/{SCHEMA}/function/{NAME}_analysis_report.md` |

## DB 접속 정보

```
Connection Name: 테스트계
Username: MESAPUSER
Password: MESAPUSER_TST
Hostname: 210.1.1.139
Port: 2020
Type: SID
SID: UBMADQ
```

검색 스키마: `MESAPUSER`, `APSUSER`

## 에러 처리
- Serena MCP 없음 → 즉시 종료
- 파라미터 누락 → 사용법 출력 후 종료
- 오브젝트 없음 → 즉시 종료
- 파싱 오류 → 로그 후 다음 진행
- Sequential MCP 타임아웃 → 기본 분석으로 대체

## 실행 정책

- **팀원 spawn 절대 금지**: 팀모드(tmux)에서 실행되더라도 TeamCreate 등으로 새 팀원을 spawn하지 않는다. 모든 병렬/위임 작업(재귀 분석, 호출 프로시저 분석 등)은 반드시 **Agent tool**의 `subagent_type` 파라미터를 지정하여 서브에이전트로 실행한다.

## 제한사항
- 중간 JSON 파일 미생성 (Markdown 보고서만)
- 정적 분석만 수행 (실행 성능 미측정)
- EXECUTE IMMEDIATE 동적 SQL은 제한적 분석
