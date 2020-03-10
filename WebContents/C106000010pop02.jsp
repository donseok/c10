<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000010pop02.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  도료사별 색상개발 담당 팝업
 * DESIGNER NAME    :  이 돈 석
 * DEVELOPER NAME   :  원 성 옥
 * CREATE DATE      :  2015.05.20
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2015.05.20     V1.0      원성옥      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
도로사별 색상개발 담당
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000010pop02_Form_1","xml":".\/header\/kr\/C106000010pop02\/C106000010pop02_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000010pop02_Grid_1","service":"C106000010pop02-service"},' +
      '{"itemType":"grid","renderTo":"C106000010pop02_Grid_1","xml":".\/header\/kr\/C106000010pop02\/C106000010pop02_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000010pop02_Form_1","service":"C106000010pop02-service"},' +
      '{"itemType":"messagebox","renderTo":"C106000010pop02_messagebox","xml":".\/header\/kr\/C106000010pop02\/C106000010pop02_messagebox.xml","service":"C106000010pop02-service"}' +
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
    var findUrl = uiCommon.parameters('C106000010pop02_Form_1',referenceItem,'find');
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
function onLoadedGrid() {
	var parentFindUrl = uiCommon.parameters('C106000010pop02_Form_1','C106000010pop02_Grid_1','find');
    items["C106000010pop02_Grid_1"].loadData(parentFindUrl);
	items['C106000010pop02_Grid_1'].getDhxGrid().detachEvent(_onXLE); // 무한루프를 방지하기 위해 onXLEEvent 삭제
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
	uiCommon.message("C106000010pop02_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadEvent(){ 
	items['C106000010pop02_Form_1'].getDhxForm().detachEvent(_onXLEForm);
 	return true;	
}
//]]>
-->
</script>
</head>
<body>
<div id="C106000010pop02_Form_1" style="position:absolute;height:35px;width:830px;left:0px;top:0px;">
</div>
<div id="C106000010pop02_Grid_1" style="position:absolute;height:301px;width:827px;left:1px;top:35px;">
</div>
<div id="C106000010pop02_messagebox" style="position:absolute;height:19px;width:828px;left:0px;top:338px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var _onXLEForm = items['C106000010pop02_Form_1'].onXLEEvent(onFormLoadEvent);
	var _onXLE = items['C106000010pop02_Grid_1'].onXLEEvent(onLoadedGrid);
//]]>
-->
</script>