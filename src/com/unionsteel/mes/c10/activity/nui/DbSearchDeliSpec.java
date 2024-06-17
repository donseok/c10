/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchDeliSpec.java
 * Change history
 * @LastModifyDate : 2011. 12. 16
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 16 김종범 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import java.util.ArrayList;
import java.util.Iterator;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosColumnDef;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosCalcVO;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 Class는 Master Data의 규격인수도사양기준을 읽어 인수도규격코드를 편성하는 Class이다.
 * <xmp>
 * 1. 편성정보: 인수도규격코드
 * - Master Table Code: 인수도기준(C10A0009)
 * - Key: 규격약호, 수주품종구분, 고객사코드, 주문용도지정코드
 * 2. 편성정보: 인수도공차코드
 * - Master Table Code: 인수도규격(C10A0010)
 * - Key: 인수도규격코드
 * 3. 편성정보: 인수도 공차기준값
 * - Master Table Code: 인수도공차(C10B0004)
 * - Key: 공차코드, 수주품명코드, Edge구분, 주문두께, 주문폭, 주문길이
 * . 인수도규격에서 편성한 공차코드(길이공차코드,두께공차코드,
 * 수직도공차코드, 직각도공차코드,평탄도공차코드,폭공차코드,
 * Burr공차코드,Camber공차코드, Telescope공차코드)에 항목이
 * 존재하는 경우 허용공차를 편성
 * . 주문두께공차코드가 'T','W'인 경우 기준에 따라 허용공차를 변경
 * 4. 편성정보: 표면등급, 형상등급, 결합특기코드 1 ~ 5
 * - Master Table Code: 주문용도기준(C10A0001)
 * - Key: 수주품종구분, 주문용도지정코드
 * 5. 합성항목처리
 * - 인수도별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전값을 변경하지 않는다.
 * - 결함특기 항목은 결함튿기함성항목의 이전 값과 주문용도기준으로 편성한
 * 값을 비교하여 동일한 결함특기를 제외하고 5개를 재편성
 * (5개 선정시 이전 합성 항목값을 우선으로 선정)
 * 6. 편성한 결과는 PosContext에 등록
 * 7. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchDeliSpec">
 * <transition name="success" value="SUBSERVICE1" />
 * <transition name="failure" value="ERROR_LOG" />
 * <property name="dao" value="m00dao" />
 * <property name="bind-result" value="RK_MAIN" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * bind-result : 이전에 ctx에 저장된 result
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchDeliSpec extends PosActivity implements C10NuiConstantsIF
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
        String prodSpecKind = this.getProperty( C10PN_PROSPECKIND ).trim();
        ctx.put( COL_QLT_DSN_SPC_TP, prodSpecKind );
        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );
        PosDecisionChecker checker = null;
        PosRuleVO result = null;
        PosCalcVO posCalcVO;
        PosRowSet rowset = null;
        PosRow row = null;
        PosColumnDef[] pcd = null;

        String cname = null;
        Object data = null;
        String colValue[] = null; // 컬럼값

        PosParameter param = new PosParameter(); // MD View param

        String spc_avr = C10STR_SPACE;
        String spc_yr = C10STR_SPACE;
        String cus_bth_pap_no = C10STR_SPACE;
        String ord_thk_mng_cd = C10STR_SPACE;
        String ord_wth_mng_cd = C10STR_SPACE;
        String ord_lth_mng_cd = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String prd_shp = C10STR_SPACE;
        String acrt_rt_spc = C10STR_SPACE;
        String ord_edg_asg_tp = C10STR_SPACE;
        String ord_exc_thk = C10STR_SPACE;
        String ord_exc_wth = C10STR_SPACE;
        String ord_exc_lth = C10STR_SPACE;

        // 고객인수도사양
        if ( prodSpecKind.equals( NUM1 ) )
        {
            cus_bth_pap_no = (String) ctx.get( COL_CUS_BTH_PAP_NO );
            if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_THK_MNG_CD ) ) )
                ord_thk_mng_cd = (String) ctx.get( COL_ORD_THK_MNG_CD );
            if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_WTH_MNG_CD ) ) )
                ord_wth_mng_cd = (String) ctx.get( COL_ORD_WTH_MNG_CD );
            if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_LTH_MNG_CD ) ) )
                ord_lth_mng_cd = (String) ctx.get( COL_ORD_LTH_MNG_CD );
            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
            prd_shp = (String) ctx.get( COL_PRD_SHP );
            acrt_rt_spc = (String) ctx.get( COL_ACPT_RT_SPC );
            ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
                ord_exc_thk = ctx.get( COL_ORD_EXC_THK ).toString();
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
                ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_LTH ) ) )
                ord_exc_lth = ctx.get( COL_ORD_EXC_LTH ).toString();

            // 최초주문입력값 설정
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_THK_TLN_LLV ) ) )
                ctx.put( COL_THK_TLN_LLV, (String) ctx.get( COL_ORD_THK_TLN_LLV ).toString() );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_THK_TLN_ULV ) ) )
                ctx.put( COL_THK_TLN_ULV, (String) ctx.get( COL_ORD_THK_TLN_ULV ).toString() );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_WTH_TLN_LLV ) ) )
                ctx.put( COL_WTH_TLN_LLV, (String) ctx.get( COL_ORD_WTH_TLN_LLV ).toString() );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_WTH_TLN_ULV ) ) )
                ctx.put( COL_WTH_TLN_ULV, (String) ctx.get( COL_ORD_WTH_TLN_ULV ).toString() );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_LTH_TLN_LLV ) ) )
                ctx.put( COL_LTH_TLN_LLV, (String) ctx.get( COL_ORD_LTH_TLN_LLV ).toString() );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_LTH_TLN_ULV ) ) )
                ctx.put( COL_LTH_TLN_ULV, (String) ctx.get( COL_ORD_LTH_TLN_ULV ).toString() );

            if ( !DbCommonUtil.isNull( ctx.get( COL_CUS_BTH_PAP_NO ) ) )
            {
            	logger.logDebug( "고객사양번호 근데 여기를 왜타?     : " + cus_bth_pap_no );
            	param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, cus_bth_pap_no );
                rowset = dao.find( VI_M00_C10A1023, param ); // 고객인수도View.select

                if ( rowset.count() != 0 )
                {
                    row = rowset.next();

                    pcd = rowset.getColumnDefs(); // 칼럼정보
                    
                    ord_thk_mng_cd = C10STR_SPACE; // 강제로 값을 조정함(NULL값)
                    ord_wth_mng_cd = C10STR_SPACE;
                    ord_lth_mng_cd = C10STR_SPACE;

                    for ( int i = 0; i < pcd.length; i++ )
                    {
                        cname = pcd[i].getName();
                        data = row.getAttribute( cname );

                        if ( cname.equals( COL_THK_TLN_LLV ) || cname.equals( COL_THK_TLN_ULV ) )
                        {
                            // 주문두께관리코드가 NULL인 경우엔 고객인수도 Master Data를 적용
                            if ( ord_thk_mng_cd.equals( C10STR_SPACE ) )
                            {
                                ctx.put( cname, data );
                                logger.logDebug( cname + C10STR_COLON + data );
                            }
                        } else if ( cname.equals( COL_WTH_TLN_LLV ) || cname.equals( COL_WTH_TLN_ULV ) )
                        {
                            // 주문폭관리코드가 NULL인 경우엔 고객인수도 Master Data를 적용
                            if ( ord_wth_mng_cd.equals( C10STR_SPACE ) )
                            {
                                ctx.put( cname, data );
                                logger.logDebug( cname + C10STR_COLON + data );
                            }
                        } else if ( cname.equals( COL_LTH_TLN_LLV ) || cname.equals( COL_LTH_TLN_ULV ) )
                        {
                            // 주문길이관리코드가 NULL인 경우엔 고객인수도 Master Data를 적용
                            if ( ord_lth_mng_cd.equals( C10STR_SPACE ) )
                            {
                                ctx.put( cname, data );
                                logger.logDebug( cname + C10STR_COLON + data );
                            }
                        } else
                        {
                            ctx.put( cname, data );
                            logger.logDebug( cname + C10STR_COLON + data );
                        }
                    }
                } else if ( rowset.count() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS18 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R114 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    // ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS08 );
                    // ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    // logger.logError( ERRMSG_R110 );
                    // return PosBizControlConstants.FAILURE;
                }

            }
            if ( ( ord_thk_mng_cd.equals( C10STR_SPACE ) || ord_thk_mng_cd.equals( C10STR_Z ) ) && 
                    ( ord_wth_mng_cd.equals( C10STR_SPACE ) || ord_wth_mng_cd.equals( C10STR_Z ) ) && 
                    ( ord_lth_mng_cd.equals( C10STR_SPACE ) || ord_lth_mng_cd.equals( C10STR_Z ) ) )
            {
                // 두께, 폭, 길이 관리코드가 NULL 또는 Z인경우
                return PosBizControlConstants.SUCCESS;
            }

            // 두께, 폭, 길이 관리코드중 하나이상이 NULL도아니고 Z도 아닌경우

            if ( ( !ord_thk_mng_cd.equals( C10STR_SPACE ) && !ord_thk_mng_cd.equals( C10STR_Z ) ) )
            {
                colValue = new String[7];
                colValue[0] = acrt_rt_spc;
                colValue[1] = prd_nm_cd;
                colValue[2] = prd_shp;
                colValue[3] = ord_edg_asg_tp;
                colValue[4] = ord_exc_thk;
                colValue[5] = ord_exc_wth;
                colValue[6] = ord_exc_lth;

                // 로깅시작
                logger.logDebug( "=== 규격인수도 기준 ===" );
                logger.logDebug( "조건값 - 인수도규격     : " + acrt_rt_spc );
                logger.logDebug( "조건값 - 품명           : " + prd_nm_cd );
                logger.logDebug( "조건값 - 제품형태       : " + prd_shp );
                logger.logDebug( "조건값 - 주문에지구분   : " + ord_edg_asg_tp );
                logger.logDebug( "조건값 - 주문두께       : " + ord_exc_thk );
                logger.logDebug( "조건값 - 주문폭         : " + ord_exc_wth );
                logger.logDebug( "조건값 - 주문길이       : " + ord_exc_lth );

                checker = EasyAccess.getPosDecisionChecker( C10B1013, null );
                result = null;
                try
                {
                    // 결과값 잘 가져오는지 확인
                    result = checker.getPosRule( colValue );
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS30 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.FAILURE;
                }

                if ( result != null && result.getRecordCount() == 1 )
                {
                    // 두께 관리 코드 적용
                    ArrayList arrayTest = new ArrayList();
                    arrayTest.add( new String[] { result.getRuleValueAt( COL_THK_TLN_LLV ) } );
                    arrayTest.add( new String[] { result.getRuleValueAt( COL_THK_TLN_ULV ) } );
                    arrayTest.add( new String[] { ord_thk_mng_cd } );
                    arrayTest.add( new String[] { C10STR_L } );
                    
                    logger.logDebug( "두께관리코드 : " + ord_thk_mng_cd );
                    logger.logDebug( "하한값 : " + result.getRuleValueAt( COL_THK_TLN_LLV ) );
                    
                    try
                    {
                        posCalcVO = EasyAccess.getPosCalc( C10B2180, arrayTest );
                    } catch ( MasterDataException e )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS05 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                        logger.logError( e.getMessage() );
                        return PosBizControlConstants.FAILURE;
                    }

                    ctx.put( COL_THK_TLN_LLV, posCalcVO.getResultValue() );
                    logger.logDebug( COL_THK_TLN_LLV + C10STR_COLON + posCalcVO.getResultValue() );
                    arrayTest = new ArrayList();
                    arrayTest.add( new String[] { result.getRuleValueAt( COL_THK_TLN_LLV ) } );
                    arrayTest.add( new String[] { result.getRuleValueAt( COL_THK_TLN_ULV ) } );
                    arrayTest.add( new String[] { ord_thk_mng_cd } );
                    arrayTest.add( new String[] { C10STR_BU } );
                    try
                    {
                        posCalcVO = EasyAccess.getPosCalc( C10B2180, arrayTest );
                    } catch ( MasterDataException e )
                    {
                        ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS05 );
                        ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                        logger.logError( e.getMessage() );
                        return PosBizControlConstants.FAILURE;
                    }

                    ctx.put( COL_THK_TLN_ULV, posCalcVO.getResultValue() );
                    logger.logDebug( COL_THK_TLN_ULV + C10STR_COLON + posCalcVO.getResultValue() );
                } else if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS21 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R117 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS30 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R113 );
                    return PosBizControlConstants.FAILURE;
                }
            }

            if ( ( !ord_wth_mng_cd.equals( C10STR_SPACE ) && !ord_wth_mng_cd.equals( C10STR_Z ) ) )
            {
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, ord_wth_mng_cd );
                rowset = dao.find( VI_M00_C10A2181, param ); // 폭공차View.select

                if ( rowset.count() == 1 )
                {
                    row = rowset.next();
                } else if ( rowset.count() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS19 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R115 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS09 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R111 );
                    return PosBizControlConstants.FAILURE;
                }

                if ( ( !ord_wth_mng_cd.equals( C10STR_SPACE ) && !ord_wth_mng_cd.equals( C10STR_Z ) ) )
                {
                    // 주문폭관리코드가 NULL이나 Z가 아닌 경우엔 규격인수도 Master Data를 적용
                    ctx.put( COL_WTH_TLN_LLV, row.getAttribute( COL_WTH_TLN_LLV ) );
                    ctx.put( COL_WTH_TLN_ULV, row.getAttribute( COL_WTH_TLN_ULV ) );
                    logger.logDebug( COL_WTH_TLN_ULV + C10STR_COLON + row.getAttribute( COL_WTH_TLN_LLV ) );
                    logger.logDebug( COL_WTH_TLN_ULV + C10STR_COLON + row.getAttribute( COL_WTH_TLN_ULV ) );
                }
            }

            if ( ( !ord_lth_mng_cd.equals( C10STR_SPACE ) && !ord_lth_mng_cd.equals( C10STR_Z ) ) )
            {
                param = new PosParameter(); // MD View param
                param.setWhereClauseParameter( 0, ord_lth_mng_cd );
                rowset = dao.find( VI_M00_C10A2182, param ); // 길이공차View.select

                if ( rowset.count() == 1 )
                {
                    row = rowset.next();
                } else if ( rowset.count() > 1 )
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS20 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R116 );
                    return PosBizControlConstants.FAILURE;
                } else
                {
                    ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS10 );
                    ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                    logger.logError( ERRMSG_R112 );
                    return PosBizControlConstants.FAILURE;
                }

                if ( ( !ord_wth_mng_cd.equals( C10STR_SPACE ) && !ord_wth_mng_cd.equals( C10STR_Z ) ) )
                {
                    // 주문폭관리코드가 NULL이나 Z가 아닌 경우엔 규격인수도 Master Data를 적용
                    ctx.put( COL_LTH_TLN_LLV, row.getAttribute( COL_LTH_TLN_LLV ) );
                    ctx.put( COL_LTH_TLN_ULV, row.getAttribute( COL_LTH_TLN_ULV ) );
                    logger.logDebug( COL_LTH_TLN_ULV + C10STR_COLON + row.getAttribute( COL_LTH_TLN_LLV ) );
                    logger.logDebug( COL_LTH_TLN_ULV + C10STR_COLON + row.getAttribute( COL_LTH_TLN_ULV ) );
                }
            }
            // 규격인수도사양
        } else if ( prodSpecKind.equals( NUM2 ) )
        {
        	logger.logDebug( "여기를 타야정상이지" );
            if ( !DbCommonUtil.isNull( ctx.get( COL_SPC_AVR ) ) )
                spc_avr = (String) ctx.get( COL_SPC_AVR );
            if ( !DbCommonUtil.isNull( ctx.get( COL_SPC_YR ) ) )
                spc_yr = (String) ctx.get( COL_SPC_YR );
            if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
                prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
            if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_SHP ) ) )
                prd_shp = (String) ctx.get( COL_PRD_SHP );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EDG_ASG_TP ) ) )
                ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
                ord_exc_thk = ctx.get( COL_ORD_EXC_THK ).toString();
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
                ord_exc_wth = ctx.get( COL_ORD_EXC_WTH ).toString();
            if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_LTH ) ) )
                ord_exc_lth = ctx.get( COL_ORD_EXC_LTH ).toString();

            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, spc_avr ); // (String)ctx.get(COL_SPC_AVR)
            param.setWhereClauseParameter( 1, spc_yr ); // (String)ctx.get(COL_SPC_YR)
            rowset = dao.find( VI_M00_C10A1010, param ); // 규격공통View.select

            if ( rowset.count() == 1 )
            {
                row = rowset.next();
            } else if ( rowset.count() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R140 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS01 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R139 );
                return PosBizControlConstants.FAILURE;
            }

            pcd = rowset.getColumnDefs(); // 칼럼정보

            for ( int i = 0; i < pcd.length; i++ )
            {
                cname = pcd[i].getName();
                data = row.getAttribute( cname );

                if ( !cname.equals( COL_SPC_AVR ) && 
                        !cname.equals( COL_SPC_YR ) && 
                        !cname.equals( COL_GRA ) && 
                        !cname.equals( COL_MDL_DEFINE_NM ) 
                        && !cname.equals( COL_MDL_DEFINE_EXPLAIN ) )
                {
                    ctx.put( cname, data );
                    logger.logDebug( cname + C10STR_COLON + data );
                } else if ( cname.equals( COL_GRA ) )
                {
                    ctx.put( COL_ORD_GRA, data );
                    logger.logDebug( COL_ORD_GRA + C10STR_COLON + data );
                }
                logger.logDebug( cname + C10STR_COLON + data );
            }

            colValue = new String[7];
            colValue[0] = (String) ctx.get( COL_ACPT_RT_SPC ); // 인수도규격
            colValue[1] = prd_nm_cd; // 품명코드
            colValue[2] = prd_shp; // 제품형태
            colValue[3] = ord_edg_asg_tp; // 주문Edge지정구분
            colValue[4] = ord_exc_thk; // 주문환산두께
            colValue[5] = ord_exc_wth; // 주문환산폭
            colValue[6] = ord_exc_lth; // 주문환산길이

            // 로깅시작
            logger.logDebug( "=== 규격인수도 기준 ===" );
            logger.logDebug( "조건값 - 인수도규격     : " + (String) ctx.get( COL_ACPT_RT_SPC ) );
            logger.logDebug( "조건값 - 품명           : " + prd_nm_cd );
            logger.logDebug( "조건값 - 제품형태       : " + prd_shp );
            logger.logDebug( "조건값 - 주문에지구분   : " + ord_edg_asg_tp );
            logger.logDebug( "조건값 - 주문두께       : " + ord_exc_thk );
            logger.logDebug( "조건값 - 주문폭         : " + ord_exc_wth );
            logger.logDebug( "조건값 - 주문길이       : " + ord_exc_lth );

            checker = EasyAccess.getPosDecisionChecker( C10B1013, null );
            try
            {
                // 결과값 잘 가져오는지 확인
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS30 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( result.getRecordCount() == 1 )
            {
                Iterator rtiter = result.itemNameRow.iterator();
                data = null;

                while ( rtiter.hasNext() )
                {
                    data = rtiter.next();
                    logger.logDebug( data.toString() + C10STR_COLON + result.getRuleValueAt( data.toString() ) );
                    ctx.put( data.toString(), result.getRuleValueAt( data.toString() ) );
                }
            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS21 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R117 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS30 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R113 );
                return PosBizControlConstants.FAILURE;
            }

        } else if ( prodSpecKind.equals( NUM4 ) )
        {
            PosRowSet rowset1 = null;
            PosRow row1 = null;
            PosRowSet rowset2 = null;
            PosRow row2 = null;

            // 고객사양 조회
            param = new PosParameter();
            param.setWhereClauseParameter( 0, (String) ctx.get( COL_ORD_NO ) );
            param.setWhereClauseParameter( 1, (String) ctx.get( COL_ORD_LN ) );
            param.setWhereClauseParameter( 2, NUM1 );
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset1 = dao.find( SELECT_DLV, param ); // 고객사양성분 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset1 = null;
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            cname = null;
            data = null;

            if ( rowset1.count() != 0 )
            {
                row1 = rowset1.next();
                pcd = rowset1.getColumnDefs(); // 칼럼정보

                for ( int i = 0; i < pcd.length; i++ )
                {
                    cname = pcd[i].getName();
                    data = row1.getAttribute( cname );

                    ctx.put( cname, data );
                    logger.logDebug( cname + C10STR_COLON + data );
                }
            }

            // 규격사양 조회
            param = new PosParameter();
            param.setWhereClauseParameter( 0, (String) ctx.get( COL_ORD_NO ) );
            param.setWhereClauseParameter( 1, (String) ctx.get( COL_ORD_LN ) );
            param.setWhereClauseParameter( 2, NUM2 );
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset2 = dao.find( SELECT_DLV, param ); // 규격사양성분 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset2 = null;
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( rowset2.count() != 0 )
            {
                row2 = rowset2.next();

            } else
            {
                // 규격사양이 없는 경우 에러
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS24 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }

            pcd = rowset2.getColumnDefs(); // 칼럼정보

            for ( int i = 0; i < pcd.length; i++ )
            {
                cname = pcd[i].getName();
                data = row2.getAttribute( cname );
                // 보증사양 편집
                if ( cname.equals( COL_THK_TLN_LLV ) || cname.equals( COL_THK_TLN_ULV ) )
                {
                    // 두께공차의 경우 상하한값 둘다 없으면 규격사양 적용
                    if ( DbCommonUtil.isNull( ctx.get( COL_THK_TLN_LLV ) ) && 
                            DbCommonUtil.isNull( ctx.get( COL_THK_TLN_ULV ) ) )
                    {
                        ctx.put( COL_THK_TLN_LLV, 
                                DbCommonUtil.numCompare( ctx.get( COL_THK_TLN_LLV ), 
                                        row2.getAttribute( COL_THK_TLN_LLV ), true ) );
                        ctx.put( COL_THK_TLN_ULV, 
                                DbCommonUtil.numCompare( ctx.get( COL_THK_TLN_ULV ), 
                                        row2.getAttribute( COL_THK_TLN_ULV ), true ) );
                    }
                    logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                } else if ( cname.equals( COL_WTH_TLN_LLV ) || cname.equals( COL_WTH_TLN_ULV ) )
                {
                	logger.logDebug("PRD_NM_CD : " +ctx.get( COL_PRD_NM_CD ));
                	// 20240613 김재용 차장 요청, 품명 E,C,D의 경우 보증사양 인수도 폭공차는 고객사양과 규격사양중 더 작은 값이 보증사양이 될 수 있도록 변경
                	if(ctx.get( COL_PRD_NM_CD ).equals("E") || ctx.get( COL_PRD_NM_CD ).equals("C") || ctx.get( COL_PRD_NM_CD ).equals("D")){
                		
                		// 하한값은 기존과 동일하게 적용 
                		ctx.put( COL_WTH_TLN_LLV, 
                                DbCommonUtil.numCompare( ctx.get( COL_WTH_TLN_LLV ), 
                                        row2.getAttribute( COL_WTH_TLN_LLV ), true ) );
                		// 상한값은 고객사양과 규격사양중 더 작은 값이 보증사양이 되도록 변경                		                		
                        double num1 = Double.parseDouble(ctx.get( COL_WTH_TLN_ULV ).toString());
                        double num2 = Double.parseDouble(row2.getAttribute( COL_WTH_TLN_ULV ).toString());                                                                      
                        double lowerNum = Math.min(num1, num2);
                        String lowerStr = String.valueOf(lowerNum);                		
                		
                        ctx.put( COL_WTH_TLN_ULV, lowerStr);            
                        logger.logDebug("품명 E,C,D일 경우 폭공차 상한값은 더 작은 값으로 : "+lowerStr);
                	}else{
                		
                		// 폭공차의 경우 상하한값 둘다 없으면 규격사양 적용
                        if ( DbCommonUtil.isNull( ctx.get( COL_WTH_TLN_LLV ) ) && 
                                DbCommonUtil.isNull( ctx.get( COL_WTH_TLN_ULV ) ) )
                        {
                            ctx.put( COL_WTH_TLN_LLV, 
                                    DbCommonUtil.numCompare( ctx.get( COL_WTH_TLN_LLV ), 
                                            row2.getAttribute( COL_WTH_TLN_LLV ), true ) );
                            ctx.put( COL_WTH_TLN_ULV, 
                                    DbCommonUtil.numCompare( ctx.get( COL_WTH_TLN_ULV ), 
                                            row2.getAttribute( COL_WTH_TLN_ULV ), true ) );
                        }                		
                		                		
                	}                    
                    logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                } else if ( cname.equals( COL_LTH_TLN_LLV ) || cname.equals( COL_LTH_TLN_ULV ) )
                {
                    // 길이공차의 경우 상하한값 둘다 없으면 규격사양 적용
                    if ( DbCommonUtil.isNull( ctx.get( COL_LTH_TLN_LLV ) ) && 
                            DbCommonUtil.isNull( ctx.get( COL_LTH_TLN_ULV ) ) )
                    {
                        ctx.put( COL_LTH_TLN_LLV, 
                                DbCommonUtil.numCompare( ctx.get( COL_LTH_TLN_LLV ), 
                                        row2.getAttribute( COL_LTH_TLN_LLV ), true ) );
                        ctx.put( COL_LTH_TLN_ULV, 
                                DbCommonUtil.numCompare( ctx.get( COL_LTH_TLN_ULV ), 
                                        row2.getAttribute( COL_LTH_TLN_ULV ), true ) );
                    }
                    logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                } else
                {
                    // 고객사양이 없으면 규격사양으로 적용
                    if ( DbCommonUtil.isNull( ctx.get( cname ) ) )
                    {
                        ctx.put( cname, data );
                    }
                    logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                }
            }

        }

        return PosBizControlConstants.SUCCESS;
    }
}