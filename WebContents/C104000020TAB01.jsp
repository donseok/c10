<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-공통
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.11.14
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.11.14     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">

//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000020TAB01_Form_1","xml":".\/header\/kr\/C104000020TAB01\/C104000020TAB01_Form_1.xml","url":"basicFormData.do","referenceItem":"C104000020TAB01_Form_1","service":"C104000020TAB01-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C104000020TAB01\/messagebox.xml","service":"C104000020TAB01-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"/dhtmlx/codebase/imgs/"};
//form find button item event function (requred)
function find(eventName){
	var findUrl = uiCommon.parameters3('C104000020_Form_1','C104000020TAB01_Form_1',eventName);
	items['C104000020TAB01_Form_1'].loadData(findUrl,findMessage); 
}

function save(eventName,formDivObj,referenceItem){
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();
	var uiFormObj = items['C104000020TAB01_Form_1'];
	var ord_spc_txt = uiFormObj.getItemValue("ORD_SPC_TXT");
	var bak_mrk = uiFormObj.getItemValue("BAK_MRK");   //2013.07.09 이세민대리 Back Marking수정 가능하게 요청

	if(isNull(ord_no)){
		alert("주문번호를 입력해주세요.");
		parentForm.setItemFocus("ORD_NO");
		return;	
	}else if(isNull(ord_ln)){
		alert("주문행번을 선택해주세요.");
		comboList.DOMelem_input.focus();
		return;	
	}
    if( ord_no != uiFormObj.getItemValue("ORD_NO") || ord_ln != uiFormObj.getItemValue("ORD_LN") ){
		alert("입력한 주문번호가 조회된 주문번호와 다릅니다.");
		parentForm.setItemFocus("ORD_NO");
		return;	
    }
	uiFormObj.setItemValue("ORD_NO",ord_no);
	uiFormObj.setItemValue("ORD_LN",ord_ln);
	
	dhtmlx.confirm({
		title:"[ 품질설계텍스트수정 ]",
		ok:"수정", cancel:"취소",
		text:"수정하시겠습니까?",
		callback:function(val){
			 if(val){
				var customParam = {"ORD_NO":ord_no,"ORD_LN":ord_ln,"ORD_SPC_TXT":ord_spc_txt,"BAK_MRK":bak_mrk};
				uiFormObj.sendForm("handleDataProcess.do",'C104000020TAB01_Form_1','save',customParam);
				return;
			 }
		}
	});		
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
function findMessage(referenceItem){
	var uiFormObj = items['C104000020TAB01_Form_1'];
	var ORD_SHT_LOD_MTH = uiFormObj.getDhxForm().getItemValue("ORD_SHT_LOD_MTH");
	var ORD_COILG_MTH = uiFormObj.getDhxForm().getItemValue("ORD_COILG_MTH");
	var ORD_SLV_KND_TP = uiFormObj.getDhxForm().getItemValue("ORD_SLV_KND_TP");
	var ORD_PAK_UNT_WGT_ULV = uiFormObj.getDhxForm().getItemValue("ORD_PAK_UNT_WGT_ULV");

	
	if(uiFormObj.getItemValue("messageBox") == "0"){	
		uiFormObj.clear();
	    uiCommon.message(ui.messagebox.messageBoxDivId,"0건 조회되었습니다.");
    }else{    
		uiCommon.message(ui.messagebox.messageBoxDivId,uiFormObj.getItemValue("messageBox"));

	    if(uiFormObj.getItemValue("ORD_COIL_IDIA") == "610"){
	       uiFormObj.getDhxForm().getInput("ORD_COIL_IDIA").style.color="red";	      
    	}
	   
	    if(!isNull(ORD_SHT_LOD_MTH)){
	    	if(ORD_SHT_LOD_MTH.substring(0,1) != "T"){
	        	uiFormObj.getDhxForm().getInput("ORD_SHT_LOD_MTH").style.color="red"; 
	        } 
	    }
     
	    if(!isNull(ORD_COILG_MTH)){
        	if(ORD_COILG_MTH.substring(0,1) == "U" || ORD_COILG_MTH.substring(0,1) == "S"){
	        	uiFormObj.getDhxForm().getInput("ORD_COILG_MTH").style.color="red";
	     	}
     	}
	    
	    if(!isNull(ORD_SLV_KND_TP)){
        	if(ORD_SLV_KND_TP.substring(0,1) == "N"){
	        	uiFormObj.getDhxForm().getInput("ORD_SLV_KND_TP").style.color="red";
	     	}
     	}

       	if(!isNull(ORD_PAK_UNT_WGT_ULV) && parseInt(ORD_PAK_UNT_WGT_ULV) <= 2900){
	        uiFormObj.getDhxForm().getInput("ORD_PAK_UNT_WGT_ULV").style.color="red";
	    } else {
			uiFormObj.getDhxForm().getInput("ORD_PAK_UNT_WGT_ULV").style.color="black";
		}

    }
	return true;
}
function onFormLoadEvent(){ 
	return true;
}
function onFormLoad(){ 
	var findUrl = uiCommon.parameters3('C104000020_Form_1','C104000020TAB01_Form_1',"find"); 
	items['C104000020TAB01_Form_1'].loadData(findUrl,findMessage); 

	backspaceOff("C104000020TAB01_Form_1");
	items['C104000020TAB01_Form_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	items['C104000020TAB01_Form_1'].getDhxForm().detachEvent(_onXLE);
	return false; 
}
function onSelectTab(id, lastId){ 
	if(id == "C104000020TAB01"){
		var findUrl = uiCommon.parameters3('C104000020_Form_1','C104000020TAB01_Form_1',"find"); 
		items['C104000020TAB01_Form_1'].loadData(findUrl,findMessage); 
	}
	return true; 
}
function onAfterUpdateFinishEvent(){
	 items['C104000020TAB01_Form_1'].getDhxForm().resetDataProcessor("updated");
	var findUrl = uiCommon.parameters3('C104000020_Form_1','C104000020TAB01_Form_1',"find"); 
	 items['C104000020TAB01_Form_1'].loadData(findUrl,findMessage); 
}

function backSpaceNotEvent(e){ 
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
//]]>

</script>
</head>
<body>
<div id="C104000020TAB01_Form_1" style="position:absolute;height:429px;width:973px;left:0px;top:0px;overflow-x:hidden;overflow-y:scroll">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:973px;left:1px;top:429px;">
</div>
</body>
</html>
<script>
//<![CDATA[
       ui.initializeDHTMLX();   
       items['C104000020TAB01_Form_1'].setBackgroundColor("#FFFFFF");
       var _onXLE = items["C104000020TAB01_Form_1"].getDhxForm().attachEvent("onXLE", onFormLoad);
       parent.items['C104000020_Tabbar_1'].getDhxTabbar().attachEvent("onSelect",onSelectTab);
//]]>
</script>