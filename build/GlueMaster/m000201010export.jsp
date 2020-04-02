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
 * @FileName      : 마스타코드 목록(Export)
 * Open Issues    :
 * Change history 
 * @2008-03-07 서정범 1.0    최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP,LANGUAGE_CODE,_SYS_R_APPLICATION_ID 출력방식 변경 
 */

    PosContext ctx=(PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale=(Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");
    List ApplicationIdList = (List) ctx.get("_SYS_R_APPLICATION_ID");
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");

    response.setHeader("Content-Disposition", "attachment;filename=MasterCodeList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.020",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0131",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0130",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0218",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0217",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0108",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0109",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
      <td>[application id]</td>
      <td>[security group id]</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
      <td>[버전관리]</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
    </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("CodeListVOResult") : null;
    PosRow row = null;
    if( rowSet!=null ){
        int rowCnt = 0;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td class="xls"><%=row.getAttribute("CD_TP_CHARACTER")==null?"":(String)row.getAttribute("CD_TP_CHARACTER")%></td>
      <td class="xls" align="left"><%=row.getAttribute("M_CD_TP_MEANNING")==null?"":(String)row.getAttribute("M_CD_TP_MEANNING")%></td>
      <td class="xls" align="left"><%=row.getAttribute("M_CD_TP")==null?"":(String)row.getAttribute("M_CD_TP")%></td>
      <td class="xls" align="left"><%=row.getAttribute("CD_TP_MEANING")==null?"":(String)row.getAttribute("CD_TP_MEANING")%></td>
      <td class="xls" align="left"><%=row.getAttribute("CD_TP")==null?"":(String)row.getAttribute("CD_TP")%></td>
      <td class="xls"><%=row.getAttribute("MDL_REG_REQ_EMP_ID")==null?"":(String)row.getAttribute("MDL_REG_REQ_EMP_ID")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_OP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OP_TP")%></td>
      <td class="xls"><%=row.getAttribute("HIERARCHY_OWNER_SHIP_TP")==null?"":(String)row.getAttribute("HIERARCHY_OWNER_SHIP_TP")%></td>
      <td class="xls"><%=row.getAttribute("CD_TP_OWNER_EMP_NO")==null?"":(String)row.getAttribute("CD_TP_OWNER_EMP_NO")%></td>
      <td class="xls"><%=row.getAttribute("LANGUAGE_CODE")==null?"":(String)row.getAttribute("LANGUAGE_CODE")%></td>
      <td class="xls"><%=row.getAttribute("APPLICATION_ID")==null?"":row.getAttribute("APPLICATION_ID").toString()%></td>
      <td class="xls"><%=row.getAttribute("SECURITY_GROUP_ID")==null?"":row.getAttribute("SECURITY_GROUP_ID").toString()%></td>
      <td class="xls"><%=row.getAttribute("CD_TP_CNG_GD")==null?"":(String)row.getAttribute("CD_TP_CNG_GD")%></td>
      <td class="xls"><%=row.getAttribute("MD_VERSION_MAINT_FLAG")==null?"":(String)row.getAttribute("MD_VERSION_MAINT_FLAG")%></td>
      <td class="xls"><%=row.getAttribute("USE_TP")==null?"":(String)row.getAttribute("USE_TP")%></td>
      <td class="xls"><%=row.getAttribute("CD_TP_VERSION")==null?"":(String)row.getAttribute("CD_TP_VERSION")%></td>
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

※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> : A~N 컬럼 필수  </b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0190",null,locale)%>)  
<b>C</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0065",null,locale)%>)  
<b>R</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0170",null,locale)%>)
<b>T</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0216",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%> : </b><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        Object[] value = (Object[]) HierarchyOpTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0082",null,locale)%> : </b><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        Object[] value = (Object[]) HierarchyOwnerShipTpList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%> : </b><%
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        Object[] value = (Object[]) LanguageCodeList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>
※ <b>[application id] : </b><%
    for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
        Object[] value = (Object[]) ApplicationIdList.get(i);
%><b><%=(String)value[0]%></b>(<%=(String)value[1]%>)  <%
    }
%><br>
※ <b>[security group id] : </b>
<b>0</b><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%> : </b>
<b>A</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale)%>)
<b>B</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale)%>)<br>
※ <b>[버전관리] : </b>
<b>Y</b>(Yes)
<b>N</b>(No)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%> : </b>
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%>)
<b>F</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%>)
<b>Y</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%>)
<b>N</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%>)<br>
</body>
</html>