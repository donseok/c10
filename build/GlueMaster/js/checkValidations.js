/*
 * Copyright(c) 2010 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : checkValidation.js
 * @FileName       : checkValidation
 * Change history
 * @Author         : 정소희
 * @LastVersion    : 1.3
 *     2003-05-16    오용현
 *     draft1A       for review
 *     draft1B       After review modification
 *                   (checkType에 EMAIL이 적용되지 않아 checkEmail 추가)
 *     1.0           After Unit  Testing 
 *     2003-07-10    정영훈
 *     1.1           validMonth 메소드 추가, 오탈자 수정
 *     2003-12-10    김동호
 *     1.2           formatDate2 메소드 추가.
 *     2004-12-02    남광현
 *     1.3           caculateHour 달 계산 로직 오류 수정
 */

// checkType 사용
var NUM      = "0123456789";
var SALPHA   = "abcdefghijklmnopqrstuvwxyz";
var ALPHA    = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"+SALPHA;
var EMAIL    = "!#$%&*+-./=?@^_`{|}"+NUM+ALPHA;
var PASSWORD = "!@.#,$%^*&_-" + ALPHA + NUM;
var ERRORMSG = "";
var ETC      = ".,()[]" ;
var TELNO    = "-" + NUM;

// getLastday 사용
var dayOfMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);

/**---------------------------------------------------------------------------------------------------
 *	Number Validation 
 **---------------------------------------------------------------------------------------------------*/

/**
* @Function 명		: doNumberCheck
* @Function 설명	: 해당 input type="text"의 입력값을 숫자외 입력불가 Function
* @Param 			: none
* @return값			: boolean
* @사용 Event 		: onKeypress
* @see 				: asc(46)=".", asc(47)="/"포함
*/
function doNumberCheck() {
	if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;
}

/**
* @Function 명		: checkDigit
* @Function 설명	: 입력값이 숫자인지 않인지만 Check
* @Param 			: 1. str : (Object)Form명을 포함한 input 
* @return값			: boolean
* @사용 Event 		: 
* @see 				:
*/
function checkDigit(str)  {
	var str = str.toString();
	var ch = '\0';
	var flag = true;
	for (var i = 0, ch = str.charAt(i); (i < str.length) && (flag); ch = str.charAt(++i)) {
		if ((ch >= '0') && (ch <= '9')) flag = true;
		else flag = false;
	}
	return flag;
}

/**
* @Function 명		: checkDigit2
* @Function 설명	: 입력값이 숫자인지 않인지만 Check Case2
* @Param 			: 1. str : (Object)Form명을 포함한 input 
* @return값			: none
* @사용 Event 		: 
* @see 				:
*/
function checkDigit2(str)  {
    var txtNumber = "" + str;
    if (isNaN(txtNumber)) { 
         alert("숫자만 입력 하세요.");
    }
}

/**
* @Function 명		: compareValue
* @Function 설명	: 입력된 Text의 비교(Integer)
* @Param 			: 1. str	: (String)Form명을 포함한 input
*					  2. str2	: (String) 비교할 Form명을 포함한 input
*					  3. sep	: (String) "<>="
* @return값			: none
* @사용 Event 		: onBlur
* @see 				: 1. doNumberCheck()와 같이 사용
*					  2. Comma가 포함 해도 무방
*/
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

/**
* @Function 명		: calculateValue
* @Function 설명	: 두입력값을 가감승제한다
* @Param 			: 1. str	: (String) 입력값
*					  2. str2	: (String) 가감승제 할 값
*                     3. sep	: (String) "+-* "
* @return값			: (String) 계산된 값
* @사용 Event 		: onBlur
* @see 				: 1. Comma가 포함 해도 무방
*/
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

/**
* @Function 명		: setRound
* @Function 설명	: 입력값의 자리수 만큼 반올림
* @Param 			: 1. str	: (String) 입력값
*					  2. len	: (String) 반올림할 자리수
* @return값			: none	
* @사용 Event 		: onBlur
* @see 				: doNumberCheck()와 같이 사용
*/
function setRound(str,len) {
    len=Math.pow(10,len)
    return Math.round(str * len) / len;
}

/**---------------------------------------------------------------------------------------------------
 *	Date Validation 
 **---------------------------------------------------------------------------------------------------*/

