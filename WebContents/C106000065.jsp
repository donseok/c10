<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000065.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  CCL-BOM & 칼라코드 조회
 * DESIGNER NAME    :  성낙원                              
 * DEVELOPER NAME   :  성낙원
 * CREATE DATE      :  2016.06.24
 *
 * Date	          Ver       Name       Description
 * ------------     ------     --------  ------------------------
 * 2016.06.24     V1.0     성낙원	 최초작성 
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
코드사용조회
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000065_Form_1","xml":".\/header\/kr\/C106000065\/C106000065_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000065_Grid_1","service":"C106000065-service"},' +
      '{"itemType":"form","renderTo":"C106000065_Form_2","xml":".\/header\/kr\/C106000065\/C106000065_Form_2.xml","url":"basicGridData.do","referenceItem":"C106000065_Grid_1","service":"C106000065-service"},' +
      '{"itemType":"grid","renderTo":"C106000065_Grid_1","xml":".\/header\/kr\/C106000065\/C106000065_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000065_Form_1","service":"C106000065-service"},' +
      '{"itemType":"form","renderTo":"C106000065_Form_3","xml":".\/header\/kr\/C106000065\/C106000065_Form_3.xml","url":"basicGridData.do","referenceItem":"C106000065_Grid_2","service":"C106000065-service"},' +
      '{"itemType":"grid","renderTo":"C106000065_Grid_2","xml":".\/header\/kr\/C106000065\/C106000065_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000065_Form_1","service":"C106000065-service"},' +
      '{"itemType":"messagebox","renderTo":"C106000065_messagebox","xml":".\/header\/kr\/C106000065\/C106000065_messagebox.xml","service":"C106000065-service"}' +
   ']';

var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){

	items['C106000065_Grid_2'].getDhxGrid().clearAll();
	
	var findUrl = uiCommon.parameters('C106000065_Form_1','C106000065_Grid_1','find');
    items["C106000065_Grid_1"].loadData(findUrl);
    
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
  	if("copy_row" == id){
         var rowId=gridObj.getSelectedRowId();
         var cellInd=gridObj.getSelectedCellIndex();
        if(rowId !== null){
           gridObj.cellToClipboard(rowId, cellInd);
        }
    }
}

function findMessage(referenceItem){
	uiCommon.message("C106000065_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}

function onGridLoad1(){
	var gridObj = items['C106000065_Grid_1'].getDhxGrid();

		gridObj.attachEvent("onSelectStateChanged", function(id){
			onRowSelect_Grid1(items['C106000065_Grid_1'].getSelectedRowId());
		}); 
	return true;
}

//grid1의 값을 선택 했을때 grid2의 상세 조회하는 부분 
function onRowSelect_Grid1(id){ 
	var grid1 = items['C106000065_Grid_1'].getDhxGrid();
	
	var p_hue_cd_frn        = grid1.cellById(id,3).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_bak       = grid1.cellById(id,5).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_frn_4cot  = grid1.cellById(id,7).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_frn_3cot  = grid1.cellById(id,9).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_frn_2cot  = grid1.cellById(id,11).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_frn_1cot  = grid1.cellById(id,13).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_bak_1cot = grid1.cellById(id,15).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_bak_2cot = grid1.cellById(id,17).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_bak_3cot = grid1.cellById(id,19).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_bak_4cot = grid1.cellById(id,21).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_lmn       = grid1.cellById(id,23).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var p_hue_cd_sub       = grid1.cellById(id,25).getValue(); // 각각 query 및 grid의 값을 가지고 온다 
	var cParam = {"P_HUE_CD_FRN":p_hue_cd_frn,"P_HUE_CD_BAK":p_hue_cd_bak,"P_HUE_CD_FRN_4COT":p_hue_cd_frn_4cot,"P_HUE_CD_FRN_3COT":p_hue_cd_frn_3cot,"P_HUE_CD_FRN_2COT":p_hue_cd_frn_2cot,"P_HUE_CD_FRN_1COT":p_hue_cd_frn_1cot,"P_HUE_CD_BAK_1COT":p_hue_cd_bak_1cot,"P_HUE_CD_BAK_2COT":p_hue_cd_bak_2cot,"P_HUE_CD_BAK_3COT":p_hue_cd_bak_3cot,"P_HUE_CD_BAK_4COT":p_hue_cd_bak_4cot,"P_HUE_CD_LMN":p_hue_cd_lmn,"P_HUE_CD_SUB":p_hue_cd_sub};
   var uiGridFindActionUrl = uiCommon.parameters('C106000065_Form_3','C106000065_Grid_2','find_clr',cParam);

   items['C106000065_Grid_2'].loadData(uiGridFindActionUrl);
}

//]]>
-->
</script>
</head>
<body>
<div id="C106000065_Form_1" style="position:absolute;height:30px;width:979px;left:0px;top:0px;">
</div>
<div id="C106000065_Form_2" style="position:absolute;height:20px;width:979px;left:0px;top:31px;">
</div>
<div id="C106000065_Grid_1" style="position:absolute;height:200px;width:977px;left:1px;top:52px;">
</div>
<div id="C106000065_Form_3" style="position:absolute;height:20px;width:979px;left:0px;top:253px;">
</div>
<div id="C106000065_Grid_2" style="position:absolute;height:292px;width:977px;left:1px;top:274px;">
</div>
<div id="C106000065_messagebox" style="position:absolute;height:19px;width:979px;left:0px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	items['C106000065_Grid_1'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid1);
	items['C106000065_Grid_1'].onXLEEvent(onGridLoad1);
    
//]]>
-->
</script>