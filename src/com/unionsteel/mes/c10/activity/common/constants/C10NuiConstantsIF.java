/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : C10NuiConstantsIF.java
 * Change history
 * @LastModifyDate : 2011. 12. 05
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 05 김종범 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.common.constants;

/**
 * C10ConstantIF.java Class는 상수를 정의한 Interface이다. <xmp> C10 Activity 내에서 상수명에 대한
 * Naming Rule에 아래와 같이 접두어를 두었다. [C10PN_] : Property Name에 대한 약자로 Activity에서 지정한
 * Property의 이름에 대한 상수이다. [C10STR_] : 위의 경우를 제외한 일반적으로 사용되는 String type의 상수이다.
 * [NUM] : 숫자형 String type의 상수 이다. [COL_] : DB 컬럼명으로 사용되는 상수이다. [BIN] : 2진수형
 * String type의 상수 이다. [ERRCD_] : 에러코드의 상수이다. [TBN_VI_] : 테이블명 상수이다. </xmp>
 * 
 * @author 김종범
 * @version 1.0
 */

public interface C10NuiConstantsIF {

    // ###############################################
    // Active Property Name
    // ###############################################

    public static final String C10PN_PARAM = "param";
    public static final String C10PN_TXNAME = "txname";
    public static final String C10PN_MUTICREATE = "multiCreate";
    public static final String C10PN_BIND_RESULTS = "bind-results";
    public static final String C10PN_BIND_LIST = "bind-list";
    public static final String C10_CHECK_BIND = "check-bind";
    public static final String C10PN_RESULTKEY = "resultkey";
    public static final String C10PN_TCCODE = "tccode";
    public static final String C10PN_COLUMN_CT = "column-ct";
    public static final String C10PN_BIND_RESULT = "bind-result";
    public static final String C10PN_ERRORQUERY = "errorQuery";
    public static final String C10PN_PROSPECKIND = "prodSpecKind";
    public static final String C10PN_IFSPECKIND = "ifSpecKind";
    public static final String C10PN_COMPLETE_SQL = "complete_sql";
    public static final String C10PN_ERROR_SQL = "error_sql";
    public static final String C10PN_SELECT_SQL = "select_sql";
    public static final String C10PN_UPDATE_SQL = "update_sql";
    public static final String C10PN_UPDATE_SQL2 = "update_sql2";
    public static final String C10PN_INSERT_SQL = "insert_sql";
    public static final String C10PN_DELETE_SQL = "delete_sql";
    public static final String C10PN_INSERTQUERY = "insertQuery";
    public static final String C10PN_UPDATEQUERY = "updateQuery";
    public static final String C10PN_DELETEQUERY = "deleteQuery";
    public static final String C10PN_READDAO = "readDao";
    public static final String C10PN_SENDDAO = "sendDao";
    public static final String C10PN_EXISTCONDITION = "existCondition";
    public static final String C10PN_INSERT_PARAM_CT = "insert_param_ct";
    public static final String C10PN_UPDATE_PARAM_CT = "update_param_ct";
    public static final String C10PN_COMPLETE_PARAM_CT = "complete_param_ct";
    public static final String C10PN_ERROR_PARAM_CT = "error_param_ct";
    public static final String C10PN_INSERT_PARAM = "insert_param";
    public static final String C10PN_UPDATE_PARAM = "update_param";
    public static final String C10PN_ERROR_PARAM = "error_param";
    public static final String C10PN_COMPLETE_PARAM = "complete_param";
    public static final String C10PN_INSERT_BIND = "insert_bind";
    public static final String C10PN_UPDATE_BIND = "update_bind";
    public static final String C10PN_DELETE_BIND = "delete_bind";
    public static final String C10PN_INSERT_REBIND = "insert_rebind";
    public static final String C10PN_UPDATE_REBIND = "update_rebind";
    public static final String C10PN_DELETE_REBIND = "delete_rebind";
    public static final String C10PN_LAYOUT = "layout";
    public static final String C10PN_LIST = "list";
    public static final String C10PN_COLUMN = "column";
    public static final String C10PN_MD_RULE_NM = "MD_RULE_NM";
    public static final String C10PN_TC_CD = "TC_CD";
    public static final String C10PN_TRSM_FAC_TP = "TRSM_FAC_TP";
    public static final String C10PN_TRSM_PROC_TP = "TRSM_PROC_TP";
    public static final String C10PN_RCPTN_FAC_TP = "RCPTN_FAC_TP";
    public static final String C10PN_RCPTN_PROC_TP = "RCPTN_PROC_TP";
    public static final String C10PN_INFC_ID = "INFC_ID";
    public static final String C10PN_IF_MSG_TP = "IF_MSG_TP";
    public static final String C10PN_IF_MSG_SEQ = "IF_MSG_SEQ";
    public static final String C10PN_INFC_DATA_TP = "INFC_DATA_TP";
    public static final String C10PN_IF_MSG_LTH = "IF_MSG_LTH";
    public static final String C10PN_BAS_TP = "BAS_TP";
    public static final String C10PN_TBL_NM = "TBL_NM";
    public static final String C10PN_VIEW_NM = "VIEW_NM";
    public static final String C10PN_BAS_CNDTN_NO = "BAS_CNDTN_NO";
    public static final String C10PN_GROUPID = "groupId";
    public static final String C10PN_PARAM_COUNT = "param-count";
    public static final String C10PN_PAGESIZE = "pagesize";
    public static final String C10PN_PAGE = "page";
    public static final String C10PN_CUR_PAGE_NAME = "cur-page-name";
    public static final String C10PN_CURPAGE = "curPage";
    public static final String C10PN_SQLKEY = "sqlkey";
    public static final String C10PN_SQLKEY1 = "sqlkey1";
    public static final String C10PN_SQLKEY2 = "sqlkey2";
    public static final String C10PN_LIST_KEY = "list-key";
    public static final String C10PN_ISAUDIT = "isAudit";
    public static final String C10PN_CHKID = "checkId";
    public static final String C10PN_EXITFLAG = "exitFlag";
    public static final String C10PN_RULLID = "ruleId";
    public static final String C10PN_KEY = "KEY";
    public static final String C10PN_VALUE = "VALUE";
    public static final String C10PN_CODENAME = "codename";
    public static final String C10PN_CATEGORY = "category";
    public static final String C10PN_TOTALCODE = "totalCode";
    public static final String C10PN_ADDITIONALKEY = "additionalKey";
    public static final String C10PN_ADDITIONALVALUE = "additionalValue";
    public static final String C10PN_SORTCOLUMN = "sortColumn";
    public static final String C10PN_ACCENDING = "accending";
    public static final String C10PN_ORDERBY = "orderby";
    public static final String C10PN_SAVERESULT = "saveResult";
    public static final String C10PN_LOADRESULT = "loadResult";
    public static final String C10PN_CLR_USE_N_CNT = "CLR_USE_N_CNT";

    /******************* 일반 상수[ActivityUtil] *************************************************/
    /* string형 일반 상수 */
    public static final String STR_BLANK = "";
    public static final String STR_MES_MESSAGE = "mes_message";

    /******************* Activity의 Property Value에 사용되는 상수[ActivityUtil] ******************/
    public static final String PV_NULL = "#null"; // 의미상 null을 의미하는 값
    public static final String PV_NOT_NULL = "#notnull"; // 의미상 null을 의미하는 값
    public static final String PV_BLANK = "#blank"; // 의미상 ' '를 의미하는 값
    public static final String PV_ALL = "#all"; // 의미상 모든 케이스(else)를 의미하는
    public static final String PV_STRING = "STRING";
    public static final String PV_NUMBER = "NUMBER";

    // #################################################
    // 일반 문자형
    // #################################################

    /** 규격약호 첫두자리 */
    public static final String SPC_AVR_KS = "KS"; // KS
    public static final String SPC_AVR_JS = "JS"; // JS

    /** 고객요청압연두께단위 */
    public static final String UNIT_CRN = "CRN"; // 보정값
    public static final String UNIT_TRK = "TRK"; // 확정값
    public static final String UNIT_PCN = "PCN"; // 보정율

    /** 주문EDGE지정구분 C S */
    public static final String SLIT_EDGE = "S"; // uni
    public static final String MILL_EDGE = "M"; // uni
    public static final String COIL_EDGE = "C"; // uni
    public static final String NO_SLIT = "N"; // uni

    /** 제품형태 C S */
    public static final String PRD_SHP_COIL = "C"; // uni
    public static final String PRD_SHP_SHEET = "S"; // uni
    
    /** COIL 내경 508 */
    public static final String ORD_COIL_ID_508 = "508"; // 내경표준사이즈  
    public static final String ORD_THK_TP_3 = "3"; // 주문두께구분_칼라TCT     

    /** 품질설계자동확정구분 */
    public static final String QLT_DSN_CFM_TP_A = "A"; // 자동확정
    public static final String QLT_DSN_CFM_TP_M = "M"; // 수동확정
    
    /** OMS 품질설계자동확정구분 */
    public static final String ORD_DSN_CFM_TP_A = "A"; // 자동확정

    /** 품질설계상태 */
    public static final String QLT_DSN_STS_CD_A = "A"; // 확정
    public static final String QLT_DSN_STS_CD_B = "B"; // 확정대기
    public static final String QLT_DSN_STS_CD_E = "E"; // 에러
    public static final String QLT_DSN_STS_CD_X = "X"; // 종료
    
    /** 주문유형 */
    public static final String ORD_KND_ZRE1 = "ZRE1"; //주문유형이 반품

    /** 품명코드 */
    public static final String PRD_NM_CD_1 = "1"; // CCI
    public static final String PRD_NM_CD_2 = "2"; // CCEI
    public static final String PRD_NM_CD_3 = "3"; // CCGI
    public static final String PRD_NM_CD_4 = "4"; // CCLI
    public static final String PRD_NM_CD_5 = "5"; // CCAI
    public static final String PRD_NM_CD_6 = "6"; // CCGX (구, CCVI)
    public static final String PRD_NM_CD_7 = "7"; // CCUS
    public static final String PRD_NM_CD_8 = "8"; // CCNI
    //public static final String PRD_NM_CD_9 = "9"; // 포장재
    public static final String PRD_NM_CD_9 = "9"; // CCLX 
    public static final String PRD_NM_CD_A = "A"; // P/O Skin Pass
    public static final String PRD_NM_CD_B = "B"; // P/O No Skin Pass
    public static final String PRD_NM_CD_C = "C"; // CR
    public static final String PRD_NM_CD_D = "D"; // F/H
    public static final String PRD_NM_CD_E = "E"; // EGI
    public static final String PRD_NM_CD_G = "G"; // GI
    public static final String PRD_NM_CD_H = "H"; // Hot Coil
    public static final String PRD_NM_CD_J = "J"; // G/A
    public static final String PRD_NM_CD_K = "K"; // Hot GI
    public static final String PRD_NM_CD_L = "L"; // G/L
    public static final String PRD_NM_CD_N = "N"; // ZnNi
    public static final String PRD_NM_CD_S = "S"; // SUS
    public static final String PRD_NM_CD_U = "U"; // Aluminum
    public static final String PRD_NM_CD_V = "V"; // GIX
    public static final String PRD_NM_CD_W = "W"; // GLX
    public static final String PRD_NM_CD_X = "X"; // HR SKELP

    /** 공정코드 */
    public static final String PROC_CD_5CGL = "85";
    public static final String PROC_CD_4CGL = "84";
    public static final String PROC_CD_3CGL = "83";
    public static final String PROC_CD_2CGL = "82";
    public static final String PROC_CD_TM = "51";
    public static final String PROC_CD_2RM = "22";
    public static final String PROC_CD_PLTCM = "1P";
    public static final String PROC_CD_3ECL = "33";
    public static final String PROC_CD_4ANN = "44";
    public static final String PROC_CD_3ANN = "43";
    public static final String PROC_CD_2EGL = "92";
    public static final String PROC_CD_EGL = "91";
    public static final String PROC_CD_7CCL = "A7";
    public static final String PROC_CD_6CCL = "A6";
    public static final String PROC_CD_5CCL = "A5";
    public static final String PROC_CD_4CCL = "A4";
    public static final String PROC_CD_3CCL = "A3";
    public static final String PROC_CD_2CCL = "A2";
    public static final String PROC_CD_O_RHL = "RO";
    public static final String PROC_CD_PACKING = "PK";
    public static final String PROC_CD_NKK = "NK";
    public static final String PROC_CD_D_CPL = "D1";
    public static final String PROC_CD_S_R_S = "C3";
    public static final String PROC_CD_S_SHL = "C1";
    public static final String PROC_CD_UCCL = "AU";
    public static final String PROC_CD_BCCL = "AB";
    public static final String PROC_CD_ACCL = "AA";
    public static final String PROC_CD_EG_H = "99";
    public static final String PROC_CD_OCGL = "8O";
    public static final String PROC_CD_GOR_S = "7Z";
    public static final String PROC_CD_OR_S = "7O";
    public static final String PROC_CD_RHL = "7A";
    public static final String PROC_CD_O_SLI = "79";
    public static final String PROC_CD_5R_S = "77";
    public static final String PROC_CD_4R_S = "76";
    public static final String PROC_CD_H_S = "75";
    public static final String PROC_CD_2R_S = "74";
    public static final String PROC_CD_2RCL = "72";
    public static final String PROC_CD_GOSHL = "6Z";
    public static final String PROC_CD_OSHL = "6O";
    public static final String PROC_CD_BSHL = "6B";
    public static final String PROC_CD_ASHL = "6A";
    public static final String PROC_CD_7SHL = "68";
    public static final String PROC_CD_6SHL = "67";
    public static final String PROC_CD_5SHL = "66";
    public static final String PROC_CD_4SHL = "65";
    public static final String PROC_CD_3SHL = "63";
    public static final String PROC_CD_H_ANN = "41";
    public static final String PROC_CD_WJ_RHL = "RO";
    public static final String PROC_CD_WJ_PACKING = "PO";
    public static final String PROC_CD_1EGL = "91";
    public static final String PROC_CD_WJ_CGL = "8O";
    public static final String PROC_CD_WJ_R_S = "7O";
    public static final String PROC_CD_WJ_SHL = "6O";
    public static final String PROC_CD_INS_SHL = "6I";
    public static final String PROC_CD_3ARP = "3A";
    public static final String PROC_CD_2R_Shop = "2R";
    public static final String PROC_CD_1R_Shop = "1R";

    /** 문자열 () : */
    public static final String C10STR_COLON = ":"; // uni

    public static final String C10_AD_MEMBER = "AD_MEMBER";

    public static final String C10STR_KEY = "key";
    /** 문자열 u */
    public static final String C10STR_U = "u";
    /** 문자열 i */
    public static final String C10STR_I = "i";
    /** 문자열 d */
    public static final String C10STR_D = "d";
    /** 문자열 loop */
    public static final String C10STR_LOOP = "loop";
    /** 문자열 mesdao */
    public static final String C10STR_MESDAO = "mesdao";
    /** 문자열 eaidao */
    public static final String C10STR_EAIDAO = "eaidao";
    /** 문자열 ROWCT Row Count를 의미함 */
    public static final String C10STR_ROWCT = "ROWCT";
    /** 문자열 pageEvent */
    public static final String C10STR_PAGEEVENT = "pageEvent";
    /** 문자열 rowStuts Row 상태를 의미함 */
    public static final String C10STR_ROWSTATUS = "rowStuts";
    /** 문자열 loop-count */
    public static final String C10STR_LOOP_COUNT = "loop-count";
    /** 테이블명 */
    public static final String C10STR_TNAME = "tname";
    /** TYPE */
    public static final String C10STR_TYPE = "type";
    /** UI */
    public static final String C10STR_UI = "UI";
    /** RECEIVE */
    public static final String C10STR_RECEIVE = "RECEIVE";
    /** localhost */
    public static final String C10STR_LOCALHOST = "200.1.6.210";
    /** ServiceName */
    public static final String C10STR_SERVICENAME = "ServiceName";
    /** errorMsg */
    public static final String C10STR_ERRMSG = "errormsg";
    /** java.lang */
    public static final String C10STR_JAVA_LANG = "java.lang";
    /** NUI */
    public static final String C10STR_NUI = "NUI";
    /** 문자열 INQRY_AUTO_EXAM_CD */
    public static final String C10STR_INQRY_AUTO_EXAM_CD = "INQRY_AUTO_EXAM_CD";
    /** 문자열 A */
    public static final String C10STR_A = "A";
    /** 문자열 Y */
    public static final String C10STR_YES = "Y";
    /** 문자열 Q */
    public static final String C10STR_Q = "Q";
    /** 문자열 N */
    public static final String C10STR_NO = "N";
    /** 문자열 X */
    public static final String C10STR_X = "X";
    /** 문자열 R */
    public static final String C10STR_R = "R";
    /** 문자열 Z */
    public static final String C10STR_Z = "Z";
    /** 문자열 L */
    public static final String C10STR_L = "L";
    /** 문자열 U */
    public static final String C10STR_BU = "U";
    /** 문자열 C 계산코드 */
    public static final String C10STR_CD_C = "C";
    /** 문자열 P 계산코드 */
    public static final String C10STR_CD_P = "P";
    /** 문자열 L 계산코드 */
    public static final String C10STR_CD_L = "L";
    /** 문자열 Z 계산코드 */
    public static final String C10STR_CD_Z = "Z";
    /** 문자열 T 공차코드 */
    public static final String C10STR_TOLCD_T = "T";
    /** 문자열 W 공차코드 */
    public static final String C10STR_TOLCD_W = "W";
    /** 문자열 A */
    public static final String C10STR_BAS_TP_A = "A";
    /** 문자열 B */
    public static final String C10STR_BAS_TP_B = "B";
    /** 알파벳 G */
    public static final String C10STR_CD_G = "G";
    /** 문자열 UPR 상한을 의미함 */
    public static final String C10STR_UPR = "UPR";
    /** 문자열 LOW 하한을 의미함 */
    public static final String C10STR_LOW = "LOW";
    /** 문자열 RESULT_VALUE 값을 의미함 */
    public static final String C10STR_RESULT_VALUE = "RESULT_VALUE";
    /** 문자열 CALC_SIGN 계산부호을 의미함 */
    public static final String C10STR_CALC_SIGN = "CALC_SIGN";
    /** 문자열 CMBR 캠버를 의미함 */
    public static final String C10STR_CMBR = "CMBR";
    /** 문자열 MIX_ 합성을 의미함 */
    public static final String C10STR_MIX = "MIX_";
    /** 문자열 C10 */
    public static final String C10STR_C10 = "C10";
    /** 문자열 A11 */
    public static final String C10STR_A11 = "A11";
    /** 문자열 A13 */
    public static final String C10STR_A13 = "A13";
    /** 문자열 TB_C10_ */
    public static final String C10STR_TB_C10_ = "TB_C10_";
    /** 문자열 TB_M13_ */
    public static final String C10STR_TB_M13_ = "TB_M13_";
    /** 문자열 COLUMN_NAME 칼럼명을 의미함 */
    public static final String C10STR_COLUMN_NAME = "COLUMN_NAME";
    /** 문자열 CNAME 칼럼명을 의미함 */
    public static final String C10STR_CNAME = "CNAME";
    /** 문자열 COMMENTS 코멘트을 의미함 */
    public static final String C10STR_COMMENTS = "COMMENTS";
    /** 문자열 RK_COMMENT 코멘트의 resultkey을 의미함 */
    public static final String C10STR_RK_COMMENT = "RK_COMMENT";

    /** 문자열 QLT_DSGN_ERR_CD 설계에러코드를 의미함 */
    public static final String C10STR_QLT_DSN_ERR_CD = "QLT_DSN_ERR_CD";
    /** 문자열 ERRMSG 주문에러메시지 의미함 */
    public static final String C10STR_ErrMsg = "ERRMSG";

    /** 문자열 null을 의미함 */
    public static final String C10STR_NULL = "null";
    /** 문자열 order by 동적 order by를 만들때 쓰인다 */
    public static final String C10STR_QRY_ORDERBY = "order by";
    /** 문자열 ERR_MSG 에러메세지를 의미함 */
    public static final String C10STR_ERR_MSG = "ERR_MSG";
    /** 문자열 C10ERR_MSG C10 에러메세지를 의미함 */
    public static final String C10STR_C10ERR_MSG = "C10ERR_MSG";
    /** 주문에러체크 메세지 */
    public static final String C10STR_ORD_ERR_CD = "ORD_ERR_CD";
    /** 문자열 "" 공백을 의미함 */
    public static final String C10STR_SPACE = "";
    /** 문자열 " " 1칸 공백을 의미함 */
    public static final String C10STR_SPACE1 = " ";
    /** 문자열 "  " 2칸 공백을 의미함 */
    public static final String C10STR_SPACE2 = "  ";
    /** 문자열 updateCt Update Count를 의미함 */
    public static final String C10STR_UPDATECT = "updateCt";
    /** 문자열 insertCt Insert Count를 의미함 */
    public static final String C10STR_INSERTCT = "insertCt";
    /** 문자열 deleteCt Delete Count를 의미함 */
    public static final String C10STR_DELETECT = "deleteCt";
    /** 문자열 PROD_SPEC_DSGN_KIND */
    public static final String C10STR_PROD_SPEC_DSGN_KIND = "PROD_SPEC_DSGN_KIND";
    /** 문자열 P_ERR_KEY */
    public static final String C10STR_P_ERR_KEY = "P_ERR_KEY";
    /** 문자열 id */
    public static final String C10STR_ID = "id";
    /** 문자열 datatype */
    public static final String C10STR_DATETYPE = "datatype";
    /** 문자열 STRING */
    public static final String C10STR_STRING = "STRING";
    /** 문자열 NUMBER */
    public static final String C10STR_NUMBER = "NUMBER";
    /** 문자열 DATE */
    public static final String C10STR_DATE = "DATE";
    /** 문자열* */
    public static final String C10STR_STAR = "*";
    /** 문자열 % */
    public static final String C10STR_PERC = "%";
    /** 문자열 + */
    public static final String C10STR_PLUS = "+";
    /** 문자열 - */
    public static final String C10STR_MINUS = "-";
    /** 문자열 \\/ */
    public static final String C10STR_SLUSH = "\\/";
    /** 문자열 / */
    public static final String C10STR_NSLUSH = "/";
    /** 문자열 () : */
    public static final String C10STR_MIXSIGN = "() : ";
    /** 문자열 . */
    public static final String C10STR_DOT = ".";
    /** 문자열 \\. */
    public static final String C10STR_EXP_DOT = "\\.";
    /** 문자열 \\| */
    public static final String C10STR_REGULAR_EXP_PIPE = "\\|";
    /** 문자열 @ */
    public static final String C10STR_AT = "@";
    /** 문자열 # */
    public static final String C10STR_SHAP = "#";
    /** 문자열 TIME */
    public static final String PER_TIME = "%TIME";
    /** 문자열 , */
    public static final String C10STR_COMMA = ",";
    /** 문자열 \n */
    public static final String C10STR_ENTER = "\n";
    /** 문자열 nodata */
    public static final String C10STR_NODATA = "nodata";
    /** 문자열 C */
    public static final String C10STR_C = "C";
    /** 문자열 AL */
    public static final String C10STR_AL = "AL";
    /** 문자열 SI */
    public static final String C10STR_SI = "SI";
    /** 문자열 MN */
    public static final String C10STR_MN = "MN";
    /** 문자열 P */
    public static final String C10STR_P = "P";
    /** 문자열 S */
    public static final String C10STR_S = "S";
    /** 문자열 SOL_AL */
    public static final String C10STR_SOL_AL = "SOL_AL";
    /** 문자열 TOT_AL */
    public static final String C10STR_TOT_AL = "TOT_AL";
    /** 문자열 CU */
    public static final String C10STR_CU = "CU";
    /** 문자열 NB */
    public static final String C10STR_NB = "NB";
    /** 문자열 B */
    public static final String C10STR_B = "B";
    /** 문자열 NI */
    public static final String C10STR_NI = "NI";
    /** 문자열 CR */
    public static final String C10STR_CR = "CR";
    /** 문자열 MO */
    public static final String C10STR_MO = "MO";
    /** 문자열 W */
    public static final String C10STR_W = "W";
    /** 문자열 TI */
    public static final String C10STR_TI = "TI";
    /** 문자열 V */
    public static final String C10STR_V = "V";
    /** 문자열 ZR */
    public static final String C10STR_ZR = "ZR";
    /** 문자열 PB */
    public static final String C10STR_PB = "PB";
    /** 문자열 PB */
    public static final String C10STR_SN = "SN";
    /** 문자열 AS */
    public static final String C10STR_AS = "AS";
    /** 문자열 CA */
    public static final String C10STR_CA = "CA";
    /** 문자열 CO */
    public static final String C10STR_CO = "CO";
    /** 문자열 MG */
    public static final String C10STR_MG = "MG";
    /** 문자열 TE */
    public static final String C10STR_TE = "TE";
    /** 문자열 BI */
    public static final String C10STR_BI = "BI";
    /** 문자열 SB */
    public static final String C10STR_SB = "SB";
    /** 문자열 ZN */
    public static final String C10STR_ZN = "ZN";
    /** 문자열 H */
    public static final String C10STR_H = "H";
    /** 문자열 N */
    public static final String C10STR_N = "N";
    /** 문자열 O */
    public static final String C10STR_O = "O";
    /** 문자열 CEQ */
    public static final String C10STR_CEQ = "CEQ";
    /** 문자열 PCM */
    public static final String C10STR_PCM = "PCM";
    /** 문자열 CPD_ELMNT_1 */
    public static final String C10STR_CPD_ELMNT_1 = "CPD_ELMNT_1";
    /** 문자열 CPD_ELMNT_2 */
    public static final String C10STR_CPD_ELMNT_2 = "CPD_ELMNT_2";
    /** 문자열 CPD_ELMNT_3 */
    public static final String C10STR_CPD_ELMNT_3 = "CPD_ELMNT_3";
    /** 문자열 CPD_ELMNT_4 */
    public static final String C10STR_CPD_ELMNT_4 = "CPD_ELMNT_4";
    /** 문자열 CPD_ELMNT_5 */
    public static final String C10STR_CPD_ELMNT_5 = "CPD_ELMNT_5";
    /** 문자열 CPD_ELMNT_6 */
    public static final String C10STR_CPD_ELMNT_6 = "CPD_ELMNT_6";
    /** 문자열 CPD_ELMNT_7 */
    public static final String C10STR_CPD_ELMNT_7 = "CPD_ELMNT_7";
    /** 문자열 TNST_YP */
    public static final String C10STR_TNST_YP = "TNST_YP";
    /** 문자열 TNST_TS */
    public static final String C10STR_TNST_TS = "TNST_TS";
    /** 문자열 TNST_EL */
    public static final String C10STR_TNST_EL = "TNST_EL";
    /** 문자열 TNST_YR */
    public static final String C10STR_TNST_YR = "TNST_YR";
    /** 문자열 TNST_RA */
    public static final String C10STR_TNST_RA = "TNST_RA";
    /** 문자열 TNST_YP_EL */
    public static final String C10STR_TNST_YP_EL = "TNST_YP_EL";
    /** 문자열 TNST_N */
    public static final String C10STR_TNST_N = "TNST_N";
    /** 문자열 IMPC_TST */
    public static final String C10STR_IMPC_TST = "IMPC_TST";
    /** 문자열 IMPC_TST_AVG */
    public static final String C10STR_IMPC_TST_AVG = "IMPC_TST_AVG";
    /** 문자열 IMPC_TST_EMINV */
    public static final String C10STR_IMPC_TST_EMINV = "IMPC_TST_EMINV";
    /** 문자열 HRDNS_TST */
    public static final String C10STR_HRDNS_TST = "HRDNS_TST";
    /** 문자열 GSTST_FGS */
    public static final String C10STR_GSTST_FGS = "GSTST_FGS";
    /** 문자열 GSTST_AGS */
    public static final String C10STR_GSTST_AGS = "GSTST_AGS";
    /** 문자열 NIT */
    public static final String C10STR_NIT = "NIT";
    /** 문자열 NIT_MAX_LTH */
    public static final String C10STR_NIT_MAX_LTH = "NIT_MAX_LTH";
    /** 문자열 NIT_MAX_WDT */
    public static final String C10STR_NIT_MAX_WDT = "NIT_MAX_WDT";
    /** 문자열 DWTT_SWSR */
    public static final String C10STR_DWTT_SWSR = "DWTT_SWSR";
    /** 문자열 DWTT_SWSR_AVG */
    public static final String C10STR_DWTT_SWSR_AVG = "DWTT_SWSR_AVG";
    /** 문자열 HIC_BL_AR_RT */
    public static final String C10STR_HIC_BL_AR_RT = "HIC_BL_AR_RT";
    /** 문자열 HIC_BL_ON1_SIZE_RNG */
    public static final String C10STR_HIC_BL_ON1_SIZE_RNG = "HIC_BL_ON1_SIZE_RNG";
    /** 문자열 HIC_BL_ON1 */
    public static final String C10STR_HIC_BL_ON1 = "HIC_BL_ON1";
    /** 문자열 HIC_BL_ON2_SIZE_RNG */
    public static final String C10STR_HIC_BL_ON2_SIZE_RNG = "HIC_BL_ON2_SIZE_RNG";
    /** 문자열 HIC_BL_ON2 */
    public static final String C10STR_HIC_BL_ON2 = "HIC_BL_ON2";
    /** 문자열 HIC_BL_ON3_SIZE_RNG */
    public static final String C10STR_HIC_BL_ON3_SIZE_RNG = "HIC_BL_ON3_SIZE_RNG";
    /** 문자열 HIC_BL_OCR_NO_3 */
    public static final String C10STR_HIC_BL_OCR_NO_3 = "HIC_BL_OCR_NO_3";
    /** 문자열 HIC_CLR */
    public static final String C10STR_HIC_CLR = "HIC_CLR";
    /** 문자열 HIC_CLR_SMP_AVG */
    public static final String C10STR_HIC_CLR_SMP_AVG = "HIC_CLR_SMP_AVG";
    /** 문자열 HIC_CLR_TOT_AVG */
    public static final String C10STR_HIC_CLR_TOT_AVG = "HIC_CLR_TOT_AVG";
    /** 문자열 HIC_CSR */
    public static final String C10STR_HIC_CSR = "HIC_CSR_SMP_AVG";
    /** 문자열 HIC_CSR_SMP_AVG */
    public static final String C10STR_HIC_CSR_SMP_AVG = "HIC_CSR_SMP_AVG";
    /** 문자열 HIC_CSR_TOT_AVG */
    public static final String C10STR_HIC_CSR_TOT_AVG = "HIC_CSR_TOT_AVG";
    /** 문자열 HIC_CTR */
    public static final String C10STR_HIC_CTR = "HIC_CTR";
    /** 문자열 HIC_CTR_SMP_AVG */
    public static final String C10STR_HIC_CTR_SMP_AVG = "HIC_CTR_SMP_AVG";
    /** 문자열 HIC_CTR_TOT_AVG */
    public static final String C10STR_HIC_CTR_TOT_AVG = "HIC_CTR_TOT_AVG";
    /** 문자열 HIC_ETC */
    public static final String C10STR_HIC_ETC = "HIC_ETC";
    /** 문자열 HIC_ETC_SMP_AVG */
    public static final String C10STR_HIC_ETC_SMP_AVG = "HIC_ETC_SMP_AVG";
    /** 문자열 HIC_ETC_TOT_AVG */
    public static final String C10STR_HIC_ETC_TOT_AVG = "HIC_ETC_TOT_AVG";
    /** 문자열 HTTST_YP */
    public static final String C10STR_HTTST_YP = "HTTST_YP";
    /** 문자열 HTTST_YP_EM */
    public static final String C10STR_HTTST_YP_EM = "HTTST_YP_EM";
    /** 문자열 HTTST_YP_AVG */
    public static final String C10STR_HTTST_YP_AVG = "HTTST_YP_AVG";
    /** 문자열 HTTST_TNSL_STRGH_EM */
    public static final String C10STR_HTTST_TNSL = "HTTST_TNSL";
    /** 문자열 HTTST_TNSL_STRGH_EM */
    public static final String C10STR_HTTST_TNSL_STRGH_EM = "HTTST_TNSL_STRGH_EM";
    /** 문자열 HTTST_TS_AVG */
    public static final String C10STR_HTTST_TS_AVG = "HTTST_TS_AVG";
    /** 문자열 HTTST_EL */
    public static final String C10STR_HTTST_EL = "HTTST_EL";
    /** 문자열 HTTST_EL_EM */
    public static final String C10STR_HTTST_EL_EM = "HTTST_EL_EM";
    /** 문자열 HTTST_EL_AVG */
    public static final String C10STR_HTTST_EL_AVG = "HTTST_EL_AVG";
    /** 문자열 VFT */
    public static final String C10STR_VFT = "VFT";
    /** 문자열 PDTST_1 */
    public static final String C10STR_PDTST_1 = "PDTST_1";
    /** 문자열 PDTST_2 */
    public static final String C10STR_PDTST_2 = "PDTST_2";
    /** 문자열 PDTST_3 */
    public static final String C10STR_PDTST_3 = "PDTST_3";
    /** 문자열 IMPC_TST_RT_AVG */
    public static final String C10STR_IMPC_TST_RT_AVG = "IMPC_TST_RT_AVG";
    /** 문자열 TNST */
    public static final String C10STR_TNST = "TNST";
    /** 문자열 WND */
    public static final String C10STR_WND = "WND";
    /** 문자열 IMPC */
    public static final String C10STR_IMPC = "IMPC";
    /** 문자열 HRDNS */
    public static final String C10STR_HRDNS = "HRDNS";
    /** 문자열 CLNG_MTH_A */
    public static final String C10STR_CLNG_MTH_A = "A";
    /** 문자열 BATCH_JOB */
    public static final String C10STR_BATCH_JOB = "BATCH_JOB";
    /** 문자열 true */
    public static final String C10STR_TRUE = "true";
    /** 문자열 countName */
    public static final String C10STR_COUNTNAME = "countName";
    /** 문자열 exit */
    public static final String C10STR_EXIT = "exit";
    /** 문자열 sp_null */
    public static final String C10STR_SP_NULL = "sp_null";
    /** 문자열 UPR_DES02 규격상한을 의미함 */
    public static final String C10STR_UPR_DES02 = "UPR_DES02";
    /** 문자열 LOW_DES02 규격하한을 의미함 */
    public static final String C10STR_LOW_DES02 = "LOW_DES02";
    /** 문자열 UPR_DES01 고객상한을 의미함 */
    public static final String C10STR_UPR_DES01 = "UPR_DES01";
    /** 문자열 LOW_DES01 고객하한을 의미함 */
    public static final String C10STR_LOW_DES01 = "LOW_DES01";
    /** 문자열 UPR_DES03 사내상한을 의미함 */
    public static final String C10STR_UPR_DES03 = "UPR_DES03";
    /** 문자열 LOW_DES03 사내하한을 의미함 */
    public static final String C10STR_LOW_DES03 = "LOW_DES03";
    /** 문자열 UPR_DES04 합성상한을 의미함 */
    public static final String C10STR_UPR_DES04 = "UPR_DES04";
    /** 문자열 LOW_DES04 합성하한을 의미함 */
    public static final String C10STR_LOW_DES04 = "LOW_DES04";
    /** 문자열 UPR_DES05 출강목표상한을 의미함 */
    public static final String C10STR_UPR_DES05 = "UPR_DES05";
    /** 문자열 LOW_DES05 출강목표하한 의미함 */
    public static final String C10STR_LOW_DES05 = "LOW_DES05";
    /** 문자열 LOW_DES0 */
    public static final String C10STR_LOW_DES0 = "LOW_DES0";
    /** 문자열 UPR_DES0 */
    public static final String C10STR_UPR_DES0 = "UPR_DES0";
    /** 문자열 두께 */
    public static final String C10STR_THK = "THK";
    /** 문자열 폭 */
    public static final String C10STR_WDT = "WDT";
    /** 문자열 길이 */
    public static final String C10STR_LTH = "LTH";

