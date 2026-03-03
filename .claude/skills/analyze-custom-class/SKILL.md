---
name: analyze-custom-class
description: "특정 Java 클래스 비즈니스 로직 심층 분석. Serena MCP를 활용하여 클래스 구조, 메소드 상세, SQL 매핑, 비즈니스 분석을 포함한 종합 보고서를 자동 생성. 사용 시점: /analyze-custom-class 클래스명 호출 시, 개별 Java 클래스의 비즈니스 로직 분석이 필요할 때, Activity 클래스의 상세 분석 요청 시"
---

# Java 클래스 비즈니스 로직 심층 분석

사용자가 지정한 Java 클래스를 심층 분석하여 클래스 구조, 메소드 상세, SQL 매핑, 비즈니스 분석 상세를 포함한 종합 보고서를 자동 생성한다.

## 사용법

```bash
# 전체 경로 지정
/analyze-custom-class src/com/unionsteel/mes/m47/activity/ui/M47CoilInsActErrorCheck.java

# 클래스명으로 지정 (자동 검색)
/analyze-custom-class M47CoilInsActErrorCheck

# 복수 클래스 분석
/analyze-custom-class M47CoilInsActErrorCheck, M47CoilInsActDataChange

# 패키지 전체 분석
/analyze-custom-class src/com/unionsteel/mes/m47/activity/nui/smart 모두 분석해
```

## 실행 알고리즘

### 시간 추적

각 Step 시작/완료 시 Bash로 `date '+[%H:%M:%S]'`를 실행하여 시각을 출력한다.

### Step 0: 매개변수 검증 및 파일 찾기

Bash로 시작 시각 출력: `echo "⏱️ 클래스 분석 시작: $(date '+%H:%M:%S')"`

- 복수 클래스 지정 시 콤마(,)로 분리
- 클래스명만 지정 시 `src/com/unionsteel/mes/m47/activity/` 하위에서 자동 검색
- `mcp__serena__find_file`로 파일 존재 확인, 없으면 즉시 종료

### Step 1: Serena MCP 심볼 분석

#### 1-1. 클래스 개요 분석
```bash
mcp__serena__get_symbols_overview --file="[FilePath]"
```
추출: 패키지명, 클래스명, 상위 클래스, 구현 인터페이스, 임포트, 전체 라인 수

#### 1-2. 메소드/필드 상세 추출
```bash
mcp__serena__find_symbol --file="[FilePath]" --type="method"
mcp__serena__find_symbol --file="[FilePath]" --type="field"
```
추출: public/protected/private 메소드, 파라미터, 반환 타입, throws, 멤버 변수

### Step 2: Activity 특화 분석 (해당 시)

#### 2-1. Activity 상속 확인
- DhtmlxActivity 상속 시: doPreActivity(), doMainActivity(), doPostActivity() 분석

#### 2-2. SQL 매핑 추출
- M47QueryConstants 구현 시: SELECT_SQL, INSERT_SQL 등 상수 추출, getProperty() 호출 패턴, DAO 메서드 호출

#### 2-3. Route Transition 패턴 분석
- 반환값: "SUCCESS", "FAILURE", "INSERT"/"UPDATE"/"DELETE", "COMPLETE", 기타 사용자정의

### Step 3: 분석 보고서 생성

#### 3-1. 마크다운 보고서
**파일**: `[PackageName].[ClassName]_class_analysis.md`

```markdown
# [ClassName] 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `[FilePath]` |
| 패키지 | `[PackageName]` |
| 상위 클래스 | `[SuperClassName]` |
| 구현 인터페이스 | `[InterfaceNames]` |
| 총 라인 수 | `[LineCount]` 라인 |
| 메소드 수 | `[MethodCount]`개 |
| 분석일자 | `[AnalysisDate]` |

---

## 1. 클래스 개요
[클래스의 비즈니스적 목적]

### 1.1 상속/구현 관계
### 1.2 핵심 입력/출력

## 2. 메소드 상세 분석
### 2.1 [메소드명]()
| 항목 | 내용 |
|------|------|
| 목적 | [목적] |
| 복잡도 | [낮음/중간/높음/매우 높음] |
**처리 흐름**: 1. [단계1] 2. [단계2] ...

## 3. 비즈니스 규칙
| # | 규칙명 | 조건 | 결과 |

## 4. SQL 매핑
| SQL Key | 용도 | 호출 시점 |

## 5. 참조 업무기준
| 업무기준 ID | 조건 | 결과 | 용도 |

## 6. 비즈니스 분석 상세
> 비즈니스 로직이 단순한 클래스는 6.1만 간략히 기술

### 6.1 업무 목적 및 배경
### 6.2 핵심 비즈니스 로직
### 6.3 업무기준(EasyAccess) 참조
### 6.4 타 시스템 연동
### 6.5 데이터 영향 범위
### 6.6 주의사항 및 제약조건
```

