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
 * @FileName      : 업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 조회(연관판단) >> 업무기준 레이아웃 조회(판단)
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 조회(조건판단) >> 업무기준 레이아웃 조회(판단)
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 레이아웃 조회(판단)
 * Open Issues    :
 * Change history 
 * @2008-06-14 류진영 #1.0   최초 생성
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
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.061",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function goDecisionData(type){
    if(document.forms[0].MasterDataPrcTp.value=='1B0'){
        document.forms[0].action="m000202070.do?saveData=true";
        document.forms[0].ServiceName.value="m000202070-service";
    }else{
        document.forms[0].action="m000202080.do?saveData=true";
        document.forms[0].ServiceName.value="m000202080-service";
    }
    document.forms[0].submit();
}
function goSave(){
    if(document.forms[0].chk!=undefined){
        if(document.forms[0].chk.length >= 2){
            for(i=0; i<document.forms[0].chk.length; i++){
                if(document.forms[0].MdRuleDtNmSeq[i].value==""){
                    alert("순서를 지정하세요.");
                    document.forms[0].MdRuleDtNmSeq[i].focus();
                    return;
                }
                if(document.forms[0].DtNmId[i].value==""){
                    alert("항목을 선택하세요");
                    return;
                }
            }
        }else{
            if(document.forms[0].MdRuleDtNmSeq.value==""){
                alert("순서를 지정하세요.");
                document.forms[0].MdRuleDtNmSeq.focus();
                return;
            }
            if(document.forms[0].DtNmId.value==""){
                alert("항목을 선택하세요");
                return;
            }
        }
        // 연관판단 일경우 결과는 3개까지 가능
        if(document.forms[0].MasterDataPrcTp.value=='1B1'){
            var outCnt = 0;
            if (document.forms[0].chk.length >= 2){
                for(i=0; i<document.forms[0].chk.length; i++){
                    if(document.forms[0].MdRuleDtNmCompChkVAppF[i].value=='O'){
                        outCnt++;
                    }
                }
            }
            if(outCnt>3){
                alert("결과항목은 3개를 초과할 수 없습니다.");
                return;
            }
        }
    }
    if(document.forms[0].deleteData.checked && confirm("<%=PosContext.getResourceMessage("GMResource","gm.msg.0029",null,locale)%>")){//기준데이타를 삭제하시겠습니까?
        document.forms[0].action=document.forms[0].action+"?saveLayout=true&deleteRuleData=true";
    }else{
        document.forms[0].action=document.forms[0].action+"?saveLayout=true";
    }
    document.forms[0].submit();
}
function goAttrsOpen(index){
    document.form_attr.opener_target_id.value=index;
    showPopup("","m000202060_m000200050",800,580,'1',0,0,1,1,1,0,0);
    document.form_attr.target="m000202060_m000200050";
    document.form_attr.submit();
}
function gm_select_all(){
    if(document.forms[0].chk!=undefined){
        if (document.forms[0].chk.length >= 2){
            for(i=0; i<document.forms[0].chk.length; i++){
                document.forms[0].chk[i].checked = !document.forms[0].chk[i].checked;
            }
        }else{
            document.forms[0].chk.checked = !document.forms[0].chk.checked;
        }
    }
}
function goImport(){
    document.form_import.MdRuleNm.value=document.forms[0].MdRuleNm.value;
    showPopup("","m000202060_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000202060_import";
    document.form_import.submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage);setTableIndexNoHeader(maintable);">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.061",null,locale)%></div></td><%
    PosRowSet rowSet = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    if(rowSet!=null && rowSet.hasNext()){%>
          <td align="right"><a href="javascript:goDecisionData('MODIFY');"><img src="<%=PosContext.getResourceMessage("GMResource","gm.img.next",null,locale)%>" align="absmiddle" border=0></a></td><%
    }%>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top><%

    rowSet = (PosRowSet)ctx.get("Rule010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1B0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0191",null,locale);
    else if("1B1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0151",null,locale);
