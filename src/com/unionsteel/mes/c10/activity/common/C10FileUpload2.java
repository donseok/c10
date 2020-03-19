/*===========================================================================
* Copyright(c) 2011 유니온스틸
* @FileName : c10FileUpload2.java
* Change history
* @LastModifyDate : 2012. 06. 15
* @LastModifier : 김종범
* @LastVersion : 1.0
* 1.0 2012. 06. 15    김종범    최초 생성
===========================================================================*/
package com.unionsteel.mes.c10.activity.common;

import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;

/**
 * 이미지 업로드에 사용할 공통 클래스이다.
 * 
 * <xmp>
 * 사용방법
 * <activity name="엑셀파일업로드" class="com.unionsteel.mes.c10.common.c10FileUpload2">
 * </activity> * 
 * 
 * Property 상세
 * 
 * </xmp>
 * @author 김종범
 * @version 1.0
 * 
 * @see com.poscoict.glue.biz.dhtmlx.grid.GridSave
 */
public class C10FileUpload2 extends PosActivity {
	/**
	 * 업로드 된 이미지정보를  등록하는  메소드. 
	 * 
	 * @param ctx PosContext 객체
	 * @return String - 업로드 결과를 return한다. 
	 */
	public String runActivity(PosContext ctx){
		PosGenericDao dao = this.getDao(C10ConstantsIF.MESDAO);
		PosParameter param = new PosParameter();
		String result = PosBizControlConstants.SUCCESS;


		try{
			
			param.setNamedParamter("ObjectType"	           , ctx.get("ObjectType"));
			param.setNamedParamter("ObjectId"	           , ctx.get("ObjectId"));
			param.setNamedParamter("ProgramId"	           , ctx.get("ProgramId"));
			param.setNamedParamter("Timestamp"	           , ctx.get("Timestamp"));
			param.setNamedParamter("INQ_NO"                , ctx.get("INQ_NO"));
			param.setNamedParamter("IMG_NM"				   , ctx.get("IMG_NM"));
			param.setNamedParamter("IMG_ADR"			   , ctx.get("IMG_ADR"));				
			

			int cnt = dao.insert("C105000010pop03.insert" , param);

			if(cnt < 0){
				result = PosBizControlConstants.FAILURE;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}

		return result;
	}
}
