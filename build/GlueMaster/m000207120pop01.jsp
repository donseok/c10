<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 표준용어 신청현황 >> 표준용어 등록의뢰
 * @FileName      : 표준용어 신청현황 >> 표준용어 승인관리
 * Open Issues    :
 * Change history 
 * @2010-07-01 황유진 1.0 다국어 지원
 * @2012-08-09 황유진 #1.4.2 LANGUAGE_CODE,_SYS_F_PROGRESS_STS 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));
    /*
     * isAdmin == true 이면. 상태 변경가능
     */

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");
    List termSectionList = (List) ctx.get("_SYS_V_TERMS_SECTION");
    HashMap<String, String> termSectionMap = new HashMap<String, String>();
    for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
        Object[] value = (Object[]) termSectionList.get(i);
        termSectionMap.put((String)value[0], (String)value[1]);
    }
    List progressStsList = (List) ctx.get("_SYS_F_PROGRESS_STS");
    HashMap<String, String> progressStsMap = new HashMap<String, String>();
    for (int i = 0, iz = progressStsList.size(); i < iz; i++) {
        Object[] value = (Object[]) progressStsList.get(i);
        progressStsMap.put((String)value[0], (String)value[1]);
    }

    boolean isSign = "sign".equals(request.getParameter("event"));
    PosRowSet rowset = ctx!=null ? (PosRowSet)ctx.get("WordList") : null;
    PosRow tmpRow = rowset!=null ? rowset.next() : null;
    if(tmpRow==null){
        isSign = false;
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><% if(isSign && isAdmin) { %>
<title><%=PosContext.getResourceMessage("GMResource","gm.title.008",null,locale)%></title><% }else{ %>
<title><%=PosContext.getResourceMessage("GMResource","gm.title.009",null,locale)%></title><% } %>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
function gm_find_StdTermsName(){
    document.form_word_data.SearchWord.value=document.forms[0].StdTermsName.value;
    showPopup("","m000207120_pop02",800,641,'1',0,0,1,1,1,0,0);
    document.form_word_data.target="m000207120_pop02";
    document.form_word_data.submit();
}
//표준용어 신청
function gm_go_regist(val){
<%
    // 표준항목 승인관리 화면일 경우
    if(isSign){
%>
    if("4"==document.forms[0].ProgressSts.value){
        if(Trim(document.forms[0].EngId.value)==""){
            alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0044",null,locale)%>');//영문ID를 입력하여 주십시요
            return;
        }
        if(Trim(document.forms[0].StdTermsName.value)==""){
            alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0043",null,locale)%>');//영문 Full Name 을 입력하여 주십시요
            return;
        }
        if(Trim(document.forms[0].EngAbbr.value)==""){
            alert('영문약어를 입력하여 주십시오');
            return;
        }
        if(Trim(document.forms[0].OwnerDept.value)==""){
            alert('담당부서를 입력하여 주십시오');
            return;
        }
        if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>')){//저장하시겠습니까?
            document.forms[0].action=document.forms[0].action+"?regist=10";
            document.forms[0].submit();
        }
    }else
    {
<%
        // 표준항목 승인관리 화면일 경우
        if(isAdmin){
%>
        if(confirm('영문ID, 영문약어, 담당부문은 검토완료시에만 등록됩니다. 저장하시겠습니까?')){
            document.forms[0].action=document.forms[0].action+"?regist=10";
            document.forms[0].submit();
        }
<%
        // 표준항목 등록의뢰 화면일 경우
        }else{
%>
        if(confirm('재 검토의뢰 하시겠습니까?')){
            document.forms[0].action=document.forms[0].action+"?regist=10";
            document.forms[0].submit();
        }
<%
        }
%>
    }
<%
    // 표준항목 등록의뢰 화면일 경우
    }else{
%>
    if(Trim(document.forms[0].TermsName.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0082",null,locale)%>');//표준용어를 입력하여 주십시요
        return;
    }
    if(Trim(document.forms[0].SubcNm.value)==""){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0041",null,locale)%>");//신청자명을 입력하여 주십시요
        return;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0080",null,locale)%>')){//표준 용어 등록 신청을 하시겠습니까?
        document.forms[0].action=document.forms[0].action+"?regist=10";
        document.forms[0].submit();
    }
<%
    }
%>
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="535" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_word_request" method="post" action="m000207120.do">
<input type="hidden" name="ServiceName" value="m000207120-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="SearchTypeLOV" value="TERMS_NAME">
<input type="hidden" name="SearchWord" value="<%=request.getParameter("SearchWord")%>">
<input type="hidden" name="isPageSet" value="false">
<input type="hidden" name="event" value="<%=request.getParameter("event")%>">
      <table width="510" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25><% if(isSign && isAdmin) { %>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.008",null,locale)%></div></td><% }else{ %>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.009",null,locale)%></div></td><% } %>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff><%

    boolean readonly = false;
    if(isSign) {
        String ChainCode = (String)tmpRow.getAttribute("CHAIN_CODE");
        String TermsSection = (String)tmpRow.getAttribute("TERMS_SECTION");
        String LanguageCode = (String)tmpRow.getAttribute("LANGUAGE_CODE");
        String TermsName = (String)tmpRow.getAttribute("TERMS_NAME");
        String StdTermsName = tmpRow.getAttribute("STD_TERMS_NAME")==null?"":(String)tmpRow.getAttribute("STD_TERMS_NAME");
        String EngId = tmpRow.getAttribute("ENG_ID")==null?"":(String)tmpRow.getAttribute("ENG_ID");
        String EngAbbr = tmpRow.getAttribute("ENG_ABBR")==null?"":(String)tmpRow.getAttribute("ENG_ABBR");
        String OwnerDept = tmpRow.getAttribute("OWNER_DEPT")==null?"":(String)tmpRow.getAttribute("OWNER_DEPT");
        String Synonymous1 = tmpRow.getAttribute("SYNONYMOUS_1")==null?"":(String)tmpRow.getAttribute("SYNONYMOUS_1");
        String Synonymous2 = tmpRow.getAttribute("SYNONYMOUS_2")==null?"":(String)tmpRow.getAttribute("SYNONYMOUS_2");
        String Synonymous3 = tmpRow.getAttribute("SYNONYMOUS_3")==null?"":(String)tmpRow.getAttribute("SYNONYMOUS_3");
        String TermsDescript = tmpRow.getAttribute("TERMS_DESCRIPT")==null?"":(String)tmpRow.getAttribute("TERMS_DESCRIPT");
        String SubcNm = tmpRow.getAttribute("SUBC_NM")==null?"":(String)tmpRow.getAttribute("SUBC_NM");
        String RequestDate = tmpRow.getAttribute("REQUEST_DATE_STR")==null?"":(String)tmpRow.getAttribute("REQUEST_DATE_STR");
        String InvestResult = tmpRow.getAttribute("INVEST_RESULT")==null?"":(String)tmpRow.getAttribute("INVEST_RESULT");
        String ProgressSts = tmpRow.getAttribute("PROGRESS_STS")==null?"":(String)tmpRow.getAttribute("PROGRESS_STS");
        readonly = "4".equals(ProgressSts);// 검토완료 이면 검토결과만 수정가능
%>
              <tr height="27">
                <td class=tbldb width=90><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td><%
        if(readonly){
%>
                <td>&nbsp;<%
            rowset = ctx!=null ? (PosRowSet)ctx.get("ChainCodeList") : null;
            if(rowset!=null){
                PosRow row = null;
                while(rowset.hasNext()){
                    row = rowset.next();
                    if(ChainCode!=null && ChainCode.equals((String)row.getAttribute("CHAIN_CODE"))){
    %><%=(String)row.getAttribute("CHAIN_CODE_NM")%><%
                        break;
                    }
                }
            }
%><input type="hidden" name="ChainCode" value="<%=ChainCode%>"></td><%
        }else{
%>
                <td>&nbsp;
                  <select name="ChainCode" class="adf"><%
            rowset = ctx!=null ? (PosRowSet)ctx.get("ChainCodeList") : null;
            if(rowset!=null){
                PosRow row = null;
                String selected = null;
                while(rowset.hasNext()){
                    row = rowset.next();
                    selected = ChainCode!=null && ChainCode.equals((String)row.getAttribute("CHAIN_CODE")) ? " selected":"";
    %>
                        <option value="<%=(String)row.getAttribute("CHAIN_CODE")%>"<%=selected%>><%=(String)row.getAttribute("CHAIN_CODE_NM")%></option><%
                }
            }
%>
                  </select>
                </td><%
        }
%>
                <td class=tbldb width=90><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></td><%
        if(readonly){


%>
                <td>&nbsp;<%=TermsSection==null||!termSectionMap.containsKey(TermsSection)?"":termSectionMap.get(TermsSection)%><input type="hidden" name="TermsSection" value="<%=TermsSection%>"></td><%
        }else{ 
%>
                <td>&nbsp; 
                  <select name="TermsSection" class="adf"><%
            for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
                Object[] value = (Object[]) termSectionList.get(i);
%>
                    <option value="<%=value[0]%>" <%=value[0].equals(TermsSection)?"selected":""%>>[<%=value[0]%>] <%=value[1]%></option><%
    }
%>
                  </select>
                </td><%
        }
