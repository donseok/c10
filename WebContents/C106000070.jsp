<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 * PROGRAM NAME     :  C106000070.jsp
 * VERSION          :  V1.0
 * DESCRIPTION      :  InterFace 조회
 * DESIGNER NAME    :  한 윤 섭
 * DEVELOPER NAME   :  이 민 균
 * CREATE DATE      :  2012.02.06
 *
 * Date	          Ver       Name       Description
 * ------------  ------    --------  ------------------------
 * 2012.02.06     V1.0      이민균      Initial Version
 * 변경일자        
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.ui.bootstrap.js"></script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000070_Form_1","xml":".\/header\/kr\/C106000070\/C106000070_Form_1.xml","url":"basicGridData.do","referenceItem":"C106000070_Grid_1","service":"C106000070-service","actionType":"save","security":"true"},' +
      '{"itemType":"grid","renderTo":"C106000070_Grid_1","xml":".\/header\/kr\/C106000070\/C106000070_Grid_1.xml","rowCnt":"15","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000070_Form_1","service":"C106000070-service","actionType":"save"},' +
      '{"itemType":"messagebox","renderTo":"C106000070_messagebox","xml":".\/header\/kr\/C106000070\/C106000070_messagebox.xml","service":"C106000070-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var winObj,winObj2,winObj3,c10popUp_setVal;
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){	
	var form = items['C106000070_Form_1'];
	var formObj = items['C106000070_Form_1'].getDhxForm();
	var comboList = items['C106000070_Form_1'].getMasterCombos();	
	if(isNull(comboList['TABLE_NAME'].getSelectedValue())){
		alert("TABLE NAME을 선택해주세요.");
		comboList['TABLE_NAME'].DOMelem_input.focus();
		return;
	}else{
		var event = "find";					  
    if(comboList['TABLE_NAME'].getSelectedValue() == "TB_C10_B10R0020"){
      event = "find2";
    }
    else if(comboList['TABLE_NAME'].getSelectedValue() == "TB_C10_B10R0030" ||
    		comboList['TABLE_NAME'].getSelectedValue() == "TB_C10_B10S1010"){
      event = "find3";
    }
    else if(comboList['TABLE_NAME'].getSelectedValue() == "TB_C10_B10S1030"){
      event = "find4";	
    }
		var findUrl = uiCommon.parameters(formDivObj,referenceItem,event);
			items[referenceItem].loadData(findUrl);		
	}
}

function Send(eventName,formDivObj,referenceItem){
	var gridObj =items['C106000070_Grid_1'];
	var comboList = items['C106000070_Form_1'].getMasterCombos();
	var comboValue = comboList['TABLE_NAME'].getSelectedValue();
    var event = "Send";
  //alert(comboValue);
	if(isNull(comboValue)){
		alert("TABLE NAME을 선택해주세요.");
		comboList['TABLE_NAME'].DOMelem_input.focus();
		return;
	}			
  if(comboValue == "TB_C10_B10S0010"){ 
    event = "Send";    //규격공통송신 
  }else if(comboValue == "TB_C10_B10S0020"){
    event = "Send1";   //주문용도송신
  }else if(comboValue == "TB_C10_B10S0030"){
    event = "Send2";   //규격별주문용도송신
  }else if(comboValue == "TB_C10_B10S0040"){
    event = "Send3";   //공통코드송신
  }else if(comboValue == "TB_C10_B10S0050"){
    event = "Send4";   //고객사양공통송신
  }else{
    alert("C10품질파트의 B10S0010~B10S0050만 전송가능합니다.");
    return;
   } 
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"전송 하시겠습니까?",
		callback:function(val){
			if(val){
			  gridObj.setUpdated(gridObj.getDhxGrid().getRowId(0),true,"updated"); 
				items["C106000070_Grid_1"].sendGrid("C106000070_Grid_1",event);
			return;
			}
		}
	});    
}

