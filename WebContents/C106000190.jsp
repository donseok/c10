<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000190.jsp
 * VERSION          :  V2.1
 * DESCRIPTION      :  칼라표준 견본 OCR 등록
 *                     - 좌: 업로드 이미지 미리보기
 *                     - 우: 라벨 시각 구조와 동일한 HTML 테이블 입력 폼
 * DEVELOPER NAME   :  SJS
 * CREATE DATE      :  2026-05-06
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>칼라표준 견본 OCR 등록</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<style type="text/css">
    #ocr_image_box {
        position:absolute; left:0px; top:36px; width:880px; height:700px;
        background:#fafafa; border:1px solid #ccc; text-align:center; overflow:hidden;
    }
    #ocr_image_box img {
        position:absolute; left:50%; top:50%;
        transform-origin:center center;
        transition:transform 0.15s ease;
        max-width:none; max-height:none;
    }
    #ocr_image_box .ocr-thumb-toolbar {
        position:absolute; top:6px; right:6px; z-index:5;
        display:flex; gap:4px;
    }
    #ocr_image_box .ocr-thumb-toolbar button {
        padding:4px 10px; font-size:12px; cursor:pointer;
        background:rgba(255,255,255,0.92); border:1px solid #999; border-radius:3px;
    }
    #ocr_image_box .ocr-thumb-toolbar button:hover {
        background:#fff;
    }
    #ocr_label_box {
        position:absolute; left:888px; top:36px; width:640px; height:700px;
        overflow-y:auto; padding:6px; box-sizing:border-box;
        border:1px solid #ddd; background:#fff;
    }
    #ocr_label_box .label-title {
        font-weight:bold; font-size:13px; color:#333; margin:0 0 4px 0;
    }
    table.ocr-label {
        width:100%; border-collapse:collapse; font-family:"Malgun Gothic",sans-serif;
        font-size:12px; table-layout:fixed;
    }
    table.ocr-label td {
        border:1px solid #555; padding:0; height:26px; vertical-align:middle;
    }
    table.ocr-label td.lbl {
        background:#eef2f6; font-weight:bold; text-align:center;
        white-space:nowrap; padding:0 6px; color:#222;
    }
    table.ocr-label td.dft-cell {
        padding:0;
    }
    table.ocr-label td.dft-cell .quad-inner {
        display:flex; align-items:stretch; height:100%;
    }
    table.ocr-label td.dft-cell .quad-inner .dft-inner {
        flex:1; border-right:1px solid #888;
    }
    table.ocr-label td.dft-cell .quad-inner .dft-inner:last-child {
        border-right:0;
    }
    table.ocr-label td.dft-cell .dft-inner {
        display:flex; align-items:center; height:100%;
    }
    table.ocr-label td.dft-cell .dft-inner span {
        display:inline-block; width:24px; text-align:center;
        background:#f5f5f5; border-right:1px solid #888; height:100%; line-height:26px;
        font-weight:bold; color:#666; font-size:11px;
    }
    table.ocr-label td.dft-cell .dft-inner input {
        border:0; flex:1; height:24px; padding:0 4px; box-sizing:border-box;
        font-size:12px; background:transparent; outline:none; min-width:0;
    }
    table.ocr-label td input,
    table.ocr-label td select {
        width:100%; height:24px; box-sizing:border-box;
        border:0; background:transparent; padding:0 6px;
        font-size:12px; outline:none;
    }
    table.ocr-label td input:focus,
    table.ocr-label td select:focus,
    table.ocr-label td.dft-cell .dft-inner input:focus {
        background:#fffbcc;
    }
    table.ocr-label td.disabled-cell {
        background:#f5f5f5; color:#999; text-align:center; font-style:italic; font-size:11px;
    }
    /* 매핑 신뢰도 시각화: input 의 background:transparent 보다 우선하도록 !important + 높은 specificity */
    table.ocr-label td input.ocr-src-fallback,
    table.ocr-label td select.ocr-src-fallback,
    table.ocr-label td.dft-cell .dft-inner input.ocr-src-fallback {
        background:#ffb74d !important;
        box-shadow: inset 3px 0 0 #f57c00 !important;
    }
    table.ocr-label td input.ocr-src-empty,
    table.ocr-label td select.ocr-src-empty,
    table.ocr-label td.dft-cell .dft-inner input.ocr-src-empty {
        background:#ffcdd2 !important;
        box-shadow: inset 3px 0 0 #e53935 !important;
    }
    table.ocr-label td input.ocr-master-warn,
    table.ocr-label td select.ocr-master-warn {
        background:#fff176 !important;
        box-shadow: inset 3px 0 0 #f9a825 !important;
    }
    .ocr-actions {
        margin:8px 0 0 0; text-align:right;
    }
    .ocr-actions button {
        margin-left:6px; padding:6px 14px; font-size:12px; cursor:pointer;
    }
    .ocr-actions .btn-send {
        background:#4a90e2; color:#fff; border:1px solid #2c6cb1;
    }
    #ocr_image_box .ocr-image-placeholder {
        display:block; padding-top:330px; color:#888; font-size:14px;
    }
</style>
<script type="text/javascript">
//<![CDATA[
// Upstage API 호출 정보 (web.xml context-param에서 서버 측 주입)
var UPSTAGE_API_URL = "<%= application.getInitParameter("c10.upstage.apiUrl") == null ? "https://api.upstage.ai/v1/information-extraction" : application.getInitParameter("c10.upstage.apiUrl") %>";
var UPSTAGE_API_KEY = "<%= application.getInitParameter("c10.upstage.apiKey") == null ? "" : application.getInitParameter("c10.upstage.apiKey") %>";

var items = new Array();
var pageConfiguration = '[' +
    '{"itemType":"form","renderTo":"C106000190_Form_1","xml":"./header/kr/C106000190/C106000190_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000190_Grid_1","service":"C106000190-service","actionType":"find","security":"true"},' +
    '{"itemType":"grid","renderTo":"C106000190_Grid_1","rowCnt":"15","xml":"./header/kr/C106000190/C106000190_Grid_1.xml","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","referenceItem":"C106000190_Form_1","service":"C106000190-service","actionType":"find"},' +
    '{"itemType":"messagebox","renderTo":"messagebox","xml":"./header/kr/C106000190/messagebox.xml","service":"C106000190-service"}' +
']';
var initConfig = JSON.parse(pageConfiguration);
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

var currentOcrNo = null;
// onFormLoadEvent 가 dhtmlx onXLE 이벤트로 두 번 호출되는 경우가 있어,
// addEventListener 가 누적되면 한 번 파일 선택에 uploadAndExtract 가 N번 실행되어 OCR_NO 가 N씩 증가함.
// 가드 변수로 file input change 핸들러는 한 번만 등록한다.
var _ocrInputBound = false;
// 사용자가 잠깐 사이에 [업로드] 를 빠르게 두 번 눌렀거나 다른 경로로 함수가 중복 호출되는 경우 방어.
var _ocrUploading = false;

// 라벨 폼 입력 필드 ID 목록
var OCR_FIELDS = [
    'OCR_CODE','OCR_TYPE','OCR_QT_TYPE','OCR_MUNSELL','OCR_GLOSS','OCR_PRIMER',
    'OCR_DFT_1C','OCR_DFT_2C','OCR_DFT_3C','OCR_COLOR','OCR_UNFIXED_NO',
    'OCR_DELTA_E','OCR_NV','OCR_L','OCR_A','OCR_B','OCR_SG','OCR_VIS',
    'OCR_MAKER','OCR_WORK_DT','OCR_APPROVED_DT','OCR_DISUSED_DT',
    'OCR_END_USER','OCR_DURABILITY','OCR_MEMO','OCR_CHARGER',
    'OCR_M2_DE','OCR_M2_DL','OCR_M2_DA','OCR_M2_DB',
    'OCR_P2_DE','OCR_P2_DL','OCR_P2_DA','OCR_P2_DB'
];

// ============================================================================
// RSN_TP(구매수지) 마스터 검증 — OCR_TYPE 값이 마스터에 등록된 코드인지 확인.
//  - 페이지 로드 시 마스터 한 번 fetch → 해시맵 캐시
//  - input 변경 시 검증 → 미등록이면 노란색 배경 + tooltip
//  - 저장/보내기 시 미등록 상태면 confirm 으로 확인 (진행 자체는 허용)
// ============================================================================
var _RSN_TP_MASTER = null;  // null = 아직 미로딩. {} = 로딩 끝(빈 마스터 포함).

function _loadRsnTpMaster() {
    if (_RSN_TP_MASTER !== null) return;
    fetch("./basicLovData.do?ServiceName=lov-service&category=SZ0000&code=RSN_TP&totalValue=&orderBy=value&displayType=all-code")
        .then(function(r){ return r.text(); })
        .then(function(xmlText){
            var map = {};
            try {
                var doc = new DOMParser().parseFromString(xmlText, "text/xml");
                var opts = doc.querySelectorAll("option");
                for (var i = 0; i < opts.length; i++) {
                    var v = opts[i].getAttribute("value");
                    if (v != null && v.length > 0) map[v.toUpperCase()] = true;
                }
            } catch (e) {}
            _RSN_TP_MASTER = map;
            _validateOcrType();  // 마스터 늦게 로드된 경우 폼 값 재검증
        })
        .catch(function(){ _RSN_TP_MASTER = {}; });  // 실패 시 검증 통과(노란색 X)
}

