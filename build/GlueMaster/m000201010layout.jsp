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
 * @FileName      : 마스타코드 목록 >> 마스타코드 내용상세 >> 마스타코드 레이아웃
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080310
 * @LastModifier  : 서정범
 * @LastVersion   : 1.0
 *    2008-03-07   서정범
 *        1.0      최초 생성
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
<title><%=PosContext.getResourceMessage("GMResource","gm.title.028",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="900" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_layout" method="post" action="m000201010.do">
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="layout" value="layout"><!-- event -->
<input type="hidden" name="CdTpId" value="<%=request.getParameter("CdTpId")== null?"":request.getParameter("CdTpId")%>">
      <table width="880" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.028",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height=18>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=left valign=top>
            <posglobalui:showTable infoName="CodeStructureVOResult" 
              headerClasses="tbldb|tbllb"
              headerValues="gm.label.0155|gm.label.0065|gm.label.0065|gm.label.0065|gm.label.0065|gm.label.0066|gm.label.0066|gm.label.0167|gm.label.0167;
                            gm.label.0155|gm.label.0159|gm.label.0059|gm.label.0055|gm.label.0124|gm.label.0054|gm.label.0141|gm.label.0147|gm.label.0138"
              height="18"
              trClasses="tblcg|tblcw"
              tdClasses="null|null|left|left|null|null|left|null|null"
              columnNames="no|CdDtNmSeq|CdDtNmExplain|CdDtNmNm|CdDtNmLen|CdDtNmV|CdDtNmMeaning|CdTpRgMi|CdTpRgMax"  
              columnWidths="30|30|200|200|50|100|170|50|50"
              displayTypes="no|text|text|text|text|text|text|text|text"
              attributes="no|CD_DT_NM_SEQ|CD_DT_NM_EXPLAIN|CD_DT_NM_NM|CD_DT_NM_LEN|CD_DT_NM_V|CD_DT_NM_MEANING|CD_TP_RG_MI|CD_TP_RG_MAX"
              defaultRowCnt="15"
            />
            <div align="center">
            <posui:showPageSet infoName="CodeStructureVOResult" formName="document.forms[0]" curPageName="curPageNum"/>
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