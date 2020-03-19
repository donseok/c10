/*
 * Copyright(c) 2012 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : common.js (UTF-8)
 * @FileName       : common
 * Change history
 * @Author         : 조창희
 * @LastVersion    : 1.0
 *   2012-07-06 / 조창희 / 초기 작성
 *   2012-07-06 / 배광식 / setTableIndexNoHeader function 추가
 *   2012-08-03 / 황유진 / upperCase,Trim function 추가(checkValidations.js 삭제)
 */

/*
 * Function Description: 대상 테이블의 TR,TD 요소에 Index 주는 함수(크롬 대응용)
 * @author  조창희
 * @version 1.0
 * @param
 *          targetTable: 대상 테이블
 * @return
 */
function setTableIndex(targetTable) {
	for ( var ch = 1; ch < targetTable.rows.length; ch++) {
		targetTable.rows[ch].index = ch - 1;
		var trTag = targetTable.rows[ch];
		for ( var ch2 = 0; ch2 < trTag.cells.length; ch2++) {
			trTag.cells[ch2].index = ch - 1;
		}
	}
}
function setTableIndexNoHeader(targetTable) {
	for ( var ch = 0; ch < targetTable.rows.length; ch++) {
		targetTable.rows[ch].index = ch;
		var trTag = targetTable.rows[ch];
		for ( var ch2 = 0; ch2 < trTag.cells.length; ch2++) {
			trTag.cells[ch2].index = ch;
		}
	}
}
/**
 * @Function Description : 지정된 문자열을 대문자로 변환하는 function
 * @Param            : 1. str    : (String) 문자열
 * @return           : (String) 대문자로 적용된 String
 */
function upperCase(str) {
    if (str.length = 0 ) return "";
    else return str.toUpperCase();
}
/**
 * @Function Description : 공백제거 함수
 * @Param            : 1. str    : (String) 입력값
 * @return           : (String) 공백이 제거된 문자열(RTrim, LTrim 역활만)
 */
function Trim(str) { 
    var search = 0;
    while ( str.charAt(search) == " ") search = search + 1;
    str = str.substring(search, (str.length));
    search = str.length - 1 ;
    while (str.charAt(search) ==" ") search = search - 1;
    return str.substring(0, search + 1);
}
/**
 * @Function Description : body onload의 alert message
 * @Param            : 1. obj    : <input type=text> 
 * @return           : 
 */
function done_message(obj){
    if(Trim(obj.value)=="") return false;
    alert(obj.value);
    obj.value="";
}
