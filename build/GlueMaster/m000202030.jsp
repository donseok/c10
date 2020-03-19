<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
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
 * @FileName      : 업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 조회(일반) >> 업무기준 구조조회(일반)
 *                  업무기준 목록 >> 업무기준 내용상세_일반기준 >> 업무기준 구조조회(일반)
 * Open Issues    :
 * Change history
 * @2008-03-18 류진영 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

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

    String modifyFlag = request.getParameter("modifyFlag")==null?"":request.getParameter("modifyFlag");
    Boolean isModify = modifyFlag.equals("") ? false : new Boolean(modifyFlag);

    String Modify = request.getParameter("Modify");

    PosRowSet rowSet = (PosRowSet)ctx.get("Defind010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1A0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale);
    else if("1A1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0137",null,locale);
    else if("1A2".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0075",null,locale);
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String UseTpStr = "";
    if("S".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
    else if("Y".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
    else if("N".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
    else if("F".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
    String MdlDefineCngGdStr = headerRow.getAttribute("MDL_DEFINE_CNG_GD")==null?"":(String)headerRow.getAttribute("MDL_DEFINE_CNG_GD");
    if("A".equals(MdlDefineCngGdStr)) MdlDefineCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale);
    else if("B".equals(MdlDefineCngGdStr)) MdlDefineCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale);

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.051",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function goGeneralDate(type){
    if(document.forms[0].MasterDataPrcTp.value=='1A0' || document.forms[0].MasterDataPrcTp.value=='1A2'){
        if(type=='VIEW'){
            document.forms[0].Modify.value="";
            document.forms[0].action='m000202040.do';
        }else{
            document.forms[0].action='m000202040.do?saveData=true&pageSize=15';
        }
        document.forms[0].ServiceName.value="m000202040-service";
    }else{
        if(type=='VIEW'){
            document.forms[0].Modify.value="";
            document.forms[0].action='m000202050.do';
        }else{
            document.forms[0].action='m000202050.do?saveData=true';
        }
        document.forms[0].ServiceName.value="m000202050-service";
    }
    document.forms[0].submit();
}
function viewDepend(tc_id_index){
    alert(document.forms[0].StandardEnglishId[tc_id_index].value);
}
function goImport(){
    <% if("Y".equals(UseTp)){%>
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0113",null,locale)%> \n <%=PosContext.getResourceMessage("GMResource","gm.msg.0114",null,locale)%>')){
    <%}%>
        document.form_import.MdlDefineNm.value=document.forms[0].MdlDefineNm.value;
        showPopup("","m000202030_import",500,450,'1',0,0,1,1,1,0,0);
        document.form_import.target="m000202030_import";
        document.form_import.submit();
    <% if("Y".equals(UseTp)){%>
    }
    <%}%>
}
function gm_select_all(){
    if (document.forms[0].chk.length >= 2){
        for(i=0; i<document.forms[0].chk.length; i++){
            document.forms[0].chk[i].checked = !document.forms[0].chk[i].checked;
        }
    }else{
        document.forms[0].chk.checked = !document.forms[0].chk.checked;
    }
}
function goSaveLength(){
    if(document.forms[0].DtNmId!=undefined){
        if(document.forms[0].DtNmId.length >= 2){
            for(i=0; i<document.forms[0].DtNmId.length; i++){
                if(Trim(document.forms[0].MdlDefineDtNmLen.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)},locale)%>'); //길이
                    document.forms[0].MdlDefineDtNmLen[i].focus();
                    return;
                }
            }
        }else{
            if(Trim(document.forms[0].MdlDefineDtNmLen.value)==""){
                alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)},locale)%>'); //길이
                document.forms[0].MdlDefineDtNmLen.focus();
                return;
            }
        }
    }else{
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0120",null,locale)%>');
        return;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>')){//저장하시겠습니까?
        document.forms[0].action="m000202030.do?saveLayoutLength=true";
        document.forms[0].ServiceName.value="m000202030-service";
        document.forms[0].submit();
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.051",null,locale)%></div></td>
          <td align="right"><% if("true".equals(modifyFlag)||"&modify.x=10".equals(Modify)){%>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.ruledata",null,locale)%>" onClick="goGeneralDate('MODIFY')" style="cursor:pointer"><% }else{%>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.ruledata",null,locale)%>" onClick="goGeneralDate('VIEW')" style="cursor:pointer"><%}%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_rule_data" method="post"><!-- m000202030.do,m000202040.do,m000202050 -->
<input type="hidden" name="ServiceName"><!-- m000202030-service,m000202040-service,m000202050-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="MdlDefineId" value="<%=headerRow.getAttribute("MDL_DEFINE_ID")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
<input type="hidden" name="modifyFlag" value="<%= modifyFlag%>">
<input type="hidden" name="Modify" value="&modify.x=10">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="UseTp" value="<%=UseTp%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdlDefineNm" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_NM")%>" style="width:120" class=adg1 readonly></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
                <td class=tbllw width=190><input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_EXPLAIN")%>" style="width:180" class=adg1 readonly></td>
                <td class=tbldb width=140><%=PosContext.getResourceMessage("GMResource","gm.label.0262",null,locale)%></td>
                <td class=tbllw width=200><input type="text" value="<%=MasterDataPrcTpStr%>" style="width:150" class=adg1 readonly></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw colspan=3>
                  <input type="text" name="StartActiveDate" value="<%=(String)headerRow.getAttribute("START_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly> ~
                  <input type="text" name="EndActiveDate" value="<%=headerRow.getAttribute("END_ACTIVE_DATE_STR")==null?"":(String)headerRow.getAttribute("END_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_VERSION")%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=UseTpStr%>" style="width:80" class=adg1 readonly>
                  <input type="text" value="<%=MdlDefineCngGdStr%>" style="width:50" class=adg1 readonly>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=headerRow.getAttribute("MDL_DEFINE_OWNER_EMP_NO")%>" style="width:70" class=adg1 readonly>
                  (<input type="text" value="<%=headerRow.getAttribute("USER_NAME")%>" style="width:100" class=adg1 readonly>)
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0083",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=HierarchyOwnerShipTpMap.get((String)headerRow.getAttribute("HIERARCHY_OWNER_SHIP_TP"))%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=HierarchyOpTpMap.get((String)headerRow.getAttribute("HIERARCHY_OP_TP"))%>" style="width:50" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0123",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("LAST_UPDATE_TIMESTAMP_STR")%>" style="width:120" class=adg1 readonly>
                  <input type="text" value="<%=(String)headerRow.getAttribute("LAST_UPDATED_OBJECT_ID")%>" style="width:70" class=adg1 readonly>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=right><% if(isAdmin && isModify){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goSaveLength()" style="cursor:pointer"><!-- save -->
            <img src='<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>' onClick="goImport()" style="cursor:pointer"><%}%><!-- import -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onclick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left">
            <table id=T1 width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class="tbldb" height="18">
                <td width="20">no.</td>
                <td width="200"><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
                <td width="120"><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
                <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></td>
                <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0073",null,locale)%></td>
                <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0238",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0194",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0193",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0187",null,locale)%></td>
                <td width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%></td>
              </tr><%
    rowSet = ctx!=null ? (PosRowSet)ctx.get("Defind020DataLayoutRowResult") : null;
    int rowCnt = 0;
    if( rowSet!=null ){
        PosRow row = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
            String _MdlDefineDtNmDataTp = row.getAttribute("MDL_DEFINE_DT_NM_DATA_TP")==null?"nbsp;":row.getAttribute("MDL_DEFINE_DT_NM_DATA_TP").toString();
            if("1".equals(_MdlDefineDtNmDataTp)) _MdlDefineDtNmDataTp="VARCHAR2";
            else if("2".equals(_MdlDefineDtNmDataTp)) _MdlDefineDtNmDataTp="NUMBER";
            else if("3".equals(_MdlDefineDtNmDataTp)) _MdlDefineDtNmDataTp="DATE";
            else if("4".equals(_MdlDefineDtNmDataTp)) _MdlDefineDtNmDataTp="CHAR";
            String _MdlDefineDtNmKeyF = row.getAttribute("MDL_DEFINE_DT_NM_KEY_F")==null?"nbsp;":(String)row.getAttribute("MDL_DEFINE_DT_NM_KEY_F");
            if("Y".equals(_MdlDefineDtNmKeyF)) _MdlDefineDtNmKeyF=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale);
            else if("N".equals(_MdlDefineDtNmKeyF)) _MdlDefineDtNmKeyF=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale);
