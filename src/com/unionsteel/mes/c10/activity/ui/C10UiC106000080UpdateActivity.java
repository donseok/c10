/**
 * =========================================================================
 * 
 * @LastModifyDate : 2024. 12. 23
 * @LastModifier : SJS
 * @LastVersion : 1.0
 * @fileName : C10UiC106000020InsertActivity.java
 *           설명
 *           - 품질설계 프린트롤관리 - 롤코드 보유라인 변경 시 사용정보 업데이트
 *           사용방법
 *           2024. 12. 23 SJS 1.0 최초 생성
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
 * @author SJS
 * @see DhtmlxActivity
 * @version : 1.0
 *          설명
 *          - Activity
 *          사용방법
 *          -
 *          2024. 12. 23 SJS 1.0 최초 생성
 *          ===========================================================================
 */
public class C10UiC106000080UpdateActivity extends C10DhtmlxActivity
{

    /**
     * =========================================================================
     * 설명
     * - 롤코드 보유라인 변경 시 사용정보 업데이트
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
    		
    		PosGenericDao dao 	= this.getDao(C10ConstantsIF.MESDAO);
            String 			ids[] 	= (String[])ctx.get(C10ConstantsIF.IDS); 
			String[] idsValue = ids[0].split(C10ConstantsIF.COMMA);	         
			PosParameter param = new PosParameter();//param정보
			int dml_cnt = 0;
    			
			String[] OLD_PROC_CD 		= null;
			String[] PROC_CD 			= null;
			String[] ROLL_CD 			= null;
			String[] ROLL_USE_STR_DD 	= null;
			String[] ROLL_USE_END_DD	= null;
			
		    
			OLD_PROC_CD 			= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("OLD_PROC_CD"));			
			PROC_CD 				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("PROC_CD"));
			ROLL_CD 				= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("ROLL_CD"));
			ROLL_USE_STR_DD 		= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("ROLL_USE_STR_DD"));
			ROLL_USE_END_DD			= (String[]) ctx.get(idsValue[0].concat(C10ConstantsIF.UNDERBAR).concat("ROLL_USE_END_DD"));
			
			logger.logDebug("########### OLD_PROC_CD ########### " + OLD_PROC_CD[0] );
			logger.logDebug("########### PROC_CD ########### " + PROC_CD[0] );
			logger.logDebug("########### ROLL_CD ########### " + ROLL_CD[0] );
			logger.logDebug("########### ROLL_USE_STR_DD ########### " + ROLL_USE_STR_DD[0] );
			logger.logDebug("########### ROLL_USE_END_DD ########### " + ROLL_USE_END_DD[0] );
			
			param.setNamedParamter("OLD_PROC_CD", OLD_PROC_CD);
			param.setNamedParamter("PROC_CD", PROC_CD);
			param.setNamedParamter("ROLL_CD", ROLL_CD);
			param.setNamedParamter("ROLL_USE_STR_DD", ROLL_USE_STR_DD);
			param.setNamedParamter("ROLL_USE_END_DD", ROLL_USE_END_DD);
	        param.setNamedParamter("ObjectType"	, ctx.get(C10ConstantsIF.OBJECT_TYPE));
			param.setNamedParamter("ObjectId"	, ctx.get(C10ConstantsIF.OBJECT_ID));
			param.setNamedParamter("ProgramId"	, ctx.get(C10ConstantsIF.PROGRAM_ID));
			param.setNamedParamter("Timestamp"	, ctx.get(C10ConstantsIF.TIMESTAMP));								
		
			if(!OLD_PROC_CD.equals("")){
				dao.update("C106000080_PTN_ROLL_USE_INF.update", param);						
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
