<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 업무기준 목록 >> 업무기준 JCS 동기화
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20030801
 * @Author        : 김연기
 * @LastModifier  : 김연기
 * @LastVersion   :  1.0
 *    2003-08-01   김연기
 *        1.0      최초 생성
 *        1.1      부분/부서/담당자 조회기능추가
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.048",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no" onload="">
<table width="420" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.048",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td size=10><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly class=adb1 size=37 value="<%=request.getParameter("MdlDefineNm")== null?"":request.getParameter("MdlDefineNm")%>" height=18></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=center><%=ctx.get("JCS_result")%></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=center>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>