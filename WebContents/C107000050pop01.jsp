<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%--
 * PROGRAM NAME     :  C107000050pop01.jsp
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
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
데이터이행 
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C107000050pop01_Form_1","xml":".\/header\/kr\/C107000050pop01\/C107000050pop01_Form_1.xml","url":"basicGridData.do","referenceItem":"C107000050pop01_Grid_1","service":"C107000050pop01-service"},' +
      '{"itemType":"messagebox","renderTo":"C107000050pop01_messagebox","xml":".\/header\/kr\/C107000050pop01\/C107000050pop01_messagebox.xml","service":"C107000050pop01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName, customparam);
     items[referenceItem].loadData(findUrl); 
}
function save(eventName,formDivObj,referenceItem){
	var formObj = items['C107000050pop01_Form_1'];
	var sTST_CK = formObj.getDhxForm().isItemChecked('TST_CK');
	var sPRD_CK = formObj.getDhxForm().isItemChecked('PRD_CK');
	
	if(sTST_CK == true  && sPRD_CK == true)  eventName = 'all';   //both
	else if(sTST_CK == true) eventName = 'save1'; //테스트계
	else if(sPRD_CK == true) eventName = 'save2'; //운영계
	else{
		dhtmlx.alert("선택된 정보가 없습니다.");
		return;
	}
	//alert(eventName);
	dhtmlx.confirm({
		ok:"확인", cancel:"취소",
		text:" 입력된 정보를 이행하시겠습니까? ",
		callback:function(val){
		 if(val){
			test = parent.items['C107000050_Grid_1'].sendGrid('C107000050_Grid_1',eventName);
		   return;
		 }
		}
	});	
	
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
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
function findMessage(referenceItem){
  	return true;
}
function onFormLoadEvent(){ 
	var formObj = items['C107000050pop01_Form_1'].getDhxForm();
	var parentGridObj = parent.items['C107000050_Grid_1'].getDhxGrid();
	
	if("<%=request.getParameter("txMsg")%>" != "null" ){
		items['C107000050pop01_Form_1'].setItemValue("MIG_DETAIL","<%=request.getParameter("txMsg")%>");
	}
	else if("<%=request.getParameter("txErrMsg")%>" != "null" ){
		items['C107000050pop01_Form_1'].setItemValue("MIG_DETAIL","<%=request.getParameter("txErrMsg")%>");
	}
	else{
		items['C107000050pop01_Form_1'].setItemValue("MIG_DETAIL","※ 표준항목 데이터 이행 \n\n- 테스트계 체크박스 선택 시 테스트계 데이터 이행\n- 운영계  체크박스 선택 시 운영계 데이터 이행 ");
	}
	items['C107000050pop01_Form_1'].getDhxForm().detachEvent(_onXLEForm);
 	return true;	
}
//]]>
-->
</script>
</head>
<body>
<div id="C107000050pop01_Form_1" style="position:absolute;height:255px;width:481px;left:0px;top:0px;">
</div>
<div id="C107000050pop01_messagebox" style="position:absolute;height:19px;width:480px;left:0px;top:231px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var _onXLEForm = items['C107000050pop01_Form_1'].onXLEEvent(onFormLoadEvent);
//]]>
-->
</script>