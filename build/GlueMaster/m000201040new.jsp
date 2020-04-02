<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 마스타코드 목록 >> 마스타코드 기본속성 등록
 * Open Issues    :
 * Change history
 * @2003-08-01 김연기 1.0    최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP,LANGUAGE_CODE,_SYS_R_APPLICATION_ID 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");
    List ApplicationIdList = (List) ctx.get("_SYS_R_APPLICATION_ID");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.024",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showCalendar.js"></script>
<script type="text/javascript">
<!--
function goCodeList(){
    var dataTp = document.forms[0].CodeType.value; //코드유형
    if(Trim(document.forms[0].CdTp.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0132",null,locale)},locale)%>'); //마스터코드영문명
        return;
    }
    if(dataTp=="M"&&Trim(document.forms[0].CdTpMeaning.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0133",null,locale)},locale)%>'); //마스터코드한글명
        return;
    }
    if(dataTp=="T"&&Trim(document.forms[0].TranCdTp.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0219",null,locale)},locale)%>'); //트랜잭션영문명
        return;
    }
    if(dataTp=="T"&&Trim(document.forms[0].TranCdTpMeaning.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0220",null,locale)},locale)%>'); //트랜잭션한글명
        return;
    }
    if(Trim(document.forms[0].StartActiveDate.value)=="" || Trim(document.forms[0].EndActiveDate.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)},locale)%>'); //유효일시
        return;
    }
    if(Trim(document.forms[0].CdTpVersion.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)},locale)%>'); //버전
        return;
    }
    if(Trim(document.forms[0].CdTpOwnerEmpNo.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)},locale)%>'); //담당자
        return;
    }
    document.forms[0].action = document.forms[0].action+"?insert=10";
    document.forms[0].target = "_self";
    document.forms[0].submit();
}
function doShow(id){
     document.all[id].style.visibility = "visible" ;
}
function doHide(id){
    document.all[id].style.visibility = "hidden" ;
}
function doControlLayer(obj, id){
    if ( obj.value == "M" ){
        doShow(id+"");
    } else{
        doHide(id+"");
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.024",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
<form name="form_code_register" method="post" action="m000201040.do">
<input type="hidden" name="ServiceName" value="m000201040-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height=20>
          <td align="right"><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goCodeList()" style="cursor:pointer"><!-- save --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">1.<%=PosContext.getResourceMessage("GMResource","gm.label.0134",null,locale)%></div>
            <table width="980" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource","gm.label.0135",null,locale)%></td>
                <td class=tbllw width=330>
                  <select name="CodeType" class="adf" onChange=doControlLayer(this,'display')>
                    <option value="M" <%="T".equals(request.getParameter("CodeType"))?"":"selected"%>><%=PosContext.getResourceMessage("GMResource","gm.label.0128",null,locale)%></option>
                    <option value="T" <%="T".equals(request.getParameter("CodeType"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0216",null,locale)%></option>
                  </select>
                </td>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource","gm.label.0223",null,locale)%></td>
                <td class=tbllw width=330>
                  <DIV ID="display" STYLE="visibility:<%="M".equals(request.getParameter("CodeType"))? "visible":"hidden" %>">
                  <select name="CdTpCharacter" class="adf">
                    <option value="S" <%="S".equals(request.getParameter("CdTpCharacter"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0190",null,locale)%></option>
                    <option value="C" <%="C".equals(request.getParameter("CdTpCharacter"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0065",null,locale)%></option>
                    <option value="R" <%="R".equals(request.getParameter("CdTpCharacter"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0170",null,locale)%></option>
                  </select>
                  </DIV>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0132",null,locale)%></td>
                <td class=tbllw><input type="text" name="CdTp" value="<%=isError ? request.getParameter("CdTp") : ""%>" size="50" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0133",null,locale)%></td>
                <td class=tbllw><input type="text" name="CdTpMeaning" value="<%=isError ? request.getParameter("CdTpMeaning") : ""%>" size="50" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0219",null,locale)%></td>
                <td class=tbllw><input type="text" name="TranCdTp" value="<%=isError ? request.getParameter("TranCdTp") : ""%>" size="50" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0220",null,locale)%></td>
                <td class=tbllw><input type="text" name="TranCdTpMeaning" value="<%=isError ? request.getParameter("TranCdTpMeaning") : ""%>" size="50" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" name="StartActiveDate" value="<%=PosMasterUtility.getCurTime("yyyy-MM-dd HH:mm:ss")%>" readonly class="adb1" size="19" maxlength="19">
                  <img src="img/gm0002img.gif" style="cursor:pointer" border="0" onClick="javascript:jspCalendar(this.parentElement.index,document.forms[0].StartActiveDate,'','true');">
                  ~
                  <input type="text" name="EndActiveDate" value="2999-12-31 23:59:59" readonly class="adb1" size="19" maxlength="19">
                  <img src="img/gm0002img.gif" style="cursor:pointer" border="0" onClick="javascript:jspCalendar(this.parentElement.index,document.forms[0].EndActiveDate,'','true');">
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw><input type="text" name="CdTpOwnerEmpNo" value="<%=isError ? request.getParameter("CdTpOwnerEmpNo") : UserEmpNo%>" class=adb1></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
                <td class=tbllw><input type="text" name="CdTpVersion" value="1.0" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0233",null,locale)%></td>
                <td class=tbllw><input type="text" name="VersionUpCauseDesc" value="<%=PosContext.getResourceMessage("GMResource","gm.label.0152",null,locale)%>" size="50" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0129",null,locale)%></td>
                <td class=tbllw colspan=3><input type="text" name=CdTpExplain value="<%=isError ? request.getParameter("CdTpExplain") : ""%>" size="100" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">2.<%=PosContext.getResourceMessage("GMResource","gm.label.0187",null,locale)%></div>
            <table width="980" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
                <td class=tbllw width=330>
                  <select name="HierarchyOwnerShipTp" class="adf"><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                </td>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource","gm.label.0163",null,locale)%></td>
                <td class=tbllw width=330>
                  <select name="HierarchyOpTp" class="adf"><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                </td>
              </tr>
              <tr>
                <td class=tbldb width=150>[application id]</td>
                <td class=tbllw width=330>
                  <select name="ApplicationId" class="adf"><%
    for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
        String[] value = (String[]) ApplicationIdList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                </td>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
                <td class=tbllw width=330>
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
              <tr>
                <td class=tbldb width=150>[security group id]</td>
                <td class=tbllw width=330>
                  <select name="SecurityGroupId" class="adf">
                    <option value="0">[0]</option>
                  </select>
                </td>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
                <td class=tbllw width=330>
                  <select name="UseTp" class="adf"><!--
                    <option value="F">[F]</option>
                    <option value="Y">[Y]</option>
                    <option value="N">[N]</option>-->
                    <option value="S">[S]<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
                  </select>
                </td>
              </tr>
              <tr>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
                <td class=tbllw>
                  <select name="CdTpCngGd" class="adf">
                    <option value="A"><%=PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale)%></option>
                    <option value="B"><%=PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale)%></option>
                  </select>
                </td>
                <td class=tbldb>[버전관리]</td>
                <td class=tbllw>
                  <input type="radio" name="MdVersionMaintFlag" value="Y" class="adb1"> Yes /
                  <input type="radio" name="MdVersionMaintFlag" value="N" class="adb1" selected> No
                </td>
              </tr>
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