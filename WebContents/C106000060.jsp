<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME      :  C106000060.jsp
 * VERSION                  :  V1.0
 * DESCRIPTION           :  CCL-BOM관리
 * DESIGNER NAME      :  한윤섭
 * DEVELOPER NAME   :  이민균
 * CREATE DATE          :  2012.01.04
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.01.04     V1.0      이민균     Initial AVersion
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String CCL_BOM_NO = request.getParameter("CCL_BOM_NO") != null
			? request.getParameter("CCL_BOM_NO")
			: "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>CCL-BOM관리</title>
<style media="screen" type="text/css">
/*custom styling for the first column*/
.form_cell {
	background-image: url(./dhtmlx/codebase/imgs/sky_blue_grid.gif);
	/*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
	border-color: #FDFDFD #BABABA #BABABA #FDFDFD !important;
	border-style: solid !important;
	border-width: 1px !important;
}

.form_cell1 {
	background-image: url(./dhtmlx/codebase/imgs/clouds_grid.gif);
	/*border-color:#FDFDFD #93AFBA #93AFBA #FDFDFD !important;*/
	border-color: #FDFDFD #BABABA #BABABA #FDFDFD !important;
	border-style: solid !important;
	border-width: 1px !important;
}

.even {
	background-color: #FFFFFF;
}

.uneven {
	background-color: #FFFFFF;
}

div.gridbox_dhx_skyblue.odd_dhx_skyblue {
	background-color: #FFFFFF;
}

html,body {
	width: 90%;
	height: 90%;
}
</style>
<script type="text/javascript"
	src="./dhtmlx/codebase/glue.ui.bootstrap.js">
</script>
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var rowIndex;  //칼라물성에서 선택된 Row의 index를 저장하기 위한 변수(2016.1.15)
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000060_Form_1","xml":".\/header\/kr\/C106000060\/C106000060_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000060_Grid_1","service":"C106000060-service","actionType":"save","security":"true"},' +
      '{"itemType":"menu","renderTo":"C106000060_Menu_1","xml":".\/header\/kr\/C106000060\/C106000060_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000060_Grid_1","service":"C106000060-service"},' +
      '{"itemType":"form","renderTo":"C106000060_Form_2","xml":".\/header\/kr\/C106000060\/C106000060_Form_2.xml","url":"basicGridData.do","referenceItem":"C106000060_Grid_1","service":"C106000060-service","actionType":"save","security":"true"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_1","xml":".\/header\/kr\/C106000060\/C106000060_Grid_1.xml","rowCnt":"3","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"menu","renderTo":"C106000060_Menu_2","xml":".\/header\/kr\/C106000060\/C106000060_Menu_2.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000060_Grid_2","service":"C106000060-service"},' +
      '{"itemType":"form","renderTo":"C106000060_Form_3","xml":".\/header\/kr\/C106000060\/C106000060_Form_3.xml","url":"basicGridData.do","referenceItem":"C106000060_Grid_2","service":"C106000060-service"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_2","xml":".\/header\/kr\/C106000060\/C106000060_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_3","xml":".\/header\/kr\/C106000060\/C106000060_Grid_3.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_4","xml":".\/header\/kr\/C106000060\/C106000060_Grid_4.xml","rowCnt":"1","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_9","xml":".\/header\/kr\/C106000060\/C106000060_Grid_9.xml","rowCnt":"1","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_5","xml":".\/header\/kr\/C106000060\/C106000060_Grid_5.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000060_messagebox","xml":".\/header\/kr\/C106000060\/messagebox.xml","service":"C106000060-service"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_6","xml":".\/header\/kr\/C106000060\/C106000060_Grid_6.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_7","xml":".\/header\/kr\/C106000060\/C106000060_Grid_7.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"},' +
      '{"itemType":"grid","renderTo":"C106000060_Grid_8","xml":".\/header\/kr\/C106000060\/C106000060_Grid_8.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000060_Form_1","service":"C106000060-service","actionType":"save"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var columnListForExcelExport = "CCL_BOM_NO,CCL_BOM_USE_YN,COT_MTH,COL_SUR_HND_CD,PRT_PTN_CD,HUE_CD_FRN,HUE_CD_BAK,HUE_CD_SUB,HUE_CD_CHM,PNT_FLM_THK_FRN_TOT,PNT_FLM_THK_BAK_TOT,LUS_RT_CD_FRN,LUS_RT_CD_BAK,RSN_TP_FRN,RSN_TP_BAK,DTL_CLR_NM,RSN_TP_FRN_1COT,RSN_TP_FRN_2COT,RSN_TP_FRN_3COT,RSN_TP_FRN_4COT,RSN_TP_BAK_1COT,RSN_TP_BAK_2COT,RSN_TP_BAK_3COT,RSN_TP_BAK_4COT,RSN_TP_LMN,HUE_CD_FRN_1COT,HUE_CD_FRN_2COT,HUE_CD_FRN_3COT,HUE_CD_FRN_4COT,HUE_CD_BAK_1COT,HUE_CD_BAK_2COT,HUE_CD_BAK_3COT,HUE_CD_BAK_4COT,HUE_CD_LMN,PNT_FLM_THK_FRN_1COT,PNT_FLM_THK_FRN_2COT,PNT_FLM_THK_FRN_3COT,PNT_FLM_THK_FRN_4COT,PNT_FLM_THK_BAK_1COT,PNT_FLM_THK_BAK_2COT,PNT_FLM_THK_BAK_3COT,PNT_FLM_THK_BAK_4COT,PNT_FLM_THK_LMN,LUS_RT_CD_FRN_1COT,LUS_RT_CD_FRN_2COT,LUS_RT_CD_FRN_3COT,LUS_RT_CD_FRN_4COT,LUS_RT_CD_BAK_1COT,LUS_RT_CD_BAK_2COT,LUS_RT_CD_BAK_3COT,LUS_RT_CD_BAK_4COT,LUS_RT_CD_LMN,LUS_RT_FRN_1COT_LLV,LUS_RT_FRN_1COT_ULV,LUS_RT_FRN_2COT_LLV,LUS_RT_FRN_2COT_ULV,LUS_RT_FRN_3COT_LLV,LUS_RT_FRN_3COT_ULV,LUS_RT_FRN_4COT_LLV,LUS_RT_FRN_4COT_ULV,LUS_RT_BAK_1COT_LLV,LUS_RT_BAK_1COT_ULV,LUS_RT_BAK_2COT_LLV,LUS_RT_BAK_2COT_ULV,LUS_RT_BAK_3COT_LLV,LUS_RT_BAK_3COT_ULV,LUS_RT_BAK_4COT_LLV,LUS_RT_BAK_4COT_ULV,LUS_RT_LMN_LLV,LUS_RT_LMN_ULV,WK_VISCO_FRN_1COT,WK_VISCO_FRN_2COT,WK_VISCO_FRN_3COT,WK_VISCO_FRN_4COT,WK_VISCO_BAK_1COT,WK_VISCO_BAK_2COT,WK_VISCO_BAK_3COT,WK_VISCO_BAK_4COT,PMT_FRN_1COT,PMT_FRN_2COT,PMT_FRN_3COT,PMT_FRN_4COT,PMT_BAK_1COT,PMT_BAK_2COT,PMT_BAK_3COT,PMT_BAK_4COT,PMT_LMN,THR_CD_FRN_1COT,THR_CD_FRN_2COT,THR_CD_FRN_3COT,THR_CD_FRN_4COT,THR_CD_BAK_1COT,THR_CD_BAK_2COT,THR_CD_BAK_3COT,THR_CD_BAK_4COT,SLV_GRA_FRN_1COT,SLV_GRA_FRN_2COT,SLV_GRA_FRN_3COT,SLV_GRA_FRN_4COT,SLV_GRA_BAK_1COT,SLV_GRA_BAK_2COT,SLV_GRA_BAK_3COT,SLV_GRA_BAK_4COT,PNT_GRA_FRN_1COT,PNT_GRA_FRN_2COT,PNT_GRA_FRN_3COT,PNT_GRA_FRN_4COT,PNT_GRA_BAK_1COT,PNT_GRA_BAK_2COT,PNT_GRA_BAK_3COT,PNT_GRA_BAK_4COT,NV_FRN_1COT,NV_FRN_2COT,NV_FRN_3COT,NV_FRN_4COT,NV_BAK_1COT,NV_BAK_2COT,NV_BAK_3COT,NV_BAK_4COT,PNT_UNT_FRN_1COT,PNT_UNT_FRN_2COT,PNT_UNT_FRN_3COT,PNT_UNT_FRN_4COT,PNT_UNT_BAK_1COT,PNT_UNT_BAK_2COT,PNT_UNT_BAK_3COT,PNT_UNT_BAK_4COT,PNT_UNT_LMN,PTT_FLM_DTL_CD,PTT_FLM_LUS_RT_CD,PTT_FLM_THK_CD,PTT_FLM_MQL_CD,PTT_FLM_SUS_ADH_CD,PTT_FLM_PRD_ADH_CD,LMN_KND_TP,LMN_BND_CD,LMN_BND_THR_CD,LMN_BND_CD1,LMN_BND_THR_CD1,LMN_FLM_THK_CD,LMN_FLM_WTH_CD,PRT_ROLL_NO1,PRT_ROLL_NO2,PRT_ROLL_NO3,PRT_ROLL_NO4,PRT_INK_CD1,PRT_INK_CD2,PRT_INK_CD3,PRT_INK_CD4,PRT_ROLL_PTN_CD1,PRT_ROLL_PTN_CD2,PRT_ROLL_PTN_CD3,PRT_ROLL_PTN_CD4,PRT_UNT1,PRT_UNT2,PRT_UNT3,PRT_UNT4,PRT_USG_CD,ANON_CD,ANON_UNT,LUXTEEL_BRD_CD,MAIN_PROC_CD,SUB_PROC_CD1,SUB_PROC_CD2,SUB_PROC_CD3,TLP_TP,CUT_LN_YN,QLT_DSN_CFM_TP,LMN_BND_UNT,LMN_BND_UNT1,UNI_TEX_ROLL_NO,UNI_TEX_PTN_CD,PICK_UP_ROLL_NO,PRT_ROLL_BAK_NO1,PRT_ROLL_BAK_NO2,PRT_ROLL_BAK_NO3,PRT_ROLL_BAK_NO4,PRT_INK_BAK_CD1,PRT_INK_BAK_CD2,PRT_INK_BAK_CD3,PRT_INK_BAK_CD4,PRT_ROLL_PTN_BAK_CD1,PRT_ROLL_PTN_BAK_CD2,PRT_ROLL_PTN_BAK_CD3,PRT_ROLL_PTN_BAK_CD4,PRT_BAK_UNT1,PRT_BAK_UNT2,PRT_BAK_UNT3,PRT_BAK_UNT4,CCL_BOM_WR_YN,PT_TP,DISC_PTN_WTH_CD,IMPT_ROLL_NO,IMPT_ROLL_BAK_NO,CUS_CD,ORD_USG_CD,PTT_FLM_DTL_CD,CLR_DIF_FRN_LLV,CLR_DIF_FRN_ULV,CLR_DIF_BAK_LLV,CLR_DIF_BAK_ULV,MPR_BAS_PNCL_HRDN_FRN,MPR_BAS_PNCL_HRDN_BAK,MPR_BAS_MEK_FRN,MPR_BAS_MEK_BAK,CLR_BND_TST_FRN_STD_CD,CLR_BND_TST_FRN_GRD_PNT,CLR_BND_TST_BAK_STD_CD,CLR_BND_TST_BAK_GRD_PNT,PTT_FLM_ADH_LLV,PTT_FLM_ADH_ULV,CCL_QLT_MSG_TXT,UNI_GLS_FLM_CD,PTT_FLM_DTL_CD_N,RGS_PRS_ID,RGS_DH,MDF_PRS_ID,MDF_DH";
var popCompleteYN   = "N"; //칼라물성 저장 사유 입력여부 
var popCfmRea		= "";	// C106000060pop06 에서 물성 저장 사유.
var loadForm1_yn = "N"; //화면 열릴때 조회를 위한 Check Flag(F1, G1)
var loadGrid1_yn = "N";  //화면 열릴때 조회를 위한 Check Flag(F1, G1)

function find(eventName,formDivObj,referenceItem){
	var formObj = items['C106000060_Form_1'].getDhxForm();
	var form = items['C106000060_Form_1'];
	var comboList = form.getMasterCombos();
	var cclBomNo = formObj.getInput("CCL_BOM_NO").value;	
	var sndLst = formObj.isItemChecked("SND_LST");	//08-21 추가	
		if(isNull(cclBomNo)){
			if(isNull(comboList['RSN_TP_FRN'].getSelectedValue()) && isNull(comboList['COT_MTH'].getSelectedValue())){
				alert("CCL-BOM번호 또는 수지타입,코팅방식을 선택하세요.");
				form.setItemFocus("CCL_BOM_NO");
				return;
			}
		}
	
	
	//전송대상체크 조회 08-21추가
    if(sndLst == false){
      eventName = "find";		
    }else{
      eventName = "find1";
    }
		
		var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
			items[referenceItem].loadData(findUrl,findAfterFunction);		
		
}
//CCL-BOM정보 저장
function save(eventName,formDivObj,referenceItem){
	var gridObj = items['C106000060_Grid_1'].getDhxGrid();
	var grid = items['C106000060_Grid_1'];
	var grid4 = items['C106000060_Grid_4'];
	var grid9 = items['C106000060_Grid_9'];
		//gridObj.selectRow(0);선택불필요
		
	var tmpColorValue = items['C106000060_Grid_3'].getAllColumnValue(0);//색상코드값 여부 확인
	var	colorValue = tmpColorValue.replace(/,/gi,"");
		colorValue = colorValue.replace("색상코드","");
		colorValue = colorValue.replace(",","");
		if(isNull(colorValue)){
			dhtmlx.alert("색상코드값을 입력해주세요.");
			return;
		}
	
	//프린트롤No,유니텍스롤No 체크
	var prtPtnCd = "";
	var rollNo = "";
	var rollNo2 = "";
	var unitexNo = "";
	if(!isNull(grid4.getCellByIndexValue(0,12))){
		rollNo = grid4.getCellByIndexValue(0,12);
	}else if(!isNull(grid4.getCellByIndexValue(0,8))){
		rollNo = grid4.getCellByIndexValue(0,8);
	}else if(!isNull(grid4.getCellByIndexValue(0,4))){
		rollNo = grid4.getCellByIndexValue(0,4);
	}else if(!isNull(grid4.getCellByIndexValue(0,0))){
		rollNo = grid4.getCellByIndexValue(0,0);
	}
	
	if(!isNull(grid9.getCellByIndexValue(0,12))){
		rollNo9 = grid9.getCellByIndexValue(0,12);
	}else if(!isNull(grid9.getCellByIndexValue(0,8))){
		rollNo9 = grid9.getCellByIndexValue(0,8);
	}else if(!isNull(grid9.getCellByIndexValue(0,4))){
		rollNo9 = grid9.getCellByIndexValue(0,4);
	}else if(!isNull(grid9.getCellByIndexValue(0,0))){
		rollNo9 = grid9.getCellByIndexValue(0,0);
	}
	
	//alert(rollNo9);
	
	//PrintPatternCode 추가
	if(!isNull(rollNo)){
		var param= "ServiceName=C106000060-service&prtPntCdFind=1&PRT_ROLL_NO="+rollNo+"&column-info=PRT_PTN_CD,PRT_PTN_CD_NM";	
		var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		var cells = xmlObj.getElementsByTagName("cell"); 
		if(cells.length > 0){            										
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),168,cells.item(0).firstChild.nodeValue);//PrintPatternCode 추가
			items['C106000060_Grid_5'].setCellValue(6,8,cells.item(1).firstChild.nodeValue);//PrintPatternCode 추가
		}
	}
	
	//CCL BOM NO입력체크
	var cclBomNo = grid.getCellValue(grid.getRowSelectedId(),0);
	if(isNull(cclBomNo)){
		dhtmlx.alert("CCL-BOM NO를 입력하세요.");
		return;	
	}
	else if(cclBomNo.length < 6){
		dhtmlx.alert("CCL-BOM 번호는 6자리로 저장하시기 바랍니다.");
		return;
	}
	
    //칼라물성 입력체크
	var gridObj2 = items['C106000060_Grid_2'].getDhxGrid();
	var ccl_cus  = gridObj2.cellByIndex(0,2).getValue();
	if(isNull(ccl_cus)){
		dhtmlx.alert("컬러물성를 입력하세요.");
		return;	
	}

    //chemical coat, 무독성구분 입력체크
	var gridObj5 = items['C106000060_Grid_5'].getDhxGrid();
	var chemical_coat  = gridObj5.cellByIndex(1,1).getValue();
	if(isNull(chemical_coat)){
		dhtmlx.alert("Chemical Coat를 입력하세요");
		return;	
	}
	//상세색상명 입력체크(2014.11.12 이돈석)
	var dlt_clr_nm  = gridObj5.cellByIndex(2,1).getValue();
	if(isNull(dlt_clr_nm)){
		dhtmlx.alert("상세색상명을 입력하세요");
		return;	
	}else{
		//ajax로 최신 색상명을 검색하고 화면의 값이랑 비교하여 
		//값이 다를 시 경고메시지 발생시킨다(2015.01.02 이돈석)
		var clr_sub_mtl_cd = gridObj5.cellByIndex(4,1).getValue();
		
		var param= "ServiceName=C106000060-service&colNm=1&CLR_SUB_MTL_CD="+clr_sub_mtl_cd+"&column-info=CLR_NM";	
		var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		var cells = xmlObj.getElementsByTagName("cell"); 
		if(cells.length > 0){
			var clr_nm_tmp = cells.item(0).firstChild.nodeValue;
			if(dlt_clr_nm != clr_nm_tmp){
				alert("칼라코드관리 프로그램의 색상명과 CCL BOM의 상세 색상명이 동일하지 않습니다");
				//items['C106000060_Grid_5'].getFilterElement().focus();
				//items['C106000060_Grid_5'].setCellValue(2,1,cells.item(0).firstChild.nodeValue);
				//items['C106000060_Grid_5'].setUpdated(items['C106000060_Grid_5'].getDhxGrid().getRowId(4),true,"updated");
				//gridObj5.setUpdated(grid.getRowSelectedId(),true,"updated");
				//alert("상세 색상명을 자동 변경하였습니다.");
				return;
			}
		}	
	}
	
	var tlp_tp  = gridObj5.cellByIndex(6,1).getValue();
	if(isNull(tlp_tp)){
		dhtmlx.alert("무독성구분을 입력하세요");
		return;	
	}
	if((chemical_coat == "CHCRO" && tlp_tp == "N") || (chemical_coat == "CHNCR" && tlp_tp== "C") || (chemical_coat == "NOCHE" && tlp_tp== "C")){
		dhtmlx.alert("Chemical Coat와 무독성구분 불일치");
		return;
	}
		
	if(duplicateCclBom()){
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"저장 하시겠습니까?",
			callback:function(val){
				if(val){					
					items[referenceItem].sendGrid(referenceItem,eventName);
					return;
				}
			}
		});  
	}else{
		alert("중복되는 CCL-BOM NO가 있습니다. 확인해주세요.");
		return;			
	}
}

