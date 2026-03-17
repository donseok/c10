#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SQL 구조 마이그레이션 유틸리티

복잡한 dataFlow.sqlQueries 객체 구조를 단순화된 배열 구조로 변환:
- sqlQueries: XML 기반 SQL 키 배열
- javaSqlQueries: Java 기반 SQL 키 배열

Author: Claude Code
Created: 2025-10-31
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Set, Any, Tuple
import argparse

class SQLStructureMigrator:
    """SQL 구조 마이그레이션 도구"""

    def __init__(self, legacy_root: str = "./docs/legacy_analysis"):
        self.legacy_root = Path(legacy_root)
        self.migration_stats = {
            "processed_files": 0,
            "migrated_files": 0,
            "total_xml_keys": 0,
            "total_java_keys": 0,
            "errors": []
        }

    def migrate_single_file(self, structure_file_path: str) -> bool:
        """
        단일 structure.json 파일을 마이그레이션

        Args:
            structure_file_path: structure.json 파일 경로

        Returns:
            성공 여부
        """
        try:
            print(f"[INFO] 마이그레이션 시작: {structure_file_path}")

            # 기존 파일 로드
            with open(structure_file_path, 'r', encoding='utf-8') as f:
                old_structure = json.load(f)

            # 데이터 추출
            xml_keys, java_keys = self.extract_sql_keys(old_structure)

            # 새로운 단순화된 구조 생성
            new_structure = self.create_simplified_structure(old_structure, xml_keys, java_keys)

            # 데이터 무결성 검증
            if not self.validate_migration(old_structure, new_structure):
                raise ValueError("마이그레이션 데이터 무결성 검증 실패")

            # 백업 파일 생성
            backup_path = structure_file_path.replace('.json', '_backup.json')
            with open(backup_path, 'w', encoding='utf-8') as f:
                json.dump(old_structure, f, ensure_ascii=False, indent=2)
            print(f"[INFO] 백업 파일 생성: {backup_path}")

            # 새로운 구조 저장
            with open(structure_file_path, 'w', encoding='utf-8') as f:
                json.dump(new_structure, f, ensure_ascii=False, indent=2)

            # 통계 업데이트
            self.migration_stats["migrated_files"] += 1
            self.migration_stats["total_xml_keys"] += len(xml_keys)
            self.migration_stats["total_java_keys"] += len(java_keys)

            print(f"[OK] 마이그레이션 완료: XML({len(xml_keys)}) + Java({len(java_keys)})")
            return True

        except Exception as e:
            error_msg = f"마이그레이션 실패: {structure_file_path} - {str(e)}"
            self.migration_stats["errors"].append(error_msg)
            print(f"[ERROR] {error_msg}")
            return False

    def extract_sql_keys(self, structure: Dict[str, Any]) -> Tuple[List[str], List[str]]:
        """
        기존 구조에서 XML과 Java SQL 키 추출

        Args:
            structure: 기존 structure.json 데이터

        Returns:
            (XML SQL 키 리스트, Java SQL 키 리스트)
        """
        xml_keys: Set[str] = set()
        java_keys: Set[str] = set()

        # 1. dataFlow.sqlQueries 객체 분석
        if 'dataFlow' in structure and 'sqlQueries' in structure['dataFlow']:
            sql_queries = structure['dataFlow']['sqlQueries']

            if isinstance(sql_queries, dict):
                # 복잡한 객체 구조
                for sql_key, sql_info in sql_queries.items():
                    sources = sql_info.get('sources', [])
                    if 'XML' in sources:
                        xml_keys.add(sql_key)
                    if 'Java' in sources:
                        java_keys.add(sql_key)
                    # sources가 없으면 기본적으로 XML으로 간주
                    if not sources:
                        xml_keys.add(sql_key)

            elif isinstance(sql_queries, list):
                # 이미 단순화된 배열 구조
                xml_keys.update(sql_queries)

        # 2. activities에서 sqlkey 직접 추출 (XML 기반)
        if 'serviceStructure' in structure and 'activities' in structure['serviceStructure']:
            for activity in structure['serviceStructure']['activities']:
                if activity.get('type') == 'custom' and 'properties' in activity:
                    properties = activity.get('properties', {})
                    for key, value in properties.items():
                        if key == 'sqlkey' and isinstance(value, str):
                            xml_keys.add(value)
                        elif key.endswith('-sql') and isinstance(value, str):
                            xml_keys.add(value)

        # 3. activities 배열에서 sqlkey 추출 (기존 방식 호환)
        if 'activities' in structure:
            for activity in structure['activities']:
                if 'properties' in activity:
                    properties = activity['properties']
                    if 'sqlkey' in properties:
                        xml_keys.add(properties['sqlkey'])

        return sorted(list(xml_keys)), sorted(list(java_keys))

    def create_simplified_structure(self, old_structure: Dict[str, Any],
                                 xml_keys: List[str], java_keys: List[str]) -> Dict[str, Any]:
        """
        새로운 단순화된 구조 생성

        Args:
            old_structure: 기존 구조
            xml_keys: XML SQL 키 리스트
            java_keys: Java SQL 키 리스트

        Returns:
            새로운 단순화된 구조
        """
        new_structure = old_structure.copy()

        # dataFlow가 없으면 생성
        if 'dataFlow' not in new_structure:
            new_structure['dataFlow'] = {}

        # 새로운 단순화된 구조로 변경
        new_structure['dataFlow'] = {
            'sqlQueries': xml_keys,
            'javaSqlQueries': java_keys
        }

        # 마이그레이션 정보 추가
        new_structure['migrationInfo'] = {
            'migratedAt': '2025-10-31',
            'fromVersion': 'complex',
            'toVersion': 'simplified',
            'xmlKeyCount': len(xml_keys),
            'javaKeyCount': len(java_keys)
        }

        return new_structure

    def validate_migration(self, old_structure: Dict[str, Any],
                          new_structure: Dict[str, Any]) -> bool:
        """
        마이그레이션 데이터 무결성 검증

        Args:
            old_structure: 기존 구조
            new_structure: 새로운 구조

        Returns:
            검증 성공 여부
        """
        # 기존 SQL 키 추출
        old_xml_keys, old_java_keys = self.extract_sql_keys(old_structure)

        # 새로운 구조에서 SQL 키 추출
        new_xml_keys = new_structure['dataFlow'].get('sqlQueries', [])
        new_java_keys = new_structure['dataFlow'].get('javaSqlQueries', [])

        # 데이터 개수 비교
        old_total = len(set(old_xml_keys + old_java_keys))
        new_total = len(set(new_xml_keys + new_java_keys))

        if old_total != new_total:
            print(f"[WARN] SQL 키 개수 불일치: 기존 {old_total}개 → 신규 {new_total}개")
            # 중요 데이터 누락만 체크
            missing_keys = set(old_xml_keys + old_java_keys) - set(new_xml_keys + new_java_keys)
            if missing_keys:
                print(f"[ERROR] 누락된 SQL 키: {missing_keys}")
                return False

        return True

    def migrate_all_files(self, process_code: str = None) -> Dict[str, Any]:
        """
        모든 structure.json 파일을 마이그레이션

        Args:
            process_code: 특정 프로세스 코드만 마이그레이션 (선택적)

        Returns:
            마이그레이션 통계
        """
        if process_code:
            # 특정 프로세스 코드만 처리
            target_dirs = [self.legacy_root / process_code]
        else:
            # 모든 프로세스 코드 처리
            target_dirs = [d for d in self.legacy_root.iterdir() if d.is_dir()]

        print(f"[INFO] 마이그레이션 대상 디렉토리: {len(target_dirs)}개")

        for process_dir in target_dirs:
            temp_dir = process_dir / ".temp"
            if not temp_dir.exists():
                continue

            # structure.json 파일 찾기
            structure_files = list(temp_dir.glob("*_structure.json"))

            for structure_file in structure_files:
                self.migration_stats["processed_files"] += 1
                self.migrate_single_file(str(structure_file))

        return self.migration_stats

    def rollback_file(self, structure_file_path: str) -> bool:
        """
        마이그레이션 롤백 (백업 파일에서 복원)

        Args:
            structure_file_path: structure.json 파일 경로

        Returns:
            롤백 성공 여부
        """
        try:
            backup_path = structure_file_path.replace('.json', '_backup.json')

            if not os.path.exists(backup_path):
                print(f"[ERROR] 백업 파일을 찾을 수 없음: {backup_path}")
                return False

            # 백업 파일 로드
            with open(backup_path, 'r', encoding='utf-8') as f:
                backup_data = json.load(f)

            # 원본 파일 복원
            with open(structure_file_path, 'w', encoding='utf-8') as f:
                json.dump(backup_data, f, ensure_ascii=False, indent=2)

            # 백업 파일 삭제
            os.remove(backup_path)

            print(f"[OK] 롤백 완료: {structure_file_path}")
            return True

        except Exception as e:
            print(f"[ERROR] 롤백 실패: {str(e)}")
            return False

