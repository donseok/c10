<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String ORD_NO = request.getParameter("ORD_NO")	!=null ? request.getParameter("ORD_NO") : "";
	String ORD_LN = request.getParameter("ORD_LN")	!=null ? request.getParameter("ORD_LN") : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
TAG 조회 POPUP
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000020POP01_Form_1","xml":".\/header\/kr\/C104000020POP01\/C104000020POP01_Form_1.xml","url":"basicFormData.do","referenceItem":"C104000020POP01_Form_2","service":"C104000020POP01-service","actionType":"find"},' +
      '{"itemType":"messagebox","renderTo":"C104000020POP01_messagebox","xml":".\/header\/kr\/C104000020POP01\/C104000020POP01_messagebox.xml","service":"C104000020POP01-service"},' +
      '{"itemType":"form","renderTo":"C104000020POP01_Form_2","xml":".\/header\/kr\/C104000020POP01\/C104000020POP01_Form_2.xml","url":"basicFormData.do","referenceItem":"C104000020POP01_Form_1","service":"C104000020POP01-service","actionType":"find"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
  var formObj = items["C104000020POP01_Form_1"].getDhxForm();
  var ord_ln = formObj.getItemValue("ORD_LN");
  var ord_no = formObj.getItemValue("ORD_NO");
  if(ord_no==""){
		dhtmlx.alert("주문번호를 입력하세요");
		return;
   }
   if(ord_ln == ""){
		dhtmlx.alert("주문행번을 입력하세요");
		return;
   }
	var findUrl = uiCommon.parameters6("C104000020POP01_Form_1","C104000020POP01_Form_2","find","");
    items["C104000020POP01_Form_2"].loadData(findUrl,findAfter);
}
function findAfter(){
	uiCommon.progressOff(parent);
	findMessage();
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C104000020POP01_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);	
}
//menu new row event function
function add(referenceItem){
   items[referenceItem].addRow();
}
//menu remove event function
function remove(referenceItem){
    items[referenceItem].removeRow();
}
//menu rows clipboard copy event function
function copy(referenceItem){
	items[referenceItem].copyRowContent();
}
//(undo)
function undo(referenceItem){
	items[referenceItem].undo();
}
//(Redo)
function redo(referenceItem){
	items[referenceItem].redo();	
}
function onGridContextMenuClick(id,gridObj,menuObj){    
    var isChecked = menuObj.getCheckboxState(id); 
    if("move_grid" == id){
        if(isChecked)
          gridObj.enableColumnMove(true);
        else
          gridObj.enableColumnMove(false);
    }  
  	if("filter_grid" == id){
  		if(isChecked)
         gridObj.enableHeaderMenu();
  	}
  
  	if("editable_grid" == id){
  		if(isChecked)
         gridObj.setEditable(true);
  		else	
  		  gridObj.setEditable(false);
  	}
  	
  	if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
  	}
} 
function findMessage(){
   var uiFormObj = items['C104000020POP01_Form_2'];
   if(uiFormObj.getItemValue("messageBox") == ""){	
	   uiFormObj.clear();
	   uiCommon.message("C104000020POP01_messagebox","0건 조회되었습니다.");
   }else{
	   uiCommon.message("C104000020POP01_messagebox","조회되었습니다.");
   }
  	return true;
}

function onFormLoadFunction(formDivObj){ 
 return true;
}

function onFormLoad1(){
	
	items['C104000020POP01_Form_1'].getDhxForm().setItemValue("ORD_NO","<%=ORD_NO%>");
	items['C104000020POP01_Form_1'].getDhxForm().setItemValue("ORD_LN","<%=ORD_LN%>");
	
	var formObj = items['C104000020POP01_Form_1'].getDhxForm();
	var ORD_NO = formObj.getInput("ORD_NO");
	valueCheck(formObj,ORD_NO);
	var ORD_LN = formObj.getInput("ORD_LN");
	valueCheck(formObj,ORD_LN);
	items['C104000020POP01_Form_1'].getDhxForm().detachEvent(onXle1);
}

function onFormLoad2(){
	
	var findUrl = uiCommon.parameters6('C104000020POP01_Form_1','C104000020POP01_Form_2','find');
	items['C104000020POP01_Form_2'].loadData(findUrl,findAfter);
	items['C104000020POP01_Form_2'].getDhxForm().detachEvent(onXle2);
}
function valueCheck(formObj,inputObj){
	inputObj.onkeyup=function(){
		for (i = 0; i < inputObj.value.length; i++){
			if (((inputObj.value.charCodeAt(i) > 0x3130 && inputObj.value.charCodeAt(i) < 0x318F) || 
			     (inputObj.value.charCodeAt(i) >= 0xAC00 && inputObj.value.charCodeAt(i) <= 0xD7A3))){
					dhtmlx.alert("영문자나 숫자만 입력해 주세요");
					inputObj.value = "";
					return;
			}else if((inputObj.value.charCodeAt(i) >= 0 && inputObj.value.charCodeAt(i) <= 47) || 
				     (inputObj.value.charCodeAt(i) >= 58 && inputObj.value.charCodeAt(i) <= 64) || 
				     (inputObj.value.charCodeAt(i) >= 91 && inputObj.value.charCodeAt(i) <= 94) || 
				     (inputObj.value.charCodeAt(i) == 96) || (inputObj.value.charCodeAt(i) >= 123 &&
				      inputObj.value.charCodeAt(i) <= 255)){
							dhtmlx.alert("영문자나 숫자만 입력해 주세요");
							inputObj.value = "";
							return;
			}
		}
		inputObj.value = inputObj.value.toUpperCase(); 
	}
}
//]]>
-->
</script>
</head>
<body>
<div id="C104000020POP01_Form_1" style="position:absolute;height:30px;width:600px;left:0px;top:0px;">
</div>
<div id="C104000020POP01_messagebox" style="position:absolute;height:23px;width:598px;left:0px;top:433px;">
</div>
<div id="C104000020POP01_Form_2" style="position:absolute;height:400px;width:600px;left:0px;top:32px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXle1=items['C104000020POP01_Form_1'].onXLEEvent(onFormLoad1);
	var onXle2=items['C104000020POP01_Form_2'].onXLEEvent(onFormLoad2);
//]]>
-->
</script>