<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000010.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  제품개발진행 등록 및 조회
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.05.03
 *       
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
제품개발 등록 및 조회
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">

//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C108000010_Form_1","xml":".\/header\/kr\/C108000010\/C108000010_Form_1.xml","url":"basicGridData.do","referenceItem":"C108000010_Grid_1","service":"C108000010-service","actionType":"find","security":"true"},' +
//       '{"itemType":"menu","renderTo":"C108000010_Menu_1","xml":".\/header\/kr\/C108000010\/C108000010_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000010_Grid_1","service":"C108000010-service"},' +
//       '{"itemType":"grid","renderTo":"C108000010_Grid_1","xml":".\/header\/kr\/C108000010\/C108000010_Grid_1.xml","rowCnt":"18","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C108000010_Form_1","service":"C108000010-service","actionType":"save"},' +
//       '{"itemType":"messagebox","renderTo":"C108000010_messagebox","xml":".\/header\/kr\/C108000010\/C108000010_messagebox.xml","service":"C108000010-service"}' +
//    ']';
// var initConfig = JSON.parse(pageConfiguration);
var Menu_1 = {"itemType":"menu","renderTo":"C108000010_Menu_1","xml":".\/header\/kr\/C108000010\/C108000010_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000010_Grid_1","service":"C108000010-service"};
var Form_1 = {"itemType":"form","renderTo":"C108000010_Form_1","xml":".\/header\/kr\/C108000010\/C108000010_Form_1.xml","url":"gridC10Data.do","referenceItem":"C108000010_Grid_1","service":"C108000010-service","actionType":"find","security":"true"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000010_Grid_1","xml":".\/header\/kr\/C108000010\/C108000010_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C108000010_Form_1","service":"C108000010-service","actionType":"save"};

Grid_1.menu = Menu_1;
//Form_2.arrow = true;

var initLayout = 
{
	"programId":"C108000010", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"65", "splitter":true, "components": 
 	[
	 	Form_1,
		Grid_1,
 	]
};
    
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var formLoadFlag = false;
var LNK_PRD_DEV_NO = 'PRD_DEV_NO';
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var formObj = items['C108000010_Form_1'].getDhxForm();
	var form = items['C108000010_Form_1'];
	
	var startDt = formObj.getInput("REQ_RGS_DH_FR").value;
	var endDt = formObj.getInput("REQ_RGS_DH_TO").value;   

	if(isNull(startDt) && !isNull(endDt)){
		dhtmlx.alert("개발요청 시작일을 입력해주세요.");
		form.setItemFocus("REQ_RGS_DH_FR");
		return;
	}else if(!isNull(startDt) && isNull(endDt)){
		dhtmlx.alert("개발요청 종료일을 입력해주세요.");
		form.setItemFocus("REQ_RGS_DH_TO");
		return;
	}else if(isNull(startDt) && isNull(endDt)){
		dhtmlx.alert("개발요청일는 입력해야 합니다.");
		form.setItemFocus("REQ_RGS_DH_FR");
		return;
	}else{
		var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
					items[referenceItem].loadData(findUrl);
	}
}

function save(eventName,formDivObj,referenceItem){
	var gridObj = items['C108000010_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var statusCnt = 0;
	for(var i=0; i< grid_cnt; i++){
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		if(row_status == 'deleted'){
			statusCnt++;
			var cellVal = items['C108000010_Grid_1'].getCellValue(gridObj.getRowId(i),gridObj.getColIndexById("DEV_PRG_CD"));
			if( cellVal.substring(0,2) != "20"){
				dhtmlx.alert("진도코드가 20-개발요청 등록 일때만 삭제 가능합니다.");
				items['C108000010_Grid_1'].clearDataProcess();
				return;
			}
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
				items[referenceItem].sendGrid(referenceItem,eventName);
			return;
			}
		}
	});  
}
//링크 이벤트 처리
function doLink(val,rId,cInd){
	//관제 코일 상세 정보 페이지 링크
	if(cInd == items['C108000010_Grid_1'].getDhxGrid().getColIndexById(LNK_PRD_DEV_NO)) {
		parent.newRemoveOpenTab('C108000050',
								LNK_PRD_DEV_NO + '=' + val);
	}
	//MO번호 상세 정보 페이지 링크
	//else if(cInd == aGrid1[1].getColIndexById(LNK_EVT_COL_NM)) {}
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C108000010_Form_1',referenceItem,'find');
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
function onGridContextMenuClick(id,gridObj,menuObj){  	
    if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
    }
}

