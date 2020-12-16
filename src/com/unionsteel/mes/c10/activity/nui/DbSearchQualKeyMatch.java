/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchQualKeyMatch.java
 * Change history
 * @LastModifyDate : 2012. 01. 31
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 01. 31 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;


import java.math.BigDecimal;
import java.util.ArrayList;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosAuditAttributes;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosCalcVO;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 Class는 Master Data의 설계Key기준을 읽어 품질설계Key사항을 편성하는 Class이다.
 * <xmp>
 * 1. 편성정보: 품질설계Key사항
 * - Master Table Code: 설계Key기준(C10B1040)
 * - Key: 품명, 형태, 규격약호, 주문용도코드, 고객사(최종수요가)코드, 고객사양번호, 주문두께, 주문폭
 * 2. 우선항목 Match처리
 * - 품질설계Key Master Data 조건항목 : 품명,형태,규격약호,주문용도코드,고객사코드,고객사양번호,주문두께,주문폭
 * ① 필수 Match 조건항목 : 품명,형태,규격약호,주문두께,주문폭
 * ② 선택 Match 조건항목 : 주문용도코드,고객사코드,고객사양번호
 * - 품질설계key 우선순위에 따라 품질설계key Master Data를 Match하여 품질설계Key사항을 설계한다.
 * 3. 편성한 결과는 PosContext에 등록
 * 4. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchQualKeyMatch">
 * <transition name="success" value="SUBSERVICE1" />
 * <transition name="failure" value="ERROR_LOG" />
 * <property name="dao" value="m00dao" />
 * <property name="bind-result" value="RK_MAIN" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * bind-result : 이전에 ctx에 저장된 result
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchQualKeyMatch extends PosActivity implements C10NuiConstantsIF
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

        String prd_nm_cd = C10STR_SPACE;
        String prd_shp = C10STR_SPACE;
        String spc_avr = C10STR_SPACE;
        String spc_ofc = C10STR_SPACE; 
        String ord_usg_cd = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        String cus_bth_pap_no = C10STR_SPACE;
        String ord_exc_thk = C10STR_SPACE;
        String ord_exc_wth = C10STR_SPACE;
        String embs_cd = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        String ord_rou_cd = C10STR_SPACE;
        String ord_spnl_tp = C10STR_SPACE;
        String gw_asg_cd = C10STR_SPACE;
        String mtl_cd = C10STR_SPACE;
        
        //******* 위탁임가공용 주문 FLAG Start ***********
        String poc_cgl_yn = C10STR_SPACE;
        String poc_ccl_yn = C10STR_SPACE;
        //String trst_rshl_yn = C10STR_SPACE;
        //String trst_cgl_yn = "Y";
        //String trst_ccl_yn = "Y";
        //******* 위탁임가공용 주문 FLAG End ***********
        
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
        String ord_knd = C10STR_SPACE;
        String ord_sur_hnd_cd = C10STR_SPACE;
        String ord_mix_wth_tp = C10STR_SPACE;
        String ord_thk_tp = C10STR_SPACE;
        String ccl_bom_no = C10STR_SPACE;
        String clr_cd = C10STR_SPACE;
        
        //포장재중량 계산을 위한 변수선언(코일)
        String ord_pak_mth = C10STR_SPACE;
        String ord_pak_unt_wgt_ulv = C10STR_SPACE;
        String ord_exc_lth = C10STR_SPACE;
        String flow_chl = C10STR_SPACE;

        prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
        prd_shp = (String) ctx.get( COL_PRD_SHP );
        spc_avr = (String) ctx.get( COL_SPC_AVR );
        if ( !DbCommonUtil.isNull( ctx.get( COL_SPC_AVR ) ) )
            if(ctx.get( COL_SPC_AVR ).toString().length() > 1)
                spc_ofc = ctx.get( COL_SPC_AVR ).toString().substring( 0, 2 );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = ctx.get( COL_ORD_EXC_THK ).toString();
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_CUS_BTH_PAP_NO ) ) )
            cus_bth_pap_no = (String) ctx.get( COL_CUS_BTH_PAP_NO );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_USG_CD ) ) )
            ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_FNL_CUS_CD ) ) )
            fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_EMBS_CD ) ) )
            embs_cd = (String) ctx.get( COL_EMBS_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_EDG_ASG_TP ) ) )
            ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_ROU_CD ) ) )
            ord_rou_cd = (String) ctx.get( COL_ORD_ROU_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_SPNL_TP ) ) )
            ord_spnl_tp = (String) ctx.get( COL_ORD_SPNL_TP );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_GW_ASG_CD ) ) )
            gw_asg_cd = (String) ctx.get( COL_GW_ASG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_MTL_CD ) ) )
            mtl_cd = (String) ctx.get( COL_MTL_CD );
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
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_KND ) ) )
            ord_knd = ctx.get( COL_ORD_KND ).toString();
        //******* 위탁임가공용 주문 FLAG START ***********
        if ( !DbCommonUtil.isNull( ctx.get( COL_POC_CGL_YN ) ) )
        	poc_cgl_yn = ctx.get( COL_POC_CGL_YN ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_POC_CCL_YN ) ) )
        	poc_ccl_yn = ctx.get( COL_POC_CCL_YN ).toString();
      //******* 위탁임가공용 주문 FLAG END ***********
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SUR_HND_CD ) ) )
            ord_sur_hnd_cd = ctx.get( COL_ORD_SUR_HND_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_THK_TP ) ) )
            ord_thk_tp = ctx.get( COL_ORD_THK_TP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_BOM_NO ) ) )
            ccl_bom_no = ctx.get( COL_CCL_BOM_NO ).toString();
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_PAK_MTH ) ) )
            ord_pak_mth = (String) ctx.get( COL_ORD_PAK_MTH );                    //포장코드
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_PAK_UNT_WGT_ULV ) ) )
            ord_pak_unt_wgt_ulv = ctx.get( COL_ORD_PAK_UNT_WGT_ULV ).toString();  //포장단중Max
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_LTH ) ) )
            ord_exc_lth = ctx.get( COL_ORD_EXC_LTH ).toString();                  //길이
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_FLOW_CHL ) ) )
        	flow_chl = (String) ctx.get( COL_FLOW_CHL );                          //유통경로
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
        {
           // if ( ord_slit_grp_cnt > 0 && Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) == ord_mix_wth1 )
           //     ord_exc_wth = Double.toString( Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * ord_slit_grp_cnt );
          //  else if ( ord_slit_grp_cnt > 0 && Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) != ord_mix_wth1 )
          //      ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
          //  else
          //      ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();

           if ( ord_slit_grp_cnt > 0 )
               ord_exc_wth = Double.toString(    ord_mix_wth1 + ord_mix_wth2 + ord_mix_wth3 + ord_mix_wth4 + ord_mix_wth5
                                                      + ord_mix_wth6 + ord_mix_wth7 + ord_mix_wth8 + ord_mix_wth9 + ord_mix_wth10 );
           else
                ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
        }

        if ( cus_bth_pap_no.equals( C10STR_SPACE ) )
        {
            cus_bth_pap_no = DbCommonUtil.setAstar( 10 );

            if(ccl_bom_no.length() > 4)
                clr_cd = ccl_bom_no.substring( 0, 5 );
            else clr_cd = DbCommonUtil.setAstar( 5 );
        }
        else
        {
            if(ccl_bom_no.length() > 4)
                clr_cd = ccl_bom_no.substring( 0, 5 );            
        }
        
        while ( true )
        {
            // 로깅시작
            logger.logDebug( "=== 설계Key 기준 ===" );
            logger.logDebug( "조건값 - 품명                : " + prd_nm_cd );
            logger.logDebug( "조건값 - 제품형태            : " + prd_shp );
            logger.logDebug( "조건값 - 규격약호            : " + spc_avr );
            logger.logDebug( "조건값 - 주문용도코드        : " + ord_usg_cd );
            logger.logDebug( "조건값 - 최종고객사          : " + fnl_cus_cd );
            logger.logDebug( "조건값 - 고객 사양번호       : " + cus_bth_pap_no );
            logger.logDebug( "조건값 - EMBOSS무늬        : " + embs_cd );
            logger.logDebug( "조건값 - 주문Spangle구분   : " + ord_spnl_tp );
            logger.logDebug( "조건값 - 주문도금량지정코드  : " + gw_asg_cd );
            logger.logDebug( "조건값 - 주문표면처리코드    : " + ord_sur_hnd_cd );
            logger.logDebug( "조건값 - CCLBOM번호(1~5)  : " + clr_cd );
            logger.logDebug( "조건값 - 주문두께            : " + ord_exc_thk );
            logger.logDebug( "조건값 - 주문폭              : " + ord_exc_wth );
            logger.logDebug( "ord_pak_unt_wgt_ulv     : " + ord_pak_unt_wgt_ulv );
            logger.logDebug( "flow_chl                : " + flow_chl );

            // 로깅종료

            colValue = new String[13];
            colValue[0] = prd_nm_cd;
            colValue[1] = prd_shp;
            colValue[2] = spc_avr;
            colValue[3] = ord_usg_cd;
            colValue[4] = fnl_cus_cd;
            colValue[5] = cus_bth_pap_no;
            colValue[6] = embs_cd;
            colValue[7] = ord_spnl_tp;
            colValue[8] = gw_asg_cd;
            colValue[9] = ord_sur_hnd_cd;
            colValue[10] = clr_cd;
            colValue[11] = ord_exc_thk;
            colValue[12] = ord_exc_wth;

            try
            {
                checker = EasyAccess.getPosDecisionChecker( C10B1040, null );
                //result = null;
                // 결과값 잘 가져오는지 확인
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
            }

            if ( result == null )
            {
                // 결과값이 null
                if ( cus_bth_pap_no.endsWith( C10STR_STAR ) )
                {
                    // 고객사양번호가 미지정
                    if( clr_cd.endsWith(C10STR_STAR) )
                    {
                        // 색상코드 "*****"
                        if ( fnl_cus_cd.endsWith( C10STR_STAR ) )
                        {
                            // 고객사코드 "******"
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                // 주문용도코드 "******"
                                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK01 );
                                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                                logger.logError( ERRMSG_R86 );
                                return PosBizControlConstants.FAILURE;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }
                            else
                            {
                                // 주문용도코드 값에  "*"가 없음
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
   
                            }   
                        } else
                        {
                            // 고객사코드 "******" 가 아님
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                // 주문용도코드 "******"
                                fnl_cus_cd = DbCommonUtil.setAstar( 6 );
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString();
                                else
                                    ord_usg_cd = C10STR_SPACE;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }
                            else
                            {
                                // 주문용도코드 값에  "*"가 없음
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
                            }
                        }
                    }
                    else // 색상코드 "*****"가 아님
                    {    
                        
                        if ( fnl_cus_cd.endsWith( C10STR_STAR ) )
                        {
                            // 고객사코드 "******"
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                // 주문용도코드 "******"
                                clr_cd = DbCommonUtil.setAstar( 5 );
                                if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
                                else ord_usg_cd = C10STR_SPACE;
                                if ( !DbCommonUtil.isNull( (String) ctx.get( COL_FNL_CUS_CD ) ) )
                                    fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
                                else fnl_cus_cd = C10STR_SPACE;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }    
                            else
                            {
                                // 주문용도코드 값에  "*"가 없음
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
   
                            }   
                        } else  //고객사코드가 "*"가 아닌경우
                        {
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                fnl_cus_cd = DbCommonUtil.setAstar( 6 );
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString();
                                else
                                    ord_usg_cd = C10STR_SPACE;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }
                            else
                            {
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
                            }
                        }
                    }
                } else
                {
                    // 고객사양번호가 지정이고 결과값이 없으면 error
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK01 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R86 );
                    return PosBizControlConstants.FAILURE;
                }
            } else
            {
                if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK02 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R87 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    ctx.put( COL_MQL_CD, result.getRuleValueAt( COL_MQL_CD ) );
                    ctx.put( COL_RMTL_CD, result.getRuleValueAt( COL_RMTL_CD1 ) );
                    ctx.put( COL_RMTL_CD1, result.getRuleValueAt( COL_RMTL_CD2 ) );
                    ctx.put( COL_CRM_MNF_STD_NO1, result.getRuleValueAt( COL_CRM_MNF_STD_NO2 ) );
                    ctx.put( COL_QLT_MSG_NM1, result.getRuleValueAt( COL_QLT_MSG_NM2 ) );
                    ctx.put( COL_RMTL_CD2, result.getRuleValueAt( COL_RMTL_CD3 ) );
                    ctx.put( COL_CRM_MNF_STD_NO2, result.getRuleValueAt( COL_CRM_MNF_STD_NO3 ) );
                    ctx.put( COL_QLT_MSG_NM2, result.getRuleValueAt( COL_QLT_MSG_NM3 ) );
                    ctx.put( COL_CRM_MNF_STD_NO, result.getRuleValueAt( COL_CRM_MNF_STD_NO1 ) );
                    //************* 임가공 테스트 *******************
                    /*
                    if(poc_cgl_yn == "Y" && poc_ccl_yn == "Y"){
                    	ctx.put( COL_PAS_PROC_NO, "3OA001" );
                    }
                    else if(poc_cgl_yn == "Y" && poc_ccl_yn == "N"){
                    	ctx.put( COL_PAS_PROC_NO, "GOH001" );
                    }
                    else{
                    	ctx.put( COL_PAS_PROC_NO, result.getRuleValueAt( COL_PAS_PROC_NO ) );
                    }
                    */
                    //****** 원본 *****
                    ctx.put( COL_PAS_PROC_NO, result.getRuleValueAt( COL_PAS_PROC_NO ) );
                    ctx.put( COL_QLT_DSN_CFM_TP, result.getRuleValueAt( COL_QLT_DSN_CFM_TP ) );
                    ctx.put( COL_QLT_MSG_NM, result.getRuleValueAt( COL_QLT_MSG_NM1 ) );
                    ctx.put( COL_QLT_MSG_NM_COR, result.getRuleValueAt( COL_QLT_MSG_NM_COR ) );
                    ctx.put( COL_APR_INP_BAS_CD, result.getRuleValueAt( COL_APR_INP_BAS_CD ) );
                    break;
                }
            }
        }

        // 메세지 저장
        PosAuditAttributes audit = ctx.getAuditAttribute();
        ArrayList<String> RMTL = new ArrayList<String>();
        ArrayList<String> MSG = new ArrayList<String>();
        ArrayList<String> TP = new ArrayList<String>();
        if ( !DbCommonUtil.isNull( ctx.get( COL_CRM_MNF_STD_NO ) ) )
        {
            RMTL.add( (String) ctx.get( COL_RMTL_CD ) );
            if(!DbCommonUtil.isNull( ctx.get( COL_QLT_MSG_NM )))
                MSG.add( (String) ctx.get( COL_QLT_MSG_NM ) );
            else MSG.add( C10STR_SPACE );
            TP.add( NUM1 );
        }
        if ( !DbCommonUtil.isNull( ctx.get( COL_CRM_MNF_STD_NO1 ) ) )
        {
            RMTL.add( (String) ctx.get( COL_RMTL_CD1 ) );
            if(!DbCommonUtil.isNull( ctx.get( COL_QLT_MSG_NM1 ) ) )
                MSG.add( (String) ctx.get( COL_QLT_MSG_NM1 ) );
            else MSG.add( C10STR_SPACE );
            TP.add( NUM2 );
        }
        if ( !DbCommonUtil.isNull( ctx.get( COL_CRM_MNF_STD_NO2 ) ) )
        {
            RMTL.add( (String) ctx.get( COL_RMTL_CD2 ) );
            if(!DbCommonUtil.isNull( ctx.get( COL_QLT_MSG_NM3 ) ) )
                MSG.add( (String) ctx.get( COL_QLT_MSG_NM3 ) );
            else MSG.add( C10STR_SPACE );
            TP.add( NUM3 );
        }

        for ( int nidx = 0; nidx < RMTL.size(); nidx++ )
        {
            param = new PosParameter(); // MD View param
            param.setValueParamter( 0, ctx.get( COL_ORD_NO ) );
            param.setValueParamter( 1, ctx.get( COL_ORD_LN ) );
            param.setValueParamter( 2, TP.get( nidx ) );
            param.setValueParamter( 3, RMTL.get( nidx ) );
            param.setValueParamter( 4, MSG.get( nidx ) );
            param.setAuditAttributes( audit );
            try
            {
                dao.insert( INSERT_MSG, param ); // 반제품 Material
            } catch ( Exception e )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB09 );
                logger.logError( e.getMessage() );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                return PosBizControlConstants.FAILURE;
            }
        }

        // 정전메세지 저장
        param = new PosParameter(); // MD View param
        param.setValueParamter( 0, ctx.get( COL_ORD_NO ) );
        param.setValueParamter( 1, ctx.get( COL_ORD_LN ) );
        param.setValueParamter( 2, ctx.get( COL_QLT_MSG_NM_COR ) );
        param.setAuditAttributes( audit );
        try
        {
            dao.insert( INSERT_MSG_COR, param ); // 반제품 Material
        } catch ( Exception e )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB09 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        //
        if(mtl_cd.equals( C10STR_SPACE ))
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP06 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R149 );
            return PosBizControlConstants.FAILURE;
        }
        
        // Class Code 편집
        String Class1 = C10STR_SPACE;
        String Class2 = C10STR_SPACE;
        String Class3 = C10STR_SPACE;
        String Class34 = C10STR_SPACE;
        String Class4 = C10STR_SPACE;
        String Class5 = C10STR_SPACE;
        String Class6 = C10STR_SPACE;

        if ( ord_slit_grp_cnt > 1 )
        {
            if ( ord_mix_wth1 != ord_mix_wth2 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth3 && ord_mix_wth3 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth4 && ord_mix_wth4 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth5 && ord_mix_wth5 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth6 && ord_mix_wth6 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth7 && ord_mix_wth7 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth8 && ord_mix_wth8 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth9 && ord_mix_wth9 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else if  ( ord_mix_wth1 != ord_mix_wth10 && ord_mix_wth10 != 0 )
                ord_mix_wth_tp = C10STR_YES;
            else
            	ord_mix_wth_tp = C10STR_NO;
        }

        // ClassCode1_제품군
        colValue = new String[4];
        colValue[0] = prd_nm_cd; // 품명코드
        if( !ord_thk_tp.equals( NUM1 ) && !ord_thk_tp.equals( NUM2 ) )
        {
            if( spc_avr.equals( SPC_AVR_KS ) || spc_avr.equals( SPC_AVR_JS ) )
            {
                colValue[1] = NUM1; // 주문두께구분
            }
            else colValue[1] = NUM2; // 주문두께구분
        }
        else
            colValue[1] = ord_thk_tp; // 주문두께구분
        colValue[2] = ord_edg_asg_tp; // 주문EDG
        colValue[3] = spc_ofc; // 규격기관
        
        logger.logError( "품명코드 :" + colValue[0] );
        logger.logError( "주문두께구분 :" + colValue[1] );
        logger.logError( "주문EDG :" + colValue[2] );
        logger.logError( "규격기관 :" + colValue[3] );
        
        checker = EasyAccess.getPosDecisionChecker( C10B9980, null );
        result = null;
        try
        {
            result = checker.getPosRule( colValue );
        } catch ( MasterDataException e )
        {
            result = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK70 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.SUCCESS;
        }

        if ( result.getRecordCount() == 1 )
        {
            if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_CLASS1 ) ) )
                Class1 = result.getRuleValueAt( COL_CLASS1 );
                logger.logError( "Class1 :" + Class1 );

        } else if ( result.getRecordCount() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK71 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R120 );
            return PosBizControlConstants.SUCCESS;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK70 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R119 );
            return PosBizControlConstants.SUCCESS;
        }

        // ClassCode2_행선지
        colValue = new String[5];
        colValue[0] = prd_nm_cd; // 품명
        colValue[1] = prd_shp; //제품형태
        colValue[2] = Double.toString( ord_slit_grp_cnt ); // 조분할
        colValue[3] = ord_mix_wth_tp; //복합조
        colValue[4] = ord_knd; // 주문종류
        
        logger.logError( "품명코드 :" + colValue[0] );
        logger.logError( "제품형태 :" + colValue[1] );
        logger.logError( "조분할 :" + colValue[2] );
        logger.logError( "복합조 :" + colValue[3] );
        logger.logError( "주문종류 :" + colValue[4] );
        
        checker = EasyAccess.getPosDecisionChecker( C10B9981, null );
        result = null;
        try
        {
            result = checker.getPosRule( colValue );
        } catch ( MasterDataException e )
        {
            result = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK72 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.SUCCESS;
        }

        if ( result.getRecordCount() == 1 )
        {
            if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_CLASS2 ) ) )
                Class2 = result.getRuleValueAt( COL_CLASS2 );
                logger.logError( "Class2 :" + Class2 );

        } else if ( result.getRecordCount() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK73 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R122 );
            return PosBizControlConstants.SUCCESS;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK72 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R121 );
            return PosBizControlConstants.SUCCESS;
        }

        // ClassCode6_표면처리
        colValue = new String[2];
        colValue[0] = prd_nm_cd; // 품명코드
        colValue[1] = ord_sur_hnd_cd;  //스팽글
        checker = EasyAccess.getPosDecisionChecker( C10B9984, null );
        result = null;
        try
        {
            result = checker.getPosRule( colValue );
        } catch ( MasterDataException e )
        {
            result = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK78 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.SUCCESS;
        }

        if ( result.getRecordCount() == 1 )
        {
            if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_CLASS6 ) ) )
                Class6 = result.getRuleValueAt( COL_CLASS6 );
                logger.logError( "Class6 :" + Class6 );

        } else if ( result.getRecordCount() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK79 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R128 );
            return PosBizControlConstants.SUCCESS;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK78 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R127 );
            return PosBizControlConstants.SUCCESS;
        }

        if ( prd_nm_cd.equals( PRD_NM_CD_A ) || 
                prd_nm_cd.equals( PRD_NM_CD_B ) || 
                prd_nm_cd.equals( PRD_NM_CD_C ) || 
                prd_nm_cd.equals( PRD_NM_CD_D ) || 
                prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                prd_nm_cd.equals( PRD_NM_CD_E ) ||
                prd_nm_cd.equals( PRD_NM_CD_N ) ||
                prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                prd_nm_cd.equals( PRD_NM_CD_5 ) ||
                prd_nm_cd.equals( PRD_NM_CD_7 ) ||
                prd_nm_cd.equals( PRD_NM_CD_8 ))
        {
            // ClassCode34_재질COPOEG
            colValue = new String[2];
            colValue[0] = prd_nm_cd; // 품명코드
            colValue[1] = (String) ctx.get( COL_MQL_CD ); //재질코드
            
            checker = EasyAccess.getPosDecisionChecker( C10B9982, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
            	result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK74 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }

            if ( result.getRecordCount() == 1 )
            {
                if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_CLASS34 ) ) )
                    Class34 = result.getRuleValueAt( COL_CLASS34 );
                    logger.logDebug( "Class34 :" + Class34 );

            } else if ( result.getRecordCount() > 1 )
            {
            	ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK75 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R124 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
            	ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK74 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R123 );
                return PosBizControlConstants.SUCCESS;
            }

            if ( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_2 ) || prd_nm_cd.equals( PRD_NM_CD_N ) || prd_nm_cd.equals( PRD_NM_CD_8 ))
            {
            	Class5 = gw_asg_cd;
            }
            else
            {
            	Class5 = ord_rou_cd;
            }
            logger.logDebug( "Class5 :" + Class5 );
            
            ctx.put( COL_CLS_CD, Class1 + Class2 + Class34 + Class5 + Class6 );
            logger.logDebug( "cls test7" );
            if ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_5 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_7 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_8 ) )
            {	
                if(mtl_cd.length() > 14)
                {
                    if(mtl_cd.indexOf( "-" ) < 0)
                        ctx.put( COL_SUB_CLS_CD, mtl_cd.substring( 7, 13 ) + ccl_bom_no );
                    else
                        ctx.put( COL_SUB_CLS_CD, mtl_cd.substring( 8, 14 ) + ccl_bom_no );
                }
            }
            else
                ctx.put( COL_SUB_CLS_CD, C10STR_SPACE );
            logger.logDebug( "cls test8" );

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
            // ClassCode34_재질COPOEG
            colValue = new String[3];
            colValue[0] = prd_nm_cd; // 재질코드
            colValue[1] = (String) ctx.get( COL_MQL_CD );
            colValue[2] = spc_ofc;
            checker = EasyAccess.getPosDecisionChecker( C10B9983, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK76 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }

            if ( result.getRecordCount() == 1 )
            {
                if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_CLASS3 ) ) )
                    Class3 = result.getRuleValueAt( COL_CLASS3 );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK77 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R126 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK76 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R125 );
                return PosBizControlConstants.SUCCESS;
            }

            Class4 = ord_spnl_tp;
            Class5 = gw_asg_cd;
            ctx.put( COL_CLS_CD, Class1 + Class2 + Class3 + Class4 + Class5 + Class6 );
            if ( prd_nm_cd.equals( PRD_NM_CD_3 ) || 
            		prd_nm_cd.equals( PRD_NM_CD_4 ) || 
            		prd_nm_cd.equals( PRD_NM_CD_6 ) || 
                     prd_nm_cd.equals( PRD_NM_CD_9 ) )
            {
                if(mtl_cd.length() > 14)
                {
                    if(mtl_cd.indexOf( "-" ) < 0)
                        ctx.put( COL_SUB_CLS_CD, mtl_cd.substring( 7, 13 ) + ccl_bom_no );
                    else
                        ctx.put( COL_SUB_CLS_CD, mtl_cd.substring( 8, 14 ) + ccl_bom_no );
                }
            }
            else
                ctx.put( COL_SUB_CLS_CD, C10STR_SPACE );
        }

        if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N)  ||
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8))
        {                
            // EG, EG칼라만 조도코드 조회
            colValue = new String[6];
            colValue[0] = prd_nm_cd; // 품명코드
            colValue[1] = spc_ofc; // 규격기관
            colValue[2] = ord_usg_cd; // 주문용도코드
            colValue[3] = fnl_cus_cd; // 최종수요가
            colValue[4] = ord_exc_thk; // 주문두께
            colValue[5] = ord_exc_wth;

            checker = EasyAccess.getPosDecisionChecker( C10B2080, null );
            result = null;
            
            try
            {
                // 결과값 잘 가져오는지 확인
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
            	result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK84 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }

            if ( result.getRecordCount() == 1 )
            {
                ctx.put( COL_ORD_ROU_CD, result.getRuleValueAt( COL_ORD_ROU_CD ) );
                logger.logDebug( COL_ORD_ROU_CD + C10STR_COLON + result.getRuleValueAt( COL_ORD_ROU_CD ) );
            } else if ( result.getRecordCount() > 1 )
            {
            	ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK85 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R148 );
            } else
            {
                // 0건인경우 SKIP
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK84 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R147 );
            }
        }
        
        if(prd_shp.equals( PRD_SHP_COIL )) //포장재중량계산(코일시작)
        {
	        colValue = new String[4];
	        colValue[0] = ord_pak_mth;          // 포장방법
	        colValue[1] = ord_exc_wth;          // 폭범위
	        colValue[2] = ord_pak_unt_wgt_ulv;  // 포장단중
	        colValue[3] = ord_exc_lth;          // 길이범위
	        
	        logger.logDebug( "=== package weight calc method ===" );
            logger.logDebug( "package method                : " + ord_pak_mth );
            logger.logDebug( "ord_exc_wth                   : " + ord_exc_wth );
            logger.logDebug( "ord_pak_unt_wgt_ulv           : " + ord_pak_unt_wgt_ulv + C10STR_COLON + colValue[2]);
            logger.logDebug( "ord_exc_lth                   : " + ord_exc_lth );
	        
	        checker = EasyAccess.getPosDecisionChecker( C10B1081, null );
	        result = null;
	        try
	        {
	            result = checker.getPosRule( colValue );
	        } catch ( MasterDataException e )
	        {
	            result = null;
	            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK92 );
	            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
	            logger.logError( e.getMessage() );
	            return PosBizControlConstants.SUCCESS;
	        }
	
	        if ( result.getRecordCount() == 1 )
	        {
	        	ctx.put( COL_ORD_PAK_MTL_WGT, result.getRuleValueAt( COL_ORD_PAK_MTL_WGT ) );
                logger.logDebug( COL_ORD_PAK_MTL_WGT + C10STR_COLON + result.getRuleValueAt( COL_ORD_PAK_MTL_WGT ) );
	
	        } else if ( result.getRecordCount() > 1 )
	        {
	            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK93 );
	            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
	            logger.logError( ERRMSG_R153 );
	            return PosBizControlConstants.SUCCESS;
	        } else
	        {
	            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK92 );
	            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
	            logger.logError( ERRMSG_R152 );
	            return PosBizControlConstants.SUCCESS;
	        }
        }
        else if(prd_shp.equals( PRD_SHP_SHEET )) //포장재중량계산(sheet시작)
        {
        	double wgtLthTot_Tmp;	// 제품폭 + 길이 합계(double형)
        	String wgtLthTot;       // 제품폭 + 길이 합계(String형)
        	
        	wgtLthTot_Tmp = Double.parseDouble(ord_exc_lth.toString()) + Double.parseDouble(ord_exc_wth.toString());
        	wgtLthTot = Double.toString(wgtLthTot_Tmp);  //형변환(double -> String)
        	
            //getPosCalc에 넣을 배열 선언
        	ArrayList calInputList = new ArrayList();
        	calInputList.add(new String[]{flow_chl});       //유통-경로(FLOW_CHL)          C1
        	calInputList.add(new String[]{wgtLthTot});      //제품폭_길이합계(WTH_LTH_TOT) C2
        	calInputList.add(new String[]{ord_exc_wth});    //제품폭(PRD_WTH)             V1
        	calInputList.add(new String[]{ord_exc_lth});    //제품길이(PRD_LTH)           V2

        	PosCalcVO posCalcVo = EasyAccess.getPosCalc("C10A2230",calInputList); //계산식
        	
        	BigDecimal calResult = null;  // EasyAccess.getPosCalc는 BigDecimal로 계산 결과를 리턴함
        	calResult = posCalcVo.getResultValue().setScale(0, BigDecimal.ROUND_HALF_UP);  //소수 1번째 자리에서 반올림
        	ctx.put( COL_ORD_PAK_MTL_WGT, calResult);  //계산결과
        	
            logger.logDebug( COL_ORD_PAK_MTL_WGT + C10STR_COLON + calResult ); //계산결과로그
        } //포장재중량계산(sheet완료)
        
        return PosBizControlConstants.SUCCESS;
    }
}
