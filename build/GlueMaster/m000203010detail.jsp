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
 * @FileName      : 계산수식 목록 >> 계산수식 내용상세
 * Open Issues    :
 * Change history 
 * @2008-03-07 김정희 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시

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
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.075",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/highlightRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
//업무기준화면열기
function goRulePage(index, masterDataPrcTp, ruleId, ruleName){
    /*
     * 1A0 : 일반 업무기준
     * 1B0 : 판단 업무기준
     * 1B1 : 연관판단 업무기준
     */
    document.form_rule_data.MdlDefineId.value = ruleId;
    document.form_rule_data.MdRuleId.value = ruleId;
    document.form_rule_data.MasterDataPrcTp.value = masterDataPrcTp;
    if(masterDataPrcTp=="1A0"){
        document.form_rule_data.action = "m000202040.do";
        document.form_rule_data.ServiceName.value = "m000202040-service";
    }else if(masterDataPrcTp=="1B0"){
        document.form_rule_data.action = "m000202070.do";
        document.form_rule_data.ServiceName.value = "m000202070-service";
    }else if(masterDataPrcTp=="1B1"){
        document.form_rule_data.action = "m000202080.do";
        document.form_rule_data.ServiceName.value = "m000202080-service";
    }else{
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0016",null,locale)%>");//기준테이블 정보가 잘못 등록되어 있습니다.
        return;
    }
    showPopup("","m000203010_rule",1016,641,'1',0,0,1,1,1,0,0);
    document.form_rule_data.target="m000203010_rule";
    document.form_rule_data.submit();
}
function goToFactor(index){
    document.form_cal_factor.MdRuleId.value = document.forms[0].MdRuleId.value;
    document.form_cal_factor.DtNmId.value = document.forms[0].charId.length>1
        ? document.forms[0].charId[index].value
        : document.forms[0].charId.value;
    showPopup("","m000203010_factor",510,310,'1',0,0,1,1,1,0,0);
    document.form_cal_factor.target="m000203010_factor";
    document.form_cal_factor.submit();
}
//계산식테스트POPUP화면열기
function gm_Test(){
    document.form_calctest.MdRuleNm.value=document.forms[0].MdRuleNm.value;
    showPopup("","m000203010_test",970,500,'1',0,0,1,1,1,0,0);
    document.form_calctest.target = "m000203010_test";
    document.form_calctest.submit();
}
//변경이력POPUP화면열기
function goVersion(){
    document.form_cal_history.target = "_self";
    document.form_cal_history.submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage);setTableIndexNoHeader(T2);">
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
      </table><%

    PosRowSet rowSet=(PosRowSet)ctx.get("Rule010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1C0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0192",null,locale);
    else if("1C2".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale);
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String UseTpStr = "";
    if("S".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale);
    else if("Y".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale);
    else if("N".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale);
    else if("F".equals(UseTp)) UseTpStr = PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale);
    String MdRuleCngGdStr = headerRow.getAttribute("MD_RULE_CNG_GD")==null?"":(String)headerRow.getAttribute("MD_RULE_CNG_GD");
    if("A".equals(MdRuleCngGdStr)) MdRuleCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale);
    else if("B".equals(MdRuleCngGdStr)) MdRuleCngGdStr = PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale);
%>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.075",null,locale)%></div></td>
          <td align=right>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.history",null,locale)%>" onClick="goVersion()" style="cursor:pointer"><% if("Y".equals(UseTp)){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.test",null,locale)%>" onClick="gm_Test()" style="cursor:pointer"><% } %>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_cal_data" method="post" action="m000203010.do">
