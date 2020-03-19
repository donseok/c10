<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  fileUpload.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  master popup
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  이 민 균
 * CREATE DATE      :  2012.02.01
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.02.01     V1.0      이민균      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
</meta>
<title>
Upload Control
</title>
<link rel="stylesheet" type="text/css" href="./dhtmlx/codebase/dhtmlxvault.css" />
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript" src="./dhtmlx/codebase/dhtmlxvault.js"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var vault = null;
	function doOnLoad() {
		vault = new dhtmlXVaultObject();
		vault.setImagePath("./dhtmlx/codebase/imgs/");
		vault.setServerHandlers("_uploadHandler.jsp", "_getInfoHandler.jsp", "_getIdHandler.jsp");
		vault.create("vault1");
		vault.setFilesLimit(1);
		vault.strings = {
		btnAdd: "Add222 file",
		btnUpload: "Upload",
		btnClean: "Clean"
		};





		vault.onAddFile = function(fileName) {
			var ext = this.getFileExtension(fileName);
			if (ext != "xls" && ext != "xlsx") {
				alert("파일첨부는 (xls,xlsx) 확장자만 등록하실수 있습니다.");
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
				var name = file.name;
				var nameIndex = file.name.lastIndexOf("\\");
				var finalName = name.substring(nameIndex+1,name.length);
				var rowCnt = parent.items['C106000020_Grid_1'].getBlankRowCntInfo();
				parent.items['C106000020_Grid_1'].loadData("fileUpload.do?blank-row-count="+rowCnt);	
				//parent.items['C106000020_Grid_1'].loadData("fileUpload.do");		
				parent.searchFlagUpdate();
			}
			dhtmlxAjax.get('fileDelete.do?fileName='+finalName);
			parent.winObj.winClose();
   		};
}
	
//]]>
-->
</script>
</head>
<body onload="doOnLoad()">
<div id="vault1">
</div>
</body>
</html>