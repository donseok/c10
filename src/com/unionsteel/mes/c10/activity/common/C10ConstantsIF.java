/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C10ConstantsIF.java
 * Change history
 * @LastModifyDate : 2011. 12. 09
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2011. 12. 09 박재영 최초 생성
 * ==============================================================================
 */

package com.unionsteel.mes.c10.activity.common;

/**
 * C10ConstantIF.java Class는 상수를 정의한 Interface이다.
 * <xmp>
 * C10 Activity 내에서 상수명에 대한 Naming Rule에 아래와 같이 접두어를 두었다.
 * [C10PN_] : Property Name에 대한 약자로 Activity에서 지정한 Property의 이름에 대한 상수이다.
 * [C10STR_] : 위의 경우를 제외한 일반적으로 사용되는 String type의 상수이다.
 * [NUM] : 숫자형 String type의 상수 이다.
 * [COL_] : DB 컬럼명으로 사용되는 상수이다.
 * [BIN] : 2진수형 String type의 상수 이다.
 * [ERRCD_] : 에러코드의 상수이다.
 * [TBN_VI_] : 테이블명 상수이다.
 * </xmp>
 * 
 * @author 박재영
 * @version 1.0
 */
public class C10ConstantsIF
{
    // query name
    public static final java.lang.String C104000050_CHECK = "C104000050.check";
    public static final java.lang.String C104000050_UPDATE = "C104000050.update";
    public static final java.lang.String C104000050_CHECK2 = "C104000050.check2";
    public static final java.lang.String C104000050_UPDATE2 = "C104000050.update2";
    public static final java.lang.String C104000050_CHECK3 = "C104000050.check3";
    public static final java.lang.String C104000050_UPDATE3 = "C104000050.update3";    
    public static final java.lang.String C106000050_SELECT = "C106000050.DetailSendSelec";
    public static final java.lang.String IFB10S1010_INSERT = "IFB10S1010.insert";
    public static final java.lang.String IFB10S0130_INSERT = "IFB10S0130.insert";
    public static final java.lang.String C106000050_erp_snd_update = "C106000050.erp_snd_update";
    public static final String C106000080POP01_INSERT 	= "C106000080pop01.insert";
    public static final String C106000080POP01_DELETE 	= "C106000080pop01.delete";
    public static final String C106000080POP01_UPDATE   = "C106000080pop01.update";
    
    public static final String C106000100POP01_INSERT 	= "C106000100pop01.insert";
    public static final String C106000100POP01_DELETE 	= "C106000100pop01.delete";
    public static final String C106000100POP01_UPDATE   = "C106000100pop01.update";
    
    public static final String C106000100POP02_INSERT 	= "C106000100pop02.insert";
    public static final String C106000100POP02_DELETE 	= "C106000100pop02.delete";
    public static final String C106000100POP02_UPDATE   = "C106000100pop02.update";
    
    public static final String C106000100POP03_INSERT 	= "C106000100pop03.insert";
    public static final String C106000100POP03_DELETE 	= "C106000100pop03.delete";
    public static final String C106000100POP03_UPDATE   = "C106000100pop03.update";
    
    public static final String C106000100POP04_INSERT 	= "C106000100pop04.insert";
    public static final String C106000100POP04_DELETE 	= "C106000100pop04.delete";
    public static final String C106000100POP04_UPDATE   = "C106000100pop04.update";
    
    public static final String C106000050POP03_INSERT 	= "C106000050pop03.insert";
    public static final String C106000050POP03_DELETE 	= "C106000050pop03.delete";
    public static final String C106000050POP03_UPDATE   = "C106000050pop03.update";
    
    public static final String C108000010POP02_INSERT 	= "C108000010pop02.insert";
    public static final String C108000010POP02_DELETE 	= "C108000010pop02.delete";
    public static final String C108000010POP02_UPDATE   = "C108000010pop02.update";
    public static final String C108000010POP02_UPDATE2  = "C108000010pop02.update2";
    
    public static final String C106000120POP01_INSERT 	= "C106000120pop01.insert";
    public static final String C106000120POP01_DELETE 	= "C106000120pop01.delete";
    public static final String C106000120POP01_UPDATE   = "C106000120pop01.update";
    
    public static final String C106000120POP02_INSERT 	= "C106000120pop02.insert";
    public static final String C106000120POP02_DELETE 	= "C106000120pop02.delete";
    public static final String C106000120POP02_UPDATE   = "C106000120pop02.update";
    
    public static final String C106000140POP01_INSERT 	= "C106000140pop01.insert";
    public static final String C106000140POP01_DELETE 	= "C106000140pop01.delete";
    public static final String C106000140POP01_UPDATE   = "C106000140pop01.update";
    
