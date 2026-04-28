/* ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C108000240pop01DevStop.java
 * Change history
 * @LastModifyDate : 2026. 03. 12
 * @LastModifier : SJS
 * @LastVersion : 1.0
 * 1.0 2026. 03. 12 SJS 최초 생성
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
 * 칼라개발관리 개발 중단 처리
 * - TB_C10_CLR_DEV_APRV에 step_7 레코드 INSERT
 * - TB_C10_CLR_DEV_MNG의 DEV_PRG_CD를 '7'로 UPDATE
 *
 * @author SJS
 * @version 1.0
 */
public class C108000240pop01DevStop extends PosActivity {
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
			String[] AGR_USER_ID = (String[]) ctx.get(idx_value.concat("AGR_USER_ID"));
			String[] OPINION_TEXT = (String[]) ctx.get(idx_value.concat("OPINION_TEXT"));

			int dmlCnt = 0;

			// 1) step_7 결재 레코드 INSERT
			PosParameter insertParam = new PosParameter();
			insertParam.setValueParamter("DEV_ID", DEV_ID[0]);
			insertParam.setValueParamter("AGR_USER_ID", AGR_USER_ID[0]);
			insertParam.setValueParamter("OPINION_TEXT", OPINION_TEXT[0]);
			insertParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			insertParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			insertParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			insertParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			logger.logDebug("###C108000240pop01DevStop### DEV_ID:" + DEV_ID[0] + ", AGR_USER_ID:" + AGR_USER_ID[0]);

			dmlCnt = dao.insert(C10ConstantsIF.C108000240POP01_INSERT_DEV_STOP, insertParam);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}

			// 2) 메인 테이블 DEV_PRG_CD = '7' UPDATE
			PosParameter updateParam = new PosParameter();
			updateParam.setValueParamter("DEV_ID", DEV_ID[0]);
			updateParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			updateParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			updateParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			updateParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_DEV_STOP, updateParam);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}

			// 3) 특이사항에 개발중단 사유 기록
			String opinion = (OPINION_TEXT[0] != null && !OPINION_TEXT[0].isEmpty()) ? OPINION_TEXT[0] : "";
			PosParameter etcParam = new PosParameter();
			etcParam.setValueParamter("DEV_ID", DEV_ID[0]);
			etcParam.setValueParamter("REG_CHR_ID", AGR_USER_ID[0]);
			etcParam.setValueParamter("DEV_ETC", "접수담당자에 의해 개발이 중단되었습니다. (사유 : " + opinion + ")");
			etcParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			etcParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			etcParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			etcParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_ETC_INSERT, etcParam);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}
			logger.logDebug("###C108000240pop01DevStop### ETC inserted: 개발중단 사유");

			this.commitTransaction("tx1");

		} catch (Exception e) {
			e.printStackTrace();
			this.rollbackTransaction("tx1");
			result = PosBizControlConstants.FAILURE;
		}
		return result;
	}
}
