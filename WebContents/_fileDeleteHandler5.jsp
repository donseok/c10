<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="com.scand.fileupload.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.unionsteel.mes.c10.activity.common.C10FileUpload4" %>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%
PosUser	user		= (PosUser)session.getAttribute(PosSecurityConstants.USER);
String		userNo	= "";
String		userName= "";
if(user != null) {
	userNo 	= (String)user.getUserInfo("USER_NO");
	userName= (String)user.getUserInfo("USER_NAME");
}

String IMG_RGS_FLAG 	= request.getParameter("IMG_RGS_FLAG");
String SEQ 				= request.getParameter("SEQ"); 
String IMG_RGS_FLAG_ID 	= request.getParameter("IMG_RGS_FLAG_ID");
String IMG_RGS_FLAG_ID1 = request.getParameter("IMG_RGS_FLAG_ID1");
String IMG_RGS_FLAG_ID2 = request.getParameter("IMG_RGS_FLAG_ID2");
String IMG_RGS_FLAG_ID4 = request.getParameter("IMG_RGS_FLAG_ID4");
String PRD_SPC_TP       = request.getParameter("PRD_SPC_TP");
String FILE_NAME 		= request.getParameter("FILE_NAME");
String FILE_ADDR 		= "";
/*
if("01".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "D:\\IMG_UPLOAD\\01" ;
else if("02".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "D:\\IMG_UPLOAD\\02" ;
else if("03".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "D:\\IMG_UPLOAD\\03" ;
else if("04".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "D:\\IMG_UPLOAD\\04" ;
else if("05".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "D:\\IMG_UPLOAD\\05" ;
*/
if("01".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "/APP/WAS/FILES/C10/01" ;
else if("02".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "/APP/WAS/FILES/C10/02" ;
else if("03".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "/APP/WAS/FILES/C10/03" ;
else if("04".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "/APP/WAS/FILES/C10/04" ;
else if("05".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "/APP/WAS/FILES/C10/05" ;
else if("06".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "/APP/WAS/FILES/C10/06" ;
else if("07".equals(IMG_RGS_FLAG))  
	FILE_ADDR = "/APP/WAS/FILES/C10/07" ;

try{
	File file = new File(FILE_ADDR , FILE_NAME);
	
	if(file.exists()){
		file.delete();
	}
	

	
	PosContext ctx = new PosContext();
	ctx.put("IMG_RGS_FLAG"		, IMG_RGS_FLAG);  //06
	ctx.put("IMG_RGS_FLAG_ID"	, IMG_RGS_FLAG_ID);  //W4720
	ctx.put("IMG_RGS_FLAG_ID1"	, IMG_RGS_FLAG_ID1);
	ctx.put("IMG_RGS_FLAG_ID2"	, IMG_RGS_FLAG_ID2); //101257
	ctx.put("IMG_RGS_FLAG_ID4"	, IMG_RGS_FLAG_ID4);
	ctx.put("FILE_ADDR"			, FILE_ADDR);	
	ctx.put("FILE_NAME"			, FILE_NAME);	
	ctx.put("SEQ"				, SEQ);
	ctx.put("PRD_SPC_TP"		, PRD_SPC_TP);	
	ctx.put("DELETE_FLAG"		, "Y");	
	ctx.put("ObjectId"			, userNo);
	
	C10FileUpload4 fileUploead = new C10FileUpload4();
	fileUploead.runActivity(ctx);
}catch (Exception e){
	e.printStackTrace();
} 
%>


