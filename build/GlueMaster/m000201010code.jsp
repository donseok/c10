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
 * @FileName      : 업무기준 목록 >> 업무기준 내용상세(일반) >> 업무기준-코드조회
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 레이아웃 수정 >> 업무기준 데이터 수정(일반) >> 업무기준-코드조회
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 수정(일반) >> 업무기준-코드조회
 * Open Issues    :
 * Change history 
 * @2008-03-20 류진영 1.0 최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String sCdTpId          = request.getParameter("CdTpId")== null?"":request.getParameter("CdTpId");
    String sCategoryGroupId = request.getParameter("CategoryGroupId")== null?"%":request.getParameter("CategoryGroupId");
    String sSearchAttribute = request.getParameter("SearchAttribute")== null?"CD_V":request.getParameter("SearchAttribute");
    String sSearchWord      = request.getParameter("SearchWord")== null?"":request.getParameter("SearchWord");
    String sType            = request.getParameter("Type")== null?"":request.getParameter("Type");
    String sFiledName       = request.getParameter("FiledName")== null?"":request.getParameter("FiledName");
    String sIndex           = request.getParameter("Index")== null?"":request.getParameter("Index");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.071",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
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
<% if("INSERT".equals(sType)){ %>
function returnCtTp() {
    var chkCnt = 0;
    if( document.forms[0].rdo_CdV.length > 1)  {
      for( var i=0; i < document.forms[0].rdo_CdV.length ; i ++) {
        if(document.forms[0].rdo_CdV[i].checked == true) {
          opener.<%=sFiledName%>.value = document.forms[0].ModCdV[i].value;
          self.close();
          return;
        }
      }
    } else {
      if(document.forms[0].rdo_CdV.checked== true) {
        opener.<%=sFiledName%>.value = document.forms[0].ModCdV.value;
        self.close();
        return;
      }
    }
    if(chkCnt == 0){
      alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    }
}
<% } %>
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="760" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_code" method="post" action="m000201010.do">
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="codeRef" value="10"><!-- event -->
<input type="hidden" name="CdTpId" value="<%=sCdTpId%>">
<input type="hidden" name="Type" value="<%=sType%>">
<input type="hidden" name="FiledName" value="<%=sFiledName%>">
<input type="hidden" name="Index" value="<%=sIndex%>">
      <table width="740" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.071",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left" height="18">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr height="18">
                <td align="left">
  <select name="CategoryGroupId" class="adf">
    <option value="%" selected>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></option><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("CodeCategoryVOResult") : null;
    if(rowSet!=null){
        PosRow row = null;
        String selected = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
            selected = sCategoryGroupId.equals(row.getAttribute("CATEGORY_GROUP_ID").toString()) ? " selected":"";
%>
    <option value="<%=row.getAttribute("CATEGORY_GROUP_ID").toString()%>"<%=selected%>><%=(String)row.getAttribute("CATEGORY_GROUP_EXPLAIN")%></option><%
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
                <td align="right"><%

    if("INSERT".equals(sType)){
        // 입력화면에서 호출했을경우
%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onClick="returnCtTp()" style="cursor:pointer"><!-- input -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr align="left" height=18>
          <td>
  <table id=mainTable width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td width="30">chk</td>
      <td width="30"><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
      <td width="140"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td width="330"><%=PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></td>
    </tr><%
        rowSet = ctx!=null ? (PosRowSet)ctx.get("CodeValueVOResult") : null;
        int rowCnt = 0;
        if(rowSet!=null){
            PosRow row = null;
            while(rowSet.hasNext()){
                row = rowSet.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><input type="radio" name="rdo_CdV" value="<%=rowCnt%>"></td>
      <td><%=rowCnt+1%></td>
      <td><%=row.getAttribute("MOD_CD_V")==null?"&nbsp;":(String)row.getAttribute("MOD_CD_V")%><input type="hidden" name="ModCdV" value="<%=row.getAttribute("MOD_CD_V")==null?"":(String)row.getAttribute("MOD_CD_V")%>"></td>
      <td align="left"><%=row.getAttribute("CD_V_MEANING")==null?"&nbsp;":(String)row.getAttribute("CD_V_MEANING")%></td>
      <td align="left"><%=row.getAttribute("CATEGORY_GROUP_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("CATEGORY_GROUP_EXPLAIN")%></td>
    </tr><%
                rowCnt++;
            }
        }
    }else{
        // 조회화면에서 호출했을경우
%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr><%
        if("VIEW".equals(sType) && request.getParameter("information_desc")!=null ){
              rowSet = (PosRowSet)ctx.get("m000202000.TbM00Codes020VO.selectByPK");
              PosRow row = rowSet.next();
%>
              <tr>
                <td rowspan=2 align=left>
                  ※ [<b><%=request.getParameter("information_desc")%></b>] >> [<b><%=row.getAttribute("CD_TP_MEANING")%></b>]
                  <input type="hidden" name="information_desc" value='<%= request.getParameter("information_desc") %>'>
                </td>
              </tr><%
        }
%>
            </table>
          </td>
        </tr>
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr align="left" height=18>
          <td>
  <table id=mainTable width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td width="30"><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
      <td width="170"><%=PosContext.getResourceMessage("GMResource","gm.label.0053",null,locale)%></td>
      <td width="330"><%=PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></td>
    </tr><%

        rowSet = ctx!=null ? (PosRowSet)ctx.get("CodeValueVOResult") : null;
        int rowCnt = 0;
        if(rowSet!=null){
            PosRow row = null;
            while(rowSet.hasNext()){
                row = rowSet.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><%=rowCnt+1%></td>
      <td><%=row.getAttribute("MOD_CD_V")==null?"&nbsp;":(String)row.getAttribute("MOD_CD_V")%><input type="hidden" name="ModCdV" value="<%=row.getAttribute("MOD_CD_V")==null?"":(String)row.getAttribute("MOD_CD_V")%>"></td>
      <td align="left"><%=row.getAttribute("CD_V_MEANING")==null?"&nbsp;":(String)row.getAttribute("CD_V_MEANING")%></td>
      <td align="left"><%=row.getAttribute("CATEGORY_GROUP_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("CATEGORY_GROUP_EXPLAIN")%></td>
    </tr><%
                rowCnt++;
            }
        }
    }
%>
  </table>
            <div align="center">
            <posui:showPageSet infoName="CodeValueVOResult" formName="document.forms[0]"/>
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