#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Phase 3: SQL 쿼리 분석 스크립트
M47CoilInsAct 서비스의 SQL 쿼리를 분석하여 메타데이터 추출
"""

import json
import re
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Set
from collections import defaultdict

class SQLAnalyzer:
    """SQL 쿼리 분석기"""

    def __init__(self, structure_file: str, output_file: str):
        self.structure_file = Path(structure_file)
        self.output_file = Path(output_file)
        self.structure_data = None
        self.sql_queries = {}
        self.analysis_result = {}

    def load_structure(self):
        """structure.json 로드"""
        with open(self.structure_file, 'r', encoding='utf-8') as f:
            self.structure_data = json.load(f)
        print(f"✅ Structure 로드 완료: {self.structure_file}")

    def extract_sql_keys(self) -> List[str]:
        """SQL Key 목록 추출"""
        sql_keys = set()

        if 'dataFlow' in self.structure_data and 'sqlQueries' in self.structure_data['dataFlow']:
            for key in self.structure_data['dataFlow']['sqlQueries']:
                sql_keys.add(key)

        return sorted(list(sql_keys))

    def determine_query_type(self, query: str) -> str:
        """쿼리 타입 결정"""
        query_upper = query.upper()

        if 'CALL' in query_upper or 'PROCEDURE' in query_upper:
            return 'PROCEDURE'
        elif query_upper.strip().startswith('SELECT'):
            return 'SELECT'
        elif query_upper.strip().startswith('INSERT'):
            return 'INSERT'
        elif query_upper.strip().startswith('UPDATE'):
            return 'UPDATE'
        elif query_upper.strip().startswith('DELETE'):
            return 'DELETE'
        elif 'MERGE' in query_upper:
            return 'MERGE'
        else:
            return 'UNKNOWN'

    def extract_tables(self, query: str, query_type: str) -> List[Dict[str, Any]]:
        """테이블 정보 추출"""
        tables = []
        query_upper = query.upper()

        # FROM 절 테이블 추출
        from_pattern = r'FROM\s+([A-Z0-9_]+\.)?([A-Z0-9_]+)(?:\s+([A-Z0-9_]+))?'
        for match in re.finditer(from_pattern, query_upper):
            schema = match.group(1).rstrip('.') if match.group(1) else None
            table_name = match.group(2)
            alias = match.group(3)

            tables.append({
                "tableName": table_name,
                "alias": alias,
                "role": "메인 테이블" if len(tables) == 0 else "참조 테이블",
                "accessPattern": query_type
            })

        # INTO 절 테이블 추출 (INSERT)
        into_pattern = r'INTO\s+([A-Z0-9_]+\.)?([A-Z0-9_]+)'
        for match in re.finditer(into_pattern, query_upper):
            table_name = match.group(2)
            if not any(t['tableName'] == table_name for t in tables):
                tables.append({
                    "tableName": table_name,
                    "alias": None,
                    "role": "메인 테이블",
                    "accessPattern": "INSERT"
                })

        # UPDATE 절 테이블 추출
        update_pattern = r'UPDATE\s+([A-Z0-9_]+\.)?([A-Z0-9_]+)'
        for match in re.finditer(update_pattern, query_upper):
            table_name = match.group(2)
            if not any(t['tableName'] == table_name for t in tables):
                tables.append({
                    "tableName": table_name,
                    "alias": None,
                    "role": "메인 테이블",
                    "accessPattern": "UPDATE"
                })

        # DELETE FROM 절 테이블 추출
        delete_pattern = r'DELETE\s+(?:/\*\+.*?\*/)?\s*([A-Z0-9_]+\.)?([A-Z0-9_]+)'
        for match in re.finditer(delete_pattern, query_upper):
            table_name = match.group(2)
            if not any(t['tableName'] == table_name for t in tables):
                tables.append({
                    "tableName": table_name,
                    "alias": None,
                    "role": "메인 테이블",
                    "accessPattern": "DELETE"
                })

        # JOIN 절 테이블 추출
        join_pattern = r'(?:INNER|LEFT|RIGHT|FULL)?\s*JOIN\s+([A-Z0-9_]+\.)?([A-Z0-9_]+)(?:\s+([A-Z0-9_]+))?'
        for match in re.finditer(join_pattern, query_upper):
            table_name = match.group(2)
            alias = match.group(3)

            if not any(t['tableName'] == table_name for t in tables):
                tables.append({
                    "tableName": table_name,
                    "alias": alias,
                    "role": "조인 테이블",
                    "accessPattern": "JOIN"
                })

        return tables

    def extract_parameters(self, query: str) -> List[Dict[str, Any]]:
        """파라미터 추출"""
        parameters = []

        # :param 형식 추출
        param_pattern = r':([A-Z0-9_]+)'
        param_names = set(re.findall(param_pattern, query.upper()))

        # 시스템 파라미터 제외
        system_params = {'OBJECTTYPE', 'OBJECTID', 'PROGRAMID', 'TIMESTAMP'}
        param_names = param_names - system_params

        for param in sorted(param_names):
            parameters.append({
                "name": param,
                "type": "VARCHAR2",  # 기본값
                "required": True,
                "description": f"입력 파라미터: {param}"
            })

        return parameters

    def extract_joins(self, query: str) -> List[Dict[str, Any]]:
        """JOIN 정보 추출"""
        joins = []
        query_upper = query.upper()

        # JOIN 패턴 매칭
        join_pattern = r'(INNER|LEFT|RIGHT|FULL)?\s*JOIN\s+([A-Z0-9_]+\.)?([A-Z0-9_]+)\s+([A-Z0-9_]+)?\s+ON\s+([^\n]+?)(?=WHERE|AND|GROUP|ORDER|INNER|LEFT|RIGHT|FULL|$)'

        for match in re.finditer(join_pattern, query_upper, re.MULTILINE):
            join_type = match.group(1) if match.group(1) else 'INNER'
            right_table = match.group(3)
            condition = match.group(5).strip()

            joins.append({
                "type": join_type,
                "leftTable": "MAIN",  # 첫 번째 테이블
                "rightTable": right_table,
                "condition": condition[:100]  # 조건 길이 제한
            })

        return joins

    def extract_columns(self, query: str, tables: List[Dict]) -> List[Dict[str, Any]]:
        """컬럼 정보 추출"""
        columns = []
        query_upper = query.upper()

        # SELECT 절 컬럼 추출
        if 'SELECT' in query_upper:
            select_match = re.search(r'SELECT\s+(.*?)\s+FROM', query_upper, re.DOTALL)
            if select_match:
                select_clause = select_match.group(1)

                # 간단한 컬럼 추출 (복잡한 경우는 생략)
                col_pattern = r'([A-Z0-9_]+\.)?([A-Z0-9_]+)(?:\s+AS\s+([A-Z0-9_]+))?'
                for match in re.finditer(col_pattern, select_clause):
                    table_alias = match.group(1).rstrip('.') if match.group(1) else None
                    col_name = match.group(2)
                    col_alias = match.group(3)

                    # 키워드 제외
                    if col_name not in ['SELECT', 'DISTINCT', 'FROM', 'WHERE', 'AND', 'OR']:
                        columns.append({
                            "name": col_alias if col_alias else col_name,
                            "tableName": self._resolve_table_name(table_alias, tables),
                            "tableAlias": table_alias,
                            "dataType": "VARCHAR2",
                            "isPrimaryKey": False,
                            "isForeignKey": False,
                            "expression": None
                        })

        return columns[:50]  # 최대 50개로 제한

    def _resolve_table_name(self, alias: str, tables: List[Dict]) -> str:
        """테이블 별칭을 실제 테이블명으로 변환"""
        if not alias:
            return tables[0]['tableName'] if tables else 'UNKNOWN'

        for table in tables:
            if table['alias'] == alias:
                return table['tableName']

        return 'UNKNOWN'

    def determine_complexity(self, query: str, joins: List, tables: List) -> str:
        """쿼리 복잡도 결정"""
        if len(joins) > 3 or len(tables) > 4:
            return "Complex"
        elif len(joins) > 1 or len(tables) > 2:
            return "Medium"
        else:
            return "Simple"

    def analyze_query(self, query_id: str, query_data: Dict) -> Dict[str, Any]:
        """개별 쿼리 분석"""
        query = query_data.get('query', '')

        # CDATA 제거
        query = re.sub(r'<!\[CDATA\[(.*?)\]\]>', r'\1', query, flags=re.DOTALL)
        query = query.strip()

        # 쿼리 타입 결정
        query_type = self.determine_query_type(query)

        # 테이블 추출
        tables = self.extract_tables(query, query_type)

        # 파라미터 추출
        parameters = self.extract_parameters(query)

        # JOIN 추출
        joins = self.extract_joins(query)

        # 컬럼 추출
        columns = self.extract_columns(query, tables)

        # 복잡도 결정
        complexity = self.determine_complexity(query, joins, tables)

        # 비즈니스 목적 추론
        business_purpose = self._infer_business_purpose(query_id, query_type, query_data.get('desc', ''))

        return {
            "queryId": query_id,
            "description": query_data.get('desc', ''),
            "queryType": query_type,
            "parameters": parameters,
            "tables": tables,
            "columns": columns,
            "joins": joins,
            "businessPurpose": business_purpose,
            "queryLogic": query_data.get('desc', '')[:200],
            "performanceInfo": {
                "hasIndex": "분석 필요",
                "queryComplexity": complexity,
                "estimatedRows": "분석 필요"
            }
        }

    def _infer_business_purpose(self, query_id: str, query_type: str, description: str) -> str:
        """비즈니스 목적 추론"""
        purpose_map = {
            'SELECT': '데이터 조회',
            'INSERT': '데이터 등록',
            'UPDATE': '데이터 수정',
            'DELETE': '데이터 삭제',
            'PROCEDURE': '프로시저 호출',
            'MERGE': '데이터 병합'
        }

        base_purpose = purpose_map.get(query_type, '알 수 없음')

        if description:
            return f"{base_purpose}: {description}"
        else:
            return base_purpose

    def build_er_diagram(self, all_queries: List[Dict]) -> Dict[str, Any]:
        """ER 다이어그램 구성"""
        relationships = []
        table_relations = defaultdict(list)

        for query in all_queries:
            for join in query.get('joins', []):
                left_table = join['leftTable']
                right_table = join['rightTable']

                # 중복 제거
                rel_key = f"{left_table}-{right_table}"
                if rel_key not in [r['description'] for r in relationships]:
                    relationships.append({
                        "from": left_table,
                        "to": right_table,
                        "type": "N:1",  # 기본값
                        "joinKey": join['condition'][:50],
                        "description": rel_key
                    })

        return {
            "relationships": relationships
        }

    def aggregate_table_info(self, all_queries: List[Dict]) -> List[Dict]:
        """테이블 정보 집계"""
        table_map = defaultdict(lambda: {
            "tableName": "",
            "tableDescription": "",
            "role": set(),
            "accessPattern": set(),
            "columns": []
        })

        for query in all_queries:
            for table in query.get('tables', []):
                table_name = table['tableName']
                table_map[table_name]['tableName'] = table_name
                table_map[table_name]['role'].add(table['role'])
                table_map[table_name]['accessPattern'].add(table['accessPattern'])

        # Set을 문자열로 변환
        result = []
        for table_name, info in table_map.items():
            result.append({
                "tableName": table_name,
                "tableDescription": f"{table_name} 테이블",
                "role": ", ".join(info['role']),
                "accessPattern": ", ".join(info['accessPattern']),
                "columns": []
            })

        return sorted(result, key=lambda x: x['tableName'])

    def run_analysis(self, sql_cache_data: Dict):
        """전체 분석 실행"""
        print("\n🚀 Phase 3 SQL 분석 시작...")

        # SQL Key 추출
        sql_keys = self.extract_sql_keys()
        print(f"📊 총 {len(sql_keys)}개의 SQL Key 발견")

        # 각 쿼리 분석
        query_details = []
        for sql_key in sql_keys:
            if sql_key in sql_cache_data:
                query_data = sql_cache_data[sql_key]
                analysis = self.analyze_query(sql_key, query_data)
                query_details.append(analysis)
                print(f"  ✓ {sql_key} 분석 완료")
            else:
                print(f"  ⚠ {sql_key} - 캐시에서 찾을 수 없음")

        # ER 다이어그램 구성
        er_diagram = self.build_er_diagram(query_details)

        # 테이블 정보 집계
        tables = self.aggregate_table_info(query_details)

        # 결과 구성
        self.analysis_result = {
            "serviceInfo": {
                "serviceId": self.structure_data['serviceInfo']['serviceId'],
                "serviceName": self.structure_data['serviceInfo']['serviceName'],
                "processCode": self.structure_data['serviceInfo']['processCode'],
                "analysisDate": datetime.now().strftime("%Y-%m-%d"),
                "numberOfQuery": len(query_details)
            },
            "hasQuery": len(query_details) > 0,
            "sqlAnalysis": {
                "totalQueries": len(query_details),
                "queryDetails": query_details,
                "tables": tables,
                "dataFlow": {
                    "inputParameters": [],
                    "outputData": []
                },
                "businessRules": []
            },
            "erDiagram": er_diagram
        }

        print(f"\n✅ 분석 완료: {len(query_details)}개 쿼리")

    def save_result(self):
        """결과 저장"""
        self.output_file.parent.mkdir(parents=True, exist_ok=True)

        with open(self.output_file, 'w', encoding='utf-8') as f:
            json.dump(self.analysis_result, f, ensure_ascii=False, indent=2)

        print(f"💾 결과 저장: {self.output_file}")


def main():
    """메인 함수"""
    import sys

    if len(sys.argv) < 2:
        print("Usage: python phase3_sql_analyzer.py <SERVICE_ID>")
        sys.exit(1)

    service_id = sys.argv[1]
    process_code = 'm' + service_id[1:3].lower()
    if service_id[1:3] == '10':
        process_code = 'c10'

    structure_file = f"./docs/legacy_analysis/{process_code}/.temp/{service_id}_structure.json"
    output_file = f"./docs/legacy_analysis/{process_code}/.temp/{service_id}_sql_analysis.json"

    # SQL 캐시 로드 (JSON-cache MCP에서 추출한 데이터 사용)
    # 실제로는 MCP를 통해 쿼리해야 하지만, 여기서는 파일로 대체
    cache_file = f"./Legacy/{process_code}.query.json"

    print(f"📁 Structure 파일: {structure_file}")
    print(f"📁 SQL 캐시 파일: {cache_file}")
    print(f"📁 출력 파일: {output_file}")

    # 분석기 실행
    analyzer = SQLAnalyzer(structure_file, output_file)
    analyzer.load_structure()

    # SQL 캐시 로드
    with open(cache_file, 'r', encoding='utf-8') as f:
        sql_cache = json.load(f)

    analyzer.run_analysis(sql_cache)
    analyzer.save_result()

    print("\n✨ Phase 3 완료!")


if __name__ == "__main__":
    main()
