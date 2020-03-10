/*==============================================================================
*Copyright(c) 2011 UNIONSTEEL
*@FileName        : DbSearchCmnErrorCheck.java
*Change history 
*@LastModifyDate	: 2011. 12. 25
*@LastModifier		: 김종범
*@LastVersion		: 1.0
*  1.0	2011. 12. 25 	김종범	최초 생성
==============================================================================*/
package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;


/**
 * 이 class는 Error 테이블 Data를 관리하는 class이다. 
 * <xmp>
 * TB_C10_QLT_DSN_ERR DB에 일치하는 Data 여부 확인 후
 * QLT_DSN_ERR_YN 정보 등록여부를 판단한다 . 
 *Key : 주문번호, 주문행번, 품질설계에러코드
 *Key Value 중복이면 Failure, 아니면 Success
 *
 * 사용 방법
 *  <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchCmnErrorCheck">
 *    <transition name="success" value="C103100140-service" />
 *    <property name="dao" value="masterdao" />
 *    <property name="bind-result" value="RK_MAIN" />
 *  </activity> 
 * 
 *  Property 설정
 *  dao : applicationContext.xml의 DAO id
 *  bind-result: 이전 Activity에서 조회된 PosRowset
 *  resultkey : Query 결과를 ctx에 저장할 Key
 *  </xmp>
 * @author  김종범
 * @see     PosActivity
 * @version 1.0    
 */

public class DbSearchCmnErrorCheck extends PosActivity implements C10NuiConstantsIF{

		/**
		 * <p>
		 * 이 메소드는 PosActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다. 
		 *
		 * </p>
		 * @throws PosException IO Exception 발생 시
		 * @param ctx Service내의 Data를 관리하는 PosContext 객체  
		 * @return success - 성공적으로 끝났을 때 Route transition.
		 *         nullpointer - NullPointerException 발생 시 Route transtion.
		 *         faillue - 그 외 Exception 발생 시 Route transition.
		 */
	public String runActivity(PosContext ctx) {
		PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
		String 			colValue[] 			= 	null;							//컬럼값	
	

        PosParameter param = new PosParameter(); //MD View param
                
		colValue 		= new String[3];
		colValue[0] = (String)ctx.get(COL_ORD_NO);
		colValue[1] = (String)ctx.get(COL_ORD_LN);      			
		colValue[2] = (String)ctx.get(COL_QLT_DSN_ERR_CD);
      			
		PosRowSet	rowset = null;
	

          param = new PosParameter();  //MD View param
          param.setWhereClauseParameter( 0, colValue[2] );
          param.setWhereClauseParameter( 0, colValue[1] );
          param.setWhereClauseParameter( 0, colValue[0] );
          
        try{
        	//결과값 잘 가져오는지 확인
        	rowset = dao.find( C103100140_SELECT_QUERY, param );	//CMN테이블에 동일 주문에 대한 Y값이 존재하는지 여부			
        }catch(Exception e){
        	rowset = null;
			logger.logError(e.getMessage());	
			return PosBizControlConstants.FAILURE;
        }

		if(rowset.count() > 0){
			return PosBizControlConstants.FAILURE;
		}
	
	return PosBizControlConstants.SUCCESS;
   	}
 }