/**
* @Function 명		: checkValidDate
* @Function 설명	: 입력일자의 값이 정확한 일자인지 Check
* @Param 			: 1. lsDate : (String)'YYYY-MM-DD' or "YYYYMMDD" 형태의 입력Date 값
* @return값			: Boolean	
* @사용 Event 		: onBlur
* @see 				: 
*/
function checkValidDate(lsDate) {
	var t_date = new String(lsDate);
	var t_year, t_month, t_day;
	
	if (lsDate.length == 8 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(4,6),10);
		t_day   = parseInt(t_date.substring(6,8),10);		
	} else if (lsDate.length == 10 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(5,7),10);
		t_day   = parseInt(t_date.substring(8,10),10);
	} else {
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}
	
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

/**
* @Function 명		: getLastday
* @Function 설명	: 입력한 년,월의 마지막 일자을 구하는 Function
* @Param 			: 1. calyear (String) 'YYYY'형태의 년도
*					  2. calmonth (String) 'MM'형태의 월
* @return값			: (String)현재달의 마지막 일자
* @사용 Event 		: onBlur
* @see 				: 
*/
function getLastday(calyear,calmonth) {
	if (((calyear % 4 == 0) && (calyear % 100 != 0))||(calyear % 400 == 0)) dayOfMonth[1] = 29;
	
	var nDays = dayOfMonth[calmonth-1];
	return nDays;
}

/**
* @Function 명		: checkValidTime
* @Function 설명	: 입력일자의 값이 정확한 시각인지 Check
* @Param 			: 1. lsDate : (String)'YYYY-MM-DD HH:MM:SS' or "YYYYMMDDHHMMSS" 형태의 입력Date 값
* @return값			: Boolean
* @사용 Event 		: onBlur
* @see 				: 
*/
function checkValidTime(lsDate) {
	var t_date = new String(lsDate);
	var t_year, t_month, t_day, t_hour, t_min, t_second;
	
	if (lsDate.length == 14 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(4,6),10);
		t_day   = parseInt(t_date.substring(6,8),10);
		t_hour  = parseInt(t_date.substring(8,10),10);
		t_min   = parseInt(t_date.substring(10,12),10);
		t_second= parseInt(t_date.substring(12,14),10);
	} else if (lsDate.length == 19 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(5,7),10);
		t_day   = parseInt(t_date.substring(8,10),10);
		t_hour  = parseInt(t_date.substring(11,13),10);
		t_min   = parseInt(t_date.substring(14,16),10);
		t_second= parseInt(t_date.substring(17,19),10);
	} else {
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}
	
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

/**
* @Function 명		: checkValidYearMonth
* @Function 설명	: 입력일자의 값이 정확한 일자인지 Check(년월)
* @Param 			: 1. lsDate : (String)'YYYY-MM' or "YYYYMM" 형태의 입력Date 값
* @return값			: Boolean	
* @사용 Event 		: onBlur
* @see 				: 
*/
function checkValidYearMonth(lsDate) {
	var t_date = new String(lsDate);
	var t_year, t_month;
	
	if (lsDate.length == 6 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(4,6),10);
	} else if (lsDate.length == 7 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(5,7),10);
	} else {
		alert('날자형식이 맞는지 확인하세요.');
		return false;
	}
	
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

/**
* @Function 명		: getCurrentDate
* @Function 설명	: 구분자에 의해 현재의 일자를 가져오는 Function
* @Param 			: 1. sep	: (String) 날짜형태의 Formatting하는 구분자
* @return값			: (String) Formatting이 정해진 현재일자
* @사용 Event 		: 
* @see 				: 
*/
function getCurrentDate(sep) {
	var today = new Date();
	var t_year = today.getFullYear();
	var t_mon  = today.getMonth()+1;
	var t_day  = today.getDate();
	
	if(t_mon.toString().length == 1) t_mon = "0" + t_mon;
	if(t_day.toString().length == 1) t_day = "0" + t_day;
	
    return ""+t_year+sep+t_mon+sep+t_day;
}

