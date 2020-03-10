<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%--
 * PROGRAM NAME     :  C107000050.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  표준항목관리
 * DESIGNER NAME    :  원성옥                              
 * DEVELOPER NAME   :  원성옥
 * CREATE DATE      :  2015.04.21
 *
 * Date	        Ver       Name       Description
 * ---------   -----    --------  ------------------------
 * 2015.04.21   V1.0     원성옥	  최초작성 
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
표준항목관리
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
'{"itemType":"form","renderTo":"C107000050_Form_1","xml":".\/header\/kr\/C107000050\/C107000050_Form_1.xml","url":"C107000050GridData.do","referenceItem":"C107000050_Grid_1","service":"C107000050-service","actionType":"save","security":"true"},' +
'{"itemType":"menu","renderTo":"C107000050_Menu_1","xml":".\/header\/kr\/C107000050\/C107000050_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C107000050_Grid_1","service":"C107000050-service"},' +
'{"itemType":"grid","renderTo":"C107000050_Grid_1","xml":".\/header\/kr\/C107000050\/C107000050_Grid_1.xml","rowCnt":"21","vertical":"true","url":"C107000050handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C107000050_Grid_1","service":"C107000050-service","actionType":"save"},' +
'{"itemType":"messagebox","renderTo":"C107000050_messagebox","xml":".\/header\/kr\/C107000050\/C107000050_messagebox.xml","service":"C107000050-service"}' +
']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var sysTpComboVal = [['%', '전체'],['MES', 'MES'], ['ERP', 'ERP']];
var dataTpComboVal = [['1', '문자'], ['2', '숫자'], ['3', '일자']];
var nMsg = 0;
var sEventName = "";
var winObj;

/* [조회]
 * 조회 기능을 수행하는 함수 
 */
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
    
}
/* [저장]
 * 저장 버튼 클릭 시 수행하는 함수 
 */
