/*==============================================================================
*Copyright(c) 2003 POSCO/POSDATA
*@ProcessChain    : Reuse
*@File            : messcript.js
*@FileName        : REUSE 컴포넌트 JAVASCRIPT 파일.
*@LastModifyDate  : 2003-12-02 15:07:02
*@LastModifier    : 정창호
*@LastVersion     :
*=============================================================================*/


/*==============================================================================
*  messcript.js의 구성 목록 
*
*  showError.js
*  checkSelectBoxChecked.js
*  checkValidations.js
*  highlightRow.js
*  moveFieldCursor.js
*  moveListItem.js
*  moveTextBoxCursor.js
*  preventRetry.js
*  selectAll.js
*  setSelectValue.js
*  setTabOrder.js
*  showBubbleHelp.js
*  showCalendar.js
*  cellCopy.js
*  showHelp.js
*  showHighLowIndexArrow.js
*  showInsertableRow.js
*  showModalPopup.js
*  showMonthCalendar.js
*  showPopup.js
*  showSerial.js
*  showTree.js
*  totalOfCheckedItems.js
*
*  총 23개 입니다.
==============================================================================*/


/** showError.js */
function showError(msgCode,msgString,detailMsg)
{
var msgWindow;
msgWindow=window.open("",msgWindow,"toolbar=no,height=340,width=400,menubar=no ");
msgWindow.document.open("text/html","replace")
msgWindow.document.writeln("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
msgWindow.document.writeln("<html>           ");
msgWindow.document.writeln("<head>");
msgWindow.document.writeln("<title>ERROR페이지 입니다</title>");
msgWindow.document.writeln("<meta http-equiv=Content-Type content=text/html; charset=euc-kr\>");
msgWindow.document.writeln("</head>");
msgWindow.document.writeln("<style>");
msgWindow.document.writeln("table{font-size:13px;font-family:verdana,굴림;color:#333333}");
msgWindow.document.writeln("</style>");
msgWindow.document.writeln("<body leftmargin=0 topmargin=0>                    ");
msgWindow.document.writeln("<table width=400 border=0 cellspacing=0 cellpadding=0>");
msgWindow.document.writeln("  <tr>");
msgWindow.document.writeln("    <td><img src=/img/m000832img.gif width=400 height=61></td>    "  );
msgWindow.document.writeln("  </tr>");
msgWindow.document.writeln("  <tr>");
msgWindow.document.writeln("    <td><table width=400 border=0 cellspacing=0 cellpadding=0>");
msgWindow.document.writeln("        <tr>");
msgWindow.document.writeln("          <td><img src=/img/m000833img.gif width=128 height=33></td>");
msgWindow.document.writeln("          <td width=173 background=/img/m000829img.gif><strong><font color=#FF0000>"+msgCode+"</font></strong></td>");
msgWindow.document.writeln("          <td><img src=/img/m000834img.gif width=85 height=33></td>");
msgWindow.document.writeln("          <td><img src=/img/m000830img.gif width=15 height=33></td>");
msgWindow.document.writeln("        </tr>");
msgWindow.document.writeln("      </table></td>");
msgWindow.document.writeln("  </tr>");
msgWindow.document.writeln("  <tr>");
msgWindow.document.writeln("    <td height=214 background=/img/m000831img.gif><div style=\"LEFT:15px ; overflow:auto; position:absolute; width:370px;top:95; height:199px  \"><table width=350 height=214 border=0 align=center cellpadding=0 cellspacing=10>");
msgWindow.document.writeln("        <tr>");
msgWindow.document.writeln("          <td valign=top>"+msgString+"&nbsp;");
if(detailMsg!=undefined)
{
msgWindow.document.writeln("				<p>&nbsp;&nbsp; <strong>-</strong> &nbsp;"+detailMsg+"</font></td>");
}
else{
msgWindow.document.writeln("</font></td>");
}
msgWindow.document.writeln("            <p>&nbsp;</p>");
msgWindow.document.writeln("            </td>");
msgWindow.document.writeln("        </tr>");
msgWindow.document.writeln("      </table></div></td>");
msgWindow.document.writeln("  </tr>");
msgWindow.document.writeln("</table>");
msgWindow.document.writeln("<table><td><center><input type=image src=/img/m000005ico.gif onclick=javascript:window.close();></center></td></table>");
msgWindow.document.writeln("</body>");
msgWindow.document.writeln("</html>");
}


/** checkSelectBoxChecked.js */
function checkSelectbox(form) {
var chk = 0;
for(var i = 0; i < form.elements.length ; i++) {
if ((form.elements[i].type == "checkbox") && (form.elements[i].checked == true)) {
chk++;
}
}
if (chk == 0 ) {
return false;
} else {
return true;
}
}


/** checkValidations.js */
var NUM      = "0123456789";
var SALPHA   = "abcdefghijklmnopqrstuvwxyz";
var ALPHA    = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"+SALPHA;
var EMAIL    = "!#$%&*+-./=?@^_`{|}"+NUM+ALPHA;
var PASSWORD = "!@.#,$%^*&_-" + ALPHA + NUM;
var ERRORMSG = "";
var ETC      = ".,()[]" ;
var TELNO    = "-" + NUM;
var dayOfMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
function doNumberCheck() {
if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;
}
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
function getLastday(calyear,calmonth) {
if (((calyear % 4 == 0) && (calyear % 100 != 0))||(calyear % 400 == 0)) dayOfMonth[1] = 29;
var nDays = dayOfMonth[calmonth-1];
return nDays;
}
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
function getCurrentDate(sep) {
var today = new Date();
var t_year = today.getFullYear();
var t_mon  = today.getMonth()+1;
var t_day  = today.getDate();
if(t_mon.toString().length == 1) t_mon = "0" + t_mon;
if(t_day.toString().length == 1) t_day = "0" + t_day;
return ""+t_year+sep+t_mon+sep+t_day;
}
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
function isFutureDate(lsDate) {
var t_date = new String(lsDate);
var t_year, t_month, t_day;
checkValidDate(lsDate);
if (lsDate.length == 8 ) {
t_year  = parseInt(t_date.substring(0,4),10);
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
function isPastDate(lsDate) {
var t_date = new String(lsDate);
var t_year, t_month, t_day;
checkValidDate(lsDate);
if (lsDate.length == 8 ) {
t_year  = parseInt(t_date.substring(0,4),10);
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
function isCompareDate(preDate,nextDate) {
checkValidDate(preDate);
checkValidDate(nextDate);
preDate  = preDate.replace(/-/gi,"");
nextDate = nextDate.replace(/-/gi,"");
if (eval(preDate) > eval(nextDate) ) return false;
return true;
}
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
function calculateHour(preDate,nextDate,sep,gbn,dis) {
var Age,t_mon,t_min,t_d,t_h,t_m;
var t_day1, t_hour1, t_min1, t_day2, t_hour2, t_min2;
var re_value;
var temp = preDate.split(sep);
t_day1 = parseInt(temp[2].substring(0,2),10);
t_hour1 = parseInt(temp[2].substring(3,5),10);
t_min1 = parseInt(temp[2].substring(6,8),10);
t_date1 = Date.UTC(temp[0],temp[1],t_day1,t_hour1,t_min1,0);
temp = nextDate.split(sep);
t_day2 = parseInt(temp[2].substring(0,2),10);
t_hour2 = parseInt(temp[2].substring(3,5),10);
t_min2 = parseInt(temp[2].substring(6,8),10);
t_date2 = Date.UTC(temp[0],temp[1],t_day2,t_hour2,t_min2,0);
Age = t_date2-t_date1 + (1000*60*60*24*30);
t_mon = Math.floor(((Age/1000)/60)/(24*60*30))-1;
t_min = ((Age/1000)/60)%(24*60*30);
t_h = Math.floor(t_min/60);
t_d = Math.floor(t_h/24);
t_h = t_h%24;
t_m = t_min%60;
t_d = (t_mon*30)+t_d;
re_value = "";
if (t_d > 0) {
if (dis=="D") {
re_value =t_d+"일 ";
} else {
t_h = t_h + (t_d*24);
}
}
if ( gbn == "M" ) {
re_value = re_value+t_h+":"+t_m;
} else {
re_value = re_value+t_h+"."+((100*t_m)/60);
}
return re_value;
}
function formatDate(lsDate, sep) {
var t_temp;
var t_date = lsDate.split(sep);
if ((event.keyCode == 189) || (event.keyCode == 190) || (event.keyCode == 191) ) {
lsDate = lsDate.substring(0, lsDate.length -1);
}
if ( lsDate.length == 4 ) {
if (t_date[0] < 1900 || t_date[0] >2100)
return "";
else {
if (event.keyCode == 8) return lsDate; else return lsDate+sep;
}
} else if ( lsDate.length == 7 ) {
t_temp = parseInt(t_date[1],10);
if ( (t_temp < 1) || (t_temp > 12) )
return lsDate.substring(0,5);
else
if (event.keyCode == 8) return lsDate; else return lsDate+sep;
} else if ( lsDate.length > 9 ) {
t_temp = parseInt(t_date[2],10);
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
if (objTextValue[i] == '-')
{
dashCharNum++;
}
}
if (dashCharNum > 1)
{
return;
}
var returnStr = formatDate(objTextValue, '-');
objText.value = returnStr;
}
function formatMonth(lsDate, sep) {
var t_temp;
var t_date = lsDate.split(sep);
if ((event.keyCode == 189) || (event.keyCode == 190) || (event.keyCode == 191) ) {
lsDate = lsDate.substring(0, lsDate.length -1);
}
if ( lsDate.length == 4 ) {
if (t_date[0] < 1900 || t_date[0] >2100)
return "";
else {
if (event.keyCode == 8) return lsDate; else return lsDate+sep;
}
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
if ((event.keyCode == 189) || (event.keyCode == 190) || (event.keyCode == 191) ) {
lsDate = lsDate.substring(0, lsDate.length -1);
}
if ( lsDate.length == 4 ) {
if (lsDate < 1900 || lsDate >2100)
return "";
else {
if (event.keyCode == 8) return lsDate; else return lsDate+sep;
}
} else if ( lsDate.length == 7 ) {
t_temp = parseInt(lsDate.substring(5,7),10);
if ( (t_temp < 1) || (t_temp > 12) )
return lsDate.substring(0,5);
else
if (event.keyCode == 8) return lsDate; else return lsDate+sep;
} else if ( lsDate.length == 10 ) {
t_temp = parseInt(lsDate.substring(8,10),10);
if ( (t_temp < 1) || (t_temp > getLastday(lsDate.substring(0,4), parseInt(lsDate.substring(5,7),10) )))
return lsDate.substring(0,8);
else
if (event.keyCode == 8) return lsDate; else return lsDate+" ";
} else if ( lsDate.length == 13 ) {
t_temp = parseInt(lsDate.substring(11,13),10);
if ( (t_temp < 1) || (t_temp > 24) )
return lsDate.substring(0,11);
else
if (event.keyCode == 8) return lsDate; else return lsDate+":";
} else if ( lsDate.length == 16 ) {
t_temp = parseInt(t_date[1],10);
if ( (t_temp < 1) || (t_temp > 60) )
return lsDate.substring(0,14);
else
if (event.keyCode == 8) return lsDate; else return lsDate+":";
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
function isNull(str) {
if ((str.length == 0) && (Trim(str) == "") ) {
alert("해당 항목이 입력되지 않았습니다.");
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


/** highlightRow.js */
function in_ch (focus,st,oTable) {
var trtag = st;
var tdNum = trtag.childNodes.length;
var idx = parseInt(st.childNodes[0].index);
if (oTable != null && oTable != "") {
if(focus == 0) {
oTrtag = oTable.rows(idx);
if(oTrtag == null) return;
for(var i=0 ; i<tdNum ; i++) {
trtag.childNodes[i].style.backgroundColor = "#D9F8D9";
oTrtag.childNodes[i].style.backgroundColor = "#D9F8D9";
}
} else {
if (oTrtag == null) return;
for (var j=0 ; j<tdNum ; j++) {
trtag.childNodes[j].style.backgroundColor = "";
oTrtag.childNodes[j].style.backgroundColor = "";
}
}
} else {
if (focus == 0) {
for (var i=0 ; i<tdNum ; i++) {
trtag.childNodes[i].style.backgroundColor = "#D9F8D9";
}
} else {
for (var j=0 ; j<tdNum ; j++) {
trtag.childNodes[j].style.backgroundColor = "";
}
}
}
}
function hiRow(table_id, oTrtag, focus){
mHiRow(table_id.firstChild.firstChild,oTrtag,focus);
return false;
}
function mHiRow(trtag,oTrtag,focus) {
var idx = parseInt(oTrtag.childNodes[0].index);
if (trtag) {
if (trtag.nextSibling) mHiRow(trtag.nextSibling,oTrtag,focus);
if (trtag.childNodes[0].index && trtag.childNodes[0].index == idx) runHiRow(trtag, focus);
}
}
function runHiRow(trtag, focus) {
var tdNum = trtag.childNodes.length;
if(focus==0){
for(var i =0 ; i < tdNum ; i++){
trtag.childNodes[i].style.backgroundColor="#D9F8D9";
}
} else {
for(var j =0 ; j < tdNum ; j++){
trtag.childNodes[j].style.backgroundColor="";
}
}
}
function hiRowEx(table_id, oTrtag, focus){
mHiRowEx(table_id.firstChild.firstChild,oTrtag,focus);
return false;
}
function mHiRowEx(trtag,oTrtag,focus) {
var idx = oTrtag.childNodes[0].uniqueID;
if (trtag) {
if (trtag.nextSibling) mHiRowEx(trtag.nextSibling,oTrtag,focus);
if (trtag.childNodes[0].uniqueID && trtag.childNodes[0].uniqueID == idx) runHiRowEx(trtag, focus);
}
}
function runHiRowEx(trtag, focus)
{
var tdNum = trtag.childNodes.length;
if(focus==0)
{
for(var i =0 ; i < tdNum ; i++)
{
trtag.childNodes[i].style.backgroundColor="#D9F8D9";
}
}
else
{
for(var j =0 ; j < tdNum ; j++)
{
trtag.childNodes[j].style.backgroundColor="";
}
}
}


/** moveFieldCursor.js */
var totObj;
function moveFieldCursor(obj,idx,totCol)
{
var objLen;
var cnt = 0;
idx = parseInt(idx);
totCol = parseInt(totCol);
var keyCode = event.keyCode;
totObj  = document.forms[0].elements.length;
objLen = eval("document.forms[0]." + obj + ".length");
if(keyCode == 38){
moveUpCursor(obj,idx);
}//end if
if(keyCode == 40){
moveDownCursor(obj,idx);
}
if(keyCode == 37){
moveLeftCursor(obj,idx,totCol);
}
if(keyCode == 39){
moveRightCursor(obj,idx,totCol);
}
return;
}
function moveUpCursor(obj,idx){
if(eval("document.forms[0]." + obj + "[+idx-1]") != null){
eval("document.forms[0]." + obj + "[+idx-1].focus()");
}
return;
}
function moveDownCursor(obj,idx){
if(eval("document.forms[0]." + obj + "[+idx+1]") != null){
eval("document.forms[0]." + obj + "[+idx+1].focus()");
}
return;
}
function moveLeftCursor(obj,idx,totCol){
for(i=0; i < totObj; i++){
if(document.forms[0].elements[i].name == obj){
if(document.forms[0].elements[i + (idx * totCol) - 1] != null){
document.forms[0].elements[i + (idx * totCol) - 1].focus();
break;
}
}
}
return;
}
function moveRightCursor(obj,idx,totCol){
for(i=0; i < totObj; i++){
if(document.forms[0].elements[i].name == obj){
if(document.forms[0].elements[i + (idx * totCol) + 1] != null){
document.forms[0].elements[i + (idx * totCol) + 1].focus();
break;
}
}
}
return;
}


/** moveListItem.js */
function right_Select_Click(leftObj, rightObj){
alert(rightObj.length);
var idx = rightObj.length;
for(var i = 0; i < leftObj.length; i++){
if(leftObj.options[i].selected){
rightObj.length += 1;
rightObj.options[idx].text = leftObj.options[i].text;
rightObj.options[idx].value = leftObj.options[i].value;
leftObj.options[i] = null;
}
}
}
function left_Select_Click(leftObj, rightObj){
var idx = leftObj.length;
for(var i = 0; i < rightObj.length; i++){
if(rightObj.options[i].selected){
leftObj.length += 1;
leftObj.options[idx].text = rightObj.options[i].text;
leftObj.options[idx].value = rightObj.options[i].value;
rightObj.options[i] = null;
}
}
}
function up_Select_Click(upObj, downObj){
var idx = upObj.length;
for(var i = 0; i < downObj.length; i++){
if(downObj.options[i].selected){
upObj.length += 1;
upObj.options[idx].text = downObj.options[i].text;
upObj.options[idx].value = downObj.options[i].value;
downObj.options[i] = null;
}
}
}
function down_Select_Click(upObj, downObj){
var idx = downObj.length;
for(var i = 0; i < upObj.length; i++){
if(upObj.options[i].selected){
downObj.length += 1;
downObj.options[idx].text = upObj.options[i].text;
downObj.options[idx].value = upObj.options[i].value;
upObj.options[i] = null;
}
}
}
function oneStepUp(objItem) {
var item = objItem.selectedIndex;
if (item != 0){
var temp = objItem.options[item].text;
objItem.options[item].text = objItem.options[item-1].text;
objItem.options[item-1].text = temp;
objItem.options[item-1].selected =true;
}
}
function oneStepDown(objItem) {
var item = objItem.selectedIndex;
if (item < objItem.length){
var temp = objItem.options[item].text;
objItem.options[item].text = objItem.options[item+1].text;
objItem.options[item+1].text = temp;
objItem.options[item+1].selected =true;
objItem.options[item].selected =false;
}
}
var NewOption = new Array();
function arrangeList(SortField, obj){
if(NewOption.length == 0)
{
for(var i=0; i < SortField.options.length; i++)
{
NewOption[i] = new Option();
NewOption[i] = SortField.options[i];
}
}else{
NewOption.reverse();
}
while(SortField.options.length)
{
d = SortField.options.length - 1;
SortField.remove(d);
}
CombSort(NewOption, obj.value);
for(x=0; x < NewOption.length; x++)
{
SortField.options[x] = new Option();
SortField.options[x] = NewOption[x];
}
}
function CombSort(ArrIn, idx)
{
var SF, gap, j, flipped, top;
var temp = new Option();
SF = 2;
flipped = false;
gap = ArrIn.length;
do {
gap = gap / SF;
switch(gap)
{
case 0:
gap = 1;
break;
case 9:
case 10:
gap = 11;
break;
}
flipped = false;
top = ArrIn.length - gap;
top = Math.floor(top)	;
for(i=0; i<top; i++)
{
j = i + gap;
j = Math.round(j);
if(idx==1){
if (ArrIn[i].text.toLowerCase() > ArrIn[j].text.toLowerCase())
{
var temp = new Option();
temp = ArrIn[i];
ArrIn[i] = ArrIn[j];
ArrIn[j] = temp;
flipped = true;
}
}else {
if (ArrIn[i].text.toLowerCase() < ArrIn[j].text.toLowerCase())
{
var temp = new Option();
temp = ArrIn[i];
ArrIn[i] = ArrIn[j];
ArrIn[j] = temp;
flipped = true;
}
}
}
}while(flipped || (gap > 1));
}


/** moveTextBoxCursor.js */
function moveCursorInTable(formname, obj, nextObj, finalObj, max)
{
var idx = obj.parentElement.index;
if(obj.value.length >= max)
{
if(obj.name==finalObj[idx].name)
{
idx++;
}
if((nextObj[idx] == null) || (nextObj[idx].length == 0))
{
return;
}
else
if(nextObj[idx].type == 'text')
{
nextObj[idx].focus();
return;
}
}
}
function moveTextBoxCursor(formname, obj, num, max)
{
value = obj.value;
if(value.length >= max)
{
formname.elements[num].focus();
return;
}
}


/** preventRetry.js */
var onProcessing = null;
var isExport = false;
document.attachEvent('onmouseup',checkEvent);
function checkEvent()
{
if (event.srcElement.name != null && event.srcElement.type == "image" &&  event.srcElement.name.toUpperCase().indexOf("EXPORT")!= -1)
{
isExport = true;
}
else
{
isExport = false;
}
}
function checkRetry()
{
if (onProcessing == null)
{
if (event != null)
{
if (!isExport)
{
onProcessing = new Date();
}
}
else
{
onProcessing = new Date();
}
return true;
}
else
{
alert("처리중입니다.");
return false;
}
}


/** selectAll.js */
var selectAllVar = true
var selectAllFormVar = true
var selectAllDocVar = true
function selectAll(name)
{
for (var idx = 0; idx < name.length; idx++)
{
var element = name[idx];
if (element.type == "checkbox")
{
element.checked = selectAllVar;
}
}
if (selectAllVar == true)
{
selectAllVar = false;
}
else
{
selectAllVar = true;
}
return;
}
function selectAllForm(form)
{
for (var idx = 0; idx < form.elements.length; idx++)
{
var element = form.elements[idx];
if (element.type == "checkbox")
{
element.checked = selectAllFormVar
}
}
if (selectAllFormVar == true)
{
selectAllFormVar = false;
}
else
{
selectAllFormVar = true;
}
return;
}
function selectAllDoc()
{
for (var formIdx = 0; formIdx < document.forms.length; formIdx++)
{
var form = document.forms[formIdx];
for (var idx = 0; idx < form.elements.length; idx++)
{
var element = form.elements[idx];
if (element.type == "checkbox")
{
element.checked = selectAllDocVar
}
}
}
if (selectAllDocVar == true)
{
selectAllDocVar = false;
}
else
{
selectAllDocVar = true;
}
return;
}
function toggleAll(name)
{
for (var idx = 0; idx < name.length; idx++)
{
var element = name[idx];
if (element.type == "checkbox")
{
element.checked = !element.checked;
}
}
return;
}
function toggleAllForm(form)
{
for (var idx = 0; idx < form.elements.length; idx++)
{
var element = form.elements[idx];
if (element.type == "checkbox")
{
element.checked = !element.checked;
}
}
return;
}
function toggleAllDoc()
{
for (var formIdx = 0; formIdx < document.forms.length; formIdx++)
{
var form = document.forms[formIdx];
for (var idx = 0; idx < form.elements.length; idx++)
{
var element = form.elements[idx];
if (element.type == "checkbox")
{
element.checked = !element.checked;
}
}
}
return;
}


/** setSelectValue.js */
function setSelectValue(orijinObj,targetObj)
{
var selectIdx;
var orijinVal = eval("document.forms[0]."+orijinObj+".value");
var totObj = document.forms[0].elements.length;
for(i=0; i < totObj; i++){
if(document.forms[0].elements[i].name == targetObj){
document.forms[0].elements[i].value = orijinVal;
}//end if
}//end for
return;
}


/** setTabOrder.js */
function setTabOrderIdx(objIdx)
{
objInx = parseInt(objIdx);
var keyCode = event.keyCode;
var totObj  = document.forms[0].elements.length;
if(keyCode == 9){
for(i=0; i < totObj; i++){
if(i == objIdx){
document.forms[0].elements[i - 1].focus();
break;
}
}
}
return;
}
function setTabOrderObj(nextObj)
{
var idx;
var keyCode = event.keyCode;
var totObj  = document.forms[0].elements.length;
if(keyCode == 9){
for(i=0; i < totObj; i++){
if(document.forms[0].elements[i].name == nextObj){
document.forms[0].elements[i - 1].focus();
break;
}
}
}
return;
}


/** showBubbleHelp.js */
var INARRAY		=	1;
var CAPARRAY	=	2;
var STICKY		=	3;
var BACKGROUND	=	4;
var NOCLOSE		=	5;
var CAPTION		=	6;
var LEFT		=	7;
var RIGHT		=	8;
var CENTER		=	9;
var OFFSETX		=	10;
var OFFSETY		=	11;
var FGCOLOR		=	12;
var BGCOLOR		=	13;
var TEXTCOLOR	=	14;
var CAPCOLOR	=	15;
var CLOSECOLOR	=	16;
var WIDTH		=	17;
var BORDER		=	18;
var STATUS		=	19;
var AUTOSTATUS	=	20;
var AUTOSTATUSCAP	=	21;
var HEIGHT		=	22;
var CLOSETEXT	=	23;
var SNAPX		=	24;
var SNAPY		=	25;
var FIXX		=	26;
var FIXY		=	27;
var FGBACKGROUND	=	28;
var BGBACKGROUND	=	29;
var PADX		=	30; // PADX2 out
var PADY		=	31; // PADY2 out
var FULLHTML	=	34;
var ABOVE		=	35;
var BELOW		=	36;
var CAPICON		=	37;
var TEXTFONT	=	38;
var CAPTIONFONT	=	39;
var CLOSEFONT	=	40;
var TEXTSIZE	=	41;
var CAPTIONSIZE	=	42;
var CLOSESIZE	=	43;
var FRAME		=	44;
var TIMEOUT		=	45;
var FUNCTION	=	46;
var DELAY		=	47;
var HAUTO		=	48;
var VAUTO		=	49;
var CLOSECLICK	=	50;
var CSSOFF		=	51;
var CSSSTYLE	=	52;
var CSSCLASS	=	53;
var FGCLASS		=	54;
var BGCLASS		=	55;
var TEXTFONTCLASS	=	56;
var CAPTIONFONTCLASS	=	57;
var CLOSEFONTCLASS	=	58;
var PADUNIT		=	59;
var HEIGHTUNIT	=	60;
var WIDTHUNIT	=	61;
var TEXTSIZEUNIT	=	62;
var TEXTDECORATION	=	63;
var TEXTSTYLE		=	64;
var TEXTWEIGHT		=	65;
var CAPTIONSIZEUNIT	=	66;
var CAPTIONDECORATION	=	67;
var CAPTIONSTYLE	=	68;
var CAPTIONWEIGHT	=	69;
var CLOSESIZEUNIT	=	70;
var CLOSEDECORATION	=	71;
var CLOSESTYLE		=	72;
var CLOSEWEIGHT		=	73;
if (typeof ol_fgcolor == 'undefined') { var ol_fgcolor = "#efffef";}
if (typeof ol_bgcolor == 'undefined') { var ol_bgcolor = "#33993F";}
if (typeof ol_textcolor == 'undefined') { var ol_textcolor = "#000000";}
if (typeof ol_capcolor == 'undefined') { var ol_capcolor = "#FFFFFF";}
if (typeof ol_closecolor == 'undefined') { var ol_closecolor = "#9999FF";}
if (typeof ol_textfont == 'undefined') { var ol_textfont = "Verdana,Arial,Helvetica";}
if (typeof ol_captionfont == 'undefined') { var ol_captionfont = "Verdana,Arial,Helvetica";}
if (typeof ol_closefont == 'undefined') { var ol_closefont = "Verdana,Arial,Helvetica";}
if (typeof ol_textsize == 'undefined') { var ol_textsize = "1";}
if (typeof ol_captionsize == 'undefined') { var ol_captionsize = "1";}
if (typeof ol_closesize == 'undefined') { var ol_closesize = "1";}
if (typeof ol_width == 'undefined') { var ol_width = "300";}
if (typeof ol_border == 'undefined') { var ol_border = "1";}
if (typeof ol_offsetx == 'undefined') { var ol_offsetx = 10;}
if (typeof ol_offsety == 'undefined') { var ol_offsety = 10;}
if (typeof ol_text == 'undefined') { var ol_text = "Default Text"; }
if (typeof ol_cap == 'undefined') { var ol_cap = ""; }
if (typeof ol_sticky == 'undefined') { var ol_sticky = 0; }
if (typeof ol_background == 'undefined') { var ol_background = ""; }
if (typeof ol_close == 'undefined') { var ol_close = "Close"; }
if (typeof ol_hpos == 'undefined') { var ol_hpos = RIGHT; }
if (typeof ol_status == 'undefined') { var ol_status = ""; }
if (typeof ol_autostatus == 'undefined') { var ol_autostatus = 0; }
if (typeof ol_height == 'undefined') { var ol_height = -1; }
if (typeof ol_snapx == 'undefined') { var ol_snapx = 0; }
if (typeof ol_snapy == 'undefined') { var ol_snapy = 0; }
if (typeof ol_fixx == 'undefined') { var ol_fixx = -1; }
if (typeof ol_fixy == 'undefined') { var ol_fixy = -1; }
if (typeof ol_fgbackground == 'undefined') { var ol_fgbackground = ""; }
if (typeof ol_bgbackground == 'undefined') { var ol_bgbackground = ""; }
if (typeof ol_padxl == 'undefined') { var ol_padxl = 1; }
if (typeof ol_padxr == 'undefined') { var ol_padxr = 1; }
if (typeof ol_padyt == 'undefined') { var ol_padyt = 1; }
if (typeof ol_padyb == 'undefined') { var ol_padyb = 1; }
if (typeof ol_fullhtml == 'undefined') { var ol_fullhtml = 0; }
if (typeof ol_vpos == 'undefined') { var ol_vpos = BELOW; }
if (typeof ol_aboveheight == 'undefined') { var ol_aboveheight = 0; }
if (typeof ol_caption == 'undefined') { var ol_capicon = ""; }
if (typeof ol_frame == 'undefined') { var ol_frame = self; }
if (typeof ol_timeout == 'undefined') { var ol_timeout = 0; }
if (typeof ol_function == 'undefined') { var ol_function = Function(); }
if (typeof ol_delay == 'undefined') { var ol_delay = 0; }
if (typeof ol_hauto == 'undefined') { var ol_hauto = 0; }
if (typeof ol_vauto == 'undefined') { var ol_vauto = 0; }
if (typeof ol_closeclick == 'undefined') { var ol_closeclick = 0; }
if (typeof ol_css == 'undefined') { var ol_css = CSSOFF; }
if (typeof ol_fgclass == 'undefined') { var ol_fgclass = ""; }
if (typeof ol_bgclass == 'undefined') { var ol_bgclass = ""; }
if (typeof ol_textfontclass == 'undefined') { var ol_textfontclass = ""; }
if (typeof ol_captionfontclass == 'undefined') { var ol_captionfontclass = ""; }
if (typeof ol_closefontclass == 'undefined') { var ol_closefontclass = ""; }
if (typeof ol_padunit == 'undefined') { var ol_padunit = "px";}
if (typeof ol_heightunit == 'undefined') { var ol_heightunit = "px";}
if (typeof ol_widthunit == 'undefined') { var ol_widthunit = "px";}
if (typeof ol_textsizeunit == 'undefined') { var ol_textsizeunit = "px";}
if (typeof ol_textdecoration == 'undefined') { var ol_textdecoration = "none";}
if (typeof ol_textstyle == 'undefined') { var ol_textstyle = "normal";}
if (typeof ol_textweight == 'undefined') { var ol_textweight = "normal";}
if (typeof ol_captionsizeunit == 'undefined') { var ol_captionsizeunit = "px";}
if (typeof ol_captiondecoration == 'undefined') { var ol_captiondecoration = "none";}
if (typeof ol_captionstyle == 'undefined') { var ol_captionstyle = "normal";}
if (typeof ol_captionweight == 'undefined') { var ol_captionweight = "bold";}
if (typeof ol_closesizeunit == 'undefined') { var ol_closesizeunit = "px";}
if (typeof ol_closedecoration == 'undefined') { var ol_closedecoration = "none";}
if (typeof ol_closestyle == 'undefined') { var ol_closestyle = "normal";}
if (typeof ol_closeweight == 'undefined') { var ol_closeweight = "normal";}
if (typeof ol_texts == 'undefined') { var ol_texts = new Array("Text 0", "Text 1"); }
if (typeof ol_caps == 'undefined') { var ol_caps = new Array("Caption 0", "Caption 1"); }
var o3_text = "";
var o3_cap = "";
var o3_sticky = 0;
var o3_background = "";
var o3_close = "Close";
var o3_hpos = RIGHT;
var o3_offsetx = 2;
var o3_offsety = 2;
var o3_fgcolor = "";
var o3_bgcolor = "";
var o3_textcolor = "";
var o3_capcolor = "";
var o3_closecolor = "";
var o3_width = "";
var o3_border = 1;
var o3_status = "";
var o3_autostatus = 0;
var o3_height = -1;
var o3_snapx = 0;
var o3_snapy = 0;
var o3_fixx = -1;
var o3_fixy = -1;
var o3_fgbackground = "";
var o3_bgbackground = "";
var o3_padxl = 0;
var o3_padxr = 0;
var o3_padyt = 0;
var o3_padyb = 0;
var o3_fullhtml = 0;
var o3_vpos = BELOW;
var o3_aboveheight = 0;
var o3_capicon = "";
var o3_textfont = "Verdana,Arial,Helvetica";
var o3_captionfont = "Verdana,Arial,Helvetica";
var o3_closefont = "Verdana,Arial,Helvetica";
var o3_textsize = "1";
var o3_captionsize = "1";
var o3_closesize = "1";
var o3_frame = self;
var o3_timeout = 0;
var o3_timerid = 0;
var o3_allowmove = 0;
var o3_function = Function();
var o3_delay = 0;
var o3_delayid = 0;
var o3_hauto = 0;
var o3_vauto = 0;
var o3_closeclick = 0;
var o3_css = CSSOFF;
var o3_fgclass = "";
var o3_bgclass = "";
var o3_textfontclass = "";
var o3_captionfontclass = "";
var o3_closefontclass = "";
var o3_padunit = "px";
var o3_heightunit = "px";
var o3_widthunit = "px";
var o3_textsizeunit = "px";
var o3_textdecoration = "";
var o3_textstyle = "";
var o3_textweight = "";
var o3_captionsizeunit = "px";
var o3_captiondecoration = "";
var o3_captionstyle = "";
var o3_captionweight = "";
var o3_closesizeunit = "px";
var o3_closedecoration = "";
var o3_closestyle = "";
var o3_closeweight = "";
var o3_x = 0;
var o3_y = 0;
var o3_allow = 0;
var o3_showingsticky = 0;
var o3_removecounter = 0;
var over = null;
var ns4 = (document.layers)? true:false;
var ns6 = (document.getElementById)? true:false;
var ie4 = (document.all)? true:false;
var ie5 = false;
if (ie4) {
if ((navigator.userAgent.indexOf('MSIE 5') > 0) || (navigator.userAgent.indexOf('MSIE 6') > 0)) {
ie5 = true;
}
if (ns6) {
ns6 = false;
}
}
if ( (ns4) || (ie4) || (ns6)) {
document.onmousemove = mouseMove
if (ns4) document.captureEvents(Event.MOUSEMOVE)
} else {
overlib = no_overlib;
nd = no_overlib;
ver3fix = true;
}
function no_overlib() {
return ver3fix;
}
function tooltipOn() {
o3_text = ol_text;
o3_cap = ol_cap;
o3_sticky = ol_sticky;
o3_background = ol_background;
o3_close = ol_close;
o3_hpos = ol_hpos;
o3_offsetx = ol_offsetx;
o3_offsety = ol_offsety;
o3_fgcolor = ol_fgcolor;
o3_bgcolor = ol_bgcolor;
o3_textcolor = ol_textcolor;
o3_capcolor = ol_capcolor;
o3_closecolor = ol_closecolor;
o3_width = ol_width;
o3_border = ol_border;
o3_status = ol_status;
o3_autostatus = ol_autostatus;
o3_height = ol_height;
o3_snapx = ol_snapx;
o3_snapy = ol_snapy;
o3_fixx = ol_fixx;
o3_fixy = ol_fixy;
o3_fgbackground = ol_fgbackground;
o3_bgbackground = ol_bgbackground;
o3_padxl = ol_padxl;
o3_padxr = ol_padxr;
o3_padyt = ol_padyt;
o3_padyb = ol_padyb;
o3_fullhtml = ol_fullhtml;
o3_vpos = ol_vpos;
o3_aboveheight = ol_aboveheight;
o3_capicon = ol_capicon;
o3_textfont = ol_textfont;
o3_captionfont = ol_captionfont;
o3_closefont = ol_closefont;
o3_textsize = ol_textsize;
o3_captionsize = ol_captionsize;
o3_closesize = ol_closesize;
o3_timeout = ol_timeout;
o3_function = ol_function;
o3_delay = ol_delay;
o3_hauto = ol_hauto;
o3_vauto = ol_vauto;
o3_closeclick = ol_closeclick;
o3_css = ol_css;
o3_fgclass = ol_fgclass;
o3_bgclass = ol_bgclass;
o3_textfontclass = ol_textfontclass;
o3_captionfontclass = ol_captionfontclass;
o3_closefontclass = ol_closefontclass;
o3_padunit = ol_padunit;
o3_heightunit = ol_heightunit;
o3_widthunit = ol_widthunit;
o3_textsizeunit = ol_textsizeunit;
o3_textdecoration = ol_textdecoration;
o3_textstyle = ol_textstyle;
o3_textweight = ol_textweight;
o3_captionsizeunit = ol_captionsizeunit;
o3_captiondecoration = ol_captiondecoration;
o3_captionstyle = ol_captionstyle;
o3_captionweight = ol_captionweight;
o3_closesizeunit = ol_closesizeunit;
o3_closedecoration = ol_closedecoration;
o3_closestyle = ol_closestyle;
o3_closeweight = ol_closeweight;
if ( (ns4) || (ie4) || (ns6) ) {
o3_frame = ol_frame;
if (ns4) over = o3_frame.document.overDiv
if (ie4) over = o3_frame.overDiv.style
if (ns6) over = o3_frame.document.getElementById("overDiv");
}
var parsemode = -1;
var ar = arguments;
for (i = 0; i < ar.length; i++) {
if (parsemode < 0) {
if (ar[i] == INARRAY) {
o3_text = ol_texts[ar[++i]];
} else {
o3_text = ar[i];
}
parsemode = 0;
} else {
if (ar[i] == INARRAY) { o3_text = ol_texts[ar[++i]]; continue; }
if (ar[i] == CAPARRAY) { o3_cap = ol_caps[ar[++i]]; continue; }
if (ar[i] == STICKY) { o3_sticky = 1; continue; }
if (ar[i] == BACKGROUND) { o3_background = ar[++i]; continue; }
if (ar[i] == NOCLOSE) { o3_close = ""; continue; }
if (ar[i] == CAPTION) { o3_cap = ar[++i]; continue; }
if (ar[i] == CENTER || ar[i] == LEFT || ar[i] == RIGHT) { o3_hpos = ar[i]; continue; }
if (ar[i] == OFFSETX) { o3_offsetx = ar[++i]; continue; }
if (ar[i] == OFFSETY) { o3_offsety = ar[++i]; continue; }
if (ar[i] == FGCOLOR) { o3_fgcolor = ar[++i]; continue; }
if (ar[i] == BGCOLOR) { o3_bgcolor = ar[++i]; continue; }
if (ar[i] == TEXTCOLOR) { o3_textcolor = ar[++i]; continue; }
if (ar[i] == CAPCOLOR) { o3_capcolor = ar[++i]; continue; }
if (ar[i] == CLOSECOLOR) { o3_closecolor = ar[++i]; continue; }
if (ar[i] == WIDTH) { o3_width = ar[++i]; continue; }
if (ar[i] == BORDER) { o3_border = ar[++i]; continue; }
if (ar[i] == STATUS) { o3_status = ar[++i]; continue; }
if (ar[i] == AUTOSTATUS) { o3_autostatus = 1; continue; }
if (ar[i] == AUTOSTATUSCAP) { o3_autostatus = 2; continue; }
if (ar[i] == HEIGHT) { o3_height = ar[++i]; o3_aboveheight = ar[i]; continue; } // Same param again.
if (ar[i] == CLOSETEXT) { o3_close = ar[++i]; continue; }
if (ar[i] == SNAPX) { o3_snapx = ar[++i]; continue; }
if (ar[i] == SNAPY) { o3_snapy = ar[++i]; continue; }
if (ar[i] == FIXX) { o3_fixx = ar[++i]; continue; }
if (ar[i] == FIXY) { o3_fixy = ar[++i]; continue; }
if (ar[i] == FGBACKGROUND) { o3_fgbackground = ar[++i]; continue; }
if (ar[i] == BGBACKGROUND) { o3_bgbackground = ar[++i]; continue; }
if (ar[i] == PADX) { o3_padxl = ar[++i]; o3_padxr = ar[++i]; continue; }
if (ar[i] == PADY) { o3_padyt = ar[++i]; o3_padyb = ar[++i]; continue; }
if (ar[i] == FULLHTML) { o3_fullhtml = 1; continue; }
if (ar[i] == BELOW || ar[i] == ABOVE) { o3_vpos = ar[i]; continue; }
if (ar[i] == CAPICON) { o3_capicon = ar[++i]; continue; }
if (ar[i] == TEXTFONT) { o3_textfont = ar[++i]; continue; }
if (ar[i] == CAPTIONFONT) { o3_captionfont = ar[++i]; continue; }
if (ar[i] == CLOSEFONT) { o3_closefont = ar[++i]; continue; }
if (ar[i] == TEXTSIZE) { o3_textsize = ar[++i]; continue; }
if (ar[i] == CAPTIONSIZE) { o3_captionsize = ar[++i]; continue; }
if (ar[i] == CLOSESIZE) { o3_closesize = ar[++i]; continue; }
if (ar[i] == FRAME) { opt_FRAME(ar[++i]); continue; }
if (ar[i] == TIMEOUT) { o3_timeout = ar[++i]; continue; }
if (ar[i] == FUNCTION) { opt_FUNCTION(ar[++i]); continue; }
if (ar[i] == DELAY) { o3_delay = ar[++i]; continue; }
if (ar[i] == HAUTO) { o3_hauto = (o3_hauto == 0) ? 1 : 0; continue; }
if (ar[i] == VAUTO) { o3_vauto = (o3_vauto == 0) ? 1 : 0; continue; }
if (ar[i] == CLOSECLICK) { o3_closeclick = (o3_closeclick == 0) ? 1 : 0; continue; }
if (ar[i] == CSSOFF) { o3_css = ar[i]; continue; }
if (ar[i] == CSSSTYLE) { o3_css = ar[i]; continue; }
if (ar[i] == CSSCLASS) { o3_css = ar[i]; continue; }
if (ar[i] == FGCLASS) { o3_fgclass = ar[++i]; continue; }
if (ar[i] == BGCLASS) { o3_bgclass = ar[++i]; continue; }
if (ar[i] == TEXTFONTCLASS) { o3_textfontclass = ar[++i]; continue; }
if (ar[i] == CAPTIONFONTCLASS) { o3_captionfontclass = ar[++i]; continue; }
if (ar[i] == CLOSEFONTCLASS) { o3_closefontclass = ar[++i]; continue; }
if (ar[i] == PADUNIT) { o3_padunit = ar[++i]; continue; }
if (ar[i] == HEIGHTUNIT) { o3_heightunit = ar[++i]; continue; }
if (ar[i] == WIDTHUNIT) { o3_widthunit = ar[++i]; continue; }
if (ar[i] == TEXTSIZEUNIT) { o3_textsizeunit = ar[++i]; continue; }
if (ar[i] == TEXTDECORATION) { o3_textdecoration = ar[++i]; continue; }
if (ar[i] == TEXTSTYLE) { o3_textstyle = ar[++i]; continue; }
if (ar[i] == TEXTWEIGHT) { o3_textweight = ar[++i]; continue; }
if (ar[i] == CAPTIONSIZEUNIT) { o3_captionsizeunit = ar[++i]; continue; }
if (ar[i] == CAPTIONDECORATION) { o3_captiondecoration = ar[++i]; continue; }
if (ar[i] == CAPTIONSTYLE) { o3_captionstyle = ar[++i]; continue; }
if (ar[i] == CAPTIONWEIGHT) { o3_captionweight = ar[++i]; continue; }
if (ar[i] == CLOSESIZEUNIT) { o3_closesizeunit = ar[++i]; continue; }
if (ar[i] == CLOSEDECORATION) { o3_closedecoration = ar[++i]; continue; }
if (ar[i] == CLOSESTYLE) { o3_closestyle = ar[++i]; continue; }
if (ar[i] == CLOSEWEIGHT) { o3_closeweight = ar[++i]; continue; }
}
}
if (o3_delay == 0) {
return overlib350();
} else {
o3_delayid = setTimeout("overlib350()", o3_delay);
if (o3_sticky) {
return false;
} else {
return true;
}
}
}
function tooltipOff() {
if ( o3_removecounter >= 1 ) { o3_showingsticky = 0 };
if ( (ns4) || (ie4) || (ns6) ) {
if ( o3_showingsticky == 0 ) {
o3_allowmove = 0;
if (over != null) hideObject(over);
} else {
o3_removecounter++;
}
}
return true;
}
function overlib350() {
var layerhtml;
if (o3_background != "" || o3_fullhtml) {
layerhtml = ol_content_background(o3_text, o3_background, o3_fullhtml);
} else {
if (o3_fgbackground != "" && o3_css == CSSOFF) {
o3_fgbackground = "BACKGROUND=\""+o3_fgbackground+"\"";
}
if (o3_bgbackground != "" && o3_css == CSSOFF) {
o3_bgbackground = "BACKGROUND=\""+o3_bgbackground+"\"";
}
if (o3_fgcolor != "" && o3_css == CSSOFF) {
o3_fgcolor = "BGCOLOR=\""+o3_fgcolor+"\"";
}
if (o3_bgcolor != "" && o3_css == CSSOFF) {
o3_bgcolor = "BGCOLOR=\""+o3_bgcolor+"\"";
}
if (o3_height > 0 && o3_css == CSSOFF) {
o3_height = "HEIGHT=" + o3_height;
} else {
o3_height = "";
}
if (o3_cap == "") {
layerhtml = ol_content_simple(o3_text);
} else {
if (o3_sticky) {
layerhtml = ol_content_caption(o3_text, o3_cap, o3_close);
} else {
layerhtml = ol_content_caption(o3_text, o3_cap, "");
}
}
}
if (o3_sticky) {
o3_showingsticky = 1;
o3_removecounter = 0;
}
layerWrite(layerhtml);
if (o3_autostatus > 0) {
o3_status = o3_text;
if (o3_autostatus > 1) {
o3_status = o3_cap;
}
}
o3_allowmove = 0;
if (o3_timeout > 0) {
if (o3_timerid > 0) clearTimeout(o3_timerid);
o3_timerid = setTimeout("cClick()", o3_timeout);
}
disp(o3_status);
if (o3_sticky) {
o3_allowmove = 0;
return false;
} else {
return true;
}
}
function ol_content_simple(text) {
if (o3_css == CSSCLASS) txt = "<TABLE WIDTH="+o3_width+" BORDER=0 CELLPADDING="+o3_border+" CELLSPACING=0 class=\""+o3_bgclass+"\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 class=\""+o3_fgclass+"\"><TR><TD VALIGN=TOP><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if (o3_css == CSSSTYLE) txt = "<TABLE WIDTH="+o3_width+" BORDER=0 CELLPADDING="+o3_border+" CELLSPACING=0 style=\"background-color: "+o3_bgcolor+"; height: "+o3_height+o3_heightunit+";\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 style=\"color: "+o3_fgcolor+"; background-color: "+o3_fgcolor+"; height: "+o3_height+o3_heightunit+";\"><TR><TD VALIGN=TOP><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if (o3_css == CSSOFF) txt = "<TABLE WIDTH="+o3_width+" BORDER=0 CELLPADDING="+o3_border+" CELLSPACING=0 "+o3_bgcolor+" "+o3_height+"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 "+o3_fgcolor+" "+o3_fgbackground+" "+o3_height+"><TR><TD VALIGN=TOP><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
set_background("");
return txt;
}
function ol_content_caption(text, title, close) {
closing = "";
closeevent = "onMouseOver";
if (o3_closeclick == 1) closeevent = "onClick";
if (o3_capicon != "") o3_capicon = "<IMG SRC=\""+o3_capicon+"\"> ";
if (close != "") {
if (o3_css == CSSCLASS) closing = "<TD ALIGN=RIGHT><A HREF=\"/\" "+closeevent+"=\"return cClick();\" class=\""+o3_closefontclass+"\">"+close+"</A></TD>";
if (o3_css == CSSSTYLE) closing = "<TD ALIGN=RIGHT><A HREF=\"/\" "+closeevent+"=\"return cClick();\" style=\"color: "+o3_closecolor+"; font-family: "+o3_closefont+"; font-size: "+o3_closesize+o3_closesizeunit+"; text-decoration: "+o3_closedecoration+"; font-weight: "+o3_closeweight+"; font-style:"+o3_closestyle+";\">"+close+"</A></TD>";
if (o3_css == CSSOFF) closing = "<TD ALIGN=RIGHT><A HREF=\"/\" "+closeevent+"=\"return cClick();\"><FONT COLOR=\""+o3_closecolor+"\" FACE=\""+o3_closefont+"\" SIZE=\""+o3_closesize+"\">"+close+"</FONT></A></TD>";
}
if (o3_css == CSSCLASS) txt = "<TABLE WIDTH="+o3_width+" BORDER=0 CELLPADDING="+o3_border+" CELLSPACING=0 class=\""+o3_bgclass+"\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+o3_capicon+title+"</FONT></TD>"+closing+"</TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 class=\""+o3_fgclass+"\"><TR><TD VALIGN=TOP><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if (o3_css == CSSSTYLE) txt = "<TABLE WIDTH="+o3_width+" BORDER=0 CELLPADDING="+o3_border+" CELLSPACING=0 style=\"background-color: "+o3_bgcolor+"; background-image: url("+o3_bgbackground+"); height: "+o3_height+o3_heightunit+";\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+o3_capicon+title+"</FONT></TD>"+closing+"</TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 style=\"color: "+o3_fgcolor+"; background-color: "+o3_fgcolor+"; height: "+o3_height+o3_heightunit+";\"><TR><TD VALIGN=TOP><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if (o3_css == CSSOFF) txt = "<TABLE WIDTH="+o3_width+" BORDER=0 CELLPADDING="+o3_border+" CELLSPACING=0 "+o3_bgcolor+" "+o3_bgbackground+" "+o3_height+"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=1><TR><TD align=center><B><FONT style=\"font-size: 9pt; font-family: 굴림체, arial; color:#FFFFFF;\">"+o3_capicon+title+"</FONT></B></TD>"+closing+"</TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 "+o3_fgcolor+" "+o3_fgbackground+" "+o3_height+"><TR><TD VALIGN=TOP><FONT style=\"font-size: 9pt; font-family: 굴림체, arial;\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
set_background("");
return txt;
}
function ol_content_background(text, picture, hasfullhtml) {
if (hasfullhtml) {
txt = text;
} else {
if (o3_css == CSSCLASS) txt = "<TABLE WIDTH="+o3_width+o3_widthunit+" BORDER=0 CELLPADDING=0 CELLSPACING=0 HEIGHT="+o3_height+o3_heightunit+"><TR><TD COLSPAN=3 HEIGHT="+o3_padyt+o3_padunit+"></TD></TR><TR><TD WIDTH="+o3_padxl+o3_padunit+"></TD><TD VALIGN=TOP WIDTH="+(o3_width-o3_padxl-o3_padxr)+o3_padunit+"><FONT class=\""+o3_textfontclass+"\">"+text+"</FONT></TD><TD WIDTH="+o3_padxr+o3_padunit+"></TD></TR><TR><TD COLSPAN=3 HEIGHT="+o3_padyb+o3_padunit+"></TD></TR></TABLE>";
if (o3_css == CSSSTYLE) txt = "<TABLE WIDTH="+o3_width+o3_widthunit+" BORDER=0 CELLPADDING=0 CELLSPACING=0 HEIGHT="+o3_height+o3_heightunit+"><TR><TD COLSPAN=3 HEIGHT="+o3_padyt+o3_padunit+"></TD></TR><TR><TD WIDTH="+o3_padxl+o3_padunit+"></TD><TD VALIGN=TOP WIDTH="+(o3_width-o3_padxl-o3_padxr)+o3_padunit+"><FONT style=\"font-family: "+o3_textfont+"; color: "+o3_textcolor+"; font-size: "+o3_textsize+o3_textsizeunit+";\">"+text+"</FONT></TD><TD WIDTH="+o3_padxr+o3_padunit+"></TD></TR><TR><TD COLSPAN=3 HEIGHT="+o3_padyb+o3_padunit+"></TD></TR></TABLE>";
if (o3_css == CSSOFF) txt = "<TABLE WIDTH="+o3_width+" BORDER=0 CELLPADDING=0 CELLSPACING=0 HEIGHT="+o3_height+"><TR><TD COLSPAN=3 HEIGHT="+o3_padyt+"></TD></TR><TR><TD WIDTH="+o3_padxl+"></TD><TD VALIGN=TOP WIDTH="+(o3_width-o3_padxl-o3_padxr)+"><FONT FACE=\""+o3_textfont+"\" COLOR=\""+o3_textcolor+"\" SIZE=\""+o3_textsize+"\">"+text+"</FONT></TD><TD WIDTH="+o3_padxr+"></TD></TR><TR><TD COLSPAN=3 HEIGHT="+o3_padyb+"></TD></TR></TABLE>";
}
set_background(picture);
return txt;
}
function set_background(pic) {
if (pic == "") {
if (ie4) over.backgroundImage = "none";
if (ns6) over.style.backgroundImage = "none";
} else {
if (ns4) {
over.background.src = pic;
} else if (ie4) {
over.backgroundImage = "url("+pic+")";
} else if (ns6) {
over.style.backgroundImage = "url("+pic+")";
}
}
}
function disp(statustext) {
if ( (ns4) || (ie4) || (ns6) ) {
if (o3_allowmove == 0) 	{
placeLayer();
showObject(over);
o3_allowmove = 1;
}
}
if (statustext != "") {
self.status = statustext;
}
}
function placeLayer() {
var placeX, placeY;
if (o3_fixx > -1) {
placeX = o3_fixx;
} else {
winoffset = (ie4) ? o3_frame.document.body.scrollLeft : o3_frame.pageXOffset;
if (ie4) iwidth = o3_frame.document.body.clientWidth;
if (ns4) iwidth = o3_frame.innerWidth; // was screwed in mozilla, fixed now?
if (ns6) iwidth = o3_frame.outerWidth;
if (o3_hauto == 1) {
if ( (o3_x - winoffset) > ((eval(iwidth)) / 2)) {
o3_hpos = LEFT;
} else {
o3_hpos = RIGHT;
}
}
if (o3_hpos == CENTER) { // Center
placeX = o3_x+o3_offsetx-(o3_width/2);
}
if (o3_hpos == RIGHT) { // Right
placeX = o3_x+o3_offsetx;
if ( (eval(placeX) + eval(o3_width)) > (winoffset + iwidth) ) {
placeX = iwidth + winoffset - o3_width;
if (placeX < 0) placeX = 0;
}
}
if (o3_hpos == LEFT) { // Left
placeX = o3_x-o3_offsetx-o3_width;
if (placeX < winoffset) placeX = winoffset;
}
if (o3_snapx > 1) {
var snapping = placeX % o3_snapx;
if (o3_hpos == LEFT) {
placeX = placeX - (o3_snapx + snapping);
} else {
placeX = placeX + (o3_snapx - snapping);
}
if (placeX < winoffset) placeX = winoffset;
}
}
if (o3_fixy > -1) {
placeY = o3_fixy;
} else {
scrolloffset = (ie4) ? o3_frame.document.body.scrollTop : o3_frame.pageYOffset;
if (o3_vauto == 0) {
if (ie4) iheight = o3_frame.document.body.clientHeight;
if (ns4) iheight = o3_frame.innerHeight;
if (ns6) iheight = o3_frame.outerHeight;
iheight = (eval(iheight)) / 2;
if ( (o3_y - scrolloffset) > iheight) {
o3_vpos = ABOVE;
} else {
o3_vpos = BELOW;
}
}
if (o3_vpos == ABOVE) {
if (o3_aboveheight == 0) {
var divref = (ie4) ? o3_frame.document.all['overDiv'] : over;
o3_aboveheight = (ns4) ? divref.clip.height : divref.offsetHeight;
}
placeY = o3_y - (o3_aboveheight + o3_offsety);
if (placeY < scrolloffset) placeY = scrolloffset;
} else {
placeY = o3_y + o3_offsety;
}
if (o3_snapy > 1) {
var snapping = placeY % o3_snapy;
if (o3_aboveheight > 0 && o3_vpos == ABOVE) {
placeY = placeY - (o3_snapy + snapping);
} else {
placeY = placeY + (o3_snapy - snapping);
}
if (placeY < scrolloffset) placeY = scrolloffset;
}
}
repositionTo(over, placeX, placeY);
}
function mouseMove(e) {
if ( (ns4) || (ns6) ) {o3_x=e.pageX; o3_y=e.pageY;}
if (ie4) {o3_x=event.x; o3_y=event.y;}
if (ie5) {o3_x=event.x+o3_frame.document.body.scrollLeft; o3_y=event.y+o3_frame.document.body.scrollTop;}
if (o3_allowmove == 1) {
placeLayer();
}
}
function cClick() {
hideObject(over);
o3_showingsticky = 0;
return false;
}
function compatibleframe(frameid) {
if (ns4) {
if (typeof frameid.document.overDiv =='undefined') return false;
} else if (ie4) {
if (typeof frameid.document.all["overDiv"] =='undefined') return false;
} else if (ns6) {
if (frameid.document.getElementById('overDiv') == null) return false;
}
return true;
}
function layerWrite(txt) {
txt += "\n";
if (ns4) {
var lyr = o3_frame.document.overDiv.document
lyr.write(txt)
lyr.close()
} else if (ie4) {
o3_frame.document.all["overDiv"].innerHTML = txt
} else if (ns6) {
range = o3_frame.document.createRange();
range.setStartBefore(over);
domfrag = range.createContextualFragment(txt);
while (over.hasChildNodes()) {
over.removeChild(over.lastChild);
}
over.appendChild(domfrag);
}
}
function showObject(obj) {
if (ns4) obj.visibility = "show";
else if (ie4) obj.visibility = "visible";
else if (ns6) obj.style.visibility = "visible";
}
function hideObject(obj) {
if (ns4) obj.visibility = "hide";
else if (ie4) obj.visibility = "hidden";
else if (ns6) obj.style.visibility = "hidden";
if (o3_timerid > 0) clearTimeout(o3_timerid);
if (o3_delayid > 0) clearTimeout(o3_delayid);
o3_timerid = 0;
o3_delayid = 0;
self.status = "";
}
function repositionTo(obj,xL,yL) {
if ( (ns4) || (ie4) ) {
obj.left = xL;
obj.top = yL;
} else if (ns6) {
obj.style.left = xL + "px";
obj.style.top = yL+ "px";
}
}
function opt_FRAME(frm) {
o3_frame = compatibleframe(frm) ? frm : ol_frame;
if ( (ns4) || (ie4 || (ns6)) ) {
if (ns4) over = o3_frame.document.overDiv;
if (ie4) over = o3_frame.overDiv.style;
if (ns6) over = o3_frame.document.getElementById("overDiv");
}
return 0;
}
function opt_FUNCTION(callme) {
o3_text = callme()
return 0;
}
function vpos_convert(d) {
if (d == 0) {
d = LEFT;
} else {
if (d == 1) {
d = RIGHT;
} else {
d = CENTER;
}
}
return d;
}
function dts(d,text) {
o3_hpos = vpos_convert(d);
overlib(text, o3_hpos, CAPTION, "");
}
function dtc(d,text,title) {
o3_hpos = vpos_convert(d);
overlib(text, CAPTION, title, o3_hpos);
}
function stc(d,text,title) {
o3_hpos = vpos_convert(d);
overlib(text, CAPTION, title, o3_hpos, STICKY);
}
function drs(text) {
dts(1,text);
}
function drc(text,title) {
dtc(1,text,title);
}
function src(text,title) {
stc(1,text,title);
}
function dls(text) {
dts(0,text);
}
function dlc(text,title) {
dtc(0,text,title);
}
function slc(text,title) {
stc(0,text,title);
}
function dcs(text) {
dts(2,text);
}
function dcc(text,title) {
dtc(2,text,title);
}
function scc(text,title) {
stc(2,text,title);
}


/** showCalendar.js */
var weekend = [0];
var weekend2 = [6];
var closeScript="";
var modal="";
var checkDate="";
var weekendColor = "#FFE1E2";
var fontface = "arial";
var fontsize = "9pt";
var gNow = new Date();
var ggWinCal;
var gCal, gCal2;
var showCalendar_close_flag;
var	second_p_year;
var	second_p_month;
Calendar.Months = ["1 월", "2 월", "3 월", "4 월", "5 월", "6 월", "7 월", "8 월", "9 월", "10 월", "11 월", "12 월"];
Calendar.DOMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
Calendar.lDOMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
function Calendar(p_item, p_WinCal, p_month, p_year, p_format, p_many, hh_sel, mi_sel, p_time) {
this.gYear				= p_year;
this.gFormat			= p_format;
this.gBGColor			= "gray";
this.gFGColor			= "black";
this.gTextColor		    = "black";
this.gHeaderColor       = "black";
this.gReturnItem	    = p_item;
this.checkValue         = false;
this.vCode1		        = "";
this.prevMMYYYY ;
this.prevMM 		;
this.prevYYYY   ;
this.nextMMYYYY ;
this.nextMM 		;
this.nextYYYY 	;
this.ghh_sel    ;
this.gmi_sel    ;
this.getMonth = function(monthNo) {
return Calendar.Months[monthNo];
}
this.init = function(p_item, p_WinCal, p_month, p_year, p_format, hh_sel, mi_sel, p_time){
if ((p_month == null) && (p_year == null))  return;
if (p_WinCal == null) {
this.gWinCal = ggWinCal;
}else {
this.gWinCal = p_WinCal;
}
if (hh_sel == null) {
this.ghh_sel = null;
}else {
this.ghh_sel = hh_sel;
}
if (p_year == null) {
this.gYear = null;
}else {
this.gYear = p_year;
}
if (mi_sel == null) {
this.gmi_sel = null;
}else {
this.gmi_sel = mi_sel;
}
if(p_time){
this.checkValue = true;
}else{
this.checkValue = false;
}
if (p_month == null) {
this.gMonthName = null;
this.gMonth = null;
this.gYearly = true;
} else {
this.gMonth = new Number(p_month);
this.gMonthName = this.getMonth(this.gMonth);
this.gYearly = false;
}
this.vCode1 = "";
}
this.formatData = function(p_day) {
var vData;
var vMonth = 1 + this.gMonth;
vMonth = (vMonth.toString().length < 2) ? "0" + vMonth : vMonth;
var vMon = this.getMonth(this.gMonth).substr(0,3).toUpperCase();
var vFMon = this.getMonth(this.gMonth).toUpperCase();
var vY4 = new String(this.gYear);
var vY2 = new String(this.gYear.substr(2,2));
var vDD = (p_day.toString().length < 2) ? "0" + p_day : p_day;
switch (this.gFormat) {
case "YYYY" :
vData = vY4 ;
break;
case "YYYY-MM" :
vData = vY4 + "-" + vMonth ;
break;
case "YYYY-MM-DD" :
vData = vY4 + "-" + vMonth + "-" + vDD;
break;
case "YYYY-MM-DD HH" :
vData = vY4 + "-" + vMonth + "-" + vDD +" HH";
break;
case "YYYY-MM-DD HH:MM" :
vData = vY4 + "-" + vMonth + "-" + vDD +" HH:MM";
break;
case "YYYY-MM-DD HH:MM:SS" :
vData = vY4 + "-" + vMonth + "-" + vDD +" HH:MM:SS";
break;
default :
vData = vY4 + "-" + vMonth + "-" + vDD;
}
return vData;
}
this.formatDay = function(vday) {
var vNowDay   = gNow.getDate();
var vNowMonth = gNow.getMonth();
var vNowYear  = gNow.getFullYear();
if (vday == vNowDay && this.gMonth == vNowMonth && this.gYear == vNowYear) {
return ("<FONT COLOR=\'#FF686C\'>" + vday + "</FONT>");
}else {
return (vday);
}
}
this.writeWeekendString = function(vday) {
var i;
for (i=0; i<weekend.length; i++) {
if ((vday == weekend[i])||(vday == weekend2[i])) {
return (" BGCOLOR=\"" + weekendColor + "\"");
}
}
return "";
}
this.getDaysOfMonth = function(monthNo, p_year) {
if ((p_year % 4) == 0) {
if ((p_year % 100) == 0 && (p_year % 400) != 0){
return Calendar.DOMonth[monthNo];
}
return Calendar.lDOMonth[monthNo];
} else
return Calendar.DOMonth[monthNo];
}
this.calcMonthYear = function(p_Month, p_Year, incr) {
var ret_arr = new Array();
if (incr == -1) {
if (p_Month == 0) {
ret_arr[0] = 11;
ret_arr[1] = parseInt(p_Year) - 1;
}
else {
ret_arr[0] = parseInt(p_Month) - 1;
ret_arr[1] = parseInt(p_Year);
}
} else if (incr == 1) {
if (p_Month == 11) {
ret_arr[0] = 0;
ret_arr[1] = parseInt(p_Year) + 1;
}
else {
ret_arr[0] = parseInt(p_Month) + 1;
ret_arr[1] = parseInt(p_Year);
}
}
return ret_arr;
}
this.show = function(objName, p_many, timeObj ,mm,yy) {
prevMMYYYY		= this.calcMonthYear( this.gMonth, this.gYear, -1);
this.prevMM 	= prevMMYYYY[0];
this.prevYYYY = prevMMYYYY[1];
nextMMYYYY		= this.calcMonthYear( this.gMonth, this.gYear, 1);
this.nextMM 	= nextMMYYYY[0];
this.nextYYYY = nextMMYYYY[1];
this.vCode1 = this.vCode1 + ("<td valign=top>\n");
this.vCode1 = this.vCode1 + ("<div align=center><FONT FACE='" + fontface +
"' SIZE=3><B>\n");
this.vCode1 = this.vCode1 + (this.gYear + " 년 " + this.gMonthName);
this.vCode1 = this.vCode1 + ("</B></FONT></div><P>\n");
this.vCode1 = this.vCode1 + ("<TABLE WIDTH='100%' BORDER=0 CELLSPACING=0 CELLPADDING=0 ALIGN='CENTER'>\n<TR>\n<TD ALIGN=center>\n");
if(p_many == 2){
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.gMonth + "', '" +
(parseInt(this.gYear)-1) + "', '" + this.gFormat + "', '" +
this.gReturnItem + "', " + p_many + ", document." + timeObj +
"Form1." + timeObj +"_hh_sel.value , document." + timeObj +
"Form1." + timeObj +"_mi_sel.value, "+ this.checkValue +", false); \"" +
" ><IMG SRC='img/gm0014img.gif' BORDER=0 >  <\/A></TD><TD ALIGN=center>\n");
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.prevMM + "', '" + this.prevYYYY + "', '"
+ this.gFormat + "', '" + this.gReturnItem + "', " + p_many +
", document." + timeObj +"Form1." + timeObj +"_hh_sel.value , document." +
timeObj +"Form1." + timeObj +"_mi_sel.value, "+ this.checkValue +", false); \"" +
"><IMG SRC='img/gm0015img.gif' BORDER=0><\/A></TD><TD ALIGN=center>\n");
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.nextMM + "', '" + this.nextYYYY + "', '"
+ this.gFormat + "', '" + this.gReturnItem + "', " + p_many +
", document." + timeObj +"Form1." + timeObj +"_hh_sel.value, document." +
timeObj +"Form1." + timeObj +"_mi_sel.value, "+ this.checkValue +", false); \"" +
"><IMG SRC='img/gm0016img.gif' BORDER=0><\/A></TD><TD ALIGN=center>\n");
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)+1)
+ "', '" + this.gFormat + "', '" + this.gReturnItem + "', " + p_many +
", document." + timeObj +"Form1." + timeObj +"_hh_sel.value, document." +
timeObj +"Form1." + timeObj +"_mi_sel.value, "+ this.checkValue +", false); \"" +
"><IMG SRC='img/gm0017img.gif' BORDER=0><\/A></TD></TR></TABLE><BR>\n");
}
else{
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)-1)
+ "', '" + this.gFormat + "', '" + this.gReturnItem + "', " + p_many +
", document." + objName +"Form1." + objName +"_hh_sel.value, document." +
objName +"Form1." + objName +"_mi_sel.value, "+ this.checkValue +", false);" +
"\"><IMG SRC='img/gm0014img.gif' BORDER=0><\/A></TD><TD ALIGN=center>");
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.prevMM + "', '" + this.prevYYYY + "', '"
+ this.gFormat + "', '" + this.gReturnItem + "', " + p_many +
", document." + objName +"Form1." + objName +"_hh_sel.value, document." +
objName +"Form1." + objName +"_mi_sel.value, "+ this.checkValue +", false);" +
"\"><IMG SRC='img/gm0015img.gif' BORDER=0><\/A></TD><TD ALIGN=center>");
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.nextMM + "', '" + this.nextYYYY + "', '"
+ this.gFormat + "', '" + this.gReturnItem + "', " + p_many +
", document." + objName +"Form1." + objName +"_hh_sel.value, document." +
objName +"Form1." + objName +"_mi_sel.value, "+ this.checkValue +", false);" +
"\"><IMG SRC='img/gm0016img.gif' BORDER=0><\/A></TD><TD ALIGN=center>");
this.vCode1 = this.vCode1 + ("<A HREF=\"" +
"javascript:window.opener.build('" + objName +
"', '" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)+1)
+ "', '" + this.gFormat + "', '" + this.gReturnItem + "', " + p_many +
", document." + objName +"Form1." + objName +"_hh_sel.value, document." +
objName +"Form1." + objName +"_mi_sel.value, "+ this.checkValue +", false);" +
"\"><IMG SRC='img/gm0017img.gif' BORDER=0><\/A></TD></TR></TABLE><BR>");
}
this.vCode1 = this.vCode1 + "<TABLE ALIGN='CENTER' BORDER=0 CELLSPACING=1 CELLPADDING=2 BGCOLOR=\"" + this.gBGColor + "\">\n";
this.vCode1 = this.vCode1 + "<TR>\n";
this.vCode1 = this.vCode1 + "<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#FFB0B3'><FONT FACE COLOR='#D80309'>&nbsp;일&nbsp;</FONT></TD>\n";
this.vCode1 = this.vCode1 + "<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'>&nbsp;월&nbsp;</FONT></TD>\n";
this.vCode1 = this.vCode1 + "<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'>&nbsp;화&nbsp;</FONT></TD>\n";
this.vCode1 = this.vCode1 + "<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'>&nbsp;수&nbsp;</FONT></TD>\n";
this.vCode1 = this.vCode1 + "<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'>&nbsp;목&nbsp;</FONT></TD>\n";
this.vCode1 = this.vCode1 + "<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'>&nbsp;금&nbsp;</FONT></TD>\n";
this.vCode1 = this.vCode1 + "<TD WIDTH='16%' ALIGN='CENTER' BGCOLOR='#FFB0B3'><FONT FACE COLOR='#D80309'>&nbsp;토&nbsp;</FONT></TD>\n";
this.vCode1 = this.vCode1 + "</TR>\n";
var vDate = new Date();
vDate.setDate(1);
vDate.setMonth(this.gMonth);
vDate.setFullYear(this.gYear);
var vFirstDay=vDate.getDay();
var vDay=1;
var vLastDay=this.getDaysOfMonth(this.gMonth, this.gYear);//10.
var vOnLastDay=0;
this.vCode1 = this.vCode1 + "<TR BGCOLOR='#F4F3F0' ALIGN='CENTER'>\n";
for (i=0; i<vFirstDay; i++) {
this.vCode1 = this.vCode1 + "<TD WIDTH='14%'" + this.writeWeekendString(i) +
"><FONT FACE='" + fontface + "'> </FONT></TD>\n";
}
for (j=vFirstDay; j<7; j++)
{
this.vCode1 = this.vCode1 + "<TD WIDTH='14%'" + this.writeWeekendString(j) +
"><FONT FACE='" + fontface + "'>\n" +
"<A HREF='#' " ;
if(p_many == '1' && showCalendar_close_flag == "true" )
{
this.vCode1 = this.vCode1 + "onClick=\"javascript : setVdayMethod('"+this.formatData(vDay)+"');";
}
else
{
this.vCode1 = this.vCode1 + "onClick=\"javascript : setVdayMethod('"+this.formatData(vDay)+"'); clickCalendar1('"+this.gReturnItem+"','"+checkStr+"','"+objName+"','"+check+"', '"+p_many+"', '"+"', ''"+",'close');";
}
if(p_many == '1' && showCalendar_close_flag == "false" )
{
this.vCode1 = this.vCode1 + "closeScript();";
}
this.vCode1 = this.vCode1 + "\">" + this.formatDay(vDay) + "</A></FONT></TD>\n";
vDay=vDay + 1;
}
this.vCode1 = this.vCode1 + "</TR>\n";
for (k=2; k<7; k++)
{
this.vCode1 = this.vCode1 + "<TR BGCOLOR='#F4F3F0' ALIGN='CENTER'>\n";
for (j=0; j<7; j++)
{
this.vCode1 = this.vCode1 + "<TD WIDTH='14%'" + this.writeWeekendString(j) +
"><FONT FACE='" + fontface + "'>\n" +
"<A HREF='#' " ;
if(p_many == '1' && showCalendar_close_flag == "true" )
{
this.vCode1 = this.vCode1 + "onClick=\"javascript : setVdayMethod('"+this.formatData(vDay)+"');";
}
else
{
this.vCode1 = this.vCode1 + "onClick=\"javascript : setVdayMethod('"+this.formatData(vDay)+"'); clickCalendar1('"+this.gReturnItem+"','"+checkStr+"','"+objName+"','"+check+"', '"+p_many+"', '"+"', ''"+",'close');";
}
if(p_many == '1' && showCalendar_close_flag == "false" )
{
this.vCode1 = this.vCode1 + "closeScript();";
}
this.vCode1 = this.vCode1 + "\">" + this.formatDay(vDay) + "</A></FONT></TD>\n";
vDay=vDay + 1;
if (vDay > vLastDay)
{
vOnLastDay = 1;
break;
}
}
if (j == 6)
this.vCode1 = this.vCode1 + "</TR>\n";
if (vOnLastDay == 1)
break;
}
for (m=1; m<(7-j); m++) {
if (this.gYearly) {
this.vCode1 = this.vCode1 + "<TD WIDTH='14%'" + this.writeWeekendString(j+m) +
"><FONT FACE='" + fontface + "' COLOR='gray'> </FONT></TD>\n";
}else {
this.vCode1 = this.vCode1 + "<TD WIDTH='14%'" + this.writeWeekendString(j+m) +
"><FONT FACE='" + fontface + "' COLOR='gray'>" + m + "</FONT></TD>\n";
}
}
this.vCode1 = this.vCode1 + "</TABLE>\n";
this.vCode1 = this.vCode1 + "<FORM name=\""+objName+"Form1\">\n";
this.vCode1 = this.vCode1 + "<TABLE ALIGN='CENTER' BORDER=0 CELLSPACING=1 CELLPADDING=2 BGCOLOR='#FFFFFF'>\n";
this.vCode1 = this.vCode1 + "<TR>\n";
this.vCode1 = this.vCode1 + "<TD>\n";
if(this.ghh_sel == null || this.ghh_sel=='' ){
var nowTime = new Date();
var hh = nowTime.getHours();
var mi = nowTime.getMinutes();
cCode = this.clock(objName, hh, mi);
this.vCode1 = this.vCode1 + (cCode);
}else {
var hh = this.ghh_sel;
var mi = this.gmi_sel;
cCode = this.clock(objName, hh, mi);
this.vCode1 = this.vCode1 + (cCode);
}
this.vCode1 = this.vCode1 + "</TD>\n";
this.vCode1 = this.vCode1 + "</TR>\n";
this.vCode1 = this.vCode1 + "</TABLE>\n";
this.vCode1 = this.vCode1 + "</FORM>\n";
if(p_many == 2){
this.vCode1 = this.vCode1 + ("</TD>\n");
}
}
this.init(p_item, p_WinCal, p_month, p_year, p_format, hh_sel, mi_sel, p_time);
}
Calendar.prototype.clock = function(objName, hh, mi) {
var vCode = "";
var nowTime = new Date();
if(this.checkValue){
vCode = vCode + "<div align=left id=\""+objName+"Time\" style=\"display:\"\"\">\n ";
}else{
vCode = vCode + "<div align=left id=\""+objName+"Time\" style=\"display:none\">\n ";
}
vCode = vCode + "	<select name=\""+ objName +"_hh_sel\" style='border-width:1px; background-color:#5b90bf; border-color:#404040;font:10px;color:white; text-align: left;'>\n";
for(i=0; i<24; i++){
if(hh == i){
if(i<10) {
vCode = vCode + "<option selected value=\"0" + i + "\">";
}else {
vCode = vCode + "<option selected value=\"" + i + "\">";
}
}else{
if(i<10) {
vCode = vCode + "<option value=\"0" + i + "\">";
}else {
vCode = vCode + "<option value=\"" + i + "\">";
}
}
if(i<10) {
vCode = vCode + "0" + i + "</option>\n";
}else {
vCode = vCode + i + "</option>\n";
}
}
vCode = vCode + "</select> <font style='font:11px'>시</font>";
vCode = vCode + " <select name=\""+ objName +"_mi_sel\" style='border-width:1px; background-color:#5b90bf; border-color:#404040;font:10px;color:white; text-align: left;'>\n";
for(i=0; i<60; i++){
if(mi == i){
if(i<10){
vCode = vCode + "<option selected value=\"0" + i + "\">";
}else{
vCode = vCode + "<option selected value=\"" + i + "\">";
}
}else{
if(i<10) {
vCode = vCode + "<option value=\"0" + i + "\">";
}else {
vCode = vCode + "<option value=\"" + i + "\">";
}
}
if(i<10) {
vCode = vCode + "0" + i + "</option>\n";
}else {
vCode = vCode + i + "</option>\n";
}
}
vCode = vCode + "</select> <font style='font:11px'>분</font>";
vCode = vCode + " <select name=\""+ objName +"_ss_sel\" style='border-width:1px; background-color:#5b90bf; border-color:#404040;font:10px;color:white; text-align: left;'><option selected value=\"00\">00</option>\n";
for(i=1; i<60; i++){
if(i<10) {
vCode = vCode + "<option value=\"0" + i + "\">" + "0" + i + "</option>\n";
}else {
vCode = vCode + "<option value=\"" + i + "\">" + i + "</option>\n";
}
}
vCode = vCode + "</select> <font style='font:11px'>초</font></div> \n ";
vCode = vCode + "<input type=\"Checkbox\" " + (this.checkValue? "checked" : "" ) +" name=\""+objName+"TimeCheck\" onClick=\"timeShow('"+objName+"')\"><font style='font:12px'>시간출력</font>";
return vCode;
}
function build(objName, p_item1, p_month, p_year, p_format, p_item2, p_many, hh_sel, mi_sel, p_time, p_timeContinue,flag) {
var vCode = "";
var p_WinCal = ggWinCal;
if(flag==false)
{
if(p_timeContinue)//true
{
if(p_many ==2)//두개
{
gCal  = new Calendar(p_item1, p_WinCal, second_p_month, second_p_year, p_format, p_many, second_hh_sel, second_mi_sel, true);
gCal2 = new Calendar(p_item2, p_WinCal, p_month, p_year, p_format, p_many, hh_sel, mi_sel, true);
}
else//한개
{
gCal  = new Calendar(p_item1, p_WinCal, p_month, p_year, p_format, p_many , hh_sel, mi_sel, p_time);
}
}
else//false
{
if(p_many ==2)//두개
{
gCal  = new Calendar(p_item1, p_WinCal, second_p_month, second_p_year, p_format, p_many,second_hh_sel, second_mi_sel, false);
gCal2 = new Calendar(p_item2, p_WinCal, p_month, p_year, p_format, p_many, hh_sel, mi_sel, false);
}
else//한개
{
gCal  = new Calendar(p_item1, p_WinCal, p_month, p_year, p_format, p_many , hh_sel, mi_sel, p_time);
}
}
}
else
{
if(p_timeContinue)
{
gCal  = new Calendar(p_item1, p_WinCal, p_month, p_year, p_format, p_many, hh_sel, mi_sel, true);
gCal2 = new Calendar(p_item2, p_WinCal, p_month, p_year, p_format, p_many, hh_sel, mi_sel, true);
}
else
{
if(p_many ==2)
{
if(objName == "gCal")
{
if(gCal.checkValue)
{
gCal.init(p_item1, gCal.gWinCal, p_month, p_year, p_format, gCal2.ghh_sel, gCal2.gmi_sel, true);
gCal2.init(p_item2, gCal2.gWinCal, gCal2.gMonth, gCal2.gYear, gCal2.gFormat, hh_sel, mi_sel, gCal2.checkValue);
}
else
{
gCal.init(p_item1, gCal.gWinCal, p_month, p_year, p_format, gCal2.ghh_sel, gCal2.gmi_sel, false);
gCal2.init(p_item2, gCal2.gWinCal, gCal2.gMonth, gCal2.gYear, gCal2.gFormat, hh_sel, mi_sel, gCal2.checkValue);
}
}
else if(objName == "gCal2")
{
if(gCal2.checkValue)
{
gCal.init(p_item1, gCal.gWinCal, gCal.gMonth, gCal.gYear, gCal.gFormat, hh_sel, mi_sel, gCal.checkValue);
gCal2.init(p_item2, p_WinCal, p_month, p_year, p_format, null, null, true);
}
else
{
gCal.init(p_item1, gCal.gWinCal, gCal.gMonth, gCal.gYear, gCal.gFormat, hh_sel, mi_sel, gCal.checkValue);
gCal2.init(p_item2, p_WinCal, p_month, p_year, p_format, null, null, false);
}
}
else
{
gCal  = new Calendar(p_item1, p_WinCal, p_month, p_year, p_format, p_many, hh_sel, mi_sel, p_time);
gCal2 = new Calendar(p_item2, p_WinCal, p_month, p_year, p_format, p_many, hh_sel, mi_sel, p_time);
}
}
else
{
gCal  = new Calendar(p_item1, p_WinCal, p_month, p_year, p_format, p_many , hh_sel, mi_sel, p_time);
}
}//flag
}
p_WinCal.document.open();
gCal.gBGColor="#FFFFFF";
gCal.gLinkColor="#4D4D4D";
gCal.gTextColor="#990066";
gCal.gHeaderColor="#715F44";
if(p_many ==2){
gCal2.gBGColor="#FFFFFF";
gCal2.gLinkColor="#4D4D4D";
gCal2.gTextColor="#990066";
gCal2.gHeaderColor="#715F44";
}
vCode = vCode + ("<html>																										\n");
vCode = vCode + ("<link rel=\"stylesheet\" href=\"css/pub.css\" type=\"text/css\">\n");
vCode = vCode + ("<head><title>Calendar</title>															\n");
vCode = vCode + ("<script language=\"JavaScript\">													\n");
vCode = vCode + ("var memoryADate=\"2999-01-01 00:00:00\";										\n")
vCode = vCode + ("var memoryBDate;										\n")
vCode = vCode + ("/* 1개짜리 달력에서 클릭된 값을 저장하기 위한 전역변수 선언(2003-09-26 12:00) */     								\n")
vCode = vCode + ("var memoryClickedDate;		\n")
vCode = vCode + ("	function timeShow(objName){															\n");
vCode = vCode + ("		if(objName == \"gCal\"){															\n");
vCode = vCode + ("			if(eval(document.gCalForm1.gCalTimeCheck.checked)){	\n");
vCode = vCode + ("						document.all.gCalTime.style.display=\"\";			\n");
vCode = vCode + ("			}else{																							\n");
vCode = vCode + ("						document.all.gCalTime.style.display=\"none\";	\n");
vCode = vCode + ("			}																										\n");
vCode = vCode + ("		}else if(objName == \"gCal2\"){												\n");
vCode = vCode + ("			if(eval(document.gCal2Form1.gCal2TimeCheck.checked)){	\n");
vCode = vCode + ("				document.all.gCal2Time.style.display=\"\";				\n");
vCode = vCode + ("			}else{																							\n");
vCode = vCode + ("				document.all.gCal2Time.style.display=\"none\";		\n");
vCode = vCode + ("			}																										\n");
vCode = vCode + ("		}																											\n");
vCode = vCode + ("		opener.eval(objName).checkValue = eval(\"document.\"+objName+\"Form1.\"+objName+\"TimeCheck.checked\")	;\n");
vCode = vCode + ("	}																												\n");
vCode = vCode + ("/* 1개짜리 달력에서 클릭된 값을 저장(2003-09-26 12:00) */     								\n")
vCode = vCode + ("	function setVdayMethod(vDay){															\n");
vCode = vCode + ("		memoryClickedDate=vDay;															\n");
vCode = vCode + ("	}																												\n");
vCode = vCode + ("	function closeScript(){   \n");
vCode = vCode + ("		//달력팝업을 닫기전 메인의 특정script를 호출하는 부분 \n");
vCode = vCode + ("		"+closeScript+" \n");
vCode = vCode + ("		window.close(); \n");
vCode = vCode + ("	}\n");
vCode = vCode + ("		//전월의 값을 기억\n"														);
vCode = vCode + ("	function setMemB(before){			  \n");
vCode = vCode + ("		memoryBDate= before;				\n");
vCode = vCode + ("			}\n"														);
vCode = vCode + ("		//현재월의 값을 기억\n"														);
vCode = vCode + ("	function setMemA(after){			  \n");
vCode = vCode + ("		memoryADate= after;				\n");
vCode = vCode + ("			}\n"														);
vCode = vCode + ("	function formatDate(vDay, preLen){   \n");
vCode = vCode + ("		switch (preLen) { \n");
vCode = vCode + ("			case 4 :\n");
vCode = vCode + ("				vData = vDay.substr(0,preLen) ;\n");
vCode = vCode + ("				break;  \n");
vCode = vCode + ("			case 7 :\n");
vCode = vCode + ("				vData = vDay.substr(0,preLen);\n");
vCode = vCode + ("				break;\n");
vCode = vCode + ("			case 10 :\n");
vCode = vCode + ("				vData = vDay.substr(0,10);\n");
vCode = vCode + ("				break;	\n");
vCode = vCode + ("			default :\n");
vCode = vCode + ("				vData = vDay;\n");
vCode = vCode + ("		}\n");
vCode = vCode + ("		return vData;\n");
vCode = vCode + ("	}\n");
vCode = vCode + ("	function formatTime(vDay, preLen, postLen, hhmmssurl, hhmmurl, hhurl){   \n");
vCode = vCode + ("		switch (postLen) { \n");
vCode = vCode + ("			case 2 :\n");
vCode = vCode + ("				vData =  \" \" +hhurl;\n");
vCode = vCode + ("				break;	\n");
vCode = vCode + ("			case 5 :  \n");
vCode = vCode + ("				vData =  \" \" +hhmmurl; \n");
vCode = vCode + ("				break;	\n");
vCode = vCode + ("			case 8 :\n");
vCode = vCode + ("				vData =  \" \" +hhmmssurl;\n");
vCode = vCode + ("				break;	\n");
vCode = vCode + ("			default :\n");
vCode = vCode + ("				 vData = \" \" +hhmmssurl;\n");
vCode = vCode + ("			}\n");
vCode = vCode + ("			return vData;\n");
vCode = vCode + ("	}\n");
vCode = vCode + ("/* 1개짜리 달력에서 클릭된 값을 저장하기위해 메소드 수정(2003-09-26 12:00) */     								\n")
vCode = vCode + ("	function clickCalendar1(gReturnItem, checkStr, objName,check, typeCnt,  vDay_tmp, isCloseFlag)			\n");
vCode = vCode + ("	{		var vDay=vDay_tmp;																	  \n");
vCode = vCode + ("	  /* 1개짜리 달력에서 날짜를 클릭하기 전에 확인 버튼을 누르면 경고창 display(2003-09-26 12:00) */     								\n")
vCode = vCode + ("	    if(	memoryClickedDate==null || memoryClickedDate.length<0) {																  \n");
vCode = vCode + ("          alert(\"날짜를 선택 하세요\");																  \n");
vCode = vCode + ("      }																  \n");
vCode = vCode + ("		if(vDay=='' || vDay.length<0){																			  \n");
vCode = vCode + ("			vDay	= 	 memoryClickedDate;														  \n");
vCode = vCode + ("}																  \n");
vCode = vCode + ("/* 1개짜리 달력에서 날짜를 클릭하기 전에 확인 버튼을 누르면 경고창보이고 나머지는 수행안함(2003-09-26 12:00) */     								\n")
vCode = vCode + ("if(vDay!=null&&vDay.length>0){																  \n");
vCode = vCode + ("		var preLen  = vDay.indexOf(\" \");										\n");
vCode = vCode + ("		var len		  = vDay.length;														\n");
vCode = vCode + ("		var postLen = len-preLen-1;														\n");
vCode = vCode + ("		if(objName == \"gCal\"){	   													\n");
vCode = vCode + ("			var hhmmssurl = eval(\"document.gCalForm1.\"+objName+\"_hh_sel.options(eval(document.\"+objName+\"Form1.\"+objName	\n");
vCode = vCode + ("										+\"_hh_sel.selectedIndex)).value \");	\n");
vCode = vCode + ("					hhmmssurl +=	\":\" +   eval(\"document.all.\"+objName+\"Form1.\"+objName+\"_mi_sel.options(eval(document.\"+objName+\"Form1.\"+objName	+\"_mi_sel.selectedIndex)).value \" );	\n");
vCode = vCode + ("					hhmmssurl +=	\":\" + eval(\"document.all.\"+objName+\"Form1.\"+objName+\"_ss_sel.options(eval(document.\"+objName+\"Form1.\"+objName	+\"_ss_sel.selectedIndex)).value \" );	\n");
vCode = vCode + ("			var hhmmurl		= eval(\"document.gCalForm1.\"+objName+\"_hh_sel.options(eval(document.\"+objName+\"Form1.\"+objName	\n");
vCode = vCode + ("										+\"_hh_sel.selectedIndex)).value \");	\n");
vCode = vCode + ("					hhmmurl		+=	\":\" + eval(\"document.all.\"+objName+\"Form1.\"+objName+\"_mi_sel.options(eval(document.\"+objName+\"Form1.\"+objName	+\"_mi_sel.selectedIndex)).value \" );	\n");
vCode = vCode + ("			var hhurl			= eval(\"document.gCalForm1.\"+objName+\"_hh_sel.options(eval(document.\"+objName+\"Form1.\"+objName	\n");
vCode = vCode + ("										+\"_hh_sel.selectedIndex)).value \");	\n");
vCode = vCode + ("			if(eval(document.gCalForm1.gCalTimeCheck.checked)){	\n");
vCode = vCode + ("				var vDay = formatDate(vDay, preLen);					\n");
vCode = vCode + ("		        vDay += formatTime(vDay, preLen, postLen, hhmmssurl, hhmmurl, hhurl);	\n");
vCode = vCode + ("				//			 From ~ To  값 체크 																															\n");
vCode = vCode + ("			if(check=='true'){																	\n");
vCode = vCode + ("				if(memoryADate<vDay){													\n");
vCode = vCode + ("					alert(checkStr); \n");
vCode = vCode + ("										\n");
vCode = vCode + ("				}else{						\n");
vCode = vCode + ("					eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); \n} \n");
vCode = vCode + ("			} 	else 	{eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); }	\n														");
vCode = vCode + ("			}else {																												\n");
vCode = vCode + ("		    var vDay = formatDate(vDay, preLen);	\n");
vCode = vCode + ("			if(check=='true'){																	\n");
vCode = vCode + ("				//			 From ~ To  값 체크 																															\n");
vCode = vCode + ("				if(memoryADate<vDay){													\n");
vCode = vCode + ("					alert(checkStr); \n");
vCode = vCode + ("										\n");
vCode = vCode + ("					}else{						\n");
vCode = vCode + ("						eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); \n");
vCode = vCode + ("				   }																										\n");
vCode = vCode + ("			 }	else {																							\n");
vCode = vCode + ("			eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); 	//check																													\n");
vCode = vCode + ("			}																												\n");
vCode = vCode + ("			}\n"														);
vCode = vCode + ("			//전달의 값을 기억																										\n");
vCode = vCode + ("		    setMemB(vDay);																									\n");
vCode = vCode + ("/* 1개짜리 달력에서 확인 버튼 클릭시 값을 setting하고 window close 호출(2003-09-26 12:00) */     								\n")
vCode = vCode + ("			if(typeCnt=='1' && isCloseFlag=='close')																												\n");
vCode = vCode + ("	        {																											\n");
vCode = vCode + ("	              closeScript(); 																												\n");
vCode = vCode + ("			}																											\n");
vCode = vCode + ("		} else if(objName == \"gCal2\"){												\n");
vCode = vCode + ("			var hhmmssurl =        eval(\"document.gCal2Form1.\"+objName+\"_hh_sel.options(eval(document.\"+objName+\"Form1.\"+objName	\n");
vCode = vCode + ("								+\"_hh_sel.selectedIndex)).value \");				\n");
vCode = vCode + ("					hhmmssurl +=	\":\" +   eval(\"document.all.\"+objName+\"Form1.\"+objName+\"_mi_sel.options(eval(document.\"+objName+\"Form1.\"+objName	+\"_mi_sel.selectedIndex)).value \" );	\n");
vCode = vCode + ("					hhmmssurl +=	\":\" + eval(\"document.all.\"+objName+\"Form1.\"+objName+\"_ss_sel.options(eval(document.\"+objName+\"Form1.\"+objName	+\"_ss_sel.selectedIndex)).value \" );	\n");
vCode = vCode + ("			var hhmmurl = eval(\"document.gCal2Form1.\"+objName+\"_hh_sel.options(eval(document.\"+objName+\"Form1.\"+objName	\n");
vCode = vCode + ("								+\"_hh_sel.selectedIndex)).value \");				\n");
vCode = vCode + ("					hhmmurl +=	\":\" + eval(\"document.all.\"+objName+\"Form1.\"+objName+\"_mi_sel.options(eval(document.\"+objName+\"Form1.\"+objName	+\"_mi_sel.selectedIndex)).value \" );	\n");
vCode = vCode + ("			var hhurl = eval(\"document.gCal2Form1.\"+objName+\"_hh_sel.options(eval(document.\"+objName+\"Form1.\"+objName	\n");
vCode = vCode + ("								+\"_hh_sel.selectedIndex)).value \");				\n");
vCode = vCode + ("			if(eval(document.gCal2Form1.gCal2TimeCheck.checked)){	\n");
vCode = vCode + ("				var vDay = formatDate(vDay, preLen);					\n");
vCode = vCode + ("		        vDay += formatTime(vDay, preLen, postLen, hhmmssurl, hhmmurl, hhurl);	\n");
vCode = vCode + ("				//			 From ~ To  값 체크 																															\n");
vCode = vCode + ("			if(check=='true'){																	\n");
vCode = vCode + ("				if(memoryBDate>vDay){													\n");
vCode = vCode + ("					alert(checkStr); \n");
vCode = vCode + ("										\n");
vCode = vCode + ("				}else{						\n");
vCode = vCode + ("					eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); \n} \n");
vCode = vCode + ("			} 	else 	{eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); }	\n														");
vCode = vCode + ("			}else {																												\n");
vCode = vCode + ("		    var vDay = formatDate(vDay, preLen);	\n");
vCode = vCode + ("			if(check=='true'){																	\n");
vCode = vCode + ("				//			 From ~ To  값 체크 																															\n");
vCode = vCode + ("				if(memoryBDate>vDay){													\n");
vCode = vCode + ("					alert(checkStr); \n");
vCode = vCode + ("										\n");
vCode = vCode + ("					}else{						\n");
vCode = vCode + ("						eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); \n");
vCode = vCode + ("				   }																										\n");
vCode = vCode + ("			 }	else {																							\n");
vCode = vCode + ("			eval(\"self.opener.document.all.\"+gReturnItem+\".value='\"+vDay+\"' \"); 	//check																													\n");
vCode = vCode + ("			}																												\n");
vCode = vCode + ("			}																												\n");
vCode = vCode + ("				//			현재일을 기억																													\n");
vCode = vCode + ("		    setMemA(vDay);																									\n");
vCode = vCode + ("		}																											\n");
vCode = vCode + ("		}																											\n");
vCode = vCode + ("	}																												\n");
vCode = vCode + ("</script>																									\n");
vCode = vCode + ("</head>																										\n");
vCode = vCode + ("<body " +
"link=\"" + gCal.gLinkColor + "\" " +
"vlink=\"" + gCal.gLinkColor + "\" " +
"alink=\"" + gCal.gLinkColor + "\" " +
"text=\"" + gCal.gTextColor + "\" ");
if(modal == "1")
vCode = vCode + ("onBlur=\"self.focus();\">");
else
vCode = vCode + (">");
if(p_many == 2){
vCode = vCode + ("<TABLE>");
vCode = vCode + ("<TR>");
gCal.show("gCal", p_many, "gCal2",this.second_p_year,this.second_p_month);
vCode = vCode+gCal.vCode1;
gCal2.show("gCal2", p_many,"gCal",this.p_year,this.p_month);
vCode = vCode+gCal2.vCode1;
vCode = vCode + ("</TR>");
vCode = vCode + ("<TR>");
vCode = vCode + ("<TD COLSPAN=\"2\" ALIGN=\"center\">\n");
vCode = vCode + ("<A HREF=\"" +
"javascript:closeScript();\"><IMG SRC=\"/img/m000010ico.gif\" BORDER=0></A>");
vCode = vCode + ("</TD>\n");
vCode = vCode + ("</TR>");
vCode = vCode + ("</TABLE>");
}
else{
gCal.show("gCal", p_many, "gCal2",p_year,p_month);
vCode = vCode+gCal.vCode1;
if (showCalendar_close_flag == "true")
{
vCode = vCode + ("<CENTER><TABLE>");
vCode = vCode + ("<TR>");
vCode = vCode + ("<TD COLSPAN=\"2\" ALIGN=\"center\">\n");
vCode = vCode + ("<IMG SRC=\"/img/m000010ico.gif\" BORDER=0 style=\"cursor:hand\" onClick=\"javascript : "+
"clickCalendar1('"+this.p_item1+"', '', "+" 'gCal','"+checkDate+"', '"+p_many+"', ''"+",'close');\">");
vCode = vCode + ("</TD>\n");
vCode = vCode + ("</TR>");
vCode = vCode + ("</TABLE></CENTER>");
}
}
vCode = vCode + ("</BODY>");
vCode = vCode + ("</HTML>");
p_WinCal.document.writeln(vCode);
p_WinCal.document.close();
}
function showCalendar() {
objName = ""; hh_sel = null; mi_sel = null;
p_item1 = arguments[0];
if (arguments[1] == "" || arguments[1] == null)   //현재시간의 년도를 구한다.
{
p_year = new String(gNow.getFullYear().toString());
}
else
{
var tmpY=arguments[1];
p_year = tmpY.substring(0,4);
}
var nowTime = new Date();
if (arguments[2] == "" || arguments[2] == null || arguments[2].length<6)
{
p_month = new String(gNow.getMonth());   //현재시간의 달로 p_month를 구한다
}
else
{
var tmpD = arguments[2];
p_month = tmpD.substring(5,7)-1;
if(parseInt(p_month)>11 || parseInt(p_month)<0 )
{
p_month = new String(gNow.getMonth());   //현재시간의 달로 p_month를 구한다
}
}
if(arguments[2] == "" ||  arguments[2].length<13 )
{
hh_sel = new String(nowTime.getHours());
}
else
{
var tmpD=arguments[2];
hh_sel =tmpD.substring(11,13);
}
if(arguments[2] == "" ||  arguments[2].length<16)
{
mi_sel = new String(nowTime.getMinutes());
}
else
{
var tmpD=arguments[2];
mi_sel =tmpD.substring(14,16);
}
if (arguments[3] == "" || arguments[3] == null) p_format = "YYYY-MONTH-DD";
else p_format = arguments[3];
p_item2 = arguments[4];
p_many  = arguments[5];
p_time  = arguments[6];
if (arguments[7] == "" || arguments[7] == null) closeScript = "";
else closeScript = arguments[7];
if (arguments[8] == "" || arguments[8] == null) modal = "0";
else modal = arguments[8];
if (arguments[9] == "" || arguments[9] == null) {checkDate = "false";}
else{ checkDate = arguments[9];}
if (arguments[10] == "" || arguments[10] == null) {checkStr = "From ~ To 의 값을 확인하세요";}
else{ checkStr = arguments[10];}
if (arguments[11] == "" || arguments[11] == null) {showCalendar_close_flag = "false";}
else{ showCalendar_close_flag = arguments[11];
}
if (arguments[12] == "" || arguments[12] == null || arguments[12].length<4)
{
second_p_year = new String(gNow.getFullYear().toString());
}
else
{
var tmpSecondstr=arguments[12];
this.second_p_year=tmpSecondstr.substring(0,4);
}
if(arguments[12] == "" || arguments[12] == null ||  arguments[12].length<7)
{
second_p_month = new String(gNow.getMonth());
}
else
{
var tmpSecondstr=arguments[12];
this.second_p_month=tmpSecondstr.substring(5,7)-1;
if(parseInt(second_p_month)>11 || parseInt(second_p_month)<0 )
{
second_p_month = new String(gNow.getMonth());   //현재시간의 달로 p_month를 구한다
}
}
if(arguments[12]== "" ||  arguments[12] == null ||arguments[12].length<13)
{
second_hh_sel = new String(nowTime.getHours());
}
else
{
var tmpSecondstr=arguments[12];
second_hh_sel =tmpSecondstr.substring(11,13);
}
if(arguments[12] == "" || arguments[12] == null || arguments[12].length<16)
{
second_mi_sel = new String(nowTime.getMinutes());
}
else
{
var tmpSecondstr=arguments[12];
second_mi_sel =tmpSecondstr.substring(14,16);
}
if(p_time){
p_timeContinue = true;
}else{
p_timeContinue = false;
}
if(p_many==2){
vWinCal = window.open(objName, "Calendar", "width=390,height=360,status=yes,resizable=yes,top=200,left=200");
}else{
vWinCal = window.open(objName, "Calendar", "width=300,height=350,status=yes,resizable=yes,top=200,left=200");
}
check=false;
if(checkDate==true)
{
check=true;
}
vWinCal.opener = self;
ggWinCal = vWinCal;
build(objName, p_item1, p_month, p_year, p_format, p_item2, p_many, hh_sel, mi_sel, p_time, p_timeContinue,false);
}
function textGen(obj,idx){
return obj.name+"["+idx+"]";
}



