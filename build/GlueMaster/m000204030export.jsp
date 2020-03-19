<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20060522
 * @Author        : 불명
 * @LastModifier  : 서정범
 * @LastVersion   :  1.2
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    response.setHeader("Content-Disposition", "attachment;filename=MasterTCErrChkList.xls");  //엑셀파일명 지정
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.086",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<posglobalui:showTable infoName="GetTCErrorCheckInfoResults"
  headerClasses="tbldb|tbldb"
  headerValues="gm.label.0213|gm.label.0155|gm.label.0030|gm.label.0037|gm.label.0034|gm.label.0211|gm.label.0064|gm.label.0028|gm.label.0168|gm.label.0168|gm.label.0029|gm.label.0169|gm.label.0169|gm.label.0127|gm.label.0210;
    gm.label.0213|gm.label.0155|gm.label.0030|gm.label.0037|gm.label.0034|gm.label.0211|gm.label.0064|gm.label.0028|gm.label.0148|gm.label.0139|gm.label.0029|MIN2|MAX2|gm.label.0127|gm.label.0210"
  columnWidths="100|100|100|100|100|100|100|100|100|100|100|100|100|100|100"
  columnNames="MdlDefineNm|MdlDefineDtNmSeq|StandardKoreanName|StandardEnglishId|Br|Tc|MdRuleDtNmCdF|MdRuleChkOlstatr1|MdRuleChkMiV1|MdRuleChkMaxV1|MdRuleChkOlstatr2|MdRuleChkMiV2|MdRuleChkMaxV2|MdRuleDtNmDetailOperType|MdRuleDtNmTrueBas"
  displayTypes="text|text|text|text|text|text|text|text|text|text|text|text|text|text|text"
  attributes="MDL_DEFINE_NM|MDL_DEFINE_DT_NM_SEQ|STANDARD_KOREAN_NAME|STANDARD_ENGLISH_ID|BR|TC|MD_RULE_DT_NM_CD_F|MD_RULE_CHK_OLSTATR_1|MD_RULE_CHK_MI_V_1|MD_RULE_CHK_MAX_V_1|MD_RULE_CHK_OLSTATR_2|MD_RULE_CHK_MI_V_2|MD_RULE_CHK_MAX_V_2|MD_RULE_DT_NM_DETAIL_OPER_TYPE|MD_RULE_DT_NM_TRUE_BAS" 
/>
  <table border=1>
  <tr class=tblcg>
    <td>END!</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr> 
</table>
<BR>
※비교연산자 설명<br>
  <table border=1>
  <tr class=tbldb>
    <td>비교연산자</td>
    <td colspan=2>의미</td>
  </tr>
  <tr class=tblcg>
    <td>=</td>
    <td colspan=2>같다</td>
  </tr>
  <tr class=tblcg>
    <td>!=</td>
    <td colspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0154",null,locale)%></td>
  </tr>
  <tr class=tblcg>
    <td>&gt;</td>
    <td colspan=2>크다</td>
  </tr>
  <tr class=tblcg>
    <td>&gt;=</td>
    <td colspan=2>크거나같다</td>
  </tr>
  <tr class=tblcg>
    <td>&lt;</td>
    <td colspan=2>작다</td>
  </tr>
  <tr class=tblcg>
    <td>&lt;=</td>
    <td colspan=2>작거나 같다</td>
  </tr>
  <tr class=tblcg>
    <td>IN</td>
    <td colspan=2>조건값 중 하나</td>
  </tr>
  <tr class=tblcg>
    <td>BETWEEN</td>
    <td colspan=2>1<= A <= 2 RANGE CHECK</td>
  </tr>
  <tr class=tblcg>
    <td>BETWEEN1</td>
    <td colspan=2><=BETWEEN<=</td>
  </tr>
  <tr class=tblcg>
    <td>BETWEEN2</td>
    <td colspan=2><=BETWEEN<</td>
  </tr>
  <tr class=tblcg>
    <td>BETWEEN3</td>
    <td colspan=2><BETWEEN<=</td>
  </tr>
  <tr class=tblcg>
    <td>BETWEEN4</td>
    <td colspan=2><BETWEEN<</td>
  </tr>
  <tr class=tblcg>
    <td>NOTNUM</td>
    <td colspan=2>숫자가아니다</td>
  </tr> 
  <tr class=tblcg>
    <td>ALL</td>
    <td colspan=2>코드값전체사용</td>
  </tr> 
  <tr class=tblcg>
    <td>DATE</td>
    <td colspan=2>날짜체크</td>
  </tr> 
  <tr class=tblcg>
    <td>SUBSTR</td>
    <td colspan=2>입력값 Substring</td>
  </tr> 
  <tr class=tblcg>
    <td>SPACE</td>
    <td colspan=2>SPACE</td>
  </tr> 
  <tr class=tblcg>
    <td>NOT_NULL</td>
    <td colspan=2>NULL이 아니다</td>
  </tr> 
</table>
</body>
</html>