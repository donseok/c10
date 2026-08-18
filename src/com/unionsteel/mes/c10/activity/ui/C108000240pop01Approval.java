/* ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C108000240pop01Approval.java
 * Change history
 * @LastModifyDate : 2026. 07. 06
 * @LastModifier : SJS
 * @LastVersion : 1.2
 * 1.0 2026. 04. 09 SJS 최초 생성
 * 1.1 2026. 04. 10 SJS 병렬 결재 변경, 단계별 분기 처리
 *                     - 시편승인(3): 특이사항 INSERT + 분석/개발(2) 자동 승인
 *                     - 사양승인(4): (클라이언트 검증)
 *                     - BOM등록(5): CCL_BOM_NO UPDATE
 *                     - DEV_PRG_CD는 결재된 최대 단계 기준으로 갱신
 * 1.2 2026. 07. 06 SJS 분석/개발(2) 단계 결재 도입
 *                     - 시편승인(3) 승인 시 분석/개발(2) 자동 승인 제거
 *                     - 분석/개발(2)도 처리담당부서 부서원이 개별 결재
 * 1.3 2026. 07. 06 SJS 반려 로직 변경 (이전 단계 리셋 + 특이사항 기록)
 *                     - 반려 시 현재 단계는 그대로 두고 이전 단계 APRV_STATUS를 '1'로 리셋
 *                     - 반려 사유를 특이사항(TB_C10_CLR_DEV_ETC)에 자동 기록
 * 1.4 2026. 08. 06 SJS 반려 시 BOM등록(5) 미승인 상태이면 CCL_BOM_NO 클리어
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
 * 칼라개발관리 확정 처리 (순차 확정)
 * - TB_C10_CLR_DEV_APRV 확정 상태 UPDATE
 * - 승인 시:
 *   · 현재 단계 APRV_STATUS = '2'
 *   · TB_C10_CLR_DEV_MNG DEV_PRG_CD 갱신 (승인된 최대 단계 기준)
 *   · 시편승인(3): 특이사항 INSERT(도료사 개발번호)
 *   · BOM등록(5): CCL_BOM_NO UPDATE
 *   · 개발완료대기(6): 개발완료(7) 자동 승인
 * - 반려 시:
 *   · 현재 단계는 그대로 두고 이전 단계 APRV_STATUS를 '1'로 리셋
 *   · 반려 사유를 특이사항에 자동 기록: [반려] {현재단계} → {이전단계}: {사유}
 *   · TB_C10_CLR_DEV_MNG DEV_PRG_CD 갱신 (승인된 최대 단계 기준)
 *   · BOM등록(5)이 미승인 상태이면 CCL_BOM_NO 클리어
 *
 * @author SJS
 * @version 1.4
 */
public class C108000240pop01Approval extends PosActivity {

	private static final String[] STEP_NAMES = new String[] {
		"", "개발접수", "분석/개발", "시편승인", "사양승인", "BOM등록", "개발완료대기", "개발완료", "개발중단"
	};

	private static String getStepName(String stepCd) {
		try {
			int idx = Integer.parseInt(stepCd);
			if (idx >= 1 && idx < STEP_NAMES.length) {
				return STEP_NAMES[idx];
			}
		} catch (NumberFormatException e) {
			// ignore
		}
		return stepCd;
	}

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

			logger.logDebug("###C108000240pop01Approval### DEV_ID:" + devId
					+ ", AGR_STEP_CD:" + stepCd
					+ ", APRV_RESULT:" + aprvResult);

			if ("2".equals(aprvResult)) {
				// ========== 승인 ==========
				// 1) 현재 단계 상태 UPDATE
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

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_SAVE_APRV, aprvParam);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}

				// 2) BOM등록(5): CCL_BOM_NO UPDATE
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

				// 3) 시편승인(3): 특이사항 INSERT (도료사 개발번호)
				if ("3".equals(stepCd) && dcrDevNo != null && !dcrDevNo.isEmpty()) {
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

				// 4) 개발완료대기(6): 개발완료(7) 자동 승인
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

			} else {
				// ========== 반려 ==========
				// 이전 단계 유효성 검사 (개발접수(1)는 반려 불가)
				int stepNum;
				try {
					stepNum = Integer.parseInt(stepCd);
				} catch (NumberFormatException e) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				if (stepNum <= 1) {
					logger.logDebug("###C108000240pop01Approval### 개발접수 단계는 반려할 수 없습니다.");
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				String prevStepCd = String.valueOf(stepNum - 1);

				// 1) 이전 단계 리셋 (APRV_STATUS='1', 승인자/일자/의견 clear)
				PosParameter prevParam = new PosParameter();
				prevParam.setValueParamter("DEV_ID", devId);
				prevParam.setValueParamter("PREV_STEP_CD", prevStepCd);
				prevParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				prevParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				prevParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				prevParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_RESET_PREV_STEP, prevParam);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				logger.logDebug("###C108000240pop01Approval### 이전 단계(" + prevStepCd + ") 리셋: " + dmlCnt + " rows");

				// 2) 반려 사유를 특이사항에 기록
				String rejectNote = "[반려] " + getStepName(stepCd) + " → " + getStepName(prevStepCd);
				if (opinion != null && !opinion.isEmpty()) {
					rejectNote = rejectNote + " : " + opinion;
				}
				PosParameter etcParam = new PosParameter();
				etcParam.setValueParamter("DEV_ID", devId);
				etcParam.setValueParamter("REG_CHR_ID", userId);
				etcParam.setValueParamter("DEV_ETC", rejectNote);
				etcParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				etcParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				etcParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				etcParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				dmlCnt = dao.update(C10ConstantsIF.C108000240POP01_ETC_INSERT, etcParam);
				if (dmlCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				logger.logDebug("###C108000240pop01Approval### 반려 특이사항 INSERT: " + rejectNote);

				// 3) BOM등록(5) 미승인 상태이면 CCL_BOM_NO 클리어
				PosParameter bomClearParam = new PosParameter();
				bomClearParam.setValueParamter("DEV_ID", devId);
				bomClearParam.setNamedParamter("ObjectType", ctx.get(C10ConstantsIF.OBJECT_TYPE));
				bomClearParam.setNamedParamter("ObjectId", ctx.get(C10ConstantsIF.OBJECT_ID));
				bomClearParam.setNamedParamter("ProgramId", ctx.get(C10ConstantsIF.PROGRAM_ID));
				bomClearParam.setNamedParamter("Timestamp", ctx.get(C10ConstantsIF.TIMESTAMP));

				int bomClearCnt = dao.update(C10ConstantsIF.C108000240POP01_CLEAR_CCL_BOM_IF_STEP5_UNAPPROVED, bomClearParam);
				if (bomClearCnt < 0) {
					this.rollbackTransaction("tx1");
					return PosBizControlConstants.FAILURE;
				}
				if (bomClearCnt > 0) {
					logger.logDebug("###C108000240pop01Approval### CCL_BOM_NO cleared (BOM등록 미승인)");
				}
			}

			// 메인 테이블 DEV_PRG_CD 갱신 (승인된 최대 단계 기준)
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

			this.commitTransaction("tx1");

		} catch (Exception e) {
			e.printStackTrace();
			this.rollbackTransaction("tx1");
			result = PosBizControlConstants.FAILURE;
		}
		return result;
	}
}
