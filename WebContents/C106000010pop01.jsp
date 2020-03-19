<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000010pop01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  칼라시편관리 popup
 * DESIGNER NAME    :  김 종 화
 * DEVELOPER NAME   :  김 종 화
 * CREATE DATE      :  2013.12.05
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2013.12.05     V1.0      김 종 화      Initial Version
 * 변경일자        
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String CLR_SMP_REQ_NO = request.getParameter("CLR_SMP_REQ_NO")	!=null ? request.getParameter("CLR_SMP_REQ_NO") : "";	
	
	PosUser	user = (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String userNo	= "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
	}
	 
	String[] valList = {userNo};
	String ctl_tp = ""; 
	try{
	//MASTER 기준 데이터를 읽어온다.
	PosRuleVO result = EasyAccess.getPosRule("C10A2183", valList, null);
	    
	    if(result.getRecordCount() > 0){
	    ctl_tp      = result.getRuleValueAt("TP");        //화면제어여부
	    }
	}catch(Exception e){
	}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C106000010pop01
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
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000010pop01_Form_1","xml":".\/header\/kr\/C106000010pop01\/C106000010pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C106000010pop01_Form_2","service":"C106000010pop01-service","actionType":"find"},' +
      '{"itemType":"form","renderTo":"C106000010pop01_Form_2","xml":".\/header\/kr\/C106000010pop01\/C106000010pop01_Form_2.xml","url":"basicFormData.do","referenceItem":"C106000010pop01_Form_2","service":"C106000010pop01-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000010pop01_MessageBox_1","xml":".\/header\/kr\/C106000010pop01\/C106000010pop01_MessageBox_1.xml","service":"C106000010pop01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	 
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
	items['C106000010pop01_Form_2'].getDhxForm().resetDataProcessor("updated");

    var SAL_CHR_REQ_DH = items['C106000010pop01_Form_2'].getItemValue("SAL_CHR_REQ_DH");
    var SAL_CHR_RGN_DH = items['C106000010pop01_Form_2'].getItemValue("SAL_CHR_RGN_DH");
    var CLR_SMP_DEV_REQ_DH = items['C106000010pop01_Form_2'].getItemValue("CLR_SMP_DEV_REQ_DH");
    var CLR_SMP_DEV_LMT_DH = items['C106000010pop01_Form_2'].getItemValue("CLR_SMP_DEV_LMT_DH");
    var CLR_SMP_DEV_END_DH = items['C106000010pop01_Form_2'].getItemValue("CLR_SMP_DEV_END_DH");
    var CLR_SMP_DEV_SND_DH = items['C106000010pop01_Form_2'].getItemValue("CLR_SMP_DEV_SND_DH");
    var PTT_FLM_YN = items['C106000010pop01_Form_2'].getItemValue("PTT_FLM_YN"); 

    items['C106000010pop01_Form_2'].setItemValue("SAL_CHR_REQ_DH", SAL_CHR_REQ_DH);
   	items['C106000010pop01_Form_2'].setItemValue("SAL_CHR_RGN_DH", SAL_CHR_RGN_DH);
   	items['C106000010pop01_Form_2'].setItemValue("CLR_SMP_DEV_REQ_DH", CLR_SMP_DEV_REQ_DH);
   	items['C106000010pop01_Form_2'].setItemValue("CLR_SMP_DEV_LMT_DH", CLR_SMP_DEV_LMT_DH);
   	items['C106000010pop01_Form_2'].setItemValue("CLR_SMP_DEV_END_DH", CLR_SMP_DEV_END_DH);   	   	   	   	
   	items['C106000010pop01_Form_2'].setItemValue("CLR_SMP_DEV_SND_DH", CLR_SMP_DEV_SND_DH);
   	items['C106000010pop01_Form_2'].setItemValue("DSN_CHR_PRS_ID", "<%=userNo %>");

	if(SAL_CHR_REQ_DH == "" ){
		dhtmlx.alert("영업요청일은  필수입력입니다.");
		return;
	}
	
	if(PTT_FLM_YN == null ){
		dhtmlx.alert("보호필름유무는 필수입력입니다.");
		return;
	}
   	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){
				if('<%=ctl_tp%>' == 'Y')
				    items['C106000010pop01_Form_2'].sendForm("handleDataProcess.do",'C106000010pop01_Form_2','dsn_save');
				else
					items['C106000010pop01_Form_2'].sendForm("handleDataProcess.do",'C106000010pop01_Form_2','sal_save');
			}
		}
	}); 	
}