/** cellCopy.js */
function cellCopyone(index,src,des){
var source = "";
var idx =parseInt(index);
source = returnTypeValue(src[idx]);
insTypeValue(des,source);
}
function returnTypeValue(src){
var source;
switch (src.type) {
case "text" :
source = src.value;
break;
case "select-one" :
source = src.options[src.selectedIndex].innerHTML;
break;
case undefined :
source = src.innerText;
break;
}
return source;
}
function insTypeValue(des,src){
switch (des.type) {
case "text" :
des.value = src;
break;
case "select-one" :
selectedValue(des,src);
break;
case undefined :
des.innerText = src;
break;
}
}
function selectedValue(des,src){
var ln =des.length;
for(var i=0 ; i < ln ; i++){
if(des.options[i].innerHTML == src)
des.selectedIndex = i;
}
}
function rowCellCopy(table_id,chkname){
var chk = chkedCellCopy(chkname);   // 체크
if( chk == true){
mcopyRow(table_id.firstChild.firstChild);
}
return false;
}
function mcopyRow(trtag) {
if (trtag) {
var tdtag = trtag.firstChild;
var chktag = tdtag.firstChild;
if (trtag.nextSibling) mcopyRow(trtag.nextSibling);
if (chktag.checked == true && trtag.nextSibling) copyRow(trtag);
}
}
function copyRow(trtag) {
var oCloneNode = trtag;
var nextTrtag= trtag.nextSibling;
var source="";
var colCount = oCloneNode.childNodes.length
for(var i = 0 ; i < colCount ; i++ ) {
var src = oCloneNode.childNodes[i].firstChild;
var des = nextTrtag.childNodes[i].firstChild;
switch (src.type) {
case "text" :
des.value = src.value;
break;
case "select-one" :
selectedValue(des, src.options[src.selectedIndex].innerHTML);
break;
case undefined :
nextTrtag.childNodes[i].innerHTML = oCloneNode.childNodes[i].innerHTML;
break;
case "" :
nextTrtag.childNodes[i].innerHTML = oCloneNode.childNodes[i].innerHTML;
break;
default :
break;
}
}
}
function chkedCellCopy(chkname) {
var result=false;
for(var chkno = 0 ; chkno < chkname.length ; chkno++){
if (chkname[chkno].checked){
result = true;
}
}
return result
}


