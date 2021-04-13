<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C104000050.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  품질설계확정
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  박 재 영
 * CREATE DATE      :  2011.12.23
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2011.12.23     V1.0      박재영      Initial Version
 * 변경일자        
--%>
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	PosUser	user		= (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String	userNo		= "";
	String	userName	= "";
	if(user!=null) {
		userNo = (String) user.getUserInfo("USER_NO");
		userName = (String) user.getUserInfo("USER_NAME");
	}
	//2020.08.22 김민섭  - 고객불만이력사무현장별항목제어기준(C10A2186)을 읽어 고객불만팝업 제어를 한다.
	String[] valList = {userNo, userName};
	String ctl_tp = ""; 
	try{
	//MASTER 기준 데이터를 읽어온다.
	PosRuleVO result = EasyAccess.getPosRule("C10A2186", valList, null);
	    
	    if(result.getRecordCount() > 0){
	    ctl_tp      = result.getRuleValueAt("TP");        //화면제어여부
	    }
	}catch(Exception e){
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
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000050_Form_1","xml":".\/header\/kr\/C104000050\/C104000050_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000050_Grid_1","service":"C104000050-service","actionType":"find","security":"true"},' +
      '{"itemType":"grid","renderTo":"C104000050_Grid_1","xml":".\/header\/kr\/C104000050\/C104000050_Grid_1.xml","rowCnt":"18","vertical":"true","url":"C104000050handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"4","referenceItem":"C104000050_Grid_1","service":"C104000050-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C104000050\/messagebox.xml","service":"C104000050-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":"./dhtmlx/codebase/imgs/"};
var columnList = "ORD_NO,ORD_LN,QLT_DSN_STS_CD,PLNT_TP,PRD_NM_CD,PRD_SHP,FLOW_CHL,ORD_KND,ORD_PRD_GRD,ORD_USG_CD,CUS_CD,ACT_CUS_CD,FNL_CUS_CD,CUS_BTH_PAP_NO,SPC_OFC,SPC_AVR,SPC_YR,SPC_NM,SPC_FUL_NM,ORD_SZ,ORD_EXC_THK,ORD_EXC_WTH,ORD_EXC_LTH,CUS_REQ_DLV_DD,ORD_SCH_DLV_DD,ORD_PTL_STR_DD,ORD_PTL_END_DD,GW_ASG_CD,CCL_BOM_NO,HUE_CD_FRN,HUE_CD_BAK,ORD_ORG_PLT_SPC_AVR,ORD_ROU_CD,ORD_SPNL_TP,ORD_COILG_MTH,ORD_SUR_HND_CD,ORD_SKP_DEG,ORD_EDG_ASG_TP,ORD_THK_TP,ORD_GRA,WGT_DCS_MTH_TP,ORD_SLV_KND_TP,EMBS_CD,ORD_PTT_FLM_DTL_CD,ORD_PTT_FLM_WTH,ORD_PTT_FLM_ADH_LOC_CD,ORD_WGT_UNT,ORD_LN_WGT,ORD_SHT_CNT,ORD_PAK_SHT_CNT,ORD_PAK_UNT_WGT_LLV,ORD_PAK_UNT_WGT_ULV,ORD_DLV_ALW_DIF_LLV,ORD_DLV_ALW_DIF_ULV,ORD_PAK_LTH_LLV,ORD_PAK_LTH_ULV,ORD_STDP_LLV,ORD_STDP_ULV,ORD_STDP_CNT_LLV,ORD_STDP_CNT_ULV,ORD_PAK_UNT_CNT,ORD_PAK_UNT_WGT,ORD_SML_PAK_WGT,ORD_SML_PAK_MIR,ORD_UNT_WGT,ORD_PAK_MTH,ORD_COIL_IDIA,ORD_COIL_ODIA,ORD_THK_TLN_LLV,ORD_THK_TLN_ULV,ORD_WTH_TLN_LLV,ORD_WTH_TLN_ULV,ORD_LTH_TLN_LLV,ORD_LTH_TLN_ULV,PNT_FLM_THK_FRN_TOT,PNT_FLM_THK_BAK_TOT,RSN_TP_FRN,RSN_TP_BAK,LUS_RT_CD_FRN,LUS_RT_CD_BAK,COT_MTH,CUS_REQ_ROL_THK,ORD_THK_MNG_CD,ORD_WTH_MNG_CD,ORD_LTH_MNG_CD,CUS_REQ_CLR_NM,URG_MTL_TP,ORD_RCP_DD,ORD_SHT_LOD_MTH,ORD_SLIT_GRP_CNT,ORD_MIX_WTH1,ORD_MIX_WTH2,ORD_MIX_WTH3,ORD_MIX_WTH4,ORD_MIX_WTH5,ORD_MIX_WTH6,ORD_MIX_WTH7,ORD_MIX_WTH8,SLIT_MAX_WGT,TRST_PROC_YN,TAG_TP,NAT_CD,ORD_SPC_TXT,TAG_PRD_NM,TAG_PO_NO,TAG_DST,TAG_SIZ,TAG_SPC_NM,TAG_GAA,TAG_HUE_FRN,TAG_HUE_BAK,TAG_SPC_MRK,RMTL_PRFR_CD,BAK_MRK,ORD_MDF_DD,ORD_CFM_DD,ORD_RGS_PRS_ID,ORD_TEM_CD,MTL_CD,CLS_CD,SUB_CLS_CD,QLT_DSN_END_DH,QLT_DSN_INST_DH,QLT_DSN_PRS_ID,MQL_CD,RMTL_CD,RMTL_GRD,CRM_MNF_STD_NO,PAS_PROC_NO,ACPT_RT_SPC,ORD_END_TP,ORD_END_DD,ORD_END_PRS_ID,QLT_DSN_CFM_DH,QLT_DSN_CFM_PRS_ID,QLT_RDSN_DH,QLT_RDSN_PRS_ID,QLT_DSN_ERR_YN,QLT_DSN_YN,QLT_DSN_CFM_TP,RMTL_CD1,RMTL_CD2,CRM_MNF_STD_NO1,CRM_MNF_STD_NO2,ORD_CNL_CAU_CD,ORD_CNL_DTL_TXT,THK_COR_UNT,PRD_THK_CAL_APL_CD,APR_INP_BAS_CD,TAG_PO_NO2,CTR_SHPM_MN,SVC_CRD_PUB_YN,PAK_MSG_CD,ORD_TEM_GRP_CD,ORD_MIX_WTH9,ORD_MIX_WTH10,PTT_FLM_NOT_ADH_WS,PTT_FLM_NOT_ADH_DS,TAG_PART_NO,MO_CVT_ORD_YN,PER_TON_LTH,ORD_BAK_SND_TP,ORD_BAK_SND_PRS_ID,ORD_BAK_SND_DH,ORD_BAK_SND_CAU,MTL_PRD_ORD_YN,ORD_PAK_MTL_WGT,QLT_DSN_TXT,ORD_DSN_CFM_TP,DSN_ATO_CFM_YN,DSN_ATO_CFM_DH,DSN_ATO_CFM_PRS_ID,QLT_HLD_YN,LTH_MNG_YN,LTH_MNG_FROM,LTH_MNG_TO,BORON_ADD_YN,ORD_REP_YN,ORD_REP_NO,ORD_REP_LN,ORD_COP_STP,WIP_PAK_MTH";
var winPop;
//form find button item event function (requred)
var renderCnt = 0;
function find(eventName){
	items['C104000050_Grid_1'].getDhxDataProcess().updatedRows = [];
	// 날짜 관련 폼 데이터
	var fromDate = items['C104000050_Form_1'].getItemValue('QLT_DSN_INST_DH_STR');
	var toDate = items['C104000050_Form_1'].getItemValue('QLT_DSN_INST_DH_END');
	
	// 조회구분
	var stsCd  = items['C104000050_Form_1'].getDhxForm().getItemValue('QLT_DSN_STS_CD');
	
	// 입력받을 타입을 검사
	fromDate = get_DateTypeDay(fromDate);
	toDate = get_DateTypeDay(toDate);
	
	if(fromDate == '' || toDate == ''){
		dhtmlx.alert({
            ok:"확인",
            text:"설계완료일자를 입력하지 않았습니다!",
            callback:function(val){
              if(val){
                items['C104000050_Form_1'].setItemFocus('QLT_DSN_INST_DH_STR');
              }
           }
      	});
	  return ;
	}
	if(fromDate > toDate){
		dhtmlx.alert({
            ok:"확인",
            text:"설계완료일자를 잘못 입력하였습니다!",
            callback:function(val){
              if(val){
                items['C104000050_Form_1'].setItemFocus('QLT_DSN_INST_DH_STR');
              }
           }
      	});
		return ;
	}
	
	//품질설계 확정대기, 설계오류 동시에 보여줌 (2020.2.12 이상현대리요청)
	if(stsCd == 'B'){
		var findUrl = uiCommon.parameters('C104000050_Form_1','C104000050_Grid_1','findBsts');
		items['C104000050_Grid_1'].loadData(findUrl,findAfterEvent);
	}else{
		var findUrl = uiCommon.parameters('C104000050_Form_1','C104000050_Grid_1','find');
		items['C104000050_Grid_1'].loadData(findUrl,findAfterEvent);
	}
}

function save(eventName,formDivObj,referenceItem){
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	var selectRowId = gridObj.getSelectedRowId();
	gridObj.selectRowById(selectRowId);
	var grid_cnt = gridObj.getRowsNum();	
	var QLT_DSN_STS_CD = "";  
	var ORD_BAK_SND_TP = "";  
	var QLT_HLD_YN = "";
	var chgCnt = 0;
	var ord_no = '';					
	var ord_ln = '';		
	var param = "";
	var xmlObj = "";
	var cells = "";
	
	for(var i=0; i< grid_cnt; i++){
		var row_status 			= gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status")
		var checkVal = items['C104000050_Grid_1'].getCellValue(gridObj.getRowId(i),0);
		
		if(row_status != ""){
			chgCnt++;		
			if(checkVal == 1){
				ord_no = gridObj.cellByIndex(i,gridObj.getColIndexById("ORD_NO")).getValue();
				ord_ln  = gridObj.cellByIndex(i,gridObj.getColIndexById("ORD_LN")).getValue();
				param= "ServiceName=C104000050-service&BRY_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=QLT_DSN_STS_CD,ORD_BAK_SND_TP,QLT_HLD_YN";						
				xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);						
				cells = xmlObj.getElementsByTagName("cell");						
				if(cells.length > 0){
					QLT_DSN_STS_CD = cells.item(0).firstChild.nodeValue;
					ORD_BAK_SND_TP = cells.item(1).firstChild.nodeValue;
					QLT_HLD_YN = cells.item(2).firstChild.nodeValue;
					if(QLT_DSN_STS_CD != "B"){ 
						dhtmlx.alert("주문: "+ord_no+"-"+ord_ln+"의 설계상태가 확정대기가 아니기에 설계확정 대상이 아닙니다!");					
					}else if(ORD_BAK_SND_TP == "R"){
						dhtmlx.alert("주문: "+ord_no+"-"+ord_ln+"이 반송된 주문이기에 설계확정 대상이 아닙니다!");					
					}else if(QLT_HLD_YN == "Y"){
						dhtmlx.alert("주문: "+ord_no+"-"+ord_ln+"의 품질설계가 보류 상태이기에 설계확정 대상이 아닙니다!");					
					}
		  			items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
		  			items['C104000050_Grid_1'].setUpdated(gridObj.getRowId(i),false,""); 			
					return;					
				}	

			} 
		}
   }

	if(chgCnt == 0 ){
	  	dhtmlx.alert("확정할 데이터가 없습니다.");
		return;
	}else{
		dhtmlx.confirm({
			title:"품질설계확정",
			ok:"확인", cancel:"취소",
			text:"확정하시겠습니까?",
			callback:function(val){
				 if(val){
					 items[referenceItem].sendGrid(referenceItem,eventName);	
				 }
			}
		});	
	}
//    items[referenceItem].send(items[referenceItem].getServerProcessUrl(),items[referenceItem].getActivityServiceName(),eventName);
}

function send(eventName,formDivObj,referenceItem){
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	var selectRowId = gridObj.getSelectedRowId();
        gridObj.selectRowById(selectRowId);
	var grid_cnt = gridObj.getRowsNum();	
	var ORD_BAK_SND_TP = '' , chgCnt = 0;
	for(var i=0; i< grid_cnt; i++)
	{
		var row_status 			= gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
		var checkVal  = items['C104000050_Grid_1'].getCellValue(gridObj.getRowId(i),0);
		var checkVal1 = items['C104000050_Grid_1'].getCellValue(gridObj.getRowId(i),9);
		var checkVal2 = gridObj.cellByIndex(i,gridObj.getColIndexById("QLT_DSN_STS_CD")).getValue();
		var ORD_BAK_SND_CAU =  gridObj.cellByIndex(i,gridObj.getColIndexById("ORD_BAK_SND_CAU")).getValue();
			ORD_BAK_SND_TP  =  gridObj.cellByIndex(i,gridObj.getColIndexById("ORD_BAK_SND_TP")).getValue();

		if(row_status != "")
		{
			chgCnt++;
			if(checkVal == 1){
				    if(ORD_BAK_SND_TP == "R"){
			  			dhtmlx.alert("이미 주문반송된 건 입니다.");	
		    			gridObj.setRowTextStyle(gridObj.getRowId(i), "color: red;");		
		    			items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
		    			return;				    	
				    }else if(checkVal2 == "A"){
			  			dhtmlx.alert("이미 확정된 주문입니다.");	
			    			items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
			    			return;
			    	}else if(ORD_BAK_SND_CAU ==""){
			    			dhtmlx.alert("주문반송시 반송사유는 필수입력입니다.");	
			    			items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
			    			//items['C104000050_Grid_1'].setUpdated(gridObj.getRowId(i),false,""); 			
			    			return;
			    	}		
			}else
			{
				if(ORD_BAK_SND_CAU !== "")
				{
					dhtmlx.alert("선택되지 않은 주문에 반송사유 정보가 입력되어 있습니다.");
					items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
	    			return;
				}else{
					dhtmlx.alert("다시 조회 후 작업하시기 바랍니다.");
					items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
	    			return;
				}
			}	
		}
    }
	
	if(chgCnt == 0 ){
		dhtmlx.alert("반송할 데이터가 없습니다.");
		return;
	}else{
		dhtmlx.confirm({
			title:"주문반송",
			ok:"확인", cancel:"취소",
			text:"반송 하시겠습니까?",
			callback:function(val){
				if(val){
					 items[referenceItem].sendGrid(referenceItem,eventName);	
				}
			}
		});	
	}
//    items[referenceItem].send(items[referenceItem].getServerProcessUrl(),items[referenceItem].getActivityServiceName(),eventName);
}

function resend(eventName,formDivObj,referenceItem){
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	var selectRowId = gridObj.getSelectedRowId();
	gridObj.selectRowById(selectRowId);
	var grid_cnt = gridObj.getRowsNum();	
	var ORD_BAK_SND_TP = '';
	for(var i=0; i< grid_cnt; i++){
	  var checkVal = items['C104000050_Grid_1'].getCellValue(gridObj.getRowId(i),0);
		var cellVal = items['C104000050_Grid_1'].getCellValue(gridObj.getRowId(i),10);
		ORD_BAK_SND_TP =  gridObj.cellByIndex(i,gridObj.getColIndexById("ORD_BAK_SND_TP")).getValue();
	   if(checkVal == 1 && cellVal !="A"){
	  		if(ORD_BAK_SND_TP != "R"){
	  			dhtmlx.alert("반송취소 대상건이 아닙니다.");	
	  			items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
	  			items['C104000050_Grid_1'].setUpdated(gridObj.getRowId(i),false,""); 			
	  			return;
	  		}		
	  	}	
   }


	dhtmlx.confirm({
		title:"반송취소",
		ok:"확인", cancel:"취소",
		text:"반송취소 하시겠습니까?",
		callback:function(val){
		 if(val){
			 items[referenceItem].sendGrid(referenceItem,eventName);	
		 }else{
		   dhtmlx.alert("취소되었습니다.");
		 }
		}
	});	
//    items[referenceItem].send(items[referenceItem].getServerProcessUrl(),items[referenceItem].getActivityServiceName(),eventName);
}

function redesign(eventName,formDivObj,referenceItem){
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	var selectRowId = gridObj.getSelectedRowId();
	gridObj.selectRowById(selectRowId);
	var grid_cnt = gridObj.getRowsNum();	
	var QLT_DSN_STS_CD = "";  
	var ORD_BAK_SND_TP = "";  
	var QLT_HLD_YN = "";
	var chgCnt = 0;
	var ord_no = '';					
	var ord_ln = '';		
	var param = "";
	var xmlObj = "";
	var cells = "";
	
	for(var i=0; i< grid_cnt; i++){
		var row_status 			= gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status")
		var checkVal = items['C104000050_Grid_1'].getCellValue(gridObj.getRowId(i),0);
		
		if(row_status != ""){
			chgCnt++;		
			if(checkVal == 1){
				ord_no = gridObj.cellByIndex(i,gridObj.getColIndexById("ORD_NO")).getValue();
				ord_ln  = gridObj.cellByIndex(i,gridObj.getColIndexById("ORD_LN")).getValue();
				param= "ServiceName=C104000050-service&BRY_find=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=QLT_DSN_STS_CD,ORD_BAK_SND_TP,QLT_HLD_YN";						
				xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);						
				cells = xmlObj.getElementsByTagName("cell");						
				if(cells.length > 0){
					QLT_DSN_STS_CD = cells.item(0).firstChild.nodeValue;
					
					// 2020.12.08 오류수정
					if(QLT_DSN_STS_CD == "A"){ 
						dhtmlx.alert("주문: "+ord_no+"-"+ord_ln+"는 확정상태라 재설계가 불가합니다!");
						items['C104000050_Grid_1'].setCellValue(gridObj.getRowId(i),0,0);
			  			items['C104000050_Grid_1'].setUpdated(gridObj.getRowId(i),false,""); 			
						return;	
					}
			
				}	

			} 
		}
   }

	if(chgCnt == 0 ){
	  	dhtmlx.alert("재설계할 대상을 선택해주세요");
		return;
	}else{
		
		var param= "ServiceName=C104000050-service&job_sts=1&column-info=JOB_STS";
		var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		var cells = xmlObj.getElementsByTagName("cell");
		if(cells.length > 0){						
			dhtmlx.alert("품질설계JOB이 진행중입니다. 잠시 후 진행하세요!");
			return;					
		}
		
		dhtmlx.confirm({
			title:"재설계",
			ok:"확인", cancel:"취소",
			text:"재설계 하시겠습니까?",
			callback:function(val){
				 if(val){
					 items[referenceItem].sendGrid(referenceItem,'redesign');	
				 }
			}
		});	
	}

}