function duplicateCclBom (){
	var gridObj1 = items['C106000060_Grid_1'].getDhxGrid();
	var gridObj = items['C106000060_Grid_1'];
	var grid_cnt1 = gridObj1.getRowsNum();
	var row_status = "";
	var code = "";
	var resultFlag = true;
	for(var i=0; i< grid_cnt1; i++){
		row_status = gridObj1.getUserData(gridObj1.getRowId(i),"!nativeeditor_status");
		if(row_status != "" && row_status == "inserted" ){
			code = gridObj.getCellByIndexValue(i,0);
			for(var j=0; j< grid_cnt1; j++){
				if(i!=j){
					var nextCode = gridObj.getCellByIndexValue(j,0);
					if(code == nextCode){							
						resultFlag = false;
						break;
					}
				}
			}
		}
	}
	return resultFlag;
}
//칼라물성정보 저장
function save1(eventName,formDivObj,referenceItem){	
	var gridObj = items['C106000060_Grid_1'];
	var gridObj2 = items['C106000060_Grid_2'];  //12-07-10 srt
	var cuscd = "";     //
	var erpsnddh = "";  //
	var ordusgcd = "";  //
	var cclqltmsgtxt = "";  //
	var rowStatus = ""; //
	var grid2_row_cnt = gridObj2.getDhxGrid().getRowsNum();
	
	if(gridObj.getRowSelectedId()){
		var cclBomNo = gridObj.getCellValue(gridObj.getRowSelectedId(),0);	
		if(gridObj2.getRowSelectedId()){
			var selectedId = gridObj2.getSelectedRowId();
	  	    
		    if(!(popCompleteYN=="Y")){
		    	popCompleteYN = "Y";
		    	C10_linkC106000060pop06(); //물성정보 저장 사유 입력 popup
				return false;
			}
			for(var i=0; i<grid2_row_cnt; i++){	
				var rowID = items['C106000060_Grid_2'].getDhxGrid().getRowId(i);
				rowStatus =  gridObj2.getDhxGrid().getUserData(rowID,"!nativeeditor_status");
				cuscd      = gridObj2.getCellValue(rowID,0);
				erpsnddh = gridObj2.getCellValue(rowID,items['C106000060_Grid_2'].getDhxGrid().getColIndexById("ERP_SND_DH"));	//12-07-10
				ordusgcd = gridObj2.getCellValue(rowID,items['C106000060_Grid_2'].getDhxGrid().getColIndexById("ORD_USG_CD"));
				cclqltmsgtxt = gridObj2.getCellValue(rowID,items['C106000060_Grid_2'].getDhxGrid().getColIndexById("CCL_QLT_MSG_TXT"));
				
			    if(!isNull(cclBomNo)&&!isNull(cuscd)&&!isNull(ordusgcd)){
					if(rowStatus == "inserted"){
						if(cclqltmsgtxt.indexOf('=""')>0){
							alert("품질메시지에 이상한 문자가 있습니다(indexOf). 수정해주세요.");
							popCompleteYN = "N";
							return;
						}
						gridObj2.setCellValue(rowID,22, popCfmRea);
						gridObj2.setUpdated(rowID,true,"inserted"); 		
					}
					else if(rowStatus == "updated"){
						if(cclqltmsgtxt.indexOf('=""')>0){
							alert("품질메시지에 이상한 문자가 있습니다(indexOf). 수정해주세요.");
							popCompleteYN = "N";
							return;
						}
						gridObj2.setCellValue(rowID,22, popCfmRea);
						gridObj2.setUpdated(rowID,true,"updated"); 		
					}
					//삭제시 ERP전송여부에 따라 Send Delete OR Delete
					else if(rowStatus == "deleted"){
						if(!isNull(erpsnddh)){
							gridObj2.setCellValue(rowID,22, popCfmRea);
							gridObj2.setUpdated(rowID,true,"senddeleted");             	       
						}
						else{
							gridObj2.setCellValue(rowID,22, popCfmRea);
							gridObj2.setUpdated(rowID,true,"deleted"); 
						}		
					}
				}else{
					alert("CCL-BOM번호,고객사,주문용도를 선택해주세요.");
					popCompleteYN = "N";
					return;
				}
			}
		    //12-07-10 end		
            popCompleteYN = "N";
		      
		    dhtmlx.confirm({
					title:"[[ 확인 ]]",
					ok:"확인", cancel:"취소",
					text:"저장 하시겠습니까?",
					callback:function(val){
						if(val){
							rowIndex=items['C106000060_Grid_2'].getDhxGrid().getRowIndex(selectedId); //저장된 row의 index를 담아둠
							items['C106000060_Grid_2'].getDhxGrid().selectRow(rowIndex);
							items['C106000060_Grid_2'].sendGrid('C106000060_Grid_2',eventName);
							//rowIndex=items['C106000060_Grid_2'].getDhxGrid().getRowIndex(selectedId); //저장된 row의 index를 담아둠
							//setTimeout('send1()',3000); //3초뒤 자동 ERP전송(2016.1.15 박성용대리 요청)
							return;
						}
					}
			});
		}else{
			alert("칼라물성정보에 선택된 행이 없습니다.");
			return;		
		}
	}else{
		alert("CCL-BOM번호를 선택해 주세요.");
		return;
	}
	
}
<%--
//확정처리 
function confirmSave(eventName,formDivObj,referenceItem){
  var grid = items['C106000060_Grid_1'];
  if(grid.getRowSelectedId()){
  	var cclBomNo = grid.getCellValue(grid.getRowSelectedId(),0);
  	if(isNull(cclBomNo)){
  		alert("CCL-BOM NO를 입력해 주세요.");
  		return;	
  	}
  	dhtmlx.confirm({
  		title:"[[ 확인 ]]",
  		ok:"확인", cancel:"취소",
  		text:"확정 하시겠습니까?",
  		callback:function(val){
  			if(val){
  				items['C106000060_Grid_1'].sendGrid('C106000060_Grid_1',"confirmSave");
  			return;
  			}
  		}
  	}); 
  }else{
    alert("CCL-BOM NO를 선택해 주세요.");
    return;
  }
}
--%>
//CCL-BOM정보 전송
function send(eventName,formDivObj,referenceItem){
	var grid = items['C106000060_Grid_1'];	
	var selectedId = grid.getSelectedRowId();
	
  if(selectedId){
	  var cclBomNo = grid.getCellValue(selectedId,0);
	}else{
    alert("CCL-BOM NO를 선택해 주세요.");
    return;
  }
	
	if(isNull(cclBomNo)){
		alert("CCL-BOM NO를 입력해 주세요.");
		return;	
	}
	if(!isNull(selectedId)){
		var rowStatus =  grid.getDhxGrid().getUserData(selectedId,"!nativeeditor_status");
		if(rowStatus == "inserted"){
			alert("저장 후 전송하십시요.");
			return;
		}
		//그리드 체크박스의 값을 DB값으로 replace 12-07-10 추가
		var orgcclBomusgyn = grid.getCellValue(selectedId,items['C106000060_Grid_1'].getDhxGrid().getColIndexById("ORG_CCL_BOM_USE_YN"));
		var cclBomusgyn = grid.getCellValue(selectedId,1);
        if(orgcclBomusgyn != cclBomusgyn ){
        	items['C106000060_Grid_1'].setCellValue(selectedId, items['C106000060_Grid_1'].getDhxGrid().getColIndexById("CCL_BOM_USE_YN"), orgcclBomusgyn);	
        	items['C106000060_Grid_1'].setCellValue(selectedId, items['C106000060_Grid_1'].getDhxGrid().getColIndexById("CCL_BOM_USE_YN_HIDDEN"), orgcclBomusgyn);	         	
        }
		var rowIdArray = selectedId.split(',');
		for(var i=0; i<rowIdArray.length; i++){
			grid.setUpdated(rowIdArray[i],true,"updated"); 
		}	 
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"전송 하시겠습니까?",
			callback:function(val){
				if(val){
					grid.sendGrid('C106000060_Grid_1',"send");
				return;
				}
			}
		}); 
	}else{
		alert("전송할 CCL-BOM를 선택해주세요.");
		return;
	
	}
}
/*
//칼라물성정보 전송
function send1(eventName,formDivObj,referenceItem){
	var grid2 = items['C106000060_Grid_2'];
	grid2.getDhxGrid().selectRow(rowIndex);  //저장된 index를 grid에 강제로 선택되게 함 
	var selectedId = grid2.getSelectedRowId();
	if(!isNull(selectedId)){
		var rowStatus =  grid2.getDhxGrid().getUserData(selectedId,"!nativeeditor_status");
		if(rowStatus == "inserted"){
			alert("저장 후 전송하십시요.");
			return;
		}
		var rowIdArray = selectedId.split(',');		
		for(var i=0; i<rowIdArray.length; i++){
			if(!isNull(grid2.getCellValue(rowIdArray[i],4))){
				if(isNull(grid2.getCellValue(rowIdArray[i],17))){
					alert("보호필름 제품점착력코드가 없는 행이 있습니다. 다시 확인해주세요.");
					return;
				}else if(isNull(grid2.getCellValue(rowIdArray[i],18))){
					alert("보호필름 두께코드가 없는 행이 있습니다. 다시 확인해주세요.");
					return;			
				}else if(isNull(grid2.getCellValue(rowIdArray[i],19))){
					alert("보호필름 재질코드가 없는 행이 있습니다. 다시 확인해주세요.");
					return;			
				}	
			}
		}
		for(var i=0; i<rowIdArray.length; i++){				
			grid2.setUpdated(rowIdArray[i],true,"inserted"); 			
		}
		grid2.sendGrid('C106000060_Grid_2',"send");
	}else{
		alert("전송할 고객사 정보를 선택해주세요.");
		return;
	}
}
*/

