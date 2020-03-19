<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 업무기준 목록 >> 업무기준 내용상세_판단기준
 * Open Issues    :
 * Change history 
 * @2008-03-26 류진영 #1.0   최초 생성
 * @2012-08-08 조창희 #1.4.2 고급검색의 연산자를  <input..> 에서 <select..>로 변경
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    HashMap<String, String> HierarchyOpTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
        HierarchyOpTpMap.put(value[0], value[1]);
    }
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");
    HashMap<String, String> HierarchyOwnerShipTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
        HierarchyOwnerShipTpMap.put(value[0], value[1]);
    }

    String[] HSearchWord1 = (String[])ctx.get("HSearchWord1");
    String[] HSearchWord2 = (String[])ctx.get("HSearchWord2");
    String[] HSearchWord3 = (String[])ctx.get("HSearchWord3");
    String sHSearchIs = PosMasterUtility.getParameter(ctx, "sHSearchIs");

%>
<%!
    private String nvl(String val)
    {
        if("null".equals(val))
        {
            return "&nbsp;";
        } else
        {
            return val;
        }
    }
    private String opExplain(String val, String str)
    {
        if("BETWEEN1".equalsIgnoreCase(val))
        {
            return "&lt;="+str+"&lt;=";
        } else if("BETWEEN2".equalsIgnoreCase(val))
        {
            return "&lt;="+str+"&lt;";
        } else if("BETWEEN3".equalsIgnoreCase(val))
        {
            return "&lt;"+str+"&lt;=";
        } else if("BETWEEN4".equalsIgnoreCase(val))
        {
            return "&lt;"+str+"&lt;";
        } else if("LIKE1".equalsIgnoreCase(val))
        {
            return "%LIKE%";
        } else if("LIKE2".equalsIgnoreCase(val))
        {
            return "%LIKE";
        } else if("LIKE3".equalsIgnoreCase(val))
        {
            return "LIKE%";
        }
        return val;
    }

