<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosPageSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 인터페이스전문 >> Format목록조회
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20120131
 * @LastModifier  : 정경주
 * @LastVersion   :  1.0
 *    2010-05-01   정경주
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String sSearchWord = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
    String sSearchAttribute = request.getParameter("SearchAttribute")== null?"MDL_DEFINE_NM": request.getParameter("SearchAttribute");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.092",null,locale)%></title>   
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript" src="js/common.js"></script>
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
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0079",null,locale)%>");
            document.forms[0].SearchWord.focus();
            return false;
        }else{
            document.forms[0].SearchWord.value = document.forms[0].SearchWord.value+"%";
        }
    }
    document.forms[0].curPageNum.value="1";//showPageSet tag.
    document.forms[0].submit();
}
function viewTCList(){
    document.forms[0].action="m000204010.do?curPageNum=1";
    document.forms[0].ServiceName.value="m000204010-service";
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
function viewTCListbelongtoFormat(tc_id_index){
	
    if (document.forms[0].MdlDefineId.length>0){
        TCForm.format_id.value = document.forms[0].MdlDefineId[tc_id_index].value;	
        TCForm.format_name.value = document.forms[0].FormatName[tc_id_index].value;
    }else{
        TCForm.format_id.value = document.forms[0].MdlDefineId.value;
        TCForm.format_name.value = document.forms[0].FormatName.value;
    }
    document.TCForm.target = "TCList";  
    document.TCForm.submit();

}
function resizeIF(Id){
    var obj = document.getElementById(Id);
    var Body, H, Min;
    Min = 0;
    try
    {
        Body = obj.contentWindow.document.getElementsByTagName('BODY');
        Body = Body[0];
        H = Body.scrollHeight + 0;
        obj.style.height =  (H<Min?Min:H) + 'px';
        this.Location = obj.contentWindow.document.location.href;
    }
    catch(e) {}
}
//Import 페이지로 이동
function go_open_import(){
    if(confirm("Format을 등록하시겠습니까? (YES:Format, NO:TC)")){
        showPopup("","m000204050_import",500,450,'1',0,0,1,1,1,0,0);
        document.form_import.target="m000204050_import";
        document.form_import.submit();
    }else{
        showPopup("","m000204050_import2",500,450,'1',0,0,1,1,1,0,0);
        document.form_import2.target="m000204050_import2";
        document.form_import2.submit();
    }
}

-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage);setTableIndex(FormatListTable);">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.092",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name=form1 method='post' action="m000204050.do">
<input type="hidden" name="ServiceName" value="m000204050-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" align=left>
  <posglobalui:showSelectList label=""   totalName="" totalValue="" name="SearchAttribute" staticNames="MDL_DEFINE_NM|MDL_DEFINE_EXPLAIN" staticValues="gm.label.0102|gm.label.0103" defaultSelectionValues="<%=sSearchAttribute%>"/>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.tclist",null,locale)%>" onClick='viewTCList()' STYLE='cursor:pointer'><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="go_open_import()" style="cursor:pointer"><!-- import --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" STYLE="cursor:pointer"><!-- export -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" STYLE='cursor:pointer'>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=left valign=top>
            <posglobalui:showTable infoName="GetFormatListResults" tableName="FormatListTable"
              headerClasses="tbldb"
              headerValues="gm.label.0155|gm.label.0102|gm.label.0103|gm.label.0199|gm.label.0086|gm.label.0156"
              height="20"
              trClasses="tblcg|tblcw"
              tdClasses="null|null|null|null|null|null|null|null"
              columnNames="sel|MdlDefineNm|MdlDefineExplain|StartActiveDate|EndActiveDate|CountTC|MdlDefineId|FormatName" 
              columnWidths="42|80|314|160|160|62|0|0" 
              displayTypes="no|link|text|text|text|text|hidden|hidden"
              attributes ="no|MDL_DEFINE_NM|MDL_DEFINE_EXPLAIN|START_ACTIVE_DATE|END_ACTIVE_DATE|COUNT_TC|MDL_DEFINE_ID|MDL_DEFINE_NM" 
              tdEvents=  "null|javascript:\" onClick=\"viewTCListbelongtoFormat(this.parentElement.index)|null|null|null|null|null|null"
              displayFormats="null|null|null|yyyy-MM-dd|yyyy-MM-dd|null|null|null"
              defaultRowCnt="10"
            />
            <div align="center">
            <posui:showPageSet infoName="GetFormatListResults" formName="document.forms[0]" curPageName="curPageNum"/>
            </div> 
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
        <div id="framediv"> 
         <td>
<iframe name="TCList" id="ifrm" onload=" resizeIF('ifrm')" src="m000204050iFrame.jsp" width="100%" height="100%" scrolling="no" leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 frameborder=2></iframe>
        </td>
        </div> 
        </tr> 
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
<form name="TCForm" method="post" action="m000204050.do">
<input type="hidden" name="ServiceName" value="m000204050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="iframe" value=10>
<input type="hidden" name="format_id">
<input type="hidden" name="format_name">
</form>
<form name="form_export" method="post" action="m000204050.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000204050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="SearchWord" value="<%=sSearchWord%>%">
<input type="hidden" name="SearchAttribute" value="<%=sSearchAttribute%>">
</form>
<form name="form_import" method="post" action="m000204050.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000204050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
</form>
<form name="form_import2" method="post" action="m000204050.do"><!-- import2 -->
<input type="hidden" name="ServiceName" value="m000204050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import2" value="10"><!-- event -->
</form>
</body>
</html>