function reSend(eventName,formDivObj,referenceItem){
	var gridObj =items['C106000070_Grid_1'];
	var selectRowId = gridObj.getSelectedRowId();	
	var comboList = items['C106000070_Form_1'].getMasterCombos();
	var comboValue = comboList['TABLE_NAME'].getSelectedValue();
	if(isNull(selectRowId)){
		alert("재전송할 인터페이스 그룹아이디가 없습니다.");
		return;	
	}else{	
		var cellValue = gridObj.getCellValue(selectRowId,0);
		if(isNull(comboValue)){
			alert("TABLE NAME을 선택해주세요.");
			comboList['TABLE_NAME'].DOMelem_input.focus();
			return;
		}			
		
		var ord_req_no = gridObj.getCellValue(selectRowId,9);
		var ord_req_ln = gridObj.getCellValue(selectRowId,10);
		var xdate = gridObj.getCellValue(selectRowId,6);
		var xtime = gridObj.getCellValue(selectRowId,7);
		
		var param= "ServiceName=C106000070-service&chk30=1&ORD_REQ_NO=" + ord_req_no + "&ORD_REQ_LN=" + ord_req_ln + "&column-info=ORD_REQ_NO";
		var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		var cells = xmlObj.getElementsByTagName("cell");
		if(cells.length > 0){						
			alert("이미 품질설계 요청된 주문입니다!");
			return;					
		}
		
		var param1= "ServiceName=C106000070-service&chk20=1&ORD_REQ_NO=" + ord_req_no + "&ORD_REQ_LN=" + ord_req_ln + "&XDATE=" + xdate + "&XTIME=" + xtime + "&column-info=ORD_REQ_NO";
		var xmlObj1 = uiCommon.ajaxLoadData('c10AjaxData.do',param1);
		var cells1 = xmlObj1.getElementsByTagName("cell");
		if(cells1.length > 0){						
			alert("최신 요청한 Data가 있습니다!");
			return;					
		}
		
		gridObj.setUpdated(selectRowId,true,"updated"); 
	}
	var colNum=gridObj.getDhxGrid().getColumnsNum();
	var customParam = "P_IF_GRP_ID="+cellValue+"&P_TBL_NM="+comboValue;
	dhtmlx.confirm({
		title:"[[ 확인 ]]",
		ok:"확인", cancel:"취소",
		text:"재전송 하시겠습니까?",
		callback:function(val){
			if(val){
				items[referenceItem].sendGrid(referenceItem,eventName,customParam);
			return;
			}
		}
	});    
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
function findMessage(referenceItem){
	uiCommon.message("C106000070_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function onFormLoadFunction(){ 
	var form   = items['C106000070_Form_1'];
	var formObj   = items['C106000070_Form_1'].getDhxForm();
	//combo설정(테이블 목록) start
	var comboList = items['C106000070_Form_1'].getMasterCombos();	
		comboList['TABLE_NAME'].readonly(true,true);
		comboList['TABLE_NAME'].setOptionHeight(220);
		ui.combo(comboList['TABLE_NAME'],"OrdlnComboData.do","ServiceName=C106000070-service&comboSelect=1&column-info=CODE,NAME");
	
	//백스페이스 이벤트 막기처리
	comboList['TABLE_NAME'].DOMelem_input.onkeydown = function(e){
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
	//combo설정(테이블 목록) end
	
	//combo설정(PI 처리 상태) start
		comboList['XSTAT_CD'].readonly(true,true);
		ui.combo.master(comboList['XSTAT_CD'],'SZ0000','XSTAT_CD','totalValue=,orderBy=value&displayType=all-code',function(){ 
		comboList['XSTAT_CD'].selectOption(0,true,true);
		comboList['XSTAT_CD'].setOptionHeight(120);
	});
	
	//백스페이스 이벤트 막기처리
	comboList['XSTAT_CD'].DOMelem_input.onkeydown = function(e){
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
	//combo설정(PI 처리 상태) end

	//백스페이스 이벤트 막기처리
	var inputCalendarStr = formObj.getInput("XDATE_START");
		inputCalendarStr.onkeydown = function(e){
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
	//백스페이스 이벤트 막기처리
	var inputCalendarEnd = formObj.getInput("XDATE_END");
		inputCalendarEnd.onkeydown = function(e){
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

	var inputORD_USG_CD = items["C106000070_Form_1"].getDhxForm().getInput("ORD_USG_CD");
	inputORD_USG_CD.onkeyup = function(){
		inputORD_USG_CD.value = inputORD_USG_CD.value.toUpperCase(); 	
	}	
	
	var inputCUS_CD = items["C106000070_Form_1"].getDhxForm().getInput("CUS_CD");
	inputCUS_CD.onkeyup = function(){
		inputCUS_CD.value = inputCUS_CD.value.toUpperCase(); 	
	}	

	comboList['PRD_NM_CD'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value',function(){
	  comboList['PRD_NM_CD'].selectOption(0,true,true);
	});
	comboList['PRD_NM_CD'].setOptionHeight(300);
	

     comboList['ORD_REQ_LN'].readonly(true,false);


	var startDay = uiCommon.getCurrentDate() + " 00:00";
	var endDay =getCurrentMinitesTime();
	form.setItemValue("XDATE_START",startDay);
	form.setItemValue("XDATE_END",endDay);
	
	//Calendar시작일자 변경(2013.05.30 기존 월요일부터 시작 -> 일요일부터 시작으로 변경)
	form.getItem("XDATE_START").setWeekStartDay(7);
	form.getItem("XDATE_END").setWeekStartDay(7);
	
	formObj.hideItem("reSend");
	formObj.hideItem("ORD_REQ_NO");
	formObj.hideItem("ORD_REQ_NO_BT");
	formObj.hideItem("ORD_REQ_LN");
	formObj.hideItem("PRD_NM_CD");
	formObj.hideItem("ORD_USG_CD");
	formObj.hideItem("template");
	formObj.hideItem("CUS_CD");
	formObj.hideItem("template1");
	formObj.hideItem("ORD_RGS_PRS_ID");
	formObj.hideItem("template2");
	formObj.hideItem("ORD_EXT_THK_STR");
	formObj.hideItem("ORD_EXT_THK_DUR");
	formObj.hideItem("ORD_EXT_THK_END");
	document.getElementById("C106000070_Form_1").style.height="65px";
	document.getElementById("C106000070_Grid_1").style.top="65px";
	document.getElementById("C106000070_Grid_1").style.height="500px";

	
	comboList['TABLE_NAME'].attachEvent("onSelectionChange", function(){
		var nValue = this.getSelectedValue();
		var headerColumInfo = [];
		var headerNameInfo = [];
		var param= "ServiceName=C106000070-service&ajaxFind=1&TABLE_NAME="+nValue+"&column-info=COLUMN_CODE_INFO,COLUMN_NAME_INFO";
		var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
		var cells = xmlObj.getElementsByTagName("cell"); 
		for(var j = 0; j < cells.length; j++){
			//var cells = row[j].childNodes; 
			headerColumInfo.push(cells.item(j).firstChild.nodeValue);
			if(cells.item(j+1).firstChild.nodeValue){
				headerNameInfo.push(cells.item(j+1).firstChild.nodeValue);
			}
			j++;
//			alert(cells.item(1).firstChild.nodeValue);
//			alert(cells.item(2).firstChild.nodeValue);
			/*if(row.length > 0){
				for(var k = 0; k < row.length; k++){
					if(typeof(row[k].getAttribute("id")) != 'undefined'){
						data = row[k].childNodes;					
						headerColumInfo.push(data[1].firstChild.nodeValue);
						headerNameInfo.push(data[2].firstChild.nodeValue);
					}
				}
			}*/
		}
		
		var param1= "column-info="+headerColumInfo+"&column-name="+encodeURIComponent(headerNameInfo)+"&blank-row-count=20";
		var xmlObj1 = uiCommon.ajaxLoadData('setGridHeaderData.do',param1);
		items['C106000070_Grid_1'].getDhxGrid().clearAll();		
		items['C106000070_Grid_1'].getDhxGrid().parse(xmlObj1);

		var columnNum = parseInt(items['C106000070_Grid_1'].getDhxGrid().getColumnsNum());
		items['C106000070_Grid_1'].getDhxGrid().setColumnHidden(columnNum-1,true);
		items['C106000070_Grid_1'].getDhxGrid().setColumnHidden(columnNum-2,true);
		
		//생산가부요청수신 선택 시 
		if("TB_C10_B10R0020" == nValue){
			formObj.showItem("reSend"); //재전송을 해도 OMS에서 읽어가지 않음 KJH20140602
			formObj.showItem("ORD_REQ_NO");
			formObj.showItem("ORD_REQ_NO_BT");
			formObj.showItem("ORD_REQ_LN");
			formObj.showItem("PRD_NM_CD");
			formObj.showItem("ORD_USG_CD");
			formObj.showItem("template");
			formObj.showItem("CUS_CD");
			formObj.showItem("template1");
			formObj.showItem("ORD_RGS_PRS_ID");
			formObj.showItem("template2");
			formObj.showItem("ORD_EXT_THK_STR");
			formObj.showItem("ORD_EXT_THK_DUR");
			formObj.showItem("ORD_EXT_THK_END");
			document.getElementById("C106000070_Form_1").style.height="95px";
			document.getElementById("C106000070_Grid_1").style.top="95px";
			document.getElementById("C106000070_Grid_1").style.height="470px";
			formObj.setItemLabel("ORD_REQ_NO","주문요청번호");
			
			//품질설계요청수신, 품질설계 결과송신 및 생산가부검토결과 선택 시 
		}else if("TB_C10_B10R0030" == nValue || "TB_C10_B10S1010" == nValue || "TB_C10_B10S1030" == nValue){
			formObj.hideItem("reSend");
			formObj.showItem("ORD_REQ_NO");
			formObj.showItem("ORD_REQ_NO_BT");
			formObj.showItem("ORD_REQ_LN");
			formObj.hideItem("PRD_NM_CD");
			formObj.hideItem("ORD_USG_CD");
			formObj.hideItem("template");
			formObj.hideItem("CUS_CD");
			formObj.hideItem("template1");
			formObj.hideItem("ORD_RGS_PRS_ID");
			formObj.hideItem("template2");
			formObj.hideItem("ORD_EXT_THK_STR");
			formObj.hideItem("ORD_EXT_THK_DUR");
			formObj.hideItem("ORD_EXT_THK_END");
			document.getElementById("C106000070_Form_1").style.height="95px";
			document.getElementById("C106000070_Grid_1").style.top="95px";
			document.getElementById("C106000070_Grid_1").style.height="470px";
			
			if("TB_C10_B10S1030" != nValue){
			formObj.setItemLabel("ORD_REQ_NO","주문번호");
			}
			
		}
		else{
			formObj.hideItem("reSend");
			formObj.hideItem("ORD_REQ_NO");
			formObj.hideItem("ORD_REQ_NO_BT");
			formObj.hideItem("ORD_REQ_LN");
			formObj.hideItem("PRD_NM_CD");
			formObj.hideItem("ORD_USG_CD");
			formObj.hideItem("template");
			formObj.hideItem("CUS_CD");
			formObj.hideItem("template1");
			formObj.hideItem("ORD_RGS_PRS_ID");
			formObj.hideItem("template2");
			formObj.hideItem("ORD_EXT_THK_STR");
			formObj.hideItem("ORD_EXT_THK_DUR");
			formObj.hideItem("ORD_EXT_THK_END");
			document.getElementById("C106000070_Form_1").style.height="65px";
			document.getElementById("C106000070_Grid_1").style.top="65px";
			document.getElementById("C106000070_Grid_1").style.height="500px";
		}
		
		gridLoadAfterFunction();
		//items['C106000070_Grid_1'].getDhxGrid().loadXML(xmlObj1,gridLoadAfterFunction);	
		//items['C106000070_Grid_1'].getDhxGrid().loadXML("setGridHeaderData.do?column-info="+headerColumInfo+"&column-name="+encodeURIComponent(headerNameInfo)+"&blank-row-count=20",gridLoadAfterFunction);	
	});  
	
//	items['C106000070_Form_1'].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	items['C106000070_Form_1'].getDhxForm().detachEvent(onXleForm);
 return true;
}
function onAfterUpdateFinishEvent(){
	 items['C106000070_Form_1'].getDhxForm().resetDataProcessor("updated");
}
function onGridAfterUpdateFinishEvent(){
	 find('find','C106000070_Form_1','C106000070_Grid_1');
}
function onCheckboxEvent(row_id,cell_index,state){
 if(!state){
	 items['C106000070_Grid_1'].setUpdated(row_id,false,"");   
 }
 return true;
}

function onCheckboxHeaderClick(ind,obj){
   if(ind === 0){
    var checked=items['C106000070_Grid_1'].getCheckedRows(0);
    
    if(checked.length > 0){
     items["C106000070_Grid_1"].uncheckAll();
    }else{
     items["C106000070_Grid_1"].checkAll();  
    }   
  }
  return true;
}

function gridLoadAfterFunction(){
	find('find','C106000070_Form_1','C106000070_Grid_1');
	uiCommon.progressOff(parent);
	return true;
}

function serchIcon_ORD_USG_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('ORD_USG_CD','SZ0000','ORD_USG_CD','C106000070_Form_1');\">";
}
function serchIcon_CUS_CD(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('CUS_CD','SZ0000','CUS_CD','C106000070_Form_1');\">";
}
function serchIcon_EMP_ID(name,val){
	return "<img src="+window.dhx_globalImgPath+val+".gif align='top' onMouseOver=this.style.cursor='hand' onMouseOut=this.style.cursor='default' onClick=\"masterPopup('EMP_ID','SZ0000','ORD_RGS_PRS_ID','C106000070_Form_1');\">";
}
function masterPopup(CD_TP,CATEGORY_GROUP_NM,target,formId){
	winObj = new ui.window("popup","popup","0","0","469","532","masterGridData.do?CD_TP="+CD_TP+"&CATEGORY_GROUP_NM="+CATEGORY_GROUP_NM+"&targetName="+target+"&targetFormID="+formId);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}
// popup으로부터 넘겨받은 값 item에 세팅
function masterSetValue(code,name,target,formId){
	items[formId].setItemValue(target,code);
}

function onChangeEvent(id,value){
	
	var formObj   = items['C106000070_Form_1'];
	var vTableNm = formObj.getItemValue("TABLE_NAME");
	var ORD_REQ_NO = formObj.getItemValue("ORD_REQ_NO");
	var comboList = formObj.getMasterCombos();
	
	if(id == "ORD_REQ_NO" && (vTableNm == "TB_C10_B10R0020" || vTableNm == "TB_C10_B10S1030"))
	{
		comboList['ORD_REQ_LN'].readonly(false,false);
		ui.combo(comboList['ORD_REQ_LN'],"OrdlnComboData.do","ServiceName=C106000070-service&OrdLnFind=1&column-info=ORD_REQ_LN,ORD_REQ_LN&ORD_REQ_NO="+ORD_REQ_NO+"&TABLE_NAME="+vTableNm);
	}
	
	if(id == "ORD_REQ_NO" && (vTableNm == "TB_C10_B10R0030" || vTableNm == "TB_C10_B10S1010"))
	{
		comboList['ORD_REQ_LN'].readonly(false,false);
		ui.combo(comboList['ORD_REQ_LN'],"OrdlnComboData.do","ServiceName=C106000070-service&OrdLnFind1=1&column-info=ORD_LN,ORD_LN&ORD_REQ_NO="+ORD_REQ_NO+"&TABLE_NAME="+vTableNm);
	}	
}	
function doOnRowDblClicked(rowId) {
	var form = items['C106000070_Form_1'];
	var formObj = items['C106000070_Form_1'].getDhxForm();
	var comboList = items['C106000070_Form_1'].getMasterCombos();	
	if(!isNull(comboList['TABLE_NAME'].getSelectedValue())){
			  
    if(comboList['TABLE_NAME'].getSelectedValue() == "TB_C10_B10R0020"){
    
        var IF_GRP_ID = items['C106000070_Grid_1'].getDhxGrid().cells(rowId,0).getValue();
        var SEQ_NO = items['C106000070_Grid_1'].getDhxGrid().cells(rowId,1).getValue();
        //NullGrid Data 클릭시 Skip
        if(isNull(IF_GRP_ID) || isNull(SEQ_NO)){
          return;	
        }else{        	
        winObj = new ui.window("C106000070pop01","생산가부요청수신IF상세","0","0","945","585","C106000070pop01.jsp?IF_GRP_ID=" + IF_GRP_ID + "&SEQ_NO=" + SEQ_NO);
        winObj.setButtonDisable("park,minmax1");
        winObj.setModal();
        }        
    }
  }
}


//]]>
-->
</script>
</head>
<body>
<div id="C106000070_Form_1" style="position:absolute;height:95px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000070_Grid_1" style="position:absolute;height:470px;width:977px;left:1px;top:95px;">
</div>
<div id="C106000070_messagebox" style="position:absolute;height:19px;width:977px;left:1px;top:567px;">
</div>
</body>
<FORM >
</FORM>
</html>
<script>
<!--
//<![CDATA[
       ui.initializeDHTMLX();   
	   var onXleForm= items['C106000070_Form_1'].onXLEEvent(onFormLoadFunction); 
	   items['C106000070_Form_1'].onChangeEvent(onChangeEvent);
	   items["C106000070_Grid_1"].rowDblClicked(doOnRowDblClicked);
	   
	   
//]]>
-->
</script>