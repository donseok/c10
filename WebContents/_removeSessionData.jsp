<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import = "java.util.List" %> 
<%@ page import = "java.util.Map" %> 
<%@ page import = "com.posdata.glue.util.log.PosLogFactory"%>
<%@ page import = "com.posdata.glue.util.log.PosLog" %>
<%@ page import = "com.posdata.glue.web.control.*" %> 
<%@ page import = "com.posdata.glue.context.PosContext" %> 
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.web.security.PosMesMenu" %> 
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.SecurityConstants" %>

<%
PosLog logger = PosLogFactory.getLogger("securityButtons");

try {
	
	session.invalidate();
	
	Cookie[] cookies = request.getCookies();
	String domainName = System.getProperty("Mes.Domain");
	for (int i = 0; i < cookies.length; i++) {
		Cookie cookie = cookies[i];
		
		logger.logInfo("cookie name : " + cookie.getName());
		
		
		if(SecurityConstants.MES_COOKIE_ID.equals(cookie.getName()) ){ //|| SecurityConstants.MES_COOKIE_PW.equals(cookie.getName())){
			response.setContentType("text/html"); 
			cookie.setValue("");
			cookie.setPath("/");
			cookie.setDomain(domainName);
			cookie.setMaxAge(0);
			response.addCookie(cookie);

			logger.logInfo("Cookie [" + cookie.getName() + "] is deleted!");
		}
	}
	out.println("success");
} catch(Exception e){
	logger.logError("<< remove session and cookies - Error : " + e.getMessage() + " >>");
	e.printStackTrace();
	out.println("failure");
}
%>
