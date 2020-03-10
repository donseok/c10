<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000010pop01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  제품개발 등록
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.05.03
 *       
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String PRD_DEV_NO = request.getParameter("PRD_DEV_NO")	!=null ? request.getParameter("PRD_DEV_NO") : "";	
	String DEV_REQ_FILE = request.getParameter("DEV_REQ_FILE")	!=null ? request.getParameter("DEV_REQ_FILE") : "";	
	
	PosUser	user = (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String userNo	= "";
	//String userName = "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
	}
	 
	/* String[] valList = {userNo};
 	String ctl_tp = ""; 
	try{
	//MASTER 기준 데이터를 읽어온다.
	PosRuleVO result = EasyAccess.getPosRule("C10A2183", valList, null);
	    
	    if(result.getRecordCount() > 0){
	    ctl_tp      = result.getRuleValueAt("TP");        //화면제어여부
	    }
	}catch(Exception e){
	} */
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
제품개발 등록
</title>
<!--
style type="text/css" media="screen">
html, body { width: 90%; height: 90%;}  
</style
-->
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<script language="JavaScript" type="text/javascript"
	src="./dhtmlx/codebase/dhtmlxvault.js"></script>
<script type="text/javascript">

//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C108000010pop01_Form_1","xml":".\/header\/kr\/C108000010pop01\/C108000010pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C108000010pop01_Form_2","service":"C108000010pop01-service","security":"true","actionType":"find"},' +
      '{"itemType":"form","renderTo":"C108000010pop01_Form_2","xml":".\/header\/kr\/C108000010pop01\/C108000010pop01_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000010pop01_Form_2","service":"C108000010pop01-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C108000010pop01_MessageBox_1","xml":".\/header\/kr\/C108000010pop01\/C108000010pop01_MessageBox_1.xml","service":"C108000010pop01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	 
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function dev_req_save(eventName,formDivObj,referenceItem){
	items['C108000010pop01_Form_2'].getDhxForm().resetDataProcessor("updated");

	var CUS_CD = items['C108000010pop01_Form_2'].getItemValue("CUS_CD");
    var USG_CD = items['C108000010pop01_Form_2'].getItemValue("USG_CD");
    var USE_NAT_CD = items['C108000010pop01_Form_2'].getItemValue("USE_NAT_CD");   
    var APP_SIM_RCV_ADDR = items['C108000010pop01_Form_2'].getItemValue("APP_SIM_RCV_ADDR");    
    var APP_SIM_RCV_NM = items['C108000010pop01_Form_2'].getItemValue("APP_SIM_RCV_NM");
    var APP_SIM_RCV_PHON = items['C108000010pop01_Form_2'].getItemValue("APP_SIM_RCV_PHON");
    var DEV_REQ_RMK = items['C108000010pop01_Form_2'].getItemValue("DEV_REQ_RMK");
    
	items['C108000010pop01_Form_2'].setItemValue("SAL_CHR_PRS_ID", "<%=userNo %>");
    items['C108000010pop01_Form_2'].setItemValue("CUS_CD", CUS_CD);
    
   	if(USG_CD == null ){
   		items['C108000010pop01_Form_2'].setItemValue("USG_CD", '');
   	} else {
   		items['C108000010pop01_Form_2'].setItemValue("USG_CD", USG_CD);
   	}
   	
   	if(USE_NAT_CD == null ){
   		items['C108000010pop01_Form_2'].setItemValue("USE_NAT_CD", '');
   	} else {
   	    items['C108000010pop01_Form_2'].setItemValue("USE_NAT_CD", USE_NAT_CD);
   	}
 
   	if(APP_SIM_RCV_ADDR == null ){
   		items['C108000010pop01_Form_2'].setItemValue("APP_SIM_RCV_ADDR", '');
   	} else {
   		items['C108000010pop01_Form_2'].setItemValue("APP_SIM_RCV_ADDR", APP_SIM_RCV_ADDR);   
   	}
   	
   	if(APP_SIM_RCV_NM == null ){
   		items['C108000010pop01_Form_2'].setItemValue("APP_SIM_RCV_NM", '');
   	} else {
   		items['C108000010pop01_Form_2'].setItemValue("APP_SIM_RCV_NM", APP_SIM_RCV_NM);   
   	}
   	
   	if(APP_SIM_RCV_PHON == null ){
   		items['C108000010pop01_Form_2'].setItemValue("APP_SIM_RCV_PHON", ''); 
   	} else {
   		items['C108000010pop01_Form_2'].setItemValue("APP_SIM_RCV_PHON", APP_SIM_RCV_PHON);   
   	}
   	
   	if(DEV_REQ_RMK == null ){
  	 	items['C108000010pop01_Form_2'].setItemValue("DEV_REQ_RMK", '');   
   	} else {
   		items['C108000010pop01_Form_2'].setItemValue("DEV_REQ_RMK", DEV_REQ_RMK);   
   	}
   	
	if(CUS_CD == null ){
		dhtmlx.alert("고객사는 필수입력입니다.");
		return;
	}
	
/* 	if(USG_CD == '' ){
		dhtmlx.alert("용도는 필수입력입니다.");
		return;
	} */
	
/* 	if(USE_NAT_CD == '' ){
		dhtmlx.alert("사용지역는 필수입력입니다.");
		return;
	} */
   	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"개발요청 저장 하시겠습니까?",
		callback:function(val){
			if(val){
			    items['C108000010pop01_Form_2'].sendForm("handleDataProcess.do",'C108000010pop01_Form_2','dev_req_save');
			}
		}
	}); 	
}

