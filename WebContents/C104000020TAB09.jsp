<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB09.jsp
 * VERSION                 :  V1.0
 * DESCRIPTION          :  품질설계결과-후공정
 * DESIGNER NAME     :  한 윤 섭
 * DEVELOPER NAME  :  박 재 영
 * CREATE DATE         :  2011.12.16
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.12.16     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
C104000020TAB09
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
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
      '{"itemType":"form","renderTo":"C104000020TAB09_Form_1","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020TAB09_Form_1","service":"C104000020TAB09-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB09_Grid_1","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Grid_1.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB09_Grid_1","service":"C104000020TAB09-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB09_Grid_2","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB09_Grid_2","service":"C104000020TAB09-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB09_Grid_3","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Grid_3.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB09_Grid_3","service":"C104000020TAB09-service","actionType":"find"},' +
      '{"itemType":"form","renderTo":"C104000020TAB09_Form_2","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Form_2.xml","url":"basicGridData.do","referenceItem":"C104000020TAB09_Form_2","service":"C104000020TAB09-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB09_Grid_4","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Grid_4.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB09_Grid_4","service":"C104000020TAB09-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C104000020TAB09_messagebox","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_messagebox.xml","service":"C104000020TAB09-service"},' +
      '{"itemType":"form","renderTo":"C104000020TAB09_Form_3","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Form_3.xml","url":"basicGridData.do","referenceItem":"C104000020TAB09_Form_1","service":"C104000020TAB09-service","actionType":"find"},' +
      '{"itemType":"grid","renderTo":"C104000020TAB09_Grid_5","xml":".\/header\/kr\/C104000020TAB09\/C104000020TAB09_Grid_5.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB09_Grid_5","service":"C104000020TAB09-service","actionType":"save"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
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
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_1','MNF_find'); 
		items['C104000020TAB09_Grid_1'].loadData(findUrl,findMessage);	
		var findUrl2 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_2','MNF_find'); 
		items['C104000020TAB09_Grid_2'].loadData(findUrl2,findMessage);	
		var findUrl3 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_3','MNF_find'); 
		items['C104000020TAB09_Grid_3'].loadData(findUrl3,findMessage);	
		var findUrl5 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_5','MNF_find'); 
		items['C104000020TAB09_Grid_5'].loadData(findUrl5,findMessage);	
		var param = parameters12('C104000020_Form_1','C104000020TAB09_Grid_4','C104000020TAB09-service','MSG_find');
		var	xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB09_Grid_4',xmlObj);
	}
}

