/*
 * ===========================================================================
 * Copyright(c) 2011 유니온스틸
 * @FileName : C10DhtmlxActivity.java
 * Change history
 * @LastModifyDate : 20120306
 * @LastModifier : 이민균
 * @LastVersion : 1.0
 * 2012-03-06 이민균
 * 1.0 최초 생성
 * ===========================================================================
 */
package com.unionsteel.mes.c10.activity.common;

import java.util.List;

import com.poscoict.glue.biz.dhtmlx.DhtmlxActivity;
import com.poscoict.glue.dhtmlx.util.ActivityUtil;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 클래스는 출하관제의 상속받기 위한 공통 CLASS 이다. <xmp> 사용방법 Property 상세 </xmp>
 * 
 * @author 이민균
 * @see DhtmlxActivity
 * @version 1.0
 */

public class C10DhtmlxActivity extends DhtmlxActivity implements
	C10NuiConstantsIF {
    /**
     * 이 Activity는 Dhtmlx용 공통 Activity에 대한 Main 기능 전에 수행해야 할 내용에 대한 추상 Method이다
     * 이 Class를 상속받는 Activity는 이 Method를 정의하도록 한다
     * 
     * @param poscontext
     *            PosContext 객체
     * @return "" 현재 정해진 기능은 없다.
     */
    public String doPreActivity(PosContext poscontext) {
	// TODO Auto-generated method stub
	return null;
    }

    /**
     * 이 Activity는 Dhtmlx용 공통 Activity에 대한 Main 기능을 수행하는 추상 Method이다 이 Class를
     * 상속받는 Activity는 이 Method를 정의하도록 한다
     * 
     * @param poscontext
     *            PosContext 객체
     * @return String transition명으로 일반적으로 success또는 failure를 지정한다
     */
    public String doMainActivity(PosContext poscontext) {
	// TODO Auto-generated method stub
	return null;
    }

    /**
     * 이 Activity는 Dhtmlx용 공통 Activity에 대한 Main 기능 후에 수행해야 할 내용에 대한 추상 Method이다
     * 이 Class를 상속받는 Activity는 이 Method를 정의하도록 한다
     * 
     * @param poscontext
     *            PosContext 객체
     * @return "" 현재 정해진 기능은 없다.
     */
    public String doPostActivity(PosContext poscontext) {
	// TODO Auto-generated method stub
	if (poscontext.get(COLUMN_INFO) != null
		&& poscontext.get(COLUMN_INFO) instanceof String[])
	    poscontext.put(COLUMN_INFO,
		    ((String[]) poscontext.get(COLUMN_INFO))[0]);

	return null;
    }

    /**
     * 이 메소드는 Reusable Component 제작 시 Default Message Key를 지정하는 추상 메소드이다.
     * 
     * @return String 해당 Activity에서 지정한 default Message key
     */
    public String getDefaultMsgCode() {
	// TODO Auto-generated method stub
	return null;
    }

    /**
     * 이 메소드는 Reusable Component 제작 시 Default Message Key에 Binding할 변수를 리턴하는 추상
     * 메소드이다.
     * 
     * @return String[] 해당 Activity에서 지정한 default Message에 Biding할 변수에 대한 배열
     */
    public String[] getDefaultMsgParam(PosContext poscontext) {
	// TODO Auto-generated method stub
	return null;
    }

    /**
     * 이 메소드는 화면에 보여줄 메세지를 생성하는 메소드이다. Reusable Component의 경우 Activity의 종류에 따라
     * 자동으로 Default Message를 보여주도록 되어 있다 체크 로직은 아래와 같다 0. glue-gun에서 제공하는
     * Reusable Component는 Default Message를 가지고 있다 1. (기존 다른 Activity에서 생성한
     * )msgApp가 없다면 무조건 메세지를 생성한다 2. msg-code를 지정하지 않으면 Custom Activity의 경우
     * Skip하고 Reusable Activity는 Default msg-code를 부여한다 3. 이전 Activity에서 생성한
     * 메세지의 우선순위와 비교하여 우선순위가 높은 메세지를 저장한다
     * 
     * @param ctx
     *            PosContext 객체
     * @param Object
     *            조회용 Activity의 경우 건수를 알아오기 위한 PosRowSet과 같은 객체
     * @return String 생성한 Message
     */
    protected String makeMessage(PosContext ctx, Object object) {

	Integer msgOrder = new Integer(this.getProperty(PN_MSG_ORDER,
		PV_LOWEST_PRIORITY));
	Integer prevMsgOrder = ctx.get(STR_APP_MSG_ORDER) == null ? new Integer(
		999) : (Integer) ctx.get(STR_APP_MSG_ORDER);

	/* msg-order가 우선 순위가 낮으면(숫자가 더 크면) Skip */
	if (ctx.get(STR_APP_MSG) != null
		&& msgOrder.compareTo(prevMsgOrder) >= 0)
	    return STR_BLANK_STRING;

	/*
	 * 화면에 보여줄 메세지 코드를 가져온다. property [msg-code]를 지정하지 않으면 Default Code 값을
	 * 가져온다.
	 */
	String msgCode = this.getProperty(PN_MSG_CODE);
	String[] msgParam = null;

	if (msgCode == null) {
	    msgCode = this.getDefaultMsgCode();
	    msgParam = this.getDefaultMsgParam(ctx);
	} else {
	    int count = this.getIntProperty(PN_MSG_PARAM_COUNT);

	    if (count >= 0) {
		msgParam = new String[count];
		String propertyValue = null;
		for (int i = 0; i < count; i++) {
		    propertyValue = this.getProperty(PN_MSG_PARAM + i);

		    /*
		     * 송범용 : 모든 Activity에서 PosContext에 ROW_COUNT를 넣는 것은 비효율적임.
		     * 로직 변경
		     */
		    if (PV_ROW_COUNT.equals(propertyValue)) {
			if (object instanceof PosRowSet
				|| object instanceof List) {
			    msgParam[i] = String.valueOf(((PosRowSet) object)
				    .count());
			} else {
			    msgParam[i] = (String) object;
			}
		    } else {
			msgParam[i] = ActivityUtil.convertToString(ctx
				.get(propertyValue));
		    }
		}
	    }
	}

	if (msgCode == null)
	    return STR_BLANK_STRING;

	String appMsg = makeMessage(ctx, msgCode, msgParam);

	if (logger.isDebugEnabled())
	    logger.logDebug("생성된메세지 : " + appMsg + ", 우선순위 : " + msgOrder);

	ctx.put(STR_APP_MSG, appMsg);
	ctx.put(STR_APP_MSG_ORDER, msgOrder);

	return appMsg;
    }
    
    /**
     * 특정 Row를 가져오는 method이다.
     * @param ctx
     * @param rkName : RowSet이름
     * @param idx
     * @return rtn
     */
    public PosRow getIndexPosRow(PosContext ctx, String rkName, int idx) {
        PosRowSet vo  = getPosRowSet(ctx, rkName);
        PosRow    row = null;
        
        if(vo!=null && vo.count()>idx) {
            row = vo.getAllRow()[idx];
        }
        
        return row;
    }
    
    /**
     * 특정 RowSet을 가져오는 method이다.
     * @param ctx
     * @param rkName : RowSet이름
     * @return rtn
     */
    public PosRowSet getPosRowSet(PosContext ctx, String rkName) {
        PosRowSet vo = (PosRowSet)ctx.get(rkName);
        if(vo!=null) {
            vo.reset();
        }
        
        return vo;
    }

}