<input type="hidden" name="ServiceName" value="m000203010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="MdRuleId" value='<%=headerRow.getAttribute("MD_RULE_ID")%>'>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left" height="18">
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdRuleNm" value="<%=(String)headerRow.getAttribute("MD_RULE_NM")%>" style="width:120" class=adg1 readonly></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
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
          <td height=20><b>1.<%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></b></td>
        </tr><%
    if ("1C0".equals(MasterDataPrcTp))
    {
%>
        <tr>
          <td>
            <table id=TtableTemp2 width="960" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=18>
                <td class=tbllb><%=headerRow.getAttribute("MD_RULE_OPER_TYPE").toString()%></td>
              </tr>
            </table>
          </td>
        </tr><%
    }
    else if ("1C2".equals(MasterDataPrcTp))
    {
%>
        <tr valign=top align=center>
          <td align="left">
            <table width="960" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              <tr class=tbldb height="20">
                <td width=350><%=PosContext.getResourceMessage("GMResource","gm.label.0074",null,locale)%></td>
                <td width=500><%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></td>
                <td width=110><%=PosContext.getResourceMessage("GMResource","gm.label.0162",null,locale)%></td>
              </tr>
            </table>
            <DIV ID=divData STYLE='position:relative;overflow-y:scroll;width:980;height:80;top:0;left:0;'>
            <table id="T1" width="960" border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"><%
    rowSet = (PosRowSet)ctx.get("CalcLinkVOResult");
    int rowCnt = 0;
    if(rowSet!=null){
        PosRow row = null;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
              <tr index=<%=rowCnt%> class="<%= (rowCnt%2==0) ? "tbllw" : "tbllg" %>" height="20" onmouseover=in_ch(0,this,T1) onmouseout=in_ch(1,this,T1)>
                <td><%=row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD")%></td>
                <td><%=row.getAttribute("MD_RULE_DECISION_RST1")==null?"&nbsp;":(String)row.getAttribute("MD_RULE_DECISION_RST1")%></td>
                <td align="center"><%=row.getAttribute("MD_RULE_CON_DO_SEQ")==null?"&nbsp;":row.getAttribute("MD_RULE_CON_DO_SEQ").toString()%></td>
              </tr><%
        }
    }
%>
              <th height=0 width=350></th>
              <th height=0 width=500></th>
              <th height=0 width=110></th>
            </table>
            </DIV>
          </td>
        </tr><%
    }
%>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td height=20><b>2.<%=PosContext.getResourceMessage("GMResource","gm.label.0160",null,locale)%></b></td>
        </tr>
        <tr>
          <td><%
    String sDecimalPrec = headerRow.getAttribute("MD_RULE_CALC_V_DECIMAL_PREC")==null||headerRow.getAttribute("MD_RULE_CALC_V_DECIMAL_PREC").toString().length()<1
      ? "&nbsp;"
      : headerRow.getAttribute("MD_RULE_CALC_V_DECIMAL_PREC").toString();
    String sUomValue = headerRow.getAttribute("MES_UNIT_OF_MEASURE")==null||headerRow.getAttribute("MES_UNIT_OF_MEASURE").toString().length()<1
      ? "&nbsp;"
      : headerRow.getAttribute("MES_UNIT_OF_MEASURE").toString();
    String sRoundF = headerRow.getAttribute("MD_RULE_CALC_V_ROUND_F")==null||headerRow.getAttribute("MD_RULE_CALC_V_ROUND_F").toString().length()<1
      ? "&nbsp;"
      : headerRow.getAttribute("MD_RULE_CALC_V_ROUND_F").toString();
    
	if("R".equals(sRoundF)){
	        sRoundF = PosContext.getResourceMessage("GMResource","gm.label.0184",null,locale);
	}else if("C".equals(sRoundF)){
	        sRoundF = PosContext.getResourceMessage("GMResource","gm.label.0221",null,locale);
	}else if("U".equals(sRoundF)){
	        sRoundF = PosContext.getResourceMessage("GMResource","gm.label.0251",null,locale);
	}else if("S".equals(sRoundF)){
	        sRoundF = PosContext.getResourceMessage("GMResource","gm.label.0264",null,locale);
	}else if("J".equals(sRoundF)){
	        sRoundF = PosContext.getResourceMessage("GMResource","gm.label.0265",null,locale);
    }
    String sCondition = null;
    PosRowSet calcConditionVO=(PosRowSet)ctx.get("CalcConditionVOResult");
    PosRow rowCondition = null;
    if(calcConditionVO.hasNext())
    {
        rowCondition = calcConditionVO.next();
        sCondition = (String)rowCondition.getAttribute("MD_RULE_DT_NM_CONNECT_CHK_TPSD");
    }
