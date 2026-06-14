/**
 * =========================================================================
 *
 * @fileName : C10UiC106000050AutoGenFmActivity.java
 *           설명
 *           - C106000050(칼라코드관리) 저장 시 부재료구분 S40(생산Lamina) /
 *             S49(생산UGS필름) 신규(inserted) row 가 있으면, 각 row 당
 *             부재료구분 ZZ1, 컬러코드 FMxxx 6건(1도~6도)을 자동 채번해서
 *             TB_C10_CLR_CD_MNG 에 INSERT 한다.
 *
 *           채번 규칙 (FM + 3자리, I/O 제외 24자 알파벳)
 *             1단계 FMnnn       FM001 ~ FM999
 *             2단계 FM + 알파+숫자2  FMA01 ~ FMZ99
 *             3단계 FM + 알파2+숫자1 FMAA1 ~ FMZZ9
 *             4단계 FM + 알파3       FMAAA ~ FMZZZ
 *
 *           동시성: TB_C10_CLR_CD_SEQ 의 (CD_TP='FM') row 를
 *           SELECT ... FOR UPDATE 로 잠금 → 채번 → INSERT → UPDATE → commit.
 *
 *           service.xml 의 customInsert success 전이에 끼워 호출됨.
 * ===========================================================================
 */
package com.unionsteel.mes.c10.activity.ui;

import java.util.ArrayList;
import java.util.List;

import com.poscoict.glue.biz.dhtmlx.DhtmlxActivity;
import com.posdata.glue.PosException;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosAuditAttributes;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.C10ConstantsIF;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;

public class C10UiC106000050AutoGenFmActivity extends DhtmlxActivity
{
    // 채번에 사용할 알파벳 (혼동 방지를 위해 I, O 제외 = 24자)
    private static final String ALPHA = "ABCDEFGHJKLMNPQRSTUVWXYZ";

    private static final String FM_PREFIX = "FM";
    private static final String CD_TP_FM  = "FM";
    private static final String SUB_MTL_TP_AUTO = "ZZ1";

    private static final String STATUS_INSERTED = "inserted";

    @Override
    public String doMainActivity( PosContext ctx )
    {
        PosGenericDao dao = this.getDao( C10ConstantsIF.MESDAO );
        PosAuditAttributes audit = ctx.getAuditAttribute();

        try
        {
            // 1) ctx 에서 신규 inserted S40/S49 row 의 CLR_SUB_MTL_CD 수집
            List parentCodes = collectTriggerCodes( ctx );
            if ( parentCodes.isEmpty() )
            {
                logger.logDebug( "[FM자동생성] S40/S49 신규 inserted row 없음. skip" );
                return PosBizControlConstants.SUCCESS;
            }

            int totalNewCount = parentCodes.size() * 6;
            logger.logInfo( "[FM자동생성] 트리거 row 수=" + parentCodes.size()
                          + ", 생성 예정 FM 코드 수=" + totalNewCount );

            // 2) 채번 row 행잠금 (TB_C10_CLR_CD_SEQ FOR UPDATE)
            String lastNo = lockAndReadLastNo( dao );
            String startLast = lastNo;

            // 3) 신규 FM 코드 1세트(6건) × N 발급 후 INSERT
            String currentLast = lastNo;
            for ( int i = 0; i < parentCodes.size(); i++ )
            {
                String parentCd = (String) parentCodes.get( i );
                for ( int j = 1; j <= 6; j++ )
                {
                    currentLast = nextCode( currentLast );
                    String clrNm  = parentCd + " " + j + "도";
                    insertAutoRow( dao, audit, currentLast, clrNm, parentCd );
                    insertModLog( dao, audit, currentLast, parentCd, j );
                    logger.logDebug( "[FM자동생성] INSERT " + currentLast
                                   + " (CLR_NM=" + clrNm + ", parent=" + parentCd + ")" );
                }
            }

            // 4) LAST_NO 갱신
            updateLastNo( dao, audit, currentLast );

            logger.logInfo( "[FM자동생성] 완료. LAST_NO " + startLast + " -> " + currentLast );
            return PosBizControlConstants.SUCCESS;
        }
        catch ( PosException pe )
        {
            logger.logError( "[FM자동생성] PosException: " + pe.getMessage() );
            ctx.put( C10ConstantsIF.ERRMSG, pe.getMessage() );
            throw pe;
        }
        catch ( Exception e )
        {
            logger.logError( "[FM자동생성] error: " + e.getClass().getName() + " - " + e.getMessage() );
            e.printStackTrace();
            ctx.put( C10ConstantsIF.ERRMSG, e.getMessage() );
            throw new PosException( "FM 자동 채번 중 오류: " + e.getMessage() );
        }
    }

