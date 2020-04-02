<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 연관판단 데이타 조회
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080408
 * @Author        : 설계자
 * @LastModifier  : 류진영
 * @LastVersion   :  1.1
 *    2008-04-08   류진영
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosRowSet rowSet = (PosRowSet)ctx.get("Rule010HeaderRowResult");
    PosRow headerRow = rowSet.next();

    ArrayList alias = new ArrayList();
    ArrayList outAlias = new ArrayList();
    PosRow row;
    rowSet = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    while(rowSet.hasNext())
    {
        row=rowSet.next();
        if("I".equals(row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")))
        {
            alias.add(row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS"));
        }else if("O".equals(row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")))
        {
            outAlias.add(row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS"));
        }
    }

    response.setHeader("Content-Disposition", "attachment;filename=RuleData("+headerRow.getAttribute("MD_RULE_NM")+").xls"); 
    out.clearBuffer(); 
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.065",null,locale)%> [export]</title>
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
      <td colspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0185",null,locale)%></td>
    </tr>
    <tr>
      <td class="xls"><%=headerRow.getAttribute("MD_RULE_NM")%></td>
      <td class="xls"><%=headerRow.getAttribute("MD_RULE_VERSION")%></td>
      <td class="xls"><%=headerRow.getAttribute("MASTER_DATA_PRC_TP")%></td>
      <td class="xls"><%=headerRow.getAttribute("USE_TP")%></td>
      <td class="xls"><%=headerRow.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td class="xls" colspan=2><%=headerRow.getAttribute("MD_RULE_EXPLAIN")%></td>
    </tr>
  </table>
  <table border=1>
    <tr class=tbldb>
      <td rowspan=2>no.</td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0162",null,locale)%></td>
      <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
      <td colspan=<%=outAlias.size()%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td>
    </tr>
    <tr class="tbllb" height="20"><%
            for(int i=0, iz=outAlias.size(); i<iz; i++){
%>
      <td><%=outAlias.get(i)%></td><%
            }
%>
    </tr><%
            rowSet = (PosRowSet)ctx.get("Rules050VO");
            int rowCnt = 0;
            while(rowSet.hasNext())
            {
                row =   rowSet.next();
%>
    <tr class=<%=(rowCnt%2==1?"tblcg":"tblcw")%>>
      <td class="xls"><%= row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_NO")%></td>
      <td class="xls"><%= row.getAttribute("MD_RULE_CON_DO_EXPLAIN")==null?"":row.getAttribute("MD_RULE_CON_DO_EXPLAIN").toString()%> </td>
      <td class="xls"><%= row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")%></td><%
                for(int i=1, iz=outAlias.size()+1; i<iz; i++){
%>
      <td class="xls"><%= row.getAttribute("MD_RULE_DECISION_RST"+i)%></td><%
                }
%>
    </tr><%
            }
%>
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
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0230",null,locale)%> : </b><%
            for(int i=0, iz=alias.size(); i<iz; i++){
%>
<b>V<%=(i+1)%></b>(<%=alias.get(i)%>)<%
            }
%><br>
</body>
</html>