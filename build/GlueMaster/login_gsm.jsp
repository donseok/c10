<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.Locale" %>
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
%>
<head>
<title>Glue Master 사용자 로그인</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script language="javascript" type="text/javascript">
<!--
function glue_login(){
  if ( document.forms[0].hidden_id.value == "" ){
    alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0102",null,locale)%>");//Username을 입력하세요
    document.forms[0].hidden_id.focus();
    return;
  }
  if ( document.forms[0].password.value == "" ) {
    alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0103",null,locale)%>");//Password을 입력하세요
    document.forms[0].password.focus();
    return;
  }
  document.forms[0].hidden_password.value=getEncryptValue(document.forms[0].password.value);
  document.forms[0].submit();
}
function executeEnterKey(){
  if( event.keyCode == 13 ) document.forms[0].submit();
}
function getEncryptValue(){
    var xmlHttp;
    var encryptValue;
    if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();
    var url = "login_encrypt_password.jsp?srcValue="+document.forms[0].password.value;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function(){
        if (xmlHttp.readyState == 4) {
            if (xmlHttp.status == 200) {
                var result = xmlHttp.responseXML.getElementsByTagName("result");
                if(result[0]!=null) encryptValue = result[0].firstChild.data;
            }
        }
    };
    xmlHttp.send(null);
    return encryptValue;
}
-->
</script>
</head>
<body>
<form name="GlueMaster" method="post" action="menu.do">
<div align=center style="position:relative;top:150"><img src="/img/login_glue.jpg">
<div align=center style="position:absolute;top:205;left:390;">
  <table width=250>
    <tr>
      <td width=70 style=color:white;font-weight:bold>Username :</td>
      <td><input type="text" name="hidden_id" class="adf1" style=width:100 size="15"></td>
      <td><input type="hidden" name="hidden_password">&nbsp;</td>
    </tr>
    <tr>
      <td width=70 style=color:white;font-weight:bold>Password :</td>
      <td><input type="password" name="password" class="adf1" style=width:100 size="15"></td>
      <td><img src="/img/btn_submit.gif" style="cursor:pointer" onclick="return glue_login();"></td>
    </tr>
  </table>
</div>
</div>
</html>