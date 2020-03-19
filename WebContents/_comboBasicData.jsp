<%@ page contentType="text/xml;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "java.util.*" %> 
<%@page import = "java.sql.Types" %> 
<%@page import = "com.posdata.glue.context.PosContext" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %> 
<%@page import = "com.posdata.glue.web.control.*" %> 
<%@page import = "com.posdata.glue.util.log.PosLog" %>

<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 

<%
System.out.println("=============Start===========");

String name = null;
String value = null;

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
		    	
		    	if(key.equals("column-info")){
		    		String [] tmp = values[i].split(",");
		    		name = tmp[0];
		    		value = tmp[1];
		    	}
		    	
		    	
		    }
		}
	}
	System.out.println("name : "+name+"     value:"+value);
	if(name == null || value == null){
		
		name = "";
		value = "";
	}
	
}catch (Exception e){
	e.printStackTrace();
}
System.out.println("=============End===========");
try
{
	PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    
	if (ctx == null)
    {
        String service = request.getParameter("ServiceName");
        String message = "Context is null, because Service ["+service+"] did not execute or has a problem!";     
        throw new Exception(message);
    }
	StringBuffer sb = new StringBuffer();
	//sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");	
	String resultKey = "xml-result";
	String columnInfo = null;	
	if(resultKey != null) {		
		Object result = ctx.get(resultKey);			
		if(result != null ){
			if (result instanceof List || result instanceof PosRowSet)
			{
				List rowSetList = (List)result;     
				Map rowMap = null;
				sb.append("<complete>\n");	
				for(int i = 0, listSize = rowSetList.size(); i < listSize; i++){
					rowMap = (Map)rowSetList.get(i);
					if(rowMap != null)
					{
						sb.append("<option value=").append("\"").append(String.valueOf(rowMap.get(name))).append("\"").append(">").append(String.valueOf(rowMap.get(value))).append("</option>");
					}
				}
				sb.append("</complete>\n");
			} else {
				throw new Exception("This resultkey type can not support! Type:"+result);
			}					
		} else {
			
			throw new Exception("Context didn't have a result with this key "+resultKey);
		}
	} else if (resultKey == null) {
		throw new Exception("Context didn't have "+DhtmlxConstantsIF.XML_RESULT);
	} else {
		throw new Exception("Context didn't have "+DhtmlxConstantsIF.COLUMN_ORDER);
	}	
	Throwable error = ctx.getException();
	if(error != null) {

		out.print(DhtmlxConstantsIF.ERROR_STARTTAG);
		out.print("<![CDATA["+error.getMessage()+"]]>");
		out.println(DhtmlxConstantsIF.ERROR_ENDTAG);
	}
	out.println(sb.toString());
	System.out.println(sb.toString());
}catch (Exception e){
	e.printStackTrace();
	out.print(DhtmlxConstantsIF.ERROR_STARTTAG);
	out.print("<![CDATA["+e.getMessage()+"]]>");
	out.println(DhtmlxConstantsIF.ERROR_ENDTAG);
}
%>