    public static final String C10STR_SQRNS = "SQRNS";

    public static final String C10STR_PRPND = "PRPND";

    public static final String C10STR_BUR = "BUR";

    public static final String C10STR_TLSCP = "TLSCP";

    public static final String C10STR_ATE = "ATE";

    public static final String C10STR_ANE = "ANE";

    public static final String C10STR_NE = "NE";

    public static final String C10STR_EX = "EX";

    public static final String C10STR_EX1 = "EX1";

    public static final String C10STR_YP = "YP";

    public static final String C10STR_YT = "YT";

    public static final String C10STR_YS = "YS";

    public static final String C10STR_TOTAL = "-전체-";

    public static final String C10STR_LABEL = "label";

    public static final String C10STR_VALUE = "value";

    public static final String OVERLAP = "overlap";

    public static final String C10PREFIX_DBS = "DBS_";

    /** 문자열 INS_UPD_A */
    public static final String C10STR_INS_UPD_A = "INS_UPD_A";
    /** 문자열 INS_UPD_B */
    public static final String C10STR_INS_UPD_B = "INS_UPD_B";

    // ################################################
    // 에러코드_범
    // ################################################

    public static final String ERRCD_O011 = "O011"; // 주문번호 : 값이 누락되었습니다
    public static final String ERRCD_O012 = "O012"; // 주문행번 : 값이 누락되었습니다
    public static final String ERRCD_O013 = "O013"; // 플랜트구분 : 정의 안된 코드입니다
    public static final String ERRCD_O014 = "O014"; // 품명코드 : 정의 안된 코드입니다
    public static final String ERRCD_O015 = "O015"; // 제품형태 : 정의 안된 코드입니다
    public static final String ERRCD_O016 = "O016"; // 유통경로 : 정의 안된 코드입니다
    public static final String ERRCD_O017 = "O017"; // 주문종류 : 정의 안된 코드입니다
    public static final String ERRCD_O018 = "O018"; // 주문제품등급 : 정의 안된 코드입니다
    public static final String ERRCD_O019 = "O019"; // 주문용도코드 : 정의 안된 코드입니다
    public static final String ERRCD_O020 = "O020"; // 고객사코드 : 정의 안된 코드입니다
    public static final String ERRCD_O021 = "O021"; // 고객사양서번호 : 정의 안된 코드입니다
    public static final String ERRCD_O022 = "O022"; // 규격기관 : 정의 안된 코드입니다
    public static final String ERRCD_O023 = "O023"; // 규격약호 : 정의 안된 코드입니다
    public static final String ERRCD_O024 = "O024"; // 규격년도 : 정의 안된 코드입니다
    public static final String ERRCD_O025 = "O025"; // 주문생칫수 : 값이 누락되었습니다
    public static final String ERRCD_O026 = "O026"; // 주문환산두께 : 값이 누락되었습니다
    public static final String ERRCD_O027 = "O027"; // 주문환산폭 : 값이 누락되었습니다
    public static final String ERRCD_O028 = "O028"; // 주문환산길이 : 값이 누락되었습니다
    public static final String ERRCD_O029 = "O029"; // 주문납기시작일 : 값이 누락되었습니다
    public static final String ERRCD_O030 = "O030"; // 주문납기종료일 : 값이 누락되었습니다
    public static final String ERRCD_O031 = "O031"; // 도금량지정코드 : 정의 안된 코드입니다
    public static final String ERRCD_O032 = "O032"; // 색상코드전면 : 정의 안된 코드입니다
    public static final String ERRCD_O033 = "O033"; // 색상코드후면 : 정의 안된 코드입니다
    public static final String ERRCD_O034 = "O034"; // 주문원판규격약호 : 정의 안된 코드입니다
    public static final String ERRCD_O035 = "O035"; // 주문표면조건 : 정의 안된 코드입니다
    public static final String ERRCD_O036 = "O036"; // 주문권취방법 : 정의 안된 코드입니다
    public static final String ERRCD_O037 = "O037"; // 주문표면처리코드 : 정의 안된 코드입니다
    public static final String ERRCD_O038 = "O038"; // 주문조질도 : 정의 안된 코드입니다
    public static final String ERRCD_O039 = "O039"; // 중량결정법구분 : 정의 안된 코드입니다
    public static final String ERRCD_O040 = "O040"; // 주문내경링종류구분 : 정의 안된 코드입니다
    public static final String ERRCD_O041 = "O041"; // EMBOSS무늬 : 정의 안된 코드입니다
    public static final String ERRCD_O042 = "O042"; // 주문보호필름코드 : 정의 안된 코드입니다
    public static final String ERRCD_O043 = "O043"; // 주문행번중량 : 값이 누락되었습니다
    public static final String ERRCD_O044 = "O044"; // 주문포장Sheet매수 : 값이 누락되었습니다
    public static final String ERRCD_O045 = "O045"; // 주문포장단중하한값 : 값이 누락되었습니다
    public static final String ERRCD_O046 = "O046"; // 주문포장단중상한값 : 값이 누락되었습니다
    public static final String ERRCD_O047 = "O047"; // 주문인도허용차하한값 : 값이 누락되었습니다
    public static final String ERRCD_O048 = "O048"; // 주문인도허용차상한값 : 값이 누락되었습니다
    public static final String ERRCD_O049 = "O049"; // 주문포장길이하한값 : 값이 누락되었습니다
    public static final String ERRCD_O050 = "O050"; // 주문포장길이상한값 : 값이 누락되었습니다
    public static final String ERRCD_O051 = "O051"; // 주문정포장하한값 : 값이 누락되었습니다
    public static final String ERRCD_O052 = "O052"; // 주문정포장상한값 : 값이 누락되었습니다
    public static final String ERRCD_O053 = "O053"; // 주문정포장매수하한값 : 값이 누락되었습니다
    public static final String ERRCD_O054 = "O054"; // 주문정포장매수상한값 : 값이 누락되었습니다
    public static final String ERRCD_O055 = "O055"; // 주문포장당매수 : 값이 누락되었습니다
    public static final String ERRCD_O056 = "O056"; // 주문포장당중량 : 값이 누락되었습니다
    public static final String ERRCD_O057 = "O057"; // 주문소포장중량 : 값이 누락되었습니다
    public static final String ERRCD_O058 = "O058"; // 주문소포장혼입율 : 값이 누락되었습니다
    public static final String ERRCD_O059 = "O059"; // 주문단위중량 : 값이 누락되었습니다
    public static final String ERRCD_O060 = "O060"; // 주문포장방법 : 값이 누락되었습니다
    public static final String ERRCD_O061 = "O061"; // 주문코일내경 : 값이 누락되었습니다
    public static final String ERRCD_O062 = "O062"; // 주문코일외경 : 값이 누락되었습니다
    public static final String ERRCD_O063 = "O063"; // 주문두께공차상한값 : 값이 누락되었습니다
    public static final String ERRCD_O064 = "O064"; // 주문두께공차하한값 : 값이 누락되었습니다
    public static final String ERRCD_O065 = "O065"; // 주문폭공차하한값 : 값이 누락되었습니다
    public static final String ERRCD_O066 = "O066"; // 주문폭공차상한값 : 값이 누락되었습니다
    public static final String ERRCD_O067 = "O067"; // 주문길이공차하한값 : 값이 누락되었습니다
    public static final String ERRCD_O068 = "O068"; // 주문길이공차상한값 : 값이 누락되었습니다
    public static final String ERRCD_O069 = "O069"; // 도막두께전면Total : 값이 누락되었습니다
    public static final String ERRCD_O070 = "O070"; // 도막두께후면Total : 값이 누락되었습니다
    public static final String ERRCD_O071 = "O071"; // 수지구분전면 : 값이 누락되었습니다
    public static final String ERRCD_O072 = "O072"; // 수지구분후면 : 값이 누락되었습니다
    public static final String ERRCD_O073 = "O073"; // 광택도코드전면 : 값이 누락되었습니다
    public static final String ERRCD_O074 = "O074"; // 광택도코드후면 : 값이 누락되었습니다
    public static final String ERRCD_O075 = "O075"; // 고객요청압연두께 : 값이 누락되었습니다
    public static final String ERRCD_O076 = "O076"; // 주문두께관리코드 : 정의 안된 코드입니다
    public static final String ERRCD_O077 = "O077"; // 주문폭관리코드 : 정의 안된 코드입니다
    public static final String ERRCD_O078 = "O078"; // 주문길이관리코드 : 정의 안된 코드입니다
    public static final String ERRCD_O079 = "O079"; // 고객정의색상 : 값이 누락되었습니다
    public static final String ERRCD_O080 = "O080"; // 긴급재구분 : 정의 안된 코드입니다
    public static final String ERRCD_O081 = "O081"; // 주문접수일 : 값이 누락되었습니다
    public static final String ERRCD_O082 = "O082"; // 주문Sheet적재방법 : 정의 안된 코드입니다
    public static final String ERRCD_O083 = "O083"; // 주문Slit조수 : 값이 누락되었습니다
    public static final String ERRCD_O084 = "O084"; // 주문조합폭1 : 값이 누락되었습니다
    public static final String ERRCD_O085 = "O085"; // 주문조합폭2 : 값이 누락되었습니다
    public static final String ERRCD_O086 = "O086"; // 주문조합폭3 : 값이 누락되었습니다
    public static final String ERRCD_O087 = "O087"; // 주문조합폭4 : 값이 누락되었습니다
    public static final String ERRCD_O088 = "O088"; // 주문조합폭5 : 값이 누락되었습니다
    public static final String ERRCD_O089 = "O089"; // 주문조합폭6 : 값이 누락되었습니다
    public static final String ERRCD_O090 = "O090"; // 주문조합폭7 : 값이 누락되었습니다
    public static final String ERRCD_O091 = "O091"; // 주문조합폭8 : 값이 누락되었습니다
    public static final String ERRCD_O092 = "O092"; // Back마킹 : 값이 누락되었습니다
    public static final String ERRCD_O093 = "O093"; // 주문수정일 : 값이 누락되었습니다
    public static final String ERRCD_O094 = "O094"; // 주문확정일 : 값이 누락되었습니다
    public static final String ERRCD_O095 = "O095"; // 주문등록자 : 값이 누락되었습니다
    public static final String ERRCD_O096 = "O096"; // 영업팀코드 : 값이 누락되었습니다
    public static final String ERRCD_O097 = "O097"; // MaterialCode : 값이 누락되었습니다
    public static final String ERRCD_O098 = "O098"; // ClassCode : 값이 누락되었습니다
    public static final String ERRCD_O099 = "O099"; // SubClassCode : 값이 누락되었습니다
    public static final String ERRCD_C011 = "C011"; // C : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C012 = "C012"; // C : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C013 = "C013"; // C : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C014 = "C014"; // C : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C021 = "C021"; // Si : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C022 = "C022"; // Si : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C023 = "C023"; // Si : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C024 = "C024"; // Si : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C031 = "C031"; // Mn : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C032 = "C032"; // Mn : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C033 = "C033"; // Mn : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C034 = "C034"; // Mn : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C041 = "C041"; // P : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C042 = "C042"; // P : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C043 = "C043"; // P : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C044 = "C044"; // P : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C051 = "C051"; // S : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C052 = "C052"; // S : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C053 = "C053"; // S : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C054 = "C054"; // S : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C061 = "C061"; // Cr : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C062 = "C062"; // Cr : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C063 = "C063"; // Cr : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C064 = "C064"; // Cr : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C071 = "C071"; // Ni : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C072 = "C072"; // Ni : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C073 = "C073"; // Ni : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C074 = "C074"; // Ni : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C081 = "C081"; // Cu : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C082 = "C082"; // Cu : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C083 = "C083"; // Cu : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C084 = "C084"; // Cu : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C091 = "C091"; // Al : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C092 = "C092"; // Al : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C093 = "C093"; // Al : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C094 = "C094"; // Al : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C101 = "C101"; // Ti : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C102 = "C102"; // Ti : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C103 = "C103"; // Ti : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C104 = "C104"; // Ti : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C111 = "C111"; // Nb : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C112 = "C112"; // Nb : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C113 = "C113"; // Nb : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C114 = "C114"; // Nb : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C121 = "C121"; // V : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C122 = "C122"; // V : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C123 = "C123"; // V : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C124 = "C124"; // V : 고객사양하한 > 고객사양상한
    public static final String ERRCD_C131 = "C131"; // N : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C132 = "C132"; // N : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_C133 = "C133"; // N : 규격사양하한 > 규격사양상한
    public static final String ERRCD_C134 = "C134"; // N : 고객사양하한 > 고객사양상한
    public static final String ERRCD_M011 = "M011"; // TS : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M012 = "M012"; // TS : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M013 = "M013"; // TS : 규격사양하한 > 규격사양상한
    public static final String ERRCD_M014 = "M014"; // TS : 고객사양하한 > 고객사양상한
    public static final String ERRCD_M021 = "M021"; // YP : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M022 = "M022"; // YP : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M023 = "M023"; // YP : 규격사양하한 > 규격사양상한
    public static final String ERRCD_M024 = "M024"; // YP : 고객사양하한 > 고객사양상한
    public static final String ERRCD_M031 = "M031"; // EL : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M032 = "M032"; // EL : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M033 = "M033"; // EL : 규격사양하한 > 규격사양상한
    public static final String ERRCD_M034 = "M034"; // EL : 고객사양하한 > 고객사양상한
    public static final String ERRCD_M041 = "M041"; // HRB : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M042 = "M042"; // HRB : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M043 = "M043"; // HRB : 규격사양하한 > 규격사양상한
    public static final String ERRCD_M044 = "M044"; // HRB : 고객사양하한 > 고객사양상한
    public static final String ERRCD_M051 = "M051"; // ER : 규격사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M052 = "M052"; // ER : 고객사양이 보증사양에 맞지 않습니다
    public static final String ERRCD_M053 = "M053"; // ER : 규격사양하한 > 규격사양상한
    public static final String ERRCD_M054 = "M054"; // ER : 고객사양하한 > 고객사양상한
    public static final String ERRCD_M061 = "M061"; // 재질Bending : 규격사양이 보증사양에
						    // 맞지 않습니다
    public static final String ERRCD_M062 = "M062"; // 재질Bending : 고객사양이 보증사양에
						    // 맞지 않습니다
    public static final String ERRCD_M071 = "M071"; // 시편채취지시위치 : 규격사양의 값이 없습니다
    public static final String ERRCD_M072 = "M072"; // 시편채취지시위치 : 고객사양의 값이 없습니다
    public static final String ERRCD_M073 = "M073"; // 시편채취지시위치 : 보증사양의 값이 없습니다
    public static final String ERRCD_M081 = "M081"; // 시편채취지시길이 : 규격사양의 값이 없습니다
    public static final String ERRCD_M082 = "M082"; // 시편채취지시길이 : 고객사양의 값이 없습니다
    public static final String ERRCD_M083 = "M083"; // 시편채취지시길이 : 보증사양의 값이 없습니다
    public static final String ERRCD_M091 = "M091"; // 시편호수 : 규격사양의 값이 없습니다
    public static final String ERRCD_M092 = "M092"; // 시편호수 : 고객사양의 값이 없습니다
    public static final String ERRCD_M093 = "M093"; // 시편호수 : 보증사양의 값이 없습니다
    public static final String ERRCD_M101 = "M101"; // 시험도금량전면 : 규격사양이 보증사양 범위에
						    // 맞지 않습니다
    public static final String ERRCD_M102 = "M102"; // 시험도금량전면 : 고객사양이 보증사양 범위에
						    // 맞지 않습니다
    public static final String ERRCD_M103 = "M103"; // 시험도금량후면 : 규격사양이 보증사양 범위에
						    // 맞지 않습니다
    public static final String ERRCD_M104 = "M104"; // 시험도금량후면 : 고객사양이 보증사양 범위에
						    // 맞지 않습니다
    public static final String ERRCD_M111 = "M111"; // 시험도금량전체 : 규격사양이 보증사양 범위에
						    // 맞지 않습니다
    public static final String ERRCD_M112 = "M112"; // 시험도금량전체 : 고객사양이 보증사양 범위에
						    // 맞지 않습니다
    public static final String ERRCD_D011 = "D011"; // 두께공차 : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D012 = "D012"; // 두께공차 : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D013 = "D013"; // 두께공차 : 규격사양하한 > 규격사양상한
    public static final String ERRCD_D014 = "D014"; // 두께공차 : 고객사양하한 > 고객사양상한
    public static final String ERRCD_D021 = "D021"; // 폭공차 : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D022 = "D022"; // 폭공차 : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D023 = "D023"; // 폭공차 : 규격사양하한 > 규격사양상한
    public static final String ERRCD_D024 = "D024"; // 폭공차 : 고객사양하한 > 고객사양상한
    public static final String ERRCD_D031 = "D031"; // 길이공차 : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D032 = "D032"; // 길이공차 : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D033 = "D033"; // 길이공차 : 규격사양하한 > 규격사양상한
    public static final String ERRCD_D034 = "D034"; // 길이공차 : 고객사양하한 > 고객사양상한
    public static final String ERRCD_D041 = "D041"; // 반곡H : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D042 = "D042"; // 반곡H : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D051 = "D051"; // 중곡H : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D052 = "D052"; // 중곡H : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D061 = "D061"; // 외곡H : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D062 = "D062"; // 외곡H : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D071 = "D071"; // 직선도 : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D072 = "D072"; // 직선도 : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D081 = "D081"; // 직각도 : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D082 = "D082"; // 직각도 : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D091 = "D091"; // 대각선차 : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D092 = "D092"; // 대각선차 : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D101 = "D101"; // 급준도 : 규격사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D102 = "D102"; // 급준도 : 고객사양이 보증사양 범위에 맞지
						    // 않습니다
    public static final String ERRCD_D111 = "D111"; // Telescope : 규격사양이 보증사양
						    // 범위에 맞지 않습니다
    public static final String ERRCD_D112 = "D112"; // Telescope : 고객사양이 보증사양
						    // 범위에 맞지 않습니다

    public static final String ERRCD_KS01 = "KS01"; // 규격약호,규격년도가 규격공통에 없습니다.
    public static final String ERRCD_KS02 = "KS02"; // 규격약호,규격년도가 규격성분에 없습니다.
    public static final String ERRCD_KS03 = "KS03"; // 규격약호,규격년도가 규격재질에 없습니다.
    public static final String ERRCD_KS04 = "KS04"; // 인수도기준이 인수도규격에 없습니다.
    public static final String ERRCD_KS05 = "KS05"; // 고객사양두께 계산식의 기준 정보가 없습니다.
    public static final String ERRCD_KS06 = "KS06"; // 고객사양폭 계산식의 기준 정보가 없습니다.
    public static final String ERRCD_KS07 = "KS07"; // 고객사양길이 계산식의 기준 정보가 없습니다.
    public static final String ERRCD_KS08 = "KS08"; // 고객인수도 기준이 없습니다.
    public static final String ERRCD_KS09 = "KS09"; // 고객사양폭공차 기준이 없습니다.
    public static final String ERRCD_KS10 = "KS10"; // 고객사양길이공차 기준이 없습니다.
    public static final String ERRCD_KS30 = "KS30"; // 규격인수도 기준이 없습니다.

    public static final String ERRCD_KS11 = "KS11"; // 규격약호,규격년도가 규격공통에 중복입니다.
    public static final String ERRCD_KS12 = "KS12"; // 규격약호,규격년도가 규격성분에 중복입니다.
    public static final String ERRCD_KS13 = "KS13"; // 규격약호,규격년도가 규격재질에 중복입니다.
    public static final String ERRCD_KS14 = "KS14"; // 인수도기준이 인수도규격에 중복입니다.
    public static final String ERRCD_KS15 = "KS15"; // 고객사양두께 계산식의 기준 정보가 중복입니다
    public static final String ERRCD_KS16 = "KS16"; // 고객사양폭 계산식의 기준 정보가 중복입니다.
    public static final String ERRCD_KS17 = "KS17"; // 고객사양길이 계산식의 기준 정보가 중복입니다.
    public static final String ERRCD_KS18 = "KS18"; // 고객인수도 기준이 중복입니다.
    public static final String ERRCD_KS19 = "KS19"; // 고객사양폭공차 기준이 중복입니다.
    public static final String ERRCD_KS20 = "KS20"; // 고객사양길이공차 기준이 중복입니다.
    public static final String ERRCD_KS21 = "KS21"; // 규격인수도 기준이 중복입니다.

    public static final String ERRCD_KS22 = "KS22"; // 보증성분사양 설계 시 규격성분사양이 없습니다.
    public static final String ERRCD_KS23 = "KS23"; // 보증재질사양 설계 시 규격재질사양이 없습니다.
    public static final String ERRCD_KS24 = "KS24"; // 보증인수도사양 설계 시 규격인수도사양이
						    // 없습니다.
    public static final String ERRCD_KS28 = "KS28"; // 규격별주문용도 기준 정보가 없습니다.
    public static final String ERRCD_KS29 = "KS29"; // 규격별주문용도 기준 정보가 중복입니다.

