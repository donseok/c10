# 성분·재질·인수도 설계 분석서

현재 소스의 동작을 설명하는 한국어 HTML 3종과 Markdown 원문입니다. 도식과 스타일·예제 스크립트는 HTML에 내장되어 문서 파일 하나로 열 수 있습니다. 소스 근거와 다른 분석서 링크는 프로젝트의 상대 경로입니다.

- 성분: 6개 도식, 예제 4개
- 재질: 6개 도식, 예제 4개
- 인수도: 8개 도식, 예제 5개
- 공통 도식을 공유하므로 SVG 파일은 총 18개입니다.

## 재생성

`python3 docs/analysis/quality-spec-guide-assets/build-reports.py`

Python 3, pandoc이 필요합니다. 본문·도식 원본은 build-reports.py에 있으며 실행 시 상위 폴더의 Markdown과 HTML을 함께 생성합니다. 생성된 Markdown을 직접 고친 경우 재생성 전에 수정 내용을 생성기에도 반영해야 합니다. CSS는 기존 width-design-guide-assets/guide.css를 재사용합니다.

## 검증

`node docs/analysis/quality-spec-guide-assets/verify-examples.cjs`

`node docs/analysis/quality-spec-guide-assets/verify-guides.cjs`

첫 명령은 설명용 수치·분기 24건을 검증합니다. 두 번째는 로컬 Playwright와 Chrome으로 소스 링크·내부 링크, SVG 표시 및 글자 경계, 13개 선택 예제, 모바일 가로 넘침, 브라우저 오류를 검사합니다. Playwright/Chrome 경로는 현재 작업 환경 기준이므로 다른 PC에서는 바꾸어야 합니다.

Java 서비스·운영 MD·Oracle을 실행한 통합 검증은 아닙니다. 실제 기준값은 운영 MD에서 확인해야 합니다. 재질의 후속 cs_update와 인수도 E/C/D의 0 처리 차이를 특히 구분합니다.
