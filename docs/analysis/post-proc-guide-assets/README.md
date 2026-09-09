# 후공정 제조표준 설계 해설서

상위 폴더의 `후공정_제조표준_설계_쉽게이해하기.md`는 수정 가능한 원문이고, `.html`은 CSS·SVG 그림·선택 예제를 내장한 오프라인 열람용 단일 파일입니다. 코드 근거 링크는 이 저장소와 함께 보관할 때 열립니다.

[용융·전기 제조표준 설계 해설서](../용융_전기_제조표준_설계_쉽게이해하기.html)와 같은 글꼴·색·목차·표 구성을 씁니다. 다만 후공정 탭은 **계산이 거의 없고 표시 규칙이 많은** 화면이라 산식표 대신 **순서도 중심**으로 그렸습니다. 그림 18개 중 여섯 개가 순서도이고, 나머지는 구조도·비교표·계보도입니다. 모두 코드로 작성한 설명용 SVG이며 운영 실적이나 설비 도면이 아닙니다.

## 그림 목록

| 번호 | 파일 | 종류 |
|---|---|---|
| 1 | 01-where-is-postproc | 구조도 · 세 탭 중 후공정의 자리 |
| 2 | 02-screen-blocks | 구조도 · 화면 다섯 블록과 편집 가능 여부 |
| 3 | 03-value-sources | 비교표 · 값의 출처 지도 |
| 4 | 04-save-flow | **순서도** · 저장 버튼의 판단 흐름 |
| 5 | 05-slit-display | **순서도** · 조수·조합폭1 표시 규칙 |
| 6 | 06-save-protect | 비교표 · 저장 시 보호 범위 |
| 7 | 07-update-all-rows | 구조도 · 조회 한 행 vs 저장 세 행 |
| 8 | 08-skid-flow | **순서도** · SKID 치수 계산 |
| 9 | 09-film-code-parse | 구조도 · 보호필름 상세코드 자리별 파싱 |
| 10 | 10-adhesion-source | **순서도** · 관리점착력 이중 소스 |
| 11 | 11-message-tables | 비교표 · 메세지 세 테이블 |
| 12 | 12-message-origin | 구조도 · 정전 메세지 생성 경로 |
| 13 | 13-terminated-order | **순서도** · 종료주문 필터 |
| 14 | 14-confirmed-order | 비교표 · 확정주문 검사 비활성 |
| 15 | 15-save-targets | 구조도 · 저장 경로별 대상 표 |
| 16 | 16-blank-diagnosis | **순서도** · 빈칸 진단 |
| 17 | 17-width-lineage | 계보도 · 폭 값 네 가지 |
| 18 | 18-tracking-checklist | 체크리스트 · 추적 순서 |

## 재생성

저장소 루트에서 그림·HTML을 함께 생성합니다. Node 18 이상이 필요합니다.

```sh
node docs/analysis/post-proc-guide-assets/build-report.cjs
```

이 환경에는 pandoc이 없어 `md2html.cjs`가 Markdown → HTML 변환을 담당합니다. 유지보수 원문은 상위 Markdown이며, `explorer.html`·`explorer.js`는 선택 예제의 원본입니다. 그림만 다시 그리려면 `build-figures.cjs`를 실행합니다.

## 검증

```sh
node docs/analysis/post-proc-guide-assets/verify-examples.cjs
node docs/analysis/post-proc-guide-assets/verify-document.cjs
node docs/analysis/post-proc-guide-assets/verify-guide.cjs
```

- **verify-examples**: 문서에 적은 표시·저장 규칙 42건을 JavaScript로 독립 재현합니다. 조수·조합폭1 표시 판단, 조합폭 2~10의 다른 규칙, 저장 시 DECODE 보호 범위, SKID 세 갈래, 보호필름 자리별 파싱, 관리점착력 우선순위, 저장 경로 판단과 콜백 체인, 조회 필터, 제품폭범위와 정전폭목표의 서로 다른 식이 포함됩니다.
- **verify-document**: 지역 링크·앵커·내장 자산을 확인하고, 문서가 인용한 **SQL 키·파일·근거 ID가 실제로 존재하는지** 대조합니다. 아울러 문서의 주요 주장이 소스에서 바뀌면 실패하도록 했습니다. 조회의 제조구분 1 조건, 종료주문 필터, **저장 SQL에 제조구분 조건이 없는 것**, 조수·조합폭1의 보호 DECODE, 조합폭2에 보호가 없는 것, SKID의 LEAST/GREATEST, 보호필름 2·4·5번째 자리, 관리점착력의 칼라 BOM 우선, 확정주문 주석, **포장메세지 표에 INSERT가 없는 것**을 확인합니다.
- **verify-guide**: 로컬 Playwright와 Chrome으로 그림 표시·글자 경계, 6개 선택 예제, 모바일 가로 넘침, 브라우저 오류를 검사합니다. Playwright·Chrome 경로는 현재 작업 환경 기준이므로 다른 PC에서는 바꾸어야 합니다.

Java 서비스·운영 MD·Oracle을 실행한 통합 검증은 아닙니다. 실제 값은 운영 DB에서 확인해야 합니다.