function reconfirm(eventName,formDivObj,referenceItem){
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var row_status ="", row_cnt=0;
	for(var i=0; i< grid_cnt; i++)
	{
    	row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
    	if(!isNull(row_status)){
       		row_cnt++;
     	}
	}
	
	if(row_cnt==0){
		dhtmlx.alert("자동설계 재확정 대상을 선택해주세요.");
  		return;  
	}
	
	/*
	for(var i=0;i<gridObj.getRowsNum();i++){
	    var stat = gridObj.cellByIndex(i,10).getValue();

		if(stat.substring(0,1) = "B" && stat.substring(0,1) = "E")				
		{
			alert("확정대상이나 설계에러는 재확정 할 수 없습니다.");
	  		return;
		}
	}
	*/

		dhtmlx.confirm(
				{
					title:"[[ 확인 ]]",
					ok:"확인", cancel:"취소",
					text:"재확정 하시겠습니까?",
					callback:function(val)
					{
						if(val)
						{
							items[referenceItem].sendGrid(referenceItem,'reconfirm');
							return;
						}
					}
				}
		);
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event	
	items[referenceItem].refresh("find");
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
function findMessage(referenceItem){		
	uiCommon.message(ui.messagebox.messageBoxDivId,referenceItem.getUserData("","appMsg"));
	return true;
}
function onFormLoadEvent(){
	renderCnt++;
	items['C104000050_Form_1'].setItemValue("QLT_DSN_INST_DH_STR",getCurrentMinusDay('-',1,'YYYYMMDD'));
	items['C104000050_Form_1'].setItemValue("QLT_DSN_INST_DH_END",uiCommon.getCurrentDate());
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	var fromDate = items['C104000050_Form_1'].getItem("QLT_DSN_INST_DH_STR").setWeekStartDay(7);
	var toDate = items['C104000050_Form_1'].getItem("QLT_DSN_INST_DH_END").setWeekStartDay(7);
	
	items['C104000050_Form_1'].setItemValue("QLT_DSN_STS_CD", "B"); //radio setting

	var comboList = items['C104000050_Form_1'].getMasterCombos();
	var formObj = items['C104000050_Form_1'].getDhxForm();
	
	var inputObj = items["C104000050_Form_1"].getDhxForm().getInput("ORD_NO");
	inputObj.onkeyup = function(){
  		inputObj.value = inputObj.value.toUpperCase(); 	
	}

	comboList['PRD_NM_CD'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value',function(){
	  comboList['PRD_NM_CD'].selectOption(0,true,true);
	  comboList['PRD_NM_CD'].setOptionHeight(240);
	});
	//comboList['PRD_NM_CD'].setOptionHeight(300);
	comboList['PRD_NM_CD'].DOMelem_input.onkeydown = function(e){
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
	
	comboList['PROC_CD'].readonly(true,false);
	ui.combo.master(comboList['PROC_CD'],'SZ0061','PROC_CD','totalValue=,orderBy=value',function(){
	  comboList['PROC_CD'].selectOption(0,true,true);
	  comboList['PROC_CD'].setOptionHeight(200);
	});

	var inputORD_USG_CD = items["C104000050_Form_1"].getDhxForm().getInput("ORD_USG_CD");
	inputORD_USG_CD.onkeyup = function(){
		inputORD_USG_CD.value = inputORD_USG_CD.value.toUpperCase(); 	
	}
	var inputSPC_AVR = items["C104000050_Form_1"].getDhxForm().getInput("SPC_AVR");
	inputSPC_AVR.onkeyup = function(){
		inputSPC_AVR.value = inputSPC_AVR.value.toUpperCase(); 	
	}	
	var inputCUS_CD = items["C104000050_Form_1"].getDhxForm().getInput("CUS_CD");
	inputCUS_CD.onkeyup = function(){
		inputCUS_CD.value = inputCUS_CD.value.toUpperCase(); 	
	}
	
	////////주문등록자가 자동으로 나오게 콤보박스 추가 2015.3.18 박성용기사 요청
	/*
	var comboList = items["C104000050_Form_1"].getMasterCombos();//comboList 객체 생성 구문
	comboList['ORD_RGS_PRS_NAME'].readonly(true,true);//ORD_RGS_PRS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	
	var fromDate1 = items['C104000050_Form_1'].getDhxForm().getItemValue('QLT_DSN_INST_DH_STR');
	var toDate1 = items['C104000050_Form_1'].getDhxForm().getItemValue('QLT_DSN_INST_DH_END');

	//고객사 콤보박스 (지정된 SQL로 콤보불러 오기) 
	ui.combo(comboList['ORD_RGS_PRS_NAME'],"OrdlnComboData.do"
	,"ServiceName=C104000050-service&findItem=0&column-info=ORD_RGS_PRS_ID,ORD_RGS_PRS_NAME&QLT_DSN_INST_DH_STR="+fromDate1+"&QLT_DSN_INST_DH_END="+toDate1,function(){ 
	  comboList['ORD_RGS_PRS_NAME'].selectOption(0,true,true);
	  comboList['ORD_RGS_PRS_NAME'].readonly(true);
	  comboList['ORD_RGS_PRS_NAME'].DOMelem_input.focus();
	});
	*/
	////////

	var inputObj = formObj.getInput("CCL_BOM_NO");
		inputObj.onkeyup = function(e){
			if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
			  inputObj.value = inputObj.value.toUpperCase();
			}	
			e = e||window.event;
			if(e.keyCode == 13){
				formObj.setItemValue("CCL_BOM_NO",inputObj.value);
				find("find","C104000050_Form_1","C104000050_Grid_1");			
			}
		}
		
	if(renderCnt >1) {
			find('findBsts','C104000050_Form_1','C104000050_Grid_1');
	}

	items['C104000050_Form_1'].getDhxForm().detachEvent(onXleForm);
	

		
	return true;
}

