/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchProcData.java
 * Change history
 * @LastModifyDate : 2012. 01. 04
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 01. 04 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import java.util.ArrayList;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosAuditAttributes;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionRuleVO;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 class는 통과공정을 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 통과공정삭제기준
 * - Master Data 정의명 : C10B2010
 * - 통과공정삭제기준 Data 조건항목 : 품명코드, BackMarking여부, 주문내경, 주문내경링종류구분, 주문표면처리코드, 도금량지정코드, EMBOSS무늬, 주문포장단중하한값, 주문코일외경, 입측두께범위, 입측폭범위, 수지타입전면, 광택코드전면, 보호필름상세코드, 재질코드, 주문EDGE지정코드
 * -> Read Count = 1 이면 통과공정삭제기준 Data의 삭제공정을 편집한다.
 * -> 에러처리하지 않는다.
 * 2. 편성정보: 정전공정추가기준
 * - Master Data 정의명 : C10B2050
 * - 정전공정추가기준 Data 조건항목 : 품명코드, 제품형태, slit조수, 조합폭(복합조중 가장적은것), 주문EDGE, 제품두께범위, 재단선유무, 위탁임가공여부, 엠보스무늬
 * -> Read Count = 1 이면 정전공정추가기준 Data의 추가위치, 기준공정, 주공정, 대체공정1, 대체공정2을 편집한다.
 * -> 에러처리하지 않는다.
 * 3. 편성정보: TM2PASS기준
 * - Master Data 정의명 : C10B2240
 * - TM2PASS기준 Data 조건항목 : 품명코드, 규격약호, 최종수요가코드, 주문용도코드, 주문표면처리코드, 광택코드전면, 두께범위, 폭범위, EMBOSS무늬
 * -> Read Count = 1 이면 TM2PASS기준 Data의 Pass수를 편집한다.
 * -> 에러처리하지 않는다.
 * 4. 편성정보: 공정순서, 주통과공정코드, 보조통과공정코드1, 보조통과공정코드2
 * - Master Data View 통한 단순구조 데이타 결과값 도출
 * . Key: 통과공정번호, 주문두께
 * -> Read Count = 1 이면 통과공정기준 Data의 공정코드를 편집한다.
 * -> Read Count = 0 이면 통과공정기준 에러처리한다.
 * 5. 편성정보: 반제품MaterialCode편집
 * - 반제품MaterialCode관리Table 통한 단순구조 데이타 결과값 도출
 * . Key: MaterialCode, 통과공정번호(주공정)
 * - 제품군이 칼라제품이고 통과공정번호가 72(RCL)인 경우 통과공정번호가 전체가 같은 결과값을 도출한다.
 * - 제품군이 칼라제품이고 통과공정번호가 72(RCL)가 아닌 경우 통과공정번호의 첫자리가 같은 결과값을 도출한다.
 * - 제품군이 칼라제품이 아닌경우 통과공정번호의 첫자리가 같은 결과값을 도출한다.
 * -> Read Count = 1 이면 반제품MaterialCode관리 Data의 반제품MaterialCode를 편집한다.
 * -> Read Count = 0 이면 반제품MaterialCode 에러처리한다.
 * 6. 편성정보 : 정전공정추가 기준공정이전
 * - 정전공정추가 기준공정이전 조건이 있을경우 정전공정을 추가한다.
 * 7. 편성정보 : 칼라공정코드 반영
 * - 칼라제품인 경우 칼라제조사양의 주공정, 대체공정1, 대체공정2, 대체공정3을 통과공정으로 반영한다.
 * 8. 편성정보 : 삭제공정 반영
 * - 삭제공정 조건이 있을 경우 통과공정을 편집(삭제)한다.
 * - 삭제반영 후 주공정, 대체공정1, 대체공정2, 대체공정3이 모두 삭제된 경우는 에러처리한다.
 * 9. 통과공정기준에서 읽어온 통과공정Data를 반영한다.
 * 10.편성정보 : TM2PASS추가
 * - 통과공정번호가 51(TM)이고 TM2PASS조건이 있을경우 TM공정을 추가한다.
 * 11.편성정보 : CCL2PASS추가
 * - 주공정이 칼라공정(A)이고 도장(코팅)방식이 A,B,C,D,E인 경우 => 20131118 삭제
 * - 주공정이 칼라공정(A)이고 도장(코팅)방식이 A,B,C,D,E이고 CCL_BOM이 'V'로 시작하지 않을 경우 => 20131118 추가
 * - 주공정이 A2,A3,A4,A6이고 도장(코딩)방식이 6,7,8,9인 경우 ==> 20150430 A4공정 삭제
 * 12. 편성정보 : 정전공정추가 기준공정이후
 * - 정전공정추가 기준공정이후 조건이 있을경우 정전공정을 추가한다.
 * 13. 편성정보 : TM PASS수
 * - 제품군이 CR, EG, CR칼라, EG칼라 인 경우 TM PASS수를 제조사양에 반영한다.
 * 14. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 항목별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 15. 편성한 결과를 품질설계결과-통과공정에 등록
 * 16. 정보가 존재하여 등록에 성공한 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchProcData">
 * <transition name="success" value="C103100030-service" />
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

