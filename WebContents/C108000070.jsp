<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000070.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  개발요청 Spec
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.05.24
 *
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String PRD_DEV_NO = request.getParameter("PRD_DEV_NO") != null ? request.getParameter("PRD_DEV_NO") : "";
	String DEV_REQ_SPEC_NO = request.getParameter("DEV_REQ_SPEC_NO") != null ? request.getParameter("DEV_REQ_SPEC_NO") : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>개발요청 SPEC</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">

//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C108000070_Form_1","xml":".\/header\/kr\/C108000070\/C108000070_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000070_Grid_1","service":"C108000070-service","actionType":"find","security":"true"},' +
//       '{"itemType":"grid","renderTo":"C108000070_Grid_1","xml":".\/header\/kr\/C108000070\/C108000070_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000070_Grid_1","service":"C108000070-service","actionType":"save"},' +
//       '{"itemType":"menu","renderTo":"C108000070_Menu_1","xml":".\/header\/kr\/C108000070\/C108000070_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000070_Grid_1","service":"C108000070-service"},' +
//       '{"itemType":"form","renderTo":"C108000070_Form_2","xml":".\/header\/kr\/C108000070\/C108000070_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000070_Grid_1","service":"C108000070-service","actionType":"find"},' +   
//       '{"itemType":"form","renderTo":"C108000070_Form_3","xml":".\/header\/kr\/C108000070\/C108000070_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000070_Form_1","service":"C108000070-service"},' +
//       '{"itemType":"grid","renderTo":"C108000070_Grid_2","xml":".\/header\/kr\/C108000070\/C108000070_Grid_2.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000070_Grid_1","service":"C108000070-service"},' +   
//       '{"itemType":"messagebox","renderTo":"C108000070_messagebox","xml":".\/header\/kr\/C108000070\/C108000070_messagebox.xml","service":"C108000070-service"}' +
//    ']';
// var initConfig = JSON.parse(pageConfiguration);	

var Form_1 = {"itemType":"form","renderTo":"C108000070_Form_1","xml":".\/header\/kr\/C108000070\/C108000070_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000070_Grid_1","service":"C108000070-service","actionType":"find","security":"true"};
var Menu_1 = {"itemType":"menu","renderTo":"C108000070_Menu_1","xml":".\/header\/kr\/C108000070\/C108000070_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000070_Grid_1","service":"C108000070-service"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000070_Grid_1","xml":".\/header\/kr\/C108000070\/C108000070_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000070_Grid_1","service":"C108000070-service","actionType":"save"};
var Form_2 = {"itemType":"form","renderTo":"C108000070_Form_2","xml":".\/header\/kr\/C108000070\/C108000070_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000070_Grid_1","service":"C108000070-service","actionType":"find"};
var Form_3 = {"itemType":"form","renderTo":"C108000070_Form_3","xml":".\/header\/kr\/C108000070\/C108000070_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000070_Form_1","service":"C108000070-service"};
var Grid_2 = {"itemType":"grid","renderTo":"C108000070_Grid_2","xml":".\/header\/kr\/C108000070\/C108000070_Grid_2.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000070_Grid_1","service":"C108000070-service","actionType":"save"};   

Grid_1.menu = Menu_1;
//Form_2.header = "*";
//Form_2.arrow = true;

var initLayout = 
{
	"programId":"C108000070", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"35", "splitter":false, "components": 
 	[
	 	Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"300,150", "splitter":true, "components": 
			[
				Grid_1,
				Form_2,
				{
					"itemType": "layout", "dirType":"row", "childSize":"30", "splitter":true, "components": 
					[
						Form_3,
						Grid_2,
					]
				}
			]
		}
 	]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var formLoadFlag = false;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	findSpecGrid();
}
function save(eventName,formDivObj,referenceItem){
	
	var grid = items[referenceItem];
	var gridObj = items[referenceItem].getDhxGrid();	
	var prdDevNo = items[formDivObj].getItemValue("PRD_DEV_NO");
	var grid_cnt = gridObj.getRowsNum();
	var statusCnt = 0;
	
	for(var i=0; i< grid_cnt; i++){
		var row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");		
		if(row_status == 'inserted'){
			grid.setCellValue(gridObj.getRowId(i),gridObj.getColIndexById('PRD_DEV_NO'), prdDevNo);
	      	var prdDevNoChk  = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('PRD_DEV_NO'));
	      	if(isNull(prdDevNoChk)){        		
	      		dhtmlx.alert("개발 번호는 필수 입력입니다.");
	      		return;	
	      	}
	      	
	       	var clrDevTp  = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('CLR_DEV_TP'));
	      	if(isNull(clrDevTp)){        		
	      		dhtmlx.alert("개발 유형은 필수 입력입니다.");
	      		return;	
	      	}
	      	
	       	var devRefTp  = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('DEV_REF_TP'));
	      	if(isNull(devRefTp)){        		
	      		dhtmlx.alert("개발참조 유형은 필수 입력입니다.");
	      		return;	
	      	}
		}
		
		if(row_status != '')
			statusCnt++;
	}

	if(statusCnt <= 0){
		dhtmlx.alert("저장할 데이타가 없습니다.");
		return;
	}
	
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

