---
name: generate-bpa
description: "기존 레거시 분석 결과(Phase 1~4 JSON)를 입력으로 비즈니스 프로세스 분석서(BPA) 생성. 코드 레벨 상세를 제거하고 업무 담당자가 읽을 수 있는 비즈니스 중심 문서를 생성한다. 사용 시점: /generate-bpa SERVICE-ID 호출 시, 레거시 분석 완료 후 비즈니스 관점 문서가 필요할 때."
---

# 비즈니스 프로세스 분석서(BPA) 생성

기존 `/analyze-service`의 Phase 1~4 결과물(JSON)을 **입력**으로 재활용하여, 업무 담당자가 새 시스템을 설계할 때 참조할 수 있는 **비즈니스 프로세스 중심 문서**를 생성한다.

---

## ⛔ 절대 준수 규칙

> 이 규칙들은 BPA 문서 생성 시 어떤 상황에서도 위반할 수 없다.

### 규칙 1: 템플릿 100% 준수

**반드시 [templates/bpa_report_template.md](templates/bpa_report_template.md) 파일을 읽고, 그 섹션 번호(1~11), 제목, HTML 형식을 정확히 따라야 한다.**
- 섹션 번호/제목을 임의로 변경, 재배치, 추가, 삭제하지 않는다
- 템플릿에 없는 섹션(예: "액티비티 목록", "호출 PL/SQL 목록", "데이터 처리 상세", "ERD")을 추가하지 않는다
- 템플릿 내 `<!-- 작성 지침 -->` HTML 주석의 지시를 반드시 따른다

### 규칙 2: 워크플로우에 화면 조작 금지

**BPA 워크플로우는 "비즈니스 프로세스"를 표현하는 것이지, "화면 조작 절차"를 표현하는 것이 아니다.**

| ⛔ 금지 (화면 조작) | ✅ 올바름 (비즈니스 프로세스) |
|---|---|
| "조회/저장 버튼 클릭" | "코일 상태 검증", "작업지시 생성" |
| "화면 진입/로드/초기화" | "EAI 전문 수신", "배치 처리 시작" |
| "그리드 표시/바인딩" | "실적 데이터 집계", "NV 환산중량 계산" |
| "팝업 열기/닫기", "탭 전환" | "ERP 실적 보고", "LOT 편성 생성" |
| "메시지 출력", "엑셀 내보내기" | 워크플로우에서 제외 |

**판단 기준**: "사람이 화면에서 하는 행위"이면 제거하거나 "시스템이 수행하는 업무 처리"로 변환한다.

### 규칙 3: 코드 레벨 정보 금지

워크플로우(섹션 3, 4)와 비즈니스 로직 상세(섹션 5)에서 아래 항목 사용 금지:
- Activity 클래스명: `FormSearch`, `GridSave`, `PosParseMessage` 등
- SQL key: `B17R4050.upsert`, `M173020030.select` 등
- 컬럼명: `XSTAT`, `IF_GRP_ID` 등 (섹션 5의 엔티티 수준 언급만 예외)
- DAO 빈명/트랜잭션명/컨텍스트 변수명: `mesdao`, `tx3`, `PosContext` 등

### 규칙 4: Mermaid 줄바꿈 규칙

Mermaid 노드 내 줄바꿈은 반드시 `<br/>`을 사용한다. `\n` 사용 금지.

### 규칙 5: P-XX 번호체계 필수

- 섹션 4의 모든 프로세스에 **P-01, P-02...** 번호 부여 (Mermaid 노드에도 포함)
- 섹션 5의 각 `<details>` 블록은 섹션 4의 P-XX와 **1:1 매핑**

### 규칙 6: 조회 전용 서비스

데이터 변경이 전혀 없는 경우, 섹션 3/4/5를 템플릿의 "조회 전용" 메시지로 처리한다.

### 규칙 7: 섹션 3(핵심)과 섹션 4(상세)의 추상화 수준 구분

**섹션 3과 섹션 4는 반드시 다른 추상화 수준으로 작성해야 한다. 동일한 흐름을 반복하면 안 된다.**

| 구분 | 섹션 3 (핵심 워크플로우) | 섹션 4 (상세 워크플로우) |
|------|----------------------|----------------------|
| 목적 | 업무 기능 **그룹** 간 관계 조감도 | 각 기능 그룹 내부의 **P-XX 단위** 세부 흐름 |
| 노드 수 | 3~7개 (업무 기능 그룹 단위) | 기능별 5~15개 (개별 처리 단계) |
| P-XX 번호 | 사용하지 않음 | 필수 |
| Mermaid 수 | 1개 (전체 조감도) | **업무 그룹별 개별 Mermaid** |
| 방향 | `flowchart TD` (세로) | `flowchart TD` (세로) |
| 예시 노드 | "발주정보 수신 처리", "실적 보고" | "P-03: Roll 번호 존재 여부 확인", "P-07: 베어링 시퀀스 생성" |