%>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></td>
                <td>&nbsp;<%=TermsName%><input type="hidden" name="TermsName" value="<%=TermsName%>"></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
                <td>&nbsp;<%
        for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
            String[] value = (String[]) LanguageCodeList.get(i);
            if(value[0].equals(LanguageCode)){
%><%=value[1]%><%
                i=iz;
            }
        }
%><input type="hidden" name="LanguageCode" value="<%=LanguageCode%>"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0205",null,locale)%></td>
                <td colspan=3>
                  &nbsp;<% if(readonly){%>
                  <input type="text" name="Synonymous1" value="<%=Synonymous1%>" class=adg1 readonly>
                  <input type="text" name="Synonymous2" value="<%=Synonymous2%>" class=adg1 readonly>
                  <input type="text" name="Synonymous3" value="<%=Synonymous3%>" class=adg1 readonly><%}else{%>
                  <input type="text" name="Synonymous1" value="<%=Synonymous1%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>
                  <input type="text" name="Synonymous2" value="<%=Synonymous2%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>
                  <input type="text" name="Synonymous3" value="<%=Synonymous3%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'><%}%>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0022",null,locale)%></td>
                <td colspan=3>&nbsp;<% if(readonly){%>
                  <textarea name="TermsDescript" rows="3" cols="60" style="width:400;height:55" class=adg1 readonly><%=TermsDescript%></textarea><%}else{%>
                  <textarea name="TermsDescript" rows="3" cols="60" style="width:400;height:55" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'><%=TermsDescript%></textarea><%}%>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></td>
                <td>&nbsp;<input type="text" name="SubcNm" value="<%=SubcNm%>" class=adg1 readonly></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></td>
                <td>&nbsp;<input type="text" name='RequestDate' value="<%=RequestDate%>" class=adg1 readonly></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></td>
                <td>&nbsp;<% if(readonly){%>
                  <input type="text" name="EngId" value="<%=EngId%>" class=adg1 readonly><%}else{%>
                  <input type="text" name="EngId" value="<%=EngId%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'><%}%>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></td><%
        if(readonly){
%>
                <td>&nbsp;<input type="text" name="StdTermsName" value="<%=StdTermsName%>" class=adg1 readonly></td><%
        }else{
%>
                <td>&nbsp;<input type="text" name="StdTermsName" value="<%=StdTermsName%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>&nbsp;<img src="img/gm0003img.gif" onclick="gm_find_StdTermsName()" style="cursor:pointer"></td><%
        }
%>
              </tr>
              <tr height="27">
                <td class=tbldb>영문약어</td>
                <td>&nbsp;<% if(readonly){%>
                  <input type="text" name="EngAbbr" value="<%=EngAbbr%>" class=adg1 readonly><%}else{%>
                  <input type="text" name="EngAbbr" value="<%=EngAbbr%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'><%}%>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0049",null,locale)%></td>
                <td>&nbsp;<% if(readonly){%>
                  <input type="text" name="OwnerDept" value="<%=OwnerDept%>" class=adg1 readonly><%}else{%>
                  <input type="text" name="OwnerDept" value="<%=OwnerDept%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'><%}%>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb>검토의견</td>
                <td colspan=3>&nbsp;<textarea name="InvestResult" rows="5" cols="60" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' style='width:400;height:90'><%=InvestResult%></textarea></td>
              </tr>
            </table>
          </td>
        </tr><% 
        if(!isAdmin){ 
%><input type="hidden" name="ProgressSts" value="1"><% 
        }else if(isAdmin && readonly){ 
%><input type="hidden" name="ProgressSts" value="4"><% 
        }else{
%>
        <tr>
          <td height=30 valign=bottom align=center><input type="hidden" name="ProgressSts" value="<%=ProgressSts%>"><b> 
            <input type="radio" name=dummy value="2" <%=("2".equals(ProgressSts)==true?"checked":"")%> onclick='document.forms[0].ProgressSts.value=this.value;this.checked=true;'><%=progressStsMap.get("2")%>&nbsp;
            <input type="radio" name=dummy value="4" <%=("4".equals(ProgressSts)==true?"checked":"")%> onclick='document.forms[0].ProgressSts.value=this.value;this.checked=true;'><%=progressStsMap.get("4")%>&nbsp;
            <input type="radio" name=dummy value="3" <%=("3".equals(ProgressSts)==true?"checked":"")%> onclick='document.forms[0].ProgressSts.value=this.value;this.checked=true;'><%=progressStsMap.get("3")%></b>
          </td>
        </tr><%

        }
    }else{

%>
              <tr height="27">
                <td class=tbldb width=90><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
                <td>&nbsp;
                  <select name="ChainCode" class="adf"><%
        String ChainCode = request.getParameter("ChainCode");
        rowset = ctx!=null ? (PosRowSet)ctx.get("ChainCodeList") : null;
        if(rowset!=null){
            PosRow row = null;
            String selected = null;
            while(rowset.hasNext()){
                row = rowset.next();
                selected = ChainCode!=null && ChainCode.equals((String)row.getAttribute("CHAIN_CODE")) ? " selected":"";
%>
                    <option value="<%=(String)row.getAttribute("CHAIN_CODE")%>"<%=selected%>><%=(String)row.getAttribute("CHAIN_CODE_NM")%></option><%
            }
        }
%>
                  </select>
                </td>
                <td class=tbldb width=90><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></td>
                <td>&nbsp;
                  <select name="TermsSection" class="adf"><%
            for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
                Object[] value = (Object[]) termSectionList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>] <%=value[1]%></option><%
    }
%> 
                  </select>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
                <td colspan=3>&nbsp;
                  <select name="LanguageCode" class="adf"><%
    String LanguageCode = request.getParameter("LanguageCode");
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        String[] value = (String[]) LanguageCodeList.get(i);
%>
                    <option value="<%=value[0]%>" <%=value[0].equals(LanguageCode)?"selected":""%>><%=value[1]%></option><%
    }