function _validateOcrType() {
    var el = document.getElementById("f_OCR_TYPE");
    if (!el) return;
    var v = (el.value || "").trim().toUpperCase();
    el.classList.remove('ocr-master-warn');
    el.style.removeProperty('background-color');
    el.style.removeProperty('box-shadow');
    if (_RSN_TP_MASTER === null || v.length === 0) { el.title = ''; return; }
    if (_RSN_TP_MASTER[v]) { el.title = ''; }
    else {
        el.classList.add('ocr-master-warn');
        el.style.setProperty('background-color', '#fff176', 'important');
        el.style.setProperty('box-shadow', 'inset 3px 0 0 #f9a825', 'important');
        el.title = 'RSN_TP 마스터에 등록되지 않은 코드입니다.';
    }
}

function _isOcrTypeUnregistered() {
    if (_RSN_TP_MASTER === null) return false;
    var el = document.getElementById("f_OCR_TYPE");
    if (!el) return false;
    var v = (el.value || "").trim().toUpperCase();
    if (v.length === 0) return false;
    return !_RSN_TP_MASTER[v];
}

// ============================================================================
// 그리드 조회 / 화면 진입
// ============================================================================
function find(eventName, formDivObj, referenceItem) {
    var fromDate = items['C106000190_Form_1'].getDhxForm().getInput('MDF_DH_STR').value;
    var toDate   = items['C106000190_Form_1'].getDhxForm().getInput('MDF_DH_END').value;
    fromDate = get_DateTypeDay(fromDate);
    toDate   = get_DateTypeDay(toDate);
    if (fromDate === '' || toDate === '') { dhtmlx.alert("일자를 입력하지 않았습니다!"); return; }
    if (fromDate > toDate) { dhtmlx.alert("일자를 잘못 입력하였습니다!"); return; }
    var url = uiCommon.parameters('C106000190_Form_1', 'C106000190_Grid_1', eventName);
    items['C106000190_Grid_1'].loadData(url);
}

function refresh(referenceItem) {
    // 그리드 컬럼이 모두 read-only 라 GLUE 가 dataProcessor 를 생성하지 않음.
    // clearDataProcess() 를 호출하면 "UI Action Type 이 정의되지 않았습니다" 알림이 뜨므로 호출하지 않는다.
    var url = uiCommon.parameters('C106000190_Form_1', referenceItem, 'find');
    items[referenceItem].loadData(url);
}

function winClose() {
    if (typeof(parent.winObj) !== 'undefined') parent.winObj.winClose();
    else parent.tabClose();
}

// Form_1 button command="openOcrUpload" 매핑
function openOcrUpload() {
    document.getElementById("realFileInput").click();
}

// ============================================================================
// Form_1 onLoad
// ============================================================================
function onFormLoadEvent() {
    items['C106000190_Form_1'].setItemValue("MDF_DH_END", uiCommon.getCurrentDate());
    var endTmp = items['C106000190_Form_1'].getItemValue("MDF_DH_END");
    var endDate = new Date(endTmp.substring(5,7)+"/"+endTmp.substring(8,10)+"/"+endTmp.substring(0,4));
    var startDate = dateAdd(endDate, -30);
    items['C106000190_Form_1'].setItemValue("MDF_DH_STR", startDate);
    items['C106000190_Form_1'].setItemValue("PROC_STS_CD", "all");
    items['C106000190_Form_1'].getItem("MDF_DH_STR").setWeekStartDay(7);
    items['C106000190_Form_1'].getItem("MDF_DH_END").setWeekStartDay(7);

    // addEventListener 는 누적되므로 onXLE 가 두 번 발생하면 핸들러도 2개 → 같은 파일 선택에 fetch 2번.
    // .onchange 는 덮어쓰기 패턴이라 onXLE 가 N번이어도 핸들러는 항상 1개만 유효함.
    document.getElementById("realFileInput").onchange = function () {
        var file = this.files[0];
        if (!file) return;
        if (file.size > 20 * 1024 * 1024) {
            dhtmlx.alert("파일 크기는 20MB 이하만 가능합니다.");
            this.value = ""; return;
        }
        uploadAndExtract(file);
        this.value = "";
    };

    // RSN_TP 마스터 로딩 + OCR_TYPE input 검증 이벤트 바인딩
    _loadRsnTpMaster();
    var _ft = document.getElementById("f_OCR_TYPE");
    if (_ft) {
        _ft.addEventListener("input",  _validateOcrType);
        _ft.addEventListener("change", _validateOcrType);
        _ft.addEventListener("blur",   _validateOcrType);
    }

    return false;
}

function onGridLoadEvent() {
    var url = uiCommon.parameters('C106000190_Form_1', 'C106000190_Grid_1', "find");
    items['C106000190_Grid_1'].loadData(url);
    items['C106000190_Grid_1'].getDhxGrid().detachEvent(_onXLE);
}

// ============================================================================
// OCR 업로드 → 브라우저에서 Upstage Document Parse 직접 호출
//             → HTML 응답을 라벨 표 휴리스틱으로 매핑 → 이미지+결과 서버 전송
// ----------------------------------------------------------------------------
// 외부통신 정책상 WAS에서 직접 Upstage 호출 불가 → 브라우저가 호출하고
// 결과/원본이미지를 서버에 전달해서 DB 적재만 서버에서 수행.
// document-digitization endpoint는 OCR 결과를 HTML/text/element로 반환하므로
// 라벨 표 구조에 따라 cell 인접관계로 라벨-값 쌍을 추출함.
// ============================================================================

// 라벨 텍스트(부분일치 OK) → 추출 스키마 키
// 주의: -2μm/+2μm 같은 복합 라벨은 OCR_LABEL_MULTI 에서 처리
// 라벨 키워드는 OCR 오타 허용 위해 어근만 사용 (DURABIL → DURABILITY/DURABILTY/DURABLITY 등)
var OCR_LABEL_MAP = [
    { keys: ["CODE"],            field: "code" },
    { keys: ["TYPE"],            field: "type" },
    { keys: ["MUNSEL"],          field: "munsell" },          // MUNSELL/MUNSEL/MUSELL 허용
    { keys: ["GLOSS"],           field: "glossPercentage" },
    { keys: ["PRIMER"],          field: "primer" },
    { keys: ["1C"],              field: "dft1c" },
    { keys: ["2C"],              field: "dft2c" },
    { keys: ["3C"],              field: "dft3c" },
    { keys: ["COLOR"],           field: "color" },
    { keys: ["UNFIX"],           field: "unfixedNumber" },    // UNFIXED/UNFIX 허용
    { keys: ["N.V","NV"],        field: "nv" },
    { keys: ["S.G","SG"],        field: "sg" },
    { keys: ["V.I.S","VIS"],     field: "vis" },
    { keys: ["MAKER"],           field: "maker" },
    { keys: ["WORK"],            field: "workDate" },         // WORK DATE/WORK 등
    { keys: ["APPROV"],          field: "approvedDate" },     // APPROVED/APPROV 등
    { keys: ["DISUS"],           field: "disusedDate" },      // DISUSED/DISUS 등
    { keys: ["END USER","ENDUSER"], field: "endUser" },
    { keys: ["DURABIL"],         field: "durability" },       // DURABILITY/DURABILTY/DURABLITY 등
    { keys: ["MEMO"],            field: "memo" },
    // 라벨 본문 좌하단 "DONGKUK CM" 셀 옆 빈 칸에 담당자 이름이 들어감.
    // OCR 응답에서 "DONGKUK CM" 텍스트 자체를 라벨 셀로 인식해 같은 tr 의 다음 셀을 값으로 매핑.
    { keys: ["DONGKUK"],         field: "charger" }
];
// 단일 ΔE는 -2μm/+2μm와 헷갈리므로 별도 처리. 라벨 셀에 μ/UM 포함이면 multi로 빠짐
var OCR_LABEL_DELTAE = { keys: ["ΔE","DELTA E","DELTAE","△E"], field: "deltaE" };
// 한 글자 라벨은 정확 매칭으로만 (L/a/b 등이 다른 단어에 끼어드는 것 방지)
var OCR_LABEL_MAP_EXACT = [
    { keys: ["L"], field: "l" },
    { keys: ["a"], field: "a" },
    { keys: ["b"], field: "b" }
];
// 복합 라벨 (-2μm/+2μm) - 값이 4개 연달아 오거나 한 셀에 콤마구분으로 옴
// Upstage 가 μ 를 누락해 "-2m(...)" 식으로 읽는 케이스 다수 → 괄호 포함 키워드 추가.
var OCR_LABEL_MULTI = [
    { keys: ["-2μm","-2UM","-2um","-2 μ","- 2μ","-2m(","-2M(","- 2m(","-2M ("], fields: ["minus2DE","minus2DL","minus2DA","minus2DB"] },
    { keys: ["+2μm","+2UM","+2um","+2 μ","+ 2μ","+2m(","+2M(","+ 2m(","+2M ("], fields: ["plus2DE","plus2DL","plus2DA","plus2DB"] }
];

