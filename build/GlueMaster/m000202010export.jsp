<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
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
 * @FileName      : 업무기준 목록(Export)
 * Open Issues    :
 * Change history 
 * @2008-03-10 류진영 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    HashMap<String, String> HierarchyOpTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
        HierarchyOpTpMap.put(value[0], value[1]);
    }
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");
    HashMap<String, String> HierarchyOwnerShipTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
        HierarchyOwnerShipTpMap.put(value[0], value[1]);
    }

    response.setHeader("Content-Disposition", "attachment;filename=RuleList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.046",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0115",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
      <td>[데이타종류]</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%>(<%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%>)</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%>(<%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%>)</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
     </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("BusinessRuleList") : null;
    PosRow row = null;
    if( rowSet!=null ){
        int rowCnt = 0;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td class="xls"><%=row.getAttribute("MASTER_DATA_PRC_TP")==null?"":(String)row.getAttribute("MASTER_DATA_PRC_TP")%></td>
      <td class="xls"><%=row.getAttribute("MD_NM")==null?"":(String)row.getAttribute("MD_NM")%></td>
      <td class="xls" align="left"><%=row.getAttribute("MD_EXPLAIN")==null?"":(String)row.getAttribute("MD_EXPLAIN")%></td>
      <td class="xls"><%=row.getAttribute("VERSION")==null?"":(String)row.getAttribute("VERSION")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_OP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OP_TP")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_OWNER_SHIP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP")%></td>
      <td class="xls"><%=row.getAttribute("OWNER_EMP_NO")==null?"":(String)row.getAttribute("OWNER_EMP_NO")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_WKS_SHARE_L")==null?"":(String)row.getAttribute("HIERARCHY_WKS_SHARE_L")%></td>
      <td class="xls"><%=row.getAttribute("CNG_GD")==null?"":(String)row.getAttribute("CNG_GD")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_DATA_ATTR")==null?"":(String)row.getAttribute("HIERARCHY_DATA_ATTR")%></td>
      <td><%=HierarchyOpTpMap.get((String)row.getAttribute("HIERARCHY_OP_TP"))%></td>
      <td><%=HierarchyOwnerShipTpMap.get((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))%></td>
      <td class="xls"><%=row.getAttribute("USER_NAME")==null?"":(String)row.getAttribute("USER_NAME")%></td>
      <td class="xls"><%=row.getAttribute("USE_TP")==null?"":(String)row.getAttribute("USE_TP")%></td>
      <td class="xls"><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td class="xls"><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
    </tr><%
            rowCnt++;
        }
    }else if("import".equals(request.getParameter("export"))){
%>
    <tr class="tblcw"><td class="xls">1A0</td><td class="xls">RG#A0001</td><td class="xls">환율적용기준</td><td class="xls">1.0</td><td class="xls">ZZ</td><td class="xls">Z</td><td class="xls">MASTDATA</td><td class="xls">A</td><td class="xls">A</td><td class="xls">A</td></tr>
    <tr class="tblcg"><td class="xls">1A1</td><td class="xls">RG#B0001</td><td class="xls">연도별 제품목표기준</td><td class="xls">1.0</td><td class="xls">ZZ</td><td class="xls">Z</td><td class="xls">MASTDATA</td><td class="xls">A</td><td class="xls">A</td><td class="xls">A</td></tr>
    <tr class="tblcw"><td class="xls">1A2</td><td class="xls">RG#C0001</td><td class="xls">등급기준</td><td class="xls">1.0</td><td class="xls">ZZ</td><td class="xls">Z</td><td class="xls">MASTDATA</td><td class="xls">A</td><td class="xls">A</td><td class="xls">A</td></tr>
    <tr class="tblcg"><td class="xls">1B0</td><td class="xls">RD#A0001</td><td class="xls">토익스피킹Level기준</td><td class="xls">1.0</td><td class="xls">ZZ</td><td class="xls">Z</td><td class="xls">MASTDATA</td><td class="xls">A</td><td class="xls">A</td><td class="xls">A</td></tr>
    <tr class="tblcw"><td class="xls">1B1</td><td class="xls">RD#B0001</td><td class="xls">BMI(비만도)기준</td><td class="xls">1.0</td><td class="xls">ZZ</td><td class="xls">Z</td><td class="xls">MASTDATA</td><td class="xls">A</td><td class="xls">A</td><td class="xls">A</td></tr><%
    }
%>
  </table>
  <table>
    <tr>
      <td>END!</td>
    </tr>
  </table><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> : A~J 컬럼 필수  </b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>1A0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale)%>)
<b>1A1</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0137",null,locale)%>)
<b>1A2</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0075",null,locale)%>)
<b>1B0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0191",null,locale)%>)
<b>1B1</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0151",null,locale)%>)<br>
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
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0115",null,locale)%> : </b>
<b>A</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0235",null,locale)%>)
<b>Z</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0195",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%> : </b>
<b>A</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale)%>)
<b>B</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale)%>)<br>
※ <b>[데이타종류] : </b>
<b>A</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0165",null,locale)%>)
<b>B</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0166",null,locale)%>)
<b>C</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0263",null,locale)%>)
<b>D</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0189",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%> : </b>
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%>)
<b>Y</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%>)
<b>N</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%>)
<b>F</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%>)<br>
</body>
</html>