#### 3-2. JSON 메타데이터
**파일**: `[PackageName].[ClassName]_class_analysis.json`

> analyze-service Phase 2의 java_analysis.json per-class 스키마와 동일 구조

```json
{
  "analysisModel": "sonnet",
  "purpose": "[목적]",
  "complexity": "[낮음/중간/높음/매우 높음]",
  "filePath": "./src/...",
  "classStructure": {
    "extends": "", "implements": [], "imports": [], "constants": [], "memberVariables": []
  },
  "classDocumentation": {
    "description": "", "author": "", "version": "", "createdDate": ""
  },
  "mainLogic": {
    "method": "", "description": "", "inputType": "", "outputType": "", "steps": []
  },
  "keyMethods": [
    {"name": "", "purpose": "", "complexity": "", "parameters": [], "returnType": "",
     "businessLogic": {"algorithms": [], "dataStructures": [], "specialCases": []}}
  ],
  "businessRules": [
    {"ruleId": "", "name": "", "condition": "", "logic": "", "validation": "", "exception": ""}
  ],
  "sqlMappings": {
    "extractedPatterns": [{"pattern": "", "constantName": "", "line": "", "context": ""}],
    "constantsResolved": [{"constantName": "", "resolvedKey": "", "source": "", "confidence": ""}],
    "dynamicSqlPatterns": [{"pattern": "", "method": "", "parameters": []}],
    "usageFrequency": [{"sqlKey": "", "usageCount": "", "locations": []}]
  },
  "businessAnalysis": {
    "purpose": "",
    "coreLogic": [{"description": "", "conditions": [], "hardcodedValues": []}],
    "easyAccessRules": [{"ruleId": "", "usage": ""}],
    "externalSystems": [{"system": "", "type": "", "description": ""}],
    "dataImpact": {"tables": [], "downstreamEffects": []},
    "constraints": [], "operationalNotes": []
  },
  "dataFlow": {"input": {}, "processing": [], "output": {}},
  "dependencies": {"framework": [], "business": [], "dataStructures": []},
  "exceptionHandling": {"checkedExceptions": [], "errorCases": []},
  "complexityFactors": []
}
```

### Step 4: 출력 파일 저장

```
docs/analysis/service/customClass/
├── [PackageName].[ClassName]_class_analysis.md      # 마크다운 보고서
├── [PackageName]_class_analysis.md                  # 패키지 전체 보고서
├── .temp/
│   ├── [PackageName].[ClassName]_class_analysis.json # JSON
│   └── [PackageName]_class_analysis.json
└── index.md                                          # 전체 분석 목록
```

### Step 5: 인덱스 파일 갱신

완료 후: `echo "✅ 클래스 분석 완료: $(date '+%H:%M:%S')"`

`index.md`에 새 분석 결과 추가:
```markdown
# 커스텀 클래스 분석 목록
| 클래스명 | 패키지 | 라인 수 | 분석일자 | 보고서 |
```

## 복잡도 평가 기준

| 등급 | 기준 |
|------|------|
| 낮음 | getter/setter, 단순 파라미터 변환 |
| 중간 | 조건 분기 2-3개, 단순 반복문 |
| 높음 | 계산 로직, 중첩 반복문, 다중 예외 처리 |
| 매우 높음 | 복잡한 상태 머신, 다중 분기, 대량 비즈니스 규칙 |

## 실행 정책

- **팀원 spawn 절대 금지**: 팀모드(tmux)에서 실행되더라도 TeamCreate 등으로 새 팀원을 spawn하지 않는다. 모든 병렬/위임 작업은 반드시 **Task tool**의 `subagent_type` 파라미터를 지정하여 서브에이전트로 실행한다.

## 주의사항

- 파일 존재 확인 우선: `mcp__serena__find_file`로 확인, 없으면 즉시 종료
- Serena MCP 활용: `mcp__serena__get_symbols_overview`, `mcp__serena__find_symbol`
- Activity 특화: DhtmlxActivity 상속 시 생명주기 메소드 분석
- 비즈니스 분석 충실성: 하드코딩 값의 업무적 의미, 타 시스템 연동, CRUD 대상 테이블
- 간결성 원칙: 단순 클래스는 6.1만 간략히, 6.2~6.6은 생략 가능
- Java 1.6 호환, UTF-8 인코딩
