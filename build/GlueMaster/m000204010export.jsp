<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * Copyright(c) 2010 posco ict
 * @FileName      : 전문목록조회(Export)
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20100304
 * @LastModifier  : 황유진
 * @LastVersion   : 1.0
 *    2010-03-04   황유진
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);
    /* 엑셀용 추가*/
    response.setHeader("Content-Disposition", "attachment;filename=InterfaceTCList.xls");  //엑셀파일명 지정
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.082",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<posglobalui:showTable infoName="GetTCListResults" tableName="TCListTable"
  headerClasses="tbldb"
  headerValues="gm.label.0213|gm.label.0214|gm.label.0102|gm.label.0232|gm.label.0188|gm.label.0171|gm.label.0250|gm.label.0199|gm.label.0086"
  height="20"
  trClasses="tblcg|tblcw"
  tdClasses="null|null|left|null|null|null|null|null|null"
  columnWidths="70|314|67|42|62|62|71|70|70" 
  displayTypes="text|text|text|text|text|text|text|text|text"
  attributes ="MDL_DEFINE_NM|MDL_DEFINE_EXPLAIN|FORMAT_NAME|MDL_DEFINE_VERSION|PROCESS_CHAIN_CODE1|PROCESS_CHAIN_CODE2|
    MDL_DEFINE_OWNER_EMP_NO|START_ACTIVE_DATE|END_ACTIVE_DATE"
  displayFormats="null|null|null|null|null|null|null|yyyy-MM-dd|yyyy-MM-dd"
  defaultRowCnt="20"
/>
END!<br/>
</body>
</html>