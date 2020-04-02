<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.biz.constants.PosBizControlConstants" %>
<%@ page import="com.posdata.glue.cache.PosCacheManager" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ page import="com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import="com.posdata.glue.web.security.PosSecurityUtil" %>
<%@ page import="com.posdata.glue.web.security.PosUserIF" %>
<%@ page import="com.posdata.glue.web.security.PosMenu" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : SETUP(TB_M00_MESSAGES020 관리)
 * Open Issues    :
 * Change history 
 * @2011-06-21 황유진 1.0 최초 생성
 * @2012-08-09 황유진 #1.4.2 Caching Data Clear 로직 추가
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosUserIF user = ctx==null ? null : (PosUserIF)ctx.getSessionUserData(PosSecurityConstants.USER);
    String UserEmpNo = null;
    boolean isAdmin = false;
    if(user==null){
        UserEmpNo = request.getParameter("hidden_id")==null ? request.getParameter("UserEmpNo") : request.getParameter("hidden_id");
        UserEmpNo = UserEmpNo==null?"MASTDATA":UserEmpNo;  //시큐리티 적용전 임시
        isAdmin = "MASTDATA".equals(UserEmpNo);
    }else{
        UserEmpNo = user.getUserID();
        PosSecurityUtil.checkPageID(request.getParameter("pageID"));//m000100100,m000205010,m000207110
        isAdmin = PosMenu.getCurPage().isPermitAction("save");//import,jcs,layout,new,insert,update,save,delete
    }
    if(request.getParameter("modify")!=null){
        ((PosCacheManager)PosContext.getBeanFactory().getBeanObject(PosBizControlConstants.CACHE_MANAGER_KEY)).clear("__GlueMaster_SysCode__");
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Setup Language(TB_M00_MESSAGES020)</title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function changeUseLangSetF(jsLanguageCode, jsUseLangSetF){
    if('B' == jsUseLangSetF){
        alert("Default Language는 변경할 수 없습니다. ");
    }else if('D' == jsUseLangSetF){
        if(confirm("Globalization 허용 언어로 설정하시겠습니까?")){
            document.forms[0].LanguageCode.value = jsLanguageCode;
            document.forms[0].UseLangSetF.value = "C";
            document.forms[0].action = document.forms[0].action+"?modify=10";
            document.forms[0].submit();
        }
    }else if('C' == jsUseLangSetF){
        if(confirm("Globalization 미허용 언어로 설정하시겠습니까?")){
            document.forms[0].LanguageCode.value = jsLanguageCode;
            document.forms[0].UseLangSetF.value = "D";
            document.forms[0].action = document.forms[0].action+"?modify=10";
            document.forms[0].submit();
        }
    }else{
        alert("미사용 언어로 처리합니다.");
        document.forms[0].LanguageCode.value = jsLanguageCode;
        document.forms[0].UseLangSetF.value = "D";
        document.forms[0].action = document.forms[0].action+"?modify=10";
        document.forms[0].submit();
    }
}
function go_open_regist(){
    showPopup("","m000100100_add",940,200,'1',0,0,1,1,1,0,0);
    document.form_language_add.target="m000100100_add";
    document.form_language_add.submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033">Setup Language(TB_M00_MESSAGES020)</div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
<form name="form_language" method="post" action="m000100100.do">
<input type="hidden" name="ServiceName" value="m000100100-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="UseLangSetF">
<input type="hidden" name="LanguageCode">
<input type="hidden" name="UpdByIp" value="<%=request.getRemoteAddr()%>">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="18">
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="go_open_regist()" style="cursor:pointer">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer">
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr valign=top align="left">
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class="tbldb" height="20">
                <th width="100">사용언어</th>
                <th width="100">NLS언어</th>
                <th width="100">NLS영역</th>
                <th width="100">ISO언어</th>
                <th width="100">ISO영역</th>
                <th width="120">NLS코드Set</th>
                <th width="100">Local언어</th>
                <th width="100">UTF8언어</th>
                <th width="100">사용언어설정</th>
                <th width="30">◈</th>
              </tr><%

    PosRowSet rowset = ctx!=null?(PosRowSet)ctx.get("TbM00Messages020"):null;
    PosRow row = null;

    if(rowset!=null && rowset.hasNext())
    {
        String trClass = null;
        int rowCnt = 0;
        while(rowset.hasNext())
        {
            row = rowset.next();
            if("B".equals((String)row.getAttribute("USE_LANG_SET_F"))){
                trClass = "tblcm";
            }else if("C".equals((String)row.getAttribute("USE_LANG_SET_F"))){
                trClass = "tblcw";
            }else{
                trClass = "tblcg";
            }
%>
              <tr class="<%=trClass%>" height="20">
                <td><%=(String)row.getAttribute("LANGUAGE_CODE")%></td>
                <td><%=(String)row.getAttribute("NLS_LANG")%></td>
                <td><%=(String)row.getAttribute("NLS_AREA")%></td>
                <td><%=(String)row.getAttribute("ISO_LANG_TP")%></td>
                <td><%=(String)row.getAttribute("ISO_AREA_TP")%></td>
                <td><%=(String)row.getAttribute("NLS_CD_SET")%></td>
                <td><%=(String)row.getAttribute("LOCAL_LANG")%></td>
                <td><%=(String)row.getAttribute("UTF8_LANG")%></td>
                <td><%=(String)row.getAttribute("USE_LANG_SET_F")%></td>
                <td><input type="radio" name=chk value=<%=rowCnt%> class=adb1 onclick="changeUseLangSetF('<%=(String)row.getAttribute("LANGUAGE_CODE")%>','<%=(String)row.getAttribute("USE_LANG_SET_F")%>')"></td>
              </tr><%
              rowCnt++;
        }
    } else
    {
%>
              <tr class="tblcw" height="20">
                <td>&nbsp;</td>
                <td><input type="text" name=LANGUAGE_CODE style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=NLS_LANG style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=NLS_AREA style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=ISO_LANG_TP style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=ISO_AREA_TP style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=NLS_CD_SET style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=LOCAL_LANG style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=UTF8_LANG style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=USE_LANG_SET_F style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
              </tr><%
    }
%>
            </table>
          </td>
        </tr>
      </table>
</form>
<form name="form_language_add" method="post" action="m000100100.do"><!-- new -->
<input type="hidden" name="ServiceName" value="m000100100-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="addview" value="10">
</form>
    </td>
  </tr>
</table>
</body>
</html>