function save(eventName,formDivObj,referenceItem){
	var gridObj = items['C107000050_Grid_1'].getDhxGrid();
	var rowsNum = gridObj.getRowsNum();
	var row_status = "", err_cnt = 0, row_cnt = 0;
	var DT_NM_ID = "", STANDARD_ENGLISH_ID = "", STANDARD_KOREAN_NAME="", DT_NM_DATA_TP="", DT_NM_LEN="", DT_NM_DECIMAL_PREC="", RULE_DT_NM_ID = "";
	
	for(var i = 0 ; i < rowsNum ; i++){			
		if( gridObj.cellByIndex(i,0).getValue() == 1 ){       //체크된 row의 경우
			//DT_NM_ID             = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_ID")).getValue();             //항목ID 
			STANDARD_ENGLISH_ID  = gridObj.cellByIndex(i,gridObj.getColIndexById("STANDARD_ENGLISH_ID")).getValue();  //표준항목ID
			STANDARD_KOREAN_NAME = gridObj.cellByIndex(i,gridObj.getColIndexById("STANDARD_KOREAN_NAME")).getValue(); //표준항목명
			DT_NM_DATA_TP        = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_DATA_TP")).getValue();        //항목Type
			DT_NM_LEN            = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_LEN")).getValue();            //항목길이
			DT_NM_DECIMAL_PREC   = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_DECIMAL_PREC")).getValue();   //항목소수점이하자리
			
			// 필수값 체크 항목 ( 필수값 : 표준항목ID, 표준항목명, 항목Type )
			if(STANDARD_ENGLISH_ID == ""  || STANDARD_KOREAN_NAME =="" || DT_NM_DATA_TP ==""){
				dhtmlx.alert("<strong>※ 필수값을 입력해주세요.</strong> <br />표준항목ID, 표준항목명, 항목Type은 필수값입니다.");
				err_cnt++;
				break;
			}
			
			row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
			if(row_status == 'inserted'){
				//동일한 정보를 입력하였는지 체크
				var param= "ServiceName=C107000050-service&chkUniqueU1=1&STANDARD_ENGLISH_ID="+STANDARD_ENGLISH_ID +
							"&STANDARD_KOREAN_NAME="+STANDARD_KOREAN_NAME +
							"&DT_NM_DATA_TP="+DT_NM_DATA_TP +
							"&DT_NM_LEN="+DT_NM_LEN +
							"&DT_NM_DECIMAL_PREC="+DT_NM_DECIMAL_PREC +
							"&column-info=CHK";
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				// 동일한 정보는 입력할 수 없음
				if(cells.length > 0){
					dhtmlx.alert("※ ["+(i+1)+"행]의 정보와 동일한 정보가 존재합니다. <br /> 표준항목ID, 표준항목명, 항목Type, 길이, 소수점이하값이 같은 값은 존재할 수 없습니다. ");
					err_cnt++;
					break;
					
				}
			}
			// 동일 정보가 아닐경우 업무기준을 체크함
			else{
				//업무기준이 존재할 경우 수정이 불가능
				RULE_DT_NM_ID   = gridObj.cellByIndex(i,gridObj.getColIndexById("RULE_DT_NM_ID")).getValue();   //MasterDataLayout정의ID
					if(RULE_DT_NM_ID > ""){
						dhtmlx.alert("※ ["+(i+1)+"행]의 업무기준이 존재합니다. <br /> 업무기준이 존재하는 경우 수정이 불가능합니다. ");
						err_cnt++;
						break;
					}
			}
			row_cnt++;
		}
	}
	if(row_cnt==0 && err_cnt==0){
		dhtmlx.alert("※ 선택된 행이 존재하지 않습니다.  ");
		return;
	}
	if(err_cnt==0){
		dhtmlx.confirm({
			ok:"확인", cancel:"취소",
			text:" 입력된 정보를 저장하시겠습니까? ",
			callback:function(val){
			 if(val){
				items[referenceItem].sendGrid(referenceItem,eventName);
				sEventName = eventName;
			   return;
			 }
			}
		});	
	}
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C107000050_Form_1',referenceItem,'find');
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
    var gridObj = items["C107000050_Grid_1"].getDhxGrid();
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
	uiCommon.message("C107000050_messagebox",referenceItem.getUserData("","appMsg"));
	
  	return true;
}
function onFormLoadFunction(){
	var formId = 'C107000050_Form_1';
	var gridId = 'C107000050_Grid_1';
	var formObj   = items[formId].getDhxForm(); 
	
	//항목 아이디로 검색 시 대문자변환 및 엔터키 조회
	var inputObj = formObj.getInput("STANDARD_ENGLISH_ID");
	inputObj.onkeyup = function(e){
		if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
		  inputObj.value = inputObj.value.toUpperCase();
		}	
		e = e||window.event;
		if(e.keyCode == 13){
			formObj.setItemValue("STANDARD_ENGLISH_ID",inputObj.value);
			find("find",formId,gridId);			
		}
	}
	//항목명으로 검색 시 엔터키 조회
	var inputObj1 = formObj.getInput("STANDARD_KOREAN_NAME");
	inputObj1.onkeyup = function(e){
		if(e.keyCode == 13){
			formObj.setItemValue("STANDARD_KOREAN_NAME",inputObj1.value);
			find("find",formId,gridId);			
		}
	}
	//MES 모듈구분(CHAIN_CODE) 콤보박스
	var comboList = items[formId].getMasterCombos(); //comboList 객체 생성 구문
 	ui.combo.master(comboList['CHAIN_CODE'],'SZ0000','MES_MOD_TP','totalValue=%,orderBy=value',function(){ 
		  comboList['CHAIN_CODE'].selectOption(0,true,true);
		  comboList['CHAIN_CODE'].readonly(true);
		  comboList['CHAIN_CODE'].setOptionHeight(140);
		});	 	
	
	//시스템구분(SYS_TP) 콤보박스 
	//var comboList = items[formId].getMasterCombos(); //comboList 객체 생성 구문
	 comboList['SYS_TP'].addOption(sysTpComboVal);
	 comboList['SYS_TP'].selectOption(0,true,true);
	 comboList['SYS_TP'].readonly(true);

	
	items[formId].getDhxForm().detachEvent(_onXLEForm);
}
//초기화 
function clear(eventName,formDivObj,referenceItem){
	  var formObj = items[formDivObj];
	  formObj.clear();
	  onFormLoadFunction();
	}
	
//저장 후 조회처리
function onAfterUpdateFinishEvent(){
	var referenceItem ="C107000050_Grid_1";
	var formId        = "C107000050_Form_1";
	
	items[formId].setItemValue("txMsg",C107000050_messagebox.childNodes[0].innerText.substr(11));    // 처리메세지
	//items[formId].setItemValue("txErrMsg",C107000050_messagebox.childNodes[1].innerText.substr(12)); // 에러메세지
	
	var txMsg = items[formId].getItemValue("txMsg");
	var txErrMsg = "";
	//var txErrMsg = items[formId].getItemValue("txErrMsg");
	if(nMsg != 0 && sEventName != "save") {
		winObj.winClose();
		winObj1 = new ui.window("popup","데이터이행","0","0","500","300",false,"C107000050pop01.jsp?txMsg="+txMsg+"&txErrMsg="+txErrMsg);
		winObj1.setModal();
	}
	//이행인경우 (save)가 아닐경우 
	nMsg = 0;
	sEventName="";
	//재조회 
	find('find',formId,'C107000050_Grid_1');

}

