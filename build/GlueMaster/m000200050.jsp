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
 * @FileName      : [m000202030layout.jsp]업무기준 레이아웃 수정 >> 표준항목 비표준항목관리
 *                  [m000202060layout.jsp]업무기준 레이아웃 조회(판단) >> 표준항목 비표준항목관리
 *                  [m000203030.jsp/m000203030new.jsp]계산수식 속성등록 >> 표준항목 비표준항목관리
 * Open Issues    :
 * Change history 
 * @2008-05-26 류진영 1.0 최초 생성
 * @2008-08-16 황유진 #1.4.3 검색조건입력창의 엔터키 이벤트활성화 및 재조회시 curPage 초기화.
 */

    PosContext ctx=(PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale=(Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String sSearchAttribute=request.getParameter("SearchAttribute")== null?"STANDARD_ENGLISH_ID":request.getParameter("SearchAttribute");
    String sSearchWord=request.getParameter("SearchWord")== null?"":request.getParameter("SearchWord").trim();
    //부모에게 넘겨질때 몇번째 인덱스..
    String idx=request.getParameter("opener_target_id");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.019",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript">
<!--
function gm_KeyDown(){
    if(event.keyCode==13){
        gm_find();
    }
    return false;
}
function gm_find(){
    document.forms[0].curPage.value="1";//showPageSet tag.
    document.forms[0].submit();
}
function goEngNameSel(index){
    if(window.opener.document.forms[0].DtNmId.length==null){
        if(document.forms[0].DtNmId.length==null){
            window.opener.document.forms[0].MdlDefineDtNmMrkNm.value=document.forms[0].StandardKoreanName.value//항목명
            window.opener.document.forms[0].DtNmDataTpMeaning.value =document.forms[0].DtNmDataTpStr.value; //데이타 타입
            window.opener.document.forms[0].MdRuleDtNmNm.value      =document.forms[0].StandardKoreanName.value+"("+document.forms[0].StandardEnglishId.value +")"; //항목명
            window.opener.document.forms[0].MesUnitOfMeasure.value  =document.forms[0].DtNmUomCd.value; //단위
            window.opener.document.forms[0].DtNmDataTp.value        =document.forms[0].DtNmDataTp.value; //데이타 타입번호
            window.opener.document.forms[0].DtNmLen.value           =document.forms[0].DtNmLen.value; //길이
            window.opener.document.forms[0].DtNmDecimalPrec.value   =document.forms[0].DtNmDecimalPrec.value; //소수점
            window.opener.document.forms[0].DtNmId.value            =document.forms[0].DtNmId.value; //DtNmId
        }else{
            window.opener.document.forms[0].MdlDefineDtNmMrkNm.value=document.forms[0].StandardKoreanName[index].value//항목명
            window.opener.document.forms[0].DtNmDataTpMeaning.value =document.forms[0].DtNmDataTpStr[index].value; //데이타 타입
            window.opener.document.forms[0].MdRuleDtNmNm.value      =document.forms[0].StandardKoreanName[index].value+"("+document.forms[0].StandardEnglishId[index].value +")"; //항목명
            window.opener.document.forms[0].MesUnitOfMeasure.value  =document.forms[0].DtNmUomCd[index].value; //단위
            window.opener.document.forms[0].DtNmDataTp.value        =document.forms[0].DtNmDataTp[index].value; //데이타 타입번호
            window.opener.document.forms[0].DtNmLen.value           =document.forms[0].DtNmLen[index].value; //길이
            window.opener.document.forms[0].DtNmDecimalPrec.value   =document.forms[0].DtNmDecimalPrec[index].value; //소수점
            window.opener.document.forms[0].DtNmId.value            =document.forms[0].DtNmId[index].value; //DtNmId
        }
    } else{
        if(document.forms[0].DtNmId.length==null){
            window.opener.document.forms[0].MdlDefineDtNmMrkNm['<%=idx%>'].value=document.forms[0].StandardKoreanName.value//항목명
            window.opener.document.forms[0].DtNmDataTpMeaning['<%=idx%>'].value =document.forms[0].DtNmDataTpStr.value; //데이타 타입
            window.opener.document.forms[0].MdRuleDtNmNm['<%=idx%>'].value      =document.forms[0].StandardKoreanName.value+"("+document.forms[0].StandardEnglishId.value +")"; //항목명
            window.opener.document.forms[0].MesUnitOfMeasure['<%=idx%>'].value  =document.forms[0].DtNmUomCd.value; //단위
            window.opener.document.forms[0].DtNmDataTp['<%=idx%>'].value        =document.forms[0].DtNmDataTp.value; //데이타 타입번호  
            window.opener.document.forms[0].DtNmLen['<%=idx%>'].value           =document.forms[0].DtNmLen.value; //길이
            window.opener.document.forms[0].DtNmDecimalPrec['<%=idx%>'].value   =document.forms[0].DtNmDecimalPrec.value; //소수점
            window.opener.document.forms[0].DtNmId['<%=idx%>'].value            =document.forms[0].DtNmId.value; //DtNmId   
        }else{
            window.opener.document.forms[0].MdlDefineDtNmMrkNm['<%=idx%>'].value=document.forms[0].StandardKoreanName[index].value//항목명
            window.opener.document.forms[0].DtNmDataTpMeaning['<%=idx%>'].value =document.forms[0].DtNmDataTpStr[index].value; //데이타 타입
            window.opener.document.forms[0].MdRuleDtNmNm['<%=idx%>'].value      =document.forms[0].StandardKoreanName[index].value+"("+document.forms[0].StandardEnglishId[index].value +")"; //항목명
            window.opener.document.forms[0].MesUnitOfMeasure['<%=idx%>'].value  =document.forms[0].DtNmUomCd[index].value; //단위
            window.opener.document.forms[0].DtNmDataTp['<%=idx%>'].value        =document.forms[0].DtNmDataTp[index].value; //데이타 타입번호  
            window.opener.document.forms[0].DtNmLen['<%=idx%>'].value           =document.forms[0].DtNmLen[index].value; //길이
            window.opener.document.forms[0].DtNmDecimalPrec['<%=idx%>'].value   =document.forms[0].DtNmDecimalPrec[index].value; //소수점
            window.opener.document.forms[0].DtNmId['<%=idx%>'].value            =document.forms[0].DtNmId[index].value; //DtNmId   
        }
    }
    window.close();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="780" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="760" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.019",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
<form name="form_attr" method="post" action="m000200050.do">
<input type="hidden" name="ServiceName" value="m000200050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="opener_target_id" value='<%=idx%>'>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr height="18">
                <td align="left">
  <select name="SearchAttribute" class="adf">
    <option value="STANDARD_ENGLISH_ID" <%=  "STANDARD_ENGLISH_ID".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></option>
    <option value="STANDARD_KOREAN_NAME" <%="STANDARD_KOREAN_NAME".equals(sSearchAttribute)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></option>
  </select>
  <input type="text" name="SearchWord" value="<%=sSearchWord%>" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onKeyDown='gm_KeyDown()'>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="gm_find()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right">
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr align=left height=18>
          <td>
            <table id=T1 width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF>
              <tr class="tbldb" height="22">
                <td width="230"><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
                <td width="210"><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
                <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%></td>
                <td width="60"><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
                <td width="50"><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td width="80"><%=PosContext.getResourceMessage("GMResource","gm.label.0031",null,locale)%></td>
              </tr><%

    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("AttrsListVOResult") : null;
    int rowCnt = 0;
    if( rowSet!=null ){
        PosRow row = null;
        String DtNmDataTpStr = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
            DtNmDataTpStr = row.getAttribute("DT_NM_DATA_TP")==null ? "&nbsp;" : row.getAttribute("DT_NM_DATA_TP").toString();
            if("1".equals(DtNmDataTpStr))      DtNmDataTpStr="VARCHAR2";
            else if("2".equals(DtNmDataTpStr)) DtNmDataTpStr="NUMBER";
            else if("3".equals(DtNmDataTpStr)) DtNmDataTpStr="DATE";
            else if("4".equals(DtNmDataTpStr)) DtNmDataTpStr="CHAR";
            else if("5".equals(DtNmDataTpStr)) DtNmDataTpStr="TIMESTAMP";
            else                               DtNmDataTpStr="ARRAY";
%>
              <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20" onmouseover=in_ch(0,this,T1) onmouseout=in_ch(1,this,T1)>
                <td><a href="javascript:"onClick="goEngNameSel(<%=rowCnt%>)"><%=row.getAttribute("STANDARD_ENGLISH_ID")==null?"&nbsp;":(String)row.getAttribute("STANDARD_ENGLISH_ID")%></a></td>
                <td><%=row.getAttribute("STANDARD_KOREAN_NAME")==null?"&nbsp;":(String)row.getAttribute("STANDARD_KOREAN_NAME")%></td>
                <td><%=DtNmDataTpStr%></td>
                <td><%=row.getAttribute("DT_NM_LEN")==null?"&nbsp;":row.getAttribute("DT_NM_LEN").toString()%></td>
                <td><%=row.getAttribute("DT_NM_DECIMAL_PREC")==null?"&nbsp;":row.getAttribute("DT_NM_DECIMAL_PREC").toString()%></td>
                <td><%=row.getAttribute("DT_NM_UOM_CD")==null?"&nbsp;":(String)row.getAttribute("DT_NM_UOM_CD")%></td>
                <td><%=row.getAttribute("DT_NM_TP")==null?"&nbsp;":(String)row.getAttribute("DT_NM_TP")%></td>
                <input type="hidden" name="DtNmId" value="<%=row.getAttribute("DT_NM_ID")%>">
                <input type="hidden" name="StandardEnglishId" value="<%=row.getAttribute("STANDARD_ENGLISH_ID")%>">
                <input type="hidden" name="StandardKoreanName" value="<%=row.getAttribute("STANDARD_KOREAN_NAME")%>">
                <input type="hidden" name="DtNmDataTp" value="<%=row.getAttribute("DT_NM_DATA_TP")%>">
                <input type="hidden" name="DtNmDataTpStr" value="<%=DtNmDataTpStr%>">
                <input type="hidden" name="DtNmLen" value="<%=row.getAttribute("DT_NM_LEN")%>">
                <input type="hidden" name="DtNmDecimalPrec" value="<%=row.getAttribute("DT_NM_DECIMAL_PREC")%>">
                <input type="hidden" name="DtNmUomCd" value="<%=row.getAttribute("DT_NM_UOM_CD")==null?"":(String)row.getAttribute("DT_NM_UOM_CD")%>">
              </tr><%
            rowCnt++;
        }
        for(; rowCnt<20; rowCnt++){
%>
              <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tblcw" : "tblcg" %>" height="20">
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr><%
        }
    }
%>
            </table>
            <div align="center">
            <posui:showPageSet infoName="AttrsListVOResult" formName="document.forms[0]"/>
            </div>
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