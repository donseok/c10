<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000230.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  시험/분석
 * DESIGNER NAME    :  전 경 진
 * DEVELOPER NAME   :  전 경 진
 * CREATE DATE      :  2019.07.22
 *
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%
	String PRD_DEV_NO = request.getParameter("PRD_DEV_NO")	!=null ? request.getParameter("PRD_DEV_NO") : "";	
	
	PosUser	user = (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String userNo	= "";
	//String userName = "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
		//userName 	= (String)user.getUserInfo("USER_NAME");
	}
	 
	/* String[] valList = {userNo};
		String ctl_tp = ""; 
	try{
	//MASTER 기준 데이터를 읽어온다.
	PosRuleVO result = EasyAccess.getPosRule("C10A2183", valList, null);
	    
	    if(result.getRecordCount() > 0){
	    ctl_tp      = result.getRuleValueAt("TP");        //화면제어여부
	    }
	}catch(Exception e){
	} */
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>개발요청 SPEC</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">

//<![CDATA[
var items = new Array();  //public dhtmlx component array

var Form_1 = {"itemType":"form","renderTo":"C108000230_Form_1","xml":".\/header\/kr\/C108000230\/C108000230_Form_1.xml","url":"gridC10Data.do","referenceItem":"C108000230_Grid_1","service":"C108000230-service","actionType":"find","security":"true"};
var Menu_1 = {"itemType":"menu","renderTo":"C108000230_Menu_1","xml":".\/header\/kr\/C108000230\/C108000230_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C108000230_Grid_1","service":"C108000230-service"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000230_Grid_1","xml":".\/header\/kr\/C108000230\/C108000230_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","referenceItem":"C108000230_Grid_1","service":"C108000230-service","actionType":"save"};
var Form_2 = {"itemType":"form","renderTo":"C108000230_Form_2","xml":".\/header\/kr\/C108000230\/C108000230_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000230_Grid_1","service":"C108000230-service","actionType":"find"};
var Form_3 = {"itemType":"form","renderTo":"C108000230_Form_3","xml":".\/header\/kr\/C108000230\/C108000230_Form_3.xml","url":"basicFormData.do","referenceItem":"C108000230_Form_1","service":"C108000230-service"};
var Grid_2 = {"itemType":"grid","renderTo":"C108000230_Grid_2","xml":".\/header\/kr\/C108000230\/C108000230_Grid_2.xml","url":"basicGridData.do","contextmenu":"true","borderline":"true","referenceItem":"C108000230_Grid_2","service":"C108000230-service","actionType":"save"};   

Grid_1.menu = Menu_1;
Form_2.header = "*진행 처리";
Form_2.arrow = true;

var initLayout = 
{
	"programId":"C108000230", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"60", "splitter":false, "components": 
 	[
	 	Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"150,450", "splitter":true, "components": 
			[
				Grid_1,
				Form_2,
				{
					"itemType": "layout", "dirType":"row", "childSize":"30", "splitter":true, "components": 
					[
						Form_3,
						Grid_2,
					]
				}
			]
		}
 	]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var formLoadFlag = false;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	findTestGrid();
}
function save(eventName,formDivObj,referenceItem){
	
	var grid = items[referenceItem];
	var gridObj = items[referenceItem].getDhxGrid();	
	var grid_cnt = gridObj.getRowsNum();
	var statusCnt = 0;
	
	for(var i=0; i< grid_cnt; i++){
		var row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		
		if(row_status == 'inserted' || row_status == 'updated'){
	      	var cmpRgsDh = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('CMP_RGS_DH'));
	      	if(isNull(cmpRgsDh)){       		
	      		dhtmlx.alert("완료 기한은 필수 입력입니다.");
	      		return;	
	      	}
	      	
	      	var tstTitle = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('TST_TITLE'));
	      	if(isNull(tstTitle)){        		
	      		dhtmlx.alert("테스트 제목은 필수 입력입니다.");
	      		return;	
	      	}	      	
	       	var tstCmp = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('TST_CMP'));
	      	if(isNull(tstCmp)){        		
	      		dhtmlx.alert("테스트 수행처는 필수 입력입니다.");
	      		return;	
	      	}
		}
		
		if(row_status == 'updated' || row_status == 'deleted'){
			var tstPrgCd = grid.getCellValue(gridObj.getRowId(i),gridObj.getColIndexById('TST_PRG_CD'));
	      	if(tstPrgCd.substring(0,2) != '10' ){	      		
	      		dhtmlx.alert("10-의뢰 에서 처리 가능 합니다.");
	      		return;	
	      	}
		}
		
		if(row_status != '')
			statusCnt++;
	}

	if(statusCnt <= 0){
		dhtmlx.alert("저장할 데이타가 없습니다.");
		return;
	}
	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){				
				items[referenceItem].sendGrid(referenceItem,eventName);
				return;
			}
		}
	});	
}

