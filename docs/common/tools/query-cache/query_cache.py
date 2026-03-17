#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""GLUE SQL Query Cache CLI - .glue_sql query source and analysis result cache."""

import argparse
import glob
import hashlib
import json
import os
import sqlite3
import sys
import xml.etree.ElementTree as ET

# --- Defaults ---
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_QUERY_DIR = os.path.normpath(os.path.join(SCRIPT_DIR, '..', '..', '..', '..', 'src', 'query'))
DEFAULT_DB_PATH = os.path.join(SCRIPT_DIR, 'data', 'queries.db')

SCHEMA_SQL = """
CREATE TABLE IF NOT EXISTS source_files (
    source_file  TEXT PRIMARY KEY,
    file_path    TEXT NOT NULL,
    description  TEXT,
    file_size    INTEGER NOT NULL,
    file_hash    TEXT NOT NULL,
    query_count  INTEGER NOT NULL,
    synced_at    TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS queries (
    query_id       TEXT PRIMARY KEY,
    description    TEXT,
    sql            TEXT NOT NULL,
    source_file    TEXT NOT NULL,
    fetch_size     INTEGER DEFAULT 10,
    is_named       INTEGER DEFAULT 1,
    sql_hash       TEXT NOT NULL,
    loaded_at      TEXT DEFAULT (datetime('now')),
    analysis_json  TEXT,
    analyzed_at    TEXT,
    version        INTEGER
);

CREATE INDEX IF NOT EXISTS idx_source ON queries(source_file);
"""


# --- DB Layer ---
AUDIT_COLUMNS = [
    'CREATED_OBJECT_TYPE', 'CREATED_OBJECT_ID', 'CREATED_PROGRAM_ID', 'CREATION_TIMESTAMP',
    'LAST_UPDATED_OBJECT_TYPE', 'LAST_UPDATED_OBJECT_ID', 'LAST_UPDATE_PROGRAM_ID', 'LAST_UPDATE_TIMESTAMP',
    'DATA_END_STATUS', 'DATA_END_OBJECT_TYPE', 'DATA_END_OBJECT_ID', 'DATA_END_PROGRAM_ID', 'DATA_END_TIMESTAMP',
    'ARCHIVE_COMPLETED_FLAG', 'ARCHIVED_EMPLOYEE_NUM', 'ARCHIVED_TIMESTAMP', 'ARCHIVE_PROGRAM_ID',
]


