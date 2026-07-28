<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000050pop09.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  원가내역서 첨부 예외 조합 조회 팝업 (조회 전용)
 *                     - TB_C10_CLR_EXCEPT (C10APUSER) 표시
 *                     - 추가/변경/삭제는 의뢰서를 통해서만 처리 가능
--%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>원가내역서 첨부 예외 조항</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script>
<script src="./js/c10.ui.js" type="text/javascript"></script>

<style type="text/css">
html, body { margin:0; padding:0; overflow:hidden; }
#noticeBox {
	box-sizing: border-box;
	padding: 8px 14px;
	background-color: #FFFCE6;
	border: 1px solid #E6D774;
	border-radius: 3px;
	color: #444;
	font-size: 12px;
	line-height: 18px;
}
#noticeBox .noticeIcon {
	display: inline-block;
	width: 16px;
	height: 16px;
	vertical-align: -3px;
	margin-right: 6px;
	background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="%23B8860B"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>') no-repeat center;
}
#noticeBox b { color: #B33; }
</style>

<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();
var pageConfiguration = '[' +
      '{"itemType":"grid","renderTo":"C106000050pop09_Grid_1","xml":".\/header\/kr\/C106000050pop09\/C106000050pop09_Grid_1.xml","rowCnt":"0","vertical":"true","url":"basicGridData.do","contextmenu":"false","borderline":"true","pageset":"false","split":"0","referenceItem":"C106000050pop09_Grid_1","service":"C106000050pop09-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000050pop09_MessageBox_1","service":"C106000050pop09-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

function winClose(){
	parent.winObj.winClose();
}

// 프레임워크가 그리드 로드 완료 후 호출. uiCommon.message 내부에서 progressOff(parent) 를 실행해 부모 lds-spinner 를 종료함.
function findMessage(referenceItem){
	uiCommon.message("C106000050pop09_MessageBox_1", referenceItem.getUserData("","appMsg"));
	return true;
}

function onGridLoadFunction(){
	var _grid = items['C106000050pop09_Grid_1'];
	var _colInfo   = _grid.getColumnInfo() || _grid.getDefaultColumnInfo();
	var _blankCnt  = _grid.getBlankRowCntInfo() || _grid.getDefaultRowCnt();
	var findUrl = "basicGridData.do?ServiceName=C106000050pop09-service"
	            + "&find=1"
	            + "&column-info="     + _colInfo
	            + "&blank-row-count=" + _blankCnt;
	// 콜백 인자 넘기면 안 됨 - gluegun.loadData(url,cb) 는 자동 findMessage 호출을 skip 해서 progressOff 가 안 걸림
	_grid.loadData(findUrl);
	_grid.getDhxGrid().detachEvent(onXleGrid);
	return true;
}
//]]>
-->
</script>
</head>
<body>
<div id="noticeBox"           style="position:absolute; left:5px;  top:5px;   width:690px; height:52px;"><span class="noticeIcon"></span>본 목록은 <b>구매수지타입과 품질수지타입이 상이한 경우</b>에도 원가내역서 첨부 없이 전송이 허용되는 예외 조합입니다.<br><span style="display:inline-block;width:22px;"></span>추가/변경/삭제는 의뢰서를 통해서만 처리 가능합니다.</div>
<div id="C106000050pop09_Grid_1"        style="position:absolute; left:5px;  top:62px;  width:690px; height:388px;"></div>
<div id="C106000050pop09_MessageBox_1"  style="position:absolute; left:0px;  top:452px; width:700px; height:23px;"></div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleGrid = items['C106000050pop09_Grid_1'].onXLEEvent(onGridLoadFunction);
//]]>
-->
</script>
