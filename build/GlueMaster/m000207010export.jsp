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
 * @FileName      : 표준용어 전체List  Export
 * Open Issues    :
 * Change history 
 * @2008-05-07 류진영 1.0 최초생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    response.setHeader("Content-Disposition", "attachment;filename=TermsInfoList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");

    List termSectionList = (List) ctx.get("_SYS_V_TERMS_SECTION");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.001",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td>no.</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0050",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0254",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></td>
     </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("selTermsInfoListExportResults") : null;
    PosRow row = null;
    int rowCnt = 0;
    if( rowSet!=null ){
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td class="xls"><%=rowCnt+1%></td>
      <td class="xls"><%=row.getAttribute("SYS_TP")==null?"":(String)row.getAttribute("SYS_TP")%></td>
      <td class="xls"><%=row.getAttribute("CHAIN_NM")==null?"":(String)row.getAttribute("CHAIN_NM")%></td>
      <td class="xls"><%=row.getAttribute("TERMS_NAME")==null?"":(String)row.getAttribute("TERMS_NAME")%></td>
      <td class="xls"><%=row.getAttribute("ENG_FULL_NAME")==null?"":(String)row.getAttribute("ENG_FULL_NAME")%></td>
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