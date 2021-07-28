<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000040.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  재설계
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  이 민 균
 * CREATE DATE      :  2012.02.06
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.02.06     V1.0      이민균      Initial Version
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
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000040_Form_1","xml":".\/header\/kr\/C104000040\/C104000040_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000040_Grid_1","service":"C104000040-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C104000040_Grid_1","xml":".\/header\/kr\/C104000040\/C104000040_Grid_1.xml","rowCnt":"18","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000040_Form_1","service":"C104000040-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C104000040_messagebox","xml":".\/header\/kr\/C104000040\/C104000040_messagebox.xml","service":"C104000040-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var formObj = items['C104000040_Form_1'].getDhxForm();
	var form = items['C104000040_Form_1'];
	var startDt = form.getItemValue("QLT_DSN_INST_DH_START");
	var endDt = form.getItemValue("QLT_DSN_INST_DH_END");
	var ordNo = formObj.getInput("ORD_NO").value;
	if(isNull(startDt) && !isNull(endDt)){
		dhtmlx.alert("설계의뢰 시작일을 입력해주세요.");
		form.setItemFocus("QLT_DSN_INST_DH_START");
		return;
	}else if(!isNull(startDt) && isNull(endDt)){
		dhtmlx.alert("설계의뢰 종료일을 입력해주세요.");
		form.setItemFocus("QLT_DSN_INST_DH_END");
		return;
	}else if(isNull(startDt) && isNull(endDt) && isNull(ordNo)){
		dhtmlx.alert("주문번호를 입력해주세요.");
		form.setItemFocus("ORD_NO");
		return;
	}else if(!isNull(startDt) && !isNull(endDt)){
		if(checkValid(startDt, "YYYYMMDD") && checkValid(endDt, "YYYYMMDD")){
			if(isCompareDate(startDt,endDt)){
				var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
					items[referenceItem].loadData(findUrl);	
			}
		}		
	}else{
		var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
					items[referenceItem].loadData(findUrl);
		
	}
}
function save(eventName,formDivObj,referenceItem){
//	var gridObj =items['C104000040_Grid_1'];
//	var checkRowId = items['C104000040_Grid_1'].getDhxGrid().getCheckedRows(0);
//	var checkRowIdArray = checkRowId.split(',');  
//	for(var i=0; i<checkRowIdArray.length; i++){
//		value = gridObj.getCellValue(checkRowIdArray[0],1);
//		if(isNull(value)){
//			dhtmlx.alert("재설계할 주문번호가 없습니다.");
//			return;
//		}								
//	}
//childindex오류 체크로직 변경 12-07-23
	var gridObj = items['C104000040_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var row_status ="", row_cnt=0;
	for(var i=0; i< grid_cnt; i++){
    row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
    if(!isNull(row_status)){
       row_cnt++;
      }
	}
	
	if(row_cnt==0){
	  dhtmlx.alert("재설계할 대상을 선택해주세요.");
  			return;  
	}else{
		var param= "ServiceName=C104000040-service&job_sts=1&column-info=JOB_STS";
		var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		var cells = xmlObj.getElementsByTagName("cell");
		if(cells.length > 0){						
			dhtmlx.alert("품질설계JOB이 진행중입니다. 잠시후 진행하세요!");
			return;					
		}
		
		var grid = items['C104000040_Grid_1'].getDhxGrid();
		var grid_cnt = grid.getRowsNum();	
		for(var i=0; i< grid_cnt; i++){
			var ord_no = items['C104000040_Grid_1'].getCellValue(grid.getRowId(i),1);
			var ord_ln = items['C104000040_Grid_1'].getCellValue(grid.getRowId(i),2);
			
			var param= "ServiceName=C104000040-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=ORD_NO";
			var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
			var cells = xmlObj.getElementsByTagName("cell");
			if(cells.length > 0){						
				dhtmlx.alert("확정된 주문이 있습니다! 다시 조회후 실행하세요!");
				return;					
			}
	   	}
		
		dhtmlx.confirm({
				title:"[[ 확인 ]]",
				ok:"확인", cancel:"취소",
				text:"재설계 하시겠습니까?",
				callback:function(val){
					if(val){
						items[referenceItem].sendGrid(referenceItem,eventName);
					return;
					}
				}
			});
	}
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
	uiCommon.message("C104000040_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(){ 
	var comboList = items['C104000040_Form_1'].getMasterCombos();
	var formObj   = items['C104000040_Form_1'].getDhxForm();
	var form   = items['C104000040_Form_1'];
	//var fristDay = getCurrentFirstDate();
	//var lastDay = getCurrentLastday();
	//form.setItemValue("QLT_DSN_INST_DH_START",fristDay);
	//form.setItemValue("QLT_DSN_INST_DH_END",lastDay);

	var startDay = getCurrentAddMinusDay('-','',1);
	var endDay = uiCommon.getCurrentDate();
	form.setItemValue("QLT_DSN_INST_DH_START",startDay);
	form.setItemValue("QLT_DSN_INST_DH_END",endDay);
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	form.getItem("QLT_DSN_INST_DH_START").setWeekStartDay(7);
	form.getItem("QLT_DSN_INST_DH_END").setWeekStartDay(7);

	var inputCalendar = formObj.getInput("QLT_DSN_INST_DH_START");
	var inputCalendar1 = formObj.getInput("QLT_DSN_INST_DH_END");
	var calendar= formObj.getCalendar("QLT_DSN_INST_DH_START");	
	var calendar1= formObj.getCalendar("QLT_DSN_INST_DH_END");	

	
	var inputObj = formObj.getInput("ORD_NO");
	inputObj.onkeyup = function(e){	
		if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
	      inputObj.value = inputObj.value.toUpperCase();
	    }	
		e = e||window.event;
		if(e.keyCode == 13){
			find("find","C104000040_Form_1","C104000040_Grid_1");			
		}
	}
	inputCalendar.onkeydown = function(e){
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
	inputCalendar1.onkeydown = function(e){
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
	
	comboList['PRD_NM_CD'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value',function(){
	  comboList['PRD_NM_CD'].selectOption(0,true,true);
	  comboList['PRD_NM_CD'].setOptionHeight(220);
	});
	//comboList['PRD_NM_CD'].setOptionHeight(300);
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

	var inputORD_USG_CD = items["C104000040_Form_1"].getDhxForm().getInput("ORD_USG_CD");
	inputORD_USG_CD.onkeyup = function(){
		inputORD_USG_CD.value = inputORD_USG_CD.value.toUpperCase(); 	
	}
	var inputSPC_AVR = items["C104000040_Form_1"].getDhxForm().getInput("SPC_AVR");
	inputSPC_AVR.onkeyup = function(){
		inputSPC_AVR.value = inputSPC_AVR.value.toUpperCase(); 	
	}	
	var inputCUS_CD = items["C104000040_Form_1"].getDhxForm().getInput("CUS_CD");
	inputCUS_CD.onkeyup = function(){
		inputCUS_CD.value = inputCUS_CD.value.toUpperCase(); 	
	}

/*		
   var inputObj = formObj.getInput("CCL_BOM_NO");
			inputObj.onkeyup = function(e){
				if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
				  inputObj.value = inputObj.value.toUpperCase();
				}	
				e = e||window.event;
				if(e.keyCode == 13){
					formObj.setItemValue("CCL_BOM_NO",inputObj.value);
					find("find","C104000040_Form_1","C104000040_Grid_1");			
				}
			} 
			*/	
	
//	items['C104000040_Form_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	items['C104000040_Form_1'].getDhxForm().detachEvent(onXleForm);
 return true;
}
function onAfterUpdateFinishEvent(){
	 items['C104000040_Form_1'].getDhxForm().resetDataProcessor("updated");
}
function onGridAfterUpdateFinishEvent(){
	 find('find','C104000040_Form_1','C104000040_Grid_1');
}
function onCheckboxEvent(row_id,cell_index,state){
 if(!state){
	 items['C104000040_Grid_1'].setUpdated(row_id,false,"");   
 }
 return true;
}
function onCheckboxHeaderClick(ind,obj){
   if(ind === 0){
    var checked=items['C104000040_Grid_1'].getCheckedRows(0);
    
    if(checked.length > 0){
     items["C104000040_Grid_1"].uncheckAll();
    }else{
     items["C104000040_Grid_1"].checkAll();  
    }   
  }
  return true;
}

function onGridLoadFunction(){ 
	find('find','C104000040_Form_1','C104000040_Grid_1');
	items['C104000040_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}

function doOnRowDblClicked(rowId) {
	var ORD_NO = items['C104000040_Grid_1'].getDhxGrid().cells(rowId,1).getValue();
	var ORD_LN = items['C104000040_Grid_1'].getDhxGrid().cells(rowId,2).getValue();
	parent.newRemoveOpenTab("C104000020","ORD_NO=" + ORD_NO + "&ORD_LN=" +ORD_LN);
}

function serchIcon_ORD_USG_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('ORD_USG_CD','SZ0000','ORD_USG_CD','C104000040_Form_1');\">";
}
function serchIcon_CUS_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C104000040_Form_1');\">";
}
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}

//]]>
-->
</script>
</head>
<body>
<div id="C104000040_Form_1" style="position:absolute;height:88px;width:981px;left:0px;top:0px;">
</div>
<div id="C104000040_Grid_1" style="position:absolute;height:470px;width:977px;left:1px;top:95px;">
</div>
<div id="C104000040_messagebox" style="position:absolute;height:19px;width:978px;left:0px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
	   var onXleForm= items['C104000040_Form_1'].onXLEEvent(onFormLoadFunction);
	   var onXleGrid= items['C104000040_Grid_1'].onXLEEvent(onGridLoadFunction);
	   items["C104000040_Grid_1"].onCheckboxEvent(onCheckboxEvent); 
	   items["C104000040_Grid_1"].onHeaderClickEvent(onCheckboxHeaderClick);
	   items["C104000040_Grid_1"].rowDblClicked(doOnRowDblClicked);
	   items["C104000040_Grid_1"].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);	   
	   
//]]>
-->
</script>