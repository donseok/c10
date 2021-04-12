<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000100.jsp
 * VERSION                 :  1.0
 * DESCRIPTION          :  CCLBOM이미지관리
 * DESIGNER NAME     :  김종화                              
 * DEVELOPER NAME  :  김종화
 * CREATE DATE         :  2014.05.08
 *
 * Date	        Ver       Name       Description
 * ---------   -----    --------  ------------------------
 * 2012.05.08   V1.0     김종화	  최초작성 
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "com.posdata.glue.context.PosContext" %>
<%@page import = "com.posdata.glue.web.security.*" %>
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%
    PosUser user        = (PosUser)session.getAttribute(PosSecurityConstants.USER);
    String  userNo      = "";
    String  userName    = "";
    if(user!=null) {
        userNo = (String) user.getUserInfo("USER_NO");
        userName = (String) user.getUserInfo("USER_NAME");
    }
    
    String CCL_BOM_NO 		= request.getParameter("CCL_BOM_NO") 	!= null ? request.getParameter("CCL_BOM_NO") 	: "";
%>    
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
CCLBOM이미지관리
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000100_Form_1","xml":".\/header\/kr\/C106000100\/C106000100_Form_1.xml","url":"gridC10Data.do","referenceItem":"C106000100_Grid_1","service":"C106000100-service","actionType":"save","security":"true"},' +
      '{"itemType":"menu","renderTo":"C106000100_Menu_1","xml":".\/header\/kr\/C106000100\/C106000100_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000100_Grid_1","service":"C106000100-service"},' +
      '{"itemType":"grid","renderTo":"C106000100_Grid_1","xml":".\/header\/kr\/C106000100\/C106000100_Grid_1.xml","rowCnt":"22","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000100_Grid_1","service":"C106000100-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000100_messagebox","xml":".\/header\/kr\/C106000100\/C106000100_messagebox.xml","service":"C106000100-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    findUrl +=  "&USER_NO="+'<%=userNo%>';
    items[referenceItem].loadData(findUrl);
}

function save(eventName,formDivObj,referenceItem){
    var gridObj = items['C106000100_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var row_status = "", err_cnt = 0, chgCnt = 0;
	var CCL_BOM_NO = ""

	var rowId = items['C106000100_Grid_1'].getRowSelectedId();
  	gridObj.selectRow(gridObj.getRowIndex(rowId));

	for(var i=0; i< grid_cnt; i++){
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");//INSERT시에만 값체크 하기
		if(row_status !== ""){
			chgCnt++;
			if(row_status=="inserted"){
				CCL_BOM_NO = gridObj.cellById(gridObj.getRowId(i),0).getValue();				
				if(CCL_BOM_NO == "" ){
					err_cnt++;
					dhtmlx.alert("CCL BOM번호를 입력하세요.");
					break;
				}
			
				var param= "ServiceName=C106000100-service&cclbomajax=1&CCL_BOM_NO="+CCL_BOM_NO+"&column-info="+items['C106000100_Grid_1'].getColumnInfo();
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				
				if(cells.item(2).firstChild.nodeValue == ""){
					dhtmlx.alert("존재하지 않는 CCL BOM번호입니다.");
					err_cnt++;
	                break;   
				}else if(cells.item(17).firstChild.nodeValue > 0){
					dhtmlx.alert("이미 등록되어 있는 CCL _BOM번호입니다.");
					err_cnt++;
	    			break;
				}else{							
					gridObj.cellById(gridObj.getRowId(i),1).setValue(cells.item(1).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),2).setValue(cells.item(2).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),3).setValue(cells.item(3).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),4).setValue(cells.item(4).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),5).setValue(cells.item(5).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),6).setValue(cells.item(6).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),7).setValue(cells.item(7).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),8).setValue(cells.item(8).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),9).setValue(cells.item(9).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),10).setValue(cells.item(10).firstChild.nodeValue);
				}
			}	
		}
		if(err_cnt > 0) break;
	}
	
	if(err_cnt === 0) {
		if(chgCnt === 0 ) {
			dhtmlx.alert("변경된 데이터가 없습니다.");
			return;
		}else{
			dhtmlx.confirm({
				ok:"확인", cancel:"취소",
				text:" 입력된 정보를 저장하시겠습니까? ",
				callback:function(val){
				 if(val){
					items[referenceItem].sendGrid(referenceItem,eventName);		   
				   return;
				 }
				}
			});	
		}
	}
}

