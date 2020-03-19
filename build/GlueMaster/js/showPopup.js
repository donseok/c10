/*
 * Copyright(c) 2011 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : showPopup.js (UTF-8)
 * @FileName       : showPopup
 * Change history
 * @Author         : 황유진
 * @LastVersion    : 1.0
 *   2011-07-21 / 황유진 / winprops수정 세미콜론(;)대신에 컴마(,)로 연결하도록 수정
 */

/*
 * Function Description: 팝업을 특정 위치에 특정 크기로 출력.
 * @author  Chung Young Hun
 * @version 1.1
 * @param
 *          url: Popup page의 위치 경로
 *          name : Popup window 이름, TARGET에서 사용
 *          w : 팝업의 width값
 *          h : 팝업의 heigth값
 *          center : 팝업의 중앙출력 여부
 *          top : 팝업의 출력 위치
 *          left : 팝업의 출력 위치
 *          status : 상태바 출력 여부
 *          scroll : 스크롤바 출력 여부
 *          resize : 팝업 size 조정가능 여부 
 *          menubar : 팝업의 menubar출력 여부
 *          toolbar : 팝업의 toolbar출력 여부
 *          locat : 팝업의 location출력 여부
 *          fullscreen : 전체화면으로 출력여부
 * @return 
 */
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

	//팝업을 중앙에 출력시킬지 특정 위치에 출력시킬지 여부 결정
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