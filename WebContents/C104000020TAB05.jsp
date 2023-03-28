<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB05.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-용융도금
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.11.28
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.11.28     V1.0      박재영      Initial Version
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
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_1","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_1.xml","rowCnt":"3","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB05_Grid_1","service":"C104000020TAB05-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_8","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_8.xml","rowCnt":"0","vertical":"false","url":"handleDataProcess.do","contextmenu":"true","borderline":"false","pageset":"false","split":"0","referenceItem":"C104000020TAB05_Grid_8","service":"C104000020TAB05-service"},' +
      '{"itemType":"form","renderTo":"C104000020TAB05_Form_1","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020TAB05_Form_1","service":"C104000020TAB05-service","security":"true"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_2","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB05_Grid_1","service":"C104000020TAB05-service","actionType":"save"},' +
      '{"itemType":"form","renderTo":"C104000020TAB05_Form_2","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Form_2.xml","url":"basicGridData.do","referenceItem":"C104000020TAB05_Form_1","service":"C104000020TAB05-service"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_3","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_3.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB05_Grid_1","service":"C104000020TAB05-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_4","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_4.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB05_Grid_1","service":"C104000020TAB05-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_5","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_5.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB05_Grid_1","service":"C104000020TAB05-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_6","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_6.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB05_Grid_1","service":"C104000020TAB05-service"},' +
      '{"itemType":"form","renderTo":"C104000020TAB05_Form_3","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Form_3.xml","url":"basicGridData.do","referenceItem":"C104000020TAB05_Form_1","service":"C104000020TAB05-service"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB05_Grid_7","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_Grid_7.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB05_Grid_7","service":"C104000020TAB05-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C104000020TAB05_messagebox","xml":".\/header\/kr\/C104000020TAB05\/C104000020TAB05_messagebox.xml","service":"C104000020TAB05-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var fg_grid2_update = "N";
var rmtlKind = "";
//원재료 두께, 폭 조정 사용자 오류방지
var redflag1 = 0;
var redflag2 = 0;




