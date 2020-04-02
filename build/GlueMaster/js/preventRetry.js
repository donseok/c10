/*
 * Copyright(c) 2010 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : preventRetry.js
 * @FileName       : preventRetry
 * Change history
 * @Author         : 주정민
 * @LastVersion    : 1.2
 *     2003-11-21    주정민
 *     1.0           최초작성
 *     2003-11-01    정창호
 *     1.1           export null check, toUpperCase 적용
 *     2004-07-21    남광현
 *     1.2           srcElement null check
 */

var onProcessing = null;
var isExport = false;

// Document 상에서 일어나는 모든 MouseUp Event를 감시한다.
document.attachEvent('onmouseup',checkEvent);

/** 
 * MouseUp Event를 일으킨 컨트롤이 excel export 버튼일 경우 isExport 전역변수를 true로
 * 설정하여 onSubmit Event가 발생되었을때 onProcessing 전역변수에 값을 설정하지 않도록 한다.
 */
function checkEvent(){
	if (event.srcElement != null) {
		if (event.srcElement.name != null && event.srcElement.type == "image" &&  event.srcElement.name.toUpperCase().indexOf("EXPORT")!= -1) {
			isExport = true;
		}
	} else {
		isExport = false;
	}
}

/**
 * onSubmit Event가 발생되었을때 호출되어 onProcessing 전역변수에 값을 설정하고 Server로 부터
 * Response를 받기 전에는 다시 request를 보낼 수 없도록 한다.
 */
function checkRetry()
{
	if (onProcessing == null){
		if (event != null){
			if (!isExport){
				onProcessing = new Date();
			}
		} else{
			onProcessing = new Date();
		}
		return true;
	} else {
		alert("처리중입니다.");
		return false;
	}
}

function lockF5(){
	if (event.keyCode == 116) {
		event.keyCode = 0;
		checkRetry();
	}
}

document.onkeydown = lockF5;
