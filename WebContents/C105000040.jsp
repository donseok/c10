<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C105000040.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  Brand 보증서 이력 관리
 * DESIGNER NAME    :  
 * DEVELOPER NAME   :  
 * CREATE DATE         :  
 *
 * Date	        Ver       Name       Description
 * ---------   -----    --------  ------------------------
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "com.posdata.glue.context.PosContext" %>
<%@page import = "com.posdata.glue.web.security.*" %>
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%
PosUser user        = (PosUser)session.getAttribute(PosSecurityConstants.USER);
String  userNo      = "";
String  userName    = "";
if(user!=null) {
    userNo = (String) user.getUserInfo("USER_NO");
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  
var pageConfiguration = '[' + 
						'{"itemType":"form","renderTo":"C105000040_Form_1","xml":".\/header\/kr\/C105000040\/C105000040_Form_1.xml","url":"basicGridData.do","referenceItem":"C105000040_Grid_1","service":"C105000040-service","actionType":"save","security":"true"},' +
						'{"itemType":"grid","renderTo":"C105000040_Grid_1","xml":".\/header\/kr\/C105000040\/C105000040_Grid_1.xml","rowCnt":"7","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C105000040_Form_1","service":"C105000040-service","actionType":"save"},' +
						'{"itemType":"messagebox","renderTo":"C105000040_messagebox","xml":".\/header\/kr\/C105000040\/C105000040_messagebox.xml","service":"C105000040-service"}' +
						']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
// 보증서 양식 상세내용
var comboValue = [['', '전체'], ['GIX', 'GIX'], ['G/L', 'G/L'], ['GLX', 'GLX']];

// 조회 기능 
function find(eventName,formDivObj,referenceItem){
	var formObj = items['C105000040_Form_1'].getDhxForm();
	var form = items['C105000040_Form_1'];

	var startDt = formObj.getInput("PUB_DH_FR").value;
	var endDt = formObj.getInput("PUB_DH_TO").value;

	if(isNull(startDt) && !isNull(endDt)){
		dhtmlx.alert("출력기간 시작일을 입력해주세요.");
		form.setItemFocus("PUB_DH_FR");
		return;
	}else if(!isNull(startDt) && isNull(endDt)){
		dhtmlx.alert("출력기간 종료일을 입력해주세요.");
		form.setItemFocus("PUB_DH_TO");
		return;
	}else if(isNull(startDt) && isNull(endDt)){
		dhtmlx.alert("출력기간을 입력해야 합니다.");
		form.setItemFocus("PUB_DH_FR");
		return;
	}else{
		var findUrl = uiCommon.parameters(formDivObj,referenceItem,"find");
		items[referenceItem].loadData(findUrl);
	}
}

//menu refresh event function
function refresh(referenceItem){
	items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C105000040_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);	
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
function findMessage(referenceItem){
	uiCommon.progressOff(parent);
	//폼 값 변할 시 호출 
	hiddenFormItem();

  	return true;
}

//컬러코드 체크 
function chkCclBomWrYn(){
}
//폼1 로드 시 실행되는 함수
function onFormLoadFunction(formDivObj){
	var formId  = "C105000040_Form_1";
	var formObj = items[formId].getDhxForm();

	items['C105000040_Form_1'].setItemValue("PUB_DH_FR",firstDay());
	items['C105000040_Form_1'].setItemValue("PUB_DH_TO",uiCommon.getCurrentDate());

	//콤보리스트 생성 
	comboList(formId);
}

//콤보리스트 생성 
function comboList(formId){
	var comboLst = items[formId].getMasterCombos();//comboList 객체 생성 구문

	// 보증서 양식
	comboLst["PUB_GBN"].addOption(comboValue);
	comboLst["PUB_GBN"].selectOption(0,true,true);
	comboLst["PUB_GBN"].readonly(true);
}

//폼1 2값 가져오는 함수(폼2값을 폼1에 세팅 및 레포트 파라미터 값 세팅 ) 
function mapValues(chkIF){
}

// 폼의 필수 값 입력 체크 
function checkCode(){
}

//폼에 입력된 값에 따라 폼2값 변하게 하는 함수 
 function hiddenFormItem(){
}

function onChange(id,value){
	var item = id;

	if(item == "ORD_NO") {
		var ORD_NO = items['C105000040_Form_1'].getItemValue("ORD_NO");
		var comboList = items['C105000040_Form_1'].getMasterCombos();
		comboList['ORD_LN'].setComboText('');
		comboList['ORD_LN'].clearAll();
		comboList['ORD_LN'].readonly(false,false);
		ui.combo(comboList['ORD_LN'],"OrdlnComboData.do"
				,"ServiceName=C105000040-service&OrdLnFind=1&column-info=ORD_LN,ORD_LN&ORD_NO="+ORD_NO,function(){
				comboList["ORD_LN"].selectOption(0,true,true);
		});
	}

}

//]]>
-->
</script>
</head>
<body>
<div id="C105000040_Form_1" style="position:absolute;height:45px;width:981px;left:0px;top:0px;">
</div>
<div id="C105000040_Grid_1" style="position:absolute;height:520px;width:977px;left:1px;top:45px;">
</div>
<div id="C105000040_messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();	
	items['C105000040_Form_1'].getDhxForm().attachEvent("onChange", onChange);
	items['C105000040_Form_1'].onXLEEvent(onFormLoadFunction);
//]]>
-->
</script>