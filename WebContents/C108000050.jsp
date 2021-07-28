<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000050.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  제품개발 상세 현황
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.05.20
 *
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String PRD_DEV_NO = request.getParameter("PRD_DEV_NO") != null ? request.getParameter("PRD_DEV_NO") : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>제품개발 상세 현황</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C108000050_Form_1","xml":".\/header\/kr\/C108000050\/C108000050_Form_1.xml","url":"basicFormData.do","referenceItem":"C108000050_Grid_1","service":"C108000050-service","actionType":"find","security":"true"},' +
//       '{"itemType":"form","renderTo":"C108000050_Form_2","xml":".\/header\/kr\/C108000050\/C108000050_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000050_Grid_1","service":"C108000050-service","actionType":"find"},' +
//       '{"itemType":"grid","renderTo":"C108000050_Grid_1","xml":".\/header\/kr\/C108000050\/C108000050_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000050_Grid_1","service":"C108000050-service"},' +
//       '{"itemType":"form","renderTo":"C108000050_Form_3","xml":".\/header\/kr\/C108000050\/C108000050_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000050_Form_1","service":"C108000050-service","actionType":"save"},' +
//       '{"itemType":"grid","renderTo":"C108000050_Grid_2","xml":".\/header\/kr\/C108000050\/C108000050_Grid_2.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000050_Grid_1","service":"C108000050-service"},' +
//       '{"itemType":"form","renderTo":"C108000050_Form_4","xml":".\/header\/kr\/C108000050\/C108000050_Form_4.xml","url":"basicFormData.do","referenceItem":"C108000050_Form_5","service":"C108000050-service","actionType":"find"},' +
//       '{"itemType":"grid","renderTo":"C108000050_Grid_3","xml":".\/header\/kr\/C108000050\/C108000050_Grid_3.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000050_Grid_1","service":"C108000050-service"},' +
//       '{"itemType":"form","renderTo":"C108000050_Form_5","xml":".\/header\/kr\/C108000050\/C108000050_Form_5.xml","url":"basicFormData.do","referenceItem":"C108000050_Form_5","service":"C108000050-service","actionType":"find"},' +
//       '{"itemType":"messagebox","renderTo":"C108000050_messagebox","xml":".\/header\/kr\/C108000050\/C108000050_messagebox.xml","service":"C108000050-service"}' +
//    ']';
// var initConfig = JSON.parse(pageConfiguration);

var Form_1 = {"itemType":"form","renderTo":"C108000050_Form_1","xml":".\/header\/kr\/C108000050\/C108000050_Form_1.xml","url":"basicFormData.do","referenceItem":"C108000050_Grid_1","service":"C108000050-service","actionType":"find","security":"true"};
var Form_2 = {"itemType":"form","renderTo":"C108000050_Form_2","xml":".\/header\/kr\/C108000050\/C108000050_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000050_Grid_1","service":"C108000050-service","actionType":"find"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000050_Grid_1","xml":".\/header\/kr\/C108000050\/C108000050_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000050_Grid_1","service":"C108000050-service"};
var Form_3 = {"itemType":"form","renderTo":"C108000050_Form_3","xml":".\/header\/kr\/C108000050\/C108000050_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000050_Form_1","service":"C108000050-service","actionType":"save"};
var Grid_2 = {"itemType":"grid","renderTo":"C108000050_Grid_2","xml":".\/header\/kr\/C108000050\/C108000050_Grid_2.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000050_Grid_1","service":"C108000050-service"};
var Form_4 = {"itemType":"form","renderTo":"C108000050_Form_4","xml":".\/header\/kr\/C108000050\/C108000050_Form_4.xml","url":"basicFormData.do","referenceItem":"C108000050_Form_5","service":"C108000050-service","actionType":"find"};
var Grid_3 = {"itemType":"grid","renderTo":"C108000050_Grid_3","xml":".\/header\/kr\/C108000050\/C108000050_Grid_3.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000050_Grid_1","service":"C108000050-service"};
var Form_5 = {"itemType":"form","renderTo":"C108000050_Form_5","xml":".\/header\/kr\/C108000050\/C108000050_Form_5.xml","url":"basicFormData.do","referenceItem":"C108000050_Form_5","service":"C108000050-service","actionType":"find"};
   
//Form_2.arrow = true;
var initLayout = 
{
	"programId":"C108000050", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"120,160,160,160", "splitter":true, "components": 
 	[
	 	Form_1,
		 {
			"itemType": "layout", "dirType":"row", "childSize":"30", "splitter":false, "components": 
			[
				Form_2,
				Grid_1,				
			]
		},
		{
			"itemType": "layout", "dirType":"row", "childSize":"30", "splitter":false, "components": 
			[		
				Form_3,
				Grid_2,				
			]
		},
		{
			"itemType": "layout", "dirType":"row", "childSize":"30", "splitter":false, "components": 
			[				
				Form_4,
				Grid_3,
			]
		},
		Form_5,
 	]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var formLoadFlag = false;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	findForm1();
	findGrid1();
	findForm5();	
}

function findForm1(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		dhtmlx.alert("개발 번호를 입력하세요.");
		items['C108000050_Form_1'].setItemFocus("PRD_DEV_NO");
		return;
	}

	var findUrl = uiCommon.parameters6("C108000050_Form_1","C108000050_Form_1","findForm1");
	items["C108000050_Form_1"].loadData(findUrl,loadAfterEvent);
}