def main():
    """메인 실행 함수"""
    parser = argparse.ArgumentParser(description='SQL 구조 마이그레이션 유틸리티')
    parser.add_argument('--process', '-p', type=str, help='특정 프로세스 코드만 마이그레이션 (예: m77)')
    parser.add_argument('--file', '-f', type=str, help='특정 파일만 마이그레이션')
    parser.add_argument('--rollback', '-r', action='store_true', help='마이그레이션 롤백')
    parser.add_argument('--legacy-root', type=str, default='./docs/legacy_analysis',
                       help='레거시 분석 결과 루트 디렉토리')

    args = parser.parse_args()

    migrator = SQLStructureMigrator(args.legacy_root)

    if args.rollback:
        if args.file:
            # 단일 파일 롤백
            migrator.rollback_file(args.file)
        else:
            print("[ERROR] 롤백 시 --file 파라미터가 필요합니다")
    elif args.file:
        # 단일 파일 마이그레이션
        migrator.migrate_single_file(args.file)
    else:
        # 전체 또는 특정 프로세스 마이그레이션
        stats = migrator.migrate_all_files(args.process)

        print("\n" + "="*60)
        print("SQL 구조 마이그레이션 완료")
        print("="*60)
        print(f"처리한 파일: {stats['processed_files']}개")
        print(f"마이그레이션 성공: {stats['migrated_files']}개")
        print(f"총 XML SQL 키: {stats['total_xml_keys']}개")
        print(f"총 Java SQL 키: {stats['total_java_keys']}개")

        if stats['errors']:
            print(f"\n오류 ({len(stats['errors'])}개):")
            for error in stats['errors']:
                print(f"  - {error}")

        print("="*60)

if __name__ == "__main__":
    main()