/** showHelp.js */
function showHelp(url)
{
var w = 536;						// 팝업 width값
var h = 550;						// 팝업 height값
var winl = (screen.width - w -10);	// 팝업이 스크린 오른쪽 끝에 나타나도록 width값 조정
var wint = (screen.height - h -55);	// 팝업이 스크린 하단 끝에 나타나도록 height값 조정
winprops = 'height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars=yes, resizable=no';
win = window.open(url, 'help', winprops);
return false;
}


/** showHighLowIndexArrow.js */
function isInCode(txt_name){
var flag=false;
for (var i = 0; i <code_array.length; i++) {
if( txt_name.value == code_array[i]) {
flag=true;
break;
}
}
return flag;
}
function showHighIndexArrow(txt_name){
var flag=false;
flag=isInCode(txt_name);
if(flag==false) { txt_name.value=""; txt_name.focus(); alert("존재하지 않는 값입니다.");}
for (var i = 0; i <code_array.length; i++) {
if( txt_name.value == code_array[code_array.length]) {
alert("더이상 없습니다.");
break;
}
else  if( txt_name.value==code_array[i])
{
if(i+1 >= code_array.length)
{
alert("더 큰값이 존재하지 않습니다.");
break;
}
else {
txt_name.value=code_array[i+1];
txt_name.focus();
break;
}
}
}
}
function showLowIndexArrow(txt_name){
var flag=false;
flag=isInCode(txt_name);
if(flag==false) { txt_name.value=""; alert("존재하지 않는 값입니다.");}
for (var i = 0; i <code_array.length; i++) {
if(txt_name.value==code_array[0]){
alert("더이상 작은 값은 존재하지 않습니다.");
txt_name.value=code_array[0];
break;
}
else if( txt_name.value == code_array[i]) {
txt_name.value=code_array[i-1];
break;
}
}
}


