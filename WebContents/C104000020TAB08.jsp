<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000020TAB08.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계결과-통과공정
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.12.16
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
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var proc_seq_max = "";
var proc_seq_max_temp = "";
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C104000020TAB08_Grid_1","xml":".\/header\/kr\/C104000020TAB08\/C104000020TAB08_Grid_1.xml","rowCnt":"15","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C104000020TAB08_Grid_1","service":"C104000020TAB08-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C104000020TAB08_messagebox","xml":".\/header\/kr\/C104000020TAB08\/C104000020TAB08_messagebox.xml","service":"C104000020TAB08-service"},' +
      '{"itemType":"menu","renderTo":"C104000020TAB08_Menu_1","xml":".\/header\/kr\/C104000020TAB08\/C104000020TAB08_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C104000020TAB08_Grid_1","service":"C104000020TAB08-service"},' +
      '{"itemType":"form","renderTo":"C104000020TAB08_Form_1","xml":".\/header\/kr\/C104000020TAB08\/C104000020TAB08_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020TAB08_Grid_1","service":"C104000020TAB08-service","security":"true"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"/dhtmlx/codebase/imgs/"};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	onFormLoadEvent1();
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB08_Grid_1',eventName); 
	items['C104000020TAB08_Grid_1'].loadData(findUrl); 
}

