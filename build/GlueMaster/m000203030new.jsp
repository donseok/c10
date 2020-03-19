<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 계산수식 목록 >> 계산수식 속성등록
 * Open Issues    :
 * Change history 
 * @2008-06-25 김정희 #1.0   최초 생성
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

    PosRowSet rowSet=null;
    PosRow row=null;
    String MasterDataPrcTp = request.getParameter("MasterDataPrcTp");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.078",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showBubbleHelp.js"></script>
<script type="text/javascript" src="js/showCalendar.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
/* validation 체크 */
function checkValid(){
    if(Trim(document.forms[0].MdRuleNm.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)},locale)%>'); //계산식ID
        return false;
    }
    if(Trim(document.forms[0].MdRuleExplain.value)=="") {
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)},locale)%>'); //계산식명
        return false;
    }
    if(Trim(document.forms[0].MdRuleOwnerEmpNo.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)},locale)%>'); //담당자
        return false;
    }
    if(Trim(document.forms[0].MdRuleVersion.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)},locale)%>'); //버전
        return false;
    }
    if(Trim(document.forms[0].StartActiveDate.value)=="" || Trim(document.forms[0].EndActiveDate.value)==""){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)},locale)%>'); //유효일시
        return;
    }
    if(document.forms[0].MasterDataPrcTp.value=="1C0"){
        if(Trim(document.forms[0].MdRuleOperType.value)==""){
            alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)},locale)%>'); //계산공식
            return false;
        }
    }
    if(document.forms[0].MasterDataPrcTp.value=="1C2"){
        var i; 
        if(document.forms[0].calchk==null){
            alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{"1."+PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)},locale)%>'); //계산공식
            return false;
        }
        if(document.forms[0].calchk.length==null){
            if(Trim(document.forms[0].MdRuleDtNmConnectChkTpsd.value)==""){
                alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0074",null,locale)},locale)%>'); //조건식
                return false;
            }
            if(Trim(document.forms[0].MdRuleDecisionRst1.value)==""){
                alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)},locale)%>'); //계산공식
                return false;
            }
        }else{
            for(i=0;i<document.forms[0].calchk.length;i++){
                if(Trim(document.forms[0].MdRuleDtNmConnectChkTpsd[i].value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0074",null,locale)},locale)%>'); //조건식
                    return false;
                }
                if(Trim(document.forms[0].MdRuleDecisionRst1[i].value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)},locale)%>'); //계산공식
                    return false;
                }
            }
        }
    }
    if(Trim(document.forms[0].MdRuleCalcVDecimalPrec.value)=="" || isNaN(Trim(document.forms[0].MdRuleCalcVDecimalPrec.value))){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)},locale)%>'); //소숫점이하
        return false;
    }
    //Input처리 Valid 체크
    if(document.forms[0].inputchk!=null){
        if(document.forms[0].inputchk.length==null){
            if(Trim(document.forms[0].MdRuleDtNmNm.value)==""){
                alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)},locale)%>'); //항목명
                return false;
            }
        }else{
            for(i=0;i<document.forms[0].inputchk.length;i++){
                if(Trim(document.forms[0].MdRuleDtNmNm[i].value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)},locale)%>'); //항목명
                    return false;
                }
            }
        }
        if(document.forms[0].inputchk.length==null){
            if(document.forms[0].MdRuleDtNmCompChkVAppF.value=='M'){
                if(Trim(document.forms[0].MdRuleDtNmDrivedVProc.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)},locale)%>'); //기준ID
                    return false;
                }
            }
            if(document.forms[0].MdRuleDtNmCompChkVAppF.value=='F'){
                if(Trim(document.forms[0].oper_list.value)==""){
                    alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0084",null,locale)},locale)%>'); //상세입력
                    return false;
                }
            }
        }else{
            for(i=0;i<document.forms[0].inputchk.length;i++){
                if(document.forms[0].MdRuleDtNmCompChkVAppF[i].value=='M'){
                    if(Trim(document.forms[0].MdRuleDtNmDrivedVProc[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)},locale)%>'); //기준ID
                        return false;
                    }
                }
                if(document.forms[0].MdRuleDtNmCompChkVAppF[i].value=='F'){
                    if(Trim(document.forms[0].oper_list[i].value)==""){
                        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0024",new Object[]{PosContext.getResourceMessage("GMResource","gm.label.0084",null,locale)},locale)%>'); //상세입력
                        return false;
                    }
                }
            }
        }
    }
    return true;
}
/* 항목명을 선택할 수 있는 팝업창을 띄운다. */
function goAttrsOpen(index){
    document.form_attr.opener_target_id.value=index;
    showPopup("","m000203030_m000200050",800,580,'1',0,0,1,1,1,0,0);
    document.form_attr.target="m000203030_m000200050";
    document.form_attr.submit();
}
/* 업무기준Id에서 Factor를 선택하고 입력버튼을 누를때 팝업창 띄움. */
function showFacPopUp(index){
    document.form_cal_factor.opener_target_id.value = document.forms[0].DtNmId.length>1 ? index   : "0";
    document.form_cal_factor.oper_list.value   = document.forms[0].DtNmId.length>1 ? document.forms[0].oper_list[index].value   : document.forms[0].oper_list.value;
    document.form_cal_factor.comp1_list.value  = document.forms[0].DtNmId.length>1 ? document.forms[0].comp1_list[index].value  : document.forms[0].comp1_list.value;
    document.form_cal_factor.comp2_list.value  = document.forms[0].DtNmId.length>1 ? document.forms[0].comp2_list[index].value  : document.forms[0].comp2_list.value;
    document.form_cal_factor.result_list.value = document.forms[0].DtNmId.length>1 ? document.forms[0].result_list[index].value : document.forms[0].result_list.value;
    showPopup("","m000203030_factor",510,310,'1',0,0,1,1,1,0,0);
    document.form_cal_factor.target="m000203030_factor";
    document.form_cal_factor.submit();
}
/* 저장버튼을 누를때 */
function gm_Save(){
    //Validation체크
    if(!checkValid()){
        return;
    }
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>')){//계산식 내용을 저장하시겠습니까?
        //스트링제작
        makestring();
        document.forms[0].action = document.forms[0].action+"?insert=10";
        document.forms[0].target = "_top";
        document.forms[0].submit();
    }
}
/*--------------------------------------------------------------------------
판단형의 계산공식과 Input처리의 스트링들을 만들어서 form의 Hidden속성에 넣어줌.
--------------------------------------------------------------------------*/       
function makestring(){
    var i;  
    //************** 계산공식에 사용될 변수들 ********************************************************    
    var psd_list="";            //조건식리스트
    var rst_list="";            //계산식리스트 
    //계산공식의 데이타들을 " ;" 구분자를 이용해 목록으로 만든다.
    if(document.forms[0].MdRuleDtNmConnectChkTpsd==null) //행이 아에 없을때
    {
        psd_list="";
        rst_list="";
    } else if(document.forms[0].MdRuleDtNmConnectChkTpsd.length>=2) //행이 둘이상일때
    {
       for(i=0;i<document.forms[0].MdRuleDtNmConnectChkTpsd.length;i++)
        {
            psd_list=psd_list+document.forms[0].MdRuleDtNmConnectChkTpsd[i].value+" ;";
            rst_list=rst_list+document.forms[0].MdRuleDecisionRst1[i].value+" ;";
        }   
    } else //행이 하나 있거나 있더라도 내용이 텅비어 있을때
    {
        if(Trim(document.forms[0].MdRuleDtNmConnectChkTpsd.value)==""&&Trim(document.forms[0].MdRuleDecisionRst1.value)=="")
        {
            psd_list="";  
            rst_list="";
        }
        else
        {
            psd_list=document.forms[0].MdRuleDtNmConnectChkTpsd.value+" ;";
            rst_list=document.forms[0].MdRuleDecisionRst1.value+" ;";
        }
    }
    document.forms[0].psd_list.value=psd_list;
    document.forms[0].rst_list.value=rst_list;  
    //************** Input처리에 사용될 변수들 ******************************************************
    var stdname_list="";        //MdRuleDtNmNm:StandardKoreanName
    var dtnmid_list="";        //DtNmId
    var code_list="";          //코드여부
    var unit_list="";          //단위
    var type_list="";          //데이타타입(히든숫자)
    var len_list="";          //길이
    var proctype_list="";      //처리타입
    var busipnt_list="";      //업무기준ID   

    var oper_list_list="";  //연산자리스트의 리스트
    var comp1_list_list=""; //판단식1의 리스트의 리스트
    var comp2_list_list=""; //판단식2의 리스트의 리스트
    var result_list_list="";//결과값의 리스트의 리스트

   //INPUT처리의 데이타들을 " ;" 구분자를 이용해 목록으로 만든다.
    if(document.forms[0].inputchk==null) //행이 아에 없을때
    {
       stdname_list="";
        dtnmid_list=""; 
        code_list="";
        unit_list="";
        type_list="";
        len_list="";   
        oper_list_list="";
        comp1_list_list="";
        comp2_list_list=""; 
        result_list_list="";
    } else if(document.forms[0].inputchk.length>=2) //행이 둘이상일때     
    {
        for(i=0;i<document.forms[0].inputchk.length;i++)
        {
            stdname_list=stdname_list+document.forms[0].MdRuleDtNmNm[i].value+" ;";
            dtnmid_list=dtnmid_list+document.forms[0].DtNmId[i].value+" ;";
            code_list=code_list+document.forms[0].MdRuleDtNmCdF[i].value+" ;";
            unit_list=unit_list+document.forms[0].MesUnitOfMeasure[i].value+" ;";
            type_list=type_list+document.forms[0].DtNmDataTp[i].value+" ;";
            len_list=len_list+document.forms[0].DtNmLen[i].value+" ;"; 
            proctype_list=proctype_list+document.forms[0].MdRuleDtNmCompChkVAppF[i].value+" ;"; 
            busipnt_list=busipnt_list+document.forms[0].MdRuleDtNmDrivedVProc[i].value+" ;";   
            oper_list_list=oper_list_list+document.forms[0].oper_list[i].value+" ;";
            comp1_list_list=comp1_list_list+document.forms[0].comp1_list[i].value+" ;";
            comp2_list_list=comp2_list_list+document.forms[0].comp2_list[i].value+" ;"; 
            result_list_list=result_list_list+document.forms[0].result_list[i].value+" ;";
        }
    } else //행이 하나 있거나 있더라도 내용이 텅비어 있을때
    {
        if(Trim(document.forms[0].DtNmId.value)=="")
        {
           stdname_list="";
            dtnmid_list=""; 
            code_list="";
            unit_list="";
            type_list="";
            len_list=""; 
            proctype_list=""; 
            busipnt_list=""; 
            oper_list_list="";
            comp1_list_list="";
            comp2_list_list=""; 
            result_list_list="";
        } else
        {
            stdname_list=stdname_list+document.forms[0].MdRuleDtNmNm.value+" ;";
            dtnmid_list=dtnmid_list+document.forms[0].DtNmId.value+" ;";
            code_list=code_list+document.forms[0].MdRuleDtNmCdF.value+" ;";
            unit_list=unit_list+document.forms[0].MesUnitOfMeasure.value+" ;";
            type_list=type_list+document.forms[0].DtNmDataTp.value+" ;";
            len_list=len_list+document.forms[0].DtNmLen.value+" ;"; 
            proctype_list=proctype_list+document.forms[0].MdRuleDtNmCompChkVAppF.value+" ;"; 
            busipnt_list=busipnt_list+document.forms[0].MdRuleDtNmDrivedVProc.value+" ;";  
            oper_list_list=oper_list_list+document.forms[0].oper_list.value+" ;";
            comp1_list_list=comp1_list_list+document.forms[0].comp1_list.value+" ;";
            comp2_list_list=comp2_list_list+document.forms[0].comp2_list.value+" ;"; 
            result_list_list=result_list_list+document.forms[0].result_list.value+" ;";
        }
    }
    document.forms[0].stdname_list.value=stdname_list;
    document.forms[0].dtnmid_list.value=dtnmid_list;
    document.forms[0].code_list.value=code_list;
    document.forms[0].unit_list.value=unit_list;
    document.forms[0].type_list.value=type_list;
    document.forms[0].len_list.value=len_list;
    document.forms[0].proctype_list.value=proctype_list;
    document.forms[0].busipnt_list.value=busipnt_list;   
    document.forms[0].oper_list_list.value=oper_list_list;
    document.forms[0].comp1_list_list.value=comp1_list_list;
    document.forms[0].comp2_list_list.value=comp2_list_list; 
    document.forms[0].result_list_list.value=result_list_list;
}
/* 계산공식 행 삭제전에 체크를 하였는지 조사 */
function delRow_cal_before(table,chk){
    var ok=0;
    if(document.forms[0].calchk==null){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0022",null,locale)%>');//더이상 삭제할 수 없습니다
        return false;
    }
    if(document.forms[0].calchk.length>=2){
        for(var i=0;i<document.forms[0].calchk.length;i++){
            if(document.forms[0].calchk[i].checked==true)
                ok=1;
        }
    }else{
        if(document.forms[0].calchk.checked==true)
                ok=1;
    }
    if(ok==0)
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    else
        delRow(table,chk);
}
/* Input처리 행 삭제전에 체크를 하였는지 조사 */
function delRow_detail_before(table,chk){
    var ok=0;
    if(document.forms[0].inputchk==null){
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0022",null,locale)%>');//더이상 삭제할 수 없습니다
        return false;
    }
    if(document.forms[0].inputchk.length>=2){
        for(var i=0;i<document.forms[0].inputchk.length;i++){
            if(document.forms[0].inputchk[i].checked==true)
                ok=1;
        }
    }else{
        if(document.forms[0].inputchk.checked==true)
                ok=1;
    }
    if(ok==0)
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    else
        delRow(table,chk);
}
/* 항목정보 타입에 따라 업무기준 ID를 Enable/Disable 입력버튼 Show/Hide 시킴. */
function toggle_ruleid(index){
    if(document.forms[0].DtNmId.length>=2){
        if(document.forms[0].MdRuleDtNmCompChkVAppF[index].value=='M'){
            document.forms[0].MdRuleDtNmDrivedVProc[index].style.display='block';
            document.forms[0].getFactor[index].src='img/gm0007img.gif';
        } else if(document.forms[0].MdRuleDtNmCompChkVAppF[index].value=='F'){
            document.forms[0].MdRuleDtNmDrivedVProc[index].style.display='none';
            document.forms[0].getFactor[index].src='<%=PosContext.getResourceMessage("GMResource","gm.img.new",null,locale)%>';
        } else{
            document.forms[0].MdRuleDtNmDrivedVProc[index].style.display='none';
            document.forms[0].getFactor[index].src='img/gm0007img.gif';
        }
    } else{
        if(document.forms[0].MdRuleDtNmCompChkVAppF.value=='M'){
            document.forms[0].MdRuleDtNmDrivedVProc.style.display='block';
            document.forms[0].getFactor.src='img/gm0007img.gif';
        } else if(document.forms[0].MdRuleDtNmCompChkVAppF.value=='F'){
            document.forms[0].MdRuleDtNmDrivedVProc.style.display='none';
            document.forms[0].getFactor.src='<%=PosContext.getResourceMessage("GMResource","gm.img.new",null,locale)%>';
        } else{
            document.forms[0].MdRuleDtNmDrivedVProc.style.display='none';
            document.forms[0].getFactor.src='img/gm0007img.gif';
        }
    }
}
/* 단순형/판단형으로 바꿀때. */
function changetype(){
    //스트링제작
    makestring();
    document.forms[0].action = document.forms[0].action+"?new=10";
    document.forms[0].target = "_top";
    document.forms[0].submit();
}
/* 작업완료 메세지 뿌리기. */
function done_message(msg){
    if(Trim(msg)=="") return false;
    alert(msg); 
    document.forms[0].msg.value="";
}
function gm_select_all(chkname){
    if(chkname=='calchk' && document.forms[0].calchk!=undefined){
        if (document.forms[0].calchk.length >= 2){
            for(i=0; i<document.forms[0].calchk.length; i++){
                document.forms[0].calchk[i].checked = !document.forms[0].calchk[i].checked;
            }
        }else{
            document.forms[0].calchk.checked = !document.forms[0].calchk.checked;
        }
    }else if(chkname=='inputchk' && document.forms[0].inputchk!=undefined){
        if (document.forms[0].inputchk.length >= 2){
            for(i=0; i<document.forms[0].inputchk.length; i++){
                document.forms[0].inputchk[i].checked = !document.forms[0].inputchk[i].checked;
            }
        }else{
            document.forms[0].inputchk.checked = !document.forms[0].inputchk.checked;
        }
    }
}
-->
</script>
</head>
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.078",null,locale)%></div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_cal_data" method="post" action="m000203030.do">
<input type="hidden" name="ServiceName" value="m000203030-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name=psd_list><!--조건식리스트(판단형)-->
<input type="hidden" name=rst_list><!--계산식리스트(판단형)-->
<input type="hidden" name=stdname_list><!--MdRuleDtNmNm : StandardKoreanName-->
<input type="hidden" name=dtnmid_list><!--DtNmId-->
<input type="hidden" name=code_list><!--코드여부-->
<input type="hidden" name=unit_list><!--단위-->
<input type="hidden" name=type_list><!--데이타타입(히든숫자)-->
<input type="hidden" name=len_list><!--길이-->
<input type="hidden" name=proctype_list><!--처리타입-->
<input type="hidden" name=busipnt_list><!--업무기준ID-->   
<input type="hidden" name=oper_list_list><!--Factor 연산자-->
<input type="hidden" name=comp1_list_list><!--Factor 조건식1-->
<input type="hidden" name=comp2_list_list><!--Factor 조건식2-->
<input type="hidden" name=result_list_list><!--Factor 결과값-->
<input type="hidden" name="ActionType_L" value="L">
<input type="hidden" name="ActionType_C" value="C">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td align="right"><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onclick="gm_Save()" style="cursor:pointer"><!-- save --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0095",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdRuleNm" value="" style="width:120" class=adb1 onKeyup="this.value=upperCase(this.value)"></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0096",null,locale)%></td>
                <td class=tbllw width=190><input type="text" name="MdRuleExplain" value="" style="width:180" class=adb1></td>
                <td class=tbldb width=140><%=PosContext.getResourceMessage("GMResource","gm.label.0262",null,locale)%></td>
                <td class=tbllw width=200>
                  <select name="MasterDataPrcTp" class="adf" onChange='javascript:changetype()' style="width:118px">
                    <option value="1C0" <%="1C0".equals(MasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0192",null,locale)%></option>
                    <option value="1C2" <%="1C2".equals(MasterDataPrcTp)?"selected":""%>><%=PosContext.getResourceMessage("GMResource","gm.label.0076",null,locale)%></option>
                  </select>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw colspan=3>
                  <input type="text" name="StartActiveDate" value="<%=PosMasterUtility.getCurTime("yyyy-MM-dd HH:mm:ss")%>" class="adb1" size="19" maxlength="19">
                  <img src="img/gm0002img.gif" style="cursor:pointer" border="0" onClick="javascript:jspCalendar(this.parentElement.index,StartActiveDate,'','true');"> ~
                  <input type="text" name="EndActiveDate" value="2999-12-31 23:59:59" class="adb1" size="19" maxlength="19">
                  <img src="img/gm0002img.gif" style="cursor:pointer" border="0" onClick="javascript:jspCalendar(this.parentElement.index,EndActiveDate,'','true');">
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" name="MdRuleVersion" value="1.0" style="width:50" class=adb1>
                  <select name="UseTp" class="adf">
                    <option value="S">[S]<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
                    <option value="F">[F]<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
                    <option value="Y">[Y]<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                  </select>
                  <select name="MdRuleCngGd" class="adf">
                    <option value="A">[A]<%=PosContext.getResourceMessage("GMResource","gm.label.0019",null,locale)%></option>
                    <option value="B">[B]<%=PosContext.getResourceMessage("GMResource","gm.label.0033",null,locale)%></option>
                  </select>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdRuleOwnerEmpNo" value="<%=UserEmpNo%>" style="width:70" class=adb1 onKeyup="this.value=upperCase(this.value)" onmouseover="tooltipOn('담당자 직번을 입력하세요',WIDTH, 150 );" onmouseout="tooltipOff();"></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0083",null,locale)%></td>
                <td class=tbllw>
                  <select name="HierarchyOwnerShipTp" class="adf"><%
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                  <select name="HierarchyOpTp" class="adf"><%
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
%>
                    <option value="<%=value[0]%>">[<%=value[0]%>]<%=value[1]%></option><%
    }
