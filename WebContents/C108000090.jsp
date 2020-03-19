<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000090.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  개발의뢰  BOM
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.06.17
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
<title>개발의뢰 BOM</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();  //public dhtmlx component array
/* var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C108000090_Form_1","xml":".\/header\/kr\/C108000090\/C108000090_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000090_Grid_1","service":"C108000090-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C108000090_Grid_1","xml":".\/header\/kr\/C108000090\/C108000090_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000090_Grid_1","service":"C108000090-service","actionType":"save"},' +
      '{"itemType":"menu","renderTo":"C108000090_Menu_1","xml":".\/header\/kr\/C108000090\/C108000090_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000090_Grid_1","service":"C108000090-service"},' +
      '{"itemType":"form","renderTo":"C108000090_Form_2","xml":".\/header\/kr\/C108000090\/C108000090_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000090_Grid_1","service":"C108000090-service","actionType":"find"},' +   
      '{"itemType":"form","renderTo":"C108000090_Form_3","xml":".\/header\/kr\/C108000090\/C108000090_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000090_Form_1","service":"C108000090-service"},' +
      '{"itemType":"grid","renderTo":"C108000090_Grid_2","xml":".\/header\/kr\/C108000090\/C108000090_Grid_2.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000090_Grid_1","service":"C108000090-service"},' +   
      '{"itemType":"messagebox","renderTo":"C108000090_messagebox","xml":".\/header\/kr\/C108000090\/C108000090_messagebox.xml","service":"C108000090-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);
 */
