/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchThkSizeData.java
 * Change history
 * @LastModifyDate : 2012. 02. 24
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 02. 24 박재영 최초 생성
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
import com.posdata.glue.master.easyaccess.returnType.PosDecisionRuleVO;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;
//import java.math.

/**
 * 이 class는 제품두께정보를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: Lamina 두께(칼라제품인 경우)
 * - Master Data 정의명 : TB_C10_QLT_DSN_CCL_BOM(칼라제조사양)
 * - 조건항목 : CCLBOM 넘버
 * -> Read Count = 1 이면 칼라제조사양 Data의 Lamina두께를 편집한다.
 * -> Read Count = 0 이면 칼라제조사양 에러처리한다.
 * 2. 편성정보: SP보정율(알미늄칼라, 스테인레스칼라 제외)
 * - Master Data 정의명 : C10B2070
 * - 조건항목 : 품명코드, 재질코드, 주문Spangle구분, 주문두께, 적용폭
 * -> Read Count = 1 이면 SP두께보정율기준 Data의 두께보정율을 편집한다.
 * -> Read Count != 1 이어도 에러처리 하지 않는다.
 * 3. 편성정보: 압연목표두께(알미늄칼라, 스테인레스칼라 제외)
 * - 고객요청압연두께(CUS_REQ_ROL_THK)가 없을(미지정)경우
 *   - 편성정보 : 압연두께Set치보정기준 
 *   - Master Data 정의명 : C10B2060
 *   - 조건항목 : 품명코드, 규격기관, 규격약호, 주문용도, 최종고객사, 주문두께구분, 주문두께관리코드, 도금량지정코드, 주문두께, 적용폭
 *   -> Read Count = 1 이면 압연두께Set치보정기준 Data의 두께보정단위, 두께보정치를 편집한다.
 *   -> Read Count != 1 이어도 에러처리 하지 않는다.
 *   - 두께보정단위가 'CRN'이고 주문두께구분이 '2'(TCT)인 경우
 *     압연목표두께 = 주문두께 - 목표도금두께 + 두께보정치
 *   - 두께보정단위가 'CRN'이고 주문두께구분이 '1'(BMT)인 경우
 *     압연목표두께 = 주문두께 + 두께보정치
 *   - 두께보정단위가 'PCN'이고 주문두께구분이 '2'(TCT)인 경우
 *     압연목표두께 = 주문두께 - 목표도금두께 + (주문두께 * 두께보정치/100)
 *   - 두께보정단위가 'PCN'이고 주문두께구분이 '1'(BMT)인 경우
 *     압연목표두께 = 주문두께 + (주문두께 * 두께보정치/100)
 *   - 두께보정단위가 'TRK'이고 주문두께구분이 '2'(TCT)인 경우
 *     압연목표두께 = 두께보정치 - 목표도금두께
 *   - 두께보정단위가 'TRK'이고 주문두께구분이 '1'(BMT)인 경우
 *     압연목표두께 = 두께보정치
 * - 고객요청압연두께(CUS_REQ_ROL_THK)가 존재하는 경우
 *   - 고객두께보정단위가 'CRN'이고 주문두께구분이 '3'(칼라TCT)인 경우
 *     압연목표두께 = 주문두께 + 고객요청압연두께 - 도막두께전후면 - 목표도금두께 + 라미나두께(라미나제품일경우)
 *   - 고객두께보정단위가 'CRN'이고 주문두께구분이 '3'(칼라TCT)이외의 경우
 *     압연목표두께 = 주문두께 + 고객요청압연두께
 *   - 고객두께보정단위가 'PCN'이고 주문두께구분이 '3'(칼라TCT)인 경우
 *     압연목표두께 = (주문두께 - 도막두께전후면 - 목표도금두께 + 라미나두께(라미나제품일경우)) + 
 *     ((주문두께 - 도막두께전후면 - 목표도금두께 + 라미나두께(라미나제품일경우)) * 고객요청압연두께/100)
 *   - 고객두께보정단위가 'PCN'이고 주문두께구분이 '3'(칼라TCT)이외의 경우
 *     압연목표두께 = 주문두께 + (주문두께 * 고객요청압연두께/100)
 *   - 고객두께보정단위가 'TRK'인 경우
 *     압연목표두께 = 고객요청압연두께
 * 4. 편성정보: 제품두께범위 상하한값, 제품두께규격범위 상하한값, 제품목표두께
 * - 품명이 CR, P/O, F/H인 경우
 *   - 제품두께범위 하한값 = 주문두께 + 인수도두께공차하한값(보증사양)
 *   - 제품두께범위 상한값 = 주문두께 + 인수도두께공차상한값(보증사양)
 *   - 제품두께규격범위 하한값 = 주문두께 + 인수도두께공차하한값(규격사양)
 *   - 제품두께규격범위 상한값 = 주문두께 + 인수도두께공차상한값(규격사양)
 *   - 제품목표두께 = 압연목표두께
 * - 품명이 CR칼라인 경우
 *   - 제품두께범위 하한값 = 주문두께 + 도막두께전후면 + 인수도두께공차하한값(보증사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께범위 상한값 = 주문두께 + 도막두께전후면 + 인수도두께공차상한값(보증사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께규격범위 하한값 = 주문두께 + 도막두께전후면 + 인수도두께공차하한값(규격사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께규격범위 상한값 = 주문두께 + 도막두께전후면 + 인수도두께공차상한값(규격사양) - 라미나두께(라미나제품일경우)
 *   - 제품목표두께 = 압연목표두께 + 도막두께전후면 - 라미나두께(라미나제품일경우)
 * - 품명이 알루미늄칼라, 스테인레스칼라인 경우
 *   - 제품두께범위 하한값 = 주문두께 + 도막두께전후면 + 인수도두께공차하한값(보증사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께범위 상한값 = 주문두께 + 도막두께전후면 + 인수도두께공차상한값(보증사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께규격범위 하한값 = 주문두께 + 도막두께전후면 + 인수도두께공차하한값(규격사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께규격범위 상한값 = 주문두께 + 도막두께전후면 + 인수도두께공차상한값(규격사양) - 라미나두께(라미나제품일경우)
 *   - 제품목표두께 = 주문두께 + 도막두께전후면 - 라미나두께(라미나제품일경우)
 * - 품명이 도금제품(G,K,J,L,E)인 경우
 *   - 제품두께범위 하한값 = 주문두께 + 목표도금두께(주문두께구분이 '2'가 아니고 제품두께계산적용코드가 space인경우)
 *                         + 인수도두께공차하한값(보증사양)
 *   - 제품두께범위 상한값 = 주문두께 + 목표도금두께(주문두께구분이 '2'가 아니고 제품두께계산적용코드가 space인경우)
 *                         + 인수도두께공차상한값(보증사양)
 *   - 제품두께규격범위 하한값 = 주문두께 + 규격도금두께(주문두께 구분이 '2'가 아니고 규격기관이 'KS','JS'인경우)
 *                         + 인수도두께공차하한값(규격사양)
 *   - 제품두께규격범위 상한값 = 주문두께 + 규격도금두께(주문두께 구분이 '2'가 아니고 규격기관이 'KS','JS'인경우)
 *                         + 인수도두께공차상한값(규격사양)
 *   - 제품목표두께 = 압연목표두께 + 목표도금두께
 * - 품명이 도금칼라제품(2,3,4,6)인 경우
 *   - 제품두께범위 하한값 = 주문두께 + 도막두께전후면(제품두게계산적용코드가 'C'가 아닌경우)
 *                         + 목표도금두께(주문두께구분이 '2'가 아니고 제품두께계산적용코드가 space인경우)
 *                         + 인수도두께공차하한값(보증사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께범위 상한값 = 주문두께 + 도막두께전후면(제품두게계산적용코드가 'C'가 아닌경우)
 *                         + 목표도금두께(주문두께구분이 '2'가 아니고 제품두께계산적용코드가 space인경우)
 *                         + 인수도두께공차상한값(보증사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께규격범위 하한값 = 주문두께 + 도막두께전후면
 *                            + 규격도금두께(주문두께 구분이 '2'가 아니고 규격기관이 'KS','JS'인경우)
 *                            + 인수도두께공차하한값(규격사양) - 라미나두께(라미나제품일경우)
 *   - 제품두께규격범위 상한값 = 주문두께 + 도막두께전후면
 *                            + 규격도금두께(주문두께 구분이 '2'가 아니고 규격기관이 'KS','JS'인경우)
 *                            + 인수도두께공차상한값(규격사양) - 라미나두께(라미나제품일경우)
 *   - 제품목표두께 = 압연목표두께 + 도막두께전후면 + 목표도금두께 - 라미나두께(라미나제품일경우)
 * 5. 편성정보: PLTCM출측두께
 * - 두께보정단위가 'TRK'인 경우
 *   PLTCM출측두께 = 압연목표두께
 * - 두께보정단위가 'TRK'가 아닌경우
 *   PLTCM출측두게 = 압연목표두께 + (압연목표두께 * SP보정률/100)
 * - 소수점3자리가지 절삭처리
 * 6. 편성정보: PLTCM X-Ray Set치
 * - 품명이 알루미늄칼라, 스테인레스칼라인 경우
 *   PLTCM X-Ray Set치 = 주문두께
 * - 품명이 알루미늄칼라, 스테인레스칼라가 아닌 경우
 *   PLTCM X-Ray Set치 적용
 *   - 소수점 3번째자리를 "0" 이나 "5"로 변환한다.
 *     . 소수점 3번째자리가 '1','2' 인 경우는 소수점 3번째자리를 "0"으로 변환한다.   
 *       예) 0.542 => 0.540
 *     . 소수점 3번째자리가 '3','4','6','7' 인 경우는 소수점 3번째자리를 "5"으로 변환한다.  
 *       예) 0.544 => 0.545 , 0.547 => 0.545
 *     . 소수점 3번째자리가 '8','9' 인 경우는 소수점 3번째자리를 "0"으로,두번째자리에 1을 더한다.  
 *       예) 0.548 => 0.550
 * 7. 편성정보: 제품길이범위 상하한값(제품형태가 Sheet인경우)
 * - 제품길이범위하한값 = 주문길이 + 인수도길이공차하한값
 * - 제품길이범위상한값 = 주문길이 + 인수도길이공차상한값
 * 8. 편성정보: 제조표준
 * - Master Data 정의명 : C10B1051
 * - 조건항목 : 제조표준번호, 품명코드, 재질코드, PLTCM X-Ray Set치, 적용폭
 * -> Read Count = 1 이면 제조사양기준 Data의 제조사양을 편집한다.
 *    - 품명이 CR,EG,CR칼라,EG칼라인 경우
 *      일반ANN소둔로유형,일반ANN소둔CYCLE,일반ANN소둔보정시간,일반ANN코일온도,일반ANN냉각종료온도,
 *      HCANN소둔로유형,HCANN소둔CYCLE,HCANN소둔보정시간,HCANN코일온도,HCANN냉각종료온도를 편집
 *    - 품명이 CR,EG,CR칼라,EG칼라가 아닌 경우
 *      소둔CYCLE#2CGL,가열온도#2CGL,냉각온도#2CGL,ShockingTime#2CGL,LineSpeed#2CGL,
 *      소둔CYCLE#3CGL,가열온도#3CGL,냉각온도#3CGL,ShockingTime#3CGL,LineSpeed#3CGL,
 *      소둔CYCLE#4CGL,가열온도#4CGL,냉각온도#4CGL,ShockingTime#4CGL,LineSpeed#4CGL,
 *      소둔CYCLE#5CGL,가열온도#5CGL,냉각온도#5CGL,ShockingTime#5CGL,LineSpeed#5CGL를 편집
 * -> Read Count != 1 이면 에러처리 한다.
 * 9. 편성정보: 매중량(제품형태가 코일인 경우)
 * - 품명이 알루미늄칼라인 경우
 *   매중량 = 주문두께 * 2.73 * 주문폭/1000 
 * - 품명이 스테인레스칼라인 경우
 *   매중량 = 주문두께 * 7.74 * 주문폭/1000 
 * - 품명이 알루미늄칼라, 스테인레스칼라가 아닌 경우
 *   매중량 = ((PLTCM X-Ray Set치 * 7.85) + 
             ((작업도금량전면하한 + 작업도금량후면하한 + 작업도금량전체하한) / 1000)) * 
               주문폭 / 1000
 * 10. 편성한 결과는 PosContext에 등록
 * 11. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchThkSizeData">
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

public class DbSearchThkSizeData extends PosActivity implements C10NuiConstantsIF
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
        PosDecisionChecker checker = null;
        PosRuleVO result = null;
        PosParameter param = new PosParameter(); // MD View param
        PosRowSet rowset = null;
        PosRow row = null;

        String colValue[] = null; // 컬럼값

        double ord_exc_thk = 0;
        double ord_exc_wth = 0;
        double me_exc_wth = 0;
        double cus_req_rol_thk = 0;
        String rmtl_cd = C10STR_SPACE;
        String ord_thk_tp = C10STR_SPACE;
        String ord_spnl_tp = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String thk_cor_unt = C10STR_SPACE;
        String spc_avr = C10STR_SPACE;
        String ord_usg_cd = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        String mql_cd = C10STR_SPACE;
        String ord_thk_mng_cd = C10STR_SPACE;
        String gw_asg_cd = C10STR_SPACE;
        String prd_shp = C10STR_SPACE;
        String prd_thk_cal_apl_cd = C10STR_SPACE;
        String crm_mnf_std_no = C10STR_SPACE;
        String qlt_dsn_mnf_tp = C10STR_SPACE;
        double pltcm_set_thk_trv = 0;
        double pnt_flm_thk_frn_tot = 0;
        double pnt_flm_thk_bak_tot = 0;
        double pnt_flm_thk_frn_tot2 = 0;
        double pnt_flm_thk_bak_tot2 = 0;
        double thk_tln_llv = 0;
        double thk_tln_ulv = 0;
        double thk_tln_llv2 = 0;
        double thk_tln_ulv2 = 0;
        double sp_thk = 0;
        double prd_thk_rng_llv = 0;
        double prd_thk_rng_ulv = 0;
        double cor_thk_trv = 0;
        double pltcm_thk_trv = 0;
        double gal_thk_trv = 0;
        double gal_thk_trv2 = 0;
        double spc_gal_thk = 0;
        double crm_thk = 0;
        double ord_exc_lth = 0;
        double lth_tln_llv = 0;
        double lth_tln_ulv = 0;
        double prd_lth_rng_llv = 0;
        double prd_lth_rng_ulv = 0;
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
        double prd_thk_spc_rng_llv = 0;
        double prd_thk_spc_rng_ulv = 0;
        double pnt_flm_thk_lmn = 0;
        double ord_unt_wgt = 0;
        double wk_gw_frn_llv = 0;
        double wk_gw_bak_llv = 0;
        double wk_gw_tot_llv = 0;

        if ( !DbCommonUtil.isNull( ctx.get( COL_QLT_DSN_MNF_TP ) ) )
        	qlt_dsn_mnf_tp = ctx.get( COL_QLT_DSN_MNF_TP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD ) ) )
            rmtl_cd = (String) ctx.get( COL_RMTL_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = Double.parseDouble( ctx.get( COL_ORD_EXC_THK ).toString() );
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
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_PRD_THK_CAL_APL_CD ) ) )
            prd_thk_cal_apl_cd = (String) ctx.get( COL_PRD_THK_CAL_APL_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_CRM_MNF_STD_NO ) ) )
            crm_mnf_std_no = (String) ctx.get( COL_CRM_MNF_STD_NO );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
        {
           // if ( ord_slit_grp_cnt > 0 && 
           //         Double.compare( 
           //                 Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) , 
           //                 ord_mix_wth1) == 0 )
           //     ord_exc_wth = 
           //     Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * ord_slit_grp_cnt;
           // else if ( ord_slit_grp_cnt > 0 && 
           //         Double.compare( 
           //                 Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
           //                 ord_mix_wth1) != 0 )
           //     ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
           // else
           //     ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
          //  
            if ( ord_slit_grp_cnt > 0 )
                ord_exc_wth =   ord_mix_wth1 + ord_mix_wth2 + ord_mix_wth3 + ord_mix_wth4 + ord_mix_wth5
                		          + ord_mix_wth6 + ord_mix_wth7 + ord_mix_wth8 + ord_mix_wth9 + ord_mix_wth10;
            else
                ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );

        	me_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
        }
        if ( !DbCommonUtil.isNull( ctx.get( COL_CUS_REQ_ROL_THK ) ) )
            cus_req_rol_thk = Double.parseDouble( ctx.get( COL_CUS_REQ_ROL_THK ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_THK_TP ) ) )
            ord_thk_tp = ctx.get( COL_ORD_THK_TP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = ctx.get( COL_PRD_NM_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SPNL_TP ) ) )
            ord_spnl_tp = ctx.get( COL_ORD_SPNL_TP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_THK_COR_UNT ) ) )
            thk_cor_unt = ctx.get( COL_THK_COR_UNT ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_SPC_AVR ) ) )
            spc_avr = ctx.get( COL_SPC_AVR ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
            ord_usg_cd = ctx.get( COL_ORD_USG_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_FNL_CUS_CD ) ) )
            fnl_cus_cd = ctx.get( COL_FNL_CUS_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_THK_MNG_CD ) ) )
            ord_thk_mng_cd = ctx.get( COL_ORD_THK_MNG_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_MQL_CD ) ) )
            mql_cd = ctx.get( COL_MQL_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PNT_FLM_THK_FRN_TOT ) ) )
            pnt_flm_thk_frn_tot = 
            Double.parseDouble( ctx.get( COL_PNT_FLM_THK_FRN_TOT ).toString() ) / 1000;
        if ( !DbCommonUtil.isNull( ctx.get( COL_PNT_FLM_THK_BAK_TOT ) ) )
            pnt_flm_thk_bak_tot = 
            Double.parseDouble( ctx.get( COL_PNT_FLM_THK_BAK_TOT ).toString() ) / 1000;
        if ( !DbCommonUtil.isNull( ctx.get( COL_PNT_FLM_THK_FRN_TOT ) ) )
            pnt_flm_thk_frn_tot2 = 
            Double.parseDouble( ctx.get( COL_PNT_FLM_THK_FRN_TOT ).toString() ) / 1000;
        if ( !DbCommonUtil.isNull( ctx.get( COL_PNT_FLM_THK_BAK_TOT ) ) )
            pnt_flm_thk_bak_tot2 = 
            Double.parseDouble( ctx.get( COL_PNT_FLM_THK_BAK_TOT ).toString() ) / 1000;
        if ( !DbCommonUtil.isNull( ctx.get( COL_THK_TLN_LLV ) ) )
            thk_tln_llv = Double.parseDouble( ctx.get( COL_THK_TLN_LLV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_THK_TLN_ULV ) ) )
            thk_tln_ulv = Double.parseDouble( ctx.get( COL_THK_TLN_ULV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_THK_TLN_LLV + NUM2 ) ) )
            thk_tln_llv2 = Double.parseDouble( ctx.get( COL_THK_TLN_LLV + NUM2 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_THK_TLN_ULV + NUM2 ) ) )
            thk_tln_ulv2 = Double.parseDouble( ctx.get( COL_THK_TLN_ULV + NUM2 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_GAL_THK_TRV ) ) )
            gal_thk_trv = Double.parseDouble( ctx.get( COL_GAL_THK_TRV ).toString() ) / 1000;
        if ( !DbCommonUtil.isNull( ctx.get( COL_GAL_THK_TRV ) ) )
            gal_thk_trv2 = Double.parseDouble( ctx.get( COL_GAL_THK_TRV ).toString() ) / 1000;
        if ( !DbCommonUtil.isNull( ctx.get( COL_SPC_GAL_THK ) ) )
            spc_gal_thk = Double.parseDouble( ctx.get( COL_SPC_GAL_THK ).toString() ) / 1000;
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_GW_ASG_CD ) ) )
            gw_asg_cd = (String) ctx.get( COL_GW_ASG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_PRD_SHP ) ) )
            prd_shp = (String) ctx.get( COL_PRD_SHP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_LTH ) ) )
            ord_exc_lth = Double.parseDouble( ctx.get( COL_ORD_EXC_LTH ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_LTH_TLN_LLV ) ) )
            lth_tln_llv = Double.parseDouble( ctx.get( COL_LTH_TLN_LLV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_LTH_TLN_ULV ) ) )
            lth_tln_ulv = Double.parseDouble( ctx.get( COL_LTH_TLN_ULV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_UNT_WGT ) ) )
            ord_unt_wgt = Double.parseDouble( ctx.get( COL_ORD_UNT_WGT ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_WK_GW_FRN_LLV ) ) )
            wk_gw_frn_llv = Double.parseDouble( ctx.get( COL_WK_GW_FRN_LLV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_WK_GW_BAK_LLV ) ) )
            wk_gw_bak_llv = Double.parseDouble( ctx.get( COL_WK_GW_BAK_LLV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_WK_GW_TOT_LLV ) ) )
            wk_gw_tot_llv = Double.parseDouble( ctx.get( COL_WK_GW_TOT_LLV ).toString() );

 
        if ( !qlt_dsn_mnf_tp.equals("1")  && 
            	!rmtl_cd.toString().substring(0,1).equals("H") && !rmtl_cd.toString().substring(0,1).equals("M") && 
            	!prd_nm_cd.toString().equals("5") && !prd_nm_cd.toString().equals("7") ){                          //구매반제품 원자재 차선등록의 경우(CCAI, CCUS 제외)
                
            	ctx.put( COL_SEM_RMTL_YN, C10STR_YES );
            	return PosBizControlConstants.SUCCESS;
        }

        if ( !prd_nm_cd.equals( PRD_NM_CD_5 ) && !prd_nm_cd.equals( PRD_NM_CD_7 ) ){

            // SP보정율 기준
            colValue = new String[5];
            colValue[0] = prd_nm_cd; //품명코드
            colValue[1] = mql_cd; //재질코드
            colValue[2] = ord_spnl_tp; //주문Spangle구분
            colValue[3] = Double.toString( ord_exc_thk ); //주문두께
            colValue[4] = Double.toString( ord_exc_wth ); //적용폭
    
            try{
                // 결과값 잘 가져오는지 확인
                PosDecisionRuleVO result2 = EasyAccess.getPosDecisionRuleLov( C10B2070, colValue, null );
                result2.next();
                sp_thk = Double.parseDouble( result2.getRuleValueAt( COL_THK_CPS_RT ) );
                
                logger.logDebug( "=== check1 ===" );
                logger.logDebug( "sp_thk          : " + sp_thk );
    
            }catch ( MasterDataException e ){
                logger.logError( e.getMessage() );
            }
    
            if ( Double.compare( cus_req_rol_thk, 0) == 0 && !ord_thk_tp.equals( NUM3 ) ){
                // 고객요청압연두께 미지정
                colValue = new String[10];
                colValue[0] = prd_nm_cd; //품명코드
                if(spc_avr.length() > 1)
                    colValue[1] = spc_avr.substring( 0, 2 ); //규격기관
                colValue[2] = spc_avr; //규격약호
                colValue[3] = ord_usg_cd; //주문용도
                colValue[4] = fnl_cus_cd; //최종고객사
                colValue[5] = ord_thk_tp; //주문두께구분
                colValue[6] = ord_thk_mng_cd; //주문두께관리코드
                colValue[7] = gw_asg_cd; //도금량기준
                colValue[8] = Double.toString( ord_exc_thk ); //주문두께
                colValue[9] = Double.toString( ord_exc_wth ); //주문폭
    
                logger.logDebug( "=== check2 ===" );
                checker = EasyAccess.getPosDecisionChecker( C10B2060, null );
                result = null;
                try{
                    // 결과값 잘 가져오는지 확인
                    result = checker.getPosRule( colValue );
                    logger.logDebug( "=== check3 ===" );
                }catch ( MasterDataException e ){
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK82 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    logger.logDebug( "=== check4 ===" );
                    return PosBizControlConstants.FAILURE;
                }
                
                if ( result.getRecordCount() == 1 ){
                	logger.logDebug( "=== check5 ===" );
                	if ( result.getRuleValueAt( COL_THK_COR_UNT ).equals( UNIT_CRN ) ){
                        if ( ord_thk_tp.equals( NUM2 ) ){
                            crm_thk = ord_exc_thk - gal_thk_trv + 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) );
                            
                            //소수점 자리 반올림로직 추가(2013.01.21) 
                            double temp = Math.round(crm_thk*10000);
                            double crm_thk1 = temp/10000;
                            crm_thk = crm_thk1;
                            
                            logger.logDebug( "=== check6 ===" );
                            logger.logDebug( "ord_exc_thk          : " + ord_exc_thk );
                            logger.logDebug( "gal_thk_trv          : " + gal_thk_trv );
                            logger.logDebug( "result.getRuleValueAt( COL_THK_COR_VAL )" + result.getRuleValueAt( COL_THK_COR_VAL ));
                            logger.logDebug( "Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) )" + Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) ));
                            logger.logDebug( "crm_thk          : " + crm_thk );
                            logger.logDebug( "temp          : " + temp );
                            logger.logDebug( "crm_thk1          : " + crm_thk1 );
                        }else{
                        	crm_thk = ord_exc_thk + 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) );
                        	logger.logDebug( "=== check7 ===" );
                            logger.logDebug( "crm_thk          : " + crm_thk );
                        }
                    }else if ( result.getRuleValueAt( COL_THK_COR_UNT ).equals( UNIT_PCN ) ){
                        if ( ord_thk_tp.equals( NUM2 ) ){
                            crm_thk = ord_exc_thk - gal_thk_trv + ord_exc_thk * 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) ) / 100;
                            logger.logDebug( "=== check8 ===" );
                            logger.logDebug( "crm_thk          : " + crm_thk );
                        }else{
                        	crm_thk = ord_exc_thk + ord_exc_thk * 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) ) / 100;
                        	logger.logDebug( "=== check9 ===" );
                            logger.logDebug( "crm_thk          : " + crm_thk );
                        }
                    }else{
                        if ( ord_thk_tp.equals( NUM2 ) ){
                            crm_thk = Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) ) - gal_thk_trv;
                            logger.logDebug( "=== check10 ===" );
                            logger.logDebug( "crm_thk          : " + crm_thk );
                        }else{
                            crm_thk = Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) );
                            logger.logDebug( "=== check11 ===" );
                            logger.logDebug( "crm_thk          : " + crm_thk );
                        }
                        sp_thk = 0;
                    }
                } else if ( result.getRecordCount() > 1 ){
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK83 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R146 );
                    logger.logDebug( "=== check12 ===" );
                    return PosBizControlConstants.FAILURE;
                } else{
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK82 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R145 );
                    logger.logDebug( "=== check13 ===" );
                    return PosBizControlConstants.FAILURE;
                }
    
            } else{
                if ( ord_thk_tp.equals( NUM3 ) ){
                    ord_exc_thk = ord_exc_thk - pnt_flm_thk_frn_tot - pnt_flm_thk_bak_tot - gal_thk_trv + pnt_flm_thk_lmn;
                }
    
                if ( thk_cor_unt.equals( UNIT_CRN ) ){
                    crm_thk = ord_exc_thk + cus_req_rol_thk;
                } else if ( thk_cor_unt.equals( UNIT_PCN ) ){
                    crm_thk = ord_exc_thk + ord_exc_thk * cus_req_rol_thk / 100;
                } else if ( thk_cor_unt.equals( UNIT_TRK ) ){
                    crm_thk = cus_req_rol_thk;
                }else crm_thk = ord_exc_thk;
            }
        }

        // 제품두께 범위계산 보증
        if ( prd_thk_cal_apl_cd.equals( C10STR_SPACE ) ){
            // 상당도금두께
            if ( ord_thk_tp.equals( NUM2 ) ){
                gal_thk_trv2 = 0;
            }
        } else if ( prd_thk_cal_apl_cd.equals( C10STR_TOLCD_T ) )
            gal_thk_trv2 = 0;
        else if ( prd_thk_cal_apl_cd.equals( C10STR_CD_C ) ){
            gal_thk_trv2 = 0;
            pnt_flm_thk_frn_tot2 = 0;
            pnt_flm_thk_bak_tot2 = 0;
        }

        // 제품두께 범위계산 규격
        if ( ord_thk_tp.equals( NUM2 ) ){
            spc_gal_thk = 0;
        }else if ( ord_thk_tp.equals( NUM3 ) ){
            if( !spc_avr.substring( 0, 2 ).equals( SPC_AVR_KS ) &&
            !spc_avr.substring( 0, 2 ).equals( SPC_AVR_JS ) )
            {
                spc_gal_thk = 0;
            }
        }
        
        if ( prd_nm_cd.equals( PRD_NM_CD_C ) || 
                prd_nm_cd.equals( PRD_NM_CD_A ) || 
                prd_nm_cd.equals( PRD_NM_CD_B ) || 
                prd_nm_cd.equals( PRD_NM_CD_D ) )
        {
            // CR, PO, F/H
            prd_thk_rng_llv = ord_exc_thk + thk_tln_llv;
            prd_thk_rng_ulv = ord_exc_thk + thk_tln_ulv;
            prd_thk_spc_rng_llv = ord_exc_thk + thk_tln_llv2;
            prd_thk_spc_rng_ulv = ord_exc_thk + thk_tln_ulv2;
            cor_thk_trv = crm_thk;

        } else if ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                prd_nm_cd.equals( PRD_NM_CD_5 ) ||
                prd_nm_cd.equals( PRD_NM_CD_7 ) )
        {
            // CR color
            prd_thk_rng_llv = ord_exc_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot2 + thk_tln_llv;
            prd_thk_rng_ulv = ord_exc_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot2 + thk_tln_ulv;
            prd_thk_spc_rng_llv = ord_exc_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot + thk_tln_llv2;
            prd_thk_spc_rng_ulv = ord_exc_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot + thk_tln_ulv2;
            if(prd_nm_cd.equals( PRD_NM_CD_1 ))
                cor_thk_trv = crm_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot;
            else cor_thk_trv = ord_exc_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot;

        } else if ( prd_nm_cd.equals( PRD_NM_CD_E ) || 
        		prd_nm_cd.equals( PRD_NM_CD_N ) ||
        		prd_nm_cd.equals( PRD_NM_CD_G ) ||
                prd_nm_cd.equals( PRD_NM_CD_K ) ||
                prd_nm_cd.equals( PRD_NM_CD_J ) || 
                prd_nm_cd.equals( PRD_NM_CD_L ) || 
                prd_nm_cd.equals( PRD_NM_CD_V ) || 
                prd_nm_cd.equals( PRD_NM_CD_W ) )
        {
            // EGI, GI, HGI, G/A, G/L
            prd_thk_rng_llv = ord_exc_thk + gal_thk_trv2 + thk_tln_llv;
            prd_thk_rng_ulv = ord_exc_thk + gal_thk_trv2 + thk_tln_ulv;
            prd_thk_spc_rng_llv = ord_exc_thk + spc_gal_thk + thk_tln_llv2;
            prd_thk_spc_rng_ulv = ord_exc_thk + spc_gal_thk + thk_tln_ulv2;
            cor_thk_trv = crm_thk + gal_thk_trv;

        } else if ( prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                prd_nm_cd.equals( PRD_NM_CD_6 ) ||
                prd_nm_cd.equals( PRD_NM_CD_8 ) ||
                prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            // EGI, GI, G/A, G/L color
            prd_thk_rng_llv = ord_exc_thk + pnt_flm_thk_frn_tot2 + pnt_flm_thk_bak_tot2 + thk_tln_llv + gal_thk_trv2;
            prd_thk_rng_ulv = ord_exc_thk + pnt_flm_thk_frn_tot2 + pnt_flm_thk_bak_tot2 + thk_tln_ulv + gal_thk_trv2;
            prd_thk_spc_rng_llv = ord_exc_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot + spc_gal_thk + thk_tln_llv2;
            prd_thk_spc_rng_ulv = ord_exc_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot + spc_gal_thk + thk_tln_ulv2;
            cor_thk_trv = crm_thk + pnt_flm_thk_frn_tot + pnt_flm_thk_bak_tot + gal_thk_trv;
        }

        if ( thk_cor_unt.equals( UNIT_TRK ) ){
            pltcm_thk_trv = crm_thk;
	        logger.logDebug( "=== check14 ===" );
	        logger.logDebug( "pltcm_thk_trv14          : " + pltcm_thk_trv );
        }else{
            pltcm_thk_trv = crm_thk + crm_thk * sp_thk / 100;
	        logger.logDebug( "=== check15 ===" );
	        logger.logDebug( "pltcm_thk_trv15          : " + pltcm_thk_trv );
	        logger.logDebug( "crm_thk          : " + crm_thk );
	        logger.logDebug( "sp_thk          : " + sp_thk );
        }

        pltcm_thk_trv = DbCommonUtil.thk_dot( pltcm_thk_trv );
        
        logger.logDebug( "=== check16 ===" );
        logger.logDebug( "pltcm_thk_trv16          : " + pltcm_thk_trv );
        
        if ( prd_nm_cd.equals( PRD_NM_CD_5 ) || prd_nm_cd.equals( PRD_NM_CD_7 ) )
            pltcm_set_thk_trv = ord_exc_thk;
        else
            pltcm_set_thk_trv = DbCommonUtil.thk_dot( DbCommonUtil.pltcm_x_Ray( pltcm_thk_trv ) ); 
        
        logger.logDebug( "pltcm_set_thk_trv          : " + pltcm_set_thk_trv );

        // 제품두께범위
        ctx.put( COL_PRD_THK_RNG_LLV, prd_thk_rng_llv );
        ctx.put( COL_PRD_THK_RNG_ULV, prd_thk_rng_ulv );
        ctx.put( COL_COR_THK_TRV, cor_thk_trv );
        ctx.put( COL_PLTCM_THK_TRV, pltcm_thk_trv );
        ctx.put( COL_PRD_THK_SPC_RNG_LLV, prd_thk_spc_rng_llv );
        ctx.put( COL_PRD_THK_SPC_RNG_ULV, prd_thk_spc_rng_ulv );
        ctx.put( COL_PLTCM_SET_THK_TRV, pltcm_set_thk_trv );

        // 제품길이범위
        if ( prd_shp.equals( PRD_SHP_SHEET ) )
        {
            prd_lth_rng_llv = ord_exc_lth + lth_tln_llv;
            prd_lth_rng_ulv = ord_exc_lth + lth_tln_ulv;
        }
        ctx.put( COL_PRD_LTH_RNG_LLV, prd_lth_rng_llv );
        ctx.put( COL_PRD_LTH_RNG_ULV, prd_lth_rng_ulv );

        if ( !prd_nm_cd.equals( PRD_NM_CD_5 ) && !prd_nm_cd.equals( PRD_NM_CD_7 ) )
        {
            colValue = new String[5];
            colValue[0] = crm_mnf_std_no; // 제조표준번호
            colValue[1] = prd_nm_cd; // 품명
            colValue[2] = mql_cd; // 재질
            colValue[3] = Double.toString( pltcm_set_thk_trv ); // 두께
            colValue[4] = Double.toString( ord_exc_wth ); // 폭
    
            checker = EasyAccess.getPosDecisionChecker( C10B1051, null );
            result = null;
            try{
                // 결과값 잘 가져오는지 확인
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e ){
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK13 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_K13 );
                return PosBizControlConstants.FAILURE;
            }
    
            if ( result.getRecordCount() == 1 ){
                if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_C ) || 
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) ||
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) ||
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_1 ) || 
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) ||
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) )
                {
                    // CR,EG 제품인 경우
                    ctx.put( COL_FUR_TP_GEN_ANN, result.getRuleValueAt( COL_FUR_TP_GEN_ANN ) );
                    ctx.put( COL_HEAT_CYL_NO_GEN_ANN, result.getRuleValueAt( COL_HEAT_CYL_NO_GEN_ANN ) );
                    ctx.put( COL_COR_TM_GEN_ANN, result.getRuleValueAt( COL_COR_TM_GEN_ANN ) );
                    ctx.put( COL_COIL_TMP_GEN_ANN, result.getRuleValueAt( COL_COIL_TMP_GEN_ANN ) );
                    ctx.put( COL_CLG_END_TMP_GEN_ANN, result.getRuleValueAt( COL_CLG_END_TMP_GEN_ANN ) );
                    ctx.put( COL_FUR_TP_HC_ANN, result.getRuleValueAt( COL_FUR_TP_HC_ANN ) );
                    ctx.put( COL_HEAT_CYL_NO_HC_ANN, result.getRuleValueAt( COL_HEAT_CYL_NO_HC_ANN ) );
                    ctx.put( COL_COR_TM_HC_ANN, result.getRuleValueAt( COL_COR_TM_HC_ANN ) );
                    ctx.put( COL_COIL_TMP_HC_ANN, result.getRuleValueAt( COL_COIL_TMP_HC_ANN ) );
                    ctx.put( COL_CLG_END_TMP_HC_ANN, result.getRuleValueAt( COL_CLG_END_TMP_HC_ANN ) );
                } else{
                    // GI,GA,GL 제품인 경우
                    ctx.put( COL_HEAT_CYL_NO_2CGL, result.getRuleValueAt( COL_HEAT_CYL_NO_2CGL ) );
                    ctx.put( COL_HTG_TEM_2CGL, result.getRuleValueAt( COL_HTG_TEM_2CGL ) );
                    ctx.put( COL_CLG_TEM_2CGL, result.getRuleValueAt( COL_CLG_TEM_2CGL ) );
                    ctx.put( COL_SHK_TM_2CGL, result.getRuleValueAt( COL_SHK_TM_2CGL ) );
                    ctx.put( COL_LN_SPD_2CGL, result.getRuleValueAt( COL_LN_SPD_2CGL ) );
                    ctx.put( COL_HEAT_CYL_NO_3CGL, result.getRuleValueAt( COL_HEAT_CYL_NO_3CGL ) );
                    ctx.put( COL_HTG_TEM_3CGL, result.getRuleValueAt( COL_HTG_TEM_3CGL ) );
                    ctx.put( COL_CLG_TEM_3CGL, result.getRuleValueAt( COL_CLG_TEM_3CGL ) );
                    ctx.put( COL_SHK_TM_3CGL, result.getRuleValueAt( COL_SHK_TM_3CGL ) );
                    ctx.put( COL_LN_SPD_3CGL, result.getRuleValueAt( COL_LN_SPD_3CGL ) );
                    ctx.put( COL_HEAT_CYL_NO_4CGL, result.getRuleValueAt( COL_HEAT_CYL_NO_4CGL ) );
                    ctx.put( COL_HTG_TEM_4CGL, result.getRuleValueAt( COL_HTG_TEM_4CGL ) );
                    ctx.put( COL_CLG_TEM_4CGL, result.getRuleValueAt( COL_CLG_TEM_4CGL ) );
                    ctx.put( COL_SHK_TM_4CGL, result.getRuleValueAt( COL_SHK_TM_4CGL ) );
                    ctx.put( COL_LN_SPD_4CGL, result.getRuleValueAt( COL_LN_SPD_4CGL ) );
                    ctx.put( COL_HEAT_CYL_NO_5CGL, result.getRuleValueAt( COL_HEAT_CYL_NO_5CGL ) );
                    ctx.put( COL_HTG_TEM_5CGL, result.getRuleValueAt( COL_HTG_TEM_5CGL ) );
                    ctx.put( COL_CLG_TEM_5CGL, result.getRuleValueAt( COL_CLG_TEM_5CGL ) );
                    ctx.put( COL_SHK_TM_5CGL, result.getRuleValueAt( COL_SHK_TM_5CGL ) );
                    ctx.put( COL_LN_SPD_5CGL, result.getRuleValueAt( COL_LN_SPD_5CGL ) );
                }
            } else if ( result.getRecordCount() > 1 ){
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK14 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_K14 );
                return PosBizControlConstants.FAILURE;
            } else{
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK13 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_K13 );
                return PosBizControlConstants.FAILURE;
            }
        }         
        
        // 코일일경우 매중량 계산
        if(prd_shp.equals( PRD_SHP_COIL )){
            if ( prd_nm_cd.equals( PRD_NM_CD_5 ) ){
                //알미늄 = 두께 * 2.73 * 폭 / 1000;   
                ord_unt_wgt = ord_exc_thk * 2.73 * me_exc_wth / 1000;
            }else if ( prd_nm_cd.equals( PRD_NM_CD_7 ) ){
                //스테인레스 = 두께 * 7.74 * 폭 / 1000;
                ord_unt_wgt = ord_exc_thk * 7.74 * me_exc_wth / 1000;
            }else{
                //그외 = ((nvl(TCM SET,0) * 7.85) + (nvl(도금부착량하한값,0) / 1000)) * 폭 / 1000;
                ord_unt_wgt = ((pltcm_set_thk_trv * 7.85) + 
                        ((wk_gw_frn_llv + wk_gw_bak_llv + wk_gw_tot_llv) / 1000)) * me_exc_wth / 1000;                
            }
            ctx.put( COL_ORD_UNT_WGT, ord_unt_wgt );
        }

        ctx.put( COL_SEM_RMTL_YN, C10STR_NO );
        return PosBizControlConstants.SUCCESS;
    }
}
