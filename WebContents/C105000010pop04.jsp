<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</meta>
<title>
톤당길이계산
</title>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript">
</script>
<script src="./js/c10.ui.js" type="text/javascript">
</script>
<script type="text/javascript">
<!--
//<![CDATA[
var items = new Array();  //public dhtmlx component array
var pageConfiguration = '[' + 
      '{"itemType":"form","renderTo":"C105000010pop04_Form_1","xml":".\/header\/kr\/C105000010pop04\/C105000010pop04_Form_1.xml","url":"basicGridData.do","referenceItem":"C105000010pop04_Form_1","service":"C105000010pop04-service"},' +
      '{"itemType":"messagebox","renderTo":"C105000010pop04_messagebox","xml":".\/header\/kr\/C105000010pop04\/C105000010pop04_messagebox.xml","service":"C105000010pop04-service"},' +
      '{"itemType":"form","renderTo":"C105000010pop04_Form_2","xml":".\/header\/kr\/C105000010pop04\/C105000010pop04_Form_2.xml","url":"basicGridData.do","referenceItem":"C105000010pop04_Form_1","service":"C105000010pop04-service"}' +
   ']';
var initConfig = JSON.parse(pageConfiguration);	     
var gridContextMenuConfig = {"xml":"./dhtmlx/data/contextmenu.xml","iconImgs":window.dhx_globalImgPath};
var req;
var resultDiv;
var pltcm_set_thk_trv_temp; //압연set임시
var prdNmCd_Cal_global;     //품명전역변수
var ton_cal_result_temp;    //톤당길이임시

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
    var findUrl = uiCommon.parameters('C105000010pop04_Form_1',referenceItem,'find');
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
	uiCommon.message("C105000010pop04_messagebox",referenceItem.getUserData("","appMsg"));
  	return true;
}
function popClose(){
	parent.winObj.winClose();
}
function onFormLoadFunction(formDivObj){
	//Form2에 있는 콤보가지고 오기
	var form  = items['C105000010pop04_Form_2'];
	var comboList = items['C105000010pop04_Form_2'].getMasterCombos();
	//선택된 품명코드
	var sel_prd_nm_cd;
	//선택된 도금량 지정코드
	var sel_gw_asg_cd;
	
	//품명콤보
	comboList['PRD_NM_CD_NM'].readonly(true,false);
	ui.combo.master(comboList['PRD_NM_CD_NM'],'SZ0000','PRD_NM_CD','totalValue=,orderBy=value,displayType=all-code',function(){
	  //comboList['PRD_NM_CD_NM'].selectOption(0,true,true);
	});
	//백스페이스 이벤트 막기처리
	comboList['PRD_NM_CD_NM'].DOMelem_input.onkeydown = function(e){
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
	
	//도금량 ComboXml 설정
	comboList['PRD_NM_CD_NM'].attachEvent("onSelectionChange", function(){
		var gridComboSelectValue = comboList['PRD_NM_CD_NM'].getSelectedValue();
		form.setItemValue("PRD_NM_CD",gridComboSelectValue);
		var category = "";
			if(gridComboSelectValue == "G" || gridComboSelectValue == "3" || gridComboSelectValue == "J" || gridComboSelectValue == "6"){
				category = "SG0000";
			}else if(gridComboSelectValue == "L" || gridComboSelectValue == "4"){
				category = "SL0000";
			}else if(gridComboSelectValue == "E" || gridComboSelectValue == "2"){
				category = "SE0000";
			}
			if(category != ""){
				ui.combo.master(comboList['GW_ASG_CD_NM'],category,'GW_ASG_CD','totalValue=,orderBy=value,displayType=all-code',function(){
				  //comboList['GW_ASG_CD_NM'].selectOption(0,true,true);
				});
			}else{
				comboList['GW_ASG_CD_NM'].setComboText('');
				comboList['GW_ASG_CD_NM'].clearAll();
			}
			//백스페이스 이벤트 막기처리
			comboList['GW_ASG_CD_NM'].DOMelem_input.onkeydown = function(e){
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
			
		//도금량
		comboList['GW_ASG_CD_NM'].attachEvent("onSelectionChange", function(){
			var comboSelectValue = comboList['GW_ASG_CD_NM'].getSelectedValue();
			form.setItemValue("GW_ASG_CD",comboSelectValue);});
	});
	
	//BMT/TCT콤보
	comboList['ORD_THK_TP'].readonly(true,false);
	ui.combo.master(comboList['ORD_THK_TP'],'SZ0001','ORD_THK_TP','totalValue=,orderBy=value,displayType=all-code',function(){
	  //comboList['PRD_NM_CD_NM'].selectOption(0,true,true);
	});
	//백스페이스 이벤트 막기처리
	comboList['ORD_THK_TP'].DOMelem_input.onkeydown = function(e){
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
	
	//BMT&TCT에 따른 압엽set값 계산
	comboList['ORD_THK_TP'].attachEvent("onSelectionChange", function()
	{
		var comboSelectValue = comboList['ORD_THK_TP'].getSelectedValue();
		var ordExcThk = form.getItemValue("ORD_EXC_THK");  //주문두께(원래값)
		var ordExcThk_Cal;                                 //계산두께
		var prdNmCd_Cal = form.getItemValue("PRD_NM_CD")   //계산용품명코드(카테고리별)
	    
		if(prdNmCd_Cal == "G" || prdNmCd_Cal == "3" || prdNmCd_Cal == "J" || prdNmCd_Cal == "6")
		{
			prdNmCd_Cal ="G";  //품명통합
		}
		else if(prdNmCd_Cal == "L" || prdNmCd_Cal == "4")
		{
			prdNmCd_Cal ="L";
		}
		else if(prdNmCd_Cal == "E" || prdNmCd_Cal == "2")
		{
			prdNmCd_Cal ="E";
		}
		
		if( comboSelectValue == "1" )  //BMT선택한 경우
		{
			form.setItemValue("PLTCM_SET_THK_TRV1",ordExcThk);  //주문두께 그대로 입력
		}
		else if( comboSelectValue == "2" ) //도금TCT, 칼라TCT를 선택한경우
		{			
			var url = "";   //url생성 후 보내기
			url += "C105000010pop04_cal.jsp?PRD_NM_CD="+prdNmCd_Cal;
			url += "&GW_ASG_CD="+form.getItemValue("GW_ASG_CD");
			setRequest();
			req.open("GET", url, true);          // request 형식. GET, POST
			req.onreadystatechange = callback;   // 상태가 바뀔때마다 호출되는 함수 callback 호출
			req.send(null);
			
			//ordExcThk_Cal = ordExcThk - (pltcm_set_thk_trv_temp/1000);
			//form.setItemValue("PLTCM_SET_THK_TRV1",ordExcThk_Cal);
			//form.setItemFocus("PLTCM_SET_THK_TRV1");
		}
		prdNmCd_Cal_global = prdNmCd_Cal;
	});
	
	items['C105000010pop04_Form_2'].getDhxForm().detachEvent(onXleForm);
}
//계산공식
function calculate(eventName,formDivObj,referenceItem){
	
	var form  = items['C105000010pop04_Form_2'];
	var url = "";          //url생성 후 보내기
	
	if(form.getItemValue("PLTCM_SET_THK_TRV1")=="" ||form.getItemValue("PLTCM_SET_THK_TRV1")==null)  //Validation Check!
	{
		dhtmlx.alert("값을 입력해 주세요!");
	}
	else
	{
		url += "C105000010pop05_cal.jsp?PRD_NM_CD="+prdNmCd_Cal_global;
		url += "&GW_ASG_CD="+form.getItemValue("GW_ASG_CD");
		setRequest();
		req.open("GET", url, true);          // request 형식. GET, POST
		req.onreadystatechange = callback1;   // 상태가 바뀔때마다 호출되는 함수 callback 호출
		req.send(null);

		if (form.getItemValue("TON_PER_LENGTH2")!="" || form.getItemValue("TON_PER_LENGTH2")!=null)
		{
			url = "";
			url += "C105000010pop06_cal.jsp?PRD_NM_CD="+prdNmCd_Cal_global;
			url += "&GW_ASG_CD="+form.getItemValue("GW_ASG_CD");
			setRequest();
			req.open("GET", url, true);          // request 형식. GET, POST
			req.onreadystatechange = callback2;   // 상태가 바뀔때마다 호출되는 함수 callback 호출
			req.send(null);
		}
	} 	
}
function clear(){
	
	//Form2에 있는 콤보가지고 오기
	var form  = items['C105000010pop04_Form_2'];
	var comboList = items['C105000010pop04_Form_2'].getMasterCombos();
	
	comboList['PRD_NM_CD_NM'].setComboText('');
	comboList['GW_ASG_CD_NM'].setComboText('');
	comboList['ORD_THK_TP'].setComboText('');

	items['C105000010pop04_Form_2'].setItemValue("ORD_EXC_THK","");         //주문두께
	items['C105000010pop04_Form_2'].setItemValue("ORD_EXC_WTH","");         //주문폭  
	items['C105000010pop04_Form_2'].setItemValue("PLTCM_SET_THK_TRV1","");  //압연set1  
	items['C105000010pop04_Form_2'].setItemValue("TON_PER_LENGTH1","");     //톤당길이1
	items['C105000010pop04_Form_2'].setItemValue("TON_PER_LENGTH_MIN","");  //톤당길이min
	items['C105000010pop04_Form_2'].setItemValue("TON_PER_LENGTH_MAX","");  //톤당길이max
	items['C105000010pop04_Form_2'].setItemValue("ORD_EXC_LTH","");         //주문길이
	items['C105000010pop04_Form_2'].setItemValue("TOT_WGT","");             //전체중량
	items['C105000010pop04_Form_2'].setItemValue("TON_PER_LENGTH2","");     //톤당길이2
	items['C105000010pop04_Form_2'].setItemValue("PLTCM_SET_THK_TRV2","");  //압연set2
	
}
/* request 객체의 상태변화시 호출되는 함수 */
function callback(){
 if(req.readyState == 4){                                        // response 될때
   if(req.status == 200){                                        // 서버가 응답할때 200, 페이지 없을때 404, 서버오류시 500 
	   var form  = items['C105000010pop04_Form_2'];
	   var ordExcThk = form.getItemValue("ORD_EXC_THK");         //주문두께(원래값)
	   var ordExcThk_Cal = ordExcThk - (req.responseText/1000);
	   form.setItemValue("PLTCM_SET_THK_TRV1",ordExcThk_Cal);    //1.압연set1계산
  }   
 }     
}

/* request 객체의 상태변화시 호출되는 함수 */

function callback1(){
 if(req.readyState == 4){     // response 될때
   if(req.status == 200){     // 서버가 응답할때 200, 페이지 없을때 404, 서버오류시 500 
	   var form  = items['C105000010pop04_Form_2'];
	   var ton_cal_result;    //톤당길이
	   var ton_cal_result_min //톤당길이min
	   var ton_cal_result_max //톤당길이max
	   
       //톤당길이 계산..(반올림)
       ton_cal_result_temp = req.responseText;
       ton_cal_result = Math.round( 1000000/( ( (form.getItemValue("PLTCM_SET_THK_TRV1")*7.85)+(ton_cal_result_temp/1000) )*form.getItemValue("ORD_EXC_WTH") ) );
       form.setItemValue("TON_PER_LENGTH1",ton_cal_result); //2.톤당길이
              
	   ton_cal_result_min = Math.round(1000000/((((form.getItemValue("PLTCM_SET_THK_TRV1")-0.01)*7.85)+(ton_cal_result_temp/1000))*form.getItemValue("ORD_EXC_WTH")));
       form.setItemValue("TON_PER_LENGTH_MIN",ton_cal_result_min); //3.톤당길이MIN
	   
       ton_cal_result_max = Math.round(1000000/((((form.getItemValue("PLTCM_SET_THK_TRV1")+0.01)*7.85)+(ton_cal_result_temp/1000))*form.getItemValue("ORD_EXC_WTH")));
	   form.setItemValue("TON_PER_LENGTH_MAX",ton_cal_result_max); //4.톤당길이MAX
       
       var tot_wgt = form.getItemValue("ORD_EXC_LTH")*ton_cal_result;  
	   form.setItemValue("TOT_WGT",tot_wgt);  //6.전체중량
       
  }   
 }     
}

function callback2(){
	 if(req.readyState == 4){     // response 될때
	   if(req.status == 200){     // 서버가 응답할때 200, 페이지 없을때 404, 서버오류시 500 
		    var form  = items['C105000010pop04_Form_2'];
            
	        //도금부착량하한
            var wk_gw_tot_uvl = req.responseText;
	        
			//var pltcm_set_thk_trv_temp2 = (1000000/(form.getItemValue("ORD_EXC_WTH")*form.getItemValue("TON_PER_LENGTH2"))-(wk_gw_tot_uvl/1000))/7.85; //계산된 압연 SET
			var pltcm_set_thk_trv_temp2 = (1000000/((form.getItemValue("ORD_EXC_WTH")*form.getItemValue("TON_PER_LENGTH2"))-(wk_gw_tot_uvl/1000)))/7.85;
			form.setItemValue("PLTCM_SET_THK_TRV2",pltcm_set_thk_trv_temp2);
	  }   
	}     
}

function setRequest(){
  if( window.ActiveXObject){ // MS 브라우저의 request 생성
   req = new ActiveXObject("Microsoft.XMLHTTP");     
  }else if(window.XMLHttpRequest){       // MS 브라우저 가 아닌 브라우저의 request 생성
   req = new XMLHttpRequest();     
  }
 }
//]]>
-->
</script>
</head>
<body>
<div id="C105000010pop04_Form_1" style="position:absolute;height:30px;width:615px;left:0px;top:0px;">
</div>
<div id="C105000010pop04_messagebox" style="position:absolute;height:19px;width:612px;left:1px;top:500px;">
</div>
<div id="C105000010pop04_Form_2" style="position:absolute;height:470px;width:615px;left:0px;top:34px;">
</div>
</body>
</html>
<script>
<!--
//<![CDATA[
	ui.initializeDHTMLX();
	var onXleForm = items["C105000010pop04_Form_2"].onXLEEvent(onFormLoadFunction);
	
//]]>
-->
</script>