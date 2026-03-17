---
name: plan:legacy2bpmn
description: "Service XML로부터 BPMN 워크플로우 파일 생성"
category: analysis
complexity: simple
wave-enabled: true
performance-profile: fast
auto-flags:
  - --validate
  - --uc
mcp-servers: []
personas: [architect]
---

# /plan:legacy2bpmn - BPMN 워크플로우 생성 명령어

## 명령어 개요
GLUE 프레임워크의 Service XML 파일을 파싱하여 BPMN 2.0 호환 워크플로우 다이어그램을 자동 생성합니다. Java, SQL, UI 분석 없이 경량화된 BPMN 파일만 생성합니다.

## 사용법
```bash
/plan:legacy2bpmn [SERVICE-ID]
```

## 매개변수
- `SERVICE-ID`: 분석할 서비스 식별자 (예: M473020030)

## 분석 대상 파일

### Service XML 파일
**📍 위치**: `./src/service/[SERVICE-ID]-service.xml`
**🔧 프로세스 코드 추출**:
- B로 시작 → M으로 변환 (예: B47R1001 → m47)
- M으로 시작 → 앞 3자 소문자 (예: M472040010 → m47)

**🔍 추출 정보**:
- **activity**: 업무 플로우의 각 단계
  - `name`: 액티비티 명칭
  - `class`: 실행 클래스 (documentation에 포함)
- **property**: 데이터 처리 규칙
  - `sqlkey`: SQL 쿼리 식별자 (documentation에 포함)
  - `bind-result`: 결과 바인딩 규칙
  - `resultkey`: 결과 키 매핑

## 출력 파일

### 생성되는 파일
- **파일명**: `[SERVICE-ID].bpmn`
- **위치**: `./docs/analysis/service/[ui|nui]/bpmn/`
- **형식**: BPMN 2.0 XML (Camunda/BPMN.io 호환)

**프로세스 코드**: SERVICE-ID 앞 3자 소문자로 추출된 폴더명 (예: M472040010 → m47)

## BPMN 작성 규칙

### 1. Task 배치 규칙
- **방향**: 왼쪽에서 오른쪽으로, 분기 시 위에서 아래로
- **Task 크기**:
  - Event Task: `width="36" height="36"`
  - 일반 Task: `width="100" height="80"`
- **Task 간격**: X축 200px, Y축 200px
- **종료 처리**: 각 종료 시점마다 별도 EndEvent 추가 (선 복잡도 방지)

### 2. 필수 요소
- `bpmndi:BPMNDiagram` 항목 필수
- Task의 `id`는 영어로 표시 (한글 인식 불가)
- `bpmn:sequenceFlow`에 대한 `bpmndi:BPMNEdge` 누락 금지
- 모든 Task에 대한 `bpmndi:BPMNShape` 필수

### 3. Documentation 프로퍼티
각 Task의 `bpmn:documentation` 요소에 다음 정보 포함:
- Activity 명칭 (한글)
- 실행 클래스 정보
- 관련 SQL 쿼리 키
- 파라미터 및 결과 바인딩 정보

## 실행 알고리즘

### Step 1: 경로 설정 및 파일 검증
1. **프로세스 코드 추출**:
   - B로 시작 → m + 다음 2자 소문자 (예: B47R1001 → m47)
   - M으로 시작 → 앞 3자 소문자 (예: M472040010 → m47)
2. **Service XML 경로 설정**: `./src/service/[SERVICE-ID]-service.xml`
3. Service XML 파일 존재 확인
4. XML 파일 유효성 검증
5. Activity 목록 추출

### Step 2: BPMN 구조 생성
1. **BPMN 프로세스 생성**
   - Process ID: `Process_[SERVICE-ID]`
   - Process Name: Service XML에서 추출한 서비스명

2. **Task 변환**
   - 각 activity → BPMN Task로 변환
   - Task ID: 영어로 변환 (예: `Task_Init`, `Task_Search`)
   - Task Name: activity의 name 속성 값 (한글 유지)

3. **SequenceFlow 생성**
   - Activity 순서대로 연결
   - Flow ID: `Flow_[순서번호]`
   - StartEvent → Task → Task → ... → EndEvent

4. **Documentation 추가**
   - 각 Task의 documentation 프로퍼티에 상세 정보 추가
   - Class, sqlkey, property 정보 포함

### Step 3: BPMN Diagram 정보 생성
1. **BPMNShape 생성**
   - 각 Task, Event에 대한 위치 및 크기 정보
   - X축: 시작 150px, 간격 200px
   - Y축: 중앙 150px, 분기 시 200px 간격

2. **BPMNEdge 생성**
   - 각 SequenceFlow에 대한 선 정보
   - Waypoint 좌표 계산

