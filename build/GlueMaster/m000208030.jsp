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
 * @FileName      : 표준용어 신청현황 >> 표준용어 등록의뢰
 * Open Issues    :
 * Change history 
 * @2010-06-18 황유진 1.0 isPermitAction() 적용
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    List termSectionList = (List) ctx.get("_SYS_V_TERMS_SECTION");

    //메세지 가져옴.
    String sMsg = ctx.get("msg")== null?"":ctx.get("msg").toString();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.009",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
//표준용어 신청
function go_regist(){
    if(Trim(document.forms[0].TERMS_NAME.value)==""){
        alert('표준용어를 입력하여 주십시요');
        return;
    }
    if(Trim(document.forms[0].ENG_FULL_NAME.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0043",null,locale)%>');//영문 Full Name 을 입력하여 주십시요
        return;
    }
    if(Trim(document.forms[0].SUBC_NM.value)==""){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0041",null,locale)%>");//신청자명을 입력하여 주십시요
        return;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0080",null,locale)%>')){
        document.forms[0].action=document.forms[0].action+"?regist=10";
        document.forms[0].submit();
    }
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="535" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_word_request" method="post" action="m000208020.do">
<input type="hidden" name="ServiceName" value="m000208020-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="msg" value="<%=sMsg%>"/>
      <table width="510" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.009",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
                <td width="403">&nbsp;
                  <posui:showRelatedSelectLists infoName="SysTpResults" name="SYS_TP" cls="adf"
                    nameAttribute="SYS_TP" valueAttribute="SYS_TP" isDistinct="true" isRequestFirst="true">
                    <posui:showRelatedSelectLists infoName="SysTpResults" name="CHAIN_CODE" cls="adf"
                      nameAttribute="CHAIN_CODE" valueAttribute="CHAIN_NM" keyAttribute="SYS_TP" isDistinct="true" isRequestFirst="true">
                    </posui:showRelatedSelectLists>
                  </posui:showRelatedSelectLists>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></td>
                <td>&nbsp;<input type="text" name=TERMS_NAME value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0254",null,locale)%></td>
                <td>&nbsp;<input type="text" name=ENG_FULL_NAME value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0052",null,locale)%></td>
                <td>&nbsp;<input type="text" name=CHINESE_CHAR value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></td>
                <td>&nbsp;<select name="TERMS_SECTION" class="adf"><%
    for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
        Object[] value = (Object[]) termSectionList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>] <%=value[1]%></option><%
    }
%>
                  </select>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0206",null,locale)%></td>
                <td>&nbsp;<input type="text" name="SYNONYMOUS_1" value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0207",null,locale)%></td>
                <td>&nbsp;<input type="text" name="SYNONYMOUS_2" value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0208",null,locale)%></td>
                <td>&nbsp;<input type="text" name="SYNONYMOUS_3" value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0022",null,locale)%></td>
                <td>&nbsp;<textarea name="TERMS_DESCRIPT" rows="10" cols="60" class=adb1></textarea></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></td>
                <td>&nbsp;<input type="text" name=SUBC_NM value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="20"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></td>
                <td>&nbsp;<input type="text" readonly name='REQUEST_DATE' value="<%=PosMasterUtility.getCurTime("yyyy-MM-dd")%>" class=adb1 size="12" align='absmiddle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td height=40 valign=bottom align=center>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onclick="go_regist()" style="cursor:pointer"><!-- confirm -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.cancel",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- cancel -->
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
</body>
<script type="text/javascript">
    if(document.forms[0].msg.value!="")
    {
      alert(document.forms[0].msg.value);
    }
</script>
</html>