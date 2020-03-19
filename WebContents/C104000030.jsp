<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000030.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-에러현황
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.12.16
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.12.16     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ORD_NO = request.getParameter("ORD_NO")	!=null ? request.getParameter("ORD_NO") : "";
	String ORD_LN = request.getParameter("ORD_LN")	!=null ? request.getParameter("ORD_LN") : "";
%>
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
      '{"itemType":"form","renderTo":"C104000030_Form_1","xml":".\/header\/kr\/C104000030\/C104000030_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000030_Grid_1","service":"C104000030-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C104000030_Grid_1","rowCnt":"22","xml":".\/header\/kr\/C104000030\/C104000030_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000030_Grid_1","service":"C104000030-service","actionType":"find"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C104000030\/messagebox.xml","service":"C104000030-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	// 날짜 관련 폼 데이터
	var fromDate = items['C104000030_Form_1'].getDhxForm().getInput('QLT_DSN_END_DH_STR').value;
	var toDate = items['C104000030_Form_1'].getDhxForm().getInput('QLT_DSN_END_DH_END').value;
	
	// 입력받을 타입을 검사
	fromDate = get_DateTypeDay(fromDate);
	toDate = get_DateTypeDay(toDate);
	
	if(fromDate == '' || toDate == ''){
		dhtmlx.alert({
            ok:"확인",
            text:"에러일자를 입력하지 않았습니다!",
            callback:function(val){
              if(val){
                items['C104000030_Form_1'].setItemFocus('QLT_DSN_END_DH_STR');
              }
           }
      	});
	  return ;
	}
	if(fromDate > toDate){
		dhtmlx.alert({
            ok:"확인",
            text:"에러일자를 잘못 입력하였습니다!",
            callback:function(val){
              if(val){
                items['C104000030_Form_1'].setItemFocus('QLT_DSN_END_DH_STR');
              }
           }
      	});
		return ;
	}

	var findUrl = uiCommon.parameters('C104000030_Form_1','C104000030_Grid_1',eventName); 
	items['C104000030_Grid_1'].loadData(findUrl); 
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C104000030_Form_1',referenceItem,'find');
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
	var inputObj = items["C104000030_Form_1"].getDhxForm().getInput("ORD_NO");

	inputObj.onkeyup = function(){
  		inputObj.value = inputObj.value.toUpperCase(); 	
	}	
		
	items['C104000030_Form_1'].setItemValue("ORD_NO","<%=ORD_NO%>");
	items['C104000030_Form_1'].setItemValue("ORD_LN","<%=ORD_LN%>");
	var ORD_NO = items['C104000030_Form_1'].getItemValue("ORD_NO");
	var ORD_LN = items['C104000030_Form_1'].getItemValue("ORD_LN");
	
	if(ORD_NO == "" && ORD_LN == "")
    {
		items['C104000030_Form_1'].setItemValue("QLT_DSN_END_DH_END",uiCommon.getCurrentDate());
	
		var QLT_DSN_END_DH_END = items['C104000030_Form_1'].getItemValue("QLT_DSN_END_DH_END");
		var QLT_DSN_END_DH_END = new Date(QLT_DSN_END_DH_END.substring(5,7)+"/"+QLT_DSN_END_DH_END.substring(8,10)+"/"+QLT_DSN_END_DH_END.substring(0,4)); 
		var QLT_DSN_END_DH_STR = dateAdd(QLT_DSN_END_DH_END,-1);
		items['C104000030_Form_1'].setItemValue("QLT_DSN_END_DH_STR",QLT_DSN_END_DH_STR);
		
		//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
		items['C104000030_Form_1'].getItem("QLT_DSN_END_DH_STR").setWeekStartDay(7);
		items['C104000030_Form_1'].getItem("QLT_DSN_END_DH_END").setWeekStartDay(7);
    }
	
	return false;
}
function onGridLoadEvent(){ 
	var ORD_NO = items['C104000030_Form_1'].getItemValue("ORD_NO");
	var ORD_LN = items['C104000030_Form_1'].getItemValue("ORD_LN");
	var QLT_DSN_END_DH_STR = items['C104000030_Form_1'].getItemValue("QLT_DSN_END_DH_STR");
	var QLT_DSN_END_DH_END = items['C104000030_Form_1'].getItemValue("QLT_DSN_END_DH_END");

	if(ORD_NO != "" && ORD_LN != "")
    {
		var findUrl = uiCommon.parameters('C104000030_Form_1','C104000030_Grid_1',"find"); 
		items['C104000030_Grid_1'].loadData(findUrl); 
    }else if(!isNull(QLT_DSN_END_DH_STR) && !isNull(QLT_DSN_END_DH_END)){
		var findUrl = uiCommon.parameters('C104000030_Form_1','C104000030_Grid_1',"find"); 
		items['C104000030_Grid_1'].loadData(findUrl); 
	}
	items['C104000030_Grid_1'].getDhxGrid().detachEvent(_onXLE);
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
<div id="C104000030_Form_1" style="position:absolute;height:31px;width:981px;left:0px;top:0px;">
</div>
<div id="C104000030_Grid_1" style="position:absolute;height:530px;width:977px;left:1px;top:36px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
    items['C104000030_Form_1'].onXLEEvent(onFormLoadEvent);
	var _onXLE =  items['C104000030_Grid_1'].onXLEEvent(onGridLoadEvent);
    items['C104000030_Form_1'].setBackgroundColor("#FFFFFF");
//]]>
-->
</script>