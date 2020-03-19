<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 마스타코드 목록 >> [import] 마스타코드 목록
 * Open Issues    :
 * Change history 
 * @2008-03-07 서정범 1.0 최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>[import] <%=PosContext.getResourceMessage("GMResource","gm.title.020",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript">
<!--
function goUpLoad(){
    if(document.forms[0].File.value.length == 0){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0064",null,locale)%>");//첨부할 파일을 먼저 선택해 주십시오!
        return;
    }
    var filenm = document.forms[0].File.value;
    var lastindex = filenm.lastIndexOf("\\");
    var attachedfile = filenm.substring(lastindex+1);
    document.forms[0].pfileNm.value = filenm;
    document.forms[0].submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no">
<table width="480" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="460" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033">[import] <%=PosContext.getResourceMessage("GMResource","gm.title.020",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
<form name="form_import" method="post" enctype="multipart/form-data" action="m000201010.do">
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="pfileNm">
        <tr height=50>
          <td><%=PosContext.getResourceMessage("GMResource","gm.msg.0095",null,locale)%> [<a href='#' onClick="document.form_export.submit()">양식 download</a>]<br>
            <input type=file name="File" size=50>
          </td>
        </tr>
        <tr>
          <td><%=PosContext.getResourceMessage("GMResource","gm.msg.0091",null,locale)%><br><!-- IMPORT 결과 -->
            <div id=divData border="1" style='position:relative;overflow:scroll;overflow-y:scroll;width:460;height:170;top:0;left:0;'>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr align="center">
                <td align="left"><%
                  HashMap result=(HashMap)ctx.get("result");
                  if(result != null)
                  {
                      out.println("<br>■ "+PosContext.getResourceMessage("GMResource","gm.msg.0092",null,locale)+" : "+result.get("StartTime"));//Import 시작시간
                      out.println("<br>■ "+PosContext.getResourceMessage("GMResource","gm.msg.0093",null,locale)+" : "+result.get("EndTime")+"<br>");//Import 종료시간
                      out.println("<br>■ "+PosContext.getResourceMessage("GMResource","gm.msg.0053",null,locale)+"    : "+result.get("InsertCnt"));//입력데이타수
                      out.println("<br>■ "+PosContext.getResourceMessage("GMResource","gm.msg.0037",null,locale)+"    : "+result.get("UpdateCnt")+"<br>");//수정데이타수

                      if(result.get("ErrMessage") != null && !result.get("ErrMessage").equals(""))
                      {
                          out.println("<br>■ "+PosContext.getResourceMessage("GMResource","gm.msg.0048",null,locale)+"   : "+result.get("ErrMessage"));//예외발생
                          out.println("<br>■ "+PosContext.getResourceMessage("GMResource","gm.msg.0048",null,locale)+"   : "+result.get("ErrorRow"));//예외발생
                      }
                  }
%>
                </td>
              </tr>
            </table>
          </div>
          </td>
        </tr>
        <tr>
          <td><br><br><div id=gm_import_text><font color="red">
            ※ <%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%><!-- IMPORT시 유의사항 -->
            <br>■ <%=PosContext.getResourceMessage("GMResource","gm.msg.0089",null,locale)%><!-- Export한 파일은 [Microsoft Excel 통합문서]형식의 다른 이름으로 저장한다. -->
            <br>■ <%=PosContext.getResourceMessage("GMResource","gm.msg.0065",null,locale)%><!-- 첫번째 WorkSheet에 입력 또는 삭제할 데이타를 작성하고 필터는 해제한다. -->
            <br>■ <%=PosContext.getResourceMessage("GMResource","gm.msg.0086",new Object[]{"2"},locale)%><!-- 항상 15번째 Row부터 데이타를 작성한다. -->
            <br>■ <%=PosContext.getResourceMessage("GMResource","gm.msg.0023",null,locale)%><!-- 등록위치지정항목의 마지막에 [end]을 반드시 입력한다. -->
            <br>■ <%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%><!-- 셀서식의 표시 형식은 텍스트로 하시기 바랍니다. -->
            </font></div>
          </td>
        </tr>
        <tr>
          <td align="center"><br><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onclick="goUpLoad()" style="cursor:pointer"><!-- import --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<form name="form_export" method="post" action="m000201010.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="import"><!-- event -->
</form>
</BODY>
</HTML>