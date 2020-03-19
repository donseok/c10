/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSetCommit.java
 * Change history
 * @LastModifyDate : 2011. 12. 16
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 09 김종범 최초 생성
 * ==============================================================================
 */

package com.unionsteel.mes.c10.activity.common;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 판단 변수명을 받아 commit 또는 Rollback 처리하는 Class이다.
 * <xmp>
 * 1.checkId를 확인하여 'Y'인 경우 Commit, 'N'인 경우 Rollback
 * 2.exitFlag가 Y이면 transition = 'exit' N이면 transition = 'success'
 * <activity name="test" class="com.unionsteel.mes.c10.activity.common.DbSetCommit">
 * <transition name="success" value="test1" />
 * <transition name="exit" value="test2" />
 * <transition name="failure" value="test3" />
 * <property name="exitFlag" value="y" />
 * <property name="checkId" value="y" />
 * </activity>
 * checkId 파라미터의 값은 대소문자를 가리지 않도록 처리 했습니다.
 * </xmp>
 * 
 * @author 김종범
 * @see PosActivity
 * @version 1.0
 */
public class DbSetCommit extends PosActivity implements C10NuiConstantsIF
{

    /**
     * 반드시 구현해야 하는 Method이다.
     * 
     * @throws PosException IO Exception 발생 시
     * @param ctx Service내의 Data를 관리하는 PosContext 객체
     * @return success - 성공적으로 끝났을 때 Route transition.
     *         nullpointer - NullPointerException 발생 시 Route transtion.
     *         faillue - 그 외 Exception 발생 시 Route transition.
     */
    public String runActivity( PosContext ctx )
    {

        // 파라미터 셋팅
        String checkIdParam = null;
        String exitflag = null;
        String checkId = null;
        String txName = null;

        checkIdParam = this.getProperty( C10PN_CHKID );
        exitflag = this.getProperty( C10PN_EXITFLAG );
        checkId = (String) ctx.get( checkIdParam );
        txName = this.getProperty( C10PN_TXNAME );

        // 처리중 에러가 나면 failure 처리
        try
        {
            // 대소문자 상관없이 N이면 커밋 Y이면 롤백
            if ( checkId.toUpperCase().equals( C10STR_NO ) )
            {
                this.commitTransaction( txName );
            } else
            {
                this.commitTransaction( txName );
                // this.rollbackTransaction(txName);
            }

            // 대소문자 상관없이 Y이면 transition = 'exit' N이면 transition = 'success'
            if ( exitflag.toUpperCase().equals( C10STR_YES ) )
            {
                return C10STR_EXIT;
            } else
            {
                return PosBizControlConstants.SUCCESS;
            }
        } catch ( Exception e )
        {
            logger.logError( e.getMessage() );
            return PosBizControlConstants.SUCCESS; // commit시는 failure 없음 2012--03-02 김종범
        }
    }

}
