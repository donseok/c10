# 용융·전기 제조표준 설계 해설서

상위 폴더의 `용융_전기_제조표준_설계_쉽게이해하기.md`는 수정 가능한 원문이고, `.html`은 CSS·SVG 그림·선택 예제를 내장한 오프라인 열람용 단일 파일입니다. 코드 근거 링크는 이 저장소와 함께 보관할 때 열립니다.

기존 [적정·차선 원자재 폭설계 해설서](../적정_차선_원자재_폭설계_쉽게이해하기.html)의 글꼴·색·목차·표 구성을 그대로 따랐습니다. 그림 14개는 코드로 작성한 설명용 SVG이며 운영 실적이나 설비 도면이 아닙니다. HTML에는 품명 6종의 두께 사슬과 조건 항목을 비교하는 선택 예제도 들어 있습니다. 업무기준 조회 기능은 없습니다.

폭 항목의 산식은 폭설계 해설서가 다루므로, 이 문서는 **두께·소둔·도금·조도·ECL·PLTCM 설정과 화면 저장 경로**에 집중합니다.

## 재생성

저장소 루트에서 그림·HTML을 함께 생성합니다. Node 18 이상이 필요합니다.

```sh
node docs/analysis/mnf-std-guide-assets/build-report.cjs
```

이 환경에는 pandoc이 없어 `md2html.cjs`가 Markdown → HTML 변환을 담당합니다. 지원 범위는 이 문서가 쓰는 부분집합(머리말, h1~h3, 문단, 파이프 표, 목록, 인용, 이미지, 링크, 굵게, 인라인 코드, 원시 HTML 한 줄)입니다. 유지보수 원문은 상위 Markdown이며, `explorer.html`·`explorer.js`는 선택 예제의 원본입니다.

그림만 다시 그리려면 다음을 실행합니다.

```sh
node docs/analysis/mnf-std-guide-assets/build-figures.cjs
```

## 사실 검증 이력

2026-09-09에 8개 그룹으로 나누어 문서의 사실 주장 452건을 소스와 대조하고, 보고된 불일치를 반대 입장에서 재검증했습니다. 확정된 오류 11건을 반영했습니다. 주요 수정은 두께 장의 기준표 경로 진입 조건(고객요청압연두께 0 **그리고** 두께구분 ≠ 3), PLTCM 출측두께가 쓰는 보정단위의 출처(C10B2060이 아니라 고객요청압연두께단위), TRK 보정단위의 KK94 조합, 규격도금두께 0 처리 조건, TAB06 품질메세지 저장의 수정로그 경로, CLEAR 액티비티가 있는 단계 범위입니다.

## 검증

```sh
node docs/analysis/mnf-std-guide-assets/verify-examples.cjs
node docs/analysis/mnf-std-guide-assets/verify-document.cjs
node docs/analysis/mnf-std-guide-assets/verify-guide.cjs
```

- **verify-examples**: 문서에 적은 산식 80건을 JavaScript로 독립 재현합니다. X-Ray SET 0/5 규칙, 보정단위 × 두께구분 × 관리코드 16조합, 기준표 경로 진입 조건, 규격도금두께 0 처리, 품명별 제품목표두께, TM·중간정전 두께, Edge 두 컬럼, Skin Pass 분기, 매중량, 정합성검사의 `&&` 조건이 포함됩니다.
- **verify-document**: 지역 링크·앵커·내장 자산을 확인하고, 문서가 인용한 **SQL 키·클래스·서비스·업무기준 상수·근거 ID가 실제로 존재하는지** 대조합니다. 11장에 적은 현행 예외(정합성검사 `&&` 조건, TAB05 CGL 열 번호 불일치, TAB05 확정주문 `return` 주석)가 소스에서 수정되면 실패하므로, 그때 문서를 갱신하라는 신호가 됩니다.
- **verify-guide**: 로컬 Playwright와 Chrome으로 그림 표시·글자 경계, 6개 선택 예제, 모바일 가로 넘침, 브라우저 오류를 검사합니다. Playwright·Chrome 경로는 현재 작업 환경 기준이므로 다른 PC에서는 바꾸어야 합니다.

Java 서비스·운영 MD·Oracle을 실행한 통합 검증은 아닙니다. 실제 기준값은 운영 MD에서 확인해야 합니다.
