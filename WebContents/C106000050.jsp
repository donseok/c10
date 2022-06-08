<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000050.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  칼라코드관리
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  이 돈 석
 * CREATE DATE      :  2012.01.04
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 최초생성일자     V1.0      김종범      Initial AVersion
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import = "com.posdata.glue.context.PosContext" %>
<%@page import = "com.posdata.glue.web.security.*" %>
<%@ page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@ page import = "com.posdata.glue.web.security.PosUser" %>
<%
    PosUser user        = (PosUser)session.getAttribute(PosSecurityConstants.USER);
    String  userNo      = "";
    String  userName    = "";
    if(user!=null) {
        userNo = (String) user.getUserInfo("USER_NO");
        userName = (String) user.getUserInfo("USER_NAME");
    }
%>        
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
칼라코드관리
</title>
<style>

/*
.dhxlist_obj_dhx_skyblue > div > div:nth-child(1) > div > div > div:nth-child(5) > div > div > table{

visibility : hidden;
*/
 

</style>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C106000050_Form_1","xml":".\/header\/kr\/C106000050\/C106000050_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000050_Grid_1","service":"C106000050-service","actionType":"find","security":"true"},' +
//       '{"itemType":"menu","renderTo":"C106000050_Menu_1","xml":".\/header\/kr\/C106000050\/C106000050_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000050_Grid_1","service":"C106000050-service"},' +
//       '{"itemType":"grid","renderTo":"C106000050_Grid_1","xml":".\/header\/kr\/C106000050\/C106000050_Grid_1.xml","rowCnt":"10","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000050_Grid_2","service":"C106000050-service","actionType":"save"},' +
//       '{"itemType":"menu","renderTo":"C106000050_Menu_2","xml":".\/header\/kr\/C106000050\/C106000050_Menu_2.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000050_Grid_2","service":"C106000050-service"},' +
//       '{"itemType":"form","renderTo":"C106000050_Form_3","xml":".\/header\/kr\/C106000050\/C106000050_Form_3.xml","url":"basicGridData.do","referenceItem":"C106000050_Form_1","service":"C106000050-service","actionType":"save","security":"true"},' +
//       '{"itemType":"grid","renderTo":"C106000050_Grid_2","xml":".\/header\/kr\/C106000050\/C106000050_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000050_Grid_2","service":"C106000050-service","actionType":"save"},' +
//       '{"itemType":"messagebox","renderTo":"messagebox","xml":".\/header\/kr\/C106000050\/messagebox.xml","service":"C106000050-service"}' +      
//    ']';
// var initConfig = JSON.parse(pageConfiguration);	     

var Form_1 = {"itemType":"form","renderTo":"C106000050_Form_1","xml":".\/header\/kr\/C106000050\/C106000050_Form_1.xml","url":"gridC10Data.do","referenceItem":"C106000050_Grid_1","service":"C106000050-service","actionType":"find","security":"true"};
var Form_3 = {"itemType":"form","renderTo":"C106000050_Form_3","xml":".\/header\/kr\/C106000050\/C106000050_Form_3.xml","url":"gridC10Data.do","referenceItem":"C106000050_Form_1","service":"C106000050-service","actionType":"save","security":"true"};
var Grid_1 = {"itemType":"grid","renderTo":"C106000050_Grid_1","xml":".\/header\/kr\/C106000050\/C106000050_Grid_1.xml","rowCnt":"10","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000050_Grid_2","service":"C106000050-service","actionType":"save"};
var Grid_2 = {"itemType":"grid","renderTo":"C106000050_Grid_2","xml":".\/header\/kr\/C106000050\/C106000050_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000050_Grid_2","service":"C106000050-service","actionType":"save"};
var Menu_1 = {"itemType":"menu","renderTo":"C106000050_Menu_1","xml":".\/header\/kr\/C106000050\/C106000050_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000050_Grid_1","service":"C106000050-service"};
var Menu_2 = {"itemType":"menu","renderTo":"C106000050_Menu_2","xml":".\/header\/kr\/C106000050\/C106000050_Menu_2.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000050_Grid_2","service":"C106000050-service"};

var initLayout = 
{
	"programId":"C106000050",
	"itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"60,50%,*", "splitter":false, "components": 
	[
	    Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"30,*", "splitter":false, "components": 
			[
				Menu_1,
				Grid_1
			]
		},
		{
			"itemType": "layout", "dirType":"row", "childSize":"30,*", "splitter":false, "components": 
			[
				{
					"itemType": "layout", "dirType":"col", "childSize":"70%,*", "splitter":false, "components": 
					[
						Menu_2,
						Form_3
					]
				},
				Grid_2
			]
		}
	]
};

var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var columnList = "USE_YN,CLR_SUB_MTL_CD,CLR_NM,SUB_MTL_TP,SUB_MTL_TP_NM,RSN_TP,RSN_TP_NM,LUS_RT_CD,LUS_RT_NM,LUS_RT_LLV,LUS_RT_ULV,RL_LUS_RT,WK_VISCO,PNT_FLM_THK,PRT_INK_TP,PRT_INK_TP_NM,NV,PNT_GRA,SLV_GRA,THR_CD,PNT_UNT,PMT,QT_L,QT_A,QT_B,STD_CLR_NM,LMN_KND_TP,LMN_KND_TP_NM,LMN_BND_CD,LMN_BND_THR_CD,LMN_BND_CD1,LMN_BND_THR_CD1,LMN_FLM_THK_CD,LMN_FLM_THK_CD_NM,PTT_FLM_LUS_RT_CD,PTT_FLM_LUS_RT_NM,PTT_FLM_THK_CD,PTT_FLM_THK_NM,PTT_FLM_MQL_CD,PTT_FLM_MQL_NM,PTT_FLM_SUS_ADH_CD,PTT_FLM_SUS_ADH_NM,PTT_FLM_PRD_ADH_CD,PTT_FLM_PRD_ADH_NM,RMRK,RGS_PRS_ID,RGS_DH,MDF_PRS_ID,CLR_MDF_DH,MGR_CLR_SUB_MTL_CD,CLR_SUB_MTL_CD_OLD,RSN_TP_OLD,LUS_RT_CD_OLD,PNT_FLM_THK_OLD,CMP_USE_YN,PNT_CMP_CD,PNT_CMP_NM,NV,PNT_GRA,SLV_GRA,PNT_UNT,LAMINA_INS_YN";
var tempRowId = "";
var popCompleteYN    = "N"; //칼라부재료업체 정보 저장 사유 입력여부 
var popCfmRea			= "";	// C106000050pop01 에서 업체 정보 저장 사유.

function find(eventName,formDivObj,referenceItem){
	items[referenceItem].clearDataProcess();
	var form = items['C106000050_Form_1'];
	//var clrSubMtlCd = form.getItemValue("CLR_SUB_MTL_CD_SH");	
	var sndLst = form.getDhxForm().isItemChecked("SND_LST");	

	if(sndLst == false){
      eventName = "find";		
    }else{
      eventName = "find1";
    }
	var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl,findAfterEvent);
    
}

