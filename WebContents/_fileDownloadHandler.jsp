<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=euc-kr"  pageEncoding="EUC-KR" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.unionsteel.mes.c10.activity.common.C10ConstantsIF" %>
<%
/*
 * @FileName      : _fileDownloadHandler.jsp
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 2013.05.14
 * @LastModifier  : 김규리
 * @LastVersion   : 1.0
 *    2013.05.14   김규리
 *        1.0      최초 생성
 */
	String file_name = request.getParameter(C10ConstantsIF.FILE_NM); // 파일명 받기
	String file_path = request.getParameter(C10ConstantsIF.FILE_ADR);
	response.reset();
	response.setHeader("Content-Type", "application/x-msdownload");
/*	String fileName = URLEncoder.encode(file_name, "UTF-8")
				.replaceAll("\\+", "%20")
				.replaceAll("\\%21", "!")
				.replaceAll("\\%25", "%")
				.replaceAll("\\%28", "(")
				.replaceAll("\\%29", ")")
				.replaceAll("\\%2C", ",")
				.replaceAll("\\%3D", "=")
				.replaceAll("\\%40", "@")
				.replaceAll("\\%29", ")");
	
	response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ";");
*/	

	// RFC 5987 인코딩을 사용하여 파일명 설정
	String encodedFileName = URLEncoder.encode(file_name, "UTF-8")
	    .replaceAll("\\+", "%20")
	    .replaceAll("\\%21", "!")
	    .replaceAll("\\%27", "'")
	    .replaceAll("\\%28", "(")
	    .replaceAll("\\%29", ")")
	    .replaceAll("\\%7E", "~");
	
	String contentDisposition = String.format("attachment; filename*=UTF-8''%s", encodedFileName);
	
	response.setHeader("Content-Disposition", contentDisposition);


		
	File file = new File(file_path + "/" + file_name);
	
	
	
	byte data[] = new byte[(int)file.length()];	
	
	if (file.length()>0 && file.isFile())
	{
		 BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
		 BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
		 int read = 0;
		 while ((read = fin.read(data)) != -1){
		  outs.write(data,0,read);
	 }
	 outs.close();
	 fin.close();
	}
%>