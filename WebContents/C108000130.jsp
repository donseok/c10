<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000130.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  색상 개발
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.06.24
 *
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String PRD_DEV_NO = request.getParameter("PRD_DEV_NO") != null ? request.getParameter("PRD_DEV_NO") : "";
	
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
<title>색상개발</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">

//<![CDATA[
var items = new Array();  //public dhtmlx component array
/* var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C108000130_Form_1","xml":".\/header\/kr\/C108000130\/C108000130_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000130_Grid_1","service":"C108000130-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C108000130_Grid_1","xml":".\/header\/kr\/C108000130\/C108000130_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000130_Grid_1","service":"C108000130-service","actionType":"save"},' +
      '{"itemType":"menu","renderTo":"C108000130_Menu_1","xml":".\/header\/kr\/C108000130\/C108000130_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000130_Grid_1","service":"C108000130-service"},' +
      '{"itemType":"form","renderTo":"C108000130_Form_2","xml":".\/header\/kr\/C108000130\/C108000130_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000130_Grid_1","service":"C108000130-service","actionType":"find"},' +      
      '{"itemType":"messagebox","renderTo":"C108000130_messagebox","xml":".\/header\/kr\/C108000130\/C108000130_messagebox.xml","service":"C108000130-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	  */
var Menu_1 = {"itemType":"menu","renderTo":"C108000130_Menu_1","xml":".\/header\/kr\/C108000130\/C108000130_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000130_Grid_1","service":"C108000130-service"};
var Form_1 = {"itemType":"form","renderTo":"C108000130_Form_1","xml":".\/header\/kr\/C108000130\/C108000130_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000130_Grid_1","service":"C108000130-service","actionType":"find","security":"true"};
var Form_2 = {"itemType":"form","renderTo":"C108000130_Form_2","xml":".\/header\/kr\/C108000130\/C108000130_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000130_Grid_1","service":"C108000130-service","actionType":"find"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000130_Grid_1","xml":".\/header\/kr\/C108000130\/C108000130_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000130_Grid_1","service":"C108000130-service","actionType":"save"};

Grid_1.menu = Menu_1;
Form_2.header = "*[색상개발]";
Form_2.arrow = true;

var initLayout = 
{
	"programId":"C108000130", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"35", "splitter":false, "components": 
 	[
	 	Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"350", "splitter":true, "components": 
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
	findClrDevGrid();
}
function save(eventName,formDivObj,referenceItem){

	var grid = items[referenceItem];
	var gridObj = items[referenceItem].getDhxGrid();
	var prdDevNo = items[formDivObj].getItemValue("PRD_DEV_NO");
	var clrDevChrUid = items[formDivObj].getItemValue("CLR_DEV_CHR_UID");
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
	      	grid.setCellValue(gridObj.getRowId(i),gridObj.getColIndexById('CLR_DEV_CHR_UID'), clrDevChrUid);
	      	var clrDevChrUidChk  = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('CLR_DEV_CHR_UID'));
	      	if(isNull(clrDevChrUidChk)){
	      		dhtmlx.alert("개발업체는 필수 입력입니다.");
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

function findClrDevGrid(){
	var prdDevNo = items['C108000130_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		dhtmlx.alert("개발 번호는 필수 입력입니다.");
		items['C108000130_Form_1'].setItemFocus("PRD_DEV_NO");
		return;
	}
	var findUrl = uiCommon.parameters("C108000130_Form_1","C108000130_Grid_1","find");
	items['C108000130_Grid_1'].loadData(findUrl,  loadAfterEvent);
}

function bindingFormToGrid(value, text) {
	
	if(value == 'CLR_DEV_DH')
		text = items['C108000130_Form_2'].getItemValue('CLR_DEV_DH');
	
	var grid = items['C108000130_Grid_1'];
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
    findClrDevGrid();
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
	var form2 = items['C108000130_Form_2'];
	var formObj2 = form2.getDhxForm();
	if(formObj2.isLocked()){
		formObj2.unlock();
		var rsnTp = form2.getItemValue("RSN_TP");
		onFormRsnTpEnable(rsnTp);
	} else {
		formObj2.lock();
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
	var form   = items['C108000130_Form_1'];
	var formDhxObj = form.getDhxForm();
	
	if(!isNull("<%=PRD_DEV_NO%>")){
		form.setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
	}
	formLoadFlag = true;
	
	var param = "ServiceName=C108000230-service&userChk=1&SMTL_SLP_CD="+<%=userNo%>+"&column-info=SMTL_SLP_CD,SMTL_SLP_NM";
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell");
	if(cells.length == 0) 
		 formDhxObj.showItem('CLR_DEV_CHR_UID');
	else{
		 form.setItemValue('CLR_DEV_CHR_UID', <%=userNo%>);
		 formDhxObj.hideItem('CLR_DEV_CHR_UID');  
	}
	
	formDhxObj.detachEvent(onXleForm);
}
function onGridLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
		findClrDevGrid();  
	}
	
	items['C108000130_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C108000130_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onSelectGrid(){
	var grid = items['C108000130_Grid_1'];
	var gridObj = grid.getDhxGrid();
	var form2 = items['C108000130_Form_2']
	var formObj2 = form2.getDhxForm();
		
	var rowStatus =  gridObj.getUserData(grid.getRowSelectedId(),"!nativeeditor_status");
	//grid.getDhxDataProcess().getState(grid.getRowSelectedId())
	if( rowStatus !== 'inserted') {
		formObj2.lock();
	}
	// 신규 추가된 row일 경우 (행추가)
	else {
		formObj2.unlock();  //폼 에디트 모드로 변경
		var rsnTp = form2.getItemValue("RSN_TP");
		onFormRsnTpEnable(rsnTp);
	}
}
function onFormLoadFunction2(){
	
	var formObj2 = items['C108000130_Form_2'].getDhxForm();
	formObj2.bind(items['C108000130_Grid_1'].getDhxGrid());

	//Form Input값 변경시 발생 이벤트
	formObj2.attachEvent('onInputChange', function(name, value, form) {
		bindingFormToGrid(name, value);
	 	if(name == "RSN_TP")
	 		onFormRsnTpEnable(value);
	});
	//Form Combo값 변경시 발생 이벤트
	formObj2.attachEvent('onChange', function(value, text) {
		bindingFormToGrid(value, text);
		if(value == "RSN_TP")
	 		onFormRsnTpEnable(text);
	});

	var comboList = items['C108000130_Form_2'].getMasterCombos();

	comboList['MPR_BAS_PNCL_HRDN'].readonly(true,false);
	ui.combo.master(comboList['MPR_BAS_PNCL_HRDN'],'SZ0000','MPR_BAS_PNCL_HRDN','totalValue=,orderBy=value,displayType=code-code',function(){
		//comboList['MPR_BAS_PNCL_HRDN'].selectOption(0,true,true);
		comboList['MPR_BAS_PNCL_HRDN'].readonly(true);
		comboList['MPR_BAS_PNCL_HRDN'].setOptionHeight(120);
	});

	comboList['CLR_BND_TST_STD_CD'].readonly(true,false);
	ui.combo.master(comboList['CLR_BND_TST_STD_CD'],'SZ0000','CLR_BND_TST_STD_CD','totalValue=,orderBy=value,displayType=code-code',function(){
		//comboList['CLR_BND_TST_STD_CD'].selectOption(0,true,true);
		comboList['CLR_BND_TST_STD_CD'].readonly(true);
		comboList['CLR_BND_TST_STD_CD'].setOptionHeight(120);
	});

	comboList['TEX_PTC_TP'].readonly(true,false);
	ui.combo.master(comboList['TEX_PTC_TP'],'SZ0000','TEX_PTC_TP','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['TEX_PTC_TP'].selectOption(0,true,true);
		comboList['TEX_PTC_TP'].readonly(true);
		comboList['TEX_PTC_TP'].setOptionHeight(120);
	});

	comboList['TLP_YN'].readonly(true,false);
	ui.combo.master(comboList['TLP_YN'],'SZ0000','TLP_YN','totalValue=,orderBy=value,displayType=all-code',function(){
		//comboList['TLP_YN'].selectOption(0,true,true);
		comboList['TLP_YN'].readonly(true);
		comboList['TLP_YN'].setOptionHeight(120);
	});
	
	onFormRsnTpEnable('');

	formObj2.detachEvent(onXleForm2);
}

/* function serchIcon_PNT_CMP_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('PNT_CMP_CD','SZ0000','CLR_DEV_CHR_UID','C108000130_Form_2');\">";
} */
function serchIcon_RSN_TP(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('RSN_TP','SZ0000','RSN_TP','C108000130_Form_2');\">";
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
	if(formId == "C108000130_Form_2") {
		bindingFormToGrid(target, code);
		if(target == "RSN_TP")
	 		onFormRsnTpEnable(code);
	}
}
//
function onGridAfterUpdateFinishEvent(){
	refresh('C108000130_Grid_1');
}

function loadAfterEvent(){
	uiCommon.progressOff(parent);

	var grid1Obj = items['C108000130_Grid_1'].getDhxGrid();
		
	if ( grid1Obj.getRowsNum() > 0 ) {
		items['C108000130_Grid_1'].getDhxGrid().selectRow(0,true);;
	}

	findMessage(grid1Obj);
  	return true;
}
//수지 타입별 비활성 처리
function onFormRsnTpEnable(rsnTp){
	var formObj2 = items['C108000130_Form_2'].getDhxForm();	
	formObj2.forEachItem(function(name){
		if(name.substring(0,5) != "BLOCK") {
			if(name == 'CLR_DEV_DH' || name == 'RSN_TP') {
				formObj2.enableItem(name);
			} else {
				if (rsnTp == '' || isNull(rsnTp)) {
					formObj2.disableItem(name);
				} else {
					if(rsnTp.substring(0,1) == 'I') {
						if(name == 'CLR_DEV_NO' || name == 'CLR_DEV_CHR_UID' || name == 'LUS_RT_CD' || name == 'PMT'
						|| name == 'THR_CD' || name == 'WK_VISCO' || name == 'QT_L' || name == 'QT_A' || name == 'QT_B')
							formObj2.disableItem(name);
						else
							formObj2.enableItem(name);								
					} else {
						formObj2.enableItem(name);
					}
				}
			}
		}
	}); 
}
//]]>
</script>
</head>
<body>
<!--<div id="C108000130_Form_1"	style="position:absolute; height:28px; width:981px; left:0px; top:0px;">
	</div>
	<div id="C108000130_Menu_1"	style="position:absolute; height:28px; width:977px; left:1px; top:32px;">
	</div>
	<div id="C108000130_Grid_1"	style="position:absolute; height:184px; width:975px; left:0px; top:61px;">
	</div>
	<div id="C108000130_Form_2"	style="position:absolute; height:121px; width:981px; left:0px; top:245px;">
	</div>	
	<div id="C108000130_messagebox"	style="position: absolute; height: 19px; width: 977px; left: 1px; top: 567px;">
	</div> -->
</body>
</html>
<script>//<![CDATA[
	ui.initializeDHTMLX();          
	//items['C108000130_Menu_1'].setBackgroundColor("#FFFFFF");
	//items['C108000130_Form_2'].setBackgroundColor("#C8FAC8");
	items["C108000130_Grid_1"].rowSelected(onSelectGrid);
	var onXleForm = items['C108000130_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000130_Grid_1'].onXLEEvent(onGridLoadFunction);	
    var onXleForm2 = items['C108000130_Form_2'].onXLEEvent(onFormLoadFunction2);
//]]>
</script>