function findGrid1(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		dhtmlx.alert("개발 번호를 입력하세요.");
		items['C108000050_Form_1'].setItemFocus("PRD_DEV_NO");
		return;
	}
	
	var findUrl1 = C10_parameters16("C108000050_Form_1","C108000050_Grid_1","findGrid1","basicGridData.do","C108000050-service");
	items["C108000050_Grid_1"].loadData(findUrl1,loadAfterEvent1);
}
//grid1 row selected
function findGrid2(){
	var findUrl2 = parameters14('C108000050_Grid_1','C108000050_Grid_2','findGrid2','basicGridData.do');
	items["C108000050_Grid_2"].loadData(findUrl2,loadAfterEvent2);
}
//grid2 row selected
function findGrid3(){
	var findUrl3 = parameters14('C108000050_Grid_2','C108000050_Grid_3','findGrid3','basicGridData.do');
	items["C108000050_Grid_3"].loadData(findUrl3,loadAfterEvent);
}

function findForm5(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");
	if(isNull(prdDevNo)){
		dhtmlx.alert("개발 번호를 입력하세요.");
		items['C108000050_Form_1'].setItemFocus("PRD_DEV_NO");
		return;		
	}
	var findUrl2 = uiCommon.parameters6("C108000050_Form_1","C108000050_Form_5","findForm5");
	items["C108000050_Form_5"].loadData(findUrl2,loadAfterEvent);
}
//개발요청 Spec link
function dev_req_spec_call(){
	var gridSpecObj = items['C108000050_Grid_1'].getDhxGrid();
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");
	var devReqSpecNo = "";

	if (gridSpecObj.getSelectedRowId() != null)
		devReqSpecNo = items['C108000050_Grid_1'].getCellValue(gridSpecObj.getSelectedRowId(),gridSpecObj.getColIndexById("DEV_REQ_SPEC_NO"));
	
	parent.newRemoveOpenTab('C108000070',
								'PRD_DEV_NO=' + prdDevNo + '&DEV_REQ_SPEC_NO=' + devReqSpecNo);	
}
//개발의뢰 BOM link
function dev_req_bom_call(){
	var gridSpecObj = items['C108000050_Grid_1'].getDhxGrid();
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");
	var devReqSpecNo = "";

	if (gridSpecObj.getSelectedRowId() != null)
		devReqSpecNo = items['C108000050_Grid_1'].getCellValue(gridSpecObj.getSelectedRowId(),gridSpecObj.getColIndexById("DEV_REQ_SPEC_NO"));
	
	parent.newRemoveOpenTab('C108000090',
								'PRD_DEV_NO=' + prdDevNo + '&DEV_REQ_SPEC_NO=' + devReqSpecNo);	
}
//개발완료 BOM link
function dev_cmp_bom_call(){
	var gridCmp = items['C108000050_Grid_2'];
	var gridCmpObj = gridCmp.getDhxGrid();
	
	var prdDevNo = "";
	var devReqSpecNo = "";
	var devReqBomNo = "";
	var pntCmpCd = "";

	if (gridCmpObj.getSelectedRowId() != null) {
		prdDevNo = gridCmp.getCellValue(gridCmpObj.getSelectedRowId(),gridCmpObj.getColIndexById("PRD_DEV_NO"));
		devReqSpecNo = gridCmp.getCellValue(gridCmpObj.getSelectedRowId(),gridCmpObj.getColIndexById("DEV_REQ_SPEC_NO"));
		devReqBomNo = gridCmp.getCellValue(gridCmpObj.getSelectedRowId(),gridCmpObj.getColIndexById("DEV_REQ_BOM_NO"));
		pntCmpCdVl = gridCmp.getCellValue(gridCmpObj.getSelectedRowId(),gridCmpObj.getColIndexById("PNT_CMP_CD"));

		var jbSplit = pntCmpCdVl.split('-');
		var pntCmpCd = jbSplit[0];
		
		if(isNull(pntCmpCd)) pntCmpCd = "";
	}
	
	parent.newRemoveOpenTab('C108000110',
								'PRD_DEV_NO=' + prdDevNo + '&DEV_REQ_SPEC_NO=' + devReqSpecNo + '&DEV_REQ_BOM_NO=' + devReqBomNo +'&PNT_CMP_CD=' + pntCmpCd);	
}
//색상개발 link
function clr_dev_call(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");	
	parent.newRemoveOpenTab('C108000130',
								'PRD_DEV_NO=' + prdDevNo);	
}
//특수제품후처리 link
function spc_prd_af_call(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");	
	parent.newRemoveOpenTab('C108000190',
								'PRD_DEV_NO=' + prdDevNo);	
}
//BabyRoll제작 link
function prt_by_roll_call(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");	
	parent.newRemoveOpenTab('C108000150',
								'PRD_DEV_NO=' + prdDevNo);	
}
//잉크젯개발 link
function ink_dev_call(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");	
	parent.newRemoveOpenTab('C108000210',
								'PRD_DEV_NO=' + prdDevNo);	
}
//라미나개발 link
function lmn_dev_call(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");	
	parent.newRemoveOpenTab('C108000170',
								'PRD_DEV_NO=' + prdDevNo);	
}
//시험/분석 link
function prd_tst_call(){
	var prdDevNo = items['C108000050_Form_1'].getItemValue("PRD_DEV_NO");	
	parent.newRemoveOpenTab('C108000230',
								'PRD_DEV_NO=' + prdDevNo);	
}
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
	uiCommon.message("messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(){	
	if(!isNull("<%=PRD_DEV_NO%>")){
	    items['C108000050_Form_1'].setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
	    findForm1();
	}
/* 		comboList['SP_ASG_YN'].DOMelem_input.onkeydown = function(e){
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
		
		var inputCD_V = items["C108000050_Form_1"].getDhxForm().getInput("ORD_USG_CD");
		inputCD_V.onkeyup = function(){
			inputCD_V.value = inputCD_V.value.toUpperCase(); 	
		}
*/		
	formLoadFlag = true;
	items['C108000050_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function onFormLoadFunction5(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
	   findForm5();
	}		
	items['C108000050_Form_5'].getDhxForm().detachEvent(onXleForm5);
}
function onGridLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
	   findGrid1();
	}
	//items['C108000050_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C108000050_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onGridAfterUpdateFinishEvent(){
	var gridObj = items['C108000050_Grid_1'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj.getRowId(i);
        items['C108000050_Grid_1'].setUpdated(rowID,false,""); 
	}
	items['C108000050_Grid_1'].clearDataProcess();
	// items['C108000050_Grid_1'].getDhxGrid().resetDataProcessor("updated");
}
function serchIcon(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('ORD_USG_CD','SZ0000','ORD_USG_CD','C108000050_Form_1');\">";
}
var winObj;
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	var ordUsgCd = items['C108000050_Form_1'].getItemValue("ORD_USG_CD"); 
	winObj = new ui.window("masterPopup","masterPopup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId+"&CD_V="+ordUsgCd);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}
function loadAfterEvent(){
	uiCommon.progressOff(parent);
  	return true;
}
function loadAfterEvent1(){
	uiCommon.progressOff(parent);
	
	var grid1Obj = items['C108000050_Grid_1'].getDhxGrid();
	
	if ( grid1Obj.getRowsNum() > 0 ) { 
		grid1Obj.selectRow(0,true);
	}

	findMessage(grid1Obj);
  	return true;
}
function loadAfterEvent2(){
	uiCommon.progressOff(parent);

	var grid2Obj = items['C108000050_Grid_2'].getDhxGrid();
	
	if ( grid2Obj.getRowsNum() > 0 ) { 
		grid2Obj.selectRow(0,true);
	}
	
	findMessage(grid2Obj);
  	return true;
}

//]]>
</script>
</head>
<body>
	<!-- <div id="C108000050_Form_1" style="position: absolute; height: 121px; width: 981px; left: 0px; top: 0px;">
	</div>
	<div id="C108000050_Form_2"	style="position: absolute; height: 28px; width: 975px; left: 1px; top: 124px;">
	</div>
	<div id="C108000050_Grid_1"	style="position: absolute; height: 98px; width: 977px; left: 0px; top: 153px;">
	</div>
	<div id="C108000050_Form_3"	style="position: absolute; height: 28px; width: 975px; left: 1px; top: 252px;">
	</div>
	<div id="C108000050_Grid_2"	style="position: absolute; height: 98px; width: 977px; left: 0px; top: 281px;">
	</div>
	<div id="C108000050_Form_4"	style="position: absolute; height: 28px; width: 975px; left: 1px; top: 380px;">
	</div>
	<div id="C108000050_Grid_3"	style="position: absolute; height: 98px; width: 977px; left: 0px; top: 409px;">
	</div>
	<div id="C108000050_Form_5"	style="position: absolute; height: 59px; width: 981px; left: 0px; top: 507px;">
	</div>
	<div id="C108000050_messagebox"	style="position: absolute; height: 19px; width: 977px; left: 1px; top: 567px;">
	</div> -->
</body>
</html>
<script>//<![CDATA[
	ui.initializeDHTMLX();          
	//items['C105000020_Form_1'].setBackgroundColor("#FFFFFF");
	//items['C108000050_Form_2'].setBackgroundColor("#FFFFFF");
	//items['C108000050_Form_3'].setBackgroundColor("#FFFFFF");
	//items['C108000050_Form_4'].setBackgroundColor("#FFFFFF");
	//items['C108000050_Form_5'].setBackgroundColor("#C8FAC8");
	items["C108000050_Grid_1"].rowSelected(findGrid2);
	items["C108000050_Grid_2"].rowSelected(findGrid3);
	var onXleForm = items['C108000050_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000050_Grid_1'].onXLEEvent(onGridLoadFunction);	
	var onXleForm5 = items['C108000050_Form_5'].onXLEEvent(onFormLoadFunction5);
	
//]]>
</script>