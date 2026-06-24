<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C10600050pop03.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  칼라코드관리 문서다운로드
 * DESIGNER NAME    :  이 돈 석
 * DEVELOPER NAME   :  이 돈 석
 * CREATE DATE      :  2019.12.19
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2019.12.19     V1.0      이돈석      Initial Version
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String CLR_SUB_MTL_CD 	    = request.getParameter("CLR_SUB_MTL_CD");
String PNT_CMP_CD 	        = request.getParameter("PNT_CMP_CD");
String SEQ 	                = request.getParameter("SEQ");
String rowId 			    = request.getParameter("rowId");
String parent_item 		    = request.getParameter("parent_item");
String IMG_RGS_TP		    = "1";  //1로 값 고정
//String PRD_SPC_TP		    = request.getParameter("PRD_SPC_TP");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
MSDS문서등록
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
      '{"itemType":"grid","renderTo":"C106000050pop03_Grid_1","xml":".\/header\/kr\/C106000050pop03\/C106000050pop03_Grid_1.xml","rowCnt":"2","vertical":"true","url":"gridC10Data.do","contextmenu":"false","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000050pop03_Form_1","service":"C106000050pop03-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000050pop03_MessageBox_1","xml":".\/header\/kr\/C106000050pop03\/C106000050pop03_MessageBox_1.xml","service":"C106000050pop03-service"}' +
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
/* function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C106000100pop02_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);	
} */
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
	uiCommon.message("C106000050pop03_MessageBox_1",referenceItem.getUserData("","appMsg"));
  	return true;
}
var vault = null;
function onVaultLoad() {
	var gridObj = parent.items['<%=parent_item%>'].getDhxGrid();
	vault = new dhtmlXVaultObject();
	vault.setImagePath("/dhtmlx/codebase/imgs/");
	vault.setServerHandlers("_uploadHandler6.jsp", "_getInfoHandler.jsp", "_getIdHandler.jsp");	
	
	vault.create("vault1");
	
	vault.setFormField("IMG_RGS_TP"		, "<%=IMG_RGS_TP%>");
	vault.setFormField("IMG_RGS_FLAG"	, "06");
	vault.setFormField("IMG_RGS_FLAG_ID", "<%=CLR_SUB_MTL_CD%>");	
	vault.setFormField("IMG_RGS_FLAG_ID2","<%=PNT_CMP_CD%>");

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
		}			
	};
}

function onLoadGrid(){
	var grid = items["C106000050pop03_Grid_1"];
	var customparam = {"CLR_SUB_MTL_CD":"<%=CLR_SUB_MTL_CD%>","PNT_CMP_CD":"<%=PNT_CMP_CD%>","SEQ":"<%=SEQ%>"};	
	var findUrl  = parametersC10('C106000050pop03_Grid_1','find',customparam);
	items['C106000050pop03_Grid_1'].loadData(findUrl);
	grid.getDhxGrid().detachEvent(onXleGrid);
}

function Grid_doLink(filename,rowId){
	var gridObj = items["C106000050pop03_Grid_1"].getDhxGrid();
	var FILE_ADR = gridObj.cellById(rowId,gridObj.getColIndexById("IMG_ADR")).getValue();
	var FILE_NM= gridObj.cellById(rowId,gridObj.getColIndexById("IMG_NM")).getValue();
	
	var url = "";
	url += "_fileDownloadHandler.jsp?";
	url += "&FILE_ADR="+FILE_ADR;
	url += "&FILE_NM="+FILE_NM;
	
	 location.href = url;
}


function doImgDel(rowIdx){
	
	var gridObj = items["C106000050pop03_Grid_1"].getDhxGrid();
	var CLR_SUB_MTL_CD	= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("CLR_SUB_MTL_CD")).getValue();
	var PNT_CMP_CD	    = gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("PNT_CMP_CD")).getValue();
	var SEQ				= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("SEQ")).getValue();
	var FILE_NAME 		= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("CHK_IMG_NM")).getValue();
	
	var del_url = "";
	del_url += "_fileDeleteHandler5.jsp";
	del_url += "?IMG_RGS_FLAG=06";
	del_url += "&IMG_RGS_FLAG_ID="+CLR_SUB_MTL_CD;
	del_url += "&IMG_RGS_FLAG_ID2="+PNT_CMP_CD;
	del_url += "&SEQ="+SEQ;
	del_url += "&FILE_NAME="+encodeURIComponent(FILE_NAME);
	
	if(confirm(" 선택한 이미지를 삭제하시겠습니까? ")) {
		dhtmlxAjax.get(del_url,onLoadGrid);
		return;
	}
}
//]]>
-->
</script>
</head>
<body onload="onVaultLoad()">
<div id="vault1"></div>
<div id="C106000050pop03_Grid_1" style="position:absolute;height:70px;width:430px;left:8px;top:260px;">
</div>
<div id="C106000050pop03_MessageBox_1" style="position:absolute;height:23px;width:445px;left:0px;top:332px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
   ui.initializeDHTMLX();  
   var onXleGrid = items["C106000050pop03_Grid_1"].onXLEEvent(onLoadGrid);     
//]]>
-->
</script>
