/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchWthSizeData.java
 * Change history
 * @LastModifyDate : 2012. 02. 21
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 02. 21 박재영 최초 생성
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
 * 이 class는 제품폭정보를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 칼라사양(칼라제품인 경우)
 * - Data 정의명 : 품질설계 칼라제조사양
 * - Data 조건항목 : 주문번호,주문행번
 * -> Read Count = 1 이면 칼라제조사양 Data의 재단선유무,코팅방식,수지구분전면을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 칼라제조사양 에러처리한다.
 * 2. 편성정보: 제품폭여유치
 * - Master Data 정의명 : C10A1070
 * - 제품폭여유기준 Data 조건항목 : 주문폭관리코드
 * -> Read Count = 1 이면 제품폭여유기준 Data의 폭여유치를 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 제품폭여유기준 에러처리한다.
 * 3. 편성정보: 제품폭범위 상하한
 * - 제품폭범위 하한값 = 주문폭 + 인수도폭공차 하한값(보증사양)
 * - 제품폭범위 상한값 = 주문폭 + 인수도폭공차 상한값(보증사양)
 * 4. 편성정보: 제품목표폭(정전목표폭), 기준적용폭
 * - 재단선유무가 'Y'이고 주문Slit조수가 '2'이고 주문폭과 조합폭1이 같은 경우
 *   - 기준적용폭 = 주문폭
 *   - 제품목표폭(정전목표폭) = 주문폭 + 제품폭여유치
 * - 재단선유무가 'Y'이고 주문Slit조수가 '2'이고 주문폭과 조합폭1이 다른 경우
 *   - 기준적용폭 = 조합폭1
 *   - 제품목표폭(정전목표폭) = 기준적용폭 + 제품폭여유치
 * - 주문Slit조수가 2보다크고 주문폭과 조합폭1이 같은 경우
 *   - 기준적용폭 = 주문폭 * 주문Slit조수
 *   - 제품목표폭(정전목표폭) = 기준적용폭 + 제품폭여유치 * 주문Slit조수
 * - 재단선유무가 'Y'가 아니고 주문Slit조수가 '2'이고 주문폭과 조합폭1이 같은 경우
 *   - 기준적용폭 = 주문폭 * 주문Slit조수
 *   - 제품목표폭(정전목표폭) = 기준적용폭 + 제품폭여유치 * 주문Slit조수
 * - 주문Slit조수가 2보다크고 주문폭과 조합폭1이 다른 경우
 *   - 기준적용폭 = 주문폭
 *   - 제품목표폭(정전목표폭) = 기준적용폭 + 제품폭여유치 * 주문Slit조수
 * - 재단선유무가 'Y'가 아니고 주문Slit조수가 '2'이고 주문폭과 조합폭1이 다른 경우
 *   - 기준적용폭 = 주문폭
 *   - 제품목표폭(정전목표폭) = 기준적용폭 + 제품폭여유치 * 주문Slit조수
 * - 그이외의 경우
 *   - 기준적용폭 = 주문폭
 *   - 제품목표폭(정전목표폭) = 주문폭 + 제품폭여유치
 * 5. 편성정보: 제조사양Slit조수
 * - 제조사양Slit조수 = 주문Slit조수
 * 6. 편성정보: 제조사양조합폭1~10
 * - 주문조합폭1이 '0'이 아닌경우
 *   제조사양조합폭1 = 주문조합폭1 + 폭여유치
 * - 주문조합폭2이 '0'이 아닌경우
 *   제조사양조합폭2 = 주문조합폭2 + 폭여유치
 * - 주문조합폭3이 '0'이 아닌경우
 *   제조사양조합폭3 = 주문조합폭3 + 폭여유치
 * - 주문조합폭4이 '0'이 아닌경우
 *   제조사양조합폭4 = 주문조합폭4 + 폭여유치
 * - 주문조합폭5이 '0'이 아닌경우
 *   제조사양조합폭5 = 주문조합폭5 + 폭여유치
 * - 주문조합폭6이 '0'이 아닌경우
 *   제조사양조합폭6 = 주문조합폭6 + 폭여유치
 * - 주문조합폭7이 '0'이 아닌경우
 *   제조사양조합폭7 = 주문조합폭7 + 폭여유치
 * - 주문조합폭8이 '0'이 아닌경우
 *   제조사양조합폭8 = 주문조합폭8 + 폭여유치
 * - 주문조합폭9이 '0'이 아닌경우
 *   제조사양조합폭9 = 주문조합폭9 + 폭여유치
 * - 주문조합폭10이 '0'이 아닌경우
 *   제조사양조합폭10 = 주문조합폭10 + 폭여유치
 * 7. 편성정보: 정전EDGE지정구분
 * - 주문EDGE지정구분이 'S', 'C'인 경우
 *   정전EDGE지정구분 = 'Y'
 * - 그이외의 경우
 *   정전EDGE지정구분 = 'N'
 * 8. 편성정보: 정전폭마진량
 * - Master Data 정의명 : C10B1079
 * - 정전폭마진량기준 Data 조건항목 : 주문EDGE지정구분, 품명코드, 제품형태, 코팅방식, 수지구분전면
 * -> Read Count = 1 이면 정전폭마진량기준 Data의 정전폭마진량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 정전폭마진량기준 에러처리한다.
 * 9. 편성정보: CCL폭수축량(칼라제품이고 재단선유무가 'Y'인 경우)
 * - Master Data 정의명 : C10B1078
 * - CCL폭수축량기준 Data 조건항목 : 품명코드, 재질코드, PLTCM X-Ray Set치, 기준적용폭
 * -> Read Count = 1 이면 CCL폭수축량기준 Data의 CCL폭수축량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CCL폭수축량기준 에러처리한다.
 * 10. 편성정보: CCL출측폭(칼라제품인 경우)
 * - 재단선유무가 'Y'인 경우
 *   CCL출측폭 = 제품목표폭(정전목표폭)
 * - 그이외의 경우
 *   CCL출측폭 = 제품목표폭(정전목표폭) + 정전폭마진량
 * 11. 편성정보: 중간정전목표폭(재단선유무가 'Y'인 경우)
 * - 주문Slit조수가 '2'인 경우
 *   중간정전목표폭 = (CCL출측폭 + CCL폭수축량) * 2 
 * - 그이외의 경우
 *   중간정전목표폭 = CCL출측폭 + CCL폭수축량 
 * 12. 편성한 결과는 PosContext에 등록
 * 13. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchWthSizeData">
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