//form find button item event function (requred)
function find(eventName){
    // 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(isNull(parentForm.getItemValue("ORD_NO"))){
		dhtmlx.alert("주문번호를 입력해주세요.");
		parentForm.setItemFocus("ORD_NO");
		return;	
	}else if(isNull(comboList.getSelectedValue())){
		dhtmlx.alert("주문행번를 선택해주세요.");
		comboList.DOMelem_input.focus();
		return;	
	}else{
		upt_clear();
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB05_Grid_1','RMT_find'); 
		items['C104000020TAB05_Grid_1'].loadData(findUrl,findMessage);		
	}	
	fg_grid2_update = "N";
}
function save(eventName,formDivObj,referenceItem){
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	
	var gridObj11 = items['C104000020TAB05_Grid_1'].getDhxGrid();
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
		var gridObj12 = items['C104000020TAB05_Grid_2'].getDhxGrid();
		gridObj12.selectRow(gridObj12.getRowIndex(gridObj12.getRowId(0)));

		row_status12 = gridObj12.getUserData(gridObj12.getRowId(0),"!nativeeditor_status");
    }
	
	if(row_status11 != "")
    {   	
    	var param1= "ServiceName=C104000020TAB05-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
    	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
    	var cells1 = xmlObj1.getElementsByTagName("cell");
    	
    	if(cells1.length > 0){						
    		dhtmlx.alert("확정된 주문입니다!");
    		return;					
    	} 
    }
	if(row_status12 != "" && fg_grid2_update == "N")
    {   	
    	var param1= "ServiceName=C104000020TAB05-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
    	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
    	var cells1 = xmlObj1.getElementsByTagName("cell");
    	
    	if(cells1.length > 0){						
    		dhtmlx.alert("확정된 주문입니다!");
    		return;					
    	} 
    }

	if( row_status11 == "" && row_status12 == "" )
    {
		var gridObj17 = items['C104000020TAB05_Grid_7'].getDhxGrid();
		gridObj17.selectRow(gridObj17.getRowIndex(gridObj17.getRowId(0)));

		row_status17 = gridObj17.getUserData(gridObj17.getRowId(0),"!nativeeditor_status");
		if( row_status17 == "" ){
			dhtmlx.alert("변경된 데이터가 없습니다.");
			return;
		}
    }
	
	//PL ST폭 값을 지울경우 해당 통과공정이 있으면 삭제불가
	//제조사양의 작업지시 값이 있는지 여부를 확인
	var gridObj = items['C104000020TAB05_Grid_2'].getDhxGrid();
	var proc_st0 = gridObj.cellByIndex(0,4).getValue();  //주공정
	var proc_st1 = gridObj.cellByIndex(0,5).getValue();  //대체공정1
	var proc_st2 = gridObj.cellByIndex(0,6).getValue();  //대체공정2
	
	var param_tmp= "ServiceName=C104000020TAB05-service&CMN_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_EXC_WTH,ORD_SLIT_GRP_CNT";
	var xmlObj_tmp = uiCommon.ajaxLoadData('c10AjaxData.do',param_tmp);
	var cells_tmp = xmlObj_tmp.getElementsByTagName("cell");
	
	var ord_exc_wth = cells_tmp.item(0).firstChild.nodeValue;
	var ord_slit_grp_cnt = cells_tmp.item(1).firstChild.nodeValue;
	
	
	//2022.10.24 여기서부터 확인하면 됨.....(이돈석)
	//proc_st0 값이 있는경우만 체크
	if(!isNull(proc_st0)){
		if((ord_slit_grp_cnt == 0) && (parseFloat(ord_exc_wth) > parseFloat(proc_st0)))
		{
			dhtmlx.alert("주공정S/T값이 주문폭보다 작습니다");
			return;
		}
	}
	
	//proc_st1 값이 있는경우만 체크
	if(!isNull(proc_st1)){
		if((ord_slit_grp_cnt == 0) && (parseFloat(ord_exc_wth) > parseFloat(proc_st1)))
		{
			dhtmlx.alert("대체공정1의 S/T값이 주문폭보다 작습니다");
			return;
		}
	}
	
	//proc_st2 값이 있는경우만 체크(숫자값 비교시 문자열로 들어오는 경우는 숫자로 반드시 변환해야 됨)
	if(!isNull(proc_st2)){
		if((ord_slit_grp_cnt == 0) && (parseFloat(ord_exc_wth) > parseFloat(proc_st2)))
		{
			dhtmlx.alert("대체공정2의 S/T값이 주문폭보다 작습니다");
			return;
		}
	}
	
	//#2,4 CGL값을 지울경우 해당 통과공정이 있으면 삭제불가
	//제조사양의 작업지시 값이 있는지 여부를 확인
	var gridObj2 = items['C104000020TAB05_Grid_3'].getDhxGrid();
	var cgl_proc_st2 = gridObj2.cellByIndex(0,1).getValue();
	var cgl_proc_st4 = gridObj2.cellByIndex(1,1).getValue();
	
	//#3,5 CGL값을 지울경우 해당 통과공정이 있으면 삭제불가
	//제조사양의 작업지시 값이 있는지 여부를 확인
	var gridObj3 = items['C104000020TAB05_Grid_4'].getDhxGrid();
	var cgl_proc_st3 = gridObj3.cellByIndex(0,1).getValue();
	var cgl_proc_st5 = gridObj3.cellByIndex(1,1).getValue();
	/*
	if(isNull(proc_st1) || isNull(proc_st2)){
		//통과공정의 값을 받아온다
		var param2= "ServiceName=C104000020TAB05-service&PROC_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=SUB_PROC_CD1,SUB_PROC_CD2";
		var xmlObj2 = uiCommon.ajaxLoadData('c10AjaxData.do',param2);
		var cells2 = xmlObj2.getElementsByTagName("cell");
		if(cells2.length > 0){	
			if(isNull(proc_st1)){
				if(!isNull(cells2.item(0).firstChild.nodeValue)) //cells2.item(0) -> 컬럼info의 정보를 말한다
				{
					dhtmlx.alert("대체공정1의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
			if(isNull(proc_st2)){
				if(!isNull(cells2.item(1).firstChild.nodeValue))
				{
					dhtmlx.alert("대체공정2의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
		}
	}//end if PL ST..
	*/
	
	/*
	if(isNull(cgl_proc_st2) || isNull(cgl_proc_st3) || isNull(cgl_proc_st4) || isNull(cgl_proc_st5)){
		//통과공정의 값을 받아온다
		var param3= "ServiceName=C104000020TAB05-service&PROC_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=SUB_PROC_CD1,SUB_PROC_CD2";
		var xmlObj3 = uiCommon.ajaxLoadData('c10AjaxData.do',param3);
		var cells3 = xmlObj3.getElementsByTagName("cell");
		
		if(cells3.length > 0){	
			if(isNull(cgl_proc_st2)){
				if(cells3.item(0).firstChild.nodeValue == "82" || cells3.item(1).firstChild.nodeValue == "82") //cells3.item(0) -> 컬럼info의 정보를 말한다
				{
					dhtmlx.alert("2CGL의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
			if(isNull(cgl_proc_st3)){
				if(cells3.item(0).firstChild.nodeValue == "83" || cells3.item(1).firstChild.nodeValue == "83") //cells3.item(0) -> 컬럼info의 정보를 말한다
				{
					dhtmlx.alert("3CGL의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
			if(isNull(cgl_proc_st4)){
				if(cells3.item(0).firstChild.nodeValue == "84" || cells3.item(1).firstChild.nodeValue == "84") //cells3.item(0) -> 컬럼info의 정보를 말한다
				{
					dhtmlx.alert("4CGL의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
			if(isNull(cgl_proc_st5)){
				if(cells3.item(0).firstChild.nodeValue == "85" || cells3.item(1).firstChild.nodeValue == "85") //cells3.item(0) -> 컬럼info의 정보를 말한다
				{
					dhtmlx.alert("5CGL의 통과공정을 먼저 삭제해 주세요!");
					return;
				}
			}
		}
	}//end if CGL ANN..
	*/
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){			
				var gridObj = items['C104000020TAB05_Grid_1'].getDhxGrid();
				var row_status = "";
				for(var i=0; i< 3; i++){
					row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
					if(row_status != "" && row_status == "updated" ){
					    break;
					}
				}
				if(row_status != "" && row_status == "updated" )
			    {
				    items['C104000020TAB05_Grid_1'].sendGrid('C104000020TAB05_Grid_1',"RMT_save");
			    }
				else
			    {
					var gridObj1 = items['C104000020TAB05_Grid_2'].getDhxGrid();
					var row_status1 = gridObj1.getUserData(gridObj1.getRowId(0),"!nativeeditor_status");
					if(row_status1 != "" && row_status1 == "updated" )
			        {
					    items['C104000020TAB05_Grid_2'].sendGrid('C104000020TAB05_Grid_2',"PLTCM_save");
					    fg_grid2_update = "N";
			        }
					else
				    {
						var gridObj2 = items['C104000020TAB05_Grid_7'].getDhxGrid();
						var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
						if(row_status2 != "" && row_status2 == "updated" )
						    items['C104000020TAB05_Grid_7'].sendGrid('C104000020TAB05_Grid_7',"MSG_save");
				    }
			    }
				////
				//parent.find();
				//
				return;
			}
		}
	}); 
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C104000020TAB05_Form_1',referenceItem,'find');
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
function onRowSelect_Grid1(id,ind){ 
       items['C104000020TAB05_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_7'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid2(id,ind){ 
       items['C104000020TAB05_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_7'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid3(id,ind){ 
       items['C104000020TAB05_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_7'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid4(id,ind){ 
       items['C104000020TAB05_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_7'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid5(id,ind){ 
       items['C104000020TAB05_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_7'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid6(id,ind){ 
       items['C104000020TAB05_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_7'].getDhxGrid().clearSelection();	
}
function onRowSelect_Grid7(id,ind){ 
       items['C104000020TAB05_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_6'].getDhxGrid().clearSelection();
}
function onRowSelect_Grid8(id,ind){ 
       items['C104000020TAB05_Grid_1'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_2'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_3'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_4'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_5'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_6'].getDhxGrid().clearSelection();
       items['C104000020TAB05_Grid_7'].getDhxGrid().clearSelection();	
}
function onGridLoadEvent1(){ 
    // 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(!isNull(parentForm.getItemValue("ORD_NO")) && !isNull(comboList.getSelectedValue())){
		var grid1 =  items['C104000020TAB05_Grid_1'];
	    var gridObj1 = items['C104000020TAB05_Grid_1'].getDhxGrid();	
	    
        var rmtlcdCombo = gridObj1.getColumnCombo(gridObj1.getColIndexById('RMTL_CD')); //원자재코드
        rmtlcdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=RMTL_CD&totalValue=&orderBy=value&displayType=all-code");   
		rmtlcdCombo.enableOptionAutoPositioning(true);
		rmtlcdCombo.readonly(true,true);
		rmtlcdCombo.setOptionHeight(200);
		
        var rmtlgrdCombo = gridObj1.getColumnCombo(gridObj1.getColIndexById('RMTL_GRD')); //원자재등급
        rmtlgrdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=RMTL_GRD&totalValue=&orderBy=value&displayType=all-code");   
		rmtlgrdCombo.enableOptionAutoPositioning(true);
		rmtlgrdCombo.readonly(true,true);
		rmtlgrdCombo.setOptionHeight(140);
		
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB05_Grid_1','RMT_find'); 
		items['C104000020TAB05_Grid_1'].loadData(findUrl,findMessage);		
	}
	items['C104000020TAB05_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent1);
	items['C104000020TAB05_Grid_1'].getDhxGrid().detachEvent(_onXLE1);
	
	//var rmtlKnd =items['C104000020TAB05_Grid_1'].getCellValue('xml-result_1',0);
	
}

function onGridAfterUpdateFinishEvent1(){
	var gridObj1 = items['C104000020TAB05_Grid_2'].getDhxGrid();
	var row_status1 = gridObj1.getUserData(gridObj1.getRowId(0),"!nativeeditor_status");
	if(row_status1 != "" && row_status1 == "updated" )
    {
	    items['C104000020TAB05_Grid_2'].sendGrid('C104000020TAB05_Grid_2',"PLTCM_save");
    }
	else
    {
		var gridObj2 = items['C104000020TAB05_Grid_7'].getDhxGrid();
		var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
		if(row_status2 != "" && row_status2 == "updated" )
		    items['C104000020TAB05_Grid_7'].sendGrid('C104000020TAB05_Grid_7',"MSG_save");
		else
	    {
			var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB05_Grid_1','RMT_find'); 
			items['C104000020TAB05_Grid_1'].loadData(findUrl,findMessage);	
	    }
    }
}

function onGridLoadEvent2(){ 
    var grid2 =  items['C104000020TAB05_Grid_2'];
	var gridObj2 = items['C104000020TAB05_Grid_2'].getDhxGrid();	
	var pltcm5stdwrtpCombo = gridObj2.getColumnCombo(gridObj2.getColIndexById('PLTCM_5STD_WR_TP')); //PLTCM5StandWRType
		pltcm5stdwrtpCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PLTCM_5STD_WR_TP&totalValue=&orderBy=value&displayType=all-code");   
		pltcm5stdwrtpCombo.enableOptionAutoPositioning(true);
		pltcm5stdwrtpCombo.readonly(true,true);
		pltcm5stdwrtpCombo.setOptionHeight(80);
		
	var pltcmslvuseynCombo = gridObj2.getColumnCombo(gridObj2.getColIndexById('PLTCM_SLV_USE_YN')); //PLTCM내경링사용여부
		pltcmslvuseynCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PLTCM_SLV_USE_YN&totalValue=&orderBy=value&displayType=all-code");   
		pltcmslvuseynCombo.enableOptionAutoPositioning(true);
		pltcmslvuseynCombo.readonly(true,true);
		pltcmslvuseynCombo.setOptionHeight(80);
		
	var pltcmedgasgtpCombo = gridObj2.getColumnCombo(gridObj2.getColIndexById('PLTCM_EDG_ASG_TP')); //PLTCMEdge지정구분
		pltcmedgasgtpCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=CUT_LN_YN&totalValue=&orderBy=value&displayType=all-code");   
		pltcmedgasgtpCombo.enableOptionAutoPositioning(true);
		pltcmedgasgtpCombo.readonly(true,true);
		pltcmedgasgtpCombo.setOptionHeight(60);
		grid2.onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
		gridObj2.detachEvent(_onXLE2);
}

function onGridAfterUpdateFinishEvent2(){
	var rowID =  items['C104000020TAB05_Grid_3'].getDhxGrid().getRowId(0);
    items['C104000020TAB05_Grid_3'].setUpdated(rowID,false,""); 
    rowID =  items['C104000020TAB05_Grid_3'].getDhxGrid().getRowId(1);
    items['C104000020TAB05_Grid_3'].setUpdated(rowID,false,"");		
    var rowID1 =  items['C104000020TAB05_Grid_4'].getDhxGrid().getRowId(0);
    items['C104000020TAB05_Grid_4'].setUpdated(rowID1,false,"");
    rowID1 =  items['C104000020TAB05_Grid_4'].getDhxGrid().getRowId(1);
    items['C104000020TAB05_Grid_4'].setUpdated(rowID1,false,"");
	var rowID2 =  items['C104000020TAB05_Grid_5'].getDhxGrid().getRowId(0);
    items['C104000020TAB05_Grid_5'].setUpdated(rowID2,false,""); 
	
	var gridObj2 = items['C104000020TAB05_Grid_7'].getDhxGrid();
	var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
	if(row_status2 != "" && row_status2 == "updated" )
	    items['C104000020TAB05_Grid_7'].sendGrid('C104000020TAB05_Grid_7',"MSG_save");
	else
    {
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB05_Grid_1','RMT_find'); 
		items['C104000020TAB05_Grid_1'].loadData(findUrl,findMessage);	
    }
}

function onGridLoadEvent3(){ 
    var grid3 =  items['C104000020TAB05_Grid_3'];
	var gridObj3 = items['C104000020TAB05_Grid_3'].getDhxGrid();	
		
	//var heatcylno2cglCombo = gridObj.getColumnCombo(gridObj.getColIndexById('HEAT_CYL_NO_2CGL')); //소둔CYCLE(2CGL)
	var heatcylno2cglCombo = gridObj3.cells(gridObj3.getRowId(0), 1).getCellCombo();	 //소둔CYCLE(2CGL)
		heatcylno2cglCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SC0000&code=HEAT_CYL_CD&totalValue=&orderBy=value&displayType=all-code");   
		heatcylno2cglCombo.enableOptionAutoPositioning(true);
		heatcylno2cglCombo.readonly(true,true);
		heatcylno2cglCombo.setOptionHeight(140);

		//소둔CYCLE(2CGL)
		heatcylno2cglCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB05_Grid_2'].setCellByIndexValue(0,40,heatcylno2cglCombo.getSelectedValue());//소둔CYCLE(2CGL)
				items['C104000020TAB05_Grid_2'].setUpdated(items['C104000020TAB05_Grid_2'].getDhxGrid().getRowId(0),true,"updated"); 
		});  

	//var heatcylno2cglCombo = gridObj.getColumnCombo(gridObj.getColIndexById('HEAT_CYL_NO_2CGL')); //소둔CYCLE(4CGL)
	var heatcylno4cglCombo = gridObj3.cells(gridObj3.getRowId(1), 1).getCellCombo();	 //소둔CYCLE(4CGL)
		heatcylno4cglCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SC0000&code=HEAT_CYL_CD&totalValue=&orderBy=value&displayType=all-code");   
		heatcylno4cglCombo.enableOptionAutoPositioning(true);
		heatcylno4cglCombo.readonly(true,true);
		heatcylno4cglCombo.setOptionHeight(140);	

		//소둔CYCLE(4CGL)
		heatcylno4cglCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB05_Grid_2'].setCellByIndexValue(0,50,heatcylno4cglCombo.getSelectedValue());//소둔CYCLE(4CGL)
				items['C104000020TAB05_Grid_2'].setUpdated(items['C104000020TAB05_Grid_2'].getDhxGrid().getRowId(0),true,"updated"); 
		});  
		gridObj3.detachEvent(_onXLE3);
}

function onGridLoadEvent4(){ 
    var grid4 =  items['C104000020TAB05_Grid_4'];
	var gridObj4 = items['C104000020TAB05_Grid_4'].getDhxGrid();	
		
	var heatcylno3cglCombo = gridObj4.cells(gridObj4.getRowId(0), 1).getCellCombo();	 //소둔CYCLE(3CGL)
		heatcylno3cglCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SC0000&code=HEAT_CYL_CD&totalValue=&orderBy=value&displayType=all-code");   
		heatcylno3cglCombo.enableOptionAutoPositioning(true);
		heatcylno3cglCombo.readonly(true,true);
		heatcylno3cglCombo.setOptionHeight(140);

		//소둔CYCLE(3CGL)
		heatcylno3cglCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB05_Grid_2'].setCellByIndexValue(0,45,heatcylno3cglCombo.getSelectedValue());//소둔CYCLE(3CGL)
				items['C104000020TAB05_Grid_2'].setUpdated(items['C104000020TAB05_Grid_2'].getDhxGrid().getRowId(0),true,"updated"); 
		});  
	
	var heatcylno5cglCombo = gridObj4.cells(gridObj4.getRowId(1), 1).getCellCombo();	 //소둔CYCLE(5CGL)
		heatcylno5cglCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SC0000&code=HEAT_CYL_CD&totalValue=&orderBy=value&displayType=all-code");   
		heatcylno5cglCombo.enableOptionAutoPositioning(true);
		heatcylno5cglCombo.readonly(true,true);
		heatcylno5cglCombo.setOptionHeight(140);

		//소둔CYCLE(5CGL)
		heatcylno5cglCombo.attachEvent("onSelectionChange", function(){
			items['C104000020TAB05_Grid_2'].setCellByIndexValue(0,55,heatcylno5cglCombo.getSelectedValue());//소둔CYCLE(5CGL)
				items['C104000020TAB05_Grid_2'].setUpdated(items['C104000020TAB05_Grid_2'].getDhxGrid().getRowId(0),true,"updated"); 
		});  

		gridObj4.detachEvent(_onXLE4);       
}

function onGridLoadEvent5(){ 
    var grid =  items['C104000020TAB05_Grid_5'];
	var gridObj = items['C104000020TAB05_Grid_5'].getDhxGrid();	
	var pltcmslvuseynCombo = gridObj.getColumnCombo(gridObj.getColIndexById('CGL_LVL_YN')); //CGLLeveler사용여부
		pltcmslvuseynCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=CGL_LVL_YN&totalValue=&orderBy=value&displayType=all-code");   
		pltcmslvuseynCombo.enableOptionAutoPositioning(true);
		pltcmslvuseynCombo.readonly(true,true);
		pltcmslvuseynCombo.setOptionHeight(80);		
		
		//pltcmslvuseynCombo
		pltcmslvuseynCombo.attachEvent("onSelectionChange", function(){
			var grid2  =  items['C104000020TAB05_Grid_2'];
				grid2.setCellByIndexValue(0,65,pltcmslvuseynCombo.getSelectedValue());//CGLLeveler사용여부
				grid2.setUpdated(grid2.getDhxGrid().getRowId(0),true,"updated"); 
		});  
		gridObj.detachEvent(_onXLE5);  
}

function onGridLoadEvent7(){ 
	items["C104000020TAB05_Grid_7"].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent7);
	items["C104000020TAB05_Grid_7"].getDhxGrid().detachEvent(_onXLE7);
}

function onGridAfterUpdateFinishEvent7(){
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB05_Grid_1','RMT_find'); 
	items['C104000020TAB05_Grid_1'].loadData(findUrl,findMessage);		
}

function onLoadGrid8 (){
	items["C104000020TAB05_Grid_8"].getDhxGrid().hdr.rows[1].style.height="52px";
	items['C104000020TAB05_Grid_8'].getDhxGrid().detachEvent(onXLEGrid8);
}
//master grid row selected
function deteilFind(rowId,cellIndex){	
	var gridObj = items['C104000020TAB05_Grid_1'];
	var grid =  items['C104000020TAB05_Grid_1'];
	var cellVal = gridObj.getCellValue(rowId,0);
	var qltDsnMnfTp = gridObj.getCellValue(rowId,6);
	//if(isNull(cellVal)){
	//	dhtmlx.alert("적차선을 선택해 주세요.");
	//	return;
	//}
	var customparam = {"QLT_DSN_MNF_TP":qltDsnMnfTp};	
	// 제조표준1 조회 
	var xmlObj;
	var param;
		param = parameters12('C104000020_Form_1','C104000020TAB05_Grid_2','C104000020TAB05-service','MNF_find',customparam);
		xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB05_Grid_2',xmlObj);  
				
		
		param = parameters12('C104000020_Form_1','C104000020TAB05_Grid_3','C104000020TAB05-service','MNF_find',customparam);
		xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);		
		uiCommon.renderToGrid('C104000020TAB05_Grid_3',xmlObj);				
		uiCommon.renderToGrid('C104000020TAB05_Grid_4',xmlObj);	
		uiCommon.renderToGrid('C104000020TAB05_Grid_5',xmlObj);		
		uiCommon.renderToGrid('C104000020TAB05_Grid_6',xmlObj);
	// 메세지 조회
		param = parameters12('C104000020_Form_1','C104000020TAB05_Grid_7','C104000020TAB05-service','MSG_find',customparam);
		xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB05_Grid_7',xmlObj);	
		upt_clear();
}
function findMessage(referenceItem){	
	uiCommon.progressOff(parent);
	var grid = items['C104000020TAB05_Grid_1'].getDhxGrid();	
//	grid.selectRow(0);//첫행선택
//	deteilFind(grid.getRowId(0));//적정 원자재 조회
    setTimeout(function(){grid.selectRow(0); deteilFind(grid.getRowId(0))},7);//적정 원자재 조회
	uiCommon.message(ui.messagebox.messageBoxDivId,grid.getUserData("","appMsg"));
	return true;
	//document.getElementById("C104000020TAB05_messagebox").innerHTML = "&nbsp;MESSAGE&nbsp;&nbsp;|&nbsp" + grid.getUserData("","appMsg"); //원자재 조회메세지 설정
}
function upt_clear(){
	/*
	var grid = items['C104000020TAB05_Grid_1'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid.setUpdated(grid.getDhxGrid().getRowId(1),false,""); 
	grid.setUpdated(grid.getDhxGrid().getRowId(2),false,""); 
	grid = items['C104000020TAB05_Grid_2'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB05_Grid_3'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid.setUpdated(grid.getDhxGrid().getRowId(1),false,""); 
	grid = items['C104000020TAB05_Grid_4'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid.setUpdated(grid.getDhxGrid().getRowId(1),false,""); 
	grid = items['C104000020TAB05_Grid_5'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB05_Grid_7'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	fg_grid2_update = "N";
	*/
	var grid = items["C104000020TAB05_Grid_1"];
	var gridObj = items["C104000020TAB05_Grid_1"].getDhxGrid();

	grid = items['C104000020TAB05_Grid_2'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,"");
	grid = items['C104000020TAB05_Grid_3'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,"");
	grid.setUpdated(grid.getDhxGrid().getRowId(1),false,"");
	grid = items['C104000020TAB05_Grid_4'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,"");
	grid.setUpdated(grid.getDhxGrid().getRowId(1),false,"");
	grid = items['C104000020TAB05_Grid_5'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,"");
	grid = items['C104000020TAB05_Grid_7'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,"");
	fg_grid2_update = "N";
	
	if(redflag2 ==1){
	  gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_WTH"),"background:red");
	}
	if(redflag1 ==1){
	  gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_THK"),"background:red");
	}
}

function onEditCellEvent1(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB05_Grid_1"];
	var gridObj = items["C104000020TAB05_Grid_1"].getDhxGrid();
	
	var rmtlKind = grid.getCellValue(grid.getSelectedRowId(),0);
	var Rmtltarthk = grid.getCellValue(grid.getSelectedRowId(),2);
	var Thklvl = grid.getCellValue(grid.getSelectedRowId(),3);
	var Thkuvl = grid.getCellValue(grid.getSelectedRowId(),4);
	var Rmtltarwth = grid.getCellValue(grid.getSelectedRowId(),5);
	var Thklvlstd = grid.getCellValue(grid.getSelectedRowId(),9);
	var Thkuvlstd = grid.getCellValue(grid.getSelectedRowId(),10);
	var Rmtltarwthstd = grid.getCellValue(grid.getSelectedRowId(),11);
	 
	if(stage==2){
		if (cInd==2){
			if(Number(nValue) < Number(Thklvlstd) || Number(nValue) > Number(Thkuvlstd))
	   		{
	    		gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_THK"),"background:red");
	    		redflag1 = 1;
	    		if(redflag2 ==1){
	      			gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_WTH"),"background:red");
	     		}
			}else{
	    		gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_THK"),"background:white");
	    		redflag1 = 0;
	    		if(redflag2 ==1){
	      			gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_WTH"),"background:red");
	     		}
	    	}
		}
		if(cInd==5){
			if(Number(nValue) < Number(Rmtltarwthstd) || Number(nValue) > Number(Rmtltarwthstd)+25)
	   		{  
	    		gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_WTH"),"background:red");
	     		redflag2 =1;
	     		if(redflag1 ==1){
	    			gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_THK"),"background:red");
	      		}
			}else{
	    		gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_WTH"),"background:white");
	    		redflag2 =0;
	    		if(redflag1 ==1){
	    			gridObj.setCellTextStyle(grid.getSelectedRowId(),gridObj.getColIndexById("RMTL_TAR_THK"),"background:red");
	      		}
	    	}
	 	}
		return true;
	}
}

function onEditCellEvent2(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB05_Grid_2"];
	var gridObj = items["C104000020TAB05_Grid_2"].getDhxGrid();
	//수정전...
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
					dhtmlx.alert("확정된 주문을 삭제/수정 할 수 없습니다! 대체공정 추가에 따른 수정은 가능.");
				    grid.setUpdated(rId, false, "")
				    return false;
			    }else{
					var param2= "ServiceName=C104000020TAB05-service&PROC_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=SUB_PROC_CD1,SUB_PROC_CD2";
					var xmlObj2 = uiCommon.ajaxLoadData('c10AjaxData.do',param2);
					var cells2 = xmlObj2.getElementsByTagName("cell");
					if(cells2.length > 0){	
						if(cInd == 5 || cInd == 13){
							if(isNull(cells2.item(0).firstChild.nodeValue)){ //cells2.item(0) -> 컬럼info의 정보를 말한다
								dhtmlx.alert("도금 대체공정1이 없습니다.!");
							    grid.setUpdated(rId, false, "")
							    return false;
							}
							fg_grid2_update	= "Y";
						}else{
							if(isNull(cells2.item(1).firstChild.nodeValue)){
								dhtmlx.alert("도금 대체공정2가 없습니다.!");
							    grid.setUpdated(rId, false, "")
							    return false;
							}
							fg_grid2_update	= "Y";
						}
					}else{
						dhtmlx.alert("통과공정에 도금공정이 없습니다.!");
					    grid.setUpdated(rId, false, "")
					    return false;
					}			    	
			    }				
			}
		}else{
			if(cells1.length > 0){	
			    dhtmlx.alert("확정된 주문을 수정할 수 없습니다! 대체공정 추가에 따른 수정은 가능.");
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
				dhtmlx.alert("두께 범위를 벗어났습니다!");
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
			dhtmlx.alert("두께 범위를 벗어났습니다!");
			grid.setCellValue(rId,9,oValue);		
		}else if( (cInd == 10 || cInd == 11) && !isNull(nValue)) {
			if(thk > max || thk < min)
			{
				dhtmlx.alert("두께 범위를 벗어났습니다!");
				grid.setCellValue(rId,cInd,oValue);		
			}
		}else if( (cInd == 10 || cInd == 11) && isNull(nValue)) {
			dhtmlx.alert("두께 범위를 벗어났습니다!");
			grid.setCellValue(rId,cInd,oValue);		
		}else{
			return true;
		}	
	}
   return true;
}