function dev_recv_save(eventName,formDivObj,referenceItem){
	items['C108000010pop01_Form_2'].getDhxForm().resetDataProcessor("updated");
		
	if(isNull("<%=PRD_DEV_NO%>")){	
		dhtmlx.alert("접수요청 번호가 없습니다.");
		return;
	}

	var PROC_SIM_MO = items['C108000010pop01_Form_2'].getItemValue("PROC_SIM_MO");
    var DEV_RECV_RMK = items['C108000010pop01_Form_2'].getItemValue("DEV_RECV_RMK");

	items['C108000010pop01_Form_2'].setItemValue("DEV_RECV_CHR_UID", "<%=userNo %>");
    items['C108000010pop01_Form_2'].setItemValue("PROC_SIM_MO", PROC_SIM_MO);
    items['C108000010pop01_Form_2'].setItemValue("DEV_RECV_RMK", DEV_RECV_RMK);
	
    if(PROC_SIM_MO == null ){
   		items['C108000010pop01_Form_2'].setItemValue("PROC_SIM_MO", ''); 
   	} else {
   		items['C108000010pop01_Form_2'].setItemValue("PROC_SIM_MO", PROC_SIM_MO);   
   	}
    
    if(DEV_RECV_RMK == null ){
   		items['C108000010pop01_Form_2'].setItemValue("DEV_RECV_RMK", ''); 
   	} else {
   		items['C108000010pop01_Form_2'].setItemValue("DEV_RECV_RMK", DEV_RECV_RMK);   
   	}
   	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"개발접수 저장 하시겠습니까?",
		callback:function(val){
			if(val){
				items['C108000010pop01_Form_2'].sendForm("handleDataProcess.do",'C108000010pop01_Form_2','dev_recv_save');
			}
		}
	}); 	
}

function findMessage(referenceItem){
	uiCommon.message("C108000010pop01_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function popClose(){
	parent.find("find","C108000010_Form_1","C108000010_Grid_1","popup");
	parent.winObj.winClose();
}
function onFormLoadFunction(formDivObj){
	var form  = items['C108000010pop01_Form_2'];
		
	var comboList = items['C108000010pop01_Form_2'].getMasterCombos();
	
	comboList['USG_CD'].readonly(true,false);
	ui.combo.master(comboList['USG_CD'],'SZ0000','ORD_USG_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['USG_CD'].selectOption(0,true,true);
		comboList['USG_CD'].readonly(true);
		comboList['USG_CD'].setOptionHeight(120);
	});	

	parent.c10popUp_setVal = masterPopup2SetValue;	
	if(!isNull("<%=PRD_DEV_NO%>")){
		items['C108000010pop01_Form_2'].setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
		var findUrl = uiCommon.parameters6("C108000010pop01_Form_2","C108000010pop01_Form_2","find");
		items['C108000010pop01_Form_2'].loadData(findUrl,findAfterFunction);
	}
	
	items['C108000010pop01_Form_2'].getDhxForm().detachEvent(onXleForm);
	
	if("<%=PRD_DEV_NO%>"=="Y"){
		document.getElementById("save").src = "./dhtmlx/codebase/imgs/save.gif";
	}

	//일자 달력 설정
	//items['C108000010pop01_Form_2'].getItem("SAL_CHR_REQ_DH").setWeekStartDay(7);

	fieldEnable();
}

