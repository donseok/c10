package com.unionsteel.mes.c10.activity.common;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

public class GridToCtx extends PosActivity implements C10NuiConstantsIF{
	@Override
	public String runActivity(PosContext ctx) {
		String[] idsValues = getIdsValue(ctx);
        if (idsValues.length > 1) {
            throw new PosException("ids는 하나만 올 수 있습니다.");
        }
        String idsValue = idsValues[0];

        for (Object o : ctx.getAllRequestParameters().keySet()) {
            String key = o.toString();
            if (!key.startsWith(idsValue)) continue;

            String keyWithoutIds = key.substring(idsValue.length() + 1);
            Object value = ctx.get(key);
            ctx.put(keyWithoutIds, value);
        }
        return PosBizControlConstants.SUCCESS;
	}
	
	public String[] getIdsValue(PosContext ctx){
		String ids[] = (String[])ctx.get("ids");
        if(ids == null || ids.length < 1)
            throw new PosException("There is no edit data!");
        String idsValue[] = ids[0].split(",");
        return idsValue;
	}
}