class QueryCacheDB(object):
    def __init__(self, db_path):
        db_dir = os.path.dirname(db_path)
        if db_dir and not os.path.exists(db_dir):
            os.makedirs(db_dir)
        self.conn = sqlite3.connect(db_path)
        self.conn.row_factory = sqlite3.Row
        self.conn.execute("PRAGMA journal_mode=WAL")
        self.conn.executescript(SCHEMA_SQL)
        self.conn.commit()
        self.db_path = db_path
        self._migrate_audit_flags()

    def _migrate_audit_flags(self):
        """One-time migration: set is_audit=1 for known audit columns."""
        try:
            row = self.conn.execute(
                "SELECT COUNT(*) AS c FROM table_columns WHERE is_audit = 1"
            ).fetchone()
            if row and row["c"] == 0:
                # Check if table_columns has any rows at all
                total = self.conn.execute(
                    "SELECT COUNT(*) AS c FROM table_columns"
                ).fetchone()["c"]
                if total > 0:
                    placeholders = ",".join("?" for _ in AUDIT_COLUMNS)
                    self.conn.execute(
                        "UPDATE table_columns SET is_audit = 1 "
                        "WHERE UPPER(column_name) IN (%s)" % placeholders,
                        [c.upper() for c in AUDIT_COLUMNS]
                    )
                    self.conn.commit()
        except sqlite3.OperationalError:
            pass  # table_columns may not exist

    def close(self):
        self.conn.close()

    # -- Table metadata --
    def get_table_info(self, table_names, exclude_audit=True):
        """Look up table metadata + columns for given table names.

        Accepts plain names (TB_C10_XXX) or schema-qualified (MESAPUSER.TB_C10_XXX).
        Returns dict keyed by 'SCHEMA.TABLE'.
        """
        if not table_names:
            return {}

        # Separate schema-qualified and plain names
        qualified = {}  # upper_table -> (schema, table)
        plain = []
        for name in table_names:
            parts = name.split('.', 1)
            if len(parts) == 2:
                qualified[name.upper()] = (parts[0].upper(), parts[1].upper())
            else:
                plain.append(name.upper())

        result = {}

        # Query for schema-qualified names
        for key, (schema, tname) in qualified.items():
            meta_row = self.conn.execute(
                "SELECT schema_owner, table_name, object_type, table_comment, column_count "
                "FROM table_metadata WHERE UPPER(schema_owner) = ? AND UPPER(table_name) = ?",
                (schema, tname)
            ).fetchone()
            if meta_row:
                result_key = "%s.%s" % (meta_row["schema_owner"], meta_row["table_name"])
                result[result_key] = self._build_table_info(meta_row, exclude_audit)

        # Query for plain names (may match multiple schemas)
        if plain:
            placeholders = ",".join("?" for _ in plain)
            meta_rows = self.conn.execute(
                "SELECT schema_owner, table_name, object_type, table_comment, column_count "
                "FROM table_metadata WHERE UPPER(table_name) IN (%s)" % placeholders,
                plain
            ).fetchall()
            for meta_row in meta_rows:
                result_key = "%s.%s" % (meta_row["schema_owner"], meta_row["table_name"])
                result[result_key] = self._build_table_info(meta_row, exclude_audit)

        return result

    def _build_table_info(self, meta_row, exclude_audit):
        """Build table info dict from metadata row + columns."""
        schema = meta_row["schema_owner"]
        tname = meta_row["table_name"]

        audit_filter = " AND is_audit = 0" if exclude_audit else ""
        col_rows = self.conn.execute(
            "SELECT column_name, column_id, data_type, data_length, data_precision, "
            "data_scale, nullable, column_comment, is_pk, pk_position "
            "FROM table_columns WHERE schema_owner = ? AND table_name = ?%s "
            "ORDER BY column_id" % audit_filter,
            (schema, tname)
        ).fetchall()

        columns = []
        for c in col_rows:
            # Build readable data type string
            dt = c["data_type"]
            if dt in ("VARCHAR2", "CHAR", "NVARCHAR2", "RAW") and c["data_length"]:
                dt = "%s(%s)" % (dt, c["data_length"])
            elif dt == "NUMBER" and c["data_precision"]:
                if c["data_scale"] and int(c["data_scale"]) > 0:
                    dt = "NUMBER(%s,%s)" % (c["data_precision"], c["data_scale"])
                else:
                    dt = "NUMBER(%s)" % c["data_precision"]

            columns.append({
                "name": c["column_name"],
                "dataType": dt,
                "nullable": c["nullable"],
                "comment": c["column_comment"] or "",
                "isPk": bool(c["is_pk"]),
                "pkPosition": c["pk_position"] if c["is_pk"] else None,
            })

        return {
            "schemaOwner": schema,
            "tableName": tname,
            "tableComment": meta_row["table_comment"] or "",
            "columns": columns,
        }

    # -- Query lookup --
    def get_query(self, query_id):
        row = self.conn.execute(
            "SELECT query_id, description, sql, source_file, fetch_size, is_named "
            "FROM queries WHERE query_id = ?", (query_id,)
        ).fetchone()
        if row is None:
            return None
        return {
            "queryId": row["query_id"],
            "description": row["description"],
            "sql": row["sql"],
            "sourceFile": row["source_file"],
            "fetchSize": row["fetch_size"],
            "isNamed": bool(row["is_named"]),
        }

    def get_queries(self, query_ids):
        if not query_ids:
            return {}
        placeholders = ",".join("?" for _ in query_ids)
        rows = self.conn.execute(
            "SELECT query_id, description, sql, source_file, fetch_size, is_named "
            "FROM queries WHERE query_id IN (%s)" % placeholders, query_ids
        ).fetchall()
        result = {}
        for row in rows:
            result[row["query_id"]] = {
                "queryId": row["query_id"],
                "description": row["description"],
                "sql": row["sql"],
                "sourceFile": row["source_file"],
                "fetchSize": row["fetch_size"],
                "isNamed": bool(row["is_named"]),
            }
        return result

    def get_queries_by_pattern(self, pattern):
        rows = self.conn.execute(
            "SELECT query_id, description, sql, source_file, fetch_size, is_named "
            "FROM queries WHERE query_id LIKE ?", (pattern,)
        ).fetchall()
        result = {}
        for row in rows:
            result[row["query_id"]] = {
                "queryId": row["query_id"],
                "description": row["description"],
                "sql": row["sql"],
                "sourceFile": row["source_file"],
                "fetchSize": row["fetch_size"],
                "isNamed": bool(row["is_named"]),
            }
        return result

    def list_keys(self, pattern=None, source_file=None):
        if pattern:
            rows = self.conn.execute(
                "SELECT query_id FROM queries WHERE query_id LIKE ? ORDER BY query_id",
                (pattern,)
            ).fetchall()
        elif source_file:
            rows = self.conn.execute(
                "SELECT query_id FROM queries WHERE source_file = ? ORDER BY query_id",
                (source_file,)
            ).fetchall()
        else:
            rows = self.conn.execute(
                "SELECT query_id FROM queries ORDER BY query_id"
            ).fetchall()
        return [row["query_id"] for row in rows]

    # -- Analysis cache --
    def get_analysis(self, query_id):
        row = self.conn.execute(
            "SELECT query_id, analysis_json, analyzed_at, version "
            "FROM queries WHERE query_id = ?", (query_id,)
        ).fetchone()
        if row is None:
            return None
        analysis = None
        if row["analysis_json"] is not None:
            try:
                analysis = json.loads(row["analysis_json"])
            except (ValueError, TypeError):
                analysis = row["analysis_json"]
        return {
            "queryId": row["query_id"],
            "analysis": analysis,
            "analyzedAt": row["analyzed_at"],
            "version": row["version"],
        }

    def get_analyses(self, query_ids):
        if not query_ids:
            return {}
        placeholders = ",".join("?" for _ in query_ids)
        rows = self.conn.execute(
            "SELECT query_id, analysis_json, analyzed_at, version "
            "FROM queries WHERE query_id IN (%s)" % placeholders, query_ids
        ).fetchall()
        result = {}
        for row in rows:
            analysis = None
            if row["analysis_json"] is not None:
                try:
                    analysis = json.loads(row["analysis_json"])
                except (ValueError, TypeError):
                    analysis = row["analysis_json"]
            result[row["query_id"]] = {
                "queryId": row["query_id"],
                "analysis": analysis,
                "analyzedAt": row["analyzed_at"],
                "version": row["version"],
            }
        return result

    def set_analysis(self, query_id, analysis_json, version=1):
        if isinstance(analysis_json, dict):
            analysis_json = json.dumps(analysis_json, ensure_ascii=False)
        cur = self.conn.execute(
            "UPDATE queries SET analysis_json = ?, analyzed_at = datetime('now'), version = ? "
            "WHERE query_id = ?", (analysis_json, version, query_id)
        )
        self.conn.commit()
        return cur.rowcount > 0

    def set_analyses(self, data_dict, version=1):
        saved = 0
        errors = []
        for query_id, analysis in data_dict.items():
            try:
                analysis_str = json.dumps(analysis, ensure_ascii=False) if isinstance(analysis, dict) else analysis
                self.conn.execute(
                    "UPDATE queries SET analysis_json = ?, analyzed_at = datetime('now'), version = ? "
                    "WHERE query_id = ?", (analysis_str, version, query_id)
                )
                saved += 1
            except Exception as e:
                errors.append({"queryId": query_id, "error": str(e)})
        self.conn.commit()
        return saved, errors

    def get_stats(self):
        total = self.conn.execute("SELECT COUNT(*) AS c FROM queries").fetchone()["c"]
        analyzed = self.conn.execute(
            "SELECT COUNT(*) AS c FROM queries WHERE analysis_json IS NOT NULL"
        ).fetchone()["c"]
        files = self.conn.execute(
            "SELECT COUNT(DISTINCT source_file) AS c FROM queries"
        ).fetchone()["c"]
        last_sync = self.conn.execute(
            "SELECT MAX(synced_at) AS t FROM source_files"
        ).fetchone()["t"]
        db_size = os.path.getsize(self.db_path) if os.path.exists(self.db_path) else 0
        rate = "%.1f%%" % (analyzed * 100.0 / total) if total > 0 else "0.0%"
        return {
            "totalQueries": total,
            "totalAnalyzed": analyzed,
            "totalFiles": files,
            "analysisRate": rate,
            "dbSize": db_size,
            "lastSync": last_sync,
        }

    def invalidate(self, query_ids=None, below_version=None, all_flag=False):
        if all_flag:
            cur = self.conn.execute(
                "UPDATE queries SET analysis_json = NULL, analyzed_at = NULL, version = NULL "
                "WHERE analysis_json IS NOT NULL"
            )
        elif below_version is not None:
            cur = self.conn.execute(
                "UPDATE queries SET analysis_json = NULL, analyzed_at = NULL, version = NULL "
                "WHERE version < ?", (below_version,)
            )
        elif query_ids:
            placeholders = ",".join("?" for _ in query_ids)
            cur = self.conn.execute(
                "UPDATE queries SET analysis_json = NULL, analyzed_at = NULL, version = NULL "
                "WHERE query_id IN (%s)" % placeholders, query_ids
            )
        else:
            return 0
        self.conn.commit()
        return cur.rowcount

    def sync(self, query_dir):
        """2-stage sync: file hash -> query hash."""
        files = sorted(glob.glob(os.path.join(query_dir, "*.glue_sql")))
        file_map = {}
        for fp in files:
            fname = os.path.basename(fp)
            file_map[fname] = fp

        # Load existing file hashes from DB
        existing_files = {}
        for row in self.conn.execute("SELECT source_file, file_hash FROM source_files").fetchall():
            existing_files[row["source_file"]] = row["file_hash"]

        added = 0
        updated = 0
        removed = 0

        # Files to process
        files_to_parse = []
        current_file_names = set(file_map.keys())
        db_file_names = set(existing_files.keys())

        # Removed files
        removed_files = db_file_names - current_file_names
        for fname in removed_files:
            cnt = self.conn.execute(
                "SELECT COUNT(*) AS c FROM queries WHERE source_file = ?", (fname,)
            ).fetchone()["c"]
            self.conn.execute("DELETE FROM queries WHERE source_file = ?", (fname,))
            self.conn.execute("DELETE FROM source_files WHERE source_file = ?", (fname,))
            removed += cnt

        # Check each current file
        for fname, fp in file_map.items():
            with open(fp, "rb") as f:
                content = f.read()
            file_hash = hashlib.sha256(content).hexdigest()
            file_size = len(content)

            if fname in existing_files and existing_files[fname] == file_hash:
                continue  # No change, skip

            files_to_parse.append((fname, fp, file_hash, file_size))

        # Parse changed files and do query-level diff
        for fname, fp, file_hash, file_size in files_to_parse:
            try:
                queries, file_desc = parse_glue_sql(fp)
            except Exception as e:
                sys.stderr.write("WARN: Failed to parse %s: %s\n" % (fname, str(e)))
                continue

            # Get existing queries for this file
            existing_queries = {}
            for row in self.conn.execute(
                "SELECT query_id, sql_hash FROM queries WHERE source_file = ?", (fname,)
            ).fetchall():
                existing_queries[row["query_id"]] = row["sql_hash"]

            new_query_ids = set()
            for q in queries:
                qid = q["query_id"]
                new_query_ids.add(qid)
                if qid not in existing_queries:
                    # New query
                    self.conn.execute(
                        "INSERT OR REPLACE INTO queries "
                        "(query_id, description, sql, source_file, fetch_size, is_named, sql_hash) "
                        "VALUES (?, ?, ?, ?, ?, ?, ?)",
                        (qid, q["description"], q["sql"], q["source_file"],
                         q["fetch_size"], q["is_named"], q["sql_hash"])
                    )
                    added += 1
                elif existing_queries[qid] != q["sql_hash"]:
                    # SQL changed - update and invalidate analysis
                    self.conn.execute(
                        "UPDATE queries SET description = ?, sql = ?, sql_hash = ?, "
                        "fetch_size = ?, is_named = ?, loaded_at = datetime('now'), "
                        "analysis_json = NULL, analyzed_at = NULL, version = NULL "
                        "WHERE query_id = ?",
                        (q["description"], q["sql"], q["sql_hash"],
                         q["fetch_size"], q["is_named"], qid)
                    )
                    updated += 1
                # else: sql_hash same, skip (preserve analysis cache)

            # Remove queries that no longer exist in file
            removed_qids = set(existing_queries.keys()) - new_query_ids
            for qid in removed_qids:
                self.conn.execute("DELETE FROM queries WHERE query_id = ?", (qid,))
                removed += 1

            # Upsert source_files
            rel_path = os.path.relpath(fp, os.path.join(SCRIPT_DIR, '..', '..', '..', '..'))
            self.conn.execute(
                "INSERT OR REPLACE INTO source_files "
                "(source_file, file_path, description, file_size, file_hash, query_count) "
                "VALUES (?, ?, ?, ?, ?, ?)",
                (fname, rel_path, file_desc, file_size, file_hash, len(queries))
            )

        self.conn.commit()

        total_queries = self.conn.execute("SELECT COUNT(*) AS c FROM queries").fetchone()["c"]
        total_files = self.conn.execute("SELECT COUNT(*) AS c FROM source_files").fetchone()["c"]

        return {
            "added": added,
            "updated": updated,
            "removed": removed,
            "totalQueries": total_queries,
            "totalFiles": total_files,
        }


