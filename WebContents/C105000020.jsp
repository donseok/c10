<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C105000020.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  생산가부수동검토
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  이 민 균
 * CREATE DATE      :  2012.01.16
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.01.16     V1.0      이민균      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String INQ_NO = request.getParameter("INQ_NO")	!=null ? request.getParameter("INQ_NO") : "";	
%>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
C105000020
</title>
<style type="text/css" media="screen">
/*custom styling for the first column*/
 .form_lable{
  background-color:#5AA1FF;
  font-weight : bold;
  text-align:center;
  /*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
  border-color:#FDFDFD #BABABA #BABABA #FDFDFD !important;  
  border-style:solid !important;
  border-width:1px !important;  
  padding-top:1px;
 }
</style>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"messagebox","renderTo":"C105000020_messagebox","xml":".\/header\/kr\/C105000020\/C105000020_messagebox.xml","service":"C105000020-service"},' +
      '{"itemType":"form","renderTo":"C105000020_Form_1","xml":".\/header\/kr\/C105000020\/C105000020_Form_1.xml","url":"basicFormData.do","referenceItem":"C105000020_Form_2","service":"C105000020-service","actionType":"find","security":"true"},' +
      '{"itemType":"form","renderTo":"C105000020_Form_2","xml":".\/header\/kr\/C105000020\/C105000020_Form_2.xml","url":"basicFormData.do","referenceItem":"C105000020_Form_1","service":"C105000020-service","actionType":"save"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var inqNo = items['C105000020_Form_1'].getItemValue("INQ_NO").trim(); 
	if(isNull(inqNo)){			
		alert("INQUIRY 번호를 입력하세요.");
		items['C105000020_Form_1'].setItemFocus("INQ_NO");
		return;
	}else{		
		if(checkValidNumber(inqNo) && checkLength(inqNo,"INQUIRY 번호",10)){
			var findUrl = uiCommon.parameters6(formDivObj,referenceItem,eventName);
			items[referenceItem].loadData(findUrl,findAfterFunction);	
			
		}
	}
}
function save(eventName,formDivObj,referenceItem){
	var comboList = items['C105000020_Form_2'].getMasterCombos();
	var inqNo = items['C105000020_Form_1'].getItemValue("INQ_NO"); 
	var form =  items['C105000020_Form_2'];
	

	if(isNull(inqNo)){		
		alert("저장할 INQUIRY번호가 없습니다.");
		return;
	}else if(inqStsCd == "9"){
		alert("INQUIRY번호가 완료된 상태입니다.");
		return;
	}
	if(!isNull(form.getItemValue("INQ_STS_CD"))){	
		var inqStsCd =  form.getItemValue("INQ_STS_CD").substring(0,1);
	}	
	// 최종검토결과 setting
	if(isNull(comboList['INQ_PSV_SRT_RSL_CD2'].getSelectedValue())){
		form.setItemValue("INQ_PSV_SRT_RSL_CD_NM",comboList['INQ_PSV_SRT_RSL_CD1'].getSelectedText());
		form.setItemValue("INQ_PSV_SRT_RSL_CD",comboList['INQ_PSV_SRT_RSL_CD1'].getSelectedValue());
	}else if(!isNull(comboList['INQ_PSV_SRT_RSL_CD2'].getSelectedValue())){
		form.setItemValue("INQ_PSV_SRT_RSL_CD_NM",comboList['INQ_PSV_SRT_RSL_CD2'].getSelectedText());
		form.setItemValue("INQ_PSV_SRT_RSL_CD",comboList['INQ_PSV_SRT_RSL_CD2'].getSelectedValue());
	}else if(!isNull(comboList['INQ_PSV_SRT_RSL_CD1'].getSelectedValue())){
		form.setItemValue("INQ_PSV_SRT_RSL_CD_NM",comboList['INQ_PSV_SRT_RSL_CD1'].getSelectedText());
		form.setItemValue("INQ_PSV_SRT_RSL_CD",comboList['INQ_PSV_SRT_RSL_CD1'].getSelectedValue());
	}
	
	// 최종검토완료일 setting
	if(isNull(form.getItemValue("INQ_PSV_SRT_END_DH2"))){
		form.setItemValue("INQ_SRT_END_DH",form.getItemValue("INQ_PSV_SRT_END_DH1"));
	}else if(!isNull(form.getItemValue("INQ_PSV_SRT_END_DH2"))){
		form.setItemValue("INQ_SRT_END_DH",form.getItemValue("INQ_PSV_SRT_END_DH2"));
	}else if(!isNull(form.getItemValue("INQ_PSV_SRT_END_DH1"))){
		form.setItemValue("INQ_SRT_END_DH",form.getItemValue("INQ_PSV_SRT_END_DH1"));
	}

	// 검토결과전송일 setting
	if(isNull(form.getItemValue("INQ_SRT_RSL_SND_DH2"))){
		form.setItemValue("INQ_SRT_RSL_SND_DH",form.getItemValue("INQ_SRT_RSL_SND_DH1"));
	}else if(!isNull(form.getItemValue("INQ_SRT_RSL_SND_DH2"))){
		form.setItemValue("INQ_SRT_RSL_SND_DH",form.getItemValue("INQ_SRT_RSL_SND_DH2"));
	}else if(!isNull(form.getItemValue("INQ_PSV_SRT_END_DH1"))){
		form.setItemValue("INQ_SRT_RSL_SND_DH",form.getItemValue("INQ_SRT_RSL_SND_DH1"));
	}

	// 고객사양등록일 setting
	if(!isNull(form.getItemValue("CUS_BTH_PAP_NO"))){
		form.setItemValue("CUS_SPC_RGS_DH",uiCommon.getCurrentDate());
	}else{
		form.setItemValue("CUS_SPC_RGS_DH","");
	}

	if((inqStsCd == "1" || inqStsCd == "2" || inqStsCd == "4") && form.getItemValue("INQ_PSV_SRT_RSL_CD") == "C"){
		form.setItemValue("INQ_STS_CD","3");
	}else if(inqStsCd == "1"){
		form.setItemValue("INQ_STS_CD","2");
	}else if(inqStsCd == "3"){
		form.setItemValue("INQ_STS_CD","4");
	}

	form.setItemValue("INQ_NO",inqNo);
	form.setItemValue("INQ_STS_CD",inqStsCd);	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장하시겠습니까?",
		callback:function(val){
		 if(val){
		   form.sendForm("handleDataProcess.do",'C105000020_Form_2',eventName);
		   return;
		 }
		}
	});
    
}

function inquiryEnd(eventName,formDivObj,referenceItem){
	var inqNo = items['C105000020_Form_1'].getItemValue("INQ_NO");
	var inqStsCd = items['C105000020_Form_2'].getItemValue("INQ_STS_CD");

	var form =  items['C105000020_Form_2'];
	if(inqNo == ""){		
		alert("완료처리를 위한 INQUIRY번호가 없습니다.");
		return;
	}else if(inqStsCd == ""){
		alert("INQUIRY번호로 조회된 데이타가 없습니다.");
		return;	
	}

	form.setItemValue("INQ_NO",inqNo); //INQUIRY 번호 설정
	form.setItemValue("INQ_STS_CD","9");//INQUIRY 상태 설정
	form.sendForm("handleDataProcess.do",'C105000020_Form_2',eventName);
}


function findAfterFunction(){
	uiCommon.progressOff(parent);
	var comboList = items['C105000020_Form_2'].getMasterCombos();
	var formObj   = items['C105000020_Form_2'].getDhxForm();
	var form =  items['C105000020_Form_2'];
	if(!isNull(form.getItemValue("INQ_STS_CD"))){
		var inqStsCd =  form.getItemValue("INQ_STS_CD").substring(0,1);

		if(inqStsCd == "1" || inqStsCd == "2"){
		//if(isNull(comboList['INQ_PSV_SRT_RSL_CD1'].getSelectedValue())){
			comboList['INQ_PSV_SRT_RSL_CD1'].DOMelem_input.style.backgroundColor="#FFFFC0";	
			formObj.getInput("INQ_PSV_SRT_END_DH1").style.backgroundColor="#FFFFC0";
			formObj.getInput("INQ_SRT_RSL_SND_DH1").style.backgroundColor="#FFFFC0";
			comboList['INQ_PSV_SRT_RSL_CD2'].DOMelem_input.style.backgroundColor="#FFFFFF";	
			formObj.getInput("INQ_PSV_SRT_END_DH2").style.backgroundColor="#FFFFFF";
			formObj.getInput("INQ_SRT_RSL_SND_DH2").style.backgroundColor="#FFFFFF";
			items['C105000020_Form_2'].disableItems("INQ_PSV_SRT_RSL_CD2,INQ_PSV_SRT_END_DH2,INQ_SRT_RSL_SND_DH2");
			items['C105000020_Form_2'].enableItems("INQ_PSV_SRT_RSL_CD1,INQ_PSV_SRT_END_DH1,INQ_SRT_RSL_SND_DH1");			
		}else{
			comboList['INQ_PSV_SRT_RSL_CD2'].DOMelem_input.style.backgroundColor="#FFFFC0";	
			formObj.getInput("INQ_PSV_SRT_END_DH2").style.backgroundColor="#FFFFC0";
			formObj.getInput("INQ_SRT_RSL_SND_DH2").style.backgroundColor="#FFFFC0";
			comboList['INQ_PSV_SRT_RSL_CD1'].DOMelem_input.style.backgroundColor="#FFFFFF";	
			formObj.getInput("INQ_PSV_SRT_END_DH1").style.backgroundColor="#FFFFFF";
			formObj.getInput("INQ_SRT_RSL_SND_DH1").style.backgroundColor="#FFFFFF";
			items['C105000020_Form_2'].disableItems("INQ_PSV_SRT_RSL_CD1,INQ_PSV_SRT_END_DH1,INQ_SRT_RSL_SND_DH1");
			items['C105000020_Form_2'].enableItems("INQ_PSV_SRT_RSL_CD2,INQ_PSV_SRT_END_DH2,INQ_SRT_RSL_SND_DH2");
		}
		formObj.getInput("INQ_SRT_TXT").style.backgroundColor="#FFFFC0";
		formObj.getInput("INQ_SRT_TXT1").style.backgroundColor="#FFFFC0";

		if(inqStsCd == "9"){		
			comboList['INQ_PSV_SRT_RSL_CD1'].DOMelem_input.style.backgroundColor="#FFFFFF";	
			formObj.getInput("INQ_PSV_SRT_END_DH1").style.backgroundColor="#FFFFFF";
			formObj.getInput("INQ_SRT_RSL_SND_DH1").style.backgroundColor="#FFFFFF";
			comboList['INQ_PSV_SRT_RSL_CD2'].DOMelem_input.style.backgroundColor="#FFFFFF";	
			formObj.getInput("INQ_PSV_SRT_END_DH2").style.backgroundColor="#FFFFFF";
			formObj.getInput("INQ_SRT_RSL_SND_DH2").style.backgroundColor="#FFFFFF";
			formObj.getInput("INQ_SRT_TXT").style.backgroundColor="#FFFFFF";
			formObj.getInput("INQ_SRT_TXT1").style.backgroundColor="#FFFFFF";
			items['C105000020_Form_2'].disableItems("INQ_PSV_SRT_RSL_CD1,INQ_PSV_SRT_END_DH1,INQ_SRT_RSL_SND_DH1");
			items['C105000020_Form_2'].disableItems("INQ_PSV_SRT_RSL_CD2,INQ_PSV_SRT_END_DH2,INQ_SRT_RSL_SND_DH2");
			formObj.setReadonly("INQ_SRT_TXT",true);
			formObj.setReadonly("INQ_SRT_TXT",true);
			items['C105000020_Form_2'].disableItems("INQ_SRT_END_DH,INQ_SRT_RSL_SND_DH");
		}
	}

	return true;
}

function findMessage(referenceItem){
	uiCommon.message("C105000020_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}


function onFormLoadFunction1(){ 
	var formObj   = items['C105000020_Form_1'].getDhxForm();
	var form   = items['C105000020_Form_1'];
	form.setItemValue("INQ_NO","<%=INQ_NO%>");

	if(!isNull("<%=INQ_NO%>")){
		find("find","C105000020_Form_1","C105000020_Form_2");
	}

	items['C105000020_Form_1'].getDhxForm().detachEvent(onXleForm1);
}

function onFormLoadFunction2(){ 
	var comboList = items['C105000020_Form_2'].getMasterCombos();
	var formObj   = items['C105000020_Form_2'].getDhxForm();
	
	var inputCalendar = items["C105000020_Form_2"].getDhxForm().getInput("INQ_SRT_END_DH");
	var inputCalendar1 = items["C105000020_Form_2"].getDhxForm().getInput("INQ_SRT_RSL_SND_DH");
	var calendar= items["C105000020_Form_2"].getDhxForm().getCalendar("INQ_SRT_END_DH");	
	var calendar1= items["C105000020_Form_2"].getDhxForm().getCalendar("INQ_SRT_RSL_SND_DH");	

		comboList['INQ_PSV_SRT_RSL_CD1'].readonly(true,true);
			ui.combo.master(comboList['INQ_PSV_SRT_RSL_CD1'],'SZ0000','INQ_SRT_RSL_CD','totalValue=,orderBy=value',function(){ 
			comboList['INQ_PSV_SRT_RSL_CD1'].selectOption(0,true,true);		
		});

		comboList['INQ_PSV_SRT_RSL_CD1'].DOMelem_input.onkeydown = function(e){
		key = (e) ? e.keyCode : event.keyCode;
			if(key==8 || key==116){
				if(e){   //표준         
					e.preventDefault();
				}
				else{ //익스용
					event.keyCode = 0;
					event.returnValue = false;
				}
			}
		}

		comboList['INQ_PSV_SRT_RSL_CD2'].readonly(true,true);
			ui.combo.master(comboList['INQ_PSV_SRT_RSL_CD2'],'SZ0000','INQ_SRT_RSL_CD','totalValue=,orderBy=value',function(){ 
			comboList['INQ_PSV_SRT_RSL_CD2'].selectOption(0,true,true);	
		});			
		comboList['INQ_PSV_SRT_RSL_CD2'].DOMelem_input.onkeydown = function(e){
		key = (e) ? e.keyCode : event.keyCode;
			if(key==8 || key==116){
				if(e){   //표준         
					e.preventDefault();
				}
				else{ //익스용
					event.keyCode = 0;
					event.returnValue = false;
				}
			}
		}

		

		inputCalendar.onkeydown = function(e){
			key = (e) ? e.keyCode : event.keyCode;
			if(key==8 || key==116){
				if(e){   //표준         
					e.preventDefault();
				}
				else{ //익스용
					event.keyCode = 0;
					event.returnValue = false;
				}
			}
		}
		inputCalendar.onclick = function(e){
			calendar.hide();
		}

		inputCalendar1.onkeydown = function(e){
			key = (e) ? e.keyCode : event.keyCode;
			if(key==8 || key==116){
				if(e){   //표준         
					e.preventDefault();
				}
				else{ //익스용
					event.keyCode = 0;
					event.returnValue = false;
				}
			}
		}
		inputCalendar1.onclick = function(e){
			calendar1.hide();
		}
		


		/*var inputItemObj = items["C105000020_Form_1"].getItem("INQ_NO");
		inputItemObj.onkeyup = function(e){		
			e = e||window.event;
			if(e.keyCode == 13){
				find("find","C105000020_Form_1","C105000020_Form_2");			
			}
		}*/

		if(!isNull("<%=INQ_NO%>")){
			items['C105000020_Form_1'].getDhxForm().setItemValue("INQ_NO","<%=INQ_NO%>");
		var findUrl = uiCommon.parameters6('C105000020_Form_1','C105000020_Form_2','find');
			items['C105000020_Form_2'].loadData(findUrl,findAfterFunction);	
		}

		backspaceOff("C105000020_Form_2");
		items['C105000020_Form_2'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
		items['C105000020_Form_2'].getDhxForm().detachEvent(onXleForm2);
}

function onAfterUpdateFinishEvent(){
	 items['C105000020_Form_2'].getDhxForm().resetDataProcessor("updated");
	 find("find","C105000020_Form_1","C105000020_Form_2");
}
//]]>
-->
</script>
</head>
<body>
<div id="C105000020_messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
<div id="C105000020_Form_1" style="position:absolute;height:38px;width:981px;left:0px;top:0px;">
</div>
<div id="C105000020_Form_2" style="position:absolute;height:530px;width:981px;left:0px;top:42px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();   
//       items['C105000020_Form_1'].setBackgroundColor("#FFFFFF");
	items['C105000020_Form_2'].setBackgroundColor("#D6E8FF");

	
//	var onXleForm1= items['C105000020_Form_1'].onXLEEvent(onFormLoadFunction1);  //Chrome Error
	var onXleForm2= items['C105000020_Form_2'].onXLEEvent(onFormLoadFunction2);


//]]>
-->
</script>