<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C108000240pop01.jsp
 * VERSION          :  1.0
 * DESCRIPTION      :  칼라 개발 의뢰
 * DESIGNER NAME    :  SJS                              
 * DEVELOPER NAME   :  SJS
 * CREATE DATE      :  2026.01.29
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2026.01.29     V1.0    	SJS			 최초작성 
--%>
<%@page import="com.posdata.glue.web.security.PosSecurityConstants"%>
<%@page import="com.posdata.glue.web.security.PosUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	PosUser	user		= (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String		userNo	= "";
	String		userName= "";		
	
	String DEV_ID = request.getParameter("DEV_ID")	!= null ? request.getParameter("DEV_ID") : "";

	String		userDeptCd	= "";
	String		userDeptNm	= "";

	if(user != null) {
		userNo 		= (String)user.getUserInfo("USER_NO");
		userName	= (String)user.getUserInfo("USER_NAME");
		userDeptCd	= user.getUserInfo("DEPT_CD")   != null ? (String)user.getUserInfo("DEPT_CD")   : "";
		userDeptNm	= user.getUserInfo("DEPT_CD_NM") != null ? (String)user.getUserInfo("DEPT_CD_NM") : "";
	}
%>
                    <html xmlns="http://www.w3.org/1999/xhtml">

                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
                        </meta>
                        <title>칼라개발의뢰</title>
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

                            div.dhxlist_obj_dhx_skyblue {
                                background-color: rgb(235, 235, 235);
                            }

                            html,
                            body {
                                width: 90%;
                                height: 90%;
                            }

                            #C108000240pop01_Grid_2 .objbox {
                                overflow-y: auto !important;
                                overflow-x: hidden !important;
                            }
                            #C108000240pop01_Grid_2 td.hdrcell,
                            #C108000240pop01_Grid_2 .hdr td,
                            #C108000240pop01_Grid_2 .xhdr td,
                            #C108000240pop01_Grid_2 div.gridbox_dhx_skyblue .hdr td,
                            #C108000240pop01_Grid_2 div.gridbox_dhx_skyblue .xhdr td {
                                white-space: nowrap !important;
                                overflow: hidden !important;
                                height: 26px !important;
                                line-height: 26px !important;
                                padding: 0 4px !important;
                            }


                            /* Grid_2 에디터 스타일 강제 고정 — popup 페이지에 붙여넣기 */
                            #C108000240pop01_Grid_2 .objbox input,
                            #C108000240pop01_Grid_2 .objbox textarea,
                            #C108000240pop01_Grid_2 .objbox select {
                                border: 0 !important;
                                outline: none !important;
                                box-shadow: none !important;
                                margin: 0 !important;
                                padding: 0 4px !important;
                                /* 셀에 맞는 여백 */
                                height: 100% !important;
                                /* 셀 높이에 맞춤 */
                                line-height: normal !important;
                                box-sizing: border-box !important;
                                /* 테두리로 높이가 변하지 않도록 */
                                background: transparent !important;
                                resize: none !important;
                            }

                            /* 편집중인 셀의 포커스 클래스가 있다면 (안전용) */
                            #C108000240pop01_Grid_2 .objbox .dhxcell_editor,
                            #C108000240pop01_Grid_2 .objbox .dhx_inp_edit {
                                border: 0 !important;
                                box-shadow: none !important;
                                background: transparent !important;
                            }

                            #C108000240pop01_Grid_2 .objbox .dhxgrid_invalid,
                            #C108000240pop01_Grid_2 .objbox .dhtmlx_validation_error,
                            #C108000240pop01_Grid_2 .objbox .dhx_inp_error {
                                border: 0 !important;
                                box-shadow: none !important;
                                background: transparent !important;
                                color: inherit !important;
                            }

                        </style>
                        <!-- <script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script> -->
                        <script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js"></script>
                        <script src="./js/c10.ui.js" type="text/javascript">
                        </script>
                        <link rel="stylesheet" type="text/css" href="./dhtmlx/codebase/dhtmlxvault.css" />
                        <script language="JavaScript" type="text/javascript"
                            src="./dhtmlx/codebase/dhtmlxvault.js"></script>
                        <script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
// var pageConfiguration = '[' + 
//       '{"itemType":"form","renderTo":"C108000240pop01_Form_1","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C108000240pop01_Form_1","service":"C108000240pop01-service","actionType":"save"},' +
//       '{"itemType":"grid","renderTo":"C108000240pop01_Grid_1","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Grid_1.xml","rowCnt":"8","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"false","split":"0","referenceItem":"C108000240pop01_Grid_1","service":"C108000240pop01-service","actionType":"save"},' +
//       '{"itemType":"messagebox","renderTo":"C108000240pop01_MessageBox_1","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_MessageBox_1.xml","service":"C108000240pop01-service"},' +
//       '{"itemType":"grid","renderTo":"C108000240pop01_Grid_2","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Grid_2.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"false","split":"0","referenceItem":"C108000240pop01_Grid_2","service":"C108000240pop01-service","actionType":"save"},' +
// // 	  '{"itemType":"grid","renderTo":"C108000240pop01_Grid_3","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Grid_3.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"false","split":"0","referenceItem":"C108000240pop01_Grid_2","service":"C108000240pop01-service","actionType":"save"},' +
// 	  '{"itemType":"form","renderTo":"C108000240pop01_Form_2","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Form_2.xml","url":"basicFormData.do","referenceItem":"C108000240pop01_Form_1","service":"C108000240pop01-service","actionType":"save"}' +
// // 	  '{"itemType":"grid","renderTo":"C108000240pop01_Grid_4","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Grid_4.xml","rowCnt":"0","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"false","split":"0","referenceItem":"C108000240pop01_Grid_2","service":"C108000240pop01-service","actionType":"save"}' +	  
//   ']';
  
  
var Form_1 = {"itemType":"form","renderTo":"C108000240pop01_Form_1","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Form_1.xml","url":"basicFormData.do","referenceItem":"C108000240pop01_Form_1","service":"C108000240pop01-service","actionType":"save"};
var Grid_1 = {"itemType":"grid","renderTo":"C108000240pop01_Grid_1","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Grid_1.xml","rowCnt":"9","vertical":"false","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"false","split":"0","referenceItem":"C108000240pop01_Grid_1","service":"C108000240pop01-service","actionType":"save"};
var Grid_2 = {"itemType":"grid","renderTo":"C108000240pop01_Grid_2","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Grid_2.xml","rowCnt":"0","vertical":"false","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"false","split":"0","referenceItem":"C108000240pop01_Grid_2","service":"C108000240pop01-service","actionType":"save"};
var Grid_3 = {"itemType":"grid","renderTo":"C108000240pop01_Grid_3","xml":".\/header\/kr\/C108000240pop01\/C108000240pop01_Grid_3.xml","rowCnt":"0","vertical":"false","url":"gridC10Data.do","contextmenu":"false","borderline":"true","pageset":"false","split":"0","referenceItem":"C108000240pop01_Grid_3","service":"C108000240pop01-service","actionType":"save"};

Grid_1.header = "*개발진도 및 결재관리";
// Grid_1.arrow = true;

Grid_2.header = "*특이사항";
Grid_3.header = "*첨부파일 목록";

var initLayout =
{
	"programId":"C108000240pop01", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"406,232,*", "splitter":false, "components":
 	[
	 	Form_1,
		Grid_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"210,*", "splitter":false, "components":
			[
				Grid_3,
				Grid_2
			]
		}
 	]
};


// var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

var comboValue = [['Y', 'Y'], ['N', 'N']];
var comboMtlGrt = [['A','보증없음'], ['B','5년'], ['C','10년'], ['D','15년'], ['E','20년'], ['F','25년'], ['G','30년'], ['H','35년'], ['I','40년']];
var comboFlmGrt = [['A','보증없음'], ['B','5년'], ['C','10년'], ['D','15년'], ['E','20년'], ['F','25년'], ['G','30년'], ['H','35년'], ['I','40년']];

var DEV_ID = '<%= DEV_ID%>' == "" ? "" : '<%= DEV_ID%>'; 
var lastSaveAction      = '';
var lastApprovalRowId   = null;
var lastApprovalResult  = null; // '2'=승인, '3'=반려
var _deptChangeModal   = null; // 부서변경 모달
// 부서 목록: 고정 순서
var g1DeptArr         = [['50106496','Appsteel영업팀'],['50106497','Luxteel영업팀'],['60000002','Luxteel수출팀'],['50106498','디자인팀'],['50106524','제품연구팀'],['50106513','Luxteel생산팀'],['50106514','Appsteel생산팀']];
var g1DeptNameToCd    = {'Appsteel영업팀':'50106496','Luxteel영업팀':'50106497','Luxteel수출팀':'60000002','디자인팀':'50106498','제품연구팀':'50106524','Luxteel생산팀':'50106513','Appsteel생산팀':'50106514'};
var userDeptCd = '<%= userDeptCd %>' || null;
var userDeptNm = '<%= userDeptNm %>' || null;

//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){    
    
}

function findMessage(referenceItem) {
    var appMsg = referenceItem.getUserData("", "appMsg");
    if (appMsg) {
        console.log("Grid Load Message:", appMsg);
        // dhtmlx.alert(appMsg); // Uncomment if a popup is desired
    }
    return true;
}

function save(eventName, formDivObj, referenceItem) {
    var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();
    var grid2Obj = items['C108000240pop01_Grid_2'].getDhxGrid();
//     var grid4Obj = items['C108000240pop01_Grid_4'].getDhxGrid();
    var form1 = items['C108000240pop01_Form_1'];

    var chgCnt = 0;
    var chkArr = [];

//     if (TST_ANL_REQ_NO == null || TST_ANL_REQ_NO == "") {
//         var param = "ServiceName=C108000240pop01-service";
//         param += "&maxNo=1&column-info=TST_ANL_REQ_NO";
//         var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
//         var cells = xmlObj.getElementsByTagName("cell");
//         form1.setItemValue("TST_ANL_REQ_NO", cells.item(0).firstChild.nodeValue);
//     } else {
//         form1.setItemValue("TST_ANL_REQ_NO", TST_ANL_REQ_NO);
//         modiYn = 'Y';
        
//         dhtmlx.alert("이미 의뢰된 내용은 수정할 수 없습니다.");
//         return;
        
//     }

//     var userVal1 = grid4Obj.cells2(0, 3).getValue();
    var devReqDd = form1.getItemValue("DEV_REQ_DD");
    var devEndDd = form1.getItemValue("DEV_END_DD");
//     var tstAnlContent = form1.getItemValue("TST_ANL_CONTENT");
//     var curPrgCd = form1.getItemValue("TST_ANL_PRG_CD");
	
    // 필수값 검증
    var _reqChecks = [
        {name:'DEV_SBJ',     label:'의뢰명'},
        {name:'CUS_CD',      label:'수요가'},
        {name:'CLR_NM',      label:'색상명'},
        {name:'FNL_CUS_CD',  label:'최종고객사'},
        {name:'ORD_USG_CD',  label:'용도'},
        {name:'PRD_NM_CD',   label:'제품군'},
        {name:'GW_ASG_CD',   label:'도금량'},
        {name:'RSN_TP',      label:'도료타입'},
        {name:'PTT_FLM',     label:'보호필름'},
        {name:'COT_TP',      label:'코팅타입'},
        {name:'MTL_GRT',     label:'소재보증'},
        {name:'PNT_FLM_GRT', label:'도막보증'}
    ];
    for (var _rc = 0; _rc < _reqChecks.length; _rc++) {
        var _rv = form1.getItemValue(_reqChecks[_rc].name);
        if (!_rv || (typeof _rv === 'string' && _rv.trim() === '')) {
            dhtmlx.alert(_reqChecks[_rc].label + '을(를) 입력하세요.');
            return;
        }
    }
    if (!devEndDd) { dhtmlx.alert("완료목표일을 입력하세요."); return; }

    // Grid_1 처리담당부서 검증 (step_1 개발접수 자동, step_7 개발중단 제외)
    var g1DeptCdIdx  = gridObj.getColIndexById("DEPT_CD");
    // step_1: 의뢰자 부서 자동 세팅
    gridObj.cells("step_1", g1DeptCdIdx).setValue(userDeptCd || '');
    var g1StepNames  = ["분석/개발", "시편승인", "사양승인", "BOM등록", "개발완료대기", "개발완료"];
    var g1StepRowIds = ["step_2", "step_3", "step_4", "step_5", "step_6", "step_7"];
    for (var g1r = 0; g1r < g1StepRowIds.length; g1r++) {
        var g1DeptCd = gridObj.cells(g1StepRowIds[g1r], g1DeptCdIdx).getValue();
        if (!g1DeptCd) {
            dhtmlx.alert("[" + g1StepNames[g1r] + "] 단계의 처리담당부서를 선택해주세요.");
            return;
        }
    }
//     if (!tstAnlContent) { dhtmlx.alert("의뢰내용을 입력하세요."); return; }
//     if (!userVal1) { dhtmlx.alert("1차 합의 수신인을 선택해주세요."); return; }
//     if (curPrgCd > 1) { dhtmlx.alert("승인된 의뢰는 수정할 수 없습니다."); return; }
<%--     if (form1.getItemValue("TST_ANL_REQ_ID") != "<%=userNo %>") { --%>
//         dhtmlx.alert("의뢰자 본인만 수정할 수 있습니다.");
//         return;
//     }
    
//     console.log("담당자 이름 : "+grid4Obj.cellById(0, grid4Obj.getColIndexById("TST_PFM1_ID")).getValue());


// 저장 전 ID 채번 (MAX + 1) 저장 취소할 경우 DEV_ID값을 날려야 할까? 
		
if(DEV_ID == null || DEV_ID == ""){

	var nextDevId = getNextDevId();
	console.log("Pre-calculated DEV_ID:", nextDevId);

	if(nextDevId){
	    form1.setItemValue("DEV_ID", nextDevId);
	    DEV_ID = nextDevId;
	} else {
	    dhtmlx.alert("개발번호를 생성할 수 없습니다. 관리자에게 문의해주세요.");
	    return;
	}

}else{
	dhtmlx.alert("이미 의뢰된 의뢰는 수정할 수 없습니다.");
	return;
}		
		

    // === 확인 이후에 처리되도록 변경 ===
    dhtmlx.confirm({
        ok: "확인", cancel: "취소",
        text: "입력된 정보를 저장하시겠습니까?",
        callback: function (val) {
            if (val) {
                // 선택된 의뢰 목록 저장
//                 form1.setItemValue("TST_SEQ", TST_SEQ);
                
                   form1.setItemValue("DEV_CHR_ID", "<%=userNo%>");
                   form1.setItemValue("REG_CHR_ID", "<%=userNo%>");

                // Grid2 데이터 저장
//                 for (var c = 1; c <= 3; c++) {
//                     form1.setItemValue("TST_PRD_NM" + c, grid2Obj.cellById(1, c - 1).getValue());
//                     form1.setItemValue("TST_ITM" + c, grid2Obj.cellById(2, c - 1).getValue());
//                     form1.setItemValue("TST_PRT" + c, grid2Obj.cellById(3, c - 1).getValue());
//                     form1.setItemValue("RMTL_MAK" + c, grid2Obj.cellById(4, c - 1).getValue());
//                     form1.setItemValue("COIL_ID" + c, grid2Obj.cellById(5, c - 1).getValue());
//                     form1.setItemValue("TST_SZ" + c, grid2Obj.cellById(6, c - 1).getValue());
//                     form1.setItemValue("GW_QTY" + c, grid2Obj.cellById(7, c - 1).getValue());
//                     form1.setItemValue("MQL_CD" + c, grid2Obj.cellById(8, c - 1).getValue());
//                 }
//                 form1.setItemValue("TST_ETC", grid2Obj.cellById(9, 0).getValue());

                // 1차 합의자 정보
//                 form1.setItemValue("TST_PFM1_ID", grid4Obj.cellById(0, grid4Obj.getColIndexById("TST_PFM1_ID")).getValue());
//                 form1.setItemValue("TST_PFM1_DEPT", grid4Obj.cellById(0, grid4Obj.getColIndexById("TST_PFM1_DEPT")).getValue());
//                 form1.setItemValue("TST_ANL_PRG_CD", "1");
<%--                 form1.setItemValue("TST_ANL_REQ_NM", "<%=userName%>"); --%>

                // SMS 발송 대상자 체크
//                 if (modiYn != 'Y') {
//                     chkEmpInfo(form1.getItemValue("TST_PFM1_ID"));
//                 }
//                 form1.setItemValue("MODI_YN", modiYn);

				lastSaveAction = 'save';

				// Grid_1 부서코드를 Form_1 hidden field에 복사 (step_1~step_6 전체)
				var _allStepRows = ["step_1","step_2","step_3","step_4","step_5","step_6","step_7"];
				for (var gi = 0; gi < _allStepRows.length; gi++) {
				    var deptCd = gridObj.cells(_allStepRows[gi], g1DeptCdIdx).getValue();
				    form1.setItemValue("DEPT_CD_" + (gi + 1), deptCd);
				}

                // 'code : name' → raw code 추출
                var _codeFields = ['CUS_CD','FNL_CUS_CD','ORD_USG_CD','NAT_CD'];
                for (var _ci = 0; _ci < _codeFields.length; _ci++) {
                    var _v = form1.getItemValue(_codeFields[_ci]) || "";
                    if (_v.indexOf(' : ') > -1) form1.setItemValue(_codeFields[_ci], _v.split(' : ')[0]);
                }

                // undefined/null/공백 처리 (모든 폼 필드)
                var _undFields = ['RAL_CD','PNT_FLM_THK','DEV_ETC','NAT_CD','CCL_BOM_NO','LUS_RT_CD'];
                for (var _ui = 0; _ui < _undFields.length; _ui++) {
                    var _uv = form1.getItemValue(_undFields[_ui]);
                    if (_uv === undefined || _uv === null || _uv === 'undefined' || String(_uv) === 'undefined') form1.setItemValue(_undFields[_ui], '');
                }

                // 최종 저장
                form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', eventName);
                
            }else {
                // 취소 눌렀을 때 DEV_ID 초기화
                DEV_ID = "";
                form1.setItemValue("DEV_ID", "");
            }
        }
    });
}

// saveEtc: Form_1 특이사항 저장 기능 제거 — Grid_2에서 직접 관리
function saveEtc(eventName, formDivObj, referenceItem) {
    dhtmlx.alert("특이사항은 아래 특이사항 그리드에서 직접 추가/수정/삭제하세요.");
}



// ===== 결재 처리 함수 (병렬 결재) =====
var _approvalModal = null;
var lastApprovalStepCd = null;

function _closeApprovalModal() {
    if (_approvalModal && _approvalModal.parentNode) {
        _approvalModal.parentNode.removeChild(_approvalModal);
    }
    _approvalModal = null;
}

// 제품사양서 파일 존재 여부 확인
function _checkProdSpecFile() {
    try {
        var grid3 = items['C108000240pop01_Grid_3'];
        if (!grid3) return false;
        var gridObj = grid3.getDhxGrid();
        if (!gridObj) return false;
        var fileTpIdx = gridObj.getColIndexById("FILE_TP");
        if (fileTpIdx < 0) return false;
        var rowCnt = gridObj.getRowsNum();
        for (var r = 0; r < rowCnt; r++) {
            var rowId = gridObj.getRowId(r);
            var fileTp = gridObj.cells(rowId, fileTpIdx).getValue();
            if (fileTp === '제품사양서') return true;
        }
        return false;
    } catch (e) { console.error("[checkProdSpecFile] error:", e); return false; }
}

// BOM 검색
function _searchBom(searchKey, selectId) {
    try {
        var _selId = selectId || "aprvBomResult";
        var param = "ServiceName=C108000240pop01-service&findBom=1&CCL_BOM_NO=" + encodeURIComponent(searchKey)
                  + "&column-info=CCL_BOM_NO";
        var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
        var resultSelect = document.getElementById(_selId);
        resultSelect.innerHTML = '<option value="">-- 선택 --</option>';
        if (xmlObj) {
            var cells = xmlObj.getElementsByTagName("cell");
            for (var i = 0; i < cells.length; i++) {
                var bomNo = (cells.item(i) && cells.item(i).firstChild) ? cells.item(i).firstChild.nodeValue : '';
                if (bomNo) {
                    var opt = document.createElement('option');
                    opt.value = bomNo;
                    opt.text = bomNo;
                    resultSelect.appendChild(opt);
                }
            }
            if (resultSelect.options.length === 1) {
                dhtmlx.alert("검색 결과가 없습니다.");
            }
        }
    } catch (e) { console.error("[searchBom] error:", e); }
}

// ===== BOM 변경 버튼 + 모달 =====
function bomChangeBtn(name, val) {
    return '<button id="_bomChgBtn" onclick="changeBom()" style="padding:1px 6px;font-size:11px;cursor:pointer;" disabled="disabled">변경</button>';
}
function _updateBomChgBtn() {
    try {
        var btn = document.getElementById('_bomChgBtn');
        if (!btn) return;
        var bom = items['C108000240pop01_Form_1'].getItemValue('CCL_BOM_NO');
        if (bom && bom.trim() !== '') {
            btn.disabled = false;
            btn.style.opacity = '1';
        } else {
            btn.disabled = true;
            btn.style.opacity = '0.5';
        }
    } catch(e) {}
}

var _bomChangeModal = null;
function _closeBomChangeModal() {
    if (_bomChangeModal && _bomChangeModal.parentNode) _bomChangeModal.parentNode.removeChild(_bomChangeModal);
    _bomChangeModal = null;
}

function changeBom() {
    if (!DEV_ID) { dhtmlx.alert("저장된 의뢰가 없습니다."); return; }
    var form1 = items['C108000240pop01_Form_1'];

    // 개발완료(6) 승인 여부 확인
    var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();
    var step6Status = gridObj.cells("step_6", gridObj.getColIndexById("APRV_STATUS")).getValue();
    if (step6Status === '2') {
        dhtmlx.alert("개발완료 승인 후에는 BOM을 변경할 수 없습니다.");
        return;
    }
    var devPrgCd = form1.getItemValue("DEV_PRG_CD");
    if (devPrgCd === '8') {
        dhtmlx.alert("개발중단된 의뢰는 BOM을 변경할 수 없습니다.");
        return;
    }

    var currentBom = form1.getItemValue("CCL_BOM_NO") || "";

    _closeBomChangeModal();
    var modal = document.createElement("div");
    modal.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:9999;display:flex;align-items:center;justify-content:center;";
    modal.innerHTML =
        '<div style="background:#fff;width:460px;padding:16px;border:1px solid #93AFBA;box-shadow:3px 3px 10px rgba(0,0,0,0.3);max-height:90%;overflow:auto;">' +
        '<div style="font-weight:bold;margin-bottom:12px;font-size:14px;">CCL-BOM 변경</div>' +
        '<div style="font-size:12px;margin-bottom:8px;">현재 BOM: <b>' + (currentBom || '(없음)') + '</b></div>' +
        '<div style="margin-bottom:8px;border-top:1px solid #ddd;padding-top:10px;">' +
        '<div style="font-size:12px;font-weight:bold;margin-bottom:4px;">변경할 BOM 검색</div>' +
        '<div style="display:flex;gap:6px;margin-bottom:4px;">' +
        '<input type="text" id="bomChgSearch" maxlength="20" placeholder="4자리 이상 입력" style="flex:1;padding:3px;font-size:12px;" />' +
        '<button id="bomChgSearchBtn" style="padding:2px 10px;font-size:11px;cursor:pointer;">검색</button>' +
        '</div>' +
        '<select id="bomChgResult" style="width:100%;padding:3px;font-size:12px;">' +
        '<option value="">-- 검색 후 선택 --</option>' +
        '</select></div>' +
        '<div style="margin-bottom:8px;border-top:1px solid #ddd;padding-top:10px;">' +
        '<div style="font-size:12px;font-weight:bold;margin-bottom:4px;">최초 등록한 BOM에서 변경되는 이유가 무엇인가요? <span style="color:red;">(필수)</span></div>' +
        '<textarea id="bomChgReason" rows="3" style="width:100%;box-sizing:border-box;resize:vertical;font-size:13px;" placeholder="변경 사유를 입력하세요."></textarea>' +
        '</div>' +
        '<div style="text-align:right;margin-top:10px;">' +
        '<button id="bomChgConfirmBtn" style="margin-right:6px;padding:3px 12px;">확인</button>' +
        '<button id="bomChgCancelBtn" style="padding:3px 12px;">취소</button>' +
        '</div></div>';
    document.body.appendChild(modal);
    _bomChangeModal = modal;

    // 검색 버튼
    document.getElementById("bomChgSearchBtn").onclick = function() {
        var key = document.getElementById("bomChgSearch").value.trim();
        if (key.length < 4) { dhtmlx.alert("BOM 번호를 4자리 이상 입력해주세요."); return; }
        _searchBom(key, "bomChgResult");
    };

    // 확인 버튼
    document.getElementById("bomChgConfirmBtn").onclick = function() {
        var newBom = document.getElementById("bomChgResult").value;
        var reason = document.getElementById("bomChgReason").value.trim();
        if (!newBom) { dhtmlx.alert("변경할 BOM을 검색 후 선택해주세요."); return; }
        if (!reason) { dhtmlx.alert("변경 사유를 입력해주세요."); return; }
        if (newBom === currentBom) { dhtmlx.alert("현재 BOM과 동일합니다."); return; }

        dhtmlx.confirm({
            ok: "확인", cancel: "취소",
            text: "CCL-BOM을 변경하시겠습니까?",
            callback: function(val) {
                if (val) {
                    form1.setItemValue("DEV_ID", DEV_ID.replace(/-/g, ''));
                    form1.setItemValue("NEW_BOM_NO", newBom);
                    form1.setItemValue("BF_BOM_NO", currentBom);
                    form1.setItemValue("BOM_CHG_REASON", reason);
                    // code:name → raw code
                    var _cf = ['CUS_CD','FNL_CUS_CD','ORD_USG_CD','NAT_CD'];
                    for (var _i = 0; _i < _cf.length; _i++) {
                        var _v = form1.getItemValue(_cf[_i]) || "";
                        if (_v.indexOf(' : ') > -1) form1.setItemValue(_cf[_i], _v.split(' : ')[0]);
                    }
                    lastSaveAction = 'changeBom';
                    form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'changeBom');
                    _closeBomChangeModal();
                }
            }
        });
    };

    // 취소 버튼
    document.getElementById("bomChgCancelBtn").onclick = function() { _closeBomChangeModal(); };
    modal.onclick = function(e) { if (e.target === modal) _closeBomChangeModal(); };
}
// ===== BOM 변경 모달 끝 =====

