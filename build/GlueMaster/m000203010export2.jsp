<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * Copyright(c) 2010 posco ict
 * @FileName      : import용 계산식 목록(Export)
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20100413
 * @LastModifier  : 조창희
 * @LastVersion   : 1.0
 *    2010-04-13  조창희   
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");

    /* 엑셀용 추가*/
    if("fomula".equals(request.getParameter("export2")))
    {
    response.setHeader("Content-Disposition", "attachment;filename=CalcFomula.xls");  //엑셀파일명 지정
    }else
    {
    response.setHeader("Content-Disposition", "attachment;filename=CalcFomulaInput.xls");  //엑셀파일명 지정
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

    if("fomula".equals(request.getParameter("export2")))
    {

%>
  <table border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
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
    </tr><%

        PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("CalcSelectListVOResult") : null;
        int rowCnt = 0;
        if( rowset!=null ){
            PosRow row = null;
            String tpsdC = "";
            String tpsdT = "";
            while(rowset.hasNext()){
                row = rowset.next();
                if("1C2".equals(row.getAttribute("MASTER_DATA_PRC_TP"))&&"C".equals(row.getAttribute("ACTION_TYPE"))){
                    tpsdC = row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD");   
                }else{
                    String formula = "";
                    if("1C2".equals(row.getAttribute("MASTER_DATA_PRC_TP"))){
                        tpsdT =row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD");
                        formula = row.getAttribute("MD_RULE_DECISION_RST1")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DECISION_RST1");
                    }else{
                        tpsdT = "";
                        formula = row.getAttribute("MD_RULE_OPER_TYPE")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_OPER_TYPE");                       
                        tpsdC = row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD");
                    }
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20">
      <td>U</td>
      <td><%=row.getAttribute("MD_RULE_NM")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_NM")%></td>
      <td><%=row.getAttribute("MD_RULE_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_EXPLAIN")%></td>
      <td><%=row.getAttribute("MD_RULE_CALC_V_ROUND_F")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CALC_V_ROUND_F")%></td>      
      <td><%=row.getAttribute("MD_RULE_CALC_V_DECIMAL_PREC")==null?"&nbsp;":(java.math.BigDecimal)row.getAttribute("MD_RULE_CALC_V_DECIMAL_PREC")%></td>
      <td><%=row.getAttribute("MES_UNIT_OF_MEASURE")==null?"&nbsp;":(String)row.getAttribute("MES_UNIT_OF_MEASURE")%></td>
      <td><%=row.getAttribute("MASTER_DATA_PRC_TP")==null?"&nbsp;":(String)row.getAttribute("MASTER_DATA_PRC_TP")%></td>
      <td><%=row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_NO")==null?"&nbsp;":(java.math.BigDecimal)row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_NO")%></td>
      <td><%=tpsdT%></td>
      <td><%=formula%></td>
      <td><%=tpsdC%></td>
      <td><%=row.getAttribute("MD_RULE_OWNER_EMP_NO")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_OWNER_EMP_NO")%></td>
      <td><%=row.getAttribute("HIERARCHY_OP_TP")==null?"&nbsp;":(String)row.getAttribute("HIERARCHY_OP_TP")%></td>
      <td><%=row.getAttribute("HIERARCHY_OWNER_SHIP_TP")==null?"&nbsp;":(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP")%></td>
      <td><%=row.getAttribute("MD_RULE_VERSION")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_VERSION")%></td>
    </tr><%
                rowCnt++;
                }
            }
        }
%>
  </table>
  <table border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tblcw"><td>END!</td></tr>
  </table>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%> : </b>
<b>C</b>(신규)
<b>U</b>(수정)
<b>D</b>(사용완료)<br>
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

    }else if("input".equals(request.getParameter("export2")))
    {

%>
  <table border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
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
    </tr><%

        PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("CalcSelectListVOResult") : null;
        int rowCnt = 0;
        if( rowset!=null ){
            PosRow row = null;
            while(rowset.hasNext()){
                row = rowset.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20">
      <td><%=row.getAttribute("MD_RULE_NM")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_NM")%></td>
      <td><%=row.getAttribute("MD_RULE_VERSION")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_VERSION")%></td>      
      <td><%=row.getAttribute("MD_RULE_DT_NM_SEQ")==null?"&nbsp;":(BigDecimal)row.getAttribute("MD_RULE_DT_NM_SEQ")%></td>
      <td><%=row.getAttribute("STANDARD_ENGLISH_ID")==null?"&nbsp;":(String)row.getAttribute("STANDARD_ENGLISH_ID")%></td>
      <td><%=row.getAttribute("STANDARD_KOREAN_NAME")==null?"&nbsp;":(String)row.getAttribute("STANDARD_KOREAN_NAME")%></td>
      <td><%=row.getAttribute("MD_RULE_DT_NM_CD_F")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DT_NM_CD_F")%></td>
      <td><%=row.getAttribute("MES_UNIT_OF_MEASURE")==null?"&nbsp;":(String)row.getAttribute("MES_UNIT_OF_MEASURE")%></td>
      <td><%=row.getAttribute("DT_NM_DATA_TP")==null?"&nbsp;":(BigDecimal)row.getAttribute("DT_NM_DATA_TP")%></td>
      <td><%=row.getAttribute("DT_NM_LEN")==null?"&nbsp;":(BigDecimal)row.getAttribute("DT_NM_LEN")%></td>
      <td><%=row.getAttribute("DT_NM_DECIMAL_PREC")==null?"&nbsp;":(BigDecimal)row.getAttribute("DT_NM_DECIMAL_PREC")%></td>
      <td><%=row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")%></td>
      <td><%=row.getAttribute("MD_RULE_DT_NM_DRIVED_V_PROC")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DT_NM_DRIVED_V_PROC")%></td>
      <td><%=row.getAttribute("MD_RULE_DT_NM_BAS_CHK_SEQ")==null?"&nbsp;":(BigDecimal)row.getAttribute("MD_RULE_DT_NM_BAS_CHK_SEQ")%></td>
      <td><%=row.getAttribute("MD_RULE_CHK_OLSTATR_1")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CHK_OLSTATR_1")%></td>
      <td><%=row.getAttribute("MD_RULE_CHK_MI_V_1")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CHK_MI_V_1")%></td>
      <td><%=row.getAttribute("MD_RULE_CHK_MAX_V_1")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CHK_MAX_V_1")%></td>
      <td><%=row.getAttribute("MD_RULE_CHK_MI_V_2")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_CHK_MI_V_2")%></td>
    </tr><%
                rowCnt++;
               
            }
        }
%>
  </table>
  <table border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
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

    }

%>
</body>
</html>