function findMessage(referenceItem){
	uiCommon.message("C106000010pop01_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function popClose(){
	parent.find("find","C106000010_Form_1","C106000010_Grid_1","popup");
	parent.winObj.winClose();
}
function onFormLoadFunction(formDivObj){ 
	var form  = items['C106000010pop01_Form_2'];
		
	var comboList = items['C106000010pop01_Form_2'].getMasterCombos();

	comboList['RSN_ANL_REQ_YN'].readonly(true,false);
	ui.combo.master(comboList['RSN_ANL_REQ_YN'],'SZ0000','RSN_ANL_REQ_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['RSN_ANL_REQ_YN'].selectOption(0,true,true);
		comboList['RSN_ANL_REQ_YN'].readonly(true);
		comboList['RSN_ANL_REQ_YN'].setOptionHeight(60);
	});	

	comboList['SMP_SND_YN'].readonly(true,false);
	ui.combo.master(comboList['SMP_SND_YN'],'SZ0000','SMP_SND_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['SMP_SND_YN'].selectOption(0,true,true);
		comboList['SMP_SND_YN'].readonly(true);
		comboList['SMP_SND_YN'].setOptionHeight(60);
	});	
	
	comboList['SMP_LUS_YN'].readonly(true,false);
	ui.combo.master(comboList['SMP_LUS_YN'],'SZ0000','SMP_LUS_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['SMP_LUS_YN'].selectOption(0,true,true);
		comboList['SMP_LUS_YN'].readonly(true);
		comboList['SMP_LUS_YN'].setOptionHeight(60);
	});	
	
	comboList['DEV_PNT_CMP_CD'].readonly(true,false);
	ui.combo.master(comboList['DEV_PNT_CMP_CD'],'SZ0000','PNT_CMP_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['DEV_PNT_CMP_CD'].selectOption(0,true,true);
		comboList['DEV_PNT_CMP_CD'].readonly(true);
		comboList['DEV_PNT_CMP_CD'].setOptionHeight(220);		
	});
	
	comboList['LUS_RT_CD'].readonly(true,false);
	ui.combo.master(comboList['LUS_RT_CD'],'SZ0000','LUS_RT_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['LUS_RT_CD'].selectOption(0,true,true);
		comboList['LUS_RT_CD'].readonly(true);
		comboList['LUS_RT_CD'].setOptionHeight(140);		
	});
 	
	comboList['PRD_NM_CD'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['PRD_NM_CD'].selectOption(0,true,true);
		comboList['PRD_NM_CD'].readonly(true);
		comboList['PRD_NM_CD'].setOptionHeight(140);	
	});

	comboList['PRD_TP_YN'].readonly(true,false);
	ui.combo.master(comboList['PRD_TP_YN'],'SZ0000','PRD_TP_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['PRD_TP_YN'].selectOption(0,true,true);
		comboList['PRD_TP_YN'].readonly(true);
		comboList['PRD_TP_YN'].setOptionHeight(60);		
	});
	
	comboList['PTT_FLM_YN'].readonly(true,false);
	ui.combo.master(comboList['PTT_FLM_YN'],'SZ0000','PTT_FLM_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['PTT_FLM_YN'].selectOption(0,true,true);
		comboList['PTT_FLM_YN'].readonly(true);
		comboList['PTT_FLM_YN'].setOptionHeight(60);		
	});
		
	comboList['DSN_CHR_RGN_YN'].readonly(true,false);
	ui.combo.master(comboList['DSN_CHR_RGN_YN'],'SZ0000','DSN_CHR_RGN_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['DSN_CHR_RGN_YN'].selectOption(0,true,true);
		comboList['DSN_CHR_RGN_YN'].readonly(true);
		comboList['DSN_CHR_RGN_YN'].setOptionHeight(60);
	});	

	comboList['CLR_TP'].readonly(true,false);
	ui.combo.master(comboList['CLR_TP'],'SZ0000','CLR_TP','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['CLR_TP'].selectOption(0,true,true);
		comboList['CLR_TP'].readonly(true);
		comboList['CLR_TP'].setOptionHeight(80);
	});	

	comboList['RSN_TP'].readonly(true,false);
	ui.combo.master(comboList['RSN_TP'],'SZ0000','RSN_TP','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['RSN_TP'].selectOption(0,true,true);
		comboList['RSN_TP'].readonly(true);
		comboList['RSN_TP'].setOptionHeight(240);
	});	
	