%>
            <table id=TtableTemp width="960" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=200><%=PosContext.getResourceMessage("GMResource","gm.label.0183",null,locale)%></td>
                <td class=tblcw width=120><%=sRoundF%></td>
                <td class=tbldb width=200><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></TD>
                <td class=tblrw width=120><%=sDecimalPrec%></TD>
                <td class=tbldb width=200><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></TD>
                <td class=tblcw width=120><%=sUomValue%></TD>
              </tr>
              <tr height=20>
                <td class=tbldb width=200><%=PosContext.getResourceMessage("GMResource","gm.label.0072",null,locale)%></TD>
                <td class=tblcw colspan=5 width=760><%=sCondition==null||sCondition.toString().length()<1?"&nbsp;":sCondition%></TD>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td height=20><b>3.<%=PosContext.getResourceMessage("GMResource","gm.label.0117",null,locale)%></b></td>
        </tr>
        <tr>
          <td align=left valign=top>
            <table width="960" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20 class=tbldb>
                <td width=4% >no.</td>
                <td width=5% ><%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%></td>
                <td width=31% ><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
                <td width=7% ><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
                <td width=10% ><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td width=11% ><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%></td>
                <td width=4% ><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td width=12% ><%=PosContext.getResourceMessage("GMResource","gm.label.0245",null,locale)%></td>
                <td width=12% ><%=PosContext.getResourceMessage("GMResource","gm.label.0243",null,locale)%></td>
              </tr>
            </table>
            <DIV ID=charData STYLE='position:relative;overflow:auto;overflow-x:hidden;width:980;height:200;top:0;left:0;'>
            <table id=T2 width="960" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff><%
    PosRowSet calcDetailListVO=(PosRowSet)ctx.get("CalcAttrsDataVOResult");
    PosRow rowDetail = null;
    String trForm = "";
    String dtNmUOMCd = "";
    int iSeq = 0;
    int valueCount = 0;
    int cnstCount =0;
    String VC = "V";
    //0:DT_NM_ID,1:STANDARD_KOREAN_NAME, 2:MD_RULE_DT_NM_COMP_CHK_V_APP_F, 3:MD_RULE_DT_NM_DRIVED_V_PROC
    //4:USE_TP,  5:DT_NM_UOM_CD,  6:MD_RULE_DT_NM_SEQ, 7:MD_RULE_ID 8:MES_UNIT_OF_MEASURE
    
    while(calcDetailListVO.hasNext()) 
    {
        rowDetail = calcDetailListVO.next();
        trForm = iSeq%2 == 0 ? "tblcg" : "tblcw";
       //표시
        if( "I".equalsIgnoreCase(rowDetail.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F").toString()))
        {
            valueCount++;
            VC = "V"+Integer.toString(valueCount);
        }else 
        {
            cnstCount ++;
            VC = "C"+Integer.toString(cnstCount);
        }

       //단위 (MES_UNIT_OF_MEASURE)
        if (rowDetail.getAttribute("MES_UNIT_OF_MEASURE") == null || (rowDetail.getAttribute("MES_UNIT_OF_MEASURE").toString()).length() <1)
        {
           dtNmUOMCd = "";
        }else
        {
           dtNmUOMCd = rowDetail.getAttribute("MES_UNIT_OF_MEASURE").toString();
        }

        String _DtNmDataTp = rowDetail.getAttribute("DT_NM_DATA_TP")==null?"nbsp;":rowDetail.getAttribute("DT_NM_DATA_TP").toString();
        if("1".equals(_DtNmDataTp)) _DtNmDataTp="VARCHAR2";
        else if("2".equals(_DtNmDataTp)) _DtNmDataTp="NUMBER";
        else if("3".equals(_DtNmDataTp)) _DtNmDataTp="DATE";
        else if("4".equals(_DtNmDataTp)) _DtNmDataTp="CHAR";
        else if("5".equals(_DtNmDataTp)) _DtNmDataTp="TIMESTAMP";

        %>
              <tr index=<%=iSeq%> class='<%= trForm %>' height=20 height="20" onmouseover=in_ch(0,this,T2) onmouseout=in_ch(1,this,T2)>
                <input type="hidden" name='charId' value="<%= rowDetail.getAttribute("DT_NM_ID") %>" >
                <input type="hidden" name='charSeq' value="<%= rowDetail.getAttribute("MD_RULE_DT_NM_SEQ")%>" >
                <input type="hidden" name='charName' value="<%= rowDetail.getAttribute("STANDARD_KOREAN_NAME")%>">
                <input type="hidden" class=adb1 name='charUomCode' size='4' value="<%= dtNmUOMCd%>">
                <td index='<%=iSeq%>'><!--순번--><%=rowDetail.getAttribute("MD_RULE_DT_NM_SEQ")%></td>
                <td index='<%=iSeq%>'><!--표시--><%= VC %></td>
                <td index='<%=iSeq%>' align="left"><!--항목명--><%= rowDetail.getAttribute("STANDARD_KOREAN_NAME")+"("+rowDetail.getAttribute("STANDARD_ENGLISH_ID")+")"%></td>
                <td index='<%=iSeq%>'><!--코드여부--><%= rowDetail.getAttribute("MD_RULE_DT_NM_CD_F")%></td>
                <td index='<%=iSeq%>'><!--단위-->&nbsp;<%= dtNmUOMCd %></td>
                <td index='<%=iSeq%>'><!--데이타타입--><%= _DtNmDataTp%></td>
                <td index='<%=iSeq%>'><!--길이--><%= rowDetail.getAttribute("DT_NM_LEN")%></td>
                <td index='<%=iSeq%>'><!--처리타입--><%
                      if( "I".equalsIgnoreCase(rowDetail.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F").toString()))
                      {
                      %>변&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수<input type="hidden" name='inputType'  value='I'><%
                      } 
                      else 
                      {
                          if ("F".equalsIgnoreCase(rowDetail.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F").toString()))
                          {
                      %><%=PosContext.getResourceMessage("GMResource","gm.label.0097",null,locale)%><%
                          } 
                          else if("M".equalsIgnoreCase(rowDetail.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F").toString())) 
                          {
                      %><%=PosContext.getResourceMessage("GMResource","gm.label.0186",null,locale)%><%
                          }
                          else if ("C".equalsIgnoreCase(rowDetail.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F").toString()))
                          {
                      %><%=PosContext.getResourceMessage("GMResource","gm.label.0081",null,locale)%><%
                          }
                      } 
                 %></td>
                <td index='<%=iSeq%>'><!--처리설정--><%
                  if( "F".equalsIgnoreCase((String)rowDetail.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F"))) {
                  %><img src="<%=PosContext.getResourceMessage("GMResource","gm.img.viewfactor",null,locale)%>" align='absmiddle' border=0 onClick="goToFactor(this.parentElement.index)"><%
                  }else if("M".equalsIgnoreCase((String)rowDetail.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F"))) {
                  %><%=rowDetail.getAttribute("MD_RULE_DT_NM_DRIVED_V_PROC")%> <img src="img/gm0003img.gif" onClick="goRulePage(this.parentElement.index,'<%=rowDetail.getAttribute("REF_MASTER_DATA_PRC_TP")%>','<%=rowDetail.getAttribute("REF_MD_RULE_ID")%>','<%=rowDetail.getAttribute("MD_RULE_DT_NM_DRIVED_V_PROC")%>')" style="cursor:pointer" align="absmiddle"><%
                  }else {
                  %>&nbsp;<%
                  }
                  %></td>
              </tr><%
   iSeq ++;
     } //End while
    %>
              <th width=4% ></th>
              <th width=5% ></th>
              <th width=31%></th>
              <th width=7% ></th>
              <th width=10%></th>
              <th width=11%></th>
              <th width=4% ></th>
              <th width=12%></th>
              <th width=12%></th>
            </table>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
      </form>
<form name="form_rule_data" method="post"><!-- m000202040.do,m000202070.do,m000202080.do-->
<input type="hidden" name="ServiceName"><!-- m000202040-service,m000202070-service,m000202080-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="MdlDefineId">
<input type="hidden" name="MdRuleId">
<input type="hidden" name="MasterDataPrcTp">
</form>
<form name="form_cal_factor" method="post" action="m000203010.do">
<input type="hidden" name="ServiceName" value="m000203010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="factor" value="popup"><!-- event -->
<input type="hidden" name="MdRuleId">
<input type="hidden" name="DtNmId">
</form>
<form name="form_calctest" method="post" action="m000203010.do"><!-- Test -->
<input type="hidden" name="ServiceName" value="m000203010-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="test" value=10><!-- event -->
<input type="hidden" name="MdRuleNm">
</form>
<form name="form_cal_history" method="post" action="m000203010.do"><!-- History -->
<input type="hidden" name="ServiceName" value="m000203010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="history" value=10><!-- event -->
<input type="hidden" name="SearchUseTp" value="%">
<input type="hidden" name="SearchWord" value="<%=(String)headerRow.getAttribute("MD_RULE_NM")%>">
<input type="hidden" name="SearchAttribute" value="MD_RULE_NM">
</form>
    </td>
  </tr>
</table>
</body>
</html>