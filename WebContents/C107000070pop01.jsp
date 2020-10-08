<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C107000070pop01.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  고객불만이력 POPUP
 * DESIGNER NAME    :  김 민 섭
 * DEVELOPER NAME   :  김 민 섭
 * CREATE DATE      :  2020.04.24
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2020.04.24     V1.0      김민섭                 Initial Version
 * 변경일자        
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	PosUser	user		= (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String		userNo	= "";
	String		userName= "";
	if(user!=null) {
		userNo = (String) user.getUserInfo("USER_NO");
		userName = (String) user.getUserInfo("USER_NAME");
	}
	
	String[] valList = {userNo, userName};
	String ctl_tp = ""; 
	try{
	//MASTER 기준 데이터를 읽어온다.(고객불마)
	PosRuleVO result = EasyAccess.getPosRule("C10A2186", valList, null);
	    
	    if(result.getRecordCount() > 0){
	    ctl_tp      = result.getRuleValueAt("TP");        //화면제어여부
	    }
	}catch(Exception e){
	}

String CCL_BOM_NO = request.getParameter("CCL_BOM_NO")==null?"":request.getParameter("CCL_BOM_NO").toString();
String FNL_CUS_CD = request.getParameter("FNL_CUS_CD")==null?"":request.getParameter("FNL_CUS_CD").toString();
String PRD_NM_CD = request.getParameter("PRD_NM_CD")==null?"":request.getParameter("PRD_NM_CD").toString();
String POPUPBlOCK_HIDDEN_TP = request.getParameter("POPUPBlOCK_HIDDEN_TP")	!=null ? request.getParameter("POPUPBlOCK_HIDDEN_TP") : "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
고객불만이력 PopUp
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">

<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C107000070pop01_Form_1","xml":".\/header\/kr\/C107000070pop01\/C107000070pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C107000070pop01_Form_2","service":"C107000070pop01-service","actionType":"save","security":"true"},' +
//       '{"itemType":"messagebox","renderTo":"C107000070pop01_messagebox","xml":".\/header\/kr\/C107000070pop01\/C107000070pop01_messagebox.xml","service":"C107000070pop01-service"},' +
//       '{"itemType":"form","renderTo":"C107000070pop01_Form_2","xml":".\/header\/kr\/C107000070pop01\/C107000070pop01_Form_2.xml","url":"basicFormData.do","referenceItem":"C107000070pop01_Form_1","service":"C107000070pop01-service","actionType":"save","security":"true"}' +
//    ']';
var pageConfiguration = '[' + 
'{"itemType":"form","renderTo":"C107000070pop01_Form_1","xml":".\/header\/kr\/C107000070pop01\/C107000070pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C107000070pop01_Form_2","service":"C107000070pop01-service","actionType":"find"},' +
'{"itemType":"messagebox","renderTo":"C107000070pop01_messagebox","xml":".\/header\/kr\/C107000070pop01\/C107000070pop01_messagebox.xml","service":"C107000070pop01-service"},' +
'{"itemType":"form","renderTo":"C107000070pop01_Form_2","xml":".\/header\/kr\/C107000070pop01\/C107000070pop01_Form_2.xml","url":"basicFormData.do","referenceItem":"C107000070pop01_Form_1","service":"C107000070pop01-service","actionType":"find"}' +
']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
  var formObj = items["C107000070pop01_Form_1"].getDhxForm();
  var FNL_CUS_CD = formObj.getItemValue("FNL_CUS_CD");
  var CCL_BOM_NO = formObj.getItemValue("CCL_BOM_NO");
  var PRD_NM_CD = formObj.getItemValue("PRD_NM_CD");
	var findUrl = uiCommon.parameters6("C107000070pop01_Form_1","C107000070pop01_Form_2","find","");
    items["C107000070pop01_Form_2"].loadData(findUrl,findAfter);
}
function findAfter(){
	uiCommon.progressOff(parent);
    var ACTL_CPN_AMT = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("ACTL_CPN_AMT");
    var CMPL_CFM_COIL_WGT = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("CMPL_CFM_COIL_WGT");
    var CCL_BOM_NO = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("CCL_BOM_NO");
    var PRD_NM_FREQ1 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("PRD_NM_FREQ1");
    var PRD_NM_FREQ2 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("PRD_NM_FREQ2");
    var CMPL_SIT_QLT_FREQ1 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("CMPL_SIT_QLT_FREQ1");
    var CMPL_SIT_QLT_FREQ2 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("CMPL_SIT_QLT_FREQ2");
    var ORD_USG_NM_FREQ1 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("ORD_USG_NM_FREQ1");
    var ORD_USG_NM_FREQ2 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("ORD_USG_NM_FREQ2");
    var CUS_CMPL_NO_FREQ1 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("CUS_CMPL_NO_FREQ1");
    var CUS_CMPL_NO_FREQ2 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("CUS_CMPL_NO_FREQ2");
    var CUS_CMPL_NO_FREQ3 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("CUS_CMPL_NO_FREQ3");
    var SAL_END_DD1 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("SAL_END_DD1");
    var SAL_END_DD2 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("SAL_END_DD2");
    var SAL_END_DD3 = items["C107000070pop01_Form_2"].getDhxForm().getItemValue("SAL_END_DD3");
	var formObj  = items['C107000070pop01_Form_2'].getDhxForm();
    // 조회 값이 없으면 모든 항목 없음으로 Setting
    if(ACTL_CPN_AMT==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("ACTL_CPN_AMT","-");
    }
    
    if(CMPL_CFM_COIL_WGT==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("CMPL_CFM_COIL_WGT","-");
    }
    
    if(CCL_BOM_NO==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("CCL_BOM_NO","-");
    }
    
    if(PRD_NM_FREQ1==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("PRD_NM_FREQ1","-");
    }
    
    if(PRD_NM_FREQ2==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("PRD_NM_FREQ2","-");
    }
    
    if(CMPL_SIT_QLT_FREQ1==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("CMPL_SIT_QLT_FREQ1","-");
    }
    
    if(CMPL_SIT_QLT_FREQ2==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("CMPL_SIT_QLT_FREQ2","-");
    }
    
    if(ORD_USG_NM_FREQ1==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("ORD_USG_NM_FREQ1","-");
    }
    
    if(ORD_USG_NM_FREQ2==null){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("ORD_USG_NM_FREQ2","-");
    }
    
    if(CUS_CMPL_NO_FREQ1==""){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("SAL_END_DD1","-");
        formObj.disableItem("CUS_CMPL_DETAIL1");
    }
    
    if(CUS_CMPL_NO_FREQ2==""){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("SAL_END_DD2","-");
        formObj.disableItem("CUS_CMPL_DETAIL2");
    }
    
    if(CUS_CMPL_NO_FREQ3==""){
    	items['C107000070pop01_Form_2'].getDhxForm().setItemValue("SAL_END_DD3","-");
        formObj.disableItem("CUS_CMPL_DETAIL3");
    }
    
	findMessage();
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C107000070pop01_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);	
}
//menu new row event function
function add(referenceItem){
   items[referenceItem].addRow();
}
//menu remove event function
function remove(referenceItem){
    items[referenceItem].removeRow();
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
function onGridContextMenuClick(id,gridObj,menuObj){    
    var isChecked = menuObj.getCheckboxState(id); 
    if("move_grid" == id){
        if(isChecked)
          gridObj.enableColumnMove(true);
        else
          gridObj.enableColumnMove(false);
    }  
  	if("filter_grid" == id){
  		if(isChecked)
         gridObj.enableHeaderMenu();
  	}
  
  	if("editable_grid" == id){
  		if(isChecked)
         gridObj.setEditable(true);
  		else	
  		  gridObj.setEditable(false);
  	}
  	
  	if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
  	}
} 
function findMessage(){
   var uiFormObj = items['C107000070pop01_Form_2'];
   if(uiFormObj.getItemValue("messageBox") == ""){	
	   uiFormObj.clear();
	   uiCommon.message("C107000070pop01_messagebox","0건 조회되었습니다.");
   }else{
	   uiCommon.message("C107000070pop01_messagebox","조회되었습니다.");
   }
  	return true;
}