function onEditCellEvent3(stage,rId,cInd,nValue,oValue){

	var grid = items["C104000020TAB05_Grid_3"];
	var gridObj = items["C104000020TAB05_Grid_3"].getDhxGrid();
	
	var grid2 = items["C104000020TAB05_Grid_2"];
	var gridObj2 = items["C104000020TAB05_Grid_2"].getDhxGrid();
	var rowIndex = gridObj.getRowId(rId);
	if(stage==1){
		if(cInd == 2 || cInd == 3 ||cInd == 5 ){ 
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("HT,CT,Line Speed",3,0,false,this.value)){
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
		}else if(cInd == 4){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("ST",4,0,false,this.value)){
							if(this.value.length > 4){
								gridObj.editor.obj.value = this.value.substring(0,4);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;
							if(rowIndex == 0  && cInd == 4){ 
								grid2.setCellByIndexValue(0,43,this.value);//ST(2CGL)
							}else if(rowIndex == 1  && cInd == 4){ 
								grid2.setCellByIndexValue(0,53,this.value);//ST(4CGL)
							}
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
		/*
		if(cells1.length > 0){	
		    dhtmlx.alert("확정된 주문은 수정할 수 없습니다!");
			grid.setUpdated(rId, false, "")
		    return false;
		}
		*/
		
		if(isNull(nValue)){
			if(rowIndex == 0  && cInd == 2){ 
				grid2.setCellByIndexValue(0,43,"");//HT(2CGL)
			}else if(rowIndex == 0  && cInd == 3){ 
				grid2.setCellByIndexValue(0,44,"");//CT(2CGL)
			}else if(rowIndex == 0  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,45,"");//Line Speed(2CGL)
			}if(rowIndex == 1  && cInd == 2){ 
				grid2.setCellByIndexValue(0,51,"");//HT(4CGL)
			}else if(rowIndex == 1  && cInd == 3){ 
				grid2.setCellByIndexValue(0,52,"");//CT(4CGL)
			}else if(rowIndex == 1  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,54,"");//Line Speed(4CGL)
			}else if(rowIndex == 0  && cInd == 4){ 
				grid2.setCellByIndexValue(0,43,"");//ST(2CGL)
			}else if(rowIndex == 1  && cInd == 4){ 
				grid2.setCellByIndexValue(0,53,"");//ST(4CGL)
			}
		}else{
			if(rowIndex == 0  && cInd == 2){ 
				grid2.setCellByIndexValue(0,41,nValue);//HT(2CGL)
			}else if(rowIndex == 0  && cInd == 3){ 
				grid2.setCellByIndexValue(0,42,nValue);//CT(2CGL)
			}else if(rowIndex == 0  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,44,nValue);//Line Speed(2CGL)
			}if(rowIndex == 1  && cInd == 2){ 
				grid2.setCellByIndexValue(0,51,nValue);//HT(4CGL)
			}else if(rowIndex == 1  && cInd == 3){ 
				grid2.setCellByIndexValue(0,52,nValue);//CT(4CGL)
			}else if(rowIndex == 1  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,54,nValue);//Line Speed(4CGL)
			}else if(rowIndex == 0  && cInd == 4){ 
				grid2.setCellByIndexValue(0,43,nValue);//ST(2CGL)
			}else if(rowIndex == 1  && cInd == 4){ 
				grid2.setCellByIndexValue(0,53,nValue);//ST(4CGL)
			}						
		}
		grid2.setUpdated(grid2.getDhxGrid().getRowId(0),true,"updated"); 
		return true;
	
	}
   return true;
}