    public static final String C106000140POP02_INSERT 	= "C106000140pop02.insert";
    public static final String C106000140POP02_DELETE 	= "C106000140pop02.delete";
    public static final String C106000140POP02_UPDATE   = "C106000140pop02.update";
    
    
    // service name
    public static final java.lang.String C104000050_SERVICE = "C104000050-service";

    // FILE NAME
    public static final java.lang.String FILE_NM = "FILE_NM";
    public static final java.lang.String FILE_ADR = "FILE_ADR";
    
    // IF 전문
    public static final java.lang.String M17A0101 = "M17A0101";
    public static final java.lang.String ERR_YN = "ERR_YN";
    public static final java.lang.String ERR_CODE = "ERR_CODE";
    public static final java.lang.String ERR_DSC = "ERR_DSC";
    public static final java.lang.String E20 = "E20";
    public static final java.lang.String E99 = "E99";
    public static final java.lang.String E01 = "E01";
    public static final java.lang.String E90 = "E90";

    // object name
    public static final java.lang.String IDS_VALUE = "idsValue";
    public static final java.lang.String MESDAO = "mesdao";
    public static final java.lang.String EAIDAO = "eaidao";
    public static final java.lang.String SERVICE_NAME = "ServiceName";
    public static final java.lang.String RADIO1 = "radio1";
    public static final java.lang.String IDS = "ids";
    public static final java.lang.String COIL = "COIL";
    public static final java.lang.String RMTL = "RMTL";
    public static final java.lang.String XML_RESULT = "xml-result";
    public static final java.lang.String XML_RESULT1 = "xml-result1";
    public static final java.lang.String XML_RESULT2 = "xml-result2";
    public static final java.lang.String XML_RESULT3 = "xml-result3";
    public static final java.lang.String XML_RESULT4 = "xml-result4";
    public static final java.lang.String CTX = "ctx";
    public static final java.lang.String TX1 = "tx1";
    public static final java.lang.String TX2 = "tx2";

    // COLUMN NAME
    public static final java.lang.String COIL_ID = "COIL_ID";
    public static final java.lang.String RMTL_CD = "RMTL_CD";
    public static final java.lang.String RPV_RMTL_NO = "RPV_RMTL_NO";
    public static final java.lang.String ORD_NO = "ORD_NO";
    public static final java.lang.String ORD_LN = "ORD_LN";
    public static final java.lang.String PROC_CD = "PROC_CD";
    public static final java.lang.String MO_NO = "MO_NO";
    public static final java.lang.String MO_PTL_SEQ_NO = "MO_PTL_SEQ_NO";
    public static final java.lang.String COIL_WK_RNK = "COIL_WK_RNK";
    public static final java.lang.String MO_WK_RNK = "MO_WK_RNK";
    public static final java.lang.String WORD_DH = "WORD_DH";
    public static final java.lang.String RMTL_NO = "RMTL_NO";
    public static final java.lang.String SLV_KND_TP = "SLV_KND_TP";
    public static final java.lang.String PL_ORD_YN = "PL_ORD_YN";
    public static final java.lang.String SEM_PRD_TP = "SEM_PRD_TP";
    public static final java.lang.String PAS_BOD_COIL_ND_YN = "PAS_BOD_COIL_ND_YN";
    public static final java.lang.String ORD_SPL_TP = "ORD_SPL_TP";
    public static final java.lang.String NXT_PROC_CD = "NXT_PROC_CD";
    public static final java.lang.String PLN_PAS_PROC = "PLN_PAS_PROC";
    public static final java.lang.String COIL_JNT_STC_TP = "COIL_JNT_STC_TP";
    public static final java.lang.String SEQ_NO = "SEQ_NO";
    public static final java.lang.String JNT_STC_COIL_ID = "JNT_STC_COIL_ID";
    public static final java.lang.String JNT_STC_COIL_IDPROC_CD = "JNT_STC_COIL_IDPROC_CD";
    public static final java.lang.String JNT_STC_COIL_IDMO_NO = "JNT_STC_COIL_IDMO_NO";
    public static final java.lang.String WK_PRG_STS = "WK_PRG_STS";
    public static final java.lang.String APS_CHG_WRG_YN = "APS_CHG_WRG_YN";
    public static final java.lang.String INST_TP = "INST_TP";
    public static final java.lang.String L2_SND_YN = "L2_SND_YN";
    public static final java.lang.String URG_MTL_TP = "URG_MTL_TP";
    public static final java.lang.String WK_STR_SCH_DH = "WK_STR_SCH_DH";
    public static final java.lang.String WK_END_SCH_DH = "WK_END_SCH_DH";
    public static final java.lang.String PLN_WK_SCH_TIM = "PLN_WK_SCH_TIM";
    public static final java.lang.String BF_PROC_CD_WK_END_SCH_DH = "BF_PROC_CD_WK_END_SCH_DH";
    public static final java.lang.String WK_STR_DH = "WK_STR_DH";
    public static final java.lang.String WK_END_DH = "WK_END_DH";
    public static final java.lang.String PRD_GRP = "PRD_GRP";
    public static final java.lang.String MTL_CD = "MTL_CD";
    public static final java.lang.String CLS_CD = "CLS_CD";
    public static final java.lang.String SUB_CLS_CD = "SUB_CLS_CD";
    public static final java.lang.String LN_SPD = "LN_SPD";
    public static final java.lang.String PRD_NM_CD = "PRD_NM_CD";
    public static final java.lang.String SPC_AVR = "SPC_AVR";
    public static final java.lang.String ORD_USG_CD = "ORD_USG_CD";
    public static final java.lang.String MQL_CD = "MQL_CD";
    public static final java.lang.String SP_ASG_YN = "SP_ASG_YN";
    public static final java.lang.String COIL_THK = "COIL_THK";
    public static final java.lang.String COIL_WTH = "COIL_WTH";
    public static final java.lang.String COIL_WGT = "COIL_WGT";
    public static final java.lang.String PDN_DH = "PDN_DH";
    public static final java.lang.String RMTL_MAK_FAC_CD = "RMTL_MAK_FAC_CD";
    public static final java.lang.String MQL_ACT_YP_MPA = "MQL_ACT_YP_MPA";
    public static final java.lang.String MQL_ACT_TS_MPA = "MQL_ACT_TS_MPA";
    public static final java.lang.String MQL_ACT_EL = "MQL_ACT_EL";
    public static final java.lang.String MQL_ACT_HRB_AVG = "MQL_ACT_HRB_AVG";
    public static final java.lang.String MQL_ACT_ERI_AVG = "MQL_ACT_ERI_AVG";
    public static final java.lang.String ORD_BAK_SND_CAU = "ORD_BAK_SND_CAU";
    //public static final java.lang.String QLT_DSN_CFM = "QLT_DSN_CFM";
    /** 품질설계상태코드 */
    public static final java.lang.String COL_QLT_DSN_STS = "QLT_DSN_STS";
    public static final java.lang.String COL_QLT_DSN_MSG = "QLT_DSN_MSG";
    public static final java.lang.String COL_IF_GRP_ID = "IF_GRP_ID";

