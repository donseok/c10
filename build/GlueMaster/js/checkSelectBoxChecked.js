/*
 * Copyright(c) 2010 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : checkSelectBoxChecked.js
 * @FileName       : checkSelectBoxChecked
 * Change history
 * @Author         : 오용현
 * @LastVersion    : 1.0
 *   2003-05-16    오용현
 *    1.0           After Unit Testing 
 */

/**
 * @Function 명   : checkSelectbox
 * @Function 설명 : 조회부의 각Row에 CheckBox에 선택 여부을 판단
 * @Param         : 1. form : (object)  HTML의 form 명
 * @return값      : boolean
 * @사용 Event    : onClick
 * @see           : 
 */
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
