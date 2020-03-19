/** 
 * @fileoverview UI Designer  ???? ?? dhtmlx component api wrapper component <br>
 * MES UI???? ?????? DHTMLX component ?? ?????? ???? wrapper component ?? ???? <br>
 * ui component ???? <br>
 * ui.common <br>
 * ui.grid <br>
 * ui.from <br>
 * ui.menu <br>
 * ui.dataprocess <br>
 * ui.tabbar <br>
 * ui.contextmenu <br>
 * ui.messagebox <br>
 * ui.initializeDHTMLX <br>
 * @author KyungSeo Park kyung-seo@withfuture.com <br>
 * @version 0.1 
 */
 
/**
 * Construct ui package object.
 * @class ui class  
 * @constructor
 */
function parameters12 (){
    /** arguments check */
     if(arguments.length < 1 || arguments.length < 2 || arguments.length < 3){
       dhtmlx.alert("function arguments setting not found<br>"+
             "arguments[0] : search form div object id<br>"+
             "arguments[1] : vertical grid(target Grid) div object id<br>"+
             "arguments[2] : service name<br>"+
             "arguments[3] : event name<br>"+
             "arguments[4] : option custom parameter add\n");
       return true;
     }  
    
      /** dhtmlx form item data */
      var _formdata = parent.items[arguments[0]].getDhxForm().getFormData();
      /** parameter array */
      var _data = [];
      /** activity serviceName push */
      _data.push("ServiceName="+arguments[2]);
      _data.push(arguments[3]+"=1");
     
      /** dhtmlx item type ?? ???? key,value ???? calendar?? data?? ??????? ????? ??? */
      for (var _key in _formdata){	
       var _itemtype = parent.items[arguments[0]].getDhxForm().getItemType(_key);
         if(_itemtype == 'radio'){ 
        	 var _radioItem = parent.items[arguments[0]].getDhxForm().getCheckedValue(_key);
         	_data.push(_key+"="+encodeURIComponent(_radioItem)); 
         }else if(_itemtype == 'calendar'){			 
			 if(parent.items[arguments[0]].getDhxForm().getInput(_key).value !== ""){
				 var _dhxCalendar = parent.items[arguments[0]].getDhxForm().getCalendar(_key);	
	            _data.push(_key+"="+encodeURIComponent(parent.items[arguments[0]].getDhxForm().getInput(_key).value));				
				delete _dhxCalendar; 
			 }			 
         }else if(_itemtype != 'label'){
              var _itemValue = (typeof(_formdata[_key]) == 'undefined')?"":_formdata[_key]; 
              _data.push(_key+"="+encodeURIComponent((_itemValue === null)?"":_itemValue));
         }   
     }

      /** item ?? ???? rendering ?? ??????? ???? */
      _data.push("column-info="+items[arguments[1]].getCellIdAllColumns());
      /** ??? parameter ?? ??????? */
      var customParams = (typeof(arguments[4]) == "object")?arguments[4]:null;
      for(var _key in customParams){
         _data.push(_key+"="+encodeURIComponent(customParams[_key])); 
      }  
      return _data.join("&");
   }
function parameters13 (){
    /** arguments check */
     if(arguments.length < 1 || arguments.length < 2 || arguments.length < 3){
       dhtmlx.alert("function arguments setting not found<br>"+
             "arguments[0] : search form div object id<br>"+
             "arguments[1] : vertical grid(target Grid) div object id<br>"+
             "arguments[2] : service name<br>"+
             "arguments[3] : event name<br>"+
             "arguments[4] : option custom parameter add\n");
       return true;
     }  
    
      /** dhtmlx form item data */
      var _formdata = parent.items[arguments[0]].getDhxForm().getFormData();
      /** parameter array */
      var _data = [];
      /** activity serviceName push */
      _data.push("ServiceName="+arguments[2]);
      _data.push(arguments[3]+"=1");
     
      /** dhtmlx item type ?? ???? key,value ???? calendar?? data?? ??????? ????? ??? */
      for (var _key in _formdata){	
       var _itemtype = parent.items[arguments[0]].getDhxForm().getItemType(_key);
         if(_itemtype == 'radio'){ 
        	 var _radioItem = parent.items[arguments[0]].getDhxForm().getCheckedValue(_key);
         	_data.push(_key+"="+encodeURIComponent(_radioItem)); 
         }else if(_itemtype == 'calendar'){			 
			 if(parent.items[arguments[0]].getDhxForm().getInput(_key).value !== ""){
				 var _dhxCalendar = parent.items[arguments[0]].getDhxForm().getCalendar(_key);	
	            _data.push(_key+"="+encodeURIComponent(parent.items[arguments[0]].getDhxForm().getInput(_key).value));				
				delete _dhxCalendar; 
			 }			 
         }else if(_itemtype != 'label'){
              var _itemValue = (typeof(_formdata[_key]) == 'undefined')?"":_formdata[_key]; 
              _data.push(_key+"="+encodeURIComponent((_itemValue === null)?"":_itemValue));
         }   
     }

      /** item ?? ???? rendering ?? ??????? ???? */
      _data.push("column-info="+items[arguments[1]].getCellIdColumns());
      /** ??? parameter ?? ??????? */
      var customParams = (typeof(arguments[4]) == "object")?arguments[4]:null;
      for(var _key in customParams){
         _data.push(_key+"="+encodeURIComponent(customParams[_key])); 
      }  
      return _data.join("&");
   }/** * 그리드의 셀 데이타 조회 * @param {gridObj}	그리드 명칭 * @param {rowId} 	row index번호 * @param {cellId}  조회할 셀의 index번호 * @returns 선택한 그리드 셀의 값		 */ function getGridCellData(gridObj, rowId, cellId){	if(rowId == null || cellId == null) 		return "";	else		return gridObj.cellById(rowId,gridObj.getColIndexById(cellId)).getValue();}