    /**
     * ctx 에서 신규 inserted S40/S49 row 의 CLR_SUB_MTL_CD 를 모은다.
     */
    private List collectTriggerCodes( PosContext ctx )
    {
        List result = new ArrayList();
        String[] ids = (String[]) ctx.get( C10ConstantsIF.IDS );
        if ( ids == null || ids.length < 1 )
            return result;

        String[] idsValue = ids[0].split( C10ConstantsIF.COMMA );
        for ( int i = 0; i < idsValue.length; i++ )
        {
            String rowId = idsValue[i];
            String[] statusArr  = (String[]) ctx.get( rowId + C10ConstantsIF.UNDERBAR + "!nativeeditor_status" );
            String[] subMtlArr  = (String[]) ctx.get( rowId + C10ConstantsIF.UNDERBAR + "SUB_MTL_TP" );
            String[] clrCdArr   = (String[]) ctx.get( rowId + C10ConstantsIF.UNDERBAR + "CLR_SUB_MTL_CD" );

            String status = firstOrNull( statusArr );
            if ( !STATUS_INSERTED.equals( status ) )
                continue;

            String subMtlTp = firstOrNull( subMtlArr );
            if ( !"S40".equals( subMtlTp ) && !"S49".equals( subMtlTp ) )
                continue;

            String parentCd = firstOrNull( clrCdArr );
            if ( parentCd == null || parentCd.length() == 0 )
            {
                logger.logError( "[FM자동생성] CLR_SUB_MTL_CD 누락 rowId=" + rowId );
                continue;
            }
            result.add( parentCd );
        }
        return result;
    }

    /**
     * TB_C10_CLR_CD_SEQ 의 (CD_TP='FM') row 를 FOR UPDATE 로 잠그고 LAST_NO 를 반환.
     */
    private String lockAndReadLastNo( PosGenericDao dao )
    {
        PosParameter param = new PosParameter();
        param.setNamedParamter( "CD_TP", CD_TP_FM );
        PosRowSet rs = dao.find( C10ConstantsIF.C106000050_FM_SEQ_SELECT, param );
        if ( rs == null || rs.count() == 0 )
        {
            throw new PosException( "TB_C10_CLR_CD_SEQ 채번 초기 row 없음 (CD_TP='FM')" );
        }
        PosRow row = rs.next();
        String lastNo = DbCommonUtil.valueOf( row.getAttribute( "LAST_NO" ) );
        if ( lastNo == null || lastNo.length() == 0 )
            lastNo = "FM000";
        return lastNo;
    }

    /**
     * 자동생성된 1건을 TB_C10_CLR_CD_MNG 에 INSERT.
     */
    private void insertAutoRow( PosGenericDao dao, PosAuditAttributes audit,
                                String clrCd, String clrNm, String parentCd )
    {
        PosParameter p = new PosParameter();
        p.setNamedParamter( "CLR_SUB_MTL_CD", clrCd );
        p.setNamedParamter( "CLR_NM",         clrNm );
        p.setNamedParamter( "PARENT_CLR_CD",  parentCd );
        p.setAuditAttributes( audit );
        dao.insert( C10ConstantsIF.C106000050_FM_AUTO_INSERT, p );
    }

    /**
     * 자동생성 row 에 대한 수정이력 로그(C106000050.clrMngMdf_log) 적재.
     * MDF_RSN = "AUTO_FM_GEN({parent} N도)" 로 행위 구분.
     */
    private void insertModLog( PosGenericDao dao, PosAuditAttributes audit,
                               String clrCd, String parentCd, int toNo )
    {
        PosParameter p = new PosParameter();
        p.setNamedParamter( "CLR_SUB_MTL_CD", clrCd );
        p.setNamedParamter( "MDF_RSN", "AUTO_FM_GEN(" + parentCd + " " + toNo + "도)" );
        p.setNamedParamter( "ZFLAG", "" );
        p.setAuditAttributes( audit );
        dao.insert( C10ConstantsIF.C106000050_CLR_LOG_INSERT, p );
    }

    /**
     * TB_C10_CLR_CD_SEQ 의 LAST_NO 를 마지막 발행값으로 갱신.
     */
    private void updateLastNo( PosGenericDao dao, PosAuditAttributes audit, String lastNo )
    {
        PosParameter p = new PosParameter();
        p.setNamedParamter( "CD_TP",   CD_TP_FM );
        p.setNamedParamter( "LAST_NO", lastNo );
        p.setAuditAttributes( audit );
        dao.update( C10ConstantsIF.C106000050_FM_SEQ_UPDATE, p );
    }

