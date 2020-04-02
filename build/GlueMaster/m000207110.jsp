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
 * @FileName      : 표준용어 목록
 * Open Issues    :
 * Change history
 * @2010-07-01 황유진 1.0 다국어 지원
 * @2012-08-09 황유진 #1.4.2 LANGUAGE_CODE,_SYS_V_TERMS_SECTION 출력방식 변경 
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
        PosSecurityUtil.checkPageID("m000207110");
        isAdmin = PosMenu.getCurPage().isPermitAction("modify");
    }

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");
    List termSectionList = (List) ctx.get("_SYS_V_TERMS_SECTION");
    HashMap<String, String> termSectionMap = new HashMap<String, String>();
    for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
        Object[] value = (Object[]) termSectionList.get(i);
        termSectionMap.put((String)value[0], (String)value[1]);
    }

    String sSearchWord  = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.001",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
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
function gm_addLanguage(obj){
    if(obj.value=="AddLanguage"){
        if(confirm("대상 언어를 설정하시겠습니까?")){
            showPopup("","m000207110_m000100100",1016,641,'1',0,0,1,1,1,0,0);
            document.form_language.target="m000207110_m000100100";
            document.form_language.submit();
        }
        obj.value="%";
    }
}
function gm_open_detail(val){
    document.form_word_data.SearchWord.value=val;
    showPopup("","m000207110_detail",1016,641,'1',0,0,1,1,1,0,0);
    document.form_word_data.target="m000207110_detail";
    document.form_word_data.submit();
}
// 입력데이타에 스페이스가 있는지 체크...
function IsEmpty(toCheck){
    var is_Space = false;
    if ( ( toCheck == "") || ( toCheck == null ) )
        return true;
    for ( j = 0 ; !(is_Space) &&  ( j < toCheck.length ) ; j++){
        if( toCheck.substring( j , j+1 ) == " " ){
            return true;
        }
    }
    return is_Space;
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.001",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_word" method="post" action="m000207110.do">
<input type="hidden" name="ServiceName" value="m000207110-service"/>
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
  <select name="ChainCode" class="adf">
    <option value="%" selected><%=PosContext.getResourceMessage("GMResource","gm.label.0234",null,locale)%></option><%
    PosRowSet rowset = null;
    String ChainCode = request.getParameter("ChainCode");
    rowset = ctx!=null ? (PosRowSet)ctx.get("ChainCodeList") : null;
    if(rowset!=null){
        PosRow row = null;
        String selected = null;
        while(rowset.hasNext()){
            row = rowset.next();
            selected = ChainCode!=null && ChainCode.equals((String)row.getAttribute("CHAIN_CODE")) ? " selected":"";
%>
    <option value="<%=(String)row.getAttribute("CHAIN_CODE")%>"<%=selected%>><%=(String)row.getAttribute("CHAIN_CODE_NM")%></option><%
        }
    }
%>
  </select>&nbsp;&nbsp;
  <select name="LanguageCode" class="adf" onChange="gm_addLanguage(this)">
    <option value="%" selected>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></option><%
    String LanguageCode = request.getParameter("LanguageCode");
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        String[] value = (String[]) LanguageCodeList.get(i);
%>
    <option value="<%=value[0]%>" <%=value[0].equals(LanguageCode)?"selected":""%>><%=value[1]%></option><%
    }
    if(isAdmin){
%>
    <option value="AddLanguage">Add . . .</option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchTypeLOV" class="adf">
    <option value="TERMS_NAME" <%=        "TERMS_NAME".equals(request.getParameter("SearchTypeLOV"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></option>
    <option value="STD_TERMS_NAME" <%="STD_TERMS_NAME".equals(request.getParameter("SearchTypeLOV"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>&nbsp;
  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0113",null,locale)%></b>
  <input type="checkbox" name="includeSynonymous" value="GO">
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle"/>
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit();" style="cursor:pointer"><!-- export -->
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
  <table id=mainTable width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <th width="57">no.</th>
      <th width="141"><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></th>
      <th width="57"><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></th>
      <th width="198"><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></th>
      <th width="135"><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></th>
      <th width="98"><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></th>
    </tr><%
    rowset = ctx!=null ? (PosRowSet)ctx.get("WordList") : null;
    int rowCnt = 1;
    if( rowset!=null ){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
            String TermsSection = row.getAttribute("TERMS_SECTION")==null||!termSectionMap.containsKey((String)row.getAttribute("TERMS_SECTION"))?"":termSectionMap.get((String)row.getAttribute("TERMS_SECTION"));
%>
  <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcg" : "tblcw" %>" height="20" onclick="gm_open_detail('<%=(String)row.getAttribute("STD_TERMS_NAME")%>')" style="cursor:pointer" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
    <td index=<%=rowCnt%>><%=(rowCnt)%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("TERMS_NAME")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("STD_TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("STD_TERMS_NAME")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("ENG_ID")==null?"&nbsp;":(String)row.getAttribute("ENG_ID")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("ENG_ABBR")==null?"&nbsp;":(String)row.getAttribute("ENG_ABBR")%></td>
    <td index=<%=rowCnt%>><%=TermsSection%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("CHAIN_CODE")==null?"&nbsp;":(String)row.getAttribute("CHAIN_CODE")%></td>
    <td index=<%=rowCnt%>><%=row.getAttribute("REGISTER_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("REGISTER_DATE_STR")%></td>
  </tr><%
            rowCnt++;
        }
        rowset.reset();
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
<form name="form_export" method="post" action="m000207110.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000207110-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="isPageSet" value="false">
</form>
<form name="form_word_data" method="post" action="m000207110.do"><!-- pop01 -->
<input type="hidden" name="ServiceName" value="m000207110-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="SearchTypeLOV" value="STD_TERMS_NAME">
<input type="hidden" name="SearchWord">
<input type="hidden" name="detail" value="10"><!-- event -->
<input type="hidden" name=isPageSet value=false>
</form>
<form name="form_language" method="post" action="m000100100.do"><!-- pop02 -->
<input type="hidden" name="ServiceName" value="m000100100-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name=isPageSet value=false>
</form>
    </td>
  </tr>
</table>
</body>
</html>