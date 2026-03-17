#!/bin/bash
# =============================================================================
# usage-monitor.sh - Claude Code 팀모드 사용량 모니터링 도구
# =============================================================================
#
# 모니터 pane의 /usage 출력을 파싱하여 실측 사용량 기반으로 팀원수를 계산한다.
#
# 기능:
#   1) tick   - 백그라운드 타이머 시작 (10분 간격)
#   2) check  - 틱 발생 여부 확인
#   3) poll   - 모니터 pane에 /usage 전송 후 출력 파싱
#   4) calc   - 사용량 기반 할당 가능 여부 판단
#   5) stop   - 백그라운드 타이머 종료
#   6) status - 현재 상태 전체 출력
#
# 사용법:
#   ./usage-monitor.sh tick                     # 타이머 시작
#   ./usage-monitor.sh check                    # 틱 확인 (TICK / NO_TICK)
#   ./usage-monitor.sh poll [pane]              # 모니터 pane에서 /usage 파싱
#   ./usage-monitor.sh calc                      # 할당 가능 여부 판단
#   ./usage-monitor.sh stop                     # 타이머 종료
#   ./usage-monitor.sh status [pane]            # 전체 상태 출력
#
# =============================================================================

set -euo pipefail

# --- 설정 ---
TICK_INTERVAL=${TICK_INTERVAL:-600}                           # 10분 (초)
THRESHOLD_STOP=${THRESHOLD_STOP:-90}                          # 신규 할당 중단 임계값(%)
POLL_WAIT=${POLL_WAIT:-5}                                     # /usage 출력 대기 시간(초)
MONITOR_PANE=${MONITOR_PANE:-"monitor"}                       # 모니터 tmux pane 이름

# --- 경로 ---
WORK_DIR="/tmp/claude-usage-monitor"
TICK_FILE="${WORK_DIR}/tick"
TICK_CONSUMED="${WORK_DIR}/tick_consumed"
PID_FILE="${WORK_DIR}/tick.pid"
POLL_FILE="${WORK_DIR}/poll_result.json"

mkdir -p "${WORK_DIR}"

# =============================================================================
# 함수 정의
# =============================================================================