**단일 프로세스 판단 기준**: 서비스의 업무 기능이 하나의 흐름(예: 수신→검증→저장→회신)으로만 구성되고, 독립적인 업무 기능 그룹이 2개 미만이면 **단일 프로세스**로 판정한다. 이 경우 섹션 3은 Mermaid 없이 다음 메시지로 대체:

> 이 서비스는 단일 업무 프로세스로 구성되어 있어 핵심 워크플로우를 별도로 작성하지 않습니다. **4. 상세 워크플로우**를 참조하세요.

**복수 기능 그룹 예시** (섹션 3 Mermaid 작성 대상):
- UI 화면에서 "저장", "삭제", "L2전송" 등 독립 업무가 3개 이상
- NUI에서 "신규 등록 경로"와 "변경 처리 경로"가 완전히 분리

### 규칙 8: 섹션 4 업무 그룹별 분리

**섹션 4는 하나의 거대 Mermaid가 아니라, 업무 기능 그룹별로 소제목 + 개별 Mermaid로 분리해야 한다.**

⛔ 금지 패턴:
```
### 프로세스 흐름도
(하나의 Mermaid에 P-01~P-13 전부 나열, Router에서 12개 분기)
```

✅ 올바른 패턴:
```
### 프로세스 흐름도 — 보급/보급취소 (P-04, P-05)
(Mermaid: 유효성 검증 → 스마트물류 분기 → 서브서비스 호출)

### 프로세스 흐름도 — 투입/투입취소 (P-06, P-07)
(Mermaid: 유효성 검증 → 부적합 경고 → 서브서비스 호출)

### 프로세스 흐름도 — 코일 이동 (P-08)
(Mermaid: 유효성 검증 → 서브서비스 호출)
```

**그룹 분리 원칙:**
- 관련 프로세스를 업무 단위로 묶는다 (예: 보급+보급취소, 투입+투입취소)
- 각 Mermaid에 유효성 검증, 분기 조건, 서브서비스 호출 등 **비즈니스 로직 단계**를 포함
- 데이터 변경 없는 순수 조회 프로세스(P-XX)는 Mermaid에서 제외하고 텍스트로 언급
- Router/분기 엔트리포인트는 섹션 3에서 이미 표현했으므로 섹션 4에서 반복하지 않는다
- `flowchart LR`(가로) 금지 — 노드 텍스트가 잘려 읽기 어려움. 반드시 `flowchart TD`(세로) 사용

---

## 실행 절차

### Step 1: 입력 데이터 확인

서비스 타입: `B` → `nui`, 그 외 → JSP 파일(`WebContents/[SERVICE-ID]*.jsp`) 존재 시 `ui`, 없으면 `nui`

필수 JSON 존재 확인:
```
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_structure.json
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_java_analysis.json
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_sql_analysis.json
docs/analysis/service/[ui|nui]/.temp/[SERVICE-ID]_ui_analysis.json
```
없으면 → `/analyze-service [SERVICE-ID]`를 Skill tool로 자동 실행

### Step 2: 연관 서비스(팝업/탭) 탐색

`.temp/`에서 `[SERVICE-ID]pop*`, `[SERVICE-ID]tab*` 패턴을 Glob으로 재귀 탐색. JSON이 존재하는 연관 서비스만 분석 대상에 포함.

### Step 3: 데이터 로드

메인 + 연관 서비스 모두:
1. `structure.json` → 서비스 구조, Activity 목록, 서브서비스
2. `java_analysis.json` → 커스텀 Activity 클래스 정보
3. `sql_analysis.json` → SQL 쿼리 분석, 테이블 정보
4. `ui_analysis.json` (ui 타입만) → 화면 레이아웃, 이벤트

### Step 4: 커스텀 클래스 분석 보고서 로드

java_analysis.json의 `customActivities`에서 `fullClassName` 추출 → `docs/analysis/service/customClass/[fullClassName]_class_analysis.md` 로드

### Step 5: 200줄 이상 클래스 필터링

class_analysis.md의 "총 라인 수" 또는 `wc -l`로 확인. **200줄 이상**만 섹션 6 Mermaid 대상.

### Step 6: BPA 보고서 생성

**반드시 [templates/bpa_report_template.md](templates/bpa_report_template.md)을 먼저 읽은 후**, 그 구조를 정확히 따라 작성한다.

#### 데이터 소스별 섹션 매핑:

