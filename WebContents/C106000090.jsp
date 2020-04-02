<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000090.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  코드사용조회
 * DESIGNER NAME    :  김종화                              
 * DEVELOPER NAME   :  김종화
 * CREATE DATE      :  2014.03.04
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2014.03.04     V1.0     김종화	 최초작성
 * 2019.01.16     V1.0     전경진	 수정작성  
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String rollCd = request.getParameter("ROLL_CD") != null? request.getParameter("ROLL_CD") : "";
%>    

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
코드사용조회
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000090_Form_1","xml":".\/header\/kr\/C106000090\/C106000090_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000090_Grid_1","service":"C106000090-service","actionType":"find","security":"true"},' +
      '{"itemType":"form","renderTo":"C106000090_Form_2","xml":".\/header\/kr\/C106000090\/C106000090_Form_2.xml","url":"basicGridData.do","referenceItem":"C106000090_Grid_1","service":"C106000090-service"},' +
      '{"itemType":"grid","renderTo":"C106000090_Grid_1","xml":".\/header\/kr\/C106000090\/C106000090_Grid_1.xml","rowCnt":"22","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000090_Form_1","service":"C106000090-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000090_messagebox","xml":".\/header\/kr\/C106000090\/C106000090_messagebox.xml","service":"C106000090-service"},' +
      '{"itemType":"grid","renderTo":"C106000090_Grid_2","xml":".\/header\/kr\/C106000090\/C106000090_Grid_2.xml","rowCnt":"22","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000090_Form_1","service":"C106000090-service","actionType":"save"},' +
      '{"itemType":"menu","renderTo":"C106000090_Menu_2","xml":".\/header\/kr\/C106000090\/C106000090_Menu_2.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000090_Grid_2","service":"C106000090-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var rollCd = '<%=rollCd%>';

//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
	
	
	var formObj = items['C106000090_Form_1'].getDhxForm();
	var radioValue = formObj.getItemValue("SEARCH_CD_SEL");
	items['C106000090_Grid_1'].getDhxGrid().clearAll();	
	if( radioValue == "1" ){	
		var useFindUrl = 
		items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindcolor=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}else if(radioValue == "2"){	
		var useFindUrl = 
		items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindcclbom=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}else if(radioValue == "3"){	
		var useFindUrl = 
		items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindrsntp=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}else if(radioValue == "4"){	
		var useFindUrl = 
			items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindcclbom1=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}else if(radioValue == "5"){	
		var useFindUrl = 
			items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindcclbom2=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}else if(radioValue == "6"){	
		var useFindUrl = 
			items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindInk=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}
	else if(radioValue == "7"){	
		var useFindUrl = 
			items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindFlm=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}
	else if(radioValue == "8"){	
		var useFindUrl = 
			items['C106000090_Form_1'].getServiceUrl()+"?ServiceName="+items['C106000090_Form_1'].getServiceName()+"&useFindBnd=1&column-info="+items['C106000090_Grid_2'].getColumnInfo()+"&blank-row-count="+items['C106000090_Grid_2'].getBlankRowCntInfo();	
	}

	items["C106000090_Grid_2"].loadData(useFindUrl,"");	
}

