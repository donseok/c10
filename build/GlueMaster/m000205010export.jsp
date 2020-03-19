<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : AP메시지목록조회화면
 * Open Issues    :
 * Change history 
 * @2008-03-07 김정희 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 LANGUAGE_CODE,_SYS_R_APPLICATION_ID 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    // Caching Data
    List LanguageCodeList = (List) ctx.get("LANGUAGE_CODE");
    List ApplicationIdList = (List) ctx.get("_SYS_R_APPLICATION_ID");
    HashMap<String, String> ApplicationIdMap = new HashMap<String, String>();
    for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
        String[] value = (String[]) ApplicationIdList.get(i);
        ApplicationIdMap.put(value[0], value[1]);
    }

    response.setHeader("Content-Disposition", "attachment;filename=GlueMaster_AppMsgList.xls");
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.013",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class="tbldb">
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0145",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0143",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0142",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0174",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%>(<%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%>)</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%>(<%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%>)</td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%>(<%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%>)</td>
    </tr><%

    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("AppMsgListVOResult") : null;
    PosRow row = null;
    int rowCnt = 0;
    if( rowSet!=null ){
        while(rowSet.hasNext()){
            row = rowSet.next();
            String MessageTpStr = row.getAttribute("MESSAGE_TP")==null?"":(String)row.getAttribute("MESSAGE_TP");
            if("Fixed".equals(MessageTpStr))       MessageTpStr=PosContext.getResourceMessage("GMResource","gm.label.0100",null,locale);
            else if("Changed".equals(MessageTpStr))MessageTpStr=PosContext.getResourceMessage("GMResource","gm.label.0231",null,locale);
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
    
      <td class="xls"><%=row.getAttribute("APPLICATION_ID")==null?"":row.getAttribute("APPLICATION_ID").toString()%></td>
      <td class="xls"><%=row.getAttribute("MESSAGE_TP")==null?"":(String)row.getAttribute("MESSAGE_TP")%></td>
      <td class="xls"><%=row.getAttribute("LANGUAGE_CODE")==null?"":(String)row.getAttribute("LANGUAGE_CODE")%></td>
      <td class="xls" align="left"><%=row.getAttribute("MESSAGE_EXPLAIN")==null?"":(String)row.getAttribute("MESSAGE_EXPLAIN")%></td>
      <td class="xls"><%=row.getAttribute("MESSAGE_NM")==null?"":(String)row.getAttribute("MESSAGE_NM")%></td>
      <td class="xls"><%=row.getAttribute("APPL_MSG_OWNER_EMP_NO")==null?"":(String)row.getAttribute("APPL_MSG_OWNER_EMP_NO")%></td>
      <td class="xls" align="left"><%=row.getAttribute("MSG_CONT")==null?"":(String)row.getAttribute("MSG_CONT")%></td>
      <td class="xls"><%=row.getAttribute("CREATE_DAY")==null?"":(String)row.getAttribute("CREATE_DAY")%></td>
      <td class="xls"><%=ApplicationIdMap.get(row.getAttribute("APPLICATION_ID").toString())%></td>
      <td class="xls"><%=MessageTpStr%></td>
      <td class="xls"><%=row.getAttribute("USER_NAME")==null?"":(String)row.getAttribute("USER_NAME")%></td>
    </tr><%
            rowCnt++;
        }
    }

    if("import".equals(request.getParameter("export"))){
        if(rowCnt==0){
%>
    <tr class="tblcw">
      <td class="xls">50001</td>
      <td class="xls">Fixed</td>
      <td class="xls">KO</td>
      <td class="xls"><%=PosContext.getResourceMessage("GMResource","gm.msg.0097",null,locale)%></td>
      <td class="xls">MSG#JS001</td>
      <td class="xls"><%=request.getParameter("UserEmpNo")%></td>
      <td class="xls"><%=PosContext.getResourceMessage("GMResource","gm.msg.0001",null,locale)%></td>
      <td class="xls"></td>
      <td class="xls"></td>
      <td class="xls"></td>
      <td class="xls"></td>
    </tr>
    <tr class="tblcw">
      <td class="xls">50001</td>
      <td class="xls">Changed</td>
      <td class="xls">KO</td>
      <td class="xls"><%=PosContext.getResourceMessage("GMResource","gm.msg.0097",null,locale)%></td>
      <td class="xls">MSG#JS002</td>
      <td class="xls"><%=request.getParameter("UserEmpNo")%></td>
      <td class="xls">&님 안녕하세요!!</td>
      <td class="xls"></td>
      <td class="xls"></td>
      <td class="xls"></td>
      <td class="xls"></td>
    </tr><%
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
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> : A~G 컬럼 필수  </b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%> : </b><%
    for (int i = 0, iz = ApplicationIdList.size(); i < iz; i++) {
        String[] value = (String[]) ApplicationIdList.get(i);
%>
<b><%=value[0]%></b>(<%=value[1]%>)<%
    }
%><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>Fixed</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0100",null,locale)%>)
<b>Changed</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0231",null,locale)%>)
<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%> : </b><%
    for (int i = 0, iz = LanguageCodeList.size(); i < iz; i++) {
        String[] value = (String[]) LanguageCodeList.get(i);
%>
<b><%=value[0]%></b>(<%=value[1]%>)<%
    }
%><br>
</body>
</html>