<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000180.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계 수정이력현황
 * DESIGNER NAME    :  이 돈 석
 * DEVELOPER NAME   :  이 돈 석
 * CREATE DATE      :  2023.09.21
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2023.09.21     V1.0      이돈석      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000180_Form_1","xml":".\/header\/kr\/C106000180\/C106000180_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000180_Grid_1","service":"C106000180-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C106000180_Grid_1","rowCnt":"22","xml":".\/header\/kr\/C106000180\/C106000180_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000180_Grid_1","service":"C106000180-service","actionType":"find"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C106000180\/messagebox.xml","service":"C106000180-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	// 날짜 관련 폼 데이터
	var fromDate = items['C106000180_Form_1'].getDhxForm().getInput('MDF_DH_STR').value;
	var toDate = items['C106000180_Form_1'].getDhxForm().getInput('MDF_DH_END').value;
	
	// 입력받을 타입을 검사
	fromDate = get_DateTypeDay(fromDate);
	toDate = get_DateTypeDay(toDate);
	
	if(fromDate == '' || toDate == ''){
		dhtmlx.alert({
            ok:"확인",
            text:"일자를 입력하지 않았습니다!",
            callback:function(val){
              if(val){
                items['C106000180_Form_1'].setItemFocus('MDF_DH_STR');
              }
           }
      	});
	  return ;
	}
	if(fromDate > toDate){
		dhtmlx.alert({
            ok:"확인",
            text:"일자를 잘못 입력하였습니다!",
            callback:function(val){
              if(val){
                items['C106000180_Form_1'].setItemFocus('MDF_DH_STR');
              }
           }
      	});
		return ;
	}

	var findUrl = uiCommon.parameters('C106000180_Form_1','C106000180_Grid_1',eventName); 
	items['C106000180_Grid_1'].loadData(findUrl); 
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C106000180_Form_1',referenceItem,'find');
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
	var inputObj = items["C106000180_Form_1"].getDhxForm().getInput("ORD_NO");

	inputObj.onkeyup = function(){
  		inputObj.value = inputObj.value.toUpperCase(); 	
	}	
		

	items['C106000180_Form_1'].setItemValue("MDF_DH_END",uiCommon.getCurrentDate());

	var MDF_DH_END_TMP = items['C106000180_Form_1'].getItemValue("MDF_DH_END");
	var MDF_DH_END = new Date(MDF_DH_END_TMP.substring(5,7)+"/"+MDF_DH_END_TMP.substring(8,10)+"/"+MDF_DH_END_TMP.substring(0,4)); 
	var MDF_DH_STR = dateAdd(MDF_DH_END,-1);
	items['C106000180_Form_1'].setItemValue("MDF_DH_STR",MDF_DH_STR);
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	items['C106000180_Form_1'].getItem("MDF_DH_STR").setWeekStartDay(7);
	items['C106000180_Form_1'].getItem("MDF_DH_END").setWeekStartDay(7);

	
	return false;
}
function onGridLoadEvent(){ 

	var findUrl = uiCommon.parameters('C106000180_Form_1','C106000180_Grid_1',"find"); 
	items['C106000180_Grid_1'].loadData(findUrl); 

	items['C106000180_Grid_1'].getDhxGrid().detachEvent(_onXLE);
}
function dateAdd(date, addDay) {
 
    var nowDate = date;
    var addDate = nowDate.getTime() + (addDay * 24 * 60 * 60 * 1000);
    nowDate.setTime(addDate);
 
    var year = nowDate.getFullYear();
    var month = nowDate.getMonth() + 1;
    var date = nowDate.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
 
    return year + "-" + month + "-" + date;
 
}

function doOnRowDblClicked(rowId) {
	//var ORD_NO = items['C106000180_Grid_1'].getDhxGrid().cells(rowId,0).getValue();
	//var ORD_LN = items['C106000180_Grid_1'].getDhxGrid().cells(rowId,1).getValue();
	//parent.newRemoveOpenTab("C104000020","ORD_NO=" + ORD_NO + "&ORD_LN=" +ORD_LN);
}


function winClose(){
	if(typeof(parent.winObj) !== 'undefined'){
		parent.winObj.winClose();					
	}else{
		parent.tabClose();
	}
}
//]]>
-->
</script>
</head>
<body>
<div id="C106000180_Form_1" style="position:absolute;height:31px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000180_Grid_1" style="position:absolute;height:530px;width:977px;left:1px;top:36px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
    items['C106000180_Form_1'].onXLEEvent(onFormLoadEvent);
	var _onXLE =  items['C106000180_Grid_1'].onXLEEvent(onGridLoadEvent);
    items['C106000180_Form_1'].setBackgroundColor("#FFFFFF");
    items["C106000180_Grid_1"].rowDblClicked(doOnRowDblClicked);
//]]>
-->
</script>