function parameters14(){ 
	  if(arguments.length < 3){
      dhtmlx.alert("function arguments setting not found<br>"+
             "arguments[0] : parent grid div object id<br>"+
             "arguments[1] : child grid div object id<br>"+
             "arguments[2] : event name<br>"+
			 "arguments[3] : serviceUrl<br>"+
             "arguments[4] : option custom parameter add");
       return true;
     }  
     
      var _data = [];
      _data.push(arguments[3]+"?ServiceName="+items[arguments[1]].getServiceName());
      _data.push(arguments[2]+"=1");
	  
	  if(items[arguments[1]].getColumnInfo())
        _data.push("column-info="+items[arguments[1]].getColumnInfo());
      else
        _data.push("column-info="+items[arguments[1]].getDefaultColumnInfo());
	 
	  if(items[arguments[1]].getBlankRowCntInfo())
		_data.push("blank-row-count="+items[arguments[1]].getBlankRowCntInfo());
	  else
		_data.push("blank-row-count="+items[arguments[1]].getDefaultRowCnt());
	 
	  var params = items[arguments[0]].parentColumnInfo(items[arguments[0]].getSelectedRowId());
      for(var _key in params){
         _data.push(_key+"="+encodeURIComponent(params[_key])); 
      }
      /** 추가 parameter 를 설정하기 */
      var customParams = (typeof(arguments[4]) == "object")?arguments[4]:null;
      for(var _key in customParams){
         _data.push(_key+"="+encodeURIComponent(customParams[_key])); 
      }  
      return _data.join("&");
}

 function varticalParameters (){
    /** arguments check */
     if(arguments.length < 1 || arguments.length < 2 || arguments.length < 3){
       dhtmlx.alert("function arguments setting not found<br>"+
             "arguments[0] : vertical grid(target Grid) div object id<br>"+
             "arguments[1] : service name<br>"+
             "arguments[2] : event name<br>"+
             "arguments[3] : option custom parameter add\n");
       return true;
     }  
    
      /** parameter array */
      var _data = [];
      /** activity serviceName push */
      _data.push("ServiceName="+arguments[1]);
      _data.push(arguments[2]+"=1");
      /** item 에 대한 rendering 을 하기위한 정보 */
      _data.push("column-info="+items[arguments[0]].getCellIdColumns());
      /** 추가 parameter 를 설정하기 */
      var customParams = (typeof(arguments[3]) == "object")?arguments[3]:null;
      for(var _key in customParams){
         _data.push(_key+"="+encodeURIComponent(customParams[_key])); 
      }  
      return _data.join("&");
}


 function varticalParameters2 (){
    /** arguments check */
     if(arguments.length < 1 || arguments.length < 2 || arguments.length < 3){
       dhtmlx.alert("function arguments setting not found<br>"+
             "arguments[0] : vertical grid(target Grid) div object id<br>"+
             "arguments[1] : service name<br>"+
             "arguments[2] : event name<br>"+
             "arguments[3] : option custom parameter add\n");
       return true;
     }  
    
      /** parameter array */
      var _data = [];
      /** activity serviceName push */
      _data.push("ServiceName="+arguments[1]);
      _data.push(arguments[2]+"=1");
      /** item 에 대한 rendering 을 하기위한 정보 */
      _data.push("column-info="+items[arguments[0]].getColumnInfo());
      /** 추가 parameter 를 설정하기 */
      var customParams = (typeof(arguments[3]) == "object")?arguments[3]:null;
      for(var _key in customParams){
         _data.push(_key+"="+encodeURIComponent(customParams[_key])); 
      }  
      return _data.join("&");
}


function parameters15 () {
     if(arguments.length < 1 || arguments.length < 2 ){
       dhtmlx.alert("function arguments setting not found<br>"+
             "arguments[0] : form div object id<br>"+
             "arguments[1] : event name<br>"+
             "arguments[2] : custom parameters array");
       return true;
     }  
     
      var _data = [];
      _data.push(items[arguments[0]].getServiceUrl()+"?ServiceName="+items[arguments[0]].getServiceName());
      _data.push(arguments[1]+"=1");
      var _formdata = items[arguments[0]].getDhxForm().getFormData();
      var _formParam =[];
      for (var _key in _formdata){	
    	  if(_key !== 'messageBox') 
           _formParam.push(_key);
      }
      _data.push("column-info="+_formParam);

      var customParams = (typeof(arguments[2]) == "object")?arguments[2]:null;
      
      for(var _key in customParams){
         _data.push(_key+"="+encodeURIComponent(customParams[_key])); 
      }  
      return _data.join("&");
}


function getDay(curDate, sep){//현재 날짜에서 1달 전 날짜를 리턴
	var curDate = uiCommon.getCurrentDate();
	var temp = curDate.split(sep);
	var t_day = new Date(parseInt(temp[0], 10), parseInt(temp[1]-2, 10), parseInt(temp[2], 10));
	return t_day;
}
function get_DateTypeDay(itm){
	if(!isNaN(itm)){// 숫자만 입력했을때
		return itm.substring(0, 4) + '-' + itm.substring(4, 6) + '-' + itm.substring(6, 8);
	}
	else if(itm.substring(4, 5) == '-' && itm.substring(7, 8) != '-'){// YYYY-MMDD 형식일때
		return itm.substring(0, 4) + '-' + itm.substring(5, 7) + '-' + itm.substring(7, 9);
	}
	else if(itm.substring(6, 7) == '-' && itm.substring(4, 5) != '-'){// YYYYMM-DD 형식일때
		return itm = itm.substring(0, 4) + '-' + itm.substring(4, 6) + '-' + itm.substring(7, 9);
	}
	return itm; // YYYY-MM-DD 형식일 때
}
function isValidNumber(id, value){//숫자인지 체크하는함수
	if(value.match(/^\d.+$/ig) == null){
		return false;
	}else{
		return true;
	}
}
/**
*@author 이민균
*@since 2012.01.16
*@deprecated  checkLength 계산
*@param input(checkLength 계산할 값, input name, maxLength)
*@return length(string size)
*/
function checkLength (str, name, nMax) {
	var nStrSize = getSize(str);
		
	if (nStrSize != nMax)  {
		alert( name + " 는 " + nMax + "자로 입력해 주십시요.\n현재 입력된 길이 : " + nStrSize + "자 입니다.");
		return false;
	}
	return true;
}


/**
*@author 이민균
*@since 2012.01.16
*@deprecated  string size 계산(영문,한글에 따른 길이 체크)
*@param input(string size 계산할 값)
*@return length(string size)
*/
function getSize (str) {
	var i;
	var len = 0;
	
	for ( i=0 ; i<str.length; i++) {
		if ( str.charCodeAt(i) > 255 )  len += 2;
		else  len ++;
	}
	return len; 
}

/**
*@author 이민균
*@since 2012.01.16
*@deprecated  number체크
*@param input(number체크할 값)
*@return 숫자일경우 true 숫자가 아닐경우 false
*/
function checkValidNumber(str)  {
    var txtNumber = '' + str;
    if (isNaN(txtNumber)) { 
         alert("숫자만 입력 하세요.");
		 return false;
    }
	return true;
}

/**
*@author 이민균
*@since 2012.01.16
*@deprecated  null체크
*@param input(null값체크할 대상)
*@return null일경우 true null이 아닐경우 false
*/
function isNull(str){
  if(str == null || str == "" || str == "null"){
    return true;
  }
  return false;
}




String.prototype.trim = function(){
  return this.replace( /(^\s*)|(\s*$)/g,"");

}

function getConfirmImage(txt) {
	var c10_confirm_str = "<img src="+window.dhx_globalImgPath+"c10_question.png align='right' width='25' height='25' margin-left:0px;>"+txt;
	return c10_confirm_str;
}

var dayOfMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
function isCompareDate(startDt,endDt) {
	var DtFlag = true;	
	var start_date = deleteFormat(startDt);
	var end_date = deleteFormat(endDt);
	
	if (eval(start_date) > eval(end_date) ){
		alert("종료일이 시작일보다 이전날짜 입니다.");
		DtFlag = false;
	}

	return DtFlag;
}



function checkValid(lsDate, format) {
	if(format == null || format == undefined) format = 'YYYYMMDD';
	var t_date = getDateArray(lsDate, format);
	if(t_date == null){
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}

	var t_year  = t_date[0];
	var t_month = t_date[1];
	var t_day   = t_date[2];
	if(isNull(lsDate)) {
		alert('날짜를 입력해주세요!');
		return false;
	}

	if(!checkDigit(t_year) || !checkDigit(t_month) || !checkDigit(t_day)) {
		alert('날짜는 숫자만 가능합니다.');
		return false;
	}
	
	if (t_year < 1900 || t_year > 2100) {
		alert('날짜가 틀렸습니다. 년도는 1900년에서 2100년까지 입니다.');
		return false;
	}
	
	if (t_month < 1 || t_month > 12) {
		alert('날짜가 틀렸습니다. 달은 1월에서 12월까지 입니다.');
		return false;
	}
	
	if (t_day < 1 || t_day > getLastday(t_year, t_month)) {
		alert('날짜가 틀렸습니다.'+t_month+'월에는 '+t_day+'일이 없습니다.');
		return false;
	}
	
	return true;
}