    /**
     * 다음 채번값 계산.
     * 입력 형식: "FM" + 3자리 (예: FM006, FMA01, FMAA1, FMAAA)
     */
    String nextCode( String last )
    {
        if ( last == null || last.length() != 5 || !last.startsWith( FM_PREFIX ) )
            throw new PosException( "LAST_NO 형식 오류: " + last );

        String suffix = last.substring( 2 );
        int stage = stageOf( suffix );

        if ( stage == 1 )
        {
            int n = Integer.parseInt( suffix );
            if ( n < 999 )
                return FM_PREFIX + pad3( n + 1 );
            // FM999 → FMA01
            return FM_PREFIX + ALPHA.charAt( 0 ) + "01";
        }
        if ( stage == 2 )
        {
            char a = suffix.charAt( 0 );
            int  n = Integer.parseInt( suffix.substring( 1 ) );
            if ( n < 99 )
                return FM_PREFIX + a + pad2( n + 1 );
            int ai = ALPHA.indexOf( a );
            if ( ai < ALPHA.length() - 1 )
                return FM_PREFIX + ALPHA.charAt( ai + 1 ) + "01";
            // FMZ99 → FMAA1
            return FM_PREFIX + ALPHA.charAt( 0 ) + ALPHA.charAt( 0 ) + "1";
        }
        if ( stage == 3 )
        {
            char a1 = suffix.charAt( 0 );
            char a2 = suffix.charAt( 1 );
            int  n  = Integer.parseInt( suffix.substring( 2 ) );
            if ( n < 9 )
                return FM_PREFIX + a1 + a2 + ( n + 1 );
            int a2i = ALPHA.indexOf( a2 );
            if ( a2i < ALPHA.length() - 1 )
                return FM_PREFIX + a1 + ALPHA.charAt( a2i + 1 ) + "1";
            int a1i = ALPHA.indexOf( a1 );
            if ( a1i < ALPHA.length() - 1 )
                return FM_PREFIX + ALPHA.charAt( a1i + 1 ) + ALPHA.charAt( 0 ) + "1";
            // FMZZ9 → FMAAA
            return FM_PREFIX + ALPHA.charAt( 0 ) + ALPHA.charAt( 0 ) + ALPHA.charAt( 0 );
        }
        // stage 4: 모두 알파벳
        char a1 = suffix.charAt( 0 );
        char a2 = suffix.charAt( 1 );
        char a3 = suffix.charAt( 2 );
        int a3i = ALPHA.indexOf( a3 );
        if ( a3i < ALPHA.length() - 1 )
            return FM_PREFIX + a1 + a2 + ALPHA.charAt( a3i + 1 );
        int a2i = ALPHA.indexOf( a2 );
        if ( a2i < ALPHA.length() - 1 )
            return FM_PREFIX + a1 + ALPHA.charAt( a2i + 1 ) + ALPHA.charAt( 0 );
        int a1i = ALPHA.indexOf( a1 );
        if ( a1i < ALPHA.length() - 1 )
            return FM_PREFIX + ALPHA.charAt( a1i + 1 ) + ALPHA.charAt( 0 ) + ALPHA.charAt( 0 );
        throw new PosException( "FM 컬러코드 채번 한도 도달 (마지막 FMZZZ 까지 발급됨)" );
    }

    /**
     * suffix(3자리)의 단계 판정.
     *  - 모두 숫자 = 1
     *  - 1자 알파+2자 숫자 = 2
     *  - 2자 알파+1자 숫자 = 3
     *  - 모두 알파 = 4
     */
    int stageOf( String suffix )
    {
        int alphaCount = 0;
        for ( int i = 0; i < suffix.length(); i++ )
        {
            char c = suffix.charAt( i );
            if ( Character.isLetter( c ) )
                alphaCount++;
        }
        if ( alphaCount == 0 ) return 1;
        if ( alphaCount == 1 ) return 2;
        if ( alphaCount == 2 ) return 3;
        return 4;
    }

    private String pad2( int n )
    {
        if ( n < 10 ) return "0" + n;
        return Integer.toString( n );
    }

    private String pad3( int n )
    {
        if ( n < 10 )  return "00" + n;
        if ( n < 100 ) return "0"  + n;
        return Integer.toString( n );
    }

    private String firstOrNull( String[] arr )
    {
        if ( arr == null || arr.length == 0 ) return null;
        return arr[0];
    }

    @Override
    public String doPreActivity( PosContext ctx )
    {
        return null;
    }

    @Override
    public String doPostActivity( PosContext ctx )
    {
        return null;
    }

    public String getDefaultMsgCode()
    {
        return null;
    }

    public String[] getDefaultMsgParam( PosContext ctx )
    {
        return null;
    }
}
