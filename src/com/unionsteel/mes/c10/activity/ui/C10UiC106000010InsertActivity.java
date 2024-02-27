/**
 * =========================================================================
 * 
 * @LastModifyDate : 2012. 02. 02
 * @LastModifier : 이민균
 * @LastVersion : 1.0
 * @fileName : C10UiC106000020InsertActivity.java
 *           설명
 *           - 품질설계 시물레이션 저장
 *           사용방법
 *           - excell로 import된 데이타를 TB_C10_QLT_DSN_SML 테이블에 저장
 *           2012. 02. 02 이민균 1.0 최초 생성
 *           ===========================================================================
 */
package com.unionsteel.mes.c10.activity.ui;

import com.poscoict.glue.biz.dhtmlx.DhtmlxActivity;
import com.posdata.glue.PosException;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;
import com.unionsteel.mes.c10.activity.common.C10DhtmlxActivity;

/**
 * =========================================================================
 * 
 * @author 이민균
 * @see DhtmlxActivity
 * @version : 1.0
 *          설명
 *          - Activity
 *          사용방법
 *          -
 *          2024. 02. 26 SJS 1.0 최초 생성
 *          ===========================================================================
 */
public class C10UiC106000010InsertActivity extends C10DhtmlxActivity
{

    /**
     * =========================================================================
     * 설명
     * - 칼라코드관리 도료사 권한자 저장시 영업정보에 등록된 번호로 SMS 송신
     * 사용방법
     * -
     * 
     * @throws :
     * @param ctx PosContext
     * @return : success - 성공적으로 끝났을 때 Route transition.
     *         : faillue - 그 외 Exception 발생 시 Route transition.
     *         ===========================================================================
     */
    @Override
    public String doMainActivity( PosContext ctx )
    {
    	try{
    		
    		PosGenericDao dao 	= this.getDao(C10ConstantsIF.EAIDAO);
            String 			ids[] 	= (String[])ctx.get(C10ConstantsIF.IDS); 
			String[] idsValue = ids[0].split(C10ConstantsIF.COMMA);	         
			PosParameter param = new PosParameter();//param정보
			int dml_cnt = 0;
    			
			String[] CUS_CD_TXT 			= null;
			String[] SMS_RCV_HP1 			= null;
			String[] SMS_RCV_HP2 			= null;
			String[] SMS_RCV_HP3 			= null;
			String[] SMS_RCV_HP4 			= null;
			String[] CUS_REQ_HUE_TXT		= null;
			String[] RSN_TP_TXT				= null;
			String[] SMPL_DLV_CMP_CD		= null;
			String[] IVC_NO					= null;
			
		    
			CUS_CD_TXT 					= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("CUS_CD_TXT"));			
			SMS_RCV_HP1 				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("SMS_RCV_HP1"));
			SMS_RCV_HP2 				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("SMS_RCV_HP2"));
			SMS_RCV_HP3 				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("SMS_RCV_HP3"));
			SMS_RCV_HP4 				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("SMS_RCV_HP4"));
			CUS_REQ_HUE_TXT				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("CUS_REQ_HUE_TXT"));
			RSN_TP_TXT					= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("RSN_TP_TXT"));
			SMPL_DLV_CMP_CD				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("SMPL_DLV_CMP_CD"));
			IVC_NO						= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("IVC_NO"));
			
			logger.logDebug("########### CUS_CD_TXT ########### " + CUS_CD_TXT[0] );
			logger.logDebug("########### SMS_RCV_HP1 ########### " + SMS_RCV_HP1[0] );
			logger.logDebug("########### SMS_RCV_HP2 ########### " + SMS_RCV_HP2[0] );
			logger.logDebug("########### SMS_RCV_HP3 ########### " + SMS_RCV_HP3[0] );
			logger.logDebug("########### SMS_RCV_HP4 ########### " + SMS_RCV_HP4[0] );
			logger.logDebug("########### CUS_REQ_HUE_TXT ########### " + CUS_REQ_HUE_TXT[0] );
			logger.logDebug("########### RSN_TP_TXT ########### " + RSN_TP_TXT[0] );
			logger.logDebug("########### SMPL_DLV_CMP_CD ########### " + SMPL_DLV_CMP_CD[0] );
			logger.logDebug("########### IVC_NO ########### " + IVC_NO[0] );
			
			param.setNamedParamter("CUS_CD_TXT", CUS_CD_TXT);
			param.setNamedParamter("SMS_RCV_HP1", SMS_RCV_HP1);
			param.setNamedParamter("SMS_RCV_HP2", SMS_RCV_HP2);
			param.setNamedParamter("SMS_RCV_HP3", SMS_RCV_HP3);
			param.setNamedParamter("SMS_RCV_HP4", SMS_RCV_HP4);
			param.setNamedParamter("CUS_REQ_HUE_TXT", CUS_REQ_HUE_TXT);
			param.setNamedParamter("RSN_TP_TXT", RSN_TP_TXT);
			param.setNamedParamter("SMPL_DLV_CMP_CD", SMPL_DLV_CMP_CD);
			param.setNamedParamter("IVC_NO", IVC_NO);
	        param.setNamedParamter("ObjectType"	, ctx.get(C10ConstantsIF.OBJECT_TYPE));
			param.setNamedParamter("ObjectId"	, ctx.get(C10ConstantsIF.OBJECT_ID));
			param.setNamedParamter("ProgramId"	, ctx.get(C10ConstantsIF.PROGRAM_ID));
			param.setNamedParamter("Timestamp"	, ctx.get(C10ConstantsIF.TIMESTAMP));								
		
			if(SMS_RCV_HP1[0] != null && SMS_RCV_HP1[0].length() == 11){
	            dml_cnt = dao.insert("C106000010pop01.sms_insert1", param);
			}
			
			if(SMS_RCV_HP2[0] != null && SMS_RCV_HP2[0].length() == 11){
	            dml_cnt = dao.insert("C106000010pop01.sms_insert2", param);
			}
			
			if(SMS_RCV_HP3[0] != null && SMS_RCV_HP3[0].length() == 11){
	            dml_cnt = dao.insert("C106000010pop01.sms_insert3", param);
			}			
			
			if(SMS_RCV_HP4[0] != null && SMS_RCV_HP4[0].length() == 11){
	            dml_cnt = dao.insert("C106000010pop01.sms_insert4", param);
			}
						
    	
            return PosBizControlConstants.SUCCESS;  

        } catch ( Exception e )
        {

            System.out.println( e.getMessage() );
            logger.logDebug( e.getMessage() );
            throw new PosException( e.getMessage() + "데이타 오류입니다." );
        } 	

    }

    /**
     * =========================================================================
     * 설명
     * - doPostActivity
     * 사용방법
     * -
     * 
     * @throws :
     * @param arg0 PosContext
     * @return : success - 성공적으로 끝났을 때 Route transition.
     *         : nullpointer - NullPointerException 발생 시 Route transtion.
     *         : faillue - 그 외 Exception 발생 시 Route transition.
     *         ===========================================================================
     */
    @Override
    public String doPostActivity( PosContext arg0 )
    {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * =========================================================================
     * 설명
     * - doPreActivity
     * 사용방법
     * -
     * 
     * @throws :
     * @param arg0 PosContext
     * @return : success - 성공적으로 끝났을 때 Route transition.
     *         : nullpointer - NullPointerException 발생 시 Route transtion.
     *         : faillue - 그 외 Exception 발생 시 Route transition.
     *         ===========================================================================
     */
    @Override
    public String doPreActivity( PosContext arg0 )
    {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * =========================================================================
     * 설명
     * - Activity
     * 사용방법
     * -
     * 
     * @throws :
     * @return : success - 성공적으로 끝났을 때 Route transition.
     *         : nullpointer - NullPointerException 발생 시 Route transtion.
     *         : faillue - 그 외 Exception 발생 시 Route transition.
     *         ===========================================================================
     */
    @Override
    public String getDefaultMsgCode()
    {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * =========================================================================
     * 설명
     * - Activity
     * 사용방법
     * -
     * 
     * @throws :
     * @return : success - 성공적으로 끝났을 때 Route transition.
     *         : nullpointer - NullPointerException 발생 시 Route transtion.
     *         : faillue - 그 외 Exception 발생 시 Route transition.
     *         ===========================================================================
     */
    @Override
    public String[] getDefaultMsgParam( PosContext arg0 )
    {
        // TODO Auto-generated method stub
        return null;
    }
}
