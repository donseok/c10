<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000110.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  개발완료  BOM
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.06.20
 *
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String PRD_DEV_NO = request.getParameter("PRD_DEV_NO") != null ? request.getParameter("PRD_DEV_NO") : "";
	String DEV_REQ_SPEC_NO = request.getParameter("DEV_REQ_SPEC_NO") != null ? request.getParameter("DEV_REQ_SPEC_NO") : "";
	String DEV_REQ_BOM_NO = request.getParameter("DEV_REQ_BOM_NO") != null ? request.getParameter("DEV_REQ_BOM_NO") : "";
	String PNT_CMP_CD = request.getParameter("PNT_CMP_CD") != null ? request.getParameter("PNT_CMP_CD") : "";
	
	PosUser	user = (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String userNo	= "";
	//String userName = "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
		//userName 	= (String)user.getUserInfo("USER_NAME");
	}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>개발완료 BOM</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();  //public dhtmlx component array
/* var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C108000110_Form_1","xml":".\/header\/kr\/C108000110\/C108000110_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000110_Grid_1","service":"C108000110-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C108000110_Grid_1","xml":".\/header\/kr\/C108000110\/C108000110_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000110_Grid_1","service":"C108000110-service","actionType":"save"},' +
      '{"itemType":"menu","renderTo":"C108000110_Menu_1","xml":".\/header\/kr\/C108000110\/C108000110_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000110_Grid_1","service":"C108000110-service"},' +
      '{"itemType":"form","renderTo":"C108000110_Form_2","xml":".\/header\/kr\/C108000110\/C108000110_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000110_Grid_1","service":"C108000110-service","actionType":"find"},' +   
      '{"itemType":"form","renderTo":"C108000110_Form_3","xml":".\/header\/kr\/C108000110\/C108000110_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000110_Form_1","service":"C108000110-service"},' +
      '{"itemType":"grid","renderTo":"C108000110_Grid_2","xml":".\/header\/kr\/C108000110\/C108000110_Grid_2.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000110_Grid_1","service":"C108000110-service"},' +   
      '{"itemType":"messagebox","renderTo":"C108000110_messagebox","xml":".\/header\/kr\/C108000110\/C108000110_messagebox.xml","service":"C108000110-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);
 */
