<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000060pop07.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  CCL-BOM 칼라물성 수정 이력 popup7
 * DESIGNER NAME    :  성 낙 원 
 * DEVELOPER NAME   :  성 낙 원
 * CREATE DATE      :  2016.10.18
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2016.10.18     V1.0      성낙원      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String cclbomno = request.getParameter("ccl_bom_no") !=null ? request.getParameter("ccl_bom_no") : "";	
	String cuscd      = request.getParameter("cus_cd")	!=null ? request.getParameter("cus_cd") : "";
	String ordusgcd = request.getParameter("ord_usg_cd")	!=null ? request.getParameter("ord_usg_cd") : "";
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C106000060pop07
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000060pop07_Form_1","xml":".\/header\/kr\/C106000060pop07\/C106000060pop07_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000060pop07_Grid_1","service":"C106000060pop07-service"},' +
      '{"itemType":"grid","renderTo":"C106000060pop07_Grid_1","xml":".\/header\/kr\/C106000060pop07\/C106000060pop07_Grid_1.xml","rowCnt":"2","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060pop07_Form_1","service":"C106000060pop07-service"},' +
      '{"itemType":"messagebox","renderTo":"C106000060pop07_messagebox","xml":".\/header\/kr\/C106000060pop07\/C106000060pop07_messagebox.xml","service":"C106000060pop07-service"}' +
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
	uiCommon.message("C106000060pop07_messagebox",referenceItem.getUserData("","appMsg"));
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

var  loadForm_yn = "N";
var  loadGrid_yn = "N";

function onLoadForm(){
	loadForm_yn = "Y";
	load_find();
    items['C106000060pop07_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function onLoadGrid(){
	loadGrid_yn = "Y";
	load_find();
    items['C106000060pop07_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}

function load_find(){
	if(loadForm_yn=="Y" && loadGrid_yn=="Y" ){
		items['C106000060pop07_Form_1'].setItemValue("CCL_BOM_NO","<%=cclbomno%>"); 
		items['C106000060pop07_Form_1'].setItemValue("CUS_CD",       "<%=cuscd%>"); 
		items['C106000060pop07_Form_1'].setItemValue("ORD_USG_CD","<%=ordusgcd%>"); 
		var findUrl = uiCommon.parameters("C106000060pop07_Form_1","C106000060pop07_Grid_1","find");
		items['C106000060pop07_Grid_1'].loadData(findUrl);	
	}
}
//]]>
-->
</script>
</head>
<body>
<div id="C106000060pop07_Form_1" style="position:absolute;height:30px;width:699px;left:0px;top:0px;">
</div>
<div id="C106000060pop07_Grid_1" style="position:absolute;height:298px;width:696px;left:1px;top:31px;">
</div>
<div id="C106000060pop07_messagebox" style="position:absolute;height:19px;width:697px;left:0px;top:331px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();      
	var onXleForm = items["C106000060pop07_Form_1"].onXLEEvent(onLoadForm);  
	var onXleGrid = items["C106000060pop07_Grid_1"].onXLEEvent(onLoadGrid);  
//]]>
-->
</script>