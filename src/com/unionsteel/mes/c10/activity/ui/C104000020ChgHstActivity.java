/*
 * ==============================================================================
 * Copyright(c) 2026 UNIONSTEEL
 * @FileName : C104000020ChgHstActivity.java
 * Change history
 * @LastModifyDate : 2026. 05. 08
 * @LastModifier : SJS
 * @LastVersion : 1.0
 * 1.0 2026. 05. 08 SJS 최초 생성
 * ==============================================================================
 */

package com.unionsteel.mes.c10.activity.ui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;

/**
 * C104000020ChgHstActivity 는 그리드/폼 저장 직전에 실행되어
 * 변경 대상 행의 OLD 값을 SELECT하고, 사용자가 제출한 NEW 값과 컬럼별 비교 후
 * 차이가 있는 컬럼만 TB_C10_QLT_DSN_CHG_HST 테이블에 적재하는 공통 액티비티이다.
 *
 * <xmp>
 * 사용 방법
 * &lt;activity name="이력기록(인수도)" class="com.unionsteel.mes.c10.activity.ui.C104000020ChgHstActivity"&gt;
 *   &lt;transition name="success" value="인수도 저장" /&gt;
 *   &lt;transition name="failure" value="end" /&gt;
 *   &lt;property name="dao"          value="mesdao" /&gt;
 *   &lt;property name="screenId"     value="C104000020" /&gt;
 *   &lt;property name="tabId"        value="TAB04" /&gt;
 *   &lt;property name="targetTable"  value="TB_C10_QLT_DSN_DLV" /&gt;
 *   &lt;property name="pkColumns"    value="ORD_NO,ORD_LN" /&gt;
 *   &lt;property name="trackColumns" value="THK_TLN_LLV,THK_TLN_ULV,..." /&gt;
 *   &lt;property name="whereExtra"   value="QLT_DSN_SPC_TP='4'" /&gt; (선택)
 * &lt;/activity&gt;
 *
 * Property 설정
 *   dao          : applicationContext.xml의 DAO id (default: mesdao)
 *   screenId     : 화면 ID (CHG_TXT 앞부분, 예: C104000020)
 *   tabId        : 탭 ID (CHG_TXT 뒷부분, 예: TAB04). screenId+tabId 로 CHG_TXT 결정dj
 *   targetTable  : 변경 대상 테이블명 (스키마 생략 가능)
 *   pkColumns    : 변경 대상 PK 컬럼 (콤마 구분, OLD select WHERE 절 + 식별정보)
 *   trackColumns : 추적 컬럼 (콤마 구분, OLD select 와 NEW 비교 대상)
 *   whereExtra   : (선택) PK 외 추가 WHERE 조건. 예: "QLT_DSN_SPC_TP='4'"
 *
 * 동작
 *   1. ctx 의 ids 에서 변경 row id 목록 획득
 *   2. row id 별로 DML 상태 확인 (UPDATE 만 처리, INSERT/DELETE 는 향후 확장)
 *   3. PK 값으로 OLD select 실행
 *   4. trackColumns 각각에 대해 OLD vs NEW 비교, 차이 시 TB_C10_QLT_DSN_CHG_HST 적재
 * </xmp>
 *
 * @author 서재섭
 * @see PosActivity
 * @version 1.0
 */
public class C104000020ChgHstActivity extends PosActivity
{
    private static final String CHG_HST_INSERT_SQLKEY = "C104000020CHG_HST.insert";
    private static final String CHG_HST_MAX_SEQ_SQLKEY = "C104000020CHG_HST.maxSeq";