var Menu_1 = {"itemType":"menu","renderTo":"C108000110_Menu_1","xml":".\/header\/kr\/C108000110\/C108000110_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000110_Grid_2","service":"C108000110-service"};
var Form_1 = {"itemType":"form","renderTo":"C108000110_Form_1","xml":".\/header\/kr\/C108000110\/C108000110_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000110_Grid_1","service":"C108000110-service","actionType":"find","security":"true"};
var Form_2 = {"itemType":"form","renderTo":"C108000110_Form_2","xml":".\/header\/kr\/C108000110\/C108000110_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000110_Grid_1","service":"C108000110-service","actionType":"find"};
var Form_3 = {"itemType":"form","renderTo":"C108000110_Form_3","xml":".\/header\/kr\/C108000110\/C108000110_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000110_Form_1","service":"C108000110-service"};
var Form_4 = {"itemType":"form","renderTo":"C108000110_Form_4","xml":".\/header\/kr\/C108000110\/C108000110_Form_4.xml","url":"basicFormData.do","referenceItem":"C108000110_Form_1","service":"C108000110-service"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000110_Grid_1","xml":".\/header\/kr\/C108000110\/C108000110_Grid_1.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000110_Grid_1","service":"C108000110-service"};
var Grid_2 = {"itemType":"grid","renderTo":"C108000110_Grid_2","xml":".\/header\/kr\/C108000110\/C108000110_Grid_2.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000110_Grid_2","service":"C108000110-service","actionType":"save"};
var Grid_3 = {"itemType":"grid","renderTo":"C108000110_Grid_3","xml":".\/header\/kr\/C108000110\/C108000110_Grid_3.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000110_Grid_2","service":"C108000110-service","actionType":"save"};

Grid_2.menu = Menu_1;
var initLayout = 
{
	"programId":"C108000110", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"60", "splitter":false, "components": 
 	[
	 	Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"400,490", "splitter":true, "components": 
			[
				{
					"itemType": "layout", "dirType":"row", "childSize":",283", "splitter":true, 
					"header":"*[개발의뢰 BOM]", "components":
					[
						Grid_1,
						Form_2,
					]
					
				},
				{
					"itemType": "layout", "dirType":"row", "childSize":",335", "splitter":true, 
					"header":"*[개발완료 BOM]","arrow":false,"components": 
					[
						Grid_2,
						Form_3,
					]
					
				},
				{
					"itemType": "layout", "dirType":"row", "childSize":"30", "splitter":true, 
					"arrow":false,"components": 
					[
						Form_4,
						Grid_3,
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
	findCmpBomGrid();
}

function save(eventName,formDivObj,referenceItem){
	var gridReqBom = items['C108000110_Grid_1'];
	var gridReqBomObj = gridReqBom.getDhxGrid();
	var rowID1 = gridReqBomObj.getSelectedRowId();

	var prdDevNo = gridReqBom.getCellValue(rowID1,gridReqBomObj.getColIndexById('PRD_DEV_NO'));	
	var devReqSpecNo = gridReqBom.getCellValue(rowID1,gridReqBomObj.getColIndexById('DEV_REQ_SPEC_NO'));
	var devReqBomNo = gridReqBom.getCellValue(rowID1,gridReqBomObj.getColIndexById('DEV_REQ_BOM_NO'));
	
	var grid = items['C108000110_Grid_2'];
	var gridObj = grid.getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var statusCnt = 0;

	for(var i=0; i< grid_cnt; i++){
		var row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");		
		if(row_status == 'inserted'){
        	grid.setCellValue(gridObj.getRowId(i),gridObj.getColIndexById('PRD_DEV_NO'), prdDevNo);
        	var prdDevNoChk = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('PRD_DEV_NO'));
        	if(isNull(prdDevNoChk)){     		
        		dhtmlx.alert("개발 번호는 필수 입력입니다.");
        		return;	
        	}
        	grid.setCellValue(gridObj.getRowId(i),gridObj.getColIndexById('DEV_REQ_SPEC_NO'), devReqSpecNo);
        	var devReqSpecNoChk = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('DEV_REQ_SPEC_NO'));
        	if(isNull(devReqSpecNoChk)){
        		dhtmlx.alert("개발 SPEC번호는 필수 입력입니다.");
        		return;	
        	}
			grid.setCellValue(gridObj.getRowId(i),gridObj.getColIndexById('DEV_REQ_BOM_NO'), devReqBomNo);
        	var devReqBomNoChk = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('DEV_REQ_BOM_NO'));
        	if(isNull(devReqBomNoChk)){
        		dhtmlx.alert("개발의뢰 BOM번호는 필수 입력입니다.");
        		return;	
        	}
		}
		
		if(row_status != '') statusCnt++;
        
    };
    
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
				items['C108000110_Grid_2'].sendGrid('C108000110_Grid_2',eventName);
				return;
			}
		}
	});	
}
function findCmpBomGrid(){
	var prdDevNo = items['C108000110_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		dhtmlx.alert("개발 번호는 필수 입력입니다.");
		items['C108000110_Form_1'].setItemFocus("PRD_DEV_NO");
		return;		
	}
/* 	var pntCmpCd = items['C108000110_Form_1'].getItemValue("PNT_CMP_CD");
	if(isNull(pntCmpCd)){
		dhtmlx.alert("개발 업체는 필수 입력입니다.");
		items['C108000110_Form_1'].setItemFocus("PNT_CMP_CD");
		return;		
	} */
	var findUrl = uiCommon.parameters("C108000110_Form_1","C108000110_Grid_1","find");
	items['C108000110_Grid_1'].loadData(findUrl,loadAfterEvent);
}
function bindingFormToGrid(value, text) {
	var grid = items['C108000110_Grid_2'];
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
    findCmpBomGrid();
}
//menu new row event function
function add(referenceItem){
   if (items['C108000110_Grid_1'].getSelectedRowId() == null) {
		dhtmlx.alert("선택된 개발의뢰 BOM이 없습니다.");
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
	var form3 = items['C108000110_Form_3'];
	var formObj3 = form3.getDhxForm();
	if(formObj3.isLocked()){
		formObj3.unlock();
		var cotMth = form3.getItemValue("COT_MTH");
		onFormCotMthEnable(cotMth);
	} else
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
function onGridLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
		findCmpBomGrid();
	}
	items['C108000110_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onGridLoadFunction2(){
	items['C108000110_Grid_2'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
	items['C108000110_Grid_2'].getDhxGrid().detachEvent(onXleGrid2);
}
function onSelectGrid1(){
	var findUrl2 = parameters14('C108000110_Grid_1','C108000110_Grid_2','findGrid2','basicGridData.do');
	items["C108000110_Grid_2"].loadData(findUrl2,loadAfterEvent2);
}
function onSelectGrid2(){
	var grid2 = items['C108000110_Grid_2'];
	var gridObj2 = grid2.getDhxGrid();
	var form3 = items['C108000110_Form_3'];
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
	
	findLabSmpGrid();	
}
function onFormLoadFunction(){	
	var form   = items['C108000110_Form_1'];
	var formDhxObj = form.getDhxForm();
	
	if(!isNull("<%=PRD_DEV_NO%>")){
		form.setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
	    if("<%=DEV_REQ_SPEC_NO%>" != ""){
	    	form.setItemValue("DEV_REQ_SPEC_NO","<%=DEV_REQ_SPEC_NO%>");			
	    }
	    if("<%=DEV_REQ_BOM_NO%>" != ""){
	    	form.setItemValue("DEV_REQ_BOM_NO","<%=DEV_REQ_BOM_NO%>");
   		}
	    if("<%=PNT_CMP_CD%>" != ""){
	    	form.setItemValue("PNT_CMP_CD","<%=PNT_CMP_CD%>");
   		}	    
	}
	formLoadFlag = true;
	
	var param = "ServiceName=C108000230-service&userChk=1&SMTL_SLP_CD="+<%=userNo%>+"&column-info=SMTL_SLP_CD,SMTL_SLP_NM";
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell");
	if(cells.length == 0) 
		 formDhxObj.showItem('PNT_CMP_CD');
	else{
		 form.setItemValue('PNT_CMP_CD', <%=userNo%>);
		 formDhxObj.hideItem('PNT_CMP_CD');  
	}
	
	formDhxObj.detachEvent(onXleForm);
}
function onFormLoadFunction2(){
	 //items['C108000110_Form_2'].setBackgroundColor("#C8FAC8");
	
	 var formObj2 = items['C108000110_Form_2'].getDhxForm();
	 formObj2.bind(items['C108000110_Grid_1'].getDhxGrid());
	 
	 formObj2.detachEvent(onXleForm2);
}
function onFormLoadFunction3(){
	 //items['C108000110_Form_3'].setBackgroundColor("#C8FAC8");
	 var formObj3 = items['C108000110_Form_3'].getDhxForm();
	 formObj3.bind(items['C108000110_Grid_2'].getDhxGrid());
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

	 var comboList = items['C108000110_Form_3'].getMasterCombos();

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

	comboList['CUT_LN_YN'].readonly(true,false);
	ui.combo.master(comboList['CUT_LN_YN'],'SZ0000','CUT_LN_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['CUT_LN_YN'].selectOption(0,true,true);
		comboList['CUT_LN_YN'].readonly(true);
		comboList['CUT_LN_YN'].setOptionHeight(120);
	});

	comboList['PT_TP'].readonly(true,false);
	ui.combo.master(comboList['PT_TP'],'SZ0000','PT_TP','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['PT_TP'].selectOption(0,true,true);
		comboList['PT_TP'].readonly(true);
		comboList['PT_TP'].setOptionHeight(120);
	});

	comboList['DISC_PTN_WTH_CD'].readonly(true,false);
	ui.combo.master(comboList['DISC_PTN_WTH_CD'],'SZ0000','DISC_PTN_WTH_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['DISC_PTN_WTH_CD'].selectOption(0,true,true);
		comboList['DISC_PTN_WTH_CD'].readonly(true);
		comboList['DISC_PTN_WTH_CD'].setOptionHeight(120);
	});

	comboList['PRT_USG_CD'].readonly(true,false);
	ui.combo.master(comboList['PRT_USG_CD'],'SZ0000','PRT_USG_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['PRT_USG_CD'].selectOption(0,true,true);
		comboList['PRT_USG_CD'].readonly(true);
		comboList['PRT_USG_CD'].setOptionHeight(120);
	});

	comboList['PRT_PTN_CD'].readonly(true,false);
	ui.combo.master(comboList['PRT_PTN_CD'],'SZ0000','PRT_PTN_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['PRT_PTN_CD'].selectOption(0,true,true);
		comboList['PRT_PTN_CD'].readonly(true);
		comboList['PRT_PTN_CD'].setOptionHeight(120);
	});
	
	onFormCotMthEnable('');

	formObj3.detachEvent(onXleForm3);
}