/**
* @Function 명		: getCurrentTime
* @Function 설명	: 구분자에 의해 현재의 시각를 가져오는 Function
* @Param 			: 1. sep	: (String) 날짜형태의 Formatting하는 구분자
* @return값			: (String) Formatting이 정해진 현재시각
* @사용 Event 		: 
* @see 				: 시분초의 구분자의 default = :
*/
function getCurrentTime(sep) {
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
	
    return ""+t_year+sep+t_mon+sep+t_day+" "+t_hour+":"+t_min+":"+t_sec;
}

/**
* @Function 명		: isFutureDate
* @Function 설명	: 입력시간이 현재일자보다 미래의 일자인지 Check
* @Param 			: 1. lsDate	: (String) 입력한일자
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
function isFutureDate(lsDate) {
	var t_date = new String(lsDate);
	var t_year, t_month, t_day;
	
	checkValidDate(lsDate);
	
	if (lsDate.length == 8 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		// 1월=0,12월=11
		t_month = parseInt(t_date.substring(4,6),10)-1; 
		t_day   = parseInt(t_date.substring(6,8),10);		
	} else if (lsDate.length == 10 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(5,7),10)-1;
		t_day   = parseInt(t_date.substring(8,10),10);
	}
	
	var dateObj = new Date(t_year,t_month,t_day);
	return (dateObj > new Date());
}

/**
* @Function 명		: isFutureDate
* @Function 설명	: 입력시간이 현재일자보다 과거의 일자인지 Check
* @Param 			: 1. lsDate	: (String) 입력한일자
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
function isPastDate(lsDate) {
	var t_date = new String(lsDate);
	var t_year, t_month, t_day;
	
	checkValidDate(lsDate);
	
	if (lsDate.length == 8 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		// 1월=0,12월=11
		t_month = parseInt(t_date.substring(4,6),10)-1; 
		t_day   = parseInt(t_date.substring(6,8),10);		
	} else if (lsDate.length == 10 ) {
		t_year  = parseInt(t_date.substring(0,4),10);
		t_month = parseInt(t_date.substring(5,7),10)-1;
		t_day   = parseInt(t_date.substring(8,10),10);
	}
	
	var dateObj = new Date(t_year,t_month,t_day);
	return (dateObj < new Date());
}

/**
* @Function 명		: isCompareDate
* @Function 설명	: 두 입력값의 날짜비교, 첫번째 인자는 두번인자보다 이전 시간이여야 한다.
* @Param 			: 1. preDate	: (String) 'YYYY-MM-DD'형태의 입력Date 값
*					  2. nextDate	: (String) 비교할 'YYYY-MM-DD'형태의 입력Date 값
* @return값			: boolean
* @사용 Event 		: onBlur
* @see 				: 
*/
function isCompareDate(preDate,nextDate) {
	checkValidDate(preDate);
	checkValidDate(nextDate);
	
	preDate  = preDate.replace(/-/gi,"");
	nextDate = nextDate.replace(/-/gi,"");
	
	if (eval(preDate) > eval(nextDate) ) return false;
	return true;
}

/**
* @Function 명		: calculateDay
* @Function 설명	: 입력된 두 날짜의 사이를 일수계산 Function
* @Param 			: 1. preDate: (String) 시간Type의 일자.  'YYYY-MM-DD'형태
*					  2. nextDate: (String) 계산할 일자 'YYYY-MM-DD'형태
*					  3. sep	: (String) 일자의 구분자(-,/,.)
* @return값			: (String) 두일자간의 일수
* @사용 Event 		: 
* @see 				: 
*/
function calculateDay(preDate,nextDate,sep) {
	var t_day1, t_day2, re_value;
	var temp = preDate.split(sep);
	var t_day1 = new Date(parseInt(temp[0],10), parseInt(temp[1]-1,10), parseInt(temp[2],10));

	t_day1 = t_day1.getTime();
	
	temp = nextDate.split(sep);
	var t_day2 = new Date(parseInt(temp[0],10), parseInt(temp[1]-1,10), parseInt(temp[2],10));
	
	t_day2 = t_day2.getTime();
	
	re_value = Math.floor( (t_day2 - t_day1) / (60*60*24*1000) );
	return re_value;
}

