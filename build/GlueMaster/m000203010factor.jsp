<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : Factor 선택
 * Open Issues    :
 * Change history
 * @LastModifyDate: 20080613
 * @LastModifier  : 김정희
  *@LastVersion   : 1.0
 *    2008-06-13   김정희
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.080",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/highlightRow.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no" onload="">
<table width="490" border="0" cellspacing="0" cellpadding="0" align=left >
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top align="center">
      <table width="470" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.080",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.cancel",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- cancel -->
          </td>
        </tr>
      </table>
      <table id=T1 width="470" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
        <tr class="tbldb" height="20">
          <td><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%></td>
          <td width="115"><%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%></td>
          <td width="115"><%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%></td>
          <td width="115"><%=PosContext.getResourceMessage("GMResource","gm.label.0178",null,locale)%></td>
        </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("Rules030FactorVOResult") : null;
    int rowCnt = 0;
    if(rowSet!=null){
        PosRow row=null;;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
        <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,T1) onmouseout=in_ch(1,this,T1)>
          <td><%=row.getAttribute("OLSTATR_CD")==null?"&nbsp;":((String)row.getAttribute("OLSTATR_CD")).replaceAll("<","&lt;").replaceAll(">","&gt;")%></td>
          <td><%=row.getAttribute("MD_RULE_CHK_MI_V_1")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CHK_MI_V_1")%></td>
          <td><%=row.getAttribute("MD_RULE_CHK_MI_V_2")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CHK_MI_V_2")%></td>
          <td><%=row.getAttribute("MD_RULE_CHK_MAX_V_1")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CHK_MAX_V_1")%></td>
        </tr><%
            rowCnt++;
        }
    }
%>
      </table>
    </td>
  </tr>
</table>
</body>
</html>