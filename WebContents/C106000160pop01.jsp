<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000160pop01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  키워드 이미지 조회
 * DESIGNER NAME    :  이 돈 석
 * DEVELOPER NAME   :  이 돈 석
 * CREATE DATE      :  2021.09.29
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2021.02.19     V1.0      이돈석      Initial Version
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String KEY_WRD_NO 	    = request.getParameter("KEY_WRD_NO");
String KEY_WRD_SEQ_NO 	= request.getParameter("KEY_WRD_SEQ_NO");
String rowId 			    = request.getParameter("rowId");
String parent_item 		    = request.getParameter("parent_item");
String IMG_RGS_TP		    = request.getParameter("IMG_RGS_TP");  //1로 값 고정
String PRD_SPC_TP		    = request.getParameter("PRD_SPC_TP");

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
디지털프린팅이미지등록
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
      '{"itemType":"grid","renderTo":"C106000160pop01_Grid_1","xml":".\/header\/kr\/C106000160pop01\/C106000160pop01_Grid_1.xml","rowCnt":"2","vertical":"true","url":"gridC10Data.do","contextmenu":"false","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000160pop01_Form_1","service":"C106000160pop01-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000160pop01_MessageBox_1","xml":".\/header\/kr\/C106000160pop01\/C106000160pop01_MessageBox_1.xml","service":"C106000160pop01-service"}' +
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
    var findUrl = uiCommon.parameters('C106000160pop01_Form_1',referenceItem,'find');
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
	uiCommon.message("C106000160pop01_MessageBox_1",referenceItem.getUserData("","appMsg"));
  	return true;
}
var vault = null;
function onVaultLoad() {
	
	//grid에서 개수로 할 것인지, 에이작스를 태울것인지 결정
	//화면 팝업하기
	
	var gridObj = parent.items['<%=parent_item%>'].getDhxGrid();
	vault = new dhtmlXVaultObject();
	vault.setImagePath("/dhtmlx/codebase/imgs/");
	vault.setServerHandlers("_uploadHandler5.jsp", "_getInfoHandler.jsp", "_getIdHandler.jsp");	
	
	vault.create("vault1");
	vault.setFormField("IMG_RGS_TP"		 ,"<%=IMG_RGS_TP%>");
	vault.setFormField("IMG_RGS_FLAG"	 ,"04");
	vault.setFormField("IMG_RGS_FLAG_ID" ,"<%=KEY_WRD_NO%>");	
	vault.setFormField("IMG_RGS_FLAG_ID2","<%=KEY_WRD_SEQ_NO%>");
	vault.setFormField("PRD_SPC_TP"      ,"<%=PRD_SPC_TP%>");	
	
	
	vault.onAddFile = function(fileName) {
		/*
		var ext = this.getFileExtension(fileName);
		if (ext != "jpg" && ext != "gif") {
			dhtmlx.alert("jpg, gif 확장자만 등록하실수 있습니다.");
			return false;
		} else	return true;
		*/
		var gridObj = items['C106000160pop01_Grid_1'].getDhxGrid();
		var grid_cnt = gridObj.getRowsNum();
		
		if(grid_cnt >= 1){
			dhtmlx.alert("1개 이상 파일을 첨부할 수 없습니다");
			return false;
		}else	return true;
	};
	

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
	var grid = items["C106000160pop01_Grid_1"];
	var customparam = {"KEY_WRD_NO":"<%=KEY_WRD_NO%>","KEY_WRD_SEQ_NO":"<%=KEY_WRD_SEQ_NO%>"};	
	var findUrl  = parametersC10('C106000160pop01_Grid_1','find',customparam);
	items['C106000160pop01_Grid_1'].loadData(findUrl);
	grid.getDhxGrid().detachEvent(onXleGrid);
}

function Grid_doLink(val,rowIdx){
	var md_url 	= "C106000080pop02.jsp?rowIdx="+rowIdx; //나중에 이부분 수정
	var pGrid 	= parent.items['<%=parent_item%>'];
	var pGridObj= pGrid.getDhxGrid();
	var grid 	= items["C106000160pop01_Grid_1"];
	var gridObj = grid.getDhxGrid();

	//pGrid.setCellValue(pGridObj.getRowId('<%=rowId%>'), pGridObj.getColIndexById('IMG_NM'), getGridCellData(gridObj,rowIdx,"CHK_IMG_NM"));
	//pGrid.setCellValue(pGridObj.getRowId('<%=rowId%>'), pGridObj.getColIndexById('IMG_ADR'),getGridCellData(gridObj,rowIdx,"CHK_IMG_ADR"));
	parent.parentViewImg('<%=rowId%>',getGridCellData(gridObj,rowIdx,"CHK_IMG_NM"));
}

function doImgDel(rowIdx){
	var gridObj = items["C106000160pop01_Grid_1"].getDhxGrid();
	var KEY_WRD_NO			= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("KEY_WRD_NO")).getValue();
	var KEY_WRD_SEQ_NO	= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("KEY_WRD_SEQ_NO")).getValue();
	var SEQ				= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("SEQ_NO")).getValue();
	var FILE_NAME 		= gridObj.cellById(gridObj.getRowId(rowIdx),gridObj.getColIndexById("CHK_IMG_NM")).getValue();
	var PRD_SPC_TP 		= <%=PRD_SPC_TP%>;
	
	var del_url = "";
	del_url += "_fileDeleteHandler4.jsp";
	del_url += "?IMG_RGS_FLAG=04";
	del_url += "&IMG_RGS_FLAG_ID="+KEY_WRD_NO;
	del_url += "&IMG_RGS_FLAG_ID2="+KEY_WRD_SEQ_NO;
	del_url += "&SEQ="+SEQ;
	del_url += "&PRD_SPC_TP="+PRD_SPC_TP;
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
<div id="C106000160pop01_Grid_1" style="position:absolute;height:70px;width:430px;left:8px;top:260px;">
</div>
<div id="C106000160pop01_MessageBox_1" style="position:absolute;height:23px;width:445px;left:0px;top:332px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
   ui.initializeDHTMLX();  
   var onXleGrid = items["C106000160pop01_Grid_1"].onXLEEvent(onLoadGrid);     
//]]>
-->
</script>