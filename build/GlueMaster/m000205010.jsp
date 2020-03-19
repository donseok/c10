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
 * @FileName      : 화면메세지관리 목록
 * Open Issues    :
 * Change history 
 * @2008-03-13 김정희 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 LANGUAGE_CODE,_SYS_R_APPLICATION_ID 출력방식 변경 
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
        PosSecurityUtil.checkPageID("m000205010");
        isAdmin = PosMenu.getCurPage().isPermitAction("enter");//enter,modify,import
    }

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");
    List ApplicationIdList = (List) ctx.get("_SYS_R_APPLICATION_ID");
    HashMap<String, String> ApplicationIdMap = new HashMap<String, String>();
    for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
        String[] value = (String[]) ApplicationIdList.get(i);
        ApplicationIdMap.put(value[0], value[1]);
    }

    String LanguageCode = request.getParameter("SearchLanguageCode")== null?"%": request.getParameter("SearchLanguageCode");
    String ApplicationId = request.getParameter("SearchApplicationId")== null?"%": request.getParameter("SearchApplicationId");
    String MessageTp    = request.getParameter("SearchMessageTp")== null?"%": request.getParameter("SearchMessageTp");
    String Attribute    = request.getParameter("SearchAttribute")== null?"MESSAGE_EXPLAIN": request.getParameter("SearchAttribute");
    String sSearchWord  = request.getParameter("SearchWord")== null?"": request.getParameter("SearchWord");
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("AppMsgListVOResult") : null;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.013",null,locale)%></title>
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
//메세지 등록
function go_open_regist(){
    showPopup("","m000205010_add",620,400,'1',0,0,1,1,1,0,0);
    document.form_msg_new.target="m000205010_add";
    document.form_msg_new.submit();
}
/*
 * 메세지 내용 수정
 */
function appMsgModify(){
    document.form_msg_data.Mode.value = "modify";
    if (document.forms[0].AppId.length > 1){
        for(i=0;i<document.forms[0].rdo.length;i++){
            if(document.forms[0].rdo[i].checked==true){
                document.form_msg_data.ApplicationId.value = document.forms[0].AppId[i].value;
                document.form_msg_data.LanguageCode.value = document.forms[0].LangCd[i].value;
                document.form_msg_data.MessageNm.value = document.forms[0].MsgNm[i].value;
                showPopup("","m000205010_modify",620,400,'1',0,0,1,1,1,0,0);
                document.form_msg_data.target="m000205010_modify";
                document.form_msg_data.submit();
                return;
            }
        }
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");
        return;
    }
    document.form_msg_data.ApplicationId.value = document.forms[0].AppId.value;
    document.form_msg_data.LanguageCode.value = document.forms[0].LangCd.value;
    document.form_msg_data.MessageNm.value = document.forms[0].MsgNm.value;
    showPopup("","m000205010_modify",620,400,'1',0,0,1,1,1,0,0);
    document.form_msg_data.target="m000205010_modify";
    document.form_msg_data.submit();
}
/*
 * 메세지 내용 세부 조회
 */