    public String runActivity( PosContext ctx )
    {
        try
        {
            String daoId = getProperty( "dao" );
            if ( daoId == null || daoId.length() == 0 )
                daoId = C10ConstantsIF.MESDAO;
            PosGenericDao dao = this.getDao( daoId );

            String screenId    = getPropertyOrEmpty( "screenId" );
            String tabId       = getPropertyOrEmpty( "tabId" );
            String chgTxt      = screenId + tabId;
            String targetTable = getPropertyOrEmpty( "targetTable" );
            String pkColumnsCsv    = getPropertyOrEmpty( "pkColumns" );
            String trackColumnsCsv = getPropertyOrEmpty( "trackColumns" );
            String ynColumnsCsv    = getPropertyOrEmpty( "ynColumns" );
            String comboColumnsCsv = getPropertyOrEmpty( "comboColumns" );
            String whereExtra      = getPropertyOrEmpty( "whereExtra" );
            boolean isFormMode     = "true".equalsIgnoreCase( getPropertyOrEmpty( "formMode" ) );

            if ( targetTable.length() == 0 || pkColumnsCsv.length() == 0 || trackColumnsCsv.length() == 0 )
            {
                logger.logError( "C104000020ChgHstActivity: targetTable/pkColumns/trackColumns property required" );
                return PosBizControlConstants.FAILURE;
            }

            String[] pkColumns    = pkColumnsCsv.split( "," );
            String[] trackColumns = trackColumnsCsv.split( "," );
            trim( pkColumns );
            trim( trackColumns );
            java.util.Set ynColumnSet = new java.util.HashSet();
            if ( ynColumnsCsv.length() > 0 )
            {
                String[] ynArr = ynColumnsCsv.split( "," );
                for ( int i = 0; i < ynArr.length; i++ )
                    ynColumnSet.add( ynArr[i].trim() );
            }
            java.util.Set comboColumnSet = new java.util.HashSet();
            if ( comboColumnsCsv.length() > 0 )
            {
                String[] cbArr = comboColumnsCsv.split( "," );
                for ( int i = 0; i < cbArr.length; i++ )
                    comboColumnSet.add( cbArr[i].trim() );
            }

            String[] idsValue;
            if ( isFormMode )
            {
                idsValue = new String[] { "FORM" };
            }
            else
            {
                String[] ids = (String[]) ctx.get( C10ConstantsIF.IDS );
                if ( ids == null || ids.length < 1 )
                    return PosBizControlConstants.SUCCESS;
                idsValue = ids[0].split( C10ConstantsIF.COMMA );
            }

            String oldSelectSql = buildOldSelectSql( targetTable, pkColumns, trackColumns, whereExtra );
            logger.logInfo( "[ChgHst] START screenId=" + screenId + ", tabId=" + tabId
                          + ", target=" + targetTable + ", rowCnt=" + idsValue.length );
            logger.logInfo( "[ChgHst] OLD select sql: " + oldSelectSql );

            logger.logInfo( "[ChgHst] ids=" + java.util.Arrays.asList( idsValue ) );

            for ( int i = 0; i < idsValue.length; i++ )
            {
                String rowId = idsValue[i];
                String dml = getDmlType( ctx, rowId );
                String[] statusArr = (String[]) ctx.get( rowId + "_!nativeeditor_status" );
                logger.logInfo( "[ChgHst] rowId=" + rowId + ", status="
                              + ( statusArr == null ? "null" : java.util.Arrays.asList( statusArr ).toString() )
                              + ", dml=" + dml );
                if ( !"UPDATE".equals( dml ) )
                    continue;

                Map newValues = readRowValues( ctx, rowId, trackColumns );
                Map pkValues  = readRowValues( ctx, rowId, pkColumns );
                logger.logInfo( "[ChgHst] rowId=" + rowId + ", NEW=" + newValues );

                if ( hasNullPk( pkColumns, pkValues ) )
                {
                    logger.logError( "[ChgHst] PK 값 누락. rowId=" + rowId + ", pk=" + pkValues );
                    continue;
                }

                PosParameter pkParam = new PosParameter();
                for ( int p = 0; p < pkColumns.length; p++ )
                    pkParam.setNamedParamter( pkColumns[p], (String) pkValues.get( pkColumns[p] ) );

                logger.logInfo( "[ChgHst] OLD select rowId=" + rowId + ", pk=" + pkValues );
                PosRowSet oldRs = dao.findByQueryStatement( oldSelectSql, pkParam, true );
                if ( oldRs.count() < 1 )
                {
                    logger.logInfo( "[ChgHst] OLD 행 없음. 신규 INSERT 가능성. rowId=" + rowId + ", pk=" + pkValues );
                    continue;
                }
                PosRow oldRow = oldRs.next();

                String ordNo = (String) pkValues.get( "ORD_NO" );
                String ordLn = (String) pkValues.get( "ORD_LN" );
                if ( ordNo == null || ordLn == null )
                {
                    logger.logError( "[ChgHst] ORD_NO/ORD_LN 누락. PK 컬럼에 포함되어야 함. rowId=" + rowId );
                    continue;
                }

                int seq = nextSeqBase( dao, ordNo, ordLn );
                String pkInfo = buildPkInfo( pkColumns, pkValues );

                int diffCount = 0;
                for ( int c = 0; c < trackColumns.length; c++ )
                {
                    String colNm = trackColumns[c];
                    String oldVal = nullSafe( oldRow.getAttribute( colNm ) );
                    String newVal = nullSafe( newValues.get( colNm ) );

                    if ( ynColumnSet.contains( colNm ) )
                    {
                        oldVal = normalizeYn( oldVal );
                        newVal = normalizeYn( newVal );
                    }
                    if ( comboColumnSet.contains( colNm ) )
                    {
                        newVal = normalizeCombo( newVal );
                    }

                    if ( isEqual( oldVal, newVal ) )
                        continue;

                    seq = seq + 1;
                    int insCnt = insertHstRow( dao, ctx, ordNo, ordLn, seq, chgTxt, targetTable,
                                               pkInfo, "UPDATE", colNm, oldVal, newVal );
                    logger.logInfo( "[ChgHst] INSERT col=" + colNm + ", seq=" + seq
                                  + ", old=[" + oldVal + "], new=[" + newVal + "], affected=" + insCnt );
                    diffCount++;
                }
                logger.logInfo( "[ChgHst] rowId=" + rowId + ", 변경컬럼수=" + diffCount );
            }

            return PosBizControlConstants.SUCCESS;
        }
        catch ( Exception e )
        {
            logger.logError( "[ChgHst] error: " + e.getClass().getName() + " - " + e.getMessage() );
            e.printStackTrace();
            ctx.put( C10ConstantsIF.ERRMSG, e.getMessage() );
            return PosBizControlConstants.FAILURE;
        }
    }

