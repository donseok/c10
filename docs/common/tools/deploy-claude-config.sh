#!/bin/bash
# deploy-claude-config.sh
# Claude Code 설정을 다른 MES 프로젝트에 배포하는 스크립트
#
# 사용법:
#   ./docs/common/tools/deploy-claude-config.sh <대상-프로젝트-경로> [모듈ID]
#   ./docs/common/tools/deploy-claude-config.sh --dry-run <대상-프로젝트-경로> [모듈ID]
#
# 예시:
#   ./docs/common/tools/deploy-claude-config.sh ../m20 M20
#   ./docs/common/tools/deploy-claude-config.sh --dry-run /home/jji/project/mes-workspace/m42
#
# 일괄 배포:
#   for mod in c10 m20 m26 m42 m60 m77 m80 pda; do
#     ./docs/common/tools/deploy-claude-config.sh "../$mod"
#   done

set -euo pipefail

# === 색상 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# === 소스 디렉토리 (이 스크립트가 위치한 프로젝트 기준) ===
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_PROJECT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# === 인자 파싱 ===
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    shift
fi

if [[ $# -lt 1 ]]; then
    echo -e "${RED}사용법: $0 [--dry-run] <대상-프로젝트-경로> [모듈ID]${NC}"
    echo ""
    echo "  대상-프로젝트-경로: 배포할 MES 프로젝트 디렉토리"
    echo "  모듈ID:            대문자 모듈 ID (생략 시 디렉토리명에서 추출)"
    echo ""
    echo "예시:"
    echo "  $0 ../m20 M20"
    echo "  $0 --dry-run ../m42"
    echo ""
    echo "일괄 배포:"
    echo "  for mod in c10 m20 m26 m42 m60 m77 m80 pda; do"
    echo "    $0 \"../\$mod\""
    echo "  done"
    exit 1
fi

TARGET="$(cd "$1" 2>/dev/null && pwd)" || {
    echo -e "${RED}오류: 대상 경로가 존재하지 않습니다: $1${NC}"
    exit 1
}

# 소스 모듈 ID 결정 (디렉토리명에서 자동 추출)
SRC_MOD_LOWER="$(basename "$SRC_PROJECT")"
SRC_MOD_UPPER="$(echo "$SRC_MOD_LOWER" | tr 'a-z' 'A-Z')"
SRC_MOD_NUM="${SRC_MOD_UPPER:1}"   # 앞글자 제거 (C10→10, M30→30)

# 대상 모듈 ID 결정
if [[ $# -ge 2 ]]; then
    MOD_UPPER="$2"
else
    MOD_UPPER="$(basename "$TARGET" | tr 'a-z' 'A-Z')"
fi
MOD_LOWER="$(echo "$MOD_UPPER" | tr 'A-Z' 'a-z')"
MOD_NUM="${MOD_UPPER:1}"   # 앞글자 제거 (M20→20, C10→10)

# === 안전 검사 ===
if [[ "$SRC_PROJECT" == "$TARGET" ]]; then
    echo -e "${RED}오류: 소스와 대상이 같은 프로젝트입니다.${NC}"
    exit 1
fi

# === 요약 출력 ===
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN} Claude Code 설정 배포${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "  소스:   ${GREEN}$SRC_PROJECT${NC}"
echo -e "  대상:   ${GREEN}$TARGET${NC}"
echo -e "  모듈ID: ${GREEN}$MOD_UPPER${NC} / ${GREEN}$MOD_LOWER${NC}"
if $DRY_RUN; then
    echo -e "  모드:   ${YELLOW}DRY-RUN (실제 변경 없음)${NC}"
fi
echo -e "${CYAN}========================================${NC}"
echo ""

# 기존 .claude/ 존재 시 확인
if [[ -d "$TARGET/.claude" ]] && ! $DRY_RUN; then
    echo -e "${YELLOW}경고: 대상에 .claude/ 디렉토리가 이미 존재합니다.${NC}"
    read -p "덮어쓰시겠습니까? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "취소되었습니다."
        exit 0
    fi
fi

# === 헬퍼 함수 ===
run_cmd() {
    if $DRY_RUN; then
        echo -e "  ${YELLOW}[DRY-RUN]${NC} $1"
    else
        echo -e "  ${GREEN}[실행]${NC} $1"
        eval "$2"
    fi
}

# === 1. .claude/ 복사 ===
echo -e "\n${CYAN}[1/6] .claude/ 디렉토리 복사${NC}"
run_cmd "rsync .claude/ → $TARGET/.claude/" \
    "rsync -a --exclude='__pycache__' --exclude='*.pyc' --exclude='projects/' --exclude='plans/' '$SRC_PROJECT/.claude/' '$TARGET/.claude/'"

# === 2. .mcp.json 복사 ===
echo -e "\n${CYAN}[2/6] .mcp.json 복사${NC}"
run_cmd "cp .mcp.json → $TARGET/.mcp.json" \
    "cp '$SRC_PROJECT/.mcp.json' '$TARGET/.mcp.json'"

# === 3. CLAUDE.md 복사 + 모듈 ID 치환 ===
echo -e "\n${CYAN}[3/6] CLAUDE.md 복사 (${SRC_MOD_UPPER} → ${MOD_UPPER}, ${SRC_MOD_LOWER} → ${MOD_LOWER})${NC}"
run_cmd "sed ${SRC_MOD_UPPER}→${MOD_UPPER}, ${SRC_MOD_LOWER}→${MOD_LOWER} → $TARGET/CLAUDE.md" \
    "sed -e 's/${SRC_MOD_UPPER}/${MOD_UPPER}/g' -e 's/${SRC_MOD_LOWER}/${MOD_LOWER}/g' -e 's/B${SRC_MOD_NUM}R/B${MOD_NUM}R/g' '$SRC_PROJECT/CLAUDE.md' > '$TARGET/CLAUDE.md'"

# === 4. docs/ 복사 ===
echo -e "\n${CYAN}[4/6] docs/ 복사${NC}"
run_cmd "rsync docs/common/ → $TARGET/docs/common/" \
    "mkdir -p '$TARGET/docs/common' && rsync -a --exclude='__pycache__' --exclude='*.pyc' '$SRC_PROJECT/docs/common/' '$TARGET/docs/common/'"
run_cmd "mkdir docs/analysis/ 구조" \
    "mkdir -p '$TARGET/docs/analysis/process' && touch '$TARGET/docs/analysis/.gitkeep' '$TARGET/docs/analysis/process/.gitkeep'"

# === 5. .gitignore 업데이트 ===
echo -e "\n${CYAN}[5/6] .gitignore 업데이트${NC}"
GITIGNORE_ENTRIES=("nul" "**/.temp/**" ".serena")
if [[ -f "$TARGET/.gitignore" ]]; then
    for entry in "${GITIGNORE_ENTRIES[@]}"; do
        if grep -qxF "$entry" "$TARGET/.gitignore" 2>/dev/null; then
            run_cmd ".gitignore: '$entry' 이미 존재 (skip)" "true"
        else
            run_cmd ".gitignore: '$entry' 추가" \
                "echo '$entry' >> '$TARGET/.gitignore'"
        fi
    done
    # .iml 항목을 *.iml로 통일
    if grep -q 'M20\.iml' "$TARGET/.gitignore" 2>/dev/null; then
        run_cmd ".gitignore: M20.iml → *.iml 변경" \
            "sed -i '' 's/^M20\\.iml\$/*.iml/' '$TARGET/.gitignore' 2>/dev/null || sed -i 's/^M20\\.iml\$/*.iml/' '$TARGET/.gitignore'"
    fi
else
    run_cmd ".gitignore 파일 없음 - 건너뜀" "true"
fi

# === 6. queries.db 데이터 초기화 + batch_state.json 리셋 ===
echo -e "\n${CYAN}[6/6] queries.db 데이터 초기화${NC}"
QUERIES_DB="$TARGET/docs/common/tools/query-cache/data/queries.db"
BATCH_STATE="$TARGET/docs/common/tools/query-cache/data/batch_state.json"

if [[ -f "$QUERIES_DB" ]]; then
    run_cmd "DELETE FROM queries, source_files + VACUUM" \
        "sqlite3 '$QUERIES_DB' 'DELETE FROM queries; DELETE FROM source_files; VACUUM;'"
else
    run_cmd "queries.db 아직 없음 (복사 직후 초기화)" "true"
    if ! $DRY_RUN && [[ -f "$SRC_PROJECT/docs/common/tools/query-cache/data/queries.db" ]]; then
        sqlite3 "$QUERIES_DB" 'DELETE FROM queries; DELETE FROM source_files; VACUUM;'
    fi
fi

run_cmd "batch_state.json 초기화" \
    "echo '{}' > '$BATCH_STATE'"

# === 결과 요약 ===
echo ""
echo -e "${CYAN}========================================${NC}"
if $DRY_RUN; then
    echo -e "${YELLOW} DRY-RUN 완료 (실제 변경 없음)${NC}"
else
    echo -e "${GREEN} 배포 완료!${NC}"
fi
echo -e "${CYAN}========================================${NC}"
echo -e "  대상: $TARGET"
echo -e "  모듈: $MOD_UPPER"

if ! $DRY_RUN; then
    echo ""
    echo -e "  복사된 항목:"
    echo -e "    .claude/    $(find "$TARGET/.claude" -type f 2>/dev/null | wc -l)개 파일"
    echo -e "    .mcp.json   OK"
    echo -e "    CLAUDE.md   OK (${SRC_MOD_UPPER}→${MOD_UPPER})"
    echo -e "    docs/       $(find "$TARGET/docs" -type f 2>/dev/null | wc -l)개 파일"
    echo ""
    echo -e "  queries.db:   $(sqlite3 "$QUERIES_DB" 'SELECT COUNT(*) FROM queries;' 2>/dev/null || echo '?')건"
fi
echo -e "${CYAN}========================================${NC}"
