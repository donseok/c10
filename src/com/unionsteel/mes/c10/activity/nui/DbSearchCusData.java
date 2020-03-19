/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchCusData.java
 * Change history
 * @LastModifyDate : 2011. 12. 26
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 26 김종범 최초 생성
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
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 고객공통사양을 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 고객공통사양
 * - 고객 : m00apuser.VI_M00_C10A1020 -고객공통view
 * 2. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 성분별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 3. 편성한 결과는 PosContext에 등록
 * 4. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchCusData">
 * <transition name="success" value="C102100070-service" />
 * <property name="prodSpecKind" value="1" />
 * <property name="dao" value="masterdao" />
 * <property name="bind-result" value="RK_Result" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * bind-result: 이전 Activity에서 조회된 PosRowset
 * prodSpecKind: 품질설계사양구분
 * resultkey : Query 결과를 ctx에 저장할 Key
 * </xmp>
 * 
 * @author 김종범
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchCusData extends PosActivity implements C10NuiConstantsIF
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
        String prodSpecKind = this.getProperty( C10PN_PROSPECKIND ).trim();
        ctx.put( COL_QLT_DSN_SPC_TP, prodSpecKind );
        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );

        PosParameter param = new PosParameter(); // MD View param

        if ( DbCommonUtil.isNull( (String) ctx.get( COL_CUS_BTH_PAP_NO ) ) )

        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC01 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R05 );
            ctx.put( COL_CUS_REQ_ROL_THK, C10STR_SPACE );
            ctx.put( COL_THK_COR_UNT, C10STR_SPACE );
            ctx.put( COL_PRD_THK_CAL_APL_CD, C10STR_SPACE );
            return PosBizControlConstants.FAILURE;
        }

        PosRowSet rowset = null;
        PosRow row = null;

        param = new PosParameter(); // MD View param

        param.setWhereClauseParameter( 0, (String) ctx.get( COL_CUS_BTH_PAP_NO ) );

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( VI_M00_C10A1020, param ); // 고객공통View.select
        } catch ( Exception e )
        {
            rowset = null;
            logger.logError( e.getMessage() );
            // return PosBizControlConstants.FAILURE;
        }

        if ( rowset.count() == 1 )
        {
            row = rowset.next();
            ctx.put( COL_CUS_REQ_ROL_THK, DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK ) ) );
            ctx.put( COL_THK_COR_UNT, DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK_UNT ) ) );
            ctx.put( COL_PRD_THK_CAL_APL_CD, DbCommonUtil.valueOf( row.getAttribute( COL_PRD_THK_CAL_APL_CD ) ) );

        } else if ( rowset.count() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS14 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R03 );
            ctx.put( COL_CUS_REQ_ROL_THK, C10STR_SPACE );
            ctx.put( COL_THK_COR_UNT, C10STR_SPACE );
            ctx.put( COL_PRD_THK_CAL_APL_CD, C10STR_SPACE );
            // return PosBizControlConstants.FAILURE;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS04 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R03 );
            ctx.put( COL_CUS_REQ_ROL_THK, C10STR_SPACE );
            ctx.put( COL_THK_COR_UNT, C10STR_SPACE );
            ctx.put( COL_PRD_THK_CAL_APL_CD, C10STR_SPACE );
            // return PosBizControlConstants.FAILURE;
        }

        return PosBizControlConstants.SUCCESS;
    }
}