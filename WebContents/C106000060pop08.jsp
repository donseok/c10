<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000060pop08.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  CCL-BOM Master popup
 * DESIGNER NAME    :  이 돈 석
 * DEVELOPER NAME   :  이 돈 석
 * CREATE DATE      :  2022.11.30
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2022.11.30     V1.0      이돈석      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    
    String rsnTpqtbrFrn = request.getParameter("rsn_tp_qt_br_frn") !=null ? request.getParameter("rsn_tp_qt_br_frn") : "";	
    
    //String CCL_BOM_NO = request.getParameter("ccl_bom_no") !=null ? request.getParameter("ccl_bom_no") : "";
    String rowId = request.getParameter("rowId")	!=null ? request.getParameter("rowId") : "";
	String cellIndex = request.getParameter("cellIndex")	!=null ? request.getParameter("cellIndex") : "";
	String targetDivId = request.getParameter("targetDivId")	!=null ? request.getParameter("targetDivId") : "";
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C106000060pop08
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
'{"itemType":"form","renderTo":"C106000060pop08_Form_1","xml":".\/header\/kr\/C106000060pop08\/C106000060pop08_Form_1.xml","url":"basicFormData.do","referenceItem":"C106000060pop08_Form_1","service":"C106000060pop08-service","actionType":"find"},' +
'{"itemType":"form","renderTo":"C106000060pop08_Form_2","xml":".\/header\/kr\/C106000060pop08\/C106000060pop08_Form_2.xml","url":"basicFormData.do","referenceItem":"C106000060pop08_Form_2","service":"C106000060pop08-service","actionType":"save"},' +
'{"itemType":"messagebox","renderTo":"C106000060pop08_messagebox","xml":".\/header\/kr\/C106000060pop08\/C106000060pop08_messagebox.xml","service":"C106000060pop08-service"}' +
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
	uiCommon.message("C106000060pop08_messagebox",referenceItem.getUserData("","appMsg"));
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


function parentSetValue(rowId,cellIndex,parentEleByNm){
	/*
	var gridObj = items['C106000060pop08_Grid_1'];
    if('<%=targetDivId%>' == 'C106000060_Grid_5'){
      	parent.popSetValue("<%=rowId%>","<%=cellIndex%>",gridObj.getCellValue(rowId,0),gridObj.getCellValue(rowId,4),gridObj.getCellValue(rowId,5),gridObj.getCellValue(rowId,6));	
    }else if('<%=targetDivId%>' == 'C106000060_Grid_5'){
		parent.popSetValue9("<%=rowId%>","<%=cellIndex%>",gridObj.getCellValue(rowId,0),gridObj.getCellValue(rowId,4),gridObj.getCellValue(rowId,5),gridObj.getCellValue(rowId,6));	
	}
    */
    
    /*폼에 있는 값들을 다 get해온다 */
    var form = items['C106000060pop08_Form_2'];
 	var rsnTpQtBrFrnCb = form.getItemValue("RSN_TP_QT_BR_FRN_CB");
 	var rsnTpQtBrBakCb = form.getItemValue("RSN_TP_QT_BR_BAK_CB");
 	var luxBrdCdCb = form.getItemValue("LUXTEEL_BRD_CD_CB");
 	
    parent.popSetValue10("<%=rowId%>",'1',rsnTpQtBrFrnCb,'2',rsnTpQtBrBakCb,'5',luxBrdCdCb);
        
	winClose();
}

function onFormLoadFunction(formDivObj){ 
	var form  = items['C106000060pop08_Form_2'];
	var comboList = items['C106000060pop08_Form_2'].getMasterCombos();
	comboList['RSN_TP_QT_BR_FRN_CB'].readonly(true,false);
	ui.combo.master(comboList['RSN_TP_QT_BR_FRN_CB'],'SZ0000','RSN_TP_QT_BR','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['RSN_TP_QT_BR_FRN_CB'].selectOption(0,true,true);
		comboList['RSN_TP_QT_BR_FRN_CB'].readonly(true);
		comboList['RSN_TP_QT_BR_FRN_CB'].setOptionHeight(220);
	});
	
	comboList['RSN_TP_QT_BR_BAK_CB'].readonly(true,false);
		ui.combo.master(comboList['RSN_TP_QT_BR_BAK_CB'],'SZ0000','RSN_TP_QT_BR','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['RSN_TP_QT_BR_BAK_CB'].selectOption(0,true,true);
		comboList['RSN_TP_QT_BR_BAK_CB'].readonly(true);
		comboList['RSN_TP_QT_BR_BAK_CB'].setOptionHeight(220);		
	});
	
	comboList['LUXTEEL_BRD_CD_CB'].readonly(true,false);
		ui.combo.master(comboList['LUXTEEL_BRD_CD_CB'],'SZ0000','LUXTEEL_BRD_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['LUXTEEL_BRD_CD_CB'].selectOption(0,true,true);
		comboList['LUXTEEL_BRD_CD_CB'].readonly(true);
		comboList['LUXTEEL_BRD_CD_CB'].setOptionHeight(220);
	});
	
	items['C106000060pop08_Form_2'].getDhxForm().detachEvent(onXleForm);
}


//]]>
-->
</script>
</head>
<body>
<div id="C106000060pop08_Form_1" style="position:absolute;height:30px;width:615px;left:0px;top:0px;">
</div>
<div id="C106000060pop08_Form_2" style="position:absolute;height:130px;width:615px;left:1px;top:31px;">
</div>
<div id="C106000060pop08_messagebox" style="position:absolute;height:19px;width:615px;left:0px;top:161px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX(); 
	var onXleForm = items["C106000060pop08_Form_2"].onXLEEvent(onFormLoadFunction);
	//items["C106000060pop01_Grid_1"].rowDblClicked(parentSetValue);    
//]]>
-->
</script>