<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 표준항목 신청현황 >> 표준항목 등록의뢰
 * Open Issues    :
 * Change history 
 * @2008-04-02 서정범 1.0 최초생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    //메세지 가져옴.
    String sMsg = ctx.get("msg")== null?"":ctx.get("msg").toString();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.012",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
/* 표준항목 신청 */
function go_regist(){
    if(Trim(document.forms[0].DATA_ITEM_NAME.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0085",null,locale)%>');
        return;
    }
    if(Trim(document.forms[0].SUBC_NM.value)==""){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0041",null,locale)%>");//신청자명을 입력하여 주십시요
        return;
    }
    if(Trim(document.forms[0].DATA_NUMBER.value)=="" ){
        document.forms[0].DATA_NUMBER.value= 0;
    }
    if(Trim(document.forms[0].DECIMAL_NUMBER.value)=="" ){
        document.forms[0].DECIMAL_NUMBER.value= 0;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0081",null,locale)%>')){
        document.forms[0].action=document.forms[0].action+"?regist=10";
        document.forms[0].submit();
    }
}
/* 표준항목생성도우미 */
function goTermHelp(objName){
    var termsvalue = "";
    if(objName=='DATA_ITEM_NAME')
        termsvalue= document.getElementById("DATA_ITEM_NAME").value;
    else 
        termsvalue = document.getElementById("DATA_VAR_ID").value;

    document.form_std_help.TERMS.value=termsvalue;
    showPopup("","m000209030_m000208040",560,620,'1',0,0,1,1,1,0,0);
    document.form_std_help.target="m000209030_m000208040";
    document.form_std_help.submit();
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="530" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_std_data" method="post" action="m000209020.do">
<input type="hidden" name="ServiceName" value="m000209020-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="msg" value="<%=sMsg%>"/>
      <table width="510" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.012",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height="27">
                <td class=tbldb width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
                <td colspan=5>&nbsp;
                  <posui:showRelatedSelectLists infoName="SysTpResults" name="SYS_TP" cls="adf"
                    nameAttribute="SYS_TP" valueAttribute="SYS_TP" isDistinct="true" isRequestFirst="true">
                    <posui:showRelatedSelectLists infoName="SysTpResults" name="CHAIN_CODE" cls="adf"
                      nameAttribute="CHAIN_CODE" valueAttribute="CHAIN_NM" keyAttribute="SYS_TP" isDistinct="true" isRequestFirst="true" >
                    </posui:showRelatedSelectLists>
                  </posui:showRelatedSelectLists>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text"  id="DATA_ITEM_NAME"  name=DATA_ITEM_NAME value="" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="60">&nbsp;<img src="img/gm0003img.gif" onClick="goTermHelp('DATA_ITEM_NAME')" style="cursor:pointer" align='absmiddle'></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" id="DATA_VAR_ID" name=DATA_VAR_ID value="" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="60">&nbsp;<img src="img/gm0003img.gif" onClick="goTermHelp('DATA_VAR_ID')" style="cursor:pointer" align='absmiddle'></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
                <td>&nbsp;<posui:showSelectList name="DATA_TYPE" staticNames="VARCHAR|SMALLINT|INTEGER|BIGINT|FLOAT|DOUBLE|DECIMAL|TIMESTAMP" staticValues="VARCHAR|SMALLINT|INTEGER|BIGINT|FLOAT|DOUBLE|DECIMAL|TIMESTAMP"/></td>
                <td class=tbldb width="75"><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td width="70">&nbsp;<input type="text" name="DATA_NUMBER" value="" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="5"></td>
                <td class=tbldb width="75"><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
                <td>&nbsp;<input type="text" name="DECIMAL_NUMBER" value="" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="5"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td>&nbsp;<input type="text" name="DATA_UNIT" value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="10"></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
                <td colspan=3>&nbsp;<posui:showSelectList name="CODE_YN" staticNames="Y|N" staticValues="YES|NO"/>&nbsp;&nbsp;</td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0021",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=KOR_ABBR value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=ENG_ABBR value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0206",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=DATA_SYNONYMOUS_1 value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0207",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=DATA_SYNONYMOUS_2 value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0208",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=DATA_SYNONYMOUS_3 value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0067",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=OTHER_TERMS value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0049",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=OWNER_DEPT value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0256",null,locale)%></td>
                <td colspan=5>&nbsp;<textarea rows="9" name="DATA_ITEM_DESCRIPT" cols="52" class=adb1></textarea></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" name=SUBC_NM value="" align='absmiddle' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="20"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></td>
                <td colspan=5>&nbsp;<input type="text" readonly name='REQUEST_DATE' value="<%=PosMasterUtility.getCurTime("yyyy-MM-dd")%>" class=adb1 size="12" align='absmiddle'></td>
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
<form name="form_std_help" method="post" action="m000208040.do">
<input type="hidden" name="ServiceName" value="m000208040-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="TERMS">
</form>
</body>
<script type="text/javascript">
  if(document.forms[0].msg.value!="")
  {
    alert(document.forms[0].msg.value);
  }
</script>
</html>