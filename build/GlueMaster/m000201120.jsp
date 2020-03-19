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
 * @FileName      : 트랜잭션 목록 >> 트랜잭션 내용상세
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080307
 * @LastModifier  : 서정범
 * @LastVersion   : 1.0
 *    2008-03-07   서정범
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String sCdTpId =request.getParameter("CdTpId")== null?"":request.getParameter("CdTpId");
    String sFkCdTpId =request.getParameter("FkCdTpId")== null?"":request.getParameter("FkCdTpId");
    String sCategoryGroupId = request.getParameter("CategoryGroupId")== null?"%":request.getParameter("CategoryGroupId");
    String sSearchAttribute =request.getParameter("SearchAttribute")== null?"":request.getParameter("SearchAttribute");
    String sSearchWord = request.getParameter("SearchWord")== null?"":request.getParameter("SearchWord");
    String sSearchWord2 = request.getParameter("SearchWord")== null?"":request.getParameter("SearchWord");

    if ((sSearchWord == null) ||("%".equals(sSearchWord)))
    {
        sSearchWord = "";
    }
    // %검색어 처리를 하는데 변형필요(%를 인식못함)
    if(sSearchWord!=null&&sSearchWord.length()>0) {
        if(sSearchWord.indexOf("*") >= 0) {
            sSearchWord=sSearchWord2.replace('*','%');
        }
    } 
    if(sSearchWord2 != null && sSearchWord2.length() > 0) {
        if(sSearchWord2.indexOf("%") >= 0) {
            sSearchWord2=sSearchWord2.replace('%','*');
        }
    }

    // Code Header 부분
    PosRowSet rowset = (PosRowSet)ctx.get("CodeHeaderRowResult");
    PosRow headerRow = rowset.next();
    String CdTpCharacterStr = headerRow.getAttribute("CD_TP_CHARACTER")==null?"":(String)headerRow.getAttribute("CD_TP_CHARACTER");
    if("S".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0190",null,locale);
    else if("C".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0065",null,locale);
    else if("R".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0170",null,locale);
    else if("T".equals(CdTpCharacterStr)) CdTpCharacterStr = PosContext.getResourceMessage("GMResource","gm.label.0216",null,locale);
    String UseTpStr = headerRow.getAttribute("USE_TP")==null?"":(String)headerRow.getAttribute("USE_TP");
    if("S".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
    else if("Y".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
    else if("N".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
    else if("F".equals(UseTpStr)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.039",null,locale)%></title>
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
    document.forms[0].curPage.value="1";//showPageSet tag.
    document.forms[0].submit();
}
//코드구조
function goCodeLayout(){
    showPopup("","m000201120_layout",920,450,'1',0,0,1,1,1,0,0);
    document.form_layout.target="m000201120_layout";
    document.form_layout.submit();
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.039",null,locale)%></div></td>
          <td align="right"><!--조합코드일경우 구조를 조회 할 수 있는 팝업으로 링크 --><% if ("C".equals(headerRow.getAttribute("CD_TP_CHARACTER"))) { %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.codestruc",null,locale)%>" onClick="goCodeLayout()" style="cursor:pointer"><% } %>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_detail" method="post" action="m000201120.do">
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="detail" value="10"><!-- event -->
<input type="hidden" name="CdTpId" value="<%=sCdTpId%>">
<input type="hidden" name="FkCdTpId" value="<%=sFkCdTpId%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table id=code_header width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0172",null,locale)%></td>
                <td class=tbllw colspan=5><input type="text" value="<%="T".equals((String)headerRow.getAttribute("CD_TP_CHARACTER"))?(String)headerRow.getAttribute("FK_CD_TP"):(String)headerRow.getAttribute("CD_TP")%>" style="width:190" class=adg1 readonly></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
                <td class=tbllw width=195><input type="text" value="<%=headerRow.getAttribute("CD_TP")%>" style="width:190" class=adg1 readonly></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0061",null,locale)%></td>
                <td class=tbllw width=205><input type="text" value="<%=headerRow.getAttribute("CD_TP_MEANING")%>" style="width:200" class=adg1 readonly></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0223",null,locale)%></td>
                <td class=tbllw width=200><input type="text" value="<%=CdTpCharacterStr%>" class=adg1 readonly></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw colspan=3>
                  <input type="text" value="<%=(String)headerRow.getAttribute("START_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly> ~
                  <input type="text" value="<%=headerRow.getAttribute("END_ACTIVE_DATE_STR")==null?"":(String)headerRow.getAttribute("END_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly>
                </td>
                <td class=tbldb>[Version]/[상태]</td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("CD_TP_VERSION")%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=UseTpStr%>" style="width:80" class=adg1 readonly>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw><input type="text" value="<%=headerRow.getAttribute("USER_NAME")%>" style="width:100" class=adg1 readonly></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0083",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=headerRow.getAttribute("OWNER_SHIP_TP_MEANING")%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=headerRow.getAttribute("OP_TP_MEANING")%>" style="width:50" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0010",null,locale)%></td>
                <td class=tbllw><input type="text" value="<%=(String)headerRow.getAttribute("CREATION_TIMESTAMP_STR")%>" style="width:120" class=adg1 readonly></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr height="20">
                <td>
  <select name="CategoryGroupId" class="adf">
    <option value="%"><%=PosContext.getResourceMessage("GMResource","gm.label.0268",null,locale)%></option><%
    rowset = ctx!=null ? (PosRowSet)ctx.get("CodeCategoryVOResult") : null;
    if(rowset!=null){
        String selected = null;
        while(rowset.hasNext()){
            PosRow row = rowset.next();
            selected = sCategoryGroupId!=null && sCategoryGroupId.equals(row.getAttribute("CATEGORY_GROUP_ID").toString()) ? " selected":"";
%>
    <option value="<%=row.getAttribute("CATEGORY_GROUP_ID").toString()%>"<%=selected%>>[<%=(String)row.getAttribute("CATEGORY_GROUP_NM")%>]<%=(String)row.getAttribute("CATEGORY_GROUP_EXPLAIN")%></option><%
        }
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchAttribute" class="adf">
    <option value="CD_V" <%=                "CD_V".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0054",null,locale)%></option>
    <option value="CD_V_MEANING" <%="CD_V_MEANING".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign="top">
            <table id=code_data width="980" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr class="tbldb" height="18">
                <td width="30" rowspan="2">NO</td>
                <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
                <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0040",null,locale)%></td>
                <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0167",null,locale)%></td>
                <td width="50" rowspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0062",null,locale)%></td>
              </tr>
              <tr class="tbllb" height="18">
                <td width="150"><%=PosContext.getResourceMessage("GMResource","gm.label.0054",null,locale)%></td>
                <td width="250"><%=PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)%></td>
                <td width="150"><%=PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)%></td>
                <td width="200"><%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></td>
                <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0147",null,locale)%></td>
                <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0138",null,locale)%></td>
              </tr><%
    rowset = ctx!=null ? (PosRowSet)ctx.get("CodeValueVOResult") : null;
    int rowCnt = 0;
    if(rowset!=null){
        while(rowset.hasNext()){
            PosRow row = rowset.next();
%>
              <tr index=<%=rowCnt%> class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> height=18 onmouseover=in_ch(0,this,code_data) onmouseout=in_ch(1,this,code_data)>
                <td><%=(rowCnt+1)%></td>
                <td><%=row.getAttribute("MOD_CD_V")==null?"&nbsp;":row.getAttribute("MOD_CD_V")%></td>
                <td align="left"><%=row.getAttribute("CD_V_MEANING")==null?"&nbsp;":row.getAttribute("CD_V_MEANING")%></td>
                <td><%=row.getAttribute("CATEGORY_GROUP_NM")==null?"&nbsp;":row.getAttribute("CATEGORY_GROUP_NM")%></td>
                <td align="left"><%=row.getAttribute("CATEGORY_GROUP_EXPLAIN")==null?"&nbsp;":row.getAttribute("CATEGORY_GROUP_EXPLAIN")%></td>
                <td><%=row.getAttribute("RG_MIN_V")==null?"&nbsp;":row.getAttribute("RG_MIN_V")%></td>
                <td><%=row.getAttribute("RG_MAX_V")==null?"&nbsp;":row.getAttribute("RG_MAX_V")%></td>
                <td><%=row.getAttribute("CD_V_INQUIRY_SEQ")==null?"&nbsp;":row.getAttribute("CD_V_INQUIRY_SEQ")%></td>
              </tr><%
            rowCnt++;
        }
    }
    rowset.reset();
    for(; rowCnt<20; rowCnt++){
%>
              <tr index=<%=rowCnt%> class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> height=18>
                <td>&nbsp</td>
                <td>&nbsp</td>
                <td>&nbsp</td>
                <td>&nbsp</td>
                <td>&nbsp</td>
                <td>&nbsp</td>
                <td>&nbsp</td>
                <td>&nbsp</td>
              </tr><%
    }
%>
            </table>
            <div align="center">
            <posui:showPageSet infoName="CodeValueVOResult" formName="document.forms[0]" curPageName="curPage"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
      </form>
<form name="form_export" method="post" action="m000201050.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000201050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="CdTpId" value="<%=headerRow.getAttribute("CD_TP_ID")%>">
<input type="hidden" name="CdTp" value="<%=headerRow.getAttribute("CD_TP")%>">
<input type="hidden" name="CdTpMeaning" value="<%=headerRow.getAttribute("CD_TP_MEANING")%>">
</form>
<form name="form_layout" method="post" action="m000201010.do"><!-- Layout -->
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="layout" value="10"><!-- event -->
<input type="hidden" name="CdTpId" value="<%=sCdTpId%>">
</form>
    </td>
  </tr>
</table>
</body>
</html>