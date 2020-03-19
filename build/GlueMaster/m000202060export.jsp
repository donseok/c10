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
 * @FileName      : 업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 조회(연관판단) >> 업무기준 레이아웃 조회(판단)(Export)
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 조회(조건판단) >> 업무기준 레이아웃 조회(판단)(Export)
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 레이아웃 조회(판단)(Export)
 *                  업무기준 목록 >> 업무기준 내용상세_판단기준 >> 업무기준 레이아웃(Export)
 *                  업무기준 목록 >> 업무기준 내용상세_일반기준 >> 업무기준 레이아웃(Export)
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

    response.setHeader("Content-Disposition", "attachment;filename=RuleLayout("+headerRow.getAttribute("MD_RULE_NM")+").xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.059",null,locale)%> [export]</title>
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
      <td rowspan="2">no.</td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0037",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0073",null,locale)%></td>
      <td colspan="3"><%=PosContext.getResourceMessage("GMResource","gm.label.0204",null,locale)%></td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%>(<%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%>)</td>
      <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0073",null,locale)%>(<%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%>)</td>
    </tr>
    <tr class="tbllb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0201",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0226",null,locale)%></td>
    </tr><%

    rowSet = ctx!=null ? (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult") : null;
    if( rowSet!=null ){
        int rowCnt = 0;
        PosRow row = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
            String _DtNmDataTp = row.getAttribute("DT_NM_DATA_TP")==null?"":row.getAttribute("DT_NM_DATA_TP").toString();
            if("1".equals(_DtNmDataTp)) _DtNmDataTp="VARCHAR2";
            else if("2".equals(_DtNmDataTp)) _DtNmDataTp="NUMBER";
            else if("3".equals(_DtNmDataTp)) _DtNmDataTp="DATE";
            else if("4".equals(_DtNmDataTp)) _DtNmDataTp="CHAR";
            String _MdRuleDtNmCompChkVAppF = row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")==null?"":(String)row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F");
            if("I".equals(_MdRuleDtNmCompChkVAppF)) _MdRuleDtNmCompChkVAppF=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale);
            else if("O".equals(_MdRuleDtNmCompChkVAppF)) _MdRuleDtNmCompChkVAppF=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale);
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td class="xls"><%=rowCnt+1%></td>
      <td class="xls" align="left"><%=row.getAttribute("STANDARD_ENGLISH_ID")==null?"":(String)row.getAttribute("STANDARD_ENGLISH_ID")%></td>
      <td class="xls" align="left"><%=row.getAttribute("STANDARD_KOREAN_NAME")==null?"":(String)row.getAttribute("STANDARD_KOREAN_NAME")%></td>
      <td class="xls" align="left"><%=row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS")%></td>
      <td class="xls"><%=row.getAttribute("DT_NM_DATA_TP")==null?"":row.getAttribute("DT_NM_DATA_TP").toString()%></td>
      <td class="xls"><%=row.getAttribute("DT_NM_LEN")==null?"":row.getAttribute("DT_NM_LEN").toString()%></td>
      <td class="xls"><%=row.getAttribute("MD_RULE_DT_NM_IP_V_PREC")==null?"":row.getAttribute("MD_RULE_DT_NM_IP_V_PREC").toString()%></td>
      <td class="xls"><%=row.getAttribute("MES_UNIT_OF_MEASURE")==null?"":(String)row.getAttribute("MES_UNIT_OF_MEASURE")%></td>
      <td class="xls"><%=row.getAttribute("MD_RULE_DT_NM_CD_F")==null?"":(String)row.getAttribute("MD_RULE_DT_NM_CD_F")%></td>
      <td class="xls"><%=row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")==null?"":(String)row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")%></td>
      <td class="xls"><%=row.getAttribute("START_INDEX")==null?"":row.getAttribute("START_INDEX").toString()%></td>
      <td class="xls"><%=row.getAttribute("MD_RULE_DT_NM_SUBSTR_LEN")==null?"":row.getAttribute("MD_RULE_DT_NM_SUBSTR_LEN").toString()%></td>
      <td class="xls"><%=row.getAttribute("MD_RULE_DT_NM_SUBSTR_LEN")==null?"N":"Y"%></td>
      <td class="xls"><%=_DtNmDataTp%></td>
      <td class="xls"><%=_MdRuleDtNmCompChkVAppF%></td>
    </tr><%
            rowCnt++;
        }
    }
%>
  </table>
  <table>
    <tr>
      <td>END!</td>
    </tr>
  </table><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b>NOTICE [ A~L 컬럼 필수 ] </b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> : <%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>  Y(<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%>)인 데이타는 새로운 버전으로 Import 됩니다.
</b>※<br>
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
※ <b>no. : </b> 1,2,3 .. 항목 순서<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%> : </b>
<b>1</b>(STRING)
<b>2</b>(NUMBER)
<b>3</b>(DATE)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%> : </b>
<b>Y</b>
<b>N</b><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0073",null,locale)%> : </b>
<b>I</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%>)
<b>O</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%>)<br>
</body>
</html>