/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchMechData.java
 * Change history
 * Change history
 * @LastModifyDate : 2011. 12. 16
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 16 김종범 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

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
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 Class 는 Master Data의 재질사양기준을 읽어 재질사양을 편성하는 Class이다.
 * <xmp>
 * 1. 편성정보: 재질사양
 * - Master Table Code: 규격재질 (C10B1012)
 * - Key: 제품사양설계종류('2'), 규격약호, 규격년도, 주문두께
 * 2. 고객재질사양
 * - Master Table Code: C10A1022
 * - Master View Table : m00apuser.VI_M00_C10A1022
 * - Key: 제품사양설계종류('1'), 고객사양번호
 * 3. 사내재질사양
 * - Master Table Code: 사내재질 (C10B1032)
 * - Key: 제품사양설계종류('3'), 재질코드, 주문두께
 * 4. 편성한 결과는 PosContext에 등록
 * 5. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchMechData">
 * <transition name="success" value="SUBSERVICE1" />
 * <transition name="failure" value="ERROR_LOG" />
 * <property name="dao" value="masterdao" />
 * <property name="prodSpecKind" value="2" />
 * <property name="bind-result" value="RK_MAIN" />
 * </activity>
 * Property 설정
 * bind-list : SETPARAM에서 셋팅된 ArrayList
 * dao : applicationContext.xml의 DAO id
 * prodSpecKind : 제품사양설계종류
 * bind-result: 이전 Activity에서 저장된 PosRowset
 * </xmp>
 * 
 * @author 김종범
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchMechData extends PosActivity implements C10NuiConstantsIF
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

        // 1. 편성정보: 재질사양
        // - Master Table Code: 열연재질_인장시험(C10B0010)
        // ~ 열연재질_청정도시험(C10B0027)
        // - Key: 수주품종, 제품사양설계종류, 고객사사양번호, 주문두께
        // . 제품사양설계종류: 고객('1'), 규격(‘2’), 사내(‘3’)

        String prodSpecKind = this.getProperty( C10PN_PROSPECKIND ).trim();
        ctx.put( COL_QLT_DSN_SPC_TP, prodSpecKind );
        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );

        String colValue[] = null; // 컬럼값

        PosParameter param = new PosParameter(); // MD View param

        String cus_bth_pap_no = C10STR_SPACE;
        String spc_avr = C10STR_SPACE;
        String spc_yr = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String mql_cd = C10STR_SPACE;
        String ord_exc_thk = C10STR_SPACE;

        // 고객재질사양
        if ( prodSpecKind.equals( NUM1 ) )
        {

            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_CUS_BTH_PAP_NO ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }

            cus_bth_pap_no = (String) ctx.get( COL_CUS_BTH_PAP_NO );

            colValue = new String[1];
            colValue[0] = cus_bth_pap_no;

            PosRowSet rowset1 = null;
            PosRow row1 = null;

            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, colValue[0] );
            rowset1 = dao.find( VI_M00_C10A1022, param ); // 고객재질View.select

            if ( rowset1.count() == 1 )
            {
                row1 = rowset1.next();

            } else if ( rowset1.count() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            } else
            {

                // ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC02 );
                // ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                // logger.logError( ERRMSG_R01 );
                // return PosBizControlConstants.FAILURE;

                return PosBizControlConstants.FALSE;
            }
            String cname = null;
            Object data = null;
            PosColumnDef[] pcd = rowset1.getColumnDefs(); // 칼럼정보

            for ( int i = 0; i < pcd.length; i++ )
            {
                cname = pcd[i].getName();
                data = row1.getAttribute( cname );

                // if(!cname.equals(COL_MQL_CD) && !cname.equals(COL_SPC_AVR) && !cname.equals(COL_CUS_BTH_PAP_NO)){
                ctx.put( cname, data );
                // logger.logDebug(cname + "  :  " + data);
                // }
            }

            // 규격재질사양
        } else if ( prodSpecKind.equals( NUM2 ) )
        {

            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_SPC_AVR ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_SPC_YR ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }

            spc_avr = (String) ctx.get( COL_SPC_AVR );
            spc_yr = (String) ctx.get( COL_SPC_YR );
            ord_exc_thk = (String) ctx.get( COL_ORD_EXC_THK ).toString();

            colValue = new String[3];
            colValue[0] = spc_avr;
            colValue[1] = spc_yr;
            colValue[2] = ord_exc_thk;

            PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B1012, null );
            PosRuleVO result2 = null;
            try
            {
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS03 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R02 );
                return PosBizControlConstants.FAILURE;
            }

            if ( result2.getRecordCount() == 1 )
            {
                Iterator rtiter = result2.itemNameRow.iterator();
                Object data = null;

                while ( rtiter.hasNext() )
                {
                    data = rtiter.next();
                    logger.logDebug( data.toString() + C10STR_COLON + result2.getRuleValueAt( data.toString() ) );
                    ctx.put( data.toString(), result2.getRuleValueAt( data.toString() ) );
                }
            } else if ( result2.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS03 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R02 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS03 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R02 );
                return PosBizControlConstants.FAILURE;
            }

            // 사내재질사양
        } else if ( prodSpecKind.equals( NUM3 ) )
        {

            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) 
                    || DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) 
                    || DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) 
                    || DbCommonUtil.isNull( ctx.get( COL_MQL_CD ) ) 
                    || DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KN02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R02 );
                return PosBizControlConstants.FAILURE;
            }
            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
            mql_cd = (String) ctx.get( COL_MQL_CD );
            ord_exc_thk = (String) ctx.get( COL_ORD_EXC_THK ).toString();

            colValue = new String[3];

            colValue[0] = prd_nm_cd; // 품명코드
            colValue[1] = mql_cd; // 재질코드
            colValue[2] = ord_exc_thk; // 주문환산두께

            PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B1032, null );
            PosRuleVO result2 = null;
            try
            {
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KN02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R02 );
                return PosBizControlConstants.FAILURE;
            }

            if ( result2.getRecordCount() == 1 )
            {
                Iterator rtiter = result2.itemNameRow.iterator();
                Object data = null;

                while ( rtiter.hasNext() )
                {
                    data = rtiter.next();
                    ctx.put( data.toString(), result2.getRuleValueAt( data.toString() ) );
                }
            } else if ( result2.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KN12 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R02 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KN02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R02 );
                return PosBizControlConstants.FAILURE;
            }
            // 보증사양
        } else if ( prodSpecKind.equals( NUM4 ) )
        {

            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) 
                    || DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }

            PosRowSet rowset1 = null;
            PosRow row1 = null;
            PosRowSet rowset2 = null;
            PosRow row2 = null;
            PosRowSet rowset3 = null;
            PosRow row3 = null;

            // 고객사양 조회
            param = new PosParameter();
            param.setWhereClauseParameter( 0, (String) ctx.get( COL_ORD_NO ) );
            param.setWhereClauseParameter( 1, (String) ctx.get( COL_ORD_LN ) );
            param.setWhereClauseParameter( 2, NUM1 );
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset1 = dao.find( SELECT_MQL, param ); // 고객사양성분 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset1 = null;
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            String cname = null;
            Object data = null;
            PosColumnDef[] pcd;

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
                rowset2 = dao.find( SELECT_MQL, param ); // 규격사양성분 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset2 = null;
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( rowset2.count() != 0 )
            {
                row2 = rowset2.next();

            } else
            {
                // 규격사양이 없는 경우 에러
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS23 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }

            pcd = rowset2.getColumnDefs(); // 칼럼정보

            for ( int i = 0; i < pcd.length; i++ )
            {
                cname = pcd[i].getName();
                data = row2.getAttribute( cname );
                // 보증사양 편집
                if ( cname.equals( COL_TS_LLV_MPA ) || 
                        cname.equals( COL_YP_LLV_MPA ) || 
                        cname.equals( COL_ELGN_LLV ) || 
                        cname.equals( COL_HRB_LLV ) || 
                        cname.equals( COL_ER_LLV ) || 
                        cname.equals( COL_TST_GW_FRN_LLV ) || 
                        cname.equals( COL_TST_GW_BAK_LLV ) || 
                        cname.equals( COL_TST_GW_TOT_LLV ) )
                {
                    // 하한값은 큰값을 적용
                    ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, true ) );
                    logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                } else if ( cname.equals( COL_TS_ULV_MPA ) || 
                        cname.equals( COL_YP_ULV_MPA ) || 
                        cname.equals( COL_ELGN_ULV ) || 
                        cname.equals( COL_HRB_ULV ) || 
                        cname.equals( COL_ER_ULV ) || 
                        cname.equals( COL_TST_GW_FRN_ULV ) || 
                        cname.equals( COL_TST_GW_BAK_ULV ) || 
                        cname.equals( COL_TST_GW_TOT_ULV ) )
                {
                    // 상한값은 NULL이나 0을 제외한 작은값을 적용
                    ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, false ) );
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
            
            // 사내사양 조회
            param = new PosParameter();
            param.setWhereClauseParameter( 0, (String) ctx.get( COL_ORD_NO ) );
            param.setWhereClauseParameter( 1, (String) ctx.get( COL_ORD_LN ) );
            param.setWhereClauseParameter( 2, NUM3 );
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset3 = dao.find( SELECT_MQL, param ); // 사내사양재질 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset3 = null;
                ctx.put( C10STR_P_ERR_KEY, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.FAILURE;
            }

            if ( rowset3.count() != 0 )
            {
                row3 = rowset3.next();
                pcd = rowset3.getColumnDefs(); // 칼럼정보

                for ( int i = 0; i < pcd.length; i++ )
                {
                    cname = pcd[i].getName();
                    data = row3.getAttribute( cname );
                    // 보증사양 편집
                    if ( cname.equals( COL_TS_LLV_MPA ) || 
                            cname.equals( COL_YP_LLV_MPA ) || 
                            cname.equals( COL_ELGN_LLV ) || 
                            cname.equals( COL_HRB_LLV ) || 
                            cname.equals( COL_ER_LLV ) || 
                            cname.equals( COL_TST_GW_FRN_LLV ) || 
                            cname.equals( COL_TST_GW_BAK_LLV ) || 
                            cname.equals( COL_TST_GW_TOT_LLV ) )
                    {
                        // 하한값은 큰값을 적용
                        ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, true ) );
                        logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                    } else if ( cname.equals( COL_TS_ULV_MPA ) || 
                            cname.equals( COL_YP_ULV_MPA ) || 
                            cname.equals( COL_ELGN_ULV ) || 
                            cname.equals( COL_HRB_ULV ) || 
                            cname.equals( COL_ER_ULV ) || 
                            cname.equals( COL_TST_GW_FRN_ULV ) || 
                            cname.equals( COL_TST_GW_BAK_ULV ) || 
                            cname.equals( COL_TST_GW_TOT_ULV ) )
                    {
                        // 상한값은 NULL이나 0을 제외한 작은값을 적용
                        ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, false ) );
                        logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                    } else
                    {
                        // 사내사양이 없으면 규격사양으로 적용
                        if ( DbCommonUtil.isNull( ctx.get( cname ) ) )
                        {
                            ctx.put( cname, data );
                        }
                        logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                    }
                }

            } 

            
        }
        return PosBizControlConstants.SUCCESS;
    }
}
