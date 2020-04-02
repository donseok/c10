<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 표준용어 목록
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20110628
 * @Author        : 황유진
 * @LastModifier  : 황유진
 * @LastVersion   :  1.0
 *    2010-07-01   다국어 지원
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    response.setHeader("Content-Disposition", "attachment;filename=GlobalTermsInfoList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");

    List termSectionList = (List) ctx.get("_SYS_V_TERMS_SECTION");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.001",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td>no.</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0254",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></td>
     </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("WordList") : null;
    PosRow row = null;
    int rowCnt = 0;
    if( rowSet!=null ){
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td class="xls"><%=rowCnt+1%></td>
      <td class="xls"><%=row.getAttribute("TERMS_NAME")==null?"":(String)row.getAttribute("TERMS_NAME")%></td>
      <td class="xls"><%=row.getAttribute("LANGUAGE_CODE")==null?"":(String)row.getAttribute("LANGUAGE_CODE")%></td>
      <td class="xls"><%=row.getAttribute("STD_TERMS_NAME")==null?"":(String)row.getAttribute("STD_TERMS_NAME")%></td>
      <td class="xls"><%=row.getAttribute("ENG_ID")==null?"":(String)row.getAttribute("ENG_ID")%></td>
      <td class="xls"><%=row.getAttribute("ENG_ABBR")==null?"":(String)row.getAttribute("ENG_ABBR")%></td>
      <td class="xls"><%=row.getAttribute("TERMS_SECTION")==null?"":(String)row.getAttribute("TERMS_SECTION")%></td>
      <td class="xls"><%=row.getAttribute("CHAIN_CODE")==null?"":(String)row.getAttribute("CHAIN_CODE")%></td>
      <td class="xls"><%=row.getAttribute("REGISTER_DATE_STR")==null?"":(String)row.getAttribute("REGISTER_DATE_STR")%></td>
    </tr><%
            rowCnt++;
        }
    }
%>
  </table>
  <br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%> : </b><%
    for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
        Object[] value = (Object[]) termSectionList.get(i);
%><b><%=value[0]%></b>(<%=value[1]%>)<%
    }
%><br>
</body>
</html>