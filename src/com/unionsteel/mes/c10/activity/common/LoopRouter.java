/*===========================================================================
* Copyright(c) 2011 유니온스틸
* @FileName : LoopRouter.java
* Change history
* @LastModifyDate : 2012. 03. 05
* @LastModifier : 박옥균
* @LastVersion : 1.0
* 1.0 2012. 03. 05    박옥균    최초 생성
===========================================================================*/
package com.unionsteel.mes.c10.activity.common;

import com.posdata.glue.PosException;
import com.posdata.glue.context.PosContext;

/**
 * 이 클래스는 화면에서 전달 받은 그리드에서 변경된 Row 데이터를
 * 하나씩 추출하여 다음 Activity 에서 사용할 수 있도록 가공하고
 * 전달해 주는 클래스이다.
 * 
 * Detail Description
 *  - 화면에 입력용 그리드가 있을 때 사용하는 Activity 이다.
 *  - 그리드에 변경된 ROW 수 만큼 LOOP를 돈다. (LOOP_CNT)
 *  - 그리드에서 변경된 하나의 ROW를 추출하여 다음 Activity에  전달한다.(ROW_DATA)
 *  - LOOP 를 끝내고 조회옵션에 따라 조회 Activity를 호출 할 때
 *    화면 단에서 파라메터로 받은 AFTER_SAVE_RETURN_VALUE 를 
 *    Return 한다. AFTER_SAVE_RETURN_VALUE 값이 없을 경우는
 *    디폴트로 success 를 반Return한다.
 * 
 * <xmp>
 * 사용방법
 * <activity name="Loop Router" class="com.unionsteel.mes.M30.common.LoopRouter">
 * </activity> * 
 * 
 * Property 상세
 * 
 * </xmp>
 * @author 박옥균
 * @version 1.0
 * 
 * @see com.poscoict.glue.biz.dhtmlx.grid.GridSave
 */
public class LoopRouter extends C10GridActivity{

	@Override
	public String doMainActivity(PosContext ctx){

        //Grid 데이터를 읽는다.
		if(ctx.get("c10Ids") == null){
        	ctx.put("c10Ids", (String[])ctx.get(C10ConstantsIF.IDS));
        }		
		String ids[] = (String[])ctx.get("c10Ids");
		if(ids == null || ids.length < 1)
		    throw new PosException("There is no edit data!");
		String idsValue[] = ids[0].split(",");
		String transition = "";
		
		logger.logInfo("[LoopRouter] ids[0] : "+ ids[0]);

		//몇 번째 데이터를 처리 할지를 iLoopCnt로 읽는다. (3개의 그리드 row 가 있다면 처음엔 0, 그 다음엔 1,2가 되고 3이 되면 loop 를 빠져 나온다.)
		String loopCnt = getProperty(C10ConstantsIF.LOOP_CNT) == null ? C10ConstantsIF.LOOP_CNT : getProperty(C10ConstantsIF.LOOP_CNT) ; 
		logger.logInfo("[LoopRouter] loopCnt명 : "+loopCnt);
        int iLoopCnt = (Integer)ctx.get(loopCnt) == null ? 0 : (Integer)ctx.get(loopCnt);
        logger.logInfo("[LoopRouter] 현재 "+loopCnt+" : "+iLoopCnt + ", 전체 : " + idsValue.length + ",  loopCnt와 전체가 같을때 빠져나옴");
        if(iLoopCnt < idsValue.length) {
        	String[] tmp_ids = new String[1];
        	tmp_ids[0] = idsValue[iLoopCnt];
        	logger.logInfo("[LoopRouter] tmp_ids[0] :  " + tmp_ids[0]);
        	ctx.put("ids", tmp_ids);
        	logger.logInfo("[LoopRouter] debug 1");
        	getRecordToNormalValue(ctx, idsValue[iLoopCnt]);
        	//추출한 row 정보의 mark 구분을 가져온다.(inserted, updated, deleted)
        	String dmlType = getDMLType(ctx, idsValue[iLoopCnt]);
        	ctx.put(C10ConstantsIF.DML_TYPE,dmlType);
        	logger.logInfo("[LoopRouter] debug 2");
        	
        	iLoopCnt++;
        	ctx.put(loopCnt, iLoopCnt);       	
        	logger.logInfo("[LoopRouter] debug 3");
        	logger.logInfo("[LoopRouter] ctx.toString() : "+ctx.toString());
        	logger.logInfo("[LoopRouter] ctx.get('TR_COND') : "+ctx.get("TR_COND"));
        	String tr_cond = (String)ctx.get("TR_COND");
        	if( tr_cond !="" && tr_cond != null)
        		transition = tr_cond;        		
        	else
        		transition = C10ConstantsIF.NEXT;
        	
        	logger.logInfo("[LoopRouter] transition : "+transition);
        	//LOOP 내 다음 Activity 를 호출 한다.
        	return transition;
        }		
        
        ctx.put("ids", ctx.get("m30Ids"));
        //loop 를 종료하고 return 값을 반환한다.
		return C10ConstantsIF.ENDLOOP;
	}
	
	/**
	 * 이 메소드는 그리드 데이터의 xml-result_x_columnId 형식의 값을 columnId 형식으로 CTX에 담는 메서드 이다.
	 * 
	 * @param ctx PosPosContext 객체
	 * @param recordId 그리드의 record ID
	 */
	public void getRecordToNormalValue(PosContext ctx, String recordId){
		if(ctx.get("column-info_M30") == null){
			ctx.put("column-info_M30", ctx.get("column-info"));
			logger.logInfo("[LoopRouter] debug 4 column-info : " + ctx.get("column-info").toString());
		}		
		
		String columnInfo = ctx.get("column-info_M30") instanceof String[] ? ((String[])ctx.get("column-info_M30"))[0] :(String)ctx.get("column-info_M30")  ;
		String [] colOrder = columnInfo.split(",");
		String tmp[] = null;				
		
		for(int i = 0 ; i < colOrder.length; i++){	
			tmp = (String[])ctx.get(recordId+"_"+colOrder[i]);			
			logger.logInfo("[LoopRouter] debug 5 " + recordId+"_"+colOrder[i] + " : " + tmp.toString());
			if(!"column-info".equals(colOrder[i])){
				ctx.put(colOrder[i], tmp[0]);
			}
		}
	}

}