function approval(eventName, formDivObj, referenceItem) {
    var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();
    var form1   = items['C108000240pop01_Form_1'];

    if (!DEV_ID) {
        dhtmlx.alert("저장 후 결재할 수 있습니다.");
        return;
    }

    var devPrgCd = form1.getItemValue("DEV_PRG_CD");
    if (devPrgCd === '8') {
        dhtmlx.alert("중단/완료된 의뢰입니다.");
        return;
    }

    var aprvStatusIdx = gridObj.getColIndexById("APRV_STATUS");
    var deptCdIdx     = gridObj.getColIndexById("DEPT_CD");
    var stepCdIdx     = gridObj.getColIndexById("DEV_PRG_CD");

    var stepNmMap = {'1':'개발접수','2':'분석/개발','3':'시편승인','4':'사양승인','5':'BOM등록','6':'개발완료대기','7':'개발완료'};

    // 순차결재: 현재 결재 대기 단계 자동 탐색
    // 순서: 개발접수(1) → 시편승인(3) → 사양승인(4) → BOM등록(5) → 개발완료(6)
    // 분석/개발(2)은 시편승인 시 자동 처리
    // 순서: 개발접수(1) → 시편승인(3) → 사양승인(4) → BOM등록(5) → 개발완료대기(6)
    // 분석/개발(2)은 시편승인 시 자동, 개발완료(7)는 개발완료대기 시 자동
    var _seqOrder = ['1','3','4','5','6'];
    var selectedRowId = null;
    var currentStepCd = null;
    var currentStepNm = null;
    var currentDeptCd = null;

    for (var _sq = 0; _sq < _seqOrder.length; _sq++) {
        var _rowId = 'step_' + _seqOrder[_sq];
        var _status = gridObj.cells(_rowId, aprvStatusIdx).getValue();
        if (_status === '3') {
            // 반려된 단계 → 이후 결재 진행 불가
            dhtmlx.alert("[" + stepNmMap[_seqOrder[_sq]] + "] 단계가 반려되었습니다. 더 이상 결재를 진행할 수 없습니다.");
            return;
        }
        if (_status !== '2') {
            selectedRowId = _rowId;
            currentStepCd = _seqOrder[_sq];
            currentStepNm = stepNmMap[currentStepCd];
            currentDeptCd = gridObj.cells(_rowId, deptCdIdx).getValue();
            break;
        }
    }

    if (!selectedRowId) {
        dhtmlx.alert("모든 단계의 결재가 완료되었습니다.");
        return;
    }

    // 선택된 행 하이라이트
    gridObj.selectRowById(selectedRowId);

    if (!currentDeptCd) {
        dhtmlx.alert("[" + currentStepNm + "] 단계의 처리담당부서가 지정되지 않았습니다.");
        return;
    }

    var myDeptCd = userDeptCd;
    var myUserNo = '<%=userNo%>';

    if (myDeptCd !== currentDeptCd) {
        dhtmlx.alert("현재 단계의 처리담당부서(" + currentDeptCd + ")와 소속부서가 다릅니다.\n결재할 수 없습니다.");
        return;
    }

    // 단계별 추가 HTML
    var extraHtml = '';
    if (currentStepCd === '5') {
        // BOM등록: BOM 검색
        var currentBom = form1.getItemValue("CCL_BOM_NO") || '';
        extraHtml = '<div style="margin-bottom:10px;border-top:1px solid #ddd;padding-top:10px;">'
                  + '<div style="font-size:12px;font-weight:bold;margin-bottom:4px;">CCL-BOM 검색 <span style="color:red;">(승인 시 필수)</span></div>'
                  + '<div style="display:flex;gap:6px;margin-bottom:4px;">'
                  + '<input type="text" id="aprvBomSearch" maxlength="20" placeholder="4자리 이상 입력" style="flex:1;padding:3px;font-size:12px;" />'
                  + '<button id="aprvBomSearchBtn" style="padding:2px 10px;font-size:11px;cursor:pointer;">검색</button>'
                  + '</div>'
                  + '<select id="aprvBomResult" style="width:100%;padding:3px;font-size:12px;">'
                  + '<option value="">-- 검색 후 선택 --</option>'
                  + '</select>'
                  + '<div style="font-size:11px;color:#888;margin-top:4px;">현재 CCL-BOM: ' + (currentBom || '(없음)') + '</div>'
                  + '</div>';
    } else if (currentStepCd === '3') {
        // 시편승인: 도료사 개발번호
        extraHtml = '<div style="margin-bottom:10px;border-top:1px solid #ddd;padding-top:10px;">'
                  + '<div style="font-size:12px;font-weight:bold;margin-bottom:4px;">도료사 개발번호 <span style="color:red;">(승인 시 필수)</span></div>'
                  + '<input type="text" id="aprvDcrDevNo" maxlength="50" placeholder="도료사 개발번호를 입력하세요" style="width:100%;box-sizing:border-box;padding:3px;font-size:12px;" />'
                  + '<div style="font-size:11px;color:#888;margin-top:4px;">※ 승인 시 특이사항에 자동 기록되며, 분석/개발 단계가 자동 승인됩니다.</div>'
                  + '</div>';
    } else if (currentStepCd === '4') {
        // 사양승인: 제품사양서 파일 확인 + 사후첨부 체크박스
        var hasSpecFile = _checkProdSpecFile();
        var warnHtml = hasSpecFile
            ? '<div style="color:#0a7a0a;font-size:11px;margin-bottom:4px;">※ 제품사양서 파일이 확인되었습니다.</div>'
            : '<div style="color:red;font-size:11px;margin-bottom:4px;">※ 제품사양서 파일이 업로드되지 않았습니다.</div>';
        extraHtml = '<div style="margin-bottom:10px;border-top:1px solid #ddd;padding-top:10px;">'
                  + '<div style="font-size:12px;font-weight:bold;margin-bottom:4px;">제품사양서 확인</div>'
                  + warnHtml
                  + '<label style="font-size:12px;cursor:pointer;"><input type="checkbox" id="aprvPostAtt" /> 사후첨부 (제품사양서는 나중에 첨부)</label>'
                  + '</div>';
    }

    // 모달 생성
    _closeApprovalModal();
    var modal = document.createElement("div");
    modal.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:9999;display:flex;align-items:center;justify-content:center;";
    modal.innerHTML =
        '<div style="background:#fff;width:460px;padding:16px;border:1px solid #93AFBA;box-shadow:3px 3px 10px rgba(0,0,0,0.3);max-height:90%;overflow:auto;">' +
        '<div style="font-weight:bold;margin-bottom:12px;font-size:20px;">[' + currentStepNm + '] 결재</div>' +
        '<div style="margin-bottom:10px;">' +
        '  <label style="margin-right:20px;cursor:pointer;"><input type="radio" name="aprvAction" value="2" checked /> 승인</label>' +
        '  <label style="cursor:pointer;"><input type="radio" name="aprvAction" value="3" /> 반려</label>' +
        '</div>' +
        extraHtml +
        '<div style="margin-bottom:4px;font-size:12px;">의견 <span id="aprvOpinionReq" style="color:red;display:none;">(필수)</span></div>' +
        '<textarea id="aprvOpinionInput" rows="4" style="width:100%;box-sizing:border-box;resize:vertical;font-size:13px;" placeholder="의견을 입력하세요."></textarea>' +
        '<div style="text-align:right;margin-top:10px;">' +
        '<button id="aprvConfirmBtn" style="margin-right:6px;padding:3px 12px;">확인</button>' +
        '<button id="aprvCancelBtn" style="padding:3px 12px;">취소</button>' +
        '</div></div>';
    document.body.appendChild(modal);
    _approvalModal = modal;

    // 반려 선택 시 의견 필수 표시
    var radios = modal.querySelectorAll('input[name="aprvAction"]');
    for (var ri = 0; ri < radios.length; ri++) {
        radios[ri].onchange = function() {
            document.getElementById("aprvOpinionReq").style.display = (this.value === '3') ? 'inline' : 'none';
        };
    }

    // BOM 검색 버튼 이벤트
    if (currentStepCd === '5') {
        document.getElementById("aprvBomSearchBtn").onclick = function() {
            var searchKey = document.getElementById("aprvBomSearch").value.trim();
            if (searchKey.length < 4) {
                dhtmlx.alert("BOM 번호를 4자리 이상 입력해주세요.");
                return;
            }
            _searchBom(searchKey);
        };
    }

    // 확인 버튼
    document.getElementById("aprvConfirmBtn").onclick = function() {
        var selRadio = modal.querySelector('input[name="aprvAction"]:checked');
        var aprvResult = selRadio ? selRadio.value : '2';
        var opinion = document.getElementById("aprvOpinionInput").value.trim();

        if (aprvResult === '3' && !opinion) {
            dhtmlx.alert("반려 시 의견을 입력해주세요.");
            return;
        }

        // 승인 시 단계별 추가 검증
        var extBomNo = '';
        var extDcrDevNo = '';
        var extPostAtt = '';

        if (aprvResult === '2') {
            if (currentStepCd === '5') {
                var bomSelect = document.getElementById("aprvBomResult");
                extBomNo = bomSelect.value;
                if (!extBomNo) {
                    dhtmlx.alert("CCL-BOM을 검색 후 선택해주세요.");
                    return;
                }
            } else if (currentStepCd === '3') {
                extDcrDevNo = document.getElementById("aprvDcrDevNo").value.trim();
                if (!extDcrDevNo) {
                    dhtmlx.alert("도료사 개발번호를 입력해주세요.");
                    return;
                }
            } else if (currentStepCd === '4') {
                var postAtt = document.getElementById("aprvPostAtt").checked;
                if (!_checkProdSpecFile() && !postAtt) {
                    dhtmlx.alert("제품사양서 파일을 먼저 업로드하거나 '사후첨부'를 체크해주세요.");
                    return;
                }
                extPostAtt = postAtt ? 'Y' : 'N';
            }
        }

        var actionNm = (aprvResult === '2') ? '승인' : '반려';
        dhtmlx.confirm({
            ok: "확인", cancel: "취소",
            text: "[" + currentStepNm + "] 단계를 " + actionNm + "하시겠습니까?",
            callback: function(val) {
                if (val) {
                    lastApprovalRowId  = selectedRowId;
                    lastApprovalResult = aprvResult;
                    lastApprovalStepCd = currentStepCd;
                    lastSaveAction     = 'saveAprv';

                    form1.setItemValue("DEV_ID",         DEV_ID);
                    form1.setItemValue("AGR_STEP_CD",    currentStepCd);
                    form1.setItemValue("AGR_USER_ID",    myUserNo);
                    form1.setItemValue("OPINION_TEXT",   opinion);
                    form1.setItemValue("APRV_RESULT",    aprvResult);
                    form1.setItemValue("EXT_BOM_NO",     extBomNo);
                    form1.setItemValue("EXT_DCR_DEV_NO", extDcrDevNo);
                    form1.setItemValue("EXT_POST_ATT",   extPostAtt);
                    form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'saveAprv');
                    _closeApprovalModal();
                }
            }
        });
    };

    // 취소 버튼
    document.getElementById("aprvCancelBtn").onclick = function() {
        _closeApprovalModal();
    };

    // 포커스
    setTimeout(function() {
        var focusEl = document.getElementById("aprvDcrDevNo") || document.getElementById("aprvBomSearch") || document.getElementById("aprvOpinionInput");
        if (focusEl) focusEl.focus();
    }, 50);
}
// ===== 결재 처리 함수 끝 =====

// ===== 개발 중단 함수 =====
var _devStopModal = null;
function _closeDevStopModal() {
    if (_devStopModal && _devStopModal.parentNode) {
        _devStopModal.parentNode.removeChild(_devStopModal);
    }
    _devStopModal = null;
}

