<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000190.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  특수제품후처리
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.06.24
 *
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String PRD_DEV_NO = request.getParameter("PRD_DEV_NO") != null ? request.getParameter("PRD_DEV_NO") : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>특수제품후처리</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">

//<![CDATA[
var items = new Array();  //public dhtmlx component array
/* var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C108000190_Form_1","xml":".\/header\/kr\/C108000190\/C108000190_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000190_Grid_1","service":"C108000190-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C108000190_Grid_1","xml":".\/header\/kr\/C108000190\/C108000190_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000190_Grid_1","service":"C108000190-service","actionType":"save"},' +
      '{"itemType":"menu","renderTo":"C108000190_Menu_1","xml":".\/header\/kr\/C108000190\/C108000190_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000190_Grid_1","service":"C108000190-service"},' +
      '{"itemType":"form","renderTo":"C108000190_Form_2","xml":".\/header\/kr\/C108000190\/C108000190_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000190_Grid_1","service":"C108000190-service","actionType":"find"},' +      
      '{"itemType":"messagebox","renderTo":"C108000190_messagebox","xml":".\/header\/kr\/C108000190\/C108000190_messagebox.xml","service":"C108000190-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	  */
var Menu_1 = {"itemType":"menu","renderTo":"C108000190_Menu_1","xml":".\/header\/kr\/C108000190\/C108000190_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000190_Grid_1","service":"C108000190-service"};
var Form_1 = {"itemType":"form","renderTo":"C108000190_Form_1","xml":".\/header\/kr\/C108000190\/C108000190_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000190_Grid_1","service":"C108000190-service","actionType":"find","security":"true"};
var Form_2 = {"itemType":"form","renderTo":"C108000190_Form_2","xml":".\/header\/kr\/C108000190\/C108000190_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000190_Grid_1","service":"C108000190-service","actionType":"find"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000190_Grid_1","xml":".\/header\/kr\/C108000190\/C108000190_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000190_Grid_1","service":"C108000190-service","actionType":"save"}; 

Grid_1.menu = Menu_1;
Form_2.header = "*[특수제품후처리]";
Form_2.arrow = true;

var initLayout = 
{
	"programId":"C108000190", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"35", "splitter":false, "components": 
 	[
	 	Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"300", "splitter":true, "components": 
			[
				Grid_1,
				Form_2,
			]
		}
 	]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var formLoadFlag = false;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	findSpcAfGrid();
}
function save(eventName,formDivObj,referenceItem){

	var gridObj = items[referenceItem].getDhxGrid();
	var grid = items[referenceItem];	
	var prdDevNo = items[formDivObj].getItemValue("PRD_DEV_NO");

	gridObj.forEachRow(function(id){
        if(grid.getDhxDataProcess().getState(id) === 'inserted') {        	
        	grid.setCellValue(id,gridObj.getColIndexById('PRD_DEV_NO'), prdDevNo);
        	var prdDevNoChk  = gridObj.cellById(id,gridObj.getColIndexById('PRD_DEV_NO')).getValue();
        	if(isNull(prdDevNoChk)){        		
        		dhtmlx.alert("개발 번호는 필수 입력입니다.");
        		return;	
        	}
		}
    });
	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){					
				items[referenceItem].sendGrid(referenceItem,eventName);
				return;
			}
		}
	});	
}

function findSpcAfGrid(){
	var prdDevNo = items['C108000190_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		dhtmlx.alert("개발 번호는 필수 입력입니다.");
		items['C108000190_Form_1'].setItemFocus("PRD_DEV_NO");
		return;
	}
	var findUrl = uiCommon.parameters("C108000190_Form_1","C108000190_Grid_1","find");
	items['C108000190_Grid_1'].loadData(findUrl,loadAfterEvent);
}

