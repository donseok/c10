<%@ page contentType="text/xml;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "java.util.*" %>
<%@page import = "com.posdata.glue.context.PosContext" %>
<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %>
<%@page import = "com.posdata.glue.web.control.*" %>
<%@page import = "com.posdata.glue.util.log.PosLog" %>
<%
try{
	PosContext ctx = (PosContext) request.getAttribute(PosWebConstants.CONTEXT);
	String lov = (String)ctx.get("lov-result");
	
	out.print(lov);
    out.flush();
} catch (Exception e){
	e.printStackTrace();
}
%>