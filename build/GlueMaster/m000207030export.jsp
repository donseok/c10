<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 표준항목 전체List
 * Open Issues    :
 * Change history 
 * @2008-04-02 이진 1.0 최초생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    response.setHeader("Content-Disposition", "attachment;filename=AttrList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.004",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td>no.</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0050",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0021",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></td>
     </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("selDataItemInfoExportResults") : null;
    PosRow row = null;
    int rowCnt = 0;
    if( rowSet!=null ){
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td class="xls"><%=rowCnt+1%></td>
      <td class="xls"><%=row.getAttribute("DATA_ITEM_NAME")==null?"":(String)row.getAttribute("DATA_ITEM_NAME")%></td>
      <td class="xls"><%=row.getAttribute("DATA_VAR_ID")==null?"":(String)row.getAttribute("DATA_VAR_ID")%></td>
      <td class="xls"><%=row.getAttribute("SYS_TP")==null?"":(String)row.getAttribute("SYS_TP")%></td>
      <td class="xls"><%=row.getAttribute("CHAIN_CODE")==null?"":(String)row.getAttribute("CHAIN_CODE")%></td>
      <td class="xls"><%=row.getAttribute("CHAIN_NM")==null?"":(String)row.getAttribute("CHAIN_NM")%></td>
      <td class="xls"><%=row.getAttribute("DATA_TYPE")==null?"":(String)row.getAttribute("DATA_TYPE")%></td>
      <td class="xls"><%=row.getAttribute("DATA_NUMBER")==null?"":row.getAttribute("DATA_NUMBER").toString()%></td>
      <td class="xls"><%=row.getAttribute("DECIMAL_NUMBER")==null?"":row.getAttribute("DECIMAL_NUMBER").toString()%></td>
      <td class="xls"><%=row.getAttribute("DATA_UNIT")==null?"":(String)row.getAttribute("DATA_UNIT")%></td>
      <td class="xls"><%=row.getAttribute("CODE_YN1")==null?"":(String)row.getAttribute("CODE_YN1")%></td>
      <td class="xls"><%=row.getAttribute("KOR_ABBR")==null?"":(String)row.getAttribute("KOR_ABBR")%></td>
      <td class="xls"><%=row.getAttribute("REGISTER_DATE_STR")==null?"":(String)row.getAttribute("REGISTER_DATE_STR")%></td>
    </tr><%
            rowCnt++;
        }
    }
%>
  </table>
  <br>
</body>
</html>