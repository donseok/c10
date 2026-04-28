/* ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C108000240pop01AppSaveEtc.java
 * Change history
 * @LastModifyDate : 2026. 02. 26
 * @LastModifier : SJS
 * @LastVersion : 1.0
 * 1.0 2026. 02. 26 SJS 최초 생성
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
 * 칼라개발관리 특이사항 저장 및 처리담당부서 결재 레코드 INSERT
 *
 * @author SJS
 * @version 1.0
 */
public class C108000240pop01AppSaveEtc extends PosActivity {
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
			String[] REG_CHR_ID = (String[]) ctx.get(idx_value.concat("REG_CHR_ID"));
			String[] DEV_ETC = (String[]) ctx.get(idx_value.concat("DEV_ETC"));

			int dmlCnt = 0;

			// 특이사항 저장 (Form_1에서 DEV_ETC 입력이 제거되어 null일 수 있음)
			if (DEV_ETC != null && DEV_ETC.length > 0 && DEV_ETC[0] != null && !DEV_ETC[0].isEmpty()) {
				PosParameter param = new PosParameter();
				param.setValueParamter("DEV_ID", DEV_ID[0]);
				param.setValueParamter("REG_CHR_ID", REG_CHR_ID[0]);
				param.setValueParamter("DEV_ETC", DEV_ETC[0]);
				param.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				param.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				param.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				param.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				logger.logDebug("###########################DEV_ID### " + DEV_ID[0]);

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_ETC_INSERT, param);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
			}

			// 처리담당부서 6개 INSERT (Form_1 hidden field: DEPT_CD_1 ~ DEPT_CD_6)
			// step_1(개발접수)은 의뢰자가 결재자로 자동 승인 처리
			String[] DEV_CHR_ID = (String[]) ctx.get(idx_value.concat("DEV_CHR_ID"));
			String devChrId = (DEV_CHR_ID != null && DEV_CHR_ID.length > 0) ? DEV_CHR_ID[0] : "";

			for (int i = 1; i <= 7; i++) {
				String[] deptCd = (String[]) ctx.get(idx_value.concat("DEPT_CD_" + i));

				logger.logDebug("### DEPT_CD_" + i + " = " + (deptCd != null ? deptCd[0] : "null"));

				if (i == 1) {
					// 개발접수: 의뢰자 부서 + 의뢰자 자동 승인
					PosParameter aprvParam = new PosParameter();
					aprvParam.setValueParamter("DEV_ID", DEV_ID[0]);
					aprvParam.setValueParamter("DEV_PRG_CD", "1");
					aprvParam.setValueParamter("DEPT_CD", (deptCd != null && !deptCd[0].isEmpty()) ? deptCd[0]
							: (String) ctx.get(C10ConstantsIF.OBJECT_ID)); // fallback
					aprvParam.setValueParamter("APRV_USER", devChrId);
					aprvParam.setValueParamter("OPINION", "");
					aprvParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
					aprvParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
					aprvParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
					aprvParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

					dmlCnt = dao.insert(C10ConstantsIF.C108000240POP01_INSERT_APRV_AUTO, aprvParam);
					if (dmlCnt < 0) {
						this.rollbackTransaction("tx1");
						return PosBizControlConstants.FAILURE;
					}
					logger.logDebug("###insertAprvDept### step_1 AUTO APPROVED, DEV_CHR_ID:" + devChrId);
				} else {
					if (deptCd == null || deptCd[0].isEmpty()) continue;

					PosParameter aprvParam = new PosParameter();
					aprvParam.setValueParamter("DEV_ID", DEV_ID[0]);
					aprvParam.setValueParamter("DEV_PRG_CD", String.valueOf(i));
					aprvParam.setValueParamter("DEPT_CD", deptCd[0]);
					aprvParam.setValueParamter("APRV_USER", "");
					aprvParam.setValueParamter("OPINION", "");
					aprvParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
					aprvParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
					aprvParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
					aprvParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

					dmlCnt = dao.insert(C10ConstantsIF.C108000240POP01_INSERT_APRV_DEPT, aprvParam);
					if (dmlCnt < 0) {
						this.rollbackTransaction("tx1");
						return PosBizControlConstants.FAILURE;
					}
					logger.logDebug("###insertAprvDept### DEV_PRG_CD:" + i + ", DEPT_CD:" + deptCd[0]);
				}
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
