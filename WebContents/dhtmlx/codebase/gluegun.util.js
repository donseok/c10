var NUM      = "0123456789";
var SALPHA   = "abcdefghijklmnopqrstuvwxyz";
var ALPHA    = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"+SALPHA;
var TELNO    = "-" + NUM;

var dayOfMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);

function isDigit(obj){
    if(!checkDigit(obj.value)){
        obj.value = "";
        showAlert(Z017);
    }
}

function isTelNo(obj){
    if(!checkType(obj.value,TELNO)){
        obj.value = "";
        showAlert(C147, "phone number");
    }
}
    
function doNumberCheck(e) {
	//if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;
	var key = _isIE ? e.keyCode:e.which;
	var sKey = String.fromCharCode(key);
	var re = new RegExp("[0-9]");
	if(sKey.match(re) == null){
	    if(_isIE) e.returnValue = false;
	    else{
	    	if(key != 8 && key != 0) e.preventDefault();
	    }
	}
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

function checkDigit2(str)  {
    var txtNumber = '' + str;
    if (isNaN(txtNumber)) { 
         alert("숫자만 입력 하세요.");
    }
}

function compareValue (str, str2, sep) {
	if (!checkType(sep, "<>=")) {
		alert("구분자는 '<>='만 허용합니다.");
		return;
	}
	
	str=removeComma(str);
	str2=removeComma(str2);
	
	checkDigit2(str);
	checkDigit2(str2);
	
	if (( sep == "=") && ( eval(str) != eval(str2) )) {
		alert("두 입력값이 다릅니다.");
	}
	
	if (( sep == ">") && ( eval(str) < eval(str2) )) {
		alert("두번째 입력값이 작아야 합니다."); 
	}
	
	if (( sep == "<") && ( eval(str) > eval(str2) )) {
		alert("두번째 입력값이 커야 합니다."); 
	}
}

function calculateValue (str, str2, sep) {
	if (!checkType(sep, "+-*/")) {
		alert("구분자는 '+,-,*,/'만 허용합니다.");
		return;
	} else if ( (sep.length != 1) ) {
		alert("구분자는 1자리만 허용합니다.");
		return;
	}
	
	str=removeComma(str);
	str2=removeComma(str2);
	
	checkDigit2(str);
	checkDigit2(str2);
	
	if ( sep == "+" ) {
		return  eval(str) + eval(str2); 
	} else if ( sep == "-" ) {
		return  eval(str) - eval(str2); 	
	} else if ( sep == "*" ) {
		return  eval(str) * eval(str2); 	
	} else if ( sep == "/" ) {
		return  eval(str) / eval(str2); 	
	}  
}

function setRound(str,len) {
    len=Math.pow(10,len)
    return Math.round(str * len) / len;
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
	}else if(format == 'YYYYMMDDHHMMSS'){
		arrDate[0] = parseInt(strDate.substring(0,4),10);
		arrDate[1] = parseInt(strDate.substring(4,6),10);
		arrDate[2] = parseInt(strDate.substring(6,8),10);		
		arrDate[3] = parseInt(strDate.substring(8,10),10);
		arrDate[4] = parseInt(strDate.substring(10,12),10);
		arrDate[5] = parseInt(strDate.substring(12,14),10);
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

function checkValidDate(lsDate, format) {
	if(format == null || format == undefined) format = 'YYYYMMDD';
	var t_date = getDateArray(lsDate, format);
	if(t_date == null){
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}
	
	var t_year  = t_date[0];
	var t_month = t_date[1];
	var t_day   = t_date[2];
	
	if(!checkDigit(t_year) || !checkDigit(t_month) || !checkDigit(t_day)) {
		alert('날짜는 숫자만 가능합니다.');
		return false;
	}
	
	if (t_year < 1900 || t_year >2100) {
		alert('날짜가 틀렸습니다. 년도는 1900년에서 2100년까지 입니다.');
		return false;
	}
	
	if (t_month <1 || t_month > 12) {
		alert('날짜가 틀렸습니다. 달은 1월에서 12월까지 입니다.');
		return false;
	}
	
	if (t_day <1 || t_day > getLastday(t_year, t_month)) {
		alert('날짜가 틀렸습니다.'+t_month+'월에는 '+t_day+'일이 없습니다.');
		return false;
	}
	return true;
}

function getLastday(calyear,calmonth) {
	if (((calyear % 4 == 0) && (calyear % 100 != 0))||(calyear % 400 == 0)) dayOfMonth[1] = 29;
	
	var nDays = dayOfMonth[calmonth-1];
	return nDays;
}

function checkValidTime(lsDate, format) {
	if(format == null || format == undefined) format = 'YYYYMMDDHHMMSS';
	var t_date = getDateArray(lsDate, format);
	if(t_date == null){
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}

	var t_year  = t_date[0];
	var t_month = t_date[1];
	var t_day   = t_date[2];
	var t_hour  = t_date[3];
	var t_min   = t_date[4];
	var t_second = t_date[5];
	
	if(!checkDigit(t_year) || !checkDigit(t_month) || !checkDigit(t_day) || !checkDigit(t_hour) || !checkDigit(t_min) || !checkDigit(t_second)) {
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
	
	if (t_hour < 0 || t_hour > 24 ) {
		alert('날짜가 틀렸습니다. 시간은 0시부터 24시까지 입니다.');
		return false;
	}
	
	if (t_min < 0 || t_min > 60 ) {
		alert('날짜가 틀렸습니다. 분은 0분부터 60분까지 입니다.');
		return false;
	}
	
	if (t_second < 0 || t_second > 60 ) {
		alert('날짜가 틀렸습니다. 초는 0초부터 60초까지 입니다.');
		return false;
	}
	return true;
}

function checkValidYearMonth(lsDate, format) {
	if(format == null || format == undefined) format = 'YYYYMM';
	var t_date = getDateArray(lsDate, format);
	if(t_date == null){
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}

	var t_year  = t_date[0];
	var t_month = t_date[1];
	
	if(!checkDigit(t_year) || !checkDigit(t_month)) {
		alert('날짜는 숫자만 가능합니다.');
		return false;
	}
	
	if (t_year < 1900 || t_year >2100) {
		alert('날짜가 틀렸습니다. 년도는 1900년에서 2100년까지 입니다.');
		return false;
	}
	
	if (t_month <1 || t_month > 12) {
		alert('날짜가 틀렸습니다. 달은 1월에서 12월까지 입니다.');
		return false;
	}
	
	return true;
}

function getCurrentDate(sep,format) {
	var today = new Date();
	var t_year = today.getFullYear();
	var t_mon  = today.getMonth()+1;
	var t_day  = today.getDate();
	
	if(t_mon.toString().length == 1) t_mon = "0" + t_mon;
	if(t_day.toString().length == 1) t_day = "0" + t_day;
	
	if(format == null || format == undefined || format == 'YYYYMMDD'){
    	return ""+t_year+sep+t_mon+sep+t_day;
    }else if(format == 'DDMMYYYY'){
    	return ""+t_day+sep+t_mon+sep+t_year;
    }
}

function getCurrentTime(sep, format) {
	var today = new Date();
	var t_year = today.getFullYear();
	var t_mon  = today.getMonth()+1;
	var t_day  = today.getDate();
	var t_hour = today.getHours();
	var t_min  = today.getMinutes();
	var t_sec  = today.getSeconds();
	
	
	if(t_mon.toString().length == 1)  t_mon = "0" + t_mon;
	if(t_day.toString().length == 1)  t_day = "0" + t_day;
	if((""+t_hour).toString().length == 1) t_hour = "0" + t_hour;
	if((""+t_min).toString().length == 1)  t_min = "0" + t_min;
	if((""+t_sec).toString().length == 1)  t_sec = "0" + t_sec;
	
	if(format == null || format == undefined || format == 'YYYYMMDD'){
    	return ""+t_year+sep+t_mon+sep+t_day+" "+t_hour+":"+t_min+":"+t_sec;
    }else if(format == 'DDMMYYYY'){
    	return ""+t_day+sep+t_mon+sep+t_year+" "+t_hour+":"+t_min+":"+t_sec;
    }
}

function isFutureDate(lsDate, format) {
	if(format == null || format == undefined) format = 'YYYYMMDD';
	checkValidDate(lsDate, format);

	var t_date = getDateArray(lsDate, format);
	if(t_date == null){
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}

	var t_year  = t_date[0];
	var t_month = t_date[1]-1;
	var t_day   = t_date[2];
	
	var dateObj = new Date(t_year,t_month,t_day);
	return (dateObj > new Date());
}

function isPastDate(lsDate, format) {
	if(format == null || format == undefined) format = 'YYYYMMDD';
	checkValidDate(lsDate, format);

	var t_date = getDateArray(lsDate, format);
	if(t_date == null){
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}

	var t_year  = t_date[0];
	var t_month = t_date[1]-1;
	var t_day   = t_date[2];
	
	var dateObj = new Date(t_year,t_month,t_day);
	return (dateObj < new Date());
}

function isCompareDate(preDate,nextDate, format) {
	if(format == null || format == undefined) format = 'YYYYMMDD';
	
	checkValidDate(preDate, format);
	checkValidDate(nextDate, format);
	
	var pre_date = getDateArray(preDate, format);
	var next_date = getDateArray(nextDate, format);
	
	preDate = pre_date[0]+""+pre_date[1]+""+pre_date[2];
	nextDate = next_date[0]+""+next_date[1]+""+next_date[2];
	
	if (eval(preDate) > eval(nextDate) ) return false;
	return true;
}

function calculateDay(preDate,nextDate,sep, format) {
	if(format == null || format == undefined) format = 'YYYYMMDD';
	
	var t_day1, t_day2, re_value;
	var temp = getDateArray(preDate, format);
	var t_day1 = new Date(parseInt(temp[0],10), parseInt(temp[1]-1,10), parseInt(temp[2],10));

	t_day1 = t_day1.getTime();
	
	temp = getDateArray(nextDate, format);
	var t_day2 = new Date(parseInt(temp[0],10), parseInt(temp[1]-1,10), parseInt(temp[2],10));
	
	t_day2 = t_day2.getTime();
	
	re_value = Math.floor( (t_day2 - t_day1) / (60*60*24*1000) );
	return re_value;
}

function calculateHour(preDate,nextDate,sep,gbn,dis) {
	var Age,t_mon,t_min,t_d,t_h,t_m;
	var t_day1, t_hour1, t_min1, t_day2, t_hour2, t_min2;
	var t_year1, t_mon1, t_year2, t_mon2;
	var re_value;
	var temp = preDate.split(sep);
	
	t_yaer1 = parseInt(temp[0],10);
	t_mon1 = parseInt(temp[1],10)-1;
	t_day1 = parseInt(temp[2].substring(0,2),10);
	t_hour1 = parseInt(temp[2].substring(3,5),10);
	t_min1 = parseInt(temp[2].substring(6,8),10);

	if (t_yaer1 < 1900 || t_yaer1 >2100) {
		alert('날짜가 틀렸습니다. 년도는 1900년에서 2100년까지 입니다.');
		return false;
	}
	
	if (t_mon1 <0 || t_mon1 > 11) {
		alert('날짜가 틀렸습니다. 달은 1월에서 12월까지 입니다.');
		return false;
	}
		
	t_date1 = Date.UTC(t_yaer1,t_mon1,t_day1,t_hour1,t_min1,0);
	
	temp = nextDate.split(sep);
	t_yaer2 = parseInt(temp[0],10);
	t_mon2 = parseInt(temp[1],10)-1;  // script 특성상 달 표시는 0-11 이기 때문에 하나 감함
	t_day2 = parseInt(temp[2].substring(0,2),10);
	t_hour2 = parseInt(temp[2].substring(3,5),10);
	t_min2 = parseInt(temp[2].substring(6,8),10);

	if (t_yaer2 < 1900 || t_yaer2 >2100) {
		alert('날짜가 틀렸습니다. 년도는 1900년에서 2100년까지 입니다.');
		return false;
	}
	
	if (t_mon2 <0 || t_mon2 > 11) {
		alert('날짜가 틀렸습니다. 달은 1월에서 12월까지 입니다.');
		return false;
	}
	t_date2 = Date.UTC(t_yaer2,t_mon2,t_day2,t_hour2,t_min2,0);
	
	Age = t_date2-t_date1;
	//달수(30일 기준)
	t_mon = Math.floor(((Age/1000)/60)/(24*60*30)); 
	t_min = ((Age/1000)/60)%(24*60*30);                   
	
	//달로 기준해서 남은 시간
	t_h = Math.floor(t_min/60); 
	//달로 기준해서 일수계산
	t_d = Math.floor(t_h/24);   
	//계산된 시간
	t_h = t_h%24;
	//계산된 분
	t_m = t_min%60;         	
	//일수계산
	t_d = (t_mon*30)+t_d;		
	
	re_value = "";
	
	if (t_d > 0) {
		if (dis=="D") {
			// 9일 99:99로 Display
			re_value =t_d+"일 ";
		} else {
			// 99:99로 Display
			t_h = t_h + (t_d*24);	
		}
	}
	
	//시:분으로 Display 할 경우
	if ( gbn == "M" ) { 
		re_value = re_value+t_h+":"+t_m;
	//시.%로 Display 할 경우
	} else {
		re_value = re_value+t_h+"."+((100*t_m)/60);
	} 
	
	return re_value;
}

//수정한 날짜값을 비교하여 분으로 반환 
function calculateMinute(preDate,nextDate,sep,gbn,dis) {
    var Age,t_mon,t_min,t_d,t_h,t_m;
    var t_day1, t_hour1, t_min1, t_day2, t_hour2, t_min2;
    var t_year1, t_mon1, t_year2, t_mon2;
    var re_value;
    var temp = preDate.split(sep);
    
    if ((preDate.length == 0) && (trim(preDate) == "")){
        re_value = "";
        return re_value;
    }
    if ((nextDate.length == 0) && (trim(nextDate) == "")){
        re_value = "";
        return re_value;
    }
    
    t_yaer1 = parseInt(temp[0],10);
    t_mon1 = parseInt(temp[1],10)-1;
    t_day1 = parseInt(temp[2].substring(0,2),10);
    t_hour1 = parseInt(temp[2].substring(3,5),10);
    t_min1 = parseInt(temp[2].substring(6,8),10);

    if (t_yaer1 < 1900 || t_yaer1 >2100) {
        alert('날짜가 틀렸습니다. 년도는 1900년에서 2100년까지 입니다.');
        return false;
    }
    
    if (t_mon1 <0 || t_mon1 > 11) {
        alert('날짜가 틀렸습니다. 달은 1월에서 12월까지 입니다.');
        return false;
    }
        
    t_date1 = Date.UTC(t_yaer1,t_mon1,t_day1,t_hour1,t_min1,0);
    
    temp = nextDate.split(sep);
    t_yaer2 = parseInt(temp[0],10);
    t_mon2 = parseInt(temp[1],10)-1;  // script 특성상 달 표시는 0-11 이기 때문에 하나 감함
    t_day2 = parseInt(temp[2].substring(0,2),10);
    t_hour2 = parseInt(temp[2].substring(3,5),10);
    t_min2 = parseInt(temp[2].substring(6,8),10);


    if (t_yaer2 < 1900 || t_yaer2 >2100) {
        alert('날짜가 틀렸습니다. 년도는 1900년에서 2100년까지 입니다.');
        return false;
    }
    
    if (t_mon2 <0 || t_mon2 > 11) {
        alert('날짜가 틀렸습니다. 달은 1월에서 12월까지 입니다.');
        return false;
    }
    t_date2 = Date.UTC(t_yaer2,t_mon2,t_day2,t_hour2,t_min2,0);
    
    Age = t_date2-t_date1;
    //달수(30일 기준)
    t_mon = Math.floor(((Age/1000)/60)/(24*60*30)); 
    t_min = ((Age/1000)/60)%(24*60*30);                   
    
    //달로 기준해서 남은 시간
    t_h = Math.floor(t_min/60); 
    //달로 기준해서 일수계산
    t_d = Math.floor(t_h/24);   
    //계산된 시간
    t_h = t_h%24;
    //계산된 분
    t_m = t_min%60;             
    //일수계산
    t_d = (t_mon*30)+t_d;       
    
    re_value = "";
    
    if (t_d > 0) {
        if (dis=="D") {
            // 9일 99:99로 Display
            re_value =t_d+"일 ";
        } else {
            // 99:99로 Display
            t_h = t_h + (t_d*24);   
        }
    }
    
    //시:분으로 Display 할 경우
    if ( gbn == "M" ) { 
        //re_value = re_value+t_h+":"+t_m;
        re_value = (t_h*60)+t_m;

    //시.%로 Display 할 경우
    } else {
        re_value = re_value+t_h+"."+((100*t_m)/60);
    }
    
    if (re_value >= 999)
        re_value = 999;

    
    return re_value;
}

function formatDate(lsDate, sep) {
	var t_temp;
	var t_date = lsDate.split(sep);
	
	// "-"=189, "."=190, "/"=191
	if ((event.keyCode == 189) || (event.keyCode == 190) || (event.keyCode == 191) ) {
		lsDate = lsDate.substring(0, lsDate.length -1);
	}
	
	// Year Check
	if ( lsDate.length == 4 ) {
		if (t_date[0] < 1900 || t_date[0] >2100)
			return "";
		else {
			// 날짜수정시 backspace인 경우는 자동 sep을 삭제
			if (event.keyCode == 8) return lsDate; else return lsDate+sep;
		}
	// Month Check
	} else if ( lsDate.length == 7 ) {
		t_temp = parseInt(t_date[1],10);
		if ( (t_temp < 1) || (t_temp > 12) )
			return lsDate.substring(0,5);
		else
			if (event.keyCode == 8) return lsDate; else return lsDate+sep;
	// Day Check
	} else if ( lsDate.length > 9 ) {
		t_temp = parseInt(t_date[2],10);
		//해당 월의 마지막 일수 Check
		if ( (t_temp < 1) || (t_temp > getLastday(t_date[0], parseInt(t_date[1],10) )))
			return lsDate.substring(0,8);
		else
			return lsDate;
	} else {
		return lsDate;
	}
}

function formatDate2(objText) {
    var objTextValue = objText.value;
    
    var dashCharNum = 0;
    
    for (i=0; i<objTextValue.length; i++)
    {
        var tmpChar = objTextValue.substring(i, i+1);

        if (tmpChar == '-')
        {
            dashCharNum++;
        }
    }
    
    // 현재 String에 '-'문자가 2개 존재하면 수정모드로 간주하고 validation 과정을 하지 않음.
    if (dashCharNum > 1) 
    {
        // 수정용 backspace일 경우는 return;
        if (event.keyCode==8 || event.keyCode==37 || event.keyCode==39)
        {
            return;
        }
    }
    
    var returnStr = formatDate(objTextValue, '-');
    objText.value = returnStr;
}

function formatMonth(lsDate, sep) {
	var t_temp;
	var t_date = lsDate.split(sep);
	
	// "-"=189, "."=190, "/"=191
	if ((event.keyCode == 189) || (event.keyCode == 190) || (event.keyCode == 191) ) {
		lsDate = lsDate.substring(0, lsDate.length -1);
	}
	
	// Year Check
	if ( lsDate.length == 4 ) {
		if (t_date[0] < 1900 || t_date[0] >2100)
			return "";
		else {
			// 날짜수정시 backspace인 경우는 자동 sep을 삭제
			if (event.keyCode == 8) return lsDate; else return lsDate+sep;
		}
	// Month Check
	} else if ( lsDate.length > 6 ) {
		t_temp = parseInt(t_date[1],10);
		if ( (t_temp < 1) || (t_temp > 12) )
			return lsDate.substring(0,5);
		else return lsDate;
	} else {
		return lsDate;
	}
}

function formatTime(lsDate, sep) {
	var t_temp;
	var t_date = lsDate.split(":");
	
	// "-"=189, "."=190, "/"=191
	if ((event.keyCode == 189) || (event.keyCode == 190) || (event.keyCode == 191) ) {
		lsDate = lsDate.substring(0, lsDate.length -1);
	}
	
    // Year Check
	if ( lsDate.length == 4 ) {
		if (lsDate < 1900 || lsDate >2100)
			return "";
		else {
			// 날짜수정시 backspace인 경우는 자동 sep을 삭제
			if (event.keyCode == 8) return lsDate; else return lsDate+sep;
		}
	// Month Check
	} else if ( lsDate.length == 7 ) {
		t_temp = parseInt(lsDate.substring(5,7),10);
		if ( (t_temp < 1) || (t_temp > 12) )
			return lsDate.substring(0,5);
		else
			if (event.keyCode == 8) return lsDate; else return lsDate+sep;
	// Day Check
	} else if ( lsDate.length == 10 ) {
		t_temp = parseInt(lsDate.substring(8,10),10);
		//해당 월의 마지막 일수 Check
		if ( (t_temp < 1) || (t_temp > getLastday(lsDate.substring(0,4), parseInt(lsDate.substring(5,7),10) )))
			return lsDate.substring(0,8);
		else
			if (event.keyCode == 8) return lsDate; else return lsDate+" ";
	// Hour Check
	} else if ( lsDate.length == 13 ) {
		t_temp = parseInt(lsDate.substring(11,13),10);
		if ( (t_temp < 1) || (t_temp > 24) )
			return lsDate.substring(0,11);
		else
			if (event.keyCode == 8) return lsDate; else return lsDate+":";
	// Minite Check
	} else if ( lsDate.length == 16 ) {
		t_temp = parseInt(t_date[1],10);
		if ( (t_temp < 1) || (t_temp > 60) )
			return lsDate.substring(0,14);
		else
			if (event.keyCode == 8) return lsDate; else return lsDate+":";
	// Second Check
	} else if ( lsDate.length > 18 ) {
		t_temp = parseInt(t_date[2],10);
		if ( (t_temp < 1) || (t_temp > 60) )
			return lsDate.substring(0,17);
		else
			return lsDate;
	} else {
		return lsDate;
	}
}

function checkValidDate2(lsDate) {
	return checkValidDate(lsDate, 'DDMMYYYY');
}

function checkValidTime2(lsDate){
	return checkValidTime(lsDate, 'DDMMYYYYHHMMSS');
}

function checkValidYearMonth2(lsDate){
	return checkValidYearMonth(lsDate, 'MMYYYY');
}

function getCurrentDate2(sep){
	return getCurrentDate(sep, 'DDMMYYYY');
}

function getCurrentTime2(sep){
	return getCurrentTime(sep, 'DDMMYYYY');
}

function isFutureDate2(lsDate){
	return isFutureDate(lsDate, 'DDMMYYYY');
}

function isPastDate2(lsDate){
	return isPastDate(lsDate, 'DDMMYYYY');
}

function isCompareDate2(preDate,nextDate){
	return isCompareDate(preDate,nextDate, 'DDMMYYYY');
}	

function calculateDay2(preDate,nextDate, sep){
	return calculateDay(preDate,nextDate, sep, 'DDMMYYYY');
}

function addDate(lsDate, strYMD, addVal, format){
	if(format == null || format == undefined){
		var strDate = deleteFormat(lsDate);
		if(strDate.length == 6) format = 'YYYYMM';
		else if(strDate.length == 8) format = 'YYYYMMDD';
	}

	var t_date = getDateArray(lsDate, format);
	if(t_date == null){
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}

	var t_year  = t_date[0];
	var t_month = t_date[1]-1;
	var t_day   = t_date[2];
	
	if(isNaN(eval(t_month))) t_month = 1;
	if(isNaN(eval(t_day))) t_day = 1;
	
	var dateObj = new Date(t_year,t_month,t_day);
	var retDate = new Date();
	
	if(strYMD == 1){
		dateObj.setMonth(dateObj.getMonth()+addVal);
		retDate.setTime(dateObj.getTime());
	}else if(strYMD == 2){
		var tempDate = dateObj.getTime() + ( addVal*24*60*60*1000);
		retDate.setTime(tempDate);
	}	
	
 	var year = retDate.getFullYear();
 	var month = retDate.getMonth() +1;
 	var day = retDate.getDate();

 	month = month < 10 ? '0' + new String(month) : month;
 	day = day < 10 ? '0' + new String(day) : day;
 	
 	if(format.indexOf('YYYYMM') > -1){
 		return year+""+month+""+day;
 	}else if(format.indexOf('MMYYYY') > -1){
 		return day+""+month+""+year;	
 	}
}

function addDate2(lsDate, strYMD, addVal){
	var strDate = deleteFormat(lsDate);
	var format;
	if(strDate.length == 6) format = 'MMYYYY';
	else if(strDate.length == 8) format = 'DDMMYYYY';
		
	var reStr = addDate(lsDate, strYMD, addVal, format);
	return setDateFormat(reStr, format, "/");
}

function setDateFormat(lsDate, format, sep){
	var mask = "";
	if(format == "MMYYYY") mask = "99"+sep+"9999";
	else if(format == "DDMMYYYY") mask = "99"+sep+"99"+sep+"9999";
	return format_mask(lsDate, mask);
}

function format_mask(str, mask){
    if(str == "" || str.length == 0) return;
    var sStr = str.replace( /(\$|\^|\*|\(|\)|\+|\.|\,|\?|\\|\{|\}|\||\[|\]|-|:)/g,"");
    var tStr="";
    var i;
    var j=0;
    var tLen = sStr.length +1 ;
    for(i=0; i< sStr.length; i++){
        tStr += sStr.charAt(i);
        j++;
        if (j < mask.length && mask.charAt(j)!="9") tStr += mask.charAt(j++);
    }
    return tStr;
}

function format_mask_obj(obj, mask){
    var str = obj.value;
    if(str == "" || str.length == 0) return;
    var sStr = str.replace( /(\$|\^|\*|\(|\)|\+|\.|\,|\?|\\|\/|\{|\}|\||\[|\]|-|:)/g,"");
    var tStr="";
    var i;
    var j=0;
    var tLen = sStr.length +1 ;
    for(i=0; i< sStr.length; i++){
        tStr += sStr.charAt(i);
        j++;
        if (j < mask.length && mask.charAt(j)!="9") tStr += mask.charAt(j++);
    }
    obj.value = tStr;
}

function format_date(obj){
	var lsDate = obj.value;
	if(lsDate == "" || lsDate.length == 0) return;
	if(lsDate.length != 10 && lsDate.length != 8){
		alert("올바른 날짜형식이 아닙니다.");
		obj.value = "";
		return;
	}
	if(checkValidDate(lsDate, 'DDMMYYYY')){
		format_mask_obj(obj,"99/99/9999");	
		return obj;
	}else{
		obj.value = "";
	}	
}

function checkType(str,spec) {
	var i;
	var chkcnt = 0;
	
	for(i=0; i<str.length; i++) {
     	if (spec.indexOf( str.substring(i, i+1)) < 0) {
 			return false;
		}
 	}
 	return true;
}

function checkReverse (str,spec) {
	var i;
	for(i=0; i<str.length; i++) {
		if (spec.indexOf( str.substring(i, i+1)) >= 0) return false;
	}
	return true;
}

function checkEmail(str){
	var regExp = /[a-z0-9]{2,}@[a-z0-9-]{2,}\.[a-z0-9]{2,}/i;

	if(!regExp.test(str)) {
		return false;
	} else {
		return true;
	}
}

function checkLength (str, name, nMax) {
	var nStrSize = getSize(str);
		
	if (nStrSize != nMax)  {
		alert( name + " : " + nMax + "자로 입력해 주십시요.\n현재 입력된 길이 : " + nStrSize + "자 입니다.");
		return false;
	}
	return true;
}

function isNull2(str) {
 	if ((str.length == 0) || (Trim(str) == "") ) {
    	return true;
 	}
}

function getSize (str) {
	var i;
	var len = 0;
	
	for ( i=0 ; i<str.length; i++) {
		if ( str.charCodeAt(i) > 255 )  len += 2;
		else  len ++;
	}
	return len; 
}

function checkLenKor (str, name, nMin, nMax) {
	var nStrSize = getSize(str);

	if (nStrSize == 0 && nMin > 0) {
		alert(name + " 입력해 주십시요.");
		return false;
	}

	if (nMin == 0 && nStrSize > nMax) {
 		alert(name + " : 한글 " + Math.floor(nMax/2) + "자 이하로 입력해 주십시요.\n현재 입력된 길이 : " 
 		+ nStrSize/2 + "자 입니다.");
		return false;
	}
	
	if (nStrSize < nMin || nStrSize > nMax) {
		alert(name + " : 한글 " + Math.ceil(nMin/2) + "자 이상, " + Math.floor(nMax/2) + "자 이하로 입력해 주십시요.\n현재 입력된 길이 : " 
		+ nStrSize/2 + "자 입니다.");
		return false;
	}

	return true;
}

function checkLenEng (str, name, nMin, nMax) {
	var nStrSize = getSize(str);

	if (nStrSize == 0 && nMin > 0) {
		alert(name + " 입력해 주십시요.");
		return false;
	}

	if (nMin == 0 && nStrSize > nMax) {
 		alert(name + " : 영문 " + nMax + "자 이하로 입력해 주십시요.\n현재 입력된 길이 : " 
 		+ nStrSize + "자 입니다.");
		return false;
	}
	
	if (nStrSize < nMin || nStrSize > nMax) {
		alert(name + " : 영문 " + nMin + "자 이상, " + nMax + "자 이하로 입력해 주십시요.\n현재 입력된 길이 : " 
		+ nStrSize + "자 입니다");
		return false;
	}

	return true;
}

function isKor (str) {
	var sKorname = Trim(str);

	if (!checkReverse(sKorname, '\"<>' + ALPHA + NUM)) {
		return false;
	}
	return true;	
}

function isAlphabet(str) {
	if (str.length == 0) return false;
	
	str = upperCase(str);
	for(var i=0; i < str.length; i++) {
		if(!('A' <= str.charAt(i) && str.charAt(i) <= 'Z')) return false;
	}
	return true;
}

function isAlphaNumeric(str) {
	if (str.length == 0) return false;
	
	str = upperCase(str);
	for(var i=0; i < str.length; i++) {
		if(!(('A' <= str.charAt(i) && str.charAt(i) <= 'Z') || ('0' <= str.charAt(i) && str.charAt(i) <= '9'))) return false;
	}
	return true;
}

function checkSameStr(str1, str2) {
	if(str1.length == 0 || str2.length == 0) return false;
	
	if(str1 == str2) return true;
	return false;
}

function insertComma(str) {
	var txtNumber = '' + str;
	checkDigit2(str);

	var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');
	var arrNumber = txtNumber.split('.');
	arrNumber[0] += '.';
	do {
		arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');
	} while (rxSplit.test(arrNumber[0]));
	
	if (arrNumber.length > 1) {
		return arrNumber.join('');
	} else {
		return arrNumber[0].split('.')[0];
  	}
}

function insertComma2(str){
    str = new String(str);
    str = str.replace(/,/gi,"");
    return insertComma(str);
}

function removeComma(str) {
	re = /^\$|,/g;
	return str.replace(re, "");
}

function upperCase(str) {
    if (str.length = 0 ) return "";
    else return str.toUpperCase();
 }

function lowerCase(str) {
	if (str.length = 0 ) return "";
	else return str.toLowerCase();
}

function Trim(str) { 
	var search = 0 
	
	while ( str.charAt(search) == " ") search = search + 1 
	
	str = str.substring(search, (str.length)) 
	search = str.length - 1 
	
	while (str.charAt(search) ==" ") search = search - 1 
	
	return str.substring(0, search + 1)
}

function Trim2(str){ 
    var reg = /\s+/g; 
    return str.replace(reg,''); 
}


function checkLenEng2(str, name, nMin, nMax) {
	var nStrSize = getSize(str);

	if (nStrSize == 0 && nMin > 0) {
		alert(name + " should be inputted");
		return false;
	}

	if (nMin == 0 && nStrSize > nMax) {
 		alert(name + " should be inputted by over [" + nMax + "] characters.\nThe length you input now : " 
 		+ nStrSize + ".");
		return false;
	}
	
	if (nStrSize < nMin || nStrSize > nMax) {
		alert(name + " should be inputted from [" + nMin + "] characters to [" + nMax + "] characters.\nThe length you input now : " 
		+ nStrSize + ".");
		return false;
	}

	return true;
}

function lpad(str, n, padding) {
    if (str.length >= n) {
        return str;
    }
    
    var len = n - str.length;
    var pad_str = str;
    
    for (var i=0; i<len; i++) {
        pad_str = padding + pad_str;
    }
    
    return pad_str
}

function rpad(str, n, padding) {
    if (str.length >= n) {
        return str;
    }
    
    var len = n - str.length;
    var pad_str = str;
    
    for (var i=0; i<len; i++) {
        pad_str = pad_str + padding;
    }
    
    return pad_str;
}

function ltrim(str) {
    return str.replace(/^\s+/, "");
}

function rtrim(str) {
    return str.replace(/\s+$/, "");
}

function trim(str) {
    return rtrim(ltrim(str));
}

// 입력값을 원단위 포맷으로 변환
function numTowon(szNumber) {
    if (szNumber == '' || szNumber == '0') {
        return szNumber;
    }
    
    var returnValue = 0;
    var temp1 = szNumber.replace(/,/g,"");
    var splitNumber = temp1.split('.');
    
    // 정수자리 원단위로 만들기
    var numInt = '';
    var comma = 1;
    
    for (var i=splitNumber[0].length-1; i>=0; i--) {
        numInt += splitNumber[0].charAt(i);
        if ((comma%3==0) && (comma!=0)) {
            numInt += ',';
        }
        
        comma++;
    }
    
    var tempNum = '';
    for (var i=numInt.length-1; i>=0; i--) {
        tempNum += numInt.charAt(i);
    }
    
    // 소수점이 있을 경우
    if (splitNumber.length > 1) {
        // 소수점 자리를 원단위로 생성해서 Return
        var numPoint = '';
        for (var i=1; i<= numInt[1].length; i++) {
            numPoint += numInt[i].charAt(i);
            
            if ((i%3==0) && (i!=0)) {
                numPoint += ',';
            }
        }
        
        var returnNum = numInt+'.'+numPoint;
        returnValue = returnNum.replace(/(^,)|(,$)/g, '');
    } else {
        returnValue = tempNum.replace(/(^,)|(,$)/g, '');
    }
    
    if (returnValue == '' || returnValue == '.') {
        return '';
    } else {
        return returnValue;
    }
}

function checkIfNotNull(value,colName){
	if(value.toString()._dhx_trim()==''){
		alert(colName+ ' should not be null');
		return false;
	}else
		return true;
}

function checkIfNotZero(value,colName){
	if(value.toString()._dhx_trim()=='0'){
		alert(colName+ ' should not be 0');
		return false;
	}else
		return true;
}


function getCurDateTime() {
    var today = new Date();
    var year = today.getFullYear();
    var month = today.getMonth() + 1;
    var day = today.getDate();
    var time = today.getTime();
    
    var si = time/1000*60*60;
    var bun = time/1000*60; 
    var cho = time/1000;
    return year+"-"+month+"-"+day+" "+si+":"+bun+":"+cho
}



/*dhtmlx grid*/
function checkLimitLength(gridObj, len){
	gridObj.editor.obj.onkeypress = function(e){
		e = e||window.event;
		if((e.keyCode >= 47) || (e.keyCode == 0)){
			var text = this.value;
			if(text.length >= len){
				return false;
			}
		}
	}
}

/*dhtmlx grid*/
function checkLimitByte(gridObj, len){
	gridObj.editor.obj.onkeypress = function(e){
		e = e||window.event;
		if((e.keyCode >= 47) || (e.keyCode == 0)){
			var text = this.value;
			if(getByte(text) >= len){
				return false;
			}
		}
	}
}

/*dhtmlx grid*/
function checkNumber(gridObj){
	gridObj.editor.obj.onkeypress = function(e){
		e = e||window.event;
		if(FILTER_NUM){
			var key = _isIE ? e.keyCode:e.which;
		    var sKey = String.fromCharCode(key);
			var re = new RegExp(FILTER_NUM);
			if(sKey.match(re) == null){
			    if(_isIE) e.returnValue = false;
			    else{
			    	if(key != 8 && key != 0) e.preventDefault();
			    }
			}else{
				var text = this.value;
				if(text == ''){
					if(sKey == '.' || sKey == ','){
						return false;	
					}	
				}
			}
		}
	}
}

/*dhtmlx grid*/
function checkNumberLimitByte(gridObj, len, len2){
	gridObj.editor.obj.onkeypress = function(e){
		e = e||window.event;
		if(FILTER_NUM){
			var key = _isIE ? e.keyCode:e.which;
		    var sKey = String.fromCharCode(key);
			var re = new RegExp(FILTER_NUM);
			if(sKey.match(re) == null){
			    if(_isIE) e.returnValue = false;
			    else{
			    	if(key != 8 && key != 0) e.preventDefault();
			    }
			}else{
				var text = this.value;
				var texts = text.split(',');
				
				if(text == ''){
					if(sKey == '.' || sKey == ','){
						return false;	
					}	
				}else{
					if(len2 != null && len2 != undefined){	
						if(sKey != '.' && sKey != ','){
							if(getByte(texts[0]) >= len){
								if(texts.length == 2){
									if(getByte(texts[1]) >= len2){
										return false;
									}
								}else{
									return false;	
								}
							}
						}
					}else{	
						if(getByte(text) >= len){
							return false;
						}
					}
				}
			}
		}
	}
}

/*dhtmlx combo*/
function getDhtmlXComboOption(comboObj){
	var comboOptions = new Array();
	for(var i = 0; i < comboObj.optionsArr.length; i++){
		var comboOption = new Array();
		comboOption[0] = comboObj.optionsArr[i].value;
		comboOption[1] = comboObj.optionsArr[i].text;
		comboOptions[i] = comboOption;
	}
	return comboOptions;
}


function checkSelectbox(formObj) {
    var chk = 0;    
    for(var i = 0; i < formObj.elements.length ; i++) {
       if ((formObj.elements[i].type == "checkbox") && (formObj.elements[i].checked == true)) {
           chk++;
       }
    }    
    if (chk == 0 ) { 
    	return false; 
    } else {
    	return true;
    }
}