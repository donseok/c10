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
 * @FileName      : 표준용어 목록 >> 표준용어 조회
 * Open Issues    :
 * Change history 
 * @2010-06-18 황유진 1.0 isPermitAction() 적용
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String SearchTypeLOV =request.getParameter("SearchTypeLOV")==null?"":request.getParameter("SearchTypeLOV");
    String sysTpLOV      =request.getParameter("sysTpLOV")== null?"":request.getParameter("sysTpLOV");
    String chainLOV      =request.getParameter("chainLOV")== null?"":request.getParameter("chainLOV");
    String SearchWord    =request.getParameter("SearchWord")== null?"":request.getParameter("SearchWord");
    String nsynChkBox    =request.getParameter("nsynChkBox")== null?"":request.getParameter("nsynChkBox");

    List termSectionList = (List) ctx.get("_SYS_V_TERMS_SECTION");
    HashMap<String, String> termSectionMap = new HashMap<String, String>();
    for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
        Object[] value = (Object[]) termSectionList.get(i);
        termSectionMap.put((String)value[0], (String)value[1]);
    }

    String TermsName     = "";
    String EngFullName = "";
    String ChineseChar = "";
    String EngId         = "";
    String EngAbbr     = "";
    String TermsSection = "";
    String Synonymous1 = "";
    String TermsDescript = "";
    String OwnerDept     = "";
    String SubcNm        = "";
    String ChainCode     = "";
    String RegisterDate = "";
    String OtherTerms    = "";

    PosRowSet rowset = (PosRowSet)ctx.get("selTermsInfoResults");
    PosRow row;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.003",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
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
    document.forms[0].action = document.forms[0].action+"?find=10";
    document.forms[0].submit();
}
function doUpdate(){
    var hasCheckedData = false;
    if(document.forms[0].modifyChk.length>=2){
        for(var i=0;i<document.forms[0].modifyChk.length;i++){
            if(document.forms[0].modifyChk[i].checked){
                hasCheckedData = true;
            }
        }
    }else{
        hasCheckedData = document.forms[0].modifyChk.checked;
    }
    if(hasCheckedData){
      document.forms[0].action = document.forms[0].action+"?modify=10";
      document.forms[0].target = "_top"; 
      document.forms[0].submit();
    }else{
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    }
}
// 입력데이타에 스페이스가 있는지 체크...
function IsEmpty(toCheck){
     var is_Space = false;
     if ( ( toCheck == "") || ( toCheck == null ) )
        return true;

     for ( j = 0 ; !(is_Space) && ( j < toCheck.length ) ; j++){
         if( toCheck.substring( j , j+1 ) == " " ){
             return true;
         }
     }
     return is_Space;
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.003",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_word_data" method="post" action="m000207010.do">
<input type="hidden" name="ServiceName" value="m000207010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="forwardname" value="modify">
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
    <option value="termsNM"><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></option>
    <option value="engFullNm"><%=PosContext.getResourceMessage("GMResource","gm.label.0254",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=SearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>&nbsp;
  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0113",null,locale)%></b>
  <input type="checkbox" name="synChkBox" value="GO" <%if( nsynChkBox.equals("true") ){%>checked<%}%> >
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick="doUpdate()" style="cursor:pointer"><!-- modify --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.help",null,locale)%>" style="cursor:pointer"><!-- help -->
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
          <td valign=top align="left">
            <DIV ID=divData STYLE='position:relative;overflow-y:scroll;width:980;height:410;top:0;left:0;'><%
    if(!rowset.hasNext())
    {
    %>
            <table width="960" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr>
                <td class="tbllb">입력한 문자가 포함된 용어가 없습니다.</td>
              </tr>
            </table><%
    }
    int modifyIndex = 0;
    while(rowset.hasNext())
    {
        row=rowset.next(); 
        TermsName = row.getAttribute("TERMS_NAME") ==null? "" : row.getAttribute("TERMS_NAME").toString();
        EngFullName = row.getAttribute("ENG_FULL_NAME") ==null? "" : row.getAttribute("ENG_FULL_NAME").toString();
        ChineseChar = row.getAttribute("CHINESE_CHAR") ==null? "" : row.getAttribute("CHINESE_CHAR").toString();
        EngId = row.getAttribute("ENG_ID") ==null? "" : row.getAttribute("ENG_ID").toString();
        EngAbbr = row.getAttribute("ENG_ABBR") ==null? "" : row.getAttribute("ENG_ABBR").toString();
        TermsSection = row.getAttribute("TERMS_SECTION")==null||!termSectionMap.containsKey((String)row.getAttribute("TERMS_SECTION"))?"":termSectionMap.get((String)row.getAttribute("TERMS_SECTION"));

        Synonymous1 = row.getAttribute("SYNONYMOUS_1") ==null? "" : row.getAttribute("SYNONYMOUS_1").toString();
        TermsDescript = row.getAttribute("TERMS_DESCRIPT") ==null? "" : row.getAttribute("TERMS_DESCRIPT").toString();
        OwnerDept = row.getAttribute("OWNER_DEPT") ==null? "" : row.getAttribute("OWNER_DEPT").toString();
        SubcNm = row.getAttribute("SUBC_NM") ==null? "" : row.getAttribute("SUBC_NM").toString();
        ChainCode = row.getAttribute("CHAIN_CODE") ==null? "" : row.getAttribute("CHAIN_CODE").toString();
        RegisterDate = row.getAttribute("REGISTER_DATE") ==null? "" : String.valueOf(row.getAttribute("REGISTER_DATE"));
        OtherTerms = row.getAttribute("OTHER_TERMS") ==null? "" : row.getAttribute("OTHER_TERMS").toString();
%>
            <table width="960" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr height="18">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></b></td>
                <td class="tbllw" width="380">&nbsp;<b><%=TermsName%></b></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></b></td>
                <td class="tbllw" width="120">&nbsp;<%=TermsSection%></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0048",null,locale)%></b></td>
                <td class="tbllw" width="100">&nbsp;<%=ChainCode%></td>
              </tr>
              <tr height="18">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0254",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=EngFullName%></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=EngId%></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=OwnerDept%></td>
              </tr>
              <tr height="18">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0196",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=ChineseChar%></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=EngAbbr%></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0024",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=SubcNm%></td>
              </tr>
              <tr height="18">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0205",null,locale)%></b></td>
                <td class="tbllw" colspan="3">&nbsp;<%=Synonymous1%></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0174",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=RegisterDate%></td>
              </tr>
              <tr height="18">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0253",null,locale)%></b></td>
                <td class="tbllw" colspan="5">&nbsp;<textarea name="TermsDescript" rows="2" cols="110" class=adb1><%=TermsDescript%></textarea>
                  <input type="checkbox" name='modifyChk' class=adb1 value=<%=modifyIndex%>>
                  <input type="hidden" name='TermsName' value='<%=TermsName%>'>
                  <input type="hidden" name='EngFullName' value='<%=EngFullName%>'>
                </td>
              </tr>
              <tr height="18">
                <td class="tbllb" align="center"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0090",null,locale)%></b></td>
                <td class="tbllw" colspan="5">&nbsp;<textarea name="OtherTerms" rows="2" cols="110" class=adb1><%=OtherTerms%></textarea>
                </td>
              </tr>
            </table>
            <table width="960" border=0 cellspacing="0" cellpadding="0">
              <tr>
                <td colspan=6 background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
              </tr>
            </table><%
        modifyIndex++;
    }
%>
            </div>
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