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
 * Copyright(c) 2010 posco ict
 * @FileName      : 계산식 목록(Export)
 * Open Issues    :
 * Change history 
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");

    /* 엑셀용 추가*/
    if("fomula".equals(request.getParameter("import")))
    {
    response.setHeader("Content-Disposition", "attachment;filename=CalcFomula.xls");  //엑셀파일명 지정
    }else if("input".equals(request.getParameter("import")))
    {
    response.setHeader("Content-Disposition", "attachment;filename=CalcFomulaInput.xls");  //엑셀파일명 지정
    }else
    {
    response.setHeader("Content-Disposition", "attachment;filename=CalcList.xls");  //엑셀파일명 지정
    }
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.074",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"><%

    if("fomula".equals(request.getParameter("import")))
    {

%>
  <table border=1>
    <tr class="tbldb">
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
      <td colspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0183",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
      <td colspan=4><%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0094",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
    </tr>
    <tr class="tbllb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0245",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0159",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0074",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></td>
    </tr>
    <tr class="tblcw"><td>C</td><td>CAL#A001</td><td>구구단</td><td></td><td>0</td><td></td><td>1C0</td><td></td><td></td><td>V1*V2</td><td>V1 between 1 and 9 AND V2 between 1 and 9</td><td>MASTDATA</td><td>ZZ</td><td>Z</td><td>1.0</td></tr>
    <tr class="tblcg"><td>C</td><td>CAL#B001</td><td>근로소득공제</td><td>C</td><td>4</td><td></td><td>1C2</td><td>1</td><td>V1<=500</td><td>V1*80/100</td><td>V1>0</td><td>MASTDATA</td><td>ZZ</td><td>Z</td><td>1.0</td></tr>
    <tr class="tblcw"><td>C</td><td>CAL#B001</td><td>근로소득공제</td><td>C</td><td>4</td><td></td><td>1C2</td><td>2</td><td>V1>500 AND V<=1500</td><td>V1*80/100</td><td>V1>0</td><td>MASTDATA</td><td>ZZ</td><td>Z</td><td>1.0</td></tr>
    <tr class="tblcg"><td>C</td><td>CAL#B001</td><td>근로소득공제</td><td>C</td><td>4</td><td></td><td>1C2</td><td>3</td><td>V1>1500 AND V<=3000</td><td>V1*80/100</td><td>V1>0</td><td>MASTDATA</td><td>ZZ</td><td>Z</td><td>1.0</td></tr>
    <tr class="tblcw"><td>C</td><td>CAL#B001</td><td>근로소득공제</td><td>C</td><td>4</td><td></td><td>1C2</td><td>4</td><td>V1>3000 AND V<=4500</td><td>V1*80/100</td><td>V1>0</td><td>MASTDATA</td><td>ZZ</td><td>Z</td><td>1.0</td></tr>
    <tr class="tblcg"><td>C</td><td>CAL#B001</td><td>근로소득공제</td><td>C</td><td>4</td><td></td><td>1C2</td><td>5</td><td>V1>4500</td><td>V1*80/100</td><td>V1>0</td><td>MASTDATA</td><td>ZZ</td><td>Z</td><td>1.0</td></tr>
  </table>
  <table border=1>
    <tr class="tblcw"><td>END!</td></tr>
  </table>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%> : </b>
<b>C</b>(신규)
<b>U</b>(수정)
<b>D</b>(사용종료)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0183",null,locale)%> : </b>
<b>R</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0184",null,locale)%>)
<b>C</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0221",null,locale)%>)
<b>U</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0251",null,locale)%>)
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0264",null,locale)%>)
<b>J</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0265",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>1C0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0192",null,locale)%>)
<b>1C2</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%> : </b><%
        for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
            Object[] value = (Object[]) HierarchyOwnerShipTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
        }
%><br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%> : </b><%
        for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
            Object[] value = (Object[]) HierarchyOpTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
        }