function findTestGrid(){
	var form = items['C108000230_Form_1'];
	var formObj = form.getDhxForm();
	
	var startDt = formObj.getInput("TST_RGS_DH_FR").value;
	var endDt = formObj.getInput("TST_RGS_DH_TO").value;   

	if(isNull(startDt) && !isNull(endDt)){
		dhtmlx.alert("요청 시작일을 입력해주세요.");
		form.setItemFocus("REQ_RGS_DH_FR");
		return;
	}else if(!isNull(startDt) && isNull(endDt)){
		dhtmlx.alert("요청 종료일을 입력해주세요.");
		form.setItemFocus("REQ_RGS_DH_TO");
		return;
	}else if(isNull(startDt) && isNull(endDt)){
		dhtmlx.alert("요청일는 입력해야 합니다.");
		form.setItemFocus("REQ_RGS_DH_FR");
		return;
	}else{
		var findUrl = uiCommon.parameters("C108000230_Form_1","C108000230_Grid_1","find");
		items['C108000230_Grid_1'].loadData(findUrl,loadAfterEvent);
	}
}
//grid1 row selected
function findSmpGrid(){
	var findUrl2 = parameters14('C108000230_Grid_1','C108000230_Grid_2','findSmp','basicGridData.do');
	items['C108000230_Grid_2'].loadData(findUrl2,loadAfterEvent2);
}

function bindingFormToGrid(value, text) {
	if(value == 'CMP_RGS_DH' || value == 'TST_CMP_DH')
		text = items['C108000230_Form_2'].getItemValue(value);
	
	var grid = items['C108000230_Grid_1'];
	var dhxGrid = grid.getDhxGrid();
	var rowID = dhxGrid.getSelectedRowId();

	if (rowID != null) {
		for(var i = 0; i < dhxGrid.getColumnsNum(); i++) {
			if(dhxGrid.getColumnId(i) === value) {
				dhxGrid.cells(rowID, i).setValue(text);
				grid.setUpdated(rowID, true, 'updated');
			}
		}
	} else {
		dhtmlx.alert("선택된 Row가 없습니다.");
	}
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    findTestGrid();
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
//menu edit event function
function edit(referenceItem){
	var form2 = items['C108000230_Form_2'];
	var formObj2 = form2.getDhxForm();
	if(formObj2.isLocked()){
		formObj2.unlock();
		var tstTp = form2.getItemValue("TST_TP");
		onFormtstTpEnable(tstTp);
	} else {
		formObj2.lock();
	}
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
	var form   = items['C108000230_Form_1'];
	var formDhxObj = form.getDhxForm();
	
	if(!isNull("<%=PRD_DEV_NO%>")){
		form.setItemValue("PRD_DEV_NO","<%=PRD_DEV_NO%>");
	}
	formLoadFlag = true;
	
	var param = "ServiceName=C108000230-service&userChk=1&SMTL_SLP_CD="+<%=userNo%>+"&column-info=SMTL_SLP_CD,SMTL_SLP_NM";
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell");
	if(cells.length == 0) 
		 formDhxObj.showItem('TST_OUT_CMP');
	else{
		 form.setItemValue('TST_OUT_CMP', <%=userNo%>);
		 formDhxObj.hideItem('TST_OUT_CMP');  
	}	
	form.setItemValue("TST_RGS_DH_FR",firstDay());
	form.setItemValue("TST_RGS_DH_TO",uiCommon.getCurrentDate());
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	form.getItem("TST_RGS_DH_FR").setWeekStartDay(7);
	form.getItem("TST_RGS_DH_TO").setWeekStartDay(7);
	
	var comboList = form.getMasterCombos();
	
 	comboList['TST_CMP'].readonly(true,false);
	ui.combo.master(comboList['TST_CMP'],'SZ0000','TST_CMP','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['TST_CMP'].readonly(true);
		comboList['TST_CMP'].setOptionHeight(120);
		comboList['TST_CMP'].setOptionWidth(100);
		
	}); 	
	comboList['TST_PRG_CD'].readonly(true,false);
	ui.combo.master(comboList['TST_PRG_CD'],'SZ0000','TST_PRG_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['TST_PRG_CD'].readonly(true);
		comboList['TST_PRG_CD'].setOptionHeight(120);
		comboList['TST_PRG_CD'].setOptionWidth(100);
	});
	
	items['C108000230_Form_1'].getDhxForm().detachEvent(onXleForm);
}