| 섹션 | 주요 데이터 소스 | 핵심 작성 포인트 |
|------|----------------|-----------------|
| 1. 시스템 개요 | structure.json `serviceInfo` | 템플릿 6행 테이블 그대로 사용 |
| 2. 시스템 목적 | structure.json + java_analysis.json | 왜 존재하는지, 누가 사용하는지, 어떤 업무를 지원하는지 |
| 3. 핵심 워크플로우 | structure.json `activities` | 업무 기능 그룹 2개 이상일 때만 Mermaid. 단일 프로세스면 "단일 프로세스" 메시지. 섹션 4와 동일 흐름 반복 금지 |
| 4. 상세 워크플로우 | structure.json `activities` | P-XX 번호 필수. 프로세스 식별: 아래 참조 |
| 5. 비즈니스 로직 상세 | sql_analysis.json + java_analysis.json | `<details>` P-XX 1:1 매핑. 엔티티 수준만 |
| 6. 커스텀 클래스 | class_analysis.md | 항상 포함. 3가지 케이스 분기 |
| 7. 주요 유즈케이스 | 종합 | `<details>` UC-XX. 최소 2개 |
| 8. 화면 구성 개요 | ui_analysis.json | UI만. NUI 생략. HTML table 레이아웃 |
| 9. 관련 엔티티 | sql_analysis.json | 테이블 목록 + 텍스트 관계. ERD/컬럼 금지 |
| 10. 서브서비스 | structure.json `subServices` | 없으면 생략 |
| 11. 특이사항 | 종합 | 최소 3건 |

#### 프로세스 식별 방법 (섹션 4용):
1. `activities`에서 `type: "custom"` 또는 데이터 변경하는 `type: "common"`
2. `FormUpdate`, `FormInsert`, `GridSave` 등 데이터 변경 built-in Activity
3. `PosSubBizControlActivity`로 서브서비스 호출
4. `PosSendMessage`로 외부 전문 전송
5. 단순 `FormSearch` + `transition: "success → end"` → **제외**

#### 연관 서비스 약칭 표기 (섹션 4, 5):
- 동일 ID 파생: `— tab01`, `— pop01`
- 다른 ID 서브서비스: `— M261000001`
- 메인 서비스: 생략

### Step 7: 저장

```
docs/analysis/bpa/[SERVICE-ID]_bpa.md
```

### Step 8: 완료 보고

```
📊 BPA 생성 완료:
- 서비스 ID: [SERVICE-ID]
- 프로세스 수: [P-XX 개수]개
- 커스텀 클래스 워크플로우: [200줄 이상 클래스 수]개
- 서브서비스: [서브서비스 수]개

📁 출력: docs/analysis/bpa/[SERVICE-ID]_bpa.md
```

---

## 실행 정책

- **Phase 1~4 JSON 자동 확보**: 필수 JSON이 없으면 `/analyze-service`를 자동 실행
- **항상 재생성**: 기존 BPA 문서가 있어도 최신 JSON 기반으로 재생성
- **팀원 spawn 금지**: 이 스킬은 직접 실행하며 서브에이전트 불필요

---

## 서브에이전트 위임 시 필수 전달 사항

이 스킬을 서브에이전트에 위임할 때, 다음을 **프롬프트에 반드시 포함**한다:

1. **템플릿 파일 경로**와 "반드시 이 파일을 읽고 섹션 구조를 정확히 따를 것"
2. 아래 규칙 블록:

```
⛔ BPA 절대 준수 규칙:
1. 템플릿 파일을 반드시 먼저 읽고 섹션 번호/제목/형식을 정확히 따를 것. 섹션 추가/삭제/이름변경 금지
2. 워크플로우에 화면 조작 금지 — "버튼 클릭", "화면 진입", "그리드 표시" 등 UI 조작 용어 금지. 비즈니스 프로세스만 표현
3. 코드 레벨 정보 금지 — Activity 클래스명, SQL key, 컬럼명, DAO명, 트랜잭션명 금지
4. P-XX 번호체계 필수 — 섹션 4의 모든 프로세스에 P-01, P-02... 부여, 섹션 5와 1:1 매핑
5. Mermaid 줄바꿈 — 노드 내 줄바꿈은 반드시 `<br/>` 사용. `\n` 사용 금지
6. 섹션 9 — ERD 다이어그램 금지, 컬럼 상세 금지. 엔티티 목록 테이블 + 텍스트 관계만
7. 조회 전용 서비스 — 섹션 3/4/5를 "조회 전용" 메시지로 처리
8. 섹션 3 vs 4 추상화 수준 분리 — 섹션 3은 업무 기능 그룹 간 조감도(3~7 노드, P-XX 없음), 섹션 4는 그룹 내부 세부 흐름(P-XX 필수). 동일 흐름 반복 금지. 독립 기능 그룹이 2개 미만(단일 프로세스)이면 섹션 3은 Mermaid 없이 "단일 업무 프로세스" 메시지로 대체
9. 섹션 4 업무 그룹별 분리 — 하나의 거대 Mermaid에 모든 P-XX를 나열 금지. 업무 그룹별 소제목(### 프로세스 흐름도 — [그룹명] (P-XX, P-XX)) + 개별 Mermaid로 분리. 각 Mermaid에 유효성 검증·분기·서브서비스 호출 등 비즈니스 로직 단계 포함. 순수 조회 P-XX는 Mermaid 제외 후 텍스트 언급. flowchart LR 금지, 반드시 flowchart TD 사용
```
