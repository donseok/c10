<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
반복주문자동설계 조회
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000060_Form_1","xml":".\/header\/kr\/C104000060\/C104000060_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000060_Grid_1","service":"C104000060-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C104000060_Grid_1","xml":".\/header\/kr\/C104000060\/C104000060_Grid_1.xml","rowCnt":"22","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000060_Form_1","service":"C104000060-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C104000060_messagebox","xml":".\/header\/kr\/C104000060\/C104000060_messagebox.xml","service":"C104000060-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var fromDate = items['C104000060_Form_1'].getItemValue('QLT_DSN_END_DH_STR');
	var toDate   = items['C104000060_Form_1'].getItemValue('QLT_DSN_END_DH_END');
	
	// 입력받을 타입을 검사
	//fromDate = get_DateTypeDay(fromDate);
	//toDate = get_DateTypeDay(toDate);
	
	if(fromDate == '' || toDate == ''){
		dhtmlx.alert({
            ok:"확인",
            text:"설계완료일자를 입력하지 않았습니다!",
            callback:function(val){
              if(val){
                items['C104000060_Form_1'].setItemFocus('QLT_DSN_END_DH_STR');
              }
           }
      	});
	  return ;
	}
	if(fromDate > toDate){
		dhtmlx.alert({
            ok:"확인",
            text:"설계완료일자를 잘못 입력하였습니다!",
            callback:function(val){
              if(val){
                items['C104000060_Form_1'].setItemFocus('QLT_DSN_END_DH_END');
              }
           }
      	});
		return ;
	}
	
	//주문번호
	var ORD_NO = items['C104000060_Form_1'].getDhxForm().getItemValue('ORD_NO');
	var findUrl;
	
	if(ORD_NO == "" || ORD_NO == null){
		findUrl = uiCommon.parameters(formDivObj,referenceItem,'find');
	}else{
		findUrl = uiCommon.parameters(formDivObj,referenceItem,'findord');
	}

    items[referenceItem].loadData(findUrl);
}

function clear(eventName,formDivObj,referenceItem){
	  var formObj = items[formDivObj];
	  formObj.clear();
	  onLoadForm();
	}

function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C104000060_Form_1',referenceItem,'find');
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
	uiCommon.message("C104000060_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(formDivObj){ 
 return true;
}

function onLoadForm(){

	var formId = "C104000060_Form_1";
	var gridId = 'C104000060_Grid_1';	

	var formObj = items[formId].getDhxForm();	
	
	// 날짜 세팅 	
	items[formId].setItemValue("QLT_DSN_END_DH_END",uiCommon.getCurrentDate());
	
	var toDate = items[formId].getDhxForm().getItemValue('QLT_DSN_END_DH_END');
	var fromDate = dateAdd(new Date(toDate.substring(5,7)+"/"+toDate.substring(8,10)+"/"+toDate.substring(0,4)),-30);
	 
	items[formId].setItemValue("QLT_DSN_END_DH_STR",fromDate);	
	fromDate = items[formId].getDhxForm().getItemValue('QLT_DSN_END_DH_STR');
	
	//콤보 생성
	var comboList = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboList['FNL_CUS_NAME'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
	//고객사 콤보박스 (지정된 SQL로 콤보불러 오기) 
	ui.combo(comboList['FNL_CUS_NAME'],"OrdlnComboData.do"
	,"ServiceName=C104000060-service&findItem=0&column-info=FNL_CUS_CD,FNL_CUS_NM&QLT_DSN_END_DH_STR="+fromDate+"&QLT_DSN_END_DH_END="+toDate,function(){ 
	  comboList['FNL_CUS_NAME'].selectOption(0,true,true);
// 	  comboList['FNL_CUS_NAME'].readonly(true);
// 	  comboList['FNL_CUS_NAME'].DOMelem_input.focus();
	});
	
	// 품명 콤보박스 
	comboList['PRD_NM_CD'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value',function(){
	  comboList['PRD_NM_CD'].selectOption(0,true,true);
	  //comboList['PRD_NM_CD'].setOptionHeight(220);
	});
	
	//작업일자 달력 설정
	items[formId].getItem("QLT_DSN_END_DH_STR").setWeekStartDay(7);
	items[formId].getItem("QLT_DSN_END_DH_END").setWeekStartDay(7);
	
	//주문번호, 행번 초기화
	items[formId].setItemValue("ORD_NO","");
	items[formId].setItemValue("ORD_LN","");
	
	//주문등록자 입력하고 엔터 시 실행 
	var inputObj = formObj.getInput("ORD_RGS_PRS_ID");
	inputObj.onkeyup = function(e){
		if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
		  inputObj.value = inputObj.value.toUpperCase();
		}	
		e = e||window.event;
		if(e.keyCode == 13){
			formObj.setItemValue("ORD_RGS_PRS_ID",inputObj.value);
			find("find",formId,gridId);			
		}
	}
	items[formId].getDhxForm().detachEvent(_onXLEForm);
	
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