//menu refresh event function
//CCL-BOM번호 refresh
function refresh(referenceItem){ //grid selection clear event
	items[referenceItem].clearDataProcess();
	find('find','C106000060_Form_1',referenceItem);
}
//menu refresh event function
function refresh1(referenceItem){ //grid selection clear event
	if(isNull(items['C106000060_Grid_1'].getSelectedRowId())){
		alert("CCL-BOM번호를 선택해주세요.");
		return;	
	}
	items['C106000060_Grid_2'].clearDataProcess(); 
	deteilCclBomNo(items['C106000060_Grid_1'].getSelectedRowId(),0);
	//var childFindUrl = uiCommon.parameters('C106000060_Form_1',referenceItem,'detailFind');
 	//items[referenceItem].loadData(childFindUrl);
}
//menu new row event function
//CCL-BOM번호 행추가
function add(referenceItem){
	var gridDhxObj = items['C106000060_Grid_1'].getDhxGrid();
	var gridObj = items['C106000060_Grid_1'];
	items[referenceItem].addRow(); //행추가
	gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), 0, "ed"); // 확정컬럼 ch로 변경
	gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), 1, "ch"); // 확정컬럼 ch로 변경
	var cellVal = gridObj.getCellValue(gridObj.getRowSelectedId(),0);
	var customparam = {"CCL_BOM_NO":"@@@@@"};	
	var detailFindUrl = parameters14('C106000060_Grid_1','C106000060_Grid_2','detailFind','basicGridData.do');
	items["C106000060_Grid_2"].loadData(detailFindUrl,afterProGressOff);	//칼라 물성정보 초기화
	
	var param = varticalParameters('C106000060_Grid_3','C106000060-service',"colorFind",customparam);
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
	uiCommon.renderToGrid('C106000060_Grid_3',xmlObj);  //색상코드Grid 초기화   
		
	var detailFindUrl2 = parameters14('C106000060_Grid_1','C106000060_Grid_4','colorFind','basicGridData.do',customparam);
	items["C106000060_Grid_4"].loadData(detailFindUrl2,afterProGressOff);	//Print정보조회 TOP
	
	var detailFindUrl3 = parameters14('C106000060_Grid_1','C106000060_Grid_9','colorFind','basicGridData.do',customparam);
	items["C106000060_Grid_9"].loadData(detailFindUrl3,afterProGressOff);	//Print정보조회 BACK
	
	var param1 = varticalParameters('C106000060_Grid_5','C106000060-service',"find",customparam);
	var xmlObj1 = uiCommon.ajaxLoadData('verticalGridData.do',param1);
	uiCommon.renderToGrid('C106000060_Grid_5',xmlObj1); //아농,보호필름,라미나,통과공정조회
	
	var grid = items['C106000060_Grid_1'];	
	var grid5 = items['C106000060_Grid_5'].getDhxGrid();
	var combo11 = grid5.cells(grid5.getRowId(6), 5).getCellCombo(); //품질설계확정구분
	//품질설계확정구분
	//combo11.loadXML(master_combo_url + '&' + 'category=SZ0000&code=QLT_DSN_CFM_TP&totalValue=&orderBy=value&displayType=all-code');
	//combo11.selectOption(2,true,false);
	//combo11.enableOptionAutoPositioning(true);
}
//menu new row and copy event function
//CCL-BOM번호 복사
function copy(referenceItem){
	var gridDhxObj = items['C106000060_Grid_1'].getDhxGrid();
	var gridObj = items['C106000060_Grid_1'];
	var cellVal = "";
	if(isNull(gridObj.getRowSelectedId())){
		alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");			
		return;
	}else{
		cellVal = gridObj.getCellValue(gridObj.getRowSelectedId(),0);
	}
	if(isNull(cellVal)){		
		alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");			
		return;
	}else{
		items[referenceItem].addRow(); //행추가
		gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), 0, "ed"); // 확정컬럼 ch로 변경
		gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), 1, "ch"); // 확정컬럼 ch로 변경
	    
		//ccl bom복사 시 Grid1에 추가된 항목들을 여기에 넣어줘야 된다.(2013.08.05) ==> Grid1의 개수와 복사되는 개수는 동일해야 insert할때 에러 발생하지 않음.
		var copyParam= "ServiceName=C106000060-service&find=1&CCL_BOM_NO="+cellVal+"&column-info=CCL_BOM_NO,CCL_BOM_USE_YN,COT_MTH_NM,RSN_TP_FRN_NM,RSN_TP_BAK_NM,LUS_RT_CD_FRN_NM,LUS_RT_CD_BAK_NM,HUE_CD_FRN,HUE_CD_BAK,PNT_FLM_THK_FRN_TOT,PNT_FLM_THK_BAK_TOT,CCL_BOM_USE_YN_HIDDEN,HUE_CD_FRN_4COT,RSN_TP_FRN_4COT,LUS_RT_CD_FRN_4COT,LUS_RT_FRN_4COT_LLV,WK_VISCO_FRN_4COT,PMT_FRN_4COT,PNT_FLM_THK_FRN_4COT,SLV_GRA_FRN_4COT,PNT_GRA_FRN_4COT,NV_FRN_4COT,PNT_UNT_FRN_4COT,THR_CD_FRN_4COT,HUE_CD_FRN_3COT,RSN_TP_FRN_3COT,LUS_RT_CD_FRN_3COT,LUS_RT_FRN_3COT_LLV,WK_VISCO_FRN_3COT,PMT_FRN_3COT,PNT_FLM_THK_FRN_3COT,SLV_GRA_FRN_3COT,PNT_GRA_FRN_3COT,NV_FRN_3COT,PNT_UNT_FRN_3COT,THR_CD_FRN_3COT,HUE_CD_FRN_2COT,RSN_TP_FRN_2COT,LUS_RT_CD_FRN_2COT,LUS_RT_FRN_2COT_LLV,WK_VISCO_FRN_2COT,PMT_FRN_2COT,PNT_FLM_THK_FRN_2COT,SLV_GRA_FRN_2COT,PNT_GRA_FRN_2COT,NV_FRN_2COT,PNT_UNT_FRN_2COT,THR_CD_FRN_2COT,HUE_CD_FRN_1COT,RSN_TP_FRN_1COT,LUS_RT_CD_FRN_1COT,LUS_RT_FRN_1COT_LLV,WK_VISCO_FRN_1COT,PMT_FRN_1COT,PNT_FLM_THK_FRN_1COT,SLV_GRA_FRN_1COT,PNT_GRA_FRN_1COT,NV_FRN_1COT,PNT_UNT_FRN_1COT,THR_CD_FRN_1COT,HUE_CD_BAK_1COT,RSN_TP_BAK_1COT,LUS_RT_CD_BAK_1COT,LUS_RT_BAK_1COT_LLV,WK_VISCO_BAK_1COT,PMT_BAK_1COT,PNT_FLM_THK_BAK_1COT,SLV_GRA_BAK_1COT,PNT_GRA_BAK_1COT,NV_BAK_1COT,PNT_UNT_BAK_1COT,THR_CD_BAK_1COT,HUE_CD_BAK_2COT,RSN_TP_BAK_2COT,LUS_RT_CD_BAK_2COT,LUS_RT_BAK_2COT_LLV,WK_VISCO_BAK_2COT,PMT_BAK_2COT,PNT_FLM_THK_BAK_2COT,SLV_GRA_BAK_2COT,PNT_GRA_BAK_2COT,NV_BAK_2COT,PNT_UNT_BAK_2COT,THR_CD_BAK_2COT,HUE_CD_BAK_3COT,RSN_TP_BAK_3COT,LUS_RT_CD_BAK_3COT,LUS_RT_BAK_3COT_LLV,WK_VISCO_BAK_3COT,PMT_BAK_3COT,PNT_FLM_THK_BAK_3COT,SLV_GRA_BAK_3COT,PNT_GRA_BAK_3COT,NV_BAK_3COT,PNT_UNT_BAK_3COT,THR_CD_BAK_3COT,HUE_CD_BAK_4COT,RSN_TP_BAK_4COT,LUS_RT_CD_BAK_4COT,LUS_RT_BAK_4COT_LLV,WK_VISCO_BAK_4COT,PMT_BAK_4COT,PNT_FLM_THK_BAK_4COT,SLV_GRA_BAK_4COT,PNT_GRA_BAK_4COT,NV_BAK_4COT,PNT_UNT_BAK_4COT,THR_CD_BAK_4COT,HUE_CD_LMN,RSN_TP_LMN,LUS_RT_CD_LMN,LUS_RT_LMN_LLV,PMT_LMN,PNT_FLM_THK_LMN,PNT_UNT_LMN,COT_MTH,RSN_TP_FRN,LUS_RT_CD_FRN,HUE_CD_CHM,DTL_CLR_NM,ANON_CD,ANON_UNT,PTT_FLM_DTL_CD,PTT_FLM_LUS_RT_CD,PTT_FLM_THK_CD,PTT_FLM_MQL_CD,PTT_FLM_SUS_ADH_CD,PTT_FLM_PRD_ADH_CD,DISC_PTN_WTH_CD,MAIN_PROC_CD,SUB_PROC_CD1,SUB_PROC_CD2,LUS_RT_FRN_4COT_ULV,LUS_RT_FRN_3COT_ULV,LUS_RT_FRN_2COT_ULV,LUS_RT_FRN_1COT_ULV,LUS_RT_BAK_1COT_ULV,LUS_RT_BAK_2COT_ULV,LUS_RT_BAK_3COT_ULV,LUS_RT_BAK_4COT_ULV,LUS_RT_LMN_ULV,LMN_KND_TP,LMN_BND_CD,LMN_BND_THR_CD,LMN_BND_CD1,LMN_BND_THR_CD1,LMN_FLM_THK_CD,RSN_TP_BAK,LUS_RT_CD_BAK,PRT_ROLL_NO1,PRT_INK_CD1,PRT_ROLL_PTN_CD1,PRT_UNT1,PRT_ROLL_NO2,PRT_INK_CD2,PRT_ROLL_PTN_CD2,PRT_UNT2,PRT_ROLL_NO3,PRT_INK_CD3,PRT_ROLL_PTN_CD3,PRT_UNT3,PRT_ROLL_NO4,PRT_INK_CD4,PRT_ROLL_PTN_CD4,PRT_UNT4,SUB_PROC_CD3,TLP_TP,PRT_USG_CD,PRT_PTN_CD,CUT_LN_YN,LMN_BND_UNT,LMN_BND_UNT1,QLT_DSN_CFM_TP,RGS_PRS_ID,RGS_DH,MDF_PRS_ID,MDF_DH,ERP_SND_DH,ORG_CCL_BOM_USE_YN,SND_LST,UNI_TEX_ROLL_NO,UNI_TEX_PTN_CD,PICK_UP_ROLL_NO,PRT_ROLL_BAK_NO1,PRT_INK_BAK_CD1,PRT_ROLL_PTN_BAK_CD1,PRT_BAK_UNT1,PRT_ROLL_BAK_NO2,PRT_INK_BAK_CD2,PRT_ROLL_PTN_BAK_CD2,PRT_BAK_UNT2,PRT_ROLL_BAK_NO3,PRT_INK_BAK_CD3,PRT_ROLL_PTN_BAK_CD3,PRT_BAK_UNT3,PRT_ROLL_BAK_NO4,PRT_INK_BAK_CD4,PRT_ROLL_PTN_BAK_CD4,PRT_BAK_UNT4,CCL_BOM_WR_YN,PT_TP,IMPT_ROLL_NO,IMPT_ROLL_BAK_NO,CLR_SPC_PRD_SCLS,CCL_BOM_ATT_YN";
		var copyXmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',copyParam);
		var cells = copyXmlObj.getElementsByTagName("cell");
		if(cells.length > 0){
		  for(var k = 0; k < cells.length; k++){
			  if(k == 1){
				  gridObj.setCellValue(gridObj.getRowSelectedId(),k, "0") //복사시 체크박스 해제 12-07-10
			  }else {
					gridObj.setCellValue(gridObj.getRowSelectedId(),k, cells.item(k).firstChild.nodeValue);
			  }
		  }
		}		
		
		var customparam = {"CCL_BOM_NO":cellVal};	
		var detailFindUrl = parameters14('C106000060_Grid_1','C106000060_Grid_2','detailFind','basicGridData.do');
		items["C106000060_Grid_2"].loadData(detailFindUrl,afterProGressOff);	//칼라 물성정보 초기화
		
		var param = varticalParameters('C106000060_Grid_3','C106000060-service',"colorFind",customparam);
		var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
		uiCommon.renderToGrid('C106000060_Grid_3',xmlObj);  //색상코드Grid 초기화   
			
		var detailFindUrl2 = parameters14('C106000060_Grid_1','C106000060_Grid_4','colorFind','basicGridData.do',customparam);
		items["C106000060_Grid_4"].loadData(detailFindUrl2,afterProGressOff);	//Print정보조회 TOP
		
		var detailFindUrl3 = parameters14('C106000060_Grid_1','C106000060_Grid_9','colorFind','basicGridData.do',customparam);
		items["C106000060_Grid_9"].loadData(detailFindUrl3,afterProGressOff);	//Print정보조회 BACK
		
		
		var param1 = varticalParameters('C106000060_Grid_5','C106000060-service',"find",customparam);
		var xmlObj1 = uiCommon.ajaxLoadData('verticalGridData.do',param1);
		uiCommon.renderToGrid('C106000060_Grid_5',xmlObj1); //아농,보호필름,라미나,통과공정조회
		gridDhxObj.selectCell(0,0,false,false);	
		gridObj.setCellValue(gridObj.getRowSelectedId(),0, cellVal);
	}
}
//menu new row event function 
//칼라물성정보 행추가
function add1(referenceItem){ 
	var gridObj = items['C106000060_Grid_1'];
	var gridObj1 = items['C106000060_Grid_2'].getDhxGrid();
	if(!isNull(gridObj.getRowSelectedId())){
		var cclBomNo = gridObj.getCellValue(gridObj.getRowSelectedId(),0);
		if(!isNull(cclBomNo)){
			items['C106000060_Grid_2'].addRow();
			gridObj1.selectRow(0);
			for (var i=0; i<18 ; i++){
				if( i != 1 || i != 3 ){
					gridObj1.setCellExcellType(gridObj1.getRowId(0), i, "ed");
				}
			}
			items['C106000060_Grid_2'].setCellValue(gridObj1.getRowId(0),gridObj1.getColIndexById("CCL_BOM_NO"),cclBomNo);
		}else{
			alert("선택한행의 CCL-BOM번호가 없습니다.\n CCL-BOM번호를 입력해주세요.");
			return;
		}
		var gridDhxObj = items['C106000060_Grid_2'].getDhxGrid();  
        gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), gridDhxObj.getColIndexById("CLR_BND_TST_FRN_STD_CD"), "combo_v"); //T
        gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), gridDhxObj.getColIndexById("CLR_BND_TST_BAK_STD_CD"), "combo_v"); //콤보설정
        gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), gridDhxObj.getColIndexById("MPR_BAS_PNCL_HRDN_FRN"), "combo_v"); //콤보설정 
        gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), gridDhxObj.getColIndexById("MPR_BAS_PNCL_HRDN_BAK"), "combo_v"); //콤보설정 		      
	}else{
		alert("CCL-BOM번호를 선택해주세요.");
		return;		
	}
}
//menu remove event function
function remove(referenceItem){
    items[referenceItem].removeRow();
	//setCellType();//cell Type 변경
}
//menu remove event function
function remove1(referenceItem){
    items[referenceItem].removeRow();
}
//menu setCusCd event function
function setCusCd(referenceItem){
	var gridObj = items[referenceItem].getDhxGrid();
	var rowId = items[referenceItem].getSelectedRowId();
		gridObj.selectRow(0);
	var rowStatus = items[referenceItem].getDhxGrid().getUserData(rowId,"!nativeeditor_status");
	if(rowStatus!="inserted"){
		alert("행추가를 한경우에만 고객사를 선택하실 수 있습니다.");
		return;
	}else{		
		var cellVal = items[referenceItem].getCellValue(rowId,0);
		winObj = new ui.window("cusCdPopup","고객사","0","0","469","532","masterGridData.do?CD_TP=CUS_CD&CATEGORY_GROUP_NM=SZ0000&targetName=C106000060_Grid_2&targetFormID=C106000060_Grid_2&CD_V="+encodeURIComponent(cellVal)+"&targetRowIndex="+gridObj.getRowIndex(rowId)+"&targetCellIndex=0");
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		return;
		//winObj.getDhxWindow().setPosition(500,500);
	}	
}
//menu setOrdUsgCd event function
function setOrdUsgCd(referenceItem){
	var gridObj = items[referenceItem].getDhxGrid();
	var rowId = items[referenceItem].getSelectedRowId();
		gridObj.selectRow(0);
	var rowStatus = items[referenceItem].getDhxGrid().getUserData(rowId,"!nativeeditor_status");
	if(rowStatus!="inserted"){
		alert("행추가를 한경우에만 주문용도를 선택하실 수 있습니다.");
		return;
	}else{		
		var cellVal = items[referenceItem].getCellValue(rowId,2);
		winObj = new ui.window("ordUsgCdPopup","주문용도","0","0","469","532","masterGridData.do?CD_TP=ORD_USG_CD&CATEGORY_GROUP_NM=SZ0000&targetName=C106000060_Grid_2&targetFormID=C106000060_Grid_2&CD_V="+encodeURIComponent(cellVal)+"&targetRowIndex="+gridObj.getRowIndex(rowId)+"&targetCellIndex=2");
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		return;
		//winObj.getDhxWindow().setPosition(500,500);
	}
	return true;
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
//master grid row selected
function deteilCclBomNo(rowId,cellIndex){	
	var gridObj = items['C106000060_Grid_1'];
	var cellVal = gridObj.getCellValue(rowId,0);
	if(isNull(cellVal)){
		cellVal = "@$$$$@";
	}
	var customparam = {"CCL_BOM_NO":cellVal};
	var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(rowId,"!nativeeditor_status");
	if( rowStatus!="inserted" && isNull(cellVal)){
		alert("선택한 행의 CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");
		return;
	}
	var detailFindUrl = parameters14('C106000060_Grid_1','C106000060_Grid_2','detailFind','basicGridData.do');
	items["C106000060_Grid_2"].loadData(detailFindUrl,afterProGressOff);	//칼라 물성정보조회
	
	var param = varticalParameters2('C106000060_Grid_3','C106000060-service',"colorFind",customparam);
	var xmlObj = uiCommon.ajaxLoadData('verticalGridData.do',param);
	uiCommon.renderToGrid('C106000060_Grid_3',xmlObj);  
	
	var detailFindUrl2 = parameters14('C106000060_Grid_1','C106000060_Grid_4','colorFind','basicGridData.do',customparam);
	items["C106000060_Grid_4"].loadData(detailFindUrl2,afterProGressOff);	//Print정보조회 TOP
	
	var detailFindUrl3 = parameters14('C106000060_Grid_1','C106000060_Grid_9','colorFind','basicGridData.do',customparam);
	items["C106000060_Grid_9"].loadData(detailFindUrl3,afterProGressOff);	//Print정보조회 BACK
	
	
	var param1 = varticalParameters('C106000060_Grid_5','C106000060-service',"find",customparam);
	var xmlObj1 = uiCommon.ajaxLoadData('verticalGridData.do',param1);
	uiCommon.renderToGrid('C106000060_Grid_5',xmlObj1); //칼라특수제품분류,보호필름,라미나,통과공정조회
}

function onFormLoadFunction(){
	items['C106000060_Form_1'].setItemValue("CCL_BOM_NO","<%=CCL_BOM_NO%>");
	var formObj = items['C106000060_Form_1'].getDhxForm();
	//items['C106000060_Form_3'].getDhxForm().hideItem("send1");
 	var comboList = items['C106000060_Form_1'].getMasterCombos();
		comboList['RSN_TP_FRN'].readonly(true,true);
			ui.combo.master(comboList['RSN_TP_FRN'],'SZ0000','RSN_TP','totalValue=,orderBy=value',function(){ 
			comboList['RSN_TP_FRN'].selectOption(0,true,true);	
			comboList['RSN_TP_FRN'].setOptionHeight(220);
		});
		comboList['RSN_TP_FRN'].DOMelem_input.onkeydown = function(e){
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
		comboList['COT_MTH'].readonly(true,true);
			ui.combo.master(comboList['COT_MTH'],'SZ0000','COT_MTH','totalValue=,orderBy=value',function(){ 
			comboList['COT_MTH'].selectOption(0,true,true);
			comboList['COT_MTH'].setOptionHeight(220);
		});	
		comboList['COT_MTH'].DOMelem_input.onkeydown = function(e){
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
//		comboList['LUS_RT_CD_FRN'].readonly(true,true);
//			ui.combo.master(comboList['LUS_RT_CD_FRN'],'SZ0000','LUS_RT_CD','totalValue=,orderBy=value',function(){ 
//			comboList['LUS_RT_CD_FRN'].selectOption(0,true,true);		
//		});	
//		comboList['LUS_RT_CD_FRN'].DOMelem_input.onkeydown = function(e){
//			key = (e) ? e.keyCode : event.keyCode;
//				if(key==8 || key==116){
//					if(e){   //표준         
//						e.preventDefault();
//					}
//					else{ //익스용
//						event.keyCode = 0;
//						event.returnValue = false;
//					}
//				}
//			}
		var inputObj = formObj.getInput("CCL_BOM_NO");
			inputObj.onkeyup = function(e){
				if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
				  inputObj.value = inputObj.value.toUpperCase();
				}	
				e = e||window.event;
				if(e.keyCode == 13){
					formObj.setItemValue("CCL_BOM_NO",inputObj.value);
					//find("find","C106000060_Form_1","C106000060_Grid_1");		
					loadForm1_yn = "Y";
					onLoadForm1Grid1();
				}
			}
        loadForm1_yn = "Y";
		onLoadForm1Grid1();
		items['C106000060_Form_1'].onAfterUpdateFinishEvent(onFormAfterUpdateFinishEvent);
		items['C106000060_Form_1'].getDhxForm().detachEvent(onXleForm);
}
function onFormAfterUpdateFinishEvent(){	
	 items['C106000060_Form_1'].getDhxForm().resetDataProcessor("updated");
}
function onGridLoadFunction(){
	loadGrid1_yn = "Y";
	onLoadForm1Grid1();
	//var formObj = items['C106000060_Form_1'].getDhxForm();
	//var cclBomNo = formObj.getInput("CCL_BOM_NO").value;	
	//if(!isNull(cclBomNo)){
	//	var findUrl = uiCommon.parameters('C106000060_Form_1','C106000060_Grid_1','find');
	//	items['C106000060_Grid_1'].loadData(findUrl,findAfterFunction);		
	//}
		
	items['C106000060_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);	
	items['C106000060_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onLoadForm1Grid1(){
	if(loadForm1_yn=="Y" && loadGrid1_yn=="Y" ){
		var formObj = items['C106000060_Form_1'].getDhxForm();
		var cclBomNo = formObj.getInput("CCL_BOM_NO").value;	
		if(!isNull(cclBomNo)){
			var findUrl = uiCommon.parameters('C106000060_Form_1','C106000060_Grid_1','find');
			items['C106000060_Grid_1'].loadData(findUrl,findAfterFunction);		
		}
    }	

}
function onGridLoadFunction2(){
//칼라물성정보 콤보 추가
  var grid2 = items['C106000060_Grid_2'].getDhxGrid();	
  var combo2 = grid2.getColumnCombo(9); //칼라Bending전면기준코드(굴곡)
  combo2.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=MQL_BND_TST_STD_CD&totalValue=&orderBy=value&displayType=code-code");      
  combo2.enableOptionAutoPositioning(true);
  combo2.readonly(true,true);
  
  var combo3 = grid2.getColumnCombo(10); //칼라Bending후면기준코드(굴곡)
  combo3.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=MQL_BND_TST_STD_CD&totalValue=&orderBy=value&displayType=code-code");      
  combo3.enableOptionAutoPositioning(true);
  combo3.readonly(true,true);
  
  var combo4 = grid2.getColumnCombo(13); //물성기준연필경도전면
  combo4.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=MPR_BAS_PNCL_HRDN&totalValue=&orderBy=value&displayType=code-code");      
  combo4.enableOptionAutoPositioning(true);
  combo4.readonly(true,true);
  
  var combo5 = grid2.getColumnCombo(14); //물성기준연필경도후면
  combo5.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=MPR_BAS_PNCL_HRDN&totalValue=&orderBy=value&displayType=code-code");      
  combo5.enableOptionAutoPositioning(true);
  combo5.readonly(true,true);  
  
    	
	items['C106000060_Grid_2'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
	items['C106000060_Grid_2'].getDhxGrid().detachEvent(onXleGrid2);
}

function onGridLoadFunction5(){
	var grid = items['C106000060_Grid_1'];	
	var grid5 = items['C106000060_Grid_5'].getDhxGrid();
	var combo0 = grid5.cells(grid5.getRowId(0), 1).getCellCombo();	  //칼라특수제품소분류
	var combo = grid5.cells(grid5.getRowId(0), 5).getCellCombo();	  //브랜드
	var combo1 = grid5.cells(grid5.getRowId(2), 5).getCellCombo();	 //주공정
	var combo2 = grid5.cells(grid5.getRowId(3), 5).getCellCombo();	 //대체공정1
	var combo3 = grid5.cells(grid5.getRowId(4), 5).getCellCombo();	 //대체공정2
	var combo4 = grid5.cells(grid5.getRowId(3), 2).getCellCombo();	 //코팅방식
	var combo5 = grid5.cells(grid5.getRowId(1), 2).getCellCombo();   //chemical coat
	var combo6 = grid5.cells(grid5.getRowId(5), 5).getCellCombo();	 //대체공정3
	var combo7 = grid5.cells(grid5.getRowId(6), 2).getCellCombo();   //무독성구분
	var combo8 = grid5.cells(grid5.getRowId(5), 8).getCellCombo();   //프린트용도
//	var combo9 = grid5.cells(grid5.getRowId(6), 8).getCellCombo(); 	 //PrintPatternCode
	var combo10 = grid5.cells(grid5.getRowId(0), 11).getCellCombo(); //재단선 유무
	var combo11 = grid5.cells(grid5.getRowId(6), 5).getCellCombo();  //품질설계확정구분
	var combo12 = grid5.cells(grid5.getRowId(1), 11).getCellCombo(); //핀트종류
	//칼라특수제품소분류 --> 2016.09.20 추가
	combo0.loadXML(master_combo_url + '&' + 'category=SZ0000&code=CLR_SPC_PRD_SCLS&totalValue=&orderBy=value&displayType=all-code');
	combo0.readonly(true,true);
	combo0.setOptionHeight(120);
	//브랜드코드:브랜드코드명 --> 2015.11.03 브랜드 코드 대신 불연속패턴 및 폭관리 코드로 변경
	combo.loadXML(master_combo_url + '&' + 'category=SZ0000&code=DISC_PTN_WTH_CD&totalValue=&orderBy=value&displayType=all-code');
	combo.readonly(true,true);
	combo.setOptionWidth(500);
	combo.setOptionHeight(140);
	//통과공정-주공정 설정
	combo1.loadXML(master_combo_url + '&' + 'category=SA0006&code=PROC_CD&totalValue=&orderBy=value');
	combo1.enableOptionAutoPositioning(true);
	combo1.readonly(true,true);
	combo1.setOptionHeight(160);
	//통과공정-대체공정1 설정
	combo2.loadXML(master_combo_url + '&' + 'category=SA0006&code=PROC_CD&totalValue=&orderBy=value');
	combo2.enableOptionAutoPositioning(true);
	combo2.readonly(true,true);
	combo2.setOptionHeight(160);	
	//통과공정-대체공정2 설정
	combo3.loadXML(master_combo_url + '&' + 'category=SA0006&code=PROC_CD&totalValue=&orderBy=value');
	combo3.enableOptionAutoPositioning(true);
	combo3.readonly(true,true);
	combo3.setOptionHeight(160);	
	//통과공정-대체공정3 설정
	combo6.loadXML(master_combo_url + '&' + 'category=SA0006&code=PROC_CD&totalValue=&orderBy=value');
	combo6.enableOptionAutoPositioning(true);
	combo6.readonly(true,true);
	combo6.setOptionHeight(160);	
	//도장방식 설정
	combo4.loadXML(master_combo_url + '&' + 'category=SZ0000&code=COT_MTH&totalValue=&orderBy=value&displayType=all-code');
	combo4.enableOptionAutoPositioning(true);
	combo4.readonly(true,true);
	combo4.setOptionHeight(160);
	//Chemical Coat 설정
	combo5.loadXML(master_combo_url + '&' + 'category=SZ0000&code=HUE_CD_CHM&totalValue=&orderBy=value');
	combo5.readonly(true,true);
	combo5.setOptionHeight(80);
	//무독성구분
	combo7.loadXML(master_combo_url + '&' + 'category=SZ0000&code=TLP_TP&totalValue=&orderBy=value&displayType=all-code');
	combo7.enableOptionAutoPositioning(true);
	combo7.readonly(true,true);	
	combo7.setOptionHeight(60);
	//Print용도코드
	combo8.loadXML(master_combo_url + '&' + 'category=SZ0000&code=PRT_USG_CD&totalValue=&orderBy=value&displayType=all-code');
	combo8.enableOptionAutoPositioning(true);
	combo8.readonly(true,true);	
	combo8.setOptionHeight(160);	
	//PrintPatternCode
//	combo9.loadXML(master_combo_url + '&' + 'category=SZ0000&code=PRT_PTN_CD&totalValue=&orderBy=value&displayType=all-code');
//	combo9.enableOptionAutoPositioning(true);
	
	//재단선 구분
	combo10.loadXML(master_combo_url + '&' + 'category=SZ0000&code=CUT_LN_YN&totalValue=&orderBy=value&displayType=all-code');
	combo10.enableOptionAutoPositioning(true);
	combo10.readonly(true,true);
	combo10.setOptionHeight(60);
	
	//품질설계확정구분
	combo11.loadXML(master_combo_url + '&' + 'category=SZ0000&code=QLT_DSN_CFM_TP&orderBy=value&displayType=all-code');
	combo11.enableOptionAutoPositioning(true);
	combo11.readonly(true,true);
	combo11.setOptionHeight(40);
	
	//핀트종류
	combo12.loadXML(master_combo_url + '&' + 'category=SZ0000&code=PT_TP&totalValue=&orderBy=value&displayType=all-code');
	combo12.enableOptionAutoPositioning(true);
	combo12.readonly(true,true);
	combo12.setOptionHeight(60);
	
	/*
	var friTpIdx = comboList['TAG_PUB_PLC_CD'].getIndexByValue('TEST02');
    comboList['TAG_PUB_PLC_CD'].selectOption(friTpIdx,true,true);
    */
	
	//var comboList = items['C106000060_Grid_5'].getMasterCombos();
	//ui.combo.master(combo11,'SZ0000','QLT_DSN_CFM_TP','totalValue=,orderBy=value',function(){ 
	//	combo11.selectOption(2,true,true);
	//	combo11.readonly(true);
	//	combo11.setOptionHeight(220);
		//combo11.enableOptionAutoPositioning(true);
	//	});
	
	//주공정
	combo1.attachEvent("onSelectionChange", function(){
		var grid5  =  items['C106000060_Grid_5'];
		var gridObj  = grid5.getDhxGrid();
		var comboVal  = grid5.getCellByIndexValue(2,5);//주공정
		var comboVal1  = grid5.getCellByIndexValue(3,5);//대체공정1
		var comboVal2  = grid5.getCellByIndexValue(4,5);//대체공정2
		var comboVal3  = grid5.getCellByIndexValue(5,5);//대체공정3
		if(!isNull(combo1.getSelectedValue())){
			if(comboVal1 == combo1.getSelectedValue() || comboVal2 == combo1.getSelectedValue() || comboVal3 == combo1.getSelectedValue()){
				alert("주공정을 대체공정1,2,3과 같은공정을 선택하실수 없습니다.");			
				gridObj.selectCell(2,5,false,false);			
				grid5.setCellByIndexValue(2,5,comboVal);//주공정
				grid5.setUpdated(gridObj.getRowId(2),false,""); 
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				items['C106000060_Grid_1'].setUpdated(items['C106000060_Grid_1'].getRowSelectedId(),false,rowStatus); 
			}
		}
	});  
	//대체공정1
	combo2.attachEvent("onSelectionChange", function(){
		var grid5  =  items['C106000060_Grid_5'];
		var gridObj  = grid5.getDhxGrid();
		var comboVal  = grid5.getCellByIndexValue(2,5);//주공정
		var comboVal1  = grid5.getCellByIndexValue(3,5);//대체공정1
		var comboVal2  = grid5.getCellByIndexValue(4,5);//대체공정2
		if(!isNull(combo2.getSelectedValue())){
			if(comboVal == combo2.getSelectedValue()){
				alert("대체공정1은 주공정과 같은공정을 선택하실수 없습니다.");			
				gridObj.selectCell(3,5,false,false);			
				grid5.setCellByIndexValue(3,5,comboVal1);//대체공정1
				grid5.setUpdated(gridObj.getRowId(3),false,""); 
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				items['C106000060_Grid_1'].setUpdated(items['C106000060_Grid_1'].getRowSelectedId(),false,rowStatus); 
			}
		}
	});  
	//대체공정2
	combo3.attachEvent("onSelectionChange", function(){
		var grid5  =  items['C106000060_Grid_5'];
		var gridObj  = grid5.getDhxGrid();
		var comboVal  = grid5.getCellByIndexValue(2,5);//주공정
		var comboVal1  = grid5.getCellByIndexValue(3,5);//대체공정1
		var comboVal2  = grid5.getCellByIndexValue(4,5);//대체공정2
		if(!isNull(combo3.getSelectedValue())){
			if(comboVal == combo3.getSelectedValue() || comboVal1 == combo3.getSelectedValue()){
				alert("대체공정2은 주공정및 대체공정1과 같은공정을 선택하실수 없습니다.");			
				gridObj.selectCell(4,5,false,false);			
				grid5.setCellByIndexValue(4,5,comboVal2);//대체공정2
				grid5.setUpdated(gridObj.getRowId(4),false,""); 
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				items['C106000060_Grid_1'].setUpdated(items['C106000060_Grid_1'].getRowSelectedId(),false,rowStatus); 
			}
		}
	}); 
	//대체공정3
	combo6.attachEvent("onSelectionChange", function(){
		var grid5  =  items['C106000060_Grid_5'];
		var gridObj  = grid5.getDhxGrid();
		var comboVal  = grid5.getCellByIndexValue(2,5);//주공정
		var comboVal1  = grid5.getCellByIndexValue(3,5);//대체공정1
		var comboVal2  = grid5.getCellByIndexValue(4,5);//대체공정2
		var comboVal3  = grid5.getCellByIndexValue(5,5);//대체공정3
		if(!isNull(combo6.getSelectedValue())){
			if(comboVal == combo6.getSelectedValue() || comboVal1 == combo6.getSelectedValue() || comboVal2 == combo6.getSelectedValue()){
				alert("대체공정3은 주공정및 대체공정1,2와 같은공정을 선택하실수 없습니다.");			
				gridObj.selectCell(5,5,false,false);			
				grid5.setCellByIndexValue(5,5,comboVal3);//대체공정3
				grid5.setUpdated(gridObj.getRowId(5),false,""); 
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				items['C106000060_Grid_1'].setUpdated(items['C106000060_Grid_1'].getRowSelectedId(),false,rowStatus); 
			}
		}
	}); 
	items['C106000060_Grid_5'].getDhxGrid().detachEvent(onXleGrid5);
}

function onGridAfterUpdateFinishEvent(){
	items['C106000060_Grid_1'].clearDataProcess();
	var grid = items['C106000060_Grid_1'];
	var gridObj = items['C106000060_Grid_1'].getDhxGrid();
	var gridObj2 = items['C106000060_Grid_2'].getDhxGrid();
	var gridObj3 = items['C106000060_Grid_3'].getDhxGrid();
	var gridObj4 = items['C106000060_Grid_4'].getDhxGrid();
	var gridObj9 = items['C106000060_Grid_9'].getDhxGrid();
	var gridObj5 = items['C106000060_Grid_5'].getDhxGrid();
	var grid_cnt1 = gridObj.getRowsNum();
	var grid_cnt2 = gridObj2.getRowsNum();
	var grid_cnt3 = gridObj3.getRowsNum();
	var grid_cnt4 = gridObj4.getRowsNum();
	var grid_cnt9 = gridObj9.getRowsNum();	
	var grid_cnt5 = gridObj5.getRowsNum();
	
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj.getRowId(i);
        items['C106000060_Grid_1'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt2; i++){
		var rowID = gridObj.getRowId(i);
        items['C106000060_Grid_2'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt3; i++){
		var rowID = gridObj3.getRowId(i);
        items['C106000060_Grid_3'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt4; i++){
		var rowID = gridObj4.getRowId(i);
        items['C106000060_Grid_4'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt9; i++){
		var rowID = gridObj9.getRowId(i);
        items['C106000060_Grid_9'].setUpdated(rowID,false,""); 
	}	
	for(var i=0; i< grid_cnt5; i++){
		var rowID = gridObj5.getRowId(i);
        items['C106000060_Grid_5'].setUpdated(rowID,false,""); 
	}
	var formObj = items['C106000060_Form_1'];
	var cclBomNo = formObj.getItemValue("CCL_BOM_NO");	
	var paramCclBomNo = "";
	if(!isNull(cclBomNo)){
		paramCclBomNo = cclBomNo;
	}else{	
		paramCclBomNo = grid.getCellValue(grid.getRowSelectedId(),0);
	}
	//var findUrl = "basicGridData.do?ServiceName=C106000060-service&find=1&CCL_BOM_NO="+paramCclBomNo+"&column-info="+items["C106000060_Grid_1"].getColumnInfo()+"&blank-row-count="+items["C106000060_Grid_1"].getBlankRowCntInfo();
	//items["C106000060_Grid_1"].loadData(findUrl,findAfterFunction);	
	find("find",'C106000060_Form_1',"C106000060_Grid_1");
}

function onGridAfterUpdateFinishEvent2(){	
	items['C106000060_Grid_2'].clearDataProcess();
	var gridObj1 = items['C106000060_Grid_2'].getDhxGrid();
	var gridObj2 = items['C106000060_Grid_2'].getDhxGrid();
	var gridObj3 = items['C106000060_Grid_3'].getDhxGrid();
	var gridObj4 = items['C106000060_Grid_4'].getDhxGrid();
	var gridObj9 = items['C106000060_Grid_9'].getDhxGrid();	
	var gridObj5 = items['C106000060_Grid_5'].getDhxGrid();
	var grid_cnt1 = gridObj1.getRowsNum();
	var grid_cnt2 = gridObj2.getRowsNum();
	var grid_cnt3 = gridObj3.getRowsNum();
	var grid_cnt4 = gridObj4.getRowsNum();
	var grid_cnt9 = gridObj9.getRowsNum();	
	var grid_cnt5 = gridObj5.getRowsNum();
	
	for(var i=0; i< grid_cnt1; i++){
		var rowID = gridObj1.getRowId(i);
        items['C106000060_Grid_1'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt2; i++){
		var rowID = gridObj2.getRowId(i);
        items['C106000060_Grid_2'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt3; i++){
		var rowID = gridObj3.getRowId(i);
        items['C106000060_Grid_3'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt4; i++){
		var rowID = gridObj4.getRowId(i);
        items['C106000060_Grid_4'].setUpdated(rowID,false,""); 
	}
	for(var i=0; i< grid_cnt9; i++){
		var rowID = gridObj9.getRowId(i);
        items['C106000060_Grid_9'].setUpdated(rowID,false,""); 
	}	
	for(var i=0; i< grid_cnt5; i++){
		var rowID = gridObj5.getRowId(i);
        items['C106000060_Grid_5'].setUpdated(rowID,false,""); 
	}
	var detailFindUrl = parameters14('C106000060_Grid_1','C106000060_Grid_2','detailFind','basicGridData.do');
	items["C106000060_Grid_2"].loadData(detailFindUrl,afterProGressOff);	//칼라 물성정보조회
	
}
function afterProGressOff(){
	uiCommon.progressOff(parent);
	return true;
}
function findMessage(referenceItem){
  items['C106000060_Grid_1'].getDhxGrid().selectRow(0); //08-21 findAfter에서 이동
	deteilCclBomNo(items['C106000060_Grid_1'].getSelectedRowId(),0); //08-21 findAfter에서 이동
	uiCommon.message("C106000060_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onCheckboxEvent(rId,cInd,state){
	var gridObj = items['C106000060_Grid_1'];
	
	/*
	if(cInd != 199 || cInd != 205){ // 보증서발행가능여부(CCL_BOM_WR_YN)가 아닐경우 
		//var cellValue = gridObj.getCellValue(rId,9);
		if(state){
			gridObj.setCellValue(rId,11,'Y');
		}else{
			gridObj.setCellValue(rId,11,'N');
		}	
	}
	*/
}

function setCellTypeReadOnly(){
	// 삭제시 색상코드 column type변경 
	var gridObj3 = items['C106000060_Grid_3'].getDhxGrid();
	var rowCount = gridObj3.getRowsNum();
	var rowId = gridObj.getRowSelectedId();
	var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(rowId,"!nativeeditor_status");
	if( rowStatus != "inserted"){
		for (var i=0; i<rowCount ; i++){
		   gridObj3.setCellExcellType(gridObj3.getRowId(i), 0, "ro");
		}
	}
}

function setCellTypeEdit(){
// 행추가시 색상코드 column type변경 
	var gridObj3 = items['C106000060_Grid_3'].getDhxGrid();
	var rowCount = gridObj3.getRowsNum();
	var rowId = gridObj.getRowSelectedId();
	var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(rowId,"!nativeeditor_status");
	if( rowStatus == "inserted"){
		for (var i=0; i<rowCount ; i++){
		   gridObj3.setCellExcellType(gridObj3.getRowId(i), 0, "ed");
		}
	}
}

var winObj;
function gridPopup2(rId,cInd){
	var grid = items['C106000060_Grid_1'];
	var gridObj2 = items['C106000060_Grid_2'];
	var grid2DhxObj = items['C106000060_Grid_2'].getDhxGrid();
	if(isNull(grid.getRowSelectedId())){
			alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");			
			return;
	}	
	if(cInd == 0){
		var cellVal = gridObj2.getCellValue(rId,cInd);
		winObj = new ui.window("cusCdPopup","고객사","0","0","469","532","masterGridData.do?CD_TP=CUS_CD&CATEGORY_GROUP_NM=SZ0000&targetName=C106000060_Grid_2&targetFormID=C106000060_Grid_2&CD_V="+encodeURIComponent(cellVal)+"&targetRowIndex="+grid2DhxObj.getRowIndex(rId)+"&targetCellIndex="+cInd);
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		return;
		//winObj.getDhxWindow().setPosition(500,500);
	}else if(cInd == 1){
		var cellVal = gridObj2.getCellValue(rId,cInd);
		winObj = new ui.window("cusCdPopup1","고객사1","0","0","469","532","masterGridData.do?CD_TP=CUS_CD&CATEGORY_GROUP_NM=SZ0000&targetName=C106000060_Grid_2&targetFormID=C106000060_Grid_2&CD_V="+encodeURIComponent(cellVal)+"&targetRowIndex="+grid2DhxObj.getRowIndex(rId)+"&targetCellIndex="+cInd);
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		return;
	}else{
		return true;
	}
	winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;
			//winObj.unload();
	});
	return true;
}

function rollSelectPopup4(rId,cInd){
	var grid = items['C106000060_Grid_1'];
	var gridObj4 = items['C106000060_Grid_4'];
	var grid4DhxObj = items['C106000060_Grid_4'].getDhxGrid();
	if(isNull(grid.getRowSelectedId())){
			alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");			
			return;
	}	
	if(cInd == 0 || cInd == 4 || cInd == 8 || cInd == 12){
		var cellVal = gridObj4.getCellValue(rId,cInd);
		winObj = new ui.window("rollSelectPopup","Print롤 선택","0","0","669","532","c106000060pop01.do?prt_roll_no="+encodeURIComponent(cellVal)+"&rowId="+rId+"&cellIndex="+cInd+"&targetDivId=C106000060_Grid_4");		
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		//winObj.getDhxWindow().setPosition(500,500);
		winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;
			//winObj.unload();
		});
		
	}else if(cInd == 1 || cInd == 5 || cInd == 9 || cInd == 13){
		grid4DhxObj.setCellExcellType(grid4DhxObj.getRowId(0), cInd, "ed"); // 확정컬럼 ch로 변경
		return true;
	}else if(cInd == 16){
		//2013.07.25 UNI-TEX ROLL번호 자동입력 용 POP-UP프로그램 호출
		var cellVal = gridObj4.getCellValue(rId,cInd);
		winObj = new ui.window("rollSelectPopup2","Uni-Tex Roll선택","100","100","669","532","c106000060pop02.do?uni_tex_roll_no="+encodeURIComponent(cellVal)+"&rowId="+rId+"&cellIndex="+cInd+"&targetDivId=C106000060_Grid_4");		
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		
		winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;	
		});
	}else if(cInd == 17){
		//2014.02.21 PICK-UP ROLL번호 자동입력 용 POP-UP프로그램 호출
		var cellVal = gridObj4.getCellValue(rId,cInd);
		winObj = new ui.window("rollSelectPopup3","Pick-Up Roll선택","100","100","669","532","c106000060pop03.do?pick_up_roll_no="+encodeURIComponent(cellVal)+"&rowId="+rId+"&cellIndex="+cInd+"&targetDivId=C106000060_Grid_4");		
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		
		winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;	
		});
	}else if(cInd == 18){
		//2015.11.09 IMPRINTING ROLL번호 자동입력 용 POP-UP프로그램 호출
		var cellVal = gridObj4.getCellValue(rId,cInd);
		winObj = new ui.window("rollSelectPopup4","Imprinting Roll선택","100","100","669","532","c106000060pop04.do?impt_roll_no="+encodeURIComponent(cellVal)+"&rowId="+rId+"&cellIndex="+cInd+"&targetDivId=C106000060_Grid_4");		
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		
		winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;	
		});
	}
}
function rollSelectPopup9(rId,cInd){
	var grid = items['C106000060_Grid_1'];
	var gridObj9 = items['C106000060_Grid_9'];
	var grid9DhxObj = items['C106000060_Grid_9'].getDhxGrid();
	if(isNull(grid.getRowSelectedId())){
			alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");			
			return;
	}	
	if(cInd == 0 || cInd == 4 || cInd == 8 || cInd == 12){
		var cellVal = gridObj9.getCellValue(rId,cInd);
		winObj = new ui.window("rollSelectPopup","Print롤 선택","0","0","669","532","c106000060pop01.do?prt_roll_no="+encodeURIComponent(cellVal)+"&rowId="+rId+"&cellIndex="+cInd+"&targetDivId=C106000060_Grid_9");		
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		//winObj.getDhxWindow().setPosition(500,500);
		winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;
			//winObj.unload();
		});
	}else if(cInd == 1 || cInd == 5 || cInd == 9 || cInd == 13){
		grid9DhxObj.setCellExcellType(grid9DhxObj.getRowId(0), cInd, "ed"); // 확정컬럼 ch로 변경
		return true;
	}else if(cInd == 18){
		//2015.12.17 IMPRINTING BACK ROLL번호 자동입력 용 POP-UP프로그램 호출
		var cellVal = gridObj9.getCellValue(rId,cInd);
		winObj = new ui.window("rollSelectPopup9","Imprinting Roll선택","100","100","669","532","c106000060pop05.do?impt_roll_no="+encodeURIComponent(cellVal)+"&rowId="+rId+"&cellIndex="+cInd+"&targetDivId=C106000060_Grid_9");		
		winObj.setButtonDisable("park,minmax1");
		winObj.setModal();
		
		winObj.getDhxWindow().attachEvent("onClose", function(win){
			this.hide();
			return true;	
		});
	}
}
//색상코드 TB_C10_CLR_CD_MNG테이블에서 조회(S31,S32,S35)
function onEditCellEvent3(stage,rId,cInd,nValue,oValue){
	var grid = items['C106000060_Grid_1'];
	var grid3 = items['C106000060_Grid_3'];
	var grdObj = items['C106000060_Grid_3'].getDhxGrid();
	var grid_cnt = grid3.getDhxGrid().getRowsNum();	
	
	var hueCdFrnMax =""; //색상코드 전면
	var hueCdBakMin =""; //색상코드 후면
	var pntFlmThkMax = 0;//도막두께 전면
	var pntFlmThkMin = 0;//도막두께 후면
	var lusRtCdFrnMax = ""; //광택도코드 전면
	var lusRtCdBakMin = ""; //광택도코드 후면
	var rsnTtpFrnMax = "";//수지코드 전면
	var rsnTpBakMin = "";//수지코드 후면
	var subMtlTp1 = "";
	var subMtlTp2 = "";
	var subMtlTp3 = "";
	var subMtlTp4 = "";
	var subMtlTp5 = "";
	var subMtlTp6 = "";
	var param = ""; 
	if(stage == 1 ){	
		if(isNull(grid.getRowSelectedId())){
			alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");
//			grdObj.selectRow(-1);
			//grdObj.selectCell(1,1,false,false);
			grdObj.clearSelection();		
			return;
		}
		var rowStatus = grid.getDhxGrid().getUserData(grid.getRowSelectedId(),"!nativeeditor_status");
		if(isNull(rowStatus) && isNull(grid.getCellValue(grid.getRowSelectedId(),0))){		
			alert("CCL BOM NO 행추가 또는 CCL BOM NO를 선택해주세요.");
			grdObj.clearSelection();	
			return;
		}
		//else if (isNull(grid.getCellByIndexValue(0,0))){
		//	alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");
		//	grdObj.clearSelection();		
		//	return;
		//}
		
		//순차적 색상코드 입력 체크
		if(!isNull(grid.getRowSelectedId())){
			if(rId == "1" ){
				if(isNull(grid3.getCellByIndexValue(2,0))){
					alert("TOP 3C를 입력해주세요.");
					grdObj.selectCell(2,0,false,false);
					return;
				}
			}else if(rId == "2" ){
				if(isNull(grid3.getCellByIndexValue(3,0))){
					alert("TOP 2C를 입력해주세요.");
					grdObj.selectCell(3,0,false,false);
					return;
				}
			}else if(rId == "3" ){
				if(isNull(grid3.getCellByIndexValue(4,0))){
					alert("TOP 1C를 입력해주세요.");
					grdObj.selectCell(4,0,false,false);
					return;
				}
			}else if(rId == "6" ){
				if(isNull(grid3.getCellByIndexValue(5,0))){
					alert("BACK 1C를 입력해주세요.");
					grdObj.selectCell(5,0,false,false);
					return;
				}
			}else if(rId == "7" ){
				if(isNull(grid3.getCellByIndexValue(6,0))){
					alert("BACK 2C를 입력해주세요.");
					grdObj.selectCell(6,0,false,false);
					return;
				}
			}else if(rId == "8" ){
				if(isNull(grid3.getCellByIndexValue(7,0))){
					alert("BACK 3C를 입력해주세요.");
					grdObj.selectCell(7,0,false,false);
					return;
				}
		 }else if(rId == "9" ){
				if(cInd==0){
					 var gridObj = items["C106000060_Grid_3"].getDhxGrid();
					 gridObj.editor.obj.onkeyup = function(){
					  //var valueLength = gridObj.editor.obj.value+'';
					  var valueLength = gridObj.editor.getValue();					  
					   if(!hanCheck(valueLength,'6')){
						   alert("5자리만 입력 가능합니다.");
						   gridObj.editor.obj.value = "";
						   return false;
					    }				
				    }
					//대문자	
					gridObj.editor.obj.onkeydown = function(e){
		  		    //var cellValue = gridObj.editor.obj.value;
		  		    var cellValue = gridObj.editor.getValue();
		  			    if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
		  				    gridObj.editor.obj.value = cellValue.toUpperCase();
		  			    }
		  		    }
				}
			}
		}
	}else if(stage == 2){
		if(!isNull(grid.getRowSelectedId())){
			if(rId == "1" || rId == "2" || rId == "3" || rId == "4" || rId == "5" || rId == "6" || rId == "7" || rId == "8" ){
				if(cInd==0){
					if(!isNull(oValue) && isNull(nValue)){
						items['C106000060_Grid_3'].setCellValue(rId,0, "");//색상코드							
						items['C106000060_Grid_3'].setCellValue(rId,1, "");//수지타입(마스터)
						items['C106000060_Grid_3'].setCellValue(rId,2, "");//광택코드(마스터)
						items['C106000060_Grid_3'].setCellValue(rId,3, "");//광택도(하한-상한)
						items['C106000060_Grid_3'].setCellValue(rId,4, "");//작업점도
						items['C106000060_Grid_3'].setCellValue(rId,5, "");//PMT
						items['C106000060_Grid_3'].setCellValue(rId,6, "");//도막
						items['C106000060_Grid_3'].setCellValue(rId,7, "");//용제비중
						items['C106000060_Grid_3'].setCellValue(rId,8, "");//도료비중
						items['C106000060_Grid_3'].setCellValue(rId,9, "");//고형분
						items['C106000060_Grid_3'].setCellValue(rId,10, "");//원단위
						items['C106000060_Grid_3'].setCellValue(rId,11, "");//시너	
						items['C106000060_Grid_3'].setCellValue(rId,12, "");//구칼라부자재코드	
						if(rId == "1" ){
							
							//색상코드(4차 TOP)정보 CCL-BOM정보로 Setting
							items['C106000060_Grid_3'].setCellValue(rId,104, "");//광택도코드4(전면)
							items['C106000060_Grid_3'].setCellValue(rId,103, "");//수지타입4(전면)						
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),12,"");//색상코드4차(전면)					
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),13,"");//수지타입4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),14,"");//광택도코드4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),15,"");//광택도4(하한)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),132,"");//광택도4(상한)										
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),16,"");//작업점도4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),17,"");//PMT4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),18,"");//도막4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),19,"");//용제비중4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),20,"");//도료비중4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),21,"");//고형분4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),22,"");//원단위4(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),23,"");//시너4(전면)	
						}else if(rId == "2"){
							
								//색상코드(3차 TOP)정보 CCL-BOM정보로 Setting
								items['C106000060_Grid_3'].setCellValue(rId,14,"");//광택도코드3(전면)
								items['C106000060_Grid_3'].setCellValue(rId,13,"");//수지타입3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),24,"");//색상코드3차(전면)					
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),25,"");//수지타입3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),26,"");//광택도코드3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),27,"");//광택도3(하한)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),133,"");//광택도3(상한)										
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),28,"");//작업점도3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),29,"");//PMT3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),30,"");//도막3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),31,"");//용제비중3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),32,"");//도료비중3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),33,"");//고형분3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),34,"");//원단위3(전면)
								items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),35,"");//시너3(전면)			
						}else if(rId == "3"){
							
							//색상코드(2차 TOP)정보 CCL-BOM정보로 Setting
							items['C106000060_Grid_3'].setCellValue(rId,26, "");//광택도코드2(전면)
							items['C106000060_Grid_3'].setCellValue(rId,25, "");//수지타입2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),36,"");//색상코드2차(전면)					
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),37,"");//수지타입2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),38,"");//광택도코드2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),39,"");//광택도2(하한)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),134,"");//광택도2(상한)										
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),40,"");//작업점도2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),41,"");//PMT2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),42,"");//도막2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),43,"");//용제비중2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),44,"");//도료비중2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),45,"");//고형분2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),46,"");//원단위2(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),47,"");//시너2(전면)				
						}else if(rId == "4"){
							
							//색상코드(1차 TOP)정보 CCL-BOM정보로 Setting
							items['C106000060_Grid_3'].setCellValue(rId,38,"");//광택도코드1(전면)
							items['C106000060_Grid_3'].setCellValue(rId,37,"");//수지타입1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),48,"");//색상코드1차(전면)					
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),49,"");//수지타입1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),50,"");//광택도코드1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),51,"");//광택도1(하한)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),135,"");//광택도1(상한)										
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),52,"");//작업점도1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),53,"");//PMT1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),54,"");//도막1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),55,"");//용제비중1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),56,"");//도료비중1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),57,"");//고형분1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),58,"");//원단위1(전면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),59,"");//시너1(전면)			
						}else if(rId == "5"){
							
							//색상코드(1차 BACK)정보 CCL-BOM정보로 Setting
							items['C106000060_Grid_3'].setCellValue(rId,50, "");//광택도코드1(후면)
							items['C106000060_Grid_3'].setCellValue(rId,49, "");//수지타입1(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),60,"");//색상코드1차(후면)					
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),61,"");//수지타입1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),62,"");//광택도코드1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),63,"");//광택도1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),136,"");//광택도1차(후면)											
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),64,"");//작업점도1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),65,"");//PMT1차(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),66,"");//도막1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),67,"");//용제비중1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),68,"");//도료비중1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),69,"");//고형분1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),70,"");//원단위1차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),71,"");//시너1차(후면)
			
						}else if(rId == "6"){	
							
							//색상코드(2차 BACK)정보 CCL-BOM정보로 Setting
							items['C106000060_Grid_3'].setCellValue(rId,62, "");//광택도코드2(후면)
							items['C106000060_Grid_3'].setCellValue(rId,61, "");//수지타입2(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),72,"");//색상코드2차(후면)					
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),73,"");//수지타입2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),74,"");//광택도코드2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),75,"");//광택도2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),137,"");//광택도2차(후면)											
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),76,"");//작업점도2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),77,"");//PMT2차(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),78,"");//도막2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),79,"");//용제비중2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),80,"");//도료비중2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),81,"");//고형분2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),82,"");//원단위2차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),83,"");//시너2차(후면)		
						}else if(rId == "7"){	
							
							//색상코드(3차 BACK)정보 CCL-BOM정보로 Setting
							items['C106000060_Grid_3'].setCellValue(rId,74, "");//광택도코드3(후면)
							items['C106000060_Grid_3'].setCellValue(rId,73, "");//수지타입3(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),84,"");//색상코드3차(후면)					
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),85,"");//수지타입3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),86,"");//광택도코드3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),87,"");//광택도3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),138,"");//광택도3차(후면)											
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),88,"");//작업점도3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),89,"");//PMT3차(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),90,"");//도막3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),91,"");//용제비중3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),92,"");//도료비중3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),93,"");//고형분3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),94,"");//원단위3차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),95,"");//시너3차(후면)		
						}else if(rId == "7"){
							
							//색상코드(4차 BACK)정보 CCL-BOM정보로 Setting
							items['C106000060_Grid_3'].setCellValue(rId,86, "");//광택도코드4(후면)
							items['C106000060_Grid_3'].setCellValue(rId,85, "");//수지타입4(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),96,"");//색상코드4차(후면)					
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),97,"");//수지타입4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),98,"");//광택도코드4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),99,"");//광택도4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),139,"");//광택도4차(후면)											
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),100,"");//작업점도4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),101,"");//PMT4차(후면)
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),102,"");//도막4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),103,"");//용제비중4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),104,"");//도료비중4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),105,"");//고형분4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),106,"");//원단위4차(후면)	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),107,"");//시너4차(후면)			
						}
						
						var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
						
						if(rowStatus!="inserted"){
							items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated");	
						}
						
						//items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
					
					}else if(oValue !=nValue){
						subMtlTp1 = "S31";
						subMtlTp2 = "S32";
						subMtlTp3 = "S35";
					    subMtlTp4 = "ZZZ";  
					    subMtlTp5 = "";
					    subMtlTp6 = "S37";
					    //Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
						param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,RSN_TP_NM,LUS_RT_CD_NM,LUS_RT,WK_VISCO,PMT,PNT_FLM_THK,SLV_GRA,PNT_GRA,NV,PNT_UNT,THR_CD,LUS_RT_LLV,LUS_RT_ULV,RSN_TP,LUS_RT_CD,CLR_SUB_MTL_CD_OLD,SUB_MTL_TP,CLR_NM,USE_YN,ERP_SND_DH";	
					    var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
					    var cells = xmlObj.getElementsByTagName("cell"); 
					     
							if(cells.length > 0){
								
								if(cells.item(19).firstChild.nodeValue == "N"){						
		    						alert("컬러코드 사용유무를 확인하세요!");
		    						return;					
		    					}  //컬러코드 미사용인경우는 bom등록이 안되게 체크
		    					
								if(cells.item(20).firstChild.nodeValue == ""){						
		    						alert("컬러코드관리 프로그램에서 ERP MM으로 컬러코드 전송 후 사용하세요!");
		    						return;					
		    					}  //ERP전송일자가 없는경우 CCL BOM에서 컬러코드 사용 못하게 에러체크(2013.06.04 이돈석 - 문제등록)
								
								//'C106000060_Grid_3 Data설정;
								items['C106000060_Grid_3'].setCellValue(rId,0, cells.item(0).firstChild.nodeValue);//색상코드							
								items['C106000060_Grid_3'].setCellValue(rId,1, cells.item(1).firstChild.nodeValue);//수지타입(마스터)
								items['C106000060_Grid_3'].setCellValue(rId,2, cells.item(2).firstChild.nodeValue);//광택코드(마스터)
								items['C106000060_Grid_3'].setCellValue(rId,3, cells.item(3).firstChild.nodeValue);//광택도(하한-상한)
								items['C106000060_Grid_3'].setCellValue(rId,4, cells.item(4).firstChild.nodeValue);//작업점도
								items['C106000060_Grid_3'].setCellValue(rId,5, cells.item(5).firstChild.nodeValue);//PMT
								items['C106000060_Grid_3'].setCellValue(rId,6, cells.item(6).firstChild.nodeValue);//도막
								items['C106000060_Grid_3'].setCellValue(rId,7, cells.item(7).firstChild.nodeValue);//용제비중
								items['C106000060_Grid_3'].setCellValue(rId,8, cells.item(8).firstChild.nodeValue);//도료비중
								items['C106000060_Grid_3'].setCellValue(rId,9, cells.item(9).firstChild.nodeValue);//고형분
								items['C106000060_Grid_3'].setCellValue(rId,10, cells.item(10).firstChild.nodeValue);//원단위
								items['C106000060_Grid_3'].setCellValue(rId,11, cells.item(11).firstChild.nodeValue);//시너											
								items['C106000060_Grid_3'].setCellValue(rId,12, cells.item(16).firstChild.nodeValue);//구칼라부자재코드	
								items['C106000060_Grid_3'].setCellValue(rId,133, cells.item(18).firstChild.nodeValue);//상세색상   08-08 5grid상세색상명
								
								if(rId == "1"){										
									//색상코드(4차 TOP)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,104, cells.item(15).firstChild.nodeValue);//광택도코드4(전면)
									items['C106000060_Grid_3'].setCellValue(rId,103, cells.item(14).firstChild.nodeValue);//수지타입4(전면)
									
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),12,cells.item(0).firstChild.nodeValue);//색상코드4차(전면)					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),13,cells.item(14).firstChild.nodeValue);//수지타입4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),14,cells.item(15).firstChild.nodeValue);//광택도코드4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),15,cells.item(13).firstChild.nodeValue);//광택도4(하한)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),132,cells.item(12).firstChild.nodeValue);//광택도4(상한)										
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),16,cells.item(4).firstChild.nodeValue);//작업점도4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),17,cells.item(5).firstChild.nodeValue);//PMT4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),18,cells.item(6).firstChild.nodeValue);//도막4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),19,cells.item(7).firstChild.nodeValue);//용제비중4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),20,cells.item(8).firstChild.nodeValue);//도료비중4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),21,cells.item(9).firstChild.nodeValue);//고형분4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),22,cells.item(10).firstChild.nodeValue);//원단위4(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),23,cells.item(11).firstChild.nodeValue);//시너4(전면)	
								}else if(rId == "2"){										
									//색상코드(3차 TOP)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,14, cells.item(15).firstChild.nodeValue);//광택도코드3(전면)
									items['C106000060_Grid_3'].setCellValue(rId,13, cells.item(14).firstChild.nodeValue);//수지타입3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),24,cells.item(0).firstChild.nodeValue);//색상코드3차(전면)					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),25,cells.item(14).firstChild.nodeValue);//수지타입3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),26,cells.item(15).firstChild.nodeValue);//광택도코드3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),27,cells.item(13).firstChild.nodeValue);//광택도3(하한)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),133,cells.item(12).firstChild.nodeValue);//광택도3(상한)										
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),28,cells.item(4).firstChild.nodeValue);//작업점도3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),29,cells.item(5).firstChild.nodeValue);//PMT3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),30,cells.item(6).firstChild.nodeValue);//도막3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),31,cells.item(7).firstChild.nodeValue);//용제비중3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),32,cells.item(8).firstChild.nodeValue);//도료비중3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),33,cells.item(9).firstChild.nodeValue);//고형분3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),34,cells.item(10).firstChild.nodeValue);//원단위3(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),35,cells.item(11).firstChild.nodeValue);//시너3(전면)	
									items['C106000060_Grid_3'].getDhxGrid().selectCell(1,0,false,false,true);
								}else if(rId == "3"){										
									//색상코드(2차 TOP)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,26, cells.item(15).firstChild.nodeValue);//광택도코드2(전면)
									items['C106000060_Grid_3'].setCellValue(rId,25, cells.item(14).firstChild.nodeValue);//수지타입2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),36,cells.item(0).firstChild.nodeValue);//색상코드2차(전면)					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),37,cells.item(14).firstChild.nodeValue);//수지타입2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),38,cells.item(15).firstChild.nodeValue);//광택도코드2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),39,cells.item(13).firstChild.nodeValue);//광택도2(하한)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),134,cells.item(12).firstChild.nodeValue);//광택도2(상한)										
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),40,cells.item(4).firstChild.nodeValue);//작업점도2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),41,cells.item(5).firstChild.nodeValue);//PMT2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),42,cells.item(6).firstChild.nodeValue);//도막2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),43,cells.item(7).firstChild.nodeValue);//용제비중2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),44,cells.item(8).firstChild.nodeValue);//도료비중2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),45,cells.item(9).firstChild.nodeValue);//고형분2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),46,cells.item(10).firstChild.nodeValue);//원단위2(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),47,cells.item(11).firstChild.nodeValue);//시너2(전면)	
									items['C106000060_Grid_3'].getDhxGrid().selectCell(2,0,false,false,true);
								}else if(rId == "4"){										
									//색상코드(1차 TOP)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,38, cells.item(15).firstChild.nodeValue);//광택도코드1(전면)
									items['C106000060_Grid_3'].setCellValue(rId,37, cells.item(14).firstChild.nodeValue);//수지타입1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),48,cells.item(0).firstChild.nodeValue);//색상코드1차(전면)					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),49,cells.item(14).firstChild.nodeValue);//수지타입1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),50,cells.item(15).firstChild.nodeValue);//광택도코드1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),51,cells.item(13).firstChild.nodeValue);//광택도1(하한)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),135,cells.item(12).firstChild.nodeValue);//광택도1(상한)										
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),52,cells.item(4).firstChild.nodeValue);//작업점도1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),53,cells.item(5).firstChild.nodeValue);//PMT1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),54,cells.item(6).firstChild.nodeValue);//도막1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),55,cells.item(7).firstChild.nodeValue);//용제비중1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),56,cells.item(8).firstChild.nodeValue);//도료비중1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),57,cells.item(9).firstChild.nodeValue);//고형분1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),58,cells.item(10).firstChild.nodeValue);//원단위1(전면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),59,cells.item(11).firstChild.nodeValue);//시너1(전면)		
									items['C106000060_Grid_3'].getDhxGrid().selectCell(3,0,false,false,true);
								}else if(rId == "5"){										
									//색상코드(1차 BACK)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,50, cells.item(15).firstChild.nodeValue);//광택도코드1(후면)
									items['C106000060_Grid_3'].setCellValue(rId,49, cells.item(14).firstChild.nodeValue);//수지타입1(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),60,cells.item(0).firstChild.nodeValue);//색상코드1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),61,cells.item(14).firstChild.nodeValue);//수지타입1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),62,cells.item(15).firstChild.nodeValue);//광택도코드1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),63,cells.item(13).firstChild.nodeValue);//광택도1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),136,cells.item(12).firstChild.nodeValue);//광택도1차(후면)											
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),64,cells.item(4).firstChild.nodeValue);//작업점도1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),65,cells.item(5).firstChild.nodeValue);//PMT1차(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),66,cells.item(6).firstChild.nodeValue);//도막1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),67,cells.item(7).firstChild.nodeValue);//용제비중1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),68,cells.item(8).firstChild.nodeValue);//도료비중1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),69,cells.item(9).firstChild.nodeValue);//고형분1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),70,cells.item(10).firstChild.nodeValue);//원단위1차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),71,cells.item(11).firstChild.nodeValue);//시너1차(후면)	
									items['C106000060_Grid_3'].getDhxGrid().selectCell(6,0,false,false,true);
								}else if(rId == "6"){										
									//색상코드(2차 BACK)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,62, cells.item(15).firstChild.nodeValue);//광택도코드2(후면)
									items['C106000060_Grid_3'].setCellValue(rId,61, cells.item(14).firstChild.nodeValue);//수지타입2(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),72,cells.item(0).firstChild.nodeValue);//색상코드2차(후면)					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),73,cells.item(14).firstChild.nodeValue);//수지타입2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),74,cells.item(15).firstChild.nodeValue);//광택도코드2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),75,cells.item(13).firstChild.nodeValue);//광택도2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),137,cells.item(12).firstChild.nodeValue);//광택도2차(후면)											
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),76,cells.item(4).firstChild.nodeValue);//작업점도2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),77,cells.item(5).firstChild.nodeValue);//PMT2차(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),78,cells.item(6).firstChild.nodeValue);//도막2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),79,cells.item(7).firstChild.nodeValue);//용제비중2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),80,cells.item(8).firstChild.nodeValue);//도료비중2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),81,cells.item(9).firstChild.nodeValue);//고형분2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),82,cells.item(10).firstChild.nodeValue);//원단위2차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),83,cells.item(11).firstChild.nodeValue);//시너2차(후면)	
									items['C106000060_Grid_3'].getDhxGrid().selectCell(7,0,false,false,true);
								}else if(rId == "7"){										
									//색상코드(3차 BACK)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,74, cells.item(15).firstChild.nodeValue);//광택도코드3(후면)
									items['C106000060_Grid_3'].setCellValue(rId,73, cells.item(14).firstChild.nodeValue);//수지타입3(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),84,cells.item(0).firstChild.nodeValue);//색상코드3차(후면)					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),85,cells.item(14).firstChild.nodeValue);//수지타입3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),86,cells.item(15).firstChild.nodeValue);//광택도코드3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),87,cells.item(13).firstChild.nodeValue);//광택도3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),138,cells.item(12).firstChild.nodeValue);//광택도3차(후면)											
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),88,cells.item(4).firstChild.nodeValue);//작업점도3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),89,cells.item(5).firstChild.nodeValue);//PMT3차(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),90,cells.item(6).firstChild.nodeValue);//도막3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),91,cells.item(7).firstChild.nodeValue);//용제비중3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),92,cells.item(8).firstChild.nodeValue);//도료비중3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),93,cells.item(9).firstChild.nodeValue);//고형분3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),94,cells.item(10).firstChild.nodeValue);//원단위3차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),95,cells.item(11).firstChild.nodeValue);//시너3차(후면)
									items['C106000060_Grid_3'].getDhxGrid().selectCell(8,0,false,false,true);
								}else if(rId == "7"){										
									//색상코드(4차 BACK)정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,86, cells.item(15).firstChild.nodeValue);//광택도코드4(후면)
									items['C106000060_Grid_3'].setCellValue(rId,85, cells.item(14).firstChild.nodeValue);//수지타입4(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),96,cells.item(0).firstChild.nodeValue);//색상코드4차(후면)					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),97,cells.item(14).firstChild.nodeValue);//수지타입4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),98,cells.item(15).firstChild.nodeValue);//광택도코드4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),99,cells.item(13).firstChild.nodeValue);//광택도4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),139,cells.item(12).firstChild.nodeValue);//광택도4차(후면)											
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),100,cells.item(4).firstChild.nodeValue);//작업점도4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),101,cells.item(5).firstChild.nodeValue);//PMT4차(후면)
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),102,cells.item(6).firstChild.nodeValue);//도막4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),103,cells.item(7).firstChild.nodeValue);//용제비중4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),104,cells.item(8).firstChild.nodeValue);//도료비중4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),105,cells.item(9).firstChild.nodeValue);//고형분4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),106,cells.item(10).firstChild.nodeValue);//원단위4차(후면)	
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),107,cells.item(11).firstChild.nodeValue);//시너4차(후면)	
									items['C106000060_Grid_3'].getDhxGrid().selectCell(9,0,false,false,true);
								}
								
								items['C106000060_Grid_3'].setUpdated(rId,true,"updated");
								var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
								if(rowStatus!="inserted"){
									items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
								}
								//items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
							}else{
								alert("해당하는 색상코드가 없습니다1.");
								items['C106000060_Grid_3'].setCellValue(rId,cInd,"");
								items['C106000060_Grid_3'].setUpdated(rId,false,""); 
								return;					
							}			
					}
				}else if(cInd==6){
						if(rId == "1"){		
							pntFlmThkMax = sumColumnTop();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),9,pntFlmThkMax);//도막두께전면Total	
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),18,nValue);//도막두께전면4Coat							
						}else if(rId == "2"){
							pntFlmThkMax = sumColumnTop();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),9,pntFlmThkMax);//도막두께전면Total
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),30,nValue);//도막두께전면3Coat
						}else if(rId == "3"){
							pntFlmThkMax = sumColumnTop();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),9,pntFlmThkMax);//도막두께전면Total
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),42,nValue);//도막두께전면2Coat
						}else if(rId == "4"){
							pntFlmThkMax = sumColumnTop();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),9,pntFlmThkMax);//도막두께전면Total
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),54,nValue);//도막두께전면1Coat
						}else if(rId == "5"){
							pntFlmThkMin = sumColumnBack();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),10,pntFlmThkMin);//도막두께후면Total
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),66,nValue);//도막두께후면1Coat
						}else if(rId == "6"){
							pntFlmThkMin = sumColumnBack();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),10,pntFlmThkMin);//도막두께후면Total
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),78,nValue);//도막두께후면1Coat
						}else if(rId == "7"){
							pntFlmThkMin = sumColumnBack();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),10,pntFlmThkMin);//도막두께후면Total
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),90,nValue);//도막두께후면1Coat
						}else if(rId == "8"){
							pntFlmThkMin = sumColumnBack();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),10,pntFlmThkMin);//도막두께후면Total
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),102,nValue);//도막두께후면1Coat
						}
						var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
						if(rowStatus!="inserted"){
								items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
						}						
						//items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				if(oValue !=nValue){ 
					setColorInfo();
				}
				return true;
			}else if(rId == "9"){
				if(cInd==0){	
					if(!isNull(oValue) && isNull(nValue)){
						items['C106000060_Grid_3'].setCellValue(rId,0, "");//색상코드							
						items['C106000060_Grid_3'].setCellValue(rId,1, "");//수지타입(마스터)
						items['C106000060_Grid_3'].setCellValue(rId,2, "");//광택코드(마스터)
						items['C106000060_Grid_3'].setCellValue(rId,3, "");//광택도(하한-상한)
						items['C106000060_Grid_3'].setCellValue(rId,4, "");//작업점도
						items['C106000060_Grid_3'].setCellValue(rId,5, "");//PMT
						items['C106000060_Grid_3'].setCellValue(rId,6, "");//도막
						items['C106000060_Grid_3'].setCellValue(rId,7, "");//용제비중
						items['C106000060_Grid_3'].setCellValue(rId,8, "");//도료비중
						items['C106000060_Grid_3'].setCellValue(rId,9, "");//고형분
						items['C106000060_Grid_3'].setCellValue(rId,10,"");//원단위
						items['C106000060_Grid_3'].setCellValue(rId,11,"");//시너	
						items['C106000060_Grid_3'].setCellValue(rId,12,"");//구칼라부자재코드
						
						items['C106000060_Grid_5'].setCellByIndexValue(0,8, "");//Lamina유형
						items['C106000060_Grid_5'].setCellByIndexValue(1,8, "");//Lamina접착제코드
						items['C106000060_Grid_5'].setCellByIndexValue(1,9, "");//Lamina접착제코드1
						items['C106000060_Grid_5'].setCellByIndexValue(2,8, "");//Lamina접착제신나코드
						items['C106000060_Grid_5'].setCellByIndexValue(2,9, "");//Lamina접착제신나코드1
						items['C106000060_Grid_5'].setCellByIndexValue(3,8, "");//Lamina필름두께코드	
					    items['C106000060_Grid_5'].setCellByIndexValue(4,8, "");//Lamina접착제원단위	
					    items['C106000060_Grid_5'].setCellByIndexValue(4,9, "");//Lamina접착제원단위	1
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),108,"");//라미나 색상코드					
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),109,"");//수지라미나
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),110,"");//광택코드라미나
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),111,"");//광택도라미나하한
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),140,"");//광택도라미나상한
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),112,"");//PMT라미나
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),113,"");//도막라미나
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),114,"");//원단위라미나
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),141,"");//Lamina유형
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),142,"");//Lamina접착제코드
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),143,"");//Lamina접착제신나코드
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),144,"");//Lamina접착제코드1
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),145,"");//Lamina접착제신나코드1
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),146,"");//Lamina필름두께코드	
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),170,"");//Lamina접착제원단위
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),171,"");//Lamina접착제원단위1
						items['C106000060_Grid_3'].setUpdated(rId,true,"updated");
						var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
						if(rowStatus!="inserted"){
							items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
						}
					}else if(oValue !=nValue){
						subMtlTp1 = "S38";
						subMtlTp2 = "";
						subMtlTp3 = "";
						subMtlTp4 = "";
						subMtlTp5 = "";
						//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
						param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,RSN_TP_NM,LUS_RT_CD_NM,LUS_RT,WK_VISCO,PMT,PNT_FLM_THK,SLV_GRA,PNT_GRA,NV,PNT_UNT,THR_CD,LUS_RT_LLV,LUS_RT_ULV,RSN_TP,LUS_RT_CD,LMN_KND_TP,LMN_BND_CD,LMN_BND_THR_CD,LMN_BND_CD1,LMN_BND_THR_CD1,LMN_FLM_THK_CD,LMN_KND_TP_NM,LMN_BND_CD_NM,LMN_BND_CD_NM1,LMN_FLM_THK_CD_NM,CLR_SUB_MTL_CD_OLD,LMN_BND_UNT,LMN_BND_UNT1,CLR_NM,USE_YN";	
						var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
						var cells = xmlObj.getElementsByTagName("cell"); 
							if(cells.length > 0){
									if(cells.item(25).firstChild.nodeValue == "N"){						
			    						alert("컬러코드 사용유무를 확인하세요!");
			    						return;					
			    					}
									//라미나정보 CCL-BOM정보로 Setting
									items['C106000060_Grid_3'].setCellValue(rId,0, cells.item(0).firstChild.nodeValue);//색상코드							
									items['C106000060_Grid_3'].setCellValue(rId,1, cells.item(1).firstChild.nodeValue);//수지타입(마스터)
									items['C106000060_Grid_3'].setCellValue(rId,2, cells.item(2).firstChild.nodeValue);//광택코드(마스터)
									items['C106000060_Grid_3'].setCellValue(rId,3, cells.item(3).firstChild.nodeValue);//광택도(하한-상한)
									items['C106000060_Grid_3'].setCellValue(rId,4, cells.item(4).firstChild.nodeValue);//작업점도
									items['C106000060_Grid_3'].setCellValue(rId,5, cells.item(5).firstChild.nodeValue);//PMT
									items['C106000060_Grid_3'].setCellValue(rId,6, cells.item(6).firstChild.nodeValue);//도막
									items['C106000060_Grid_3'].setCellValue(rId,7, cells.item(7).firstChild.nodeValue);//용제비중
									items['C106000060_Grid_3'].setCellValue(rId,8, cells.item(8).firstChild.nodeValue);//도료비중
									items['C106000060_Grid_3'].setCellValue(rId,9, cells.item(9).firstChild.nodeValue);//고형분
									//items['C106000060_Grid_3'].setCellValue(rId,10, cells.item(10).firstChild.nodeValue);//원단위
									items['C106000060_Grid_3'].setCellValue(rId,11, cells.item(11).firstChild.nodeValue);//시너	
									items['C106000060_Grid_3'].setCellValue(rId,12, cells.item(26).firstChild.nodeValue);//구칼라부자재코드
										
									items['C106000060_Grid_5'].setCellByIndexValue(0,8, cells.item(22).firstChild.nodeValue);//Lamina유형
									items['C106000060_Grid_5'].setCellByIndexValue(1,8, cells.item(17).firstChild.nodeValue);//Lamina접착제코드
									items['C106000060_Grid_5'].setCellByIndexValue(1,9, cells.item(19).firstChild.nodeValue);//Lamina접착제코드
									items['C106000060_Grid_5'].setCellByIndexValue(2,1, cells.item(29).firstChild.nodeValue);//상세색상명
									items['C106000060_Grid_5'].setCellByIndexValue(2,8, cells.item(18).firstChild.nodeValue);//Lamina접착제신나코드
									items['C106000060_Grid_5'].setCellByIndexValue(2,9, cells.item(20).firstChild.nodeValue);//Lamina접착제신나코드
									items['C106000060_Grid_5'].setCellByIndexValue(3,8, cells.item(25).firstChild.nodeValue);//Lamina필름두께코드
									if(!isNull(cells.item(17).firstChild.nodeValue)){
										subMtlTp1 = "S37";	
										subMtlTp2 = "";
										subMtlTp3 = "";
										subMtlTp4 = "";
										subMtlTp5 = "";
										subMtlTp6 = "";
										//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
										param = "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+cells.item(17).firstChild.nodeValue+"&column-info=PNT_UNT";	
										var pntUntXml = uiCommon.ajaxLoadData('c10AjaxData.do',param);
										var pntUntCells = pntUntXml.getElementsByTagName("cell"); 
  										items['C106000060_Grid_5'].setCellByIndexValue(4,8, pntUntCells.item(0).firstChild.nodeValue);//Lamina접착제원단위
										items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),170,pntUntCells.item(0).firstChild.nodeValue);//Lamina접착제원단위
									}
									if(!isNull(cells.item(19).firstChild.nodeValue)){
										subMtlTp1 = "S37";	
										subMtlTp2 = "";
										subMtlTp3 = "";
										subMtlTp4 = "";
										subMtlTp5 = "";
										subMtlTp6 = "";
										//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
										param = "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+cells.item(19).firstChild.nodeValue+"&column-info=PNT_UNT";	
										var pntUntXml = uiCommon.ajaxLoadData('c10AjaxData.do',param);
										var pntUntCells = pntUntXml.getElementsByTagName("cell"); 
  										items['C106000060_Grid_5'].setCellByIndexValue(4,9, pntUntCells.item(0).firstChild.nodeValue);//Lamina접착제원단위
										items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),171,pntUntCells.item(0).firstChild.nodeValue);//Lamina접착제원단위
									}
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),108,cells.item(0).firstChild.nodeValue);//라미나 색상코드					
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),109,cells.item(14).firstChild.nodeValue);//수지라미나
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),110,cells.item(15).firstChild.nodeValue);//광택코드라미나
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),111,cells.item(12).firstChild.nodeValue);//광택도라미나하한
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),140,cells.item(13).firstChild.nodeValue);//광택도라미나상한
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),112,cells.item(5).firstChild.nodeValue);//PMT라미나
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),113,cells.item(6).firstChild.nodeValue);//도막라미나
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),114,"");//원단위라미나
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),141,cells.item(16).firstChild.nodeValue);//Lamina유형
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),142,cells.item(17).firstChild.nodeValue);//Lamina접착제코드
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),143,cells.item(18).firstChild.nodeValue);//Lamina접착제신나코드
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),144,cells.item(19).firstChild.nodeValue);//Lamina접착제코드1
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),145,cells.item(20).firstChild.nodeValue);//Lamina접착제신나코드1
									items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),146,cells.item(21).firstChild.nodeValue);//Lamina필름두께코드		
									
									var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
								if(rowStatus!="inserted"){
									items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
								}
							}else{
								alert("해당하는 색상코드가 없습니다2.");
								items['C106000060_Grid_3'].setCellValue(rId,cInd,"");
								items['C106000060_Grid_3'].setUpdated(rId,false,""); 
								return;					
							}
					}
				}else if(cInd==6){
						if(rId == "1"){		
							pntFlmThkMax = sumColumnTop();
							items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),113,nValue);//도막두께Lamina
						}
						var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
						if(rowStatus!="inserted"){
							items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
						}
						//				items['C106000060_Grid_1'].setUpdated(items['C106000060_Grid_1'].getRowSelectedId(),false,rowStatus); 
						//items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				setColorInfo();
				return true;
			}
		}
	}	
	return true;
}
function onEditCellEvent5(stage,rId,cInd,nValue,oValue){
	var grid = items['C106000060_Grid_1'];
	var grdObj = items['C106000060_Grid_5'].getDhxGrid();	
	var subMtlTp1 = "";
	var subMtlTp2 = "";
	var subMtlTp3 = "";
	var subMtlTp4 = "";	
	var subMtlTp5 = "";
	var subMtlTp6 = "";
	var param= "";	
	if(stage == 1 ){	
		if(isNull(grid.getRowSelectedId())){
			alert("CCL BOM NO 가 없습니다.\n CCL BOM NO를 선택해주세요.");
//			grdObj.selectRow(-1);
//			grdObj.selectCell(0,0,false,false);
			grdObj.clearSelection();	
			return;
		}
		
		var rowStatus = grid.getDhxGrid().getUserData(grid.getRowSelectedId(),"!nativeeditor_status");
		if(isNull(rowStatus) && isNull(grid.getCellValue(grid.getRowSelectedId(),0))){		
			alert("CCL BOM NO 행추가 또는 CCL BOM NO를 선택해주세요.");
			grdObj.clearSelection();	
			return;
		}
        
		if(grdObj.getRowIndex(rId) == 2 && cInd == 2){
			grdObj.editor.obj.onkeyup = function() {
				var valueLength = grdObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'50')){
					alert("50자리만 입력 가능합니다.");
					grdObj.editor.obj.value = "";
					return false;
				}				
			}
		}
		/*
		else if(grdObj.getRowIndex(rId) == 1 && cInd == 10){
			grdObj.editor.obj.onkeyup = function() {
				var valueLength = grdObj.editor.obj.value+'';
				
				if(!hanCheck(valueLength,'5')){
					alert("5자리만 입력 가능합니다.");
					grdObj.editor.obj.value = "";
					return false;
				}				
			}
		}*/
		
        if(rId == "1" && ( cInd==8 || cInd == 9 )){//라미나접착제 -> 대문자입력
        	grdObj.editor.obj.onkeydown = function(e){
		       var cellValue = grdObj.editor.obj.value;
	  	       if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
	  	    	 grdObj.editor.obj.value = cellValue.toUpperCase();
	  	       }
	        }	
        }
	}else if(stage == 2){
		if(!isNull(grid.getRowSelectedId())){
            
			if(rId == "0" && cInd==1){ 
				grid.setCellValue(grid.getRowSelectedId(),203,nValue);//칼라특수제품소분류
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}	
			}else if(rId == "0" && cInd==5){ 	
				grid.setCellValue(grid.getRowSelectedId(),128,nValue);//럭스틸브랜드코드
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
			}else if(rId == "0" && cInd==11){ 
				grid.setCellValue(grid.getRowSelectedId(),169,nValue);//재단선 유무
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
			}else if(rId == "1" && cInd==1){ 
				//items['C106000060_Grid_5'].setUpdated(rId,false,""); 
				grid.setCellValue(grid.getRowSelectedId(),118,nValue);//상코드Chemical
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
			}else if(rId == "2" && cInd==2){ 
				grid.setCellValue(grid.getRowSelectedId(),119,nValue);//상세색상명
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
			}else if(rId == "1" && cInd==8){  //라미나접착제
				subMtlTp1 = "S37";
				subMtlTp2 = "";
				subMtlTp3 = "";
				subMtlTp4 = "";
				subMtlTp5 = "";
				subMtlTp6 = "";
				//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
				param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,THR_CD,PNT_UNT";	
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
                var cells = xmlObj.getElementsByTagName("cell");
					if(cells.length > 0){
						grid.setCellValue(grid.getRowSelectedId(),142,nValue);//라미나접착제
						grid.setCellValue(grid.getRowSelectedId(),143, cells.item(1).firstChild.nodeValue);//라미나접착제신나코드
						grid.setCellValue(grid.getRowSelectedId(),170, cells.item(2).firstChild.nodeValue);//라미나접착제원단위
						items['C106000060_Grid_5'].setCellByIndexValue(2,8, cells.item(1).firstChild.nodeValue);//라미나접착제신나코드
						items['C106000060_Grid_5'].setCellByIndexValue(4,8, cells.item(2).firstChild.nodeValue);//라미나접착제원단위
						var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
						if(rowStatus!="inserted"){
							grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
						}
					}else{
						alert("해당하는 접착제 코드가 없습니다!");
						return false;					
					}
			}else if(rId == "1" && cInd==9){  //라미나접착제1
				subMtlTp1 = "S37";
				subMtlTp2 = "";
				subMtlTp3 = "";
				subMtlTp4 = "";
				subMtlTp5 = "";
				subMtlTp6 = "";
				//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
				param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,THR_CD,PNT_UNT";	
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
                var cells = xmlObj.getElementsByTagName("cell");
					if(cells.length > 0){
						grid.setCellValue(grid.getRowSelectedId(),144,nValue);//라미나접착제1
						grid.setCellValue(grid.getRowSelectedId(),145, cells.item(1).firstChild.nodeValue);//라미나접착제신나코드1
						grid.setCellValue(grid.getRowSelectedId(),171, cells.item(2).firstChild.nodeValue);//라미나접착제원단위1
						items['C106000060_Grid_5'].setCellByIndexValue(2,9, cells.item(1).firstChild.nodeValue);//라미나접착제신나코드1
						items['C106000060_Grid_5'].setCellByIndexValue(4,9, cells.item(2).firstChild.nodeValue);//라미나접착제원단위1
						var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
						if(rowStatus!="inserted"){
							grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
						}
					}else{
						alert("해당하는 접착제 코드가 없습니다!");
						return false;					
					}
			}else if(rId == "1" && cInd==11){  
				grid.setCellValue(grid.getRowSelectedId(),200,nValue);//핀트종류추가(2015.10.07 - 반드시 Grid1에 있는 index-1의 순서로 맞춰야 함)
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 			
			}else if(rId == "2" && cInd==5){ 
				grid.setCellValue(grid.getRowSelectedId(),129,nValue);//주공정
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "3" && cInd==1){ 
				if(!isNull(oValue) && isNull(nValue)){
					grid.setCellValue(grid.getRowSelectedId(),2,"");//코팅방식 NM
					grid.setCellValue(grid.getRowSelectedId(),115,"");//코팅방식
				}else if(oValue !=nValue){
					var combo = grdObj.cells(grdObj.getRowId(3), 2).getCellCombo();//코팅방식 combo object
					grid.setCellValue(grid.getRowSelectedId(),2,combo.getSelectedText());//코팅방식 NM
					grid.setCellValue(grid.getRowSelectedId(),115,nValue);//코팅방식
				}
				//비지니스 신규 추가 도장방식값에 따라 아농원단위값 변경
				var anoneCd = "ANNON";
				var anoneUnt = 0;
				
				if(nValue == "F"){					
					anoneUnt = 0.012;
				}else if(nValue == "G"){
					anoneUnt = parseFloat("0.012") * 2;
				}else if(nValue == "H"){
					anoneUnt = 0.036;
				}else if(nValue == "J"){
					anoneUnt = parseFloat("0.012") * 4;
				}else{
					anoneCd = "";
					anoneUnt = 0;
				}
				//items['C106000060_Grid_5'].setCellValue(0,2, anoneUnt);
				grid.setCellValue(grid.getRowSelectedId(),grid.getDhxGrid().getColIndexById('ANON_CD'), anoneCd);//아농원코드
				grid.setCellValue(grid.getRowSelectedId(),grid.getDhxGrid().getColIndexById('ANON_UNT'), anoneUnt);//아농원단위
				items['C106000060_Grid_5'].setUpdated(0,true,"updated"); 
				
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "3" && cInd==5){ 
				grid.setCellValue(grid.getRowSelectedId(),130,nValue);//대체공정1
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "4" && cInd==5){ 
				grid.setCellValue(grid.getRowSelectedId(),131,nValue);//대체공정2
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "5" && cInd==8){ 
				grid.setCellValue(grid.getRowSelectedId(),167,nValue);//Print용도코드
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "5" && cInd==5){ 
				grid.setCellValue(grid.getRowSelectedId(),165,nValue);//대체공정3
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "6" && cInd==1){ 
				grid.setCellValue(grid.getRowSelectedId(),166,nValue);//무독성구분
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "6" && cInd==8){ 
				grid.setCellValue(grid.getRowSelectedId(),168,nValue);//PrintPatternCode
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
			}else if(rId == "6" && cInd==5){ 
				grid.setCellValue(grid.getRowSelectedId(),172,nValue);//품질설계확정구분
				var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
				if(rowStatus!="inserted"){
					grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}				
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated");				
				//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 				
			}else if(rId == "4" && cInd==1 && !isNull(nValue)){
				subMtlTp1 = "S31";
				subMtlTp2 = "S32";
				subMtlTp3 = "S35";
				subMtlTp4 = "S38";
				subMtlTp5 = "ZZZ";
				subMtlTp6 = "S37";
				//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
				param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,RSN_TP,RSN_TP_NM,CLR_NM,USE_YN";	
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
                var cells = xmlObj.getElementsByTagName("cell");
					if(cells.length > 0){
								//'C106000060_Grid_3 Data설정;	
								items['C106000060_Grid_5'].setCellValue(rId,cInd, cells.item(0).firstChild.nodeValue);//색상코드(T)
								items['C106000060_Grid_5'].setCellByIndexValue(5,1, cells.item(1).firstChild.nodeValue);//수지타입(T)
								items['C106000060_Grid_5'].setCellByIndexValue(2,1, cells.item(3).firstChild.nodeValue);//상세색상명(T)
								grid.setCellValue(grid.getRowSelectedId(),7,cells.item(0).firstChild.nodeValue);//색상(T)
								grid.setCellValue(grid.getRowSelectedId(),116,cells.item(1).firstChild.nodeValue);//수지타입(T)
								grid.setCellValue(grid.getRowSelectedId(),3,cells.item(2).firstChild.nodeValue);//수지타입 NM(T)
								grid.setCellValue(grid.getRowSelectedId(),119,cells.item(3).firstChild.nodeValue);//상세색상명	12-07-05 신규추가 김태성대리 요청
								items['C106000060_Grid_5'].setUpdated(rId,true,"updated"); 
								var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
								if(rowStatus!="inserted"){
									items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
								}
								//items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 							
					}else{
						alert("해당하는 색상코드가 없습니다3.");
						items['C106000060_Grid_5'].setCellByIndexValue(4,1,"");					
						items['C106000060_Grid_5'].setCellByIndexValue(4,1,items['C106000060_Grid_1'].getCellByIndexValue(items['C106000060_Grid_1'].getDhxGrid().getRowIndex(grid.getRowSelectedId()),119));
						//setColorInfo();
						items['C106000060_Grid_5'].setUpdated(rId,false,""); 
						return;					
					}
					var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
					if(rowStatus!="inserted"){
						grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
					}
			}else if(rId == "4" && cInd==2 && !isNull(nValue)){ 
				subMtlTp1 = "S31";
				subMtlTp2 = "S32";
				subMtlTp3 = "S35";
				subMtlTp4 = "S38";
				subMtlTp5 = "ZZZ";
				subMtlTp6 = "S37";
				//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
				param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,RSN_TP,RSN_TP_NM,SUB_MTL_TP,USE_YN";	
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
                var cells = xmlObj.getElementsByTagName("cell");
					if(cells.length > 0){
					   //양면프린트 도입으로 Back도 대표색상 입력가능 2014.05.15 KJH	
					   /*if(cells.item(3).firstChild.nodeValue == "ZZZ"){
					      alert("대표색상은 전면만 변경가능합니다.");
										return;
					   }*/
						//'C106000060_Grid_3 Data설정;	
						items['C106000060_Grid_5'].setCellValue(rId,cInd, cells.item(0).firstChild.nodeValue);//색상코드(B)
						items['C106000060_Grid_5'].setCellByIndexValue(5,2, cells.item(1).firstChild.nodeValue);//수지타입(B)
						grid.setCellValue(grid.getRowSelectedId(),8,cells.item(0).firstChild.nodeValue);//색상(B)
						grid.setCellValue(grid.getRowSelectedId(),147,cells.item(1).firstChild.nodeValue);//수지타입(B)
						grid.setCellValue(grid.getRowSelectedId(),4,cells.item(2).firstChild.nodeValue);//수지타입 NM(B)
						items['C106000060_Grid_5'].setUpdated(rId,true,"updated"); 
						var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
						if(rowStatus!="inserted"){
							items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
						}
						//items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 				
					}else{
						alert("해당하는 색상코드가 없습니다4.");
						items['C106000060_Grid_5'].setCellByIndexValue(4,2,"");
						//setColorInfo();
						items['C106000060_Grid_5'].setUpdated(rId,false,""); 
						return;					
					}
			}
		}
	}	
	return true;
}