# --- Parser ---
def parse_glue_sql(file_path):
    """Parse a single .glue_sql file. Returns (queries_list, file_description)."""
    tree = ET.parse(file_path)
    root = tree.getroot()  # <queryMap>
    file_desc = root.get("desc", "")
    queries = []
    seen_ids = {}
    for elem in root.findall("query"):
        sql_text = (elem.text or "").strip()
        if not sql_text:
            sys.stderr.write("WARN: Empty SQL in %s query %s\n" % (
                os.path.basename(file_path), elem.get("id", "?")))
        qid = elem.get("id")
        if qid in seen_ids:
            seen_ids[qid] += 1
            new_qid = "%s_dup%d" % (qid, seen_ids[qid])
            sys.stderr.write("WARN: Duplicate query_id '%s' in %s, renamed to '%s'\n" % (
                qid, os.path.basename(file_path), new_qid))
            qid = new_qid
        else:
            seen_ids[qid] = 0
        queries.append({
            "query_id": qid,
            "description": elem.get("desc", ""),
            "fetch_size": int(elem.get("fetchSize", "10")),
            "is_named": 1 if elem.get("isNamed", "true") == "true" else 0,
            "sql": sql_text,
            "sql_hash": hashlib.sha256(sql_text.encode("utf-8")).hexdigest(),
            "source_file": os.path.basename(file_path),
        })
    return queries, file_desc