function onGridLoadFunction(){
	if(!isNull("<%=PRD_DEV_NO%>") && (formLoadFlag)){
		findTestGrid();
	}
	items['C108000230_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C108000230_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}

function onSelectGrid(){
	var grid = items['C108000230_Grid_1'];
	var gridObj = grid.getDhxGrid();
	var form2 = items['C108000230_Form_2']
	var formObj2 = form2.getDhxForm();
		
	var rowStatus =  gridObj.getUserData(grid.getRowSelectedId(),"!nativeeditor_status");
	//grid.getDhxDataProcess().getState(grid.getRowSelectedId())
	if( rowStatus !== 'inserted') {
		formObj2.lock();
	}
	// 신규 추가된 row일 경우 (행추가)
	else {
		formObj2.unlock(); //폼 에디트 모드로 변경
		var tstTp = form2.getItemValue("TST_TP");
		onFormtstTpEnable(tstTp);
	}
	findSmpGrid();
	
	var grid = items['C108000230_Grid_1'];
	var gridObj = grid.getDhxGrid();
	var curRowId = gridObj.getSelectedRowId();
	if (curRowId != null) {
		var reqFile = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_REQ_FILE'));
		var endFile = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_END_FILE'));
		if(reqFile == 'Y'){
			document.getElementById("save1").src = "./dhtmlx/codebase/imgs/save.gif";
		}
		else {
			document.getElementById("save1").src = "./dhtmlx/codebase/imgs/save_dis.gif";
		}
		if(endFile=='Y'){
			document.getElementById("save2").src = "./dhtmlx/codebase/imgs/save.gif";
		}
		else {
			document.getElementById("save2").src = "./dhtmlx/codebase/imgs/save_dis.gif";
		}
	}
}

function onFormLoadFunction2(){	

	var formObj2 = items['C108000230_Form_2'].getDhxForm();
	formObj2.bind(items['C108000230_Grid_1'].getDhxGrid());

	//Form Input값 변경시 발생 이벤트
	formObj2.attachEvent('onInputChange', function(name, value, form) {
		bindingFormToGrid(name, value);
		if(name == "TST_TP")
	 		onFormtstTpEnable(value);
	});
		
	//Form Combo값 변경시 발생 이벤트
	formObj2.attachEvent('onChange', function(value, text) {
		bindingFormToGrid(value, text);
		if(value == "TST_TP")
			onFormtstTpEnable(text);
		
	});
	
	var comboList = items['C108000230_Form_2'].getMasterCombos();
	
	comboList['TST_TP'].readonly(true,false);
	ui.combo.master(comboList['TST_TP'],'SZ0000','TST_TP','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['TST_TP'].readonly(true);
		comboList['TST_TP'].setOptionHeight(120);
		comboList['TST_TP'].setOptionWidth(200);
	});
	
	comboList['TST_CMP'].readonly(true,false);
	ui.combo.master(comboList['TST_CMP'],'SZ0000','TST_CMP','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['TST_CMP'].readonly(true);
		comboList['TST_CMP'].setOptionHeight(120);
		comboList['TST_CMP'].setOptionWidth(100);
	});

	comboList['TST_LINE'].readonly(true,false);
	ui.combo.master(comboList['TST_LINE'],'SA0006','PROC_CD','totalValue=,orderBy=value,displayType=all-code',function(){
		comboList['TST_LINE'].readonly(true);
		comboList['TST_LINE'].setOptionHeight(120);
		comboList['TST_LINE'].setOptionWidth(100);
	});
	
	onFormtstTpEnable('');

	formObj2.detachEvent(onXleForm2);
}
function onGridLoadFunction2(){
	items['C108000230_Grid_2'].getDhxGrid().detachEvent(onXleGrid2);
}
//
function onGridAfterUpdateFinishEvent(){
/* 	var gridObj = items['C108000230_Grid_1'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj.getRowId(i);
        items['C108000230_Grid_1'].setUpdated(rowID,false,""); 
	}
	items['C108000230_Grid_1'].clearDataProcess(); */
	refresh('C108000230_Grid_1');
}