public class DbSearchProcData extends PosActivity implements C10NuiConstantsIF
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
        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );
        PosParameter param = new PosParameter(); // MD View param

        String colValue[] = null; // 판단기준 array 컬럼값

        String pas_proc_no = C10STR_SPACE;
        String mtl_cd = C10STR_SPACE;
        String sem_prod_mtl_cd = C10STR_SPACE;
        String main_proc_cd = C10STR_SPACE;
        String ccl_proc_cd = C10STR_SPACE;
        String ccl_proc_cd1 = C10STR_SPACE;
        String ccl_proc_cd2 = C10STR_SPACE;
        String ccl_proc_cd3 = C10STR_SPACE;
        String ccl_proc_cd_tmp = C10STR_SPACE;
        String ccl_proc_cd1_tmp = C10STR_SPACE;
        String ccl_proc_cd2_tmp = C10STR_SPACE;
        String ccl_proc_cd3_tmp = C10STR_SPACE;
        String ccl_proc_cd4_tmp = C10STR_SPACE;
        String ccl_proc_cd5_tmp = C10STR_SPACE;
        String ccl_proc_cd6_tmp = C10STR_SPACE;
        
        String cor_proc_cd = C10STR_SPACE;
        String cor_proc_cd1 = C10STR_SPACE;
        String cor_proc_cd2 = C10STR_SPACE;
        String cor_proc_cd3 = C10STR_SPACE;
        String sub_proc_cd1 = C10STR_SPACE;
        String sub_proc_cd2 = C10STR_SPACE;
        String sub_proc_cd3 = C10STR_SPACE;
        String sub_proc_cd4 = C10STR_SPACE;
        String sub_proc_cd5 = C10STR_SPACE;
        String sub_proc_cd6 = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String prd_shp = C10STR_SPACE;
        String ord_no = C10STR_SPACE;
        String ord_ln = C10STR_SPACE;
        String bak_mrk = C10STR_SPACE;
        String ord_coil_idia = C10STR_SPACE;
        String ord_slv_knd_tp = C10STR_SPACE;
        String ord_sur_hnd_cd = C10STR_SPACE;
        String gw_asg_cd = C10STR_SPACE;
        String ord_pak_unt_wgt_llv = C10STR_SPACE;
        String ord_coil_odia = C10STR_SPACE;
        String cot_mth = C10STR_SPACE;
        String ccl_bom_no = C10STR_SPACE;
        String embs_cd = C10STR_SPACE;
        String ord_exc_thk = C10STR_SPACE;
        String ord_exc_lth = C10STR_SPACE;
        String ord_exc_wth = C10STR_SPACE;
        String exc_wth = C10STR_SPACE;
        String loc = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        String cut_ln_yn = C10STR_SPACE;
        String base_proc_cd = C10STR_SPACE;
        String trst_proc_yn = C10STR_SPACE;
        String lus_rt_cd_frn = C10STR_SPACE;
        String rsn_tp_frn = C10STR_SPACE;
        String ptt_flm_dtl_cd = C10STR_SPACE;
        String mql_cd = C10STR_SPACE;
        String spc_avr = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        String ord_usg_cd = C10STR_SPACE;
        String tm_proc_cd = C10STR_SPACE;
        String ord_coilg_mth = C10STR_SPACE;
        String ord_spnl_tp = C10STR_SPACE;
        double mix_wth = 0;
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
        int add_seq = 0;
        int proc_seq = 0;
        int count = 0;
        int seq = 0;

        // Parameter Error Check True=Null, FALE=NotNull
        if ( !DbCommonUtil.isNull( ctx.get( COL_PAS_PROC_NO ) ) )
            pas_proc_no = (String) ctx.get( COL_PAS_PROC_NO );
        if ( !DbCommonUtil.isNull( ctx.get( COL_MTL_CD ) ) )
            mtl_cd = (String) ctx.get( COL_MTL_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_SHP ) ) )
            prd_shp = (String) ctx.get( COL_PRD_SHP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) )
            ord_no = (String) ctx.get( COL_ORD_NO );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) )
            ord_ln = (String) ctx.get( COL_ORD_LN );
        if ( !DbCommonUtil.isNull( ctx.get( COL_BAK_MRK ) ) )
        	if ( ((String) ctx.get( COL_BAK_MRK )).substring(0,4).equals("BACK") )
        		bak_mrk = C10STR_YES;
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_COIL_IDIA ) ) )
            ord_coil_idia = ctx.get( COL_ORD_COIL_IDIA ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SLV_KND_TP ) ) )
            ord_slv_knd_tp = (String) ctx.get( COL_ORD_SLV_KND_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SUR_HND_CD ) ) )
            ord_sur_hnd_cd = (String) ctx.get( COL_ORD_SUR_HND_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_GW_ASG_CD ) ) )
            gw_asg_cd = (String) ctx.get( COL_GW_ASG_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_PAK_UNT_WGT_LLV ) ) )
            ord_pak_unt_wgt_llv = ctx.get( COL_ORD_PAK_UNT_WGT_LLV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_COIL_ODIA ) ) )
            ord_coil_odia = ctx.get( COL_ORD_COIL_ODIA ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_EMBS_CD ) ) )
            embs_cd = (String) ctx.get( COL_EMBS_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = ctx.get( COL_ORD_EXC_THK ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_LTH ) ) )
            ord_exc_lth = ctx.get( COL_ORD_EXC_LTH ).toString();  //길이정보 추가
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
            ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
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
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EDG_ASG_TP ) ) )
            ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_TRST_PROC_YN ) ) )
            trst_proc_yn = (String) ctx.get( COL_TRST_PROC_YN );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_MQL_CD ) ) )
            mql_cd = (String) ctx.get( COL_MQL_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_SPC_AVR ) ) )
            spc_avr = (String) ctx.get( COL_SPC_AVR );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_FNL_CUS_CD ) ) )
            fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_USG_CD ) ) )
            ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_CCL_BOM_NO ) ) )
            ccl_bom_no = (String) ctx.get( COL_CCL_BOM_NO );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_COILG_MTH ) ) )
        	ord_coilg_mth = (String) ctx.get( COL_ORD_COILG_MTH );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_SPNL_TP ) ) )
            ord_spnl_tp = (String) ctx.get( COL_ORD_SPNL_TP );

        //폭조합 중 가장 작은것으로 저장(정전공정추가기준 조건용)
        if ( ord_slit_grp_cnt > 0 ){
        	mix_wth = ord_mix_wth1;
        	if ( mix_wth > ord_mix_wth2 && ord_mix_wth2 != 0 )
	           mix_wth = ord_mix_wth2;
	    	if ( mix_wth > ord_mix_wth3 && ord_mix_wth3 != 0 )
	           mix_wth = ord_mix_wth3;
	    	if ( mix_wth > ord_mix_wth4 && ord_mix_wth4 != 0 )
	           mix_wth = ord_mix_wth4;
	    	if ( mix_wth > ord_mix_wth5 && ord_mix_wth5 != 0 )
	           mix_wth = ord_mix_wth5;
	    	if ( mix_wth > ord_mix_wth6 && ord_mix_wth6 != 0 )
	           mix_wth = ord_mix_wth6;
	    	if ( mix_wth > ord_mix_wth7 && ord_mix_wth7 != 0 )
	           mix_wth = ord_mix_wth7;
	    	if ( mix_wth > ord_mix_wth8 && ord_mix_wth8 != 0 )
	           mix_wth = ord_mix_wth8;
	    	if ( mix_wth > ord_mix_wth9 && ord_mix_wth9 != 0 )
	           mix_wth = ord_mix_wth9;
	    	if ( mix_wth > ord_mix_wth10 && ord_mix_wth10 != 0 )
	           mix_wth = ord_mix_wth10;
        }else
        	mix_wth = Double.parseDouble( ord_exc_wth );
        
        PosRowSet rowset = null;
        PosRowSet rowset1 = null;
        PosRowSet rowset2 = null; //정전 '6X'일때 이전 칼라공정 Select 용 
        PosRow row = null;
        PosRow row1 = null;
        PosRow row2 = null;  //정전 '6X'일때 이전 칼라공정 Select 용

        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, pas_proc_no );
        
        //logger.logDebug( "JKJ -> " +bak_mrk+ " -> " + ord_no +","+ ord_ln );

        // 칼라제품 공정코드 Check
        if ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
             prd_nm_cd.equals( PRD_NM_CD_2 ) || 
             prd_nm_cd.equals( PRD_NM_CD_3 ) || 
             prd_nm_cd.equals( PRD_NM_CD_4 ) || 
             prd_nm_cd.equals( PRD_NM_CD_5 ) || 
             prd_nm_cd.equals( PRD_NM_CD_6 ) ||
             prd_nm_cd.equals( PRD_NM_CD_7 ) ||
             prd_nm_cd.equals( PRD_NM_CD_8 ) ||
             prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            try{
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( VI_M00_C10A1054_PROC_CHK, param ); // 통과공정기준View.select
            } catch ( Exception e ){
                rowset = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
            if ( rowset.count() == 0 ){
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R98 );
                return PosBizControlConstants.FAILURE;
            }

            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ord_no );
            param.setWhereClauseParameter( 1, ord_ln );

            try{
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( SELECT_MNF_CCL_BOM, param ); // 칼라제조사양.select
            }catch ( Exception e ){
                rowset = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }
            if ( rowset.count() == 0 ){
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R98 );
                return PosBizControlConstants.FAILURE;
            }else{
                row = rowset.next();
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_MAIN_PROC_CD ) ) )
                    ccl_proc_cd = DbCommonUtil.valueOf( row.getAttribute( COL_MAIN_PROC_CD ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_SUB_PROC_CD1 ) ) )
                    ccl_proc_cd1 = DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD1 ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_SUB_PROC_CD2 ) ) )
                    ccl_proc_cd2 = DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD2 ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_SUB_PROC_CD3 ) ) )
                    ccl_proc_cd3 = DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD3 ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_COT_MTH ) ) )
                    cot_mth = DbCommonUtil.valueOf( row.getAttribute( COL_COT_MTH ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_CUT_LN_YN ) ) )
                    cut_ln_yn = DbCommonUtil.valueOf( row.getAttribute( COL_CUT_LN_YN ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_LUS_RT_CD_FRN ) ) )
                    lus_rt_cd_frn = DbCommonUtil.valueOf( row.getAttribute( COL_LUS_RT_CD_FRN ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_RSN_TP_FRN ) ) )
                    rsn_tp_frn = DbCommonUtil.valueOf( row.getAttribute( COL_RSN_TP_FRN ) );
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_PTT_FLM_DTL_CD ) ) )
                    ptt_flm_dtl_cd = DbCommonUtil.valueOf( row.getAttribute( COL_PTT_FLM_DTL_CD ) );
                
                logger.logDebug( "===CCL BOM PROC CHECK TEST=== ");
                logger.logDebug( "check 1 ccl_proc_cd    : " + ccl_proc_cd );
                logger.logDebug( "check 1 ccl_proc_cd1   : " + ccl_proc_cd1 );
                logger.logDebug( "check 1 ccl_proc_cd2   : " + ccl_proc_cd2 );
                logger.logDebug( "check 1 ccl_proc_cd3   : " + ccl_proc_cd3 );
            }
        }

        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
        {
            // if ( ord_slit_grp_cnt > 0 && Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) == ord_mix_wth1 )
            //     exc_wth = Double.toString( Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * ord_slit_grp_cnt );
            // else if ( ord_slit_grp_cnt > 0 && Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) != ord_mix_wth1 )
            //     exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
            // else
            //     exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
            if ( ord_slit_grp_cnt > 0 )
                exc_wth = Double.toString(   ord_mix_wth1 + ord_mix_wth2 + ord_mix_wth3 + ord_mix_wth4 + ord_mix_wth5
                		                         + ord_mix_wth6 + ord_mix_wth7 + ord_mix_wth8 + ord_mix_wth9 + ord_mix_wth10 );
            else
                exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
        }

        ArrayList<String> DEL_PROC = new ArrayList<String>();
        ArrayList<String> DATA_PROC = new ArrayList<String>();
        //2022.12.27 백선이과장요청 (slit 조수 조건 추가)
        //colValue = new String[22];
        colValue = new String[23];
        colValue[0] = prd_nm_cd;
        colValue[1] = bak_mrk;
        colValue[2] = ord_coil_idia;
        colValue[3] = ord_slv_knd_tp;
        colValue[4] = ord_sur_hnd_cd;
        colValue[5] = gw_asg_cd;
        colValue[6] = embs_cd;
        colValue[7] = ord_pak_unt_wgt_llv;
        colValue[8] = ord_coil_odia;
        colValue[9] = ord_exc_thk;
        colValue[10] = exc_wth;
        colValue[11] = rsn_tp_frn;
        colValue[12] = lus_rt_cd_frn;
        colValue[13] = ptt_flm_dtl_cd;
        colValue[14] = mql_cd;
        colValue[15] = ord_edg_asg_tp; // 주문에지구분
        colValue[16] = ord_exc_lth;    // 주문길이추가(2014.08.11 이돈석 - 박성용기사 요청)
        colValue[17] = prd_shp;        // 제품형태추가(2016.03.24 이돈석 - 김태훈기사 요청)
        colValue[18] = ord_coilg_mth;  // 권취방법추가(2016.04.14 이돈석 - 김태훈기사 요청)
        colValue[19] = fnl_cus_cd;  // 최종수요가추가(2017.07.17 - 우병우과장 요청)
        colValue[20] = ord_usg_cd;  // 주문용도추가(2017.07.17 - 우병우과장 요청)
        colValue[21] = ord_spnl_tp;  //스팽글추가(2020.04.17 - 이동윤기사 요청)
        colValue[22] = Double.toString(ord_slit_grp_cnt); //slit조수(2022.12.27 이돈석 - 백선이과장 요청)
        
        logger.logDebug( "==='통과공정삭제' 기준 조건 Param=== ");
        logger.logDebug("품명                                  : " + colValue[0]);
        logger.logDebug("bak_mrk             : " + colValue[1]);
        logger.logDebug("ord_coil_idia       : " + colValue[2]);
        logger.logDebug("ord_slv_knd_tp      : " + colValue[3]);
        logger.logDebug("ord_sur_hnd_cd      : " + colValue[4]);
        logger.logDebug("gw_asg_cd           : " + colValue[5]);
        logger.logDebug("embs_cd             : " + colValue[6]);
        logger.logDebug("ord_pak_unt_wgt_llv : " + colValue[7]);
        logger.logDebug("ord_coil_odia       : " + colValue[8]);
        logger.logDebug("ord_exc_thk         : " + colValue[9]);
        logger.logDebug("exc_wth             : " + colValue[10]);
        logger.logDebug("rsn_tp_frn          : " + colValue[11]);
        logger.logDebug("lus_rt_cd_frn       : " + colValue[12]);
        logger.logDebug("ptt_flm_dtl_cd      : " + colValue[13]);
        logger.logDebug("mql_cd              : " + colValue[14]);
        logger.logDebug("ord_edg_asg_tp      : " + colValue[15]);
        logger.logDebug("ord_exc_lth         : " + colValue[16]);
        logger.logDebug("prd_shp             : " + colValue[17]);
        logger.logDebug("ord_coilg_mth       : " + colValue[18]);
        logger.logDebug("fnl_cus_cd          : " + colValue[19]);
        logger.logDebug("ord_usg_cd          : " + colValue[20]);
        logger.logDebug("ord_spnl_tp         : " + colValue[21]);
        logger.logDebug("ord_slit_grp_cnt    : " + colValue[22]);

        try{
            // 결과값 잘 가져오는지 확인
            PosDecisionRuleVO result = EasyAccess.getPosDecisionRuleLov( C10B2010, colValue, null );
            result.next(); //여러건인 경우확인
            DEL_PROC.add( result.getRuleValueAt( COL_PROC_CD ) );
            logger.logDebug( "==='통과공정삭제' 기준 적용 공정=== ");
            while ( result.next() ){
            	//logger.logDebug( "===CCL BOM PROC CHECK TEST=== ");
                //logger.logDebug( "check 2 COL_PROC_CD    : " + COL_PROC_CD );
            	DEL_PROC.add( result.getRuleValueAt( COL_PROC_CD ) );
            	//logger.logDebug( "check 2 AFTER DEL_PROC : " + COL_PROC_CD );
                logger.logDebug("삭제 proc_cd   : " + result.getRuleValueAt( COL_PROC_CD ));
            }
        }catch ( MasterDataException e ){
        	//logger.logDebug( "===donseok=== ");
        	logger.logError( C10B2010 + C10STR_COLON  + e.getMessage() );
        }
        
        // 정전공정추가기준
        colValue = new String[9];
        colValue[0] = prd_nm_cd;
        colValue[1] = prd_shp;
        colValue[2] = Double.toString( ord_slit_grp_cnt );
        colValue[3] = Double.toString( mix_wth );
        colValue[4] = ord_edg_asg_tp;
        colValue[5] = ord_exc_thk;
        colValue[6] = cut_ln_yn;
        colValue[7] = trst_proc_yn;
        colValue[8] = embs_cd;
        
        logger.logDebug( "==='정전공정추가' 기준 조건 Param===");
        logger.logDebug("품명      colValue[0]   : " + colValue[0]);
        logger.logDebug("제품형태 colValue[1]   : " + colValue[1]);
        logger.logDebug("Slit조수   colValue[2]   : " + colValue[2]);
        logger.logDebug("mix_wht  colValue[3]   : " + colValue[3]);
        logger.logDebug("           colValue[4]   : " + colValue[4]);
        logger.logDebug("           colValue[5]   : " + colValue[5]);
        logger.logDebug("           colValue[6]   : " + colValue[6]);
        logger.logDebug("           colValue[7]   : " + colValue[7]);
        logger.logDebug("           colValue[8]   : " + colValue[8]);
        

        PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B2050, null );
        PosRuleVO result = null;
        try{
            // 결과값 잘 가져오는지 확인
            result = checker.getPosRule( colValue );

            loc = result.getRuleValueAt( COL_LOC );  //공정 앞뒤 확인
            cor_proc_cd = result.getRuleValueAt( COL_MAIN_PROC_CD );
            cor_proc_cd1 = result.getRuleValueAt( COL_SUB_PROC_CD1 );
            cor_proc_cd2 = result.getRuleValueAt( COL_SUB_PROC_CD2 );
            cor_proc_cd3 = result.getRuleValueAt( COL_SUB_PROC_CD3 );
            base_proc_cd = result.getRuleValueAt( COL_BASE_PROC_CD );  //기준공정
            
            //2014.11.05 박성용기사 요청 (추가된 정전공정 중74번공정이고 폭이 1270 이상인 경우 74번을 추가하지 않음)
            if(cor_proc_cd1.equals( NUM7 + NUM4 ) && Double.parseDouble(exc_wth) > 1270){ 
            	cor_proc_cd1 = C10STR_SPACE;
            }
            
            logger.logDebug( "==='정전공정추가' 기준 CHECK1=== ");
            logger.logDebug( "check 3 cor_proc_cd    : " + cor_proc_cd );
            logger.logDebug( "check 3 cor_proc_cd1   : " + cor_proc_cd1 );
            logger.logDebug( "check 3 cor_proc_cd2   : " + cor_proc_cd2 );
            logger.logDebug( "check 3 cor_proc_cd3   : " + cor_proc_cd3 );
            logger.logDebug( "check 3 base_proc_cd   : " + base_proc_cd );
            
            
        }catch ( MasterDataException e ){
            logger.logError( C10B2050 + C10STR_COLON  + e.getMessage() );
        }
        
        logger.logDebug( "==='정전공정추가' 기준 CHECK 2=== ");
        logger.logDebug( "check 3 cor_proc_cd    : " + cor_proc_cd );
        logger.logDebug( "check 3 cor_proc_cd1   : " + cor_proc_cd1 );
        logger.logDebug( "check 3 cor_proc_cd2   : " + cor_proc_cd2 );
        logger.logDebug( "check 3 cor_proc_cd3   : " + cor_proc_cd3 );
        logger.logDebug( "check 3 base_proc_cd   : " + base_proc_cd );

        // TM 2pass 기준
        colValue = new String[9];
        colValue[0] = prd_nm_cd;
        colValue[1] = spc_avr;
        colValue[2] = fnl_cus_cd;
        colValue[3] = ord_usg_cd;
        colValue[4] = ord_sur_hnd_cd;
        colValue[5] = lus_rt_cd_frn;
        colValue[6] = ord_exc_thk;
        colValue[7] = exc_wth;
        colValue[8] = embs_cd;

        checker = EasyAccess.getPosDecisionChecker( C10B2240, null );
        result = null;
        try{
            // 결과값 잘 가져오는지 확인
            result = checker.getPosRule( colValue );
            if(!result.getRuleValueAt( COL_TM_PASS_CNT ).equals( NUM1 )){
                tm_proc_cd = NUM5 + NUM1;
            }
            ctx.put( COL_TM_PASS_CNT, result.getRuleValueAt( COL_TM_PASS_CNT ) );
        }catch ( MasterDataException e ){
            logger.logError( C10B2240 + C10STR_COLON  + e.getMessage() );
        }
        
        logger.logDebug( "==='TM 2pass' 기준 CHECK=== ");
        logger.logDebug( "tm_proc_cd    : " + tm_proc_cd );
        
        param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, pas_proc_no );
        param.setWhereClauseParameter( 1, base_proc_cd );
        param.setWhereClauseParameter( 2, pas_proc_no );
        try{
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( VI_M00_C10A1054N, param ); // 통과공정기준View.select
        }catch ( Exception e ){
            rowset = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK23 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }

        if ( rowset.count() == 0 ){
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK23 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R84 );
            return PosBizControlConstants.FAILURE;
        }
        
        logger.logDebug( "===While '통과공정기준' select 조건 Param=== ");
        logger.logDebug( "pas_proc_no    : " + pas_proc_no );
        logger.logDebug( "base_proc_cd   : " + base_proc_cd ); 

        while ( rowset.hasNext() ){
            row = rowset.next();
            
            logger.logDebug( "==='통과공정' select Data === ");
            logger.logDebug( "seq    : " + DbCommonUtil.valueOf( row.getAttribute( COL_PROC_SEQ ) ) );
            logger.logDebug( "main_proc_cd    : " + DbCommonUtil.valueOf( row.getAttribute( COL_MAIN_PROC_CD ) ));
            logger.logDebug( "value   : " + DbCommonUtil.valueOf( row.getAttribute( C10PN_VALUE ) ) );
            
            
            main_proc_cd = DbCommonUtil.valueOf( row.getAttribute( COL_MAIN_PROC_CD ) );
            count = Integer.parseInt( DbCommonUtil.valueOf( row.getAttribute( C10PN_VALUE ) ) );
            // 반제품 Material code 조회
            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, mtl_cd );

            if ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_5 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_6 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_7 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_8 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_9 ) )
            {
                // RCL(72) 공정은 공정코드 전체(72)를 비교하여 Set한다.
                if ( main_proc_cd.equals( NUM7 + NUM2 ) )
                    param.setWhereClauseParameter( 1, main_proc_cd );
                else if ( !main_proc_cd.substring( 0, 1 ).equals( NUM7 ) )
                    param.setWhereClauseParameter( 1, main_proc_cd.substring( 0, 1 ) );
            } else
                param.setWhereClauseParameter( 1, main_proc_cd.substring( 0, 1 ) );
            
            try{
                // 결과값 잘 가져오는지 확인
                if ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                        prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                        prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                        prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                        prd_nm_cd.equals( PRD_NM_CD_5 ) || 
                        prd_nm_cd.equals( PRD_NM_CD_6 ) ||
                        prd_nm_cd.equals( PRD_NM_CD_7 ) ||
                        prd_nm_cd.equals( PRD_NM_CD_8 ) ||
                        prd_nm_cd.equals( PRD_NM_CD_9 ) )
                {
                    // RCL(72) 공정은 공정코드 전체(72)를 비교하여 Set한다.
                    if ( main_proc_cd.equals( NUM7 + NUM2 ) )
                        rowset1 = dao.find( SELECT_SEM_MTL1, param ); // 반제품 Material
                    // R/S(72이외 7로 시작하는 공정) 공정은 RCL공정(72)를 제외한 "7"로 시작하는 공정코드를 비교하여 Set한다.
                    else if ( main_proc_cd.substring( 0, 1 ).equals( NUM7 ) )
                        rowset1 = dao.find( SELECT_SEM_MTL3, param ); // 반제품 Material
                    // 이외의 공정은 공정코드비교시 공정코드 첫자리만 비교하여 Match되는 공정의 반제품 Material Code를 Set한다.
                    else
                        rowset1 = dao.find( SELECT_SEM_MTL2, param ); // 반제품 Material
                }else
                    rowset1 = dao.find( SELECT_SEM_MTL2, param ); // 반제품 Material
            }catch ( Exception e ){
                rowset1 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK23 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( rowset1.count() > 0 ){
                row1 = rowset1.next();
                sem_prod_mtl_cd = DbCommonUtil.valueOf( row1.getAttribute( COL_SEM_PROD_MTL_CD ) );
            }

            logger.logDebug( "===Sem_mtl_cd CHECK=== ");
            logger.logDebug( "main_proc_cd      : " + main_proc_cd );
            logger.logDebug( "sem_prod_mtl_cd : " + sem_prod_mtl_cd );

            if ( main_proc_cd.substring( 0, 1 ).equals( base_proc_cd ) ){
                if ( loc.equals( C10STR_B ) ){
                    seq++;
                    if(count == seq){
                        param = new PosParameter(); // MD View param
                        param.setWhereClauseParameter( 0, mtl_cd );
                        if ( cor_proc_cd.equals( NUM7 + NUM2 ) )
                            param.setWhereClauseParameter( 1, cor_proc_cd );
                        else if ( !cor_proc_cd.substring( 0, 1 ).equals( NUM7 ) )
                            param.setWhereClauseParameter( 1, cor_proc_cd.substring( 0, 1 ) );
    
                        try{
                            if ( cor_proc_cd.equals( NUM7 + NUM2 ) )
                                rowset1 = dao.find( SELECT_SEM_MTL1, param ); // 반제품 Material
                            // R/S(72이외 7로 시작하는 공정) 공정은 RCL공정(72)를 제외한 "7"로 시작하는 공정코드를 비교하여 Set한다.
                            else if ( cor_proc_cd.substring( 0, 1 ).equals( NUM7 ) )
                                rowset1 = dao.find( SELECT_SEM_MTL3, param ); // 반제품 Material
                            // 이외의 공정은 공정코드비교시 공정코드 첫자리만 비교하여 Match되는 공정의 반제품 Material Code를 Set한다.
                            else
                                rowset1 = dao.find( SELECT_SEM_MTL2, param ); // 반제품 Material
                        }catch ( Exception e ){
                            rowset1 = null;
                            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK23 );
                            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                            logger.logError( e.getMessage() );
                            return PosBizControlConstants.FAILURE;
                        }
    
                        proc_seq = Integer.parseInt( row.getAttribute( COL_PROC_SEQ ).toString() ) + add_seq;
                        add_seq++;
                        // 정전공정 자동추가 칼라공정 이전
                        ctx.put( COL_PROC_SEQ, proc_seq );
                        ctx.put( COL_MAIN_PROC_CD, cor_proc_cd );
                        ctx.put( COL_SUB_PROC_CD1, cor_proc_cd1 );
                        ctx.put( COL_SUB_PROC_CD2, cor_proc_cd2 );
                        ctx.put( COL_SUB_PROC_CD3, cor_proc_cd3 );
                        ctx.put( COL_SUB_PROC_CD4, C10STR_SPACE );
                        ctx.put( COL_SUB_PROC_CD5, C10STR_SPACE );
                        ctx.put( COL_SUB_PROC_CD6, C10STR_SPACE );
                        ctx.put( COL_SEM_PROD_MTL_CD, sem_prod_mtl_cd );
                        if ( !InsProc( dao, ctx ) ){
                            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB08 );
                            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                            return PosBizControlConstants.FAILURE;
                        }
                        logger.logDebug( "==='정전공정추가' 기준 적용(Before)=== ");
                        logger.logDebug( "proc_seq    : "   + proc_seq );
                        logger.logDebug( "cor_proc_cd : "  + cor_proc_cd );
                        logger.logDebug( "cor_proc_cd1 : " + cor_proc_cd1 );
                        logger.logDebug( "cor_proc_cd2 : " + cor_proc_cd2 );
                        logger.logDebug( "cor_proc_cd3 : " + cor_proc_cd3 );
                        logger.logDebug( "Before : " + main_proc_cd );
                    }
                }
            }
            
            
            // 칼라제품 공정코드 설계
            if ( ( prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_2 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_5 ) || 
                    prd_nm_cd.equals( PRD_NM_CD_6 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_7 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_8 ) ||
                    prd_nm_cd.equals( PRD_NM_CD_9 ) ) && 
                    main_proc_cd.substring( 0, 1 ).equals( C10STR_A ) && 
                    main_proc_cd.substring( 1, 2 ).equals( C10STR_X ) )
            {
            	logger.logDebug( "===CCL BOM PROC CHECK TEST=== ");
                logger.logDebug( "check 2 main_proc_cd    : " + main_proc_cd );
                logger.logDebug( "check 2 sub_proc_cd1   : " + sub_proc_cd1 );
                logger.logDebug( "check 2 sub_proc_cd2   : " + sub_proc_cd2 );
                logger.logDebug( "check 2 sub_proc_cd3   : " + sub_proc_cd3 );
                logger.logDebug( "check 2 ccl_proc_cd    : " + ccl_proc_cd );
                logger.logDebug( "check 2 ccl_proc_cd1   : " + ccl_proc_cd1 );
                logger.logDebug( "check 2 ccl_proc_cd2   : " + ccl_proc_cd2 );
                logger.logDebug( "check 2 ccl_proc_cd3   : " + ccl_proc_cd3 );
            	
            	main_proc_cd = ccl_proc_cd;
                sub_proc_cd1 = ccl_proc_cd1;
                sub_proc_cd2 = ccl_proc_cd2;
                sub_proc_cd3 = ccl_proc_cd3;
                sub_proc_cd4 = C10STR_SPACE;
                sub_proc_cd5 = C10STR_SPACE;
                sub_proc_cd6 = C10STR_SPACE;
            }else{
                if ( !DbCommonUtil.isNull( DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD1 ) ) ) )
                    sub_proc_cd1 = row.getAttribute( COL_SUB_PROC_CD1 ).toString();
                else
                    sub_proc_cd1 = C10STR_SPACE;
                if ( !DbCommonUtil.isNull( DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD2 ) ) ) )
                    sub_proc_cd2 = row.getAttribute( COL_SUB_PROC_CD2 ).toString();
                else
                    sub_proc_cd2 = C10STR_SPACE;
                if ( !DbCommonUtil.isNull( DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD3 ) ) ) )
                    sub_proc_cd3 = row.getAttribute( COL_SUB_PROC_CD3 ).toString();
                else
                    sub_proc_cd3 = C10STR_SPACE;
                if ( !DbCommonUtil.isNull( DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD4 ) ) ) )
                    sub_proc_cd4 = row.getAttribute( COL_SUB_PROC_CD4 ).toString();
                else
                    sub_proc_cd4 = C10STR_SPACE;
                if ( !DbCommonUtil.isNull( DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD5 ) ) ) )
                    sub_proc_cd5 = row.getAttribute( COL_SUB_PROC_CD5 ).toString();
                else
                    sub_proc_cd5 = C10STR_SPACE;
                if ( !DbCommonUtil.isNull( DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD6 ) ) ) )
                    sub_proc_cd6 = row.getAttribute( COL_SUB_PROC_CD6 ).toString();
                else
                    sub_proc_cd6 = C10STR_SPACE;
            }
            logger.logDebug( "===통과공정순서 기준 Select 결과=== ");
            logger.logDebug( " main_proc_cd    : " + main_proc_cd );
            logger.logDebug( " sub_proc_cd1   : " + sub_proc_cd1 );
            logger.logDebug( " sub_proc_cd2   : " + sub_proc_cd2 );
            logger.logDebug( " sub_proc_cd3   : " + sub_proc_cd3 );
            logger.logDebug( " sub_proc_cd4   : " + sub_proc_cd4 );
            logger.logDebug( " sub_proc_cd5   : " + sub_proc_cd5 );
            logger.logDebug( " sub_proc_cd6   : " + sub_proc_cd6 );

            // 통과공정 결정기준을 읽어 통과공정을 삭제한다.
            if ( DEL_PROC.size() > 0 ){
            	logger.logDebug( "===check 20=== ");
            	DATA_PROC = DelProc( DEL_PROC, main_proc_cd, sub_proc_cd1, sub_proc_cd2, sub_proc_cd3, sub_proc_cd4, sub_proc_cd5, sub_proc_cd6 );

            	if ( DATA_PROC.get( 0 ).equals( C10STR_SPACE ) ){
            		ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK27 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R118 );
                    return PosBizControlConstants.FAILURE;
                }

                main_proc_cd = DATA_PROC.get( 0 );
                sub_proc_cd1 = DATA_PROC.get( 1 );
                sub_proc_cd2 = DATA_PROC.get( 2 );
                sub_proc_cd3 = DATA_PROC.get( 3 );
                sub_proc_cd4 = DATA_PROC.get( 4 );
                sub_proc_cd5 = DATA_PROC.get( 5 );
                sub_proc_cd6 = DATA_PROC.get( 6 );
                
                logger.logDebug( "==='통과공정삭제' 기준 적용 후=== ");
                logger.logDebug( " main_proc_cd    : " + main_proc_cd );
                logger.logDebug( " sub_proc_cd1   : " + sub_proc_cd1 );
                logger.logDebug( " sub_proc_cd2   : " + sub_proc_cd2 );
                logger.logDebug( " sub_proc_cd3   : " + sub_proc_cd3 );
                logger.logDebug( " sub_proc_cd4   : " + sub_proc_cd4 );
                logger.logDebug( " sub_proc_cd5   : " + sub_proc_cd5 );
                logger.logDebug( " sub_proc_cd6   : " + sub_proc_cd6 );
                /*
                if(main_proc_cd.substring( 0, 1 ).equals( C10STR_A ))  //여기가 문제라서 조건을 추가했음...
                {
                	ccl_proc_cd  = main_proc_cd;
                    ccl_proc_cd1 = sub_proc_cd1;
                    ccl_proc_cd2 = sub_proc_cd2;
                    ccl_proc_cd3 = sub_proc_cd3;                    
                }
                */
            }
            
            if ( main_proc_cd.equals( C10STR_SPACE ) ){
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK27 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R118 );
                return PosBizControlConstants.FAILURE;
            }

           //?????? 전체 공정 적용되는 거?   
            proc_seq = Integer.parseInt( DbCommonUtil.valueOf( row.getAttribute( COL_PROC_SEQ ) ) ) + 
                    add_seq;
            
            // main_proc '6X' 일때 칼라정전라인결정기준 적용
            if ( !main_proc_cd.equals( C10STR_SPACE ) && main_proc_cd.substring( 0, 1 ).equals( NUM6 ) && main_proc_cd.substring( 1, 2 ).equals( C10STR_X ) )
            {
                //삭제된 최종 칼라공정을 가져오기 위해서 PROC테이블을 검색
            	//검색 후 ccl_proc_cd_tmp 변수에 담아서 shl공정 검색
            	//2014.09.26일 박성용 기사 요청으로 변경 (이돈석)
            	param = new PosParameter();
            	param.setWhereClauseParameter( 0, ord_no);
            	param.setWhereClauseParameter( 1, ord_ln);
            	
            	try{
            		rowset2 = dao.find( SELECT_CCL_PROC, param);
            	}catch ( Exception e ){
            		rowset2 = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
            	}
            	if ( rowset2.count() == 0 ){
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KP05 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R98 );
                    return PosBizControlConstants.FAILURE;
            	}else{
            		row2 = rowset2.next();
            		if ( !DbCommonUtil.isNull( row2.getAttribute( COL_MAIN_PROC_CD ) ) )
            			ccl_proc_cd_tmp = DbCommonUtil.valueOf( row2.getAttribute( COL_MAIN_PROC_CD ) );
                    if ( !DbCommonUtil.isNull( row2.getAttribute( COL_SUB_PROC_CD1 ) ) )
                        ccl_proc_cd1_tmp = DbCommonUtil.valueOf( row2.getAttribute( COL_SUB_PROC_CD1 ) );
                    if ( !DbCommonUtil.isNull( row2.getAttribute( COL_SUB_PROC_CD2 ) ) )
                        ccl_proc_cd2_tmp = DbCommonUtil.valueOf( row2.getAttribute( COL_SUB_PROC_CD2 ) );
                    if ( !DbCommonUtil.isNull( row2.getAttribute( COL_SUB_PROC_CD3 ) ) )
                        ccl_proc_cd3_tmp = DbCommonUtil.valueOf( row2.getAttribute( COL_SUB_PROC_CD3 ) );
                    if ( !DbCommonUtil.isNull( row2.getAttribute( COL_SUB_PROC_CD4 ) ) )
                        ccl_proc_cd4_tmp = DbCommonUtil.valueOf( row2.getAttribute( COL_SUB_PROC_CD4 ) );
                    if ( !DbCommonUtil.isNull( row2.getAttribute( COL_SUB_PROC_CD5 ) ) )
                        ccl_proc_cd5_tmp = DbCommonUtil.valueOf( row2.getAttribute( COL_SUB_PROC_CD5 ) );
                    if ( !DbCommonUtil.isNull( row2.getAttribute( COL_SUB_PROC_CD6 ) ) )
                        ccl_proc_cd6_tmp = DbCommonUtil.valueOf( row2.getAttribute( COL_SUB_PROC_CD6 ) );
            	}
            	
            	logger.logDebug( "===main_proc '6X'에 대한 이전 칼라공정 Select===");
                logger.logDebug( " ccl_proc_cd_tmp    : " + ccl_proc_cd_tmp );
                logger.logDebug( " ccl_proc_cd1_tmp   : " + ccl_proc_cd1_tmp );
                logger.logDebug( " ccl_proc_cd2_tmp   : " + ccl_proc_cd2_tmp );
                logger.logDebug( " ccl_proc_cd3_tmp   : " + ccl_proc_cd3_tmp );
                logger.logDebug( " ccl_proc_cd4_tmp   : " + ccl_proc_cd4_tmp );
                logger.logDebug( " ccl_proc_cd5_tmp   : " + ccl_proc_cd5_tmp );
                logger.logDebug( " ccl_proc_cd6_tmp   : " + ccl_proc_cd6_tmp );

            	main_proc_cd = CclShlProc( ccl_proc_cd_tmp, ctx, dao );  //요부분 위에서 가져온 값으로 대입
                if ( main_proc_cd.equals( C10STR_SPACE ) )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R129 );
                    return PosBizControlConstants.FAILURE;
                }
                else if ( main_proc_cd.equals( C10STR_SPACE2 ) )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                    logger.logError( ERRMSG_R130 );
                    return PosBizControlConstants.FAILURE;
                }

                if ( !ccl_proc_cd1_tmp.equals( C10STR_SPACE ) )
                {
                    sub_proc_cd1 = CclShlProc( ccl_proc_cd1_tmp, ctx, dao ); //요부분 ccl_proc_cd1가져 오는것...
                    if ( sub_proc_cd1.equals( C10STR_SPACE ) ){
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R129 );
                        return PosBizControlConstants.FAILURE;
                    }
                    else if ( sub_proc_cd1.equals( C10STR_SPACE2 ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R130 );
                        return PosBizControlConstants.FAILURE;
                    }
                }

                if ( !ccl_proc_cd2_tmp.equals( C10STR_SPACE ) )
                {
                    sub_proc_cd2 = CclShlProc( ccl_proc_cd2_tmp, ctx, dao );  //요부분 ccl_proc_cd2가져 오는것...
                    if ( sub_proc_cd2.equals( C10STR_SPACE ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R129 );
                        return PosBizControlConstants.FAILURE;
                    }
                    else if ( sub_proc_cd2.equals( C10STR_SPACE2 ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R130 );
                        return PosBizControlConstants.FAILURE;
                    }
                }

                if ( !ccl_proc_cd3_tmp.equals( C10STR_SPACE ) )
                {
                    sub_proc_cd3 = CclShlProc( ccl_proc_cd3_tmp, ctx, dao );  //요부분 ccl_proc_cd3가져 오는것...
                    if ( sub_proc_cd3.equals( C10STR_SPACE ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R129 );
                        return PosBizControlConstants.FAILURE;
                    }else if ( sub_proc_cd3.equals( C10STR_SPACE2 ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R130 );
                        return PosBizControlConstants.FAILURE;
                    }
                }
 
                if ( !ccl_proc_cd4_tmp.equals( C10STR_SPACE ) )
                {
                    sub_proc_cd4 = CclShlProc( ccl_proc_cd4_tmp, ctx, dao );  //요부분 ccl_proc_cd3가져 오는것...
                    if ( sub_proc_cd4.equals( C10STR_SPACE ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R129 );
                        return PosBizControlConstants.FAILURE;
                    }else if ( sub_proc_cd4.equals( C10STR_SPACE2 ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R130 );
                        return PosBizControlConstants.FAILURE;
                    }
                }
                if ( !ccl_proc_cd5_tmp.equals( C10STR_SPACE ) )
                {
                    sub_proc_cd5 = CclShlProc( ccl_proc_cd5_tmp, ctx, dao );  //요부분 ccl_proc_cd3가져 오는것...
                    if ( sub_proc_cd5.equals( C10STR_SPACE ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R129 );
                        return PosBizControlConstants.FAILURE;
                    }else if ( sub_proc_cd5.equals( C10STR_SPACE2 ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R130 );
                        return PosBizControlConstants.FAILURE;
                    }
                }
                if ( !ccl_proc_cd6_tmp.equals( C10STR_SPACE ) )
                {
                    sub_proc_cd6 = CclShlProc( ccl_proc_cd6_tmp, ctx, dao );  //요부분 ccl_proc_cd3가져 오는것...
                    if ( sub_proc_cd6.equals( C10STR_SPACE ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R129 );
                        return PosBizControlConstants.FAILURE;
                    }else if ( sub_proc_cd6.equals( C10STR_SPACE2 ) )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        logger.logError( ERRMSG_R130 );
                        return PosBizControlConstants.FAILURE;
                    }
                }
                logger.logDebug( "===main_proc '6X' 일때 칼라정전공정결정기준 적용 후===");
                logger.logDebug( " main_proc_cd   : " + main_proc_cd );
                logger.logDebug( " sub_proc_cd1   : " + sub_proc_cd1 );
                logger.logDebug( " sub_proc_cd2   : " + sub_proc_cd2 );
                logger.logDebug( " sub_proc_cd3   : " + sub_proc_cd3 );
                logger.logDebug( " sub_proc_cd4   : " + sub_proc_cd4 );
                logger.logDebug( " sub_proc_cd5   : " + sub_proc_cd5 );
                logger.logDebug( " sub_proc_cd6   : " + sub_proc_cd6 );
            }

            // 품질설계결과 통과공정 Insert
            ctx.put( COL_PROC_SEQ, proc_seq );
            ctx.put( COL_MAIN_PROC_CD, main_proc_cd );
            ctx.put( COL_SUB_PROC_CD1, sub_proc_cd1 );
            ctx.put( COL_SUB_PROC_CD2, sub_proc_cd2 );
            ctx.put( COL_SUB_PROC_CD3, sub_proc_cd3 );
            ctx.put( COL_SUB_PROC_CD4, sub_proc_cd4 );
            ctx.put( COL_SUB_PROC_CD5, sub_proc_cd5 );
            ctx.put( COL_SUB_PROC_CD6, sub_proc_cd6 );
            ctx.put( COL_SEM_PROD_MTL_CD, sem_prod_mtl_cd );
            
            if ( !InsProc( dao, ctx ) ){
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB08 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                return PosBizControlConstants.FAILURE;
            }
            logger.logDebug( "==='통과공정순서' 기준 Insert(타 기준에 의한 Insert 아님)=== ");
            logger.logDebug( " proc_seq        : " + proc_seq );
            logger.logDebug( " main_proc_cd   : " + main_proc_cd );
            logger.logDebug( " sub_proc_cd1   : " + sub_proc_cd1 );
            logger.logDebug( " sub_proc_cd2   : " + sub_proc_cd2 );
            logger.logDebug( " sub_proc_cd3   : " + sub_proc_cd3 );
            logger.logDebug( " sub_proc_cd4   : " + sub_proc_cd4 );
            logger.logDebug( " sub_proc_cd5   : " + sub_proc_cd5 );
            logger.logDebug( " sub_proc_cd6   : " + sub_proc_cd6 );

           
            if(main_proc_cd.equals( NUM5 + NUM1 )){
                if ( DbCommonUtil.isNull( ctx.get( COL_TM_PASS_CNT ) ) ){
                    ctx.put( COL_TM_PASS_CNT, NUM1 );                    
                }else{
                	ctx.put( COL_TM_PASS_CNT, NUM1 );  //TM의 경우는 무조건 1PASS임 (2018.06.20 이돈석)
                }

                if(tm_proc_cd.equals( NUM5 + NUM1 )){
                    add_seq++;
                    proc_seq = Integer.parseInt( row.getAttribute( COL_PROC_SEQ ).toString() ) + add_seq;

                    ctx.put( COL_PROC_SEQ, proc_seq );
                    ctx.put( COL_MAIN_PROC_CD, main_proc_cd );
                    ctx.put( COL_SUB_PROC_CD1, sub_proc_cd1 );
                    ctx.put( COL_SUB_PROC_CD2, sub_proc_cd2 );
                    ctx.put( COL_SUB_PROC_CD3, sub_proc_cd3 );
                    ctx.put( COL_SUB_PROC_CD4, sub_proc_cd4 );
                    ctx.put( COL_SUB_PROC_CD5, sub_proc_cd5 );
                    ctx.put( COL_SUB_PROC_CD6, sub_proc_cd6 );
                    ctx.put( COL_SEM_PROD_MTL_CD, sem_prod_mtl_cd );
                    if ( !InsProc( dao, ctx ) ){
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB08 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        return PosBizControlConstants.FAILURE;
                    }
                    tm_proc_cd = C10STR_SPACE;
                }
            }
            
            //칼라공정 2Pass 적용
            if ( main_proc_cd.substring( 0, 1 ).equals( C10STR_A ) ){
                if ( ( (cot_mth.equals( C10STR_A ) || 
                        cot_mth.equals( C10STR_B ) || 
                        cot_mth.equals( C10STR_C ) || 
                        cot_mth.equals( PRD_NM_CD_D ) || 
                        cot_mth.equals( PRD_NM_CD_E ) )  && ( !ccl_bom_no.substring( 0, 1 ).equals( C10STR_V ))  ) ||   
                        ( ( cot_mth.equals( NUM6 ) || 
                                cot_mth.equals( NUM7 ) || 
                                cot_mth.equals( NUM8 ) || 
                                cot_mth.equals( NUM9 ) ) && 
                                ( main_proc_cd.equals( C10STR_A + NUM2 ) || 
                                        main_proc_cd.equals( C10STR_A + NUM3 ) || 
                                        //main_proc_cd.equals( C10STR_A + NUM4 ) || 
                                        main_proc_cd.equals( C10STR_A + NUM6 ) ) ) )
                {
                    add_seq++;
                    proc_seq = Integer.parseInt( row.getAttribute( COL_PROC_SEQ ).toString() ) + add_seq;

                    ctx.put( COL_PROC_SEQ, proc_seq );
                    ctx.put( COL_MAIN_PROC_CD, main_proc_cd );
                    ctx.put( COL_SUB_PROC_CD1, sub_proc_cd1 );
                    ctx.put( COL_SUB_PROC_CD2, sub_proc_cd2 );
                    ctx.put( COL_SUB_PROC_CD3, sub_proc_cd3 );
                    ctx.put( COL_SUB_PROC_CD4, sub_proc_cd4 );
                    ctx.put( COL_SUB_PROC_CD5, sub_proc_cd5 );
                    ctx.put( COL_SUB_PROC_CD6, sub_proc_cd6 );
                    ctx.put( COL_SEM_PROD_MTL_CD, sem_prod_mtl_cd );
                    if ( !InsProc( dao, ctx ) ){
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB08 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                        return PosBizControlConstants.FAILURE;
                    }
                }
                logger.logDebug( "===칼라공정 2Pass 적용(Insert) 후=== ");
                logger.logDebug( " proc_seq        : " + proc_seq );
                logger.logDebug( " main_proc_cd   : " + main_proc_cd );
                logger.logDebug( " sub_proc_cd1   : " + sub_proc_cd1 );
                logger.logDebug( " sub_proc_cd2   : " + sub_proc_cd2 );
                logger.logDebug( " sub_proc_cd3   : " + sub_proc_cd3 );
                logger.logDebug( " sub_proc_cd4   : " + sub_proc_cd4 );
                logger.logDebug( " sub_proc_cd5   : " + sub_proc_cd5 );
                logger.logDebug( " sub_proc_cd6   : " + sub_proc_cd6 );
            }
            

            if (main_proc_cd.substring( 0, 1 ).equals( base_proc_cd ) ){
                if ( loc.equals( C10STR_A ) ){
                    seq++;
                    if(count == seq){
                        param = new PosParameter(); // MD View param
                        param.setWhereClauseParameter( 0, mtl_cd );
                        if ( cor_proc_cd.equals( NUM7 + NUM2 ) )
                            param.setWhereClauseParameter( 1, cor_proc_cd );
                        else if ( !cor_proc_cd.substring( 0, 1 ).equals( NUM7 ) )
                            param.setWhereClauseParameter( 1, cor_proc_cd.substring( 0, 1 ) );
    
                        try{
                            if ( cor_proc_cd.equals( NUM7 + NUM2 ) )
                                rowset1 = dao.find( SELECT_SEM_MTL1, param ); // 반제품 Material
                            // R/S(72이외 7로 시작하는 공정) 공정은 RCL공정(72)를 제외한 "7"로 시작하는 공정코드를 비교하여 Set한다.
                            else if ( cor_proc_cd.substring( 0, 1 ).equals( NUM7 ) )
                                rowset1 = dao.find( SELECT_SEM_MTL3, param ); // 반제품 Material
                            // 이외의 공정은 공정코드비교시 공정코드 첫자리만 비교하여 Match되는 공정의 반제품 Material Code를 Set한다.
                            else
                                rowset1 = dao.find( SELECT_SEM_MTL2, param ); // 반제품 Material
                        }catch ( Exception e ){
                            rowset1 = null;
                            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KK23 );
                            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                            logger.logError( e.getMessage() );
                            return PosBizControlConstants.FAILURE;
                        }
    
                        if ( rowset1.count() > 0 ){
                            row1 = rowset1.next();
                            sem_prod_mtl_cd = DbCommonUtil.valueOf( row1.getAttribute( COL_SEM_PROD_MTL_CD ) );
                        }
    
                        add_seq++;
                        proc_seq = Integer.parseInt( row.getAttribute( COL_PROC_SEQ ).toString() ) + add_seq;
                        // 정전공정 자동추가 칼라공정 이전
                        ctx.put( COL_PROC_SEQ, proc_seq );
                        ctx.put( COL_MAIN_PROC_CD, cor_proc_cd );
                        ctx.put( COL_SUB_PROC_CD1, cor_proc_cd1 );
                        ctx.put( COL_SUB_PROC_CD2, cor_proc_cd2 );
                        ctx.put( COL_SUB_PROC_CD3, cor_proc_cd3 );
                        ctx.put( COL_SUB_PROC_CD4, C10STR_SPACE );
                        ctx.put( COL_SUB_PROC_CD5, C10STR_SPACE );
                        ctx.put( COL_SUB_PROC_CD6, C10STR_SPACE );
                         ctx.put( COL_SEM_PROD_MTL_CD, sem_prod_mtl_cd );
                        if ( !InsProc( dao, ctx ) ){
                            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB08 );
                            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                            return PosBizControlConstants.FAILURE;
                        }
                    }
                }
            }
        }
        
        logger.logDebug( "===Main While(통과공정기준 Seq대로 Loop) 문 Exit 후=== ");

        if ( prd_nm_cd.equals( PRD_NM_CD_C ) || 
                prd_nm_cd.equals( PRD_NM_CD_1 ) || 
                prd_nm_cd.equals( PRD_NM_CD_E ) ||
                prd_nm_cd.equals( PRD_NM_CD_2 ) ||
                prd_nm_cd.equals( PRD_NM_CD_8 ) )
        {
            if ( !chgtmpass( dao, ctx ) ){
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_TB06 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                return PosBizControlConstants.FAILURE;
            }
        }
        
        logger.logDebug( "===CCL BOM PROC CHECK TEST=== ");
        logger.logDebug( "check 15 ccl_proc_cd    : " + ccl_proc_cd );
        logger.logDebug( "check 15 ccl_proc_cd1   : " + ccl_proc_cd1 );
        logger.logDebug( "check 15 ccl_proc_cd2   : " + ccl_proc_cd2 );
        logger.logDebug( "check 15 ccl_proc_cd3   : " + ccl_proc_cd3 );
        
        return PosBizControlConstants.SUCCESS;
    }

    /**
     * 통과공정을 편집(삭제)하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param DEL_PROC 삭제대상공정
     * @param MAIN_PROC 주공정
     * @param SUB_PROC_CD1 대체공정1
     * @param SUB_PROC_CD2 대체공정2
     * @param SUB_PROC_CD3 대체공정3
     * @return boolean
     */

    public ArrayList<String> DelProc( ArrayList<String> DEL_PROC, String MAIN_PROC, String SUB_PROC_CD1, String SUB_PROC_CD2, String SUB_PROC_CD3, String SUB_PROC_CD4, String SUB_PROC_CD5, String SUB_PROC_CD6 )
    {
        ArrayList<String> DATA_PROC = new ArrayList<String>();
        ArrayList<String> RESULT_PROC = new ArrayList<String>();
        DATA_PROC.add( MAIN_PROC );
        DATA_PROC.add( SUB_PROC_CD1 );
        DATA_PROC.add( SUB_PROC_CD2 );
        DATA_PROC.add( SUB_PROC_CD3 );
        DATA_PROC.add( SUB_PROC_CD4 );
        DATA_PROC.add( SUB_PROC_CD5 );
        DATA_PROC.add( SUB_PROC_CD6 );
        int RCNT = 0;

        for ( int CNT = 0; CNT < 7; CNT++ )
        {
            if ( !DATA_PROC.get( CNT ).equals( C10STR_SPACE ) )
            {
                for ( int DCNT = 0; DCNT < DEL_PROC.size(); DCNT++ )
                {
                    if ( DATA_PROC.get( CNT ).equals( DEL_PROC.get( DCNT ) ) )
                    {
                        logger.logError( "Delete Line" + C10STR_COLON  + DEL_PROC.get( DCNT ) );
                        break;
                    }

                    if ( DCNT == DEL_PROC.size() - 1 )
                    {
                        RESULT_PROC.add( DATA_PROC.get( CNT ) );
                    }
                }
            }
        }

        if ( RESULT_PROC.size() < 7 )
        {
            RCNT = RESULT_PROC.size();
            for ( int CNT = 0; CNT < 7 - RCNT; CNT++ )
            {
                RESULT_PROC.add( C10STR_SPACE );
            }
        }
        return RESULT_PROC;
    }

    /**
     * 후공정(SHL)코드를 부여하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param MAIN_PROC 공정코드
     * @param ctx PosContext
     * @param dao data access object
     * @return String
     */

    public String CclShlProc( String MAIN_PROC, PosContext ctx, PosGenericDao dao )
    {
        String cor_proc_cd = C10STR_SPACE;
        PosRowSet rowset = null;
        PosRow row = null;
        PosParameter param = new PosParameter(); // MD View param
        param.setWhereClauseParameter( 0, MAIN_PROC );
        try
        {
            // 결과값 잘 가져오는지 확인
            rowset = dao.find( VI_M00_C10A2030, param ); // 칼라정전라인 결정기준View.select
        } catch ( MasterDataException e )
        {
            rowset = null;
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( e.getMessage() );
            return C10STR_SPACE;
        }

        if ( rowset.count() == 1 )
        {
            row = rowset.next();
            cor_proc_cd = row.getAttribute( COL_PROC_CD_SHL ).toString();
        } else if ( rowset.count() > 1 )
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT31 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R130 );
            return C10STR_SPACE2;
        } else
        {
            ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KT30 );
            ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
            logger.logError( ERRMSG_R129 );
            return C10STR_SPACE;
        }

        return cor_proc_cd;
    }

    /**
     * 품질설계 통과공정정보를 저장하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param dao Data Access Object
     * @param ctx PosContext
     * @return boolean
     */

    public boolean InsProc( PosGenericDao dao, PosContext ctx )
    {
        //원본소스
    	/*
    	PosAuditAttributes audit = ctx.getAuditAttribute();
        PosParameter param = new PosParameter(); // MD View param
        param.setValueParamter( 0, ctx.get( COL_ORD_NO ) );
        param.setValueParamter( 1, ctx.get( COL_ORD_LN ) );
        param.setValueParamter( 2, ctx.get( COL_PROC_SEQ ) );
        param.setValueParamter( 3, ctx.get( COL_MAIN_PROC_CD ) );
        param.setValueParamter( 4, ctx.get( COL_SUB_PROC_CD1 ) );
        param.setValueParamter( 5, ctx.get( COL_SUB_PROC_CD2 ) );
        param.setValueParamter( 6, ctx.get( COL_SUB_PROC_CD3 ) );
        param.setValueParamter( 7, ctx.get( COL_SEM_PROD_MTL_CD ) );
        param.setAuditAttributes( audit );
        */
        
        //테스트소스
    	PosAuditAttributes audit = ctx.getAuditAttribute();
        PosParameter param = new PosParameter(); // MD View param
        param.setValueParamter( 0, ctx.get( COL_ORD_NO ) );
        param.setValueParamter( 1, ctx.get( COL_ORD_LN ) );
        param.setValueParamter( 2, ctx.get( COL_PROC_SEQ ) );
        param.setValueParamter( 3, ctx.get( COL_MAIN_PROC_CD ) );
        param.setValueParamter( 4, ctx.get( COL_SUB_PROC_CD1 ) );
        param.setValueParamter( 5, ctx.get( COL_SUB_PROC_CD2 ) );
        param.setValueParamter( 6, ctx.get( COL_SUB_PROC_CD3 ) );
        param.setValueParamter( 7, ctx.get( COL_SUB_PROC_CD4 ) );
        param.setValueParamter( 8, ctx.get( COL_SUB_PROC_CD5 ) );
        param.setValueParamter( 9, ctx.get( COL_SUB_PROC_CD6 ) );
        param.setValueParamter( 10, ctx.get( COL_SEM_PROD_MTL_CD ) );
        param.setAuditAttributes( audit );
        
        try
        {
            dao.insert( INSERT_PROC, param ); // 반제품 Material
        } catch ( Exception e )
        {
            logger.logError( e.getMessage() );
            return false;
        }

        return true;
    }

    /**
     * 품질설계 제조표준 TM pass수 정보를 저장하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param dao Data Access Object
     * @param ctx PosContext
     * @return boolean
     */

    public boolean chgtmpass( PosGenericDao dao, PosContext ctx )
    {
        PosAuditAttributes audit = ctx.getAuditAttribute();
        PosParameter param = new PosParameter(); // MD View param
        param.setValueParamter( 0, ctx.get( COL_TM_PASS_CNT ) );
        param.setValueParamter( 1, ctx.get( COL_ORD_NO ) );
        param.setValueParamter( 2, ctx.get( COL_ORD_LN ) );
        param.setAuditAttributes( audit );

        try
        {
            dao.update( UPDATE_TMPASS, param ); // 반제품 Material
        } catch ( Exception e )
        {
            logger.logError( e.getMessage() );
            return false;
        }

        return true;
    }
}
