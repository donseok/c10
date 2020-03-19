/*
 * ===========================================================================
 * Copyright(c) 2011 유니온스틸
 * @FileName : C10GridActivity.java
 * Change history
 * @LastModifyDate : 20111227
 * @LastModifier : 이민균
 * @LastVersion : 1.0
 * 2011-12-28 이민균
 * 1.0 최초 생성
 * ===========================================================================
 */
package com.unionsteel.mes.c10.activity.common;

import java.util.List;

import com.poscoict.glue.biz.dhtmlx.grid.GridActivity;
import com.posdata.glue.PosException;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosParameter;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 클래스는 품질설계의 상속받기 위한 공통 CLASS 이다.
 * <xmp>
 * 사용방법
 * Property 상세
 * </xmp>
 * 
 * @author 이민균
 */

public class C10GridActivity extends GridActivity implements C10NuiConstantsIF
{

    /**
     * 이 메소드는 그리드의 변경 된 rowID들을 배열로 return받는 메서드 이다.
     * 
     * @param ctx PosPosContext 객체
     * @return record ID 의 String 배열
     */
    public String[] getIdsValue( PosContext ctx )
    {
        String ids[] = (String[]) ctx.get( "ids" );
        if ( ids == null || ids.length < 1 )
            throw new PosException( "There is no edit data!" );
        String idsValue[] = ids[0].split( "," );
        return idsValue;
    }

    /**
     * 이 메소드는 해당 recordId의 record가 Insert, Update, Delete인지 리턴하는 메서드 이다.
     * 
     * @param ctx PosPosContext 객체
     * @param ids record ID
     * @return record ID 의 String 배열
     */
    public String getDMLType( PosContext ctx, String ids )
    {
        String status[] = (String[]) ctx.get( ( new StringBuilder( String.valueOf( ids ) ) ).append( "_!nativeeditor_status" ).toString() );
        logger.logDebug( ( new StringBuilder( "DMLType - " ) ).append( ids ).append( "_!nativeeditor_status" ).append( " : " ).append( status[0] ).toString() );
        if ( status != null && "inserted".equals( status[0] ) )
            return "INSERT";
        if ( status != null && "deleted".equals( status[0] ) )
            return "DELETE";
        if ( status != null && "senddeleted".equals( status[0] ) )
            return "SENDDELETE";        
        if ( status == null || "updated".equals( status[0] ) )
        {
            return "UPDATE";
        } else
        {
            logger.logDebug( "PosSaveByName.getQueryType : 정의되지 않은 타입입니다." );
            return "";
        }
    }

    /**
     * makeMessage
     */
    public String makeMessage( PosContext ctx, int updateCount, int insertCount, int deleteCount )
    {
        StringBuffer msgBuffer = new StringBuffer();
        if ( updateCount > 0 )
            msgBuffer.append( "수정 : " ).append( insertCount ).append( " " );
        if ( insertCount > 0 )
            msgBuffer.append( "등록 : " ).append( insertCount ).append( " " );
        if ( deleteCount > 0 )
            msgBuffer.append( "삭제 : " ).append( deleteCount ).append( " " );
        if ( updateCount + insertCount + deleteCount > 0 )
            msgBuffer.append( "- 성공적으로 처리하였습니다." );
        else
            msgBuffer.append( "처리 건수가 0입니다." );
        ctx.put( "appMsg", msgBuffer.toString() );
        return msgBuffer.toString();
    }

    /**
     * makePosParameter
     */
    public PosParameter makePosParameter( PosContext ctx, String idx, List namedParam )
    {
        String namedParamValue = null;
        PosParameter wherParam = new PosParameter();
        logger.logDebug( "----- named param ------------------------" );
        int j = 0;
        for ( int listSize = namedParam.size(); j < listSize; j++ )
        {
            namedParamValue = (String) namedParam.get( j );
            Object bindParam = ctx.get( ( new StringBuilder( String.valueOf( idx ) ) ).append( "_" ).append( namedParamValue ).toString() );
            if ( bindParam instanceof String[] )
                bindParam = ( (String[]) bindParam )[0];
            logger.logDebug( ( new StringBuilder( String.valueOf( namedParamValue ) ) ).append( " : " ).append( bindParam ).toString() );
            wherParam.setNamedParamter( namedParamValue, bindParam );
        }

        return wherParam;
    }

    /**
     * makePosParameter
     */
    public PosParameter makePosParameter( PosContext ctx, String dmlType, String idx, List namedParam )
    {
        String namedParamValue = null;
        PosParameter wherParam = new PosParameter();
        logger.logDebug( "----- named param ------------------------" );
        int j = 0;
        for ( int listSize = namedParam.size(); j < listSize; j++ )
        {
            namedParamValue = (String) namedParam.get( j );
            Object bindParam = ctx.get( ( new StringBuilder( String.valueOf( idx ) ) ).append( "_" ).append( namedParamValue ).toString() );
            if ( bindParam instanceof String[] )
                bindParam = ( (String[]) bindParam )[0];
            logger.logDebug( ( new StringBuilder( String.valueOf( dmlType ) ) ).append( " - " ).append( namedParamValue ).append( " : " ).append( bindParam ).toString() );
            wherParam.setNamedParamter( namedParamValue, bindParam );
        }

        return wherParam;
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

    @Override
    protected Object doDaoAction( PosContext arg0, PosParameter arg1 )
    {
        // TODO Auto-generated method stub
        return null;
    }

}
