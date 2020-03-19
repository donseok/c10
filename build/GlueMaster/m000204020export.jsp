<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 전문레이아웃조회
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20060522
 * @Author        : 불명
 * @LastModifier  : 서정범
 * @LastVersion   :  1.2
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    response.setHeader("Content-Disposition", "attachment;filename=MasterFormatLayout.xls");  //엑셀파일명 지정
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.087",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
  <tr class=tbldb>
    <td rowspan=2>no.</td>
    <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
    <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
    <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
    <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
    <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
    <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
    <td rowspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
    <td colspan=3><%=PosContext.getResourceMessage("GMResource","gm.label.0088",null,locale)%></td>
  </tr>
  <tr class=tbllb>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0034",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.gm.label.0211",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0068",null,locale)%></td>
  </tr>
</table>
  <table border=1><%

        PosRowSet rowSet = (PosRowSet)ctx.get("GetTCDetailResults");
        PosRow row = null;
        int seq1=0;
        String MdlDefineDtNmGroupTpStr = null;;
        while(rowSet.hasNext())
        {
            row = rowSet.next();
            MdlDefineDtNmGroupTpStr = row.getAttribute("MDL_DEFINE_DT_NM_GROUP_TP")==null?"":(String)row.getAttribute("MDL_DEFINE_DT_NM_GROUP_TP");
            if("E".equals(MdlDefineDtNmGroupTpStr))       MdlDefineDtNmGroupTpStr="항목";
            else if("G".equals(MdlDefineDtNmGroupTpStr))  MdlDefineDtNmGroupTpStr="그룹";
            else if("GE".equals(MdlDefineDtNmGroupTpStr)) MdlDefineDtNmGroupTpStr="그룹항목";
%>
  <tr CLASS=<%= seq1%2==0?"tblcg":"tblcw"%>>
    <td><%=row.getAttribute("MDL_DEFINE_DT_NM_SEQ")%></td>
    <td><%=MdlDefineDtNmGroupTpStr%></td>
    <td><%=row.getAttribute("STANDARD_KOREAN_NAME")%></td>
    <td><%=row.getAttribute("STANDARD_ENGLISH_ID")%></td>
    <td><%=row.getAttribute("DATA_TP")%></td>
    <td><%=row.getAttribute("MDL_DEFINE_DT_NM_LEN")%></td>
    <td><%=row.getAttribute("DT_NM_UOM_CD")==null?"":row.getAttribute("DT_NM_UOM_CD")%></td>
    <td><%=row.getAttribute("MDL_DEFINE_DT_NM_V_DECI_PREC")%></td>
    <td><%= (Integer.parseInt(row.getAttribute("BR_CHECK_FLAG").toString())==0?" ":"checked")%></td>
    <td><%= (Integer.parseInt(row.getAttribute("BL_CHECK_FLAG").toString())==0?" ":"checked")%></td>
    <td><%= (Integer.parseInt(row.getAttribute("ALL_CHECK_FLAG").toString())==0?" ":"checked")%></td>
  </tr><%
            seq1++;
        }
%>
</table>
</body>
</html>