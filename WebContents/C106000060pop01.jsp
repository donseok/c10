<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000060pop01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  CCL-BOM Master popup
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  이 민 균
 * CREATE DATE      :  2012.02.16
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.02.16     V1.0      이민균      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String prtRollNo = request.getParameter("prt_roll_no") !=null ? request.getParameter("prt_roll_no") : "";	
	String rowId = request.getParameter("rowId")	!=null ? request.getParameter("rowId") : "";
	String cellIndex = request.getParameter("cellIndex")	!=null ? request.getParameter("cellIndex") : "";
	String targetDivId = request.getParameter("targetDivId")	!=null ? request.getParameter("targetDivId") : "";
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C106000060pop01
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000060pop01_Form_1","xml":".\/header\/kr\/C106000060pop01\/C106000060pop01_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000060pop01_Grid_1","service":"C106000060pop01-service"},' +
      '{"itemType":"grid","renderTo":"C106000060pop01_Grid_1","xml":".\/header\/kr\/C106000060pop01\/C106000060pop01_Grid_1.xml","rowCnt":"2","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060pop01_Form_1","service":"C106000060pop01-service"},' +
      '{"itemType":"messagebox","renderTo":"C106000060pop01_messagebox","xml":".\/header\/kr\/C106000060pop01\/C106000060pop01_messagebox.xml","service":"C106000060pop01-service"}' +
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
	uiCommon.message("C106000060pop01_messagebox",referenceItem.getUserData("","appMsg"));
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
	items['C106000060pop01_Form_1'].setItemValue("PRT_ROLL_NO","<%=prtRollNo%>"); 
	var findUrl = uiCommon.parameters("C106000060pop01_Form_1","C106000060pop01_Grid_1","find");
	items['C106000060pop01_Grid_1'].loadData(findUrl);		
	var inputCD_V = items["C106000060pop01_Form_1"].getDhxForm().getInput("PRT_ROLL_NO");
		inputCD_V.onkeyup = function(){
			inputCD_V.value = inputCD_V.value.toUpperCase(); 	
		}	
		items['C106000060pop01_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}

function parentSetValue(rowId,cellIndex,parentEleByNm){
	var gridObj = items['C106000060pop01_Grid_1'];
    if('<%=targetDivId%>' == 'C106000060_Grid_4'){
      	parent.popSetValue("<%=rowId%>","<%=cellIndex%>",gridObj.getCellValue(rowId,0),gridObj.getCellValue(rowId,4),gridObj.getCellValue(rowId,5),gridObj.getCellValue(rowId,6));	
    }else if('<%=targetDivId%>' == 'C106000060_Grid_9'){
		parent.popSetValue9("<%=rowId%>","<%=cellIndex%>",gridObj.getCellValue(rowId,0),gridObj.getCellValue(rowId,4),gridObj.getCellValue(rowId,5),gridObj.getCellValue(rowId,6));	
	}
	winClose();
}
//]]>
-->
</script>
</head>
<body>
<div id="C106000060pop01_Form_1" style="position:absolute;height:30px;width:650px;left:0px;top:0px;">
</div>
<div id="C106000060pop01_Grid_1" style="position:absolute;height:431px;width:648px;left:1px;top:31px;">
</div>
<div id="C106000060pop01_messagebox" style="position:absolute;height:19px;width:649px;left:0px;top:464px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();      
	var onXleGrid = items["C106000060pop01_Grid_1"].onXLEEvent(onLoadGrid);  
	items["C106000060pop01_Grid_1"].rowDblClicked(parentSetValue);    
//]]>
-->
</script>