function OnDataChanged(id,value){
	var fromDate = items['C104000050_Form_1'].getDhxForm().getItemValue('QLT_DSN_INST_DH_STR');
	var toDate = items['C104000050_Form_1'].getDhxForm().getItemValue('QLT_DSN_INST_DH_END');
	
	/*
	var comboList = items['C104000050_Form_1'].getMasterCombos();//comboList 객체 생성 구문
	comboList['ORD_RGS_PRS_NAME'].readonly(true,true);//FNL_CUS_NAME : Form에 comboList 배치할 때 지정해 준 NAME
	ui.combo(comboList['ORD_RGS_PRS_NAME'],"OrdlnComboData.do"
	,"ServiceName=C104000050-service&findItem=0&column-info=ORD_RGS_PRS_ID,ORD_RGS_PRS_NAME&QLT_DSN_INST_DH_STR="+fromDate+"&QLT_DSN_INST_DH_END="+toDate);
	*/
	
	/*
	var ORD_NO = items['C104000060_Form_1'].getItemValue("ORD_NO");
	var comboList1 = items['C104000060_Form_1'].getMasterCombos();
	comboList1['ORD_LN'].readonly(false,false);
	ui.combo(comboList1['ORD_LN'],"OrdlnComboData.do","ServiceName=C104000060-service&OrdLnFind=1&column-info=ORD_LN,ORD_LN&ORD_NO="+ORD_NO);
	*/	
	
return true;
}