function findSpecGrid(){
	
	var prdDevNo = items['C108000070_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		dhtmlx.alert("개발 번호는 필수 입력입니다.");
		items['C108000070_Form_1'].setItemFocus("PRD_DEV_NO");
		return;		
	}
	var findUrl = uiCommon.parameters("C108000070_Form_1","C108000070_Grid_1","find");
	items['C108000070_Grid_1'].loadData(findUrl,loadAfterEvent);
}
//grid1 row selected
function findSmpGrid(){
	var findUrl2 = parameters14('C108000070_Grid_1','C108000070_Grid_2','findSmp','basicGridData.do');
	items['C108000070_Grid_2'].loadData(findUrl2,loadAfterEvent2);
}

function bindingFormToGrid(value, text) {
	var grid = items['C108000070_Grid_1'];
	var dhxGrid = grid.getDhxGrid();
	var rowID = dhxGrid.getSelectedRowId();

	if (rowID != null) {
		for(var i = 0; i < dhxGrid.getColumnsNum(); i++) {
			if(dhxGrid.getColumnId(i) === value) {
				dhxGrid.cells(rowID, i).setValue(text);
				grid.setUpdated(rowID, true, 'updated');
			}
		}
	} else {
		dhtmlx.alert("선택된 Row가 없습니다.");
	}
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    findSpecGrid();
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
	var formObj2 = items['C108000070_Form_2'].getDhxForm();
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
	    items['C108000070_Form_1'].setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
	    if(!isNull("<%=DEV_REQ_SPEC_NO%>")){
	    	items['C108000070_Form_1'].setItemValue("DEV_REQ_SPEC_NO","<%=DEV_REQ_SPEC_NO%>");
	    }
	}
	formLoadFlag = true;
	items['C108000070_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function onGridLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
		findSpecGrid();  
	}
	
	items['C108000070_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C108000070_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onSelectGrid(){
	var grid = items['C108000070_Grid_1'];
	var gridObj = grid.getDhxGrid();
	
	var form2 = items['C108000070_Form_2'];
	var formObj2 = form2.getDhxForm();
		
	var rowStatus =  gridObj.getUserData(grid.getRowSelectedId(),"!nativeeditor_status");
	//grid.getDhxDataProcess().getState(grid.getRowSelectedId())
	if( rowStatus !== 'inserted') {
		formObj2.lock();
	}
	// 신규 추가된 row일 경우 (행추가)
	else {
		formObj2.unlock();  //폼 에디트 모드로 변경
		formObj2.disableItem("DEV_REQ_SPEC_NO");
	}	
	
	var clrDevTp = "";

	if (gridObj.getSelectedRowId() != null)
		clrDevTp = items['C108000070_Grid_1'].getCellValue(gridObj.getSelectedRowId(),gridObj.getColIndexById("CLR_DEV_TP"));
		
	var comboDevRefTp = form2.getMasterCombos();
	comboDevRefTp['DEV_REF_TP'].readonly(true,false);
	if (clrDevTp == 'C') {
		ui.combo.master(comboDevRefTp['DEV_REF_TP'],'SZ0000','DEV_REF_TP_CLR','totalValue=,orderBy=value,displayType=all-code',function(){
			comboDevRefTp['DEV_REF_TP'].readonly(true);
			comboDevRefTp['DEV_REF_TP'].setOptionHeight(120);
		});
	} else if (clrDevTp == 'D') {
		ui.combo.master(comboDevRefTp['DEV_REF_TP'],'SZ0000','DEV_REF_TP_DESN','totalValue=,orderBy=value,displayType=all-code',function(){
			comboDevRefTp['DEV_REF_TP'].readonly(true);
			comboDevRefTp['DEV_REF_TP'].setOptionHeight(120);
		});
	}else {
		comboDevRefTp['DEV_REF_TP'].clearAll();
	}
	
	findSmpGrid();
}
function onFormLoadFunction2(){	

	var formObj2 = items['C108000070_Form_2'].getDhxForm();
	formObj2.bind(items['C108000070_Grid_1'].getDhxGrid());

	//Form Input값 변경시 발생 이벤트
	formObj2.attachEvent('onInputChange', function(name, value, form) {
		bindingFormToGrid(name, value);
	});
		
	//Form Combo값 변경시 발생 이벤트
	formObj2.attachEvent('onChange', function(value, text) {
		bindingFormToGrid(value, text);

		if(value == 'CLR_DEV_TP') {	
			var comboDevRefTp = items['C108000070_Form_2'].getMasterCombos();
			comboDevRefTp['DEV_REF_TP'].readonly(true,false);
			if (text == 'C') {
				ui.combo.master(comboDevRefTp['DEV_REF_TP'],'SZ0000','DEV_REF_TP_CLR','totalValue=,orderBy=value,displayType=all-code',function(){
					comboDevRefTp['DEV_REF_TP'].readonly(true);
					comboDevRefTp['DEV_REF_TP'].setOptionHeight(120);
				});
			} else if (text == 'D') {
				ui.combo.master(comboDevRefTp['DEV_REF_TP'],'SZ0000','DEV_REF_TP_DESN','totalValue=,orderBy=value,displayType=all-code',function(){
					comboDevRefTp['DEV_REF_TP'].readonly(true);
					comboDevRefTp['DEV_REF_TP'].setOptionHeight(120);
				});
			}else {
				comboDevRefTp['DEV_REF_TP'].clearAll();
			}
		}
		
	});
	
	var comboList = items['C108000070_Form_2'].getMasterCombos();
	
	comboList['PRD_NM_CD'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD'],'SJ0001','PRD_NM_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['PRD_NM_CD'].selectOption(0,true,true);
		comboList['PRD_NM_CD'].readonly(true);
		comboList['PRD_NM_CD'].setOptionHeight(120);
	});

	comboList['COT_MTH'].readonly(true,false);
	ui.combo.master(comboList['COT_MTH'],'SZ0000','COT_MTH','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['COT_MTH'].selectOption(0,true,true);
		comboList['COT_MTH'].readonly(true);
		comboList['COT_MTH'].setOptionHeight(120);
		comboList['COT_MTH'].setOptionWidth(200);
	});

	comboList['TLP_TP'].readonly(true,false);
	ui.combo.master(comboList['TLP_TP'],'SZ0000','TLP_TP','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['TLP_TP'].selectOption(0,true,true);
		comboList['TLP_TP'].readonly(true);
		comboList['TLP_TP'].setOptionHeight(120);
	});

	comboList['PTT_FLM_YN'].readonly(true,false);
	ui.combo.master(comboList['PTT_FLM_YN'],'SZ0000','PTT_FLM_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['PTT_FLM_YN'].selectOption(0,true,true);
		comboList['PTT_FLM_YN'].readonly(true);
		comboList['PTT_FLM_YN'].setOptionHeight(120);
	});

	formObj2.detachEvent(onXleForm2);
}
function onGridLoadFunction2(){
	items['C108000070_Grid_2'].onAfterUpdateFinishEvent(findSpecGrid);
	items['C108000070_Grid_2'].getDhxGrid().detachEvent(onXleGrid2);
}
//
function onGridAfterUpdateFinishEvent(){
/* 	var gridObj = items['C108000070_Grid_1'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj.getRowId(i);
        items['C108000070_Grid_1'].setUpdated(rowID,false,""); 
	}
	items['C108000070_Grid_1'].clearDataProcess(); */
	refresh('C108000070_Grid_1');
}

