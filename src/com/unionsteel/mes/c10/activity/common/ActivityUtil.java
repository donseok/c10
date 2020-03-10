/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : ActivityUtil.java
 * Change history
 * @LastModifyDate : 2012. 02. 29
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2012. 02. 29 김종범 최초 생성
 * ==============================================================================
 */

package com.unionsteel.mes.c10.activity.common;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Locale;


import com.posdata.glue.context.PosContext;
import com.posdata.glue.util.log.PosLog;
import com.posdata.glue.util.log.PosLogFactory;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * ActivityUtil Class는 Custom Activity Class에서 사용되는 간단한 비교 또는 null 체크와 같은 
 * Util 성 Method를 제공하는 클래스이다.
 * @author 김종범
 * @version 1.0
 */
public class ActivityUtil implements C10NuiConstantsIF{
    
	/**
     * 이 메소드는 파라미터로 받은 String 값이 valid한지 check하는 메소드이다. 
     * Valid 여부는 아래 항목을 체크하여 결정한다 
     *   - false : null이거나 ""인 경우
     *   - true : null과 ""가 아닌 경우
     * @param data 체크하려는 String 객체
     * @return Valid한지 여부
     */
    public static boolean isValidData(String data){
    	return !(isNull(data) || isBlankSpace(data));
    }
    /**
     * 이 메소드는 파라미터로 받은 String 값이 valid한지 check하는 메소드이다. 
     */
    public static boolean isNull(Object data){
    	return data == null;
    }
    /**
     * 이 메소드는 파라미터로 받은 String 값이 valid한지 check하는 메소드이다. 
     */
    public static boolean isBlankSpace(String data){
    	return STR_BLANK.equals(data);
    }
    
    /**
     * 이 메소드는 source와 target이 동일한 값을 갖는지 판단하는 메소드이다. 
     * source와 target은 String, Timestamp, BigDecimal 객체에 대해서 체크한다. 
     * 이 외의 Class인 경우 equals() 메소드로 단순 동일 비교를 수행한다. 
     * 
     * @param source 비교하려는 Source 객체
     * @param target 비교하려는 Target 객체
     * @return 동일 여부 Boolean
     */
    public static boolean isSameValue(Object source, Object target){

    	
    	/* Target이 특수 문자인 경우  */
    	if(PV_ALL.equals(target)){
    		return true;
    	} else if(PV_NULL.equals(target)) {
    		return source == null;
    	} else if(PV_BLANK.equals(target)) {
    		if(source instanceof String){
    			return "".equals(source);
    		} else {
    			return false;
    		}
    	} else if(PV_NOT_NULL.equals(target)){
    		return (source != null);
    	}
    	
    	/* source가 널인경우 */
    	if(source == null) return false;
    	
    	/* 
    	 * 여기까지 Flow가 진행되었을 때 아래 사항을 보장해야 되어야 에러가 발생하지 않는다.  
    	 * 1. source는 null이 아니다. 
    	 * 2. target은 특수문자가 아니다. 
    	 */  
    	
//		if(source == null){
//		    /* target이 "#null"이거나 "#blank"로 세팅되어 있을 경우 같은 값으로 판단한다.  */
//		    return PV_NULL.equals((String)target);
//		} else if(STR_BLANK.equals(source)){
//			return  PV_BLANK.equals((String)target);
//		}
//	
//		if(PV_ALL.equals(target)){
//		    return true;
//		} else if(PV_NULL.equals(target)){
//			return false;
//		} else if(PV_BLANK.equals(target)){
//			return false;
//		}
    	

	
        if(source instanceof String){
            return ((String) source).equals(target);
        } else if(source instanceof BigDecimal){
            BigDecimal castSource = (BigDecimal)source ; 
            BigDecimal castTarget = new BigDecimal((String)target) ; 
             
            return (castSource.compareTo(castTarget) == 0);
        } else if(source instanceof Integer){
        	Integer castSource = (Integer)source ; 
        	Integer castTarget = new Integer((String)target) ; 
        	
            return (castSource.compareTo(castTarget) == 0);
        } else if(source instanceof Timestamp){
            Timestamp castSource = (Timestamp)source ;
            return castSource.equals((Timestamp)target);
        } else {
          // logger.logWarn("ActivityUtil.isSameValue()의 Parameter Type은 String, BigDecimal, Timestamp만 가능합니다. ");

        	return source.equals(target);
        }
    }
    /**
     * 이 메소드는 유효한 값을 갖는지 판단하는 메소드이다. 
     */    
    public static String getStatusBarMessage(PosContext ctx, String msgcode, String[] bindValues){
		if(ctx == null){
		    PosLog logger = PosLogFactory.getLogger("ActivityUtil");
			logger.logError("PosContext가 Null입니다. Error Message를 가져올 수 없습니다. ");
			return "System Error 발생";
		} else {
			return PosContext.getResourceMessage(STR_MES_MESSAGE, msgcode, bindValues, Locale.KOREA);			
		}
    }
}