function onGridLoadEvent(){
	renderCnt++;
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	var qlt_hld_yn;
	/*
	for(var i=0;i<gridObj.getRowsNum();i++)
	{
		
		var stat = grid.cellByIndex(i,10).getValue();
		if(stat == "")
		{
	        grid.cellByIndex(i, 0).setDisabled(true);
			continue;
		}
		if(stat.substring(0,1) != "B" && stat.substring(0,1) != "E")				
		{
	        grid.cellByIndex(i, 0).setDisabled(true);
		}
		else grid.cellByIndex(i, 0).setDisabled(false);
		
	}*/
	//find('find','C104000050_Form_1','C104000050_Grid_1');
	if(renderCnt >1) {
		find('findBsts','C104000050_Form_1','C104000050_Grid_1');
	}
	
	gridObj.detachEvent(onXleGrid);

}

function setTextColor(){
	//조건에 따른 글자색 변경
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var qlt_hld_yn;
	
	for(var i=0; i<grid_cnt; i++){
		qlt_hld_yn = gridObj.cellById(gridObj.getRowId(i),gridObj.getColIndexById("QLT_HLD_YN")).getValue();
		//보류인 경우 붉은색으로 필드 표시 및 체크박스 비활성
		if(qlt_hld_yn == "Y"){
			gridObj.setRowTextStyle(gridObj.getRowId(i), "color: red;");
			//gridObj.cellByIndex(gridObj.getRowIndex(i), gridObj.getColIndexById("QLT_DSN_CFM")).setDisabled(true);
			gridObj.cellByIndex(i, 0).setDisabled(true);
		}
	}
}