function _normText(t) {
    return (t == null ? "" : String(t)).replace(/\s+/g, " ").trim();
}
function _matchKeys(text, keys, exact) {
    var up = text.toUpperCase();
    for (var j = 0; j < keys.length; j++) {
        var k = keys[j].toUpperCase();
        if (exact) { if (text === keys[j]) return true; }
        else { if (up.indexOf(k) >= 0) return true; }
    }
    return false;
}
function _findFieldByPartial(text, used, suppressDeltaE) {
    // -2μm/+2μm 같은 복합 라벨에 deltaE가 포함되어 있는 경우 단일 deltaE로 잡으면 안 됨.
    // suppressDeltaE=true 면 같은 행에 ΔL/Δa/Δb 가 있는 경우(=Δ-series 행)이므로 standalone ΔE 매칭 차단.
    if (!suppressDeltaE && !_isMultiLabel(text)) {
        if (!used[OCR_LABEL_DELTAE.field] && _matchKeys(text, OCR_LABEL_DELTAE.keys, false)) {
            return OCR_LABEL_DELTAE.field;
        }
    }
    for (var i = 0; i < OCR_LABEL_MAP.length; i++) {
        if (used[OCR_LABEL_MAP[i].field]) continue;
        if (_matchKeys(text, OCR_LABEL_MAP[i].keys, false)) return OCR_LABEL_MAP[i].field;
    }
    return null;
}
function _findFieldByExact(text, used) {
    for (var i = 0; i < OCR_LABEL_MAP_EXACT.length; i++) {
        if (used[OCR_LABEL_MAP_EXACT[i].field]) continue;
        if (_matchKeys(text, OCR_LABEL_MAP_EXACT[i].keys, true)) return OCR_LABEL_MAP_EXACT[i].field;
    }
    return null;
}
function _findMultiLabel(text, used) {
    for (var i = 0; i < OCR_LABEL_MULTI.length; i++) {
        var fs = OCR_LABEL_MULTI[i].fields;
        if (used[fs[0]]) continue;
        if (_matchKeys(text, OCR_LABEL_MULTI[i].keys, false)) return OCR_LABEL_MULTI[i];
    }
    return null;
}
function _isMultiLabel(text) {
    for (var i = 0; i < OCR_LABEL_MULTI.length; i++) {
        if (_matchKeys(text, OCR_LABEL_MULTI[i].keys, false)) return true;
    }
    return false;
}
function _isLabelCell(text) {
    if (!text) return true;
    if (_isMultiLabel(text)) return true;
    if (_matchKeys(text, OCR_LABEL_DELTAE.keys, false)) return true;
    for (var i = 0; i < OCR_LABEL_MAP.length; i++) {
        if (_matchKeys(text, OCR_LABEL_MAP[i].keys, false)) return true;
    }
    for (var i = 0; i < OCR_LABEL_MAP_EXACT.length; i++) {
        if (_matchKeys(text, OCR_LABEL_MAP_EXACT[i].keys, true)) return true;
    }
    return false;
}
// -2μm/+2μm 표의 서브헤더 셀 여부 (ΔE/ΔL/Δa/Δb, △E/L/a/b, DE/DL/DA/DB)
function _isDeltaSubHeader(text) {
    if (!text) return false;
    var t = String(text).replace(/\s+/g, "").toUpperCase();
    var keys = ["ΔE","ΔL","ΔA","ΔB","△E","△L","△A","△B","DE","DL","DA","DB"];
    for (var i = 0; i < keys.length; i++) if (t === keys[i].toUpperCase()) return true;
    return false;
}
// 이 행에 ΔL/Δa/Δb 중 하나라도 있는지 — 있으면 같은 행의 ΔE 는 standalone 이 아니라 sub-header 로 간주해야 한다.
// (standalone ΔE 는 단독 라벨 행에 N.V 같은 다른 라벨과 함께 등장하므로 Δ-series 패턴이 아님)
function _rowHasDeltaSubHeader(texts) {
    var keys = ["ΔL","ΔA","ΔB","△L","△A","△B","DL","DA","DB"];
    for (var i = 0; i < texts.length; i++) {
        var t = (texts[i] || "").replace(/\s+/g, "").toUpperCase();
        for (var k = 0; k < keys.length; k++) if (t === keys[k].toUpperCase()) return true;
    }
    return false;
}
// 이 행이 -2μm/+2μm 라벨만 있고 (같은 행에 값이 없음) standalone multi header 인지 검사.
// standalone 이면 다음 행을 값 행으로 소비할 수 있도록 pendingMultiHeader 로 표시.
function _detectStandaloneMultiHeader(texts, used) {
    var foundMulti = null;
    var hasNumericValue = false;
    for (var i = 0; i < texts.length; i++) {
        var t = texts[i];
        if (!t) continue;
        if (foundMulti === null) {
            for (var mi = 0; mi < OCR_LABEL_MULTI.length; mi++) {
                if (used[OCR_LABEL_MULTI[mi].fields[0]]) continue;
                if (_matchKeys(t, OCR_LABEL_MULTI[mi].keys, false)) { foundMulti = OCR_LABEL_MULTI[mi]; break; }
            }
        }
        if (_isDeltaSubHeader(t)) continue;
        if (_isMultiLabel(t)) continue;
        if (_matchKeys(t, OCR_LABEL_DELTAE.keys, false)) continue; // ΔE single label 도 sub-header 로 본다 (값 셀 아님)
        var toks = _splitNumericTokens(t);
        if (toks.length > 0) { hasNumericValue = true; break; }
    }
    if (foundMulti && !hasNumericValue) return foundMulti;
    return null;
}

// 같은 셀에 "라벨:값" 또는 라벨 뒤 공백 값 형태로 합쳐져 있는지 확인
function _extractInlineValue(labelText) {
    var colonIdx = labelText.indexOf(":");
    if (colonIdx >= 0 && colonIdx < labelText.length - 1) {
        return labelText.substring(colonIdx + 1).trim();
    }
    return null;
}
// 문자열에서 콤마/공백으로 구분된 숫자 토큰 추출
function _splitNumericTokens(text) {
    if (!text) return [];
    var parts = String(text).split(/[,\s\/]+/);
    var out = [];
    for (var i = 0; i < parts.length; i++) {
        var p = parts[i].replace(/[^\d\-.]/g, "");
        if (p && p !== "-" && p !== ".") out.push(p);
    }
    return out;
}

// 필드별 값 형식 검증 — 라벨이 잘못 인접한 값을 끌어오는 사고 방지.
// 숫자/날짜 필드에 형식이 안 맞으면 false 반환해서 매핑 자체를 보류한다.
var OCR_NUMERIC_FIELDS = {
    glossPercentage:1, dft1c:1, dft2c:1, dft3c:1,
    nv:1, l:1, a:1, b:1, sg:1, vis:1, deltaE:1,
    minus2DE:1, minus2DL:1, minus2DA:1, minus2DB:1,
    plus2DE:1, plus2DL:1, plus2DA:1, plus2DB:1
};
var OCR_DATE_FIELDS = { workDate:1, approvedDate:1, disusedDate:1 };
function _validForField(field, value) {
    if (value == null) return false;
    var v = String(value).trim();
    if (v.length === 0) return false;
    if (OCR_NUMERIC_FIELDS[field]) {
        // 숫자 토큰이 하나라도 들어있어야 함
        return /-?\d+(\.\d+)?/.test(v);
    }
    if (OCR_DATE_FIELDS[field]) {
        // yyyymmdd / yyyy-mm-dd / yyyy.mm.dd / yyyy/mm/dd
        return /\d{4}[\-./]?\d{1,2}[\-./]?\d{1,2}/.test(v);
    }
    return true;
}

// 시퀀스 헤더(예: 1C/2C/3C) 감지 — 한 행에 모두 들어 있는지 확인
function _detectSequenceHeader(texts, used) {
    var idx1 = -1, idx2 = -1, idx3 = -1;
    for (var i = 0; i < texts.length; i++) {
        var t = String(texts[i]).replace(/\s+/g, "").toUpperCase();
        if (t === "1C") idx1 = i;
        else if (t === "2C") idx2 = i;
        else if (t === "3C") idx3 = i;
    }
    if (idx1 >= 0 && idx2 >= 0 && idx3 >= 0) {
        if (used.dft1c || used.dft2c || used.dft3c) return null;
        return { fields: ["dft1c", "dft2c", "dft3c"], type: "dft" };
    }
    return null;
}