//접속ID에 따른 항목 enable
function fieldEnable(){
	var formObj  = items['C108000010pop01_Form_2'].getDhxForm();
        
        formObj.disableItem("PRD_DEV_NO");
        formObj.disableItem("REQ_RGS_DH");
        formObj.disableItem("SAL_CHR_PRS_ID");
                        
        formObj.disableItem("DEV_RGS_DH");
        formObj.disableItem("DEV_RECV_CHR_UID");
}

function serchIcon_CUS_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C108000010pop01_Form_2');\">";
}

function serchIcon_NAT_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('NAT_CD','SZ0000','USE_NAT_CD','C108000010pop01_Form_2');\">";
}

function setImgIcon(name,val){
	return "<img id=\"save\" style=\"cursor:pointer\" src='./dhtmlx/codebase/imgs/save_dis.gif' align=\"top\" onClick=\"C10_linkC108000010pop02()\">";
}

var winObj;
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}

var masterPopup2SetValue = function(code,name,target,formId){ //최종값 세팅 
	items[formId].setItemValue(target,code);
}

function findAfterFunction(){
	var uiFormObj = items['C108000010pop01_Form_2'];
	
	uiCommon.message(ui.messagebox.messageBoxDivId,uiFormObj.getItemValue("messageBox"));
	if(uiFormObj.getItemValue("messageBox") == "0"){	
		uiFormObj.clear();
		uiCommon.message(ui.messagebox.messageBoxDivId,"0건 조회되었습니다.");
	}else{
		uiCommon.message(ui.messagebox.messageBoxDivId,uiFormObj.getItemValue("messageBox"));
	}
  	return true;
}

function onAfterUpdateFinishEvent(){
    //var findUrl = uiCommon.parameters6("C108000010pop01_Form_2","C108000010pop01_Form_2","find");
	//items['C108000010pop01_Form_2'].loadData(findUrl,findAfterFunction);
	popClose();
	return true;	
}

/* function onPop01Form2Changed(name, value){ //숫자 Check 
	if(name =="ORD_PRE_WGT"){
		if(!grid_qnty_check("예상수주량(톤)", 4, 1, true, value)){
			items['C108000010pop01_Form_2'].getDhxForm().setItemValue(name, "");
			return true;
		}
	}
} 
*/

function C10_linkC108000010pop02(){
	if(!isNull("<%=PRD_DEV_NO%>")){
			
			winObj = new ui.window("coilImgRegPopWin","비고 이미지 등록","0","0","465","405", "C108000010pop02.jsp?"
					+ "IMG_RGS_TP=1"
					+ "&PRD_DEV_NO=" + "<%=PRD_DEV_NO%>"
					+ "&PRD_DEV_SEQ_NO=0");
			winObj.setButtonDisable("park,minmax1");
			winObj.setModal();
	}else {
		dhtmlx.alert("접수요청 번호가 없습니다.");
	}
}


//]]>
</script>
</head>
<body>
<div id="C108000010pop01_Form_1" style="position:absolute;height:28px;width:870px;left:0px;top:0px;">
</div>
<div id="C108000010pop01_Form_2" style="position:absolute;height:352px;width:870px;left:0px;top:29px;overflow-x:hidden;overflow-y:scroll">
</div>
<div id="C108000010pop01_MessageBox_1" style="position:absolute;height:19px;width:869px;left:1px;top:380px;">
</div>
</body>
</html>
<script>
//<![CDATA[
       ui.initializeDHTMLX();   
	   var onXleForm = items["C108000010pop01_Form_2"].onXLEEvent(onFormLoadFunction);
	   var _onAfterUp = items['C108000010pop01_Form_2'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
       
	  //items['C108000010pop01_Form_2'].onChangeEvent(onPop01Form2Changed);
//]]>
</script>