function dateAdd(date, addDay) {
 
    var nowDate = date;
    var addDate = nowDate.getTime() + (addDay * 24 * 60 * 60 * 1000);
    nowDate.setTime(addDate);
 
    var year = nowDate.getFullYear();
    var month = nowDate.getMonth() + 1;
    var date = nowDate.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
 
    return year + "-" + month + "-" + date;
 
}
function onCheckEvent(row_id, cell_index, state){ 
	if(state)
    {
    	items['C104000050_Grid_1'].setUpdated(row_id,true,"updated"); 
    }
    else
    {
    	items['C104000050_Grid_1'].setUpdated(row_id,false,"");    
    }
}
function onCheckboxHeaderClick(ind,obj){
   if(ind === 0){
    var checked=items['C104000050_Grid_1'].getCheckedRows(0);
    if(checked.length > 0){
     items["C104000050_Grid_1"].uncheckAll();
    }else{
     items["C104000050_Grid_1"].checkAll();  
    }   
  }
  return true;
}
function doOnRowDblClicked(rowId,cellIndex) {
// 	var ORD_NO = items['C104000050_Grid_1'].getDhxGrid().cells(rowId,2).getValue();
// 	var ORD_LN = items['C104000050_Grid_1'].getDhxGrid().cells(rowId,3).getValue();
// 	var QLT_DSN_STS_CD = items['C104000050_Grid_1'].getDhxGrid().cells(rowId,11).getValue();
	
	var ORD_NO = items['C104000050_Grid_1'].getDhxGrid().cells(rowId,3).getValue();
	var ORD_LN = items['C104000050_Grid_1'].getDhxGrid().cells(rowId,4).getValue();
	var QLT_DSN_STS_CD = items['C104000050_Grid_1'].getDhxGrid().cells(rowId,12).getValue();
	
	if(QLT_DSN_STS_CD == "") return;
	
	if(cellIndex == 24){
	  items['C104000050_Grid_1'].getDhxGrid().setCellExcellType(items['C104000050_Grid_1'].getDhxGrid().getSelectedRowId(),22, "ed"); //반송원인 ed로 변경	
	}else{
  	if(QLT_DSN_STS_CD.substring(0,1) == "E")
  	{
  	  parent.newRemoveOpenTab("C104000030","ORD_NO=" + ORD_NO + "&ORD_LN=" +ORD_LN);	
  	}
  	else{ 
  	  parent.newRemoveOpenTab("C104000020","ORD_NO=" + ORD_NO + "&ORD_LN=" +ORD_LN);
  	}
  }
  return true;
}
function winClose(){
	if(typeof(parent.winObj) !== 'undefined'){
		parent.winObj.winClose();					
	}else{
		parent.tabClose();
	}
}

