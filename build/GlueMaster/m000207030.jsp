<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
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
 * @FileName      : 표준항목 목록
 * Open Issues    :
 * Change history 
 * @2010-06-18 황유진 1.0 isPermitAction() 적용
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
        PosSecurityUtil.checkPageID("m000207030");
        isAdmin = PosMenu.getCurPage().isPermitAction("detail");
    }

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String SearchTypeLOV = request.getParameter("SearchTypeLOV")== null?"dataItemNM": request.getParameter("SearchTypeLOV");
    String sysTpLOV      = request.getParameter("sysTpLOV")== null?"": request.getParameter("sysTpLOV");
    String chainLOV      = request.getParameter("chainLOV")== null?"": request.getParameter("chainLOV");
    String SearchWord    = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
    String nsynChkBox    = request.getParameter("nsynChkBox")== null?"": request.getParameter("nsynChkBox");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.004",null,locale)%></title>
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
    var nsynChkBox = "";
    var scSearchWord = document.forms[0].SearchWord.value;
    if (document.forms[0].synChkBox.checked==true){
        document.forms[0].nsynChkBox.value ="true"
    }
    if (scSearchWord.length>0){
        if(IsEmpty(scSearchWord)){
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0008",null,locale)%>");
            document.forms[0].SearchWord.focus();
            return;
        }
    }
    document.forms[0].curPageNum.value="1";//showPageSet tag.
    document.forms[0].submit();
}
//표준항목 내용상세
function go_open_detail(tc_id_index){
    document.form_detail.data_item_name.value     = document.forms[0].DataItemName[tc_id_index].value;
    document.form_detail.data_var_id.value        = document.forms[0].DataVarId[tc_id_index].value;
    document.form_detail.sys_tp.value             = document.forms[0].SysTp[tc_id_index].value;
    document.form_detail.chain_code.value         = document.forms[0].ChainCode[tc_id_index].value;
    document.form_detail.data_type.value          = document.forms[0].DataType[tc_id_index].value;
    document.form_detail.data_number.value        = document.forms[0].DataNumber[tc_id_index].value;
    document.form_detail.decimal_number.value     = document.forms[0].DecimalNumber[tc_id_index].value;
    document.form_detail.data_unit.value          = document.forms[0].DataUnit[tc_id_index].value;
    document.form_detail.code_yn.value            = document.forms[0].CodeYnHidden[tc_id_index].value;
    document.form_detail.kor_abbr.value           = document.forms[0].KorAbbr[tc_id_index].value;
    document.form_detail.eng_abbr.value           = document.forms[0].EngAbbr[tc_id_index].value;
    document.form_detail.data_synonymous_1.value  = document.forms[0].DataSynonymous1[tc_id_index].value; 
    document.form_detail.data_synonymous_2.value  = document.forms[0].DataSynonymous2[tc_id_index].value; 
    document.form_detail.data_synonymous_3.value  = document.forms[0].DataSynonymous3[tc_id_index].value; 
    document.form_detail.data_item_descript.value = document.forms[0].DataItemDescript[tc_id_index].value;
    document.form_detail.other_terms.value        = document.forms[0].OtherTerms[tc_id_index].value;
    document.form_detail.owner_dept.value         = document.forms[0].OwnerDept[tc_id_index].value;
    document.form_detail.subc_nm.value            = document.forms[0].SubcNm[tc_id_index].value;
    document.form_detail.register_date.value      = document.forms[0].RegisterDate[tc_id_index].value;
    showPopup("","m000207030_detail",1016,641,'1',0,0,1,1,1,0,0);
    document.form_detail.target = "m000207030_detail"; 
    document.form_detail.submit();
}
// 입력데이타에 스페이스가 있는지 체크...
function IsEmpty(toCheck){
    var is_Space = false;
    if ( ( toCheck == "") || ( toCheck == null ) )
       return true;

    for ( j = 0 ; !(is_Space) &&  ( j < toCheck.length ) ; j++){
        if( toCheck.substring( j , j+1 ) == " " ){
            return true;
        }
    }
    return is_Space;
}
function CodesCheck(tc_id_index){
    var CdTpIdvalue = document.forms[0].CdTpId[tc_id_index].value;
    var FkCdTpIdvalue = document.forms[0].FkCdTpId[tc_id_index].value;
    if(document.forms[0].CodeYnHidden[tc_id_index].value == "Y"){
        if((CdTpIdvalue == null || CdTpIdvalue == "") && (FkCdTpIdvalue == null || FkCdTpIdvalue == "")){
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0087",null,locale)%>");
        }else{
            document.form_code_detail.action = CdTpIdvalue == FkCdTpIdvalue ? "m000201010.do" : "m000201110.do";
            document.form_code_detail.CdTpId.value  =CdTpIdvalue;
            document.form_code_detail.FkCdTpId.value=FkCdTpIdvalue;
            showPopup("","m000207030_detail",1016,641,'1',0,0,1,1,1,0,0);
            document.form_code_detail.target="m000207030_detail";
            document.form_code_detail.submit();
        }
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.004",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_std" method="post" action="m000207030.do">
<input type="hidden" name="ServiceName" value="m000207030-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="nsynChkBox">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align="left">
  <posglobalui:showRelatedSelectLists infoName="SysTpResults" name="sysTpLOV" label="gm.label.0209" cls="adf"
    nameAttribute="SYS_TP" valueAttribute="SYS_TP" isDistinct="true" isRequestFirst="true" defaultSelectionValues="<%=sysTpLOV%>">
    <posglobalui:showRelatedSelectLists infoName="SysTpResults" name="chainLOV" label="gm.label.0047" cls="adf"
      nameAttribute="CHAIN_CODE" valueAttribute="CHAIN_NM" keyAttribute="SYS_TP" isDistinct="true" isRequestFirst="true" defaultSelectionValues="<%=chainLOV%>">
    </posglobalui:showRelatedSelectLists>
  </posglobalui:showRelatedSelectLists>&nbsp;&nbsp;
  <select name="SearchTypeLOV" class="adf">
    <option value="dataItemNM" <%="dataItemNM".equals(SearchTypeLOV)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></option>
    <option value="dataVarID" <%=  "dataVarID".equals(SearchTypeLOV)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=SearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>&nbsp;
  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0113",null,locale)%></b>
  <input type="checkbox" name="synChkBox" value="GO" <%if( nsynChkBox.equals("true") ){%>checked<%}%>>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
  <table id="mainTable" width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td width="47"><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
      <td width="200"><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></td>
      <td width="196"><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
      <td width="58"><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
      <td width="58"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="77"><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
      <td width="49"><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
      <td width="49"><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
      <td width="78"><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
      <td width="49"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td width="119"><%=PosContext.getResourceMessage("GMResource","gm.label.0021",null,locale)%></td>
    </tr><%
    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("selDataItemInfoListResults") : null;
    int rowCnt = 0;
    if( rowset!=null ){
        PosRow row = null;
        while(rowset.hasNext()){
            row = rowset.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><%=rowCnt+1%></td>
      <td align="left"><a href="javascript:" onClick="go_open_detail(<%=rowCnt%>)"><%=row.getAttribute("DATA_ITEM_NAME")==null?"&nbsp;":(String)row.getAttribute("DATA_ITEM_NAME")%></a></td>
      <td align="left"><%=row.getAttribute("DATA_VAR_ID")==null?"&nbsp;":(String)row.getAttribute("DATA_VAR_ID")%></td>
      <td><%=row.getAttribute("SYS_TP")==null?"&nbsp;":(String)row.getAttribute("SYS_TP")%></td>
      <td><%=row.getAttribute("CHAIN_CODE")==null?"&nbsp;":(String)row.getAttribute("CHAIN_CODE")%></td>
      <td><%=row.getAttribute("DATA_TYPE")==null?"&nbsp;":(String)row.getAttribute("DATA_TYPE")%></td>
      <td><%=row.getAttribute("DATA_NUMBER")==null?"&nbsp;":row.getAttribute("DATA_NUMBER").toString()%></td>
      <td><%=row.getAttribute("DECIMAL_NUMBER")==null?"&nbsp;":row.getAttribute("DECIMAL_NUMBER").toString()%></td>
      <td><%=row.getAttribute("DATA_UNIT")==null?"&nbsp;":(String)row.getAttribute("DATA_UNIT")%></td>
      <td><a href="javascript:" onClick="CodesCheck(<%=rowCnt%>)"><%=row.getAttribute("CODE_YN")==null?"&nbsp;":(String)row.getAttribute("CODE_YN")%></a></td>
      <td><%=row.getAttribute("KOR_ABBR")==null?"&nbsp;":(String)row.getAttribute("KOR_ABBR")%></td>
      <input type="hidden" name="DataItemName" value="<%=row.getAttribute("DATA_ITEM_NAME")==null?"":(String)row.getAttribute("DATA_ITEM_NAME")%>">
      <input type="hidden" name="DataVarId" value="<%=row.getAttribute("DATA_VAR_ID")==null?"":(String)row.getAttribute("DATA_VAR_ID")%>">
      <input type="hidden" name="SysTp" value="<%=row.getAttribute("SYS_TP")==null?"":(String)row.getAttribute("SYS_TP")%>">
      <input type="hidden" name="ChainCode" value="<%=row.getAttribute("CHAIN_CODE")==null?"":(String)row.getAttribute("CHAIN_CODE")%>">
      <input type="hidden" name="DataType" value="<%=row.getAttribute("DATA_TYPE")==null?"":(String)row.getAttribute("DATA_TYPE")%>">
      <input type="hidden" name="DataNumber" value="<%=row.getAttribute("DATA_NUMBER")==null?"":row.getAttribute("DATA_NUMBER").toString()%>">
      <input type="hidden" name="DecimalNumber" value="<%=row.getAttribute("DECIMAL_NUMBER")==null?"":row.getAttribute("DECIMAL_NUMBER").toString()%>">
      <input type="hidden" name="DataUnit" value="<%=row.getAttribute("DATA_UNIT")==null?"":(String)row.getAttribute("DATA_UNIT")%>">
      <input type="hidden" name="CodeYnHidden" value="<%=row.getAttribute("CODE_YN1")==null?"":(String)row.getAttribute("CODE_YN1")%>">
      <input type="hidden" name="KorAbbr" value="<%=row.getAttribute("KOR_ABBR")==null?"":(String)row.getAttribute("KOR_ABBR")%>">
      <input type="hidden" name="EngAbbr" value="<%=row.getAttribute("ENG_ABBR")==null?"":(String)row.getAttribute("ENG_ABBR")%>">
      <input type="hidden" name="DataSynonymous1" value="<%=row.getAttribute("DATA_SYNONYMOUS_1")==null?"":(String)row.getAttribute("DATA_SYNONYMOUS_1")%>">
      <input type="hidden" name="DataSynonymous2" value="<%=row.getAttribute("DATA_SYNONYMOUS_2")==null?"":(String)row.getAttribute("DATA_SYNONYMOUS_2")%>">
      <input type="hidden" name="DataSynonymous3" value="<%=row.getAttribute("DATA_SYNONYMOUS_3")==null?"":(String)row.getAttribute("DATA_SYNONYMOUS_3")%>">
      <input type="hidden" name="DataItemDescript" value="<%=row.getAttribute("DATA_ITEM_DESCRIPT")==null?"":(String)row.getAttribute("DATA_ITEM_DESCRIPT")%>">
      <input type="hidden" name="OtherTerms" value="<%=row.getAttribute("OTHER_TERMS")==null?"":(String)row.getAttribute("OTHER_TERMS")%>">
      <input type="hidden" name="OwnerDept" value="<%=row.getAttribute("OWNER_DEPT")==null?"":(String)row.getAttribute("OWNER_DEPT")%>">
      <input type="hidden" name="SubcNm" value="<%=row.getAttribute("SUBC_NM")==null?"":(String)row.getAttribute("SUBC_NM")%>">
      <input type="hidden" name="RegisterDate" value="<%=row.getAttribute("REGISTER_DATE")==null?"":(String)row.getAttribute("REGISTER_DATE")%>">
      <input type="hidden" name="CdTpId" value="<%=row.getAttribute("CD_TP_ID")==null?"":row.getAttribute("CD_TP_ID").toString()%>">
      <input type="hidden" name="FkCdTpId" value="<%=row.getAttribute("FK_CD_TP_ID")==null?"":row.getAttribute("FK_CD_TP_ID").toString()%>">
    </tr><%
            rowCnt++;
        }
        rowset.reset();
    }
    for(; rowCnt<20; rowCnt++){
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
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
      <td>&nbsp;</td>
    </tr><%
    }
%>
  </table>
            <div align="center">
            <posui:showPageSet infoName="selDataItemInfoListResults" formName="document.forms[0]" curPageName="curPageNum"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
      </form>
<form name="form_code_detail" method="post"><!-- m000201010.do/m000201110.do -->
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="detail" value="10"><!-- event -->
<input type="hidden" name="CdTpId">
<input type="hidden" name="FkCdTpId">
</form>
<form name="form_detail" method="post" action="m000207030.do" >
<input type="hidden" name="ServiceName" value="m000207030-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="detail" value="10"><!-- event -->
<input type="hidden" name=data_item_name value="">
<input type="hidden" name=data_var_id value="">
<input type="hidden" name=sys_tp value="">
<input type="hidden" name=chain_code value="">
<input type="hidden" name=data_type value="">
<input type="hidden" name=data_number value="">
<input type="hidden" name=decimal_number value="">
<input type="hidden" name=data_unit value="">
<input type="hidden" name=code_yn value="">
<input type="hidden" name=kor_abbr value="">
<input type="hidden" name=eng_abbr value="">
<input type="hidden" name=data_synonymous_1 value="">
<input type="hidden" name=data_synonymous_2 value="">
<input type="hidden" name=data_synonymous_3 value="">
<input type="hidden" name=data_item_descript value="">
<input type="hidden" name=other_terms value="">
<input type="hidden" name=owner_dept value="">
<input type="hidden" name=subc_nm value="">
<input type="hidden" name=register_date value="">
<input type="hidden" name=cd_tp_id value="">
<input type="hidden" name=fk_cd_tp_id value="">
</form>
<form name="form_export" method="post" action="m000207030.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000207030-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
</form>
    </td>
  </tr>
</table>
</body>
</html>