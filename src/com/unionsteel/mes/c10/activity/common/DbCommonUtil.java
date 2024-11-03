/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbCommonUtil.java
 * Change history
 * @LastModifyDate : 2011. 12. 09
 * @LastModifier : 김종범
 * @LastVersion : 1.0
 * 1.0 2011. 12. 09 김종범 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.common;

import java.math.BigDecimal;

import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 공통적으로 쓰이는 Method를 모아둔 class이다.
 * 
 * @author 김종범
 * @version 1.0
 */
public class DbCommonUtil implements C10NuiConstantsIF
{

    /**
     * Object 값을 String 값으로 변환하는 메소드이다.
     * <xmp>
     * 기존의 String class의 valueOf의 확장형
     * Object[] 또는 Object인지 구분후 String 형태로 변환,
     * null일 경우 기존에 스트링타입 문자열 "null"로 변환되는걸 ""으로 변환하도록 확장
     * </xmp>
     * 
     * @param data String type으로 변환될 Object value
     * @return String
     */
    public static String valueOf( Object data )
    {
        String value = C10STR_SPACE;
        if ( data instanceof Object[] )
        {
            value = String.valueOf( ( (Object[]) data )[0] ).trim();
        } else
        {
            value = String.valueOf( data ).trim();
        }

        if ( value.equals( C10STR_NULL ) )
        {
            value = C10STR_SPACE;
        }
        return value;
    }

    /**
     * 두개의 Object타입 변수를 String타입으로 변환후 동일한지 비교하는 메소드이다.
     * 
     * @param data 비교대상 1
     * @param data1 비교대상 2
     * @return Boolean
     */

    public static Boolean isSame( Object data, Object data1 )
    {
    	
    	
        String str1 = DbCommonUtil.valueOf( data );
        String str2 = DbCommonUtil.valueOf( data1 );
        Boolean returnValue = null;
        if ( str1.equals( str2 ) )
        {
            returnValue = Boolean.TRUE;
        } else
        {
            returnValue = false;
        }

        return returnValue;
    }

    /**
     * 2진수 String값을 돌려주는 메소드이다.
     * <xmp>
     * size와 data값을 주면 size에 맞게 2진수 스트링값을 리턴한다.
     * (예: size: 4 data: 4 --> 리턴값 0100)
     * </xmp>
     * 
     * @param bitsize 2진수 사이즈
     * @param data 변환될 데이터
     * @return String
     * @throws Exception
     */
    public static String toBinary( int bitsize, int data ) throws Exception
    {
        String binary = C10STR_SPACE;
        if ( Math.pow( 2, bitsize ) > data )
        {
            int re = data;

            for ( int i = 0; i < bitsize; i++ )
            {
                binary = Integer.toString( re % 2 ) + binary;
                re = re / 2;
            }
        } else
        {
            throw new Exception( EXCEPTION_MSG1 );
        }
        return binary;

    }

    /**
     * 단일 Row일때 PosRowSet의 count가 0 아닐때 단일 PosRow를 돌려주는 메소드이다.
     * PosRowSet count가 0일때는 PosRow값은 null로 돌려준다.
     * 
     * @param rowset PosRowSet
     * @return PosRow
     */
    public static PosRow rowOf( PosRowSet rowset )
    {
        PosRow row = null;
        if ( rowset != null )
        {
            if ( rowset.count() != 0 )
            {
                rowset.reset();
                row = rowset.next();
            }
        }
        return row;
    }

    /**
     * row가 null이 아닐경우에만 row에서 값을 리턴해주는 메소드이다.
     * <xmp>
     * row가 null이면 ""을 리턴
     * row가 null이 아니면 row의 해당 칼럼 값을 리턴한다.
     * </xmp>
     * 
     * @param row PosRowSet
     * @param columnName 칼럼명
     * @return String
     */

    public static String rowValueOf( PosRow row, String columnName )
    {
        String columnValue = C10STR_SPACE;
        if ( row != null )
        {
            columnValue = DbCommonUtil.valueOf( row.getAttribute( columnName ) );
        }
        return columnValue;
    }

    /**
     * str에 Null값 또는 비어있는지를 check하는 함수이다.
     * <xmp>
     * str가 null 또는 ""이면 true을 리턴
     * str가 null 이 아니고 ""도 아니면 false 리턴한다.
     * </xmp>
     * 
     * @param str 비교값
     * @return boolean
     */

    public static boolean isStrNull( String str )
    {
        if ( str == null || str.equals( C10STR_SPACE ) || str.equals( C10STR_NULL ) )
        {
            return true;
        } else
        {
            return false;
        }
    }

    /**
     * obj에 Null값 또는 비어있는지를 check하는 함수이다.
     * <xmp>
     * obj가 null 또는 ""이면 true을 리턴
     * obj가 null 이 아니고 ""도 아니면 false 리턴한다.
     * </xmp>
     * 
     * @param obj 비교값
     * @return boolean
     */

    public static boolean isNull( Object obj )
    {
        if ( obj == null )
        {
            return true;
        } else if ( obj.toString().equals( C10STR_SPACE ) || obj.toString().equals( C10STR_NULL ) )
        {
            return true;
        } else
        {
            return false;
        }
    }