// 한 tr 의 cell 텍스트 배열을 받아 라벨-값 매핑을 result 에 누적.
// source[field] = 'primary' (같은 행 1차 매핑 성공) / 'fallback' (보조 로직) 으로 추적.
function _mapRowCells(texts, result, used, source) {
    // 이 행에 ΔL/Δa/Δb 가 있으면 ΔE 는 sub-header. standalone deltaE 매칭 차단.
    var suppressDeltaE = _rowHasDeltaSubHeader(texts);
    for (var i = 0; i < texts.length; i++) {
        var labelText = texts[i];
        if (!labelText) continue;

        // 1) 복합 라벨 (-2μm/+2μm) — 같은 행 안에서만 값 수집
        var multi = _findMultiLabel(labelText, used);
        if (multi) {
            var values = [];
            for (var j = i + 1; j < texts.length && values.length < 4; j++) {
                var v = texts[j];
                if (!v) continue;
                if (_isDeltaSubHeader(v)) continue;
                if (_isLabelCell(v)) break;
                var toks = _splitNumericTokens(v);
                if (toks.length === 0) continue;
                for (var k = 0; k < toks.length && values.length < 4; k++) values.push(toks[k]);
            }
            for (var k = 0; k < multi.fields.length; k++) {
                if (k < values.length) {
                    result[multi.fields[k]] = values[k];
                    if (source) source[multi.fields[k]] = 'primary';
                }
                used[multi.fields[k]] = true;
            }
            // 같은 행에 다른 라벨이 더 있을 수 있으므로 continue
            i = i; // 인덱스는 그대로 두고 다음 i++ 진행
            continue;
        }

        // 2) 단일 라벨
        var field = _findFieldByPartial(labelText, used, suppressDeltaE);
        if (!field) field = _findFieldByExact(labelText, used);
        if (!field) continue;

        // inline value (라벨:값 합쳐진 셀)
        var inlineVal = _extractInlineValue(labelText);
        if (inlineVal) {
            if (_validForField(field, inlineVal)) {
                result[field] = inlineVal;
                used[field] = true;
                if (source) source[field] = 'primary';
            }
            continue;
        }

        // 같은 행 안에서 다음 비-빈/비-라벨 셀을 값으로 채택
        for (var jj = i + 1; jj < texts.length; jj++) {
            var v = texts[jj];
            if (!v) continue;
            if (_isLabelCell(v)) break;
            if (_validForField(field, v)) {
                result[field] = v;
                used[field] = true;
                if (source) source[field] = 'primary';
            }
            // TYPE 캡처 직후 다음 셀이 라벨이 아니면 품질수지 텍스트로 보관 (예: Z2 다음의 "PVC SOL")
            // 이미지에 TYPE 셀 안에 구매수지(Z2)/품질수지(PVC SOL) 두 값이 들어있는 케이스 대응.
            if (field === "type" && !used.qtType) {
                for (var jq = jj + 1; jq < texts.length; jq++) {
                    var vq = texts[jq];
                    if (!vq) continue;
                    if (_isLabelCell(vq)) break;
                    result.qtType = vq;
                    used.qtType = true;
                    if (source) source.qtType = 'primary';
                    i = jq;     // 캡처한 셀까지 outer 인덱스 점프
                    break;
                }
                if (used.qtType) break;
            }
            // 첫 비-빈 비-라벨 셀에서 결정 (다음 라벨이 같은 행에 있을 수 있으므로 i = jj 로 점프)
            i = jj;
            break;
        }
    }
}

// Document Parse HTML 응답에서 표를 tr 단위로 순회 → 스키마 키로 매핑
function mapHtmlToFields(html) {
    var result = {};
    if (!html) return result;
    var doc;
    try { doc = new DOMParser().parseFromString(html, "text/html"); }
    catch (e) { return result; }

    var trs = doc.querySelectorAll("tr");
    var used = {};
    var source = {};                // field 별 매핑 출처: 'primary' (1차) / 'fallback' (보조)
    var pendingHeader = null;       // 직전 행이 시퀀스 헤더면 다음 행이 값 행
    var pendingMultiHeader = null;  // 직전 행이 -2μm/+2μm 라벨만 있는 standalone 헤더면 다음 행이 Δ-series 값 행

    for (var ri = 0; ri < trs.length; ri++) {
        // Upstage 응답이 가끔 <table><tr><td><table>...</table></td></tr></table> 형태의 nested table 로 옴.
        // 이 wrapper tr 를 처리하면 querySelectorAll("td, th") 가 inner td 까지 평탄화해서 가져오는데,
        // 그 결과 _detectSequenceHeader 가 평탄화된 셀들에서 1C/2C/3C 를 잘못 발견 → pendingHeader 설정 →
        // 다음 inner tr(예: GLOSS/PRIMER row)이 pendingHeader 로 잘못 처리되어 used.dft 만 채워지고
        // 정작 GLOSS/PRIMER/DFT 라벨 매핑은 전부 실패함. 컨테이너 tr 는 skip 하고 leaf tr 만 처리.
        if (trs[ri].querySelector("table") !== null) continue;

        var cells = trs[ri].querySelectorAll("td, th");
        var texts = [];
        for (var ci = 0; ci < cells.length; ci++) texts.push(_normText(cells[ci].textContent));

        // 직전 행이 1C/2C/3C 헤더였다면 → 이 행의 값들을 차례로 매핑
        if (pendingHeader) {
            var k = 0;
            for (var ti = 0; ti < texts.length && k < pendingHeader.fields.length; ti++) {
                var v = texts[ti];
                if (!v) continue;
                if (_isLabelCell(v)) break;          // 라벨 만나면 중단
                var fld = pendingHeader.fields[k];
                if (!used[fld] && _validForField(fld, v)) {
                    result[fld] = v;
                    source[fld] = 'primary';
                }
                used[fld] = true;
                k++;
            }
            // 못 채운 필드도 used 처리 (이후 일반 매핑이 잘못 끌어오지 않도록)
            while (k < pendingHeader.fields.length) {
                used[pendingHeader.fields[k]] = true;
                k++;
            }
            pendingHeader = null;
            continue;
        }

        // 직전 행이 -2μm/+2μm standalone 헤더였다면 → 이 행의 숫자 토큰을 sub-header(ΔE/ΔL/Δa/Δb) 건너뛰며 4개까지 수집
        if (pendingMultiHeader) {
            var mvals = [];
            for (var ti = 0; ti < texts.length && mvals.length < 4; ti++) {
                var v = texts[ti];
                if (!v) continue;
                if (_isDeltaSubHeader(v)) continue;
                if (_isMultiLabel(v)) continue;
                // ΔE single label 도 sub-header 로 취급 (이 행은 multi 값 행)
                if (_matchKeys(v, OCR_LABEL_DELTAE.keys, false)) continue;
                var toks = _splitNumericTokens(v);
                for (var kk = 0; kk < toks.length && mvals.length < 4; kk++) mvals.push(toks[kk]);
            }
            for (var kk = 0; kk < pendingMultiHeader.fields.length; kk++) {
                if (kk < mvals.length) {
                    result[pendingMultiHeader.fields[kk]] = mvals[kk];
                    source[pendingMultiHeader.fields[kk]] = 'primary';
                }
                used[pendingMultiHeader.fields[kk]] = true;
            }
            pendingMultiHeader = null;
            continue;
        }

        // 이 행이 시퀀스 헤더(1C/2C/3C 한 행)인지 검사
        var seq = _detectSequenceHeader(texts, used);
        if (seq) {
            pendingHeader = seq;
            continue;
        }

        // 이 행이 -2μm/+2μm 라벨만 있는 standalone 헤더인지 검사
        var mh = _detectStandaloneMultiHeader(texts, used);
        if (mh) {
            pendingMultiHeader = mh;
            continue;
        }

        // 일반 라벨-값 매핑 (같은 행 안에서만)
        _mapRowCells(texts, result, used, source);
    }

    // 표 외부의 자유 텍스트(<p>, plain text) 대비 — tr 매핑으로 못 잡은 필드를 위한 fallback 없음.
    // 라벨 외부에 있는 데이터는 OCR 인식 단계에서 라벨화되지 않으므로 무시한다.

    // 페인트 비중(S.G)은 실제 라벨이 1.x 범위 소수점인데, OCR 이 점을 콤마로 잘못 읽는 케이스가 잦음.
    // 매핑된 sg 값의 콤마를 점으로 보정 → 폼/DB 모두 정상 값으로 저장.
    if (result.sg && String(result.sg).indexOf(",") >= 0) {
        result.sg = String(result.sg).replace(/,/g, ".");
    }

    // qtType (품질수지) cross-row fallback: TYPE 값(예: Z2) 셀 다음의 비-라벨 셀을 품질수지 텍스트로 채택.
    // _mapRowCells 의 같은 행 매핑에서 못 잡은 경우 (PVC SOL 이 다른 tr 에 있는 케이스).
    if (!result.qtType && result.type) {
        var flatCells = doc.querySelectorAll("td, th");
        var flatTexts = [];
        for (var fi = 0; fi < flatCells.length; fi++) flatTexts.push(_normText(flatCells[fi].textContent));
        var typeValIdx = -1;
        for (var fi = 0; fi < flatTexts.length; fi++) {
            if (flatTexts[fi] === result.type) { typeValIdx = fi; break; }
        }
        if (typeValIdx >= 0) {
            for (var fj = typeValIdx + 1; fj < flatTexts.length; fj++) {
                var v = flatTexts[fj];
                if (!v) continue;
                if (_isLabelCell(v)) break;
                // 숫자만 있는 셀은 무시 (다른 필드의 수치값일 가능성)
                if (/^[-\d.,\s]+$/.test(v)) continue;
                result.qtType = v;
                source.qtType = 'fallback';
                break;
            }
        }
    }

    // Durability fallback: OCR 이 'Durability' 라벨과 'Y'/'N' 값을 다른 행으로 쪼개는 경우
    // _mapRowCells 의 같은 행 매핑에서 누락됨. 전체 셀 평탄화해서 DURABIL 셀 이후
    // 첫 비-라벨 Y/N 셀을 채택한다.
    if (!result.durability) {
        var flatCells = doc.querySelectorAll("td, th");
        var flatTexts = [];
        for (var fi = 0; fi < flatCells.length; fi++) flatTexts.push(_normText(flatCells[fi].textContent));
        var labelIdx = -1;
        for (var fi = 0; fi < flatTexts.length; fi++) {
            if (flatTexts[fi].toUpperCase().indexOf("DURABIL") >= 0) { labelIdx = fi; break; }
        }
        if (labelIdx >= 0) {
            for (var fj = labelIdx + 1; fj < flatTexts.length; fj++) {
                var v = flatTexts[fj];
                if (!v) continue;
                if (_isLabelCell(v)) break;
                var up = v.toUpperCase().replace(/\s+/g, '');
                if (up === 'Y' || up === 'N' || up === 'YES' || up === 'NO') {
                    result.durability = up.charAt(0);
                    source.durability = 'fallback';
                    break;
                }
            }
        }
    }

    // OCR_COLOR mojibake 처리: Upstage 가 한글 인식 실패 시 U+FFFD(REPLACEMENT CHARACTER)
    // 또는 다수 ? 가 포함된 문자열을 반환. 깨진 문자만 제거하고 남은 텍스트 유지.
    // 완전 깨짐(strip 후 1자 미만) 이면 result.color 자체 제거 → 빈값으로 분류.
    if (result.color) {
        var origColor = String(result.color);
        var cleaned = origColor.replace(/�+/g, '').replace(/\s+/g, ' ').trim();
        if (cleaned.length === 0) {
            delete result.color;
            delete source.color;
        } else if (cleaned !== origColor) {
            result.color = cleaned;
            source.color = 'fallback';   // 부분 정상 + 부분 깨짐 → 사용자 검토 권장
        }
    }

    result.__source = source;
    return result;
}

