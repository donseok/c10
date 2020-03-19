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
 * @FileName      : 조건판단 데이타 ExcelExport
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080328
 * @Author        : 설계자
 * @LastModifier  : 류진영
 * @LastVersion   :  1.1
 *    2008-03-28   류진영
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosRowSet rowSet = (PosRowSet)ctx.get("Rule010HeaderRowResult");
    PosRow headerRow = rowSet.next();

    response.setHeader("Content-Disposition", "attachment;filename=RuleData("+headerRow.getAttribute("MD_RULE_NM")+").xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");

    int keyCnt = 0, dataCnt = 0;
    rowSet = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    PosRow row;
    while(rowSet.hasNext())
    {
        row = rowSet.next();
        if("I".equals(row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")))
        {
            keyCnt++;
        }else
        {
            dataCnt++;
        }
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.062",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class=tbldb>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td colspan=3><%=PosContext.getResourceMessage("GMResource","gm.label.0185",null,locale)%></td>
    </tr>
    <tr align=center>
      <td class="xls"><%=headerRow.getAttribute("MD_RULE_NM")%></td>
      <td class="xls"><%=headerRow.getAttribute("MD_RULE_VERSION")%></td>
      <td class="xls"><%=headerRow.getAttribute("MASTER_DATA_PRC_TP")%></td>
      <td class="xls"><%=headerRow.getAttribute("USE_TP")%></td>
      <td class="xls"><%=headerRow.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td class="xls" colspan=3><%=headerRow.getAttribute("MD_RULE_EXPLAIN")%></td>
    </tr>
  </table>
  <table border=1>
    <tr class="tbldb">
      <td rowspan=3>no.</td>
      <td rowspan=3><%=PosContext.getResourceMessage("GMResource","gm.label.0162",null,locale)%></td>
      <td colspan=<%=keyCnt*3%>><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
      <td colspan=<%=dataCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td>
    </tr>
    <tr class=tbldb><%

    rowSet.reset();
    while(rowSet.hasNext()){
        row = rowSet.next();
        if("I".equals(row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F"))){
%>
    <td colspan=3><%= row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS") %></td><%
        }else{
%>
    <td rowspan=2><%= row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS") %></td><%
        }
    }

%>
    </tr>
    <tr class=tbllb><%        for(int i=0;i<keyCnt;i++){%>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%></td><% } %>
    </tr><%

    rowSet = (PosRowSet)ctx.get("DecisionRuleDataRowResultException");
    if(rowSet.hasNext()){
        row = rowSet.next();

%>
    <tr class=tbcy>
      <td class="xls">0</td>
      <td class="xls"><%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%></td>
      <td class="xls" colspan=<%=keyCnt*3%>><%=PosContext.getResourceMessage("GMResource","gm.msg.0042",null,locale)%></td><%
        for(int i=0;i<dataCnt;i++){
%>
      <td class="xls"><%= row.getAttribute("MD_RULE_DECISION_RST"+String.valueOf(i+1))==null?"":(String)row.getAttribute("MD_RULE_DECISION_RST"+String.valueOf(i+1)) %></td><%
        }
    }
%>
    </tr><%

        int rowCnt = 0;
        rowSet = (PosRowSet)ctx.get("DecisionRuleDataRowResult");
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class=<%=(rowCnt%2==1?"tblcg":"tblcw")%>>
      <td class="xls"><%=rowCnt+1%></td>
      <td class="xls"><%= row.getAttribute("MD_RULE_CON_DO_SEQ")==null?"":row.getAttribute("MD_RULE_CON_DO_SEQ").toString() %></td><%
            for(int i=0;i<keyCnt;i++){
%>
      <td class="xls"><%= row.getAttribute("MD_RULE_CON_OLSTATR_"+String.valueOf(i+1))==null?"":(String)row.getAttribute("MD_RULE_CON_OLSTATR_"+String.valueOf(i+1)) %></td>
      <td class="xls"><%= row.getAttribute("MD_RULE_CON_MI_V_"+String.valueOf(i+1))==null?"":(String)row.getAttribute("MD_RULE_CON_MI_V_"+String.valueOf(i+1)) %></td>
      <td class="xls"><%= row.getAttribute("MD_RULE_CON_MAX_V_"+String.valueOf(i+1))==null?"":(String)row.getAttribute("MD_RULE_CON_MAX_V_"+String.valueOf(i+1)) %></td><%
            }
            for(int i=0;i<dataCnt;i++){
%>
      <td class="xls"><%= row.getAttribute("MD_RULE_DECISION_RST"+String.valueOf(i+1))==null?"":(String)row.getAttribute("MD_RULE_DECISION_RST"+String.valueOf(i+1)) %></td><%
            }
            rowCnt++;
        }
%>
    </tr>
  </table>
  <table>
    <tr>
      <td>END!</td>
    </tr>
  </table><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> </b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>1A0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale)%>)
<b>1A1</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0137",null,locale)%>)
<b>1A2</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0075",null,locale)%>)
<b>1B0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0191",null,locale)%>)
<b>1B1</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0151",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%> : </b>
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%>)
<b>F</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%>)
<b>Y</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%>)
<b>N</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%>)<br>
※ <b>no. : </b>
<b>0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%>), 1,2,3.. data 순서<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%> : </b>
<b>NOT_CHECK</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0153",null,locale)%>)
<b>=</b>(=)
<b>!=</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0154",null,locale)%>)
<b>></b>(&gt;)
<b>>=</b>(&gt;=)
<b><</b>(&lt;)
<b><=</b>(&lt;=)<br>&nbsp;&nbsp;&nbsp;&nbsp;
<b>BETWEEN1</b>(&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=)
<b>BETWEEN2</b>(&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;)
<b>BETWEEN3</b>(&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=)
<b>BETWEEN4</b>(&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;)<br>&nbsp;&nbsp;&nbsp;&nbsp;
<b>LIKE1</b>(%LIKE%)
<b>LIKE2</b>(%LIKE)
<b>LIKE3</b>(LIKE%)<br>&nbsp;&nbsp;&nbsp;&nbsp;
<b>IN</b>(in)
<b>NOT_IN</b>(not in)
<b>NOT_NULL</b>(not null)
<b>IS_NULL</b>(is null)<br>
</body>
</html>