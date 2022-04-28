/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchChemData.java
 * Change history
 * @LastModifyDate : 2011. 12. 09
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 09 김종범 최초 생성
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
 * 이 class는 성분사양을 편성하는 class이다.
 * <xmp>
 * 1. 편성정보: 성분사양
 * 	- 규격성분 & 사내성분 : EasyAccess를 통한 판단구조 데이타 결과값 도출
 * 	- 고객성분 : Master Table: View 이용하여 성분 편성
 *	- 보증성분 : 고객, 규격, 사내사양을 비교하여 편성한다.
 *   - 하한값 : 고객, 규격, 사내사양을 비교하여 가장 높은수치으로 편성
 *   - 상한값 : 고객, 규격, 사내사양을 비교하여 가장 낮은수치으로 편성
 * . View 명: m00apuser.VI_M00_C10A1021
 * . Key: 고객사사양번호
 * - 품질설계사양구분: 고객('1'), 규격(‘2’), 사내(‘3’), 보증(‘3’)
 * 2. PosContext에 합성항목과 품질보증구분항목 편집
 * - 합성항목 편집
 * . 성분별로 합성항목은 이전 값이 존재하지 않으면 값을 등록하고,
 * 값이 존재하면 이전 값을 변경하지 않는다.
 * 3. 편성한 결과는 PosContext에 등록
 * 4. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchChemData">
 * <transition name="success" value="C102100030-service" />
 * <property name="prodSpecKind" value="1" />
 * <property name="dao" value="masterdao" />
 * <property name="bind-result" value="RK_MAIN" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * bind-result: 이전 Activity에서 조회된 PosRowset
 * prodSpecKind: 품질설계사양구분
 * resultkey : Query 결과를 ctx에 저장할 Key
 * </xmp>
 * 
 * @author 김종범
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchChemData extends PosActivity implements C10NuiConstantsIF
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

        String colValue[] = null; // 컬럼값

        PosParameter param = new PosParameter(); // MD View param

        String cus_bth_pap_no = C10STR_SPACE;
        String SPC_AVR = C10STR_SPACE;
        String SPC_YR = C10STR_SPACE;
        String mql_cd = C10STR_SPACE;
        String prd_nm_cd = C10STR_SPACE;
        String ord_exc_thk = C10STR_SPACE;

        // 고객성분사양
        if ( prodSpecKind.equals( NUM1 ) )
        {

            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) || DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) )
            		|| DbCommonUtil.isNull( ctx.get( COL_CUS_BTH_PAP_NO ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
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
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset1 = dao.find( VI_M00_C10A1021, param ); // 고객성분View.select
            } catch ( MasterDataException e )
            {
                rowset1 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R96 );
            }

            if ( rowset1.count() == 1 )
            {
                row1 = rowset1.next();

            } else if ( rowset1.count() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R97 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                // ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KC02 );
                // ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                // logger.logError( ERRMSG_R96 );
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

                ctx.put( cname, data );
                logger.logDebug( cname + C10STR_COLON + data );
            }

            // 규격성분사양
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
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R00 );
                return PosBizControlConstants.FAILURE;
            }

            SPC_AVR = (String) ctx.get( COL_SPC_AVR );
            SPC_YR = (String) ctx.get( COL_SPC_YR );
            ord_exc_thk = (String) ctx.get( COL_ORD_EXC_THK ).toString();

            colValue = new String[3];
            colValue[0] = SPC_AVR;
            colValue[1] = SPC_YR;
            colValue[2] = ord_exc_thk;

            PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B1011, null );
            PosRuleVO result2 = null;
            try
            {
                // 결과값 잘 가져오는지 확인
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R00 );
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
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS12 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R00 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS02 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R00 );
                return PosBizControlConstants.FAILURE;
            }

            // 사내성분사양
        } else if ( prodSpecKind.equals( NUM3 ) )
        {

            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_MQL_CD ) ) || 
                    DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }

            prd_nm_cd = (String) ctx.get( COL_PRD_NM_CD );
            mql_cd = (String) ctx.get( COL_MQL_CD );
            ord_exc_thk = (String) ctx.get( COL_ORD_EXC_THK ).toString();

            colValue = new String[3];
            colValue[0] = prd_nm_cd; // 품명코드
            colValue[1] = mql_cd; // 재질코드
            colValue[2] = ord_exc_thk; // 주문환산두께
            
            logger.logDebug( "=== 사내성분사양(C10B1031) ===");
            logger.logDebug( "품명코드        : " + colValue[0]);
            logger.logDebug( "재질코드        : " + colValue[1]);
            logger.logDebug( "주문환산두께  : " + colValue[2]);


            PosDecisionChecker checker = EasyAccess.getPosDecisionChecker( C10B1031, null );
            PosRuleVO result2 = null;
            try
            {
                result2 = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result2 = null;
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R01 );
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
                    logger.logDebug( data.toString() + C10STR_COLON + result2.getRuleValueAt( data.toString() ) );
                }
            } else if ( result2.getRecordCount() > 1 )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KN11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            } else
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KN01 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
                logger.logError( ERRMSG_R01 );
                return PosBizControlConstants.FAILURE;
            }
            // 보증성분사양
        } else if ( prodSpecKind.equals( NUM4 ) )
        {

            // Parameter Error Check True=Null, FALE=NotNull
            if ( DbCommonUtil.isNull( ctx.get( COL_ORD_NO ) ) || DbCommonUtil.isNull( ctx.get( COL_ORD_LN ) ) )
            {
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS11 );
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
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
                rowset1 = dao.find( SELECT_CHM, param ); // 고객사양성분 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset1 = null;
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
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
                rowset2 = dao.find( SELECT_CHM, param ); // 규격사양성분 select
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
                ctx.put( COL_QLT_DSN_ERR_CD, ERRCD_KS22 );
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
                if ( cname.equals( COL_C_LLV ) || 
                        cname.equals( COL_SI_LLV ) || 
                        cname.equals( COL_MN_LLV ) || 
                        cname.equals( COL_P_LLV ) || 
                        cname.equals( COL_S_LLV ) || 
                        cname.equals( COL_CR_LLV ) || 
                        cname.equals( COL_NI_LLV ) || 
                        cname.equals( COL_CU_LLV ) || 
                        cname.equals( COL_AL_LLV ) || 
                        cname.equals( COL_TI_LLV ) || 
                        cname.equals( COL_NB_LLV ) || 
                        cname.equals( COL_V_LLV ) || 
                        cname.equals( COL_N_LLV ) )
                {
                    // 하한값은 큰값을 적용
                    ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, true ) );
                    logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                } else if ( cname.equals( COL_C_ULV ) || 
                        cname.equals( COL_SI_ULV ) || 
                        cname.equals( COL_MN_ULV ) || 
                        cname.equals( COL_P_ULV ) || 
                        cname.equals( COL_S_ULV ) || 
                        cname.equals( COL_CR_ULV ) || 
                        cname.equals( COL_NI_ULV ) || 
                        cname.equals( COL_CU_ULV ) || 
                        cname.equals( COL_AL_ULV ) || 
                        cname.equals( COL_TI_ULV ) || 
                        cname.equals( COL_NB_ULV ) || 
                        cname.equals( COL_V_ULV ) || 
                        cname.equals( COL_N_ULV ) )
                {
                    // 상한값은 NULL이나 0을 제외한 작은값을 적용
                    ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, false ) );
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
                rowset3 = dao.find( SELECT_CHM, param ); // 규격사양성분 select
            } catch ( Exception e )
            {
                // 조회 시 에러인 경우
                rowset3 = null;
                ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
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
                    if ( cname.equals( COL_C_LLV ) || 
                            cname.equals( COL_SI_LLV ) || 
                            cname.equals( COL_MN_LLV ) || 
                            cname.equals( COL_P_LLV ) || 
                            cname.equals( COL_S_LLV ) || 
                            cname.equals( COL_CR_LLV ) || 
                            cname.equals( COL_NI_LLV ) || 
                            cname.equals( COL_CU_LLV ) || 
                            cname.equals( COL_AL_LLV ) || 
                            cname.equals( COL_TI_LLV ) || 
                            cname.equals( COL_NB_LLV ) || 
                            cname.equals( COL_V_LLV ) || 
                            cname.equals( COL_N_LLV ) )
                    {
                        // 하한값은 큰값을 적용
                        ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, true ) );
                        logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                    } else if ( cname.equals( COL_C_ULV ) || 
                            cname.equals( COL_SI_ULV ) || 
                            cname.equals( COL_MN_ULV ) || 
                            cname.equals( COL_P_ULV ) || 
                            cname.equals( COL_S_ULV ) || 
                            cname.equals( COL_CR_ULV ) || 
                            cname.equals( COL_NI_ULV ) || 
                            cname.equals( COL_CU_ULV ) || 
                            cname.equals( COL_AL_ULV ) || 
                            cname.equals( COL_TI_ULV ) || 
                            cname.equals( COL_NB_ULV ) || 
                            cname.equals( COL_V_ULV ) || 
                            cname.equals( COL_N_ULV ) )
                    {
                        // 상한값은 NULL이나 0을 제외한 작은값을 적용
                        ctx.put( cname, DbCommonUtil.numCompare( ctx.get( cname ), data, false ) );
                        logger.logDebug( cname + C10STR_COLON + ctx.get( cname ) );
                    }
                }

            } 

            
        }

        /*
         * String listColumn = null;
         * String mixCoulmn = null;
         * String value = null;
         * Iterator iter = list.iterator();
         * while(iter.hasNext()){
         * listColumn = (String)iter.next();
         * if(!listColumn.startsWith(C10STR_MIX)){
         * mixCoulmn = C10STR_MIX + listColumn;
         * value = DbCommonUtil.valueOf(ctx.get(listColumn));
         * //정보가 존재하면 등록
         * if(ActivityUtil.isValidData(value)){
         * //합성항목에 값이 존재하면 skip 합성항목에 값이 존재하지 않으면 등록
         * if(!ActivityUtil.isValidData(DbCommonUtil.valueOf(ctx.get(mixCoulmn)))){
         * ctx.put(mixCoulmn, ctx.get(listColumn));
         * }
         * }
         * }
         * }
         */

        return PosBizControlConstants.SUCCESS;
    }
}