/* [그리드 로드]
 * 그리드 로드 시 수행하는 함수 
 */
function onLoadGrid (){
    var grid =  items['C107000050_Grid_1'];
	var gridObj = items['C107000050_Grid_1'].getDhxGrid();
	
	//시스템 구분 그리드 콤보
	var sysTpCombo = gridObj.getColumnCombo(gridObj.getColIndexById('SYS_TP')); 
	sysTpCombo.addOption(sysTpComboVal);    
	sysTpCombo.enableOptionAutoPositioning(true);
	sysTpCombo.readonly(true,true);
	sysTpCombo.setOptionHeight(60);
	
 	//항목 데이터 타입 구분 그리드 콤보
	var dataTypeCombo = gridObj.getColumnCombo(gridObj.getColIndexById('DT_NM_DATA_TP')); 
	dataTypeCombo.addOption(dataTpComboVal);    
	dataTypeCombo.enableOptionAutoPositioning(true);
	dataTypeCombo.readonly(true,true);
	dataTypeCombo.setOptionHeight(80); 
	
	//체인 구분 그리드 콤보
	var chainCombo = gridObj.getColumnCombo(gridObj.getColIndexById('CHAIN_CODE')); 
	chainCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=MES_MOD_TP&totalValue=&orderBy=value&displayType=all-code");   
	chainCombo.enableOptionAutoPositioning(true);
	chainCombo.readonly(true,true);
	chainCombo.setOptionHeight(180);
	
	//사용여부 구분 그리드 콤보
	var useTpCombo = gridObj.getColumnCombo(gridObj.getColIndexById('USE_TP')); 
	useTpCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=USE_YN&totalValue=&orderBy=value&displayType=code-code");
	useTpCombo.enableOptionAutoPositioning(true);
	useTpCombo.readonly(true,true);
	useTpCombo.setOptionHeight(60);
	
	items["C107000050_Grid_1"].getDhxGrid().detachEvent(_onXLEGrid);

}
/* [데이터 이행]
 * 데이터 이행버튼 클릭 시 팝업창을 호출한다. 
 */
function migraiton(rowIdx){
	var gridObj = items['C107000050_Grid_1'].getDhxGrid();
	var rowId = gridObj.getRowIndex(rowIdx);
	var rowsNum = gridObj.getRowsNum();
	
	var row_status = "", err_cnt = 0, row_cnt = 0;
	var STANDARD_ENGLISH_ID = "", STANDARD_KOREAN_NAME = "", DT_NM_DATA_TP = "", DT_NM_LEN = "", DT_NM_DECIMAL_PREC = "";
	var	DT_NM_ID = "", SYS_TP = "", CHAIN_CODE = "",DT_NM_DATA_TP = "", USE_TP = "" ;
	
	for(var i = 0 ; i < rowsNum ; i++){			
		if( gridObj.cellByIndex(i,0).getValue() == 1 ){       //체크된 row의 경우
			DT_NM_ID             = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_ID")).getValue();             //항목ID 
			STANDARD_ENGLISH_ID  = gridObj.cellByIndex(i,gridObj.getColIndexById("STANDARD_ENGLISH_ID")).getValue();  //표준항목ID
			STANDARD_KOREAN_NAME = gridObj.cellByIndex(i,gridObj.getColIndexById("STANDARD_KOREAN_NAME")).getValue(); //표준항목명
			SYS_TP               = gridObj.cellByIndex(i,gridObj.getColIndexById("SYS_TP")).getValue();               //시스템
			CHAIN_CODE           = gridObj.cellByIndex(i,gridObj.getColIndexById("CHAIN_CODE")).getValue();           //부문
			DT_NM_DATA_TP        = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_DATA_TP")).getValue();        //항목Type
			DT_NM_LEN            = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_LEN")).getValue();            //항목길이
			DT_NM_DECIMAL_PREC   = gridObj.cellByIndex(i,gridObj.getColIndexById("DT_NM_DECIMAL_PREC")).getValue();   //항목소수점이하자리
			USE_TP               = gridObj.cellByIndex(i,gridObj.getColIndexById("USE_TP")).getValue();               //사용구분
			
			var param = "ServiceName=C107000050-service&chkUpdateRow=1&DT_NM_ID="+DT_NM_ID +
			 			"&STANDARD_ENGLISH_ID="+STANDARD_ENGLISH_ID +
						"&STANDARD_KOREAN_NAME="+STANDARD_KOREAN_NAME +
						"&SYS_TP="+SYS_TP +
						"&CHAIN_CODE="+CHAIN_CODE +
						"&DT_NM_DATA_TP="+DT_NM_DATA_TP +
						"&DT_NM_LEN="+DT_NM_LEN +
						"&DT_NM_DECIMAL_PREC="+DT_NM_DECIMAL_PREC +
						"&USE_TP="+USE_TP +
						"&column-info=CHK";
			var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
			var cells = xmlObj.getElementsByTagName("cell");
			if(!cells.length > 0){
				dhtmlx.alert("※ ["+(i+1)+"행]의 정보가 수정되었습니다. <br />저장하고 다시 이행하세요. ");
				err_cnt++;
				break;
			}
			row_cnt++;
		}
	}
	if(err_cnt==0 && row_cnt==0){
		dhtmlx.alert("※ 선택된 행이 존재하지 않습니다.  ");
		return;
	}
	if(err_cnt==0){
	winObj = new ui.window("popup","데이터이행","0","0","500","300",false,"C107000050pop01.jsp?");
	winObj.setModal();
	nMsg++;
	}
}

