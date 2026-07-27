<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME	    :  C104000020POP_HST.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과 변경이력 조회 팝업 (glue.3x.ui)
 * DESIGNER NAME    :  서재섭
 * DEVELOPER NAME   :  서재섭
 * CREATE DATE      :  2026.05.11
 *
 * Date         Ver       Name       Description
 * -----------------------------------------------------------------
 * 2026.05.11   V1.0      서재섭      Initial Version
 * 2026.05.13   V1.1      서재섭      glue.3x.ui 전환
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ORD_NO = request.getParameter("ORD_NO") != null ? request.getParameter("ORD_NO") : "";
	String ORD_LN = request.getParameter("ORD_LN") != null ? request.getParameter("ORD_LN") : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>품질설계결과 변경이력</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();

var Form_1 = {"itemType":"form","renderTo":"C104000020POP_HST_Form_1","xml":".\/header\/kr\/C104000020POP_HST\/C104000020POP_HST_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020POP_HST_Grid_1","service":"C104000020POP_HST-service"};
var Grid_1 = {"itemType":"grid","renderTo":"C104000020POP_HST_Grid_1","xml":".\/header\/kr\/C104000020POP_HST\/C104000020POP_HST_Grid_1.xml","rowCnt":"10","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020POP_HST_Form_1","service":"C104000020POP_HST-service"};

var initLayout = {
	"programId": "C104000020POP_HST",
	"itemType": "layout", "messageBox": true, "dirType": "row", "childSize": "30,", "splitter": false,
	"components": [Form_1, Grid_1]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

function find(eventName, formDivObj, referenceItem){
	var formObj = items["C104000020POP_HST_Form_1"].getDhxForm();
	if(formObj.getItemValue("ORD_NO") == ""){
		dhtmlx.alert("주문번호가 없습니다.");
		return;
	}
	if(formObj.getItemValue("ORD_LN") == ""){
		dhtmlx.alert("주문행번이 없습니다.");
		return;
	}
	var findUrl = uiCommon.parameters(formDivObj, referenceItem, eventName);
	items[referenceItem].loadData(findUrl);
}

function findMessage(referenceItem){
	uiCommon.message("C104000020POP_HST_messagebox", referenceItem.getUserData("","appMsg"));
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

var loadForm_yn = "N";
var loadGrid_yn = "N";

function onLoadForm(){
	console.log("[POP_HST] onLoadForm fired");
	loadForm_yn = "Y";
	load_find();
	items['C104000020POP_HST_Form_1'].getDhxForm().detachEvent(onXleForm);
}

function onLoadGrid(){
	console.log("[POP_HST] onLoadGrid fired");
	loadGrid_yn = "Y";
	load_find();
	items['C104000020POP_HST_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}

function load_find(){
	console.log("[POP_HST] load_find called, loadForm_yn=" + loadForm_yn + ", loadGrid_yn=" + loadGrid_yn);
	if(loadForm_yn == "Y" && loadGrid_yn == "Y"){
		console.log("[POP_HST] both ready, ORD_NO=<%=ORD_NO%>, ORD_LN=<%=ORD_LN%>");
		items['C104000020POP_HST_Form_1'].setItemValue("ORD_NO", "<%=ORD_NO%>");
		items['C104000020POP_HST_Form_1'].setItemValue("ORD_LN", "<%=ORD_LN%>");
		var findUrl = uiCommon.parameters("C104000020POP_HST_Form_1", "C104000020POP_HST_Grid_1", "find");
		console.log("[POP_HST] findUrl=" + findUrl);
		items['C104000020POP_HST_Grid_1'].loadData(findUrl);
		console.log("[POP_HST] loadData called");
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
	var onXleForm = items["C104000020POP_HST_Form_1"].onXLEEvent(onLoadForm);
	var onXleGrid = items["C104000020POP_HST_Grid_1"].onXLEEvent(onLoadGrid);
//]]>
</script>
