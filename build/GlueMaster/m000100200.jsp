<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.lang.StringBuffer"%>
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
 * @FileName      : MasterData 이행
 * Open Issues    :
 * Change history 
 * @2012-07-09 배광식 #1.3.9 최초 생성
 * @2012-08-09 황유진 #1.4.2 연관테이블 이행
 * @2012-08-28 황유진 #1.4.4 JCS이행시 권한체크 기능 추가
 */

    PosContext ctx = (PosContext) request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale) pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosUserIF user = ctx==null ? null : (PosUserIF)ctx.getSessionUserData(PosSecurityConstants.USER);
    String UserEmpNo = null;
    boolean isAdmin = false;
    if (user==null) {
        UserEmpNo = request.getParameter("hidden_id") == null ? request.getParameter("UserEmpNo") : request.getParameter("hidden_id");
        UserEmpNo = UserEmpNo == null ? "MASTDATA" : UserEmpNo; //시큐리티 적용전 임시
        isAdmin = "MASTDATA".equals(UserEmpNo);
    } else {
        UserEmpNo = user.getUserID();
        PosSecurityUtil.checkPageID("m000100200");
        isAdmin = PosMenu.getCurPage().isPermitAction("save");//import,jcs,layout,new,insert,update,save,delete
    }

    String sSystemType = request.getParameter("SearchSystemType") == null ? "%" : request.getParameter("SearchSystemType");

    // Caching Data
    List SYS_F_DATASOURCE_TYPE = (List) ctx.get("_SYS_F_DATASOURCE_TYPE");
    List SYS_V_DB_HOST_TP = (List) ctx.get("_SYS_V_DB_HOST_TP");
    List SYS_V_JDBC_CLASS = (List) ctx.get("_SYS_V_JDBC_CLASS");
    HashMap<String, String> typeMap = new HashMap<String, String>();
    for (int i = 0, iz = SYS_V_DB_HOST_TP.size(); i < iz; i++) {
        Object[] value = (Object[]) SYS_V_DB_HOST_TP.get(i);
        typeMap.put((String)value[0], (String)value[1]);
    }

    List codeList = (List)ctx.get("jcs_CdTp_list");
    List codeIdList = (List)ctx.get("jcs_CdTpId_list");
    List ruleList = (List)ctx.get("jcs_MdlDefineNm_list");
    String[] masterDataId = (String[]) ctx.get("MasterDataId");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.093",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript">
