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
 * @FileName      : 마스타코드 목록 >> 마스타코드 수정(Export)
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080307
 * @LastModifier  : 서정범
 * @LastVersion   : 1.0
 *    2008-03-07   서정범
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    response.setHeader("Content-Disposition", "attachment;filename=MasterCodeCategoryList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.030",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class=tbldb>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0055",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0059",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0042",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0043",null,locale)%></td>
    </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("CategoryGrVOResult") : null;
    PosRow row = null;
    if(rowSet!=null && rowSet.hasNext()){
        int rowCnt = 0;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class=<%=(rowCnt%2==1?"tblcg":"tblcw")%>>
      <td class="xls"><%=row.getAttribute("CD_TP")%></td>
      <td class="xls"><%=request.getParameter("CdTpMeaning")%></td>
      <td class="xls"><%=(String)row.getAttribute("CATEGORY_GROUP_NM")%></td>
      <td class="xls"><%=(String)row.getAttribute("CATEGORY_GROUP_EXPLAIN")%></td>
    </tr><%
            rowCnt++;
        }
    }else if("import".equals(request.getParameter("export"))){
%>
    <tr class="tblcw">
      <td class="xls">EDU_CRUD</td>
      <td class="xls">CRUD구분</td>
      <td class="xls">SZ0000</td>
      <td class="xls">공통</td>
    </tr>
    <tr class="tblcg">
      <td class="xls">EDU_CRUD</td>
      <td class="xls">CRUD구분</td>
      <td class="xls">SZA000</td>
      <td class="xls">테스트</td>
    </tr><%
    }
%>
  </table>
  <table>
    <tr>
      <td>END!</td>
    </tr>
  </table><br>

※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> : A~D 컬럼 필수  </b>※<br>
</body>
</html>