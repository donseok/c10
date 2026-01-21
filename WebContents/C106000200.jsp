<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<% // String domain=System.getProperty("Mes.Domain"); // 지주사전환 excel_export를 위함 %>
		<html xmlns="http://www.w3.org/1999/xhtml">

		<head>
			<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
			</meta>
			<title>
				디지털프린트 작업지시조회
			</title>
			<script src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js" type="text/javascript">
			</script>
			<script src="./js/c10.ui.js" type="text/javascript"></script>
			</script>
			<style>
				/* 작은 모니터에서 가로 스크롤 생성 */
				html,
				body {
					/* 메뉴가 나와도 절대 줄어들지 않도록 body 자체에 최소 너비 고정 */
					min-width: 2000px !important;
					width: 100% !important;
					height: 100% !important;
					margin: 0 !important;
					padding: 0 !important;
					/* auto 대신 scroll로 항상 스크롤바 영역 확보 */
					overflow-y: hidden !important;
					/* 세로는 내부 div가 처리 */
					white-space: nowrap !important;
					/* 요소 줄바꿈 절대 방지 */
				}

				/* DHTMLX Layout 컨테이너가 절대 줄어들지 않도록 강제 */
				div[class*="dhtmlxLayout"],
				table[class*="dhtmlxLayout"] {
					min-width: 2000px !important;
					width: 2000px !important;
					/* auto 대신 고정값으로 버티기 */
					display: block !important;
					/* 테이블 구조 무시하고 블록으로 강제 */
				}

				#C106000200_Grid_1 {
					width: 600px !important;
					min-width: 600px !important;
					max-width: 600px !important;
					margin: 0 !important;
					padding: 0 !important;
				}

				/* Grid 컨테이너 고정 너비 + 간격 제거 */
				#C106000200_Grid_2 {
					width: 350px !important;
					min-width: 350px !important;
					max-width: 350px !important;
					margin: 0 !important;
					padding: 0 !important;
				}

				#C106000200_Grid_3 {
					width: 300px !important;
					min-width: 300px !important;
					max-width: 300px !important;
					margin: 0 !important;
					padding: 0 !important;
				}

				#C106000200_Grid_4 {
					width: 200px !important;
					min-width: 200px !important;
					max-width: 200px !important;
					margin: 0 !important;
					padding: 0 !important;
				}

				/* DHTMLX 레이아웃 셀 간격 제거 */
				.dhx_cell_layout,
				.dhx_cell_cont_layout {
					margin: 0 !important;
					padding: 0 !important;
					gap: 0 !important;
					justify-content: flex-start !important;
				}

				.odd_dhx_skyblue td,
				/* Grid2,3,4 사이 간격 완전 제거 */
				.dhx_cell_layout>div,
				.dhx_cell_cont_layout>div {
					margin: 0 !important;
					padding: 0 !important;
				}

				/* Grid2,3,4를 담는 컨테이너 - 왼쪽 정렬 고정 */
				#C106000200_Grid_2,
				#C106000200_Grid_3,
				#C106000200_Grid_4 {
					float: left !important;
				}

				/* DHTMLX 그리드 내부 padding/border 제거 */
				#C106000200_Grid_1 .objbox,
				#C106000200_Grid_2 .objbox,
				#C106000200_Grid_3 .objbox,
				#C106000200_Grid_4 .objbox,
				#C106000200_Grid_1 .gridbox,
				#C106000200_Grid_2 .gridbox,
				#C106000200_Grid_3 .gridbox,
				#C106000200_Grid_4 .gridbox,
				#C106000200_Grid_1>div,
				#C106000200_Grid_2>div,
				#C106000200_Grid_3>div,
				#C106000200_Grid_4>div {
					width: 100% !important;
					padding: 0 !important;
					margin: 0 !important;
					border: none !important;
					box-sizing: border-box !important;
				}

				/* Grid1 정렬/크기 문제 해결 (홀수/짝수 동일하게) */
				#C106000200_Grid_1 .odd_dhx_skyblue td,
				#C106000200_Grid_1 .ev_dhx_skyblue td {
					height: 22px !important;
					/* 행 높이 통일 */
					padding-left: 6px !important;
					/* 좌측 여백 통일 */
					padding-right: 6px !important;
					/* 우측 여백 통일 */
					line-height: normal !important;
					vertical-align: middle !important;
				}

				/* Grid1 세로 스크롤바 강제 복원 */
				#C106000200_Grid_1 {
					height: 100% !important;
				}

				#C106000200_Grid_1 .objbox {
					/* height: 100% !important;  <-- 제거: 헤더 높이만큼 밀려나서 잘리는 문제 방지 */
					overflow-y: scroll !important;
					/* auto 대신 scroll로 강제 표시 시도 */
				}

				/* Grid2 이미지 셀 크기 (Grid1은 영향 없음) */
				#C106000200_Grid_2 .odd_dhx_skyblue td {
					width: 100px;
					height: 100px;
				}

				#C106000200_Grid_2 img {
					max-width: 100%;
					max-height: 350px;
					width: auto;
					height: auto;
					display: block;
					/* Ensure it behaves well */
					margin: 0 auto;
					/* Center it */
					cursor: pointer;
				}
			</style>
			<script type="text/javascript">
				//<![CDATA[
				var items = new Array();  //public dhtmlx component array
				// var pageConfiguration = '[' + 
				//       '{"itemType":"form","renderTo":"C106000200_Form_1","xml":".\/header\/kr\/C106000200\/C106000200_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000200_Form_1","service":"C106000200-service","actionType":"save"},' +
				//       '{"itemType":"grid","renderTo":"C106000200_Grid_1","xml":".\/header\/kr\/C106000200\/C106000200_Grid_1.xml","rowCnt":"20","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000200_Form_1","service":"C106000200-service","actionType":"save"},' +
				//       '{"itemType":"messagebox","renderTo":"C106000200_messagebox","xml":".\/header\/kr\/C106000200\/C106000200_messagebox.xml","service":"C106000200-service","actionType":"save"},' +
				//       '{"itemType":"grid","renderTo":"C106000200_Grid_2","xml":".\/header\/kr\/C106000200\/C106000200_Grid_2.xml","rowCnt":"0","vertical":"false","url":"handleDataProcess.do","contextmenu":"false","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000200_Form_1","service":"C106000200-service","actionType":"save"},' +
				//       '{"itemType":"grid","renderTo":"C106000200_Grid_3","xml":".\/header\/kr\/C106000200\/C106000200_Grid_3.xml","rowCnt":"0","vertical":"false","url":"handleDataProcess.do","contextmenu":"false","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000200_Form_1","service":"C106000200-service","actionType":"save"},' +
				//       '{"itemType":"grid","renderTo":"C106000200_Grid_4","xml":".\/header\/kr\/C106000200\/C106000200_Grid_4.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"false","borderline":"true","pageset":"false","split":"0","referenceItem":"C106000200_Form_1","service":"C106000200-service","actionType":"save","hiddenType":"true"}' +
				//    ']';
				// var initConfig = JSON.parse(pageConfiguration);	   

				var Form_1 = { "itemType": "form", "renderTo": "C106000200_Form_1", "version": "0.0", "xml": ".\/header\/kr\/C106000200\/C106000200_Form_1.xml", "url": "basicGridData.do", "referenceItem": "C106000200_Form_1", "service": "C106000200-service", "actionType": "save" };
				var Grid_1 = { "itemType": "grid", "renderTo": "C106000200_Grid_1", "version": "0.0", "xml": ".\/header\/kr\/C106000200\/C106000200_Grid_1.xml", "rowCnt": "20", "vertical": "true", "url": "handleDataProcess.do", "contextmenu": "true", "borderline": "true", "pageset": "true", "split": "0", "referenceItem": "C106000200_Form_1", "service": "C106000200-service", "actionType": "save", "width": "30%" };
				var Grid_2 = { "itemType": "grid", "renderTo": "C106000200_Grid_2", "version": "0.0", "xml": ".\/header\/kr\/C106000200\/C106000200_Grid_2.xml", "rowCnt": "0", "vertical": "false", "url": "handleDataProcess.do", "contextmenu": "false", "borderline": "true", "pageset": "true", "split": "0", "referenceItem": "C106000200_Form_1", "service": "C106000200-service", "actionType": "save", "width": "42%" };
				var Grid_3 = { "itemType": "grid", "renderTo": "C106000200_Grid_3", "version": "0.0", "xml": ".\/header\/kr\/C106000200\/C106000200_Grid_3.xml", "rowCnt": "0", "vertical": "false", "url": "handleDataProcess.do", "contextmenu": "false", "borderline": "true", "pageset": "true", "split": "0", "referenceItem": "C106000200_Form_1", "service": "C106000200-service", "actionType": "save", "width": "14%" };
				var Grid_4 = { "itemType": "grid", "renderTo": "C106000200_Grid_4", "version": "0.0", "xml": ".\/header\/kr\/C106000200\/C106000200_Grid_4.xml", "rowCnt": "0", "vertical": "false", "url": "handleDataProcess.do", "contextmenu": "false", "borderline": "true", "pageset": "false", "split": "0", "referenceItem": "C106000200_Form_1", "service": "C106000200-service", "actionType": "save", "width": "14%" };

				var initLayout =
				{
					"programId": "C106000200",
					"itemType": "layout", "messageBox": true, "dirType": "row", "childSize": "60", "splitter": false, "components":
						[
							Form_1,
							{
								"itemType": "layout", "dirType": "col", "childSize": "600,850", "splitter": false, "components":
									[
										Grid_1,
										{
											"itemType": "layout", "dirType": "col", "childSize": "350,300,200", "splitter": false, "components":
												[
													Grid_2,
													Grid_3,
													Grid_4,
												]
										}
									]
							}

						]
				};

				var gridContextMenuConfig = { "xml": "./dhtmlx/data/contextmenu.xml", "iconImgs": window.dhx_globalImgPath };
				var aGrid2Dhx, aGrid3Dhx;
				var _onXLE03, _onXLE04;
				var MAX_OBJ_CNT = 9;		// Object 개수 정의
				var loadedObjCnt = 0;		// 화면에 Load된 Object 개수
				var gridIdList = new Array();
				var gridIdIndex = 0;

				//form find button item event function (requred) 
				function find(eventName, formDivObj, referenceItem) {
					var frmDateTime = items["C106000200_Form_1"].getItemValue("STR_SCH_DH");
					var toDateTime = items["C106000200_Form_1"].getItemValue("END_SCH_DH");
					var vMoNo = items["C106000200_Form_1"].getItemValue("MO_NO");
					var vBomNo = items["C106000200_Form_1"].getItemValue("CCL_BOM_NO");

					// 	var cParam = {"PDN_PST_DD_FR":frmDateTime,"PDN_PST_DD_TO":toDateTime, "PROC_CD":vProcCD, "MO_NO":vMoNo, "CCL_BOM_NO":vBomNo, "ORD_EXC_THK_FR":vOrdExcThkFr, "ORD_EXC_THK_TO":vOrdExcThkTo, "ORD_EXC_WTH_FR":vOrdExcWthFr, "ORD_EXC_WTH_TO":vOrdExcWthTo, "SUB_CLS_CD":vSubClass,"LN_SPD":vLnSpeed};
					// 	var findUrl = m47_customParameter("C106000200_Grid_1", "basicGridData.do", null, "find", cParam);
					var findUrl = uiCommon.parameters('C106000200_Form_1', 'C106000200_Grid_1', eventName);
					// 	items['C106000190_Grid_1'].loadData(findUrl); 




					items["C106000200_Grid_1"].clearDataProcess();
					items["C106000200_Grid_1"].loadData(findUrl);

				}

				function deteilFind(rowId) {

					var grid = items["C106000200_Grid_1"];
					var gridObj = items["C106000200_Grid_1"].getDhxGrid();

					var grid2 = items["C106000200_Grid_2"];
					var grid2Obj = items["C106000200_Grid_2"].getDhxGrid();

					var grid3 = items["C106000200_Grid_3"];
					var grid3Obj = items["C106000200_Grid_3"].getDhxGrid();

					var grid4 = items["C106000200_Grid_4"];
					var grid4Obj = items["C106000200_Grid_4"].getDhxGrid();

					var ccl_bom_no = gridObj.cellById(rowId, gridObj.getColIndexById("CCL_BOM_NO")).getValue();
					var cus_cd = gridObj.cellById(rowId, gridObj.getColIndexById("CUS_CD")).getValue();
					var ord_usg_cd = gridObj.cellById(rowId, gridObj.getColIndexById("ORD_USG_CD")).getValue();
					var ord_no = gridObj.cellById(rowId, gridObj.getColIndexById("ORD_NO")).getValue();
					var ord_ln = gridObj.cellById(rowId, gridObj.getColIndexById("ORD_LN")).getValue();

					var param = "ServiceName=C106000200-service&qltMsgFind=1&CCL_BOM_NO=" + ccl_bom_no + "&CUS_CD=" + cus_cd + "&ORD_USG_CD=" + ord_usg_cd + "&column-info=CCL_QLT_MSG_TXT";
					var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
					var cells = xmlObj.getElementsByTagName("cell");

					var qlt_msg_txt = "";
					if (cells.length > 0 && cells.item(0).firstChild) {
						qlt_msg_txt = cells.item(0).firstChild.nodeValue;
					}

					var msg = escapeHtml(qlt_msg_txt || "");
					msg = msg.replace(/(\r\n|\n)/g, "<br/>");

					// 	grid.cells(rowId, grid.getColIndexById("CCL_QLT_MSG_TXT")).setValue(msg);

					// 					var imgUrl = "/C10/coilimgdown?file=JB06HA1300A.jpg";

					var param3 = "ServiceName=C106000200-service&dgtImgFind=1&CCL_BOM_NO=" + ccl_bom_no + "&column-info=IMG_NM";
					var xmlObj3 = uiCommon.ajaxLoadData('c10AjaxData.do', param3);
					var cells3 = xmlObj3.getElementsByTagName("cell");

					if (cells3.length <= 0) {
						console.log("이미지 없음");
						grid2Obj.setCellExcellType(1, 0, "ro");
						grid2Obj.cells(1, 0).setValue("이미지가 없습니다.");
					} else {
						var imgNm = (cells3.item(0).firstChild) ? cells3.item(0).firstChild.nodeValue : "";
						console.log("img : " + imgNm);
						var imgUrl = "/C10/coilimgdown?file=" + imgNm;
						console.log("imgUrl : " + imgUrl);
						grid2Obj.setCellExcellType(1, 0, "img");
						grid2Obj.cells(1, 0).setValue(imgUrl);
					}

					if (cells.length <= 0) {
						grid2.setCellValue(3, grid2Obj.getColIndexById("CCL_BOM_NO"), msg);
						//			dhtmlx.alert("등록된 시너코드가 없습니다.");
						// grid2.setCellValue(1, grid2Obj.getColIndexById("CCL_BOM_NO"), "이미지가 없습니다.");
						// 		return true;										
					} else {
						// grid2.setCellValue(1, grid2Obj.getColIndexById("CCL_BOM_NO"), imgUrl);
						grid2.setCellValue(3, grid2Obj.getColIndexById("CCL_BOM_NO"), msg);
						// 		return true;
					}

					console.log("ord_no : " + ord_no);
					console.log("ord_ln : " + ord_ln);

					var param1 = "ServiceName=C106000200-service&prdInfoFind=1&ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln + "&column-info=CUS_CD,ORD_RGS_PRS_ID,ORD_USG_CD,HUE_CD_FRN_3COT,HUE_CD_FRN_2COT,HUE_CD_FRN_1COT,HUE_CD_BAK_1COT,HUE_CD_BAK_2COT,ORD_PTT_FLM_WTH,ORD_PTT_FLM_DTL_CD,BAK_MRK";
					var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do', param1);
					var cells1 = xmlObj1.getElementsByTagName("cell");


					// 	console.log(grid3Obj.getColIndexById("CUS_CD"));
					// 	console.log(grid3Obj.getColIndexById("ORD_RGS_PRS_ID"));
					// 	console.log(grid3Obj.getColIndexById("ORD_USG_CD"));
					// 	console.log(grid3Obj.getColIndexById("HUE_CD_FRN_3COT"));
					// 	console.log(grid3Obj.getColIndexById("HUE_CD_FRN_2COT"));

					if (cells1.length <= 0) {
						console.log("제품정보 없음");
						// 		return true;
					} else {
						grid3.setCellValue(1, 2, cells1.item(0).firstChild.nodeValue);
						grid3.setCellValue(2, 2, cells1.item(1).firstChild.nodeValue);
						grid3.setCellValue(3, 2, cells1.item(2).firstChild.nodeValue);
						grid3.setCellValue(4, 2, cells1.item(3).firstChild.nodeValue);
						grid3.setCellValue(5, 2, cells1.item(4).firstChild.nodeValue);
						grid3.setCellValue(6, 2, cells1.item(5).firstChild.nodeValue);
						grid3.setCellValue(7, 2, cells1.item(6).firstChild.nodeValue);
						grid3.setCellValue(8, 2, cells1.item(7).firstChild.nodeValue);
						grid3.setCellValue(9, 2, cells1.item(8).firstChild.nodeValue);
						grid3.setCellValue(10, 2, cells1.item(9).firstChild.nodeValue);
						grid3.setCellValue(11, 2, cells1.item(10).firstChild.nodeValue);
						// 		return true;
					}

					var param2 = "ServiceName=C106000200-service&wkInfoFind=1&CCL_BOM_NO=" + ccl_bom_no + "&column-info=WK_END_DH,CCL_BOM_NO";
					var xmlObj2 = uiCommon.ajaxLoadData('c10AjaxData.do', param2);
					var cells2 = xmlObj2.getElementsByTagName("cell");


					if (cells2.length <= 0) {
						console.log("생산정보 없음");
						return true;
					} else {
						console.log("wk_end_dh : " + cells2.item(0).firstChild.nodeValue);
						console.log("CCL_BOM_NO : " + cells2.item(1).firstChild.nodeValue);
						grid4.setCellValue(1, 1, cells2.item(0).firstChild.nodeValue);
						grid4.setCellValue(2, 1, cells2.item(1).firstChild.nodeValue);
						return true;
					}
				}

				function escapeHtml(str) {
					return str
						.replace(/&/g, "&amp;")
						.replace(/</g, "&lt;")
						.replace(/>/g, "&gt;");
				}

				function onLoadGrid(dhxGridObj, count) {
					aGrid3Dhx.detachEvent(_onXLE03);

					return true;
				}
				function onLoadComb() {
					onLoadObj();
				}
				function onLoadObj() {

					if (++loadedObjCnt >= MAX_OBJ_CNT) {
						gridInitialize();
					}
				}
				/**
				 * Grid 초기화.
				 */
				function gridInitialize() {
				}
				//menu refresh event function
				function refresh(referenceItem) { //grid selection clear event
					items[referenceItem].clearDataProcess();
					var findUrl = uiCommon.parameters('C106000200_Form_1', referenceItem, 'find');
					items[referenceItem].loadData(findUrl);
				}
				//menu rows clipboard copy event function
				function copy(referenceItem) {
					items[referenceItem].copyRowContent();
				}
				function onGridContextMenuClick(id, gridObj, menuObj) {
					var isChecked = menuObj.getCheckboxState(id);
					if ("move_grid" == id) {
						if (isChecked)
							gridObj.enableColumnMove(true);
						else
							gridObj.enableColumnMove(false);
					}
					if ("filter_grid" == id) {
						if (isChecked)
							gridObj.enableHeaderMenu();
					}

					if ("editable_grid" == id) {
						if (isChecked)
							gridObj.setEditable(true);
						else
							gridObj.setEditable(false);
					}
				}
				function findMessage(referenceItem) {
					uiCommon.message("messagebox", referenceItem.getUserData("", "appMsg"));
					return true;
				}
				function onFormLoadFunction() {
					items["C106000200_Form_1"].setItemValue("STR_SCH_DH", uiCommon.getCurrentDate());
					items["C106000200_Form_1"].setItemValue("END_SCH_DH", uiCommon.getCurrentDate());

					return true;
				}

				//링크 이벤트 처리
				function doLink(val, rId, cInd) {
					var grid = items['C106000200_Grid_1'].getDhxGrid();
					bomNo = items['C106000200_Grid_1'].getCellValue(rId, grid.getColIndexById("CCL_BOM_NO"));
					parent.newRemoveOpenTab('C106000060', 'CCL_BOM_NO' + '=' + bomNo);

				}



				function openImageViewer(imgUrl) {

					var old = document.getElementById("imgViewerOverlay");
					if (old) old.remove();

					var overlay = document.createElement("div");
					overlay.id = "imgViewerOverlay";
					overlay.style.cssText = `
				        position:fixed;
				        top:0; left:0;
				        width:100%; height:100%;
				        background:rgba(0,0,0,0.85);
				        z-index:99999;
				        display:flex;
				        align-items:center;
				        justify-content:center;
				        cursor:pointer;
				        overflow:hidden;
				    `;

					var img = document.createElement("img");
					img.src = imgUrl;

					var scale = 1;
					var posX = 0, posY = 0;
					var isDragging = false;
					var startX = 0, startY = 0;

					img.style.cssText = `
				        max-width:90%;
				        max-height:90%;
				        transform:translate(0px, 0px) scale(1);
				        transition:transform 0.1s ease;
				        cursor:grab;
				        user-select:none;
				        background:#fff;
				    `;

					overlay.appendChild(img);
					document.body.appendChild(overlay);

					function updateTransform() {
						img.style.transform =
							"translate(" + posX + "px," + posY + "px) scale(" + scale + ")";
					}

					function closeViewer() {
						document.removeEventListener("keydown", escHandler);
						overlay.remove();
					}

					function escHandler(e) {
						if (e.key === "Escape") closeViewer();
					}

					/* =====================
					   닫기 처리
					===================== */
					overlay.onclick = closeViewer;

					img.onclick = function (e) {
						e.stopPropagation();
					};

					/* =====================
					   휠 확대/축소
					===================== */
					img.addEventListener("wheel", function (e) {
						e.preventDefault();

						scale += (e.deltaY < 0) ? 0.1 : -0.1;
						scale = Math.min(Math.max(0.2, scale), 5);

						updateTransform();
					});

					/* =====================
					   드래그 이동
					===================== */
					img.addEventListener("mousedown", function (e) {
						e.preventDefault();

						isDragging = true;
						startX = e.clientX - posX;
						startY = e.clientY - posY;

						img.style.cursor = "grabbing";
						img.style.transition = "none";
					});

					document.addEventListener("mousemove", function (e) {
						if (!isDragging) return;

						posX = e.clientX - startX;
						posY = e.clientY - startY;

						updateTransform();
					});

					document.addEventListener("mouseup", function () {
						if (!isDragging) return;

						isDragging = false;
						img.style.cursor = "grab";
						img.style.transition = "transform 0.1s ease";
					});

					document.addEventListener("keydown", escHandler);
				}

				function isImageUrl(url) {
					if (!url) return false;
					return /\.(jpg|jpeg|png|gif|bmp|webp)$/i.test(url);
				}

				//]]>

			</script>
		</head>

		<body>
			<!-- <div id="C106000200_Form_1" style="position:absolute;height:59px;width:975px;left:0px;top:0px;">