%>
<form name="form_rule_data" method="post" action="m000202060.do"><!-- m000202070.do,m000202080.do -->
<input type="hidden" name="ServiceName" value="m000202060-service"><!-- m000202070-service,m000202080-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="Modify" value="&modify.x=10">
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height="10">
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdRuleNm" value="<%=(String)headerRow.getAttribute("MD_RULE_NM")%>" style="width:120" class=adg1 readonly></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
                <td class=tbllw width=190><input type="text" value="<%=(String)headerRow.getAttribute("MD_RULE_EXPLAIN")%>" style="width:180" class=adg1 readonly></td>
                <td class=tbldb width=140><%=PosContext.getResourceMessage("GMResource","gm.label.0262",null,locale)%></td>
                <td class=tbllw width=200><input type="text" value="<%=MasterDataPrcTpStr%>" style="width:150" class=adg1 readonly></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw colspan=3>
                  <input type="text" name="StartActiveDate" value="<%=(String)headerRow.getAttribute("START_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly> ~
                  <input type="text" name="EndActiveDate" value="<%=headerRow.getAttribute("END_ACTIVE_DATE_STR")==null?"2999-12-31 23:59:59":(String)headerRow.getAttribute("END_ACTIVE_DATE_STR")%>" style="width:120" class=adb1>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MD_RULE_VERSION")%>" style="width:50" class=adg1 readonly><%
    if("Y".equals(UseTp)){
%>
                  <select name="UseTp" class="adf">
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>>[Y]<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                    <option value="N" <%="N".equals(UseTp)?"selected":""%>>[N]<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
                  </select><%
    }else if("N".equals(UseTp)){
%>
                  <select name="UseTp" class="adf">
                    <option value="N" <%="N".equals(UseTp)?"selected":""%>>[N]<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
                  </select><%
    }else{
%>
                  <select name="UseTp" class="adf">
                    <option value="S" <%="S".equals(UseTp)?"selected":""%>>[S]<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
                    <option value="F" <%="F".equals(UseTp)?"selected":""%>>[F]<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
                  </select><%
    }
