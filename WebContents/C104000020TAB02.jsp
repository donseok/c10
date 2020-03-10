<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB02.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-성분
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.11.21
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.11.21     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C104000020TAB02_Grid_2","xml":".\/header\/kr\/C104000020TAB02\/C104000020TAB02_Grid_2.xml","rowCnt":"4","url":"basicGridData.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB02_Grid_1","service":"C104000020TAB02-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB02_Grid_1","xml":".\/header\/kr\/C104000020TAB02\/C104000020TAB02_Grid_1.xml","rowCnt":"4","url":"basicGridData.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB02_Grid_1","service":"C104000020TAB02-service","actionType":"find"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C104000020TAB02\/messagebox.xml","service":"C104000020TAB02-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"/dhtmlx/codebase/imgs/"};
//form find button item event function (requred)
function find(eventName){ 
	var findUrl2 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB02_Grid_2',eventName); 
	items['C104000020TAB02_Grid_2'].loadData(findUrl2, function(){
	       var findUrl1 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB02_Grid_1',eventName); 
	   	items['C104000020TAB02_Grid_1'].loadData(findUrl1);
	     });
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].send(items[referenceItem].getServerProcessUrl(),items[referenceItem].getActivityServiceName(),eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].getSelectionClear();
}
//menu new row event function
function add(referenceItem){
    items[referenceItem].addRow();
}
//menu remove event function
function modify(referenceItem){
    items[referenceItem].removeRow();
}
//menu remove event function
function remove(referenceItem){
    items[referenceItem].removeRow();
}
//menu rows clipboard copy event function
function copy(referenceItem){
    items[referenceItem].copyRowsClipboard('srows','\t');
}
//menu rows clipboard paste event function
function paste(referenceItem){
    items[referenceItem].addRowClipboard();
}
//(undo)
function undo(referenceItem){
    items[referenceItem].undo();
}
//(Redo)
function redo(referenceItem){
    items[referenceItem].redo();	
}
function findMessage(referenceItem){		
	uiCommon.message(ui.messagebox.messageBoxDivId,referenceItem.getUserData("","appMsg"));
	return true;
}
function onFormLoadEvent(){ 
	return true;
}
function doOnRowSelectedGrid2(rowId,cellId) {
	items['C104000020TAB02_Grid_1'].getDhxGrid().selectRowById(rowId);
}	
function doOnRowSelectedGrid1(rowId,cellId) {
	items['C104000020TAB02_Grid_2'].getDhxGrid().selectRowById(rowId);	
}	
function onGridLoadEvent1(){ 
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB02_Grid_1',"find"); 
	items['C104000020TAB02_Grid_1'].loadData(findUrl);		
	items['C104000020TAB02_Grid_1'].getDhxGrid().detachEvent(_onXLE1);
	return false;
}
function onGridLoadEvent2(){ 
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB02_Grid_2',"find"); 
	items['C104000020TAB02_Grid_2'].loadData(findUrl); 
	items['C104000020TAB02_Grid_2'].getDhxGrid().detachEvent(_onXLE2);
	return false;
}

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


//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB02_Grid_2" style="position:absolute;height:140px;width:968px;left:1px;top:5px;">
</div>
<div id="C104000020TAB02_Grid_1" style="position:absolute;height:140px;width:968px;left:1px;top:190px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:968px;left:1px;top:429px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();
       items['C104000020TAB02_Grid_2'].getDhxGrid().attachEvent("onRowSelect", doOnRowSelectedGrid2);
       items['C104000020TAB02_Grid_1'].getDhxGrid().attachEvent("onRowSelect", doOnRowSelectedGrid1);
       var _onXLE2 = items['C104000020TAB02_Grid_2'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent2);
       var _onXLE1 = items['C104000020TAB02_Grid_1'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent1);
//]]>
-->
</script>