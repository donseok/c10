/*
 * Copyright(c) 2010 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : showCalendar.js
 * @FileName       : showCalendar
 * Change history
 * @Author         : 오용현
 * @LastVersion    : 1.0
 *   2003-05-16    오용현
 *    1.0           After Unit Testing 
 */

/**
 * 현재 날짜로 달력을 출력할 것인지 선택한 날짜로 출력할 것인지를 판단하여 달력을 띄우는 메소드
 * @param  idx  날짜값을 출력시키는 input type tag가 입력을 받기 위한 tag인지(값 -1),
 *              showTable에서 출력되는 tag인지를 판단하기 위한 값(값 >=0)
 *              obj  날짜값을 출력시키는 input type tag 객체
 */
function jspCalendar(idx, obj, gFormat, timecheck){
	var objYear="";
	var objMonth="";
	var objDay="";
	//stor2=는 날짜를 입력할 input tag name
	if(idx == -1 || idx == undefined){
		objName  = obj.name;
		if(obj.value!=null && obj.value.length > 0){
			objYear  = obj.value.substr(0,4);
			objMonth = obj.value.substr(5,2);
			objDay   = obj.value.substr(8,2);
		}
		stor2 = objName;
	}else if(idx >= 0){
		objName  = obj[idx].name;
		if(obj.value!=null && obj.value.length > 0){
			objValue = obj[idx].value;
			objYear  = objValue.substr(0,4);
			objMonth = objValue.substr(5,2);
			objDay   = objValue.substr(8,2);
		}
		stor2 = objName+"["+idx+"]";
	}
	var url = "server_calendar.jsp?year="+objYear+"&month="+objMonth+"&day="+objDay+"&gFormat=" +gFormat +"&stor2=" +stor2 +"&timeCheck="+timecheck;
	var winsize = 'scrollbars=no,status=no,width=280,height=320';
	window.open(url,"Calendar", winsize);
}

function jspGlobalCalendar(idx, obj, gFormat, timecheck){
	var objYear="";
	var objMonth="";
	var objDay="";
	//stor2=는 날짜를 입력할 input tag name
	if(idx == -1 || idx == undefined){
		objName  = obj.name;
		if(obj.value!=null && obj.value.length > 0){
			objYear  = obj.value.substr(0,4);
			objMonth = obj.value.substr(5,2);
			objDay   = obj.value.substr(8,2);
		}
		stor2 = objName;
	}else if(idx >= 0){
		objName  = obj[idx].name;
		if(obj.value!=null && obj.value.length > 0){
			objValue = obj[idx].value;
			objYear  = objValue.substr(0,4);
			objMonth = objValue.substr(5,2);
			objDay   = objValue.substr(8,2);
		}
		stor2 = objName+"["+idx+"]";
	}
	var url = "server_calendar_global.jsp?year="+objYear+"&month="+objMonth+"&day="+objDay+"&gFormat=" +gFormat +"&stor2=" +stor2 +"&timeCheck="+timecheck;
	var winsize = 'scrollbars=no,status=no,width=280,height=320';
	window.open(url,"Calendar", winsize);
}