var Menu_1 = {"itemType":"menu","renderTo":"C108000090_Menu_1","xml":".\/header\/kr\/C108000090\/C108000090_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000090_Grid_2","service":"C108000090-service"};
var Form_1 = {"itemType":"form","renderTo":"C108000090_Form_1","xml":".\/header\/kr\/C108000090\/C108000090_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000090_Grid_1","service":"C108000090-service","actionType":"find","security":"true"};
var Form_2 = {"itemType":"form","renderTo":"C108000090_Form_2","xml":".\/header\/kr\/C108000090\/C108000090_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000090_Grid_1","service":"C108000090-service","actionType":"find"};
var Form_3 = {"itemType":"form","renderTo":"C108000090_Form_3","xml":".\/header\/kr\/C108000090\/C108000090_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000090_Form_1","service":"C108000090-service"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000090_Grid_1","xml":".\/header\/kr\/C108000090\/C108000090_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000090_Grid_1","service":"C108000090-service"};
var Grid_2 = {"itemType":"grid","renderTo":"C108000090_Grid_2","xml":".\/header\/kr\/C108000090\/C108000090_Grid_2.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000090_Grid_2","service":"C108000090-service","actionType":"save"};

Grid_2.menu = Menu_1;
var initLayout = 
{
	"programId":"C108000090", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"35", "splitter":false, "components": 
 	[
	 	Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"40%", "splitter":true, "components": 
			[
			 	{
			 		"itemType": "layout", "dirType":"row", "childSize":",140", "splitter":true, 
			 		"header":"*[개발요청 Spec]", "components": 
					[
					 	Grid_1,
						Form_2,
					]
			 		
			 	},
			 	{
			 		"itemType": "layout", "dirType":"row", "childSize":",300", "splitter":true, 
			 		"header":"*[개발의뢰 BOM]","arrow":false,"components": 
					[
					 	Grid_2,
						Form_3,
					]
			 		
			 	},
			]
		}
 	]
}; 
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var formLoadFlag = false;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	findReqBomGrid();
}
function save(eventName,formDivObj,referenceItem){		
	
	var gridSpec = items[referenceItem];
	var gridSpecObj = gridSpec.getDhxGrid();
	var rowID1 = gridSpecObj.getSelectedRowId();	
	
	var prdDevNo = gridSpec.getCellValue(rowID1,gridSpecObj.getColIndexById('PRD_DEV_NO'));
	var devReqSpecNo = gridSpec.getCellValue(rowID1,gridSpecObj.getColIndexById('DEV_REQ_SPEC_NO'));
	
	var grid = items['C108000090_Grid_2'];
	var gridObj = grid.getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var statusCnt = 0;


	for(var i=0; i< grid_cnt; i++){
		var row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		if(row_status == 'inserted'){
	      	grid.setCellValue(gridObj.getRowId(i), gridObj.getColIndexById('PRD_DEV_NO'), prdDevNo);
        	var prdDevNoChk  = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('PRD_DEV_NO'));
        	if(isNull(prdDevNoChk)){
        		dhtmlx.alert("개발 번호는 필수 입력입니다.");
        		return;	
        	}
        	grid.setCellValue(gridObj.getRowId(i), gridObj.getColIndexById('DEV_REQ_SPEC_NO'), devReqSpecNo);
        	var devReqSpecNoChk  = grid.getCellValue(gridObj.getRowId(i), gridObj.getColIndexById('DEV_REQ_SPEC_NO'));
        	if(isNull(devReqSpecNoChk)){
        		dhtmlx.alert("개발 SPEC번호는 필수 입력입니다.");
        		return;
        	}
		} else if(row_status == 'updated' || row_status == 'deleted') {
			var devReqBomNo = grid.getCellValue(gridObj.getRowId(i), gridObj.getColIndexById('DEV_REQ_BOM_NO'));			
			var param = "ServiceName=C108000090-service&devCmpBomChk=1&PRD_DEV_NO=" + prdDevNo + "&DEV_REQ_SPEC_NO=" + devReqSpecNo + "&DEV_REQ_BOM_NO=" + devReqBomNo + "&column-info=DEV_CMP_BOM_YN";
			var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
			var cells = xmlObj.getElementsByTagName("cell");
			var devCmpBomYn = cells.item(0).firstChild.nodeValue;
			
			if(devCmpBomYn != 'N'){     		
        		dhtmlx.alert("개발 완료 진행으로 수정 및 삭제 불가 합니다.");
        		return;	
        	}
		}

		if(row_status != '') {			
			statusCnt++;
		}
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
				items['C108000090_Grid_2'].sendGrid('C108000090_Grid_2',eventName);
				return;
			}
		}
	});	
}
function findReqBomGrid(){
	var prdDevNo = items['C108000090_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		alert("개발 번호는 필수 입력입니다.");
		items['C108000090_Form_1'].setItemFocus("PRD_DEV_NO");
		return;		
	}
	var findUrl = uiCommon.parameters("C108000090_Form_1","C108000090_Grid_1","find");
	items['C108000090_Grid_1'].loadData(findUrl,loadAfterEvent);
}
function bindingFormToGrid(value, text) {
	var grid = items['C108000090_Grid_2'];
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
		alert("선택된 Row가 없습니다.");
	}
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    findReqBomGrid();
}
//menu new row event function
function add(referenceItem){
   if (items['C108000090_Grid_1'].getSelectedRowId() == null) {
		dhtmlx.alert("선택된 개발 SPEC번호가 없습니다.");
        return;	
   }
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
	var form3 = items['C108000090_Form_3'];
	var formObj3 = form3.getDhxForm();
	if(formObj3.isLocked()){
		formObj3.unlock();
		var cotMth = form3.getItemValue("COT_MTH");
		onFormCotMthEnable(cotMth);
	} else {
		formObj3.lock();
	}
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
	    items['C108000090_Form_1'].setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
	    if(!isNull("<%=DEV_REQ_SPEC_NO%>")){
	    	items['C108000090_Form_1'].setItemValue("DEV_REQ_SPEC_NO","<%=DEV_REQ_SPEC_NO%>");
	    }
	}
	
	formLoadFlag = true;
	items['C108000090_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function onGridLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
		findReqBomGrid();
	}
	items['C108000090_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onGridLoadFunction2(){
	items['C108000090_Grid_2'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
	items['C108000090_Grid_2'].getDhxGrid().detachEvent(onXleGrid2);
}
function onSelectGrid1(){
	var findUrl2 = parameters14('C108000090_Grid_1','C108000090_Grid_2','findGrid2','gridC10Data.do');
	items["C108000090_Grid_2"].loadData(findUrl2,loadAfterEvent2);
}
function onSelectGrid2(){
	var grid2 = items['C108000090_Grid_2'];
	var gridObj2 = grid2.getDhxGrid();
	var form3 = items['C108000090_Form_3'];
	var formObj3 = form3.getDhxForm();
		
	var rowStatus2 =  gridObj2.getUserData(grid2.getRowSelectedId(),"!nativeeditor_status");
	//grid.getDhxDataProcess().getState(grid.getRowSelectedId())
	if( rowStatus2 !== 'inserted') {
		formObj3.lock();
	}
	// 신규 추가된 row일 경우 (행추가)
	else {
		formObj3.unlock();  //폼 에디트 모드로 변경
		var cotMth = form3.getItemValue("COT_MTH");
		onFormCotMthEnable(cotMth);
	}
}
function onFormLoadFunction2(){
	 //items['C108000090_Form_2'].setBackgroundColor("#C8FAC8");
	 var formObj2 = items['C108000090_Form_2'].getDhxForm();
	 formObj2.bind(items['C108000090_Grid_1'].getDhxGrid());
	 
	 formObj2.detachEvent(onXleForm2);
}
function onFormLoadFunction3(){
	 //items['C108000090_Form_3'].setBackgroundColor("#C8FAC8");
	 var formObj3 = items['C108000090_Form_3'].getDhxForm();
	 formObj3.bind(items['C108000090_Grid_2'].getDhxGrid());
    //Form Input값 변경시 발생 이벤트
	 formObj3.attachEvent('onInputChange', function(name, value, form) {
	 	bindingFormToGrid(name, value);
	 });
	 //Form Combo값 변경시 발생 이벤트
	 formObj3.attachEvent('onChange', function(value, text) {
	 	bindingFormToGrid(value, text);
	 	
	 	if(value == "COT_MTH")
			onFormCotMthEnable(text);
	 });

	 var comboList = items['C108000090_Form_3'].getMasterCombos();

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

	comboList['LMN_KND_TP'].readonly(true,false);
	ui.combo.master(comboList['LMN_KND_TP'],'SZ0000','LMN_KND_TP','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['LMN_KND_TP'].selectOption(0,true,true);
		comboList['LMN_KND_TP'].readonly(true);
		comboList['LMN_KND_TP'].setOptionHeight(120);
	});
	
	onFormCotMthEnable('');

	formObj3.detachEvent(onXleForm3);
	//$("input[name=HUE_CD_FRN_3COT]")[0].style ="background-color:#FFFFC0"
	//$("input[name=HUE_CD_FRN_4COT]").css({"background-color":"#FFFFC0"})
}
function onGridAfterUpdateFinishEvent2(){
	refresh('C108000090_Grid_2');
}
function serchIcon_PNT_CMP_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('PNT_CMP_CD','SZ0000','PNT_CMP_CD','C108000090_Form_3');\">";
}
function serchIcon_LMN_BND_CMP_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('PNT_CMP_CD','SZ0000','LMN_BND_CMP_CD','C108000090_Form_3');\">";
}
function serchIcon_ROLL_CMP_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('PNT_CMP_CD','SZ0000','PRT_BY_ROLL_CMP_CD','C108000090_Form_3');\">";
}
function serchIcon_RSN_TP(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('RSN_TP','SZ0000','RSN_TP','C108000090_Form_3');\">";
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
	if(formId == "C108000090_Form_3") {
		bindingFormToGrid(target, code);
	}
}

