<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000010.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  칼라시편관리
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
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
칼라시편관리
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000010_Form_1","xml":".\/header\/kr\/C106000010\/C106000010_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000010_Grid_1","service":"C106000010-service","actionType":"find","security":"true"},' +
      '{"itemType":"menu","renderTo":"C106000010_Menu_1","xml":".\/header\/kr\/C106000010\/C106000010_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000010_Grid_1","service":"C106000010-service"},' +
      '{"itemType":"grid","renderTo":"C106000010_Grid_1","xml":".\/header\/kr\/C106000010\/C106000010_Grid_1.xml","rowCnt":"18","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000010_Form_1","service":"C106000010-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000010_messagebox","xml":".\/header\/kr\/C106000010\/C106000010_messagebox.xml","service":"C106000010-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var columnList = "CLR_SMP_REQ_NO,CLR_SMP_RCP_NO,CUS_REQ_HUE_TXT,RSN_TP_TXT,RSN_ANL_REQ_YN,SMP_SND_YN,PNT_FLM_THK_TXT,SMP_LUS_YN,LUS_RT_CD,CLR_USE_NM,SAL_CHR_PRS_ID,CUS_CD_TXT,USE_REG_TXT,PRD_NM_CD,PRD_TP_YN,SAL_CHR_REQ_DH,SAL_CHR_RGN_DH,CLR_SMP_RMK,DEV_PNT_CMP_CD,DEV_PNT_CMP_CD_NM,RSN_TP,CLR_SMP_DEV_REQ_DH,CLR_SMP_DEV_LMT_DH,CLR_SMP_DEV_END_DH,CLR_SMP_DEV_SND_DH,SMP_SND_INF,DSN_CHR_RGN_YN,HUE_CD,CCL_BOM_NO,CCL_BOM_RGS_DH,CLR_TP,CLR_TP_NM,SIM_HUE_PRG_YN,DSN_CHR_PRS_ID,CLR_SMP_DSN_RMK,SMP_PRC_MAN,MGR_CAL";
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var formObj = items['C106000010_Form_1'].getDhxForm();
	var form = items['C106000010_Form_1'];
	
	var startDt = formObj.getInput("CLR_SMP_DEV_RCP_DH_START").value;
	var endDt = formObj.getInput("CLR_SMP_DEV_RCP_DH_END").value;
    var clrSmpReqNo = formObj.getInput("CLR_SMP_REQ_NO").value;//의뢰번호
	var clrSmpRcpNo = formObj.getInput("CLR_SMP_RCP_NO").value;//접수번호
	var salChrPrsId = formObj.getInput("SAL_CHR_PRS_ID").value;//영업담당자

	if(isNull(startDt) && !isNull(endDt)){
		alert("의뢰 시작일을 입력해주세요.");
		form.setItemFocus("CLR_SMP_DEV_RCP_DH_START");
		return;
	}else if(!isNull(startDt) && isNull(endDt)){
		alert("의뢰 종료일을 입력해주세요.");
		form.setItemFocus("CLR_SMP_DEV_RCP_DH_END");
		return;
	}else if(isNull(startDt) && isNull(endDt) && isNull(clrSmpReqNo) && isNull(clrSmpRcpNo) && isNull(salChrPrsId)){
		alert("하나 이상의 검색조건을 입력해야 합니다.");
		form.setItemFocus("CLR_SMP_RCP_NO");
		return;
	}else{
		var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
					items[referenceItem].loadData(findUrl);
	}
}

function save(eventName,formDivObj,referenceItem){
	var gridObj = items['C106000010_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var statusCnt = 0;
	for(var i=0; i< grid_cnt; i++){
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		if(row_status == 'inserted'){
			var cellVal2 = items['C106000010_Grid_1'].getCellValue(gridObj.getRowId(i),2);
			var cellVal3 = items['C106000010_Grid_1'].getCellValue(gridObj.getRowId(i),3);
			var cellVal4 = items['C106000010_Grid_1'].getCellValue(gridObj.getRowId(i),4);
			var cellVal5 = items['C106000010_Grid_1'].getCellValue(gridObj.getRowId(i),5);
			var cellVal6 = items['C106000010_Grid_1'].getCellValue(gridObj.getRowId(i),6);
			var cellVal7 = items['C106000010_Grid_1'].getCellValue(gridObj.getRowId(i),7);
			var cellVal8 = items['C106000010_Grid_1'].getCellValue(gridObj.getRowId(i),8);
			if(isNull(cellVal2) && isNull(cellVal3) && isNull(cellVal4) && isNull(cellVal5) && isNull(cellVal6) && isNull(cellVal7) && isNull(cellVal8)){
				alert("색상정보 또는 사양 정보를 입력해주세요.");
				return;
			}
		}

		if(isNull(row_status)){
			statusCnt++;
		}
	}

	if(statusCnt <= 0){
		alert("저장할 데이타가 없습니다.");
		return;
	}
	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){
				items[referenceItem].sendGrid(referenceItem,eventName,function(){
				    items['C106000010_Grid_1'].clearDataProcess();
				    var findUrl = uiCommon.parameters('C106000010_Form_1','C106000010_Grid_1','find');
				    items['C106000010_Grid_1'].loadData(findUrl);	
				});
			return;
			}
		}
	});  
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C106000010_Form_1',referenceItem,'find');
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