function devStop(eventName, formDivObj, referenceItem) {
    var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();
    var form1   = items['C108000240pop01_Form_1'];

    // 1) DEV_ID 존재 여부
    if (!DEV_ID) {
        dhtmlx.alert("저장 후 개발 중단할 수 있습니다.");
        return;
    }

    // 2) 이미 중단 여부
    var devPrgCd = form1.getItemValue("DEV_PRG_CD");
    if (devPrgCd === '8') {
        dhtmlx.alert("이미 중단된 의뢰입니다.");
        return;
    }

    // 3) step_1~7 모두 완료인지 확인
    var stepRowIds = ["step_1", "step_2", "step_3", "step_4", "step_5", "step_6", "step_7"];
    var aprvStatusIdx = gridObj.getColIndexById("APRV_STATUS");
    var allCompleted = true;
    for (var i = 0; i < stepRowIds.length; i++) {
        var aprvStatus = gridObj.cells(stepRowIds[i], aprvStatusIdx).getValue();
        if (aprvStatus !== '2') {
            allCompleted = false;
            break;
        }
    }
    if (allCompleted) {
        dhtmlx.alert("모든 결재가 완료된 의뢰는 중단할 수 없습니다.");
        return;
    }

    // 4) 접수담당자 본인 확인
    var devChrId = form1.getItemValue("DEV_CHR_ID");
    if ('<%=userNo%>' !== devChrId) {
        dhtmlx.alert("접수담당자만 개발을 중단할 수 있습니다.");
        return;
    }

    // 모달 생성
    _closeDevStopModal();
    var modal = document.createElement("div");
    modal.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:9999;display:flex;align-items:center;justify-content:center;";
    modal.innerHTML =
        '<div style="background:#fff;width:440px;padding:16px;border:1px solid #93AFBA;box-shadow:3px 3px 10px rgba(0,0,0,0.3);">' +
        '<div style="font-weight:bold;margin-bottom:12px;font-size:14px;">개발 중단</div>' +
        '<div style="margin-bottom:4px;font-size:12px;">중단 사유 <span style="color:red;">(필수)</span></div>' +
        '<textarea id="devStopReasonInput" rows="5" style="width:100%;box-sizing:border-box;resize:vertical;font-size:13px;" placeholder="중단 사유를 입력하세요."></textarea>' +
        '<div style="text-align:right;margin-top:10px;">' +
        '<button id="devStopConfirmBtn" style="margin-right:6px;padding:3px 12px;">확인</button>' +
        '<button id="devStopCancelBtn" style="padding:3px 12px;">취소</button>' +
        '</div></div>';
    document.body.appendChild(modal);
    _devStopModal = modal;

    var myUserNo = '<%=userNo%>';

    // 확인 버튼
    document.getElementById("devStopConfirmBtn").onclick = function() {
        var reason = document.getElementById("devStopReasonInput").value.trim();
        if (!reason) {
            dhtmlx.alert("중단 사유를 입력해주세요.");
            return;
        }

        dhtmlx.confirm({
            ok: "확인", cancel: "취소",
            text: "개발을 중단하시겠습니까?",
            callback: function(val) {
                if (val) {
                    lastSaveAction = 'saveDevStop';

                    form1.setItemValue("DEV_ID",       DEV_ID);
                    form1.setItemValue("AGR_USER_ID",  myUserNo);
                    form1.setItemValue("OPINION_TEXT",  reason);
                    form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'saveDevStop');
                    _closeDevStopModal();
                }
            }
        });
    };

    // 취소 버튼
    document.getElementById("devStopCancelBtn").onclick = function() {
        _closeDevStopModal();
    };

    // textarea 포커스
    document.getElementById("devStopReasonInput").focus();
}
// ===== 개발 중단 함수 끝 =====

// ===== 담당자 변경 함수 =====
var _changeUserModal = null;
function _closeChangeUserModal() {
    if (_changeUserModal && _changeUserModal.parentNode) {
        _changeUserModal.parentNode.removeChild(_changeUserModal);
    }
    _changeUserModal = null;
}

function printDivPopup(eventName, formDivObj, referenceItem) {
    var form1 = items['C108000240pop01_Form_1'];

    // 1) DEV_ID 존재 여부
    if (!DEV_ID) {
        dhtmlx.alert("저장된 의뢰가 없습니다.");
        return;
    }

    // 2) 중단 여부 확인
    var devPrgCd = form1.getItemValue("DEV_PRG_CD");
    if (devPrgCd === '8') {
        dhtmlx.alert("중단된 의뢰는 담당자를 변경할 수 없습니다.");
        return;
    }

    // 3) 같은 팀(부서) 소속 확인
    var devChrDept = form1.getItemValue("DEV_CHR_DEPT");
    var myDeptCd = userDeptCd;
    var currentChrId = form1.getItemValue("DEV_CHR_ID");
    if (devChrDept !== myDeptCd) {
        dhtmlx.alert("같은 팀 소속만 담당자를 변경할 수 있습니다.");
        return;
    }

    // 모달 생성
    _closeChangeUserModal();
    var modal = document.createElement("div");
    modal.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:9999;display:flex;align-items:center;justify-content:center;";
    modal.innerHTML =
        '<div style="background:#fff;width:500px;padding:16px;border:1px solid #93AFBA;box-shadow:3px 3px 10px rgba(0,0,0,0.3);">' +
        '<div style="font-weight:bold;margin-bottom:12px;font-size:14px;">담당자 변경</div>' +
        '<div style="margin-bottom:10px;">' +
        '  <input type="text" id="chgUserSearchKey" placeholder="이름 또는 사번 입력" style="width:300px;padding:3px 6px;font-size:13px;" />' +
        '  <button id="chgUserSearchBtn" style="margin-left:6px;padding:3px 12px;">검색</button>' +
        '</div>' +
        '<div id="chgUserResultArea" style="max-height:250px;overflow-y:auto;border:1px solid #ccc;margin-bottom:10px;">' +
        '<table style="width:100%;border-collapse:collapse;font-size:13px;">' +
        '<thead><tr style="background:#f0f0f0;"><th style="padding:4px 8px;border-bottom:1px solid #ccc;text-align:left;">사번</th><th style="padding:4px 8px;border-bottom:1px solid #ccc;text-align:left;">이름</th><th style="padding:4px 8px;border-bottom:1px solid #ccc;text-align:left;">부서</th></tr></thead>' +
        '<tbody id="chgUserResultBody"><tr><td colspan="3" style="padding:10px;text-align:center;color:#999;">검색 결과가 없습니다.</td></tr></tbody>' +
        '</table></div>' +
        '<div style="text-align:right;margin-top:10px;">' +
        '<button id="chgUserConfirmBtn" style="margin-right:6px;padding:3px 12px;">확인</button>' +
        '<button id="chgUserCancelBtn" style="padding:3px 12px;">취소</button>' +
        '</div></div>';
    document.body.appendChild(modal);
    _changeUserModal = modal;

    var selectedUser = null;

    // 검색 버튼 클릭
    document.getElementById("chgUserSearchBtn").onclick = function() {
        var searchKey = document.getElementById("chgUserSearchKey").value.trim();
        if (!searchKey) {
            dhtmlx.alert("검색어를 입력하세요.");
            return;
        }
        var param = "ServiceName=C108000240pop01-service&findUser=1"
            + "&column-info=USER_NO,USER_NAME,DEPT_CD,DEPT_NM"
            + "&SEARCH_KEY=" + encodeURIComponent(searchKey);
        var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
        var cells = xmlObj ? xmlObj.getElementsByTagName("cell") : [];
        var tbody = document.getElementById("chgUserResultBody");
        tbody.innerHTML = "";
        selectedUser = null;

        if (cells.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" style="padding:10px;text-align:center;color:#999;">검색 결과가 없습니다.</td></tr>';
            return;
        }

        var colsPerRow = 4;
        for (var i = 0; i < cells.length; i += colsPerRow) {
            var userNo   = (cells.item(i)   && cells.item(i).firstChild)   ? cells.item(i).firstChild.nodeValue   : "";
            var userName = (cells.item(i+1) && cells.item(i+1).firstChild) ? cells.item(i+1).firstChild.nodeValue : "";
            var deptCd   = (cells.item(i+2) && cells.item(i+2).firstChild) ? cells.item(i+2).firstChild.nodeValue : "";
            var deptNm   = (cells.item(i+3) && cells.item(i+3).firstChild) ? cells.item(i+3).firstChild.nodeValue : "";
            var tr = document.createElement("tr");
            tr.style.cursor = "pointer";
            tr.setAttribute("data-userno", userNo);
            tr.setAttribute("data-username", userName);
            tr.setAttribute("data-deptnm", deptNm);
            tr.innerHTML = '<td style="padding:4px 8px;border-bottom:1px solid #eee;">' + userNo + '</td>'
                         + '<td style="padding:4px 8px;border-bottom:1px solid #eee;">' + userName + '</td>'
                         + '<td style="padding:4px 8px;border-bottom:1px solid #eee;">' + deptNm + '</td>';
            (function(row) {
                row.onclick = function() {
                    var allRows = tbody.getElementsByTagName("tr");
                    for (var r = 0; r < allRows.length; r++) {
                        allRows[r].style.backgroundColor = "";
                    }
                    row.style.backgroundColor = "#d0e8ff";
                    selectedUser = {
                        userNo: row.getAttribute("data-userno"),
                        userName: row.getAttribute("data-username"),
                        deptNm: row.getAttribute("data-deptnm")
                    };
                };
            })(tr);
            tbody.appendChild(tr);
        }
    };

    // 엔터 키로 검색
    document.getElementById("chgUserSearchKey").onkeydown = function(e) {
        if (e.keyCode === 13) {
            document.getElementById("chgUserSearchBtn").onclick();
        }
    };

    // 확인 버튼
    document.getElementById("chgUserConfirmBtn").onclick = function() {
        if (!selectedUser) {
            dhtmlx.alert("변경할 담당자를 선택하세요.");
            return;
        }
        if (selectedUser.userNo === currentChrId) {
            dhtmlx.alert("현재 담당자와 동일한 사용자입니다.");
            return;
        }
        dhtmlx.confirm({
            ok: "확인", cancel: "취소",
            text: "담당자를 [" + selectedUser.userName + "](" + selectedUser.userNo + ")으로 변경하시겠습니까?",
            callback: function(val) {
                if (val) {
                    form1.setItemValue("DEV_ID", DEV_ID.replace(/-/g, ''));
                    form1.setItemValue("NEW_CHR_ID", selectedUser.userNo);
                    form1.setItemValue("BF_CHR_ID", currentChrId);
                    form1.setItemValue("BF_CHR_NM", form1.getItemValue("DEV_CHR_NM") || currentChrId);
                    form1.setItemValue("NEW_CHR_NM", selectedUser.userName);
                    // 'code : name' → raw code 복원
                    var _cf2 = ['CUS_CD','FNL_CUS_CD','ORD_USG_CD','NAT_CD'];
                    for (var _ci2 = 0; _ci2 < _cf2.length; _ci2++) {
                        var _v2 = form1.getItemValue(_cf2[_ci2]) || "";
                        if (_v2.indexOf(' : ') > -1) form1.setItemValue(_cf2[_ci2], _v2.split(' : ')[0]);
                    }
                    lastSaveAction = 'changeUser';
                    form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'changeUser');
                    _closeChangeUserModal();
                }
            }
        });
    };

    // 취소 버튼
    document.getElementById("chgUserCancelBtn").onclick = function() {
        _closeChangeUserModal();
    };

    // 검색 입력란 포커스
    document.getElementById("chgUserSearchKey").focus();
}
// ===== 담당자 변경 함수 끝 =====

// ===== Grid_1 로드 완료 후 처리담당부서 콤보 초기화 =====
function onGrid1LoadFunction() {
    try {
        var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();
        if (!gridObj) return;

        // 1) 부서 목록이 아직 없으면 onFormLoadFunction에서 로드 실패한 경우 → 여기서 재시도
        if (g1DeptArr.length === 0) {
            // LOV 서비스에서 전체 부서 조회 후 findDept 조건으로 필터링
            try {
                var lovResp = dhtmlxAjax.getSync(master_combo_url + '&category=SZ0000&code=DEPT_CD&orderBy=value');
                if (lovResp && lovResp.xmlDoc && lovResp.xmlDoc.responseXML) {
                    var optNodes = lovResp.xmlDoc.responseXML.getElementsByTagName("option");
                    for (var oi = 0; oi < optNodes.length; oi++) {
                        var optVal = optNodes[oi].getAttribute("value");
                        var optTxt = optNodes[oi].firstChild ? optNodes[oi].firstChild.nodeValue : "";
                        if (!optVal) continue;
                        var prefix4 = optVal.substring(0, 4);
                        if ((prefix4 === '5010' || prefix4 === '6000') && optVal !== '50106465') {
                            g1DeptArr.push([optVal, optTxt]);
                            g1DeptNameToCd[optTxt] = optVal;
                        }
                    }
                }
            } catch(e) { console.error("[Grid1Load] LOV fallback error:", e); }
        }
        console.log("[Grid1Load] g1DeptArr count:", g1DeptArr.length);

        // 2) 처리담당부서 콤보 초기화
        var deptColIdx = gridObj.getColIndexById("DEPT_NM");
        var deptCombo = gridObj.getColumnCombo(deptColIdx);

        if (deptCombo) {
            if (g1DeptArr.length > 0) {
                deptCombo.addOption(g1DeptArr);
            } else {
                // 최종 폴백: 필터 없이 전체 부서 로드
                deptCombo.loadXML(master_combo_url + '&category=SZ0000&code=DEPT_CD&orderBy=value');
            }
            deptCombo.enableOptionAutoPositioning(true);
            deptCombo.readonly(true, true);
            deptCombo.setOptionHeight(200);

            // 콤보 선택 시 DEPT_CD 숨김 컬럼에 코드 저장
            deptCombo.attachEvent("onSelectionChange", function(){
                var selRowId = gridObj.getSelectedRowId();
                if (selRowId) {
                    var deptCd = deptCombo.getSelectedValue();
                    if (!isNull(deptCd)) {
                        gridObj.cells(selRowId, gridObj.getColIndexById("DEPT_CD")).setValue(deptCd);
                    }
                }
            });
        }

        // 3) step_1(개발접수) — 신규 의뢰일 때 로그인 사용자 부서로 자동 표시
        if (!DEV_ID && userDeptCd) {
            var _s1DeptNm = userDeptNm;
            // 부서명이 없으면 AJAX로 조회
            if (!_s1DeptNm) {
                try {
                    var _dp = "ServiceName=C108000240pop01-service&findDeptInfo=1&USER_NO=<%=userNo%>&column-info=DEPT_CD,DEPT_NM";
                    var _dx = uiCommon.ajaxLoadData('c10AjaxData.do', _dp);
                    if (_dx) {
                        var _dc = _dx.getElementsByTagName("cell");
                        if (_dc.length >= 2 && _dc.item(1).firstChild) _s1DeptNm = _dc.item(1).firstChild.nodeValue;
                    }
                } catch(e3) {}
            }
            gridObj.cells("step_1", gridObj.getColIndexById("DEPT_NM")).setValue(_s1DeptNm || userDeptCd);
            gridObj.cells("step_1", gridObj.getColIndexById("DEPT_CD")).setValue(userDeptCd);
            gridObj.cells("step_8", gridObj.getColIndexById("DEPT_NM")).setValue(_s1DeptNm || userDeptCd);
            gridObj.cells("step_8", gridObj.getColIndexById("DEPT_CD")).setValue(userDeptCd);
        }

        // 4) step_1(자동승인), step_8(개발중단) 편집 차단, 기존 의뢰는 부서변경 모달 사용
        gridObj.attachEvent("onEditCell", function(stage, rId, cInd, nValue, oValue) {
            if (stage === 0) {
                var colId = gridObj.getColumnId(cInd);
                if (colId !== "DEPT_NM") return false;
                if (rId === "step_1") return false;
                if (rId === "step_8") return false;
                if (DEV_ID) return false;
            }
            return true;
        });

        // 5) step_8(개발중단) 처리담당부서 셀의 드롭다운 아이콘 숨김
        try {
            var _deptNmIdx = gridObj.getColIndexById("DEPT_NM");
            var _s8Cell = gridObj.cells("step_8", _deptNmIdx).cell;
            if (_s8Cell) {
                var _s8Divs = _s8Cell.getElementsByTagName("div");
                for (var _di = 0; _di < _s8Divs.length; _di++) {
                    _s8Divs[_di].style.display = "none";
                }
                _s8Cell.style.cursor = "default";
            }
        } catch(e2) {}

    } catch(e) {
        console.error("[Grid1Load] ERROR:", e);
    }

    // XLE 이벤트 해제
    try { items['C108000240pop01_Grid_1'].getDhxGrid().detachEvent(_onXLE1); } catch(e2) {}
}
// ===== Grid_1 헤더에 결재/반려 버튼 삽입 =====
function injectApprovalButton() {
    try {
        var allDivs = document.getElementsByTagName('div');
        var hdrEl = null;
        for (var i = 0; i < allDivs.length; i++) {
            var d = allDivs[i];
            if (d.innerHTML && d.innerHTML.indexOf('개발진도 및 결재관리') > -1 && !d.querySelector('table')) {
                if (!hdrEl || d.innerHTML.length < hdrEl.innerHTML.length) {
                    hdrEl = d;
                }
            }
        }
        if (!hdrEl) return;
        if (hdrEl.querySelector('.aprv-btn-bar')) return;

        var _btnStyle = 'height:20px;padding:0 8px;font-size:11px;font-weight:bold;line-height:18px;cursor:pointer;border-radius:3px;box-sizing:border-box;';
        var _btnBlue = _btnStyle + 'background:#D6E4F5;color:#003366;border:1px solid #7A9FD1;';
        var _btnRed  = _btnStyle + 'background:#F5D6D6;color:#660000;border:1px solid #D19A9A;';
        var btnSpan = document.createElement('span');
        btnSpan.className = 'aprv-btn-bar';
        btnSpan.style.cssText = 'float:right;position:relative;top:-5px;right:-5px;white-space:nowrap;';
        btnSpan.innerHTML = '<button onclick="approval(\'approval\',\'C108000240pop01_Form_1\',\'C108000240pop01_Grid_1\')" '
            + 'style="' + _btnBlue + 'margin-right:4px;"'
            + ' onmouseover="this.style.background=\'#B8D0EC\'" onmouseout="this.style.background=\'#D6E4F5\'">'
            + '결재/반려</button>'
            + '<button onclick="devStop(\'devStop\',\'C108000240pop01_Form_1\',\'C108000240pop01_Grid_1\')" '
            + 'style="' + _btnRed + 'margin-right:4px;"'
            + ' onmouseover="this.style.background=\'#ECC0C0\'" onmouseout="this.style.background=\'#F5D6D6\'">'
            + '개발중단</button>'
            + '<button onclick="changeDept()" '
            + 'style="' + _btnBlue + '"'
            + ' onmouseover="this.style.background=\'#B8D0EC\'" onmouseout="this.style.background=\'#D6E4F5\'">'
            + '부서변경</button>';
        hdrEl.appendChild(btnSpan);
    } catch(e) { console.error("[injectApprovalButton] error:", e); }
}
// ===== Grid_1 헤더에 결재/반려 버튼 삽입 끝 =====

// ===== Grid_1 로드 완료 후 처리담당부서 콤보 초기화 끝 =====

// ===== 처리담당부서 변경 모달 =====
function _closeDeptChangeModal() {
    if (_deptChangeModal && _deptChangeModal.parentNode) {
        _deptChangeModal.parentNode.removeChild(_deptChangeModal);
    }
    _deptChangeModal = null;
}