function onFormLoadFunction(formDivObj){ 
 return true;
}

function onFormLoad1(){
	var POPUPBlOCK_HIDDEN_TP = "<%=POPUPBlOCK_HIDDEN_TP%>";
	var form   = items['C107000070pop01_Form_1'];
	var formDhxObj = form.getDhxForm();
	if(POPUPBlOCK_HIDDEN_TP=="N"){
// 		items["C107000070pop01_Form_1"].showItem("popUpBlock");
		formDhxObj.enableItem("popUpBlock");
	}
	var nowDate = new Date();
	var nowYear = nowDate.getFullYear();
	var nowMonth = nowDate.getMonth()+1;
	var nowDay = nowDate.getDate();
	if(nowMonth<10){nowMonth ="0"+nowMonth;}
	if(nowDay<10){nowDay="0"+nowDay;}
	var todayDate = nowYear+"-"+nowMonth+"-"+nowDay;
	
	
	var yearDate  = nowDate.getTime() - (730*24*60*60*1000);
	nowDate.setTime(yearDate);
	var twoYearsAgoYear = nowDate.getFullYear();
	var twoYearsAgoMonth = nowDate.getMonth() + 1;
	var twoYearsAgoDay = nowDate.getDate();
	if(twoYearsAgoMonth<10){twoYearsAgoMonth="0"+twoYearsAgoMonth;}
	if(twoYearsAgoDay<10){twoYearsAgoDay="0"+twoYearsAgoDay;}
	var twoYearsAgoDate = twoYearsAgoYear+"-"+twoYearsAgoMonth+"-"+twoYearsAgoDay;

	items['C107000070pop01_Form_1'].getDhxForm().setItemValue("SAL_END_DD_FR",twoYearsAgoDate);
	items['C107000070pop01_Form_1'].getDhxForm().setItemValue("SAL_END_DD_TO",todayDate);
	
	var CCL_BOM_NO="<%=CCL_BOM_NO%>";
	var FNL_CUS_CD="<%=FNL_CUS_CD%>";
	var PRD_NM_CD="<%=PRD_NM_CD%>";
	
// 	var CCL_BOM_NO="X2360L";
// 	var ACT_CUS_CD="200430";
	
	if( (CCL_BOM_NO==null || CCL_BOM_NO=="" || typeof(CCL_BOM_NO)=='undefined') && (FNL_CUS_CD==null || FNL_CUS_CD=="" || typeof(FNL_CUS_CD)=='undefined') && (PRD_NM_CD==null || PRD_NM_CD=="" || typeof(PRD_NM_CD)=='undefined') ){
		//skip
	}else{
		items['C107000070pop01_Form_1'].getDhxForm().setItemValue("CCL_BOM_NO",CCL_BOM_NO);
		items['C107000070pop01_Form_1'].getDhxForm().setItemValue("FNL_CUS_CD",FNL_CUS_CD);
		items['C107000070pop01_Form_1'].getDhxForm().setItemValue("PRD_NM_CD",PRD_NM_CD);
	}
	
	var formObj = items['C107000070pop01_Form_1'].getDhxForm();
	items['C107000070pop01_Form_1'].getDhxForm().detachEvent(onXle1);
}