%><br><%

    }else if("input".equals(request.getParameter("import")))
    {

%>
  <table border=1>
    <tr class="tbldb">
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
      <td colspan=8>항목정보</td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0245",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
      <td colspan=5><%=PosContext.getResourceMessage("GMResource","gm.label.0097",null,locale)%></td>
    </tr>
    <tr class="tbllb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0037",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0159",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0178",null,locale)%></td>
    </tr>
    <tr class="tblcw"><td>CAL#A001</td><td>1.0</td><td>1</td><td>EDU_NUM_N1</td><td>변수1   </td><td>N</td><td></td><td>2</td><td>3</td><td>0</td><td>I</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
    <tr class="tblcw"><td>CAL#A001</td><td>1.0</td><td>2</td><td>EDU_NUM_N2</td><td>변수2   </td><td>N</td><td></td><td>2</td><td>3</td><td>0</td><td>I</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
    <tr class="tblcw"><td>CAL#B001</td><td>1.0</td><td>1</td><td>EDU_NUM_N3</td><td>총급여액</td><td>N</td><td></td><td>2</td><td>3</td><td>4</td><td>I</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
  </table>
  <table border=1>
    <tr class="tblcg"><td>END!</td></tr>
  </table>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%> : </b>
<b>Y</b>
<b>N</b><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%> : </b>
<b>1</b>(STRING)
<b>2</b>(NUMBER)
<b>3</b>(DATE)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0245",null,locale)%> : </b>
<b>I</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>)
<b>F</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0097",null,locale)%>)
<b>M</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0186",null,locale)%>)
<b>C</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0081",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%> : </b>
<b>DEFAULT</b>(DEFAULT)
<b>=</b>(=)
<b>!=</b>(!=)
<b><</b>(<)
<b><=</b>(<=)
<b>></b>(>)
<b>>=</b>(>=)
<b><=BETWEEN<=</b>(<=BETWEEN<=)
<b><BETWEEN<=</b>(<BETWEEN<=)
<b><=BETWEEN<</b>(<=BETWEEN<)
<b><BETWEEN<</b>(<BETWEEN<)
<b>%LIKE%</b>(%LIKE%)
<b>LIKE%</b>(LIKE%)
<b>%LIKE</b>(%LIKE)
<b>IN</b>(IN)
<b>NOT_IN</b>(NOT_IN)<br><%

    }else
    {

%>
  <table border=1>
    <tr class="tbldb">
      <td>no.</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%

        PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("CalcSelectListVOResult") : null;
        int rowCnt = 0;
        if( rowSet!=null ){
            PosRow row = null;
            while(rowSet.hasNext()){
                row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td><%=(rowCnt+1)%></td>
      <td><%=row.getAttribute("MASTER_DATA_PRC_TP")==null?"":(String)row.getAttribute("MASTER_DATA_PRC_TP")%></td>
      <td><%=row.getAttribute("USE_TP")==null?"":(String)row.getAttribute("USE_TP")%></td>
      <td align="left"><%=row.getAttribute("MD_RULE_EXPLAIN")==null?"":(String)row.getAttribute("MD_RULE_EXPLAIN")%></td>
      <td><%=row.getAttribute("MD_RULE_NM")==null?"":(String)row.getAttribute("MD_RULE_NM")%></td>
      <td><%=row.getAttribute("HIERARCHY_OP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OP_TP")%></td>
      <td><%=row.getAttribute("HIERARCHY_OWNER_SHIP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP")%></td>
      <td><%=row.getAttribute("MD_RULE_OWNER_EMP_NO")==null?"":(String)row.getAttribute("MD_RULE_OWNER_EMP_NO")%></td>
      <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
    </tr><%
                rowCnt++;
            }
        }
%>
  </table>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%> : </b>
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%>)
<b>F</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%>)
<b>Y</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%>)
<b>N</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%>)<br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>1C0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0192",null,locale)%>)
<b>1C2</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale)%>)<br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%> : </b><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        Object[] value = (Object[]) HierarchyOwnerShipTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%> : </b><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        Object[] value = (Object[]) HierarchyOpTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br><%
    }
%>
</body>
</html>