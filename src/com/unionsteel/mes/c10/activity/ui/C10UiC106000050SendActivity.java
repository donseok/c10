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
import com.posdata.glue.dao.vo.PosAuditAttributes;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;

/**
 * =========================================================================
 * 
 * @author : 이돈석
 * @see DhtmlxActivity
 * @version : 1.0
 *          설명
 *          - Activity
 *          사용방법
 *          -
 *          2012. 03. 20 이돈석 1.0 최초 생성
 * ===========================================================================
 */
public class C10UiC106000050SendActivity extends DhtmlxActivity
{

    /**
     * =========================================================================
     * 설명
     * - 칼라부자재 정보 및 도료사 정보 MM으로 전송(다건 전송)
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
        // mes,eai dao연결
    	PosGenericDao mesdao = this.getDao( C10ConstantsIF.MESDAO );
        PosGenericDao eaidao = this.getDao( C10ConstantsIF.EAIDAO );
        
        PosParameter param = new PosParameter();
        param = new PosParameter();
        

        String[] SUB_MTL_TP = null;
        String[] CLR_SUB_MTL_CD = null;
        
        String[] CLR_NM  = null;
        String PNT_CMP_CD = null;
        String PNT_CMP_NM = null;
        String USE_YN = null;
        String[] RSN_TP = null;
        String[] RSN_TP_NM = null;
        String[] LUS_RT_CD = null;
        String[] LUS_RT_NM = null;
        String[] PRT_INK_TP = null;
        String[] PRT_INK_TP_NM = null;
        String[] PTT_FLM_MQL_CD = null;
        String[] PTT_FLM_MQL_NM = null;
        String[] PTT_FLM_THK_CD = null;
        String[] PTT_FLM_THK_NM = null;
        String[] PTT_FLM_PRD_ADH_CD = null;
        String[] PTT_FLM_PRD_ADH_NM = null;
        String[] PTT_FLM_SUS_ADH_CD = null;
        String[] PTT_FLM_SUS_ADH_NM = null;
        
        String[] MOD_YN = null;
        
        int idx = 0;
        int nRELULT = 0;
		int dmlCnt = 0;
        
        try
        {
            String[] ids = (String[]) ctx.get( C10ConstantsIF.IDS );
            if ( ids == null || ids.length < 1 )
                throw new PosException( "IDS가 존재하지 않습니다." );
            // return PosBizControlConstants.SUCCESS;
            String[] idsValue = ids[0].split( C10ConstantsIF.COMMA );
            for ( int i = 0, n = idsValue.length; i < n; i++ )
            {
            	SUB_MTL_TP = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("SUB_MTL_TP"));
            	CLR_SUB_MTL_CD = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("CLR_SUB_MTL_CD"));
            	CLR_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("CLR_NM"));
            	RSN_TP = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("RSN_TP"));
            	RSN_TP_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("RSN_TP_NM"));
            	LUS_RT_CD = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("LUS_RT_CD"));
            	LUS_RT_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("LUS_RT_NM"));
            	PRT_INK_TP = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PRT_INK_TP"));
            	PRT_INK_TP_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PRT_INK_TP_NM"));
            	PTT_FLM_MQL_CD = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_MQL_CD"));
            	PTT_FLM_MQL_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_MQL_NM"));
            	PTT_FLM_THK_CD = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_THK_CD"));
            	PTT_FLM_THK_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_THK_NM"));
            	PTT_FLM_SUS_ADH_CD = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_SUS_ADH_CD"));
            	PTT_FLM_SUS_ADH_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_SUS_ADH_NM"));
            	PTT_FLM_PRD_ADH_CD = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_PRD_ADH_CD"));
            	PTT_FLM_PRD_ADH_NM = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PTT_FLM_PRD_ADH_NM"));
            	MOD_YN = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("MOD_YN"));
            	//PNT_CMP_USE_YN = (String[]) ctx.get(idsValue[i].concat(C10ConstantsIF.UNDERBAR).concat("PNT_CMP_USE_YN"));
           	   
    	
            	param = new PosParameter();
                param.setNamedParamter( "CLR_SUB_MTL_CD", CLR_SUB_MTL_CD );
                param.setWhereClauseParameter( 0, CLR_SUB_MTL_CD );

                // 전송일시 update처리
                logger.logDebug("전송일자Update처리 : " + CLR_SUB_MTL_CD[i]); 
                dmlCnt = mesdao.update(C10ConstantsIF.C106000050_erp_snd_update, param);
                
                param.setWhereClauseParameter( 0, CLR_SUB_MTL_CD );
                PosRowSet rowset = mesdao.find( C10ConstantsIF.C106000050_SELECT , param );
               
                logger.logDebug( C10ConstantsIF.SELECT_COUNT + rowset.count() );
                if ( rowset.count() == 0 )
                {
                    // error
                    logger.logError( C10ConstantsIF.C106000050_CHECK_ERR );
                     //throw new PosException( C10ConstantsIF.C104000050_CHECK_ERR );

                    ctx.put( C10ConstantsIF.ERRMSG, C10ConstantsIF.C106000050_CHECK_ERR );

                    return PosBizControlConstants.FAILURE;

                }

                for ( int j = 0, x = rowset.count(); j < x; j++ )
                {
                	
                    PosRow row = rowset.next();
                    //Child
                    USE_YN = DbCommonUtil.valueOf(row.getAttribute("USE_YN"));
                    PNT_CMP_CD = DbCommonUtil.valueOf(row.getAttribute("PNT_CMP_CD"));
                	PNT_CMP_NM = DbCommonUtil.valueOf(row.getAttribute("PNT_CMP_NM"));
                	

                    //Parent
                	PosAuditAttributes audit = ctx.getAuditAttribute();
                    param = new PosParameter();
                    param.setNamedParamter( C10ConstantsIF.COL_IF_GRP_ID, ctx.get( C10ConstantsIF.COL_IF_GRP_ID ) );
                    param.setNamedParamter( "SUB_MTL_TP", SUB_MTL_TP );
                    param.setNamedParamter( "CLR_SUB_MTL_CD", CLR_SUB_MTL_CD );
                	param.setNamedParamter( "CLR_NM", CLR_NM );
                	param.setNamedParamter( "USE_YN", USE_YN );
                	param.setNamedParamter( "PNT_CMP_CD", PNT_CMP_CD );
                	param.setNamedParamter( "PNT_CMP_NM", PNT_CMP_NM );
                	param.setNamedParamter( "RSN_TP", RSN_TP );
                	param.setNamedParamter( "RSN_TP_NM", RSN_TP_NM );
                	param.setNamedParamter( "LUS_RT_CD", LUS_RT_CD );
                	param.setNamedParamter( "LUS_RT_NM", LUS_RT_NM );
                	param.setNamedParamter( "PRT_INK_TP", PRT_INK_TP );
                	param.setNamedParamter( "PRT_INK_TP_NM", PRT_INK_TP_NM );
                	param.setNamedParamter( "PTT_FLM_MQL_CD", PTT_FLM_MQL_CD );
                	param.setNamedParamter( "PTT_FLM_MQL_NM", PTT_FLM_MQL_NM );
                	param.setNamedParamter( "PTT_FLM_THK_CD", PTT_FLM_THK_CD );
                	param.setNamedParamter( "PTT_FLM_THK_NM", PTT_FLM_THK_NM );
                	param.setNamedParamter( "PTT_FLM_SUS_ADH_CD", PTT_FLM_SUS_ADH_CD );
                	param.setNamedParamter( "PTT_FLM_SUS_ADH_NM", PTT_FLM_SUS_ADH_NM );
                	param.setNamedParamter( "PTT_FLM_PRD_ADH_CD", PTT_FLM_PRD_ADH_CD );
                	param.setNamedParamter( "PTT_FLM_PRD_ADH_NM", PTT_FLM_PRD_ADH_NM );
                	param.setNamedParamter( "MOD_YN", MOD_YN );
                	
                	// Audit 값이 안들어가서 임의로 추가해봄 
                	param.setNamedParamter("LAST_UPDATED_OBJECT_ID", audit.getObjectId());
                	param.setNamedParamter("LAST_UPDATE_PROGRAM_ID", audit.getProgramId());
                	param.setNamedParamter("LAST_UPDATED_OBJECT_TYPE", audit.getObjectType());
                	//Audit 값이 안들어가서 임의로 추가해봄
                	
                    param.setAuditAttributes( audit );  
                    
                	nRELULT = eaidao.insert( C10ConstantsIF.IFB10S0130_INSERT, param );
                    logger.logDebug( C10ConstantsIF.IFB10S0130_INSERT ); 
                }
                

            	
                if("M".equals(MOD_YN[i])){
                logger.logDebug("MOD_YN Update : " + CLR_SUB_MTL_CD[i]); 
                mesdao.update("C106000050.updateModYn", param);
                }
            }
            
	
            
            this.commitTransaction( C10ConstantsIF.TX1 );
            this.commitTransaction( C10ConstantsIF.TX2 );
            return PosBizControlConstants.SUCCESS;

        } catch ( Exception e )
        {
            // ctx.put( "errMsg", COIL_ID[idx].toString() + "는 이미 존재합니다." );
            // this.rollbackTransaction( "tx1" );
            System.out.println( e.getMessage() );
            logger.logDebug( e.getMessage() );
            throw new PosException( CLR_SUB_MTL_CD[idx].toString() + " :  처리중에 오류가 발생했습니다" );
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
     * @param arg0 PosContext
     * @return : success - 성공적으로 끝났을 때 Route transition.
     *         : nullpointer - NullPointerException 발생 시 Route transtion.
     *         : faillue - 그 외 Exception 발생 시 Route transition.
     *         ===========================================================================
     */
    public String[] getDefaultMsgParam( PosContext arg0 )
    {
        // TODO Auto-generated method stub
        return null;
    }
}