/**
* @Function 명		: calculateHour
* @Function 설명	: 입력된 두 날짜의 사이를 시간을 계산하여 정해진 포맷에 맞게 출력 Function
* @Param 			: 1. preDate: (String) 시간Type의 일자.  'YYYY-MM-DD'형태
*					  2. nextDate: (String) 계산할 일자 'YYYY-MM-DD'형태
*					  3. sep	: (String) 일자의 구분자(-,/,.)
*					  4. gbn	: (String) 'M' : 시:분으로 표기, 'P' : 시.%으로 표기
*					  5. dis	: (String) 'D' : 1일 1:00 표기,  'H' : 25:00 표기
* @return값			: (String) 두시간차이를  '시:분' 내지 시간단위로 표시
* @사용 Event 		: 
* @see 				: 
*/
function calculateHour(preDate,nextDate,sep,gbn,dis) {
	var Age,t_mon,t_min,t_d,t_h,t_m;
	var t_day1, t_hour1, t_min1, t_day2, t_hour2, t_min2;
	var t_year1, t_mon1, t_year2, t_mon2;
	var re_value;
	var temp = preDate.split(sep);
	
	t_yaer1 = parseInt(temp[0],10);
	t_mon1 = parseInt(temp[1],10)-1; // script 특성상 달 표시는 0-11 이기 때문에 하나 감함
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

/**
 * @Function 명		: formatDate
 * @Function 설명  	: 날짜표시 구분자에 의해  자동 Formating function(일자)
 * @Param 			: 1. lsDate	: (String) 입력Date 값("YYYY-MM-DD")
 *					  2. sep	: (String) 일자의 구분자(-,/,.)
 * @return값			: (String) 자동 Formating이 된 일자
 * @사용 Event 		: onKeyup
 * @see 				: 1. 년,월,일 Validiation Check시 범위가 벗어나는 경우 해당 년,월,일만 삭제.
 *					  2. onKeypress="doNumberCheck();"와 같이 사용
 */
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

/**
 * @Function 명		: formatDate2
 * @Function 설명  	: textbox를 입력 받아서 validation 과정 수행
 * @Param 			: 1. objText - form Object
 * @return			: 없음.
 * @사용 Event 		: onKeyup
 */
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



/**
* @Function 명		: formatMonth
* @Function 설명	: 날짜표시 구분자에 의해  자동 Formating function(일자)
* @Param 			: 1. lsDate	: (String) 입력Date 값("YYYY-MM")
*					  2. sep	: (String) 일자의 구분자(-,/,.)
* @return값			: (String) 자동 Formating이 된 년,월
* @사용 Event 		: onKeyup
* @see 				: 1. 년,월 Validiation Check시 범위가 벗어나는 경우 해당 년,월만 삭제.
*					  2. onKeypress="doNumberCheck();"와 같이 사용
*/
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



/**
* @Function 명		: formatTime
* @Function 설명	: 날짜표시 구분자에 의해  자동 Formating function(시각)
* @Param 			: 1. lsDate	: (String) 입력Date 값("YYYY-MM-DD HH:MI:SS")
*					  2. sep	: 일자의 구분자(-,/,.)
* @return값			: (String) 자동 Formating이 된 시각
* @사용 Event 		: onKeyup
* @see 				: 1. 년,월,일,시,분초 Validiation Check시 범위가 벗어나는 경우 해당 년,월,일,시,분초만 삭제.
*					  2. onKeypress="doNumberCheck();"와 같이 사용
*/
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

/**---------------------------------------------------------------------------------------------------
 *	항목 Validation 
 **---------------------------------------------------------------------------------------------------*/

/**
* @Function 명		: checkType
* @Function 설명	: 해당 Spec에 형태에 존재하는지 Check
* @Param 			: 1. str	: (String) 입력값
*					  2. spec	: (String) Spec 범례중 한 개의 값
* @return값			: boolean
* @사용 Event 		: onBlur
* @see 				: 1. NUM	= 숫자
*					: 2. SALPHA	= 소문자영문
*					: 3. ALPHA  = 영문자
*					: 4. EMAIL  = 메일관련
*					: 5. PASSWORD  = 패스워드
*					: 6. ERRORMSG  = ERROR관련
*					: 7. ETC   = 기타
*					: 8. TELNO  = 전화번호, 년도
*					: Validation에 전범위에서 사용, 필요에 따라 추가 사용 
*/
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

/**
* @Function 명		: checkReverse
* @Function 설명	: checkType의 반대의 Funtion
*					  입력받는 spec의 제외된 문자범위내에서 spec 구조을 check
* @Param 			: 1. str	: (String) 입력값
*					  2. spec	: (String) Spec 범례중 한 개의 값 (checkType spec 참고)
* @return값			: boolean
* @사용 Event 		: onBlur
* @see 				: 
*/
function checkReverse (str,spec) {
	var i;
	for(i=0; i<str.length; i++) {
		if (spec.indexOf( str.substring(i, i+1)) >= 0) return false;
	}
	return true;
}


/**
* @Function 명		: checkEmail
* @Function 설명	: 해당 문자가 정확한 Email 문자인지 Check
* @Param 			: 1. str	: (String) 이메일 형태의 입력값
* @return값			: boolean
* @사용 Event 		: onBlur
* @see 				: 
*/
function checkEmail(str){
	var regExp = /[a-z0-9]{2,}@[a-z0-9-]{2,}\.[a-z0-9]{2,}/i;

	if(!regExp.test(str)) {
		return false;
	} else {
		return true;
	}
}

/**
* @Function 명		: checkLength
* @Function 설명	: 해당 문자의 자리수 Check
* @Param 			: 1. str	: (String) 입력값
*					  2. name	: (String) 입력값이 Alert에 표시될 문자명
*					  3. nMax	: (String) check해야 할 자리수 
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
function checkLength (str, name, nMax) {
	var nStrSize = getSize(str);
		
	if (nStrSize != nMax)  {
		alert( name + " : " + nMax + "자로 입력해 주십시요.\n현재 입력된 길이 : " + nStrSize + "자 입니다.");
		return false;
	}
	return true;
}

/**
* @Function 명		: isNull
* @Function 설명	: 입력된 Text가 공백여부 Check
* @Param 			: 1. str	: (String) Form명을 포함한 입력값
* @return값			: 없음
* @사용 Event 		: 
* @see 				: 
*/
function isNull(str) {
 	if ((str.length == 0) && (Trim(str) == "") ) {
    	alert("해당 항목이 입력되지 않았습니다.");
 	}
}

/**
* @Function 명		: getSize
* @Function 설명	: 해당 문자열의 자리수(영문, 한글 포함)
* @Param 			: 1. str	: (String) 입력값
* @return값			: (String) 자리수 값
* @사용 Event 		: 
* @see 				: 
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
* @Function 명		: checkLenKor
* @Function 설명	: 입력된 한글문자열의 최소 입력될 자리수와 최대 입력 문자열을 Check
* @Param 			: 1. str	: (String) 입력값
*					  2. name	: (String) 입력값이 Alert에 표시될 문자명
*					  3. nMin 	: (String) 입력문자열의 최소자리수
*					  4. nMax  	: (String) 입력문자열의 최대자리수
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
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

/**
* @Function 명		: checkLenEng
* @Function 설명	: 입력된 영문문자열의 최소 입력될 자리수와 최대 입력 문자열을 Check
* @Param 			: 1. str	: (String) 입력값
*					  2. name	: (String) 입력값이 Alert에 표시될 문자명
*					  3. nMin 	: (String) 입력문자열의 최소자리수
*					  4. nMax  	: (String) 입력문자열의 최대자리수
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
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

/**
* @Function 명		: isKor
* @Function 설명	: 입력된 문자열이 한글인지 Check
* @Param 			: 1. str	: (String) 입력값
*					  2. name	: (String) 입력값이 Alert에 표시될 문자명
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
function isKor (str) {
	var sKorname = Trim(str);

	if (!checkReverse(sKorname, '\"<>' + ALPHA + NUM)) {
		return false;
	}
	return true;	
}

/**
* @Function 명		: isAlphabet
* @Function 설명	: 입력값이 영문인지 Check(Case2)
* @Param 			: 1. str	: (String) 입력값
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
function isAlphabet(str) {
	if (str.length == 0) return false;
	
	str = upperCase(str);
	for(var i=0; i < str.length; i++) {
		if(!('A' <= str.charAt(i) && str.charAt(i) <= 'Z')) return false;
	}
	return true;
}

/**
* @Function 명		: isAlphaNumberic
* @Function 설명	: 입력값이 영문과 숫자로 되었는지 Check
* @Param 			: 1. str	: (String) 입력값
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 
*/
function isAlphaNumeric(str) {
	if (str.length == 0) return false;
	
	str = upperCase(str);
	for(var i=0; i < str.length; i++) {
		if(!(('A' <= str.charAt(i) && str.charAt(i) <= 'Z') || ('0' <= str.charAt(i) && str.charAt(i) <= '9'))) return false;
	}
	return true;
}

/**
* @Function 명		: checkSameStr
* @Function 설명	: 입력된 두값이 같은지 Check
* @Param 			: 1. str1	: (String) 입력값
*					  2. str2	: (String) 비교할 문자값
* @return값			: boolean
* @사용 Event 		: 
* @see 				: 비밀번호 와 새비밀번호가 같은지 여부
*/
function checkSameStr(str1, str2) {
	if(str1.length == 0 || str2.length == 0) return false;
	
	if(str1 == str2) return true;
	return false;
}

/**---------------------------------------------------------------------------------------------------
 *	기타 Validation 
 **---------------------------------------------------------------------------------------------------*/

/**
* @Function 명		: insertComma
* @Function 설명	: 해당 text에 ','을 추가(금액), '.' 포함
* @Param 			: 1. str	: (String) Form명을 포함한 입력값
* @return값			: (String) Comma가 적용된 String(','및 '.'을 포함)
* @사용 Event 		: onBlur
* @see 				: doNumberCheck() 와 같이 사용 유용
*/
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

/**
* @Function 명		: insertComma2
* @Function 설명	: Comma Function Case2
* @Param 			: 1. str	: (String)Form명을 포함한 입력값
* @return값			: (String) Comma가 적용된 String(소수점이 있는 숫자,음수도 포함)
* @사용 Event 		: onKeyup
* @see 				: doNumberCheck() 와 같이 사용 유용
*/
function insertComma2(str){
    str = new String(str);
    str = str.replace(/,/gi,"");
    return insertComma(str);
}

/**
* @Function 명		: removeComma
* @Function 설명	: Comma가 적용된 Text을 제거하는 function
* @Param 			: 1. str	: (String)Form명을 포함한 input
* @return값			: (String) Comma가 제거된 String
* @사용 Event 		: onBlur
* @see 				: 
*/
function removeComma(str) {
	re = /^\$|,/g;
	return str.replace(re, "");
}

/**
* @Function 명		: upperCase
* @Function 설명	: 지정된 문자열을 대문자로 변환하는 function
* @Param 			: 1. str	: (String) 문자열
* @return값			: (String) 대문자로 적용된 String
* @사용 Event 		: onBlur
* @see 				: 
*/
function upperCase(str) {
    if (str.length = 0 ) return "";
    else return str.toUpperCase();
}

/**
* @Function 명		: lowerCase
* @Function 설명	: 지정된 문자열을 소문자로 변환하는 function
* @Param 			: 1. str	: (String) 문자열
* @return값			: (String) 소문자로 적용된 String
* @사용 Event 		: onBlur
* @see 				: 
*/
function lowerCase(str) {
	if (str.length = 0 ) return "";
	else return str.toLowerCase();
}

/**
* @Function 명		: Trim
* @Function 설명	: 공백제거 함수
* @Param 			: 1. str	: (String) 입력값
* @return값			: (String) 공백이 제거된 문자열(RTrim, LTrim 역활만)
* @사용 Event 		: 
* @see 				: 
*/
function Trim(str) { 
	var search = 0 
	
	while ( str.charAt(search) == " ") search = search + 1 
	
	str = str.substring(search, (str.length)) 
	search = str.length - 1 
	
	while (str.charAt(search) ==" ") search = search - 1 
	
	return str.substring(0, search + 1)
}

/**
* @Function 명		: Trim2
* @Function 설명	: 공백제거 함수
* @Param 			: 1. str	: (String) 입력값
* @return값			: (String) 공백이 제거된 문자열(중간의 공백도 모두 제거)
* @사용 Event 		: 
* @see 				: 
*/
function Trim2(str){ 
    var reg = /\s+/g; 
    return str.replace(reg,''); 
}