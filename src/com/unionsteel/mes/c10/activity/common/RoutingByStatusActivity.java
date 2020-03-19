package com.unionsteel.mes.c10.activity.common;

import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.util.log.PosLog;
import com.posdata.glue.util.log.PosLogFactory;


public class RoutingByStatusActivity extends PosActivity {
	protected static PosLog logger = PosLogFactory.getLogger(RoutingByStatusActivity.class);

	private static boolean isRunning = false;
	
	public String runActivity(PosContext ctx){
		String mode = this.getProperty("mode");
		if(mode == null || "".equals(mode)){
			logger.logError("property [mode] 값이 null이거나 빈문자열입니다.");
			return PosBizControlConstants.FAILURE;
		}
		
		return handleStatus(mode);
	}
	
	public synchronized String handleStatus(String mode){
		if("START".equals(mode)){
			if(isRunning){
				return PosBizControlConstants.FAILURE;
			} else {
				isRunning = true;
				return PosBizControlConstants.SUCCESS;
			}
		} else if("STOP".equals(mode)){
			if(isRunning){
				isRunning = false;
				return PosBizControlConstants.SUCCESS;
			} else {
				logger.logWarn("Stop 상태에서 Stop하려고 합니다.");
				return PosBizControlConstants.FAILURE;
			}
		} else {
			logger.logWarn("입력받은 파라미터 mode는 [START|STOP] 중 하나이어야 함 : " + mode);
			return PosBizControlConstants.FAILURE;
		}
	}
}
