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
 * @2008-06-16 류진영 #1.0   최초 생성
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

    // Page 관련 추가사항들... (begin)
    String curPage  = request.getParameter("curPage")==null?"1":request.getParameter("curPage");

    int                 rowCnt              =   0;
    int                 keyCnt              =   0;
    int                 dataCnt             =   0;
    int                 seq                 =   0;
    int inputWidth=0;
    String              operation           =   "";
    String              sModifyYn           =   "";
    ArrayList           mdMasSearchGrKeyF   =   new ArrayList();
    ArrayList filedNams    = new ArrayList();
    ArrayList dbFiledName  = new ArrayList();

    PosRowSet rowSet = (PosRowSet)ctx.get("Rule010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1B0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0191",null,locale);
    else if("1B1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0151",null,locale);

    String recordResp = headerRow.getAttribute("ATTRIBUTE3")==null?"N":headerRow.getAttribute("ATTRIBUTE3").toString();

    rowSet = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    PosRow row;
    if(rowSet.hasNext()){
        while(rowSet.hasNext())
        {
            row = rowSet.next();
            if("I".equals(row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")))
            {
                keyCnt++;
                /* 검색구분키로 정의되어 있는항목의 Seq를 추출*/
                if("Y".equals(row.getAttribute("MD_BAS_SEARCH_GR_KEY_F")))
                {
                    mdMasSearchGrKeyF.add(String.valueOf(row.getAttribute("MD_RULE_DT_NM_SEQ")));
                }
            } else
            {
                dataCnt++;
            }
            filedNams.add(row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS"));
            dbFiledName.add(String.valueOf(row.getAttribute("MD_RULE_DT_NM_SEQ")));
        }
    
        if(((keyCnt*3)*80+(dataCnt*150))+100<958)
        {
            inputWidth=80+(958-(dataCnt*150)-((keyCnt*3)*80)-115)/(keyCnt*3);
        } else
        {
            inputWidth=100;
        }
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.064",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/checkSelectBoxChecked.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showBubbleHelp.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function cntCheckBox(form) {
    var cnt = 0;
    for(var i = 0; i < form.elements.length ; i++) {
       if ((form.elements[i].type == "checkbox")) {
           cnt++;
       }
    }
    return cnt;
}
function goPage(actionType){
    document.forms[0].sHSearchIs.value="";
    document.forms[0].action=document.forms[0].action+"?saveData=true&curPage=1";
    document.forms[0].submit();
    return;
}
function goLayout(){
    document.forms[0].action="m000202060.do<%="S".equals(UseTp)?"?inputLayout=true":""%>";
    document.forms[0].ServiceName.value="m000202060-service";
    document.forms[0].submit();
}
function goVersion(){
    document.form_rule_hitory.target = "_self";
    document.form_rule_hitory.submit();
}
function goSave(){
    if(!checkSelectbox(document.forms[0]) && document.forms[0].UseTp.value == "<%=UseTp%>"){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return;
    }
    if( checkCondition()==true){
        document.forms[0].action=document.forms[0].action+"?save=10";
        document.forms[0].submit();
    }
}
function goDelete(){
    if(!checkSelectbox(document.forms[0])){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0029",null,locale)%>')){//삭제 하시겠습니까?
        document.forms[0].action=document.forms[0].action+"?delete=10";
        document.forms[0].submit();
    }
}
function gm_select_all(){
    if (document.forms[0].TbM00Rules040VO_chk.length >= 2){
        for(i=0; i<document.forms[0].TbM00Rules040VO_chk.length; i++){
            document.forms[0].TbM00Rules040VO_chk[i].checked = !document.forms[0].TbM00Rules040VO_chk[i].checked;
        }
    }else{
        document.forms[0].TbM00Rules040VO_chk.checked = !document.forms[0].TbM00Rules040VO_chk.checked;
    }
}
function goImport(){
    showPopup("","m000202070_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000202070_import";
    document.form_import.submit();
}
function checkCondition(){
    var subForm = document.forms[0];

    var maxRowCnt = subForm.TbM00Rules040VO_chk.length;
    var priority="";
    var op = "";
    var min ="";
    var max ="";
    var result ="";

//에러체크
    for( var i = 1; i < maxRowCnt*1 ;  i ++){ //row

<%
        for( int j =0; j <keyCnt ; j ++){//colum
%>
            if(subForm.TbM00Rules040VO_chk[i].checked!=true){
                continue;
            }
            op = subForm.MdRuleConOlstatr<%= j+1 %>[i].value;
            min = subForm.MdRuleConMiV<%= j+1 %>[i].value;
            max = subForm.MdRuleConMaxV<%= j+1 %>[i].value;
            priority = subForm.MdRuleConDoSeq[i].value;

            if(op=="NOT_CHECK"||op=="NOT_NULL"||op=="IS_NULL"){

            }else if( op == "BETWEEN1"||op == "BETWEEN2"||op == "BETWEEN3"||op == "BETWEEN4" ){
                if( min == "" ) {
                    alert(i+"번째줄 <%= j+1 %>번째 비교값1을 입력하세요");
                    subForm.MdRuleConMiV<%= j+1 %>[i].focus();
                    return;
                }
                if( max == "" ) {
                    alert(i+"번째줄 <%= j+1 %>번째 비교값2을 입력하세요");
                    subForm.MdRuleConMaxV<%= j+1 %>[i].focus();
                    return;
                }
            } else {
                if( min == "" ) {
                    alert(i+"번째줄 <%= j+1 %>번째 비교값1을 입력하세요");
                    subForm.MdRuleConMiV<%= j+1 %>[i].focus();
                    return;
                }
            }
<%
    }
%>
        }//for
        return true;
    }
/* ************************ 행추가에 관련된 Script*********************************/
function insRow2(table_id,eTable_id,esubTable_id,chkname,sub_table_id){
    var cnt=0;
    insertRowNochk2(table_id,eTable_id,sub_table_id,esubTable_id);
    cnt=cntCheckBox(document.forms[0]);
    if(cnt==1){
        document.forms[0].TbM00Rules040VO_chk.focus();
        document.forms[0].MdRuleConOlstatr1.focus();
    }else if(cnt==2){
        document.forms[0].TbM00Rules040VO_chk[1].focus();
        document.forms[0].MdRuleConOlstatr1[1].focus();
    }else{
        document.forms[0].TbM00Rules040VO_chk[chkname.length-1].focus();
        document.forms[0].MdRuleConOlstatr1[chkname.length-1].focus();
    }
    return false;
}
function insertRow2(tdtag,subtdtag) {
    tdtag.nextSibling.firstChild.value='';
    var trtag = tdtag.parentElement;
    var oCloneswapallNode = trtag.cloneNode(true);
    trtag.parentElement.insertBefore(oCloneswapallNode,trtag);
    var subtrtag = subtdtag.parentElement;
    var suboCloneswapallNode = subtrtag.cloneNode(true);
    subtrtag.parentElement.insertBefore(suboCloneswapallNode,subtrtag);
    swapall2(trtag,trtag.nextSibling,subtrtag,subtrtag.nextSibling);
}
function swapall2(trtag,Ttag,subtrtag,subTtag) {
    var node;
    var chktag = getFirstChild(getFirstChild(trtag));
    // 다음 row가 존재시
    if (trtag.nextSibling) {
        for(var ch =0 ; ch <trtag.childNodes.length ; ch++){
            if(ch==0) chktag.value = Ttag.rowIndex-1;
            trtag.childNodes[ch].index = Ttag.rowIndex-1;
        }
        for(var ch =0 ; ch <subtrtag.childNodes.length ; ch++){
            subtrtag.childNodes[ch].index =Ttag.rowIndex-1;
        }
        swapall2(getNextSibling(trtag),getNextSibling(Ttag),getNextSibling(subtrtag),getNextSibling(subTtag));
    //다음 row가 미존재시(마지막 Row일때)
    } else {
        for(var ce =0 ; ce <trtag.childNodes.length ; ce++){
            if(ce==0) chktag.value =  trtag.rowIndex;
            trtag.childNodes[ce].index = trtag.rowIndex;
        }
        for(var ce =0 ; ce <subtrtag.childNodes.length ; ce++){
            subtrtag.childNodes[ce].index = subtrtag.rowIndex;
        }
    }
}
function insertRowNochk2(table_id,eTable_id,sub_table_id,esubTable_id){
   var hTrtag = eTable_id.rows[0];
    var oCloneNode = hTrtag.cloneNode(true);
    table_id.rows[0].parentNode.insertBefore(oCloneNode,null);
    var trtag=table_id.rows[0];

    var subhTrtag = esubTable_id.rows[0];
    var suboCloneNode = subhTrtag.cloneNode(true);
    sub_table_id.rows[0].parentNode.insertBefore(suboCloneNode,null);
    var subtrtag=sub_table_id.rows[0];
    swapall2(trtag,getNextSibling(trtag),subtrtag,getNextSibling(subtrtag));
}
/* ************************ 행추가에 관련된 Script*********************************/
function divDataOnscroll(){
    //Chrome에서 '<SCRIPT FOR=divData EVENT=onscroll>'형식을 지원하지 않아 별도의 function으로 분리하여 호출하였음.
    document.all.divTop.scrollLeft = document.all.divData.scrollLeft;
    document.all.divLeft.scrollTop = document.all.divData.scrollTop;
}

function showHSearch(){
    document.getElementById('hSearchDiv').style.display='block';
}
function closeHSearch(){
    document.getElementById('hSearchDiv').style.display='none';
}
function goHSearch(){
    document.forms[0].action=document.forms[0].action+"?saveData=true&curPage=1";
    document.forms[0].sHSearchIs.value="H";
    document.forms[0].submit();
}
-->
</script>
</head>
<!-- 풍선도움말을 위한 Div Layer -->
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage);">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.064",null,locale)%></div></td>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.layout",null,locale)%>" onClick="goLayout()" style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.history",null,locale)%>" onClick="goVersion()" style="cursor:pointer">
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
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
<input type="hidden" name="modifyFlag" value="true">
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
          <td>
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
                  <input type="text" name="StartActiveDate" value="<%=(String)headerRow.getAttribute("START_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly> ~
                  <input type="text" name="EndActiveDate" value="<%=headerRow.getAttribute("END_ACTIVE_DATE_STR")==null?"2999-12-31 23:59:59":(String)headerRow.getAttribute("END_ACTIVE_DATE_STR")%>" style="width:120" class=adb1>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MD_RULE_VERSION")%>" style="width:50" class=adg1 readonly><%
    if("Y".equals(UseTp)){
%>
                  <select name="UseTp" class="adf">
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>>[Y]<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                    <option value="N" <%="N".equals(UseTp)?"selected":""%>>[N]<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
                  </select><%
    }else if("N".equals(UseTp)){
%>
                  <select name="UseTp" class="adf">
                    <option value="N" <%="N".equals(UseTp)?"selected":""%>>[N]<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
                  </select><%
    }else{
%>
                  <select name="UseTp" class="adf">
                    <option value="S" <%="S".equals(UseTp)?"selected":""%>>[S]<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
                    <option value="F" <%="F".equals(UseTp)?"selected":""%>>[F]<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>>[Y]<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                  </select><%
    }
%>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MD_RULE_CNG_GD")%>" style="width:50" class=adg1 readonly>
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
          <td>
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
                  <input type="text" name="SearchWord" value='<%=SearchWord%>' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' onmouseover="tooltipOn('■ 주요 연산자 유형<br>BETWEEN1(<=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><=)<br>BETWEEN2(<=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><)<br>BETWEEN3(<<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><=)<br>BETWEEN4(<<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%><)<br>LIKE1(%LIKE%)<br>LIKE2(%LIKE)<br>LIKE3(LIKE%)',WIDTH, 170 );" onmouseout="tooltipOff();">
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goPage('modifyAttrFind.x')" style="cursor:pointer" align='absmiddle'>
                  <a href="javascript:showHSearch();" style="padding-left:10px;"><%=PosContext.getResourceMessage("GMResource","gm.label.0286",null,locale)%></a>
                </td>
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="insRow2(maintable,hiddenTable,hiddenTableSub,document.forms[0].TbM00Rules040VO_chk,subtable)" style="cursor:pointer"><!-- add row -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goSave()" style="cursor:pointer"><!-- save -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.delete",null,locale)%>" onClick="goDelete()" style="cursor:pointer"><!-- delete -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goImport()" style="cursor:pointer"><!-- import --><% } %>
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
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="right">
                  <div id=divSpec style="position:relative;overflow:hidden;width:120;height:56;top:0;left:0;">
                  <table width="120" border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb height=54>
                      <td width=25><img src="img/gm0004img.gif" onClick="gm_select_all()" style="cursor:pointer"></td>
                      <td width=35>no.</td>
                      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0162",null,locale)%></td>
                    </tr>
                  </table>
                  </div>
                </td>
                <td align="left">
                  <div id=divTop style="position:relative;overflow:hidden;width:840;height:56;top:0;left:0;">
                  <table width=<%= (keyCnt*3)*(inputWidth+5)+dataCnt*150%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb height=18>
                      <td colspan=<%=keyCnt*3%>><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
                      <td colspan=<%=dataCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td>
                    </tr>
                    <tr class=tbldb height=18><%