function serchIcon_TST_OUT_CMP(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('PNT_CMP_CD','SZ0000','TST_OUT_CMP','C108000230_Form_2');\">";
}

var winObj;
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
	if(formId == "C108000230_Form_2") {
		bindingFormToGrid(target, code);
	}
}

function loadAfterEvent(){
	uiCommon.progressOff(parent);
	var grid1Obj = items['C108000230_Grid_1'].getDhxGrid();
		
	if ( grid1Obj.getRowsNum() > 0 ) { 
		items['C108000230_Grid_1'].getDhxGrid().selectRow(0,true);
		findMessage(grid1Obj);
	}
	
  	return true;
}

function loadAfterEvent2(){
	uiCommon.progressOff(parent);
	var grid2Obj = items['C108000230_Grid_2'].getDhxGrid();
	
	if ( grid2Obj.getRowsNum() > 0 ) { 
		items['C108000230_Grid_2'].getDhxGrid().selectRow(0,true);
		findMessage(grid2Obj);
	}
	
	items['C108000230_Form_3'].setItemValue("SIM_CNT",grid2Obj.getRowsNum());
  	return true;
}
//샘플관리 link
function simple_call(){
	var gridObj = items['C108000230_Grid_1'].getDhxGrid();
	var tstNo = "";
	var prdDevNo = "";
	var claimNo = "";

	if (gridObj.getSelectedRowId() != null) {
		tstNo = items['C108000230_Grid_1'].getCellValue(gridObj.getSelectedRowId(),gridObj.getColIndexById("TST_NO"));
		prdDevNo = items['C108000230_Grid_1'].getCellValue(gridObj.getSelectedRowId(),gridObj.getColIndexById("PRD_DEV_NO"));
		claimNo = items['C108000230_Grid_1'].getCellValue(gridObj.getSelectedRowId(),gridObj.getColIndexById("CLAIM_NO"));
	}
	
	parent.newRemoveOpenTab('M205040100', 'TEST_NO=' + tstNo +'&DEV_NO=' + prdDevNo +'&CMPL_NO=' + claimNo);	
}
//TEST 접수
function receive(){
	var grid = items['C108000230_Grid_1'];
	var gridObj = grid.getDhxGrid();
	
	var curRowId = gridObj.getSelectedRowId();

	if (curRowId != null) {	    
	    var tstPrgCd = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_PRG_CD'));
      	if(tstPrgCd.substring(0,2) != '10' ){	      		
      		dhtmlx.alert("10-의뢰 에서 처리 가능 합니다.");
      		return;	
      	}
		var tstNo = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_NO'));
		if(isNull(tstNo)){
		   	dhtmlx.alert("TEST번호 누락");
		   	return;
	    }
	    var tstRspId = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_RSP_ID'));
		if(isNull(tstRspId)){
		   	dhtmlx.alert("수행담당자 누락");
		   	return;	
	    }
	    var tstCmpDh = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_CMP_DH'));
	    if(isNull(tstCmpDh)){
	     	dhtmlx.alert("완료예정일 누락");
	    	return;	
	    }
	    
	    var row_status = gridObj.getUserData(curRowId,"!nativeeditor_status");		
		if(row_status != 'updated')
		    grid.setUpdated(curRowId,"true","updated");
		
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"접수 처리 하시겠습니까?",
			callback:function(val){
				if(val){					
					grid.sendGrid('C108000230_Grid_1','receive');
					return;
				}
			}
		});
	} else {
		dhtmlx.alert("접수할 데이타가 없습니다.");
		return;
	}
}
//TEST 완료
function complete(){
	var grid = items['C108000230_Grid_1'];
	var gridObj = grid.getDhxGrid();
	
	var curRowId = gridObj.getSelectedRowId();

	if (curRowId != null) {
	    
	    var tstPrgCd = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_PRG_CD'));
      	if(tstPrgCd.substring(0,2) != '20' ){	      		
      		dhtmlx.alert("20-접수 에서 처리 가능 합니다.");
      		return;	
      	}
		var tstNo = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_NO'));
		if(isNull(tstNo)){
		   	dhtmlx.alert("TEST번호 누락");
		   	return;
	    }
	    var tstRst = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_RST'));
		if(isNull(tstRst)){	
		   	dhtmlx.alert("Test결과(요약) 누락");
		   	return;	
	    }
		
	    var row_status = gridObj.getUserData(curRowId,"!nativeeditor_status");		
		if(row_status != 'updated')
		    grid.setUpdated(curRowId,"true","updated");;
		
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"완료 처리 하시겠습니까?",
			callback:function(val){
				if(val){					
					grid.sendGrid('C108000230_Grid_1','complete');
					return;
				}
			}
		});
	} else {
		dhtmlx.alert("접수할 데이타가 없습니다.");
		return;
	}
}

