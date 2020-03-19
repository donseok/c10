<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
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
 * @FileName      : 연관판단 데이타 조회
 * Open Issues    :
 * Change history
 * @2008-06-24 류진영 #1.0   최초 생성
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

    PosRowSet rowSet = (PosRowSet)ctx.get("Rule010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1B0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0191",null,locale);
    else if("1B1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0151",null,locale);

    rowSet = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    PosRow row;

    String sModifyYn="";
    String recordResp = headerRow.getAttribute("ATTRIBUTE3")==null?"N":headerRow.getAttribute("ATTRIBUTE3").toString();
    int dataCnt=0;

    ArrayList alias = new ArrayList();
    ArrayList outAlias = new ArrayList();
    while(rowSet.hasNext()){
        row = rowSet.next();
        // 변수정의
        alias.add(row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS"));
        if("O".equals(row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F"))){
            outAlias.add(row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS"));
            dataCnt++;
        }
    }
    int tdWidth = dataCnt==0? 480 : 480/dataCnt;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.067",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/checkSelectBoxChecked.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function goLayout(){
    document.forms[0].action="m000202060.do<%="S".equals(UseTp)?"?inputLayout=true":""%>";
    document.forms[0].ServiceName.value="m000202060-service";
    document.forms[0].submit();
}
function goVersion(){
    document.form_rule_hitory.target = "_self";
    document.form_rule_hitory.submit();
}
function goSave(){
    if(document.forms[0].TbM00Rules050VO_chk!=undefined){
        if (document.forms[0].TbM00Rules050VO_chk.length >= 2){
            for(i=0; i<document.forms[0].TbM00Rules050VO_chk.length; i++){
                if(document.forms[0].MdRuleConDoSeq[i].value==""){
                    alert("순서를 지정하세요.");
                    document.forms[0].MdRuleConDoSeq[i].focus();
                    return;
                }
            }
        }else{
            if(document.forms[0].MdRuleConDoSeq.value==""){
                alert("순서를 지정하세요.");
                document.forms[0].MdRuleConDoSeq.focus();
                return;
            }
        }
    }

    if(!checkSelectbox(document.forms[0]) && document.forms[0].UseTp.value == "<%=UseTp%>"){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return;
    }
    document.forms[0].action=document.forms[0].action+"?save=10";
    document.forms[0].submit();
}
function goDelete(){
    if(!checkSelectbox(document.forms[0])){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0029",null,locale)%>')){//삭제 하시겠습니까?
        //FOR DB2 변환위한 작업
        for (var i=0; i<document.forms[0].MdRuleDtNmConnectChkNo.length; i++) {
            if (document.forms[0].MdRuleDtNmConnectChkNo[i].value == "") {
                document.forms[0].MdRuleDtNmConnectChkNo[i].value = "-1";
            }
        }
        document.forms[0].action=document.forms[0].action+"?delete=10";
        document.forms[0].submit();
    }
}
function gm_select_all(){
    if(document.forms[0].TbM00Rules050VO_chk!=undefined){
        if (document.forms[0].TbM00Rules050VO_chk.length >= 2){
            for(i=0; i<document.forms[0].TbM00Rules050VO_chk.length; i++){
                document.forms[0].TbM00Rules050VO_chk[i].checked = !document.forms[0].TbM00Rules050VO_chk[i].checked;
            }
        }else{
            document.forms[0].TbM00Rules050VO_chk.checked = !document.forms[0].TbM00Rules050VO_chk.checked;
        }
    }
}
function goImport(){
    showPopup("","m000202080_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000202080_import";
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.067",null,locale)%></div></td>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.layout",null,locale)%>" onClick="goLayout()" style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.history",null,locale)%>" onClick="goVersion()" style="cursor:pointer">
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_rule_data" method="post" action="m000202080.do"><!-- m000202010.do,m000202060.do -->
<input type="hidden" name="ServiceName" value="m000202080-service"><!-- m000202010-service,m000202060-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
<input type="hidden" name="modifyFlag" value="true">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
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
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>>[Y]<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
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
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height=20>
          <td><div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.label.0230",null,locale)%></div></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff><%

    if(alias.size()>0){
        for(int i=0, iz=alias.size(); i<iz; i++){
            if(i%5==0)          { %>
              <tr height=20><%  } %>
                <td width='5%' class=tbldb>V<%= i+1 %></td>
                <td width='15%'><%= alias.get(i)%></td><%
            if(i%5==4)          { %>
              </tr><%           }
        }
        if(alias.size()%5!=0){
            for(int i=alias.size()%5; i<5; i++){ %>
                <td width='5%' class=tbldb>&nbsp;</td>
                <td width='15%'>&nbsp;</td><%  }  %>
              </tr><%
        }
    }else{
%>
              <tr height=20>
                <td><%=PosContext.getResourceMessage("GMResource","gm.msg.0059",null,locale)%></td>
              </tr><%
    }
%>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height="25">
          <td align="right"><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="insRow(maintable,hiddenTable,document.forms[0].TbM00Rules050VO_chk)" style="cursor:pointer"><!-- add row -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goSave()" style="cursor:pointer"><!-- save -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.delete",null,locale)%>" onClick="goDelete()" style="cursor:pointer"><!-- delete -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goImport()" style="cursor:pointer"><!-- import --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class="tbldb" height="20">
                <td width="40" rowspan="2"><img src="img/gm0004img.gif" onClick="gm_select_all()" style="cursor:pointer"></td>
                <td width="60" rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0162",null,locale)%></td>
                <td rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0074",null,locale)%></td>
                <td colspan="<%=outAlias.size()%>"><%=PosContext.getResourceMessage("GMResource","gm.label.0178",null,locale)%></td>
              </tr>
              <tr class="tbllb" height="20"><%
    for(int i=0, iz=outAlias.size(); i<iz; i++){
%>
                <td width="<%=tdWidth%>"><%=outAlias.get(i)%></td><%
    }
%>
              </tr>
            </table>
            <table id="maintable" width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff><%

    rowSet = (PosRowSet)ctx.get("Rules050VO");
    row = null;
    if( rowSet!=null && rowSet.hasNext()){
        if(rowSet.hasNext()){
            row = rowSet.next();
            if(!"0".equals(String.valueOf(row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_NO")))){
                row=null;
            }
        }
%>
              <tr class="tblcm" height="20">
                <td index=0 width="40"><input type="checkbox" name="TbM00Rules050VO_chk" value="0"><input type="hidden" name="TbM00Rules050VOMdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID").toString()%>"></td>
                <td index=0 width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%>
                  <input type="hidden" name="MdRuleConDoSeq" value="-1"><% if(row!=null){%>
                  <input type="hidden" name="MdRuleDtNmConnectChkNo" value="0"><%}else{%>
                  <input type="hidden" name="MdRuleDtNmConnectChkNo"><%}%>
                </td>
                <td index=0><%=PosContext.getResourceMessage("GMResource","gm.msg.0049",null,locale)%><input type="hidden" name="MdRuleDtNmConnectChkTpsd" value="예외처리데이타"></td><%
        if(dataCnt==0){%>
                <td index=0 width="<%=tdWidth%>">&nbsp;</td><%
        }else{
            if(row!=null){
                for(int i=0, iz=dataCnt; i<iz; i++){%>
                <td index=0 width="<%=tdWidth%>"><input type="text" name="<%="MdRuleDecisionRst"+(i+1)%>" value="<%=row.getAttribute("MD_RULE_DECISION_RST"+(i+1))==null?"":(String)row.getAttribute("MD_RULE_DECISION_RST"+(i+1))%>" style="width:<%=tdWidth-10%>" class=adb1></td><%
                }
            }else{
                for(int i=0, iz=dataCnt; i<iz; i++){%>
                <td index=0 width="<%=tdWidth%>"><input type="text" name="<%="MdRuleDecisionRst"+(i+1)%>" style="width:<%=tdWidth-10%>" class=adb1></td><%
                }
            }
        }%>
              </tr><%

        int rowCnt = 0;
        rowSet.reset();
        while(rowSet.hasNext()){
            row = rowSet.next();
            if(!"0".equals(String.valueOf(row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_NO")))){
%>
              <tr index=<%=rowCnt+1%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20">
                <td><input type="checkbox" name="TbM00Rules050VO_chk" value="<%=rowCnt+1%>"><input type="hidden" name="TbM00Rules050VOMdRuleId" value="<%=row.getAttribute("MD_RULE_ID").toString()%>"></td>
                <td><input type="text" name="MdRuleConDoSeq" value="<%=row.getAttribute("MD_RULE_CON_DO_SEQ").toString()%>" style=width:50 class=adb1><input type="hidden" name="MdRuleDtNmConnectChkNo" value="<%=row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_NO").toString()%>"></td>
                <td><input type="text" name="MdRuleDtNmConnectChkTpsd" value="<%=row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")==null?"":(String)row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")%>" style="width:95%" class=adb1></td><%
                if(dataCnt==0){
%>
                <td>&nbsp;</td><%
                }else{
                    for(int i=0, iz=dataCnt; i<iz; i++){
%>
                <td><input type="text" name="<%="MdRuleDecisionRst"+(i+1)%>" value="<%=row.getAttribute("MD_RULE_DECISION_RST"+(i+1))==null?"":(String)row.getAttribute("MD_RULE_DECISION_RST"+(i+1))%>" style="width:<%=tdWidth-10%>" class=adb1></td><%
                    }
                }
                rowCnt++;
%>
              </tr><%
            }
        }
    }else{
%>
              <tr index=0 class="tblcm" height="20">
                <td width="40"><input type="checkbox" name="TbM00Rules050VO_chk" value="0"><input type="hidden" name="TbM00Rules050VOMdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID").toString()%>"></td>
                <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%><input type="hidden" name="MdRuleConDoSeq" value="-1"><input type="hidden" name="MdRuleDtNmConnectChkNo"></td>
                <td><%=PosContext.getResourceMessage("GMResource","gm.msg.0049",null,locale)%><input type="hidden" name="MdRuleDtNmConnectChkTpsd" value="예외처리데이타"></td><%
        if(dataCnt==0){%>
                <td width="<%=tdWidth%>">&nbsp;</td><%
        }else{
            for(int i=0, iz=dataCnt; i<iz; i++){%>
                <td width="<%=tdWidth%>"><input type="text" name="<%="MdRuleDecisionRst"+(i+1)%>" style="width:<%=tdWidth-10%>" class=adb1></td><%
            }
        }%>
              </tr>
              <tr index=1 class=tblcw height="20">
                <td><input type="checkbox" name="TbM00Rules050VO_chk" value="1"><input type="hidden" name="TbM00Rules050VOMdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID").toString()%>"></td>
                <td><input type="text" name="MdRuleConDoSeq" style=width:50 class=adb1><input type="hidden" name="MdRuleDtNmConnectChkNo"></td>
                <td><input type="text" name="MdRuleDtNmConnectChkTpsd" style="width:95%" class=adb1></td><%
    if(dataCnt==0){
%>
                <td>&nbsp;</td><%
    }else{
        for(int i=0, iz=dataCnt; i<iz; i++){
%>
                <td><input type="text" name="<%="MdRuleDecisionRst"+(i+1)%>" style="width:<%=tdWidth-10%>" class=adb1></td><%
        }
    }
%>
              </tr><%
    }
