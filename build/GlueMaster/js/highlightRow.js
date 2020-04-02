/*
 * Copyright(c) 2010 POSCO ICT
 * @ProcessChain   : Reuse
 * @File           : HighLightRow.js
 * @FileName       : 화면 한글 명칭
 * Change history
 * @Author         : 정소희
 * @LastVersion    : 1.2
 *     2003.05.09    정소희
 *     1.0           for review
 *     2003.12.08    김동호
 *     1.1           갯수가 다른 테이블에서 자바스크립트 오류 수정. 
 *     2004-07-21    남광현
 *     1.2           mHiRow 재귀 호출시 465개 이상이면 memory overflow
 *                     호출방법 변경
 */

/**
 * @Function 명   : in_ch
 * @Function 설명 : Table내의 RowIndex를 인지하여 해당 Row의 색을 변경시킴.
 * @Param         : 1. focus (event 1 : onMouseOver   2 : onMouseOut)	
 *                  2. trtag (해당 Object 즉, 해당 Table Row)
 *                  3. oTable (연계될 Table ID)
 *                ※ 이 부분은 주로 하나의 테이블에서 하나의 Row 색 변화와, 둘 이상의 테이블 연동시 Row 색 변화에 사용됨
 */
function in_ch(focus,trtag,oTable) {
    var idx = parseInt(trtag.rowIndex);
    var tdStyle = "";
    if (focus == 0) {
        tdStyle = "#D9F8D9";
    }
    trtag.style.backgroundColor = tdStyle;

    if (oTable != null && oTable != "") {
        oTrtag = oTable.rows[idx];
        if (oTrtag != null && oTrtag != "") {
            oTrtag.style.backgroundColor = tdStyle;
        }
    }
}

function in_ch_plus(focus,trtag,oTable,plus) {
    var idx = parseInt(trtag.rowIndex);
    var tdStyle = "";
    if (focus == 0) {
        tdStyle = "#D9F8D9";
    }
    trtag.style.backgroundColor = tdStyle;

    if (oTable != null && oTable != "") {
        oTrtag = oTable.rows[idx+plus];
        if (oTrtag != null && oTrtag != "") {
            oTrtag.style.backgroundColor = tdStyle;
        }
    }
}

/**
 * @Function 명   : hiRow, mHiRow, runHiRow
 * @Function 설명 : Table내의 RowIndex를 인지하여 해당 Row의 색을 변경시킴.
 * @Param         : 1. table_id (Table ID)
 *                  2. oTrtag (해당 Object 즉, 해당 Table Row)		
 *                  3. focus (event 1 : onMouseOver시	   2 : onMouseOut시)
 *                ※ 이 부분은 주로 하나의 테이블에서 하나이상의 Row 색 변화에 사용됨(RowSpan으로 두줄 이상이 하나의 Row로 사용될 때)
 */
function hiRow(table_id, oTrtag, focus){
	mHiRow(table_id.firstChild.firstChild,oTrtag,focus);
	return false;
}

function mHiRow(trtag,oTrtag,focus) {
	for (i = 0; i < oTrtag.childNodes.length; i++) {
		if (oTrtag.childNodes[i]) {
			if (focus == 0) {
				oTrtag.childNodes[i].style.backgroundColor = "#D9F8D9";
			} else{
				oTrtag.childNodes[i].style.backgroundColor = "";
			}
		}
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
	if(focus==0){
		for(var i =0 ; i < tdNum ; i++){
			trtag.childNodes[i].style.backgroundColor="#D9F8D9";
		}
	}else{
		for(var j =0 ; j < tdNum ; j++){
			trtag.childNodes[j].style.backgroundColor="";
		}
	}
}