/** showInsertableRow.js */
function insRow(table_id,eTable_id,chkname){
if (chkname == null && eTable_id == null )
{
return false;
}
if( chkname!= null && chked(chkname) ){			//체크박스를 선택되어 있을때 그 Row를 바로 위로 복사
minsRow(table_id.firstChild.firstChild,chkname);
}
else{
if( eTable_id != null){     //체크박스를 선택하지 않고 행삽입 눌룰시 빈 HiddenTable존재시 그 Table의 Row를 복사
insertRowNochk(table_id,eTable_id);
}
}
return false;
}
function minsRow(trtag) {
if (trtag) {
var tdtag = trtag.firstChild;
var chktag = tdtag.firstChild;
if (trtag.nextSibling) minsRow(trtag.nextSibling);
if (chktag.checked == true) insertRow(tdtag);
}
}
function insertRow(tdtag) {
var trtag = tdtag.parentElement;
var oCloneNode = trtag.cloneNode(true);
trtag.parentElement.insertBefore(oCloneNode,trtag);
swapall(trtag,trtag.nextSibling);
}
function insertRowNochk(table_id,eTable_id){
var hTrtag = eTable_id.firstChild.firstChild;
var oCloneNode = hTrtag.cloneNode(true);
table_id.firstChild.insertBefore(oCloneNode,null);
if(table_id.firstChild.firstChild != null){
trtag=table_id.firstChild.firstChild;
swapall(trtag,trtag.nextSibling);
}
}
function delRow(table_id,chkname){
var chk = chked(chkname);   // 체크
if( chk == true){			// 체크가 되어있는  Row를 삭제한다.
mdelrow(table_id.firstChild.firstChild);
}
return false;
}
function mdelrow(trtag){
if (trtag) {
var tdtag = trtag.firstChild;
var chktag = tdtag.firstChild;
if (trtag.nextSibling) mdelrow(trtag.nextSibling);
if (chktag.checked == true) removeRow(tdtag);
}
}
function removeRow(tdtag) {
var trtag = tdtag.parentElement;
var Ttag = trtag.nextSibling;
var tabtag = trtag.parentElement;
tabtag.deleteRow(trtag.rowIndex);
if (Ttag) swapall(Ttag,Ttag.nextSibling);
}
function swapall(trtag,Ttag) {
var node;
var chktag = trtag.firstChild.firstChild;
if (trtag.nextSibling) {
for(var ch =0 ; ch <trtag.childNodes.length ; ch++){
if(ch==0) chktag.value = Ttag.rowIndex-1;
trtag.childNodes[ch].index = Ttag.rowIndex-1;
}
swapall(trtag.nextSibling,Ttag.nextSibling);
} else {
for(var ce =0 ; ce <trtag.childNodes.length ; ce++){
if(ce==0) chktag.value =  trtag.rowIndex;
trtag.childNodes[ce].index = trtag.rowIndex;
}
}
}
function chked(chkname) {
var result=false;
if(chkname.length == null){
if (chkname.checked){
result = true;
}
}
else{
for(var chkno = 0 ; chkno < chkname.length ; chkno++){
if (chkname[chkno].checked){
result = true;
}
}
}
return result
}


