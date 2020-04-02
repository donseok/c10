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
 * @FileName      : 표준용어 목록 >> 표준용어 조회
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20110701
 * @Author        : 황유진
 * @LastModifier  : 황유진
 * @LastVersion   :  1.0
 *    2010-07-01   다국어 지원
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List termSectionList = (List) ctx.get("_SYS_V_TERMS_SECTION");
    HashMap<String, String> termSectionMap = new HashMap<String, String>();
    for (int i = 0, iz = termSectionList.size(); i < iz; i++) {
        Object[] value = (Object[]) termSectionList.get(i);
        termSectionMap.put((String)value[0], (String)value[1]);
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.003",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.003",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_word_data" method="post" action="m000207110.do">
<input type="hidden" name="ServiceName" value="m000207110-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="SearchTypeLOV" value="STD_TERMS_NAME">
<input type="hidden" name="SearchWord" value="<%=request.getParameter("SearchWord")%>">
<input type="hidden" name=isPageSet value=false>
<input type="hidden" name=modify value=modify><!-- event -->
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.edit",null,locale)%>" onClick="document.forms[0].submit();" style="cursor:pointer"><!-- modify --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td valign=top align="left"><%

    PosRowSet rowset = (PosRowSet)ctx.get("WordList");
    int rowCnt = 0;
    if( rowset!=null && rowset.hasNext()){
        PosRow row = rowset.next();
%>
<table width=100% border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
  <tr class="tbldb" height=20>
    <th colspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0198",null,locale)%></th>
    <th><%=PosContext.getResourceMessage("GMResource","gm.label.0174",null,locale)%></th>
    <th width=410><%=PosContext.getResourceMessage("GMResource","gm.label.0090",null,locale)%></th>
  </tr>
  <tr class="tblcw" height=20>
    <td colspan=2><%=row.getAttribute("STD_TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("STD_TERMS_NAME")%></td>
    <td><%=row.getAttribute("REGISTER_DATE_STR")==null?"&nbsp;":(String)row.getAttribute("REGISTER_DATE_STR")%></td>
    <td rowspan=3><textarea name=OtherTerms style="width:400;height:50" class=adb1><%=row.getAttribute("OTHER_TERMS")==null?"":(String)row.getAttribute("OTHER_TERMS")%></textarea></td>
  </tr>
  <tr class="tbldb" height=20>
    <th>영문ID</th>
    <th>영문약어</th>
    <th>담당부문</th>
  </tr>
  <tr class="tblcw" height=20>
    <td><%=row.getAttribute("ENG_ID")==null?"&nbsp;":(String)row.getAttribute("ENG_ID")%></td>
    <td><%=row.getAttribute("ENG_ABBR")==null?"&nbsp;":(String)row.getAttribute("ENG_ABBR")%></td>
    <td><%=row.getAttribute("OWNER_DEPT")==null?"&nbsp;":(String)row.getAttribute("OWNER_DEPT")%></td>
  </tr>
</table>
<table width=100% border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
  <tr class="tbldb" height="20">
    <th width="35">chk</th>
    <th width="40"><%=PosContext.getResourceMessage("GMResource","gm.label.0004",null,locale)%></th>
    <th width="100"><%=PosContext.getResourceMessage("GMResource","gm.label.0267",null,locale)%></th>
    <th width="310"><%=PosContext.getResourceMessage("GMResource","gm.label.0253",null,locale)%></th>
    <th width="70"><%=PosContext.getResourceMessage("GMResource","gm.label.0252",null,locale)%></th>
    <th width="70">체인코드</th>
    <th width="270" colspan=3><%=PosContext.getResourceMessage("GMResource","gm.label.0205",null,locale)%></th>
    <th width="65">신청자</th>
  </tr><%
        rowset.reset();
        while(rowset.hasNext()){
            row = rowset.next();
            String TermsSection = row.getAttribute("TERMS_SECTION")==null||!termSectionMap.containsKey((String)row.getAttribute("TERMS_SECTION"))?"":termSectionMap.get((String)row.getAttribute("TERMS_SECTION"));
%>
  <tr class="<%= (rowCnt%2==0) ? "tblcg" : "tblcw" %>">
    <td><input type="checkbox" name="chk" value="<%=rowCnt%>" class=adb1></td>
    <td><%=row.getAttribute("LANGUAGE_CODE")==null?"&nbsp;":(String)row.getAttribute("LANGUAGE_CODE")%><input type="hidden" name="LanguageCodeHidden" value="<%=(String)row.getAttribute("LANGUAGE_CODE")%>"></td>
    <td><%=row.getAttribute("TERMS_NAME")==null?"&nbsp;":(String)row.getAttribute("TERMS_NAME")%><input type="hidden" name="TermsName" value="<%=(String)row.getAttribute("TERMS_NAME")%>"></td>
    <td><textarea name=TermsDescript style="width:300;height:50" class=adb1><%=row.getAttribute("TERMS_DESCRIPT")==null?"":(String)row.getAttribute("TERMS_DESCRIPT")%></textarea></td>
    <td><%=TermsSection%></td>
    <td><%=row.getAttribute("CHAIN_CODE")==null?"&nbsp;":(String)row.getAttribute("CHAIN_CODE")%></td>
    <td><input type="text" name=Synonymous1 value="<%=row.getAttribute("SYNONYMOUS_1")==null?"":(String)row.getAttribute("SYNONYMOUS_1")%>" style="width:85" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
    <td><input type="text" name=Synonymous2 value="<%=row.getAttribute("SYNONYMOUS_2")==null?"":(String)row.getAttribute("SYNONYMOUS_2")%>" style="width:85" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
    <td><input type="text" name=Synonymous3 value="<%=row.getAttribute("SYNONYMOUS_3")==null?"":(String)row.getAttribute("SYNONYMOUS_3")%>" style="width:85" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></td>
    <td><%=row.getAttribute("SUBC_NM")==null?"&nbsp;":(String)row.getAttribute("SUBC_NM")%></td>
  </tr><%
            rowCnt++;
        }
    }
%>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
      </form>
    </td>
  </tr>
</table>
</body>
</html>