<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="com.scand.fileupload.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%
//String deleteFolder = "c:\\upload\\";
String deleteFolder = "/APP/WAS/FILES/C10/";
 try{
		String fileName = request.getParameter("fileName")!=null ? request.getParameter("fileName") : "";	

		File file = new File(deleteFolder,fileName);
		 if(file.exists()){
			if (file.delete()) {
				System.out.println("File delete successful");
			} else {
				System.out.println("File delete fail");
			}
		 }

		// End Try
 }catch (Exception e){
	e.printStackTrace();
} 
%>

