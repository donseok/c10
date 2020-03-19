<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterConstants" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ page import="com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import="com.posdata.glue.web.security.PosUserIF" %>
<%@ page import="com.posdata.glue.web.security.PosMenuIF" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : Glue Master Home
 * Change history 
 * @2011-07-11 / 황유진 / 최초 생성
 * @2012-08-09 황유진 #1.4.2 다국어 지원 메뉴 
 */

    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort());
    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosUserIF user = null;
    if(ctx==null){
        user = (PosUserIF)session.getAttribute(PosSecurityConstants.USER);
    }else{
        user = (PosUserIF)ctx.getSessionUserData(PosSecurityConstants.USER);
    }
    String UserEmpNo = null, UserName=null;
    if(user==null){
        UserEmpNo = PosContext.getGlueProperty(PosMasterConstants.GLUE_PROP_USERNAME);// MASTDATA, MASTUSER : 시큐리티 적용전 임시
        if(UserEmpNo==null){
            UserEmpNo = "MASTUSER";
            UserName = "MASTUSER";
        }
    }else{
        UserEmpNo = user.getUserID();
        UserName = user.getUserInfo("USER_NAME")==null?UserEmpNo:user.getUserInfo("USER_NAME").toString();
    }
%>
<html>
<head>
<title>Glue Master Home</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script language="javascript" type="text/javascript">
<!--
function pop(URL){
//  window.open("<%=serverIP%>"+URL,"","width=1016,height=656,toolbar=no,menubar=no,top=0,left=0,scrollbars=yes,status=yes,resizable=yes");
  window.open(""+URL,"","width=1016,height=656,toolbar=no,menubar=no,top=0,left=0,scrollbars=yes,status=yes,resizable=yes");
}
function goLogout(){
  document.location.href=document.location.pathname.replace("menu.do","login.jsp");
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
      <table width="500" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td align=right>
            <div style="font-family:Verdana;font-size:10px;color:004A4A;cursor:pointer" onclick="goLogout()">LOGOUT</div>
          </td>
        </tr>
        <tr>
          <td align=center><font style="font-size: 30pt">Glue Master Home</font></td>
        </tr>
        <tr>
          <td align=right><font style="font-size:11px;color:4A4A4A;font-weight:normal"><%=PosContext.getResourceMessage("GMResource","gm.msg.0010",new Object[]{UserName},locale)%></font></td>
        </tr><%
        List root_menu_list = null;
        if(user!=null){
            root_menu_list = user.getMenu();
            for(int i=0, iz=root_menu_list.size(); i<iz; i++){
                PosMenuIF menu = (PosMenuIF)root_menu_list.get(i);
                List subMenus = menu.getSubMenus();
%>
        <tr>
          <td align=center>
            <br>
            <div style="width:300;height:25;text-align:left;font-size:14px;font-weight:bold">▣ <%=PosContext.getResourceMessage("GMResource",menu.getName(),null,locale)%></div><%
                for(int j=0, jz=subMenus.size(); j<jz; j++){
                    menu = (PosMenuIF)subMenus.get(j);
%>
            <div style="width:280;height:20;text-align:left;font-size:12px;font-weight:normal">　
            <a href="javascript:pop('<%=menu.getUrl()%>ServiceName=<%=menu.getPageID()%>-service&pageID=<%=menu.getPageID()%>&UserEmpNo=<%=UserEmpNo%>')"><%=PosContext.getResourceMessage("GMResource",menu.getName(),null,locale)%><a> <%=menu.getInfo().get("PROGRAM_NAME")%>
            </div><%
                }
%>
          </td>
        </tr><%
            }
        }
        if(user==null || root_menu_list==null){
%>
        <tr>
          <td>
<center><font style="font-size:12px;font:굴림;" color=red> Security 문제로 해당 data를 얻지 못했습니다. </font></center>
          </td>
        </tr><%
        }
%>
      </table>
</div>
</body>
</html>