function serchIcon_RSN_TP(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('RSN_TP','SZ0000','RSN_TP','C108000070_Form_2');\">";
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
	if(formId == "C108000070_Form_2") {
		bindingFormToGrid(target, code);
	}
}

function loadAfterEvent(){
	uiCommon.progressOff(parent);
	var grid1Obj = items['C108000070_Grid_1'].getDhxGrid();
	
	if ( grid1Obj.getRowsNum() > 0 ) { 
		items['C108000070_Grid_1'].getDhxGrid().selectRow(0,true);
		findMessage(grid1Obj);
	}	
  	return true;
}


function loadAfterEvent2(){
	uiCommon.progressOff(parent);
	var grid2Obj = items['C108000070_Grid_2'].getDhxGrid();
	
	if ( grid2Obj.getRowsNum() > 0 ) { 
		items['C108000070_Grid_2'].getDhxGrid().selectRow(0,true);
		findMessage(grid2Obj);
	}
	
	items['C108000070_Form_3'].setItemValue("SIM_CNT",grid2Obj.getRowsNum());
  	return true;
}

//참조 샘플관리 link
function simple_call(){
	var gridSpecObj = items['C108000070_Grid_1'].getDhxGrid();
	var prdDevSpecNo = "";

	if (gridSpecObj.getSelectedRowId() != null)
		prdDevSpecNo = items['C108000070_Grid_1'].getCellValue(gridSpecObj.getSelectedRowId(),gridSpecObj.getColIndexById("PRD_DEV_SPEC_NO"));
	
	parent.newRemoveOpenTab('M205040040',
								'DEV_NO=' + prdDevSpecNo);	
}