%>
            </table><%
%>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000202080.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000202080-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
</form>
<form name="form_import" method="post" action="m000202080.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000202080-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="MdRuleNm" value="<%=headerRow.getAttribute("MD_RULE_NM")%>">
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
</form>
<form name="form_rule_hitory" method="post" action="m000202010.do"><!-- History -->
<input type="hidden" name="ServiceName" value="m000202010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="history" value="10"><!-- event -->
<input type="hidden" name="SearchUseTp" value="%">
<input type="hidden" name="SearchMasterDataPrcTp" value="%">
<input type="hidden" name="SearchWord" value="<%=(String)headerRow.getAttribute("MD_RULE_NM")%>">
<input type="hidden" name="SearchAttribute" value="MD_NM">
<input type="hidden" name="modifyFlag" value="true">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
</form>
    </td>
  </tr>
</table>
<div STYLE=display:none>
<table id=hiddenTable width=980 border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
  <tr index=0 class=tblcw height=20>
    <td width=40><input type="checkbox" name="TbM00Rules050VO_chk"><input type="hidden" name="TbM00Rules050VOMdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID").toString()%>"></td>
    <td width=60><input type="text" name="MdRuleConDoSeq" style=width:50 class=adb1><input type="hidden" name="MdRuleDtNmConnectChkNo"></td>
    <td><input type="text" name="MdRuleDtNmConnectChkTpsd" style="width:95%" class=adb1></td><%
    if(dataCnt==0){
%>
    <td width=<%=tdWidth%>>&nbsp;</td><%
    }else{
        for(int i=0, iz=dataCnt; i<iz; i++){
%>
    <td width="<%=tdWidth%>"><input type="text" name="<%="MdRuleDecisionRst"+(i+1)%>" style="width:<%=tdWidth-10%>" class=adb1></td><%
        }
    }
%>
  </tr>
</table>
</div>
</body>
</html>