    public static final String ERRCD_KN01 = "KN01"; // 사내성분이 사내성분기준에 없습니다.
    public static final String ERRCD_KN02 = "KN02"; // 사내재질이 사내성분기준에 없습니다.
    public static final String ERRCD_KN11 = "KN11"; // 사내성분이 사내성분기준에 중복입니다
    public static final String ERRCD_KN12 = "KN12"; // 사내재질이 사내성분기준에 중복입니다
    public static final String ERRCD_KN21 = "KN21"; // 보증성분 편집시 사내성분사양이 없습니다.
    public static final String ERRCD_KN22 = "KN22"; // 보증재질 편집시 사내재질사양이 없습니다.
    public static final String ERRCD_KC01 = "KC01"; // 고객사양번호의 고객사코드와 고객사양의
						    // 고객사코드가 다릅니다.
    public static final String ERRCD_KC02 = "KC02"; // 고객사양번호가 고객사양에 없습니다
    public static final String ERRCD_KC11 = "KC11"; // 고객사양성분이 고객사양기준에 중복입니다
    public static final String ERRCD_KC12 = "KC12"; // 고객사양재질이 고객사양기준에 중복입니다
    public static final String ERRCD_KC13 = "KC13"; // 고객사양인수도가 고객사양기준에 중복입니다
    public static final String ERRCD_KC21 = "KC21"; // 규격약호가 수요가공통의 규격약호와 다릅니다
    public static final String ERRCD_KC22 = "KC22"; // 주문용도가 수요가공통의 주문용도와 다릅니다
    public static final String ERRCD_KC23 = "KC23"; // 주문품명이가 고객사양의 품명과 다릅니다
    public static final String ERRCD_KC24 = "KC24"; // 주문두께가 고객사양의 두께범위와 다릅니다
    public static final String ERRCD_KC25 = "KC25"; // 주문폭이 고객사양의 폭범위와 다릅니다
    public static final String ERRCD_KC26 = "KC26"; // 주문길이가 고객사양의 길이범위와 다릅니다
    public static final String ERRCD_KK00 = "KK00"; // 시스템 ERROR입니다. 시스템 관리자에게
						    // 문의 하십시오.
    public static final String ERRCD_KK01 = "KK01"; // 품질설계KEY 기준이 없습니다
    public static final String ERRCD_KK02 = "KK02"; // 품질설계KEY 기준이 중복입니다
    public static final String ERRCD_KK11 = "KK11"; // 제조표준번호가 제조표준기준에 없습니다
    public static final String ERRCD_KK12 = "KK12"; // 제조표준번호가 제조표준기준에 중복입니다
    public static final String ERRCD_KK13 = "KK13"; // 제조표준 기준 정보가 없습니다.
    public static final String ERRCD_KK14 = "KK14"; // 제조표준 기준 정보가 중복입니다.
    public static final String ERRCD_KK21 = "KK21"; // 통과공정번호가 통과공정기준에 없습니다.
    public static final String ERRCD_KK22 = "KK22"; // 통과공정번호가 통과공정기준에 중복입니다.
    public static final String ERRCD_KK23 = "KK23"; // 통과공정기준에 기준 정보가 없습니다.
    public static final String ERRCD_KK24 = "KK24"; // 통과공정기준에 기준 정보가 중복입니다.
    public static final String ERRCD_KK25 = "KK25"; // 통과공정 결정기준에 기준 정보가 없습니다.
    public static final String ERRCD_KK26 = "KK26"; // 통과공정 결정기준에 기준 정보가 중복입니다.
    public static final String ERRCD_KK27 = "KK27"; // 통과공정이 모두 삭제되었습니다.
    public static final String ERRCD_KK31 = "KK31"; // 도금량 코드가 도금량기준에 없습니다.(C10A1061)
    public static final String ERRCD_KK32 = "KK32"; // 도금량 코드가 도금량기준에 중복입니다.(C10A1061)
    public static final String ERRCD_KK33 = "KK33"; // 도금량지정코드에 상당도금두께가 없습니다.
    public static final String ERRCD_KK34 = "KK34"; // 도금량지정코드에 상당도금두께가 중복입니다.
    public static final String ERRCD_KK40 = "KK40"; // 포장방법이 포장재기준에 없습니다.
    public static final String ERRCD_KK41 = "KK41"; // 포장방법이 Coil 포장재중량기준에 없습니다.
    public static final String ERRCD_KK42 = "KK42"; // 포장방법이 Coil 포장재중량기준에
						    // 중복입니다.
    public static final String ERRCD_KK43 = "KK43"; // 포장방법이 Sheet 포장재중량기준에
						    // 없습니다.
    public static final String ERRCD_KK44 = "KK44"; // 포장방법이 Sheet 포장재중량기준에
						    // 중복입니다.
    public static final String ERRCD_KK45 = "KK45"; // 포장재중량_Coil 기준 정보가 없습니다.
    public static final String ERRCD_KK46 = "KK46"; // 포장재중량_Coil 기준 정보가 중복입니다.
    public static final String ERRCD_KK47 = "KK47"; // 포장재중량_Sheet 기준 정보가 없습니다.
    public static final String ERRCD_KK48 = "KK48"; // 포장재중량_Sheet 기준 정보가 중복입니다.
    public static final String ERRCD_KK50 = "KK50"; // PLTCM Sleeve유무Set 기준 정보가
						    // 없습니다.
    public static final String ERRCD_KK51 = "KK51"; // PLTCM Sleeve유무Set 기준 정보가
						    // 중복입니다.
    public static final String ERRCD_KK52 = "KK52"; // PLTCM 5Stand WR Type 기준
						    // 정보가 없습니다.
    public static final String ERRCD_KK53 = "KK53"; // PLTCM 6Stand WR Type 기준
						    // 정보가 중복입니다.
    public static final String ERRCD_KK54 = "KK54"; // ECL권치장력Set기준 정보가 없습니다.
    public static final String ERRCD_KK55 = "KK55"; // ECL권치장력Set기준 정보가 중복입니다.
    public static final String ERRCD_KK56 = "KK56"; // CGL Leveler Set기준 정보가
						    // 없습니다.
    public static final String ERRCD_KK57 = "KK57"; // CGL Leveler Set기준 정보가
						    // 중복입니다.
    public static final String ERRCD_KK58 = "KK58"; // ECL C-D방지약품Set기준 정보가
						    // 없습니다.
    public static final String ERRCD_KK59 = "KK59"; // ECL C-D방지약품Set기준 정보가
						    // 중복입니다.
    public static final String ERRCD_KK60 = "KK60"; // CGL표면처리유형Set기준 정보가 없습니다.
    public static final String ERRCD_KK61 = "KK61"; // CGL표면처리유형Set기준 정보가 중복입니다.
    public static final String ERRCD_KK62 = "KK62"; // 품질메세지 기준 정보가 없습니다.
    public static final String ERRCD_KK63 = "KK63"; // 품질메세지 기준 정보가 중복입니다.
    public static final String ERRCD_KK64 = "KK64"; // 조도설계 기준 정보가 없습니다.
    public static final String ERRCD_KK65 = "KK65"; // 조도설계 기준 정보가 중복입니다.
    public static final String ERRCD_KK66 = "KK66"; // 후처리 기준 정보가 없습니다.
    public static final String ERRCD_KK67 = "KK67"; // 후처리 기준 정보가 중복입니다.
    public static final String ERRCD_KK68 = "KK68"; // 정전공정 방청유Set기준 정보가 없습니다.
    public static final String ERRCD_KK69 = "KK69"; // 정전공정 방청유Set기준 정보가 중복입니다.
    public static final String ERRCD_KK70 = "KK70"; // ClassCode1_제품군 기준이 없습니다.
    public static final String ERRCD_KK71 = "KK71"; // ClassCode1_제품군 기준이 중복입니다.
    public static final String ERRCD_KK72 = "KK72"; // ClassCode2_행선지 기준이 없습니다.
    public static final String ERRCD_KK73 = "KK73"; // ClassCode2_행선지 기준이 중복입니다.
    public static final String ERRCD_KK74 = "KK74"; // ClassCode34_재질COPOEG 기준이
						    // 없습니다.
    public static final String ERRCD_KK75 = "KK75"; // ClassCode34_재질COPOEG 기준이
						    // 중복입니다.
    public static final String ERRCD_KK76 = "KK76"; // ClassCode3_재질GIGAGL 기준이
						    // 없습니다.
    public static final String ERRCD_KK77 = "KK77"; // ClassCode3_재질GIGAGL 기준이
						    // 중복입니다.
    public static final String ERRCD_KK78 = "KK78"; // ClassCode6_표면처리 기준이 없습니다.
    public static final String ERRCD_KK79 = "KK79"; // ClassCode6_표면처리 기준이
						    // 중복입니다.
    public static final String ERRCD_KK80 = "KK80"; // PLTCM두께공차 기준 정보가 없습니다.
    public static final String ERRCD_KK81 = "KK81"; // PLTCM두께공차 기준 정보가 중복입니다.
    public static final String ERRCD_KK82 = "KK82"; // 압연두께Set치보정기준 정보가 없습니다.
    public static final String ERRCD_KK83 = "KK83"; // 압연두께Set치보정기준 정보가 중복입니다.
    public static final String ERRCD_KK84 = "KK84"; // EG조도SET기준 정보가 없습니다.
    public static final String ERRCD_KK85 = "KK85"; // EG조도SET기준 정보가 중복입니다.
    public static final String ERRCD_KK86 = "KK86"; // 품질설계SMS발송대상 정보가 없습니다.
    public static final String ERRCD_KK87 = "KK87"; // 품질설계SMS발송대상 정보가 중복입니다.
    public static final String ERRCD_KK88 = "KK88"; // 품질설계SMS발송기준 정보가 없습니다.
    public static final String ERRCD_KK89 = "KK89"; // 품질설계SMS발송기준 정보가 중복입니다.
    public static final String ERRCD_KK90 = "KK90"; // 중간재적용기준 정보가 없습니다.
    public static final String ERRCD_KK91 = "KK91"; // 중간재적용기준 정보가 중복입니다.
    public static final String ERRCD_KK92 = "KK92"; // 코일포장재중량기준 정보가 없습니다.
    public static final String ERRCD_KK93 = "KK93"; // 코일포장재중량기준 정보가 중복입니다.

    
    
    public static final String ERRCD_KP01 = "KP01"; // 색상코드가 칼라제조표준(CCL-BOM)에
						    // 없습니다.
    public static final String ERRCD_KP02 = "KP02"; // 색상코드가 칼라물성기준에 없습니다.
    public static final String ERRCD_KP03 = "KP03"; // CCL-BOM관리 테이블에 기준 정보가
						    // 없습니다.
    public static final String ERRCD_KP04 = "KP04"; // 칼라물성기준관리 테이블에 기준 정보가
						    // 없습니다.
    public static final String ERRCD_KP05 = "KP05"; // 칼라공정코드가 설계되어 있지 않습니다.
    public static final String ERRCD_KP06 = "KP06"; // MaterialCode 가 없습니다.    
    public static final String ERRCD_KP11 = "KP11"; // 색상코드가 칼라제조표준(CCL-BOM)에
						    // 중복입니다.
    public static final String ERRCD_KP12 = "KP12"; // 색상코드가 칼라물성기준에 중복입니다.
    public static final String ERRCD_KP13 = "KP13"; // CCL-BOM관리 테이블에 기준정보가
						    // 중복입니다.
    public static final String ERRCD_KP14 = "KP14"; // 칼라물성기준관리 테이블에 기준 정보가
						    // 중복입니다.
    public static final String ERRCD_KT01 = "KT01"; // 원자재두께기준에 없는 두께입니다 (PLTCM
						    // Set 두께)
    public static final String ERRCD_KT02 = "KT02"; // 원자재폭기준에 없는 폭입니다. (기준
						    // Unmatch)
    public static final String ERRCD_KT03 = "KT03"; // 폭여유치를 설계하지 못했습니다. (기준
						    // Unmatch)
    public static final String ERRCD_KT04 = "KT04"; // PLTCM폭수축량 기준 정보가 없습니다.
    public static final String ERRCD_KT05 = "KT05"; // PLTCM폭마진량 기준 정보가 없습니다.
    public static final String ERRCD_KT06 = "KT06"; // 원자재두께기준에 기준 정보가 없습니다.
    public static final String ERRCD_KT07 = "KT07"; // 원자재폭기준에 기준 정보가 없습니다.
    public static final String ERRCD_KT11 = "KT11"; // 원자재두께기준이 중복입니다 (PLTCM Set
						    // 두께)
    public static final String ERRCD_KT12 = "KT12"; // 원자재폭기준이 중복입니다. (기준
						    // Unmatch)
    public static final String ERRCD_KT13 = "KT13"; // 폭여유치기준이 중복입니다. (기준
						    // Unmatch)
    public static final String ERRCD_KT14 = "KT14"; // PLTCM폭수축량기준이 중복입니다.
    public static final String ERRCD_KT15 = "KT15"; // PLTCM폭마진량기준이 중복입니다.
    public static final String ERRCD_KT16 = "KT16"; // 원자재기준 정보가 없습니다.
    public static final String ERRCD_KT17 = "KT17"; // 원자재기준 정보가 중복입니다.
    public static final String ERRCD_KT18 = "KT18"; // 원자재발주 기준 정보가 없습니다.
    public static final String ERRCD_KT19 = "KT19"; // 원자재발주기준 정보가 중복입니다.
    public static final String ERRCD_KT20 = "KT20"; // CGL폭감소량 기준 정보가 없습니다.
    public static final String ERRCD_KT21 = "KT21"; // CGL폭감소량기준 정보가 중복입니다.
    public static final String ERRCD_KT22 = "KT22"; // EGL폭감소량 기준 정보가 없습니다.
    public static final String ERRCD_KT23 = "KT23"; // EGL폭감소량 기준 정보가 중복입니다.
    public static final String ERRCD_KT24 = "KT24"; // 정전폭감소량 기준 정보가 없습니다.
    public static final String ERRCD_KT25 = "KT25"; // 정전폭감소량 기준 정보가 중복입니다.
    public static final String ERRCD_KT26 = "KT26"; // CCL폭감소량 기준 정보가 없습니다.
    public static final String ERRCD_KT27 = "KT27"; // CCL폭감소량 기준 정보가 중복입니다.
    public static final String ERRCD_KT28 = "KT28"; // 정전폭마진량 기준 정보가 없습니다.
    public static final String ERRCD_KT29 = "KT29"; // 정전폭마진량 기준 정보가 중복입니다.
    public static final String ERRCD_KT30 = "KT30"; // 칼라정전라인 결정기준 정보가 없습니다.
    public static final String ERRCD_KT31 = "KT31"; // 칼라정전라인 결정기준 정보가 중복입니다.
    public static final String ERRCD_KT32 = "KT32"; // 제품폭여유기준 정보가 없습니다.
    public static final String ERRCD_KT33 = "KT33"; // 제품폭여유기준 정보가 중복입니다.
    public static final String ERRCD_KT34 = "KT34"; // 감량매직체크기준 정보가 중복입니다.
    public static final String ERRCD_KT35 = "KT35"; // 지관발주메시지기준 정보가 중복입니다.
    public static final String ERRCD_KT36 = "KT36"; // PE-FOAM적용메시지기준 정보가 중복입니다.

    public static final String ERRCD_TB01 = "TB01"; // Table 반영 에러입니다._품질설계_공통
    public static final String ERRCD_TB02 = "TB02"; // Table 반영 에러입니다._품질설계_성분사양
    public static final String ERRCD_TB03 = "TB03"; // Table 반영 에러입니다._품질설계_재질사양
    public static final String ERRCD_TB04 = "TB04"; // Table 반영
						    // 에러입니다._품질설계_인수도사양
    public static final String ERRCD_TB05 = "TB05"; // Table 반영 에러입니다._품질설계_원자재
    public static final String ERRCD_TB06 = "TB06"; // Table 반영 에러입니다._품질설계_제조사양
    public static final String ERRCD_TB07 = "TB07"; // Table 반영
						    // 에러입니다._품질설계_CCLBOM
    public static final String ERRCD_TB08 = "TB08"; // Table 반영 에러입니다._품질설계_통과공정
    public static final String ERRCD_TB09 = "TB09"; // Table 반영
						    // 에러입니다._품질설계_품질메세지
    public static final String ERRCD_TB10 = "TB10"; // Table 반영 에러입니다._품질설계_에러
    public static final String ERRCD_TB11 = "TB11"; // Table 반영 에러입니다._생산가부이력
    public static final String ERRCD_TB12 = "TB12"; // Table 반영 에러입니다._수정주문I/F
    public static final String ERRCD_TB13 = "TB13"; // Table 반영 에러입니다._품질기준개선이력
    public static final String ERRCD_TB14 = "TB14"; // Table 반영
						    // 에러입니다._품질설계Simultion
    public static final String ERRCD_TB15 = "TB15"; // Table 반영 에러입니다._칼라물성기준
    public static final String ERRCD_TB16 = "TB16"; // Table 반영 에러입니다._CCLBOM관리
    public static final String ERRCD_TB17 = "TB17"; // Table 반영
						    // 에러입니다._Material_Code마스타
    public static final String ERRCD_TB18 = "TB18"; // Table 반영
						    // 에러입니다._반제품Material_Code
    public static final String ERRCD_TB19 = "TB19"; // Table 반영 에러입니다._코일별제조사양
    public static final String ERRCD_TB20 = "TB20"; // Table 반영 에러입니다._칼라코드관리
    public static final String ERRCD_TB21 = "TB21"; // Table 반영 에러입니다._칼라코드업체관리
    public static final String ERRCD_TB22 = "TB22"; // Table 반영 에러입니다._칼라시편관리

    public static final String ERRCD_CF01 = "CF01"; // 재질코드 : 값이 누락되었습니다.
    public static final String ERRCD_CF02 = "CF02"; // 원자재코드 : 값이 누락되었습니다.
    public static final String ERRCD_CF03 = "CF03"; // 제조표준번호 : 값이 누락되었습니다.
    public static final String ERRCD_CF04 = "CF04"; // 통과공정번호 : 값이 누락되었습니다.
    public static final String ERRCD_CF05 = "CF05"; // 규격사양성분이 설계되어있지 않습니다.
    public static final String ERRCD_CF06 = "CF06"; // 보증사양성분이 설계되어있지 않습니다.
    public static final String ERRCD_CF07 = "CF07"; // 제품두께범위상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF08 = "CF08"; // 제품두께범위 : 하한값 > 상한값
    public static final String ERRCD_CF09 = "CF09"; // 제품폭범위상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF10 = "CF10"; // 제품폭범위 : 하한값 > 상한값
    public static final String ERRCD_CF11 = "CF11"; // 작업도금량목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF12 = "CF12"; // 작업도금량전면상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF13 = "CF13"; // 작업도금량전면 : 하한값 > 상한값
    public static final String ERRCD_CF14 = "CF14"; // 작업도금량후면상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF15 = "CF15"; // 작업도금량후면 : 하한값 > 상한값
    public static final String ERRCD_CF16 = "CF16"; // 작업도금량전체상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF17 = "CF17"; // 작업도금량전체 : 하한값 > 상한값
    public static final String ERRCD_CF18 = "CF18"; // 도금두께목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF19 = "CF19"; // 도금두께상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF20 = "CF20"; // 도금두께 : 하한값 > 상한값
    public static final String ERRCD_CF21 = "CF21"; // CGL두께목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF22 = "CF22"; // CGL폭목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF23 = "CF23"; // EGL두께목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF24 = "CF24"; // EGL폭목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF25 = "CF25"; // PLTCMX-RaySet두께값 : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF26 = "CF26"; // PLTCM두께목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF27 = "CF27"; // PLTCM두께상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF28 = "CF28"; // PLTCM두께 : 하한값 > 상한값
    public static final String ERRCD_CF29 = "CF29"; // 원자재목표두께 : 값이 누락되었습니다.
    public static final String ERRCD_CF30 = "CF30"; // 원자재목표폭 : 값이 누락되었습니다.
    public static final String ERRCD_CF31 = "CF31"; // 원자재목표두께상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF32 = "CF32"; // 원자재목표두께 : 하한값 > 상한값
    public static final String ERRCD_CF33 = "CF33"; // 원자재목표폭상하한값 : 값이 누락되었습니다.
    public static final String ERRCD_CF34 = "CF34"; // 원자재목표폭 : 하한값 > 상한값
    public static final String ERRCD_CF35 = "CF35"; // 칼라제조사양이 설계되어있지 않습니다.
    public static final String ERRCD_CF36 = "CF36"; // 일반ANN소둔CYCLE : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF37 = "CF37"; // 일반ANN소둔보정시간 : 값이 누락되었습니다.
    public static final String ERRCD_CF38 = "CF38"; // 일반ANN코일온도 : 값이 누락되었습니다.
    public static final String ERRCD_CF39 = "CF39"; // 일반ANN냉각종료온도 : 값이 누락되었습니다.
    public static final String ERRCD_CF40 = "CF40"; // HCANN소둔CYCLE : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF41 = "CF41"; // HCANN소둔보정시간 : 값이 누락되었습니다.
    public static final String ERRCD_CF42 = "CF42"; // HCANN코일온도 : 값이 누락되었습니다.
    public static final String ERRCD_CF43 = "CF43"; // HCANN냉각종료온도 : 값이 누락되었습니다.
    public static final String ERRCD_CF44 = "CF44"; // 소둔CYCLE#2CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF45 = "CF45"; // 가열온도#2CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF46 = "CF46"; // 냉각온도#2CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF47 = "CF47"; // ShockingTime#2CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF48 = "CF48"; // LineSpeed#2CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF49 = "CF49"; // 소둔CYCLE#3CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF50 = "CF50"; // 가열온도#3CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF51 = "CF51"; // 냉각온도#3CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF52 = "CF52"; // ShockingTime#3CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF53 = "CF53"; // LineSpeed#3CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF54 = "CF54"; // 소둔CYCLE#4CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF55 = "CF55"; // 가열온도#4CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF56 = "CF56"; // 냉각온도#4CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF57 = "CF57"; // ShockingTime#4CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF58 = "CF58"; // LineSpeed#4CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF59 = "CF59"; // 소둔CYCLE#5CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF60 = "CF60"; // 가열온도#5CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF61 = "CF61"; // 냉각온도#5CGL : 값이 누락되었습니다.
    public static final String ERRCD_CF62 = "CF62"; // ShockingTime#5CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF63 = "CF63"; // LineSpeed#5CGL : 값이
						    // 누락되었습니다.
    public static final String ERRCD_CF64 = "CF64"; // 규격사양재질이 설계되어있지 않습니다.
    public static final String ERRCD_CF65 = "CF65"; // 규격사양인수도가 설계되어있지 않습니다.
    public static final String ERRCD_CF66 = "CF66"; // 보증사양재질이 설계되어있지 않습니다.
    public static final String ERRCD_CF67 = "CF67"; // 보증사양인수도가 설계되어있지 않습니다.
    public static final String ERRCD_CF68 = "CF68"; // 주문에러체크 기준데이타 오류입니다.
    public static final String ERRCD_CF69 = "CF69"; // 비트 사이즈를 초과하였습니다.
    public static final String ERRCD_CF70 = "CF70"; // PosContext에 Key로 @로 시작하는
						    // 값으로 넣었음. @를 뺀 변수명을 입력 :
    public static final String ERRCD_CF71 = "CF71"; // 해당 Row가 존재하지 않습니다.
    public static final String ERRCD_CF72 = "CF72"; // PLTCM폭목표값 : 값이 누락되었습니다.
    public static final String ERRCD_CF73 = "CF73"; // 품질설계상태의 값이 일치하지 않습니다.
    public static final String ERRCD_CF74 = "CF74"; // ;가(이) null입니다.
    public static final String ERRCD_CF75 = "CF75"; // PLTCM S/T 오류 (PLTCM출측폭 - PL출측폭)
    public static final String ERRCD_CF80 = "CF80"; 
    // 제품목표두께가 제품두께범위하한 또는 제품두께규격범위하한 보다 작습니다.
    public static final String ERRCD_CF81 = "CF81"; 
    // 제품목표두께가 제품두께범위상한값 제품두께규격범위상한 보다 큽니다.
    public static final String ERRCD_CF82 = "CF82"; // 주문단위중량이 없습니다.
    public static final String ERRCD_CF83 = "CF83"; // 주문에러체크 보호필름값이 이상합니다.
    public static final String ERRCD_CF84 = "CF84"; // 주문에러체크 BOM의 재단선이 Y인 경우 M Edge사용불가 
    
    public static final String ERRCD_A130 = "A130"; // _정의안된 코드
    public static final String ERRCD_A23 = "A23"; // 고객사코드 누락
    public static final String ERRCD_A231 = "A231"; // 고객사코드 코드정의오류
    public static final String ERRCD_A232 = "A232"; // 고객사코드 중복
    public static final String ERRCD_A21 = "A21"; // 수요가코드 누락
    public static final String ERRCD_A211 = "A211"; // 수요가코드 코드정의오류
    public static final String ERRCD_A212 = "A212"; // 수요가코드 중복
    public static final String ERRCD_A22 = "A22"; // 최종수요가코드 누락
    public static final String ERRCD_A221 = "A221"; // 최종수요가코드 코드정의오류
    public static final String ERRCD_A222 = "A222"; // 최종수요가코드 중복
    public static final String ERRCD_A223 = "A223"; // 고객사양번호 조합오류    
    public static final String ERRCD_A241 = "A241"; // 고객공통기준 정보에 없슴
    public static final String ERRCD_A242 = "A242"; // 고객공통 기준정보에 중복
    
    public static final String ERRCD_A243 = "A243"; // 주문용도 고객공통기준 상이
    public static final String ERRCD_A244 = "A244"; // 규격약호 고객공통기준 상이   
    public static final String ERRCD_A245 = "A245"; // 규격년도 고객공통기준 상이 
    public static final String ERRCD_A246 = "A246"; // 최종수요가 고객공통기준 상이   
    public static final String ERRCD_A247 = "A247"; // 품명 고객공통기준 상이
    public static final String ERRCD_A248 = "A248"; // 주문두께 고객공통기준 상이
    public static final String ERRCD_A249 = "A249"; // 주문폭 고객공통기준 상이 
    public static final String ERRCD_A250 = "A250"; // 주문길이 고객공통기준 상이 
    public static final String ERRCD_A251 = "A251"; // 두께구분 고객공통기준 상이
    public static final String ERRCD_A252 = "A252"; // 도금량  고객공통기준 상이
    public static final String ERRCD_A253 = "A253"; // 주문표면처리  고객공통기준 상이 
    public static final String ERRCD_A254 = "A254"; // 색상코드  고객공통기준 상이 
    
    
    public static final String ERRCD_A341 = "A341"; // 규격약호,년도가 기준에 없슴
    public static final String ERRCD_A342 = "A342"; // 규격약호,년도가 기준에 중복
    public static final String ERRCD_A93 = "A93"; // 주문정보KEY Null
    public static final String ERRCD_A65 = "A65"; // 주문포장방법 누락
    public static final String ERRCD_A651 = "A651"; // 주문포장방법 코드정의오류
    public static final String ERRCD_A652 = "A652"; // 주문포장방법 중복
    public static final String ERRCD_A72 = "A72"; // 주문Spangle구분 누락
    public static final String ERRCD_A721 = "A721"; // 주문Spangle구분 코드정의오류
    public static final String ERRCD_A61 = "A61"; // 도금량지정코드 누락
    public static final String ERRCD_A611 = "A611"; // 도금량지정코드 코드정의오류
    public static final String ERRCD_A66 = "A66"; // 도금보호필름상세코드 기준에 없슴
    public static final String ERRCD_A661 = "A661"; // 도금보호필름상세코드 기준에 중복
    public static final String ERRCD_A663 = "A663"; // 칼라물성테이블 기준에 없슴
    public static final String ERRCD_A664 = "A664"; // 칼라물성테이블 기준에 중복
    public static final String ERRCD_A665 = "A665"; // 주문vs MES의 보호필름코드가 다름    
    public static final String ERRCD_A902 = "A902"; // CCL_BOM테이블 기준에 없슴
    public static final String ERRCD_A903 = "A903"; // CCL_BOM테이블 기준에 중복
    public static final String ERRCD_A904 = "A904"; // CCL_BOM에 사용불가 칼라코드가 있음
    public static final String ERRCD_A905 = "A905"; // CCL_BOM에 사용불가 칼라코드 개수 조회 오류
    public static final String ERRCD_A200 = "A200"; // MasterCode 기준 오류
    public static final String ERRCD_A201 = "A201"; // MasterCode 기준 누락
    public static final String ERRCD_A782 = "A782"; // 주문코일외경 범위초과
    public static final String ERRCD_A783 = "A783"; // 포장매수 단중MIN/MAX초과 
    public static final String ERRCD_A784 = "A784"; // 단중범위 좁음   
    
    

    // ################################################
    // 주문에러메세지
    // ################################################

