/*===========================================================================
 * Copyright(c) 2011 유니온스틸
 * @FileName : M20FileUpload.java
 * Change history
 * @LastModifyDate : 2012. 03. 21
 * @LastModifier : 박옥균
 * @LastVersion : 1.0
 * 1.0 2012. 03. 21    박옥균    최초 생성
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
 * <xmp> 사용방법 <activity name="이미지업로드"
 * class="com.unionsteel.mes.C10.common.C10FileUpload4"> </activity> *
 * 
 * Property 상세
 * 
 * </xmp>
 * 
 * @author 이돈석
 * @version 1.0
 * 
 * @see com.poscoict.glue.biz.dhtmlx.grid.GridSave
 */
public class C10FileUpload5 extends PosActivity {
	/**
	 * 업로드 된 이미지정보를 등록 및 삭제하는 메소드.
	 * 
	 * @param ctx
	 *            PosContext 객체
	 * @return String - 업로드 결과를 return한다.
	 */
	public String runActivity(PosContext ctx) {
		PosGenericDao dao   = this.getDao(C10ConstantsIF.MESDAO);
		PosParameter param  = new PosParameter();
		String result       = PosBizControlConstants.SUCCESS;
		String img_rgs_flag = (String) ctx.get("IMG_RGS_FLAG");
		String prdSpcTp     = (String) ctx.get("PRD_SPC_TP");
		String delete_flag  = (String) ctx.get("DELETE_FLAG");
		String queryStr     = "", delQueryStr = "", upQueryStr = "";
		
		int cnt = 0;
		try {

			param.setNamedParamter("ObjectId"        ,ctx.get("ObjectId"));
			param.setNamedParamter("IMG_RGS_TP"      ,ctx.get("IMG_RGS_TP"));
			param.setNamedParamter("IMG_RGS_FLAG"    ,img_rgs_flag);
			param.setNamedParamter("IMG_RGS_FLAG_ID" ,ctx.get("IMG_RGS_FLAG_ID"));  //W4720
			param.setNamedParamter("IMG_RGS_FLAG_ID1",ctx.get("IMG_RGS_FLAG_ID1")); 
			param.setNamedParamter("IMG_RGS_FLAG_ID2",ctx.get("IMG_RGS_FLAG_ID2")); //101257
			param.setNamedParamter("IMG_RGS_FLAG_ID4",ctx.get("IMG_RGS_FLAG_ID4"));
			param.setNamedParamter("FILE_NAME"       ,ctx.get("FILE_NAME"));
			param.setNamedParamter("FILE_ADDR"       ,ctx.get("FILE_ADDR"));
			param.setNamedParamter("PRD_SPC_TP"      ,prdSpcTp);
			param.setNamedParamter("SEQ"             ,ctx.get("SEQ"));

			if ("03".equals(img_rgs_flag)) {
				queryStr = C10ConstantsIF.C106000080POP01_INSERT;
				delQueryStr = C10ConstantsIF.C106000080POP01_DELETE;
				upQueryStr = C10ConstantsIF.C106000080POP01_UPDATE;
			} else if ("04".equals(img_rgs_flag)) {
				if ("1".equals(prdSpcTp)) { 
					//제품이미지인 경우 (prdSpcTp 값 : 1)
					queryStr = C10ConstantsIF.C106000100POP01_INSERT;
					delQueryStr = C10ConstantsIF.C106000100POP01_DELETE;
					upQueryStr = C10ConstantsIF.C106000100POP01_UPDATE;
				} else if ("2".equals(prdSpcTp)) {
					//규격이미지인 경우 (prdSpcTp 값 : 2)
					queryStr = C10ConstantsIF.C106000100POP02_INSERT;
					delQueryStr = C10ConstantsIF.C106000100POP02_DELETE;
					upQueryStr = C10ConstantsIF.C106000100POP02_UPDATE;
				} else if ("3".equals(prdSpcTp)) {
					//물성파일인 경우 (prdSpcTp 값 : 3)
					queryStr = C10ConstantsIF.C106000100POP03_INSERT;
					delQueryStr = C10ConstantsIF.C106000100POP03_DELETE;
					upQueryStr = C10ConstantsIF.C106000100POP03_UPDATE;
				} else if ("4".equals(prdSpcTp)) {
					//규격파일인 경우 (prdSpcTp 값 : 4)
					queryStr = C10ConstantsIF.C106000100POP04_INSERT;
					delQueryStr = C10ConstantsIF.C106000100POP04_DELETE;
					upQueryStr = C10ConstantsIF.C106000100POP04_UPDATE;
				} else if ("5".equals(prdSpcTp)) { 
					//제품이미지인 경우 (prdSpcTp 값 : 5)
					queryStr = C10ConstantsIF.C106000140POP01_INSERT;
					delQueryStr = C10ConstantsIF.C106000140POP01_DELETE;
					upQueryStr = C10ConstantsIF.C106000140POP01_UPDATE;
				} else if ("6".equals(prdSpcTp)) {
					//규격이미지인 경우 (prdSpcTp 값 : 6)	
					queryStr = C10ConstantsIF.C106000140POP02_INSERT;
					delQueryStr = C10ConstantsIF.C106000140POP02_DELETE;
					upQueryStr = C10ConstantsIF.C106000140POP02_UPDATE;
				} else if ("7".equals(prdSpcTp)) {
					//규격이미지인 경우 (prdSpcTp 값 : 6)	
					queryStr = C10ConstantsIF.C106000160POP01_INSERT;
					delQueryStr = C10ConstantsIF.C106000160POP01_DELETE;
					upQueryStr = C10ConstantsIF.C106000160POP01_UPDATE;
				} else if ("8".equals(prdSpcTp)) {
					//규격이미지인 경우 (prdSpcTp 값 : 6)	
					queryStr = C10ConstantsIF.C106000160POP02_INSERT;
					delQueryStr = C10ConstantsIF.C106000160POP02_DELETE;
					upQueryStr = C10ConstantsIF.C106000160POP02_UPDATE;
				} else if ("9".equals(prdSpcTp)) { //여기 작업
					//도장사양서 경우 (prdSpcTp 값 : 9)
					queryStr = C10ConstantsIF.C106000050POP06_INSERT;
					delQueryStr = C10ConstantsIF.C106000050POP06_DELETE;
					upQueryStr = C10ConstantsIF.C106000050POP06_UPDATE;
				} else if ("0".equals(prdSpcTp)) { //여기 작업
					//원가내역서 경우 (prdSpcTp 값 : A)	
					queryStr = C10ConstantsIF.C106000050POP07_INSERT;
					delQueryStr = C10ConstantsIF.C106000050POP07_DELETE;
					upQueryStr = C10ConstantsIF.C106000050POP07_UPDATE;
				}
				
			}  else if ("05".equals(img_rgs_flag)) {
				queryStr    = C10ConstantsIF.C108000010POP02_INSERT;
				delQueryStr = C10ConstantsIF.C108000010POP02_DELETE;
				upQueryStr  = C10ConstantsIF.C108000010POP02_UPDATE;
			}  else if ("06".equals(img_rgs_flag)) {
				queryStr    = C10ConstantsIF.C106000050POP03_INSERT;
				delQueryStr = C10ConstantsIF.C106000050POP03_DELETE;
				upQueryStr  = C10ConstantsIF.C106000050POP03_UPDATE;
			}
			   else if ("07".equals(img_rgs_flag)) {
				queryStr    = C10ConstantsIF.C106000120POP01_INSERT;
				delQueryStr = C10ConstantsIF.C106000120POP01_DELETE;
				upQueryStr  = C10ConstantsIF.C106000120POP01_UPDATE;

			} else if ("08".equals(img_rgs_flag)) {
				/* 미사용
				if ("1".equals(prdSpcTp)) {
					//제품이미지인 경우 (prdSpcTp 값 : 1)
					queryStr = C10ConstantsIF.C106000140POP01_INSERT;
					delQueryStr = C10ConstantsIF.C106000140POP01_DELETE;
					upQueryStr = C10ConstantsIF.C106000140POP01_UPDATE;
				} else if ("2".equals(prdSpcTp)) {
					//규격이미지인 경우 (prdSpcTp 값 : 2)
					queryStr = C10ConstantsIF.C106000140POP02_INSERT;
					delQueryStr = C10ConstantsIF.C106000140POP02_DELETE;
					upQueryStr = C10ConstantsIF.C106000140POP02_UPDATE;
				}
				*/
			} else if ("09".equals(img_rgs_flag)) {
				//칼라개발의뢰 첨부파일 (IMG_RGS_FLAG 값 : 09)
				queryStr    = C10ConstantsIF.C108000240POP02_INSERT;
				delQueryStr = C10ConstantsIF.C108000240POP02_DELETE;
				upQueryStr  = C10ConstantsIF.C108000240POP02_UPDATE;
			}

			logger.logDebug("delete_flag : " + delete_flag);

			if ("Y".equals(delete_flag))
				cnt = dao.delete(delQueryStr, param);
			else
				cnt = dao.insert(queryStr, param);

			if (cnt < 0) {
				result = PosBizControlConstants.FAILURE;
				this.rollbackTransaction(C10ConstantsIF.TX1);
			} else {
				cnt = dao.update(upQueryStr, param);
				if (cnt < 0) {
					result = PosBizControlConstants.FAILURE;
					this.rollbackTransaction(C10ConstantsIF.TX1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
