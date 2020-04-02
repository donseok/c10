<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
원자재두께관리
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C107000030tab08_Grid_1","xml":".\/header\/kr\/C107000030tab08\/C107000030tab08_Grid_1.xml","rowCnt":"19","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C107000030tab08_Grid_1","service":"C107000030tab08-service"},' +
      '{"itemType":"messagebox","renderTo":"C107000030tab08_messagebox","xml":".\/header\/kr\/C107000030tab08\/C107000030tab08_messagebox.xml","service":"C107000030tab08-service"},' +
      '{"itemType":"form","renderTo":"C107000030tab08_Form_1","xml":".\/header\/kr\/C107000030tab08\/C107000030tab08_Form_1.xml","url":"basicGridData.do","referenceItem":"C107000030tab08_Form_1","service":"C107000030tab08-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var flag = false;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var customparam = '';

    var findUrl = uiCommon.parameters4('C107000030_Form_1','C107000030tab08_Grid_1',customparam + eventName);
    items['C107000030tab08_Grid_1'].loadData(findUrl);
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
	uiCommon.message("C107000030tab08_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onLoadGrid (){
	var customparam = '';
    var findUrl = uiCommon.parameters4('C107000030_Form_1','C107000030tab08_Grid_1',customparam + 'find');
    items['C107000030tab08_Grid_1'].loadData(findUrl);
	items["C107000030tab08_Grid_1"].getDhxGrid().detachEvent(onXLE);
}
//]]>
-->
</script>
</head>
<body>
<div id="C107000030tab08_Form_1" style="position:absolute;height:30px;width:282px;left:0px;top:450px;">
</div>
<div id="C107000030tab08_Grid_1" style="position:absolute;height:492px;width:976px;left:0px;top:0px;">
</div>
<div id="C107000030tab08_messagebox" style="position:absolute;height:18px;width:976px;left:0px;top:493px;">
</div>

</body>
</html> 
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
	var onXLE = items['C107000030tab08_Grid_1'].onXLEEvent(onLoadGrid);  
//]]>
-->
</script>