var formLoadFlag = false;
function onFormLoadFunction(){ 
	var formDhxObj   = items['C106000010_Form_1'].getDhxForm();
	var formObj   = items['C106000010_Form_1'];
	items['C106000010_Form_1'].setItemValue("CLR_SMP_DEV_RCP_DH_START",firstDay());
	items['C106000010_Form_1'].setItemValue("CLR_SMP_DEV_RCP_DH_END",uiCommon.getCurrentDate());
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	items['C106000010_Form_1'].getItem("CLR_SMP_DEV_RCP_DH_START").setWeekStartDay(7);
	items['C106000010_Form_1'].getItem("CLR_SMP_DEV_RCP_DH_END").setWeekStartDay(7);	
	
	formLoadFlag = true;

	items['C106000010_Form_1'].getDhxForm().detachEvent(onXleForm);
	
	var comboList = items['C106000010_Form_1'].getMasterCombos();
	comboList['DEV_PNT_CMP_CD'].readonly(true,false);
	ui.combo.master(comboList['DEV_PNT_CMP_CD'],'SZ0000','PNT_CMP_CD','totalValue=%,orderBy=value,displayType=all-code',function(){
		comboList['DEV_PNT_CMP_CD'].selectOption(0,true,true);
		comboList['DEV_PNT_CMP_CD'].readonly(true);
		comboList['DEV_PNT_CMP_CD'].setOptionHeight(240);		
	});
	
}

function onGridLoadFunction(){
	if(formLoadFlag){	
		 find("find",'C106000010_Form_1',"C106000010_Grid_1");
	}
	items['C106000010_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C106000010_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onGridAfterUpdateFinishEvent(){
	var gridObj = items['C106000010_Grid_1'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj.getRowId(i);
        items['C106000010_Grid_1'].setUpdated(rowID,false,""); 
	}
	items['C106000010_Grid_1'].clearDataProcess();
	// items['C106000020_Grid_1'].getDhxGrid().resetDataProcessor("updated");
}


function findMessage(referenceItem){
	uiCommon.message("C106000010_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
/*
function serchIcon1(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('PNT_CMP_CD','SZ0000','DEV_PNT_CMP_CD','C106000010_Form_1');\">";
}
*/

// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}

function create(){
	var grid = items['C106000010_Grid_1'];
	var CLR_SMP_REQ_NO = ""
	if(!isNull(grid.getSelectedRowId())){
		CLR_SMP_REQ_NO = grid.getDhxGrid().cells(grid.getSelectedRowId(),0).getValue();
	}
	winObj = new ui.window("popup","칼라시편등록","0","0","890","520","c106000010pop01.do?CLR_SMP_REQ_NO="+CLR_SMP_REQ_NO);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();

	winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;
			//winObj.unload();
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

function masterPopupSetValue(code,name,target,formId){
	c10popUp_setVal(code,name,target,formId);

}

function onGridAfterUpdateFinishEvent(){
	 find('find','C106000010_Form_1','C106000010_Grid_1');
}

function excelExport(eventName,formDivObj,referenceItem){
	var findUrl = parameters13(formDivObj,eventName, 'excelExportC106000010.do',columnList);
	win = window.open(findUrl, "GGGG", "width=310,height=300,scrollbars=yes"); 
}

function parameters13(){
    if(arguments.length < 1 || arguments.length < 2 || arguments.length <3){
      dhtmlx.alert("function arguments setting not found<br>"+
            "arguments[0] : form div object id<br>"+
            "arguments[1] : event name<br>"+
            "arguments[2] : ServiceUrl<br>"+
            "arguments[3] : columnInfol\n");
      return true;
    }

     var _data = [];
     /** activity serviceName push */
     _data.push(arguments[2]+"?ServiceName="+items[arguments[0]].getServiceName());
     /** activity event push */
     _data.push(arguments[1]+"=1");
     /** dhtmlx item type 에 대한 key,value 추출 calendar는 data를 추출하는 방법이 다름 */
     uiCommon.formParameter(_data,items[arguments[0]].getDhxForm()); 
     /** item 에 대한 rendering 을 하기위한 정보 */
     _data.push("column-info="+arguments[3]);

     return _data.join("&");
}
//도료사별 담당 버튼 클릭시 도료사별 색상개발 담당 팝업 호출
function findClrCmp(){
	winObj = new ui.window('popup','도료사별 색상개발 담당','0','0','848','406','C106000010pop02.jsp?');
	winObj.setModal();
    
}
//]]>
-->
</script>
</head>
<body>
<div id="C106000010_Form_1" style="position:absolute;height:71px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000010_Menu_1" style="position:absolute;height:25px;width:981px;left:0px;top:73px;">
</div>
<div id="C106000010_Grid_1" style="position:absolute;height:467px;width:977px;left:0px;top:97px;">
</div>
<div id="C106000010_messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
	var onXleForm = items['C106000010_Form_1'].onXLEEvent(onFormLoadFunction);
	//var onXleGrid = items['C106000010_Grid_1'].onXLEEvent(onGridLoadFunction);
//]]>
-->
</script>