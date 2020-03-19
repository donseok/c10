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

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.springframework.context.ApplicationContext;

import oracle.jdbc.OraclePreparedStatement;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosAuditAttributes;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * C107000050pop01ProcActivity
 * 
 * <activity name="상태확인" class="com.unionsteel.mes.c10.activity.ui.C10UiCheckActivity">
 * <transition name="success" value="end" />
 * <transition name="failure" value="end" />
 * </activity>
 * Property 설정
 * sqlkey : query.xml의 query id
 * dao : applicationContext.xml의 DAO id
 * resultkey : Query 결과를 ctx에 저장할 Key
 * </xmp>
 * 
 * @author 원성옥
 * @see PosActivity
 * @version 1.0
 * @date 2015.04.21
 */

public class C107000050pop01ProcActivity extends PosActivity implements C10NuiConstantsIF
{

    /**
     * <p>
     * 이 메소드는 PosActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다. 
     * property의 값 또는 PosContext의 input, output값은 Class JavaDoc에 작성
     *  
     * 예를 들어 @throws, @param, @return에 대해 더 상세히 기술하거나 예제를 추가할 필요가 있을 때 작성한다.
     * </p>
     * 
     * @throws PosException IO Exception 발생 시
     * @param ctx Service내의 Data를 관리하는 PosContext 객체
     * @return success - 성공적으로 끝났을 때 Route transition.
     *         nullpointer - NullPointerException 발생 시 Route transtion.
     *         faillue - 그 외 Exception 발생 시 Route transition.
     */
	private static final String driver     = "oracle.jdbc.driver.OracleDriver";
	private static final String url_tst    = "jdbc:oracle:thin:@210.1.1.139:2020:UBMADQ";
	private static final String dbid_tst   = "M00APUSER"; 
	private static final String dbpass_tst = "M00APUSER_TST";
	
	private static final String url_prd    = "jdbc:oracle:thin:@210.1.1.146:2010:USMEAP1";
	private static final String dbid_prd   = "M00APUSER"; 
	private static final String dbpass_prd = "M00APUSER_PRD";
	
