/*
 * ===========================================================================
 * Copyright(c) 2011 유니온스틸
 * @FileName : LoopRouter.java
 * Change history
 * @LastModifyDate : 20111227
 * @LastModifier : 박영진
 * @LastVersion : 1.0
 * 2011-12-28 박영진
 * 1.0 최초 생성
 * ===========================================================================
 */
package com.unionsteel.mes.c10.activity.ui;

import com.posdata.glue.PosException;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosParameter;
import com.unionsteel.mes.c10.activity.common.C10GridActivity;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 클래스는 화면의 grid에서 dml된 row로 LOOP를 하는 custom Activity 이다.
 * <xmp>
 * 사용방법
 * <activity name="LOOP_ROUTER" class="com.unionsteel.mes.m60.activity.common.LoopRouter">
 * <transition name="endLoop" value="end" />
 * <transition name="UPDATE" value="checkFlag" />
 * <transition name="INSERT" value="상차편성공통저장" />
 * <transition name="DELETE" value="상차편성공통저장" />
 * </activity>
 * Property 상세
 * </xmp>
 * 
 * @author 박영진
 */
public class LoopRouter extends C10GridActivity implements C10NuiConstantsIF
{

    @Override
    public String doPreActivity( PosContext poscontext )
    {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public String doMainActivity( PosContext ctx )
    {

        if ( ctx.get( "m60Ids" ) == null )
        {
            ctx.put( "m60Ids", (String[]) ctx.get( "ids" ) );
        }

        String ids[] = (String[]) ctx.get( "m60Ids" );

        if ( ids == null || ids.length < 1 )
            throw new PosException( "There is no edit data!" );

        String idsValue[] = ids[0].split( "," );

        int i = (Integer) ctx.get( LOOP_CNT ) == null ? 0 : (Integer) ctx.get( LOOP_CNT );

        if ( i < idsValue.length )
        {

            String dmlType = getDMLType( ctx, idsValue[i] );
            String[] tmp = new String[1];
            tmp[0] = idsValue[i];
            ctx.put( "ids", tmp );

            getRecordToNormalValue( ctx, idsValue[i] );

            i++;
            ctx.put( LOOP_CNT, i );

            return dmlType;

        }

        ctx.put( "ids", ctx.get( "m60Ids" ) );

        // Loop 종료
        return LOOP_END;
    }

    @Override
    public String doPostActivity( PosContext poscontext )
    {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * 이 메소드는 그리드 데이터의 xml-result_x_columnId 형식의 값을 columnId 형식으로 CTX에 담는 메서드 이다.
     * 
     * @param ctx PosPosContext 객체
     * @param recordId 그리드의 record ID
     */
    public void getRecordToNormalValue( PosContext ctx, String recordId )
    {

        if ( ctx.get( "column-info_M60" ) == null )
        {
            ctx.put( "column-info_M60", ctx.get( "column-info" ) );
        }

        String[] columnInfo = (String[]) ctx.get( "column-info_M60" );
        String[] colOrder = columnInfo[0].split( "," );
        String tmp[] = null;

        for ( int i = 0; i < colOrder.length; i++ )
        {

            tmp = (String[]) ctx.get( recordId + "_" + colOrder[i] );

            if ( !colOrder[i].equals( "column-info" ) )
            {
                ctx.put( colOrder[i], tmp[0] );
            }
        }
    }

    @Override
    protected Object doDaoAction( PosContext arg0, PosParameter arg1 )
    {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public String getDefaultMsgCode()
    {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public String[] getDefaultMsgParam( PosContext arg0 )
    {
        // TODO Auto-generated method stub
        return null;
    }
}