function onFormLoad2(){
// 	var findUrl = uiCommon.parameters6('C107000070pop01_Form_1','C107000070pop01_Form_2','find');
// 	items['C107000070pop01_Form_2'].loadData(findUrl,findAfter);
// 	items['C107000070pop01_Form_2'].getDhxForm().detachEvent(onXle2);
// 	  var frmUrl = window.location.href;
// 	  var varCut = frmUrl.indexOf("?");
// 	   var varCheck = frmUrl.substring(varCut + 1, frmUrl.length);
	             
	             
// 	   var _dhxForm = items['C107000070pop01_Form_2'].getDhxForm();
	  var findUrl = uiCommon.parameters6('C107000070pop01_Form_1','C107000070pop01_Form_2','find');
	  items['C107000070pop01_Form_2'].loadData(findUrl,findAfter);
	  items['C107000070pop01_Form_2'].getDhxForm().detachEvent(onXle2);
	  
	// 사무,현장별 상세보기 기능 항목 제어
	  if("<%=ctl_tp%>" == '1'){
		// 사무직은 상세보기 버튼활성화
	  } else if("<%=ctl_tp%>" == '2'){
		// 현장직은 상세보기 비활성화
		var formObj  = items['C107000070pop01_Form_2'].getDhxForm();
	        formObj.disableItem("CUS_CMPL_DETAIL1");
	        formObj.disableItem("CUS_CMPL_DETAIL2");
	        formObj.disableItem("CUS_CMPL_DETAIL3");
	  }
}