// 이미지(제품) 등록을 위한 POP-UP
function doImgPopUp(rowIdx){	
	var gridObj = items['C106000100_Grid_1'].getDhxGrid();
	var rowId = gridObj.getRowIndex(rowIdx);
	
	var md_url = "C106000100pop01.jsp?rowId="+rowId;
		md_url += "&CCL_BOM_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_NO'));
		md_url += "&CCL_BOM_IMG_SEQ_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_IMG_SEQ_NO'));
		md_url += "&parent_item=C106000100_Grid_1";
		md_url += "&IMG_RGS_TP=1";  // 1로 고정(PC)
		md_url += "&PRD_SPC_TP=1";  // 1로 고정(제품이미지)
		
	var cusWinObj = new ui.window("C106000100PopWin","CCL BOM 제품 이미지 등록","0","0","465","405",md_url);
	cusWinObj.setButtonDisable("park,minmax1");
	cusWinObj.setModal();
}


//이미지(규격) 등록을 위한 POP-UP
function doImgPopUp1(rowIdx){	
	var gridObj = items['C106000100_Grid_1'].getDhxGrid();
	var rowId = gridObj.getRowIndex(rowIdx);
	
	var md_url = "C106000100pop02.jsp?rowId="+rowId;
		md_url += "&CCL_BOM_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_NO'));
		md_url += "&CCL_BOM_IMG_SEQ_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_IMG_SEQ_NO'));
		md_url += "&parent_item=C106000100_Grid_1";
		md_url += "&IMG_RGS_TP=1";  // 1로 고정(PC)
		md_url += "&PRD_SPC_TP=2";  // 2로 고정(규격이미지)
		
	var cusWinObj = new ui.window("C106000100PopWin","CCL BOM 규격 이미지 등록","0","0","465","405",md_url);
	cusWinObj.setButtonDisable("park,minmax1");
	cusWinObj.setModal();
}

//(물성) 등록을 위한 POP-UP
function doImgPopUp2(rowIdx){	
	var gridObj = items['C106000100_Grid_1'].getDhxGrid();
	var rowId = gridObj.getRowIndex(rowIdx);
	
	var md_url = "C106000100pop03.jsp?rowId="+rowId;
		md_url += "&CCL_BOM_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_NO'));
		md_url += "&CCL_BOM_IMG_SEQ_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_IMG_SEQ_NO'));
		md_url += "&parent_item=C106000100_Grid_1";
		md_url += "&IMG_RGS_TP=1";  // 1로 고정(PC)
		md_url += "&PRD_SPC_TP=3";  // 3로 고정(물성)
		
	var cusWinObj = new ui.window("C106000100PopWin","CCL BOM 물성 파일 등록","0","0","465","405",md_url);
	cusWinObj.setButtonDisable("park,minmax1");
	cusWinObj.setModal();
}

//(규격_파일) 등록을 위한 POP-UP
function doImgPopUp3(rowIdx){	
	var gridObj = items['C106000100_Grid_1'].getDhxGrid();
	var rowId = gridObj.getRowIndex(rowIdx);
	
	var md_url = "C106000100pop04.jsp?rowId="+rowId;
		md_url += "&CCL_BOM_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_NO'));
		md_url += "&CCL_BOM_IMG_SEQ_NO="+items['C106000100_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('CCL_BOM_IMG_SEQ_NO'));
		md_url += "&parent_item=C106000100_Grid_1";
		md_url += "&IMG_RGS_TP=1";  // 1로 고정(PC)
		md_url += "&PRD_SPC_TP=4";  // 4로 고정(규격)
		
	var cusWinObj = new ui.window("C106000100PopWin","CCL BOM 규격 파일 등록","0","0","465","405",md_url);
	cusWinObj.setButtonDisable("park,minmax1");
	cusWinObj.setModal();
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
	//테스트
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C106000100_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);	
}
//menu new row event function
function add(referenceItem){
   items[referenceItem].addRow();
   //행 추가 했을 때 기본적인 정보들이 자동으로 grid에 입력된다.
   setAutoData(items[referenceItem].getDhxGrid().getRowId(0),0);
}

