<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.biz.constants.PosBizControlConstants" %>
<%@ page import="com.posdata.glue.cache.PosCacheManager" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 마스타코드 목록 >> 마스타코드 - 카테고리 관리 >> 마스타코드 - 카테고리별 코드값 관리
 * Open Issues    :
 * Change history
 * @2003-08-01 김연기 1.0    최초 생성
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

    String sSearchCategory = request.getParameter("SearchCategory")== null?"CATEGORY_GROUP_NM":request.getParameter("SearchCategory");
    String sCategoryWord = request.getParameter("CategoryWord")== null?"":request.getParameter("CategoryWord");
    String sSearchAttribute = request.getParameter("SearchAttribute")== null?"CD_V":request.getParameter("SearchAttribute");
    String sSearchWord = request.getParameter("SearchWord")== null?"":request.getParameter("SearchWord");

    // CodeHeader 부
    PosRowSet rowset = (PosRowSet)ctx.get("CodeHeaderRowResult");
    PosRow headerRow = rowset.next();
    String CdTpCharacterStr = headerRow.getAttribute("CD_TP_CHARACTER")==null?"":(String)headerRow.getAttribute("CD_TP_CHARACTER");
    if("S".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0190",null,locale);
    else if("C".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0065",null,locale);
    else if("R".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0170",null,locale);
    else if("T".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0216",null,locale);
    String UseTp = headerRow.getAttribute("USE_TP")==null?"":(String)headerRow.getAttribute("USE_TP");
    String HierarchyOpTp = headerRow.getAttribute("HIERARCHY_OP_TP")==null?"":(String)headerRow.getAttribute("HIERARCHY_OP_TP");
    String HierarchyOwnerShipTp = headerRow.getAttribute("HIERARCHY_OWNER_SHIP_TP")==null?"":(String)headerRow.getAttribute("HIERARCHY_OWNER_SHIP_TP");

    boolean isRelative = ((String)headerRow.getAttribute("CD_TP")).startsWith("_SYS_R_"); // 삭제불가능 
    boolean isFixed = ((String)headerRow.getAttribute("CD_TP")).startsWith("_SYS_F_");//행추가,삭제 불가능
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.033",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showCalendar.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
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
    document.forms[0].curPageNum.value="1";//showPageSet tag.
    document.forms[0].submit();
}
function cntInputType(form,type){
    var cnt = 0;
    for(var i = 0; i < form.elements.length ; i++){
        if ((form.elements[i].type ==type )){
            cnt++;
        }
    }
    return cnt;
}
/* 카테고리조회 팝업 */
function goCategory(rowindex){
    document.form_category.LocCategoryGroupNm.value     =document.forms[0].TbM00Codes030VO_chk.length>1?"document.forms[0].CATEGORY_GROUP_NM["+rowindex+"]"     :"document.forms[0].CATEGORY_GROUP_NM" ;
    document.form_category.LocCategoryGroupExplain.value=document.forms[0].TbM00Codes030VO_chk.length>1?"document.forms[0].CATEGORY_GROUP_EXPLAIN["+rowindex+"]":"document.forms[0].CATEGORY_GROUP_EXPLAIN" ;
    document.form_category.LocCategoryGroupId.value     =document.forms[0].TbM00Codes030VO_chk.length>1?"document.forms[0].CategoryGroupId["+rowindex+"]"       :"document.forms[0].CategoryGroupId";
    document.form_category.CdTp.value                   =document.forms[0].CdTp.value;
    showPopup("","m000201050_m000201050pop01",500,480,'1',0,0,1,1,1,0,0);
    document.form_category.target="m000201050_m000201050pop01";
    document.form_category.submit();
    return false;
}
function goExcelImport(){
    showPopup("","m000201050_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000201050_import";
    document.form_import.submit();
}
/* 삭제버튼누를때 */
function goCodeValDelete(){
    if(cntCheckBox(document.forms[0])>=1){
        if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0029",null,locale)%>')){//삭제 하시겠습니까?
            document.forms[0].action = document.forms[0].action+"?delete=10";
            document.forms[0].submit();
        }
    }else{
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    }
}
/* 저장버튼누를때(Upsert) */
function goCodeValUpsert(){
    if(cntCheckBox(document.forms[0])>=1){
        if(document.forms[0].TbM00Codes030VO_chk.length >= 2){
            var cnt = 0;
            for(var i = 0; i < document.forms[0].TbM00Codes030VO_chk.length; i++){
                if(document.forms[0].TbM00Codes030VO_chk[i].checked==true){
                    if(Trim(document.forms[0].MOD_CD_V[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0054",null,locale)},locale)%>'); //코드값
                        return;
                    }
                    if(Trim(document.forms[0].CD_V_MEANING[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)},locale)%>'); //코드의미
                        return;
                    }
                    if(Trim(document.forms[0].CATEGORY_GROUP_NM[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)},locale)%>'); //카테고리 ID
                        return;
                    }
                    if(Trim(document.forms[0].CATEGORY_GROUP_EXPLAIN[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)},locale)%>'); //카테고리명
                        return;
                    }
                }
            }
        }else{
            if(document.forms[0].TbM00Codes030VO_chk.checked==true){
                if(Trim(document.forms[0].MOD_CD_V.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0054",null,locale)},locale)%>'); //코드값
                    return;
                }
                if(Trim(document.forms[0].CD_V_MEANING.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)},locale)%>'); //코드의미
                    return;
                }
                if(Trim(document.forms[0].CATEGORY_GROUP_NM.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)},locale)%>'); //카테고리 ID
                    return;
                }
                if(Trim(document.forms[0].CATEGORY_GROUP_EXPLAIN.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)},locale)%>'); //카테고리명
                    return;
                }
            }
        }
        document.forms[0].action = document.forms[0].action+"?save=10";
        document.forms[0].submit();
    }else{
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    }
}
/* 체크박스선택여부를 판독함.*/
function cntCheckBox(form){
    var cnt = 0;
    for(var i = 0; i < form.elements.length ; i++){
        if ((form.elements[i].type == "checkbox")){
            if(form.elements[i].checked==true){
                cnt++;
            }
        }
    }
    return cnt;
}
function gm_select_all(){
    if (document.forms[0].TbM00Codes030VO_chk.length >= 2){
        for(i=0; i<document.forms[0].TbM00Codes030VO_chk.length; i++){
            document.forms[0].TbM00Codes030VO_chk[i].checked = !document.forms[0].TbM00Codes030VO_chk[i].checked;
        }
    }else{
        document.forms[0].TbM00Codes030VO_chk.checked = !document.forms[0].TbM00Codes030VO_chk.checked;
    }
}
//코드속성저장
function goCodeSave(){
    document.forms[0].action = document.forms[0].action+"?update=10";
    document.forms[0].target = "_self";
    document.forms[0].submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage);setTableIndexNoHeader(maintable);">
