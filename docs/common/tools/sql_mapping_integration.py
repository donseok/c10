#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SQL 매핑 통합 분석 유틸리티

Phase 2 Java 분석에서 발견된 SQL 매핑을 Phase 3 SQL 분석에 통합하기 위한 유틸리티.
- Java 상수 정의 파싱 (M77ConstantsIF 등)
- SQL 매핑 패턴 추출 및 해석
- structure.json sqlQueries 배열에 통합
- 중복 제거 및 메타데이터 생성

Author: Claude Code
Created: 2025-10-31
"""

import re
import json
import os
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass
from collections import defaultdict

@dataclass
class SQLMapping:
    """SQL 매핑 정보를 담는 데이터 클래스"""
    constant_name: str
    resolved_key: str
    line_number: int
    method_name: str
    pattern: str
    confidence: str
    source_file: str
    package_name: str

class SQLMappingAnalyzer:
    """SQL 매핑 분석기"""

    def __init__(self, service_id: str, process_code: str):
        self.service_id = service_id
        self.process_code = process_code
        self.sql_constants = {}  # 상수명 -> 실제 SQL 키 매핑
        self.extracted_mappings = []  # 추출된 SQL 매핑 목록

    def parse_constants_file(self, constants_file_path: str) -> Dict[str, str]:
        """
        M77ConstantsIF.java 등 상수 정의 파일을 파싱하여 SQL 상수 매핑 생성

        Args:
            constants_file_path: 상수 정의 파일 경로

        Returns:
            상수명 -> SQL 키 매핑 딕셔너리
        """
        try:
            with open(constants_file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # SQL 관련 상수 추출 정규식
            sql_constant_pattern = r'public\s+static\s+final\s+String\s+([A-Z_]+SQL\d*)\s*=\s*"([^"]+)"'
            matches = re.findall(sql_constant_pattern, content)

            constants = {}
            for constant_name, sql_key in matches:
                constants[constant_name] = sql_key

            self.sql_constants = constants
            print(f"[OK] SQL 상수 {len(constants)}개 추출됨")

            return constants

        except FileNotFoundError:
            print(f"[WARN] 상수 정의 파일을 찾을 수 없음: {constants_file_path}")
            return {}
        except Exception as e:
            print(f"[ERROR] 상수 정의 파일 파싱 오류: {e}")
            return {}

    def extract_sql_patterns_from_java(self, java_file_path: str) -> List[SQLMapping]:
        """
        Java 파일에서 SQL 매핑 패턴 추출

        Args:
            java_file_path: Java 소스 파일 경로

        Returns:
            추출된 SQL 매핑 목록
        """
        try:
            with open(java_file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # SQL 매핑 패턴 정규식
            sql_patterns = [
                r'getProperty\(M77ConstantsIF\.([A-Z_]+SQL\d*)\)',  # 기본 패턴
                r'setNamedParameter\([^,]+,\s*getProperty\([^)]+\)\)',  # 파라미터 결합 패턴
                r'dao\.(find|insert|update|delete)\(getProperty\([^)]+\)',  # DAO 메서드 호출 패턴
            ]

            mappings = []

            # 각 라인을 분석하여 SQL 매핑 추출
            lines = content.split('\n')
            for line_num, line in enumerate(lines, 1):
                for pattern in sql_patterns:
                    matches = re.findall(pattern, line)
                    if matches:
                        # 메소드명 추출
                        method_match = re.search(r'(public|private|protected)?.*?(\w+)\s*\([^)]*\)\s*\{', line)
                        method_name = method_match.group(2) if method_match else "unknown"

                        for constant_name in matches:
                            resolved_key = self.resolve_sql_key(constant_name)
                            confidence = self.calculate_confidence(constant_name, resolved_key)

                            mapping = SQLMapping(
                                constant_name=constant_name,
                                resolved_key=resolved_key,
                                line_number=line_num,
                                method_name=method_name,
                                pattern=line.strip(),
                                confidence=confidence,
                                source_file=os.path.basename(java_file_path),
                                package_name=self.extract_package_name(content)
                            )

                            mappings.append(mapping)

            return mappings

        except FileNotFoundError:
            print(f"[WARN] Java 파일을 찾을 수 없음: {java_file_path}")
            return []
        except Exception as e:
            print(f"[ERROR] Java 파일 파싱 오류: {e}")
            return []

    def resolve_sql_key(self, constant_name: str) -> str:
        """
        상수명을 실제 SQL 키로 변환

        Args:
            constant_name: 상수명 (예: SELECT_SQL2)

        Returns:
            실제 SQL 키 (예: select-sql2)
        """
        # 1. 상수 정의에 있으면 직접 매핑
        if constant_name in self.sql_constants:
            base_key = self.sql_constants[constant_name]
        else:
            # 2. 상수명으로부터 유추
            base_key = constant_name.lower().replace('_', '-')

        # 3. 서비스 ID 조합
        full_key = f"{self.service_id}.{base_key}"

        return full_key

    def calculate_confidence(self, constant_name: str, resolved_key: str) -> str:
        """
        SQL 키 해석의 신뢰도 계산

        Args:
            constant_name: 상수명
            resolved_key: 해석된 SQL 키

        Returns:
            신뢰도 레벨 (high, medium, low)
        """
        if constant_name in self.sql_constants:
            return "high"
        elif "SQL" in constant_name and any(char.isdigit() for char in constant_name):
            return "medium"
        else:
            return "low"

    def extract_package_name(self, content: str) -> str:
        """Java 파일에서 패키지명 추출"""
        package_match = re.search(r'package\s+([^;]+);', content)
        return package_match.group(1) if package_match else ""

    def integrate_to_structure_json(self, structure_file_path: str, java_mappings: List[SQLMapping]) -> bool:
        """
        Java에서 추출된 SQL 매핑을 structure.json의 javaSqlQueries 배열에 추가

        Args:
            structure_file_path: structure.json 파일 경로
            java_mappings: Java 분석으로 추출된 SQL 매핑 목록

        Returns:
            성공 여부
        """
        try:
            # 기존 structure.json 로드
            with open(structure_file_path, 'r', encoding='utf-8') as f:
                structure_data = json.load(f)

            # dataFlow가 없으면 생성
            if 'dataFlow' not in structure_data:
                structure_data['dataFlow'] = {}

            # 기존 javaSqlQueries 배열 가져오기
            existing_java_sql_keys = structure_data['dataFlow'].get('javaSqlQueries', [])

            # Java에서 추출된 SQL 키 목록 생성 (중복 제거)
            java_sql_keys = list(set([mapping.resolved_key for mapping in java_mappings]))

            # 기존 배열과 합치고 중복 제거
            all_java_sql_keys = sorted(list(set(existing_java_sql_keys + java_sql_keys)))

            # javaSqlQueries 배열 업데이트
            structure_data['dataFlow']['javaSqlQueries'] = all_java_sql_keys

            # 업데이트된 structure.json 저장
            with open(structure_file_path, 'w', encoding='utf-8') as f:
                json.dump(structure_data, f, ensure_ascii=False, indent=2)

            print(f"[OK] javaSqlQueries 배열에 SQL 키 {len(java_sql_keys)}개 추가 완료")
            print(f"[INFO] 총 Java SQL 키: {len(all_java_sql_keys)}개")
            return True

        except FileNotFoundError:
            print(f"[ERROR] structure.json 파일을 찾을 수 없음: {structure_file_path}")
            return False
        except Exception as e:
            print(f"[ERROR] structure.json 업데이트 오류: {e}")
            import traceback
            traceback.print_exc()
            return False

    def infer_sql_type(self, constant_name: str) -> str:
        """상수명으로부터 SQL 타입 추론"""
        if "SELECT" in constant_name:
            return "SELECT"
        elif "INSERT" in constant_name:
            return "INSERT"
        elif "UPDATE" in constant_name:
            return "UPDATE"
        elif "DELETE" in constant_name:
            return "DELETE"
        else:
            return "UNKNOWN"

    def create_location_info(self, mapping: SQLMapping) -> Dict[str, Any]:
        """SQL 매핑 위치 정보 생성"""
        return {
            "file": mapping.source_file,
            "line": mapping.line_number,
            "method": mapping.method_name,
            "pattern": f"getProperty(M77ConstantsIF.{mapping.constant_name})",
            "sourceType": "Java",
            "package": mapping.package_name
        }

    def analyze_java_project(self, legacy_root: str, output_dir: str) -> Dict[str, Any]:
        """
        Java 프로젝트 전체를 분석하여 SQL 매핑 통합

        Args:
            legacy_root: 레거시 시스템 루트 경로
            output_dir: 출력 디렉토리

        Returns:
            분석 결과 요약
        """
        results = {
            "serviceId": self.service_id,
            "processCode": self.process_code,
            "constantsFound": 0,
            "mappingsExtracted": 0,
            "javaSqlKeysAdded": 0,
            "totalJavaSqlKeys": 0,
            "errors": []
        }

        try:
            # 1. 상수 정의 파일 파싱
            constants_search_pattern = os.path.join(legacy_root, self.process_code, "src", "**", "*ConstantsIF.java")
            constants_files = list(Path(legacy_root).glob(f"{self.process_code}/src/**/*ConstantsIF.java"))

            if constants_files:
                constants_file = constants_files[0]
                self.sql_constants = self.parse_constants_file(str(constants_file))
                results["constantsFound"] = len(self.sql_constants)
            else:
                results["errors"].append("ConstantsIF 파일을 찾을 수 없음")
                return results

            # 2. structure.json 파일 경로 확인
            structure_file = os.path.join(output_dir, ".temp", f"{self.service_id}_structure.json")
            if not os.path.exists(structure_file):
                results["errors"].append("structure.json 파일을 찾을 수 없음")
                return results

            # 3. Java Custom Activity 파일들에서 SQL 매핑 추출
            legacy_path = Path(legacy_root) / self.process_code / "src"
            java_files = list(legacy_path.glob("**/activity/**/*.java"))

            all_mappings = []
            for java_file in java_files:
                mappings = self.extract_sql_patterns_from_java(str(java_file))
                all_mappings.extend(mappings)

            results["mappingsExtracted"] = len(all_mappings)

            # 4. structure.json에 javaSqlQueries 배열로 추가
            if all_mappings:
                # 기존 javaSqlKeys 개수 확인
                try:
                    with open(structure_file, 'r', encoding='utf-8') as f:
                        existing_structure = json.load(f)
                    existing_java_keys = existing_structure.get('dataFlow', {}).get('javaSqlQueries', [])
                    results["totalJavaSqlKeys"] = len(existing_java_keys)
                except:
                    results["totalJavaSqlKeys"] = 0

                success = self.integrate_to_structure_json(structure_file, all_mappings)
                if success:
                    # 새로 추가된 SQL 키 개수 계산
                    new_java_sql_keys = list(set([mapping.resolved_key for mapping in all_mappings]))
                    results["javaSqlKeysAdded"] = len(new_java_sql_keys)
                    results["totalJavaSqlKeys"] += len(new_java_sql_keys)
                else:
                    results["errors"].append("javaSqlQueries 배열 추가 실패")

            return results

        except Exception as e:
            results["errors"].append(f"분석 중 오류 발생: {str(e)}")
            return results

def main():
    """메인 실행 함수"""
    import sys

    if len(sys.argv) < 4:
        print("사용법: python sql_mapping_integration.py <service_id> <process_code> <legacy_root> [output_dir]")
        sys.exit(1)

    service_id = sys.argv[1]
    process_code = sys.argv[2]
    legacy_root = sys.argv[3]
    output_dir = sys.argv[4] if len(sys.argv) > 4 else f"docs/legacy_analysis/{process_code}"

    analyzer = SQLMappingAnalyzer(service_id, process_code)
    results = analyzer.analyze_java_project(legacy_root, output_dir)

    print("\n" + "="*50)
    print("Java SQL 매핑 분석 결과")
    print("="*50)
    print(f"서비스 ID: {results['serviceId']}")
    print(f"프로세스 코드: {results['processCode']}")
    print(f"발견된 상수: {results['constantsFound']}개")
    print(f"추출된 매핑: {results['mappingsExtracted']}개")
    print(f"Java SQL 키 추가: {results['javaSqlKeysAdded']}개")
    print(f"총 Java SQL 키: {results['totalJavaSqlKeys']}개")

    if results['errors']:
        print("\n오류:")
        for error in results['errors']:
            print(f"  - {error}")

    print("="*50)

if __name__ == "__main__":
    main()