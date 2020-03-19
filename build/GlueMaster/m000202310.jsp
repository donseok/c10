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
 * @2008-06-25 류진영 1.0 최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String SearchRuleNm = request.getParameter("SearchRuleNm")==null?"":request.getParameter("SearchRuleNm");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.072",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script language=javascript>
<!--
function gm_KeyDown(){
    if(event.keyCode==13){
        gm_find();
    }
    return false;
}
function gm_find(){
    document.forms[0].curPage.value="1";//showPageSet tag.
    document.forms[0].submit();
}
function goSave(){
    var chkcnt = document.forms[0].jcs_chk.length;
    var checkedcnt = 0;
    if(chkcnt > 1){
        for(var i=0; i<chkcnt; i++){
            if(document.forms[0].jcs_chk[i].checked == true){
                checkedcnt++;
                document.forms[0].action=document.forms[0].action+"?save=10";
                document.forms[0].submit();
                return;
            }
        }
    }else{
        if(document.forms[0].jcs_chk.checked == true){
            checkedcnt++;
            document.forms[0].action=document.forms[0].action+"?save=10";
            document.forms[0].submit();
            return;
        }
    }
    if(checkedcnt == 0){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    }
}
function goRuleAttrs(idx){
    document.form_jcs_attr.RuleId.value=document.forms[0].jcs_chk.length>1?document.forms[0].RuleId[idx].value:document.forms[0].RuleId.value;
    document.form_jcs_attr.RuleNm.value=document.forms[0].jcs_chk.length>1?document.forms[0].RuleNm[idx].value:document.forms[0].RuleNm.value;
    document.form_jcs_attr.Type.value  =document.forms[0].jcs_chk.length>1?document.forms[0].Type[idx].value  :document.forms[0].Type.value;
    showPopup("","SelectRuleAttrs",620,380,'1',0,0,1,1,1,0,0);
    document.form_jcs_attr.target="SelectRuleAttrs";
    document.form_jcs_attr.submit();
}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="780" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_jcs" method="post" action="m000202310.do">
<input type="hidden" name="ServiceName" value="m000202310-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="760" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.072",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign="bottom" bgcolor=FFFFFF> 
            <table class=tbllw width="100%" border=0 cellspacing="0" cellpadding="0"  bordercolorlight=666666 bordercolordark=ffffff align=center>
              <tr height=25>
                <td>
  <img src="img/gm0008img.gif" border="0">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%>&nbsp;:&nbsp;</b>
  <input type="text" name="SearchRuleNm" value="<%=SearchRuleNm%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="insRow(mainTable, hiddenTable, document.forms[0].jcs_chk)" style="cursor:pointer"><!-- add row -->
                  <img src='<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>' onClick="goSave()" style="cursor:pointer"><!-- save -->
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
          <td valign="top" align=left>
  <table width=100% border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF>
    <tr class="tbldb" height="20">
      <th width="40">chk</th>
      <th width="160"><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></th>
      <th width="160"><%=PosContext.getResourceMessage("GMResource","gm.label.0185",null,locale)%></th>
      <th width="160"><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></th>
      <th width="160"><%=PosContext.getResourceMessage("GMResource","gm.label.0087",null,locale)%></th>
      <th><%=PosContext.getResourceMessage("GMResource","gm.label.0120",null,locale)%></th>
    </tr>
  </table>
  <table id=mainTable width=100% border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF><%

    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("PosRuleJocListVO") : null;
    int rowCnt = 0;
    if( rowSet!=null ){
        PosRow row = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td width="40"><input type="checkbox" name="jcs_chk" value="<%=rowCnt%>"></td>
      <td width="160"><input type="text" readonly name="RuleNm" value="<%=row.getAttribute("RULE_NM")%>" class=adb1></td>
      <td width="160"><a href="#" onClick="goRuleAttrs(<%=rowCnt%>)"><%=row.getAttribute("RULE_EXPLAIN")%></a></td>
      <td width="160"><%=row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td width="160"><%=row.getAttribute("END_ACTIVE_DATE_STR")%></td>
      <td>
        <select name="JocFlag" class=adb1>
          <option value="Y" <%="Y".equals(row.getAttribute("ACCORD_DATA_CONFIRM_DEST_FLAG"))?"selected":""%>>YES</option>
          <option value="N" <%="N".equals(row.getAttribute("ACCORD_DATA_CONFIRM_DEST_FLAG"))?"selected":""%>>NO</option>
        </select>
      </td>
      <input type="hidden" name="Type" value="<%=row.getAttribute("MASTER_DATA_PRC_TP")%>">
      <input type="hidden" name="RuleId" value="<%=row.getAttribute("RULE_ID")%>">
    </tr><%
            rowCnt++;
        }
        rowSet.reset();
    }
    for(; rowCnt<20; rowCnt++){
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20">
      <td width="40"><input type="checkbox" name="jcs_chk" value="<%=rowCnt%>"></td>
      <td width="160"><input type="text" name="RuleNm" value="" class=adb1></td>
      <td width="160">&nbsp;</td>
      <td width="160">&nbsp;</td>
      <td width="160">&nbsp;</td>
      <td>
        <select name=JocFlag class=adb1>
          <option value="Y">YES</option>
          <option value="N">NO</option>
        </select>
      </td>
      <input type="hidden" name="Type">
      <input type="hidden" name="RuleId">
    </tr><%
    }
%>
  </table>
            <div align="center">
            <posui:showPageSet infoName="PosRuleJocListVO" formName="document.forms[0]" curPageName="curPage"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_jcs_attr" method="post" action="m000202310.do">
<input type="hidden" name="ServiceName" value="m000202310-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="pop01" value="1"><!-- event -->
<input type="hidden" name="RuleId">
<input type="hidden" name="RuleNm">
<input type="hidden" name="Type">
</form>
    </td>
  </tr>
</table>
<div STYLE=display:none>
<table id="hiddenTable" width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
  <tr height="20" class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
    <td><input type="checkbox" name="jcs_chk" value=0 checked></td>
    <td><input type="text" name="RuleNm" class=adb1></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>
      <select name=JocFlag class=adb1>
        <option value="Y">YES</option>
        <option value="N">NO</option>
      </select>
    </td>
    <input type="hidden" name="Type">
    <input type="hidden" name="RuleId">
  </tr>
</table>
</div>
</body>
</html>