function save(eventName,formDivObj,referenceItem){
	
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	var param1= "ServiceName=C104000020TAB08-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
	var cells1 = xmlObj1.getElementsByTagName("cell");
	/*
	if(cells1.length > 0){						
		dhtmlx.alert("확정된 주문입니다!");
		return;					
	}
	*/
	
	//통과공정 삭제 시 공정순서 조정에 대한 알림메시지
	//alert("통과공정 삭제 시는 공정순서를 변경하시기 바랍니다!");
	
	var grid = items['C104000020TAB08_Grid_1'];
	var gridObj = items['C104000020TAB08_Grid_1'].getDhxGrid();
	var row_status = "";
	var row_status1 = "";
	var main_proc = "";
	var main_proc_clr = "";
	var sub_proc1 = "";
	var sub_proc2 = "";
	var sub_proc3 = "";
	var proc_seq = "";
	var ord_seq = "";
	var proc_seq_pre = "";  //추가
	var proc_seq_diff = ""; //추가
	//var proc_seq_max = new Array(14); //공정순서 최대값
	
	for(var i=0; i< gridObj.getRowsNum(); i++)	{
	    proc_seq = gridObj.cellByIndex(i,0).getValue();
	    //alert("proc_seq:" + proc_seq);
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		//alert("row_status:" + row_status);
		if(row_status != "")
		    row_status1 = row_status;
		//alert("row_status1:" + row_status1);
		//proc_seq_max = proc_seq;

		if(proc_seq == "")
			break;

		//삭제된 row는 중복체크 대상에서 제외 (2026.07.06 서재섭)
		if(row_status == "deleted")
			continue;

		for(var k=0; k< gridObj.getRowsNum(); k++){
			ord_seq = gridObj.cellByIndex(k,0).getValue();
			var k_status = gridObj.getUserData(gridObj.getRowId(k),"!nativeeditor_status");
			//alert("ord_seq:" + ord_seq);
			if(i != k && k_status != "deleted"){
				if(ord_seq == proc_seq){
					dhtmlx.alert("순번 중복이 있습니다!");
					return;
				}
			}
		}
		
		/*
		if(i == 0)
		{
			proc_seq_pre = proc_seq;
		}
		else
		{
			proc_seq_diff = proc_seq - proc_seq_pre;
			if(proc_seq_diff != 1)
			{
				dhtmlx.alert("공정순서가 맞지 않습니다. 순서 조정하시기 바랍니다.!");
				return;
			}
			else
			{
				proc_seq_pre = proc_seq;
			}
		}
		*/
	}
	
	if(row_status1 != ""){
		for(var i=0; i< gridObj.getRowsNum(); i++){
		    main_proc = gridObj.cellByIndex(i,1).getValue();
			row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
			if(row_status == "" && main_proc == "" ){
		    	break;
			}else{
			    sub_proc1 = gridObj.cellByIndex(i,2).getValue();
			    sub_proc2 = gridObj.cellByIndex(i,3).getValue();
			    sub_proc3 = gridObj.cellByIndex(i,4).getValue();
			    sub_proc4 = gridObj.cellByIndex(i,5).getValue();
			    sub_proc5 = gridObj.cellByIndex(i,6).getValue();
			    sub_proc6 = gridObj.cellByIndex(i,7).getValue();
			    
			    //2013.04.05 주공정 대비 대체공정에 대한 Validation Check 추가(강정한 대리요청)
			    if(sub_proc1 != "" && (main_proc.substring(0,1) != sub_proc1.substring(0,1))){
			    	dhtmlx.alert("주공정과 특성이 다른 대체공정코드1은 추가 할 수 없습니다!");
					return;
			    }else if(sub_proc2 != "" && (main_proc.substring(0,1) != sub_proc2.substring(0,1))){
			    	dhtmlx.alert("주공정과 특성이 다른 대체공정코드2는 추가 할 수 없습니다!");
					return;
			    }else if(sub_proc3 != "" && (main_proc.substring(0,1) != sub_proc3.substring(0,1))){
			    	dhtmlx.alert("주공정과 특성이 다른 대체공정코드3은 추가 할 수 없습니다!");
					return;
			    }else if(sub_proc4 != "" && (main_proc.substring(0,1) != sub_proc4.substring(0,1))){
			    	dhtmlx.alert("주공정과 특성이 다른 대체공정코드4는 추가 할 수 없습니다!");
					return;
			    }else if(sub_proc5 != "" && (main_proc.substring(0,1) != sub_proc5.substring(0,1))){
			    	dhtmlx.alert("주공정과 특성이 다른 대체공정코드5는 추가 할 수 없습니다!");
					return;
			    }else if(sub_proc6 != "" && (main_proc.substring(0,1) != sub_proc6.substring(0,1))){
			    	dhtmlx.alert("주공정과 특성이 다른 대체공정코드6은 추가 할 수 없습니다!");
					return;
			    }

                //주공정이 offline일경우 인라인shl공정은 대체공정에 설계하면 안됨(APS요청) 2014.02.01
			    if(main_proc.substring(0,1) == "6" && i >0)	{
					main_proc_clr = gridObj.cellByIndex(i-1,1).getValue();
					
					if( (main_proc_clr == "A4" && main_proc != '65' && ( sub_proc1 =='65' || sub_proc2 =='65' ||sub_proc3 =='65' ||sub_proc4 =='65' || sub_proc5 =='65' ||sub_proc6 =='65')) ||
						(main_proc_clr == "A5" && main_proc != '66' && ( sub_proc1 =='66' || sub_proc2 =='66' ||sub_proc3 =='66' ||sub_proc4 =='66' || sub_proc5 =='66' ||sub_proc6 =='66')) ||
						(main_proc_clr == "A6" && main_proc != '67' && ( sub_proc1 =='67' || sub_proc2 =='67' ||sub_proc3 =='67' ||sub_proc4 =='67' || sub_proc5 =='67' ||sub_proc6 =='67')) ||
						(main_proc_clr == "A7" && main_proc != '68' && ( sub_proc1 =='68' || sub_proc2 =='68' ||sub_proc3 =='68' ||sub_proc4 =='68' || sub_proc5 =='68' ||sub_proc6 =='68')) ||
						(main_proc_clr == "A8" && main_proc != '69' && ( sub_proc1 =='69' || sub_proc2 =='69' ||sub_proc3 =='69' ||sub_proc4 =='69' || sub_proc5 =='69' ||sub_proc6 =='69')) )
					{
		    			dhtmlx.alert("주공정OFF-LINE작업시, IN-LINE공정을 대체공정에 설계할 수 없습니다");
						return;
					}					
				}
			    
				if(sub_proc2 == ""){
					gridObj.cellByIndex(i,3).setValue(gridObj.cellByIndex(i,4).getValue());
					gridObj.cellByIndex(i,4).setValue("");
				}
				if(sub_proc1 == ""){
					gridObj.cellByIndex(i,2).setValue(gridObj.cellByIndex(i,3).getValue());
					gridObj.cellByIndex(i,3).setValue(gridObj.cellByIndex(i,4).getValue());
				}
				if(main_proc == ""){
					gridObj.cellByIndex(i,1).setValue(gridObj.cellByIndex(i,2).getValue());
					gridObj.cellByIndex(i,2).setValue(gridObj.cellByIndex(i,3).getValue());
					gridObj.cellByIndex(i,3).setValue(gridObj.cellByIndex(i,4).getValue());
				}
				
			    sub_proc1 = gridObj.cellByIndex(i,2).getValue();
			    sub_proc2 = gridObj.cellByIndex(i,3).getValue();
			    sub_proc3 = gridObj.cellByIndex(i,4).getValue();
			    
			    
			    if(sub_proc1.substring(0,1) == "8"){
			    	var param1= "ServiceName=C104000020TAB08-service&PL_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=PL_WTH_SUB_PROC1_TRV,PL_WTH_SUB_PROC2_TRV";
					var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
					var cells1 = xmlObj1.getElementsByTagName("cell");
					if(isNull(cells1.item(0).firstChild.nodeValue)){						
						alert("대체공정1에 Side Trimming Set값 및 폭목표 값을 반드시 입력하세요!");
						//return;					
					}
			    }
			    
			    
			    if(sub_proc2.substring(0,1) == "8"){
			    	var param2= "ServiceName=C104000020TAB08-service&PL_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=PL_WTH_SUB_PROC1_TRV,PL_WTH_SUB_PROC2_TRV";
					var xmlObj2 = uiCommon.ajaxLoadData('c10AjaxData.do',param2);
					var cells2 = xmlObj2.getElementsByTagName("cell");
					if(isNull(cells2.item(1).firstChild.nodeValue)){						
						alert("대체공정2에 Side Trimming Set값 및 폭목표 값을 반드시 입력하세요!");
						//return;					
					}
			    }
			    /*
			    if(	sub_proc3.substring(0,1) == "8" || sub_proc3.substring(0,1) == "9"){
			    	//alert("PL ST폭은 입력할 수 없습니다!");
					//return;		
			    }
			    
			    //PL ST폭이 없으면 해당 통과공정 추가 불가
				if( sub_proc1.substring(0,1) == "8" || sub_proc1.substring(0,1) == "9"){
					var param2= "ServiceName=C104000020TAB08-service&PL_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=PL_WTH_SUB_PROC1_TRV,PL_WTH_SUB_PROC2_TRV";
					var xmlObj2 = uiCommon.ajaxLoadData('c10AjaxData.do',param2);
					var cells2 = xmlObj2.getElementsByTagName("cell");
					if(isNull(cells2.item(0).firstChild.nodeValue)){						
						//alert("대체공정2에 Side Trimming Set값 및 폭 목표 값을 반드시 입력하세요!");
						//return;					
					}
					
					if(sub_proc2.substring(0,1) == "8" || 	sub_proc2.substring(0,1) == "9"){
						if(isNull(cells2.item(1).firstChild.nodeValue)){						
							//alert("PL ST폭 대체공정2를 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;					
						}						
				    }
			    } //end if PL ST..
			    */
			    
			    //CGL 소둔사이클 코드가 없으면 해당 통과공정 추가 불가
			    /*
				if(sub_proc1.substring(0,1) == "8"){
					var param3= "ServiceName=C104000020TAB08-service&CANN_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=HEAT_CYL_NO_2CGL,HEAT_CYL_NO_3CGL,HEAT_CYL_NO_4CGL,HEAT_CYL_NO_5CGL";
					var xmlObj3 = uiCommon.ajaxLoadData('c10AjaxData.do',param3);
					var cells3 = xmlObj3.getElementsByTagName("cell");
					
					//82번 처리
					if(isNull(cells3.item(0).firstChild.nodeValue)){						
						if(sub_proc1.substring(0,2) == "82"){
							//alert("2CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;
						}
					}
					//83번 처리
					if(isNull(cells3.item(1).firstChild.nodeValue)){						
						if(sub_proc1.substring(0,2) == "83"){
							//alert("3CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;
						}
					}
					//84번 처리
					if(isNull(cells3.item(2).firstChild.nodeValue)){						
						if(sub_proc1.substring(0,2) == "84"){
							//alert("4CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;
						}
					}
					//85번 처리
					if(isNull(cells3.item(3).firstChild.nodeValue)){						
						if(sub_proc1.substring(0,2) == "85"){
							//alert("5CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;
						}
					}
					
					if(sub_proc2.substring(0,1) == "8"){
						//82번 처리
						if(isNull(cells3.item(0).firstChild.nodeValue)){						
							if(sub_proc2.substring(0,2) == "82"){
								//alert("2CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
								//return;
							}
						}
						//83번 처리
						if(isNull(cells3.item(1).firstChild.nodeValue)){						
							if(sub_proc2.substring(0,2) == "83"){
								//alert("3CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
								//return;
							}
						}
						//84번 처리
						if(isNull(cells3.item(2).firstChild.nodeValue)){						
							if(sub_proc2.substring(0,2) == "84"){
								//alert("4CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
								//return;
							}
						}
						//85번 처리
						if(isNull(cells3.item(3).firstChild.nodeValue)){						
							if(sub_proc2.substring(0,2) == "85"){
								//alert("5CGL 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
								//return;
							}
						}							
				    }
			    } //end if CGL소둔 사이클..
			    */
			    
			    //ANN 소둔사이클 코드가 없으면 해당 통과공정 추가 불가
			    
				if(sub_proc1.substring(0,1) == "4"){
					var param4= "ServiceName=C104000020TAB08-service&ANN_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=HEAT_CYL_NO_GEN_ANN,HEAT_CYL_NO_HC_ANN";
					var xmlObj4 = uiCommon.ajaxLoadData('c10AjaxData.do',param4);
					var cells4 = xmlObj4.getElementsByTagName("cell");
					
					//44번 처리
					if(isNull(cells4.item(0).firstChild.nodeValue)){						
						if(sub_proc1.substring(0,2) == "44"){
							//alert("일반 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;
						}
					}
					//43번 처리
					if(isNull(cells4.item(0).firstChild.nodeValue)){						
						if(sub_proc1.substring(0,2) == "43"){
							//alert("일반 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;
						}
					}
					//41번 처리
					if(isNull(cells4.item(1).firstChild.nodeValue)){						
						if(sub_proc1.substring(0,2) == "41"){
							//alert("HI-CON 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
							//return;
						}
					}
					
					//소둔 대체공정2의 경우
					if(sub_proc2.substring(0,1) == "4"){
						//44번 처리
						if(isNull(cells4.item(0).firstChild.nodeValue)){						
							if(sub_proc2.substring(0,2) == "44"){
								//alert("일반 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
								//return;
							}
						}
						//43번 처리
						if(isNull(cells4.item(0).firstChild.nodeValue)){						
							if(sub_proc2.substring(0,2) == "43"){
								//alert("일반 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
								//return;
							}
						}
						//41번 처리
						if(isNull(cells4.item(1).firstChild.nodeValue)){						
							if(sub_proc2.substring(0,2) == "41"){
								//alert("HI-CON 소둔사이클을 먼저 입력하신 후 통과공정을 추가하세요!");
								//return;
							}
						}				
				    }
			    } //end if ANN소둔 사이클..
			}
			grid.setUpdated(grid.getDhxGrid().getRowId(i),true,"updated"); 
		}
		
		
		dhtmlx.confirm({
			title:"통과공정저장",
			ok:"확인", cancel:"취소",
			text:"저장하시겠습니까?",
			callback:function(val){
				 if(val){
					 items['C104000020TAB08_Grid_1'].sendGrid('C104000020TAB08_Grid_1',"save");
			
					 for(var x=0; x< gridObj.getRowsNum(); x++){  //삭제 시 공정순서 에러체크
							proc_seq_max = gridObj.cellByIndex(x,0).getValue();		
					 
							if(gridObj.cellByIndex(x,0).getValue() == "")
								break;
							
							proc_seq_max_temp = proc_seq_max;
					}
					//2013.07.25 이돈석 - 공정 추가/삭제 시 순차조정을 위한 경고 메시지 추가
					//dhtmlx.alert("[알림]용융 및 전기도금 화면에서 S/T값,폭목표값,소둔Cycle등 각종 제조표준 정보를 추가하시기 바랍니다"); 
				 }else{
				 	dhtmlx.alert("취소되었습니다.");
				 }
				 return;
			 }
		});	
    }
	setTimeout('proc_seq_chk()',2500); //2초 이후에 공정 순서 체크(2013.10.02 이돈석)
}

