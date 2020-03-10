/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C10UiCheckActivity.java
 * Change history
 * @LastModifyDate : 2012. 06. 25
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 06. 25 박재영 최초 생성
 * ==============================================================================
 */

package com.unionsteel.mes.c10.activity.ui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosAuditAttributes;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * C10UiCheckActivity Class는 화면에서 설정된 설계확정 대상의 <br>
 * 설계상태가 확정대기 상태인지를 데이터베이스를 조회하여 확인하는 <br>
 * Class이다.
 * <xmp>
 * 1. 서비스간 정보 Interface를 위해 PosContext에 항목변수를 관리한다.
 * - 처리 서비스가 Batch job임을 구분(BATCH_JOB=true)
 * - 처리대상 주문 행번 건수를 관리
 * . 처리 건수관리 변수의 값이 null인 경우 이전 서비스의 Result set건수를
 * 읽어 값을 Setting
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

public class C104000020TAB08ProcActivity extends PosActivity implements C10NuiConstantsIF
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
        PosParameter param = new PosParameter();

        try
        {
            logger.logDebug( C10ConstantsIF.NEW_LINE + 
                    C10ConstantsIF.CTX + C10ConstantsIF.LOG_NOTI + ctx );

            String[] ids = (String[]) ctx.get( C10ConstantsIF.IDS );
            PosRowSet rowset = null;
            PosRow row = null;

            if ( ids == null || ids.length < 1 )
                return PosBizControlConstants.FAILURE;

            String[] idsValue = ids[0].split( C10ConstantsIF.COMMA );
            String[] ORD_NO;
            String[] ORD_LN;
            String[] PROC_SEQ;
            String[] MAIN_PROC_CD;
            String[] SUB_PROC_CD1;
            String[] SUB_PROC_CD2;
            String[] SUB_PROC_CD3;
            String[] SUB_PROC_CD4;
            String[] SUB_PROC_CD5;
            String[] SUB_PROC_CD6;
            String[] SMS_RCV_YN;
            String[] STATUS;
            String sORD_NO = C10STR_SPACE;
            String sORD_LN = C10STR_SPACE;
            String sPROC_SEQ = C10STR_SPACE;
            String sPRD_NM_CD = C10STR_SPACE;
            String sMAIN_PROC_CD;
            String sSUB_PROC_CD1;
            String sSUB_PROC_CD2;
            String sSUB_PROC_CD3;
            String sSUB_PROC_CD4;
            String sSUB_PROC_CD5;
            String sSUB_PROC_CD6;
            String sSMS_RCV_YN;
            String sMTL_CD = C10STR_SPACE;
            String sSEM_MTL_CD;
            String sSTATUS = C10STR_SPACE;
            int nRELULT = 0;
            int nIvalue = 0;     //내역저장 플래그 
            
   
            for ( int i = 0, n = idsValue.length; i < n; i++ )
            {
                ORD_NO = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_ORD_NO );
                ORD_LN = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_ORD_LN );
                PROC_SEQ = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_PROC_SEQ );
                MAIN_PROC_CD = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_MAIN_PROC_CD );
                SUB_PROC_CD1 = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_SUB_PROC_CD1 );
                SUB_PROC_CD2 = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_SUB_PROC_CD2 );
                SUB_PROC_CD3 = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_SUB_PROC_CD3 );
                SUB_PROC_CD4 = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_SUB_PROC_CD4 );
                SUB_PROC_CD5 = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_SUB_PROC_CD5 );
                SUB_PROC_CD6 = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_SUB_PROC_CD6 );
                SMS_RCV_YN = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + COL_SMS_RCV_YN );                
                STATUS = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "!nativeeditor_status" );
                
                if ( ORD_NO.length > 0 && ORD_LN.length > 0 )
                { 

                    sMAIN_PROC_CD = C10STR_SPACE;
                    sSUB_PROC_CD1 = C10STR_SPACE;
                    sSUB_PROC_CD2 = C10STR_SPACE;
                    sSUB_PROC_CD3 = C10STR_SPACE;
                    sSUB_PROC_CD4 = C10STR_SPACE;
                    sSUB_PROC_CD5 = C10STR_SPACE;
                    sSUB_PROC_CD6 = C10STR_SPACE;
                    sSMS_RCV_YN = C10STR_SPACE;
                    sSEM_MTL_CD = C10STR_SPACE;
                    sORD_NO = ORD_NO[0];
                    sORD_LN = ORD_LN[0];
                    sPROC_SEQ = PROC_SEQ[0];
                    sSTATUS = STATUS[0];
                    sMAIN_PROC_CD = MAIN_PROC_CD[0];
                    sSUB_PROC_CD1 = SUB_PROC_CD1[0];
                    sSUB_PROC_CD2 = SUB_PROC_CD2[0];
                    sSUB_PROC_CD3 = SUB_PROC_CD3[0];
                    sSUB_PROC_CD4 = SUB_PROC_CD4[0];
                    sSUB_PROC_CD5 = SUB_PROC_CD5[0];
                    sSUB_PROC_CD6 = SUB_PROC_CD6[0];
                    sSMS_RCV_YN = SMS_RCV_YN[0];

                    logger.logError( "ORD_NO :" + sORD_NO );
                    logger.logError( "ORD_LN :" + sORD_LN );
                    logger.logError( "PROC_SEQ :" + sPROC_SEQ );
                    logger.logError( "MAIN_PROC_CD :" + sMAIN_PROC_CD );
                    logger.logError( "SUB_PROC_CD1 :" + sSUB_PROC_CD1 );
                    logger.logError( "SUB_PROC_CD2 :" + sSUB_PROC_CD2 );
                    logger.logError( "SUB_PROC_CD3 :" + sSUB_PROC_CD3 );
                    logger.logError( "SUB_PROC_CD4 :" + sSUB_PROC_CD4 );
                    logger.logError( "SUB_PROC_CD5 :" + sSUB_PROC_CD5 );
                    logger.logError( "SUB_PROC_CD6 :" + sSUB_PROC_CD6 );
                    logger.logError( "SMS_RCV_YN :" + sSMS_RCV_YN );

                    if(i == 0)
                    {
                        param = new PosParameter();
                        param.setWhereClauseParameter( 0, sORD_NO );
                        param.setWhereClauseParameter( 1, sORD_LN );
                        rowset = mesdao.find( SELECT_CMN, param ); // 반제품 Material
                        logger.logError( "조회" );
                        if ( rowset.count() > 0 )
                        {
                            row = rowset.next();
                            sPRD_NM_CD = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_NM_CD ) );
                            sMTL_CD = DbCommonUtil.valueOf( row.getAttribute( COL_MTL_CD ) );
                            logger.logError( "PRD_NM_CD : " + sPRD_NM_CD );
                            logger.logError( "MTL_CD : " + sMTL_CD );
                        }

                        // 통과공정삭제
                        param = new PosParameter();
                        param.setNamedParamter( COL_ORD_NO, sORD_NO );
                        param.setNamedParamter( COL_ORD_LN, sORD_LN );
                        nRELULT = mesdao.delete( DELETE_PROC, param );      
                        logger.logError( "삭제" );
                        
                    }
                    
                    logger.logError( "상태 : " + sSTATUS  );
                    if(sMAIN_PROC_CD.equals( C10STR_SPACE ) || sSTATUS.equals( "deleted" ) )
                        continue;
                    
                    param = new PosParameter();
                    param.setWhereClauseParameter( 0, sMTL_CD );

                    if ( sPRD_NM_CD.equals( PRD_NM_CD_1 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_2 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_3 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_4 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_5 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_6 ) ||
                            sPRD_NM_CD.equals( PRD_NM_CD_7 ) ||
                            sPRD_NM_CD.equals( PRD_NM_CD_8 ) ||
                            sPRD_NM_CD.equals( PRD_NM_CD_9 ) )
                    {
                        // RCL(72) 공정은 공정코드 전체(72)를 비교하여 Set한다.
                        if ( sMAIN_PROC_CD.equals( NUM7 + NUM2 ) )
                            param.setWhereClauseParameter( 1, sMAIN_PROC_CD );
                        else if ( !sMAIN_PROC_CD.substring( 0, 1 ).equals( NUM7 ) )
                            param.setWhereClauseParameter( 1, sMAIN_PROC_CD.substring( 0, 1 ) );
                    } else
                        param.setWhereClauseParameter( 1, sMAIN_PROC_CD.substring( 0, 1 ) );
                    // 결과값 잘 가져오는지 확인
                    if ( sPRD_NM_CD.equals( PRD_NM_CD_1 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_2 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_3 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_4 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_5 ) || 
                            sPRD_NM_CD.equals( PRD_NM_CD_6 ) ||
                            sPRD_NM_CD.equals( PRD_NM_CD_7 ) ||
                            sPRD_NM_CD.equals( PRD_NM_CD_8 ) ||
                            sPRD_NM_CD.equals( PRD_NM_CD_9 ) )
                    {
                        // RCL(72) 공정은 공정코드 전체(72)를 비교하여 Set한다.
                        if ( sMAIN_PROC_CD.equals( NUM7 + NUM2 ) )
                            rowset = mesdao.find( SELECT_SEM_MTL1, param ); // 반제품 Material
                        // R/S(72이외 7로 시작하는 공정) 공정은 RCL공정(72)를 제외한 "7"로 시작하는 공정코드를 비교하여 Set한다.
                        else if ( sMAIN_PROC_CD.substring( 0, 1 ).equals( NUM7 ) )
                            rowset = mesdao.find( SELECT_SEM_MTL3, param ); // 반제품 Material
                        // 이외의 공정은 공정코드비교시 공정코드 첫자리만 비교하여 Match되는 공정의 반제품 Material Code를 Set한다.
                        else
                            rowset = mesdao.find( SELECT_SEM_MTL2, param ); // 반제품 Material
                    } else
                        rowset = mesdao.find( SELECT_SEM_MTL2, param ); // 반제품 Material
    
                    if ( rowset.count() > 0 )
                    {
                        row = rowset.next();
                        sSEM_MTL_CD = DbCommonUtil.valueOf( row.getAttribute( COL_SEM_PROD_MTL_CD ) );
                        logger.logError( "세미조회" );
                    }
  
                    PosAuditAttributes audit = ctx.getAuditAttribute();
                    param = new PosParameter();
                    param.setNamedParamter( "ORD_NO", sORD_NO );
                    param.setNamedParamter( "ORD_LN", sORD_LN );
                    param.setNamedParamter( "PROC_SEQ", sPROC_SEQ );
                    param.setNamedParamter( "MAIN_PROC_CD", sMAIN_PROC_CD );
                    param.setNamedParamter( "SUB_PROC_CD1", sSUB_PROC_CD1 );
                    param.setNamedParamter( "SUB_PROC_CD2", sSUB_PROC_CD2 );
                    param.setNamedParamter( "SUB_PROC_CD3", sSUB_PROC_CD3 );
                    param.setNamedParamter( "SUB_PROC_CD4", sSUB_PROC_CD4 );
                    param.setNamedParamter( "SUB_PROC_CD5", sSUB_PROC_CD5 );
                    param.setNamedParamter( "SUB_PROC_CD6", sSUB_PROC_CD6 );
                    param.setNamedParamter( "MTL_CD", sSEM_MTL_CD );
                    param.setNamedParamter( "SMS_RCV_YN", sSMS_RCV_YN );
                    param.setNamedParamter( "VALUE_I", nIvalue );
                    param.setNamedParamter( C10ConstantsIF.OBJECT_TYPE,(String) ctx.get( C10ConstantsIF.OBJECT_TYPE ) );
                    param.setNamedParamter( C10ConstantsIF.OBJECT_ID,(String) ctx.get( C10ConstantsIF.OBJECT_ID ) );
                    param.setNamedParamter( C10ConstantsIF.PROGRAM_ID,(String) ctx.get( C10ConstantsIF.PROGRAM_ID ) );
                    param.setNamedParamter( C10ConstantsIF.TIMESTAMP,ctx.get(C10ConstantsIF.TIMESTAMP));

                    //원본소스
                    //nRELULT = mesdao.insert( INSERT_PROC, param );
                    //테스트소스
                    nRELULT = mesdao.insert( INSERT_PROC2, param );
                    //통과공정 내역을 통과공정수정이력 테이블에 같이 저장한다. 
                    nRELULT = mesdao.insert( INSERT_PROC_HST, param );
                    //내역저장 플래그 
                    nIvalue++;
                    
                    logger.logError( "저장" );
                }
            }
            
            if(!sORD_NO.equals( C10STR_SPACE ) && !sORD_LN.equals( C10STR_SPACE ))
            {
                param = new PosParameter();
                param.setNamedParamter( COL_ORD_NO, sORD_NO );
                param.setNamedParamter( COL_ORD_LN, sORD_LN );
                param.setNamedParamter( C10ConstantsIF.OBJECT_TYPE, 
                        (String) ctx.get( C10ConstantsIF.OBJECT_TYPE ) );
                param.setNamedParamter( C10ConstantsIF.OBJECT_ID, 
                        (String) ctx.get( C10ConstantsIF.OBJECT_ID ) );
                param.setNamedParamter( C10ConstantsIF.PROGRAM_ID, 
                        (String) ctx.get( C10ConstantsIF.PROGRAM_ID ) );
                param.setNamedParamter( C10ConstantsIF.TIMESTAMP, 
                        ctx.get(C10ConstantsIF.TIMESTAMP));

                nRELULT = mesdao.insert( INSERT_HST, param );               
            }
            this.commitTransaction( C10ConstantsIF.TX1 );
            logger.logError( "커밋" );
            return PosBizControlConstants.SUCCESS;

        } catch ( Exception e )
        {
            logger.logError( e.getMessage() );
            this.rollbackTransaction( C10ConstantsIF.TX1 );

            ctx.put( C10ConstantsIF.ERRMSG, e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }
    }
}
