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
 * @FileName      : 업무기준 목록 >> 업무기준 내용상세_일반기준 >> 업무기준 변경이력
 *                  업무기준 목록 >> 업무기준 내용상세_매트릭스 >> 업무기준 변경이력
 *                  업무기준 목록 >> 업무기준 내용상세_판단기준 >> 업무기준 변경이력
 *                  업무기준 목록 >> 업무기준 내용상세_연관판단 >> 업무기준 변경이력
 * Open Issues    :
 * Change history 
 * @2008-03-25 류진영 1.0 최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String modifyFlag = request.getParameter("modifyFlag")== null?"":request.getParameter("modifyFlag");
    String Modify = request.getParameter("Modify");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.050",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript">
<!--
function goDetailPage(type,modifyYN){
    var maxIndex = document.forms[0].rdo.length;
    var selected = false;
    var js_MdId='';
    var js_MasterDataPrcTp='';
    var js_UseTp='';
    if(maxIndex==null) maxIndex=0;
    if (maxIndex >= 2){
        for(idx=0; idx<maxIndex; idx++){
            if(document.forms[0].rdo[idx].checked){
                js_MasterDataPrcTp = document.forms[0].MasterDataPrcTp[idx].value;
                js_MdId            = document.forms[0].MdlDefineId[idx].value;
                js_UseTp           = document.forms[0].UseTp[idx].value;
                selected = true;
            }
        }
        if( !selected){
            alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
            return ;
        }
    } else {
        /*변경이력이 하나밖에 없을 경우 처리 로직*/
        js_MasterDataPrcTp = document.forms[0].MasterDataPrcTp.value;
        js_MdId            = document.forms[0].MdlDefineId.value;
        js_UseTp           = document.forms[0].UseTp.value;
    }

    if(js_MasterDataPrcTp=='1A0' || js_MasterDataPrcTp=='1A1' || js_MasterDataPrcTp=='1A2'){
        document.form_rule_data.MdlDefineId.value=js_MdId;
    } else{
        document.form_rule_data.MdRuleId.value=js_MdId;
    }

    if(type=='MODIFYDATA'){
        if(js_MasterDataPrcTp=='1A0'||js_MasterDataPrcTp=='1A2')
            document.form_rule_data.action = "m000202040.do?ServiceName=m000202040-service&saveData=true&pageSize=15";
        else if(js_MasterDataPrcTp=='1A1')
            document.form_rule_data.action = "m000202050.do?ServiceName=m000202050-service&saveData=true"
        else if(js_MasterDataPrcTp=='1B0')
            document.form_rule_data.action = "m000202070.do?ServiceName=m000202070-service&saveData=true";
        else
            document.form_rule_data.action = "m000202080.do?ServiceName=m000202080-service&saveData=true";
    }else if(type=='DATA'){
        document.form_rule_data.Modify.value="";
        if(js_MasterDataPrcTp=='1A0'||js_MasterDataPrcTp=='1A2')
            document.form_rule_data.action = "m000202040.do?ServiceName=m000202040-service";
        else if(js_MasterDataPrcTp=='1A1')
            document.form_rule_data.action = "m000202050.do?ServiceName=m000202050-service";
        else if(js_MasterDataPrcTp=='1B0')
            document.form_rule_data.action = "m000202070.do?ServiceName=m000202070-service";
         else
            document.form_rule_data.action = "m000202080.do?ServiceName=m000202080-service";
    } else { // if(type=='LAYOUT')
        if(modifyYN=='true'){
            if(js_MasterDataPrcTp=='1A0'||js_MasterDataPrcTp=='1A1'||js_MasterDataPrcTp=='1A2'){
                if(js_UseTp=='S')
                    document.form_rule_data.action = "m000202030.do?ServiceName=m000202030-service&inputLayout=true";
                else
                    document.form_rule_data.action = "m000202030.do?ServiceName=m000202030-service";
            }else{
                if(js_UseTp=='S')
                    document.form_rule_data.action = "m000202060.do?ServiceName=m000202060-service&inputLayout=true";
                else
                    document.form_rule_data.action = "m000202060.do?ServiceName=m000202060-service";
            }
        } else {
            document.form_rule_data.Modify.value="";
            if(js_MasterDataPrcTp=='1A0'||js_MasterDataPrcTp=='1A1'||js_MasterDataPrcTp=='1A2')
                document.form_rule_data.action = "m000202030.do?ServiceName=m000202030-service";
            else
                document.form_rule_data.action = "m000202060.do?ServiceName=m000202060-service";
        }
    }
    document.form_rule_data.submit();
}
-->
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.050",null,locale)%></div></td>
          <td align="right"><% if("true".equals(modifyFlag)||"&modify.x=10".equals(Modify)){%>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.ruledata",null,locale)%>" onClick='goDetailPage("MODIFYDATA","true")' style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.layout",null,locale)%>" onClick='goDetailPage("LAYOUT","true")' style="cursor:pointer"><%}else{%>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.ruledata",null,locale)%>" onClick='goDetailPage("DATA","false")' style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.layout",null,locale)%>" onClick='goDetailPage("LAYOUT","false")' style="cursor:pointer"><%}%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_rule_hitory" method="post" action="m000202010.do">