# --- pane 이름/ID 해석 (3단계: pane ID → 제목 검색 → 팀 설정 조회) ---
resolve_pane() {
    local pane="$1"

    # 1. pane ID 형식 (%N) - 직접 확인
    if [[ "${pane}" == %* ]]; then
        if tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -q "^${pane}$"; then
            echo "${pane}"
            return 0
        fi
        return 1
    fi

    # 2. pane 제목으로 검색
    local found_pane
    found_pane=$(tmux list-panes -a -F '#{pane_id} #{pane_title}' 2>/dev/null | grep "${pane}" | head -1 | awk '{print $1}')
    if [ -n "${found_pane}" ]; then
        echo "${found_pane}"
        return 0
    fi

    # 3. 팀 설정 파일에서 멤버 이름으로 tmuxPaneId 조회
    local team_configs_dir="${HOME}/.claude/teams"
    if [ -d "${team_configs_dir}" ]; then
        local config pane_id
        for config in "${team_configs_dir}"/*/config.json; do
            [ -f "${config}" ] || continue
            pane_id=$(jq -r --arg name "${pane}" '.members[] | select(.name == $name) | .tmuxPaneId' "${config}" 2>/dev/null)
            if [ -n "${pane_id}" ] && [ "${pane_id}" != "null" ]; then
                echo "${pane_id}"
                return 0
            fi
        done
    fi

    return 1
}

# --- 백그라운드 틱 타이머 시작 ---
cmd_tick() {
    if [ -f "${PID_FILE}" ]; then
        local old_pid
        old_pid=$(cat "${PID_FILE}")
        if kill -0 "${old_pid}" 2>/dev/null; then
            echo "이미 타이머가 실행 중입니다 (PID: ${old_pid})"
            return 0
        fi
    fi

    (
        while true; do
            date '+%Y-%m-%d %H:%M:%S' > "${TICK_FILE}"
            sleep "${TICK_INTERVAL}"
        done
    ) &

    local pid=$!
    echo "${pid}" > "${PID_FILE}"
    date '+%Y-%m-%d %H:%M:%S' > "${TICK_FILE}"
    echo "타이머 시작 (PID: ${pid}, 간격: $((TICK_INTERVAL / 60))분)"
}

# --- 틱 발생 확인 ---
cmd_check() {
    if [ ! -f "${TICK_FILE}" ]; then
        echo "NO_TICK"
        return 0
    fi

    if [ ! -f "${TICK_CONSUMED}" ]; then
        cp "${TICK_FILE}" "${TICK_CONSUMED}"
        echo "TICK $(cat "${TICK_FILE}")"
        return 0
    fi

    if [ "${TICK_FILE}" -nt "${TICK_CONSUMED}" ]; then
        cp "${TICK_FILE}" "${TICK_CONSUMED}"
        echo "TICK $(cat "${TICK_FILE}")"
    else
        echo "NO_TICK"
    fi
}

# --- 모니터 pane에서 /usage 파싱 ---
cmd_poll() {
    local pane_arg="${1:-${MONITOR_PANE}}"

    # tmux 세션 확인
    if ! tmux has-session 2>/dev/null; then
        echo '{"error": "tmux 세션이 없습니다"}' | tee "${POLL_FILE}"
        return 1
    fi

    # pane 해석 (이름/ID/팀설정 3단계)
    local pane
    pane=$(resolve_pane "${pane_arg}")
    if [ -z "${pane}" ]; then
        echo "{\"error\": \"pane '${pane_arg}'을 찾을 수 없습니다\"}" | tee "${POLL_FILE}"
        return 1
    fi

    # /usage 전송 (/usage와 Enter를 분리 전송해야 정상 동작)
    tmux send-keys -t "${pane}" '/usage'
    sleep 10
    tmux send-keys -t "${pane}" Enter
    sleep 10
    tmux send-keys -t "${pane}" Enter

    # 출력 대기
    sleep "${POLL_WAIT}"

    # pane 출력 캡처
    local captured
    captured=$(tmux capture-pane -t "${pane}" -p -S -50 2>/dev/null || echo "")

    # /usage 화면 닫기 (Esc로 종료)
    tmux send-keys -t "${pane}" Escape

    if [ -z "${captured}" ]; then
        echo '{"error": "pane 출력을 캡처할 수 없습니다"}' | tee "${POLL_FILE}"
        return 1
    fi

    # --- /usage 출력 파싱 ---
    # 파싱 대상 형식:
    #   Current session
    #     ███████                                            14% used
    #     Resets 6pm (Asia/Seoul)
    #
    #   Current week (all models)
    #     ████████                                           16% used
    #     Resets Feb 27, 6pm (Asia/Seoul)

    # Current session 사용률
    local session_pct
    session_pct=$(echo "${captured}" | grep -A2 "Current session" | sed -n 's/.*[[:space:]]\([0-9][0-9]*\)% used.*/\1/p' | head -1)

    # Current session 리셋 시각
    local session_reset
    session_reset=$(echo "${captured}" | grep -A3 "Current session" | grep "Resets " | head -1 | sed 's/.*Resets //;s/ *(.*//' | sed 's/[[:space:]]*$//')

    # Current week 사용률
    local week_pct
    week_pct=$(echo "${captured}" | grep -A2 "Current week" | sed -n 's/.*[[:space:]]\([0-9][0-9]*\)% used.*/\1/p' | head -1)

    # Current week 리셋 시각
    local week_reset
    week_reset=$(echo "${captured}" | grep -A3 "Current week" | grep "Resets " | head -1 | sed 's/.*Resets //;s/ *(.*//' | sed 's/[[:space:]]*$//')

    # 리셋까지 남은 시간 계산 (session reset 기준)
    local remaining_hours=""
    if [ -n "${session_reset}" ]; then
        remaining_hours=$(parse_reset_time "${session_reset}")
    fi

    # 결과 저장
    local now
    now=$(date '+%Y-%m-%d %H:%M:%S')

    cat > "${POLL_FILE}" <<EOF
{
  "timestamp": "${now}",
  "source": "monitor_pane",
  "pane": "${pane}",
  "session_usage_pct": ${session_pct:-null},
  "session_reset": "${session_reset:-}",
  "session_remaining_hours": ${remaining_hours:-null},
  "week_usage_pct": ${week_pct:-null},
  "week_reset": "${week_reset:-}"
}
EOF

    cat "${POLL_FILE}"
}

