/*===========================================================================
*Copyright(c) 2011 유니온스틸
*@FileName : M42CmnRouter.java
*Change history
*@LastModifyDate : 20120213
*@LastModifier     :  이재웅
*@LastVersion      :  1.0
*
===========================================================================*/

package com.unionsteel.mes.c10.activity.common;

import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;


/**
 * 이 클래스는 품질설계 체인 (C10)의 공통 ROUTER 클래스로서 각 조건에 맞는 값으로 분기한다.
 * 
 * 1) item variable, condition, 1st router, 2nd router 를 하나의 string으로 property로 설정한다.
 *     property name = "routers", value = "item/condition/router1/router2"
 * 2) item의 항목 값이 rowset에 들었는지, ctx에 들었는지에 대한 flag 값을 property로 설정한다.
 * 3) item의 항목 값이 rowset에 들었다면, rowset의 정보를 bindkey로서 property로 설정한다.
 * 
 *   
 * <xmp>
 * 
 * </xmp>
 * @author  이재웅
 * @version 1.0
 */
public class C10CmnRouter extends PosActivity implements C10NuiConstantsIF
{
	
    /**
     * item의 항목값이 조건에 부합할 때 원하는 곳으로 분기하는 메인 메소드이다.
     * 
     * @param PosContext
     * @return String
     */
	
	public String runActivity(PosContext ctx)
    {
		String result = PosBizControlConstants.FAILURE;

		String checkRouters 							= null;	// router의 item, condition, 1st router, 2nd router를 담은 string
		String [] routers 									= null;	// router의 각 정보들을 각각의 index에 저장하는 string 배열
		
		int routersLength 								= 0;		// router정보 string을 검사하기 위한 변수

		Boolean isCtx 										= null;	// ctx인지 rowset인지 받기 위한 변수
		
		try
		{
			checkRouters = getProperty("routers");		// ad에서 설정한 routers 정보들을 받는다.
			
			isCtx = Boolean.valueOf(getProperty("ctx-rowset"));
																				// item 값의 위치를 받는다.

			routers = checkRouters.split("/");	// 각 항목을 배열로 저장한다.
			routersLength = routers.length;					// 배열의 길이
			
			if(0 != routersLength % 4)								// 4의 배수인지 확인한다 (구성 : item, condition, router1, router2)
			{
				logger.logDebug("Activity의 항목 설정이 잘못되었습니다.");

				return result = "ad-failure";
			}
			
			// 각 항목들의 순서대로 분기하기 위한 변수 
			String [] itemBuf =  new String [routersLength / 4];  
			String [] conditionBuf = new String [routersLength / 4];
			String [] routerBuf = new String [routersLength / 4];
			String [] routerBuf2 = new String [routersLength / 4];
			
			for(int i = 0, index = 0; index < routersLength / 4;)
			{
				itemBuf[index] = routers[i++];
				conditionBuf[index] = routers[i++];
				routerBuf[index] = routers[i++];
				routerBuf2[index] = routers[i];
				
				logger.logDebug(" * 조건값 " + this.getData(ctx, itemBuf[index], isCtx));

				// 비교하기 위한 item 값을 얻어와 condition 조건과 비교한 후 원하는 flow로 분기한다.
				if(!isNull(this.getData(ctx, itemBuf[index], isCtx)))
				{
					logger.logDebug(" * 분기 아이템 : " + itemBuf[index]);
					logger.logDebug(" * 분기 조건 : " + conditionBuf[index]);
					
					if(this.getData(ctx, itemBuf[index], isCtx).equals(conditionBuf[index]))
					{
						logger.logDebug(routerBuf[index] + " 로 분기합니다.");
						return result = routerBuf[index];
					}
					else
					{
						logger.logDebug(routerBuf2[index] + " 로 분기합니다.");
						return result = routerBuf2[index];
					}
				}
				else
				{
					logger.logDebug(routerBuf2[index] + " 로 분기합니다.");

					return result = routerBuf2[index];
				}
			}
		}
		catch(Exception e)
		{
			logger.logDebug("Activity의 항목 설정이 잘못되었습니다.");

			return result = "ad-failure";
		}

		return result = "ad-failure";
    }
	
	/**
     * item의 실제 항목값을 얻는다.
     * rowset, ctx, number, String 값을 구별하여 얻는다.
     * 
     * overrided
     * @param PosContext, String, boolean, boolean
     * @return String
     */
	public Object getData(PosContext ctx, Object item, boolean ctxFlag)
	{
		Object result = null;
		
		try
		{
			if(ctxFlag == true)
			{
				result = (Object)ctx.get(item);
				logger.logDebug(" * ctx   조건 값 : " + "=" + result);
			}
			else
			{
				PosRowSet rowset = (PosRowSet)ctx.get(getProperty("bindkey"));

				// rowset의 모든 정보를 row배열에 담는다.
				PosRow [] row = rowset.getAllRow();
				int rowLength = row.length;
				Object [] buf = new Object [rowLength];
				
				for(int i = 0; i < rowLength; i++)
				{
					buf[i] = row[i].getAttribute(item.toString());
					
					// rowset의 다수의 row 중 하나라도 원하는 값이 존재할 때 분기하기 위한 return 변수 설정
					if(buf[i] != null)
					{
						result = buf[i];
					}
				}
			}
		}
		catch(Exception e)
		{
			logger.logDebug(e.getMessage());
		}

		return result;
	}
	
    /**
     * string 값을 체크한다. 
     * @param string
     * @return boolean
     */

	public boolean isNull(Object message)
	{
		if(message == null)
		{
			return true;//정보가 없는 경우
		}
		else if(message.toString().trim().length() == 0)
		{
			return true;//정보가 없는 경우
		}
		
		return false;//정보가 있는 경우
	}
}
