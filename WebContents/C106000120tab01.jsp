<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000120tab01.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  보증서기준등록
 * DESIGNER NAME    :  원성옥                              
 * DEVELOPER NAME   :  원성옥
 * CREATE DATE      :  2014.11.04
 *
 * Date	        Ver       Name       Description
 * ---------   -----    --------  ------------------------
 * 2014.11.04   V1.0     원성옥	  최초작성 
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
보증서기준등록
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000120tab01_Form_1","xml":".\/header\/kr\/C106000120tab01\/C106000120tab01_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000120tab01_Grid_1","service":"C106000120tab01-service","actionType":"save","security":"true"},' +
      '{"itemType":"menu","renderTo":"C106000120tab01_Menu_1","xml":".\/header\/kr\/C106000120tab01\/C106000120tab01_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000120tab01_Grid_1","service":"C106000120tab01-service"},' +
      '{"itemType":"grid","renderTo":"C106000120tab01_Grid_1","xml":".\/header\/kr\/C106000120tab01\/C106000120tab01_Grid_1.xml","rowCnt":"17","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000120tab01_Grid_1","service":"C106000120tab01-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000120tab01_messagebox","xml":".\/header\/kr\/C106000120tab01\/C106000120tab01_messagebox.xml","service":"C106000120tab01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
