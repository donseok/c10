/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbCheckCnt.java
 * Change history
 * @LastModifyDate : 2012. 1. 12
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 1. 12 박재영 최초 생성
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
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 Table에 Data 존재유무를 반환하는 class이다.
 * <xmp>
 * 1. 존재하는 경우 transition='true', 아니면 'false'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbCheckCnt">
 * <transition name="success" value="C102100070-service" />
 * <property name="dao" value="mesdao" />
 * <property name="sqlkey" value="RK_Result" />
 * <property name="param-count" value="1" />
 * <property name="param0" value="where절변수명" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * sqlkey: 대상sql
 * param-count : Binding 할 개 수 (select * from emp where deptno=?)의 "?" 수
 * param#(param0,param1...): Binding Value ("?"와 순서 일치 하여야 함)
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbCheckCnt extends PosActivity implements C10NuiConstantsIF
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
        String sqlkey = this.getProperty( C10PN_SQLKEY ).trim();
        String paramCt = this.getProperty( PosServiceParamIF.PARAM_COUNT ); // param-count
        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );
        int paramCount = 0; // 파라미터 갯수

        PosParameter param = new PosParameter(); // MD View param

        if ( paramCt != null ) // 파라미터 카운터가 null이 아니라면
        {
            paramCount = Integer.parseInt( paramCt.trim() );

            for ( int i = 0; i < paramCount; i++ )
            {

                // System.out.println(ctx.get( this.getProperty( C10PN_PARAM + i ) ));

                param.setWhereClauseParameter( i, "" + ctx.get( this.getProperty( C10PN_PARAM + i ) ) );
            }
        }

        PosRowSet rowset = null;

        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( sqlkey, param ); // 고객공통View.select
        } catch ( Exception e )
        {
            rowset = null;
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( rowset.count() > 0 )
        {
            return PosBizControlConstants.TRUE;

        }

        return PosBizControlConstants.FALSE;
    }
}