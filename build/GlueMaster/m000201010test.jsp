<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.master.easyaccess.returnType.PosCodeCombinationInfo" %>
<%@ page import="com.posdata.glue.master.easyaccess.returnType.PosCodeLOV" %>
<%@ page import="com.posdata.glue.master.easyaccess.returnType.PosCodeValueInfo" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 마스타코드 목록 >> 마스타코드 PopUp화면(코드테스트) 
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080307
 * @LastModifier  : 서정범
 * @LastVersion   : 1.0
 *    2008-03-07   서정범
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String sPageProcess= request.getParameter("pageProcess")==null?"A":request.getParameter("pageProcess");
    String sProcess    = request.getParameter("process")==null   ?"":request.getParameter("process");
    String sParameter1 = request.getParameter("parameter1")==null?"":request.getParameter("parameter1");
    String sParameter2 = request.getParameter("parameter2")==null?"":request.getParameter("parameter2");
    String sParameter3 = request.getParameter("parameter3")==null?"":request.getParameter("parameter3");
    Object result = ctx.get("_result_");

    String[] Method1 = {
         "getCodeLOV(String codeNm, String category)"
        ,"getCodeValueInfo(String codeNm, String codeValue, String category)"
        ,"validateCodeValue(String codeNm, String codeValue, String category)"
        ,"getDivisionCodeValues(String codeNm, String codeValue, String category)"
        ,"getUnionCodeValue(String codeNm, String[] elementValues, String category)"
        ,"getCodeCombinationInfo(String codeNm, String category)"
        ,"getCodeLOVOrderByValue(String codeNm, String category, boolean ascending)"
        ,"getCodeLOVOrderByMeaning(String codeNm, String category, boolean ascending)"
        ,"getCodeLOVStartWith(String codeNm, String category, String condiString)"
        ,"getCodeLOVOrderBySequence(String codeNm, String category)"
        };

    String[] Method2 = {
         "PosCodeLOV"
        ,"PosCodeValueInfo"
        ,"boolean"
        ,"String[]"
        ,"String"
        ,"PosCodeCombinationInfo"
        ,"PosCodeLOV"
        ,"PosCodeLOV"
        ,"PosCodeLOV"
        ,"PosCodeLOV"
        };
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.025",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
<!--
function goConfirm()
{
    document.forms[0].pageProcess.value="B";
    document.forms[0].target = "_self";
    document.forms[0].submit();
}
function goReload()
{
    document.forms[0].pageProcess.value="A";
    document.forms[0].target = "_self";
    document.forms[0].submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
<table width="900" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="880" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.025",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="form_codetest" method="post" action="m000201010.do"><!-- Test -->
<input type="hidden" name="ServiceName" value="m000201010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="forwardname" value="test">
<input type="hidden" name="test" value=10><!-- event -->
<input type="hidden" name="pageProcess">
              <tr height="18">
                <td align="left">
                  <img src="/img/m000008img.gif" border="0">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0163",null,locale)%>&nbsp;:&nbsp;</b>
                  <select name="process" class="adf">
                    <option value="1" <%=  "1".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0008",null,locale)%></option>
                    <option value="2" <%=  "2".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0011",null,locale)%></option>
                    <option value="3" <%=  "3".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0012",null,locale)%></option>
                    <option value="4" <%=  "4".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0013",null,locale)%></option>
                    <option value="5" <%=  "5".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0014",null,locale)%></option>
                    <option value="6" <%=  "6".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0015",null,locale)%></option>
                    <option value="7" <%=  "7".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0016",null,locale)%></option>
                    <option value="8" <%=  "8".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0017",null,locale)%></option>
                    <option value="9" <%=  "9".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0018",null,locale)%></option>
                    <option value="10" <%="10".equals(sProcess)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0009",null,locale)%></option>
                  </select>
                </td>
                <td align="right"><% if ("A".equals(sPageProcess)) {%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.test",null,locale)%>" onClick="javascript:goConfirm();" style="cursor:pointer"><% } else { %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.ok",null,locale)%>" onClick="javascript:goReload()" style="cursor:pointer"><!-- confirm --><% }%>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- close -->
                </td>
              </tr>
              <tr colspan=2>
                <td align="left" height="18">
                  <img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0259",null,locale)%> :</b>&nbsp;
                  <input type="text" class=adb1 name="parameter1" value="<%=sParameter1%>" size=40 height=18>
                  &nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0260",null,locale)%> :</b>&nbsp;
                  <input type="text" class=adb1 name="parameter2" value="<%=sParameter2%>" size=15 height=18>
                  &nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0261",null,locale)%> :</b>&nbsp;
                  <input type="text" class=adb1 name="parameter3" value="<%=sParameter3%>" size=15 height=18>
                </td>
              </tr>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td><%
    if ("A".equals(sPageProcess)) {
%>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class=tbldb height=20>
                <td size=30>no.</td>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0146",null,locale)%></td>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0176",null,locale)%></td>
              </tr><%        for(int i=0; i < Method1.length ; i++) {%>
              <tr>
                <td align=center><%= i+1%></td>
                <td><%=Method1[i]%></td>
                <td><%=Method2[i]%></td>
              </tr><%        }%>
            </table><%
    } else {
        int methodIdx = Integer.parseInt(sProcess)-1;
%>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class=tbllb height=20>
                <td colspan=3><%=Method2[methodIdx]%>&nbsp; result = EasyAccess.<%=Method1[methodIdx]%></td>
              </tr>
              <tr class=tbldb height=20>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0146",null,locale)%></td>
                <td><%=PosContext.getResourceMessage("GMResource","gm.label.0243",null,locale)%></td>
              </tr><%

        if(result instanceof PosCodeLOV)
        {
            int cnt = ((PosCodeLOV)result).getCodeCount();
%>
              <tr>
                <td align=center>int</td>
                <td>result.getCodeCount()</td>
                <td><%= ((PosCodeLOV)result).getCodeCount()%></td>
              </tr><%
            for(int i=0; i < cnt ; i++)
            {
                if(i == 1000)
                {
%>
              <tr><td colspan=3>over 1000</td></tr><%
                    break;
                }
%>
              <tr>
                <td align=center>String</td>
                <td align=left>result.getCodeValueAt(<%=i%>) result.getCodeMeaningAt(<%=i%>)</td>
                <td align=left>
                  Range? [<%=(((PosCodeLOV)result).getCodeRangeFlagAt(i)==null?"&nbsp;":((PosCodeLOV)result).getCodeRangeFlagAt(i))%>]
                  MIN [<%= (((PosCodeLOV)result).getCodeRangeMinAt(i)==null?"&nbsp;":((PosCodeLOV)result).getCodeRangeMinAt(i))%>]
                  MAX [<%= (((PosCodeLOV)result).getCodeRangeMaxAt(i)==null?"&nbsp;":((PosCodeLOV)result).getCodeRangeMaxAt(i))%>]
                  [<%= ((PosCodeLOV)result).getCodeValueAt(i)%>][<%= ((PosCodeLOV)result).getCodeMeaningAt(i)%>]
                </td>
              </tr><%
            }
        }else if(result instanceof PosCodeValueInfo)
        {
%>
              <tr><td>String</td><td>result.codeValue</td><td><%=(((PosCodeValueInfo)result).codeValue==null?"&nbsp;":((PosCodeValueInfo)result).codeValue)%></td></tr>
              <tr><td>String</td><td>result.codeValueMeaning</td><td><%=(((PosCodeValueInfo)result).codeValueMeaning==null?"&nbsp;":((PosCodeValueInfo)result).codeValueMeaning)%></td></tr>
              <tr><td>String</td><td>result.codeRangeFlag</td><td><%=(((PosCodeValueInfo)result).codeRangeFlag==null?"&nbsp;":((PosCodeValueInfo)result).codeRangeFlag)%></td></tr>
              <tr><td>String</td><td>result.codeRangeMin</td><td><%=(((PosCodeValueInfo)result).codeRangeMin==null?"&nbsp;":((PosCodeValueInfo)result).codeRangeMin)%></td></tr>
              <tr><td>String</td><td>result.codeRangeMax</td><td><%=(((PosCodeValueInfo)result).codeRangeMax==null?"&nbsp;":((PosCodeValueInfo)result).codeRangeMax)%></td></tr><%
        }else if(result instanceof Boolean)
        {
%>
              <tr><td>boolean</td><td>&nbsp;</td><td><%=result%></td></tr><%
        }else if(result instanceof String[])
        {
            int cnt = ((String[])result).length;
            for (int i=0; i < cnt ; i++)
            {
                if(i == 1000)
                {
%>
              <tr><td colspan=3>over 1000</td></tr><%
                    break;
                }
%>
              <tr><td>String[]</td><td>result[<%=i%>]</td><td><%=((String[])result)[i]%></td></tr><%
            } // for문 종료 
        }else if(result instanceof String)
        {
%>
              <tr><td>String</td><td>&nbsp;</td><td><%=result%></td></tr><%
        }else if(result instanceof PosCodeCombinationInfo)
        {
%>
              <tr><td>int</td><td>result.getElementCount()</td><td><%=((PosCodeCombinationInfo)result).getElementCount()%></td></tr><%
            try
            {
                String[] aResult = ((PosCodeCombinationInfo)result).getElementList(); 
                for (int i=0; i < aResult.length ; i++)
                {
                    ArrayList alResult = (ArrayList)((PosCodeCombinationInfo)result).getElementCodeValues(aResult[i]);
                    int nResultSub1 = (int)((PosCodeCombinationInfo)result).getElementCodeSatColumn(aResult[i]);
                    int nResultSub2 = (int)((PosCodeCombinationInfo)result).getElementCodeLength(aResult[i]);
                    String[] aResultSub1 = (String[])alResult.get(0);    // 조합항목값
                    String[] aResultSub2 = (String[])alResult.get(1);    // 조합항목의미
%>
              <tr><td>int</td><td>result.getElementCodeSatColumn(<%=aResult[i]%>)</td><td><%=nResultSub1%></td></tr>
              <tr><td>int</td><td>result.getElementCodeLength(<%=aResult[i]%>)</td><td><%=nResultSub1%></td></tr><%
                    for (int j=0 ; j < aResultSub1.length ; j++)
                    {
%>
              <tr><td>ArrayList</td><td>result.getElementCodeValues(<%=aResult[i]%>/<%=j+1%>)</td><td><%=aResult[i]%>[<%=aResultSub1[j]%>]</td></tr><%
                    } // j for 문 종료 
                }    // i for 문 종료 
            } catch (Exception e)
            {
                e.printStackTrace();
            }
        }
%>
            </table><%
    }
%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>