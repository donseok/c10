<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME	:  C106000050pop01.jsp
 * VERSION				:  V1.0
 * DESCRIPTION			:  칼라부재료 업체정보 저장 사유 입력
 * DESIGNER NAME	:  성낙원
 * DEVELOPER NAME	:  성낙원
 * CREATE DATE			:  2016.10.19
 *
 * Date				Ver		Name		Description
 * -----------------------------------------------------------------
 * 최초생성일자		V1.0		성낙원		Initial Version
 * 변경일자      version number  개발자이름 변경사항
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
물성정보 저장 사유
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
      '{"itemType":"form","renderTo":"C106000050pop01_Form_1","xml":".\/header\/kr\/C106000050pop01\/C106000050pop01_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000050pop01_Form_1","service":"C106000050pop01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

// 확인
function ok() {
	var cfmRea		= items[ aForm1[0] ].getItemValue("CFM_REA");		// 확인사유
		
	if( cfmRea==null || cfmRea.length == 0 ||  C10_trim(cfmRea)=="" ){
		dhtmlx.alert("사유를 입력하세요.");
		return false;
	}
	parent.popCfmRea	= cfmRea;	    // 확인사유	
	parent.winObj.winClose();
}

// 취소
function cancel() {
	parent.winObj.winClose();
}

//]]>
-->
</script>
</head>
<body>
<div id="C106000050pop01_Form_1" style="position:absolute;height:131px;width:330px;left:0px;top:0px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	
	var aForm1 = ["C106000050pop01_Form_1"	, ""]; 
	
	items[ aForm1[0] ].onXLEEvent( function(){
		aForm1[1]	= items[ aForm1[0]	].getDhxForm();
	});
//]]>
-->
</script>