    private String getPropertyOrEmpty( String name )
    {
        String v = getProperty( name );
        return v == null ? "" : v.trim();
    }

    private void trim( String[] arr )
    {
        for ( int i = 0; i < arr.length; i++ )
            arr[i] = arr[i].trim();
    }

    private String getDmlType( PosContext ctx, String rowId )
    {
        String[] status = (String[]) ctx.get( rowId + "_!nativeeditor_status" );
        if ( status == null || status.length == 0 )
            return "UPDATE";
        String s = status[0];
        if ( "inserted".equals( s ) )
            return "INSERT";
        if ( "deleted".equals( s ) || "senddeleted".equals( s ) )
            return "DELETE";
        return "UPDATE";
    }

    private Map readRowValues( PosContext ctx, String rowId, String[] columns )
    {
        Map result = new HashMap();
        for ( int i = 0; i < columns.length; i++ )
        {
            String col = columns[i];
            Object v = ctx.get( rowId + C10ConstantsIF.UNDERBAR + col );
            if ( v == null )
                v = ctx.get( col );
            String value = null;
            if ( v instanceof String[] )
            {
                String[] arr = (String[]) v;
                if ( arr.length > 0 ) value = arr[0];
            }
            else if ( v != null )
            {
                value = v.toString();
            }
            result.put( col, value );
        }
        return result;
    }

    private boolean hasNullPk( String[] pkColumns, Map pkValues )
    {
        for ( int i = 0; i < pkColumns.length; i++ )
        {
            Object v = pkValues.get( pkColumns[i] );
            if ( v == null || v.toString().length() == 0 )
                return true;
        }
        return false;
    }

    private String buildOldSelectSql( String targetTable, String[] pkColumns, String[] trackColumns, String whereExtra )
    {
        StringBuffer sb = new StringBuffer();
        sb.append( "SELECT /*+ C10 변경이력 OLD select */ " );
        for ( int i = 0; i < trackColumns.length; i++ )
        {
            if ( i > 0 ) sb.append( ", " );
            sb.append( trackColumns[i] );
        }
        sb.append( " FROM " ).append( targetTable );
        sb.append( " WHERE " );
        for ( int i = 0; i < pkColumns.length; i++ )
        {
            if ( i > 0 ) sb.append( " AND " );
            sb.append( pkColumns[i] ).append( " = :" ).append( pkColumns[i] );
        }
        if ( whereExtra != null && whereExtra.length() > 0 )
            sb.append( " AND " ).append( whereExtra );
        return sb.toString();
    }