/** showModalPopup.js */
function showModalPopup()
{
var url, arg, w, h, center, top, left, loca, status, scroll, resize, winprops, win;
url = arguments[0];
if (arguments[1] == "" || arguments[1] == null)
arg = '';
else arg = arguments[1];
if (arguments[2] == "" || arguments[2] == null)
w = 100;
else w = arguments[2];
if (arguments[3] == "" || arguments[3] == null)
h = 100;
else h = arguments[3];
if ( arguments[4] == "" || arguments[4] == null || arguments[4] == "1" || arguments[4] == "yes")
loca = "center: 1;";
else if(arguments[4] == "0" || arguments[4] == "no")
{
if (arguments[5] == "" || arguments[5] == null)
top = 0;
else top = arguments[5];
if (arguments[6] == "" || arguments[6] == null)
left = 0;
else left = arguments[6];
loca = 'dialogTop:'+top+'px; dialogLeft:'+left+'px;' ;
}
else loca = '';
if (arguments[7] == "" || arguments[7] == null)
status = '1';
else status = arguments[7];
if (arguments[8] == "" || arguments[8] == null)
scroll = '0';
else scroll = arguments[8];
if (arguments[9] == "" || arguments[9] == null)
resize = '0';
else resize = arguments[9];
winprops = 'dialogWidth:'+w+'px;dialogHeight:'+h+'px; '+loca+' help:0; status:'
+status+'; scroll:'+scroll+'; resizable:'+resize ;
win = window.showModalDialog(url,arg,winprops);
return false;
}