public class DbSearchWthSizeData extends PosActivity implements C10NuiConstantsIF
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
        PosRowSet rowset = null;
        PosRow row = null;
        PosDecisionChecker checker = null;
        PosRuleVO result = null;

        String colValue[] = null; // 컬럼값

        double ord_exc_thk = 0;
        double ord_exc_wth = 0;
        String rmtl_cd = C10STR_SPACE;
        String ord_no = C10STR_SPACE;
        String ord_ln = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String prd_shp = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        String mql_cd = C10STR_SPACE;
        String cot_mth = C10STR_SPACE;
        String rsn_tp_frn = C10STR_SPACE;
        String pltcm_set_thk_trv = C10STR_SPACE;
        String ccl_bom_no = C10STR_SPACE;
        String qlt_dsn_mnf_tp = C10STR_SPACE;
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
        String ord_wth_mng_cd = C10STR_SPACE;
        String cut_ln_yn = C10STR_SPACE;
        double wth_tln_llv = 0;
        double wth_tln_ulv = 0;
        double cor_wth_trv = 0;
        double col_wth_mgn = 0;
        double ccl_wth_shr = 0;
        double ccl_wth_trv = 0;
        double mid_cor_wth_trv = 0;
        boolean mid_cor_proc = false;
        double mrg_wth = 0;

        if ( !DbCommonUtil.isNull( ctx.get( COL_QLT_DSN_MNF_TP ) ) )
        	qlt_dsn_mnf_tp = ctx.get( COL_QLT_DSN_MNF_TP ).toString();
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
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_SET_THK_TRV ) ) )
            pltcm_set_thk_trv = ctx.get( COL_PLTCM_SET_THK_TRV ).toString();
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
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_WTH_MNG_CD ) ) )
            ord_wth_mng_cd = ctx.get( COL_ORD_WTH_MNG_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_WTH_TLN_LLV ) ) )
            wth_tln_llv = Double.parseDouble( ctx.get( COL_WTH_TLN_LLV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_WTH_TLN_ULV ) ) )
            wth_tln_ulv = Double.parseDouble( ctx.get( COL_WTH_TLN_ULV ).toString() );

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
                ccl_bom_no = DbCommonUtil.valueOf( row.getAttribute( COL_CCL_BOM_NO ) );
                

                if ( cut_ln_yn.equals( C10STR_YES ) )
                    mid_cor_proc = true;
            }
        }

        // 제품폭여유
        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ord_wth_mng_cd );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( VI_M00_C10A1070, param ); // 제품폭여유치View.select
        } catch ( MasterDataException e )
        {
            rowset = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT03 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( rowset.count() == 1 )
        {
            row = rowset.next();
            mrg_wth = Double.parseDouble( DbCommonUtil.valueOf( row.getAttribute( COL_MRG_WTH ) ) );
        } else if ( rowset.count() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT13 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R138 );
            return PosBizControlConstants.FAILURE;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT03 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R137 );
            return PosBizControlConstants.FAILURE;
        }

        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
        {
            // 제품폭범위
            ctx.put( COL_PRD_WTH_RNG_LLV, Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) + wth_tln_llv );
            ctx.put( COL_PRD_WTH_RNG_ULV, Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) + wth_tln_ulv );
            if ( cut_ln_yn.equals( C10STR_YES ) && 
                    Double.compare( ord_slit_grp_cnt , 2) == 0 && 
                    Double.compare( 
                            Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
                            ord_mix_wth1 ) == 0 )
            {
                ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
                cor_wth_trv = ord_exc_wth + mrg_wth;
            } else if ( cut_ln_yn.equals( C10STR_YES ) && 
                    Double.compare( ord_slit_grp_cnt , 2) == 0 && 
                    Double.compare( 
                            Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
                            ord_mix_wth1 ) != 0 )
            {
                ord_exc_wth = ord_mix_wth1;
                cor_wth_trv = ord_exc_wth + mrg_wth;
           // } else if ( ( Double.compare( ord_slit_grp_cnt, 2 ) > 0 && 
           //         Double.compare( 
           //                 Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
           //                 ord_mix_wth1 ) == 0 ) || 
           //         ( !cut_ln_yn.equals( C10STR_YES ) && 
           //                 Double.compare( ord_slit_grp_cnt , 2) == 0 && 
           //                 Double.compare( 
          //                          Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
          //                          ord_mix_wth1 ) == 0 ) )
          //  {
          //      ord_exc_wth = 
          //              Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * 
          //              ord_slit_grp_cnt;
          //      cor_wth_trv = ord_exc_wth + mrg_wth * ord_slit_grp_cnt;
          //  } else if ( ( Double.compare( ord_slit_grp_cnt, 2 ) > 0 && 
         //           Double.compare( 
         //                   Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
         //                   ord_mix_wth1 ) != 0 ) || 
         //           ( !cut_ln_yn.equals( C10STR_YES ) && 
         //                   Double.compare( ord_slit_grp_cnt , 2) == 0 && 
         //                           Double.compare( 
         //                                   Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
         //                                   ord_mix_wth1 ) != 0 ) )
         //   {
         //       ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
         //       cor_wth_trv = ord_exc_wth + mrg_wth * ord_slit_grp_cnt;
            } else if ( ord_slit_grp_cnt > 0  )
            {
                    ord_exc_wth =   ord_mix_wth1 + ord_mix_wth2 + ord_mix_wth3 + ord_mix_wth4 + ord_mix_wth5
                    		          + ord_mix_wth6 + ord_mix_wth7 + ord_mix_wth8 + ord_mix_wth9 + ord_mix_wth10;
                            
                    cor_wth_trv = ord_exc_wth + mrg_wth * ord_slit_grp_cnt;
            } else
            {
                ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
                cor_wth_trv = ord_exc_wth + mrg_wth;
            }
            // }
        }

        // 제품목표폭(정전목표폭)
        ctx.put( COL_SLIT_GRP_CNT, ord_slit_grp_cnt );
        if ( ord_mix_wth1 > 0 )
            ctx.put( COL_MIX_WTH1, ord_mix_wth1 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH1, ord_mix_wth1 );
        if ( ord_mix_wth2 > 0 )
            ctx.put( COL_MIX_WTH2, ord_mix_wth2 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH2, ord_mix_wth2 );
        if ( ord_mix_wth3 > 0 )
            ctx.put( COL_MIX_WTH3, ord_mix_wth3 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH3, ord_mix_wth3 );
        if ( ord_mix_wth4 > 0 )
            ctx.put( COL_MIX_WTH4, ord_mix_wth4 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH4, ord_mix_wth4 );
        if ( ord_mix_wth5 > 0 )
            ctx.put( COL_MIX_WTH5, ord_mix_wth5 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH5, ord_mix_wth5 );
        if ( ord_mix_wth6 > 0 )
            ctx.put( COL_MIX_WTH6, ord_mix_wth6 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH6, ord_mix_wth6 );
        if ( ord_mix_wth7 > 0 )
            ctx.put( COL_MIX_WTH7, ord_mix_wth7 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH7, ord_mix_wth7 );
        if ( ord_mix_wth8 > 0 )
            ctx.put( COL_MIX_WTH8, ord_mix_wth8 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH8, ord_mix_wth8 );
        if ( ord_mix_wth9 > 0 )
            ctx.put( COL_MIX_WTH9, ord_mix_wth9 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH9, ord_mix_wth9 );
        if ( ord_mix_wth10 > 0 )
            ctx.put( COL_MIX_WTH10, ord_mix_wth10 + mrg_wth );
        else
            ctx.put( COL_MIX_WTH10, ord_mix_wth10 );
        if ( ord_edg_asg_tp.equals( SLIT_EDGE ) || ord_edg_asg_tp.equals( COIL_EDGE ) )
            ctx.put( COL_COR_EDG_ASG_TP, C10STR_YES );
        else
            ctx.put( COL_COR_EDG_ASG_TP, C10STR_NO );

        // 정전폭마진
        colValue = new String[7];
        colValue[0] = ord_edg_asg_tp; // 주문에지구분
        colValue[1] = prd_nm_cd; // 품명코드
        colValue[2] = prd_shp; // 제품형태
        colValue[3] = cot_mth; // 코팅방식
        colValue[4] = rsn_tp_frn; // 수지구분 전면
        colValue[5] = Double.toString( ord_exc_thk ); //정전폭마진기준에서 주문두께 추가(2013.05.29 김태성대리 요청) 
        colValue[6] = ccl_bom_no; //정전폭마진기준에서 ccl bom번호 추가(2015.09.03 김태훈사원 요청)
        
        logger.logDebug( "DONSEOK CHECK1 ord_edg_asg_tp : " + colValue[0] );
        logger.logDebug( "DONSEOK CHECK1 prd_nm_cd : " + colValue[1] );
        logger.logDebug( "DONSEOK CHECK1 prd_shp : " + colValue[2] );
        logger.logDebug( "DONSEOK CHECK1 cot_mth : " + colValue[3] );
        logger.logDebug( "DONSEOK CHECK2 rsn_tp_frn : " + colValue[4] );
        logger.logDebug( "DONSEOK CHECK1 ord_exc_thk : " + colValue[5] );
        logger.logDebug( "DONSEOK CHECK1 ccl_bom_no : " + colValue[6] );

        checker = EasyAccess.getPosDecisionChecker( C10B1079, null );
        result = null;
        try
        {
            result = checker.getPosRule( colValue );
            logger.logDebug( "DONSEOK CHECK3 result : " + result.getRuleValueAt(0) );
        } catch ( MasterDataException e )
        {
            rowset = null;
            logger.logDebug( "DONSEOK CHECK2 ORD THK : " + colValue[5] );
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT28 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( result.getRecordCount() == 1 )
        {
            col_wth_mgn = Double.parseDouble( result.getRuleValueAt( COL_MRG_WTH ) );

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
        
        // CCL출측폭(CCL목표폭)
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
           
            if ( mid_cor_proc )
            {
                // 중간정전 통과제
                ccl_wth_trv = cor_wth_trv;

                // CCL폭감소량
                colValue = new String[4];
                colValue[0] = prd_nm_cd; // 품명
                colValue[1] = mql_cd; // 재질코드
                colValue[2] = pltcm_set_thk_trv; // X-Ray Set
                colValue[3] = Double.toString( ord_exc_wth ); // 기준적용폭
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

                if ( Double.compare( ord_slit_grp_cnt , 2) == 0 )
                    mid_cor_wth_trv = ( ccl_wth_trv + ccl_wth_shr ) * 2;
                else
                    mid_cor_wth_trv = ccl_wth_trv + ccl_wth_shr;
            } else
            {
                ccl_wth_trv = cor_wth_trv + col_wth_mgn;
            }
        }

        // 제품폭범위
        ctx.put( COL_COR_WTH_TRV, cor_wth_trv );
        ctx.put( COL_CCL_WTH_TRV, ccl_wth_trv );
        ctx.put( COL_MID_COR_WTH_TRV, mid_cor_wth_trv );

        ctx.put( COL_SEM_RMTL_YN, C10STR_NO );
        return PosBizControlConstants.SUCCESS;
    }
}