    private String buildPkInfo( String[] pkColumns, Map pkValues )
    {
        List parts = new ArrayList();
        for ( int i = 0; i < pkColumns.length; i++ )
        {
            String col = pkColumns[i];
            if ( "ORD_NO".equals( col ) || "ORD_LN".equals( col ) )
                continue;
            Object v = pkValues.get( col );
            parts.add( col + "=" + ( v == null ? "" : v.toString() ) );
        }
        StringBuffer sb = new StringBuffer();
        Iterator it = parts.iterator();
        while ( it.hasNext() )
        {
            if ( sb.length() > 0 ) sb.append( "," );
            sb.append( (String) it.next() );
        }
        return sb.toString();
    }

    private int nextSeqBase( PosGenericDao dao, String ordNo, String ordLn )
    {
        PosParameter param = new PosParameter();
        param.setNamedParamter( "ORD_NO", ordNo );
        param.setNamedParamter( "ORD_LN", ordLn );
        PosRowSet rs = dao.find( CHG_HST_MAX_SEQ_SQLKEY, param );
        if ( rs.count() < 1 )
            return 0;
        Object v = rs.next().getAttribute( "MAX_SEQ" );
        if ( v == null )
            return 0;
        if ( v instanceof Number )
            return ( (Number) v ).intValue();
        try
        {
            return Integer.parseInt( v.toString() );
        }
        catch ( NumberFormatException e )
        {
            return 0;
        }
    }

    private int insertHstRow( PosGenericDao dao, PosContext ctx,
                              String ordNo, String ordLn, int seq, String chgTxt,
                              String targetTable, String pkInfo, String dmlType,
                              String colNm, String oldVal, String newVal )
    {
        PosParameter param = new PosParameter();
        param.setNamedParamter( "ORD_NO", ordNo );
        param.setNamedParamter( "ORD_LN", ordLn );
        param.setNamedParamter( "SEQ", String.valueOf( seq ) );
        param.setNamedParamter( "CHG_TXT", chgTxt );
        param.setNamedParamter( "TARGET_TABLE_NM", targetTable );
        param.setNamedParamter( "TARGET_PK_INFO", pkInfo );
        param.setNamedParamter( "DML_TYPE", dmlType );
        param.setNamedParamter( "COLUMN_NM", colNm );
        param.setNamedParamter( "OLD_VAL", oldVal );
        param.setNamedParamter( "NEW_VAL", newVal );
        param.setNamedParamter( C10ConstantsIF.OBJECT_TYPE, (String) ctx.get( C10ConstantsIF.OBJECT_TYPE ) );
        param.setNamedParamter( C10ConstantsIF.OBJECT_ID,   (String) ctx.get( C10ConstantsIF.OBJECT_ID ) );
        param.setNamedParamter( C10ConstantsIF.PROGRAM_ID,  (String) ctx.get( C10ConstantsIF.PROGRAM_ID ) );
        param.setNamedParamter( C10ConstantsIF.TIMESTAMP,   ctx.get( C10ConstantsIF.TIMESTAMP ) );
        return dao.insert( CHG_HST_INSERT_SQLKEY, param );
    }

    private String nullSafe( Object v )
    {
        if ( v == null ) return "";
        String s = v.toString();
        return s == null ? "" : s;
    }

    private String normalizeCombo( String v )
    {
        if ( v == null ) return null;
        int idx = v.indexOf( " - " );
        if ( idx > 0 ) return v.substring( 0, idx ).trim();
        idx = v.indexOf( " | " );
        if ( idx > 0 ) return v.substring( 0, idx ).trim();
        return v;
    }

    private String normalizeYn( String v )
    {
        if ( v == null ) return "N";
        String s = v.trim();
        if ( s.length() == 0 ) return "N";
        if ( "1".equals( s ) || "Y".equalsIgnoreCase( s ) ) return "Y";
        if ( "0".equals( s ) || "N".equalsIgnoreCase( s ) ) return "N";
        return s;
    }

    private boolean isEqual( String a, String b )
    {
        String x = a == null ? "" : a.trim();
        String y = b == null ? "" : b.trim();
        if ( x.equals( y ) ) return true;
        if ( x.length() == 0 && y.length() == 0 ) return true;
        try
        {
            double dx = x.length() == 0 ? 0.0 : Double.parseDouble( x.replace( ",", "" ) );
            double dy = y.length() == 0 ? 0.0 : Double.parseDouble( y.replace( ",", "" ) );
            return dx == dy;
        }
        catch ( NumberFormatException e )
        {
            return false;
        }
    }
}