/** showMonthCalendar.js */
var showMonthCalendar_obj;
var showMonthCalendar_year;
var showMonthCalendar_month;
var showMonthCalendar_closeScript;
var showMonthCalendar_option;
var showMonthCalendar_ok;
var showMonthCalendar_cancel;
var showMonthCalendar_confirm;
function showMonthCalendar()
{
showMonthCalendar_obj = null;
showMonthCalendar_year = null;
showMonthCalendar_month = null;
showMonthCalendar_closeScript = null;
showMonthCalendar_option = null;
showMonthCalendar_ok = null;
showMonthCalendar_cancel = null;
showMonthCalendar_confirm = null;
if (arguments[0] != "" && arguments[0] != null)
{
showMonthCalendar_obj = arguments[0];
}
if (arguments[1] != "" && arguments[1] != null)
{
var tmpDate = arguments[1];
if (tmpDate.length == 7)
{
var tmpYear = tmpDate.substring(0,4);
var tmpMonth = tmpDate.substring(5,7);
if (0<eval(tmpMonth) && eval(tmpMonth) < 13)
{
showMonthCalendar_year = tmpYear;
showMonthCalendar_month = tmpMonth;
}
}
}
if (arguments[2] != "" && arguments[2] != null)
{
showMonthCalendar_closeScript = arguments[2];
}
if (arguments[3] != "" || arguments[3] != null)
{
showMonthCalendar_option = arguments[3];
if (showMonthCalendar_option == 0)
{
showMonthCalendar_ok = false;
showMonthCalendar_cancel = false;
showMonthCalendar_confirm = false;
}
else if (showMonthCalendar_option == 1)
{
showMonthCalendar_ok = true;
showMonthCalendar_cancel = false;
showMonthCalendar_confirm = false;
}
else if (showMonthCalendar_option == 2)
{
showMonthCalendar_ok = true;
showMonthCalendar_cancel = false;
showMonthCalendar_confirm = true;
}
else if (showMonthCalendar_option == 3)
{
showMonthCalendar_ok = false;
showMonthCalendar_cancel = true;
showMonthCalendar_confirm = false;
}
else if (showMonthCalendar_option == 4)
{
showMonthCalendar_ok = true;
showMonthCalendar_cancel = true;
showMonthCalendar_confirm = false;
}
else if (showMonthCalendar_option == 5)
{
showMonthCalendar_ok = true;
showMonthCalendar_cancel = true;
showMonthCalendar_confirm = true;
}
}
var vWinCal = window.open("년월입력", "년월입력", "width=290,height=150,top=200,left=200");
showMonthCalendar_build(vWinCal);
vWinCal.MM_initial();
}
function showMonthCalendar_setValue(value)
{
if (showMonthCalendar_obj != null)
{
showMonthCalendar_obj.value = value;
}
}
function showMonthCalendar_build(win)
{
var vCode;
vCode = ("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n");
vCode = vCode + ("<html>\n");
vCode = vCode + ("<head>\n");
vCode = vCode + ("<title>년월입력</title>\n");
vCode = vCode + ("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">\n");
vCode = vCode + ("<script language=\"JavaScript\" type=\"text/JavaScript\">\n");
vCode = vCode + ("<!--\n");
vCode = vCode + ("    var show_month_calendar_returnObj;\n");
vCode = vCode + ("    var show_month_calendar_firstItem;\n");
vCode = vCode + ("    var show_month_calendar_firstItem_img;\n");
vCode = vCode + ("    var show_month_calendar_firstItem_value;\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    function MM_initial() { //v3.0\n");
if (showMonthCalendar_month != null)
{
vCode = vCode + ("      MM_preloadImages('/img/m000921img.gif','/img/m000924img.gif','/img/m000923img.gif','/img/m000922img.gif','/img/m000925img.gif','/img/m000926img.gif','/img/m000927img.gif','/img/m000928img.gif','/img/m000929img.gif','/img/m000930img.gif','/img/m000931img.gif','/img/m000932img.gif');\n");
vCode = vCode + ("      itemSelected('Image" + showMonthCalendar_month + "','/img/m0009" + (20+eval(showMonthCalendar_month)) + "img.gif','" + showMonthCalendar_month + "','/img/m0009" + showMonthCalendar_month + "img.gif', 0);\n");
}
else
{
}
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    function MM_preloadImages() { //v3.0\n");
vCode = vCode + ("      var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();\n");
vCode = vCode + ("        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)\n");
vCode = vCode + ("        if (a[i].indexOf(\"#\")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    function MM_swapImgRestore() { //v3.0\n");
vCode = vCode + ("      var i,x,a=document.MM_sr; \n");
vCode = vCode + ("      for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++)\n");
vCode = vCode + ("      {if(show_month_calendar_firstItem != x.id)x.src=x.oSrc;}\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    function MM_findObj(n, d) { //v4.01\n");
vCode = vCode + ("      var p,i,x;  if(!d) d=document; if((p=n.indexOf(\"?\"))>0&&parent.frames.length) {\n");
vCode = vCode + ("        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}\n");
vCode = vCode + ("      if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];\n");
vCode = vCode + ("      for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);\n");
vCode = vCode + ("      if(!x && d.getElementById) x=d.getElementById(n); return x;\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    function MM_swapImage() { //v3.0\n");
vCode = vCode + ("      var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)\n");
vCode = vCode + ("       if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    function yearChanged(type)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        if (type == 1)\n");
vCode = vCode + ("        {\n");
vCode = vCode + ("            var yearValue = year.innerText;\n");
vCode = vCode + ("            year.innerText = yearValue - 1;\n");
vCode = vCode + ("        }\n");
vCode = vCode + ("        else \n");
vCode = vCode + ("        {\n");
vCode = vCode + ("            var yearValue = year.innerText;\n");
vCode = vCode + ("            year.innerText = eval(yearValue) + 1;\n");
vCode = vCode + ("        }\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    function itemSelected(id, img, value, srcimg, option)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        var previousId;\n");
vCode = vCode + ("        var previousImg;\n");
vCode = vCode + ("        \n");
vCode = vCode + ("        previousId = show_month_calendar_firstItem;\n");
vCode = vCode + ("        previousImg = show_month_calendar_firstItem_img;\n");
vCode = vCode + ("        \n");
vCode = vCode + ("        show_month_calendar_firstItem = id;\n");
vCode = vCode + ("        show_month_calendar_firstItem_img = srcimg;\n");
vCode = vCode + ("        show_month_calendar_firstItem_value = value;\n");
vCode = vCode + ("    \n");
if (showMonthCalendar_obj != null && showMonthCalendar_confirm == true)
{
vCode = vCode + ("        if (previousId != null && previousImg != null)\n");
vCode = vCode + ("        {\n");
vCode = vCode + ("            MM_swapImage(previousId,'',previousImg,1);\n");
vCode = vCode + ("        }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("        MM_swapImage(id,'',img,1);\n");
}
else
{
vCode = vCode + ("        if (option == 1)\n");
vCode = vCode + ("        {\n");
vCode = vCode + ("            closeMonthCalendar();\n");
vCode = vCode + ("        }\n");
vCode = vCode + ("        else\n");
vCode = vCode + ("        {\n");
vCode = vCode + ("            if (previousId != null && previousImg != null)\n");
vCode = vCode + ("            {\n");
vCode = vCode + ("                MM_swapImage(previousId,'',previousImg,1);\n");
vCode = vCode + ("            }\n");
vCode = vCode + ("            \n");
vCode = vCode + ("            MM_swapImage(id,'',img,1);\n");
vCode = vCode + ("        }\n");
}
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    function closeMonthCalendar()\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        if (show_month_calendar_firstItem_value == null)\n");
vCode = vCode + ("        {\n");
vCode = vCode + ("            alert('월을 선택하세요');\n");
vCode = vCode + ("            return;\n");
vCode = vCode + ("        }\n");
vCode = vCode + ("        \n");
if (showMonthCalendar_obj != null)
{
vCode = vCode + ("        window.opener.showMonthCalendar_setValue(year.innerText + \"-\" + show_month_calendar_firstItem_value);\n");
}
if (showMonthCalendar_closeScript != null)
{
vCode = vCode + ("        window.opener." + showMonthCalendar_closeScript + ";\n");
}
vCode = vCode + ("        window.close();\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("//-->\n");
vCode = vCode + ("</script>\n");
vCode = vCode + ("</head>\n");
vCode = vCode + ("<style>\n");
vCode = vCode + ("table{font-family:\"Verdana\", \"Arial\", \"Helvetica\", \"sans-serif\";font-size:13px;};\n");
vCode = vCode + ("</style>\n");
vCode = vCode + ("<body onLoad=\"MM_preloadImages('/img/m000921img.gif','/img/m000924img.gif','/img/m000923img.gif','/img/m000922img.gif','/img/m000925img.gif','/img/m000926img.gif','/img/m000927img.gif','/img/m000928img.gif','/img/m000929img.gif','/img/m000930img.gif','/img/m000931img.gif','/img/m000932img.gif')\">\n");
vCode = vCode + ("<table width=\"270\" height=\"130\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("  <tr> \n");
vCode = vCode + ("    <td><table width=\"255\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("        <tr> \n");
vCode = vCode + ("          <td height=\"29\" background=\"/img/m000900img.gif\">\n");
vCode = vCode + ("            <table width=\"255\" height=\"29\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("              <tr> \n");
vCode = vCode + ("                <td width=\"104\"><div align=\"center\"><font color=\"#FFFFFF\"><img src=\"/img/m000935img.gif\" width=\"16\" height=\"17\" align=\"absmiddle\" onClick=\"javascript:yearChanged(1)\" style=\"cursor:hand\"> \n");
vCode = vCode + ("                    <strong id='year'>");
if (showMonthCalendar_year != null)
{
vCode = vCode + showMonthCalendar_year;
}
else
{
var now = new Date();
vCode = vCode + now.getYear();
}
vCode = vCode + ("</strong>&nbsp;<img src=\"/img/m000934img.gif\" width=\"16\" height=\"17\" align=\"absmiddle\" onClick=\"javascript:yearChanged(2)\" style=\"cursor:hand\"></font></div></td>\n");
vCode = vCode + ("                <td width=\"151\"><div align=\"right\">");
if (showMonthCalendar_ok == true)
{
vCode = vCode + ("<img src=\"/img/m000933img.gif\" width=\"57\" height=\"19\" style=\"cursor:hand\" onClick=\"javascript:closeMonthCalendar()\">");
}
if (showMonthCalendar_cancel == true)
{
vCode = vCode + ("&nbsp;<img src=\"/img/m000936img.gif\" width=\"57\" height=\"19\" style=\"cursor:hand\" onClick=\"javascript:window.close()\">");
}
vCode = vCode + ("              </div></td>\n");
vCode = vCode + ("              </tr>\n");
vCode = vCode + ("            </table>\n");
vCode = vCode + ("          </td>\n");
vCode = vCode + ("        </tr>\n");
vCode = vCode + ("        <tr> \n");
vCode = vCode + ("          <td><table width=\"255\" border=\"0\" cellpadding=\"1\" cellspacing=\"0\" bordercolor=\"#0066CC\">\n");
vCode = vCode + ("              <tr> \n");
vCode = vCode + ("                <td bgcolor=\"94AAE1\">\n");
vCode = vCode + ("                  <table width=\"100%\" height=\"84\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("                    <tr> \n");
vCode = vCode + ("                      <td valign=\"bottom\" bgcolor=\"#F4f4f4\">\n");
vCode = vCode + ("                        <table width=\"240\" border=\"0\" align=\"center\">\n");
vCode = vCode + ("                          <tr> \n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image01','','/img/m000921img.gif',1)\"><img src=\"/img/m000901img.gif\" name=\"Image01\" width=\"31\" id=\"Image01\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image01', '/img/m000921img.gif', '01', '/img/m000901img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image02','','/img/m000922img.gif',1)\"><img src=\"/img/m000902img.gif\" name=\"Image02\" width=\"31\" id=\"Image02\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image02', '/img/m000922img.gif', '02', '/img/m000902img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image03','','/img/m000923img.gif',1)\"><img src=\"/img/m000903img.gif\" name=\"Image03\" width=\"31\" id=\"Image03\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image03', '/img/m000923img.gif', '03', '/img/m000903img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image04','','/img/m000924img.gif',1)\"><img src=\"/img/m000904img.gif\" name=\"Image04\" width=\"31\" id=\"Image04\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image04', '/img/m000924img.gif', '04', '/img/m000904img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image05','','/img/m000925img.gif',1)\"><img src=\"/img/m000905img.gif\" name=\"Image05\" width=\"31\" id=\"Image05\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image05', '/img/m000925img.gif', '05', '/img/m000905img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image06','','/img/m000926img.gif',1)\"><img src=\"/img/m000906img.gif\" name=\"Image06\" width=\"31\" id=\"Image06\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image06', '/img/m000926img.gif', '06', '/img/m000906img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                          </tr>                                                                                                                                                                                           \n");
vCode = vCode + ("                        </table> \n");
vCode = vCode + ("                      </td>\n");
vCode = vCode + ("                    </tr>\n");
vCode = vCode + ("                 \n");
vCode = vCode + ("                    <tr> \n");
vCode = vCode + ("                      <td valign=\"top\" bgcolor=\"#F4f4f4\">\n");
vCode = vCode + ("                        <table width=\"240\" border=\"0\" align=\"center\">\n");
vCode = vCode + ("                          <tr> \n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image07','','/img/m000927img.gif',1)\"><img src=\"/img/m000907img.gif\" name=\"Image07\" width=\"31\" id=\"Image07\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image07', '/img/m000927img.gif', '07', '/img/m000907img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image08','','/img/m000928img.gif',1)\"><img src=\"/img/m000908img.gif\" name=\"Image08\" width=\"31\" id=\"Image08\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image08', '/img/m000928img.gif', '08', '/img/m000908img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image09','','/img/m000929img.gif',1)\"><img src=\"/img/m000909img.gif\" name=\"Image09\" width=\"31\" id=\"Image09\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image09', '/img/m000929img.gif', '09', '/img/m000909img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image10','','/img/m000930img.gif',1)\"><img src=\"/img/m000910img.gif\" name=\"Image10\" width=\"31\" id=\"Image10\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image10', '/img/m000930img.gif', '10', '/img/m000910img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image11','','/img/m000931img.gif',1)\"><img src=\"/img/m000911img.gif\" name=\"Image11\" width=\"31\" id=\"Image11\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image11', '/img/m000931img.gif', '11', '/img/m000911img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                            <td><div align=\"center\"><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image12','','/img/m000932img.gif',1)\"><img src=\"/img/m000912img.gif\" name=\"Image12\" width=\"31\" id=\"Image12\" height=\"27\" border=\"0\" onClick=\"itemSelected('Image12', '/img/m000932img.gif', '12', '/img/m000912img.gif', 1)\"></a></div></td>\n");
vCode = vCode + ("                          </tr>\n");
vCode = vCode + ("                        </table> \n");
vCode = vCode + ("                      </td>\n");
vCode = vCode + ("                    </tr>\n");
vCode = vCode + ("                  </table>\n");
vCode = vCode + ("                </td>\n");
vCode = vCode + ("              </tr>\n");
vCode = vCode + ("            </table></td>\n");
vCode = vCode + ("        </tr>\n");
vCode = vCode + ("      </table></td>\n");
vCode = vCode + ("  </tr>\n");
vCode = vCode + ("</table>\n");
vCode = vCode + ("</body>\n");
vCode = vCode + ("</html>\n");
win.document.writeln(vCode);
}


/** showPopup.js */
function showPopup()
{
var url, name, w, h, loca, top, left, status, scroll, resize;
var menubar, toolbar, locat, fullscreen; 
var winprops, win;

url = arguments[0];
name = arguments[1];

if (arguments[2] == "" || arguments[2] == null) w = 300;
else w = arguments[2];

if (arguments[3] == "" || arguments[3] == null) h = 200;
else h = arguments[3];

if ( arguments[4] == "" || arguments[4] == null || arguments[4] == "1" || arguments[4] == "yes"){
top = (screen.height - h) / 2;
left = (screen.width - w) / 2;
loca = 'top='+top+',left='+left+',' ;
} else if(arguments[4] == "0" || arguments[4] == "no"){
if (arguments[5] == "" || arguments[5] == null) top = 0;
else top = arguments[5];
if (arguments[6] == "" || arguments[6] == null) left = 0;
else left = arguments[6];
loca = 'top='+top+',left='+left+',' ;
} else{
loca = '';
}

if (arguments[7] == "" || arguments[7] == null) status = '1';
else status = arguments[7];

if (arguments[8] == "" || arguments[8] == null) scroll = '0';
else scroll = arguments[8];

if (arguments[9] == "" || arguments[9] == null) resize = '0';
else resize = arguments[9];

if (arguments[10] == "" || arguments[10] == null) menubar = '0';
else menubar = arguments[10];

if (arguments[11] == "" || arguments[11] == null) toolbar = '0';
else toolbar = arguments[11];

if (arguments[12] == "" || arguments[12] == null) locat = '0';
else locat = arguments[12];

if (arguments[13] == "" || arguments[13] == null) fullscreen = '0';
else fullscreen = arguments[13];

winprops = 'width='+w+',height='+h+','+loca+'status='+status+',scrollbars='+scroll+',resizable='+resize+',menubar='+menubar+',toolbar='+toolbar+',location='+locat+',fullscreen='+fullscreen;
win = window.open(url,name,winprops);
win.focus();
return false;
}

function closeWindow()
{
window.close();
return false;
}


/** showSerial.js */
var showSerial_obj;
var showSerial_year;
var showSerial_closeScript;
function showSerial()
{
if (arguments[0] == "" || arguments[0] == null)
{
showSerial_obj = null;
}
else
{
showSerial_obj = arguments[0];
}
if (arguments[1] == "" || arguments[1] == null)
{
showSerial_year = null;
}
else
{
showSerial_year = arguments[1];
}
if (arguments[2] == "" || arguments[2] == null)
{
showSerial_closeScript = null;
}
else
{
showSerial_closeScript = arguments[2];
}
var vWinCal = window.open("차수입력", "차수입력", "width=290,height=150,top=200,left=200");
showSerial_build(vWinCal);
}
function showSerial_setValue(value)
{
if (showSerial_obj != null)
{
showSerial_obj.value = value;
}
}
function showSerial_build(win)
{
var vCode;
vCode = ("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n");
vCode = vCode + ("<html>\n");
vCode = vCode + ("<head>\n");
vCode = vCode + ("<title>차수입력</title>\n");
vCode = vCode + ("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">\n");
vCode = vCode + ("<link rel=\"stylesheet\" href=\"css/pub.css\" type=\"text/css\">\n");
vCode = vCode + ("<script language=\"JavaScript\" type=\"text/JavaScript\">\n");
vCode = vCode + ("<!--\n");
vCode = vCode + ("var show_sequence_returnObj;\n");
vCode = vCode + ("var show_sequence_firstItem;\n");
vCode = vCode + ("var show_sequence_secondItem;\n");
vCode = vCode + ("var show_sequence_firstItem_img;\n");
vCode = vCode + ("var show_sequence_secondItem_img;\n");
vCode = vCode + ("var show_sequence_firstItem_value;\n");
vCode = vCode + ("var show_sequence_secondItem_value;\n");
vCode = vCode + ("\n");
vCode = vCode + ("function MM_swapImgRestore() { //v3.0\n");
vCode = vCode + ("  var i,x,a=document.MM_sr; \n");
vCode = vCode + ("  for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++)\n");
vCode = vCode + ("  {if(show_sequence_firstItem != x.id && show_sequence_secondItem != x.id)x.src=x.oSrc;}\n");
vCode = vCode + ("}\n");
vCode = vCode + ("\n");
vCode = vCode + ("function MM_preloadImages() { //v3.0\n");
vCode = vCode + ("  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();\n");
vCode = vCode + ("    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)\n");
vCode = vCode + ("    if (a[i].indexOf(\"#\")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}\n");
vCode = vCode + ("}\n");
vCode = vCode + ("\n");
vCode = vCode + ("function MM_findObj(n, d) { //v4.01\n");
vCode = vCode + ("  var p,i,x;  if(!d) d=document; if((p=n.indexOf(\"?\"))>0&&parent.frames.length) {\n");
vCode = vCode + ("    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}\n");
vCode = vCode + ("  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];\n");
vCode = vCode + ("  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);\n");
vCode = vCode + ("  if(!x && d.getElementById) x=d.getElementById(n); return x;\n");
vCode = vCode + ("}\n");
vCode = vCode + ("\n");
vCode = vCode + ("function MM_swapImage() { //v3.0\n");
vCode = vCode + ("  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)\n");
vCode = vCode + ("   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}\n");
vCode = vCode + ("}\n");
vCode = vCode + ("\n");
vCode = vCode + ("function itemSelected(id, order, img, value, srcimg)\n");
vCode = vCode + ("{\n");
vCode = vCode + ("    var previousId;\n");
vCode = vCode + ("    var previousImg;\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    if (order == 1)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        previousId = show_sequence_firstItem;\n");
vCode = vCode + ("        previousImg = show_sequence_firstItem_img;\n");
vCode = vCode + ("        \n");
vCode = vCode + ("        show_sequence_firstItem = id;\n");
vCode = vCode + ("        show_sequence_firstItem_img = srcimg;\n");
vCode = vCode + ("        show_sequence_firstItem_value = value;\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    else if (order == 2)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        previousId = show_sequence_secondItem;\n");
vCode = vCode + ("        previousImg = show_sequence_secondItem_img;\n");
vCode = vCode + ("\n");
vCode = vCode + ("        show_sequence_secondItem = id;\n");
vCode = vCode + ("        show_sequence_secondItem_img = srcimg;\n");
vCode = vCode + ("        show_sequence_secondItem_value = value;\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("\n");
vCode = vCode + ("    if (previousId != null && previousImg != null)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        MM_swapImage(previousId,'',previousImg,1);\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("\n");
vCode = vCode + ("    MM_swapImage(id,'',img,1);\n");
vCode = vCode + ("}\n");
vCode = vCode + ("\n");
vCode = vCode + ("function yearChanged(type)\n");
vCode = vCode + ("{\n");
vCode = vCode + ("    if (type == 1)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        var yearValue = year.innerText;\n");
vCode = vCode + ("        year.innerText = yearValue - 1;\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    else \n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        var yearValue = year.innerText;\n");
vCode = vCode + ("        year.innerText = eval(yearValue) + 1;\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("}\n");
vCode = vCode + ("\n");
vCode = vCode + ("function closeSerial()\n");
vCode = vCode + ("{\n");
vCode = vCode + ("    if (show_sequence_firstItem_value == null)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        alert('첫번째 자리를 입력하세요');\n");
vCode = vCode + ("        return;\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
vCode = vCode + ("    if (show_sequence_secondItem_value == null)\n");
vCode = vCode + ("    {\n");
vCode = vCode + ("        alert('두번째 자리를 입력하세요');\n");
vCode = vCode + ("        return;\n");
vCode = vCode + ("    }\n");
vCode = vCode + ("    \n");
if (showSerial_obj != null)
{
vCode = vCode + ("    window.opener.showSerial_setValue(year.innerText + \"-\" + show_sequence_firstItem_value + show_sequence_secondItem_value);\n");
}
if (showSerial_closeScript != null)
{
vCode = vCode + ("    window.opener." + showSerial_closeScript + ";\n");
}
vCode = vCode + ("    window.close();\n");
vCode = vCode + ("}\n");
vCode = vCode + ("\n");
vCode = vCode + ("//-->\n");
vCode = vCode + ("</script>\n");
vCode = vCode + ("</head>\n");
vCode = vCode + ("\n");
vCode = vCode + ("<style>\n");
vCode = vCode + ("table{font-family:\"Verdana\", \"Arial\", \"Helvetica\", \"sans-serif\";font-size:13px;};\n");
vCode = vCode + ("</style>\n");
vCode = vCode + ("\n");
vCode = vCode + ("<body leftmargin=\"0\" topmargin=\"0\" onLoad=\"MM_preloadImages('/img/m000725img.gif','/img/m000711img.gif','/img/m000712img.gif','/img/m000713img.gif','/img/m000714img.gif','/img/m000715img.gif','/img/m000716img.gif','/img/m000717img.gif','/img/m000718img.gif','/img/m000719img.gif')\">\n");
vCode = vCode + ("<table width=\"288\" height=\"140\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("  <tr>\n");
vCode = vCode + ("    <td><table width=\"255\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("        <tr> \n");
vCode = vCode + ("          <td height=\"29\" background=\"/img/m000700img.gif\"><table width=\"255\" height=\"29\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("              <tr>\n");
vCode = vCode + ("                <td width=\"104\"><div align=\"center\"><font color=\"#FFFFFF\"><img src=\"/img/m000722img.gif\" width=\"17\" height=\"16\" align=\"absmiddle\" onClick=\"yearChanged(1)\" style=\"cursor:hand\">&nbsp;<strong id='year'>");
if (showSerial_year != null)
{
vCode = vCode + showSerial_year;
}
else
{
var now = new Date();
vCode = vCode + now.getYear();
}
vCode = vCode + ("</strong>&nbsp;<img src=\"/img/m000723img.gif\" width=\"17\" height=\"16\" align=\"absmiddle\" onClick=\"yearChanged(2)\" style=\"cursor:hand\"></font></div></td>\n");
vCode = vCode + ("                <td width=\"151\"><div align=\"right\"><img src=\"/img/m000721img.gif\" width=\"57\" height=\"19\" style=\"cursor:hand\" onClick=\"closeSerial()\"></div></td>\n");
vCode = vCode + ("              </tr>\n");
vCode = vCode + ("            </table></td>\n");
vCode = vCode + ("        </tr>\n");
vCode = vCode + ("        <tr> \n");
vCode = vCode + ("          <td><table width=\"255\" border=\"0\" cellpadding=\"1\" cellspacing=\"0\" bordercolor=\"#0066CC\">\n");
vCode = vCode + ("              <tr>\n");
vCode = vCode + ("                <td bgcolor=\"#336699\"><table width=\"100%\" height=\"84\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("                    <tr> \n");
vCode = vCode + ("                      <td bgcolor=\"#F4f4f4\"> \n");
vCode = vCode + ("                        <table width=\"198\" border=\"0\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\">\n");
vCode = vCode + ("                          <tr>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image0','','/img/m000725img.gif',1)\"><img src=\"/img/m000726img.gif\" name=\"Image0\" id=\"Image0\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image0', 1, '/img/m000725img.gif', 0, '/img/m000726img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image1','','/img/m000711img.gif',1)\"><img src=\"/img/m000701img.gif\" name=\"Image1\" id=\"Image1\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image1', 1, '/img/m000711img.gif', 1, '/img/m000701img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image2','','/img/m000712img.gif',1)\"><img src=\"/img/m000702img.gif\" name=\"Image2\" id=\"Image2\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image2', 1, '/img/m000712img.gif', 2, '/img/m000702img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image3','','/img/m000713img.gif',1)\"><img src=\"/img/m000703img.gif\" name=\"Image3\" id=\"Image3\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image3', 1, '/img/m000713img.gif', 3, '/img/m000703img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image4','','/img/m000714img.gif',1)\"><img src=\"/img/m000704img.gif\" name=\"Image4\" id=\"Image4\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image4', 1, '/img/m000714img.gif', 4, '/img/m000704img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image5','','/img/m000715img.gif',1)\"><img src=\"/img/m000705img.gif\" name=\"Image5\" id=\"Image5\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image5', 1, '/img/m000715img.gif', 5, '/img/m000705img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image6','','/img/m000716img.gif',1)\"><img src=\"/img/m000706img.gif\" name=\"Image6\" id=\"Image6\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image6', 1, '/img/m000716img.gif', 6, '/img/m000706img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image7','','/img/m000717img.gif',1)\"><img src=\"/img/m000707img.gif\" name=\"Image7\" id=\"Image7\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image7', 1, '/img/m000717img.gif', 7, '/img/m000707img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image8','','/img/m000718img.gif',1)\"><img src=\"/img/m000708img.gif\" name=\"Image8\" id=\"Image8\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image8', 1, '/img/m000718img.gif', 8, '/img/m000708img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image9','','/img/m000719img.gif',1)\"><img src=\"/img/m000709img.gif\" name=\"Image9\" id=\"Image9\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image9', 1, '/img/m000719img.gif', 9, '/img/m000709img.gif')\"></a></td>\n");
vCode = vCode + ("                          </tr>\n");
vCode = vCode + ("                        </table></td>\n");
vCode = vCode + ("                    </tr>\n");
vCode = vCode + ("                    <tr> \n");
vCode = vCode + ("                      <td bgcolor=\"#F4f4f4\"> \n");
vCode = vCode + ("                        <table width=\"230\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\n");
vCode = vCode + ("                          <tr>\n");
vCode = vCode + ("                            <td background=\"/img/m000720img.gif\"><img src=\"/img/m000720img.gif\" width=\"4\" height=\"1\"></td>\n");
vCode = vCode + ("                          </tr>\n");
vCode = vCode + ("                        </table></td>\n");
vCode = vCode + ("                    </tr>\n");
vCode = vCode + ("                    <tr> \n");
vCode = vCode + ("                      <td bgcolor=\"#F4f4f4\"> \n");
vCode = vCode + ("                        <table width=\"198\" border=\"0\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\">\n");
vCode = vCode + ("                          <tr> \n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image01','','/img/m000725img.gif',1)\"><img src=\"/img/m000726img.gif\" name=\"Image01\" id=\"Image01\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image01', 2, '/img/m000725img.gif', 0, '/img/m000726img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image11','','/img/m000711img.gif',1)\"><img src=\"/img/m000701img.gif\" name=\"Image11\" id=\"Image11\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image11', 2, '/img/m000711img.gif', 1, '/img/m000701img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image21','','/img/m000712img.gif',1)\"><img src=\"/img/m000702img.gif\" name=\"Image21\" id=\"Image21\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image21', 2, '/img/m000712img.gif', 2, '/img/m000702img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image31','','/img/m000713img.gif',1)\"><img src=\"/img/m000703img.gif\" name=\"Image31\" id=\"Image31\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image31', 2, '/img/m000713img.gif', 3, '/img/m000703img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image41','','/img/m000714img.gif',1)\"><img src=\"/img/m000704img.gif\" name=\"Image41\" id=\"Image41\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image41', 2, '/img/m000714img.gif', 4, '/img/m000704img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image51','','/img/m000715img.gif',1)\"><img src=\"/img/m000705img.gif\" name=\"Image51\" id=\"Image51\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image51', 2, '/img/m000715img.gif', 5, '/img/m000705img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image61','','/img/m000716img.gif',1)\"><img src=\"/img/m000706img.gif\" name=\"Image61\" id=\"Image61\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image61', 2, '/img/m000716img.gif', 6, '/img/m000706img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image71','','/img/m000717img.gif',1)\"><img src=\"/img/m000707img.gif\" name=\"Image71\" id=\"Image71\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image71', 2, '/img/m000717img.gif', 7, '/img/m000707img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image81','','/img/m000718img.gif',1)\"><img src=\"/img/m000708img.gif\" name=\"Image81\" id=\"Image81\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image81', 2, '/img/m000718img.gif', 8, '/img/m000708img.gif')\"></a></td>\n");
vCode = vCode + ("                            <td><a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image91','','/img/m000719img.gif',1)\"><img src=\"/img/m000709img.gif\" name=\"Image91\" id=\"Image91\" width=\"22\" height=\"22\" border=\"0\" onClick=\"itemSelected('Image91', 2, '/img/m000719img.gif', 9, '/img/m000709img.gif')\"></a></td>\n");
vCode = vCode + ("                          </tr>\n");
vCode = vCode + ("                        </table></td>\n");
vCode = vCode + ("                    </tr>\n");
vCode = vCode + ("                  </table></td>\n");
vCode = vCode + ("              </tr>\n");
vCode = vCode + ("            </table></td>\n");
vCode = vCode + ("        </tr>\n");
vCode = vCode + ("      </table></td>\n");
vCode = vCode + ("  </tr>\n");
vCode = vCode + ("</table>\n");
vCode = vCode + ("</body>\n");
vCode = vCode + ("</html>\n");
win.document.writeln(vCode);
}


/** showTree.js */


function TreeList()
{
	// 객체의 빠른 접근을 위한 인덱스 테이블
	this.indexTable     = new Array();
	// 현재 브라우저의 종류를 나타낸다(OTHER=0, MS=1, NS=2)
	this.browserVersion = 0;
	// 트리가 생성될 때의 객체의 이름(기본값:treelist)
    this.name           = "treelist"; 
	this.bTextLink      = true;
	this.count          = 0;
	this.tTrame         = "_blank";
	this.bNewWin        = false;
	this.images         = null;

	// 객체의 초기화
	this.init = function() {
		if ( document.all ) {
			this.setVersion(1);
		} else if ( document.layers) {
			this.setVersion(2);
			self.onresize = this.doResize;
		} else {
			this.setVersion(0);
		}
	}

	// 트리에 필요한 각종 이미지를 설정하는 함수
	this.setImages = function(obj) {
		this.images = obj;
	}
	
	// 객체를 테이블에 추가한다
	this.setObject = function(objId, obj) {
		this.indexTable[objId] = obj;
		return obj;
	}
	
	// 현재의 브라우저 버전을 설정
	this.setVersion = function(ver) {
		this.browserVersion = ver;
	}	

    // 트리객체의 오브젝트명을 설정한다
    // 다수의 트리가 한 페이지에 존재할 경우에 각각을 구분해주기 위해서 필요하다
    this.setName = function(name) {
        this.name = name;
    }
	
	// 전체 트리를 화면에 출력한다
	this.display = function() {
		var root = this.indexTable[0];
		if ( root ) {
			// level, lastnode, link를 입력한다
			root.draw(0,1,"");
			root.show();
		}
		// ROOT폴더를 열린상태로 만든다
		this.clickOnNode(0);
		this.clickOnNode(0);
	}
	
	this.clickOnFolder = function(objId) {
		var clickedFolder = this.indexTable[objId];
		
		// 이 부분은 생각을 좀더 해야겠다.
		// 왜냐하면 설명을 클릭했을 때 expand되었다가 다시 클릭하면 
		// collapse되어야하는데 지금 그렇게 되지 않고 있다.
		if ( !clickedFolder.bOpen ) {
			this.clickOnNode(objId);
		}
		return false;
	}
	
	this.openAllFolder = function()
	{
	    for(var idx=1; idx<this.indexTable.length; idx++)
	    {
	        if (this.indexTable[idx].type)
	        {
	            var tmpFolder = this.indexTable[idx];
	            tmpFolder.toggle(true);
	        }
	    }
    }

	this.closeAllFolder = function()
	{
	    for(var idx=1; idx<this.indexTable.length; idx++)
	    {
	        if (this.indexTable[idx].type)
	        {
	            var tmpFolder = this.indexTable[idx];
	            tmpFolder.toggle(false);
	        }
	    }
    }
	
	// 폴더에만 node가 존재하므로 폴더일때만 작동한다
	this.clickOnNode = function(objId) {
		var clickedNode = null;
		var state       = false;
		
		clickedNode = this.indexTable[objId];

		state       = clickedNode.bOpen;
		
		// toggle
		clickedNode.toggle(!state);
		
		// 링크를 클릭했을 때 다른 페이지로 분기하는 것을 막기 위해서 false를 반환
		return false;		
	}
	
	this.go = function(ref) {
		if ( !opener.closed ) {
			this.openWindow(ref);	
		} else {
			window.open(ref, "newW");
		}
	}
	
	this.openWindow = function(ref) {
		opener.document.location = ref;
	}
		
	// 생성자의 역할을 한다.
	this.init();
}

// composite패턴에서 최상위의 component의 역할을 하는 객체
// 이 객체는 단독으로 사용될 수 없고 항상 Folder또는 Item객체의 멤버로 등록되어야 한다.
// 왜냐하면 자바스크립트는 상속의 개념이 없기 때문에 Entry객체를 Folder 또는 Item객체의
// 상위 객체로서 사용한다
function Entry(treeObj, description, reference, value)
{
    // 엔트가 등록되는 트리객체
    this.treeObj = treeObj;
	
	// 객체가 등록될 때 설정된다

    // 객체설명
	this.desc    = description;	
	// 객체링크
	this.link    = reference;	
	// 코드값
    this.value   = value;     
	// 객체식별자(인덱스테이블에서 식별자로서 역할을 함)
	this.id	     = -1;			

	// 객체의 내용이 html로 출력될 때 값이 설정된다
	// HTML중 객체의 테이블 식별자
	this.obj     = null;
	// HTML중 객체의 이미지식별자
	this.iconImg = null;
	// HTML중 각 노드의 이미지식별자
	this.nodeImg = null;			
	
	// 테이블 식별자, 폴더 또는 아이템 식별자, 및 노드 식별자를 설정한다
	this.setIds = function( objName ) {
		this.obj	= document.all[objName+this.id];
		this.iconImg= document.all[objName+"Icon"+this.id];
		this.nodeImg= document.all[objName+"nodeIcon"+this.id];			
	}
	
	// 이 함수는 가상함수를 제공하는 것으로 기본적으로 자신의 식별자를 만든다
	// 매개변수 obj를 사용하기 위해서 재정의하여 사용해야 한다
	this.add = function(obj){		
		this.id = this.treeObj.count;
		this.treeObj.setObject(this.id, obj);
		this.treeObj.count++;
	}
	
	// 현재의 객체를 숨긴다
	this.hide = function() {
		if ( this.obj.style.display == "none" ) {
			return;
		}
		this.obj.style.display = "none"
	}
	
	// 현재의 객체를 보이게 한다
	this.show = function() {
		this.obj.style.display = "block";
	}
	
}

// composite역할을 하는 Container로서 folder또는 item을 똑같은 방법으로 
// 다루기 위해서 필요하다
function Folder(treeObj, folderDesc, folderLink, value)
{	
	// Entry객체를 상속한다.
	this.entry     = new Entry(treeObj, folderDesc, folderLink, value);
	// folder고유의 멤버변수
	// 자식객체를 저장하는 배열
	this.children  = new Array();	
	// 자식의 갯수
	this.nChildren = 0;
	// 현재 폴더가 마지막 노드인지를 판단하는 플래그
	this.bLastNode = false;			
	// 폴더가 열려있는지를 판단하는 플래그
	this.bOpen     = true;	
	// 폴더인지 엔트리인지 구별
	this.type = true;		
	
	// 객체를 초기화한다
	this.init = function() {
        var treeName = this.entry.treeObj.name;
        
		if ( treeObj.bNewWin && this.entry.link ) {
			this.entry.link = "javascript:"+treeName+".go(\""+this.entry.link+"\")";
		}
		
		// 인덱스 테이블에 등록한다
		this.entry.add(this);
	}
	
	// 함수의 override가 필요하면 여기서 재정의 해야한다.	
	this.hide = function() {
		this.entry.hide();
		this.toggle(false);
	}
	this.show = function() {
		this.entry.show();
	}
	
	this.add  = function(obj) {
		// 폴더의 자식으로서 등록
		this.children[this.nChildren] = obj;
		this.nChildren++;
		return obj;
	}
	
	// 좌측 장식과 객체의 내용을 출력한다
	this.draw = function(level, lastNode, decorator) {
		var img;		// 이미지
		var stag;		// Node를 클릭했을 때 반응하는 action을 지정하기 위한 시작태그
		var etag;		// stag의 종료태그
		var folderId;	// 현재의 아이디(스크립트를 간단하게 위해서)
        var treeName;
				
		folderId = this.entry.id;
        treeName = this.entry.treeObj.name;
						
		// 노드를 클릭할 경우에 반응하는 action을 설정한다
		stag = "<a href='javascript:;' OnClick=\"return "+treeName+".clickOnNode("+folderId+");\" class=k>";
		etag = "</a>";

		// 자신을 출력한다
		if ( level > 0 ) {
			var nodeimg;
            var imgSrc;
            var folderName = treeName+"nodeIcon"+folderId;
			if ( lastNode ) {
                nodeimg = this.entry.treeObj.images.mlastnode;                
                imgSrc  = this.entry.treeObj.images.blank;
				img = "<img name='"+folderName+"' src='"+nodeimg+"' width=16 height=22 border=0>";
				this.drawObj(decorator + stag + img + etag);				
				decorator = decorator + "<img src='"+imgSrc+"' width=16 height=22 border=0>";
				this.bLastNode = true;
			} else {
				// 자식이 있는 경우는 pnode.gif로 표시하고 그리고 링크를 걸고
				// 하지만 자식이 없는 경우는 node.gif를 표시하고 링크를 걸지 않는다
				if ( this.nChildren ) {
					nodeimg = this.entry.treeObj.images.pnode;
					img = "<img name='"+folderName+"' src='"+nodeimg+"' width=16 height=22 border=0>";
					this.drawObj(decorator + stag + img + etag);			
					
				} else {
					nodeimg = this.entry.treeObj.images.node;
					img = "<img name='"+folderName+"' src='"+nodeimg+"' width=16 height=22 border=0>";
					this.drawObj(decorator + img );								
				}
                imgSrc = this.entry.treeObj.images.vline;
				decorator = decorator + "<img src='"+imgSrc+"' width=16 height=22 border=0>";
				this.bLastNode = false;
			}
		} else {
			// Root를 출력한다
			this.drawObj("");
		}
				
		// 자식이 있으면 자식을 출력한다
		if ( this.nChildren > 0 ) {
			var i=0;
			level++;
			for(i=0; i<this.nChildren; i++) {
				if ( i == (this.nChildren-1)) {
					this.children[i].draw(level, true, decorator);
				} else {
					this.children[i].draw(level, false, decorator);
				}
			}
		}
		
	}
	
	// 객체의 내용에 장식을 붙여 HTML형식으로 출력한다
	this.drawObj = function(decorator) {		
        var treeName   = this.entry.treeObj.name;
        var folderId   = treeName + this.entry.id;
        var folderIcon = treeName + "Icon" + this.entry.id;

		document.write("<TABLE ");
		document.write(" id = '"+folderId+"' style='position:block;' ");
		document.write(" border=0 cellspacing=0 cellpadding=0><tr><td>");
		document.write(decorator);	
		document.write("<img name='"+folderIcon+"' src='"+this.entry.treeObj.images.folderopen+"' border=0>");	
		document.write("</td><td valign=middle nowrap>");
		
		if ( this.entry.treeObj.bTextLink ) {
			this.writeLink();
			document.write("<NOBR>"+this.entry.desc+"</NOBR></a>");
		} else {
			document.write("<NOBR>"+this.entry.desc+"</NOBR>");
		}
		
		document.write("</td></tr></TABLE>");

		this.entry.setIds(treeName);		

	}
	
	this.writeLink = function() {
        var treeName = this.entry.treeObj.name;
		if ( this.entry.link ) {
			document.write("<a href='"+this.entry.link+"' class=k target=\""+this.entry.treeObj.tFrame+"\" ");
			document.write(" OnClick="+treeName+".clickOnFolder('"+this.entry.id+")'>");			
		} else {
			if ( this.entry.id != 0 ) {
				document.write("<a href='javascript:;'  class=k OnClick=\""+treeName+".clickOnFolder('"+this.entry.id+"'); return false;\">");
			}
		}
	}
	
	this.toggle = function(bOpen) {
		// 현재의 상태와 같으면 그냥 종료한다
		if ( this.bOpen == bOpen ) {
			return;
		}
		
		this.bOpen = bOpen;
		this.propagate();
	}
	
	// 노드아이콘 폴더아이콘을 상태에 맞는 아이콘으로 바꾸고,
	// bOpen이 true이면 자식을 펼지고 false이면 자식을 감춘다
	this.propagate = function() {
		var i = 0;
		if ( this.bOpen ) {
			// 노드아이콘을 바꾼다
			if ( this.entry.nodeImg ) {							
				if ( this.bLastNode ) {
					this.entry.nodeImg.src = this.entry.treeObj.images.mlastnode;
				} else {
					this.entry.nodeImg.src = this.entry.treeObj.images.mnode;
				}
			}
			// 폴더 아이콘을 바꾼다
			this.entry.iconImg.src = this.entry.treeObj.images.folderopen;
			// 자식이 있는 경우에 자식을 보이게 만든다
			for(i=0; i<this.nChildren; i++ ) {
				this.children[i].show();
			}
		} else {
			// 노드아이콘을 바꾼다
			if ( this.entry.nodeImg ) {							
				if ( this.bLastNode ) {
					this.entry.nodeImg.src = this.entry.treeObj.images.plastnode;
				} else {
					this.entry.nodeImg.src = this.entry.treeObj.images.pnode;
				}
			}
			// 폴더 아이콘을 바꾼다
			this.entry.iconImg.src = this.entry.treeObj.images.folderclosed;
			// 자식이 있는 경우에 자식을 보이지 않게 한다
			for(i=0; i<this.nChildren; i++ ) {
				this.children[i].hide();
			}			
		}
	}
	
	// 생성자의 역할을 수행한다(변수의 초기화)
	this.init();

}

// composite패턴에서 LEAF에 해당되는 객체
function Item(treeObj, target, itemDesc, itemLink, value)
{	
	// Entry객체를 상속한다
	this.entry = new Entry(treeObj, itemDesc, itemLink, value);
	this.target = target;
	this.type = false;		
	
	// 객체의 초기화
	this.init = function() {
		var ref     = "";
		var fullRef = "";
        
		if ( this.entry.treeObj.bNewWin && this.entry.link ) {
			ref = "javascript:"+this.entry.treeObj.name+".go(\""+this.entry.link+"\")";
		} else {
			ref = this.entry.link;
		}
		
		if ( ref != "" ) {
			if ( this.target == "" ) {
				fullRef = "'"+ref+"' target=\""+this.entry.treeObj.tFrame+"\"";
			} else {
				fullRef = "'"+ref+"' target=\""+this.target+"\"";
			}
		}
		
		this.entry.link = fullRef;
		
		this.entry.add(this);
	}
	
	// 함수의 override가 필요하면 여기서 재정의 해야한다.	
	this.hide = function() {
		this.entry.hide();
	}
	this.show = function() {
		this.entry.show();
	}
	
	this.draw = function(level, lastNode, decorator) {
		// 이미지
		var img;		
		
		// item은 자식을 가지고 있지 않기 때문에 자기 자신만을 출력하면 된다.
		if ( level > 0 ) {
			if ( lastNode ) {
				img = "<img src='"+this.entry.treeObj.images.lastnode+"' width=16 height=22>";				
			} else {
				img = "<img src='"+this.entry.treeObj.images.node+"' width=16 height=22>";
			}
			this.drawObj(decorator+img);
		} else {
			this.drawObj("");
		}
	}
	
	// 객체의 내용에 장식을 붙여 HTML형식으로 출력한다
	this.drawObj = function(decorator) {
        var treeName = this.entry.treeObj.name;
        var itemId   = treeName + this.entry.id;
        var itemIcon = treeName + "Icon" + this.entry.id;

		document.write("<TABLE ");
		document.write(" id='"+itemId+"' style='position:block;' ");			
		document.write("border=0 cellspacing=0 cellpadding=0><tr><td>");
		document.write(decorator);
		document.write("<img id='"+itemIcon+"' src='"+this.entry.treeObj.images.doc+"' border=0>");
		document.write("</td><td valign=middle nowrap>");
		
		if ( this.entry.treeObj.bTextLink && this.entry.link ) {
			document.write("<NOBR>");
            if ( typeof(this.entry.treeObj.OnClick) == 'undefined' ) {
//    			document.write("<a href="+this.entry.link+" class=k>"+this.entry.desc+"</a>");
    			document.write("<a href=javascript:goPage(&#39" + itemLink + "&#39) class=k>"+this.entry.desc+"</a>");
            } else {
                document.write("<a href='javascript:;' OnClick="+treeName+".OnClick("+treeName+".indexTable["+this.entry.id+"]) class=k>"+this.entry.desc+"</a>");
            }
			document.write("</NOBR>");	
		} else {
			document.write("<NOBR>"+this.entry.desc+"</NOBR>");
		}
		
		document.write("</td></tr></TABLE>");	

		this.entry.setIds(treeName);
		
	}
	
	// 생성자의 역할을 수행한다
	this.init();
}

function TreeImages(imgpath)
{
	this.plastnode    = imgpath + "/m000814img.gif";    
	this.folderopen   = imgpath + "/m000815img.gif";
	this.mnode        = imgpath + "/m000816img.gif";
	this.pnode        = imgpath + "/m000817img.gif";
	this.blank        = imgpath + "/m000818img.gif";
	this.folderclosed = imgpath + "/m000819img.gif";
	this.mlastnode    = imgpath + "/m000820img.gif";
	this.lastnode     = imgpath + "/m000821img.gif";
	this.node         = imgpath + "/m000822img.gif";
	this.doc          = imgpath + "/m000823img.gif";
	this.vline        = imgpath + "/m000824img.gif";
	
	this.init = function() {
		// 이미지를 preloading한다
		var img1 = new Image();
		img1.src = this.plastnode;
		
		var img2 = new Image();
		img2.src = this.folderopen;
		
		var img3 = new Image();
		img3.src = this.mnode;
		
		var img4 = new Image();
		img4.src = this.pnode;
		
		var img5 = new Image();
		img5.src = this.blank;
		
		var img6 = new Image();
		img6.src = this.folderclosed;
		
		var img7 = new Image();
		img7.src = this.mlastnode;
		
		var img8 = new Image();
		img8.src = this.lastnode;
		
		var img9 = new Image();
		img9.src = this.node;
		
		var img10 = new Image();
		img10.src = this.doc;
		
		var img11 = new Image();		
		img11.src = this.vline;
	}
	
	this.init();
}


/** totalOfCheckedItems.js */
function doTotalOfCheckedItems(f_name, ck_name, cell_name, tot_name)
{
var doc=document.f_name;
var total=0;
var tmp=0;
if(ck_name.length>0)
{
for (var i = 0; i <ck_name.length; i++)
{
if (ck_name[ i ].checked == true)
{
switch(cell_name[i].type)
{
case "text" :
tmp=eval(cell_name[i].value);
if(isNaN(tmp))
{
tmp=0;
}
else
{
tmp=eval(cell_name[i].value);
}
total +=tmp;
break;
case undefined:
tmp=eval(cell_name[i].innerText);
if(isNaN(tmp))
{
tmp=0;
}
else{ tmp=eval(cell_name[i].innerText);}
total+=tmp;
break;
}
}
}//for
tot_name.value=total;
}//if
else
{
if (ck_name.checked == true)
{
switch(cell_name.type)
{
case "text" :
tmp=eval(cell_name.value);
if(isNaN(tmp))
{
tmp=0;
}
else
{
tmp=eval(cell_name.value);
}
break;
case undefined:
tmp=eval(cell_name.innerText);
if(isNaN(tmp))
{
tmp=0;
}
else
{
tmp=eval(cell_name.innerText);
}
break;
}
}
tot_name.value=tmp;
}
}


/*==============================================================================
*  Glue F/W을 위한 Ajax Java Script
==============================================================================*/
    function initRequest() {
        try {
         //IE 7 부터
           request = new XMLHttpRequest();
         } catch (trymicrosoft) {
           try {
            // IE 6
             request = new ActiveXObject("Msxml2.XMLHTTP");
           } catch (othermicrosoft) {
             try {
             //IE 6 이전 버젼
               request = new ActiveXObject("Microsoft.XMLHTTP");
             } catch (failed) {
               request = null;
             }
           }
         }
        if(request==null){
            alert("Request 생성 안됨.");
        } else {
            return request;
        }
    }
    
    function callReq(url,callback,id) {
        var req = initRequest();
        
        if(req == null) alert("Reqeust null callReq");
        //req.onreadystatechange = callback;
        req.onreadystatechange =function () 
			{
				if ( req.readyState == 4 ){
					callback(req,id);
				}
			}
        req.open("POST", url, true); // asynchronous
        req.send(null);
        //alert("callReq");
    }
    
    function handlePageForAjax(req,id){
        var data = req.responseText;
        var htmlData = document.getElementById(id);
        htmlData.innerHTML= data;
        return false;
    }     