function bindingFormToGrid(value, text) {
	var grid = items['C108000190_Grid_1'];
	var dhxGrid = grid.getDhxGrid();
	var rowID = dhxGrid.getSelectedRowId();
	
	for(var i = 0; i < dhxGrid.getColumnsNum(); i++) {
		if(dhxGrid.getColumnId(i) === value) {
			dhxGrid.cells(rowID, i).setValue(text);
			grid.setUpdated(rowID, true, 'updated');
		}
	}
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    findSpcAfGrid();
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
//menu edit event function
function edit(referenceItem){
	var formObj2 = items['C108000190_Form_2'].getDhxForm();
	if(formObj2.isLocked())
		formObj2.unlock();
	else
		formObj2.lock();
}
//menu refresh event function
function onGridContextMenuClick(id,gridObj,menuObj){
    var isChecked = menuObj.getCheckboxState(id);    
    if("copy_row" == id){
         var rowId=gridObj.getSelectedRowId();
         var cellInd=gridObj.getSelectedCellIndex();
        if(rowId !== null){
           gridObj.cellToClipboard(rowId, cellInd);
        }
    }  	
    if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
    }
}
function findMessage(referenceItem){
	uiCommon.message("messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>")){
	    items['C108000190_Form_1'].setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
	}
	formLoadFlag = true;
	items['C108000190_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function onGridLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
		findSpcAfGrid();  
	}
	
	items['C108000190_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C108000190_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onSelectGrid(){
	var grid = items['C108000190_Grid_1'];
	var gridObj = grid.getDhxGrid();
	var formObj2 = items['C108000190_Form_2'].getDhxForm();
		
	var rowStatus =  gridObj.getUserData(grid.getRowSelectedId(),"!nativeeditor_status");
	//grid.getDhxDataProcess().getState(grid.getRowSelectedId())
	if( rowStatus !== 'inserted') {
		formObj2.lock();
	}
	// 신규 추가된 row일 경우 (행추가)
	else {
		formObj2.unlock();  //폼 에디트 모드로 변경
		formObj2.disableItem("CLR_DEV_NO");
	}
}
function onFormLoadFunction2(){
	
	var formObj2 = items['C108000190_Form_2'].getDhxForm();
	formObj2.bind(items['C108000190_Grid_1'].getDhxGrid());

	//Form Input값 변경시 발생 이벤트
	formObj2.attachEvent('onInputChange', function(name, value, form) {
		bindingFormToGrid(name, value);
	});
	//Form Combo값 변경시 발생 이벤트
	formObj2.attachEvent('onChange', function(value, text) {
		bindingFormToGrid(value, text);
	});

	formObj2.detachEvent(onXleForm2);
}
//
function onGridAfterUpdateFinishEvent(){
	refresh('C108000190_Grid_1');
}

function loadAfterEvent(){
	uiCommon.progressOff(parent);

	var grid1Obj = items['C108000190_Grid_1'].getDhxGrid();
		
	if ( grid1Obj.getRowsNum() > 0 ) {
		items['C108000190_Grid_1'].getDhxGrid().selectRow(0,true);;
	}
	
	findMessage(grid1Obj);
  	return true;
}

//]]>
</script>
</head>
<body>
<!--<div id="C108000190_Form_1"	style="position:absolute; height:28px; width:981px; left:0px; top:0px;">
	</div>
	<div id="C108000190_Menu_1"	style="position:absolute; height:28px; width:977px; left:1px; top:32px;">
	</div>
	<div id="C108000190_Grid_1"	style="position:absolute; height:184px; width:975px; left:0px; top:61px;">
	</div>
	<div id="C108000190_Form_2"	style="position:absolute; height:121px; width:981px; left:0px; top:245px;">
	</div>	
	<div id="C108000190_messagebox"	style="position: absolute; height: 19px; width: 977px; left: 1px; top: 567px;">
	</div> -->
</body>
</html>
<script>//<![CDATA[
	ui.initializeDHTMLX();          
	//items['C108000190_Menu_1'].setBackgroundColor("#FFFFFF");
	//items['C108000190_Form_2'].setBackgroundColor("#C8FAC8");
	items["C108000190_Grid_1"].rowSelected(onSelectGrid);
	var onXleForm = items['C108000190_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000190_Grid_1'].onXLEEvent(onGridLoadFunction);	
    var onXleForm2 = items['C108000190_Form_2'].onXLEEvent(onFormLoadFunction2);
//]]>
</script>