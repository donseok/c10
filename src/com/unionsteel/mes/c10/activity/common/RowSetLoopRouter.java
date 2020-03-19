package com.unionsteel.mes.c10.activity.common;

import java.util.ArrayList;
import java.util.List;

import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.dao.vo.PosRowSetImpl;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

public class RowSetLoopRouter extends C10GridActivity implements C10NuiConstantsIF
{

    @Override
    public String doMainActivity( PosContext ctx )
    {

        String loopCntNm = getProperty( LOOP_CNT ) == null ? LOOP_CNT : getProperty( LOOP_CNT );

        PosRowSet rowset = (PosRowSet) ctx.get( getProperty( BIND_KEY ) );
        String resultkey = getProperty( RESULTKEY );
        PosRow[] row = rowset.getAllRow();
        List list = new ArrayList();

        int loopCnt = (Integer) ctx.get( loopCntNm ) == null ? 0 : (Integer) ctx.get( loopCntNm );

        logger.logDebug( "************loopCnt : " + loopCnt );

        logger.logDebug( "************rowset.count() : " + rowset.count() );

        if ( loopCnt < rowset.count() )
        {
            list.add( row[loopCnt] );
            PosRowSet rowSet = new PosRowSetImpl( list );
            ctx.put( resultkey, rowSet );
            ctx.setRowSet( resultkey, rowSet );

            loopCnt++;
            ctx.put( loopCntNm, loopCnt );

            return PosBizControlConstants.SUCCESS;
        }
        return LOOP_END;
    }

    @Override
    public String doPreActivity( PosContext poscontext )
    {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public String doPostActivity( PosContext poscontext )
    {
        // TODO Auto-generated method stub
        return null;
    }
}