%>
                  </select>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td valign=top><%
    if("1C0".equals(MasterDataPrcTp))
    {
    //단순형
%> 
            <table width="100%" border=0 cellspacing=0 cellpadding=0>
              <tr valign=bottom height=35>
                <td><div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">1.<%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></div></td>
              </tr>
            </table>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdRuleOperType" value="" size="145" maxLength="200" class=adb1 onKeyup="this.value=upperCase(this.value)" onmouseover="tooltipOn('■ <%=PosContext.getResourceMessage("GMResource","gm.msg.0028",null,locale)%><br>-<%=PosContext.getResourceMessage("GMResource","gm.msg.0019",null,locale)%> : J_ROUND,K_ROUND,TRUNC<br>-SQL SELECT문에서 사용가능한 내장함수 : <br>&nbsp;&nbsp;&nbsp;ABS,SQRT,POWER,TO_DATE 등<br><%=PosContext.getResourceMessage("GMResource","gm.msg.0046",new Object[]{"1"},locale)%>) SQRT(V1/(V2*6.04)+POWER((C1/1000),2))*1000<br><%=PosContext.getResourceMessage("GMResource","gm.msg.0046",new Object[]{"2"},locale)%>) J_ROUND(V1 * C1)*J_ROUND((V2*V3)/1000000) ',WIDTH, 450 );" onmouseout="tooltipOff();"></td><!-- 사용가능함수 예시1 예시2 -->
              </tr>
            </table><%
    } else
    {
    //판단형
%>
            <table width="100%" border=0 cellspacing=0 cellpadding=0>
              <tr valign=bottom height=35>
                <td><div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">1.<%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></div></td>
                <td align=right>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="javascript:return insRow(calculation,hiddenCal,document.forms[0].calchk);" style="cursor:pointer"/><!-- add row -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.deleterow",null,locale)%>" onClick="javascript:return delRow_cal_before(calculation,document.forms[0].calchk)" style="cursor:pointer"/><!-- delete row -->
                </td>
              </tr>
            </table>
            <table width=960 border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class=tbldb height=20>
                <td width='4%'><img src="img/gm0004img.gif" onClick="gm_select_all('calchk')" style="cursor:pointer"></td>
                <td width='45%'><%=PosContext.getResourceMessage("GMResource","gm.label.0074",null,locale)%></td>
                <td width='51%'><%=PosContext.getResourceMessage("GMResource","gm.label.0136",null,locale)%></td>
              </tr>
            </table>
            <DIV id=divBody STYLE='position:relative;overflow-y:scroll;width:980;height:112;top:0;left:0;'>
            <table id=calculation width=960 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF><TBODY></TBODY>
            </table>
            </div><%
    }