function save(eventName,formDivObj,referenceItem){
	var grid = items['C106000050_Grid_1'];
	var gridObj = items['C106000050_Grid_1'].getDhxGrid();
	var selectRowId = items['C106000050_Grid_1'].getSelectedRowId();
		gridObj.selectRowById(selectRowId);
	var combo3 = gridObj.getColumnCombo(3); //부재료구분
	var grid_cnt = gridObj.getRowsNum();
	var fin_chk = "0";
	
	for(var i=0; i< grid_cnt; i++){
		var rowID = gridObj.getRowId(i);		
		var rowStatus = gridObj.getUserData(rowID,"!nativeeditor_status");
		if(rowStatus != ""){ //전체적으로 5개의 컬럼이 추가 되었음
			var cellValue = grid.getCellValue(rowID,  gridObj.getColIndexById("SUB_MTL_TP"));//3 부재료구분
			var cellValue2 = grid.getCellValue(rowID, gridObj.getColIndexById("CLR_SUB_MTL_CD"));//1 컬러코드
			var cellValue3 = grid.getCellValue(rowID, gridObj.getColIndexById("CLR_NM"));//2 색상명
			var cellValue5  = grid.getCellValue(rowID,gridObj.getColIndexById("RSN_TP"));//6 수지타입
			var cellValue7  = grid.getCellValue(rowID,gridObj.getColIndexById("LUS_RT_CD"));//8 광택도코드		  
			var cellValue12 = grid.getCellValue(rowID,gridObj.getColIndexById("PNT_FLM_THK"));//17 도막두께
			var cellValue13 = grid.getCellValue(rowID,gridObj.getColIndexById("PRT_INK_TP"));//18 InkType
			var cellValue15 = grid.getCellValue(rowID,gridObj.getColIndexById("NV"));//20 고형분(NV)
			var cellValue16 = grid.getCellValue(rowID,gridObj.getColIndexById("PNT_GRA"));//21 도료비중(SG)
			var cellValue17 = grid.getCellValue(rowID,gridObj.getColIndexById("SLV_GRA"));//22 용재비중
			var cellValue20 = grid.getCellValue(rowID,gridObj.getColIndexById("PNT_UNT"));//25 도료원단위
			var cellValue21 = grid.getCellValue(rowID,gridObj.getColIndexById("PMT"));//26 PMT
			var cellValue26 = grid.getCellValue(rowID,gridObj.getColIndexById("LMN_KND_TP"));//37 Lamina유형
            var msg = "";		
		    var colidx = 0;			
			
			grid.setCellValue(rowID,gridObj.getColIndexById("USERNO"), <%=userNo%>);
			
        if(isNull(cellValue)){
	        dhtmlx.alert("부재료구분을 선택해주세요.");		
	        gridObj.selectCell(i, 3 , true, true, true);//SetFocus기능 안됨
	        return;
        }else if(isNull(cellValue3)){
            //색상명 필수 입력으로 변경(2013.04.17)
        	dhtmlx.alert("색상명을 선택해주세요.");		
	        gridObj.selectCell(i, 3 , true, true, true);//SetFocus기능 안됨
	        return;	
        }else{
          		//PCM도료 필수항목 체크
              if((cellValue == "S31") && (isNull(cellValue2)|| isNull(cellValue5) || isNull(cellValue7) || isNull(cellValue12) || isNull(cellValue15) ||
                  isNull(cellValue16) || isNull(cellValue17) || isNull(cellValue20) || isNull(cellValue21))){

	                if(isNull(cellValue2)){
		                if(msg == ""){                      
		                	msg = "컬러코드";
		                	colidx = 1;
		                }else{ 
		                	msg = msg + ",컬러코드";
		                }
	                }
	                if(isNull(cellValue5)){
	                    if(msg == ""){
	                    	msg = "수지타입";
	                    	colidx = 5;
	                    }else{
	                     	msg = msg + ",수지타입";
	                    }
	                }
	                if(isNull(cellValue7)){
	                	if(msg == ""){
	                		msg = "광택도코드";
	                		colidx = 7;
	                  	}else{
	                  		msg = msg + ",광택도코드";
	                  	}
	                }
	                if(isNull(cellValue12)){
	                	if(msg == ""){
	                		msg = "도막두께";
	                  		colidx = 12;
	                  	}else{
	                  		msg = msg + ",도막두께";
	                  	}
	                }
	                if(isNull(cellValue15)){
	                  	if(msg == ""){
	                  		msg = "고형분(NV)";
	                  		colidx = 15;
	                  	}else{
	                  		msg = msg + ",고형분(NV)";
	                  	}
	                }
	                if(isNull(cellValue16)){
	                  	if(msg == ""){
	                  		msg = "도료비중(SG)";
	                  		colidx = 16;
	                  	}else{
	                  		msg = msg + ",도료비중(SG)";
	                  	}
	                }
	                if(isNull(cellValue17)){
	                  	if(msg == ""){
	                  		msg = "용제비중";
	                  		colidx = 17;
	                  	}else{
	                  		msg = msg + ",용제비중";
	                  	}
	                }
	                if(isNull(cellValue20)){
	                  	if(msg == ""){
	                  		msg = "도료원단위";
	                  		colidx = 20;
	                  	}else{
	                  		msg = msg + ",도료원단위";
	                  	}
	                }
	                if(isNull(cellValue21)){
	                  	if(msg == ""){
	                  		msg = "PMT";
	                  		colidx = 21;
	                  	}else{
	                  		msg = msg + ",PMT";
	                  	}
	                }                                                                                                                  
	                dhtmlx.alert("PCM도료의 필수 항목이 누락되었습니다.\n(" + msg + ")");
	                gridObj.selectCell(i, colidx , true, true);
	                return;
                }
                
           	 //Primer 필수항목 체크  
              if((cellValue == "S32") && (isNull(cellValue2)|| isNull(cellValue5) || isNull(cellValue7) || isNull(cellValue12) || isNull(cellValue15) ||
                  isNull(cellValue16) || isNull(cellValue17) || isNull(cellValue20) || isNull(cellValue21))){

	                if(isNull(cellValue2)){
	                  	if(msg == ""){                      
	                  		msg = "컬러코드";
	                  		colidx = 1;
	                  	}else{ 
	                  		msg = msg + ",컬러코드";
	                  	}
	                }
	                if(isNull(cellValue5)){
	                  	if(msg == ""){
	                  		msg = "수지타입";
	                  		colidx = 5;
	                  	}else{
	                  		msg = msg + ",수지타입";
	                  	}
	                }
	                if(isNull(cellValue7)){
	                  	if(msg == ""){
	                  		msg = "광택도코드";
	                  		colidx = 7;
	                  	}else{
	                  		msg = msg + ",광택도코드";
	                  	}
	                }
	                if(isNull(cellValue12)){
	                  	if(msg == ""){
	                  		msg = "도막두께";
	                  		colidx = 12;
	                  	}else{
	                  		msg = msg + ",도막두께";
	                  	}
	                }
	                if(isNull(cellValue15)){
	                  	if(msg == ""){
	                  		msg = "고형분(NV)";
	                  		colidx = 15;
	                  	}else{
	                  		msg = msg + ",고형분(NV)";
	                  	}
	                }
	                if(isNull(cellValue16)){
	                  	if(msg == ""){
	                  		msg = "도료비중(SG)";
	                  		colidx = 16;
	                  	}else{
	                  		msg = msg + ",도료비중(SG)";
	                  	}
	                }
	                if(isNull(cellValue17)){
	                  	if(msg == ""){
	                  		msg = "용제비중";
	                  		colidx = 17;
	                  	}else{
	                  		msg = msg + ",용제비중";
	                  	}
	                }
	                if(isNull(cellValue20)){
	                  	if(msg == ""){
	                  		msg = "도료원단위";
	                  		colidx = 20;
	                  	}else{
	                  		msg = msg + ",도료원단위";
	                  	}
	                }
	                if(isNull(cellValue21)){
	                  	if(msg == ""){
	                  		msg = "PMT";
	                  		colidx = 21;
	                  	}else{
	                  		msg = msg + ",PMT";
	                  	}
	                }                                                                                                                  
	                dhtmlx.alert("Primer의 필수 항목이 누락되었습니다.\n(" + msg + ")");
	                gridObj.selectCell(i, colidx , true, true);
	                return;
                }

            //Clear 필수항목 체크  
              if((cellValue == "S35") && (isNull(cellValue2)|| isNull(cellValue5) || isNull(cellValue7) || isNull(cellValue12) || isNull(cellValue15) ||
                  isNull(cellValue16) || isNull(cellValue17) || isNull(cellValue20) || isNull(cellValue21))){

	                if(isNull(cellValue2)){
	                  	if(msg == ""){                      
	                  		msg = "컬러코드";
	                  		colidx = 1;
	                  	}else{ 
	                  		msg = msg + ",컬러코드";
	                  	}
	                }
	                if(isNull(cellValue5)){
	                  	if(msg == ""){
	                  		msg = "수지타입";
	                  		colidx = 5;
	                  	}else{
	                  		msg = msg + ",수지타입";
	                  	}
	                }
	                if(isNull(cellValue7)){
	                  	if(msg == ""){
	                  		msg = "광택도코드";
	                  		colidx = 7;
	                  	}else{
	                  		msg = msg + ",광택도코드";
	                  	}
	                }
	                if(isNull(cellValue12)){
	                  	if(msg == ""){
	                  		msg = "도막두께";
	                  		colidx = 12;
	                  	}else{
	                  		msg = msg + ",도막두께";
	                  	}
	                }
	                if(isNull(cellValue15)){
	                  	if(msg == ""){
	                  		msg = "고형분(NV)";
	                  		colidx = 15;
	                  	}else{
	                  		msg = msg + ",고형분(NV)";
	                  	}
	                }
	                if(isNull(cellValue16)){
	                  	if(msg == ""){
	                  		msg = "도료비중(SG)";
	                  		colidx = 16;
	                  	}else{
	                  		msg = msg + ",도료비중(SG)";
	                  	}
	                }
	                if(isNull(cellValue17)){
	                  	if(msg == ""){
	                  		msg = "용제비중";
	                  		colidx = 17;
	                  	}else{
	                  		msg = msg + ",용제비중";
	                  	}
	                }
	                if(isNull(cellValue20)){
	                  	if(msg == ""){
	                  		msg = "도료원단위";
	                  		colidx = 20;
	                  	}else{
	                  		msg = msg + ",도료원단위";
	                  	}
	                }
	                if(isNull(cellValue21)){
	                  	if(msg == ""){
	                  		msg = "PMT";
	                  		colidx = 21;
	                  	}else{
	                  		msg = msg + ",PMT";
	                  	}
	                }                                                                                                                  
	                dhtmlx.alert("Clear의 필수 항목이 누락되었습니다.\n(" + msg + ")");
	                gridObj.selectCell(i, colidx , true, true);
	                return;
                }

            //Lamina 필수항목 체크  
              if((cellValue == "S38") && (isNull(cellValue2) || isNull(cellValue12) || isNull(cellValue26))){

	                if(isNull(cellValue2)){
	                 	if(msg == ""){
	                  		msg = "컬러코드";
	                  		colidx = 1;
	                  	}else{ 
	                  		msg = msg + ",컬러코드";
	                  	}
	                }
	                if(isNull(cellValue12)){
	                  	if(msg == ""){
	                  		msg = "도막두께";
	                  		colidx = 12;
	                  	}else{
	                  		msg = msg + ",도막두께";
	                  	}
	                }
	                if(isNull(cellValue26)){
	                  	if(msg == ""){
	                  		msg = "Lamina유형";
	                  		colidx = 26;
	                  	}else{
	                  		msg = msg + ",Lamina유형";
	                  	}
	                }                                                                                                                
	                dhtmlx.alert("Lamina의 필수 항목이 누락되었습니다.\n(" + msg + ")");  //이부분수정
	                gridObj.selectCell(i, colidx , true, true);
	                return;
                }

            //대표색상 필수항목 체크  
              if((cellValue == "ZZZ") && (isNull(cellValue2) || isNull(cellValue5) || isNull(cellValue7) || isNull(cellValue12))){

	                if(isNull(cellValue2)){
	                  	if(msg == ""){
	                  		msg = "컬러코드";
	                  		colidx = 1;
	                  	}else{ 
	                  		msg = msg + ",컬러코드";
	                  	}
	                }
	                if(isNull(cellValue5)){
	                  	if(msg == ""){
	                  		msg = "수지타입";
	                  		colidx = 5;
	                  	}else{
	                  		msg = msg + ",수지타입";
	                  	}
	                }
	                if(isNull(cellValue7)){
	                  	if(msg == ""){
	                  		msg = "광택도코드";
	                  		colidx = 7;
	                  	}else{
	                  		msg = msg + ",광택도코드";
	                  	}
	                }                
	                if(isNull(cellValue12)){
	                  	if(msg == ""){
	                  		msg = "도막두께";
	                  		colidx = 12;
	                  	}else{
	                  		msg = msg + ",도막두께";
	                  	}
	                }                                                                                                             
	                dhtmlx.alert("대표색상의 필수 항목이 누락되었습니다.\n(" + msg + ")");
	                gridObj.selectCell(i, colidx , true, true);
                return;
                }

            //Ink 필수항목 체크  
              if((cellValue == "S34") && (isNull(cellValue2) || isNull(cellValue13))){

	                if(isNull(cellValue2)){
	                  	if(msg == ""){
	                  		msg = "컬러코드";
	                  		colidx = 1;
	                  	}else{ 
	                  		msg = msg + ",컬러코드";
	                  	}
	                }
	                if(isNull(cellValue13)){
	                  	if(msg == ""){
	                  		msg = "InkType";
	                  		colidx = 13;
	                  	}else{
	                  		msg = msg + ",InkType";
	                  	}
	                }                                                                                                          
	                dhtmlx.alert("Ink의 필수 항목이 누락되었습니다.\n(" + msg + ")");
	                gridObj.selectCell(i, colidx , true, true);
                return;
                }

            //Thinner 필수항목 체크  
              if((cellValue == "S33") && (isNull(cellValue2))){

	                if(isNull(cellValue2)){
	                  	if(msg == ""){
	                  		msg = "컬러코드";
	                  		colidx = 1;
	                  	}else{ 
	                  		msg = msg + ",컬러코드";
	                  	}
	                }                                                                                                          
	                dhtmlx.alert("Thinner의 필수 항목이 누락되었습니다.\n(" + msg + ")");
	                gridObj.selectCell(i, colidx , true, true);
	                return;
                }
            
            //보호필름 필수항목 체크  
              if((cellValue == "S36") && (isNull(cellValue2))){

	                if(isNull(cellValue2)){
	                  	if(msg == ""){
	                  		msg = "컬러코드";
	                  		colidx = 1;
	                  	}else{ 
	                  		msg = msg + ",컬러코드";
	                  	}
	                }                                                                                                          
	                dhtmlx.alert("보호필름의 필수 항목이 누락되었습니다.\n(" + msg + ")");
	                gridObj.selectCell(i, colidx , true, true);
	                return;
              }
            //도장기타 필수항목 체크  
              if((cellValue == "S37") && (isNull(cellValue2))){

					if(isNull(cellValue2)){
                  		if(msg == ""){                      
                  			msg = "컬러코드";
                  			colidx = 1;
                  		}else{ 
                  			msg = msg + ",컬러코드";
                  		}
                	}                                                                                                          
                	dhtmlx.alert("도장기타의 필수 항목이 누락되었습니다.\n(" + msg + ")");
                	gridObj.selectCell(i, colidx , true, true);
                	return;
              }
        	}  
           // 수지타입에 대한 'MTC NOTE 편집기준 Check
           if(cellValue == "S31" || cellValue == "S32" || cellValue == "S35" || cellValue == "ZZZ"){
     		  var param = "ServiceName=C106000050-service&rule_chk=1&RSN_TP_FRN="+cellValue5+"&column-info=MPR_ACT_SUB_TST";
    	      var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
    	      var cells = xmlObj.getElementsByTagName("cell");
    		  if(cells.length <= 0){						
                 dhtmlx.alert("수지:"+cellValue5+"에 대한 'MTC NOTE 편집기준'이 없습니다.");
             	 gridObj.selectCell(i, colidx , true, true);
    			 return;					
		      }          
           }
           
           if(rowStatus == "updated" || rowStatus == "deleted"){
       		 if(popCompleteYN != "Y"){
         	  	 popCompleteYN = "Y";
	  	   	   	 C10_linkC106000050pop01("grid1");
				 return false;
	    	 }

			grid.setCellValue(rowID,gridObj.getColIndexById("MDF_RSN"), popCfmRea);
		   }
		 } // end of if(rowStatus != "")
	} // end of for loop
	
  	popCompleteYN = "N";

	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"저장 하시겠습니까?",
		callback:function(val){
			if(val){
				items[referenceItem].sendGrid(referenceItem,eventName);
				//setTimeout('send()',2500);
				return;
			}
		}
	}); 

	//2013.07.25 저장 후 2.5초 이후 전송 버튼 누르지 않아도 전송되게 변경(컬러코드전송 버튼 히든처리) -> 김종민 대리요청으로 취소
	//setTimeout('send()',3000);
}

