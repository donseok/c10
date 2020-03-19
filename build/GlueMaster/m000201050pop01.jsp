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
 * @FileName      : 마스타코드 목록 >> 마스타코드 수정 >> 마스타코드 카테고리 등록 및 수정 >> 마스타코드 카테고리 목록 PopUp화면
 * Open Issues    :
 * Change history 
 * @2005-04-15 김연기 1.0 최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.035",null,locale)%></title>
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
    document.forms[0].CategoryGroupNm.value=upperCase(document.forms[0].CategoryGroupNm.value);
    document.forms[0].curPageNum.value="1";//showPageSet tag.
    document.forms[0].submit();
}
function goSelect(){
    var maxIndex = document.forms[0].Category_rdo.length;
    if(maxIndex>1){
        var checkIndex=-1;
        for(var i=0;i<maxIndex;i++){
            if( document.forms[0].Category_rdo[i].checked == true){
                checkIndex= i;
            }
        }
        if(checkIndex==-1){
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
            return;
        }
        opener.<%=request.getParameter("LocCategoryGroupNm")%>.value      = document.forms[0].CATEGORY_GROUP_NM[checkIndex].value;
        opener.<%=request.getParameter("LocCategoryGroupExplain")%>.value = document.forms[0].CATEGORY_GROUP_EXPLAIN[checkIndex].value;
        opener.<%=request.getParameter("LocCategoryGroupId")%>.value      = document.forms[0].CategoryGroupId[checkIndex].value;
    }else{
        opener.<%=request.getParameter("LocCategoryGroupNm")%>.value      = document.forms[0].CATEGORY_GROUP_NM.value;
        opener.<%=request.getParameter("LocCategoryGroupExplain")%>.value = document.forms[0].CATEGORY_GROUP_EXPLAIN.value;
        opener.<%=request.getParameter("LocCategoryGroupId")%>.value      = document.forms[0].CategoryGroupId.value;
    }
    self.close();
    return;
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="480" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_category" method="post" action="m000201050.do">
<input type="hidden" name="ServiceName" value="m000201050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="pop01" value="category"><!-- event -->
<input type="hidden" name="CdTp" value="<%=request.getParameter("CdTp")%>">
<input type="hidden" name="LocCategoryGroupNm" value="<%=request.getParameter("LocCategoryGroupNm")%>">
<input type="hidden" name="LocCategoryGroupExplain" value="<%=request.getParameter("LocCategoryGroupExplain")%>">
<input type="hidden" name="LocCategoryGroupId" value="<%=request.getParameter("LocCategoryGroupId")%>">
      <table width="460" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.035",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=0 cellspacing=0 cellpadding=0>
              <tr height="18">
                <td align="left">
  <img src="img/gm0008img.gif" border="0"> <b><%=PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)%></b>
  <input type="text" name="CategoryGroupNm" value="<%=request.getParameter("CategoryGroupNm")==null?"":request.getParameter("CategoryGroupNm")%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onClick="goSelect()" style="cursor:pointer"><!-- confirm -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height=18>
          <td align="left" valign=top>
  <table id="category" width="450" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td>chk</td>
      <td width="160"><%=PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)%></td>
      <td width="250"><%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></td>
    </tr><%
    PosRowSet rowset=(PosRowSet)ctx.get("CategoryGrVOResult");
    int rowCnt = 0;
    if(rowset!=null && rowset.hasNext()){
        while(rowset.hasNext()){
            PosRow row = rowset.next();
%>
    <tr index=<%=rowCnt%> class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> height=20>
      <td><input type="radio" name="Category_rdo" value="<%=rowCnt%>"><input type="hidden" name=CategoryGroupId value='<%=row.getAttribute("CATEGORY_GROUP_ID")%>'></td>
      <td><input type="text" name="CATEGORY_GROUP_NM" value="<%=row.getAttribute("CATEGORY_GROUP_NM")%>" class=adb1 style=width:150 readonly></td>
      <td><input type="text" name="CATEGORY_GROUP_EXPLAIN" value="<%=row.getAttribute("CATEGORY_GROUP_EXPLAIN")%>" class=adb1 style=width:240 readonly></td>
    </tr><%
            rowCnt++;
        }
    }
    for(int i=rowCnt; i<10; i++){
%>
    <tr index=<%=rowCnt%> class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> height=20>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr><%
    }
%>
  </table>
  <div align="center">
  <posui:showPageSet infoName="CategoryGrVOResult" formName="document.forms[0]" curPageName="curPageNum"/>
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