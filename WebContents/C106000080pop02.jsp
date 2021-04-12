<%--
 * PROGRAM NAME     :  C106000080pop02.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  프린트 롤 이미지 조회
 * DESIGNER NAME    :  이 돈 석
 * DEVELOPER NAME   :  이 돈 석
 * CREATE DATE      :  2013.10.01
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2013.10.01     V1.0      이돈석      Initial Version
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String rowIdx 				= request.getParameter("rowIdx");
String grid 					= request.getParameter("grid");
String img_rgs_flags 	= request.getParameter("img_rgs_flags");
String imgnm				= request.getParameter("imgnm");
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<title>Upload Control</title>
<style>
#Table1{
	border: solid 1px #b1daef;
	empty-cells: show;
	border-collapse: collapse;
}
.td1{
	padding: 4px;
	border: 1px solid #E3EDF5;
	overflow: hidden;
	font-size: 14px;
	font-weight: normal;
}
</style>
<script language="javascript">
	function viewImg(){
		var str = "", link_name = "", imgnm = "";
		
		if("<%=img_rgs_flags%>" == "01")  link_name = "rmtlimgdown";
		else if("<%=img_rgs_flags%>" == "03")  link_name = "cusspcimgdown";
		else if("<%=img_rgs_flags%>" == "04")  link_name = "coilimgdown";
		else if("<%=img_rgs_flags%>" == "05")  link_name = "cusvisitimgdown";
		else if("<%=img_rgs_flags%>" == "08")  link_name = "digimgdown";
		
		imgnm = "<%=imgnm%>";
		
		str += "<img src='/C10/"+link_name+"?file="+imgnm+"' alt='"+imgnm+"'>";
		
		document.getElementById('imgCon').innerHTML = str;
	}
</script>
</head>
<body onLoad="viewImg()">
	<div id="imgCon"></div>
</body>
</html>