function loadAfterEvent(){
	uiCommon.progressOff(parent);

	var grid1Obj = items['C108000090_Grid_1'].getDhxGrid();	
	
	if ( grid1Obj.getRowsNum() > 0 ) { 
		items['C108000090_Grid_1'].getDhxGrid().selectRow(0,true);;
	}
	
	findMessage(grid1Obj);
  	return true;
}

function loadAfterEvent2(){
	uiCommon.progressOff(parent);

	var grid2Obj = items['C108000090_Grid_2'].getDhxGrid();
	
	if ( grid2Obj.getRowsNum() > 0 ) { 
		items['C108000090_Grid_2'].getDhxGrid().selectRow(0,true);;
	}
  	return true;
}
//개발업체 코팅방식 제외하고 미활성
function onFormCotMthEnable(cotMthValue){
	var formObj3 = items['C108000090_Form_3'].getDhxForm();	
	formObj3.forEachItem(function(name){
		if(name.substring(0,5) != "BLOCK") {
			if(name == 'PNT_CMP_CD' || name == 'COT_MTH') {
				formObj3.enableItem(name);
			} else {
				if (cotMthValue == '') {
					formObj3.disableItem(name);
				} else {
					if(cotMthValue == '1') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_2COT' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == '2') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_2COT' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					
					} else if(cotMthValue == '3') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' 
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == '4') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == '5') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);					
					} else if(cotMthValue == '6') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == '7') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == '8') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == '9') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_4COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == 'A') {
						if(name == 'DEV_REQ_BOM_NO'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'B') {
						if(name == 'DEV_REQ_BOM_NO'
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);					
					} else if(cotMthValue == 'C') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' 
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);					
					} else if(cotMthValue == 'D') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' 
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == 'E') {
						if(name == 'DEV_REQ_BOM_NO'	|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK' || name == 'PRT_BY_ROLL_CMP_CD')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'F') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_LMN'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'G') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'H') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_LMN' 
							|| name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'J') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3'
							|| name == 'LMN_BND_CMP_CD' || name == 'LMN_KND_TP' || name == 'LMN_FLM_THK')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == 'X' || cotMthValue == 'Y' || cotMthValue == 'Z') {
						if(name == 'DEV_REQ_BOM_NO' || name == 'HUE_CD_FRN_1COT' || name == 'HUE_CD_FRN_2COT' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' || name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'RSN_TP'	|| name == 'PNT_FLM_THK_TXT' || name == 'PRT_BY_ROLL_CMP_CD' || name == 'SPC_PRD_AF_WK')
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					}
				}
			}
		}
	}); 
}