//도료업체정보 저장
function save1(eventName,formDivObj,referenceItem){
	var gridObj2 = items['C106000050_Grid_2']; 
	var grid2_row_cnt = gridObj2.getDhxGrid().getRowsNum();
	if(gridObj2.getRowSelectedId()){
		if(!(popCompleteYN=="Y")){
	    	popCompleteYN = "Y";
	    	C10_linkC106000050pop01("grid2"); //칼라부재료업체 정보 저장 사유 입력 popup
			return false;
		}
		for(var i=0; i<grid2_row_cnt; i++){	
			var rowID = gridObj2.getDhxGrid().getRowId(i);
			var clrcd      = gridObj2.getCellValue(rowID,1);
			var pntcmpcd = gridObj2.getCellValue(rowID,2);
			var rowStatus =  gridObj2.getDhxGrid().getUserData(rowID,"!nativeeditor_status");
			if(!isNull(clrcd)&&!isNull(pntcmpcd)){
				if(rowStatus == "inserted" || rowStatus == "updated" || rowStatus == "deleted"){
					gridObj2.setCellValue(rowID,20, popCfmRea);
				}
			}else{
				alert("칼라코드, 업체코드를 선택해주세요.");
				return;
			}
		}
        popCompleteYN = "N";

        dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"저장 하시겠습니까?",
			callback:function(val){
				if(val){
					items['C106000050_Grid_2'].sendGrid('C106000050_Grid_2',eventName);
					return;
				}
			}
		}); 
	}else{
		alert("칼라부재료업체 정보에 선택된 행이 없습니다.");
		return;				
	}
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
	//items[referenceItem].clearDataProcess();
	find('find','C106000050_Form_1',referenceItem);
}

//menu refresh event function
function refresh1(referenceItem){ //grid selection clear event
	if(isNull(items['C106000050_Grid_1'].getSelectedRowId())){
		dhtmlx.alert("컬러코드를 선택해주세요.");
		return;	
	}
	items['C106000050_Grid_2'].clearDataProcess();
	var prdFindUrl = uiCommon.parameters2('C106000050_Form_1','C106000050_Grid_1','C106000050_Grid_2','detailFind',items['C106000050_Grid_1'].getSelectedRowId());
	items["C106000050_Grid_2"].loadData(prdFindUrl,afterProGressOff);
}

function send(eventName,formDivObj,referenceItem){

	var grid = items['C106000050_Grid_1'];
	var gridObj = items['C106000050_Grid_1'].getDhxGrid();
	var selectedId1 = grid.getSelectedRowId();
	
	
	var START_DATE = grid.getCellValue(selectedId1,gridObj.getColIndexById("ERP_SND_DH"));
	if(isNull(START_DATE)){
		//한번도 전송한적이 없음.diff를 10이상으로 하기위해 임의 날짜 set
		var START_DATE = "2014-01-01 12:59:59";
	}
	var END_DATE = getCurrentTimeStamp();
	
	var diff = getDiffTime(START_DATE, END_DATE);
	
	/*
	if(diff < 10) {
		diff = 10 - diff;
		dhtmlx.alert("이전 전송작업이 완료되지 않았습니다.<br><br> " + diff + "분 뒤에 전송하세요.");
		return;
	}
	*/
	
	
	//도료업체 등록여부 확인 12-07-10 추가
	var gridObj2 = items['C106000050_Grid_2'].getDhxGrid();
	if(isNull(items['C106000050_Grid_2'].getCellValue(gridObj2.getRowId(0),gridObj2.getColIndexById("CLR_SUB_MTL_CD")))){
	  dhtmlx.alert("해당 컬러코드의 도료업체 등록 후 전송하세요.");
		return;
	}	
  
	var selectedId = grid.getSelectedRowId();
	if(!isNull(selectedId)){		
		var rowIdArray = selectedId.split(',');	
			
		for(var i=0; i<rowIdArray.length; i++){	
			if(isNull(grid.getCellValue(rowIdArray[i],1))){
				dhtmlx.alert("선택한 행의 컬러코드값이 없습니다. 입력해주세요.");
				return;			
			}
			if((!isNull(grid.getCellValue(rowIdArray[i],1))) &&( grid.getCellValue(rowIdArray[i],1).substring(0,3).toUpperCase() == "ZZZ" || grid.getCellValue(rowIdArray[i],3).substring(0,3).toUpperCase() == "ZZZ")){
				dhtmlx.alert("선택한 행의 컬러코드값이나 부재료구분값이 ZZZ인 경우 전송할 수 없습니다.");
				return;
			}
			grid.setUpdated(rowIdArray[i],true,"updated"); 
		}	 
		dhtmlx.confirm({
			title:"[[ 확인 ]]",
			ok:"확인", cancel:"취소",
			text:"전송 하시겠습니까?",
			callback:function(val){
				if(val){
					grid.sendGrid('C106000050_Grid_1',"send");
				return;
				}
			}
		});  
	}else{
		dhtmlx.alert("전송할 컬러코드를 선택해주세요.");
		return;
	
	}
  
}

//menu new row event function
function add(referenceItem){
   var gridDhxObj = items['C106000050_Grid_1'].getDhxGrid();	   
    //gridDhxObj.setEditable(true); //grid rock(C106000050_Grid_1.xml의 setEditable이 false)
	items[referenceItem].addRow(); //행추가
	gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), 1, "ed"); // 컬러코드 ed로 변경
	
}
//menu edit event function
function edit(referenceItem){
   var gridDhxObj = items['C106000050_Grid_1'].getDhxGrid();
   //gridDhxObj.setEditable(true); //grid rock(C106000050_Grid_1.xml의 setEditable이 false)
}