function deleteFormat(str){
	return str.replace(/(\$|\ |\/|\^|\*|\(|\)|\+|\.|\?|\\|\{|\}|\||\[|\]|-|:)/g,"");
} 


function getDateArray(lsDate, format){
	var tempDate = new String(lsDate);
	var strDate = deleteFormat(tempDate);
	
	var arrDate = new Array();
	if(format == 'YYYYMM'){
		arrDate[0] = parseInt(strDate.substring(0,4),10);
		arrDate[1] = parseInt(strDate.substring(4,6),10);
	}else if(format == 'MMYYYY'){
		arrDate[0] = parseInt(strDate.substring(2,6),10);
		arrDate[1] = parseInt(strDate.substring(0,2),10);
	}else if(format == 'YYYYMMDD'){
		arrDate[0] = parseInt(strDate.substring(0,4),10);
		arrDate[1] = parseInt(strDate.substring(4,6),10);
		arrDate[2] = parseInt(strDate.substring(6,8),10);		
	}else if(format == 'DDMMYYYY'){
		arrDate[0] = parseInt(strDate.substring(4,8),10);
		arrDate[1] = parseInt(strDate.substring(2,4),10);
		arrDate[2] = parseInt(strDate.substring(0,2),10);	
	}else if(format == 'YYYYMMDDHHMM'){
		arrDate[0] = parseInt(strDate.substring(0,4),10);
		arrDate[1] = parseInt(strDate.substring(4,6),10);
		arrDate[2] = parseInt(strDate.substring(6,8),10);		
		arrDate[3] = parseInt(strDate.substring(8,10),10);
		arrDate[4] = parseInt(strDate.substring(10,12),10);
	}else if(format == 'DDMMYYYYHHMMSS'){
		arrDate[0] = parseInt(strDate.substring(4,8),10);
		arrDate[1] = parseInt(strDate.substring(2,4),10);
		arrDate[2] = parseInt(strDate.substring(0,2),10);	
		arrDate[3] = parseInt(strDate.substring(8,10),10);
		arrDate[4] = parseInt(strDate.substring(10,12),10);
		arrDate[5] = parseInt(strDate.substring(12,14),10);
	}else{
		return null;
	}
	return arrDate;
}


