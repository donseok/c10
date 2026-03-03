# GLUE SQL Query Cache CLI

M47 레거시 분석용 `.glue_sql` 쿼리 원문/분석 결과 영속 캐시 도구.

## 데이터 소스

- **경로**: `src/query/*.glue_sql` (451개 파일, ~2,542개 쿼리)
- **형식**: XML (`<queryMap>` 루트, `<query>` 엘리먼트에 CDATA SQL 포함)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<queryMap desc="ROLL압연실적수신">
  <query id="B475107_ROL헤더정보조회_SELECT" desc="" fetchSize="100" isNamed="true">
    <![CDATA[
      SELECT /*+ M47 ... */ PO_NO, SEQ_NO, ROLL_NO
        FROM TB_M47_ROLL_HEDR
       WHERE ROLL_NO = :ROLL_NO
    ]]>
  </query>
</queryMap>
```

| 속성 | 설명 | 기본값 |
|------|------|--------|
| `id` | 쿼리 ID (캐시 PK) | 필수 |
| `desc` | 쿼리 설명 | `""` |
| `fetchSize` | 페치 크기 | `10` |
| `isNamed` | Named Parameter 여부 | `true` |

## 요구사항

- Python 3.6+ (표준 라이브러리만 사용, 외부 의존성 없음)

## 빠른 시작

```bash
# 1. DB 동기화 (첫 실행 시 DB 자동 생성)
python3 query_cache.py sync

# 2. 통계 확인
python3 query_cache.py stats

# 3. 쿼리 조회
python3 query_cache.py get M472020010pop06_Grid_1.select
```

## 명령어

### sync - DB 동기화

`.glue_sql` 파일을 파싱하여 DB에 동기화. 2-Stage 변경 감지(파일 해시 → 쿼리 해시)로 변경분만 처리.

```bash
python3 query_cache.py sync
python3 query_cache.py sync --query-dir /path/to/query
```

### get - 단일 쿼리 조회

```bash
python3 query_cache.py get <query_id>
```

### get-batch - 배치 쿼리 조회

```bash
python3 query_cache.py get-batch key1 key2 key3
python3 query_cache.py get-batch --pattern "M472020010%"
```

### list-keys - 쿼리 ID 검색

```bash
python3 query_cache.py list-keys --pattern "M472020010%"
python3 query_cache.py list-keys --file "M472020010-query.glue_sql"
```

### get-analysis - 분석 결과 조회

```bash
python3 query_cache.py get-analysis <query_id>
```

### get-analysis-batch - 분석 결과 배치 조회

cached/missed로 분류하여 반환.

```bash
python3 query_cache.py get-analysis-batch key1 key2 key3
```

### set-analysis - 분석 결과 저장

```bash
python3 query_cache.py set-analysis <query_id> '{"type":"SELECT","tables":["TB_M47_XX"]}'
```

### set-analysis-batch - 분석 결과 배치 저장

stdin으로 JSON 입력.

```bash
python3 query_cache.py set-analysis-batch - <<'EOF'
{"key1": {"type": "SELECT"}, "key2": {"type": "UPDATE"}}
EOF
```

### stats - 통계

```bash
python3 query_cache.py stats
# {"totalQueries": 2539, "totalAnalyzed": 0, "totalFiles": 432, "analysisRate": "0.0%", ...}
```

### invalidate - 분석 캐시 무효화

```bash
python3 query_cache.py invalidate key1 key2        # 특정 쿼리
python3 query_cache.py invalidate --below-version 2 # 특정 버전 이하
python3 query_cache.py invalidate --all              # 전체
```

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `QUERY_DIR` | `../../../../src/query` (스크립트 기준) | `.glue_sql` 파일 디렉토리 |
| `DB_PATH` | `data/queries.db` (스크립트 기준) | SQLite DB 경로 |

## Phase 3 연동 패턴

```bash
python3 query_cache.py sync                          # 1회
python3 query_cache.py get-batch key1 key2 ...       # 1회
python3 query_cache.py get-analysis-batch key1 ...   # 1회 (cached/missed 분류)
# Claude 내부: missed 쿼리만 분석
python3 query_cache.py set-analysis-batch - <<'EOF'  # 1회
{"key1": {...}, "key2": {...}}
EOF
```

총 CLI 호출: **4회** (쿼리 개수에 무관)

## DB 복구

DB 손상 시 삭제 후 재동기화:

```bash
rm data/queries.db
python3 query_cache.py sync
```

L1(쿼리 원문)은 완전 복구. L2(분석 결과)는 재분석 필요.
