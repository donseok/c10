<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000110.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  보증서 출력관리
 * DESIGNER NAME    :  원성옥                              
 * DEVELOPER NAME   :  원성옥
 * CREATE DATE         :  2014.10.22
 *
 * Date	        Ver       Name       Description
 * ---------   -----    --------  ------------------------
 * 2014.10.22   V1.0     원성옥	  최초작성 
 * 2017.03.15   V2.0     성낙원	  한글보증서 추가 
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
String[] valList = {userNo};
String ctl_tp = ""; 
try{
// MASTER 기준 데이터를 읽어온다. C10A2184 : 보증서관리기준
PosRuleVO result = EasyAccess.getPosRule("C10A2184", valList, null);
    
    if(result.getRecordCount() > 0){
    ctl_tp      = result.getRuleValueAt("TP");        //화면제어여부
    }
}catch(Exception e){
    e.printStackTrace();
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
      '{"itemType":"form","renderTo":"C106000110_Form_1","xml":".\/header\/kr\/C106000110\/C106000110_Form_1.xml","url":"basicFormData.do","referenceItem":"C106000110_Form_2","service":"C106000110-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000110_messagebox","xml":".\/header\/kr\/C106000110\/C106000110_messagebox.xml","service":"C106000110-service"},' +
      '{"itemType":"form","renderTo":"C106000110_Form_2","xml":".\/header\/kr\/C106000110\/C106000110_Form_2.xml","url":"basicFormData.do","referenceItem":"C106000110_Form_2","service":"C106000110-service","actionType":"save"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//발급사유 콤보 상세내용
var comboValue = [['사전영업용', '사전영업용'], ['WARRANTY발급용', 'WARRANTY발급용']];
var radio1Value = 'ENG'; 
// 조회 기능 
function find(eventName,formDivObj,referenceItem){
	if(!checkCode()) return;
	//발행불가 컬러코드 체크 
	if(!chkCclBomWrYn()) return;
	
		var findUrl = uiCommon.parameters6(formDivObj,referenceItem,eventName);
		items[referenceItem].loadData(findUrl,findMessage); 
}
function save(eventName,formDivObj,referenceItem){
	var uiFormObj     = items['C106000110_Form_1'];
	if(!checkCode()) return;
	if(mapValues("save")=="false") return;
	
	var customParam = "";
	uiFormObj.sendForm("handleDataProcess.do",'C106000110_Form_1','save',customParam);
}
//menu refresh event function
function refresh(referenceItem){
    var findUrl = uiCommon.parameters6('C106000110_Form_1','C106000110_Form_2','find');
    items['C106000110_Form_2'].loadData(findUrl,findMessage);	
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
	var formId1   = "C106000110_Form_1";
	var formId2   = "C106000110_Form_2";
	var uiFormObj = items[formId1];
	var uiFormOb2 = items[formId2];
	var sCclBomNo = uiFormObj.getItemValue("CCL_BOM_NO"); //컬러코드
	var rtnVal = true;
	
	var param1= "ServiceName=C106000110-service&cclBomChk=1&CCL_BOM_NO=" + sCclBomNo + "&column-info=CCL_BOM_WR_YN";
	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
	var cells1 = xmlObj1.getElementsByTagName("cell");
	var cclBomWrYn = cells1.item(0).firstChild.nodeValue;
	
	items[formId1].getDhxForm().disableItem('prtRpt');
	
	if(cclBomWrYn=="X"){
		alert("존재하지 않는 CCLBOM입니다.");
		uiFormOb2.clear();
		rtnVal = false;
		
	}else if(cclBomWrYn=="N"){
		alert("보증서 발행불가 CCLBOM입니다.");
		uiFormOb2.clear();
		rtnVal = false;
	}
	else{
		items[formId1].getDhxForm().enableItem('prtRpt');
	}
	return rtnVal;
}
//폼1 로드 시 실행되는 함수
function onFormLoadFunction(formDivObj){
	var formId  = "C106000110_Form_1";
	var formId2 = "C106000110_Form_2";
	var formObj = items[formId].getDhxForm();
	
	//콤보리스트 생성 
	comboList(formId);
	
	//컬러코드 입력 시 대문자로 변환 	
	var inputObj = formObj.getInput("CCL_BOM_NO");
	inputObj.onkeyup = function(e){
		if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
		  inputObj.value = inputObj.value.toUpperCase();
		}	
		e = e||window.event;
		if(e.keyCode == 13){
			formObj.setItemValue("CCL_BOM_NO",inputObj.value);
			find("find",formId,formId2);			
		}
	}

	items[formId].getDhxForm().detachEvent(_onXLEForm);	
}

//폼2 로드 시 실행되는 함수
function onFormLoadFunction2(formDivObj){
	var formId = "C106000110_Form_2";
	var formObj = items[formId].getDhxForm();
	
	// 기본값 설정 
	formObj.hideItem("labelChgToC");
	formObj.hideItem("primiumClassA");
	formObj.hideItem("primiumClassB");
	formObj.hideItem("universalClassB");
	formObj.hideItem("NAT_ENM_1");
	
	//보증서 수정 권한이 존재하지 않을 경우 폼2의 값을 전부 disable 시킨다.  
	if('<%=ctl_tp%>' == "Y"){ 
		formObj.forEachItem(function(id){
			if(formObj.getItemType(id) != "block"){
			   formObj.	enableItem(id);
				}              
			});  
		 }
	else{
		formObj.forEachItem(function(id){
			if(formObj.getItemType(id) != "block"){
			   formObj.disableItem(id);
				}              
			});  
		 }

	items[formId].getDhxForm().detachEvent(_onXLEForm2);	
}

