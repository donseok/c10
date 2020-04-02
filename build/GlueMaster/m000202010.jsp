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
 * @FileName      : 업무기준 목록
 * Open Issues    :
 * Change history 
 * @2008-03-10 류진영 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경. 조회시 curPageName 초기화.
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
        PosSecurityUtil.checkPageID("m000202010");
        isAdmin = PosMenu.getCurPage().isPermitAction("save");//save,inputLayout,saveLayout,save,savaData,delete,jcs
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

    String sMasterDataPrcTp = request.getParameter("SearchMasterDataPrcTp")==null?"%":request.getParameter("SearchMasterDataPrcTp");
    String sUseTp = request.getParameter("SearchUseTp")==null?"Y":request.getParameter("SearchUseTp");
    String sHierarchyOpTp = request.getParameter("SearchHierarchyOpTp")==null?"%":request.getParameter("SearchHierarchyOpTp");
    String sHierarchyOwnerShipTp = request.getParameter("SearchHierarchyOwnerShipTp")==null?"%":request.getParameter("SearchHierarchyOwnerShipTp");
    String sSearchAttribute = request.getParameter("SearchAttribute")==null?"MD_EXPLAIN":request.getParameter("SearchAttribute");
    String sSearchWord = request.getParameter("SearchWord")==null?"":request.getParameter("SearchWord");
    String curPage = request.getParameter("curPageName")== null?"1":request.getParameter("curPageName");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.046",null,locale)%></title>
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
    document.forms[0].curPageName.value="1";//showPageSet tag.
    document.forms[0].submit();
}
function goViewPage(tc_id_index,type){
    document.form_rule_data.isNew.value = 'false';
    if(document.forms[0].MdlDefineId.value!=null){
        document.form_rule_data.MdlDefineId.value     = document.forms[0].MdlDefineId.value;
        document.form_rule_data.MdRuleId.value        = document.forms[0].MdlDefineId.value;
        document.form_rule_data.MdlDefineCngGd.value  = document.forms[0].MdlDefineCngGd.value;
        document.form_rule_data.MasterDataPrcTp.value = document.forms[0].MasterDataPrcTp.value;
        document.form_rule_data.HierarchyDataId.value = document.forms[0].HierarchyDataId.value;
        document.form_rule_data.MdlDefineNm.value     = document.forms[0].MdlDefineNm.value;
    }else{
        document.form_rule_data.MdlDefineId.value     = document.forms[0].MdlDefineId[tc_id_index].value;
        document.form_rule_data.MdRuleId.value        = document.forms[0].MdlDefineId[tc_id_index].value;
        document.form_rule_data.MdlDefineCngGd.value  = document.forms[0].MdlDefineCngGd[tc_id_index].value;
        document.form_rule_data.MasterDataPrcTp.value = document.forms[0].MasterDataPrcTp[tc_id_index].value;
        document.form_rule_data.HierarchyDataId.value = document.forms[0].HierarchyDataId[tc_id_index].value;
        document.form_rule_data.MdlDefineNm.value     = document.forms[0].MdlDefineNm[tc_id_index].value;
    }
    if(type=='VIEW'){
        // view detail
        if(document.form_rule_data.MasterDataPrcTp.value=='1A0'||document.form_rule_data.MasterDataPrcTp.value=='1A2'){
            //일반기준일경우//
            document.form_rule_data.action = "m000202040.do";
            document.form_rule_data.ServiceName.value = "m000202040-service";
            showPopup("","m000202010_m000202040",1016,641,'1',0,0,1,1,1,0,0);
            document.form_rule_data.target = "m000202010_m000202040"; 
        } else if(document.form_rule_data.MasterDataPrcTp.value=='1A1'){
            //일반기준중 매트릭스기준일경우//
            document.form_rule_data.action = "m000202050.do";
            document.form_rule_data.ServiceName.value = "m000202050-service";
            showPopup("",'m000202010_m000202050',1016,641,'1',0,0,1,1,1,0,0);
            document.form_rule_data.target = "m000202010_m000202050"; 
        } else if(document.form_rule_data.MasterDataPrcTp.value=='1B0'){
            //판단기준일경우//
            document.form_rule_data.action = "m000202070.do";
            document.form_rule_data.ServiceName.value = "m000202070-service";
            showPopup("","m000202010_m000202070",1016,641,'1',0,0,1,1,1,0,0);
            document.form_rule_data.target = "m000202010_m000202070"; 
        } else{
            //판단기준중 연관판단기준일경우//
            document.form_rule_data.action = "m000202080.do";
            document.form_rule_data.ServiceName.value = "m000202080-service";
            showPopup("",'m000202010_m000202080',1016,641,'1',0,0,1,1,1,0,0);
            document.form_rule_data.target = "m000202010_m000202080"; 
        }
    }else{
        if(document.form_rule_data.MasterDataPrcTp.value=='1A0'||document.form_rule_data.MasterDataPrcTp.value=='1A1'||document.form_rule_data.MasterDataPrcTp.value=='1A2'){
            //일반기준 : 일반기준/Matrix일반기준/판단성일반
            document.form_rule_data.action = "m000202020.do?general=10";
        } else{
            //판단기준일경우//
            document.form_rule_data.action = "m000202020.do?decision=10";
        }
        document.form_rule_data.ServiceName.value = "m000202020-service";
        showPopup("","m000202010_m000202020",1016,641,'1',0,0,1,1,1,0,0);
        document.form_rule_data.target = "m000202010_m000202020"; 
    }
    document.form_rule_data.submit();
}
//Register(업무기준 등록)
function go_open_regist(){
    document.form_rule_data.MdlDefineId.value     = '';
    document.form_rule_data.MdRuleId.value        = '';
    document.form_rule_data.MdlDefineCngGd.value  = '';
    document.form_rule_data.MasterDataPrcTp.value = '';
    document.form_rule_data.HierarchyDataId.value = '';
    document.form_rule_data.MdlDefineNm.value     = '';
    document.form_rule_data.isNew.value='true';
    document.form_rule_data.action = "m000202020.do";
    document.form_rule_data.ServiceName.value = "m000202020-service";
    showPopup("","m000202010_m000202020",1016,641,'1',0,0,1,1,1,0,0);
    document.form_rule_data.target="m000202010_m000202020";
    document.form_rule_data.submit();
}
//Modify
function go_open_modify(type){
    if (document.forms[0].rdo.length > 1){
        for(var i = 0 ; i< document.forms[0].rdo.length ; i++){
            if( document.forms[0].rdo[i].checked == true){
                goViewPage(i,type);
                return;
            }
        }
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    } else{
        goViewPage('0',type);
    }
}
//JCS 확정버튼 누름시
function goJCSPage(rowIndex){
    if (document.forms[0].MdlDefineNm.length > 1){
        goJCS_RuleList(document.forms[0].MdlDefineNm[rowIndex].value);
    }else{
        goJCS_RuleList(document.forms[0].MdlDefineNm.value);
    }
}
function goJCS_RuleList(type){
    document.form_jcs.MdlDefineNm.value=type;
    showPopup("","m000202010_jcs",440,220,'1',0,0,1,1,1,0,0);
    document.form_jcs.target="m000202010_jcs";
    document.form_jcs.submit();
}
function goJCSListPage(){
    showPopup("","m000202010_jcslist",800,600,'1',0,0,1,1,1,0,0);
    document.form_jcs_rule_list.target="m000202010_jcslist";
    document.form_jcs_rule_list.submit();
}
//Import 페이지로 이동
function go_open_import(){
    showPopup("","m000202010_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000202010_import";
    document.form_import.submit();
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.046",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_rule" method="post" action="m000202010.do">
<input type="hidden" name="ServiceName" value="m000202010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
  <select name="SearchMasterDataPrcTp" class="adf">
    <option value="%" <%=  "%".equals(sMasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0237",null,locale)%></option>
    <option value="1A%" <%="1A%".equals(sMasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale)%></option>
    <option value="1B%" <%="1B%".equals(sMasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale)%></option>
  </select>&nbsp;&nbsp;
  <select name="SearchUseTp" class="adf"><!--gm.label.0227-->
    <option value="%" <%="%".equals(sUseTp)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></option>
    <option value="S" <%="S".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
    <option value="F" <%="F".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
    <option value="Y" <%="Y".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
    <option value="N" <%="N".equals(sUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
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
    <option value="MD_EXPLAIN" <%="MD_EXPLAIN".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></option>
    <option value="MD_NM" <%=          "MD_NM".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></option>
    <option value="CNG_GD" <%=        "CNG_GD".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></option>
    <option value="USER_NAME" <%=  "USER_NAME".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value='<%=sSearchWord%>' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
          </td>
        </tr>
        <tr>
          <td align="right"><% if(isJCS){ %>
  <a href="#" onClick="goJCSListPage();return false;"><%=PosContext.getResourceMessage("GMResource","gm.label.0121",null,locale)%></a>
  <img src="img/gm0004img.gif" onClick="goJCS_RuleList('RuleList');" style="cursor:pointer" align="absmiddle"><%}%><% if(isAdmin){%>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="go_open_regist();" style="cursor:pointer" align="absmiddle"><!-- register -->
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick="go_open_modify('modify');" style="cursor:pointer" align="absmiddle"><!-- modify -->
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="go_open_import()" style="cursor:pointer" align="absmiddle"><!-- import --><% } %>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit();" style="cursor:pointer" align="absmiddle"><!-- export -->
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer" align="absmiddle"><!-- close -->
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left">
  <table id=mainTable width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF>
    <tr class="tbldb" height="20"><% if(isAdmin){ %>
      <td width="40">chk</td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="250"><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
      <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
      <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
      <td width="30"><%=PosContext.getResourceMessage("GMResource","gm.label.0271",null,locale)%></td><% }else if(isJCS){ %>
      <td width="40">no.</td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="250"><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
      <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
      <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
      <td width="30"><%=PosContext.getResourceMessage("GMResource","gm.label.0271",null,locale)%></td><% }else{ %>
      <td width="45">no.</td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="265"><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
      <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
      <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td><% } %>
    </tr><%

    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("BusinessRuleList") : null;
    int rowCnt = 0;
    if( rowset!=null ){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
            String MasterDataPrcTp = (String)row.getAttribute("MASTER_DATA_PRC_TP");
            String MasterDataPrcTpStr = "&nbsp;";
            if("1A0".equals(MasterDataPrcTp) || "1A1".equals(MasterDataPrcTp) || "1A2".equals(MasterDataPrcTp))MasterDataPrcTpStr = PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale);
            else if("1B0".equals(MasterDataPrcTp) || "1B1".equals(MasterDataPrcTp))                            MasterDataPrcTpStr = PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale);
            String _UseTp = row.getAttribute("USE_TP")==null?"&nbsp;":(String)row.getAttribute("USE_TP");
            if("S".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
            else if("Y".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
            else if("N".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
            else if("F".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
            String MdExplain = row.getAttribute("MD_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MD_EXPLAIN");
            if("%".equals(sUseTp)){
               MdExplain = MdExplain+"["+row.getAttribute("VERSION")+"]";
            }
            String HierarchyOpTpStr = HierarchyOpTpMap.containsKey((String)row.getAttribute("HIERARCHY_OP_TP"))
                ?HierarchyOpTpMap.get((String)row.getAttribute("HIERARCHY_OP_TP"))
                :(String)row.getAttribute("HIERARCHY_OP_TP");
            String HierarchyOwnerShipTpStr = HierarchyOwnerShipTpMap.containsKey((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                ?HierarchyOwnerShipTpMap.get((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                :(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP");
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)><%if(isAdmin){%>
      <td><input type="radio" name="rdo" value="<%=rowCnt%>"></td><%    }else{%>
      <td><%=(rowCnt+1) + (Integer.parseInt(curPage)-1)*20%></td><%     }%>
      <td><%=MasterDataPrcTpStr%><input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>"></td>
      <td><%=_UseTp%></td>
      <td align="left"><a href="javascript:" onClick="goViewPage(<%=rowCnt%>,'VIEW')"><%=MdExplain%></a></td>
      <td><%=row.getAttribute("MD_NM")==null?"&nbsp;":(String)row.getAttribute("MD_NM")%></td>
      <td><%=row.getAttribute("CNG_GD")==null?"&nbsp;":(String)row.getAttribute("CNG_GD")%></td>
      <td><%=HierarchyOpTpStr.length()>3?HierarchyOpTpStr.substring(0,3)+"...":HierarchyOpTpStr%></td>
      <td><%=HierarchyOwnerShipTpStr.length()>3?HierarchyOwnerShipTpStr.substring(0,3)+"...":HierarchyOwnerShipTpStr%></td>
      <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
      <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td><% if(isJCS){%>
      <td><% if(row.getAttribute("ACCORD_DATA_CONFIRM_DEST_FLAG")!=null){%><img src="img/gm0004img.gif" border=0 onClick="goJCSPage(<%=rowCnt%>)" style="cursor:pointer"><%}else{%>&nbsp;<%}%></td><%}%>
      <input type="hidden" name="MdlDefineId" value="<%=row.getAttribute("MD_ID")%>">
      <input type="hidden" name="MdlDefineCngGd" value="<%=(String)row.getAttribute("CNG_GD")%>">
      <input type="hidden" name="HierarchyDataId" value="<%=row.getAttribute("HIERARCHY_DATA_ID")%>">
      <input type="hidden" name="MdlDefineNm" value="<%=(String)row.getAttribute("MD_NM")%>">
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
      <td>&nbsp;</td>
      <td>&nbsp;</td><% if(isJCS){ %>
      <td>&nbsp;</td><% } %>
  </tr><%
        }
        rowset.reset();
    }
%>
  </table>
            <div align="center">
            <posui:showPageSet infoName="BusinessRuleList" formName="document.forms[0]" curPageName="curPageName"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000202010.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000202010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="SearchMasterDataPrcTp" value="<%=sMasterDataPrcTp%>">
<input type="hidden" name="SearchUseTp" value="<%=sUseTp%>">
<input type="hidden" name="SearchHierarchyOpTp" value="<%=sHierarchyOpTp%>">
<input type="hidden" name="SearchHierarchyOwnerShipTp" value="<%=sHierarchyOwnerShipTp%>">
<input type="hidden" name="SearchAttribute" value="<%=sSearchAttribute%>">
<input type="hidden" name="SearchWord" value="<%=sSearchWord%>">
</form>
<form name="form_jcs" method="post" action="m000202010.do"><!-- jcs -->
<input type="hidden" name="ServiceName" value="m000202010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isJCS%>">
<input type="hidden" name="jcs" value="10"><!-- event -->
<input type="hidden" name="MdlDefineNm">
</form>
<form name="form_rule_data" method="post"><!-- m000202020.do,m000202040.do,m000202050,m000202070.do,m000202080.do-->
<input type="hidden" name="ServiceName"><!-- m000202020-service,m000202040-service,m000202050-service,m000202070-service,m000202080-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="isNew"><!-- 신규/수정  구분 -->
<input type="hidden" name="MdlDefineId" value="">
<input type="hidden" name="MdlDefineNm" value="">
<input type="hidden" name="MdRuleId" value="">
<input type="hidden" name="MasterDataPrcTp" value="">
<input type="hidden" name="MdlDefineCngGd" value="">
<input type="hidden" name="HierarchyDataId" value="">
</form>
<form name="form_import" method="post" action="m000202020.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000202020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
</form>
<form name="form_jcs_rule_list" method="post" action="m000202310.do"><!-- jcs -->
<input type="hidden" name="ServiceName" value="m000202310-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isJCS%>">
</form>
    </td>
  </tr>
</table>
</body>
</html>