function setImgIcon(name,val){
	return "<img id=\"save\" style=\"cursor:pointer\" src='./dhtmlx/codebase/imgs/save_dis.gif' align=\"top\" onClick=\"C10_linkC108000010pop02()\">";
}

function C10_linkC108000010pop02(){

	var gridSpec = items['C108000090_Grid_1'];
	var gridSpecObj = gridSpec.getDhxGrid();
	var rowID1 = gridSpecObj.getSelectedRowId();	
	
	var prdDevNo = gridSpec.getCellValue(rowID1,gridSpecObj.getColIndexById('PRD_DEV_NO'));
	var devReqSpecNo = gridSpec.getCellValue(rowID1,gridSpecObj.getColIndexById('DEV_REQ_SPEC_NO'));
	
	var gridBom = items['C108000090_Grid_2'];
	var gridBomObj = gridBom.getDhxGrid();
	var rowID2 = gridBomObj.getSelectedRowId();
	
	var devReqBomNo = gridBom.getCellValue(rowID2,gridBomObj.getColIndexById('DEV_REQ_BOM_NO'));
	
	if(isNull(devReqBomNo)||devReqBomNo==''){
		dhtmlx.alert("접수요청 BOM 번호가 없습니다. 저장후 시안 저장을 눌러주세요");
	}
	var prdDevNo = prdDevNo + devReqSpecNo + devReqBomNo;
	if(!isNull(prdDevNo)){
			winObj = new ui.window("coilImgRegPopWin","비고 이미지 등록","0","0","465","405", "C108000010pop02.jsp?"
					+ "IMG_RGS_TP=1"
					+ "&PRD_DEV_NO=" + prdDevNo
					+ "&PRD_DEV_SEQ_NO=0"
				);
			winObj.setButtonDisable("park,minmax1");
			winObj.setModal();
	}else {
		dhtmlx.alert("접수요청 번호가 없습니다.");
	}
}

function doImgPopUp1(rowIdx){
	
	C10_linkC108000010pop02();
	/*var gridObj = items["C108000090_Grid_2"].getDhxGrid();
	var FILE_NM_DOC = gridObj.cellById(rowIdx,gridObj.getColIndexById("IMG_NM")).getValue();
	var FILE_YN = gridObj.cellById(rowIdx,gridObj.getColIndexById("FILE_YN")).getValue();
	
	if(!isNull(FILE_NM_DOC) || FILE_NM_DOC!=""){
		var url = "";
		url += "_fileDownloadHandler.jsp?";
		url += "&FILE_ADR="+ "/APP/WAS/FILES/C10/05";
		url += "&FILE_NM="+ FILE_NM_DOC;
		location.href = url;
	}*/
}
//]]>
</script>
</head>
<body>
	<!-- <div id="C108000090_Form_1" style="position:absolute; height:28px; width:981px; left:0px; top:0px;">
	</div>	
	<div id="C108000090_Grid_1"	style="position:absolute; height:90px; width:975px; left:0px; top:32px;">
	</div>
	<div id="C108000090_Form_2"	style="position:absolute; height:121px; width:981px; left:0px; top:122px;">
	</div>
	<div id="C108000090_Menu_1"	style="position:absolute; height:28px; width:977px; left:1px; top:243px;">
	</div>
	<div id="C108000090_Grid_2"	style="position: absolute; height:90px; width: 977px; left: 0px; top: 271px;">
	</div>
	<div id="C108000090_Form_3"	style="position:absolute; height:203px; width:981px; left:0px; top:322px;">
	</div>
	<div id="C108000090_messagebox"	style="position: absolute; height: 19px; width: 977px; left: 1px; top: 567px;">
	</div> -->
</body>
</html>
<script>//<![CDATA[
	ui.initializeDHTMLX();          
	//items['C105000020_Form_1'].setBackgroundColor("#FFFFFF");
	//items['C108000090_Menu_1'].setBackgroundColor("#FFFFFF");
	items["C108000090_Grid_1"].rowSelected(onSelectGrid1);
	items["C108000090_Grid_2"].rowSelected(onSelectGrid2);
	var onXleForm = items['C108000090_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000090_Grid_1'].onXLEEvent(onGridLoadFunction);	
    var onXleForm2 = items['C108000090_Form_2'].onXLEEvent(onFormLoadFunction2);
    var onXleGrid2 = items['C108000090_Grid_2'].onXLEEvent(onGridLoadFunction2);
	var onXleForm3 = items['C108000090_Form_3'].onXLEEvent(onFormLoadFunction3);
//]]>
</script>