function onFormLoadFunction(){
	var formDhxObj   = items['C108000010_Form_1'].getDhxForm();
	var formObj   = items['C108000010_Form_1'];
	items['C108000010_Form_1'].setItemValue("REQ_RGS_DH_FR",firstDay());
	items['C108000010_Form_1'].setItemValue("REQ_RGS_DH_TO",uiCommon.getCurrentDate());
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	items['C108000010_Form_1'].getItem("REQ_RGS_DH_FR").setWeekStartDay(7);
	items['C108000010_Form_1'].getItem("REQ_RGS_DH_TO").setWeekStartDay(7);	
	
	formLoadFlag = true;

	items['C108000010_Form_1'].getDhxForm().detachEvent(onXleForm);
	
	var comboList = items['C108000010_Form_1'].getMasterCombos();
	comboList['DEV_PRG_CD'].readonly(true,false);
	ui.combo.master(comboList['DEV_PRG_CD'],'SZ0000','DEV_PRG_CD','totalValue=%,orderBy=value,displayType=all-code',function(){
		comboList['DEV_PRG_CD'].selectOption(0,true,true);
		comboList['DEV_PRG_CD'].readonly(true);
		comboList['DEV_PRG_CD'].setOptionHeight(200);		
	});
	
	comboList['COT_MTH'].readonly(true,false);
	ui.combo.master(comboList['COT_MTH'],'SZ0000','COT_MTH','totalValue=%,orderBy=value,displayType=all-code',function(){
		comboList['COT_MTH'].selectOption(0,true,true);
		comboList['COT_MTH'].readonly(true);
		comboList['COT_MTH'].setOptionHeight(200);
		comboList['COT_MTH'].setOptionWidth(200);
	});
	
}
function onGridLoadFunction(){
/* 	if(formLoadFlag){
		 find("find",'C108000010_Form_1',"C108000010_Grid_1");
	} */
	items['C108000010_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C108000010_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}

function onGridAfterUpdateFinishEvent(){
	refresh('C108000010_Grid_1');	
/* 	var gridObj = items['C108000010_Grid_1'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj.getRowId(i);
        items['C108000010_Grid_1'].setUpdated(rowID,false,""); 
	}
	items['C108000010_Grid_1'].clearDataProcess(); */
	// items['C106000020_Grid_1'].getDhxGrid().resetDataProcessor("updated");
}


function findMessage(referenceItem){
	uiCommon.message("messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}

function serchIcon_CUS_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C108000010_Form_1');\">";
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
}

function doImgPopUp1(rowIdx){
	
	C10_linkC108000010pop02();
	/*var gridObj = items["C108000010_Grid_1"].getDhxGrid();
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

function create(){
	var grid = items['C108000010_Grid_1'];
	var PRD_DEV_NO = "";
	var REQ_RGS_DH = "";
	var DEV_REQ_FILE = "";
	
	if(!isNull(grid.getSelectedRowId())){
		PRD_DEV_NO = grid.getDhxGrid().cells(grid.getSelectedRowId(),grid.getDhxGrid().getColIndexById("PRD_DEV_NO")).getValue();
		REQ_RGS_DH = grid.getDhxGrid().cells(grid.getSelectedRowId(),grid.getDhxGrid().getColIndexById("REQ_RGS_DH")).getValue();
		DEV_REQ_FILE  = grid.getDhxGrid().cells(grid.getSelectedRowId(),grid.getDhxGrid().getColIndexById("DEV_REQ_FILE")).getValue();
	} 
	winObj = new ui.window("popup","제품개발 등록","0","0","900","447","C108000010pop01.do?pageID=C108000010pop01&PRD_DEV_NO="+PRD_DEV_NO+"&DEV_REQ_FILE="+DEV_REQ_FILE );
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
	winObj.getDhxWindow().attachEvent("onClose", function(win){
		this.hide();
		return true;
		//winObj.unload();
		});
}
function cancel(){
	var gridObj = items['C108000010_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();	
	var statusCnt = 0;
	for(var i=0; i< grid_cnt; i++)
	{
		var row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		var checkVal  = items['C108000010_Grid_1'].getCellValue(gridObj.getRowId(i),gridObj.getColIndexById("PRD_DEV_CFM"));

		if(row_status == 'updated' && checkVal == '1')
		{	
			statusCnt++;
			var cellVal = items['C108000010_Grid_1'].getCellValue(gridObj.getRowId(i),gridObj.getColIndexById("DEV_PRG_CD"));
			if( cellVal.substring(0,2) == "90"){
			 	dhtmlx.alert("진도코드가 90-등록완료(종결)은 반려 불가능합니다.");
			 	items['C108000010_Grid_1'].clearDataProcess();
			 	return;
			}			
		}
    }
	
	if(statusCnt == 0 ){
		dhtmlx.alert("반려할 데이터가 없습니다.");
		return;
	}else{
		dhtmlx.confirm({
			title:"반려처리",
			ok:"확인", cancel:"취소",
			text: statusCnt + "건 반려 하시겠습니까?",
			callback:function(val){
				if(val){
					items['C108000010_Grid_1'].sendGrid('C108000010_Grid_1','cancel');
				}
			}
		});	
	}
}

function devCmp(){
	var gridObj = items['C108000010_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();	
	var statusCnt = 0;
	for(var i=0; i< grid_cnt; i++)
	{
		var row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		var checkVal  = items['C108000010_Grid_1'].getCellValue(gridObj.getRowId(i),gridObj.getColIndexById("PRD_DEV_CFM"));

		if(row_status == 'updated' && checkVal == '1')
		{	
			statusCnt++;
			var cellVal = items['C108000010_Grid_1'].getCellValue(gridObj.getRowId(i),gridObj.getColIndexById("DEV_PRG_CD"));
			if( cellVal.substring(0,2) != "51"){
			 	dhtmlx.alert("진도코드가 51-승인대기 상태에서만 가능합니다.");
			 	items['C108000010_Grid_1'].clearDataProcess();
			 	return;
			}			
		}
    }
	
	if(statusCnt == 0 ){
		dhtmlx.alert("반려할 데이터가 없습니다.");
		return;
	}else{
		dhtmlx.confirm({
			title:"개발완료",
			ok:"확인", cancel:"취소",
			text: statusCnt + "건 개발완료 하시겠습니까?",
			callback:function(val){
				if(val){
					items['C108000010_Grid_1'].sendGrid('C108000010_Grid_1','devCmp');
				}
			}
		});	
	}
}

function saveCmp(){
	var gridObj = items['C108000010_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();	
	var statusCnt = 0;
	for(var i=0; i< grid_cnt; i++)
	{
		var row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		var checkVal  = items['C108000010_Grid_1'].getCellValue(gridObj.getRowId(i),gridObj.getColIndexById("PRD_DEV_CFM"));

		if(row_status == 'updated' && checkVal == '1')
		{	
			statusCnt++;
			var cellVal = items['C108000010_Grid_1'].getCellValue(gridObj.getRowId(i),gridObj.getColIndexById("DEV_PRG_CD"));
			if( cellVal.substring(0,2) != "60"){
			 	dhtmlx.alert("진도코드가 60-개발완료 상태에서만 가능합니다.");
			 	items['C108000010_Grid_1'].clearDataProcess();
			 	return;
			}			
		}
    }
	
	if(statusCnt == 0 ){
		dhtmlx.alert("반려할 데이터가 없습니다.");
		return;
	}else{
		dhtmlx.confirm({
			title:"등록완료",
			ok:"확인", cancel:"취소",
			text: statusCnt + "건 등록완료 하시겠습니까?",
			callback:function(val){
				if(val){
					items['C108000010_Grid_1'].sendGrid('C108000010_Grid_1','saveCmp');
				}
			}
		});	
	}
}

function C10_linkC108000010pop02(){
	
	var grid = items['C108000010_Grid_1'];
	var PRD_DEV_NO = ""
	
	if(!isNull(grid.getSelectedRowId())){
		PRD_DEV_NO = grid.getDhxGrid().cells(grid.getSelectedRowId(),grid.getDhxGrid().getColIndexById("PRD_DEV_NO")).getValue();		
			winObj = new ui.window("coilImgRegPopWin","파일 등록","0","0","465","405", "C108000010pop02.jsp?"
					+ "IMG_RGS_TP=1"
					+ "&PRD_DEV_NO=" + PRD_DEV_NO
					+ "&PRD_DEV_SEQ_NO=0");
			winObj.setButtonDisable("park,minmax1");
			winObj.setModal();
	}else {
		dhtmlx.alert("접수요청 번호가 없습니다.");
	}
}
//]]>
</script>
</head>
<body>
<!-- <div id="C108000010_Form_1" style="position:absolute;height:71px;width:981px;left:0px;top:0px;">
</div>
<div id="C108000010_Menu_1" style="position:absolute;height:25px;width:981px;left:0px;top:73px;">
</div>
<div id="C108000010_Grid_1" style="position:absolute;height:467px;width:977px;left:0px;top:97px;">
</div>
<div id="C108000010_messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div> -->
</body>
</html>
<script>
//<![CDATA[
	ui.initializeDHTMLX();
	//items['C108000010_Menu_1'].setBackgroundColor("#FFFFFF");
	var onXleForm = items['C108000010_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000010_Grid_1'].onXLEEvent(onGridLoadFunction);
//]]>
</script>