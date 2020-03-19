package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.scheduling.server.PosGlueSchedulerHttpServer;

/**
 * Batch Job Demon을 띄우는 Main Class이다.
 * 각 체인 Jar에서는 이 클래스를 포함시킨 후 Jar에서 Main Class로 지정해야 한다.
 * 특별한 이유가 없는한 체인에서는 그대로 복사하여 사용한다. 
 */
public class GlueHttpServerLauncher
{
	public static void main(String[] args)
	{
		try
		{
			PosGlueSchedulerHttpServer.main(null);
		} 
		catch (Exception e)
		{
			System.out.println(e.getMessage());
			e.printStackTrace();
			System.exit(-1);
		}
	}
}