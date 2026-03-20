
## 5. BPA 체크리스트 생성 프롬프트

### 방법 A: 기존 분석 체크리스트 기반

기존 `service_analysis_checklist.md`에서 tab/pop 서비스를 제외한 부모 서비스만 추출하여 BPA 생성 체크리스트를 자동 생성한다.

### 프롬프트

```
'{체크리스트_경로}' 를 기준으로 generate-bpa 스킬을 사용해서 분석할 서비스의 체크리스트를 만들고 싶어.
tab, pop[up] 등의 부차적인 서비스는 제외하고 부모 서비스들의 체크리스트를 파일로 만들어줘.
```

**예시:**
```
'docs/analysis/service_analysis_checklist.md' 를 기준으로 generate-bpa 스킬을 사용해서 분석할 서비스의 체크리스트를 만들고 싶어.
tab, pop[up] 등의 부차적인 서비스는 제외하고 부모 서비스들의 체크리스트를 파일로 만들어줘.
```

**결과:**
- 출력 경로: `docs/analysis/bpa/bpa_generation_checklist.md`
- tab/pop 서비스 제외, 부모 서비스만 추출
- 하위 tab/pop이 있는 서비스는 비고에 `(tab01~02 포함)` 등으로 표기
- 체크리스트 형식: `⬜` 미완료 / `✅` 완료

### 방법 B: 서비스 XML 디렉토리에서 직접 생성

분석 체크리스트 없이 `src/service/` 디렉토리의 서비스 XML 파일을 직접 스캔하여 BPA 체크리스트를 생성한다. 유틸리티/프레임워크 서비스는 자동 제외.

#### 프롬프트

```
src/service/ 디렉토리의 서비스 XML 파일을 스캔하여 generate-bpa 용 체크리스트를 만들어줘.
다음 규칙을 적용해:
1. tab*, pop* 접미사 서비스는 제외하고 부모 서비스만 추출
2. 유틸리티/프레임워크 서비스 제외 (login, lov, masterGridData, pageConnLogging, security, userLogging, tabsample, testSample 등)
3. 다른 모듈 서비스 제외 (M47*, M26* 등 현재 모듈이 아닌 것)
4. 하위 tab/pop이 있으면 비고에 '(tab01~02 포함)' 형태로 표기
5. 서비스 ID 명명규칙에 따라 카테고리 분류 (M17X → 대분류, B17R → NUI)
6. 출력: docs/analysis/bpa/bpa_generation_checklist.md
```

**예시:**
```
src/service/ 디렉토리의 서비스 XML 파일을 스캔하여 generate-bpa 용 체크리스트를 만들어줘.
다음 규칙을 적용해:
1. tab*, pop* 접미사 서비스는 제외하고 부모 서비스만 추출
2. 유틸리티/프레임워크 서비스 제외 (login, lov, masterGridData, pageConnLogging, security, userLogging, tabsample, testSample 등)
3. 다른 모듈 서비스 제외 (현재 모듈이 아닌 것)
4. 하위 tab/pop이 있으면 비고에 '(tab01~02 포함)' 형태로 표기
5. 서비스 ID 명명규칙에 따라 카테고리 분류 (MXX → 대분류, BXX → NUI)
6. 출력: docs/analysis/bpa/bpa_generation_checklist.md
```

**장점:**
- 분석 체크리스트가 없는 프로젝트에서도 바로 사용 가능
- 실제 서비스 파일 기준이므로 누락/불일치 없음
- 새 서비스가 추가되어도 최신 상태 반영

---

## 6. BPA 일괄 생성 프롬프트

BPA 체크리스트 기반으로 서브에이전트 풀을 활용한 일괄 BPA 생성 프롬프트:

### 프롬프트

```
/generate-bpa '{BPA_체크리스트_경로}' {N}개의 sonnet 서브에이전트 pool을 이용해 작업해줘.
하나의 서브에이전트가 끝나면 바로 다음 서브에이전트 실행해서 문서를 생성하면 된다.
```

**예시:**
```
/generate-bpa 'docs/analysis/bpa/bpa_generation_checklist.md' 20개의 sonnet 서브에이전트 pool을 이용해 작업해줘.
하나의 서브에이전트가 끝나면 바로 다음 서브에이전트 실행해서 문서를 생성하면 된다. NUI를 가장 먼저 진행해. 진행관리는 main 에이전트가 하면 된다. 
다음의 문자를 사용해. ✅ 완료, 🔄 진행중 , ⬜ 미분석 
```

**동작:**
- 체크리스트에서 `⬜` 항목을 순차 선택
- 최대 N개의 sonnet 서브에이전트를 동시 실행
- 서브에이전트 1개 완료 → 즉시 다음 `⬜` 항목 할당
- 완료 시 `⬜` → `✅` 갱신 및 요약 테이블 업데이트