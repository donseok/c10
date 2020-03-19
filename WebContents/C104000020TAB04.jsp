<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB04.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-인수도
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
<style media="screen" type="text/css">
/*custom styling for the first column*/
.form_cell{
 background-image:url(./dhtmlx/codebase/imgs/sky_blue_grid.gif);
 /*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
 border-color:#FDFDFD #BABABA #BABABA #FDFDFD !important;  
 border-style:solid !important;
 border-width:1px !important;
}
.form_cell1{
 background-image:url(./dhtmlx/codebase/imgs/clouds_grid.gif);
 /*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
 border-color:#FDFDFD #BABABA #BABABA #FDFDFD !important;  
 border-style:solid !important;
 border-width:1px !important;
}
.even{
 background-color:#FFFFFF;
}
.uneven{
 background-color:#FFFFFF;
}
div.gridbox_dhx_skyblue.odd_dhx_skyblue{background-color:#FFFFFF;}  
</style>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C104000020TAB04_Grid_1","xml":".\/header\/kr\/C104000020TAB04\/C104000020TAB04_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB04_Grid_1","service":"C104000020TAB04-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C104000020TAB04\/messagebox.xml","service":"C104000020TAB04-service"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB04_Grid_2","xml":".\/header\/kr\/C104000020TAB04\/C104000020TAB04_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB04_Grid_2","service":"C104000020TAB04-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB04_Grid_3","xml":".\/header\/kr\/C104000020TAB04\/C104000020TAB04_Grid_3.xml","rowCnt":"0","vertical":"false","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"false","split":"0","referenceItem":"C104000020TAB04_Grid_3","service":"C104000020TAB04-service","actionType":"save"},' +
      '{"itemType":"form","renderTo":"C104000020TAB04_Form_1","xml":".\/header\/kr\/C104000020TAB04\/C104000020TAB04_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020TAB04_Form_1","service":"C104000020TAB04-service","security":"true"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"/dhtmlx/codebase/imgs/"};
//form find button item event function (requred)
function find(eventName){ 
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_1',eventName); 
	items['C104000020TAB04_Grid_1'].loadData(findUrl, function(){
	       var findUrl1 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_2',eventName); 
	   	items['C104000020TAB04_Grid_2'].loadData(findUrl1,lockRowEvent2);
	},lockRowEvent); 
	var ord_no = parent.items['C104000020_Form_1'].getItemValue("ORD_NO");
	var ord_ln = parent.items['C104000020_Form_1'].getItemValue("ORD_LN");
	var customparam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};	
	var param = varticalParameters('C104000020TAB04_Grid_3','C104000020TAB04-service',"ajaxFind",customparam);
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
	uiCommon.renderToGrid('C104000020TAB04_Grid_3',xmlObj);  //색상코드Grid 초기화   
}
function save(eventName,formDivObj,referenceItem){
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	var param1= "ServiceName=C104000020TAB04-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
	var cells1 = xmlObj1.getElementsByTagName("cell");
	if(cells1.length > 0){						
		alert("확정된 주문입니다!");
		return;					
	}				
	
	items['C104000020TAB04_Grid_3'].setUpdated(items['C104000020TAB04_Grid_3'].getDhxGrid().getRowId(3),false,""); 
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){
				var gridObj = items['C104000020TAB04_Grid_1'].getDhxGrid();
				var row_status = "";
				row_status = gridObj.getUserData(gridObj.getRowId(2),"!nativeeditor_status");
				if(row_status != "" && row_status == "updated" )
			    {
				    items['C104000020TAB04_Grid_1'].sendGrid('C104000020TAB04_Grid_1',"DLV_save");					
			    }
				else
			    {
					var gridObj1 = items['C104000020TAB04_Grid_3'].getDhxGrid();
					row_status1 = gridObj1.getUserData(gridObj1.getRowId(2),"!nativeeditor_status");
					if(row_status1 != "" && row_status1 == "updated" )
			        {
					    items['C104000020TAB04_Grid_3'].sendGrid('C104000020TAB04_Grid_3',"RNG_save");
			        }
			    }
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
	items['C104000020TAB04_Grid_1'].getDhxGrid().selectRowById(rowId);
}	
function doOnRowSelectedGrid1(rowId,cellId) {
	items['C104000020TAB04_Grid_2'].getDhxGrid().selectRowById(rowId);	
}	
function onGridLoadEvent1(){ 
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_1',"find"); 
	items['C104000020TAB04_Grid_1'].loadData(findUrl,lockRowEvent); 
	items['C104000020TAB04_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent1);
	items['C104000020TAB04_Grid_1'].getDhxGrid().detachEvent(_onXLE1);
	return false;
}
function onGridLoadEvent2(){ 
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_2',"find"); 
	items['C104000020TAB04_Grid_2'].loadData(findUrl,lockRowEvent2); 
	items['C104000020TAB04_Grid_2'].getDhxGrid().detachEvent(_onXLE2);
	return false;
}
function onGridLoadEvent3(){ 
	var ord_no = parent.items['C104000020_Form_1'].getItemValue("ORD_NO");
	var ord_ln = parent.items['C104000020_Form_1'].getItemValue("ORD_LN");
	var customparam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};	
	var param = varticalParameters('C104000020TAB04_Grid_3','C104000020TAB04-service',"ajaxFind",customparam);
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
	uiCommon.renderToGrid('C104000020TAB04_Grid_3',xmlObj);  //색상코드Grid 초기화   
	items['C104000020TAB04_Grid_3'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent3);
	items['C104000020TAB04_Grid_3'].getDhxGrid().detachEvent(_onXLE3);
}

function onGridAfterUpdateFinishEvent1(){
	var gridObj1 = items['C104000020TAB04_Grid_3'].getDhxGrid();
	var row_status1 = gridObj1.getUserData(gridObj1.getRowId(2),"!nativeeditor_status");
	if(row_status1 != "" && row_status1 == "updated" )
    {
	    items['C104000020TAB04_Grid_3'].sendGrid('C104000020TAB04_Grid_3',"RNG_save");
    }
	else
    {
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_1',"find"); 
		items['C104000020TAB04_Grid_1'].loadData(findUrl,lockRowEvent); 
		findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_2',"find"); 
		items['C104000020TAB04_Grid_2'].loadData(findUrl,lockRowEvent2); 
    }
}

function onGridAfterUpdateFinishEvent3(){
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_1',"find"); 
	items['C104000020TAB04_Grid_1'].loadData(findUrl,lockRowEvent); 
	findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB04_Grid_2',"find"); 
	items['C104000020TAB04_Grid_2'].loadData(findUrl,lockRowEvent2); 
	var ord_no = parent.items['C104000020_Form_1'].getItemValue("ORD_NO");
	var ord_ln = parent.items['C104000020_Form_1'].getItemValue("ORD_LN");
	var customparam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};	
	var param = varticalParameters('C104000020TAB04_Grid_3','C104000020TAB04-service',"ajaxFind",customparam);
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
	uiCommon.renderToGrid('C104000020TAB04_Grid_3',xmlObj);  //색상코드Grid 초기화   
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
	var grid  = items['C104000020TAB04_Grid_1'].getDhxGrid();
	grid.lockRow(grid.getRowId(0), true);
	grid.lockRow(grid.getRowId(1), true);
	grid.setCellTextStyle(grid.getRowId(2),1,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),2,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),3,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),4,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),5,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),6,"background-color:#FFFFC0;");	
	uiCommon.progressOff(parent);
}
function lockRowEvent2(){
	var grid  = items['C104000020TAB04_Grid_2'].getDhxGrid();
	grid.lockRow(grid.getRowId(0), true);
	grid.lockRow(grid.getRowId(1), true);
	grid.setCellTextStyle(grid.getRowId(2),1,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),2,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),3,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),4,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),5,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),6,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),7,"background-color:#FFFFC0;");
	grid.setCellTextStyle(grid.getRowId(2),8,"background-color:#FFFFC0;");
	
	uiCommon.progressOff(parent);
}
function onEditCellEvent2(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB04_Grid_1"];
	var gridObj = items["C104000020TAB04_Grid_1"].getDhxGrid();
	if(stage==2){
		if(isNull(nValue)){
			if(cInd == 1){ 
				grid.setCellByIndexValue(2,7,"");
			}else if(cInd == 2){ 
				grid.setCellByIndexValue(2,8,"");
			}else if(cInd == 3){ 						
				grid.setCellByIndexValue(2,9,"");
			}else if(cInd == 4){ 
				grid.setCellByIndexValue(2,10,"");
			}else if(cInd == 5){ 
				grid.setCellByIndexValue(2,11,"");
			}else if(cInd == 6){ 						
				grid.setCellByIndexValue(2,12,"");
			}else if(cInd == 7){ 
				grid.setCellByIndexValue(2,13,"");
			}else if(cInd == 8){ 
				grid.setCellByIndexValue(2,14,"");
			}
		}else{
			if(cInd == 1){ 
				grid.setCellByIndexValue(2,7,nValue);
			}else if(cInd == 2){ 
				grid.setCellByIndexValue(2,8,nValue);
			}else if(cInd == 3){ 						
				grid.setCellByIndexValue(2,9,nValue);
			}else if(cInd == 4){ 
				grid.setCellByIndexValue(2,10,nValue);
			}else if(cInd == 5){ 
				grid.setCellByIndexValue(2,11,nValue);
			}else if(cInd == 6){ 						
				grid.setCellByIndexValue(2,12,nValue);
			}else if(cInd == 7){ 
				grid.setCellByIndexValue(2,13,nValue);
			}else if(cInd == 8){ 
				grid.setCellByIndexValue(2,14,nValue);
			}
		}
		grid.setUpdated(grid.getDhxGrid().getRowId(2),true,"updated"); 
		return true;
	}
   return true;
}

function onEditCellEvent3(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB04_Grid_3"];
	var gridObj = items["C104000020TAB04_Grid_3"].getDhxGrid();
	
	if(stage==1){ 	//수정전
		if(cInd == 2 || cInd == 3) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("두께목표,하한,상한",2,3,true,this.value)){						
						if(this.value.length > 5){
							gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;							
						return true;
					}				
				}
			}
		}else if( cInd == 4 || cInd == 5 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("폭수치",4,1,true,this.value)){
						if(this.value.length > 5){
							gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;							
						return true;
					}				
				}
			}
		}else if( cInd == 6 || cInd == 7 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("길이수치",4,1,true,this.value)){
						if(this.value.length > 5){
							gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;							
						return true;
					}				
				}
			}
		}else{
			return true;
		}
	}else if(stage==2){  //수정후
		if(isNull(nValue)){
		    if(gridObj.getRowIndex(rId) == 3)
		    {
				if(cInd == 2){ 
					grid.setCellByIndexValue(2,8,"");
				}else if(cInd == 3){ 
					grid.setCellByIndexValue(2,9,"");
				}
			}
		}else{
		    if(gridObj.getRowIndex(rId) == 3)
		    {
				if(cInd == 2){ 
					grid.setCellByIndexValue(2,8,nValue);
				}else if(cInd == 3){ 
					grid.setCellByIndexValue(2,9,nValue);
				}
			}
		}
		grid.setUpdated(grid.getDhxGrid().getRowId(2),true,"updated"); 
		return true;
	}
   return true;
}

//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB04_Grid_1" style="position:absolute;height:118px;width:973px;left:1px;top:5px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:973px;left:1px;top:429px;">
</div>
<div id="C104000020TAB04_Grid_2" style="position:absolute;height:106px;width:973px;left:1px;top:297px;">
</div>
<div id="C104000020TAB04_Grid_3" style="position:absolute;height:88px;width:975px;left:1px;top:160px;">
</div>
<div id="C104000020TAB04_Form_1" style="position:absolute;height:28px;width:975px;left:0px;top:124px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
       items['C104000020TAB04_Grid_1'].getDhxGrid().attachEvent("onRowSelect", doOnRowSelectedGrid1);
       items['C104000020TAB04_Grid_2'].getDhxGrid().attachEvent("onRowSelect", doOnRowSelectedGrid2);
       var _onXLE1 = items['C104000020TAB04_Grid_1'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent1);
       var _onXLE2 = items['C104000020TAB04_Grid_2'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent2);
	   var _onXLE3 = items['C104000020TAB04_Grid_3'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent3);
	   items["C104000020TAB04_Grid_2"].onEditCellEvent(onEditCellEvent2);
	   items["C104000020TAB04_Grid_3"].onEditCellEvent(onEditCellEvent3);
//]]>
-->
</script>