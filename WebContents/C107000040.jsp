<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
품질설계검색결과상세조회
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
      '{"itemType":"form","renderTo":"C107000040_Form_1","xml":".\/header\/kr\/C107000040\/C107000040_Form_1.xml","url":"basicGridData.do","referenceItem":"C107000040_Grid_1","service":"C107000040-service"},' +
      '{"itemType":"grid","renderTo":"C107000040_Grid_1","xml":".\/header\/kr\/C107000040\/C107000040_Grid_1.xml","rowCnt":"22","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C107000040_Form_1","service":"C107000040-service"},' +
      '{"itemType":"messagebox","renderTo":"C107000040_messagebox","xml":".\/header\/kr\/C107000040\/C107000040_messagebox.xml","service":"C107000040-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	// 날짜 관련 폼 데이터
	var fromDate = items['C107000040_Form_1'].getDhxForm().getInput('QLT_DSN_CFM_DH_STR').value;
	var toDate = items['C107000040_Form_1'].getDhxForm().getInput('QLT_DSN_CFM_DH_END').value;
	
	// 입력받을 타입을 검사
	fromDate = get_DateTypeDay(fromDate);
	toDate = get_DateTypeDay(toDate);
	
	if(fromDate == '' || toDate == ''){
		dhtmlx.alert({
            ok:"확인",
            text:"설계확정일자를 입력하지 않았습니다!",
            callback:function(val){
              if(val){
                items['C107000040_Form_1'].setItemFocus('QLT_DSN_CFM_DH_STR');
              }
           }
      	});
	  return ;
	}
	if(fromDate > toDate){
		dhtmlx.alert({
            ok:"확인",
            text:"설계확정일자를 잘못 입력하였습니다!",
            callback:function(val){
              if(val){
                items['C107000040_Form_1'].setItemFocus('QLT_DSN_CFM_DH_STR');
              }
           }
      	});
		return ;
	}
	var findUrl = uiCommon.parameters('C107000040_Form_1','C107000040_Grid_1',eventName); 
	items['C107000040_Grid_1'].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C107000040_Form_1',referenceItem,'find');
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
function doOnRowDblClicked(rowId) {
	var ORD_NO = items['C107000040_Grid_1'].getDhxGrid().cells(rowId,0).getValue();
	var ORD_LN = items['C107000040_Grid_1'].getDhxGrid().cells(rowId,1).getValue();
	parent.newRemoveOpenTab("C104000020","ORD_NO=" + ORD_NO + "&ORD_LN=" +ORD_LN);
}

function onGridLoadEvent(){
	var grid =  items['C107000040_Grid_1'].getDhxGrid();
	var qltDsnCfmDhStr = items['C107000040_Form_1'].getDhxForm().getInput('QLT_DSN_CFM_DH_STR').value;
	var qltDsnCfmDhEnd = uiCommon.getCurrentDate();		
	var customParam = {"QLT_DSN_CFM_DH_STR":qltDsnCfmDhStr,"QLT_DSN_CFM_DH_END":qltDsnCfmDhEnd};
	var findUrl = parametersC11("basicGridData.do",'C107000040_Grid_1','find',customParam);
	items['C107000040_Grid_1'].loadData(findUrl);
	grid.detachEvent(onXleGrid);
}
	