<!--
function goPop01(){
    showPopup("","m000100200_pop01",936,500,'1',0,0,1,1,1,0,0);
    document.form_pop01.target="m000100200_pop01";
    document.form_pop01.submit();
}
/* 확인(적용) 버튼을 누를때 */
function gm_sync(){
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

    var isMasterDataId = false;
    if(document.forms[0].MasterDataId.length>1){
        for(var i=0;i<document.forms[0].MasterDataId.length;i++){
            if(document.forms[0].MasterDataId[i].value != ""){
                isMasterDataId=true;
            }
        }
    }

    if(isCheckedOne==false || isMasterDataId==false){
        alert('<%=PosContext.getResourceMessage("GMResource", "gm.msg.0107", null, locale)%>');//이행할 Data를 선택하십시요
        return;
    } else {
        if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0111",null,locale)%>')){//이행하시겠습니까?
        document.forms[0].action=document.forms[0].action+"?sync=10";
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
function goPop02(){
    if((document.form_pop02.CdTp.value != "" && document.form_pop02.CdTpId.value != "") || document.form_pop02.MdlDefineNm.value != ""){
        showPopup("","m000100200_pop02",476,500,'1',0,0,1,1,1,0,0);
        document.form_pop02.target="m000100200_pop02";
        document.form_pop02.submit();
    }
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="goPop02()">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
  <tr id=gm_logo>
    <td><img src="/img/m000001img.gif" width="1000" height="40"></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5">
        <tr height="23">
          <td id=gm_BreadCrumbs valign="middle"><!--BreadCrumbs 네비게이션 링크 출력--></td>
          <td id=gm_showDate><div align="right"><posui:showDate /></div></td>
        </tr>
      </table>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family: Verdana; font-size: 16px; font-weight: bold; color: 000033"><%=PosContext.getResourceMessage("GMResource","gm.title.093",null,locale)%></div></td>
          <td align=right><img src="img/gmbut0006.gif" onclick="goPop01()"></td>
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
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr valign=bottom height=20>
          <td><div id=gm_tb_title style="font-family: Verdana; font-size: 14px; font-weight: bold; color: 000033"><%=PosContext.getResourceMessage("GMResource","gm.title.094",null,locale)%></div></td>
        </tr>
        <tr height=25>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="20">
                <td align="left"><img src="img/gm0008img.gif">&nbsp;
                  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0272",null,locale)%> : </b>
                  <select name="SearchSystemType" class="adf">
                    <option value="%" <%="%".equals(sSystemType) ? "selected" : ""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0273",null,locale)%></option><%
    for (int i = 0, iz = SYS_V_DB_HOST_TP.size(); i < iz; i++) {
        Object[] value = (Object[]) SYS_V_DB_HOST_TP.get(i);
%>
                    <option value="<%=value[0]%>" <%=value[0].equals(sSystemType) ? "selected" : ""%>>[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>&nbsp;&nbsp;
                  <input type="checkbox" name="chk_includeSys" value="true"><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%>
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="document.forms[0].submit()" style="cursor:pointer"><!-- find --><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onClick="gm_sync()" style="cursor:pointer"><!-- sync --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
            <table id=tTable width="964" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr class="tbldb" height="20">
                <td width=50><img src="img/gm0004img.gif" onClick="gm_select_all()" style="cursor:pointer"></td>
                <td width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0272",null,locale)%></td>
                <td width=300><%=PosContext.getResourceMessage("GMResource","gm.label.0274",null,locale)%></td>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0275",null,locale)%></td>
              </tr>
            </table>
            <DIV id=divBody STYLE='position:relative;overflow-y:scroll;width:980;height:111;top:0;left:0;'>
            <table id=mainTable width="964" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"><%
        PosRowSet rowset = ctx != null ? (PosRowSet) ctx.get("TbM00DbmsConInfoResult") : null;
        int rowCnt = 0;
        if (rowset != null) {
            PosRow row = null;
            while (rowset.hasNext()) {
                row = rowset.next();
%>
              <tr index=<%=rowCnt%> class="<%=(rowCnt % 2 == 0) ? "tblcw" : "tblcg"%>" height="20" onmouseover=in_ch(0,this,mainTable) onmouseout=in_ch(1,this,mainTable)>
                <td index=<%=rowCnt%> width=50>
                  <input type="checkbox" name="chk" value="<%=rowCnt%>">
                  <input type="hidden" name="DATASOURCE_ID" value="<%=row.getAttribute("DATASOURCE_ID") == null ? "&nbsp;" : row.getAttribute("DATASOURCE_ID").toString()%>">
                  <input type="hidden" name="DATASOURCE_TYPE" value="<%=row.getAttribute("DATASOURCE_TYPE") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE_TYPE")%>">
                  <input type="hidden" name="DATASOURCE" value="<%=row.getAttribute("DATASOURCE") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE")%>">
                  <input type="hidden" name="DATASOURCE_EXPLAIN" value="<%=row.getAttribute("DATASOURCE_EXPLAIN") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE_EXPLAIN")%>">
                  <input type="hidden" name="DATASOURCE_DRIVER_CLASS" value="<%=row.getAttribute("DATASOURCE_DRIVER_CLASS") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE_DRIVER_CLASS")%>">
                  <input type="hidden" name="DATASOURCE_ACCOUNT" value="<%=row.getAttribute("DATASOURCE_ACCOUNT") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE_ACCOUNT")%>">
                  <input type="hidden" name="DATASOURCE_PASSWORD" value="<%=row.getAttribute("DATASOURCE_PASSWORD") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE_PASSWORD")%>">
                </td>
                <td index=<%=rowCnt%> width=100><%=row.getAttribute("SYSTEM_TYPE") == null ? "&nbsp;" : "["+(String) row.getAttribute("SYSTEM_TYPE")+"]"+typeMap.get(row.getAttribute("SYSTEM_TYPE"))%></td>
                <td index=<%=rowCnt%> width=300><%=row.getAttribute("DATASOURCE_EXPLAIN") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE_EXPLAIN")%></td>
                <td index=<%=rowCnt%>><%=row.getAttribute("DATASOURCE") == null ? "&nbsp;" : (String) row.getAttribute("DATASOURCE")%></td>
              </tr><%
                rowCnt++;
            }
            rowset.reset();
        }
