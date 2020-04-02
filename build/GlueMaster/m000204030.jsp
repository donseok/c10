<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
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

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String fac_op_cd = request.getParameter("fac_op_cd")==null||"%".equals(request.getParameter("fac_op_cd"))?"":request.getParameter("fac_op_cd"); //공장공정코드

    //관리모드인지 조회모드인지 기억
    String sMode=(String)request.getParameter("mode");
    if (sMode==null) sMode = "ret";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.089",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function viewDetail(){
    document.forms[0].action = document.forms[0].action+"?mode=<%=sMode%>";
    document.forms[0].submit();
}
function goErrorCheckModify(){
    document.forms[0].action=document.forms[0].action+"?modifyPage=10";
    document.forms[0].submit();
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
  <tr id=gm_logo>
    <td><img src="/img/m000001img.gif" width="1000" height="40"></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5">
        <tr height="23">
          <td id=gm_BreadCrumbs valign="middle"><!--BreadCrumbs 네비게이션 링크 출력--></td>
          <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
        </tr>
      </table>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.089",null,locale)%></div></td>
          <td align="right"><img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.tclayout",null,locale)%>" onClick='viewDetail();' style="cursor:pointer"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_tc_check" METHOD="post" action="m000204020.do">
<input type="hidden" name="ServiceName" value="m000204020-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="fac_op_cd" value="<%=fac_op_cd%>">
<input type="hidden" name="TbM00Interfaces_FkMdlDefineId" value="<%=request.getParameter("TbM00Interfaces_FkMdlDefineId")%>">
<input type="hidden" name="TbM00Interfaces_MdlDefineId" value="<%=request.getParameter("TbM00Interfaces_MdlDefineId")%>"><!-- TB_M00_INTERFACES -->
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0"><%
    PosRowSet rowSet = (PosRowSet)ctx.get("TB_M00_INTERFACES");
    PosRow row = rowSet.next();
%>
              <tr>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0102",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="format_name" value='<%=request.getParameter("format_name")%>' class=adb1 style="width:100px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0213",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="TbM00Interfaces_MdlDefineNm" value='<%=row.getAttribute("MDL_DEFINE_NM")%>' class=adb1 style="width:100px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0188",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("PROCESS_CHAIN_CODE1")%>' class=adb1 style="width:70px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="dummy" value='<%=row==null||row.getAttribute("MDL_DEFINE_OWNER_EMP_NO")==null?"":(String)row.getAttribute("MDL_DEFINE_OWNER_EMP_NO")%>' class=adb1 style="width:120px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="dummy" value='<%=row.getAttribute("START_ACTIVE_DATE")%>' class=adb1 style="width:120px"></td>
              </tr>
              <tr>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0214",null,locale)%></b></td>
                <td colspan=3><b>:</b>&nbsp;<input type="text" readonly name="TbM00Interfaces_MdlDefineExplain" value='<%=row.getAttribute("MDL_DEFINE_EXPLAIN")%>' class=adb1 style="width:350px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0171",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("PROCESS_CHAIN_CODE2")%>' class=adb1 style="width:70px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></b> </td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value="<%=row.getAttribute("LAST_UPDATE_TIMESTAMP")%>" class=adb1 style="width:120px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0092",null,locale)%><%=PosContext.getResourceMessage("GMResource","gm.label.0092",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("END_ACTIVE_DATE")%>' class=adb1 style="width:120px"></td>
              </tr>
           </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=right><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick="goErrorCheckModify()" style="cursor:pointer"><!-- modify --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onclick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td align=left valign=top>
            <posglobalui:showTable infoName="GetTCErrorCheckInfoResults"  
              headerClasses="tbldb|tbllb"
              headerValues="gm.label.0155|gm.label.0030|gm.label.0155|gm.label.0078|gm.label.0124|gm.label.0064|gm.label.0028|gm.label.0168|gm.label.0168|gm.label.0029|gm.label.0169|gm.label.0169|gm.label.0127|gm.label.0210;
                            gm.label.0155|gm.label.0030|gm.label.0155|gm.label.0078|gm.label.0124|gm.label.0064|gm.label.0028|gm.label.0148|gm.label.0139|gm.label.0029|MIN2|MAX2|gm.label.0127|gm.label.0210"
              height="20"
              tdClasses="tblcg|tbllw|tblcg|tblcw|tblcg|tblcw|tblcg|tblcw|tblcg|tblcw|tblcg|tblcw|tblcg|tblcw"
              columnWidths="50|180|40|70|40|50|70|90|80|70|80|80|40|40"
              columnNames="a|b|c|d|e|f|g|h|i|j|k|l|m|n"
              displayTypes="no|text|text|text|text|text|text|text|text|text|text|text|text|text"
              attributes="no|STANDARD_KOREAN_NAME|MDL_DEFINE_DT_NM_SEQ|DATA_TP|MDL_DEFINE_DT_NM_LEN|MD_RULE_DT_NM_CD_F|MD_RULE_CHK_OLSTATR_1|MD_RULE_CHK_MI_V_1|MD_RULE_CHK_MAX_V_1|MD_RULE_CHK_OLSTATR_2|MD_RULE_CHK_MI_V_2|MD_RULE_CHK_MAX_V_2|MD_RULE_DT_NM_DETAIL_OPER_TYPE|MD_RULE_DT_NM_TRUE_BAS"
            />
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000204020.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000204020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="checkxls" value="10"><!-- event -->
<input type="hidden" name="TbM00Interfaces_MdlDefineNm" value="<%=request.getParameter("TbM00Interfaces_MdlDefineNm")%>">
<input type="hidden" name="TbM00Interfaces_MdlDefineId" value="<%=request.getParameter("TbM00Interfaces_MdlDefineId")%>">
<input type="hidden" name="fac_op_cd" value="<%=fac_op_cd%>">
</form>
    </td>
  </tr>
</table>
</body>
</html>