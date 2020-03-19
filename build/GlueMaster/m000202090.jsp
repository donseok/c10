<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import="com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 업무기준 테스트화면
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

    PosRowSet rowSet = (PosRowSet)ctx.get("TbM00Defines020VO_Key");
    int inCnt = rowSet==null ? 29 : rowSet.count();

    String  mdlDefineNm = request.getParameter("MdRuleNm");
    String  cmd = request.getParameter("cmd");
    String[]  para=new String[inCnt];
    int seq=0;
    PosRuleVO ruleVO = null;
    String result=null;
    ArrayList m_Data=new ArrayList();
    String data="";
    String errMessage="";
    String startDateEffective=request.getParameter("startDateEffective")==null?"":request.getParameter("startDateEffective");

    try
    {
        for(int i=0;i<inCnt;i++)
        {
            para[i]="";
        }
        if("EXEC".equals(cmd))
        {
            for(int i=0;i<inCnt;i++)
            {
                data=request.getParameter("para"+String.valueOf(i+1));
                if(data!=null)
                    m_Data.add(data);
            }
            startDateEffective=request.getParameter("startDateEffective");
            if(m_Data.size()>0)
            {
                para=new String[m_Data.size()];
                for(int i=0;i<m_Data.size();i++)
                {
                    if(((String)m_Data.get(i)).compareTo(" ")==0)
                    {
                        para[i]=(String)m_Data.get(i);
                    } else
                    {
                        para[i]=(String)m_Data.get(i);
                    }
                }
                ruleVO =EasyAccess.getPosRuleLov(mdlDefineNm,para,startDateEffective);
            }
        }
    }catch(Exception e)
    {
        errMessage=e.getMessage();
        e.printStackTrace();
    }
    %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.068",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript">
function doChangePage()
{
    var cmd=ListForm.changePage[ListForm.changePage.selectedIndex].value;
    if(cmd=='GEN')
    {
        self.location='m000202010.do?ServiceName=m000202010-service&test=10&testType=general&MdRuleNm=';
    }else if(cmd=='DECISIONLOV')
    {
        self.location='m000202010.do?ServiceName=m000202010-service&test=10&testType=decisionLov&MdRuleNm=';
    }else if(cmd=='MDECISIONMULTI')
    {
        self.location='m000202010.do?ServiceName=m000202010-service&test=10&testType=multipleDecision&MdRuleNm=<%=mdlDefineNm%>';
    }
}
function getRuleInfo(){
    document.forms[0].cmd.value="GetRuleInfo";
    document.forms[0].submit();
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.068",null,locale)%></div></td>
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
<input type="hidden" name="testType" value='general'>
<input type="hidden" name="cmd" value="EXEC">
            <table width="100%" border=0 cellspacing="0" cellpadding="0">
              <tr>
                <td><posui:showSelectList name="changePage" staticNames="GEN|DECISIONLOV|MDECISIONMULTI" staticValues="업무기준|판단기준LOV|판단기준멀티" defaultSelectionValues="GEN" script="onChange='doChangePage()'"/></td>
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
                <td><input type="text" name="MdRuleNm" value="<%= mdlDefineNm%>" class=adb1 onChange="getRuleInfo()" >
                  : <%=ctx.get("MDL_DEFINE_EXPLAIN")==null?"존재하지 않는 기준입니다.":ctx.get("MDL_DEFINE_EXPLAIN")%>
                </td>
              </tr>
              <tr>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td></td>
                <td><%
                rowSet = (PosRowSet)ctx.get("TbM00Defines010VO");
                if(rowSet != null && rowSet.hasNext()){
%>
                  <posui:showSelectList infoName="TbM00Defines010VO" name="startDateEffective" nameAttribute="START_ACTIVE_DATE_STR" valueAttribute="START_ACTIVE_DATE" totalName="-" totalValue="-------------------" defaultSelectionValues="<%=startDateEffective%>" style="width:118px" script="onChange='getRuleInfo()'"/><%
                }else{
                %><input type="text" name="startDateEffective" value="<%= startDateEffective%>" class=adb1><%
                }
                %></td>
              </tr>
              <tr>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0228",null,locale)%></td>
                <td>
                  <DIV ID=divData STYLE="position:relative;overflow:scroll;width:850;height:60;top:0;left:0;">
                  <table width=<%=inCnt*40%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
                    <tr class=tbldb><% for(int i=1; i<=inCnt; i++){%>
                      <td width=40><%=i%></td><% }%>
                    </tr>
                    <tr class=tblcw><% for(int i=1; i<=inCnt; i++){%>
                      <td><input type="text" name="para<%=i%>" value="<%= para[i-1]%>" class=adb1 size=4></td><% }%>
                    </tr>
                  </table>
                  </div>
                </td>
              </tr>
              <tr height=30>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0178",null,locale)%></td>
                <td><%    if(ruleVO!=null){
                  %>
                  <DIV ID=divData STYLE="position:relative;overflow:scroll;width:850;height:200;top:0;left:0;">
                  <table width=<%=ruleVO.getColumnCount()*60%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff><%
                            for(int j=0;j<ruleVO.getRecordCount();j++)
                            {
                                ruleVO.moveRecorde(j);
                              %>
                    <tr class=tblcw><%
                                for(int i=0, iz=ruleVO.getColumnCount(); i<iz; i++){
                      %>
                      <td class=tbllb>&nbsp;<%= ruleVO.getRuleValueAt(i)==null?"&nbsp;":ruleVO.getRuleValueAt(i) %>&nbsp;</td><%
                                }%>
                    </tr><%
                            }%>
                  </table>
                  </div><%}else{
                              if(errMessage!=null&&errMessage.length()>1){
                        %>에러메시지 : <%= errMessage%><%
                              } %>&nbsp;<%
                          }%></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</body>
</html>