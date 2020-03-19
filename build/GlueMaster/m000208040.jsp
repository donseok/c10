<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : m000208040.jsp, 표준항목 생성 유틸리티
 * Open Issues    :
 * Change history 
 * @2008-04-02 임병태 1.0 최초생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String sMsg = ctx.get("msg")== null?"":((String[])ctx.get("msg"))[0];
    String termsText = ctx.get("TERMS")==null?"":ctx.get("TERMS").toString();
    String termsText2 = ctx.get("TERMS2")==null?"":ctx.get("TERMS2").toString();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.091",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
//표준항목 변환
function go_regist(){
    if(Trim(document.forms[0].TERMS.value)==""){
        alert('변환항목을 입력하세요');
        return;
    }
    if(confirm('표준항목 조회 결과 확인')){
        document.forms[0].action=document.forms[0].action+"?regist.x=10";
        document.forms[0].submit();
    }
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="540" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_std_help" method="post" action="m000208040.do">
<input type="hidden" name="ServiceName" value="m000208040-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="msg" value="<%=sMsg%>"/>
      <table width="520" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.091",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=25>
                <td class=tbldb width="112"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0258",null,locale)%></b></td>
                <td>표준용어 입력항목에 ※ 문자는 사용금지</td>
              </tr>
              <tr height=25>
                <td class=tbldb><b><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></b></td>
                <td><input type="text" name=TERMS value="<%=termsText%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
              <tr height=25>
                <td class=tbldb><b><%=PosContext.getResourceMessage("GMResource","gm.label.0257",null,locale)%></b></td>
                <td><input type="text" name=TERMS2 value="<%=termsText2%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' size="63"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td height=40 valign=bottom align=center>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onclick="go_regist()" style="cursor:pointer"><!-- confirm -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.cancel",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- cancel -->
          </td>
        </tr>
        <tr>
          <td>
            <posglobalui:showTable infoName="resultkey" tableName="WordList"
              headerClasses="tbldb"
              headerValues="gm.label.0198|gm.label.0254|gm.label.0020"
              height="20"
              trClasses="tblcw|tblcg"
              tdClasses="null|null|null"
              columnNames="TermsName|EngFullName|EngId" 
              columnWidths="200|200|120" 
              displayTypes="text|text|text"
              attributes ="TERMS_NAME|ENG_FULL_NAME|ENG_ID" 
              displayFormats="null|null|null"
              defaultRowCnt="10"
            />
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
</body>
<script language="javascript">
  if(document.forms[0].msg.value!="")
  {
    alert(document.forms[0].msg.value);
  }
</script>
</html>