function findAfterEvent(){
	var grid = items['C104000050_Grid_1'].getDhxGrid();
	var ORD_BAK_SND_TP = '';
	var qlt_hld_yn;
	
	uiCommon.message(ui.messagebox.messageBoxDivId,grid.getUserData("","appMsg"));
	
	for(var i=0;i<grid.getRowsNum();i++)
	{
   
	    ORD_BAK_SND_TP =  grid.cellByIndex(i,grid.getColIndexById("ORD_BAK_SND_TP")).getValue();
	    qlt_hld_yn = grid.cellByIndex(i,grid.getColIndexById("QLT_HLD_YN")).getValue();
	    

		//보류 or 반송인 경우는 붉은 색으로 표시 및 설계확정을 위한 체크박스 비활성
		if(ORD_BAK_SND_TP == "R" || qlt_hld_yn == "Y"){
		  grid.setRowTextStyle(grid.getRowId(i),"color:red;");
		  grid.cellByIndex(i,0).setDisabled(true);
		}
		
	}
	return true;
}

function onGridAfterUpdateFinishEvent(){
	 find('find','C104000050_Form_1','C104000050_Grid_1');
}

function serchIcon_ORD_USG_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('ORD_USG_CD','SZ0000','ORD_USG_CD','C104000050_Form_1');\">";
}
function serchIcon_CUS_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C104000050_Form_1');\">";
}
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}