<input type="hidden" name="ServiceName" value="m000202010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="history" value="history"><!-- event -->
<input type="hidden" name="modifyFlag" value="<%= modifyFlag%>">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table id="T1" width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr class="tbldb" height="20">
                <td width="30">chk</td>
                <td width="30">no.</td>
                <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
                <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
                <td width="350"><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
                <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td width="135"><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
                <td width="135"><%=PosContext.getResourceMessage("GMResource","gm.label.0086",null,locale)%></td>
                <td width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
              </tr><%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("BusinessRuleList") : null;
    int rowCnt = 0;
    if(rowSet!=null){
        PosRow row=null;;
        while(rowSet.hasNext()){
            row = rowSet.next();
            String _UseTp = row.getAttribute("USE_TP")==null?"&nbsp;":(String)row.getAttribute("USE_TP");
            if("S".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
            else if("Y".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
            else if("N".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
            else if("F".equals(_UseTp)) _UseTp = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
%>
              <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,T1) onmouseout=in_ch(1,this,T1)>
                <td><input type="radio" name="rdo" value="<%=rowCnt%>"></td>
                <td><%=rowCnt+1%></td>
                <td><%=_UseTp%></td>
                <td><%=row.getAttribute("VERSION")==null?"&nbsp;":(String)row.getAttribute("VERSION")%></td>
                <td><%=row.getAttribute("MD_EXPLAIN")==null?"&nbsp;":(String)row.getAttribute("MD_EXPLAIN")%></td>
                <td><%=row.getAttribute("MD_NM")==null?"&nbsp;":(String)row.getAttribute("MD_NM")%></td>
                <td><%=row.getAttribute("START_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("START_ACTIVE_DATE_STR")%></td>
                <td><%=row.getAttribute("END_ACTIVE_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("END_ACTIVE_DATE_STR")%></td>
                <td><%=row.getAttribute("USER_NAME")==null?"&nbsp;":(String)row.getAttribute("USER_NAME")%></td>
                <input type="hidden" name="MdlDefineId" value="<%=row.getAttribute("MD_ID")%>">
                <input type="hidden" name="MasterDataPrcTp" value="<%=(String)row.getAttribute("MASTER_DATA_PRC_TP")%>">
                <input type="hidden" name="UseTp" value="<%=(String)row.getAttribute("USE_TP")%>">
              </tr><%
            rowCnt++;
        }
    }
%>
            </table>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
      </form>
<form name="form_rule_data" method="post"><!-- m000202030.do,m000202060.do,m000202040.do,m000202050,m000202070.do,m000202080.do-->
<input type="hidden" name="ServiceName"><!-- m000202030-service,m000202060-service,m000202040-service,m000202050-service,m000202070-service,m000202080-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=request.getParameter("MasterDataPrcTp")%>">
<input type="hidden" name="MdlDefineId">
<input type="hidden" name="MdRuleId">
<input type="hidden" name="Modify" value="&modify.x=10">
</form>
    </td>
  </tr>
</table>
</body>
</html>