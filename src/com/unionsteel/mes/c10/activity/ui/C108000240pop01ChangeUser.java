/* ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C108000240pop01ChangeUser.java
 * Change history
 * @LastModifyDate : 2026. 04. 15
 * @LastModifier : SJS
 * @LastVersion : 1.0
 * 1.0 2026. 04. 15 SJS 최초 생성
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
 * 칼라개발관리 담당자 변경
 *
 * @author SJS
 * @version 1.0
 */
public class C108000240pop01ChangeUser extends PosActivity {
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
			String[] NEW_CHR_ID = (String[]) ctx.get(idx_value.concat("NEW_CHR_ID"));
			String[] BF_CHR_ID = (String[]) ctx.get(idx_value.concat("BF_CHR_ID"));

			logger.logDebug("###C108000240pop01ChangeUser### DEV_ID:" + DEV_ID[0]
					+ ", NEW_CHR_ID:" + NEW_CHR_ID[0]
					+ ", BF_CHR_ID:" + BF_CHR_ID[0]);

			PosParameter param = new PosParameter();
			param.setValueParamter("DEV_ID", DEV_ID[0]);
			param.setValueParamter("NEW_CHR_ID", NEW_CHR_ID[0]);
			param.setValueParamter("BF_CHR_ID", BF_CHR_ID[0]);
			param.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			param.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			param.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			param.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			int dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_DEV_CHR, param);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}

			// 특이사항에 담당자 변경 이력 기록
			String[] BF_CHR_NM = (String[]) ctx.get(idx_value.concat("BF_CHR_NM"));
			String[] NEW_CHR_NM = (String[]) ctx.get(idx_value.concat("NEW_CHR_NM"));
			String bfNm = (BF_CHR_NM != null && BF_CHR_NM.length > 0 && BF_CHR_NM[0] != null) ? BF_CHR_NM[0] : BF_CHR_ID[0];
			String newNm = (NEW_CHR_NM != null && NEW_CHR_NM.length > 0 && NEW_CHR_NM[0] != null) ? NEW_CHR_NM[0] : NEW_CHR_ID[0];

			PosParameter etcParam = new PosParameter();
			etcParam.setValueParamter("DEV_ID", DEV_ID[0]);
			etcParam.setValueParamter("REG_CHR_ID", (String) ctx.get(C10ConstantsIF.OBJECT_ID));
			etcParam.setValueParamter("DEV_ETC", "접수담당자 " + bfNm + "에서 " + newNm + "로 변경하였음.");
			etcParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			etcParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			etcParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			etcParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_ETC_INSERT, etcParam);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}
			logger.logDebug("###C108000240pop01ChangeUser### ETC inserted: " + bfNm + " -> " + newNm);

			this.commitTransaction("tx1");

		} catch (Exception e) {
			e.printStackTrace();
			this.rollbackTransaction("tx1");
			result = PosBizControlConstants.FAILURE;
		}
		return result;
	}
}
