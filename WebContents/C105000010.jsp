<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C105000010.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  占쎌뮇�쒎첎占쏙옙野껓옙�쀯옙��젾鈺곌퀬�� * DESIGNER NAME    :  占쏙옙占쏙옙占쏙옙 * DEVELOPER NAME   :  獄쏉옙占쏙옙占쏙옙 * CREATE DATE      :  2011.12.23
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.12.23     V1.0      獄쏅벡�깍옙占�    Initial Version
 * 癰귨옙瑗랃옙�깆쁽        
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
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C105000010_Form_1","xml":".\/header\/kr\/C105000010\/C105000010_Form_1.xml","url":"gridC10Data.do","referenceItem":"C105000010_Grid_1","service":"C105000010-service","actionType":"save"},' +
      '{"itemType":"menu","renderTo":"C105000010_Menu_1","xml":".\/header\/kr\/C105000010\/C105000010_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C105000010_Grid_1","service":"C105000010-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C105000010_Grid_1","xml":".\/header\/kr\/C105000010\/C105000010_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"2","referenceItem":"C105000010_Grid_1","service":"C105000010-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C105000010\/messagebox.xml","service":"C105000010-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var winObj,winObj2,winObj3,c10popUp_setVal;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	// 날짜 관련 폼 데이터
	var fromDate = items['C105000010_Form_1'].getDhxForm().getInput('INQ_RCP_DH_STR').value;
	var toDate = items['C105000010_Form_1'].getDhxForm().getInput('INQ_RCP_DH_END').value;
	
	// 입력받을 타입을 검사
	fromDate = get_DateTypeDay(fromDate);
	toDate = get_DateTypeDay(toDate);
	
	if(fromDate == '' || toDate == ''){
		dhtmlx.alert({
            ok:"확인",
            text:"Inquiry접수일을 입력하지 않았습니다!",
            callback:function(val){
              if(val){
                items['C105000010_Form_1'].setItemFocus('INQ_RCP_DH_STR');
              }
           }
      	});
	  return ;
	}
	if(fromDate > toDate){
		dhtmlx.alert({
            ok:"확인",
            text:"Inquiry접수일을 잘못 입력하였습니다!",
            callback:function(val){
              if(val){
                items['C105000010_Form_1'].setItemFocus('INQ_RCP_DH_STR');
              }
           }
      	});
		return ;
	}
	/*if((calculateDay(fromDate, toDate, '-')) > 7){ // 7일 이상의 데이터를 조회하면
		dhtmlx.alert('Inquiry접수일 기간은 최대 일주일입니다!');
		return ;
	}*/
	
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
	var gridObj = items['C105000010_Grid_1'].getDhxGrid();
	var selectRowId = gridObj.getSelectedRowId();
	gridObj.selectRowById(selectRowId);
	var grid_cnt = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt; i++){
		var rowStatus = items['C105000010_Grid_1'].getDhxGrid().getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		var cellVal = items['C105000010_Grid_1'].getCellValue(gridObj.getRowId(i),26);
		if( rowStatus == "deleted"){			
			if(cellVal  != "1"){
				alert("삭제는 1:검토의뢰 상태 또는 행추가/삭제 상태만 가능합니다.");			
		        items['C105000010_Grid_1'].setUpdated(gridObj.getRowId(i),false,""); 	
				return;
			}			
		}else if(rowStatus == "updated"){			
			if(cellVal  == "9"){
				alert("상태가 \"종료\" 인경우 저장하실 수 없습니다.");
				return;
			}				
		}
	}
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){
				items['C105000010_Grid_1'].sendGrid('C105000010_Grid_1','save');
			}
		}
	}); 
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C105000010_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);	
}
//menu new row event function
function add(referenceItem){
	var gridDhxObj = items[referenceItem].getDhxGrid();
		items[referenceItem].addRow();
		items['C105000010_Grid_1'].setCellValue(gridDhxObj.getRowId(0),3,"");
		//gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), 3, "ed"); // 확정컬럼 ch로 변경
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
function onFormLoadFunction(formDivObj){ 
	items['C105000010_Form_1'].setItemValue("INQ_RCP_DH_END",uiCommon.getCurrentDate());
	
	var INQ_RCP_DH_END = items['C105000010_Form_1'].getItemValue("INQ_RCP_DH_END");
	var INQ_RCP_DH_END = new Date(INQ_RCP_DH_END.substring(5,7)+"/"+INQ_RCP_DH_END.substring(8,10)+"/"+INQ_RCP_DH_END.substring(0,4)); 
	// 2012년9월11일 김태성 대리 요청전 -1일 -> 요청후 -14일(2주전~금일)로 변경요청
	var INQ_RCP_DH_STR = dateAdd(INQ_RCP_DH_END,-14);  
	items['C105000010_Form_1'].setItemValue("INQ_RCP_DH_STR",INQ_RCP_DH_STR);
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	items['C105000010_Form_1'].getItem("INQ_RCP_DH_STR").setWeekStartDay(7);
	items['C105000010_Form_1'].getItem("INQ_RCP_DH_END").setWeekStartDay(7);
	
	var inputCUS_CD = items["C105000010_Form_1"].getDhxForm().getInput("CUS_CD");
	inputCUS_CD.onkeyup = function(){
		inputCUS_CD.value = inputCUS_CD.value.toUpperCase(); 	
	}	
	
	var comboList = items['C105000010_Form_1'].getMasterCombos();
 	
	comboList['PRD_NM_CD'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value',function(){
	  comboList['PRD_NM_CD'].selectOption(0,true,true);
	});
	comboList['PRD_NM_CD'].setOptionHeight(300);
	//백스페이스 이벤트 막기처리
		//백스페이스 이벤트 막기처리
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
	items['C105000010_Form_1'].getDhxForm().detachEvent(onXleForm);
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
function serchIcon_CUS_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C105000010_Form_1');\">";
}
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId,popupGubun){
	winObj = new ui.window("popup1","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId+"&popupGubun="+popupGubun);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
	winObj.getDhxWindow().attachEvent("onClose", function(win){
		this.hide();
		return true;
	});
}
function masterPopup2(CD_TP,CATEGORY_GROUP_NM,target,formId,popupGubun){
	winObj2 = new ui.window("popup3","popup3","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId+"&popupGubun="+popupGubun);
	winObj2.setButtonDisable("park,minmax1");
	winObj2.setModal();
	winObj2.getDhxWindow().attachEvent("onClose", function(win){
		this.hide();
		return true;
	});
}
function gluePopup(val){
	winObj3 = new ui.window("gluePopup","gluePopup","0","0","669","532","c105000010pop02.do?SPC_AVR="+val);
	winObj3.setButtonDisable("park,minmax1");
	winObj3.setModal();
	winObj3.getDhxWindow().attachEvent("onClose", function(win){
		this.hide();
		return true;
	});
}
function doOnRowClicked(rId,cInd) {
	var grid  = items['C105000010_Grid_1'];
	var inqNo = grid.getDhxGrid().cells(rId,0).getValue();
	var cellVal = grid.getCellValue(rId,cInd);
	if(cInd == 6){
		var val = cellVal.indexOf(":");
		if(val > -1){
			cellVal	= cellVal.substring(0,val);			
		}
		winObj = new ui.window("popup2","고객사","0","0","469","532","masterGridData.do?CD_TP=CUS_CD&CATEGORY_GROUP_NM=SZ0000&targetName="+cInd+"&targetFormID=C105000010_Grid_1&CD_V="+cellVal);
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();	
	}else if(cInd == 7){
		var val = cellVal.indexOf(":");
		if(val > -1){
			cellVal	= cellVal.substring(0,val);			
		}
		winObj = new ui.window("popup3","주문용도","0","0","469","532","masterGridData.do?CD_TP=ORD_USG_CD&CATEGORY_GROUP_NM=SZ0000&targetName="+cInd+"&targetFormID=C105000010_Grid_1&CD_V="+cellVal);
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
	}else if(cInd == 2 || cInd == 3 || cInd == 4 || cInd == 5 || cInd == 8 || cInd == 9 || cInd == 10 || cInd == 11 || cInd == 12 || cInd == 13 || cInd == 14 || cInd == 15 || cInd == 16 || cInd == 17 || cInd == 18 || cInd == 19){
		return true;
	}else{
		if(!isNull(inqNo)){
			parent.newRemoveOpenTab("C105000020","INQ_NO=" + inqNo);
		}	
	}
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,targetDivId){
	if(targetDivId.indexOf('Grid') > -1){
		var rowId = items[targetDivId].getSelectedRowId();
		if(target == "6"){		
			items[targetDivId].setCellValue(rowId,target,code);
			items[targetDivId].setCellValue(rowId,27,code);//고객사
			items['C105000010_Grid_1'].setUpdated(rowId,true,"updated");
		}else if(target == "7"){
			items[targetDivId].setCellValue(rowId,target,code);
			items[targetDivId].setCellValue(rowId,28,code);//주문용도
			items['C105000010_Grid_1'].setUpdated(rowId,true,"updated");
		}else{
			items[targetDivId].setItemValue(target,code);		
		}	
	}else{
		items[targetDivId].setItemValue(target,code);	
	}
//	items[targetDivId].setUpdated(items[targetDivId].getSelectedRowId(),true,"updated");
}
function onGridLoadEvent(){ 
	var gridDhxObj = items['C105000010_Grid_1'].getDhxGrid();
	var gridObj = items['C105000010_Grid_1'];
	var gridCombo = gridDhxObj.getColumnCombo(3); //품명
		gridCombo.loadXML(master_combo_url + '&' + 'category=SZ0000&code=PRD_NM_CD&orderBy=value&displayType=all-code');
		gridCombo.readonly(true,true);
		//백스페이스 이벤트 막기처리
		//품명
		gridCombo.attachEvent("onSelectionChange", function(){	
			var comboValue = gridCombo.getSelectedValue();
			if(!isNull(comboValue)){
				gridObj.setCellValue(gridDhxObj.getSelectedRowId(),29,comboValue);
			}
		});  
		
		
		//도금량 ComboXml 설정
		gridCombo.attachEvent("onSelectionChange", function(){
			var gridCombo3 = gridDhxObj.getColumnCombo(9); //도금량지정코드
			var gridComboSelectValue = gridCombo.getSelectedValue();
			var category = "";
				if(gridComboSelectValue == "G" || gridComboSelectValue == "3" || gridComboSelectValue == "J" || gridComboSelectValue == "6"){
					category = "SG0000";
				}else if(gridComboSelectValue == "L" || gridComboSelectValue == "4"){
					category = "SL0000";
				}else if(gridComboSelectValue == "E" || gridComboSelectValue == "2"){
					category = "SE0000";
				}
				if(category != ""){
					gridCombo3.loadXML(master_combo_url + '&' + 'category='+category+'&code=GW_ASG_CD&orderBy=value&displayType=all-code');
				}else{
					gridCombo3.clearAll();
				}
				gridCombo3.readonly(true,true);
				//백스페이스 이벤트 막기처리
				
				//도금량지정코드
				gridCombo3.attachEvent("onSelectionChange", function(){	
					var comboValue3 = gridCombo3.getSelectedValue();
					if(!isNull(comboValue3)){
						gridObj.setCellValue(gridDhxObj.getSelectedRowId(),34,comboValue3);
					}
				});  
		});  
	
	var gridCombo1 = gridDhxObj.getColumnCombo(4); //제품유형
		gridCombo1.loadXML(master_combo_url + '&' + 'category=SZ0000&code=PRD_SHP&orderBy=value&displayType=all-code');
		gridCombo1.readonly(true,true);
		//백스페이스 이벤트 막기처리
		//제품형태
		gridCombo1.attachEvent("onSelectionChange", function(){	
			var comboValue1 = gridCombo1.getSelectedValue();
			if(!isNull(comboValue1)){
				gridObj.setCellValue(gridDhxObj.getSelectedRowId(),30,comboValue1);
			}
		}); 
	var gridCombo2 = gridDhxObj.getColumnCombo(8); //표면후처리
		gridCombo2.loadXML(master_combo_url + '&' + 'category=SZ0000&code=ORD_SUR_HND_CD&orderBy=value&displayType=all-code');
		gridCombo2.readonly(true,true);
		//백스페이스 이벤트 막기처리
		
		//표면후처리
		gridCombo2.attachEvent("onSelectionChange", function(){	
			var comboValue2 = gridCombo2.getSelectedValue();
			if(!isNull(comboValue2)){
				gridObj.setCellValue(gridDhxObj.getSelectedRowId(),31,comboValue2);
			}
		});
	
	var gridCombo4 = gridDhxObj.getColumnCombo(10); //유통경로
		gridCombo4.loadXML(master_combo_url + '&' + 'category=SZ0000&code=FLOW_CHL&orderBy=value&displayType=all-code');
		gridCombo4.readonly(true,true);
		//백스페이스 이벤트 막기처리
		//유통경로
		gridCombo4.attachEvent("onSelectionChange", function(){	
			var comboValue4 = gridCombo4.getSelectedValue();
			if(!isNull(comboValue4)){
				gridObj.setCellValue(gridDhxObj.getSelectedRowId(),32,comboValue4);
			}
		});
	
	var gridCombo5 = gridDhxObj.getColumnCombo(11); //Edge구분
		gridCombo5.loadXML(master_combo_url + '&' + 'category=SZ0000&code=ORD_EDG_ASG_TP&orderBy=value&displayType=all-code');
		gridCombo5.readonly(true,true);
		//백스페이스 이벤트 막기처리
		//Edge구분
		gridCombo5.attachEvent("onSelectionChange", function(){	
			var comboValue5 = gridCombo5.getSelectedValue();
			if(!isNull(comboValue5)){
				gridObj.setCellValue(gridDhxObj.getSelectedRowId(),33,comboValue5);
			}
		});
	var inqRcpDhEnd = items['C105000010_Form_1'].getItemValue("INQ_RCP_DH_END");
	
	if(!isNull(inqRcpDhEnd)){
		find("find","C105000010_Form_1","C105000010_Grid_1");
	}
	
	items['C105000010_Grid_1'].getDhxGrid().detachEvent(onXleGrid);		
}
function onCellChangedEvent(rId,cInd,nValue){
	var grid = items['C105000010_Grid_1'];
	if(cInd == 5 && !isNull(nValue)){
		grid.setUpdated(rId,true,"updated");
	}else if (cInd == 6 && !isNull(nValue)){
		grid.setUpdated(rId,true,"updated");
	}
}
function create(){
	var grid = items['C105000010_Grid_1'];
	var inqNo = "";
	if(!isNull(grid.getSelectedRowId())){
		inqNo = grid.getDhxGrid().cells(grid.getSelectedRowId(),0).getValue();
	}
	winObj = new ui.window("popup","생산가부이력등록","0","0","634","569","c105000010pop01.do?INQ_NO="+inqNo);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
	winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;
			//winObj.unload();
	});
}