//	form.setItemValue("INQ_RCP_DH",getCurrentMinitesTime());
	parent.c10popUp_setVal = masterPopup2SetValue;	
	if(!isNull("<%=CLR_SMP_REQ_NO%>")){	
		items['C106000010pop01_Form_2'].setItemValue("CLR_SMP_REQ_NO","<%=CLR_SMP_REQ_NO%>");
		var findUrl = uiCommon.parameters6("C106000010pop01_Form_2","C106000010pop01_Form_2","find");
		items['C106000010pop01_Form_2'].loadData(findUrl,findAfterFunction);
	}
	
	items['C106000010pop01_Form_2'].getDhxForm().detachEvent(onXleForm);

	//일자 달력 설정
	items['C106000010pop01_Form_2'].getItem("SAL_CHR_REQ_DH").setWeekStartDay(7);
	items['C106000010pop01_Form_2'].getItem("SAL_CHR_RGN_DH").setWeekStartDay(7);	
	items['C106000010pop01_Form_2'].getItem("CLR_SMP_DEV_REQ_DH").setWeekStartDay(7);
	items['C106000010pop01_Form_2'].getItem("CLR_SMP_DEV_LMT_DH").setWeekStartDay(7);	
	items['C106000010pop01_Form_2'].getItem("CLR_SMP_DEV_END_DH").setWeekStartDay(7);	
	items['C106000010pop01_Form_2'].getItem("CLR_SMP_DEV_SND_DH").setWeekStartDay(7);
	items['C106000010pop01_Form_2'].getItem("CCL_BOM_RGS_DH").setWeekStartDay(7);	
	
	//items['C106000010pop01_Form_2'].getItem("SAL_CHR_REQ_DH").setPosition(10,10);
	//items['C106000010pop01_Form_2'].getItem("SAL_CHR_REQ_DH").setPosition(null,20);
	//http://docs.dhtmlx.com/doku.php?id=dhtmlxcalendar:api_method_dhtmlxcalendar_setposition
	//http://docs.dhtmlx.com/doku.php?id=dhtmlxcalendar:toc		
			
	fieldEnable();
}

//접속ID에 따른 항목 enable
function fieldEnable(){
	var formObj  = items['C106000010pop01_Form_2'].getDhxForm();
        
        formObj.disableItem("CLR_SMP_RCP_NO");
        formObj.disableItem("DEV_PNT_CMP_CD");
        formObj.disableItem("RSN_TP");
        formObj.disableItem("CLR_SMP_DEV_REQ_DH");
        formObj.disableItem("CLR_SMP_DEV_LMT_DH");        
        formObj.disableItem("CLR_SMP_DEV_END_DH");
        formObj.disableItem("CLR_SMP_DEV_SND_DH");
        formObj.disableItem("SMP_SND_INF");
        formObj.disableItem("DSN_CHR_RGN_YN");
        formObj.disableItem("HUE_CD");
        formObj.disableItem("SIM_HUE_PRG_YN");
        formObj.disableItem("CCL_BOM_NO");
        formObj.disableItem("CCL_BOM_RGS_DH");
        formObj.disableItem("CLR_TP");
        formObj.disableItem("DSN_CHR_PRS_ID");
        formObj.disableItem("CLR_SMP_DSN_RMK");        
         
        if('<%=ctl_tp%>' == 'Y'){ 
         	formObj.enableItem("CLR_SMP_RCP_NO");
            formObj.enableItem("DEV_PNT_CMP_CD");
            formObj.enableItem("RSN_TP");
            formObj.enableItem("CLR_SMP_DEV_REQ_DH");
            formObj.enableItem("CLR_SMP_DEV_LMT_DH");            
            formObj.enableItem("CLR_SMP_DEV_END_DH");
            formObj.enableItem("CLR_SMP_DEV_SND_DH");
            formObj.enableItem("SMP_SND_INF");
            formObj.enableItem("DSN_CHR_RGN_YN");
            formObj.enableItem("HUE_CD");
            formObj.enableItem("SIM_HUE_PRG_YN");
            formObj.enableItem("CCL_BOM_NO");
            formObj.enableItem("CCL_BOM_RGS_DH");
            formObj.enableItem("CLR_TP");  
            formObj.enableItem("DSN_CHR_PRS_ID");
            formObj.enableItem("CLR_SMP_DSN_RMK");
        }        
}

// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}
var masterPopup2SetValue = function(code,name,target,formId){ //최종값 세팅 
	items[formId].setItemValue(target,code);
}

function findAfterFunction(){
	var uiFormObj = items['C106000010pop01_Form_2'];
	var comboList = items['C106000010pop01_Form_2'].getMasterCombos();
	
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
    var findUrl = uiCommon.parameters6("C106000010pop01_Form_2","C106000010pop01_Form_2","find");
	items['C106000010pop01_Form_2'].loadData(findUrl,findAfterFunction);
	
	return true;	
}

function onPop01Form2Changed(name, value){ //숫자 Check 
	if(name =="ORD_PRE_WGT"){
		if(!grid_qnty_check("예상수주량(톤)", 4, 1, true, value)){
			items['C106000010pop01_Form_2'].getDhxForm().setItemValue(name, "");
			return true;
		}
	}
}


//]]>
-->
</script>
</head>
<body>
<div id="C106000010pop01_Form_1" style="position:absolute;height:28px;width:870px;left:0px;top:0px;">
</div>
<div id="C106000010pop01_Form_2" style="position:absolute;height:425px;width:870px;left:0px;top:29px;overflow-x:hidden;overflow-y:scroll">
</div>
<div id="C106000010pop01_MessageBox_1" style="position:absolute;height:19px;width:869px;left:1px;top:452px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
	   var onXleForm = items["C106000010pop01_Form_2"].onXLEEvent(onFormLoadFunction);
	   var _onAfterUp = items['C106000010pop01_Form_2'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
       
	   items['C106000010pop01_Form_2'].onChangeEvent(onPop01Form2Changed);
//]]>
-->
</script>