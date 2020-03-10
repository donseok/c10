/*==============================================================================
*Copyright(c) 2011 UNIONSTEEL
*@FileName        : DbSetParam.java
*Change history 
*@LastModifyDate	: 2011. 12. 09
*@LastModifier		: 김종범
*@LastVersion		: 1.0
*  1.0	2011. 12. 09 	김종범	최초 생성
==============================================================================*/
package com.unionsteel.mes.c10.activity.common;

import java.util.ArrayList;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;


/**
* DbSetParam Class는 Parameter로 값을 받아 PosContext에 등록하는 클래스이다. 
* 
* <xmp>
* 사용 방법
*  <activity name="SearchTest" class="com.posdata.glue.biz.activity.PosSearch">
*    <transition name="success" value="SEARCH" />
*    <property name="param0" value="A|2" />
*    <property name="param1" value="B|3" />
*    <property name="param-count" value="2" />
*    <property name="list" value="list1" />
*  </activity> 
*  
*  Property 설정은 아래와 같다.
*  param0 : 코드명
*  param1 : 코드 카테고리
*  list	  : paramValue[0]의 값을 모두 ArrayList로 저장한다. 
*           list항목을 주지 않으면 저장되지 않는다. 선택사항이니 필요에 따라 사용가능  
*  param-count : parameter 갯수
*  </xmp>
*  
* @author 김종범
* @see PosActivity
* @version 1.0
*/

public class DbSetParam extends PosActivity implements C10NuiConstantsIF{
	
	/**
	 * 반드시 구현해야 하는 Method이다.
	 * @throws PosException IO Exception 발생 시
	 * @param ctx Service내의 Data를 관리하는 PosContext 객체  
	 * @return success - 성공적으로 끝났을 때 Route transition.
	 *         nullpointer - NullPointerException 발생 시 Route transtion.
	 *         faillue - 그 외 Exception 발생 시 Route transition.
	 */
    public String runActivity(PosContext ctx) {
    	try
		{
			String paramCt = this.getProperty(PosServiceParamIF.PARAM_COUNT);	
			
			int count = 0;
		    String param[] = null;
		    ArrayList	list	  =		null;
		    String		listName  =     C10STR_SPACE;
		    Boolean     flag	  =     false;
		    if(this.getProperty(C10PN_LIST) != null){
		    	    	listName  =     this.getProperty(C10PN_LIST);
		    	    	list	  =		new ArrayList();
		    	    	flag 	  =     true;    	
		    }
		    if(paramCt != null)
		    {
		    	count = Integer.parseInt(paramCt.trim());
		        param = new String[count];
		        String[] 	 paramValue 	= null;
		        int 	 	 resultIndex 	= 0; 
		        Object 		 bindCulmn  	= null;
		        PosRowSet 	 rowset 	 	= null;
		        PosRow[]  	row 			= null; 
		        for(int i = 0; i < count; i++)
	            {
	                param[i] 	= this.getProperty(PosServiceParamIF.PARAM + i);
	                //param0		A|sp_null 
	                //param1		B|3
	    			paramValue 	= param[i].split(C10STR_REGULAR_EXP_PIPE); //paramValue[0] A, paramValue[1] 2
	    			
	    			if(C10STR_SP_NULL.equals(paramValue[1])){
	    				
	    				paramValue[1] = C10STR_SPACE;
	    				ctx.put(paramValue[0], C10STR_SPACE);
	    			
	    			}else if(paramValue[1].indexOf(C10STR_AT) > -1){
	    				
	    				if(ctx.get(paramValue[1].substring(1)) instanceof Object[]) {
	    					
	    					ctx.put(paramValue[0], ((Object[])ctx.get(paramValue[1].substring(1)))[0]);
	    					
	    					logger.logDebug( C10PN_KEY + C10STR_COLON + paramValue[0]);
	    					logger.logDebug( C10PN_VALUE + C10STR_COLON + ((Object[])ctx.get(paramValue[1].substring(1)))[0]);
	    					
	    				}else{
	    					ctx.put(paramValue[0], ctx.get(paramValue[1].substring(1)));
	    					
	    					logger.logDebug(C10PN_KEY + C10STR_COLON + paramValue[0]);
	    					logger.logDebug(C10PN_VALUE + C10STR_COLON + ctx.get(paramValue[1].substring(1)));
	    				}
	    				
	    			}else if(paramValue[1].indexOf(C10STR_DOT) > 0 ){
	    				
	    				resultIndex = paramValue[1].indexOf(C10STR_DOT);
	    				rowset = ctx.getRowSet(paramValue[1].substring(0,resultIndex));
	    				
	    				if(rowset != null && rowset.count() != 0){
	    					
	    					row 	  = rowset.getAllRow();
	    					bindCulmn = row[0].getAttribute(paramValue[1].substring(resultIndex+1));
	    					
	    				}else{
	    					
	    					bindCulmn = C10STR_SPACE;
	    					
	    				}
	    				
	    				ctx.put(paramValue[0], bindCulmn);
	    				logger.logDebug(C10PN_KEY + C10STR_COLON + paramValue[0]);
    					logger.logDebug(C10PN_VALUE + C10STR_COLON + bindCulmn);
	    				
	    			}else{
	    				
	    				ctx.put(paramValue[0], paramValue[1]);
	    				logger.logDebug(C10PN_KEY + C10STR_COLON + paramValue[0]);
    					logger.logDebug(C10PN_VALUE + C10STR_COLON + paramValue[1]);
	    			}
	    			
	    			//Property list값이 셋팅되어 있으면 파라미터값을 list에 담는다.
	    			if(flag){
	   
	    				list.add(paramValue[0]);	
	    			}
	    			
	            }
		        if(listName != null || list.equals(C10STR_SPACE)){
		        	ctx.put(listName, list);
		        }
		    }
			
		} catch(Exception e){
			logger.logDebug("DbSetParam Error ");
			e.printStackTrace();
			return PosBizControlConstants.FAILURE;
		}
		
		return PosBizControlConstants.SUCCESS;
    }
}
