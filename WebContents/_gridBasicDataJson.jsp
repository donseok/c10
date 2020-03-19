<%@ page contentType="text/plain;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@page import = "java.util.*" %> 
<%@page import = "java.sql.Types" %> 
<%@page import = "com.posdata.glue.context.PosContext" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %> 
<%@page import = "com.posdata.glue.web.control.*" %> 
<%@page import = "com.posdata.glue.util.log.PosLog" %>

<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 
<%@page import = "com.poscoict.glue.biz.dhtmlx.converter.GridJsonConverter" %> 
<%
String columnInfo = null;
String blankRowCntParam = null;
int blankRowCnt = 0;

StringBuffer sb = new StringBuffer();
try
{
    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);

    if (ctx == null) {
        //out.println("<rows>");
        
        String service = request.getParameter("ServiceName");
		String message = "Context is null, because Service ["+service+"] did not execute or has a problem!";     
		throw new Exception(message);
	}
    
	GridJsonConverter converter = new GridJsonConverter();
	String jsondata = converter.convert(ctx);
	
	sb.append(jsondata);
}catch (Exception e){
	e.printStackTrace();
	sb.append("{rows:[");
	sb.append("\"errMsg\":\"").append(e.getMessage()).append("\"");
	sb.append("}");
	sb.append("]}");
}
//System.out.println(sb.toString());
out.print(sb);


/*
아래는 DhtmlxGrid에 JSON 방식의 Data에 대한 예임
{
  "sname1": "ud1",// global userData
  "sname2": "ud2",// global userData
  rows: [
    { id: 1002, data: ["1000", "Blood"] },
    { id: 1003, data: ["1001", "Smoke"] }
  ]
}
*/


%>