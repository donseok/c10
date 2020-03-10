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
   }
function parameters14(){ 
	  if(arguments.length < 1 || arguments.length < 2 || arguments.length < 3){
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
      _data.push("column-info="+items[arguments[1]].getColumnInfo());
	  _data.push("blank-row-count="+items[arguments[1]].getBlankRowCntInfo());
	 
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
} 
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
	var n=a.length;
	var m=b.length;
	var sortVal = 1;
	if(n != 0 && m != 0){
		if(order=="asc"){
				(n>m)? sortVal=1: sortVal= -1;
		}
		else{
				(n<m)? sortVal=1: sortVal= -1;
		}
	}
	return sortVal;
}

function sort_int_custom(a,b,order){
	var n=a.length;
	var m=b.length;
	var sortVal = 1;
    floatA = parseFloat(a);
	floatB = parseFloat(b);
	if(n != 0 && m != 0){
		if(order=="asc"){
			(floatA > floatB)? sortVal=1: sortVal= -1;
		}
		else{
			(floatA < floatB)? sortVal=1: sortVal= -1;
		}
	}
	return sortVal;
}



function sort_date_custom(a,b,order){
	var n=a.length;
	var m=b.length;
	var sortVal = 1;
    dateA = deleteFormat(a);
	dateB = deleteFormat(b);
	if(n != 0 && m != 0){
		if(order=="asc"){
			(dateA > dateB)? sortVal=1: sortVal= -1;
		}
		else{
			(dateA < dateB)? sortVal=1: sortVal= -1;
		}
	}
	return sortVal;
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
				sum += 2;
				cal_sum = sum /2;
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
}
/** nest all other methods from base class */
eXcell_ahref_idx.prototype = new eXcell;  

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
