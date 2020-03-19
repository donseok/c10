<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import="com.posdata.glue.master.easyaccess.returnType.PosCalcVO" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 계산수식 목록 >> 계산수식 내용상세 >> 계산수식 PopUp화면(계산식 테스트)
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080410
 * @LastModifier  : 김정희
 * @LastVersion   : 1.0
 *    2008-03-07   김정희
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

    String Cmd = request.getParameter("Cmd")== null?"": request.getParameter("Cmd");
    String MdRuleNm =request.getParameter("MdRuleNm")== null?"": request.getParameter("MdRuleNm");
   
    BigDecimal result = null;
    java.sql.Timestamp resultDate = null;

    String checkDate = request.getParameter("checkDate")== null?"": request.getParameter("checkDate");
    PosCalcVO resultVO = null;

    if( "do".equals(Cmd))
    {
        ArrayList inputParams = new ArrayList();
        String[] tempVal = new String[10];

        //전체 파라미터의 갯수를 구한다
        int maxRow = 0;
        for( int i = 1; i <13 ; i++)
        {
            tempVal = request.getParameterValues("factorVal"+Integer.toString(i));
            if( tempVal[0] != null && tempVal[0].length() > 0 ){ maxRow = i; }
        }

        int paramCnt = 0;

        for( int i = 1; i < maxRow+1 ; i ++)
        {
            tempVal =  request.getParameterValues("factorVal"+Integer.toString(i));
            paramCnt = 0;
            for( int j= 1; j  < 11 ; j ++)
            {
                if( tempVal[j-1] != null && tempVal[j-1].length()>0)
                    paramCnt = j;
            }
            if( paramCnt == 0) 
            {
                inputParams.add(null);
            }else
            {
                String[] oneRow = new String[paramCnt];
                for( int j = 0; j < paramCnt ; j ++)
                {
                    oneRow[j] = tempVal[j];
                }
                inputParams.add(oneRow);
            }
        }

        if( checkDate == null || checkDate.trim().length() == 0)
        {
             resultVO = EasyAccess.getPosCalc(MdRuleNm.trim(),inputParams);
        } 
        else 
        {
             resultVO = EasyAccess.getPosCalc(MdRuleNm.trim(),inputParams, checkDate);
        }

        if (resultVO != null)
        {
            result = resultVO.getResultValue();
            resultDate = resultVO.getResultDate();
        }
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.077",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no" onload="">
<table width="950" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="930" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.077",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.test",null,locale)%>" onClick="document.form_calctest.submit()" style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
<form name="form_calctest" method="post" action="m000203010.do"><!-- Test -->
<input type="hidden" name="ServiceName" value="m000203010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="test" value=10><!-- event -->
<input type="hidden" name="Cmd" value="do">
        <tr>
          <td align="left">
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr>
                <td class=tbldb width=200><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
                <td class=tbllb width=740><input type="text" name='MdRuleNm' value='<%= MdRuleNm %>' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=200><%=PosContext.getResourceMessage("GMResource","gm.label.0079",null,locale)%></td>
                <td class=tbllb width=740><input type="text" name='checkDate' value='' class=adb1></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td height=20><b><%=PosContext.getResourceMessage("GMResource","gm.label.0228",null,locale)%></b></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr>
                <td class=tbldb width=70 >Input1</td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal1' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input2</td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal2' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input3</td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal3' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input4</td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal4' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input5</td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal5' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input6</td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal6' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input7</td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal7' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input8</td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal8' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input9</td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal9' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input10</td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal10' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input11</td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal11' value='' size='10' class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb width=70 >Input12</td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
                <td width=85><input type="text" name='factorVal12' value='' size='10' class=adb1></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr>
                <td class=tbldb width=200>gm.label.0178</td><% 
                    if(result==null && resultDate==null)
                    { 
%>  
                <td class=tbllb width=740><input type="text" name ='result' value='' class=adb1></td><%
                    } 
                    else 
                    { 
%>
                <td class=tbllb width=740><input type="text" name ='result' value='<%= (result==null)? resultDate.toString():result.toString() %>' class=adb1></td><% 
                    } 
%>
              </tr>
            </table> 
          </td>
        </tr>
      </table>
      </form>
    </td>
  </tr>
</table>
</body>
</html>