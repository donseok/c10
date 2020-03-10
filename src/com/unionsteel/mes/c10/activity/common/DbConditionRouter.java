/*==============================================================================
*Copyright(c) 2011 UNIONSTEEL
*@FileName        : DbConditionRouter.java
*Change history 
*@LastModifyDate	: 2011. 12. 16
*@LastModifier		: 김종범
*@LastVersion		: 1.0
*  1.0	2011. 12. 16 	김종범	최초 생성
==============================================================================*/
package com.unionsteel.mes.c10.activity.common;

import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
//import com.posdata.glue.biz.activity.PosReuseActivity;


/**
 * DbConditionRouter.java Class는 항목값을 조건과 비교하여 조건에 따라 Routing하는 Class이다.
 *  <xmp>
 * 1. 조건                                                           
 * - 대상항목이 space와 null인 경우를 Check할 때는 sp_null로 고정 
 * - |는 or 조건으로 처리                                         
 * 2. 처리방법                                                       
 * - param0: Check 대상 항목명과 param1: 조건을 비교하여 참인 경우
 * - param2를 수행하고 거짓인 경우 param3를 수행                 
 *
 *
 * 사용 방법
 *  <activity name="ROUTER_IF_THEN" class="com.unionsteel.mes.c10.activity.common.DbConditionRouter">
 *    <transition name="success" value="end" />
 *    <property name="param0" value="MKEY_USE_TP" />
 *    <property name="param1" value="Y|T" />
 *    <property name="param2" value="confirm" />
 *    <property name="param3" value="stay" />
 *    <property name="param-count" value="4" />
 *  </activity> 
 * 
 *  Property 설정
 *  param-count : Binding 할 개 수 (select * from emp where deptno=?)의 "?" 수
 *  param#(param0,param1...): Binding Value ("?"와 순서 일치 하여야 함)
 *  </xmp>
 * @author  김종범
 * @see     PosActivity 
 * @version 1.0 
 */

    //public class DbConditionRouter extends PosReuseActivity implements C10NuiConstantsIF{
	public class DbConditionRouter extends PosActivity implements C10NuiConstantsIF{	
	/**
	 * <p>
	 * 이 메소드는 PosReuseActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다. 
	 * </p>
	 * @throws PosException IO Exception 발생 시
	 * @param ctx Service내의 Data를 관리하는 PosContext 객체  
	 * @return success - 성공적으로 끝났을 때 Route transition.
	 *         nullpointer - NullPointerException 발생 시 Route transtion.
	 *         faillue - 그 외 Exception 발생 시 Route transition.
	 */	
	public String runActivity(PosContext ctx)
//	public String doMainActivity(PosContext ctx)
	{
		String paramCt = this.getProperty(C10PN_PARAM_COUNT); 
		 
		int count = 0; 
		String param [] = null; 
		
		if (paramCt != null)
		{

			count = Integer.parseInt(paramCt.trim()); 
		    param = new String [count]; 
		    for (int i = 0; i < count; i++)
		    {
		    	param [i] = this.getProperty(C10PN_PARAM+i); 
				//param[0] = RK_MAIN("", null)
				//param[1] = sp_null , 1C, 1C|2C, 1C|2C|3C|4C .....
				//param[2] = A로 라우팅
				//param[3] = B로 라우팅
		    }
		   
	    	String[] targetValue = param[1].split(C10STR_REGULAR_EXP_PIPE);

	    	for (int j = 0; j < targetValue.length; j++) {		    		
	    		if(targetValue[j].equals(C10STR_SP_NULL)){
	    		   targetValue[j]	=	C10STR_SPACE;
	    		}		    		
	    		if(DbCommonUtil.isSame(DbCommonUtil.valueOf(ctx.get(param[0])), targetValue[j])){
	    			//ex)  param[0] = 1C일 경우
	    				 //targetValue[0] = 2C
	    				 //targetValue[1] = 3C
	    			return param[2];	//A
	    		}
	    	}
	    	return param[3]; 			//B 
		} else {
			logger.logError("DbConditionRouter : paramCt가 지정되어 있지 않습니다.");	
		}
		
	
	return PosBizControlConstants.SUCCESS;
	}
}

