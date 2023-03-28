<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과Main
 * DESIGNER NAME    :  한 윤 섭 
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.11.14
 *
 * Date           Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.11.14     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%
	String ORD_NO = request.getParameter("ORD_NO") !=null ? request.getParameter("ORD_NO") : "";
	String ORD_LN = request.getParameter("ORD_LN") !=null ? request.getParameter("ORD_LN") : "";
	String QLT_DSN_YN = request.getParameter("QLT_DSN_YN") !=null ? request.getParameter("QLT_DSN_YN") : "";
	String CCL_BOM_NO = request.getParameter("CCL_BOM_NO") !=null ? request.getParameter("CCL_BOM_NO") : "";
    String colorTabOpen = request.getParameter("colorTabOpen") !=null ? request.getParameter("colorTabOpen") : ""; //20210204 변정훈 품질설계결과 화면 오픈 시 칼라제조사양 탭 오픈 여부 변수
 
	PosUser	user = (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String userNo	= "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
	}
 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
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
var colorTabOpen = '<%=colorTabOpen%>'; //20210204 변정훈 품질설계결과 화면 오픈 시 칼라제조사양 탭 오픈 여부 변수            

var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000020_Form_1","xml":".\/header\/kr\/C104000020\/C104000020_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020_Form_2","service":"C104000020-service","actionType":"save"},' +
      '{"itemType":"tabbar","renderTo":"C104000020_Tabbar_1","xml":".\/header\/kr\/C104000020\/C104000020_Tabbar_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","skin":"modern","service":"C104000020-service"},' +
      '{"itemType":"form","renderTo":"C104000020_Form_2","xml":".\/header\/kr\/C104000020\/C104000020_Form_2.xml","url":"basicFormData.do","referenceItem":"C104000020_Form_2","service":"C104000020-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);      
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"/dhtmlx/codebase/imgs/"};
//form find button item event function (requred)
function find(eventName){
	var form = items['C104000020_Form_1'];
	var comboList = form.getDhxForm().getCombo("ORD_LN");

	if(isNull(form.getItemValue("ORD_NO"))){
		dhtmlx.alert("주문번호를 입력해주세요.");
		form.setItemFocus("ORD_NO");
		return; 
	}else if(isNull(comboList.getSelectedValue())){
		dhtmlx.alert("주문행번를 선택해주세요.");
		comboList.DOMelem_input.focus();
		return; 
	}else{
		var findUrl = uiCommon.parameters6('C104000020_Form_1','C104000020_Form_2',eventName);
		items['C104000020_Form_2'].loadData(findUrl,findMessage); 
		items["C104000020_Tabbar_1"].activeTabFrame().contentWindow.find(eventName);     
	}
}
function tag_popup(){
 //var grid = items['C105000010_Grid_1'];
 //var inqNo = "";
 //if(!isNull(grid.getSelectedRowId())){
 // inqNo = grid.getDhxGrid().cells(grid.getSelectedRowId(),0).getValue();
 //}
 //winObj = new ui.window("popup","Tag정보조회","0","0","634","569","c105000010pop01.do?INQ_NO="+inqNo);
 var form = items['C104000020_Form_1'];
 var comboList = form.getDhxForm().getCombo("ORD_LN");
 if(isNull(form.getItemValue("ORD_NO"))){
  dhtmlx.alert("주문번호를 입력해주세요.");
  form.setItemFocus("ORD_NO");
  return; 
 }else if(isNull(comboList.getSelectedValue())){
  dhtmlx.alert("주문행번를 선택해주세요.");
  comboList.DOMelem_input.focus();
  return; 
 }
 
 winObj = new ui.window("popup","Tag정보조회","0","0","619","505","C104000020POP01.jsp?ORD_NO="+form.getItemValue("ORD_NO")+"&ORD_LN="+comboList.getSelectedValue());
 winObj.setButtonDisable("park,minmax1");
 winObj.setModal();
 winObj.getDhxWindow().attachEvent("onClose", function(win){
   this.hide();
   return true;
   //winObj.unload();
 });
 
}