//그리드안의 주문번호 클릭 시 링크 연결 
function Grid_doLink(val,rowIdx,cellIdx){
	var gridObj 	= items['C104000060_Grid_1'].getDhxGrid();
	var link_url 	= "", param = "";
	//주문번호 링크 이동 
	if(cellIdx == gridObj.getColIndexById('ORD_NO')) {	
		var ORD_NO	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_NO")).getValue();
		var ORD_LN 	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_LN")).getValue();
		link_url = "C104000020";
		param += "&ORD_NO="+ORD_NO;
		param += "&ORD_LN="+ORD_LN;
		parent.newRemoveOpenTab(link_url,param);
	}
	else if(cellIdx == gridObj.getColIndexById('ORD_REP_NO')) {	
		
		var ORD_REP_NO	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_REP_NO")).getValue();
		var ORD_REP_LN 	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_REP_LN")).getValue();
		link_url = "C104000020";
		param += "&ORD_NO="+ORD_REP_NO;
		param += "&ORD_LN="+ORD_REP_LN;
		parent.newRemoveOpenTab(link_url,param);
	}
}

function OnDataChanged(id,value){
	var fromDate = items['C104000060_Form_1'].getDhxForm().getItemValue('QLT_DSN_END_DH_STR');
	var toDate = items['C104000060_Form_1'].getDhxForm().getItemValue('QLT_DSN_END_DH_END');
	
	var comboList = items['C104000060_Form_1'].getMasterCombos();//comboList 객체 생성 구문
	comboList['FNL_CUS_NAME'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
	ui.combo(comboList['FNL_CUS_NAME'],"OrdlnComboData.do"
			,"ServiceName=C104000060-service&findItem=0&column-info=FNL_CUS_CD,FNL_CUS_NM&QLT_DSN_END_DH_STR="+fromDate+"&QLT_DSN_END_DH_END="+toDate,function(){ 
// 			  comboList['FNL_CUS_NAME'].readonly(true);
// 			  comboList['FNL_CUS_NAME'].DOMelem_input.focus();
			});	
	
	/*
	var ORD_NO = items['C104000060_Form_1'].getItemValue("ORD_NO");
	var comboList1 = items['C104000060_Form_1'].getMasterCombos();
	comboList1['ORD_LN'].readonly(false,false);
	ui.combo(comboList1['ORD_LN'],"OrdlnComboData.do","ServiceName=C104000060-service&OrdLnFind=1&column-info=ORD_LN,ORD_LN&ORD_NO="+ORD_NO);
	*/	
	
return true;
}

function onLoadGrid(){
	var grid =  items['C104000060_Grid_1'].getDhxGrid();
	var qltDsnInstDhStr = items['C104000060_Form_1'].getItemValue('QLT_DSN_END_DH_STR');
	var qltDsnInstDhEnd = items['C104000060_Form_1'].getItemValue('QLT_DSN_END_DH_END');
	
	var customParam = {"QLT_DSN_END_DH_STR":qltDsnInstDhStr,"QLT_DSN_END_DH_END":qltDsnInstDhEnd};
	var findUrl = parametersC11("basicGridData.do",'C104000060_Grid_1','find',customParam);
	items['C104000060_Grid_1'].loadData(findUrl);
	grid.detachEvent(_onXleGrid);
}


//]]>
-->
</script>
</head>
<body>
<div id="C104000060_Form_1" style="position:absolute;height:30px;width:981px;left:0px;top:0px;">
</div>
<div id="C104000060_Grid_1" style="position:absolute;height:534px;width:977px;left:1px;top:31px;">
</div>
<div id="C104000060_messagebox" style="position:absolute;height:19px;width:979px;left:0px;top:566px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();  	
	var _onXLEForm = items['C104000060_Form_1'].onXLEEvent(onLoadForm);
	items['C104000060_Form_1'].getDhxForm().attachEvent('onChange', OnDataChanged);
	var _onXleGrid = items['C104000060_Grid_1'].onXLEEvent(onLoadGrid);
	
	
//]]>
-->
</script>