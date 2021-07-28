<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000020.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계시뮬레이션
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
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C106000020
</title>
<style>
html, body { width: 100%; height: 100%; overflow: hidden; }  
</style>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000020_Form_1","xml":".\/header\/kr\/C106000020\/C106000020_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000020_Grid_1","service":"C106000020-service","actionType":"find","security":"true"},' +
      '{"itemType":"form","renderTo":"C106000020_Form_2","xml":".\/header\/kr\/C106000020\/C106000020_Form_2.xml","url":"basicFormData.do","referenceItem":"C106000020_Form_4","service":"C106000020-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C106000020_Grid_1","xml":".\/header\/kr\/C106000020\/C106000020_Grid_1.xml","rowCnt":"11","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000020_Grid_1","service":"C106000020-service","actionType":"save"},' +
      '{"itemType":"form","renderTo":"C106000020_Form_3","xml":".\/header\/kr\/C106000020\/C106000020_Form_3.xml","url":"basicGridData.do","referenceItem":"C106000020_Form_1","service":"C106000020-service","actionType":"save"},' +
      '{"itemType":"form","renderTo":"C106000020_Form_4","xml":".\/header\/kr\/C106000020\/C106000020_Form_4.xml","url":"basicFormData.do","referenceItem":"C106000020_Form_5","service":"C106000020-service","actionType":"find"},' +
      '{"itemType":"messagebox","renderTo":"C106000020_messagebox","xml":".\/header\/kr\/C106000020\/C106000020_messagebox.xml","service":"C106000020-service"},' +
      '{"itemType":"form","renderTo":"C106000020_Form_5","xml":".\/header\/kr\/C106000020\/C106000020_Form_5.xml","url":"basicFormData.do","referenceItem":"C106000020_Form_5","service":"C106000020-service","actionType":"find"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var searchFlag = false;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var formObj = items['C106000020_Form_1'];
	var formObj2 = items['C106000020_Form_2'];
	var comboList = formObj.getMasterCombos();
	var startDt = items["C106000020_Form_1"].getDhxForm().getInput("PDN_DH_START").value;
	var endDt = items["C106000020_Form_1"].getDhxForm().getInput("PDN_DH_END").value;
		if(isNull(comboList['PRD_NM_CD'].getSelectedValue())){
			dhtmlx.alert("품명을 선택해주세요.");
			return;
		}else if(checkValid(startDt, "YYYYMMDD") && checkValid(endDt, "YYYYMMDD")){
			if(isCompareDate(startDt,endDt)){	
					if(!isNull(formObj2.getItemValue("MQL_ACT_YP_MPA_MIN")) || !isNull(formObj2.getItemValue("MQL_ACT_YP_MPA_MAX"))){			
						if(!isNull(formObj2.getItemValue("MQL_ACT_YP_MPA_MIN")) && isNull(formObj2.getItemValue("MQL_ACT_YP_MPA_MAX"))){
							dhtmlx.alert("범위기준 YP의 Max값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_YP_MPA_MAX");
							return;
						}else if(!isNull(formObj2.getItemValue("MQL_ACT_YP_MPA_MAX")) && isNull(formObj2.getItemValue("MQL_ACT_YP_MPA_MIN"))){
							dhtmlx.alert("범위기준 YP의 Min값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_YP_MPA_MIN");
							return;
						}else if(!js_field_qnty_check("MQL_ACT_YP_MPA_MIN는","MQL_ACT_YP_MPA_MIN","C106000020_Form_2", "3", "0", false )){
							return;
						}else if(!js_field_qnty_check("MQL_ACT_YP_MPA_MAX","MQL_ACT_YP_MPA_MAX","C106000020_Form_2", "3", "0", false )){
							return;
						}
					}
					if(!isNull(formObj2.getItemValue("MQL_ACT_TS_MPA_MIN")) || !isNull(formObj2.getItemValue("MQL_ACT_TS_MPA_MAX"))){
						if(!isNull(formObj2.getItemValue("MQL_ACT_TS_MPA_MIN")) && isNull(formObj2.getItemValue("MQL_ACT_TS_MPA_MAX"))){
							dhtmlx.alert("범위기준 TS의 Max값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_TS_MPA_MAX");
							return;
						}else if(!isNull(formObj2.getItemValue("MQL_ACT_TS_MPA_MAX")) && isNull(formObj2.getItemValue("MQL_ACT_TS_MPA_MIN"))){
							dhtmlx.alert("범위기준 TS의 Min값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_TS_MPA_MIN");
							return;
						}else if(!js_field_qnty_check("MQL_ACT_TS_MPA_MIN는","MQL_ACT_TS_MPA_MIN","C106000020_Form_2", "3", "0", false )){
							return;
						}else if(!js_field_qnty_check("MQL_ACT_TS_MPA_MAX는","MQL_ACT_TS_MPA_MAX","C106000020_Form_2", "3", "0", false )){
							return;
						}
					}
					if(!isNull(formObj2.getItemValue("MQL_ACT_EL_MIN")) || !isNull(formObj2.getItemValue("MQL_ACT_EL_MAX"))){
						if(!isNull(formObj2.getItemValue("MQL_ACT_EL_MIN")) && isNull(formObj2.getItemValue("MQL_ACT_EL_MAX"))){
							dhtmlx.alert("범위기준 EL의 Max값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_EL_MAX");
							return;
						}else if(!isNull(formObj2.getItemValue("MQL_ACT_EL_MAX")) && isNull(formObj2.getItemValue("MQL_ACT_EL_MIN"))){
							dhtmlx.alert("범위기준 EL의 Min값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_EL_MIN");
							return;
						}else if(!js_field_qnty_check("MQL_ACT_EL_MIN는","MQL_ACT_EL_MIN","C106000020_Form_2", "3", "1", true )){
							return;
						}else if(!js_field_qnty_check("MQL_ACT_EL_MAX는","MQL_ACT_EL_MAX","C106000020_Form_2", "3", "1", true )){
							return;
						}
					}
					
					if(!isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MIN")) || !isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MAX"))){
						if(!isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MIN")) && isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MAX"))){
							dhtmlx.alert("범위기준 HRB의 Max값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_HRB_AVG_MAX");
							return;
						}else if(!isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MAX")) && isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MIN"))){
							dhtmlx.alert("범위기준 HRB의 Min값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_HRB_AVG_MIN");
							return;
						}else if(!js_field_qnty_check("MQL_ACT_HRB_AVG_MIN는","MQL_ACT_HRB_AVG_MIN","C106000020_Form_2", "3", "1", true )){
							return;
						}else if(!js_field_qnty_check("MQL_ACT_HRB_AVG_MAX는","MQL_ACT_HRB_AVG_MAX","C106000020_Form_2", "3", "1", true )){
							return;
						}
					}
					
					if(!isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MIN")) || !isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MAX"))){
						if(!isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MIN")) && isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MAX"))){
							dhtmlx.alert("범위기준 ERI의 Max값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_HRB_AVG_MAX");
							return;
						}else if(!isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MAX")) && isNull(formObj2.getItemValue("MQL_ACT_HRB_AVG_MIN"))){
							dhtmlx.alert("범위기준 ERI의 Min값을 입력해주세요");
							items['C106000020_Form_2'].setItemFocus("MQL_ACT_HRB_AVG_MIN");
							return;
						}else if(!js_field_qnty_check("MQL_ACT_HRB_AVG_MIN는","MQL_ACT_HRB_AVG_MIN","C106000020_Form_2", "3", "1", true )){
							return;
						}else if(!js_field_qnty_check("MQL_ACT_HRB_AVG_MAX는","MQL_ACT_HRB_AVG_MAX","C106000020_Form_2", "3", "1", true )){
							return;
						}
					}
					var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
				    items[referenceItem].loadData(findUrl,loadAfterEvent);
					var findUrl2 = uiCommon.parameters6("C106000020_Form_2","C106000020_Form_5","standardFind")+"&"+formParameter(items['C106000020_Form_1'].getDhxForm());
					items["C106000020_Form_5"].loadData(findUrl2,loadAfterEvent2);	
			 }
		}    
}
function save(eventName,formDivObj,referenceItem){
	if(searchFlag){
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"저장하시겠습니까?",
			callback:function(val){
				if(val){
					var gridObj = items['C106000020_Grid_1'].getDhxGrid();
					var grid_cnt1 = gridObj.getRowsNum();
					for(var i=0; i< grid_cnt1; i++){
						var rowID = gridObj.getRowId(i);
						items['C106000020_Grid_1'].setUpdated(rowID,true,"inserted"); 
					}
					items[referenceItem].sendGrid(referenceItem,eventName);		
				  return;
				}
			}
		});		  
	}else{
		dhtmlx.alert("Import한 경우에만 저장하실 수 있습니다.");
		return;
	}
}
/*function save(eventName,formDivObj,referenceItem){
	//var param = "ServiceName=C106000020-service&coilIdFind=1&COIL_ID="+ items[referenceItem].getCellByIndexValue(0,0);
	//var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var param = "";
	var xmlObj = "";
	var gridObj = items['C106000020_Grid_1'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	var rows;
	var row;
	var dueCnt=0;
	var coil_id;
	var data;
	var rowId = [];
	for(var i=0; i< grid_cnt1; i++){
		param = "ServiceName=C106000020-service&coilIdFind=1&COIL_ID="+ items[referenceItem].getCellByIndexValue(i,0)+"&column-info=COIL_ID";	
		xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		rows = xmlObj.getElementsByTagName("rows");
		for(var j = 0; j < rows.length; j++){
			row = rows[j].childNodes;	
			for(var k = 0; k < row.length; k++){
				if(typeof(row[k].getAttribute("id")) != 'undefined'){
					data = row[k].childNodes;				
					coil_id = data[0].firstChild.nodeValue;
					if (coil_id != "0") {
						dueCnt++;
						rowId.push(gridObj.getRowId(i));
					}
				}
			}
		}
	}
	if(dueCnt > 0){
	  for(var h=0; h<rowId.length; h++){
		   gridObj.setRowTextStyle(rowId[h], "color: red;");
	  }
	}	
	
}*/
//menu refresh event function
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
	uiCommon.message("C106000020_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(){ 
	var comboList = items['C106000020_Form_1'].getMasterCombos();
	var formObj   = items['C106000020_Form_1'].getDhxForm();

	items["C106000020_Form_1"].setItemValue("PDN_DH_START",getCurrentAddMinusDay("-","",1));
	items["C106000020_Form_1"].setItemValue("PDN_DH_END",uiCommon.getCurrentDate());
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	items['C106000020_Form_1'].getItem("PDN_DH_START").setWeekStartDay(7);
	items['C106000020_Form_1'].getItem("PDN_DH_END").setWeekStartDay(7);

	var categoryCd = "SZ0000";
	
		comboList['PRD_NM_CD'].readonly(true,true);//품명
			ui.combo.master(comboList['PRD_NM_CD'],'SZ0000','PRD_NM_CD','totalValue=all,orderBy=value',function(){ 
			comboList['PRD_NM_CD'].selectOption(0,true,true);		
		});
		comboList['PRD_NM_CD'].DOMelem_input.onkeydown = function(e){
			key = (e) ? e.keyCode : event.keyCode;
				if(key==8 || key==116){
					if(e){   //표준         
						e.preventDefault();
					}
					else{ //익스용
						event.keyCode = 0;
						event.returnValue = false;
					}
				}
			}
		comboList['PROC_CD'].readonly(true,true);//생산공정
			ui.combo.master(comboList['PROC_CD'],'SZ0000','PROC_CD','totalValue=,orderBy=value',function(){ 
			comboList['PROC_CD'].selectOption(0,true,true);		
		});
		comboList['PROC_CD'].DOMelem_input.onkeydown = function(e){
			key = (e) ? e.keyCode : event.keyCode;
				if(key==8 || key==116){
					if(e){   //표준         
						e.preventDefault();
					}
					else{ //익스용
						event.keyCode = 0;
						event.returnValue = false;
					}
				}
			}
		comboList['SP_ASG_YN'].readonly(true,true);//S/P
			ui.combo.master(comboList['SP_ASG_YN'],'SZ0000','SPM_USE_YN','totalValue=,orderBy=value',function(){ 
			comboList['SP_ASG_YN'].selectOption(0,true,true);	
			comboList['SP_ASG_YN'].setOptionHeight(60);
		});
		comboList['SP_ASG_YN'].DOMelem_input.onkeydown = function(e){
			key = (e) ? e.keyCode : event.keyCode;
				if(key==8 || key==116){
					if(e){   //표준         
						e.preventDefault();
					}
					else{ //익스용
						event.keyCode = 0;
						event.returnValue = false;
					}
				}
			}
		
		var inputCD_V = items["C106000020_Form_1"].getDhxForm().getInput("ORD_USG_CD");
		inputCD_V.onkeyup = function(){
			inputCD_V.value = inputCD_V.value.toUpperCase(); 	
		}	
		
		//items['C106000020_Form_1'].onAfterUpdateFinishEvent(onFormAfterUpdateFinishEvent);
		items['C106000020_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function onGridLoadFunction(){
	items['C106000020_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C106000020_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onFormAfterUpdateFinishEvent(){	
	 items['C106000020_Form_1'].getDhxForm().resetDataProcessor("updated");
}
function onGridAfterUpdateFinishEvent(){
	var gridObj = items['C106000020_Grid_1'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj.getRowId(i);
        items['C106000020_Grid_1'].setUpdated(rowID,false,""); 
	}
	items['C106000020_Grid_1'].clearDataProcess();
	// items['C106000020_Grid_1'].getDhxGrid().resetDataProcessor("updated");
}
function serchIcon(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('ORD_USG_CD','SZ0000','ORD_USG_CD','C106000020_Form_1');\">";
}
var winObj;
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	var ordUsgCd = items['C106000020_Form_1'].getItemValue("ORD_USG_CD"); 
	winObj = new ui.window("masterPopup","masterPopup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId+"&CD_V="+ordUsgCd);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}
function excelImport(eventName,formDivObj,referenceItem){
	winObj = new ui.window("fileUplad","FileUplad","0","0","465","305","fileUpload.jsp");
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
function searchFlagUpdate(){
	searchFlag = true;
}
function loadAfterEvent(){
	uiCommon.message("C106000020_messagebox",items['C106000020_Grid_1'].getDhxGrid().getUserData("","appMsg"));
    var gridObj = items['C106000020_Grid_1'].getDhxGrid();
	var grid = items['C106000020_Grid_1'];
	//평균값
	var rowCnt = items['C106000020_Grid_1'].getDhxGrid().getRowsNum();
	var coilWgt = 0;
	var yp = 0;
	var ts = 0;
	var el = 0;
	var hrb = 0;
	var eri = 0;
	var rowValCnt = 0;
    for (var i = 0; i < rowCnt; i++) {
		if(!isNull(gridObj.cells2(i, 0).getValue())){
			++rowValCnt;
		}
        coilWgt += parseFloat(Number(gridObj.cells2(i, 9).getValue()));
		yp += parseFloat(Number(gridObj.cells2(i, 13).getValue()));
		ts += parseFloat(Number(gridObj.cells2(i, 14).getValue()));
		el += parseFloat(Number(gridObj.cells2(i, 15).getValue()));
		hrb += parseFloat(Number(gridObj.cells2(i, 16).getValue()));
		eri += parseFloat(Number(gridObj.cells2(i, 17).getValue()));
    }
	if(!isNull(grid.getCellByIndexValue(0,0))){
		items["C106000020_Form_3"].setItemValue("TOTAL_CNT",fnc_numberFormat(rowValCnt));
		items["C106000020_Form_3"].setItemValue("AVG_WGT",fnc_numberFormat((coilWgt/rowValCnt).toFixed(1)));
		items["C106000020_Form_3"].setItemValue("YP_AVG",fnc_numberFormat((yp/rowValCnt).toFixed(1)));
		items["C106000020_Form_3"].setItemValue("TS_AVG",fnc_numberFormat((ts/rowValCnt).toFixed(1)));
		items["C106000020_Form_3"].setItemValue("EL_AVG",fnc_numberFormat((el/rowValCnt).toFixed(1)));
		items["C106000020_Form_3"].setItemValue("HRB_AVG",fnc_numberFormat((hrb/rowValCnt).toFixed(1)));
		items["C106000020_Form_3"].setItemValue("ERI_AVG",fnc_numberFormat((eri/rowValCnt).toFixed(1)));
	}
  	return true;
}

function loadAfterEvent2(){
	uiCommon.progressOff(parent);		
  	return true;
}

//]]>
-->
</script>
</head>
<body>
<div id="C106000020_Form_1" style="position:absolute;height:91px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000020_Form_2" style="position:absolute;height:65px;width:981px;left:0px;top:96px;">
</div>
<div id="C106000020_Grid_1" style="position:absolute;height:320px;width:977px;left:1px;top:165px;">
</div>
<div id="C106000020_Form_3" style="position:absolute;height:76px;width:566px;left:0px;top:494px;">
</div>
<div id="C106000020_Form_4" style="position:absolute;height:25px;width:300px;left:590px;top:494px;">
</div>
<div id="C106000020_Form_5" style="position:absolute;height:28px;width:300px;left:590px;top:523px;">
</div>
<div id="C106000020_messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
	//items['C105000020_Form_1'].setBackgroundColor("#FFFFFF");
	items['C106000020_Form_2'].setBackgroundColor("#D6E8FF");
	items['C106000020_Form_3'].setBackgroundColor("#FFFFFF");
	items['C106000020_Form_4'].setBackgroundColor("#FFFFFF");
	items['C106000020_Form_5'].setBackgroundColor("#FFFFFF");
	var onXleForm = items['C106000020_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C106000020_Grid_1'].onXLEEvent(onGridLoadFunction);
	
//]]>
-->
</script>