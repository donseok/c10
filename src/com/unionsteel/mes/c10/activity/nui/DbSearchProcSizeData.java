/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchProcSizeData.java
 * Change history
 * @LastModifyDate : 2012. 02. 23
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 02. 23 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 공정별Size정보를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 칼라사양(칼라제품인 경우)
 * - Data 정의명 : 품질설계 칼라제조사양
 * - Data 조건항목 : 주문번호,주문행번
 * -> Read Count = 1 이면 칼라제조사양 Data의 재단선유무,코팅방식,수지구분전면,
 *    Lamina두께(Lamina제품인경우)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 칼라제조사양 에러처리한다.
 * 2. 편성정보: 기준적용폭, 도금폭수축량기준적용폭
 * - 재단선유무가 'Y'이고 주문Slit조수가 '2'이고 주문폭과 조합폭1이 같은 경우
 *   - 기준적용폭 = 주문폭
 *   - 도금폭수축량기준적용폭 = 주문폭 * 2
 * - 재단선유무가 'Y'이고 주문Slit조수가 '2'이고 주문폭과 조합폭1이 다른 경우
 *   - 기준적용폭 = 조합폭1
 *   - 도금폭수축량기준적용폭 = 주문폭
 * - 주문Slit조수가 2보다크고 주문폭과 조합폭1이 같은 경우
 *   - 기준적용폭 = 주문폭 * 주문Slit조수
 *   - 도금폭수축량기준적용폭 = 주문폭 * 주문Slit조수
 * - 재단선유무가 'Y'가 아니고 주문Slit조수가 '2'이고 주문폭과 조합폭1이 같은 경우
 *   - 기준적용폭 = 주문폭 * 주문Slit조수
 *   - 도금폭수축량기준적용폭 = 주문폭 * 2
 * - 그이외의 경우
 *   - 기준적용폭 = 주문폭
 *   - 도금폭수축량기준적용폭 = 주문폭
 * 3. 편성정보: 도금공정
 * - Data 정의명 : 품질설계결과 통과공정
 * - Data 조건항목 : 주문번호,주문행번
 * -> Read Count > 0 이면 통과공정 Data의 도금공정(주공정,대체공정1,대체공정2)을 편집한다.
 * -> Read Count = 0 이면 통과공정 에러처리한다.
 * 4. 편성정보: 정전폭마진량
 * - Master Data 정의명 : C10B1079
 * - 정전폭마진량기준 Data 조건항목 : 주문EDGE지정구분, 품명코드, 제품형태, 코팅방식, 수지구분전면
 * -> Read Count = 1 이면 정전폭마진량기준 Data의 정전폭마진량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 정전폭마진량기준 에러처리한다.
 * 5. 편성정보: CCL폭수축량(칼라제품인 경우)
 * - Master Data 정의명 : C10B1078
 * - CCL폭수축량기준 Data 조건항목 : 품명코드, 재질코드, PLTCM X-Ray Set치, 기준적용폭
 * -> Read Count = 1 이면 CCL폭수축량기준 Data의 CCL폭수축량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CCL폭수축량기준 에러처리한다.
 * 6. 편성정보: 정전폭감소량(통과공정에 정전공정이 있는경우)
 * - Master Data 정의명 : C10B1077
 * - 정전폭감소량기준 Data 조건항목 : 품명코드, 재질코드, PLTCM X-Ray Set치, 기준적용폭
 * -> Read Count = 1 이면 정전폭감소량기준 Data의 정전폭감소량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 정전폭감소량기준 에러처리한다.
 * 7. 편성정보: CGL폭감소량(용융도금제품인 경우)
 * - Master Data 정의명 : C10B1075
 * - CGL폭감소량기준 Data 조건항목 : CGL공정(주공정), 품명코드, 재질코드, 원자재코드, 
 *                                 PLTCM X-Ray Set치, 도금폭수축량기준적용폭
 * -> Read Count = 1 이면 CGL폭감소량기준 Data의 CGL폭감소량(주공정)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CGL폭감소량기준 에러처리한다.
 * 8. 편성정보: PLTCM ST폭보정기준(용융도금제품인 경우)
 * - Master Data 정의명 : C10B2191
 * - PLTCM ST폭보정기준 Data 조건항목 : 폭관리코드, CGL공정코드(주공정)
 * -> Read Count = 1 이면 PLTCM ST폭보정기준 Data의 PLTCM ST폭보정치(주공정)을 편집한다.
 * -> 에러처리 하지 않는다.
 * 9. 편성정보: CGL폭감소량(용융도금제품이고 대체공정1이 있는경우)
 * - Master Data 정의명 : C10B1075
 * - CGL폭감소량기준 Data 조건항목 : CGL공정(대체공정1), 품명코드, 재질코드, 원자재코드, 
 *                                 PLTCM X-Ray Set치, 도금폭수축량기준적용폭
 * -> Read Count = 1 이면 CGL폭감소량기준 Data의 CGL폭감소량(대체공정1)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CGL폭감소량기준 에러처리한다.
 * 10. 편성정보: PLTCM ST폭보정기준(용융도금제품이고 대체공정1이 있는경우)
 * - Master Data 정의명 : C10B2191
 * - PLTCM ST폭보정기준 Data 조건항목 : 폭관리코드, CGL공정코드(대체공정1)
 * -> Read Count = 1 이면 PLTCM ST폭보정기준 Data의 PLTCM ST폭보정치(대체공정1)을 편집한다.
 * -> 에러처리 하지 않는다.
 * 11. 편성정보: CGL폭감소량(용융도금제품이고 대체공정2가 있는경우)
 * - Master Data 정의명 : C10B1075
 * - CGL폭감소량기준 Data 조건항목 : CGL공정(대체공정2), 품명코드, 재질코드, 원자재코드, 
 *                                 PLTCM X-Ray Set치, 도금폭수축량기준적용폭
 * -> Read Count = 1 이면 CGL폭감소량기준 Data의 CGL폭감소량(대체공정2)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CGL폭감소량기준 에러처리한다.
 * 12. 편성정보: PLTCM ST폭보정기준(용융도금제품이고 대체공정2이 있는경우)
 * - Master Data 정의명 : C10B2191
 * - PLTCM ST폭보정기준 Data 조건항목 : 폭관리코드, CGL공정코드(대체공정2)
 * -> Read Count = 1 이면 PLTCM ST폭보정기준 Data의 PLTCM ST폭보정치(대체공정2)을 편집한다.
 * -> 에러처리 하지 않는다.
 * 13. 편성정보: 중간재적용기준(전기도금제품인 경우)
 * - Master Data 정의명 : C10B2230
 * - 중간재적용기준 Data 조건항목 : 품명코드, 주문두께, 기준적용폭
 * -> Read Count = 1 이면 중간재적용기준 Data의 중간재적용여부를 판단한다.
 *    중간재적용인 경우 도금공정(주공정)을 '92'로 편집한다.
 * -> 에러처리 하지 않는다.
 * 14. 편성정보: EGL폭감소량(전기도금제품인 경우)
 * - Master Data 정의명 : C10B1076
 * - EGL폭감소량기준 Data 조건항목 : EGL공정(주공정), 품명코드, 재질코드, 원자재코드, 
 *                                 PLTCM X-Ray Set치, 도금폭수축량기준적용폭
 * -> Read Count = 1 이면 EGL폭감소량기준 Data의 EGL폭감소량(주공정)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 EGL폭감소량기준 에러처리한다.
 * 15. 편성정보: PLTCM ST폭보정기준(전기도금제품인 경우)
 * - Master Data 정의명 : C10B2191
 * - PLTCM ST폭보정기준 Data 조건항목 : 폭관리코드, EGL공정코드(주공정)
 * -> Read Count = 1 이면 PLTCM ST폭보정기준 Data의 PLTCM ST폭보정치(주공정)을 편집한다.
 * -> 에러처리 하지 않는다.
 * 16. 편성정보: EGL폭감소량(전기도금제품이고 대체공정1이 있는경우)
 * - Master Data 정의명 : C10B1075
 * - EGL폭감소량기준 Data 조건항목 : EGL공정(대체공정1), 품명코드, 재질코드, 원자재코드, 
 *                                 PLTCM X-Ray Set치, 도금폭수축량기준적용폭
 * -> Read Count = 1 이면 EGL폭감소량기준 Data의 EGL폭감소량(대체공정1)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 EGL폭감소량기준 에러처리한다.
 * 17. 편성정보: PLTCM ST폭보정기준(전기도금제품이고 대체공정1이 있는경우)
 * - Master Data 정의명 : C10B2191
 * - PLTCM ST폭보정기준 Data 조건항목 : 폭관리코드, EGL공정코드(대체공정1)
 * -> Read Count = 1 이면 PLTCM ST폭보정기준 Data의 PLTCM ST폭보정치(대체공정1)을 편집한다.
 * -> 에러처리 하지 않는다.
 * 18. 편성정보: EGL폭감소량(전기도금제품이고 대체공정2가 있는경우)
 * - Master Data 정의명 : C10B1075
 * - EGL폭감소량기준 Data 조건항목 : EGL공정(대체공정2), 품명코드, 재질코드, 원자재코드, 
 *                                 PLTCM X-Ray Set치, 도금폭수축량기준적용폭
 * -> Read Count = 1 이면 EGL폭감소량기준 Data의 EGL폭감소량(대체공정2)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 EGL폭감소량기준 에러처리한다.
 * 17. 편성정보: PLTCM ST폭보정기준(전기도금제품이고 대체공정2이 있는경우)
 * - Master Data 정의명 : C10B2191
 * - PLTCM ST폭보정기준 Data 조건항목 : 폭관리코드, EGL공정코드(대체공정2)
 * -> Read Count = 1 이면 PLTCM ST폭보정기준 Data의 PLTCM ST폭보정치(대체공정2)을 편집한다.
 * -> 에러처리 하지 않는다.
 * 18. 편성정보: CGL목표폭, EGL목표폭, CCL목표두께, 중간정전목표두께, CGL목표두께, EGL목표두께
 * - 재단선유무가 'Y'이고 품명코드가 '3','4','5'인경우
 *   - CGL목표폭 = 중간정전목표폭 + 정전폭감소량 + 정전폭마진량
 *   - CCL목표두께 = 제품목표두께
 *   - 중간정전목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 *   - CGL목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 * - 재단선유무가 'Y'가 아니고 품명코드가 '3','4','5'인경우
 *   - CGL목표폭 = 중간정전목표폭 + 정전폭감소량
 *   - CCL목표두께 = 제품목표두께
 *   - 중간정전목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 *   - CGL목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 * - 재단선유무가 'Y'이고 품명코드가 '2'인경우
 *   - EGL목표폭 = 중간정전목표폭 + 정전폭감소량 + 정전폭마진량
 *   - CCL목표두께 = 제품목표두께
 *   - 중간정전목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 *   - EGL목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 * - 재단선유무가 'Y'가 아니고 품명코드가 '2'인경우
 *   - EGL목표폭 = 중간정전목표폭 + 정전폭감소량
 *   - CCL목표두께 = 제품목표두께
 *   - 중간정전목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 *   - EGL목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 * - 재단선유무가 'Y'이고 품명코드가 '1'인경우
 *   - CCL목표두께 = 제품목표두께
 *   - 중간정전목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 * - 재단선유무가 'Y'가 아니고 품명코드가 '1'인경우
 *   - CCL목표두께 = 제품목표두께
 *   - 중간정전목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 * - 품명코드가 '5','7'인경우
 *   - CCL목표두께 = 제품목표두께
 *   - 중간정전목표두께 = 제품목표두께 - 도막두께 전후면/1000 + 라미나두께(라미나제품인 경우)
 * - 품명코드가 'G','K','J','L'인경우
 *   - CGL목표폭 = 제품목표폭 + 정전폭감소량 + 정전폭마진량
 *   - CGL목표두께 = 제품목표두께
 * - 품명코드가 'E'인경우
 *   - EGL목표폭 = 제품목표폭 + 정전폭감소량 + 정전폭마진량
 *   - EGL목표두께 = 제품목표두께
 * 19. 편성정보: PLTCM목표폭, PLTCM목표폭 대체공정1, PLTCM목표폭 대체공정2, TM목표폭,
 *              TM목표폭 대체공정1, TM목표폭 대체공정2
 * - 품명코드가 용융도금제품인경우
 *   - PLTCM목표폭 = CGL목표폭 + CGL폭소량(주공정)
 *   - CGL대체공정1이 있는경우
 *      - PLTCM목표폭 대체공정1 = CGL목표폭 + CGL폭소량(대체공정1)
 *   - CGL대체공정2가 있는경우
 *      - PLTCM목표폭 대체공정2 = CGL목표폭 + CGL폭소량(대체공정2)
 * - 품명코드가 전기도금제품인경우
 *   - 주문두께 구분이 '1'인경우
 *     - TM목표두께 = EGL목표두께 - ( 규격도금두께 / 1000 )
 *   - 주문두께 구분이 '1'인경우
 *     - TM목표두께 = EGL목표두께 - ( 목표도금두께 / 1000 )
 *   - TM목표폭 = EGL목표폭 + EGL폭소량(주공정)
 *   - PLTCM목표폭 = EGL목표폭 + EGL폭소량(주공정)
 *   - EGL대체공정1이 있는경우
 *      - PLTCM목표폭 대체공정1 = EGL목표폭 + EGL폭소량(대체공정1)
 *      - TM목표폭 대체공정1 = EGL목표폭 + EGL폭소량(대체공정1)
 *   - EGL대체공정2가 있는경우
 *      - PLTCM목표폭 대체공정2 = EGL목표폭 + EGL폭소량(대체공정2)
 *      - TM목표폭 대체공정2 = EGL목표폭 + EGL폭소량(대체공정2)
 * - 품명코드가 '1'인경우 *     
 *     - TM목표두께 = 제품목표두께 - ( 도막두께전후면 / 1000 ) + 라미나두께(라미나제품인 경우)
 *     - 재단선유무가 'Y'인 경우
 *       - TM목표폭 = 중간정전목표폭 + 정전폭마진량
 *     - 재단선유무가 'Y'가 아닌경우
 *       - TM목표폭 = CCL목표두께 + CCL폭수축량
 *     - PLTCM목표폭 = TM목표폭
 *     - PLTCM목표폭 대체공정1 = 0
 *     - PLTCM목표폭 대체공정2 = 0
 * - 품명코드가 'C'인경우     
 *     - TM목표두께 = 제품목표두께
 *     - 주문EDGE지정구분이 'S'나'C'인 경우
 *       - TM목표폭 = 제품목표폭 + 정전폭마진량 + 정전폭감소량
 *     - 그이외의 경우
 *       - TM목표폭 = 제품목표폭 + 정전폭감소량
 *     - PLTCM목표폭 = TM목표폭
 *     - PLTCM목표폭 대체공정1 = 0
 *     - PLTCM목표폭 대체공정2 = 0
 * - 품명코드가 'D'인경우     
 *     - PLTCM목표폭 = 제품목표폭
 * 20. 편성정보: PLTCM두께공차(알루미늄칼라, 스테인레스칼라제외)
 * - Master Data 정의명 : C10B2190
 * - PLTCM두께공차기준 Data 조건항목 : PLTCM X-Ray Set치
 * -> Read Count = 1 이면 PLTCM두께공차기준 Data의 PLTCM두께공차상하한값을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM두께공차기준 에러처리한다.
 * 21. 편성정보: PLTCM두께범위(알루미늄칼라, 스테인레스칼라제외)
 * - PLTCM두께범위 하한 = PLTCM X-Ray Set치 + PLTCM두께공차하한값
 * - PLTCM두께범위 상한 = PLTCM X-Ray Set치 + PLTCM두께공차상한값
 * 22. 편성정보: PLTCM 5Stand W/R Type Set기준(알루미늄칼라, 스테인레스칼라제외)
 * - Master Data 정의명 : C10B2110
 * - PLTCM 5Stand W/R Type Set기준 Data 조건항목 : PLTCM X-Ray Set치
 * -> Read Count = 1 이면 PLTCM 5Stand W/R Type Set기준 Data의 PLTCM5StandWRType을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM 5Stand W/R Type Set기준 에러처리한다.
 * 23. 편성정보: PLTCM Sleeve유무 Set기준(알루미늄칼라, 스테인레스칼라제외)
 * - Master Data 정의명 : C10B2120
 * - PLTCM Sleeve유무 Set기준 Data 조건항목 : PLTCM X-Ray Set치
 * -> Read Count = 1 이면 PLTCM Sleeve유무 Set기준 Data의 PLTCM내경링사용여부를 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM Sleeve유무 Set기준 에러처리한다.
 * 24. 편성정보: PLTCM폭수축량기준(알루미늄칼라, 스테인레스칼라제외)
 * - Master Data 정의명 : C10B1074
 * - PLTCM폭수축량기준 Data 조건항목 : 원자재코드, PLTCM X-Ray Set치, PLTCM목표폭(주공정)
 * -> Read Count = 1 이면 PLTCM폭수축량기준 Data의 PLTCM폭수축량(주공정)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM폭수축량기준 에러처리한다.
 * 25. 편성정보: PLTCM폭수축량기준 대체공정1(알루미늄칼라, 스테인레스칼라제외 PLTCM목표폭 대체공정1이 있을경우)
 * - Master Data 정의명 : C10B1074
 * - PLTCM폭수축량기준 Data 조건항목 : 원자재코드, PLTCM X-Ray Set치, PLTCM목표폭(대체공정1)
 * -> Read Count = 1 이면 PLTCM폭수축량기준 Data의 PLTCM폭수축량(대체공정1)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM폭수축량기준 에러처리한다.
 * 26. 편성정보: PLTCM폭수축량기준 대체공정2(알루미늄칼라, 스테인레스칼라제외 PLTCM목표폭 대체공정2이 있을경우)
 * - Master Data 정의명 : C10B1074
 * - PLTCM폭수축량기준 Data 조건항목 : 원자재코드, PLTCM X-Ray Set치, PLTCM목표폭(대체공정2)
 * -> Read Count = 1 이면 PLTCM폭수축량기준 Data의 PLTCM폭수축량(대체공정2)을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM폭수축량기준 에러처리한다.
 * 27. 편성정보: PL폭목표값 최대값
 * - PLTCM폭목표값 + PLTCM폭수축량(주공정) , PLTCM폭대체공정1목표값 + PLTCM폭수축량(대체공정1),
 *   PLTCM폭대체공정2목표값 + PLTCM폭수축량(대체공정2) 중 가장 큰수치로 편집한다.
 * 28. 편성정보: PL폭목표값 , PL목표폭 대체공정1, PL목표폭 대체공정2
 * - PLTCM폭목표값 + PLTCM폭수축량(주공정) + PLTCM ST폭보정치(주공정) > PL폭목표값 최대값 이면
 *   - PL폭목표값 = PL폭목표값 최대값
 * - PLTCM폭목표값 + PLTCM폭수축량(주공정) + PLTCM ST폭보정치(주공정) < PL폭목표값 최대값 이면
 *   - PL폭목표값 = PLTCM폭목표값 + PLTCM폭수축량(주공정) + PLTCM ST폭보정치(주공정)
 * - PLTCM폭대체공정1목표값 + PLTCM폭수축량(대체공정1) + PLTCM ST폭보정치(대체공정1) > PL폭목표값 최대값 이면
 *   - PL폭대체공정1목표값 = PL폭목표값 최대값
 * - PLTCM폭대체공정1목표값 + PLTCM폭수축량(대체공정1) + PLTCM ST폭보정치(대체공정1) < PL폭목표값 최대값 이면
 *   - PL폭대체공정1목표값 = PLTCM폭대체공정1목표값 + PLTCM폭수축량(대체공정1) + PLTCM ST폭보정치(대체공정1)
 * - PLTCM폭대체공정2목표값 + PLTCM폭수축량(대체공정2) + PLTCM ST폭보정치(대체공정2) > PL폭목표값 최대값 이면
 *   - PL폭대체공정2목표값 = PL폭목표값 최대값
 * - PLTCM폭대체공정2목표값 + PLTCM폭수축량(대체공정2) + PLTCM ST폭보정치(대체공정2) < PL폭목표값 최대값 이면
 *   - PL폭대체공정2목표값 = PLTCM폭대체공정2목표값 + PLTCM폭수축량(대체공정2) + PLTCM ST폭보정치(대체공정2)
 * 29. 편성정보: PLTCM EDGE지정구분
 * - 주문EDGE지정구분이 'S', 'M'인 경우
 *   PLTCM EDGE지정구분 = 'Y'
 * - 그이외의 경우
 *   PLTCM EDGE지정구분 = 'N'
 * 30. 편성정보: 정전EDGE지정구분
 * - 주문EDGE지정구분이 'S', 'C'인 경우
 *   정전EDGE지정구분 = 'Y'
 * - 그이외의 경우
 *   정전EDGE지정구분 = 'N'
 * 31. 편성한 결과는 PosContext에 등록
 * 32. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchProcSizeData">
 * <transition name="success" value="C103100010-service" />
 * <property name="dao" value="masterdao" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchProcSizeData extends PosActivity implements C10NuiConstantsIF
{

    /**
     * <p>
     * 이 메소드는 PosActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다.
     * </p>
     * 
     * @throws PosException IO Exception 발생 시
     * @param ctx Service내의 Data를 관리하는 PosContext 객체
     * @return success - 성공적으로 끝났을 때 Route transition.
     *         nullpointer - NullPointerException 발생 시 Route transtion.
     *         faillue - 그 외 Exception 발생 시 Route transition.
     */
    public String runActivity( PosContext ctx )
    {
        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );
        PosParameter param = new PosParameter(); // MD View param

        PosDecisionChecker checker = null;
        PosRuleVO result = null;
        String colValue[] = null; // 컬럼값
        PosRowSet rowset = null;
        PosRow row = null;

        double ord_exc_thk = 0;
        double ord_exc_wth = 0;
        double cegl_exc_wth = 0;
        String rmtl_cd = C10STR_SPACE;
        String tmp_rmtl_cd = C10STR_SPACE;
        String ord_no = C10STR_SPACE;
        String ord_ln = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String prd_shp = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        String ord_thk_tp = C10STR_SPACE;
        String mql_cd = C10STR_SPACE;
        String main_proc_cd = C10STR_SPACE;
        String cgl_proc_cd = C10STR_SPACE;
        String cgl_proc_cd1 = C10STR_SPACE;
        String cgl_proc_cd2 = C10STR_SPACE;
        String egl_proc_cd = C10STR_SPACE;
        String egl_proc_cd1 = C10STR_SPACE;
        String egl_proc_cd2 = C10STR_SPACE;
        String cut_ln_yn = C10STR_SPACE;
        String cot_mth = C10STR_SPACE;
        String rsn_tp_frn = C10STR_SPACE;
        String ccl_bom_no = C10STR_SPACE;
        String ord_wth_mng_cd = C10STR_SPACE;
        String qlt_dsn_mnf_tp = C10STR_SPACE;
        String ord_spnl_tp = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        String cus_bth_pap_no = C10STR_SPACE;
        double pltcm_set_thk_trv = 0;
        double gal_thk_trv = 0;
        double cor_thk_trv = 0;
        double ccl_thk_trv = 0;
        double cgl_thk_trv = 0;
        double cor_wth_trv = 0;
        double col_wth_shr = 0;
        double col_wth_mgn = 0;
        double ccl_wth_shr = 0;
        double cgl_wth_shr = 0;
        double cgl_wth_shr1 = 0;
        double cgl_wth_shr2 = 0;
        double egl_wth_shr = 0;
        double egl_wth_shr1 = 0;
        double egl_wth_shr2 = 0;
        double ccl_wth_trv = 0;
        double cgl_wth_trv = 0;
        double egl_thk_trv = 0;
        double egl_wth_trv = 0;
        double mid_cor_wth_trv = 0;
        double pnt_flm_thk_frn_tot = 0;
        double pnt_flm_thk_bak_tot = 0;
        double tm_thk_trv = 0;
        double tm_wth_trv = 0;
        double tm_wth_sub_proc1_trv = 0;
        double tm_wth_sub_proc2_trv = 0;
        double pltcm_thk_trv = 0;
        double pltcm_thk_llv = 0;
        double pltcm_thk_ulv = 0;
        double pltcm_wth_trv = 0;
        double pltcm_wth_sub_proc1_trv = 0;
        double pltcm_wth_sub_proc2_trv = 0;
        double pltcm_wth_cor_val = 0;
        double pltcm_wth_sub_proc1_cor_val = 0;
        double pltcm_wth_sub_proc2_cor_val = 0;
        double pltcm_wth_trv_max = 0;
        double mid_cor_thk_trv = 0;
        boolean mid_cor_proc = false;
        boolean cor_proc = false;
        double ord_slit_grp_cnt = 0;
        double ord_mix_wth1 = 0;
        double ord_mix_wth2 = 0;
        double ord_mix_wth3 = 0;
        double ord_mix_wth4 = 0;
        double ord_mix_wth5 = 0;
        double ord_mix_wth6 = 0;
        double ord_mix_wth7 = 0;
        double ord_mix_wth8 = 0;
        double ord_mix_wth9 = 0;
        double ord_mix_wth10 = 0;
        double tcm_wth_shr_qty = 0;
        double tcm_wth_shr_qty1 = 0;
        double tcm_wth_shr_qty2 = 0;
                
        if ( !DbCommonUtil.isNull( ctx.get( COL_QLT_DSN_MNF_TP ) ) )
        	qlt_dsn_mnf_tp = ctx.get( COL_QLT_DSN_MNF_TP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_BOM_NO ) ) )
            ccl_bom_no = ctx.get( COL_CCL_BOM_NO ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD ) ) )
            rmtl_cd = (String) ctx.get( COL_RMTL_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = Double.parseDouble( ctx.get( COL_ORD_EXC_THK ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) )
            ord_no = ctx.get( COL_ORD_NO ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) )
            ord_ln = ctx.get( COL_ORD_LN ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = ctx.get( COL_PRD_NM_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_SHP ) ) )
            prd_shp = ctx.get( COL_PRD_SHP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EDG_ASG_TP ) ) )
            ord_edg_asg_tp = ctx.get( COL_ORD_EDG_ASG_TP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_MQL_CD ) ) )
            mql_cd = ctx.get( COL_MQL_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_THK_TP ) ) )
            ord_thk_tp = ctx.get( COL_ORD_THK_TP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_SET_THK_TRV ) ) )
            pltcm_set_thk_trv = Double.parseDouble( ctx.get( COL_PLTCM_SET_THK_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_COR_THK_TRV ) ) )
            cor_thk_trv = Double.parseDouble( ctx.get( COL_COR_THK_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_COR_WTH_TRV ) ) )
            cor_wth_trv = Double.parseDouble( ctx.get( COL_COR_WTH_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_WTH_TRV ) ) )
            ccl_wth_trv = Double.parseDouble( ctx.get( COL_CCL_WTH_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_MID_COR_WTH_TRV ) ) )
            mid_cor_wth_trv = Double.parseDouble( ctx.get( COL_MID_COR_WTH_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_GAL_THK_TRV ) ) )
            gal_thk_trv = Double.parseDouble( ctx.get( COL_GAL_THK_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PNT_FLM_THK_FRN_TOT ) ) )
            pnt_flm_thk_frn_tot = Double.parseDouble( ctx.get( COL_PNT_FLM_THK_FRN_TOT ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PNT_FLM_THK_BAK_TOT ) ) )
            pnt_flm_thk_bak_tot = Double.parseDouble( ctx.get( COL_PNT_FLM_THK_BAK_TOT ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_THK_TRV ) ) )
            pltcm_thk_trv = Double.parseDouble( ctx.get( COL_PLTCM_THK_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SLIT_GRP_CNT ) ) )
            ord_slit_grp_cnt = Double.parseDouble( ctx.get( COL_ORD_SLIT_GRP_CNT ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH1 ) ) )
            ord_mix_wth1 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH1 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH2 ) ) )
            ord_mix_wth2 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH2 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH3 ) ) )
            ord_mix_wth3 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH3 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH4 ) ) )
            ord_mix_wth4 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH4 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH5 ) ) )
            ord_mix_wth5 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH5 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH6 ) ) )
            ord_mix_wth6 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH6 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH7 ) ) )
            ord_mix_wth7 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH7 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH8 ) ) )
            ord_mix_wth8 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH8 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH9 ) ) )
            ord_mix_wth9 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH9 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH10 ) ) )
            ord_mix_wth10 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH10 ).toString() );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_WTH_MNG_CD ) ) )
            ord_wth_mng_cd = (String) ctx.get( COL_ORD_WTH_MNG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_SPNL_TP ) ) )
            ord_spnl_tp = (String) ctx.get( COL_ORD_SPNL_TP );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_FNL_CUS_CD ) ) )
            fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_CUS_BTH_PAP_NO ) ) )
        	cus_bth_pap_no = (String) ctx.get( COL_CUS_BTH_PAP_NO );
        
        
        // 2025.10.24 APS 수정이 완료될 때까지 임시 조치
        // 적정이 F/H, 차선이 H/C일 경우 적정 ST폭값에 차선 ST폭값을 업데이트
        if(qlt_dsn_mnf_tp.equals("1") && rmtl_cd.toString().substring(0,1).equals("D")){
//        	if(rmtl_cd.equals("D32")){
//        		rmtl_cd = "H32";
//        	}else if(rmtl_cd.equals("D36")){
//        		rmtl_cd = "H36";
//        	}else if(rmtl_cd.equals("D37")){
//        		rmtl_cd = "H39";
//        	}
        	
            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ord_no );
            param.setWhereClauseParameter( 1, ord_ln );

            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( SELECT_MNF2, param ); // 칼라제조사양.select
            } catch ( Exception e )
            {
                rowset = null;
//                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
//                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
//                return PosBizControlConstants.SUCCESS;
            }
            if ( rowset.count() == 0 )
            {
//                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
//                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
//                logger.logError( ERRMSG_R98 );
//                return PosBizControlConstants.FAILURE;
            	logger.logError("차선이 없음");
            } else
            {
                row = rowset.next();
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_RMTL_CD ) ) )
                	tmp_rmtl_cd = DbCommonUtil.valueOf( row.getAttribute( COL_RMTL_CD ) );
            }        	
            
            logger.logInfo("기존rmtl_cd " + rmtl_cd);
            if(tmp_rmtl_cd.toString().substring(0,1).equals("H")){
            	rmtl_cd = tmp_rmtl_cd;
            	logger.logInfo("변경rmtl_cd " + rmtl_cd);
            }
        	
        }
        // 2025.10.24 APS 수정이 완료될 때까지 임시 조치 끝
        

        if ( !qlt_dsn_mnf_tp.equals("1")  && 
            	!rmtl_cd.toString().substring(0,1).equals("H") && !rmtl_cd.toString().substring(0,1).equals("M") && 
            	!prd_nm_cd.toString().equals("5") && !prd_nm_cd.toString().equals("7") ){                          //구매반제품 원자재 차선등록의 경우(CCAI, CCUS 제외)
                
            	ctx.put( COL_SEM_RMTL_YN, C10STR_YES );
            	return PosBizControlConstants.SUCCESS;
        }
        
        // 칼라제품 공정코드 Check
        if ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                prd_nm_cd.equals( PRD_NM_CD_5 ) || 
                prd_nm_cd.equals( PRD_NM_CD_6 ) ||
                prd_nm_cd.equals( PRD_NM_CD_7 ) ||
                prd_nm_cd.equals( PRD_NM_CD_8 ) ||
                prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ord_no );
            param.setWhereClauseParameter( 1, ord_ln );

            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( SELECT_MNF_CCL_BOM, param ); // 칼라제조사양.select
            } catch ( Exception e )
            {
                rowset = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
            if ( rowset.count() == 0 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R98 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                row = rowset.next();
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_CUT_LN_YN ) ) )
                    cut_ln_yn = DbCommonUtil.valueOf( row.getAttribute( COL_CUT_LN_YN ) );

                cot_mth = DbCommonUtil.valueOf( row.getAttribute( COL_COT_MTH ) );
                rsn_tp_frn = DbCommonUtil.valueOf( row.getAttribute( COL_RSN_TP_FRN ) );
                
                if ( cut_ln_yn.equals( C10STR_YES ) )
                    mid_cor_proc = true;
            }
        }

        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
        {
            if ( cut_ln_yn.equals( C10STR_YES ) && 
                    Double.compare( ord_slit_grp_cnt , 2) == 0 && 
                            Double.compare( 
                                    Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
                                    ord_mix_wth1 ) == 0 )
            {
                ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
                cegl_exc_wth =  Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * 2;
            }
            else if ( cut_ln_yn.equals( C10STR_YES ) && 
                    Double.compare( ord_slit_grp_cnt , 2) == 0 && 
                    Double.compare( 
                            Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
                            ord_mix_wth1 ) != 0 )
            {
                ord_exc_wth = ord_mix_wth1;
                cegl_exc_wth =  Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
            }
            // else if ( ( Double.compare( ord_slit_grp_cnt, 2 ) > 0 && 
            //         Double.compare( 
            //                Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
            //                ord_mix_wth1 ) == 0 ) || 
            //        ( !cut_ln_yn.equals( C10STR_YES ) && 
            //                Double.compare( ord_slit_grp_cnt , 2) == 0 && 
            //                Double.compare( 
            //                        Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
            //                        ord_mix_wth1 ) == 0 ) )
            //{
            //    ord_exc_wth = 
            //    Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * ord_slit_grp_cnt;
            //    cegl_exc_wth =
            //            Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * ord_slit_grp_cnt;
            // }
            else if ( ord_slit_grp_cnt > 0 )
            {
                ord_exc_wth =  ord_mix_wth1 + ord_mix_wth2 + ord_mix_wth3 + ord_mix_wth4 + ord_mix_wth5
      		                      + ord_mix_wth6 + ord_mix_wth7 + ord_mix_wth8 + ord_mix_wth9 + ord_mix_wth10;
                cegl_exc_wth = ord_exc_wth;
            }
            else
            {
                cegl_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
                ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
            }
        }

        // 통과공정
        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ord_no );
        param.setWhereClauseParameter( 1, ord_ln );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( SELECT_PROC, param ); // 통과공정.select
        } catch ( MasterDataException e )
        {
            rowset = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK21 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( rowset.count() > 0 )
        {
            while ( rowset.hasNext() )
            {
                row = rowset.next();
                main_proc_cd = row.getAttribute( COL_MAIN_PROC_CD ).toString();
                if ( row.getAttribute( COL_MAIN_PROC_CD ).toString().substring( 0, 1 ).equals( NUM8 ) )
                {
                    // CGL 공정
                    cgl_proc_cd = row.getAttribute( COL_MAIN_PROC_CD ).toString();
                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_SUB_PROC_CD1 ) ) )
                        cgl_proc_cd1 = row.getAttribute( COL_SUB_PROC_CD1 ).toString();
                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_SUB_PROC_CD2 ) ) )
                        cgl_proc_cd2 = row.getAttribute( COL_SUB_PROC_CD2 ).toString();
                } else if ( row.getAttribute( COL_MAIN_PROC_CD ).toString().substring( 0, 1 ).equals( NUM9 ) )
                {
                    // EGL 공정
                    egl_proc_cd = row.getAttribute( COL_MAIN_PROC_CD ).toString();
                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_SUB_PROC_CD1 ) ) )
                        egl_proc_cd1 = row.getAttribute( COL_SUB_PROC_CD1 ).toString();
                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_SUB_PROC_CD2 ) ) )
                        egl_proc_cd2 = row.getAttribute( COL_SUB_PROC_CD2 ).toString();
                } else if ( main_proc_cd.substring( 0, 1 ).equals( NUM7 ) || 
                        main_proc_cd.substring( 0, 1 ).equals( NUM6 ) )
                {
                    cor_proc = true;
                }
            }
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK21 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R84 );
            return PosBizControlConstants.FAILURE;
        }

        // 정전폭마진량
        colValue = new String[8];
        colValue[0] = ord_edg_asg_tp; // 주문에지구분
        colValue[1] = prd_nm_cd; // 품명코드
        colValue[2] = prd_shp; // 제품형태
        colValue[3] = cot_mth; // 코팅방식
        colValue[4] = rsn_tp_frn; // 수지구분 전면
        colValue[5] = Double.toString( ord_exc_thk ); //정전폭마진기준에서 주문두께 추가(2013.05.29 김태성대리 요청)
        colValue[6] = ccl_bom_no; //정전폭마진기준에서 ccl bom번호 추가(2015.09.03 김태훈사원 요청)
        colValue[7] = ord_spnl_tp; //주문스팽글구분(2020.09.25 전현진과장요청)
        checker = EasyAccess.getPosDecisionChecker( C10B1079, null );
        result = null;
        try
        {
            result = checker.getPosRule( colValue );
            
        } catch ( MasterDataException e )
        {
            rowset = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT28 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( result.getRecordCount() == 1 )
        {
            col_wth_mgn = Double.parseDouble( result.getRuleValueAt( COL_MRG_WTH ) );
            
            logger.logInfo(colValue[0] + "," + colValue[1] + "," + colValue[2] + "," + colValue[3] + "," + colValue[4] + "," + colValue[5] + "," + colValue[6]);
            logger.logInfo("정전폭마진량 결과: " + col_wth_mgn);
        } else if ( result.getRecordCount() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT29 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R104 );
            return PosBizControlConstants.FAILURE;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT28 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R103 );
            return PosBizControlConstants.FAILURE;
        }
        
        // COLOR 제품
        if ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                prd_nm_cd.equals( PRD_NM_CD_5 ) || 
                prd_nm_cd.equals( PRD_NM_CD_6 ) ||
                prd_nm_cd.equals( PRD_NM_CD_7 ) ||
                prd_nm_cd.equals( PRD_NM_CD_8 ) ||
                prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            // CCL폭수축량
            colValue = new String[4];
            colValue[0] = prd_nm_cd; // 품명
            colValue[1] = mql_cd; // 재질코드
            colValue[2] = Double.toString( pltcm_set_thk_trv ); // 주문두께
            colValue[3] = Double.toString( ord_exc_wth ); // 주문폭
            checker = EasyAccess.getPosDecisionChecker( C10B1078, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT26 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result.getRecordCount() == 1 )
            {
                ccl_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_CCL_WTH_SHR_QTY ) );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT27 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R89 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT26 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R88 );
                return PosBizControlConstants.FAILURE;
            }
        }

        // 정전공정통과
        if ( cor_proc )
        {
            // 정전폭감소량
            colValue = new String[4];
            colValue[0] = prd_nm_cd; // 품명
            colValue[1] = mql_cd; // 재질코드
            colValue[2] = Double.toString( pltcm_set_thk_trv ); // 주문두께
            colValue[3] = Double.toString( ord_exc_wth ); // 주문폭
            checker = EasyAccess.getPosDecisionChecker( C10B1077, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT24 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result.getRecordCount() == 1 )
            {
                col_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_WTH_SHR_QTY ) );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT25 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R102 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT24 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R101 );
                return PosBizControlConstants.FAILURE;
            }
        }

        // CGL 제품
        if ( prd_nm_cd.equals( PRD_NM_CD_G ) ||
        		prd_nm_cd.equals( PRD_NM_CD_K ) ||
                prd_nm_cd.equals( PRD_NM_CD_J ) || 
                prd_nm_cd.equals( PRD_NM_CD_L ) || 
                prd_nm_cd.equals( PRD_NM_CD_V ) || 
                prd_nm_cd.equals( PRD_NM_CD_W ) || 
                prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                prd_nm_cd.equals( PRD_NM_CD_6 ) || 
                prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            // CGL폭감소량
            colValue = new String[6];
            colValue[0] = cgl_proc_cd; // 공정코드
            colValue[1] = prd_nm_cd; // 품명
            colValue[2] = mql_cd; // 재질코드
           	colValue[3] = rmtl_cd; // 원자재코드
            colValue[4] = Double.toString( pltcm_set_thk_trv ); // 주문두께
            colValue[5] = Double.toString( cegl_exc_wth ); // 주문폭
            checker = EasyAccess.getPosDecisionChecker( C10B1075, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT20 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result.getRecordCount() == 1 )
            {
                cgl_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_GAL_WTH_SHR_QTY ) );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT21 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R106 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT20 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R105 );
                return PosBizControlConstants.FAILURE;
            }

            // PLTCM ST폭보정기준
            colValue = new String[3];
            colValue[0] = prd_nm_cd; // 품명코드
            colValue[1] = ord_wth_mng_cd; // 폭관리코드
            colValue[2] = cgl_proc_cd; // 공정코드
            checker = EasyAccess.getPosDecisionChecker( C10B2191, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            	pltcm_wth_cor_val = Double.parseDouble( result.getRuleValueAt( COL_WTH_COR_VAL ) );
            } catch ( MasterDataException e )
            {
                logger.logError( C10B2191 + C10STR_COLON + e.getMessage() );
            }
            
            if ( !cgl_proc_cd1.equals( C10STR_SPACE ) )
            {
                colValue = new String[6];
                colValue[0] = cgl_proc_cd1; // 공정코드
                colValue[1] = prd_nm_cd; // 품명
                colValue[2] = mql_cd; // 재질코드
               	colValue[3] = rmtl_cd; // 원자재코드
                colValue[4] = Double.toString( pltcm_set_thk_trv ); // 주문두께
                colValue[5] = Double.toString( cegl_exc_wth ); // 주문폭
                checker = EasyAccess.getPosDecisionChecker( C10B1075, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );

                    if ( result.getRecordCount() == 1 )
                    {
                        cgl_wth_shr1 = Double.parseDouble( result.getRuleValueAt( COL_GAL_WTH_SHR_QTY ) );

                    } else if ( result.getRecordCount() > 1 )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT21 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R106 );
                    } else
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT20 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R105 );
                    }
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT20 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                }

                // PLTCM ST폭보정기준
                colValue = new String[3];
                colValue[0] = prd_nm_cd; // 품명코드
                colValue[1] = ord_wth_mng_cd; // 폭관리코드
                colValue[2] = cgl_proc_cd1; // 공정코드

                checker = EasyAccess.getPosDecisionChecker( C10B2191, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );
                	pltcm_wth_sub_proc1_cor_val = Double.parseDouble( result.getRuleValueAt( COL_WTH_COR_VAL ) );
                    
                } catch ( MasterDataException e )
                {
                    logger.logError( C10B2191 + C10STR_COLON + e.getMessage() );
                }
            }

            if ( !cgl_proc_cd2.equals( C10STR_SPACE ) )
            {
                colValue = new String[6];
                colValue[0] = cgl_proc_cd2; // 공정코드
                colValue[1] = prd_nm_cd; // 품명
                colValue[2] = mql_cd; // 재질코드
               	colValue[3] = rmtl_cd; // 원자재코드
                colValue[4] = Double.toString( pltcm_set_thk_trv ); // 주문두께
                colValue[5] = Double.toString( cegl_exc_wth ); // 주문폭
                checker = EasyAccess.getPosDecisionChecker( C10B1075, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );

                    if ( result.getRecordCount() == 1 )
                    {
                        cgl_wth_shr2 = Double.parseDouble( result.getRuleValueAt( COL_GAL_WTH_SHR_QTY ) );

                    } else if ( result.getRecordCount() > 1 )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT21 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R106 );
                    } else
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT20 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R105 );
                    }
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT20 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                }
                
                // PLTCM ST폭보정기준
                colValue = new String[3];
                colValue[0] = prd_nm_cd; // 품명코드
                colValue[1] = ord_wth_mng_cd; // 폭관리코드
                colValue[2] = cgl_proc_cd2; // 공정코드
                
                checker = EasyAccess.getPosDecisionChecker( C10B2191, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );
                	pltcm_wth_sub_proc2_cor_val = Double.parseDouble( result.getRuleValueAt( COL_WTH_COR_VAL ) );
                    
                } catch ( MasterDataException e )
                {
                    logger.logError( C10B2191 + C10STR_COLON + e.getMessage() );
                }
            }
        }

        // EGL 제품)
        if ( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_2 ) || prd_nm_cd.equals( PRD_NM_CD_N ) || prd_nm_cd.equals( PRD_NM_CD_8 )){
            colValue = new String[6];
            colValue[0] = prd_nm_cd; // 품명
            colValue[1] = Double.toString( ord_exc_thk ); // 두께
            colValue[2] = Double.toString( cegl_exc_wth ); // 주문폭
            colValue[3] = fnl_cus_cd; // 최종수요가
            colValue[4] = cus_bth_pap_no ; // 고객사양번호
            colValue[5] = ccl_bom_no; // ccl bom
            checker = EasyAccess.getPosDecisionChecker( C10B2230, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
                
                if ( result.getRecordCount() == 1 )
                {
                    egl_proc_cd = NUM9 + NUM2;
                } else if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK91 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R151 );
                    return PosBizControlConstants.FAILURE;
                }

            } catch ( MasterDataException e )
            {
                result = null;
            }
            
            // EGL폭수축량
            colValue = new String[6];
            colValue[0] = egl_proc_cd; // 공정코드
            colValue[1] = prd_nm_cd; // 품명
            colValue[2] = mql_cd; // 재질코드
           	colValue[3] = rmtl_cd; // 원자재코드
            colValue[4] = Double.toString( pltcm_set_thk_trv ); // 주문두께
            colValue[5] = Double.toString( cegl_exc_wth ); // 주문폭
            checker = EasyAccess.getPosDecisionChecker( C10B1076, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT22 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result.getRecordCount() == 1 )
            {
                egl_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_EGL_WTH_SHR_QTY ) );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT23 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R108 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT22 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R107 );
                return PosBizControlConstants.FAILURE;
            }
            
            // PLTCM ST폭보정기준
            colValue = new String[2];
            colValue[0] = ord_wth_mng_cd; // 폭관리코드
            colValue[1] = egl_proc_cd; // 공정코드
            checker = EasyAccess.getPosDecisionChecker( C10B2191, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
                pltcm_wth_cor_val = Double.parseDouble( result.getRuleValueAt( COL_WTH_COR_VAL ) );
                
            } catch ( MasterDataException e )
            {
                logger.logError( C10B2191 + C10STR_COLON + e.getMessage() );
            }

            if ( !egl_proc_cd1.equals( C10STR_SPACE ) )
            {
                colValue = new String[6];
                colValue[0] = egl_proc_cd1; // 공정코드
                colValue[1] = prd_nm_cd; // 품명
                colValue[2] = mql_cd; // 재질코드
               	colValue[3] = rmtl_cd; // 원자재코드
                colValue[4] = Double.toString( pltcm_set_thk_trv ); // 주문두께
                colValue[5] = Double.toString( cegl_exc_wth ); // 주문폭
                checker = EasyAccess.getPosDecisionChecker( C10B1076, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );

                    if ( result.getRecordCount() == 1 )
                    {
                        egl_wth_shr1 = Double.parseDouble( result.getRuleValueAt( COL_EGL_WTH_SHR_QTY ) );

                    } else if ( result.getRecordCount() > 1 )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT23 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R108 );
                    } else
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT22 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R107 );
                    }
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT22 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                }

                // PLTCM ST폭보정기준
                colValue = new String[2];
                colValue[0] = ord_wth_mng_cd; // 폭관리코드
                colValue[1] = egl_proc_cd1; // 공정코드
                checker = EasyAccess.getPosDecisionChecker( C10B2191, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );
                    pltcm_wth_sub_proc1_cor_val = Double.parseDouble( result.getRuleValueAt( COL_WTH_COR_VAL ) );
                    
                } catch ( MasterDataException e )
                {
                    logger.logError( C10B2191 + C10STR_COLON + e.getMessage() );
                }
            }

            if ( !egl_proc_cd2.equals( C10STR_SPACE ) )
            {
                colValue = new String[6];
                colValue[0] = egl_proc_cd2; // 공정코드
                colValue[1] = prd_nm_cd; // 품명
                colValue[2] = mql_cd; // 재질코드
               	colValue[3] = rmtl_cd; // 원자재코드
                colValue[4] = Double.toString( pltcm_set_thk_trv ); // 주문두께
                colValue[5] = Double.toString( cegl_exc_wth ); // 주문폭
                checker = EasyAccess.getPosDecisionChecker( C10B1076, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );

                    if ( result.getRecordCount() == 1 )
                    {
                        egl_wth_shr2 = Double.parseDouble( result.getRuleValueAt( COL_EGL_WTH_SHR_QTY ) );

                    } else if ( result.getRecordCount() > 1 )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT23 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R108 );
                    } else
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT22 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R107 );
                    }
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT22 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                }
                
                // PLTCM ST폭보정기준
                colValue = new String[2];
                colValue[0] = ord_wth_mng_cd; // 폭관리코드
                colValue[1] = egl_proc_cd2; // 공정코드
                checker = EasyAccess.getPosDecisionChecker( C10B2191, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );
                    pltcm_wth_sub_proc2_cor_val = Double.parseDouble( result.getRuleValueAt( COL_WTH_COR_VAL ) );
                    
                } catch ( MasterDataException e )
                {
                    logger.logError( C10B2191 + C10STR_COLON + e.getMessage() );
                }
            }
        }

        if ( mid_cor_proc && 
                ( prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                		prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                		prd_nm_cd.equals( PRD_NM_CD_6 ) || 
                        prd_nm_cd.equals( PRD_NM_CD_9 ) ) )
        {
            // GI칼라, GL칼라, GA칼라 중간정전 통과제
            cgl_wth_trv = mid_cor_wth_trv + col_wth_shr + col_wth_mgn;
            ccl_thk_trv = cor_thk_trv;
            mid_cor_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
            cgl_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
        } else if ( !mid_cor_proc && 
                ( prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                		prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                		prd_nm_cd.equals( PRD_NM_CD_6 ) || 
                        prd_nm_cd.equals( PRD_NM_CD_9 ) ) )
        {
            // GI칼라, GL칼라, GA칼라 중간정전 미통과제
            cgl_wth_trv = ccl_wth_trv + ccl_wth_shr;
            ccl_thk_trv = cor_thk_trv;
            mid_cor_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
            cgl_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
        } else if ( (mid_cor_proc && prd_nm_cd.equals( PRD_NM_CD_2 )) || (mid_cor_proc && prd_nm_cd.equals( PRD_NM_CD_8 )))
        {
            // EG칼라 중간정전 통과제
            egl_wth_trv = mid_cor_wth_trv + col_wth_shr + col_wth_mgn;
            ccl_thk_trv = cor_thk_trv;
            mid_cor_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
            egl_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
        } else if ( (!mid_cor_proc && prd_nm_cd.equals( PRD_NM_CD_2 )) || (!mid_cor_proc && prd_nm_cd.equals( PRD_NM_CD_8 )))
        {
            // EG칼라 중간정전 미통과제
            egl_wth_trv = ccl_wth_trv + ccl_wth_shr;
            ccl_thk_trv = cor_thk_trv;
            mid_cor_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
            egl_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
        }  else if ( mid_cor_proc && prd_nm_cd.equals( PRD_NM_CD_1 ) )
        {
            // CCI 중간정전 통과제
            ccl_thk_trv = cor_thk_trv;
            mid_cor_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
        } else if ( !mid_cor_proc && prd_nm_cd.equals( PRD_NM_CD_1 ) )
        {
            // CCI 중간정전 미통과제
            ccl_thk_trv = cor_thk_trv;
            mid_cor_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
        } else if ( prd_nm_cd.equals( PRD_NM_CD_5 ) || prd_nm_cd.equals( PRD_NM_CD_7 ) )
        {
            // CCAI, CCUS 
            ccl_thk_trv = cor_thk_trv;
            mid_cor_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;
        } else if ( prd_nm_cd.equals( PRD_NM_CD_G ) || prd_nm_cd.equals( PRD_NM_CD_K ) ||
        		prd_nm_cd.equals( PRD_NM_CD_J ) || prd_nm_cd.equals( PRD_NM_CD_L ) ||
        		prd_nm_cd.equals( PRD_NM_CD_V ) || prd_nm_cd.equals( PRD_NM_CD_W ) )
        {
            // GI, HGI, GL, GA
            cgl_wth_trv = cor_wth_trv + col_wth_shr + col_wth_mgn;
            cgl_thk_trv = cor_thk_trv;
        } else if ( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_N )  )
        {
            // EG, Zn-Nk
            egl_wth_trv = cor_wth_trv + col_wth_shr + col_wth_mgn;
            egl_thk_trv = cor_thk_trv;
        }

        if ( prd_nm_cd.equals( PRD_NM_CD_G ) || 
        		prd_nm_cd.equals( PRD_NM_CD_K ) ||
                prd_nm_cd.equals( PRD_NM_CD_J ) || 
                prd_nm_cd.equals( PRD_NM_CD_L ) || 
                prd_nm_cd.equals( PRD_NM_CD_V ) || 
                prd_nm_cd.equals( PRD_NM_CD_W ) || 
                prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                prd_nm_cd.equals( PRD_NM_CD_6 ) || 
                prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            pltcm_wth_trv = cgl_wth_trv + cgl_wth_shr;
            if ( !cgl_proc_cd1.equals( C10STR_SPACE ) )
            {
                pltcm_wth_sub_proc1_trv = cgl_wth_trv + cgl_wth_shr1;
            }
            if ( !cgl_proc_cd2.equals( C10STR_SPACE ) )
            {
                pltcm_wth_sub_proc2_trv = cgl_wth_trv + cgl_wth_shr2;
            }
        } else if ( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_2 )  || prd_nm_cd.equals( PRD_NM_CD_N ) || prd_nm_cd.equals( PRD_NM_CD_8 ))
        {
            tm_thk_trv = egl_thk_trv - ( gal_thk_trv / 1000 );
            tm_wth_trv = egl_wth_trv + egl_wth_shr;

            pltcm_wth_trv = egl_wth_trv + egl_wth_shr;
            if ( !egl_proc_cd1.equals( C10STR_SPACE ) )
            {
                pltcm_wth_sub_proc1_trv = egl_wth_trv + egl_wth_shr1;
                tm_wth_sub_proc1_trv = egl_wth_trv + egl_wth_shr1;
            }
            if ( !egl_proc_cd2.equals( C10STR_SPACE ) )
            {
                pltcm_wth_sub_proc2_trv = egl_wth_trv + egl_wth_shr2;
                tm_wth_sub_proc2_trv = egl_wth_trv + egl_wth_shr2;
            }
        } else if ( prd_nm_cd.equals( PRD_NM_CD_1 ) )
        {
            tm_thk_trv = cor_thk_trv - ( pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot ) / 1000;

            if ( mid_cor_proc )
                tm_wth_trv = mid_cor_wth_trv + col_wth_mgn;
            else
                tm_wth_trv = ccl_wth_trv + ccl_wth_shr;

            pltcm_wth_trv = tm_wth_trv;
            pltcm_wth_sub_proc1_trv = 0;
            pltcm_wth_sub_proc2_trv = 0;
        } else if ( prd_nm_cd.equals( PRD_NM_CD_C ) )
        {
            tm_thk_trv = cor_thk_trv;

            if ( ord_edg_asg_tp.equals( SLIT_EDGE ) || ord_edg_asg_tp.equals( COIL_EDGE ) )
                tm_wth_trv = cor_wth_trv + col_wth_mgn  + col_wth_shr;
            else tm_wth_trv = cor_wth_trv + col_wth_shr;

            pltcm_wth_trv = tm_wth_trv;
            pltcm_wth_sub_proc1_trv = 0;
            pltcm_wth_sub_proc2_trv = 0;
        } else if ( prd_nm_cd.equals( PRD_NM_CD_D ) )
        {
            pltcm_wth_trv = cor_wth_trv;
        } else if ( prd_nm_cd.equals( PRD_NM_CD_B ) )	//2013.05.21 PO임가공 추가 이돈석  
        {
            pltcm_wth_trv = cor_wth_trv;
        } else if ( prd_nm_cd.equals( PRD_NM_CD_A ) )	//2013.05.21 PO임가공 추가 이돈석
        {
            //PLTCM폭 = 주문사이즈
        	pltcm_wth_trv = cor_wth_trv;
        } 
        
        if( !prd_nm_cd.equals( PRD_NM_CD_5 ) && !prd_nm_cd.equals( PRD_NM_CD_7 ) )
        {
            // PLTCM두께공차
            colValue = new String[1];
            colValue[0] = Double.toString( pltcm_set_thk_trv ); // PLTCM X-Ray Set치
            checker = EasyAccess.getPosDecisionChecker( C10B2190, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK80 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
    
            if ( result.getRecordCount() == 1 )
            {
                pltcm_thk_llv = Double.parseDouble( result.getRuleValueAt( COL_PLTCM_THK_TLN_LLV ) );
                pltcm_thk_ulv = Double.parseDouble( result.getRuleValueAt( COL_PLTCM_THK_TLN_ULV ) );
                ctx.put( COL_PLTCM_THK_LLV, pltcm_set_thk_trv + pltcm_thk_llv );
                ctx.put( COL_PLTCM_THK_ULV, pltcm_set_thk_trv + pltcm_thk_ulv );
            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK81 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R136 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK80 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R135 );
                return PosBizControlConstants.FAILURE;
            }
    
            // PLTCM 5Stand W/R Type Set기준
            colValue = new String[1];
            colValue[0] = Double.toString( pltcm_set_thk_trv ); // PLTCM X-Ray Set치
            checker = EasyAccess.getPosDecisionChecker( C10B2110, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK52 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
    
            if ( result.getRecordCount() == 1 )
            {
                ctx.put( COL_PLTCM_5STD_WR_TP, result.getRuleValueAt( COL_PLTCM_5STD_WR_TP ) );
            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK53 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R35 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK52 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R34 );
                return PosBizControlConstants.FAILURE;
            }
    
            // PLTCM Sleeve유무 Set기준
            colValue = new String[2];
            colValue[0] = prd_nm_cd; // 품명
            colValue[1] = Double.toString( pltcm_set_thk_trv ); // PLTCM X-Ray Set치
            checker = EasyAccess.getPosDecisionChecker( C10B2120, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK50 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
    
            if ( result.getRecordCount() == 1 )
            {
                ctx.put( COL_PLTCM_SLV_USE_YN, result.getRuleValueAt( COL_PLTCM_SLV_USE_YN ) );
            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK51 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R39 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK50 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R38 );
                return PosBizControlConstants.FAILURE;
            }
    
            // PLTCM수축량
            colValue = new String[3];
           	colValue[0] = rmtl_cd; // 원자재코드
            colValue[1] = Double.toString( pltcm_thk_trv ); // PLTCM두께
            colValue[2] = Double.toString( pltcm_wth_trv ); // PLTCM폭
            
            logger.logInfo("PLTCM두께: " + colValue[1]);
            logger.logInfo("PLTCM폭: " + colValue[2]);
            
            checker = EasyAccess.getPosDecisionChecker( C10B1074, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
    
            if ( result.getRecordCount() == 1 )
            {
                tcm_wth_shr_qty = Double.parseDouble( result.getRuleValueAt( COL_TCM_WTH_SHR_QTY ) );
                logger.logInfo("PLTCM폭수축량: " + tcm_wth_shr_qty);
            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT14 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R132 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R131 );
                return PosBizControlConstants.FAILURE;
            }
            pltcm_wth_trv_max = pltcm_wth_trv + tcm_wth_shr_qty;
            logger.logInfo("폭목표최대값: " + pltcm_wth_trv_max);
            if ( pltcm_wth_sub_proc1_trv > 0 )
            {
                // PLTCM수축량
                colValue = new String[3];
               	colValue[0] = rmtl_cd; // 원자재코드
                colValue[1] = Double.toString( pltcm_thk_trv ); // PLTCM두께
                colValue[2] = Double.toString( pltcm_wth_sub_proc1_trv ); // PLTCM폭
                
                logger.logInfo("원자재코드: " + colValue[0]);                
                logger.logInfo("PLTCM두께: " + colValue[1]);
                logger.logInfo("PLTCM폭: " + colValue[2]);
                checker = EasyAccess.getPosDecisionChecker( C10B1074, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }
    
                if ( result.getRecordCount() == 1 )
                {
                    tcm_wth_shr_qty1 = Double.parseDouble( result.getRuleValueAt( COL_TCM_WTH_SHR_QTY ) );
                    logger.logInfo("tcm_wth_shr_qty1: " + tcm_wth_shr_qty1);
                } else if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT14 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R132 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R131 );
                    return PosBizControlConstants.FAILURE;
                }
                if(Double.compare( pltcm_wth_trv_max, pltcm_wth_sub_proc1_trv + tcm_wth_shr_qty1 ) < 0)
                    pltcm_wth_trv_max = pltcm_wth_sub_proc1_trv + tcm_wth_shr_qty1;
                	logger.logInfo("pltcm_wth_trv_max: " + pltcm_wth_trv_max);

            }
    
            if ( pltcm_wth_sub_proc2_trv > 0 )
            {
                // PLTCM수축량
                colValue = new String[3];
               	colValue[0] = rmtl_cd; // 원자재코드
                colValue[1] = Double.toString( pltcm_thk_trv ); // PLTCM두께
                colValue[2] = Double.toString( pltcm_wth_sub_proc2_trv ); // PLTCM폭
                
                logger.logInfo("원자재코드: " + colValue[0]);                
                logger.logInfo("PLTCM두께: " + colValue[1]);
                logger.logInfo("PLTCM폭: " + colValue[2]);                
                checker = EasyAccess.getPosDecisionChecker( C10B1074, null );
                result = null;
                try
                {
                    result = checker.getPosRule( colValue );
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }
    
                if ( result.getRecordCount() == 1 )
                {
                    tcm_wth_shr_qty2 = Double.parseDouble( result.getRuleValueAt( COL_TCM_WTH_SHR_QTY ) );
                    logger.logInfo("tcm_wth_shr_qty2: " + tcm_wth_shr_qty2);    
                } else if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT14 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R132 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R131 );
                    return PosBizControlConstants.FAILURE;
                }
                if(Double.compare( pltcm_wth_trv_max, pltcm_wth_sub_proc2_trv + tcm_wth_shr_qty2 ) < 0)
                    pltcm_wth_trv_max = pltcm_wth_sub_proc2_trv + tcm_wth_shr_qty2;
            		logger.logInfo("pltcm_wth_trv_max: " + pltcm_wth_trv_max);                
            }
        }
        
        logger.logInfo("pltcm_wth_trv_max: " + pltcm_wth_trv_max);
        logger.logInfo("pltcm_wth_trv: " + pltcm_wth_trv);    
        logger.logInfo("pltcm폭수축량 tcm_wth_shr_qty: " + tcm_wth_shr_qty);    
        logger.logInfo("폭보정치 pltcm_wth_cor_val: " + pltcm_wth_cor_val);    
        logger.logInfo("pltcm_wth_sub_proc1_trv: " + pltcm_wth_sub_proc1_trv);
        logger.logInfo("pltcm폭수축량 tcm_wth_shr_qty1: " + tcm_wth_shr_qty1);
        logger.logInfo("폭보정치 pltcm_wth_sub_proc1_cor_val: " + pltcm_wth_sub_proc1_cor_val);
        
        logger.logInfo("pltcm_wth_sub_proc2_trv: " + pltcm_wth_sub_proc2_trv);
        logger.logInfo("pltcm폭수축량 tcm_wth_shr_qty2: " + tcm_wth_shr_qty2);
        logger.logInfo("폭보정치 pltcm_wth_sub_proc1_cor_va2: " + pltcm_wth_sub_proc2_cor_val);
        
        

        if(Double.compare( pltcm_wth_trv_max, pltcm_wth_trv + tcm_wth_shr_qty + pltcm_wth_cor_val ) > 0){
        	ctx.put( COL_PL_WTH_TRV, Math.round( pltcm_wth_trv + tcm_wth_shr_qty + pltcm_wth_cor_val ) );
            logger.logInfo("COL_PL_WTH_TRV: " + Math.round( pltcm_wth_trv + tcm_wth_shr_qty + pltcm_wth_cor_val ));  
        }else{
            ctx.put( COL_PL_WTH_TRV, Math.round( pltcm_wth_trv_max ) );        	
            logger.logInfo("COL_PL_WTH_TRV: " + Math.round( pltcm_wth_trv_max ));  
        }
                    
        if ( pltcm_wth_sub_proc1_trv > 0 )
        {
            if(Double.compare( pltcm_wth_trv_max, pltcm_wth_sub_proc1_trv + tcm_wth_shr_qty1 + pltcm_wth_sub_proc1_cor_val ) > 0)
                ctx.put( COL_PL_WTH_SUB_PROC1_TRV, Math.round( pltcm_wth_sub_proc1_trv + tcm_wth_shr_qty1 + pltcm_wth_sub_proc1_cor_val ) );        
            else ctx.put( COL_PL_WTH_SUB_PROC1_TRV, Math.round( pltcm_wth_trv_max ) );
        }
        else ctx.put( COL_PL_WTH_SUB_PROC1_TRV, C10STR_SPACE );

        if ( pltcm_wth_sub_proc2_trv > 0 )
        {
            if(Double.compare( pltcm_wth_trv_max, pltcm_wth_sub_proc2_trv + tcm_wth_shr_qty2 + pltcm_wth_sub_proc2_cor_val ) > 0)
                ctx.put( COL_PL_WTH_SUB_PROC2_TRV, Math.round( pltcm_wth_sub_proc2_trv + tcm_wth_shr_qty2 + pltcm_wth_sub_proc2_cor_val ) );        
            else ctx.put( COL_PL_WTH_SUB_PROC2_TRV, Math.round( pltcm_wth_trv_max ) );
        }
        else ctx.put( COL_PL_WTH_SUB_PROC2_TRV, C10STR_SPACE );
        
        ctx.put( COL_CCL_THK_TRV, ccl_thk_trv );
        ctx.put( COL_MID_COR_THK_TRV, mid_cor_thk_trv );
        ctx.put( COL_CGL_WTH_TRV, cgl_wth_trv );
        ctx.put( COL_CGL_THK_TRV, cgl_thk_trv );
        ctx.put( COL_EGL_WTH_TRV, egl_wth_trv );
        ctx.put( COL_EGL_THK_TRV, egl_thk_trv );
        ctx.put( COL_TM_WTH_TRV, tm_wth_trv );
        ctx.put( COL_TM_WTH_SUB_PROC1_TRV, tm_wth_sub_proc1_trv );
        ctx.put( COL_TM_WTH_SUB_PROC2_TRV, tm_wth_sub_proc2_trv );
        ctx.put( COL_TM_THK_TRV, tm_thk_trv );
        ctx.put( COL_PLTCM_WTH_TRV, Math.round( pltcm_wth_trv ) );
        ctx.put( COL_PLTCM_WTH_SUB_PROC1_TRV, Math.round( pltcm_wth_sub_proc1_trv ) );
        ctx.put( COL_PLTCM_WTH_SUB_PROC2_TRV, Math.round( pltcm_wth_sub_proc2_trv ) );
        if ( ord_edg_asg_tp.equals( SLIT_EDGE ) || ord_edg_asg_tp.equals( MILL_EDGE ) )
            ctx.put( COL_PLTCM_EDG_ASG_TP, C10STR_YES );
        else
            ctx.put( COL_PLTCM_EDG_ASG_TP, C10STR_NO );

        if ( ord_edg_asg_tp.equals( SLIT_EDGE ) || ord_edg_asg_tp.equals( COIL_EDGE ) )
            ctx.put( COL_COR_EDG_ASG_TP, C10STR_YES );
        else
            ctx.put( COL_COR_EDG_ASG_TP, C10STR_NO );
        
        ctx.put( COL_SEM_RMTL_YN, C10STR_NO );
        return PosBizControlConstants.SUCCESS;
    }
}
