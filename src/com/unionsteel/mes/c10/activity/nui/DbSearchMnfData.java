/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchRsnRouData.java
 * Change history
 * @LastModifyDate : 2012. 01. 11
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 01. 11 박재영 최초 생성
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
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 제조표준를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보:ECL C-D 방지 약품 (CR,EG,CR칼라,EG칼라 제품군만)
 * - Master Data 정의명 : C10B2130
 * - ECL C-D 방지 약품 기준 Data 조건항목 : 주문두께
 * -> Read Count = 1 이면 ECL C-D 방지 약품 기준 Data의 ECLC-D방지약품을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 ECL C-D 방지 약품 기준 에러처리한다.
 * 2. 편성정보:ECL 권취장력 Set기준 (CR,EG,CR칼라,EG칼라 제품군만)
 * - Master Data 정의명 : C10B2210
 * - ECL 권취장력 Set 기준 Data 조건항목 : 품명
 * -> Read Count = 1 이면 ECL 권취장력 Set 기준 Data의 ECL권취장력을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 ECL 권취장력 Set 기준 에러처리한다.
 * 3. 편성정보:EGL표면처리코드
 *    - 주문표면처리코드로 EGL표면처리코드를 편성한다.
 * 4. 편성정보:CGL Leveler Set기준 (용융도금 또는 용융도금칼라 제품군만)
 * - Master Data 정의명 : C10B2150
 * - CGL Leveler Set기준 Data 조건항목 : 품명
 * -> Read Count = 1 이면 CGL Leveler Set기준 Data의 CGLLeveler사용여부를 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CGL Leveler Set기준 에러처리한다.
 * 5. 편성정보:CGL표면처리코드
 *    - 주문표면처리코드로 CGL표면처리코드를 편성한다.
 * 6. 편성정보:CGLSkinPass 여부
 *    - 주문Spangle구분이 '4','5'인 경우 CGLSkinPass 여부를 'Y'로 편성한다.(2014.11.25 우봉우대리 '5'인 경우 추가요청)
 *    - 주문Spangle구분이 '4','5'가 아닌 경우 CGLSkinPass 여부를 'N'로 편성한다.
 * 7. 편성정보:정전공정 방청류 Set기준 (CR,CR칼라 제품군만)
 * - Master Data 정의명 : C10B2170
 * - 정전공정 방청류 Set기준 Data 조건항목 : 품명, 주문표면처리코드, 제품형태
 * -> Read Count = 1 이면 정전공정 방청류 Set기준 Data의 도유코드를 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 정전공정 방청류 Set기준 에러처리한다.
 * 8. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 항목별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 9. 편성한 결과는 PosContext에 등록
 * 10. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchMnfData">
 * <transition name="success" value="C103100020-service" />
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