# --- CLI Handlers ---
def cmd_sync(args, db):
    query_dir = args.query_dir or os.environ.get("QUERY_DIR", DEFAULT_QUERY_DIR)
    if not os.path.isdir(query_dir):
        sys.stderr.write("ERROR: Query directory not found: %s\n" % query_dir)
        sys.exit(1)
    result = db.sync(query_dir)
    print(json.dumps(result, ensure_ascii=False))


def cmd_get(args, db):
    result = db.get_query(args.query_id)
    if result is None:
        print(json.dumps({"error": "not_found", "key": args.query_id}, ensure_ascii=False))
    else:
        print(json.dumps(result, ensure_ascii=False))


def cmd_get_batch(args, db):
    if args.pattern:
        results = db.get_queries_by_pattern(args.pattern)
        found = len(results)
        print(json.dumps({"results": results, "found": found}, ensure_ascii=False))
    else:
        query_ids = args.query_ids or []
        if args.stdin:
            stdin_data = sys.stdin.read().strip()
            if stdin_data:
                try:
                    query_ids = json.loads(stdin_data)
                except ValueError:
                    query_ids = [line.strip() for line in stdin_data.split("\n") if line.strip()]
        results = db.get_queries(query_ids)
        not_found = [qid for qid in query_ids if qid not in results]
        print(json.dumps({
            "results": results,
            "found": len(results),
            "notFound": not_found,
        }, ensure_ascii=False))


