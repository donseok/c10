<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
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
 * @FileName      : 표준용어 신청현황
 * Open Issues    :
 * Change history 
 * @2010-07-04 황유진 1.0 다국어 지원
 * @2012-08-09 황유진 #1.4.2 LANGUAGE_CODE,_SYS_F_PROGRESS_STS 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosUserIF user = ctx==null ? null : (PosUserIF)ctx.getSessionUserData(PosSecurityConstants.USER);
    String UserEmpNo = null;
    boolean isAdmin = false;
    if(user==null){
        UserEmpNo = request.getParameter("hidden_id")==null?request.getParameter("UserEmpNo"):request.getParameter("hidden_id");
        UserEmpNo = UserEmpNo==null?"MASTDATA":UserEmpNo;  //시큐리티 적용전 임시
        isAdmin = "MASTDATA".equals(UserEmpNo);
    }else{
        UserEmpNo = user.getUserID();
        PosSecurityUtil.checkPageID("m000207120");
        isAdmin = PosMenu.getCurPage().isPermitAction("sign");
    }

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");
    List progressStsList = (List) ctx.get("_SYS_F_PROGRESS_STS");
    HashMap<String, String> progressStsMap = new HashMap<String, String>();
    for (int i = 0, iz = progressStsList.size(); i < iz; i++) {
        Object[] value = (Object[]) progressStsList.get(i);
        progressStsMap.put((String)value[0], (String)value[1]);
    }

    String sSearchWord  = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.007",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
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
//표준용어 승인관리
function gm_open_sign(val1, val2){
    document.form_sign_word.SearchWord.value=val1;
    document.form_sign_word.LanguageCode.value=val2;
    showPopup("","m000207120_m000207120pop01",560,470,'1',0,0,1,1,1,0,0);
    document.form_sign_word.target="m000207120_m000207120pop01";
    document.form_sign_word.submit();
}
//표준용어 등록의뢰
function gm_open_regist(){
    showPopup("","m000207120_m000207120pop01",560,470,'1',0,0,1,1,1,0,0);
    document.form_req_word.target="m000207120_m000207120pop01";
    document.form_req_word.submit();
}
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.007",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_word" method="post" action="m000207120.do">
<input type="hidden" name="ServiceName" value="m000207120-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align="left">
  <select name="ProgressSts" class="adf">
    <option value="%" selected>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></option><%
            for (int i = 0, iz = progressStsList.size(); i < iz; i++) {
                Object[] value = (Object[]) progressStsList.get(i);
%>
    <option value="<%=value[0]%>">[<%=value[0]%>] <%=value[1]%></option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="LanguageCode" class="adf">
    <option value="%" selected>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></option><%
    String LanguageCode = request.getParameter("LanguageCode");
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        String[] value = (String[]) LanguageCodeList.get(i);
%>
    <option value="<%=value[0]%>" <%=value[0].equals(LanguageCode)?"selected":""%>><%=value[1]%></option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchTypeLOV" class="adf">
    <option value="TERMS_NAME" <%="TERMS_NAME".equals(request.getParameter("SearchTypeLOV"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></option>
    <option value="SUBC_NM" <%=      "SUBC_NM".equals(request.getParameter("SearchTypeLOV"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="gm_open_regist()" style="cursor:pointer"><!-- register -->
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
          <td valign=top align="left">
  <table id=mainTable width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <th width="57">no.</th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></th>
      <th width="57"><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></th>
      <th width="141"><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></th>
      <th width="198"><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></th>
      <th width="135"><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0027",null,locale)%></th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0180",null,locale)%></th>
    </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("WordList") : null;
    int rowCnt = 1;
    if( rowSet!=null ){
        PosRow row = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
  <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcg" : "tblcw" %>" height="20" onclick="gm_open_sign('<%=(String)row.getAttribute("TERMS_NAME")%>','<%=(String)row.getAttribute("LANGUAGE_CODE")%>')" style="cursor:pointer" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
    <td index=<%=rowCnt%>><%=(rowCnt)%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("CHAIN_CODE")==null?"&nbsp;":(String)row.getAttribute("CHAIN_CODE")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("TERMS_NAME")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("STD_TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("STD_TERMS_NAME")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("SUBC_NM")==null?"&nbsp;":(String)row.getAttribute("SUBC_NM")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("REQUEST_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("REQUEST_DATE_STR")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("PROGRESS_STS")==null||!progressStsMap.containsKey((String)row.getAttribute("PROGRESS_STS"))?"&nbsp;":progressStsMap.get((String)row.getAttribute("PROGRESS_STS"))%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("INVEST_RESULT")==null||row.getAttribute("INVEST_RESULT").toString().length()<1?"&nbsp;":(String)row.getAttribute("INVEST_RESULT")%></td>
  </tr><%
            rowCnt++;
        }
        rowSet.reset();
    }
    for(; rowCnt<21; rowCnt++){
%>
  <tr class="<%= (rowCnt%2==0) ? "tblcg" : "tblcw" %>" height="20">
    <td><%=(rowCnt)%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr><%
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
<form name="form_sign_word" method="post" action="m000207120.do">
<input type="hidden" name="ServiceName" value="m000207120-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="SearchTypeLOV" value="TERMS_NAME">
<input type="hidden" name="SearchWord">
<input type="hidden" name="LanguageCode">
<input type="hidden" name="sign" value="10"><!-- event -->
<input type="hidden" name="event" value="sign">
<input type="hidden" name="isPageSet" value="false">
</form>
<form name="form_req_word" method="post" action="m000207120.do">
<input type="hidden" name="ServiceName" value="m000207120-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="new" value="10"><!-- event -->
<input type="hidden" name="event" value="new">
</form>
    </td>
  </tr>
</table>
</body>
</html>