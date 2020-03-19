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
 * @FileName      : 전문목록조회
 * Open Issues    :
 * Change history
 * @2008-03-24 이진 1.0
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
        PosSecurityUtil.checkPageID("m000204010");
        isAdmin = PosMenu.getCurPage().isPermitAction("save");
    }

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String chain1LOV     = request.getParameter("chain1LOV")== null?"%": request.getParameter("chain1LOV");
    String chain2LOV     = request.getParameter("chain2LOV")== null?"%": request.getParameter("chain2LOV");
    String sSearchAttribute = request.getParameter("SearchAttribute")== null?"MDL_DEFINE_NM": request.getParameter("SearchAttribute");
    String sSearchWord   = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");

    //모드기억
    String sMode=request.getParameter("mode")== null?"": request.getParameter("mode");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.082",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
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
    if (document.forms[0].SearchWord.value.length>0){
       if(IsEmpty(document.forms[0].SearchWord.value)){
          alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0058",null,locale)%>");
          document.forms[0].SearchWord.focus();
          return;
       }
    }
    document.forms[0].curPageNum.value="1";//showPageSet tag.
    document.forms[0].submit();
}
function viewDetail(tc_id_index){
    if (document.forms[0].MdlDefineId.length>0){
        document.form_detail.TbM00Interfaces_MdlDefineId.value = document.forms[0].MdlDefineId[tc_id_index].value;
        document.form_detail.TbM00Interfaces_FkMdlDefineId.value = document.forms[0].FkMdlDefineId[tc_id_index].value;
        document.form_detail.TbM00Interfaces_MdlDefineNm.value = document.forms[0].MdlDefineNm[tc_id_index].value;

        document.form_detail.format_name.value = document.forms[0].FormatName[tc_id_index].value;
    }else{
        document.form_detail.TbM00Interfaces_MdlDefineId.value = document.forms[0].MdlDefineId.value;
        document.form_detail.TbM00Interfaces_FkMdlDefineId.value = document.forms[0].FkMdlDefineId.value;
        document.form_detail.TbM00Interfaces_MdlDefineNm.value = document.forms[0].MdlDefineNm.value;

        document.form_detail.format_name.value = document.forms[0].FormatName.value;
    }
    showPopup("","m000204010_detail",1016,641,'1',0,0,1,1,1,0,0);
    document.form_detail.target="m000204010_detail";
    document.form_detail.submit();
}
function viewDetailModify(){
    if (document.forms[0].MdlDefineId.length>0){
        for(i=0;i<document.forms[0].sel.length;i++){
            if(document.forms[0].sel[i].checked){
                document.form_detail.mode.value="modify";
                document.form_detail.isAdmin.value="<%=isAdmin%>";
                viewDetail(i);
                document.form_detail.mode.value="";
                document.form_detail.isAdmin.value="";
                return;
            }
        }
    }else{
        if(document.forms[0].sel.checked){
            document.form_detail.isAdmin.value="<%=isAdmin%>";
            document.form_detail.mode.value="modify";
            viewDetail(i);
            document.form_detail.mode.value="";
            document.form_detail.isAdmin.value="";
            return;
        }
    }
    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0038",null,locale)%>');//수정하고자 하는 전문을 선택하십시요!
}
function deleteTC(){
    if (document.forms[0].MdlDefineId.length>0){
        for(i=0;i<document.forms[0].sel.length;i++){
            if(document.forms[0].sel[i].checked){
                do_delete_TC_Format("delTC=10", document.forms[0].MdlDefineNm[i].value);
                return;
            }
        }
    }else{
        if(document.forms[0].sel.checked){
            do_delete_TC_Format("delTC=10", document.forms[0].MdlDefineNm.value);
            return;
        }
    }
    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0031",null,locale)%>');//삭제하고자 하는 전문을 선택하십시요!
}
function do_delete_TC_Format(eventName, tc){
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0029",null,locale)%>')){//선택하신 전문 및 에러체크 기준을 삭제처리 하시겠습니까?
        document.forms[0].mode.value="del";
        document.forms[0].DelTC.value = tc;
        document.forms[0].DelFormat.value = tc;
        document.forms[0].action = document.forms[0].action+"?"+eventName;//delTC.x=10,delFormatNTC.x=10
        document.forms[0].submit();
    }
}
function deleteFormat(){
    if (document.forms[0].MdlDefineId.length>0){
        for(i=0;i<document.forms[0].sel.length;i++){
            if(document.forms[0].sel[i].checked){
                do_delete_TC_Format("delFormatNTC=10", document.forms[0].FormatName[i].value);
                return;
            }
        }
    }else{
        if(document.forms[0].sel.checked){
            do_delete_TC_Format("delFormatNTC=10", document.forms[0].FormatName.value);
            return;
        }
    }
    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0032",null,locale)%>');//삭제하고자 하는 포맷을 선택하십시요!
}
function listFormat(){
    document.forms[0].action = "m000204050.do?curPageNum=1";
    document.forms[0].ServiceName.value = "m000204050-service";
    document.forms[0].submit();
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
function goJCSPage(rowIndex){
    document.form_jcs.MdlDefineId.value=document.forms[0].MdlDefineId.length > 1 ? document.forms[0].MdlDefineId[rowIndex].value : document.forms[0].MdlDefineId.value;
    document.form_jcs.MdlDefineNm.value=document.forms[0].MdlDefineId.length > 1 ? document.forms[0].MdlDefineNm[rowIndex].value : document.forms[0].MdlDefineNm.value;
    showPopup("","m000204010_jcs",440,220,'1',0,0,1,1,1,0,0);
    document.form_jcs.target="m000204010_jcs";
    document.form_jcs.submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage);setTableIndex(TCListTable)">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.082",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_tc" method="post" action="m000204010.do">
<input type="hidden" name="ServiceName" value="m000204010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="format_id">
<input type="hidden" name="format_name" value="">
<input type="hidden" name="mode" value="ret">
<input type="hidden" name="DelTC" value="">
<input type="hidden" name="DelFormat" value="">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align=left><b><%=PosContext.getResourceMessage("GMResource","gm.label.0269",null,locale)%></b> :
                  <select name="chain1LOV" class="adf">
                    <option value="%"><%=PosContext.getResourceMessage("GMResource","gm.label.0023",null,locale)%></option><%
    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("TCChainCode1VOResults") : null;
    if(rowset!=null){
        PosRow tmprow = null;
        while(rowset.hasNext()){
            tmprow = rowset.next();
            if(tmprow.getAttribute("SEND_CODE")!=null){
%>
                    <option value="<%=(String)tmprow.getAttribute("SEND_CODE")%>" <%=chain1LOV.equals((String)tmprow.getAttribute("SEND_CODE"))?"selected":""%>><%=(String)tmprow.getAttribute("SEND_CODE")%></option><%
            }
        }
    }
%>
                  </select>&nbsp;&nbsp;
                  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0270",null,locale)%></b> :
                  <select name="chain2LOV" class="adf">
                    <option value="%"><%=PosContext.getResourceMessage("GMResource","gm.label.0023",null,locale)%></option><%
    rowset = ctx!=null ? (PosRowSet)ctx.get("TCChainCode2VOResults") : null;
    if(rowset!=null){
        PosRow tmprow = null;
        while(rowset.hasNext()){
            tmprow = rowset.next();
            if(tmprow.getAttribute("RECIEVE_CODE")!=null){
%>
                    <option value="<%=(String)tmprow.getAttribute("RECIEVE_CODE")%>" <%=chain2LOV.equals((String)tmprow.getAttribute("RECIEVE_CODE"))?"selected":""%>><%=(String)tmprow.getAttribute("RECIEVE_CODE")%></option><%
            }
        }
    }
%>
                  </select>&nbsp;&nbsp;
  <select name="SearchAttribute" class="adf">
    <option value="MDL_DEFINE_NM" <%=          "MDL_DEFINE_NM".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0213",null,locale)%></option>
    <option value="MDL_DEFINE_EXPLAIN" <%="MDL_DEFINE_EXPLAIN".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0214",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick='viewDetailModify()' style="cursor:pointer"><!-- modify -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.deletetc",null,locale)%>" onClick='deleteTC()' style="cursor:pointer"><!-- delete TC -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.deleteformat",null,locale)%>" onClick='deleteFormat()' style="cursor:pointer"><!-- delete Format --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.formatlist",null,locale)%>" onClick='listFormat()' style="cursor:pointer"><!-- addedbyseasun0, listformat -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=left valign=top><% if(isAdmin){ %>
            <posglobalui:showTable infoName="GetTCListResults" tableName="TCListTable"
              headerClasses="tbldb"
              headerValues="gm.label.0155|gm.label.0213|gm.label.0214|gm.label.0212|gm.label.0188|gm.label.0171|gm.label.0250|gm.label.0199|gm.label.0086|gm.label.0089|gm.label.0101|gm.label.0077"
              height="20"
              trClasses="tblcg|tblcw"
              tdClasses="null|null|left|null|null|null|null|null|null|null|null|null"
              columnNames="sel|MdlDefineNm|MdlDefineExplain|FormatName|ProcessChainCode1|ProcessChainCode2|MdlDefineOwnerEmpNo|StarMdlDefineOwnerEmpNotDt|EndDt|EchkFlag|NewVersionFlag|ViewAttr|
                MdlDefineId|FkMdlDefineId|MdlDefineExplain|FormatName|MdlDefineNm"
              columnWidths="42|70|314|67|62|62|71|70|70|61|61|30|0|0|0|0|0"
              displayTypes="radio|link|text|text|text|text|text|text|text|text|text|link|
                hidden|hidden|hidden|hidden|hidden"
              attributes ="null|MDL_DEFINE_NM|MDL_DEFINE_EXPLAIN|FORMAT_NAME|PROCESS_CHAIN_CODE1|PROCESS_CHAIN_CODE2|MDL_DEFINE_OWNER_EMP_NO|START_ACTIVE_DATE|END_ACTIVE_DATE|ECHK_FLAG|NEW_VERSION_FLAG|VIEW_ATTR|
                MDL_DEFINE_ID|FK_MDL_DEFINE_ID|MDL_DEFINE_EXPLAIN|FORMAT_NAME|MDL_DEFINE_NM"
              tdEvents=  "null|javascript:\" onClick=\"viewDetail(this.parentElement.index)|null|null|null|null|null|null|null|null|null|javascript:\" onClick=\"goJCSPage(this.parentElement.index)|
                null|null|null|null|null"
              displayFormats="null|null|null|null|null|null|null|yyyy-MM-dd|yyyy-MM-dd|null|null|null|
                null|null|null|null|null"
              defaultRowCnt="20"
            /><% }else{ %>
            <posglobalui:showTable infoName="GetTCListResults" tableName="TCListTable"
              headerClasses="tbldb"
              headerValues="gm.label.0155|gm.label.0213|gm.label.0214|gm.label.0212|gm.label.0188|gm.label.0171|gm.label.0250|gm.label.0199|gm.label.0086|gm.label.0089|gm.label.0101"
              height="20"
              trClasses="tblcg|tblcw"
              tdClasses="null|null|left|null|null|null|null|null|null|null|null"
              columnNames="sel|MdlDefineNm|MdlDefineExplain|FormatName|ProcessChainCode1|ProcessChainCode2|MdlDefineOwnerEmpNo|StarMdlDefineOwnerEmpNotDt|EndDt|EchkFlag|NewVersionFlag|
                MdlDefineId|FkMdlDefineId|MdlDefineExplain|FormatName|MdlDefineNm"
              columnWidths="42|70|334|77|62|62|71|70|70|61|61|0|0|0|0|0"
              displayTypes="radio|link|text|text|text|text|text|text|text|text|text|
                hidden|hidden|hidden|hidden|hidden"
              attributes ="null|MDL_DEFINE_NM|MDL_DEFINE_EXPLAIN|FORMAT_NAME|PROCESS_CHAIN_CODE1|PROCESS_CHAIN_CODE2|MDL_DEFINE_OWNER_EMP_NO|START_ACTIVE_DATE|END_ACTIVE_DATE|ECHK_FLAG|NEW_VERSION_FLAG|
                MDL_DEFINE_ID|FK_MDL_DEFINE_ID|MDL_DEFINE_EXPLAIN|FORMAT_NAME|MDL_DEFINE_NM"
              tdEvents=  "null|javascript:\" onClick=\"viewDetail(this.parentElement.index)|null|null|null|null|null|null|null|null|null|
                null|null|null|null|null"
              displayFormats="null|null|null|null|null|null|null|yyyy-MM-dd|yyyy-MM-dd|null|null|
                null|null|null|null|null"
              defaultRowCnt="20"
            /><% } %>
            <div align="center">
            <posui:showPageSet infoName="GetTCListResults" formName="document.forms[0]" curPageName="curPageNum"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000204010.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000204010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="chain1LOV" value="<%=chain1LOV%>">
<input type="hidden" name="chain2LOV" value="<%=chain2LOV%>">
<input type="hidden" name="SearchWord" value="<%=sSearchWord%>%">
<input type="hidden" name="SearchAttribute" value="<%=sSearchAttribute%>">
</form>
<form name="form_jcs" method="post" action="m000204010.do"><!-- jcs -->
<input type="hidden" name="ServiceName" value="m000204010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="jcs" value="10"><!-- event -->
<input type="hidden" name="MdlDefineId">
<input type="hidden" name="MdlDefineNm">
</form>
<form name="form_detail" method="post" action="m000204020.do"><!-- detail -->
<input type="hidden" name="ServiceName" value="m000204020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin">
<input type="hidden" name="TbM00Interfaces_MdlDefineId"><!-- TB_M00_INTERFACES -->
<input type="hidden" name="TbM00Interfaces_FkMdlDefineId">
<input type="hidden" name="TbM00Interfaces_MdlDefineNm">
<input type="hidden" name="format_name">
<input type="hidden" name="mode">
</form>
    </td>
  </tr>
</table>
</body>
</html><%
    if("del".equals(sMode))
    {
%>
<script type="text/javascript">
    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0030",null,locale)%>');//삭제되었습니다!
</script><%
    }
%>