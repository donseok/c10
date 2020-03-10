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
 * 이 class는 후처리/조도를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 수지부착량(하한,상한)
 * - Master Table Code: CGL 표면처리 유형 Set기준(C10B2160)
 * . Key: 품명코드, 주문표면처리코드
 * 2. 편성정보: Ra(하한,상한), PPI(하한,상한), Rmax하한값, 조도코드
 * - Master Table Code: 조도설계기준(Ra,PPI,Rmax)(C10B2210)
 * . Key: 품명코드, 주문조도코드
 * 3. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 항목별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 4. 편성한 결과는 PosContext에 등록
 * 5. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchRsnRouData">
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

public class DbSearchRsnRouData extends PosActivity implements C10NuiConstantsIF
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
        PosDecisionChecker checker = null;
        PosRuleVO result2 = null;

        // Parameter Error Check True=Null, FALE=NotNull
        if ( DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R01 );
            return PosBizControlConstants.FAILURE;
        }

        if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_G ) ||
        		ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_K ) ||
        		ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_J ) || 
        		ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_L ) || 
        		ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_V ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_W ) )
        {
            // 용융도금제품만 후처리설계
            colValue = new String[2];
            colValue[0] = (String) ctx.get( COL_PRD_NM_CD ); // 품명코드
            colValue[1] = (String) ctx.get( COL_ORD_SUR_HND_CD ); // 주문표면처리코드

            checker = EasyAccess.getPosDecisionChecker( C10B2160, null );
            result2 = null;
            try
            {
                // 결과값 잘 가져오는지 확인
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK60 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result2.getRecordCount() == 1 )
            {
                ctx.put( COL_RSN_ATT_AMT_TRV, result2.getRuleValueAt( COL_RSN_ATT_AMT_TRV ) );
                ctx.put( COL_RSN_ATT_AMT_LLV, result2.getRuleValueAt( COL_RSN_ATT_AMT_LLV ) );
                ctx.put( COL_RSN_ATT_AMT_ULV, result2.getRuleValueAt( COL_RSN_ATT_AMT_ULV ) );
                logger.logDebug( COL_RSN_ATT_AMT_LLV + C10STR_COLON + result2.getRuleValueAt( COL_ATT_AMT_LLV ) );
                logger.logDebug( COL_RSN_ATT_AMT_ULV + C10STR_COLON + result2.getRuleValueAt( COL_ATT_AMT_ULV ) );
                ctx.put( COL_ROU_RA_LLV, null );
                ctx.put( COL_ROU_RA_ULV, null );
                result2.next();
            } else if ( result2.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK61 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R65 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                // 0건인경우 SKIP
                return PosBizControlConstants.FALSE;
            }
        } else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_C ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) ||
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) ||   
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_1 ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) ||
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) )
        {            
            // TM공정통과제만 조도설계
            colValue = new String[2];
            colValue[0] = (String) ctx.get( COL_PRD_NM_CD ); // 품명코드
            colValue[1] = (String) ctx.get( COL_ORD_ROU_CD ); // 주문조도코드

            checker = EasyAccess.getPosDecisionChecker( C10B2210, null );
            result2 = null;
            try
            {
                // 결과값 잘 가져오는지 확인
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK64 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result2.getRecordCount() == 1 )
            {
                ctx.put( COL_ROU_RA_LLV, result2.getRuleValueAt( COL_RA_LLV ) );
                ctx.put( COL_ROU_RA_ULV, result2.getRuleValueAt( COL_RA_ULV ) );
                logger.logDebug( COL_ROU_RA_LLV + C10STR_COLON + result2.getRuleValueAt( COL_RA_LLV ) );
                logger.logDebug( COL_ROU_RA_ULV + C10STR_COLON + result2.getRuleValueAt( COL_RA_ULV ) );
                ctx.put( COL_RSN_ATT_AMT_LLV, null );
                ctx.put( COL_RSN_ATT_AMT_ULV, null );
            } else if ( result2.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK65 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R69 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                // 0건인경우 SKIP
                return PosBizControlConstants.FALSE;
            }
        } else
            return PosBizControlConstants.FALSE;

        return PosBizControlConstants.SUCCESS;
    }
}