function onGridLoadFunction3(){
	items['C108000110_Grid_3'].onAfterUpdateFinishEvent(findCmpBomGrid);
	items['C108000110_Grid_3'].getDhxGrid().detachEvent(onXleGrid3);
}

function onGridAfterUpdateFinishEvent2(){
	refresh('C108000110_Grid_2');
}

// function serchIcon_PNT_CMP_CD(name,val){
// 	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('PNT_CMP_CD','SZ0000','PNT_CMP_CD','C108000090_Form_3');\">";
// }

// var winObj;
// function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
// 	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
// 	winObj.setButtonDisable("park,minmax1");
// 	winObj.setModal();
// }

// // popup으로부터 넘겨받은 값 item에 세팅
// function masterSetValue(code,name,target,formId){
// 	items[formId].setItemValue(target,code);
// 	if(formId == "C108000110_Form_3") {
// 		bindingFormToGrid(target, code);
// 	}
// }
function loadAfterEvent(){
	uiCommon.progressOff(parent);

	var grid1Obj = items['C108000110_Grid_1'].getDhxGrid();	
	
	if ( grid1Obj.getRowsNum() > 0 ) { 
		items['C108000110_Grid_1'].getDhxGrid().selectRow(0,true);;
	}
	
	findMessage(grid1Obj);
  	return true;
}