def cmd_list_keys(args, db):
    keys = db.list_keys(pattern=args.pattern, source_file=args.file)
    print(json.dumps({"keys": keys, "total": len(keys)}, ensure_ascii=False))


def cmd_get_analysis(args, db):
    result = db.get_analysis(args.query_id)
    if result is None:
        print(json.dumps({"error": "not_found", "key": args.query_id}, ensure_ascii=False))
    else:
        print(json.dumps(result, ensure_ascii=False))


def cmd_get_analysis_batch(args, db):
    query_ids = args.query_ids or []
    results = db.get_analyses(query_ids)
    cached = {}
    missed = []
    for qid in query_ids:
        if qid in results and results[qid]["analysis"] is not None:
            cached[qid] = results[qid]
        else:
            missed.append(qid)
    print(json.dumps({
        "results": results,
        "cached": len(cached),
        "missed": missed,
    }, ensure_ascii=False))


def cmd_set_analysis(args, db):
    try:
        analysis = json.loads(args.json_data)
    except ValueError:
        sys.stderr.write("ERROR: Invalid JSON\n")
        sys.exit(1)
    version = args.version if hasattr(args, "version") and args.version else 1
    success = db.set_analysis(args.query_id, analysis, version)
    print(json.dumps({"success": success}, ensure_ascii=False))