function onEditCellEvent4(stage,rId,cInd,nValue,oValue){

	var grid = items["C104000020TAB05_Grid_4"];
	var gridObj = items["C104000020TAB05_Grid_4"].getDhxGrid();
	
	var grid2 = items["C104000020TAB05_Grid_2"];
	var gridObj2 = items["C104000020TAB05_Grid_2"].getDhxGrid();
	var rowIndex = gridObj.getRowId(rId);
	if(stage==1){
		if(cInd == 2 || cInd == 3 ||cInd == 5 ){ 
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("HT,CT,Line Speed",3,0,false,this.value)){
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
		}else if(cInd == 4){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("ST",4,0,false,this.value)){
							if(this.value.length > 4){
								gridObj.editor.obj.value = this.value.substring(0,4);
							}else{
								gridObj.editor.obj.value = "";
							}
							return true;
						}else{
							gridObj.editor.obj.value = this.value;
							if(rowIndex == 0  && cInd == 4){ 
								grid2.setCellByIndexValue(0,48,this.value);//ST(3CGL)
							}else if(rowIndex == 1  && cInd == 4){ 
								grid2.setCellByIndexValue(0,58,this.value);//ST(5CGL)
							}
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
		/*
		if(cells1.length > 0){	
		    dhtmlx.alert("확정된 주문은 수정할 수 없습니다!");
			grid.setUpdated(rId, false, "")
		    return false;
		}
		*/
		
		if(isNull(nValue)){
			if(rowIndex == 0  && cInd == 2){ 
				grid2.setCellByIndexValue(0,46,"");//HT(2CGL)
			}else if(rowIndex == 0  && cInd == 3){ 
				grid2.setCellByIndexValue(0,47,"");//CT(2CGL)
			}else if(rowIndex == 0  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,48,"");//Line Speed(2CGL)
			}if(rowIndex == 1  && cInd == 2){ 
				grid2.setCellByIndexValue(0,56,"");//HT(4CGL)
			}else if(rowIndex == 1  && cInd == 3){ 
				grid2.setCellByIndexValue(0,57,"");//CT(4CGL)
			}else if(rowIndex == 1  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,58,"");//Line Speed(4CGL)
			}else if(rowIndex == 0  && cInd == 4){ 
				grid2.setCellByIndexValue(0,48,"");//ST(2CGL)
			}else if(rowIndex == 1  && cInd == 4){ 
				grid2.setCellByIndexValue(0,58,"");//ST(4CGL)
			}
		}else{
			if(rowIndex == 0  && cInd == 2){ 
				grid2.setCellByIndexValue(0,46,nValue);//HT(3CGL)
			}else if(rowIndex == 0  && cInd == 3){ 
				grid2.setCellByIndexValue(0,47,nValue);//CT(3CGL)
			}else if(rowIndex == 0  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,49,nValue);//Line Speed(3CGL)
			}if(rowIndex == 1  && cInd == 2){ 
				grid2.setCellByIndexValue(0,56,nValue);//HT(5CGL)
			}else if(rowIndex == 1  && cInd == 3){ 
				grid2.setCellByIndexValue(0,57,nValue);//CT(5CGL)
			}else if(rowIndex == 1  && cInd == 5){ 						
				grid2.setCellByIndexValue(0,59,nValue);//Line Speed(5CGL)
			}else if(rowIndex == 0  && cInd == 4){ 
				grid2.setCellByIndexValue(0,48,nValue);//ST(2CGL)
			}else if(rowIndex == 1  && cInd == 4){ 
				grid2.setCellByIndexValue(0,58,nValue);//ST(4CGL)
			}						
		}
		grid2.setUpdated(grid2.getDhxGrid().getRowId(0),true,"updated"); 
		return true;
	
	}
   return true;
}