%>
<%

    String sDecisionRuleDataPageRowResult  = request.getParameter("curPage")==null?"1":request.getParameter("curPage");

    int rowCnt =     0;
    int itemIndex = 0;   
    int keyCnt=0;
    int dataCnt=0;
    int inputWidth=0;
    ArrayList itemLength=new ArrayList();
    ArrayList filedNams    = new ArrayList();
    ArrayList dbFiledName  = new ArrayList();
    /* between 연산자가 아닌경우 비교값2를 삭제 */
    String conOlstatr="";
    HashMap conMaxView=new HashMap();

    PosRowSet rowSet = (PosRowSet)ctx.get("Rule010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1B0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0191",null,locale);
    else if("1B1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0151",null,locale);
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String UseTpStr = "";
    if("S".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
    else if("Y".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
    else if("N".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
    else if("F".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
    String MdRuleCngGdStr = headerRow.getAttribute("MD_RULE_CNG_GD")==null?"":(String)headerRow.getAttribute("MD_RULE_CNG_GD");
    if("A".equals(MdRuleCngGdStr)) MdRuleCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale);
    else if("B".equals(MdRuleCngGdStr)) MdRuleCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale);

    PosRowSet rowset2 = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    PosRow row2;
    PosRowSet rowset3 = (PosRowSet)ctx.get("DecisionRuleDataRowResult");
    PosRow row3;
    PosRowSet rowset4 = (PosRowSet)ctx.get("DecisionRuleDataRowResultException");
    PosRow row4 = rowset4!=null&&rowset4.hasNext()?rowset4.next():null;
    /********END DATE가 최종버전이면 빈칸으로 설정************/
    String endDate = String.valueOf(headerRow.getAttribute("END_ACTIVE_DATE_STR"));
    if ("2999".equals(endDate.substring(0,4)))
        endDate="";

    int viewKeyCnt=0;
    if(rowset2!=null && rowset2.count() > 0)
    {
        while(rowset2.hasNext())
        {
            row2=rowset2.next();
            if("I".equals(row2.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")))
            {
                keyCnt++;
            } else
            {
                dataCnt++;
            }
            filedNams.add(row2.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row2.getAttribute("STANDARD_KOREAN_NAME"):(String)row2.getAttribute("MD_RULE_DT_NM_ALIAS"));
            dbFiledName.add(String.valueOf(row2.getAttribute("MD_RULE_DT_NM_SEQ")));
        }
        while(rowset3.hasNext())
        {
            row3=rowset3.next();
            for(int i=0;i<keyCnt;i++)
            {
                conOlstatr=(String)row3.getAttribute("MD_RULE_CON_OLSTATR_"+(i+1));
                if(conOlstatr.equalsIgnoreCase("BETWEEN1")
                  ||conOlstatr.equalsIgnoreCase("BETWEEN2")
                  ||conOlstatr.equalsIgnoreCase("BETWEEN3")
                  ||conOlstatr.equalsIgnoreCase("BETWEEN4") )
                {
                    conMaxView.put("MD_RULE_CON_OLSTATR_"+(i+1),new Boolean(true));
                }
            }
        }
        viewKeyCnt = keyCnt*2 + conMaxView.size();
        if((viewKeyCnt*80+(dataCnt*150))+80<978)
        //if(((keyCnt*3)*80+(dataCnt*150))+80<958)
        {
            //inputWidth=80+(958-(dataCnt*150)-((keyCnt*3)*80)-80)/(keyCnt*3);
            inputWidth=80+(978-(dataCnt*150)-(viewKeyCnt*80)-80)/viewKeyCnt;
        } else
        {
            inputWidth=100;
        }
        rowset3.reset();
        rowset2.reset();
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.062",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css" media="screen" >
<SCRIPT FOR=divData EVENT=onscroll>
<!--
  document.all.divTop.scrollLeft = document.all.divData.scrollLeft;
  document.all.divLeft.scrollTop = document.all.divData.scrollTop;
-->
</script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showBubbleHelp.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function goLayout(){
    document.forms[0].action="m000202060.do";
    document.forms[0].ServiceName.value="m000202060-service";
    document.forms[0].submit();
}
function goVersion(){
    document.form_rule_hitory.target = "_self";
    document.form_rule_hitory.submit();
}
function localToolTipOn(str){
    if(str.length>10){
        tooltipOn(str,WIDTH,150);
    }
}
function goBusinessRuleTestPage(mdlDefineNm){
    document.form_ruletest.MdRuleNm.value=mdlDefineNm;
    showPopup("","m000202040_test",970,500,'1',0,0,1,1,1,0,0);
    document.form_ruletest.target = "m000202040_test";
    document.form_ruletest.submit();
}
function showHSearch(){
    document.getElementById('hSearchDiv').style.display='block';
}
function closeHSearch(){
    document.getElementById('hSearchDiv').style.display='none';
}
function goHSearch(){
    document.forms[0].action=document.forms[0].action+"?curPage=1&find=10";
    document.forms[0].sHSearchIs.value="H";
    document.forms[0].submit();
}
function goPage(actionType){
    document.forms[0].sHSearchIs.value="";
    document.forms[0].action=document.forms[0].action+"?curPage=1&"+actionType+"=10";
    document.forms[0].submit();
}
-->
</script>
</head>
<!-- 풍선도움말을 위한 Div Layer --> 
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.062",null,locale)%></div></td>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.layout",null,locale)%>" onClick="goLayout()" style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.history",null,locale)%>" onClick="goVersion()" style="cursor:pointer"><% if("Y".equals(UseTp)){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.test",null,locale)%>" onClick="goBusinessRuleTestPage('<%=headerRow.getAttribute("MD_RULE_NM")%>')" style="cursor:pointer"><!--rule test--><%}%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_rule_data" method="post" action="m000202070.do"><!-- m000202010.do,m000202060.do -->
<input type="hidden" name="ServiceName" value="m000202070-service"><!-- m000202010-service,m000202060-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
<input type="hidden" name="modifyFlag" value="false">
<input type="hidden" name="sHSearchIs" value="<%=sHSearchIs%>">
<div id="hSearchDiv" class="hsearchtype1">
<table border="0" cellspacing="0" cellpadding="0" align="center">
    <tbody>
        <tr style="height:30px;background:#B3cdee;padding-left:3px;" >
            <td colspan=4>
            <%=PosContext.getResourceMessage("GMResource","gm.label.0286",null,locale)%>
            </td>
        </tr>
        <tr style="height:23px;padding-right:5px;">
            <td>
                &nbsp;
            </td>
            <td style="padding:2px 0 0 12px;" >
                <%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%>
            </td>   
            <td style="padding:2px 0 0 12px;" >
                <%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%>
            </td>   
            <td style="padding:2px 0 0 12px;" >
                <%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%>
            </td>   
        </tr>
<%
for(int i=0;i<keyCnt;i++){
%>
        <tr style="height:27px;padding-right:5px;">
            <td style="padding-left:5px;" >
                <input type="hidden" name="HSearchAttr" value='<%= (String)dbFiledName.get(i)%>' >
                <%= ((String)filedNams.get(i)).length()>11
                      ? ((String)filedNams.get(i)).substring(0,12)
                      : filedNams.get(i)%>
            </td>
            <td>
                <select class=adb1 name='HSearchWord1' style='width:93;'>
                    <option value='' >&nbsp;</option>
                    <option value='NOT_CHECK' <%=("NOT_CHECK".equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>NOT_CHECK</option>
                    <option value='=' <%=        ("="        .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>=</option>
                    <option value='!=' <%=       ("!="       .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>><%=PosContext.getResourceMessage("GMResource","gm.label.0154",null,locale)%></option>
                    <option value='>' <%=        (">"        .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&gt;</option>
                    <option value='>=' <%=       (">="       .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&gt;=</option>
                    <option value='<' <%=        ("<"        .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&lt;</option>
                    <option value='<=' <%=       ("<="       .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&lt;=</option>
                    <option value='BETWEEN1' <%= ("BETWEEN1" .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=</option>
                    <option value='BETWEEN2' <%= ("BETWEEN2" .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;</option>
                    <option value='BETWEEN3' <%= ("BETWEEN3" .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=</option>
                    <option value='BETWEEN4' <%= ("BETWEEN4" .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;</option>
                    <option value='LIKE1' <%=    ("LIKE1"    .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>%LIKE%</option>
                    <option value='LIKE2' <%=    ("LIKE2"    .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>%LIKE</option>
                    <option value='LIKE3' <%=    ("LIKE3"    .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>LIKE%</option>
                    <option value='IN' <%=       ("IN"       .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>IN</option>
                    <option value='NOT_IN' <%=   ("NOT_IN"   .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>NOT_IN</option>
                    <option value='NOT_NULL' <%= ("NOT_NULL" .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>NOT_NULL</option>
                    <option value='IS_NULL' <%=  ("IS_NULL"  .equalsIgnoreCase((HSearchWord1==null?"":HSearchWord1[i].trim())))?"selected":"" %>>IS_NULL</option>
                </select>
            </td>   
            <td>
                <input type="text" name="HSearchWord2" value='<%=(HSearchWord2==null?"":HSearchWord2[i].trim())%>' class=adb1 >
            </td>   
            <td>
                <input type="text" name="HSearchWord3" value='<%=(HSearchWord3==null?"":HSearchWord3[i].trim())%>' class=adb1 >
            </td>   
        </tr>
<%
}
%>
<tr style="height:30px;">
            <td style="text-align:center;" colspan=4>
                <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goHSearch();" style="cursor:pointer" align='absmiddle'>
                <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="closeHSearch();" style="cursor:pointer" align='absmiddle'>
            </td>
        </tr>
    </tbody>
</table>
</div>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdRuleNm" value="<%=(String)headerRow.getAttribute("MD_RULE_NM")%>" style="width:120" class=adg1 readonly></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
                <td class=tbllw width=190><input type="text" value="<%=(String)headerRow.getAttribute("MD_RULE_EXPLAIN")%>" style="width:180" class=adg1 readonly></td>
                <td class=tbldb width=140><%=PosContext.getResourceMessage("GMResource","gm.label.0262",null,locale)%></td>
                <td class=tbllw width=200><input type="text" value="<%=MasterDataPrcTpStr%>" style="width:150" class=adg1 readonly></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw colspan=3>
                  <input type="text" value="<%=(String)headerRow.getAttribute("START_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly> ~
                  <input type="text" value="<%=headerRow.getAttribute("END_ACTIVE_DATE_STR")==null?"":(String)headerRow.getAttribute("END_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MD_RULE_VERSION")%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=UseTpStr%>" style="width:80" class=adg1 readonly>
                  <input type="text" value="<%=MdRuleCngGdStr%>" style="width:50" class=adg1 readonly>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=headerRow.getAttribute("MD_RULE_OWNER_EMP_NO")%>" style="width:70" class=adg1 readonly>
                  (<input type="text" value="<%=headerRow.getAttribute("USER_NAME")%>" style="width:100" class=adg1 readonly>)
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0083",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=HierarchyOwnerShipTpMap.get((String)headerRow.getAttribute("HIERARCHY_OWNER_SHIP_TP"))%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=HierarchyOpTpMap.get((String)headerRow.getAttribute("HIERARCHY_OP_TP"))%>" style="width:50" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0123",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("LAST_UPDATE_TIMESTAMP_STR")%>" style="width:120" class=adg1 readonly>
                  <input type="text" value="<%=(String)headerRow.getAttribute("LAST_UPDATED_OBJECT_ID")%>" style="width:70" class=adg1 readonly>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td align="left"><b><%=PosContext.getResourceMessage("GMResource","gm.label.0098",null,locale)%>:</b>&nbsp;
                  <select name="SearchAttribute" class=adf>
                    <option value=""><%=PosContext.getResourceMessage("GMResource","gm.label.0255",null,locale)%></option><%
    String SearchAttribute = request.getParameter("SearchAttribute");
    String SearchOper = request.getParameter("SearchOper"); 
    String SearchWord = request.getParameter("SearchWord")==null?"":request.getParameter("SearchWord");
                    for(int i=0;i<keyCnt;i++){
%>
                    <option <%=(((String)dbFiledName.get(i)).equals(SearchAttribute)==true?"selected":"")%> value="<%=(String)dbFiledName.get(i)%>"><%= ((String)filedNams.get(i)).length()>11?((String)filedNams.get(i)).substring(0,12):filedNams.get(i)%></option><%
                    }
%>
                  </select>
                  <select name="SearchOper" class="adf">
                    <option value="MD_RULE_CON_OLSTATR" <%="MD_RULE_CON_OLSTATR".equals(SearchOper)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%></option>
                    <option value="MD_RULE_CON_MI_V" <%=      "MD_RULE_CON_MI_V".equals(SearchOper)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%></option>
                    <option value="MD_RULE_CON_MAX_V" <%=    "MD_RULE_CON_MAX_V".equals(SearchOper)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%></option>
                  </select>
                  <input type="text" name="SearchWord" value='<%=(SearchWord==null?"":SearchWord.trim())%>' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onmouseover="tooltipOn('■ 주요 연산자 유형<br>between1(<=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><=)<br>between2(<=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><)<br>between3(<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><=)<br>between4(<<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><)<br>LIKE1(%LIKE%)<br>LIKE2(%LIKE)<br>LIKE3(LIKE%)',WIDTH, 170 );" onmouseout="tooltipOff();">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goPage('find')" style="cursor:pointer" align='absmiddle'>
                  <a href="javascript:showHSearch();" style="padding-left:10px;"><%=PosContext.getResourceMessage("GMResource","gm.label.0286",null,locale)%></a>
                </td>
                <td align="right">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
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
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td valign="top" align="right">
                  <div id=divSpec style="position:relative;overflow:hidden;width:95;top:0;left:0;">
                  <table width="95" border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb height=54>
                      <td width=35>no.</td>
                      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0162",null,locale)%></td>
                    </tr>
                  </table>
                  <table id=maintable width="95" border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff><%
        if(row4!=null){
%>
                    <tr height=22 class=tblcm onmouseover=in_ch_plus(0,this,subtable,3) onmouseout=in_ch_plus(1,this,subtable,3)>
                      <td width=35>&nbsp;</td>
                      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%></td>
                    </tr><%
        }
        rowCnt=4;
        while(rowset3.hasNext())
        {
            row3=rowset3.next();
%>
                    <tr height=20 class=<%= rowCnt%2==1?"tblcg":"tblcw"%> onmouseover=in_ch_plus(0,this,subtable,3) onmouseout=in_ch_plus(1,this,subtable,3)>
                      <td width=35><%= Integer.parseInt(sDecisionRuleDataPageRowResult)*15-15+rowCnt-3%></TD>
                      <td><%=row3.getAttribute("MD_RULE_CON_DO_SEQ")==null?"&nbsp;":row3.getAttribute("MD_RULE_CON_DO_SEQ").toString()%></TD>
                    </tr><%
                rowCnt++;
        }
        int unFixedheight = 0;
        if(viewKeyCnt*inputWidth+dataCnt*150 > 900)
        {
            unFixedheight = 428;
        }else
        {
            unFixedheight = 408;
        }
%>
                  </table>
                </div>
                </td>
                <td valign="top" align="left">
                  <div id=divTop style="position:relative;overflow:auto;width:885;height:<%=unFixedheight%>;top:0;left:0;">
                  <table id="subtable" class="tbfix" width=<%= viewKeyCnt*inputWidth+dataCnt*150%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb height=18>
                      <td colspan=<%=viewKeyCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
                      <td colspan=<%=dataCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td>
                    </tr>
                    <tr class=tbldb height=19><%
    while(rowset2.hasNext())
    {
        row2=rowset2.next();
        if("I".equals(row2.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")))
        {
            if(conMaxView.containsKey("MD_RULE_CON_OLSTATR_"+row2.getAttribute("MD_RULE_DT_NM_SEQ"))){
%>
                      <td colspan=3 title='<%= row2.getAttribute("STANDARD_KOREAN_NAME")%>'><%= row2.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row2.getAttribute("STANDARD_KOREAN_NAME"):(String)row2.getAttribute("MD_RULE_DT_NM_ALIAS")%></td><%
            }else{
%>
                      <td colspan=2 title='<%= row2.getAttribute("STANDARD_KOREAN_NAME")%>'><%= row2.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row2.getAttribute("STANDARD_KOREAN_NAME"):(String)row2.getAttribute("MD_RULE_DT_NM_ALIAS")%></td><%
            }
        }
        else
        {
%>
                      <td rowspan=2 width=150 title='<%= row2.getAttribute("STANDARD_KOREAN_NAME")%>'><%= row2.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row2.getAttribute("STANDARD_KOREAN_NAME"):(String)row2.getAttribute("MD_RULE_DT_NM_ALIAS")%></td><%
        }
    }
%>
                    </tr>
                    <tr class=tbllb height=19><%               for(int i=0;i<keyCnt;i++) {%>
                      <td width=<%=inputWidth%>><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%></td>
                      <td width=<%=inputWidth%>><%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%></td><%    if(conMaxView.containsKey("MD_RULE_CON_OLSTATR_"+(i+1))){%>
                      <td width=<%=inputWidth%>><%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%></td><%    }
                                                               } %>
                    </tr><%

    if(row4!=null){
%>
                    <tr height=22 class=tblcm onmouseover=in_ch_plus(0,this,maintable,-3) onmouseout=in_ch_plus(1,this,maintable,-3)>
                      <td colspan=<%=viewKeyCnt%>><%=PosContext.getResourceMessage("GMResource","gm.msg.0042",null,locale)%></td><%//아래조건을 만족하지 않을경우 적용
        for(int i=0;i<dataCnt;i++)
        {
%>
                      <td width=150><%=row4.getAttribute("MD_RULE_DECISION_RST"+(i+1))==null?"&nbsp;":row4.getAttribute("MD_RULE_DECISION_RST"+(i+1))%></td><%
        }
%>
                    </tr><%
    }

    rowset3.reset();
    rowCnt=4;
    while(rowset3.hasNext())
    {
%>
                    <tr height=20 class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> onmouseover=in_ch_plus(0,this,maintable,-3) onmouseout=in_ch_plus(1,this,maintable,-3)><%
        row3=rowset3.next();
        for(int i=0;i<keyCnt;i++)
        {
%>
                      <td onmouseover="localToolTipOn('<%=opExplain(nvl(String.valueOf(row3.getAttribute("MD_RULE_CON_OLSTATR_"+(i+1)))), PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale))%>')" onmouseout="tooltipOff();"  width=<%=inputWidth%>><nobr><%=opExplain(nvl(String.valueOf(row3.getAttribute("MD_RULE_CON_OLSTATR_"+(i+1)))), PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale))%></nobr></td>
                      <td onmouseover="localToolTipOn('<%=row3.getAttribute("MD_RULE_CON_MI_V_" +(i+1))==null||row3.getAttribute("MD_RULE_CON_MI_V_" +(i+1)).toString().length()<1?"&nbsp;":row3.getAttribute("MD_RULE_CON_MI_V_" +(i+1))%>');" onmouseout="tooltipOff();" width=<%=inputWidth%>><nobr><%=row3.getAttribute("MD_RULE_CON_MI_V_" +(i+1))==null||row3.getAttribute("MD_RULE_CON_MI_V_" +(i+1)).toString().length()<1?"&nbsp;":row3.getAttribute("MD_RULE_CON_MI_V_" +(i+1))%></nobr></td><%
                if(conMaxView.containsKey("MD_RULE_CON_OLSTATR_"+(i+1))){
%>
                      <td onmouseover="localToolTipOn('<%=row3.getAttribute("MD_RULE_CON_MAX_V_"+(i+1))==null||row3.getAttribute("MD_RULE_CON_MAX_V_"+(i+1)).toString().length()<1?"&nbsp;":row3.getAttribute("MD_RULE_CON_MAX_V_"+(i+1))%>');" onmouseout="tooltipOff();" width=<%=inputWidth%>><nobr><%=row3.getAttribute("MD_RULE_CON_MAX_V_"+(i+1))==null||row3.getAttribute("MD_RULE_CON_MAX_V_"+(i+1)).toString().length()<1?"&nbsp;":row3.getAttribute("MD_RULE_CON_MAX_V_"+(i+1))%></nobr></td><%
                }
        }
        for(int i=0;i<dataCnt;i++)
        {
%>
                      <td onmouseover="localToolTipOn('<%=row3.getAttribute("MD_RULE_DECISION_RST"+(i+1))==null||row3.getAttribute("MD_RULE_DECISION_RST"+(i+1)).toString().length()<1?"&nbsp;":row3.getAttribute("MD_RULE_DECISION_RST"+(i+1))%>');" onmouseout="tooltipOff();" width=150><nobr><%=row3.getAttribute("MD_RULE_DECISION_RST"+(i+1))==null||row3.getAttribute("MD_RULE_DECISION_RST"+(i+1)).toString().length()<1?"&nbsp;":row3.getAttribute("MD_RULE_DECISION_RST"+(i+1))%></nobr></td><%
        }
%>
                    </tr><%
        rowCnt++;
    }
%>
                  </TABLE>
                </DIV>
                </TD>
              </TR>
            </TABLE>
          </td>
        </tr>
        <tr>
          <td align="left">
            <posui:showPageSet infoName="DecisionRuleDataRowResult" formName="document.forms[0]" curPageName="curPage"/>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000202070.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000202070-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
</form>
<form name="form_ruletest" method="post" action="m000202010.do"><!-- Test -->
<input type="hidden" name="ServiceName" value="m000202010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="test" value=10><!-- event -->
<input type="hidden" name="testType" value="decisionLov">
<input type="hidden" name="MdRuleNm">
</form>
<form name="form_rule_hitory" method="post" action="m000202010.do"><!-- History -->
<input type="hidden" name="ServiceName" value="m000202010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="history" value="10"><!-- event -->
<input type="hidden" name="SearchUseTp" value="%">
<input type="hidden" name="SearchMasterDataPrcTp" value="%">
<input type="hidden" name="SearchWord" value="<%=(String)headerRow.getAttribute("MD_RULE_NM")%>">
<input type="hidden" name="SearchAttribute" value="MD_NM">
<input type="hidden" name="modifyFlag" value="false">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
</form>
    </td>
  </tr>
</table>
</body>
</html>