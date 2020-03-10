<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"FirstPage_Form_1","xml":".\/header\/kr\/FirstPage\/FirstPage_Form_1.xml","url":"basicGridData.do","referenceItem":"FirstPage_Grid_1","service":"FirstPage-service"},' +
      '{"itemType":"menu","renderTo":"FirstPage_Menu_1","xml":".\/header\/kr\/FirstPage\/FirstPage_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"FirstPage_Grid_1","service":"FirstPage-service"},' +
      '{"itemType":"grid","renderTo":"FirstPage_Grid_1","xml":".\/header\/kr\/FirstPage\/FirstPage_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"false","service":"FirstPage-service"},' +
      '{"itemType":null,"renderTo":"messagebox","xml":".\/header\/kr\/FirstPage\/messagebox.xml","service":"FirstPage-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"./dhtmlx/codebase/imgs/"};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var uiGridFindActionUrl = uiCommon.parameters(items[formDivObj].getDhxForm(),items[formDivObj].getFindUrl(),items[formDivObj].getServiceName(),eventName,items[referenceItem].getColumnInfo());
    items[referenceItem].loadData(uiGridFindActionUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].send(items[referenceItem].getServerProcessUrl(),items[referenceItem].getActivityServiceName(),eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event	
	items[referenceItem].refresh("find");
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
//]]>
-->
</script>
</head>
<body>

<div id="FirstPage_Form_1" style="position:absolute;height:28px;width:959px;left:0px;top:0px;">
</div>
<div id="FirstPage_Menu_1" style="position:absolute;height:25px;width:959px;left:0px;top:33px;">
</div>
<div id="FirstPage_Grid_1" style="position:absolute;height:540px;width:959px;left:0px;top:58px;">
</div>
<div id="messagebox" style="position:absolute;height:23px;width:959px;left:0px;top:603px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
//]]>
-->
</script>