    // message type
    public static final java.lang.String ERRMSG = "errMsg";
    public static final java.lang.String APPMSG = "appMsg";

    // message
    public static final java.lang.String C104000050_CHECK_ERR = 
            "설계완료 또는 설계오류상태인 항목이 있습니다. 상태를 확인하세요";
    public static final java.lang.String C104000050_CHECK_ERR2 = 
            "설계완료 상태인 항목이 있습니다. 상태를 확인하세요";
    public static final java.lang.String C104000050_CHECK_ERR3 = 
            "반송 상태가 아닌 항목이 있습니다. 상태를 확인하세요";     
    public static final java.lang.String C106000050_CHECK_ERR = 
            "칼라코드 전송 시 업체코드가 없습니다.";    
    public static final java.lang.String EMPTY_DATA = "empty data!";
    public static final java.lang.String SELECT_COUNT = "건수 : ";

    // 특수문자
    public static final java.lang.String COMMA = ",";
    public static final java.lang.String UNDERBAR = "_";
    public static final java.lang.String BLANK = "";
    public static final java.lang.String NEW_LINE = "/n";

    // number
    public static final java.lang.String S1 = "1";
    public static final java.lang.String S2 = "2";
    public static final java.lang.String S3 = "3";
    public static final java.lang.String S4 = "4";
    public static final java.lang.String S5 = "5";
    public static final java.lang.String S6 = "6";
    public static final java.lang.String S7 = "7";
    public static final java.lang.String S8 = "8";
    public static final java.lang.String S9 = "9";
    public static final java.lang.String S0 = "0";

    // Y/N
    public static final java.lang.String Y = "Y";
    public static final java.lang.String N = "N";
    public static final java.lang.String A = "A";
    public static final java.lang.String R = "R";
    public static final java.lang.String C = "C";

    // logger value
    public static final java.lang.String LOG_KIHO = "================";
    public static final java.lang.String C10UiCheckActivityName = "C10UiCheckActivity";
    public static final java.lang.String Start = "start";
    public static final java.lang.String SPACE4 = "    ";
    public static final java.lang.String LOG_NOTI = "==>";

    public static final java.lang.String OBJECT_TYPE = "ObjectType";
    public static final java.lang.String OBJECT_ID = "ObjectId";
    public static final java.lang.String PROGRAM_ID = "ProgramId";
    public static final java.lang.String TIMESTAMP = "Timestamp";
    
    //LoopRouter Class 사용
	public static final String LOOP_CNT 	= "loop-cnt";
	public static final String DML_TYPE		= "dml-type";
	public static final String NEXT			= "next";
	public static final String ENDLOOP		= "endLoop";

}