function useFindcolor(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindcolor');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

function useFindcclbom(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindcclbom');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

function useFindrsntp(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindrsntp');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

function useFindcclbom1(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindcclbom1');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

function useFindcclbom2(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindcclbom2');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

function useFindInk(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindInk');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

function useFindFlm(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindFlm');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

function  useFindBnd(){
	var prdFindUrl =  uiCommon.parameters('C106000090_Form_1','C106000090_Grid_2','useFindBnd');
	items["C106000090_Grid_2"].loadData(prdFindUrl);
	uiCommon.progressOff(parent);
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
	var formObj = items['C106000090_Form_1'].getDhxForm();
	var radioValue = formObj.getItemValue("SEARCH_CD_SEL");

	//getSelectedRowId 가 널일때 error 발생 
	if(items['C106000090_Grid_1'].getSelectedRowId()==null){
	return;
	}
	if( radioValue == "1" ){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcolor',items['C106000090_Grid_1'].getSelectedRowId());
	}else if(radioValue == "2"){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcclbom',items['C106000090_Grid_1'].getSelectedRowId());
	}else if(radioValue == "3"){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindrsntp',items['C106000090_Grid_1'].getSelectedRowId());
	}else if(radioValue == "4"){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcclbom1',items['C106000090_Grid_1'].getSelectedRowId());
	}else if(radioValue == "5"){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcclbom2',items['C106000090_Grid_1'].getSelectedRowId());
	}else if(radioValue == "6"){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindInk',items['C106000090_Grid_1'].getSelectedRowId());
	}else if(radioValue == "7"){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindFlm',items['C106000090_Grid_1'].getSelectedRowId());
	}else if(radioValue == "8"){	
		var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindBnd',items['C106000090_Grid_1'].getSelectedRowId());
	}
	
	items["C106000090_Grid_2"].loadData(prdFindUrl,'');
	uiCommon.progressOff(parent);
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
    if("move_grid" == id){
        if(isChecked)
          gridObj.enableColumnMove(true);
        else
          gridObj.enableColumnMove(false);
    }  
  	if("filter_grid" == id){
  		if(isChecked)
         gridObj.enableHeaderMenu();
  	}
  	if("editable_grid" == id){
  		if(isChecked)
         gridObj.setEditable(true);
  		else	
  		  gridObj.setEditable(false);
  	}
  	if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
  	}
  	if("copy_row" == id){
         var rowId=gridObj.getSelectedRowId();
         var cellInd=gridObj.getSelectedCellIndex();
        if(rowId !== null){
           gridObj.cellToClipboard(rowId, cellInd);
        }
    }
}
function findMessage(referenceItem){
	uiCommon.message("C106000090_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}


function onFormLoad(){
	var formObj = items['C106000090_Form_1'].getDhxForm();
	var grid1 = items['C106000090_Grid_1'];
	var grid2 = items['C106000090_Grid_2'];
	var gridObj = items['C106000090_Grid_1'].getDhxGrid();
	
	if(rollCd != ""){
		items['C106000090_Form_1'].getDhxForm().setItemValue("FIND_CD",rollCd);		
		items['C106000090_Form_1'].getDhxForm().setItemValue("SEARCH_CD_SEL","4");
		rollCd = "";
	}

	var radioValue = formObj.getItemValue("SEARCH_CD_SEL");

	if( radioValue == "1" ){
		items['C106000090_Form_2'].setItemValue("ALERT","칼라코드가 사용된 CCL BOM검색");	
		grid1.setColumnHiddenFlag("0,1,2",false);
		grid1.setColumnHiddenFlag("3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19",true);		
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,57,59,60,61,62",false);
		grid2.setColumnHiddenFlag("13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,58,63,64",true);		
	}else if(radioValue == "2"){
		items['C106000090_Form_2'].setItemValue("ALERT","CCL BOM이 사용된 주문검색");
		grid1.setColumnHiddenFlag("3,4,5",false);
		grid1.setColumnHiddenFlag("0,1,2,6,7,8,9,10,11,12,13,14,15,16,17,18,19",true);
		grid2.setColumnHiddenFlag("13,14,15,16,17,18,19,20,64",false);		
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63",true);
	}else if(radioValue == "3"){
		items['C106000090_Form_2'].setItemValue("ALERT","수지타입이 사용된 칼라코드 검색");	
		grid1.setColumnHiddenFlag("6,7",false);
		grid1.setColumnHiddenFlag("0,1,2,3,4,5,8,9,10,11,12,13,14,15,16,17,18,19",true);
		grid2.setColumnHiddenFlag("21,22,23,24,25,26,27",false);
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",true);		
	}else if(radioValue == "4"){
		items['C106000090_Form_2'].setItemValue("ALERT","Print Roll이 사용된 CCL BOM 검색");	
		grid1.setColumnHiddenFlag("8,9,10",false);
		grid1.setColumnHiddenFlag("0,1,2,3,4,5,6,7,11,12,13,14,15,16,17,18,19",true);
		grid2.setColumnHiddenFlag("28,29,30,31,32,33,34,35,36,37",false);
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",true);		
	}else if(radioValue == "5"){
		items['C106000090_Form_2'].setItemValue("ALERT","동일Print Roll이 사용된 CCL BOM 검색");	
		grid1.setColumnHiddenFlag("11,12",false);
		grid1.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,13,14,15,16,17,18,19",true);
		grid2.setColumnHiddenFlag("38,39,40,41,42,43,44,45,46",false);
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",true);		
	}else if(radioValue == "6"){
		items['C106000090_Form_2'].setItemValue("ALERT","Ink코드가 사용된 CCL BOM 검색");	
		grid1.setColumnHiddenFlag("13,14,15",false);
		grid1.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,16,17,18,19",true);
		grid2.setColumnHiddenFlag("47,48,49,50,51,52,53,54,55,56",false);
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,57,58,59,60,61,62,63,64",true);		
	}else if(radioValue == "7"){
		items['C106000090_Form_2'].setItemValue("ALERT","보호필름코드가 사용된 CCL BOM 검색");	
		grid1.setColumnHiddenFlag("16",false);
		grid1.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19",true);
		grid2.setColumnHiddenFlag("58,59,60,61,62",false);
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,63,64",true);
	}else if(radioValue == "8"){
		items['C106000090_Form_2'].setItemValue("ALERT","접착제가 사용된 CCL BOM 검색");	
		grid1.setColumnHiddenFlag("17,18,19",false);
		grid1.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16",true);
		
		grid2.setColumnHiddenFlag("58,59,60,61,62,63",false);
		grid2.setColumnHiddenFlag("0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,64",true);		
	}
}

function onFormLoad2(){
	var formObj = items['C106000090_Form_1'].getDhxForm();
	var radioValue = formObj.getItemValue("SEARCH_CD_SEL");

	if( radioValue == "1" ){	
		items['C106000090_Form_2'].setItemValue("ALERT","칼라코드가 사용된 CCL BOM검색");
	}else if(radioValue == "2"){
		items['C106000090_Form_2'].setItemValue("ALERT","CCL BOM이 사용된 주문검색");
	}else if(radioValue == "3"){	
		items['C106000090_Form_2'].setItemValue("ALERT","수지타입이 사용된 칼라코드 검색");
	}else if(radioValue == "4"){	
		items['C106000090_Form_2'].setItemValue("ALERT","Print Roll이 사용된 CCL BOM 검색");
	}else if(radioValue == "5"){	
		items['C106000090_Form_2'].setItemValue("ALERT","동일Print Roll이 사용된 CCL BOM 검색");
	}else if(radioValue == "6"){	
		items['C106000090_Form_2'].setItemValue("ALERT","Ink코드가 사용된 CCL BOM 검색");
	}else if(radioValue == "7"){
		items['C106000090_Form_2'].setItemValue("ALERT","보호필름코드가 사용된 CCL BOM 검색");
	}else if(radioValue == "8"){
		items['C106000090_Form_2'].setItemValue("ALERT","접착제가 사용된 CCL BOM 검색");
	}
	
	items['C106000090_Form_2'].getDhxForm().detachEvent(formXle);
}

function useSelect(id){
	var gridObj = items['C106000090_Grid_1'].getDhxGrid();
	var formObj = items['C106000090_Form_1'].getDhxForm();
	var radioValue = formObj.getItemValue("SEARCH_CD_SEL");	

	if( radioValue == "1" ){	
		var CLR_SUB_MTL_CD = gridObj.cellById(id,gridObj.getColIndexById("CLR_SUB_MTL_CD")).getValue();
		if(CLR_SUB_MTL_CD != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcolor',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}else if(radioValue == "2"){	
		var CCL_BOM_NO = gridObj.cellById(id,gridObj.getColIndexById("CCL_BOM_NO")).getValue();
		if(CCL_BOM_NO != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcclbom',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}else if(radioValue == "3"){	
		var RSN_TP = gridObj.cellById(id,gridObj.getColIndexById("RSN_TP")).getValue();
		if(RSN_TP != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindrsntp',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}else if(radioValue == "4"){	
		var PRT_ROLL_NO = gridObj.cellById(id,gridObj.getColIndexById("PRT_ROLL_NO")).getValue();
		if(PRT_ROLL_NO != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcclbom1',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}else if(radioValue == "5"){	
		var CCL_BOM_NO1 = gridObj.cellById(id,gridObj.getColIndexById("CCL_BOM_NO1")).getValue();
		if(CCL_BOM_NO1 != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindcclbom2',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}else if(radioValue == "6"){	
		var CLR_SUB_MTL_CD_INK = gridObj.cellById(id,gridObj.getColIndexById("CLR_SUB_MTL_CD_INK")).getValue();
		if(CLR_SUB_MTL_CD_INK != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindInk',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}else if(radioValue == "7"){	
		var PTT_FLM_DTL_CD = gridObj.cellById(id,gridObj.getColIndexById("PTT_FLM_DTL_CD")).getValue();
		if(PTT_FLM_DTL_CD != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindFlm',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}else if(radioValue == "8"){	
		var LMN_BND_CD = gridObj.cellById(id,gridObj.getColIndexById("LMN_BND_CD")).getValue();
		if(LMN_BND_CD != "") {
			var prdFindUrl = uiCommon.parameters2('C106000090_Form_1','C106000090_Grid_1','C106000090_Grid_2','useFindBnd',id);
			items["C106000090_Grid_2"].loadData(prdFindUrl,'');		
			uiCommon.progressOff(parent);
		}
	}
	
}

function onGridLoad1(){
	var gridObj = items['C106000090_Grid_1'].getDhxGrid();

		gridObj.attachEvent("onSelectStateChanged", function(id){
			useSelect(items['C106000090_Grid_1'].getSelectedRowId());
		}); 
	return true;
}

//해당 사용코드 색깔표시
function onGridLoad2(){
	var gridObj1 = items['C106000090_Grid_1'].getDhxGrid();
	var gridObj2 = items['C106000090_Grid_2'].getDhxGrid();
	var formObj = items['C106000090_Form_1'].getDhxForm();
	var radioValue = formObj.getItemValue("SEARCH_CD_SEL");
	
	if( radioValue == "1" ){
	    var CLR_SUB_MTL_CD = getGridCellData(gridObj1,gridObj1.getSelectedRowId(),"CLR_SUB_MTL_CD");
		var grid_cnt = gridObj2.getRowsNum();
		
		for(var  i=0; i<grid_cnt; i++) {
			var HUE_CD_FRN          = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_FRN")).getValue();
			var HUE_CD_BAK          = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_BAK")).getValue();
			var HUE_CD_FRN_4COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_FRN_4COT")).getValue();
			var HUE_CD_FRN_3COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_FRN_3COT")).getValue();
			var HUE_CD_FRN_2COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_FRN_2COT")).getValue();
			var HUE_CD_FRN_1COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_FRN_1COT")).getValue();
			var HUE_CD_BAK_1COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_BAK_1COT")).getValue();
			var HUE_CD_BAK_2COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_BAK_2COT")).getValue();
			var HUE_CD_BAK_3COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_BAK_3COT")).getValue();
			var HUE_CD_BAK_4COT = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_BAK_4COT")).getValue();
			var HUE_CD_LMN         = gridObj2.cellByIndex(i, gridObj2.getColIndexById("HUE_CD_LMN")).getValue();
			
	        if(CLR_SUB_MTL_CD == HUE_CD_FRN){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_FRN'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD == HUE_CD_BAK){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_BAK'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD == HUE_CD_FRN_4COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_FRN_4COT'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD == HUE_CD_FRN_3COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_FRN_3COT'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD == HUE_CD_FRN_2COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_FRN_2COT'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD == HUE_CD_FRN_1COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_FRN_1COT'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD == HUE_CD_BAK_1COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_BAK_1COT'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD == HUE_CD_BAK_2COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_BAK_2COT'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD == HUE_CD_BAK_3COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_BAK_3COT'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD == HUE_CD_BAK_4COT){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_BAK_4COT'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD == HUE_CD_LMN){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('HUE_CD_LMN'),"color:blue;");
			}	        
		}		
	}else if(radioValue == "4"){
	    var PRT_ROLL_NO = getGridCellData(gridObj1,gridObj1.getSelectedRowId(),"PRT_ROLL_NO");
		var grid_cnt = gridObj2.getRowsNum();
		
		for(var  i=0; i<grid_cnt; i++) {
			var PRT_ROLL_NO1 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_NO1")).getValue();
			var PRT_ROLL_NO2 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_NO2")).getValue();
			var PRT_ROLL_NO3 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_NO3")).getValue();
			var PRT_ROLL_NO4 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_NO4")).getValue();
			var PRT_ROLL_BAK_NO1 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_BAK_NO1")).getValue();
			var PRT_ROLL_BAK_NO2 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_BAK_NO2")).getValue();
			var PRT_ROLL_BAK_NO3 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_BAK_NO3")).getValue();
			var PRT_ROLL_BAK_NO4 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_ROLL_BAK_NO4")).getValue();

	        if(PRT_ROLL_NO == PRT_ROLL_NO1){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_NO1'),"color:blue;");
			}
	        if(PRT_ROLL_NO == PRT_ROLL_NO2){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_NO2'),"color:blue;");
			}		
	        if(PRT_ROLL_NO == PRT_ROLL_NO3){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_NO3'),"color:blue;");
			}
	        if(PRT_ROLL_NO == PRT_ROLL_NO4){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_NO4'),"color:blue;");
			}		
	        if(PRT_ROLL_NO == PRT_ROLL_BAK_NO1){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_BAK_NO1'),"color:blue;");
			}
	        if(PRT_ROLL_NO == PRT_ROLL_BAK_NO2){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_BAK_NO2'),"color:blue;");
			}		
	        if(PRT_ROLL_NO == PRT_ROLL_BAK_NO3){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_BAK_NO3'),"color:blue;");
			}
	        if(PRT_ROLL_NO == PRT_ROLL_BAK_NO4){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_ROLL_BAK_NO4'),"color:blue;");
			}		
		}		
	}else if(radioValue == "5"){
	    var CCL_BOM_NO1 = getGridCellData(gridObj1,gridObj1.getSelectedRowId(),"CCL_BOM_NO1");
		var grid_cnt = gridObj2.getRowsNum();
		
		for(var  i=0; i<grid_cnt; i++) {
			var CCL_BOM_NO2 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("CCL_BOM_NO2")).getValue();

	        if(CCL_BOM_NO1 == CCL_BOM_NO2){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('CCL_BOM_NO2'),"color:blue;");
			}		
		}		
	}else if(radioValue == "6"){
	    var CLR_SUB_MTL_CD_INK = getGridCellData(gridObj1,gridObj1.getSelectedRowId(),"CLR_SUB_MTL_CD_INK");
		var grid_cnt = gridObj2.getRowsNum();
		
		for(var  i=0; i<grid_cnt; i++) {
			var PRT_INK_CD1 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_CD1")).getValue();
			var PRT_INK_CD2 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_CD2")).getValue();
			var PRT_INK_CD3 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_CD3")).getValue();
			var PRT_INK_CD4 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_CD4")).getValue();
			var PRT_INK_BAK_CD1 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_BAK_CD1")).getValue();
			var PRT_INK_BAK_CD2 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_BAK_CD2")).getValue();
			var PRT_INK_BAK_CD3 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_BAK_CD3")).getValue();
			var PRT_INK_BAK_CD4 = gridObj2.cellByIndex(i, gridObj2.getColIndexById("PRT_INK_BAK_CD4")).getValue();

	        if(CLR_SUB_MTL_CD_INK == PRT_INK_CD1){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_CD1'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD_INK == PRT_INK_CD2){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_CD2'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD_INK == PRT_INK_CD3){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_CD3'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD_INK == PRT_INK_CD4){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_CD4'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD_INK == PRT_INK_BAK_CD1){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_BAK_CD1'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD_INK == PRT_INK_BAK_CD2){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_BAK_CD2'),"color:blue;");
			}		
	        if(CLR_SUB_MTL_CD_INK == PRT_INK_BAK_CD3){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_BAK_CD3'),"color:blue;");
			}
	        if(CLR_SUB_MTL_CD_INK == PRT_INK_BAK_CD4){
			    gridObj2.setCellTextStyle(gridObj2.getRowId(i),gridObj2.getColIndexById('PRT_INK_BAK_CD4'),"color:blue;");
			}		
		}		
	}

	return true;
}

function Grid_doLink(val,rowIdx,cellIdx){
	var gridObj 	= items['C106000090_Grid_2'].getDhxGrid();

	var link_url 	= "", param = "";
	if(cellIdx == gridObj.getColIndexById('ORD_NO')) {	
		var ORD_NO	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_NO")).getValue().substring(0,10);
		var ORD_LN 	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_NO")).getValue().substring(11,14);
		link_url = "C104000020";
		param += "&ORD_NO="+ORD_NO;
		param += "&ORD_LN="+ORD_LN;
		parent.newRemoveOpenTab(link_url,param);
	}
}

function C106000090_doLink(val,rowIdx,cellIdx){
	var gridObj 	= items['C106000090_Grid_2'].getDhxGrid();
	var link_url 	= "", param = "";
	if(cellIdx == gridObj.getColIndexById('PRD_WHS_OX')) {
		
			var ORD_NO	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_NO")).getValue().substring(0,10);
			var ORD_LN 	= gridObj.cells(rowIdx,gridObj.getColIndexById("ORD_NO")).getValue().substring(11,14);
			link_url = "M472020090";
			param += "&ORD_NO="+ORD_NO;
			param += "&ORD_LN="+ORD_LN;
			parent.newRemoveOpenTab(link_url,param);
	}
}

//]]>
-->
</script>
</head>
<body>
<div id="C106000090_Form_1" style="position:absolute;height:58px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000090_Form_2" style="position:absolute;height:23px;width:300px;left:0px;top:58px;">
</div>
<div id="C106000090_Grid_1" style="position:absolute;height:481px;width:300px;left:1px;top:83px;">
</div>
<div id="C106000090_Menu_2" style="position:absolute;height:25px;width:670px;left:309px;top:60px; background:#FFFFFF">
</div>
<div id="C106000090_Grid_2" style="position:absolute;height:481px;width:668px;left:309px;top:83px;">
</div>
<div id="C106000090_messagebox" style="position:absolute;height:19px;width:978px;left:0px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	items['C106000090_Form_1'].onXLEEvent(onFormLoad);
	var formXle = items['C106000090_Form_2'].onXLEEvent(onFormLoad2);
	//items["C106000090_Grid_1"].rowSelected(useSelect);
	items['C106000090_Form_1'].getDhxForm().attachEvent("onChange",onFormLoad);
	items['C106000090_Grid_1'].onXLEEvent(onGridLoad1);
	items['C106000090_Grid_2'].onXLEEvent(onGridLoad2);	
    items['C106000090_Form_2'].setBackgroundColor("#FFFFFF");	
	
//]]>
-->
</script>