function save(eventName,formDivObj,referenceItem){
	var form = items['C104000020_Form_1'];
	var form2 = items['C104000020_Form_2'];
	var comboList = form.getDhxForm().getCombo("ORD_LN");
	var ord_no = form.getItemValue("ORD_NO");
	var ord_ln = comboList.getSelectedValue();
	var ccl_bom = form2.getItemValue("CCL_BOM_NO");
	var ccl_bom_tmp = ccl_bom.substring(0,2);
	var prd_nm_cd = form2.getItemValue("PRD_NM_CD_ORG");
    
	if(isNull(ord_no)){
		dhtmlx.alert("주문번호를 입력해주세요.");
		form.setItemFocus("ORD_NO");
		return; 
	}else if(isNull(ord_ln)){
		dhtmlx.alert("주문행번를 선택해주세요.");
		comboList.DOMelem_input.focus();
		return; 
	}
	
	var cnt = "0";
	var param= "ServiceName=C104000020-service&ERR_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=NO_THK";
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell");
 
	if(cells.length > 0){
		cnt = cells.item(0).firstChild.nodeValue;
		if(cnt == "1"){
			dhtmlx.confirm({
    		title:"[[ 설계확정 ]]",
    		ok:"확정", cancel:"취소",
    		text:"제품두께범위를 벗어난 주문입니다.\n 그래도 확정하시겠습니까?",
    		callback:function(val){
      			if(val){
      				var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln,"QLT_DSN_STS_CD":"A"};
      				form.sendForm("handleDataProcess.do",'C104000020_Form_1','save',customParam);
      				return;}
    			}
   			});
     	}  
	} 
 
	if(cnt != "1")
	{
		param= "ServiceName=C104000020-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=ORD_NO";
		xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		cells = xmlObj.getElementsByTagName("cell");
  
		if(cells.length > 0){      
			dhtmlx.alert("반송된 주문이거나 보류 혹은 설계상태가 확정대기가 아닙니다!");
   			return;     
  		}
  
  		//CCLBOM이 US****로 시작하는 주문은 확정하기 전에 통과공정이 RB가 있는지 확인하고 없는경우는 확정이 안되게 한다
  		//2014.12.15 변경
		if(ccl_bom_tmp == "US"){
			param= "ServiceName=C104000020-service&PROC_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=ORD_NO";
   			xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
   			cells = xmlObj.getElementsByTagName("cell");
   
   			if(cells.length < 1){      
    			dhtmlx.alert("해당주문은 CP(RH)공정이 반드시 추가되어야 하는 주문입니다(US****로 시작하는 BOM때문)!");
    			return;
    		}
  		}
  
		//위탁임가공의 경우 통과공정여부를 반드시 확인하라는 경고메시지 띄운다.(2015.3.12 박성용기사요청)
		var trst_proc_yn = form.getItemValue("TRST_PROC_YN");
		if(trst_proc_yn == "Y"){
			dhtmlx.alert("위탁임가공 주문입니다. 통과공정정보를 반드시 확인하시고 확정하시기 바랍니다."); 
  		}
		
		//로그인한 설계원과 설계내용 수정한 설계원이 동일한 경우 설계확정이 안되게 체크한다 (2023.2.7 이상현차장 요청)
		if(prd_nm_cd == "G" || prd_nm_cd == "L" || prd_nm_cd == "V" || prd_nm_cd == "W"){
			param= "ServiceName=C104000020-service&MOD_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=LAST_UPDATED_OBJECT_ID";
			xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
			cells = xmlObj.getElementsByTagName("cell");
			
			if(cells.length > 0){
				var modUserId = cells.item(0).firstChild.nodeValue;
				if(modUserId == <%=userNo%>){      
					dhtmlx.alert("설계내용 수정자와 설계 확정자가 동일함으로 확정이 불가합니다 ");
		   			return;     
		  		}
			}
		}
		
		dhtmlx.confirm({
			title:"[[ 설계확정 ]]",
			ok:"확정", cancel:"취소",
			text:"확정하시겠습니까?",
				callback:function(val){
					if(val){
					//var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln,"QLT_DSN_STS_CD":"A"};
						var param = "ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln;
						form.sendForm("handleDataProcess.do",'C104000020_Form_1','save',param);
						//form.sendForm("handleDataProcess.do",'C104000020_Form_1','save',customParam);
						return;
					}
				}
		});  
	}
}
function holdy(eventName,formDivObj,referenceItem){        

 var form = items['C104000020_Form_1'];       
 var comboList = form.getDhxForm().getCombo("ORD_LN");       
 var ord_no = form.getItemValue("ORD_NO");        
 var ord_ln = comboList.getSelectedValue();        
 
 if(isNull(ord_no)){       
  dhtmlx.alert("주문번호를 입력해주세요.");      
  form.setItemFocus("ORD_NO");      
  return;      
 }else if(isNull(ord_ln)){       
  dhtmlx.alert("주문행번를 선택해주세요.");      
  comboList.DOMelem_input.focus();      
  return;      
 }
 
 param= "ServiceName=C104000020-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=ORD_NO";      
 xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);      
 cells = xmlObj.getElementsByTagName("cell");      
 if(cells.length > 0){      
  dhtmlx.alert("반송된 주문이거나 보류 혹은 설계상태가 확정대기가 아니기에 보류대상이 아닙니다!");     
  return;     
 } 
 else
 {
  dhtmlx.confirm({       
   title:"[[ 설계보류 ]]",      
   ok:"보류", cancel:"취소",      
   text:"보류하시겠습니까?",      
   callback:function(val){      
     if(val){     
     //var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln,"QLT_HLD_YN":"Y"};
     var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};
     form.sendForm("handleDataProcess.do",'C104000020_Form_1','holdy',customParam);    
     return;    
     }     
   }      
  });
 }
}        