function removeSmp(){
	var grid2 = items['C108000230_Grid_2'];
	var grid2Obj = grid2.getDhxGrid();
	
	var curRowId = grid2Obj.getSelectedRowId();

	if (curRowId != null) {
	    var smplNo = grid2.getCellValue(curRowId,grid2Obj.getColIndexById('SMPL_NO'));
		   if(isNull(smplNo)){	
		   	dhtmlx.alert("샘플 번호 누락");
		   	return;	
	    }

	    var tstNo = grid2.getCellValue(curRowId,grid2Obj.getColIndexById('TST_NO'));
	    if(isNull(tstNo)){	
	     	dhtmlx.alert("TEST 번호 누락");
	    	return;	
	    }
		
		grid2.setUpdated(curRowId,"true","updated");
		
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"샘플 연결 해제 하시겠습니까?",
			callback:function(val){
				if(val){					
					items['C108000230_Grid_2'].sendGrid('C108000230_Grid_2','removeSmp');
					return;
				}
			}
		});
	} else {
		dhtmlx.alert("해제할 데이타가 없습니다.");
		return;
	}
}
//테스트 유형별 비활성 처리
function onFormtstTpEnable(tstTp){
	var formObj2 = items['C108000230_Form_2'].getDhxForm();	
	formObj2.forEachItem(function(name){		
		if(name.substring(0,5) != "BLOCK") {
			if(name == 'TST_TP') {
				formObj2.enableItem(name);
			} else {
				if (tstTp == '' || isNull(tstTp)) {
					formObj2.disableItem(name);
				} else {
					if(tstTp == '10' || tstTp == '50' || tstTp == '60') {
						if( name == 'TST_LINE' || name == 'ORD_NO' || name == 'TST_FLD_LOC' || name == 'template'
							|| name == 'TST_NO' || name == 'TST_PRG_CD' || name == 'TST_REQ_ID' || name == 'REQ_RGS_DH' || name == 'TST_START_DH' || name == 'TST_END_DH')
							formObj2.disableItem(name);
						else
							formObj2.enableItem(name);								
					} else if(tstTp == '20' || tstTp == '40') {
						if(name == 'TST_LINE' || name == 'ORD_NO' || name == 'template'
							|| name == 'TST_NO' || name == 'TST_PRG_CD' || name == 'TST_REQ_ID' || name == 'REQ_RGS_DH' || name == 'TST_START_DH' || name == 'TST_END_DH')
							formObj2.disableItem(name);
						else
							formObj2.enableItem(name);	
					} else if(tstTp == '30') {
						if(name == 'TST_OUT_CMP' || name == 'TST_FLD_LOC' || name == 'template'
							|| name == 'TST_NO' || name == 'TST_PRG_CD' || name == 'TST_REQ_ID' || name == 'REQ_RGS_DH' || name == 'TST_START_DH' || name == 'TST_END_DH')
							formObj2.disableItem(name);
						else
							formObj2.enableItem(name);	
					} else {
						formObj2.disableItem(name);
					}
				}
			}
		}
	}); 
}

