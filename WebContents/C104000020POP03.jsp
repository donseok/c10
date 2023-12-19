<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME	:  C104000020POP03.jsp
 * VERSION				:  V1.0
 * DESCRIPTION			:  위탁임가공 주문 설계확정
 * DESIGNER NAME	:  이돈석
 * DEVELOPER NAME	:  이돈석
 * CREATE DATE			:  2023.11.08
 *
 * Date				Ver		Name		Description
 * -----------------------------------------------------------------
 * 최초생성일자		V1.0		이돈석		Initial Version
 * 변경일자      version number  개발자이름 변경사항
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
      '{"itemType":"form","renderTo":"C104000020POP03_Form_1","xml":".\/header\/kr\/C104000020POP03\/C104000020POP03_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020POP03_Form_1","service":"C104000020POP03-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

function onFormLoadEvent(){
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();
    
    items['C104000020POP03_Form_1'].setItemValue("ORD_NO",ord_no);
    items['C104000020POP03_Form_1'].setItemValue("ORD_LN",ord_ln);
    
    items['C104000020POP03_Form_1'].getDhxForm().detachEvent(onXleForm);
}


// 설계확정
function ok() {
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();
	
	var param = "ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln;
	parentForm.sendForm("handleDataProcess.do",'C104000020_Form_1','save',param);
	
	winClose();
}

// 재확인
function cancel() {
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();
    
    var tabObj = parent.items['C104000020_Tabbar_1'].getDhxTabbar(); 
    tabObj.setTabActive("C104000020TAB08");

	winClose();
}

//]]>
-->
</script>
</head>
<body>
<div id="C104000020POP03_Form_1" style="position:absolute;height:131px;width:330px;left:0px;top:0px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleForm = items['C104000020POP03_Form_1'].onXLEEvent(onFormLoadEvent);
//]]>
-->
</script>