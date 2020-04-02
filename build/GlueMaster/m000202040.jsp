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
 * @FileName      : 업무기준 목록 >> 업무기준 내용상세_일반기준
 * Open Issues    :
 * Change history
 * @2008-03-18 류진영 #1.0   최초 생성
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

    String[] HSearchWord = (String[])ctx.get("HSearchWord");
    String sHSearchIs = PosMasterUtility.getParameter(ctx, "sHSearchIs");

    PosRowSet rowSet = (PosRowSet)ctx.get("Defind010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1A0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale);
    else if("1A1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0137",null,locale);
    else if("1A2".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0075",null,locale);
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String UseTpStr = "";
    if("S".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
    else if("Y".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
    else if("N".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
    else if("F".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
    String MdlDefineCngGdStr = headerRow.getAttribute("MDL_DEFINE_CNG_GD")==null?"":(String)headerRow.getAttribute("MDL_DEFINE_CNG_GD");
    if("A".equals(MdlDefineCngGdStr)) MdlDefineCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale);
    else if("B".equals(MdlDefineCngGdStr)) MdlDefineCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale);

    String fixIndex = request.getParameter("fixIndex");
    if(fixIndex==null||fixIndex.length()<1) fixIndex="-1";

    rowSet = (PosRowSet)ctx.get("Defind020DataLayoutRowResult");
    PosRow row;
    PosRowSet rowset3 = (PosRowSet)ctx.get("Datas010RowResult");
    PosRow row3;
    PosRowSet rowset4 = (PosRowSet)ctx.get("Datas010ExceptionCase");
    PosRow row4;

    int         keyCnt              =   0;
    int         dataCnt             =   0;
    ArrayList   fixFiled            =   new ArrayList();
    ArrayList   unFixFiled          =   new ArrayList();
    ArrayList   fixFiledFullName    =   new ArrayList();
    ArrayList   unFixFiledFullName  =   new ArrayList();

    ArrayList tileLength            =   new ArrayList();
    ArrayList fixFiledLength        =   new ArrayList();
    ArrayList unFixFiledLength      =   new ArrayList();
    int       fixFiledTotalLength   =   0;
    int       unFixFiledTotalLength =   0;
    int       totalLength           =   0;
    double    unFixTitleLength      =   0;
    double    ratio                 =   0.0;
    ArrayList filedNams             =   new ArrayList();
    ArrayList dbFiledName           =   new ArrayList();

    String    filedName             =   "";
    String    javaFiledName         =   "";
    ArrayList fixFiledId            =   new ArrayList();
    ArrayList unFixFiledId          =   new ArrayList();

    String SearchAttribute          =  request.getParameter("SearchAttribute");
    String SearchWord               =  request.getParameter("SearchWord");

    HashMap     mapCdTpId           =   new HashMap();  /*CdTpId를 저장할 변수*/

    int seq                         =   0;
    int filedLen                    =   0;
    int dateTypePlusLen             =   0;
    String  aliasName               =   "";
    while(rowSet.hasNext())
    {
        row = rowSet.next();
        /********************* 출력할 java필드명을 생성한다***************/
        filedName=row.getAttribute("MDL_DEFINE_DT_NM_DRIVED_V_PROC").toString();

        /********************* 항목이 코드일 경우 CdTpId를 얻어온다**************/
        if("Y".equals(row.getAttribute("MDL_DEFINE_DT_NM_CD_F")))
        {
            mapCdTpId.put(filedName,row.getAttribute("CD_TP_ID"));
        }

        /********************* Date Type일 경우 LENGTH를 Plus 한다**************/
        if("3".equals(row.getAttribute("MDL_DEFINE_DT_NM_DATA_TP").toString()))
        {
            dateTypePlusLen=30;
        }else
        {
            dateTypePlusLen=0;
        }

        /* Title로 쓰일 한글명을 추출한다*/
        aliasName = row.getAttribute("MDL_DEFINE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MDL_DEFINE_DT_NM_ALIAS");
        if(row.getAttribute("OLSTATR_NM")!=null)
        {
            aliasName = aliasName +"("+row.getAttribute("OLSTATR_NM")+")";
        }

        /********************* 고정시킬 필드들을 가져온다***************/
        if((Integer.parseInt(fixIndex)==-1&&"Y".equals(row.getAttribute("MDL_DEFINE_DT_NM_KEY_F"))) || Integer.parseInt(fixIndex)>=seq)
        {
            if(aliasName.getBytes().length>Integer.parseInt(row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString()))
            {
                filedLen = aliasName.getBytes().length*8;
            }else
            {
                 filedLen = Integer.parseInt(row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString())*8;
            }
            fixFiledId.add(filedName);
            fixFiled.add(aliasName);
            fixFiledFullName.add(row.getAttribute("MDL_DEFINE_DT_NM_MRK_NM"));
            fixFiledLength.add(String.valueOf(filedLen+dateTypePlusLen));
            fixFiledTotalLength += filedLen + dateTypePlusLen;
        }else
        {
            if(aliasName.getBytes().length>Integer.parseInt(row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString()))
            {
                filedLen = aliasName.getBytes().length*8;
            }else
            {
                filedLen = Integer.parseInt(row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString())*8;
            }
            unFixFiledId.add(filedName);
            unFixFiled.add(aliasName);
            unFixFiledFullName.add(row.getAttribute("MDL_DEFINE_DT_NM_MRK_NM"));
            unFixFiledLength.add(String.valueOf(filedLen+dateTypePlusLen));
            unFixFiledTotalLength += filedLen + dateTypePlusLen;
        }
        /********************* 출력값과 입력값을 CNT한다***************/
        if("Y".equals(row.getAttribute("MDL_DEFINE_DT_NM_KEY_F")))
        {
            keyCnt++;
        }else
        {
            dataCnt++;
        }
        filedNams.add(aliasName);
        dbFiledName.add(row.getAttribute("MDL_DEFINE_DT_NM_DRIVED_V_PROC"));
        seq++;
    }

    totalLength = fixFiledTotalLength + unFixFiledTotalLength;
    if(totalLength + 65 < 958)
    {
        ratio = ((958-65)/(double)totalLength);
    }else
    {
        ratio = 1.0;
    }
    if( (fixFiledTotalLength*ratio + unFixFiledTotalLength*ratio + 65) <= 980 )
    {
        unFixTitleLength = 980-(fixFiledTotalLength*ratio+65);
    }else
    {
        unFixTitleLength = 980-(fixFiledTotalLength*ratio+65)-20;
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.054",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showBubbleHelp.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function goPage(actionType){
	document.forms[0].sHSearchIs.value="";
    document.forms[0].action=document.forms[0].action+"?curPage=1&"+actionType+"=10";
    document.forms[0].submit();
}
function goLayout(){
    document.forms[0].action="m000202030.do";
    document.forms[0].ServiceName.value="m000202030-service";
    document.forms[0].submit();
}
function goVersion(){
    document.form_rule_hitory.target = "_self";
    document.form_rule_hitory.submit();
}
function goCodeList(cdTpId,SearchWord){
    document.form_code.CdTpId.value    =cdTpId;
    document.form_code.SearchWord.value=SearchWord;
    showPopup("","showCode_"+cdTpId,780,550,'1',0,0,1,1,1,0,0);
    document.form_code.target = "showCode_"+cdTpId;
    document.form_code.submit();
}
function goBusinessRuleTestPage(mdlDefineNm){
    document.form_ruletest.MdRuleNm.value=mdlDefineNm;
    showPopup("","m000202040_test",970,500,'1',0,0,1,1,1,0,0);
    document.form_ruletest.target = "m000202040_test";
    document.form_ruletest.submit();
}
function divDataOnscroll(){
    //Chrome에서 '<SCRIPT FOR=divData EVENT=onscroll>'형식을 지원하지 않아 별도의 function으로 분리하여 호출하였음.
    document.all.divTop.scrollLeft = document.all.divData.scrollLeft;
    document.all.divLeft.scrollTop = document.all.divData.scrollTop;
}
function localToolTipOn(str){
    if(str.length>10){
        tooltipOn(str,WIDTH,150);
    }
}

function showHSearch(){
	document.getElementById('hSearchDiv').style.display='block';
}
function closeHSearch(){
	document.getElementById('hSearchDiv').style.display='none';
}
function goHSearch(){
    document.forms[0].action=document.forms[0].action+"?curPage=1&find.x=10";	
	document.forms[0].sHSearchIs.value="H";
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
<form name="form_rule_data" method="post" action="m000202040.do"><!-- m000202010.do,m000202030.do -->
<input type="hidden" name="ServiceName" value="m000202040-service"><!-- m000202010-service,m000202030-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="MdlDefineId" value="<%=headerRow.getAttribute("MDL_DEFINE_ID")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
<input type="hidden" name="modifyFlag" value="false">
<input type="hidden" name="sHSearchIs" value="<%=sHSearchIs%>">
      <table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5">
        <tr height="23">
          <td id=gm_BreadCrumbs valign="middle"><!--BreadCrumbs 네비게이션 링크 출력--></td>
          <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
        </tr>
      </table>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.054",null,locale)%></div></td>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.layout",null,locale)%>" onClick="goLayout()" style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.history",null,locale)%>" onClick="goVersion()" style="cursor:pointer"><% if("Y".equals(UseTp)){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.test",null,locale)%>" onClick="goBusinessRuleTestPage('<%=headerRow.getAttribute("MDL_DEFINE_NM")%>')" style="cursor:pointer"><!--rule test--><%}%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
<div id="hSearchDiv" style="position:absolute;display: none;top:205px;left:270px;z-index:999;background:#fff;border:1px solid #000;">
<table border="0" cellspacing="0" cellpadding="0" align="center">
  <tbody>
  <tr style="height:30px;background:#B3cdee;padding-left:3px;" >
    <td colspan=2><%=PosContext.getResourceMessage("GMResource","gm.label.0286",null,locale)%></td>
  </tr><%
    for(int i=0;i<filedNams.size();i++){
%>
  <tr style="height:27px;padding-right:5px;">
    <td style="padding-left:5px;"><input type="hidden" name="HSearchAttr" value='<%= (String)dbFiledName.get(i)%>'><%=
         ((String)filedNams.get(i)).length()>11 ? ((String)filedNams.get(i)).substring(0,12) : filedNams.get(i) %></td>
    <td><input type="text" name="HSearchWord" value='<%=(HSearchWord==null?"":HSearchWord[i].trim())%>' class=adb1></td>
  </tr><%
    }
%>
  <tr style="height:30px;">
    <td style="text-align:center;" colspan=2>
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
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td class=tbllw><input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_NM")%>" style="width:120" class=adg1 readonly></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
                <td class=tbllw width=190><input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_EXPLAIN")%>" style="width:180" class=adg1 readonly></td>
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
                  <input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_VERSION")%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=UseTpStr%>" style="width:80" class=adg1 readonly>
                  <input type="text" value="<%=MdlDefineCngGdStr%>" style="width:50" class=adg1 readonly>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=headerRow.getAttribute("MDL_DEFINE_OWNER_EMP_NO")%>" style="width:70" class=adg1 readonly>
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
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="25">
                <td><b><%=PosContext.getResourceMessage("GMResource","gm.label.0099",null,locale)%> : </b>
                  <select name="fixIndex" class=adf>
                    <option value="-1"><%=PosContext.getResourceMessage("GMResource","gm.label.0255",null,locale)%></option><%
for(int i=0;i<filedNams.size()-1;i++){
%>
                    <option value="<%=i%>" <%= (Integer.parseInt(fixIndex)==i?"selected":"")%>><%=
                      ((String)filedNams.get(i)).length()>11
                      ? ((String)filedNams.get(i)).substring(0,12)
                      : filedNams.get(i)%></option><%
}
%>
                  </select>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goPage('fixIndex.x')" style="cursor:pointer" align="absmiddle">&nbsp;&nbsp;&nbsp;
                  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0098",null,locale)%> : </b>
                  <select name="SearchAttribute" class=adf>
                    <option value=""><%=PosContext.getResourceMessage("GMResource","gm.label.0255",null,locale)%></option><%
for(int i=0;i<filedNams.size();i++){
%>
                    <option <%=(((String)dbFiledName.get(i)).equals(SearchAttribute)==true?"selected":"")%> value="<%= (String)dbFiledName.get(i)%>"><%=
                      ((String)filedNams.get(i)).length()>11
                      ?((String)filedNams.get(i)).substring(0,12)
                      :filedNams.get(i)%></option><%
}
%>
                  </select>
                  <input type="text" name="SearchWord" value='<%=(SearchWord==null?"":SearchWord.trim())%>' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goPage('find.x')" style="cursor:pointer" align='absmiddle'>
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
            <div style="position:relative;overflow:auto;width:980;height:<%=(int)(fixFiledTotalLength*ratio+65)<980 && (int)(fixFiledTotalLength*ratio+65)+(int)(unFixFiledTotalLength*ratio) < 980 ? 420 : 440%>;top:0;left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="right">
                  <div id=divSpec style="position:relative;overflow:hidden;width:<%=(int)(fixFiledTotalLength*ratio+65)%>;top:0;left:0;">
                  <table width="<%=(int)(fixFiledTotalLength*ratio+65)%>" border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb>
                      <td rowspan=2 width=65><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td><%  if(fixFiled.size()>keyCnt){%>
                      <td colspan=<%= keyCnt%> ><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
                      <td colspan=<%= fixFiled.size() - keyCnt%> ><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td><%  }else{%>
                      <td colspan=<%= fixFiled.size()%> ><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td><%  }%>
                    </tr>
                    <tr class=tbldb height=18><%  for(int i=0;i<fixFiled.size();i++){   %>
                      <td width=<%=Integer.parseInt((String)fixFiledLength.get(i))*ratio%> title="<%= fixFiledFullName.get(i)%>"><%= fixFiled.get(i)%></td><%  }%>
                    </tr>
                  </table>
                  </div>
                </td>
                <td>
                  <div id=divTop style="position:relative;overflow:hidden;width:<%=980-(int)(fixFiledTotalLength*ratio+65) > 0 ? 980-(int)(fixFiledTotalLength*ratio+65) : (int)(unFixFiledTotalLength*ratio) %>;top:0;left:0;">
                  <table width=<%=(int)(unFixFiledTotalLength*ratio)%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb><%  if(unFixFiled.size()>dataCnt){%>
                      <td colspan=<%= unFixFiled.size()-dataCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
                      <td colspan=<%= dataCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td><%  }else{%>
                      <td colspan=<%= unFixFiled.size()%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td><%  }%>
                    </tr>
                    <tr class=tbldb height=18><%  for(int i=0;i<unFixFiled.size();i++){   %>
                      <td width=<%= Integer.parseInt((String)unFixFiledLength.get(i))*ratio%> title="<%= unFixFiledFullName.get(i)%>"><%= unFixFiled.get(i)%></td><%  }%>
                    </tr>
                  </table>
                  </div>
                </td>
              </tr>
              <tr>
                <td align="right" valign=top>
                  <div id=divLeft style="position:relative;overflow:hidden;width:<%=(int)(fixFiledTotalLength*ratio+65)%>;top:0;left:0;">
                  <table id=maintable class="tbfix"  width="<%=(int)(fixFiledTotalLength*ratio+65)%>" border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff><%
    seq=0;
    row4=rowset4!=null&&rowset4.hasNext()?rowset4.next():null;
    if(row4!=null){//예외처리 Data 시작
%>
                    <tr height=18 class=tblcm onmouseover=in_ch(0,this,subtable) onmouseout=in_ch(1,this,subtable)>
                      <td index=<%=seq%> width=65><%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%></td><%

        for(int i=0;i<fixFiled.size();i++)
        {
            /* 코드항목일 경우*/
            if(mapCdTpId.get((String)fixFiledId.get(i))!=null)
            {
%>
                      <td onmouseover="localToolTipOn('<%=(row4.getAttribute((String)fixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%= Integer.parseInt((String)fixFiledLength.get(i))*ratio%>><%
                if(row4.getAttribute((String)fixFiledId.get(i))==null||row4.getAttribute((String)fixFiledId.get(i)).toString().length()<1)
                {
                          %>&nbsp;<%
                }else
                {
                        %><a href="javascript:goCodeList('<%= mapCdTpId.get((String)fixFiledId.get(i))%>','<%= (row4.getAttribute((String)fixFiledId.get(i)))%>');"><%=
                          (row4.getAttribute((String)fixFiledId.get(i)))
                        %></a><%
                }
                        %></td><%
            /* 일반항목일 경우*/
            }else
            {
%>
                      <td onmouseover="localToolTipOn('<%=(row4.getAttribute((String)fixFiledId.get(i)))==null||row4.getAttribute((String)fixFiledId.get(i)).toString().length()<1?"&nbsp;":(row4.getAttribute((String)fixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%= Integer.parseInt((String)fixFiledLength.get(i))*ratio%>><%=
                          (row4.getAttribute((String)fixFiledId.get(i)))==null||row4.getAttribute((String)fixFiledId.get(i)).toString().length()<1?"&nbsp;":(row4.getAttribute((String)fixFiledId.get(i)))
                        %></td><%
            }
        }
%>
                    </tr><%
    seq++;
    }// if end 예외처리 Data 종료
    String curPageNum = request.getParameter("curPage")==null?"1":request.getParameter("curPage");
    while(rowset3.hasNext()){
        row3=rowset3.next();

%>
                    <tr class=<%= seq%2==1?"tblcw":"tblcg"%> height=18 onmouseover=in_ch(0,this,subtable) onmouseout=in_ch(1,this,subtable)>
                      <td index=<%=seq%>><%= Integer.parseInt(curPageNum)*20-20+seq%></td><%

        for(int i=0;i<fixFiled.size();i++)
        {
            /* 코드항목일 경우*/
            if(mapCdTpId.get((String)fixFiledId.get(i))!=null)
            {
%>
                      <td onmouseover="localToolTipOn('<%=(row3.getAttribute((String)fixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%= Integer.parseInt((String)fixFiledLength.get(i))*ratio%>><%
                if(row3.getAttribute((String)fixFiledId.get(i))==null||row3.getAttribute((String)fixFiledId.get(i)).toString().length()<1)
                {
                          %>&nbsp;<%
                }else
                {
                        %><a href="javascript:goCodeList('<%= mapCdTpId.get((String)fixFiledId.get(i))%>','<%= (row3.getAttribute((String)fixFiledId.get(i)))%>');"><%=
                          (row3.getAttribute((String)fixFiledId.get(i)))
                        %></a><%
                }
                        %></td><%
            /* 일반항목일 경우*/
            }else
            {
%>
                      <td onmouseover="localToolTipOn('<%=(row3.getAttribute((String)fixFiledId.get(i)))==null||row3.getAttribute((String)fixFiledId.get(i)).toString().length()<1?"&nbsp;":(row3.getAttribute((String)fixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%= Integer.parseInt((String)fixFiledLength.get(i)) * ratio%>><%=
                          (row3.getAttribute((String)fixFiledId.get(i)))==null||row3.getAttribute((String)fixFiledId.get(i)).toString().length()<1?"&nbsp;":(row3.getAttribute((String)fixFiledId.get(i)))
                        %></td><%
            }
        }
        seq++;
%>
                    </tr><%
    }
%>
                  </table>
                  </div>
                </td>
                <td align="left" valign=top><%
                  int unFixedDivHeight = 380;
                  if( (fixFiledTotalLength*ratio+65)<980 && (int)(fixFiledTotalLength*ratio+65)+(int)(unFixFiledTotalLength*ratio) > 980){
                      unFixedDivHeight = 400;
                  }
%>
                  <div id=divData style="position:relative;overflow:auto;width:<%=980-(int)(fixFiledTotalLength*ratio+65) > 0 ? 980-(int)(fixFiledTotalLength*ratio+65) : (int)(unFixFiledTotalLength*ratio) %>;height:<%=unFixedDivHeight%>;top:0;left:0;" onscroll="divDataOnscroll()">
                  <table id=subtable class="tbfix" width=<%=(int)(unFixFiledTotalLength*ratio)%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff><%
    seq=0;
    if(row4!=null){//예외처리 Data 시작
%>
                    <tr height=18 class=tblcm onmouseover=in_ch(0,this,maintable) onmouseout=in_ch(1,this,maintable)><%

        for(int i=0;i<unFixFiledId.size();i++){
            /* 코드항목일 경우*/
            if(mapCdTpId.get((String)unFixFiledId.get(i))!=null){%>

                      <td onmouseover="localToolTipOn('<%=(row4.getAttribute((String)unFixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%=Integer.parseInt((String)unFixFiledLength.get(i))*ratio%>><%

                if(row4.getAttribute((String)unFixFiledId.get(i))==null||row4.getAttribute((String)unFixFiledId.get(i)).toString().length()<1){
                          %>&nbsp;<%
                }else
                {
                        %><a href="javascript:goCodeList('<%= mapCdTpId.get((String)unFixFiledId.get(i))%>','<%= (row4.getAttribute((String)unFixFiledId.get(i)))%>');"><nobr><%=
                          (row4.getAttribute((String)unFixFiledId.get(i)))%></nobr></a><%
                }
                        %></td><%

            /* 일반항목일 경우*/
            }else{
%>
                      <td onmouseover="localToolTipOn('<%=(row4.getAttribute((String)unFixFiledId.get(i)))==null||row4.getAttribute((String)unFixFiledId.get(i)).toString().length()<1?"&nbsp;":(row4.getAttribute((String)unFixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%=Integer.parseInt((String)unFixFiledLength.get(i))*ratio%>><nobr><%=
                          (row4.getAttribute((String)unFixFiledId.get(i)))==null||row4.getAttribute((String)unFixFiledId.get(i)).toString().length()<1?"&nbsp;":(row4.getAttribute((String)unFixFiledId.get(i)))
                        %></nobr></td><%
            }
        }
%>
                    </tr><%
    seq++;
    }//if end 예외처리 Data 종료
    rowset3.reset();
    while(rowset3.hasNext()){
        row3=rowset3.next(); %>
                    <tr class=<%= seq%2==1?"tblcw":"tblcg"%> height=18 onmouseover=in_ch(0,this,maintable) onmouseout=in_ch(1,this,maintable)><%

        for(int i=0;i<unFixFiledId.size();i++){
            /* 코드항목일 경우*/
            if(mapCdTpId.get((String)unFixFiledId.get(i))!=null){%>

                      <td onmouseover="localToolTipOn('<%=(row3.getAttribute((String)unFixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%=Integer.parseInt((String)unFixFiledLength.get(i))*ratio%>><%

                if(row3.getAttribute((String)unFixFiledId.get(i))==null||row3.getAttribute((String)unFixFiledId.get(i)).toString().length()<1){
                          %>&nbsp;<%
                }else
                {
                        %><a href="javascript:goCodeList('<%= mapCdTpId.get((String)unFixFiledId.get(i))%>','<%= (row3.getAttribute((String)unFixFiledId.get(i)))%>');"><nobr><%=
                          (row3.getAttribute((String)unFixFiledId.get(i)))%></nobr></a><%
                }
                        %></td><%

            /* 일반항목일 경우*/
            }else{
%>
                      <td onmouseover="localToolTipOn('<%=(row3.getAttribute((String)unFixFiledId.get(i)))==null||row3.getAttribute((String)unFixFiledId.get(i)).toString().length()<1?"&nbsp;":(row3.getAttribute((String)unFixFiledId.get(i)))%>');" onmouseout="tooltipOff();" index=<%=seq%> width=<%=Integer.parseInt((String)unFixFiledLength.get(i))*ratio%>><nobr><%=
                          (row3.getAttribute((String)unFixFiledId.get(i)))==null||row3.getAttribute((String)unFixFiledId.get(i)).toString().length()<1?"&nbsp;":(row3.getAttribute((String)unFixFiledId.get(i)))
                        %></nobr></td><%
            }
        }
        seq++;
%>
                    </tr><%
    }
%>
                  </table>
                  </div>
                </td>
              </tr>
            </table>
            </div><% if("1A0".equals(MasterDataPrcTp)){%>
            <div align="center">
            <posui:showPageSet infoName="Datas010RowResult" formName="document.forms[0]" curPageName="curPage"/>
            </div><%}%>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
    </td>
  </tr>
</table>
<form name="form_export" method="post" action="m000202040.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000202040-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="MdlDefineId" value='<%=headerRow.getAttribute("MDL_DEFINE_ID")%>'>
</form>
<form name="form_code" method="post" action="m000201010.do"><!-- codeRef -->
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="codeRef" value="10"><!-- event -->
<input type="hidden" name="CdTpId">
<input type="hidden" name="Type" value="VIEW">
<input type="hidden" name="SearchWord">
<input type="hidden" name="information_desc" value='<%=headerRow.getAttribute("MDL_DEFINE_EXPLAIN")%>'>
</form>
<form name="form_ruletest" method="post" action="m000202010.do"><!-- Test -->
<input type="hidden" name="ServiceName" value="m000202010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="test" value=10><!-- event -->
<input type="hidden" name="testType" value="general">
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
<input type="hidden" name="SearchWord" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_NM")%>">
<input type="hidden" name="SearchAttribute" value="MD_NM">
<input type="hidden" name="modifyFlag" value="false">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
</form>
</body>
</html>