public class DbSearchMnfData extends PosActivity implements C10NuiConstantsIF
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

        String colValue[] = null; // 컬럼값

        PosDecisionChecker checker = null;
        PosRuleVO result = null;
        String rmtl_cd = C10STR_SPACE;
        String rmtl_cd1 = C10STR_SPACE;
        String rmtl_cd2 = C10STR_SPACE;
        String ord_exc_thk = C10STR_SPACE;

        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD ) ) )
            rmtl_cd = (String) ctx.get( COL_RMTL_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD1 ) ) )
            rmtl_cd1 = (String) ctx.get( COL_RMTL_CD1 );
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD2 ) ) )
            rmtl_cd2 = (String) ctx.get( COL_RMTL_CD2 );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = ctx.get( COL_ORD_EXC_THK ).toString();

        ArrayList<String> RMTL = new ArrayList<String>();
        ArrayList<String> CRM_MNF_STD = new ArrayList<String>();
        RMTL.add( rmtl_cd );
        CRM_MNF_STD.add( (String) ctx.get( COL_CRM_MNF_STD_NO ) );
        if ( !rmtl_cd1.equals( C10STR_SPACE ) )
        {
            RMTL.add( rmtl_cd1 );
            CRM_MNF_STD.add( (String) ctx.get( COL_CRM_MNF_STD_NO1 ) );
        }
        if ( !rmtl_cd2.equals( C10STR_SPACE ) )
        {
            RMTL.add( rmtl_cd2 );
            CRM_MNF_STD.add( (String) ctx.get( COL_CRM_MNF_STD_NO2 ) );
        }

        for ( int nidx = 0; nidx < RMTL.size(); nidx++ )
        {
            ctx.put( COL_QLT_DSN_MNF_TP, nidx + 1 );

            if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_C ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_1 ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) ||
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) ||
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_G ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_K ) ||
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_J ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_L ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_V ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_W ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 ) ||
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) || 
            	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ) )
            {

                if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_C ) || 
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) ||
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) ||
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_1 ) ||
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) ||
                	 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) )
                {
                    colValue = new String[1];
                    colValue[0] = ord_exc_thk; // 주문두께

                    checker = EasyAccess.getPosDecisionChecker( C10B2130, null );
                    result = null;
                    try
                    {
                        // 결과값 잘 가져오는지 확인
                        result = checker.getPosRule( colValue );
                    } catch ( MasterDataException e )
                    {
                        result = null;
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK58 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( e.getMessage() );
                        return PosBizControlConstants.FAILURE;
                    }

                    if ( result.getRecordCount() == 1 )
                    {
                        // ECL C-D 방지 약품
                        ctx.put( COL_ECL_CDR_CD, result.getRuleValueAt( COL_ECL_CDR_CD ) );
                        logger.logDebug( COL_ECL_CDR_CD + C10STR_COLON + result.getRuleValueAt( COL_ECL_CDR_CD ) );
                    } else if ( result.getRecordCount() > 1 )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK59 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R63 );
                        return PosBizControlConstants.FAILURE;
                    } else
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK58 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R62 );
                        return PosBizControlConstants.FAILURE;
                    }

                    colValue = new String[1];
                    colValue[0] = (String) ctx.get( COL_PRD_NM_CD ); // 품명코드

                    checker = EasyAccess.getPosDecisionChecker( C10B2140, null );
                    result = null;
                    try
                    {
                        // 결과값 잘 가져오는지 확인
                        result = checker.getPosRule( colValue );
                    } catch ( MasterDataException e )
                    {
                        result = null;
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK54 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( e.getMessage() );
                        return PosBizControlConstants.FAILURE;
                    }

                    if ( result.getRecordCount() == 1 )
                    {
                        // ECL 권취장력
                        ctx.put( COL_ECL_COILG_TS_CD, result.getRuleValueAt( COL_ECL_COILG_TS_CD ) );
                        logger.logDebug( COL_ECL_COILG_TS_CD + C10STR_COLON + result.getRuleValueAt( COL_ECL_COILG_TS_CD ) );
                    } else if ( result.getRecordCount() > 1 )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK55 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_K55 );
                        return PosBizControlConstants.FAILURE;
                    } else
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK54 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_K54 );
                        return PosBizControlConstants.FAILURE;
                    }

                    if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) ||  ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ))
                    {
                        ctx.put( COL_EGL_SUR_HND_CD, ctx.get( COL_ORD_SUR_HND_CD ) );
                        logger.logDebug( COL_EGL_SUR_HND_CD + C10STR_COLON + ctx.get( COL_ORD_SUR_HND_CD ) );
                    }
                }else{
                    colValue = new String[1];
                    colValue[0] = (String) ctx.get( COL_PRD_NM_CD ); // 품명코드

                    checker = EasyAccess.getPosDecisionChecker( C10B2150, null );
                    result = null;
                    try
                    {
                        // 결과값 잘 가져오는지 확인
                        result = checker.getPosRule( colValue );
                    } catch ( MasterDataException e )
                    {
                        result = null;
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK56 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( e.getMessage() );
                        return PosBizControlConstants.FAILURE;
                    }

                    if ( result.getRecordCount() == 1 )
                    {
                        // CGL Leveler
                        ctx.put( COL_CGL_LVL_YN, result.getRuleValueAt( COL_CGL_LVL_YN ) );
                        logger.logDebug( COL_CGL_LVL_YN + C10STR_COLON + result.getRuleValueAt( COL_CGL_LVL_YN ) );
                    } else if ( result.getRecordCount() > 1 )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK57 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_K57 );
                        return PosBizControlConstants.FAILURE;
                    } else
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK56 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_K56 );
                        return PosBizControlConstants.FAILURE;
                    }
                    ctx.put( COL_SPNL_TP, ctx.get( COL_ORD_SPNL_TP ) );
                    logger.logDebug( COL_SPNL_TP + C10STR_COLON + ctx.get( COL_ORD_SPNL_TP ) );
                    if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SPNL_TP ) ) && ctx.get( COL_ORD_SPNL_TP ).toString().equals( NUM4 ) )
                    {
                        ctx.put( COL_CGL_SP_ASG_YN, C10STR_YES );
                        logger.logDebug( COL_CGL_SP_ASG_YN + C10STR_COLON + ctx.get( COL_ORD_SP_ASG_YN ) );
                    } else if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SPNL_TP ) ) && ctx.get( COL_ORD_SPNL_TP ).toString().equals( NUM5 ) )
                    {
                        //2014.11.25일 우봉우대리 추가요청(spangle 5번인경우 스킨패스 여부 Y로 지정)
                    	ctx.put( COL_CGL_SP_ASG_YN, C10STR_YES );
                        logger.logDebug( COL_CGL_SP_ASG_YN + C10STR_COLON + ctx.get( COL_ORD_SP_ASG_YN ) );
                    } else if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SPNL_TP ) ) && ctx.get( COL_ORD_SPNL_TP ).toString().equals( NUM7 ) )
                    {
                        //2018.3.30일 전현진대리 추가요청(spangle 7번인경우 스킨패스 여부 Y로 지정)
                    	ctx.put( COL_CGL_SP_ASG_YN, C10STR_YES );
                        logger.logDebug( COL_CGL_SP_ASG_YN + C10STR_COLON + ctx.get( COL_ORD_SP_ASG_YN ) );
                    } else
                    {
                        ctx.put( COL_CGL_SP_ASG_YN, C10STR_NO );
                        logger.logDebug( COL_CGL_SP_ASG_YN + C10STR_COLON + ctx.get( COL_ORD_SP_ASG_YN ) );
                    }
                    ctx.put( COL_CGL_SUR_HND_CD, ctx.get( COL_ORD_SUR_HND_CD ) );
                    logger.logDebug( COL_CGL_SUR_HND_CD + C10STR_COLON + ctx.get( COL_ORD_SUR_HND_CD ) );
                }
            }

            if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_C ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_1 ) )
            {
                colValue = new String[3];
                colValue[0] = (String) ctx.get( COL_PRD_NM_CD ); // 품명코드
                colValue[1] = (String) ctx.get( COL_ORD_SUR_HND_CD ); // 주문표면처리코드
                colValue[2] = (String) ctx.get( COL_PRD_SHP ); // 제품형태

                checker = EasyAccess.getPosDecisionChecker( C10B2170, null );
                result = null;
                try
                {
                    // 결과값 잘 가져오는지 확인
                    result = checker.getPosRule( colValue );
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK68 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }

                if ( result.getRecordCount() == 1 )
                {
                    // 도유코드
                    ctx.put( COL_OIL_PNT_CD, result.getRuleValueAt( COL_OIL_PNT_CD ) );
                    logger.logDebug( COL_OIL_PNT_CD + C10STR_COLON + result.getRuleValueAt( COL_OIL_PNT_CD ) );
                } else if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK69 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R73 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK68 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R72 );
                    return PosBizControlConstants.FAILURE;
                }
            }

            PosAuditAttributes audit = ctx.getAuditAttribute();

            param = new PosParameter(); // MD View param
            param.setValueParamter( 0, ctx.get( COL_ORD_NO ) );
            param.setValueParamter( 1, ctx.get( COL_ORD_LN ) );
            param.setValueParamter( 2, ctx.get( COL_QLT_DSN_MNF_TP ) );
            param.setValueParamter( 3, RMTL.get( nidx ) );
            param.setValueParamter( 4, CRM_MNF_STD.get( nidx ) );
            param.setValueParamter( 5, ctx.get( COL_ECL_CDR_CD ) );
            param.setValueParamter( 6, ctx.get( COL_ECL_COILG_TS_CD ) );
            param.setValueParamter( 7, ctx.get( COL_CGL_LVL_YN ) );
            param.setValueParamter( 8, ctx.get( COL_SPNL_TP ) );
            param.setValueParamter( 9, ctx.get( COL_CGL_SP_ASG_YN ) );
            param.setValueParamter( 10, ctx.get( COL_CGL_SUR_HND_CD ) );
            param.setValueParamter( 11, ctx.get( COL_EGL_SUR_HND_CD ) );
            param.setValueParamter( 12, ctx.get( COL_OIL_PNT_CD ) );

            param.setAuditAttributes( audit );
            try
            {
                dao.insert( INSERT_MNF, param ); // 제조표준 생성
            } catch ( Exception e )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB06 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
        }

        return PosBizControlConstants.SUCCESS;
    }
}
