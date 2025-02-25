<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
품질설계 B/U
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array

var Form_1 = {"itemType":"form","renderTo":"C104000070_Form_1","xml":".\/header\/kr\/C104000070\/C104000070_Form_1.xml","url":"basicFormData.do","referenceItem":"C104000070_Form_1","service":"C104000070-service","actionType":"save","security":"true"};
var initLayout =
{
	"programId": "C104000070",
	"itemType": "layout", "messageBox": true, "dirType": "row", "childSize": ",", "splitter": false,
	"components":
		[
			Form_1,
		]
}; 

//품질설계 상태 변경 조회
function findQltSts(eventName,formDivObj,referenceItem){
	
	//강제저장 비활성화
	items["C104000070_Form_1"].getDhxForm().disableItem('saveForceQltSts');
	
	var findUrl = uiCommon.parameters6("C104000070_Form_1","C104000070_Form_1",eventName);
	
	items["C104000070_Form_1"].loadData(findUrl);		 	
	uiCommon.progressOff(parent);
}

//품질설계 상태 변경 저장
function saveQltSts(eventName,formDivObj,referenceItem){

	var aForm1 = "C104000070_Form_1";
	var ordNo = items[aForm1].getDhxForm().getItemValue('ORD_NO'); 
	var ordLn = items[aForm1].getDhxForm().getItemValue('ORD_LN'); 
	var qltDsnSts = items[aForm1].getDhxForm().getItemValue('QLT_DSN_STS_CD');
	var workCnt = items[aForm1].getDhxForm().getItemValue('CNT');
	
	if(ordNo == '' || ordLn == ''){
		dhtmlx.alert('주문번호를 입력하세요.');
	} else if(qltDsnSts != 'A'){
		dhtmlx.alert('품질설계 상태가 확정인 건만 확정대기 상태로 변경 가능합니다.');
	} else if(workCnt > 0){
		dhtmlx.alert('작업대기 또는 작업중(작업완료) 코일이 포함되어있습니다. \n 설계원과 상의하세요.');
		items[aForm1].getDhxForm().enableItem('saveForceQltSts');
	}else {

		dhtmlx.confirm({
			title:"품질설계상태변경",
			ok:"확인", cancel:"취소",
			text:"확정 대기상태로 변경 하시겠습니까?",
			callback:function(val){
				 if(val){
				     items["C104000070_Form_1"].sendForm("handleDataProcess.do","C104000070_Form_1",eventName);
				     findQltSts('findQltSts','','');
				 }
			}
		});	

// 		items["C104000070_Form_1"].sendForm("handleDataProcess.do","C104000070_Form_1",eventName);	
// 		findQltSts('findQltSts','','');
	}
}



//품질설계 상태 변경 강제저장
function saveForceQltSts(eventName,formDivObj,referenceItem){

	var aForm1 = "C104000070_Form_1";
	var ordNo = items[aForm1].getDhxForm().getItemValue('ORD_NO'); 
	var ordLn = items[aForm1].getDhxForm().getItemValue('ORD_LN'); 
	var qltDsnSts = items[aForm1].getDhxForm().getItemValue('QLT_DSN_STS_CD');
	
	if(ordNo == '' || ordLn == ''){
		dhtmlx.alert('주문번호를 입력하세요.');
	} else if(qltDsnSts != 'A'){
		dhtmlx.alert('품질설계 상태가 확정인 건만 확정대기 상태로 변경 가능합니다.');
	} else {

		dhtmlx.confirm({
			title:"품질설계상태변경",
			ok:"확인", cancel:"취소",
			text:"확정 대기상태로 변경 하시겠습니까?",
			callback:function(val){
				 if(val){
				     items["C104000070_Form_1"].sendForm("handleDataProcess.do","C104000070_Form_1",eventName);
				     findQltSts('findQltSts','','');
				 }
			}
		});	

// 		items["C104000070_Form_1"].sendForm("handleDataProcess.do","C104000070_Form_1",eventName);	
// 		findQltSts('findQltSts','','');
	}
}




function onFormLoadEvent(){ 

}


function onChange(id,value){
	 var item = id;
	 if(item == "ORD_NO")
	 {
	  var ORD_NO = items["C104000070_Form_1"].getItemValue("ORD_NO");
	  var comboList = items[aForm1].getMasterCombos();
	  comboList['ORD_LN'].readonly(false,false);
	  ui.combo(comboList['ORD_LN'],"OrdlnComboData.do","ServiceName=C104000070-service&OrdLnFind=1&column-info=ORD_LN,ORD_LN&ORD_NO="+ORD_NO);
	 } 
}

function onAfterUpdateFinishEvent(){
	items[aForm1].clearDataProcess();
	items[aForm1].getDhxForm().resetDataProcessor("updated");
}

//]]>
-->
</script>
</head>
<body>
<!-- <div id="C104000070_Form_1" style="position:absolute;height:76px;width:981px;left:0px;top:0px;"> -->
<!-- </div> -->
<!-- <div id="C104000070_Grid_1" style="position:absolute;height:475px;width:977px;left:-6px;top:83px;"> -->
<!-- </div> -->
<!-- <div id="messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;"> -->
<!-- </div> -->
</body>
</html>
<script>
<!--
//<![CDATA[
           
	ui.initializeDHTMLX();
	var aForm1 = "C104000070_Form_1";
	//items[aForm1].onXLEEvent(onFormLoadFunction);

	var onFormXLE = items[aForm1].onXLEEvent(onFormLoadEvent); 
	items[aForm1].getDhxForm().attachEvent('onChange', onChange);
	items[aForm1].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent); 
	   
//]]>
-->
</script>