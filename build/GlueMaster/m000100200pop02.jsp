<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="com.posdata.glue.context.PosContext"%>
<%@ page import="com.posdata.glue.dao.vo.PosRow"%>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet"%>
<%@ page import="com.posdata.glue.web.control.PosWebConstants"%>
<%@ page import="com.posdata.glue.web.security.PosSecurityConstants"%>
<%@ page import="com.posdata.glue.web.security.PosSecurityUtil"%>
<%@ page import="com.posdata.glue.web.security.PosUserIF"%>
<%@ page import="com.posdata.glue.web.security.PosMenu"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui"%>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui"%>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean" />
<posglobalui:setResourceName name="GMResource" />
<%
/*
 * @FileName      : 이행Data JCS 동기화
 * Open Issues    :
 * Change history 
 * @2012-07-11 배광식 #1.3.9 최초 생성
 * @2012-08-28 황유진 #1.4.4 JCS이행시 권한체크 기능 추가
 */
    PosContext ctx = (PosContext) request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale) pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = null;
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    UserEmpNo = request.getParameter("hidden_id") == null ? request.getParameter("UserEmpNo") : request.getParameter("hidden_id");
    UserEmpNo = UserEmpNo == null ? "MASTDATA" : UserEmpNo; //시큐리티 적용전 임시

    String CdTp = request.getParameter("CdTp");
    String CdTpId = request.getParameter("CdTpId");
    String MdlDefineNm = request.getParameter("MdlDefineNm");

    String[] CdTpArray = null;
    String[] CdTpIdArray = null;
    String[] MdlDefineNmArray = null;

    if(CdTp != null && !CdTp.equals("")){
        CdTpArray = CdTp.split("\\|");
        CdTpIdArray = CdTpId.split("\\|");
    }

    if(MdlDefineNm != null && !MdlDefineNm.equals("")){
        MdlDefineNmArray = MdlDefineNm.split("\\|");
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.098",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript">
<!--
function goJCSCd(rowIndex){
    document.form_jcs_code.CdTp.value  =document.forms[0].CdTpId.length > 1?document.forms[0].CdTp[rowIndex].value  :document.forms[0].CdTp.value;
    document.form_jcs_code.CdTpId.value=document.forms[0].CdTpId.length > 1?document.forms[0].CdTpId[rowIndex].value:document.forms[0].CdTpId.value;
    showPopup("","m000201010_jcs",440,220,'1',0,0,1,1,1,0,0);
    document.form_jcs_code.target="m000201010_jcs";
    document.form_jcs_code.submit();
    document.getElementById("Cd"+rowIndex).style.backgroundColor = "#D9F8D9";
}
function goJCSMdl(rowIndex){
    document.form_jcs_rule.MdlDefineNm.value  =document.forms[0].MdlDefineNm.length > 1?document.forms[0].MdlDefineNm[rowIndex].value  :document.forms[0].MdlDefineNm.value;
    showPopup("","m000202010_jcs",440,220,'1',0,0,1,1,1,0,0);
    document.form_jcs_rule.target="m000202010_jcs";
    document.form_jcs_rule.submit();
    document.getElementById("Mdl"+rowIndex).style.backgroundColor = "#D9F8D9";
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<table width="460" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_sync" method="post" action="m000100200.do">
      <table width="440" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.098",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
            <table id=tTable width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr class="tbldb" height="20">
                <td width=150><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
                <td>ID</td>
                <td width=50>JCS</td>
              </tr>
            </table>
            <table id=mainTable width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"><%
    if(CdTpArray != null && CdTpArray.length > 0){
        for (int i = 0, iz = CdTpArray.length; i < iz; i++) {
%>
              <tr id="Cd<%=i%>" class="tblcw" height="20">
                <%=(i==0)? "<td width=150 rowspan="+CdTpArray.length+">"+PosContext.getResourceMessage("GMResource","gm.label.0277",null,locale)+"</td>" : ""%>
                <td><%=CdTpArray[i]%></td>
                <td width=50><img src="img/gm0004img.gif" onClick="goJCSCd(<%=i%>)" style="cursor:pointer"></td>
                <input type="hidden" name="CdTp" value="<%=CdTpArray[i]%>">
                <input type="hidden" name="CdTpId" value="<%=CdTpIdArray[i]%>">
              </tr><%
        }
    }
    if(MdlDefineNmArray != null && MdlDefineNmArray.length > 0){
        for (int i = 0, iz = MdlDefineNmArray.length; i < iz; i++) {
%>
              <tr id="Mdl<%=i%>" class="tblcw" height="20">
                <%=(i==0)? "<td width=150 rowspan="+MdlDefineNmArray.length+">"+PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)+"</td>" : ""%>
                <td><%=MdlDefineNmArray[i]%></td>
                <td width=50><img src="img/gm0004img.gif" onClick="goJCSMdl(<%=i%>)" style="cursor:pointer"></td>
                <input type="hidden" name="MdlDefineNm" value="<%=MdlDefineNmArray[i]%>">
              </tr><%
        }
    }
%>
            </table>
          </td>
        </tr>
      </table>
</form>
<form name="form_jcs_code" method="post" action="m000201010.do"><!-- jcs -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="jcs" value="10"><!-- event -->
<input type="hidden" name="CdTp">
<input type="hidden" name="CdTpId">
</form>
<form name="form_jcs_rule" method="post" action="m000202010.do"><!-- jcs -->
<input type="hidden" name="ServiceName" value="m000202010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="jcs" value="10"><!-- event -->
<input type="hidden" name="MdlDefineNm">
</form>
    </td>
  </tr>
</table>
</body>
</html>