function uploadAndExtract(file) {
    if (!UPSTAGE_API_KEY || UPSTAGE_API_KEY.length === 0) {
        dhtmlx.alert("Upstage API 키가 설정되지 않았습니다. 관리자에게 문의하세요.");
        return;
    }
    // 한 번의 업로드 흐름이 끝나기 전 중복 호출 차단 (OCR_NO 중복 채번 방지)
    if (_ocrUploading) return;
    _ocrUploading = true;
    showProgress(true, "① 이미지 업로드 + OCR 분석 중... (10~20초 소요)");

    var fd = new FormData();
    fd.append("document", file);
    fd.append("model", "document-parse");
    fd.append("output_formats", '["html","text"]');
    fd.append("ocr", "auto");

    fetch(UPSTAGE_API_URL, {
        method: "POST",
        headers: { "Authorization": "Bearer " + UPSTAGE_API_KEY },
        body: fd
    })
    .then(function(r){
        return r.text().then(function(t){ return { ok: r.ok, status: r.status, text: t }; });
    })
    .then(function(resp) {
        if (!resp.ok) {
            showProgress(false);
            dhtmlx.alert("Upstage API 호출 실패: HTTP " + resp.status + "\n" + (resp.text || "").substring(0, 300));
            return;
        }
        var upstageJson;
        try { upstageJson = JSON.parse(resp.text); }
        catch (e) {
            showProgress(false);
            dhtmlx.alert("Upstage 응답 파싱 실패");
            return;
        }
        setProgressStage("② OCR 결과 정리 중...");
        var html = (upstageJson && upstageJson.content && upstageJson.content.html) || "";
        var extracted = mapHtmlToFields(html);

        setProgressStage("③ 서버에 저장 중...");
        var fd2 = new FormData();
        fd2.append("image", file);
        fd2.append("extracted_json", JSON.stringify(extracted));
        fd2.append("raw_json", resp.text);

        return fetch("./_c10OcrProxyHandler.jsp", { method: "POST", body: fd2 })
            .then(function(r){ return r.json(); })
            .then(function(data){
                showProgress(false);
                if (!data.success) {
                    dhtmlx.alert("저장 실패: " + (data.message || "알 수 없는 오류"));
                    return;
                }
                currentOcrNo = data.ocrNo;
                // server round-trip 시 __source 가 누락될 가능성에 대비해 client extracted 의 __source 를 보강.
                var srvExt = data.extracted || extracted;
                if (srvExt && !srvExt.__source && extracted && extracted.__source) srvExt.__source = extracted.__source;
                populateFromExtracted(srvExt);
                showOcrImage(data.ocrNo);
                refresh('C106000190_Grid_1');
                dhtmlx.message({ type:"info", text:"OCR 추출 완료 (OCR_NO=" + data.ocrNo + ")", expire:3000 });
            });
    })
    .catch(function(err){
        showProgress(false);
        dhtmlx.alert("업로드/추출 중 오류: " + err);
    })
    .then(function(){ _ocrUploading = false; }, function(){ _ocrUploading = false; });
}

// Upstage 응답의 extracted{} 를 폼 필드에 매핑
function populateFromExtracted(ext) {
    function pick() {
        for (var i = 0; i < arguments.length; i++) {
            var k = arguments[i];
            if (ext && ext[k] != null && String(ext[k]).length > 0) return ext[k];
        }
        return '';
    }
    var durRaw = pick('durability');
    var dur = String(durRaw || '').toUpperCase();
    var durVal = (dur.charAt(0) === 'Y') ? 'Y' : (dur.charAt(0) === 'N' ? 'N' : '');

    setF('OCR_CODE',        pick('code'));
    setF('OCR_TYPE',        pick('type'));
    setF('OCR_QT_TYPE',     pick('qtType'));
    setF('OCR_MUNSELL',     pick('munsell'));
    setF('OCR_GLOSS',       pick('glossPercentage','gloss'));
    setF('OCR_PRIMER',      pick('primer'));
    setF('OCR_DFT_1C',      pick('dft1c','1C'));
    setF('OCR_DFT_2C',      pick('dft2c','2C'));
    setF('OCR_DFT_3C',      pick('dft3c','3C'));
    setF('OCR_COLOR',       pick('color'));
    setF('OCR_UNFIXED_NO',  pick('unfixedNumber','unfixedNo'));
    setF('OCR_DELTA_E',     pick('deltaE'));
    setF('OCR_NV',          pick('nv','N.V'));
    setF('OCR_L',           pick('l','L'));
    setF('OCR_A',           pick('a'));
    setF('OCR_B',           pick('b'));
    setF('OCR_SG',          pick('sg','S.G'));
    // V.I.S 는 일반적으로 NNN±NN 형식. Upstage 가 ± 를 누락하는 경우가 있어
    // 5 자리 순수 숫자(예: "35050")면 마지막 2자리를 tolerance 로 보고 ± 삽입(→ "350±50").
    var visVal = pick('vis');
    if (visVal && /^\d{5}$/.test(visVal)) {
        visVal = visVal.substring(0, 3) + '±' + visVal.substring(3);
    }
    setF('OCR_VIS',         visVal);
    setF('OCR_MAKER',       pick('maker'));
    setF('OCR_WORK_DT',     _normDateStr(pick('workDate')));
    setF('OCR_APPROVED_DT', _normDateStr(pick('approvedDate')));
    setF('OCR_DISUSED_DT',  _normDateStr(pick('disusedDate')));
    setF('OCR_END_USER',    pick('endUser'));
    setF('OCR_DURABILITY',  durVal);
    setF('OCR_MEMO',        pick('memo'));
    setF('OCR_CHARGER',     pick('charger'));

    setF('OCR_M2_DE',       pick('minus2DE'));
    setF('OCR_M2_DL',       pick('minus2DL'));
    setF('OCR_M2_DA',       pick('minus2DA'));
    setF('OCR_M2_DB',       pick('minus2DB'));
    setF('OCR_P2_DE',       pick('plus2DE'));
    setF('OCR_P2_DL',       pick('plus2DL'));
    setF('OCR_P2_DA',       pick('plus2DA'));
    setF('OCR_P2_DB',       pick('plus2DB'));

    _applyAllFieldSources(ext && ext.__source);
    _validateOcrType();   // setF 는 input 이벤트 발생 안 시키므로 명시적 호출
}

