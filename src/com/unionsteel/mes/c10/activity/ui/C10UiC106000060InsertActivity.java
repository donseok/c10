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
import com.posdata.glue.dao.vo.PosRow;
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
 *          2019. 01. 23 JKJ 1.0 최초 생성
 *          ===========================================================================
 */
public class C10UiC106000060InsertActivity extends C10DhtmlxActivity
{

    /**
     * =========================================================================
     * 설명
     * - 품질 설계 값 CTX로 이동
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
    		
    		PosRow jRow    = getIndexPosRow(ctx, "RK_C10A2200", 0);
    		
    		logger.logInfo("== 1 " + jRow);
    		
    		String mainEmpCd = ""; 
    		String subEmpCd1 = "";
    		String subEmpCd2 = "";
    		
    		if (jRow != null) {    		
    	     mainEmpCd       = (String)jRow.getAttribute("MAIN_EMP_CD");
             subEmpCd1       = (String)jRow.getAttribute("SUB_EMP_CD1");
             subEmpCd2       = (String)jRow.getAttribute("SUB_EMP_CD2");
    		}
    		
            logger.logDebug( "정:" +mainEmpCd +", 부1:" + subEmpCd1  +", 부2:" + subEmpCd2 );
            
            ctx.put("MAIN_EMP_CD", mainEmpCd);
            ctx.put("SUB_EMP_CD1", subEmpCd1);
            ctx.put("SUB_EMP_CD2", subEmpCd2);
    	
            return PosBizControlConstants.SUCCESS;  

        } catch ( Exception e )
        {
            // ctx.put( "errMsg", COIL_ID[idx].toString() + "는 이미 존재합니다." );
            // this.rollbackTransaction( "tx1" );
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