    public String runActivity( PosContext ctx )
    {
    	String chk = getProperty("chk");
    	Connection conn = null;
    	OraclePreparedStatement pstmt = null;
    	try {
			Class.forName(driver);
			logger.logDebug("DRIVER LOADING SUECCESS");
		} catch (ClassNotFoundException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
    	 try {
			
	        if(chk.equals("tstdao"))      conn = DriverManager.getConnection(url_tst, dbid_tst, dbpass_tst);
	        else if(chk.equals("prddao")) conn = DriverManager.getConnection(url_prd, dbid_prd, dbpass_prd);
	        else                          //conn = DriverManager.getConnection(url, dbid, dbpass);
		
			logger.logDebug("DB CONNECTION SUCCESS");
			conn.setAutoCommit(false);

			//--------------------------------------------------------------------------------//
	/*		String path = this.getClass().getResource("").getPath();
			 logger.logError("path" +  path);
			 logger.logError("devpath    : " + "/APP/WAS/UBMWD/user_projects/domains/UBMWD1_domain/servers/UBMWD1/tmp/_WL_user/M42/9g2dkm/war");
			StringBuffer query = null;
			query = new StringBuffer();
	        java.io.FileReader file = null;
	        java.io.BufferedReader reader = null;
	        String readString = null;
                file = new FileReader(path + "C107000050pop01.sql");
                reader = new BufferedReader(file);
    
                while ((readString = reader.readLine()) != null) {
                        query.append("\n");
                        query.append(readString);
                }
            logger.logError("query" +  query);*/
             //--------------------------------------------------------------------------------//          
			StringBuffer sqlKey = new StringBuffer();
			sqlKey.append(" MERGE INTO M00APUSER.TB_M00_ATTRS \n");
			sqlKey.append(" USING DUAL \n");
			sqlKey.append(" ON(DT_NM_ID =:DT_NM_ID) \n");
			sqlKey.append(" WHEN MATCHED THEN \n");
			sqlKey.append(" UPDATE SET \n");
			sqlKey.append(" STANDARD_ENGLISH_ID = :STANDARD_ENGLISH_ID \n");
			sqlKey.append(" ,STANDARD_KOREAN_NAME = :STANDARD_KOREAN_NAME \n");
			sqlKey.append(" ,DT_NM_DATA_TP = :DT_NM_DATA_TP \n");
			sqlKey.append(" ,DT_NM_LEN = :DT_NM_LEN \n");
			sqlKey.append(" ,DT_NM_DECIMAL_PREC = :DT_NM_DECIMAL_PREC \n");
			sqlKey.append(" ,USE_TP = :USE_TP \n");
			sqlKey.append(" ,SYS_TP = :SYS_TP \n");
			sqlKey.append(" ,CHAIN_CODE = :CHAIN_CODE \n");
			sqlKey.append(" ,LAST_UPDATED_OBJECT_TYPE = :ObjectType \n");
			sqlKey.append(" ,LAST_UPDATED_OBJECT_ID = :ObjectId \n");
			sqlKey.append(" ,LAST_UPDATE_PROGRAM_ID = :ProgramId \n");
			sqlKey.append(" ,LAST_UPDATE_TIMESTAMP = :Timestamp \n");
			sqlKey.append(" WHEN NOT MATCHED THEN \n");
			sqlKey.append(" INSERT \n");
			sqlKey.append(" (DT_NM_ID \n");
			sqlKey.append(" ,STANDARD_ENGLISH_ID \n");
			sqlKey.append(" ,STANDARD_KOREAN_NAME \n"); 
			sqlKey.append(" ,DT_NM_DATA_TP \n");
			sqlKey.append(" ,DT_NM_LEN \n");
			sqlKey.append(" ,DT_NM_DECIMAL_PREC \n");
			sqlKey.append(" ,USE_TP \n");
			sqlKey.append(" ,SYS_TP \n");
			sqlKey.append(" ,CHAIN_CODE \n");
			sqlKey.append(" ,CREATED_OBJECT_TYPE \n");
			sqlKey.append(" ,CREATED_OBJECT_ID \n");
			sqlKey.append(" ,CREATED_PROGRAM_ID \n");
			sqlKey.append(" ,CREATION_TIMESTAMP \n");
			sqlKey.append(" ,LAST_UPDATED_OBJECT_TYPE \n");
			sqlKey.append(" ,LAST_UPDATED_OBJECT_ID \n");
			sqlKey.append(" ,LAST_UPDATE_PROGRAM_ID \n");
			sqlKey.append(" ,LAST_UPDATE_TIMESTAMP \n");
			sqlKey.append(" ) \n");
			sqlKey.append(" VALUES \n");
			sqlKey.append(" (:DT_NM_ID \n");
			sqlKey.append(" ,:STANDARD_ENGLISH_ID \n");
			sqlKey.append(" ,:STANDARD_KOREAN_NAME \n");
			sqlKey.append(" ,:DT_NM_DATA_TP \n");
			sqlKey.append(" ,:DT_NM_LEN \n");
			sqlKey.append(" ,:DT_NM_DECIMAL_PREC \n");
			sqlKey.append(" ,:USE_TP  \n");
			sqlKey.append(" ,:SYS_TP \n");
			sqlKey.append(" ,:CHAIN_CODE \n");
			sqlKey.append(" ,:ObjectType \n");
			sqlKey.append(" ,:ObjectId \n");
			sqlKey.append(" ,:ProgramId \n");
			sqlKey.append(" ,:Timestamp \n");
			sqlKey.append(" ,:ObjectType \n");
			sqlKey.append(" ,:ObjectId  \n");
			sqlKey.append(" ,:ProgramId \n");
			sqlKey.append(" ,:Timestamp \n");
			sqlKey.append(" )\n");

			logger.logError("sqlKey : " + sqlKey);
			pstmt = (OraclePreparedStatement) conn.prepareStatement(sqlKey.toString());
			
            logger.logDebug( C10ConstantsIF.NEW_LINE + 
                    C10ConstantsIF.CTX + C10ConstantsIF.LOG_NOTI + ctx );

            String[] ids = (String[]) ctx.get( C10ConstantsIF.IDS );
            PosRowSet rowset = null;
            PosRow row = null;

            if ( ids == null || ids.length < 1 )
                return PosBizControlConstants.FAILURE;

            String[] idsValue = ids[0].split( C10ConstantsIF.COMMA );
            
            String[] CH;
            String[] DT_NM_ID;
            String[] STANDARD_ENGLISH_ID;
            String[] STANDARD_KOREAN_NAME;
            String[] SYS_TP;
            String[] CHAIN_CODE;
            String[] DT_NM_DATA_TP;
            String[] DT_NM_LEN;
            String[] DT_NM_DECIMAL_PREC;
            String[] DT_NM_ALIAS;
            String[] USE_TP;

            String[] STATUS;
            
            String sCH;
            String sDT_NM_ID = C10STR_SPACE;
            String sSTANDARD_ENGLISH_ID = C10STR_SPACE;
            String sSTANDARD_KOREAN_NAME = C10STR_SPACE;
            String sSYS_TP = C10STR_SPACE;
            String sCHAIN_CODE;
            String sDT_NM_DATA_TP;
            String sDT_NM_LEN;
            String sDT_NM_DECIMAL_PREC;
            String sDT_NM_ALIAS;
            String sUSE_TP;

            String sSTATUS = C10STR_SPACE;
  
            for ( int i = 0, n = idsValue.length; i < n; i++ )
            {
            	
            	CH = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "CH" );
            	DT_NM_ID = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "DT_NM_ID" );
            	STANDARD_ENGLISH_ID = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "STANDARD_ENGLISH_ID" );
            	STANDARD_KOREAN_NAME = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "STANDARD_KOREAN_NAME" );
              	SYS_TP = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "SYS_TP" );
            	CHAIN_CODE = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "CHAIN_CODE" );
            	DT_NM_DATA_TP = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "DT_NM_DATA_TP" );
            	DT_NM_LEN = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "DT_NM_LEN" );
                DT_NM_DECIMAL_PREC = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "DT_NM_DECIMAL_PREC" );
                DT_NM_ALIAS = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "DT_NM_ALIAS" );
                USE_TP = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "USE_TP" );
              
                STATUS = (String[]) ctx.get( idsValue[i] + 
                        C10ConstantsIF.UNDERBAR + "!nativeeditor_status" );

                
                if (DT_NM_ID.length > 0 && STANDARD_ENGLISH_ID.length > 0 && STANDARD_KOREAN_NAME.length > 0 && SYS_TP.length > 0 )
                { 

                  	sCH                   = C10STR_SPACE;
                	sCHAIN_CODE           = C10STR_SPACE;
                	sDT_NM_DATA_TP        = C10STR_SPACE;
                	sDT_NM_LEN            = C10STR_SPACE;
                    sDT_NM_DECIMAL_PREC   = C10STR_SPACE;
                    sDT_NM_ALIAS          = C10STR_SPACE;
                    sUSE_TP               = C10STR_SPACE; 
                     
                    sCH                   = CH[0];
                	sDT_NM_ID             = DT_NM_ID[0];
                	sSTANDARD_ENGLISH_ID  = STANDARD_ENGLISH_ID[0];
                    sSTANDARD_KOREAN_NAME = STANDARD_KOREAN_NAME[0];
                    sSYS_TP               = SYS_TP[0];
                	sCHAIN_CODE           = CHAIN_CODE[0];
                	sDT_NM_DATA_TP        = DT_NM_DATA_TP[0];
                	sDT_NM_LEN            = DT_NM_LEN[0];
                	sDT_NM_DECIMAL_PREC   = DT_NM_DECIMAL_PREC[0];
                	sDT_NM_ALIAS          = DT_NM_ALIAS[0];
                    sUSE_TP               = USE_TP[0];

                	sSTATUS               = STATUS[0];
                	
                   	logger.logDebug( "CH :" + sCH );
                	logger.logDebug( "DT_NM_ID :" + sDT_NM_ID );
                	logger.logDebug( "STANDARD_ENGLISH_ID :" + sSTANDARD_ENGLISH_ID );
                	logger.logDebug( "STANDARD_KOREAN_NAME :" + sSTANDARD_KOREAN_NAME );
                    logger.logDebug( "SYS_TP :" + sSYS_TP );
                    logger.logDebug( "CHAIN_CODE :" + sCHAIN_CODE );
                    logger.logDebug( "DT_NM_DATA_TP :" + sDT_NM_DATA_TP );
                    logger.logDebug( "DT_NM_LEN :" + sDT_NM_LEN );
                    logger.logDebug( "DT_NM_DECIMAL_PREC :" + sDT_NM_DECIMAL_PREC );
                    logger.logDebug( "DT_NM_ALIAS :" + sDT_NM_ALIAS );
                    logger.logDebug( "USE_TP :" + sUSE_TP );
                    
                    logger.logDebug( "log_status : " + sSTATUS  );
                    logger.logDebug( "OBJECT_TYPE :" +  (String) ctx.get(C10ConstantsIF.OBJECT_TYPE ));
                    logger.logDebug( "OBJECT_ID :" +  (String) ctx.get(C10ConstantsIF.OBJECT_ID ));
                    logger.logDebug( "PROGRAM_ID :" +  (String) ctx.get(C10ConstantsIF.PROGRAM_ID ));
                    logger.logDebug( "TIMESTAMP :" +  ctx.get(C10ConstantsIF.TIMESTAMP ));
                    
 
                    PosAuditAttributes audit = ctx.getAuditAttribute();
                	pstmt.setStringAtName( "DT_NM_ID", sDT_NM_ID );
                	pstmt.setStringAtName( "STANDARD_ENGLISH_ID", sSTANDARD_ENGLISH_ID );
                	pstmt.setStringAtName( "STANDARD_KOREAN_NAME", sSTANDARD_KOREAN_NAME );
                	pstmt.setStringAtName( "SYS_TP", sSYS_TP );
                	pstmt.setStringAtName( "CHAIN_CODE", sCHAIN_CODE );
                	pstmt.setStringAtName( "DT_NM_DATA_TP", sDT_NM_DATA_TP );
                	pstmt.setStringAtName( "DT_NM_LEN", sDT_NM_LEN );
                	pstmt.setStringAtName( "DT_NM_DECIMAL_PREC", sDT_NM_DECIMAL_PREC );
                	pstmt.setStringAtName( "USE_TP", sUSE_TP );

                	pstmt.setStringAtName( C10ConstantsIF.OBJECT_TYPE,(String) ctx.get( C10ConstantsIF.OBJECT_TYPE ) );
                	pstmt.setStringAtName( C10ConstantsIF.OBJECT_ID,(String) ctx.get( C10ConstantsIF.OBJECT_ID ) );
                	pstmt.setStringAtName( C10ConstantsIF.PROGRAM_ID,(String) ctx.get( C10ConstantsIF.PROGRAM_ID ) );
                    pstmt.setTimestampAtName(C10ConstantsIF.TIMESTAMP, (Timestamp) ctx.get(C10ConstantsIF.TIMESTAMP));
                	
					//체크 된 값
					if(sCH.equals("1")){
						logger.logDebug("WHEN CH == 1 ");
						//인서트, 업데이트 구문 실행
						pstmt.executeUpdate();
                    }
                    logger.logDebug( "저장" );
                }
            }

            conn.commit();
            logger.logDebug( "커밋" );
            if(chk.equals("tstdao")){ 
            	ctx.put("TST", "테스트계 이행이 완료되었습니다.");
            }
            else if(chk.equals("prddao")){
            	ctx.put("PRD", "운영계 이행이 완료되었습니다.");
            }
            return PosBizControlConstants.SUCCESS;

        } catch ( Exception e )
        {
        	if(conn!=null) try{conn.rollback();}catch(SQLException sqle){} 
            if(chk.equals("tstdao")){ 
            	ctx.put("TST", "테스트계 이행이 실패했습니다.");
            }
            else if(chk.equals("prddao")){
            	ctx.put("PRD", "운영계 이행이 실패했습니다.");
            }
            logger.logError( e.getMessage() );
            ctx.put( C10ConstantsIF.ERRMSG, e.getMessage() );
            throw new PosException(e.getMessage());
            
        }finally {
           // if (rs != null) try { rs.close(); } catch(SQLException ex) {}
            if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
            if (conn != null) try { conn.close(); } catch(SQLException ex) {}
        }
    	 
    }
}
