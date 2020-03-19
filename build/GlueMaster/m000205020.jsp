<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 화면메세지관리 목록 >> 화면메세지관리 내용상세
 *                  화면메세지관리 목록 >> 화면메세지관리 등록
 *                  화면메세지관리 목록 >> 화면메세지관리 수정
 * Open Issues    :
 * Change history 
 * @2008-03-07 김정희 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 LANGUAGE_CODE,_SYS_R_APPLICATION_ID 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");
    List ApplicationIdList = (List) ctx.get("_SYS_R_APPLICATION_ID");
    HashMap<String, String> ApplicationIdMap = new HashMap<String, String>();
    for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
        String[] value = (String[]) ApplicationIdList.get(i);
        ApplicationIdMap.put(value[0], value[1]);
    }

    PosRowSet rowSet = (PosRowSet)ctx.get("AppMsgSelectedVOResult");
    PosRow row = rowSet!=null&&rowSet.hasNext() ? rowSet.next() : null;
    String sMode = request.getParameter("Mode")== null?"": request.getParameter("Mode");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><% if( "detail".equals(sMode)){ %>
<title><%=PosContext.getResourceMessage("GMResource","gm.title.016",null,locale)%></title><%} else if( "enter".equals(sMode)){ %>
<title><%=PosContext.getResourceMessage("GMResource","gm.title.017",null,locale)%></title><%} else { %>
<title><%=PosContext.getResourceMessage("GMResource","gm.title.018",null,locale)%></title><%} %>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showBubbleHelp.js"></script>
<script type="text/javascript" src="js/showCalendar.js"></script>
<script type="text/javascript">
<!--
<% if( "enter".equals(sMode) || "modify".equals(sMode)){%>
function validateContents()
{
    var a = "Changed"; 
    var b = "Fixed";
    var c = document.forms[0].MessageTp.value;
    var d = document.forms[0].MessageCont.value;
    if(a == c){
        if(d.indexOf("&") != -1){
        }else{
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0001",null,locale)%>");
            return false;
        }
    }else if(b==c){
        if(d.indexOf("&") == -1) {
        }else{
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0002",null,locale)%>");
            return false;
        }
    }
    if(Trim(document.forms[0].ApplMsgOwnerEmpNo.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0002",null,locale)},locale)%>'); //등록자
        return false
    }
    if(Trim(document.forms[0].MessageExplain.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0005",null,locale)},locale)%>'); //메세지용도
        return false
    }
    if(Trim(document.forms[0].MessageNm.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{"ID"},locale)%>'); //ID
        return false
    }
    if(Trim(document.forms[0].MessageCont.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0007",null,locale)},locale)%>'); //내용
        return false
    }
    document.forms[0].action = document.forms[0].action+"?<%=sMode%>=10";
    document.forms[0].target = "_top";
    document.forms[0].submit();
}
<%}%>
function gm_close(){
<% if( "yes".equals(request.getParameter("needReloadPage")) ){ %>
    window.opener.document.forms[0].submit();
<% } %>
    window.close()
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<table width="600" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_msg_data" method="post" action="m000205020.do">
<input type="hidden" name="ServiceName" value="m000205020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="needReloadPage" value="<%=isError?"no":"yes"%>">
<input type="hidden" name="Mode" value="<%=sMode%>">
      <table width="580" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25><% if( "detail".equals(sMode)){%>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.016",null,locale)%></div></td><%} else if( "enter".equals(sMode)){%>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.017",null,locale)%></div></td><%} else {%>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.018",null,locale)%></div></td><%}%>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height="25">
          <td align="right"><% if(isAdmin){ %><% if( "enter".equals(sMode)){%>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="validateContents()" style="cursor:pointer"><!-- register --><%}else if("modify".equals(sMode)){%>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick="validateContents()" style="cursor:pointer"><!-- modify --><%}%><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="gm_close()" style="cursor:pointer">
          </td>
        </tr>
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td><%

    if( row==null ){
%>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0001",null,locale)%></td>
                <td class=tbllw width=200>
                  <input type="text" name="dummy" value="<%=PosMasterUtility.getCurTime("yyyy-MM-dd HH:mm:ss")%>" readonly class="adb1" size="19" maxlength="19">
                  <img src="img/gm0002img.gif" style="cursor:pointer" border="0" onClick="javascript:jspCalendar(this.parentElement.index,dummy,'','true');">
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0002",null,locale)%></td>
                <td class=tbllw><input type="text" name="ApplMsgOwnerEmpNo" value=<%=UserEmpNo%> class="adb1" size="12" maxlength="8" onmouseover="tooltipOn('<%=PosContext.getResourceMessage("GMResource","gm.msg.0003",null,locale)%>',WIDTH, 180);" onmouseout="tooltipOff();"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table id=Ttable width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0003",null,locale)%></td>
                <td class=tbllw>
                  <select name="ApplicationId" class="adf"><%
        for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
            String[] value = (String[]) ApplicationIdList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>]<%=value[1]%></option><%
        }
%>
                  </select>
                </td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
                <td class=tbllw>
                  <select name="LanguageCode" class="adf"><%
        for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
            String[] value = (String[]) LanguageCodeList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>]<%=value[1]%></option><%
        }