function changeDept() {
    if (!DEV_ID) {
        dhtmlx.alert("저장된 의뢰가 없습니다.");
        return;
    }
    var form1 = items['C108000240pop01_Form_1'];
    var devPrgCd = form1.getItemValue("DEV_PRG_CD");
    if (devPrgCd === '8' || devPrgCd === '8') {
        dhtmlx.alert("개발중단된 의뢰는 부서를 변경할 수 없습니다.");
        return;
    }
    var devChrId = form1.getItemValue("DEV_CHR_ID");
    if (devChrId !== '<%=userNo%>') {
        dhtmlx.alert("접수담당자만 부서를 변경할 수 있습니다.");
        return;
    }

    var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();
    var deptCdIdx     = gridObj.getColIndexById("DEPT_CD");
    var deptNmIdx     = gridObj.getColIndexById("DEPT_NM");
    var aprvStatusIdx = gridObj.getColIndexById("APRV_STATUS");
    var stepRowIds = ["step_1","step_2","step_3","step_4","step_5","step_6","step_7"];
    var stepNames  = ["개발접수","분석/개발","시편승인","사양승인","BOM등록","개발완료대기","개발완료"];

    // 테이블 행 생성
    var rowsHtml = "";
    for (var i = 0; i < stepRowIds.length; i++) {
        var aprvStatus = gridObj.cells(stepRowIds[i], aprvStatusIdx).getValue();
        var deptCd = gridObj.cells(stepRowIds[i], deptCdIdx).getValue();
        var deptNm = gridObj.cells(stepRowIds[i], deptNmIdx).getValue();
        var statusTxt = aprvStatus === '2' ? '<span style="color:blue;">완료</span>' : (aprvStatus === '3' ? '<span style="color:red;">중단</span>' : '-');

        rowsHtml += '<tr>';
        rowsHtml += '<td style="padding:5px 8px;border:1px solid #ccc;text-align:center;">' + stepNames[i] + '</td>';

        if (aprvStatus === '2') {
            rowsHtml += '<td style="padding:5px 8px;border:1px solid #ccc;background:#e8e8e8;">' + (deptNm || '') + '</td>';
        } else {
            rowsHtml += '<td style="padding:5px 8px;border:1px solid #ccc;"><select id="deptChg_' + (i+1) + '" style="width:100%;padding:2px;">';
            for (var d = 0; d < g1DeptArr.length; d++) {
                var sel = (g1DeptArr[d][0] === deptCd) ? ' selected' : '';
                rowsHtml += '<option value="' + g1DeptArr[d][0] + '"' + sel + '>' + g1DeptArr[d][1] + '</option>';
            }
            rowsHtml += '</select></td>';
        }

        rowsHtml += '<td style="padding:5px 8px;border:1px solid #ccc;text-align:center;width:60px;">' + statusTxt + '</td>';
        rowsHtml += '</tr>';
    }

    // 모달 생성
    _closeDeptChangeModal();
    var modal = document.createElement("div");
    modal.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:9999;display:flex;align-items:center;justify-content:center;";
    modal.innerHTML =
        '<div style="background:#fff;width:500px;padding:16px;border:1px solid #93AFBA;box-shadow:3px 3px 10px rgba(0,0,0,0.3);">' +
        '<div style="font-weight:bold;margin-bottom:12px;font-size:14px;">처리담당부서 변경</div>' +
        '<div style="font-size:11px;color:#888;margin-bottom:8px;">결재 완료된 단계는 변경할 수 없습니다.</div>' +
        '<table style="width:100%;border-collapse:collapse;font-size:12px;">' +
        '<thead><tr style="background:#f0f0f0;">' +
        '<th style="padding:5px 8px;border:1px solid #ccc;width:90px;">단계</th>' +
        '<th style="padding:5px 8px;border:1px solid #ccc;">처리담당부서</th>' +
        '<th style="padding:5px 8px;border:1px solid #ccc;width:60px;">상태</th>' +
        '</tr></thead><tbody>' + rowsHtml + '</tbody></table>' +
        '<div style="text-align:right;margin-top:12px;">' +
        '<button id="deptChangeConfirmBtn" style="margin-right:6px;padding:3px 14px;">저장</button>' +
        '<button id="deptChangeCancelBtn" style="padding:3px 14px;">취소</button>' +
        '</div></div>';
    document.body.appendChild(modal);
    _deptChangeModal = modal;

    // 저장 버튼
    document.getElementById("deptChangeConfirmBtn").onclick = function() {
        var form1   = items['C108000240pop01_Form_1'];
        var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();

        for (var si = 0; si < stepRowIds.length; si++) {
            var sel = document.getElementById("deptChg_" + (si+1));
            if (sel) {
                form1.setItemValue("DEPT_CD_" + (si+1), sel.value);
                gridObj.cells(stepRowIds[si], deptCdIdx).setValue(sel.value);
                gridObj.cells(stepRowIds[si], deptNmIdx).setValue(sel.options[sel.selectedIndex].text);
            } else {
                form1.setItemValue("DEPT_CD_" + (si+1), "");
            }
        }

        form1.setItemValue("DEV_ID", DEV_ID);
        lastSaveAction = 'saveDeptChange';
        form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'saveDeptChange');
        _closeDeptChangeModal();
    };

    // 취소 버튼
    document.getElementById("deptChangeCancelBtn").onclick = function() {
        _closeDeptChangeModal();
    };
}
// ===== 처리담당부서 변경 모달 끝 =====

// ===== 의견 입력 모달 전역 함수 =====
var _opinionStepCd = null;
var _opinionModal  = null;

function _saveOpinionModal() {
    var ta = document.getElementById("opinionTextInput");
    if (!ta || !ta.value.trim()) {
        dhtmlx.alert("의견을 입력해주세요.");
        return;
    }
    var form1 = items['C108000240pop01_Form_1'];
    form1.setItemValue("DEV_ID",       DEV_ID);
    form1.setItemValue("AGR_STEP_CD",  _opinionStepCd);
    form1.setItemValue("OPINION_TEXT", ta.value);
    form1.setItemValue("AGR_USER_ID",  '<%=userNo%>');
    lastSaveAction = 'saveOpinion';
    form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'saveOpinion');
    _closeOpinionModal();
}

function _closeOpinionModal() {
    if (_opinionModal && _opinionModal.parentNode) {
        _opinionModal.parentNode.removeChild(_opinionModal);
    }
    _opinionModal = null;
}
// ===== 의견 입력 모달 전역 함수 끝 =====

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
// function onLoadFunction(){ 
  	
//   	return true;
// }










//     console.log("TST_ANL_REQ_NO : " + TST_ANL_REQ_NO);

//     // 의뢰 전 처리
//     if (!TST_ANL_REQ_NO) {
<%--         form1.setItemValue("TST_ANL_REQ_ID", "<%=userNo%>"); --%>
<%--         form1.setItemValue("TST_ANL_REQ_NM", "<%=userName%>"); --%>
//         return;
//     }

//     // 의뢰 후 처리
//     form1.setItemValue("TST_ANL_REQ_NO", TST_ANL_REQ_NO);
//     var findUrl = uiCommon.parameters6('C108000240pop01_Form_1', 'C108000240pop01_Form_1', 'find');

//     form1.loadData(findUrl, function () {
//         var data = {};
//         var fields = [
//             "TST_PRD_NM1", "TST_ITM1", "TST_PRT1", "RMTL_MAK1", "COIL_ID1", "TST_SZ1", "GW_QTY1", "MQL_CD1", "TST_ETC",
//             "TST_PRD_NM2", "TST_ITM2", "TST_PRT2", "RMTL_MAK2", "COIL_ID2", "TST_SZ2", "GW_QTY2", "MQL_CD2",
//             "TST_PRD_NM3", "TST_ITM3", "TST_PRT3", "RMTL_MAK3", "COIL_ID3", "TST_SZ3", "GW_QTY3", "MQL_CD3"
//         ];

//         // getItemValue 결과를 한 번만 호출해서 data 객체에 담기
//         fields.forEach(f => data[f] = form1.getItemValue(f));

//         // TST_SEQ 처리 최적화
//         var tstSeq = form1.getItemValue("TST_SEQ") || "";
//         tstSeq.split(",").forEach(seq => {
//             var row = parseInt(seq, 10) - 1;
//             if (row >= 0) gridObj.cells(row, 2).setValue('1');
//         });

//         // grid2에 한 번에 데이터 넣기
//         var gridData = [
//             [data.TST_PRD_NM1, data.TST_PRD_NM2, data.TST_PRD_NM3],
//             [data.TST_ITM1, data.TST_ITM2, data.TST_ITM3],
//             [data.TST_PRT1, data.TST_PRT2, data.TST_PRT3],
//             [data.RMTL_MAK1, data.RMTL_MAK2, data.RMTL_MAK3],
//             [data.COIL_ID1, data.COIL_ID2, data.COIL_ID3],
//             [data.TST_SZ1, data.TST_SZ2, data.TST_SZ3],
//             [data.GW_QTY1, data.GW_QTY2, data.GW_QTY3],
//             [data.MQL_CD1, data.MQL_CD2, data.MQL_CD3],
//             [data.TST_ETC, "", ""]
//         ];

//         // grid2.clearAll();
//         for (let row = 0; row < gridData.length; row++) {
//             for (let col = 0; col < gridData[row].length; col++) {
//                 grid2.setCellValue(row + 1, col, gridData[row][col]);
//             }
//         }

//         emergencyChk();