    /**
     * mode가 따라 obj1와 obj2의 수치값을 비교해 결과값을 return하는 함수이다.
     * <xmp>
     * mode가 true이면 obj1와 obj2의 값을 비교해 큰값을 return
     * mode가 false이면 obj1와 obj2의 값을 비교해 작은값을 return
     * </xmp>
     * 
     * @param obj1 비교값1
     * @param obj2 비교값2
     * @param mode return value 설정
     * @return Object
     */

    public static Object numCompare( Object obj1, Object obj2, boolean mode )
    {
        if ( isNull( obj2 ) )
        {
            return obj1;
        } else if ( isNull( obj1 ) )
        {
            return obj2;
        } else
        {
            double num1 = Double.parseDouble( obj1.toString() );
            double num2 = Double.parseDouble( obj2.toString() );

            if ( num2 == 0 )
            {
                return obj1;
            } else if ( num1 == 0 )
            {
                return obj2;
            } else if ( Double.compare( num1, num2 ) < 0 )
            {
                if ( mode )
                    return obj2;
                else
                    return obj1;
            } else
            {
                if ( mode )
                    return obj1;
                else
                    return obj2;
            }
        }
    }

    /**
     * mode가 따라 obj1와 obj2의 수치값을 비교해 결과값을 return하는 함수이다.
     * <xmp>
     * mode가 true이면 obj1와 obj2의 값을 비교해 큰값을 return
     * mode가 false이면 obj1와 obj2의 값을 비교해 작은값을 return
     * </xmp>
     * 
     * @param str1 비교값1
     * @param str2 비교값2
     * @param mode return value 설정
     * @return Object
     */

    public static String numCompare( String str1, String str2, boolean mode )
    {
        if ( str2.equals( C10STR_SPACE ) )
        {
            return str1;
        } else if ( str1.equals( C10STR_SPACE ) )
        {
            return str2;
        } else
        {
            double num1 = Double.parseDouble( str1.toString() );
            double num2 = Double.parseDouble( str2.toString() );

            if ( num2 == 0 )
            {
                return str1;
            } else if ( num1 == 0 )
            {
                return str2;
            } else if ( Double.compare( num1, num2 ) < 0 )
            {
                if ( mode )
                    return str2;
                else
                    return str1;
            } else
            {
                if ( mode )
                    return str1;
                else
                    return str2;
            }
        }
    }

    /**
     * Count 수에 따라 '*'반환하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param Count '*' 수
     * @return String
     */

    public static String setAstar( int Count )
    {
        String result = C10STR_SPACE;

        for ( int i = 0; i < Count; i++ )
        {
            result = result + C10STR_STAR;
        }

        return result;
    }

    /**
     * PLTCM X-RAY SET치를반환하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param PLTCM_THK_TRV 목표두께
     * @return double
     */

    public static double pltcm_x_Ray( double PLTCM_THK_TRV )
    {
        String value1 = C10STR_SPACE;
        String value2 = C10STR_SPACE;
        int IDX = Double.toString( PLTCM_THK_TRV ).indexOf( C10STR_DOT );
        double result = PLTCM_THK_TRV;
        if ( IDX > 0 )
        {
            value1 = Double.toString( PLTCM_THK_TRV ).substring( 0, IDX );
            value2 = Double.toString( PLTCM_THK_TRV ).substring( IDX + 1, 
                    Double.toString( PLTCM_THK_TRV ).length() );
            
            if ( value2.length() > 2 )
            {
                if ( value2.substring( 2, 3 ).equals( NUM1 ) || 
                        value2.substring( 2, 3 ).equals( NUM2 ) )
                    result = Double.parseDouble( value1 + C10STR_DOT + value2.substring( 0, 2 ) + NUM0 );
                else if ( value2.substring( 2, 3 ).equals( NUM3 ) 
                        || value2.substring( 2, 3 ).equals( NUM4 ) 
                        || value2.substring( 2, 3 ).equals( NUM6 ) 
                        || value2.substring( 2, 3 ).equals( NUM7 ) )
                    result = Double.parseDouble( value1 + C10STR_DOT + value2.substring( 0, 2 ) + NUM5 );
                else if ( value2.substring( 2, 3 ).equals( NUM8 ) 
                        || value2.substring( 2, 3 ).equals( NUM9 ) )
                {
                    BigDecimal tmpResult = new BigDecimal(value1 + C10STR_DOT + value2.substring(0, 2));
                    BigDecimal finalResult = tmpResult.add(new BigDecimal("0.01"));
                	double resultAsDouble = finalResult.doubleValue();
                	result = resultAsDouble;
//                    result = Double.parseDouble(value1 + C10STR_DOT + value2.substring( 0, 2 )) + 0.01;
                }
            }
        }

        return result;
    }

    /**
     * 두께 수치를 소수점 3자리처리하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param PLTCM_THK_TRV 목표두께
     * @return double
     */

    public static double thk_dot( double PLTCM_THK_TRV )
    {
        String value1 = C10STR_SPACE;
        String value2 = C10STR_SPACE;
        int IDX = Double.toString( PLTCM_THK_TRV ).indexOf( C10STR_DOT );
        double result = PLTCM_THK_TRV;
        if ( IDX > 0 )
        {
            value1 = Double.toString( PLTCM_THK_TRV ).substring( 0, IDX );
            value2 = Double.toString( PLTCM_THK_TRV ).substring( IDX + 1, 
                    Double.toString( PLTCM_THK_TRV ).length() );
            if ( value2.length() > 3 )
            {
                result = Double.parseDouble(value1 + C10STR_DOT + value2.substring( 0, 3 ));
            }
        }

        return result;
    }
}
