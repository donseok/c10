# GlueHttpServerLauncher 상세 분석

| 항목 | 내용 |
|------|------|
| 파일 경로 | `src/com/unionsteel/mes/c10/activity/nui/GlueHttpServerLauncher.java` |
| 패키지 | `com.unionsteel.mes.c10.activity.nui` |
| 상위 클래스 | 없음 (Object 직접 상속) |
| 구현 인터페이스 | 없음 |
| 총 라인 수 | 25 라인 |
| 메소드 수 | 1개 (`main`) |
| 분석일자 | 2026-03-16 |

---

## 1. 클래스 개요

GLUE 프레임워크의 배치 잡(Batch Job) 데몬을 기동하는 Main 클래스이다. `PosGlueSchedulerHttpServer.main(null)`을 호출하여 HTTP 기반 스케줄러 서버를 시작한다. 실제 Activity 클래스가 아니며 JAR 실행 진입점(`Main-Class`) 역할만 수행한다.

### 1.1 상속/구현 관계

```
Object
    └── GlueHttpServerLauncher
```

GLUE 프레임워크 Activity 계층과 무관한 독립 실행 클래스이다.

### 1.2 핵심 입력/출력

| 구분 | 항목 | 설명 |
|------|------|------|
| 입력 | `args` | JVM 실행 인자 (null로 전달하여 무시) |
| 출력 | 없음 | 서버 기동 후 프로세스 유지 (데몬) |

---

## 2. 메소드 상세 분석

### 2.1 `main(String[] args)`

**목적**: GLUE 스케줄러 HTTP 서버 기동

**복잡도**: 매우 낮음

**처리 흐름**:

1. `PosGlueSchedulerHttpServer.main(null)` 호출 (args를 null로 고정 전달)
2. 예외 발생 시:
   - `System.out.println(e.getMessage())`: 에러 메시지 콘솔 출력
   - `e.printStackTrace()`: 스택 트레이스 출력
   - `System.exit(-1)`: 비정상 종료

---

## 3. 비즈니스 규칙

| # | 규칙명 | 조건 | 결과 |
|---|--------|------|------|
| 1 | 정상 기동 | `PosGlueSchedulerHttpServer.main()` 성공 | 스케줄러 데몬 프로세스 유지 |
| 2 | 기동 실패 | `Exception` 발생 | 에러 출력 후 `System.exit(-1)` 비정상 종료 |

---

## 4. SQL 매핑

해당 없음. DB 접근 없는 서버 런처 클래스이다.

---

## 6. 비즈니스 분석 상세

### 6.1 업무 목적 및 배경

C10 모듈의 배치 처리(NUI 서비스) 실행을 위한 GLUE HTTP 스케줄러 서버 기동 진입점이다. 주석에 명시된 대로 "특별한 이유가 없는 한 체인에서 그대로 복사하여 사용"하는 표준 런처 템플릿이다.

JAR 파일을 생성할 때 `Manifest.MF`의 `Main-Class`를 이 클래스로 지정하면 `java -jar c10-batch.jar` 명령으로 GLUE 스케줄러가 기동된다. GLUE 스케줄러는 HTTP 포트를 열고 외부에서 서비스 호출을 받아 배치 Activity 체인을 실행한다.