//톤당길이 계산pop up			
function calculate(){			
	//단순하게 화면만 띄운다.	
	winObj = new ui.window("popup","톤당길이계산","0","0","634","569","C105000010pop04.jsp");		
	winObj.setButtonDisable("park,minmax1");		
	winObj.setModal();		
	winObj.getDhxWindow().attachEvent("onClose", function(win){		
			this.hide();
			return true;
			//winObj.unload();
	});		
}			

// popup으로부터 넘겨받은 값 item에 세팅
function masterPopupSetValue(code,name,target,formId){
		c10popUp_setVal(code,name,target,formId);
}
function gluePopupSetValue(val){
	c105000010pop02_setVal(val);
}
function doFileUpload(rowId){	
  var gridObj = items['C105000010_Grid_1'].getDhxGrid();
	var md_url = "C105000010pop03.jsp?rowId="+rowId;
	md_url += "&INQ_NO="+gridObj.cellById(gridObj.getRowId(rowId),0).getValue();
	
		winObj = new ui.window("C105000010PopWin","생산가부이력 파일 등록","0","0","465","405",md_url);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
//]]>
-->
</script>
</head>
<body>
<div id="C105000010_Form_1" style="position:absolute;height:84px;width:981px;left:0px;top:0px;">
</div>
<div id="C105000010_Menu_1" style="position:absolute;height:25px;width:979px;left:1px;top:85px;">
</div>
<div id="C105000010_Grid_1" style="position:absolute;height:454px;width:976px;left:-7px;top:103px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:979px;left:0px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
var onXleForm = items["C105000010_Form_1"].onXLEEvent(onFormLoadFunction);
var onXleGrid = items['C105000010_Grid_1'].onXLEEvent(onGridLoadEvent)
	//items["C105000010_Grid_1"].onCellChangedEvent(onCellChangedEvent);
	items["C105000010_Grid_1"].rowDblClicked(doOnRowClicked);	
    items['C105000010_Form_1'].setBackgroundColor("#FFFFFF");
//]]>
-->
</script>