function removeSmp(){
	debugger;
	var grid2 = items['C108000070_Grid_2'];
	var grid2Obj = grid2.getDhxGrid();
	var curRowId = grid2Obj.getSelectedRowId();

	if (curRowId != null) {
	    var smplNo = grid2.getCellValue(curRowId,grid2Obj.getColIndexById('SMPL_NO'));
		   if(isNull(smplNo)){	
		   	dhtmlx.alert("샘플 번호 누락");
		   	return;	
	    }
	    var prdDevSpecNo = grid2.getCellValue(curRowId,grid2Obj.getColIndexById('PRD_DEV_SPEC_NO'));
	    if(isNull(prdDevSpecNo)){
	     	dhtmlx.alert("개발 번호 누락");
	    	return;	
	    }
		
		grid2.setUpdated(curRowId,"true","updated");
		
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"참조 샘플 연결 해제 하시겠습니까?",
			callback:function(val){
				if(val){					
					items['C108000070_Grid_2'].sendGrid('C108000070_Grid_2','removeSmp');
					return;
				}
			}
		});
	} else {
		dhtmlx.alert("해제할 데이타가 없습니다.");
		return;
	}
}

//]]>
</script>
</head>
<body>
	<!-- <div id="C108000070_Form_1"	style="position:absolute; height:28px; width:981px; left:0px; top:0px;">
	</div>
	<div id="C108000070_Menu_1"	style="position:absolute; height:28px; width:977px; left:1px; top:32px;">
	</div>
	<div id="C108000070_Grid_1"	style="position:absolute; height:184px; width:975px; left:0px; top:61px;">
	</div>
	<div id="C108000070_Form_2"	style="position:absolute; height:121px; width:981px; left:0px; top:245px;">
	</div>
	<div id="C108000070_Form_3"	style="position:absolute; height:28px; width:975px; left:0px; top:366px;">
	</div>
	<div id="C108000070_Grid_2"	style="position: absolute; height: 170px; width: 977px; left: 0px; top: 394px;">
	</div>	
	<div id="C108000070_messagebox"	style="position: absolute; height: 19px; width: 977px; left: 1px; top: 567px;">
	</div> -->
</body>
</html>
<script>//<![CDATA[
	ui.initializeDHTMLX();          
	//items['C105000020_Form_1'].setBackgroundColor("#FFFFFF");
	// items['C108000070_Menu_1'].setBackgroundColor("#FFFFFF");
	// items['C108000070_Form_2'].setBackgroundColor("#C8FAC8");
	// items['C108000070_Form_3'].setBackgroundColor("#FFFFFF");
	items["C108000070_Grid_1"].rowSelected(onSelectGrid);
	var onXleForm = items['C108000070_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000070_Grid_1'].onXLEEvent(onGridLoadFunction);	
    var onXleForm2 = items['C108000070_Form_2'].onXLEEvent(onFormLoadFunction2);
    var onXleGrid2 = items['C108000070_Grid_2'].onXLEEvent(onGridLoadFunction2);
//]]>
</script>