%>
                  </select>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></td>
                <td colspan=3>&nbsp;<input type="text" name="TermsName" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></td>
                <td colspan=3>&nbsp;<input type="text" name="StdTermsName" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>&nbsp;<img src="img/gm0003img.gif" onclick="gm_find_StdTermsName()" style="cursor:pointer"></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0205",null,locale)%></td>
                <td colspan=3>
                  &nbsp;<input type="text" name="Synonymous1" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>
                  <input type="text" name="Synonymous2" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>
                  <input type="text" name="Synonymous3" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>
                </td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0022",null,locale)%></td>
                <td colspan=3>&nbsp;<textarea name="TermsDescript" rows="10" cols="60" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' style="width:400;height:90"></textarea></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></td>
                <td>&nbsp;<input type="text" name="SubcNm" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></td>
                <td>&nbsp;<input type="text" name="RequestDate" value="<%=PosMasterUtility.getCurTime("yyyy-MM-dd")%>" class=adg1 readonly></td>
              </tr>
            </table>
          </td>
        </tr><%
    }
%>
        <tr>
          <td height=40 valign=bottom align=center><% if(!isAdmin && readonly) {}else{%>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onclick="gm_go_regist()" style="cursor:pointer"><!-- confirm --><%}%><% if(readonly){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close --><% }else{ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.cancel",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- cancel --><% } %>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
<form name="form_word_data" method="post" action="m000207120.do"><!-- pop02 -->
<input type="hidden" name="ServiceName" value="m000207120-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="SearchTypeLOV" value="STD_TERMS_NAME">
<input type="hidden" name="SearchWord">
<input type="hidden" name="pop02" value="10"><!-- event -->
</form>
</body>
<script type="text/javascript"><%
    if(ctx!=null && "close".equals((String)ctx.get("result"))){
%>
alert("등록되었습니다.");
window.opener.document.forms[0].submit();
self.close(); <%
    }
%>
</script>
</html>