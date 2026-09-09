# 적정·차선 원자재 폭설계 해설서

상위 폴더의 `적정_차선_원자재_폭설계_쉽게이해하기.md`는 수정 가능한 원문이고, `.html`은 CSS·SVG 그림을 내장한 오프라인 열람용 단일 파일입니다. 코드 근거 링크는 이 저장소와 함께 보관할 때 열립니다.

기존 PLTCM 압연 SET 해설서의 글꼴·색·목차·표 구성을 참고했습니다. 이번 보완으로 입문 그림 8개를 추가해 총 14개가 되었습니다. 그림은 코드로 작성한 설명용 SVG이며 운영 실적이나 설비 도면이 아닙니다. HTML에는 제품목표폭 1,002를 고정한 소재 경로 6개를 선택·비교하는 예제도 들어 있습니다. 업무기준 조회 기능은 없습니다. 기존 두께 분석서와 실행 코드는 수정하지 않았습니다.

저장소 루트에서 그림·계산 예제를 재현합니다.

```sh
node docs/analysis/width-design-guide-assets/build-beginner-figures.cjs
node docs/analysis/width-design-guide-assets/verify-examples.cjs
```

저장소 루트에서 HTML을 생성합니다(Python 3, Node, Pandoc 필요). 그림 생성, Markdown 변환, 경로 비교 예제와 오프라인 스크립트 내장을 함께 수행합니다. 유지보수 원문은 상위 Markdown이며, `explorer.html`·`explorer.js`는 선택 예제의 원본입니다.

```sh
python3 docs/analysis/width-design-guide-assets/build-report.py
```

저장소 루트에서 구조를 확인합니다.

```sh
node docs/analysis/width-design-guide-assets/verify-document.cjs
```

계산 검증은 설명용 양수 입력을 대상으로 Java의 계산 순서를 JavaScript로 독립 재현한 40개 확인 항목입니다. GLUE·Java 클래스나 운영 업무기준 DB를 실행하는 통합시험이 아닙니다. 문서를 변경하면 데스크톱·좁은 화면에서 표·그림·목차·가로 넘침과 선택 예제 6개를 다시 확인합니다. 인쇄 시 선택 예제는 숨기고 정적 그림·표를 사용합니다.
