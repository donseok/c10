<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C105000030.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  Brand 보증서 출력 관리
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
String  prdNmCd     = "";
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
      '{"itemType":"form","renderTo":"C105000030_Form_1","xml":".\/header\/kr\/C105000030\/C105000030_Form_1.xml","url":"basicFormData.do","referenceItem":"C105000030_Form_2","service":"C105000030-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C105000030_messagebox","xml":".\/header\/kr\/C105000030\/C106000110_messagebox.xml","service":"C105000030-service"},' +
      '{"itemType":"form","renderTo":"C105000030_Form_2","xml":".\/header\/kr\/C105000030\/C105000030_Form_2.xml","url":"basicFormData.do","referenceItem":"C105000030_Form_2","service":"C105000030-service","actionType":"save"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//발급사유 콤보 상세내용
var comboValue = [['사전영업용', '사전영업용'], ['WARRANTY발급용', 'WARRANTY발급용']];
var radio1Value = 'ENG'; 

// 조회 기능 
function find(eventName,formDivObj,referenceItem){
	var form = items['C105000030_Form_1'];

	var pOrdNo = form.getItemValue("ORD_NO");
	var pOrdLn = form.getItemValue("ORD_LN");
	var nKeyCount = 2;
	
	if(isNull(pOrdNo) || isNull(pOrdNo) ){
		dhtmlx.alert("주문번호를 입력해주세요.");
		form.setItemFocus("ORD_NO");
		return false;
	}

	var findUrl = uiCommon.parameters6(formDivObj,referenceItem,eventName);
	items["C105000030_Form_2"].loadData(findUrl,findMessage);
}

function save(eventName,formDivObj,referenceItem){
	var form = items['C105000030_Form_1'];

	var pOrdNo = form.getItemValue("ORD_NO");
	var pOrdLn = form.getItemValue("ORD_LN");
	var pPrdNmCd = prdNmCd;

	if(isNull(pOrdNo) || isNull(pOrdNo) ){
		dhtmlx.alert("주문번호를 입력해주세요.");
		form.setItemFocus("ORD_NO");
		return false;
	}

	var customParam = {"ORD_NO":pOrdNo,"ORD_LN":pOrdLn};
	form.sendForm("handleDataProcess.do",'C105000030_Form_1','save',customParam);
}

// 보증서 발행
function prtRpt() {
	var form = items['C105000030_Form_1'];

	// 현재 서버 주소
	var strService 	= "http://210.1.1.230:8080/oz80/sample/ozexe_simple.html?";
	// 출력할 리포트 이름
	var sReportName;
	var sOdiName;

	var pOrdNo = form.getItemValue("ORD_NO");
	var pOrdLn = form.getItemValue("ORD_LN");
	var pPrdNmCd = prdNmCd;
	var nKeyCount = 2;

	if(pPrdNmCd == "GIX"){
		sReportName = "CRMES/C10/ozr/warrantyGix.ozr";
		sOdiName = "warrantyGix";
	}else if(pPrdNmCd == "G/L"){
		sReportName = "CRMES/C10/ozr/warrantyGl.ozr";
		sOdiName = "warrantyGl";
	}else if(pPrdNmCd == "GLX"){
		sReportName = "CRMES/C10/ozr/warrantyGlx.ozr";
		sOdiName = "warrantyGlx";
	}else{
		return false;
	}

	var md_url = strService+"reportFileName="+sReportName+"&reportOdiName="+sOdiName+"&pKey1=pOrdNo"+"&pValue1="+pOrdNo+"&pKey2=pOrdLn"+"&pValue2="+pOrdLn+"&pKeyCount="+nKeyCount;
	win = window.open(md_url, "GGGG", "width=310,height=300,scrollbars=yes");

}

//menu refresh event function
function refresh(referenceItem){
    var findUrl = uiCommon.parameters6('C105000030_Form_1','C105000030_Form_2','find');
    items['C105000030_Form_2'].loadData(findUrl,findMessage);	
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
	var formId  = "C105000030_Form_1";
	var formObj = items[formId].getDhxForm();

	//콤보리스트 생성 
	comboList(formId);
}

