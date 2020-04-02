<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page isErrorPage="true"%>
<html>
<head>
<title>Error Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<style>
table{font-size:12px; font-family:돋움}
</style>
<body>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="middle">
        <table width=550 border="1" align="center" cellpadding="0" cellspacing="0" bordercolorlight="#666666" bordercolordark="#FFFFFF" bgcolor="e5e5e5">
          <tr height=50 valign=middle>
            <td align=center>
              <br><br><font style="font-size:20px;font-weight:bold">▒ &nbsp; E R R O R &nbsp; ▒</font>
              <br><hr width="500" size="3" noshade>
              <div style="position:relative;top:10px;left:5px;width:450px;" bgcolor=blue align=left><font color="#FF0000"><%= exception %></font></div><br>
              <br><hr width="500" size="1" noshade>
              <br><br>페이지를 표시할 수 없습니다.<br>
              <hr width="250" size="1" noshade>
              <img src="img/gmico2002.gif" onClick="javascript:history.back();" style="cursor:pointer"><br><br>
              </td>
          </tr>
        </table>
    </td>
  </tr>
</table>
<%
    String currentTime = com.poscoict.glue.master.common.PosMasterUtility.getCurTime("yyyy-MM-dd HH:mm:ss");
    System.err.println(currentTime + " - Request URI = " + request.getRequestURI());
    System.err.println(currentTime + " - Request User IP Address = " + request.getRemoteHost());
    exception.printStackTrace();
%>
</body>
</html>