### Step 4: BPMN XML 파일 저장
1. **출력 디렉토리 생성**: `./docs/analysis/service/[ui|nui]/bpmn/`
2. BPMN 2.0 XML 형식으로 저장
3. UTF-8 인코딩
4. 파일 생성 확인 및 보고

## BPMN 파일 구조 예시

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"
                   xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI"
                   xmlns:dc="http://www.omg.org/spec/DD/20100524/DC"
                   xmlns:di="http://www.omg.org/spec/DD/20100524/DI"
                   id="Definitions_1"
                   targetNamespace="http://bpmn.io/schema/bpmn">

  <bpmn:process id="Process_M473020030" name="생산실적 조회" isExecutable="false">

    <bpmn:startEvent id="StartEvent_1" name="시작"/>

    <bpmn:task id="Task_Init" name="초기화">
      <bpmn:documentation>
        Class: com.poscoict.glue.activity.InitActivity
        Type: Common Activity
      </bpmn:documentation>
    </bpmn:task>

    <bpmn:task id="Task_Calculate" name="배분중량계산">
      <bpmn:documentation>
        Class: com.unionsteel.mes.m47.activity.ui.M47CoilInsActErrorCheck
        Type: Custom Activity
        SQL Keys: selectCoilList, updateCoilWeight
        Result Key: coilGrid
      </bpmn:documentation>
    </bpmn:task>

    <bpmn:endEvent id="EndEvent_1" name="종료"/>

    <bpmn:sequenceFlow id="Flow_1" sourceRef="StartEvent_1" targetRef="Task_Init"/>
    <bpmn:sequenceFlow id="Flow_2" sourceRef="Task_Init" targetRef="Task_Calculate"/>
    <bpmn:sequenceFlow id="Flow_3" sourceRef="Task_Calculate" targetRef="EndEvent_1"/>

  </bpmn:process>

  <bpmndi:BPMNDiagram id="BPMNDiagram_1">
    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_M473020030">

      <bpmndi:BPMNShape id="Shape_StartEvent_1" bpmnElement="StartEvent_1">
        <dc:Bounds x="150" y="150" width="36" height="36"/>
      </bpmndi:BPMNShape>

      <bpmndi:BPMNShape id="Shape_Task_Init" bpmnElement="Task_Init">
        <dc:Bounds x="250" y="128" width="100" height="80"/>
      </bpmndi:BPMNShape>

      <bpmndi:BPMNShape id="Shape_Task_Calculate" bpmnElement="Task_Calculate">
        <dc:Bounds x="450" y="128" width="100" height="80"/>
      </bpmndi:BPMNShape>

      <bpmndi:BPMNShape id="Shape_EndEvent_1" bpmnElement="EndEvent_1">
        <dc:Bounds x="650" y="150" width="36" height="36"/>
      </bpmndi:BPMNShape>

      <bpmndi:BPMNEdge id="Edge_Flow_1" bpmnElement="Flow_1">
        <di:waypoint x="186" y="168"/>
        <di:waypoint x="250" y="168"/>
      </bpmndi:BPMNEdge>

      <bpmndi:BPMNEdge id="Edge_Flow_2" bpmnElement="Flow_2">
        <di:waypoint x="350" y="168"/>
        <di:waypoint x="450" y="168"/>
      </bpmndi:BPMNEdge>

      <bpmndi:BPMNEdge id="Edge_Flow_3" bpmnElement="Flow_3">
        <di:waypoint x="550" y="168"/>
        <di:waypoint x="650" y="168"/>
      </bpmndi:BPMNEdge>

    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>

</bpmn:definitions>
```

## 출력 예시

```
✅ BPMN 워크플로우 생성 완료

📋 생성 정보:
- Service ID: [SERVICE-ID]
- Service Name: [서비스명]
- Activity 수: [N]개
- 파일 위치: ./docs/analysis/service/[ui|nui]/bpmn/[SERVICE-ID].bpmn

🎯 다음 단계:
- BPMN 뷰어로 확인: https://bpmn.io 또는 Camunda Modeler
- 상세 분석 필요 시: /legacy:analyze_service [SERVICE-ID] 실행
```

---

*이 명령어는 Service XML로부터 BPMN 워크플로우만 빠르게 생성하여 전체 레거시 분석 프로세스의 효율성을 높입니다.*

<!--
MES-AI 개발 프레임워크 - Command Documentation
Copyright (c) 2025 장종익 - 동국시스템즈
Command: legacy2bpmn
Category: analysis
Version: 1.0
Developer: 장종익

Service XML로부터 BPMN 워크플로우 파일만 경량화하여 생성하는 명령어입니다.
-->
