<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
프린트롤관리
</title>
<script type="text/javascript" src="./dhtmlx/codebase/glue.3x.ui.bootstrap.js">
</script>
<script src="./js/c10.ui.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
var items = new Array();  
/* var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C106000080_Form_1","xml":".\/header\/kr\/C106000080\/C106000080_Form_1.xml","url":"gridC10Data.do","referenceItem":"C106000080_Grid_1","service":"C106000080-service","actionType":"save","security":"true"},' +
      '{"itemType":"menu","renderTo":"C106000080_Menu_1","xml":".\/header\/kr\/C106000080\/C106000080_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000080_Grid_1","service":"C106000080-service"},' +
      '{"itemType":"grid","renderTo":"C106000080_Grid_1","xml":".\/header\/kr\/C106000080\/C106000080_Grid_1.xml","rowCnt":"22","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000080_Grid_1","service":"C106000080-service","actionType":"save"},' +
      '{"itemType":"form","renderTo":"C106000080_Form_2","xml":".\/header\/kr\/C106000080\/C106000080_Form_2.xml","url":"basicGridData.do","referenceItem":"C106000080_Form_1","service":"C106000080-service"},' +
      '{"itemType":"grid","renderTo":"C106000080_Grid_2","xml":".\/header\/kr\/C106000080\/C106000080_Grid_2.xml","rowCnt":"6","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000080_Grid_2","service":"C106000080-service"},' +
      '{"itemType":"messagebox","renderTo":"C106000080_messagebox","xml":".\/header\/kr\/C106000080\/C106000080_messagebox.xml","service":"C106000080-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration); */

var Menu_1 = {"itemType":"menu","renderTo":"C106000080_Menu_1","xml":".\/header\/kr\/C106000080\/C106000080_Menu_1.xml","iconImgs":".\/dhtmlx\/codebase\/imgs\/","referenceItem":"C106000080_Grid_1","service":"C106000080-service"};
var Form_1 = {"itemType":"form","renderTo":"C106000080_Form_1","xml":".\/header\/kr\/C106000080\/C106000080_Form_1.xml","url":"gridC10Data.do","referenceItem":"C106000080_Grid_1","service":"C106000080-service","actionType":"save","security":"true"};
var Form_2 = {"itemType":"form","renderTo":"C106000080_Form_2","xml":".\/header\/kr\/C106000080\/C106000080_Form_2.xml"};
var Grid_1 = {"itemType":"grid","renderTo":"C106000080_Grid_1","xml":".\/header\/kr\/C106000080\/C106000080_Grid_1.xml","rowCnt":"22","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000080_Grid_1","service":"C106000080-service","actionType":"save"};
var Grid_2 = {"itemType":"grid","renderTo":"C106000080_Grid_2","xml":".\/header\/kr\/C106000080\/C106000080_Grid_2.xml","rowCnt":"6","vertical":"true","url":"handleDataProcess.do","contextmenu":"true","borderline":"true","pageset":"true","split":"0","referenceItem":"C106000080_Grid_2","service":"C106000080-service"};

Grid_1.menu = Menu_1;
Form_2.header = "* 공정별 Print Roll 집계 현황";
Form_2.arrow = true;

var initLayout = 
{
	"programId":"C106000080", "itemType": "layout", "messageBox":true, "dirType":"row", "childSize":"60", "splitter":false, "components": 
	[
		Form_1,
		{
			"itemType": "layout", "dirType":"row", "childSize":"340,160,", "splitter":true, "components": 
			[
				Grid_1,
				Form_2,
				Grid_2,
			]
		}
 	]
};

var procCdComboVal = [['A4', 'A4'], ['A5', 'A5'], ['A6', 'A6'], ['A7', 'A7'], ['A8', 'A8'], ['A9', 'A9']];
var useYnComboVal = [['Y', 'Y'], ['N', 'N'], ['Y(SPARE)', 'Y(SPARE)']];
var rollWthComboVal = [[1350, '1,350'], [1600, '1,600']];
var rollPointComboVal = [['무핀트', '무핀트'], ['일반핀트', '일반핀트'], ['무늬핀트', '무늬핀트']];
var rollPrdCmpComboVal = [['형제제판', '형제제판'], ['다인', '다인'], ['동성로라', '동성로라'], ['태광스크린','태광스크린'], ['기타', '기타']];
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
//form find button item event function (requred)
function find(eventName,formDivObj,referenceItem){
	var findUrl = uiCommon.parameters(formDivObj,referenceItem,eventName);
	findUrl +=  "&USER_NO="+'<%=userNo%>';
	items[referenceItem].loadData(findUrl);

	var findUrl1 = uiCommon.parameters('C106000080_Form_1','C106000080_Grid_2','find_sum');
	items['C106000080_Grid_2'].loadData(findUrl1);
}

