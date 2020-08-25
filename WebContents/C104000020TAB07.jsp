<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB07.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-칼라제조사양
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.12.09
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.12.09     V1.0      박재영      Initial Version
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
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript">
</script>
<style media="screen" type="text/css">
.form_cell{
  background-image:url(./dhtmlx/codebase/imgs/clouds_grid.gif);
  /*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
  border-color:#FDFDFD #BABABA #BABABA #FDFDFD !important;  
  border-style:solid !important;
  border-width:1px !important;
 }
.form_cell1{
 background-image:url(./dhtmlx/codebase/imgs/sky_blue_grid.gif);
 /*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
 border-color:#FDFDFD #BABABA #BABABA #FDFDFD !important;  
 border-style:solid !important;
 border-width:1px !important;
}
</style>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_1","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"find"},' +
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_2","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"save"},' +
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_3","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_3.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"find"},' +
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_4","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_4.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"find"},' +
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_5","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_5.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"find"},' +
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_6","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_6.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"find"},' +
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_7","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_7.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"find"},' +
'{"itemType":"grid","renderTo":"C104000020TAB07_Grid_8","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Grid_8.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB07_Grid_8","service":"C104000020TAB07-service","actionType":"save"},' +
'{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C104000020TAB07\/messagebox.xml","service":"C104000020TAB07-service"},' +
'{"itemType":"form","renderTo":"C104000020TAB07_Form_1","xml":".\/header\/kr\/C104000020TAB07\/C104000020TAB07_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020TAB07_Form_1","service":"C104000020TAB07-service","security":"true","actionType":"save"}' +
']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	upt_clear();
    var param = parameters13('C104000020_Form_1','C104000020TAB07_Grid_1','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_1',xmlObj);  
	param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_2','C104000020TAB07-service','find');
	xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_2',xmlObj);
		uiCommon.renderToGrid('C104000020TAB07_Grid_3',xmlObj);
		uiCommon.renderToGrid('C104000020TAB07_Grid_4',xmlObj);
		uiCommon.renderToGrid('C104000020TAB07_Grid_5',xmlObj);
		uiCommon.renderToGrid('C104000020TAB07_Grid_6',xmlObj);
		uiCommon.renderToGrid('C104000020TAB07_Grid_8',xmlObj);
	param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_7','C104000020TAB07-service','CMN_find');
	xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
	    uiCommon.renderToGrid('C104000020TAB07_Grid_7',xmlObj);
}
function save(eventName,formDivObj,referenceItem){
	var gridObj2 = items['C104000020TAB07_Grid_2'].getDhxGrid();
	var gridObj8 = items['C104000020TAB07_Grid_8'].getDhxGrid();
	var chgCnt = 0;
	var cclqltmsgtxt = "";
	
	// 현재입력 Cell에서 강제 포커스 이동시켜 변경상태를 인지토록 함
	var rowId2 = items['C104000020TAB07_Grid_2'].getRowSelectedId();
  	gridObj2.selectRow(gridObj2.getRowIndex(rowId2));
	var rowId8 = items['C104000020TAB07_Grid_8'].getRowSelectedId();
  	gridObj8.selectRow(gridObj8.getRowIndex(rowId8));  	
  	
	var row_status2 = "", row_status8 = "";
	row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
	row_status8 = gridObj8.getUserData(gridObj8.getRowId(0),"!nativeeditor_status");
	if( row_status2 == "updated" || row_status8 == "updated"){	
    	chgCnt++;
    	/* 확정된 주문이라도 수정할수 있도록 수정 : 박성용요청 20140611
		var parentForm = parent.items['C104000020_Form_1'];
		var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
		var ord_no = parentForm.getItemValue("ORD_NO");
		var param1= "ServiceName=C104000020TAB07-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		if(cells1.length > 0){						
			dhtmlx.alert("확정된 주문입니다!");
			return;					
		}
		*/
    }
	
	if(chgCnt === 0 ){
		dhtmlx.alert("변경된 데이터가 없습니다.");
		return;
	}else{
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"저장 하시겠습니까?",
			callback:function(val){
				if(val){			
					
					//목표두께/폭 수정
					var gridObj = items['C104000020TAB07_Grid_2'].getDhxGrid();
					var row_status = "";
					row_status = gridObj.getUserData(gridObj.getRowId(0),"!nativeeditor_status");
					if(row_status != "" && row_status == "updated" ){
					    items['C104000020TAB07_Grid_2'].sendGrid('C104000020TAB07_Grid_2',"save");					
				    }
				    
				    //품질메세지 수정
					var gridObj1 = items['C104000020TAB07_Grid_8'].getDhxGrid();
					var row_status1 = "";
					row_status1 = gridObj1.getUserData(gridObj1.getRowId(0),"!nativeeditor_status");
					if(row_status1 != "" && row_status1 == "updated" ){
						cclqltmsgtxt = items['C104000020TAB07_Grid_8'].getCellValue(0,1);
						if(cclqltmsgtxt.indexOf('=""')>0){
							alert("품질메시지에 이상한 문자가 있습니다(indexOf). 수정해주세요.");
							popCompleteYN = "N";
							return;
						}
					    items['C104000020TAB07_Grid_8'].sendGrid('C104000020TAB07_Grid_8',"MSG_save");					
				    }
					return;
				}
			}
		}); 
	}
}
 