# --- 리셋 시각 문자열 → 남은 시간(h) 변환 ---
parse_reset_time() {
    local reset_str="$1"
    local now_epoch
    now_epoch=$(date +%s)

    # "6pm" → 오늘 18:00
    # "Feb 27, 6pm" → 해당 날짜 18:00
    local reset_epoch=""

    # 패턴 1: "6pm" 또는 "11am" (오늘)
    if echo "${reset_str}" | grep -qE '^[0-9]{1,2}(am|pm)$'; then
        local hour
        hour=$(echo "${reset_str}" | sed 's/[apm]//g')
        local ampm
        ampm=$(echo "${reset_str}" | sed 's/[0-9]//g')
        if [ "${ampm}" = "pm" ] && [ "${hour}" -ne 12 ]; then
            hour=$((hour + 12))
        elif [ "${ampm}" = "am" ] && [ "${hour}" -eq 12 ]; then
            hour=0
        fi
        # macOS date
        local today_str
        today_str=$(date '+%Y-%m-%d')
        reset_epoch=$(date -j -f '%Y-%m-%d %H:%M:%S' "${today_str} ${hour}:00:00" +%s 2>/dev/null || echo "")
        # 이미 지난 시각이면 내일로
        if [ -n "${reset_epoch}" ] && [ "${reset_epoch}" -le "${now_epoch}" ]; then
            local tomorrow_str
            tomorrow_str=$(date -j -v+1d '+%Y-%m-%d')
            reset_epoch=$(date -j -f '%Y-%m-%d %H:%M:%S' "${tomorrow_str} ${hour}:00:00" +%s 2>/dev/null || echo "")
        fi
    fi

    # 패턴 2: "Mar 27, 6pm"
    if [ -z "${reset_epoch}" ]; then
        if echo "${reset_str}" | grep -qE '^[A-Z][a-z]+ [0-9]{1,2}, [0-9]{1,2}(am|pm)$'; then
            local month_day
            month_day=$(echo "${reset_str}" | sed 's/,[[:space:]]*[0-9]*[apm]*$//')
            local time_part
            time_part=$(echo "${reset_str}" | sed 's/.*,[[:space:]]*//')
            local hour
            hour=$(echo "${time_part}" | sed 's/[apm]//g')
            local ampm
            ampm=$(echo "${time_part}" | sed 's/[0-9]//g')
            if [ "${ampm}" = "pm" ] && [ "${hour}" -ne 12 ]; then
                hour=$((hour + 12))
            elif [ "${ampm}" = "am" ] && [ "${hour}" -eq 12 ]; then
                hour=0
            fi
            local year
            year=$(date '+%Y')
            reset_epoch=$(date -j -f '%b %d %Y %H:%M:%S' "${month_day} ${year} ${hour}:00:00" +%s 2>/dev/null || echo "")
        fi
    fi

    if [ -n "${reset_epoch}" ] && [ "${reset_epoch}" -gt "${now_epoch}" ]; then
        local remaining_sec=$((reset_epoch - now_epoch))
        echo "scale=1; ${remaining_sec} / 3600" | bc
    else
        echo ""
    fi
}

