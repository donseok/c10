/*==============================================================================
*Copyright(c) 2011 UNIONSTEEL
*@FileName   : DbSearchMtlData.java
*Change history 
*@LastModifyDate	: 2012. 02. 22
*@LastModifier		: 김종범
*@LastVersion		: 1.0
*  1.0	2012. 02. 22 	김종범	최초 생성
==============================================================================*/
package com.unionsteel.mes.c10.activity.nui;


import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;



/**
 * 이 class는 Material Code 수신데이타에 대한 필수항목 체크하는  class이다. 
 * <xmp>
 *1. 편성정보: Material Code 수신
 *    - TB_C10_B10R0050
 *2. PosContext에 수신항목 편집
 *3. 편성한 결과는 PosContext에 등록
 *4. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 *
 * 사용 방법
 *  <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchMtlData">
 *    <transition name="success" value="B10R0050-service" />
 *    <property name="dao" value="eaidao" />
 *    <property name="bind-result" value="RK_Result" />
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

public class DbSearchMtlData extends PosActivity implements C10NuiConstantsIF{

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
    public String runActivity( PosContext ctx )
    {
        String prodSpecKind = this.getProperty( C10PN_PROSPECKIND ).trim();
        ctx.put( COL_QLT_DSN_SPC_TP, prodSpecKind );
        
		//Material Code
        if ( prodSpecKind.equals( NUM1 ) )
        {        
		   if ( DbCommonUtil.isNull( ctx.get( COL_MTL_CD ) ) || 
				DbCommonUtil.isNull( ctx.get( COL_MAT_TYPE ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_PRD_SHP ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_MQL_CD ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_CUS_REQ_ROL_THK ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_ORD_PAK_MTH ) ) )
        
        {
			//ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC01 );
			//ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
			logger.logError( ERRMSG_CF74);
			return PosBizControlConstants.FAILURE;
        }
        
       // Semi Material Code
        } else if ( prodSpecKind.equals( NUM2 ) )
        {
        	
		   if ( DbCommonUtil.isNull( ctx.get( COL_PLNT_TP ) ) || 
				DbCommonUtil.isNull( ctx.get( COL_MTL_CD ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_PROC_SEQ ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_PROC_CD ) ) ||
				DbCommonUtil.isNull( ctx.get( COL_SEM_PROD_MTL_CD ) ) )
        
        {
			//ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC01 );
			//ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
			logger.logError( ERRMSG_CF74 );
			return PosBizControlConstants.FAILURE;
        }
       }   
	
        return PosBizControlConstants.SUCCESS;
   	}
 }