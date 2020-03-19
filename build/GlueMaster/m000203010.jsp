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
 * @FileName      : 계산수식 목록
 * Open Issues    :
 * Change history 
 * @2008-03-07 김정희 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
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
        PosSecurityUtil.checkPageID("m000203010");
        isAdmin = PosMenu.getCurPage().isPermitAction("modify");//new,insert,modify
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

    String sSearchUseTp = request.getParameter("SearchUseTp")== null?"Y": request.getParameter("SearchUseTp");
    String sMasterDataPrcTp =request.getParameter("SearchMasterDataPrcTp")== null?"%": request.getParameter("SearchMasterDataPrcTp");
    String sHierarchyOpTp = request.getParameter("SearchHierarchyOpTp")==null?"%":request.getParameter("SearchHierarchyOpTp");
    String sHierarchyOwnerShipTp = request.getParameter("SearchHierarchyOwnerShipTp")==null?"%":request.getParameter("SearchHierarchyOwnerShipTp");
    String sSearchAttribute = request.getParameter("SearchAttribute")== null?"": request.getParameter("SearchAttribute");
    String sSearchWord = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
    String curPage = request.getParameter("curPage")== null?"1": request.getParameter("curPage");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.074",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
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
function gm_Detail(calc_index){
    document.form_detail.MdRuleId.value= document.forms[0].MdRuleId.length>1 ? document.forms[0].MdRuleId[calc_index].value : document.forms[0].MdRuleId.value;
    showPopup("","m000203010_detail",1016,641,'1',0,0,1,1,1,0,0);
    document.form_detail.target = "m000203010_detail";
    document.form_detail.submit();
}
function gm_modify(){
    //선택된 라디오 버튼 확인.
    var i;
    var index;
    index=-1;
    if (document.forms[0].chk.length >= 2){
        for(i=0;i<document.forms[0].chk.length;i++){
            if(document.forms[0].chk[i].checked==true){
                index=i;
            }
        }
    }else{
        index =  document.forms[0].chk.checked? 1 : -1;
    }
    if(index==-1){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return false;
    }
    document.form_cal_data.MdRuleId.value       =document.forms[0].MdRuleId.length > 1 ? document.forms[0].MdRuleId[index].value       :document.forms[0].MdRuleId.value;
    document.form_cal_data.MasterDataPrcTp.value=document.forms[0].MdRuleId.length > 1 ? document.forms[0].MasterDataPrcTp[index].value:document.forms[0].MasterDataPrcTp.value;
    document.form_cal_data.calctype.value       =document.form_cal_data.MasterDataPrcTp.value=="1C2"?"complex":"simple";
    showPopup("","m000203010_modify",1016,641,'1',0,0,1,1,1,0,0);
    document.form_cal_data.target = "m000203010_modify";
    document.form_cal_data.submit();
}
function gm_new(){
    var actionstr = document.form_cal_data.action;// action 원래대로
    document.form_cal_data.MasterDataPrcTp.value="1C0";
    document.form_cal_data.action = document.form_cal_data.action+"?new=1";
    showPopup("","m000203010_new",1016,641,'1',0,0,1,1,1,0,0);
    document.form_cal_data.target = "m000203010_new";
    document.form_cal_data.submit();
    document.form_cal_data.action = actionstr;
}
//Import 페이지로 이동
function go_open_import(){
    if(confirm("구조식을 등록하시겠습니까? (YES:구조식, NO:항목)")){
        showPopup("","m000203010_import",500,450,'1',0,0,1,1,1,0,0);
        document.form_import.target="m000203010_import";
        document.form_import.submit();
    }else{
        showPopup("","m000203010_import2",500,450,'1',0,0,1,1,1,0,0);
        document.form_import2.target="m000203010_import2";
        document.form_import2.submit();
    }
}