/**************    TITLE 부분을 출력한다 **********************************************************/
    rowSet = (PosRowSet)ctx.get("DecisionRuleLayoutDataRowResult");
    rowSet.reset();
    while(rowSet.hasNext())
    {
        row=rowSet.next();
        if("I".equals(row.getAttribute("MD_RULE_DT_NM_COMP_CHK_V_APP_F")))
        {
%>
                      <td colspan=3 TITLE='<%= row.getAttribute("STANDARD_KOREAN_NAME")%>'><%= row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS")%></td><%
        }else
        {
%>
                      <td rowspan=2 width=150 TITLE='<%= row.getAttribute("STANDARD_KOREAN_NAME")%>'><%= row.getAttribute("MD_RULE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MD_RULE_DT_NM_ALIAS")%></td><%
        }
    }
%>
                    </tr>
                    <tr class=tbllb height=18><%               for(int i=0;i<keyCnt;i++) {%>
                      <td width=<%=inputWidth+15%>><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%></td>
                      <td width=<%=inputWidth%>><%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%></td>
                      <td width=<%=inputWidth%>><%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%></td><% } %>
                    </tr>
                  </table>
                  </div>
                </td>
              </tr>
              <tr>
                <td align="right" valign=top>
                  <div id=divLeft style="position:relative;overflow:hidden;width:120;height:354;top:0;left:0;">
                  <table id=maintable width=120 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF><%
    sModifyYn=""; //checkbox disabled 용
    if("Y".equals(sModifyYn) || "N".equals(recordResp)){
        sModifyYn="";
    }else{
        sModifyYn="disabled";
    }