function findMessage(referenceItem){
	uiCommon.message("C107000040_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
/**
 * @class function Form Load시 동작하는 Event
 * @param {} 
 * @return {} 
 * @see dhtmlx , gluegun.ui 참조 function
 */
function onFormLoadEvent(){ 
	 
	items['C107000040_Form_1'].setItemValue("QLT_DSN_CFM_DH_STR",getCurrentMinusDay('-',1,'YYYYMMDD'));
	items['C107000040_Form_1'].setItemValue("QLT_DSN_CFM_DH_END",uiCommon.getCurrentDate());
	
	items['C107000040_Form_1'].getItem("QLT_DSN_CFM_DH_STR").setWeekStartDay(7);
	items['C107000040_Form_1'].getItem("QLT_DSN_CFM_DH_END").setWeekStartDay(7);
	 
    var comboList = items['C107000040_Form_1'].getMasterCombos();
    var form  = items['C107000040_Form_1'];
 	
    comboList['PRD_NM_CD_NM'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD_NM'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value,displayType=all-code',function(){
	  //comboList['PRD_NM_CD_NM'].selectOption(0,true,true);
	});
	//백스페이스 이벤트 막기처리
	comboList['PRD_NM_CD_NM'].DOMelem_input.onkeydown = function(e){
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
	//도금량 ComboXml 설정
	comboList['PRD_NM_CD_NM'].attachEvent("onSelectionChange", function(){
		var gridComboSelectValue = comboList['PRD_NM_CD_NM'].getSelectedValue();
		form.setItemValue("PRD_NM_CD",gridComboSelectValue);
		var category = "";
			if(gridComboSelectValue == "G" || gridComboSelectValue == "3" || gridComboSelectValue == "J" || gridComboSelectValue == "6"){
				category = "SG0000";
			}else if(gridComboSelectValue == "L" || gridComboSelectValue == "4"){
				category = "SL0000";
			}else if(gridComboSelectValue == "E" || gridComboSelectValue == "2"){
				category = "SE0000";
			}
			if(category != ""){
				ui.combo.master(comboList['GW_ASG_CD_NM'],category,'GW_ASG_CD','totalValue=,orderBy=value,displayType=all-code',function(){
				  //comboList['GW_ASG_CD_NM'].selectOption(0,true,true);
				});
			}else{
				comboList['GW_ASG_CD_NM'].setComboText('');
				comboList['GW_ASG_CD_NM'].clearAll();
			}
			//백스페이스 이벤트 막기처리
			comboList['GW_ASG_CD_NM'].DOMelem_input.onkeydown = function(e){
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
			
		//도금량
		comboList['GW_ASG_CD_NM'].attachEvent("onSelectionChange", function(){
			var comboSelectValue = comboList['GW_ASG_CD_NM'].getSelectedValue();
			form.setItemValue("GW_ASG_CD",comboSelectValue);
		});  
	});
	
	
	comboList['MQL_CD_NM'].readonly(true,false);
	ui.combo.master(comboList['MQL_CD_NM'],'SZ0000','MQL_CD','totalValue=,orderBy=value,displayType=all-code',function(){
	});
	//백스페이스 이벤트 막기처리
	comboList['MQL_CD_NM'].DOMelem_input.onkeydown = function(e){
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
	
	comboList['EMBS_CD_NM'].readonly(true,false);
	ui.combo.master(comboList['EMBS_CD_NM'],'SZ0000','EMBS_CD','totalValue=,orderBy=value,displayType=all-code',function(){
	});
	//백스페이스 이벤트 막기처리
	comboList['EMBS_CD_NM'].DOMelem_input.onkeydown = function(e){
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
	
	comboList['PRD_SHP_NM'].readonly(true,false);
	ui.combo.master(comboList['PRD_SHP_NM'],'SZ0000','PRD_SHP','totalValue=,orderBy=value,displayType=all-code',function(){
	});
	//백스페이스 이벤트 막기처리
	comboList['PRD_SHP_NM'].DOMelem_input.onkeydown = function(e){
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
	
	//수지
	comboList['RSN_TP_NM'].readonly(true,false);
	ui.combo.master(comboList['RSN_TP_NM'],'SZ0000','RSN_TP','totalValue=,orderBy=value,displayType=all-code',function(){
	});
	//백스페이스 이벤트 막기처리
	comboList['RSN_TP_NM'].DOMelem_input.onkeydown = function(e){
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
	
	//조도
	comboList['ORD_ROU_CD_NM'].readonly(true,false);
	ui.combo.master(comboList['ORD_ROU_CD_NM'],'SZ0000','ORD_ROU_CD','totalValue=,orderBy=value,displayType=all-code',function(){
	});
	//백스페이스 이벤트 막기처리
	comboList['ORD_ROU_CD_NM'].DOMelem_input.onkeydown = function(e){
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
	
	//스팽글
	comboList['ORD_SPNL_TP_NM'].readonly(true,false);
	ui.combo.master(comboList['ORD_SPNL_TP_NM'],'SZ0000','ORD_SPNL_TP','totalValue=,orderBy=value,displayType=all-code',function(){
	});
	//백스페이스 이벤트 막기처리
	comboList['ORD_SPNL_TP_NM'].DOMelem_input.onkeydown = function(e){
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
	
	//후처리
	comboList['ORD_SUR_HND_CD_NM'].readonly(true,false);
	ui.combo.master(comboList['ORD_SUR_HND_CD_NM'],'SZ0000','ORD_SUR_HND_CD','totalValue=,orderBy=value,displayType=all-code',function(){
	});
	//백스페이스 이벤트 막기처리
	comboList['ORD_SUR_HND_CD_NM'].DOMelem_input.onkeydown = function(e){
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
	
	items['C107000040_Form_1'].getDhxForm().detachEvent(onXleForm);
}
//]]>
-->
</script>
</head>
<body>
<div id="C107000040_Form_1" style="position:absolute;height:63px;width:981px;left:0px;top:0px;">
</div>
<div id="C107000040_Grid_1" style="position:absolute;height:511px;width:980px;left:-1px;top:64px;">
</div>
<div id="C107000040_messagebox" style="position:absolute;height:19px;width:980px;left:-1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleForm = items['C107000040_Form_1'].onXLEEvent(onFormLoadEvent);
	items["C107000040_Grid_1"].rowDblClicked(doOnRowDblClicked);
	var onXleGrid= items['C107000040_Grid_1'].onXLEEvent(onGridLoadEvent);
//]]>
-->
</script>