%>
              <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,T1) onmouseout=in_ch(1,this,T1)>
                <td><%=rowCnt+1%><input type="hidden" name="DtNmId" value="<%= row.getAttribute("DT_NM_ID")%>"></td>
                <td align="left"><%=row.getAttribute("STANDARD_KOREAN_NAME")==null||((String)row.getAttribute("STANDARD_KOREAN_NAME")).length()<1?"&nbsp;":(String)row.getAttribute("STANDARD_KOREAN_NAME")%></td>
                <td align="left"><%=row.getAttribute("STANDARD_ENGLISH_ID")==null||((String)row.getAttribute("STANDARD_ENGLISH_ID")).length()<1?"&nbsp;":(String)row.getAttribute("STANDARD_ENGLISH_ID")%></td>
                <td align="left"><%=row.getAttribute("MDL_DEFINE_DT_NM_ALIAS")==null||((String)row.getAttribute("MDL_DEFINE_DT_NM_ALIAS")).length()<1?"&nbsp;":(String)row.getAttribute("MDL_DEFINE_DT_NM_ALIAS")%></td>
                <td><%=_MdlDefineDtNmDataTp%></td>
                <td><%
                if(isAdmin && isModify){
                %><input type="text" name="MdlDefineDtNmLen" value="<%= row.getAttribute("MDL_DEFINE_DT_NM_LEN")==null?row.getAttribute("DT_NM_LEN"):row.getAttribute("MDL_DEFINE_DT_NM_LEN")%>" style="width:35" class=adb2><%
                }else{%><%=row.getAttribute("MDL_DEFINE_DT_NM_LEN")==null||row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString().length()<1?"&nbsp;":row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString()%><%
                }%></td>
                <td><%=row.getAttribute("MES_UNIT_OF_MEASURE")==null||((String)row.getAttribute("MES_UNIT_OF_MEASURE")).length()<1?"&nbsp;":(String)row.getAttribute("MES_UNIT_OF_MEASURE")%></td>
                <td><%=row.getAttribute("MDL_DEFINE_DT_NM_V_DECI_PREC")==null||row.getAttribute("MDL_DEFINE_DT_NM_V_DECI_PREC").toString().length()<1?"&nbsp;":row.getAttribute("MDL_DEFINE_DT_NM_V_DECI_PREC").toString()%></td>
                <td><%=row.getAttribute("MDL_DEFINE_DT_NM_CD_F")==null||((String)row.getAttribute("MDL_DEFINE_DT_NM_CD_F")).length()<1?"&nbsp;":(String)row.getAttribute("MDL_DEFINE_DT_NM_CD_F")%></td>
                <td><%=_MdlDefineDtNmKeyF%></td>
                <td><%=row.getAttribute("MDL_DEFINE_DT_NM_WILDCARD_TP")==null||((String)row.getAttribute("MDL_DEFINE_DT_NM_WILDCARD_TP")).length()<1?"&nbsp;":(String)row.getAttribute("MDL_DEFINE_DT_NM_WILDCARD_TP")%></td>
                <td><%=row.getAttribute("MDL_DEFINE_DT_NM_ARR_MET")==null||((String)row.getAttribute("MDL_DEFINE_DT_NM_ARR_MET")).length()<1?"&nbsp;":(String)row.getAttribute("MDL_DEFINE_DT_NM_ARR_MET")%></td>
                <td><%=row.getAttribute("MDL_DEFINE_DT_NM_ARR_MET_SEQ")==null||row.getAttribute("MDL_DEFINE_DT_NM_ARR_MET_SEQ").toString().length()<1?"&nbsp;":row.getAttribute("MDL_DEFINE_DT_NM_ARR_MET_SEQ").toString()%></td><% if(row.getAttribute("HIERARCHY_DATA_ID")!=null){%>
                <td><img src="img/gm0004img.gif" onClick="viewDepend(<%=rowCnt%>)" style="cursor:pointer"></td><%                                           }else{%>
                <td>&nbsp;</td><%                                                                                                                           }%>
                <td><%=row.getAttribute("OLSTATR_NM")==null||((String)row.getAttribute("OLSTATR_NM")).length()<1?"&nbsp;":(String)row.getAttribute("OLSTATR_NM")%></td>
                <input type="hidden" name="StandardEnglishId" value="<%=row.getAttribute("STANDARD_ENGLISH_ID")%>">
              </tr><%
            rowCnt++;
        }
    }
%>
            </table>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000202030.do">
<input type="hidden" name="ServiceName" value="m000202030-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="MdlDefineId" value="<%=headerRow.getAttribute("MDL_DEFINE_ID")%>">
<input type="hidden" name="export" value="10"><!-- event -->
</form>
<form name="form_import" method="post" action="m000202030.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000202030-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="MdlDefineNm">
<input type="hidden" name="MdlDefineId" value="<%= request.getParameter("MdlDefineId")%>">
<input type="hidden" name="UseTp" value="<%=UseTp%>" >
</form>
    </td>
  </tr>
</table>
</body>
</html>