// 폼 필드 ID → mapHtmlToFields source key 매핑
var _FIELD_TO_SOURCE_KEY = {
    'OCR_CODE':'code','OCR_TYPE':'type','OCR_QT_TYPE':'qtType','OCR_MUNSELL':'munsell',
    'OCR_GLOSS':'glossPercentage','OCR_PRIMER':'primer',
    'OCR_DFT_1C':'dft1c','OCR_DFT_2C':'dft2c','OCR_DFT_3C':'dft3c',
    'OCR_COLOR':'color','OCR_UNFIXED_NO':'unfixedNumber','OCR_DELTA_E':'deltaE',
    'OCR_NV':'nv','OCR_L':'l','OCR_A':'a','OCR_B':'b','OCR_SG':'sg','OCR_VIS':'vis',
    'OCR_MAKER':'maker','OCR_WORK_DT':'workDate','OCR_APPROVED_DT':'approvedDate',
    'OCR_DISUSED_DT':'disusedDate','OCR_END_USER':'endUser','OCR_DURABILITY':'durability',
    'OCR_MEMO':'memo','OCR_CHARGER':'charger',
    'OCR_M2_DE':'minus2DE','OCR_M2_DL':'minus2DL','OCR_M2_DA':'minus2DA','OCR_M2_DB':'minus2DB',
    'OCR_P2_DE':'plus2DE','OCR_P2_DL':'plus2DL','OCR_P2_DA':'plus2DA','OCR_P2_DB':'plus2DB'
};

// 시각화 색상
//  primary  : 기본색 (변경 없음)
//  fallback : 연한 주황 — 보조 로직으로 채워짐, 검토 권장
//  empty    : 연한 회색 — 자동 매핑 실패
var _SRC_COLOR  = { 'primary':'', 'fallback':'#ffb74d', 'empty':'#ffcdd2' };
var _SRC_BORDER = { 'primary':'', 'fallback':'inset 3px 0 0 #f57c00', 'empty':'inset 3px 0 0 #e53935' };
var _SRC_TOOLTIP = {
    'fallback':'자동 매핑 보조 로직으로 채워진 값입니다. 확인해주세요.',
    'empty':'자동 매핑 실패. 직접 입력해주세요.'
};

function _applyFieldSource(fieldId, sourceMap) {
    var el = document.getElementById('f_' + fieldId);
    if (!el) return;
    if (fieldId === 'OCR_TYPE') return;
    var srcKey = _FIELD_TO_SOURCE_KEY[fieldId];
    var isEmpty = (el.tagName === 'SELECT') ? (el.selectedIndex <= 0) : ((el.value || '').length === 0);
    var src = (sourceMap && srcKey) ? sourceMap[srcKey] : null;
    var bucket;
    if (isEmpty)                 bucket = 'empty';
    else if (src === 'fallback') bucket = 'fallback';
    else                         bucket = 'primary';
    el.classList.remove('ocr-src-fallback', 'ocr-src-empty');
    if (bucket === 'fallback') el.classList.add('ocr-src-fallback');
    else if (bucket === 'empty') el.classList.add('ocr-src-empty');
    var color = _SRC_COLOR[bucket] || '';
    var border = _SRC_BORDER[bucket] || '';
    if (color) el.style.setProperty('background-color', color, 'important');
    else el.style.removeProperty('background-color');
    if (border) el.style.setProperty('box-shadow', border, 'important');
    else el.style.removeProperty('box-shadow');
    el.title = _SRC_TOOLTIP[bucket] || '';
}

function _applyAllFieldSources(sourceMap) {
    for (var i = 0; i < OCR_FIELDS.length; i++) _applyFieldSource(OCR_FIELDS[i], sourceMap);
}

// DB 단건 조회 결과(JSON)를 폼에 채움
function populateFromDb(d) {
    for (var i = 0; i < OCR_FIELDS.length; i++) {
        var f = OCR_FIELDS[i];
        var v = d[f] == null ? '' : d[f];
        if (f === 'OCR_WORK_DT' || f === 'OCR_APPROVED_DT' || f === 'OCR_DISUSED_DT') {
            v = _normDateStr(v);
        }
        setF(f, v);
    }
    // DB 재조회는 매핑 출처를 모르므로 시각화 초기화 (모든 필드 기본색)
    _applyAllFieldSources(null);
    _validateOcrType();
}

function setF(name, val) {
    var el = document.getElementById('f_' + name);
    if (!el) return;
    var v = (val == null) ? '' : String(val);
    // select 인 경우 옵션 매칭 후 selectedIndex 로 강제 선택 (.value 할당이 trim/대소문자 차이로 실패할 수 있음)
    if (el.tagName === 'SELECT') {
        var t = v.replace(/\s+/g, '').toUpperCase();
        var matched = -1;
        for (var i = 0; i < el.options.length; i++) {
            var ov = String(el.options[i].value).replace(/\s+/g, '').toUpperCase();
            if (ov === t) { matched = i; break; }
        }
        el.selectedIndex = (matched >= 0) ? matched : 0;
        return;
    }
    el.value = v;
}
function getF(name) {
    var el = document.getElementById('f_' + name);
    return el ? el.value : '';
}
function clearForm() {
    for (var i = 0; i < OCR_FIELDS.length; i++) setF(OCR_FIELDS[i], '');
}

// 날짜 normalize: 숫자만 남기고 8자리(YYYYMMDD)로. 6자리(YYMMDD)는 '20' 보정.
// OCR_WORK_DT / OCR_APPROVED_DT / OCR_DISUSED_DT 가 VARCHAR2(8) 라 hyphen/dot 포함 시 길이 초과로 저장 실패.
function _normDateStr(s) {
    if (s == null) return '';
    var digits = String(s).replace(/\D/g, '');
    if (digits.length === 6) digits = '20' + digits;
    if (digits.length >= 8) return digits.substring(0, 8);
    return '';
}

// 미리보기 이미지 현재 회전값 (0/90/180/270) — 확대 뷰어로 그대로 전달됨
var _ocrThumbRotate = 0;

// 이미지 미리보기 (썸네일 상태에서도 ±90° 회전 가능, 클릭 시 전체화면 확대 뷰어)
function showOcrImage(ocrNo) {
    _ocrThumbRotate = 0;
    var box = document.getElementById("ocr_image_box");
    var url = "./_c10OcrImage.jsp?ocrNo=" + encodeURIComponent(ocrNo) + "&_t=" + (new Date()).getTime();
    box.innerHTML =
        "<div class='ocr-thumb-toolbar'>" +
        "  <button type='button' id='ocr_thumb_rot_l' title='왼쪽 90° 회전'>⟲ 90°</button>" +
        "  <button type='button' id='ocr_thumb_rot_r' title='오른쪽 90° 회전'>⟳ 90°</button>" +
        "</div>" +
        "<img id='ocr_thumb_img' src='" + url + "' alt='OCR 원본' style='cursor:zoom-in;' title='클릭하면 확대보기'/>";

    var thumb = document.getElementById("ocr_thumb_img");
    if (thumb) {
        thumb.onclick = function() { openOcrImageViewer(url, _ocrThumbRotate); };
        thumb.onload  = _applyOcrThumbRotate;   // 이미지 로드 완료 후 첫 렌더
    }
    document.getElementById("ocr_thumb_rot_l").onclick = function() {
        _ocrThumbRotate = (_ocrThumbRotate + 270) % 360;
        _applyOcrThumbRotate();
    };
    document.getElementById("ocr_thumb_rot_r").onclick = function() {
        _ocrThumbRotate = (_ocrThumbRotate + 90) % 360;
        _applyOcrThumbRotate();
    };
}

// 썸네일 이미지에 현재 회전값 반영.
// 90/270° 회전 시 이미지의 width/height 축이 뒤바뀌므로 컨테이너에 맞게 scale 재계산.
function _applyOcrThumbRotate() {
    var thumb = document.getElementById("ocr_thumb_img");
    var box   = document.getElementById("ocr_image_box");
    if (!thumb || !box || !thumb.naturalWidth) return;

    var boxW = box.clientWidth, boxH = box.clientHeight;
    var nW = thumb.naturalWidth, nH = thumb.naturalHeight;

    var scale = (_ocrThumbRotate % 180 === 0)
        ? Math.min(boxW / nW, boxH / nH)   // 0/180°: 원본 축 그대로
        : Math.min(boxW / nH, boxH / nW);  // 90/270°: 축 뒤바뀜

    thumb.style.width  = nW + "px";
    thumb.style.height = nH + "px";
    thumb.style.transform = "translate(-50%,-50%) rotate(" + _ocrThumbRotate + "deg) scale(" + scale + ")";
}