//행추가시 등록자, 등록자명, seq를 가져와서 화면에 보여준다.
//등록자 아이디를 가져오는 로직을 분석한다.
//seq는 ajax를 이용해서 값을 가져오고 그 값에 +1을 해서 화면에 보여준다.
function setAutoData(id,cInd){
	var grdObj = items['C106000100_Grid_1'].getDhxGrid();
	if(cInd==0){
		var row_status = grdObj.getUserData(id,"!nativeeditor_status");
		if(row_status=="inserted"){
			
			grdObj.cellById(id,grdObj.getColIndexById("CCL_BOM_RGS_DH")).setValue(uiCommon.getCurrentDate());
		}
	}
}

//menu remove event function
function remove(referenceItem){
	if(items['C106000100_Grid_1'].getSelectedRowId()==null){
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
	uiCommon.message("C106000100_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(formDivObj){ 
 return true;
}

function parentViewImg(rowIdx,imgnm){
	var winObj2;
	var md_url = "C106000080pop02.jsp?grid=C106000100_Grid_1&imgnm="+encodeURIComponent(imgnm)+"&img_rgs_flags=04";
	//winObj = new ui.window("viewWinPop","CCL BOM 이미지 조회","0","0","950","550",md_url);
	//winObj.setButtonDisable("park,minmax1");
	//winObj.setModal();
	window.open(md_url, '_blank');
}

//저장 후 조회처리
function onAfterUpdateFinishEvent(){
	//var msg = getMessage('C106000100_messagebox');
	//if (msg != "") {
	  //items['C106000100_Form_1'].setItemValue('saveMessage',msg);
	  find('find','C106000100_Form_1','C106000100_Grid_1');	
	//}
}

function setReadonly(){
	var gridObj = items['C106000100_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	for(var i=0; i<grid_cnt; i++) {
		gridObj.setCellExcellType(gridObj.getRowId(i), 0, "ro");
	}
}

function firstFind(){
	items['C106000100_Form_1'].setItemValue("CCL_BOM_NO","<%=CCL_BOM_NO%>");			
	var parentFindUrl = uiCommon.parameters('C106000100_Form_1','C106000100_Grid_1','find');
	items["C106000100_Grid_1"].loadData(parentFindUrl);	
	uiCommon.progressOff(parent);	
	
	items['C106000100_Grid_1'].getDhxGrid().detachEvent(grdXle);
}

//그리드안의 주문번호 클릭 시 링크 연결 
function doOnRowDblClicked(rowId) {
	var CCL_BOM_NO = items['C106000100_Grid_1'].getDhxGrid().cells(rowId,0).getValue();
	parent.newRemoveOpenTab("C106000060","CCL_BOM_NO=" + CCL_BOM_NO);
	}
//]]>
-->
</script>
</head>
<body>
<div id="C106000100_Form_1" style="position:absolute;height:28px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000100_Menu_1" style="position:absolute;height:25px;width:981px;left:0px;top:28px;">
</div>
<div id="C106000100_Grid_1" style="position:absolute;height:511px;width:980px;left:-1px;top:54px;">
</div>
<div id="C106000100_messagebox" style="position:absolute;height:19px;width:980px;left:-1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	items['C106000100_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	items['C106000100_Grid_1'].onXLEEvent(setReadonly);
	var grdXle = items['C106000100_Grid_1'].onXLEEvent(firstFind);	
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
	var dataProcessor = items["C106000100_Grid_1"].getDhxDataProcess();
	items["C106000100_Grid_1"].rowDblClicked(doOnRowDblClicked);
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}	
//]]>
-->
</script>