function excelExport(eventName,formDivObj,referenceItem){
	var findUrl = parameters13(formDivObj,eventName, 'excelExportC104000050.do',columnList);
	win = window.open(findUrl, "GGGG", "width=310,height=300,scrollbars=yes"); 
}

function parameters13(){
    if(arguments.length < 1 || arguments.length < 2 || arguments.length <3){
      dhtmlx.alert("function arguments setting not found<br>"+
            "arguments[0] : form div object id<br>"+
            "arguments[1] : event name<br>"+
            "arguments[2] : ServiceUrl<br>"+
            "arguments[3] : columnInfol\n");
      return true;
    }  
   
     var _data = [];
     /** activity serviceName push */
     _data.push(arguments[2]+"?ServiceName="+items[arguments[0]].getServiceName());
     /** activity event push */
     _data.push(arguments[1]+"=1");
     /** dhtmlx item type 에 대한 key,value 추출 calendar는 data를 추출하는 방법이 다름 */
     uiCommon.formParameter(_data,items[arguments[0]].getDhxForm()); 
     /** item 에 대한 rendering 을 하기위한 정보 */
     
     _data.push("column-info="+arguments[3]);
             
     return _data.join("&");
}

function doLink(val,rId,cInd){
	var gridObj = items['C104000050_Grid_1'].getDhxGrid();
	if (cInd == gridObj.getColIndexById('CUS_CMPL_HST_YN')) {
		var CCL_BOM_NO = items['C104000050_Grid_1'].getCellValue(rId,gridObj.getColIndexById("CCL_BOM_NO"));
		var FNL_CUS_CD = items['C104000050_Grid_1'].getCellValue(rId,gridObj.getColIndexById("FNL_CUS_CD")).substr(0,6);
		var PRD_NM_CD = items['C104000050_Grid_1'].getCellValue(rId,gridObj.getColIndexById("PRD_NM_CD"));
        if([].slice.call(document.getElementsByClassName("dhtmlx_wins_title")).filter(function(f){return f.innerText=="고객불만이력"}).length==1){
        	winPop.winClose();
        }
		if("<%=ctl_tp%>" == '1' || "<%=ctl_tp%>" == '2'){
			if(CCL_BOM_NO==null){
				CCL_BOM_NO="";
			}
			popUrl = parent.customPopupLinkUrl('C107000070pop01', 'CCL_BOM_NO=' + CCL_BOM_NO + '&FNL_CUS_CD=' +FNL_CUS_CD+'&PRD_NM_CD='+PRD_NM_CD);
			winPop = new ui.window('popup','고객불만이력','0','0','619','505',popUrl);
		} else{
			// 업무기준에 등록되지 않은 사용자는 팝업버튼허용X
		}
	}
}