</div>
<div id="C106000200_Grid_1" style="position:absolute;height:497px;width:220px;left:0px;top:60px;">
</div>
<div id="C106000200_messagebox" style="position:absolute;height:23px;width:975px;left:0px;top:559px;">
</div>
<div id="C106000200_Grid_2" style="position:absolute;height:497px;width:374px;left:222px;top:60px;">
</div>
<div id="C106000200_Grid_3" style="position:absolute;height:497px;width:374px;left:598px;top:60px;">
</div>
-->
			<div id="C106000200_Grid_4" style="position:absolute;height:497px;width:220px;left:0px;top:60px;">
			</div>
		</body>

		</html>
		<script>

			//<![CDATA[
			ui.initializeDHTMLX();
			//     ui.componentRendering(null, Grid_4);
			items["C106000200_Grid_1"].rowSelected(deteilFind);
			var onXLEForm = items['C106000200_Form_1'].onXLEEvent(onFormLoadFunction);


			var grid2Obj = items["C106000200_Grid_2"].getDhxGrid();

			grid2Obj.attachEvent("onRowSelect", function (rId, cInd) {

				if (grid2Obj.getColType(cInd) !== "img") return;

				var imgUrl = grid2Obj.cells(rId, cInd).getValue();

				// ⭐ 핵심 필터
				if (!isImageUrl(imgUrl)) return;

				grid2Obj.clearSelection();
				openImageViewer(imgUrl);
			});

			//]]>

		</script>