<table width="1000" border="0" cellspacing="0" cellpadding="0" onload="">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.033",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_codedata" method="post" action="m000201050.do" >
<input type="hidden" name="ServiceName" value="m000201050-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="CdTpCharacter" value="<%=(String)headerRow.getAttribute("CD_TP_CHARACTER")%>">
<input type="hidden" name="ApplicationId" value="<%=headerRow.getAttribute("APPLICATION_ID").toString()%>">
<input type="hidden" name="SecurityGroupId" value="<%=headerRow.getAttribute("SECURITY_GROUP_ID")%>">
<input type="hidden" name="CdTpId" value="<%=headerRow.getAttribute("CD_TP_ID")%>">
<input type="hidden" name="CategoryWord1" value="">
<input type="hidden" name="CategoryWord2" value="">
<input type="hidden" name="SearchWord1" value="">
<input type="hidden" name="SearchWord2" value="">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">1.<%=PosContext.getResourceMessage("GMResource","gm.label.0056",null,locale)%></div>
          </td>
        </tr>
        <tr>
          <td align="right">
<% if(isAdmin && !"N".equals(UseTp)){ %>
          	<img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goCodeSave()" style="cursor:pointer"><!-- save -->
<% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.help",null,locale)%>" style="cursor:pointer"><!-- help -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
        <tr>
          <td align="left">
            <table id=code_header width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
                <td class=tbllw width=195>
                  <input type="text" name="CdTp" value="<%=headerRow.getAttribute("CD_TP")%>" style="width:190" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0061",null,locale)%></td>
                <td class=tbllw width=205><% if("Y".equals(UseTp)||"N".equals(UseTp)){%>
                  <input type="text" name="CdTpMeaning" value="<%=headerRow.getAttribute("CD_TP_MEANING")%>" style="width:200" class=adg1 readonly><%}else{%>
                  <input type="text" name="CdTpMeaning" value="<%=headerRow.getAttribute("CD_TP_MEANING")%>" style="width:200" class=adb1><%}%>
                </td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0223",null,locale)%></td>
                <td class=tbllw width=200><input type="text" value="<%=CdTpCharacterStr%>" style="width:150" class=adg1 readonly></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw colspan=3>
                  <input type="text" name="StartActiveDate" value="<%=(String)headerRow.getAttribute("START_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly> ~
                  <input type="text" name="EndActiveDate" value="<%=headerRow.getAttribute("END_ACTIVE_DATE_STR")==null?"2999:12:31 23:59:59":(String)headerRow.getAttribute("END_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("CD_TP_VERSION")%>" style="width:50" class=adg1 readonly><%
                if("Y".equals(UseTp)){
%>
                  <select name="UseTp" class="adf">
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                    <option value="N" <%="N".equals(UseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
                  </select><%
                }else if("N".equals(UseTp)){
%>
                  <input type="text" value="<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%>" style="width:50" class=adg1 readonly>
                  <input type="hidden" name="UseTp" value="<%=UseTp%>"><%
                }else{
%>
                  <select name="UseTp" class="adf">
                    <option value="S" <%="S".equals(UseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
                    <option value="F" <%="F".equals(UseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                  </select><%
                }
%>
                  <input type="text" name="LanguageCode" value="<%=(String)headerRow.getAttribute("LANGUAGE_CODE")%>" style="width:50" class=adg1 readonly>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" name="CdTpOwnerEmpNo" value="<%=headerRow.getAttribute("CD_TP_OWNER_EMP_NO")%>" style="width:70" class=adg1 readonly>
                  (<input type="text" value="<%=headerRow.getAttribute("USER_NAME")%>" style="width:100" class=adg1 readonly>)
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0083",null,locale)%></td>
                <td class=tbllw><% if("Y".equals(UseTp)||"N".equals(UseTp)){%>
                  <input type="text" value="<%=HierarchyOwnerShipTpMap.get(HierarchyOwnerShipTp)%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=HierarchyOpTpMap.get(HierarchyOpTp)%>" style="width:50" class=adg1 readonly>
                  <input type="hidden" name="HierarchyOwnerShipTp" value="<%=HierarchyOwnerShipTp%>">
                  <input type="hidden" name="HierarchyOpTp" value="<%=HierarchyOpTp%>"><%}else{%>
                  <select name="HierarchyOwnerShipTp" class="adf"><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
%>
                    <option value="<%=value[0]%>" <%=HierarchyOwnerShipTp.equals(value[0])?"selected":""%>>[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                  <select name="HierarchyOpTp" class="adf"><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
%>
                    <option value="<%=value[0]%>" <%=HierarchyOpTp.equals(value[0])?"selected":""%>>[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select><%}%>
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
        <tr height=30>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">2.<%=PosContext.getResourceMessage("GMResource","gm.label.0057",null,locale)%></div>
          </td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=0 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td>
  <select name="SearchCategory" class="adf">
    <option value="CATEGORY_GROUP_NM" <%=          "CATEGORY_GROUP_NM".equals(sSearchCategory)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)%></option>
    <option value="CATEGORY_GROUP_EXPLAIN" <%="CATEGORY_GROUP_EXPLAIN".equals(sSearchCategory)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0140",null,locale)%></option>
  </select>
  <input type="text" name="CategoryWord" value="<%=sCategoryWord%>" size=10 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>&nbsp;&nbsp;
  <select name="SearchAttribute" class="adf">
    <option value="CD_V" <%=                "CD_V".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0054",null,locale)%></option>
    <option value="CD_V_MEANING" <%="CD_V_MEANING".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right"><%
    if(isAdmin){
        if(isFixed){
%><!-- disable addrow--><%
        }else{ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="insRow(maintable,hiddenTable,document.forms[0].TbM00Codes030VO_chk)" style="cursor:pointer"><!-- add row --><%
        }
%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goCodeValUpsert()" style="cursor:pointer"><!-- save --><%
        if(isFixed || isRelative){
%><!-- disable delete--><%
        }else{
%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.delete",null,locale)%>" onClick="goCodeValDelete()" style="cursor:pointer"><!-- delete --><%
        }
%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goExcelImport()" style="cursor:pointer"><!-- import --><%
    }
%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td valign="top">
            <table width=100% border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
              <tr class="tbldb" height="20">
                <td rowspan="2"><img src="img/gm0004img.gif" onClick="gm_select_all()" style="cursor:pointer"></td>
                <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
                <td colspan="2">Category</td>
                <td colspan="2">Range</td>
                <td width="40" rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0241",null,locale)%></td>
                <td width="130" rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0149",null,locale)%></td>
              </tr>
              <tr class="tbllb" height="20">
                <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0054",null,locale)%></td>
                <td width="250"><%=PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)%></td>
                <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)%></td>
                <td width="200"><%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></td>
                <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0147",null,locale)%></td>
                <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0138",null,locale)%></td>
              </tr>
            </table>
            <table id=maintable width=100% border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF><%
    rowset=(PosRowSet)ctx.get("CodeValueVOResult");
    if(rowset!=null && rowset.hasNext()){
      int rowCnt = 0;
      while(rowset.hasNext()){
        PosRow row = rowset.next();
%>
              <tr index=<%=rowCnt%> class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> height=18>
                <td index=<%=rowCnt%>><input type="checkbox" name="TbM00Codes030VO_chk" value=<%=rowCnt%>></td>
                <td index=<%=rowCnt%> width=100><input type="text" name=MOD_CD_V value="<%=row.getAttribute("MOD_CD_V")==null?"":row.getAttribute("MOD_CD_V")%>" style=width:95 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=<%=rowCnt%> width=250><input type="text" name=CD_V_MEANING value="<%=row.getAttribute("CD_V_MEANING")==null?"":row.getAttribute("CD_V_MEANING")%>" style=width:245 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=<%=rowCnt%> width=90><input type="text" readonly name=CATEGORY_GROUP_NM value="<%=row.getAttribute("CATEGORY_GROUP_NM")==null?"":row.getAttribute("CATEGORY_GROUP_NM")%>" style=width:65 class=adb1><input type="image" name=CategoryGroupNmbut src="img/gm0003img.gif" onClick='javascript: return goCategory(this.parentElement.index)'></td>
                <td index=<%=rowCnt%> width=200><input type="text" readonly name=CATEGORY_GROUP_EXPLAIN value="<%=row.getAttribute("CATEGORY_GROUP_EXPLAIN")==null?"":row.getAttribute("CATEGORY_GROUP_EXPLAIN")%>" style=width:195 size=1 class=adb1></td>
                <td index=<%=rowCnt%> width=60><input type="text" name=RG_MIN_V value="<%=row.getAttribute("RG_MIN_V")==null?"":row.getAttribute("RG_MIN_V")%>" style=width:55 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=<%=rowCnt%> width=60><input type="text" name=RG_MAX_V value="<%=row.getAttribute("RG_MAX_V")==null?"":row.getAttribute("RG_MAX_V")%>" style=width:55 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=<%=rowCnt%> width=40><input type="text" name=CD_V_INQUIRY_SEQ value="<%=row.getAttribute("CD_V_INQUIRY_SEQ")==null?"":row.getAttribute("CD_V_INQUIRY_SEQ")%>" style=width:35 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=<%=rowCnt%> width=130><%=row.getAttribute("LAST_UPDATE_TIMESTAMP_STR")==null?"":row.getAttribute("LAST_UPDATE_TIMESTAMP_STR")%></td>
                <input type="hidden" name="CdTpId2" value="<%=row.getAttribute("CD_TP_ID")%>">
                <input type="hidden" name="CategoryGroupId" value="<%=row.getAttribute("CATEGORY_GROUP_ID")%>">
              </tr><%
        rowCnt++;
      }
    }else{
%>
              <tr index=0 class=tblcw height=18>
                <td index=0><input type="checkbox" name="TbM00Codes030VO_chk" value=0 checked></td>
                <td index=0 width=100><input type="text" name=MOD_CD_V style=width:95 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=0 width=250><input type="text" name=CD_V_MEANING style=width:245 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=0 width=90><input type="text" readonly name=CATEGORY_GROUP_NM style=width:65 class=adb1><input type="image" name=CategoryGroupNmbut src="img/gm0003img.gif" onClick='javascript: return goCategory(this.parentElement.index)'></td>
                <td index=0 width=200><input type="text" readonly name=CATEGORY_GROUP_EXPLAIN style=width:195 class=adb1></td>
                <td index=0 width=60><input type="text" name=RG_MIN_V style=width:55 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=0 width=60><input type="text" name=RG_MAX_V style=width:55 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=0 width=40><input type="text" name=CD_V_INQUIRY_SEQ style=width:35 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td index=0 width=130>&nbsp;</td>
                <input type="hidden" name="CdTpId2" value="<%=headerRow.getAttribute("CD_TP_ID")%>">
                <input type="hidden" name="CategoryGroupId" value="-1">
              </tr><%
    }
%>
            </table>
            <div align="center">
            <posui:showPageSet infoName="CodeValueVOResult" formName="document.forms[0]" curPageName="curPageNum"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
      <div STYLE=display:none>
      <table id=hiddenTable width=980 align=null border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666  bordercolordark=FFFFFF>
        <tr class=tblcw height=18>
          <td index=0><input type="checkbox" name="TbM00Codes030VO_chk" value=0 checked></td>
          <td index=0 width=100><input type="text" name=MOD_CD_V style=width:95 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
          <td index=0 width=250><input type="text" name=CD_V_MEANING style=width:245 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
          <td index=0 width=90><input type="text" readonly name=CATEGORY_GROUP_NM style=width:65 class=adb1><input type="image" name=CategoryGroupNmbut src="img/gm0003img.gif" onClick='javascript: return goCategory(this.parentElement.index)'></td>
          <td index=0 width=200><input type="text" readonly name=CATEGORY_GROUP_EXPLAIN style=width:195 class=adb1></td>
          <td index=0 width=60><input type="text" name=RG_MIN_V style=width:55 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
          <td index=0 width=60><input type="text" name=RG_MAX_V style=width:55 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
          <td index=0 width=40><input type="text" name=CD_V_INQUIRY_SEQ style=width:35 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
          <td index=0 width=130>&nbsp;</td>
          <input type="hidden" name="CdTpId2" value="<%=headerRow.getAttribute("CD_TP_ID")%>">
          <input type="hidden" name="CategoryGroupId" value="-1">
        </tr>
      </table>
      </div>
<form name="form_export" method="post" action="m000201050.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000201050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="CdTpId" value="<%=headerRow.getAttribute("CD_TP_ID")%>">
<input type="hidden" name="CdTp" value="<%=headerRow.getAttribute("CD_TP")%>">
<input type="hidden" name="CdTpMeaning" value="<%=headerRow.getAttribute("CD_TP_MEANING")%>">
<input type="hidden" name="LanguageCode" value="<%=headerRow.getAttribute("LANGUAGE_CODE")%>">
</form>
<form name="form_import" method="post" action="m000201050.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000201050-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="CdTpId" value="<%=headerRow.getAttribute("CD_TP_ID")%>">
<input type="hidden" name="CdTp" value="<%=headerRow.getAttribute("CD_TP")%>">
<input type="hidden" name="CdTpMeaning" value="<%=headerRow.getAttribute("CD_TP_MEANING")%>">
<input type="hidden" name="LanguageCode" value="<%=headerRow.getAttribute("LANGUAGE_CODE")%>">
</form>
<form name="form_category" method="post" action="m000201050.do"><!-- Category -->
<input type="hidden" name="ServiceName" value="m000201050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="pop01" value="category"><!-- event -->
<input type="hidden" name="CdTp">
<input type="hidden" name="CategoryGroupNm">
<input type="hidden" name="LocCategoryGroupNm">
<input type="hidden" name="LocCategoryGroupExplain">
<input type="hidden" name="LocCategoryGroupId">
</form>
    </td>
  </tr>
</table>
</body>
</html>