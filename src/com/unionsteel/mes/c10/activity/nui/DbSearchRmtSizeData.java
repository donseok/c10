/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchRmtSizeData.java
 * Change history
 * @LastModifyDate : 2012. 02. 16
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 02. 16 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import java.util.Iterator;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 원자재Size를 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: PLTCM폭 최대값
 * - PLTCM주공정폭목표치, PLTCM대체공정1폭목표치, PLTCM대체공정2폭목표치 중
 *   가장 큰값으로 편성
 * 2. 편성정보: 중간재적용기준(알미늄칼라, 스테인레스칼라)
 * - Master Data 정의명 : C10B2230
 * - 중간재적용기준 Data 조건항목 : 품명코드, 주문두께, 기준적용폭
 * -> Read Count = 1 이면 중간재적용기준 Data의 중간재품명코드를 편성한다.
 * -> Read Count = 0 에러처리 하지 않는다.
 * -> Read Count > 1 이면 중간재적용기준 에러처리한다.
 * 3. 편성정보: 원자재두께기준(알루미늄칼라, 스테인레스칼라제외)
 * - Master Data 정의명 : C10B1071
 * - 원자재두께기준 Data 조건항목 : 원자재코드, PLTCM X-Ray Set치, PLTCM목표폭최대값
 * -> Read Count = 1 이면 원자재두께기준 Data의 원자재두께, 원자재두께(1~5)을 편집한다.
 *    원자재두께1~5 중 가장 작은값을 원자재두께하한으로 가장큰값을 원자재두께상한으로
 *    편집한다. 
 * -> Read Count = 0 이거나 Read Coun	t > 1 이면 원자재두께기준 에러처리한다.
 * 4. 편성정보: PLTCM폭수축량기준(알루미늄칼라, 스테인레스칼라제외)
 * - Master Data 정의명 : C10B1074
 * - PLTCM폭수축량기준 Data 조건항목 : 원자재코드, PLTCM X-Ray Set치, PLTCM목표폭최대값
 * -> Read Count = 1 이면 PLTCM폭수축량기준 Data의 PLTCM폭수축량최대값을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM폭수축량기준 에러처리한다.
 * 5. 편성정보: PLTCM폭마진량기준(알루미늄칼라, 스테인레스칼라제외)
 * - Master Data 정의명 : C10B1073
 * - PLTCM폭마진량기준 Data 조건항목 : 원자재코드, 원자재두께, PLTCM목표폭최대값
 * -> Read Count = 1 이면 PLTCM폭마진량기준 Data의 PLTCM폭마진량을 편집한다.(원자재목표폭)
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM폭마진량기준 에러처리한다.
 *
 * 6. 편성정보: 원자재목표두께, 원자재두께범위하한, 원자재두께범위상한, 원자재목표폭, 원자재코드(중간재)
 * - 품명코드가 알미늄칼라, 스테인레스칼라인 경우
 *   - 원자재목표두께 = 주문두께
 *   - 원자재목표두께범위하한 = 주문두께
 *   - 원자재목표두께범위상한 = 주문두께
 *   - 원자재목표폭 = 제품목표폭(소수점 반올림)
 * - 그이외의 경우
 *   - 중간재품명코드가 space인 경우
 *     - 원자재목표두께 = 원자재두께
 *     - 원자재목표두께범위하한 = 원자재목표두께하한
 *     - 원자재목표두께범위상한 = 원자재목표두께상한
 *     - 단, 품명코드가 A,B일 경우 두께는 주문두께로
 *     - 주문EDGE지정구분이 'C'인 경우
 *       - 원자재목표폭 = PLTCM목표폭최대값(소수점 반올림)
 *     - 주문EDGE지정구분이 'N'인 경우
 *       - 원자재목표폭 = 제품목표폭(소수점 반올림) (2016.3.15일 이전)
 *       - 원자재목표폭 = 제품목표폭 + CGL/EGL폭수축량 (2016.3.15일 이후, 김태성과장 요청)
 *       - 원자재목표폭 = PLTCM 출측폭목표값(1,2,3중에 제일 큰 값으로 변경 (2019.10.07일 이후, 김종민과장 요청)
 *     - 그이외의 경우
 *       - 원자재목표폭 = (PLTCM목표폭최대값 + PLTCM폭수축량 + PLTCM폭마진량)(소수점반올림)
 *   - 중간재품명코드가 'C'인 경우
 *     - 원자재목표두께 = TM목표두께
 *     - 원자재목표두께범위하한 = TM목표두께
 *     - 원자재목표두께범위상한 = TM목표두께
 *     - 원자재목표폭 = TM목표폭(소수점 반올림)
 *     - 원자재코드 = 중간재품명코드 + 원자재코드의 첫자리를 제외한 값 *     
 *   - 중간재품명코드가 'E'인 경우
 *     - 원자재목표두께 = EGL목표두께
 *     - 원자재목표두께범위하한 = EGL목표두께
 *     - 원자재목표두께범위상한 = EGL목표두께
 *     - 원자재목표폭 = EGL목표폭(소수점 반올림)
 *     - 원자재코드 = 중간재품명코드 + 원자재코드의 첫자리를 제외한 값 *     
 * 7. 편성한 결과는 PosContext에 등록
 * 8. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchRmtSizeData">
 * <transition name="success" value="C103100010-service" />
 * <property name="dao" value="masterdao" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchRmtSizeData extends PosActivity implements C10NuiConstantsIF
{

    /**
     * <p>
     * 이 메소드는 PosActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다.
     * </p>
     * 
     * @throws PosException IO Exception 발생 시
     * @param ctx Service내의 Data를 관리하는 PosContext 객체
     * @return success - 성공적으로 끝났을 때 Route transition.
     *         nullpointer - NullPointerException 발생 시 Route transtion.
     *         faillue - 그 외 Exception 발생 시 Route transition.
     */
    public String runActivity( PosContext ctx )
    {
        PosDecisionChecker checker = null;
        PosRuleVO result = null;
        String colValue[] = null; // 컬럼값

        double ord_exc_thk = 0;
        double max_pltcm_wth_trv = 0;
        double pltcm_wth_trv1 = 0;
        double pltcm_wth_trv2 = 0;
        double pltcm_wth_trv3 = 0;
        String prd_nm_cd = C10STR_SPACE;
        String rmtl_cd = C10STR_SPACE;
        String pltcm_thk_trv = C10STR_SPACE;
        String pltcm_set_thk_trv = C10STR_SPACE;
        String pltcm_wth_trv = C10STR_SPACE;
        String rmtl_tar_thk_llv = C10STR_SPACE;
        String rmtl_tar_thk_ulv = C10STR_SPACE;
        String tcm_wth_shr_qty = C10STR_SPACE;
        String mrg_wth = C10STR_SPACE;
        String cor_wth_trv = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        String cgl_thk_trv = C10STR_SPACE;
        String cgl_wth_trv = C10STR_SPACE;
        String egl_thk_trv = C10STR_SPACE;
        String egl_wth_trv = C10STR_SPACE;
        String tm_thk_trv = C10STR_SPACE;
        String tm_wth_trv = C10STR_SPACE;
        String ord_exc_wth = C10STR_SPACE;
        String sem_prd_nm_cd = C10STR_SPACE;
        String egl_main_proc_cd = C10STR_SPACE; //EGL 통과공정(2016.3.15)
        String cgl_main_proc_cd = C10STR_SPACE; //CGL 통과공정(2016.3.15)
        String mql_cd = C10STR_SPACE; //재질추가(2016.3.15)
        String fnl_cus_cd = C10STR_SPACE; //최종고객사(2022.5.02)
        String cus_bth_pap_no = C10STR_SPACE;
        String ccl_bom_no = C10STR_SPACE;
        String ord_thk_mng_cd = C10STR_SPACE;
        String ord_usg_cd = C10STR_SPACE;
        String cus_cd = C10STR_SPACE;
        String fh_thk_llv = C10STR_SPACE;
        String fh_thk_ulv = C10STR_SPACE;
        
        
        
        double ord_slit_grp_cnt = 0;
        double ord_mix_wth1 = 0;
        double ord_mix_wth2 = 0;
        double ord_mix_wth3 = 0;
        double ord_mix_wth4 = 0;
        double ord_mix_wth5 = 0;
        double ord_mix_wth6 = 0;
        double ord_mix_wth7 = 0;
        double ord_mix_wth8 = 0;
        double ord_mix_wth9 = 0;
        double ord_mix_wth10 = 0;
        double gal_wth_shr = 0;  //CGL/EGL 폭 감소량(2016.3.15)
        double sem_rmtl_tar_thk_lvl = 0; 
        double sem_rmtl_tar_thk_uvl = 0;
        double sem_rmtl_tar_wth = 0;

        

        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_MQL_CD ) ) )  //재질
            mql_cd = (String) ctx.get( COL_MQL_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_CGL_MAIN_PROC_CD ) ) )  //CGL주공정
        	cgl_main_proc_cd = (String) ctx.get( COL_CGL_MAIN_PROC_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_EGL_MAIN_PROC_CD ) ) )  //EGL주공정
        	egl_main_proc_cd = (String) ctx.get( COL_EGL_MAIN_PROC_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_RMTL_CD ) ) )
            rmtl_cd = (String) ctx.get( COL_RMTL_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_THK_TRV ) ) )
            pltcm_thk_trv = ctx.get( COL_PLTCM_THK_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_SET_THK_TRV ) ) )
            pltcm_set_thk_trv = ctx.get( COL_PLTCM_SET_THK_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_WTH_TRV ) ) )
            pltcm_wth_trv1 = Double.parseDouble( ctx.get( COL_PLTCM_WTH_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_WTH_SUB_PROC1_TRV ) ) )
            pltcm_wth_trv2 = Double.parseDouble( ctx.get( COL_PLTCM_WTH_SUB_PROC1_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PLTCM_WTH_SUB_PROC2_TRV ) ) )
            pltcm_wth_trv3 = Double.parseDouble( ctx.get( COL_PLTCM_WTH_SUB_PROC2_TRV ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_COR_WTH_TRV ) ) )
            cor_wth_trv = ctx.get( COL_COR_WTH_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EDG_ASG_TP ) ) )
            ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = Double.parseDouble( ctx.get( COL_ORD_EXC_THK ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SLIT_GRP_CNT ) ) )
            ord_slit_grp_cnt = Double.parseDouble( ctx.get( COL_ORD_SLIT_GRP_CNT ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH1 ) ) )
            ord_mix_wth1 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH1 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH2 ) ) )
            ord_mix_wth2 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH2 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH3 ) ) )
            ord_mix_wth3 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH3 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH4 ) ) )
            ord_mix_wth4 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH4 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH5 ) ) )
            ord_mix_wth5 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH5 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH6 ) ) )
            ord_mix_wth6 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH6 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH7 ) ) )
            ord_mix_wth7 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH7 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH8 ) ) )
            ord_mix_wth8 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH8 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH9 ) ) )
            ord_mix_wth9 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH9 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH10 ) ) )
            ord_mix_wth10 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH10 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
        {
           // if ( ord_slit_grp_cnt > 0 && Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) == ord_mix_wth1 )
           //     ord_exc_wth = Double.toString( Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * ord_slit_grp_cnt );
           // else if ( ord_slit_grp_cnt > 0 && Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) != ord_mix_wth1 )
           //     ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
           // else
           //     ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
             if ( ord_slit_grp_cnt > 0  )
                 ord_exc_wth = Double.toString(    ord_mix_wth1 + ord_mix_wth2 + ord_mix_wth3 + ord_mix_wth4 + ord_mix_wth5
                		                                + ord_mix_wth6 + ord_mix_wth7 + ord_mix_wth8 + ord_mix_wth9 + ord_mix_wth10 );
             else
                 ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
        }
        if ( !DbCommonUtil.isNull( ctx.get( COL_CGL_THK_TRV ) ) )
            cgl_thk_trv = ctx.get( COL_CGL_THK_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_CGL_WTH_TRV ) ) )
            cgl_wth_trv = ctx.get( COL_CGL_WTH_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_EGL_THK_TRV ) ) )
            egl_thk_trv = ctx.get( COL_EGL_THK_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_EGL_WTH_TRV ) ) )
            egl_wth_trv = ctx.get( COL_EGL_WTH_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_TM_THK_TRV ) ) )
            tm_thk_trv = ctx.get( COL_TM_THK_TRV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_TM_WTH_TRV ) ) )
            tm_wth_trv = ctx.get( COL_TM_WTH_TRV ).toString();
        
        if(pltcm_wth_trv1 > pltcm_wth_trv2)
            max_pltcm_wth_trv = pltcm_wth_trv1;
        else
            max_pltcm_wth_trv = pltcm_wth_trv2;
        
        if(max_pltcm_wth_trv < pltcm_wth_trv3)
            max_pltcm_wth_trv = pltcm_wth_trv3;
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_FNL_CUS_CD ) ) )
        	fnl_cus_cd = ctx.get( COL_FNL_CUS_CD ).toString();
               
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_CUS_BTH_PAP_NO ) ) )
        	cus_bth_pap_no = (String) ctx.get( COL_CUS_BTH_PAP_NO );
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_BOM_NO ) ) )
        	ccl_bom_no = ctx.get( COL_CCL_BOM_NO ).toString();
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_THK_MNG_CD ) ) )
        	ord_thk_mng_cd = ctx.get( COL_ORD_THK_MNG_CD ).toString();
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
        	ord_usg_cd = ctx.get( COL_ORD_USG_CD ).toString();
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_CUS_CD ) ) )
        	cus_cd = ctx.get( COL_CUS_CD ).toString();
        
        
        pltcm_wth_trv = Double.toString( max_pltcm_wth_trv );
        
        logger.logDebug( "=== RMTL LOG START ===" );
        logger.logDebug( prd_nm_cd + C10STR_COLON + ord_exc_thk  + C10STR_COLON + ord_exc_wth);

        if( !prd_nm_cd.equals( PRD_NM_CD_5 ) && !prd_nm_cd.equals( PRD_NM_CD_7 ) ){  
        	colValue = new String[6];
            colValue[0] = prd_nm_cd; // 품명
            colValue[1] = Double.toString( ord_exc_thk ); // 두께
            colValue[2] = ord_exc_wth; // 주문폭
            colValue[3] = fnl_cus_cd; // 최종고객사
            colValue[4] = cus_bth_pap_no; // 고객사양번호
            colValue[5] = ccl_bom_no; // cclbom
            
            checker = EasyAccess.getPosDecisionChecker( C10B2230, null );
            result = null;
            try{
                result = checker.getPosRule( colValue );
                
                if( result.getRecordCount() == 1 ){
                    sem_prd_nm_cd = result.getRuleValueAt( COL_SEM_PRD_NM_CD );
                    ctx.put( COL_RMTL_CD, sem_prd_nm_cd + rmtl_cd.substring( 1 ));
                }else if ( result.getRecordCount() > 1 ){
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK91 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R151 );
                    return PosBizControlConstants.FAILURE;
                }
                
            }catch ( MasterDataException e ){
                result = null;
            }
            
            if( !rmtl_cd.toString().substring(0,1).equals("H") && !rmtl_cd.toString().substring(0,1).equals("M") ){
              sem_prd_nm_cd = rmtl_cd.toString().substring(0,1);
            }
            
            logger.logDebug( "중간재적용기준 " + sem_prd_nm_cd);

            if(sem_prd_nm_cd.equals( C10STR_SPACE )){
                // 원자재두께
                colValue = new String[3];
                colValue[0] = rmtl_cd; // 원자재코드
                colValue[1] = pltcm_set_thk_trv; // PLTCM X-Ray Set치
                //colValue[2] = pltcm_wth_trv; // PLTCM폭
                logger.logDebug( "주문Edge구분 : " + ord_edg_asg_tp );
                //2023.6.7 김태성부장 요청. 품질설계 H/C 두께 선정 개선
                if(ord_edg_asg_tp.equals(NO_SLIT) || ord_edg_asg_tp.equals(COIL_EDGE)) 
                {
                	colValue[2] = Double.toString(Double.parseDouble(pltcm_wth_trv) + 20);
                	//colValue[2] = Double.parseDouble(pltcm_wth_trv)+20;
                	//colValue[2] = pltcm_wth_trv + 20; 6.27 여기수정필요!!
                	logger.logDebug( "C10B1071 + 20mm: " + colValue[2]  );
                }else{
                	colValue[2] = pltcm_wth_trv; // PLTCM폭
                	logger.logDebug( "C10B1071 : " + colValue[2]  );
                }
                
                logger.logDebug( "C10B1071 : " + rmtl_cd  );
                logger.logDebug( "C10B1071 : " + pltcm_set_thk_trv  );
                //logger.logDebug( "C10B1071 : " + pltcm_wth_trv  );
                
                checker = EasyAccess.getPosDecisionChecker( C10B1071, null );
                result = null;
                try{
                    result = checker.getPosRule( colValue );
                }catch( MasterDataException e ){
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT06 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }

                if( result.getRecordCount() == 1 ){
                    Iterator rtiter = result.itemNameRow.iterator();
                    Object data = null;

                    while( rtiter.hasNext() ){
                        data = rtiter.next();
                        
//                        logger.logDebug("data : "+ data.toString() +"         " +  data);
                        
                        if( data.toString().equals( COL_RMTL_TAR_THK ) ){
                            ctx.put( data.toString(), result.getRuleValueAt( data.toString() ) );
                            logger.logDebug( data.toString() + C10STR_COLON + result.getRuleValueAt( data.toString() ) );
                        }else{
                            if( rmtl_tar_thk_llv.equals( C10STR_SPACE ) ){
                                rmtl_tar_thk_llv = result.getRuleValueAt( data.toString() );
                            }else{
                                rmtl_tar_thk_llv = 
                                        DbCommonUtil.numCompare( 
                                                result.getRuleValueAt( 
                                                        data.toString() ), 
                                                        rmtl_tar_thk_llv, false ).toString();
                            }
                            if( rmtl_tar_thk_ulv.equals( C10STR_SPACE ) ){
                                rmtl_tar_thk_ulv = result.getRuleValueAt( data.toString() );
                            }else{
                                rmtl_tar_thk_ulv = 
                                        DbCommonUtil.numCompare( 
                                                result.getRuleValueAt( 
                                                        data.toString() ), 
                                                        rmtl_tar_thk_ulv, true ).toString();
                            }
                        }
                    }

                    //목표값을 무조건 하한값으로 적용
//                    ctx.put( COL_RMTL_TAR_THK, rmtl_tar_thk_llv);
//                    logger.logDebug( data.toString() + C10STR_COLON + result.getRuleValueAt( data.toString() ) );                    
                    
                    
                    ctx.put( COL_RMTL_TAR_THK_LVL, rmtl_tar_thk_llv );
                    ctx.put( COL_RMTL_TAR_THK_UVL, rmtl_tar_thk_ulv );
                    logger.logDebug( COL_RMTL_TAR_THK_LVL + C10STR_COLON + rmtl_tar_thk_llv );
                    logger.logDebug( COL_RMTL_TAR_THK_UVL + C10STR_COLON + rmtl_tar_thk_ulv );

                }else if( result.getRecordCount() > 1 ){
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT11 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R89 );
                    return PosBizControlConstants.FAILURE;
                }else{
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT06 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R88 );
                    return PosBizControlConstants.FAILURE;
                }
                
                // PLTCM수축량
                colValue = new String[3];
                colValue[0] = rmtl_cd; // 원자재코드
                colValue[1] = pltcm_thk_trv; // PLTCM두께
                colValue[2] = pltcm_wth_trv; // PLTCM폭
                checker = EasyAccess.getPosDecisionChecker( C10B1074, null );
                result = null;
                try{
                    result = checker.getPosRule( colValue );
                }catch( MasterDataException e ){
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }

                if( result.getRecordCount() == 1 ){
                    tcm_wth_shr_qty = result.getRuleValueAt( COL_TCM_WTH_SHR_QTY );
                }else if( result.getRecordCount() > 1 ){
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT14 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R132 );
                    return PosBizControlConstants.FAILURE;
                }else{
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT04 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R131 );
                    return PosBizControlConstants.FAILURE;
                }

                // PLTCM마진량
                colValue = new String[4];
                colValue[0] = rmtl_cd; // 원자재코드
                colValue[1] = ctx.get( COL_RMTL_TAR_THK ).toString(); // 원자재두께
                colValue[2] = pltcm_wth_trv; // PLTCM폭
                colValue[3] = fnl_cus_cd; // 고객사코드  
                logger.logError( "PLTCM폭마진량 원자재코드  : " + colValue[0]);
                logger.logError( "PLTCM폭마진량 원자재두께  : " + colValue[1]);
                logger.logError( "PLTCM폭마진량 PLTCM폭  : " + colValue[2]);
                logger.logError( "PLTCM폭마진량 고객사코드   : " + colValue[3]);
                
                checker = EasyAccess.getPosDecisionChecker( C10B1073, null );
                result = null;
                try{
                    result = checker.getPosRule( colValue );
                } catch ( MasterDataException e ){
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT05 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }

                if( result.getRecordCount() == 1 ){
                    mrg_wth = result.getRuleValueAt( COL_MRG_WTH );
                    logger.logError( "PLTCM폭마진량 결과  : " + mrg_wth);
                }else if( result.getRecordCount() > 1 ){
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT15 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R134 );
                    return PosBizControlConstants.FAILURE;
                }else{
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT05 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R133 );
                    return PosBizControlConstants.FAILURE;
                }                
            }
        }

        if( prd_nm_cd.equals( PRD_NM_CD_5 ) || prd_nm_cd.equals( PRD_NM_CD_7 )){
                ctx.put( COL_RMTL_TAR_THK_LVL, ord_exc_thk );
	            ctx.put( COL_RMTL_TAR_THK_UVL, ord_exc_thk );
	            ctx.put( COL_RMTL_TAR_THK, ord_exc_thk );
	            ctx.put( COL_RMTL_TAR_WTH, Math.round( Double.parseDouble( cor_wth_trv ) ) );
	            logger.logDebug( "cor_wth_trv:" + cor_wth_trv );
        }else{
        	logger.logDebug("5 7 제외 폭 계산 시작");
        	//PO제품일 경우 두께만 주문두께로 Set, 폭은 계산
            if(sem_prd_nm_cd.equals( C10STR_SPACE )){

		        if( prd_nm_cd.equals( PRD_NM_CD_A ) || prd_nm_cd.equals( PRD_NM_CD_B ) ){
		        	ctx.put( COL_RMTL_TAR_THK_LVL, ord_exc_thk );
		            ctx.put( COL_RMTL_TAR_THK_UVL, ord_exc_thk );
		            ctx.put( COL_RMTL_TAR_THK, ord_exc_thk );
		        }            	
            	
                if( ord_edg_asg_tp.equals( COIL_EDGE ) ){
                    ctx.put( COL_RMTL_TAR_WTH, Math.round( Double.parseDouble( pltcm_wth_trv ) ) );
                }else if( ord_edg_asg_tp.equals( NO_SLIT ) ){   //여기서부터 확인 2019.09.30 반드시
                	// 원자재폭 = CGL/EGL폭감소량 반영(2016.03.15)
                	if (    prd_nm_cd.equals( PRD_NM_CD_G ) || 
                    		prd_nm_cd.equals( PRD_NM_CD_K ) ||
                            prd_nm_cd.equals( PRD_NM_CD_J ) || 
                            prd_nm_cd.equals( PRD_NM_CD_L ) || 
                            prd_nm_cd.equals( PRD_NM_CD_V ) || 
                            prd_nm_cd.equals( PRD_NM_CD_W ) || 
                            prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                            prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                            prd_nm_cd.equals( PRD_NM_CD_6 ) || 
                            prd_nm_cd.equals( PRD_NM_CD_9 ) )
                    {
                        // CGL폭감소량
                        /*
                		colValue = new String[6];
                        colValue[0] = cgl_main_proc_cd; // 공정코드
                        colValue[1] = prd_nm_cd; // 품명
                        colValue[2] = ctx.get( COL_MQL_CD ).toString(); // 재질코드
                        colValue[3] = ctx.get( COL_RMTL_CD ).toString(); // 원자재코드
                        colValue[4] = pltcm_thk_trv; // PLTCM두께
                        colValue[5] = ord_exc_wth; // 주문폭
                                              
                        checker = EasyAccess.getPosDecisionChecker( C10B1075, null );
                        result = null;
                        try
                        {
                            result = checker.getPosRule( colValue );
                        } catch ( MasterDataException e )
                        {
                            result = null;
                            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                            ctx.put( COL_XMSGS, ERRMSG_I18 );
                            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I18 );
                            ctx.put( COL_ERR_YN, C10STR_YES );
                            logger.logError( e.getMessage() );
                            return PosBizControlConstants.SUCCESS;
                        }

                        if ( result.getRecordCount() == 1 )
                        {
                            gal_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_GAL_WTH_SHR_QTY ) );

                        } else if ( result.getRecordCount() > 1 )
                        {
                            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                            ctx.put( COL_XMSGS, ERRMSG_I19 );
                            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I19 );
                            ctx.put( COL_ERR_YN, C10STR_YES );
                            logger.logError( ERRMSG_I19 );
                            return PosBizControlConstants.SUCCESS;
                        } else
                        {
                            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                            ctx.put( COL_XMSGS, ERRMSG_I18 );
                            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I18 );
                            ctx.put( COL_ERR_YN, C10STR_YES );
                            logger.logError( ERRMSG_I18 );
                            return PosBizControlConstants.SUCCESS;
                        }
                        //원자재폭 = 제품폭 + CGL폭감소량
                        //CGL폭 감소량 계산완료.. 최종감소량은 gal_wth_shr 변수가 받음
                        ctx.put( COL_RMTL_TAR_WTH, Math.round( Double.parseDouble( cor_wth_trv )  + gal_wth_shr ) );
                        */
                		ctx.put( COL_RMTL_TAR_WTH, Math.round( Double.parseDouble( pltcm_wth_trv ) ) );
                    }   
                	else if( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_2 ) || prd_nm_cd.equals( PRD_NM_CD_N ) || prd_nm_cd.equals( PRD_NM_CD_8 ) )
                	{
                		/*
                		// EGL폭수축량
                        colValue = new String[6];
                        colValue[0] = egl_main_proc_cd; // 공정코드
                        colValue[1] = prd_nm_cd; // 품명
                        colValue[2] = ctx.get( COL_MQL_CD ).toString(); // 재질코드
                        colValue[3] = ctx.get( COL_RMTL_CD ).toString(); // 원자재코드
                        colValue[4] = pltcm_thk_trv; // PLTCM두께
                        colValue[5] = ord_exc_wth; // 주문폭
                        
                        logger.logDebug( "공정코드          : " + colValue[0] );
                        logger.logDebug( "품명              : " + colValue[1] );
                        logger.logDebug( "재질코드          : " + colValue[2] );
                        logger.logDebug( "원자재코드        : " + colValue[3] );
                        logger.logDebug( "PLTCM두께        : " + colValue[4] );
                        logger.logDebug( "주문폭            : " + colValue[5] );
                        
                        checker = EasyAccess.getPosDecisionChecker( C10B1076, null );
                        result = null;
                        try
                        {
                            result = checker.getPosRule( colValue );
                        } catch ( MasterDataException e )
                        {
                            result = null;
                            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                            ctx.put( COL_XMSGS, ERRMSG_I20 );
                            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I20 );
                            ctx.put( COL_ERR_YN, C10STR_YES );
                            logger.logError( e.getMessage() );
                            return PosBizControlConstants.SUCCESS;
                        }

                        if ( result.getRecordCount() == 1 )

                        {
                            gal_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_EGL_WTH_SHR_QTY ) );

                        } else if ( result.getRecordCount() > 1 )
                        {
                            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                            ctx.put( COL_XMSGS, ERRMSG_I21 );
                            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I21 );
                            ctx.put( COL_ERR_YN, C10STR_YES );
                            logger.logError( ERRMSG_I21 );
                            return PosBizControlConstants.SUCCESS;
                        } else
                        {
                            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                            ctx.put( COL_XMSGS, ERRMSG_I20 );
                            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I20 );
                            ctx.put( COL_ERR_YN, C10STR_YES );
                            logger.logError( ERRMSG_I20 );
                            return PosBizControlConstants.SUCCESS;
                        }
                        //원자재폭 = 제품폭 + EGL폭감소량
                        ctx.put( COL_RMTL_TAR_WTH, Math.round( Double.parseDouble( cor_wth_trv )  + gal_wth_shr ) );
                        */
                		ctx.put( COL_RMTL_TAR_WTH, Math.round( Double.parseDouble( pltcm_wth_trv ) ) );
                    }
                	else{
                		//원자재폭 = 제품폭
                		ctx.put( COL_RMTL_TAR_WTH, Math.round( Double.parseDouble( cor_wth_trv ) ) );
                	}
                }else{
                    ctx.put( COL_RMTL_TAR_WTH, 
                            Math.round( Double.parseDouble( pltcm_wth_trv ) + 
                                    Double.parseDouble( tcm_wth_shr_qty ) + Double.parseDouble( mrg_wth ) ) );
                }                    
            }else if(sem_prd_nm_cd.equals( PRD_NM_CD_D )){
//            	ctx.put( COL_RMTL_TAR_THK_LVL, pltcm_thk_trv );
//                ctx.put( COL_RMTL_TAR_THK_UVL, pltcm_thk_trv );
//                ctx.put( COL_RMTL_TAR_THK, pltcm_thk_trv );
//                ctx.put( COL_RMTL_TAR_WTH, pltcm_wth_trv );
            	
            	String[] ordUsgCdPriority = {
            		    ord_usg_cd,                                      // 1. 그대로
            		    ord_usg_cd.substring(0, 3) + "***",              // 2. 앞 3자리 + ***
            		    ord_usg_cd.substring(0, 1) + "*****",            // 3. 앞 1자리 + *****
            		    "******"                                         // 4. 전체 와일드카드
            		};

            	String[] cusCdPriority = {
            		    cus_cd,
            		    "******"
            		};      
            	
            	boolean found = false;

    	    	for (String usgCd : ordUsgCdPriority) {
    	    		for (String customerCd : cusCdPriority) {

	                //FH두께설계기준
	                colValue = new String[5];
	                colValue[0] = ord_thk_mng_cd; // 두께관리코드
	                colValue[1] = prd_nm_cd; // 품명 
	                colValue[2] = usgCd; // 주문용도코드
	                colValue[3] = customerCd; // 고객사코드
	                colValue[4] = Double.toString( ord_exc_thk ); // 두께
	                logger.logError( "FH두께설계기준 두께관리코드  : " + colValue[0]);
	                logger.logError( "FH두께설계기준 품명  : " + colValue[1]);
	                logger.logError( "FH두께설계기준 주문용도코드  : " + colValue[2]);
	                logger.logError( "FH두께설계기준 고객사코드   : " + colValue[3]);
	                logger.logError( "FH두께설계기준 두께   : " + colValue[4]);
	                
	                checker = EasyAccess.getPosDecisionChecker( C10B2310, null );
	                result = null;
	                try{
	                    result = checker.getPosRule( colValue );
	                } catch ( MasterDataException e ){
//	                    result = null;
//	                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT37 );
//	                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
//	                    logger.logError( e);
//	                    logger.logError( e.getMessage() );
//	                    return PosBizControlConstants.FAILURE;
	                	logger.logDebug("조합(" + usgCd + ", " + customerCd + ") 데이터 없음, 다음 조합 시도");
	                    continue;
	                	
	                }
	
		                if( result != null && result.getRecordCount() == 1 ){
		                	fh_thk_llv = result.getRuleValueAt( THK_RNG_LLV );
		                	fh_thk_ulv = result.getRuleValueAt( THK_RNG_ULV );
		                	logger.logDebug( "FH두깨설계기준 두께하한값  : " + fh_thk_llv);
		                    logger.logDebug( "FH두깨설계기준 두께상한값  : " + fh_thk_ulv);
		                    
			            	ctx.put( COL_RMTL_TAR_THK_LVL, String.valueOf(Double.parseDouble(pltcm_thk_trv) + Double.parseDouble(fh_thk_llv)) );
			                ctx.put( COL_RMTL_TAR_THK_UVL, String.valueOf(Double.parseDouble(pltcm_thk_trv) + Double.parseDouble(fh_thk_ulv)) );
			                ctx.put( COL_RMTL_TAR_THK, pltcm_thk_trv );
			                // 2026.04.28 - 원재료 적정 FH(QLT_DSN_MNF_TP='1')이면서 RMTL_CD가 D로 시작할 경우 RMTL_TAR_WTH = RMTL_TAR_WTH - 3
			                // 차선 FH(QLT_DSN_MNF_TP != '1')인 경우에는 원값 유지
			                String mnfTp = "";
			                if ( !DbCommonUtil.isNull( ctx.get( COL_QLT_DSN_MNF_TP ) ) ) {
			                    mnfTp = ctx.get( COL_QLT_DSN_MNF_TP ).toString();
			                }
			                if ( "1".equals(mnfTp) && rmtl_cd.startsWith("D") ) {
			                    logger.logDebug( "RMTL_TAR_WTH (기존목표폭) : " + pltcm_wth_trv );
			                    ctx.put( COL_RMTL_TAR_WTH, Double.parseDouble(pltcm_wth_trv) - 3 );
			                    logger.logDebug( "RMTL_TAR_WTH (적정 FH -3) : " + (Double.parseDouble(pltcm_wth_trv) - 3) );
			                } else {
			                    ctx.put( COL_RMTL_TAR_WTH, pltcm_wth_trv );
			                }

			                logger.logDebug("룰 조회 성공: 조합(" + usgCd + ", " + customerCd + ")");
			                found = true;
			                break;
		                    
		                    
		                } else if (result != null && result.getRecordCount() > 1) {
		                    logger.logError("복수 결과 존재 - 조건(" + usgCd + ", " + customerCd + ")");
		                }
	                
	    	    	}
		    	    if (found) break;
		    	}
	    	
            	
		    	if (!found) {
		    	    ctx.put(COL_QLT_DSN_ERR_CD, ERRCD_KT37);
		    	    ctx.put(C10STR_P_ERR_KEY, C10STR_YES);
		    	    logger.logError( ERRMSG_R155 );
		    	    return PosBizControlConstants.FAILURE;
		    	}
            	
            }else if(sem_prd_nm_cd.equals( PRD_NM_CD_C )){
            	// 원자재코드 구매CR C코드 해당분(C25, C32, C70, C7B, C7T 5가지) --2019.03.26 JKJ
            	// TM 두께 목표에 하한 : -0.02, 상한 : 0
            	if( rmtl_cd.equals("C25") || rmtl_cd.equals("C32") || rmtl_cd.equals("C70") || rmtl_cd.equals("C7B") || rmtl_cd.equals("C7T") ){
            		logger.logDebug("원재료에 따른 두께 범위 => "+ rmtl_cd);
            		sem_rmtl_tar_thk_lvl = Double.parseDouble(tm_thk_trv)*0.98;
                	sem_rmtl_tar_thk_uvl = Double.parseDouble(tm_thk_trv);
                } else {
                	sem_rmtl_tar_thk_lvl = Double.parseDouble(tm_thk_trv)*0.95;
                	sem_rmtl_tar_thk_uvl = Double.parseDouble(tm_thk_trv)*1.05;
                }
            	sem_rmtl_tar_thk_lvl = sem_rmtl_tar_thk_lvl*100;
            	sem_rmtl_tar_thk_lvl = Math.round(sem_rmtl_tar_thk_lvl);
            	sem_rmtl_tar_thk_lvl = sem_rmtl_tar_thk_lvl/100;

            	sem_rmtl_tar_thk_uvl = sem_rmtl_tar_thk_uvl*100;
            	sem_rmtl_tar_thk_uvl = Math.round(sem_rmtl_tar_thk_uvl);
            	sem_rmtl_tar_thk_uvl = sem_rmtl_tar_thk_uvl/100;
            	
                ctx.put( COL_RMTL_TAR_THK_LVL, sem_rmtl_tar_thk_lvl );
                ctx.put( COL_RMTL_TAR_THK_UVL, sem_rmtl_tar_thk_uvl );
                ctx.put( COL_RMTL_TAR_THK, tm_thk_trv );
                
                //김재용 : 구매CR만 목표폭을 +10로 요청을 드립니다. 반올림 처리(조건 : EGI / SLIT NO-ST / 구매CR) --2021.04.29 JKJ
                if( prd_nm_cd.equals("E")) {
                	sem_rmtl_tar_wth = Math.round(Double.parseDouble( tm_wth_trv ) - 3);
                }else{
                  sem_rmtl_tar_wth = Double.parseDouble( tm_wth_trv ) - 3;
                  sem_rmtl_tar_wth = sem_rmtl_tar_wth*10;
                  sem_rmtl_tar_wth = Math.round(sem_rmtl_tar_wth);
                  sem_rmtl_tar_wth = sem_rmtl_tar_wth/10;
                }
                ctx.put( COL_RMTL_TAR_WTH, sem_rmtl_tar_wth );
                
            }else if( sem_prd_nm_cd.equals( PRD_NM_CD_G ) || sem_prd_nm_cd.equals( PRD_NM_CD_L ) ||
            	      sem_prd_nm_cd.equals( PRD_NM_CD_V ) || sem_prd_nm_cd.equals( PRD_NM_CD_W ) ){
            	sem_rmtl_tar_thk_lvl = Double.parseDouble(cgl_thk_trv)*0.95;
            	sem_rmtl_tar_thk_lvl = sem_rmtl_tar_thk_lvl*100;
            	sem_rmtl_tar_thk_lvl = Math.round(sem_rmtl_tar_thk_lvl);
            	sem_rmtl_tar_thk_lvl = sem_rmtl_tar_thk_lvl/100;
            	sem_rmtl_tar_thk_uvl = Double.parseDouble(cgl_thk_trv)*1.05;
            	sem_rmtl_tar_thk_uvl = sem_rmtl_tar_thk_uvl*100;
            	sem_rmtl_tar_thk_uvl = Math.round(sem_rmtl_tar_thk_uvl);
            	sem_rmtl_tar_thk_uvl = sem_rmtl_tar_thk_uvl/100;
                ctx.put( COL_RMTL_TAR_THK_LVL, sem_rmtl_tar_thk_lvl );
                ctx.put( COL_RMTL_TAR_THK_UVL, sem_rmtl_tar_thk_uvl );
                ctx.put( COL_RMTL_TAR_THK, cgl_thk_trv );
//                ctx.put( COL_RMTL_TAR_THK, sem_rmtl_tar_thk_lvl ); //원재료 목표 두께 하한값 지정 
                
                sem_rmtl_tar_wth = Double.parseDouble( cgl_wth_trv ) - 1;
                sem_rmtl_tar_wth = sem_rmtl_tar_wth*10;
                sem_rmtl_tar_wth = Math.round(sem_rmtl_tar_wth);
                sem_rmtl_tar_wth = sem_rmtl_tar_wth/10;
                ctx.put( COL_RMTL_TAR_WTH, sem_rmtl_tar_wth );

            }else if( sem_prd_nm_cd.equals( PRD_NM_CD_E ) || sem_prd_nm_cd.equals( PRD_NM_CD_N ) ){
            	sem_rmtl_tar_thk_lvl = Double.parseDouble(egl_thk_trv)*0.95;
            	sem_rmtl_tar_thk_lvl = sem_rmtl_tar_thk_lvl*100;
            	sem_rmtl_tar_thk_lvl = Math.round(sem_rmtl_tar_thk_lvl);
            	sem_rmtl_tar_thk_lvl = sem_rmtl_tar_thk_lvl/100;
            	sem_rmtl_tar_thk_uvl = Double.parseDouble(egl_thk_trv)*1.05;
            	sem_rmtl_tar_thk_uvl = sem_rmtl_tar_thk_uvl*100;
            	sem_rmtl_tar_thk_uvl = Math.round(sem_rmtl_tar_thk_uvl);
            	sem_rmtl_tar_thk_uvl = sem_rmtl_tar_thk_uvl/100;
                ctx.put( COL_RMTL_TAR_THK_LVL, sem_rmtl_tar_thk_lvl );
                ctx.put( COL_RMTL_TAR_THK_UVL, sem_rmtl_tar_thk_uvl );
                ctx.put( COL_RMTL_TAR_THK, egl_thk_trv );

                sem_rmtl_tar_wth = Double.parseDouble( egl_wth_trv ) - 1;
                sem_rmtl_tar_wth = sem_rmtl_tar_wth*10;
                sem_rmtl_tar_wth = Math.round(sem_rmtl_tar_wth);
                sem_rmtl_tar_wth = sem_rmtl_tar_wth/10;
                ctx.put( COL_RMTL_TAR_WTH, sem_rmtl_tar_wth );
            }
            
            logger.logDebug("두께 폭 계산 완료 " + sem_rmtl_tar_thk_lvl + C10STR_COLON + sem_rmtl_tar_thk_uvl + C10STR_COLON + sem_rmtl_tar_wth);
        }
        return PosBizControlConstants.SUCCESS;
    }
}