function holdn(eventName,formDivObj,referenceItem){        
 
 var form = items['C104000020_Form_1'];
 var comboList = form.getDhxForm().getCombo("ORD_LN");
    var ord_no = form.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();

 if(isNull(ord_no)){       
  dhtmlx.alert("주문번호를 입력해주세요.");      
  form.setItemFocus("ORD_NO");      
  return;      
 }else if(isNull(ord_ln)){       
  dhtmlx.alert("주문행번를 선택해주세요.");      
  comboList.DOMelem_input.focus();      
  return;      
 }

 dhtmlx.confirm({       
  title:"[[ 설계보류해제 ]]",      
  ok:"보류해제", cancel:"취소",      
  text:"보류해제하시겠습니까?",      
  callback:function(val){      
    if(val){     
    //var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln,"QLT_HLD_YN":""};
    var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};
    form.sendForm("handleDataProcess.do",'C104000020_Form_1','holdn',customParam);    
    return;    
    }     
  }      
 });  
}

function atty(eventName,formDivObj,referenceItem){        

 var form = items['C104000020_Form_1'];       
 var comboList = form.getDhxForm().getCombo("ORD_LN");       
 var ord_no = form.getItemValue("ORD_NO");        
 var ord_ln = comboList.getSelectedValue();
 var att_ord_yn = form.getItemValue("ATT_ORD_YN");
 
 if(isNull(ord_no)){       
  dhtmlx.alert("주문번호를 입력해주세요.");      
  form.setItemFocus("ORD_NO");      
  return;      
 }else if(isNull(ord_ln)){       
  dhtmlx.alert("주문행번를 선택해주세요.");      
  comboList.DOMelem_input.focus();      
  return;      
 }
 
 if(att_ord_yn == "Y"){
  dhtmlx.alert("현재 관심주문 상태입니다.");            
  return;
 }
 /*
 param= "ServiceName=C104000020-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=ORD_NO";      
 xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);      
 cells = xmlObj.getElementsByTagName("cell");      
 if(cells.length > 0){      
  dhtmlx.alert("확정대기일때 관심주문으로 등록 가능합니다!");     
  return;     
 } 
 else
 {
 */
  dhtmlx.confirm({       
   title:"[[ 관심등록 ]]",      
   ok:"등록", cancel:"취소",      
   text:"등록하시겠습니까?",      
   callback:function(val){      
     if(val){     
     //var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln,"QLT_HLD_YN":"Y"};
     var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};
     form.sendForm("handleDataProcess.do",'C104000020_Form_1','atty',customParam);    
     return;    
     }     
   }      
  });
 //}
}        

