/* ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C108000240pop01DeptChange.java
 * Change history
 * @LastModifyDate : 2026. 04. 09
 * @LastModifier : SJS
 * @LastVersion : 1.0
 * 1.0 2026. 04. 09 SJS 최초 생성
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
 * 칼라개발관리 처리담당부서 변경
 * - 미결재 단계(step_1~step_6)의 TB_C10_CLR_DEV_APRV.DEPT_CD를 UPDATE
 *
 * @author SJS
 * @version 1.0
 */
public class C108000240pop01DeptChange extends PosActivity {
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

			int dmlCnt = 0;
			int updateCnt = 0;

			// step_1 ~ step_6 처리담당부서 UPDATE (미결재 단계만)
			for (int i = 1; i <= 7; i++) {
				String[] deptCd = (String[]) ctx.get(idx_value.concat("DEPT_CD_" + i));

				if (deptCd == null || deptCd[0] == null || deptCd[0].isEmpty()) {
					continue;
				}

				PosParameter param = new PosParameter();
				param.setValueParamter("DEV_ID", DEV_ID[0]);
				param.setValueParamter("DEV_PRG_CD", String.valueOf(i));
				param.setValueParamter("DEPT_CD", deptCd[0]);
				param.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				param.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				param.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				param.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_APRV_DEPT_CD, param);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				updateCnt += dmlCnt;

				logger.logDebug("###C108000240pop01DeptChange### step:" + i + ", DEPT_CD:" + deptCd[0] + ", updated:" + dmlCnt);
			}

			logger.logDebug("###C108000240pop01DeptChange### DEV_ID:" + DEV_ID[0] + ", total updated:" + updateCnt);

			// 메인 테이블 LAST_UPDATE_TIMESTAMP 갱신
			if (updateCnt > 0) {
				PosParameter tsParam = new PosParameter();
				tsParam.setValueParamter("DEV_ID", DEV_ID[0]);
				tsParam.setValueParamter("AGR_STEP_CD", "");
				tsParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				tsParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				tsParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				tsParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_LAST_TS, tsParam);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				logger.logDebug("###C108000240pop01DeptChange### LAST_UPDATE_TIMESTAMP updated");
			}

			this.commitTransaction("tx1");

		} catch (Exception e) {
			e.printStackTrace();
			this.rollbackTransaction("tx1");
			result = PosBizControlConstants.FAILURE;
		}
		return result;
	}
}