//콤보리스트 생성 
function comboList(formId){
	var comboLst = items[formId].getMasterCombos();//comboList 객체 생성 구문
	comboLst['NAT_CD'].readonly(true,true);//NAT_CD : Form에 comboList 배치할 때 지정해 준 NAME
	
	//국가코드 콤보리스트 생성 
	ui.combo(comboLst['NAT_CD'],"OrdlnComboData.do"
			,"ServiceName=C106000110-service&selNat=0&column-info=NAT_CD,NAT_KNM",function(){ 
			 comboLst['NAT_CD'].selectOption(0,true,true);
			 comboLst['NAT_CD'].readonly(true);
			 comboLst['NAT_CD'].DOMelem_input.focus();
			});
	
	//국가 선택 시 클래스 호출 
	comboLst['NAT_CD'].attachEvent("onSelectionChange",function(){
				 ui.combo(comboLst['CLS_CD'],"OrdlnComboData.do"
							,"ServiceName=C106000110-service&selClass=0&NAT_CD="+this.getSelectedValue()+"&column-info=CLS_CD,CLS_KNM",function(){ 
							 comboLst['CLS_CD'].selectOption(0,true,true);
							 comboLst['CLS_CD'].readonly(true);
							 comboLst['CLS_CD'].DOMelem_input.focus();
							});
		         return true;
		       });
	
	// 발급사유 콤보 
	 comboLst["PRT_RSN"].addOption(comboValue);
	 comboLst["PRT_RSN"].selectOption(0,true,true);
	 comboLst["PRT_RSN"].readonly(true);
}

