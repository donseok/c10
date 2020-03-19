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
 * @FileName      : 표준용어 신청현황 >> 표준용어 등록의뢰 >> StdTermsName 조회
 * @FileName      : 표준용어 신청현황 >> 표준용어 승인관리 >> StdTermsName 조회
 * Open Issues    :
 * Change history 
 * @2010-07-01 황유진 1.0 다국어 지원
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String sSearchWord  = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>EngFuleName</title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
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
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="780" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_word_request" method="post" action="m000207120.do">
<input type="hidden" name="ServiceName" value="m000207120-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="SearchTypeLOV" value="STD_TERMS_NAME">
<input type="hidden" name="pop02" value="10"><!-- event -->
      <table width="760" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033">EngFuleName</div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align="left">
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class="tbldb" height="20">
                <th><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></th>
                <th>Eng ID</th>
                <th>약어</th>
                <th><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></th>
                <th><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></th>
                <th><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></th>
                <th><%=PosContext.getResourceMessage("GMResource","gm.label.0206",null,locale)%></th>
                <th><%=PosContext.getResourceMessage("GMResource","gm.label.0207",null,locale)%></th>
                <th><%=PosContext.getResourceMessage("GMResource","gm.label.0208",null,locale)%></th>
              </tr><%

    PosRowSet rowset = (PosRowSet)ctx.get("WordList");
    int rowCnt = 0;
    if( rowset!=null && rowset.hasNext()){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
%>
  <tr class="<%= (rowCnt%2==0) ? "tblcg" : "tblcw" %>">
    <td><%=row.getAttribute("STD_TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("STD_TERMS_NAME")%></td>
    <td><%=row.getAttribute("ENG_ID")==null?"&nbsp;":(String)row.getAttribute("ENG_ID")%></td>
    <td><%=row.getAttribute("ENG_ABBR")==null?"&nbsp;":(String)row.getAttribute("ENG_ABBR")%></td>
    <td><%=row.getAttribute("OWNER_DEPT")==null?"&nbsp;":(String)row.getAttribute("OWNER_DEPT")%></td>
    <td><%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%></td>
    <td><%=row.getAttribute("TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("TERMS_NAME")%></td>
    <td><%=row.getAttribute("SYNONYMOUS_1")==null?"&nbsp;":(String)row.getAttribute("SYNONYMOUS_1")%></td>
    <td><%=row.getAttribute("SYNONYMOUS_2")==null?"&nbsp;":(String)row.getAttribute("SYNONYMOUS_2")%></td>
    <td><%=row.getAttribute("SYNONYMOUS_3")==null?"&nbsp;":(String)row.getAttribute("SYNONYMOUS_3")%></td>
  </tr><%
        }
        rowset.reset();
    }
%>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
            <posui:showPageSet infoName="WordList" formName="document.forms[0]"/>
            </div>
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