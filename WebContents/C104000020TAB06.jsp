<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB06.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-전기도금
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.12.02
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.12.02     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<style media="screen" type="text/css">
.form_cell{
  background-image:url(./dhtmlx/codebase/imgs/clouds_grid.gif);
  /*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
  border-color:#FDFDFD #BABABA #BABABA #FDFDFD !important;  
  border-style:solid !important;
  border-width:1px !important;
 }
.form_cell1{
 background-image:url(./dhtmlx/codebase/imgs/sky_blue_grid.gif);
 /*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
 border-color:#FDFDFD #BABABA #BABABA #FDFDFD !important;  
 border-style:solid !important;
 border-width:1px !important;
}
 div.gridbox_dhx_skyblue .odd_dhx_skyblue{background-color:#FFFFFF;}
</style>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_1","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Grid_1","service":"C104000020TAB06-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_2","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_2.xml","rowCnt":"3","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Grid_2","service":"C104000020TAB06-service","actionType":"save"},' +
      '{"itemType":"form","renderTo":"C104000020TAB06_Form_1","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020TAB06_Form_1","service":"C104000020TAB06-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_3","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_3.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Grid_1","service":"C104000020TAB06-service","actionType":"save"},' +
	  '{"itemType":"form","renderTo":"C104000020TAB06_Form_2","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Form_2.xml","url":"basicGridData.do","referenceItem":"C104000020TAB06_Form_2","service":"C104000020TAB06-service","actionType":"find"},' +	  	        
      '{"itemType":"form","renderTo":"C104000020TAB06_Form_3","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Form_3.xml","url":"basicGridData.do","referenceItem":"C104000020TAB06_Form_3","service":"C104000020TAB06-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_4","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_4.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Grid_1","service":"C104000020TAB06-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_5","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_5.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Form_1","service":"C104000020TAB06-service","actionType":"save"},' +
	  '{"itemType":"form","renderTo":"C104000020TAB06_Form_4","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Form_4.xml","url":"basicGridData.do","referenceItem":"C104000020TAB06_Form_4","service":"C104000020TAB06-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_6","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_6.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Grid_1","service":"C104000020TAB06-service","actionType":"save"},' +
	  '{"itemType":"form","renderTo":"C104000020TAB06_Form_5","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Form_5.xml","url":"basicGridData.do","referenceItem":"C104000020TAB06_Form_5","service":"C104000020TAB06-service","actionType":"find"},' +
      '{"itemType":"messagebox","renderTo":"C104000020TAB06_messagebox","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_messagebox.xml","service":"C104000020TAB06-service"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_7","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_7.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Grid_1","service":"C104000020TAB06-service","actionType":"save"},' +
	  '{"itemType":"form","renderTo":"C104000020TAB06_Form_6","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Form_6.xml","url":"basicGridData.do","referenceItem":"C104000020TAB06_Form_6","service":"C104000020TAB06-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB06_Grid_8","xml":".\/header\/kr\/C104000020TAB06\/C104000020TAB06_Grid_8.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB06_Form_1","service":"C104000020TAB06-service","actionType":"save"}' +      
   ']';
var initConfig = JSON.parse(pageConfiguration);	     

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

var fg_grid3_update = "N";

var rmtlKind = "";


//form find button item event function (requred)
function find(eventName){
	// 원자재 조회 
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(isNull(parentForm.getItemValue("ORD_NO"))){
		alert("주문번호를 입력해주세요.");
		parentForm.setItemFocus("ORD_NO");
		return;	
	}else if(isNull(comboList.getSelectedValue())){
		alert("주문행번를 선택해주세요.");
		comboList.DOMelem_input.focus();
		return;	
	}else{
		upt_clear();
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB06_Grid_2','RMT_find'); 
		items['C104000020TAB06_Grid_2'].loadData(findUrl,findMessage);		
	}	
	fg_grid3_update = "N";
}
function onGridContextMenuClick(id,gridObj,menuObj){  	
    var isChecked = menuObj.getCheckboxState(id);    
    if("copy_row" == id){
         var rowId=gridObj.getSelectedRowId();
         var cellInd=gridObj.getSelectedCellIndex();
        if(rowId !== null){
           gridObj.cellToClipboard(rowId, cellInd);
        }
    }  	
    if("excel_grid" == id){
     	gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
    }
}
function save(eventName,formDivObj,referenceItem){
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	
	var gridObj11 = items['C104000020TAB06_Grid_2'].getDhxGrid();
	var row_status11 = "";
	var row_status12 = "";
	var row_status17 = "";
	for(var i=0; i< 3; i++){
		gridObj11.selectRow(gridObj11.getRowIndex(gridObj11.getRowId(i)));
		row_status11 = gridObj11.getUserData(gridObj11.getRowId(i),"!nativeeditor_status");
		if(row_status11 != "" && row_status11 == "updated" ){
		    break;
		}
	}
	if( row_status11 == "" )
    {
		var gridObj12 = items['C104000020TAB06_Grid_3'].getDhxGrid();
		gridObj12.selectRow(gridObj12.getRowIndex(gridObj12.getRowId(0)));
		row_status12 = gridObj12.getUserData(gridObj12.getRowId(0),"!nativeeditor_status");
    }

    if(row_status11 != "")
    {   	
		var param1= "ServiceName=C104000020TAB06-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		if(cells1.length > 0){						
			alert("확정된 주문입니다!");
			return;					
		}
    }
    
	if(row_status12 != "" && fg_grid3_update == "N")
    {   	
    	var param1= "ServiceName=C104000020TAB06-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
    	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
    	var cells1 = xmlObj1.getElementsByTagName("cell");
    	
    	if(cells1.length > 0){						
    		alert("확정된 주문입니다!");
    		return;					
    	} 
    }

	if( row_status11 == "" && row_status12 == "" )
    {
		var gridObj18 = items['C104000020TAB06_Grid_8'].getDhxGrid();
		gridObj18.selectRow(gridObj18.getRowIndex(gridObj18.getRowId(0)));

		row_status17 = gridObj18.getUserData(gridObj18.getRowId(0),"!nativeeditor_status");
		if( row_status17 == "" ){
			alert("변경된 데이터가 없습니다.");
			return;
		}
    }
	
	//PL ST폭 값을 지울경우 해당 통과공정이 있으면 삭제불가
	//제조사양의 작업지시 값이 있는지 여부를 확인
	var gridObj = items['C104000020TAB06_Grid_3'].getDhxGrid();
	var proc_st0 = gridObj.cellByIndex(0,4).getValue(); //주공정
	var proc_st1 = gridObj.cellByIndex(0,5).getValue(); //대체공정1
	var proc_st2 = gridObj.cellByIndex(0,6).getValue(); //대체공정2

	var param_tmp= "ServiceName=C104000020TAB06-service&CMN_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_EXC_WTH,ORD_SLIT_GRP_CNT";
	var xmlObj_tmp = uiCommon.ajaxLoadData('c10AjaxData.do',param_tmp);
	var cells_tmp = xmlObj_tmp.getElementsByTagName("cell");
	
	var ord_exc_wth = cells_tmp.item(0).firstChild.nodeValue;
	var ord_slit_grp_cnt = cells_tmp.item(1).firstChild.nodeValue;
	
	//proc_st0 값이 있는경우만 체크
	if(!isNull(proc_st0)){
		if((ord_slit_grp_cnt == 0) && (parseFloat(ord_exc_wth) > parseFloat(proc_st0)))
		{
			alert("주공정S/T값이 주문폭보다 작습니다");
			return;
		}
	}
	
	//proc_st1 값이 있는경우만 체크
	if(!isNull(proc_st1)){
		if((ord_slit_grp_cnt == 0) && (parseFloat(ord_exc_wth) > parseFloat(proc_st1)))
		{
			alert("대체공정1의 S/T값이 주문폭보다 작습니다");
			return;
		}
	}
	
	//proc_st2 값이 있는경우만 체크(숫자값 비교시 문자열로 들어오는 경우는 숫자로 반드시 변환해야 됨)
	if(!isNull(proc_st2)){
		if((ord_slit_grp_cnt == 0) && (parseFloat(ord_exc_wth) > parseFloat(proc_st2)))
		{
			alert("대체공정2의 S/T값이 주문폭보다 작습니다");
			return;
		}
	}
	
	//ANN Cycle 값을 지울경우 해당 통과공정이 있으면 삭제불가
	//제조사양의 작업지시 값이 있는지 여부를 확인
	var gridObj2 = items['C104000020TAB06_Grid_6'].getDhxGrid();
	var proc_gen = gridObj2.cellByIndex(0,1).getValue();
	var proc_hic = gridObj2.cellByIndex(0,6).getValue();
	
	if(isNull(proc_st1) || isNull(proc_st2)){
		//통과공정의 값을 받아온다
		var param2= "ServiceName=C104000020TAB06-service&PROC_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=SUB_PROC_CD1,SUB_PROC_CD2";
		var xmlObj2 = uiCommon.ajaxLoadData('c10AjaxData.do',param2);
		var cells2 = xmlObj2.getElementsByTagName("cell");
		if(cells2.length > 0){	
			if(isNull(proc_st1)){
				if(!isNull(cells2.item(0).firstChild.nodeValue)) //cells2.item(0) -> 컬럼info의 정보를 말한다
				{
					alert("대체공정1의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
			if(isNull(proc_st2)){
				if(!isNull(cells2.item(1).firstChild.nodeValue))
				{
					alert("대체공정2의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
		}
	}//end if PL ST
	
	if(isNull(proc_gen) || isNull(proc_hic)){
		//통과공정의 값을 받아온다
		var param3= "ServiceName=C104000020TAB06-service&ANN_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=SUB_PROC_CD1,SUB_PROC_CD2";
		var xmlObj3 = uiCommon.ajaxLoadData('c10AjaxData.do',param3);
		var cells3 = xmlObj3.getElementsByTagName("cell");
		if(cells3.length > 0){	
			if(isNull(proc_gen)){
				if(cells3.item(0).firstChild.nodeValue == "43" || cells3.item(1).firstChild.nodeValue == "43" ||
				   cells3.item(0).firstChild.nodeValue == "44" || cells3.item(1).firstChild.nodeValue == "44") //cells3.item(0) -> 컬럼info의 정보를 말한다
				{
					alert("일반ANN의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
			if(isNull(proc_hic)){
				if(cells3.item(0).firstChild.nodeValue == "41" || cells3.item(1).firstChild.nodeValue == "41") //cells3.item(0) -> 컬럼info의 정보를 말한다
				{
					alert("H-C ANN의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
		}
	}//end if ANN
	
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){
				var gridObj = items['C104000020TAB06_Grid_2'].getDhxGrid();
				var row_status = "";
				for(var i=0; i< 3; i++){
					row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
					if(row_status != "" && row_status == "updated" ){
					    break;
					}
				}
				if(row_status != "" && row_status == "updated" )
			    {
				    items['C104000020TAB06_Grid_2'].sendGrid('C104000020TAB06_Grid_2',"RMT_save");					
			    }
				else
			    {
					var gridObj1 = items['C104000020TAB06_Grid_3'].getDhxGrid();
					var row_status1 = gridObj1.getUserData(gridObj1.getRowId(0),"!nativeeditor_status");
					if(row_status1 != "" && row_status1 == "updated" )
			        {
					    items['C104000020TAB06_Grid_3'].sendGrid('C104000020TAB06_Grid_3',"MNF_save");
					    fg_grid3_update = "N";
			        }
					else
				    {
						var gridObj2 = items['C104000020TAB06_Grid_8'].getDhxGrid();
						var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
						if(row_status2 != "" && row_status2 == "updated" )
						    items['C104000020TAB06_Grid_8'].sendGrid('C104000020TAB06_Grid_8',"MSG_save");
				    }
			    }
				return;
			}
		}
	}); 
}
function onRowSelect_Grid1(id,ind){ 
       items['C104000020TAB06_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_7'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid2(id,ind){ 
       items['C104000020TAB06_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_7'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_8'].getDhxGrid().clearSelection();		
}
function onRowSelect_Grid3(id,ind){ 
       items['C104000020TAB06_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_7'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_8'].getDhxGrid().clearSelection();		
}
function onRowSelect_Grid4(id,ind){ 
       items['C104000020TAB06_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_7'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_8'].getDhxGrid().clearSelection();		
}
function onRowSelect_Grid5(id,ind){ 
       items['C104000020TAB06_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_7'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_8'].getDhxGrid().clearSelection();		
}
function onRowSelect_Grid6(id,ind){ 
       items['C104000020TAB06_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_7'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_8'].getDhxGrid().clearSelection();		
}
function onRowSelect_Grid7(id,ind){ 
       items['C104000020TAB06_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_8'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid8(id,ind){ 
       items['C104000020TAB06_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB06_Grid_7'].getDhxGrid().clearSelection();		
}
function onLoadGrid1 (){
	// 적차선 Header높이 조절
	items["C104000020TAB06_Grid_1"].getDhxGrid().hdr.rows[1].style.height="52px";
	items['C104000020TAB06_Grid_1'].getDhxGrid().detachEvent(onXLEGrid1);
}
function onLoadGrid2 (){	
// 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(!isNull(parentForm.getItemValue("ORD_NO")) && !isNull(comboList.getSelectedValue())){
		var grid =  items['C104000020TAB06_Grid_2'];
	    var gridObj = items['C104000020TAB06_Grid_2'].getDhxGrid();	
        var rmtlcdCombo = gridObj.getColumnCombo(gridObj.getColIndexById('RMTL_CD')); //원자재코드
        rmtlcdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=RMTL_CD&totalValue=&orderBy=value&displayType=all-code");   
		rmtlcdCombo.enableOptionAutoPositioning(true);
		rmtlcdCombo.readonly(true,true);
		rmtlcdCombo.setOptionHeight(140);		
		
        var rmtlgrdCombo = gridObj.getColumnCombo(gridObj.getColIndexById('RMTL_GRD')); //원자재등급
        rmtlgrdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=RMTL_GRD&totalValue=&orderBy=value&displayType=all-code");   
		rmtlgrdCombo.enableOptionAutoPositioning(true);
		rmtlgrdCombo.readonly(true,true);
		rmtlgrdCombo.setOptionHeight(140);		
		
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB06_Grid_2','RMT_find'); 
		items['C104000020TAB06_Grid_2'].loadData(findUrl,findMessage);	
		
	}
	items['C104000020TAB06_Grid_2'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent1);
	items['C104000020TAB06_Grid_2'].getDhxGrid().detachEvent(onXLEGrid2);
}
function onGridAfterUpdateFinishEvent1(){
	var gridObj1 = items['C104000020TAB06_Grid_3'].getDhxGrid();
	var row_status1 = gridObj1.getUserData(gridObj1.getRowId(0),"!nativeeditor_status");
	if(row_status1 != "" && row_status1 == "updated" )
    {
	    items['C104000020TAB06_Grid_3'].sendGrid('C104000020TAB06_Grid_3',"MNF_save");
    }
	else
    {
		var gridObj2 = items['C104000020TAB06_Grid_8'].getDhxGrid();
		var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
		if(row_status2 != "" && row_status2 == "updated" )
		    items['C104000020TAB06_Grid_8'].sendGrid('C104000020TAB06_Grid_8',"MSG_save");
		else
	    {
			var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB06_Grid_2','RMT_find'); 
			items['C104000020TAB06_Grid_2'].loadData(findUrl,findMessage);		
	    }
    }
}
function onLoadGrid3 (){
	// ECL Header높이 조절
    var grid =  items['C104000020TAB06_Grid_3'];
	var gridObj = items['C104000020TAB06_Grid_3'].getDhxGrid();	
	var pltcm5stdwrtpCombo = gridObj.getColumnCombo(gridObj.getColIndexById('PLTCM_5STD_WR_TP')); //PLTCM5StandWRType
		pltcm5stdwrtpCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PLTCM_5STD_WR_TP&totalValue=&orderBy=value&displayType=all-code");   
		pltcm5stdwrtpCombo.enableOptionAutoPositioning(true);
		pltcm5stdwrtpCombo.readonly(true,true);
		pltcm5stdwrtpCombo.setOptionHeight(80);				
		
	var pltcmslvuseynCombo = gridObj.getColumnCombo(gridObj.getColIndexById('PLTCM_SLV_USE_YN')); //PLTCM내경링사용여부
		pltcmslvuseynCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PLTCM_SLV_USE_YN&totalValue=&orderBy=value&displayType=all-code");   
		pltcmslvuseynCombo.enableOptionAutoPositioning(true);
		pltcmslvuseynCombo.readonly(true,true);
		pltcmslvuseynCombo.setOptionHeight(80);		
	var pltcmedgasgtpCombo = gridObj.getColumnCombo(gridObj.getColIndexById('PLTCM_EDG_ASG_TP')); //PLTCMEdge지정구분
		pltcmedgasgtpCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=CUT_LN_YN&totalValue=&orderBy=value&displayType=all-code");   
		pltcmedgasgtpCombo.enableOptionAutoPositioning(true);
		pltcmedgasgtpCombo.readonly(true,true);
		pltcmedgasgtpCombo.setOptionHeight(60);				
	grid.onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
	items['C104000020TAB06_Grid_3'].getDhxGrid().detachEvent(onXLEGrid3);
}
function onGridAfterUpdateFinishEvent2(){
	var rowID =  items['C104000020TAB06_Grid_4'].getDhxGrid().getRowId(0);
    items['C104000020TAB06_Grid_4'].setUpdated(rowID,false,""); 
    var rowID1 =  items['C104000020TAB06_Grid_5'].getDhxGrid().getRowId(0);
    items['C104000020TAB06_Grid_5'].setUpdated(rowID1,false,"");
	var rowID2 =  items['C104000020TAB06_Grid_6'].getDhxGrid().getRowId(0);
    items['C104000020TAB06_Grid_6'].setUpdated(rowID2,false,""); 
	var rowID3 =  items['C104000020TAB06_Grid_7'].getDhxGrid().getRowId(0);
    items['C104000020TAB06_Grid_7'].setUpdated(rowID3,false,""); 
    
	var gridObj2 = items['C104000020TAB06_Grid_8'].getDhxGrid();
	var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
	if(row_status2 != "" && row_status2 == "updated" )
	    items['C104000020TAB06_Grid_8'].sendGrid('C104000020TAB06_Grid_8',"MSG_save");
	else
    {
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB06_Grid_2','RMT_find'); 
		items['C104000020TAB06_Grid_2'].loadData(findUrl,findMessage);		
    }
}
function onLoadGrid4 (){
    var grid =  items['C104000020TAB06_Grid_4'];
	var gridObj = items['C104000020TAB06_Grid_4'].getDhxGrid();	
	var eclcdrcdCombo = gridObj.getColumnCombo(gridObj.getColIndexById('ECL_CDR_CD')); //ECLC-D방지약품
		eclcdrcdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=ECL_CDR_CD&totalValue=&orderBy=value&displayType=all-code");   
		eclcdrcdCombo.enableOptionAutoPositioning(true);
		eclcdrcdCombo.readonly(true,true);
		eclcdrcdCombo.setOptionHeight(60);			
		eclcdrcdCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB06_Grid_3'].setCellByIndexValue(0,18,eclcdrcdCombo.getSelectedValue());//ECLC-D방지약품
				items['C104000020TAB06_Grid_3'].setUpdated(items['C104000020TAB06_Grid_3'].getDhxGrid().getRowId(0),true,"updated"); 
		});  
		
	var eclcoilgtscdCombo = gridObj.getColumnCombo(gridObj.getColIndexById('ECL_COILG_TS_CD')); //ECL권취장력
		eclcoilgtscdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=ECL_COILG_TS_CD&totalValue=&orderBy=value&displayType=all-code");   
		eclcoilgtscdCombo.enableOptionAutoPositioning(true);
		eclcoilgtscdCombo.readonly(true,true);
		eclcoilgtscdCombo.setOptionHeight(100);		
		eclcoilgtscdCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB06_Grid_3'].setCellByIndexValue(0,19,eclcoilgtscdCombo.getSelectedValue());//ECL권취장력
				items['C104000020TAB06_Grid_3'].setUpdated(items['C104000020TAB06_Grid_3'].getDhxGrid().getRowId(0),true,"updated"); 
		});  
		
	// ECL Header높이 조절
	items["C104000020TAB06_Grid_4"].getDhxGrid().hdr.rows[1].style.height="52px";
	items['C104000020TAB06_Grid_4'].getDhxGrid().detachEvent(onXLEGrid4);
}
function onLoadGrid5 (){
	// ECL Header높이 조절
	items['C104000020TAB06_Grid_5'].getDhxGrid().detachEvent(onXLEGrid5);
}
function onLoadGrid6 (){
    var grid =  items['C104000020TAB06_Grid_6'];
	var gridObj = items['C104000020TAB06_Grid_6'].getDhxGrid();	
	var heatcylnogenannCombo = gridObj.getColumnCombo(gridObj.getColIndexById('HEAT_CYL_NO_GEN_ANN')); //소둔CYCLE
		heatcylnogenannCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SG0000&code=HEAT_CYL_CD&totalValue=&orderBy=value&displayType=all-code");   
		heatcylnogenannCombo.enableOptionAutoPositioning(true);
		heatcylnogenannCombo.readonly(true,true);
		heatcylnogenannCombo.setOptionHeight(140);
		heatcylnogenannCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB06_Grid_3'].setCellByIndexValue(0,31,heatcylnogenannCombo.getSelectedValue());//소둔CYCLE(2CGL)
				items['C104000020TAB06_Grid_3'].setUpdated(items['C104000020TAB06_Grid_3'].getDhxGrid().getRowId(0),true,"updated"); 
		});  
		
	var heatcylnohcannCombo = gridObj.getColumnCombo(gridObj.getColIndexById('HEAT_CYL_NO_HC_ANN')); //ECL권취장력
		heatcylnohcannCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SH0000&code=HEAT_CYL_CD&totalValue=&orderBy=value&displayType=all-code");   
		heatcylnohcannCombo.enableOptionAutoPositioning(true);
		heatcylnohcannCombo.readonly(true,true);
		heatcylnohcannCombo.setOptionHeight(100);
		heatcylnohcannCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB06_Grid_3'].setCellByIndexValue(0,36,heatcylnohcannCombo.getSelectedValue());//소둔CYCLE(2CGL)
				items['C104000020TAB06_Grid_3'].setUpdated(items['C104000020TAB06_Grid_3'].getDhxGrid().getRowId(0),true,"updated"); 
		});  
		
	// ECL Header높이 조절
	items['C104000020TAB06_Grid_6'].getDhxGrid().detachEvent(onXLEGrid5);
}
function onLoadGrid8(){ 
	items["C104000020TAB06_Grid_8"].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent8);
	items["C104000020TAB06_Grid_8"].getDhxGrid().detachEvent(onXLEGrid8);
}
function onGridAfterUpdateFinishEvent8(){
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB06_Grid_2','RMT_find'); 
	items['C104000020TAB06_Grid_2'].loadData(findUrl,findMessage);		
}
//master grid row selected
function deteilFind(rowId,cellIndex){	
	var gridObj = items['C104000020TAB06_Grid_2'];
	var grid =  items['C104000020TAB06_Grid_2'];
	var cellVal = gridObj.getCellValue(rowId,0);
	var qltDsnMnfTp = gridObj.getCellValue(rowId,6);
	/*if(isNull(cellVal)){
		alert("적차선을 선택해 주세요.");
		return;
	}*/
	var customparam = {"QLT_DSN_MNF_TP":qltDsnMnfTp};	
	// 제조표준1 조회 
	var xmlObj;
	var param;
		param = parameters12('C104000020_Form_1','C104000020TAB06_Grid_3','C104000020TAB06-service','MNF_find',customparam);
		xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		
		uiCommon.renderToGrid('C104000020TAB06_Grid_3',xmlObj);  
		uiCommon.renderToGrid('C104000020TAB06_Grid_4',xmlObj);
		uiCommon.renderToGrid('C104000020TAB06_Grid_5',xmlObj);
		uiCommon.renderToGrid('C104000020TAB06_Grid_6',xmlObj);
		uiCommon.renderToGrid('C104000020TAB06_Grid_7',xmlObj);
		
	// 메세지 조회
		param = parameters12('C104000020_Form_1','C104000020TAB06_Grid_8','C104000020TAB06-service','MSG_find',customparam);
		xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB06_Grid_8',xmlObj);	
		upt_clear();
}
function findMessage(referenceItem){	
	uiCommon.progressOff(parent);
	var grid = items['C104000020TAB06_Grid_2'].getDhxGrid();	
//	grid.selectRow(0);//첫행선택
//	deteilFind(grid.getRowId(0));//적정 원자재 조회
    setTimeout(function(){grid.selectRow(0); deteilFind(grid.getRowId(0))},7);//적정 원자재 조회
	document.getElementById("C104000020TAB06_messagebox").innerHTML = "&nbsp;MESSAGE&nbsp;&nbsp;|&nbsp" + grid.getUserData("","appMsg"); //원자재 조회메세지 설정
}
function upt_clear(){
	var grid = items['C104000020TAB06_Grid_2'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid.setUpdated(grid.getDhxGrid().getRowId(1),false,""); 
	grid.setUpdated(grid.getDhxGrid().getRowId(2),false,""); 
	grid = items['C104000020TAB06_Grid_3'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB06_Grid_4'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB06_Grid_5'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB06_Grid_6'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB06_Grid_7'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB06_Grid_8'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	fg_grid3_update = "N";
}
function onEditCellEvent2(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB06_Grid_2"];
	var gridObj = items["C104000020TAB06_Grid_2"].getDhxGrid();
	
    rmtlKind = grid.getCellValue(grid.getSelectedRowId(),0);
	  
	if(stage==1){
		if(cInd == 2 || cInd == 3 || cInd == 4 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("두께목표,하한,상한",2,3,true,this.value)){
						if(this.value.length > 5){
							gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;							
						return true;
					}				
				}
			}
		}else if(cInd == 5 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("폭목표",4,1,true,this.value)){
						if(this.value.length > 5){
							gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;							
						return true;
					}				
				}
			}
		}else{
			return true;
		}
	}
   return true;
}
function onEditCellEvent3(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB06_Grid_3"];
	var gridObj = items["C104000020TAB06_Grid_3"].getDhxGrid();
	if(stage==1){
		if(cInd == 9 || cInd == 10 || cInd == 11) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("두께목표,하한,상한",2,3,true,this.value)){
						if(this.value.length > 5){
							gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;							
						return true;
					}				
				}
			}
		}else if( cInd == 4 || cInd == 5 || cInd == 6 || cInd == 12 || cInd == 13 || cInd == 14 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("폭수치",4,1,true,this.value)){
						if(this.value.length > 5){
							gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;							
						return true;
					}				
				}
			}
		}else{
			return true;
		}
	}else if(stage==2){
		var parentForm = parent.items['C104000020_Form_1'];
		var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
		var ord_no = parentForm.getItemValue("ORD_NO");
		var param1= "ServiceName=C104000020TAB08-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		
		if(cInd == 5 || cInd == 6 || cInd == 13 || cInd == 14){
			if(cells1.length > 0){	
			    if( oValue != "" && oValue != 0){
					alert("확정된 주문을 삭제/수정 할 수 없습니다! 대체공정 추가에 따른 수정은 가능.");
				    grid.setUpdated(rId, false, "")
				    return false;
			    }else{
					var param2= "ServiceName=C104000020TAB06-service&PROC_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=SUB_PROC_CD1,SUB_PROC_CD2";
					var xmlObj2 = uiCommon.ajaxLoadData('c10AjaxData.do',param2);
					var cells2 = xmlObj2.getElementsByTagName("cell");
					if(cells2.length > 0){	
						if(cInd == 5 || cInd == 13){
							if(isNull(cells2.item(0).firstChild.nodeValue)){ //cells2.item(0) -> 컬럼info의 정보를 말한다
								alert("도금 대체공정1이 없습니다.!");
							    grid.setUpdated(rId, false, "")
							    return false;
							}
							fg_grid2_update	= "Y";
						}else{
							if(isNull(cells2.item(1).firstChild.nodeValue)){
								alert("도금 대체공정2가 없습니다.!");
							    grid.setUpdated(rId, false, "")
							    return false;
							}
							fg_grid3_update	= "Y";
						}
					}else{
						alert("통과공정에 도금공정이 없습니다.!");
					    grid.setUpdated(rId, false, "")
					    return false;
					}			    	
			    }				
			}
		}else{
			if(cells1.length > 0){	
			    alert("확정된 주문을 수정할 수 없습니다! 대체공정 추가에 따른 수정은 가능.");
				grid.setUpdated(rId, false, "")
			    return false;
			}
		}
		
		var max = grid.getCellValue(rId,11);
		var min = grid.getCellValue(rId,10);
		var thk = grid.getCellValue(rId,9);
		if(cInd == 9 && !isNull(nValue)) {
			if(nValue > max || nValue < min)
			{
				alert("두께 범위를 벗어났습니다!");
				grid.setCellValue(rId,9,oValue);			
			}
			else
		    {
				var idx = nValue.indexOf(".");
				if(idx != -1){
					var value1 = nValue.substring( 0, idx );
					var value2 = nValue.substring( idx+1, nValue.length);
					if ( value2.length > 2 ){
						var subValue = value2.substring( 2, 3 );
						if ( subValue == "1" || subValue == "2"){
							var finishVal = value1+"."+value2.substring( 0, 2 )+"0";
							grid.setCellValue(rId,3,finishVal);
						}else if ( subValue == "3" || subValue == "4" || subValue == "6" || subValue == "7"){
							var finishVal2 = value1+"."+value2.substring( 0, 2 )+"5";
							grid.setCellValue(rId,3,finishVal2);
						}else if ( subValue == "8" || subValue == "9"){
							var finishVal3 = parseFloat(value1+"."+value2.substring( 0, 2 )) + 0.01;
							grid.setCellValue(rId,3,finishVal3);
						}                      
						else
							grid.setCellValue(rId,3,nValue);				
					}
					else grid.setCellValue(rId,3,nValue);
				}
				else grid.setCellValue(rId,3,nValue);				
		    }
		}else if(cInd == 9 && isNull(nValue)) {
			alert("두께 범위를 벗어났습니다!");
			grid.setCellValue(rId,7,oValue);		
		}else if( (cInd == 10 || cInd == 11) && !isNull(nValue)) {
			if(thk > max || thk < min)
			{
				alert("두께 범위를 벗어났습니다!");
				grid.setCellValue(rId,cInd,oValue);		
			}
		}else if( (cInd == 10 || cInd == 11) && isNull(nValue)) {
			alert("두께 범위를 벗어났습니다!");
			grid.setCellValue(rId,cInd,oValue);		
		}else{
			return true;
		}	
	}
   return true;
}
function onEditCellEvent5(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB06_Grid_5"];
	var gridObj = items["C104000020TAB06_Grid_5"].getDhxGrid();
	
	var grid2 = items["C104000020TAB06_Grid_3"];
	var gridObj2 = items["C104000020TAB06_Grid_3"].getDhxGrid();
	var rowIndex = gridObj.getRowId(rId);
	var rowIndex2 = gridObj2.getRowId(0);
	if(stage==1){
		if(cInd == 0 ){ 
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("Pass수",1,0,false,this.value)){
						if(this.value.length > 1){
							gridObj.editor.obj.value = this.value.substring(0,1);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;						
						return true;
					}	
				}
			}
		}else if(cInd == 1 || cInd == 2){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("ST",1,2,true,this.value)){
							if(this.value.length > 3){
								gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;							
							return true;
						}						
					}
				}
		}else if(cInd == 3 || cInd == 4){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("PPI하한,상한",3,0,false,this.value)){
							if(this.value.length > 3){
							gridObj.editor.obj.value = this.value.substring(0,3);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;
							return true;
						}						
					}
				}
		}else if(cInd >= 7){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("폭목표",4,1,true,this.value)){
							if(this.value.length > 5){
								gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;							
							return true;
						}						
					}
				}
		}else{
			return true;
		}
	}else if(stage==2){
		var parentForm = parent.items['C104000020_Form_1'];
		var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
		var ord_no = parentForm.getItemValue("ORD_NO");
		var param1= "ServiceName=C104000020TAB08-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		if(cells1.length > 0){	
		    alert("확정된 주문은 수정할 수 없습니다!");
			grid.setUpdated(rId, false, "")
		    return false;
		}

		if(isNull(nValue)){
			if(cInd == 0){ 
				grid2.setCellByIndexValue(0,20,"");//Pass수
			}else if(cInd == 1){ 
				grid2.setCellByIndexValue(0,21,"");//조도RA하한값
			}else if(cInd == 2){ 						
				grid2.setCellByIndexValue(0,22,"");//조도RA상한값
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,23,"");//조도PPI하한값
			}else if(cInd == 4){ 
				grid2.setCellByIndexValue(0,24,"");//조도PPI상한값
			}else if(cInd == 7){ 						
				grid2.setCellByIndexValue(0,27,"");//TM폭목표값
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,28,"");//TM폭대체공정1목표값
			}else if(cInd == 9){ 
				grid2.setCellByIndexValue(0,29,"");//TM폭대체공정2목표값
			}
		}else{
			if(cInd == 0){ 
				grid2.setCellByIndexValue(0,20,nValue);//Pass수
			}else if(cInd == 1){ 
				grid2.setCellByIndexValue(0,21,nValue);//조도RA하한값
			}else if(cInd == 2){ 						
				grid2.setCellByIndexValue(0,22,nValue);//조도RA상한값
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,23,nValue);//조도PPI하한값
			}else if(cInd == 4){ 
				grid2.setCellByIndexValue(0,24,nValue);//조도PPI상한값
			}else if(cInd == 7){ 						
				grid2.setCellByIndexValue(0,27,nValue);//TM폭목표값
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,28,nValue);//TM폭대체공정1목표값
			}else if(cInd == 9){ 
				grid2.setCellByIndexValue(0,29,nValue);//TM폭대체공정2목표값
			}
		}
		grid2.setUpdated(grid2.getDhxGrid().getRowId(0),true,"updated"); 
		return true;
	
	}
   return true;
}
function onEditCellEvent6(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB06_Grid_6"];
	var gridObj = items["C104000020TAB06_Grid_6"].getDhxGrid();
	
	var grid2 = items["C104000020TAB06_Grid_3"];
	var gridObj2 = items["C104000020TAB06_Grid_3"].getDhxGrid();
	var rowIndex = gridObj.getRowId(rId);
	if(stage==1){
		if(cInd == 2 || cInd == 7){ 
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("보정시간",2,0,false,this.value)){
						if(this.value.length > 2){
							gridObj.editor.obj.value = this.value.substring(0,2);
						}else{
							gridObj.editor.obj.value = "";
						}
						return true;
					}else{
						gridObj.editor.obj.value = this.value;						
						return true;
					}	
				}
			}
		}else if(cInd == 3 || cInd == 4 || cInd == 8 || cInd == 9){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("코일온도,냉각온도",3,0,false,this.value)){
							if(this.value.length > 3){
							gridObj.editor.obj.value = this.value.substring(0,3);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;						
							return true;
						}						
					}
				}
		}else{
			return true;
		}
	}else if(stage==2){
		var parentForm = parent.items['C104000020_Form_1'];
		var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
		var ord_no = parentForm.getItemValue("ORD_NO");
		var param1= "ServiceName=C104000020TAB08-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		if(cells1.length > 0){	
		    alert("확정된 주문은 수정할 수 없습니다!");
			grid.setUpdated(rId, false, "")
		    return false;
		}

		if(isNull(nValue)){
			if(cInd == 2){ 
				grid2.setCellByIndexValue(0,32,"");//일반ANN소둔보정시간
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,33,"");//일반ANN코일온도
			}else if(cInd == 4){ 						
				grid2.setCellByIndexValue(0,34,"");//일반ANN냉각종료온도
			}else if(cInd == 7){ 
				grid2.setCellByIndexValue(0,37,"");//HCANN소둔보정시간
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,38,"");//HCANN코일온도
			}else if(cInd == 9){ 
				grid2.setCellByIndexValue(0,39,"");//HCANN냉각종료온도
			}
		}else{
			if(cInd == 2){ 
				grid2.setCellByIndexValue(0,32,nValue);//일반ANN소둔보정시간
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,33,nValue);//일반ANN코일온도
			}else if(cInd == 4){ 						
				grid2.setCellByIndexValue(0,34,nValue);//일반ANN냉각종료온도
			}else if(cInd == 7){ 
				grid2.setCellByIndexValue(0,37,nValue);//HCANN소둔보정시간
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,38,nValue);//HCANN코일온도
			}else if(cInd == 9){ 
				grid2.setCellByIndexValue(0,39,nValue);//HCANN냉각종료온도
			}
		}
		grid2.setUpdated(grid2.getDhxGrid().getRowId(0),true,"updated"); 
		return true;
	
	}
   return true;
}
function onEditCellEvent7(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB06_Grid_7"];
	var gridObj = items["C104000020TAB06_Grid_7"].getDhxGrid();
	
	var grid2 = items["C104000020TAB06_Grid_3"];
	var gridObj2 = items["C104000020TAB06_Grid_3"].getDhxGrid();
	var rowIndex = gridObj.getRowId(rId);
	if(stage==1){
		if(cInd <= 4){ 
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("작업도금량 전면하한,전면상한,후면하한,후면상한,도금량 목표",3,1,true,this.value)){
						gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
						return true;
					}	
				}
			}
		}else if(cInd == 5){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("도금량 두께",3,0,false,this.value)){
							if(this.value.length > 3){
							gridObj.editor.obj.value = this.value.substring(0,3);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;						
							return true;
						}						
					}
				}
		}else if(cInd == 7){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("목표Size 두께",2,3,true,this.value)){
							if(this.value.length > 5){
								gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;							
							return true;
						}						
					}
				}
		}else if(cInd == 8){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("목표Size 폭",4,1,true,this.value)){
							if(this.value.length > 5){
								gridObj.editor.obj.value = this.value.substring(0,this.value.length-1);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;							
							return true;
						}						
					}
				}
		}else{
			return true;
		}
	}else if(stage==2){
		var parentForm = parent.items['C104000020_Form_1'];
		var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
		var ord_no = parentForm.getItemValue("ORD_NO");
		var param1= "ServiceName=C104000020TAB08-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		if(cells1.length > 0){	
		    alert("확정된 주문은 수정할 수 없습니다!");
			grid.setUpdated(rId, false, "")
		    return false;
		}

		if(isNull(nValue)){
			if(cInd == 0){ 
				grid2.setCellByIndexValue(0,41,"");//일반ANN소둔보정시간
			}else if(cInd == 1){ 
				grid2.setCellByIndexValue(0,42,"");//일반ANN코일온도
			}else if(cInd == 2){ 						
				grid2.setCellByIndexValue(0,43,"");//일반ANN냉각종료온도
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,44,"");//HCANN소둔보정시간
			}else if(cInd == 4){ 
				grid2.setCellByIndexValue(0,45,"");//HCANN코일온도
			}else if(cInd == 5){ 
				grid2.setCellByIndexValue(0,46,"");//HCANN냉각종료온도
			}else if(cInd == 7){ 
				grid2.setCellByIndexValue(0,48,"");//HCANN냉각종료온도
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,49,"");//HCANN냉각종료온도
			}
		}else{
			if(cInd == 0){ 
				grid2.setCellByIndexValue(0,41,nValue);//일반ANN소둔보정시간
			}else if(cInd == 1){ 
				grid2.setCellByIndexValue(0,42,nValue);//일반ANN코일온도
			}else if(cInd == 2){ 						
				grid2.setCellByIndexValue(0,43,nValue);//일반ANN냉각종료온도
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,44,nValue);//HCANN소둔보정시간
			}else if(cInd == 4){ 
				grid2.setCellByIndexValue(0,45,nValue);//HCANN코일온도
			}else if(cInd == 5){ 
				grid2.setCellByIndexValue(0,46,nValue);//HCANN냉각종료온도
			}else if(cInd == 7){ 
				grid2.setCellByIndexValue(0,48,nValue);//HCANN냉각종료온도
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,49,nValue);//HCANN냉각종료온도
			}
		}
		grid2.setUpdated(grid2.getDhxGrid().getRowId(0),true,"updated"); 
		return true;
	
	}
   return true;
}