/* [그리드 수정 시]
 * 그리드 데이터 수정 시 수행하는 함수 
 */
function onEdit(stage,rId,cInd,nValue,oValue){
	var gridObj = items['C107000050_Grid_1'].getDhxGrid();
	var grid = items['C107000050_Grid_1'];
	var check = gridObj.getColIndexById("CH");//체크 유무 판별
	
	var index1= gridObj.getColIndexById("DT_NM_ID");//
	var index2= gridObj.getColIndexById("STANDARD_ENGLISH_ID");//

	if(stage == '2'){
		grid.setCellValue(rId,cInd,nValue);	
		return true;
	}
	else if(stage == 1){
		return true;
	}
	else if(stage == '0'){
		if(cInd == check){       // 선택 부분의 정보가 변경 되었을 때
			var state = gridObj.cellByIndex(gridObj.getRowIndex(rId),check).getValue();
		 	if(state == 0){      // 체크된 경우
		 		gridObj.cellByIndex(gridObj.getRowIndex(rId),check).setValue("1");
		
				items['C107000050_Grid_1'].setUpdated(rId,true,'updated');
			}
			else if(state == 1){ //체크가 해지되면 보류사유가 원래의 값으로 되돌아감
				gridObj.cellByIndex(gridObj.getRowIndex(rId),check).setValue("0");
				items['C107000050_Grid_1'].setUpdated(rId,false,'updated');
			}
		}
	}	
}
/* [조건에 따른 배경색 및 글자색 변경]
 * 업무기준이 존재하는 경우 글자색을 빨간색으로 바꾼다
 */
function setTextColor(){
	var gridObj = items['C107000050_Grid_1'].getDhxGrid();
	var rowsNum = gridObj.getRowsNum();
	var RULE_DT_NM_ID = "";
	
	for(var i=0; i<rowsNum; i++){
		RULE_DT_NM_ID   = gridObj.cellByIndex(i,gridObj.getColIndexById("RULE_DT_NM_ID")).getValue();   //MasterDataLayout정의ID
		if(RULE_DT_NM_ID > ""){
			gridObj.setRowTextStyle(gridObj.getRowId(i), "color: red;");
		}
	}
}
//]]>
-->
</script>
</head>
<body>
<div id="C107000050_messagebox" style="position:absolute;height:19px;width:977px;left:0px;top:566px;">
</div>
<div id="C107000050_Form_1" style="position:absolute;height:35px;width:980px;left:0px;top:0px;">
</div>
<div id="C107000050_Grid_1" style="position:absolute;height:502px;width:977px;left:1px;top:61px;">
</div>
<div id="C107000050_Menu_1" style="position:absolute;height:25px;width:980px;left:0px;top:36px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
       items['C107000050_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
       var _onXLEForm =items['C107000050_Form_1'].onXLEEvent(onFormLoadFunction);
   	   var _onXLEGrid = items['C107000050_Grid_1'].onXLEEvent(onLoadGrid);
   	  // items['C107000050_Grid_1'].onXLEEvent(setTextColor);
   	   //그리드 값 변경 시 
   	   items['C107000050_Grid_1'].onEditCellEvent(onEdit);
       //삭제 시 빨간 줄 업데이트 및 인서트 시 bold
       var dataProcessor = items["C107000050_Grid_1"].getDhxDataProcess();
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}
//]]>
-->
</script>