<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String IMG_RGS_TP		= request.getParameter("IMG_RGS_TP");
String PRD_DEV_NO 	        = request.getParameter("PRD_DEV_NO");
String PRD_DEV_SEQ_NO 	= request.getParameter("PRD_DEV_SEQ_NO");

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<title>제품개발파일첨부프로그램</title>
<link rel="stylesheet" type="text/css" href="./dhtmlx/codebase/dhtmlxvault.css" />
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript" src="./dhtmlx/codebase/dhtmlxvault.js"></script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C108000010pop02_Grid_1","xml":".\/header\/kr\/C108000010pop02\/C108000010pop02_Grid_1.xml","rowCnt":"2","vertical":"true","url":"gridC10Data.do","contextmenu":"false","borderline":"true","pageset":"true","split":"0","referenceItem":"C108000010pop02_Grid_1","service":"C108000010pop02-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C108000010pop02_MessageBox_1","xml":".\/header\/kr\/C108000010pop02\/C108000010pop02_MessageBox_1.xml","service":"C108000010pop02-service"}' +
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
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C108000010pop02_Form_1',referenceItem,'find');
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
//(undo)
function undo(referenceItem){
	items[referenceItem].undo();
}
//(Redo)
function redo(referenceItem){
	items[referenceItem].redo();	
}
function onGridContextMenuClick(id,gridObj,menuObj){    
    var isChecked = menuObj.getCheckboxState(id); 
    if("move_grid" == id){
        if(isChecked)
          gridObj.enableColumnMove(true);
        else
          gridObj.enableColumnMove(false);
    }  
  	if("filter_grid" == id){
  		if(isChecked)
         gridObj.enableHeaderMenu();
  	}
  
  	if("editable_grid" == id){
  		if(isChecked)
         gridObj.setEditable(true);
  		else	
  		  gridObj.setEditable(false);
  	}
  	
  	if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
  	}
} 
function findMessage(referenceItem){
	uiCommon.message("C108000010pop02_MessageBox_1",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(formDivObj){ 
 return true;
}
var vault = null;
function onVaultLoad() {
	

	vault = new dhtmlXVaultObject();
	vault.setImagePath("/dhtmlx/codebase/imgs/");
	vault.setServerHandlers("_uploadHandler3.jsp", "_getInfoHandler.jsp", "_getIdHandler.jsp");	
	
	vault.create("vault1");
	vault.setFormField("IMG_RGS_TP"		 ,"<%=IMG_RGS_TP%>");
	vault.setFormField("IMG_RGS_FLAG"	 ,"05");
	vault.setFormField("IMG_RGS_FLAG_ID" ,"<%=PRD_DEV_NO%>");	
	vault.setFormField("IMG_RGS_FLAG_ID2","<%=PRD_DEV_SEQ_NO%>");

	
	vault.onAddFile = function(fileName) {
		var ext = this.getFileExtension(fileName);
		 return true;
	};

	vault.onUploadComplete = function(files) {
        var uploadFlag = false;
        for (var i=0; i<files.length; i++) {
            var file = files[i];
            uploadFlag = file.error;
        }
		if(uploadFlag){
            alert("파일업로드에 실패하였습니다.");
		}else{
			onLoadGrid();
		}			
	};
}

function onLoadGrid(){
	var grid = items["C108000010pop02_Grid_1"];
	var customparam = {"PRD_DEV_NO":"<%=PRD_DEV_NO%>","PRD_DEV_SEQ_NO":"<%=PRD_DEV_SEQ_NO%>"};	
	var findUrl  = parametersC10('C108000010pop02_Grid_1','find',customparam);
	items['C108000010pop02_Grid_1'].loadData(findUrl);
	grid.getDhxGrid().detachEvent(onXleGrid);
}

function customColumnInfo(){
	return items["C108000010pop02_Grid_1"].getDhxGrid().columnIds.join(",");	 
}




function doImgDel(rowIdx){
	var gridObj = items["C108000010pop02_Grid_1"].getDhxGrid();
	var PRD_DEV_NO		= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("PRD_DEV_NO")).getValue();
	var SEQ				= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("SEQ_NO")).getValue();
	var FILE_NAME 		= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("CHK_IMG_NM")).getValue();
	var del_url = "";
	del_url += "_fileDeleteHandler3.jsp";
	del_url += "?IMG_RGS_FLAG=05";
	del_url += "&IMG_RGS_FLAG_ID="+PRD_DEV_NO;
	del_url += "&SEQ="+SEQ;
	del_url += "&FILE_NAME="+encodeURIComponent(FILE_NAME);
	
	if(confirm(" 선택한 파일을 삭제하시겠습니까? ")) {
		dhtmlxAjax.get(del_url,onLoadGrid);
		return;
	}	
	
}

function Grid_doLink(val,rowIdx){
	var gridObj = items["C108000010pop02_Grid_1"].getDhxGrid();
	var FILE_NM_DOC = gridObj.cellById(rowIdx,gridObj.getColIndexById("CHK_IMG_NM")).getValue();
	var url = "";
	url += "_fileDownloadHandler.jsp?";
	url += "&FILE_ADR="+ "/APP/WAS/FILES/C10/05";
	url += "&FILE_NM="+ FILE_NM_DOC;
	
	 location.href = url;
}
//]]>
-->
</script>
</head>
<body onload="onVaultLoad()">
	<div id="vault1"></div>
	<div id="C108000010pop02_Grid_1"style="position: absolute; height: 70px; width: 430px; left: 8px; top: 260px;">
	</div>
	<div id="C108000010pop02_MessageBox_1"
		style="position: absolute; height: 23px; width: 445px; left: 0px; top: 332px;">
	</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX(); 
	var onXleGrid = items["C108000010pop02_Grid_1"].onXLEEvent(onLoadGrid);     
//]]>
-->
</script>