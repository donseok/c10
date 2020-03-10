<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000120tab03.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  보증서발행내역관리
 * DESIGNER NAME    :  원성옥                              
 * DEVELOPER NAME   :  원성옥
 * CREATE DATE      :  2014.11.04
 *
 * Date	        Ver       Name       Description
 * ---------   -----    --------  ------------------------
 * 2014.11.04   V1.0     원성옥	  최초작성 
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
보증서발행내역관리  
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000120tab03_Form_1","xml":".\/header\/kr\/C106000120tab03\/C106000120tab03_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000120tab03_Grid_1","service":"C106000120tab03-service","actionType":"find"},' +
      '{"itemType":"menu","renderTo":"C106000120tab03_Menu_1","xml":".\/header\/kr\/C106000120tab03\/C106000120tab03_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000120tab03_Grid_1","service":"C106000120tab03-service"},' +
      '{"itemType":"grid","renderTo":"C106000120tab03_Grid_1","xml":".\/header\/kr\/C106000120tab03\/C106000120tab03_Grid_1.xml","rowCnt":"19","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"3","referenceItem":"C106000120tab03_Grid_1","service":"C106000120tab03-service"},' +
      '{"itemType":"messagebox","renderTo":"C106000120tab03_messagebox","xml":".\/header\/kr\/C106000120tab03\/C106000120tab03_messagebox.xml","service":"C106000120tab03-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    var findUrl = uiCommon.parameters('C106000120tab03_Form_1',referenceItem,'find');
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
function findMessage(referenceItem){
	uiCommon.message("C106000120tab03_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
//폼 로드 시 조회되는 함수 
function onLoadForm(){ 
	
	var formId = "C106000120tab03_Form_1";
	var gridId = 'C106000120tab03_Grid_1';	
	var formObj = items[formId].getDhxForm();
	
	// 날짜 세팅 	
	items[formId].setItemValue("WAR_PRT_DH_END",uiCommon.getCurrentDate());
	
	var toDate = items[formId].getDhxForm().getItemValue('WAR_PRT_DH_END');
	var fromDate = dateAdd(new Date(toDate.substring(5,7)+"/"+toDate.substring(8,10)+"/"+toDate.substring(0,4)),-15);
	 
	items[formId].setItemValue("WAR_PRT_DH_STR",fromDate);
	
	fromDate = items[formId].getDhxForm().getItemValue('WAR_PRT_DH_STR');
	
	//작업일자 달력 설정
	items[formId].getItem("WAR_PRT_DH_STR").setWeekStartDay(7);
	items[formId].getItem("WAR_PRT_DH_END").setWeekStartDay(7);
	
	//국가 콤보 생성 
	var comboList = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboList['NAT_COMB'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
  	ui.combo(comboList['NAT_COMB'],"OrdlnComboData.do"
			,"ServiceName=C106000120tab03-service&findItem=0&column-info=NAT_CD,NAT_NM&WAR_PRT_DH_STR="+fromDate+"&WAR_PRT_DH_END="+toDate,function(){ 
			  comboList['NAT_COMB'].selectOption(0,true,true);
			  comboList['NAT_COMB'].readonly(true);
			  comboList['NAT_COMB'].DOMelem_input.focus();
			}); 
		
	//CCL_BOM_NO 입력하고 엔터 시 실행 
	var inputObj = formObj.getInput("CCL_BOM_NO");
	inputObj.onkeyup = function(e){
		if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
		  inputObj.value = inputObj.value.toUpperCase();
		}	
		e = e||window.event;
		if(e.keyCode == 13){
			formObj.setItemValue("CCL_BOM_NO",inputObj.value);
			find("find",formId,gridId);			
		}
	};
	
	//발행자 입력하고 엔터 시 실행 
	var inputObj2 = formObj.getInput("WAR_PRT_EMP_ID");
	inputObj2.onkeyup = function(e){
		if(inputObj2.value.charAt(inputObj2.value.length - 1) <= 'z' && inputObj2.value.charAt(inputObj2.value.length - 1) >= 'a'){
		  inputObj2.value = inputObj2.value.toUpperCase();
		}	
		e = e||window.event;
		if(e.keyCode == 13){
			formObj.setItemValue("WAR_PRT_EMP_ID",inputObj2.value);
			find("find",formId,gridId);			
		}
	}
	
	items[formId].getDhxForm().detachEvent(onXLEForm);
}

function dateAdd(date, addDay) {
	 
    var nowDate = date;
    var addDate = nowDate.getTime() + (addDay * 24 * 60 * 60 * 1000);
    nowDate.setTime(addDate);
 
    var year = nowDate.getFullYear();
    var month = nowDate.getMonth() + 1;
    var date = nowDate.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
 
    return year + "-" + month + "-" + date;
 
}

function onLoadGrid (){
    var findUrl = uiCommon.parameters('C106000120tab03_Form_1','C106000120tab03_Grid_1','find');
    items['C106000120tab03_Grid_1'].loadData(findUrl);
	items["C106000120tab03_Grid_1"].getDhxGrid().detachEvent(onXLEGrid);
}

//]]>
-->
</script>
</head>
<body>
<div id="C106000120tab03_Form_1" style="position:absolute;height:28px;width:976px;left:0px;top:0px;">
</div>
<div id="C106000120tab03_Menu_1" style="position:absolute;height:25px;width:975px;left:0px;top:28px;">
</div>
<div id="C106000120tab03_Grid_1" style="position:absolute;height:449px;width:975px;left:-7px;top:46px;">
</div>
<div id="C106000120tab03_messagebox" style="position:absolute;height:23px;width:976px;left:-1px;top:509px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();  
	var onXLEForm = items['C106000120tab03_Form_1'].onXLEEvent(onLoadForm);
	var onXLEGrid = items['C106000120tab03_Grid_1'].onXLEEvent(onLoadGrid);
//]]>
-->
</script>