%>
                    <tr index=0 height=18 class=tblcm>
                      <td width=25><input type="checkbox" name="TbM00Rules040VO_chk" value=0 <%=sModifyYn%>></td>
                      <td width=35>&nbsp;</td>
                      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%></td>
                      <input type="hidden" name="TbM00Rules040VOMdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
                      <input type="hidden" name="MdRuleConNum" value="0">
                      <input type="hidden" name="MdRuleConDoSeq" value="">
                    </tr><%

    rowCnt=1;
    rowSet = (PosRowSet)ctx.get("DecisionRuleDataRowResult");
    rowSet.reset();
    while(rowSet.hasNext())
    {
        row=rowSet.next();
        sModifyYn=(String)row.getAttribute("MODIFY_YN"); //checkbox disabled 용
        if("Y".equals(sModifyYn) || "N".equals(recordResp)){
            sModifyYn="";
        }else{
            sModifyYn="disabled";
        }
%>
                    <tr index=<%=rowCnt%> class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> height=18>
                      <td width=25><input type="checkbox" name="TbM00Rules040VO_chk" value=<%=rowCnt%> <%= sModifyYn%>></td>
                      <td width=35><%= Integer.parseInt(curPage)*15-15+rowCnt%></td>
                      <td><input type="text" name="MdRuleConDoSeq" value='<%=row.getAttribute("MD_RULE_CON_DO_SEQ")==null?"":row.getAttribute("MD_RULE_CON_DO_SEQ")%>' class=adb1 size=3></td>
                      <input type="hidden" name="TbM00Rules040VOMdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
                      <input type="hidden" name="MdRuleConNum" value=<%=row.getAttribute("MD_RULE_CON_NUM")%>>
                    </tr><%
        rowCnt++;
    }
    int unFixedheight = 0;
    if((keyCnt*3)*inputWidth+dataCnt*150 > 840)
    {
        unFixedheight = 370;
    }else
    {
        unFixedheight = 354;
    }