//menu new row event function
function add1(referenceItem){
	var gridObj = items['C106000050_Grid_1'];
	var gridDhxObj = items['C106000050_Grid_2'].getDhxGrid();
	
	if(!isNull(gridObj.getRowSelectedId())){
		var colorValue = gridObj.getCellValue(gridObj.getRowSelectedId(),1);
		if(!isNull(colorValue)){
			items[referenceItem].addRow(); //행추가
			gridDhxObj.setCellExcellType(gridDhxObj.getRowId(0), 2, "combo_v"); // 업체코드 combo_v로 변경
			var pntCmpCdCombo = gridDhxObj.getColumnCombo(2);
				pntCmpCdCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PNT_CMP_CD&totalValue=&orderBy=value&displayType=all-code");   
				pntCmpCdCombo.enableOptionAutoPositioning(true);
				pntCmpCdCombo.readonly(true,true);
				pntCmpCdCombo.DOMelem_input.onkeydown = function(e){
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
			items['C106000050_Grid_2'].setCellValue(gridDhxObj.getRowId(0),1,colorValue);
		}else{
			dhtmlx.alert("선택한 행의 컬러코드번호가 없습니다.\n 컬러코드번호를 입력해주세요.");
			return;
		}
	}else{
		dhtmlx.alert("상위 컬러코드를 선택해주세요.");
		return;		
	}
}

//menu remove event function
function remove(referenceItem){
    items[referenceItem].removeRow();
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
function deteilFind(rowId){
	var prdFindUrl = uiCommon.parameters2('C106000050_Form_1','C106000050_Grid_1','C106000050_Grid_2','detailFind',rowId);
	items["C106000050_Grid_2"].loadData(prdFindUrl,"");
	uiCommon.progressOff(parent);	

}
function findMessage(referenceItem){
  var grid = items['C106000050_Grid_1'].getDhxGrid();
  grid.selectRow(0);
  deteilFind("");
	uiCommon.message("messagebox",referenceItem.getUserData("","appMsg"));
	
  	return true;
}
function onFormLoadFunction(){ 
	var formObj = items['C106000050_Form_1'].getDhxForm();
	var grid = items['C106000050_Grid_1'];
	
	var gridObj = items['C106000050_Grid_1'].getDhxGrid();
	var gridObjRowCnt = gridObj.getRowsNum();


	var comboList = items['C106000050_Form_1'].getMasterCombos();
		
	    comboList['SUB_MTL_TP_SH'].readonly(true,true);//부재료구분
			ui.combo.master(comboList['SUB_MTL_TP_SH'],'SZ0000','SUB_MTL_TP_CD','totalValue=all,orderBy=value',function(){ 
			comboList['SUB_MTL_TP_SH'].selectOption(0,true,true);	
			comboList['SUB_MTL_TP_SH'].readonly(true);
			comboList['SUB_MTL_TP_SH'].setOptionHeight(220);			
		});	

		comboList['SUB_MTL_TP_SH'].DOMelem_input.onkeydown = function(e){
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

		//INK TYPE 설정
		comboList['SUB_MTL_TP_SH'].attachEvent("onSelectionChange", function(){
			var comboValue = comboList['SUB_MTL_TP_SH'].getSelectedValue();

			if(!isNull(comboValue) && comboValue == "S34"){		
				formObj.disableItem("PRT_INK_TP_SH");			
			}else if(!isNull(comboValue)){
				formObj.enableItem("PRT_INK_TP_SH");						
			}
			
			/* 2021.10.22 원본 (6개 항목 추가전)
			if(!isNull(comboValue) && (comboValue == "S31" || comboValue == "S32" || comboValue == "S35" || comboValue == "ZZZ")){	
				grid.setColumnHiddenFlag("1,2,3,5,6,8,11,12,13,14,15,16,17,20,21,22,23,25,26,27,28,29,30,48,49,50,51,52,53,54",false);
				grid.setColumnHiddenFlag("18,31,33,34,35,36,37,38,40,42,44,46",true); //완료!!
			}else if(!isNull(comboValue) && (comboValue == "S33")){	 //Thinner 완료!!
				grid.setColumnHiddenFlag("1,2,3,6,25,50,51,52,53,54",false);
				grid.setColumnHiddenFlag("8,10,11,12,13,14,15,16,17,18,20,21,22,23,25,26,27,28,29,30,31,33,34,35,36,37,38,40,42,44,46",true); 
			}else if(!isNull(comboValue) && (comboValue == "S37")){	//도장기타 완료!!
				grid.setColumnHiddenFlag("1,2,3,25,48,49,50,51,52,53,54",false);
				grid.setColumnHiddenFlag("6,11,12,14,15,16,18,27,28,29,30,31,33,34,35,36,37,38,41,42,44,46",true); 
			}else if(!isNull(comboValue) && (comboValue == "S34")){	//Ink 완료!!
				grid.setColumnHiddenFlag("1,2,3,6,8,18,25,30,48,49,50,51,52,53,54",false);
				grid.setColumnHiddenFlag("5,10,11,12,13,14,15,16,23,26,27,28,29,30,31,33,34,35,36,37,38,39,42,44,46",true); 
			}else if(!isNull(comboValue) && (comboValue == "S36")){	//보호필름 완료!!
				grid.setColumnHiddenFlag("1,2,3,25,38,40,44,46,48,49,52,53,54",false);
				grid.setColumnHiddenFlag("5,6,8,10,11,12,13,14,15,16,17,18,20,21,22,23,26,27,28,29,30,31,33,34,35,36,37",true);  
			}else if(!isNull(comboValue) && (comboValue == "S39")){	//UGS필름  이돈석 수정(2013.07.23 UGS필름 추가)  완료!!
				grid.setColumnHiddenFlag("1,2,3,40,42,48,49",false);
				grid.setColumnHiddenFlag("5,6,8,10,11,12,13,16,17,18,20,21,22,23,25,26,27,28,29,30,31,32,34,35,36,37,38,44,46,50,51,52,53,54",true);	
			}else if(!isNull(comboValue) && (comboValue == "S38")){	//Lamina  완료!!
				grid.setColumnHiddenFlag("1,2,3,8,17,25,26,31,33,34,35,36,37,48,49,50,51,52,53,54",false);
				grid.setColumnHiddenFlag("5,6,10,11,12,13,14,15,16,18,20,21,23,27,28,29,30,38,40,42,44,46",true);  
			}else{
				grid.setColumnHiddenFlag("1,2,3,5,6,8,10,11,12,13,14,15,16,17,18,20,21,22,23,25,26,27,28,29,30,31,33,34,35,36,37,38,40,42,44,46,48,49,50,51,52,53,54",false);
			}
			*/
			if(!isNull(comboValue) && (comboValue == "S31" || comboValue == "S32" || comboValue == "S35" || comboValue == "ZZZ")){	
				grid.setColumnHiddenFlag("1,2,3,5,6,8,11,12,13,14,15,16,17,20,21,22,23,25,26,27,28,29,30,31,32,33,34,35,36,54,55,56,57,58,59,60",false);
				grid.setColumnHiddenFlag("18,37,39,40,41,42,43,44,46,48,50,52,71",true); //완료!!
			}else if(!isNull(comboValue) && (comboValue == "S33")){	 //Thinner 완료!!
				grid.setColumnHiddenFlag("1,2,3,6,25,56,57,58,59,60",false);
				grid.setColumnHiddenFlag("8,10,11,12,13,14,15,16,17,18,20,21,22,23,25,26,27,28,29,30,31,32,33,34,35,36,37,39,40,41,42,43,44,46,48,50,52,71",true); 
			}else if(!isNull(comboValue) && (comboValue == "S37")){	//도장기타 완료!!
				grid.setColumnHiddenFlag("1,2,3,25,54,55,56,57,58,59,60",false);
				grid.setColumnHiddenFlag("6,11,12,14,15,16,18,27,28,29,30,31,32,33,34,35,36,37,39,40,41,42,43,44,46,48,50,52,71",true); 
			}else if(!isNull(comboValue) && (comboValue == "S34")){	//Ink 완료!!
				grid.setColumnHiddenFlag("1,2,3,6,8,18,25,30,31,32,33,34,35,36,54,55,56,57,58,59,60",false);
				grid.setColumnHiddenFlag("5,10,11,12,13,14,15,16,23,26,27,28,29,30,37,39,40,41,42,43,44,45,48,50,52,71",true); 
			}else if(!isNull(comboValue) && (comboValue == "S36")){	//보호필름 완료!!
				grid.setColumnHiddenFlag("1,2,3,25,38,40,44,46,48,49,52,53,54",false);
				grid.setColumnHiddenFlag("5,6,8,10,11,12,13,14,15,16,17,18,20,21,22,23,26,27,28,29,30,31,32,33,34,35,36,37,39,40,41,42,43,71",true);  
			}else if(!isNull(comboValue) && (comboValue == "S39")){	//UGS필름  이돈석 수정(2013.07.23 UGS필름 추가)  완료!!
				grid.setColumnHiddenFlag("1,2,3,40,42,48,49",false);
				grid.setColumnHiddenFlag("5,6,8,10,11,12,13,16,17,18,20,21,22,23,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,42,43,44,50,52,56,57,58,59,60,71",true);	
			}else if(!isNull(comboValue) && (comboValue == "S38")){	//Lamina  완료!!   ---
				grid.setColumnHiddenFlag("1,2,3,8,17,25,26,37,39,40,41,42,43,54,55,56,57,58,59,60,71",false);
				grid.setColumnHiddenFlag("5,6,10,11,12,13,14,15,16,18,20,21,23,27,28,29,30,31,32,33,34,35,36,44,46,48,50,52",true);  
			}else{
				grid.setColumnHiddenFlag("1,2,3,5,6,8,10,11,12,13,14,15,16,17,18,20,21,22,23,25,26,27,28,29,30,31,32,33,34,35,36,37,39,40,41,42,43,44,46,48,50,52,54,55,56,57,58,59,60,71",false);
			}
			
		});  
			
	    comboList['RSN_TP_SH'].readonly(true,true);//수지타입
			ui.combo.master(comboList['RSN_TP_SH'],'SZ0000','RSN_TP','totalValue=%,orderBy=value&displayType=all-code',function(){ 
			comboList['RSN_TP_SH'].selectOption(0,true,true);	
			comboList['RSN_TP_SH'].readonly(true);
			comboList['RSN_TP_SH'].setOptionHeight(200);				
		});

		comboList['RSN_TP_SH'].DOMelem_input.onkeydown = function(e){
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
//광택도코드 조건 삭제 (전송대상체크 조건 추가됨) 08-21		
//	    comboList['LUS_RT_CD_SH'].readonly(true,true);//광택도코드
//			ui.combo.master(comboList['LUS_RT_CD_SH'],'SZ0000','LUS_RT_CD','totalValue=,orderBy=value',function(){ 
//			comboList['LUS_RT_CD_SH'].selectOption(0,true,true);		
//		});
//
//		comboList['LUS_RT_CD_SH'].DOMelem_input.onkeydown = function(e){
//		key = (e) ? e.keyCode : event.keyCode;
//			if(key==8 || key==116){
//				if(e){   //표준         
//					e.preventDefault();
//				}
//				else{ //익스용
//					event.keyCode = 0;
//					event.returnValue = false;
//				}
//			}
//		}
		
		comboList['PRT_INK_TP_SH'].readonly(true,true);//INK TYPE
			ui.combo.master(comboList['PRT_INK_TP_SH'],'SZ0000','PRT_INK_TP','totalValue=&,orderBy=value',function(){ 
			comboList['PRT_INK_TP_SH'].selectOption(0,true,true);		
			comboList['PRT_INK_TP_SH'].readonly(true);
			comboList['PRT_INK_TP_SH'].setOptionHeight(200);			
		});	
		
		comboList['PRT_INK_TP_SH'].DOMelem_input.onkeydown = function(e){
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

		comboList['TP_CD'].readonly(true,true);//TYPE구분	 
		ui.combo.master(comboList['TP_CD'],'SZ0000','TP_CD','totalValue=%,orderBy=value&displayType=all-code',function(){ 
			comboList['TP_CD'].selectOption(0,true,true);	
			comboList['TP_CD'].readonly(true);
			comboList['TP_CD'].setOptionHeight(200);				
		});
	
		comboList['TP_CD'].DOMelem_input.onkeydown = function(e){
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

		var inputObj = formObj.getInput("CLR_SUB_MTL_CD_SH");
			inputObj.onkeyup = function(e){	
				if(inputObj.value.charAt(inputObj.value.length - 1) <= 'z' && inputObj.value.charAt(inputObj.value.length - 1) >= 'a'){
				  inputObj.value = inputObj.value.toUpperCase();
				}	
				e = e||window.event;
				if(e.keyCode == 13){
					formObj.setItemValue("CLR_SUB_MTL_CD_SH",inputObj.value); 
					find("find","C106000050_Form_1","C106000050_Grid_1");			
				}
			}
		
		items['C106000050_Form_1'].getDhxForm().detachEvent(onXleForm);
}

function onGrid1LoadFunction(){
	var grid =  items['C106000050_Grid_1'];
	var gridObj = items['C106000050_Grid_1'].getDhxGrid();
	
	var gridDhxObj = items['C106000050_Grid_1'].getDhxGrid();		
	
	var sub_mtl_tp_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('SUB_MTL_TP')); //부재료구분
	    sub_mtl_tp_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=SUB_MTL_TP_CD&totalValue=&orderBy=value&displayType=all-code");   
		sub_mtl_tp_Combo.enableOptionAutoPositioning(true);
		sub_mtl_tp_Combo.readonly(true,true);
		sub_mtl_tp_Combo.setOptionHeight(220);

		//부재료구분
		sub_mtl_tp_Combo.attachEvent("onSelectionChange", function(){
			var rowId = grid.getRowSelectedId();
			
			grid.setCellValue(rowId,gridObj.getColIndexById("SUB_MTL_TP_HIDDEN"),sub_mtl_tp_Combo.getSelectedValue());
			var SUB_MTL_TP_HIDDEN =  gridObj.cellById(rowId, gridObj.getColIndexById("SUB_MTL_TP_HIDDEN")).getValue();

			//
			if(SUB_MTL_TP_HIDDEN != "S31" && SUB_MTL_TP_HIDDEN != "S32" && SUB_MTL_TP_HIDDEN != "S35" && SUB_MTL_TP_HIDDEN != "S37" && SUB_MTL_TP_HIDDEN != "ZZZ" && (!isNull(grid.getCellValue(rowId,23)))){	
				grid.setCellValue(rowId,23,"");				
			}else{
				if(SUB_MTL_TP_HIDDEN == "S31" || SUB_MTL_TP_HIDDEN == "S32" || SUB_MTL_TP_HIDDEN == "S35" || SUB_MTL_TP_HIDDEN == "S37" || SUB_MTL_TP_HIDDEN == "ZZZ"){

					//도료원단위계산식
					var nv = 0, unt_gra = 0, slv_gra = 0, pnt_unt = 0;
					nv = gridObj.cellById(rowId,gridObj.getColIndexById("NV")).getValue();
					unt_gra = gridObj.cellById(rowId,gridObj.getColIndexById("PNT_GRA")).getValue();
					slv_gra = gridObj.cellById(rowId,gridObj.getColIndexById("SLV_GRA")).getValue();			
					pnt_unt = (parseFloat(unt_gra)*100)/(100-((100-parseFloat(nv))*(parseFloat(unt_gra)/parseFloat(slv_gra))));	 
				
					if(nv == "0" || unt_gra == "0" || slv_gra == "0" ){
					   items['C106000050_Grid_1'].setCellValue(rowId, gridObj.getColIndexById("PNT_UNT"), "");          
					}else if(isNull(nv) || isNull(unt_gra) || isNull(slv_gra)){			
					   items['C106000050_Grid_1'].setCellValue(rowId, gridObj.getColIndexById("PNT_UNT"), "");          
					}else{	           
					   items['C106000050_Grid_1'].setCellValue(rowId, gridObj.getColIndexById("PNT_UNT"), pnt_unt.toFixed(2));   
					}
					
				}
			}
		});
	
    var rsnTpCombo = gridObj.getColumnCombo(gridObj.getColIndexById('RSN_TP')); //수지타입
        rsnTpCombo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=RSN_TP&totalValue=&orderBy=value&displayType=all-code");   
		rsnTpCombo.enableOptionAutoPositioning(true);
		rsnTpCombo.readonly(true,true);
		rsnTpCombo.setOptionHeight(220);
		//백스페이스 이벤트 막기처리
        
    var lusRt_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('LUS_RT_CD')); //광택도코드
        lusRt_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=LUS_RT_CD&totalValue=&orderBy=value&displayType=all-code");   
		lusRt_cd_Combo.enableOptionAutoPositioning(true);
		lusRt_cd_Combo.readonly(true,true);
		lusRt_cd_Combo.setOptionHeight(220);
        //백스페이스 이벤트 막기처리

    var prt_Ink_tp_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('PRT_INK_TP')); //INK TYPE코드
        prt_Ink_tp_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PRT_INK_TP&totalValue=&orderBy=value&displayType=all-code");   
		prt_Ink_tp_Combo.enableOptionAutoPositioning(true);
		prt_Ink_tp_Combo.readonly(true,true);
		prt_Ink_tp_Combo.setOptionHeight(220);
		//백스페이스 이벤트 막기처리
        
    var ptt_Flm_thk_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('PTT_FLM_THK_CD')); //보호필름&lt;br&gt;두께코드
        ptt_Flm_thk_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PTT_FLM_THK_CD&totalValue=&orderBy=value&displayType=all-code");   
		ptt_Flm_thk_cd_Combo.enableOptionAutoPositioning(true);
		ptt_Flm_thk_cd_Combo.readonly(true,true);
		ptt_Flm_thk_cd_Combo.setOptionHeight(220);
		//백스페이스 이벤트 막기처리

    var lmn_flm_thk_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('LMN_FLM_THK_CD')); //Lamina필름두께코드
        lmn_flm_thk_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=LMN_FLM_THK_CD&totalValue=&orderBy=value&displayType=all-code");   
    	lmn_flm_thk_cd_Combo.enableOptionAutoPositioning(true);
    	lmn_flm_thk_cd_Combo.readonly(true,true);
    	lmn_flm_thk_cd_Combo.setOptionHeight(220);
		
    var lmn_Knd_tp_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('LMN_KND_TP')); //Lamina유형
        lmn_Knd_tp_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=LMN_KND_TP&totalValue=&orderBy=value&displayType=all-code");   
		lmn_Knd_tp_Combo.enableOptionAutoPositioning(true);
		lmn_Knd_tp_Combo.readonly(true,true);
		lmn_Knd_tp_Combo.setOptionHeight(220);
        
    var ptt_Flm_lus_rt_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('PTT_FLM_LUS_RT_CD')); //보호필름 광택코드
        ptt_Flm_lus_rt_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PTT_FLM_LUS_RT_CD&totalValue=&orderBy=value&displayType=all-code");   
		ptt_Flm_lus_rt_cd_Combo.enableOptionAutoPositioning(true);
		ptt_Flm_lus_rt_cd_Combo.readonly(true,true);
		ptt_Flm_lus_rt_cd_Combo.setOptionHeight(220);
        
    var ptt_Flm_sus_adh_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('PTT_FLM_SUS_ADH_CD')); //보호필름 SUS점착력코드
        ptt_Flm_sus_adh_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PTT_FLM_SUS_ADH_CD&totalValue=&orderBy=value&displayType=all-code");   
		ptt_Flm_sus_adh_cd_Combo.enableOptionAutoPositioning(true);
		ptt_Flm_sus_adh_cd_Combo.readonly(true,true);
		ptt_Flm_sus_adh_cd_Combo.setOptionHeight(220);

    var ptt_Flm_prd_adh_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('PTT_FLM_PRD_ADH_CD')); //보호필름 제품점착력코드
        ptt_Flm_prd_adh_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PTT_FLM_PRD_ADH_CD&totalValue=&orderBy=value&displayType=all-code");   
		ptt_Flm_prd_adh_cd_Combo.enableOptionAutoPositioning(true);
		ptt_Flm_prd_adh_cd_Combo.readonly(true,true);
		ptt_Flm_prd_adh_cd_Combo.setOptionHeight(220);

	var ptt_flm_mql_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('PTT_FLM_MQL_CD')); //보호필름 제질코드
        ptt_flm_mql_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PTT_FLM_MQL_CD&totalValue=&orderBy=value&displayType=all-code");     
		ptt_flm_mql_cd_Combo.enableOptionAutoPositioning(true);
		ptt_flm_mql_cd_Combo.readonly(true,true);
		ptt_flm_mql_cd_Combo.setOptionHeight(220);
		
	var tp_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('TP_CD')); //type유형
		tp_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=TP_CD&totalValue=&orderBy=value&displayType=all-code");     
		tp_cd_Combo.enableOptionAutoPositioning(true);
		tp_cd_Combo.readonly(true,true);
		tp_cd_Combo.setOptionHeight(220);
		
		
		//2021.10.22 6개 항목추가
	var rsn_tp_qt_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('RSN_TP_QT')); //type유형
		rsn_tp_qt_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=RSN_TP_QT&totalValue=&orderBy=value&displayType=all-code");     
		rsn_tp_qt_Combo.enableOptionAutoPositioning(true);
		rsn_tp_qt_Combo.readonly(true,true);
		rsn_tp_qt_Combo.setOptionHeight(220);
		
	var pat_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('PAT_CD')); //type유형
		pat_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=PAT_CD&totalValue=&orderBy=value&displayType=all-code");     
		pat_cd_Combo.enableOptionAutoPositioning(true);
		pat_cd_Combo.readonly(true,true);
		pat_cd_Combo.setOptionHeight(220);
		
	var func_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('FUNC_CD')); //type유형
		func_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=FUNC_CD&totalValue=&orderBy=value&displayType=all-code");     
		func_cd_Combo.enableOptionAutoPositioning(true);
		func_cd_Combo.readonly(true,true);
		func_cd_Combo.setOptionHeight(220);
		
	var tte_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('TTE_CD')); //type유형
		tte_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=TTE_CD&totalValue=&orderBy=value&displayType=all-code");     
		tte_cd_Combo.enableOptionAutoPositioning(true);
		tte_cd_Combo.readonly(true,true);
		tte_cd_Combo.setOptionHeight(220);
		
	var use_pos_cd_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('USE_POS_CD')); //type유형
		use_pos_cd_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=USE_POS_CD&totalValue=&orderBy=value&displayType=all-code");     
		use_pos_cd_Combo.enableOptionAutoPositioning(true);
		use_pos_cd_Combo.readonly(true,true);
		use_pos_cd_Combo.setOptionHeight(220);
		
	var wty_yn_Combo = gridObj.getColumnCombo(gridObj.getColIndexById('WTY_YN')); //type유형
		wty_yn_Combo.loadXML("basicLovData.do?ServiceName=lov-service&category=SZ0000&code=WTY_YN&totalValue=&orderBy=value&displayType=all-code");     
		wty_yn_Combo.enableOptionAutoPositioning(true);
		wty_yn_Combo.readonly(true,true);
		wty_yn_Combo.setOptionHeight(220);
		
		/*
		//부재료구분
		tp_cd_Combo.attachEvent("onSelectionChange", function(){
			var rowId = grid.getRowSelectedId();
			var tp_cd = gridObj.cellById(rowId,gridObj.getColIndexById("TP_CD")).getValue();
			var col_diff_std;
			
			if(tp_cd == '1'){
				col_diff_std = 0.5;
			}else if(tp_cd == '2'){
				col_diff_std = 0.8;
			}else if(tp_cd == '3'){
				col_diff_std = 1.2;
			}
			
			items['C106000050_Grid_1'].setCellValue(rowId, gridObj.getColIndexById("COL_DIF_STD"), col_diff_std);
		});	
		*/
		
		//키보드 화살표 이동시 상세그리드 자동조회 12-07-27
		gridObj.attachEvent("onSelectStateChanged", function(id){
		deteilFind(items['C106000050_Grid_1'].getSelectedRowId());
	  });		

		//items['C106000050_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
		//items['C106000050_Grid_1'].getDhxGrid().detachEvent(onXleGrid);
}
function onGrid2LoadFunction(){
	var gridObj = items['C106000050_Grid_2'].getDhxGrid();	
		//items['C106000050_Grid_2'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
		//items['C106000050_Grid_2'].getDhxGrid().detachEvent(onXleGrid2);
}

