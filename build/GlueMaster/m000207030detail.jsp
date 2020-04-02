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
 * @FileName      : 표준항목 목록 >> 표준항목 내용상세
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080402
 * @Author        : 이진
 * @LastModifier  : 이진
 * @LastVersion   :  1.0 
 *    2008-04-02   이진
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    String data_item_name      =request.getParameter("data_item_name") == null?"":request.getParameter("data_item_name");
    String data_var_id         =request.getParameter("data_var_id") == null?"":request.getParameter("data_var_id");
    String sys_tp              =request.getParameter("sys_tp") == null?"":request.getParameter("sys_tp");
    String chain_code          =request.getParameter("chain_code") == null?"":request.getParameter("chain_code");
    String data_type           =request.getParameter("data_type") == null?"":request.getParameter("data_type");
    String data_number         =request.getParameter("data_number") == null?"":request.getParameter("data_number");
    String decimal_number      =request.getParameter("decimal_number") == null?"":request.getParameter("decimal_number");
    String data_unit           =request.getParameter("data_unit") == null?"":request.getParameter("data_unit");
    String code_yn             =request.getParameter("code_yn") == null?"":request.getParameter("code_yn");
    String kor_abbr            =request.getParameter("kor_abbr") == null?"":request.getParameter("kor_abbr");
    String eng_abbr            =request.getParameter("eng_abbr") == null?"":request.getParameter("eng_abbr");
    String data_synonymous_1   =request.getParameter("data_synonymous_1") == null?"":request.getParameter("data_synonymous_1");
    String data_synonymous_2   =request.getParameter("data_synonymous_2") == null?"":request.getParameter("data_synonymous_2");
    String data_synonymous_3   =request.getParameter("data_synonymous_3") == null?"":request.getParameter("data_synonymous_3");
    String data_item_descript  =request.getParameter("data_item_descript") == null?"":request.getParameter("data_item_descript");
    String other_terms         =request.getParameter("other_terms") == null?"":request.getParameter("other_terms");
    String owner_dept          =request.getParameter("owner_dept") == null?"":request.getParameter("owner_dept");
    String subc_nm             =request.getParameter("subc_nm") == null?"":request.getParameter("subc_nm");
    String register_date       =request.getParameter("register_date") == null?"":request.getParameter("register_date");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.006",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no" onload="">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.006",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.help",null,locale)%>" style="cursor:pointer"><!-- help -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer"/>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
            <table width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr height="25">
                <td class="tbllb" width="200"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></b></td>
                <td class="tbllw" width="290">&nbsp;<b><%=data_item_name%></b></td>
                <td class="tbllb" width="200"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></b></td>
                <td class="tbllw" width="290">&nbsp;<%=register_date%></td>
              </tr>
              <tr height="25">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=data_var_id%></td>
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=sys_tp%></td>
              </tr>
              <tr height="25">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=data_type%>&nbsp;</td>
                <td class="tbllb" align="center"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0048",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=chain_code%></td>
              </tr>
              <tr height="25">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0126",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=data_number%></td>
                <td class="tbllb" align="center"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0021",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=kor_abbr%></td>
              </tr>
              <tr height="25">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=decimal_number%></td>
                <td class="tbllb" align="center"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=eng_abbr%></td>
              </tr>
              <tr height="25">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=data_unit%></td>
                <td class="tbllb" align="center"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=owner_dept%></td>
              </tr>
              <tr height="25">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=code_yn%></td>
                <td class="tbllb" align="center"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></b></td>
                <td class="tbllw">&nbsp;<%=subc_nm%></td>
              </tr>
              <tr height="25">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0205",null,locale)%></b></td>
                <td class="tbllw" colspan="3">&nbsp;<%=data_synonymous_1%>&nbsp;<%=data_synonymous_2%>&nbsp;<%=data_synonymous_3%></td>
              </tr>
              <tr height="75">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0256",null,locale)%></b></td>
                <td class="tbllw" colspan="3">&nbsp;<%=data_item_descript%></td>
              </tr>
              <tr height="50">
                <td class="tbllb"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0176",null,locale)%></b></td>
                <td class="tbllw" colspan="3">&nbsp;<%=other_terms%></td>
              </tr>
            </table>
            </div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>