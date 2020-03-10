<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="com.scand.fileupload.*" %>
<%@ page import="com.unionsteel.mes.c10.activity.common.C10FileUpload" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%

String uploadFolder = "/APP/WAS/FILES/C10/";
//String uploadFolder = "C://Tmp//";
String PAGE_ID = "";
String QLT_IMV_REQ_NO = "";

// Check that we have a file upload request
boolean isMultipart = FileUpload.isMultipartContent(request);

if (!isMultipart) {

	out.println ("Use multipart form to upload a file!");

} else {

String fileId = request.getParameter("sessionId").toString().trim();
        
// Create a new file upload handler
FileItemFactory factory = new ProgressMonitorFileItemFactory(request, fileId);
ServletFileUpload upload = new ServletFileUpload(factory);
upload.setHeaderEncoding("UTF-8");
// Parse the request
List /* FileItem */ items = upload.parseRequest(request);

	Iterator fIter = items.iterator();	
	while (fIter.hasNext()) {
		FileItem 	fitem 		= (FileItem)fIter.next();
		String 		f_field_name= fitem.getFieldName();		
		if (fitem.isFormField()) {
			if("PAGE_ID".equals(f_field_name))  	PAGE_ID 	= fitem.getString();
			else if("QLT_IMV_REQ_NO".equals(f_field_name))  	QLT_IMV_REQ_NO 	= fitem.getString();
		}
	}
	
// Process the uploaded items
Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (item.isFormField()) {
        //processFormField
    } else {
        //processUploadedFile
		String fieldName = item.getFieldName();
		String fileName = item.getName();
		int i2 = fileName.lastIndexOf("\\");
		if(i2>-1) fileName = fileName.substring(i2+1);
		File dirs = new File(uploadFolder);
		//if(dirs.isDirectory()) {
			dirs.mkdirs();
		//}
		File uploadedFile = new File(dirs,fileName);
		if(uploadedFile.exists()){
			if (uploadedFile.delete()) {
				System.out.println("File delete successful");
			} else {
				System.out.println("File delete fail");
			}
		}
		item.write(uploadedFile);
      
		session.setAttribute("FileUpload.Progress."+fileId,"-1");
		session.setAttribute("FileUpload.fileName",fileName);
		
    if(PAGE_ID!=null && !"".equals(PAGE_ID)){
      			PosContext ctx = new PosContext();
			ctx.put("QLT_IMV_REQ_NO"		, QLT_IMV_REQ_NO);
			ctx.put("IMG_ADR"			, uploadFolder);	
			ctx.put("IMG_NM"			, fileName);	
			
			C10FileUpload fileUploead = new C10FileUpload();
			fileUploead.runActivity(ctx);
      }
    }
 }

}  
%>