function simul(){
	var rmtlknd = items["C104000020TAB06_Grid_2"].getCellValue(items["C104000020TAB06_Grid_2"].getSelectedRowId(),0);
	if(isNull(rmtlknd)){
	
	var vrmtlKnd = rmtlKind;
		}
	else{
	
	var vrmtlKnd = rmtlknd;
	}
	
	if(isNull(vrmtlKnd)){
		alert("적차선을 선택한 후에 조회 하시기 바랍니다.");
	}
	else{
	
		var vstWth    = items["C104000020TAB06_Grid_3"].getCellValue(items["C104000020TAB06_Grid_3"].getDhxGrid().getRowId(0),4);
		var vpltcmThk = items["C104000020TAB06_Grid_3"].getCellValue(items["C104000020TAB06_Grid_3"].getDhxGrid().getRowId(0),9);
	
		winObj = new ui.window('popup','폭수축 및 시뮬레이션','0','0','570','405','C104000020POP02.jsp?RMTL_KND='+vrmtlKnd+'&ST_WHT='+vstWth+'&PLTCM_THK='+vpltcmThk);
		winObj.setModal();
	}
}
//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB06_Grid_1" style="position:absolute;height:118px;width:116px;left:1px;top:0px;">
</div>
<div id="C104000020TAB06_Grid_2" style="position:absolute;height:118px;width:840px;left:118px;top:0px;">
</div>
<div id="C104000020TAB06_Form_1" style="position:absolute;height:25px;width:958px;left:1px;top:120px;">
</div>
<div id="C104000020TAB06_Grid_3" style="position:absolute;height:74px;width:957px;left:1px;top:146px;">
</div>
<div id="C104000020TAB06_Form_2" style="position:absolute;height:20px;width:195px;left:0px;top:224px;">
</div>
<div id="C104000020TAB06_Grid_4" style="position:absolute;height:74px;width:188px;left:1px;top:245px;">
</div>
<div id="C104000020TAB06_Form_3" style="position:absolute;height:20px;width:768px;left:191px;top:224px;">
</div>
<div id="C104000020TAB06_Grid_5" style="position:absolute;height:74px;width:767px;left:190px;top:245px;">
</div>
<div id="C104000020TAB06_Form_4" style="position:absolute;height:20px;width:958px;left:1px;top:323px;">
</div>
<div id="C104000020TAB06_Grid_6" style="position:absolute;height:36px;width:957px;left:1px;top:344px;">
</div>
<div id="C104000020TAB06_Form_5" style="position:absolute;height:20px;width:958px;left:1px;top:395px;">
</div>
<div id="C104000020TAB06_Grid_7" style="position:absolute;height:74px;width:957px;left:1px;top:415px;">
</div>
<div id="C104000020TAB06_Form_6" style="position:absolute;height:20px;width:958px;left:1px;top:494px;">
</div>
<div id="C104000020TAB06_Grid_8" style="position:absolute;height:50px;width:957px;left:1px;top:515px;">
</div>
<div id="C104000020TAB06_messagebox" style="position:absolute;height:19px;width:957px;left:1px;top:566px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
       items['C104000020TAB06_Form_1'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB06_Form_2'].setBackgroundColor("#FFFFFF");
	   items['C104000020TAB06_Form_3'].setBackgroundColor("#FFFFFF");
	   items['C104000020TAB06_Form_4'].setBackgroundColor("#FFFFFF");
	   items['C104000020TAB06_Form_5'].setBackgroundColor("#FFFFFF");
	   items['C104000020TAB06_Form_6'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB06_Grid_1'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid1);
       items['C104000020TAB06_Grid_2'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid2);
       items['C104000020TAB06_Grid_3'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid3);
       items['C104000020TAB06_Grid_4'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid4);
       items['C104000020TAB06_Grid_5'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid5);
       items['C104000020TAB06_Grid_6'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid6);
       items['C104000020TAB06_Grid_7'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid7);
       items['C104000020TAB06_Grid_8'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid8);       
	   var onXLEGrid1 = items['C104000020TAB06_Grid_1'].onXLEEvent(onLoadGrid1);	    
	   var onXLEGrid2 = items['C104000020TAB06_Grid_2'].onXLEEvent(onLoadGrid2);
	   var onXLEGrid3 = items['C104000020TAB06_Grid_3'].onXLEEvent(onLoadGrid3);
	   var onXLEGrid4 = items['C104000020TAB06_Grid_4'].onXLEEvent(onLoadGrid4);
	   var onXLEGrid5 = items['C104000020TAB06_Grid_5'].onXLEEvent(onLoadGrid5);
	   var onXLEGrid6 = items['C104000020TAB06_Grid_6'].onXLEEvent(onLoadGrid6);
	   var onXLEGrid8 = items['C104000020TAB06_Grid_8'].onXLEEvent(onLoadGrid8);
	   items["C104000020TAB06_Grid_2"].onEditCellEvent(onEditCellEvent2);
	   items["C104000020TAB06_Grid_3"].onEditCellEvent(onEditCellEvent3);
	   items["C104000020TAB06_Grid_5"].onEditCellEvent(onEditCellEvent5);
	   items["C104000020TAB06_Grid_6"].onEditCellEvent(onEditCellEvent6);
	   items["C104000020TAB06_Grid_7"].onEditCellEvent(onEditCellEvent7);
	   items["C104000020TAB06_Grid_2"].rowSelected(deteilFind);       
//]]>
-->
</script>