function proc_seq_chk(){
	var grid = items['C104000020TAB08_Grid_1'];
	var gridObj = items['C104000020TAB08_Grid_1'].getDhxGrid();
	var proc_seq_last;  //최종 공정 순서(max)
	var proc_seq_last_temp; //최종 공정 순서(max) 임시 저장값
	var proc_fill_count = 0;  //공정이 들어가 있는 Row의 개수
	
	for(var x=0; x< gridObj.getRowsNum(); x++){  		
		proc_seq_last = gridObj.cellByIndex(x,0).getValue();
		if(proc_seq_last != ""){
			proc_seq_last_temp = proc_seq_last;	
		}else{
			break;
		}
		proc_fill_count = proc_fill_count + 1;
	}
	
	if(proc_seq_last_temp != proc_fill_count){
		dhtmlx.alert("공정삭제/추가로 인하여 통과공정 순서가 올바르지 않습니다.공정순서를 순서대로 정의하세요.");
	}
}


//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].getSelectionClear();
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB08_Grid_1','find'); 
	items['C104000020TAB08_Grid_1'].loadData(findUrl); 
}
//menu new row event function
function add(referenceItem){
	//품질설계 확정 이후에는 추가할수 없음...(2013.01.15)
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	var param1= "ServiceName=C104000020TAB08-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
	var cells1 = xmlObj1.getElementsByTagName("cell");
	if(cells1.length > 0){						
		dhtmlx.alert("확정된 주문입니다!");
		return;					
	}else{
    	items[referenceItem].addRow();
	}
}
//menu modify event function
function modify(referenceItem){
    	items[referenceItem].removeRow();
}
//menu remove event function
function remove(referenceItem){
	//품질설계 확정 이후에는 삭제할수 없음...(2013.01.15)
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	var param1= "ServiceName=C104000020TAB08-service&STS_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=ORD_NO";
	var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
	var cells1 = xmlObj1.getElementsByTagName("cell");
	if(cells1.length > 0){
		dhtmlx.alert("확정된 주문입니다!");
		return;
	}else{
    	items[referenceItem].removeRow();
    	resequenceProcSeq(referenceItem);
	}
}
//삭제 후 남은 통과공정의 순번(PROC_SEQ)을 1..N으로 재정렬 (2026.07.06 서재섭)
function resequenceProcSeq(referenceItem){
	var grid = items[referenceItem];
	var gridObj = grid.getDhxGrid();
	var newSeq = 1;
	for(var i=0; i< gridObj.getRowsNum(); i++){
		var rowId = gridObj.getRowId(i);
		var rowStatus = gridObj.getUserData(rowId, "!nativeeditor_status");
		if(rowStatus == "deleted"){
			continue;
		}
		var mainProc = gridObj.cellByIndex(i,1).getValue();
		var currentSeq = gridObj.cellByIndex(i,0).getValue();
		if(mainProc == "" && currentSeq == ""){
			continue;
		}
		if(String(currentSeq) != String(newSeq)){
			gridObj.cellByIndex(i,0).setValue(newSeq);
		}
		newSeq++;
	}
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
function onFormLoadEvent(){ 
	return true;
}
function findMessage(referenceItem){		
	uiCommon.message("C104000020TAB08_messagebox",referenceItem.getUserData("","appMsg"));
	return true;
}

function onGridLoadEvent(){ 
    var grid =  items['C104000020TAB08_Grid_1'];
	var gridObj = items['C104000020TAB08_Grid_1'].getDhxGrid();	
	var mainproccdCombo = gridObj.getColumnCombo(gridObj.getColIndexById('MAIN_PROC_CD')); //PLTCM5StandWRType
		mainproccdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PROC_CD&totalValue=&orderBy=value&displayType=all-code");   
		mainproccdCombo.enableOptionAutoPositioning(true);
		mainproccdCombo.readonly(true,true);
		mainproccdCombo.setOptionHeight(180);
	var subproccd1Combo = gridObj.getColumnCombo(gridObj.getColIndexById('SUB_PROC_CD1')); //PLTCM5StandWRType
		subproccd1Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PROC_CD&totalValue=&orderBy=value&displayType=all-code");   
		subproccd1Combo.enableOptionAutoPositioning(true);
		subproccd1Combo.readonly(true,true);
		subproccd1Combo.setOptionHeight(180);
	var subproccd2Combo = gridObj.getColumnCombo(gridObj.getColIndexById('SUB_PROC_CD2')); //PLTCM5StandWRType
		subproccd2Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PROC_CD&totalValue=&orderBy=value&displayType=all-code");   
		subproccd2Combo.enableOptionAutoPositioning(true);
		subproccd2Combo.readonly(true,true);
		subproccd2Combo.setOptionHeight(180);
	var subproccd3Combo = gridObj.getColumnCombo(gridObj.getColIndexById('SUB_PROC_CD3')); //PLTCM5StandWRType
		subproccd3Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PROC_CD&totalValue=&orderBy=value&displayType=all-code");   
		subproccd3Combo.enableOptionAutoPositioning(true);
		subproccd3Combo.readonly(true,true);
		subproccd3Combo.setOptionHeight(180);
	var subproccd4Combo = gridObj.getColumnCombo(gridObj.getColIndexById('SUB_PROC_CD4')); //PLTCM5StandWRType
		subproccd4Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PROC_CD&totalValue=&orderBy=value&displayType=all-code");   
		subproccd4Combo.enableOptionAutoPositioning(true);
		subproccd4Combo.readonly(true,true);
		subproccd4Combo.setOptionHeight(180);
	var subproccd5Combo = gridObj.getColumnCombo(gridObj.getColIndexById('SUB_PROC_CD5')); //PLTCM5StandWRType
		subproccd5Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PROC_CD&totalValue=&orderBy=value&displayType=all-code");   
		subproccd5Combo.enableOptionAutoPositioning(true);
		subproccd5Combo.readonly(true,true);
		subproccd5Combo.setOptionHeight(180);
	var subproccd6Combo = gridObj.getColumnCombo(gridObj.getColIndexById('SUB_PROC_CD6')); //PLTCM5StandWRType
		subproccd6Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PROC_CD&totalValue=&orderBy=value&displayType=all-code");   
		subproccd6Combo.enableOptionAutoPositioning(true);
		subproccd6Combo.readonly(true,true);
		subproccd6Combo.setOptionHeight(180);
	
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB08_Grid_1',"find"); 
	items['C104000020TAB08_Grid_1'].loadData(findUrl); 
	items['C104000020TAB08_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
	items['C104000020TAB08_Grid_1'].getDhxGrid().detachEvent(_onXLE);
		
	return false;
}

function onGridAfterUpdateFinishEvent(){
	var findUrl = uiCommon.parameters4('C104000020_Form_1','C104000020TAB08_Grid_1',"find"); 
	items['C104000020TAB08_Grid_1'].loadData(findUrl); 
	
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	var param10= "ServiceName=C104000020TAB08-service&PCNT_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + comboList.getSelectedValue() + "&column-info=PROC_CNT";

    var xmlObj10 = uiCommon.ajaxLoadData('c10AjaxData.do',param10);
    var cells10 = xmlObj10.getElementsByTagName("cell");
	var row_num = cells10.item(0).firstChild.nodeValue;

	//alert("row_num :" + row_num + "   proc_seq_max_temp :" + proc_seq_max_temp);
	/*
	if(proc_seq_max_temp != row_num)
	{
		 dhtmlx.alert("통과공정의 순서가 맞지 않습니다.조회 완료 후 공정순서를 변경하시기 바랍니다.")
	}
	*/
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
function setAutoData(id) {
	var gridObj = items['C104000020TAB08_Grid_1'].getDhxGrid();
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
	var seq = 0;
	
	items['C104000020TAB08_Grid_1'].getDhxGrid().cellById(id,9).setValue(parentForm.getItemValue("ORD_NO"));
	items['C104000020TAB08_Grid_1'].getDhxGrid().cellById(id,10).setValue(comboList.getSelectedValue());
	
	for(var i=0; i< gridObj.getRowsNum(); i++){
	    proc_seq = gridObj.cellByIndex(i,0).getValue();
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		if(proc_seq == "" && row_status == ""){
		    seq = i;
	    	break;
		}
        if(i == gridObj.getRowsNum() - 1)
            seq = i;		    
	}	
	items['C104000020TAB08_Grid_1'].getDhxGrid().cellById(id,0).setValue(seq);
}

function onFormLoadEvent1(){
	
	//통과공정 번호 보여주는 프로세스(2012.12.11추가)
	var parentForm = parent.items['C104000020_Form_1'];
	var ord_no = parentForm.getItemValue("ORD_NO");
	var ord_ln = parentForm.getItemValue("ORD_LN");
	
	if (ord_no != ""){
		var param1= "ServiceName=C104000020TAB08-service&PROC_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=PAS_PROC_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		var form1 =  items['C104000020TAB08_Form_1'];
		var pas_proc_no = (cells1.length > 0 && cells1.item(0).firstChild) ? cells1.item(0).firstChild.nodeValue : "";
		
		form1.setItemValue("PAS_PROC_NO",pas_proc_no);
	}	
	items['C104000020TAB08_Form_1'].getDhxForm().detachEvent(onXleForm);
}

function onEditCellEvent(stage,rId,cInd,nValue,oValue){
	var grid = items["C104000020TAB08_Grid_1"];
	var gridObj = items["C104000020TAB08_Grid_1"].getDhxGrid();
	if(stage==1){
		if(cInd == 0){ //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					if(!grid_qnty_check("순번",2,0,false,this.value)){						
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
		if(cells1.length > 0 && oValue != "" ){	//대체공정 추가는 가능..				
			dhtmlx.alert("확정된 통과공정을 삭제/수정 할 수 없습니다! 대체공정 추가는 가능.");
		    grid.setUpdated(rId, false, "")
		    return false;
		}
		
		if(cInd == 0){
			if(isNull(nValue)){
				dhtmlx.alert("순번은 필수 입니다!!");
				grid.setCellValue(rId,cInd,oValue);				
		    } 	
        }else if(cInd == 4 || cInd == 5 || cInd == 6 || cInd == 7){
        	if(nValue.substring(0,1) == '8' || nValue.substring(0,1) == '9'){
                dhtmlx.alert("도금공정은 대체공정2까지 지정 가능합니다.!!");
                grid.setUpdated(rId, false, "")
                return false;
        	}
        	
        }else{
			return true;
		}	
	}
   return true;
}

//통과공정 조회 버튼 클릭 시 실행되는 팝업 함수 
function chrProbtn(){
	var strPasProcNo = items['C104000020TAB08_Form_1'].getItemValue('PAS_PROC_NO');
	var strCclBomNo  = parent.items['C104000020_Form_2'].getItemValue("CCL_BOM_NO");

    if (strPasProcNo == null)
    {
    	dhtmlx.alert("통과공정 번호가 없습니다. ");
    }
    else
    {
		winObj = new ui.window('popup','통과공정 및 CCL-BOM 공정 조회','0','0','570','390','C104000020TAB08pop.jsp?PAS_PROC_NO='+strPasProcNo + '&CCL_BOM_NO='+strCclBomNo);
		winObj.setModal();
    }
}

//통과공정 이력 조회 버튼 클릭 시 실행되는 팝업 함수 
function chrProhstbtn(){
	var strOrdNo  = parent.items['C104000020_Form_1'].getItemValue("ORD_NO");
	var strOrdLn  = parent.items['C104000020_Form_1'].getItemValue("ORD_LN");

    if (strOrdNo == null || strOrdLn == null )
    {
    	dhtmlx.alert("주문번호가 없습니다. ");
    }
    else
    {
		winObj = new ui.window('popup','통과공정 이력조회','0','0','700','390','C104000020TAB08pop02.jsp?ORD_NO='+strOrdNo + '&ORD_LN='+strOrdLn);
		winObj.setModal();
    }
}
//]]>
-->
</script>
</head>
<body>
<div id="C104000020TAB08_Grid_1" style="position:absolute;height:357px;width:973px;left:1px;top:63px;">
</div>
<div id="C104000020TAB08_messagebox" style="position:absolute;height:19px;width:973px;left:1px;top:429px;">
</div>
<div id="C104000020TAB08_Menu_1" style="position:absolute;height:25px;width:973px;left:1px;top:37px;">
</div>
<div id="C104000020TAB08_Form_1" style="position:absolute;height:28px;width:974px;left:0px;top:3px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();
       var _onXLE = items['C104000020TAB08_Grid_1'].getDhxGrid().attachEvent("onXLE", onGridLoadEvent);
	   items["C104000020TAB08_Grid_1"].getDhxGrid().attachEvent("onRowAdded",setAutoData);
	   items["C104000020TAB08_Grid_1"].onEditCellEvent(onEditCellEvent);
	   var onXleForm = items['C104000020TAB08_Form_1'].getDhxForm().attachEvent("onXLE", onFormLoadEvent1);
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
		var dataProcessor = items["C104000020TAB08_Grid_1"].getDhxDataProcess();
		dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}
//]]>
-->
</script>