//메세지 cclbom에 저장
function MSG_sync(eventName,formDivObj,referenceItem){								
	
	dhtmlx.confirm({							
		title:"[[ 메세지 동기화처리 ]]",						
		ok:"동기화", cancel:"취소",						
		text:"CCL BOM메시지와  동기화하시겠습니까?",						
		callback:function(val){						
			 if(val){					

			    //강제로 updated로 해서 저장처리 
			    items["C104000020TAB07_Grid_8"].setUpdated(0,"true","updated");
				  	
				items['C104000020TAB07_Grid_8'].sendGrid('C104000020TAB07_Grid_8',"MSG_sync");												
				return;				
			 }					
		}						
	});		
}
//신뢰성 시험 대상재 등록
function truTest_save(){
	var parentForm = parent.items['C104000020_Form_1'];		
	var ORD_NO="", ORD_LN="";
	var ORD_NO = parentForm.getItemValue("ORD_NO");
	var ORD_LN = parentForm.getItemValue("ORD_LN");
 
	winObj = new ui.window("popup","대상등록","0","0","310","232","C104000020TAB07pop01.jsp?ORD_NO="+ORD_NO+"&ORD_LN="+ORD_LN);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();

	setPopupStyle(['top'], ['300']);

	winObj.getDhxWindow().attachEvent("onClose", function(win){
		this.hide();
		return true;
	});
}
function setPopupStyle(arrKey, arrVal) {
 var style = winObj.getDhxWindow().getAttribute('style').split(';');
 for(var i = 0; i < style.length - 1; i++) {
  for(var j = 0; j < arrKey.length; j++) {
   if(style[i].indexOf(arrKey[j]) >= 0)
    style[i] = ' ' + arrKey[j] + ': ' + arrVal[j] + 'px';
  }
 }
 return winObj.getDhxWindow().setAttribute('style', style.join(';'));
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C104000020TAB07_Form_1',referenceItem,'find');
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
function findMessage(referenceItem){		
	uiCommon.message(ui.messagebox.messageBoxDivId,referenceItem.getUserData("","appMsg"));
	return true;
}
function onFormLoadEvent(){ 
	return true;
}
function onRowSelect_Grid1(id,ind){ 
       items['C104000020TAB07_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_7'].getDhxGrid().clearSelection();	
       items['C104000020TAB07_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid2(id,ind){ 
       items['C104000020TAB07_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_7'].getDhxGrid().clearSelection();       
       items['C104000020TAB07_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid3(id,ind){ 
       items['C104000020TAB07_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_7'].getDhxGrid().clearSelection();       
       items['C104000020TAB07_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid4(id,ind){ 
       items['C104000020TAB07_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_7'].getDhxGrid().clearSelection();       
       items['C104000020TAB07_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid5(id,ind){ 
       items['C104000020TAB07_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_7'].getDhxGrid().clearSelection();       
       items['C104000020TAB07_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid6(id,ind){ 
       items['C104000020TAB07_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_7'].getDhxGrid().clearSelection();       
       items['C104000020TAB07_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid7(id,ind){ 
       items['C104000020TAB07_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_6'].getDhxGrid().clearSelection();  
       items['C104000020TAB07_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid8(id,ind){ 
       items['C104000020TAB07_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB07_Grid_7'].getDhxGrid().clearSelection();          
      
}
function onGridLoadEvent1(){ 
    var param = parameters13('C104000020_Form_1','C104000020TAB07_Grid_1','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_1',xmlObj);  
	items['C104000020TAB07_Grid_1'].getDhxGrid().detachEvent(_onXLE1);
	return false;
}
function onGridLoadEvent2(){ 
	var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_2','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_2',xmlObj);
		uiCommon.renderToGrid('C104000020TAB07_Grid_8',xmlObj);
	items['C104000020TAB07_Grid_2'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
	items['C104000020TAB07_Grid_2'].getDhxGrid().detachEvent(_onXLE2);
	return false;
}
function onGridAfterUpdateFinishEvent2(){
	var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_2','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_2',xmlObj);
}
function onGridLoadEvent3(){ 
	var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_3','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_3',xmlObj);
	items['C104000020TAB07_Grid_3'].getDhxGrid().detachEvent(_onXLE3);
	return false;
}
function onGridLoadFunction4(){
	items["C104000020TAB07_Grid_4"].getDhxGrid().rowsAr[0].style.height="24px";
	items["C104000020TAB07_Grid_4"].getDhxGrid().rowsAr[1].style.height="24px";
	var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_4','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_4',xmlObj);
	items['C104000020TAB07_Grid_4'].getDhxGrid().detachEvent(onXleGrid4);
}
function onGridLoadFunction5(){
	var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_5','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_5',xmlObj);
	items['C104000020TAB07_Grid_5'].getDhxGrid().detachEvent(onXleGrid5);
}
function onGridLoadFunction6(){
	items["C104000020TAB07_Grid_6"].getDhxGrid().rowsAr[0].style.height="24px";
	items["C104000020TAB07_Grid_6"].getDhxGrid().rowsAr[1].style.height="24px";
	var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_6','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_6',xmlObj);
	items['C104000020TAB07_Grid_6'].getDhxGrid().detachEvent(onXleGrid6);
}
function onGridLoadEvent7(){ 
    var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_7','C104000020TAB07-service','CMN_find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_7',xmlObj);  
	items['C104000020TAB07_Grid_7'].getDhxGrid().detachEvent(_onXLE7);
	return false;
}
function onGridLoadEvent8(){ 
	var param = parameters12('C104000020_Form_1','C104000020TAB07_Grid_2','C104000020TAB07-service','find');
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB07_Grid_2',xmlObj);
		uiCommon.renderToGrid('C104000020TAB07_Grid_8',xmlObj);
    items['C104000020TAB07_Grid_8'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);		
	items['C104000020TAB07_Grid_8'].getDhxGrid().detachEvent(_onXLE8);
	
	document.getElementById("C104000020TAB07_Grid_8").onmousemove = function(event) { event.target.title = event.target.innerText; }
	return false;
}
function upt_clear(){
	var grid = items['C104000020TAB07_Grid_2'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB07_Grid_8'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
}
function onEditCellEvent2(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB07_Grid_2"];
	var gridObj = items["C104000020TAB07_Grid_2"].getDhxGrid();
	if(stage==1){
		if(cInd == 9) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("두께",2,3,true,this.value)){
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
		}else if( cInd == 10 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("폭",4,1,true,this.value)){
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
	}
   return true;
}
//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB07_Grid_1" style="position:absolute;height:250px;width:956px;left:1px;top:0px;">
</div>
<div id="C104000020TAB07_Grid_2" style="position:absolute;height:74px;width:956px;left:1px;top:253px;">
</div>
<div id="C104000020TAB07_Grid_3" style="position:absolute;height:180px;width:171px;left:1px;top:329px;">
</div>
<div id="C104000020TAB07_Grid_4" style="position:absolute;height:180px;width:250px;left:175px;top:329px;">
</div>
<div id="C104000020TAB07_Grid_5" style="position:absolute;height:180px;width:277px;left:428px;top:329px;">
</div>
<div id="C104000020TAB07_Grid_6" style="position:absolute;height:180px;width:249px;left:708px;top:329px;">
</div>
<div id="C104000020TAB07_Grid_7" style="position:absolute;height:44px;width:857px;left:1px;top:512px;">
</div>
<div id="C104000020TAB07_Grid_8" style="position:absolute;height:50px;width:857px;left:1px;top:563px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:956px;left:1px;top:615px;">
</div>
<div id="C104000020TAB07_Form_1" style="position:absolute;height:80px;width:98px;left:861px;top:531px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
       items['C104000020TAB07_Form_1'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB07_Grid_1'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid1);
       items['C104000020TAB07_Grid_2'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid2);
       items['C104000020TAB07_Grid_3'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid3);
       items['C104000020TAB07_Grid_4'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid4);
       items['C104000020TAB07_Grid_5'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid5);
       items['C104000020TAB07_Grid_6'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid6); 
       items['C104000020TAB07_Grid_7'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid7);        
       items['C104000020TAB07_Grid_8'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid8); 
	   
       var _onXLE1 = items['C104000020TAB07_Grid_1'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent1);
       var _onXLE2 = items['C104000020TAB07_Grid_2'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent2);
       var _onXLE3 = items['C104000020TAB07_Grid_3'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent3);
	   var onXleGrid4 = items['C104000020TAB07_Grid_4'].onXLEEvent(onGridLoadFunction4); 
	   var onXleGrid5 = items['C104000020TAB07_Grid_5'].onXLEEvent(onGridLoadFunction5); 
	   var onXleGrid6 = items['C104000020TAB07_Grid_6'].onXLEEvent(onGridLoadFunction6); 
       var _onXLE7 = items['C104000020TAB07_Grid_7'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent7);
       var _onXLE8 = items['C104000020TAB07_Grid_8'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent8);
	   items["C104000020TAB07_Grid_2"].onEditCellEvent(onEditCellEvent2);
//]]>
-->
</script>