    public static final String ERRMSG_R00 = "규격사양 MasterData에 데이타가 없거나 많습니다.";
    public static final String ERRMSG_R01 = "성분사양 MasterData에 데이타가 없거나 많습니다.";
    public static final String ERRMSG_R02 = "재질사양 MasterData에 데이타가 없거나 많습니다.";
    public static final String ERRMSG_R03 = "인수도사양 MasterData에 데이타가 없거나 많습니다";
    public static final String ERRMSG_R04 = "주문항목과 MasterData 항목이 불일치 합니다.";
    public static final String ERRMSG_R05 = "필수항목체크시 에러입니다.";
    public static final String ERRMSG_R06 = "칼라표면처리 기준정보가 없습니다.";
    public static final String ERRMSG_R07 = "칼라표면처리 기준정보가 중복입니니다.";
    public static final String ERRMSG_R08 = "코팅방식 기준정보가 없습니다.";
    public static final String ERRMSG_R09 = "코팅방식 기준정보가 중복입니니다.";
    public static final String ERRMSG_R10 = "일반ANN소둔로유형 기준정보가 없습니다.";
    public static final String ERRMSG_R11 = "일반ANN소둔로유형 기준정보가 중복입니니다.";
    public static final String ERRMSG_R12 = "색상코드 기준정보가 없습니다.";
    public static final String ERRMSG_R13 = "색상코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R14 = "가상차량여부 기준정보가 없습니다.";
    public static final String ERRMSG_R15 = "가상차량여부 기준정보가 중복입니니다.";
    public static final String ERRMSG_R16 = "Lamina접착제코드 기준정보가 없습니다.";
    public static final String ERRMSG_R17 = "Lamina접착제코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R18 = "라미나필름두께코드 기준정보가 없습니다.";
    public static final String ERRMSG_R19 = "라미나필름두께코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R20 = "라미나유형 기준정보가 없습니다.";
    public static final String ERRMSG_R21 = "라미나유형 기준정보가 중복입니니다.";
    public static final String ERRMSG_R22 = "물성기준연필경도 기준정보가 없습니다.";
    public static final String ERRMSG_R23 = "물성기준연필경도 기준정보가 중복입니니다.";
    public static final String ERRMSG_R24 = "주문코일내경 기준정보가 없습니다.";
    public static final String ERRMSG_R25 = "주문코일내경 기준정보가 중복입니니다.";
    public static final String ERRMSG_R26 = "주문종류 기준정보가 없습니다.";
    public static final String ERRMSG_R27 = "주문종류 기준정보가 중복입니니다.";
    public static final String ERRMSG_R28 = "주문조도코드 기준정보가 없습니다.";
    public static final String ERRMSG_R29 = "주문조도코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R30 = "주문Spangle구분 기준정보가 없습니다.";
    public static final String ERRMSG_R31 = "주문Spangle구분 기준정보가 중복입니니다.";
    public static final String ERRMSG_R32 = "주문표면처리코드 기준정보가 없습니다.";
    public static final String ERRMSG_R33 = "주문표면처리코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R34 = "PLTCM5StandWRType 기준정보가 없습니다.";
    public static final String ERRMSG_R35 = "PLTCM 5Stand WR Type  기준정보 중복입니니다.";
    public static final String ERRMSG_R36 = "PLTCM내경링사용여부 기준정보가 없습니다.";
    public static final String ERRMSG_R37 = "PLTCM내경링사용여부 기준정보가 중복입니니다.";
    public static final String ERRMSG_R38 = "PLTCM Sleeve유무Set기준 기준정보가 없습니다.";
    public static final String ERRMSG_R39 = "PLTCM Sleeve유무Set기준 기준정보가 중복입니니다.";
    public static final String ERRMSG_R40 = "품명코드 기준정보가 없습니다.";
    public static final String ERRMSG_R41 = "품명코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R42 = "PrintInkRollPattern 기준정보가 없습니다.";
    public static final String ERRMSG_R43 = "PrintInkRollPattern 기준정보가 중복입니니다.";
    public static final String ERRMSG_R44 = "PrintInkType 기준정보가 없습니다.";
    public static final String ERRMSG_R45 = "PrintInkType 기준정보가 중복입니니다. ";
    public static final String ERRMSG_R46 = "PrintPatternCode 기준정보가 없습니다.";
    public static final String ERRMSG_R47 = "PrintPatternCode 기준정보가 중복입니니다.";
    public static final String ERRMSG_R48 = "Print용도코드 기준정보가 없습니다.";
    public static final String ERRMSG_R49 = "Print용도코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R50 = "보호필름점착력 기준정보가 없습니다.";
    public static final String ERRMSG_R51 = "보호필름점착력 기준정보가 중복입니니다.";
    public static final String ERRMSG_R52 = "보호필름폭 기준정보가 없습니다.";
    public static final String ERRMSG_R53 = "보호필름폭 기준정보가 중복입니니다.";
    public static final String ERRMSG_R54 = "품질설계에러코드 기준정보가 없습니다.";
    public static final String ERRMSG_R55 = "품질설계에러코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R56 = "품질개선상태코드 기준정보가 없습니다.";
    public static final String ERRMSG_R57 = "품질개선상태코드 기준정보가 중복입니니다.";
    public static final String ERRMSG_R58 = "수지타입 기준정보가 없습니다.";
    public static final String ERRMSG_R59 = "수지타입 기준정보가 중복입니니다.";
    public static final String ERRMSG_R60 = "시험열병합수구분 기준정보가 없습니다.";
    public static final String ERRMSG_R61 = "시험열병합수구분 기준정보가 중복입니니다.";
    public static final String ERRMSG_R62 = "ECL C-D방지약품Set기준 기준정보가 없습니다.(C10B2130)";
    public static final String ERRMSG_R63 = "ECL C-D방지약품Set기준 기준정보가 중복입니니다.(C10B2130)";
    public static final String ERRMSG_R64 = "CGL표면처리유형Set기준 기준정보가 없습니다.(C10B2160)";
    public static final String ERRMSG_R65 = "CGL표면처리유형Set기준 기준정보가 중복입니니다.(C10B2160)";
    public static final String ERRMSG_R66 = "품질메세지  기준정보가 없습니다.";
    public static final String ERRMSG_R67 = "품질메세지  기준정보가 중복입니니다.";
    public static final String ERRMSG_R68 = "조도설계(Ra_PPI_Rmax) 기준정보가 없습니다.(C10B2210)";
    public static final String ERRMSG_R69 = "조도설계(Ra_PPI_Rmax) 기준정보가 중복입니니다.(C10B2210)";
    public static final String ERRMSG_R70 = "후처리 기준정보가 없습니다.";
    public static final String ERRMSG_R71 = "후처리 기준정보가 중복입니니다.";
    public static final String ERRMSG_R72 = "정전공정 방청유Set기준  기준정보가 없습니다.(C10B2170)";
    public static final String ERRMSG_R73 = "정전공정 방청유Set기준  기준정보가 중복입니니다.(C10B2170)";
    public static final String ERRMSG_R74 = "원자재관련정보  기준정보가 없습니다.(C10B1063)";
    public static final String ERRMSG_R75 = "원자재관련정보  기준정보가 중복입니니다(C10B1063).";
    public static final String ERRMSG_R76 = "고객사양폭공차기준  기준정보가 없습니다.";
    public static final String ERRMSG_R77 = "고객사양폭공차기준  기준정보가 중복입니니다.";
    public static final String ERRMSG_R78 = "고객사양길이공차기준  기준정보가 없습니다.";
    public static final String ERRMSG_R79 = "고객사양길이공차기준  기준정보가 중복입니니다.";
    public static final String ERRMSG_R80 = "고객사양두께공차기준  기준정보가 없습니다.";
    public static final String ERRMSG_R81 = "고객사양두께공차기준  기준정보가 중복입니니다.";
    public static final String ERRMSG_R82 = "도금량기준  기준정보가 없습니다.(C10A1061)";
    public static final String ERRMSG_R83 = "도금량기준  기준정보가 중복입니니다.(C10A1061)";
    public static final String ERRMSG_R84 = "통과공정기준  기준정보가 없습니다.";
    public static final String ERRMSG_R85 = "통과공정기준  기준정보가 중복입니니다.";
    public static final String ERRMSG_R86 = "설계Key  기준정보가 없습니다.";
    public static final String ERRMSG_R87 = "설계Key  기준정보가 중복입니니다.";
    public static final String ERRMSG_R88 = "원자재두께  기준정보가 없습니다.";
    public static final String ERRMSG_R89 = "원자재두께  기준정보가 중복입니니다.";
    public static final String ERRMSG_R90 = "제조표준_칼라물성정보  기준정보가 없습니다.";
    public static final String ERRMSG_R91 = "제조표준_칼라물성정보  기준정보가 중복입니니다.";
    public static final String ERRMSG_R92 = "포장재중량관련정보  기준정보가 없습니다.";
    public static final String ERRMSG_R93 = "포장재중량관련정보  기준정보가 중복입니니다.";
    public static final String ERRMSG_R94 = "CCL_BOM기준정보  기준정보가 없습니다.";
    public static final String ERRMSG_R95 = "CCL_BOM기준정보  기준정보가 중복입니니다. ";
    public static final String ERRMSG_R96 = "고객사양번호가 고객사양기준에 없습니다. ";
    public static final String ERRMSG_R97 = "고객사양성분이 고객사양기준에 중복입니다. ";
    public static final String ERRMSG_R98 = "칼라공정코드가 설계되어 있지 않습니다.";
    public static final String ERRMSG_R100 = "시스템 ERROR입니다. 시스템 관리자에게 문의 하십시오.";
    public static final String ERRMSG_R101 = "정전폭감소량 기준 정보가 없습니다.";
    public static final String ERRMSG_R102 = "정전폭감소량 기준 정보가 중복입니다.";
    public static final String ERRMSG_R103 = "정전폭마진량 기준 정보가 없습니다.";
    public static final String ERRMSG_R104 = "정전폭마진량 기준 정보가 중복입니다.";
    public static final String ERRMSG_R105 = "CGL폭수축량 기준 정보가 없습니다.";
    public static final String ERRMSG_R106 = "CGL폭수축량 기준 정보가 중복입니다.";
    public static final String ERRMSG_R107 = "EGL폭수축량 기준 정보가 없습니다.";
    public static final String ERRMSG_R108 = "EGL폭수축량 기준 정보가 중복입니다.";
    public static final String ERRMSG_R109 = "품질설계KEY 에러입니다.";
    public static final String ERRMSG_R110 = "고객인수도 기준이 없습니다.";
    public static final String ERRMSG_R111 = "고객사양폭공차 기준이 없습니다.";
    public static final String ERRMSG_R112 = "고객사양길이공차 기준이 없습니다.";
    public static final String ERRMSG_R113 = "규격인수도 기준이 없습니다.";
    public static final String ERRMSG_R114 = "고객인수도 기준이 중복입니다.";
    public static final String ERRMSG_R115 = "고객사양폭공차 기준이 중복입니다.";
    public static final String ERRMSG_R116 = "고객사양길이공차 기준이 중복입니다.";
    public static final String ERRMSG_R117 = "규격인수도 기준이 중복입니다.";
    public static final String ERRMSG_R118 = "통과공정이 모두 삭제되었습니다.";
    public static final String ERRMSG_R119 = "ClassCode1_제품군 기준이 없습니다.";
    public static final String ERRMSG_R120 = "ClassCode1_제품군 기준이 중복입니다.";
    public static final String ERRMSG_R121 = "ClassCode2_행선지 기준이 없습니다.";
    public static final String ERRMSG_R122 = "ClassCode2_행선지 기준이 중복입니다.";
    public static final String ERRMSG_R123 = "ClassCode34_재질COPOEG 기준이 없습니다.";
    public static final String ERRMSG_R124 = "ClassCode34_재질COPOEG 기준이 중복입니다.";
    public static final String ERRMSG_R125 = "ClassCode3_재질GIGAGL 기준이 없습니다.";
    public static final String ERRMSG_R126 = "ClassCode3_재질GIGAGL 기준이 중복입니다.";
    public static final String ERRMSG_R127 = "ClassCode6_표면처리 기준이 없습니다.";
    public static final String ERRMSG_R128 = "ClassCode6_표면처리 기준이 중복입니다.";
    public static final String ERRMSG_R129 = "칼라정전라인 결정기준 정보가 없습니다.(C10A2030)";
    public static final String ERRMSG_R130 = "칼라정전라인 결정기준 정보가 중복입니다.(C10A2030)";
    public static final String ERRMSG_R131 = "PLTCM폭수축량 기준 정보가 없습니다.";
    public static final String ERRMSG_R132 = "PLTCM폭수축량 기준 정보가 중복입니다.";
    public static final String ERRMSG_R133 = "PLTCM폭마진량 기준 정보가 없습니다.";
    public static final String ERRMSG_R134 = "PLTCM폭마진량 기준 정보가 중복입니다.";
    public static final String ERRMSG_R135 = "PLTCM두께공차 기준 정보가 없습니다.";
    public static final String ERRMSG_R136 = "PLTCM두께공차 기준 정보가 중복입니다.";
    public static final String ERRMSG_R137 = "폭여유치를 설계하지 못했습니다. (기준 Unmatch)";
    public static final String ERRMSG_R138 = "폭여유치기준이 중복입니다. (기준 Unmatch)";
    public static final String ERRMSG_R139 = "규격약호,규격년도가 규격공통에 없습니다.";
    public static final String ERRMSG_R140 = "규격약호,규격년도가 규격공통에 중복입니다.";
    public static final String ERRMSG_R141 = "고객사양번호가 고객공통에 없습니다.";
    public static final String ERRMSG_R142 = "고객사양번호가 고객공통에 중복입니다.";
    public static final String ERRMSG_R143 = "CCL폭감소량 기준 정보가 없습니다.";
    public static final String ERRMSG_R144 = "CCL폭감소량 기준 정보가 중복입니다.";
    public static final String ERRMSG_R145 = "압연두께Set치보정기준 정보가 없습니다.(C10B2060)";
    public static final String ERRMSG_R146 = "압연두께Set치보정기준 정보가 중복입니다.(C10B2060)";
    public static final String ERRMSG_R147 = "EG조도SET기준 정보가 없습니다.";
    public static final String ERRMSG_R148 = "EG조도SET기준 정보가 중복입니다.";
    public static final String ERRMSG_R149 = "MaterialCode 가 없습니다.";
    public static final String ERRMSG_R150 = "중간재적용기준 정보가 없습니다.";
    public static final String ERRMSG_R151 = "중간재적용기준 정보가 중복입니다."; 
    public static final String ERRMSG_R152 = "포장재중량계산(코일)적용기준 정보가 없습니다.";
    public static final String ERRMSG_R153 = "포장재중량계산(코일)적용기준 정보가 중복입니다.";
    
    public static final String ERRMSG_CF01 = "재질코드 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF02 = "원자재코드 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF03 = "제조표준번호 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF04 = "통과공정번호 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF05 = "규격사양성분이 설계되어있지 않습니다.";
    public static final String ERRMSG_CF06 = "보증사양성분이 설계되어있지 않습니다.";
    public static final String ERRMSG_CF07 = "제품두께범위상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF08 = "제품두께범위 : 하한값 > 상한값";
    public static final String ERRMSG_CF09 = "제품폭범위상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF10 = "제품폭범위 : 하한값 > 상한값";
    public static final String ERRMSG_CF11 = "작업도금량목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF12 = "작업도금량전면상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF13 = "작업도금량전면 : 하한값 > 상한값";
    public static final String ERRMSG_CF14 = "작업도금량후면상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF15 = "작업도금량후면 : 하한값 > 상한값";
    public static final String ERRMSG_CF16 = "작업도금량전체상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF17 = "작업도금량전체 : 하한값 > 상한값";
    public static final String ERRMSG_CF18 = "도금두께목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF19 = "도금두께상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF20 = "도금두께 : 하한값 > 상한값";
    public static final String ERRMSG_CF21 = "CGL두께목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF22 = "CGL폭목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF23 = "EGL두께목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF24 = "EGL폭목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF25 = "PLTCMX-RaySet두께값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF26 = "PLTCM두께목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF27 = "PLTCM두께상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF28 = "PLTCM두께 : 하한값 > 상한값";
    public static final String ERRMSG_CF29 = "원자재목표두께 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF30 = "원자재목표폭 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF31 = "원자재목표두께상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF32 = "원자재목표두께 : 하한값 > 상한값";
    public static final String ERRMSG_CF33 = "원자재목표폭상하한값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF34 = "원자재목표폭 : 하한값 > 상한값";
    public static final String ERRMSG_CF35 = "칼라제조사양이 설계되어있지 않습니다.";
    public static final String ERRMSG_CF36 = "일반ANN소둔CYCLE : 값이 누락되었습니다.";
    public static final String ERRMSG_CF37 = "일반ANN소둔보정시간 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF38 = "일반ANN코일온도 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF39 = "일반ANN냉각종료온도 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF40 = "HCANN소둔CYCLE : 값이 누락되었습니다.";
    public static final String ERRMSG_CF41 = "HCANN소둔보정시간 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF42 = "HCANN코일온도 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF43 = "HCANN냉각종료온도 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF44 = "소둔CYCLE#2CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF45 = "가열온도#2CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF46 = "냉각온도#2CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF47 = "ShockingTime#2CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF48 = "LineSpeed#2CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF49 = "소둔CYCLE#3CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF50 = "가열온도#3CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF51 = "냉각온도#3CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF52 = "ShockingTime#3CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF53 = "LineSpeed#3CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF54 = "소둔CYCLE#4CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF55 = "가열온도#4CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF56 = "냉각온도#4CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF57 = "ShockingTime#4CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF58 = "LineSpeed#4CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF59 = "소둔CYCLE#5CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF60 = "가열온도#5CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF61 = "냉각온도#5CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF62 = "ShockingTime#5CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF63 = "LineSpeed#5CGL : 값이 누락되었습니다.";
    public static final String ERRMSG_CF64 = "규격사양재질이 설계되어있지 않습니다.";
    public static final String ERRMSG_CF65 = "규격사양인수도가 설계되어있지 않습니다.";
    public static final String ERRMSG_CF66 = "보증사양재질이 설계되어있지 않습니다.";
    public static final String ERRMSG_CF67 = "보증사양인수도가 설계되어있지 않습니다.";
    public static final String ERRMSG_CF68 = "주문에러체크 기준데이타 오류입니다.";
    public static final String ERRMSG_CF69 = "비트 사이즈를 초과하였습니다.";
    public static final String ERRMSG_CF70 = "PosContext에 Key로 @로 시작하는 값으로 넣었음. @를 뺀 변수명을 입력 :";
    public static final String ERRMSG_CF71 = "해당 Row가 존재하지 않습니다.";
    public static final String ERRMSG_CF72 = "PLTCM폭목표값 : 값이 누락되었습니다.";
    public static final String ERRMSG_CF73 = "품질설계상태의 값이 일치하지 않습니다.";
    public static final String ERRMSG_CF74 = ";가(이) null입니다.";
    public static final String ERRMSG_CF75 = "PLTCM S/T 오류 (PLTCM출측폭 - PL출측폭)";
    public static final String ERRMSG_CF80 = 
            "제품목표두께가 제품두께범위하한 또는 제품두께규격범위하한 보다 작습니다.";
    public static final String ERRMSG_CF81 = 
            "제품목표두께가 제품두께범위상한값 제품두께규격범위상한 보다 큽니다.";
    public static final String ERRMSG_CF82 = "주문단위중량이 없습니다.";
    public static final String ERRMSG_CF83 = "주문에러체크 보호필름값이 이상합니다.";
    public static final String ERRMSG_CF84 = "BOM의 재단선 유무가 Y인경우, M Edge는 선택하시면 안됩니다.";
    
    public static final String ERRMSG_A130 = "[품질설계][현업담당]_정의안된 코드";
    public static final String ERRMSG_A23 = "[품질설계][시스템]고객사코드 누락(MES신규고객사코드DB적용필요)";
    public static final String ERRMSG_A231 = "[품질설계][시스템]고객사코드 미등록(MES신규고객사등록후,DB적용필요)";
    public static final String ERRMSG_A232 = "[품질설계][시스템]고객사코드 중복(MES신규고객사코드DB적용필요)";
    public static final String ERRMSG_A21 = "[품질설계][시스템]수요가코드 누락(MES신규고객사코드DB적용필요)";
    public static final String ERRMSG_A211 = "[품질설계][시스템]수요가코드 미등록(MES신규고객사등록후,DB적용필요)";
    public static final String ERRMSG_A212 = "[품질설계][시스템]수요가코드 중복(MES신규고객사코드DB적용필요)";
    public static final String ERRMSG_A22 = "[품질설계][시스템]최종수요가코드 누락(MES신규고객사코드DB적용필요)";
    public static final String ERRMSG_A221 = "[품질설계][시스템]최종수요가코드 코드정의오류(MES신규고객사코드DB적용필요)";
    public static final String ERRMSG_A222 = "[품질설계][시스템]최종수요가코드 중복(MES신규고객사코드DB적용필요)";
    public static final String ERRMSG_A223 = "[품질설계][현업담당]고객사양번호 조합오류";   
    public static final String ERRMSG_A241 = "[품질설계][현업담당]고객사양공통기준(C10A1020) 고객사양번호가 없음";
    public static final String ERRMSG_A242 = "[품질설계][현업담당]고객사양공통기준(C10A1020) 고객사양번호가 중복";
    
    public static final String ERRMSG_A243 = "[품질설계][등록자,현업담당]입력한 주문용도와 고객사양공통의 주문용도가 다름";
    public static final String ERRMSG_A244 = "[품질설계][등록자,현업담당]입력한 규격약호와 고객사양공통의 규격약호가 다름";  
    public static final String ERRMSG_A245 = "[품질설계][등록자,현업담당]입력한 규격년도와 고객사양공통의 규격년도가 다름";
    public static final String ERRMSG_A246 = "[품질설계][등록자,현업담당]입력한 고객사와 고객사양공통의 고객사가 다름";    
    public static final String ERRMSG_A247 = "[품질설계][등록자,현업담당]입력한 품명과 고객사양공통의 품명과 다름";
    public static final String ERRMSG_A248 = "[품질설계][등록자,현업담당]입력한 주문두께와 고객사양공통의 주문두께가 다름";
    public static final String ERRMSG_A249 = "[품질설계][등록자,현업담당]입력한 주문폭과 고객사양공통의 주문폭이 다름"; 
    public static final String ERRMSG_A250 = "[품질설계][등록자,현업담당]입력한 주문길이와 고객사양공통의 주문길이가 다름"; 
    public static final String ERRMSG_A251 = "[품질설계][등록자,현업담당]입력한 두께구분와 고객사양공통의 두께구분이 다름";
    public static final String ERRMSG_A252 = "[품질설계][등록자,현업담당]입력한 도금량과 고객사양공통의 도금량이 다름";
    public static final String ERRMSG_A253 = "[품질설계][등록자,현업담당]입력한 표면처리와 고객사양공통의 표면처리가 다름"; 
    public static final String ERRMSG_A254 = "[품질설계][등록자,현업담당]색상코드 고객공통기준 상이";      
   
    public static final String ERRMSG_A341 = "[품질설계][현업담당]규격약호,년도가 기준에 없음(C10A1010)";
    public static final String ERRMSG_A342 = "[품질설계][현업담당]규격약호,년도가 기준에 중복(C10A1010)";
    public static final String ERRMSG_A93 = "[품질설계][현업담당]주문정보KEY Null";
    public static final String ERRMSG_A65 = "[품질설계][등록자]주문포장방법 누락";
    public static final String ERRMSG_A651 = "[품질설계][현업담당]주문포장방법 코드정의오류(포장방법카테고리확인)";
    public static final String ERRMSG_A652 = "[품질설계][현업담당]주문포장방법 중복";
    public static final String ERRMSG_A72 = "[품질설계][등록자]주문Spangle구분 누락";
    public static final String ERRMSG_A721 = "[품질설계][현업담당]주문Spangle구분 코드정의오류";
    public static final String ERRMSG_A61 = "[품질설계][등록자]도금량지정코드 누락";
    public static final String ERRMSG_A611 = "[품질설계][현업담당]도금량지정코드 정의오류";
    public static final String ERRMSG_A66 = "[품질설계][현업담당]도금보호필름상세코드 기준에 없음";
    public static final String ERRMSG_A661 = "[품질설계][현업담당]도금보호필름상세코드 기준에 중복";
    public static final String ERRMSG_A663 = "[품질설계][현업담당]해당CCLBOM의 칼라물성정보가 없음";
    public static final String ERRMSG_A664 = "[품질설계][현업담당]해당CCLBOM의 칼라물성정보가 중복";
    public static final String ERRMSG_A665 = "[품질설계][현업담당]주문의 보호필름과 해당CCLBOM의 보호필름이 다름 ";
    public static final String ERRMSG_A902 = "[품질설계][현업담당]주문의CCL_BOM이 MES에 없음";
    public static final String ERRMSG_A903 = "[품질설계][현업담당]주문의CCL_BOM이 MES에 중복";
    public static final String ERRMSG_A904 = "[품질설계][현업담당]주문의CCL_BOM에 사용불가 칼라코드가 있음";
    public static final String ERRMSG_A905 = "[품질설계][현업담당]주문의CCL_BOM에 사용불가 칼라코드 개수 조회 오류";
    public static final String ERRMSG_A200 = "[품질설계][현업담당]Master Code기준 오류";
    public static final String ERRMSG_A201 = "[품질설계][현업담당]Master Code기준 누락";
    public static final String ERRMSG_A782 = "[품질설계][현업담당]주문코일외경 범위초과"; 
    public static final String ERRMSG_A783 = "[품질설계][등록자]포장매수 단중MIN/MAX초과"; 
    public static final String ERRMSG_A784 = "[품질설계][등록자]단중범위 좁음";      

    // 동부
    public static final String ERRMSG_A34 = "주문폭이 기준에 불일치 합니다.";
    public static final String ERRMSG_A35 = "MainKey 기준 검색된 데이터가 없습니다.";
    public static final String ERRMSG_A36 = "수주가능 SIZE(C10B0320) 데이터가 없습니다.";
    public static final String ERRMSG_A37 = "규격 Header 검색된 데이터가 없습니다.";
    public static final String ERRMSG_A38 = "제강제조표준기술(C10A0011) 검색된 데이터가 없습니다.";
    public static final String ERRMSG_A39 = "주문용도기준(C10A0001) 검색된  데이터가 없습니다.";
    public static final String ERRMSG_A40 = "규격별용도기준(C10A0002) 데이터가 없습니다.";
    public static final String ERRMSG_A41 = "출강목표기준이 존재하지 하지 않습니다.";
    public static final String ERRMSG_A45 = "해당 주문의 고객사코드가 고객사사양번호에 포함되어 있지 않습니다.";
    public static final String ERRMSG_A46 = "해당 주문정보가 존재하지 않습니다.";
    public static final String ERRMSG_A50 = "원자재기준(C10B1063) 데이터가 없거나 많습니다.";
    public static final String ERRMSG_S33 = "주문오류체크 기준데이타가 존재하지 않습니다.";
    public static final String ERRMSG_K13 = "제조표준기준(C10B1051) 정보가 없습니다.";
    public static final String ERRMSG_K14 = "제조표준기준(C10B1051) 정보가 중복입니다.";
    public static final String ERRMSG_K55 = "ECL권치장력Set기준(C10B2140) 정보가 중복입니다.";
    public static final String ERRMSG_K54 = "ECL권치장력Set기준(C10B2140) 정보가 없습니다.";
    public static final String ERRMSG_K56 = "CGL Leveler Set기준(C10B2150) 정보가 없습니다.";
    public static final String ERRMSG_K57 = "CGL Leveler Set기준(C10B2150) 정보가 중복입니다.";

    public static final String ERRMSG_I01 = "[품질설계][현업담당]품질설계KEY미등록(품질설계원 설계KEY확인요)";
    public static final String ERRMSG_I02 = "[품질설계][등록자]고객사양번호 중복";
    public static final String ERRMSG_I03 = "[품질설계][등록자]고객사양번호 없음";
    public static final String ERRMSG_I04 = "[품질설계][등록자]규격약호,년도 중복(품질기준 오류)";
    public static final String ERRMSG_I05 = "[품질설계][현업담당]생산불가(규격약호,년도가 규격공통기준에 없음)";
    public static final String ERRMSG_I06 = "[품질설계][현업담당]규격인수도기준 없음(품질기준 오류)";
    public static final String ERRMSG_I07 = "[품질설계][현업담당]규격인수도기준 중복(품질기준 오류)";
    public static final String ERRMSG_I08 = "[품질설계][현업담당]도금량기준 중복(품질기준 오류)";
    public static final String ERRMSG_I09 = "[품질설계][현업담당]생산불가(도금량기준 없음)";
    public static final String ERRMSG_I10 = "[품질설계][현업담당]폭관리코드별 폭공차기준 중복";
    public static final String ERRMSG_I11 = "[품질설계][현업담당]폭관리코드별 폭공차기준 없음";
    public static final String ERRMSG_I12 = "[품질설계][현업담당]Size기준 없음(정전폭마진량)";
    public static final String ERRMSG_I13 = "[품질설계][현업담당]Size기준 중복(정전폭마진량)";
    public static final String ERRMSG_I14 = "[품질설계][현업담당]Size기준 없음(정전폭감소량)";
    public static final String ERRMSG_I15 = "[품질설계][현업담당]Size기준 중복(정전폭감소량)";
    public static final String ERRMSG_I16 = "[품질설계][현업담당]Size기준 없음(CCL폭감소량)";
    public static final String ERRMSG_I17 = "[품질설계][현업담당]Size기준 중복(CCL폭감소량)";
    public static final String ERRMSG_I18 = "[품질설계][현업담당]Size기준 없음(CGL폭감소량)";
    public static final String ERRMSG_I19 = "[품질설계][현업담당]Size기준 중복(CGL폭감소량)";
    public static final String ERRMSG_I20 = "[품질설계][현업담당]Size기준 없음(EGL폭감소량)";
    public static final String ERRMSG_I21 = "[품질설계][현업담당]Size기준 중복(EGL폭감소량)";
    public static final String ERRMSG_I22 = "[품질설계][현업담당]통과공정 기준 없음(통과공정번호 등록필요)";
    public static final String ERRMSG_I23 = "[품질설계][현업담당]원자재두께  결정기준 없음(C10B1071)";
    public static final String ERRMSG_I24 = "[품질설계][현업담당]원자재두께  결정기준 중복(C10B1071)";
    public static final String ERRMSG_I25 = "[품질설계][현업담당]Size기준 없음(PLTCM폭감소량)";
    public static final String ERRMSG_I26 = "[품질설계][현업담당]Size기준 중복(PLTCM폭감소량)";
    public static final String ERRMSG_I27 = "[품질설계][현업담당]Size기준 없음(PLTCM폭마진량)";
    public static final String ERRMSG_I28 = "[품질설계][현업담당]Size기준 중복(PLTCM폭마진량)";
    public static final String ERRMSG_I29 = "[품질설계][현업담당]압연두께Set치보정기준(C10B2060) 없음";
    public static final String ERRMSG_I30 = "[품질설계][현업담당]압연두께Set치보정기준(C10B2060) 중복";
    public static final String ERRMSG_I31 = "[품질설계][현업담당]생산불가(공정삭제기준에 의한 통과공정삭제)";
    public static final String ERRMSG_I32 = "[품질설계][현업담당]CCL BOM 정보 없음";
    public static final String ERRMSG_I33 = "[품질설계][현업담당]CCL BOM 정보 중복";
    public static final String ERRMSG_I34 = "[품질설계][현업담당]폭관리코드별 폭여유치기준 중복";
    public static final String ERRMSG_I35 = "[품질설계][현업담당]폭관리코드별 폭여유치기준 없음";
    public static final String ERRMSG_I36 = "[품질설계][현업담당]중간재적용기준 중복";
    public static final String ERRMSG_I37 = "[품질설계][현업담당]감량매직체크기준 중복";
    public static final String ERRMSG_I38 = "[품질설계][현업담당]설계KEY 적정, 차선 원자재 오류(품질설계원 설계KEY 확인요)";
    public static final String ERRMSG_I39 = "[품질설계][현업담당]지관발주메시지기준 중복";
    public static final String ERRMSG_I40 = "[품질설계][현업담당]PE-FOAM적용메시지기준 중복";
    public static final String ERRMSG_I41 = "[품질설계][현업담당]엠보스 1P선택 시 Imprint Roll필수선택";
    public static final String ERRMSG_I42 = "[품질설계][현업담당]엠보스 미선택 시 Imprint Roll선택불가";
	
