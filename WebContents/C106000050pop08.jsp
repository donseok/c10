<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String CLR_SUB_MTL_CD_SH = request.getParameter("CLR_SUB_MTL_CD_SH") !=null ? request.getParameter("CLR_SUB_MTL_CD_SH") : "";

	PosUser	user		= (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String		userNo	= "";
	String		userName= "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
		userName= (String)user.getUserInfo("USER_NAME");
	}
%>    
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>미사용 코드 찾기</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>

<style type="text/css">

#HtmlObj_1 {
    display: flex;
	flex-direction: column;    
}

.tableTitle {
    margin: 20px 0; /* 상하 여백 추가 */
    text-align: center; /* 텍스트 가운데 정렬 */
    font-size: 24px; /* 폰트 크기 조정 */
}


#styledTable {
  border-collapse: collapse;
  margin-top: 20px;
  margin-left: 80px; /* 그리드와의 간격 */
  margin-right: 80px;
  float: left;
  background: linear-gradient(to bottom, #ffffff 0%, #f1f1f1 100%); /* 그라데이션 배경 */
}

#styledTable th, #styledTable td {
  border: 1px solid #ddd; /* 테두리 색상 */
  padding: 8px 16px; /* 셀 안쪽 여백 */
  text-align: left; /* 텍스트 정렬 */
}

#styledTable th {
  background-color: #224EA7; /* 헤더 배경색 */
  color: white; /* 헤더 글꼴 색상 */
}

/* 각 행에 마우스 오버 시 배경색 변경 */
#styledTable tr:hover {background-color: #ddd;}

/* 첫 번째 행(제목 행)은 마우스 오버 시 스타일 변경 제외 */
#styledTable tr:first-child:hover {background-color: #4CAF50;}
</style>

<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C106000050pop08_Form_1","xml":".\/header\/kr\/C106000050pop08\/C106000050pop08_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000050pop08_Grid_1","service":"C106000050pop08-service","actionType":"save"},' +
//       '{"itemType":"grid","renderTo":"C106000050pop08_Grid_1","xml":".\/header\/kr\/C106000050pop08\/C106000050pop08_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000050pop08_Form_1","service":"C106000050pop08-service","actionType":"save"},' +
//       '{"itemType":"htmlObj","renderTo":"HtmlObj_1"}'
//       '{"itemType":"messagebox","renderTo":"C106000050pop08_messagebox","xml":".\/header\/kr\/C106000050pop08\/C106000050pop08_messagebox.xml","service":"C106000050pop08-service"}' +
//    ']';
// var initConfig = JSON.parse(pageConfiguration);	     

var Form_1 = {"itemType":"form","renderTo":"C106000050pop08_Form_1","xml":".\/header\/kr\/C106000050pop08\/C106000050pop08_Form_1.xml","url":"gridC10Data.do","referenceItem":"C106000050pop08_Grid_1","service":"C106000050pop08-service","actionType":"find","security":"true"};
var Grid_1 = {"itemType":"grid","renderTo":"C106000050pop08_Grid_1","xml":".\/header\/kr\/C106000050pop08\/C106000050pop08_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000050pop08_Form_1","service":"C106000050pop08-service","actionType":"save"};
var HtmlObj_1 = {"itemType":"htmlObj","renderTo":"HtmlObj_1"};