function parentPop(CUS_CMPL_NO,CUS_CMPL_LN){
	popUrl = parent.customPopupLinkUrl('C107000070pop02', 'CUS_CMPL_NO=' + CUS_CMPL_NO + '&CUS_CMPL_LN=' +CUS_CMPL_LN);
	winObj = new ui.window('popup','고객불만 상세보기','0','0','1200','800',popUrl);
}

//]]>
-->
</script>
</head>
<body>
<div id="C104000050_Form_1" style="position:absolute;height:76px;width:981px;left:0px;top:0px;">
</div>
<div id="C104000050_Grid_1" style="position:absolute;height:475px;width:977px;left:-6px;top:83px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();          
    var onXleForm = items['C104000050_Form_1'].onXLEEvent(onFormLoadEvent);
    //items["C104000050_Grid_1"].onHeaderClickEvent(onCheckboxHeaderClick);
	var onXleGrid= items['C104000050_Grid_1'].onXLEEvent(onGridLoadEvent);
    items['C104000050_Grid_1'].onCheckboxEvent(onCheckEvent);
	items['C104000050_Grid_1'].getDhxGrid().attachEvent("onRowDblClicked", doOnRowDblClicked);
    items['C104000050_Form_1'].setBackgroundColor("#FFFFFF");
    items["C104000050_Grid_1"].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
    items['C104000050_Form_1'].getDhxForm().attachEvent('onChange', OnDataChanged);
    //items['C104000050_Grid_1'].onXLEEvent(setTextColor);
	   
//]]>
-->
</script>