//(물성) 등록을 위한 POP-UP
function doImgPopUp2(rowIdx){	
	var gridObj = items['C106000050_Grid_2'].getDhxGrid();
	var rowId = gridObj.getRowIndex(rowIdx);
	
	var md_url = "C106000050pop03.jsp?rowId="+rowId;
		md_url += "&CLR_SUB_MTL_CD="+items['C106000050_Grid_2'].getCellByIndexValue(rowId,gridObj.getColIndexById('CLR_SUB_MTL_CD'));
		md_url += "&PNT_CMP_CD="+items['C106000050_Grid_2'].getCellByIndexValue(rowId,gridObj.getColIndexById('PNT_CMP_CD'));
		md_url += "&SEQ=1";  // 1로 고정
		md_url += "&parent_item=C106000050_Grid_2";

	var cusWinObj = new ui.window("C106000050PopWin","MSDS 파일 다운로드","0","0","465","405",md_url);
		cusWinObj.setButtonDisable("park,minmax1");
		cusWinObj.setModal();
	
}


function onCheckboxEvent(row_id,cell_index,state){
	var gridObj = items['C106000050_Grid_1'];
	if(!state){
		items['C106000050_Grid_1'].setUpdated(row_id,false,"");   
	}
	return true;
}

function onGridAfterUpdateFinishEvent(){
	items['C106000050_Grid_1'].clearDataProcess();
	items['C106000050_Grid_2'].clearDataProcess();
	var gridObj = items['C106000050_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt; i++){
		var rowID = gridObj.getRowId(i);
        items['C106000050_Grid_1'].setUpdated(rowID,false,""); 
	}
	//var findUrl = uiCommon.parameters('C106000050_Form_1','C106000050_Grid_1','find');
  //items['C106000050_Grid_1'].loadData(findUrl);
    find("find","C106000050_Form_1","C106000050_Grid_1");//08-20추가
}

