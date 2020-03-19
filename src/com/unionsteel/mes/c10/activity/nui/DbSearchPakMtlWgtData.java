/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchPakMtlWgtData.java
 * Change history
 * @LastModifyDate : 2012. 01. 11
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 01. 11 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 포장재중량을 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 포장재중량
 * - Master Table Code: 포장재중량 기준 Coil(C10B1081), 포장재중량 기준 Sheet(C10B1082)
 * . Key:
 * - Coil : 포장방법, 두께, 폭, 포장단중
 * - Sheet : 포장방법, 폭, 길이, 포장단중
 * 2. PosContext에 편집
 * 3. 편성한 결과는 PosContext에 등록
 * 4. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchPakMtlWgtData">
 * <transition name="success" value="C103100050-service" />
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

public class DbSearchPakMtlWgtData extends PosActivity implements C10NuiConstantsIF
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
        String colValue[] = null; // 컬럼값
        String prd_shp = C10STR_SPACE;
        // Parameter Error Check True=Null, FALE=NotNull
        if ( DbCommonUtil.isNull( ctx.get( COL_ORD_PAK_MTH ) ) || 
                DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) || 
                DbCommonUtil.isNull( ctx.get( COL_PRD_SHP ) ) || 
                DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) || 
                DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) || 
                DbCommonUtil.isNull( ctx.get( COL_PAK_UNT_WGT ) ) )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R01 );
            return PosBizControlConstants.FAILURE;
        }

        prd_shp = (String) ctx.get( COL_PRD_SHP );

        if ( prd_shp.equals( PRD_SHP_COIL ) )
        {
            // 포장재중량-코일 Master조회
            colValue = new String[4];
            colValue[0] = (String) ctx.get( COL_ORD_PAK_MTH ); // 포장방법
            colValue[1] = (String) ctx.get( COL_ORD_EXC_THK ); // 주문두께
            colValue[2] = (String) ctx.get( COL_ORD_EXC_WTH ); // 주문폭
            colValue[3] = (String) ctx.get( COL_PAK_UNT_WGT ); // 포장단중

            PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B1081, null );
            PosRuleVO result1 = null;
            try
            {
                // 결과값 잘 가져오는지 확인
                result1 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result1 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK45 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result1.getRecordCount() == 1 )
            {
                ctx.put( COL_ORD_PAK_MTL_WGT, result1.getRuleValueAt( COL_ORD_PAK_MTL_WGT ) );
                logger.logDebug( COL_ORD_PAK_MTL_WGT + C10STR_COLON + result1.getRuleValueAt( COL_ORD_PAK_MTL_WGT ) );
            } else if ( result1.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK46 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R92 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK45 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R93 );
                return PosBizControlConstants.FALSE;
            }
        } else if ( prd_shp.equals( PRD_SHP_SHEET ) )
        {
            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_LTH ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }

            // 포장재중량-쉬트 Master조회
            colValue = new String[4];
            colValue[0] = (String) ctx.get( COL_ORD_PAK_MTH ); // 포장방법
            colValue[1] = (String) ctx.get( COL_ORD_EXC_WTH ); // 주문폭
            colValue[2] = (String) ctx.get( COL_ORD_EXC_LTH ); // 주문길이
            colValue[3] = (String) ctx.get( COL_PAK_UNT_WGT ); // 포장단중

            PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B1082, null );
            PosRuleVO result2 = null;
            try
            {
                // 결과값 잘 가져오는지 확인
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK47 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result2.getRecordCount() == 1 )
            {
                ctx.put( COL_ORD_PAK_MTL_WGT, result2.getRuleValueAt( COL_ORD_PAK_MTL_WGT ) );
                logger.logDebug( COL_ORD_PAK_MTL_WGT + C10STR_COLON + result2.getRuleValueAt( COL_ORD_PAK_MTL_WGT ) );
            } else if ( result2.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK48 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R92 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK47 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R92 );
                return PosBizControlConstants.FAILURE;
            }
        }

        return PosBizControlConstants.SUCCESS;
    }
}
