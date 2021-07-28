<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB03.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-재질
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.11.21
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.11.21     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C104000020TAB03_Grid_1","xml":".\/header\/kr\/C104000020TAB03\/C104000020TAB03_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB03_Grid_1","service":"C104000020TAB03-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB03_Grid_2","xml":".\/header\/kr\/C104000020TAB03\/C104000020TAB03_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB03_Grid_2","service":"C104000020TAB03-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C104000020TAB03\/messagebox.xml","service":"C104000020TAB03-service"},' +
      '{"itemType":"form","renderTo":"C104000020TAB03_Form_1","xml":".\/header\/kr\/C104000020TAB03\/C104000020TAB03_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020TAB03_Form_1","service":"C104000020TAB03-service","security":"true"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"/dhtmlx/codebase/imgs/"};
//form find button item event function (requred)
function find(eventName){ 
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB03_Grid_1',"find"); 
	items['C104000020TAB03_Grid_1'].loadData(findUrl,lockRowEvent); 
	findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB03_Grid_2',"find"); 
	items['C104000020TAB03_Grid_2'].loadData(findUrl,lockRowEvent2); 
}
function save(eventName,formDivObj,referenceItem){
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	var param1= "ServiceName=C104000020TAB03-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
	var cells1 = xmlObj1.getElementsByTagName("cell");
	if(cells1.length > 0){						
		dhtmlx.alert("확정된 주문입니다!");
		return;					
	}				
	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){
			    items['C104000020TAB03_Grid_1'].sendGrid('C104000020TAB03_Grid_1',"save");					
				return;
			}
		}
	}); 
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].getSelectionClear();
}
//menu new row event function
function add(referenceItem){
    items[referenceItem].addRow();
}
//menu remove event function
function modify(referenceItem){
    items[referenceItem].removeRow();
}
//menu remove event function
function remove(referenceItem){
    items[referenceItem].removeRow();
}
//menu rows clipboard copy event function
function copy(referenceItem){
    items[referenceItem].copyRowsClipboard('srows','\t');
}
//menu rows clipboard paste event function
function paste(referenceItem){
    items[referenceItem].addRowClipboard();
}
//(undo)
function undo(referenceItem){
    items[referenceItem].undo();
}
//(Redo)
function redo(referenceItem){
    items[referenceItem].redo();	
}
function findMessage(referenceItem){		
	uiCommon.message(ui.messagebox.messageBoxDivId,referenceItem.getUserData("","appMsg"));
	return true;
}
function onFormLoadEvent(){ 
	return true;
}
function doOnRowSelectedGrid2(rowId,cellId) {
	items['C104000020TAB03_Grid_1'].getDhxGrid().selectRowById(rowId);
}	
function doOnRowSelectedGrid1(rowId,cellId) {
	items['C104000020TAB03_Grid_2'].getDhxGrid().selectRowById(rowId);	
}	
function onGridLoadEvent1(){ 
    var grid2 =  items['C104000020TAB03_Grid_1'];
	var gridObj2 = items['C104000020TAB03_Grid_1'].getDhxGrid();	
	var mqlbndtststdcdCombo = gridObj2.getColumnCombo(11);	 //
		mqlbndtststdcdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=MQL_BND_TST_STD_CD&totalValue=&orderBy=value&displayType=all-code");   
		mqlbndtststdcdCombo.enableOptionAutoPositioning(true);
		mqlbndtststdcdCombo.readonly(true,true);
		mqlbndtststdcdCombo.setOptionHeight(100);
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB03_Grid_1',"find"); 
	items['C104000020TAB03_Grid_1'].loadData(findUrl,lockRowEvent); 
	items['C104000020TAB03_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C104000020TAB03_Grid_1'].getDhxGrid().detachEvent(_onXLE1);
	return false;
}
function onGridLoadEvent2(){ 
    var grid2 =  items['C104000020TAB03_Grid_2'];
	var gridObj2 = items['C104000020TAB03_Grid_2'].getDhxGrid();	
	var tstpicgthinstlocCombo = gridObj2.getColumnCombo(1);	 //
		tstpicgthinstlocCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=TST_PIC_GTH_INST_LOC&totalValue=&orderBy=value&displayType=all-code");   
		tstpicgthinstlocCombo.enableOptionAutoPositioning(true);
		tstpicgthinstlocCombo.readonly(true,true);
		tstpicgthinstlocCombo.setOptionHeight(80);

		//
		tstpicgthinstlocCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB03_Grid_1'].setCellByIndexValue(3,12,tstpicgthinstlocCombo.getSelectedValue());//
				items['C104000020TAB03_Grid_1'].setUpdated(items['C104000020TAB03_Grid_1'].getDhxGrid().getRowId(3),true,"updated"); 
		});  

	var trgrgsnoCombo = gridObj2.getColumnCombo(3);	 //
		trgrgsnoCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=TPG_RGS_NO&totalValue=&orderBy=value&displayType=all-code");   
		trgrgsnoCombo.enableOptionAutoPositioning(true);
		trgrgsnoCombo.readonly(true,true);
		trgrgsnoCombo.setOptionHeight(40);

		//
		trgrgsnoCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB03_Grid_1'].setCellByIndexValue(3,14,trgrgsnoCombo.getSelectedValue());//
				items['C104000020TAB03_Grid_1'].setUpdated(items['C104000020TAB03_Grid_1'].getDhxGrid().getRowId(3),true,"updated"); 
		});  

	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB03_Grid_2',"find"); 
	items['C104000020TAB03_Grid_2'].loadData(findUrl,lockRowEvent2);		
	items['C104000020TAB03_Grid_2'].getDhxGrid().detachEvent(_onXLE2);
	return false;
}
function onGridAfterUpdateFinishEvent(){
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB03_Grid_1',"find"); 
	items['C104000020TAB03_Grid_1'].loadData(findUrl,lockRowEvent); 
	findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB03_Grid_2',"find"); 
	items['C104000020TAB03_Grid_2'].loadData(findUrl,lockRowEvent2); 
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
function lockRowEvent(){
	var grid  = items['C104000020TAB03_Grid_1'].getDhxGrid();
	grid.setCellExcellType(grid.getRowId(0), 11, "ro");
	grid.setCellExcellType(grid.getRowId(1), 11, "ro");
	grid.setCellExcellType(grid.getRowId(2), 11, "ro");
	grid.setCellTextStyle(grid.getRowId(3),1,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),2,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),3,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),4,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),5,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),6,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),7,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),8,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),9,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),10,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(3),11,"background-color:#FFFFC0;");	
	grid.lockRow(grid.getRowId(0), true);
	grid.lockRow(grid.getRowId(1), true);
	grid.lockRow(grid.getRowId(2), true);
	uiCommon.progressOff(parent);
}
function lockRowEvent2(){
	var grid2  = items['C104000020TAB03_Grid_2'].getDhxGrid();
	grid2.setCellExcellType(grid2.getRowId(0), 1, "ro");
	grid2.setCellExcellType(grid2.getRowId(1), 1, "ro");
	grid2.setCellExcellType(grid2.getRowId(2), 1, "ro");
	grid2.setCellExcellType(grid2.getRowId(0), 3, "ro");
	grid2.setCellExcellType(grid2.getRowId(1), 3, "ro");
	grid2.setCellExcellType(grid2.getRowId(2), 3, "ro");
	
	grid2.lockRow(grid2.getRowId(0), true);
	grid2.lockRow(grid2.getRowId(1), true);
	grid2.lockRow(grid2.getRowId(2), true);
	grid2.setCellTextStyle(grid2.getRowId(3),1,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),2,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),3,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),4,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),5,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),6,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),7,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),8,"background-color:#FFFFC0;");
	grid2.setCellTextStyle(grid2.getRowId(3),9,"background-color:#FFFFC0;");
	uiCommon.progressOff(parent);
}
function onEditCellEvent2(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB03_Grid_1"];
	var gridObj = items["C104000020TAB03_Grid_1"].getDhxGrid();
	var grid2 = items["C104000020TAB03_Grid_2"];
	var gridObj2 = items["C104000020TAB03_Grid_2"].getDhxGrid();
	if(stage==2){
		if(isNull(nValue)){
			if(cInd == 2){ 
				grid.setCellByIndexValue(3,13,"");
			}else if(cInd == 4){ 
				grid.setCellByIndexValue(3,15,"");
			}else if(cInd == 5){ 						
				grid.setCellByIndexValue(3,16,"");
			}else if(cInd == 6){ 
				grid.setCellByIndexValue(3,17,"");
			}else if(cInd == 7){ 
				grid.setCellByIndexValue(3,18,"");
			}else if(cInd == 8){ 						
				grid.setCellByIndexValue(3,19,"");
			}else if(cInd == 9){ 
				grid.setCellByIndexValue(3,20,"");
			}
		}else{
			if(cInd == 2){ 						
				grid.setCellByIndexValue(3,13,nValue);
			}else if(cInd == 4){ 						
				grid.setCellByIndexValue(3,15,nValue);
			}else if(cInd == 5){ 
				grid.setCellByIndexValue(3,16,nValue);
			}else if(cInd == 6){ 
				grid.setCellByIndexValue(3,17,nValue);
			}else if(cInd == 7){ 						
				grid.setCellByIndexValue(3,18,nValue);
			}else if(cInd == 8){ 
				grid.setCellByIndexValue(3,19,nValue);
			}else if(cInd == 9){ 
				grid.setCellByIndexValue(3,20,nValue);
			}
		}
		grid.setUpdated(grid.getDhxGrid().getRowId(3),true,"updated"); 
		return true;
	}
   return true;
}

//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB03_Grid_1" style="position:absolute;height:140px;width:973px;left:1px;top:5px;">
</div>
<div id="C104000020TAB03_Grid_2" style="position:absolute;height:140px;width:973px;left:1px;top:190px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:973px;left:1px;top:429px;">
</div>
<div id="C104000020TAB03_Form_1" style="position:absolute;height:28px;width:975px;left:0px;top:152px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
       items['C104000020TAB03_Grid_1'].getDhxGrid().attachEvent("onRowSelect", doOnRowSelectedGrid1);
       items['C104000020TAB03_Grid_2'].getDhxGrid().attachEvent("onRowSelect", doOnRowSelectedGrid2);
       var _onXLE1 = items['C104000020TAB03_Grid_1'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent1);
       var _onXLE2 = items['C104000020TAB03_Grid_2'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent2);
	   items["C104000020TAB03_Grid_2"].onEditCellEvent(onEditCellEvent2);
//]]>
-->
</script>