<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
반납확정등록용설계  
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000130pop01_Form_1","xml":".\/header\/kr\/C106000130pop01\/C106000130pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C106000130pop01_Form_1","service":"C106000130pop01-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000130pop01_messagebox","xml":".\/header\/kr\/C106000130pop01\/C106000130pop01_messagebox.xml","service":"C106000130pop01-service"}' +
      
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
}

function save(eventName,formDivObj,referenceItem){
		
	//폼에서 주문번호와 행번 정보를 받아옴
	var uiFormObj = items['C106000130pop01_Form_1'];
	var ord_no = uiFormObj.getItemValue("ORD_NO");
	var ord_ln = uiFormObj.getItemValue("ORD_LN");
	
	//주문번호 null체크
	
	if ((ord_no == null) || (ord_ln == null)){
		alert("주문번호없이 설계 할 수 없습니다."); 
		return ;
	}
	
	//alert("ord_no :" + ord_no + "ord_ln :" + ord_ln);

	//재설계 전 품질설계 batch가 실행되고 있는지 확인
	var param= "ServiceName=C106000130pop01-service&job_sts=1&column-info=JOB_STS";
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell");
	if(cells.length > 0){						
		alert("품질설계JOB이 진행중입니다. 잠시후 진행하세요!");
		return;					
	}
		dhtmlx.confirm({
				title:"[[ 확인 ]]",
				ok:"확인", cancel:"취소",
				text:"재설계 하시겠습니까?",
				callback:function(val){
					if(val){
						var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};
						uiFormObj.sendForm("handleDataProcess.do",'C106000130pop01_Form_1','save',customParam);
					return;
					}
				}
			});
}

function findAfter(){
	uiCommon.progressOff(parent);
	findMessage();
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
function findMessage(){
	uiCommon.message("C106000130pop01_messagebox","조회되었습니다.");
  	return true;
}
function onFormLoadFunction(formDivObj){ 
 return true;
}
function onFormLoad1(){
	items['C106000130pop01_Form_1'].getDhxForm().setItemValue("ORD_NO",<%=request.getParameter("ORD_NO")%>);
	items['C106000130pop01_Form_1'].getDhxForm().setItemValue("ORD_LN",<%=request.getParameter("ORD_LN")%>);
<%-- 	items['C106000130pop01_Form_1'].getDhxForm().setItemValue("ORD_NO","<%=ORD_NO%>");
	items['C106000130pop01_Form_1'].getDhxForm().setItemValue("ORD_LN","<%=ORD_LN%>");
	
	var formObj = items['C106000130pop01_Form_1'].getDhxForm();
	var ORD_NO = formObj.getInput("ORD_NO");
	valueCheck(formObj,ORD_NO);
	var ORD_LN = formObj.getInput("ORD_LN");
	valueCheck(formObj,ORD_LN);
	items['C106000130pop01_Form_1'].getDhxForm().detachEvent(onXle1); --%>
}
//]]>
-->
</script>
</head>
<body>
<div id="C106000130pop01_Form_1" style="position:absolute;height:236px;width:382px;left:0px;top:0px;">
</div>
<div id="C106000130pop01_messagebox" style="position:absolute;height:23px;width:380px;left:0px;top:228px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXle1=items['C106000130pop01_Form_1'].onXLEEvent(onFormLoad1);
//]]>
-->
</script>