function onEditCellEvent5(stage,rId,cInd,nValue,oValue){

	var grid = items["C104000020TAB05_Grid_5"];
	var gridObj = items["C104000020TAB05_Grid_5"].getDhxGrid();
	
	var grid2 = items["C104000020TAB05_Grid_2"];
	var gridObj2 = items["C104000020TAB05_Grid_2"].getDhxGrid();
	if(stage==1){
		if(cInd == 0 || cInd == 1 ||cInd == 2 ){ 
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("도금 부착량 상한,하한, 도금량",3,0,true,this.value)){
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
		}else if(cInd == 3){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("ST",3,0,false,this.value)){
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
		}else if(cInd == 8 || cInd == 9 ||cInd == 10 ){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("수지부착량",4,0,false,this.value)){
							if(this.value.length > 4){
							gridObj.editor.obj.value = this.value.substring(0,4);
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
		}else if(cInd == 11){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("두께 목표값",2,3,true,this.value)){
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
		}else if(cInd == 12){ 
				gridObj.editor.obj.onkeyup = function(e){
					e = e||window.event;
					if((e.keyCode >= 47) || (e.keyCode == 0)){
						if(!grid_qnty_check("폭 목표값",4,1,true,this.value)){
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
		/*
		if(cells1.length > 0){	
		    dhtmlx.alert("확정된 주문은 수정할 수 없습니다!");
			grid.setUpdated(rId, false, "")
		    return false;
		}
		*/
		
		if(isNull(nValue)){			
			if(cInd == 0){ 
				grid2.setCellByIndexValue(0,60,"");//도금 부착량 하한값
			}else if(cInd == 1){ 
				grid2.setCellByIndexValue(0,61,"");//도금 부착량 상한값
			}else if(cInd == 2){ 						
				grid2.setCellByIndexValue(0,62,"");//도금목표 도금량 
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,63,"");//도금목표 두께 
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,68,"");//수지부착량 목표
			}else if(cInd == 9){ 						
				grid2.setCellByIndexValue(0,69,"");//수지부착량 하한
			}else if(cInd == 10){ 						
				grid2.setCellByIndexValue(0,70,"");//수지부착량 상한
			}else if(cInd == 11){ 						
				grid2.setCellByIndexValue(0,71,"");//목표 Size 두께
			}else if(cInd == 12){ 						
				grid2.setCellByIndexValue(0,72,"");//목표 Size 폭
			}
		}else{ 
			if(cInd == 0){ 
				grid2.setCellByIndexValue(0,60,nValue);//도금 부착량 하한값
			}else if(cInd == 1){ 
				grid2.setCellByIndexValue(0,61,nValue);//도금 부착량 상한값
			}else if(cInd == 2){ 						
				grid2.setCellByIndexValue(0,62,nValue);//도금목표 도금량 
			}else if(cInd == 3){ 
				grid2.setCellByIndexValue(0,63,nValue);//도금목표 두께 
			}else if(cInd == 8){ 
				grid2.setCellByIndexValue(0,68,nValue);//수지부착량 목표
			}else if(cInd == 9){ 						
				grid2.setCellByIndexValue(0,69,nValue);//수지부착량 하한
			}else if(cInd == 10){ 						
				grid2.setCellByIndexValue(0,70,nValue);//수지부착량 상한
			}else if(cInd == 11){ 						
				grid2.setCellByIndexValue(0,71,nValue);//목표 Size 두께
			}else if(cInd == 12){ 						
				grid2.setCellByIndexValue(0,72,nValue);//목표 Size 폭
			}
		}
		grid2.setUpdated(grid2.getDhxGrid().getRowId(0),true,"updated"); 
		return true;
	
	}
   return true;
}

function simul(){
	
	var rmtlknd = items["C104000020TAB05_Grid_1"].getCellValue(items["C104000020TAB05_Grid_1"].getSelectedRowId(),0);
	if(isNull(rmtlknd)){
	
	var vrmtlKnd = rmtlKind;
		}
	else{
	
	var vrmtlKnd = rmtlknd;
	}
	
	if(isNull(vrmtlKnd)){
		dhtmlx.alert("적차선을 선택한 후에 조회 하시기 바랍니다.");
	}
	else{
		var vstWth    = items["C104000020TAB05_Grid_2"].getCellValue(items["C104000020TAB05_Grid_2"].getDhxGrid().getRowId(0),4);
		var vpltcmThk = items["C104000020TAB05_Grid_2"].getCellValue(items["C104000020TAB05_Grid_2"].getDhxGrid().getRowId(0),9);	
		winObj = new ui.window('popup','폭수축 및 시뮬레이션','0','0','570','405','C104000020POP02.jsp?RMTL_KND='+vrmtlKnd+'&ST_WHT='+vstWth+'&PLTCM_THK='+vpltcmThk);
		winObj.setModal();
	}
}

//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB05_Grid_1" style="position:absolute;height:118px;width:840px;left:118px;top:0px;">
</div>
<div id="C104000020TAB05_Grid_8" style="position:absolute;height:118px;width:116px;left:1px;top:0px;">
</div>
<div id="C104000020TAB05_Form_1" style="position:absolute;height:26px;width:958px;left:1px;top:121px;">
</div>
<div id="C104000020TAB05_Grid_2" style="position:absolute;height:74px;width:957px;left:1px;top:150px;">
</div>
<div id="C104000020TAB05_Form_2" style="position:absolute;height:20px;width:958px;left:1px;top:228px;">
</div>
<div id="C104000020TAB05_Grid_3" style="position:absolute;height:70px;width:479px;left:1px;top:249px;">
</div>
<div id="C104000020TAB05_Grid_4" style="position:absolute;height:70px;width:475px;left:483px;top:249px;">
</div>
<div id="C104000020TAB05_Grid_5" style="position:absolute;height:74px;width:957px;left:1px;top:322px;">
</div>
<div id="C104000020TAB05_Grid_6" style="position:absolute;height:22px;width:957px;left:1px;top:399px;">
</div>
<div id="C104000020TAB05_Form_3" style="position:absolute;height:20px;width:958px;left:1px;top:424px;">
</div>
<div id="C104000020TAB05_Grid_7" style="position:absolute;height:50px;width:957px;left:1px;top:424px;">
</div>
<div id="C104000020TAB05_messagebox" style="position:absolute;height:19px;width:957px;left:1px;top:496px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
       items['C104000020TAB05_Form_1'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB05_Form_2'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB05_Form_3'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB05_Grid_1'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid1);
       items['C104000020TAB05_Grid_2'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid2);
       items['C104000020TAB05_Grid_3'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid3);
       items['C104000020TAB05_Grid_4'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid4);
       items['C104000020TAB05_Grid_5'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid5);
       items['C104000020TAB05_Grid_6'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid6);
       items['C104000020TAB05_Grid_7'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid7);
       //items['C104000020TAB05_Grid_7'].getDhxGrid().enableKeyboardSupport(true);
	   //items['C104000020TAB05_Grid_8'].getDhxGrid().attachEvent("onRowSelect", onRowSelect_Grid8);
	   var _onXLE1 = items['C104000020TAB05_Grid_1'].onXLEEvent(onGridLoadEvent1);
	   var _onXLE2 = items['C104000020TAB05_Grid_2'].onXLEEvent(onGridLoadEvent2);
	   var _onXLE3 = items['C104000020TAB05_Grid_3'].onXLEEvent(onGridLoadEvent3);
	   var _onXLE4 = items['C104000020TAB05_Grid_4'].onXLEEvent(onGridLoadEvent4);
	   var _onXLE5 = items['C104000020TAB05_Grid_5'].onXLEEvent(onGridLoadEvent5);
	   var _onXLE7 = items['C104000020TAB05_Grid_7'].onXLEEvent(onGridLoadEvent7);
	   var onXLEGrid8 = items['C104000020TAB05_Grid_8'].onXLEEvent(onLoadGrid8);
	   items["C104000020TAB05_Grid_1"].onEditCellEvent(onEditCellEvent1);
	   items["C104000020TAB05_Grid_2"].onEditCellEvent(onEditCellEvent2);
	   items["C104000020TAB05_Grid_3"].onEditCellEvent(onEditCellEvent3);
	   items["C104000020TAB05_Grid_4"].onEditCellEvent(onEditCellEvent4);
	   items["C104000020TAB05_Grid_5"].onEditCellEvent(onEditCellEvent5);
   	   items["C104000020TAB05_Grid_1"].rowSelected(deteilFind);
//]]>
-->
</script>