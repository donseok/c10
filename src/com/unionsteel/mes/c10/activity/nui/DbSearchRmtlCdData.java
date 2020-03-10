/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchRmtlCdData.java
 * Change history
 * @LastModifyDate : 2012. 01. 04
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 01. 04 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import java.util.ArrayList;
import java.util.Iterator;

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
 * 이 class는 원자재코드를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 원자재코드 기준
 * - Master Data 정의명 : C10B1063
 * - 원자재코드 기준 Data 조건항목 : 원자재코드, 주문두께
 * -> Read Count = 1 이면 원자재코드 기준 Data의 원자재코드, 원자재등급을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 원자재코드 기준 에러처리한다.
 * 2. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 항목별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 3. 편성한 결과는 PosContext에 등록
 * 4. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchRmtlCdData">
 * <transition name="success" value="C103100010-service" />
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

public class DbSearchRmtlCdData extends PosActivity implements C10NuiConstantsIF
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

        String rmtl_cd = C10STR_SPACE;
        String rmtl_cd1 = C10STR_SPACE;
        String rmtl_cd2 = C10STR_SPACE;
        String ord_exc_thk = C10STR_SPACE;
        String rmtl_prfr_cd = C10STR_SPACE;

        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD ) ) )
            rmtl_cd = (String) ctx.get( COL_RMTL_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD1 ) ) )
            rmtl_cd1 = (String) ctx.get( COL_RMTL_CD1 );
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD2 ) ) )
            rmtl_cd2 = (String) ctx.get( COL_RMTL_CD2 );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = (String) ctx.get( COL_ORD_EXC_THK ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_PRFR_CD ) ) )
            rmtl_prfr_cd = (String) ctx.get( COL_RMTL_PRFR_CD ).toString();

        ArrayList<String> rmtl = new ArrayList<String>();
        rmtl.add( rmtl_cd );
        if ( !rmtl_cd1.equals( C10STR_SPACE ) )
            rmtl.add( rmtl_cd1 );
        if ( !rmtl_cd2.equals( C10STR_SPACE ) )
            rmtl.add( rmtl_cd2 );

        for ( int nidx = 0; nidx < rmtl.size(); nidx++ )
        {

        	ctx.put( COL_QLT_DSN_MNF_TP, nidx + 1 );
            // Parameter Error Check True=Null, FALE=NotNull

            colValue = new String[2];
            colValue[0] = rmtl.get( nidx ); // 원자재코드
            colValue[1] = ord_exc_thk; // 주문환산두께

            logger.logDebug( "원자재기준 조건 rmtl_cd : " + colValue[0]  );

            
            PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B1063, null );
            PosRuleVO result2 = null;
            try
            {
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT16 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result2.getRecordCount() == 1 )
            {
                Iterator rtiter = result2.itemNameRow.iterator();
                Object data = null;

                while ( rtiter.hasNext() )
                {
                    data = rtiter.next();
                    ctx.put( data.toString(), result2.getRuleValueAt( data.toString() ) );
                    logger.logDebug( data.toString() + C10STR_COLON + result2.getRuleValueAt( data.toString() ) );
                }

                PosAuditAttributes audit = ctx.getAuditAttribute();

                param = new PosParameter(); // MD View param
                param.setValueParamter( 0, ctx.get( COL_ORD_NO ) );
                param.setValueParamter( 1, ctx.get( COL_ORD_LN ) );
                param.setValueParamter( 2, ctx.get( COL_QLT_DSN_MNF_TP ) );
                param.setValueParamter( 3, rmtl.get( nidx ) );
                param.setValueParamter( 4, rmtl_prfr_cd );
                param.setAuditAttributes( audit );
                try
                {
                    dao.insert( INSERT_RMT, param ); // 반제품 Material
                } catch ( Exception e )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB05 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }

            } else if ( result2.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT17 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R75 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT16 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R74 );

                return PosBizControlConstants.FAILURE;
            }

        }

        return PosBizControlConstants.SUCCESS;
    }
}
