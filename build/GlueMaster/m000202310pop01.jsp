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
 * @FileName      : 업무기준 JCS대상 관리화면
 * Open Issues    :
 * Change history 
 * @2008-06-26 류진영 1.0 최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String RuleId = request.getParameter("RuleId");
    String RuleNm = request.getParameter("RuleNm");
    String Type   = request.getParameter("Type");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.073",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script language=javascript>
<!--
function goSave(){
    var chkcnt = document.forms[0].jcs_chk.length;
    var checkedcnt = 0;
    if(chkcnt > 1){
        for(var i=0; i<chkcnt; i++){
            if(document.forms[0].jcs_chk[i].checked == true){
                checkedcnt++;
                document.forms[0].action=document.forms[0].action+"?pop01_save=10";
                document.forms[0].submit();
                return;
            }
        }
    }else{
        if(document.forms[0].jcs_chk.checked == true){
            checkedcnt++;
            document.forms[0].action=document.forms[0].action+"?pop01_save=10";
            document.forms[0].submit();
            return;
        }
    }
    if(checkedcnt == 0){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    }
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width=600 border=0 cellspacing=0 cellpadding=0>
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_jcs_attr" method="post" action="m000202310.do">
<input type="hidden" name="ServiceName" value="m000202310-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="RuleId" value="<%=RuleId%>">
<input type="hidden" name="Type" value="<%=Type%>">
      <table width="580" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.073",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign="bottom" bgcolor=FFFFFF> 
            <table class=tbllw width="580" border=0 cellspacing="0" cellpadding="0"  bordercolorlight=666666 bordercolordark=ffffff align=center>
              <tr height=25>
                <td align="left">
                  <img src="img/gm0008img.gif" border="0">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%>&nbsp;:&nbsp;</b>
                  <input type="text" readonly name="RuleNm" value='<%=RuleNm%>' size="15" maxlength="13" class="adb1" style="custom style">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goSave()" style="cursor:pointer"><!-- save -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
         <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr> 
          <td valign="bottom" bgcolor=FFFFFF>
  <table id=mainTable width=100% border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF>
    <tr class="tbldb" height="20">
      <td width="40">chk</td>
      <td>SEQ</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0120",null,locale)%></td>
    </tr><%

    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("PosRuleAttrsJocListVO") : null;
    int rowCnt = 0;
    if( rowSet!=null ){
        PosRow row = null;
        if("1B0".equals(Type)){
            while(rowSet.hasNext()){
                row = rowSet.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><input type="checkbox" name="jcs_chk" value="<%=rowCnt%>"></td>
      <td><%=row.getAttribute("MD_RULE_DT_NM_SEQ")%></td>
      <td><%=row.getAttribute("MD_RULE_DT_NM_NM")%></td>
      <td>
        <select name="JocFlag" class=adb1>
          <option value="Y" <%="Y".equals(row.getAttribute("MD_BAS_SEARCH_GR_KEY_F"))?"selected":""%>>YES</option>
          <option value="N" <%="N".equals(row.getAttribute("MD_BAS_SEARCH_GR_KEY_F"))?"selected":""%>>NO</option>
        </select>
        <input type="hidden" name="DtNmId" value="<%=row.getAttribute("DT_NM_ID")%>">
      </td><%
                rowCnt++;
            }
        }else{
            while(rowSet.hasNext()){
                row = rowSet.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><input type="checkbox" name="jcs_chk" value="<%=rowCnt%>"></td>
      <td><%=row.getAttribute("MDL_DEFINE_DT_NM_SEQ")%></td>
      <td><%=row.getAttribute("MDL_DEFINE_DT_NM_NM")%></td>
      <td>
        <select name="JocFlag" class=adb1>
          <option value="Y" <%="Y".equals(row.getAttribute("MD_BAS_SEARCH_GR_KEY_F"))?"selected":""%>>YES</option>
          <option value="N" <%="N".equals(row.getAttribute("MD_BAS_SEARCH_GR_KEY_F"))?"selected":""%>>NO</option>
        </select>
        <input type="hidden" name="DtNmId" value="<%=row.getAttribute("DT_NM_ID")%>">
      </td><%
                rowCnt++;
            }
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