// 전체화면 이미지 뷰어 (휠 zoom + 드래그 이동 + 회전 ±90° + ESC/클릭 닫기)
//   단축키: ←/→ 회전, ESC 닫기
//   initRotate: 썸네일에서 이미 회전한 상태(0/90/180/270)를 유지한 채 열기 위한 초기값
function openOcrImageViewer(imgUrl, initRotate) {
    var old = document.getElementById("ocrImgViewerOverlay");
    if (old) old.parentNode.removeChild(old);

    var overlay = document.createElement("div");
    overlay.id = "ocrImgViewerOverlay";
    overlay.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;"
        + "background:rgba(0,0,0,0.85);z-index:99999;display:flex;"
        + "align-items:center;justify-content:center;cursor:pointer;overflow:hidden;";

    var img = document.createElement("img");
    img.src = imgUrl;
    img.style.cssText = "max-width:90%;max-height:90%;"
        + "transform:translate(0px,0px) rotate(" + (initRotate || 0) + "deg) scale(1);"
        + "transition:transform 0.1s ease;cursor:grab;user-select:none;background:#fff;";

    var scale = 1, posX = 0, posY = 0, rotate = (initRotate || 0);
    var isDragging = false, startX = 0, startY = 0;

    function updateTransform() {
        img.style.transform = "translate(" + posX + "px," + posY + "px) "
                            + "rotate(" + rotate + "deg) "
                            + "scale(" + scale + ")";
    }
    function rotateBy(delta) {
        rotate = (rotate + delta + 360) % 360;
        posX = 0; posY = 0;  // 회전 후 중앙 정렬
        updateTransform();
    }
    function closeViewer() {
        document.removeEventListener("keydown", keyHandler);
        if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
    }
    function keyHandler(e) {
        if (e.key === "Escape")          closeViewer();
        else if (e.key === "ArrowLeft")  rotateBy(-90);
        else if (e.key === "ArrowRight") rotateBy(+90);
    }

    overlay.appendChild(img);

    // 우측 상단 툴바 (회전 ±90° + 닫기)
    var toolbar = document.createElement("div");
    toolbar.style.cssText = "position:absolute;top:20px;right:20px;z-index:100000;"
        + "display:flex;gap:8px;";
    function mkBtn(label, title, onClick) {
        var b = document.createElement("button");
        b.textContent = label;
        b.title = title;
        b.style.cssText = "padding:8px 14px;font-size:14px;cursor:pointer;"
            + "background:#fff;border:1px solid #ccc;border-radius:4px;";
        b.onclick = function(e) { e.stopPropagation(); onClick(); };
        return b;
    }
    toolbar.appendChild(mkBtn("⟲ 90°", "왼쪽 회전 (←)",   function(){ rotateBy(-90); }));
    toolbar.appendChild(mkBtn("⟳ 90°", "오른쪽 회전 (→)", function(){ rotateBy(+90); }));
    toolbar.appendChild(mkBtn("✕",     "닫기 (ESC)",      closeViewer));
    overlay.appendChild(toolbar);

    document.body.appendChild(overlay);

    overlay.onclick = closeViewer;
    img.onclick = function(e) { e.stopPropagation(); };

    img.addEventListener("wheel", function(e) {
        e.preventDefault();
        scale += (e.deltaY < 0) ? 0.1 : -0.1;
        scale = Math.min(Math.max(0.2, scale), 5);
        updateTransform();
    });
    img.addEventListener("mousedown", function(e) {
        e.preventDefault();
        isDragging = true;
        startX = e.clientX - posX;
        startY = e.clientY - posY;
        img.style.cursor = "grabbing";
        img.style.transition = "none";
    });
    document.addEventListener("mousemove", function(e) {
        if (!isDragging) return;
        posX = e.clientX - startX;
        posY = e.clientY - startY;
        updateTransform();
    });
    document.addEventListener("mouseup", function() {
        if (!isDragging) return;
        isDragging = false;
        img.style.cursor = "grab";
        img.style.transition = "transform 0.1s ease";
    });
    document.addEventListener("keydown", keyHandler);
}

function showProgress(on, stageText) {
    var el = document.getElementById("ocr_progress");
    if (!el) return;
    if (on) {
        el.textContent = stageText || "OCR 처리 중...";
        el.style.display = "block";
    } else {
        el.style.display = "none";
        el.textContent = "OCR 처리 중...";  // 다음 호출 위해 리셋
    }
}
function setProgressStage(text) {
    var el = document.getElementById("ocr_progress");
    if (el && el.style.display === "block") el.textContent = text;
}

// 그리드 단일 클릭 → 폼 + 이미지 로드 (행 선택 시 즉시 반영)
function doOnRowSelected(rowId) {
    var grid = items['C106000190_Grid_1'].getDhxGrid();
    var ocrNo = grid.cellById(rowId, grid.getColIndexById("OCR_NO")).getValue();
    if (!ocrNo) return;
    if (currentOcrNo === ocrNo) return; // 같은 행 재선택은 무시
    currentOcrNo = ocrNo;
    fetch("./_c10OcrDetail.jsp?ocrNo=" + encodeURIComponent(ocrNo))
        .then(function(r){ return r.json(); })
        .then(function(data){
            if (data && data.success) populateFromDb(data);
            else dhtmlx.alert("OCR 데이터를 조회하지 못했습니다.");
        });
    showOcrImage(ocrNo);
}

// ============================================================================
// 저장 / 보내기
// ============================================================================
function buildBody() {
    var parts = ['OCR_NO=' + encodeURIComponent(currentOcrNo)];
    for (var i = 0; i < OCR_FIELDS.length; i++) {
        var fld = OCR_FIELDS[i];
        var val = getF(fld);
        // OCR_VIS: '±' 뒷부분은 저장하지 않음. 폼 display 는 '350±50' 이어도 서버로는 base('350')만 보냄.
        // (OCR_VIS DB 컬럼은 NUMBER, WK_VISCO 는 NUMBER(3,0) 라 ± 와 tolerance 포함 시 저장 실패)
        if (fld === 'OCR_VIS' && val) {
            var idx = val.indexOf('±'); // ±
            if (idx >= 0) val = val.substring(0, idx);
        }
        // 날짜 컬럼은 VARCHAR2(8) 이라 hyphen/dot 포함 시 ORA-12899 발생.
        // 사용자가 폼에서 "2024-07-26" 같이 입력해도 강제로 "20240726" 8자리로 정규화.
        if (fld === 'OCR_WORK_DT' || fld === 'OCR_APPROVED_DT' || fld === 'OCR_DISUSED_DT') {
            val = _normDateStr(val);
        }
        parts.push(fld + '=' + encodeURIComponent(val));
    }
    return parts.join('&');
}

function postUpdate() {
    return fetch("./_c10OcrUpdate.jsp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
        body: buildBody()
    }).then(function(r){ return r.json(); });
}

// OCR_TYPE 이 마스터 미등록이면 confirm 으로 사용자 확인. ok 시 진행 콜백 실행.
function _confirmIfOcrTypeUnregistered(onProceed) {
    if (!_isOcrTypeUnregistered()) { onProceed(); return; }
    var v = (document.getElementById("f_OCR_TYPE").value || "").trim();
    dhtmlx.confirm({
        title: "[[ OCR_TYPE 확인 ]]",
        ok: "진행", cancel: "취소",
        text: "OCR_TYPE '" + v + "' 은(는) RSN_TP 마스터에 등록되지 않은 코드입니다.\n그대로 진행하시겠습니까?",
        callback: function(ok){ if (ok) onProceed(); }
    });
}

function saveCurrent() {
    if (!currentOcrNo) { dhtmlx.alert("저장할 OCR 데이터가 없습니다."); return; }
    _confirmIfOcrTypeUnregistered(function(){
        postUpdate().then(function(data){
            if (data.success) {
                dhtmlx.message({ type:"info", text:"저장되었습니다.", expire:2500 });
                refresh('C106000190_Grid_1');
            } else {
                dhtmlx.alert("저장 실패: " + data.message);
            }
        }).catch(function(e){ dhtmlx.alert("저장 오류: " + e); });
    });
}

function sendToColorMng() {
    if (!currentOcrNo) { dhtmlx.alert("보낼 OCR 데이터가 없습니다."); return; }
    var clrCd = getF('OCR_CODE');
    if (!clrCd || clrCd.length === 0) {
        dhtmlx.alert("CODE 값이 비어 있습니다. CODE를 먼저 입력하세요."); return;
    }
    _confirmIfOcrTypeUnregistered(function(){ _doSendToColorMng(clrCd); });
}

