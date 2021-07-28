<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000030.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질기준개선이력관리
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  김 종 범
 * CREATE DATE      :  2012.01.04
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 최초생성일자     V1.0      김종범      Initial AVersion
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
품질기준개선이력관리
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000030_Form_1","xml":".\/header\/kr\/C106000030\/C106000030_Form_1.xml","url":"gridC10Data.do","referenceItem":"C106000030_Grid_1","service":"C106000030-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C106000030_Grid_1","xml":".\/header\/kr\/C106000030\/C106000030_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","rowCnt":"19","split":"0","referenceItem":"C106000030_Form_1","service":"C106000030-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000030_messagebox","xml":".\/header\/kr\/C106000030\/C106000030_messagebox.xml","service":"C106000030-service"},' +
      '{"itemType":"menu","renderTo":"C106000030_Menu_2","xml":".\/header\/kr\/C106000030\/C106000030_Menu_2.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000030_Grid_1","service":"C106000030-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
/**
 * @class 품질기준개선이력관리
 * @param {eventName} 이벤트명
 * @return {} 
 * @see dhtmlx , parameters, loadData 
 */
function find(eventName,formDivObj,referenceItem){
	// 날짜 관련 폼 데이터
	var fromDate = items['C106000030_Form_1'].getDhxForm().getInput('QLT_IMV_REQ_DH_FR').value;
	var toDate = items['C106000030_Form_1'].getDhxForm().getInput('QLT_IMV_REQ_DH_TO').value;
	
	// 입력받을 타입을 검사
	fromDate = get_DateTypeDay(fromDate);
	toDate = get_DateTypeDay(toDate);
	
	if(fromDate == '' || toDate == ''){
		dhtmlx.alert({
            ok:"확인",
            text:"의뢰일자를 입력하지 않았습니다!",
            callback:function(val){
              if(val){
                items['C106000030_Form_1'].setItemFocus('FROM_DAY');
              }
           }
      	});
	  return ;
	}
	if(fromDate > toDate){
		dhtmlx.alert({
            ok:"확인",
            text:"의뢰일자를 잘못 입력하였습니다!",
            callback:function(val){
              if(val){
                items['C106000030_Form_1'].setItemFocus('FROM_DAY');
              }
           }
      	});
		return ;
	}
    var findUrl = uiCommon.parameters('C106000030_Form_1','C106000030_Grid_1',eventName);
    items['C106000030_Grid_1'].loadData(findUrl);
}

function save(eventName,formDivObj,referenceItem){   
    var gridObj = items['C106000030_Grid_1'].getDhxGrid();
    var grid_cnt = gridObj.getRowsNum();
	if(!isNull(gridObj.getSelectedRowId())){	
		gridObj.selectRowById(gridObj.getSelectedRowId());
	}
	var row_status = "", qlt_imv_sts_cd = "", grd_day="", err_cnt = 0, chgCnt = 0;
	for(var i=0; i< grid_cnt; i++){
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		if(row_status !== ""){
			chgCnt++;
			qlt_imv_sts_cd = gridObj.cellById(gridObj.getRowId(i),1).getValue();
			qlt_imv_req_prs_id = gridObj.cellById(gridObj.getRowId(i),3).getValue();					
			
			     if(row_status != "deleted" && qlt_imv_sts_cd == "" ){
				  err_cnt++;
				  dhtmlx.alert("품질개선상태코드를 선택해주세요.");
				break;
			    }			    
			     if(row_status != "deleted" && qlt_imv_req_prs_id == "" ){
				  err_cnt++;
				  dhtmlx.alert("품질개선의뢰자를 선택해주세요.");
				break;
			    }			    
		}
	}
	if(err_cnt==0){
		if(chgCnt == 0) {
			dhtmlx.alert("변경된 데이터가 없습니다.");
			return false;
		}else{
		    // dhtmlx.alert(row_status);
		 	 dhtmlx.confirm({
				ok:"확인", cancel:"취소",
				text:" 입력된 정보를 저장하시겠습니까? ",
				callback:function(val){
				 if(val){
					items[referenceItem].sendGrid(referenceItem,eventName);		   
				 }
				}
			});	
		}
	}
}
//----------------------------------------------------------------------------------------------------
//   '저장'(save) 을 누르고 처리완료 후 바로 '조회'(find)
//----------------------------------------------------------------------------------------------------
function onAfterUpdateFinishEvent(){
	var findUrl = uiCommon.parameters('C106000030_Form_1','C106000030_Grid_1','find');
		items['C106000030_Grid_1'].loadData(findUrl,progressOff);
	return true;
}

