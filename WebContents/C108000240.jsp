<!DOCTYPE html>
<%--
 * PROGRAM NAME      :  C108000240.jsp
 * VERSION           :  1.0
 * DESCRIPTION       :  칼라 개발 관리
 * DESIGNER NAME     :  SJS                             
 * DEVELOPER NAME    :  SJS
 * CREATE DATE       :  2026.01.13
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2025.04.01     V1.0    	SJS	 		최초작성 
--%>
<%@page import="com.posdata.glue.web.security.PosSecurityConstants"%>
<%@page import="com.posdata.glue.web.security.PosUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%
	PosUser	user		= (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String		userNo	= "";
	String		userName= "";
	if(user != null) {
		userNo 	= (String)user.getUserInfo("USER_NO");
		userName= (String)user.getUserInfo("USER_NAME");
	}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>칼라 개발 관리</title>
	<script src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js" type="text/javascript"></script>
	<script src="./js/c10.ui.js" type="text/javascript"></script>
	<script type="text/javascript">

		var items = [];  //public dhtmlx component array
		var Form_1 = {"itemType":"form","renderTo":"C108000240_Form_1","xml":"./header/kr/C108000240/C108000240_Form_1.xml","version":"1","url":"gridC10Data.do","referenceItem":"C108000240_Grid_1","service":"C108000240-service","actionType":"find","security":"true"};
		var Menu_1 = {"itemType":"menu","renderTo":"C108000240_Menu_1","xml":"./header/kr/C108000240/C108000240_Menu_1.xml","version":"1","iconImgs":"./dhtmlx/codebase/imgs/","referenceItem":"C108000240_Grid_1","service":"C108000240-service"};
		var Grid_1 = {"itemType":"grid","renderTo":"C108000240_Grid_1","xml":"./header/kr/C108000240/C108000240_Grid_1.xml","version":"1","rowCnt":"18","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","referenceItem":"C108000240_Form_1","service":"C108000240-service","actionType":"save"};
		var initLayout =
				{
					"programId": "C108000240",
					"itemType": "layout",
					"messageBox": true,
					"dirType": "row",
					"splitter": false,
					"childSize": "70,30,*",
					"components":
							[
								Form_1,
								Menu_1,
								Grid_1
							]
				};
		
		

		
// 		Grid_1.header = "의뢰자";
// 		Grid_1.setHeader("의뢰자,#cspan,#cspan,#cspan,#cspan,#cspan,시험조");
// 		Grid_1.attachHeader("TST_ANL_REG_NO,TST_ANL_REQ_ID,TST_NM,TST_CONTENT,TST_LMT_DD,TST_AGREE,TST_ANL_PRG_CD");
		
		var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
		var formId = 'C108000240_Form_1';
		var gridId = 'C108000240_Grid_1';
		var userNo = parent.userNoFromPortal;
		var devComboVal = [["%", "전체"],["1", "개발접수"], ["2", "분석/개발"],["3", "시편승인"],["4", "사양승인"],["5", "BOM등록"],["6", "개발완료대기"],["7", "개발완료"],["8", "개발중단"]];		
				
		
		
		//form find button item event function (requred)
		function find(eventName,formDivObj,referenceItem){
			var DEV_REQ_DD_START 	= items['C108000240_Form_1'].getItemValue("DEV_REQ_DD_START");
			var DEV_REQ_DD_END 	= items['C108000240_Form_1'].getItemValue("DEV_REQ_DD_END");
			if(DEV_REQ_DD_START > DEV_REQ_DD_END){
				dhtmlx.alert('의뢰일자를 잘못 입력하였습니다!');
				return;
			}
			// 조회 시 hidden 필드의 raw code를 표시 필드에 세팅 → 조회 → 코드명 복원
			// 표시 필드가 비어있으면 hidden도 초기화
			var _codeMap = {CUS_CD:'H_CUS_CD', FNL_CUS_CD:'H_FNL_CUS_CD', DEV_CHR_DEPT:'H_DEV_CHR_DEPT', APRV_DEPT_CD:'H_APRV_DEPT_CD'};
			var _savedNms = {};
			for (var _f in _codeMap) {
				var _dispVal = items['C108000240_Form_1'].getItemValue(_f) || "";
				_savedNms[_f] = _dispVal;
				if (!_dispVal.trim()) {
					items['C108000240_Form_1'].setItemValue(_codeMap[_f], "");
					items['C108000240_Form_1'].setItemValue(_f, "");
				} else {
					var _hv = items['C108000240_Form_1'].getItemValue(_codeMap[_f]) || "";
					items['C108000240_Form_1'].setItemValue(_f, _hv);
				}
			}
			var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
			items[referenceItem].loadData(findUrl, function() {
				_highlightRejected();
			});
			// 코드명 복원
			for (var _f2 in _codeMap) {
				items['C108000240_Form_1'].setItemValue(_f2, _savedNms[_f2]);
			}
			uiCommon.progressOff(parent);
		}
		function save(eventName,formDivObj,referenceItem){
			var gridObj = items['C108000240_Grid_1'].getDhxGrid();
			var grid_cnt = gridObj.getRowsNum();
			var row_status = "", err_cnt = 0, chgCnt = 0;
// 			var req_no = "";

			var rowId = items['C108000240_Grid_1'].getRowSelectedId();
			gridObj.selectRow(gridObj.getRowIndex(rowId));

			for(var i=0; i< grid_cnt; i++){
				row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
				
// 				req_no = getGridCellData(gridObj,gridObj.getRowId(i),"TST_ANL_REG_NO");
				items['C108000240_Grid_1'].setCellValue(gridObj.getRowId(i), gridObj.getColIndexById("TST_NOTE"), gridObj.cellByIndex(i, gridObj.getColIndexById("TST_NOTE")).getValue());
				
				if(row_status !== ""){
					chgCnt++;
				}
				if(err_cnt > 0) break;
			}
			if(err_cnt==0){
				if(chgCnt == 0) {
					dhtmlx.alert("변경된 데이터가 없습니다.");
					return;
				}else{
					dhtmlx.confirm({
						ok:"확인", cancel:"취소",
						text:" 비고를 저장하시겠습니까? ",
						callback:function(val){
							if(val){
								
// 								items['C108000240_Grid_1'].sendGrid('C108000240_Grid_1','save');
								items[referenceItem].sendGrid(referenceItem,eventName);
								return;
							}
						}
					});
				}
			}
		}
		
		
		
		
		function deleteReq(){
		    var grid    = items['C108000240_Grid_1'];
		    var gridObj = grid.getDhxGrid();

		    var rowId = grid.getRowSelectedId();

		    if(!rowId){
		        dhtmlx.alert("삭제할 행을 선택하세요.");
		        return;
		    }

		    dhtmlx.confirm({
		        ok:"확인", cancel:"취소",
		        text:" 의뢰를 삭제하시겠습니까? ",
		        callback:function(val){
		            if(val){

		            	grid.removeRow();
// 		                gridObj.dataProcessor.setUpdated(rowId, true, "deleted");

		                // 서버로 삭제 요청
		                grid.sendGrid('C108000240_Grid_1', 'deleteReq');		                
		                
		                
		            }
		        }
		    });
		}
		
		
		
// 		function deleteReq(){
// 			var gridObj = items['C108000240_Grid_1'].getDhxGrid();
// 			var grid_cnt = gridObj.getRowsNum();
// 			var row_status = "", err_cnt = 0, chgCnt = 0;
// // 			var req_no = "";

// 			var rowId = items['C108000240_Grid_1'].getRowSelectedId();
// 			gridObj.selectRow(gridObj.getRowIndex(rowId));

// 			for(var i=0; i< grid_cnt; i++){
// 				row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");
				
// // 				req_no = getGridCellData(gridObj,gridObj.getRowId(i),"TST_ANL_REG_NO");
// // 				items['C108000240_Grid_1'].setCellValue(gridObj.getRowId(i), gridObj.getColIndexById("TST_NOTE"), gridObj.cellByIndex(i, gridObj.getColIndexById("TST_NOTE")).getValue());
				
// 				if(row_status !== ""){
// 					chgCnt++;
// 				}
// 				if(err_cnt > 0) break;
// 			}
// 			if(err_cnt==0){
// 				if(chgCnt == 0) {
// 					dhtmlx.alert("삭제할 행을 선택하세요.");
// 					return;
// 				}else{
// 					dhtmlx.confirm({
// 						ok:"확인", cancel:"취소",
// 						text:" 의뢰를 삭제하시겠습니까? ",
// 						callback:function(val){
// 							if(val){
								
// 								items['C108000240_Grid_1'].sendGrid('C108000240_Grid_1','deleteReq');
// // 								items[referenceItem].sendGrid(referenceItem,eventName);
// 								return;
// 							}
// 						}
// 					});
// 				}
// 			}
// 		}
		
		
		//menu refresh event function
		function refresh(referenceItem){ //grid selection clear event
			items[referenceItem].clearDataProcess();
			var findUrl = uiCommon.parameters('C108000240_Form_1',referenceItem,'find');
			items[referenceItem].loadData(findUrl);
		}

		//menu new row event function
		function add(referenceItem){
			items[referenceItem].addRow();
		}
		//menu remove event function
		function remove(referenceItem){
			
			var grid = items['C108000240_Grid_1'];
			var gridObj = grid.getDhxGrid();
			
			var userId = grid.getDhxGrid().cells(grid.getSelectedRowId(),gridObj.getColIndexById("TST_ANL_REQ_USER_ID")).getValue();
			if(userId != "<%=userNo%>"){
				dhtmlx.alert("의뢰 삭제는 의뢰자만 할 수 있습니다.");
				return;
			}
			
			var finishYn = grid.getDhxGrid().cells(grid.getSelectedRowId(),gridObj.getColIndexById("TST_SMS_SND_DH")).getValue();
			if(finishYn != null && finishYn != ""){
				dhtmlx.alert("완료된 의뢰는 삭제할 수 없습니다.");
				return;
			}
// 			var TST_ANL_PRG_CD = grid.getDhxGrid().cells(grid.getSelectedRowId(),gridObj.getColIndexById("TST_ANL_PRG_CD")).getValue(); 
// 				grid.getDhxGrid().cells(grid.getSelectedRowId(),4).getValue();
// 			if(TST_ANL_PRG_CD != '의뢰접수'){
// 				dhtmlx.alert("의뢰 삭제는 접수 단계에서만 가능합니다.");
// 				return;
// 			}

// 			//공급업체가 로그인하면 '삭제'권한제어
// 			var param = "ServiceName=C108000240-service&userChk=1&PNT_CMP_CD="+userNo+"&column-info=SMTL_SLP_CD,SMTL_SLP_NM";
// 			var xmlObj = uiCommon.ajaxLoadData('m20AjaxData.do',param);
// 			var cells = xmlObj.getElementsByTagName("cell");
// 			if(cells.length == 0){
// 				if(items['C108000240_Grid_1'].getSelectedRowId() == "" || items['C108000240_Grid_1'].getSelectedRowId() == null){
// 					dhtmlx.alert("삭제대상을 선택해 주세요");
// 					return;
// 				}
// 			}else{
// 				dhtmlx.alert("권한이 없습니다");
// 				return;
// 			}

// 			items[referenceItem].removeRow();
			deleteReq();
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
			uiCommon.message("messagebox",referenceItem.getUserData("","appMsg"));
			return true;
		}
		function onFormLoadFunction(formDivObj){
			var formObj = items['C108000240_Form_1'].getDhxForm();
			
			items['C108000240_Form_1'].setItemValue("DEV_REQ_DD_END",uiCommon.getCurrentDate());

			var DEV_DD_END_TMP = items['C108000240_Form_1'].getItemValue("DEV_REQ_DD_END");
			var DEV_DD_END = new Date(DEV_DD_END_TMP.substring(5,7)+"/"+DEV_DD_END_TMP.substring(8,10)+"/"+DEV_DD_END_TMP.substring(0,4));
			var DEV_DD_STR_DT = new Date(DEV_DD_END.getFullYear(), DEV_DD_END.getMonth() - 2, DEV_DD_END.getDate());
			var _m = DEV_DD_STR_DT.getMonth() + 1;
			var _d = DEV_DD_STR_DT.getDate();
			var DEV_DD_STR = DEV_DD_STR_DT.getFullYear() + "-" + (_m < 10 ? "0" + _m : _m) + "-" + (_d < 10 ? "0" + _d : _d);
			items['C108000240_Form_1'].setItemValue("DEV_REQ_DD_START",DEV_DD_STR);

			//작업일자 달력 설정
			items['C108000240_Form_1'].getItem("DEV_REQ_DD_START").setWeekStartDay(7);
			items['C108000240_Form_1'].getItem("DEV_REQ_DD_END").setWeekStartDay(7);
			items["C108000240_Form_1"].getDhxForm().detachEvent(onXleForm);
			
	        // 개발진도 콤보
		    var devCombo = items['C108000240_Form_1'].getItem('DEV_PRG_CD'); 
		    	devCombo.addOption(devComboVal);    
		    	devCombo.enableOptionAutoPositioning(true);
		    	devCombo.readonly(true,true);
		    	devCombo.selectOption(0,true,true);	 		    	
		    	devCombo.setOptionHeight(60);		       
		        		

			var comboList = items['C108000240_Form_1'].getMasterCombos();
			
			// 제품군
			ui.combo.master(comboList['PRD_NM_CD'],'SJ0001','PRD_NM_CD','totalValue=%,orderBy=sequence',function(){
				comboList['PRD_NM_CD'].selectOption(0,true,true);
				comboList['PRD_NM_CD'].readonly(true);
				comboList['PRD_NM_CD'].setOptionHeight(100);
			});
			
			// 도료타입
			ui.combo.master(comboList['RSN_TP'],'SZ0000','RSN_TP','totalValue=&,orderBy=value',function(){
				comboList['RSN_TP'].selectOption(0,true,true);
				comboList['RSN_TP'].readonly(true);
				comboList['RSN_TP'].setOptionHeight(100);
			});
			

			
			
			// 코팅타입
			ui.combo.master(comboList['COT_TP'],'AP0000','COT_TP','totalValue=%,orderBy=sequence',function(){
				comboList['COT_TP'].selectOption(0,true,true);
				comboList['COT_TP'].readonly(true);
				comboList['COT_TP'].setOptionHeight(100);
			});
			
			//헤더 변경
// 			var gridObj1 = items['C108000240_Grid_1'].getDhxGrid();
// 			gridObj1.setHeader("의뢰자,#cspan,#cspan,#cspan,#cspan,#cspan,시험조");
// 			gridObj1.attachHeader("TST_ANL_REG_NO,TST_ANL_REQ_ID,TST_NM,TST_CONTENT,TST_LMT_DD,TST_AGREE,TST_ANL_PRG_CD");
			

			//공급업체코드로 로그인 시, 업체검색 히든처리
// 			var param = "ServiceName=C108000240-service&userChk=1&PNT_CMP_CD="+userNo+"&column-info=SMTL_SLP_CD,SMTL_SLP_NM";
// 			var xmlObj = uiCommon.ajaxLoadData('m20AjaxData.do',param);
// 			var cells = xmlObj.getElementsByTagName("cell");
// 			if(cells.length == 0)	formObj.showItem('PNT_CMP_CD');
// 			else{
// 				formObj.setItemValue('PNT_CMP_CD', userNo);
// 				formObj.hideItem('PNT_CMP_CD');
// 			}
		}

		function onGridLoadFunction(stage,rId,cInd,nValue,oValue){

			var grid = items['C108000240_Grid_1']; 
			var gridObj = items['C108000240_Grid_1'].getDhxGrid();
			
		}
		//의뢰
		function tstReq(){
			var grid = items['C108000240_Grid_1'];
			var DEV_ID = "";
			if(!isNull(grid.getSelectedRowId())){
				DEV_ID = grid.getDhxGrid().cells(grid.getSelectedRowId(),1).getValue().replace(/-/g,'');
			}

			//공급업체가 로그인하면 권한제어
// 			var param = "ServiceName=C108000240-service&userChk=1&PNT_CMP_CD="+userNo+"&column-info=SMTL_SLP_CD,SMTL_SLP_NM";
// 			var xmlObj = uiCommon.ajaxLoadData('m20AjaxData.do',param);
// 			var cells = xmlObj.getElementsByTagName("cell");
// 			if(cells.length == 0){
			
				winObj = new ui.window("popup","칼라 신규 개발 등록","0","0","1020","1200","C108000240pop01.jsp?DEV_ID="+DEV_ID);
				winObj.setButtonDisable("park,minmax1");
				winObj.setModal();

				winObj.getDhxWindow().attachEvent("onClose", function(win){
					this.hide();
					return true;
				});
// 			}else{
// 				dhtmlx.alert("권한이 없습니다");
// 				return;
// 			}
		}
		//시험분석의뢰 완료 알림 전송
		function sendSms(){
			var grid = items['C108000240_Grid_1'];
			var TST_ANL_REQ_NO = "";
			
			var rowId 	= items['C108000240_Grid_1'].getRowSelectedId();
// 			var COIL_ID	= getGridCellData(gridObj,rowId,"COIL_ID");

			if(!isNull(grid.getSelectedRowId())){
				TST_ANL_REQ_NO = grid.getDhxGrid().cells(grid.getSelectedRowId(),0).getValue();
// 				TST_ANL_PRG_CD = grid.getDhxGrid().cells(grid.getSelectedRowId(),4).getValue();
			}

			if(TST_ANL_REQ_NO == "" || TST_ANL_REQ_NO == null){
				dhtmlx.alert('의뢰번호를 선택하세요');
				return;
			}
			
// 			console.log("TST_ANL_PRG_CD : "+TST_ANL_PRG_CD);
			
// 			if(TST_ANL_PRG_CD != "합의완료"){
// 				dhtmlx.alert('합의 완료된 의뢰만 완료 전송 가능합니다.');
// 				return;
// 			}						
						
			chkReqEmpInfo(grid.getSelectedRowId(),grid.getDhxGrid().cells(grid.getSelectedRowId(),grid.getDhxGrid().getColIndexById("TST_ANL_REQ_USER_ID")).getValue());					
			
// 			row_status = grid.getDhxGrid().getUserData(grid.getSelectedRowId(),"!nativeeditor_status");
			grid.setUpdated(grid.getSelectedRowId(),true,"updated"); 
			
			dhtmlx.confirm({
				ok:"확인", cancel:"취소",
				text:" 해당 의뢰 완료 전송하시겠습니까? ",
				callback:function(val){
					if(val){
						grid.sendGrid('C108000240_Grid_1',"sendSms");
						return;
					}
				}
			});
		}
		function Grid_doLink(val,rowIdx,cellIdx){
			var gridObj 	= items['C108000240_Grid_1'].getDhxGrid();
			var grid		= items['C108000240_Grid_1'];
			var param = "";
			var link_url = "";
			var DEV_ID = "";
			
			gridObj.selectRow(rowIdx, false, true);
		    
			DEV_ID = gridObj.cells(rowIdx, 0).getValue();
			

		    
// 			gridObj.attachEvent("onRowSelect", function(rId, cInd){
// 			    console.log("onRowSelect 발생 : " + rId + " - " + cInd);
// 			    console.log("의뢰번호 : "+grid.getDhxGrid().cells(grid.getSelectedRowId(),0).getValue());
// 			    TST_ANL_REQ_NO = grid.getDhxGrid().cells(grid.getSelectedRowId(),0).getValue();
// 				console.log("TST_ANL_REQ_NO1 : "+TST_ANL_REQ_NO);			    
// // 			    gridObj.selectRowById(rId, false, true);
// 			    return true;
// 			});
			
			
// 			if(!isNull(grid.getSelectedRowId())){
// 				TST_ANL_REQ_NO = gridObj.cells(grid.getSelectedRowId(),0).getValue();
// 			}
			
// 			var prg_cd = gridObj.cells(rowIdx,gridObj.getColIndexById("TST_ANL_PRG_CD")).getValue();
			
// 			if(prg_cd != '합의완료'){
// 				dhtmlx.alert('최종합의 완료 후 입력 가능합니다!');
// 				return;
// 			}
			
			
// 			var DETAIL_TITLE = gridObj.cells(rowIdx,gridObj.getColIndexById("TST1")).getValue();
// 			var TST_ANL_REQ_NO	= gridObj.cells(rowIdx,gridObj.getColIndexById("TST_ANL_REQ_NO")).getValue();

				
// 		 			if(cellIdx == gridObj.getColIndexById('TST1')){					
// 						link_url = "C108000240pop02.jsp?TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
// 						winObj = new ui.window("popup02","기계적물성","0","0","639","373",link_url);		
						
// 		 			}else if(cellIdx == gridObj.getColIndexById('TST2')){
// 						link_url = "C108000240pop03.jsp?TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
// 						winObj = new ui.window("popup03","도금부착량","0","0","835","373",link_url);
// 		 			}else if(cellIdx == gridObj.getColIndexById('TST3')){
// 						link_url = "C108000240pop04.jsp?TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
// 						winObj = new ui.window("popup04","도금두께","0","0","537","217",link_url);						
// 		 			}else if(cellIdx == gridObj.getColIndexById('TST4')){
// 						link_url = "C108000240pop05.jsp?TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
// 						winObj = new ui.window("popup05","성분시험","0","0","1336","217",link_url);						
// 		 			}else if(cellIdx == gridObj.getColIndexById('TST5')){
// 						link_url = "M202010300";
// 						parent.newRemoveOpenTab(link_url,"");						
// 		 			}else if(cellIdx == gridObj.getColIndexById('TST6')){
// 						link_url = "C108000240pop06.jsp?TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
// 						winObj = new ui.window("popup06","크롬농도분석","0","0","534","196",link_url);	
// 		 			}else if(cellIdx == gridObj.getColIndexById('TST8')){
// 						link_url = "C108000240pop08.jsp?TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
// 						winObj = new ui.window("popup08","기타시험","0","0","537","194",link_url);	
// 		 			}else{
// 						link_url = "C108000240pop04.jsp?TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
// 						winObj = new ui.window("popup04","도금두께","0","0","537","217",link_url);						
// 		 			}
		 			
		}
		function onAfterUpdateFinishEvent(){
			find('find','C108000240_Form_1','C108000240_Grid_1');
			return true;
		}
		
		//CUPPINGTEST, 첨부파일 등록을 위한 POP-UP
// 		function doImgPopUp(rowIdx, reqNo, tstSeq, prg_cd){
		function doImgPopUp(rowIdx, reqNo, tstSeq){
			var gridObj = items['C108000240_Grid_1'].getDhxGrid();
			var rowId = gridObj.getRowIndex(rowIdx);			
			var TST_ANL_REQ_NO = reqNo;
			
// 			var prg_cd = gridObj.cells(rowId,gridObj.getColIndexById("TST_ANL_PRG_CD")).getValue();
			
// 			console.log("prg_cd : "+prg_cd);
// 			if(prg_cd != '합의완료'){
// 				dhtmlx.alert('최종합의 완료 후 첨부 가능합니다!');
// 				return;
// 			}


			var md_url = "";
			var pop_nm = "";
			if(tstSeq == '7'){
				md_url = "C108000240pop07.jsp?rowId="+rowId;
				pop_nm = "CUPPING TEST";
			}else{
				md_url = "C108000240pop09.jsp?rowId="+rowId;
				pop_nm = "첨부파일";
			}
				md_url += "&TST_ANL_REQ_NO="+TST_ANL_REQ_NO;
				md_url += "&TST_SEQ="+tstSeq;
				md_url += "&parent_item=C108000240_Grid_1";
		
			var cusWinObj = new ui.window("cusImgRegPopWin",pop_nm,"0","0","465","405",md_url);
			cusWinObj.setButtonDisable("park,minmax1");
			cusWinObj.setModal();
		}	
		
		
		function chkReqEmpInfo(rowId,userVal){
			
			var gridObj = items['C108000240_Grid_1'].getDhxGrid();
			
// 			console.log("rowId : "+rowId);
// 			console.log("userVal : "+userVal);
			
			var param = "ServiceName=C108000240pop01-service";
			param += "&findReqEmpInfo=1";
			param += "&TST_ANL_REQ_ID="+userVal;
			param += "&column-info=HND_PHN_NO,EMAIL,USER_NO,USER_NAME";
			var xmlObj = uiCommon.ajaxLoadData('m20AjaxData.do', param);
			var cells  = xmlObj.getElementsByTagName("cell");

			if(cells.length > 0){
				
// 				console.log("cells.item(0).firstChild.nodeValue : "+cells.item(0).firstChild.nodeValue);
// 				console.log("cells.item(3).firstChild.nodeValue : "+cells.item(3).firstChild.nodeValue);
				
	             gridObj.cells(rowId, gridObj.getColIndexById("PHN_NO")).setValue(cells.item(0).firstChild.nodeValue);
	             gridObj.cells(rowId, gridObj.getColIndexById("RECEIVE_USER_NAME")).setValue(cells.item(3).firstChild.nodeValue);
	             
	             
// 			    items['C108000240_Grid_1'].setItemValue("PHN_NO", cells.item(0).firstChild.nodeValue);
// 			    items['C108000240_Grid_1'].setItemValue("EMAIL", cells.item(1).firstChild.nodeValue);
// 			    items['C108000240_Grid_1'].setItemValue("RECEIVE_USER_NAME", cells.item(3).firstChild.nodeValue);        	 
			}else{
				 dhtmlx.alert("의뢰자의 휴대폰번호가 없습니다.");
				 return
			}
			
		}		
		
		function _highlightRejected() {
			try {
				var gridObj = items['C108000240_Grid_1'].getDhxGrid();
				var prgIdx = gridObj.getColIndexById("DEV_PRG_CD");
				for (var r = 0; r < gridObj.getRowsNum(); r++) {
					var rowId = gridObj.getRowId(r);
					var prgVal = gridObj.cells(rowId, prgIdx).getValue();
					if (prgVal && prgVal.indexOf('(반려)') > -1) {
						gridObj.setRowTextStyle(rowId, "color:#cc0000;");
					}
				}
			} catch(e) {}
		}

		function clearGridSelection() {
		    var gridObj = items['C108000240_Grid_1'].getDhxGrid();
		    gridObj.clearSelection();
		    tstReq();
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
		
	    function serchIcon_DEV_CHR_DEPT(name,val){
	    	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('DEPT_CD','SZ0000','DEV_CHR_DEPT','부서 검색','C108000240_Form_1');\">";
	    }

	    function serchIcon_APRV_DEPT_CD(name,val){
	    	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('DEPT_CD','SZ0000','APRV_DEPT_CD','처리부서 검색','C108000240_Form_1');\">";
	    }

	    function serchIcon_CUS_CD(name,val){
	    	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('CUS_CD','SZ0000','CUS_CD','수요가 검색','C108000240_Form_1');\">";
	    }

	    function serchIcon_FNL_CUS_CD(name,val){
	    	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('CUS_CD','SZ0000','FNL_CUS_CD','최종고객사 검색','C108000240_Form_1');\">";
	    }

	    // ===== 범용 마스터코드 검색 커스텀 팝업 (대소문자 무시) =====
	    var _codePopupModal = null;
	    var _codeCache = {};
	    var _codeDebounce = null;
	    var _LARGE_CODE_TYPES = {'CUS_CD':true}; // 대량 데이터 코드 타입
	    var _LARGE_MAX_ROWS = 100;
	    var _LARGE_MIN_CHARS = 2;
	    // 부서 코드 고정 정렬 순서 + 주요 부서 필터
	    var _DEPT_ORDER = {'50106496':1,'50106497':2,'60000002':3,'50106498':4,'50106524':5,'50106513':6,'50106514':7};
	    var _showAllDept = false;
	    function _sortCodeList(list, cdTp) {
	    	if (cdTp !== 'DEPT_CD') return list;
	    	var sorted = list.slice();
	    	sorted.sort(function(a,b) {
	    		var oa = _DEPT_ORDER[a.cd] || 999;
	    		var ob = _DEPT_ORDER[b.cd] || 999;
	    		if (oa !== ob) return oa - ob;
	    		return a.nm.localeCompare(b.nm);
	    	});
	    	return sorted;
	    }

	    function _closeCodePopup() {
	    	if (_codePopupModal && _codePopupModal.parentNode) _codePopupModal.parentNode.removeChild(_codePopupModal);
	    	_codePopupModal = null;
	    	if (_codeDebounce) { clearTimeout(_codeDebounce); _codeDebounce = null; }
	    }

	    function _loadCodeListAsync(cdTp, categoryGrp, callback) {
	    	var cacheKey = cdTp + '_' + categoryGrp;
	    	if (_codeCache[cacheKey]) { callback(_codeCache[cacheKey]); return; }
	    	dhtmlxAjax.get(master_combo_url + '&category=' + categoryGrp + '&code=' + cdTp + '&orderBy=value', function(resp) {
	    		var list = [];
	    		try {
	    			if (resp && resp.xmlDoc && resp.xmlDoc.responseXML) {
	    				var optNodes = resp.xmlDoc.responseXML.getElementsByTagName("option");
	    				for (var i = 0; i < optNodes.length; i++) {
	    					var cd = optNodes[i].getAttribute("value");
	    					var nm = optNodes[i].firstChild ? optNodes[i].firstChild.nodeValue : "";
	    					if (cd) list.push({cd: cd, nm: nm});
	    				}
	    			}
	    		} catch(e) { console.error("[loadCodeList] parse error:", e); }
	    		list = _sortCodeList(list, cdTp);
	    		_codeCache[cacheKey] = list;
	    		callback(list);
	    	});
	    }

	    function _loadCodeListSync(cdTp, categoryGrp) {
	    	var cacheKey = cdTp + '_' + categoryGrp;
	    	if (_codeCache[cacheKey]) return _codeCache[cacheKey];
	    	try {
	    		var resp = dhtmlxAjax.getSync(master_combo_url + '&category=' + categoryGrp + '&code=' + cdTp + '&orderBy=value');
	    		var list = [];
	    		if (resp && resp.xmlDoc && resp.xmlDoc.responseXML) {
	    			var optNodes = resp.xmlDoc.responseXML.getElementsByTagName("option");
	    			for (var i = 0; i < optNodes.length; i++) {
	    				var cd = optNodes[i].getAttribute("value");
	    				var nm = optNodes[i].firstChild ? optNodes[i].firstChild.nodeValue : "";
	    				if (cd) list.push({cd: cd, nm: nm});
	    			}
	    		}
	    		list = _sortCodeList(list, cdTp);
	    		_codeCache[cacheKey] = list;
	    		return list;
	    	} catch(e) { console.error("[loadCodeList] error:", e); return []; }
	    }

	    function _renderCodeRows(tbody, list, keyword, targetField, formId, isLarge, cdTp) {
	    	tbody.innerHTML = '';
	    	var key = (keyword || '').toUpperCase();
	    	var isDept = (cdTp === 'DEPT_CD');

	    	if (isLarge && key.length < _LARGE_MIN_CHARS) {
	    		tbody.innerHTML = '<tr><td colspan="2" style="padding:10px;text-align:center;color:#999;">' + _LARGE_MIN_CHARS + '글자 이상 입력하세요.</td></tr>';
	    		return;
	    	}

	    	var filtered = [];
	    	for (var i = 0; i < list.length; i++) {
	    		// 부서: 검색어 없고 더보기 아닐 때 주요 부서만
	    		if (isDept && !_showAllDept && !key && !_DEPT_ORDER[list[i].cd]) continue;
	    		if (!key || list[i].cd.toUpperCase().indexOf(key) > -1 || list[i].nm.toUpperCase().indexOf(key) > -1) {
	    			filtered.push(list[i]);
	    			if (isLarge && filtered.length >= _LARGE_MAX_ROWS) break;
	    		}
	    	}
	    	if (filtered.length === 0) {
	    		tbody.innerHTML = '<tr><td colspan="2" style="padding:10px;text-align:center;color:#999;">검색 결과가 없습니다.</td></tr>';
	    		return;
	    	}
	    	var html = '';
	    	for (var j = 0; j < filtered.length; j++) {
	    		html += '<tr data-cd="' + filtered[j].cd + '" data-nm="' + filtered[j].nm.replace(/"/g,'&quot;') + '" style="cursor:pointer;">'
	    		      + '<td style="padding:4px 8px;border-bottom:1px solid #eee;">' + filtered[j].cd + '</td>'
	    		      + '<td style="padding:4px 8px;border-bottom:1px solid #eee;">' + filtered[j].nm + '</td></tr>';
	    	}
	    	if (isLarge && filtered.length >= _LARGE_MAX_ROWS) {
	    		html += '<tr><td colspan="2" style="padding:6px 8px;text-align:center;color:#888;font-size:11px;">최대 ' + _LARGE_MAX_ROWS + '건 표시. 검색어를 더 입력하세요.</td></tr>';
	    	}
	    	// 부서: 더보기 버튼
	    	if (isDept && !_showAllDept && !key) {
	    		html += '<tr data-action="showAll"><td colspan="2" style="padding:6px 8px;text-align:center;cursor:pointer;color:#4A7CBB;font-size:11px;border-top:1px solid #ddd;">▼ 다른부서 더보기</td></tr>';
	    	} else if (isDept && _showAllDept && !key) {
	    		html += '<tr data-action="hideAll"><td colspan="2" style="padding:6px 8px;text-align:center;cursor:pointer;color:#4A7CBB;font-size:11px;border-top:1px solid #ddd;">▲ 주요부서만 보기</td></tr>';
	    	}
	    	tbody.innerHTML = html;

	    	// 이벤트 위임 (개별 row 이벤트 대신 tbody 한 번)
	    	tbody.onclick = function(e) {
	    		var tr = e.target;
	    		while (tr && tr.tagName !== 'TR') tr = tr.parentNode;
	    		if (!tr) return;
	    		// 더보기/접기 클릭
	    		if (tr.getAttribute('data-action') === 'showAll') {
	    			_showAllDept = true;
	    			_renderCodeRows(tbody, list, keyword, targetField, formId, isLarge, cdTp);
	    			return;
	    		}
	    		if (tr.getAttribute('data-action') === 'hideAll') {
	    			_showAllDept = false;
	    			_renderCodeRows(tbody, list, keyword, targetField, formId, isLarge, cdTp);
	    			return;
	    		}
	    		if (!tr.getAttribute('data-cd')) return;
	    		var _cd = tr.getAttribute('data-cd');
	    		var _nm = tr.getAttribute('data-nm');
	    		// 코드명만 표시, hidden에 코드 저장
	    		var _hiddenMap = {CUS_CD:'H_CUS_CD', FNL_CUS_CD:'H_FNL_CUS_CD', DEV_CHR_DEPT:'H_DEV_CHR_DEPT', APRV_DEPT_CD:'H_APRV_DEPT_CD'};
	    		if (_hiddenMap[targetField]) {
	    			items[formId].setItemValue(targetField, _nm);
	    			items[formId].setItemValue(_hiddenMap[targetField], _cd);
	    		} else {
	    			items[formId].setItemValue(targetField, _cd + ' : ' + _nm);
	    		}
	    		_closeCodePopup();
	    	};
	    	tbody.onmouseover = function(e) {
	    		var tr = e.target; while (tr && tr.tagName !== 'TR') tr = tr.parentNode;
	    		if (tr && tr.getAttribute('data-cd')) tr.style.backgroundColor = '#e8f0fe';
	    	};
	    	tbody.onmouseout = function(e) {
	    		var tr = e.target; while (tr && tr.tagName !== 'TR') tr = tr.parentNode;
	    		if (tr && tr.getAttribute('data-cd')) tr.style.backgroundColor = '';
	    	};
	    }

	    function customCodePopup(cdTp, categoryGrp, targetField, title, formId) {
	    	_closeCodePopup();
	    	var isLarge = !!_LARGE_CODE_TYPES[cdTp];

	    	var modal = document.createElement('div');
	    	modal.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.4);z-index:9999;display:flex;align-items:center;justify-content:center;';
	    	modal.innerHTML =
	    		'<div style="background:#fff;width:420px;padding:16px;border:1px solid #93AFBA;box-shadow:3px 3px 10px rgba(0,0,0,0.3);">' +
	    		'<div style="font-weight:bold;margin-bottom:10px;font-size:14px;">' + title + '</div>' +
	    		'<div style="margin-bottom:8px;">' +
	    		'<input type="text" id="_codeSearchInput" placeholder="코드 또는 명칭 입력" style="width:100%;padding:4px 6px;font-size:13px;box-sizing:border-box;" />' +
	    		'</div>' +
	    		'<div style="max-height:300px;overflow-y:auto;border:1px solid #ccc;">' +
	    		'<table style="width:100%;border-collapse:collapse;font-size:12px;">' +
	    		'<thead><tr style="background:#f0f0f0;position:sticky;top:0;">' +
	    		'<th style="padding:4px 8px;border-bottom:1px solid #ccc;text-align:left;">코드</th>' +
	    		'<th style="padding:4px 8px;border-bottom:1px solid #ccc;text-align:left;">명칭</th>' +
	    		'</tr></thead><tbody id="_codeSearchBody"></tbody></table></div>' +
	    		'<div style="text-align:right;margin-top:10px;">' +
	    		'<button id="_codeSearchClose" style="padding:3px 12px;">닫기</button>' +
	    		'</div></div>';
	    	document.body.appendChild(modal);
	    	_codePopupModal = modal;

	    	var tbody = document.getElementById('_codeSearchBody');
	    	var searchInput = document.getElementById('_codeSearchInput');

	    	_showAllDept = false; // 팝업 열 때 초기화

	    	var _doSearch = function(codeList) {
	    		searchInput.onkeyup = function() {
	    			var val = this.value;
	    			if (isLarge) {
	    				if (_codeDebounce) clearTimeout(_codeDebounce);
	    				_codeDebounce = setTimeout(function() {
	    					_renderCodeRows(tbody, codeList, val, targetField, formId, true, cdTp);
	    				}, 300);
	    			} else {
	    				_renderCodeRows(tbody, codeList, val, targetField, formId, false, cdTp);
	    			}
	    		};
	    	};

	    	if (isLarge) {
	    		tbody.innerHTML = '<tr><td colspan="2" style="padding:10px;text-align:center;color:#999;">로딩 중...</td></tr>';
	    		_loadCodeListAsync(cdTp, categoryGrp, function(codeList) {
	    			_renderCodeRows(tbody, codeList, '', targetField, formId, true, cdTp);
	    			_doSearch(codeList);
	    		});
	    	} else {
	    		var codeList = _loadCodeListSync(cdTp, categoryGrp);
	    		_renderCodeRows(tbody, codeList, '', targetField, formId, false, cdTp);
	    		_doSearch(codeList);
	    	}

	    	searchInput.focus();
	    	document.getElementById('_codeSearchClose').onclick = function() { _closeCodePopup(); };
	    	modal.onclick = function(e) { if (e.target === modal) _closeCodePopup(); };
	    }
	    // ===== 범용 마스터코드 검색 커스텀 팝업 끝 =====
	    
	    function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	    	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
	    	winObj.setButtonDisable("park,minmax1");
	    	winObj.setModal();
	    }
	    // popup으로부터 넘겨받은 값 item에 세팅
	    function masterSetValue(code,name,target,formId){
	    	var _hm = {CUS_CD:'H_CUS_CD', FNL_CUS_CD:'H_FNL_CUS_CD', DEV_CHR_DEPT:'H_DEV_CHR_DEPT', APRV_DEPT_CD:'H_APRV_DEPT_CD'};
	    	if (_hm[target]) {
	    		items[formId].setItemValue(target, name);
	    		items[formId].setItemValue(_hm[target], code);
	    	} else {
	    		items[formId].setItemValue(target, code);
	    	}
	    }		
		

	</script>
</head>
<body>
</body>
</html>
<script>

	ui.initializeDHTMLX();
	var onXleForm = items['C108000240_Form_1'].onXLEEvent(onFormLoadFunction);
// 	items['C108000240_Grid_1'].onXLEEvent(onGridLoadFunction);
// 	items['C108000240_Grid_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	items["C108000240_Grid_1"].rowDblClicked(tstReq);
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
	var dataProcessor = items["C108000240_Grid_1"].getDhxDataProcess();
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}

</script>