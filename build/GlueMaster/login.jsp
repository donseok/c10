<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterConstants" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ page import="com.posdata.glue.web.security.PosSecurityConstants" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/><%
/*
 *Change history
 *@LastModifyDate : 20100609
 *@LastModifier   : 황유진
 *@LastVersion    : 1.0
 *    2010-06-09    황유진
 */
    /*
     * LOGOUT 또는 LOGIN화면 재실행시 session invalidate함
     * 동일 Web Application에서 session invalidate 됨
     */
    session.removeAttribute(PosSecurityConstants.USER);
    session.invalidate();
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);
    boolean isStandAlone = "standalone".equalsIgnoreCase(PosContext.getGlueProperty(PosMasterConstants.GLUE_PROP_LOGIN_SOURCE));
    boolean isEncrypt = isStandAlone && "encrypt".equalsIgnoreCase(PosContext.getGlueProperty(PosMasterConstants.GLUE_PROP_STANDALONE_LOGIN));
%>
<head>
<title>Glue Master 사용자 로그인</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<style>
.box {padding:8px 0 5px 5px;height:30px;width:170px;border:1px solid #d6d6d6;}
.btn_pw_reset{ background:url(./img/gm0013img.gif) no-repeat; width:94px; height:19px; font-size:12px; letter-spacing:-1px; cursor:pointer; text-align:center; padding:3px}
</style>
<script language="javascript" type="text/javascript">
<!--
function glue_login(){
  if ( document.forms[0].hidden_id.value == "" ){
    alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0102",null,locale)%>");//Username을 입력하세요
    document.forms[0].hidden_id.focus();
    return;
  }
  document.forms[0].hidden_password.value=document.forms[0].password.value;
  document.forms[0].submit();
}
function executeEnterKey(){
  if( event.keyCode == 13 ) document.forms[0].submit();
}
function pop_up(windowURL) {
        if (windowURL!="") {
                var width = '560';
                var height = '450';
                var ntop = (screen.height) ? (screen.height-height)/2 : 0;
                var nleft = (screen.width) ? (screen.width-width)/2 : 0;
                var _Opts = '';
                _Opts = _Opts + 'height=470px';
                _Opts = _Opts + ',width='+width+"px";
                _Opts = _Opts + ',left='+nleft+"px";
                _Opts = _Opts + ',top='+ntop+"px";
                _Opts = _Opts + ',scrollbars=no';
                _Opts = _Opts + ',status=no';
                _Opts = _Opts + ',toolbar=no';
                _Opts = _Opts + ',menubar=no';
                _Opts = _Opts + ',location=no';
                _Opts = _Opts + ',resizable=yes';
                window.open(windowURL,"",_Opts);
        }
}
-->
</script>
</head>
<body>
<form name="GlueMaster" method="post" action="menu.do"><br><br><br><br><br><br>
  <table width="700" border="0" cellspacing="10" cellpadding="10" align=center>
    <tr>
      <td style="padding:200px 0 40 390px;background-image:url(/img/login_glue.jpg)">
        <table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td style="padding-left:14px;">
              <input type="text" name="hidden_id" class="box" tabindex="1" style="background-image:url(./img/gm0010img.jpg);background-repeat:no-repeat;font-weight:bold;ime-mode:inactive;" onFocus="this.style.backgroundImage='url(none)';"  onblur="if (this.value.length==0) {this.style.backgroundImage='url(./img/gm0010img.jpg)'}else {this.style.backgroundImage='url(none)'};"  />
            </td>
            <td rowspan="2" style="padding-left:5px;padding-top:1px;">
              <input type="image" title="LOGIN" src="./img/gm0009img.gif" onClick='javascript: return glue_login()'>
            </td>
          </tr>
          <tr> 
            <td style="padding:3px 0 0 14px;">
              <input type="password" name="password" class="box" tabindex="2" style="background-image:url(./img/gm0011img.jpg);background-repeat:no-repeat;font-weight:bold;" onFocus="this.style.backgroundImage='url(none)';"  onblur="if (this.value.length==0) {this.style.backgroundImage='url(./img/gm0011img.jpg)'}else {this.style.backgroundImage='url(none)'};" />
              <INPUT TYPE="HIDDEN" NAME="hidden_password">
            </td>
          </tr>
          <tr height=20 align=right><%
  if(isEncrypt) {
%>
            <td colspan="2" style="padding-top:14px;"><div class="btn_pw_reset" onClick="pop_up('./help/login.html')">login guide</div></td><%
  }else if(isStandAlone || request.getAttribute("Exception")!=null){
%>
            <td colspan="2" style="padding-top:14px;"><div class="btn_pw_reset" onClick="pop_up('./help/login.html')">login guide</div></td><%
  }else{
%>
            <td colspan="2" style="padding-top:14px;">&nbsp;</td><%
  }%>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
<script type="text/javascript"><%
if(request.getAttribute("Exception")!=null){
%>
    alert("<%=request.getAttribute("ExceptionLocalizedMessage")%>");
<%
}
%>
</script>
</html>