%>
                  </select>
                </td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0005",null,locale)%></td>
                <td class=tbllw><input type="text" name="MessageExplain" class="adb1" size="20" onmouseover="tooltipOn('<%=PosContext.getResourceMessage("GMResource","gm.msg.0004",null,locale)%>',WIDTH, 80);" onmouseout="tooltipOff();"></td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100>ID</td>
                <td class=tbllw><input type="text" name="MessageNm" class="adb1" size="20" maxlength="30"></td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
                <td class=tbllw>
                  <select name="MessageTp" class="adf">
                    <option value="Fixed"><%=PosContext.getResourceMessage("GMResource","gm.label.0100",null,locale)%></option>
                    <option value="Changed"><%=PosContext.getResourceMessage("GMResource","gm.label.0231",null,locale)%></option>
                  </select>
                </td>
              </tr>
              <tr height=60>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0007",null,locale)%></td>
                <td class=tbllw><textarea name="MessageCont" rows=7 cols=75 class="adb1" style="width:470px"></textarea></td>
              </tr>
            </table><%

    }else {

%>
<input type="hidden" name="MessageNm" value="<%=row.getAttribute("MESSAGE_NM")==null?"":(String)row.getAttribute("MESSAGE_NM")%>">
<input type="hidden" name="MessageExplain" value="<%=row.getAttribute("MESSAGE_EXPLAIN")==null?"":(String)row.getAttribute("MESSAGE_EXPLAIN")%>">
<input type="hidden" name="ApplMsgOwnerEmpNo" value="<%=row.getAttribute("APPL_MSG_OWNER_EMP_NO")==null?"":(String)row.getAttribute("APPL_MSG_OWNER_EMP_NO")%>">
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0001",null,locale)%></td>
                <td class=tbllw width=200><%=row.getAttribute("CREATE_DATE")==null?"&nbsp;":row.getAttribute("CREATE_DATE")%></td>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0002",null,locale)%></td>
                <td class=tbllw><%=row.getAttribute("USER_NAME")==null?"&nbsp;":row.getAttribute("USER_NAME")%></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table id=Ttable width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0003",null,locale)%><input type="hidden" name="ApplicationId" value='<%=row.getAttribute("APPLICATION_ID")%>'></td>
                <td class=tbllw><%=row.getAttribute("APPLICATION_ID")%>(<%=ApplicationIdMap.get(row.getAttribute("APPLICATION_ID").toString())%>)</td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%><input type="hidden" name="LanguageCode" value='<%=row.getAttribute("LANGUAGE_CODE")%>'></td>
                <td class=tbllw><%=row.getAttribute("LANGUAGE_CODE_1")%></td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0005",null,locale)%></td>
                <td class=tbllw><%=row.getAttribute("MESSAGE_EXPLAIN")%></td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100>ID</td>
                <td class=left><%=row.getAttribute("MESSAGE_NM")%></td>
              </tr>
              <tr height=25>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
                <td class=tbllw>
                  <select name="MessageTp" class="adf">
                    <option value="Fixed" <%=    "Fixed".equals((String)row.getAttribute("MESSAGE_TP"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0100",null,locale)%></option>
                    <option value="Changed" <%="Changed".equals((String)row.getAttribute("MESSAGE_TP"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0231",null,locale)%></option>
                  </select>
                </td>
              </tr>
              <tr height=60>
                <td class=tbldb width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0007",null,locale)%></td>
                <td class=tbllw><textarea name="MessageCont" rows=7 cols=75 class="adb1" style="width:470px"><%=row.getAttribute("MESSAGE_CONT")%></textarea></td>
              </tr>
            </table><%
    }
%>
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