# --- 사용량 기반 할당 가능 여부 판단 ---
cmd_calc() {
    # poll 결과 확인
    if [ ! -f "${POLL_FILE}" ]; then
        echo '{"error": "poll 데이터 없음. 먼저 poll을 실행하세요."}'
        return 1
    fi

    # poll 결과에서 실측 데이터 읽기
    local usage_pct
    usage_pct=$(jq '.session_usage_pct // null' "${POLL_FILE}")

    local remaining_hours
    remaining_hours=$(jq '.session_remaining_hours // null' "${POLL_FILE}")

    local session_reset
    session_reset=$(jq -r '.session_reset // ""' "${POLL_FILE}")

    local week_pct
    week_pct=$(jq '.week_usage_pct // null' "${POLL_FILE}")

    # 실측 데이터 유효성 확인
    if [ "${usage_pct}" = "null" ] || [ -z "${usage_pct}" ]; then
        echo '{"error": "사용률 데이터를 파싱할 수 없습니다. poll 출력을 확인하세요."}'
        return 1
    fi

    # 상태 판단: normal / stop (90% 기준)
    local action="normal"
    local can_assign="true"

    if [ "${usage_pct}" -ge "${THRESHOLD_STOP}" ]; then
        action="stop"
        can_assign="false"
    fi

    cat <<EOF
{
  "timestamp": "$(date '+%Y-%m-%d %H:%M:%S')",
  "usage_pct": ${usage_pct},
  "remaining_hours": ${remaining_hours:-null},
  "session_reset": "${session_reset}",
  "week_usage_pct": ${week_pct:-null},
  "threshold_stop": ${THRESHOLD_STOP},
  "action": "${action}",
  "can_assign_new_work": ${can_assign}
}
EOF
}

# --- 타이머 종료 ---
cmd_stop() {
    if [ -f "${PID_FILE}" ]; then
        local pid
        pid=$(cat "${PID_FILE}")
        if kill -0 "${pid}" 2>/dev/null; then
            kill "${pid}"
            echo "타이머 종료 (PID: ${pid})"
        else
            echo "타이머가 이미 종료되었습니다"
        fi
        rm -f "${PID_FILE}"
    else
        echo "실행 중인 타이머 없음"
    fi
    rm -f "${TICK_FILE}" "${TICK_CONSUMED}"
}

# --- 전체 상태 출력 ---
cmd_status() {
    local pane_arg="${1:-${MONITOR_PANE}}"

    # pane 해석
    local pane
    pane=$(resolve_pane "${pane_arg}")
    if [ -z "${pane}" ]; then
        echo "{\"error\": \"pane '${pane_arg}'을 찾을 수 없습니다\"}"
        return 1
    fi

    echo "=== Claude Code 팀모드 사용량 모니터 ==="
    echo ""

    # 타이머 상태
    if [ -f "${PID_FILE}" ]; then
        local pid
        pid=$(cat "${PID_FILE}")
        if kill -0 "${pid}" 2>/dev/null; then
            echo "[타이머] 실행 중 (PID: ${pid}, 간격: $((TICK_INTERVAL / 60))분)"
        else
            echo "[타이머] 종료됨 (stale PID: ${pid})"
        fi
    else
        echo "[타이머] 미시작"
    fi

    if [ -f "${TICK_FILE}" ]; then
        echo "[마지막 틱] $(cat "${TICK_FILE}")"
    fi
    echo ""

    # poll 실행
    echo "[/usage 조회 중 (pane: ${pane})...]"
    cmd_poll "${pane}"
    echo ""

    # 할당 가능 여부
    echo "[할당 판단]"
    cmd_calc
}

# =============================================================================
# 메인
# =============================================================================

case "${1:-status}" in
    tick)    cmd_tick ;;
    check)   cmd_check ;;
    poll)    cmd_poll "${2:-${MONITOR_PANE}}" ;;
    calc)    cmd_calc ;;
    stop)    cmd_stop ;;
    status)  cmd_status "${2:-${MONITOR_PANE}}" ;;
    *)
        echo "사용법: $0 {tick|check|poll [pane]|calc [N]|stop|status [pane]}"
        exit 1
        ;;
esac
