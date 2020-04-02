
function getFirstChild(targetEle){

	var firstEle = targetEle.firstChild;

	if(firstEle && firstEle.nodeType == 3){
		firstEle = targetEle.childNodes[1];
	}

	return firstEle;
}

function getNextSibling(targetEle){

	var nextEle = targetEle.nextSibling;

	if(targetEle.nextSibling && nextEle.nodeType == 3){
		nextEle = getNextSibling(nextEle);
	}

	return nextEle;
}


/*
 * Copyright(c) 2010 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : showInsertableRow.js
 * @FileName       : Table의 Row를 추가 또는 삭제
 * Change history
 * @Author         : 황유진
 * @LastVersion    : 1.0
 *   2003-05-16    황유진
 *    1.0           After Unit Testing
 */

/** 기존Row 복사
 * @author 김성태
 * @company PosData Corporation
 * @version 1.0
 * @param table_id : table id 이름
 * @      eTable_id : hidden table id 이름
 * @      chkname : checkbox 이름
 */
function insRow(table_id,eTable_id,chkname){
	if (chkname == null && eTable_id == null )
	{
		return false;
	}
	if( chkname!= null && chked(chkname) ){
		//체크박스를 선택되어 있을때 그 Row를 바로 위로 복사
		minsRow(table_id.rows[0],chkname);
	} else{
		if( eTable_id != null){
			//체크박스를 선택하지 않고 행삽입 눌룰시 빈 HiddenTable존재시 그 Table의 Row를 복사
			insertRowNochk(table_id,eTable_id);
		}
	}
	return false;
}

function minsRow(trtag) {
	if (trtag) {
		var tdtag = getFirstChild(trtag);
		var chktag = getFirstChild(tdtag);
		if (getNextSibling(trtag)) minsRow(getNextSibling(trtag));
		if (chktag.checked == true) insertRow(tdtag);
	}
}

function insertRow(tdtag) {
	var trtag = tdtag.parentElement;
	var oCloneNode = trtag.cloneNode(true);

	var oCloneChktag = getFirstChild(getFirstChild(oCloneNode));
	oCloneChktag.checked = false;

	trtag.parentElement.insertBefore(oCloneNode,trtag);
	swapall(trtag,getNextSibling(trtag));
}

function insertRowNochk(table_id,eTable_id){
	//var hTrtag = eTable_id.firstChild.firstChild; // 도대체 뭐가 맞는겐지?
	var hTrtag = eTable_id.rows[0]; // 도대체 뭐가 맞는겐지?
	var oCloneNode = hTrtag.cloneNode(true);

	var oCloneChktag = getFirstChild(getFirstChild(oCloneNode));
	oCloneChktag.checked = false;

	var table_id_first = getFirstChild(table_id);
	table_id_first.insertBefore(oCloneNode,null);
	if(table_id.rows[0] != null){
		trtag=table_id.rows[0];
		swapall(trtag,getNextSibling(trtag));
	}
}

/** 기존Row 삭제
 * @author 김성태
 * @company PosData Corporation
 * @version 1.0
 * @param table_id : source inputField 이름
 * @      chkname : dest inputField 이름
 */
function delRow(table_id,chkname){
	var chk = chked(chkname);
	if( chk == true){
		// 체크가 되어있는  Row를 삭제한다.
		mdelrow(table_id.rows[0]);
	}
	return false;
}

function mdelrow(trtag){
	if (trtag){
		var tdtag = getFirstChild(trtag);
		var chktag = getFirstChild(tdtag);
		if (getNextSibling(trtag)) mdelrow(getNextSibling(trtag));
		if (chktag.checked == true){
			chktag.checked = false;
			removeRow(tdtag);
		}
	}
}

function removeRow(tdtag) {
	var trtag = tdtag.parentElement;
	var Ttag = getNextSibling(trtag);
	var tabtag = trtag.parentElement;
	tabtag.deleteRow(trtag.rowIndex);
	if (Ttag) swapall(Ttag,getNextSibling(Ttag));
}

/** 기존Row 복사, 삭제시 인덱스 정렬 (index는 ShowTableTag에서 지원해 주는 속성이다-Td에 들어간다.)
 * @author 김성태
 * @company PosData Corporation
 * @version 1.0
 * @param trtag : source inputField 이름
 * @      Ttag : dest inputField 이름
 */
function swapall(trtag,Ttag) {
	var node;
	var chktag = getFirstChild(getFirstChild(trtag));
	// 다음 row가 존재시
	if (getNextSibling(trtag)) {
		for(var ch =0 ; ch <trtag.childNodes.length ; ch++){
			if(ch==0) chktag.value = Ttag.rowIndex-1;
			trtag.childNodes[ch].index = Ttag.rowIndex-1;
		}
		swapall(getNextSibling(trtag),getNextSibling(Ttag));
	//다음 row가 미존재시(마지막 Row일때)
	} else {
		for(var ce =0 ; ce <trtag.childNodes.length ; ce++){
			if(ce==0) chktag.value =  trtag.rowIndex;
			trtag.childNodes[ce].index = trtag.rowIndex;
		}
	}
}

/** 첫 column의 checkbox중 체크 되어 있는 Row가 있는지 체크
 * @author 김성태
 * @company PosData Corporation
 * @version 1.0
 * @param chkname : source inputField 이름
 */
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