%>
          </td>
        </tr>
        <tr>
          <td valign=top>
            <table width="100%" border=0 cellspacing=0 cellpadding=0>
              <tr valign=bottom height=35>
                <td><div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">2.<%=PosContext.getResourceMessage("GMResource","gm.label.0160",null,locale)%></div></td>
              </tr>
            </table>
            <table id=TtableTemp width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0183",null,locale)%></td>
                <td class=tbllw>
                  <select name="MdRuleCalcVRoundF" class="adf">
                    <option value="X" selected> </option>
                    <option value="R"><%=PosContext.getResourceMessage("GMResource","gm.label.0184",null,locale)%></option>
                    <option value="C"><%=PosContext.getResourceMessage("GMResource","gm.label.0221",null,locale)%></option>
                    <option value="U"><%=PosContext.getResourceMessage("GMResource","gm.label.0251",null,locale)%></option>
                    <option value="S"><%=PosContext.getResourceMessage("GMResource","gm.label.0264",null,locale)%></option>
                    <option value="J"><%=PosContext.getResourceMessage("GMResource","gm.label.0265",null,locale)%></option>
                  </select>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdRuleCalcVDecimalPrec" value="" size="33" class=adb1></td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td class=tbllw>
                  <select name="UnitOfMeasure" size=1 class=adf >
                    <option value="" selected>   </option>
                    <option value="dt">dt</option><%
                          rowSet=(PosRowSet)ctx.get("UnitsOfMeasuresVO");
                          while(rowSet.hasNext())
                          {
                              row=rowSet.next();
%>
                    <option value=<%=row.getAttribute("MES_UNIT_OF_MEASURE")%>><%=row.getAttribute("MES_UNIT_OF_MEASURE")%> </option><%
                          }