%>
                  </table>
                  </div>
                </td>
                <td align="left" valign=top>
                  <DIV ID=divData STYLE="position:relative;overflow:auto;width:860;height:<%=unFixedheight%>;top:0;left:0;" onscroll="divDataOnscroll()">
                  <table id=subtable width="<%=(keyCnt*3)*(inputWidth+5)+dataCnt*150%>" BORDER=1 CELLSPACING=0 CELLPADDING=0 BORDERCOLORLIGHT=666666 BORDERCOLORDARK=ffffff>
                    <tr index=0 height=18 class=tblcm>
                      <td colspan=<%=keyCnt*3%>><%=PosContext.getResourceMessage("GMResource","gm.msg.0042",null,locale)%><%//아래조건을 만족하지 않을경우 적용
    for(int i=0;i<keyCnt;i++)
    {
%>
                      <input type="hidden" name=<%="MdRuleConOlstatr"+(i+1)%> value="">
                      <input type="hidden" name=<%="MdRuleConMiV"+(i+1)%> value="">
                      <input type="hidden" name=<%="MdRuleConMaxV"+(i+1)%> value=""><%
    }
                      %></td><%
    rowSet = (PosRowSet)ctx.get("DecisionRuleDataRowResultException");
    if(rowSet!=null && rowSet.hasNext()){
        row = rowSet.next();
        for(int i=0;i<dataCnt;i++)
        { %>
                      <td width=150><input type="text" name='<%="MdRuleDecisionRst"+(i+1)%>' value='<%=row.getAttribute("MD_RULE_DECISION_RST"+(i+1))==null?"":row.getAttribute("MD_RULE_DECISION_RST"+(i+1))%>' size=20 class=adb1></td><%
        }
    }else{
        for(int i=0;i<dataCnt;i++)
        { %>
                      <td width=150><input type="text" name='<%="MdRuleDecisionRst"+(i+1)%>' value='' size=20 class=adb1></td><%
        }
    }
