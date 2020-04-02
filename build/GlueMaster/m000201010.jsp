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
 * @FileName      : 마스타코드 목록
 * Open Issues    :
 * Change history 
 * @2008-03-07 서정범 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP,LANGUAGE_CODE 출력방식 변경 
 * @2008-08-16 황유진 #1.4.3 검색조건입력창의 엔터키 이벤트활성화 및 재조회시 curPage 초기화.
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosUserIF user = ctx==null ? null : (PosUserIF)ctx.getSessionUserData(PosSecurityConstants.USER);
    String UserEmpNo = null;
    boolean isAdmin = false, isJCS = false;
    if(user==null){
        UserEmpNo = request.getParameter("hidden_id")==null?request.getParameter("UserEmpNo"):request.getParameter("hidden_id");
        UserEmpNo = UserEmpNo==null?"MASTDATA":UserEmpNo;  //시큐리티 적용전 임시
        isAdmin = "MASTDATA".equals(UserEmpNo);
    }else{
        UserEmpNo = user.getUserID();
        PosSecurityUtil.checkPageID("m000201010");
        isAdmin = PosMenu.getCurPage().isPermitAction("save");//import,layout,new,insert,update,save,delete
        isJCS = PosMenu.getCurPage().isPermitAction("jcs");//jcs
    }

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    HashMap<String, String> HierarchyOpTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
        HierarchyOpTpMap.put(value[0], value[1]);
    }
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");
    HashMap<String, String> HierarchyOwnerShipTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
        HierarchyOwnerShipTpMap.put(value[0], value[1]);
    }
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");

    String sCdTpCharacter = request.getParameter("SearchCdTpCharacter")==null?"%":request.getParameter("SearchCdTpCharacter");
    String sUseTp = request.getParameter("SearchUseTp")==null?"Y":request.getParameter("SearchUseTp");
    String sLanguageCode = request.getParameter("SearchLanguageCode")==null?"%":request.getParameter("SearchLanguageCode");
    String sHierarchyOpTp = request.getParameter("SearchHierarchyOpTp")==null?"%":request.getParameter("SearchHierarchyOpTp");
    String sHierarchyOwnerShipTp = request.getParameter("SearchHierarchyOwnerShipTp")==null?"%":request.getParameter("SearchHierarchyOwnerShipTp");
    String sSearchAttribute = request.getParameter("SearchAttribute")==null?"CD_TP_MEANING":request.getParameter("SearchAttribute");
    String sSearchWord = request.getParameter("SearchWord")==null?"":request.getParameter("SearchWord");
    String curPage = request.getParameter("curPage")== null?"1":request.getParameter("curPage");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.020",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript">