    // public static final String ERRMSG_R01 =
    // "테이블에  고객 성분사양 편성정보 데이타가 존재하지 않습니다.";
    // public static final String ERRMSG_R04 =
    // "인수도공차기준값(C10B0040) MasterData에 해당 인수도 공차가 존재하지 않습니다";
    // public static final String ERRMSG_R05 = "출강목표번호가 존재하지 하지 않습니다.";
    // public static final String ERRMSG_R06 =
    // "Main key의 폭이 수주가능 size폭 사이에 존재하지 않습니다.";
    // public static final String ERRMSG_R07 = "강종구분이 존재하지 않습니다.";
    // public static final String ERRMSG_R08 = "의 값이 존재하지 않습니다.";
    // public static final String ERRMSG_R09 =
    // "출강목표의 성분(단일,계산식,복합) 검색된 데이타가 존재하지 않습니다.";
    // public static final String ERRMSG_R10 = "열연제조표준번호로 된 기준이 존재합니다.";
    // public static final String ERRMSG_R11 = "열연제조표준번호로 된 기준이 존재하지 않습니다.";
    // public static final String ERRMSG_R12 = " 해당조건에 만족하는 인수도 기준 존재하지  않습니다.";
    // public static final String ERRMSG_R13 = "인수도 규격코드값이 null이거나 공백입니다.";
    // public static final String ERRMSG_R14 = "가(이)  0보다 작습니다.";
    // public static final String ERRMSG_R15 = "가(이)  null입니다.";
    // public static final String ERRMSG_R16 = "가(이)  numeric이 아닙니다.";
    // public static final String ERRMSG_R17 = "가(이) 존재하지 않습니다.";
    // public static final String ERRMSG_R18 = "정의되지 않은 항목 타입입니다 :";
    // public static final String ERRMSG_R19 =
    // "getType() : 항목의 type을 찾을 수 없음. 전문 Format과 Property의 항목명을 점검 - ";
    // public static final String ERRMSG_R20 =
    // "시스템 ERROR입니다. 시스템 관리자에게 문의 하십시오.";
    public static final String EXCEPTION_MSG1 = "비트 사이즈를 초과하였습니다.";
    public static final String EXCEPTION_MSG2 = "PosContext에 Key로 @로 시작하는 값으로 넣었음. @를 뺀 변수명을 입력 :";
    public static final String EXCEPTION_MSG3 = "해당 Row가 존재하지 않습니다.";
    // EAI Error Msg
    public static final String ERRMSG_EAI1 = "품질설계DB에 해당주문번호가 등록되어 있습니다";
    public static final String ERRMSG_EAI2 = "주문항목 에러입니다";

    // ################################################
    // 2진수
    // ################################################

    public static final String BIN00 = "00";
    public static final String BIN01 = "01";
    public static final String BIN10 = "10";
    public static final String BIN11 = "11";

    // ################################################
    // 숫자형
    // ################################################

    public static final String NUM0070 = "SD0070"; // 규격공통전문id

    public static final String NUM0 = "0";
    public static final String NUM1 = "1";
    public static final String NUM2 = "2";
    public static final String NUM3 = "3";
    public static final String NUM4 = "4";
    public static final String NUM5 = "5";
    public static final String NUM6 = "6";
    public static final String NUM7 = "7";
    public static final String NUM8 = "8";
    public static final String NUM9 = "9";
    public static final String NUM100 = "100";
    public static final String NUM150 = "150";
    public static final String NUM200 = "200";
    public static final String NUM250 = "250";
    public static final String NUM300 = "300";
    public static final String NUM500 = "500";
    public static final String NUM1000 = "1000";
    public static final String NUM1630 = "1630";

    public static final String NUM3_1 = "3.1";
    public static final String NUM0_02 = "0.02";
    public static final String NUM0_002 = "0.002";
    public static final String NUM304_8 = "304.8";

    // ################################################
    // CHAR 형
    // ################################################

    public static final char CHAR_1 = '1';

    // ################################################
    // 칼럼명_범
    // ################################################
    /** 주문요청번호(생산가부요청시) */
    public static final String COL_ORD_REQ_NO = "ORD_REQ_NO";
    /** 주문요청행번(생산가부요청시) */
    public static final String COL_ORD_REQ_LN = "ORD_REQ_LN";

    /** 주문번호 */
    public static final String COL_ORD_NO = "ORD_NO";
    /** 주문행번 */
    public static final String COL_ORD_LN = "ORD_LN";
    /** 품질설계사양구분 */
    public static final String COL_QLT_DSN_SPC_TP = "QLT_DSN_SPC_TP";
    /** MaterialCode */
    public static final String COL_MTL_CD = "MTL_CD";
    /** 원자재코드 */
    public static final String COL_RMTL_CD = "RMTL_CD";
    /** 구매반제품 원자재여부 */
    public static final String COL_SEM_RMTL_YN = "SEM_RMTL_YN";
    /** 원자재등급 */
    public static final String COL_RMTL_GRD = "RMTL_GRD";
    /** 냉연제조표준번호 */
    public static final String COL_CRM_MNF_STD_NO = "CRM_MNF_STD_NO";
    /** 냉연제조표준번호1 */
    public static final String COL_CRM_MNF_STD_NO1 = "CRM_MNF_STD_NO1";
    /** 냉연제조표준번호2 */
    public static final String COL_CRM_MNF_STD_NO2 = "CRM_MNF_STD_NO2";
    /** 냉연제조표준번호3 */
    public static final String COL_CRM_MNF_STD_NO3 = "CRM_MNF_STD_NO3";

    /** 품질검토결과 */
    public static final String COL_QLT_SRT_RSL = "QLT_SRT_RSL";

    /** 주문에러체크 판단기준 */
    public static final String COL_PRD_PSL_YN = "PRD_PSL_YN";
    /** 고객요청납기일 */   
    public static final String COL_CUS_REQ_DLV_DD = "CUS_REQ_DLV_DD";

    /** TB_C10_QLT_DSN_CCL_BOM 품질설계 CCL-BOM */
    /** 주문번호 */
    /** 주문행번 */

    /** 코팅방식 */
    public static final String COL_COT_MTH = "COT_MTH";
    /** imprint roll */
    public static final String COL_IMPT_ROLL_NO = "IMPT_ROLL_NO";
    /** 색상코드전면 */
    // public static final String COL_HUE_CD_FRN ="HUE_CD_FRN";
    /** 색상코드후면 */
    // public static final String COL_HUE_CD_BAK ="HUE_CD_BAK";
    /** 색상코드SUB */
    public static final String COL_HUE_CD_SUB = "HUE_CD_SUB";
    /** 색상코드Chemical */
    public static final String COL_HUE_CD_CHM = "HUE_CD_CHM";
    /** 도막두께전면Total */
    // public static final String COL_PNT_FLM_THK_FRN_TOT
    // ="PNT_FLM_THK_FRN_TOT";
    /** 도막두께후면Total */
    // public static final String COL_PNT_FLM_THK_BAK_TOT
    // ="PNT_FLM_THK_BAK_TOT";
    /** 광택도코드전면 */
    // public static final String COL_LUS_RT_CD_FRN ="LUS_RT_CD_FRN";
    /** 광택도코드후면 */
    // public static final String COL_LUS_RT_CD_BAK ="LUS_RT_CD_BAK";
    /** 수지구분전면 */
    // public static final String COL_RSN_TP_FRN ="RSN_TP_FRN";
    /** 수지구분후면 */
    // public static final String COL_RSN_TP_BAK ="RSN_TP_BAK";
    /** 상세색상명 */
    public static final String COL_DTL_CLR_NM = "DTL_CLR_NM";
    /** 수지구분전면1Coat */
    public static final String COL_RSN_TP_FRN_1COT = "RSN_TP_FRN_1COT";
    /** 수지구분전면2Coat */
    public static final String COL_RSN_TP_FRN_2COT = "RSN_TP_FRN_2COT";
    /** 수지구분전면3Coat */
    public static final String COL_RSN_TP_FRN_3COT = "RSN_TP_FRN_3COT";
    /** 수지구분전면4Coat */
    public static final String COL_RSN_TP_FRN_4COT = "RSN_TP_FRN_4COT";
    /** 수지구분후면1Coat */
    public static final String COL_RSN_TP_BAK_1COT = "RSN_TP_BAK_1COT";
    /** 수지구분후면2Coat */
    public static final String COL_RSN_TP_BAK_2COT = "RSN_TP_BAK_2COT";
    /** 수지구분후면3Coat */
    public static final String COL_RSN_TP_BAK_3COT = "RSN_TP_BAK_3COT";
    /** 수지구분후면4Coat */
    public static final String COL_RSN_TP_BAK_4COT = "RSN_TP_BAK_4COT";
    /** 수지구분Lamina */
    public static final String COL_RSN_TP_LMN = "RSN_TP_LMN";
    /** 색상코드전면1Coat */
    public static final String COL_HUE_CD_FRN_1COT = "HUE_CD_FRN_1COT";
    /** 색상코드전면2Coat */
    public static final String COL_HUE_CD_FRN_2COT = "HUE_CD_FRN_2COT";
    /** 색상코드전면3Coat */
    public static final String COL_HUE_CD_FRN_3COT = "HUE_CD_FRN_3COT";
    /** 색상코드전면4Coat */
    public static final String COL_HUE_CD_FRN_4COT = "HUE_CD_FRN_4COT";
    /** 색상코드후면1Coat */
    public static final String COL_HUE_CD_BAK_1COT = "HUE_CD_BAK_1COT";
    /** 색상코드후면2Coat */
    public static final String COL_HUE_CD_BAK_2COT = "HUE_CD_BAK_2COT";
    /** 색상코드후면3Coat */
    public static final String COL_HUE_CD_BAK_3COT = "HUE_CD_BAK_3COT";
    /** 색상코드후면4Coat */
    public static final String COL_HUE_CD_BAK_4COT = "HUE_CD_BAK_4COT";
    /** 색상코드Lamina */
    public static final String COL_HUE_CD_LMN = "HUE_CD_LMN";
    /** 도막두께전면1Coat */
    public static final String COL_PNT_FLM_THK_FRN_1COT = "PNT_FLM_THK_FRN_1COT";
    /** 도막두께전면2Coat */
    public static final String COL_PNT_FLM_THK_FRN_2COT = "PNT_FLM_THK_FRN_2COT";
    /** 도막두께전면3Coat */
    public static final String COL_PNT_FLM_THK_FRN_3COT = "PNT_FLM_THK_FRN_3COT";
    /** 도막두께전면4Coat */
    public static final String COL_PNT_FLM_THK_FRN_4COT = "PNT_FLM_THK_FRN_4COT";
    /** 도막두께후면1Coat */
    public static final String COL_PNT_FLM_THK_BAK_1COT = "PNT_FLM_THK_BAK_1COT";
    /** 도막두께후면2Coat */
    public static final String COL_PNT_FLM_THK_BAK_2COT = "PNT_FLM_THK_BAK_2COT";
    /** 도막두께후면3Coat */
    public static final String COL_PNT_FLM_THK_BAK_3COT = "PNT_FLM_THK_BAK_3COT";
    /** 도막두께후면4Coat */
    public static final String COL_PNT_FLM_THK_BAK_4COT = "PNT_FLM_THK_BAK_4COT";
    /** 도막두께Lamina */
    public static final String COL_PNT_FLM_THK_LMN = "PNT_FLM_THK_LMN";
    /** 광택도코드전면1Coat */
    public static final String COL_LUS_RT_CD_FRN_1COT = "LUS_RT_CD_FRN_1COT";
    /** 광택도코드전면2Coat */
    public static final String COL_LUS_RT_CD_FRN_2COT = "LUS_RT_CD_FRN_2COT";
    /** 광택도코드전면3Coat */
    public static final String COL_LUS_RT_CD_FRN_3COT = "LUS_RT_CD_FRN_3COT";
    /** 광택도코드전면4Coat */
    public static final String COL_LUS_RT_CD_FRN_4COT = "LUS_RT_CD_FRN_4COT";
    /** 광택도코드후면1Coat */
    public static final String COL_LUS_RT_CD_BAK_1COT = "LUS_RT_CD_BAK_1COT";
    /** 광택도코드후면2Coat */
    public static final String COL_LUS_RT_CD_BAK_2COT = "LUS_RT_CD_BAK_2COT";
    /** 광택도코드후면3Coat */
    public static final String COL_LUS_RT_CD_BAK_3COT = "LUS_RT_CD_BAK_3COT";
    /** 광택도코드후면4Coat */
    public static final String COL_LUS_RT_CD_BAK_4COT = "LUS_RT_CD_BAK_4COT";
    /** 광택도코드Lamina */
    public static final String COL_LUS_RT_CD_LMN = "LUS_RT_CD_LMN";
    /** 광택도전면1Coat하한값 */
    public static final String COL_LUS_RT_FRN_1COT_LLV = "LUS_RT_FRN_1COT_LLV";
    /** 광택도전면1Coat상한값 */
    public static final String COL_LUS_RT_FRN_1COT_ULV = "LUS_RT_FRN_1COT_ULV";
    /** 광택도전면2Coat하한값 */
    public static final String COL_LUS_RT_FRN_2COT_LLV = "LUS_RT_FRN_2COT_LLV";
    /** 광택도전면2Coat상한값 */
    public static final String COL_LUS_RT_FRN_2COT_ULV = "LUS_RT_FRN_2COT_ULV";
    /** 광택도전면3Coat하한값 */
    public static final String COL_LUS_RT_FRN_3COT_LLV = "LUS_RT_FRN_3COT_LLV";
    /** 광택도전면3Coat상한값 */
    public static final String COL_LUS_RT_FRN_3COT_ULV = "LUS_RT_FRN_3COT_ULV";
    /** 광택도전면4Coat하한값 */
    public static final String COL_LUS_RT_FRN_4COT_LLV = "LUS_RT_FRN_4COT_LLV";
    /** 광택도전면4Coat상한값 */
    public static final String COL_LUS_RT_FRN_4COT_ULV = "LUS_RT_FRN_4COT_ULV";
    /** 광택도후면1Coat하한값 */
    public static final String COL_LUS_RT_BAK_1COT_LLV = "LUS_RT_BAK_1COT_LLV";
    /** 광택도후면1Coat상한값 */
    public static final String COL_LUS_RT_BAK_1COT_ULV = "LUS_RT_BAK_1COT_ULV";
    /** 광택도후면2Coat하한값 */
    public static final String COL_LUS_RT_BAK_2COT_LLV = "LUS_RT_BAK_2COT_LLV";
    /** 광택도후면2Coat상한값 */
    public static final String COL_LUS_RT_BAK_2COT_ULV = "LUS_RT_BAK_2COT_ULV";
    /** 광택도후면3Coat하한값 */
    public static final String COL_LUS_RT_BAK_3COT_LLV = "LUS_RT_BAK_3COT_LLV";
    /** 광택도후면3Coat상한값 */
    public static final String COL_LUS_RT_BAK_3COT_ULV = "LUS_RT_BAK_3COT_ULV";
    /** 광택도후면4Coat하한값 */
    public static final String COL_LUS_RT_BAK_4COT_LLV = "LUS_RT_BAK_4COT_LLV";
    /** 광택도후면4Coat상한값 */
    public static final String COL_LUS_RT_BAK_4COT_ULV = "LUS_RT_BAK_4COT_ULV";
    /** 광택도Lamina하한값 */
    public static final String COL_LUS_RT_LMN_LLV = "LUS_RT_LMN_LLV";
    /** 광택도Lamina상한값 */
    public static final String COL_LUS_RT_LMN_ULV = "LUS_RT_LMN_ULV";
    /** 작업점도전면1Coat */
    public static final String COL_WK_VISCO_FRN_1COT = "WK_VISCO_FRN_1COT";
    /** 작업점도전면2Coat */
    public static final String COL_WK_VISCO_FRN_2COT = "WK_VISCO_FRN_2COT";
    /** 작업점도전면3Coat */
    public static final String COL_WK_VISCO_FRN_3COT = "WK_VISCO_FRN_3COT";
    /** 작업점도전면4Coat */
    public static final String COL_WK_VISCO_FRN_4COT = "WK_VISCO_FRN_4COT";
    /** 작업점도후면1Coat */
    public static final String COL_WK_VISCO_BAK_1COT = "WK_VISCO_BAK_1COT";
    /** 작업점도후면2Coat */
    public static final String COL_WK_VISCO_BAK_2COT = "WK_VISCO_BAK_2COT";
    /** 작업점도후면3Coat */
    public static final String COL_WK_VISCO_BAK_3COT = "WK_VISCO_BAK_3COT";
    /** 작업점도후면4Coat */
    public static final String COL_WK_VISCO_BAK_4COT = "WK_VISCO_BAK_4COT";
    /** PMT전면1Coat */
    public static final String COL_PMT_FRN_1COT = "PMT_FRN_1COT";
    /** PMT전면2Coat */
    public static final String COL_PMT_FRN_2COT = "PMT_FRN_2COT";
    /** PMT전면3Coat */
    public static final String COL_PMT_FRN_3COT = "PMT_FRN_3COT";
    /** PMT전면4Coat */
    public static final String COL_PMT_FRN_4COT = "PMT_FRN_4COT";
    /** PMT후면1Coat */
    public static final String COL_PMT_BAK_1COT = "PMT_BAK_1COT";
    /** PMT후면2Coat */
    public static final String COL_PMT_BAK_2COT = "PMT_BAK_2COT";
    /** PMT후면3Coat */
    public static final String COL_PMT_BAK_3COT = "PMT_BAK_3COT";
    /** PMT후면4Coat */
    public static final String COL_PMT_BAK_4COT = "PMT_BAK_4COT";
    /** PMTLamina */
    public static final String COL_PMT_LMN = "PMT_LMN";
    /** 신나코드전면1Coat */
    public static final String COL_THR_CD_FRN_1COT = "THR_CD_FRN_1COT";
    /** 신나코드전면2Coat */
    public static final String COL_THR_CD_FRN_2COT = "THR_CD_FRN_2COT";
    /** 신나코드전면3Coat */
    public static final String COL_THR_CD_FRN_3COT = "THR_CD_FRN_3COT";
    /** 신나코드전면4Coat */
    public static final String COL_THR_CD_FRN_4COT = "THR_CD_FRN_4COT";
    /** 신나코드후면1Coat */
    public static final String COL_THR_CD_BAK_1COT = "THR_CD_BAK_1COT";
    /** 신나코드후면2Coat */
    public static final String COL_THR_CD_BAK_2COT = "THR_CD_BAK_2COT";
    /** 신나코드후면3Coat */
    public static final String COL_THR_CD_BAK_3COT = "THR_CD_BAK_3COT";
    /** 신나코드후면4Coat */
    public static final String COL_THR_CD_BAK_4COT = "THR_CD_BAK_4COT";
    /** 색차전면하한값 */
    public static final String COL_CLR_DIF_FRN_LLV = "CLR_DIF_FRN_LLV";
    /** 색차전면상한값 */
    public static final String COL_CLR_DIF_FRN_ULV = "CLR_DIF_FRN_ULV";
    /** 색차후면하한값 */
    public static final String COL_CLR_DIF_BAK_LLV = "CLR_DIF_BAK_LLV";
    /** 색차후면상한값 */
    public static final String COL_CLR_DIF_BAK_ULV = "CLR_DIF_BAK_ULV";
    /** 물성기준연필경도전면 */
    public static final String COL_MPR_BAS_PNCL_HRDN_FRN = "MPR_BAS_PNCL_HRDN_FRN";
    /** 물성기준연필경도후면 */
    public static final String COL_MPR_BAS_PNCL_HRDN_BAK = "MPR_BAS_PNCL_HRDN_BAK";
    /** 물성기준MEK전면 */
    public static final String COL_MPR_BAS_MEK_FRN = "MPR_BAS_MEK_FRN";
    /** 물성기준MEK후면 */
    public static final String COL_MPR_BAS_MEK_BAK = "MPR_BAS_MEK_BAK";
    /** 칼라Bending전면기준코드 */
    public static final String COL_CLR_BND_TST_FRN_STD_CD = "CLR_BND_TST_FRN_STD_CD";
    /** 칼라Bending시험전면평점 */
    public static final String COL_CLR_BND_TST_FRN_GRD_PNT = "CLR_BND_TST_FRN_GRD_PNT";
    /** 칼라Bending후면기준코드 */
    public static final String COL_CLR_BND_TST_BAK_STD_CD = "CLR_BND_TST_BAK_STD_CD";
    /** 칼라Bending시험후면평점 */
    public static final String COL_CLR_BND_TST_BAK_GRD_PNT = "CLR_BND_TST_BAK_GRD_PNT";
    /** 보호필름상세코드 */
    public static final String COL_PTT_FLM_DTL_CD = "PTT_FLM_DTL_CD";
    /** 신보호필름상세코드 */
    public static final String COL_PTT_FLM_DTL_CD_N = "PTT_FLM_DTL_CD_N";
    /** 보호필름광택코드 */
    public static final String COL_PTT_FLM_LUS_RT_CD = "PTT_FLM_LUS_RT_CD";
    /** 보호필름두께코드 */
    public static final String COL_PTT_FLM_THK_CD = "PTT_FLM_THK_CD";
    /** 보호필름재질코드 */
    public static final String COL_PTT_FLM_MQL_CD = "PTT_FLM_MQL_CD";
    /** 보호필름SUS점착력코드 */
    public static final String COL_PTT_FLM_SUS_ADH_CD = "PTT_FLM_SUS_ADH_CD";
    /** 신보호필름SUS점착력코드 */
    public static final String COL_PTT_FLM_SUS_ADH_CD_N = "PTT_FLM_SUS_ADH_CD_N";
    /** 보호필름제품점착력코드 */
    public static final String COL_PTT_FLM_PRD_ADH_CD = "PTT_FLM_PRD_ADH_CD";
    /** 보호필름코드 */
    public static final String COL_PTT_FLM_CD = "PTT_FLM_CD";
    /** 보호필름두께 */
    public static final String COL_PTT_FLM_THK = "PTT_FLM_THK";
    /** 보호필름폭 */
    public static final String COL_PTT_FLM_WTH = "PTT_FLM_WTH";
    /** 보호필름점착력하한 */
    public static final String COL_PTT_FLM_ADH_LLV = "PTT_FLM_ADH_LLV";
    /** 보호필름점착력상한 */
    public static final String COL_PTT_FLM_ADH_ULV = "PTT_FLM_ADH_ULV";
	/** UNI-GLS필름코드 */
    public static final String COL_UNI_GLS_FLM_CD = "UNI_GLS_FLM_CD";
	/** 보호필름관리 점착력 */
    public static final String COL_PTT_FLM_MNG_ADH_TXT = "PTT_FLM_MNG_ADH_TXT";
    /** Lamina유형 */
    public static final String COL_LMN_KND_TP = "LMN_KND_TP";
    /** Lamina접착제코드 */
    public static final String COL_LMN_BND_CD = "LMN_BND_CD";
    /** Lamina접착제신나코드 */
    public static final String COL_LMN_BND_THR_CD = "LMN_BND_THR_CD";
    /** PrintRollNo1도 */
    public static final String COL_PRT_ROLL_NO1 = "PRT_ROLL_NO1";
    /** PrintRollNo2도 */
    public static final String COL_PRT_ROLL_NO2 = "PRT_ROLL_NO2";
    /** PrintRollNo3도 */
    public static final String COL_PRT_ROLL_NO3 = "PRT_ROLL_NO3";
    /** PrintRollNo4도 */
    public static final String COL_PRT_ROLL_NO4 = "PRT_ROLL_NO4";
    /** PrintInkCode1도 */
    public static final String COL_PRT_INK_CD1 = "PRT_INK_CD1";
    /** PrintInkCode2도 */
    public static final String COL_PRT_INK_CD2 = "PRT_INK_CD2";
    /** PrintInkCode3도 */
    public static final String COL_PRT_INK_CD3 = "PRT_INK_CD3";
    /** PrintInkCode4도 */
    public static final String COL_PRT_INK_CD4 = "PRT_INK_CD4";
    /** PrintInkType1도 */
    public static final String COL_PRT_INK_TP1 = "PRT_INK_TP1";
    /** PrintInkType2도 */
    public static final String COL_PRT_INK_TP2 = "PRT_INK_TP2";
    /** PrintInkType3도 */
    public static final String COL_PRT_INK_TP3 = "PRT_INK_TP3";
    /** PrintInkType4도 */
    public static final String COL_PRT_INK_TP4 = "PRT_INK_TP4";
    /** CCL공정품질메시지 */
    public static final String COL_CCL_QLT_MSG_TXT = "CCL_QLT_MSG_TXT";
    /** KEY WRD1 */
    public static final String COL_KEY_WRD1 = "KEY_WRD1";
    /** KEY WRD2 */
    public static final String COL_KEY_WRD2 = "KEY_WRD2";
    /** KEY WRD3 */
    public static final String COL_KEY_WRD3 = "KEY_WRD3";
    /** KEY WRD4 */
    public static final String COL_KEY_WRD4 = "KEY_WRD4";
    /** 재단선유무 */
    public static final String COL_CUT_LN_YN = "CUT_LN_YN";

    /** TB_C10_MTL_MST Material_Code마스타 */
    /** 자재유형 */
    public static final String COL_MAT_TYPE = "MAT_TYPE";

    /** TB_C10_QLT_DSN_CHM 품질설계 성분 */
    /** 주문번호 */
    /** 주문행번 */
    /** 품질설계사양구분 */
    /** C하한값 */
    public static final String COL_C_LLV = "C_LLV";
    /** C상한값 */
    public static final String COL_C_ULV = "C_ULV";
    /** Si하한값 */
    public static final String COL_SI_LLV = "SI_LLV";
    /** Si상한값 */
    public static final String COL_SI_ULV = "SI_ULV";
    /** Mn하한값 */
    public static final String COL_MN_LLV = "MN_LLV";
    /** Mn상한값 */
    public static final String COL_MN_ULV = "MN_ULV";
    /** P하한값 */
    public static final String COL_P_LLV = "P_LLV";
    /** P상한값 */
    public static final String COL_P_ULV = "P_ULV";
    /** S하한값 */
    public static final String COL_S_LLV = "S_LLV";
    /** S상한값 */
    public static final String COL_S_ULV = "S_ULV";
    /** Cr하한값 */
    public static final String COL_CR_LLV = "CR_LLV";
    /** Cr상한값 */
    public static final String COL_CR_ULV = "CR_ULV";
    /** Ni하한값 */
    public static final String COL_NI_LLV = "NI_LLV";
    /** Ni상한값 */
    public static final String COL_NI_ULV = "NI_ULV";
    /** Cu하한값 */
    public static final String COL_CU_LLV = "CU_LLV";
    /** Cu상한값 */
    public static final String COL_CU_ULV = "CU_ULV";
    /** Al하한값 */
    public static final String COL_AL_LLV = "AL_LLV";
    /** Al상한값 */
    public static final String COL_AL_ULV = "AL_ULV";
    /** Ti하한값 */
    public static final String COL_TI_LLV = "TI_LLV";
    /** Ti상한값 */
    public static final String COL_TI_ULV = "TI_ULV";
    /** Nb하한값 */
    public static final String COL_NB_LLV = "NB_LLV";
    /** Nb상한값 */
    public static final String COL_NB_ULV = "NB_ULV";
    /** V하한값 */
    public static final String COL_V_LLV = "V_LLV";
    /** V상한값 */
    public static final String COL_V_ULV = "V_ULV";
    /** N하한값 */
    public static final String COL_N_LLV = "N_LLV";
    /** N상한값 */
    public static final String COL_N_ULV = "N_ULV";

