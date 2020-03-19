package com.unionsteel.mes.c10.activity.ui;

import java.util.List;

import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10DhtmlxActivity;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

public class SearchTableLoad extends C10DhtmlxActivity implements C10NuiConstantsIF
{

    @Override
    public String doMainActivity( PosContext ctx )
    {

        PosGenericDao dao = getDao( C10STR_EAIDAO ); // DATA ACCESS OBJECT
        String sqlKey = getProperty( C10PN_SQLKEY ); // 인터페이스 정보를 조회 할 SQLKEY
        String query = dao.getQueryManager().getQueryDefinition( sqlKey ).getQueryStatement( true );

        PosParameter param = new PosParameter();
        List paramList = getBindingNames( ctx, dao, sqlKey );
        int size = Integer.parseInt( (String) getProperty( KEY_COUNT ) );
        String key[] = null;

        for ( int i = 1; i <= size; i++ )
        {
            key = ( (String) getProperty( C10STR_KEY + i ) ).split( C10STR_REGULAR_EXP_PIPE );
            query = query.replace( key[0], (String) get( ctx, key[1] ) );
        }

        for ( int i = 0, pSize = paramList.size(); i < pSize; i++ )
        {
            param.setNamedParamter( paramList.get( i ), get( ctx, paramList.get( i ) ) );
        }

        /* Excute DAO Action */
        PosRowSet rowset = dao.findByQueryStatement( query, param, true );

        ctx.put( super.getProperty( PN_RESULTKEY, PV_XML_RESULT ), rowset );

        /* Make Screen Message */
        String message = makeMessage( ctx, rowset );
        logger.logDebug( message );
        return SUCCESS;
    }

    @Override
    public String getDefaultMsgCode()
    {
        // TODO Auto-generated method stub
        return MSG_MS001024;
    }

    @Override
    public String[] getDefaultMsgParam( PosContext ctx )
    {
        String[] msgParam = new String[1];
        PosRowSet rowSet = (PosRowSet) ctx.get( super.getProperty( PN_RESULTKEY, PV_XML_RESULT ) );
        msgParam[0] = String.valueOf( rowSet.count() );
        return msgParam;
    }

    public Object get( PosContext ctx, Object key )
    {
        Object rtn = ctx.get( key );

        if ( rtn != null && rtn instanceof String[] )
        {
            rtn = ( (String[]) rtn )[0];
        }

        return rtn;
    }
}