function attn(eventName,formDivObj,referenceItem){        
 
 var form = items['C104000020_Form_1'];
 var comboList = form.getDhxForm().getCombo("ORD_LN");
    var ord_no = form.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();
    var att_ord_yn = form.getItemValue("ATT_ORD_YN");

 if(isNull(ord_no)){       
  dhtmlx.alert("주문번호를 입력해주세요.");      
  form.setItemFocus("ORD_NO");      
  return;      
 }else if(isNull(ord_ln)){       
  dhtmlx.alert("주문행번를 선택해주세요.");      
  comboList.DOMelem_input.focus();      
  return;      
 }
 if(att_ord_yn == "N" || isNull(att_ord_yn)){
  dhtmlx.alert("현재 관심주문 해제상태 입니다.");            
  return;
 }
 
 //1. 해당주문에 SMS전송이력 있으면 해제불가
 //2. 해당주문에 SMS전송이력 없으나 수동 등록건이 있으면 해제불가
 param= "ServiceName=C104000020-service&SMS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=SMS_YN";      
 xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);      
 cells = xmlObj.getElementsByTagName("cell");      
 if(cells.length > 0){      
  dhtmlx.alert("SMS전송이력이 있거나 사용자 수동 등록 데이터가 있습니다!");     
  return;     
 }
 else{
  dhtmlx.confirm({       
   title:"[[ 관심등록해제 ]]",      
   ok:"관심해제", cancel:"취소",      
   text:"관심해제하시겠습니까?",      
   callback:function(val){      
     if(val){     
     //var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln,"QLT_HLD_YN":""};
     var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln};
     form.sendForm("handleDataProcess.do",'C104000020_Form_1','attn',customParam);    
     return;    
     }     
   }      
  });
 }
}

function onAfterUpdateFinishEvent(){
 //폼에 있는 정보가 아닐때 업데이트 후 반드시 아래 문구 입력
 items['C104000020_Form_1'].getDhxForm().resetDataProcessor("inserted");
 //재조회
 find("find");
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].getSelectionClear();
}
//menu new row event function
function add(referenceItem){
    items[referenceItem].addRow();
}
//menu remove event function
function modify(referenceItem){
    items[referenceItem].removeRow();
}
//menu remove event function
function remove(referenceItem){
    items[referenceItem].removeRow();
}
//menu rows clipboard copy event function
function copy(referenceItem){
    items[referenceItem].copyRowsClipboard('srows','\t');
}
//menu rows clipboard paste event function
function paste(referenceItem){
    items[referenceItem].addRowClipboard();
}
//(undo)
function undo(referenceItem){
    items[referenceItem].undo();
}
//(Redo)
function redo(referenceItem){
    items[referenceItem].redo(); 
}
/*
function findMassage(){ 
 var uiFormObj = items['C104000020_Form_2']; 
 uiCommon.message(ui.messagebox.messageBoxDivId,uiFormObj.getItemValue("messageBox")); 
 if(uiFormObj.getItemValue("messageBox") == "0")
 { 
  uiFormObj.clear(); 
  uiCommon.message(ui.messagebox.messageBoxDivId,"0건 조회되었습니다."); 
 }
 else
 { 
  uiCommon.message(ui.messagebox.messageBoxDivId,uiFormObj.getItemValue("messageBox")); 
 } 
}
*/
function findMessage(referenceItem){
 //위탁임가공 값 세팅 
 setTrstProcYn();
 //품질협정서 여부 확인
 setQltYn();
 uiCommon.progressOff(parent);
 
 return true;
}
function setQltYn(){
	//품질협정서 여부체크
	var form = items['C104000020_Form_2'];
	var cnt_qlt = '';
	var cus_cd = form.getDhxForm().getItemValue("CUS_CD_ORG");
	var act_cus_cd = form.getDhxForm().getItemValue("ACT_CUS_CD_ORG");
	var fnl_cus_cd = form.getDhxForm().getItemValue("FNL_CUS_CD_ORG");
		
	param= "ServiceName=C104000020-service&QLT_find=1&FNL_CUS_CD=" + fnl_cus_cd + "&CUS_CD=" + cus_cd + "&ACT_CUS_CD=" + act_cus_cd + "&column-info=QLT_CNT";
	xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	cells = xmlObj.getElementsByTagName("cell");
	cnt_qlt = cells.item(0).firstChild.nodeValue;

	if(cnt_qlt < 1){
		items['C104000020_Form_1'].getDhxForm().disableItem("custom_call");
	}else{
		items['C104000020_Form_1'].getDhxForm().enableItem("custom_call");
	}
	
}

function setTrstProcYn(){
	 var form1 = items['C104000020_Form_1'];
	 var form2 = items['C104000020_Form_2'];
	 var ordLn      = form1.getItemValue("ORD_LN");
	 var trstProcYn = form2.getItemValue("TRST_PROC_YN");
	 var att_ord_Yn = form2.getItemValue("ATT_ORD_YN");
	 form1.setItemValue("TRST_PROC_YN",trstProcYn);
	 form1.setItemValue("ATT_ORD_YN",att_ord_Yn);
}