function appMsgDetail(msg_index){
    var actionstr = document.form_msg_data.action;// action 원래대로
    document.form_msg_data.action = document.form_msg_data.action+"?detail=10";
    document.form_msg_data.Mode.value = "detail";
    if (document.forms[0].AppId.length > 1){
        document.form_msg_data.ApplicationId.value = document.forms[0].AppId[msg_index].value;
        document.form_msg_data.LanguageCode.value = document.forms[0].LangCd[msg_index].value;
        document.form_msg_data.MessageNm.value = document.forms[0].MsgNm[msg_index].value;
    }else{
        document.form_msg_data.ApplicationId.value = document.forms[0].AppId.value;
        document.form_msg_data.LanguageCode.value = document.forms[0].LangCd.value;
        document.form_msg_data.MessageNm.value = document.forms[0].MsgNm.value;
    }
    showPopup("","m000205010_detail",620,400,'1',0,0,1,1,1,0,0);
    document.form_msg_data.target="m000205010_detail";
    document.form_msg_data.submit();
    document.form_msg_data.action = actionstr;
}
function goExcelImport(){
    showPopup("","m000205010_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000205010_import";
    document.form_import.submit();
}
function gm_addLanguage(obj){
    if(obj.value=="AddLanguage"){
        if(confirm("대상 언어를 설정하시겠습니까?")){
            showPopup("","m000207110_m000100100",1016,641,'1',0,0,1,1,1,0,0);
            document.form_language.target="m000207110_m000100100";
            document.form_language.submit();
        }
        obj.value="%";
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.013",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_main_msg" method="post" action="m000205010.do">
<input type="hidden" name="ServiceName" value="m000205010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left" height="18">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr height="18">
                <td align="left">
  <select name="SearchLanguageCode" class="adf" onChange="gm_addLanguage(this)">
    <option value="%" <%="%".equals(LanguageCode)?"selected":""%>>√ <%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></option><%
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        String[] value = (String[]) LanguageCodeList.get(i);
%>
    <option value="<%=value[0]%>" <%=value[0].equals(LanguageCode)?"selected":""%>><%=value[1]%></option><%
    }
    if(isAdmin){
%>
    <option value="AddLanguage">Add . . .</option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchApplicationId" class="adf"><!--ApplicationId-->
    <option value="%" <%="%".equals(ApplicationId)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0234",null,locale)%></option><%
    for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
        String[] value = (String[]) ApplicationIdList.get(i);
%>
    <option value="<%=value[0]%>" <%=value[0].equals(ApplicationId)?"selected":""%>><%=value[1]%></option><%
    }
%>
  </select>&nbsp;&nbsp;
  <select name="SearchMessageTp" class="adf">
    <option value="%" <%=            "%".equals(MessageTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0237",null,locale)%></option>
    <option value="Fixed" <%=    "Fixed".equals(MessageTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0100",null,locale)%></option>
    <option value="Changed" <%="Changed".equals(MessageTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0231",null,locale)%></option>
  </select>&nbsp;&nbsp;
  <select name="SearchAttribute" class="adf">
    <option value="MESSAGE_EXPLAIN" <%=            "MESSAGE_EXPLAIN".equals(Attribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0144",null,locale)%></option>
    <option value="MESSAGE_NM" <%=                      "MESSAGE_NM".equals(Attribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0143",null,locale)%></option>
    <option value="APPL_MSG_OWNER_EMP_NO" <%="APPL_MSG_OWNER_EMP_NO".equals(Attribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onClick="go_open_regist()" style="cursor:pointer"><!-- register -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick="appMsgModify(this.parentElement.index)" style="cursor:pointer"><!-- modify -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goExcelImport()" style="cursor:pointer"><!-- import --><% } %>
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
          <td align="left" height="18"><%
if(isAdmin){ %>
  <table id="mainTable" width="980" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td width="30">chk</td>
      <td width="30"><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="180"><%=PosContext.getResourceMessage("GMResource","gm.label.0145",null,locale)%></td>
      <td width="150"><%=PosContext.getResourceMessage("GMResource","gm.label.0143",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="300"><%=PosContext.getResourceMessage("GMResource","gm.label.0142",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0174",null,locale)%></td>
    </tr><%
    int rowCnt = 0;
    if( rowSet!=null ){
        PosRow row = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
            String MessageTpStr = row.getAttribute("MESSAGE_TP")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_TP");
            if("Fixed".equals(MessageTpStr))       MessageTpStr=PosContext.getResourceMessage("GMResource","gm.label.0100",null,locale);
            else if("Changed".equals(MessageTpStr))MessageTpStr=PosContext.getResourceMessage("GMResource","gm.label.0231",null,locale);
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><input type="radio" name="rdo" value="<%=rowCnt%>"></td>
      <td><%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%></td>
      <td><%=ApplicationIdMap.get(row.getAttribute("APPLICATION_ID").toString())%></td>
      <td><%=MessageTpStr%></td>
      <td align="left"><%=row.getAttribute("MESSAGE_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_EXPLAIN")%></td>
      <td><%=row.getAttribute("MESSAGE_NM")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_NM")%></td>
      <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
      <td align="left"><a href="javascript:" onClick="appMsgDetail(<%=rowCnt%>)"><%=row.getAttribute("MSG_CONT")==null?"&nbsp;":(String)row.getAttribute("MSG_CONT")%></a></td>
      <td><%=row.getAttribute("CREATE_DAY")==null?"&nbsp;":(String)row.getAttribute("CREATE_DAY")%></td>
      <input type="hidden" name="MsgNm" value="<%=row.getAttribute("MESSAGE_NM")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_NM")%>">
      <input type="hidden" name="AppId" value="<%=row.getAttribute("APPLICATION_ID")==null?"&nbsp;":row.getAttribute("APPLICATION_ID").toString()%>">
      <input type="hidden" name="LangCd" value="<%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%>">
    </tr><%
            rowCnt++;
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
      <td>&nbsp;</td>
      <td>&nbsp;</td>
  </tr><%
        }
    }
}else{ %>
  <table id="mainTable" width="980" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
    <tr class="tbldb" height="20">
      <td width="30">no.</td>
      <td width="30"><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td width="180"><%=PosContext.getResourceMessage("GMResource","gm.label.0145",null,locale)%></td>
      <td width="150"><%=PosContext.getResourceMessage("GMResource","gm.label.0143",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td width="300"><%=PosContext.getResourceMessage("GMResource","gm.label.0142",null,locale)%></td>
      <td width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0174",null,locale)%></td>
    </tr><%
    int rowCnt = 0;
    if( rowSet!=null ){
        PosRow row = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
            String MessageTpStr = row.getAttribute("MESSAGE_TP")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_TP");
            if("Fixed".equals(MessageTpStr))       MessageTpStr=PosContext.getResourceMessage("GMResource","gm.label.0100",null,locale);
            else if("Changed".equals(MessageTpStr))MessageTpStr=PosContext.getResourceMessage("GMResource","gm.label.0231",null,locale);
%>
    <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
      <td><%=rowCnt+1%></td>
      <td><%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%></td>
      <td><%=ApplicationIdMap.get(row.getAttribute("APPLICATION_ID").toString())%></td>
      <td><%=MessageTpStr%></td>
      <td align="left"><%=row.getAttribute("MESSAGE_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_EXPLAIN")%></td>
      <td><%=row.getAttribute("MESSAGE_NM")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_NM")%></td>
      <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
      <td align="left"><a href="javascript:" onClick="appMsgDetail(<%=rowCnt%>)"><%=row.getAttribute("MSG_CONT")==null?"&nbsp;":(String)row.getAttribute("MSG_CONT")%></a></td>
      <td><%=row.getAttribute("CREATE_DAY")==null?"&nbsp;":(String)row.getAttribute("CREATE_DAY")%></td>
      <input type="hidden" name="MsgNm" value="<%=row.getAttribute("MESSAGE_NM")==null?"&nbsp;":(String)row.getAttribute("MESSAGE_NM")%>">
      <input type="hidden" name="AppId" value="<%=row.getAttribute("APPLICATION_ID")==null?"&nbsp;":row.getAttribute("APPLICATION_ID").toString()%>">
      <input type="hidden" name="LangCd" value="<%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%>">
    </tr><%
            rowCnt++;
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
      <td>&nbsp;</td>
      <td>&nbsp;</td>
  </tr><%
        }
    }
}
if(rowSet!=null) rowSet.reset();
%>
  </table>
            <div align="center">
            <posui:showPageSet infoName="AppMsgListVOResult" formName="document.forms[0]" curPageName="curPage"/>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000205010.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000205010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="LanguageCode" value="<%=LanguageCode%>">
<input type="hidden" name="SearchApplicationId" value="<%=ApplicationId%>">
<input type="hidden" name="SearchMessageTp" value="<%=MessageTp%>">
<input type="hidden" name="SearchAttribute" value="<%=Attribute%>">
<input type="hidden" name="SearchWord" value="<%=sSearchWord%>">
</form>
<form name="form_import" method="post" action="m000205020.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000205020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="1"><!-- event -->
</form>
<form name="form_msg_data" method="post" action="m000205020.do">
<input type="hidden" name="ServiceName" value="m000205020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="ApplicationId">
<input type="hidden" name="LanguageCode">
<input type="hidden" name="MessageNm">
<input type="hidden" name="Mode"><!--등록이냐 수정이냐를 기억하는 Mode파라메터 (조회시 "detail" 등록시 "enter" 수정시 "modify")-->
</form>
<form name="form_msg_new" method="post" action="m000205020.do">
<input type="hidden" name="ServiceName" value="m000205020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="enterpage" value="10"><!-- event -->
<input type="hidden" name="Mode" value="enter">
</form>
<form name="form_language" method="post" action="m000100100.do"><!-- pop02 -->
<input type="hidden" name="ServiceName" value="m000100100-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name=isPageSet value=false>
</form>
    </td>
  </tr>
</table>
</body>
</html>