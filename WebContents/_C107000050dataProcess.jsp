<%@ page contentType="text/xml;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "java.util.*" %>
<%@page import = "java.util.regex.Pattern" %>
<%@page import = "java.util.regex.Matcher" %>
<%@page import = "com.posdata.glue.context.PosContext" %>
<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %>
<%@page import = "com.posdata.glue.web.control.*" %>
<%@page import = "com.posdata.glue.util.log.PosLog" %>
<%
	
	
	System.out.println("=============Start===========");
		try{			
			Map params = request.getParameterMap();
			Set keys = params.keySet();
			Iterator keyItr = keys.iterator();
			
			while(keyItr.hasNext()){
				Object key = keyItr.next();
				Object data = params.get(key);
				System.out.println("Type Key : "+key+"     value:"+data);
				if(data instanceof String[]){
				    String [] values = (String []) data;
				    for(int i = 0; i < values.length; i++){
				    	System.out.println("\tKey : "+key+"   value_"+i+":"+values[i]);
				    }
				}
			}
		}catch (Exception e){
			e.printStackTrace();
		}
    System.out.println("=============End===========");
   // out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    try{
    	
    	PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    	
    	if (ctx == null) 
        {
            String service = request.getParameter("ServiceName");
            String message = "Context is null, because Service ["+service+"] did not execute or has a problem!";     
            throw new Exception(message);
        }
        String[] ids = request.getParameter("ids").split(",");
        
        Throwable error = ctx.getException();
        if(error != null) {
                  	    
        	Pattern p = Pattern.compile("ORA-");
    		// 입력 문자열과 함께 매쳐 클래스 생성
    		Matcher m = p.matcher(error.getMessage());
    		
            out.print("<data>");
            String errorMessage ="";
        	for(int i = 0; i < ids.length; i++){
        		if(i==0)
            	  errorMessage = "message=\"errMsg\"";
        		
            	    if(m.find()){
            	    	Pattern p2 = Pattern.compile("ORA-20100");
	            		// 입력 문자열과 함께 매쳐 클래스 생성
	            		Matcher m2 = p.matcher(error.getMessage());
	            		if(m2.find())        				            		
	            			out.print("<action type=\"invalid\" sid=\""+ids[i]+"\"".concat(" ")+ errorMessage + "><![CDATA["+error.getMessage()+"]]></action>");            		        
	            		else	            			
	            		    out.print("<action type=\"invalid\" sid=\""+ids[i]+"\"".concat(" ")+ errorMessage + "><![CDATA[SQL 처리중 에러발생2]]></action>");
            	    }
            		else{
            			out.print("<action type=\"invalid\" sid=\""+ids[i]+"\"".concat(" ")+ errorMessage + "><![CDATA["+error.getMessage()+"]]></action>");
            		}
            	}

       	    out.println("</data>");	        	
        }else{
        	
    		   out.print("<data>");
        	for(int i = 0; i < ids.length; i++){
        		
        		String type = request.getParameter(ids[i] + "_!nativeeditor_status");
        		
		        out.print("<action type='"+type+"' sid='"+ids[i]+"' tid='"+ids[i]+"' message='Success'></action>");
        	}
        	String tstMsg = (String) ctx.get("TST");
        	String prdMsg = (String) ctx.get("PRD");
         	if(tstMsg == null) tstMsg = "";
         	else tstMsg = tstMsg +"\\n";
        	if(prdMsg == null) prdMsg = "";
        	else prdMsg = prdMsg +"\\n";

			out.print("<action type='appMsg'><![CDATA["+tstMsg+ prdMsg+ids.length +"건의 Data 처리에 성공했습니다.]]></action>");
       	    out.println("</data>");	
       	 tstMsg="";
       	 prdMsg="";
        }
    } catch (Exception e) {
    	out.print("<data>");
        out.print("<action type='invalid'><![CDATA[SQL 처리중 에러발생1]]></action>");
       	out.println("</data>");
       	//여기 예외로 바로 빠지네...
    }
    out.flush();
	%>