function onFormLoadEvent(){ 
 items['C104000020_Form_1'].setItemValue("ORD_NO","<%=ORD_NO%>");
 var ORD_NO = items['C104000020_Form_1'].getItemValue("ORD_NO");
    var comboList = items['C104000020_Form_1'].getMasterCombos();
    comboList['ORD_LN'].readonly(true,false);
    ui.combo(comboList['ORD_LN'],"OrdlnComboData.do","ServiceName=C104000020-service&OrdLnFind=1&column-info=ORD_LN,ORD_LN&ORD_NO="+ORD_NO,function(){
  items['C104000020_Form_1'].setItemValue("ORD_LN", "<%=ORD_LN%>");
  });
  comboList['ORD_LN'].DOMelem_input.onkeydown = function(e){
  key = (e) ? e.keyCode : event.keyCode;
  if(key==8 || key==116){
   if(e){   //표준         
    e.preventDefault();
   }
   else{ //익스용
    event.keyCode = 0;
    event.returnValue = false;
   }
  }
 }
    var inputObj = items["C104000020_Form_1"].getDhxForm().getInput("ORD_NO");
 inputObj.onkeyup = function(){
    inputObj.value = inputObj.value.toUpperCase();  
 }  
 
 return true;
}
function onFormLoadEvent2(){ 
 //위탁임가공 값 세팅 
 setTrstProcYn();
//품질협정서 여부 확인
 setQltYn();
 readOnlyItemBackEvent('C104000020_Form_2');
 return true;  
}
function onChange(id,value){
 var item = id;
 if(item == "ORD_NO")
 {
  var ORD_NO = items['C104000020_Form_1'].getItemValue("ORD_NO");
  var comboList = items['C104000020_Form_1'].getMasterCombos();
  comboList['ORD_LN'].readonly(false,false);
  ui.combo(comboList['ORD_LN'],"OrdlnComboData.do","ServiceName=C104000020-service&OrdLnFind=1&column-info=ORD_LN,ORD_LN&ORD_NO="+ORD_NO);
 } 
}

function openBom(){
 var vUrl = "";
 var cclbom_tmp  = items["C104000020_Form_2"].getItemValue("CCL_BOM_NO");
 var cclbom = cclbom_tmp.substring(0,5);
 
 if(isNull(cclbom)){
  dhtmlx.alert("BOM정보가 없습니다!");
 }
 else{
  vUrl += "CCL_BOM_NO="+encodeURIComponent(cclbom);
  parent.newRemoveOpenTab("C106000060", vUrl);
 }
}

function openColImg(){
 var vUrl = "";
 var cclbom_tmp  = items["C104000020_Form_2"].getItemValue("CCL_BOM_NO");
 var cclbom = cclbom_tmp.substring(0,5);
 var cclbom_1 = cclbom_tmp.substring(0,1);
 
 if(isNull(cclbom)){
 	dhtmlx.alert("BOM정보가 없습니다!");
 }
 else{ 
 		if(cclbom_1 == "J")
 		{
 			vUrl += "CCL_BOM_NO="+encodeURIComponent(cclbom);
 			parent.newRemoveOpenTab("C106000140", vUrl);
 		}
 		else{
 			vUrl += "CCL_BOM_NO="+encodeURIComponent(cclbom);
 	 		parent.newRemoveOpenTab("C106000100", vUrl);	
 		}
	 	
 	}
}

function openCdUsg(){
 var vUrl = "";
 var cclbom_tmp  = items["C104000020_Form_2"].getItemValue("CCL_BOM_NO");
 var cclbom = cclbom_tmp.substring(0,5);
 
 if(isNull(cclbom)){
  dhtmlx.alert("BOM정보가 없습니다!");
 }
 else{
  vUrl += "CCL_BOM_NO="+encodeURIComponent(cclbom);
  parent.newRemoveOpenTab("C106000090", vUrl);
 }
}

