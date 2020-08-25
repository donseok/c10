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
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
'{"itemType":"form","renderTo":"C107000060_Form_1","xml":".\/header\/kr\/C107000060\/C107000060_Form_1.xml","url":"gridC10Data.do","referenceItem":"C107000060_Grid_1","service":"C107000060-service","actionType":"save","security":"true"},' +
'{"itemType":"form","renderTo":"C107000060_Form_2","xml":".\/header\/kr\/C107000060\/C107000060_Form_2.xml","url":"gridC10Data.do","referenceItem":"C107000060_Grid_1","service":"C107000060-service","actionType":"save","security":"true"},' +
'{"itemType":"menu","renderTo":"C107000060_Menu_1","xml":".\/header\/kr\/C107000060\/C107000060_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C107000060_Grid_1","service":"C107000060-service"},' +
'{"itemType":"grid","renderTo":"C107000060_Grid_1","xml":".\/header\/kr\/C107000060\/C107000060_Grid_1.xml","rowCnt":"21","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C107000060_Grid_1","service":"C107000060-service","actionType":"save"},' +
'{"itemType":"messagebox","renderTo":"C107000060_messagebox","xml":".\/header\/kr\/C107000060\/C107000060_messagebox.xml","service":"C107000060-service"}' +
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
	uiCommon.message("C107000060_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}

function onFormLoadFunction(){ 

	var formObj   = items['C107000060_Form_2'].getDhxForm();
	var form   = items['C107000060_Form_2'];
	
	form.setItemLabel("cau_lab", "<span style='color:red;'>※ BOM 칼라코드와 다른 실사용 도료 적용 시 출측특기사항에 실사용 칼라코드와 도료사 기록 必</span>");
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

function onGridLoadFunction(){
	var grid =  items['C107000060_Grid_1'];
	var gridObj = items['C107000060_Grid_1'].getDhxGrid();
	var gridDhxObj = items['C107000060_Grid_1'].getDhxGrid();		
	var pntCmpCdCombo = gridDhxObj.getColumnCombo(gridObj.getColIndexById('PNT_CMP_CD'));
	
	pntCmpCdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PNT_CMP_CD&totalValue=&orderBy=value&displayType=all-code");   
	pntCmpCdCombo.enableOptionAutoPositioning(true);
	pntCmpCdCombo.readonly(true,true);
	pntCmpCdCombo.setOptionHeight(220);
}

//]]>
-->
</script>	    
</head>
<body>
<div id="C107000060_Form_1" style="position:absolute;height:28px;width:981px;left:0px;top:0px;">
</div>
<div id="C107000060_Menu_1" style="position:absolute;height:25px;width:981px;left:0px;top:28px;">
</div>
<div id="C107000060_Form_2" style="position:absolute;height:25px;width:749px;left:231px;top:28px;">
</div>
<div id="C107000060_Grid_1" style="position:absolute;height:511px;width:980px;left:-1px;top:54px;">
</div>
<div id="C107000060_messagebox" style="position:absolute;height:19px;width:980px;left:-1px;top:567px;">
</div>  
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleForm= items['C107000060_Form_2'].onXLEEvent(onFormLoadFunction);
	items['C107000060_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	var grdXle = items['C107000060_Grid_1'].onXLEEvent(firstFind);
	var onXleGrid = items["C107000060_Grid_1"].onXLEEvent(onGridLoadFunction);
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
	var dataProcessor = items["C107000060_Grid_1"].getDhxDataProcess();
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}
//]]>
-->
</script>
