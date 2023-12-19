<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME	:  C104000050pop01.jsp
 * VERSION				:  V1.0
 * DESCRIPTION			:  위탁임가공 주문 설계확정
 * DESIGNER NAME	:  이돈석
 * DEVELOPER NAME	:  이돈석
 * CREATE DATE			:  2023.11.09
 *
 * Date				Ver		Name		Description
 * -----------------------------------------------------------------
 * 최초생성일자		V1.0		이돈석		Initial Version
 * 변경일자      version number  개발자이름 변경사항
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ORD_NO = request.getParameter("ORD_NO");
	String ORD_LN = request.getParameter("ORD_LN");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
위탁임가공 주문 설계확정
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000050pop01_Form_1","xml":".\/header\/kr\/C104000050pop01\/C104000050pop01_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000050pop01_Form_1","service":"C104000050pop01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

function onFormLoadEvent(){
    
    items['C104000050pop01_Form_1'].setItemValue("ORD_NO","<%=ORD_NO%>");
    items['C104000050pop01_Form_1'].setItemValue("ORD_LN","<%=ORD_LN%>");
    
    items['C104000050pop01_Form_1'].getDhxForm().detachEvent(onXleForm);
}


// 설계확정
function ok() {

	parent.items['C104000050_Grid_1'].sendGrid('C104000050_Grid_1','save');
	winClose();
}

// 재확인
function cancel() {
	
	var ord_no = items['C104000050pop01_Form_1'].getItemValue("ORD_NO");
    var ord_ln = items['C104000050pop01_Form_1'].getItemValue("ORD_LN");
    
    parent.parent.newRemoveOpenTab("C104000020","ORD_NO=" + ord_no + "&ORD_LN=" +ord_ln);
    //일단 이동하는건 좀 있다 생각하고...
    //alert('11');
    //setTimeout(open_tab,3000);
    //alert('22');
	winClose();
}

function open_tab(){
	//alert('1');
	var tabObj = parent.items['C104000020_Tabbar_1'].getDhxTabbar();
	//alert('2');
	tabObj.setTabActive("C104000020TAB08");
}


//]]>
-->
</script>
</head>
<body>
<div id="C104000050pop01_Form_1" style="position:absolute;height:131px;width:330px;left:0px;top:0px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleForm = items['C104000050pop01_Form_1'].onXLEEvent(onFormLoadEvent);
	
//]]>
-->
</script>