// 저장함수
function save(eventName,formDivObj,referenceItem){
	var grid    = items['C106000120tab01_Grid_1'];
	var gridObj = items['C106000120tab01_Grid_1'].getDhxGrid();
	
	//모든 그리드 업데이트(보증서 변경내역 저장을 위해) 
/* 	for(var i=0; i< gridObj.getRowsNum(); i++){
		grid.setUpdated(grid.getDhxGrid().getRowId(i),true,"updated"); 
	} */
		
	dhtmlx.confirm({
		ok:"확인", cancel:"취소",
		text:" 입력된 정보를 저장하시겠습니까? ",
		callback:function(val){
		 if(val){
			items[referenceItem].sendGrid(referenceItem,eventName);
		   return;
		 }
		}
	});	
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C106000120tab01_Form_1',referenceItem,'find');
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
} 
function findMessage(referenceItem){
	uiCommon.message("C106000120tab01_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
//폼 로드 시 
function onLoadForm(){ 
	var formId = "C106000120tab01_Form_1";
	var gridId = 'C106000120tab01_Grid_1';	
	var formObj = items[formId].getDhxForm();
	
	// 날짜 세팅 	
	items[formId].setItemValue("DH_END",uiCommon.getCurrentDate());
	
	var toDate = items[formId].getDhxForm().getItemValue('DH_END');
	var fromDate = dateAdd(new Date(toDate.substring(5,7)+"/"+toDate.substring(8,10)+"/"+toDate.substring(0,4)),-90);
	 
	items[formId].setItemValue("DH_STR",fromDate);
	
	fromDate = items[formId].getDhxForm().getItemValue('DH_STR');
	
	//작업일자 달력 설정
	items[formId].getItem("DH_STR").setWeekStartDay(7);
	items[formId].getItem("DH_END").setWeekStartDay(7);
	
	//콤보생성 
	comboList(formId,fromDate,toDate,"onLoadForm")
	
	//저장함수 비활성화 
  	items[formId].getDhxForm().disableItem('save');
  	
	items[formId].getDhxForm().detachEvent(onXLEForm);

}

//콤보리스트 생성
function comboList(formId,fromDate,toDate,action){
	//클래스 콤보 생성 
	var comboList = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboList['CLS_COMB'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
  	ui.combo(comboList['CLS_COMB'],"OrdlnComboData.do"
			,"ServiceName=C106000120tab01-service&findItemCls=0&column-info=CLS_CD,CLS_NM&DH_STR="+fromDate+"&DH_END="+toDate,function(){ 
  			if(action != "changeEvent"){
  			  comboList['CLS_COMB'].selectOption(0,true,true);
			  comboList['CLS_COMB'].readonly(true);
			  comboList['CLS_COMB'].DOMelem_input.focus();
  			}
			}); 
	
	//구분 콤보 생성 
	var comboList1 = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboList['DIV_COMB'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
  	ui.combo(comboList1['DIV_COMB'],"OrdlnComboData.do"
			,"ServiceName=C106000120tab01-service&findItemDiv=0&column-info=DIV_CD,DIV_NM&DH_STR="+fromDate+"&DH_END="+toDate,function(){
			if(action != "changeEvent"){
	  		  comboList1['DIV_COMB'].selectOption(0,true,true);
	  		  comboList1['DIV_COMB'].readonly(true);
	  		  comboList1['DIV_COMB'].DOMelem_input.focus();
			}
			}); 
	
	//수지구분 콤보생성 
	var comboList2 = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboList['RSN_COMB'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
  	ui.combo(comboList2['RSN_COMB'],"OrdlnComboData.do"
			,"ServiceName=C106000120tab01-service&findItemRsn=0&column-info=RSN_TP,RSN_TP_NM&DH_STR="+fromDate+"&DH_END="+toDate,function(){
			if(action != "changeEvent"){
  			  comboList2['RSN_COMB'].selectOption(0,true,true);
  			  comboList2['RSN_COMB'].readonly(true);
  			  comboList2['RSN_COMB'].DOMelem_input.focus();
			}
			}); 
	
	//버전구분 콤보생성 
	var comboList3 = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboList['VER_COMB'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
  	ui.combo(comboList3['VER_COMB'],"OrdlnComboData.do"
			,"ServiceName=C106000120tab01-service&findItemVer=0&column-info=VER_CD,VER_NM&DH_STR="+fromDate+"&DH_END="+toDate,function(){
			if(action != "changeEvent"){
  			  comboList3['VER_COMB'].selectOption(0,true,true);
  			  comboList3['VER_COMB'].readonly(true);
  			  comboList3['VER_COMB'].DOMelem_input.focus();
			}
			}); 
	
}

//날짜 계산함수
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
//그리드 로드 시 
function onLoadGrid (){
    var findUrl = uiCommon.parameters('C106000120tab01_Form_1','C106000120tab01_Grid_1','find');
    items['C106000120tab01_Grid_1'].loadData(findUrl);
	items["C106000120tab01_Grid_1"].getDhxGrid().detachEvent(onXLEGrid);
	//메뉴 숨김
	hideMenuItems();
}
//저장 후 조회처리
function onAfterUpdateFinishEvent(){
	var formId = "C106000120tab01_Form_1";
	var toDate   = items[formId].getDhxForm().getItemValue('DH_END');
	var fromDate = items[formId].getDhxForm().getItemValue('DH_STR');
	
	  find('find',formId,'C106000120tab01_Grid_1');
	  //콤보재조회
	  comboList(formId,fromDate,toDate,"AfterUpdate");
}
// 폼 체인지 이벤트 
function onFormChangeEvent(id){
	var formId  = "C106000120tab01_Form_1";
	var formObj = items[formId].getDhxForm();
	var grid = items['C106000120tab01_Grid_1'];	
	var gridObj = items['C106000120tab01_Grid_1'].getDhxGrid();


	var selectedId = grid.getSelectedRowId();
	//alert(selectedId);
	var fromDate= items[formId].getDhxForm().getItemValue('DH_STR');
	var toDate  = items[formId].getDhxForm().getItemValue('DH_END');

	comboList(formId,fromDate,toDate,"changeEvent");
		
	if(id == 'SETTING'){
  		if(formObj.getItemValue(id) == 'N'){ // 조회
  			formObj.disableItem('save');
  			hideMenuItems();
  		}
  		if(formObj.getItemValue(id) == 'Y'){ //저장
  			formObj.enableItem('save');
  			showMenuItems();
  		}
  		//alert(grid.getCellValue(gridObj.getRowId(0),0));
  	  find('find','C106000120tab01_Form_1','C106000120tab01_Grid_1');
  	}
}
//메뉴 정보를 숨김
function hideMenuItems(){
	var menuObj = items['C106000120tab01_Menu_1'].getDhxMenu();
	menuObj.hideItem("add");
	menuObj.hideItem("copy");
	menuObj.hideItem("remove");
	
}
//메뉴정보를 보여줌 
function showMenuItems(){
	var menuObj = items['C106000120tab01_Menu_1'].getDhxMenu();
	menuObj.showItem("add");
	menuObj.showItem("copy");
	menuObj.showItem("remove");
	
}
//전송버튼 클릭 시 실행 
function send(){
	dhtmlx.confirm({
		ok:"확인", cancel:"취소",
		text:" 전송 하시겠습니까? ",
		callback:function(val){
		 if(val){
			 
			 var customparam = null;
	 	    items["C106000120tab01_Form_1"].sendForm("handleDataProcess.do","C106000120tab01_Form_1","send",customparam);
		   return;
		 }
		}
	});	
	
}
//]]>
-->
</script>
</head>
<body>
<div id="C106000120tab01_Form_1" style="position:absolute;height:57px;width:977px;left:0px;top:0px;">
</div>
<div id="C106000120tab01_Menu_1" style="position:absolute;height:25px;width:977px;left:0px;top:57px;">
</div>
<div id="C106000120tab01_Grid_1" style="position:absolute;height:428px;width:974px;left:0px;top:82px;">
</div>
<div id="C106000120tab01_messagebox" style="position:absolute;height:23px;width:976px;left:-1px;top:508px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	items['C106000120tab01_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	var onXLEForm = items['C106000120tab01_Form_1'].onXLEEvent(onLoadForm);
	var onXLEGrid = items['C106000120tab01_Grid_1'].onXLEEvent(onLoadGrid);
	items['C106000120tab01_Form_1'].onChangeEvent(onFormChangeEvent);
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
	var dataProcessor = items["C106000120tab01_Grid_1"].getDhxDataProcess();
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}
//]]>
-->
</script>