//         uiCommon.progressOff(parent);
//         form1.getDhxForm().detachEvent(onXleForm);
//     });





	  
function onFormLoadFunction(formDivObj){

	var form1		= items['C108000240pop01_Form_1'];

    // 사용자 부서 정보: 세션에서 직접 가져옴 (AJAX 불필요)
    // AJAX 호출(findDeptInfo)이 서버 배포 상태에 따라 실패할 수 있으므로 세션 값 우선 사용
    if (!userDeptCd) {
        // 세션 값이 비어있으면 AJAX로 재시도
        try {
            var deptParam = "ServiceName=C108000240pop01-service&findDeptInfo=1&USER_NO=" + '<%= userNo%>' + "&column-info=DEPT_CD,DEPT_NM";
            var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', deptParam);
            if (xmlObj) {
                var cells = xmlObj.getElementsByTagName("cell");
                if (cells.length > 0) {
                    userDeptCd = cells.item(0).firstChild.nodeValue;
                    userDeptNm = cells.item(1).firstChild.nodeValue;
                }
            }
        } catch(e) { console.error("[FormLoad] findDeptInfo AJAX error:", e); }
    }
    console.log("[FormLoad] userDeptCd:", userDeptCd, "userDeptNm:", userDeptNm);

    // Grid_1 콤보용 부서 목록 조회
    if (g1DeptArr.length === 0) {
        // 1차: c10AjaxData.do의 findDept 쿼리 시도
        try {
            var deptListParam = "ServiceName=C108000240pop01-service&findDept=1&column-info=DEPT_CD,DEPT_NM";
            var deptListXml = uiCommon.ajaxLoadData('c10AjaxData.do', deptListParam);
            if (deptListXml) {
                var dlCells = deptListXml.getElementsByTagName("cell");
                for (var dli = 0; dli < dlCells.length; dli += 2) {
                    var dlCd = (dlCells.item(dli) && dlCells.item(dli).firstChild) ? dlCells.item(dli).firstChild.nodeValue : "";
                    var dlNm = (dlCells.item(dli+1) && dlCells.item(dli+1).firstChild) ? dlCells.item(dli+1).firstChild.nodeValue : "";
                    if (dlCd) { g1DeptNameToCd[dlNm] = dlCd; g1DeptArr.push([dlCd, dlNm]); }
                }
            }
        } catch(e) { console.error("[FormLoad] findDept AJAX error:", e); }

        // 2차: findDept가 빈 결과를 반환하면 LOV 서비스에서 전체 부서 조회 후 필터링
        if (g1DeptArr.length === 0) {
            try {
                var lovResp = dhtmlxAjax.getSync(master_combo_url + '&category=SZ0000&code=DEPT_CD&orderBy=value');
                if (lovResp && lovResp.xmlDoc && lovResp.xmlDoc.responseXML) {
                    var optNodes = lovResp.xmlDoc.responseXML.getElementsByTagName("option");
                    for (var oi = 0; oi < optNodes.length; oi++) {
                        var optVal = optNodes[oi].getAttribute("value");
                        var optTxt = optNodes[oi].firstChild ? optNodes[oi].firstChild.nodeValue : "";
                        if (!optVal) continue;
                        var prefix4 = optVal.substring(0, 4);
                        // findDept 쿼리 조건: SUBSTR(CD_V,1,4) in ('5010','6000') AND CD_V != '50106465'
                        if ((prefix4 === '5010' || prefix4 === '6000') && optVal !== '50106465') {
                            g1DeptArr.push([optVal, optTxt]);
                            g1DeptNameToCd[optTxt] = optVal;
                        }
                    }
                }
                console.log("[FormLoad] LOV fallback dept count:", g1DeptArr.length);
            } catch(lovErr) { console.error("[FormLoad] LOV fallback error:", lovErr); }
        } else {
            console.log("[FormLoad] findDept dept count:", g1DeptArr.length);
        }
    }

	var comboList = form1.getMasterCombos();

	// 비동기 콤보 로딩 완료 추적 (PRD_NM_CD, RSN_TP, NAT_CD, COT_TP, LUS_RT_CD)
	var _comboReadyCnt = 0;
	var _comboReadyTarget = 6;
	var _pendingGwAsgCd = '';

	function _onComboReady() {
		_comboReadyCnt++;
		if (_comboReadyCnt >= _comboReadyTarget && DEV_ID) {
			_loadSavedFormData();
		}
	}

	//수요가
// 	comboList['CUS_CD'].readonly(true,true);//
// 		ui.combo.master(comboList['CUS_CD'],'SZ0000','CUS_CD','totalValue=&,orderBy=value',function(){ 
// 		comboList['CUS_CD'].selectOption(0,true,true);		
// 		comboList['CUS_CD'].readonly(true);
// 		comboList['CUS_CD'].setOptionHeight(200);			
// 	});	
	
	
	//최종고객사
// 	comboList['FNL_CUS_CD'].readonly(true,true);//
// 		ui.combo.master(comboList['FNL_CUS_CD'],'SZ0000','CUS_CD','totalValue=&,orderBy=value',function(){ 
// 		comboList['FNL_CUS_CD'].selectOption(0,true,true);		
// 		comboList['FNL_CUS_CD'].readonly(true);
// 		comboList['FNL_CUS_CD'].setOptionHeight(200);			
// 	});	
	
	
	//용도
// 	comboList['ORD_USG_CD'].readonly(true,true);//
// 		ui.combo.master(comboList['ORD_USG_CD'],'SZ0000','ORD_USG_CD','totalValue=&,orderBy=value',function(){ 
// 		comboList['ORD_USG_CD'].selectOption(0,true,true);		
// 		comboList['ORD_USG_CD'].readonly(true);
// 		comboList['ORD_USG_CD'].setOptionHeight(200);			
// 	});	
	
	//제품군
	comboList['PRD_NM_CD'].readonly(true,true);//
		ui.combo.master(comboList['PRD_NM_CD'],'SJ0001','PRD_NM_CD','totalValue=&,orderBy=value',function(){
		comboList['PRD_NM_CD'].selectOption(0,true,true);
		comboList['PRD_NM_CD'].readonly(true);
		comboList['PRD_NM_CD'].setOptionHeight(200);
		_onComboReady();
	});	
	
// 	comboList['PRD_NM_CD'].DOMelem_input.onkeydown = function(e){
// 	key = (e) ? e.keyCode : event.keyCode;
// 		if(key==8 || key==116){
// 			if(e){   //표준         
// 				e.preventDefault();
// 			}
// 			else{ //익스용
// 				event.keyCode = 0;
// 				event.returnValue = false;
// 			}
// 		}
// 	}



		// 도금량: CCGI 기준(SG0000) 직접 로드 → GIX 제외 → 숫자 오름차순 정렬
		comboList['GW_ASG_CD'].readonly(true,true);
		try {
			var _gwResp = dhtmlxAjax.getSync(master_combo_url + '&category=SG0000&code=GW_ASG_CD&orderBy=value');
			var _gwOpts = [];
			if (_gwResp && _gwResp.xmlDoc && _gwResp.xmlDoc.responseXML) {
				var _gwNodes = _gwResp.xmlDoc.responseXML.getElementsByTagName("option");
				for (var _gi = 0; _gi < _gwNodes.length; _gi++) {
					var _gv = _gwNodes[_gi].getAttribute("value");
					var _gt = _gwNodes[_gi].firstChild ? _gwNodes[_gi].firstChild.nodeValue : "";
					if (_gv && _gt.indexOf('GIX') === -1) _gwOpts.push([_gv, _gt]);
				}
			}
			// 공백(도금없음) + 20g/㎡ 하드코딩 추가
			_gwOpts.push(['A', '없음']);
			_gwOpts.push(['B', '20 g/㎡']);
			_gwOpts.sort(function(a, b) {
				var na = parseInt((a[1].match(/\d+/) || ['0'])[0], 10);
				var nb = parseInt((b[1].match(/\d+/) || ['0'])[0], 10);
				return na - nb;
			});
			comboList['GW_ASG_CD'].addOption(_gwOpts);
		} catch(e) { console.error("[GW_ASG_CD load] error:", e); }
		comboList['GW_ASG_CD'].selectOption(0,true,true);
		comboList['GW_ASG_CD'].readonly(true);
		comboList['GW_ASG_CD'].setOptionHeight(200);
		if (_pendingGwAsgCd) { form1.setItemValue('GW_ASG_CD', _pendingGwAsgCd); _pendingGwAsgCd = ''; }
		_onComboReady();
















	//도금량
// 	comboList['GW_ASG_CD'].readonly(true,true);//INK TYPE
// 		ui.combo.master(comboList['GW_ASG_CD'],'SZ0000','GW_ASG_CD','totalValue=&,orderBy=value',function(){ 
// 		comboList['GW_ASG_CD'].selectOption(0,true,true);		
// 		comboList['GW_ASG_CD'].readonly(true);
// 		comboList['GW_ASG_CD'].setOptionHeight(200);			
// 	});	
	
	//도료타입
	comboList['RSN_TP'].readonly(true,true);//INK TYPE
		ui.combo.master(comboList['RSN_TP'],'SZ0000','RSN_TP','totalValue=&,orderBy=value',function(){
		comboList['RSN_TP'].selectOption(0,true,true);
		comboList['RSN_TP'].readonly(true);
		comboList['RSN_TP'].setOptionHeight(200);
		_onComboReady();
	});	
	
	//국가 — 돋보기 팝업으로 변경, 콤보 제거
	_onComboReady();	
	
	//보호필름
	comboList["PTT_FLM"].addOption([['N', 'N - 없음'], ['Y', 'Y - 보호필름부착']]);
	comboList["PTT_FLM"].selectOption(0,true,true);
	comboList["PTT_FLM"].readonly(true);	
	
	//코팅타입
	comboList['COT_TP'].readonly(true,true);//INK TYPE
		ui.combo.master(comboList['COT_TP'],'AP0000','COT_TP','totalValue=&,orderBy=value',function(){
		comboList['COT_TP'].selectOption(0,true,true);
		comboList['COT_TP'].readonly(true);
		comboList['COT_TP'].setOptionHeight(200);
		_onComboReady();
	});
	
	//광택도
	comboList['LUS_RT_CD'].readonly(true,true);//INK TYPE
		ui.combo.master(comboList['LUS_RT_CD'],'SZ0000','LUS_RT_CD','totalValue=&,orderBy=value',function(){
		comboList['LUS_RT_CD'].selectOption(0,true,true);
		comboList['LUS_RT_CD'].readonly(true);
		comboList['LUS_RT_CD'].setOptionHeight(200);
		_onComboReady();
	});		
	
	//소재보증
	comboList["MTL_GRT"].addOption(comboMtlGrt);
	comboList["MTL_GRT"].selectOption(0,true,true);
	comboList["MTL_GRT"].readonly(true);	
	
	//도막보증	
	comboList["PNT_FLM_GRT"].addOption(comboFlmGrt);
	comboList["PNT_FLM_GRT"].selectOption(0,true,true);
	comboList["PNT_FLM_GRT"].readonly(true);	
	
// 	console.log("TST_ANL_REQ_NO : "+TST_ANL_REQ_NO);


	// 폼 데이터 로딩 함수 — 모든 콤보 로딩 완료 후 _onComboReady()에서 호출
	function _loadSavedFormData() {
		items['C108000240pop01_Form_1'].setItemValue("DEV_ID",DEV_ID);

		try {
		var findParam = "ServiceName=C108000240pop01-service&find=1"
			+ "&column-info=DEV_ID,DEV_PRG_CD,DEV_SBJ,FNL_CUS_CD,CUS_CD,ORD_USG_CD,PRD_NM_CD,GW_ASG_CD,RSN_TP,COT_TP,DEV_REQ_DD,DEV_END_DD,LAST_UPDATE_DD,DEV_CHR_DEPT,DEV_CHR_DEPT_NM,DEV_CHR_ID,DEV_CHR_NM,CLR_NM,RAL_CD,NAT_CD,PNT_FLM_THK,MTL_GRT,PTT_FLM,CCL_BOM_NO,LUS_RT_CD,PNT_FLM_GRT,DEV_ETC"
			+ "&DEV_ID=" + encodeURIComponent(DEV_ID);
		var findXml = uiCommon.ajaxLoadData('c10AjaxData.do', findParam);
		if (findXml) {
			var fCells = findXml.getElementsByTagName("cell");
			var fFields = ["DEV_ID","DEV_PRG_CD","DEV_SBJ","FNL_CUS_CD","CUS_CD","ORD_USG_CD","PRD_NM_CD","GW_ASG_CD","RSN_TP","COT_TP","DEV_REQ_DD","DEV_END_DD","LAST_UPDATE_TIMESTAMP","DEV_CHR_DEPT","DEV_CHR_DEPT_NM","DEV_CHR_ID","DEV_CHR_NM","CLR_NM","RAL_CD","NAT_CD","PNT_FLM_THK","MTL_GRT","PTT_FLM","CCL_BOM_NO","LUS_RT_CD","PNT_FLM_GRT","DEV_ETC"];
			// GW_ASG_CD 값을 먼저 저장 (PRD_NM_CD 설정 시 onSelectionChange → GW_ASG_CD 로드보다 선행해야 함)
			var gwIdx = 7; // GW_ASG_CD index in fFields
			if (gwIdx < fCells.length) {
				_pendingGwAsgCd = (fCells.item(gwIdx) && fCells.item(gwIdx).firstChild) ? fCells.item(gwIdx).firstChild.nodeValue : "";
			}
			for (var fi = 0; fi < fFields.length && fi < fCells.length; fi++) {
				if (fFields[fi] === 'GW_ASG_CD') continue;
				var fVal = (fCells.item(fi) && fCells.item(fi).firstChild) ? fCells.item(fi).firstChild.nodeValue : "";
				if (fVal === null || fVal === undefined) fVal = "";
				form1.setItemValue(fFields[fi], fVal);
			}
			// GW_ASG_CD: 콤보 로딩 완료까지 폴링 재시도 (콜백 타이밍 이슈 보완)
			if (_pendingGwAsgCd) {
				var _gwTarget = _pendingGwAsgCd;
				(function _ensureGw(n) {
					if (n <= 0) return;
					setTimeout(function() {
						try {
							form1.setItemValue('GW_ASG_CD', _gwTarget);
							if (form1.getItemValue('GW_ASG_CD') === _gwTarget) return;
						} catch(e) {}
						_ensureGw(n - 1);
					}, 100);
				})(20);
			}
		}
		} catch(e) { console.error("[FormLoad] find AJAX error:", e); }

		// Grid_1 로드 완료 후 결재 데이터 반영
		(function _waitGrid() {
			var g1 = items['C108000240pop01_Grid_1'];
			var gridObj = g1 ? g1.getDhxGrid() : null;
			if (!gridObj || gridObj.getRowsNum() === 0) { setTimeout(_waitGrid, 50); return; }

	    	var devChrDept   = form1.getItemValue("DEV_CHR_DEPT");
	    	var devChrDeptNm = form1.getItemValue("DEV_CHR_DEPT_NM");
	    	if (devChrDept) {
	    		gridObj.cells("step_8", gridObj.getColIndexById("DEPT_NM")).setValue(devChrDeptNm);
	    		gridObj.cells("step_8", gridObj.getColIndexById("DEPT_CD")).setValue(devChrDept);
	    	}

	    	var aprvParam = "ServiceName=C108000240pop01-service&findAprv=1"
	    		+ "&column-info=DEV_PRG_CD,APRV_STATUS_NM,DEPT_NM,APRV_USER_NM,APRV_DT,OPINION,DEPT_CD,APRV_USER,APRV_STATUS"
	    		+ "&DEV_ID=" + encodeURIComponent(DEV_ID);
	    	var aprvXmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', aprvParam);
	    	var aprvCells = aprvXmlObj ? aprvXmlObj.getElementsByTagName("cell") : [];

	    	var colsPerRow = 9;
	    	var stepRowMap = {'1':'step_1', '2':'step_2', '3':'step_3', '4':'step_4', '5':'step_5', '6':'step_6', '7':'step_7', '8':'step_8'};

	    	for (var ai = 0; ai < aprvCells.length; ai += colsPerRow) {
	    		var getCellVal = function(idx) {
	    			return (aprvCells.item(idx) && aprvCells.item(idx).firstChild) ? aprvCells.item(idx).firstChild.nodeValue : "";
	    		};

	    		var devPrgCd     = getCellVal(ai);
	    		var aprvStatusNm = getCellVal(ai + 1);
	    		var deptNm       = getCellVal(ai + 2);
	    		var aprvUserNm   = getCellVal(ai + 3);
	    		var aprvDt       = getCellVal(ai + 4);
	    		var opinion      = getCellVal(ai + 5);
	    		var deptCd       = getCellVal(ai + 6);
	    		var aprvUser     = getCellVal(ai + 7);
	    		var aprvStatus   = getCellVal(ai + 8);

	    		var rowId = stepRowMap[devPrgCd];
	    		if (!rowId) continue;

	    		gridObj.cells(rowId, gridObj.getColIndexById("APRV_STATUS_NM")).setValue(aprvStatusNm);
	    		gridObj.cells(rowId, gridObj.getColIndexById("DEPT_NM")).setValue(deptNm);
	    		gridObj.cells(rowId, gridObj.getColIndexById("APRV_USER_NM")).setValue(aprvUserNm);
	    		gridObj.cells(rowId, gridObj.getColIndexById("APRV_DT")).setValue(aprvDt);
	    		gridObj.cells(rowId, gridObj.getColIndexById("OPINION")).setValue(opinion);
	    		gridObj.cells(rowId, gridObj.getColIndexById("DEPT_CD")).setValue(deptCd);
	    		gridObj.cells(rowId, gridObj.getColIndexById("APRV_USER")).setValue(aprvUser);
	    		gridObj.cells(rowId, gridObj.getColIndexById("APRV_STATUS")).setValue(aprvStatus);
	    	}
	    	console.log("findAprv 로드 완료, 건수:", aprvCells.length / colsPerRow);

	    	// 결재 상태별 행 스타일링
	    	applyAprvRowStyles();
		})();

		// 특이사항 그리드 확실히 로드
		try { reloadEtcGrid(); } catch(e) { console.error("[FormLoad] reloadEtcGrid error:", e); }
		// BOM 변경 버튼 상태 갱신
		setTimeout(function() { _updateBomChgBtn(); }, 300);

		// 기존 의뢰: 콤보 + 캘린더 readonly (데이터 로드 완료 후)
		setTimeout(function() {
			try {
				var _cl = form1.getMasterCombos();
				var _rc = ['PRD_NM_CD','GW_ASG_CD','RSN_TP','PTT_FLM','COT_TP','LUS_RT_CD','MTL_GRT','PNT_FLM_GRT'];
				for (var _i = 0; _i < _rc.length; _i++) {
					try { if (_cl[_rc[_i]]) _cl[_rc[_i]].disable(true); } catch(e2) {}
				}
			} catch(e) {}
			try {
				var _fd = document.getElementById('C108000240pop01_Form_1');
				var _ci = _fd.getElementsByTagName('input');
				for (var _j = 0; _j < _ci.length; _j++) {
					if (_ci[_j].name === 'DEV_END_DD') {
						_ci[_j].readOnly = true;
						var _cp = _ci[_j].parentNode;
						if (_cp) { var _imgs = _cp.getElementsByTagName('img'); for (var _k = 0; _k < _imgs.length; _k++) { _imgs[_k].onclick = function(e){e.preventDefault();e.stopPropagation();return false;}; _imgs[_k].style.opacity='0.3'; _imgs[_k].style.cursor='default'; } }
						break;
					}
				}
			} catch(e) {}
		}, 500);

		uiCommon.progressOff(parent);
		items['C108000240pop01_Form_1'].getDhxForm().detachEvent(onXleForm);
	}

	if(DEV_ID == null || DEV_ID == ""){
		// 신규 의뢰 — 개발접수일 자동 설정 (서버 저장 시 SYSDATE 사용, 화면은 오늘 날짜 표시)
		form1.setItemValue("DEV_REQ_DD", uiCommon.getCurrentDate());
	} else {
		// 기존 의뢰 — 저장 버튼 비활성화 + 폼 필드 readonly
		form1.getDhxForm().disableItem("save");
		// input 필드 readonly
		var _roFields = ['DEV_SBJ','CUS_CD','CLR_NM','FNL_CUS_CD','ORD_USG_CD','NAT_CD','PNT_FLM_THK','RAL_CD','DEV_ETC'];
		var _formDiv = document.getElementById('C108000240pop01_Form_1');
		if (_formDiv) {
			var _allInputs = _formDiv.getElementsByTagName('input');
			var _allTextareas = _formDiv.getElementsByTagName('textarea');
			var _roSet = {};
			for (var _ri = 0; _ri < _roFields.length; _ri++) _roSet[_roFields[_ri]] = true;
			for (var _ii = 0; _ii < _allInputs.length; _ii++) {
				if (_roSet[_allInputs[_ii].name]) _allInputs[_ii].readOnly = true;
			}
			for (var _ti = 0; _ti < _allTextareas.length; _ti++) {
				if (_roSet[_allTextareas[_ti].name]) _allTextareas[_ti].readOnly = true;
			}
		}
		// 완료목표: 달력 변경 시 원래 값으로 되돌림
		var _savedEndDd = form1.getItemValue("DEV_END_DD") || "";
		form1.getDhxForm().attachEvent("onChange", function(name, value) {
			if (name === "DEV_END_DD" && DEV_ID) {
				form1.setItemValue("DEV_END_DD", _savedEndDd);
			}
		});
	}

	// 필수값 빨간색 * 표시
	var _reqFields = ['DEV_SBJ','CUS_CD','CLR_NM','FNL_CUS_CD','ORD_USG_CD','PRD_NM_CD','GW_ASG_CD','DEV_END_DD','RSN_TP','PTT_FLM','COT_TP','MTL_GRT','PNT_FLM_GRT'];
	var _dhxForm = form1.getDhxForm();
	for (var _ri = 0; _ri < _reqFields.length; _ri++) {
		try {
			var _lbl = _dhxForm.getItemLabel(_reqFields[_ri]);
			if (_lbl && _lbl.indexOf('*') === -1) {
				_dhxForm.setItemLabel(_reqFields[_ri], _lbl + '<span style="color:red;font-size:9px;vertical-align:super;margin-left:1px;">*</span>');
			}
		} catch(e) {}
	}

	// 기존 의뢰: _loadSavedFormData()는 _onComboReady()에서 5개 콤보 로딩 완료 후 자동 호출됨

}


                            // function approval(){
                            // 	var grid = items['C108000240pop01_Grid_4'];
                            // 	var gridObj = grid.getDhxGrid();
                            // 	var form1 = items['C108000240pop01_Form_1'];
                            // 	var TST_ANL_PRG_CD = "";

                            // 	var prg_cd = form1.getItemValue("TST_ANL_PRG_CD");

                            // 	if(prg_cd == '1'){
                            // 		TST_ANL_PRG_CD = '2';
                            // 	}else if(prg_cd == '2'){
                            // 		TST_ANL_PRG_CD = '3';
                            // 	}else if(prg_cd == '3'){
                            // 		TST_ANL_PRG_CD = '4';
                            // 	}else{
                            // 		TST_ANL_PRG_CD = '5';
                            // 	}

                            // 	items['C108000240pop01_Form_1'].setItemValue("TST_ANL_PRG_CD",TST_ANL_PRG_CD);	
                            // // 	gridObj.cells(0, gridObj.getColIndexById("TST_ANL_REQ_NO")).setValue(TST_ANL_REQ_NO);

                            // 	dhtmlx.confirm({
                            // 		ok:"확인", cancel:"취소",
                            // 		text:" 승인하시겠습니까? ",
                            // 		callback:function(val){
                            // 		 if(val){
                            // //				items[referenceItem].sendGrid(referenceItem,eventName);
                            // // 				grid.sendGrid('C108000240pop01_Form_1','approval');	 				
                            // 			items['C108000240pop01_Form_1'].sendForm("handleDataProcess.do",'C108000240pop01_Form_1','approval');
                            // 			return;
                            // 		 }
                            // 		}
                            // 	});		


                            // }

                            // function approval() {
                            // 	approvalOrBack('Y');
                            // }

                            // function sendback(){
                            // 	approvalOrBack('N');
                            // }


                            /* 
                            function approvalOrBack(agr_yn) {
                            //     var grid    = items['C108000240pop01_Grid_4'];
                                var gridObj = grid.getDhxGrid();
                                var form1   = items['C108000240pop01_Form_1'];
                                var TST_ANL_PRG_CD = form1.getItemValue("TST_ANL_PRG_CD");
                                var rowNum = 0;
                                var agrComment = (agr_yn === 'Y' ? '승인' : '반려');
                            
                                var TST_RGN1_YN = form1.getItemValue("TST_RGN1_YN");
                                var TST_RGN2_YN = form1.getItemValue("TST_RGN2_YN");
                                var TST_RGN3_YN = form1.getItemValue("TST_RGN3_YN");
                            
                                // 반려된 건 재처리 방지
                                if ([TST_RGN1_YN, TST_RGN2_YN, TST_RGN3_YN].includes('N')) {
                                    dhtmlx.alert("반려 건은 " + agrComment + "할 수 없습니다.");
                                    return;
                                }
                            
                                // 다음 단계 코드 결정
                                var nextPrgCd = '';
                                var deptColId = null, userColId = null;
                            
                                if (TST_ANL_PRG_CD == '1') {
                                    rowNum = 1; 
                                    nextPrgCd = '2';
                                    deptColId = "TST_PFM2_DEPT"; 
                                    userColId = "TST_PFM2_ID";
                                } else if (TST_ANL_PRG_CD == '2') {
                                    rowNum = 2; 
                                    nextPrgCd = '3';
                                    deptColId = "TST_PFM3_DEPT"; 
                                    userColId = "TST_PFM3_ID";
                                } else if (TST_ANL_PRG_CD == '3') {
                                    rowNum = 3; 
                                    nextPrgCd = '4';
                                } else if (TST_ANL_PRG_CD == '4') {
                                    dhtmlx.alert('이미 합의완료된 건입니다.');
                                    return;
                                } else if (TST_ANL_PRG_CD == '5') {
                                    dhtmlx.alert('반려된 의뢰입니다.');
                                    return;
                                } else {
                                    dhtmlx.alert('의뢰 전 ' + agrComment + ' 불가능 합니다.');
                                    return;
                                }
                                
                                // 현재 단계 담당자 일치 확인 
                                  var userChk = gridObj.cells2(rowNum-1, 3).getValue();     
                            
                            */
                            //현재 담당자만 결재가능하도록 , 임시 주석 처리 
                            //         dhtmlx.alert("현재 단계에서 "+agrComment+"할 담당자가 아닙니다.");
                            //         return;
                            //     }    


                            /*
                            //반려일 경우 활용
                            items['C108000240pop01_Form_1'].setItemValue("REJECT_STEP", nextPrgCd);
                        
                            // 승인(Y)에서만 다음 담당자 체크
                            var rowId = gridObj.getRowId(rowNum);
                            var userNo;
                            if (deptColId && userColId) {
                                var deptVal = gridObj.cells2(rowNum, 2).getValue();
                                var userVal = gridObj.cells2(rowNum, 3).getValue();
                                userNo = gridObj.getUserData(rowId, "user_no");
                                if (!userVal || !deptVal) {
                                    if (agr_yn === 'Y') {
                                        dhtmlx.alert("다음 단계 담당자를 반드시 선택해야 합니다.");
                                        return;
                                    }
                                }
                            }
                        
                            // -----------------------
                            // 반려(N) 처리
                            // -----------------------
                            if (agr_yn === 'N') {
                                nextPrgCd = '5';
                        
                                // 전역(부모 window)에 초기화
                                window.popReRs = undefined;
                                window.popAction = undefined;
                        
                                // 팝업 열기
                                winObj = new ui.window("popup", "반려사유", "0", "0", "349", "174", "C108000240pop01_pop01.jsp");
                                winObj.setButtonDisable("park,minmax1");
                        
                                // 팝업 닫힘 이벤트
                                winObj.getDhxWindow().attachEvent("onClose", function(){
                                    this.hide();
                        
                                    // 확인(OK)일 때만 진행
                                    if (window.popAction !== "ok") {
                                        return; // 취소 시 아무 것도 하지 않음
                                    }
                        
                                    var rejectReason = window.popReRs; // 부모창 전역값 참조
                                    if (!rejectReason || rejectReason.trim() === "") {
                                        dhtmlx.alert("반려 사유를 입력해주세요.");
                                        return;
                                    }
                        */
                            // 값 세팅
                            //             form1.setItemValue("TST_ANL_REJECT_RS", rejectReason);

                            /*
                                        // Confirm 실행
                                        dhtmlx.confirm({
                                            ok: "확인", cancel: "취소",
                                            text: "반려하시겠습니까?",
                                            callback: function (val) {
                                                if (!val) return;
                                                
                                                if (rowNum == '1') {
                                                    form1.setItemValue("TST_RGN1_YN", 'N');
                            //                         form1.setItemValue("TST_PFM2_ID", userNo);
                                                } else if (rowNum == '2') {
                                                    form1.setItemValue("TST_RGN2_YN", 'N');
                            //                         form1.setItemValue("TST_PFM3_ID", userNo);
                                                } else if (rowNum == '3') {
                                                    form1.setItemValue("TST_RGN3_YN", 'N');
                                                }
                                                
                                                console.log("1 : "+form1.getItemValue("TST_RGN1_YN"));
                                                console.log("2 : "+form1.getItemValue("TST_RGN2_YN"));
                                                console.log("3 : "+form1.getItemValue("TST_RGN3_YN"));
                            
                                                // 반려 처리
                                                form1.setItemValue("TST_ANL_PRG_CD", nextPrgCd);
                                                grid.setCellValue(0, gridObj.getColIndexById("TST_ANL_PRG_CD"), nextPrgCd);
                                                grid.setCellValue(0, gridObj.getColIndexById("TST_ANL_REQ_NO"), form1.getItemValue("TST_ANL_REQ_NO"));
                            
                                                chkReqEmpInfo(form1.getItemValue("TST_ANL_REQ_ID"));
                                                form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'approval');
                                            }
                                        });
                                    });
                            
                                    return; // 반려는 여기서 종료(아래 공통 confirm 진입 방지)
                                }
                            
                                // -----------------------
                                // 승인(Y) 처리
                                // -----------------------
                                dhtmlx.confirm({
                                    ok: "확인", cancel: "취소",
                                    text: "승인하시겠습니까?",
                                    callback: function (val) {
                                        if (!val) return;
                            
                                        if (TST_ANL_PRG_CD == '1') {
                                            form1.setItemValue("TST_RGN1_YN", 'Y');
                                            form1.setItemValue("TST_PFM2_ID", userNo);
                                        } else if (TST_ANL_PRG_CD == '2') {
                                            form1.setItemValue("TST_RGN2_YN", 'Y');
                                            form1.setItemValue("TST_PFM3_ID", userNo);
                                        } else if (TST_ANL_PRG_CD == '3') {
                                            form1.setItemValue("TST_RGN3_YN", 'Y');
                                        }
                            
                                        form1.setItemValue("TST_ANL_PRG_CD", nextPrgCd);
                                        grid.setCellValue(0, gridObj.getColIndexById("TST_ANL_PRG_CD"), nextPrgCd);
                                        grid.setCellValue(0, gridObj.getColIndexById("TST_ANL_REQ_NO"), form1.getItemValue("TST_ANL_REQ_NO"));
                            
                                        if (TST_ANL_PRG_CD != '3') chkEmpInfo(userNo);
                                        form1.sendForm("handleDataProcess.do", 'C108000240pop01_Form_1', 'approval');
                                    }
                                });
                            }
                            */

                            /*
                            function chkEmpInfo(userVal){
                            	
                                var param = "ServiceName=C108000240pop01-service";
                                param += "&findEmpInfo=1";
                                param += "&RECEIVE_USER_ID="+userVal;
                                param += "&column-info=PHN_NO,EMAIL,USER_NO,USER_NAME";
                                var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
                                var cells  = xmlObj.getElementsByTagName("cell");
                            
                                if(cells.length > 0){
                                    items['C108000240pop01_Form_1'].setItemValue("PHN_NO", cells.item(0).firstChild.nodeValue);
                                    items['C108000240pop01_Form_1'].setItemValue("EMAIL", cells.item(1).firstChild.nodeValue);
                                    items['C108000240pop01_Form_1'].setItemValue("RECEIVE_USER_NAME", cells.item(3).firstChild.nodeValue);        	 
                                }else{
                                     dhtmlx.alert("다음 담당자의 휴대폰번호가 없습니다.");
                                     return;
                                }
                            	
                            }
                            */

                            function chkReqEmpInfo(userVal) {

                                var param = "ServiceName=C108000240pop01-service";
                                param += "&findReqEmpInfo=1";
                                param += "&TST_ANL_REQ_ID=" + userVal;
                                param += "&column-info=HND_PHN_NO,EMAIL,USER_NO,USER_NAME";
                                var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
                                var cells = xmlObj.getElementsByTagName("cell");

                                if (cells.length > 0) {
                                    items['C108000240pop01_Form_1'].setItemValue("PHN_NO", cells.item(0).firstChild.nodeValue);
                                    items['C108000240pop01_Form_1'].setItemValue("EMAIL", cells.item(1).firstChild.nodeValue);
                                    items['C108000240pop01_Form_1'].setItemValue("RECEIVE_USER_NAME", cells.item(3).firstChild.nodeValue);
                                } else {
                                    dhtmlx.alert("의뢰자의 휴대폰번호가 없습니다.");
                                    return
                                }

                            }



                            /* 순차합의 기능 사용 안함
                            function onGrid4LoadFunction(){
                                var grid    = items['C108000240pop01_Grid_4'];
                                var gridObj = grid.getDhxGrid();
                                var form1   = items['C108000240pop01_Form_1'];
                            
                                // 서버 데이터 조회 (CHR_TP 포함)
                                var param = "ServiceName=C108000240pop01-service";
                                param += "&findRole=1";    
                                param += "&column-info=CHR_TP,DEPT_CD,DEPT_CD_NM,USER_NO,USER_NAME";
                                var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
                                var cells  = xmlObj.getElementsByTagName("cell");
                            
                                // 역할별 맵 초기화
                                var roleMaps = {
                                    PFM1: { deptCodeToName:{}, deptNameToCode:{}, userMap:{} },
                                    PFM2: { deptCodeToName:{}, deptNameToCode:{}, userMap:{} },
                                    PFM3: { deptCodeToName:{}, deptNameToCode:{}, userMap:{} }
                                };
                            
                                function roleByTp(tp){
                                    if(tp=="3") return "PFM1";
                                    if(tp=="2") return "PFM2";
                                    if(tp=="1") return "PFM3";
                                    return null;
                                }
                                function roleByColId(colId){
                                    if(!colId) return null;
                                    if(/PFM1_/.test(colId)) return "PFM1";
                                    if(/PFM2_/.test(colId)) return "PFM2";
                                    if(/PFM3_/.test(colId)) return "PFM3";
                                    return null;
                                }
                            
                                // XML -> roleMaps 채우기 (cells는 5개씩: CHR_TP,DEPT_CD,DEPT_CD_NM,USER_NO,USER_NAME)
                                for(var i=0; i<cells.length; i+=5){
                                    var tp      = (cells.item(i)   && cells.item(i).firstChild)   ? cells.item(i).firstChild.nodeValue   : "";
                                    var deptCd  = (cells.item(i+1) && cells.item(i+1).firstChild) ? cells.item(i+1).firstChild.nodeValue : "";
                                    var deptNm  = (cells.item(i+2) && cells.item(i+2).firstChild) ? cells.item(i+2).firstChild.nodeValue : "";
                                    var userNo  = (cells.item(i+3) && cells.item(i+3).firstChild) ? cells.item(i+3).firstChild.nodeValue : "";
                                    var userNm  = (cells.item(i+4) && cells.item(i+4).firstChild) ? cells.item(i+4).firstChild.nodeValue : "";
                            
                                    var role = roleByTp(tp);
                                    if(!role || !deptCd) continue;
                            
                                    var rm = roleMaps[role];
                                    rm.deptCodeToName[deptCd] = deptNm || "";
                                    if(deptNm) rm.deptNameToCode[deptNm] = deptCd;
                                    if(!rm.userMap[deptCd]) rm.userMap[deptCd] = [];
                                    rm.userMap[deptCd].push({userNo:userNo,userName:userNm});
                                }
                            
                                // 셀의 XML id(논리 컬럼 id)를 안전하게 가져오기 (여러 케이스 시도 후 헤더로 폴백)
                                function getLogicalCellId(rId, cInd){
                                    try{
                                        var cellObj = gridObj.cells(rId, cInd);
                                        if(cellObj && cellObj.cell){
                                            var dom = cellObj.cell;
                                            // 보편적: DOM의 id 속성
                                            var idAttr = dom.getAttribute && dom.getAttribute("id");
                                            if(idAttr) return idAttr;
                                            // 다른 가능성들: column_id, name, data-id 등
                                            var alt = (dom.getAttribute && (dom.getAttribute("column_id") || dom.getAttribute("col_id") || dom.getAttribute("name") || dom.getAttribute("data-id"))) || dom.id || null;
                                            if(alt) return alt;
                                        }
                                    }catch(e){}
                                    // 폴백: header 컬럼 id 사용
                                    try { return gridObj.getColumnId(cInd); } catch(e) { return null; }
                                }
                            
                                // 콤보 객체 얻기 (cell-level 우선 -> column-level)
                                function getComboObj(cInd, rId){
                                    try{
                                        var cellObj = gridObj.cells(rId, cInd);
                                        if(cellObj && typeof cellObj.getCellCombo === "function"){
                                            return cellObj.getCellCombo();
                                        }
                                    }catch(e){}
                                    if(typeof gridObj.getColumnCombo === "function") return gridObj.getColumnCombo(cInd);
                                    if(typeof gridObj.getCombo === "function") return gridObj.getCombo(cInd);
                                    return null;
                                }
                                function clearAndPut(combo, options){
                                    if(!combo) return;
                                    if(typeof combo.clearAll === "function") combo.clearAll();
                                    if(typeof combo.clear === "function") combo.clear();
                                    for(var i=0;i<options.length;i++){
                                        var v = options[i].value, t = options[i].text;
                                        if(typeof combo.put === "function") combo.put(v,t);
                                        else if(typeof combo.addOption === "function") combo.addOption(v,t);
                                    }
                                }
                            
                                function flattenUsers(rm){
                                    var arr = [];
                                    for(var d in rm.userMap){
                                        var list = rm.userMap[d] || [];
                                        for(var j=0;j<list.length;j++){
                                            arr.push({value:list[j].userNo, text:list[j].userName});
                                        }
                                    }
                                    return arr;
                                }
                            
                                // 핵심: onEditCell
                                gridObj.attachEvent("onEditCell", function(stage, rId, cInd, nValue, oValue){
                                    if(!rId) return true;
                            
                                    var curPrg = form1.getItemValue("TST_ANL_PRG_CD");
                                    if (curPrg === null || curPrg === undefined) {
                                        curPrg = "";
                                    }
                            
                                    var rowIndex = gridObj.getRowIndex(rId);
                                    
                                    var deptColIdx = 2; // 부서 컬럼 인덱스
                                    var userColIdx = 3; // 담당자 컬럼 인덱스
                            
                                    var isAllowed = false;
                                    var role = null;
                            
                                    // Determine if the cell is editable based on progress code and row index
                                    if ((curPrg === "") && rowIndex === 0) {
                                        isAllowed = true;
                                        role = "PFM1";
                                    } else if (curPrg === '1' && rowIndex === 1) {
                                        isAllowed = true;
                                        role = "PFM2";
                                    } else if (curPrg === '2' && rowIndex === 2) {
                                        isAllowed = true;
                                        role = "PFM3";
                                    } 
                            //         else if (curPrg === '3' && rowIndex === 3) {
                            //             isAllowed = true;
                            //             role = "PFM4";
                            //         }
                                    
                                    // Only department and user columns are editable
                                    if (cInd !== deptColIdx && cInd !== userColIdx) {
                                        isAllowed = false;
                                    }
                            
                                    console.log("onEditCell => stage:",stage,"rId:",rId,"cInd:",cInd,"curPrg:",curPrg,"rowIndex:",rowIndex,"allowed:",isAllowed);
                                    
                                    // stage 0 : editor 열리기 직전 -> 옵션을 채우고 허용 여부 반환
                                    if(stage === 0){
                                        if(!isAllowed){
                                            return false;
                                        }
                            
                                        if(!role) return true;
                            
                                        var rm = roleMaps[role];
                                        var combo = getComboObj(cInd, rId);
                            
                                        // 부서 콤보 세팅
                                        if(cInd === deptColIdx){
                                            var deptOpts = [];
                                            for(var d in rm.deptCodeToName){
                                                if(!rm.deptCodeToName.hasOwnProperty(d)) continue;
                                                deptOpts.push({value:d, text:rm.deptCodeToName[d]});
                                            }
                                            clearAndPut(combo, deptOpts);
                                        }
                                        // 사용자 콤보 세팅 (부서 기준, 없으면 전체)
                                        else if(cInd === userColIdx){
                                            var deptVal = gridObj.cells(rId, deptColIdx).getValue();
                                            
                                            var deptKey = rm.userMap[deptVal] ? deptVal : (rm.deptNameToCode[deptVal] || "");
                                            var userOpts = [];
                                            if(deptKey) {
                                                var list = rm.userMap[deptKey] || [];
                                                for(var k=0;k<list.length;k++) userOpts.push({value:list[k].userNo, text:list[k].userName});
                                            } else {
                                                userOpts = flattenUsers(rm);
                                            }
                                            clearAndPut(combo, userOpts);
                                        }
                            
                                        return true; // 편집 허용
                                    }
                            
                                    // stage 1: 열린 상태일 때는 허용된 컬럼이면 true
                                    if(stage === 1) {
                                        return isAllowed;
                                    }
                            
                                    // stage 2: 편집 종료 - 부서 확정이면 담당자 콤보 재구성
                            //         if(stage === 2) {
                            //             if(!isAllowed) return false;
                            //             if(cInd === deptColIdx) {
                            //                 gridObj.cells(rId, userColIdx).setValue("");
                            //             }
                            
                            
                                    if(stage === 2) {
                                        if(!isAllowed) return false;
                                	
                                        var rm = roleMaps[role];
                                        
                                        
                                        if(cInd === userColIdx && role === "PFM1") {
                                            var combo = getComboObj(cInd, rId);
                                            var selectedUserNo = combo ? (combo.getActualValue ? combo.getActualValue() : nValue) : nValue;
                            
                                            var idColIdx = gridObj.getColIndexById("TST_PFM1_ID");
                                            console.log("role:", role, "selectedUserNo:", selectedUserNo, "idColIdx:", idColIdx);
                            
                                            if(idColIdx >= 0) {
                                                gridObj.cells(rId, idColIdx).setValue(selectedUserNo);
                                            }
                                        }		    
                                        
                                        
                                        
                                        
                            // 		    if(cInd === userColIdx) {
                            // 		        var combo = getComboObj(cInd, rId);
                            // 		        var selectedUserNo = combo ? (combo.getActualValue ? combo.getActualValue() : nValue) : nValue;
                                	
                            // 		        var idColName = (role === "PFM1") ? "TST_PFM1_ID" : null;
                            // // 		                      : (role === "PFM2") ? "TST_PFM2_ID"
                            // // 		                      : (role === "PFM3") ? "TST_PFM3_ID" : null;
                                            
                            // 		        if(idColName){
                            // 		            var idColIdx = gridObj.getColIndexById(idColName);
                            // 		            console.log("role:", role, "idColName:", idColName, "idColIdx:", idColIdx, "selectedUserNo:", selectedUserNo);
                            // 		            if(idColIdx >= 0) {
                            // 		                gridObj.cells(rId, idColIdx).setValue(selectedUserNo);
                            // 		            }
                            // 		        }
                            // 		    }
                                	
                                        return true;
                                    }
                            
                                    return true;
                                });
                                
                                // 자동 선택 함수 수정
                                function autoSelectFirstValues(role, rowIndex) {
                                    var rm = roleMaps[role];
                                    var firstDeptCode = Object.keys(rm.deptCodeToName)[0];
                                    if (firstDeptCode) {
                                        var deptName = rm.deptCodeToName[firstDeptCode];
                                        
                                        // 부서 정보 설정
                                        gridObj.cells2(rowIndex, 2).setValue(deptName);
                                        gridObj.setUserData(gridObj.getRowId(rowIndex), "dept_code", firstDeptCode);
                                        
                                        // 사용자 정보 설정
                                        var users = rm.userMap[firstDeptCode];
                                        if (users && users.length > 0) {
                                            gridObj.cells2(rowIndex, 3).setValue(users[0].userName);
                                            gridObj.setUserData(gridObj.getRowId(rowIndex), "user_no", users[0].userNo);
                                        }
                                    }
                                }
                                
                                // After loading, auto-select first values
                                setTimeout(function() {
                                    autoSelectFirstValues('PFM2', 1);
                                    autoSelectFirstValues('PFM3', 2);
                                }, 100);    
                                
                                
                            }
                                
                            */



                            function onAfterUpdateFinishEvent() {

                                if (lastSaveAction === 'saveAprv') {
                                    // 결재 완료 후 그리드 행 업데이트
                                    var gridObj  = items['C108000240pop01_Grid_1'].getDhxGrid();
                                    var form1    = items['C108000240pop01_Form_1'];
                                    var myUserNm = '<%=userName%>';
                                    var myUserNo = '<%=userNo%>';
                                    var today    = new Date();
                                    var mm = today.getMonth() + 1;
                                    var dd = today.getDate();
                                    var todayStr = today.getFullYear() + '-' + (mm < 10 ? '0' + mm : mm) + '-' + (dd < 10 ? '0' + dd : dd);

                                    var isApprove = (lastApprovalResult === '2');
                                    var savedOpinion = form1.getItemValue("OPINION_TEXT") || '';
                                    if (lastApprovalRowId) {
                                        gridObj.cells(lastApprovalRowId, gridObj.getColIndexById("APRV_STATUS")).setValue(lastApprovalResult);
                                        gridObj.cells(lastApprovalRowId, gridObj.getColIndexById("APRV_STATUS_NM")).setValue(isApprove ? "완료" : "중단");
                                        gridObj.cells(lastApprovalRowId, gridObj.getColIndexById("APRV_USER_NM")).setValue(myUserNm);
                                        gridObj.cells(lastApprovalRowId, gridObj.getColIndexById("APRV_USER")).setValue(myUserNo);
                                        gridObj.cells(lastApprovalRowId, gridObj.getColIndexById("APRV_DT")).setValue(todayStr);
                                        gridObj.cells(lastApprovalRowId, gridObj.getColIndexById("OPINION")).setValue(savedOpinion);
                                    }

                                    // 시편승인(3) 승인 시 분석/개발(2) 자동 승인 UI 반영
                                    if (isApprove && lastApprovalStepCd === '3') {
                                        var step2AprvStatus = gridObj.cells("step_2", gridObj.getColIndexById("APRV_STATUS")).getValue();
                                        if (step2AprvStatus !== '2' && step2AprvStatus !== '3') {
                                            gridObj.cells("step_2", gridObj.getColIndexById("APRV_STATUS")).setValue("2");
                                            gridObj.cells("step_2", gridObj.getColIndexById("APRV_STATUS_NM")).setValue("완료");
                                            gridObj.cells("step_2", gridObj.getColIndexById("APRV_USER_NM")).setValue("-");
                                            gridObj.cells("step_2", gridObj.getColIndexById("APRV_USER")).setValue("-");
                                            gridObj.cells("step_2", gridObj.getColIndexById("APRV_DT")).setValue(todayStr);
                                            gridObj.cells("step_2", gridObj.getColIndexById("OPINION")).setValue("시편승인 담당자에게 문의");
                                        }
                                    }

                                    // 개발완료대기(6) 승인 시 개발완료(7) 자동 승인 UI 반영
                                    if (isApprove && lastApprovalStepCd === '6') {
                                        var step7AprvStatus = gridObj.cells("step_7", gridObj.getColIndexById("APRV_STATUS")).getValue();
                                        if (step7AprvStatus !== '2' && step7AprvStatus !== '3') {
                                            gridObj.cells("step_7", gridObj.getColIndexById("APRV_STATUS")).setValue("2");
                                            gridObj.cells("step_7", gridObj.getColIndexById("APRV_STATUS_NM")).setValue("완료");
                                            gridObj.cells("step_7", gridObj.getColIndexById("APRV_USER_NM")).setValue(myUserNm);
                                            gridObj.cells("step_7", gridObj.getColIndexById("APRV_USER")).setValue(myUserNo);
                                            gridObj.cells("step_7", gridObj.getColIndexById("APRV_DT")).setValue(todayStr);
                                            gridObj.cells("step_7", gridObj.getColIndexById("OPINION")).setValue("개발완료대기 승인자에 의한 자동 승인");
                                            var _s6DeptNm = gridObj.cells("step_6", gridObj.getColIndexById("DEPT_NM")).getValue();
                                            var _s6DeptCd = gridObj.cells("step_6", gridObj.getColIndexById("DEPT_CD")).getValue();
                                            gridObj.cells("step_7", gridObj.getColIndexById("DEPT_NM")).setValue(_s6DeptNm);
                                            gridObj.cells("step_7", gridObj.getColIndexById("DEPT_CD")).setValue(_s6DeptCd);
                                        }
                                    }

                                    // BOM등록(5) 승인 시 CCL_BOM_NO 폼 필드 갱신
                                    if (isApprove && lastApprovalStepCd === '5') {
                                        var newBom = form1.getItemValue("EXT_BOM_NO");
                                        if (newBom) form1.setItemValue("CCL_BOM_NO", newBom);
                                        _updateBomChgBtn();
                                    }

                                    var _needEtcReload = (isApprove && lastApprovalStepCd === '3');
                                    lastApprovalRowId  = null;
                                    lastApprovalResult = null;
                                    lastApprovalStepCd = null;
                                    applyAprvRowStyles();
                                    dhtmlx.alert({
                                        text: isApprove ? "결재되었습니다." : "반려되었습니다.",
                                        callback: function() {
                                            if (_needEtcReload) {
                                                try { reloadEtcGrid(); } catch(e) {}
                                            }
                                        }
                                    });

                                } else if (lastSaveAction === 'saveOpinion') {
                                    dhtmlx.alert("의견이 저장되었습니다.");

                                } else if (lastSaveAction === 'saveEtc') {
                                    // saveEtc일 때는 팝업을 닫지 않고 성공 메시지만 표시
                                    dhtmlx.alert("저장되었습니다.");

                                } else if (lastSaveAction === 'changeUser') {
                                    // 담당자 변경 후 Form_1 값 갱신
                                    var form1 = items['C108000240pop01_Form_1'];
                                    var newChrId = form1.getItemValue("NEW_CHR_ID");
                                    // 변경된 담당자 정보 조회
                                    var deptParam = "ServiceName=C108000240pop01-service&findDeptInfo=1&USER_NO=" + encodeURIComponent(newChrId) + "&column-info=DEPT_CD,DEPT_NM";
                                    try {
                                        var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', deptParam);
                                        if (xmlObj) {
                                            var cells = xmlObj.getElementsByTagName("cell");
                                            if (cells.length >= 2) {
                                                var newDeptNm = (cells.item(1) && cells.item(1).firstChild) ? cells.item(1).firstChild.nodeValue : "";
                                                form1.setItemValue("DEV_CHR_DEPT_NM", newDeptNm);
                                            }
                                        }
                                    } catch(e) { console.error("[changeUser] findDeptInfo error:", e); }
                                    // 담당자 이름 조회
                                    var userParam = "ServiceName=C108000240pop01-service&findUser=1&column-info=USER_NO,USER_NAME,DEPT_CD,DEPT_NM&SEARCH_KEY=" + encodeURIComponent(newChrId);
                                    try {
                                        var userXml = uiCommon.ajaxLoadData('c10AjaxData.do', userParam);
                                        if (userXml) {
                                            var uCells = userXml.getElementsByTagName("cell");
                                            if (uCells.length >= 2) {
                                                var newUserNm = (uCells.item(1) && uCells.item(1).firstChild) ? uCells.item(1).firstChild.nodeValue : "";
                                                form1.setItemValue("DEV_CHR_NM", newUserNm);
                                            }
                                        }
                                    } catch(e) { console.error("[changeUser] findUser error:", e); }
                                    form1.setItemValue("DEV_CHR_ID", newChrId);
                                    dhtmlx.alert("담당자가 변경되었습니다.");

                                } else if (lastSaveAction === 'saveDeptChange') {
                                    dhtmlx.alert("처리담당부서가 변경되었습니다.");

                                } else if (lastSaveAction === 'changeBom') {
                                    var form1 = items['C108000240pop01_Form_1'];
                                    var newBom = form1.getItemValue("NEW_BOM_NO");
                                    if (newBom) form1.setItemValue("CCL_BOM_NO", newBom);
                                    _updateBomChgBtn();
                                    try { reloadEtcGrid(); } catch(e) {}
                                    dhtmlx.alert("CCL-BOM이 변경되었습니다.");

                                } else if (lastSaveAction === 'saveDevStop') {
                                    // 개발 중단 후 Grid_1 step_7 행 업데이트
                                    var gridObj  = items['C108000240pop01_Grid_1'].getDhxGrid();
                                    var myUserNm = '<%=userName%>';
                                    var myUserNo = '<%=userNo%>';
                                    var today    = new Date();
                                    var mm = today.getMonth() + 1;
                                    var dd = today.getDate();
                                    var todayStr = today.getFullYear() + '-' + (mm < 10 ? '0' + mm : mm) + '-' + (dd < 10 ? '0' + dd : dd);

                                    gridObj.cells("step_8", gridObj.getColIndexById("APRV_STATUS")).setValue("3");
                                    gridObj.cells("step_8", gridObj.getColIndexById("APRV_STATUS_NM")).setValue("중단");
                                    gridObj.cells("step_8", gridObj.getColIndexById("APRV_USER_NM")).setValue(myUserNm);
                                    gridObj.cells("step_8", gridObj.getColIndexById("APRV_USER")).setValue(myUserNo);
                                    gridObj.cells("step_8", gridObj.getColIndexById("APRV_DT")).setValue(todayStr);
                                    gridObj.cells("step_8", gridObj.getColIndexById("OPINION")).setValue(items['C108000240pop01_Form_1'].getItemValue("OPINION_TEXT"));

                                    items['C108000240pop01_Form_1'].setItemValue("DEV_PRG_CD", "8");
                                    applyAprvRowStyles();
                                    dhtmlx.alert("개발이 중단되었습니다.");

                                } else {
                                    // 저장 성공 → 부모 화면 자동 조회 + 창 닫기
                                    try { parent.find('find', 'C108000240_Form_1', 'C108000240_Grid_1'); } catch(e) {}
                                    winClose();
                                }
                                lastSaveAction = '';

                            }


                            function serchIcon_ORD_USG_CD(name, val) {
                                var imgPath = window.dhx_globalImgPath ? window.dhx_globalImgPath : "./dhtmlx/codebase/imgs/";
                                return "<img src='" + imgPath + "search.gif' align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('ORD_USG_CD','SZ0000','ORD_USG_CD','용도 검색','C108000240pop01_Form_1');\">";
                            }

                            function serchIcon_NAT_CD(name, val) {
                                var imgPath = window.dhx_globalImgPath ? window.dhx_globalImgPath : "./dhtmlx/codebase/imgs/";
                                return "<img src='" + imgPath + "search.gif' align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('NAT_CD','SZ0000','NAT_CD','사용국가 검색','C108000240pop01_Form_1');\">";
                            }

                            function serchIcon_CUS_CD(name, val) {
                                var imgPath = window.dhx_globalImgPath ? window.dhx_globalImgPath : "./dhtmlx/codebase/imgs/";
                                return "<img src='" + imgPath + "search.gif' align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('CUS_CD','SZ0000','CUS_CD','수요가 검색','C108000240pop01_Form_1');\">";
                            }

                            function serchIcon_FNL_CUS_CD(name, val) {
                                var imgPath = window.dhx_globalImgPath ? window.dhx_globalImgPath : "./dhtmlx/codebase/imgs/";
                                return "<img src='" + imgPath + "search.gif' align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"customCodePopup('CUS_CD','SZ0000','FNL_CUS_CD','최종고객사 검색','C108000240pop01_Form_1');\">";
                            }

                            function masterPopup(CD_TP, CATEGORY_GROUP_NM, target, formId) {
                                winObj = new ui.window("popup", "popup", "0", "0", "469", "532", "masterGridData.do?CD_TP=" + CD_TP + "&CATEGORY_GROUP_NM=" + CATEGORY_GROUP_NM + "&targetName=" + target + "&targetFormID=" + formId);
                                winObj.setButtonDisable("park,minmax1");
                                winObj.setModal();
                            }
                            // popup으로부터 넘겨받은 값 item에 세팅
                            function masterSetValue(code, name, target, formId) {
                                if (target === 'CUS_CD' || target === 'FNL_CUS_CD' || target === 'ORD_USG_CD' || target === 'NAT_CD') {
                                    items[formId].setItemValue(target, code + ' : ' + name);
                                } else {
                                    items[formId].setItemValue(target, code);
                                }
                            }

                            // ===== 범용 마스터코드 검색 커스텀 팝업 (대소문자 무시) =====
                            var _codePopupModal = null;
                            var _codeCache = {};
                            var _codeDebounce = null;
                            var _LARGE_CODE_TYPES = {'CUS_CD':true};
                            var _LARGE_MAX_ROWS = 100;
                            var _LARGE_MIN_CHARS = 2;
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
                                if (isDept && !_showAllDept && !key) {
                                    html += '<tr data-action="showAll"><td colspan="2" style="padding:6px 8px;text-align:center;cursor:pointer;color:#4A7CBB;font-size:11px;border-top:1px solid #ddd;">▼ 다른부서 더보기</td></tr>';
                                } else if (isDept && _showAllDept && !key) {
                                    html += '<tr data-action="hideAll"><td colspan="2" style="padding:6px 8px;text-align:center;cursor:pointer;color:#4A7CBB;font-size:11px;border-top:1px solid #ddd;">▲ 주요부서만 보기</td></tr>';
                                }
                                tbody.innerHTML = html;
                                tbody.onclick = function(e) {
                                    var tr = e.target; while (tr && tr.tagName !== 'TR') tr = tr.parentNode;
                                    if (!tr) return;
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
                                    items[formId].setItemValue(targetField, tr.getAttribute('data-cd') + ' : ' + tr.getAttribute('data-nm'));
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
                                _showAllDept = false;

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

                            function getNextDevId() {
                                var maxId = null;
                                var param = "ServiceName=C108000240pop01-service&maxNo=1&column-info=DEV_ID";

                                try {
                                    var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
                                    if (xmlObj) {
                                        var cells = xmlObj.getElementsByTagName("cell");
                                        if (cells && cells.length > 0 && cells.item(0).firstChild) {
                                            maxId = cells.item(0).firstChild.nodeValue;
                                        }
                                    }
                                } catch(e) { console.error("[getNextDevId] error:", e); }

                                return maxId;
                            }

// ===== 첨부파일 관련 함수 =====
function openFilePopup() {
    if (!DEV_ID) { dhtmlx.alert("개발번호가 없습니다. 먼저 저장하세요."); return; }
    window.open("C108000240pop02.jsp?DEV_ID=" + encodeURIComponent(DEV_ID) + "&parent_item=C108000240pop01_Grid_3",
        "fileUpload", "width=480,height=430,scrollbars=no");
}

function Grid_doLink(filename, rowId) {
    var gridObj = items["C108000240pop01_Grid_3"].getDhxGrid();
    var FILE_ADR = gridObj.cellById(rowId, gridObj.getColIndexById("IMG_ADR")).getValue();
    var FILE_NM  = gridObj.cellById(rowId, gridObj.getColIndexById("IMG_NM")).getValue();
    console.log("[Grid_doLink] FILE_ADR=" + FILE_ADR + " FILE_NM=" + FILE_NM);
    // hidden iframe으로 다운로드 (팝업 페이지 유지)
    var iframe = document.getElementById("_downloadFrame");
    if (!iframe) {
        iframe = document.createElement("iframe");
        iframe.id = "_downloadFrame";
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }
    iframe.src = "_fileDownloadHandler.jsp?FILE_ADR=" + encodeURIComponent(FILE_ADR) + "&FILE_NM=" + encodeURIComponent(FILE_NM);
}

function downloadAll() {
    var gridObj = items["C108000240pop01_Grid_3"].getDhxGrid();
    if (gridObj.getRowsNum() === 0) { dhtmlx.alert("첨부파일이 없습니다."); return; }
    var files = [];
    var _dlFlagIdx = gridObj.getColIndexById("DEL_FLAG");
    for (var r = 0; r < gridObj.getRowsNum(); r++) {
        var rId = gridObj.getRowId(r);
        if (_dlFlagIdx >= 0 && gridObj.cells(rId, _dlFlagIdx).getValue() === 'Y') continue;
        var imgAdr = gridObj.cellById(rId, gridObj.getColIndexById("IMG_ADR")).getValue();
        var imgNm  = gridObj.cellById(rId, gridObj.getColIndexById("IMG_NM")).getValue();
        if (imgAdr && imgNm) {
            files.push({adr: imgAdr, nm: imgNm});
        }
    }
    if (files.length === 0) { dhtmlx.alert("다운로드할 파일이 없습니다."); return; }

    // 개별 순차 다운로드 (500ms 간격)
    var _dlIdx = 0;
    function _dlNext() {
        if (_dlIdx >= files.length) return;
        var iframe = document.createElement('iframe');
        iframe.style.display = 'none';
        iframe.src = "_fileDownloadHandler.jsp?FILE_ADR=" + encodeURIComponent(files[_dlIdx].adr) + "&FILE_NM=" + encodeURIComponent(files[_dlIdx].nm);
        document.body.appendChild(iframe);
        setTimeout(function() { try { document.body.removeChild(iframe); } catch(e) {} }, 10000);
        _dlIdx++;
        if (_dlIdx < files.length) setTimeout(_dlNext, 500);
    }
    dhtmlx.alert(files.length + "개 파일을 다운로드합니다.");
    _dlNext();
}

var _fileGridLoaded = false;
function loadFileGrid() {
    try {
        if (_fileGridLoaded) { console.log("[loadFileGrid] 이미 로드됨, skip"); return; }
        console.log("[loadFileGrid] DEV_ID=" + DEV_ID + " grid3Item=" + !!items['C108000240pop01_Grid_3']);
        if (!DEV_ID) return;
        var grid3Item = items['C108000240pop01_Grid_3'];
        if (!grid3Item) return;
        var dhxGrid = grid3Item.getDhxGrid();
        if (!dhxGrid) { console.log("[loadFileGrid] dhxGrid null"); return; }

        _fileGridLoaded = true;

        var param = "ServiceName=C108000240pop01-service&findFile=1";
        if (grid3Item.getColumnInfo()) {
            param += "&column-info=" + grid3Item.getColumnInfo();
        } else {
            param += "&column-info=FILE_TP,IMG_NM,RGS_PRS_NM,RGS_DD,IMG_ADR,SEQ_NO,CHK_IMG_NM";
        }
        param += "&DEV_ID=" + encodeURIComponent(DEV_ID);

        var findUrl = "basicGridData.do?" + param;
        grid3Item.loadData(findUrl, function() {
            console.log("[loadFileGrid] 로드 완료, rows:", dhxGrid.getRowsNum());
            try { applyFileStrikethrough(); } catch(e) {}
        });
    } catch(e) {
        _fileGridLoaded = false;
        console.error("[loadFileGrid] error:", e);
    }
}
// 외부(pop02)에서 업로드 후 호출하는 리로드 함수
// loadData → progressOn이 걸리므로, 리로드 시에는 dhxGrid.clearAndLoad 직접 호출
function reloadFileGrid() {
    try {
        _fileGridLoaded = true;
        var grid3Item = items['C108000240pop01_Grid_3'];
        if (!grid3Item) return;
        var dhxGrid = grid3Item.getDhxGrid();
        if (!dhxGrid) return;
        var param = "ServiceName=C108000240pop01-service&findFile=1";
        if (grid3Item.getColumnInfo()) {
            param += "&column-info=" + grid3Item.getColumnInfo();
        } else {
            param += "&column-info=FILE_TP,IMG_NM,RGS_PRS_NM,RGS_DD,IMG_ADR,SEQ_NO,CHK_IMG_NM";
        }
        param += "&DEV_ID=" + encodeURIComponent(DEV_ID);
        dhxGrid.clearAndLoad("basicGridData.do?" + param, function() {
            try { applyFileStrikethrough(); } catch(e) {}
        });
    } catch(e) {
        console.error("[reloadFileGrid] error:", e);
    }
}

function applyFileStrikethrough() {
    try {
        var g3 = items['C108000240pop01_Grid_3'].getDhxGrid();
        var delFlagIdx = g3.getColIndexById("DEL_FLAG");
        if (delFlagIdx < 0) return;
        for (var i = 0; i < g3.getRowsNum(); i++) {
            var rowId = g3.getRowId(i);
            if (g3.cells(rowId, delFlagIdx).getValue() === 'Y') {
                g3.setRowTextStyle(rowId, "text-decoration:line-through;color:#999;");
            }
        }
    } catch(e) {}
}

function injectFileButtons() {
    try {
        var gridDiv = document.getElementById("C108000240pop01_Grid_3");
        if (!gridDiv) { console.log("[injectFileButtons] gridDiv not found"); return; }

        // 디버그: gridDiv 부터 body까지 DOM 경로 출력
        var path = [];
        var node = gridDiv;
        while (node && node !== document.body) {
            path.push(node.tagName + (node.className ? '.' + node.className.replace(/\s+/g,'.') : '') + (node.id ? '#' + node.id : ''));
            node = node.parentNode;
        }
        console.log("[injectFileButtons] DOM path:", path.join(" → "));

        // 방법1: 문서 전체에서 "첨부파일 목록" 텍스트를 포함하는 헤더 요소 찾기
        var allDivs = document.getElementsByTagName('div');
        var hdrEl = null;
        for (var i = 0; i < allDivs.length; i++) {
            var d = allDivs[i];
            // 직접 텍스트 내용에 "첨부파일" 포함되고, 자식에 grid가 없는 헤더 영역
            if (d.innerHTML && d.innerHTML.indexOf('첨부파일 목록') > -1 && !d.querySelector('table')) {
                // 가장 깊은(작은) 요소 선택
                if (!hdrEl || d.innerHTML.length < hdrEl.innerHTML.length) {
                    hdrEl = d;
                }
            }
        }
        console.log("[injectFileButtons] hdrEl found:", !!hdrEl, hdrEl ? hdrEl.tagName + '.' + (hdrEl.className||'') : '');
        if (!hdrEl) { console.log("[injectFileButtons] 헤더 요소를 찾지 못함"); return; }
        if (hdrEl.querySelector('.file-btn-bar')) { console.log("[injectFileButtons] 이미 삽입됨"); return; }

        var btnDisabled = !DEV_ID ? ' disabled="disabled" style="padding:1px 6px;font-size:11px;cursor:default;opacity:0.7;"' : ' style="padding:1px 6px;font-size:11px;cursor:pointer;"';
        var btnSpan = document.createElement('span');
        btnSpan.className = 'file-btn-bar';
        btnSpan.style.cssText = 'float:right;position:relative;top:-5px;right:-5px;white-space:nowrap;';
        btnSpan.innerHTML = '<button onclick="openFilePopup()"' + btnDisabled + '>첨부관리</button> '
            + '<button onclick="downloadAll()"' + btnDisabled + '>전체다운로드</button>'
            + '<span style="margin-left:8px;font-size:11px;color:#2B4A7A;font-family:Malgun Gothic,맑은 고딕,sans-serif;">※ 파일 삭제 : "첨부" 버튼을 눌러 &#x1F5D1; 를 클릭, 삭제된 파일은 전체 다운로드 시 제외되며, 필요시 선택하여 다운로드 가능합니다.</span>';
        hdrEl.appendChild(btnSpan);
        console.log("[injectFileButtons] 버튼 삽입 완료");
    } catch(e) { console.error("[injectFileButtons] error:", e); }
}
// ===== 첨부파일 관련 함수 끝 =====

                            function onGridLoadEvent2() {
                                if (_onXLE2) items['C108000240pop01_Grid_2'].getDhxGrid().detachEvent(_onXLE2);
                                if (!DEV_ID) {
                                    uiCommon.progressOff(parent);
                                    return;
                                }

                                var grid2Item = items['C108000240pop01_Grid_2'];
                                var param2 = "ServiceName=C108000240pop01-service&findEtc=1";

                                if (grid2Item.getColumnInfo()) {
                                    param2 += "&column-info=" + grid2Item.getColumnInfo();
                                } else {
                                    param2 += "&column-info=" + grid2Item.getDefaultColumnInfo();
                                }

                                if (grid2Item.getBlankRowCntInfo()) {
                                    param2 += "&blank-row-count=" + grid2Item.getBlankRowCntInfo();
                                } else {
                                    param2 += "&blank-row-count=" + grid2Item.getDefaultRowCnt();
                                }

                                param2 += "&DEV_ID=" + encodeURIComponent(DEV_ID);

                                var findUrl2 = "basicGridData.do?" + param2;
                                items['C108000240pop01_Grid_2'].loadData(findUrl2, function () {
                                    applyAllStrikethrough();
                                    applyEtcTooltip();
                                    uiCommon.progressOff(parent);
                                });
                            }

// ===== Grid_2 특이사항 인라인 수정/삭제 =====
var g2MyUserNo = '<%=userNo%>';
var g2ColDevEtc, g2ColSeq, g2ColRawId, g2ColDelFlag;
var g2EditedRows = {};
var g2NewRows = {};
var g2NewRowSeq = 0;

function initGrid2ColIdx() {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    g2ColDevEtc  = g2.getColIndexById("DEV_ETC");
    g2ColSeq     = g2.getColIndexById("SEQ");
    g2ColRawId   = g2.getColIndexById("REG_CHR_ID_RAW");
    g2ColDelFlag = g2.getColIndexById("DEL_FLAG");
}

function grid2EditCell(stage, rId, cellIndex, nValue, oValue) {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    if (typeof g2ColDevEtc === 'undefined') initGrid2ColIdx();

    if (stage === 0) {
        if (cellIndex !== g2ColDevEtc) return false;
        // 신규 행만 편집 가능 (기존 행은 삭제 후 재작성)
        if (g2NewRows[rId]) return true;
        return false;
    }
    if (stage === 2) {
        if (nValue !== oValue) {
            g2EditedRows[rId] = true;
        }
        return true;
    }
    return true;
}

function saveEtcEdits() {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    if (typeof g2ColDevEtc === 'undefined') initGrid2ColIdx();

    // 수정된 행 (기존행)
    var editRowIds = [];
    for (var k in g2EditedRows) {
        if (g2EditedRows.hasOwnProperty(k) && !g2NewRows[k]) editRowIds.push(k);
    }
    // 신규행
    var newRowIds = [];
    for (var n in g2NewRows) {
        if (g2NewRows.hasOwnProperty(n)) newRowIds.push(n);
    }

    if (editRowIds.length === 0 && newRowIds.length === 0) {
        dhtmlx.alert("수정된 내용이 없습니다.");
        return;
    }

    dhtmlx.confirm({
        ok: "확인", cancel: "취소",
        text: "특이사항을 저장하시겠습니까?",
        callback: function(val) {
            if (val) {
                _doSaveEtc(editRowIds, newRowIds);
            }
        }
    });
}

function _doSaveEtc(editRowIds, newRowIds) {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    if (typeof g2ColDevEtc === 'undefined') initGrid2ColIdx();

    var successCount = 0;
    var failCount = 0;

    // 1) 신규행 INSERT
    for (var ni = 0; ni < newRowIds.length; ni++) {
        var nrId = newRowIds[ni];
        var newDevEtc = g2.cells(nrId, g2ColDevEtc).getValue();
        if (!newDevEtc || newDevEtc.trim() === '') {
            g2.deleteRow(nrId);
            delete g2NewRows[nrId];
            delete g2EditedRows[nrId];
            continue;
        }
        var insertBody = "ServiceName=C108000240pop01-service&insertEtcRow=1"
            + "&ids=r1"
            + "&r1_DEV_ID=" + encodeURIComponent(DEV_ID)
            + "&r1_REG_CHR_ID=" + encodeURIComponent(g2MyUserNo)
            + "&r1_DEV_ETC=" + encodeURIComponent(newDevEtc)
            + "&r1_!nativeeditor_status=inserted";
        try {
            var iLoader = dhtmlxAjax.postSync("handleDataProcess.do", insertBody);
            var iResp = iLoader.xmlDoc.responseText;
            if (iResp && iResp.indexOf("invalid") >= 0) {
                failCount++;
            } else {
                successCount++;
                delete g2NewRows[nrId];
                delete g2EditedRows[nrId];
            }
        } catch(ie) {
            failCount++;
        }
    }

    // 2) 기존행 UPDATE
    for (var ei = 0; ei < editRowIds.length; ei++) {
        var eId = editRowIds[ei];
        var seq = g2.cells(eId, g2ColSeq).getValue();
        var devEtc = g2.cells(eId, g2ColDevEtc).getValue();
        var postBody = "ServiceName=C108000240pop01-service&updateEtc=1"
            + "&ids=r1"
            + "&r1_DEV_ETC=" + encodeURIComponent(devEtc)
            + "&r1_DEV_ID=" + encodeURIComponent(DEV_ID)
            + "&r1_SEQ=" + encodeURIComponent(seq)
            + "&r1_!nativeeditor_status=updated";
        try {
            var loader = dhtmlxAjax.postSync("handleDataProcess.do", postBody);
            var resp = loader.xmlDoc.responseText;
            if (resp && resp.indexOf("invalid") >= 0) {
                failCount++;
            } else {
                successCount++;
            }
        } catch(e) {
            failCount++;
        }
    }

    g2EditedRows = {};

    if (failCount > 0) {
        dhtmlx.alert(failCount + "건 저장 실패, " + successCount + "건 저장 완료");
    } else if (successCount > 0) {
        dhtmlx.alert(successCount + "건 저장 완료");
    }

    // 저장 후 Grid_2 다시 로드 (신규행이 있었으면 SEQ 등 반영 위해)
    if (successCount > 0) {
        reloadEtcGrid();
    }
}

function reloadEtcGrid() {
    try {
        var grid2Item = items['C108000240pop01_Grid_2'];
        var g2 = grid2Item.getDhxGrid();
        var param2 = "ServiceName=C108000240pop01-service&findEtc=1";
        if (grid2Item.getColumnInfo()) {
            param2 += "&column-info=" + grid2Item.getColumnInfo();
        } else {
            param2 += "&column-info=" + grid2Item.getDefaultColumnInfo();
        }
        if (grid2Item.getBlankRowCntInfo()) {
            param2 += "&blank-row-count=" + grid2Item.getBlankRowCntInfo();
        } else {
            param2 += "&blank-row-count=" + grid2Item.getDefaultRowCnt();
        }
        param2 += "&DEV_ID=" + encodeURIComponent(DEV_ID);
        g2.clearAndLoad("basicGridData.do?" + param2, function() {
            g2NewRows = {};
            g2EditedRows = {};
            applyAllStrikethrough();
            applyEtcTooltip();
        });
    } catch(e) {
        console.error("[reloadEtcGrid] error:", e);
    }
}

function softDeleteEtcRow(rowId) {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    if (typeof g2ColDelFlag === 'undefined') initGrid2ColIdx();

    var rawId = g2.cells(rowId, g2ColRawId).getValue();
    if (rawId !== g2MyUserNo) {
        dhtmlx.alert("작성자만 삭제할 수 있습니다.");
        return;
    }
    if (g2.cells(rowId, g2ColDelFlag).getValue() === 'Y') {
        dhtmlx.alert("이미 삭제된 항목입니다.");
        return;
    }
    dhtmlx.confirm({
        text: "이 특이사항을 삭제하시겠습니까?",
        callback: function(result) {
            if (!result) return;
            var seq = g2.cells(rowId, g2ColSeq).getValue();
            var postBody = "ServiceName=C108000240pop01-service&softDeleteEtc=1"
                + "&ids=r1"
                + "&r1_DEV_ID=" + encodeURIComponent(DEV_ID)
                + "&r1_SEQ=" + encodeURIComponent(seq)
                + "&r1_!nativeeditor_status=updated";
            try {
                var loader = dhtmlxAjax.postSync("handleDataProcess.do", postBody);
                var resp = loader.xmlDoc.responseText;
                if (resp && resp.indexOf("invalid") >= 0) {
                    dhtmlx.alert("삭제 중 오류가 발생했습니다.");
                    return;
                }
                g2.cells(rowId, g2ColDelFlag).setValue('Y');
                delete g2EditedRows[rowId];
                applyStrikethrough(g2, rowId);
            } catch(e) {
                dhtmlx.alert("삭제 중 오류가 발생했습니다.");
            }
        }
    });
}

function addEtcRow() {
    if (!DEV_ID) {
        dhtmlx.alert("저장된 의뢰가 없습니다.");
        return;
    }
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    if (typeof g2ColDevEtc === 'undefined') initGrid2ColIdx();

    g2NewRowSeq++;
    var newId = "new_" + g2NewRowSeq;
    var today = new Date();
    var yyyy = today.getFullYear();
    var mm = ('0' + (today.getMonth() + 1)).slice(-2);
    var dd = ('0' + today.getDate()).slice(-2);
    var todayStr = yyyy + '-' + mm + '-' + dd;

    g2.addRow(newId, [todayStr, '<%=userDeptNm%>', '<%=userName%>', '', '', '<%=userNo%>', 'N'], 0);
    g2NewRows[newId] = true;
    g2EditedRows[newId] = true;

    g2.selectRowById(newId);
    g2.editCell(0, g2ColDevEtc);
}

function deleteEtcSelected() {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    var selId = g2.getSelectedRowId();
    if (!selId) {
        dhtmlx.alert("삭제할 행을 선택하세요.");
        return;
    }
    if (g2NewRows[selId]) {
        g2.deleteRow(selId);
        delete g2NewRows[selId];
        delete g2EditedRows[selId];
        return;
    }
    softDeleteEtcRow(selId);
}

function applyStrikethrough(g2, rowId) {
    g2.setRowTextStyle(rowId, "text-decoration:line-through;color:#999;");
}

function applyAllStrikethrough() {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    if (typeof g2ColDelFlag === 'undefined') initGrid2ColIdx();
    var rowCount = g2.getRowsNum();
    for (var i = 0; i < rowCount; i++) {
        var rowId = g2.getRowId(i);
        if (g2.cells(rowId, g2ColDelFlag).getValue() === 'Y') {
            applyStrikethrough(g2, rowId);
        }
    }
}

function applyEtcTooltip() {
    try {
        var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
        if (typeof g2ColDevEtc === 'undefined') initGrid2ColIdx();
        var rowCount = g2.getRowsNum();
        for (var i = 0; i < rowCount; i++) {
            var rowId = g2.getRowId(i);
            var etcVal = g2.cells(rowId, g2ColDevEtc).getValue();
            if (etcVal) {
                var cell = g2.cells(rowId, g2ColDevEtc).cell;
                if (cell) cell.title = etcVal;
            }
        }
    } catch(e) {}
}

// ===== 결재 그리드 행 상태별 스타일링 =====
function applyAprvRowStyles() {
    try {
        var gridObj = items['C108000240pop01_Grid_1'].getDhxGrid();
        var form1 = items['C108000240pop01_Form_1'];
        var aprvStatusIdx = gridObj.getColIndexById("APRV_STATUS");
        var devPrgCd = form1.getItemValue("DEV_PRG_CD");
        var isDevStop = (devPrgCd === '8');

        // 순차결재 순서 (분석/개발은 시편승인 시 자동)
        var seqOrder = ['1','3','4','5','6'];
        var allSteps = ["step_1","step_2","step_3","step_4","step_5","step_6","step_7"];

        // 현재 결재 대기 단계 찾기
        var currentStepRowId = null;
        for (var s = 0; s < seqOrder.length; s++) {
            var _rowId = 'step_' + seqOrder[s];
            var _status = gridObj.cells(_rowId, aprvStatusIdx).getValue();
            if (_status !== '2') {
                currentStepRowId = _rowId;
                break;
            }
        }

        for (var i = 0; i < allSteps.length; i++) {
            var rowId = allSteps[i];
            var status = gridObj.cells(rowId, aprvStatusIdx).getValue();

            if (isDevStop && (status === '2' || status === '3')) {
                // 개발중단: 기존 결재 행 취소선 + 회색
                gridObj.setRowTextStyle(rowId, "text-decoration:line-through;color:#999;");
                gridObj.setRowColor(rowId, "#f5f5f5");
            } else if (status === '2') {
                // 결재 완료: 기본 스타일
                gridObj.setRowTextStyle(rowId, "");
                gridObj.setRowColor(rowId, "");
            } else if (rowId === currentStepRowId) {
                // 현재 결재 대기: 노란 하이라이트
                gridObj.setRowTextStyle(rowId, "font-weight:bold;");
                gridObj.setRowColor(rowId, "#FFE699");
            } else {
                // 아직 비활성 단계: 옅은 회색
                gridObj.setRowTextStyle(rowId, "color:#aaa;");
                gridObj.setRowColor(rowId, "#f5f5f5");
            }
        }

        // step_7(개발중단)
        if (isDevStop) {
            gridObj.setRowTextStyle("step_8", "font-weight:bold;color:#cc0000;");
            gridObj.setRowColor("step_8", "");
        } else {
            gridObj.setRowTextStyle("step_8", "color:#aaa;");
            gridObj.setRowColor("step_8", "#f5f5f5");
        }
    } catch(e) { console.error("[applyAprvRowStyles] error:", e); }
}
// ===== 결재 그리드 행 상태별 스타일링 끝 =====

function injectEtcButtons() {
    try {
        var allDivs = document.getElementsByTagName('div');
        var hdrEl = null;
        for (var i = 0; i < allDivs.length; i++) {
            var d = allDivs[i];
            if (d.innerHTML && d.innerHTML.indexOf('특이사항') > -1 && !d.querySelector('table')) {
                if (!hdrEl || d.innerHTML.length < hdrEl.innerHTML.length) {
                    hdrEl = d;
                }
            }
        }
        if (!hdrEl || hdrEl.querySelector('.etc-btn-bar')) return;

        var btnDisabled = !DEV_ID
            ? ' disabled="disabled" style="padding:1px 6px;font-size:11px;cursor:default;opacity:0.7;"'
            : ' style="padding:1px 6px;font-size:11px;cursor:pointer;"';
        var btnSpan = document.createElement('span');
        btnSpan.className = 'etc-btn-bar';
        btnSpan.style.cssText = 'float:right;position:relative;top:-5px;right:-5px;white-space:nowrap;';
        btnSpan.innerHTML = '<button onclick="addEtcRow()"' + btnDisabled + '>행추가</button> '
            + '<button onclick="saveEtcEdits()"' + btnDisabled + '>저장</button> '
            + '<button onclick="deleteEtcSelected()"' + btnDisabled + '>삭제</button>';
        hdrEl.appendChild(btnSpan);
    } catch(e) { console.error("[injectEtcButtons] error:", e); }
}

var g2CtxMenu;
var g2SelectedRowId;
function initGrid2ContextMenu() {
    var g2 = items['C108000240pop01_Grid_2'].getDhxGrid();
    g2CtxMenu = new dhtmlXMenuObject();
    g2CtxMenu.setIconsPath("dhtmlx/codebase/imgs/");
    g2CtxMenu.renderAsContextMenu();
    g2CtxMenu.addNewChild(g2CtxMenu.topId, 1, "deleteEtc", "삭제");
    g2CtxMenu.attachEvent("onClick", function(id) {
        if (id === "deleteEtc" && g2SelectedRowId) {
            softDeleteEtcRow(g2SelectedRowId);
        }
    });
    g2.enableContextMenu(g2CtxMenu);
    g2.attachEvent("onBeforeContextMenu", function(rowId, cellIdx, gridObj) {
        g2SelectedRowId = rowId;
        return true;
    });
}
// ===== Grid_2 특이사항 인라인 수정/삭제 끝 =====


//]]>
-->
                        </script>
                    </head>

                    <body>
                        <!-- 	<div id="C108000240pop01_Form_1" -->
                        <!-- 		style="position: absolute; height: 350px; width: 996px; left: 0px; top: 0px;"> -->
                        <!-- 	</div>	 -->
                        <!-- 	<div id="C108000240pop01_Grid_1" -->
                        <!-- 		style="position: absolute; height: 185px; width: 996px; left: 0px; top: 350px;"> -->
                        <!-- 	</div> -->
                        <!-- 	<div id="C108000240pop01_Form_2" -->
                        <!-- 		style="position: absolute; height: 65px; width: 996px; left: 0px; top: 533px;"> -->
                        <!-- 	</div>		 -->
                        <!-- 	<div id="C108000240pop01_Grid_2" -->
                        <!-- 		style="position: absolute; height: 220px; width: 996px; left: 0px; top: 598px;"> -->
                        <!-- 	</div> -->
                        <!-- <!-- 	<div id="C108000240pop01_Grid_3" -->
                        <!-- <!-- 		style="position: absolute; height: 220px; width: 290px; left: 0px; top: 598px;"> -->
                        <!-- <!-- 	</div> -->
                        <!-- 	<div id="C108000240pop01_MessageBox_1" -->
                        <!-- 		style="position: absolute; height: 23px; width: 996px; left: 0px; top: 818px;"> -->
                        <!-- 	</div> -->
                    </body>

                    </html>
                    <script>

                        ui.initializeDHTMLX();
                        console.log("[INIT] Form_1:", !!items['C108000240pop01_Form_1'],
                            "Grid_1:", !!items['C108000240pop01_Grid_1'],
                            "Grid_2:", !!items['C108000240pop01_Grid_2'],
                            "Grid_3:", !!items['C108000240pop01_Grid_3']);
                        var _onXLE1 = items['C108000240pop01_Grid_1'].onXLEEvent(onGrid1LoadFunction);
                        try { injectApprovalButton(); } catch(e1b) { console.error("[INIT] injectApprovalButton error:", e1b); }
                        var onXleForm = items["C108000240pop01_Form_1"].onXLEEvent(onFormLoadFunction);
                        try { var _onXLE2 = items['C108000240pop01_Grid_2'].onXLEEvent(onGridLoadEvent2); } catch(e2) { console.error("[INIT] Grid_2 XLE error:", e2); }
                        try {
                            items['C108000240pop01_Grid_2'].getDhxGrid().attachEvent("onEditCell", grid2EditCell);
                            initGrid2ContextMenu();
                            injectEtcButtons();
                        } catch(e2b) { console.error("[INIT] Grid_2 edit/ctx error:", e2b); }
                        items['C108000240pop01_Form_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);

                        // Grid_3 첨부파일: 버튼 주입 + 데이터 로드 (모두 try-catch로 메인 흐름 보호)
                        try {
                            if (items['C108000240pop01_Grid_3']) {
                                console.log("[INIT] Grid_3 XLE 등록");
                                var _onXLE3 = items['C108000240pop01_Grid_3'].onXLEEvent(function() {
                                    try { if (_onXLE3) items['C108000240pop01_Grid_3'].getDhxGrid().detachEvent(_onXLE3); } catch(e3) {}
                                    try { injectFileButtons(); } catch(e4) {}
                                    try { loadFileGrid(); } catch(e5) {}
                                });
                            } else {
                                console.warn("[INIT] Grid_3 items 없음!");
                            }
                        } catch(xleErr) { console.error("[INIT] Grid_3 XLE error:", xleErr); }

                        // XLE 미발생 대비 fallback (2초 후)
                        setTimeout(function() {
                            console.log("[fallback] Grid_3 exists:", !!items['C108000240pop01_Grid_3']);
                            try { injectFileButtons(); } catch(e6) {}
                            try { loadFileGrid(); } catch(e7) {}
                        }, 2000);

                    </script>