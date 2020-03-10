<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB07pop01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  대상재 등록
 * DESIGNER NAME    :  김 종 화
 * DEVELOPER NAME   :  김 종 화
 * CREATE DATE      :  2018.08.09
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2018.08.09     V1.0      김 종 화      Initial Version
 * 변경일자        
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String ORD_NO = request.getParameter("ORD_NO")	!=null ? request.getParameter("ORD_NO") : "";	
	String ORD_LN = request.getParameter("ORD_LN")	!=null ? request.getParameter("ORD_LN") : "";
	
	PosUser	user = (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String userNo	= "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
	}
	 
	//String[] valList = {userNo};
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>대상재등록</title>
<!--
style type="text/css" media="screen">
html, body { width: 90%; height: 90%;}  
</style
-->
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js"></script>
<script src="./js/c10_common.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000020TAB07pop01_Form_1","xml":".\/header\/kr\/C104000020TAB07pop01\/C104000020TAB07pop01_Form_1.xml","url":"gridC10Data.do","referenceItem":"C104000020TAB07pop01_Form_1","service":"C104000020TAB07pop01-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C104000020TAB07pop01_messagebox","xml":".\/header\/kr\/C104000020TAB07pop01\/C104000020TAB07pop01_messagebox.xml","service":"C104000020TAB07pop01-service"}' +      
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}

function save(eventName,formDivObj,referenceItem){
	items['C104000020TAB07pop01_Form_1'].getDhxForm().resetDataProcessor("inserted");
   	
	dhtmlx.confirm({
		ok:"등록", cancel:"취소",
		text:" 신뢰성시험 대상재로 등록하시겠습니까? ",
		callback:function(val){
		 if(val){
			items['C104000020TAB07pop01_Form_1'].sendForm("handleDataProcess.do",'C104000020TAB07pop01_Form_1',eventName);					   
		   return;
		 }
		}
	});	 	
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C104000020TAB07pop01_Form_1',referenceItem,'find');
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

function onFormLoadFunction(formDivObj){ 
	var form  = items['C104000020TAB07pop01_Form_1'];

	items['C104000020TAB07pop01_Form_1'].setItemValue("ORD_NO","<%=ORD_NO%>");
	items['C104000020TAB07pop01_Form_1'].setItemValue("ORD_LN","<%=ORD_LN%>");
	items['C104000020TAB07pop01_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function afterUpdateFinishEvent(){
	winClose();	
	return true;	 
}
//]]>
-->
</script>
</head>
<body>
	<div id="C104000020TAB07pop01_Form_1" style="position:absolute;height:190px;width:290px;left:0px;top:0px;"></div>
	<div id="C104000020TAB07pop01_messagebox" style="position: absolute; height: 22px; width: 290px; left: 0px; top: 160px;"></div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();   
	var onXleForm = items["C104000020TAB07pop01_Form_1"].onXLEEvent(onFormLoadFunction);
  items['C104000020TAB07pop01_Form_1'].onAfterUpdateFinishEvent(afterUpdateFinishEvent);
//]]>
-->
</script>