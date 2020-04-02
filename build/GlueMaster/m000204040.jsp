<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
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
 * @FileName      : Master Data 전문 Error Check 등록 화면
 * Open Issues    :
 * Change history 
 * @x-x-x 김정희 1.0 영문화
 * @2010-03-04 정경주 1.x 영문화
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String fac_op_cd = request.getParameter("fac_op_cd")==null||"%".equals(request.getParameter("fac_op_cd"))?"":request.getParameter("fac_op_cd"); //공장공정코드
    String MdlDefineId = ""; 

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.090",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript">
<!--
function viewDetail(){
    document.forms[0].action = document.forms[0].action + "?mode=modify";
    document.forms[0].submit();
}
//행추가버튼 누름시
function insRowThis(maintable,chk){
    //하나이상 체크되어 있는지 확인
    chk_ok=0;
	
    for(var i=0;i<document.forms[0].chk.length;i++){
        if(document.forms[0].chk[i].checked==true){
            chk_ok=1;
        }
    }
    if(chk_ok==0){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0066",null,locale)%>');
        return false;
    }
	
    insRow(maintable,null,chk);
	
    var length = document.forms[0].MdRuleDtNmBasChkSeq.length;    
    for(var i=0;i<length;i++){
        if (document.forms[0].chk[i].checked==true){
            document.forms[0].MdRuleDtNmDetailOperType[i].value ="OR";
            document.forms[0].MdRuleDtNmDetailOperType[i-1].value ="OR";
            var t =document.forms[0].MdRuleDtNmBasChkSeq[i].value;
            document.forms[0].MdRuleDtNmBasChkSeq[i-1].value = ++t;
            document.forms[0].chk[i].checked=false;
            document.forms[0].chk[i-1].checked=true;
        }
    }
	
	
	
    return true;
}
//저장버튼 누름시
function error_save(){
    //하나이상 체크되어 있는지 확인
    if(!confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>')){//에러체크 기준을 저장하시겠습니까?
        return false;
    }
    //모두 일괄 저장
    for(var i=0;i<document.forms[0].chk.length;i++){
        document.forms[0].chk[i].checked=true;
    }
    var length = document.forms[0].MdRuleDtNmBasChkSeq.length;
    for(var i=0;i<length-1;i++){
        if (document.forms[0].DtNmId[i].value == document.forms[0].DtNmId[i+1].value){
            document.forms[0].MdRuleDtNmDetailOperType[i].value ="OR";
            document.forms[0].MdRuleDtNmDetailOperType[i+1].value ="OR";
        }
    }
    document.forms[0].action = document.forms[0].action+"?save=10";
    document.forms[0].submit();
}
//삭제버튼누름시
function error_delete(table,chk){
    //하나이상 체크되어 있는지 확인
    chk_ok=0;
    for(var i=0;i<document.forms[0].chk.length;i++){
        if(document.forms[0].chk[i].checked==true){
            chk_ok=1;
        }
    }
    if(chk_ok==0){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return false;
    }
    var length = document.forms[0].MdRuleDtNmBasChkSeq.length;    
    for(var i=0;i<length;i++){
        if (document.forms[0].chk[i].checked==true & (document.forms[0].MdRuleDtNmBasChkSeq[i].value == 1)){
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0018",null,locale)%>");// 기준항목은 삭제 할 수 없습니다.
            return false; 
        }
    }
    delRow(table,chk);
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.090",null,locale)%></div></td>
          <td align="right"><img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.tclayout",null,locale)%>" align="absmiddle" onClick="viewDetail()" style="cursor:pointer"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_tc_check" method="post" action="m000204020.do">
<input type="hidden" name="ServiceName" value="m000204020-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="fac_op_cd" value="<%=fac_op_cd%>">
<input type="hidden" name="TbM00Interfaces_FkMdlDefineId" value="<%=request.getParameter("TbM00Interfaces_FkMdlDefineId")%>">
<input type="hidden" name="TbM00Interfaces_MdlDefineId" value="<%=request.getParameter("TbM00Interfaces_MdlDefineId")%>"><!-- TB_M00_INTERFACES -->
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align=left><%
    PosRowSet rowSet = (PosRowSet)ctx.get("TB_M00_INTERFACES");
    PosRow row = rowSet.next();