%>
                  </select>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0094",null,locale)%></td>
                <td class=tbllw colspan=5><input type="text" name="ConnectChkF" value="" size='145' class=adb1 onKeyup="this.value=upperCase(this.value)" onmouseover="tooltipOn('연산자는 등호 혹은 부등호만 가능합니다.<br> 예) V1<=V2',WIDTH, 250 );" onmouseout="tooltipOff();"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td valign=top align=left>
            <table width="100%" border=0 cellspacing=0 cellpadding=0>
              <tr valign=bottom height=35>
                <td><div id=gm_tb_title style="font-family:Verdana;font-size:14px;font-weight:bold;color:000033">3.<%=PosContext.getResourceMessage("GMResource","gm.label.0117",null,locale)%></div></td>
                <td align=right>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="javascript:return insRow(detail,hidden_detail,document.forms[0].inputchk);" style="cursor:pointer"/><!-- add row -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.deleterow",null,locale)%>" onClick="javascript:return delRow_detail_before(detail,document.forms[0].inputchk)" style="cursor:pointer"/><!-- delete row -->
                </td>
              </tr>
            </table>
            <table id=Ttable width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr class=tbldb height=20>
                <td width=3.049%><img src="img/gm0004img.gif" onClick="gm_select_all('inputchk')" style="cursor:pointer"></td>
                <td width=4.065% ><%=PosContext.getResourceMessage("GMResource","gm.label.0085",null,locale)%></td>
                <td width=28.862%><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
                <td width=6.098% ><%=PosContext.getResourceMessage("GMResource","gm.label.0064",null,locale)%></td>
                <td width=12.195%><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td width=9.146% ><%=PosContext.getResourceMessage("GMResource","gm.label.0078",null,locale)%></td>
                <td width=5.081% ><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td width=14.228%><%=PosContext.getResourceMessage("GMResource","gm.label.0245",null,locale)%></td>
                <td width=10.163%><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td width=7.114% ><%=PosContext.getResourceMessage("GMResource","gm.label.0084",null,locale)%></td>
              </tr>
            </table>
            <table id=detail width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
			<TBODY></TBODY>
            </table>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_attr" method="post" action="m000200050.do">
