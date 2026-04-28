<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000240pop02.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  칼라개발의뢰 첨부파일 업로드
 * DESIGNER NAME    :  SJS
 * DEVELOPER NAME   :  SJS
 * CREATE DATE      :  2026.03.13
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2026.03.13     V1.0      SJS        최초작성
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String DEV_ID       = request.getParameter("DEV_ID")       != null ? request.getParameter("DEV_ID") : "";
String parent_item  = request.getParameter("parent_item")  != null ? request.getParameter("parent_item") : "";
String IMG_RGS_TP   = request.getParameter("IMG_RGS_TP")   != null ? request.getParameter("IMG_RGS_TP") : "1";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
칼라개발의뢰 첨부파일
</title>
<link rel="stylesheet" type="text/css" href="./dhtmlx/codebase/dhtmlxvault.css" />
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript" src="./dhtmlx/codebase/dhtmlxvault.js"></script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' +
      '{"itemType":"grid","renderTo":"C108000240pop02_Grid_1","xml":".\/header\/kr\/C108000240pop02\/C108000240pop02_Grid_1.xml","rowCnt":"2","vertical":"true","url":"gridC10Data.do","contextmenu":"false","borderline":"true","pageset":"true","split":"0","referenceItem":"C108000240pop02_Form_1","service":"C108000240pop02-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C108000240pop02_MessageBox_1","xml":".\/header\/kr\/C108000240pop02\/C108000240pop02_MessageBox_1.xml","service":"C108000240pop02-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
function refresh(referenceItem){
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C108000240pop02_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);
}
function add(referenceItem){
   items[referenceItem].addRow();
}
function remove(referenceItem){
    items[referenceItem].removeRow();
}
function copy(referenceItem){
	items[referenceItem].copyRowContent();
}
function undo(referenceItem){
	items[referenceItem].undo();
}
function redo(referenceItem){
	items[referenceItem].redo();
}
function onGridContextMenuClick(id,gridObj,menuObj){
    var isChecked = menuObj.getCheckboxState(id);
    if("move_grid" == id){
        if(isChecked) gridObj.enableColumnMove(true);
        else gridObj.enableColumnMove(false);
    }
  	if("filter_grid" == id){
  		if(isChecked) gridObj.enableHeaderMenu();
  	}
  	if("editable_grid" == id){
  		if(isChecked) gridObj.setEditable(true);
  		else gridObj.setEditable(false);
  	}
  	if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
  	}
}
function findMessage(referenceItem){
	uiCommon.message("C108000240pop02_MessageBox_1",referenceItem.getUserData("","appMsg"));
  	return true;
}
var vault = null;
function onVaultLoad() {
	vault = new dhtmlXVaultObject();
	vault.setImagePath("/dhtmlx/codebase/imgs/");
	vault.setServerHandlers("_uploadHandler6.jsp", "_getInfoHandler.jsp", "_getIdHandler.jsp");

	vault.create("vault1");
	vault.setFormField("IMG_RGS_TP"      ,"<%=IMG_RGS_TP%>");
	vault.setFormField("IMG_RGS_FLAG"    ,"09");
	vault.setFormField("IMG_RGS_FLAG_ID" ,"<%=DEV_ID%>");
	vault.setFormField("PRD_SPC_TP"      ,"");

	// 구분 선택값 변경 시 vault form field에 실시간 동기화
	var fileTpInput = document.getElementById("FILE_TP_INPUT");
	fileTpInput.onchange = function() { vault.setFormField("PRD_SPC_TP", this.value); };
	// 초기값 동기화
	vault.setFormField("PRD_SPC_TP", fileTpInput.value);

	vault.onUploadComplete = function(files) {
        var uploadFlag = false;
        for (var i=0; i<files.length; i++) {
            var file = files[i];
            uploadFlag = file.error;
        }
		if(uploadFlag){
            dhtmlx.alert("파일업로드에 실패하였습니다.");
		}else{
			onLoadGrid();
			// 부모 Grid_3 새로고침
			try { window.opener.reloadFileGrid(); } catch(e) {}
		}
	};
}

function onLoadGrid(){
	var grid = items["C108000240pop02_Grid_1"];
	var customparam = {"DEV_ID":"<%=DEV_ID%>"};
	var findUrl  = parametersC10('C108000240pop02_Grid_1','find',customparam);
	items['C108000240pop02_Grid_1'].loadData(findUrl);
	grid.getDhxGrid().detachEvent(onXleGrid);
}

function Grid_doLink(filename,rowId){
	var gridObj = items["C108000240pop02_Grid_1"].getDhxGrid();
	var FILE_ADR = gridObj.cellById(rowId,gridObj.getColIndexById("IMG_ADR")).getValue();
	var FILE_NM  = gridObj.cellById(rowId,gridObj.getColIndexById("IMG_NM")).getValue();

	var url = "";
	url += "_fileDownloadHandler.jsp?";
	url += "&FILE_ADR="+FILE_ADR;
	url += "&FILE_NM="+FILE_NM;

	location.href = url;
}

function doImgDel(rowIdx){
	var gridObj = items["C108000240pop02_Grid_1"].getDhxGrid();
	var DEV_ID_VAL = gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("DEV_ID")).getValue();
	var SEQ        = gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("SEQ_NO")).getValue();

	var del_url = "";
	del_url += "_fileDeleteHandler6.jsp";
	del_url += "?IMG_RGS_FLAG=09";
	del_url += "&IMG_RGS_FLAG_ID="+DEV_ID_VAL;
	del_url += "&SEQ="+SEQ;
	del_url += "&SOFT_DELETE=Y";

	if(confirm(" 선택한 파일을 삭제하시겠습니까? ")) {
		dhtmlxAjax.get(del_url,onLoadGrid);
		// 부모 Grid_3 새로고침
		try { window.opener.reloadFileGrid(); } catch(e) {}
		return;
	}
}
//]]>
-->
</script>
</head>
<body onload="onVaultLoad()">
<div style="padding:6px 8px 4px 8px;">
	<label for="FILE_TP_INPUT" style="font-size:12px;font-weight:bold;">구분 : </label>
	<select id="FILE_TP_INPUT" style="width:220px;padding:2px 4px;font-size:12px;">
		<option value="기타">-- 구분 선택 --</option>
		<option value="고객요구사양">고객요구사양</option>
		<option value="제품사양서">제품사양서</option>
		<option value="사진자료">사진자료</option>
		<option value="개발자료">개발자료</option>
		<option value="기타">기타</option>
	</select>
</div>
<div id="vault1"></div>
<div id="C108000240pop02_Grid_1" style="position:absolute;height:90px;width:450px;left:8px;top:288px;">
</div>
<div id="C108000240pop02_MessageBox_1" style="position:absolute;height:23px;width:460px;left:0px;top:383px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
   ui.initializeDHTMLX();
   var onXleGrid = items["C108000240pop02_Grid_1"].onXLEEvent(onLoadGrid);
//]]>
-->
</script>