//폼2 로드 시 실행되는 함수
function onFormLoadFunction2(formDivObj){
	var formId  = "C105000030_Form_2";
	var formObj = items[formId].getDhxForm();
}

//콤보리스트 생성 
function comboList(formId){
	var comboLst = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboLst['NAT_CD'].readonly(true,true);//NAT_CD : Form에 comboList 배치할 때 지정해 준 NAME

	//국가코드 콤보리스트 생성 
	ui.combo(comboLst['NAT_CD'],"OrdlnComboData.do"
			,"ServiceName=C105000030-service&selNat=0&column-info=NAT_CD,NAT_KNM",function(){ 
			 comboLst['NAT_CD'].selectOption(0,true,true);
			 comboLst['NAT_CD'].readonly(true);
			 comboLst['NAT_CD'].DOMelem_input.focus();
			});

	//국가 선택 시 클래스 호출 
	comboLst['NAT_CD'].attachEvent("onSelectionChange",function(){
				 ui.combo(comboLst['CLS_CD'],"OrdlnComboData.do"
							,"ServiceName=C105000030-service&selClass=0&NAT_CD="+this.getSelectedValue()+"&column-info=CLS_CD,CLS_KNM",function(){ 
							 comboLst['CLS_CD'].selectOption(0,true,true);
							 comboLst['CLS_CD'].readonly(true);
							 comboLst['CLS_CD'].DOMelem_input.focus();
							});
		         return true;
		       });

	// 발급사유 콤보 
	comboLst["PUB_REA"].addOption(comboValue);
	comboLst["PUB_REA"].selectOption(0,true,true);
	comboLst["PUB_REA"].readonly(true);
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

//최종수요가 검색 
function serchIcon_CUS_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C105000030_Form_1');\">";
}

function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
//popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}

function onChange(id,value){
	var item = id;
	
	if(item == "ORD_NO") {
		var ORD_NO = items['C105000030_Form_1'].getItemValue("ORD_NO");
		var comboList = items['C105000030_Form_1'].getMasterCombos();
		comboList['ORD_LN'].setComboText('');
		comboList['ORD_LN'].clearAll();
		comboList['ORD_LN'].readonly(false,false);
		ui.combo(comboList['ORD_LN'],"OrdlnComboData.do"
				,"ServiceName=C105000030-service&OrdLnFind=1&column-info=ORD_LN,ORD_LN&ORD_NO="+ORD_NO,function(){
				comboList["ORD_LN"].selectOption(0,true,true);
		});

		prdNmCd = "";
		var param = "ServiceName=C105000030-service&PrdNmFind=1&column-info=PRD_NM_CD,PRD_NM_CD&ORD_NO="+ORD_NO;
		var xmlObj = uiCommon.ajaxLoadData("c10AjaxData.do",param);
		if(xmlObj.getElementsByTagName("cell")){
			var cells = xmlObj.getElementsByTagName("cell");
			if(cells[0]) {
				prdNmCd = cells.item(1).firstChild.nodeValue?cells.item(1).firstChild.nodeValue:"";
			} 
		}
	}

}

//폼의 입력값이 변할 경우 
function OnDataChanged(id, value){
}

function OnRadioChanged(id, value){
}
//]]>
-->
</script>
</head>
<body>
<div id="C105000030_Form_1" style="position:absolute;height:100px;width:964px;left:0px;top:0px;">
</div>
<div id="C105000030_messagebox" style="position:absolute;height:19px;width:962px;left:0px;top:909px;">
</div>
<div id="C105000030_Form_2" style="position:absolute;height:813px;width:964px;left:0px;top:100px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();	
	var _onXLEForm  = items['C105000030_Form_1'].onXLEEvent(onFormLoadFunction);
	var _onXLEForm2 = items['C105000030_Form_2'].onXLEEvent(onFormLoadFunction2);
	items['C105000030_Form_1'].onAfterUpdateFinishEvent(prtRpt);
	items['C105000030_Form_1'].onChangeEvent(OnRadioChanged);
	items['C105000030_Form_1'].getDhxForm().attachEvent("onChange", onChange);
	items['C105000030_Form_2'].getDhxForm().attachEvent('onChange', OnDataChanged);
//]]>
-->
</script>