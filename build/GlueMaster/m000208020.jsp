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
 * @FileName      : 표준용어 신청현황 >> 표준용어 승인관리
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

    String sTERMS_NAME=request.getParameter("TERMS_NAME")== null?"": request.getParameter("TERMS_NAME").toString();
    String sENG_FULL_NAME=request.getParameter("ENG_FULL_NAME")== null?"": request.getParameter("ENG_FULL_NAME").toString();
    //메세지 가져옴.
    String sMsg = request.getParameter("msg")== null?"":request.getParameter("msg");

    PosRowSet rowset = (PosRowSet)ctx.get("RetTermsApplyResults");
    PosRow row = rowset.next();
    String ProgressSts = row.getAttribute("PROGRESS_STS")== null?"": row.getAttribute("PROGRESS_STS").toString();
    String TermsSection = row.getAttribute("TERMS_SECTION")==null||!termSectionMap.containsKey((String)row.getAttribute("TERMS_SECTION"))?"&nbsp":termSectionMap.get((String)row.getAttribute("TERMS_SECTION"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.008",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
/* 표준용어 등록 승인 */
function go_sign(){
    if(Trim(document.forms[0].ENG_ID.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0044",null,locale)%>');//영문ID를 입력하여 주십시요
        return false;
    }
    if(document.forms[0].STS[0].checked==false&&document.forms[0].STS[1].checked==false&&document.forms[0].STS[2].checked==false){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0009",null,locale)%>');
        return false;
    }

    var ans=confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>');//저장하시겠습니까?
    if(ans){
        if(document.forms[0].STS[0].checked==true){
            document.forms[0].PROGRESS_STS.value=2;
        }
        if(document.forms[0].STS[1].checked==true){
            document.forms[0].PROGRESS_STS.value=4;
        }
        if(document.forms[0].STS[2].checked==true){
            document.forms[0].PROGRESS_STS.value=3;
        }
        document.forms[0].msg.value='등록되었습니다';
        document.forms[0].action=document.forms[0].action+"?sign=10";
        document.forms[0].target="_top";
        document.forms[0].submit(); 
    }else{
        return false;
    }
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="430" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_word_sign" method="post" action="m000208020.do">
<input type="hidden" name="ServiceName" value="m000208020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="msg" value="<%=sMsg%>">
<input type="hidden" name="TERMS_NAME" value="<%=sTERMS_NAME%>">
<input type="hidden" name="ENG_FULL_NAME" value="<%=sENG_FULL_NAME%>">
<input type="hidden" name="PROGRESS_STS">
      <table width="410" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.008",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.label.0181",null,locale)%></div>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
                <td width="105">&nbsp;<%=row.getAttribute("SYS_TP")==null?"":row.getAttribute("SYS_TP").toString()%></td>
                <td width="65" class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
                <td width="105">&nbsp;<%=row.getAttribute("CHAIN_CODE")==null?"":row.getAttribute("CHAIN_CODE").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("TERMS_NAME")==null?"":row.getAttribute("TERMS_NAME").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0254",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("ENG_FULL_NAME")==null?"":row.getAttribute("ENG_FULL_NAME").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0052",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("CHINESE_CHAR")==null?"":row.getAttribute("CHINESE_CHAR").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></td>
                <td colspan=3>&nbsp;<%=TermsSection%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0206",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("SYNONYMOUS_1")==null?"":row.getAttribute("SYNONYMOUS_1").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0207",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("SYNONYMOUS_2")==null?"":row.getAttribute("SYNONYMOUS_2").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0207",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("SYNONYMOUS_3")==null?"":row.getAttribute("SYNONYMOUS_3").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0022",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("TERMS_DESCRIPT")==null?"":row.getAttribute("TERMS_DESCRIPT").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("SUBC_NM")==null?"":row.getAttribute("SUBC_NM").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></td>
                <td colspan=3>&nbsp;<%=row.getAttribute("REQUEST_DATE")==null?"":row.getAttribute("REQUEST_DATE").toString()%></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></td>
                <td colspan=3>&nbsp;<input type="text" name="ENG_ID" size="38" value="<%=row.getAttribute("ENG_ID")==null?"":row.getAttribute("ENG_ID").toString()%>" class=adb1></td>
              </tr>
              <tr height="27">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0180",null,locale)%></td>
                <td colspan=3>&nbsp;<textarea rows="5" name="INVEST_RESULT" cols="40" class=adb1><%=row.getAttribute("INVEST_RESULT")==null?"":row.getAttribute("INVEST_RESULT").toString()%></textarea></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td height=30 valign=bottom align=center><b>
            <input type="radio" name="STS" value="2" <%=("2".equals(ProgressSts)==true?"checked":"")%>><%=progressStsMap.get("2")%>&nbsp;
            <input type="radio" name="STS" value="4" <%=("4".equals(ProgressSts)==true?"checked":"")%>><%=progressStsMap.get("4")%>&nbsp;
            <input type="radio" name="STS" value="3" <%=("3".equals(ProgressSts)==true?"checked":"")%>><%=progressStsMap.get("3")%></b>
          </td>
        </tr>
        <tr>
          <td height=40 valign=bottom align=center><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onclick="go_sign()" style="cursor:pointer"><!-- confirm --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.cancel",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- cancel -->
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
</body>
<script type="text/javascript">
  if(document.forms[0].msg.value!="")
  {
      alert(document.forms[0].msg.value);
  }
</script>
</html>