function saveof(eventName,formDivObj,referenceItem){
	var gridObj = items['C106000080_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var row_status = "", err_cnt = 0, chgCnt = 0;
	var ROLL_CD = ""

	var rowId = items['C106000080_Grid_1'].getRowSelectedId();
	gridObj.selectRow(gridObj.getRowIndex(rowId));

	for(var i=0; i< grid_cnt; i++){
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");//INSERT시에만 값체크 하기
		if(row_status !== ""){
			chgCnt++;
			
			if(gridObj.cellById(gridObj.getRowId(i),0).getValue()==""){
				err_cnt++;
				dhtmlx.alert("롤코드를 선택하세요.(더블클릭 후 팝업에서 선택)");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),3).getValue()==""){
				err_cnt++;
				dhtmlx.alert("보유라인을 선택하세요.");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),6).getValue()==""){
				err_cnt++;
				dhtmlx.alert("사용가능 여부를 선택하세요.");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),7).getValue()==""){
				err_cnt++;
				dhtmlx.alert("규격(외주,mm)를 입력하세요.");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),8).getValue()==""){
				err_cnt++;
				dhtmlx.alert("규격(Φ,mm)를 입력하세요.");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),9).getValue()==""){
				err_cnt++;
				dhtmlx.alert("규격(폭,mm)를 입력하세요.");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),10).getValue()==""){
				err_cnt++;
				dhtmlx.alert("핀트를 선택하세요.");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),13).getValue()==""){
				err_cnt++;
				dhtmlx.alert("제작업체를 선택하세요.");
				break;
			}
			if(gridObj.cellById(gridObj.getRowId(i),20).getValue()==""){
				err_cnt++;
				dhtmlx.alert("입고일자를 선택하세요.");
				break;
			}
			
			/*
			if(row_status=="inserted"){
				ROLL_CD = gridObj.cellById(gridObj.getRowId(i),0).getValue();				
				if(ROLL_CD == "" ){
					err_cnt++;
					dhtmlx.alert("롤번호를 입력하세요.");
					break;
				}
			
				var param= "ServiceName=C106000080-service&prtrollajax=1&ROLL_CD="+ROLL_CD+"&column-info="+items['C106000080_Grid_1'].getColumnInfo();
				var xmlObj = uiCommon.ajaxLoadData('c10AjaxData.do',param);
				var cells = xmlObj.getElementsByTagName("cell");
				
				if(cells.item(0).firstChild.nodeValue == ""){
					dhtmlx.alert("존재하지 않는 롤번호입니다.");
					err_cnt++;
					break;   
				}else{							
					gridObj.cellById(gridObj.getRowId(i),2).setValue(cells.item(1).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),4).setValue(cells.item(2).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),10).setValue(cells.item(3).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),11).setValue(cells.item(4).firstChild.nodeValue);
					gridObj.cellById(gridObj.getRowId(i),14).setValue(cells.item(5).firstChild.nodeValue);
				}
			}
			*/
		}
		if(err_cnt > 0) break;
	}
	
	if(err_cnt === 0) {
		if(chgCnt === 0 ) {
			dhtmlx.alert("변경된 데이터가 없습니다.");
			return;
		}else{
			dhtmlx.confirm({
				ok:"확인", cancel:"취소",
				text:" 입력된 정보를 저장하시겠습니까? ",
				callback:function(val){
				 if(val){
					items[referenceItem].sendGrid(referenceItem,"saveof");
				   return;
				 }
				}
			});	
		}
	}
}

