/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbQualDesignLoop.java
 * Change history
 * @LastModifyDate : 2011. 12. 09
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 09 김종범 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.ActivityUtil;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * DbQualDesignLoop Class는 이전 서비스에서 편성한 정보(Result set)를 읽어와 <br>
 * 다른 서비스에서 1건 단위로 처리할 수 있도록 기본정보를 편성하고 오류Log항목을 초기화하는<br>
 * Class이다.
 * <xmp>
 * 1. 서비스간 정보 Interface를 위해 PosContext에 항목변수를 관리한다.
 * - 처리 서비스가 Batch job임을 구분(BATCH_JOB=true)
 * - 처리대상 주문 행번 건수를 관리
 * . 처리 건수관리 변수의 값이 null인 경우 이전 서비스의 Result set건수를
 * 읽어 값을 Setting
 * . 처리 건수가 0이 아닌 경우 transition='success',
 * 0인 경우 'exit'로 Set하고 종료한다.
 * 2. 처리대상 항목을 저장변수에 등록한다.
 * 3. 후속 서비스에서 사용하는 변수를 초기화하여 등록한다.
 * . 오류발생여부 Check 변수(P_ERR_KEY= 'N‘)
 * . 오류 logging변수 Space처리
 * 4. 처리대상 주문 행번 건수를 1건 차감한다.
 * 사용 방법
 * <activity name="PROC_LOOP" class="com.unionsteel.mes.c10.activity.common.constants.DbQualDesignLoop.">
 * <transition name="enter" value="SUBSERVICE1" />
 * <transition name="update" value="SEARCH1" />
 * <property name="countName" value="처리 건수관리 변수명" />
 * <property name="param-count" value="1" />
 * <property name="param0" value="저장변수명|대상항목명" />
 * <property name="bind-result" value="Binding에 사용할 이전 Result Key" />
 * </activity>
 * Property 설정
 * sqlkey : query.xml의 query id
 * dao : applicationContext.xml의 DAO id
 * param-count : Binding 할 개 수 (select * from emp where deptno=?)의 "?" 수
 * param#(param0,param1...): Binding Value ("?"와 순서 일치 하여야 함)
 * resultkey : Query 결과를 ctx에 저장할 Key
 * </xmp>
 * 
 * @author 김종범
 * @see PosActivity
 * @version 1.0
 */

public class DbQualDesignLoop extends PosActivity implements C10NuiConstantsIF
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
        try
        {

            int paramCount = 0; // 파라미터 갯수
            int procCount = 0;
            int total_row = 0; // 전체 row
            int proc_row = 0;
            int this_row = 0; // 현재 row
            String param[] = null;

            ctx.put( C10STR_P_ERR_KEY, C10STR_NO );
            ctx.put( C10STR_BATCH_JOB, C10STR_TRUE ); // 처리 서비스가 BATCH_JOB임을 구분
            String paramCt = this.getProperty( PosServiceParamIF.PARAM_COUNT ); // param-count
            String coutNm = this.getProperty( C10STR_COUNTNAME ); // 처리건수 관리 변수명 PROC_COUNT

//            if ( coutNm.equals( "QLT_DSN_VALID_COUNT" ) )
//            {
//                this_row = 0; // 현재 row
//            }
            Object coutVal = ctx.get( coutNm ); // 처리건수 관리 변수명

            String bindResultKey = this.getProperty( C10PN_BIND_RESULT ); // 이전 서비스 ResultKey
            PosRowSet bindSet = ctx.getRowSet( bindResultKey ); // ResultKey의 ResultSet을 가져온다.
            total_row = bindSet.count(); // 전체 row의 갯수를 리턴한다.

            if ( ActivityUtil.isNull( coutVal ) )
            {
                procCount = total_row;
            } else
            {
                procCount = Integer.parseInt( DbCommonUtil.valueOf( coutVal ) );// 전체 row의 갯수를 진행 카운터에 넣는다
            }
            if ( procCount == 0 ) // 진행 건수가 모두 끝났을 때 exit로 빠진다.
            {
                ctx.remove( coutNm );
                return C10STR_EXIT;
            }
            procCount -= 1; // 진행 건수를 하나씩 줄인다.
            this_row = total_row - procCount; // 전체 6 이면 5 -> 현재 row는 1
            ctx.put( COL_QLT_DSN_ERR_YN, C10STR_SPACE ); // 품질설계에러여부 초기화
            ctx.put( C10STR_P_ERR_KEY, C10STR_NO );

            if ( paramCt != null ) // 파라미터 카운터가 null이 아니라면
            {

                paramCount = Integer.parseInt( paramCt.trim() );
                param = new String[paramCount];

                PosRow row = null;
                bindSet.reset(); // RowSet의 커서 위치를 처음으로 이동시킨다.
                String[] paramValueArry = null;
                Object bindParam = null;

                while ( bindSet.hasNext() )
                {
                    row = bindSet.next(); // RusultKey의 첫번째 row를 가져온다.
                    proc_row += 1;

                    if ( this_row == proc_row )
                    {

                        for ( int i = 0; i < paramCount; i++ )
                        {
                            param[i] = this.getProperty( C10PN_PARAM + i ); // 저장변수명|대상항목명
                            paramValueArry = param[i].split( C10STR_REGULAR_EXP_PIPE );
                            // paramValueArry[0] -> 저장변수명
                            // paramValueArry[1] -> 대상항목명
                            bindParam = row.getAttribute( paramValueArry[1] );
                            ctx.put( paramValueArry[0], bindParam );
                        }
                        ctx.put( coutNm, procCount );
                        return PosBizControlConstants.SUCCESS;
                    }
                }

            } else
            {
                return PosBizControlConstants.FAILURE;
            }

        } catch ( Exception e )
        {

            logger.logError( "DbQualDesignLoop 에러 발생 : " +  ctx);
            e.printStackTrace();
            ctx.setException( e );
            return PosBizControlConstants.FAILURE;
        }

        return PosBizControlConstants.SUCCESS;
    }
}