def cmd_set_analysis_batch(args, db):
    stdin_data = sys.stdin.read().strip()
    if not stdin_data:
        sys.stderr.write("ERROR: No input from stdin\n")
        sys.exit(1)
    try:
        data = json.loads(stdin_data)
    except ValueError:
        sys.stderr.write("ERROR: Invalid JSON from stdin\n")
        sys.exit(1)
    version = args.version if hasattr(args, "version") and args.version else 1
    saved, errors = db.set_analyses(data, version)
    print(json.dumps({"saved": saved, "errors": errors}, ensure_ascii=False))


def cmd_stats(args, db):
    result = db.get_stats()
    print(json.dumps(result, ensure_ascii=False))


def cmd_invalidate(args, db):
    count = db.invalidate(
        query_ids=args.query_ids if args.query_ids else None,
        below_version=args.below_version,
        all_flag=args.all,
    )
    print(json.dumps({"invalidated": count}, ensure_ascii=False))


def cmd_table_info(args, db):
    table_names = args.table_names
    exclude_audit = not args.include_audit
    result = db.get_table_info(table_names, exclude_audit=exclude_audit)
    print(json.dumps(result, ensure_ascii=False, indent=2))


# --- Entry Point ---
def main():
    db_path = os.environ.get("DB_PATH", DEFAULT_DB_PATH)

    parser = argparse.ArgumentParser(
        description="GLUE SQL Query Cache CLI"
    )
    parser.add_argument("--db", default=db_path, help="SQLite DB path")
    sub = parser.add_subparsers(dest="command")

    # sync
    p_sync = sub.add_parser("sync", help="Sync .glue_sql files to DB")
    p_sync.add_argument("--query-dir", help="Query directory path")

    # get
    p_get = sub.add_parser("get", help="Get single query")
    p_get.add_argument("query_id", help="Query ID")

    # get-batch
    p_gb = sub.add_parser("get-batch", help="Get multiple queries")
    p_gb.add_argument("query_ids", nargs="*", help="Query IDs")
    p_gb.add_argument("--pattern", help="LIKE pattern")
    p_gb.add_argument("--stdin", action="store_true", help="Read IDs from stdin")

    # list-keys
    p_lk = sub.add_parser("list-keys", help="List query IDs")
    p_lk.add_argument("--pattern", help="LIKE pattern")
    p_lk.add_argument("--file", help="Source file name")

    # get-analysis
    p_ga = sub.add_parser("get-analysis", help="Get analysis result")
    p_ga.add_argument("query_id", help="Query ID")

    # get-analysis-batch
    p_gab = sub.add_parser("get-analysis-batch", help="Get analysis results batch")
    p_gab.add_argument("query_ids", nargs="*", help="Query IDs")

    # set-analysis
    p_sa = sub.add_parser("set-analysis", help="Set analysis result")
    p_sa.add_argument("query_id", help="Query ID")
    p_sa.add_argument("json_data", help="Analysis JSON")
    p_sa.add_argument("--version", type=int, default=1, help="Analysis version")

    # set-analysis-batch
    p_sab = sub.add_parser("set-analysis-batch", help="Set analysis results batch (stdin)")
    p_sab.add_argument("source", nargs="?", default="-", help="'-' for stdin")
    p_sab.add_argument("--version", type=int, default=1, help="Analysis version")

    # stats
    sub.add_parser("stats", help="Show DB statistics")

    # invalidate
    p_inv = sub.add_parser("invalidate", help="Invalidate analysis cache")
    p_inv.add_argument("query_ids", nargs="*", help="Query IDs to invalidate")
    p_inv.add_argument("--below-version", type=int, help="Invalidate below version")
    p_inv.add_argument("--all", action="store_true", help="Invalidate all")

    # table-info
    p_ti = sub.add_parser("table-info", help="Get table metadata and columns")
    p_ti.add_argument("table_names", nargs="+", help="Table names (e.g. TB_C10_XXX or MESAPUSER.TB_C10_XXX)")
    p_ti.add_argument("--include-audit", action="store_true", help="Include audit columns")

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    db = QueryCacheDB(args.db)
    try:
        handlers = {
            "sync": cmd_sync,
            "get": cmd_get,
            "get-batch": cmd_get_batch,
            "list-keys": cmd_list_keys,
            "get-analysis": cmd_get_analysis,
            "get-analysis-batch": cmd_get_analysis_batch,
            "set-analysis": cmd_set_analysis,
            "set-analysis-batch": cmd_set_analysis_batch,
            "stats": cmd_stats,
            "invalidate": cmd_invalidate,
            "table-info": cmd_table_info,
        }
        handlers[args.command](args, db)
    finally:
        db.close()


if __name__ == "__main__":
    main()