<input type="hidden" name="ServiceName" value="m000200050-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="opener_target_id">
</form>
<form name="form_cal_factor" method="post" action="m000203030.do">
<input type="hidden" name="ServiceName" value="m000203030-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="factor" value="10"><!-- event -->
<input type="hidden" name="opener_target_id">
<input type="hidden" name="oper_list">
<input type="hidden" name="comp1_list">
<input type="hidden" name="comp2_list">
<input type="hidden" name="result_list">
</form>
    </td>
  </tr>
</table>
<div STYLE=display:none id=haha1>
<table id=hiddenCal width=960 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
  <tr class=tblcw height=18>
    <td width='4%'><input type="checkbox" name="calchk" class=adb1></td>
    <td width='45%'><input type="text" name="MdRuleDtNmConnectChkTpsd" size=67 maxLength="150" class=adb1 onKeyup="this.value=upperCase(this.value)" onmouseover="tooltipOn('■ 조건식 표현방법<br>-SQL SELECT문의 WHERE절에 표현되는 형식<br><%=PosContext.getResourceMessage("GMResource","gm.msg.0046",new Object[]{"1"},locale)%>) V3+V4+V5<=2 AND V5<=1<br><%=PosContext.getResourceMessage("GMResource","gm.msg.0046",new Object[]{"2"},locale)%>) ABS(TRUNC(V1,-1)-V2)>10 AND ABS(TRUNC(V1,-1)-V3)<=10',WIDTH, 450 );" onmouseout="tooltipOff();"></td>
    <td width='51%'><input type="text" name="MdRuleDecisionRst1" size=77 class=adb1 onKeyup="this.value=upperCase(this.value)" onmouseover="tooltipOn('■ <%=PosContext.getResourceMessage("GMResource","gm.msg.0028",null,locale)%><br>-<%=PosContext.getResourceMessage("GMResource","gm.msg.0019",null,locale)%> : J_ROUND,K_ROUND,TRUNC<br>-SQL SELECT문에서 사용가능한 내장함수 : <br>&nbsp;&nbsp;&nbsp;ABS,SQRT,POWER,TO_DATE 등<br><%=PosContext.getResourceMessage("GMResource","gm.msg.0046",new Object[]{"1"},locale)%>) SQRT(V1/(V2*6.04)+POWER((C1/1000),2))*1000<br><%=PosContext.getResourceMessage("GMResource","gm.msg.0046",new Object[]{"2"},locale)%>) J_ROUND(V1 * C1)*J_ROUND((V2*V3)/1000000) ',WIDTH, 450 );" onmouseout="tooltipOff();"></td><!-- 사용가능함수 예시1 예시2 -->
  </tr>
