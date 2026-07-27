<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME      :  C104000080pop01.jsp
 * VERSION           :  V1.0
 * DESCRIPTION       :  C104000080 항목 검색 LOV 팝업 (빈도 + 화면/탭)
 * DESIGNER NAME     :  서재섭
 * DEVELOPER NAME    :  서재섭
 * CREATE DATE       :  2026.06.30
 *
 * Date         Ver       Name       Description
 * -----------------------------------------------------------------
 * 2026.06.30   V1.0      서재섭      Initial Version
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String START_DATE = request.getParameter("START_DATE") != null ? request.getParameter("START_DATE") : "";
	String END_DATE   = request.getParameter("END_DATE")   != null ? request.getParameter("END_DATE")   : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>항목 검색</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js"></script>
<script type="text/javascript" src="./js/c10.ui.js"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();

var Form_1 = {"itemType":"form","renderTo":"C104000080pop01_Form_1","xml":".\/header\/kr\/C104000080pop01\/C104000080pop01_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000080pop01_Grid_1","service":"C104000080pop01-service"};
var Grid_1 = {"itemType":"grid","renderTo":"C104000080pop01_Grid_1","xml":".\/header\/kr\/C104000080pop01\/C104000080pop01_Grid_1.xml","rowCnt":"15","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000080pop01_Form_1","service":"C104000080pop01-service"};

var initLayout = {
	"programId": "C104000080pop01",
	"itemType": "layout", "messageBox": true, "dirType": "row", "childSize": "35,", "splitter": false,
	"components": [Form_1, Grid_1]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

function find(eventName, formDivObj, referenceItem){
	var findUrl = uiCommon.parameters(formDivObj, referenceItem, eventName);
	items[referenceItem].loadData(findUrl);
}

// 닫기 — 표준 패턴: parent.winObj.winClose()
function winClose(){
	if(typeof(parent.winObj) !== 'undefined' && parent.winObj){
		parent.winObj.winClose();
	}else if(typeof(parent.tabClose) === 'function'){
		parent.tabClose();
	}
}

function findMessage(referenceItem){
	uiCommon.message("C104000080pop01_messagebox", referenceItem.getUserData("","appMsg"));
	return true;
}

function onGridContextMenuClick(id, gridObj, menuObj){
	if("copy_row" == id){
		var rowId = gridObj.getSelectedRowId();
		var cellInd = gridObj.getSelectedCellIndex();
		if(rowId !== null){
			gridObj.cellToClipboard(rowId, cellInd);
		}
	}
	if("excel_grid" == id){
		gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
	}
}

// 행 더블클릭 → 부모에 값 전달
function onRowDblClickedItem(rowId){
	var gridObj = items['C104000080pop01_Grid_1'].getDhxGrid();
	var colNm      = gridObj.cells(rowId, gridObj.getColIndexById("COLUMN_NM")).getValue();
	var colComment = gridObj.cells(rowId, gridObj.getColIndexById("COLUMN_COMMENT")).getValue();
	if(parent && typeof parent.setSelectedItem == "function"){
		parent.setSelectedItem(colNm, colComment);
	}
}

var loadForm_yn = "N";
var loadGrid_yn = "N";

function onLoadForm(){
	loadForm_yn = "Y";
	items['C104000080pop01_Form_1'].getDhxForm().detachEvent(onXleForm);
	tryFirstSearch();
}

function onLoadGrid(){
	loadGrid_yn = "Y";
	items['C104000080pop01_Grid_1'].getDhxGrid().attachEvent("onRowDblClicked", onRowDblClickedItem);
	items['C104000080pop01_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
	tryFirstSearch();
}

function tryFirstSearch(){
	if(loadForm_yn == "Y" && loadGrid_yn == "Y"){
		find('find', 'C104000080pop01_Form_1', 'C104000080pop01_Grid_1');
	}
}
//]]>
</script>
</head>
<body>
</body>
</html>
<script>
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleForm = items["C104000080pop01_Form_1"].onXLEEvent(onLoadForm);
	var onXleGrid = items["C104000080pop01_Grid_1"].onXLEEvent(onLoadGrid);
//]]>
</script>
