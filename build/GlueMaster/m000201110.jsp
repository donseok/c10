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
 * @FileName      : 트랜잭션 목록
 * Open Issues    :
 * Change history 
 * @2008-03-07 서정범 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP,LANGUAGE_CODE 출력방식 변경 
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
        PosSecurityUtil.checkPageID("m000201110");
        isAdmin = PosMenu.getCurPage().isPermitAction("sign");
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

    String sUseTp=request.getParameter("SearchUseTp")==null?"Y":request.getParameter("SearchUseTp");
    String sLanguageCode=request.getParameter("SearchLanguageCode")==null?"%":request.getParameter("SearchLanguageCode");
    String sHierarchyOpTp=request.getParameter("SearchHierarchyOpTp")==null?"%":request.getParameter("SearchHierarchyOpTp");
    String sHierarchyOwnerShipTp=request.getParameter("SearchHierarchyOwnerShipTp")==null?"%":request.getParameter("SearchHierarchyOwnerShipTp");
    String sSearchAttribute=request.getParameter("SearchAttribute")==null?"CD_TP_MEANING":request.getParameter("SearchAttribute");
    String sSearchWord=request.getParameter("SearchWord")==null?"":request.getParameter("SearchWord");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.036",null,locale)%></title>
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
//코드상세조회 페이지로 이동
function moveCodeDetail(rowIndex){
    document.form_detail.CdTpId.value  =document.forms[0].CdTpId.length>1 ? document.forms[0].CdTpId[rowIndex].value  :document.forms[0].CdTpId.value;
    document.form_detail.FkCdTpId.value=document.forms[0].CdTpId.length>1 ? document.forms[0].FkCdTpId[rowIndex].value:document.forms[0].FkCdTpId.value;
    showPopup("","m000201110_m000201020",1016,641,'1',0,0,1,1,1,0,0);
    document.form_detail.target="m000201110_m000201020";
    document.form_detail.submit();
}
function goCodeTest(){
    showPopup("","m000201110_test",920,400,"1",1,1,1,1,1,0,0);
    document.form_codetest.target="m000201110_test";
    document.form_codetest.submit();
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.036",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_code" method="post" action="m000201110.do">
<input type="hidden" name="ServiceName" value="m000201110-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
  <select name="SearchUseTp" class="adf">
    <option value="%" <%="%".equals(sUseTp)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></option>
    <option value="S" <%="S".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
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
    <option value="CD_TP_MEANING" <%=                "CD_TP_MEANING".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></option>
    <option value="CD_TP" <%=                                "CD_TP".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></option>
    <option value="USER_NAME" <%=                        "USER_NAME".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
        </tr>
        <tr>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.test",null,locale)%>" onClick="goCodeTest()" style="cursor:pointer"><!--code test-->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit();" style="cursor:pointer"><!-- export -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
  <table id=mainTable width="980" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td colspan="7"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
    </tr>
    <tr class="tbllb" height="20">
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="160"><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></td>
      <td width="220"><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
      <td width="160"><%=PosContext.getResourceMessage("GMResource","gm.label.0131",null,locale)%></td>
      <td width="65"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="65"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="65"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%
    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("CodeListVOResult") : null;
    int rowCnt = 0;
    if( rowset!=null ){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
            String UseTpStr = row.getAttribute("USE_TP")==null?"&nbsp;":(String)row.getAttribute("USE_TP");
            if("S".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
            else if("Y".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
            else if("N".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
            else if("F".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
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
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><%=UseTpStr%></td>
      <td align="left"><a href="javascript:" onClick="moveCodeDetail(<%=rowCnt%>)"><%=row.getAttribute("CD_TP_MEANING")==null?"&nbsp;":(String)row.getAttribute("CD_TP_MEANING")%></a></td>
      <td align="left"><%=row.getAttribute("CD_TP")==null?"&nbsp;":(String)row.getAttribute("CD_TP")%></td>
      <td align="left"><%=row.getAttribute("M_CD_TP_MEANNING")==null?"&nbsp;":(String)row.getAttribute("M_CD_TP_MEANNING")%></td>
      <td><%=HierarchyOpTpStr.length()>3?HierarchyOpTpStr.substring(0,3)+"...":HierarchyOpTpStr%></td>
      <td><%=HierarchyOwnerShipTpStr.length()>3?HierarchyOwnerShipTpStr.substring(0,3)+"...":HierarchyOwnerShipTpStr%></td>
      <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
      <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
      <input type="hidden" name="CdTpId" value="<%=row.getAttribute("CD_TP_ID")==null?"":row.getAttribute("CD_TP_ID").toString()%>">
      <input type="hidden" name="FkCdTpId" value="<%=row.getAttribute("FK_CD_TP_ID")==null?"":row.getAttribute("FK_CD_TP_ID").toString()%>">
  </tr><%
            rowCnt++;
        }
        for(; rowCnt<20; rowCnt++){
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20">
      <td>&nbsp;</td>
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
<form name="form_export" method="post" action="m000201110.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000201110-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="curPage" value=<%=request.getParameter("curPage")==null?"1":request.getParameter("curPage")%>>
<input type="hidden" name="SearchCdTpCharacter" value="%">
<input type="hidden" name="SearchUseTp" value="<%=sUseTp%>">
<input type="hidden" name="SearchLanguageCode" value="<%=sLanguageCode%>">
<input type="hidden" name="SearchHierarchyOpTp" value="<%=sHierarchyOpTp%>">
<input type="hidden" name="SearchHierarchyOwnerShipTp" value="<%=sHierarchyOwnerShipTp%>">
<input type="hidden" name="SearchAttribute" value="<%=sSearchAttribute%>">
<input type="hidden" name="SearchWord" value="<%=sSearchWord%>">
</form>

<form name="form_codetest" method="post" action="m000201010.do"><!-- Test -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="test" value=10><!-- event -->
</form>
<form name="form_detail" method="post" action="m000201110.do">
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="detail" value="10"><!-- event -->
<input type="hidden" name="CdTpId">
<input type="hidden" name="FkCdTpId">
</form>
    </td>
  </tr>
</table>
</body>
</html>