function onEditCellEvent4(stage,rId,cInd,nValue,oValue){
	var grid = items['C106000060_Grid_1'];
	var grid4 = items['C106000060_Grid_4'];
	var grdObj = items['C106000060_Grid_4'].getDhxGrid();
	
	if(stage == 1 ){	
		if(isNull(grid.getRowSelectedId())){
			alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");
			grdObj.selectCell(0,0,false,false);
			return;
		}
		if(cInd == 1 || cInd == 5 || cInd == 9 || cInd == 13){//롤코드
			var temVal = grid4.getCellValue(rId,cInd);
			grdObj.editor.obj.onkeyup = function() {
				var valueLength = grdObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'5')){
					alert("5자리만 입력 가능합니다.");
					grdObj.editor.obj.value = temVal;
					return false;
				}				
			}
		  var gridObj = items["C106000060_Grid_4"].getDhxGrid();
		  gridObj.editor.obj.onkeydown = function(e){
	  			var cellValue = gridObj.editor.obj.value;
	  			if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
	  				gridObj.editor.obj.value = cellValue.toUpperCase();
	  			}
  			}
		}
	}else if(stage == 2){		
		if(!isNull(nValue)){
			if(cInd==1 || cInd==5 || cInd==9 || cInd==13){ 
				var subMtlTp1 = "S34";
				var subMtlTp2 = "";
				var subMtlTp3 = "";
				var subMtlTp4 = "";
				var subMtlTp5 = "";
				var subMtlTp6 = "";
				//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
				param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,RSN_TP,RSN_TP_NM";	
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				if(cells.length > 0){
					//'C106000060_Grid_4 Ink부자재 색상코드설정;	
					items['C106000060_Grid_4'].setCellValue(rId,cInd, cells.item(0).firstChild.nodeValue);//색상코드(Ink)
					if(cInd == 1){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),150,nValue);//PrintInkCode1도					
					}else if(cInd == 5){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),154,nValue);//PrintInkCode2도
					}else if(cInd == 9){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),158,nValue);//PrintInkCode3도
					}else if(cInd == 13){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),162,nValue);//PrintInkCode4도
					}
				}else{
					alert("해당하는 Ink 색상코드가 없습니다.");
					items['C106000060_Grid_4'].setCellValue(rId,cInd, "");//색상코드(Ink)
					if(cInd == 1){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),150,"");//PrintInkCode1도					
					}else if(cInd == 5){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),154,"");//PrintInkCode2도
					}else if(cInd == 9){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),158,"");//PrintInkCode3도
					}else if(cInd == 13){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),162,"");//PrintInkCode4도
					}
					return;					
				}
			}
		}else{
			if(cInd == 1){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),150,"");//PrintInkCode1도					
			}else if(cInd == 5){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),154,"");//PrintInkCode2도
			}else if(cInd == 9){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),158,"");//PrintInkCode3도
			}else if(cInd == 13){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),162,"");//PrintInkCode4도
			}
		}
		var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
		if(rowStatus!="inserted"){
			items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
		}
		//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
	}	
	return true;
}
function onEditCellEvent9(stage,rId,cInd,nValue,oValue){
	var grid = items['C106000060_Grid_1'];
	var grid9 = items['C106000060_Grid_9'];
	var grdObj = items['C106000060_Grid_9'].getDhxGrid();
	
	if(stage == 1 ){	
		if(isNull(grid.getRowSelectedId())){
			alert("CCL-BOM 번호가 없습니다.\n CCL-BOM번호를 선택해주세요.");
			grdObj.selectCell(0,0,false,false);
			return;
		}
		if(cInd == 1 || cInd == 5 || cInd == 9 || cInd == 13){//롤코드
			var temVal = grid9.getCellValue(rId,cInd);
			grdObj.editor.obj.onkeyup = function() {
				var valueLength = grdObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'5')){
					alert("5자리만 입력 가능합니다.");
					grdObj.editor.obj.value = temVal;
					return false;
				}				
			}
		  var gridObj = items["C106000060_Grid_9"].getDhxGrid();
		  gridObj.editor.obj.onkeydown = function(e){
		  		var cellValue = gridObj.editor.obj.value;
	  			if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
	  				gridObj.editor.obj.value = cellValue.toUpperCase();
	  			}
  			}
		}
	}else if(stage == 2){
		if(!isNull(nValue)){
			if(cInd==1 || cInd==5 || cInd==9 || cInd==13){ 
				var subMtlTp1 = "S34";
				var subMtlTp2 = "";
				var subMtlTp3 = "";
				var subMtlTp4 = "";
				var subMtlTp5 = "";
				var subMtlTp6 = "";
				//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
				param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,RSN_TP,RSN_TP_NM";	
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				if(cells.length > 0){
					//'C106000060_Grid_9 Ink부자재 색상코드설정;	
					items['C106000060_Grid_9'].setCellValue(rId,cInd, cells.item(0).firstChild.nodeValue);//색상코드(Ink)
					if(cInd == 1){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),184,nValue);//PrintInkCode1도
					}else if(cInd == 5){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),188,nValue);//PrintInkCode2도
					}else if(cInd == 9){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),192,nValue);//PrintInkCode3도
					}else if(cInd == 13){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),196,nValue);//PrintInkCode4도
					}
				}else{
					alert("해당하는 Ink 색상코드가 없습니다.");
					items['C106000060_Grid_9'].setCellValue(rId,cInd, "");//색상코드(Ink)
					if(cInd == 1){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),184,"");//PrintInkCode1도
					}else if(cInd == 5){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),188,"");//PrintInkCode2도
					}else if(cInd == 9){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),192,"");//PrintInkCode3도
					}else if(cInd == 13){
						items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),196,"");//PrintInkCode4도
					}
					return;					
				}
			}
		}else{
			if(cInd == 1){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),184,"");//PrintInkCode1도
			}else if(cInd == 5){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),188,"");//PrintInkCode2도
			}else if(cInd == 9){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),192,"");//PrintInkCode3도
			}else if(cInd == 13){
				items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),196,"");//PrintInkCode4도
			}
		}
		var rowStatus = items['C106000060_Grid_1'].getDhxGrid().getUserData(items['C106000060_Grid_1'].getRowSelectedId(),"!nativeeditor_status");
		if(rowStatus!="inserted"){
			items['C106000060_Grid_1'].setUpdated(grid.getRowSelectedId(),true,"updated"); 
		}
		//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
	}	
	return true;
}
// C106000060pop01으로부터 넘겨받은 값 item에 세팅(프린트롤TOP)
function popSetValue(rowId,colIndex,rollCode,ppCode,ptCode,untCode){
	var grid = items['C106000060_Grid_1'];
	items['C106000060_Grid_4'].setCellValue(rowId,colIndex,rollCode);
	items['C106000060_Grid_4'].setCellValue(rowId,parseInt(colIndex)+2,ptCode);
	items['C106000060_Grid_4'].setCellValue(rowId,parseInt(colIndex)+3,untCode);
	if(isNull(rollCode)){
		items['C106000060_Grid_4'].setCellValue(rowId,parseInt(colIndex)+1,"");
		if(colIndex == "0"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),150,"");//PrintInkCode1도		
		}else if(colIndex == "4"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),154,"");//PrintInkCode2도			
		}else if(colIndex == "8"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),158,"");//PrintInkCode3도
		}else if(colIndex == "12"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),162,"");//PrintInkCode4도
		}
	}
	
	if(colIndex == "0"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),149,rollCode);//PrintRollNo1도		
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),151,ptCode);//PrintRollPatternCode1도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),152,untCode);//Print원단위1도
	}else if(colIndex == "4"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),153,rollCode);//PrintRollNo2도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),155,ptCode);//PrintRollPatternCode2도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),156,untCode);//Print원단위2도
	}else if(colIndex == "8"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),157,rollCode);//PrintRollNo3도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),159,ptCode);//PrintRollPatternCode3도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),160,untCode);//Print원단위3도
	}else if(colIndex == "12"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),161,rollCode);//PrintRollNo4도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),163,ptCode);//PrintRollPatternCode4도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),164,untCode);//Print원단위4도
	}		
	items['C106000060_Grid_4'].setUpdated(items['C106000060_Grid_4'].getDhxGrid().getRowId(0),true,"updated"); 
	grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
	return true;
}