function loadAfterEvent2(){
	uiCommon.progressOff(parent);

	var grid2Obj = items['C108000110_Grid_2'].getDhxGrid();
	
	if ( grid2Obj.getRowsNum() > 0 ) { 
		items['C108000110_Grid_2'].getDhxGrid().selectRow(0,true);;
	}
  	return true;
}
//개발업체 코팅방식 제외하고 미활성
function onFormCotMthEnable(cotMthValue){
	var formObj3 = items['C108000110_Form_3'].getDhxForm();	
	formObj3.forEachItem(function(name){
		if(name.substring(0,5) != "BLOCK") {
			if(name == 'PNT_CMP_CD' || name == 'COT_MTH') {
				formObj3.enableItem(name);
			} else {
				if (cotMthValue == '') {
					formObj3.disableItem(name);
				} else {
					if(cotMthValue == '1') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_2COT' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == '2') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_2COT' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					
					} else if(cotMthValue == '3') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' 
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == '4') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name);
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == '5') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);					
					} else if(cotMthValue == '6') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == '7') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == '8') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_4COT'
							|| name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == '9') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_4COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == 'A') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH'
							|| name == 'HUE_CD_BAK_1COT' || name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'B') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' 
							|| name == 'HUE_CD_BAK_2COT' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);					
					} else if(cotMthValue == 'C') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_BAK_3COT' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' 
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);					
					} else if(cotMthValue == 'D') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_BAK_4COT'
							|| name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' 
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'							
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == 'E') {
						if(name == 'DEV_CMP_BOM_NO'	|| name == 'DEV_CMP_DH' || name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'							
							|| name == 'DISC_PTN_WTH_CD' || name == 'CUT_LN_YN'
							|| name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'F') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_LMN'	|| name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'G') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1'
						    || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'H') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_LMN' 
							|| name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'	
							|| name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					} else if(cotMthValue == 'J') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_LMN' || name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2'
							|| name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3'
							|| name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);						
					} else if(cotMthValue == 'X' || cotMthValue == 'Y' || cotMthValue == 'Z') {
						if(name == 'DEV_CMP_BOM_NO' || name == 'DEV_CMP_DH' || name == 'HUE_CD_FRN_1COT' || name == 'HUE_CD_FRN_2COT' || name == 'HUE_CD_FRN_3COT' || name == 'HUE_CD_FRN_4COT'
							|| name == 'PRT_ROLL_NO1' || name == 'PRT_INK_CD1' || name == 'PRT_ROLL_NO2' || name == 'PRT_INK_CD2' || name == 'PRT_ROLL_NO3' || name == 'PRT_INK_CD3' || name == 'PRT_ROLL_NO4' || name == 'PRT_INK_CD4'
							|| name == 'UNFIX_NO' || name == 'UNI_TEX_PTN_CD' || name == 'PT_TP' || name == 'PRT_USG_CD' || name == 'PRT_PTN_CD' || name == 'SPC_PRD_AF_NO' || name == 'INK_DEV_NO' )
								formObj3.disableItem(name); 
						else
								formObj3.enableItem(name);
					}
				}
			}
		}
	}); 
}
//승신 샘플 처리
function findLabSmpGrid(){	
	var findUrl3 = parameters14('C108000110_Grid_2','C108000110_Grid_3','findLabSmp','basicGridData.do');
	items['C108000110_Grid_3'].loadData(findUrl3,loadAfterEvent3);
}
function loadAfterEvent3(){
	uiCommon.progressOff(parent);

	var grid3Obj = items['C108000110_Grid_3'].getDhxGrid();
	
	if ( grid3Obj.getRowsNum() > 0 ) { 
		grid3Obj.selectRow(0,true);
	}
	
	items['C108000110_Form_4'].setItemValue("CMP_SIM_CNT",grid3Obj.getRowsNum());
	
  	return true;
}
//Lab개발 샘플관리 link
function lab_simple_call(){
	var grid2Obj = items['C108000110_Grid_2'].getDhxGrid();
	var prdDevCmpBomNo = "";

	if (grid2Obj.getSelectedRowId() != null)
		prdDevCmpBomNo = items['C108000110_Grid_2'].getCellValue(grid2Obj.getSelectedRowId(),grid2Obj.getColIndexById("PRD_DEV_CMP_BOM_NO"));
	
	parent.newRemoveOpenTab('M205040050',
								'DEV_NO=' + prdDevCmpBomNo);	
}
//샘플승인 처리 link
function cnf_simple_call(){
	var grid2Obj = items['C108000110_Grid_2'].getDhxGrid();
	var prdDevCmpBomNo = "";

	if (grid2Obj.getSelectedRowId() != null)
		prdDevCmpBomNo = items['C108000110_Grid_2'].getCellValue(grid2Obj.getSelectedRowId(),grid2Obj.getColIndexById("PRD_DEV_CMP_BOM_NO"));
	
	parent.newRemoveOpenTab('M205040020',
								'DEV_NO=' + prdDevCmpBomNo);	
}
//칼라 색상개발 link
function clr_dev_call(){
	var grid1Obj = items['C108000110_Grid_1'].getDhxGrid();
	var prdDevNo = "";

	if (grid1Obj.getSelectedRowId() != null)
		prdDevNo = items['C108000110_Grid_1'].getCellValue(grid1Obj.getSelectedRowId(),grid1Obj.getColIndexById("PRD_DEV_NO"));
	
	parent.newRemoveOpenTab('C108000130',
								'PRD_DEV_NO=' + prdDevNo);	
}