function _doSendToColorMng(clrCd) {
    postUpdate().then(function(data){
        if (!data.success) {
            dhtmlx.alert("저장 실패: " + data.message);
            return;
        }
        // 중복 체크 (sync XML)
        var param = "ServiceName=C106000190-service&dupCheck=1&CLR_SUB_MTL_CD="
                  + encodeURIComponent(clrCd) + "&column-info=CNT";
        var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do', param);
        var cnt = 0;
        if (xmlObj) {
            var cells = xmlObj.getElementsByTagName("cell");
            if (cells.length > 0 && cells.item(0).firstChild) {
                cnt = parseInt(cells.item(0).firstChild.nodeValue, 10) || 0;
            }
        }
        if (cnt > 0) {
            dhtmlx.alert("이미 등록된 컬러코드입니다 (" + clrCd + "). 칼라코드 관리에서 직접 수정해 주세요.");
            return;
        }
        if (parent && typeof parent.newRemoveOpenTab === "function") {
            parent.newRemoveOpenTab("C106000050", "OCR_NO=" + currentOcrNo);
        } else {
            window.open("./C106000050.jsp?OCR_NO=" + currentOcrNo, "_blank");
        }
    });
}

// ============================================================================
// 유틸
// ============================================================================
function dateAdd(date, addDay) {
    var d = new Date(date.getTime());
    d.setTime(d.getTime() + (addDay * 24 * 60 * 60 * 1000));
    var y = d.getFullYear(), m = d.getMonth() + 1, dd = d.getDate();
    if (m < 10) m = "0" + m;
    if (dd < 10) dd = "0" + dd;
    return y + "-" + m + "-" + dd;
}
function findMessage(referenceItem){
    uiCommon.message(ui.messagebox.messageBoxDivId, referenceItem.getUserData("","appMsg"));
    return true;
}
function onGridContextMenuClick(id, gridObj, menuObj) {
    if ("excel_grid" == id) gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
}
//]]>
</script>
</head>
<body>
<input type="file" id="realFileInput" accept="image/*" style="display:none;"/>
<div id="ocr_progress" style="display:none; position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); padding:10px 20px; background:#333; color:#fff; border-radius:6px; z-index:9999;">OCR 처리 중...</div>

<div id="C106000190_Form_1" style="position:absolute; height:31px; width:1540px; left:0px; top:0px;"></div>

<!-- 좌: 이미지 미리보기 -->
<div id="ocr_image_box">
    <span class="ocr-image-placeholder">이미지 업로드 후 미리보기가 표시됩니다.</span>
</div>

<!-- 우: 라벨과 동일 구조의 입력 테이블 -->
<div id="ocr_label_box">
    <p class="label-title">OCR 추출 결과 (검토 / 수정)</p>
    <table class="ocr-label">
        <colgroup>
            <col style="width:25%"/>
            <col style="width:25%"/>
            <col style="width:25%"/>
            <col style="width:25%"/>
        </colgroup>
        <tr>
            <td class="lbl">CODE</td>
            <td colspan="3"><input type="text" id="f_OCR_CODE"/></td>
        </tr>
        <tr>
            <td class="lbl">TYPE (구매수지)</td>
            <td colspan="3"><input type="text" id="f_OCR_TYPE"/></td>
        </tr>
        <tr>
            <td class="lbl">TYPE (품질수지)</td>
            <td colspan="3"><input type="text" id="f_OCR_QT_TYPE" placeholder="예: PVC SOL — 칼라코드 RSN_TP_QT/_BR 콤보 선택 시 참고"/></td>
        </tr>
        <tr>
            <td class="lbl">MUNSELL</td>
            <td colspan="3"><input type="text" id="f_OCR_MUNSELL"/></td>
        </tr>
        <tr>
            <td class="lbl">GLOSS(%)</td>
            <td><input type="text" id="f_OCR_GLOSS"/></td>
            <td class="lbl">PRIMER</td>
            <td><input type="text" id="f_OCR_PRIMER"/></td>
        </tr>
        <tr>
            <td class="lbl">D.F.T(μm)</td>
            <td class="dft-cell">
                <div class="dft-inner"><span>1C</span><input type="text" id="f_OCR_DFT_1C"/></div>
            </td>
            <td class="dft-cell">
                <div class="dft-inner"><span>2C</span><input type="text" id="f_OCR_DFT_2C"/></div>
            </td>
            <td class="dft-cell">
                <div class="dft-inner"><span>3C</span><input type="text" id="f_OCR_DFT_3C"/></div>
            </td>
        </tr>
        <tr>
            <td class="lbl">COLOR</td>
            <td colspan="3"><input type="text" id="f_OCR_COLOR"/></td>
        </tr>
        <tr>
            <td class="lbl">Unfixed No.</td>
            <td colspan="3"><input type="text" id="f_OCR_UNFIXED_NO"/></td>
        </tr>
        <tr>
            <td class="lbl">ΔE</td>
            <td><input type="text" id="f_OCR_DELTA_E"/></td>
            <td class="lbl">N.V(%)</td>
            <td><input type="text" id="f_OCR_NV"/></td>
        </tr>
        <tr>
            <td class="lbl">L</td>
            <td><input type="text" id="f_OCR_L"/></td>
            <td class="lbl">S.G</td>
            <td><input type="text" id="f_OCR_SG"/></td>
        </tr>
        <tr>
            <td class="lbl">a</td>
            <td><input type="text" id="f_OCR_A"/></td>
            <td class="lbl">V.I.S(Sec)</td>
            <td><input type="text" id="f_OCR_VIS"/></td>
        </tr>
        <tr>
            <td class="lbl">b</td>
            <td><input type="text" id="f_OCR_B"/></td>
            <td class="lbl">MAKER</td>
            <td><input type="text" id="f_OCR_MAKER"/></td>
        </tr>
        <tr>
            <td class="lbl">WORK DATE</td>
            <td colspan="3"><input type="text" id="f_OCR_WORK_DT" placeholder="YYYYMMDD"/></td>
        </tr>
        <tr>
            <td class="lbl">APPROVED DATE</td>
            <td colspan="3"><input type="text" id="f_OCR_APPROVED_DT" placeholder="YYYYMMDD"/></td>
        </tr>
        <tr>
            <td class="lbl">DISUSED DATE</td>
            <td colspan="3"><input type="text" id="f_OCR_DISUSED_DT" placeholder="YYYYMMDD"/></td>
        </tr>
        <tr>
            <td class="lbl">END USER</td>
            <td colspan="3"><input type="text" id="f_OCR_END_USER"/></td>
        </tr>
        <tr>
            <td class="lbl">+2μm(ΔE,ΔL,Δa,Δb)</td>
            <td colspan="3" class="dft-cell">
                <div class="quad-inner">
                    <div class="dft-inner"><span>ΔE</span><input type="text" id="f_OCR_P2_DE"/></div>
                    <div class="dft-inner"><span>ΔL</span><input type="text" id="f_OCR_P2_DL"/></div>
                    <div class="dft-inner"><span>Δa</span><input type="text" id="f_OCR_P2_DA"/></div>
                    <div class="dft-inner"><span>Δb</span><input type="text" id="f_OCR_P2_DB"/></div>
                </div>
            </td>
        </tr>
        <tr>
            <td class="lbl">-2μm(ΔE,ΔL,Δa,Δb)</td>
            <td colspan="3" class="dft-cell">
                <div class="quad-inner">
                    <div class="dft-inner"><span>ΔE</span><input type="text" id="f_OCR_M2_DE"/></div>
                    <div class="dft-inner"><span>ΔL</span><input type="text" id="f_OCR_M2_DL"/></div>
                    <div class="dft-inner"><span>Δa</span><input type="text" id="f_OCR_M2_DA"/></div>
                    <div class="dft-inner"><span>Δb</span><input type="text" id="f_OCR_M2_DB"/></div>
                </div>
            </td>
        </tr>
        <tr>
            <td class="lbl">DURABILITY</td>
            <td colspan="3">
                <select id="f_OCR_DURABILITY">
                    <option value=""></option>
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="lbl">MEMO</td>
            <td colspan="3"><input type="text" id="f_OCR_MEMO"/></td>
        </tr>
        <tr>
            <td class="lbl">담당자</td>
            <td colspan="3"><input type="text" id="f_OCR_CHARGER"/></td>
        </tr>
    </table>

    <div class="ocr-actions">
        <button type="button" onclick="saveCurrent()">중간 저장</button>
        <button type="button" class="btn-send" onclick="sendToColorMng()">칼라코드 관리로 보내기</button>
    </div>
</div>

<div id="C106000190_Grid_1" style="position:absolute; left:0px; top:742px; width:1530px; height:300px;"></div>

<div id="messagebox" style="position:absolute; left:1px; top:1047px; width:1530px; height:19px;"></div>
</body>
</html>
<script>
//<![CDATA[
ui.initializeDHTMLX();
items['C106000190_Form_1'].onXLEEvent(onFormLoadEvent);
var _onXLE = items['C106000190_Grid_1'].onXLEEvent(onGridLoadEvent);
items['C106000190_Form_1'].setBackgroundColor("#FFFFFF");
items['C106000190_Grid_1'].getDhxGrid().attachEvent("onRowSelect", doOnRowSelected);
//]]>
</script>
