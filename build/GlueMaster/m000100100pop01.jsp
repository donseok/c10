<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.biz.constants.PosBizControlConstants" %>
<%@ page import="com.posdata.glue.cache.PosCacheManager" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : SETUP(TB_M00_MESSAGES020 관리) >> 등록
 * Open Issues    :
 * Change history 
 * @2005-04-15 황유진 1.0 최초 생성
 * @2012-08-09 황유진 #1.4.2 Caching Data Clear 로직 추가
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    if(request.getParameter("insert")!=null){
        ((PosCacheManager)PosContext.getBeanFactory().getBeanObject(PosBizControlConstants.CACHE_MANAGER_KEY)).clear("__GlueMaster_SysCode__");
    }

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Setup Language(TB_M00_MESSAGES020)</title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript">
<!--
function save(){
    document.forms[0].action = document.forms[0].action+"?insert=10";
    document.forms[0].submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no">
<table width="920" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="900" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033">Setup Language(TB_M00_MESSAGES020)</div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="right">
<form name="form_language" method="post" action="m000100100.do">
<input type="hidden" name="ServiceName" value="m000100100-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="UpdByIp" value="<%=request.getRemoteAddr()%>">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="save()" style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height=18>
          <td align="left" valign=top>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class="tbldb" height="20">
                <th width="80">사용언어</th>
                <th width="110">NLS언어</th>
                <th width="110">NLS영역</th>
                <th width="80">ISO언어</th>
                <th width="80">ISO영역</th>
                <th width="130">NLS코드Set</th>
                <th width="110">Local언어</th>
                <th width="110">UTF8언어</th>
                <th width="90">사용언어설정</th>
              </tr>
              <tr class="tblcw" height="20">
                <td><input type="text" name="LanguageCode" style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=NlsLang style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=NlsArea style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=IsoLangTp style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=IsoAreaTp style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=NlsCdSet style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=LocalLang style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td><input type="text" name=Utf8Lang style="width:70px" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td>
                  <select name="UseLangSetF" class="adf">
                    <option value="C" <%=request.getParameter("UseLangSetF")==null || "C".equals(request.getParameter("UseLangSetF"))?"selected":""%>>사용</option>
                    <option value="D" <%="D".equals(request.getParameter("UseLangSetF"))?"selected":""%>>미사용</option>
                  </select>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
</form>
    </td>
  </tr>
</table>
</body><% if( ctx.get("insertCnt") != null ){ %>
<script type="text/javascript">
    window.opener.document.forms[0].submit();
    self.close();
</script><% } %>
</html>