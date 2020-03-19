/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchGwTotData.java
 * Change history
 * @LastModifyDate : 2012. 01. 04
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 01. 04 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 도금량를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 도금량전면/후면(하한,상한), 목표부착량기준, 도금두께최소/최대
 * - Master Data View 통한 단순구조 데이타 결과값 도출
 * . Key: 품명코드(도금칼라제품일 경우 원판 품명코드)
 * 2. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 항목별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 3. 편성한 결과는 PosContext에 등록
 * 4. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchGwTotData">
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

public class DbSearchGwTotData extends PosActivity implements C10NuiConstantsIF
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

        String prd_nm_cd = C10STR_SPACE;
        String gw_asg_cd = C10STR_SPACE;

        // Parameter Error Check True=Null, FALE=NotNull
        if ( DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R01 );
            return PosBizControlConstants.FAILURE;
        }

        // 도금제품만 설계
        if (    !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_G ) && 
        		!ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_K ) &&
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_J ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_L ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_V ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_W ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 ) &&
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) &&
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ))
        {
            return PosBizControlConstants.FALSE;
        }

        // 품명코드 편집 (칼라제품은 원판의 품명코드 사용)
        if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_G ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 ) ){
            prd_nm_cd = PRD_NM_CD_G;
        }else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_K ) ){
            prd_nm_cd = PRD_NM_CD_K;
        }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_J ) ){
            prd_nm_cd = PRD_NM_CD_J;
        }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_L ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 ) ){
            prd_nm_cd = PRD_NM_CD_L;
        }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_V ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 ) ){
            prd_nm_cd = PRD_NM_CD_V;
        }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_W ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ) ){
            prd_nm_cd = PRD_NM_CD_W;
        }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) ){
            prd_nm_cd = PRD_NM_CD_E;
        }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) ){
            prd_nm_cd = PRD_NM_CD_N;
        }
        gw_asg_cd = (String) ctx.get( COL_GW_ASG_CD );
        PosRowSet rowset = null;
        PosRow row = null;

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, prd_nm_cd );
        param.setWhereClauseParameter( 1, gw_asg_cd );
        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( VI_M00_C10A1061, param ); // 도금량View.select
        } catch ( MasterDataException e )
        {
            rowset = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK31 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( rowset.count() == 1 )
        {
            row = rowset.next();

        } else if ( rowset.count() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK32 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R83 );
            return PosBizControlConstants.FAILURE;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK31 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R82 );
            return PosBizControlConstants.FAILURE;
        }

        // 도금작업공정에 따라 시험도금량, 작업도금량, 도금두께를 설계한다.
        if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_G ) || 
       		 ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_K ) ||
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_J ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_L ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_V ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_W ) || 
             ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ) )
        {
            ctx.put( COL_TST_GW_TOT_LLV, row.getAttribute( COL_WK_GW_TOT_LLV ) );
            ctx.put( COL_TST_GW_TOT_ULV, row.getAttribute( COL_WK_GW_TOT_ULV ) );
            ctx.put( COL_TST_GW_FRN_LLV, C10STR_SPACE );
            ctx.put( COL_TST_GW_FRN_ULV, C10STR_SPACE );
            ctx.put( COL_TST_GW_BAK_LLV, C10STR_SPACE );
            ctx.put( COL_TST_GW_BAK_ULV, C10STR_SPACE );
        }else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) || 
                       ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) ||
                       ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) || 
                       ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) )
        {
            ctx.put( COL_TST_GW_TOT_LLV, C10STR_SPACE );
            ctx.put( COL_TST_GW_TOT_ULV, C10STR_SPACE );
            ctx.put( COL_TST_GW_FRN_LLV, row.getAttribute( COL_WK_GW_FRN_LLV ) );
            ctx.put( COL_TST_GW_FRN_ULV, row.getAttribute( COL_WK_GW_FRN_ULV ) );
            ctx.put( COL_TST_GW_BAK_LLV, row.getAttribute( COL_WK_GW_BAK_LLV ) );
            ctx.put( COL_TST_GW_BAK_ULV, row.getAttribute( COL_WK_GW_BAK_ULV ) );
        }
        
        ctx.put( COL_QLT_DSN_SPC_TP, NUM2 );
        ctx.put( COL_WK_GW_TRV, row.getAttribute( COL_WK_GW_TRV ) );
        ctx.put( COL_WK_GW_FRN_LLV, row.getAttribute( COL_WK_GW_FRN_LLV ) );
        ctx.put( COL_WK_GW_FRN_ULV, row.getAttribute( COL_WK_GW_FRN_ULV ) );
        ctx.put( COL_WK_GW_BAK_LLV, row.getAttribute( COL_WK_GW_BAK_LLV ) );
        ctx.put( COL_WK_GW_BAK_ULV, row.getAttribute( COL_WK_GW_BAK_ULV ) );
        ctx.put( COL_WK_GW_TOT_LLV, row.getAttribute( COL_WK_GW_TOT_LLV ) );
        ctx.put( COL_WK_GW_TOT_ULV, row.getAttribute( COL_WK_GW_TOT_ULV ) );
        ctx.put( COL_GAL_THK_LLV, row.getAttribute( COL_GAL_THK_LLV ) );
        ctx.put( COL_GAL_THK_ULV, row.getAttribute( COL_GAL_THK_ULV ) );
        ctx.put( COL_GAL_THK_TRV, row.getAttribute( COL_GAL_THK_TRV ) );
        ctx.put( COL_SPC_GAL_THK, row.getAttribute( COL_SPC_GAL_THK ) );

        return PosBizControlConstants.SUCCESS;
    }
}
