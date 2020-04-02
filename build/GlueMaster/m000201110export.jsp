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
 * @FileName      : 트랜잭션 목록(Export)
 * Open Issues    :
 * Change history 
 * @2008-03-07 서정범 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");

    response.setHeader("Content-Disposition", "attachment;filename=MasterCodeList_Tran.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.037",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td rowspan=2>no.</td>
      <td colspan=7><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td colspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
    </tr>
    <tr class="tbllb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0131",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("CodeListVOResult") : null;
    PosRow row = null;
    if( rowSet!=null ){
        int rowCnt = 0;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td class="xls"><%=(rowCnt+1)%></td>
      <td class="xls"><%=row.getAttribute("USE_TP")==null?"":(String)row.getAttribute("USE_TP")%></td>
      <td class="xls" align="left"><%=row.getAttribute("CD_TP_MEANING")==null?"":(String)row.getAttribute("CD_TP_MEANING")%></td>
      <td class="xls" align="left"><%=row.getAttribute("CD_TP")==null?"":(String)row.getAttribute("CD_TP")%></td>
      <td class="xls" align="left"><%=row.getAttribute("M_CD_TP_MEANNING")==null?"":(String)row.getAttribute("M_CD_TP_MEANNING")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_OP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OP_TP")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_OWNER_SHIP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP")%></td>
      <td class="xls"><%=row.getAttribute("USER_NAME")==null?"":(String)row.getAttribute("USER_NAME")%></td>
      <td class="xls"><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td class="xls"><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
    </tr><%
            rowCnt++;
        }
    }
%>
  </table><br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0190",null,locale)%>)  
<b>C</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0065",null,locale)%>)  
<b>R</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0170",null,locale)%>)<br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%> : </b><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        Object[] value = (Object[]) HierarchyOpTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%> : </b><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        Object[] value = (Object[]) HierarchyOwnerShipTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>
</body>
</html>