%>
              <tr>
                <td><img src="img/gm0008img.gif">&nbsp;<b>Format ID</b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="format_name" value='<%=request.getParameter("format_name")%>' class=adb1 style="width:100px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0213",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="TbM00Interfaces_MdlDefineNm" value='<%=row.getAttribute("MDL_DEFINE_NM")%>' class=adb1 style="width:100px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0188",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("PROCESS_CHAIN_CODE1")%>' class=adb1 style="width:70px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="dummy" value='<%=row==null||row.getAttribute("MDL_DEFINE_OWNER_EMP_NO")==null?"":(String)row.getAttribute("MDL_DEFINE_OWNER_EMP_NO")%>' class=adb1 style="width:120px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="dummy" value='<%=row.getAttribute("START_ACTIVE_DATE")%>' class=adb1 style="width:120px"></td>
              </tr>
              <tr>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0214",null,locale)%></b></td>
                <td colspan=3><b>:</b>&nbsp;<input type="text" readonly name="TbM00Interfaces_MdlDefineExplain" value='<%=row.getAttribute("MDL_DEFINE_EXPLAIN")%>' class=adb1 style="width:350px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0171",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("PROCESS_CHAIN_CODE2")%>' class=adb1 style="width:70px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></b> </td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value="<%=row.getAttribute("LAST_UPDATE_TIMESTAMP")%>" class=adb1 style="width:120px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0092",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("END_ACTIVE_DATE")%>' class=adb1 style="width:120px"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height="25">
          <td align="right"><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onclick="insRowThis(maintable,document.forms[0].chk)" style="cursor:pointer"><!-- add row -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onclick="error_save()" style="cursor:pointer"><!-- save -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.delete",null,locale)%>" onclick="error_delete(maintable,document.forms[0].chk)" style="cursor:pointer"><!-- delete --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.help",null,locale)%>" style="cursor:pointer"><!-- help -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!--닫기버튼-->
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <posglobalui:showTable infoName="GetTCErrorCheckInfoResults1" tableName="maintableheader"
              headerClasses="tbldb|tbllb"
              height="20"
              headerValues =  "gm.label.0255|gm.label.0155|gm.label.0030|gm.label.0155|gm.label.0078|gm.label.0124|gm.label.0064|gm.label.0028|gm.label.0168|gm.label.0168|gm.label.0029|gm.label.0169|gm.label.0169|gm.label.0127|gm.label.0210;
                               gm.label.0255|gm.label.0155|gm.label.0030|gm.label.0155|gm.label.0078|gm.label.0124|gm.label.0064|gm.label.0028|gm.label.0148|gm.label.0139|gm.label.0029|MIN2|MAX2|gm.label.0127|gm.label.0210"
              columnWidths = "30|40|150|40|70|40|50|70|80|80|70|80|80|60|40" 
              defaultRowCnt="0"
            />
            <table id=maintable width=980.0 align=null border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666  bordercolordark=FFFFFF><%
                      int i =0;
                      PosRowSet TCErrorCheckInfoVO = (PosRowSet)ctx.get("GetTCErrorCheckInfoResults");
                      while(TCErrorCheckInfoVO.hasNext())
                      {
                        row = TCErrorCheckInfoVO.next();
                        String StandardKoreanName        = row.getAttribute("STANDARD_KOREAN_NAME").toString();
                        String MdlDefineDtNmSeq         = row.getAttribute("MDL_DEFINE_DT_NM_SEQ").toString();
                        String DataTp     = row.getAttribute("DATA_TP").toString();
                        String MdlDefineDtNmLen        = row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString();
                        
                        String MdRuleDtNmCdF        = "";
                        String MdRuleChkOlstatr1    = "";
                        String MdRuleChkMiV1        = "";
                        String MdRuleChkMaxV1        = "";
                        String MdRuleChkOlstatr2    = "";
                        String MdRuleChkMiV2         = "";
                        String MdRuleChkMaxV2        = "";
                        String MdRuleDtNmDetailOperType        = "";
                        String MdRuleDtNmTrueBas        = "";  
                        
                        //String MdlDefineId        = ""; 
                        String DtNmId        = ""; 
                        String MdRuleDtNmBasChkSeq = "";  
                        
                        //Min1
                        if(row.getAttribute("MD_RULE_CHK_MI_V_1")==null)
                        {
                            MdRuleChkMiV1="";
                        }
                        else
                        {
                            MdRuleChkMiV1=row.getAttribute("MD_RULE_CHK_MI_V_1").toString();
                        }
                        
                        //Max1
                        if(row.getAttribute("MD_RULE_CHK_MAX_V_1")==null)
                        {
                            MdRuleChkMaxV1="";
                        }
                        else
                        {
                            MdRuleChkMaxV1=row.getAttribute("MD_RULE_CHK_MAX_V_1").toString();
                        }
                        
                        //Min2
                        if(row.getAttribute("MD_RULE_CHK_MI_V_2")==null)
                        {
                            MdRuleChkMiV2="";
                        }
                        else
                        {
                            MdRuleChkMiV2        = row.getAttribute("MD_RULE_CHK_MI_V_2").toString();
                        }
                        
                        //Max2
                        if(row.getAttribute("MD_RULE_CHK_MAX_V_2")==null)
                        {
                            MdRuleChkMaxV2="";
                        }
                        else
                        {
                            MdRuleChkMaxV2        = row.getAttribute("MD_RULE_CHK_MAX_V_2").toString();
                        }
                        
                        //MDL_DEFINE_ID
                        if(row.getAttribute("MDL_DEFINE_ID")==null)
                        {
                            MdlDefineId="";
                        }
                        else
                        {
                            MdlDefineId        = row.getAttribute("MDL_DEFINE_ID").toString();
                        }
                        
                        //DT_NM_ID
                        if(row.getAttribute("DT_NM_ID")==null)
                        {
                            DtNmId="";
                        }
                        else
                        {
                            DtNmId=row.getAttribute("DT_NM_ID").toString();
                        }
                        
                        //                        
                        if(row.getAttribute("MD_RULE_DT_NM_BAS_CHK_SEQ")==null)
                        {
                            MdRuleDtNmBasChkSeq="2";
                        }
                        else
                        {
                            MdRuleDtNmBasChkSeq        = row.getAttribute("MD_RULE_DT_NM_BAS_CHK_SEQ").toString();
                        }            
                  %>    
              <tr class=tblcg height=18> 
                <td index=<%=i%> width=3.061%><input type="checkbox" name="chk" value=<%=i%> ></td>
                <td index=<%=i%> onClick='javascript: return printindex(this.index)' width=43><%=i+1%></td>
                <td index=<%=i%> name='StandardKoreanName' width=159><%=StandardKoreanName%></td>
                <td index=<%=i%> name=MdlDefineDtNmSeq width=40><%=MdlDefineDtNmSeq%></td>
                <td index=<%=i%> name=DataTp width=70><%=DataTp%></td>
                <td index=<%=i%> name=MdlDefineDtNmLen width=42><%=MdlDefineDtNmLen%></td>
                <td index=<%=i%> width=5.102%><posui:showSelectList name="MdRuleDtNmCdF" staticNames="N|C|Y" staticValues="N|C|Y" defaultSelectionValues="<%=(String)row.getAttribute(\"MD_RULE_DT_NM_CD_F\")%>" style="width:48"/></td>
                <td index=<%=i%> width=7.143%>
                  <select name="MdRuleChkOlstatr1" style=width:68 size=1 class=adb2 >          
                    <option value="=" <%if("=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>>=</option>
                    <option value="!=" <%if("!=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>>!=</option>
                    <option value=">" <%if(">".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>>></option>
                    <option value=">=" <%if(">=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>>>=</option>
                    <option value="<" <%if("<".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>><</option>
                    <option value="<=" <%if("<=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>><=</option>
                    <option value="IN" <%if("IN".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>>IN</option>
                    <option value="BETWEEN" <%if("BETWEEN".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>BETWEEN</option>
                    <option value="BETWEEN1" <%if("BETWEEN1".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>BETWEEN1</option>
                    <option value="BETWEEN2" <%if("BETWEEN2".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>BETWEEN2</option>
                    <option value="BETWEEN3" <%if("BETWEEN3".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>BETWEEN3</option>
                    <option value="BETWEEN4" <%if("BETWEEN4".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>BETWEEN4</option>
                    <option value="NOTNUM" <%if("NOTNUM".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>NOTNUM</option>
                    <option value="ALL" <%if("ALL".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>>ALL</option>
                    <option value="DATE" <%if("DATE".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))         { %>selected<%}%>>DATE</option>
                    <option value="SUBSTR" <%if("SUBSTR".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>SUBSTR</option>
                    <option value="SPACE" <%if("SPACE".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>SPACE</option>
                    <option value="NOT_NULL" <%if("NOT_NULL".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_1")))     { %>selected<%}%>>NOT_NULL</option>
                  </select>
                </td>
                <td index=<%=i%>  width=8.1632%><input type="text"  name=MdRuleChkMiV1 value="<%=MdRuleChkMiV1%>"  style=width:76 style=height:18 class=adb2 onBlur="this.value=upperCase(this.value);" onFocus=this.className='adf2'></td>
                <td index=<%=i%>  width=8.1632%><input type="text"  name=MdRuleChkMaxV1 value="<%=MdRuleChkMaxV1%>"  style=width:77 style=height:18 class=adb2 onBlur="this.value=upperCase(this.value);" onFocus=this.className='adf2' ></td>
                <td index=<%=i%> width=7.143%>
                  <select name="MdRuleChkOlstatr2" style=width:68 size=1 class=adb2 >
                    <option value=""></option>
                    <option value="="            <% if("=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>=</option>
                    <option value="!="          <% if("!=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>!=</option>
                    <option value=">"            <% if(">".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>></option>
                    <option value=">="          <% if(">=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>>=</option>
                    <option value="<"            <% if("<".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>><</option>
                    <option value="<="          <% if("<=".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>><=</option>
                    <option value="IN"            <% if("IN".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>IN</option>
                    <option value="BETWEEN"      <% if("BETWEEN".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>BETWEEN</option>
                    <option value="BETWEEN1"      <% if("BETWEEN1".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>BETWEEN1</option>
                    <option value="BETWEEN2"      <% if("BETWEEN2".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>BETWEEN2</option>
                    <option value="BETWEEN3"      <% if("BETWEEN3".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>BETWEEN3</option>
                    <option value="BETWEEN4"      <% if("BETWEEN4".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>BETWEEN4</option>
                    <option value="NOTNUM"        <% if("NOTNUM".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>NOTNUM</option>
                    <option value="ALL"          <% if("ALL".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>ALL</option>
                    <option value="DATE"        <% if("DATE".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>DATE</option>
                    <option value="SUBSTR"      <% if("SUBSTR".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>SUBSTR</option>
                    <option value="SPACE"          <% if("SPACE".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>SPACE</option>
                    <option value="NOT_NULL"    <% if("NOT_NULL".equals(row.getAttribute("MD_RULE_CHK_OLSTATR_2"))) { %>selected<%}%>>NOT_NULL</option>
                  </select>
                </td>
                <td index=<%=i%>  width=8.1632%><input type="text"  name=MdRuleChkMiV2 value="<%=MdRuleChkMiV2%>"  style=width:77 style=height:18 class=adb2 onBlur="this.value=upperCase(this.value);" onFocus=this.className='adf2'></td>
                <td index=<%=i%>  width=8.1632%><input type="text"  name=MdRuleChkMaxV2 value="<%=MdRuleChkMaxV2%>"  style=width:77 style=height:18 class=adb2 onBlur="this.value=upperCase(this.value);" onFocus=this.className='adf2'></td>
                <td index=<%=i%>  width=5.102%><posui:showSelectList name="MdRuleDtNmDetailOperType" staticNames="AND|OR" staticValues="AND|OR" defaultSelectionValues="<%=(String)row.getAttribute(\"MD_RULE_DT_NM_DETAIL_OPER_TYPE\")%>" style="width:58"/></td>
                <td index=<%=i%>  width=4.08%><posui:showSelectList name="MdRuleDtNmTrueBas" staticNames="T|F" staticValues="T|F" defaultSelectionValues="<%=(String)row.getAttribute(\"MD_RULE_DT_NM_TRUE_BAS\")%>" style="width:38"/></td>
                <input type="hidden" name="MdlDefineId" value="<%=MdlDefineId%>" >
                <input type="hidden" name="DtNmId" value="<%=DtNmId%>" >
                <input type="hidden" name="MdRuleDtNmBasChkSeq"  value="<%=MdRuleDtNmBasChkSeq%>">
              </tr><%
                      i++;
                }
                %> 
            </table>
<input type="hidden" name="gMdlDefineId" value="<%=MdlDefineId%>">
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
          </td>  
        </tr> 
      </table> 
</body>
</html>