</table>
</div>
<div STYLE=display:none id=haha2>
<table id=hidden_detail width=960 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
  <tr class=tblcg height=27>
    <td width=3.049%><input type="checkbox" name="inputchk"></td>
    <td width=4.065%>&nbsp;</td>
    <td width=28.862%><input type="text" name="MdRuleDtNmNm" style=width:245.0 class=adb1 readonly><img src="img/gm0003img.gif" onClick='javascript:return goAttrsOpen(this.parentElement.index)' style="cursor:pointer"></td>
    <td width=6.098%>
      <select name="MdRuleDtNmCdF" class="adf" style="width:50px">
        <option value="Y">Y</option>
        <option value="N">N</option>
      </select>
    </td>
    <td width=12.195% class=tblcw>
      <select name="MesUnitOfMeasure" size=1 class=adf >
        <option value="">   </option>
        <option value="dt">dt</option><%
    rowSet=(PosRowSet)ctx.get("UnitsOfMeasuresVO");
    rowSet.reset();
    while(rowSet.hasNext())
    {
        row=rowSet.next();
%>
        <option value=<%=row.getAttribute("MES_UNIT_OF_MEASURE")%>><%=row.getAttribute("MES_UNIT_OF_MEASURE")%> </option><%
    }
%>
      </select>
    </td>
    <td width=9.146% class=tblcw><input type="text" name="DtNmDataTpMeaning" style=width:80.0;height:18 class=adb1 readonly></td>
    <td width=5.081% class=tblcw><input type="text" name="DtNmLen" style=width:40.0;height:18 class=adb1 onBlur="this.className='adb1'" onFocus="this.className='adf1'" readonly></td>
    <td width=14.228%>
      <select name="MdRuleDtNmCompChkVAppF" class="adf" style="width:130px" onChange="toggle_ruleid(this.parentElement.index)">
        <option value="I"><%=PosContext.getResourceMessage("GMResource","gm.label.0229",null,locale)%></option>
        <option value="F"><%=PosContext.getResourceMessage("GMResource","gm.label.0097",null,locale)%></option>
        <option value="M"><%=PosContext.getResourceMessage("GMResource","gm.label.0186",null,locale)%></option>
        <option value="C"><%=PosContext.getResourceMessage("GMResource","gm.label.0081",null,locale)%></option>
      </select>
    </td>
    <td width=10.163%>&nbsp;<input type="text" name="MdRuleDtNmDrivedVProc" maxlength=8 class=adb1 style=width:90.0;height:18;display:none onBlur="this.className='adb1'" onFocus="this.className='adf1'"></td>
    <td width=7.114%><img src='img/gm0007img.gif' name=getFactor onclick=showFacPopUp(this.parentElement.index) style="cursor:pointer"></td>
    <input type="hidden" name=oper_list value=''>
    <input type="hidden" name=comp1_list value=''>
    <input type="hidden" name=comp2_list value=''>
    <input type="hidden" name=result_list value=''>
    <input type="hidden" name="DtNmId">
    <input type="hidden" name="DtNmDataTp">
    <input type="hidden" name="DtNmDecimalPrec">
    <input type="hidden" name="MdlDefineDtNmMrkNm">
  </tr>
</table>
</div>
</body>
</html>