function checkDigit(str)  {
	var str = str.toString();
	var ch = '\0';
	var flag = true;
	for (var i = 0, ch = str.charAt(i); (i < str.length) && (flag); ch = str.charAt(++i)) {
		if (ch == '.' || ch == ',' || (ch >= '0' && ch <= '9')) flag = true;
		else flag = false;
	}
	return flag;
}



 function fnc_numberFormat(num){
   var num = String(num);
   var reg = /(\-?\d+)(\d{3})($|\.\d+)/;
   
   if(reg.test(num)){
    return num.replace(reg, function(str, p1,p2,p3){
           return fnc_numberFormat(p1) + "," + p2 + "" + p3;
          }
    );
      } else{
          return num;
      }
 }

 /********************************************************************************
설명 :  숫자 입력 field의 유효성 검사
리턴 :  boolen
인자 :  headName : Head Name
		fieldName : field Name
        formDivObj: formDivObj
        fieldLen : 전체길이
        pridLen  : 소수점의 길이        
*********************************************************************************/
function js_field_qnty_check( headName,fieldName,formDivObj, fieldLen, pridLen, pridMode )
{
	
    var qntyValue = textFieldCodeSpace(items[formDivObj].getItemValue(fieldName));

    var len = qntyValue.length;
    var origIdx = idx = qntyValue.indexOf(".");
    // 소수점 자리수 체크

	if(pridMode == true){
	    if( (len-idx-1) > pridLen && idx != -1 ) {
	        sMsg = headName+' 소수점'+pridLen+'자리까지 입력하세요.';	      
	        alert(sMsg);
			items[formDivObj].setItemValue(fieldName,'');
			items[formDivObj].setItemFocus(fieldName);
	        return false;
	    }
    }else{
    	if(origIdx != -1){ 
	        sMsg = headName+' 숫자로 입력하세요.';
	        alert(sMsg);
			items[formDivObj].setItemValue(fieldName,'');
			items[formDivObj].setItemFocus(fieldName);
	        return false;
    	}
    }

    // 공백인지 체크
    qntyValue = js_Rtrim(qntyValue);
    if( qntyValue == '' ){
        sMsg = headName+' 입력하세요.';        
        alert(sMsg);
		items[formDivObj].setItemValue(fieldName,'');
		items[formDivObj].setItemFocus(fieldName);
        return false;
    }

    // 문자가 있는지 체크
    if( !js_valiDigit( qntyValue, false ) ){
        sMsg = headName+' 숫자로 입력하세요.';        
        alert(sMsg);
        items[formDivObj].setItemValue(fieldName,'');
        items[formDivObj].setItemFocus(fieldName);
        return false;
    }
    // 길이 체크
    sValue = ( origIdx == -1 ) ? qntyValue : qntyValue.substring(0,origIdx);
    if( sValue.length > fieldLen ){
        sMsg = headName+' 길이' +fieldLen+' 넘지 못합니다.';
        alert(sMsg);
        items[formDivObj].setItemValue(fieldName,'');
        items[formDivObj].setItemFocus(fieldName);
        return false;
    }
    return true;
} /********************************************************************************설명 :  숫자 입력 field의 유효성 검사리턴 :  boolen인자 :  headName : Head Name        fieldLen : 전체길이        pridLen  : 소수점의 길이      		pridMode  : 소수점 모드   		value    :  value *********************************************************************************/function c106000050_grid_qnty_check(headName,fieldLen, pridLen, pridMode,value){    var qntyValue = value;    var len = qntyValue.length;    var origIdx = idx = qntyValue.indexOf(".");    // 소수점 자리수 체크	if(pridMode == true){	    if( (len-idx-1) > pridLen && idx != -1 ) {	        sMsg = headName+' 소수점'+pridLen+'자리까지 입력하세요.';	      	        alert(sMsg);	        return false;	    }    }else{    	if(origIdx != -1){ 	        sMsg = headName+' 숫자로 입력하세요.';	        alert(sMsg);	        return false;    	}    }        // 문자가 있는지 체크    if( !js_valiDigit( qntyValue, true ) ){        sMsg = headName+' 숫자로 입력하세요.';                alert(sMsg);        return false;    }    // 길이 체크    sValue = ( origIdx == -1 ) ? qntyValue : qntyValue.substring(0,origIdx);    if( sValue.length > fieldLen ){        sMsg = headName+' 길이' +fieldLen+'을 넘지 못합니다.';        alert(sMsg);        return false;    }    return true;} /********************************************************************************설명 :  일 차이를 계산.리턴 :  문자열.인자 : startDate, endDate *********************************************************************************/function getDiffTime(startDate, endDate)  {    var diff = 0;     var startDateTmp = replaceAll(startDate, ':',''); startDateTmp = replaceAll(startDateTmp, ' ',''); startDateTmp = replaceAll(startDateTmp, '-','');  var start_yyyy = startDateTmp.substring(0,4);    var start_mm = startDateTmp.substring(4,6);    var start_dd = startDateTmp.substring(6,8); var start_hh = startDateTmp.substring(8,10); var start_mi = startDateTmp.substring(10,12);     var sDate = new Date(start_yyyy, start_mm, start_dd,start_hh,start_mi,0);     var endDateTmp = replaceAll(endDate, ':',''); endDateTmp = replaceAll(endDateTmp, ' ',''); endDateTmp = replaceAll(endDateTmp, '-','');      var end_yyyy = endDateTmp.substring(0,4);    var end_mm = endDateTmp.substring(4,6);    var end_dd = endDateTmp.substring(6,8); var end_hh = endDateTmp.substring(8,10); var end_mi = endDateTmp.substring(10,12);     var eDate = new Date(end_yyyy, end_mm, end_dd,end_hh,end_mi,0);      diff = Math.ceil( (eDate.getTime() - sDate.getTime()) / (1000*60) );                return diff;}function replaceAll(sValue, param1, param2) {    return sValue.split(param1).join(param2);}/** * 현재날짜를 YYYY-MM-DD HH24:MI:SS 형태로 표기 * @returns 			 */function getCurrentTimeStamp() {  	var curr_date = new Date();	var curr_time =		addZeros(curr_date.getFullYear(), 4) + '-' +		addZeros(curr_date.getMonth() + 1, 2) + '-' +		addZeros(curr_date.getDate(), 2) + ' ' +				addZeros(curr_date.getHours(), 2) + ':' +		addZeros(curr_date.getMinutes(), 2) + ':' +		addZeros(curr_date.getSeconds(), 2);	return curr_time;}/** * 숫자앞에 자리수만틈 0 더하기 * @param {n} 		0이 더해질 값 * @param {digits} 	0을 포함한 자릿수 * @returns 			 */function addZeros(n, digits) {	var zero = '';	n = n.toString();		if (n.length < digits) {		for (i = 0; i < digits - n.length; i++)			zero += '0';	}	return zero + n;}
/********************************************************************************
설명 :  저장, 수정, 삭제 전에 code의 공백을 제거해 주는 루틴.
리턴 :  문자열.
인자 :  sValue : 값을 replace랄 string
*********************************************************************************/
function textFieldCodeSpace( sValue )
{
	re = / /gi;
	sValue = sValue.replace(re,'');
	return sValue;
}

/****************************************************************
설명 :  문자의 뒤의 공백을 지운다.
리턴 :  문자열.
인자 :  sValue : 공백을 제거할 string
****************************************************************/
function js_Rtrim( sValue )     // "aadfasdf   "
{
    idx = sValue.lastIndexOf(" ");
    while( idx > -1 ){          // 뒤의 공백을 지운다.
        if( idx < sValue.length-1 ) break;
        else{
            sValue = sValue.substring(0,idx);
            idx = sValue.lastIndexOf(" ");
        }
    }
    return sValue;
}


/********************************************************************************
설명 :  문자열이 숫자인지 체크한다. 콤마(.)는 무시. 쉼표(,)는 에러
리턴 :  boolen
인자 :  number : 문자열
        flag   : true : 제일 앞자리 -(마이너스)는 허용..
                 false : -는 허용하지 않음.
*********************************************************************************/
function js_valiDigit(number, flag)
{
    for (var i = 0; i < number.length; i++) {
        aChar = number.charAt(i);
        if( flag && i == 0) {
            if ((aChar < '0' || aChar > '9') && (aChar != '-')) return false;
        }
        else {
            if ((aChar < '0' || aChar > '9') &&  aChar != '.') return false;
        }
    }
    return true;
}
function formParameter(formDivObj){	
	var _formdata = formDivObj.getFormData();     
	var _data = [];
	/** dhtmlx item type 에 대한 key,value 추출 calendar는 data를 추출하는 방법이 다름 */
	for (var _key in _formdata){	
		var _itemtype = formDivObj.getItemType(_key);
		if(_itemtype == 'radio'){ 
			var _radioItem = formDivObj.getCheckedValue(_key);
			_data.push(_key+"="+encodeURIComponent(_radioItem)); 
		}else if(_itemtype == 'calendar'){			 
			if(formDivObj.getInput(_key).value !== ""){
				var _dhxCalendar = formDivObj.getCalendar(_key);	
				_data.push(_key+"="+encodeURIComponent(formDivObj.getInput(_key).value));				
				delete _dhxCalendar; 
			}			 
		}else if(_itemtype != 'label'){
			var _itemValue = (typeof(_formdata[_key]) == 'undefined')?"":_formdata[_key]; 
			_data.push(_key+"="+encodeURIComponent((_itemValue === null)?"":_itemValue));
		}   
	}
	return _data.join("&");
}
function sort_str_custom(a,b,order){
	var n=a.toString().toLowerCase();
	var m=b.toString().toLowerCase();  
	if(n != "" && m != ""){
		if(order=="asc"){
			return (n>m) ?1:-1;
		}
		else{
			return (n<m) ?1:-1;
		}
	}
}




function sort_int_custom(a,b,order){
	var n=a.toString().toLowerCase();
	var m=b.toString().toLowerCase();  
    floatA = parseFloat(a);
	floatB = parseFloat(b);
	if(n != "" && m != ""){
		if(order=="asc"){
			return (floatA > floatB) ?1:-1;
		}
		else{
			return (floatA < floatB) ?1:-1;
		}
	}
}



function sort_date_custom(a,b,order){
	var n=a.toString().toLowerCase();
	var m=b.toString().toLowerCase();  
    dateA = deleteFormat(a);
	dateB = deleteFormat(b);
	if(n != "" && m != ""){
		if(order=="asc"){
			return (dateA > dateB) ?1:-1; 
		}
		else{
			return  (dateA < dateB) ?1:-1; 
		}
	}
}


function backspaceOff(formDivId){
	var formDivObj = items[formDivId].getDhxForm();
	var _formdata = formDivObj.getFormData();     
	for (var _key in _formdata){			
		var _itemtype = formDivObj.getItemType(_key);
		if(_itemtype == 'calendar'){
			if(formDivObj.isReadonly(_key)){
				_formdata[_key].onkeydown = function(e){
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
			}
		}
		else if(_itemtype == 'input'){
			if(formDivObj.isReadonly(_key)){
				formDivObj.getInput(_key).onkeydown = function(e){
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
			}
		}			
	}
}


function calculateDay(fromDate,toDate,sep) {//한달인지 체크하기 위한 함수 -두 날짜의 차를 리턴.
	var t_day1, t_day2, re_value;
	var temp = fromDate.split(sep);
	var t_day1 = new Date(parseInt(temp[0],10), parseInt(temp[1]-1,10), parseInt(temp[2],10));
	t_day1 = t_day1.getTime();
	
	temp = toDate.split(sep);
	var t_day2 = new Date(parseInt(temp[0],10), parseInt(temp[1]-1,10), parseInt(temp[2],10));
	
	t_day2 = t_day2.getTime();
	
	re_value = Math.floor( (t_day2 - t_day1) / (60*60*24*1000) );
	return re_value;
}

/*
 *  현재 달의 첫일 구하는 스크립트.
 */
function firstDay() {
     var firstDay = new Date();  // 현재달의 시작 일
     firstDay.setDate(1);
     var firstDayVal = firstDay.getFullYear()+"-"+("0"+(firstDay.getMonth()+1)).substr(("0"+(firstDay.getMonth()+1)).length-2,2)+"-"+("0"+firstDay.getDate()).substr(("0"+firstDay.getDate()).length-2, 2);
	 return firstDayVal;
}

/*
 *  현재 달의 마지막일 구하는 스크립트.
 */
function lastDay() {
     var firstDay = new Date();  // 현재달의 시작 일
     var lastDay = new Date(firstDay.getTime());  // 현재달의 마지막 일
     lastDay.setMonth(lastDay.getMonth()+1);
     lastDay.setDate(0);

    // var firstDayVal = firstDay.getFullYear()+"-"+("0"+(firstDay.getMonth()+1)).substr(("0"+(firstDay.getMonth()+1)).length-2,2)+"-"+("0"+firstDay.getDate()).substr(("0"+firstDay.getDate()).length-2, 2);
     var lastDayVal = lastDay.getFullYear()+"-"+("0"+(lastDay.getMonth()+1)).substr(("0"+(lastDay.getMonth()+1)).
          length-2, 2)+"-"+("0"+lastDay.getDate()).substr(("0"+lastDay.getDate()).length-2, 2);
     return lastDayVal;


}

/*dhtmlx grid*/
function checkLimitByte(gridObj, len){
	gridObj.editor.obj.onkeyup = function(e){
		e = e||window.event;
		if((e.keyCode >= 47) || (e.keyCode == 0)){
			var text = this.value;
			if(getByte(text) >= len){
				return false;
			}
		}
	}
}

function getByte(data) {
    var total = 0;
    for (var i = 0; i < data.length; i++) {
        var c = escape(data.charAt(i));
        if(c.length == 1){	
            total++;
        }else if(c.indexOf("%u") != -1){
            total += 2;
        }else if(c.indexOf("%") != -1){
            total += c.length/3;
        }
    }
    return total;
}


 /********************************************************************************
설명 :  숫자 입력 field의 유효성 검사
리턴 :  boolen
인자 :  headName : Head Name
        fieldLen : 전체길이
        pridLen  : 소수점의 길이      
		pridMode  : 소수점 모드   
		value    :  value 
*********************************************************************************/
function grid_qnty_check(headName,fieldLen, pridLen, pridMode,value)
{
    var qntyValue = value;

    var len = qntyValue.length;
    var origIdx = idx = qntyValue.indexOf(".");
    // 소수점 자리수 체크

	if(pridMode == true){
	    if( (len-idx-1) > pridLen && idx != -1 ) {
	        sMsg = headName+' 소수점'+pridLen+'자리까지 입력하세요.';	      
	        alert(sMsg);
	        return false;
	    }
    }else{
    	if(origIdx != -1){ 
	        sMsg = headName+' 숫자로 입력하세요.';
	        alert(sMsg);
	        return false;
    	}
    }    

    // 문자가 있는지 체크
    if( !js_valiDigit( qntyValue, false ) ){
        sMsg = headName+' 숫자로 입력하세요.';        
        alert(sMsg);
        return false;
    }
    // 길이 체크
    sValue = ( origIdx == -1 ) ? qntyValue : qntyValue.substring(0,origIdx);
    if( sValue.length > fieldLen ){
        sMsg = headName+' 길이' +fieldLen+'을 넘지 못합니다.';
        alert(sMsg);
        return false;
    }
    return true;
} 


/**
 * 한글, 영문, 숫자 혼용시 자릿수 체크
 * @param {val} 	입력값
 * @param {max} 	maxlength
 * @returns 			
 */
function hanCheck(val,max){
	var sum = 0, cal_sum=0;
	if(val != ""){
		for(i=0;i<val.length;i++) {
			ch = escape(val.charAt(i));        
			if (strCharByte2(ch) == 2){
				sum += 3;
				cal_sum = Math.floor(sum /3);
			}else{
				sum += 1;
				cal_sum = sum ;
			}
		}
		if(sum > max){
			return false;
		}
	}
	return true;
}

/**
 * 입력된 값이 한글인지 여부 체크
 * @param {chStr} 	입력값
 * @returns 			
 */
function strCharByte2(chStr){
    if (chStr.substring(0, 2) == '%u'){
        if (chStr.substring(2,4) == '00')
        	return 1;
        else
        	return 2;        //한글
    } else if (chStr.substring(0,1) == '%') {
        if (parseInt(chStr.substring(1,3), 16) > 127)
        	return 2;        //한글
        else
        	return 1;
    } else {
    	return 1;
    }
}


function getFirstDate(date, sep)
{
	var temp = date.split(sep);
	var t_day = new Date(parseInt(temp[0], 10), parseInt(temp[1]-1, 10), parseInt(temp[2], 10));
	
	temp[0] = t_day.getFullYear();
	temp[1] = t_day.getMonth()+1;
	temp[2] = '01';
	
	var result_day = temp.join('-');
	return result_day;
}


//입력한 년,월의 마지막 일자을 구하는 Function
// 1. calyear (String) 'YYYY'형태의 년도
// 2. calmonth (String) 'MM'형태의 월
function getLastday(calyear,calmonth) {
	if (((calyear % 4 == 0) && (calyear % 100 != 0))||(calyear % 400 == 0)) dayOfMonth[1] = 29;
	
	var nDays = dayOfMonth[calmonth-1];
	return nDays;
}


//현재 년,월의 마지막 일자을 구하는 Function
function getCurrentLastday() {
	var date = uiCommon.getCurrentDate();
	var temp = date.split("-");
	var t_day = new Date(parseInt(temp[0], 10), parseInt(temp[1]-1, 10), parseInt(temp[2], 10));
	temp[0] = t_day.getFullYear();
	temp[1] = t_day.getMonth()+1;
	if ( temp[1] < 10) {
		temp[1] = "0"+temp[1];
	}
	if (((temp[0] % 4 == 0) && (temp[0] % 100 != 0))||(temp[0] % 400 == 0)) dayOfMonth[1] = 29;
	temp[2] = dayOfMonth[temp[1]-1];
	var result_day = temp.join('-');
	return result_day;
}

//현재 년,월의 첫 일자을 구하는 Function
function getCurrentFirstDate()
{
	var date = uiCommon.getCurrentDate();
	var temp = date.split("-");
	var t_day = new Date(parseInt(temp[0], 10), parseInt(temp[1]-1, 10), parseInt(temp[2], 10));	
	temp[0] = t_day.getFullYear();
	temp[1] = t_day.getMonth()+1;
	temp[2] = '01';	
	var result_day = temp.join('-');
	return result_day;
}

function getCurrentAddMinusDay(sep,plusDay,minusDay) {
	var today = new Date();
	var t_year = today.getFullYear();
	var t_mon  = today.getMonth()+1;
	var t_day  = "";
	if(isNull(plusDay)){
		t_day  = today.getDate() - minusDay;
	}else if(isNull(minusDay)){
		t_day  = today.getDate() + plusDay;	
	}else{
		t_day  = today.getDate();
	}
		
	if(t_mon.toString().length == 1)  t_mon = "0" + t_mon;
	if(t_day.toString().length == 1)  t_day = "0" + t_day;
	
   	return ""+t_year+sep+t_mon+sep+t_day;

}


function getCurrentMinitesTime() {
	var today = new Date();
	var t_year = today.getFullYear();
	var t_mon  = today.getMonth()+1;
	var t_day  = today.getDate();
	var t_hour = today.getHours();
	var t_min  = today.getMinutes();
	var sep = '-';
	
	if(t_mon.toString().length == 1)  t_mon = "0" + t_mon;
	if(t_day.toString().length == 1)  t_day = "0" + t_day;
	if((""+t_hour).toString().length == 1) t_hour = "0" + t_hour;
	if((""+t_min).toString().length == 1)  t_min = "0" + t_min;
	
   	return ""+t_year+sep+t_mon+sep+t_day+" "+t_hour+":"+t_min;
}



function getCurrentMinusDay(sep,minusDay,format) {
	var today = new Date();
	var t_year = today.getFullYear();
	var t_mon  = today.getMonth()+1;
	var t_day  = today.getDate() - minusDay;
	var t_hour = today.getHours();
	var t_min  = today.getMinutes();
	var t_sec  = today.getSeconds();
	
	
	if(t_mon.toString().length == 1)  t_mon = "0" + t_mon;
	if(t_day.toString().length == 1)  t_day = "0" + t_day;
	if((""+t_hour).toString().length == 1) t_hour = "0" + t_hour;
	if((""+t_min).toString().length == 1)  t_min = "0" + t_min;
	if((""+t_sec).toString().length == 1)  t_sec = "0" + t_sec;
	
	if(format == null || format == undefined || format == 'YYYYMMDDHHMISS'){
    	return ""+t_year+sep+t_mon+sep+t_day+" "+t_hour+":"+t_min+":"+t_sec;
    }else{
		return ""+t_year+sep+t_mon+sep+t_day;
	}
}



/**
 * @class DHTMLX Grid Cell link Type Custom Function  
 * @constructor
 * @param {object} Grid cell object ( excell name is defined here )
 * @see http://docs.dhtmlx.com/doku.php?id=dhtmlxgrid:toc_custom_excell_creation
 */ 
function eXcell_ahref_idx(cell){       
  /** default pattern, just copy it */
	if (cell){                                                     
		this.cell = cell;
		this.grid = this.cell.parentNode.grid;
	}
	this.setValue=function(val){
	  /** get related row id */
		var row_id=this.cell.parentNode.idd; 
		  var cell_idx = this.cell._cellIndex;	
		  this.setCValue("<a href='javascript:void(0)' onclick='Grid_doLink(\""+val+"\",\""+row_id+"\",\""+cell_idx+"\")' onFocus='blur()'>"+val+"</a>",val);                                      
		},
    this.getValue=function(){
		 return this.cell.childNodes[0].innerHTML; // get value
	};
}/** nest all other methods from base class */eXcell_ahref_idx.prototype = new eXcell;  
//form input item backspace event 방지 이벤트호출
function readOnlyItemBackEvent(formId){    
	var formdata = items[formId].getDhxForm().getFormData(); 
  	
	for (var key in formdata){	
		var itemtype = items[formId].getDhxForm().getItemType(key);
		if(itemtype == 'input'){
			var inputObj = items[formId].getDhxForm().getInput(key);
			backSpaceBlockEvent(inputObj);
 		}
	}    
}
//inputBox backspace event 방지 이벤트
function backSpaceBlockEvent(inputObj){
	inputObj.onkeydown = function(e){
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
}
parametersC10 = function(){ 
	if(arguments.length < 1 || arguments.length < 2 || arguments.length < 3){
     	alert("function arguments setting not found<br>"+
           "arguments[0] : grid div object id<br>"+
           "arguments[1] : event name<br>"+
           "arguments[2] : option custom parameter add");
     	return true;
	}  
	
    var _data = [];
    _data.push(items[arguments[0]].getServiceUrl()+"?ServiceName="+items[arguments[0]].getServiceName());
    _data.push(arguments[1]+"=1");        
   
    _data.push("column-info="+items[arguments[0]].getColumnInfo());
    var customParams = (typeof(arguments[2]) == "object")?arguments[2]:null;

	for(var _key in customParams){
	 	_data.push(_key+"="+encodeURIComponent(customParams[_key])); 
	}  
	return _data.join("&");
}


function eXcell_ed(cell){
	if (cell){
		this.cell=cell;
		this.grid=this.cell.parentNode.grid;
	}
	this.edit=function(){
		this.cell.atag=((!this.grid.multiLine)&&(_isKHTML||_isMacOS||_isFF)) ? "INPUT" : "TEXTAREA";
		this.val=this.getValue();
		this.obj=document.createElement(this.cell.atag);
		this.obj.setAttribute("autocomplete", "off");
		this.obj.style.height=(this.cell.offsetHeight-(_isIE ? 4 : 4))+"px";
		this.obj.className="dhx_combo_edit";
		this.obj.wrap="soft";
		this.obj.style.textAlign=this.cell.style.textAlign;
		this.obj.onclick=function(e){
			(e||event).cancelBubble=true
		}
		this.obj.onmousedown=function(e){
			(e||event).cancelBubble=true
		}
		this.obj.onkeydown=function(e){
			var ev = (e||event);
			if (ev.keyCode == 9|| ev.keyCode == 13){				
				globalActiveDHTMLGridObject.entBox.focus();
				globalActiveDHTMLGridObject.doKey({
					keyCode: ev.keyCode,
					shiftKey: ev.shiftKey,
					srcElement: "0"
					});

				return false;
			}
		}

		this.obj.value=this.val
		this.cell.innerHTML="";
		this.cell.appendChild(this.obj);

		if (_isFF && !window._KHTMLrv){
			this.obj.style.overflow="visible";

			if ((this.grid.multiLine)&&(this.obj.offsetHeight >= 18)&&(this.obj.offsetHeight < 40)){
				this.obj.style.height="36px";
				this.obj.style.overflow="scroll";
			}
		}
		this.obj.onselectstart=function(e){
			if (!e)
				e=event;
			e.cancelBubble=true;
			return true;
		};
		if (_isIE)
		    this.obj.focus();
		this.obj.focus()
	}
	this.getValue=function(){
		if ((this.cell.firstChild)&&((this.cell.atag)&&(this.cell.firstChild.tagName == this.cell.atag)))
			return this.cell.firstChild.value;

		if (this.cell._clearCell)
			return "";

		return this.cell.innerHTML.toString()._dhx_trim();
	}

	this.detach=function(){
		this.setValue(this.obj.value);
		return this.val != this.getValue();
	}
}
eXcell_ed.prototype=new eXcell;

function parametersC11 (){ 
	if(arguments.length < 1 || arguments.length < 2 || arguments.length < 3){
     	alert("function arguments setting not found<br>"+
           "arguments[0] : service url<br>"+
           "arguments[1] : grid div object id<br>"+
           "arguments[2] : event name<br>"+
           "arguments[3] : option custom parameter add");
     	return true;
	}  
	
    var _data = [];
    _data.push(arguments[0]+"?ServiceName="+items[arguments[1]].getServiceName());
    _data.push(arguments[2]+"=1");        
   
    _data.push("column-info="+items[arguments[1]].getColumnInfo());
	_data.push("blank-row-count="+items[arguments[1]].getBlankRowCntInfo());
			
	if(items[arguments[1]].getColumnInfo())
        _data.push("column-info="+items[arguments[1]].getColumnInfo());
	else
		_data.push("column-info="+items[arguments[1]].getDefaultColumnInfo());

	if(items[arguments[1]].getBlankRowCntInfo())
		_data.push("blank-row-count="+items[arguments[1]].getBlankRowCntInfo());
	else
		_data.push("blank-row-count="+items[arguments[1]].getDefaultRowCnt());
	  
    var customParams = (typeof(arguments[3]) == "object")?arguments[3]:null;

	for(var _key in customParams){
	 	_data.push(_key+"="+encodeURIComponent(customParams[_key])); 
	}  
	return _data.join("&");
}

function eXcell_edn(cell){
	if (cell){
		this.cell=cell;
		this.grid=this.cell.parentNode.grid;
	}	

	this.getValue=function(){
		//this.grid.editStop();
		if ((this.cell.firstChild)&&(this.cell.firstChild.tagName == "TEXTAREA"))
			return this.cell.firstChild.value;

		if (this.cell._clearCell)
			return "";

		return this.cell._orig_value||this.grid._aplNFb(this.cell.innerHTML.toString()._dhx_trim(), this.cell._cellIndex);
	}

	this.detach=function(){
		var tv = this.obj.value;
		this.setValue(tv);
		return this.val != this.getValue();
	}
}
eXcell_edn.prototype=new eXcell_ed;
eXcell_edn.prototype.setValue=function(val){ 
	if (!val||val.toString()._dhx_trim() == ""){
		this.cell._clearCell=true;
		return this.setCValue("&nbsp;",0);
	} else {
		this.cell._clearCell=false;
		this.cell._orig_value = val;
	}
	this.setCValue(this.grid._aplNF(val, this.cell._cellIndex), val);
}/** * 공백제거 * @param str * @returns */function C10_trim(str) { 	var search = 0 	str = new String(str);	while ( str.charAt(search) == " ") search = search + 1 		str = str.substring(search, (str.length)) 	search = str.length - 1 		while (str.charAt(search) ==" ") search = search - 1 		return str.substring(0, search + 1)}/** * @class DHTMLX Grid Cell link Type Custom Function   * @constructor * @param {object} Grid cell object ( excell name is defined here ) * @see http://docs.dhtmlx.com/doku.php?id=dhtmlxgrid:toc_custom_excell_creation */ function eXcell_calendarC(cell){    if (cell){        this.cell = cell;        this.grid = this.cell.parentNode.grid;    }    this.inputId = this.grid.columnIds[this.cell._cellIndex];    this.tempValue;       this.edit=function(){   	this.val = this.getValue().replace("&nbsp;","");       	if(this.val == ''){    	var today  = new Date();   	 var year  = today.getFullYear();   	 var month  = today.getMonth() + 1 ;  	 var day  = today.getDate();  	 var hours = today.getHours();  	 var minutes = today.getMinutes();  	 if(month < 10 ) month =  "0".concat(month);  	 if(day < 10 )  day   =  "0".concat(day);  	 if(hours < 10 )  hours   =  "0".concat(hours);  	 if(minutes < 10 )  minutes   =  "0".concat(minutes);   	   if(this.grid._dtmask == 'YYYYMMDD'){   	     this.val = year + "-" + month + "-" + day;    	   }else if(this.grid._dtmask == 'YYYYMMDDHHMI'){    	     this.val = year + "-" + month + "-" + day + " " + hours + ":" + minutes;    	   }else if(this.grid._dtmask == 'YYYYMMDDHHMISS'){   	     this.val = year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":00";    	   }   	     	}    	this.cell.innerHTML="<input id='"+this.inputId+"' style='background-color:#FFFFC0; border:#A4BED4 1px solid' size='13' type='text' value='"+this.val+"' />&nbsp;<img src=/dhtmlx/codebase/imgs/btnic_calendar.gif style='cursor:pointer;' align='absmiddle' onclick='(new eXcell_calendarC(this.parentNode)).openCalendar();(arguments[0]||event).cancelBubble=true;'/>";     		if(this.grid._dtmask == 'YYYYMMDD'){  		  var cellValue = this.cell.childNodes[0].value.substring(0,10);    		if(_isIE)    		  this.cell.childNodes[0].value= cellValue.split("-").join("");    		else    		  this.cell.childNodes[0].value= cellValue.replace(new RegExp("-", "gi"), "");  	  }else if((this.grid._dtmask == 'YYYYMMDDHHMI') || (this.grid._dtmask == 'YYYYMMDDHHMISS')){  	    var cellValue = this.cell.childNodes[0].value.substring(0,16);  	    if(_isIE){  		    this.cell.childNodes[0].value= cellValue.split("-").join("");  		    this.cell.childNodes[0].value= this.cell.childNodes[0].value.split(":").join("");  		    this.cell.childNodes[0].value= this.cell.childNodes[0].value.split(" ").join("");  		  }else{  		    this.cell.childNodes[0].value= cellValue.replace(new RegExp("-", "gi"), "");  		    this.cell.childNodes[0].value= this.cell.childNodes[0].value.replace(new RegExp(":", "gi"), "");  		    this.cell.childNodes[0].value= this.cell.childNodes[0].value.replace(new RegExp(" ", "gi"), "");  	    }  	  }   	  tempValue = this.cell.childNodes[0].value;  		if(this.grid._dtmask == 'YYYYMMDD'){  		  this.cell.childNodes[0].setAttribute('maxlength',8);  		}else if((this.grid._dtmask == 'YYYYMMDDHHMI') || (this.grid._dtmask == 'YYYYMMDDHHMISS')){  		  this.cell.childNodes[0].setAttribute('maxlength',12);  		}  		    		this.cell.childNodes[0].onclick=function(e){(e||event).cancelBubble=true; }   		this.cell.childNodes[0].onmousedown=function(e){(e||event).cancelBubble=true;}		  this.cell.childNodes[0].onkeydown=function(e){  		  var ev = (e||event);   		  if(ev.keyCode !=8 && ev.keyCode !=37 && ev.keyCode !=39 && (ev.keyCode < 48 || ev.keyCode > 57)&& (ev.keyCode < 96 || ev.keyCode > 105)){  		    if(!!(ev.ctrlKey && ev.keyCode == 67) || !!(ev.ctrlKey && ev.keyCode == 86))  		     return true;  		    else   		     return false;    		  }   		}    		  		if (_isIE)  		  this.cell.childNodes[0].focus();  	    this.cell.childNodes[0].focus()        var valLen = this.cell.childNodes[0].getAttribute('maxlength');  	    this.cell.childNodes[0].setSelectionRange(valLen,valLen);		}		  this.openCalendar=function(){ 	    var arPos = this.grid.getPosition(this.cell);		    	var calPosHeight=parseInt(arPos[1])+408;		  if(this.grid.entBox.clientWidth < arPos[0]+358){			arPos[0] = arPos[0]*1 + this.cell.offsetWidth - 358;		  }else{			arPos[0] = arPos[0]*1;  		  }		  if(this.grid.entBox.clientHeight < arPos[1]+98){			arPos[1] = arPos[1]*1 - 193;		  }else{			arPos[1] = arPos[1]*1 + this.cell.offsetHeight;  		  }    	  /*if(document.documentElement.clientHeight < calPosHeight)    	  arPos[1] = arPos[1]*1 - (this.cell.offsetHeight+7);    	  else    	  arPos[1] = arPos[1]*1 + (this.cell.offsetHeight);		   */    	  if(this.grid._dtmask == 'YYYYMMDD'){       	  NewCssCal(this.inputId,this.grid._dtmask,'arrow',false,'24',false,false,arPos);    	  }else if((this.grid._dtmask == 'YYYYMMDDHHMI') || (this.grid._dtmask == 'YYYYMMDDHHMISS')){			    NewCssCal(this.inputId,this.grid._dtmask.substring(0,8),'arrow',true,'24',false,false,arPos);    	  }           return false;    	}     this.setValue=function(val){      this.setCValue(val);                                         }    this.getValue=function(){      return this.cell.innerHTML; // get value    }   	this.detach=function(){   	   //format 설정       	   var dateArray = new Array();  	   var dateValue;  	   var editFlag = true;  	   if(this.grid._dtmask == 'YYYYMMDD'){  	     if(this.cell.childNodes[0].value.length != 8){  	      this.cell.childNodes[0].value = tempValue;    	      editFlag = false;  	     }   	   }else if((this.grid._dtmask == 'YYYYMMDDHHMI') || (this.grid._dtmask == 'YYYYMMDDHHMISS')){  	     if(this.cell.childNodes[0].value.length != 12){   	      this.cell.childNodes[0].value = tempValue;     	      editFlag = false;   	     }    	   }  	   if(this.grid._dtmask == 'YYYYMMDD'){  	     dateArray.push(this.cell.childNodes[0].value.substring(0,4));   	     dateArray.push(this.cell.childNodes[0].value.substring(4,6));   	     dateArray.push(this.cell.childNodes[0].value.substring(6,8));   	     dateValue = dateArray.join("-");  	   }else if(this.grid._dtmask == 'YYYYMMDDHHMI'){  	     dateArray.push(this.cell.childNodes[0].value.substring(0,4));   	     dateArray.push(this.cell.childNodes[0].value.substring(4,6));   	     dateArray.push(this.cell.childNodes[0].value.substring(6,8));   	     dateValue = dateArray.join("-")+" "+this.cell.childNodes[0].value.substring(8,10)+":"+ this.cell.childNodes[0].value.substring(10,12);   	   }else if(this.grid._dtmask == 'YYYYMMDDHHMISS'){  	     dateArray.push(this.cell.childNodes[0].value.substring(0,4));   	     dateArray.push(this.cell.childNodes[0].value.substring(4,6));   	     dateArray.push(this.cell.childNodes[0].value.substring(6,8));   	     dateValue = dateArray.join("-")+" "+this.cell.childNodes[0].value.substring(8,10)+":"+ this.cell.childNodes[0].value.substring(10,12)+":00";   	   }    	    if(editFlag){  	      var dt=null;          var monthDayArray = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);  	      if(this.grid._dtmask == 'YYYYMMDD'){            dt = dateValue.toString().match(/^(\d{4})-(\d{2})-(\d{2})$/);  		      if((dt[1] % 4) === 0){ 	           	  if((dt[1] % 100 === 0) && (dt[1] % 400) !== 0){		             	 monthDayArray[1] = 28                }else{			             monthDayArray[1] = 29;		            }	            }else{		               monthDayArray[1] = 28	            }  		       checkValue = monthDayArray[eval(dt[2])-1];  		          		      if(!(dt && !!(dt[1]<=9999 && dt[2]<=12 && dt[3]<=checkValue))|| false){  		        if(dhtmlx.alert) 		          dhtmlx.alert("Invalid Date");  		        dateValue = this.val;  		      }  	      }else if(this.grid._dtmask == 'YYYYMMDDHHMI'){  	        dt = dateValue.toString().match(/^(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2})$/);  	         if((dt[1] % 4) === 0){ 	           	if ((dt[1] % 100 === 0) && (dt[1] % 400) !== 0){		             	 monthDayArray[1] = 28               }else{			             monthDayArray[1] = 29;		            }	         }else{		               monthDayArray[1] = 28	         }  		     checkValue = monthDayArray[eval(dt[2])-1]; 		     if(!(dt && !!(dt[1]<=9999 && dt[2]<=12 && dt[3]<=checkValue && dt[4]<=59 && dt[5]<=59)) || false){ 		         if(dhtmlx.alert) 		         dhtmlx.alert("Invalid Date");  		        dateValue = this.val;  		     }    	      }else if(this.grid._dtmask == 'YYYYMMDDHHMISS'){  	        var temp = dateValue.substring(0,16);  	        dt = temp.toString().match(/^(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2})$/);  	        if((dt[1] % 4) === 0){ 	           	  if ((dt[1] % 100 === 0) && (dt[1] % 400) !== 0){		             	 monthDayArray[1] = 28                }else{			             monthDayArray[1] = 29;		            }	            }else{		               monthDayArray[1] = 28	           }  		       checkValue = monthDayArray[eval(dt[2])-1]; 		        if(!(dt && !!(dt[1]<=9999 && dt[2]<=12 && dt[3]<=checkValue && dt[4]<=59 && dt[5]<=59)) || false){ 		          dhtmlx.alert("Invalid Date");  		        dateValue = this.val;  		        }    	      }  	      this.setValue(dateValue);  	    }else{  	     this.setValue("");  	     return false;  	    }       	 	    if(winCal)	    winCal.style.visibility = 'hidden';	    return this.val != this.getValue();	  }     }eXcell_calendarC.prototype = new eXcell;/**  * @param {object} arguments[0] form div object id * @param {string} arguments[1] grid div object id * @param {string} arguments[2] eventName * @param {string} arguments[3] Service Url	* @param {string} arguments[4] Service Name	* @param {string} arguments[5] option custom parameters array * @example option custom code   * var customparam = {"aaa":"bbbb","cccc":"dddd"}; * var uiGridFindActionUrl = uiCommon.parameters7(SeachFormDivObjId,GridDivObjId,eventName,ServiceUrl,ServiceName,customparam); */function C10_parameters16() {    /** arguments check */	if(arguments.length < 5){	     dhtmlx.alert("function arguments setting not found<br>"+	           "arguments[0] : form div object id<br>"+	           "arguments[1] : grid div object id<br>"+	           "arguments[2] : event name<br>"+	           "arguments[3] : Service Url<br>"+			   "arguments[4] : Service Name<br>"+	           "arguments[5] : custom parameters array\n");	     return true;	}  	 /** parameter array */    var _data = [];    /** activity serviceName push */    _data.push(arguments[3]+"?ServiceName="+arguments[4]);    /** activity event push */    _data.push(arguments[2]+"=1");	/** dhtmlx form item data */    uiCommon.formParameter(_data,items[arguments[0]].getDhxForm());    /** dhtmlx item type 에 대한 key,value 추출 calendar는 data를 추출하는 방법이 다름 */           /** item 에 대한 rendering 을 하기위한 정보 */	   if(items[arguments[1]].getColumnInfo())     _data.push("column-info="+items[arguments[1]].getColumnInfo());   else     _data.push("column-info="+items[arguments[1]].getDefaultColumnInfo());	 	  if(items[arguments[1]].getBlankRowCntInfo())		  _data.push("blank-row-count="+items[arguments[1]].getBlankRowCntInfo());	  else		  _data.push("blank-row-count="+items[arguments[1]].getDefaultRowCnt());		    /** 추가 parameter 를 설정하기 */    var customParams = (typeof(arguments[5]) == "object")?arguments[5]:null;    for(var _key in customParams){       _data.push(_key+"="+encodeURIComponent(customParams[_key]));     }      return _data.join("&");}