<!--
//검색텍스트박스에서 Enter 키 누름시.
function gm_KeyDown(){
    if(event.keyCode==13){
        gm_find();
    }
    return false;
}
//검색버튼 클릭시
function gm_find(){
    document.forms[0].curPage.value="1";//showPageSet tag.
    document.forms[0].target="_top";
    document.forms[0].submit();
}
//코드상세조회 페이지로 이동
function moveCodeDetail(rowIndex){
    document.form_detail.CdTpId.value  =document.forms[0].CdTpId.length>1 ? document.forms[0].CdTpId[rowIndex].value  :document.forms[0].CdTpId.value;
    document.form_detail.FkCdTpId.value=document.forms[0].CdTpId.length>1 ? document.forms[0].FkCdTpId[rowIndex].value:document.forms[0].FkCdTpId.value;
    showPopup("","m000201010_m000201020",1016,641,'1',0,0,1,1,1,0,0);
    document.form_detail.target="m000201010_m000201020";
    document.form_detail.submit();
}
//등록버튼누름시
function go_open_regist(){
    showPopup("","m000201010_m000201040",1016,641,'1',0,0,1,1,1,0,0);
    document.form_register.target="m000201010_m000201040";
    document.form_register.submit();
}
//수정버튼 누름시
function goModify(){
    var nRecodeCnt;
    var checked = false;
    if (document.forms[0].chk.length >= 2){
        nRecodeCnt=document.forms[0].chk.length;
    }else{
        nRecodeCnt=1;
    }
    for (var i=0; i < nRecodeCnt; i++){
        if (nRecodeCnt > 1){
            if (document.forms[0].chk[i].checked==true){
                document.form_modify.CdTpId.value=document.forms[0].CdTpId[i].value;
                document.form_modify.CdTp.value  =document.forms[0].CdTp[i].value;
                checked = true;
                break;
            }
        } else{
            if (document.forms[0].chk.checked==true){
                document.form_modify.CdTpId.value=document.forms[0].CdTpId.value;
                document.form_modify.CdTp.value  =document.forms[0].CdTp.value;
                checked = true;
                break;
            }
        }
    }
    if(checked){
        showPopup("","m000201010_m000201040",1016,641,'1',0,0,1,1,1,0,0);
        document.form_modify.target="m000201010_m000201040";
        document.form_modify.submit();
    }else{
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");//선택된 Data가 없습니다.
    }
}
//Import 페이지로 이동
function goExcelImport(){
    showPopup("","m000201010_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000201010_import";
    document.form_import.submit();
}
//공통모듈 테스트 화면 누름시(확인버튼)
function goCodeTest(){
    showPopup("","m000201010_test",920,400,"1",1,1,1,1,1,0,0);
    document.form_codetest.target="m000201010_test";
    document.form_codetest.submit();
}
//JCS 확정버튼 누름시 : m000201010-query.glue_sql 참고
function goJCSPage(rowIndex){
    document.form_jcs.CdTp.value  =document.forms[0].CdTpId.length > 1?document.forms[0].CdTp[rowIndex].value  :document.forms[0].CdTp.value;
    document.form_jcs.CdTpId.value=document.forms[0].CdTpId.length > 1?document.forms[0].CdTpId[rowIndex].value:document.forms[0].CdTpId.value;
    showPopup("","m000201010_jcs",440,220,'1',0,0,1,1,1,0,0);
    document.form_jcs.target="m000201010_jcs";
    document.form_jcs.submit();
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.020",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_code" method="post" action="m000201010.do">
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
  <select name="SearchCdTpCharacter" class="adf">
    <option value="%" <%="%".equals(sCdTpCharacter)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></option>
    <option value="S" <%="S".equals(sCdTpCharacter)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0190",null,locale)%></option>
    <option value="C" <%="C".equals(sCdTpCharacter)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0065",null,locale)%></option>
    <option value="R" <%="R".equals(sCdTpCharacter)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0170",null,locale)%></option>
  </select>&nbsp;&nbsp;
  <select name="SearchUseTp" class="adf">
    <option value="%" <%="%".equals(sUseTp)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></option>
    <option value="F" <%="F".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
    <option value="Y" <%="Y".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
    <option value="N" <%="N".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
  </select>&nbsp;&nbsp;
  <select name="SearchLanguageCode" class="adf">
    <option value="%" <%="%".equals(sLanguageCode)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></option><%
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        String[] value = (String[]) LanguageCodeList.get(i);
%>
    <option value="<%=value[0]%>" <%=value[0].equals(sLanguageCode)?"selected":""%>><%=value[1]%></option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchHierarchyOpTp" class="adf">
    <option value="%" <%="%".equals(sHierarchyOpTp)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></option><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
%>
    <option value="<%=value[0]%>" <%=value[0].equals(sHierarchyOpTp)?"selected":""%>><%=value[1]%></option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchHierarchyOwnerShipTp" class="adf">
    <option value="%" <%="%".equals(sHierarchyOwnerShipTp)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></option><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
%>
    <option value="<%=value[0]%>" <%=value[0].equals(sHierarchyOwnerShipTp)?"selected":""%>><%=value[1]%></option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchAttribute" class="adf">
    <option value="CD_TP_MEANING" <%="CD_TP_MEANING".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></option>
    <option value="CD_TP" <%=                "CD_TP".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></option>
    <option value="USER_NAME" <%=        "USER_NAME".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
          </td>
        </tr>
        <tr>
          <td align="right"><% if(isAdmin){ %>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="go_open_regist()" style="cursor:pointer"><!-- register -->
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick="goModify()" style="cursor:pointer"><!--modify--><% } %>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.test",null,locale)%>" onClick="goCodeTest()" style="cursor:pointer"><!--code test--><% if(isAdmin){ %>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goExcelImport()" style="cursor:pointer"><!-- import --><% } %>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
  <table id=mainTable width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"><%

    if(isAdmin){ 

%>
    <tr class="tbldb" height="20">
      <td width="38" rowspan="2">chk</td>
      <td colspan="7"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
      <td width="31" rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0271",null,locale)%></td>
    </tr>
    <tr class="tbllb" height="20">
      <td width="52"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="52"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="214"><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></td>
      <td width="242"><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="82"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="83"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%

    }else if(isJCS){

%>
    <tr class="tbldb" height="20">
      <td colspan="7"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
      <td width="31" rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0271",null,locale)%></td>
    </tr>
    <tr class="tbllb" height="20">
      <td width="52"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="52"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="214"><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></td>
      <td width="242"><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="82"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="83"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%

    }else{

%>
    <tr class="tbldb" height="20">
      <td colspan="7"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
    </tr>
    <tr class="tbllb" height="20">
      <td width="52"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="52"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="214"><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></td>
      <td width="242"><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="62"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="82"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="83"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%

    }

    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("CodeListVOResult") : null;
    int rowCnt = 0;
    if( rowset!=null ){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
            String UseTpStr = row.getAttribute("USE_TP")==null?"&nbsp;":(String)row.getAttribute("USE_TP");
            if("S".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
            else if("F".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
            else if("Y".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
            else if("N".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
            String CdTpCharacterStr = row.getAttribute("CD_TP_CHARACTER")==null?"&nbsp;":(String)row.getAttribute("CD_TP_CHARACTER");
            if("S".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0190",null,locale);
            else if("C".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0065",null,locale);
            else if("R".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0170",null,locale);
            String HierarchyOpTpStr = HierarchyOpTpMap.containsKey((String)row.getAttribute("HIERARCHY_OP_TP"))
                ?HierarchyOpTpMap.get((String)row.getAttribute("HIERARCHY_OP_TP"))
                :(String)row.getAttribute("HIERARCHY_OP_TP");
            String HierarchyOwnerShipTpStr = HierarchyOwnerShipTpMap.containsKey((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                ?HierarchyOwnerShipTpMap.get((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                :(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP");
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)><%
    if(isAdmin){
%>
      <td><input type="radio" name="chk" value="<%=rowCnt%>"></td><%
    }
%>
      <td><%=CdTpCharacterStr%></td>
      <td><%=UseTpStr%></td>
      <td align="left"><a href="javascript:" onClick="moveCodeDetail(<%=rowCnt%>)"><%=row.getAttribute("CD_TP_MEANING")==null?"&nbsp;":(String)row.getAttribute("CD_TP_MEANING")%></a></td>
      <td align="left"><%=row.getAttribute("CD_TP")==null?"&nbsp;":(String)row.getAttribute("CD_TP")%></td>
      <td><%=HierarchyOpTpStr.length()>3?HierarchyOpTpStr.substring(0,3)+"...":HierarchyOpTpStr%></td>
      <td><%=HierarchyOwnerShipTpStr.length()>3?HierarchyOwnerShipTpStr.substring(0,3)+"...":HierarchyOwnerShipTpStr%></td>
      <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
      <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td><%
    if(isJCS){
%>
      <td><img src="img/gm0004img.gif" onClick="goJCSPage(<%=rowCnt%>)" style="cursor:pointer"></td><%
    }
%>
      <input type="hidden" name="CdTpId" value="<%=row.getAttribute("CD_TP_ID")==null?"":row.getAttribute("CD_TP_ID").toString()%>">
      <input type="hidden" name="CdTp" value="<%=row.getAttribute("CD_TP")==null?"":(String)row.getAttribute("CD_TP")%>">
      <input type="hidden" name="FkCdTpId" value="<%=row.getAttribute("FK_CD_TP_ID")==null?"":row.getAttribute("FK_CD_TP_ID").toString()%>">
      <input type="hidden" name="MdlDefineCngGd" value="<%=row.getAttribute("MDL_DEFINE_CNG_GD")==null?"":(String)row.getAttribute("MDL_DEFINE_CNG_GD")%>">
  </tr><%
            rowCnt++;
        }
        for(; rowCnt<20; rowCnt++){
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20"><%    if(isAdmin){%>
      <td>&nbsp;</td><%    }%>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td><%    if(isJCS){%>
      <td>&nbsp;</td><%    }%>
  </tr><%
        }
        rowset.reset();
    }
%>
  </table>
            <div align="center">
            <posui:showPageSet infoName="CodeListVOResult" formName="document.forms[0]"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000201010.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="curPage" value=<%=request.getParameter("curPage")==null?"1":request.getParameter("curPage")%>>
<input type="hidden" name="SearchCdTpCharacter" value="<%=sCdTpCharacter%>">
<input type="hidden" name="SearchUseTp" value="<%=sUseTp%>">
<input type="hidden" name="SearchLanguageCode" value="<%=sLanguageCode%>">
<input type="hidden" name="SearchHierarchyOpTp" value="<%=sHierarchyOpTp%>">
<input type="hidden" name="SearchHierarchyOwnerShipTp" value="<%=sHierarchyOwnerShipTp%>">
<input type="hidden" name="SearchAttribute" value="<%=sSearchAttribute%>">
<input type="hidden" name="SearchWord" value="<%=sSearchWord%>">
</form>
<form name="form_detail" method="post" action="m000201010.do"><!-- detail -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="detail" value="10"><!-- event -->
<input type="hidden" name="CdTpId">
<input type="hidden" name="FkCdTpId">
</form>
<form name="form_import" method="post" action="m000201010.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
</form>
<form name="form_codetest" method="post" action="m000201010.do"><!-- Test -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="test" value=10><!-- event -->
</form>
<form name="form_jcs" method="post" action="m000201010.do"><!-- jcs -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isJCS%>">
<input type="hidden" name="jcs" value="10"><!-- event -->
<input type="hidden" name="CdTp">
<input type="hidden" name="CdTpId">
</form>
<form name="form_register" method="post" action="m000201040.do"><!-- New -->
<input type="hidden" name="ServiceName" value="m000201040-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="new" value=10><!-- event -->
<input type="hidden" name="CodeType" value="M">
</form>
<form name="form_modify" method="post" action="m000201040.do"><!-- Modify -->
<input type="hidden" name="ServiceName" value="m000201040-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="CdTpId">
<input type="hidden" name="FkCdTpId">
<input type="hidden" name="CdTp">
<input type="hidden" name="SearchWord" value="">
</form>
    </td>
  </tr>
</table>
</body>
</html>