// 2시간동안 팝업차단
function setCookie(name, value, expiredays) {
	parent.document.cookie = escape(name) + "=" + escape(value) + "; expires=" + expiredays.toUTCString();
}

function popUpBlock(){
	var expiredays=new Date();
	expiredays.setTime(expiredays.getTime()+2*60*60*1000);
// 	expiredays.setTime(expiredays.getTime()+60*1000);
    setCookie("popupYN", "N", expiredays);
    parent.winPop.winClose();
}

function CUS_CMPL_DETAIL1(){
	  var formObj2 = items["C107000070pop01_Form_2"].getDhxForm();
	  var CUS_CMPL_DETATIL = formObj2.getItemValue("CUS_CMPL_NO_FREQ1");
	  var DETAIL_ARRAY = CUS_CMPL_DETATIL.split('-');
	  var CUS_CMPL_NO = DETAIL_ARRAY[0];
	  var CUS_CMPL_LN = DETAIL_ARRAY[1];
	  parent.parentPop(CUS_CMPL_NO,CUS_CMPL_LN);
}

function CUS_CMPL_DETAIL2(){
	 var formObj2 = items["C107000070pop01_Form_2"].getDhxForm();
	 var CUS_CMPL_DETATIL = formObj2.getItemValue("CUS_CMPL_NO_FREQ2");
	 var DETAIL_ARRAY = CUS_CMPL_DETATIL.split('-');
	 var CUS_CMPL_NO = DETAIL_ARRAY[0];
	 var CUS_CMPL_LN = DETAIL_ARRAY[1];
	 parent.parentPop(CUS_CMPL_NO,CUS_CMPL_LN);
}

function CUS_CMPL_DETAIL3(){
	 var formObj2 = items["C107000070pop01_Form_2"].getDhxForm();
	 var CUS_CMPL_DETATIL = formObj2.getItemValue("CUS_CMPL_NO_FREQ3");
	 var DETAIL_ARRAY = CUS_CMPL_DETATIL.split('-');
	 var CUS_CMPL_NO = DETAIL_ARRAY[0];
	 var CUS_CMPL_LN = DETAIL_ARRAY[1];
	 parent.parentPop(CUS_CMPL_NO,CUS_CMPL_LN);
}
-->
</script>
</head>
<body>
<div id="C107000070pop01_Form_1" style="position:absolute;height:30px;width:600px;left:0px;top:0px;">
</div>
<div id="C107000070pop01_Form_2" style="position:absolute;height:380px;width:600px;left:0px;top:30px;">
</div>
<div id="C107000070pop01_messagebox" style="position:absolute;height:23px;width:600px;left:0px;top:410px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXle1=items['C107000070pop01_Form_1'].onXLEEvent(onFormLoad1);
	var onXle2=items['C107000070pop01_Form_2'].onXLEEvent(onFormLoad2);
//]]>
-->
</script>