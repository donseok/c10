<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import="com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 판단기준멀티 테스트화면
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080410
 * @Author        : 설계자
 * @LastModifier  : 류진영
 * @LastVersion   :  1.1
 *    2008-04-10   류진영
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

     request.setCharacterEncoding("KSC5601");
    String  mdlDefineNm    =request.getParameter("MdRuleNm");
    String  cmd        =request.getParameter("cmd");
    String[]  para=new String[20];
    int        seq=0;

    PosRuleVO ruleVO            =   null;
    String result               =   null;
    ArrayList m_Data            =   new ArrayList();
    ArrayList arryData          =   new ArrayList();
    String[][] data             =   new String[20][20];
    String errMessage           =   "";
    String startDateEffective   =   "";

    try
    {
        for(int i=0;i<20;i++)
        {
            para[i]="";
            for(int j=0;j<20;j++)
            {
                data[i][j]="";
            }
        }
        if("EXEC".equals(cmd))
        {
            for(int i=0;i<20;i++)
            {
                 data[i]=request.getParameterValues("para"+String.valueOf(i+1));
            }
    
            startDateEffective=request.getParameter("startDateEffective");
            if(startDateEffective.length()<8)
            {
                startDateEffective=null;
            }
            m_Data=new ArrayList();
            for(int i=0;i<7;i++){
                m_Data=new ArrayList();
                for(int j=0;j<20;j++)
                {
                    if(!"".equals(data[j][i]))
                    {
                        m_Data.add(data[j][i]);
                    }
                }
                para=new String[m_Data.size()];
                for(int j=0;j<m_Data.size();j++)
                {
                    para[j]=(String)m_Data.get(j);
                }
                if(m_Data.size()>0)
                {
                    arryData.add(para);
                }
            }
            ruleVO =EasyAccess.getPosDecisionRule(mdlDefineNm,arryData,startDateEffective);
        }
    }
    catch(Exception e)
    {
        errMessage=e.getMessage();
    }
    /*PosBusinessLogicFactory.setAppName(orginServiceName);*/        


%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.070",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript">
function doChangePage()
{
    var cmd=ListForm.changePage[ListForm.changePage.selectedIndex].value;
    if(cmd=='GEN')
    {
        self.location='m000202010.do?ServiceName=m000202010-service&test=10&testType=general&MdRuleNm=<%=mdlDefineNm%>';
    }else if(cmd=='DECISIONLOV')
    {
        self.location='m000202010.do?ServiceName=m000202010-service&test=10&testType=decisionLov&MdRuleNm=<%=mdlDefineNm%>';
    }else if(cmd=='MDECISIONMULTI')
    {
        self.location='m000202010.do?ServiceName=m000202010-service&test=10&testType=multipleDecision&MdRuleNm=<%=mdlDefineNm%>';
    }
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no" onload="">
<table width="950" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="930" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.070",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
<form name="form_ruletest" method="post" action="m000202010.do">
<input type="hidden" name="ServiceName" value="m000202010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="test" value=10><!-- event -->
<input type="hidden" name="cmd" value="EXEC">
            <table width="100%" border=0 cellspacing="0" cellpadding="0">
              <tr>
                <td><posui:showSelectList name="changePage" staticNames="GEN|DECISIONLOV|MDECISIONMULTI" staticValues="업무기준|판단기준LOV|판단기준멀티" defaultSelectionValues="MDECISIONMULTI" script="onChange='doChangePage()'"/></td>
                <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.test",null,locale)%>" onClick="document.forms[0].submit()" style="cursor:pointer">
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
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td></td>
                <td colspan=20><input type="text" name="MdRuleNm" value="<%= mdlDefineNm%>" class=adb1></td>
              </tr>
              <tr>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td></td>
                <td colspan=20><input type="text" name="startDateEffective" value="<%= startDateEffective==null?"":startDateEffective %>" class=adb1></td>
              </tr>
              <tr class=tbldb>
                <td rowspan=8><%=PosContext.getResourceMessage("GMResource","gm.label.0228",null,locale)%></td></td>
                <td>1</td>
                <td>2</td>
                <td>3</td>
                <td>4</td>
                <td>5</td>
                <td>6</td>
                <td>7</td>
                <td>8</td>
                <td>9</td>
                <td>10</td>
                <td>11</td>
                <td>12</td>
                <td>13</td>
                <td>14</td>
                <td>15</td>
                <td>16</td>
                <td>17</td>
                <td>18</td>
                <td>19</td>
                <td>20</td>
              </tr><% for(int i=0;i<7;i++){%>
              <tr class=tblcw>
                <td><input type="text" name="para1" value="<%= data[0][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para2" value="<%= data[1][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para3" value="<%= data[2][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para4" value="<%= data[3][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para5" value="<%= data[4][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para6" value="<%= data[5][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para7" value="<%= data[6][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para8" value="<%= data[7][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para9" value="<%= data[8][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para10" value="<%= data[9][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para11" value="<%= data[10][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para12" value="<%= data[11][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para13" value="<%= data[12][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para14" value="<%= data[13][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para15" value="<%= data[14][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para16" value="<%= data[15][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para17" value="<%= data[16][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para18" value="<%= data[17][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para19" value="<%= data[18][i]%>" class=adb1 size=4></td>
                <td><input type="text" name="para20" value="<%= data[19][i]%>" class=adb1 size=4></td>
              </tr><% }%><%    if(ruleVO!=null){%>
              <tr>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0178",null,locale)%></td></td>
                <Td colspan=20>
                  <table border=1><% 
                                    for(int i=0;i<ruleVO.getRecordCount();i++){%>
                    <tr><%
                                        ruleVO.moveRecorde(i);
                                        for(int j=0;j<ruleVO.getColumnCount();j++){%>
                      <td>&nbsp;<%= ruleVO.getRuleValueAt(j)==null ? "-":ruleVO.getRuleValueAt(j) %></td><%
                                        }%>
                    </tr><%
                                    }%>
                  </table>
                </td>
              </tr><%     } %>
            </table>
          </td>
        </tr><%
  if(errMessage!=null&&errMessage.length()>1){%>
        <TR>
          <td>에러메시지 : <%= errMessage%></td>
        </TR><%}%>
      </table>
    </td>
  </tr>
</table>
<input type="hidden" name="cmd" >
</form>
</body>
</html>