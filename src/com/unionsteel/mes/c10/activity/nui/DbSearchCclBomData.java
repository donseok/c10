/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchCclBomData.java
 * Change history
 * @LastModifyDate : 2012. 02. 07
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 02. 07 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosColumnDef;
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
 * 이 class는 칼라제조사양을 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: CCL BOM 기준
 * - 품명이 칼라제품이 아니면 Skip
 * - Master Data 정의명 : CCL BOM 기준(TB_C10_CCL_BOM)
 * - CCL BOM 기준 Data 조건항목 : CCL_BOM_NO
 * -> Read Count = 1 이면 CCL BOM 기준 Data의 전체항목을 편집하고 자동확정여부를 편집한다.
 *    자동확정여부가 'M'이 아니면 'A'로 편집한다. --> null이면 M으로 편집(20170927)
 * -> Read Count = 0 이거나 Read Count > 1 이면 CCL BOM 기준 에러처리한다.
 * 2. 편성정보: 칼라물성시험기준
 * - Master 기준테이블(TB_C10_CLR_MPR)을 통한 데이타 결과값 도출
 * . Key: CCLBOM번호, 고객사코드, 주문용도
 * - 품명이 칼라제품이 아니면 Skip
 * - 첫번째 Match 조건 : CCLBOM번호, 고객사코드, 주문용도코드
 * - 두번째 Match 조건 : CCLBOM번호, 고객사코드 "******", 주문용도코드 
 * - 세번째 Match 조건 : CCLBOM번호, 고객사코드, 주문용도코드 "******" 
 * - 네번째 Match 조건 : CCLBOM번호, 고객사코드 "******", 주문용도코드 "******" 
 * -> Read Count = 1 이면 CCL BOM 기준 Data의 색차전/후면상하한,물성기준연필경도전/후면,
 *    물성기준MEK전/후면,칼라Bending전면/후면기준코드,칼라Bending시험전면/후면평점,CCL공정품질메세지항목을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CCL BOM 기준 에러처리한다.
 * 3. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 항목별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 3. 편성한 결과를 품질설계결과-공통에 수정, 품질설계결과-칼라제조사양에 등록
 * 4. 정보가 존재하여 등록에 성공한 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchCclBomData">
 * <transition name="success" value="C102100160-service" />
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