function save(eventName,formDivObj,referenceItem){
	var gridObj1 = items['C104000020TAB09_Grid_1'].getDhxGrid();
	var gridObj4 = items['C104000020TAB09_Grid_4'].getDhxGrid();
	var gridObj5 = items['C104000020TAB09_Grid_5'].getDhxGrid();
	var chgCnt = 0;
	
	// 현재입력 Cell에서 강제 포커스 이동시켜 변경상태를 인지토록 함
	var rowId1 = items['C104000020TAB09_Grid_1'].getRowSelectedId();
  	gridObj1.selectRow(gridObj1.getRowIndex(rowId1));
	var rowId4 = items['C104000020TAB09_Grid_4'].getRowSelectedId();
  	gridObj4.selectRow(gridObj4.getRowIndex(rowId4));
	var rowId5 = items['C104000020TAB09_Grid_5'].getRowSelectedId();
  	gridObj5.selectRow(gridObj5.getRowIndex(rowId5));  	
  	
  	var row_status1 = "", row_status4 = "", row_status5 = "";
  	
	row_status1 = gridObj1.getUserData(gridObj1.getRowId(0),"!nativeeditor_status");
	row_status4 = gridObj4.getUserData(gridObj4.getRowId(0),"!nativeeditor_status");
	row_status5 = gridObj5.getUserData(gridObj5.getRowId(0),"!nativeeditor_status");
	
	if( row_status1 == "updated" || row_status4 == "updated" || row_status5 == "updated"){
		chgCnt++;
    	/* 확정된 주문이라도 수정할수 있도록 수정 : 박성용요청 20140611
	    var parentForm = parent.items['C104000020_Form_1'];
		var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
		var ord_no = parentForm.getItemValue("ORD_NO");
		var param1= "ServiceName=C104000020TAB05-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		if(cells1.length > 0){
			dhtmlx.alert("확정된 주문입니다!");
			return;					
		} */		
    }
	
	if(chgCnt === 0 ){
		dhtmlx.alert("변경된 데이터가 없습니다.");
		return;
	}else{
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"저장 하시겠습니까?",
			callback:function(val){
				if(val){			
					if(row_status1 == "updated" ){
					    items['C104000020TAB09_Grid_1'].sendGrid('C104000020TAB09_Grid_1',"COR_save");		
					    //items['C104000020TAB09_Grid_1'].sendGrid('C104000020TAB09_Grid_1',"1T2C_save");	
				    }else{
						if(row_status4 == "updated" )
						    items['C104000020TAB09_Grid_4'].sendGrid('C104000020TAB09_Grid_4',"MSG_save");
						else{
							if(row_status5 == "updated" )
							    items['C104000020TAB09_Grid_5'].sendGrid('C104000020TAB09_Grid_5',"PKG_save");
						}
				    }
					return;
				}
			}
		}); 
	}	
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
function onLoadGrid1(){	
// 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(!isNull(parentForm.getItemValue("ORD_NO")) && !isNull(comboList.getSelectedValue())){		
		var grid1 =  items['C104000020TAB09_Grid_1'];
	    var gridObj1 = items['C104000020TAB09_Grid_1'].getDhxGrid();
	    
	    
        var rmtlcdCombo = gridObj1.getColumnCombo(gridObj1.getColIndexById('COR_EDG_ASG_TP')); //S/T유무
        rmtlcdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=CUT_LN_YN&totalValue=&orderBy=value&displayType=all-code");   
		rmtlcdCombo.enableOptionAutoPositioning(true);
		rmtlcdCombo.readonly(true,true);
		rmtlcdCombo.setOptionHeight(60);
		
		var rmtl1t2cCombo = gridObj1.getColumnCombo(gridObj1.getColIndexById('OT_TC_YN')); //OT_TC_YN 
		rmtl1t2cCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=OT_TC_YN&totalValue=&orderBy=value&displayType=all-code");   
		rmtl1t2cCombo.enableOptionAutoPositioning(true);
		rmtl1t2cCombo.readonly(true,true);
		rmtl1t2cCombo.setOptionHeight(60);
		//정전 조회
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_1','MNF_find'); 
		items['C104000020TAB09_Grid_1'].loadData(findUrl,findMessage);					
	}
	items['C104000020TAB09_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent1);
	items['C104000020TAB09_Grid_1'].getDhxGrid().detachEvent(onXLEGrid1);
}

function onGridAfterUpdateFinishEvent1(){
	var gridObj2 = items['C104000020TAB09_Grid_4'].getDhxGrid();
	var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
	if(row_status2 != "" && row_status2 == "updated" )
	    items['C104000020TAB09_Grid_4'].sendGrid('C104000020TAB09_Grid_4',"MSG_save");
	else
    {
		var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_1','MNF_find'); 
		items['C104000020TAB09_Grid_1'].loadData(findUrl,findMessage);	
    }
}

function onLoadGrid2(){	
// 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(!isNull(parentForm.getItemValue("ORD_NO")) && !isNull(comboList.getSelectedValue())){				
		//SKID,SHEET적재방법,엠보스무늬,방청유
		var findUrl2 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_2','MNF_find'); 
		items['C104000020TAB09_Grid_2'].loadData(findUrl2,findMessage);	
	}
	items['C104000020TAB09_Grid_2'].getDhxGrid().detachEvent(onXLEGrid2);
}