// C106000060pop01으로부터 넘겨받은 값 item에 세팅(프린트롤BACK)
function popSetValue9(rowId,colIndex,rollCode,ppCode,ptCode,untCode){
	var grid = items['C106000060_Grid_1'];
	items['C106000060_Grid_9'].setCellValue(rowId,colIndex,rollCode);
	items['C106000060_Grid_9'].setCellValue(rowId,parseInt(colIndex)+2,ptCode);
	items['C106000060_Grid_9'].setCellValue(rowId,parseInt(colIndex)+3,untCode);
	
	/*
	if(isNull(rollCode)){
		items['C106000060_Grid_9'].setCellValue(rowId,parseInt(colIndex)+1,"");
		if(colIndex == "0"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),182,"");//PrintInkCode1도		
		}else if(colIndex == "4"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),186,"");//PrintInkCode2도			
		}else if(colIndex == "8"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),190,"");//PrintInkCode3도
		}else if(colIndex == "12"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),194,"");//PrintInkCode4도
		}
	}
	
	if(colIndex == "0"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),181,rollCode);//PrintRollNo1도		
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),183,ptCode);//PrintRollPatternCode1도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),184,untCode);//Print원단위1도
	}else if(colIndex == "4"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),185,rollCode);//PrintRollNo2도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),187,ptCode);//PrintRollPatternCode2도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),188,untCode);//Print원단위2도
	}else if(colIndex == "8"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),189,rollCode);//PrintRollNo3도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),191,ptCode);//PrintRollPatternCode3도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),192,untCode);//Print원단위3도
	}else if(colIndex == "12"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),193,rollCode);//PrintRollNo4도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),195,ptCode);//PrintRollPatternCode4도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),196,untCode);//Print원단위4도
	}*/		
	
	if(isNull(rollCode)){
		items['C106000060_Grid_9'].setCellValue(rowId,parseInt(colIndex)+1,"");
		if(colIndex == "0"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),184,"");//PrintInkCode1도		
		}else if(colIndex == "4"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),188,"");//PrintInkCode2도			
		}else if(colIndex == "8"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),192,"");//PrintInkCode3도
		}else if(colIndex == "12"){
			items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),196,"");//PrintInkCode4도
		}
	}
	
	if(colIndex == "0"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),183,rollCode);//PrintRollNo1도		
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),185,ptCode);//PrintRollPatternCode1도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),186,untCode);//Print원단위1도
	}else if(colIndex == "4"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),187,rollCode);//PrintRollNo2도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),189,ptCode);//PrintRollPatternCode2도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),190,untCode);//Print원단위2도
	}else if(colIndex == "8"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),191,rollCode);//PrintRollNo3도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),193,ptCode);//PrintRollPatternCode3도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),194,untCode);//Print원단위3도
	}else if(colIndex == "12"){
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),195,rollCode);//PrintRollNo4도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),197,ptCode);//PrintRollPatternCode4도
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),198,untCode);//Print원단위4도
	}
	
	items['C106000060_Grid_9'].setUpdated(items['C106000060_Grid_9'].getDhxGrid().getRowId(0),true,"updated"); 
	grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
	return true;
}

