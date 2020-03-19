<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
통과공정 및 CCL-BOM 공정 조회
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000020TAB08pop_Form_1","xml":".\/header\/kr\/C104000020TAB08pop\/C104000020TAB08pop_Form_1.xml","url":"gridC10Data.do","referenceItem":"C104000020TAB08pop_Grid_1","service":"C104000020TAB08pop-service"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB08pop_Grid_1","xml":".\/header\/kr\/C104000020TAB08pop\/C104000020TAB08pop_Grid_1.xml","rowCnt":"6","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB08pop_Form_1","service":"C104000020TAB08pop-service"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB08pop_Grid_2","xml":".\/header\/kr\/C104000020TAB08pop\/C104000020TAB08pop_Grid_2.xml","rowCnt":"2","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB08pop_Form_1","service":"C104000020TAB08pop-service"},' +
      '{"itemType":"messagebox","renderTo":"C104000020TAB08pop_messagebox","xml":".\/header\/kr\/C104000020TAB08pop\/C104000020TAB08pop_messagebox.xml","service":"C104000020TAB08pop-service"},' +
      '{"itemType":"form","renderTo":"C104000020TAB08pop_Form_2","xml":".\/header\/kr\/C104000020TAB08pop\/C104000020TAB08pop_Form_2.xml","url":"basicGridData.do","referenceItem":"C104000020TAB08pop_Form_1","service":"C104000020TAB08pop-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function findCclBom(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C104000020TAB08pop_Form_1',referenceItem,'find');
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
function onLoadedGrid1() {
	var parentFindUrl = uiCommon.parameters('C104000020TAB08pop_Form_1','C104000020TAB08pop_Grid_1','find');
    items["C104000020TAB08pop_Grid_1"].loadData(parentFindUrl);
	items['C104000020TAB08pop_Grid_1'].getDhxGrid().detachEvent(_onXLE1); // 무한루프를 방지하기 위해 onXLEEvent 삭제
}
function onLoadedGrid2() {
	var parentFindUrl = uiCommon.parameters('C104000020TAB08pop_Form_1','C104000020TAB08pop_Grid_2','findCclBom');
    items["C104000020TAB08pop_Grid_2"].loadData(parentFindUrl);
	items['C104000020TAB08pop_Grid_2'].getDhxGrid().detachEvent(_onXLE2); // 무한루프를 방지하기 위해 onXLEEvent 삭제
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
	uiCommon.message("C104000020TAB08pop_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadEvent(){ 
 	//부모프로그램의 통과공정번호를 팝업창에도 그대로 복사함 
 	items['C104000020TAB08pop_Form_1'].setItemValue("PAS_PROC_NO","<%=request.getParameter("PAS_PROC_NO")%>");
 	items['C104000020TAB08pop_Form_1'].setItemValue("CCL_BOM_NO","<%=request.getParameter("CCL_BOM_NO")%>"); 
	
	items['C104000020TAB08pop_Form_1'].getDhxForm().detachEvent(_onXLEForm); 
 	return true;	
}
//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB08pop_Form_1" style="position:absolute;height:56px;width:552px;left:0px;top:0px;">
</div>
<div id="C104000020TAB08pop_Grid_1" style="position:absolute;height:160px;width:550px;left:0px;top:56px;">
</div>
<div id="C104000020TAB08pop_Grid_2" style="position:absolute;height:73px;width:550px;left:0px;top:248px;">
</div>
<div id="C104000020TAB08pop_messagebox" style="position:absolute;height:19px;width:551px;left:-1px;top:321px;">
</div>
<div id="C104000020TAB08pop_Form_2" style="position:absolute;height:32px;width:550px;left:0px;top:216px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var _onXLEForm = items['C104000020TAB08pop_Form_1'].onXLEEvent(onFormLoadEvent);
	var _onXLE1 = items['C104000020TAB08pop_Grid_1'].onXLEEvent(onLoadedGrid1);
	var _onXLE2 = items['C104000020TAB08pop_Grid_2'].onXLEEvent(onLoadedGrid2);
//]]>
-->
</script>