function onLoadGrid3(){	
// 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(!isNull(parentForm.getItemValue("ORD_NO")) && !isNull(comboList.getSelectedValue())){				
		//보호필름
		var findUrl3 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_3','MNF_find'); 
		items['C104000020TAB09_Grid_3'].loadData(findUrl3,findMessage);
	}
	items['C104000020TAB09_Grid_3'].getDhxGrid().detachEvent(onXLEGrid3);
}
function onLoadGrid4(){	
// 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(!isNull(parentForm.getItemValue("ORD_NO")) && !isNull(comboList.getSelectedValue())){				
		// 메세지 조회
		var param = parameters12('C104000020_Form_1','C104000020TAB09_Grid_4','C104000020TAB09-service','MSG_find');
		var	xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB09_Grid_4',xmlObj);
	}
	items['C104000020TAB09_Grid_4'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent4);
	items['C104000020TAB09_Grid_4'].getDhxGrid().detachEvent(onXLEGrid4);
}

function onGridAfterUpdateFinishEvent4(){
	var gridObj2 = items['C104000020TAB09_Grid_5'].getDhxGrid();
	var row_status2 = gridObj2.getUserData(gridObj2.getRowId(0),"!nativeeditor_status");
	if(row_status2 != "" && row_status2 == "updated" )
	    items['C104000020TAB09_Grid_5'].sendGrid('C104000020TAB09_Grid_5',"PKG_save");
	else
    {
    	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_1','MNF_find'); 
		items['C104000020TAB09_Grid_1'].loadData(findUrl,findMessage);					
		var param = parameters12('C104000020_Form_1','C104000020TAB09_Grid_4','C104000020TAB09-service','MSG_find');
		var	xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C104000020TAB09_Grid_4',xmlObj);
    }
}

function onLoadGrid5(){	
// 원자재 조회
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	if(!isNull(parentForm.getItemValue("ORD_NO")) && !isNull(comboList.getSelectedValue())){				
		var grid5 =  items['C104000020TAB09_Grid_5'];
	    var gridObj5 = items['C104000020TAB09_Grid_5'].getDhxGrid();	
	    
        var pakmsgcdCombo = gridObj5.getColumnCombo(gridObj5.getColIndexById('PAK_MSG_CD')); //포장메시지
        pakmsgcdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PAK_MSG_CD&totalValue=&orderBy=value&displayType=all-code");   
		pakmsgcdCombo.enableOptionAutoPositioning(true);
		pakmsgcdCombo.readonly(true,true);
		pakmsgcdCombo.setOptionHeight(240);		
		//보호필름
		var findUrl5 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_5','MNF_find'); 
		items['C104000020TAB09_Grid_5'].loadData(findUrl5,findMessage);
	}
	items['C104000020TAB09_Grid_5'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent5);
	items['C104000020TAB09_Grid_5'].getDhxGrid().detachEvent(onXLEGrid5);
}

function onGridAfterUpdateFinishEvent5(){
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_1','MNF_find'); 
	items['C104000020TAB09_Grid_1'].loadData(findUrl,findMessage);					
	var param = parameters12('C104000020_Form_1','C104000020TAB09_Grid_4','C104000020TAB09-service','MSG_find');
	var	xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
	uiCommon.renderToGrid('C104000020TAB09_Grid_4',xmlObj);
	var findUrl5 = uiCommon.parameters4('C104000020_Form_1','C104000020TAB09_Grid_5','MNF_find'); 
	items['C104000020TAB09_Grid_5'].loadData(findUrl5,findMessage);
}

