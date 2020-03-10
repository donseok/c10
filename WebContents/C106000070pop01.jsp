<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000070pop01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  생산가부요청수신IF Pop-Up
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  김 종 범
 * CREATE DATE      :  2012.06.25
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.06.25     V1.0      김종범      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String IF_GRP_ID = request.getParameter("IF_GRP_ID")	!=null ? request.getParameter("IF_GRP_ID") : "";
	String SEQ_NO = request.getParameter("SEQ_NO")	!=null ? request.getParameter("SEQ_NO") : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C106000070pop01
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000070pop01_Form_1","xml":".\/header\/kr\/C106000070pop01\/C106000070pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C106000070pop01_Form_1","service":"C106000070pop01-service"},' +
      '{"itemType":"messagebox","renderTo":"C106000070pop01_messagebox","xml":".\/header\/kr\/C106000070pop01\/C106000070pop01_messagebox.xml","service":"C106000070pop01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C106000070pop01_Form_1',referenceItem,'find');
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

function onFormLoadFunction(){
	var form = items['C106000070pop01_Form_1'];
	var formObj = items['C106000070pop01_Form_1'].getDhxForm();
	var customParam = {"IF_GRP_ID":"<%=IF_GRP_ID%>","SEQ_NO":"<%=SEQ_NO%>"};
	var findUrl = uiCommon.parameters6('C106000070pop01_Form_1','C106000070pop01_Form_1','find',customParam);
		items['C106000070pop01_Form_1'].loadData(findUrl,LoadAfterFunction);
		items['C106000070pop01_Form_1'].getDhxForm().detachEvent(onXleForm);
}

function LoadAfterFunction(){
	uiCommon.progressOff(parent);
	uiCommon.message("C106000070pop01_messagebox",items['C106000070pop01_Form_1'].getItemValue("messageBox"));
}

//]]>
-->
</script>
</head>
<body>
<div id="C106000070pop01_Form_1" style="position:absolute;height:575px;width:910px;left:0px;top:0px;">
</div>
<div id="C106000070pop01_messagebox" style="position:absolute;height:23px;width:910px;left:1px;top:575px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX(); 
		items['C106000070pop01_Form_1'].setBackgroundColor("##FFFFFF");
		var onXleForm= items['C106000070pop01_Form_1'].onXLEEvent(onFormLoadFunction);         
//]]>
-->
</script>