//export종류 판단
function go_export(){
    if(confirm("Import용 파일로 Export하시겠습니까? (YES:import용, NO:항목)")){
         if(confirm("구조식용 파일을 Export하시겠습니까? (YES:구조식, NO:INPUT항목)")){
             document.form_export2.export2.value="fomula";
             document.form_export2.submit();
         }else{
             //선택된 라디오 버튼 확인.
             var i;
             var index;
             index=-1;
             
             if (document.forms[0].chk.length >= 2){
               for(i=0;i<document.forms[0].chk.length;i++){
                 if(document.forms[0].chk[i].checked==true){
                   index=i;
                 }
               }
             }else{
               index =  document.forms[0].chk.checked? 1 : -1;
             }
             if(index==-1){
               alert('Export하고자하는 계산식을 선택하여 주세요');
               return false;
             }
             document.form_export2.MdRuleId.value       =document.forms[0].MdRuleId.length > 1 ? document.forms[0].MdRuleId[index].value       :document.forms[0].MdRuleId.value;
             document.form_export2.export2.value="input";
             document.form_export2.submit();
         }
    }else{
        document.form_export.submit();
    }
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.074",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_cal" method="post" action="m000203010.do">
<input type="hidden" name="ServiceName" value="m000203010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
  <select name="SearchMasterDataPrcTp" class="adf">
    <option value="%" <%=    "%".equals(sMasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0237",null,locale)%></option>
    <option value="1C0" <%="1C0".equals(sMasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0192",null,locale)%></option>
    <option value="1C2" <%="1C2".equals(sMasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale)%></option>
  </select>&nbsp;&nbsp;
  <select name="SearchUseTp" class="adf"><!--gm.label.0227-->
    <option value="%" <%="%".equals(sSearchUseTp)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></option>
    <option value="S" <%="S".equals(sSearchUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
    <option value="F" <%="F".equals(sSearchUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
    <option value="Y" <%="Y".equals(sSearchUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
    <option value="N" <%="N".equals(sSearchUseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
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
    <option value="MD_RULE_EXPLAIN" <%="MD_RULE_EXPLAIN".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></option>
    <option value="MD_RULE_NM" <%=          "MD_RULE_NM".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></option>
    <option value="USER_NAME" <%=            "USER_NAME".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
          </td>
        </tr>
        <tr>
          <td align="right"><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onclick="gm_new()" style="cursor:pointer"><!-- register -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onclick="gm_modify()" style="cursor:pointer"><!-- modify -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="go_open_import()" style="cursor:pointer"><!-- import --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="go_export()" style="cursor:pointer"><!-- export -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.help",null,locale)%>" style="cursor:pointer"><!-- help -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr valign=top>
          <td align="left"><%
if(isAdmin){
%>
  <table id=mainTable width="980" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td width="35">chk</td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="285"><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%
    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("CalcSelectListVOResult") : null;
    int rowCnt = 0;
    if( rowset!=null ){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
            String MasterDataPrcTp = (String)row.getAttribute("MASTER_DATA_PRC_TP");
            String MasterDataPrcTpStr = "&nbsp;";
            if("1C0".equals(MasterDataPrcTp))     MasterDataPrcTpStr = PosContext.getResourceMessage("GMResource","gm.label.0192",null,locale);
            else if("1C2".equals(MasterDataPrcTp))MasterDataPrcTpStr = PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale);
            String _UseTp = row.getAttribute("USE_TP")==null?"&nbsp;":(String)row.getAttribute("USE_TP");
            if("S".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
            else if("Y".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
            else if("N".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
            else if("F".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
            String MdRuleExplain = row.getAttribute("MD_RULE_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_EXPLAIN");
            if("%".equals(sSearchUseTp)){
               MdRuleExplain = MdRuleExplain+"["+row.getAttribute("MD_RULE_VERSION")+"]";
            }
            String HierarchyOpTpStr = HierarchyOpTpMap.containsKey((String)row.getAttribute("HIERARCHY_OP_TP"))
                ?HierarchyOpTpMap.get((String)row.getAttribute("HIERARCHY_OP_TP"))
                :(String)row.getAttribute("HIERARCHY_OP_TP");
            String HierarchyOwnerShipTpStr = HierarchyOwnerShipTpMap.containsKey((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                ?HierarchyOwnerShipTpMap.get((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                :(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP");
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><input type="radio" name="chk" value="<%=rowCnt%>"></td>
      <td><%=MasterDataPrcTpStr%><input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>"></td>
      <td><%=_UseTp%><input type="hidden" name="MdRuleId" value="<%=row.getAttribute("MD_RULE_ID")%>"></td>
      <td align="left"><a href="javascript:" onClick="gm_Detail(<%=rowCnt%>)"><%=MdRuleExplain%></a></td>
      <td><%=row.getAttribute("MD_RULE_NM")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_NM")%></td>
      <td><%=HierarchyOpTpStr.length()>3?HierarchyOpTpStr.substring(0,3)+"...":HierarchyOpTpStr%></td>
      <td><%=HierarchyOwnerShipTpStr.length()>3?HierarchyOwnerShipTpStr.substring(0,3)+"...":HierarchyOwnerShipTpStr%></td>
      <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
      <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
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
  </tr><%
        }
        rowset.reset();
    }
}else{ 
%>
  <table id=mainTable width="980" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td width="35">no.</td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td width="285"><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
    </tr><%

    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("CalcSelectListVOResult") : null;
    int rowCnt = 0, curpage = Integer.parseInt(curPage)-1;
    if( rowset!=null ){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
            String MasterDataPrcTp = (String)row.getAttribute("MASTER_DATA_PRC_TP");
            String MasterDataPrcTpStr = "&nbsp;";
            if("1C0".equals(MasterDataPrcTp))     MasterDataPrcTpStr = PosContext.getResourceMessage("GMResource","gm.label.0192",null,locale);
            else if("1C2".equals(MasterDataPrcTp))MasterDataPrcTpStr = PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale);
            String _UseTp = row.getAttribute("USE_TP")==null?"&nbsp;":(String)row.getAttribute("USE_TP");
            if("S".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
            else if("Y".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
            else if("N".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
            else if("F".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
            String MdRuleExplain = row.getAttribute("MD_RULE_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_EXPLAIN");
            if("%".equals(sSearchUseTp)){
               MdRuleExplain = MdRuleExplain+"["+row.getAttribute("MD_RULE_VERSION")+"]";
            }
            String HierarchyOpTpStr = HierarchyOpTpMap.containsKey((String)row.getAttribute("HIERARCHY_OP_TP"))
                ?HierarchyOpTpMap.get((String)row.getAttribute("HIERARCHY_OP_TP"))
                :(String)row.getAttribute("HIERARCHY_OP_TP");
            String HierarchyOwnerShipTpStr = HierarchyOwnerShipTpMap.containsKey((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                ?HierarchyOwnerShipTpMap.get((String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP"))
                :(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP");
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><%=(curpage*20)+(rowCnt+1)%></td>
      <td><%=MasterDataPrcTpStr%><input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>"></td>
      <td><%=_UseTp%><input type="hidden" name="MdRuleId" value="<%=row.getAttribute("MD_RULE_ID")%>"></td>
      <td align="left"><a href="javascript:" onClick="gm_Detail(<%=rowCnt%>)"><%=MdRuleExplain%></a></td>
      <td><%=row.getAttribute("MD_RULE_NM")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_NM")%></td>
      <td><%=HierarchyOpTpStr.length()>3?HierarchyOpTpStr.substring(0,3)+"...":HierarchyOpTpStr%></td>
      <td><%=HierarchyOwnerShipTpStr.length()>3?HierarchyOwnerShipTpStr.substring(0,3)+"...":HierarchyOwnerShipTpStr%></td>
      <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
      <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
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
  </tr><%
        }
        rowset.reset();
    }
}
%>
  </table>
            <div align="center">
            <posui:showPageSet infoName="CalcSelectListVOResult" formName="document.forms[0]" curPageName="curPage"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000203010.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000203010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="SearchUseTp" value="<%=sSearchUseTp%>">
<input type="hidden" name="SearchMasterDataPrcTp" value="<%=sMasterDataPrcTp%>">
</form>
<form name="form_export2" method="post" action="m000203010.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000203010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export2" value="10"><!-- event -->
<input type="hidden" name="SearchUseTp" value="<%=sSearchUseTp%>">
<input type="hidden" name="SearchMasterDataPrcTp" value="<%=sMasterDataPrcTp%>">
<input type="hidden" name="MdRuleId" value="">
</form>
<form name="form_detail" method="post" action="m000203010.do"><!-- detail view -->
<input type="hidden" name="ServiceName" value="m000203010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="detail" value="10"><!-- event -->
<input type="hidden" name="MdRuleId">
<input type="hidden" name="ActionType_L" value="L">
<input type="hidden" name="ActionType_C" value="C">
</form>
<form name="form_cal_data" method="post" action="m000203030.do"><!-- new/modify -->
<input type="hidden" name="ServiceName" value="m000203030-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="MdRuleId">
<input type="hidden" name="MasterDataPrcTp">
<input type="hidden" name="calctype">
<input type="hidden" name="ActionType_L" value="L">
<input type="hidden" name="ActionType_C" value="C">
</form>
<form name="form_import" method="post" action="m000203030.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000203030-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
</form>
<form name="form_import2" method="post" action="m000203030.do"><!-- import2 -->
<input type="hidden" name="ServiceName" value="m000203030-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import2" value="10"><!-- event -->
</form>
    </td>
  </tr>
</table>
</body>
</html>