//C106000060pop02으로부터 넘겨받은 값 item에 세팅(Uni-Tex롤번호)
function popSetValue2(rowId,colIndex,rollCode){
	var grid = items['C106000060_Grid_1'];
	items['C106000060_Grid_4'].setCellValue(rowId,colIndex,rollCode); //Grid4에 값 화면 표시
	items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),180,rollCode); //표시된 값을 Grid1에 모아서 저장할때 한번에 전송
	items['C106000060_Grid_4'].setUpdated(items['C106000060_Grid_4'].getDhxGrid().getRowId(0),true,"updated"); //업데이트 모드
	grid.setUpdated(grid.getRowSelectedId(),true,"updated");
	
	//UniTexPatternCode 추가(2013.08.05)
	var param= "ServiceName=C106000060-service&utPntCDFind=1&PRT_ROLL_NO="+rollCode+"&column-info=PRT_PTN_CD,PRT_PTN_CD_NM";	
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell"); 
	
	if(cells.length > 0)
	{            										
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),181,cells.item(0).firstChild.nodeValue);//UnitexPatternCode 추가
		items['C106000060_Grid_5'].setCellValue(1,5,cells.item(1).firstChild.nodeValue);//UnitexPatternCode 추가
		items['C106000060_Grid_5'].setUpdated(items['C106000060_Grid_5'].getDhxGrid().getRowId(0),true,"updated");
		grid.setUpdated(grid.getRowSelectedId(),true,"updated");
	}
	
	return true;
}

