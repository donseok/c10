<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 업무기준 목록 >> 업무기준 기본속성 등록
 * Open Issues    :
 * Change history
 * @2008-05-19 류진영 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext) request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale) pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo"); //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");

    String MdlDefineNm = "";
    String MdlDefineId = null;
    String HierarchyDataId = "";
    String MasterDataPrcTp = ""; //MasterData처리유형
    String HierarchyWksShareL = null;
    String MdlDefineCngGd = null;
    String HierarchyOpTp = null;
    String HierarchyOwnerShipTp = null;
    String MdlDefineOwnerEmpNo = "";
    String MdlDefineVersion = null;
    String MdlDefineExplain = null;
    String HierarchyKeyDtNmTp = "";
    String HierarchyDataAttr = null;
    String StartActiveDate = null;
    String EndActiveDate = null;
    String UseTp = "S";
    String Attribute3 = null;

    PosRowSet rowSet = (PosRowSet) ctx.get("TbM00Depend010VOResult");
    PosRow row = null;
    if (rowSet != null && rowSet.count() >= 1) {
        row = rowSet.next();
        HierarchyDataId = String.valueOf(row.getAttribute("HIERARCHY_DATA_ID"));
        HierarchyWksShareL = (String) row.getAttribute("HIERARCHY_WKS_SHARE_L");
        HierarchyOpTp = (String) row.getAttribute("HIERARCHY_OP_TP");
        HierarchyOwnerShipTp = (String) row.getAttribute("HIERARCHY_OWNER_SHIP_TP");
        HierarchyKeyDtNmTp = (String) row.getAttribute("HIERARCHY_KEY_DT_NM_TP");
        HierarchyDataAttr = (String) row.getAttribute("HIERARCHY_DATA_ATTR");
        MasterDataPrcTp = (String) row.getAttribute("MASTER_DATA_PRC_TP");
        if(MasterDataPrcTp.startsWith("1A") || MasterDataPrcTp.startsWith("1B")){
            if(MasterDataPrcTp.startsWith("1A")){
                rowSet = (PosRowSet) ctx.get("TbM00DefinesVOResult");
                row = rowSet.next();
                MdlDefineNm = (String) row.getAttribute("MDL_DEFINE_NM");
                MdlDefineId = String.valueOf(row.getAttribute("MDL_DEFINE_ID"));
                MdlDefineCngGd = (String) row.getAttribute("MDL_DEFINE_CNG_GD");
                MdlDefineVersion = (String) row.getAttribute("MDL_DEFINE_VERSION");
                MdlDefineExplain = (String) row.getAttribute("MDL_DEFINE_EXPLAIN");
                MdlDefineOwnerEmpNo = (String) row.getAttribute("MDL_DEFINE_OWNER_EMP_NO");
            }else if(MasterDataPrcTp.startsWith("1B")){
                rowSet = (PosRowSet) ctx.get("TbM00Rules010VOResult");
                row = rowSet.next();
                MdlDefineNm = (String) row.getAttribute("MD_RULE_NM");
                MdlDefineId = String.valueOf(row.getAttribute("MD_RULE_ID"));
                MdlDefineCngGd = (String) row.getAttribute("MD_RULE_CNG_GD");
                MdlDefineVersion = (String) row.getAttribute("MD_RULE_VERSION");
                MdlDefineExplain = (String) row.getAttribute("MD_RULE_EXPLAIN");
                MdlDefineOwnerEmpNo = (String) row.getAttribute("MD_RULE_OWNER_EMP_NO");
            }
            UseTp = (String) row.getAttribute("USE_TP");
            StartActiveDate = (String) row.getAttribute("START_ACTIVE_DATE_STR");
            EndActiveDate = (String) row.getAttribute("END_ACTIVE_DATE_STR");
            Attribute3 = row.getAttribute("ATTRIBUTE3") == null ? "N" : row.getAttribute("ATTRIBUTE3").toString();
        }
    }
    if(isError || row==null){
        MdlDefineNm = request.getParameter("MdlDefineNm") != null ? request.getParameter("MdlDefineNm") : MdlDefineNm;
        MasterDataPrcTp = request.getParameter("MasterDataPrcTp") != null ? request.getParameter("MasterDataPrcTp") : MasterDataPrcTp;
        MdlDefineExplain = request.getParameter("MdlDefineExplain") != null ? request.getParameter("MdlDefineExplain") : MdlDefineExplain;
        MdlDefineOwnerEmpNo = request.getParameter("MdlDefineOwnerEmpNo") != null ? request.getParameter("MdlDefineOwnerEmpNo") : UserEmpNo;
        MdlDefineVersion = request.getParameter("MdlDefineVersion") != null ? request.getParameter("MdlDefineVersion") : "1.0";
        StartActiveDate = request.getParameter("StartActiveDate") != null ? request.getParameter("StartActiveDate") : PosMasterUtility.getCurTime("yyyy-MM-dd HH:mm:ss");
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource", "gm.title.049", null, locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showCalendar.js"></script>
<script type="text/javascript">
<!--
function goCmd(mode){
    var MasterDataPrcTp = mode=='insert'
      ? document.forms[0].MasterDataPrcTp[document.forms[0].MasterDataPrcTp.selectedIndex].value
      : document.forms[0].MasterDataPrcTp.value;
    if(  MasterDataPrcTp=='1A0'
       ||MasterDataPrcTp=='1A1'
       ||MasterDataPrcTp=='1A2'){
        document.forms[0].HierarchyKeyDtNmTp.value='D1';
        document.forms[0].action = document.forms[0].action+"?general=10&save=10";
    }else{
        document.forms[0].HierarchyKeyDtNmTp.value='R1';
        document.forms[0].action = document.forms[0].action+"?decision=10&save=10";
    }
    if(document.forms[0].MdlDefineNm.value == ""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)},locale)%>'); //기준ID
        return;
    }else if(MasterDataPrcTp=="error"){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0262",null,locale)},locale)%>'); //종류
        return;
    }else if(document.forms[0].MdlDefineExplain.value == ""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)},locale)%>'); //업무기준명
        return;
    }else if(document.forms[0].MdlDefineOwnerEmpNo.value == ""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)},locale)%>'); //담당자
        return;
    }else{
        document.forms[0].target = "_self";
        document.forms[0].submit();
    }
}
function goLayout(){
    if(  document.forms[0].MasterDataPrcTp.value=='1A0'
       ||document.forms[0].MasterDataPrcTp.value=='1A1'
       ||document.forms[0].MasterDataPrcTp.value=='1A2'){
        document.forms[0].action = "m000202030.do?inputLayout=10";
        document.forms[0].ServiceName.value="m000202030-service";
    }else{
        document.forms[0].action = "m000202060.do?inputLayout=10";
        document.forms[0].ServiceName.value="m000202060-service";
    }
    document.forms[0].target = "_self";
    document.forms[0].submit();
}
function goData(){
    if(document.forms[0].MasterDataPrcTp.value=='1A0'){
        document.forms[0].action="m000202040.do?saveData=true&pageSize=15";
        document.forms[0].ServiceName.value="m000202040-service";
    } else if(document.forms[0].MasterDataPrcTp.value=='1A1'){
        document.forms[0].action="m000202050.do?saveData=true";
        document.forms[0].ServiceName.value="m000202050-service";
    } else if(document.forms[0].MasterDataPrcTp.value=='1A2'){
        document.forms[0].action="m000202040.do?saveData=true&pageSize=15";
        document.forms[0].ServiceName.value="m000202040-service";
    } else if(document.forms[0].MasterDataPrcTp.value=='1B0'){
        document.forms[0].action='m000202070.do?saveData=true';
        document.forms[0].ServiceName.value="m000202070-service";
    } else{
        document.forms[0].action='m000202080.do?saveData=true';
        document.forms[0].ServiceName.value="m000202080-service";
    }
    document.forms[0].target = "_self";
    document.forms[0].submit();
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource", "gm.title.049", null, locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_rule_header" method="post" action="m000202020.do"><!-- m000202030.do,m000202060.do,m000202040.do,m000202050,m000202070.do,m000202080.do -->
<input type="hidden" name="ServiceName" value="m000202020-service"><!-- m000202030-service,m000202060-service,m000202040-service,m000202050-service,m000202070-service,m000202080-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID") == null ? "SecurityError" : request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="HierarchyKeyDtNmTp" value='<%=HierarchyKeyDtNmTp%>'>
<input type="hidden" name="HierarchyDataId" value='<%=HierarchyDataId%>'>
<input type="hidden" name="MdlDefineId" value='<%=MdlDefineId == null ? "" : MdlDefineId%>'>
<input type="hidden" name="MdRuleId" value='<%=MdlDefineId == null ? "" : MdlDefineId%>'>
<input type="hidden" name="MdRuleNm" value='<%=MdlDefineNm%>'>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="right"><%
    if (isAdmin) {
        if (MdlDefineId != null && "S".equals(UseTp)) {
%>
            <img src="<%=PosContext.getResourceMessage("GMResource", "gm.img.next", null, locale)%>" onClick="goLayout()" style="cursor:pointer" alt="LAYOUT"><!-- next(layout) --><%
        }
        if (MdlDefineId != null) {
%>
            <img src="<%=PosContext.getResourceMessage("GMResource", "gm.img.next", null, locale)%>" onClick="goData()" style="cursor:pointer" alt="DATA"><!-- next(data) -->
            <img src="<%=PosContext.getResourceMessage("GMResource", "gm.img.edit", null, locale)%>" onClick="goCmd('modify')" style="cursor:pointer"><!-- modify --><%
        } else {
%>
            <img src="<%=PosContext.getResourceMessage("GMResource", "gm.img.save", null, locale)%>" onClick="goCmd('insert')" style="cursor:pointer"><!-- save --><%
        }
    }
%>
            <img src="<%=PosContext.getResourceMessage("GMResource", "gm.img.close", null, locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
            <div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">1.<%=PosContext.getResourceMessage("GMResource", "gm.label.0038", null, locale)%></div>
            <table width=100% border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF>
              <tr height=20>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource", "gm.label.0035", null, locale)%></td>
                <td class=tbllw><%
    if (MdlDefineId!=null){
%>
                  <input type="text" name="MdlDefineNm" value="<%=MdlDefineNm%>" class=adg1 readonly><%
    } else {
%>
                  <input type="text" name="MdlDefineNm" value="<%=MdlDefineNm%>" class=adb1><%
    }
%>
                </td>
                <td class=tbldb width=150><%=PosContext.getResourceMessage("GMResource", "gm.label.0262", null, locale)%></td>
                <td class=tbllw width=330><%
    if (MdlDefineId==null) {
%>
                  <select name="MasterDataPrcTp" class="adf">
                    <option value="error"><%=PosContext.getResourceMessage("GMResource", "gm.label.0255", null, locale)%></option>
                    <option value="1A0" <%="1A0".equals(MasterDataPrcTp) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0105", null, locale)%></option>
                    <option value="1A1" <%="1A1".equals(MasterDataPrcTp) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0137", null, locale)%></option>
                    <option value="1A2" <%="1A2".equals(MasterDataPrcTp) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0075", null, locale)%></option>
                    <option value="1B0" <%="1B0".equals(MasterDataPrcTp) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0191", null, locale)%></option>
                    <option value="1B1" <%="1B1".equals(MasterDataPrcTp) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0151", null, locale)%></option>
                  </select><%
    } else {
        if ("1A0".equals(MasterDataPrcTp)) {
%>
                  <input type="text" value="<%=PosContext.getResourceMessage("GMResource", "gm.label.0105", null, locale)%>" class=adg1 readonly><%
        } else if ("1A1".equals(MasterDataPrcTp)) {
%>
                  <input type="text" value="<%=PosContext.getResourceMessage("GMResource", "gm.label.0137", null, locale)%>" class=adg1 readonly><%
        } else if ("1A2".equals(MasterDataPrcTp)) {
%>
                  <input type="text" value="<%=PosContext.getResourceMessage("GMResource", "gm.label.0075", null, locale)%>" class=adg1 readonly><%
        } else if ("1B0".equals(MasterDataPrcTp)) {
%>
                  <input type="text" value="<%=PosContext.getResourceMessage("GMResource", "gm.label.0191", null, locale)%>" class=adg1 readonly><%
        } else if ("1B1".equals(MasterDataPrcTp)) {
%>
                  <input type="text" value="<%=PosContext.getResourceMessage("GMResource", "gm.label.0151", null, locale)%>" class=adg1 readonly><%
        }
%>
                  <input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>"><%
    }
%>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0036", null, locale)%></td>
                <td class=tbllw><input type="text" name="MdlDefineExplain" value="<%=(MdlDefineExplain == null ? "" : MdlDefineExplain)%>" size="50" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0161", null, locale)%></td>
                <td class=tbllw><input type="text" name="MdlDefineOwnerEmpNo" value="<%=MdlDefineOwnerEmpNo%>" class=adb1></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0115", null, locale)%></td>
                <td class=tbllw>
                  <select name="HierarchyWksShareL" class="adf">
                    <option value="A" <%="A".equals(HierarchyWksShareL) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0235", null, locale)%></option>
                    <option value="Z" <%="Z".equals(HierarchyWksShareL) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0195", null, locale)%></option>
                  </select>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0106", null, locale)%></td>
                <td class=tbllw>
                  <select name="MdlDefineCngGd" class="adf">
                    <option value="A" <%="A".equals(MdlDefineCngGd) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0019", null, locale)%></option>
                    <option value="B" <%="B".equals(MdlDefineCngGd) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0033", null, locale)%></option>
                  </select>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0047", null, locale)%></td>
                <td class=tbllw>
                  <select name="HierarchyOpTp" class="adf"><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
%>
                    <option value="<%=value[0]%>" <%=value[0].equals(HierarchyOpTp)?"selected":""%>>[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0082", null, locale)%></td>
                <td class=tbllw>
                  <select name="HierarchyOwnerShipTp" class="adf"><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
%>
                    <option value="<%=value[0]%>" <%=value[0].equals(HierarchyOwnerShipTp)?"selected":""%>>[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0215", null, locale)%></td>
                <td class=tbllw><% if(MdlDefineId!=null){%>
                  <input type="text" name="StartActiveDate" value="<%=StartActiveDate%>" style="width:120" class=adg1 readonly> ~<%}else{%>
                  <input type="text" name="StartActiveDate" value="<%=StartActiveDate%>" style="width:120" class=adb1>
                  <img src="img/gm0002img.gif" style="cursor:pointer" border="0" onClick="javascript:jspCalendar(this.parentElement.index,document.forms[0].StartActiveDate,'','true');"> ~<%} %> 
                  <input type="text" name="EndActiveDate" value="<%=EndActiveDate == null ? "2999-12-31 23:59:59" : EndActiveDate%>" style="width:120" class=adb1>
                  <img src="img/gm0002img.gif" style="cursor:pointer" border="0" onClick="javascript:jspCalendar(this.parentElement.index,document.forms[0].EndActiveDate,'','true');">
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0232", null, locale)%></td>
                <td class=tbllw><input type="text" name="MdlDefineVersion" value="<%=MdlDefineVersion%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
              </tr>
              <tr height=20>
                <td class=tbldb>[데이타종류]</td>
                <td class=tbllw>
                  <select name="HierarchyDataAttr" class="adf">
                    <option value="A" <%="A".equals(HierarchyDataAttr) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0165", null, locale)%></option>
                    <option value="B" <%="B".equals(HierarchyDataAttr) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0166", null, locale)%></option>
                    <option value="C" <%="C".equals(HierarchyDataAttr) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0263", null, locale)%></option>
                    <option value="D" <%="D".equals(HierarchyDataAttr) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0189", null, locale)%></option>
                  </select>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0116", null, locale)%></td>
                <td class=tbllw>
                  <select name="Attribute3" class="adf">
                    <option value="N" <%="N".equals(Attribute3) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource", "gm.label.0239", null, locale)%></option>
                  </select>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource", "gm.label.0227", null, locale)%></td>
                <td class=tbllw><%
    if ("S".equals(UseTp) || "F".equals(UseTp)) {
%>
                  <select name="UseTp" class="adf">
                    <option value="S" <%="S".equals(UseTp) ? "selected" : ""%>>[S]<%=PosContext.getResourceMessage("GMResource", "gm.label.0114", null, locale)%></option>
                    <option value="F" <%="F".equals(UseTp) ? "selected" : ""%>>[F]<%=PosContext.getResourceMessage("GMResource", "gm.label.0175", null, locale)%></option>
                  </select><%
    } else if ("Y".equals(UseTp)) {
%>
                  <select name="UseTp" class="adf">
                    <option value="Y" <%="Y".equals(UseTp) ? "selected" : ""%>>[Y]<%=PosContext.getResourceMessage("GMResource", "gm.label.0032", null, locale)%></option>
                    <option value="N" <%="N".equals(UseTp) ? "selected" : ""%>>[N]<%=PosContext.getResourceMessage("GMResource", "gm.label.0093", null, locale)%></option>
                  </select><%
    } else {
%>
                  <select name="UseTp" class="adf">
                    <option value="N" <%="N".equals(UseTp) ? "selected" : ""%>>[N]<%=PosContext.getResourceMessage("GMResource", "gm.label.0093", null, locale)%></option>
                  </select><%
    }
%>
                </td>
                <td class=tbldb>[수정가능사용자]</td>
                <td class=tbllw>
                  <select class="adf"><%
    rowSet = (PosRowSet) ctx.get("TbM00MdRespGrUser_Result");
    String selectedUser = null;
    if(rowSet!=null && rowSet.hasNext()){
        while(rowSet.hasNext()){
            row = rowSet.next();
            if(UserEmpNo.equals(row.getAttribute("USER_EMP_NO"))){
                selectedUser = UserEmpNo;
%>
                    <option selected><%=row.getAttribute("USER_EMP_NO")%>(<%=row.getAttribute("USER_NAME")%>)</option><%
            }else{
%>
                    <option><%=row.getAttribute("USER_EMP_NO")%>(<%=row.getAttribute("USER_NAME")%>)</option><%
            }
        }
        if(selectedUser==null){
%>
                    <option selected> </option><%
        }
    }else{
%>
                    <option> </option><%
    }
%>
                  </select><%=selectedUser==null?"&nbsp;["+UserEmpNo+"] 수정권한없음":""%> 
                </td>
              </tr>
            </table>
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