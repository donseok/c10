<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String INQ_NO = request.getParameter("INQ_NO");
String SEQ = request.getParameter("SEQ");

%>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
생산가부이력관리 파일 업로드
</title>
<link rel="stylesheet" type="text/css" href="./dhtmlx/codebase/dhtmlxvault.css" />
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript" src="./dhtmlx/codebase/dhtmlxvault.js"></script>

<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"grid","renderTo":"C105000010pop03_Grid_1","xml":".\/header\/kr\/C105000010pop03\/C105000010pop03_Grid_1.xml","url":"gridC10Data.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C105000010pop03_Form_1","service":"C105000010pop03-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C105000010pop03_messagebox","xml":".\/header\/kr\/C105000010pop03\/C105000010pop03_messagebox.xml","service":"C105000010pop03-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
    var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
    items[referenceItem].loadData(findUrl);
}
function save(eventName,formDivObj,referenceItem){
    items[referenceItem].sendGrid(referenceItem,eventName);
}
//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
    items[referenceItem].clearDataProcess();
    var findUrl = uiCommon.parameters('C105000010pop03_Form_1',referenceItem,'find');
    items[referenceItem].loadData(findUrl);	
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
	uiCommon.message("C105000010pop03_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}

var vault = null;
	function onVaultLoad() {
		vault = new dhtmlXVaultObject();
		vault.setImagePath("./dhtmlx/codebase/imgs/");
		vault.setServerHandlers("_uploadHandler2.jsp", "_getInfoHandler.jsp", "_getIdHandler.jsp");
		vault.create("vault1");
		vault.setFormField("PAGE_ID", "C105000010pop03");	
		vault.setFormField("INQ_NO", "<%=INQ_NO%>");
		vault.setFilesLimit(50);//upload file count limit
		vault.strings = {
		btnAdd: "Add file",
		btnUpload: "Upload",
		btnClean: "Clean",
		done: "Done"
		
		};

		vault.onAddFile = function(fileName) {
			var ext = this.getFileExtension(fileName);
			if (ext != "xls" && ext != "xlsx" && ext != "ppt" && ext != "pptx") {
				alert("파일첨부는 (xls,xlsx,ppt,pptx) 확장자만 등록하실수 있습니다.");
				return;
			}
			/*else if(fileName.match("tb_c10_qlt_dsn_sml") == null){
				alert("파일첨부는 tb_c10_qlt_dsn_sml.xlsx 만 가능합니다.");
				return false;
			} else return true;*/
			return true;
		};

		vault.onUploadComplete = function(files) {
            var uploadFlag = false;
            for (var i=0; i<files.length; i++) {
                var file = files[i];
                uploadFlag = file.error;
            }
			if(uploadFlag){
                alert("파일업로드에 실패하였습니다.");
			}else{
				onLoadGrid();
			}

   		};
}
//popup grid search
function onLoadGrid(){
	var grid = items["C105000010pop03_Grid_1"];
	var customparam = {"INQ_NO":"<%=INQ_NO%>"};	
	var findUrl  = parametersC10('C105000010pop03_Grid_1','find',customparam);		
	items['C105000010pop03_Grid_1'].loadData(findUrl);
	parent.find('find','C105000010_Form_1','C105000010_Grid_1');
	
	grid.getDhxGrid().detachEvent(onXleGrid);
}
//popup grid delete
function doImgDel(rowIndex,cellIndex){
	var grid = items["C105000010pop03_Grid_1"];	
	var customparam = {"INQ_NO":grid.getCellByIndexValue(rowIndex,0),"SEQ":grid.getCellByIndexValue(rowIndex,1)};		
	var findUrl  = parametersC10('C105000010pop03_Grid_1','delete',customparam);	
	items['C105000010pop03_Grid_1'].loadData(findUrl);	
	
	parent.find('find','C105000010_Form_1','C105000010_Grid_1');	
}	
//popup grid file download	
function Grid_doLink(val,rowIdx){
	fileDownload("/C10/download",val);
}
function fileDownload(url,fileName) {
	if (!document.getElementById('ifr')) {
		var ifr = document.createElement('iframe');
		ifr.style.display = 'none';
		ifr.setAttribute('name', 'dhx_export_iframe');
		ifr.setAttribute('src', '');
		ifr.setAttribute('id', 'dhx_export_iframe');
		document.body.appendChild(ifr);
	}

	 var target = " target=\"dhx_export_iframe\"";
     var d=document.createElement("div");
	 d.style.display="none";
	 document.body.appendChild(d);
	 var uid = "form_"+new Date();

	 d.innerHTML = '<form id="'+uid+'" method="post" action="'+url+'" accept-charset="utf-8"  enctype="application/x-www-form-urlencoded"' + target + '><input type="hidden" name="file"/></form>';
	 document.getElementById(uid).firstChild.value = fileName;
	 document.getElementById(uid).submit();
}
	
//]]>
-->
</script>
</head>
<body onload="onVaultLoad()">
<div id="vault1"></div>
<div id="C105000010pop03_Grid_1" style="position:absolute;height:70px;width:430px;left:8px;top:260px;">
</div>
<div id="C105000010pop03_messagebox" style="position:absolute;height:23px;width:445px;left:0px;top:332px;">

</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();  
	var onXleGrid = items["C105000010pop03_Grid_1"].onXLEEvent(onLoadGrid);     
//]]>
-->
</script>