<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal " %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * Copyright(c) 2010 posco ict
 * @FileName      : 포맷목록조회(Export)
 * Open Issues    :
 * Change history 
 * @2010-03-04 정경주 1.0 영문화
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    /* 엑셀용 추가*/
    response.setHeader("Content-Disposition", "attachment;filename=InterfaceFormatList.xls");  //엑셀파일명 지정
    if("tc".equals(request.getParameter("import")))
    {
        response.setHeader("Content-Disposition", "attachment;filename=InterfaceFormatTCList.xls");  //엑셀파일명 지정
    }
    out.clearBuffer();
    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.092",null,locale)%></title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"><%

    if("format".equals(request.getParameter("import")))
    {

%>
  <table border=1>
  <tr class="tbldb">
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0102",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0159",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0103",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
  </tr>
  <tr class="tblcw"><td>FORMAT01</td><td>1.0</td><td>1</td><td>부서정보 Format</td><td>TRANSACTION_CODE</td><td>TransactionCode</td><td>1</td><td>8</td><td></td></tr>
  <tr class="tblcg"><td>FORMAT01</td><td>1.0</td><td>2</td><td>부서정보 Format</td><td>EDU_CRUD</td><td>CRUD구분</td><td>1</td><td>1</td><td></td></tr>
  <tr class="tblcw"><td>FORMAT01</td><td>1.0</td><td>3</td><td>부서정보 Format</td><td>EDU_DEPTNO</td><td>부서번호</td><td>2</td><td>2</td><td>0</td></tr>
  <tr class="tblcg"><td>FORMAT01</td><td>1.0</td><td>4</td><td>부서정보 Format</td><td>EDU_DNAME</td><td>부서이름</td><td>1</td><td>14</td><td></td></tr>
  <tr class="tblcw"><td>FORMAT01</td><td>1.0</td><td>5</td><td>부서정보 Format</td><td>EDU_DLOC</td><td>부서위치</td><td>1</td><td>13</td><td></td></tr>
  <tr class="tblcg"><td>FORMAT02</td><td>1.0</td><td>1</td><td>사원정보 Format</td><td>TRANSACTION_CODE</td><td>TransactionCode</td><td>1</td><td>8</td><td></td></tr>
  <tr class="tblcw"><td>FORMAT02</td><td>1.0</td><td>2</td><td>사원정보 Format</td><td>EDU_CRUD</td><td>CRUD구분</td><td>1</td><td>1</td><td></td></tr>
  <tr class="tblcg"><td>FORMAT02</td><td>1.0</td><td>3</td><td>사원정보 Format</td><td>EDU_EMPNO</td><td>사원번호</td><td>2</td><td>4</td><td></td></tr>
  <tr class="tblcw"><td>FORMAT02</td><td>1.0</td><td>4</td><td>사원정보 Format</td><td>EDU_ENAME</td><td>사원명</td><td>1</td><td>10</td><td></td></tr>
  <tr class="tblcg"><td>FORMAT02</td><td>1.0</td><td>5</td><td>사원정보 Format</td><td>EDU_JOB</td><td>업무</td><td>1</td><td>9</td><td></td></tr>
  <tr class="tblcw"><td>FORMAT02</td><td>1.0</td><td>6</td><td>사원정보 Format</td><td>EDU_MGR</td><td>관리자번호</td><td>2</td><td>4</td><td></td></tr>
  <tr class="tblcg"><td>FORMAT02</td><td>1.0</td><td>7</td><td>사원정보 Format</td><td>EDU_HIREDATE</td><td>고용일자</td><td>3</td><td>8</td><td></td></tr>
  <tr class="tblcw"><td>FORMAT02</td><td>1.0</td><td>8</td><td>사원정보 Format</td><td>EDU_SAL</td><td>급여</td><td>2</td><td>7</td><td>2</td></tr>
  <tr class="tblcg"><td>FORMAT02</td><td>1.0</td><td>9</td><td>사원정보 Format</td><td>EDU_COMM</td><td>커미션</td><td>2</td><td>7</td><td>2</td></tr>
  <tr class="tblcw"><td>FORMAT02</td><td>1.0</td><td>10</td><td>사원정보 Format</td><td>EDU_DEPTNO</td><td>부서번호</td><td>2</td><td>2</td><td></td></tr>
  <tr><td>END!</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
</table><%

    }else if("tc".equals(request.getParameter("import")))
    {
%>
  <table border=1>
  <tr class="tbldb">
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0213",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0214",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0102",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0188",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0171",null,locale)%></td>
    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0250",null,locale)%></td>
  </tr>
  
  <tr class="tblcw"><td>MSGFW001</td><td>부서정보(교육용#1)</td><td>FORMAT01</td><td>1.0</td><td>EDU</td><td>AP#1</td><td>MASTDATA</td></tr>
  <tr class="tblcg"><td>MSGFW002</td><td>부서정보(교육용#2)</td><td>FORMAT01</td><td>1.0</td><td>EDU</td><td>AP#2</td><td>MASTDATA</td></tr>
  <tr class="tblcw"><td>MSGFW011</td><td>사원정보(교육용#1)</td><td>FORMAT02</td><td>1.0</td><td>EDU</td><td>AP#1</td><td>MASTDATA</td></tr>
  <tr class="tblcg"><td>MSGFW012</td><td>사원정보(교육용#2)</td><td>FORMAT02</td><td>1.0</td><td>EDU</td><td>AP#2</td><td>MASTDATA</td></tr>
  <tr><td>END!</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
</table><%
    }else
    {
%>
  <table border=1>
    <tr class="tbldb">
   	  <td><%=PosContext.getResourceMessage("GMResource","gm.label.0102",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0159",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0103",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0156",null,locale)%></td>
    </tr><%
        PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("GetFormatListResults") : null;
        int rowCnt = 0;
        if( rowSet!=null ){
            PosRow row = null;
            while(rowSet.hasNext()){
                row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>">
      <td><%=row.getAttribute("MDL_DEFINE_NM")==null?"":(String)row.getAttribute("MDL_DEFINE_NM")%></td>
      <td><%=row.getAttribute("MDL_DEFINE_VERSION")==null?"":(String)row.getAttribute("MDL_DEFINE_VERSION")%></td>
      <td><%=row.getAttribute("MDL_DEFINE_DT_NM_SEQ")==null?"":(BigDecimal)row.getAttribute("MDL_DEFINE_DT_NM_SEQ")%></td>
      <td><%=row.getAttribute("MDL_DEFINE_EXPLAIN")==null?"":(String)row.getAttribute("MDL_DEFINE_EXPLAIN")%></td>
      <td><%=row.getAttribute("STANDARD_ENGLISH_ID")==null?"":(String)row.getAttribute("STANDARD_ENGLISH_ID")%></td>
      <td><%=row.getAttribute("STANDARD_KOREAN_NAME")==null?"":(String)row.getAttribute("STANDARD_KOREAN_NAME")%></td>
      <td><%=row.getAttribute("MDL_DEFINE_DT_NM_DATA_TP")==null?"":(BigDecimal)row.getAttribute("MDL_DEFINE_DT_NM_DATA_TP")%></td>
      <td><%=row.getAttribute("MDL_DEFINE_DT_NM_LEN")==null?"":(BigDecimal)row.getAttribute("MDL_DEFINE_DT_NM_LEN")%></td>
      <td><%=row.getAttribute("MDL_DEFINE_DT_NM_V_DECI_PREC")==null?"":(BigDecimal)row.getAttribute("MDL_DEFINE_DT_NM_V_DECI_PREC")%></td>
      <td><%=row.getAttribute("START_ACTIVE_DATE")==null?"":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("END_ACTIVE_DATE")==null?"":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
      <td><%=row.getAttribute("COUNT_TC")==null?"":row.getAttribute("COUNT_TC").toString()%></td>
    </tr><%
                rowCnt++;
            }
        }
      %>
        </table>
        END!<br/>
        ※ 데이타타입 : 1(STRING) 2(NUMBER) 3(DATE)<br/>
        ※ 수정 후 import 하실경우에는 A~I 컬럼만 수정하시면 됩니다. <br/>
     <%   
    }
%>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
</body>
</html>