function progressOff(){
	uiCommon.progressOff(parent);
	return;
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C106000030_Form_1',referenceItem,'find');
        items['C106000030_Grid_1'].loadData(findUrl);
    //items[referenceItem].loadData(findUrl);	
}
//menu new row event function
function add(referenceItem){
   items[referenceItem].addRow();
}
//menu remove event function
function remove(referenceItem){
		if(items['C106000030_Grid_1'].getSelectedRowId()==null){
			dhtmlx.alert("삭제 대상이 없습니다.");
		}else{
			items[referenceItem].removeRow();
		}
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

//----------------------------------------------------------------------------------------------------
//  messageBox의 메세지 내용 가져오기
//----------------------------------------------------------------------------------------------------
function getMessage(messageBoxId) {
    var msg = document.getElementById(messageBoxId).innerHTML
	return msg.replace("&nbsp;MESSAGE&nbsp;&nbsp;|&nbsp;","");
}
function findMessage(referenceItem){
	//저장 후 조회라면 저장 메세지를 출력하도록 수정
	uiCommon.message("C106000030_messagebox",referenceItem.getUserData("","appMsg"));
	return true;	
}
var formLoadFlag = false;
function onFormLoadFunction(formDivObj){ 
	items['C106000030_Form_1'].setItemValue("QLT_IMV_REQ_DH_TO",uiCommon.getCurrentDate());
	
	var QLT_IMV_REQ_DH_TO = items['C106000030_Form_1'].getItemValue("QLT_IMV_REQ_DH_TO");
	var QLT_IMV_REQ_DH_TO = new Date(QLT_IMV_REQ_DH_TO.substring(5,7)+"/"+QLT_IMV_REQ_DH_TO.substring(8,10)+"/"+QLT_IMV_REQ_DH_TO.substring(0,4)); 
	var QLT_IMV_REQ_DH_FR = dateAdd(QLT_IMV_REQ_DH_TO,-1);	

	items['C106000030_Form_1'].setItemValue("QLT_IMV_REQ_DH_FR",QLT_IMV_REQ_DH_FR);
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	items['C106000030_Form_1'].getItem("QLT_IMV_REQ_DH_FR").setWeekStartDay(7);
	items['C106000030_Form_1'].getItem("QLT_IMV_REQ_DH_TO").setWeekStartDay(7);
	
	var comboList = items['C106000030_Form_1'].getMasterCombos();	  
	comboList['QLT_IMV_STS_CD'].readonly(true,true);       
 	ui.combo.master(comboList['QLT_IMV_STS_CD'] ,'SZ0000','QLT_IMV_STS_CD','totalValue=%,orderBy=value',function(){ 
	comboList['QLT_IMV_STS_CD'].selectOption(0,true,true);
	});
	comboList['QLT_IMV_STS_CD'].DOMelem_input.onkeydown = function(e){
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
	
	
	formLoadFlag = true;
	items['C106000030_Form_1'].setItemFocus('QLT_IMV_REQ_DH_FR');
	items['C106000030_Form_1'].getDhxForm().detachEvent(onXleForm);

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

// 선택된 Grid의 Row ID 구하기
//function getSelectedRowID() {
//	var rowId = items['C106000030_Grid_1'].getDhxGrid().getSelectedRowId();
//	
//	if(rowId == null && 
//	   items['C106000030_Grid_1'].getDhxGrid().getRowsNum() > 0) {
//	   items['C106000030_Grid_1'].getDhxGrid().selectRow(0);
//		rowId = items['C106000030_Grid_1'].getDhxGrid().getSelectedRowId();
//	}
//	
//	return rowId;
//}
function setAutoData(id) {
	items['C106000030_Grid_1'].getDhxGrid().cellById(id,2).setValue(uiCommon.getCurrentDate());
	items['C106000030_Grid_1'].getDhxGrid().cellById(id,1).setValue("");
	items['C106000030_Grid_1'].getDhxGrid().cellById(id,3).setValue("");
}
function onGridLoadEvent(){ 	

	var dhxGridObj = items['C106000030_Grid_1'].getDhxGrid();
	dhxGridObj.detachEvent(onXleGrid);
	var gridCombo0 = dhxGridObj.getColumnCombo(items['C106000030_Grid_1'].getDhxGrid().getColIndexById('QLT_IMV_STS_CD'));//MD 품질개선상태코드
		gridCombo0.loadXML(master_combo_url + '&' + 'category=SZ0000&code=QLT_IMV_STS_CD&totalValue=&orderBy=sequence');//&totalValue=&orderBy=value
		gridCombo0.readonly(true);
			
	if(formLoadFlag){
		var findUrl = uiCommon.parameters('C106000030_Form_1','C106000030_Grid_1','find');
		items['C106000030_Grid_1'].loadData(findUrl);	
	}
}
// 현재일시 가져오기
//function currentDate(){
//   var x = new Date(); 
//    var current_date= x.getFullYear() + '-' + String(x.getMonth()+1).replace(/^(.)$/, "0$1") + '-' + String(x.getDate()).replace(/^(.)$/, "0$1") + ' ' + String(x.getHours()) + ':' + String(x.getMinutes()); 
//    return current_date;
//}


function doFileUpload(rowId){	
	var md_url = "C106000030pop01.jsp?rowId="+rowId;
		md_url += "&QLT_IMV_REQ_NO="+items['C106000030_Grid_1'].getCellByIndexValue(rowId,0);
		
	winObj = new ui.window("C106000030PopWin","품질개선이력관리 파일 등록","0","0","465","405",md_url);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
/**
 * 엔터키를 사용한 그리드 포커스 이동
 * @param {gridObj}	grid object
 * @param {id} 현재 선택된 row의 id
 * @param {ind} 현재 선택된 cell의 id
 */
function chkfocusInd(gridObj,id,ind){
	var row_cnt = gridObj.getRowsNum();
	var ind_cnt = gridObj.getColumnsNum();
	var row_id =gridObj.getRowIndex(id);
	if(	!gridObj.isColumnHidden(ind)){
		if(ind < ind_cnt){
			ind++;
		}else{
			if(row_id<row_cnt){
				row_id++;
				ind=0;
			}
		}
	}else{
		if(row_id<row_cnt){
				row_id++;
				ind=0;
			}
	}
	gridObj.selectCell(row_id,ind);
	gridObj.editCell();
}
function focusMove(id,ind){
	var gridObj = items['C106000030_Grid_1'].getDhxGrid();
	//(그리드객체,rowid,cellid);
	chkfocusInd(gridObj,id,ind);
}
function onEditCellEvent(stage,rId,cInd,nValue,oValue){
	var grid = items["C106000030_Grid_1"];
	var gridObj = items["C106000030_Grid_1"].getDhxGrid();
	var param= "";	

	if(stage==1) { 
		if(cInd == 4){//품질담당자
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'10')){
					dhtmlx.alert("10자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}
  }else if(cInd == 5){//개선사유
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'200')){
					dhtmlx.alert("200자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}
  }else if(cInd == 6){//개선주요내역
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'400')){
					dhtmlx.alert("400자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}	
  }else if(cInd == 7){//기준변경내용
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'400')){
					dhtmlx.alert("400자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}
  }else if(cInd == 8){//개선효과
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'400')){
					dhtmlx.alert("400자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}
		}
	else{
			return true;
		}
	}
   return true;														
}	
//]]>
-->
</script>

</head>
<body>
<div id="C106000030_Form_1" style="position:absolute;height:62px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000030_Grid_1" style="position:absolute;height:465px;width:977px;left:1px;top:92px;">
</div>
<div id="C106000030_messagebox" style="position:absolute;height:19px;width:978px;left:0px;top:567px;">
</div>
<div id="C106000030_Menu_2" style="position:absolute;height:25px;width:981px;left:0px;top:67px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
	var onXleForm = items['C106000030_Form_1'].onXLEEvent(onFormLoadFunction);
	var onXleGrid  = items['C106000030_Grid_1'].onXLEEvent(onGridLoadEvent);	
	items['C106000030_Form_1'].setBackgroundColor("#FFFFFF");	
	
	items['C106000030_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent); 
	items['C106000030_Grid_1'].getDhxGrid().attachEvent("onEnter", focusMove); //Edit Grid Enter Move	
	items["C106000030_Grid_1"].onEditCellEvent(onEditCellEvent);
	
	//행추가시 오늘 날짜 삽입
	items["C106000030_Grid_1"].getDhxGrid().attachEvent("onRowAdded",setAutoData);
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
	var dataProcessor = items["C106000030_Grid_1"].getDhxDataProcess();
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}
//]]>
-->
</script>