function removeSmp(){
	var grid3 = items['C108000110_Grid_3'];
	var grid3Obj = grid3.getDhxGrid();
	
	var curRowId = grid3Obj.getSelectedRowId();

	if (curRowId != null) {
	    var smplNo = grid3.getCellValue(curRowId,grid3Obj.getColIndexById('SMPL_NO'));
		   if(isNull(smplNo)){	
		   	dhtmlx.alert("샘플 번호 누락");
		   	return;	
	    }
	    var prdDevCmpBomNo = grid3.getCellValue(curRowId,grid3Obj.getColIndexById('PRD_DEV_CMP_BOM_NO'));
	    if(isNull(prdDevCmpBomNo)){
	     	dhtmlx.alert("개발 번호 누락");
	    	return;	
	    }
		
		grid3.setUpdated(curRowId,"true","updated");
		
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"LAB샘플 연결 해제 하시겠습니까?",
			callback:function(val){
				if(val){					
					items['C108000110_Grid_3'].sendGrid('C108000110_Grid_3','removeSmp');
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
<body style="height:1200px">
	<!-- <div id="C108000110_Form_1"	style="position:absolute; height:28px; width:981px; left:0px; top:0px;">
	</div>	
	<div id="C108000110_Grid_1"	style="position:absolute; height:90px; width:975px; left:0px; top:32px;">
	</div>
	<div id="C108000110_Form_2"	style="position:absolute; height:121px; width:981px; left:0px; top:122px;">
	</div>
	<div id="C108000110_Menu_1"	style="position:absolute; height:28px; width:977px; left:1px; top:243px;">
	</div>
	<div id="C108000110_Grid_2"	style="position: absolute; height:90px; width: 977px; left: 0px; top: 271px;">
	</div>
	<div id="C108000110_Form_3"	style="position:absolute; height:203px; width:981px; left:0px; top:322px;">
	</div>
	<div id="C108000110_messagebox"	style="position: absolute; height: 19px; width: 977px; left: 1px; top: 567px;">
	</div> -->
</body>
</html>
<script>//<![CDATA[
	ui.initializeDHTMLX();          
	//items['C105000020_Form_1'].setBackgroundColor("#FFFFFF");
	//items['C108000110_Menu_1'].setBackgroundColor("#FFFFFF");
	items["C108000110_Grid_1"].rowSelected(onSelectGrid1);
	items["C108000110_Grid_2"].rowSelected(onSelectGrid2);
	var onXleForm = items['C108000110_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000110_Grid_1'].onXLEEvent(onGridLoadFunction);	
    var onXleForm2 = items['C108000110_Form_2'].onXLEEvent(onFormLoadFunction2);
    var onXleGrid2 = items['C108000110_Grid_2'].onXLEEvent(onGridLoadFunction2);
	var onXleForm3 = items['C108000110_Form_3'].onXLEEvent(onFormLoadFunction3);
	var onXleGrid3 = items['C108000110_Grid_3'].onXLEEvent(onGridLoadFunction3);
//]]>
</script>