//C106000060pop03으로부터 넘겨받은 값 item에 세팅(PICK-UP롤번호)
function popSetValue3(rowId,colIndex,rollCode){
	var grid = items['C106000060_Grid_1'];
	items['C106000060_Grid_4'].setCellValue(rowId,colIndex,rollCode); //Grid4에 값 화면 표시
	items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),182,rollCode); //표시된 값을 Grid1에 모아서 저장할때 한번에 전송
	items['C106000060_Grid_4'].setUpdated(items['C106000060_Grid_4'].getDhxGrid().getRowId(0),true,"updated"); //업데이트 모드
	grid.setUpdated(grid.getRowSelectedId(),true,"updated");
	
	//UniTexPatternCode 추가(2013.08.05)
/*	var param= "ServiceName=C106000060-service&utPntCDFind=1&PRT_ROLL_NO="+rollCode+"&column-info=PRT_PTN_CD,PRT_PTN_CD_NM";	
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell"); 
	
	if(cells.length > 0)
	{            										
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),179,cells.item(0).firstChild.nodeValue);//UnitexPatternCode 추가
		items['C106000060_Grid_5'].setCellValue(1,5,cells.item(1).firstChild.nodeValue);//UnitexPatternCode 추가
		items['C106000060_Grid_5'].setUpdated(items['C106000060_Grid_5'].getDhxGrid().getRowId(0),true,"updated");
		grid.setUpdated(grid.getRowSelectedId(),true,"updated");
	} */
	
	return true;
}

//C106000060pop04으로부터 넘겨받은 값 item에 세팅(Imprinting롤번호)
function popSetValue4(rowId,colIndex,rollCode){
	var grid = items['C106000060_Grid_1'];
	items['C106000060_Grid_4'].setCellValue(rowId,colIndex,rollCode); //Grid4에 값 화면 표시
	items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),201,rollCode); //표시된 값을 Grid1에 모아서 저장할때 한번에 전송
	items['C106000060_Grid_4'].setUpdated(items['C106000060_Grid_4'].getDhxGrid().getRowId(0),true,"updated"); //업데이트 모드
	grid.setUpdated(grid.getRowSelectedId(),true,"updated");
	
	return true;
}

//C106000060pop05으로부터 넘겨받은 값 item에 세팅(Imprinting back롤번호)
function popSetValue5(rowId,colIndex,rollCode){
	var grid = items['C106000060_Grid_1'];
	items['C106000060_Grid_9'].setCellValue(rowId,colIndex,rollCode); //Grid9에 값 화면 표시
	items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),202,rollCode); //표시된 값을 Grid1에 모아서 저장할때 한번에 전송
	items['C106000060_Grid_9'].setUpdated(items['C106000060_Grid_9'].getDhxGrid().getRowId(0),true,"updated"); //업데이트 모드
	grid.setUpdated(grid.getRowSelectedId(),true,"updated");
	
	return true;
}

function onEditCellEvent1(stage,rId,cInd,nValue,oValue){
	var grid = items["C106000060_Grid_1"];
	var gridObj = items["C106000060_Grid_1"].getDhxGrid();
	var param= "";	
	if(stage==1) { 
		if(cInd == 0){//CCL BOM NO
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'6')){
					alert("6자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}
			var rowStatus = gridObj.getUserData(rId,"!nativeeditor_status");
			if( rowStatus!="inserted"){
				alert("행추가를 한경우에만 CCL BOM NO를 입력하실 수 있습니다.");
				//gridObj.clearSelection();
				gridObj.editStop();		
				return;
			}
		}else{
			return true;
		}
	}else if(stage ==2){
		//CCL BOM테이블에서 조회
		var rowStatus = gridObj.getUserData(rId,"!nativeeditor_status");
		if(rowStatus =="inserted"){
			if(cInd==0 && !isNull(nValue)){
				var param= "ServiceName=C106000060-service&colorFind=1&CCL_BOM_NO="+nValue+"&column-info=CCL_BOM_NO";
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				if(cells.length > 0){						
					alert("이미 등록된 CCL BOM NO가 있습니다.");
					grid.setCellByIndexValue(0,0,"");
					//grid.setUpdated(rId,false,""); 
					return;					
				}
			}
		}
	}
	return true;
}

function onEditCellEvent2(stage,rId,cInd,nValue,oValue){
	var grid = items["C106000060_Grid_2"];
	var gridObj = items["C106000060_Grid_2"].getDhxGrid();	
	var param= "";	
	if(stage==1){ //MAX LENGTH 체크
		if(cInd == 0 || cInd == 2 ){//고객사/주문용도
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'6')){
					alert("6자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}
			
			gridObj.editor.obj.onkeydown = function(e){
	  			var cellValue = gridObj.editor.obj.value;
	  			if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
	  				gridObj.editor.obj.value = cellValue.toUpperCase();
	  			}
	  		}	
		}else if(cInd == gridObj.getColIndexById("PTT_FLM_DTL_CD")){ //보호필름
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'5')){
					alert("5자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}				
			}
			
			gridObj.editor.obj.onkeydown = function(e){
	  		var cellValue = gridObj.editor.obj.value;
	  			if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
	  				gridObj.editor.obj.value = cellValue.toUpperCase();
	  			}
	  		}	
		}else if(cInd == 9 || cInd == 10 || cInd == 13 || cInd == 14 ){//칼라Bending전면기준코드/칼라Bending후면기준코드,물성기준연필경도전면 /물성기준연필경도후면
			//if(checkLimitByte(gridObj, 2)){
			//	return true;
			//}
		}else if(cInd == 11 || cInd == 12){//물성기준MEK전면/물성기준MEK후면
			gridObj.editor.obj.onkeyup = function() {
				var valueLength = gridObj.editor.obj.value+'';
				if(valueLength.length>3){
					alert("3자리만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}
			}				
		}else if(cInd == 15 || cInd == 16){//색차 전면/색차후면
			gridObj.editor.obj.onkeyup = function() {
				var value = gridObj.editor.obj.value+'';	
				if(grid_qnty_check("색차의",1,1,true,value)){
					return true;
				}else{
					gridObj.editor.obj.value = "";
					return true;
				}			
			}
		}else if(cInd == gridObj.getColIndexById("CCL_QLT_MSG_TXT")){//품질메세지
			gridObj.editor.obj.onkeyup = function() {
				//var valueLength = gridObj.editor.obj.value+'';
				var valueLength = gridObj.editor.getValue();			
				if(!hanCheck(valueLength,'2000')){
					alert("2000Byte만 입력 가능합니다.");
					gridObj.editor.obj.value = "";
					return false;
				}
			}
			//Enter키 후 개행하지 않기위해 아래 소스 추가
			//gridObj.selectRow(gridObj.getRowIndex(rId));
		}
	}else if(stage == 2){
		//고객사코드 마스터데이터 테이블에서 조회
		if(cInd==0 && !isNull(nValue)){
			if(nValue == "******"){ //값이 ****** 이면 Skip
				return true;
			}else{		
				param= "ServiceName=C106000060-service&cusCdFind=1&CD_V="+nValue+"&column-info=CD_V";
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				if(cells.length > 0){
					//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}else{
					alert("해당하는 고객사 CODE가 없습니다.");
					grid.setCellByIndexValue(0,0,"");
					//grid.setUpdated(rId,false,""); 
					return;					
				}
			}
		}else if(cInd==2 && !isNull(nValue)){ 
			//주문용도 마스터데이터 테이블에서 조회
			if(nValue == "******"){ //값이 ****** 이면 Skip
				return true;
			}else{
				var val;
				if(nValue.indexOf("*") > -1){
					val = nValue.substring(0,3);
				}else{
					val = nValue;
				}
				param= "ServiceName=C106000060-service&ordUsgCdFind=1&CD_V="+val+"&column-info=CD_V";
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				if(cells.length > 0){
					//grid.setUpdated(grid.getRowSelectedId(),true,"updated"); 
				}else{
					alert("해당하는 주문용도 CODE가 없습니다.");
					grid.setCellByIndexValue(0,2,"");
					//grid.setUpdated(rId,false,""); 
					return;					
				}
			}
		}else if(cInd== gridObj.getColIndexById("PTT_FLM_DTL_CD") && !isNull(nValue)){ 
			//보호필름 TB_C10_CLR_CD_MNG테이블에서 조회(S36) 
			var subMtlTp1 = "S36";
			var subMtlTp2 = "";
			var subMtlTp3 = "";
			var subMtlTp4 = "";
			var subMtlTp5 = "";
			var subMtlTp6 = "";
			//Grid변경시 colorAjaxFind 의 column-info 필드 확인 및 유의
			var param= "ServiceName=C106000060-service&colorAjaxFind=1&SUB_MTL_TP1="+subMtlTp1+"&SUB_MTL_TP2="+subMtlTp2+"&SUB_MTL_TP3="+subMtlTp3+"&SUB_MTL_TP4="+subMtlTp4+"&SUB_MTL_TP5="+subMtlTp5+"&SUB_MTL_TP6="+subMtlTp6+"&CLR_SUB_MTL_CD="+nValue+"&column-info=CLR_SUB_MTL_CD,PTT_FLM_PRD_ADH_CD_NM_MASTER,PTT_FLM_THK_CD_NM_MASTER,PTT_FLM_MQL_CD_NM_MASTER";	
			var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
      		var cells = xmlObj.getElementsByTagName("cell");
			if(cells.length > 0){
         		grid.setCellValue(rId,cInd,cells.item(0).firstChild.nodeValue);
				grid.setCellValue(rId,gridObj.getColIndexById("PTT_FLM_PRD_ADH_CD_NM_MASTER"),cells.item(1).firstChild.nodeValue);//보호필름SUS점착력코드 설명
				grid.setCellValue(rId,gridObj.getColIndexById("PTT_FLM_THK_CD_NM_MASTER"),cells.item(2).firstChild.nodeValue);//보호필름두께코드 설명
				grid.setCellValue(rId,gridObj.getColIndexById("PTT_FLM_MQL_CD_NM_MASTER"),cells.item(3).firstChild.nodeValue);//보호필름재질코드 설명            
			}else{
				alert("해당하는 보호필름 CODE가 없습니다.");
				grid.setCellValue(rId,cInd,"");
				return;					
			}
		}
	}	
	return true;
}