//폼1 2값 가져오는 함수(폼2값을 폼1에 세팅 및 레포트 파라미터 값 세팅 ) 
function mapValues(chkIF){
	var uiFormObj     = items['C106000110_Form_1'];
	var uiFormObjSub  = items['C106000110_Form_2'];
	
	var returnVal     ="false";
	//폼 입력값 
	var sCclBomNo     = uiFormObj.getItemValue("CCL_BOM_NO"); //컬러코드
	var sNatCd        = uiFormObj.getItemValue("NAT_CD");     //국가코드
	var sClsCd   	  = uiFormObjSub.getItemValue("CLS_CD");  //클래스구분코드
	
	var sDivCd		  = uiFormObjSub.getItemValue("DIV_CD");  //구분코드	
	var sBrdCmp2Check = uiFormObjSub.getItemValue("BRD_CMP_2_CHECK"); 
	
	var sCusCd        = uiFormObj.getItemValue("CUS_CD");     //최종수요가
	var sPrtRsn       = uiFormObj.getItemValue("PRT_RSN");    //발행사유 
	
	// 폼 가변적인 값 
 	var sPER_FOR_19    = uiFormObjSub.getItemValue("PER_FOR_19"); 
 	var sBRD_CMP_2    = uiFormObjSub.getItemValue("BRD_CMP_2"); 
 	var sF_CCL_BOM_NO = uiFormObjSub.getItemValue("F_CCL_BOM_NO");
 	var sBRD_CMP_2_1  = uiFormObjSub.getItemValue("BRD_CMP_2_1"); 
 	var sNAT_ENM      = uiFormObjSub.getItemValue("NAT_ENM");
 	var sNAT_ENM_1    = uiFormObjSub.getItemValue("NAT_ENM_1");
 	var sBRD_CMP_2_2  = uiFormObjSub.getItemValue("BRD_CMP_2_2"); 
 	var sPER_FOR_6    = uiFormObjSub.getItemValue("PER_FOR_6");
 	//var sPER_FOR_1_1  = uiFormObjSub.getItemValue("PER_FOR_1_1");
 	var sBRD_CMP_2_3  = uiFormObjSub.getItemValue("BRD_CMP_2_3");
 	var sFA_TRM_7     = uiFormObjSub.getItemValue("FA_TRM_7"); 
 	var sFA_TRM_8     = uiFormObjSub.getItemValue("FA_TRM_8"); 
 	var sBRD_CMP_2_4  = uiFormObjSub.getItemValue("BRD_CMP_2_4"); 
 	var sFA_WAL_12    = uiFormObjSub.getItemValue("FA_WAL_12"); 
 	var sFA_WAL_11    = uiFormObjSub.getItemValue("FA_WAL_11"); 
 	var sFA_ROF_10    = uiFormObjSub.getItemValue("FA_ROF_10"); 
 	var sFA_ROF_9     = uiFormObjSub.getItemValue("FA_ROF_9"); 
 	var sCH_TRM_14    = uiFormObjSub.getItemValue("CH_TRM_14"); 
 	var sCH_TRM_13    = uiFormObjSub.getItemValue("CH_TRM_13"); 
 	var sCH_WAL_18    = uiFormObjSub.getItemValue("CH_WAL_18"); 
 	var sCH_WAL_17    = uiFormObjSub.getItemValue("CH_WAL_17"); 
 	var sCH_ROF_15    = uiFormObjSub.getItemValue("CH_ROF_15"); 
 	var sCH_ROF_16    = uiFormObjSub.getItemValue("CH_ROF_16"); 
 	var sBRD_CMP_2_5  = uiFormObjSub.getItemValue("BRD_CMP_2_5");
 	var sBRD_CMP_2_6  = uiFormObjSub.getItemValue("BRD_CMP_2_6");
 	var sBrdCmp2Check = uiFormObjSub.getItemValue("BRD_CMP_2_CHECK");

 	var sPER_FOR_19_1 = uiFormObjSub.getItemValue("PER_FOR_19_1");
    var sPE_FL_20     = uiFormObjSub.getItemValue("PE_FL_20");
    var sPE_FL_1      = uiFormObjSub.getItemValue("PE_FL_1"); 
 	var sBRD_CMP_2_7  = uiFormObjSub.getItemValue("BRD_CMP_2_7"); //새로추가된부분 A.항목 
 	var sCusNm        = uiFormObjSub.getItemValue("CUS_NM");      //최종수요가
 	var sGT_MT        = uiFormObjSub.getItemValue("GT_MT");       //거리미터
 	var sGT_FT        = uiFormObjSub.getItemValue("GT_FT");       //거리피트
 	
 	var arryList = new Array(8);
 	arryList[0] = sBRD_CMP_2;
 	arryList[1] = sBRD_CMP_2_1;
 	arryList[2] = sBRD_CMP_2_2;
 	arryList[3] = sBRD_CMP_2_3;
 	arryList[4] = sBRD_CMP_2_4;
 	arryList[5] = sBRD_CMP_2_5;
 	arryList[6] = sBRD_CMP_2_6;
 	arryList[7] = sBRD_CMP_2_7;
 	
 	
 	if(sPER_FOR_19 != sPER_FOR_19_1){
 			alert("입력값19) 값이 다릅니다. ");
 			return returnVal;
 		}
 	
 	else if(sNAT_ENM != sNAT_ENM_1){
 			alert("입력값4) 값이 다릅니다. ");
 			return returnVal;
 		}
 	else{
 	 	for(i=0; i<7; i++){
 	 		for(j=0; j<8; j++){
 	 			// 프리미엄일때는 B 구문이 빠진다 
 	 		if( (sDivCd == "PREMIUM" && i==4) || (sDivCd == "PREMIUM" && j==4) )
 	 			continue;
 		 		if(arryList[i] != arryList[j]){
 		 			alert("입력값2) 값이 다릅니다. ");
 		 			return returnVal;
 	 			}
 	 		}
 	 	}
 	}

 		//보증서 출력 시 레포트로 넘어가는 파라미터 값 
 		if(chkIF=="prtRpt"){
	 	returnVal = 
	 	   sCclBomNo     + "$" + sNatCd        + "$" + sPER_FOR_19  + "$" + sBRD_CMP_2   + "$" +
		   sF_CCL_BOM_NO + "$" + sBRD_CMP_2_1  + "$" + sNAT_ENM     + "$" + sBRD_CMP_2_2 + "$" +
		   sPER_FOR_6    + "$" + sPER_FOR_19_1 + "$" + sBRD_CMP_2_3 + "$" + sFA_TRM_7    + "$" +
		   sFA_TRM_8     + "$" + sBRD_CMP_2_4  + "$" + sFA_WAL_12   + "$" + sFA_WAL_11   + "$" +
		   sFA_ROF_10    + "$" + sFA_ROF_9     + "$" + sCH_TRM_14   + "$" + sCH_TRM_13   + "$" +
		   sCH_WAL_18    + "$" + sCH_WAL_17    + "$" + sCH_ROF_15   + "$" + sCH_ROF_16   + "$" +
		   sBRD_CMP_2_5  + "$" + sClsCd        + "$" + sDivCd       + "$" + sBrdCmp2Check+ "$" + 
		   sNAT_ENM_1    + "$" + sBRD_CMP_2_6  + "$" + sPrtRsn      + "$" + sBRD_CMP_2_7 + "$" +
		   sPE_FL_20     + "$" + sPE_FL_1      + "$" + sCusNm       + "$" + sGT_MT       + "$" +
		   sGT_FT;
 		}
 		
 		//폼2의 값을 폼1에도 세팅 
	 	else if(chkIF=="save"){
	 		uiFormObj.setItemValue("PER_FOR_19",sPER_FOR_19);
	 		uiFormObj.setItemValue("BRD_CMP_2" ,sBRD_CMP_2);
	 		uiFormObj.setItemValue("PER_FOR_6" ,sPER_FOR_6);
	 		uiFormObj.setItemValue("FA_TRM_7"  ,sFA_TRM_7);
	 		uiFormObj.setItemValue("FA_TRM_8"  ,sFA_TRM_8);
	 		uiFormObj.setItemValue("FA_WAL_12" ,sFA_WAL_12);
	 		uiFormObj.setItemValue("FA_WAL_11" ,sFA_WAL_11);
	 		uiFormObj.setItemValue("FA_ROF_10" ,sFA_ROF_10);
	 		uiFormObj.setItemValue("FA_ROF_9"  ,sFA_ROF_9);
	 		uiFormObj.setItemValue("CH_TRM_14" ,sCH_TRM_14);
	 		uiFormObj.setItemValue("CH_TRM_13" ,sCH_TRM_13);
	 		uiFormObj.setItemValue("CH_WAL_18" ,sCH_WAL_18);
	 		uiFormObj.setItemValue("CH_WAL_17" ,sCH_WAL_17);
	 		uiFormObj.setItemValue("CH_ROF_15" ,sCH_ROF_15);
	 		uiFormObj.setItemValue("CH_ROF_16" ,sCH_ROF_16);
	 		uiFormObj.setItemValue("PE_FL_20"  ,sPE_FL_20);
	 		uiFormObj.setItemValue("PE_FL_1"   ,sPE_FL_1);
	 		uiFormObj.setItemValue("CUS_NM"    ,sCusNm);
	 		uiFormObj.setItemValue("GT_MT"     ,sGT_MT);
	 		uiFormObj.setItemValue("GT_FT"     ,sGT_FT);
	 		returnVal = "true";
 		}
 	return returnVal;
}