%>
                    </tr><%
    rowSet = (PosRowSet)ctx.get("DecisionRuleDataRowResult");
    rowSet.reset();
    rowCnt=1;
    while(rowSet.hasNext())
    {
%>
                    <tr index=<%=rowCnt%> class=<%=(rowCnt%2==1?"tblcg":"tblcw")%> height=18><%
        row = rowSet.next();
        for(int i=0;i<keyCnt;i++)
        {
%>
                      <td width=<%=inputWidth+15%>>
                        <select class=adb1 name='<%="MdRuleConOlstatr"+(i+1)%>' style=width:93><%
            /* MasterData기준검색그룹Key로 정의된 항목은 연산자를 "=" 로 고정시킨다 만일 =아니면 select box를 선택하루 있게 해준다"*/
            operation= String.valueOf(row.getAttribute("MD_RULE_CON_OLSTATR_"+(i+1)));
            if(mdMasSearchGrKeyF.indexOf(String.valueOf(i+1))<0)
            {
%>
                          <option value='NOT_CHECK' <%=("NOT_CHECK".equalsIgnoreCase(operation))?"selected":"" %>><%=PosContext.getResourceMessage("GMResource","gm.label.0153",null,locale)%></option>
                          <option value='=' <%=        ("="        .equalsIgnoreCase(operation))?"selected":"" %>>=</option>
                          <option value='!=' <%=       ("!="       .equalsIgnoreCase(operation))?"selected":"" %>><%=PosContext.getResourceMessage("GMResource","gm.label.0154",null,locale)%></option>
                          <option value='>' <%=        (">"        .equalsIgnoreCase(operation))?"selected":"" %>>&gt;</option>
                          <option value='>=' <%=       (">="       .equalsIgnoreCase(operation))?"selected":"" %>>&gt;=</option>
                          <option value='<' <%=        ("<"        .equalsIgnoreCase(operation))?"selected":"" %>>&lt;</option>
                          <option value='<=' <%=       ("<="       .equalsIgnoreCase(operation))?"selected":"" %>>&lt;=</option>
                          <option value='BETWEEN1' <%= ("BETWEEN1" .equalsIgnoreCase(operation))?"selected":"" %>>&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=</option>
                          <option value='BETWEEN2' <%= ("BETWEEN2" .equalsIgnoreCase(operation))?"selected":"" %>>&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;</option>
                          <option value='BETWEEN3' <%= ("BETWEEN3" .equalsIgnoreCase(operation))?"selected":"" %>>&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=</option>
                          <option value='BETWEEN4' <%= ("BETWEEN4" .equalsIgnoreCase(operation))?"selected":"" %>>&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;</option>
                          <option value='LIKE1' <%=    ("LIKE1"    .equalsIgnoreCase(operation))?"selected":"" %>>%LIKE%</option>
                          <option value='LIKE2' <%=    ("LIKE2"    .equalsIgnoreCase(operation))?"selected":"" %>>%LIKE</option>
                          <option value='LIKE3' <%=    ("LIKE3"    .equalsIgnoreCase(operation))?"selected":"" %>>LIKE%</option>
                          <option value='IN' <%=       ("IN"       .equalsIgnoreCase(operation))?"selected":"" %>>IN</option>
                          <option value='NOT_IN' <%=   ("NOT_IN"   .equalsIgnoreCase(operation))?"selected":"" %>>NOT_IN</option>
                          <option value='NOT_NULL' <%= ("NOT_NULL" .equalsIgnoreCase(operation))?"selected":"" %>>NOT_NULL</option>
                          <option value='IS_NULL' <%=  ("IS_NULL"  .equalsIgnoreCase(operation))?"selected":"" %>>IS_NULL</option><%
            }
            else
            {
%>
                          <%= ("NOT_CHECK".equalsIgnoreCase(operation))?"<option value='NOT_CHECK' selected>"+PosContext.getResourceMessage("GMResource","gm.label.0153",null,locale)+"</option>":""%>
                          <option value='=' <%= ("=".equalsIgnoreCase(operation))?"selected":""%>>=</option>
                          <%= ("!=".equalsIgnoreCase(operation))?     "<option value='!=' selected>"+PosContext.getResourceMessage("GMResource","gm.label.0154",null,locale)+"</option>":""%>
                          <%= (">".equalsIgnoreCase(operation))?      "<option value='>' selected>&gt;</option>":""%>
                          <%= (">=".equalsIgnoreCase(operation))?     "<option value='>=' selected>&gt;=</option>":""%>
                          <%= ("<".equalsIgnoreCase(operation))?      "<option value='<' selected>&lt;</option>":""%>
                          <%= ("<=".equalsIgnoreCase(operation))?     "<option value='<=' selected>&lt;=</option>":""%>
                          <%= ("BETWEEN1".equalsIgnoreCase(operation))?"<option value='BETWEEN1' selected>&lt;=변수&lt;=</option>":""%>
                          <%= ("BETWEEN2".equalsIgnoreCase(operation))?"<option value='BETWEEN2' selected>&lt;=변수&lt</option>":""%>
                          <%= ("BETWEEN3".equalsIgnoreCase(operation))?"<option value='BETWEEN3' selected>&lt;변수&lt;=</option>":""%>
                          <%= ("BETWEEN4".equalsIgnoreCase(operation))?"<option value='BETWEEN3' selected>&lt;변수&lt;</option>":""%>
                          <%= ("LIKE1".equalsIgnoreCase(operation))?  "<option value='LIKE1' selected>%LIKE%</option>":""%>
                          <%= ("LIKE2".equalsIgnoreCase(operation))?  "<option value='LIKE2' selected>%LIKE</option>":""%>
                          <%= ("LIKE3".equalsIgnoreCase(operation))?  "<option value='LIKE2' selected>LIKE%</option>":""%>
                          <%= ("IN".equalsIgnoreCase(operation))?     "<option value='IN' selected>IN</option>":""%>
                          <%= ("NOT_IN".equalsIgnoreCase(operation))? "<option value='NOT_IN' selected>NOT_IN</option>":""%>
                          <%= ("NOT_NULL".equalsIgnoreCase(operation))?"<option value='NOT_NULL' selected>NOT_NULL</option>":""%>
                          <%= ("IS_NULL".equalsIgnoreCase(operation))?"<option value='IS_NULL' selected>IS_NULL</option>":""%><%
            }
%>
                        </select>
                      </td>
                      <td width=<%=inputWidth%>><input type="text" name='<%="MdRuleConMiV" +(i+1)%>' value='<%=row.getAttribute("MD_RULE_CON_MI_V_" +(i+1))==null?"":row.getAttribute("MD_RULE_CON_MI_V_" +(i+1))%>' size=10 class=adb1></td>
                      <td width=<%=inputWidth%>><input type="text" name='<%="MdRuleConMaxV"+(i+1)%>' value='<%=row.getAttribute("MD_RULE_CON_MAX_V_"+(i+1))==null?"":row.getAttribute("MD_RULE_CON_MAX_V_"+(i+1))%>' size=10 class=adb1></td><%
        }
        for(int i=0;i<dataCnt;i++)
        {
%>
                      <td width=150><input type="text" name='<%="MdRuleDecisionRst"+(i+1)%>' value='<%=row.getAttribute("MD_RULE_DECISION_RST"+(i+1))==null?"":row.getAttribute("MD_RULE_DECISION_RST"+(i+1))%>' size=20 class=adb1></td><%
        }
        rowCnt++;
%>
                    </tr><%
    }//END WHILE