    /** TB_C10_QLT_DSN_CMN 품질설계 공통 */
    /** 주문번호 */
    /** 주문행번 */
    /** 품질설계상태코드 */
    public static final String COL_QLT_DSN_STS_CD = "QLT_DSN_STS_CD";
    /** 플랜트구분 */
    public static final String COL_PLNT_TP = "PLNT_TP";
    /** 품명코드 */
    public static final String COL_PRD_NM_CD = "PRD_NM_CD";
    /** 제품형태 */
    public static final String COL_PRD_SHP = "PRD_SHP";
    /** 유통경로 */
    public static final String COL_FLOW_CHL = "FLOW_CHL";
    /** 주문종류 */
    public static final String COL_ORD_KND = "ORD_KND";
    /** 주문제품등급 */
    public static final String COL_ORD_PRD_GRD = "ORD_PRD_GRD";
    /** 주문용도코드 */
    public static final String COL_ORD_USG_CD = "ORD_USG_CD";
    /** 고객사코드 */
    public static final String COL_CUS_CD = "CUS_CD";
    /** 반복주문번호 */
    public static final String COL_ORD_REP_NO = "ORD_REP_NO";
    /** 반복주문행번 */
    public static final String COL_ORD_REP_LN = "ORD_REP_LN";
    /** 수요가코드 */
    public static final String COL_ACT_CUS_CD = "ACT_CUS_CD";
    /** 최종고객사코드 */
    public static final String COL_FNL_CUS_CD = "FNL_CUS_CD";
    /** 고객사양서번호 */
    public static final String COL_CUS_BTH_PAP_NO = "CUS_BTH_PAP_NO";
    /** 규격기관 */
    public static final String COL_SPC_OFC = "SPC_OFC";
    /** 규격약호 */
    public static final String COL_SPC_AVR = "SPC_AVR";
    /** 규격년도 */
    public static final String COL_SPC_YR = "SPC_YR";
    /** 주문생칫수 */
    public static final String COL_ORD_SZ = "ORD_SZ";
    /** 주문환산두께 */
    public static final String COL_ORD_EXC_THK = "ORD_EXC_THK";
    /** 주문환산폭 */
    public static final String COL_ORD_EXC_WTH = "ORD_EXC_WTH";
    /** 주문환산길이 */
    public static final String COL_ORD_EXC_LTH = "ORD_EXC_LTH";
    /** 주문납기시작일 */
    public static final String COL_ORD_PTL_STR_DD = "ORD_PTL_STR_DD";
    /** 주문납기종료일 */
    public static final String COL_ORD_PTL_END_DD = "ORD_PTL_END_DD";
    /** 도금량지정코드 */
    public static final String COL_GW_ASG_CD = "GW_ASG_CD";
    /** CCL_BOM번호 */
    public static final String COL_CCL_BOM_NO = "CCL_BOM_NO";
    /** 부적합 감량 메시지 */
    public static final String COL_DEF_RED_TXT = "DEF_RED_TXT";
    /** 지관발주메시지 */
    public static final String COL_PPR_RNG_PORD_TXT = "PPR_RNG_PORD_TXT";
    /** PE-FOAM 적용메시지 */
    public static final String COL_PE_FOAM_TXT = "PE_FOAM_TXT";
    /** 색상코드전면 */
    public static final String COL_HUE_CD_FRN = "HUE_CD_FRN";
    /** 색상코드후면 */
    public static final String COL_HUE_CD_BAK = "HUE_CD_BAK";
    /** 주문원판규격약호 */
    public static final String COL_ORD_ORG_PLT_SPC_AVR = "ORD_ORG_PLT_SPC_AVR";
    /** 주문조도코드 */
    public static final String COL_ORD_ROU_CD = "ORD_ROU_CD";
    /** 주문Spangle구분 */
    public static final String COL_ORD_SPNL_TP = "ORD_SPNL_TP";
    /** 주문권취방법 */
    public static final String COL_ORD_COILG_MTH = "ORD_COILG_MTH";
    /** 주문SkinPass지정여부 */
    public static final String COL_ORD_SP_ASG_YN = "ORD_SP_ASG_YN";
    /** 주문표면처리코드 */
    public static final String COL_ORD_SUR_HND_CD = "ORD_SUR_HND_CD";
    /** 주문조질도 */
    public static final String COL_ORD_SKP_DEG = "ORD_SKP_DEG";
    /** 조당최대중량 */
    public static final String COL_SLIT_MAX_WGT = "SLIT_MAX_WGT";
    /** 주문중량단위 */
    public static final String COL_ORD_WGT_UNT = "ORD_WGT_UNT";
    /** 중량결정법구분 */
    public static final String COL_WGT_DCS_MTH_TP = "WGT_DCS_MTH_TP";
    /** 주문내경링종류구분 */
    public static final String COL_ORD_SLV_KND_TP = "ORD_SLV_KND_TP";
    /** EMBOSS무늬 */
    public static final String COL_EMBS_CD = "EMBS_CD";
    /** 주문보호필름상세코드 */
    public static final String COL_ORD_PTT_FLM_DTL_CD = "ORD_PTT_FLM_DTL_CD";
    public static final String COL_ORD_PTT_FLM_CD = "ORD_PTT_FLM_CD"; // 오픈이후 삭제
    /** 주문보호필름폭 */
    public static final String COL_ORD_PTT_FLM_WTH = "ORD_PTT_FLM_WTH";
    /** 주문보호필름부착위치코드 */
    public static final String COL_ORD_PTT_FLM_ADH_LOC_CD = "ORD_PTT_FLM_ADH_LOC_CD";
    /** 주문행번중량 */
    public static final String COL_ORD_LN_WGT = "ORD_LN_WGT";
    /** 주문포장Sheet매수 */
    public static final String COL_ORD_PAK_SHT_CNT = "ORD_PAK_SHT_CNT";
    /** 주문포장단중하한값 */
    public static final String COL_ORD_PAK_UNT_WGT_LLV = "ORD_PAK_UNT_WGT_LLV";
    /** 주문포장단중상한값 */
    public static final String COL_ORD_PAK_UNT_WGT_ULV = "ORD_PAK_UNT_WGT_ULV";
    /** 주문인도허용차하한값 */
    public static final String COL_ORD_DLV_ALW_DIF_LLV = "ORD_DLV_ALW_DIF_LLV";
    /** 주문인도허용차상한값 */
    public static final String COL_ORD_DLV_ALW_DIF_ULV = "ORD_DLV_ALW_DIF_ULV";
    /** 주문포장길이하한값 */
    public static final String COL_ORD_PAK_LTH_LLV = "ORD_PAK_LTH_LLV";
    /** 주문포장길이상한값 */
    public static final String COL_ORD_PAK_LTH_ULV = "ORD_PAK_LTH_ULV";
    /** 주문정포장하한값 */
    public static final String COL_ORD_STDP_LLV = "ORD_STDP_LLV";
    /** 주문정포장상한값 */
    public static final String COL_ORD_STDP_ULV = "ORD_STDP_ULV";
    /** 주문정포장매수하한값 */
    public static final String COL_ORD_STDP_CNT_LLV = "ORD_STDP_CNT_LLV";
    /** 주문정포장매수상한값 */
    public static final String COL_ORD_STDP_CNT_ULV = "ORD_STDP_CNT_ULV";
    /** 주문포장당매수 */
    public static final String COL_ORD_PAK_UNT_CNT = "ORD_PAK_UNT_CNT";
    /** 주문포장당중량 */
    public static final String COL_ORD_PAK_UNT_WGT = "ORD_PAK_UNT_WGT";
    /** 주문소포장중량 */
    public static final String COL_ORD_SML_PAK_WGT = "ORD_SML_PAK_WGT";
    /** 주문소포장혼입율 */
    public static final String COL_ORD_SML_PAK_MIR = "ORD_SML_PAK_MIR";
    /** 주문단위중량 */
    public static final String COL_ORD_UNT_WGT = "ORD_UNT_WGT";
    /** 주문포장방법 */
    public static final String COL_ORD_PAK_MTH = "ORD_PAK_MTH";
    /** 주문코일내경 */
    public static final String COL_ORD_COIL_IDIA = "ORD_COIL_IDIA";
    /** 주문코일외경 */
    public static final String COL_ORD_COIL_ODIA = "ORD_COIL_ODIA";
    /** 주문두께공차상한값 */
    public static final String COL_ORD_THK_TLN_ULV = "ORD_THK_TLN_ULV";
    /** 주문두께공차하한값 */
    public static final String COL_ORD_THK_TLN_LLV = "ORD_THK_TLN_LLV";
    /** 주문폭공차하한값 */
    public static final String COL_ORD_WTH_TLN_LLV = "ORD_WTH_TLN_LLV";
    /** 주문폭공차상한값 */
    public static final String COL_ORD_WTH_TLN_ULV = "ORD_WTH_TLN_ULV";
    /** 주문길이공차하한값 */
    public static final String COL_ORD_LTH_TLN_LLV = "ORD_LTH_TLN_LLV";
    /** 주문길이공차상한값 */
    public static final String COL_ORD_LTH_TLN_ULV = "ORD_LTH_TLN_ULV";
    /** 도막두께전면Total */
    public static final String COL_PNT_FLM_THK_FRN_TOT = "PNT_FLM_THK_FRN_TOT";
    /** 도막두께후면Total */
    public static final String COL_PNT_FLM_THK_BAK_TOT = "PNT_FLM_THK_BAK_TOT";
    /** 수지구분전면 */
    public static final String COL_RSN_TP_FRN = "RSN_TP_FRN";
    /** 수지구분후면 */
    public static final String COL_RSN_TP_BAK = "RSN_TP_BAK";
    /** 광택도코드전면 */
    public static final String COL_LUS_RT_CD_FRN = "LUS_RT_CD_FRN";
    /** 광택도코드후면 */
    public static final String COL_LUS_RT_CD_BAK = "LUS_RT_CD_BAK";
    /** 고객요청압연두께 */
    public static final String COL_CUS_REQ_ROL_THK = "CUS_REQ_ROL_THK";
    /** 고객요청압연두께단위 */
    public static final String COL_CUS_REQ_ROL_THK_UNT = "CUS_REQ_ROL_THK_UNT";
    /** 주문두께구분 */
    public static final String COL_ORD_THK_TP = "ORD_THK_TP";
    /** 주문두께관리코드 */
    public static final String COL_ORD_THK_MNG_CD = "ORD_THK_MNG_CD";
    /** 주문폭관리코드 */
    public static final String COL_ORD_WTH_MNG_CD = "ORD_WTH_MNG_CD";
    /** 주문길이관리코드 */
    public static final String COL_ORD_LTH_MNG_CD = "ORD_LTH_MNG_CD";
    /** 고객정의색상 */
    public static final String COL_CUS_REQ_CLR_NM = "CUS_REQ_CLR_NM";
    /** 긴급재구분 */
    public static final String COL_URG_MTL_TP = "URG_MTL_TP";
    /** 주문접수일 */
    public static final String COL_ORD_RCP_DD = "ORD_RCP_DD";
    /** 주문Sheet적재방법 */
    public static final String COL_ORD_SHT_LOD_MTH = "ORD_SHT_LOD_MTH";
    /** 주문Sheet매수 */
    public static final String COL_ORD_SHT_CNT = "ORD_SHT_CNT";
    /** 주문Slit조수 */
    public static final String COL_ORD_SLIT_GRP_CNT = "ORD_SLIT_GRP_CNT";
    /** 주문조합폭1 */
    public static final String COL_ORD_MIX_WTH1 = "ORD_MIX_WTH1";
    /** 주문조합폭2 */
    public static final String COL_ORD_MIX_WTH2 = "ORD_MIX_WTH2";
    /** 주문조합폭3 */
    public static final String COL_ORD_MIX_WTH3 = "ORD_MIX_WTH3";
    /** 주문조합폭4 */
    public static final String COL_ORD_MIX_WTH4 = "ORD_MIX_WTH4";
    /** 주문조합폭5 */
    public static final String COL_ORD_MIX_WTH5 = "ORD_MIX_WTH5";
    /** 주문조합폭6 */
    public static final String COL_ORD_MIX_WTH6 = "ORD_MIX_WTH6";
    /** 주문조합폭7 */
    public static final String COL_ORD_MIX_WTH7 = "ORD_MIX_WTH7";
    /** 주문조합폭8 */
    public static final String COL_ORD_MIX_WTH8 = "ORD_MIX_WTH8";
    /** 주문조합폭9 */
    public static final String COL_ORD_MIX_WTH9 = "ORD_MIX_WTH9";
    /** 주문조합폭10 */
    public static final String COL_ORD_MIX_WTH10 = "ORD_MIX_WTH10";
    /** 원자재선호도 */
    public static final String COL_RMTL_PRFR_CD = "RMTL_PRFR_CD";
    /** Back마킹 */
    public static final String COL_BAK_MRK = "BAK_MRK";
    /** 위탁임가공여부 */
    public static final String COL_TRST_PROC_YN = "TRST_PROC_YN";
    /** Tag유형 */
    public static final String COL_TAG_TP = "TAG_TP";
    /** 국가코드 */
    public static final String COL_NAT_CD = "NAT_CD";
    /** 주문수정일 */
    public static final String COL_ORD_MDF_DD = "ORD_MDF_DD";
    /** 주문확정일 */
    public static final String COL_ORD_CFM_DD = "ORD_CFM_DD";
    /** 주문등록자 */
    public static final String COL_ORD_RGS_PRS_ID = "ORD_RGS_PRS_ID";
    /** 영업팀코드 */
    public static final String COL_ORD_TEM_CD = "ORD_TEM_CD";
    /** 주문특기사항 */
    public static final String COL_ORD_SPC_TXT = "ORD_SPC_TXT";
    /** 품질메세지코드 */
    public static final String COL_PAK_MSG_CD = "PAK_MSG_CD";    
    /** MaterialCode */
    /** ClassCode */
    public static final String COL_CLS_CD = "CLS_CD";
    /** SubClassCode */
    public static final String COL_SUB_CLS_CD = "SUB_CLS_CD";
    /** 품질설계완료일시 */
    public static final String COL_QLT_DSN_END_DH = "QLT_DSN_END_DH";
    /** 품질설계지시일시 */
    public static final String COL_QLT_DSN_INST_DH = "QLT_DSN_INST_DH";
    /** 품질설계자ID */
    public static final String COL_QLT_DSN_PRS_ID = "QLT_DSN_PRS_ID";
    /** 재질코드 */
    public static final String COL_MQL_CD = "MQL_CD";
    /** 주문포장재중량 */
    public static final String COL_ORD_PAK_MTL_WGT = "ORD_PAK_MTL_WGT";
    /** 원자재코드 */
    /** 원자재등급 */
    /** 통과공정번호 */
    public static final String COL_PAS_PROC_NO = "PAS_PROC_NO";
    /** 품질설계확정구분 */
    public static final String COL_QLT_DSN_CFM_TP = "QLT_DSN_CFM_TP";
    /** OMS품질설계확정구분 */
    public static final String COL_ORD_DSN_CFM_TP = "ORD_DSN_CFM_TP";
    /** 주문종결구분 */
    public static final String COL_ORD_END_TP = "ORD_END_TP";
    /** 주문종결일 */
    public static final String COL_ORD_END_DD = "ORD_END_DD";
    /** 주문종결자 */
    public static final String COL_ORD_END_PRS_ID = "ORD_END_PRS_ID";
    /** 주문Edge지정구분 */
    public static final String COL_ORD_EDG_ASG_TP = "ORD_EDG_ASG_TP";
    /** 주문비중 */
    public static final String COL_ORD_GRA = "ORD_GRA";
    /** 비중 */
    public static final String COL_GRA = "GRA";
    /** 규격명 */
    public static final String COL_SPC_NM = "SPC_NM";
    /** 규격 풀 네임 */
    public static final String COL_SPC_FUL_NM = "SPC_FUL_NM";
    /** 품질설계에러여부 */
    public static final String COL_QLT_DSN_ERR_YN = "QLT_DSN_ERR_YN";
    /** 관심주문여부 */
    public static final String COL_ATT_ORD_YN = "ATT_ORD_YN";
    /** 광신스틸임가공주문여부 */
    public static final String COL_POC_AUTO_YN = "POC_AUTO_YN";
    /** CGL임가공주문여부 */
    public static final String COL_POC_CGL_YN = "POC_CGL_YN";
    /** CCL임가공주문여부 */
    public static final String COL_POC_CCL_YN = "POC_CCL_YN";
    /** MD길이범위 상한 */
    public static final String COL_PRD_LTH_RNG_ULV = "PRD_LTH_RNG_ULV";
    /** MD길이범위 하한 */
    public static final String COL_PRD_LTH_RNG_LLV = "PRD_LTH_RNG_LLV";
    /** 원자재코드1 */
    public static final String COL_RMTL_CD1 = "RMTL_CD1";
    /** 원자재코드2 */
    public static final String COL_RMTL_CD2 = "RMTL_CD2";
    /** 원자재코드3 */
    public static final String COL_RMTL_CD3 = "RMTL_CD3";
    /** 제품두께계산적용코드 */
    public static final String COL_PRD_THK_CAL_APL_CD = "PRD_THK_CAL_APL_CD";
    /** 외관검사기준코드 */
    public static final String COL_APR_INP_BAS_CD = "APR_INP_BAS_CD";
    /** TagPO번호2 */
    public static final String COL_TAG_PO_NO2 = "TAG_PO_NO2";
    /** 보호필름미부착폭WS */
    public static final String COL_PTT_FLM_NOT_ADH_WS = "PTT_FLM_NOT_ADH_WS";
    /** 보호필름미부착폭DS */
    public static final String COL_PTT_FLM_NOT_ADH_DS = "PTT_FLM_NOT_ADH_DS";
    /** TagPartNo */
    public static final String COL_TAG_PART_NO = "TAG_PART_NO";
    /** MO전환주문여부 */
    public static final String COL_MO_CVT_ORD_YN = "MO_CVT_ORD_YN";

    /** TB_C10_QLT_DSN_DLV 품질설계 인수도 */
    /** 주문번호 */
    /** 주문행번 */
    /** 품질설계사양구분 */
    /** 두께공차상한값 */
    public static final String COL_THK_TLN_ULV = "THK_TLN_ULV";
    /** 두께공차하한값 */
    public static final String COL_THK_TLN_LLV = "THK_TLN_LLV";
    /** 폭공차하한값 */
    public static final String COL_WTH_TLN_LLV = "WTH_TLN_LLV";
    /** 폭공차상한값 */
    public static final String COL_WTH_TLN_ULV = "WTH_TLN_ULV";
    /** 길이공차하한값 */
    public static final String COL_LTH_TLN_LLV = "LTH_TLN_LLV";
    /** 길이공차상한값 */
    public static final String COL_LTH_TLN_ULV = "LTH_TLN_ULV";
    /** 반곡H */
    public static final String COL_HWAV_H = "HWAV_H";
    /** 중곡H */
    public static final String COL_MWAV_H = "MWAV_H";
    /** 외곡H */
    public static final String COL_EWAV_H = "EWAV_H";
    /** 직선도상한값 */
    public static final String COL_SLR_ULV = "SLR_ULV";
    /** 직각도상한값 */
    public static final String COL_RAR_ULV = "RAR_ULV";
    /** 대각선차상한값 */
    public static final String COL_DGLN_DIF_ULV = "DGLN_DIF_ULV";
    /** 급준도 */
    public static final String COL_STPN = "STPN";
    /** Telescope */
    public static final String COL_TLC = "TLC";

    /** 인수도규격 */
    public static final String COL_ACPT_RT_SPC = "ACPT_RT_SPC";

    /** TB_C10_QLT_DSN_ERR 품질설계 에러 */
    /** 주문번호 */
    /** 주문행번 */
    /** 품질설계에러코드 */
    public static final String COL_QLT_DSN_ERR_CD = "QLT_DSN_ERR_CD";
    /** 품질설계에러발생일 */
    public static final String COL_QLT_DSN_ERR_DD = "QLT_DSN_ERR_DD";

    /** TB_C10_QLT_DSN_MNF 품질설계 제조표준 */
    /** 주문번호 */
    /** 주문행번 */
    /** 원자재코드 */
    /** 냉연제조표준번호 */
    /** 품질설계제조구분 */
    public static final String COL_QLT_DSN_MNF_TP = "QLT_DSN_MNF_TP";
    /** PLTCM5StandWRType */
    public static final String COL_PLTCM_5STD_WR_TP = "PLTCM_5STD_WR_TP";
    /** PLTCM내경링사용여부 */
    public static final String COL_PLTCM_SLV_USE_YN = "PLTCM_SLV_USE_YN";
    /** ECLC-D방지약품 */
    public static final String COL_ECL_CDR_CD = "ECL_CDR_CD";
    /** ECL권취장력 */
    public static final String COL_ECL_COILG_TS_CD = "ECL_COILG_TS_CD";
    /** 일반ANN소둔로유형 */
    public static final String COL_FUR_TP_GEN_ANN = "FUR_TP_GEN_ANN";
    /** 일반ANN소둔CYCLE */
    public static final String COL_HEAT_CYL_NO_GEN_ANN = "HEAT_CYL_NO_GEN_ANN";
    /** 일반ANN소둔보정시간 */
    public static final String COL_COR_TM_GEN_ANN = "COR_TM_GEN_ANN";
    /** 일반ANN코일온도 */
    public static final String COL_COIL_TMP_GEN_ANN = "COIL_TMP_GEN_ANN";
    /** 일반ANN냉각종료온도 */
    public static final String COL_CLG_END_TMP_GEN_ANN = "CLG_END_TMP_GEN_ANN";
    /** HCANN소둔로유형 */
    public static final String COL_FUR_TP_HC_ANN = "FUR_TP_HC_ANN";
    /** HCANN소둔CYCLE */
    public static final String COL_HEAT_CYL_NO_HC_ANN = "HEAT_CYL_NO_HC_ANN";
    /** HCANN소둔보정시간 */
    public static final String COL_COR_TM_HC_ANN = "COR_TM_HC_ANN";
    /** HCANN코일온도 */
    public static final String COL_COIL_TMP_HC_ANN = "COIL_TMP_HC_ANN";
    /** HCANN냉각종료온도 */
    public static final String COL_CLG_END_TMP_HC_ANN = "CLG_END_TMP_HC_ANN";
    /** TMPass수 */
    public static final String COL_TM_PASS_CNT = "TM_PASS_CNT";
    /** 조도RA하한값 */
    public static final String COL_ROU_RA_LLV = "ROU_RA_LLV";
    /** 조도RA상한값 */
    public static final String COL_ROU_RA_ULV = "ROU_RA_ULV";
    /** 조도PPI하한값 */
    public static final String COL_ROU_PPI_LLV = "ROU_PPI_LLV";
    /** 조도PPI상한값 */
    public static final String COL_ROU_PPI_ULV = "ROU_PPI_ULV";
    /** 조도RMAX하한값 */
    public static final String COL_ROU_R_MAX_LLV = "ROU_R_MAX_LLV";
    /** 소둔CYCLE#2CGL */
    public static final String COL_HEAT_CYL_NO_2CGL = "HEAT_CYL_NO_2CGL";
    /** 가열온도#2CGL */
    public static final String COL_HTG_TEM_2CGL = "HTG_TEM_2CGL";
    /** 냉각온도#2CGL */
    public static final String COL_CLG_TEM_2CGL = "CLG_TEM_2CGL";
    /** ShockingTime#2CGL */
    public static final String COL_SHK_TM_2CGL = "SHK_TM_2CGL";
    /** LineSpeed#2CGL */
    public static final String COL_LN_SPD_2CGL = "LN_SPD_2CGL";
    /** 소둔CYCLE#3CGL */
    public static final String COL_HEAT_CYL_NO_3CGL = "HEAT_CYL_NO_3CGL";
    /** 가열온도#3CGL */
    public static final String COL_HTG_TEM_3CGL = "HTG_TEM_3CGL";
    /** 냉각온도#3CGL */
    public static final String COL_CLG_TEM_3CGL = "CLG_TEM_3CGL";
    /** ShockingTime#3CGL */
    public static final String COL_SHK_TM_3CGL = "SHK_TM_3CGL";
    /** LineSpeed#3CGL */
    public static final String COL_LN_SPD_3CGL = "LN_SPD_3CGL";
    /** 소둔CYCLE#4CGL */
    public static final String COL_HEAT_CYL_NO_4CGL = "HEAT_CYL_NO_4CGL";
    /** 가열온도#4CGL */
    public static final String COL_HTG_TEM_4CGL = "HTG_TEM_4CGL";
    /** 냉각온도#4CGL */
    public static final String COL_CLG_TEM_4CGL = "CLG_TEM_4CGL";
    /** ShockingTime#4CGL */
    public static final String COL_SHK_TM_4CGL = "SHK_TM_4CGL";
    /** LineSpeed#4CGL */
    public static final String COL_LN_SPD_4CGL = "LN_SPD_4CGL";
    /** 소둔CYCLE#5CGL */
    public static final String COL_HEAT_CYL_NO_5CGL = "HEAT_CYL_NO_5CGL";
    /** 가열온도#5CGL */
    public static final String COL_HTG_TEM_5CGL = "HTG_TEM_5CGL";
    /** 냉각온도#5CGL */
    public static final String COL_CLG_TEM_5CGL = "CLG_TEM_5CGL";
    /** ShockingTime#5CGL */
    public static final String COL_SHK_TM_5CGL = "SHK_TM_5CGL";
    /** LineSpeed#5CGL */
    public static final String COL_LN_SPD_5CGL = "LN_SPD_5CGL";
    /** Spangle구분 */
    public static final String COL_SPNL_TP = "SPNL_TP";
    /** CGLLeveler사용여부 */
    public static final String COL_CGL_LVL_YN = "CGL_LVL_YN";
    /** CGLSkinPass */
    public static final String COL_CGL_SP_ASG_YN = "CGL_SP_ASG_YN";
    /** CGL표면처리코드 */
    public static final String COL_CGL_SUR_HND_CD = "CGL_SUR_HND_CD";
    /** EGL표면처리코드 */
    public static final String COL_EGL_SUR_HND_CD = "EGL_SUR_HND_CD";
    /** 수지부착량기준목표 */
    public static final String COL_RSN_ATT_AMT_TRV = "RSN_ATT_AMT_TRV";
    /** 수지부착량기준하한 */
    public static final String COL_RSN_ATT_AMT_LLV = "RSN_ATT_AMT_LLV";
    /** 수지부착량기준상한 */
    public static final String COL_RSN_ATT_AMT_ULV = "RSN_ATT_AMT_ULV";
    /** 작업도금량목표값 */
    public static final String COL_WK_GW_TRV = "WK_GW_TRV";
    /** 작업도금량전면상한값 */
    public static final String COL_WK_GW_FRN_ULV = "WK_GW_FRN_ULV";
    /** 작업도금량전면하한값 */
    public static final String COL_WK_GW_FRN_LLV = "WK_GW_FRN_LLV";
    /** 작업도금량후면상한값 */
    public static final String COL_WK_GW_BAK_ULV = "WK_GW_BAK_ULV";
    /** 작업도금량후면하한값 */
    public static final String COL_WK_GW_BAK_LLV = "WK_GW_BAK_LLV";
    /** 작업도금량전체상한값 */
    public static final String COL_WK_GW_TOT_ULV = "WK_GW_TOT_ULV";
    /** 작업도금량전체하한값 */
    public static final String COL_WK_GW_TOT_LLV = "WK_GW_TOT_LLV";
    /** Piling방향 */
    public static final String COL_PIL_DIR = "PIL_DIR";
    /** 도유코드 */
    public static final String COL_OIL_PNT_CD = "OIL_PNT_CD";
    /** 제품두께범위하한값 */
    public static final String COL_PRD_THK_RNG_LLV = "PRD_THK_RNG_LLV";
    /** 제품두께범위상한값 */
    public static final String COL_PRD_THK_RNG_ULV = "PRD_THK_RNG_ULV";
    /** 제품폭범위하한값 */
    public static final String COL_PRD_WTH_RNG_LLV = "PRD_WTH_RNG_LLV";
    /** 제품폭범위상한값 */
    public static final String COL_PRD_WTH_RNG_ULV = "PRD_WTH_RNG_ULV";
    /** 도금두께하한 */
    public static final String COL_GAL_THK_LLV = "GAL_THK_LLV";
    /** 도금두께상한 */
    public static final String COL_GAL_THK_ULV = "GAL_THK_ULV";
    /** 도금두께목표 */
    public static final String COL_GAL_THK_TRV = "GAL_THK_TRV";
    /** 사양도금두께 */
    public static final String COL_SPC_GAL_THK = "SPC_GAL_THK";
    /** 정전두께목표값 */
    public static final String COL_COR_THK_TRV = "COR_THK_TRV";
    /** 정전폭목표값 */
    public static final String COL_COR_WTH_TRV = "COR_WTH_TRV";
    /** CGL두께목표값 */
    public static final String COL_CGL_THK_TRV = "CGL_THK_TRV";
    /** CGL폭목표값 */
    public static final String COL_CGL_WTH_TRV = "CGL_WTH_TRV";
    /** EGL두께목표값 */
    public static final String COL_EGL_THK_TRV = "EGL_THK_TRV";
    /** EGL폭목표값 */
    public static final String COL_EGL_WTH_TRV = "EGL_WTH_TRV";
    /** TM두께목표값 */
    public static final String COL_TM_THK_TRV = "TM_THK_TRV";
    /** TM폭목표값 */
    public static final String COL_TM_WTH_TRV = "TM_WTH_TRV";
    /** TM폭대체공정1목표값 */
    public static final String COL_TM_WTH_SUB_PROC1_TRV = "TM_WTH_SUB_PROC1_TRV";
    /** TM폭대체공정2목표값 */
    public static final String COL_TM_WTH_SUB_PROC2_TRV = "TM_WTH_SUB_PROC2_TRV";
    /** PLTCMX-RaySet두께값 */
    public static final String COL_PLTCM_SET_THK_TRV = "PLTCM_SET_THK_TRV";
    /** PLTCM두께목표값 */
    public static final String COL_PLTCM_THK_TRV = "PLTCM_THK_TRV";
    /** PLTCM두께하한값 */
    public static final String COL_PLTCM_THK_LLV = "PLTCM_THK_LLV";
    /** PLTCM두께상한값 */
    public static final String COL_PLTCM_THK_ULV = "PLTCM_THK_ULV";
    /** PLTCM폭목표값 */
    public static final String COL_PLTCM_WTH_TRV = "PLTCM_WTH_TRV";
    /** PLTCM폭대체공정1목표값 */
    public static final String COL_PLTCM_WTH_SUB_PROC1_TRV = "PLTCM_WTH_SUB_PROC1_TRV";
    /** PLTCM폭대체공정2목표값 */
    public static final String COL_PLTCM_WTH_SUB_PROC2_TRV = "PLTCM_WTH_SUB_PROC2_TRV";
    /** PLTCMEdge지정구분 */
    public static final String COL_PLTCM_EDG_ASG_TP = "PLTCM_EDG_ASG_TP";
    /** 정전Edge지정구분 */
    public static final String COL_COR_EDG_ASG_TP = "COR_EDG_ASG_TP";

