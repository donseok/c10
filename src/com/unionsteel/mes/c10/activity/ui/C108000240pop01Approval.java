/* ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C108000240pop01Approval.java
 * Change history
 * @LastModifyDate : 2026. 04. 10
 * @LastModifier : SJS
 * @LastVersion : 1.1
 * 1.0 2026. 04. 09 SJS 최초 생성
 * 1.1 2026. 04. 10 SJS 병렬 결재 변경, 단계별 분기 처리
 *                     - 시편승인(3): 특이사항 INSERT + 분석/개발(2) 자동 승인
 *                     - 사양승인(4): (클라이언트 검증)
 *                     - BOM등록(5): CCL_BOM_NO UPDATE
 *                     - DEV_PRG_CD는 결재된 최대 단계 기준으로 갱신
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
 * 칼라개발관리 결재 처리 (병렬 결재)
 * - TB_C10_CLR_DEV_APRV 결재 상태 UPDATE
 * - 승인 시:
 *   · TB_C10_CLR_DEV_MNG DEV_PRG_CD 갱신 (결재된 최대 단계 기준)
 *   · 시편승인(3): 특이사항 INSERT(도료사 개발번호) + 분석/개발(2) 자동 승인
 *   · BOM등록(5): CCL_BOM_NO UPDATE
 *
 * @author SJS
 * @version 1.1
 */
public class C108000240pop01Approval extends PosActivity {
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
			String[] AGR_STEP_CD = (String[]) ctx.get(idx_value.concat("AGR_STEP_CD"));
			String[] AGR_USER_ID = (String[]) ctx.get(idx_value.concat("AGR_USER_ID"));
			String[] OPINION_TEXT = (String[]) ctx.get(idx_value.concat("OPINION_TEXT"));
			String[] APRV_RESULT = (String[]) ctx.get(idx_value.concat("APRV_RESULT"));

			// 단계별 추가 파라미터
			String[] EXT_BOM_NO = (String[]) ctx.get(idx_value.concat("EXT_BOM_NO"));
			String[] EXT_DCR_DEV_NO = (String[]) ctx.get(idx_value.concat("EXT_DCR_DEV_NO"));

			String devId = DEV_ID[0];
			String stepCd = AGR_STEP_CD[0];
			String userId = AGR_USER_ID[0];
			String opinion = OPINION_TEXT[0];
			String aprvResult = APRV_RESULT[0];
			String bomNo = (EXT_BOM_NO != null && EXT_BOM_NO.length > 0 && EXT_BOM_NO[0] != null) ? EXT_BOM_NO[0] : "";
			String dcrDevNo = (EXT_DCR_DEV_NO != null && EXT_DCR_DEV_NO.length > 0 && EXT_DCR_DEV_NO[0] != null) ? EXT_DCR_DEV_NO[0] : "";

			int dmlCnt = 0;

			// 1) 결재 테이블 상태 UPDATE
			PosParameter aprvParam = new PosParameter();
			aprvParam.setValueParamter("DEV_ID", devId);
			aprvParam.setValueParamter("AGR_STEP_CD", stepCd);
			aprvParam.setValueParamter("AGR_USER_ID", userId);
			aprvParam.setValueParamter("OPINION_TEXT", opinion);
			aprvParam.setValueParamter("APRV_RESULT", aprvResult);
			aprvParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
			aprvParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
			aprvParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
			aprvParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

			logger.logDebug("###C108000240pop01Approval### DEV_ID:" + devId
					+ ", AGR_STEP_CD:" + stepCd
					+ ", APRV_RESULT:" + aprvResult);

			dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_SAVE_APRV, aprvParam);
			if (dmlCnt < 0) {
				this.rollbackTransaction("tx1");
				return PosBizControlConstants.FAILURE;
			}

			// 2) 승인인 경우 단계별 추가 처리
			if ("2".equals(aprvResult)) {

				// 2-1) BOM등록(5): CCL_BOM_NO UPDATE
				if ("5".equals(stepCd) && bomNo != null && !bomNo.isEmpty()) {
					PosParameter bomParam = new PosParameter();
					bomParam.setValueParamter("DEV_ID", devId);
					bomParam.setValueParamter("CCL_BOM_NO", bomNo);
					bomParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
					bomParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
					bomParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
					bomParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

					dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_CCL_BOM, bomParam);
					if (dmlCnt < 0) {
						this.rollbackTransaction("tx1");
						return PosBizControlConstants.FAILURE;
					}
					logger.logDebug("###C108000240pop01Approval### CCL_BOM_NO updated: " + bomNo);
				}

				// 2-2) 시편승인(3): 특이사항 INSERT + 분석/개발(2) 자동 승인
				if ("3".equals(stepCd)) {
					// 특이사항에 도료사 개발번호 기록
					if (dcrDevNo != null && !dcrDevNo.isEmpty()) {
						PosParameter etcParam = new PosParameter();
						etcParam.setValueParamter("DEV_ID", devId);
						etcParam.setValueParamter("REG_CHR_ID", userId);
						etcParam.setValueParamter("DEV_ETC", "도료사 개발번호 : " + dcrDevNo);
						etcParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
						etcParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
						etcParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
						etcParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

						dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_ETC_INSERT, etcParam);
						if (dmlCnt < 0) {
							this.rollbackTransaction("tx1");
							return PosBizControlConstants.FAILURE;
						}
						logger.logDebug("###C108000240pop01Approval### ETC inserted: 도료사 개발번호 : " + dcrDevNo);
					}

					// 분석/개발(2) 자동 승인 (이미 승인/반려된 경우 건너뜀)
					PosParameter autoParam = new PosParameter();
					autoParam.setValueParamter("DEV_ID", devId);
					autoParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
					autoParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
					autoParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
					autoParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

					int autoCnt = dao.update(C10ConstantsIF.C108000240POP01_AUTO_APPROVE_ANALYSIS, autoParam);
					if (autoCnt < 0) {
						this.rollbackTransaction("tx1");
						return PosBizControlConstants.FAILURE;
					}
					logger.logDebug("###C108000240pop01Approval### 분석/개발 자동 승인: " + autoCnt + " rows");
				}

				// 2-3) 개발완료대기(6) 승인 시 개발완료(7) 자동 승인
				if ("6".equals(stepCd)) {
					PosParameter complParam = new PosParameter();
					complParam.setValueParamter("DEV_ID", devId);
					complParam.setValueParamter("APRV_USER", userId);
					complParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
					complParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
					complParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
					complParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

					int complCnt = dao.update(C10ConstantsIF.C108000240POP01_AUTO_APPROVE_COMPLETE, complParam);
					if (complCnt < 0) {
						this.rollbackTransaction("tx1");
						return PosBizControlConstants.FAILURE;
					}
					logger.logDebug("###C108000240pop01Approval### 개발완료 자동 승인: " + complCnt + " rows");
				}

				// 2-4) 메인 테이블 DEV_PRG_CD 갱신 (결재된 최대 단계 기준)
				PosParameter prgParam = new PosParameter();
				prgParam.setValueParamter("DEV_ID", devId);
				prgParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				prgParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				prgParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				prgParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_DEV_PRG_BY_MAX, prgParam);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				logger.logDebug("###C108000240pop01Approval### DEV_PRG_CD updated by MAX");
			} else {
				// 반려 시에도 LAST_UPDATE_TIMESTAMP는 갱신
				PosParameter tsParam = new PosParameter();
				tsParam.setValueParamter("DEV_ID", devId);
				tsParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				tsParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				tsParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				tsParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_UPDATE_LAST_TS, tsParam);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
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
