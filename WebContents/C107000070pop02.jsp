<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
String CUS_CMPL_NO = request.getParameter("CUS_CMPL_NO")==null?"":request.getParameter("CUS_CMPL_NO").toString();
String CUS_CMPL_LN = request.getParameter("CUS_CMPL_LN")==null?"":request.getParameter("CUS_CMPL_LN").toString();
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
고객불만이력 상세조회  
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C107000070pop02_Form_1","xml":".\/header\/kr\/C107000070pop02\/C107000070pop02_Form_1.xml","url":"basicFormData.do","referenceItem":"C107000070pop02_Form_1","service":"C107000070pop02-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C107000070pop02_messagebox","xml":".\/header\/kr\/C107000070pop02\/C107000070pop02_messagebox.xml","service":"C107000070pop02-service"}' +
      
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var CMPL_HMTL_CD;

//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
}

function onFormLoad1(){
	var CUS_CMPL_DETAIL = [];
	var CUS_CMPL_NO="<%=CUS_CMPL_NO%>";
	var CUS_CMPL_LN="<%=CUS_CMPL_LN%>";

	var param = "ServiceName=C107000070pop02-service&find=1&CUS_CMPL_NO="+CUS_CMPL_NO+"&CUS_CMPL_LN="+CUS_CMPL_LN+"&column-info=CUS_CMPL_HTML_CD";
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell");
	CMPL_HMTL_CD="";
	for(var i=0; i<cells.length; i++){
		CMPL_HMTL_CD+=cells[i].textContent;
	}
	
	document.getElementById("CUS_CMPL").innerHTML=CMPL_HMTL_CD;
}

//]]>
-->
</script>
</head>
<body id="CUS_CMPL">
<div id="C107000070pop02_Form_1" style="position:absolute;height:236px;width:382px;left:0px;top:0px;">
</div>
<div id="C107000070pop02_messagebox" style="position:absolute;height:23px;width:380px;left:0px;top:228px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXle1=items['C107000070pop02_Form_1'].onXLEEvent(onFormLoad1);
//]]>
-->
</script>