---
name: usage-monitor
description: "Claude Code 팀모드 사용량 모니터링. 모니터 pane의 /usage 실측 데이터 기반으로 할당 가능 여부 판단 (90% 이상이면 중단). 팀리더가 주기적으로 호출. 사용 시점: /usage-monitor 호출 시, 팀모드에서 사용량 확인이 필요할 때. 예: /usage-monitor start, /usage-monitor check"
---

# 팀모드 사용량 모니터

Claude Code 팀모드에서 모니터 pane의 `/usage` 실측 데이터를 파싱하여
할당 가능 여부를 판단한다 (90% 미만이면 normal, 90% 이상이면 stop).

## 스크립트 경로

```
MONITOR=docs/common/tools/usage-monitor.sh
```

## 매개변수

- `서브커맨드`: start | check | status | stop (기본: status)
- `pane`: 모니터 tmux pane 이름 (기본: monitor)

## 사용법

```
/usage-monitor start            # 타이머 시작 + 초기 poll
/usage-monitor check            # 틱 확인 + poll + 할당 가능 여부 판단
/usage-monitor status           # 전체 상태 출력
/usage-monitor stop             # 타이머 종료
```

## 실행 흐름

### start - 타이머 시작, 초기 poll 및 초기 팀원수 결정

팀리더가 팀 구성 직후 1회 호출한다.

#### Step 1: 타이머 시작

```bash
bash $MONITOR tick
```

10분 간격 백그라운드 틱 타이머 시작.

#### Step 2: 초기 사용량 조회

```bash
bash $MONITOR poll monitor
```

모니터 pane에 `/usage` 전송 → 5초 대기 → tmux capture-pane으로 출력 파싱.

파싱 대상 (Claude Code /usage 출력 형식):
```
Current session
  ███████                                            14% used
  Resets 6pm (Asia/Seoul)
```

추출 데이터:
- `session_usage_pct`: 세션 사용률 (%)
- `session_reset`: 리셋 시각 문자열
- `session_remaining_hours`: 리셋까지 남은 시간 (h)
- `week_usage_pct`: 주간 사용률 (%)

#### Step 3: 할당 가능 여부 판단

```bash
bash $MONITOR calc
```

poll 결과를 기반으로 할당 가능 여부를 판단한다.
`action` 값에 따라 업무 분배:
- `normal` (<90%) → 3명에게 각 1건씩 할당
- `stop` (≥90%) → 전원 업무 할당 보류, 리셋 시각까지 대기

#### Step 4: 결과 보고

사용자에게 보고:
- 실측 사용률 (%)
- 리셋 시각 및 남은 시간
- 주간 사용률
- **action (normal / stop)**

---

### check - 틱 확인 및 팀원수 계산

팀리더가 매 iteration에 호출한다.

#### Step 1: 틱 확인

```bash
bash $MONITOR check
```

- `TICK YYYY-MM-DD HH:MM:SS` → Step 2로 진행
- `NO_TICK` → 10분 미경과, 현재 작업 계속 (여기서 종료)

#### Step 2: 모니터 pane poll

틱 발생 시에만 실행:

```bash
bash $MONITOR poll monitor
```

#### Step 3: 할당 가능 여부 판단

```bash
bash $MONITOR calc
```

출력 JSON 필드:

| 필드 | 의미 |
|------|------|
| `usage_pct` | 실측 세션 사용률 (%) |
| `remaining_hours` | 리셋까지 남은 시간 |
| `action` | `normal` / `stop` |
| `can_assign_new_work` | 신규 작업 할당 가능 여부 |
| `week_usage_pct` | 주간 사용률 (참고) |

#### Step 4: 판단 및 조치

`action` 값에 따른 팀리더 조치:

**normal (사용률 < 90%)**:
```
[사용량 모니터] 사용률 {N}% | 리셋 {시각} ({H}시간 후)
→ 정상 운영, 3명 할당 유지
```

**stop (사용률 >= 90%)**:
```
[사용량 모니터] 사용률 {N}% | 리셋 {시각} ({H}시간 후)
→ 전체 신규 할당 중단. 진행 중 작업 완료 대기.
```

---

### status - 전체 상태 출력

```bash
bash $MONITOR status monitor
```

poll + calc 한 번에 실행.

---

### stop - 타이머 종료

```bash
bash $MONITOR stop
```

---

## 환경변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `TICK_INTERVAL` | 600 | 틱 간격 (초) |
| `THRESHOLD_STOP` | 90 | 전면 중단 임계값 (%) |
| `POLL_WAIT` | 5 | /usage 출력 대기 (초) |
| `MONITOR_PANE` | monitor | 모니터 tmux pane 이름 |

## 팀리더 연동 패턴

```
1. 팀 구성 직후: /usage-monitor start
2. 매 iteration:
   a. /usage-monitor check → TICK이면 계속, NO_TICK이면 건너뜀
   b. poll → 모니터 pane에서 실측 사용률 획득
   c. calc → action 판단
   d. action == normal (<90%) → 3명 할당 유지
   e. action == stop (≥90%) → 전원 대기, 리셋 후 재확인
3. 팀 해산: /usage-monitor stop
```
