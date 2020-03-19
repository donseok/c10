<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
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
 * @FileName      : 표준항목 신청현황 >> 표준항목 승인관리
 * Open Issues    :
 * Change history 
 * @2008-04-02 서정범 1.0 최초생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List progressStsList = (List) ctx.get("_SYS_F_PROGRESS_STS");
    HashMap<String, String> progressStsMap = new HashMap<String, String>();
    for (int i = 0, iz = progressStsList.size(); i < iz; i++) {
        Object[] value = (Object[]) progressStsList.get(i);
        progressStsMap.put((String)value[0], (String)value[1]);
    }

    String sDATA_ITEM_NAME=request.getParameter("DATA_ITEM_NAME")== null?"": request.getParameter("DATA_ITEM_NAME").toString();

    //메세지 가져옴.
    String sMsg = request.getParameter("msg")== null?"":request.getParameter("msg");
    PosRowSet rowset = (PosRowSet)ctx.get("RetAttrsApplyResults");
    PosRow row = rowset.next();
    String ProgressSts = row.getAttribute("PROGRESS_STS")== null ? "" : (String)row.getAttribute("PROGRESS_STS");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.011",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
/* 표준항목 등록 승인 */
function go_sign(){
    if(Trim(document.forms[0].DATA_ITEM_NAME.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0084",null,locale)%>');
        return;
    }
    if(document.forms[0].STS[0].checked==false&&document.forms[0].STS[1].checked==false&&document.forms[0].STS[2].checked==false){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0009",null,locale)%>');
        return;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>')){//저장하시겠습니까?
        if(document.forms[0].STS[0].checked==true){
            document.forms[0].PROGRESS_STS.value=2;
        }
        if(document.forms[0].STS[1].checked==true){
            document.forms[0].PROGRESS_STS.value=4;
        }
        if(document.forms[0].STS[2].checked==true){
            document.forms[0].PROGRESS_STS.value=3;
        }
        document.forms[0].msg.value='등록되었습니다';
        document.forms[0].action=document.forms[0].action+"?sign=10";
        document.forms[0].target="_top";
        document.forms[0].submit();
    }
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="420" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_std_data" method="post" action="m000209020.do">
<input type="hidden" name="ServiceName" value="m000209020-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="msg" value="<%=sMsg%>"/>
<input type="hidden" name="DATA_ITEM_NAME" value="<%=sDATA_ITEM_NAME%>">
<input type="hidden" name="PROGRESS_STS" value="<%=ProgressSts%>">
      <table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.011",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.label.0181",null,locale)%></div>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height="23">
                <td class=tbldb width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0209",null,locale)%></td>
                <td width="100">&nbsp;<%=row.getAttribute("SYS_TP_2")==null?"":row.getAttribute("SYS_TP_2").toString()%></td>
                <td class=tbldb width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0047",null,locale)%></td>
                <td width="100">&nbsp;<%=row.getAttribute("CHAIN_CODE")==null?"":row.getAttribute("CHAIN_CODE").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0197",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("DATA_ITEM_NAME")==null?"":row.getAttribute("DATA_ITEM_NAME").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
                <td>&nbsp;<%=row.getAttribute("DATA_TYPE")==null?"":row.getAttribute("DATA_TYPE").toString()%></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td>&nbsp;<%=row.getAttribute("DATA_NUMBER")==null?"":row.getAttribute("DATA_NUMBER").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
                <td>&nbsp;<%=row.getAttribute("DECIMAL_NUMBER")==null?"":row.getAttribute("DECIMAL_NUMBER").toString()%></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td>&nbsp;<%=row.getAttribute("DATA_UNIT")==null?"":row.getAttribute("DATA_UNIT").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("CODE_YN")==null?"":row.getAttribute("CODE_YN").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0021",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("KOR_ABBR")==null?"":row.getAttribute("KOR_ABBR").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0020",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("ENG_ABBR")==null?"":row.getAttribute("ENG_ABBR").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0206",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("DATA_SYNONYMOUS_1")==null?"":row.getAttribute("DATA_SYNONYMOUS_1").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0207",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("DATA_SYNONYMOUS_2")==null?"":row.getAttribute("DATA_SYNONYMOUS_2").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0208",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("DATA_SYNONYMOUS_3")==null?"":row.getAttribute("DATA_SYNONYMOUS_3").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0067",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("OTHER_TERMS")==null?"":row.getAttribute("OTHER_TERMS").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0049",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("OWNER_DEPT")==null?"":row.getAttribute("OWNER_DEPT").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0256",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("DATA_ITEM_DESCRIPT")==null?"":row.getAttribute("DATA_ITEM_DESCRIPT").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0025",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("SUBC_NM")==null?"":row.getAttribute("SUBC_NM").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0026",null,locale)%></td>
                <td colspan="3">&nbsp;<%=row.getAttribute("REQUEST_DATE_STR")==null?"":row.getAttribute("REQUEST_DATE_STR").toString()%></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0110",null,locale)%></td>
                <td colspan="3">&nbsp;<input type="text" name="DATA_VAR_ID" size="38" value="<%=row.getAttribute("DATA_VAR_ID")==null?"":row.getAttribute("DATA_VAR_ID").toString()%>" class=adb1></td>
              </tr>
              <tr height="23">
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0180",null,locale)%></td>
                <td colspan="3">&nbsp;<textarea rows="5" name="INVEST_RESULT" cols="45" class=adb1><%=row.getAttribute("INVEST_RESULT")==null?"":row.getAttribute("INVEST_RESULT").toString()%></textarea></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td height=30 valign=bottom align=center><b>
            <input type="radio" name="STS" value="2" <%=("2".equals(ProgressSts)==true?"checked":"")%>><%=progressStsMap.get("2")%>&nbsp;
            <input type="radio" name="STS" value="4" <%=("4".equals(ProgressSts)==true?"checked":"")%>><%=progressStsMap.get("4")%>&nbsp;
            <input type="radio" name="STS" value="3" <%=("3".equals(ProgressSts)==true?"checked":"")%>><%=progressStsMap.get("3")%></b>
          </td>
        </tr>
        <tr>
          <td height=40 valign=bottom align=center><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onclick="go_sign()" style="cursor:pointer"><!-- confirm --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.cancel",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- cancel -->
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
</body>
<script type="text/javascript">
  if(document.forms[0].msg.value!="")
  {
    alert(document.forms[0].msg.value);
  }
</script>
</html>