//보증서 출력  Popup 호출
function prtRpt(){
	if(!checkCode()) return;
	
	//값 입력 잘못 할 경우 에러 
	var keyValue = mapValues("prtRpt");
	if(keyValue=="false") return;
	
	var uiFormObjSub  = items['C106000110_Form_2'];
	var sDivCd		  = uiFormObjSub.getItemValue("DIV_CD");  //구분코드
	var vLang          = items['C106000110_Form_1'].getDhxForm().getItemValue("radio1");
	
	if(vLang == 'KOR'){
		if(sDivCd != "PREMIUM")
			reportFileName	= 'C106000110_KOR.jasper';
		else
			reportFileName	= 'C106000110_PREMIUM_KOR.jasper';
	}else{
		if(sDivCd != "PREMIUM")
			reportFileName	= 'C106000110.jasper';
		else
			reportFileName	= 'C106000110_PREMIUM.jasper';
	}
	
	var keyName  = "CCL_BOM_NO,NAT_CD,PER_FOR_19,BRD_CMP_2,F_CCL_BOM_NO,BRD_CMP_2_1,"+
	               "NAT_ENM,BRD_CMP_2_2,PER_FOR_6,PER_FOR_19_1,BRD_CMP_2_3,FA_TRM_7,"+
	               "FA_TRM_8,BRD_CMP_2_4,FA_WAL_12,FA_WAL_11,FA_ROF_10,FA_ROF_9,CH_TRM_14,"+
	               "CH_TRM_13,CH_WAL_18,CH_WAL_17,CH_ROF_16,CH_ROF_15,BRD_CMP_2_5,CLS_CD,DIV_CD,"+
	               "BRD_CMP_2_CHECK,NAT_ENM_1,BRD_CMP_2_6,PRT_RSN,BRD_CMP_2_7,PE_FL_20,PE_FL_1,CUS_NM,GT_MT,GT_FT";
	
	winObj = new ui.window("popup","보증서출력","0","0","550","600",false,"iReport_list.jsp?reportFileName="+reportFileName +
			                                                         "&keyValue=" + keyValue + 
			                                                         "&keyName="  + keyName);	
	winObj.setModal();
}
// 폼의 필수 값 입력 체크 
function checkCode(){
	var form = items['C106000110_Form_1'];
	var comboNatcd  = form.getDhxForm().getCombo("NAT_CD");
	var comboClscd  = form.getDhxForm().getCombo("CLS_CD");
	var comboPrtRsn = form.getDhxForm().getCombo("PRT_RSN");
	var sCclBomNo   = form.getItemValue("CCL_BOM_NO");
	var sCusCd      = form.getItemValue("CUS_CD");
	
	if(isNull(sCclBomNo)){
		alert("컬러코드를 입력해주세요.");
		form.setItemFocus("CCL_BOM_NO");
		return false;	
	}else if(isNull(comboNatcd.getSelectedValue())){
		alert("국가를 선택해주세요.");
		comboNatcd.DOMelem_input.focus();
		return false;
	}else if(isNull(comboClscd.getSelectedValue())){
		alert("CLASS를 선택해주세요.");
		comboClscd.DOMelem_input.focus();
		return false;	
	}else if(isNull(comboPrtRsn)){
		alert("발행사유를 선택해주세요.");
		comboPrtRsn.DOMelem_input.focus();
		return false;	
	}else if(isNull(sCusCd)){
		alert("최종수요가를 입력해주세요.");
		form.setItemFocus("CUS_CD");
		return false;	
	}
	return true;
}
//폼에 입력된 값에 따라 폼2값 변하게 하는 함수 
 function hiddenFormItem(){
	var formId  = items['C106000110_Form_2'];
	var formObj = items['C106000110_Form_2'].getDhxForm();
	//폼 입력값 
	var sDivCd        = formId.getItemValue("DIV_CD");  // 구분코드
	var sClsCd        = formId.getItemValue("CLS_CD");  // 클래스구분코드
	var sBrdCmp2Check = formId.getItemValue("BRD_CMP_2_CHECK"); 
	
	if(sDivCd == "PREMIUM"){
		if(sClsCd == "CLASSB"){
			if( radio1Value == "ENG" ){
				formObj.showItem("NAT_ENM_1");
			}
			formObj.showItem("primiumClassB");
			formObj.showItem("S1_3");
			formObj.hideItem("primiumClassA");
			formObj.hideItem("universalClassA");
			formObj.hideItem("universalClassB");
					
		}else{
			formObj.showItem("primiumClassA");
			formObj.hideItem("primiumClassB");
			formObj.hideItem("universalClassA");
			formObj.hideItem("universalClassB");
			formObj.hideItem("NAT_ENM_1");
			formObj.hideItem("S1_3");
						
		}
		formObj.hideItem("blockC");
		formObj.hideItem("labelD");
		formObj.showItem("labelChgToC");

	}else{
		if(sClsCd == "CLASSB"){
			if( radio1Value == "ENG" ){
				formObj.showItem("NAT_ENM_1");
			}
			formObj.showItem("universalClassB");
			formObj.showItem("S1_3");
            formObj.hideItem("universalClassA");
			formObj.hideItem("primiumClassA");
			formObj.hideItem("primiumClassB");			
		}else{
	        formObj.showItem("universalClassA");
	        formObj.hideItem("universalClassB");
	        formObj.hideItem("primiumClassA");
            formObj.hideItem("primiumClassB");
            formObj.hideItem("NAT_ENM_1");
			formObj.hideItem("S1_3");
		}
		formObj.showItem("blockC");
		formObj.showItem("labelD");
		formObj.hideItem("labelChgToC");	

	}
	
	if( radio1Value == "KOR" ){
		OnRadioChanged('radio1','KOR');
	}
		
}
 //최종수요가 검색 
 function serchIcon_CUS_CD(name,val){
		return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C106000110_Form_1');\">";
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
 
 //폼의 입력값이 변할 경우 
 function OnDataChanged(id, value){
	 
		var uiFormObjSub  = items['C106000110_Form_2'];
	
		//폼의 입력값 2)
	 	var arryList_BRD_CMP = new Array(8);
	 	arryList_BRD_CMP[0] = "BRD_CMP_2";
	 	arryList_BRD_CMP[1] = "BRD_CMP_2_1";
	 	arryList_BRD_CMP[2] = "BRD_CMP_2_2";
	 	arryList_BRD_CMP[3] = "BRD_CMP_2_3";
	 	arryList_BRD_CMP[4] = "BRD_CMP_2_4";
	 	arryList_BRD_CMP[5] = "BRD_CMP_2_5";
	 	arryList_BRD_CMP[6] = "BRD_CMP_2_6";
	 	arryList_BRD_CMP[7] = "BRD_CMP_2_7";
	 	
	 	var arryList_PER_FOR_19 = new Array(2);
	 	arryList_PER_FOR_19[0] = "PER_FOR_19";
	 	arryList_PER_FOR_19[1] = "PER_FOR_19_1";
	 	
	 	var arryList_NAT_ENM = new Array(2);
	 	arryList_NAT_ENM[0] = "NAT_ENM";
	 	arryList_NAT_ENM[1] = "NAT_ENM_1";
	 	
	// 입력값 19)의 값이 변할경우 해당되는 19)의 입력값을 전부 변화시킨다.  	
	if(id == arryList_PER_FOR_19[0] ||  id == arryList_PER_FOR_19[1]){
		for(i=0; i<arryList_PER_FOR_19.length; i++){
	 		if(id == arryList_PER_FOR_19[i]){
	 			for(j=0; j<arryList_PER_FOR_19.length; j++){
	 				if(j!=i){
	 				uiFormObjSub.setItemValue(arryList_PER_FOR_19[j], value);
	 				}
	 			}
	 		}
	 	}	
 	}
 	// 입력값 4)의 값이 변할경우 해당되는 4)의 입력값을 전부 변화시킨다. 
 	else if(id == arryList_NAT_ENM[0] ||  id == arryList_NAT_ENM[1]){
		for(i=0; i<arryList_NAT_ENM.length; i++){
	 		if(id == arryList_NAT_ENM[i]){
	 			for(j=0; j<arryList_NAT_ENM.length; j++){
	 				if(j!=i){
	 				uiFormObjSub.setItemValue(arryList_NAT_ENM[j], value);
	 				}
	 			}
	 		}
	 	}	
 	}
 	else{	
	 	// 입력값 2)의 값이 변할경우 해당되는 2)의 입력값을 전부 변화시킨다. 
	 	for(i=0; i<arryList_BRD_CMP.length; i++){
	 		if(id == arryList_BRD_CMP[i]){
	 			for(j=0; j<arryList_BRD_CMP.length; j++){
	 				if(j!=i){
	 				uiFormObjSub.setItemValue(arryList_BRD_CMP[j], value);
	 				}
	 			}
	 		}
		}
 	}
 }

 function OnRadioChanged(id, value){ //한글, 영문 변경 
		if(id =="radio1"){
			var FormD2 = items['C106000110_Form_2'].getDhxForm();
			
			if(value == "KOR"){ 
				radio1Value = "KOR";
				FormD2.hideItem("BRD_CMP_2_1");
				FormD2.hideItem("NAT_ENM");
				FormD2.hideItem("BRD_CMP_2_2");
				FormD2.hideItem("NAT_ENM_1");
				FormD2.hideItem("PER_FOR_6");
				FormD2.hideItem("PER_FOR_19_1");
				FormD2.hideItem("BRD_CMP_2_7");
				FormD2.hideItem("PE_FL_20");
				FormD2.hideItem("PE_FL_1");
				FormD2.hideItem("BRD_CMP_2_3");
				FormD2.hideItem("FA_TRM_7");
				FormD2.hideItem("FA_TRM_8");
				FormD2.hideItem("BRD_CMP_2_4");
				FormD2.hideItem("FA_WAL_12");
				FormD2.hideItem("FA_WAL_11");
				FormD2.hideItem("FA_ROF_10");
				FormD2.hideItem("FA_ROF_9");
				FormD2.hideItem("CH_TRM_14");
				FormD2.hideItem("CH_TRM_13");
				FormD2.hideItem("BRD_CMP_2_6");
				FormD2.hideItem("CH_WAL_18");
				FormD2.hideItem("CH_WAL_17");
				FormD2.hideItem("CH_ROF_16");
				FormD2.hideItem("CH_ROF_15");
				FormD2.hideItem("BRD_CMP_2_5");
								
				FormD2.setItemLabel('SS_1', "본 보증서는 동국제강(주) ");
				FormD2.setItemLabel('SS_2',  items['C106000110_Form_2'].getItemValue("BRD_CMP_2_1") + "제품에 대하여 출고일로부터 ");
				FormD2.setItemLabel('SS_3', "");
				FormD2.setItemLabel('SS_4',  items['C106000110_Form_2'].getItemValue("PER_FOR_19") + "년 동안 유효합니다. "); 
				FormD2.setItemLabel('SS_5', "또한 아래 보증 항목이 적용됩니다. ");
				
				FormD2.setItemLabel('S1_1', "1. 동국제강(주)는 하기 명기된 항목에 따라 대한민국내 건축물에 적용된  ");
				FormD2.setItemLabel('S1_2',  items['C106000110_Form_2'].getItemValue("BRD_CMP_2_2") + "에 대하여 다음의 기준으로 제품을 보증합니다. ");
				FormD2.setItemLabel('primiumClassA', "");
				FormD2.setItemLabel('primiumClassB', "");
				FormD2.setItemLabel('universalClassB', "");
				FormD2.setItemLabel('universalClassA', "");
				FormD2.setItemLabel('S1_3', "");
				
				FormD2.setItemLabel('S1A_1', "가. ");
				FormD2.setItemLabel('S1A_2',  items['C106000110_Form_2'].getItemValue("BRD_CMP_2_7") + "는 외부로부터의 손상이 없는 상태에서 ");
				FormD2.setItemLabel('S1A_3',  items['C106000110_Form_2'].getItemValue("PER_FOR_19_1") + "년 동안 천공이 발생되지 않습니다.");

				FormD2.setItemLabel('S1B_1', "나. ");
				FormD2.setItemLabel('S1B_2',  items['C106000110_Form_2'].getItemValue("BRD_CMP_2_3") + "는 외부로부터의 손상이 없는 상태에서 ");
				FormD2.setItemLabel('S1B_3',  items['C106000110_Form_2'].getItemValue("PE_FL_1") + "년 동안 도막이 벗겨지지 않습니다. ");
				FormD2.setItemLabel('S1B_4', "       단, Roll-Forming 및 절단, 절곡 작업시 발생하는 미세한 균열 및 이로인해 유발된 현상은 포함되지 않습니다. ");
				
			    FormD2.setItemLabel('S1C_1', "다. ");
				FormD2.setItemLabel('S1C_2',  items['C106000110_Form_2'].getItemValue("BRD_CMP_2_6") + "는 ");
			    FormD2.setItemLabel('S1C_3',  items['C106000110_Form_2'].getItemValue("FA_TRM_8") + "년 동안 벽체일경우 △E는 ");
				FormD2.setItemLabel('S1C_4',  items['C106000110_Form_2'].getItemValue("FA_WAL_11") + "이상 변하지 않고 ");
			    FormD2.setItemLabel('S1C_5', "지붕일경우 △E가 ");
				FormD2.setItemLabel('S1C_6',  items['C106000110_Form_2'].getItemValue("FA_ROF_9") + "이상 변하지 않습니다. ");
			    FormD2.setItemLabel('S1C_7', "	   단, 색상 변화는 외부오염(먼지 및 Chalk 발생부 등) 제거한 제품에 깨끗한 표면, 노출되지 않은 원래의 표면과 비교하여 ASTM D2244-93 방법으로 측정합니다.(태양과 외부환경에 동등하게 노출되지 않은 표면은 균일하지 않을 수 있음을 이해합니다.) ");

			    FormD2.setItemLabel('labelD', "라.");
				FormD2.setItemLabel('labelChgToC', "다.");
				FormD2.setItemLabel('S1D_2',  items['C106000110_Form_2'].getItemValue("BRD_CMP_2_4") + "는 ,");
				FormD2.setItemLabel('S1D_3',  items['C106000110_Form_2'].getItemValue("CH_TRM_13") + "년 동안, 분필가루처럼 일어나는 Chalk현상에 대해 ASTM D4214, Method C로 측정 시, 벽체일경우 ");
				FormD2.setItemLabel('S1D_4',  items['C106000110_Form_2'].getItemValue("CH_WAL_17") + "Rate, 지붕일경우 ");
				FormD2.setItemLabel('S1D_5',  items['C106000110_Form_2'].getItemValue("CH_ROF_15") + "Rate 보다 양호할 것을 보증합니다. 단, 측정방법은 ASTM D3964에 준하여 Chalk 발생부의 외부오염이나 먼지를 가볍게 제거 후 측정합니다.");

			    FormD2.setItemLabel('S2_1', "2. 해안으로부터 1km 이내 또는 염분이 포함된 대기 환경에 대해서는 ");
				FormD2.setItemLabel('S2_2',  items['C106000110_Form_2'].getItemValue("BRD_CMP_2_5") + "의 보증범위에 포함되지 않습니다. 따라서 해안가 시공의 경우 제조사측과 별도의 협의과정을 거쳐야 합니다. ");

				FormD2.setItemLabel('S3', "3. 본 보증서는 동국제강(주)에서 제어할 수 없는 환경 즉, 화산폭발 등의 천재지변, 전쟁, 폭동, 낙하물, 외부압력, 유독가스, 화학물, 염분과다 대기, 동물의 배설물, 외부오염(모래, 흙, 철가루, 티끌), 부적절한 취급과 저장 및 기타 가공에 의해 발생한 결함 및 문제에 대해서는 보증범위에 포함되지 않습니다. 그리고 외부로 노출되는 절단 또는 타공면에서 발생되는 녹, 페인트 불량은 보증에서 제외됩니다.");

				FormD2.setItemLabel('S4', "4. 부적절한 운송이나 보관, 가공으로 인해 발생하는 문제는 보증에서 제외됩니다. ");

			    FormD2.setItemLabel('S5', "5. 본 보증서는 동국제강(주)에서 승인된 색상 및 용도 범위에서만 적용됩니다. 고객의 요구로 추가 개발 및 조정된 색상은 상기 표준에 맞지 않을 수 있으며, 별도의 협의를 거칩니다. ");
			    FormD2.setItemLabel('S5_1', "");
			    FormD2.setItemLabel('S5_2', "");

			    FormD2.setItemLabel('S6', "6. 동국제강(주)의 책임은 하자가 있는 제품의 교환 또는 환불 등 직접적인 비용에 한정되며, 제품의 결함에 의해 추가 발생한 간접적인, 특별한, 필연적인 손해와 노동력 손실에 대한 비용은 보상하지 않습니다. ");
			    FormD2.setItemLabel('S6_1', "가. 동국제강(주)의 클레임 보상 책임은 METAL PANEL 또는 STEEL SHEET 가격내에서 보상한다. ");			    
			    FormD2.setItemLabel('S6_2', "나. 동국제강(주)는 장비사용료, 노동임금 또는 별도의 간접적인 손실 금액 등에 대해서는 보상하지 않는다. ");

			    FormD2.setItemLabel('S7', "7. 동국제강(주)는 하자가 있는 제품에 대해서 재도장 및 재시공 방법을 결정할 권한과 다른 재료 교체, 설치, 또는 재처를 결정하는 자리에 참여와 승인 자격을 가지게 됩니다. 교체나 재처리 후, 보증의 연장 부분은 최소 보증의 잔여기간 동안만 유효합니다. ");

			    FormD2.setItemLabel('S8', "8. 본 보증서에 명시된 제품의 성능 관련된 모든 클레임은 고객이 제푸에 대한 결함을 알게 되었거나 알고 있는 시점으로부터 30일 이내에 동국제강(주)에 문서로 제출하여야 하며, 그렇지 않을 경우 클레임 청구 권리가 철회됩니다. 동국제강(주)은 필요한 경우 시험분석을 위한 샘플을 요청할 권한이 있으며 동국제강(주) 요구시 클레임 청구자는 샘플을 제공해야 할 책임이 있습니다. ");

			    FormD2.setItemLabel('S9', "9. 동국제강(주)는 제품이 판매되어 시공되는 과정에 관여한 제조사, 가공처, 유통점, 시공사, 건설사에 대한 정보를 요구할 권리를 가지며, 고객은 이에 대한 충분한 정보를 제공하여야 합니다. 또한 동국제강(주)은 제품의 Coil Number, 가공일자, 시공일자 등에 대한 충분한 자료 및 기록을 확인하고 조사할 권리를 가집니다. ");

			    FormD2.setItemLabel('SA', "10. 동국제강(주)는 판매된 제품 자체에 대한 클레임만 수용할 뿐, 보증항목에 해당하지 않는 원인으로 발생된 클레임에 대해서는 어떠한 의무도 지지 않습니다. ");

			    FormD2.setItemLabel('SB', "11. 본 보증서는 발급대상으로 명기된 고객을 제외한 누구에게도 양도 혹은 이전될 수 없습니다. 또한, 보증서를 발급받은 고객을 제외한 어떠한 대리인, 대표자, 중개인도 고객을 대신하여 이 보증서에 대한 권리를 가질 수 없으며, 제품에 대한 어떠한 책임도 물을 수 없습니다. ");

			    FormD2.setItemLabel('SC', "12. 본 보증서는 동국제강(주)에서 발행되는 다른 모든 제품의 보증서에 우선하여 적용됩니다. 본 보증서 상의 모든 변경, 수정, 추가사항은 반드시 동국제강(주) 품질담당자의 서명을 포함하여 명문화 되어야 합니다. 영업사원이나 중계상의 동의에 의해 변경된 보증서는 효력을 상실하게 됩니다.");

			    FormD2.setItemLabel('SD', "13. 본 보증과 관련하여 법적인 분쟁이 발생하는 경우 동국제강(주) 본사 소재지의 관할법원에서 처리함을 원칙으로 합니다.");

			    FormD2.setItemLabel('SE', "본 보증서는 아래 서명 후에 효력이 발생합니다. ");

			}else if(value == "ENG"){
				radio1Value = "ENG";
				FormD2.showItem("BRD_CMP_2_1");
				FormD2.showItem("NAT_ENM");
				FormD2.showItem("BRD_CMP_2_2");
				if(items['C106000110_Form_2'].getItemValue("CLS_CD") == "CLASSB"){
					FormD2.showItem("NAT_ENM_1");
				}
				FormD2.showItem("PER_FOR_6");
				FormD2.showItem("PER_FOR_19_1");
				FormD2.showItem("BRD_CMP_2_7");
				FormD2.showItem("PE_FL_20");
				FormD2.showItem("PE_FL_1");
				FormD2.showItem("BRD_CMP_2_3");
				FormD2.showItem("FA_TRM_7");
				FormD2.showItem("FA_TRM_8");
				FormD2.showItem("BRD_CMP_2_4");
				FormD2.showItem("FA_WAL_12");
				FormD2.showItem("FA_WAL_11");
				FormD2.showItem("FA_ROF_10");
				FormD2.showItem("FA_ROF_9");
				FormD2.showItem("CH_TRM_14");
				FormD2.showItem("CH_TRM_13");
				FormD2.showItem("BRD_CMP_2_6");
				FormD2.showItem("CH_WAL_18");
				FormD2.showItem("CH_WAL_17");
				FormD2.showItem("CH_ROF_16");
				FormD2.showItem("CH_ROF_15");
				FormD2.showItem("BRD_CMP_2_5");
				
				FormD2.setItemLabel("SS_1", "DONGKUK STEEL provides the following warranty concerning");
    			FormD2.setItemLabel("SS_2", "System for building and roofing panel end");
	    		FormD2.setItemLabel("SS_3", " use in ");
	    		FormD2.setItemLabel("SS_4", "");
	    		FormD2.setItemLabel("SS_5", "Warranty is subjected to the following terms and conditions : " );
				
	    		FormD2.setItemLabel("S1_1", "1. DONGKUK STEEL warrants that the");
	    		FormD2.setItemLabel("S1_2", "covered by this warranty will conform to the performance standards listed below. ");
				FormD2.setItemLabel('primiumClassA', "Items #A through # C below apply to metal building and similar structures installed north of the 15th parallel in the northern hemisphere or south of the 15th parallel in the southern hemisphere. Only item # A applies to metal building and similar structures installed between these latitudes:");
				FormD2.setItemLabel('primiumClassB', "Items #A through # C below apply to metal building and similar structures installed in");
				FormD2.setItemLabel('universalClassB', "Items #A through # D below apply to metal building and similar structures installed in");
				FormD2.setItemLabel('universalClassA', "Items #A through # D below apply to metal building and similar structures installed north of the 15th parallel in the northern hemisphere or south of the 15th parallel in the southern hemisphere. Only item # A applies to metal building and similar structures installed between these latitudes:");
				FormD2.setItemLabel('S1_3', "");
	    		 
				FormD2.setItemLabel('S1A_1', "A. For");
				FormD2.setItemLabel('S1A_2', "years, ");
				FormD2.setItemLabel('S1A_3', "will have prior to corrosion to perforation in the natural element. ");
				
			    FormD2.setItemLabel('S1B_1', "B. For");
				FormD2.setItemLabel('S1B_2', "years, ");
				FormD2.setItemLabel('S1B_3', "will not peel, flake or otherwise lose adhesion to an extent that is apparent on ordinary ");
				FormD2.setItemLabel('S1B_4', "NOTE : Slight crazing or cracking may occur on roll formed edges or break bends at the time of forming, and is considered as standard -such crazing or cracking shall not constitute a basis for complaint under this limited warranty; and");

			    FormD2.setItemLabel('S1C_1', "C. For");
				FormD2.setItemLabel('S1C_2', "years, sidewall panels of ");
			    FormD2.setItemLabel('S1C_3', "will not change color more than ");
				FormD2.setItemLabel('S1C_4', "delta E Hunter");
			    FormD2.setItemLabel('S1C_5', " units and roof panels will not change more than ");
				FormD2.setItemLabel('S1C_6', "delta E Hunter units.");
			    FormD2.setItemLabel('S1C_7', "	Color change shall be measured on an exposed painted surface that has been cleaned of surface soils and Chalk, and the corresponding values measured on the original or unexposed painted surface. It is undersood that fading or color changes may not be uniform if the surfaces are not equally exposed to the sun and elements.");

			    FormD2.setItemLabel('labelD', "D. For");
				FormD2.setItemLabel('labelChgToC', "C. For");
				FormD2.setItemLabel('S1D_2', "years, sidewall panels of ");
				FormD2.setItemLabel('S1D_3', "will not chalk more than a number");
				FormD2.setItemLabel('S1D_4', "roof panels won&#39;t chalk more than a number");
				FormD2.setItemLabel('S1D_5', "rating when measured per ASTM D4214, Method C.");
				
			    FormD2.setItemLabel('S2_1', "2. No warranty is provided for ");
				FormD2.setItemLabel('S2_2', "on any substrate that is subjected to sea spray or installed on property located within 1,000 meters (3,250 feets) of a salt-water environment.");

				FormD2.setItemLabel('S3', "3. This warranty is restricted to failures resulted from normal weathering and does not include coating failures caused by scratches, scrapes or any other unnatural damage including improperly formed, fabricated or embossed material. This warranty excludes failures caused by standing water, and direct exposure to corrosive and aggressive atmospheres including salt spray and animal waste products. DONGKUK STEEL also holds no liability for damages caused by acts of God, radiation, falling objects, explosions, or other external forces beyond Dongkuk steel&#39;s control.");

				FormD2.setItemLabel('S4', "4. Some colors may not meet our high standards. So this warranty applies only to colors that are on DONGKUK STEEL&#39;s approved color range. DONGKUK STEEL will inform you the time of color matching if the color you have selected is not an approved color.");

			    FormD2.setItemLabel('S5', "5. DONGKUK STEEL&#39;s responsibility extends only to the direct cost of refinishing or replacing failed coated substrate. Dongkuk steel cannot accept liability for loss or damage to other property or equipment, loss of profits or sales, or any other claims relative to standard business interruption, or any other incidental or consequential damages.");
			    FormD2.setItemLabel('S5_1', "A. DONGKUK STEEL shall only be liable for the cost of having the same metal panel or steel sheet");			    
			    FormD2.setItemLabel('S5_2', "B. DONGKUK STEEL shall not be liable for the cost of construction equipments, labor or any kind of losses");
			    
			    FormD2.setItemLabel('S6', "6. DONGKUK STEEL reserves the right to establish whether repainting or replacing material is required and to approve and participate in the negotiation of any subcontracted material replacement, installation, or refinishing. After replacement or re-finishing of the repaired area, this area will be considered as installed as of the original installation date for the purpose of the application of this warranty.");
			    FormD2.setItemLabel('S6_1', "");
			    FormD2.setItemLabel('S6_2', "");
			    
			    FormD2.setItemLabel('S7', "7. Claims under this warranty must be submitted in writing within thirty (30) days of discovery of the warranted performance failure and DONGKUK STEEL requires the opportunity for site failure inspection and investigation. DONGKUK STEEL also reserves the right to evaluate and determine its obligation under the terms and condition of this limited warranty.");

			    FormD2.setItemLabel('S8', "8. DONGKUK STEEL shall maintain, or have access to, adequate records to identify the coil coater, coil numbers, product identification and date of installation. In the event of a claim, DONGKUK STEEL reserves the right to inspect all records mentioned above.");

			    FormD2.setItemLabel('S9', "9. This limited warranty supersedes any and all other warranties of performance, expressed or implied, by DONGKUK STEEL. Any modifications, additions, or adjustments made to this warranty must be officially added as a signed written amendment.");

			    FormD2.setItemLabel('SA', "10. This limited warranty is non-transferable, non-assignable, and may not be modified, extended or enlarged by any representative of DONGKUK STEEL or intermediate salesman or agent.");
			    
			    FormD2.setItemLabel('SB', "");
			    
			    FormD2.setItemLabel('SC', "");
			    
			    FormD2.setItemLabel('SD', "");
			    
			    FormD2.setItemLabel('SE', "This warranty becomes effective when all of the above conditions meet 	and DONGKUK STEEL have signed this agreement as of the date set forth below.");

			}
		}
		return true;
 }
//]]>
-->
</script>
</head>
<body>
<div id="C106000110_Form_1" style="position:absolute;height:61px;width:964px;left:0px;top:0px;">
</div>
<div id="C106000110_messagebox" style="position:absolute;height:19px;width:962px;left:0px;top:1072px;">
</div>
<div id="C106000110_Form_2" style="position:absolute;height:1013px;width:964px;left:0px;top:61px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();	
	var _onXLEForm  = items['C106000110_Form_1'].onXLEEvent(onFormLoadFunction);
	var _onXLEForm2 = items['C106000110_Form_2'].onXLEEvent(onFormLoadFunction2);
	items['C106000110_Form_1'].onAfterUpdateFinishEvent(prtRpt);  
	items['C106000110_Form_1'].onChangeEvent(OnRadioChanged);
	items['C106000110_Form_2'].getDhxForm().attachEvent('onChange', OnDataChanged);
//]]>
-->
</script>