/* ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C108000240pop01BomChange.java
 * Change history
 * @LastModifyDate : 2026. 04. 23
 * @LastModifier : SJS
 * @LastVersion : 1.0
 * 1.0 2026. 04. 23 SJS 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.ui;

import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;

/**
 * 칼라개발관리 CCL-BOM 변경
 * - TB_C10_CLR_DEV_MNG.CCL_BOM_NO UPDATE
 * - TB_C10_CLR_DEV_ETC 특이사항 INSERT (변경 이력)
 *
 * @author SJS
 * @version 1.0
 */
public class C108000240pop01BomChange extends PosActivity {
	@Override
	public String runActivity(PosContext ctx) {
		String result = PosBizControlConstants.SUCCESS;
		try {
			String[] ids = (String[]) ctx.get(C10ConstantsIF.IDS);
			PosGenericDao dao = this.getDao(C10ConstantsIF.MESDAO);

			if (ids == null || ids.length < 1) {
				return PosBizControlConstants.FAILURE;
			}

			String[] idsValue = ids[0].split(C10ConstantsIF.COMMA);
			String idx_value = idsValue[0].concat(C10ConstantsIF.UNDERBAR);

			String[] DEV_ID = (String[]) ctx.get(idx_value.concat("DEV_ID"));
			String[] NEW_BOM_NO = (String[]) ctx.get(idx_value.concat("NEW_BOM_NO"));
			String[] BF_BOM_NO = (String[]) ctx.get(idx_value.concat("BF_BOM_NO"));
			String[] BOM_CHG_REASON = (String[]) ctx.get(idx_value.concat("BOM_CHG_REASON"));

			String devId = DEV_ID[0];
			String newBom = (NEW_BOM_NO != null && NEW_BOM_NO.length > 0) ? NEW_BOM_NO[0] : "";
			String bfBom = (BF_BOM_NO != null && BF_BOM_NO.length > 0) ? BF_BOM_NO[0] : "";
			String reason = (BOM_CHG_REASON != null && BOM_CHG_REASON.length > 0) ? BOM_CHG_REASON[0] : "";

			int dmlCnt = 0;

			// 1) CCL_BOM_NO UPDATE
			PosParameter bomParam = new PosParameter();
			bomParam.setValueParamter("DEV_ID", devId);
			bomParam.setValueParamter("CCL_BOM_NO", newBom);
			bomParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			bomParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			bomParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			bomParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_CCL_BOM, bomParam);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}

			// 2) 특이사항 INSERT (변경 이력)
			String etcText = "BOM변경 : " + bfBom + " -> " + newBom + " (사유 : " + reason + ")";
			PosParameter etcParam = new PosParameter();
			etcParam.setValueParamter("DEV_ID", devId);
			etcParam.setValueParamter("REG_CHR_ID", (String) ctx.get(C10ConstantsIF.OBJECT_ID));
			etcParam.setValueParamter("DEV_ETC", etcText);
			etcParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			etcParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			etcParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			etcParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_ETC_INSERT, etcParam);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}

			logger.logDebug("###C108000240pop01BomChange### " + bfBom + " -> " + newBom);

			this.commitTransaction("tx1");

		} catch (Exception e) {
			e.printStackTrace();
			this.rollbackTransaction("tx1");
			result = PosBizControlConstants.FAILURE;
		}
		return result;
	}
}
