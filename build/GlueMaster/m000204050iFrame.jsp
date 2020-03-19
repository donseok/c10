<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosPageSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * Copyright(c) 2009 POSDATA
 * @FileName      : Format 목록조회-iframe
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20100501
 * @Author        : 정경주
 * @LastModifier  : 정경주
 * @LastVersion   :  1.0
 *    2
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String format_id = request.getParameter("format_id");
    String format_name = request.getParameter("format_name");
    if(format_id!=null){
        PosRowSet rowSet = (PosRowSet)ctx.get("GeTCBelongtoFormatResults");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.082",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table id=mainTable border="0" cellspacing="0" cellpadding="0" >
<form name="TCForm" method="post" action="m000204050.do">
<input type="hidden" name="ServiceName" value="m000204050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="iframe" value=10>
<input type="hidden" name="format_id" value=<%=format_id%>>
<input type="hidden" name="format_name" value=<%=format_name%>>
    <tr>
      <td ><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033">&nbsp<%=format_name%>&nbsp<%=PosContext.getResourceMessage("GMResource","gm.label.0104",null,locale)%> 
      </div></td>
    </tr>
    <tr>
      <td  height="7"></td>
    </tr>
    	<tr>
          <td align=left valign=top>
            <posglobalui:showTable infoName="GeTCBelongtoFormatResults" tableName="TCListTable"
              headerClasses="tbldb"
              headerValues="gm.label.0214|gm.label.0214|gm.label.0188|수신|gm.label.0199|gm.label.0086"
                            
              height="20"
              trClasses="tblcg|tblcw"
              tdClasses="null|null|null|null|null|null"
              columnNames="MdlDefineNm|MdlDefineExplain|ProcessChainCode1|ProcessChainCode2|
                StartActiveDate|EndActiveDate" 
              columnWidths="80|400|50|50|120|120" 
              displayTypes="text|text|text|text|text|text"
              attributes ="MDL_DEFINE_NM|MDL_DEFINE_EXPLAIN|PROCESS_CHAIN_CODE1|PROCESS_CHAIN_CODE2|
                START_ACTIVE_DATE|END_ACTIVE_DATE" 
              tdEvents=  "null|null|null|null|null|null"
              displayFormats="null|null|null|null|yyyy-MM-dd|yyyy-MM-dd"
              defaultRowCnt="10"
            />
            <div align="center"> 
            <posui:showPageSet infoName="GeTCBelongtoFormatResults" formName="document.TCForm" curPageName="curPageNum" />
            </div> 
          </td>
        </tr>
    </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
</body>
</html>
<%
}else{
%>

<%
}%>