function onGridAfterUpdateFinishEvent2(){
	items['C106000050_Grid_2'].clearDataProcess();
	var gridObj = items['C106000050_Grid_2'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	for(var i=0; i< grid_cnt; i++){
		var rowID = gridObj.getRowId(i);
        items['C106000050_Grid_2'].setUpdated(rowID,false,""); 
	}
	var selectedRowId = items['C106000050_Grid_1'].getSelectedRowId();
	if(!isNull(selectedRowId)){
		var prdFindUrl = uiCommon.parameters2('C106000050_Form_1','C106000050_Grid_1','C106000050_Grid_2','detailFind',selectedRowId);
		items["C106000050_Grid_2"].loadData(prdFindUrl,afterProGressOff);	
	}
  //var findUrl = uiCommon.parameters('C106000050_Form_1','C106000050_Grid_1','find');
  //items['C106000050_Grid_1'].loadData(findUrl);	
    find("find","C106000050_Form_1","C106000050_Grid_1");//08-20추가
}

//전송대상건 gridrow 붉은색 처리 추가 08-20
function findAfterEvent(){
	var gridObj = items["C106000050_Grid_1"].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();

	for(var i=0; i< grid_cnt; i++){  //ERP전송일시 59번 index
		var sndLst = gridObj.cellById(gridObj.getRowId(i),gridObj.getColIndexById("SND_LST")).getValue();
		
	 	if(sndLst == "Y"){
			gridObj.setRowTextStyle(gridObj.getRowId(i), "color: red;");		
		} else {
			var purChrCfm = gridObj.cellById(gridObj.getRowId(i),gridObj.getColIndexById("PUR_CHR_CFM")).getValue();

			if(purChrCfm != "Y"){
				if(purChrCfm == "R") {
					gridObj.setRowTextStyle(gridObj.getRowId(i), "color: green;");
				} else{
					gridObj.setRowTextStyle(gridObj.getRowId(i), "color: blue;");
				}
    		}
		}
	}
  	uiCommon.progressOff(parent);	
  	findMessage(gridObj);
}


function onEditCellEvent(stage, rId, cInd, nValue, oValue){
	var grid = items["C106000050_Grid_1"];
	var gridObj = items["C106000050_Grid_1"].getDhxGrid();
	var param= "";	

	if(stage==1) { 
		if(cInd == 1){//컬러코드
			gridObj.editor.obj.onkeyup = function() {
			
//10ui.js와 같이 반영해주세요.			  
//			  for (i = 0; i < gridObj.editor.obj.value.length; i++){
//	  			  if (((gridObj.editor.obj.value.charCodeAt(i) > 0x3130 && gridObj.editor.obj.value.charCodeAt(i) < 0x318F) || 
//	  						 (gridObj.editor.obj.value.charCodeAt(i) >= 0xAC00 && gridObj.editor.obj.value.charCodeAt(i) <= 0xD7A3))){
//	  								dhtmlx.alert("컬러코드는 알파벳과 숫자만 입력해 주세요");
//	  								gridObj.editor.obj.value = "";
//	  								return;
//	  			  }
//			  }
			  
				var valueLength = gridObj.editor.obj.value+'';
				if(!hanCheck(valueLength,'5')){
					dhtmlx.alert("5자리만 입력 가능합니다.");
					//items"C106000050_Grid_1"].setCellValue(rd, cInd, 5);
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

			var rowStatus = gridObj.getUserData(rId,"!nativeeditor_status");
			if( rowStatus!="inserted"){
				dhtmlx.alert("행추가를 한경우에만 컬러코드를 입력하실 수 있습니다.");
				gridObj.clearSelection();		
				return;
			}
    	}else if(cInd == 2){//색상명
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'40')){
  					dhtmlx.alert("40자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}
		}else if(cInd == 11 ) { //광택도하한값
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("광택도하한값의",4,1,true,this.value)){
						return true;
					}else{
						this.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 12 ) { //광택도상한값
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("광택도상한값의",4,1,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			} 
		}else if(cInd == 16 ) { //작업점도
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("작업점도의",3,0,true,this.value)){
						return true;
					}else{
						this.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 17 ) { //도막두께
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("도막두께의",3,0,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 21 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("도료비중의",7,2,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 20 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("고형분의",7,2,true,this.value)){
						return true;
					}else{
						this.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 22 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("용재비중의",7,2,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
    	}else if(cInd == 23 ){//적용시너코드
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'5')){
  					dhtmlx.alert("5자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}			
		}else if(cInd == 25 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("도료원단위의",8,2,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 26 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("PMT의",4,0,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 27 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(c106000050_grid_qnty_check("L의",6,3,true,this.value)){
						return true;
					}else{
						this.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 28 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(c106000050_grid_qnty_check("A의",6,3,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 29 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(c106000050_grid_qnty_check("B의",6,3,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}						 			 			
    	}else if(cInd == 36){//표준색상명 
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'20')){
  					dhtmlx.alert("20자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}	
    	/*
    	}else if(cInd == 33 || cInd == 34 || cInd == 35 || cInd == 36){//라미나접착제 -> 대문자입력
			gridObj.editor.obj.onkeydown = function(e){
			    var cellValue = gridObj.editor.obj.value;
		  	    if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
		  		   gridObj.editor.obj.value = cellValue.toUpperCase();
		  		}
		    }*/
    	}else if(cInd == 39 || cInd == 40 || cInd == 41 || cInd == 42){//라미나접착제 -> 대문자입력
			gridObj.editor.obj.onkeydown = function(e){
			    var cellValue = gridObj.editor.obj.value;
		  	    if(cellValue.charAt(cellValue - 1) <= 'z' && cellValue.charAt(cellValue.length - 1) >= 'a'){
		  		   gridObj.editor.obj.value = cellValue.toUpperCase();
		  		}
		    }	    
    	/*
    	}else if(cInd == 48){//비고
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'100')){
  					dhtmlx.alert("100자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}
    	}else if(cInd == 49){//등록자
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'10')){
  					dhtmlx.alert("10자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}
    	}else if(cInd == 51){//수정자
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'10')){
  					dhtmlx.alert("10자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}
    	*/
    	}else if(cInd == 54){//비고
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'100')){
  					dhtmlx.alert("100자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}
    	}else if(cInd == 55){//등록자
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'10')){
  					dhtmlx.alert("10자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}
    	}else if(cInd == 57){//수정자
  			gridObj.editor.obj.onkeyup = function() {
  				var valueLength = gridObj.editor.obj.value+'';
  				if(!hanCheck(valueLength,'10')){
  					dhtmlx.alert("10자리만 입력 가능합니다.");
  					gridObj.editor.obj.value = "";
  					return false;
  				}				
  			}
  		}else{
  			return true;
  		}
	}else if(stage ==2){
		var rowStatus = gridObj.getUserData(rId,"!nativeeditor_status");
		var sub_mtl_tp_Combo = gridObj.getColumnCombo(3); //부재료구분
		
		if(rowStatus !=""){
			if(cInd==1 && !isNull(nValue)){
			  
				if(grid.getCellValue(rId,1).length < 5){
			    	dhtmlx.alert("컬러코드는 5자리만 입력가능합니다.");
			    return;
				}
				var comboValue = sub_mtl_tp_Combo.getSelectedValue();
				var param= "ServiceName=C106000050-service&colorAjaxFind=1&CLR_SUB_MTL_CD="+nValue+"&SUB_MTL_TP="+comboValue+"&column-info=CLR_SUB_MTL_CD";				
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell"); 
				if(cells.length > 0){					
					dhtmlx.alert("이미 등록된 컬러코드가 있습니다.");
					grid.setCellByIndexValue(0,0,"");
					//grid.setUpdated(rId,false,""); 
					return;										
				}
			}else if((cInd==20 || cInd==21 || cInd==22)){
                var SUB_MTL_TP_HIDDEN =  gridObj.cellById(rId, gridObj.getColIndexById("SUB_MTL_TP_HIDDEN")).getValue();

				if(isNull(SUB_MTL_TP_HIDDEN)){
					dhtmlx.alert("부재료 구분을 선택해주세요.");
					return;								
				}else if(SUB_MTL_TP_HIDDEN == "S31" || SUB_MTL_TP_HIDDEN == "S32" || SUB_MTL_TP_HIDDEN == "S35" || SUB_MTL_TP_HIDDEN == "S37" || SUB_MTL_TP_HIDDEN == "ZZZ"){
					
					//도료원단위계산식
					var nv = 0, unt_gra = 0, slv_gra = 0, pnt_unt = 0;
					nv = gridObj.cellById(rId,gridObj.getColIndexById("NV")).getValue();
					unt_gra = gridObj.cellById(rId,gridObj.getColIndexById("PNT_GRA")).getValue();
					slv_gra = gridObj.cellById(rId,gridObj.getColIndexById("SLV_GRA")).getValue();			
					pnt_unt = (parseFloat(unt_gra)*100)/(100-((100-parseFloat(nv))*(parseFloat(unt_gra)/parseFloat(slv_gra))));	 
				
					if(nv == "0" || unt_gra == "0" || slv_gra == "0" ){
					   items['C106000050_Grid_1'].setCellValue(rId, gridObj.getColIndexById("PNT_UNT"), "");          
					}else if(isNull(nv) || isNull(unt_gra) || isNull(slv_gra)){			
					   items['C106000050_Grid_1'].setCellValue(rId, gridObj.getColIndexById("PNT_UNT"), "");          
					}else{	           
					   items['C106000050_Grid_1'].setCellValue(rId, gridObj.getColIndexById("PNT_UNT"), pnt_unt.toFixed(2));   
					}		
				}
				
			}
			//색차기준
			else if(cInd==5){
				var tp_cd = gridObj.cellById(rId,gridObj.getColIndexById("TP_CD")).getValue();
				var col_diff_std;
				
				if(tp_cd == '1'){
					col_diff_std = 0.5;
				}else if(tp_cd == '2'){
					col_diff_std = 0.8;
				}else if(tp_cd == '3'){
					col_diff_std = 1.2;
				}
				
				items['C106000050_Grid_1'].setCellValue(rId, gridObj.getColIndexById("COL_DIF_STD"), col_diff_std);
			}
			//색상명, 수지, 광택도 변경 시 수정여부에 값 입력되는 로직 추가
			else if((cInd==2 || cInd==6 || cInd==8)){
				if (oValue != nValue)
				{
					//ERP전송 기록이 있는 경우만 수정여부에 M을 넣어주고 그렇지 않고 전송기록이 한번도 없는경우는 M을 넣지 않는다
					if(gridObj.cellById(rId,gridObj.getColIndexById("ERP_SND_DH")).getValue() != ""){
						items['C106000050_Grid_1'].setCellValue(rId, gridObj.getColIndexById("MOD_YN"), "M");
					}
				}
			}else if(cInd==10)
				{
				var SUB_MTL_TP_HIDDEN =  gridObj.cellById(rId, gridObj.getColIndexById("SUB_MTL_TP_HIDDEN")).getValue();

				if(isNull(SUB_MTL_TP_HIDDEN)){
					dhtmlx.alert("부재료 구분을 선택해주세요.");
					return;								
				}else if(SUB_MTL_TP_HIDDEN == "S31" || SUB_MTL_TP_HIDDEN == "S32" || SUB_MTL_TP_HIDDEN == "S35" || SUB_MTL_TP_HIDDEN == "S37" || SUB_MTL_TP_HIDDEN == "ZZZ"){
					//광택도 하한,상한 계산식
					var rl_lus_rt;
					var lus_rt_llv;
					var lus_rt_ulv;
					rl_lus_rt = gridObj.cellById(rId,gridObj.getColIndexById("RL_LUS_RT")).getValue();
					
					if(rl_lus_rt <= 5){  //실광택도가 <=5인경우
						lus_rt_llv = Number(rl_lus_rt)-2;
						lus_rt_ulv = Number(rl_lus_rt)+2;
					}
					else if(rl_lus_rt > 5 && rl_lus_rt <= 10){
						lus_rt_llv = Number(rl_lus_rt)-3;
						lus_rt_ulv = Number(rl_lus_rt)+3;
					}
					else if(rl_lus_rt > 10 && rl_lus_rt <= 20){
						lus_rt_llv = Number(rl_lus_rt)-4;
						lus_rt_ulv = Number(rl_lus_rt)+4;
					}
					else if(rl_lus_rt > 20 && rl_lus_rt <= 40){
						lus_rt_llv = Number(rl_lus_rt)-6;
						lus_rt_ulv = Number(rl_lus_rt)+6;
					}
					else if(rl_lus_rt > 40 && rl_lus_rt <= 60){
						lus_rt_llv = Number(rl_lus_rt)-8;
						lus_rt_ulv = Number(rl_lus_rt)+8;
					}else if(rl_lus_rt > 60){
						lus_rt_llv = Number(rl_lus_rt)-10;
						lus_rt_ulv = Number(rl_lus_rt)+10;
					}
					
					items['C106000050_Grid_1'].setCellValue(rId, gridObj.getColIndexById("LUS_RT_LLV"), lus_rt_llv);
					items['C106000050_Grid_1'].setCellValue(rId, gridObj.getColIndexById("LUS_RT_ULV"), lus_rt_ulv);
					
				}
			}
		}

	}
	return true;
}


function onEditCellEvent2(stage,rId,cInd,nValue,oValue){
	var gridObj = items["C106000050_Grid_2"].getDhxGrid();
	var gridObj1 = items["C106000050_Grid_1"].getDhxGrid();
	
	if(stage==1){
		if(cInd == 6 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("고형분의",7,2,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 7 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("도료비중의",7,2,true,this.value)){
						return true;
					}else{
						this.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 8 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("용재비중의",7,2,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else if(cInd == 9 ) { //MAX LENGTH 체크
			gridObj.editor.obj.onkeyup = function(e){
				e = e||window.event;
				if((e.keyCode >= 47) || (e.keyCode == 0)){
					var text = this.value;
					if(grid_qnty_check("도료원단위의",8,2,true,this.value)){
						return true;
					}else{
						gridObj.editor.obj.value = "";
						return true;
					}					
				}
			}
		}else{
			return true;
		}
	}else if(stage ==2){
		var rowStatus = gridObj.getUserData(rId,"!nativeeditor_status");
		
		if(rowStatus !=""){
            if((cInd==4 || cInd==5 || cInd==6)){
                var SUB_MTL_TP_HIDDEN2 =  gridObj1.cellById(gridObj1.getSelectedRowId(), gridObj1.getColIndexById("SUB_MTL_TP_HIDDEN")).getValue();

				if(isNull(SUB_MTL_TP_HIDDEN2)){
					dhtmlx.alert("부재료 구분이 잘못되었습니다.");
					return;								
				}else if(SUB_MTL_TP_HIDDEN2 == "S31" || SUB_MTL_TP_HIDDEN2 == "S32" || SUB_MTL_TP_HIDDEN2 == "S35" || SUB_MTL_TP_HIDDEN2 == "S37" || SUB_MTL_TP_HIDDEN2 == "ZZZ"){
					
					//도료원단위계산식
					var nv2 = 0, unt_gra2 = 0, slv_gra2 = 0, pnt_unt2 = 0;
                    nv2 = gridObj.cellById(rId,gridObj.getColIndexById("NV")).getValue();
                    unt_gra2 = gridObj.cellById(rId,gridObj.getColIndexById("PNT_GRA")).getValue();
                    slv_gra2 = gridObj.cellById(rId,gridObj.getColIndexById("SLV_GRA")).getValue();			
				
					if(nv2 == "0" || unt_gra2 == "0" || slv_gra2 == "0" ){
					   items['C106000050_Grid_2'].setCellValue(rId, gridObj.getColIndexById("PNT_UNT"), "");          
					}else if(isNull(nv2) || isNull(unt_gra2) || isNull(slv_gra2)){			
					   items['C106000050_Grid_2'].setCellValue(rId, gridObj.getColIndexById("PNT_UNT"), "");          
					}else{	           
                       pnt_unt2 = (parseFloat(unt_gra2)*100)/(100-((100-parseFloat(nv2))*(parseFloat(unt_gra2)/parseFloat(slv_gra2))));	 
					   items['C106000050_Grid_2'].setCellValue(rId, gridObj.getColIndexById("PNT_UNT"), pnt_unt2.toFixed(2));   
					}		
				}
			}
		}
	}
   return true;
}


function afterProGressOff(){
	uiCommon.progressOff(parent);
	return true;
}
/**
 * 엔터키를 사용한 그리드 포커스 이동
 * @param {gridObj}	grid object
 * @param {id} 현재 선택된 row의 id
 * @param {ind} 현재 선택된 cell의 id
 */
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
function focusMove(id,ind){
	var gridObj = items['C106000050_Grid_1'].getDhxGrid();
	//(그리드객체,rowid,cellid);
	chkfocusInd(gridObj,id,ind);
}

function excelExport(eventName,formDivObj,referenceItem){
	var findUrl = parameters13(formDivObj,eventName, 'excelExportC106000050.do',columnList);
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

//cell 값 입력시 validation check
function chkValidation(stage,id,index,new_value,old_value) {
	var gridObj = items['C106000050_Grid_1'].getDhxGrid();
    var RSN_TP ="" , SUB_MTL_TP="" ,RSN_TP1="";
    /* cell 값 입력시 validation check 해제 (2015.07.20 이상현기사 요청)
	if(stage==2){
		if(index == gridObj.getColIndexById('RSN_TP')){
			SUB_MTL_TP = gridObj.cellById(gridObj.getSelectedRowId(),3).getValue();
			RSN_TP = gridObj.cellById(gridObj.getSelectedRowId(),5).getValue();
			RSN_TP1 = RSN_TP.substring(0,1);
			 
			if(SUB_MTL_TP == "S31"){
				if(RSN_TP1 == "P" || RSN_TP1 == "T" || RSN_TP1 == "I" || RSN_TP1 == "C"){
					dhtmlx.alert('PCM도료에 해당되는 수지가 아닙니다!');
			    	return;
				}
			}else if(SUB_MTL_TP == "S32"){
				if(RSN_TP1 != "P"){
					dhtmlx.alert('Primer에 해당되는 수지가 아닙니다!');
			    	return;
				}
			}else if(SUB_MTL_TP == "S33"){
				if(RSN_TP1 != "T"){
					dhtmlx.alert('Thinner에 해당되는 수지가 아닙니다!');
			    	return;
				}
			}else if(SUB_MTL_TP == "S34"){	
				if(RSN_TP1 != "I"){
					dhtmlx.alert('Ink에 해당되는 수지가 아닙니다!');
			    	return;
				}				
			}else if(SUB_MTL_TP == "S35"){					
				if(RSN_TP1 != "C" && RSN_TP1 != "V"){
					dhtmlx.alert('Clear에 해당되는 수지가 아닙니다!');
			    	return;
				}				
			}
		}
		return true;
	}
    */
	return true; 
}

//칼라업체 사용여부 변경 시, 수정여부 M 세팅처리 , 전송한적이 없으면 M세팅 안함
function chkVal(rId,cInd,state) {
	var gridObj  = items['C106000050_Grid_2'].getDhxGrid();
	var gridObj1 = items["C106000050_Grid_1"].getDhxGrid();
    var USE_YN_BAK = "" , state_bak="";
    
    USE_YN_BAK = gridObj.cellById(rId, gridObj.getColIndexById("USE_YN_BAK")).getValue();
    var ERP_SND_DH = getGridCellData(gridObj1,gridObj1.getSelectedRowId(),"ERP_SND_DH");
    if(state){
    	state_bak = "1";
    }else{
    	state_bak = "0";
    }
    
    if(cInd == 0 && ERP_SND_DH != "" ) {
		if(USE_YN_BAK != state_bak){
			items['C106000050_Grid_2'].setCellValue(rId, gridObj.getColIndexById("MOD_YN_BAK"), "M");
		}else{
			items['C106000050_Grid_2'].setCellValue(rId, gridObj.getColIndexById("MOD_YN_BAK"), "");
		}
	}
	return true; 
}
//물성정보 저장 사유입력 Poup호출
function C10_linkC106000050pop01(gridObj) {
	popCfmRea = "";

	var pageNM = "";
	var pageId = "";

	if( gridObj == "grid1") {
		pageNM = "칼라부재료 수정 사유";
		pageId = "C106000050pop05.jsp";
	} else if( gridObj == "grid2") {
		pageNM = "칼라부재료 업체 저장 사유";
		pageId = "C106000050pop01.jsp";
	}

	winObj = new ui.window("popup",pageNM,"0","0","349","174",pageId);
	winObj.setButtonDisable("park,minmax1");

	winObj.getDhxWindow().attachEvent("onClose", function(win){
		this.hide();
		if( popCfmRea==null || popCfmRea.length==0 || C10_trim(popCfmRea)=="" ) {
			popCompleteYN = "N";
		} else {
			if( gridObj == "grid1") {
				save('save','C106000050_Form_1','C106000050_Grid_1');	
			} else if( gridObj == "grid2") {			
				save1('save1','C106000050_Form_3','C106000050_Grid_2');
			}			
		}
		return true;
	});
}
//칼라부재료업체 정보 수정이력 조회 Popup을 호출한다.
function C10_linkC106000050pop02() {
	if(items['C106000050_Grid_2'].getRowSelectedId()){
		var g2_selectedId = items['C106000050_Grid_2'].getSelectedRowId();
  	    var g2_clrcd       = items['C106000050_Grid_2'].getCellValue(g2_selectedId,1);
		var g2_pntcmpcd = items['C106000050_Grid_2'].getCellValue(g2_selectedId,2);

		winObj = new ui.window("popup","칼라부재료업체 정보 수정이력","0","0","718","400","c106000050pop02.do?clr_cd="+g2_clrcd+"&pnt_cmp_cd="+g2_pntcmpcd);
		winObj.setButtonDisable("park,minmax1");
	} else {
		alert("칼라부재료업체정보에 선택된 행이 없습니다."); 
		return;
	}
}
//칼라코드 정보 수정이력 조회 Popup을 호출한다.
function C10_linkC106000050pop04() {
	if(items['C106000050_Grid_1'].getRowSelectedId()){
		var g1_selectedId = items['C106000050_Grid_1'].getSelectedRowId();
  	    var g1_clrcd = items['C106000050_Grid_1'].getCellValue(g1_selectedId,1);

		winObj = new ui.window("popup","칼라업체 정보 수정이력","0","0","900","400","C106000050pop04.jsp?clr_cd="+g1_clrcd);
		winObj.setButtonDisable("park,minmax1");
	} else {
		alert("칼라코드 정보에 선택된 행이 없습니다."); 
		return;
	}
}
//]]>
</script>
</head>
<body>
<!-- <div id="C106000050_Form_1" style="position:absolute;height:61px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000050_Menu_1" style="position:absolute;height:26px;width:300px;left:1px;top:61px;">
</div>
<div id="C106000050_Grid_1" style="position:absolute;height:283px;width:977px;left:1px;top:88px;">
</div>
<div id="C106000050_Menu_2" style="position:absolute;height:25px;width:243px;left:1px;top:378px;">
</div>
<div id="C106000050_Form_3" style="position:absolute;height:25px;width:237px;left:735px;top:373px;">
</div>
<div id="C106000050_Grid_2" style="position:absolute;height:156px;width:977px;left:1px;top:405px;">
</div>
<div id="messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div> -->
</body>
</html>
<script>
//<![CDATA[
ui.initializeDHTMLX();
items["C106000050_Grid_1"].rowSelected(deteilFind); //rowDblClicked
var onXleForm = items["C106000050_Form_1"].onXLEEvent(onFormLoadFunction);
var onXleGrid = items["C106000050_Grid_1"].onXLEEvent(onGrid1LoadFunction);
var onXleGrid2 = items["C106000050_Grid_2"].onXLEEvent(onGrid2LoadFunction);
items["C106000050_Grid_1"].onEditCellEvent(onEditCellEvent);
items["C106000050_Grid_2"].onEditCellEvent(onEditCellEvent2);
//items["C106000050_Grid_1"].onCheckboxEvent(onCheckboxEvent); 
items['C106000050_Menu_1'].setBackgroundColor("#FFFFFF");
items['C106000050_Menu_2'].setBackgroundColor("#FFFFFF");
//items['C106000050_Form_3'].setBackgroundColor("#FFFFFF");
items['C106000050_Grid_1'].getDhxGrid().attachEvent("onEnter", focusMove); //Edit Grid Enter Move
items['C106000050_Grid_1'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent);
items['C106000050_Grid_2'].onAfterUpdateFinishEvent(onGridAfterUpdateFinishEvent2);
// 입력값 validation체크
items['C106000050_Grid_1'].getDhxGrid().attachEvent("onEditCell",chkValidation);
items['C106000050_Grid_2'].getDhxGrid().attachEvent("onCheckbox",chkVal);
//]]>
</script>