function setImgIcon(name,val){
	return "<img id=\"save1\" style=\"cursor:pointer\" src='./dhtmlx/codebase/imgs/save_dis.gif' align=\"top\" onClick=\"C10_linkC108000010pop02(1)\">";	
}
function setImgIcon2(name,val){
	return "<img id=\"save2\" style=\"cursor:pointer\" src='./dhtmlx/codebase/imgs/save_dis.gif' align=\"top\" onClick=\"C10_linkC108000010pop02(2)\">";
}

function C10_linkC108000010pop02(val){
	var grid = items['C108000230_Grid_1'];
	var gridObj = grid.getDhxGrid();
	var curRowId = gridObj.getSelectedRowId();
	if (curRowId != null) {
	    var tstNo = grid.getCellValue(curRowId,gridObj.getColIndexById('TST_NO'));
		if(isNull(tstNo)){
		   	dhtmlx.alert("TEST번호 누락");
		   	return;
		}
	else{
			winObj = new ui.window("coilImgRegPopWin","비고 이미지 등록","0","0","465","405", "C108000010pop02.jsp?"
					+ "IMG_RGS_TP=1"
					+ "&PRD_DEV_NO=" + tstNo
					+ "&PRD_DEV_SEQ_NO=" + val
				);
			winObj.setButtonDisable("park,minmax1");
			winObj.setModal();
		}
	
	}
}
function doImgPopUp1(rowIdx){
	C10_linkC108000010pop02(1)
}
function doImgPopUp2(rowIdx){
	C10_linkC108000010pop02(2)
}


//]]>
</script>
</head>
<body>
	<!-- <div id="C108000230_Form_1"	style="position:absolute; height:28px; width:981px; left:0px; top:0px;">
	</div>
	<div id="C108000230_Menu_1"	style="position:absolute; height:28px; width:977px; left:1px; top:32px;">
	</div>
	<div id="C108000230_Grid_1"	style="position:absolute; height:184px; width:975px; left:0px; top:61px;">
	</div>
	<div id="C108000230_Form_2"	style="position:absolute; height:121px; width:981px; left:0px; top:245px;">
	</div>
	<div id="C108000230_Form_3"	style="position:absolute; height:28px; width:975px; left:0px; top:366px;">
	</div>
	<div id="C108000230_Grid_2"	style="position: absolute; height: 170px; width: 977px; left: 0px; top: 394px;">
	</div>	
	<div id="C108000230_messagebox"	style="position: absolute; height: 19px; width: 977px; left: 1px; top: 567px;">
	</div> -->
</body>
</html>
<script>//<![CDATA[
	ui.initializeDHTMLX();          
	// items['C108000230_Form_2'].setBackgroundColor("#C8FAC8");
	items["C108000230_Grid_1"].rowSelected(onSelectGrid);
	var onXleForm = items['C108000230_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid = items['C108000230_Grid_1'].onXLEEvent(onGridLoadFunction);	
    var onXleForm2 = items['C108000230_Form_2'].onXLEEvent(onFormLoadFunction2);
    var onXleGrid2 = items['C108000230_Grid_2'].onXLEEvent(onGridLoadFunction2);
//]]>
</script>