%>
                  </table>
                  </div>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <posui:showPageSet infoName="DecisionRuleDataRowResult" formName="document.forms[0]" curPageName="curPage" paramNames="saveData" paramValues="1"/>
          </td>
        </tr>
<!--*******************************  페이지나누기 테이블 ******************************* -->
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
<form name="form_import" method="post" action="m000202070.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000202070-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="MdRuleNm" value="<%=headerRow.getAttribute("MD_RULE_NM")%>">
<input type="hidden" name="MdRuleId" value="<%=headerRow.getAttribute("MD_RULE_ID")%>">
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
<input type="hidden" name="modifyFlag" value="true">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
</form>
   </td>
  </tr>
</table>
<!-- *******************************   hidden 페이지 행추가시 필요함 *********************************************-->
<div style=display:none>
<table id=hiddenTable width=120 border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
  <tr class=tblcw height=18>
    <td index=0 width=25><input type="checkbox" name="TbM00Rules040VO_chk" value='0' checked></td>
    <td index=0 width=35>&nbsp;</td>
    <td index=0><input type="text" name="MdRuleConDoSeq" class=adb1 size=3></td>
    <input type="hidden" name=MdRuleConNum value=''>
  </tr>
</table>
<table id=hiddenTableSub width="<%= (keyCnt*3)*inputWidth+dataCnt*150%>" border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666  bordercolordark=FFFFFF>
  <tr class=tblcw height=18><%
    for(int i=0;i<keyCnt;i++)
    {
%>
    <td index=0 width=<%=inputWidth%>><%
        if(mdMasSearchGrKeyF.indexOf(String.valueOf(i+1))<0)
        {
%>
      <select class=adb1 name='<%="MdRuleConOlstatr"+(i+1)%>' style=width:93>
        <option value='NOT_CHECK' ><%=PosContext.getResourceMessage("GMResource","gm.label.0153",null,locale)%></option>
        <option value='=' >=</option>
        <option value='!=' ><%=PosContext.getResourceMessage("GMResource","gm.label.0154",null,locale)%></option>
        <option value='>' >&gt;</option>
        <option value='>=' >&gt;=</option>
        <option value='<' >&lt;</option>
        <option value='<=' >&lt;=</option>
        <option value='BETWEEN1' >&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=</option>
        <option value='BETWEEN2' >&lt;=<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;</option>
        <option value='BETWEEN3' >&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;=</option>
        <option value='BETWEEN4' >&lt;<%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%>&lt;</option>
        <option value='LIKE1'>%LIKE%</option>
        <option value='LIKE2' >%LIKE</option>
        <option value='LIKE3' >LIKE%</option>
        <option value='IN' >IN</option>
        <option value='NOT_IN' >NOT_IN</option>
        <option value='NOT_NULL' >NOT_NULL</option>
        <option value='IS_NULL' >IS_NULL</option>
      </select><%
      /*MasterData기준검색그룹Key로 정의된 항목은 "="연산자 사용*/
        }
        else
        {
%>
      <select class=adb1 name='<%="MdRuleConOlstatr"+(i+1)%>' style=width:80>
        <option selected value='='>=</option>
      </select><%
        }
%>
    </td>
    <td index=0 width='<%=inputWidth%>'><input type="text" name='<%="MdRuleConMiV" +(i+1)%>' size=10 class=adb1></td>
    <td index=0 width='<%=inputWidth%>'><input type="text" name='<%="MdRuleConMaxV"+(i+1)%>' size=10 class=adb1></td><%
    }
    for(int i=0;i<dataCnt;i++)
    {
%>
    <td index=0 width=150><input type="text" name='<%="MdRuleDecisionRst"+(i+1)%>' size=20 class=adb1></td><%
    }
%>
  </tr>
</table>
</div>
</body>
</html>