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

<%
PosLog logger = PosLogFactory.getLogger("securityButtons");

try {
	
	PosUser user = (PosUser)session.getAttribute(PosSecurityConstants.USER);

	if(user != null){
		List menuList = user.getMenu();
		
		String pageId = request.getParameter("pageID");

		logger.logDebug("pageID : " + pageId);
		
		String buttons = null;
		PosMesMenu role = null;
		PosMesMenu permitedPage = null;
		for(int i = 0; i < menuList.size(); i ++){
			role = (PosMesMenu) menuList.get(i);
			permitedPage = (PosMesMenu) role.isPermitPage(pageId, permitedPage);
		}
		
		if(permitedPage != null){
			Map map = permitedPage.getInfo();
			buttons = (String) map.get("BUTTON_FLAG");
			logger.logInfo("<< Security Buttons : " + buttons + " >>");
			out.println(buttons);
		} else {
			logger.logInfo("<< Security Buttons : pageID is invalid! >>");
			out.println("");
		}
		
	} else {
		logger.logInfo("<< Security Buttons : User is null >>");
		out.println("");
	}
} catch(Exception e){
	logger.logError("<< Security Buttons - Error : " + e.getMessage() + " >>");
	e.printStackTrace();
	out.println("");
}
out.flush();
%>
