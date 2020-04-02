/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C10UiCheckActivity.java
 * Change history
 * @LastModifyDate : 2011. 12. 09
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2011. 12. 09 박재영 최초 생성
 * ==============================================================================
 */

package com.unionsteel.mes.c10.activity.ui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;

/**
 * C10UiCheckActivity Class는 화면에서 설정된 설계확정 대상의 <br>
 * 설계상태가 확정대기 상태인지를 데이터베이스를 조회하여 확인하는 <br>
 * Class이다.
 * <xmp>
 * 1. 서비스간 정보 Interface를 위해 PosContext에 항목변수를 관리한다.
 * - 처리 서비스가 Batch job임을 구분(BATCH_JOB=true)
 * - 처리대상 주문 행번 건수를 관리
 * . 처리 건수관리 변수의 값이 null인 경우 이전 서비스의 Result set건수를 읽어 값을 Setting
 * 2. 처리대상 항목을 저장변수에 등록한다.
 * 3. 후속 서비스에서 사용하는 변수를 초기화하여 등록한다.
 * . 오류 logging변수 Space처리
 * 4. 처리대상 주문 행번 건수를 1건 차감한다.
 * 사용 방법
 * <activity name="상태확인" class="com.unionsteel.mes.c10.activity.ui.C10UiCheckActivity">
 * <transition name="success" value="설계확정" />
 * <transition name="failure" value="end" />
 * </activity>
 * Property 설정
 * sqlkey : query.xml의 query id
 * dao : applicationContext.xml의 DAO id
 * resultkey : Query 결과를 ctx에 저장할 Key
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class C10UiCheckActivity extends PosActivity
{

    /**
     * <p>
     * 이 메소드는 PosActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다. 
     * property의 값 또는 PosContext의 input, output값은 Class JavaDoc에 작성하며
     * runActivity에서는 아래의 Tag와 관련된 내용을 작성한다. 
     * 예를 들어 @throws, @param, @return에 대해 더 상세히 기술하거나 예제를 추가할 필요가 있을 때 작성한다.
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
        PosGenericDao mesdao = this.getDao( C10ConstantsIF.MESDAO );
        PosGenericDao eaidao = this.getDao( C10ConstantsIF.EAIDAO );
        PosParameter param = new PosParameter();

        Object oServiceId = ctx.get( C10ConstantsIF.SERVICE_NAME );
        logger.logDebug( C10ConstantsIF.LOG_KIHO + C10ConstantsIF.SPACE4 + 
                C10ConstantsIF.C10UiCheckActivityName + 
                C10ConstantsIF.SPACE4 + C10ConstantsIF.Start + 
                C10ConstantsIF.SPACE4 + C10ConstantsIF.LOG_KIHO );
        try
        {
            if ( oServiceId.equals( C10ConstantsIF.C104000050_SERVICE ) )
            { // 작업지시변경저장 coil
                logger.logDebug( C10ConstantsIF.NEW_LINE + 
                        C10ConstantsIF.CTX + C10ConstantsIF.LOG_NOTI + ctx );

                String[] ids = (String[]) ctx.get( C10ConstantsIF.IDS );
                PosRowSet rowset = null;

                if ( ids == null || ids.length < 1 )
                    return PosBizControlConstants.FAILURE;

                String[] idsValue = ids[0].split( C10ConstantsIF.COMMA );
                String[] ORD_NO;
                String[] ORD_LN;
                String sORD_NO;
                String sORD_LN;
                int nRELULT = 0;

                for ( int i = 0, n = idsValue.length; i < n; i++ )
                {
                    ORD_NO = (String[]) ctx.get( idsValue[i] + 
                            C10ConstantsIF.UNDERBAR + C10ConstantsIF.ORD_NO );
                    ORD_LN = (String[]) ctx.get( idsValue[i] + 
                            C10ConstantsIF.UNDERBAR + C10ConstantsIF.ORD_LN );

                    sORD_NO = ORD_NO[0];
                    sORD_LN = ORD_LN[0];

                    if ( ORD_NO.length > 0 && ORD_LN.length > 0 )
                    {
                        logger.logDebug( C10ConstantsIF.IDS_VALUE + i + idsValue[i] );
                        logger.logDebug( C10ConstantsIF.ORD_NO + i + sORD_NO );
                        logger.logDebug( C10ConstantsIF.ORD_LN + i + sORD_LN );

                        param = new PosParameter();

                        param.setWhereClauseParameter( 0, sORD_NO );
                        param.setWhereClauseParameter( 1, sORD_LN );

                        rowset = mesdao.find( C10ConstantsIF.C104000050_CHECK, param );

                        logger.logDebug( C10ConstantsIF.SELECT_COUNT + rowset.count() );
                        if ( rowset.count() == 0 )
                        {
                            // error
                            logger.logError( C10ConstantsIF.C104000050_CHECK_ERR );
                            // throw new PosException( C10ConstantsIF.C104000050_CHECK_ERR );

                            ctx.put( C10ConstantsIF.ERRMSG, C10ConstantsIF.C104000050_CHECK_ERR );

                            return PosBizControlConstants.FAILURE;

                        }
                        /*
                         * select QLT_DSN_STS_CD
                         * FROM TB_C10_QLT_DSN_CMN
                         * WHERE ORD_NO = :ORD_NO
                         * AND ORD_LN = :ORD_LN
                         * AND QLT_DSN_STS_CD = 'B'
                         */

                        param = new PosParameter();
                        param.setValueParamter( C10ConstantsIF.ORD_NO, sORD_NO );
                        param.setValueParamter( C10ConstantsIF.ORD_LN, sORD_LN );
                        param.setNamedParamter( C10ConstantsIF.OBJECT_TYPE, 
                                (String) ctx.get( C10ConstantsIF.OBJECT_TYPE ) );
                        param.setNamedParamter( C10ConstantsIF.OBJECT_ID, 
                                (String) ctx.get( C10ConstantsIF.OBJECT_ID ) );
                        param.setNamedParamter( C10ConstantsIF.PROGRAM_ID, 
                                (String) ctx.get( C10ConstantsIF.PROGRAM_ID ) );
                        param.setNamedParamter( C10ConstantsIF.TIMESTAMP, 
                        		ctx.get(C10ConstantsIF.TIMESTAMP));
                        logger.logDebug( param );
                        nRELULT = mesdao.update( C10ConstantsIF.C104000050_UPDATE, param );
                        logger.logDebug( C10ConstantsIF.C104000050_UPDATE );

                        param = new PosParameter();
                        param.setNamedParamter( C10ConstantsIF.COL_IF_GRP_ID, 
                                ctx.get( C10ConstantsIF.COL_IF_GRP_ID ) );
                        param.setNamedParamter( C10ConstantsIF.ORD_NO, sORD_NO );
                        param.setNamedParamter( C10ConstantsIF.ORD_LN, sORD_LN );
                        param.setNamedParamter( C10ConstantsIF.COL_QLT_DSN_STS, C10ConstantsIF.A );
                        param.setNamedParamter( C10ConstantsIF.COL_QLT_DSN_MSG, C10ConstantsIF.A );
                        param.setNamedParamter( C10ConstantsIF.OBJECT_TYPE, 
                                (String) ctx.get( C10ConstantsIF.OBJECT_TYPE ) );
                        param.setNamedParamter( C10ConstantsIF.OBJECT_ID, 
                                (String) ctx.get( C10ConstantsIF.OBJECT_ID ) );
                        param.setNamedParamter( C10ConstantsIF.PROGRAM_ID, 
                                (String) ctx.get( C10ConstantsIF.PROGRAM_ID ) );
                        param.setNamedParamter( C10ConstantsIF.TIMESTAMP,
                        		ctx.get(C10ConstantsIF.TIMESTAMP));
                        nRELULT = eaidao.insert( C10ConstantsIF.IFB10S1010_INSERT, param );
                        logger.logDebug( C10ConstantsIF.IFB10S1010_INSERT );
                    } else
                    {
                        logger.logDebug( C10ConstantsIF.EMPTY_DATA );

                    }
                }
                this.commitTransaction( C10ConstantsIF.TX1 );
                this.commitTransaction( C10ConstantsIF.TX2 );
                return PosBizControlConstants.SUCCESS;
            }
            return PosBizControlConstants.FAILURE;
        } catch ( Exception e )
        {
            this.rollbackTransaction( C10ConstantsIF.TX1 );
            this.rollbackTransaction( C10ConstantsIF.TX2 );

            ctx.put( C10ConstantsIF.ERRMSG, e.getMessage() );
            return PosBizControlConstants.FAILURE;

        }
    }
}