%>
            </table>
            </div>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr valign=bottom height=30>
          <td><div id=gm_tb_title style="font-family: Verdana; font-size: 14px; font-weight: bold; color: 000033"><%=PosContext.getResourceMessage("GMResource","gm.title.095",null,locale)%></div></td>
        </tr>
        <tr>
          <td valign=top align="left" height="18">
            <table id="dataTable" width="100%" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr class="tbldb" height="20">
                <td width=100><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0276",null,locale)%></td>
              </tr>
              <tr class="tblcw" height="20" onmouseover=in_ch(0,this,dataTable) onmouseout=in_ch(1,this,dataTable)>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0277",null,locale)%><input type="hidden" name="MasterDataType" value="CODE"></td>
                <td><input type=text name="MasterDataId" value="<%=masterDataId != null && masterDataId[0] != null ? masterDataId[0] : ""%>" class="adb1" size=160></td>
              </tr>
              <tr class="tblcg" height="20" onmouseover=in_ch(0,this,dataTable) onmouseout=in_ch(1,this,dataTable)>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0278",null,locale)%><input type="hidden" name="MasterDataType" value="DEFINE"></td>
                <td><input type=text name="MasterDataId" value="<%=masterDataId != null && masterDataId[1] != null ? masterDataId[1] : ""%>" class="adb1" size=160></td>
              </tr>
              <tr class="tblcw" height="20" onmouseover=in_ch(0,this,dataTable) onmouseout=in_ch(1,this,dataTable)>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0279",null,locale)%><input type="hidden" name="MasterDataType" value="RULE"></td>
                <td><input type=text name="MasterDataId" value="<%=masterDataId != null && masterDataId[2] != null ? masterDataId[2] : ""%>" class="adb1" size=160></td>
              </tr>
              <tr class="tblcg" height="20" onmouseover=in_ch(0,this,dataTable) onmouseout=in_ch(1,this,dataTable)>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0280",null,locale)%><input type="hidden" name="MasterDataType" value="CALC"></td>
                <td><input type=text name="MasterDataId" value="<%=masterDataId != null && masterDataId[3] != null ? masterDataId[3] : ""%>" class="adb1" size=160></td>
              </tr>
              <tr class="tblcw" height="20" onmouseover=in_ch(0,this,dataTable) onmouseout=in_ch(1,this,dataTable)>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0281",null,locale)%><input type="hidden" name="MasterDataType" value="FORMAT"></td>
                <td><input type=text name="MasterDataId" value="<%=masterDataId != null && masterDataId[4] != null ? masterDataId[4] : ""%>" class="adb1" size=160></td>
              </tr>
              <tr class="tblcg" height="20" onmouseover=in_ch(0,this,dataTable) onmouseout=in_ch(1,this,dataTable)>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0211",null,locale)%><input type="hidden" name="MasterDataType" value="TC"></td>
                <td><input type=text name="MasterDataId" value="<%=masterDataId != null && masterDataId[5] != null ? masterDataId[5] : ""%>" class="adb1" size=160></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr valign=bottom height=35>
          <td><div id=gm_tb_title style="font-family: Verdana; font-size: 14px; font-weight: bold; color: 000033"><%=PosContext.getResourceMessage("GMResource","gm.title.096",null,locale)%></div></td>
        </tr>
        <tr>
          <td valign=top align="left" width="100%"><textarea rows=10 style="width:100%"><%=ctx.get("SyncResult") == null ? "&nbsp;" : (String) ctx.get("SyncResult")%></textarea></td>
        </tr>
      </table>
</form>
<form name="form_pop01" method="post" action="m000100200.do">
<input type="hidden" name="ServiceName" value="m000100200-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID") == null ? "SecurityError" : request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="pop01" value="10"><!-- event -->
</form>
<form name="form_pop02" method="post" action="m000100200.do">
<input type="hidden" name="ServiceName" value="m000100200-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID") == null ? "SecurityError" : request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="pop02" value="10"><!-- event --><%

    StringBuffer CdTp = new StringBuffer();
    StringBuffer CdTpId = new StringBuffer();
    StringBuffer MdlDefineNm = new StringBuffer();
    
    if(codeList!=null && codeList.size()>0){
        String code;
        String codeId;
        for (int i = 0, iz = codeList.size(); i < iz; i++) {
            code = (String) codeList.get(i);
            codeId = String.valueOf((Object)codeIdList.get(i));
            if(i != 0){
                CdTp.append("|");
                CdTpId.append("|");
            }
            CdTp.append(code);
            CdTpId.append(codeId);
        }
    }
    if(ruleList != null && ruleList.size() > 0){
        String rule;
        for (int i = 0, iz = ruleList.size(); i < iz; i++) {
            rule = (String) ruleList.get(i);
            if(i != 0){
                MdlDefineNm.append("|");
            }
            MdlDefineNm.append(rule);
        }
    }
%>
<input type="hidden" name="CdTp" value="<%=CdTp.toString()%>">
<input type="hidden" name="CdTpId" value="<%=CdTpId.toString()%>">
<input type="hidden" name="MdlDefineNm" value="<%=MdlDefineNm.toString()%>">
</form>
    </td>
  </tr>
</table>
</body>
</html>