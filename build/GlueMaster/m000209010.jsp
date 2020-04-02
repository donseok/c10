<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
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
 * @FileName      : 표준항목 신청현황
 * Open Issues    :
 * Change history
 * @2008-04-02 서정범 1.0 최초생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosSecurityUtil.checkPageID(request.getParameter("pageID"));//"m000209010"
    PosUserIF user = ctx==null ? null : (PosUserIF)ctx.getSessionUserData(PosSecurityConstants.USER);
    String UserEmpNo = user==null ? null : user.getUserID();
    boolean isAdmin = user==null ? null : PosMenu.getCurPage().isPermitAction("sign");

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List progressStsList = (List) ctx.get("_SYS_F_PROGRESS_STS");
    HashMap<String, String> progressStsMap = new HashMap<String, String>();
    for (int i = 0, iz = progressStsList.size(); i < iz; i++) {
        Object[] value = (Object[]) progressStsList.get(i);
        progressStsMap.put((String)value[0], (String)value[1]);
    }

    String curPage = request.getParameter("curPageNum")== null?"1":request.getParameter("curPageNum");
    String sSearchAttribute=request.getParameter("SearchAttribute")== null?"": request.getParameter("SearchAttribute");
    String sSearchWord=request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.010",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
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
//표준항목 승인관리
function go_open_sign(index){
    var actionStr = document.form_std_data.action;
    showPopup("","m000209010_sign",440,620,'1',0,0,1,1,1,0,0);
    document.form_std_data.action = document.form_std_data.action+"?admin=10&isAdmin=<%=isAdmin%>";
    document.form_std_data.DATA_ITEM_NAME.value=document.forms[0].DATA_ITEM_NAME2[index].value;
    document.form_std_data.target="m000209010_sign";
    document.form_std_data.submit();
    document.form_std_data.action = actionStr;
}
//표준항목 등록의뢰
function go_open_regist(){
    var actionStr = document.form_std_data.action;
    document.form_std_data.action = document.form_std_data.action+"?user=10&isAdmin=<%=isAdmin%>";
    showPopup("","m000209010_request",550,625,'1',0,0,1,1,1,0,0);
    document.form_std_data.target="m000209010_request";
    document.form_std_data.submit();
    document.form_std_data.action = actionStr;
}
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.010",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_std" method="post" action="m000209010.do">
<input type="hidden" name="ServiceName" value="m000209010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align="left">
  <select name="SearchAttribute" class="adf">
    <option value="ATTR_KOR" <%="ATTR_KOR".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></option>
    <option value="ATTR_APP" <%="ATTR_APP".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="go_open_regist()" style="cursor:pointer"><!-- register -->
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
          <td valign=top align="left" height="18">
  <table id="mainTable" width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td>no.<!--gm.label.0155--></td>
      <td width="65"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="290"><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></td>
      <td width="90"><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></td>
      <td width="95"><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0027",null,locale)%></td>
      <td width="325"><%=PosContext.getResourceMessage("GMResource","gm.label.0180",null,locale)%></td>
    </tr><%
    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("AttrsApplyListSearchResults") : null;
    int rowCnt = 0;
    if( rowset!=null ){
        PosRow row = null;
        if(isAdmin){
            while(rowset.hasNext()){
                row = rowset.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><%=(rowCnt+1) + (Integer.parseInt(curPage)-1)*20%></td>
      <td><%=row.getAttribute("CHAIN_CODE")==null?"&nbsp;":(String)row.getAttribute("CHAIN_CODE")%></td>
      <td><a href="javascript:" onClick="go_open_sign('<%=rowCnt%>')"><%=row.getAttribute("DATA_ITEM_NAME")==null?"&nbsp;":(String)row.getAttribute("DATA_ITEM_NAME")%></a><input type="hidden" name="DATA_ITEM_NAME2" value="<%=row.getAttribute("DATA_ITEM_NAME")==null?"":(String)row.getAttribute("DATA_ITEM_NAME")%>"></td>
      <td><%=row.getAttribute("SUBC_NM")==null?"&nbsp;":(String)row.getAttribute("SUBC_NM")%></td>
      <td><%=row.getAttribute("REQUEST_DATE")==null?"&nbsp;":(String)row.getAttribute("REQUEST_DATE")%></td>
      <td><%=row.getAttribute("PROGRESS_STS")==null||!progressStsMap.containsKey((String)row.getAttribute("PROGRESS_STS"))?"&nbsp;":progressStsMap.get((String)row.getAttribute("PROGRESS_STS"))%></td>
      <td><%=row.getAttribute("INVEST_RESULT")==null?"&nbsp;":(String)row.getAttribute("INVEST_RESULT")%></td>
    </tr><%
                rowCnt++;
            }
        }else{
            while(rowset.hasNext()){
                row = rowset.next();
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><%=(rowCnt+1) + (Integer.parseInt(curPage)-1)*20%></td>
      <td><%=row.getAttribute("CHAIN_CODE")==null?"&nbsp;":(String)row.getAttribute("CHAIN_CODE")%></td>
      <td><%=row.getAttribute("DATA_ITEM_NAME")==null?"&nbsp;":(String)row.getAttribute("DATA_ITEM_NAME")%></td>
      <td><%=row.getAttribute("SUBC_NM")==null?"&nbsp;":(String)row.getAttribute("SUBC_NM")%></td>
      <td><%=row.getAttribute("REQUEST_DATE")==null?"&nbsp;":(String)row.getAttribute("REQUEST_DATE")%></td>
      <td><%=row.getAttribute("PROGRESS_STS")==null||!progressStsMap.containsKey((String)row.getAttribute("PROGRESS_STS"))?"&nbsp;":progressStsMap.get((String)row.getAttribute("PROGRESS_STS"))%></td>
      <td><%=row.getAttribute("INVEST_RESULT")==null?"&nbsp;":(String)row.getAttribute("INVEST_RESULT")%></td>
    </tr><%
                rowCnt++;
            }
        }
        rowset.reset();
    }
    for(; rowCnt<20; rowCnt++){
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20">
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
            <posui:showPageSet infoName="AttrsApplyListSearchResults" formName="document.forms[0]" curPageName="curPageNum"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
      </form>
<form name="form_std_data" method="post" action="m000209020.do">
<input type="hidden" name="ServiceName" value="m000209020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="DATA_ITEM_NAME">
</form>
    </td>
  </tr>
</table>
</body>
</html>