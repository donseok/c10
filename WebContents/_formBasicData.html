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
Throwable error = null;
String columnInfo = null;	
PosContext ctx = null;
try
{
	ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
	if (ctx == null)
    {
        String service = request.getParameter("ServiceName");
        String message = "Context is null, because Service ["+service+"] did not execute or has a problem!";     
        throw new Exception(message);
    }
	StringBuffer sb = new StringBuffer();
	//sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
	String resultKey = "xml-result";
	
	columnInfo = (String)ctx.get("column-info");
	String [] colOrder = columnInfo.split(",");
	if(resultKey != null && colOrder != null) {
		
		Object result = ctx.get(resultKey);			
		if(result != null ){
			if (result instanceof List || result instanceof PosRowSet)
			{
				List rowSetList = (List)result;     
				Map rowMap = null;
				int listCnt =  rowSetList.size();
				if(listCnt >0){
					for(int i = 0; i < listCnt; i++){
						rowMap = (Map)rowSetList.get(i);
						if(rowMap != null)
						{
							sb.append("<data>");
							Object cellData = null;
							for(int j = 0; j < colOrder.length; j++){
								cellData = rowMap.get(colOrder[j]) == null ? "" : rowMap.get(colOrder[j]);
								
								sb.append("<").append(colOrder[j]).append(">").append("<![CDATA[").append(cellData).append("]]>").append("</").append(colOrder[j]).append(">");	
							}
							sb.append("<messageBox>").append("1건 조회되었습니다").append("</messageBox>");
							sb.append("</data>");
						}
					}
				}else{
					sb.append("<data>");					
				 	for(int j = 0; j < colOrder.length; j++){							
			 	       sb.append("<").append(colOrder[j]).append(">").append("</").append(colOrder[j]).append(">");				 	        				 	    
					}
					sb.append("<messageBox>").append("0").append("</messageBox>");
					sb.append("</data>");
					
				}
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
	out.println(sb.toString());
}catch (Exception e){
	e.printStackTrace();
	error = ctx.getException();
	if(error != null) {
		columnInfo = request.getParameter("column-info") != null ?  request.getParameter("column-info") : "";
		out.println("<rows>");
		out.print(DhtmlxConstantsIF.ERROR_STARTTAG);
		out.print("<![CDATA["+error.getMessage()+"]]>");
		out.println(DhtmlxConstantsIF.ERROR_ENDTAG);	
		out.println("<userdata name='column-info'>"+columnInfo+"</userdata>");	    	
	    out.println(DhtmlxConstantsIF.ROWS_ENDTAG); 
	}
}
%>