function findAfterFunction(){  	
//전송대상건 gridrow 붉은색 처리 추가 08-21
	var gridObj = items["C106000060_Grid_1"].getDhxGrid();		
	var grid_cnt = gridObj.getRowsNum();	
	for(var i=0; i< grid_cnt; i++){
		//Grid1의 index값 변경 시 반드시 SND_LST의 index를 조정해 줘야 함
		var sndLst = gridObj.cellById(gridObj.getRowId(i),176).getValue();
	    
	     if(sndLst == "Y"){
	        gridObj.setRowTextStyle(gridObj.getRowId(i), "color: red;");
	     }		
  	}
  	uiCommon.progressOff(parent);
  	findMessage(gridObj);
}

// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,targetDivId,rowIndex,cellIndex){
	if(cellIndex == 0){ 
		items[targetDivId].setCellByIndexValue(rowIndex,1,name);
	}else{
		items[targetDivId].setCellByIndexValue(rowIndex,3,name);
	}
	items[targetDivId].setCellByIndexValue(rowIndex,cellIndex,code);
	//items[targetDivId].getDhxGrid().editStop();
}
	
//Grid edit 대문자 입력 
function onEditCellEvent(stage,rId,cInd,nValue,oValue){
	var gridObj = items["parentChild_Grid_2"].getDhxGrid();
	if(stage==1 && gridObj.editor.obj) { //MAX LENGTH 체크
		gridObj.editor.obj.onkeydown = function(e){
		var cellValue = gridObj.editor.obj.value;
			if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
				gridObj.editor.obj.value = cellValue.toUpperCase();
			}
		}		
	}
   return true;
}

function sumColumnTop() {
	var out = 0;
	var grid3 = items['C106000060_Grid_3'];
    //도막두께전면Total 값설정
	for(var h=1; h< 5; h++){
		if(!isNull(grid3.getCellByIndexValue(h,6))){			
			out = out + parseInt(grid3.getCellByIndexValue(h,6));		
		}
	}
	//라미나 도막두께유무에 따른 도막두께전면값 설정
	if(!isNull(grid3.getCellByIndexValue(9,6))){
		out = out + parseInt(grid3.getCellByIndexValue(9,6));
	}
    return out;
}
function sumColumnBack() {
	var out = 0;
	var grid3 = items['C106000060_Grid_3'];
	//도막두께후면Total 값설정
	for(var e=8; e> 4; e--){
		if(!isNull(grid3.getCellByIndexValue(e,6))){			
			out = out + parseInt(grid3.getCellByIndexValue(e,6));		
		}
	}
    return out;
}
/**
 * 엔터키를 사용한 그리드 포커스 이동
 * @param {gridObj}	grid object
 * @param {id} 현재 선택된 row의 id
 * @param {ind} 현재 선택된 cell의 id
 */
 //Enter 이후 Move 잘 되다 갑자기 단락바뀌는 현상 이슈 있슴 
function chkfocusInd(gridObj,id,ind){
	var row_cnt = gridObj.getRowsNum();
	var ind_cnt = gridObj.getColumnsNum();
	var row_id =gridObj.getRowIndex(id);
	if(	!gridObj.isColumnHidden(ind)){
		if(ind < ind_cnt){
			ind++;
		}else{
			if(row_id<row_cnt){
				row_id++;
				ind=0;
			}
		}
	}else{
		if(row_id<row_cnt){
				row_id++;
				ind=0;
		}
	}
	gridObj.selectCell(row_id,ind);
	gridObj.editCell();
}

/*
function focusMove(id,ind){
	var gridObj = items['C106000060_Grid_2'].getDhxGrid();
	//(그리드객체,rowid,cellid);
	chkfocusInd(gridObj,id,ind);
}
*/

function setColorInfo() {
	var grid = items['C106000060_Grid_1'];
	var grid3 = items['C106000060_Grid_3'];
	var hueCdFrnMax =""; //색상코드 전면
	var hueCdBakMin =""; //색상코드 후면
	var pntFlmThkMax = 0;//도막두께 전면
	var pntFlmThkMin = 0;//도막두께 후면
	var lusRtCdFrnMax = ""; //광택도코드 전면
	var lusRtCdBakMin = ""; //광택도코드 후면
	var lusRtCdFrnMaxNm = ""; //광택도코드 전면 Nm
	var lusRtCdBakMinNm = ""; //광택도코드 후면 Nm
	var rsnTtpFrnMax = "";//수지코드 전면
	var rsnTtpBakMin = "";//수지코드 후면
	var rsnTtpFrnMaxNm = "";//수지코드 전면 Nm
	var rsnTtpBakMinNm = "";//수지코드 후면 Nm
	//3grid 색상코드의 상세색상명 5grid 셋팅
	//	var dtlClrNm =grid3.getCellByIndexValue(parseInt(grid3.getDhxGrid().getSelectedRowId())+1,133); //상세 색상명 08-08 3grid ->5grid
	//라미나일때 getSelectedRowId())+1 이 10이고 10은 무조건 Null이기 자동 9로 셋팅
	var dtlClrNm =grid3.getCellByIndexValue(parseInt(grid3.getDhxGrid().getSelectedRowId())+1==10?9:parseInt(grid3.getDhxGrid().getSelectedRowId())+1,parseInt('133')); //상세 색상명 08-21 3grid ->5grid
	//#######################################색상코드 Start###############################################
				//색상코드전면 추출
		for(var i=1; i< 5; i++){
			if(!isNull(grid3.getCellByIndexValue(i,0))){			
				hueCdFrnMax = grid3.getCellByIndexValue(i,0);
				dtlClrNm = grid3.getCellByIndexValue(i,133);
				break;
			}		
		}
		//색상코드 라미나코드유무에 따른 색상코드전면값 설정
		if(!isNull(grid3.getCellByIndexValue(9,0))){
			hueCdFrnMax = grid3.getCellByIndexValue(9,0);
		}
		
		//색상코드후면 추출
		for(var r=8; r> 4; r--){	
			if(!isNull(grid3.getCellByIndexValue(r,0))){					
				hueCdBakMin = grid3.getCellByIndexValue(r,0);
				break;
			}		
		}
	//#######################################색상코드 End#################################################		
		
	//#######################################도막두께 Start###############################################
		//도막두께전면Total 값설정
		for(var h=1; h< 5; h++){
			if(!isNull(grid3.getCellByIndexValue(h,6))){			
				pntFlmThkMax = pntFlmThkMax + parseInt(grid3.getCellByIndexValue(h,6));		
			}
		}
		//라미나 도막두께유무에 따른 도막두께전면값 설정(0으로 변경)
		if(!isNull(grid3.getCellByIndexValue(9,6))){
			pntFlmThkMax = 0; //pntFlmThkMax = pntFlmThkMax + parseInt(grid3.getCellByIndexValue(9,6))
		}
		
		//도막두께후면Total 값설정
		for(var e=8; e> 4; e--){
			if(!isNull(grid3.getCellByIndexValue(e,6))){			
				pntFlmThkMin = pntFlmThkMin + parseInt(grid3.getCellByIndexValue(e,6));		
			}
		}
	//#######################################도막두께 End#################################################

	//#######################################광택도코드 Start#############################################
		//광택도코드 전면
		if(!isNull(grid3.getCellByIndexValue(9,2))){
			var cellVal = grid3.getCellByIndexValue(9,2);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			lusRtCdFrnMax = cellVal;
			lusRtCdFrnMaxNm = grid3.getCellByIndexValue(9,2);
			
		}else{
			if(!isNull(grid3.getCellByIndexValue(1,2))){
				var cellVal = grid3.getCellByIndexValue(1,2);
				var val = cellVal.indexOf(":");
				if(val > -1){
					cellVal	= cellVal.substring(0,val);			
				}
				lusRtCdFrnMax = cellVal;
				lusRtCdFrnMaxNm = grid3.getCellByIndexValue(1,2);
			}else if(!isNull(grid3.getCellByIndexValue(2,2))){
				var cellVal = grid3.getCellByIndexValue(2,2);
				var val = cellVal.indexOf(":");
				if(val > -1){
					cellVal	= cellVal.substring(0,val);			
				}
				lusRtCdFrnMax = cellVal;
				lusRtCdFrnMaxNm = grid3.getCellByIndexValue(2,2);
			}else if(!isNull(grid3.getCellByIndexValue(3,2))){
				var cellVal = grid3.getCellByIndexValue(3,2);
				var val = cellVal.indexOf(":");
				if(val > -1){
					cellVal	= cellVal.substring(0,val);			
				}
				lusRtCdFrnMax = cellVal;
				lusRtCdFrnMaxNm = grid3.getCellByIndexValue(3,2);
			}else if(!isNull(grid3.getCellByIndexValue(4,2))){
				var cellVal = grid3.getCellByIndexValue(4,2);
				var val = cellVal.indexOf(":");
				if(val > -1){
					cellVal	= cellVal.substring(0,val);			
				}
				lusRtCdFrnMax = cellVal;
				lusRtCdFrnMaxNm = grid3.getCellByIndexValue(4,2);
			}		
		}		
		//광택도코드 후면
		if(!isNull(grid3.getCellByIndexValue(8,2))){
			var cellVal = grid3.getCellByIndexValue(8,2);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			lusRtCdBakMin = cellVal;
			lusRtCdBakMinNm = grid3.getCellByIndexValue(8,2);
		}else if(!isNull(grid3.getCellByIndexValue(7,2))){
			var cellVal = grid3.getCellByIndexValue(7,2);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			lusRtCdBakMin = cellVal;
			lusRtCdBakMinNm = grid3.getCellByIndexValue(7,2);
		}else if(!isNull(grid3.getCellByIndexValue(6,2))){
			var cellVal = grid3.getCellByIndexValue(6,2);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			lusRtCdBakMin = cellVal;
			lusRtCdBakMinNm = grid3.getCellByIndexValue(6,2);
		}else if(!isNull(grid3.getCellByIndexValue(5,2))){
			var cellVal = grid3.getCellByIndexValue(5,2);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			lusRtCdBakMin = cellVal;
			lusRtCdBakMinNm = grid3.getCellByIndexValue(5,2);
		}
	//#######################################광택도코드 End###############################################
	
	//#######################################수지타입코드 Start#############################################
		//수지코드 전면
		if(!isNull(grid3.getCellByIndexValue(1,1))){
			var cellVal = grid3.getCellByIndexValue(1,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpFrnMax = cellVal;
			rsnTtpFrnMaxNm = grid3.getCellByIndexValue(1,1);
		}else if(!isNull(grid3.getCellByIndexValue(2,1))){
			var cellVal = grid3.getCellByIndexValue(2,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpFrnMax = cellVal;
			rsnTtpFrnMaxNm = grid3.getCellByIndexValue(2,1);
		}else if(!isNull(grid3.getCellByIndexValue(3,1))){
			var cellVal = grid3.getCellByIndexValue(3,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpFrnMax = cellVal;
			rsnTtpFrnMaxNm = grid3.getCellByIndexValue(3,1);
		}else if(!isNull(grid3.getCellByIndexValue(4,1))){
			var cellVal = grid3.getCellByIndexValue(4,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpFrnMax = cellVal;
			rsnTtpFrnMaxNm = grid3.getCellByIndexValue(4,1);
		}		
		//수지코드 후면
		if(!isNull(grid3.getCellByIndexValue(8,1))){
			var cellVal = grid3.getCellByIndexValue(8,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpBakMin = cellVal;
			rsnTtpBakMinNm = grid3.getCellByIndexValue(8,1);
		}else if(!isNull(grid3.getCellByIndexValue(7,1))){
			var cellVal = grid3.getCellByIndexValue(7,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpBakMin = cellVal;
			rsnTtpBakMinNm = grid3.getCellByIndexValue(7,1);
		}else if(!isNull(grid3.getCellByIndexValue(6,1))){
			var cellVal = grid3.getCellByIndexValue(6,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpBakMin = cellVal;
			rsnTtpBakMinNm = grid3.getCellByIndexValue(6,1);
		}else if(!isNull(grid3.getCellByIndexValue(5,1))){
			var cellVal = grid3.getCellByIndexValue(5,1);
			var val = cellVal.indexOf(":");
			if(val > -1){
				cellVal	= cellVal.substring(0,val);			
			}
			rsnTtpBakMin = cellVal;
			rsnTtpBakMinNm = grid3.getCellByIndexValue(5,1);
		}
	//#######################################수지타입코드 End###############################################
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),7,hueCdFrnMax);//색상코드전면
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),8,hueCdBakMin);//색상코드후면
		items['C106000060_Grid_5'].setCellByIndexValue(4,1,hueCdFrnMax);//색상코드후면
		items['C106000060_Grid_5'].setCellByIndexValue(4,2,hueCdBakMin);//색상코드후면
		if(isNull(grid3.getCellByIndexValue(9,0))){
			items['C106000060_Grid_5'].setCellByIndexValue(2,1,dtlClrNm);//상세색상명 08-08변경처리
		}	
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),9,pntFlmThkMax);//도막두께전면Total
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),10,pntFlmThkMin);//도막두께후면Total
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),117,lusRtCdFrnMax);//광택도코드 전면
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),148,lusRtCdBakMin);//광택도코드 후면
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),5,lusRtCdFrnMaxNm);//광택도코드 전면 Nm
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),6,lusRtCdBakMinNm);//광택도코드 후면 Nm
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),116,rsnTtpFrnMax);//수지타입전면
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),147,rsnTtpBakMin);//수지타입후면
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),3,rsnTtpFrnMaxNm);//수지타입전면 Nm
		items['C106000060_Grid_1'].setCellValue(grid.getRowSelectedId(),4,rsnTtpBakMinNm);//수지타입후면 Nm
		items['C106000060_Grid_5'].setCellByIndexValue(5,1,rsnTtpFrnMax);//수지타입전면
		items['C106000060_Grid_5'].setCellByIndexValue(5,2,rsnTtpBakMin);//수지타입후면
}

function img_btn(){
	var gridObj = items['C106000060_Grid_1'].getDhxGrid();
	var select_row = gridObj.getSelectedRowId();
    var CCL_BOM_NO ="";
	
	var row_status = gridObj.getUserData(select_row,"!nativeeditor_status");
	if(row_status!="inserted" ){
	     if(select_row =="" || select_row == null){
	     	CCL_BOM_NO = "";
	     }else{
			CCL_BOM_NO = gridObj.cellById(select_row,gridObj.getColIndexById('CCL_BOM_NO')).getValue();
		 }
		 var param ="CCL_BOM_NO="+CCL_BOM_NO;
		 parent.newRemoveOpenTab("C106000100",param);
	}else{
		dhtmlx.alert("먼저 데이터를 등록해주세요");
		return;
	}
}

function excelExport(eventName,formDivObj,referenceItem){
	var findUrl = parameters13(formDivObj,eventName, 'excelExportC106000060.do',columnListForExcelExport);
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
//물성정보 저장 사유입력 Poup호출
function C10_linkC106000060pop06() {
	popCfmRea		= "";
	
	winObj = new ui.window("popup","물성정보 저장사유","0","0","349","174","C106000060pop06.jsp");
	winObj.setButtonDisable("park,minmax1");

	winObj.getDhxWindow().attachEvent("onClose", function(win){
		this.hide();
		if( popCfmRea==null || popCfmRea.length==0 || C10_trim(popCfmRea)=="" ) {
			popCompleteYN = "N";
		} else {
			save1('save1','C106000060_Form_3','C106000060_Grid_2');
		}
		return true;
	});
}    
//물성정보 수정이력 조회 Popup을 호출한다.
function C10_linkC106000060pop07() {
	if(items['C106000060_Grid_2'].getRowSelectedId()){
		var g2_selectedId = items['C106000060_Grid_2'].getSelectedRowId();
  	    var g2_cclbomno = items['C106000060_Grid_2'].getCellValue(g2_selectedId,18);
		var g2_cuscd      = items['C106000060_Grid_2'].getCellValue(g2_selectedId,0);
		var g2_ordusgcd = items['C106000060_Grid_2'].getCellValue(g2_selectedId,2);

		winObj = new ui.window("popup","칼라물성 수정이력","0","0","718","400","c106000060pop07.do?ccl_bom_no="+g2_cclbomno+"&cus_cd="+g2_cuscd+"&ord_usg_cd="+g2_ordusgcd);
		winObj.setButtonDisable("park,minmax1");
	}else {
		alert("칼라물성정보에 선택된 행이 없습니다.");
		return;				
	}	
}
//]]>
-->
</script>
</head>
<body>
	<div id="C106000060_Form_1"
		style="position: absolute; height: 35px; width: 961px; left: 0px; top: 0px;">
	</div>
	<div id="C106000060_Menu_1"
		style="position: absolute; height: 25px; width: 291px; left: 1px; top: 41px;">
	</div>
	<div id="C106000060_Form_2"
		style="position: absolute; height: 28px; width: 242px; left: 712px; top: 37px;">
	</div>
	<div id="C106000060_Grid_1"
		style="position: absolute; height: 110px; width: 961px; left: 1px; top: 66px;">
	</div>
	<div id="C106000060_Menu_2"
		style="position: absolute; height: 25px; width: 961px; left: 1px; top: 181px;">
	</div>
	<div id="C106000060_Form_3"
		style="position: absolute; height: 28px; width: 356px; left: 702px; top: 178px;">
	</div>
	<div id="C106000060_Grid_2"
		style="position: absolute; height: 118px; width: 961px; left: 1px; top: 208px;">
	</div>
	<div id="C106000060_Grid_3"
		style="position: absolute; height: 220px; width: 892px; left: 70px; top: 333px;">
	</div>
	<div id="C106000060_Grid_4"
		style="position: absolute; height: 96px; width: 923px; left: 39px; top: 560px;">
	</div>
	<div id="C106000060_Grid_9"
		style="position: absolute; height: 22px; width: 923px; left: 39px; top: 634px;">
	</div>
	<div id="C106000060_Grid_5"
		style="position: absolute; height: 174px; width: 961px; left: 1px; top: 664px;">
	</div>
	<div id="C106000060_messagebox"
		style="position: absolute; height: 23px; width: 960px; left: 1px; top: 819px;">
	</div>
	<div id="C106000060_Grid_6"
		style="position: absolute; height: 220px; width: 70px; left: 1px; top: 333px;">
	</div>
	<div id="C106000060_Grid_7"
		style="position: absolute; height: 44px; width: 38px; left: 1px; top: 612px;">
	</div>
	<div id="C106000060_Grid_8"
		style="position: absolute; height: 22px; width: 38px; left: 1px; top: 560px;">
	</div>
</body>
</html>
<script>//<![CDATA[
ui.initializeDHTMLX();
//items["C106000060_Grid_1"].rowDblClicked(deteilCclBomNo);
items["C106000060_Grid_1"].rowSelected(deteilCclBomNo);
items["C106000060_Grid_1"].onEditCellEvent(onEditCellEvent1);
items["C106000060_Grid_2"].onEditCellEvent(onEditCellEvent2);
//items["C106000060_Grid_2"].rowDblClicked(gridPopup2);
items["C106000060_Grid_3"].onEditCellEvent(onEditCellEvent3);
items["C106000060_Grid_4"].onEditCellEvent(onEditCellEvent4);
items["C106000060_Grid_9"].onEditCellEvent(onEditCellEvent9);
items["C106000060_Grid_5"].onEditCellEvent(onEditCellEvent5);
items["C106000060_Grid_4"].rowDblClicked(rollSelectPopup4);
items["C106000060_Grid_9"].rowDblClicked(rollSelectPopup9);
var onXleForm = items["C106000060_Form_1"].onXLEEvent(onFormLoadFunction);
var onXleGrid = items['C106000060_Grid_1'].onXLEEvent(onGridLoadFunction);
var onXleGrid2 = items['C106000060_Grid_2'].onXLEEvent(onGridLoadFunction2);
items['C106000060_Menu_1'].setBackgroundColor("#FFFFFF");
items['C106000060_Form_2'].setBackgroundColor("#FFFFFF");
items['C106000060_Menu_2'].setBackgroundColor("#FFFFFF");
items['C106000060_Form_3'].setBackgroundColor("#FFFFFF");
items["C106000060_Grid_1"].onCheckboxEvent(onCheckboxEvent); 
var onXleGrid5 = items['C106000060_Grid_5'].onXLEEvent(onGridLoadFunction5);
//items['C106000060_Grid_2'].getDhxGrid().attachEvent("onEnter", focusMove); //Edit Grid Enter Move
//]]>
-->
</script>