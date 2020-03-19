<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 마스타코드 목록 >> 마스타코드 수정 >> 마스타코드 카테고리 등록 및 수정(Export)
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080307
 * @LastModifier  : 서정범
 * @LastVersion   : 1.0
 * @2008-03-07 서정범 1.0 최초 생성
 * @2012-08-09 황유진 #1.4.2 LANGUAGE_CODE 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    // Caching Data
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");

    response.setHeader("Content-Disposition", "attachment;filename=MasterCodeValueList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.026",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0054",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0141",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0147",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0138",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0241",null,locale)%></td>
    </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("CodeValueVOResult") : null;
    PosRow row = null;
    if(rowSet!=null && rowSet.hasNext()){
        int rowCnt = 0;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class=<%=(rowCnt%2==1?"tblcg":"tblcw")%>>
      <td class="xls"><%=request.getParameter("LanguageCode")%></td>
      <td class="xls"><%=request.getParameter("CdTp")%></td>
      <td class="xls"><%=request.getParameter("CdTpMeaning")%></td>
      <td class="xls"><%=(String)row.getAttribute("CD_V")%></td>
      <td class="xls"><%=(String)row.getAttribute("CD_V_MEANING")%></td>
      <td class="xls"><%=(String)row.getAttribute("CATEGORY_GROUP_NM")%></td>
      <td class="xls"><%=(String)row.getAttribute("CATEGORY_GROUP_EXPLAIN")%></td>
      <td class="xls"><%=row.getAttribute("RG_MIN_V")==null?"":row.getAttribute("RG_MIN_V").toString()%></td>
      <td class="xls"><%=row.getAttribute("RG_MAX_V")==null?"":row.getAttribute("RG_MAX_V").toString()%></td>
      <td class="xls"><%=row.getAttribute("CD_V_INQUIRY_SEQ")==null?"":row.getAttribute("CD_V_INQUIRY_SEQ").toString()%></td>
    </tr><%
            rowCnt++;
        }
    }
%>
  </table>
  <table>
    <tr>
      <td>END!</td>
    </tr>
  </table><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> : A~J 컬럼 필수  </b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%> : </b><%
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        Object[] value = (Object[]) LanguageCodeList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>
</body>
</html>