<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
업무기준조회(판단)
</title>
<script src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C107000030_Form_1","xml":".\/header\/kr\/C107000030\/C107000030_Form_1.xml","url":"basicGridData.do","referenceItem":"C107000030_Tabbar_1","service":"C107000030-service"},' +
//       '{"itemType":"tabbar","renderTo":"C107000030_Tabbar_1","xml":".\/header\/kr\/C107000030\/C107000030_Tabbar_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","skin":"modern","service":"C107000030-service"}' +
//    ']';
// var initConfig = JSON.parse(pageConfiguration);	     

var Form_1 = {"itemType":"form","renderTo":"C107000030_Form_1","xml":".\/header\/kr\/C107000030\/C107000030_Form_1.xml","url":"basicGridData.do","referenceItem":"C107000030_Tabbar_1","service":"C107000030-service"};
var Tabbar_1 = {"itemType":"tabbar","renderTo":"C107000030_Tabbar_1","xml":".\/header\/kr\/C107000030\/C107000030_Tabbar_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","skin":"modern","service":"C107000030-service"};

var initLayout = 
{
	  "programId":"C107000030",
	  "itemType": "layout", "dirType":"row", "childSize":"30,*", "splitter":false, "components": 
	  [
      Form_1,
      Tabbar_1
	  ] 
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	items[referenceItem].activeTabFrame().contentWindow.find(eventName);
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C107000030_Form_1',referenceItem,'find');
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
	uiCommon.message("messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}

//]]>
</script>
</head>
<body>
<!-- <div id="C107000030_Form_1" style="position:absolute;height:30px;width:980px;left:0px;top:0px;">
</div>
<div id="C107000030_Tabbar_1" style="position:absolute;height:562px;width:980px;left:0px;top:31px;">
</div> -->
</body>
</html>
<script>
//<![CDATA[
	ui.initializeDHTMLX();          
//]]>
</script>