    /** 부착량 기준목표 */
    public static final String COL_ATT_AMT_TRV = "ATT_AMT_TRV";
    /** 부착량하한 */
    public static final String COL_ATT_AMT_LLV = "ATT_AMT_LLV";
    /** 부착량상한 */
    public static final String COL_ATT_AMT_ULV = "ATT_AMT_ULV";
    /** 조도하한 */
    public static final String COL_RA_LLV = "RA_LLV";
    /** 조도상한 */
    public static final String COL_RA_ULV = "RA_ULV";

    /** Slit조수 */
    public static final String COL_SLIT_GRP_CNT = "SLIT_GRP_CNT";
    /** 조합폭1 */
    public static final String COL_MIX_WTH1 = "MIX_WTH1";
    /** 조합폭2 */
    public static final String COL_MIX_WTH2 = "MIX_WTH2";
    /** 조합폭3 */
    public static final String COL_MIX_WTH3 = "MIX_WTH3";
    /** 조합폭4 */
    public static final String COL_MIX_WTH4 = "MIX_WTH4";
    /** 조합폭5 */
    public static final String COL_MIX_WTH5 = "MIX_WTH5";
    /** 조합폭6 */
    public static final String COL_MIX_WTH6 = "MIX_WTH6";
    /** 조합폭7 */
    public static final String COL_MIX_WTH7 = "MIX_WTH7";
    /** 조합폭8 */
    public static final String COL_MIX_WTH8 = "MIX_WTH8";
    /** 조합폭9 */
    public static final String COL_MIX_WTH9 = "MIX_WTH9";
    /** 조합폭10 */
    public static final String COL_MIX_WTH10 = "MIX_WTH10";
    /** 중간정전목표두께 */
    public static final String COL_MID_COR_THK_TRV = "MID_COR_THK_TRV";
    /** 중간정전목표폭 */
    public static final String COL_MID_COR_WTH_TRV = "MID_COR_WTH_TRV";
    /** CCL목표두께 */
    public static final String COL_CCL_THK_TRV = "CCL_THK_TRV";
    /** CCL목표폭 */
    public static final String COL_CCL_WTH_TRV = "CCL_WTH_TRV";

    /** PL폭목표값 */
    public static final String COL_PL_WTH_TRV = "PL_WTH_TRV";
    /** PL폭대체공정1목표값 */
    public static final String COL_PL_WTH_SUB_PROC1_TRV = "PL_WTH_SUB_PROC1_TRV";
    /** PL폭대체공정2목표값 */
    public static final String COL_PL_WTH_SUB_PROC2_TRV = "PL_WTH_SUB_PROC2_TRV";

    /** 제품두께규격범위하한값 */
    public static final String COL_PRD_THK_SPC_RNG_LLV = "PRD_THK_SPC_RNG_LLV";
    /** 제품두께규격범위상한값 */
    public static final String COL_PRD_THK_SPC_RNG_ULV = "PRD_THK_SPC_RNG_ULV";

    /** TB_C10_QLT_DSN_MQL 품질설계 재질 */
    /** 주문번호 */
    /** 주문행번 */
    /** 품질설계사양구분 */
    /** TS하한값MPA */
    public static final String COL_TS_LLV_MPA = "TS_LLV_MPA";
    /** TS상한값MPA */
    public static final String COL_TS_ULV_MPA = "TS_ULV_MPA";
    /** YP하한값MPA */
    public static final String COL_YP_LLV_MPA = "YP_LLV_MPA";
    /** YP상한값MPA */
    public static final String COL_YP_ULV_MPA = "YP_ULV_MPA";
    /** 연신율하한값 */
    public static final String COL_ELGN_LLV = "ELGN_LLV";
    /** 연신율상한값 */
    public static final String COL_ELGN_ULV = "ELGN_ULV";
    /** HRB하한값 */
    public static final String COL_HRB_LLV = "HRB_LLV";
    /** HRB상한값 */
    public static final String COL_HRB_ULV = "HRB_ULV";
    /** ER하한값 */
    public static final String COL_ER_LLV = "ER_LLV";
    /** ER상한값 */
    public static final String COL_ER_ULV = "ER_ULV";
    /** 재질Bending시험기준코드 */
    public static final String COL_MQL_BND_TST_STD_CD = "MQL_BND_TST_STD_CD";
    /** 시편채취지시위치 */
    public static final String COL_TST_PIC_GTH_INST_LOC = "TST_PIC_GTH_INST_LOC";
    /** 시편채취지시길이 */
    public static final String COL_TST_PIC_GTH_INST_LTH = "TST_PIC_GTH_INST_LTH";
    /** 시편호수 */
    public static final String COL_TPG_RGS_NO = "TPG_RGS_NO";
    /** 시험도금량전면하한값 */
    public static final String COL_TST_GW_FRN_LLV = "TST_GW_FRN_LLV";
    /** 시험도금량전면상한값 */
    public static final String COL_TST_GW_FRN_ULV = "TST_GW_FRN_ULV";
    /** 시험도금량후면하한값 */
    public static final String COL_TST_GW_BAK_LLV = "TST_GW_BAK_LLV";
    /** 시험도금량후면상한값 */
    public static final String COL_TST_GW_BAK_ULV = "TST_GW_BAK_ULV";
    /** 시험도금량전체하한값 */
    public static final String COL_TST_GW_TOT_LLV = "TST_GW_TOT_LLV";
    /** 시험도금량전체상한값 */
    public static final String COL_TST_GW_TOT_ULV = "TST_GW_TOT_ULV";

    /** TB_C10_QLT_DSN_MSG 품질설계 품질메세지 */
    /** 주문번호 */
    /** 주문행번 */
    /** 공정코드 */
    public static final String COL_PROC_CD = "PROC_CD";
    /** 원자재공급업체코드 */
    public static final String COL_RMTL_SLP_CD = "RMTL_SLP_CD";
    /** 품질Message코드 */
    public static final String COL_QLT_MSG_CD = "QLT_MSG_CD";
    /** 품질Message */
    public static final String COL_QLT_MSG_NM = "QLT_MSG_NM";
    /** 품질Message1 */
    public static final String COL_QLT_MSG_NM1 = "QLT_MSG_NM1";
    /** 품질Message2 */
    public static final String COL_QLT_MSG_NM2 = "QLT_MSG_NM2";
    /** 품질Message3 */
    public static final String COL_QLT_MSG_NM3 = "QLT_MSG_NM3";

    /** TB_C10_QLT_DSN_PROC 품질설계 통과공정 */
    /** 주문번호 */
    /** 주문행번 */
    /** 공정순서 */
    public static final String COL_PROC_SEQ = "PROC_SEQ";
    /** 주공정코드 */
    public static final String COL_MAIN_PROC_CD = "MAIN_PROC_CD";
    /** CGL주공정코드 */
    public static final String COL_CGL_MAIN_PROC_CD = "CGL_MAIN_PROC_CD";
    /** EGL주공정코드 */
    public static final String COL_EGL_MAIN_PROC_CD = "EGL_MAIN_PROC_CD";
    /** 대체공정코드1 */
    public static final String COL_SUB_PROC_CD1 = "SUB_PROC_CD1";
    /** 대체공정코드2 */
    public static final String COL_SUB_PROC_CD2 = "SUB_PROC_CD2";
    /** 대체공정코드3 */
    public static final String COL_SUB_PROC_CD3 = "SUB_PROC_CD3";
    /** 대체공정코드4 */
    public static final String COL_SUB_PROC_CD4 = "SUB_PROC_CD4";
    /** 대체공정코드5 */
    public static final String COL_SUB_PROC_CD5 = "SUB_PROC_CD5";
    /** 대체공정코드6 */
    public static final String COL_SUB_PROC_CD6 = "SUB_PROC_CD6";
    /** SMS수신여부 */
    public static final String COL_SMS_RCV_YN = "SMS_RCV_YN";    
    /** MaterialCode */

    /** TB_C10_QLT_DSN_RMT 품질설계 원자재 */
    /** 주문번호 */
    /** 주문행번 */
    /** 원자재코드 */
    /** 원자재등급 */
    /** 원자재목표두께 */
    public static final String COL_RMTL_TAR_THK = "RMTL_TAR_THK";
    /** 원자재목표폭 */
    public static final String COL_RMTL_TAR_WTH = "RMTL_TAR_WTH";
    /** 원자재목표두께하한 */
    public static final String COL_RMTL_TAR_THK_LVL = "RMTL_TAR_THK_LVL";
    /** 원자재목표두께상한 */
    public static final String COL_RMTL_TAR_THK_UVL = "RMTL_TAR_THK_UVL";
    /** 원자재목표폭하한 */
    public static final String COL_RMTL_TAR_WTH_LVL = "RMTL_TAR_WTH_LVL";
    /** 원자재목표폭상한 */
    public static final String COL_RMTL_TAR_WTH_UVL = "RMTL_TAR_WTH_UVL";

    /** CCL-BOM기준 */
    /** 코팅방식 */
    /** 칼라표면처리코드 */
    public static final String COL_COL_SUR_HND_CD = "COL_SUR_HND_CD";
    /** 용제비중전면1Coat */
    public static final String COL_SLV_GRA_PRN_1COT = "SLV_GRA_PRN_1COT";
    /** 용제비중전면2Coat */
    public static final String COL_SLV_GRA_PRN_2COT = "SLV_GRA_PRN_2COT";
    /** 용제비중전면3Coat */
    public static final String COL_SLV_GRA_PRN_3COT = "SLV_GRA_PRN_3COT";
    /** 용제비중전면4Coat */
    public static final String COL_SLV_GRA_PRN_4COT = "SLV_GRA_PRN_4COT";
    /** 용제비중후면1Coat */
    public static final String COL_SLV_GRA_BAK_1COT = "SLV_GRA_BAK_1COT";
    /** 용제비중후면2Coat */
    public static final String COL_SLV_GRA_BAK_2COT = "SLV_GRA_BAK_2COT";
    /** 용제비중후면3Coat */
    public static final String COL_SLV_GRA_BAK_3COT = "SLV_GRA_BAK_3COT";
    /** 용제비중후면4Coat */
    public static final String COL_SLV_GRA_BAK_4COT = "SLV_GRA_BAK_4COT";
    /** 도료비중전면1Coat */
    public static final String COL_PNT_GRA_PRN_1COT = "PNT_GRA_PRN_1COT";
    /** 도료비중전면2Coat */
    public static final String COL_PNT_GRA_PRN_2COT = "PNT_GRA_PRN_2COT";
    /** 도료비중전면3Coat */
    public static final String COL_PNT_GRA_PRN_3COT = "PNT_GRA_PRN_3COT";
    /** 도료비중전면4Coat */
    public static final String COL_PNT_GRA_PRN_4COT = "PNT_GRA_PRN_4COT";
    /** 도료비중후면1Coat */
    public static final String COL_PNT_GRA_BAK_1COT = "PNT_GRA_BAK_1COT";
    /** 도료비중후면2Coat */
    public static final String COL_PNT_GRA_BAK_2COT = "PNT_GRA_BAK_2COT";
    /** 도료비중후면3Coat */
    public static final String COL_PNT_GRA_BAK_3COT = "PNT_GRA_BAK_3COT";
    /** 도료비중후면4Coat */
    public static final String COL_PNT_GRA_BAK_4COT = "PNT_GRA_BAK_4COT";
    /** 도료원단위전면1Coat */
    public static final String COL_PNT_UNT_PRN_1COT = "PNT_UNT_PRN_1COT";
    /** 도료원단위전면2Coat */
    public static final String COL_PNT_UNT_PRN_2COT = "PNT_UNT_PRN_2COT";
    /** 도료원단위전면3Coat */
    public static final String COL_PNT_UNT_PRN_3COT = "PNT_UNT_PRN_3COT";
    /** 도료원단위전면4Coat */
    public static final String COL_PNT_UNT_PRN_4COT = "PNT_UNT_PRN_4COT";
    /** 도료원단위후면1Coat */
    public static final String COL_PNT_UNT_BAK_1COT = "PNT_UNT_BAK_1COT";
    /** 도료원단위후면2Coat */
    public static final String COL_PNT_UNT_BAK_2COT = "PNT_UNT_BAK_2COT";
    /** 도료원단위후면3Coat */
    public static final String COL_PNT_UNT_BAK_3COT = "PNT_UNT_BAK_3COT";
    /** 도료원단위후면4Coat */
    public static final String COL_PNT_UNT_BAK_4COT = "PNT_UNT_BAK_4COT";
    /** 도료원단위Lamina */
    public static final String COL_PNT_UNT_LMN = "PNT_UNT_LMN";
    /** Lamina필름두께코드 */
    public static final String COL_LMN_FLM_THK_CD = "LMN_FLM_THK_CD";
    /** Lamina필름폭코드 */
    public static final String COL_LMN_FLM_WTH_CD = "LMN_FLM_WTH_CD";
    /** PrintPatternCode1도 */
    public static final String COL_PRT_PTN_CD1 = "PRT_PTN_CD1";
    /** PrintPatternCode2도 */
    public static final String COL_PRT_PTN_CD2 = "PRT_PTN_CD2";
    /** PrintPatternCode3도 */
    public static final String COL_PRT_PTN_CD3 = "PRT_PTN_CD3";
    /** PrintPatternCode4도 */
    public static final String COL_PRT_PTN_CD4 = "PRT_PTN_CD4";
    /** Print원단위1도 */
    public static final String COL_PRT_UNT1 = "PRT_UNT1";
    /** Print원단위2도 */
    public static final String COL_PRT_UNT2 = "PRT_UNT2";
    /** Print원단위3도 */
    public static final String COL_PRT_UNT3 = "PRT_UNT3";
    /** Print원단위4도 */
    public static final String COL_PRT_UNT4 = "PRT_UNT4";
    /** Print용도코드 */
    public static final String COL_PRT_USG_CD = "PRT_USG_CD";
    /** 아농코드 */
    public static final String COL_ANON = "ANON";

    /** 칼라물성기준 */

    /** 원자재공급업체코드 */
    public static final String COL_ORN_RMTL_SLP_CD = "ORN_RMTL_SLP_CD";

    /** 기준적용여부(제조가부) */
    public static final String COL_BAS_APL_YN = "BAS_APL_YNP";

    /** TB_C10_C101100010 품질설계 IF송신 테이블 */
    public static final String COL_IF_GRP_ID = "IF_GRP_ID";
    public static final String COL_IF_SD_ID = "IF_SD_ID";

    /** TB_C10_B10R0030 인터페이스 */
    /** 인터페이스 SEQ */
    public static final String COL_SEQ_NO = "SEQ_NO";
    /** PI Sequence Key Value */
    public static final String COL_XSEQ = "XSEQ";
    /** PI Data 유형 */
    public static final String COL_XCRUD = "XCRUD";
    /** PI 처리 상태 */
    public static final String COL_XSTAT = "XSTAT";
    /** PI 에러 메세지 */
    public static final String COL_XMSGS = "XMSGS";
    /** PI 송신시간 */
    public static final String COL_XTIME = "XTIME";
    /** PI 처리 상태 */
    public static final String COL_XSTAT_CALLBACK = "XSTAT_CALLBACK";
    /** 에러여부 */
    public static final String COL_ERR_YN = "ERR_YN";
    /** 압연목표두께 */
    public static final String COL_ROL_TAR_THK = "ROL_TAR_THK";
    /** 주문에러내용 */
    public static final String COL_ORD_ERR_TXT = "ORD_ERR_TXT";
    /** 요청IF_GRP_ID */
    public static final String COL_IF_GRP_ID_REQ = "IF_GRP_ID_REQ";    
    
    /** TB_C10_MTL_SEM_PROD 반제품 Material Code */
    /** Material Code */
    /** 공정코드 */
    /** 반제품 Material Code */
    public static final String COL_SEM_PROD_MTL_CD = "SEM_PROD_MTL_CD";
    /** 수신일시 */
    public static final String COL_MTL_RCP_DH = "MTL_RCP_DH";

    /** 포장재중량 */
    public static final String COL_PAK_UNT_WGT = "PAK_UNT_WGT";

    /** CGL폭감소량 */
    public static final String COL_GAL_WTH_SHR_QTY = "GAL_WTH_SHR_QTY";
    /** EGL폭감소량 */
    public static final String COL_EGL_WTH_SHR_QTY = "EGL_WTH_SHR_QTY";
    /** CCL폭감소량 */
    public static final String COL_CCL_WTH_SHR_QTY = "CCL_WTH_SHR_QTY";
    /** 정전폭감소량 */
    public static final String COL_WTH_SHR_QTY = "WTH_SHR_QTY";
    /** 정전메세지 */
    public static final String COL_QLT_MSG_NM_COR = "QLT_MSG_NM_COR";
    /** Class1 */
    public static final String COL_CLASS1 = "Class1";
    /** Class2 */
    public static final String COL_CLASS2 = "Class2";
    /** Class3 */
    public static final String COL_CLASS3 = "Class3";
    /** Class34 */
    public static final String COL_CLASS34 = "Class34";
    /** Class4 */
    public static final String COL_CLASS4 = "Class4";
    /** Class5 */
    public static final String COL_CLASS5 = "Class5";
    /** Class6 */
    public static final String COL_CLASS6 = "Class6";
    /** 이폭조합폭구분 */
    public static final String COL_ORD_MIX_WTH_TP = "ORD_MIX_WTH_TP";

    /** 폭범위하한 */
    public static final String COL_WTH_RNG_LLV = "WTH_RNG_LLV";
    /** 폭범위상한 */
    public static final String COL_WTH_RNG_ULV = "WTH_RNG_ULV";
    /** 길이범위하한 */
    public static final String COL_LTH_RNG_LLV = "LTH_RNG_LLV";
    /** 길이범위상한 */
    public static final String COL_LTH_RNG_ULV = "LTH_RNG_ULV";

    /** 결과값 */
    public static final String COL_RSL_VAL = "RSL_VAL";
    /** CCL공정코드 */
    public static final String COL_PROC_CD_CCL = "PROC_CD_CCL";
    /** 정전공정코드 */
    public static final String COL_PROC_CD_SHL = "PROC_CD_SHL";

    /** PLTCM두께하한값 */
    public static final String COL_PLTCM_THK_TLN_LLV = "PLTCM_THK_TLN_LLV";
    /** PLTCM두께상한값 */
    public static final String COL_PLTCM_THK_TLN_ULV = "PLTCM_THK_TLN_ULV";
    /** 위치 */
    public static final String COL_LOC = "LOC";
    /** 기준공정코드 */
    public static final String COL_BASE_PROC_CD = "BASE_PROC_CD";
    /** 폭여유치 */
    public static final String COL_MRG_WTH = "MRG_WTH";
    /** PLTCM폭수축량 */
    public static final String COL_TCM_WTH_SHR_QTY = "TCM_WTH_SHR_QTY";

    public static final String COL_PRDN_ACTL_MTRL_CD = "PRDN_ACTL_MTRL_CD";

    public static final String COL_MTRL_CD = "MTRL_CD";

    public static final String COL_MTRL_CD_CMPSTN_PSBLT_FG = "MTRL_CD_CMPSTN_PSBLT_FG";
    /** 제조가부 기준적용여부 */
    public static final String COL_BAS_AP_OBJ_TP = "BAS_AP_OBJ_TP";
    /** 두께보정치 */
    public static final String COL_THK_COR_VAL = "THK_COR_VAL";
    /** 두께보정단위 */
    public static final String COL_THK_COR_UNT = "THK_COR_UNT";
    /** 두께보정율 */
    public static final String COL_THK_CPS_RT = "THK_CPS_RT";

    /** 재설계 구분 */
    public static final String COL_RE_QLT_DSN_TP = "RE_QLT_DSN_TP";

    /** SMS수신자명 */
    public static final String COL_SMS_RCV_EMP_NM = "SMS_RCV_EMP_NM";
    /** SMS수신전화번호 */
    public static final String COL_SMS_RCV_TEL = "SMS_RCV_TEL";
    /** SMS발송자명 */
    public static final String COL_SMS_SND_EMP_NM = "SMS_SND_EMP_NM";
    /** SMS발송전화번호 */
    public static final String COL_SMS_SND_TEL = "SMS_SND_TEL";
    /** SMS발송내역 */
    public static final String COL_SMS_SND_TXT = "SMS_SND_TXT";
    
    /** 중간재품명 */
    public static final String COL_SEM_PRD_NM_CD = "SEM_PRD_NM_CD";
    
    /** 폭보정치 */
    public static final String COL_WTH_COR_VAL = "WTH_COR_VAL";
    /** KISS CUTTING 여부 */
    public static final String COL_KISS_CUT_YN = "KISS_CUT_YN";    
    
    // 단순구조View컬럼
    public static final String COL_MDL_DEFINE_NM = "MDL_DEFINE_NM";
    public static final String COL_MDL_DEFINE_EXPLAIN = "MDL_DEFINE_EXPLAIN";

    // ################################################
    // 마스터데이터 코드
    // ################################################
    /** 단순구조데이타 */
    /** 규격공통 */
    public static final String C10A1010 = "C10A1010";
    /** 고객성분사양 */
    public static final String C10A1021 = "C10A1021";
    /** 고객재질사양 */
    public static final String C10A1022 = "C10A1022";
    /** 고객인수도 */
    public static final String C10A1023 = "C10A1023";
    /** 고객사양공통 */
    public static final String C10A1020 = "C10A1020";
    /** 도금량기준 */
    public static final String C10A1061 = "C10A1061";
    /** 통과공정기준 */
    public static final String C10A1054 = "C10A1054";
    /** CCL BOM관리 */
    public static final String C10A1052 = "C10A1052";

    /** 판단기준데이타 */
    /** 규격성분사양 */
    public static final String C10B1011 = "C10B1011";
    /** 규격재질사양 */
    public static final String C10B1012 = "C10B1012";
    /** 규격인수도 */
    public static final String C10B1013 = "C10B1013";
    /** 설계KEY */
    public static final String C10B1040 = "C10B1040";
    /** 사내성분사양 */
    public static final String C10B1031 = "C10B1031";
    /** 사내재질사양 */
    public static final String C10B1032 = "C10B1032";
    /** 제조표준기준 */
    public static final String C10B1051 = "C10B1051";
    /** 원자재두께 */
    public static final String C10B1071 = "C10B1071";
    /** 원자재폭 */
    public static final String C10B1072 = "C10B1072";
    /** PLTCM마진량 */
    public static final String C10B1073 = "C10B1073";
    /** PLTCM수축량 */
    public static final String C10B1074 = "C10B1074";
    /** CGL폭수축량 */
    public static final String C10B1075 = "C10B1075";
    /** EGL폭수축량 */
    public static final String C10B1076 = "C10B1076";
    /** 정전폭감소량 */
    public static final String C10B1077 = "C10B1077";
    /** CCL폭감소량 */
    public static final String C10B1078 = "C10B1078";
    /** 정전폭 마진량 */
    public static final String C10B1079 = "C10B1079";
    /** 감량매직체크기준 */
    public static final String C10B2280 = "C10B2280";
    /** 지관발주메시지기준 */
    public static final String C10B2290 = "C10B2290";
    /** PE-FOAM 적용메시지기준 */
    public static final String C10B2300 = "C10B2300";
    /** 원자재코드 */
    public static final String C10B1063 = "C10B1063";
    /** 포장재중량-코일 */
    public static final String C10B1081 = "C10B1081";
    /** 포장재중량-쉬트 */
    public static final String C10B1082 = "C10B1082";
    /** 통과공정삭제 */
    public static final String C10B2010 = "C10B2010";
    /** 정전공정추가기준 */
    public static final String C10B2050 = "C10B2050";
    /** 압연두께Set치보정기준 */
    public static final String C10B2060 = "C10B2060";
    /** SP두께보정율기준 */
    public static final String C10B2070 = "C10B2070";
    /** EG조도SET기준 */
    public static final String C10B2080 = "C10B2080";
    /** PLTCM 5Stand W/R Type Set기준 */
    public static final String C10B2110 = "C10B2110";
    /** PLTCM Sleeve유무 Set기준 */
    public static final String C10B2120 = "C10B2120";
    /** CGL 표면처리 유형 Set기준 */
    public static final String C10B2160 = "C10B2160";
    /** 조도설계기준(Ra,PPI,Rmax) */
    public static final String C10B2210 = "C10B2210";
    /** ECL C-D 방지 약품 Set기준 */
    public static final String C10B2130 = "C10B2130";
    /** ECL 권취장력 Set기준 */
    public static final String C10B2140 = "C10B2140";
    /** CGL Leveler Set기준 */
    public static final String C10B2150 = "C10B2150";
    /** 정전공정 방청류 Set기준 */
    public static final String C10B2170 = "C10B2170";

    public static final String C10B2180 = "C10B2180";
    /** PLTCM두께공차 */
    public static final String C10B2190 = "C10B2190";
    /** PLTCM ST폭보정기준 */
    public static final String C10B2191 = "C10B2191";
    /** 주문에러체크 */
    public static final String C10B2220 = "C10B2220";
    public static final String C10B2221 = "C10B2221"; //TEST 이후 삭제 요함  12-07-06
    /** 중간재적용기준 */
    public static final String C10B2230 = "C10B2230";
    /** TM2PASS기준 */
    public static final String C10B2240 = "C10B2240";
    /** 품질설계수동확정대상 */
    public static final String C10B2250 = "C10B2250";
    /** CCL-BOM의 설계확정 제외기준 */
    public static final String C10B2260 = "C10B2260";
    /** 품질설계자동확정대상 */
    public static final String C10B2270 = "C10B2270";
    /** ClassCode1_제품군 */
    public static final String C10B9980 = "C10B9980";
    /** ClassCode2_행선지 */
    public static final String C10B9981 = "C10B9981";
    /** ClassCode34_재질COPOEG */
    public static final String C10B9982 = "C10B9982";
    /** ClassCode3_재질GIGAGL */
    public static final String C10B9983 = "C10B9983";
    /** ClassCode6_표면처리 */
    public static final String C10B9984 = "C10B9984";
    /** 품질설계SMS발송대상 */
    public static final String C10B9990 = "C10B9990";
    /** 품질설계SMS발송기준 */
    public static final String C10B9991 = "C10B9991";
    /** 코일외경계산식 조업마스타기준 참조 */
    public static final String M47C0013 = "M47C0013";   
    

    /** 주문에러체크 메세지 코드 */
    public static final String C102100010 = "C102100010";

    // ################################################
    // 화면출력 메세지코드 _범
    // ################################################

