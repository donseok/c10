<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="com.posdata.glue.context.PosContext"%>
<%@ page import="com.posdata.glue.dao.vo.PosRow"%>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet"%>
<%@ page import="com.posdata.glue.web.control.PosWebConstants"%>
<%@ page import="com.posdata.glue.web.security.PosSecurityConstants"%>
<%@ page import="com.posdata.glue.web.security.PosSecurityUtil"%>
<%@ page import="com.posdata.glue.web.security.PosUserIF"%>
<%@ page import="com.posdata.glue.web.security.PosMenu"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui"%>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui"%>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean" />
<posglobalui:setResourceName name="GMResource" />
<%
/*
 * @FileName      : 이행 대상 시스템 관리
 * Open Issues    :
 * Change history 
 * @2012-07-09 배광식 #1.3.9 최초 생성
 */

    PosContext ctx = (PosContext) request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale) pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    // Caching Data
    List SYS_F_DATASOURCE_TYPE = (List) ctx.get("_SYS_F_DATASOURCE_TYPE");
    List SYS_V_DB_HOST_TP = (List) ctx.get("_SYS_V_DB_HOST_TP");
    List SYS_V_JDBC_CLASS = (List) ctx.get("_SYS_V_JDBC_CLASS");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.097",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
<!--
/* 저장버튼을 누를때 */
function gm_save(){
    var isCheckedOne=false;
    if(document.forms[0].DATASOURCE_ID.length>1){
        for(var i=0;i<document.forms[0].DATASOURCE_ID.length;i++){
            document.forms[0].chk[i].value = i;
            if(document.forms[0].chk[i].checked==true){
                isCheckedOne=true;
            }
        }
    }else{
        isCheckedOne = document.forms[0].chk.checked;
    }

    if(isCheckedOne==false){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return;
    }else{
        if(document.forms[0].DATASOURCE_ID.length>1){
            for(var i=0;i<document.forms[0].DATASOURCE_ID.length;i++){
                if(document.forms[0].chk[i].checked==true){
                    if(Trim(document.forms[0].DATASOURCE[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource", "gm.msg.0108", null, locale)%>'); //DataSource를 입력하여 주십시요
                        return;
                    }else if(Trim(document.forms[0].DATASOURCE_EXPLAIN[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource", "gm.msg.0109", null, locale)%>'); //DataSource설명을 입력하여 주십시요
                        return;
                    }else if(Trim(document.forms[0].DATASOURCE_PASSWORD[i].value)!=""){
                        if(Trim(document.forms[0].DATASOURCE_PASSWORD_OLD[i].value)!=""){
                            if(document.forms[0].DATASOURCE_PASSWORD_OLD[i].value == document.forms[0].DATASOURCE_PASSWORD[i].value){
                                alert('<%=PosContext.getResourceMessage("GMResource", "gm.msg.0110", null, locale)%>'); //암호를 다시 입력하여 주십시요
                                return;
                            }
                        }
                    }
                }
            }
        }else{
            if(document.forms[0].chk.checked==true){
                if(Trim(document.forms[0].DATASOURCE.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource", "gm.msg.0108", null, locale)%>'); //DataSource를 입력하여 주십시요
                    return;
                }else if(Trim(document.forms[0].DATASOURCE_EXPLAIN.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource", "gm.msg.0109", null, locale)%>'); //DataSource설명을 입력하여 주십시요
                    return;
                }else if(Trim(document.forms[0].DATASOURCE_PASSWORD.value)!=""){
                    if(Trim(document.forms[0].DATASOURCE_PASSWORD_OLD.value)!=""){
                        alert(document.forms[0].DATASOURCE_PASSWORD_OLD.value);
                        alert(document.forms[0].DATASOURCE_PASSWORD.value);
                        if(document.forms[0].DATASOURCE_PASSWORD_OLD.value == document.forms[0].DATASOURCE_PASSWORD.value){
                            alert('<%=PosContext.getResourceMessage("GMResource", "gm.msg.0110", null, locale)%>'); //암호를 다시 입력하여 주십시요
                            return;
                        }
                    }
                }
            }
        }
        if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>')){//저장하시겠습니까?
            document.forms[0].action = document.forms[0].action+"?save=10";
            document.forms[0].submit();
        }
    }
}
/* 삭제버튼을 누를때 */
function gm_delete(){
    var isCheckedOne=false;
    if(document.forms[0].DATASOURCE_ID.length>1){
        for(var i=0;i<document.forms[0].DATASOURCE_ID.length;i++){
            document.forms[0].chk[i].value = i;
            if(document.forms[0].chk[i].checked==true){
                isCheckedOne=true;
            }
        }
    }else{
        isCheckedOne = document.forms[0].chk.checked;
    }

    if(isCheckedOne==false){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return;
    } else{
        if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0029",null,locale)%>')){//삭제 하시겠습니까?
            document.forms[0].action = document.forms[0].action+"?delete=10";
            document.forms[0].submit();
        }
    }
}
/* 전체선택 */
function gm_select_all(){
    if (document.forms[0].chk.length >= 2){
        for(i=0; i<document.forms[0].chk.length; i++){
            document.forms[0].chk[i].checked = !document.forms[0].chk[i].checked;
        }
    }else{
        document.forms[0].chk.checked = !document.forms[0].chk.checked;
    }
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
    <table width="920" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="e5e5e5">
            <td id=gm_showDate>
                <div align="right"><posui:showDate /></div>
            </td>
        </tr>
        <tr>
            <td valign=top>
                <table width="900" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr height=25>
                        <td><div id=gm_title style="font-family: Verdana; font-size: 16px; font-weight: bold; color: 000033"><%=PosContext.getResourceMessage("GMResource","gm.title.097",null,locale)%></div></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <form name="form_main_code" method="post" action="m000100200.do">
                <input type="hidden" name="ServiceName" value="m000100200-service">
                <input type="hidden" name="pageID" value="<%=request.getParameter("pageID") == null ? "SecurityError" : request.getParameter("pageID")%>">
                <input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
                <input type="hidden" name="isAdmin" value="<%=isAdmin%>">
                <table width="900" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
                    </tr>
                    <tr>
                        <td align="left">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr height="18">
                                        <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="javascript:insRow(mainTable,hiddenTable,null)" style="cursor:pointer"><!-- add row -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="gm_save()" style="cursor:pointer"><!-- save -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.delete",null,locale)%>" onClick="gm_delete()" style="cursor:pointer"><!-- delete -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                                        </td>
                                    </tr>
                                </table>
                        </td>
                    </tr>
                    <tr>
                        <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
                    </tr>
                    <tr>
                        <td valign=top align="left" height="18">
                            <table id=Ttable width="900" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
                                <tr class="tbldb" height="20">
                                    <td width=40><img src="img/gm0004img.gif" onClick="gm_select_all()" style="cursor:pointer"></td>
                                    <td width=90><%=PosContext.getResourceMessage("GMResource","gm.label.0272",null,locale)%></td>
                                    <td width=70><%=PosContext.getResourceMessage("GMResource","gm.label.0282",null,locale)%></td>
                                    <td><%=PosContext.getResourceMessage("GMResource","gm.label.0275",null,locale)%></td>
                                    <td width=140><%=PosContext.getResourceMessage("GMResource","gm.label.0274",null,locale)%></td>
                                    <td width=110><%=PosContext.getResourceMessage("GMResource","gm.label.0283",null,locale)%></td>
                                    <td width=90><%=PosContext.getResourceMessage("GMResource","gm.label.0284",null,locale)%></td>
                                    <td width=90><%=PosContext.getResourceMessage("GMResource","gm.label.0285",null,locale)%></td>
                                </tr>
                            </table>
                            <table id=mainTable width="900" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
<%
    PosRowSet rowset = ctx != null ? (PosRowSet) ctx.get("TbM00DbmsConInfoResult") : null;
    int rowCnt = 0;
    if (rowset != null && rowset.hasNext()) {
        PosRow row = null;
        while (rowset.hasNext()) {
            row = rowset.next();
%>
                                    <tr index=<%=rowCnt%> class="<%=(rowCnt % 2 == 0) ? "tblcw" : "tblcg"%>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
                                        <td index=<%=rowCnt%> width=40><input type="checkbox" name="chk" value="<%=rowCnt%>"><input type="hidden" name="DATASOURCE_ID" value="<%=row.getAttribute("DATASOURCE_ID")%>"></td>
                                        <td index=<%=rowCnt%> width=90>
                                            <select name="SYSTEM_TYPE" class="adf" style="width:85">
                                                <%
                                                    for (int i = 0, iz = SYS_V_DB_HOST_TP.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_V_DB_HOST_TP.get(i);
                                                %>
                                                <option value="<%=value[0]%>" <%=value[0].equals(row.getAttribute("SYSTEM_TYPE")) ? "selected" : ""%>><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td index=<%=rowCnt%> width=70>
                                            <select name="DATASOURCE_TYPE" class="adf" style="width:65">
                                                <%
                                                    for (int i = 0, iz = SYS_F_DATASOURCE_TYPE.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_F_DATASOURCE_TYPE.get(i);
                                                %>
                                                <option value="<%=value[0]%>" <%=value[0].equals(row.getAttribute("DATASOURCE_TYPE")) ? "selected" : ""%>><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td index=<%=rowCnt%>><textarea name="DATASOURCE" class="adb1" style="width:240"><%=row.getAttribute("DATASOURCE")%></textarea></td>
                                        <td index=<%=rowCnt%> width=140><input type=text name="DATASOURCE_EXPLAIN" value="<%=row.getAttribute("DATASOURCE_EXPLAIN")%>" class="adb1" size=20></td>
                                        <td index=<%=rowCnt%> width=110>
                                            <select name="DATASOURCE_DRIVER_CLASS" class="adf" style="width:105">
                                                <option value="" <%="".equals(row.getAttribute("DATASOURCE_DRIVER_CLASS")) ? "selected" : ""%>></option>
                                                <%
                                                    for (int i = 0, iz = SYS_V_JDBC_CLASS.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_V_JDBC_CLASS.get(i);
                                                %>
                                                <option value="<%=value[0]%>" <%=value[0].equals(row.getAttribute("DATASOURCE_DRIVER_CLASS")) ? "selected" : ""%>><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td index=<%=rowCnt%> width=90><input type=text name="DATASOURCE_ACCOUNT" value="<%=row.getAttribute("DATASOURCE_ACCOUNT")==null?"":(String)row.getAttribute("DATASOURCE_ACCOUNT")%>" class="adb1" size=10></td>
                                        <td index=<%=rowCnt%> width=90>
                                            <input type=text name="DATASOURCE_PASSWORD" value="<%=row.getAttribute("DATASOURCE_PASSWORD")==null?"":(String)row.getAttribute("DATASOURCE_PASSWORD")%>" class="adb1" size=10>
                                            <input type=hidden name="DATASOURCE_PASSWORD_OLD" value="<%=row.getAttribute("DATASOURCE_PASSWORD")==null?"":(String)row.getAttribute("DATASOURCE_PASSWORD")%>">
                                        </td>
                                    </tr>
<%
    rowCnt++;
        }
        rowset.reset();
    } else {
%>
                                    <tr index=0 class=tblcw>
                                        <td index=0 width=40><input type="checkbox" name="chk" value="0"><input type="hidden" name="DATASOURCE_ID" value="-1"></td>
                                        <td index=0 width=90>
                                            <select name="SYSTEM_TYPE" class="adf" style="width:85">
                                                <%
                                                    for (int i = 0, iz = SYS_V_DB_HOST_TP.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_V_DB_HOST_TP.get(i);
                                                %>
                                                <option value="<%=value[0]%>"><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td index=0 width=70>
                                            <select name="DATASOURCE_TYPE" class="adf" style="width:65">
                                                <%
                                                    for (int i = 0, iz = SYS_F_DATASOURCE_TYPE.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_F_DATASOURCE_TYPE.get(i);
                                                %>
                                                <option value="<%=value[0]%>"><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td index=0><textarea name="DATASOURCE" class="adb1" style="width:240"></textarea></td>
                                        <td index=0 width=140><input type=text name="DATASOURCE_EXPLAIN" class="adb1" size=20></td>
                                        <td index=0 width=110>
                                            <select name="DATASOURCE_DRIVER_CLASS" class="adf" style="width:105">
                                                <option value=""></option>
                                                <%
                                                    for (int i = 0, iz = SYS_V_JDBC_CLASS.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_V_JDBC_CLASS.get(i);
                                                %>
                                                <option value="<%=value[0]%>"><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td index=0 width=90><input type=text name="DATASOURCE_ACCOUNT" class="adb1" size=10></td>
                                        <td index=0 width=90><input type=text name="DATASOURCE_PASSWORD" class="adb1" size=10><input type=hidden name="DATASOURCE_PASSWORD_OLD"></td>
                                    </tr>
<%
    }
%>
                            </table>
                        </td>
                    </tr>
                </table>
                </form>
                <div STYLE="display: none">
                    <table id=hiddenTable width="900" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
                        <tr index=1 class=tblcw>
                            <td index=1 width=40><input type="checkbox" name="chk" value="0" checked><input type="hidden" name="DATASOURCE_ID" value="-1"></td>
                            <td index=1 width=90>
                                <select name="SYSTEM_TYPE" class="adf" style="width:85">
                                                <%
                                                    for (int i = 0, iz = SYS_V_DB_HOST_TP.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_V_DB_HOST_TP.get(i);
                                                %>
                                                <option value="<%=value[0]%>"><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                </select>
                            </td>
                            <td index=1 width=70>
                                <select name="DATASOURCE_TYPE" class="adf" style="width:65">
                                                <%
                                                    for (int i = 0, iz = SYS_F_DATASOURCE_TYPE.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_F_DATASOURCE_TYPE.get(i);
                                                %>
                                                <option value="<%=value[0]%>"><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                </select>
                            </td>
                            <td index=1><textarea name="DATASOURCE" class="adb1" style="width:240"></textarea></td>
                            <td index=1 width=140><input type=text name="DATASOURCE_EXPLAIN" class="adb1" size=20></td>
                            <td index=1 width=110>
                                <select name="DATASOURCE_DRIVER_CLASS" class="adf" style="width:105">
                                    <option value=""></option>
                                                <%
                                                    for (int i = 0, iz = SYS_V_JDBC_CLASS.size(); i < iz; i++) {
                                                        Object[] value = (Object[]) SYS_V_JDBC_CLASS.get(i);
                                                %>
                                                <option value="<%=value[0]%>"><%=value[1]%></option>
                                                <%
                                                    }
                                                %>
                                </select>
                            </td>
                            <td index=1 width=90><input type=text name="DATASOURCE_ACCOUNT" class="adb1" size=10></td>
                            <td index=1 width=90><input type=text name="DATASOURCE_PASSWORD" class="adb1" size=10><input type=hidden name="DATASOURCE_PASSWORD_OLD"></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</body>
</html>