function onRowSelect_Grid1(id,ind){ 
	items['C104000020TAB09_Grid_2'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_3'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_4'].getDhxGrid().clearSelection();
}
function onRowSelect_Grid2(id,ind){ 
	items['C104000020TAB09_Grid_1'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_3'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_4'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_5'].getDhxGrid().clearSelection();
}
function onRowSelect_Grid3(id,ind){ 
	items['C104000020TAB09_Grid_1'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_2'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_4'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_5'].getDhxGrid().clearSelection();
}
function onRowSelect_Grid4(id,ind){ 
	items['C104000020TAB09_Grid_1'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_2'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_3'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_5'].getDhxGrid().clearSelection();
}
function onRowSelect_Grid5(id,ind){ 
	items['C104000020TAB09_Grid_1'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_2'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_3'].getDhxGrid().clearSelection();
	items['C104000020TAB09_Grid_4'].getDhxGrid().clearSelection();
}
function findMessage(referenceItem){	
	uiCommon.progressOff(parent);
	var grid = items['C104000020TAB09_Grid_1'].getDhxGrid();	
	document.getElementById("C104000020TAB09_messagebox").innerHTML = "&nbsp;MESSAGE&nbsp;&nbsp;|&nbsp" + grid.getUserData("","appMsg"); //정전 조회메세지 설정
}
function upt_clear(){
	var grid = items['C104000020TAB09_Grid_1'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB09_Grid_4'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
	grid = items['C104000020TAB09_Grid_5'];
	grid.setUpdated(grid.getDhxGrid().getRowId(0),false,""); 
}
function onEditCellEvent1(stage,rId,cInd,nValue,oValue){

	var grid = items["C104000020TAB09_Grid_1"];
	var gridObj = items["C104000020TAB09_Grid_1"].getDhxGrid();
	if(stage==1){
		if(cInd == 0) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("조수",1,0,false,this.value)){
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
		}else if((cInd > 0 && cInd < 11) || cInd > 11 && (cInd > 0 && cInd < 12) || cInd > 12 ) { //MAX LENGTH 체크
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

//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB09_Form_1" style="position:absolute;height:28px;width:976px;left:0px;top:0px;">
</div>
<div id="C104000020TAB09_Grid_1" style="position:absolute;height:74px;width:973px;left:1px;top:28px;">
</div>
<div id="C104000020TAB09_Grid_2" style="position:absolute;height:74px;width:973px;left:1px;top:105px;">
</div>
<div id="C104000020TAB09_Grid_3" style="position:absolute;height:74px;width:973px;left:1px;top:182px;">
</div>
<div id="C104000020TAB09_Form_2" style="position:absolute;height:23px;width:973px;left:0px;top:260px;">
</div>
<div id="C104000020TAB09_Grid_4" style="position:absolute;height:50px;width:973px;left:1px;top:284px;">
</div>
<div id="C104000020TAB09_messagebox" style="position:absolute;height:19px;width:973px;left:1px;top:430px;">
</div>
<div id="C104000020TAB09_Form_3" style="position:absolute;height:23px;width:973px;left:0px;top:338px;">
</div>
<div id="C104000020TAB09_Grid_5" style="position:absolute;height:50px;width:973px;left:1px;top:363px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();
       items['C104000020TAB09_Form_1'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB09_Form_2'].setBackgroundColor("#FFFFFF");
       items['C104000020TAB09_Form_3'].setBackgroundColor("#FFFFFF");
	   items['C104000020TAB09_Grid_1'].rowSelected(onRowSelect_Grid1);
       items['C104000020TAB09_Grid_2'].rowSelected(onRowSelect_Grid2);
       items['C104000020TAB09_Grid_3'].rowSelected(onRowSelect_Grid3);
	   items['C104000020TAB09_Grid_4'].rowSelected(onRowSelect_Grid4);
	   items['C104000020TAB09_Grid_5'].rowSelected(onRowSelect_Grid5);
   	   var onXLEGrid1 = items['C104000020TAB09_Grid_1'].onXLEEvent(onLoadGrid1);	    
	   var onXLEGrid2 = items['C104000020TAB09_Grid_2'].onXLEEvent(onLoadGrid2);	    
	   var onXLEGrid3 = items['C104000020TAB09_Grid_3'].onXLEEvent(onLoadGrid3);	    
	   var onXLEGrid4 = items['C104000020TAB09_Grid_4'].onXLEEvent(onLoadGrid4);	    
	   var onXLEGrid5 = items['C104000020TAB09_Grid_5'].onXLEEvent(onLoadGrid5);	    
	   items["C104000020TAB09_Grid_1"].onEditCellEvent(onEditCellEvent1);
//]]>
-->
</script>