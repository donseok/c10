<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  masterGridData.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  master popup
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.01.02
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.01.02     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String CD_TP = request.getParameter("CD_TP")	!=null ? request.getParameter("CD_TP") : "";
	String CATEGORY_GROUP_NM = request.getParameter("CATEGORY_GROUP_NM")	!=null ? request.getParameter("CATEGORY_GROUP_NM") : "";
	String targetName = request.getParameter("targetName")	!=null ? request.getParameter("targetName") : "";
	String targetRowIndex = request.getParameter("targetRowIndex")	!=null ? request.getParameter("targetRowIndex") : "";
	String targetCellIndex = request.getParameter("targetCellIndex")	!=null ? request.getParameter("targetCellIndex") : "";
	String formId = request.getParameter("targetFormID")	!=null ? request.getParameter("targetFormID") : "";	
	String CD_V = request.getParameter("CD_V") !=null ? request.getParameter("CD_V") : "";	
	String popUpGubun = request.getParameter("popupGubun") !=null ? request.getParameter("popupGubun") : "";	

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
masterGridData
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"masterGridData_Form_1","xml":".\/header\/kr\/masterGridData\/masterGridData_Form_1.xml","url":"basicGridData.do","referenceItem":"masterGridData_Grid_1","service":"masterGridData-service"},' +
      '{"itemType":"grid","renderTo":"masterGridData_Grid_1","xml":".\/header\/kr\/masterGridData\/masterGridData_Grid_1.xml","rowCnt":"18","vertical":"true","url":"handleDataProcess.do","contextmenu":"false","borderline":"true","pageset":"true","split":"0","referenceItem":"masterGridData_Form_1","service":"masterGridData-service"},' +
      '{"itemType":"messagebox","renderTo":"masterGridData_messagebox","xml":".\/header\/kr\/masterGridData\/masterGridData_messagebox.xml","service":"masterGridData-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var customparam = {"CD_TP":"<%=CD_TP%>","CATEGORY_GROUP_NM":"<%=CATEGORY_GROUP_NM%>"};
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName,customparam);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
 
function findMessage(referenceItem){
	uiCommon.message("masterGridData_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}

function onLoadGrid(){
	  items['masterGridData_Form_1'].setItemValue("CD_V","<%=CD_V%>"); 
	  var customparam = {"CD_TP":"<%=CD_TP%>","CATEGORY_GROUP_NM":"<%=CATEGORY_GROUP_NM%>","CD_V":"<%=CD_V%>"};
	  var findUrl = uiCommon.parameters("masterGridData_Form_1","masterGridData_Grid_1","find",customparam);
	  items['masterGridData_Grid_1'].loadData(findUrl);
	  items['masterGridData_Grid_1'].getDhxGrid().detachEvent(onXleGrid);		
	var inputCD_V = items["masterGridData_Form_1"].getDhxForm().getInput("CD_V");
	inputCD_V.onkeyup = function(){
		inputCD_V.value = inputCD_V.value.toUpperCase(); 	
	}	
}

function parentSetValue(rowId,cellIndex,parentEleByNm){
	var gridObj = items['masterGridData_Grid_1'];
	if("<%=popUpGubun%>" == "" || "<%=popUpGubun%>" == 'undefined'){
		parent.masterSetValue(gridObj.getCellValue(rowId,0),gridObj.getCellValue(rowId,1),"<%=targetName%>","<%=formId%>","<%=targetRowIndex%>","<%=targetCellIndex%>");
		winClose();	
	}else{
		parent.masterPopupSetValue(gridObj.getCellValue(rowId,0),gridObj.getCellValue(rowId,1),"<%=targetName%>","<%=formId%>","<%=targetRowIndex%>","<%=targetCellIndex%>");
		if(typeof(parent.winObj2) !== 'undefined'){
			parent.winObj2.winClose();					
		}
	}
	
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
<div id="masterGridData_Form_1" style="position:absolute;height:30px;width:450px;left:0px;top:0px;">
</div>
<div id="masterGridData_Grid_1" style="position:absolute;height:431px;width:448px;left:1px;top:31px;">
</div>
<div id="masterGridData_messagebox" style="position:absolute;height:19px;width:449px;left:0px;top:464px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();      
	var onXleGrid = items["masterGridData_Grid_1"].onXLEEvent(onLoadGrid);  
	items["masterGridData_Grid_1"].rowDblClicked(parentSetValue);
	  
//]]>
-->
</script>