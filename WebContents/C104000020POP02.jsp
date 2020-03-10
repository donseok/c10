<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
폭수축 및 시뮬레이션
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000020POP02_Form_1","xml":".\/header\/kr\/C104000020POP02\/C104000020POP02_Form_1.xml","url":"gridC10Data.do","referenceItem":"C104000020POP02_Grid_1","service":"C104000020POP02-service"},' +
      '{"itemType":"grid","renderTo":"C104000020POP02_Grid_1","xml":".\/header\/kr\/C104000020POP02\/C104000020POP02_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020POP02_Form_1","service":"C104000020POP02-service"},' +
      '{"itemType":"grid","renderTo":"C104000020POP02_Grid_2","xml":".\/header\/kr\/C104000020POP02\/C104000020POP02_Grid_2.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020POP02_Form_2","service":"C104000020POP02-service"},' +
      '{"itemType":"messagebox","renderTo":"C104000020POP02_messagebox","xml":".\/header\/kr\/C104000020POP02\/C104000020POP02_messagebox.xml","service":"C104000020POP02-service"},' +
      '{"itemType":"form","renderTo":"C104000020POP02_Form_2","xml":".\/header\/kr\/C104000020POP02\/C104000020POP02_Form_2.xml","url":"gridC10Data.do","referenceItem":"C104000020POP02_Grid_2","service":"C104000020POP02-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}

function simulrate(eventName,formDivObj,referenceItem){
	
	var v_1  = items['C104000020POP02_Form_2'].getItemValue("I_MTL_COIL_THK");
	var v_2  = items['C104000020POP02_Form_2'].getItemValue("I_MTL_COIL_WTH");
	var v_3  = items['C104000020POP02_Form_2'].getItemValue("I_ST_WISH_WTH");
	var v_4  = items['C104000020POP02_Form_2'].getItemValue("I_COMPRESS_THK");
	var v_5  = items['C104000020POP02_Form_2'].getItemValue("I_YP");
	var v_6  = items['C104000020POP02_Form_2'].getItemValue("I_TS");
	var v_7  = items['C104000020POP02_Form_2'].getItemValue("I_EL");
	var v_8  = items['C104000020POP02_Form_2'].getItemValue("I_C");
	var v_9  = items['C104000020POP02_Form_2'].getItemValue("I_SI");
	var v_10  = items['C104000020POP02_Form_2'].getItemValue("I_MN");
	var v_11  = items['C104000020POP02_Form_2'].getItemValue("I_P");
	var v_12  = items['C104000020POP02_Form_2'].getItemValue("I_S");
	
	
	  if (v_1 == null || v_2 == null || v_3 == null || v_4 == null || v_5 == null || v_6 == null || v_7 == null || v_8 == null || v_9 == null || v_10 == null || v_11 == null || v_12 == null){
	    	alert("모든 항목은 필수 항목입니다. ");
	  }
	  else{
    		var findUrl2 = uiCommon.parameters(formDivObj,referenceItem,eventName);
    		items[referenceItem].loadData(findUrl2);
	  }
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
function findMessage(referenceItem){
	uiCommon.message("C104000020POP02_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadEvent(){ 
 	//부모프로그램의 통과공정번호를 팝업창에도 그대로 복사함 
 	items['C104000020POP02_Form_1'].setItemValue("RMTL_KND","<%=request.getParameter("RMTL_KND")%>");
 	items['C104000020POP02_Form_1'].setItemValue("ST_WHT","<%=request.getParameter("ST_WHT")%>"); 
 	items['C104000020POP02_Form_1'].setItemValue("PLTCM_THK","<%=request.getParameter("PLTCM_THK")%>"); 

 	return true;	
}
//]]>
-->
</script>
</head>
<body>
<div id="C104000020POP02_Form_1" style="position:absolute;height:56px;width:550px;left:0px;top:0px;">
</div>
<div id="C104000020POP02_Grid_1" style="position:absolute;height:120px;width:550px;left:0px;top:56px;">
</div>
<div id="C104000020POP02_Form_2" style="position:absolute;height:112px;width:550px;left:0px;top:174px;">
</div>
<div id="C104000020POP02_Grid_2" style="position:absolute;height:48px;width:550px;left:0px;top:286px;">
</div>
<div id="C104000020POP02_messagebox" style="position:absolute;height:19px;width:551px;left:-1px;top:334px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var _onXLEForm = items['C104000020POP02_Form_1'].onXLEEvent(onFormLoadEvent);

//]]>
-->
</script>