function saveop(eventName,formDivObj,referenceItem){
	var gridObj = items['C106000080_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	var row_status = "", err_cnt = 0, chgCnt = 0;
	var ROLL_CD = ""
	//var rowId = items['C106000080_Grid_1'].getRowSelectedId();
	//gridObj.selectRow(gridObj.getRowIndex(rowId));

	for(var i=0; i< grid_cnt; i++){
		row_status = gridObj.getUserData(gridObj.getRowId(i),"!nativeeditor_status");//INSERT시에만 값체크 하기
		if(row_status !== ""){
			chgCnt++;			
			// if(gridObj.cellById(gridObj.getRowId(i),0).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("롤코드를 선택하세요.(더블클릭 후 팝업에서 선택)");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),3).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("보유라인을 선택하세요.");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),6).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("사용가능 여부를 선택하세요.");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),7).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("규격(외주,mm)를 입력하세요.");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),8).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("규격(Φ,mm)를 입력하세요.");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),9).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("규격(폭,mm)를 입력하세요.");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),10).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("핀트를 선택하세요.");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),13).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("제작업체를 선택하세요.");
			// 	break;
			// }
			// if(gridObj.cellById(gridObj.getRowId(i),20).getValue()==""){
			// 	err_cnt++;
			// 	dhtmlx.alert("입고일자를 선택하세요.");
			// 	break;
			// }
		}
		if(err_cnt > 0) break;
	}
	
	if(err_cnt === 0) {
		if(chgCnt === 0 ) {
			dhtmlx.alert("변경된 데이터가 없습니다.");
			return;
		}else{
			dhtmlx.confirm({
				ok:"확인", cancel:"취소",
				text:" 수정된 정보를 저장하시겠습니까? ",
				callback:function(val){
				 if(val){
					items[referenceItem].sendGrid(referenceItem,"saveop");
				   return;
				 }
				}
			});	
		}
	}
}

// 이미지 등록을 위한 POP-UP
function doImgPopUp(rowIdx){	
	var gridObj = items['C106000080_Grid_1'].getDhxGrid();
	var rowId = gridObj.getRowIndex(rowIdx);
	
	var md_url = "C106000080pop01.jsp?rowId="+rowId;
		md_url += "&PRT_ROLL_NO="+items['C106000080_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('ROLL_CD'));
		md_url += "&PRT_ROLL_IMG_SEQ_NO="+items['C106000080_Grid_1'].getCellByIndexValue(rowId,gridObj.getColIndexById('ROLL_CD_SEQ_NO'));
		md_url += "&parent_item=C106000080_Grid_1";
		md_url += "&IMG_RGS_TP=1";  //1로 고정
		
	var cusWinObj = new ui.window("C106000080PopWin","프린트롤 이미지 등록","0","0","465","405",md_url);
	cusWinObj.setButtonDisable("park,minmax1");
	cusWinObj.setModal();
}

//menu refresh event function
function refresh(referenceItem){ //grid selection clear event
	//테스트
	items[referenceItem].clearDataProcess();
	var findUrl = uiCommon.parameters('C106000080_Form_1',referenceItem,'find');
	items[referenceItem].loadData(findUrl);	
}
//menu new row event function
function add(referenceItem){
	items[referenceItem].addRow();
	//행 추가 했을 때 기본적인 정보들이 자동으로 grid에 입력된다.
	setAutoData(items[referenceItem].getDhxGrid().getRowId(0),0);
}
//행추가시 등록자, 등록자명, seq를 가져와서 화면에 보여준다.
//등록자 아이디를 가져오는 로직을 분석한다.
//seq는 ajax를 이용해서 값을 가져오고 그 값에 +1을 해서 화면에 보여준다.
function setAutoData(id,cInd){
	var grdObj = items['C106000080_Grid_1'].getDhxGrid();
	if(cInd==0){
		var row_status = grdObj.getUserData(id,"!nativeeditor_status");
		if(row_status=="inserted"){
			
			grdObj.cellById(id,grdObj.getColIndexById("ROLL_RGS_DH")).setValue(uiCommon.getCurrentDate());
			grdObj.cellById(id,grdObj.getColIndexById("ROLL_MDF_DH")).setValue(uiCommon.getCurrentDate());
		}
	}
}

//menu remove event function
function remove(referenceItem){
	if(items['C106000080_Grid_1'].getSelectedRowId()==null){
		dhtmlx.alert("삭제 대상이 없습니다.");
	}else{
		items[referenceItem].removeRow();
	}
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
//menu roll코드 search 기능
function searchRoll(referenceItem){
	var grid1	= items['C106000080_Grid_1'];
	var grid1Obj= items['C106000080_Grid_1'].getDhxGrid();
	if(grid1Obj.getUserData(grid1.getSelectedRowId(),"!nativeeditor_status")=="inserted"){
		rollSelectPopup(grid1.getSelectedRowId(),1);
	}else{
		dhtmlx.alert("추가한 행 선택 후 클릭하세요.");
	}
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
		var findUrl = C10_parameters16("C106000080_Form_1","C106000080_Grid_1","find","excelExportC106000080.do","C106000080-service");
			findUrl +=  "&FILENM=C106000080";
		win = window.open(findUrl, "EXCEL", "width=400,height=300,scrollbars=yes");
		//gridObj.toExcel('<%=request.getContextPath()%>/gridexcel','color');
	}
}

function findMessage(referenceItem){
	//저장 후 조회라면 저장 메세지를 출력 적용
	if(items["C106000080_Form_1"].getItemValue('saveMessage') == "" 
		|| items["C106000080_Form_1"].getItemValue('saveMessage') == null) {
		uiCommon.message("messagebox",referenceItem.getUserData("","appMsg"));
	} else {
		uiCommon.message("messagebox",items["C106000080_Form_1"].getItemValue('saveMessage'));
		items["C106000080_Form_1"].setItemValue('saveMessage',"");
	}
  	return true;
}

function onFormLoadFunction(formDivObj){ 
 return true;
}

function parentViewImg(rowIdx,imgnm){
	var winObj2;
	var md_url = "C106000080pop02.jsp?grid=C106000080_Grid_1&imgnm="+encodeURIComponent(imgnm)+"&img_rgs_flags=03";
	winObj = new ui.window("viewWinPop","프린트롤 이미지 조회","0","0","950","550",md_url);
	winObj.setButtonDisable("park,minmax1");
	winObj.setModal();
}

/* [그리드 로드]
 * 그리드 로드 시 수행하는 함수 
 */
function onLoadGrid (){
	var grid =  items['C106000080_Grid_1'];
	var gridObj = items['C106000080_Grid_1'].getDhxGrid();
	
	//그리드 콤보
	var procCdCombo = gridObj.getColumnCombo(gridObj.getColIndexById('PROC_CD'));
	procCdCombo.addOption(procCdComboVal);    
	procCdCombo.enableOptionAutoPositioning(true);
	procCdCombo.readonly(true,true);
	procCdCombo.setOptionHeight(140);
	
	var useYnCombo = gridObj.getColumnCombo(gridObj.getColIndexById('USE_YN'));
	useYnCombo.addOption(useYnComboVal);    
	useYnCombo.enableOptionAutoPositioning(true);
	useYnCombo.readonly(true,true);
	useYnCombo.setOptionHeight(80);
	
	var rollWthCombo = gridObj.getColumnCombo(gridObj.getColIndexById('ROLL_WTH'));
	rollWthCombo.addOption(rollWthComboVal);    
	rollWthCombo.enableOptionAutoPositioning(true);
	rollWthCombo.readonly(true,true);
	rollWthCombo.setOptionHeight(60);
	
	var rollPointCombo = gridObj.getColumnCombo(gridObj.getColIndexById('ROLL_POINT'));
	rollPointCombo.addOption(rollPointComboVal);    
	rollPointCombo.enableOptionAutoPositioning(true);
	rollPointCombo.readonly(true,true);
	rollPointCombo.setOptionHeight(80);
	
	var rollPrdCmpCombo = gridObj.getColumnCombo(gridObj.getColIndexById('ROLL_PRD_CMP'));
	rollPrdCmpCombo.addOption(rollPrdCmpComboVal);    
	rollPrdCmpCombo.enableOptionAutoPositioning(true);
	rollPrdCmpCombo.readonly(true,true);
	rollPrdCmpCombo.setOptionHeight(100);

	items["C106000080_Grid_1"].getDhxGrid().detachEvent(_onXLEGrid);
	
	grid.rowDblClicked(function(rId,cInd) {
		if(cInd == 20 || cInd == 21 || cInd == 22  || cInd == 23) {
			grid.setCellValue(rId,cInd,"");
			grid.setUpdated(rId,true,"updated");
		}
	});

}

//저장 후 조회처리
function onAfterUpdateFinishEvent(){
	//var msg = getMessage('C106000080_messagebox');
	//if (msg != "") {
	  //items['C106000080_Form_1'].setItemValue('saveMessage',msg);
	  find('find','C106000080_Form_1','C106000080_Grid_1');	
	//}
}

function setReadonly(){
	var gridObj = items['C106000080_Grid_1'].getDhxGrid();
	var grid_cnt = gridObj.getRowsNum();
	for(var i=0; i<grid_cnt; i++) {
		gridObj.setCellExcellType(gridObj.getRowId(i), 3, "ro");
	}
}

function rollSelectPopup(rId,cInd){
	var grid = items['C106000080_Grid_1'];
	var gridDhxObj = items['C106000080_Grid_1'].getDhxGrid();
	if(cInd == 1){
		var cellVal = grid.getCellValue(rId,cInd);
		if(cellVal == ''){
			if(gridDhxObj.getUserData(grid.getSelectedRowId(),"!nativeeditor_status")=="inserted"){
				winObj = new ui.window("rollSelectPopup","패턴롤 선택","0","0","669","532","c106000080pop03.do?rowId="+rId+"&cellIndex="+cInd);		
				winObj.setButtonDisable("park,minmax1");
				winObj.setModal();
				//winObj.getDhxWindow().setPosition(500,500);
				winObj.getDhxWindow().attachEvent("onClose", function(win){
					this.hide();
					return true;
					//winObj.unload();
				});
			}else{
				dhtmlx.alert("추가한 행 선택 후 클릭하세요.!!");
			}
		}
	}
}

//C106000060pop01으로부터 넘겨받은 값 item에 세팅(프린트롤BACK)
function pop3SetValue(rowId,rollCd,rollTp,ptnNm,usgNm,dtlUsgNm,rpvClrNm){
	var grid = items['C106000080_Grid_1'];
	
	items['C106000080_Grid_1'].setCellValue(rowId,0,rollCd);
	items['C106000080_Grid_1'].setCellValue(rowId,2,rollTp);
	items['C106000080_Grid_1'].setCellValue(rowId,5,ptnNm);
	items['C106000080_Grid_1'].setCellValue(rowId,11,usgNm);
	items['C106000080_Grid_1'].setCellValue(rowId,12,dtlUsgNm);
	items['C106000080_Grid_1'].setCellValue(rowId,15,rpvClrNm);

	return true;
}

function doLink(val){
	parent.newRemoveOpenTab("C106000090","ROLL_CD="+val);
}

function onEditCellEvent(stage,rId,cInd,nValue,oValue){
	var grid = items['C106000080_Grid_1'];
	var grdObj = items['C106000080_Grid_1'].getDhxGrid();
	
	if(stage == 2){
		if(!isNull(nValue)){
			if(cInd==7 && nValue!=oValue){//외주 
				var roll_dia = parseFloat(nValue)/3.141592;
			    roll_dia = roll_dia.toFixed(1);
				grid.setCellValue(grid.getRowSelectedId(),8, roll_dia);
			}
		}	
	}	
	return true;
}

//메뉴 버튼 권한 처리
function menuButtonSecurity(){
	var frmUrl = window.location.href;
	var varCut = frmUrl.indexOf("?");
	var varCheck = frmUrl.substring(varCut+1,frmUrl.length);
	var menuObj = items['C106000080_Menu_1'].getDhxMenu();

	menuObj.hideItem("add");
	menuObj.hideItem("remove");	

	if(varCheck.match("m90") == null){
		var buttonList = dhtmlxAjax.postSync("_buttonSecurityData.jsp?"+eval(varCheck.split("&",1)));			
		var buttonListArray = buttonList.xmlDoc.responseText.replace(/(^\s*)|(\s*$)/g,"").split(',');
		for(var i=0; i<buttonListArray.length; i++){
			var _itemtype = menuObj.getItemType(buttonListArray[i]);
			if(_itemtype != null)
			{
				menuObj.showItem(buttonListArray[i]);
				// menuObj.setItemEnabled(buttonListArray[i]);
			}
		}
	}
}

var tooltip=function(){
	var id = 'tt';
	var top = 3;
	var left = 3;
	var maxw = 300;
	var speed = 10;
	var timer = 20;
	var endalpha = 95;
	var alpha = 0;
	var tt,t,c,b,h;
	var ie = document.all ? true : false;
	return{
		show:function(v,w){
			if(tt == null){
				tt = document.createElement('div');
				tt.setAttribute('id',id);
				t = document.createElement('div');
				t.setAttribute('id',id + 'top');
				c = document.createElement('div');
				c.setAttribute('id',id + 'cont');
				b = document.createElement('div');
				b.setAttribute('id',id + 'bot');
				tt.appendChild(t);
				tt.appendChild(c);
				tt.appendChild(b);
				document.body.appendChild(tt);
				tt.style.opacity = 0;
				tt.style.filter = 'alpha(opacity=0)';
				document.onmousemove = this.pos;
			}
			tt.style.display = 'block';
			c.innerHTML = v;
			tt.style.width = w ? w + 'px' : 'auto';
			if(!w && ie){
				t.style.display = 'none';
				b.style.display = 'none';
				tt.style.width = tt.offsetWidth;
				t.style.display = 'block';
				b.style.display = 'block';
			}
			if(tt.offsetWidth > maxw){tt.style.width = maxw + 'px'}
			h = parseInt(tt.offsetHeight) + top;
			clearInterval(tt.timer);
			tt.timer = setInterval(function(){tooltip.fade(1)},timer);
		},
		pos:function(e){
			var u = ie ? event.clientY + document.documentElement.scrollTop : e.pageY;
			var l = ie ? event.clientX + document.documentElement.scrollLeft : e.pageX;
			tt.style.top = (u - h) + 'px';
			tt.style.left = (l + left) + 'px';
		},
		fade:function(d){
			var a = alpha;
			if((a != endalpha && d == 1) || (a != 0 && d == -1)){
				var i = speed;
				if(endalpha - a < speed && d == 1){
					i = endalpha - a;
				}else if(alpha < speed && d == -1){
					i = a;
				}
				alpha = a + (i * d);
				tt.style.opacity = alpha * .01;
				tt.style.filter = 'alpha(opacity=' + alpha + ')';
			}else{
				clearInterval(tt.timer);
				if(d == -1){tt.style.display = 'none'}
			}
		},
		hide:function(){
			clearInterval(tt.timer);
			tt.timer = setInterval(function(){tooltip.fade(-1)},timer);
		}
	};
}();
//]]>
</script>
</head>
<body>
<!--<div id="C106000080_Form_1" style="position:absolute;height:28px;width:981px;left:0px;top:0px;">
</div>
<div id="C106000080_Menu_1" style="position:absolute;height:25px;width:981px;left:0px;top:28px;">
</div>
<div id="C106000080_Grid_1" style="position:absolute;height:331px;width:980px;left:-1px;top:54px;">
</div>
<div id="C106000080_Grid_2" style="position:absolute;height:24px;width:981px;left:0px;top:386px;">
</div>
<div id="C106000080_Grid_2" style="position:absolute;height:161px;width:980px;left:-1px;top:406px;">
</div>
<div id="C106000080_messagebox" style="position:absolute;height:19px;width:980px;left:-1px;top:567px;">
</div>
</body>-->
</html>
<script>
//<![CDATA[
	ui.initializeDHTMLX();
	items["C106000080_Grid_1"].onEditCellEvent(onEditCellEvent);
	items["C106000080_Grid_1"].onAfterUpdateFinishEvent(onAfterUpdateFinishEvent);
	items["C106000080_Grid_1"].rowDblClicked(rollSelectPopup);
	var _onXLEGrid = items["C106000080_Grid_1"].onXLEEvent(onLoadGrid);
	items["C106000080_Menu_1"].onXLEEvent(menuButtonSecurity);
	items["C106000080_Grid_1"].onXLEEvent(setReadonly);
	// 행삭제시 삭제데이타 붉은색 실선으로 표시
	var dataProcessor = items["C106000080_Grid_1"].getDhxDataProcess();
	dataProcessor.styles ={inserted: "font-weight:bold; color:black;",updated: "font-weight:bold; color:black;",deleted:"font-weight:bold; color:red;text-decoration: line-through;"}	
//]]>
</script>