function custom_call(){
 var fnlCusCd  = items["C104000020_Form_2"].getItemValue("FNL_CUS_CD");
 var cusCD     = items["C104000020_Form_2"].getItemValue("CUS_CD");     // 고객사
 var actCusCd  = items["C104000020_Form_2"].getItemValue("ACT_CUS_CD"); // 수요가
 var vUrl      = "";
 var flag      = 0;

 // 최종수요가
 if(!isNull(fnlCusCd)){
  var FNL_CUS_CD = fnlCusCd.split(" : ");
  if(FNL_CUS_CD.length > 1){
   vUrl += "FNL_CUS_CD="+encodeURIComponent(FNL_CUS_CD[1]); //한글깨짐현상 판정 encodeURIComponent 12-07-23
   flag++;
  }
 }
 // 고객사
 if(!isNull(cusCD)){
  var CUS_CD = cusCD.split(" : ");
  if(CUS_CD.length > 1){
   if(flag > 0){
    vUrl += "&"
   }
   vUrl += "CUS_CD="+encodeURIComponent(CUS_CD[1]);
   flag++;
  }
 }
 // 수요가
 if(!isNull(actCusCd)){
  var ACT_CUS_CD = actCusCd.split(" : ");
  if(ACT_CUS_CD.length > 1){
   if(flag > 0){
    vUrl += "&"
   }
   vUrl += "ACT_CUS_CD="+encodeURIComponent(ACT_CUS_CD[1]);
   flag++;
  }
 }
	//품질협정서 flag 3번으로 송신
	vUrl = vUrl + "&" + "CUS_SPC_TP_CD=" + "3";
 //고객특성등록화면
 if(flag > 0){
   parent.newRemoveOpenTab("M205010010", vUrl); 
 }
}
function winClose(){
 if(typeof(parent.winObj) !== 'undefined'){
  parent.winObj.winClose();     
 }else{
  parent.tabClose();
 }
}
function onTabContentLoaded(id){
 var comboList = items['C104000020_Form_1'].getDhxForm().getCombo("ORD_LN");
 if(isNull(items['C104000020_Form_1'].getItemValue("ORD_NO")) || 
   isNull(comboList.getSelectedValue())){
  return; 
 }
 
 var item = id;
 if(item == "C104000020TAB01")
 {
  var findUrl = uiCommon.parameters6('C104000020_Form_1','C104000020_Form_2',"find");
  items['C104000020_Form_2'].loadData(findUrl, closeProgressBar); //20210204 변정훈 closeeProgressBar 추가
 }
 return true;
}   
function initializeTabEvent(){ 
 var DhxTabObj = items['C104000020_Tabbar_1'].getDhxTabbar();  
 DhxTabObj.attachEvent("onSelect",function(id){
  if(id != 'C104000020TAB01'){
   if("<%=QLT_DSN_YN%>" == "N"){
    dhtmlx.alert("품질설계대상 주문이 아닙니다.");
    return;
   }else{ 
    DhxTabObj.setContentHref(id, id+".jsp?pageID=C104000020");
   }
  }
 return true;
 });
}
//20210204 변정훈 TAB Load 이벤트 추가
function onTabLoadEvent() {
 var tabObj = items['C104000020_Tabbar_1'].getDhxTabbar(); 
 tabObj.detachEvent(onXLETab);
 
 if(colorTabOpen == 'Y') {
  tabObj.setTabActive("C104000020TAB07");
 }
}
//20210204 변정훈 closseBar 닫기 함수 추가
function closeProgressBar() {
 uiCommon.progressOff(parent);
}
//]]>
-->
</script>
</head>
<body>
<div id="C104000020_Form_1" style="position:absolute;height:28px;width:981px;left:0px;top:1px;">
</div>
<div id="C104000020_Form_2" style="position:absolute;height:60px;width:981px;left:0px;top:29px;">
</div>
<div id="C104000020_Tabbar_1" style="position:absolute;height:479px;width:979px;left:1px;top:114px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
        ui.initializeDHTMLX();  
		items['C104000020_Form_1'].onXLEEvent(onFormLoadEvent);
		items['C104000020_Form_2'].onXLEEvent(onFormLoadEvent2);
        initializeTabEvent();
        items['C104000020_Form_1'].getDhxForm().attachEvent("onChange",onChange);
        onXLETab = items['C104000020_Tabbar_1'].getDhxTabbar().attachEvent("onXLE", onTabLoadEvent); //20210204 변정훈 추가
        items['C104000020_Tabbar_1'].getDhxTabbar().attachEvent("onTabContentLoaded",onTabContentLoaded);
        items['C104000020_Form_1'].setBackgroundColor("#FFFFFF");
        items['C104000020_Form_2'].setBackgroundColor("#FFFFFF");
        items['C104000020_Form_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
        //items['C104000020_Form_2'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
       
//]]>
-->
</script>