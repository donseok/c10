/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchQltReqData.java
 * Change history
 * @LastModifyDate : 2012. 01. 16
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 01. 16 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 품질설계요청 에러내용을 편집하는 class이다.
 * <xmp>
 * 1. 편집정보: 품질설계의뢰 에러메세지
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbQltReqErrSet">
 * <transition name="success" value="C103100050-service" />
 * <property name="dao" value="masterdao" />
 * </activity>
 * Property 설정
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbQltReqErrSet extends PosActivity implements C10NuiConstantsIF
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
        String errKind = this.getProperty( C10STR_P_ERR_KEY ).trim();

        ctx.put( COL_XSTAT, C10STR_X );
        ctx.put( COL_XSTAT_CALLBACK, C10STR_R );

        if ( errKind.equals( NUM1 ) )
        {
            ctx.put( COL_XMSGS, ERRMSG_EAI1 );
        } else
        {
            ctx.put( COL_XMSGS, ERRMSG_EAI2 );
        }

        return PosBizControlConstants.SUCCESS;
    }
}
