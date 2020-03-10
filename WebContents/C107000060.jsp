<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "com.posdata.glue.context.PosContext" %>
<%@page import = "com.posdata.glue.web.security.*" %>
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%
    PosUser user        = (PosUser)session.getAttribute(PosSecurityConstants.USER);
    String  userNo      = "";
    String  userName    = "";
    if(user!=null) {
        userNo = (String) user.getUserInfo("USER_NO");
        userName = (String) user.getUserInfo("USER_NAME");
    }
    
    String CCL_BOM_NO 		= request.getParameter("CCL_BOM_NO") 	!= null ? request.getParameter("CCL_BOM_NO") 	: "";
%> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<title>실사용도료칼라코드관리</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
// '{"itemType":"form","renderTo":"C107000060_Form_1","xml":".\/header\/kr\/C107000060\/C107000060_Form_1.xml","url":"gridC10Data.do","referenceItem":"C107000060_Grid_1","service":"C107000060-service","actionType":"save","security":"true"},' +
// '{"itemType":"menu","renderTo":"C107000060_Menu_1","xml":".\/header\/kr\/C107000060\/C107000060_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C107000060_Grid_1","service":"C107000060-service"},' +
// '{"itemType":"grid","renderTo":"C107000060_Grid_1","xml":".\/header\/kr\/C107000060\/C107000060_Grid_1.xml","rowCnt":"21","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C107000060_Grid_1","service":"C107000060-service","actionType":"save"},' +
// '{"itemType":"messagebox","renderTo":"C107000060_messagebox","xml":".\/header\/kr\/C107000060\/C107000060_messagebox.xml","service":"C107000060-service"}' +
// ']';

// var initConfig = JSON.parse(pageConfiguration);	     

var Form_1 = {"itemType":"form","renderTo":"C107000060_Form_1","xml":".\/header\/kr\/C107000060\/C107000060_Form_1.xml","url":"gridC10Data.do","referenceItem":"C107000060_Grid_1","service":"C107000060-service","actionType":"save","security":"true"};
var Grid_1 = {"itemType":"grid","renderTo":"C107000060_Grid_1","xml":".\/header\/kr\/C107000060\/C107000060_Grid_1.xml","rowCnt":"21","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C107000060_Grid_1","service":"C107000060-service","actionType":"save"};
var Menu_1 = {"itemType":"menu","renderTo":"C107000060_Menu_1","xml":".\/header\/kr\/C107000060\/C107000060_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C107000060_Grid_1","service":"C107000060-service"};

var initLayout = 
{
	"programId":"C107000060",
	"itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"30,30,*", "splitter":false, "components": 
	[
	    Form_1,
		Menu_1,
		Grid_1
	]
}; 

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
    var findUrl = uiCommon.parameters('C107000060_Form_1',referenceItem,'find');
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

function onFormLoadFunction(formDivObj){ 
 return true;
}

//저장 후 조회처리
function onAfterUpdateFinishEvent(){
	find('find','C107000060_Form_1','C107000060_Grid_1');	
}

function firstFind(){		
	var parentFindUrl = uiCommon.parameters('C107000060_Form_1','C107000060_Grid_1','find');
	items["C107000060_Grid_1"].loadData(parentFindUrl);	
	uiCommon.progressOff(parent);	
	
	items['C107000060_Grid_1'].getDhxGrid().detachEvent(grdXle);
}


//]]>
</script>	    
</head>
<body>
<!-- <div id="C107000060_Form_1" style="position:absolute;height:28px;width:981px;left:0px;top:0px;">
</div>
<div id="C107000060_Menu_1" style="position:absolute;height:25px;width:981px;left:0px;top:28px;">
</div>
<div id="C107000060_Grid_1" style="position:absolute;height:511px;width:980px;left:-1px;top:54px;">
</div>
<div id="C107000060_messagebox" style="position:absolute;height:19px;width:980px;left:-1px;top:567px;">
</div>   -->
</body>
</html>
<script>
//<![CDATA[
	ui.initializeDHTMLX();
	items['C107000060_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	var grdXle = items['C107000060_Grid_1'].onXLEEvent(firstFind);	
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
	var dataProcessor = items["C107000060_Grid_1"].getDhxDataProcess();
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}
//]]>
</script>
