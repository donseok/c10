/*===========================================================================
*Copyright(c) 2011 유니온스틸
*Change history
*@LastModifyDate : 20120504
*@LastModifier     :  박영진
*@LastVersion      :  1.0
*    2012-05-04   박영진
*        1.0         최초 생성
*
===========================================================================*/
package com.unionsteel.mes.c10.activity.common;

import com.poscoict.glue.biz.dhtmlx.DhtmlxActivity;
import com.posdata.glue.PosException;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;

/**
 * 이 클래스는 화면 UI에서 표현 될 message를 PosContext에 세팅하는 Custom Activity이다.
 * 
 * <xmp>
 * 
 * Property 상세
 * msgKey :  ctx에 담길 msg key
 * msg    :  message key에 담길 내용
 *   
 * </xmp>
 * @author 박영진
 *
 */
public class SetUIMessage extends DhtmlxActivity {

	/**
	 * 이 Activity는 Dhtmlx용 공통 Activity에 대한 Main 기능을 수행하는 추상 Method이다
	 * 이 Class를 상속받는 Activity는 이 Method를 정의하도록 한다
	 * @param ctx PosContext 객체
	 * @return String transition명으로 일반적으로 success또는 failure를 지정한다
	 */
	public String doMainActivity(PosContext ctx) {
		
		String msgKey = getProperty("MSG_KEY") == null ? "" : getProperty("MSG_KEY");
		String msg = getProperty("MSG") == null ? "" : getProperty("MSG");
		
		if(msg.contains("#")){			
			PosRowSet rowset = (PosRowSet)ctx.get(getProperty("bind-key"));                                                                                                                                                                                                                     
			if(rowset.count()>0){
				PosRow[] row;
				row = rowset.getAllRow();
				String temp = (String)row[0].getAttribute(getProperty("column-id"));
				msg = msg.replaceAll("#",temp);		
			}
		}		
		if(msgKey.equals("errMsg")){
			throw new PosException(msg);
		}	
		
		ctx.put(msgKey, msg);
		
		return "SUCCESS";
	}

	@Override
	public String doPostActivity(PosContext arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String doPreActivity(PosContext arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getDefaultMsgCode() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String[] getDefaultMsgParam(PosContext arg0) {
		// TODO Auto-generated method stub
		return null;
	}
}