    public static final String MS001001 = "MS001001";
    public static final String MS001002 = "MS001002";
    public static final String MS001003 = "MS001003";
    public static final String MS001004 = "MS001004";
    public static final String MS001005 = "MS001005";
    public static final String MS001006 = "MS001006";
    public static final String MS001007 = "MS001007";
    public static final String MS001008 = "MS001008";
    public static final String MS001009 = "MS001009";
    public static final String MS001010 = "MS001010";
    public static final String MS001011 = "MS001011";
    public static final String MS001012 = "MS001012";
    public static final String MS001013 = "MS001013";
    public static final String MS001014 = "MS001014";
    public static final String MS001015 = "MS001015";
    public static final String MS001016 = "MS001016";
    public static final String MS001017 = "MS001017";
    public static final String MS001018 = "MS001018";
    public static final String MS001019 = "MS001019";
    public static final String MS001020 = "MS001020";
    public static final String MS001021 = "MS001021";
    public static final String MS001022 = "MS001022";
    public static final String MS001023 = "MS001023";
    public static final String MS001024 = "MS001024";
    public static final String MS001025 = "MS001025";
    public static final String MS001026 = "MS001026";
    public static final String MS001027 = "MS001027";
    public static final String MS001028 = "MS001028";
    public static final String MS001029 = "MS001029";
    public static final String MS002001 = "MS002001";
    public static final String MS002002 = "MS002002";
    public static final String MS002003 = "MS002003";
    public static final String MS002004 = "MS002004";
    public static final String MS002005 = "MS002005";
    public static final String MS002006 = "MS002006";
    public static final String MS002007 = "MS002007";
    public static final String MS002008 = "MS002008";
    public static final String MS002009 = "MS002009";
    public static final String MS002010 = "MS002010";
    public static final String MS002011 = "MS002011";
    public static final String MS002012 = "MS002012";
    public static final String MS002013 = "MS002013";
    public static final String MS002014 = "MS002014";
    public static final String MS002015 = "MS002015";
    public static final String MS002016 = "MS002016";
    public static final String MS002017 = "MS002017";
    public static final String MS002018 = "MS002018";
    public static final String MS002019 = "MS002019";
    public static final String MS002020 = "MS002020";
    public static final String MS002021 = "MS002021";
    public static final String MS002022 = "MS002022";
    public static final String MS002023 = "MS002023";
    public static final String MS002024 = "MS002024";
    public static final String MS002025 = "MS002025";
    public static final String MS002026 = "MS002026";
    public static final String MS002027 = "MS002027";
    public static final String MS002028 = "MS002028";
    public static final String MS002029 = "MS002029";
    public static final String MS002030 = "MS002030";
    public static final String MS002031 = "MS002031";
    public static final String MS002032 = "MS002032";
    public static final String MS002033 = "MS002033";
    public static final String MS002034 = "MS002034";
    public static final String MS002035 = "MS002035";
    public static final String MS002036 = "MS002036";
    public static final String MS002037 = "MS002037";
    public static final String MS002038 = "MS002038";
    public static final String MS002039 = "MS002039";
    public static final String MS002040 = "MS002040";
    public static final String MS002041 = "MS002041";
    public static final String MS002042 = "MS002042";
    public static final String MS002043 = "MS002043";
    public static final String MS002044 = "MS002044";
    public static final String MS002045 = "MS002045";
    public static final String MS002046 = "MS002046";
    public static final String MS002047 = "MS002047";
    public static final String MS002048 = "MS002048";
    public static final String MS002049 = "MS002049";
    public static final String MS002050 = "MS002050";
    public static final String MS002051 = "MS002051";
    public static final String MS002052 = "MS002052";
    public static final String MS002053 = "MS002053";
    public static final String MS002054 = "MS002054";
    public static final String MS002055 = "MS002055";
    public static final String MS002056 = "MS002056";
    public static final String MS002057 = "MS002057";
    public static final String MS002058 = "MS002058";
    public static final String MS002059 = "MS002059";
    public static final String MS002060 = "MS002060";
    public static final String MS002061 = "MS002061";
    public static final String MS002062 = "MS002062";

    public static final String MS002063 = "MS002063"; // 주문번호:{0} {1}의 {2}

    // ################################################
    // 파싱정보
    // ################################################
    public static final String PARSEINFO_A92 = "A92 /ORD_REQ_NO/주문요청번호";
    public static final String PARSEINFO_A102 = "A102/ORD_REQ_LN/주문요청행번";
    public static final String PARSEINFO_A162 = "A162/PRD_NM_CD/품명코드";
    public static final String PARSEINFO_A462 = "A462/PRD_SHP/제품형태";
    public static final String PARSEINFO_A172 = "A172/FLOW_CHL/유통경로";
    public static final String PARSEINFO_A112 = "A112/ORD_KND/주문종류";
    public static final String PARSEINFO_A892 = "A892/ORD_USG_CD/주문용도코드";
    public static final String PARSEINFO_A122 = "A122/CUS_CD/고객사코드";
    public static final String PARSEINFO_A212 = "A212/ACT_CUS_CD/수요가코드";
    public static final String PARSEINFO_A222 = "A222/FNL_CUS_CD/최종수요가코드";
    public static final String PARSEINFO_A242 = "A242/CUS_BTH_PAP_NO/고객사양서번호";
    public static final String PARSEINFO_A342 = "A342/SPC_AVR/규격약호";
    public static final String PARSEINFO_A352 = "A352/SPC_YR/규격년도";
    public static final String PARSEINFO_A282 = "A282/ORD_SZ/주문생칫수";
    public static final String PARSEINFO_A252 = "A252/ORD_EXC_THK/주문환산두께";
    public static final String PARSEINFO_A262 = "A262/ORD_EXC_WTH/주문환산폭";
    public static final String PARSEINFO_A622 = "A622/ORD_SUR_HND_CD/주문표면처리코드";
    public static final String PARSEINFO_A472 = "A472/ORD_EDG_ASG_TP/주문Edge지정구분";
    public static final String PARSEINFO_A422 = "A422/WGT_DCS_MTH_TP/중량결정법구분";
    public static final String PARSEINFO_A312 = "A312/ORD_WGT_UNT/주문중량단위";
    public static final String PARSEINFO_A332 = "A332/ORD_LN_WGT/주문행번중량";
    public static final String PARSEINFO_A512 = "A512/ORD_STDP_LLV/주문정포장하한값";
    public static final String PARSEINFO_A522 = "A522/ORD_STDP_ULV/주문정포장상한값";
    public static final String PARSEINFO_A912 = "A912/ORD_PAK_UNT_WGT/주문포장당중량";
    public static final String PARSEINFO_A432 = "A432/ORD_SML_PAK_WGT/주문소포장중량";
    public static final String PARSEINFO_A452 = "A452/ORD_UNT_WGT/주문단위중량";
    public static final String PARSEINFO_A652 = "A652/ORD_PAK_MTH/주문포장방법";
    public static final String PARSEINFO_A532 = "A532/ORD_THK_MNG_CD/주문두께관리코드";
    public static final String PARSEINFO_A562 = "A562/ORD_WTH_MNG_CD/주문폭관리코드";
    public static final String PARSEINFO_A752 = "A752/ORD_COILG_MTH/주문권취방법";
    public static final String PARSEINFO_A272 = "A272/ORD_EXC_LTH/주문환산길이";
    public static final String PARSEINFO_A702 = "A702/ORD_LTH_MNG_CD/주문길이관리코드";
    public static final String PARSEINFO_A792 = "A792/ORD_SHT_LOD_MTH/주문Sheet적재방법";
    public static final String PARSEINFO_A132 = "A132/NAT_CD/국가코드";
    public static final String PARSEINFO_A192 = "A192/ORD_RGS_PRS_ID/주문등록자";
    public static final String PARSEINFO_A182 = "A182/ORD_TEM_CD/영업팀코드";

    public static final String PARSEINFO_A104 = "A104/ORD_REQ_LN/주문요청행번";
    public static final String PARSEINFO_A254 = "A254/ORD_EXC_THK/주문환산두께";
    public static final String PARSEINFO_A264 = "A264/ORD_EXC_WTH/주문환산폭";
    public static final String PARSEINFO_A274 = "A274/ORD_EXC_LTH/주문환산길이";
    public static final String PARSEINFO_A674 = "A674/ORD_PTT_FLM_WTH/주문보호필름폭";
    public static final String PARSEINFO_A334 = "A334/ORD_LN_WGT/주문행번중량";
    public static final String PARSEINFO_A324 = "A324/ORD_SHT_CNT/주문Sheet매수";
    public static final String PARSEINFO_A694 = "A694/ORD_PAK_SHT_CNT/주문포장Sheet매수";
    public static final String PARSEINFO_A384 = "A384/ORD_PAK_UNT_WGT_LLV/주문포장단중하한값";
    public static final String PARSEINFO_A394 = "A394/ORD_PAK_UNT_WGT_ULV/주문포장단중상한값";
    public static final String PARSEINFO_A414 = "A414/ORD_DLV_ALW_DIF_LLV/주문인도허용차하한값";
    public static final String PARSEINFO_A404 = "A404/ORD_DLV_ALW_DIF_ULV/주문인도허용차상한값";
    public static final String PARSEINFO_A494 = "A494/ORD_PAK_LTH_LLV/주문포장길이하한값";
    public static final String PARSEINFO_A504 = "A504/ORD_PAK_LTH_ULV/주문포장길이상한값";
    public static final String PARSEINFO_A514 = "A514/ORD_STDP_LLV/주문정포장하한값";
    public static final String PARSEINFO_A524 = "A524/ORD_STDP_ULV/주문정포장상한값";
    public static final String PARSEINFO_A634 = "A634/ORD_STDP_CNT_LLV/주문정포장매수하한값";
    public static final String PARSEINFO_A644 = "A644/ORD_STDP_CNT_ULV/주문정포장매수상한값";
    public static final String PARSEINFO_A914 = "A914/ORD_PAK_UNT_WGT/주문포장당중량";
    public static final String PARSEINFO_A434 = "A434/ORD_SML_PAK_WGT/주문소포장중량";
    public static final String PARSEINFO_A444 = "A444/ORD_SML_PAK_MIR/주문소포장혼입율";
    public static final String PARSEINFO_A454 = "A454/ORD_UNT_WGT/주문단위중량";
    public static final String PARSEINFO_A774 = "A774/ORD_COIL_IDIA/주문코일내경";
    public static final String PARSEINFO_A775 = "A775/PAK_MSG_CD/포장메세지코드";
    public static final String PARSEINFO_A784 = "A784/ORD_COIL_ODIA/주문코일외경";
    public static final String PARSEINFO_A544 = "A544/ORD_THK_TLN_LLV/주문두께공차하한값";
    public static final String PARSEINFO_A554 = "A554/ORD_THK_TLN_ULV/주문두께공차상한값";
    public static final String PARSEINFO_A574 = "A574/ORD_WTH_TLN_LLV/주문폭공차하한값";
    public static final String PARSEINFO_A584 = "A584/ORD_WTH_TLN_ULV/주문폭공차상한값";
    public static final String PARSEINFO_A594 = "A594/ORD_LTH_TLN_LLV/주문길이공차하한값";
    public static final String PARSEINFO_A604 = "A604/ORD_LTH_TLN_ULV/주문길이공차상한값";
    public static final String PARSEINFO_A804 = "A804/ORD_SLIT_GRP_CNT/주문Slit조수";
    public static final String PARSEINFO_A814 = "A814/ORD_MIX_WTH1/주문조합폭1";
    public static final String PARSEINFO_A824 = "A824/ORD_MIX_WTH2/주문조합폭2";
    public static final String PARSEINFO_A834 = "A834/ORD_MIX_WTH3/주문조합폭3";
    public static final String PARSEINFO_A844 = "A844/ORD_MIX_WTH4/주문조합폭4";
    public static final String PARSEINFO_A854 = "A854/ORD_MIX_WTH5/주문조합폭5";
    public static final String PARSEINFO_A864 = "A864/ORD_MIX_WTH6/주문조합폭6";
    public static final String PARSEINFO_A874 = "A874/ORD_MIX_WTH7/주문조합폭7";
    public static final String PARSEINFO_A884 = "A884/ORD_MIX_WTH8/주문조합폭8";
    public static final String PARSEINFO_A924 = "A924/SLIT_MAX_WGT/조당최대중량";

    public static final String PARSEINFO_A201 = "A201/PLNT_TP/플랜트구분";
    public static final String PARSEINFO_A161 = "A161/PRD_NM_CD/품명코드";
    public static final String PARSEINFO_A461 = "A461/PRD_SHP/제품형태";
    public static final String PARSEINFO_A171 = "A171/FLOW_CHL/유통경로";
    public static final String PARSEINFO_A111 = "A111/ORD_KND/주문종류";
    public static final String PARSEINFO_A891 = "A891/ORD_USG_CD/주문용도코드";
    public static final String PARSEINFO_A121 = "A121/CUS_CD/고객사코드";
    public static final String PARSEINFO_A211 = "A211/ACT_CUS_CD/수요가코드";
    public static final String PARSEINFO_A221 = "A221/FNL_CUS_CD/최종수요가코드";
    public static final String PARSEINFO_A611 = "A611/GW_ASG_CD /도금량지정코드";
    public static final String PARSEINFO_A291 = "A291/HUE_CD_FRN/색상코드전면";
    public static final String PARSEINFO_A301 = "A301/HUE_CD_BAK/색상코드후면";
    public static final String PARSEINFO_A711 = "A711/ORD_ROU_CD/주문조도코드";
    public static final String PARSEINFO_A721 = "A721/ORD_SPNL_TP/주문Spangle구분";
    public static final String PARSEINFO_A751 = "A751/ORD_COILG_MTH/주문권취방법";
    public static final String PARSEINFO_A621 = "A621/ORD_SUR_HND_CD/주문표면처리코드";
    public static final String PARSEINFO_A741 = "A741/ORD_SKP_DEG/주문조질도";
    public static final String PARSEINFO_A471 = "A471/ORD_EDG_ASG_TP/주문Edge지정구분";
    public static final String PARSEINFO_A475 = "A475/RSN_TP_FRN/수지구분전면";
    public static final String PARSEINFO_A481 = "A481/ORD_THK_TP/주문두께구분";
    public static final String PARSEINFO_A421 = "A421/WGT_DCS_MTH_TP/중량결정법구분";
    public static final String PARSEINFO_A761 = "A761/ORD_SLV_KND_TP/주문내경링종류구분";
    public static final String PARSEINFO_A731 = "A731/EMBS_CD/EMBOSS무늬";
    public static final String PARSEINFO_A661 = "A661/ORD_PTT_FLM_DTL_CD/주문보호필름상세코드";
    public static final String PARSEINFO_A681 = "A681/ORD_PTT_FLM_ADH_LOC_CD/주문보호필름부착위치";
    public static final String PARSEINFO_A651 = "A651/ORD_PAK_MTH/주문포장방법";
    public static final String PARSEINFO_A531 = "A531/ORD_THK_MNG_CD/주문두께관리코드";
    public static final String PARSEINFO_A561 = "A561/ORD_WTH_MNG_CD/주문폭관리코드";
    public static final String PARSEINFO_A701 = "A701/ORD_LTH_MNG_CD/주문길이관리코드";
    public static final String PARSEINFO_A791 = "A791/ORD_SHT_LOD_MTH/주문Sheet적재방법";
    public static final String PARSEINFO_A231 = "A231/TRST_PROC_YN/위탁임가공여부";
    public static final String PARSEINFO_A931 = "A931/TAG_TP/Tag유형";
    public static final String PARSEINFO_A131 = "A131/NAT_CD/국가코드";
    public static final String PARSEINFO_A181 = "A181/ORD_TEM_CD/영업팀코드";

    // /동부
    public static final String PARSEINFO_0_2 = "0/2";

    public static final String PARSEINFO_2_3 = "2/3";

    public static final String PARSEINFO_3_4 = "3/4";

    public static final String PARSEINFO_4_5 = "4/5";

    public static final String PARSEINFO_5_7 = "5/7";

    public static final String PARSEINFO_A01 = "A01/INSPT_ORGAN_CD/검사기관코드";

    public static final String PARSEINFO_A06_LOW = "A06/포장단중하한";

    public static final String PARSEINFO_A06_UPR = "A06/포장단중상한";

    public static final String PARSEINFO_A27 = "A27/RCVG_TP/수주구분코드";

    public static final String PARSEINFO_A28 = "A28/RCVG_GRD_TP/수주품종구분";

    public static final String PARSEINFO_A29 = "A29/RCVG_PROD_NM_CD/수주품명코드";

    public static final String PARSEINFO_A31 = "A31/ORD_USE_ASGN_CD/주문용도";

    public static final String PARSEINFO_A30 = "A30/규격약호";

    public static final String PARSEINFO_A32 = "A32/고객사코드";

    public static final String PARSEINFO_A33 = "A33/주문두께";

    public static final String PARSEINFO_A34 = "A34/주문폭";

    public static final String PARSEINFO_A43 = "A43/판매품 Material";

    public static final String PARSEINFO_A44 = "A44/STK_SLS_TP/재고판매구분";

    public static final String PARSEINFO_A45 = "A45/OrderLine량";

    public static final String PARSEINFO_A47 = "A47/최종고객사코드";

    // ################################################
    // 로그정보
    // ################################################
    public static final String LOG_TST = "시험편";
    public static final String LOG_CUS = "(고객)";
    public static final String LOG_STC = "(규격)";
    public static final String LOG_CPN = "(사내)";
    public static final String LOG_MIX = "(합성)";
    public static final String LOG_TPTG = "(출강목표)";
    public static final String LOG_ERR = "failure 처리";

    // ################################################
    // 테이블명_범
    // ################################################
    public static final String TB_C10_QLT_DSN_CMN = "TB_C10_QLT_DSN_CMN"; // 품질설계
									  // 공통
    public static final String TB_C10_QLT_DSN_CHM = "TB_C10_QLT_DSN_CHM"; // 품질설계
									  // 성분
    public static final String TB_C10_QLT_DSN_MQL = "TB_C10_QLT_DSN_MQL"; // 품질설계
									  // 재질
    public static final String TB_C10_QLT_DSN_DLV = "TB_C10_QLT_DSN_DLV"; // 품질설계
									  // 인수도
    public static final String TB_C10_QLT_DSN_ERR = "TB_C10_QLT_DSN_ERR"; // 품질설계
									  // 에러
    public static final String TB_C10_QLT_DSN_MSG = "TB_C10_QLT_DSN_MSG"; // 품질설계
									  // 품질메세지
    public static final String TB_C10_QLT_DSN_CCL_BOM = "TB_C10_QLT_DSN_CCL_BOM"; // 품질설계
										  // CCL-BOM
    public static final String TB_C10_QLT_DSN_RMT = "TB_C10_QLT_DSN_RMT"; // 품질설계
									  // 원자재
    public static final String TB_C10_QLT_DSN_MNF = "TB_C10_QLT_DSN_MNF"; // 품질설계
									  // 제조표준
    public static final String TB_C10_QLT_DSN_PROC = "TB_C10_QLT_DSN_PROC"; // 품질설계
									    // 통과공정

    // 단순구조MD 기준 적용여부관리 기준에서 조건으로 'TB_C10_REQ020'을 주고 읽어 기준적용대상구분이 'Y'체크
    public static final String TBN_C10_REQ020 = "TB_C10_REQ020";

    // ################################################
    // 쿼리 ID
    // ################################################

    public static final String C103100140_SELECT_QUERY = "C103100140.select"; // ERR_SEARCH_CHK
    public static final String VI_M00_C10A1010 = "C10A1010"; // 규격공통view
    public static final String VI_M00_C10A1020 = "C10A1020"; // 고객사양공통view
    public static final String VI_M00_C10A1021 = "C10A1021"; // 고객성분view
    public static final String VI_M00_C10A1022 = "C10A1022"; // 고객재질view
    public static final String VI_M00_C10A1023 = "C10A1023"; // 고객인수도view
    public static final String VI_M00_C10A1061 = "C10A1061"; // 도금량view
    public static final String VI_M00_C10A1070 = "C10A1070"; // 제품폭여유치view
//    public static final String VI_M00_C10A1079 = "C10A1079"; // 정전폭마진view
    public static final String VI_M00_C10A2181 = "C10A2181"; // 폭공차view
    public static final String VI_M00_C10A2182 = "C10A2182"; // 길이공차view
    public static final String VI_M00_C10A1054 = "C10A1054"; // 통과공정기준view
    public static final String VI_M00_C10A1054N = "C10A1054N"; // 통과공정기준2view
    public static final String VI_M00_C10A2030 = "C10A2030"; // 칼라정전라인 결정기준view
    public static final String VI_M00_C10A1054_PROC_CHK = "C10A1054_PROC_CHK"; // 통과공정기준view
    public static final String SELECT_CMN = "C102100CMN.select";
    public static final String SELECT_CHM = "C102100CHM.select"; // 품질설계결과성분조회
    public static final String SELECT_MQL = "C102100MQL.select"; // 품질설계결과재질조회
    public static final String SELECT_DLV = "C102100DLV.select"; // 품질설계결과인수도조회
    public static final String SELECT_MNF = "C102100MNF.select"; // 품질설계결과제조사양조회
    public static final String INSERT_MNF = "C102100MNF.insert"; // 품질설계결과제조사양저장
    public static final String INSERT_PROC = "C102100PROC.Insert"; // 품질설계결과통과공정저장(대체공정3개-생산가부,품질설계의뢰시사용)
    public static final String INSERT_PROC2 = "C102100PROC.Insert2"; // 품질설계결과통과공정저장(대체공정6개-대체공정 추가시 사용)
    public static final String INSERT_PROC_HST = "C104000020TAB08pop02.insertHistory"; // 품질설계결과통과공정내역 저장 
    public static final String DELETE_PROC = "C102100000.PROC_DELETE"; // 품질설계결과통과공정삭제
    public static final String SELECT_PROC = "C102100PROC.select"; // 품질설계결과통과공정조회
    public static final String UPDATE_TMPASS = "C102100PROC.MNFupdate"; // TM통과횟수 수정
    public static final String SELECT_RMT = "C102100RMTL.select"; // 품질설계결과원자재조회
    public static final String INSERT_RMT = "C102100RMTL.insert"; // 품질설계결과원자재코드저장
    public static final String INSERT_MSG = "C102100MSG.Insert"; // 품질설계결과메세지저장
    public static final String INSERT_MSG_COR = "C102100MSG.InsertCOR"; // 품질설계결과정전메세지저장
    public static final String INSERT_SMS = "TB_M90.SMSinsert"; // SMS발송저장
    public static final String INSERT_HST = "C104000020TAB08.CHG_HSTinsert"; // 
    public static final String SELECT_SEM_MTL1 = "C102100PROC.SemMtlselect1"; // 반제품
									      // Material
									      // Code
									      // 조회
    public static final String SELECT_SEM_MTL2 = "C102100PROC.SemMtlselect2"; // 반제품
									      // Material
									      // Code
									      // 조회
    public static final String SELECT_SEM_MTL3 = "C102100PROC.SemMtlselect3"; // 반제품
									      // Material
									      // Code
									      // 조회
    public static final String SELECT_CCL_BOM = "C102100CCL_BOM.select"; // CCL-BOM기준
									 // 조회
    public static final String C102100CCL_BOM_CLR_USE_N = "C102100CCL_BOM.CLR_USE_N_select"; // CCL-BOM에 대한 칼라코드 사용불가 개수 Select
                                	 // 조회
    public static final String SELECT_MNF_CCL_BOM = "C102100CCL_BOM.Aselect"; // 칼라제조사양
									      // 조회
	public static final String SELECT_CCL_PROC = "C102100PROC.Aselect"; // 칼라통과공정
									      // 조회
    public static final String SELECT_CLR_MPR = "C102100CLR_MPR.select"; // 칼라물성기준
									 // 조회
	public static final String SELECT_REP_CCL_SEL = "C102100CLR_MPR.Rselect"; // 반복주문보호필름조회
									 // 조회								 
    public static final String INSERT_ERR = "C103100040.insert"; // 에러코드등록
    public static final String SELECT_ERR = "C103100140.select"; // 에러코드조회
    public static final String UPDATE_STS_OMS = "C102100CMN.Oms_modify"; // 품질설계상태(oms)
    public static final String UPDATE_STS = "C102100CMN.StsME_modify"; // 품질설계상태
    public static final String UPDATE_MQL = "C102100MQL.cs_update"; // 보증사양최종수정
    public static final String INSERT_ATT_ORD_SMS = "C102100CMN.AttSms"; // 관심주문SMS등록
								       // 수정
								       // 에러여부
    public static final String UPDATE_STS_ATU = "C102100CMN.StsA_modify"; // 품질설계상태
									  // 수정
									  // 확정
    public static final String GW_ASG_CD_SELECT = "C102100010.GW_ASG_CD_SELECT"; // 품목별
										 // 도금량지금코드
										 // 주문에러체크
    public static final String ORD_PAK_MTH_SELECT = "C102100010.ORD_PAK_MTH_SELECT"; // 제품형태별
										     // 주문포장방법
										     // 주문에러체크
    public static final String ORD_SPNL_TP_SELECT = "C102100010.ORD_SPNL_TP_SELECT"; // 품목별
										     // 주문Spangle구분
										     // 주문에러체크
    public static final String ACT_CUS_CD_SELECT = "C102100010.ACT_CUS_CD_SELECT"; // 수요가코드
										   // 주문에러체크
    public static final String FNL_CUS_CD_SELECT = "C102100010.FNL_CUS_CD_SELECT"; // 최종수요가코드
										   // 주문에러체크
    public static final String GAL_PTT_FLM_SELECT = "C102100010.GAL_PTT_FLM_SELECT"; // 도금제품
										     // 보호필름상세코드
										     // 조회
    public static final String CLR_MPR_SELECT = "C102100010_CLR_MPR.SELECT"; // 주문에러
									     // 칼라물성기준
									     // 조회
    public static final String COILID_SELECT_QUERY = "C106000020.coilIdSelect"; // 칼라시뮬레이션 IMPORT CHK
    
    // public static final String N2000_DELETE_QUERY = "n2000.delete";
    public static final String N2002_SELECT_QUERY = "n2002.select";
    public static final String N4001_SELECT_QUERY1 = "n4001.select1";
    public static final String N4001_SELECT_QUERY2 = "n4001.select2";
    public static final String N4001_SELECT_QUERY3 = "n4001.select3";
    public static final String N4001_SELECT_QUERY4 = "n4001.select4";
    public static final String N4001_SELECT_QUERY5 = "n4001.select5";
    public static final String N4001_SELECT_QUERY6 = "n4001.select6";
    public static final String N4001_SELECT_QUERY7 = "n4001.select7";
    public static final String N4001_SELECT_QUERY8 = "n4001.select8";
    public static final String U5001_SELECT_QUERY3 = "u5001.select3";
    public static final String U5001_SELECT_QUERY4 = "u5001.select4";
    public static final String U5001_SELECT_QUERY5 = "u5001.select5";
    public static final String U5001_SELECT_QUERY6 = "u5001.select6";
    public static final String U5001_INSERT_QUERY1 = "u5001.insert";
    public static final String R4010_SELECT_QUERY = "r4010.select";
    public static final String U5003_SELECT_QUERY3 = "u5003.select3";
    public static final String U6004_SELECT_QUERY = "u6004.select3";
    public static final String U6004_DELETE_QUERY = "u6004.delete";
    public static final String U1006_SELECT_QUERY = "u1006.select";
    public static final String ERROR_SELETE_QUERY = "error.select";
    public static final String TB_C10_MRTL010_SELECT_QUERY = "TB_C10_MRTL010.select";
    public static final String VI_M00_C10A1315_SELECT_QUERY = "VI_M00_C10A1315.select";
    public static final String TB_C10_MRTL_REQ_INSERT_QUERY = "TB_C10_MRTL_REQ.insert";
    public static final String ERR_INSERT_QUERY = "C103100040.insert";
    public static final String REQ_CHECK_SELECT = "reqCheck.select";

    // ################################################
    // 쿼리조건
    // ################################################

    public final static String[] REQ020_CONDITION = { "RCVG_GRD_TP",
	    "RCVG_PROD_NM_CD", "SPEC_CD", "CUST_SPEC_NO", "ORD_USE_ASGN_CD",
	    "CUST_CD", "ORD_THK", "ORD_WDT" };

    // ################################################
    // 쿼리조건
    // ################################################

    public final static String DAO_MES = "mesdao";// DAO_M100 = "m100dao";

    /** EXCEPTION CODE M00010990 */
    public final String EXCEPTION_M00010990 = "M00010990";

    public final String TIMEFORMAT = "yyyyMMddHHmmss";

    public final String LOOP_CNT = "loop-cnt";

    public final String LOOP_END = "endLoop";

    public final String BIND_KEY = "bind-key";

    public final String RESULTKEY = "resultkey";

    public static final String SUCCESS = "success";

    public static final String KEY_COUNT = "keyCount";

    public static final String COLUMN_INFO = "column-info";
    
    public static final String ARGS = "args";
    
    public static final String DELIMITER = "/";
    
    public static final String SERVICE_NAME = "ServiceName";
    
    public static final String DASH = "-";
    
    public static final String EQUAL = "=";
}