public class DbSearchCclBomData extends PosActivity implements C10NuiConstantsIF
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
        PosDecisionChecker checker1 = null;
        PosDecisionChecker checker2 = null;
        PosRuleVO result = null;
        PosRuleVO result1 = null;
        PosRuleVO result2 = null;
        String colValue[] = null; // 컬럼값
        String colValue1[] = null; // 컬럼값
        String colValue2[] = null; // 컬럼값
        
        String ccl_bom_no = C10STR_SPACE;
        String ord_ptt_flm_dtl_cd = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String cus_cd = C10STR_SPACE;
        String ord_usg_cd = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        String qlt_dsn_cfm_tp = C10STR_SPACE;
        //2016.5.10 감량매직체크기준 적용을 위한 변수
        String act_cus_cd = C10STR_SPACE;
        String nat_cd = C10STR_SPACE;
        String def_red_txt = C10STR_SPACE;
        //2016.8.17 지관발주메시지 기준 적용을 위한 변수 추가
        String prd_shp = C10STR_SPACE;
        double ord_exc_thk = 0;
        String embs_cd = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        double ord_pak_unt_wgt_llv = 0;
        double ord_pak_unt_wgt_ulv = 0;
        String hue_cd_top = C10STR_SPACE;
        //2018.04.16 지관발주메세지 ORD_SLV_KND_TP가 N이면 메시지 공백 표시
        String ord_slv_knd_tp = C10STR_SPACE;
        String ppr_rng_pord_txt = C10STR_SPACE;
        //2018.1.5 PE-FOAM적용메시지 기준 적용을 위한 변수 추가
        String pe_foam_txt = C10STR_SPACE;
         
        // Parameter Error Check True=Null, FALE=NotNull
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );

        // 칼라제품이 아니면 Skip
        if ( !prd_nm_cd.equals( PRD_NM_CD_1 ) && 
                !prd_nm_cd.equals( PRD_NM_CD_2 ) && 
                !prd_nm_cd.equals( PRD_NM_CD_3 ) && 
                !prd_nm_cd.equals( PRD_NM_CD_4 ) && 
                !prd_nm_cd.equals( PRD_NM_CD_5 ) && 
                !prd_nm_cd.equals( PRD_NM_CD_6 ) &&
                !prd_nm_cd.equals( PRD_NM_CD_7 ) &&
                !prd_nm_cd.equals( PRD_NM_CD_8 ) &&
                !prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            return PosBizControlConstants.FALSE;
        }

        if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_BOM_NO ) ) )
            ccl_bom_no = (String) ctx.get( COL_CCL_BOM_NO );
        if ( !DbCommonUtil.isNull( ctx.get( COL_CUS_CD ) ) )
            cus_cd = (String) ctx.get( COL_CUS_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
            ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_FNL_CUS_CD ) ) )
            fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_QLT_DSN_CFM_TP ) ) )
            qlt_dsn_cfm_tp = (String) ctx.get( COL_QLT_DSN_CFM_TP );
        // 품질설계공통의 보호필름 사항 BackUp
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_PTT_FLM_DTL_CD ) ) )
            ord_ptt_flm_dtl_cd = (String) ctx.get( COL_ORD_PTT_FLM_DTL_CD );
        //2016.5.10 감량매직체크기준 적용(신종욱기사요청)
        if ( !DbCommonUtil.isNull( ctx.get( COL_ACT_CUS_CD ) ) )
        	act_cus_cd = (String) ctx.get( COL_ACT_CUS_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_NAT_CD ) ) )
        	nat_cd = (String) ctx.get( COL_NAT_CD );
        //2016.8.17 지관발주메시지기준 적용(김태성과장 요청)
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_SHP ) ) )
        	prd_shp = (String) ctx.get( COL_PRD_SHP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
        	ord_exc_thk = Double.parseDouble( ctx.get( COL_ORD_EXC_THK ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_EMBS_CD ) ) )
        	embs_cd = (String) ctx.get( COL_EMBS_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EDG_ASG_TP ) ) )
        	ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_PAK_UNT_WGT_LLV ) ) )
        	ord_pak_unt_wgt_llv =  Double.parseDouble( ctx.get( COL_ORD_PAK_UNT_WGT_LLV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_PAK_UNT_WGT_ULV ) ) )
        	ord_pak_unt_wgt_ulv = Double.parseDouble( ctx.get( COL_ORD_PAK_UNT_WGT_ULV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_HUE_CD_FRN ) ) )
        	hue_cd_top = (String) ctx.get( COL_HUE_CD_FRN );
        //2018.04.16 지관발주메세지 ORD_SLV_KND_TP가 N이면 메시지 공백 표시
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SLV_KND_TP ) ) )
        	ord_slv_knd_tp = (String) ctx.get( COL_ORD_SLV_KND_TP );

        
        PosRowSet rowset = null;
        PosRow row = null;

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ccl_bom_no );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( SELECT_CCL_BOM, param ); // CCL-BOM 기준select
        } catch ( Exception e )
        {
            rowset = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP03 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( rowset.count() == 1 )
        {
            row = rowset.next();
        } else if ( rowset.count() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP13 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_A903 );
            return PosBizControlConstants.FAILURE;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP03 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_A902 );
            return PosBizControlConstants.FAILURE;
        }
        
        //감량매직체크기준(C10B2280)결과 가져오기
        colValue = new String[6];
        colValue[0] = nat_cd;     // 국가코드
        colValue[1] = cus_cd;      // 고객사코드, 2016.08.01 추가 by 성낙원, 신종욱
        colValue[2] = act_cus_cd; // 수요가코드
        colValue[3] = fnl_cus_cd; // 최종수요가코드
        colValue[4] = ord_usg_cd; // 용도코드
        colValue[5] = ccl_bom_no; // CCL BOM번호

        logger.logDebug( "===감량매직체크기준(C10B2280) ===" );
        logger.logDebug( "조건값 - 국가코드    : " + colValue[0] );
        logger.logDebug( "조건값 - 고객사코드 : " + colValue[1] );
        logger.logDebug( "조건값 - 수요가코드  : " + colValue[2] );
        logger.logDebug( "조건값 - 최종수요가코드  : " + colValue[3] );
        logger.logDebug( "조건값 - 용도코드       : " + colValue[4] );
        logger.logDebug( "조건값 - CCL BOM번호 : " + colValue[5] );
         
        checker = EasyAccess.getPosDecisionChecker( C10B2280, null );
        result = null;
        
        try
        {
            // 결과값 잘 가져오는지 확인
            result = checker.getPosRule( colValue );
        }
        catch ( MasterDataException e )
        {
            logger.logError( C10B2280 + C10STR_COLON + e.getMessage() );
            result = null;
        }
        if ( result.getRecordCount() == 1 )
        {
        	def_red_txt = result.getRuleValueAt( COL_DEF_RED_TXT ) ;
        	ctx.put(COL_DEF_RED_TXT, def_red_txt);
        } else if ( result.getRecordCount() > 1 )
        {
        	ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT34 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_I37 );
            return PosBizControlConstants.FAILURE;
        }

        //지관발주메시지기준(C10B2290)결과 가져오기
        colValue1 = new String[13];
        colValue1[0] = cus_cd;                    // 고객사코드
        colValue1[1] = act_cus_cd;               // 수요가코드
        colValue1[2] = fnl_cus_cd;                // 최종수요가코드
        colValue1[3] = prd_nm_cd;               // 품명
        colValue1[4] = prd_shp;                  // 제품형태
        colValue1[5] = Double.toString(ord_exc_thk);             // 주문환산두께
        colValue1[6] = ord_ptt_flm_dtl_cd;      // 보호필름상세코드
        colValue1[7] = embs_cd;                 // EMBOSS무늬
        colValue1[8] = ord_edg_asg_tp;         // 주문Edge지정구분
        colValue1[9] = Double.toString(ord_pak_unt_wgt_llv);    // 포장단중하한
        colValue1[10] = Double.toString(ord_pak_unt_wgt_ulv);  // 포장단중상한
        colValue1[11] = ord_usg_cd;             // 주문용도
        colValue1[12] = hue_cd_top;             // 색상코드(TOP)

        logger.logDebug( "===지관발주메시지기준(C10B2290) ===" );
        logger.logDebug( "조건값 - 고객사코드         : " + colValue1[0] );
        logger.logDebug( "조건값 - 수요가코드         : " + colValue1[1] );
        logger.logDebug( "조건값 - 최종수요가코드    : " + colValue1[2] );
        logger.logDebug( "조건값 - 품명                 : " + colValue1[3] );
        logger.logDebug( "조건값 - 제품형태            : " + colValue1[4] );
        logger.logDebug( "조건값 - 주문환산두께       : " + colValue1[5] );
        logger.logDebug( "조건값 - 보호필름상세코드  : " + colValue1[6] );
        logger.logDebug( "조건값 - EMBOSS무늬       : " + colValue1[7] );
        logger.logDebug( "조건값 - 주문Edge지정구분 : " + colValue1[8] );
        logger.logDebug( "조건값 - 포장단중하한       : " + colValue1[9] );
        logger.logDebug( "조건값 - 포장단중상한       : " + colValue1[10] );
        logger.logDebug( "조건값 - 주문용도            : " + colValue1[11] );
        logger.logDebug( "조건값 - 색상코드(TOP)      : " + colValue1[12] );
        logger.logDebug( "주문내경링종류구분(ord_slv_knd_tp)   : " + ord_slv_knd_tp );
         
        checker1 = EasyAccess.getPosDecisionChecker( C10B2290, null );
        result1 = null;
        
        try
        {
            // 결과값 잘 가져오는지 확인
            result1 = checker1.getPosRule( colValue1 );
        }
        catch ( MasterDataException e )
        {
            logger.logError( C10B2290 + C10STR_COLON + e.getMessage() );
            result1 = null;
        }
        
        if ( result1.getRecordCount() == 1 )
        {
        	if("N".equals(ord_slv_knd_tp)) {
        		ctx.put(COL_PPR_RNG_PORD_TXT, "");
        	} else {
        		ppr_rng_pord_txt = result1.getRuleValueAt( COL_PPR_RNG_PORD_TXT ) ;
	        	ctx.put(COL_PPR_RNG_PORD_TXT, ppr_rng_pord_txt);
        	}
        } else if ( result1.getRecordCount() > 1 )
        {
        	ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT35 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_I39 );
            return PosBizControlConstants.FAILURE;
        }
        
        //PE-FOAM적용메세지 기준(C10B2300)결과 가져오기
        colValue2 = new String[15];
        colValue2[0] = cus_cd;                                        // 고객사코드
        colValue2[1] = act_cus_cd;                                   // 수요가코드
        colValue2[2] = fnl_cus_cd;                                    // 최종수요가코드
        colValue2[3] = prd_nm_cd;                                   // 품명
        colValue2[4] = prd_shp;                                      // 제품형태
        colValue2[5] = Double.toString(ord_exc_thk);              // 주문환산두께
        colValue2[6] = nat_cd;                                         // 국가코드
        colValue2[7] = ord_ptt_flm_dtl_cd;                           // 보호필름상세코드
        colValue2[8] = embs_cd;                                      // EMBOSS무늬
        colValue2[9] = ord_edg_asg_tp;                              // 주문Edge지정구분
        colValue2[10] = Double.toString(ord_pak_unt_wgt_llv);   // 포장단중하한
        colValue2[11] = Double.toString(ord_pak_unt_wgt_ulv);  // 포장단중상한
        colValue2[12] = ord_usg_cd.substring(0,1);                 // 주문용도 대분류
        colValue2[13] = ord_usg_cd;                                  // 주문용도
        colValue2[14] = ccl_bom_no;                                  // CCL BOM 번호
        
        logger.logDebug( "===FOAM적용메세지 기준(C10B2300) ===" );
        logger.logDebug( "조건값 - 고객사코드         : " + colValue2[0] );
        logger.logDebug( "조건값 - 수요가코드         : " + colValue2[1] );
        logger.logDebug( "조건값 - 최종수요가코드    : " + colValue2[2] );
        logger.logDebug( "조건값 - 품명                 : " + colValue2[3] );
        logger.logDebug( "조건값 - 제품형태            : " + colValue2[4] );
        logger.logDebug( "조건값 - 주문환산두께       : " + colValue2[5] );
        logger.logDebug( "조건값 - 국가코드            : " + colValue2[6] );
        logger.logDebug( "조건값 - 보호필름상세코드  : " + colValue2[7] );
        logger.logDebug( "조건값 - EMBOSS무늬       : " + colValue2[8] );
        logger.logDebug( "조건값 - 주문Edge지정구분 : " + colValue2[9] );
        logger.logDebug( "조건값 - 포장단중하한       : " + colValue2[10] );
        logger.logDebug( "조건값 - 포장단중상한       : " + colValue2[11] );
        logger.logDebug( "조건값 - 주문용도대분류    : " + colValue2[12] );
        logger.logDebug( "조건값 - 주문용도            : " + colValue2[13] );
        logger.logDebug( "조건값 - CCL BOM 번호     : " + colValue2[14] );
        
        checker2 = EasyAccess.getPosDecisionChecker( C10B2300, null );
        result2 = null;
        
        try
        {
            // 결과값 잘 가져오는지 확인
            result2 = checker2.getPosRule( colValue2 );
        }
        catch ( MasterDataException e )
        {
            logger.logError( C10B2300 + C10STR_COLON + e.getMessage() );
            result2 = null;
        }
        
        if ( result2.getRecordCount() == 1 )
        {
        	pe_foam_txt = result2.getRuleValueAt( COL_PE_FOAM_TXT ) ;
        	ctx.put(COL_PE_FOAM_TXT, pe_foam_txt);
        	logger.logDebug( "결과값 - PE-FOAM적용메시지     : " + pe_foam_txt );
        } else if ( result2.getRecordCount() > 1 )
        {
        	ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT36 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_I40 );
            return PosBizControlConstants.FAILURE;
        } 
        
        String cname = null;
        Object data = null;
        PosColumnDef[] pcd = rowset.getColumnDefs(); // 칼럼정보

        for ( int i = 0; i < pcd.length; i++ )
        {
            cname = pcd[i].getName();
            data = row.getAttribute( cname );
            if(cname.equals( COL_QLT_DSN_CFM_TP ))
            {
            	logger.logDebug( "=== 품질설계 자동/수동 구분 ===" );
                logger.logDebug( "QLT_DSN_CFM_TP   : " + data );
                if(!DbCommonUtil.isNull( data ))
                {
                    if(data.equals( QLT_DSN_CFM_TP_M ))
                    {
                        colValue = new String[2];
                        colValue[0] = prd_nm_cd;
                        colValue[1] = fnl_cus_cd;

                        checker = EasyAccess.getPosDecisionChecker( C10B2260, null );
                        result = null;
                        
                        try
                        {
                            // 결과값 잘 가져오는지 확인
                            result = checker.getPosRule( colValue );
                        }
                        catch ( MasterDataException e )
                        {
                            logger.logError( C10B2260 + C10STR_COLON + e.getMessage() );
                            result = null;
                        }
                        
                        if(result == null)
                            ctx.put( COL_QLT_DSN_CFM_TP, QLT_DSN_CFM_TP_M );
                    }
                }
                else ctx.put( COL_QLT_DSN_CFM_TP, QLT_DSN_CFM_TP_M );
            }
            else ctx.put( cname, data );
        }

        // 품질설계공통의 보호필름 사항을 반영
        ctx.put( COL_PTT_FLM_DTL_CD, ord_ptt_flm_dtl_cd );
        if(ord_ptt_flm_dtl_cd.length() > 0)
            ctx.put( COL_PTT_FLM_LUS_RT_CD, ord_ptt_flm_dtl_cd.substring( 0, 1 ) );
        else ctx.put( COL_PTT_FLM_LUS_RT_CD, C10STR_SPACE );
        if(ord_ptt_flm_dtl_cd.length() > 1)
            ctx.put( COL_PTT_FLM_THK_CD, ord_ptt_flm_dtl_cd.substring( 1, 2 ) );
        else ctx.put( COL_PTT_FLM_THK_CD, C10STR_SPACE );
        if(ord_ptt_flm_dtl_cd.length() > 2)
            ctx.put( COL_PTT_FLM_MQL_CD, ord_ptt_flm_dtl_cd.substring( 2, 3 ) );
        else ctx.put( COL_PTT_FLM_MQL_CD, C10STR_SPACE );
        if(ord_ptt_flm_dtl_cd.length() > 3)
            ctx.put( COL_PTT_FLM_SUS_ADH_CD, ord_ptt_flm_dtl_cd.substring( 3, 4 ) );
        else ctx.put( COL_PTT_FLM_SUS_ADH_CD, C10STR_SPACE );
        if(ord_ptt_flm_dtl_cd.length() > 4)
            ctx.put( COL_PTT_FLM_PRD_ADH_CD, ord_ptt_flm_dtl_cd.substring( 4, 5 ) );
        else ctx.put( COL_PTT_FLM_PRD_ADH_CD, C10STR_SPACE );

        while( true ){
            // 로깅시작
            logger.logDebug( "=== 칼라물성 기준 ===" );
            logger.logDebug( "조건값 - CCL-BOM번호   : " + ccl_bom_no );
            logger.logDebug( "조건값 - 고객사코드     : " + fnl_cus_cd );
            logger.logDebug( "조건값 - 주문용도       : " + ord_usg_cd );
            // 로깅종료

            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ccl_bom_no );
            param.setWhereClauseParameter( 1, fnl_cus_cd );
            param.setWhereClauseParameter( 2, ord_usg_cd );

            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( SELECT_CLR_MPR, param ); // 칼라물성 기준select
            } catch ( Exception e )
            {
                rowset = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP04 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( rowset.count() == 1 )
            {
                row = rowset.next();
                ctx.put( COL_CLR_DIF_FRN_LLV, row.getAttribute( COL_CLR_DIF_FRN_LLV ) );
                ctx.put( COL_CLR_DIF_FRN_ULV, row.getAttribute( COL_CLR_DIF_FRN_ULV ) );
                ctx.put( COL_CLR_DIF_BAK_LLV, row.getAttribute( COL_CLR_DIF_BAK_LLV ) );
                ctx.put( COL_CLR_DIF_BAK_ULV, row.getAttribute( COL_CLR_DIF_BAK_ULV ) );
                ctx.put( COL_MPR_BAS_PNCL_HRDN_FRN, row.getAttribute( COL_MPR_BAS_PNCL_HRDN_FRN ) );
                ctx.put( COL_MPR_BAS_PNCL_HRDN_BAK, row.getAttribute( COL_MPR_BAS_PNCL_HRDN_BAK ) );
                ctx.put( COL_MPR_BAS_MEK_FRN, row.getAttribute( COL_MPR_BAS_MEK_FRN ) );
                ctx.put( COL_MPR_BAS_MEK_BAK, row.getAttribute( COL_MPR_BAS_MEK_BAK ) );
                ctx.put( COL_CLR_BND_TST_FRN_STD_CD, row.getAttribute( COL_CLR_BND_TST_FRN_STD_CD ) );
                ctx.put( COL_CLR_BND_TST_FRN_GRD_PNT, row.getAttribute( COL_CLR_BND_TST_FRN_GRD_PNT ) );
                ctx.put( COL_CLR_BND_TST_BAK_STD_CD, row.getAttribute( COL_CLR_BND_TST_BAK_STD_CD ) );
                ctx.put( COL_CLR_BND_TST_BAK_GRD_PNT, row.getAttribute( COL_CLR_BND_TST_BAK_GRD_PNT ) );
                ctx.put( COL_CCL_QLT_MSG_TXT, row.getAttribute( COL_CCL_QLT_MSG_TXT ) );
                ctx.put( COL_UNI_GLS_FLM_CD, row.getAttribute( COL_UNI_GLS_FLM_CD ) );
                ctx.put( COL_PTT_FLM_DTL_CD_N, row.getAttribute( COL_PTT_FLM_DTL_CD_N ) );                
                
                if(ord_ptt_flm_dtl_cd.length() > 0)
                	ctx.put( COL_PTT_FLM_MNG_ADH_TXT, row.getAttribute( COL_PTT_FLM_MNG_ADH_TXT ) );
                else ctx.put( COL_PTT_FLM_MNG_ADH_TXT, C10STR_SPACE );
                
                break;

            }else if ( rowset.count() > 1 ){
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP14 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_A664 );
                return PosBizControlConstants.FAILURE;
            }else{
                if(fnl_cus_cd.equals( DbCommonUtil.setAstar( 6 ) ) && ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) ){
                    // 고객사코드 '******', 주문용도코드 '******'
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP04 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_A663 );
                    return PosBizControlConstants.FAILURE;
                }else if ( fnl_cus_cd.equals( DbCommonUtil.setAstar( 6 ) ) ){
                    // 고객사코드 '******'
                    ord_usg_cd = DbCommonUtil.setAstar( 6 );
                }else if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) ){
                    // 주문용도코드 '******'
                    fnl_cus_cd = DbCommonUtil.setAstar( 6 );
                    if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                        ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
                    else
                        ord_usg_cd = C10STR_SPACE;
                }else
                    ord_usg_cd = DbCommonUtil.setAstar( 6 );
            }
        }
        return PosBizControlConstants.SUCCESS;
    }
}
