# 품질메세지 설계 해설서

상위 폴더의 `품질메세지_설계_쉽게이해하기.md`는 수정 가능한 원문이고, `.html`은 CSS·SVG 그림·선택 예제를 내장한 오프라인 열람용 단일 파일입니다. 코드 근거 링크는 이 저장소와 함께 보관할 때 열립니다.

[용융·전기 제조표준 설계 해설서](../용융_전기_제조표준_설계_쉽게이해하기.html), [후공정 제조표준 설계 해설서](../후공정_제조표준_설계_쉽게이해하기.html)와 같은 글꼴·색·목차·표 구성을 씁니다. 다만 품질메세지는 **계산이 거의 없고 갈래와 조건 분기가 많은** 주제라 산식표 대신 **지도와 순서도**를 중심으로 그렸습니다. 그림 18개 중 여덟 개가 순서도이고, 나머지는 지도·구조도·비교표입니다. 모두 코드로 작성한 설명용 SVG이며 운영 실적이나 실제 등록된 메세지가 아닙니다.

## 다루는 범위

품질메세지 여섯 갈래를 모두 다룹니다.

| 갈래 | 표 · 컬럼 |
|---|---|
| 제조구분별 품질메세지 | `TB_C10_QLT_DSN_MSG.QLT_MSG_NM` |
| 정전 품질메세지 | `TB_C10_QLT_DSN_MSG1.QLT_MSG_NM` |
| 포장메세지 | `TB_C10_QLT_DSN_MSG_PKG.QLT_MSG_NM` + `CMN.PAK_MSG_CD` |
| CCL 공정품질메시지 | `TB_C10_QLT_DSN_CCL_BOM.CCL_QLT_MSG_TXT` |
| 지관발주메시지 | `TB_C10_QLT_DSN_CMN.PPR_RNG_PORD_TXT` |
| PE-FOAM 적용메시지 | `TB_C10_QLT_DSN_CMN.PE_FOAM_TXT` |

이름이 메세지인데 품질메세지가 아닌 것(오류코드, EAI 송신 플래그)도 구분해 정리했습니다.

## 그림 목록

| 번호 | 파일 | 종류 |
|---|---|---|
| 1 | 01-six-families | 지도 · 품질메세지 여섯 갈래 |
| 2 | 02-rows-per-order | 구조도 · 기준 한 줄에서 갈라지는 행 |
| 3 | 03-design-key | 비교표 · 설계Key 열세 조건 |
| 4 | 04-match-cascade | **순서도** · 조건을 넓혀 가는 순서 |
| 5 | 05-usage-widening | **순서도** · 주문용도코드 세 단계 확장 |
| 6 | 06-master-to-ctx | 비교표 · 기준값이 저장값으로 옮겨지는 경로 |
| 7 | 07-three-rows | **순서도** · 제조구분별 행 생성 조건 |
| 8 | 08-cor-insert | **순서도** · 정전 메세지 저장 |
| 9 | 09-tables | 비교표 · 여섯 갈래의 표와 키 |
| 10 | 10-screens | 구조도 · 화면별 메세지 칸 |
| 11 | 11-save-scope | **순서도** · 탭별 저장 범위 |
| 12 | 12-select-filters | **순서도** · 탭별 조회 필터 |
| 13 | 13-lifecycle | **순서도** · 메세지 행의 수명주기 |
| 14 | 14-copy | 구조도 · 반복주문 설계복사 |
| 15 | 15-history | 구조도 · 변경이력 기록 |
| 16 | 16-pack-message | 구조도 · 포장메세지 두 조각 |
| 17 | 17-ccl-message | 비교표 · CCL 공정품질메시지 |
| 18 | 18-blank-diagnosis | **순서도** · 메세지 빈칸 진단 |

## 재생성

저장소 루트에서 그림·HTML을 함께 생성합니다. Node 18 이상이 필요합니다.

```sh
node docs/analysis/qlt-msg-guide-assets/build-report.cjs
```

이 환경에는 pandoc이 없어 `md2html.cjs`가 Markdown → HTML 변환을 담당합니다. 유지보수 원문은 상위 Markdown이며, `explorer.html`·`explorer.js`는 선택 예제의 원본입니다. 그림만 다시 그리려면 `build-figures.cjs`를 실행합니다.

## 검증

```sh
node docs/analysis/qlt-msg-guide-assets/verify-examples.cjs
node docs/analysis/qlt-msg-guide-assets/verify-document.cjs
node docs/analysis/qlt-msg-guide-assets/verify-guide.cjs
```

- **verify-examples**: 문서에 적은 설계·표시·저장 규칙 72건을 JavaScript로 독립 재현합니다. 설계Key 조건 배열과 주문폭 계산, 조건 확장의 전체 하강 순서, 주문용도코드 세 단계, 기준값이 저장값으로 옮겨질 때의 이름 대응, 제조구분별 행 생성 조건과 차선2 빈칸, 정전 메세지의 무조건 1행, 탭별 저장 범위와 조회 결과, 1000바이트 절단, 포장메세지 결합, 반복주문 복사, 수정설계원 판정 범위, 확정 주문 저장 차단, 재질코드 검사 순서가 포함됩니다.
- **verify-document**: 지역 링크·앵커·내장 자산을 확인하고, 문서가 인용한 **SQL 키·파일·근거 ID가 실제로 존재하는지** 대조합니다. 아울러 문서의 주요 주장이 소스에서 바뀌면 실패하도록 했습니다. 설계Key 조건이 13개인 것, **기준 3번 칸을 `QLT_MSG_NM2`로 담고 저장은 `QLT_MSG_NM3`을 찾는 어긋남**, `QLT_MSG_NM3`을 담는 코드가 저장소에 없는 것, 정전 INSERT 앞에 조건이 없는 것, **재질코드 검사가 메세지 INSERT 뒤에 있는 것**, 탭별 제조구분 고정, 후공정 탭에만 있는 종료주문 필터, **사장 쿼리 다섯 개가 여전히 호출되지 않는 것**, 포장메세지 표에 쓰는 SQL이 없는 것, **롤백이 주석 처리된 것**, 세 탭의 메세지 이력 추적, **수정설계원 판정에서 메세지 표가 빠져 있는 것**, EAI 송신 플래그 사용을 확인합니다.
- **verify-guide**: 로컬 Playwright와 Chrome으로 그림 표시·글자 경계, 6개 선택 예제, 모바일 가로 넘침, 브라우저 오류를 검사합니다. Playwright·Chrome 경로는 현재 작업 환경 기준이므로 다른 PC에서는 바꾸어야 합니다.

Java 서비스·운영 MD·Oracle을 실행한 통합 검증은 아닙니다. 실제 값은 운영 DB에서 확인해야 합니다.