var initLayout = 
{
	"programId":"C106000050pop08",
	"itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"60,*", "splitter":false, "components": 
	[
	    Form_1,
		{
			"itemType": "layout", "dirType":"col", "childSize":"30%,*", "splitter":false, "components": 
			[
				Grid_1,
				HtmlObj_1
			]
		}
	]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(){
	
	var formObj = items['C106000050pop08_Form_1'].getDhxForm();
	var disits = formObj.getItemValue("DISITS");	
	var searchCode = formObj.getItemValue("CLR_SUB_MTL_CD_SH");
	
	if(disits =="1" && (searchCode == null || searchCode == "")){
		dhtmlx.alert('4자리 검색은 1글자 이상 입력 후 조회하세요.');
		return;
	}
	
	if(disits =="2" && searchCode.length < 4){
		dhtmlx.alert('5자리 검색은 4글자 입력 후 조회하세요.');
		return;
	}	
	
	
	if(disits == "1"){
		var findUrl = uiCommon.parameters('C106000050pop08_Form_1','C106000050pop08_Grid_1','find');		
	}else if(disits == "2"){
		var findUrl = uiCommon.parameters('C106000050pop08_Form_1','C106000050pop08_Grid_1','find2');
	}
	
    items['C106000050pop08_Grid_1'].loadData(findUrl);
}
function choice(rowId){	
	var selectRowId = items['C106000050pop08_Grid_1'].getSelectedRowId();
	if(selectRowId != null){
		doOnRowDblClicked(selectRowId);
	}else{
		dhtmlx.alert("미사용 코드를 선택해주세요.");
		return;
	}
	
}
function winClose(eventName,formDivObj,referenceItem){
	parent.winObj.winClose();
}

function onCheckEvent(row_id, cell_index, state){ 
	if(state) {
		//체크값 체크 시
    	items['C106000050pop08_Grid_1'].setUpdated(row_id,true,"updated"); 
    }else{
    	//체크해제 시
    	items['C106000050pop08_Grid_1'].setUpdated(row_id,false,"updated"); 
    }
}
function findMessage(referenceItem){
	uiCommon.message("C106000050pop08_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
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
	var UNUSED_CODE = items['C106000050pop08_Grid_1'].getDhxGrid().cells(rowId,0).getValue();
	
	parent.masterSetValue(UNUSED_CODE,'C106000050_Form_1');
	parent.winObj.winClose();	
	
    // 부모 창의 입력 필드에 값을 설정
//     window.opener.document.getElementById('CLR_SUB_MTL_CD_SH').value = UNUSED_CODE;
//     window.close();	
	
// 	parent.newRemoveOpenTab("C106000050","CLR_SUB_MTL_CD_SH=" + UNUSED_CODE);
	}



function onFormLoadFunction(formDivObj){
	
	
	// 입고일자 세팅 및 backspace 입력 방지 처리
// 	setDefaultDate('C106000050pop08_Form_1','SMPL_DH_STR','SMPL_DH_END',-7);

	//작업일자 달력 설정
// 	items['C106000050pop08_Form_1'].getItem("SMPL_DH_STR").setWeekStartDay(7);
// 	items['C106000050pop08_Form_1'].getItem("SMPL_DH_END").setWeekStartDay(7);
	
// 	var comboList = items['C106000050pop08_Form_1'].getMasterCombos();	   
//  	ui.combo.master(comboList['SMPL_TP'] ,'SZ0010','SMPL_TP','totalValue=%,orderBy=value',function(){
//  		comboList['SMPL_TP'].readonly(true);
// 		comboList['SMPL_TP'].selectOption(0,true,true);
// 		comboList['SMPL_TP'].setOptionHeight(60);
// 	});

	if(!isNull("<%=CLR_SUB_MTL_CD_SH%>")){	
		items['C106000050pop08_Form_1'].setItemValue("CLR_SUB_MTL_CD_SH","<%=CLR_SUB_MTL_CD_SH%>");
		var findUrl = uiCommon.parameters6("C106000050pop08_Form_1","C106000050pop08_Form_1","find");
	}
	items['C106000050pop08_Form_1'].getDhxForm().detachEvent(onXleForm);	
 	
}

function onGridLoadFunction(){

    var findUrl = uiCommon.parameters('C106000050pop08_Form_1','C106000050pop08_Grid_1','find');
    items['C106000050pop08_Grid_1'].loadData(findUrl);

	items["C106000050pop08_Grid_1"].getDhxGrid().detachEvent(onXleGrid);
	return true;		
}
function onAfterUpdateFinishEvent(){
	find('find','C106000050pop08_Form_1','C106000050pop08_Grid_1');

	return true;
}
//]]>
-->
</script>
</head>
<body>
<!-- <div id="C106000050pop08_Form_1" style="position:absolute;height:64px;width:681px;left:0px;top:0px;"></div> -->
<!-- <div id="C106000050pop08_Grid_1" style="position:absolute;height:362px;width:120px;left:0px;top:64px;"></div> -->

<div id="HtmlObj_1" style="height:362px;">
	<h2 class="tableTitle">※[안내] 칼라코드 생성 규칙 </h2>
	<table id="styledTable">
		<tr>
		    <th>코드</th>
			<th>색상</th>
		</tr>
		<tr>
		    <td>A,B,C</td>
			<td>BLUE</td>
		</tr>
		<tr>
		    <td>D,G,I</td>
			<td>GREEN</td>
		</tr>
		<tr>
		    <td>L,M,N</td>
			<td>GRAY</td>
		</tr>
		<tr>
		    <td>H,W,X</td>
			<td>WHITE</td>
		</tr>
		<tr>
		    <td>E,F</td>
			<td>BEIGE</td>
		</tr>
		<tr>
		    <td>K</td>
			<td>BLACK</td>
		</tr>
		<tr>
		    <td>O</td>
			<td>ORANGE</td>
		</tr>
		<tr>
		    <td>R,S</td>
			<td>RED,BROWN</td>
		</tr>
		<tr>
		    <td>Y</td>
			<td>YELLOW</td>
		</tr>										
	</table>
</div>


<!-- <div id="C106000050pop08_messagebox" style="position:absolute;height:23px;width:680px;left:0px;top:428px;"></div> -->
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
       var onXleForm = items['C106000050pop08_Form_1'].onXLEEvent(onFormLoadFunction);
       var onXleGrid = items['C106000050pop08_Grid_1'].onXLEEvent(onGridLoadFunction);
//        items['C106000050pop08_Grid_1'].onCheckboxEvent(onCheckEvent);
//        items['C106000050pop08_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
       items["C106000050pop08_Grid_1"].rowDblClicked(doOnRowDblClicked);       
//]]>
-->
</script>