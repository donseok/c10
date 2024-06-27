<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME	:  C104000020POP04.jsp
 * VERSION				:  V1.0
 * DESCRIPTION			:  프로젝트 주문 설계확정
 * DESIGNER NAME	:  서재섭
 * DEVELOPER NAME	:  서재섭
 * CREATE DATE			:  2024.06.24
 *
 * Date				Ver		Name		Description
 * -----------------------------------------------------------------
 * 최초생성일자		V1.0		서재섭		Initial Version
 * 변경일자      version number  개발자이름 변경사항
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "com.posdata.glue.web.security.PosSecurityConstants" %>
<%@page import = "com.posdata.glue.web.security.PosUser" %>
<%
	String ORD_NO = request.getParameter("ORD_NO") !=null ? request.getParameter("ORD_NO") : "";
	String ORD_LN = request.getParameter("ORD_LN") !=null ? request.getParameter("ORD_LN") : "";
%>    

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
프로젝트 주문 설계확정
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script type="text/javascript" src="./js/c10.ui.js">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C104000020POP04_Form_1","xml":".\/header\/kr\/C104000020POP04\/C104000020POP04_Form_1.xml","url":"basicGridData.do","referenceItem":"C104000020POP04_Form_1","service":"C104000020POP04-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};

function onFormLoadEvent(){
	var parentForm = parent.items['C104000020_Form_2'];
	var bom = parentForm.getItemValue("CCL_BOM_NO");
    
    find(bom);
    
    items['C104000020POP04_Form_1'].getDhxForm().detachEvent(onXleForm);
}

function find(bom){
	var ord_no = "";
	var ord_ln = "";
	var wk_end_dh = "";
	var proc_cd = "";
	var main_proc_cd = "";
	var arr = [];
	var form = items['C104000020POP04_Form_1'];
	var j = 0;
	
	var param = "ServiceName=C104000020POP04-service&find=1&CCL_BOM_NO=" + bom + "&column-info=ORD_NO,ORD_LN,WK_END_DH,PROC_CD";
	var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	var cells = xmlObj.getElementsByTagName("cell");
	
	if(cells.length > 0){
		ord_no = cells.item(0).firstChild.nodeValue;
		ord_ln = cells.item(1).firstChild.nodeValue;
		wk_end_dh = cells.item(2).firstChild.nodeValue;
		proc_cd = cells.item(3).firstChild.nodeValue;		
		
		form.setItemValue("ORDER_NO","수주번호 : "+ord_no+"-"+ord_ln);
		form.setItemValue("HISTORY","\""+wk_end_dh.split('.')[0]+"\""+" "+proc_cd+" 에서 생산이력이 있습니다.");
		
// 		return;					
	}else{
		//생산이력 없다고 return
		form.setItemValue("ORDER_NO","");
		form.setItemValue("HISTORY","해당 BOM의 생산이력이 없습니다.");		
	}	
	
	param = "ServiceName=C104000020POP04-service&findProc=1&ORD_NO=" + "<%= ORD_NO %>"+ "&ORD_LN=" + "<%= ORD_LN %>" + "&column-info=MAIN_PROC_CD,SUB_PROC_CD1,SUB_PROC_CD2,SUB_PROC_CD3,SUB_PROC_CD4,SUB_PROC_CD5,SUB_PROC_CD6";
<%-- 	param = "ServiceName=C104000020POP04-service&findProc=1&ORD_NO="<%= ORD_NO %>"&ORD_LN="<%= ORD_LN %>"&column-info=MAIN_PROC_CD,SUB_PROC_CD1,SUB_PROC_CD2,SUB_PROC_CD3,SUB_PROC_CD4,SUB_PROC_CD5,SUB_PROC_CD6"; --%>
	xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
	cells = xmlObj.getElementsByTagName("cell");
	
	if(cells.length > 0){
		
		main_proc_cd = cells.item(0).firstChild.nodeValue;

		for(var i=1 ; i<7 ; i++){
			arr[i] = cells.item(i).firstChild.nodeValue;
			console.log("arr : "+i+" : "+arr[i]);
			if(arr[i] == null || arr[i] == ""){
				j = i-1;
				break;
			}
			
		}
		
		form.setItemValue("PROC","『 현재 주문의 통과공정 』 ");
		form.setItemValue("MAIN_PROC","• 주공정 : "+main_proc_cd);
		for(var k = 1;k<=j;k++){
			form.setItemValue("SUB_PROC"+k,"• 대체공정"+k+" : "+arr[k]);
		}
				
	}else{
		form.setItemValue("PROC","현재 주문의 통과공정에 칼라공정이 없습니다.");
	}
	
	
}

// 설계확정
function ok() {
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();
	
	var param = "ORD_NO=" + ord_no + "&ORD_LN=" + ord_ln;
	parentForm.sendForm("handleDataProcess.do",'C104000020_Form_1','save',param);
	
	winClose();
}

// 코드사용
function openCdUsg() {
    
    var vUrl = "";
    var cclbom_tmp  = parent.items["C104000020_Form_2"].getItemValue("CCL_BOM_NO");
    var cclbom = cclbom_tmp.substring(0,5);
    
    if(isNull(cclbom)){
     dhtmlx.alert("BOM정보가 없습니다!");
    }
    else{
     vUrl += "CCL_BOM_NO="+encodeURIComponent(cclbom);
     parent.parent.newRemoveOpenTab("C106000090", vUrl);
    }    

	winClose();
}


//통과공정
function cancel() {
	var parentForm = parent.items['C104000020_Form_1'];
	var comboList = parentForm.getDhxForm().getCombo("ORD_LN");
	var ord_no = parentForm.getItemValue("ORD_NO");
    var ord_ln = comboList.getSelectedValue();
    
    var tabObj = parent.items['C104000020_Tabbar_1'].getDhxTabbar(); 
    tabObj.setTabActive("C104000020TAB08");

	winClose();
}


//]]>
-->
</script>
</head>
<body>
<div id="C104000020POP04_Form_1" style="position:absolute;height:357px;width:582px;left:0px;top:0px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleForm = items['C104000020POP04_Form_1'].onXLEEvent(onFormLoadEvent);
//]]>
-->
</script>