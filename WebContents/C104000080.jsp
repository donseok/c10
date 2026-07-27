<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME      :  C104000080.jsp
 * VERSION           :  V1.0
 * DESCRIPTION       :  품질설계결과 변경이력 분석 (전체 주문 대상)
 * DESIGNER NAME     :  서재섭
 * DEVELOPER NAME    :  서재섭
 * CREATE DATE       :  2026.06.29
 *
 * Date         Ver       Name       Description
 * -----------------------------------------------------------------
 * 2026.06.29   V1.0      서재섭      Initial Version
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>품질설계결과 변경이력 분석</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js"></script>
<script type="text/javascript" src="./js/c10.ui.js"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();

var Form_1 = {"itemType":"form","renderTo":"C104000080_Form_1","xml":".\/header\/kr\/C104000080\/C104000080_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000080_Grid_1","service":"C104000080-service","actionType":"find","security":"true"};
var Grid_1 = {"itemType":"grid","renderTo":"C104000080_Grid_1","xml":".\/header\/kr\/C104000080\/C104000080_Grid_1.xml","rowCnt":"25","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000080_Form_1","service":"C104000080-service"};

var initLayout = {
	"programId": "C104000080",
	"itemType": "layout", "messageBox": true, "dirType": "row", "childSize": "35,", "splitter": false,
	"components": [Form_1, Grid_1]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

// 화면/탭 콤보 정적 옵션
var chgTxtOptions = [
	['all',             '전체'],
	['C104000020TAB01', '공통'],
	['C104000020TAB02', '성분'],
	['C104000020TAB03', '재질'],
	['C104000020TAB04', '인수도'],
	['C104000020TAB05', '용융도금-제조표준'],
	['C104000020TAB06', '전기도금-제조표준'],
	['C104000020TAB07', '칼라제조사양'],
	['C104000020TAB08', '통과공정'],
	['C104000020TAB09', '후공정-제조표준']
];

function find(eventName, formDivObj, referenceItem){
	var formObj = items["C104000080_Form_1"].getDhxForm();
	var sDate = formObj.getItemValue("START_DATE");
	var eDate = formObj.getItemValue("END_DATE");
	if(sDate == "" || eDate == ""){
		dhtmlx.alert("수정일자를 입력하세요.");
		return;
	}
	if(sDate > eDate){
		dhtmlx.alert("수정일자 범위가 올바르지 않습니다.");
		return;
	}
	var findUrl = uiCommon.parameters(formDivObj, referenceItem, eventName);
	items[referenceItem].loadData(findUrl);
}

function excelExport(){
	var gridObj = items['C104000080_Grid_1'].getDhxGrid();
	if(gridObj.getRowsNum() == 0){
		dhtmlx.alert("출력할 데이터가 없습니다.");
		return;
	}
	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
}

function findMessage(referenceItem){
	uiCommon.message("C104000080_messagebox", referenceItem.getUserData("","appMsg"));
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

// 항목 검색 팝업
var winObj;
function searchItem(){
	winObj = new ui.window("itempop", "항목 검색", "0", "0", "780", "560", "C104000080pop01.jsp");
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}

// 항목 선택 초기화
function clearItem(){
	items['C104000080_Form_1'].setItemValue("COLUMN_NM_NM", "전체");
	items['C104000080_Form_1'].setItemValue("COLUMN_NM", "all");
}

// 팝업에서 호출되는 콜백 (행 더블클릭 시)
function setSelectedItem(colNm, colComment){
	items['C104000080_Form_1'].setItemValue("COLUMN_NM_NM", colComment);
	items['C104000080_Form_1'].setItemValue("COLUMN_NM",    colNm);
	if(winObj){
		try{ winObj.winClose(); }catch(e){}
		winObj = null;
	}
}

function onLoadForm(){
	// 기본 날짜: 7일 전 ~ 오늘
	items['C104000080_Form_1'].setItemValue("START_DATE", getCurrentMinusDay('-', 7, 'YYYYMMDD'));
	items['C104000080_Form_1'].setItemValue("END_DATE",   uiCommon.getCurrentDate());

	items['C104000080_Form_1'].getItem("START_DATE").setWeekStartDay(7);
	items['C104000080_Form_1'].getItem("END_DATE").setWeekStartDay(7);

	var comboList = items['C104000080_Form_1'].getMasterCombos();

	// 화면/탭 콤보 (정적 옵션)
	comboList["CHG_TXT"].addOption(chgTxtOptions);
	comboList["CHG_TXT"].selectOption(0, true, true);
	comboList["CHG_TXT"].readonly(true);
	comboList["CHG_TXT"].setOptionHeight(220);

	// 항목 input 초기값
	items['C104000080_Form_1'].setItemValue("COLUMN_NM_NM", "전체");
	items['C104000080_Form_1'].setItemValue("COLUMN_NM",    "all");

	items['C104000080_Form_1'].getDhxForm().detachEvent(onXleForm);
}

function onLoadGrid(){
	var gridObj = items['C104000080_Grid_1'].getDhxGrid();
	// 셀 hover 시 잘린 값 전체를 브라우저 기본 툴팁으로 표시
	gridObj.attachEvent("onMouseOver", function(rId, cInd){
		try{
			var cellObj = gridObj.cellById(rId, cInd);
			if(cellObj && cellObj.cell){
				var val = cellObj.getValue();
				cellObj.cell.title = (val == null) ? "" : String(val);
			}
		}catch(e){}
		return true;
	});
	gridObj.detachEvent(onXleGrid);
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
	var onXleForm = items["C104000080_Form_1"].onXLEEvent(onLoadForm);
	var onXleGrid = items["C104000080_Grid_1"].onXLEEvent(onLoadGrid);
//]]>
</script>
