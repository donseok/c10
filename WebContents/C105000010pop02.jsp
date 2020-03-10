<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C105000010pop02.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  규격공통 규격약호pop-up
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  김 종 범
 * CREATE DATE      :  2012.06.15
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.06.15     V1.0      김종범      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String spcAvr = request.getParameter("SPC_AVR") !=null ? request.getParameter("SPC_AVR") : "";		
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C105000010pop02
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C105000010pop02_Form_1","xml":".\/header\/kr\/C105000010pop02\/C105000010pop02_Form_1.xml","url":"basicGridData.do","referenceItem":"C105000010pop02_Grid_1","service":"C105000010pop02-service"},' +
      '{"itemType":"grid","renderTo":"C105000010pop02_Grid_1","xml":".\/header\/kr\/C105000010pop02\/C105000010pop02_Grid_1.xml","rowCnt":"18","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C105000010pop02_Form_1","service":"C105000010pop02-service"},' +
      '{"itemType":"messagebox","renderTo":"C105000010pop02_messagebox","xml":".\/header\/kr\/C105000010pop02\/C105000010pop02_messagebox.xml","service":"C105000010pop02-service"}' +
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
 
function findMessage(referenceItem){
	uiCommon.message("C105000010pop02_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
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

function onLoadGrid(){
	var spcAvr = "<%=spcAvr%>";
	if(isNull(spcAvr)){
		spcAvr = "";	
	}
	items['C105000010pop02_Form_1'].setItemValue("SPC_AVR",spcAvr); 
	var findUrl = uiCommon.parameters("C105000010pop02_Form_1","C105000010pop02_Grid_1","find");
	items['C105000010pop02_Grid_1'].loadData(findUrl);		
	var inputCD_V = items["C105000010pop02_Form_1"].getDhxForm().getInput("SPC_AVR");
		inputCD_V.onkeyup = function(){
			inputCD_V.value = inputCD_V.value.toUpperCase(); 	
		}	
		items['C105000010pop02_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}

function popClose(){
	parent.winObj3.winClose();
}

function parentSetValue(rowId,cellIndex){
	var cellValue = items['C105000010pop02_Grid_1'].getCellValue(rowId,0);
	parent.gluePopupSetValue(cellValue);
	if(typeof(parent.winObj3) !== 'undefined'){
		parent.winObj3.winClose();					
	}
}
//]]>
-->
</script>
</head>
<body>
<div id="C105000010pop02_Form_1" style="position:absolute;height:30px;width:650px;left:0px;top:0px;">
</div>
<div id="C105000010pop02_Grid_1" style="position:absolute;height:431px;width:648px;left:1px;top:31px;">
</div>
<div id="C105000010pop02_messagebox" style="position:absolute;height:19px;width:649px;left:0px;top:464px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();      
	var onXleGrid = items["C105000010pop02_Grid_1"].onXLEEvent(onLoadGrid);  
	items["C105000010pop02_Grid_1"].rowDblClicked(parentSetValue);    

//]]>
-->
</script>