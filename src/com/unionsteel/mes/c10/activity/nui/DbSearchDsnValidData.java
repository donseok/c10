/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchDsnValidData.java
 * Change history
 * @LastModifyDate : 2012. 02. 08
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 02. 08 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import java.util.ArrayList;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosAuditAttributes;
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

/**
 * 이 class는 품질설계대기인 주문에 대해 설계정합성을 체크하는 class이다.
 * <xmp>
 * 1. 정합성확인정보: 품질설계공통항목
 * - 재질코드, 원자재코드, 제조표준번호, 통과공정번호가 있는지 체크한다.
 * 2. 정합성확인정보: 품질설계결과성분항목
 * - 품질설계결과 성분에 보증성분이 설계 안된 경우  Error
 * - 규격,고객,사내,보증 성분의 각 항목에 대하여 하한 >= 상한 이면 Error
 * - 규격성분 각 항목에 대하여 보증하한 < 규격하한 이면 Error
 * - 규격성분 각 항목에 대하여 보증상한 > 규격상한 이면 Error  
 * - 고객성분이 설계된 항목에 대하여 보증하한 < 고객하한 이면 Error  
 * - 고객성분이 설계된  항목에 대하여 보증상한 > 고객상한 이면 Error
 * 3. 정합성확인정보: 품질설계결과재질항목체크
 * - 품질설계결과 재질에 보증재질이 설계 안된 경우  Error
 * - 규격,고객,사내,보증 재질의 각 항목에 대하여 하한 >= 상한 이면 Error
 * - 규격재질 각 항목에 대하여 보증하한 < 규격하한 이면 Error
 * - 규격재질 각 항목에 대하여 보증상한 > 규격상한 이면 Error  
 * - 고객재질이 설계된 항목에 대하여 보증하한 < 고객하한 이면 Error  
 * - 고객재질이 설계된  항목에 대하여 보증상한 > 고객상한 이면 Error
 * 4. 정합성확인정보: 품질설계결과인수도항목체크
 * - 품질설계결과 인수도에 보증인수도가 설계 안된 경우  Error
 * - 각 항목에 대해 고객인수도가 설계된 경우 고객인수도(하한,상한)가 보증인수도(하한,상한)와 다르면 Error
 * - 각 항목에 대해 고객인수도가 설계안된 경우 규격인수도(하한,상한)가 보증인수도(하한,상한)와 다르면 Error
 * 5. 정합성확인정보: 제조사양중요항목체크
 * - 제품두께, 제품두께하한, 제품두께상한 설계가 안된 경우 Error 
 * - 제품폭, 제품폭하한, 제품폭상한 설계가 안된 경우 Error 
 * - 도금제품인 경우 도금출측 두께가  설계가 안된 경우 Error 
 * - 도금제품인 경우 도금출측폭이  설계가 안된 경우 Error 
 * - 도금제품인 경우 도금두께,작업도금량이  설계가 안된 경우 Error 
 * - PLTCM X-RAY SET  두께가  설계가 안된 경우 Error 
 * - PLTCM  폭이  설계가 안된 경우 Error 
 * - 원자재두께가  설계가 안된 경우 Error 
 * - 원자재  폭이  설계가 안된 경우 Error 
 * - CR,EG,CR칼라,EG칼라 제품인 경우 소둔로,소둔Cycle이 Space 이면  Error
 * - GI,GL,GA, GI칼라,GL칼라,GA칼라 제품인 경우 CGL 소둔Cycle이  Space이면  Error 
 * 6. 에러등록 및 품질설계상태 반영
 * - 에러가 존재하는경우 품질설계에러Table에 발생한 에러코드를 모두 등록한다.
 * - 재설계요청이 아닌경우
 *   - 편성정보: SMS발송기준
 *   - Master Data 정의명 : C10B9991
 *   - SMS발송대상 기준 Data 조건항목 : 품명코드, 긴급재구분, 주문행번중량
 *   -> Read Count > 0 이면 SMS발송대상 기준 Data의 발송여부를 편집한다.
 *   -> 에러처리하지 안는다.
 *   - 편성정보: SMS발송대상(SMS발송기준이 존재하는경우)
 *   - Master Data 정의명 : C10B9990
 *   - SMS발송대상 기준 Data 조건항목 : 품명코드
 *   -> Read Count = 1 이면 SMS발송대상 기준 Data의 SMS수신자면, 수신전화번호, 발송전화번호, 발송내역을 편집한다.
 *      - SMS인터페이스Table(TB_M90_SMS)에 Insert한다.
 *   -> 에러처리하지 안는다.
 * - 품질설계상태를 품질설계공통에 반영한다.
 *   - 에러인 경우는 품질설계상태를 'E'로 등록
 *   - 에러가 없고 자동확정구분이 'A'인 경우 품질설계상태를 'A'로 등록
 *   - 그이외의 경우 품질설계상태를 'B'로 등록
 * 7. 에러가 없고 자동확정구분(QLT_DSN_CFM_TP)이 'A'인 경우 transition='TRUE', 
 *    그이외의 경우는 transition='FALSE'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchDsnValidData">
 * <transition name="success" value="C103100010-service" />
 * <property name="dao" value="mesdao" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchDsnValidData extends PosActivity implements C10NuiConstantsIF
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

        String err_code = C10STR_SPACE;
        String ord_no = C10STR_SPACE;
        String ord_ln = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String qlt_dsn_cfm_tp = C10STR_SPACE;
        String qlt_dsn_err_yn = C10STR_SPACE;
        String gw_asg_cd = C10STR_SPACE;
        String ord_knd   = C10STR_SPACE;
        double ord_unt_wgt = 0;
        String ord_dsn_cfm_tp = C10STR_SPACE; //OMS주문 입력 값(자동/수동설계)
        String cut_ln_yn = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        String ccl_bom_no = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        //String poc_auto_yn = C10STR_SPACE;
        //String att_ord_yn = C10STR_SPACE;
        //String ord_rgs_prs_id = C10STR_SPACE; //자동설계 조건(영업사원 - 주문등록자)

        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) )
            ord_no = (String) ctx.get( COL_ORD_NO );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) )
            ord_ln = (String) ctx.get( COL_ORD_LN );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_QLT_DSN_CFM_TP ) ) )
            qlt_dsn_cfm_tp = (String) ctx.get( COL_QLT_DSN_CFM_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_QLT_DSN_ERR_YN ) ) )
            qlt_dsn_err_yn = (String) ctx.get( COL_QLT_DSN_ERR_YN );
        if ( !DbCommonUtil.isNull( ctx.get( COL_GW_ASG_CD ) ) )
            gw_asg_cd = (String) ctx.get( COL_GW_ASG_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_UNT_WGT ) ) )
            ord_unt_wgt = Double.parseDouble( ctx.get( COL_ORD_UNT_WGT ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_KND ) ) )
            ord_knd = (String) ctx.get( COL_ORD_KND );
        //if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_RGS_PRS_ID ) ) ) // 자동설계 추가
        //    ord_rgs_prs_id = (String) ctx.get( COL_ORD_RGS_PRS_ID );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_DSN_CFM_TP ) ) ) //OMS주문 입력 값(자동/수동설계) cmn에 입력되어 있는 값을 받아와서 변수에 입력 
            ord_dsn_cfm_tp = (String) ctx.get( COL_ORD_DSN_CFM_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_FNL_CUS_CD ) ) ) //최종고객사 
            fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
        
        //2015.8.19 추가(박성용기사 -> BOM재단선 Y인 경우, Edge가 'M'으로 되어 있는 경우는 주문에러 발생)
        //if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_BOM_NO ) ) ) //CCLBOM번호
        //	ccl_bom_no = (String) ctx.get( COL_CCL_BOM_NO );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EDG_ASG_TP ) ) ) //주문Edge지정구분
            ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_BOM_NO ) ) ){
	        PosParameter param = new PosParameter(); // MD View param
	        param.setWhereClauseParameter( 0, ord_no );
	        param.setWhereClauseParameter( 1, ord_ln );
	        PosRowSet rowset = null;
	        PosRow row = null;
        
	        try
	        {
	            // 결과값 잘 가져오는지 확인
	        	rowset = dao.find( SELECT_MNF_CCL_BOM, param );
	        } catch ( Exception e )
	        {
	            // 조회 시 에러인 경우
	        	rowset = null;
	            logger.logError( e.getMessage() );
	        }
	        
	        if ( rowset.hasNext() )
	        {
	        	row = rowset.next();
	        	cut_ln_yn = DbCommonUtil.valueOf( row.getAttribute( COL_CUT_LN_YN ) );
	        }
        
	        logger.logError( "-----donseok log-----" );
	        logger.logError( "ccl_bom_no : " + ccl_bom_no );
	        logger.logError( "cut_ln_yn : " + cut_ln_yn );
	        logger.logError( "ord_edg_asg_tp :" + ord_edg_asg_tp );
	        logger.logError( "ord_no : " + ord_no );
	        logger.logError( "ord_ln : " + ord_ln );
	        logger.logError( "fnl_cus_cd : " + fnl_cus_cd );
	        
	        //재단선이 Y이고, Edge구분이 M인 경우 주문에러 발생
	        //최종고객사 320104 : 부산공장일반용 제외
	        if ( (fnl_cus_cd != "320104" && !fnl_cus_cd.equals( "320104" )) && cut_ln_yn.equals( C10STR_YES ) && ord_edg_asg_tp.equals( MILL_EDGE ) ){
	        	err_code = SetErrorcode( err_code, ERRCD_CF84 );
	            logger.logError( ERRMSG_CF84 );
	        }
        } //end of code...

        // 재질코드 체크
        if ( DbCommonUtil.isNull( ctx.get( COL_MQL_CD ) ) )
        {
            err_code = SetErrorcode( err_code, ERRCD_CF01 );
            logger.logError( ERRMSG_CF01 );
        }

        // 원자재코드 체크
        if ( DbCommonUtil.isNull( ctx.get( COL_RMTL_CD ) ) )
        {
            err_code = SetErrorcode( err_code, ERRCD_CF02 );
            logger.logError( ERRMSG_CF02 );
        }

        // 제조표준번호 체크
        if ( DbCommonUtil.isNull( ctx.get( COL_CRM_MNF_STD_NO ) ) )
        {
            err_code = SetErrorcode( err_code, ERRCD_CF03 );
            logger.logError( ERRMSG_CF03 );
        }

        // 통과공정번호 체크
        if ( DbCommonUtil.isNull( ctx.get( COL_PAS_PROC_NO ) ) )
        {
            err_code = SetErrorcode( err_code, ERRCD_CF04 );
            logger.logError( ERRMSG_CF04 );
        }
        
        // 매중량 체크
        if ( ord_unt_wgt == 0 )
        {
            err_code = SetErrorcode( err_code, ERRCD_CF82 );
            logger.logError( ERRMSG_CF82 );
        }

        // 품질설계결과성분 체크
        err_code = CheckChem( dao, ord_no, ord_ln, err_code );

        // 품질설계결과재질 체크
        err_code = CheckMech( dao, ord_no, ord_ln, err_code );

        // 품질설계결과인수도 체크
        err_code = CheckDeli( dao, ord_no, ord_ln, err_code );

        // 품질설계결과(칼라)제조사양 중요항목 체크
        err_code = CheckMnf( dao, ord_no, ord_ln, prd_nm_cd, gw_asg_cd, err_code );
        
        PosAuditAttributes audit = ctx.getAuditAttribute();

        if ( !ErrProc( dao, ord_no, ord_ln, qlt_dsn_cfm_tp, ord_dsn_cfm_tp, err_code, audit, ctx, qlt_dsn_err_yn, ord_knd ) )
        {
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
        }

        if ( err_code.equals( C10STR_SPACE ) && qlt_dsn_cfm_tp.equals( QLT_DSN_CFM_TP_A ) )
        {
            return PosBizControlConstants.TRUE;
        }
        
        

        return PosBizControlConstants.FALSE;
    }

    /**
     * 설계정합성 체크 에	러코드를 편성하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param ERR_CODE
     * @param VALUE
     * @return String
     */

    public String SetErrorcode( String ERR_CODE, String VALUE )
    {
        if ( ERR_CODE.equals( C10STR_SPACE ) )
        {
            ERR_CODE = VALUE;
        } else
            ERR_CODE = ERR_CODE + C10STR_COLON + VALUE;

        return ERR_CODE;
    }

    /**
     * 품질설계결과성분항목 정합성을 체크하는함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param dao Data Access Object
     * @return String
     */

    public String CheckChem( PosGenericDao dao, String ORD_NO, String ORD_LN, String ERR_CODE )
    {
        // 규격사양 조회
        PosParameter param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM2 );
        PosRowSet rowset1 = null;
        PosRowSet rowset2 = null;
        PosRowSet rowset4 = null;
        PosRow row1 = null;
        PosRow row2 = null;
        PosRow row4 = null;
        ArrayList<String[]> MIN_MAX = new ArrayList<String[]>();
        String[] VALUE = new String[4];

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset2 = dao.find( SELECT_CHM, param ); // 규격사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            rowset2 = null;
            logger.logError( e.getMessage() );
        }

        if ( !rowset2.equals( null ) && rowset2.count() != 0 )
        {
            row2 = rowset2.next();
            // 고객사양상하한 체크
            // C
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_C_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_C_ULV ) );
            VALUE[2] = ERRCD_C013;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // SI
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_SI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_SI_ULV ) );
            VALUE[2] = ERRCD_C023;
            MIN_MAX.add( VALUE );

            // MN
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_MN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_MN_ULV ) );
            VALUE[2] = ERRCD_C033;
            MIN_MAX.add( VALUE );

            // P
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_P_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_P_ULV ) );
            VALUE[2] = ERRCD_C043;
            MIN_MAX.add( VALUE );

            // S
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_S_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_S_ULV ) );
            VALUE[2] = ERRCD_C053;
            MIN_MAX.add( VALUE );

            // CR
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_CR_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_CR_ULV ) );
            VALUE[2] = ERRCD_C063;
            MIN_MAX.add( VALUE );

            // NI
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_NI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_NI_ULV ) );
            VALUE[2] = ERRCD_C073;
            MIN_MAX.add( VALUE );

            // CU
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_CU_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_CU_ULV ) );
            VALUE[2] = ERRCD_C083;
            MIN_MAX.add( VALUE );

            // AL
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_AL_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_AL_ULV ) );
            VALUE[2] = ERRCD_C093;
            MIN_MAX.add( VALUE );

            // TI
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_TI_ULV ) );
            VALUE[2] = ERRCD_C103;
            MIN_MAX.add( VALUE );

            // NB
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_NB_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_NB_ULV ) );
            VALUE[2] = ERRCD_C113;
            MIN_MAX.add( VALUE );

            // V
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_V_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_V_ULV ) );
            VALUE[2] = ERRCD_C123;
            MIN_MAX.add( VALUE );

            // N
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_N_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_N_ULV ) );
            VALUE[2] = ERRCD_C133;
            MIN_MAX.add( VALUE );

        } else
        {
            // 규격사양이 없는 경우 에러
            rowset2 = null;
            logger.logError( ERRMSG_CF05 );
            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF05 );
        }

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM4 );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset4 = dao.find( SELECT_CHM, param ); // 보증사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            logger.logError( e.getMessage() );
        }

        if ( rowset4.count() != 0 && !rowset2.equals( null ) && rowset2.count() != 0 )
        {
            row4 = rowset4.next();

            // C
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_C_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_C_LLV ) );
            VALUE[2] = ERRCD_C011;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_C_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_C_ULV ) );
            VALUE[2] = ERRCD_C011;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // SI
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_SI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_SI_LLV ) );
            VALUE[2] = ERRCD_C021;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_SI_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_SI_ULV ) );
            VALUE[2] = ERRCD_C021;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // MN
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_MN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_MN_LLV ) );
            VALUE[2] = ERRCD_C031;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_MN_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_MN_ULV ) );
            VALUE[2] = ERRCD_C031;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // P
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_P_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_P_LLV ) );
            VALUE[2] = ERRCD_C041;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_P_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_P_ULV ) );
            VALUE[2] = ERRCD_C041;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // S
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_S_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_S_LLV ) );
            VALUE[2] = ERRCD_C051;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_S_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_S_ULV ) );
            VALUE[2] = ERRCD_C051;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // CR
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_CR_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CR_LLV ) );
            VALUE[2] = ERRCD_C061;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_CR_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CR_ULV ) );
            VALUE[2] = ERRCD_C061;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // NI
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_NI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NI_LLV ) );
            VALUE[2] = ERRCD_C071;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_NI_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NI_ULV ) );
            VALUE[2] = ERRCD_C071;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // CU
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_CU_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CU_LLV ) );
            VALUE[2] = ERRCD_C081;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_CU_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CU_ULV ) );
            VALUE[2] = ERRCD_C081;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // AL
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_AL_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_AL_LLV ) );
            VALUE[2] = ERRCD_C091;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_AL_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_AL_ULV ) );
            VALUE[2] = ERRCD_C091;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // TI
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TI_LLV ) );
            VALUE[2] = ERRCD_C101;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TI_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TI_ULV ) );
            VALUE[2] = ERRCD_C101;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // NB
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_NB_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NB_LLV ) );
            VALUE[2] = ERRCD_C111;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_NB_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NB_ULV ) );
            VALUE[2] = ERRCD_C111;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // V
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_V_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_V_LLV ) );
            VALUE[2] = ERRCD_C121;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_V_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_V_ULV ) );
            VALUE[2] = ERRCD_C121;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // N
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_N_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_N_LLV ) );
            VALUE[2] = ERRCD_C131;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_N_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_N_ULV ) );
            VALUE[2] = ERRCD_C131;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );
        } else
        {
            // 보증사양이 없는 경우 에러
            rowset4 = null;
            logger.logError( ERRMSG_CF06 );
            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF06 );
        }

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM1 );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset1 = dao.find( SELECT_CHM, param ); // 고객사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            logger.logError( e.getMessage() );
        }

        if ( rowset1.count() != 0 )
        {
            row1 = rowset1.next();

            if ( !rowset4.equals( null ) && rowset4.count() != 0 )
            {
                // C
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_C_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_C_LLV ) );
                VALUE[2] = ERRCD_C011;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_C_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_C_ULV ) );
                VALUE[2] = ERRCD_C011;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // SI
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_SI_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_SI_LLV ) );
                VALUE[2] = ERRCD_C021;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_SI_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_SI_ULV ) );
                VALUE[2] = ERRCD_C021;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // MN
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_MN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_MN_LLV ) );
                VALUE[2] = ERRCD_C031;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_MN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_MN_ULV ) );
                VALUE[2] = ERRCD_C031;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // P
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_P_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_P_LLV ) );
                VALUE[2] = ERRCD_C041;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_P_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_P_ULV ) );
                VALUE[2] = ERRCD_C041;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // S
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_S_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_S_LLV ) );
                VALUE[2] = ERRCD_C051;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_S_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_S_ULV ) );
                VALUE[2] = ERRCD_C051;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // CR
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_CR_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CR_LLV ) );
                VALUE[2] = ERRCD_C061;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_CR_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CR_ULV ) );
                VALUE[2] = ERRCD_C061;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // NI
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_NI_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NI_LLV ) );
                VALUE[2] = ERRCD_C071;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_NI_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NI_ULV ) );
                VALUE[2] = ERRCD_C071;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // CU
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_CU_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CU_LLV ) );
                VALUE[2] = ERRCD_C081;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_CU_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_CU_ULV ) );
                VALUE[2] = ERRCD_C081;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // AL
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_AL_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_AL_LLV ) );
                VALUE[2] = ERRCD_C091;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_AL_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_AL_ULV ) );
                VALUE[2] = ERRCD_C091;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // TI
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TI_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TI_LLV ) );
                VALUE[2] = ERRCD_C101;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TI_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TI_ULV ) );
                VALUE[2] = ERRCD_C101;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // NB
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_NB_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NB_LLV ) );
                VALUE[2] = ERRCD_C111;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_NB_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_NB_ULV ) );
                VALUE[2] = ERRCD_C111;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // V
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_V_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_V_LLV ) );
                VALUE[2] = ERRCD_C121;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_V_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_V_ULV ) );
                VALUE[2] = ERRCD_C121;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // N
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_N_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_N_LLV ) );
                VALUE[2] = ERRCD_C131;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_N_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_N_ULV ) );
                VALUE[2] = ERRCD_C131;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

            }

            // 고객사양상하한 체크
            // C
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_C_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_C_ULV ) );
            VALUE[2] = ERRCD_C014;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // SI
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_SI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_SI_ULV ) );
            VALUE[2] = ERRCD_C024;
            MIN_MAX.add( VALUE );

            // MN
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_MN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_MN_ULV ) );
            VALUE[2] = ERRCD_C034;
            MIN_MAX.add( VALUE );

            // P
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_P_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_P_ULV ) );
            VALUE[2] = ERRCD_C044;
            MIN_MAX.add( VALUE );

            // S
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_S_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_S_ULV ) );
            VALUE[2] = ERRCD_C054;
            MIN_MAX.add( VALUE );

            // CR
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_CR_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_CR_ULV ) );
            VALUE[2] = ERRCD_C064;
            MIN_MAX.add( VALUE );

            // NI
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_NI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_NI_ULV ) );
            VALUE[2] = ERRCD_C074;
            MIN_MAX.add( VALUE );

            // CU
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_CU_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_CU_ULV ) );
            VALUE[2] = ERRCD_C084;
            MIN_MAX.add( VALUE );

            // AL
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_AL_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_AL_ULV ) );
            VALUE[2] = ERRCD_C094;
            MIN_MAX.add( VALUE );

            // TI
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TI_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_TI_ULV ) );
            VALUE[2] = ERRCD_C104;
            MIN_MAX.add( VALUE );

            // NB
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_NB_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_NB_ULV ) );
            VALUE[2] = ERRCD_C114;
            MIN_MAX.add( VALUE );

            // V
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_V_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_V_ULV ) );
            VALUE[2] = ERRCD_C124;
            MIN_MAX.add( VALUE );

            // N
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_N_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_N_ULV ) );
            VALUE[2] = ERRCD_C134;
            MIN_MAX.add( VALUE );
        }

        ERR_CODE = chkMinMax( MIN_MAX, ERR_CODE );

        return ERR_CODE;
    }

    /**
     * 품질설계결과재질항목 정합성을 체크하는함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param dao Data Access Object
     * @return String
     */

    public String CheckMech( PosGenericDao dao, String ORD_NO, String ORD_LN, String ERR_CODE )
    {
        PosParameter param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM2 );
        PosRowSet rowset1 = null;
        PosRowSet rowset2 = null;
        PosRowSet rowset4 = null;
        PosRow row1 = null;
        PosRow row2 = null;
        PosRow row4 = null;
        boolean sp1 = false;
        boolean sp2 = false;
        boolean sp4 = false;
        ArrayList<String[]> MIN_MAX = new ArrayList<String[]>();
        String[] VALUE = new String[4];
        ArrayList<String[]> CHK_NULL = new ArrayList<String[]>();

        // 규격사양 조회
        try
        {
            // 결과값 잘 가져오는지 확인
            rowset2 = dao.find( SELECT_MQL, param ); // 규격사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            rowset2 = null;
            logger.logError( e.getMessage() );
        }

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM4 );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset4 = dao.find( SELECT_MQL, param ); // 보증사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            rowset4 = null;
            logger.logError( e.getMessage() );
        }

        if ( !rowset2.equals( null ) && rowset2.count() != 0 )
        {
            row2 = rowset2.next();
            sp2 = true;

            // 규격사양상하한 체크
            // TS상하한값 체크
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TS_LLV_MPA ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_TS_ULV_MPA ) );
            VALUE[2] = ERRCD_M013;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // YP
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_YP_LLV_MPA ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_YP_ULV_MPA ) );
            VALUE[2] = ERRCD_M023;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // 연신율상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_ELGN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_ELGN_ULV ) );
            VALUE[2] = ERRCD_M033;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // HRB상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_HRB_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_HRB_ULV ) );
            VALUE[2] = ERRCD_M043;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // ER상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_ER_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_ER_ULV ) );
            VALUE[2] = ERRCD_M053;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // 시편채취지시위치
            // VAL_NULL[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_PIC_GTH_INST_LOC ) );
            // VAL_NULL[1] = ERRCD_M071;
            // CHK_NULL.add( VAL_NULL );

            // 시편채취지시길이
            // VAL_NULL[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_PIC_GTH_INST_LTH ) );
            // VAL_NULL[1] = ERRCD_M081;
            // CHK_NULL.add( VAL_NULL );

            // 시편호수
            // VAL_NULL[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TPG_RGS_NO ) );
            // VAL_NULL[1] = ERRCD_M091;
            // CHK_NULL.add( VAL_NULL );
        } else
        {
            // 규격사양이 없는 경우 에러
            rowset2 = null;
            logger.logError( ERRMSG_CF64 );
            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF64 );
        }

        if ( !rowset4.equals( null ) && rowset4.count() != 0 )
        {
            row4 = rowset4.next();
            sp4 = true;
            if ( rowset2 != null && rowset2.count() != 0 )
            {
                // TS
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TS_LLV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TS_LLV_MPA ) );
                VALUE[2] = ERRCD_M011;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TS_ULV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TS_ULV_MPA ) );
                VALUE[2] = ERRCD_M011;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // YP
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_YP_LLV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_YP_LLV_MPA ) );
                VALUE[2] = ERRCD_M021;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_YP_ULV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_YP_ULV_MPA ) );
                VALUE[2] = ERRCD_M021;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 연신률
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_ELGN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ELGN_LLV ) );
                VALUE[2] = ERRCD_M031;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_ELGN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ELGN_ULV ) );
                VALUE[2] = ERRCD_M031;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // HRB
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_HRB_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_HRB_LLV ) );
                VALUE[2] = ERRCD_M041;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_HRB_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_HRB_ULV ) );
                VALUE[2] = ERRCD_M041;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // ER
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_ER_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ER_LLV ) );
                VALUE[2] = ERRCD_M051;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_ER_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ER_ULV ) );
                VALUE[2] = ERRCD_M051;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 시험도금량전면
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_GW_FRN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_FRN_LLV ) );
                VALUE[2] = ERRCD_M101;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_GW_FRN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_FRN_ULV ) );
                VALUE[2] = ERRCD_M101;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 시험도금량후면
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_GW_BAK_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_BAK_LLV ) );
                VALUE[2] = ERRCD_M103;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_GW_BAK_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_BAK_ULV ) );
                VALUE[2] = ERRCD_M103;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 시험도금량전체
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_GW_TOT_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_TOT_LLV ) );
                VALUE[2] = ERRCD_M111;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_TST_GW_TOT_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_TOT_ULV ) );
                VALUE[2] = ERRCD_M111;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );
            }
            // 시편채취지시위치
            // VAL_NULL[0] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_PIC_GTH_INST_LOC ) );
            // VAL_NULL[1] = ERRCD_M073;
            // CHK_NULL.add( VAL_NULL );
            // 시편채취지시길이
            // VAL_NULL[0] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_PIC_GTH_INST_LTH ) );
            // VAL_NULL[1] = ERRCD_M083;
            // CHK_NULL.add( VAL_NULL );
            // 시편호수
            // VAL_NULL[0] = DbCommonUtil.valueOf( row4.getAttribute( COL_TPG_RGS_NO ) );
            // VAL_NULL[1] = ERRCD_M093;
            // CHK_NULL.add( VAL_NULL );
        } else
        {
            // 보증사양이 없는 경우 에러
            rowset4 = null;
            logger.logError( ERRMSG_CF66 );
            return ERRCD_CF66;
        }

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM1 );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset1 = dao.find( SELECT_CHM, param ); // 고객사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            logger.logError( e.getMessage() );
        }

        if ( rowset1.count() != 0 )
        {
            row1 = rowset1.next();
            sp1 = true;
            if ( !rowset4.equals( null ) && rowset4.count() != 0 )
            {
                // TS
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TS_LLV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TS_LLV_MPA ) );
                VALUE[2] = ERRCD_M012;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TS_ULV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TS_ULV_MPA ) );
                VALUE[2] = ERRCD_M012;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // YP
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_YP_LLV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_YP_LLV_MPA ) );
                VALUE[2] = ERRCD_M022;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_YP_ULV_MPA ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_YP_ULV_MPA ) );
                VALUE[2] = ERRCD_M022;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 연신률
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_ELGN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ELGN_LLV ) );
                VALUE[2] = ERRCD_M032;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_ELGN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ELGN_ULV ) );
                VALUE[2] = ERRCD_M032;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // HRB
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_HRB_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_HRB_LLV ) );
                VALUE[2] = ERRCD_M042;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_HRB_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_HRB_ULV ) );
                VALUE[2] = ERRCD_M042;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // ER
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_ER_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ER_LLV ) );
                VALUE[2] = ERRCD_M052;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_ER_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_ER_ULV ) );
                VALUE[2] = ERRCD_M052;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 시험도금량전면
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_GW_FRN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_FRN_LLV ) );
                VALUE[2] = ERRCD_M102;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_GW_FRN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_FRN_ULV ) );
                VALUE[2] = ERRCD_M102;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 시험도금량후면
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_GW_BAK_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_BAK_LLV ) );
                VALUE[2] = ERRCD_M104;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_GW_BAK_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_BAK_ULV ) );
                VALUE[2] = ERRCD_M104;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 시험도금량전체
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_GW_TOT_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_TOT_LLV ) );
                VALUE[2] = ERRCD_M112;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_GW_TOT_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_TST_GW_TOT_ULV ) );
                VALUE[2] = ERRCD_M112;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );
            }
            // 시편채취지시위치
            // VAL_NULL[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_PIC_GTH_INST_LOC ) );
            // VAL_NULL[1] = ERRCD_M072;
            // CHK_NULL.add( VAL_NULL );
            // 시편채취지시길이
            // VAL_NULL[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TST_PIC_GTH_INST_LTH ) );
            // VAL_NULL[1] = ERRCD_M082;
            // CHK_NULL.add( VAL_NULL );
            // 시편호수
            // VAL_NULL[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TPG_RGS_NO ) );
            // VAL_NULL[1] = ERRCD_M092;
            // CHK_NULL.add( VAL_NULL );

            // 고객사양상하한 체크
            // TS상하한값 체크
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_TS_LLV_MPA ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_TS_ULV_MPA ) );
            VALUE[2] = ERRCD_M014;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // YP
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_YP_LLV_MPA ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_YP_ULV_MPA ) );
            VALUE[2] = ERRCD_M024;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // 연신율상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_ELGN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_ELGN_ULV ) );
            VALUE[2] = ERRCD_M034;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // HRB상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_HRB_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_HRB_ULV ) );
            VALUE[2] = ERRCD_M044;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // ER상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_ER_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_ER_ULV ) );
            VALUE[2] = ERRCD_M054;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
        }

        ERR_CODE = chkMinMax( MIN_MAX, ERR_CODE );

        ERR_CODE = chkNull( CHK_NULL, ERR_CODE );

        if ( !sp1 && sp4 && sp2 )
        {
            if ( !DbCommonUtil.isNull( row2.getAttribute( COL_MQL_BND_TST_STD_CD ) ))
            {
                if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_MQL_BND_TST_STD_CD ) ).equals( 
                        DbCommonUtil.valueOf( row4.getAttribute( COL_MQL_BND_TST_STD_CD ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_M061 );
                }
            }
        }

        if ( sp1 && sp4 )
        {
            if ( !DbCommonUtil.isNull( row1.getAttribute( COL_MQL_BND_TST_STD_CD ) ))
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_MQL_BND_TST_STD_CD ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_MQL_BND_TST_STD_CD ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_M062 );
                }
            }
        }

        ERR_CODE = chkMinMax( MIN_MAX, ERR_CODE );

        ERR_CODE = chkNull( CHK_NULL, ERR_CODE );

        return ERR_CODE;
    }

    /**
     * 품질설계결과인수도항목 정합성을 체크하는함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param dao Data Access Object
     * @return String
     */

    public String CheckDeli( PosGenericDao dao, String ORD_NO, String ORD_LN, String ERR_CODE )
    {
        PosParameter param; // MD View param
        PosRowSet rowset1 = null;
        PosRowSet rowset2 = null;
        PosRowSet rowset4 = null;
        PosRow row1 = null;
        PosRow row2 = null;
        PosRow row4 = null;
        boolean sp1 = false;
        boolean sp4 = false;
        ArrayList<String[]> MIN_MAX = new ArrayList<String[]>();
        String[] VALUE = new String[4];

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM2 );
        // 규격사양 조회
        try
        {
            // 결과값 잘 가져오는지 확인
            rowset2 = dao.find( SELECT_DLV, param ); // 규격사양인수도 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            rowset2 = null;
            logger.logError( e.getMessage() );
        }

        if ( !rowset2.equals( null ) && rowset2.count() != 0 )
        {
            row2 = rowset2.next();
            // 규격사양상하한 체크
            // 두께공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_THK_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_THK_TLN_ULV ) );
            VALUE[2] = ERRCD_D013;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // 폭공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_WTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_WTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D023;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // 길이공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_LTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row2.getAttribute( COL_LTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D033;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
        } else
        {
            // 규격사양이 없는 경우 에러
            rowset2 = null;
            logger.logError( ERRMSG_CF65 );
            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF65 );
        }

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM4 );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset4 = dao.find( SELECT_DLV, param ); // 보증사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            rowset4 = null;
            logger.logError( e.getMessage() );
        }

        if ( !rowset4.equals( null ) && rowset4.count() != 0 )
        {
            row4 = rowset4.next();
            sp4 = true;
        } else
        {
            // 보증사양이 없는 경우 에러
            rowset4 = null;
            logger.logError( ERRMSG_CF67 );
            return ERRCD_CF67;
        }

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );
        param.setWhereClauseParameter( 2, NUM1 );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset1 = dao.find( SELECT_CHM, param ); // 고객사양성분 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            rowset1 = null;
            logger.logError( e.getMessage() );
        }

        if ( rowset1.count() != 0 )
        {
            row1 = rowset1.next();
            sp1 = true;
            if ( !rowset4.equals( null ) )
            {
                // 두께공차상하한값
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_THK_TLN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_THK_TLN_LLV ) );
                VALUE[2] = ERRCD_D012;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_THK_TLN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_THK_TLN_ULV ) );
                VALUE[2] = ERRCD_D012;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 폭공차상하한값
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_WTH_TLN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_WTH_TLN_LLV ) );
                VALUE[2] = ERRCD_D022;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_WTH_TLN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_WTH_TLN_ULV ) );
                VALUE[2] = ERRCD_D022;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );

                // 길이공차상하한값
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_LTH_TLN_LLV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_LTH_TLN_LLV ) );
                VALUE[2] = ERRCD_D032;
                VALUE[3] = C10STR_TRUE;
                MIN_MAX.add( VALUE );
                VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_LTH_TLN_ULV ) );
                VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_LTH_TLN_ULV ) );
                VALUE[2] = ERRCD_D032;
                VALUE[3] = C10STR_SPACE;
                MIN_MAX.add( VALUE );
            }

            // 고객사양상하한 체크
            // 두께공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_THK_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_THK_TLN_ULV ) );
            VALUE[2] = ERRCD_D014;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // 폭공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_WTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_WTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D024;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );

            // 길이공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_LTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row1.getAttribute( COL_LTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D034;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
        }

        if ( !rowset4.equals( null ) && !rowset2.equals( null ) && rowset1.equals( null ) )
        {
            // 두께공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_THK_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_THK_TLN_LLV ) );
            VALUE[2] = ERRCD_D011;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_THK_TLN_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_THK_TLN_ULV ) );
            VALUE[2] = ERRCD_D011;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // 폭공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_WTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_WTH_TLN_LLV ) );
            VALUE[2] = ERRCD_D021;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_WTH_TLN_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_WTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D021;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // 길이공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_LTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_LTH_TLN_LLV ) );
            VALUE[2] = ERRCD_D031;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row2.getAttribute( COL_LTH_TLN_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_LTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D031;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // 반곡H
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_HWAV_H ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_HWAV_H ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D041 );
            }

            // 중곡H
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_MWAV_H ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_MWAV_H ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D051 );
            }

            // 외곡H
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_EWAV_H ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_EWAV_H ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D061 );
            }

            // 직선도상한값
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_SLR_ULV ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_SLR_ULV ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D071 );
            }

            // 직각도상한값
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_RAR_ULV ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_RAR_ULV ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D081 );
            }

            // 대각선차상한값
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_DGLN_DIF_ULV ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_DGLN_DIF_ULV ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D091 );
            }

            // 급준도
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_STPN ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_STPN ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D101 );
            }

            // Telescope
            if ( !DbCommonUtil.valueOf( row2.getAttribute( COL_TLC ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_TLC ) ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D111 );
            }
        }

        if ( sp1 && sp4 )
        {
            // 두께공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_THK_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_THK_TLN_LLV ) );
            VALUE[2] = ERRCD_D012;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_THK_TLN_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_THK_TLN_ULV ) );
            VALUE[2] = ERRCD_D012;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // 폭공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_WTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_WTH_TLN_LLV ) );
            VALUE[2] = ERRCD_D022;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_WTH_TLN_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_WTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D022;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // 길이공차상하한값
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_LTH_TLN_LLV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_LTH_TLN_LLV ) );
            VALUE[2] = ERRCD_D032;
            VALUE[3] = C10STR_TRUE;
            MIN_MAX.add( VALUE );
            VALUE[0] = DbCommonUtil.valueOf( row1.getAttribute( COL_LTH_TLN_ULV ) );
            VALUE[1] = DbCommonUtil.valueOf( row4.getAttribute( COL_LTH_TLN_ULV ) );
            VALUE[2] = ERRCD_D032;
            VALUE[3] = C10STR_SPACE;
            MIN_MAX.add( VALUE );

            // 반곡H
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_HWAV_H ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_HWAV_H ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_HWAV_H ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D042 );
                }
            }

            // 중곡H
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_MWAV_H ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_MWAV_H ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_MWAV_H ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D052 );
                }
            }

            // 외곡H
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_EWAV_H ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_EWAV_H ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_EWAV_H ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D062 );
                }
            }

            // 직선도상한값
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_SLR_ULV ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_SLR_ULV ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_SLR_ULV ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D072 );
                }
            }

            // 직각도상한값
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_RAR_ULV ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_RAR_ULV ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_RAR_ULV ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D082 );
                }
            }

            // 대각선차상한값
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_DGLN_DIF_ULV ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_DGLN_DIF_ULV ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_DGLN_DIF_ULV ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D092 );
                }
            }

            // 급준도
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_STPN ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_STPN ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_STPN ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D102 );
                }
            }

            // Telescope
            if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_TLC ) ).equals( C10STR_SPACE ) )
            {
                if ( !DbCommonUtil.valueOf( row1.getAttribute( COL_TLC ) ).equals( DbCommonUtil.valueOf( row4.getAttribute( COL_TLC ) ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_D112 );
                }
            }
        }

        return ERR_CODE;
    }

    /**
     * 품질설계 제조사양 중요항목 정합성을 체크하는함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param dao Data Access Object
     * @return String
     */

    public String CheckMnf( PosGenericDao dao, String ORD_NO, String ORD_LN, String PRD_NM_CD, String GW_ASG_CD, String ERR_CODE )
    {
        PosParameter param; // MD View param
        PosRowSet rowset = null;
        PosRowSet rowset1 = null;
        PosRow row = null;
        Object data = null;

        if ( !PRD_NM_CD.equals( PRD_NM_CD_5 ) && !PRD_NM_CD.equals( PRD_NM_CD_7 ) )
        //if ( !PRD_NM_CD.equals( PRD_NM_CD_5 ) && !PRD_NM_CD.equals( PRD_NM_CD_7 ) && !PRD_NM_CD.equals( PRD_NM_CD_8 ) && !PRD_NM_CD.equals( PRD_NM_CD_N ))
        {

            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ORD_NO );
            param.setWhereClauseParameter( 1, ORD_LN );
            // 제조사양 조회
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( SELECT_MNF, param ); // 품질설계제조사양 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset = null;
                logger.logError( e.getMessage() );
            }
    
            if ( !rowset.equals( null ) && rowset.count() != 0 )
            {
                row = rowset.next();
    
                // 제품두께,폭값
                if ( DbCommonUtil.isNull( row.getAttribute( COL_PRD_THK_RNG_LLV ) ) || DbCommonUtil.isNull( row.getAttribute( COL_PRD_THK_RNG_ULV ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF07 );
                } else
                {
                    data = DbCommonUtil.numCompare( row.getAttribute( COL_PRD_THK_RNG_LLV ), row.getAttribute( COL_PRD_THK_RNG_ULV ), true );
                    if ( !row.getAttribute( COL_PRD_THK_RNG_ULV ).equals( data ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF08 );
                    }

                    data = DbCommonUtil.numCompare( row.getAttribute( COL_PRD_THK_RNG_LLV ), row.getAttribute( COL_COR_THK_TRV ), true );
                    /* 2013.07.10 제품목표두께가 제품두께범위하한 또는 제품두께규격범위하한 보다 작습니다. 로직 삭제 - 박성용기사 자동화관련해서 요청
                    if ( !row.getAttribute( COL_COR_THK_TRV ).equals( data ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF80 );
                    }
                    */

                    data = DbCommonUtil.numCompare( row.getAttribute( COL_PRD_THK_RNG_ULV ), row.getAttribute( COL_COR_THK_TRV ), true );
                    if ( !row.getAttribute( COL_PRD_THK_RNG_ULV ).equals( data ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF81 );
                    }
                }

                if ( !DbCommonUtil.isNull( row.getAttribute( COL_PRD_THK_SPC_RNG_LLV ) ) && !DbCommonUtil.isNull( row.getAttribute( COL_PRD_THK_SPC_RNG_ULV ) ) )
                {
                    data = DbCommonUtil.numCompare( row.getAttribute( COL_COR_THK_TRV ), row.getAttribute( COL_PRD_THK_SPC_RNG_LLV ), true );
                    /* 2013.07.10 제품목표두께가 제품두께범위하한 또는 제품두께규격범위하한 보다 작습니다. 로직 삭제 - 박성용기사 자동화관련해서 요청
                    if ( !row.getAttribute( COL_COR_THK_TRV ).equals( data ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF80 );
                    }
                    */

                    data = DbCommonUtil.numCompare( row.getAttribute( COL_COR_THK_TRV ), row.getAttribute( COL_PRD_THK_SPC_RNG_ULV ), true );
                    if ( !row.getAttribute( COL_PRD_THK_SPC_RNG_ULV ).equals( data ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF81 );
                    }
                }                    
                
                if ( DbCommonUtil.isNull( row.getAttribute( COL_PRD_WTH_RNG_LLV ) ) || DbCommonUtil.isNull( row.getAttribute( COL_PRD_WTH_RNG_ULV ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF09 );
                } else
                {
                    data = DbCommonUtil.numCompare( row.getAttribute( COL_PRD_WTH_RNG_LLV ), row.getAttribute( COL_PRD_WTH_RNG_ULV ), true );
                    if ( !row.getAttribute( COL_PRD_WTH_RNG_ULV ).equals( data ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF10 );
                    }
                }
    
                // PLTCM
                if ( DbCommonUtil.isNull( row.getAttribute( COL_PLTCM_SET_THK_TRV ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF25 );
                }
                if ( DbCommonUtil.isNull( row.getAttribute( COL_PLTCM_THK_TRV ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF26 );
                }
                
                
                /*
                 * if ( DbCommonUtil.isNull( row.getAttribute( COL_PLTCM_THK_LLV ) ) || DbCommonUtil.isNull( row.getAttribute( COL_PLTCM_THK_ULV
                 * ) ) )
                 * {
                 * ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF27 );
                 * } else
                 * {
                 * data = DbCommonUtil.NumCompare( row.getAttribute( COL_PLTCM_THK_LLV ), row.getAttribute( COL_PLTCM_THK_ULV ), true );
                 * if ( !row.getAttribute( COL_PLTCM_THK_ULV ).equals( data ) )
                 * {
                 * ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF28 );
                 * }
                 * }
                 */
                if ( DbCommonUtil.isNull( row.getAttribute( COL_PLTCM_WTH_TRV ) ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF72 );
                }
    
                
                
                // 도금제품의 경우
                if ( !GW_ASG_CD.equals( C10STR_SPACE ) )
                {                   
                    // 도금목표두께
                    if ( DbCommonUtil.isNull( row.getAttribute( COL_GAL_THK_TRV ) ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF18 );
                    }
                    if ( DbCommonUtil.isNull( row.getAttribute( COL_CGL_THK_TRV ) ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF21 );
                    }
                    if ( DbCommonUtil.isNull( row.getAttribute( COL_EGL_THK_TRV ) ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF23 );
                    }
    
                    // CGL, EGL 목표폭
                    if ( DbCommonUtil.isNull( row.getAttribute( COL_CGL_WTH_TRV ) ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF22 );
                    }
                    if ( DbCommonUtil.isNull( row.getAttribute( COL_EGL_WTH_TRV ) ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF24 );
                    }
    
                    // 도금두께
                    if ( DbCommonUtil.isNull( row.getAttribute( COL_GAL_THK_LLV ) ) || DbCommonUtil.isNull( row.getAttribute( COL_GAL_THK_ULV ) ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF19 );
                    } else
                    {
                        data = DbCommonUtil.numCompare( row.getAttribute( COL_GAL_THK_LLV ), row.getAttribute( COL_GAL_THK_ULV ), true );
                        if ( !row.getAttribute( COL_GAL_THK_ULV ).equals( data ) )
                        {
                            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF20 );
                        }
                    }
    
                    // 작업도금량
                    if ( DbCommonUtil.isNull( row.getAttribute( COL_WK_GW_TRV ) ) )
                    {
                        ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF11 );
                    }
                    
                    if( PRD_NM_CD.equals( PRD_NM_CD_E ) || PRD_NM_CD.equals( PRD_NM_CD_2 ) || PRD_NM_CD.equals( PRD_NM_CD_N ) || PRD_NM_CD.equals( PRD_NM_CD_8 ))
                    {
                        if ( DbCommonUtil.isNull( row.getAttribute( COL_WK_GW_FRN_LLV ) ) || DbCommonUtil.isNull( row.getAttribute( COL_WK_GW_FRN_ULV ) ) )
                        {
                            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF12 );
                        } else
                        {
                            data = DbCommonUtil.numCompare( row.getAttribute( COL_WK_GW_FRN_LLV ), row.getAttribute( COL_WK_GW_FRN_ULV ), true );
                            if ( !row.getAttribute( COL_WK_GW_FRN_ULV ).equals( data ) )
                            {
                                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF13 );
                            }
                        }
                        if ( DbCommonUtil.isNull( row.getAttribute( COL_WK_GW_BAK_LLV ) ) || DbCommonUtil.isNull( row.getAttribute( COL_WK_GW_BAK_ULV ) ) )
                        {
                            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF14 );
                        } else
                        {
                            data = DbCommonUtil.numCompare( row.getAttribute( COL_WK_GW_BAK_LLV ), row.getAttribute( COL_WK_GW_BAK_ULV ), true );
                            if ( !row.getAttribute( COL_WK_GW_BAK_ULV ).equals( data ) )
                            {
                                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF15 );
                            }
                        }
                    }
                    
                    if( PRD_NM_CD.equals( PRD_NM_CD_G ) 
                    		|| PRD_NM_CD.equals( PRD_NM_CD_K )
                            || PRD_NM_CD.equals( PRD_NM_CD_J ) 
                            || PRD_NM_CD.equals( PRD_NM_CD_L )
                            || PRD_NM_CD.equals( PRD_NM_CD_V )
                            || PRD_NM_CD.equals( PRD_NM_CD_W )
                            || PRD_NM_CD.equals( PRD_NM_CD_3 )
                            || PRD_NM_CD.equals( PRD_NM_CD_4 )
                            || PRD_NM_CD.equals( PRD_NM_CD_6 )
                            || PRD_NM_CD.equals( PRD_NM_CD_9 ) )
                    {                        
                        if ( DbCommonUtil.isNull( row.getAttribute( COL_WK_GW_TOT_LLV ) ) || DbCommonUtil.isNull( row.getAttribute( COL_WK_GW_TOT_ULV ) ) )
                        {
                            ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF16 );
                        } else
                        {
                            data = DbCommonUtil.numCompare( row.getAttribute( COL_WK_GW_TOT_LLV ), row.getAttribute( COL_WK_GW_TOT_ULV ), true );
                            if ( !row.getAttribute( COL_WK_GW_TOT_ULV ).equals( data ) )
                            {
                                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF17 );
                            }
                        }
                    }
                }
    
                if ( PRD_NM_CD.equals( PRD_NM_CD_C ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_E )
                        || PRD_NM_CD.equals( PRD_NM_CD_N )
                        || PRD_NM_CD.equals( PRD_NM_CD_1 ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_2 ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_G )
                        || PRD_NM_CD.equals( PRD_NM_CD_K )
                        || PRD_NM_CD.equals( PRD_NM_CD_J ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_L ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_V ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_W ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_3 ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_4 ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_6 ) 
                        || PRD_NM_CD.equals( PRD_NM_CD_9 ) )
                {
                    param = new PosParameter(); // MD View param
                    param.setWhereClauseParameter( 0, ORD_NO );
                    param.setWhereClauseParameter( 1, ORD_LN );
                    // 제조사양 조회
                    try
                    {
                        // 결과값 잘 가져오는지 확인
                        rowset1 = dao.find( SELECT_PROC, param ); // 품질설계제조사양 select
                    } catch ( Exception e )
                    {
                        // 조회 시 에러인 경우
                        rowset1 = null;
                        logger.logError( e.getMessage() );
                    }
    
                    if ( !rowset1.equals( null ) )
                    {
                        // CR, EG, CR칼라, EG칼라제품의 경우
                        if ( PRD_NM_CD.equals( PRD_NM_CD_C ) && PRD_NM_CD.equals( PRD_NM_CD_E ) && 
                        	 PRD_NM_CD.equals( PRD_NM_CD_N ) && PRD_NM_CD.equals( PRD_NM_CD_1 ) && 
                        	 PRD_NM_CD.equals( PRD_NM_CD_2 ) && PRD_NM_CD.equals( PRD_NM_CD_8 ) )
                        {
                            if ( checkProc( rowset1, PROC_CD_3ANN ) || checkProc( rowset1, PROC_CD_4ANN ) )
                            {
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HEAT_CYL_NO_GEN_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF36 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_COR_TM_GEN_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF37 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_COIL_TMP_GEN_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF38 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_CLG_END_TMP_GEN_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF39 );
                                }
                            }
                            if ( checkProc( rowset1, PROC_CD_H_ANN ) )
                            {
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HEAT_CYL_NO_HC_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF40 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_COR_TM_HC_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF41 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_COIL_TMP_HC_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF42 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_CLG_END_TMP_HC_ANN ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF43 );
                                }
                            }
                        }
    
                        // GI, HGI, GA, GL, GI칼라, GA칼라, GL칼라제품의 경우
                        if ( PRD_NM_CD.equals( PRD_NM_CD_G ) && PRD_NM_CD.equals( PRD_NM_CD_K ) &&
                        	 PRD_NM_CD.equals( PRD_NM_CD_J ) && PRD_NM_CD.equals( PRD_NM_CD_L ) && 
                        	 PRD_NM_CD.equals( PRD_NM_CD_V ) && PRD_NM_CD.equals( PRD_NM_CD_W ) && 
                        	 PRD_NM_CD.equals( PRD_NM_CD_3 ) && PRD_NM_CD.equals( PRD_NM_CD_4 ) && 
                        	 PRD_NM_CD.equals( PRD_NM_CD_6 ) && PRD_NM_CD.equals( PRD_NM_CD_9 ) )
                        {
                            if ( checkProc( rowset1, PROC_CD_2CGL ) )
                            {
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HEAT_CYL_NO_2CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF44 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HTG_TEM_2CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF45 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_CLG_TEM_2CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF46 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_SHK_TM_2CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF47 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_LN_SPD_2CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF48 );
                                }
                            }
                            if ( checkProc( rowset1, PROC_CD_3CGL ) )
                            {
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HEAT_CYL_NO_3CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF49 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HTG_TEM_3CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF50 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_CLG_TEM_3CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF51 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_SHK_TM_3CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF52 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_LN_SPD_3CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF53 );
                                }
                            }
                            if ( checkProc( rowset1, PROC_CD_4CGL ) )
                            {
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HEAT_CYL_NO_4CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF54 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HTG_TEM_4CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF55 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_CLG_TEM_4CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF56 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_SHK_TM_4CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF57 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_LN_SPD_4CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF58 );
                                }
                            }
                            if ( checkProc( rowset1, PROC_CD_5CGL ) )
                            {
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HEAT_CYL_NO_5CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF59 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_HTG_TEM_5CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF60 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_CLG_TEM_5CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF61 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_SHK_TM_5CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF62 );
                                }
                                if ( DbCommonUtil.isNull( row.getAttribute( COL_LN_SPD_5CGL ) ) )
                                {
                                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF63 );
                                }
                            }
                        }
                    }
                }
            } else
            {
                // 규격사양이 없는 경우 에러
                rowset = null;
                logger.logError( ERRCD_CF07 );
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF07 );
            }
        }

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, ORD_NO );
        param.setWhereClauseParameter( 1, ORD_LN );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( SELECT_RMT, param ); // 원자재정보 select
        } catch ( Exception e )
        {
            // 조회 시 에러인 경우
            rowset = null;
            logger.logError( e.getMessage() );
        }

        if ( !rowset.equals( null ) && rowset.count() != 0 )
        {
            row = rowset.next();

            // 원자재목표두께
            if ( DbCommonUtil.isNull( row.getAttribute( COL_RMTL_TAR_THK ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF29 );
            }
            // 원자재목표폭
            if ( DbCommonUtil.isNull( row.getAttribute( COL_RMTL_TAR_WTH ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF30 );
            }
            // 원자재목표두께상하한
            if ( DbCommonUtil.isNull( row.getAttribute( COL_RMTL_TAR_THK_LVL ) ) || DbCommonUtil.isNull( row.getAttribute( COL_RMTL_TAR_THK_UVL ) ) )
            {
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF31 );
            } else
            {
                data = DbCommonUtil.numCompare( row.getAttribute( COL_RMTL_TAR_THK_LVL ), row.getAttribute( COL_RMTL_TAR_THK_UVL ), true );
                if ( !row.getAttribute( COL_RMTL_TAR_THK_UVL ).equals( data ) )
                {
                    ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF32 );
                }
            }

            // 원자재목표폭상하한
            /*
             * if ( DbCommonUtil.isNull( row.getAttribute( COL_RMTL_TAR_WTH_LVL ) ) || DbCommonUtil.isNull( row.getAttribute(
             * COL_RMTL_TAR_WTH_UVL ) ) )
             * {
             * ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF33 );
             * } else
             * {
             * data = DbCommonUtil.NumCompare( row.getAttribute( COL_RMTL_TAR_WTH_LVL ), row.getAttribute( COL_RMTL_TAR_WTH_UVL ), true );
             * if ( !row.getAttribute( COL_RMTL_TAR_WTH_UVL ).equals( data ) )
             * {
             * ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF34 );
             * }
             * }
             */
        }

        if ( PRD_NM_CD.equals( PRD_NM_CD_1 ) || 
                PRD_NM_CD.equals( PRD_NM_CD_2 ) || 
                PRD_NM_CD.equals( PRD_NM_CD_3 ) || 
                PRD_NM_CD.equals( PRD_NM_CD_4 ) || 
                PRD_NM_CD.equals( PRD_NM_CD_5 ) || 
                PRD_NM_CD.equals( PRD_NM_CD_6 ) ||
                PRD_NM_CD.equals( PRD_NM_CD_7 ) ||
                PRD_NM_CD.equals( PRD_NM_CD_8 ) ||
                PRD_NM_CD.equals( PRD_NM_CD_9 ) )
        {
            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ORD_NO );
            param.setWhereClauseParameter( 1, ORD_LN );

            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( SELECT_MNF_CCL_BOM, param ); // 고객사양성분 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset = null;
                logger.logError( e.getMessage() );
            }

            if ( rowset.equals( null ) || rowset.count() == 0 )
            {
                logger.logError( ERRMSG_CF35 );
                ERR_CODE = SetErrorcode( ERR_CODE, ERRCD_CF35 );
            }
        }

        return ERR_CODE;
    }

    /**
     * 통과공정코드 존재여부를 리턴하는 편성하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param rowset
     * @param PROC_CD
     * @return boolean
     */

    public boolean checkProc( PosRowSet rowset, String PROC_CD )
    {
        PosRow row = null;

        rowset.reset();

        while ( rowset.hasNext() )
        {
            row = rowset.next();

            if ( row.getAttribute( COL_MAIN_PROC_CD ).equals( PROC_CD ) )
            {
                return true;
            } else if ( row.getAttribute( COL_SUB_PROC_CD1 ).equals( PROC_CD ) )
            {
                return true;
            } else if ( row.getAttribute( COL_SUB_PROC_CD2 ).equals( PROC_CD ) )
            {
                return true;
            }
        }

        return false;
    }

    /**
     * 품질설계에러코드를 처리하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param dao Data Access Object
     * @return boolean
     */

    public boolean ErrProc( PosGenericDao dao, String ORD_NO, String ORD_LN, String QLT_DSN_CFM_TP, String ORD_DSN_CFM_TP, String ERR_CODE, PosAuditAttributes audit, PosContext ctx, String QLT_DSN_ERR_YN, String ORD_KND )
    {
        PosParameter param = null;
        PosParameter param1 = null;
        PosParameter param2 = null;
        PosParameter param3 = null;
        PosParameter param4 = null;
        
        String[] ERR_CD_ARR = ERR_CODE.split( C10STR_COLON );
        PosRowSet rowset = null;
        PosDecisionChecker checker = null;
        PosRuleVO result = null;

        String colValue[] = null; // 컬럼값

        if ( !ERR_CODE.equals( C10STR_SPACE ) )
        {
            for ( int eCnt = 0; eCnt < ERR_CD_ARR.length; eCnt++ )
            {
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, ORD_NO );
                param.setWhereClauseParameter( 1, ORD_LN );
                param.setWhereClauseParameter( 2, ERR_CD_ARR[eCnt] );

                // 에러코드 조회
                try
                {
                    //
                    rowset = dao.find( SELECT_ERR, param ); // 품질설계제조사양 select
                } catch ( Exception e )
                {
                    // 조회 시 에러인 경우
                    rowset = null;
                    logger.logError( e.getMessage() );
                    return false;
                }

                if ( rowset.count() == 0 )
                {
                    // 품질설계결과 통과공정 Insert
                    param = new PosParameter(); // MD View param
                    param.setValueParamter( 0, ORD_NO );
                    param.setValueParamter( 1, ORD_LN );
                    param.setValueParamter( 2, ERR_CD_ARR[eCnt] );
                    param.setAuditAttributes( audit );

                    try
                    {
                        dao.insert( INSERT_ERR, param ); // 반제품 Material
                    } catch ( Exception e )
                    {
                        logger.logError( e.getMessage() );
                        return false;
                    }
                }
            }
        }

        String re_qlt_dsn_tp = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String ord_ln_wgt = C10STR_SPACE;
        String urg_mtl_tp = C10STR_SPACE;
        String ord_spc_txt = C10STR_SPACE;
        String ord_usg_cd = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        String ord_rgs_prs_id = C10STR_SPACE;  // 자동설계 조건추가로 변경(2012.11.05)
        String ord_dsn_cfm_tp = C10STR_SPACE;  //OMS주문 입력 값(자동/수동설계)
        String chk_tmp = C10STR_SPACE;         //OMS수동 품질설계 자동인 경우 그 다음 판단을 위해 잠시 값을 담아 놓음
        String att_ord_yn = C10STR_SPACE;
        String poc_auto_yn = C10STR_SPACE;
        String cus_bth_pap_no = C10STR_SPACE;
                
        if ( !DbCommonUtil.isNull( ctx.get( COL_RE_QLT_DSN_TP ) ) )
            re_qlt_dsn_tp = (String) ctx.get( COL_RE_QLT_DSN_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_LN_WGT ) ) )
            ord_ln_wgt = ctx.get( COL_ORD_LN_WGT ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_URG_MTL_TP ) ) )
            urg_mtl_tp = (String) ctx.get( COL_URG_MTL_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SPC_TXT ) ) )
            ord_spc_txt = (String) ctx.get( COL_ORD_SPC_TXT );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
            ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_FNL_CUS_CD ) ) )
            fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_RGS_PRS_ID ) ) ) // 자동설계 조건추가로 변경(2012.11.05)
            ord_rgs_prs_id = (String) ctx.get( COL_ORD_RGS_PRS_ID );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_DSN_CFM_TP ) ) ) //OMS주문 입력 값(자동/수동설계) cmn에 입력되어 있는 값을 받아와서 변수에 입력 
            ord_dsn_cfm_tp = (String) ctx.get( COL_ORD_DSN_CFM_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ATT_ORD_YN ) ) ) //최종고객사 
        	att_ord_yn = (String) ctx.get( COL_ATT_ORD_YN );
        if ( !DbCommonUtil.isNull( ctx.get( COL_POC_AUTO_YN ) ) ) //광신스틸위탁임가공 
            poc_auto_yn = (String) ctx.get( COL_POC_AUTO_YN );
        if ( !DbCommonUtil.isNull( ctx.get( COL_CUS_BTH_PAP_NO ) ) ) //광신스틸위탁임가공 
        	cus_bth_pap_no = (String) ctx.get( COL_CUS_BTH_PAP_NO );
        
        if ( re_qlt_dsn_tp.equals( C10STR_NO ) )
        {
            colValue = new String[3];
            colValue[0] = prd_nm_cd;
            colValue[1] = urg_mtl_tp;
            colValue[2] = ord_ln_wgt;

            checker = EasyAccess.getPosDecisionChecker( C10B9991, null );
            result = null;
            try
            {
                // 결과값 잘 가져오는지 확인
                result = checker.getPosRule( colValue );

                colValue = new String[1];
                colValue[0] = prd_nm_cd;

                try
                {
                    // 결과값 잘 가져오는지 확인
                    PosDecisionRuleVO result1 = 
                            EasyAccess.getPosDecisionRuleLov( C10B9990, colValue, null );
                    while ( result1.next() )
                    {
                        audit = ctx.getAuditAttribute();
                        param = new PosParameter(); // MD View param
                        param.setValueParamter( 0, ctx.get( COL_IF_GRP_ID ) );
                        param.setValueParamter( 1, result1.getRuleValueAt( COL_SMS_RCV_EMP_NM ) );
                        param.setValueParamter( 2, result1.getRuleValueAt( COL_SMS_RCV_TEL ) );
                        param.setValueParamter( 3, result1.getRuleValueAt( COL_SMS_SND_TEL ) );
                        param.setValueParamter( 4, result1.getRuleValueAt( COL_SMS_SND_TXT ) );
                        param.setAuditAttributes( audit );

                        try
                        {
                            dao.insert( INSERT_SMS, param ); // SMS 발송
                            
                        } catch ( Exception e )
                        {
                            logger.logError( e.getMessage() );
                            return false;
                        }

                    }

                } catch ( MasterDataException e )
                {
                    logger.logError( e.getMessage() );
                }           
            } catch ( MasterDataException e )
            {
                logger.logError( e.getMessage() );
//                return true;
            }

        }
        
        if ( !ERR_CODE.equals( C10STR_SPACE ) || QLT_DSN_ERR_YN.equals( C10STR_YES ) )
        {
            ctx.put( COL_QLT_DSN_STS_CD, QLT_DSN_STS_CD_E );
            param = new PosParameter(); // MD View param
            //param.setWhereClauseParameter( 0, QLT_DSN_STS_CD_E );
            //param.setWhereClauseParameter( 1, ORD_NO );
            //param.setWhereClauseParameter( 2, ORD_LN );
            //param.setAuditAttributes( audit );
            
            //if (ORD_KND.equals(ORD_KND_ZRE1)) //주문유형추가(반품주문인 경우 무조건 에러에도 자동설계)
            if (ORD_NO.substring(0,1).equals("R"))
            {
                param.setWhereClauseParameter( 0, ORD_NO );
                param.setWhereClauseParameter( 1, ORD_LN );
                param.setAuditAttributes( audit );
                
            	try
                {
                    dao.update( UPDATE_STS_ATU, param );
                } catch ( Exception e )
                {
                    logger.logError( e.getMessage() );
                    return false;
                }
            }
            else 
            {
            	param.setWhereClauseParameter( 0, QLT_DSN_STS_CD_E );
                param.setWhereClauseParameter( 1, ORD_NO );
                param.setWhereClauseParameter( 2, ORD_LN );
                param.setAuditAttributes( audit );
                
            	try
	            {
	                dao.update( UPDATE_STS, param );
	            } catch ( Exception e )
	            {
	                logger.logError( e.getMessage() );
	                return false;
	            }
            }
        } 
        else
        {            
        	//자동설계조건 추가(Start...)
            logger.logDebug( "=== ORD AUTO DECISION ====" );
            logger.logDebug( "ORD_DSN_CFM_TP : " + ORD_DSN_CFM_TP );
            
			//if ( QLT_DSN_CFM_TP.equals( QLT_DSN_CFM_TP_A ) )  //수정전 
            /* 2013.0628 정보기획팀 요청으로 품질설계 자동확정대상 조건 제외
            if ( QLT_DSN_CFM_TP.equals( QLT_DSN_CFM_TP_A ) && ORD_DSN_CFM_TP.equals( ORD_DSN_CFM_TP_A) )  //OMS자동설계조건 추가(A,M)
            {                            	
            	try
            	{
	            	//자동설계조건 추가(Start...)
	                logger.logDebug( "=== QLT AUTO DECISION ===" );
	                logger.logDebug( "ord_rgs_prs_id : " + ord_rgs_prs_id );
	                
	                colValue = new String[1];  //추가
	                colValue[0] = ord_rgs_prs_id; //추가
	                			
	                checker = EasyAccess.getPosDecisionChecker( C10B2270, null ); //추가
	                result = null; //추가
	                
	               	result = checker.getPosRule( colValue );
                
                } catch ( MasterDataException e ) {
                	result = null;
                	//logger.logError( e.getMessage() );
                }
                
            	if ( result == null )
                {
            		QLT_DSN_CFM_TP = QLT_DSN_STS_CD_B;
                }
            	else
            	{
            		try //칸변경
	                {
	                    colValue = new String[5];
	                    colValue[0] = prd_nm_cd;
	                    colValue[1] = ord_usg_cd;
	                    colValue[2] = fnl_cus_cd;
	                    colValue[3] = ord_ln_wgt;
	                    colValue[4] = ord_spc_txt;
	        
	                    checker = EasyAccess.getPosDecisionChecker( C10B2250, null );
	                    result = null;
	                    
	                    result = checker.getPosRule( colValue );
	                    
	                    QLT_DSN_CFM_TP = QLT_DSN_STS_CD_B;
	
	                } catch ( MasterDataException e )
	                {
	                    logger.logError( e.getMessage() );
	                } //칸변경완료!!
	            }
            }
            */
            //2013.0628 품질설계 수동확정 대상만 적용-정보기획팀요청
            if ( QLT_DSN_CFM_TP.equals( QLT_DSN_CFM_TP_A ) && ORD_DSN_CFM_TP.equals( ORD_DSN_CFM_TP_A) )  //OMS자동설계조건 추가(A,M)
            {
            	try
                {
                    colValue = new String[5];
                    colValue[0] = prd_nm_cd;
                    colValue[1] = ord_usg_cd;
                    colValue[2] = fnl_cus_cd;
                    colValue[3] = ord_ln_wgt;
                    colValue[4] = ord_spc_txt;
        
                    checker = EasyAccess.getPosDecisionChecker( C10B2250, null );
                    result = null;
                    
                    result = checker.getPosRule( colValue );
                    
                    QLT_DSN_CFM_TP = QLT_DSN_STS_CD_B;

                } catch ( MasterDataException e )
                {
                    logger.logError( e.getMessage() );
                }
            }
            
            if ( QLT_DSN_CFM_TP.equals( QLT_DSN_CFM_TP_A ) && !ORD_DSN_CFM_TP.equals( ORD_DSN_CFM_TP_A) )  //OMS수동, 나머지 자동이라도 수동으로 처리
            {
            	ctx.put( COL_QLT_DSN_STS_CD, QLT_DSN_STS_CD_B );
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, QLT_DSN_STS_CD_B );
                param.setWhereClauseParameter( 1, ORD_NO );
                param.setWhereClauseParameter( 2, ORD_LN );
                param.setAuditAttributes( audit );

                QLT_DSN_CFM_TP = QLT_DSN_STS_CD_B;
                //chk_tmp = "A";
            }
            
            if ( !QLT_DSN_CFM_TP.equals( QLT_DSN_CFM_TP_A ) )
            {
                ctx.put( COL_QLT_DSN_STS_CD, QLT_DSN_STS_CD_B );
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, QLT_DSN_STS_CD_B );
                param.setWhereClauseParameter( 1, ORD_NO );
                param.setWhereClauseParameter( 2, ORD_LN );
                param.setAuditAttributes( audit );
                
                //2020.03.03 고객사양 (재질)추가
                param1 = new PosParameter(); // MD View param
                param1.setWhereClauseParameter( 0, ORD_NO );
                param1.setWhereClauseParameter( 1, ORD_LN );
                param1.setAuditAttributes( audit );
                
                try
                {
                    dao.update( UPDATE_STS, param );
                    //2020.03.03 고객사양 (재질)추가
                    if(cus_bth_pap_no.isEmpty())
                    {
                    }
                    else{
                    	dao.update( UPDATE_MQL, param1 );
                    }
                } catch ( Exception e )
                {
                    logger.logError( e.getMessage() );
                    return false;
                }

                if(att_ord_yn.equals( C10STR_YES ) )
                {
                	
                	param = new PosParameter(); // MD View param
                    param.setValueParamter( 0, ORD_NO );
                    param.setValueParamter( 1, ORD_LN );
                    param.setAuditAttributes( audit );

                    try
                    {
                        dao.insert( INSERT_ATT_ORD_SMS, param ); // 관심주문등록
                    } catch ( Exception e )
                    {
                        logger.logError( e.getMessage() );
                        return false;
                    }
                }
            }
            else
            {               
                ctx.put( COL_QLT_DSN_STS_CD, QLT_DSN_STS_CD_A );
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, ORD_NO );
                param.setWhereClauseParameter( 1, ORD_LN );
                param.setAuditAttributes( audit );
                
                //2020.03.03 고객사양 (재질)추가
                param2 = new PosParameter(); // MD View param
                param2.setWhereClauseParameter( 0, ORD_NO );
                param2.setWhereClauseParameter( 1, ORD_LN );
                param2.setAuditAttributes( audit );

                try
                {
                    dao.update( UPDATE_STS_ATU, param );
                    if(cus_bth_pap_no.isEmpty())
                    {
                    }
                    else{
                    	dao.update( UPDATE_MQL, param2 );
                    }
                    
                } catch ( Exception e )
                {
                    logger.logError( e.getMessage() );
                    return false;
                }
            }
            
            //예외주문 - 반품주문인 경우 무조건 자동설계
            if (ORD_NO.substring(0,1).equals("R"))
            {
            	ctx.put( COL_QLT_DSN_STS_CD, QLT_DSN_STS_CD_A );
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, ORD_NO );
                param.setWhereClauseParameter( 1, ORD_LN );
                param.setAuditAttributes( audit );

                try
                {
                    dao.update( UPDATE_STS_ATU, param );
                } catch ( Exception e )
                {
                    logger.logError( e.getMessage() );
                    return false;
                }
            }
            
            //(광신스틸 임가공 주문인 경우 무조건 자동설계)
            if (poc_auto_yn.equals("Y"))
            {
            	ctx.put( COL_QLT_DSN_STS_CD, QLT_DSN_STS_CD_A );
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, ORD_NO );
                param.setWhereClauseParameter( 1, ORD_LN );
                param.setAuditAttributes( audit );
                
                param3 = new PosParameter(); // MD View param
                param3.setWhereClauseParameter( 0, ORD_NO );
                param3.setWhereClauseParameter( 1, ORD_LN );
                param3.setAuditAttributes( audit );

                try
                {
                    dao.update( UPDATE_STS_ATU, param );
                    if(cus_bth_pap_no.isEmpty())
                    {
                    }
                    else{
                    	dao.update( UPDATE_MQL, param3 );
                    }
                } catch ( Exception e )
                {
                    logger.logError( e.getMessage() );
                    return false;
                }
            }
            
        }
        
        return true;
    }

    public String chkMinMax( ArrayList<String[]> ROW, String ERRCODE )
    {
        String[] VALUE = null;
        String DATA = C10STR_SPACE;

        for ( int CNT = 0; CNT < ROW.size(); CNT++ )
        {
            VALUE = ROW.get( CNT );

            if ( !VALUE[0].equals( C10STR_SPACE ) && !VALUE[1].equals( C10STR_SPACE ) )
            {
                if ( VALUE[3].equals( C10STR_TRUE ) )
                    DATA = DbCommonUtil.numCompare( VALUE[0], VALUE[1], true );
                else
                    DATA = DbCommonUtil.numCompare( VALUE[0], VALUE[1], false );
                if ( !VALUE[1].equals( DATA ) )
                    ERRCODE = SetErrorcode( ERRCODE, VALUE[2] );
            }

        }

        return ERRCODE;
    }

    public String chkNull( ArrayList<String[]> ROW, String ERRCODE )
    {
        String[] VALUE = null;

        for ( int CNT = 0; CNT < ROW.size(); CNT++ )
        {
            VALUE = ROW.get( CNT );

            if ( VALUE[0].equals( C10STR_SPACE ) )
            {
                ERRCODE = SetErrorcode( ERRCODE, VALUE[1] );
            }

        }

        return ERRCODE;
    }    
    
}
