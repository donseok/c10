<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME	:  C106000060pop09.jsp
 * VERSION				:  V1.0
 * DESCRIPTION			:  CCL-BOM 물성정보 저장 사유 입력
 * DESIGNER NAME	:  SJS
 * DEVELOPER NAME	:  SJS
 * CREATE DATE			:  2024.08.07
 *
 * Date				Ver		Name		Description
 * -----------------------------------------------------------------
 * 최초생성일자		V1.0		SJS		Initial Version
 * 변경일자      version number  개발자이름 변경사항
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String TOP = request.getParameter("TOP") !=null ? request.getParameter("TOP") : "";
	String BACK = request.getParameter("BACK") !=null ? request.getParameter("BACK") : "";
	String topNum = request.getParameter("topNum") !=null ? request.getParameter("topNum") : "";
	String backNum = request.getParameter("backNum") !=null ? request.getParameter("backNum") : "";
	String difference = request.getParameter("difference") !=null ? request.getParameter("difference") : "";
%>        
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
      '{"itemType":"form","renderTo":"C106000060pop09_Form_1","xml":".\/header\/kr\/C106000060pop09\/C106000060pop09_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000060pop09_Form_1","service":"C106000060pop09-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

function onFormLoadEvent(){
	
    find();
    
    items['C106000060pop09_Form_1'].getDhxForm().detachEvent(onXleForm);
}


function find(){
	var top = "<%= TOP %>";
	var back = "<%= BACK %>";
	var topNum = "<%= topNum %>";
	var backNum = "<%= backNum %>";
	var difference = "<%= difference %>";
	var form = items['C106000060pop09_Form_1'];

	if(top == null && back == null){
		form.setItemValue("TOP","비교대상이 없음");
	}else if(top != null && back == null){
		form.setItemValue("TOP","비교대상이 없음");
	}else if(top == null && back != null){
		form.setItemValue("TOP","비교대상이 없음");
	}else{
		form.setItemValue("TOP","• TOP : "+top+" "+topNum+"%");
		form.setItemValue("BACK","• BACK : "+back+" "+backNum+"%");
		form.setItemValue("DIFF","• 광택차 : "+difference+"%");
		
	}
	
}	

// 확인
// function ok() {
// 	var cfmRea		= items[ aForm1[0] ].getItemValue("CFM_REA");		// 확인사유
		
// 	if( cfmRea==null || cfmRea.length == 0 ||  C10_trim(cfmRea)=="" ){
// 		dhtmlx.alert("사유를 입력하세요.");
// 		return false;
// 	}
// 	parent.popCfmRea	= cfmRea;	    // 확인사유	
// 	parent.winObj.winClose();
// }

// 취소
function cancel() {
	parent.winObj.winClose();
}

//]]>
-->
</script>
</head>
<body>
<div id="C106000060pop09_Form_1" style="position:absolute;height:238px;width:432px;left:0px;top:0px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	
// 	var aForm1 = ["C106000060pop06_Form_1"	, ""];
// 	items[ aForm1[0] ].onXLEEvent( function(){
// 		aForm1[1]	= items[ aForm1[0]	].getDhxForm();
// 	});	
	var onXleForm = items['C106000060pop09_Form_1'].onXLEEvent(onFormLoadEvent);
	

//]]>
-->
</script>