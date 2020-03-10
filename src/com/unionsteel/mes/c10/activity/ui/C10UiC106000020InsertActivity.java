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
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;

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
 *          2012. 02. 02 이민균 1.0 최초 생성
 *          ===========================================================================
 */
public class C10UiC106000020InsertActivity extends DhtmlxActivity
{

    /**
     * =========================================================================
     * 설명
     * - 품질설계 시물레이션 저장
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
        //PosGenericDao mesdao = this.getDao( C10ConstantsIF.MESDAO );//
        PosGenericDao dao = this.getDao( C10ConstantsIF.MESDAO );
        PosParameter param = new PosParameter();
        param = new PosParameter();
        String[] COIL_ID = null;
        String[] PRD_NM_CD = null;
        String[] SPC_AVR = null;
        String[] ORD_USG_CD = null;
        String[] RMTL_CD = null;
        String[] MQL_CD = null;
        String[] SP_ASG_YN = null;
        String[] COIL_THK = null;
        String[] COIL_WTH = null;
        String[] COIL_WGT = null;
        String[] PDN_DH = null;
        String[] PROC_CD = null;
        String[] RMTL_MAK_FAC_CD = null;
        String[] MQL_ACT_YP_MPA = null;
        String[] MQL_ACT_TS_MPA = null;
        String[] MQL_ACT_EL = null;
        String[] MQL_ACT_HRB_AVG = null;
        String[] MQL_ACT_ERI_AVG = null;
        int idx = 0;
        try
        {
            String[] ids = (String[]) ctx.get( C10ConstantsIF.IDS );

            if ( ids == null || ids.length < 1 )
                throw new PosException( "IDS가 존재하지 않습니다." );
            // return PosBizControlConstants.SUCCESS;

            String[] idsValue = ids[0].split( C10ConstantsIF.COMMA );

            for ( int i = 0, n = idsValue.length; i < n; i++ )
            {
            	
                COIL_ID = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.COIL_ID );
                PRD_NM_CD = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.PRD_NM_CD );
                SPC_AVR = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.SPC_AVR );
                ORD_USG_CD = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.ORD_USG_CD );
                RMTL_CD = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.RMTL_CD );
                MQL_CD = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.MQL_CD );
                SP_ASG_YN = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.SP_ASG_YN );
                COIL_THK = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.COIL_THK );
                COIL_WTH = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.COIL_WTH );
                COIL_WGT = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.COIL_WGT );
                PDN_DH = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.PDN_DH );
                PROC_CD = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.PROC_CD );
                RMTL_MAK_FAC_CD = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.RMTL_MAK_FAC_CD );
                MQL_ACT_YP_MPA = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.MQL_ACT_YP_MPA );
                MQL_ACT_TS_MPA = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.MQL_ACT_TS_MPA );
                MQL_ACT_EL = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.MQL_ACT_EL );
                MQL_ACT_HRB_AVG = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.MQL_ACT_HRB_AVG );
                MQL_ACT_ERI_AVG = (String[]) ctx.get( idsValue[i] + C10ConstantsIF.UNDERBAR + C10ConstantsIF.MQL_ACT_ERI_AVG );

                
                
                param = new PosParameter();
                param.setNamedParamter( "COIL_ID", COIL_ID );
                PosRowSet rowset = null;                
                rowset = dao.find( "C106000020.coilIdSelect", param );
                logger.logDebug( C10ConstantsIF.SELECT_COUNT + rowset.count() );
                if ( rowset == null || rowset.count() <= 0 )
                {
                	param = new PosParameter();
	                param.setNamedParamter( "COIL_ID", COIL_ID );
	                param.setNamedParamter( "PRD_NM_CD", PRD_NM_CD );
	                param.setNamedParamter( "SPC_AVR", SPC_AVR );
	                param.setNamedParamter( "ORD_USG_CD", ORD_USG_CD );
	                param.setNamedParamter( "RMTL_CD", RMTL_CD );
	                param.setNamedParamter( "MQL_CD", MQL_CD );
	                param.setNamedParamter( "SP_ASG_YN", SP_ASG_YN );
	                param.setNamedParamter( "COIL_THK", COIL_THK );
	                param.setNamedParamter( "COIL_WTH", COIL_WTH );
	                param.setNamedParamter( "COIL_WGT", COIL_WGT );
	                param.setNamedParamter( "PDN_DH", PDN_DH );
	                param.setNamedParamter( "PROC_CD", PROC_CD );
	                param.setNamedParamter( "RMTL_MAK_FAC_CD", RMTL_MAK_FAC_CD );
	                param.setNamedParamter( "MQL_ACT_YP_MPA", MQL_ACT_YP_MPA );
	                param.setNamedParamter( "MQL_ACT_TS_MPA", MQL_ACT_TS_MPA );
	                param.setNamedParamter( "MQL_ACT_EL", MQL_ACT_EL );
	                param.setNamedParamter( "MQL_ACT_HRB_AVG", MQL_ACT_HRB_AVG );
	                param.setNamedParamter( "MQL_ACT_ERI_AVG", MQL_ACT_ERI_AVG );
	
	                dao.insert( "C106000020.insert", param );
	                idx++;
                }
            }                
            return PosBizControlConstants.SUCCESS;

        } catch ( Exception e )
        {
            // ctx.put( "errMsg", COIL_ID[idx].toString() + "는 이미 존재합니다." );
            // this.rollbackTransaction( "tx1" );
            System.out.println( e.getMessage() );
            logger.logDebug( e.getMessage() );
            throw new PosException( COIL_ID[idx].toString() + "데이타 오류입니다." );
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