%>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MD_RULE_CNG_GD")%>" style="width:50" class=adg1 readonly>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=headerRow.getAttribute("MD_RULE_OWNER_EMP_NO")%>" style="width:70" class=adg1 readonly>
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
        <tr height="10">
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align="left"><input type="checkbox" name="deleteData"> <%=PosContext.getResourceMessage("GMResource","gm.label.0080",null,locale)%></td>
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goSave()" style="cursor:pointer"><!-- save -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="insRow(maintable,hiddenTable,document.forms[0].chk)" style="cursor:pointer"><!-- add row -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.deleterow",null,locale)%>" onClick="delRow(maintable,document.forms[0].chk)" style="cursor:pointer"><!-- delete row -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goImport()" style="cursor:pointer"><!-- import --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align=left>
            <table width=958 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
              <tr class=tbldb height=18>
                <td rowspan=2 width=20><img src="img/gm0004img.gif" onClick="gm_select_all()" style="cursor:pointer"></td>
                <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
                <td rowspan=2 width=190><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
                <td rowspan=2 width=110><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></td>
                <td rowspan=2 width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%></td>
                <td rowspan=2 width=60><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td rowspan=2 width=70><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td rowspan=2 width=60><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
                <td rowspan=2 width=70><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
                <td rowspan=2 width=70><%=PosContext.getResourceMessage("GMResource","gm.label.0073",null,locale)%></td>
                <td colspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0204",null,locale)%></td>
              </tr>
              <tr class=tbldb height=18>
                <td width=60><%=PosContext.getResourceMessage("GMResource","gm.label.0201",null,locale)%></td>
                <td width=60><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
              </tr>
            </table>
            <DIV ID=divData STYLE='position:relative;overflow:auto;width:980;height:350;top:0;left:0;'>
            <table id=maintable width=958 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF><TBODY><%

    rowSet = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    PosRow row = null;
    int seq =0;
    while(rowSet.hasNext())
    {
        row=rowSet.next();
%>
              <tr class=<%= (seq%2==0?"tblcg":"tblcw")%> height=18>
                <td index=<%=seq%> width=20><input type="checkbox" name="chk"></td>
                <td index=<%=seq%> ><input type="text" name="MdRuleDtNmSeq" value='<%= row.getAttribute("MD_RULE_DT_NM_SEQ")%>' style=width:30 class=adb2 onBlur=this.className='adb2' onFocus=this.className='adb2' ></td>
                <td index=<%=seq%> width=190><input type="text" name="MdlDefineDtNmMrkNm" value='<%=row.getAttribute("STANDARD_KOREAN_NAME")%>' style=width:160 class=adg1 readonly><img src="img/gm0003img.gif" onClick='javascript:goAttrsOpen(this.parentElement.index);' style="cursor:pointer"></td>
                <td index=<%=seq%> width=110><input type="text" name="MdRuleDtNmAlias" value='<%=row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS")%>' style=width:95 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=<%=seq%> width=100><input type="text" name="DtNmDataTpMeaning" value=<%
                  if      ("1".equals(String.valueOf(row.getAttribute("DT_NM_DATA_TP")))) {%>VARCHAR2<%
                  }else if("2".equals(String.valueOf(row.getAttribute("DT_NM_DATA_TP")))) {%>NUMBER<%
                  }else if("3".equals(String.valueOf(row.getAttribute("DT_NM_DATA_TP")))) {%>DATE<%
                  }else if("4".equals(String.valueOf(row.getAttribute("DT_NM_DATA_TP")))) {%>CHAR<%
                  }else if("5".equals(String.valueOf(row.getAttribute("DT_NM_DATA_TP")))) {%>TIMESTAMP<%
                  }else{%>undefined<%}%> style=width:80 class=adg1 readonly></td>
                <td index=<%=seq%> width=60><input type="text" name="DtNmLen" value='<%=row.getAttribute("DT_NM_LEN")%>' style=width:50 class=adg1 readonly></td>
                <td index=<%=seq%> width=70><input type="text" name="MesUnitOfMeasure" value='<%=row.getAttribute("MES_UNIT_OF_MEASURE")==null?"":row.getAttribute("MES_UNIT_OF_MEASURE")%>' style=width:55 class=adb2 onBlur=this.className='adb2' onFocus=this.className='adb2'></td>
                <td index=<%=seq%> width=60><input type="text" name="DtNmDecimalPrec" value='<%=row.getAttribute("MD_RULE_DT_NM_IP_V_PREC")==null?"":row.getAttribute("MD_RULE_DT_NM_IP_V_PREC")%>' style=width:50 class=adg1 readonly></td>
                <td index=<%=seq%> width=70>
                  <select name="MdRuleDtNmCdF" class="adf" style="width:50px">
                    <option value="Y" <%="Y".equals((String)row.getAttribute("MD_RULE_DT_NM_CD_F"))?"selected":""%>>Y</option>
                    <option value="N" <%="N".equals((String)row.getAttribute("MD_RULE_DT_NM_CD_F"))?"selected":""%>>N</option>
                  </select>
                </td>
                <td index=<%=seq%> width=70>
                  <select name="MdRuleDtNmCompChkVAppF" class="adf" style="width:65px">
                    <option value="I" <%="I".equals((String)row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></option>
                    <option value="O" <%="O".equals((String)row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F"))?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></option>
                  </select>
                </td>
                <td index=<%=seq%> width=60><input type="text" name="StartIndex" value='<%=row.getAttribute("START_INDEX")==null?"":row.getAttribute("START_INDEX").toString()%>' style=width:50 class=adb2 onBlur=this.className='adb2' onFocus=this.className='adb2'></td>
                <td index=<%=seq%> width=60><input type="text" name="MdRuleDtNmSubstrLen" value='<%=row.getAttribute("MD_RULE_DT_NM_SUBSTR_LEN")==null?"":row.getAttribute("MD_RULE_DT_NM_SUBSTR_LEN")%>' style=width:50 class=adb2 onBlur=this.className='adb2' onFocus=this.className='adb2'></td>
                <input type="hidden" name="MdlDefineDtNmSeq">
                <input type="hidden" name="DtNmId" value="<%= row.getAttribute("DT_NM_ID")%>">
                <input type="hidden" name="DtNmDataTp" value="<%=row.getAttribute("DT_NM_DATA_TP")%>"><!--MdlDefineDtNmDataTp-->
                <input type="hidden" name="MdRuleDtNmNm" value="<%=row.getAttribute("MD_RULE_DT_NM_NM")%>">
              </tr><%
        seq++;
    }
%>
            </TBODY>
            </table>
            </DIV>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000202060.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000202060-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="MdRuleId" value='<%=headerRow.getAttribute("MD_RULE_ID")%>'>
<input type="hidden" name="export" value="10"><!-- event -->
</form>
<form name="form_import" method="post" action="m000202060.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000202060-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="MdRuleNm">
</form>
<form name="form_attr" method="post" action="m000200050.do">
<input type="hidden" name="ServiceName" value="m000200050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="opener_target_id">
</form>
    </td>
  </tr>
</table>
<div STYLE=display:none>
<table id=hiddenTable width=980 border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
  <tr class=tblcg height=18>
    <td index=0 width=20><input type="checkbox" name="chk"></td>
    <td index=0><input type="text" name="MdRuleDtNmSeq" style=width:30 class=adb2 onBlur=this.className='adb2' onFocus=this.className='adb2' ></td>
    <td index=0 width=190><input type="text" name="MdlDefineDtNmMrkNm" style=width:160 class=adg1 readonly><img src="img/gm0003img.gif" onClick='javascript:goAttrsOpen(this.parentElement.index);' style="cursor:pointer"></td>
    <td index=0 width=110><input type="text" name="MdRuleDtNmAlias" style=width:95 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
    <td index=0 width=100><input type="text" name="DtNmDataTpMeaning" style=width:80.0;height:18 class=adg1 readonly></td>
    <td index=0 width=60><input type="text" name="DtNmLen" style=width:50 class=adg1 readonly></td>
    <td index=0 width=70><input type="text" name="MesUnitOfMeasure" style=width:55 class=adb1 onBlur=this.className='adb2' onFocus=this.className='adb2'></td>
    <td index=0 width=60><input type="text" name="DtNmDecimalPrec" style=width:50 class=adg1 readonly></td>
    <td index=0 width=70>
      <select name="MdRuleDtNmCdF" class="adf" style="width:50px">
        <option value="Y">Y</option>
        <option value="N">N</option>
      </select>
    </td>
    <td index=0 width=70>
      <select name="MdRuleDtNmCompChkVAppF" class="adf" style="width:65px">
        <option value="I"><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></option>
        <option value="O"><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></option>
      </select>
    </td>
    <td index=0 width=60><input type="text" name="StartIndex" style=width:50 class=adb2 onBlur=this.className='adb2' onFocus=this.className='adb2'></td>
    <td index=0 width=60><input type="text" name="MdRuleDtNmSubstrLen" style=width:50 class=adb2 onBlur=this.className='adb2' onFocus=this.className='adb2'></td>
    <input type="hidden" name="MdlDefineDtNmSeq">
    <input type="hidden" name="DtNmId">
    <input type="hidden" name="DtNmDataTp">
    <input type="hidden" name="MdRuleDtNmNm">
  </tr>
</table>
</div>
</body>
</html>