<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 계산수식 목록 >> 계산수식 내용상세 >> 계산수식 변경이력
 * Open Issues    :
 * Change history 
 * @2008-03-07 김정희 1.0 최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.076",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript">
<!--
function goDetailListPage(){
    document.forms[0].action=document.forms[0].action+"?detail=10";
    if (document.forms[0].rdo.length > 1){
        for(var i = 0 ; i< document.forms[0].rdo.length ; i++) {
            if( document.forms[0].rdo[i].checked) {
                document.forms[0].MdRuleId.value = document.forms[0].MdRuleId2[i].value;
                document.forms[0].target = "_top";
                document.forms[0].submit();
                return;
            }
        }
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    }else{
        document.forms[0].MdRuleId.value = document.forms[0].MdRuleId2.value;
        document.forms[0].target = "_top";
        document.forms[0].submit();
    }
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
  <tr id=gm_logo>
    <td><img src="/img/m000001img.gif" width="1000" height="40"></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5">
        <tr height="23">
          <td id=gm_BreadCrumbs valign="middle"><!--BreadCrumbs 네비게이션 링크 출력--></td>
          <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
        </tr>
      </table>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.076",null,locale)%></div></td>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.ruledata",null,locale)%>" onClick="goDetailListPage();" style="cursor:pointer">
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_cal_history" method="post" action="m000203010.do">
<input type="hidden" name="ServiceName" value="m000203010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="MdRuleId">
<input type="hidden" name="ActionType_L" value="L">
<input type="hidden" name="ActionType_C" value="C">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table id="T1" width="960" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr class="tbldb" height="20">
                <td width="30">chk</td>
                <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
                <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
                <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
                <td width="350"><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
                <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
                <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
                <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
                <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
              </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("CalcSelectListVOResult") : null;
    int rowCnt = 0;
    if(rowSet!=null){
        PosRow row=null;;
        while(rowSet.hasNext()){
            row = rowSet.next();
            String _UseTp = row.getAttribute("USE_TP")==null?"&nbsp;":(String)row.getAttribute("USE_TP");
            if("S".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
            else if("Y".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
            else if("N".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
            else if("F".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
%>
              <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,T1) onmouseout=in_ch(1,this,T1)>
                <td><input type="radio" name="rdo" value="<%=rowCnt%>"><input type="hidden" name="MdRuleId2" value="<%=row.getAttribute("MD_RULE_ID")%>"></td>
                <td><%=rowCnt+1%></td>
                <td><%=_UseTp%></td>
                <td><%=row.getAttribute("MD_RULE_VERSION")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_VERSION")%></td>
                <td><%=row.getAttribute("MD_RULE_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_EXPLAIN")%></td>
                <td><%=row.getAttribute("MD_RULE_NM")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_NM")%></td>
                <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
                <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
                <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
              </tr><%
            rowCnt++;
        }
    }
%>
            </table>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
</body>
</html>