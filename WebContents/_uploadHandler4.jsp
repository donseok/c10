<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="com.scand.fileupload.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.unionsteel.mes.c10.activity.common.C10FileUpload4" %>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
PosUser	user		= (PosUser)session.getAttribute(PosSecurityConstants.USER);
String		userNo	= "";
String		userName= "";
if(user != null) {
	userNo 	= (String)user.getUserInfo("USER_NO");
	userName= (String)user.getUserInfo("USER_NAME");
}
if(userNo == null || "".equals(userNo)) userNo = "C10USER";

String IMG_RGS_TP = "", IMG_RGS_FLAG = "", IMG_RGS_FLAG_ID = "", FILE_ADDR = "", IMG_RGS_FLAG_ID2 = "";
String IMG_RGS_FLAG_ID3 = "" , IMG_RGS_FLAG_ID4 = "", IMG_RGS_FLAG_ID1 = "";
String PRD_SPC_TP="";
// Check that we have a file upload request
boolean isMultipart = FileUpload.isMultipartContent(request);
if (!isMultipart) {
	out.println ("Use multipart form to upload a file!");
} else {
	String fileId = request.getParameter("sessionId").toString().trim();
	String org_file_name[] = request.getParameterValues("fileName");  
 
	// Create a new file upload handler
	FileItemFactory factory = new ProgressMonitorFileItemFactory(request, fileId);
	ServletFileUpload upload = new ServletFileUpload(factory);
	upload.setHeaderEncoding("utf-8");
	
	// Parse the request
	List /* FileItem */ items = upload.parseRequest(request);
	
	// 등록위치를 확인해 업로드 폴더 지정
	Iterator fIter = items.iterator();	
	while (fIter.hasNext()) {
		FileItem 	fitem 		= (FileItem)fIter.next();
		String 		f_field_name= fitem.getFieldName();		
		if (fitem.isFormField()) {
			if("IMG_RGS_FLAG".equals(f_field_name))  	IMG_RGS_FLAG 	= fitem.getString();	
			if("IMG_RGS_TP".equals(f_field_name)) 		IMG_RGS_TP 		= fitem.getString();
        	if("IMG_RGS_FLAG_ID".equals(f_field_name))	IMG_RGS_FLAG_ID = fitem.getString();
        	if("IMG_RGS_FLAG_ID1".equals(f_field_name))	IMG_RGS_FLAG_ID1 = fitem.getString();
        	if("IMG_RGS_FLAG_ID2".equals(f_field_name))	IMG_RGS_FLAG_ID2 = fitem.getString();
        	if("IMG_RGS_FLAG_ID3".equals(f_field_name))	IMG_RGS_FLAG_ID3 = fitem.getString();
        	if("IMG_RGS_FLAG_ID4".equals(f_field_name))	IMG_RGS_FLAG_ID4 = fitem.getString();
        	if("PRD_SPC_TP".equals(f_field_name))	    PRD_SPC_TP       = fitem.getString();
		}
	}

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
	else if("07".equals(IMG_RGS_FLAG))  
		FILE_ADDR = "/APP/WAS/FILES/C10/07" ;
	
	// Process the uploaded items
	Iterator iter = items.iterator();	
	while (iter.hasNext()) {
		FileItem item = (FileItem) iter.next();
		String fieldName = item.getFieldName();		
		String fileName = "";
		if (item.isFormField()) {
        	
    	} else {
        	//processUploadedFile		
			fileName = item.getName();
			int i2 = fileName.lastIndexOf("\\");
			if(i2>-1) fileName = fileName.substring(i2+1);
			File dirs = new File(FILE_ADDR);
			if(!dirs.exists()) dirs.mkdirs();		
			for(int i=0; i<org_file_name.length; i++){
				if(org_file_name[i].toLowerCase().equals(fileName))
					fileName = org_file_name[i];
			}
			File uploadedFile = new File(dirs,fileName);
			item.write(uploadedFile);
	      
			session.setAttribute("FileUpload.Progress."+fileId,"-1");
			
			PosContext ctx = new PosContext();
			ctx.put("IMG_RGS_TP"		, IMG_RGS_TP);
			ctx.put("IMG_RGS_FLAG"		, IMG_RGS_FLAG);
			ctx.put("IMG_RGS_FLAG_ID"	, IMG_RGS_FLAG_ID);
			ctx.put("IMG_RGS_FLAG_ID1"	, IMG_RGS_FLAG_ID1);
			ctx.put("IMG_RGS_FLAG_ID2"	, IMG_RGS_FLAG_ID2);
			ctx.put("IMG_RGS_FLAG_ID4"	, IMG_RGS_FLAG_ID4);
			ctx.put("FILE_ADDR"			, FILE_ADDR);	
			ctx.put("FILE_NAME"			, fileName);	
			ctx.put("ObjectId"			, userNo);
			ctx.put("PRD_SPC_TP"	    , PRD_SPC_TP);
			
			C10FileUpload4 fileUploead = new C10FileUpload4();
			fileUploead.runActivity(ctx);
    	}		
 	}
}  
%>