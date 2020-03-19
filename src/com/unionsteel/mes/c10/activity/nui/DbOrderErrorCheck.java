/*==============================================================================
*Copyright(c) 2011 유니온스틸
*@FileName        : DbOrderErrorCheck.java
*Change history 
*@LastModifyDate	: 2012. 02. 12
*@LastModifier		: 김종범
*@LastVersion		: 1.0
*  1.0	2012. 02. 12	 김종범	최초 생성
==============================================================================*/
package com.unionsteel.mes.c10.activity.nui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionRuleVO;
import com.posdata.glue.util.log.PosLog;
import com.unionsteel.mes.c10.activity.common.ActivityUtil;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;


/**
 * 이 Class는 생산가부요청의 주문항목들을 받아 에러여부를 체크하는 Class이다.										
 * 체크이후 생산가부요청 서비스를 Return Call하는 Class이다.
  
 * <xmp>
 *	
 *- 정합성Check기준은 FD설계서를 참조
 *  정합성 Check결과 정상인 경우 transition='success', 
 *  아닌 경우 'failure'로 Set하고 종료한다.
 *- 오류가 발생한 경우 오류 내역을 PosContext에 등록한다.
 *
 * 사용 방법
 *  <activity name="ORD_ERR_CHK" class="com.unionsteel.mes.c10.activity.nui.DbOrderErrorCheck">
 *   <transition name="success" value="end" />
 *   <transition name="failure" value="ERROR_LOG" />
 *   <property name="dao" value="mesdao" />
 *   <property name="bind-result" value="RK_MAIN" />
 * </activity>
 * 
 *  Property 설정
 *  dao : applicationContext.xml의 DAO id
 *  param-count : Binding 할 개 수 (select * from emp where deptno=?)의 "?" 수
 *  bind-result : Binding된 PosRowSet
 *  </xmp>
 * @author  김종범
 * @see     PosActivity  
 * @version 1.0
 */

public class DbOrderErrorCheck extends PosActivity implements C10NuiConstantsIF{

	
	
	private String		ord_req_no				= null;
	private String		ord_req_ln				= null;
	



	/**
	 * <p>
	 * 이 메소드는 PosActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다. 
	 * </p>
	 * @throws PosException IO Exception 발생 시
	 * @param ctx Service내의 Data를 관리하는 PosContext 객체  
	 * @return success - 성공적으로 끝났을 때 Route transition.
	 * nullpointer - NullPointerException 발생 시 Route transtion.
	 * faillue - 그 외 Exception 발생 시 Route transition.
	 */
	public String runActivity(PosContext ctx) {
		ctx.put(C10STR_P_ERR_KEY		,C10STR_NO);
		ctx.put(C10STR_QLT_DSN_ERR_CD	,C10STR_SPACE);
//		String 	bind_result	=	this.getProperty(C10PN_BIND_RESULT);
//		PosRowSet	rowset	=	ctx.getRowSet(bind_result);
		PosRow		row		=	null;
//		PosRowSet	rowset1	=	ctx.getRowSet(bind_result);
//		PosRowSet	rowset2	=	ctx.getRowSet(bind_result);
		PosRowSet   rowset  = null; 

	
//		if(row == null){
//			setError(ctx , logger , ERRMSG_CF68 , ERRCD_CF68 
//					 , new String[]{ord_req_no, ord_req_ln, ERRCD_CF68}  , ERRMSG_CF68);//MS002007
//			return PosBizControlConstants.FAILURE;
//			
//
//			
//		}		
		
		String		fnl_cus_cd	        =	C10STR_SPACE;
		String		cus_bth_pap_no		=	C10STR_SPACE;
		String 		spc_avr             =	C10STR_SPACE;          
		String		spc_yr              =	C10STR_SPACE;
		String		prd_shp             =   C10STR_SPACE;	
        String      ord_usg_cd          =	C10STR_SPACE;		
        String      prd_nm_cd           =	C10STR_SPACE;
        String      ord_exc_thk         =	C10STR_SPACE;        
        String      ord_exc_wth         =	C10STR_SPACE;       
        String      ord_exc_lth         =	C10STR_SPACE;
        String      ord_thk_tp          =	C10STR_SPACE;
        String      gw_asg_cd           =	C10STR_SPACE;
        String      ord_sur_hnd_cd      =	C10STR_SPACE;
        String      ccl_bom_no          =	C10STR_SPACE;
        String      ord_slit_grp_cnt    =	C10STR_SPACE;       
        String      ord_mix_wth1        =	C10STR_SPACE;        
		            ord_req_no			=	C10STR_SPACE;
					ord_req_ln		    =	C10STR_SPACE;
					
		String		glueordusgcd        =	C10STR_SPACE;          //고객공통 주문용도
		String		gluespcavr          =	C10STR_SPACE;          //고객공통 규격약호
		String		gluespcyr           =	C10STR_SPACE;          //고객공통 규격년도
		String		gluecuscd           =	C10STR_SPACE;          //고객공통 고객사
		String		glueprdnmcd         =	C10STR_SPACE;          //고객공통 품명
		String		gluethkrngllv       =	C10STR_SPACE;          //고객공통 제품두께범위 하한
		String		gluethkrngulv       =	C10STR_SPACE;          //고객공통 제품두께범위 상한
		String		gluewthrngllv       =	C10STR_SPACE;          //고객공통 제품폭범위 하한
		String		gluewthrngulv       =	C10STR_SPACE;          //고객공통 제품폭범위 상한
		String		gluelthrngllv       =	C10STR_SPACE;          //고객공통 제품길이범위 하한
		String		gluelthrngulv       =	C10STR_SPACE;          //고객공통 제품길이범위 상한
		String		gluethktp           =	C10STR_SPACE;          //고객공통 두께구분코드
		String		gluegwasg           =	C10STR_SPACE;          //고객공통 도금량코드
		String		gluesurhnd          =	C10STR_SPACE;          //고객공통 표면처리코드
		String		gluecclbom          =	C10STR_SPACE;          //고객공통 칼라코드전면		
		
		if(!DbCommonUtil.isNull(ctx.get(COL_FNL_CUS_CD)))
		    fnl_cus_cd	        =	ctx.get(COL_FNL_CUS_CD).toString();
		if(!DbCommonUtil.isNull(ctx.get(COL_CUS_BTH_PAP_NO)))
			cus_bth_pap_no		=	ctx.get(COL_CUS_BTH_PAP_NO).toString();
		if(!DbCommonUtil.isNull(ctx.get(COL_SPC_AVR)))
			spc_avr             =	ctx.get(COL_SPC_AVR).toString();          
		if(!DbCommonUtil.isNull(ctx.get(COL_SPC_YR)))                    
			spc_yr              =	ctx.get(COL_SPC_YR).toString(); 
		if(!DbCommonUtil.isNull(ctx.get(COL_PRD_SHP)))                    
			prd_shp             =	ctx.get(COL_PRD_SHP).toString(); 
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_USG_CD)))                    
			ord_usg_cd          =	ctx.get(COL_ORD_USG_CD).toString(); 		
		if(!DbCommonUtil.isNull(ctx.get(COL_PRD_NM_CD)))                    
			prd_nm_cd           =	ctx.get(COL_PRD_NM_CD).toString(); 		
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_EXC_THK)))                    
			ord_exc_thk         =	ctx.get(COL_ORD_EXC_THK).toString(); 		
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_EXC_WTH)))                    
			ord_exc_wth         =	ctx.get(COL_ORD_EXC_WTH).toString(); 
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_EXC_LTH)))                    
			ord_exc_lth         =	ctx.get(COL_ORD_EXC_LTH).toString(); 	
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_THK_TP)))                    
			ord_thk_tp         =	ctx.get(COL_ORD_THK_TP).toString(); 
		if(!DbCommonUtil.isNull(ctx.get(COL_GW_ASG_CD)))                    
			gw_asg_cd          =	ctx.get(COL_GW_ASG_CD).toString();     
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_SUR_HND_CD)))                    
			ord_sur_hnd_cd     =	ctx.get(COL_ORD_SUR_HND_CD).toString();     
		if(!DbCommonUtil.isNull(ctx.get(COL_CCL_BOM_NO)))                    
			ccl_bom_no         =	ctx.get(COL_CCL_BOM_NO).toString();		
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_SLIT_GRP_CNT)))                    
			ord_slit_grp_cnt         =	ctx.get(COL_ORD_SLIT_GRP_CNT).toString();  
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH1)))                    
			ord_mix_wth1         =	ctx.get(COL_ORD_MIX_WTH1).toString();  				
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_REQ_NO)))
		    ord_req_no			=	ctx.get(COL_ORD_REQ_NO).toString();
		if(!DbCommonUtil.isNull(ctx.get(COL_ORD_REQ_LN)))
			ord_req_ln		    =	ctx.get(COL_ORD_REQ_LN).toString();
		
					
		//고객사양번호 Chk & 고객공통 Chk			
		if(ActivityUtil.isValidData(cus_bth_pap_no)){
			if(!cus_bth_pap_no.startsWith(fnl_cus_cd))
			{
				setError(ctx	, logger , ERRMSG_A223 
					    , ERRCD_A223
							, new String[]{ord_req_no, ord_req_ln, ERRCD_A223} , ERRMSG_CF68);//MS002007
				//return PosBizControlConstants.FAILURE; 
			}
		
		}	
	        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_CUS_BTH_PAP_NO ) ) )	            
	        {	
			    PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
				PosParameter param = new PosParameter(); //MD View param
				//PosRowSet	rowset = null;
		        //PosRow row = null;		
		        param = new PosParameter();  //MD View param
		        param.setWhereClauseParameter( 0, (String) ctx.get( COL_CUS_BTH_PAP_NO ) );
		        
		        
		        try{
		        	//결과값 잘 가져오는지 확인
		        	rowset = dao.find( VI_M00_C10A1020, param );	//고객공통View.select			
		        }catch(Exception e){
		        	rowset = null;
					logger.logError(e.getMessage());	
					setError(ctx	, logger , ERRMSG_A241
						    , ERRCD_A241
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A241} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 
		        }

		        if ( rowset.count() == 1 )
		        {
		        	row = rowset.next();
		        	
		        	//고객공통기준 결과값  
			        glueordusgcd   = DbCommonUtil.valueOf( row.getAttribute( COL_ORD_USG_CD ) );
			        gluespcavr     = DbCommonUtil.valueOf( row.getAttribute( COL_SPC_AVR ) );
			        gluespcyr      = DbCommonUtil.valueOf( row.getAttribute( COL_SPC_YR ) );
			        gluecuscd      = DbCommonUtil.valueOf( row.getAttribute( COL_CUS_CD ) );	
			        glueprdnmcd    = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_NM_CD ) );
					gluethkrngllv  = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_THK_RNG_LLV ) );
					gluethkrngulv  = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_THK_RNG_ULV ) );					
					gluewthrngllv  = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_WTH_RNG_LLV ) );
					gluewthrngulv  = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_WTH_RNG_ULV ) );					
					gluelthrngllv  = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_LTH_RNG_LLV ) );
					gluelthrngulv  = DbCommonUtil.valueOf( row.getAttribute( COL_PRD_LTH_RNG_ULV ) );
					gluethktp      = DbCommonUtil.valueOf( row.getAttribute( COL_ORD_THK_TP ) );					
					gluegwasg      = DbCommonUtil.valueOf( row.getAttribute( COL_GW_ASG_CD ) );	
					gluesurhnd     = DbCommonUtil.valueOf( row.getAttribute( COL_ORD_SUR_HND_CD ) );		
					gluecclbom     = DbCommonUtil.valueOf( row.getAttribute( COL_CCL_BOM_NO ) );						
			        
		        	//주문항목과 결과값 에러체크		            
		            if(!ord_usg_cd.equals(glueordusgcd)){
						setError(ctx	, logger , ERRMSG_A243
							    , ERRCD_A243
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A243} , ERRMSG_CF68); //주문용도 고객공통기준 상이			            	
		            }
		            if(!spc_avr.equals(gluespcavr)){
						setError(ctx	, logger , ERRMSG_A244
							    , ERRCD_A244
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A244} , ERRMSG_CF68); //규격약호 고객공통기준 상이		            	
		            }
		            if(!spc_yr.equals(gluespcyr)){
						setError(ctx	, logger , ERRMSG_A245
							    , ERRCD_A245
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A245} , ERRMSG_CF68); //규격년도 고객공통기준 상이		            	
		            }
		            if(!fnl_cus_cd.equals(gluecuscd)){
						setError(ctx	, logger , ERRMSG_A246
							    , ERRCD_A246
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A246} , ERRMSG_CF68); //최종수요가 고객공통기준 상이		            	
		            }
		            if(!prd_nm_cd.equals(glueprdnmcd)){
						setError(ctx	, logger , ERRMSG_A247
							    , ERRCD_A247
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A247} , ERRMSG_CF68); //품명 고객공통기준 상이	            	
		            }		            
		            if(ActivityUtil.isValidData(gluethkrngllv)){
		               if(Double.parseDouble(ord_exc_thk) < Double.parseDouble(gluethkrngllv)){
						setError(ctx	, logger , ERRMSG_A248
							    , ERRCD_A248
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A248} , ERRMSG_CF68); //주문두께 고객공통기준 상이
		               }
		            }
		            if(ActivityUtil.isValidData(gluethkrngulv)){
		               if(Double.parseDouble(ord_exc_thk) > Double.parseDouble(gluethkrngulv)){
						setError(ctx	, logger , ERRMSG_A248
							    , ERRCD_A248
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A248} , ERRMSG_CF68); //주문두께 고객공통기준 상이
		               }
		            }
		            
		            //조합폭 기준체크 변경 08-20 start
		            if(Double.parseDouble(ord_slit_grp_cnt) > 0 && ord_exc_wth.equals( ord_mix_wth1 )){
						if(ActivityUtil.isValidData(gluewthrngllv)){
						       if(Double.parseDouble(ord_slit_grp_cnt)* Double.parseDouble(ord_mix_wth1) < Double.parseDouble(gluewthrngllv)){
								setError(ctx	, logger , ERRMSG_A249
									    , ERRCD_A249
											, new String[]{ord_req_no, ord_req_ln, ERRCD_A249} , ERRMSG_CF68); //주문폭 고객공통기준 상이
						       }
						    }
						if(ActivityUtil.isValidData(gluewthrngulv)){
						   if(Double.parseDouble(ord_slit_grp_cnt)* Double.parseDouble(ord_mix_wth1) > Double.parseDouble(gluewthrngulv)){
							setError(ctx	, logger , ERRMSG_A249
								    , ERRCD_A249
										, new String[]{ord_req_no, ord_req_ln, ERRCD_A249} , ERRMSG_CF68); //주문폭 고객공통기준 상이
							   }
							}
		            	
		            }else{
				            if(ActivityUtil.isValidData(gluewthrngllv)){
				               if(Double.parseDouble(ord_exc_wth) < Double.parseDouble(gluewthrngllv)){
								setError(ctx	, logger , ERRMSG_A249
									    , ERRCD_A249
											, new String[]{ord_req_no, ord_req_ln, ERRCD_A249} , ERRMSG_CF68); //주문폭 고객공통기준 상이
				               }
				            }
				            if(ActivityUtil.isValidData(gluewthrngulv)){
				               if(Double.parseDouble(ord_exc_wth) > Double.parseDouble(gluewthrngulv)){
								setError(ctx	, logger , ERRMSG_A249
									    , ERRCD_A249
											, new String[]{ord_req_no, ord_req_ln, ERRCD_A249} , ERRMSG_CF68); //주문폭 고객공통기준 상이
				               }
				            }
		            }
//08-20 end            
		            
		            if(prd_shp.equals( PRD_SHP_SHEET ) && ActivityUtil.isValidData(gluelthrngllv)){
		               if(Double.parseDouble(ord_exc_lth) < Double.parseDouble(gluelthrngllv)){
						setError(ctx	, logger , ERRMSG_A250
							    , ERRCD_A250
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A250} , ERRMSG_CF68); //주문길이 고객공통기준 상이
		               }
		            }
		            if(prd_shp.equals( PRD_SHP_SHEET ) && ActivityUtil.isValidData(gluelthrngulv)){
		               if(Double.parseDouble(ord_exc_lth) > Double.parseDouble(gluelthrngulv)){
						setError(ctx	, logger , ERRMSG_A250
							    , ERRCD_A250
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A250} , ERRMSG_CF68); //주문길이 고객공통기준 상이
		               }
		            }			            
		            if(DbCommonUtil.isNull(gluethktp)){
		               if(ord_thk_tp.equals( ORD_THK_TP_3 )){
						setError(ctx	, logger , ERRMSG_A251
							    , ERRCD_A251
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A251} , ERRMSG_CF68); //두께구분코드 고객공통기준 상이
		               }
		            }		            
		            if(ActivityUtil.isValidData(gluethktp)){
		               if(gluethktp.equals( ORD_THK_TP_3 ) && !ord_thk_tp.equals( ORD_THK_TP_3 )){
						setError(ctx	, logger , ERRMSG_A251
							    , ERRCD_A251
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A251} , ERRMSG_CF68); //두께구분코드 고객공통기준 상이
		               }
		            }
		            if(ActivityUtil.isValidData(gluegwasg)){
		               if(!gluegwasg.equals(gw_asg_cd)){
						setError(ctx	, logger , ERRMSG_A252
							    , ERRCD_A252
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A252} , ERRMSG_CF68); //도금량  고객공통기준 상이
		               }
		            }
		            if(ActivityUtil.isValidData(gluesurhnd)){
		               if(!gluesurhnd.equals(ord_sur_hnd_cd)){
						setError(ctx	, logger , ERRMSG_A253
							    , ERRCD_A253
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A253} , ERRMSG_CF68); //주문표면처리  고객공통기준 상이
		               }
		            }		            
		    		if(ActivityUtil.isValidData(gluecclbom)){
	    			  if(!ccl_bom_no.startsWith(gluecclbom)){
						setError(ctx	, logger , ERRMSG_A254
							    , ERRCD_A254
									, new String[]{ord_req_no, ord_req_ln, ERRCD_A254} , ERRMSG_CF68); //색상코드  고객공통기준 상이
		               }
		            }
		            //row1 = rowset1.next();
		            //ctx.put( COL_CUS_REQ_ROL_THK, row.getAttribute( COL_CUS_REQ_ROL_THK ) );
  	            
	
		        } else if ( rowset.count() > 1 )
		        {
					setError(ctx	, logger , ERRMSG_A242
						    , ERRCD_A242
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A242} , ERRMSG_CF68);//MS002007
		          //  return PosBizControlConstants.FAILURE;
		        } else
		        {
					setError(ctx	, logger , ERRMSG_A241
						    , ERRCD_A241
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A241} , ERRMSG_CF68);//MS002007
		           // return PosBizControlConstants.FAILURE;
		        }
	      }
		
		
         //규격공통정보 Chk        
		if((ActivityUtil.isValidData(spc_avr))&& (ActivityUtil.isValidData(spc_yr)))
		{
			PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
			String 			colValue[] 			= 	null;//컬럼값
			PosParameter param = new PosParameter(); //MD View param
			
			colValue 		= new String[2];
			colValue[0] = (String)ctx.get(COL_SPC_AVR); //규격약호
			colValue[1] = (String)ctx.get(COL_SPC_YR);  //규격년도    			  
	      			
			//PosRowSet	rowset = null;


	          param = new PosParameter();  //MD View param
	          param.setWhereClauseParameter( 0, colValue[1] );
	          param.setWhereClauseParameter( 0, colValue[0] );


	          
		        try{
		        	//결과값 잘 가져오는지 확인
		        	rowset = dao.find( VI_M00_C10A1010, param );	//규격공통View.select			
		        }catch(Exception e){
		        	rowset = null;
					logger.logError(e.getMessage());
					setError(ctx	, logger , ERRMSG_A341
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A341} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 
		        }
		        if ( rowset.count() == 1 )
		        {
		            //row2 = rowset2.next();
		        }
		        else if(rowset.count() > 1){
					setError(ctx	, logger , ERRMSG_A342 
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRMSG_A342} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 	
			    }
		        else{
					setError(ctx	, logger , ERRMSG_A341 
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRMSG_A341} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 	
			    }
		
	     }
						

		//Master 기준 체크 
		if(ordMasterChk(ctx)){
//			return PosBizControlConstants.FAILURE;
		}

		//코드 체크 
		if(ordCodeChk(ctx)){
//			return PosBizControlConstants.FAILURE;
		}

				 
		if(DbCommonUtil.isNull(ctx.get(COL_XMSGS)))
			return PosBizControlConstants.SUCCESS;
		else return PosBizControlConstants.FAILURE;
	}
	

	/**
	 * 생산가부요청 정보에 대해 코드정보를 점검하는 메소드이다.
	 * <xmp>
	 * 코드체크 항목을 추가시 HashMap에 값을 넣을때 다음과 같은 방법으로 추가해주시면 됩니다.
	 * 예) codeChkMap.put("항목" , "에러코드/항목명");
	 * </xmp>
	 * @param context PosContext
	 * @return Boolean 판별 결과 
	 */
	public Boolean ordCodeChk(PosContext context){
		
		PosContext ctx  = context;
//		PosRow	row		= posRow;
		Boolean info	= false;
		
		String 		gw_asg_cd                = C10STR_SPACE;
		String 		prd_nm_cd                = C10STR_SPACE;
		String 		ord_pak_mth              = C10STR_SPACE;
		String 		prd_shp                  = C10STR_SPACE;
		String 		plnt_tp                  = C10STR_SPACE;
		String 		ord_rou_cd               = C10STR_SPACE;
		String 		ord_spnl_tp              = C10STR_SPACE;
		String 		ord_coilg_mth            = C10STR_SPACE;
		String 		ord_skp_deg              = C10STR_SPACE;
		String 		ord_thk_tp               = C10STR_SPACE;
		String 		ord_slv_knd_tp           = C10STR_SPACE;
		String 		embs_cd                  = C10STR_SPACE;
		String 		ord_ptt_flm_adh_loc_cd   = C10STR_SPACE;
		String 		ord_lth_mng_cd           = C10STR_SPACE;
		String 		ord_sht_lod_mth          = C10STR_SPACE;
		String 		trst_proc_yn             = C10STR_SPACE;
		String 		tag_tp                   = C10STR_SPACE;
		String 		cus_cd                   = C10STR_SPACE;
		String 		act_cus_cd               = C10STR_SPACE;
		String 		fnl_cus_cd               = C10STR_SPACE;
		String 		ord_coil_idia            = C10STR_SPACE;
		String 		ord_sur_hnd_cd           = C10STR_SPACE;
		String 		flow_chl                 = C10STR_SPACE;
		String 		ord_knd                  = C10STR_SPACE;
		String 		ord_usg_cd               = C10STR_SPACE;
		String 		ord_edg_asg_tp           = C10STR_SPACE;
		String 		wgt_dcs_mth_tp           = C10STR_SPACE;
		String      ord_thk_mng_cd           = C10STR_SPACE;
		String      ord_wth_mng_cd           = C10STR_SPACE;
		String      nat_cd                   = C10STR_SPACE;
		String      ord_tem_cd               = C10STR_SPACE;
		String      pak_msg_cd               = C10STR_SPACE;
		
		
    if(!DbCommonUtil.isNull(ctx.get(COL_GW_ASG_CD))) 
        gw_asg_cd                  =	ctx.get(COL_GW_ASG_CD).toString();  
    if(!DbCommonUtil.isNull(ctx.get(COL_PRD_NM_CD)))
        prd_nm_cd                  =	ctx.get(COL_PRD_NM_CD).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_MTH)))
        ord_pak_mth                =	ctx.get(COL_ORD_PAK_MTH).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_PRD_SHP)))
        prd_shp                    =	ctx.get(COL_PRD_SHP).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_PLNT_TP)))
        plnt_tp                    =	ctx.get(COL_PLNT_TP).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_ROU_CD)))
        ord_rou_cd                 =	ctx.get(COL_ORD_ROU_CD).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_SPNL_TP)))
        ord_spnl_tp                =	ctx.get(COL_ORD_SPNL_TP).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_COILG_MTH)))	
        ord_coilg_mth              =	ctx.get(COL_ORD_COILG_MTH).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_SKP_DEG)))
        ord_skp_deg                =	ctx.get(COL_ORD_SKP_DEG).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_THK_TP)))
        ord_thk_tp                 =	ctx.get(COL_ORD_THK_TP).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_SLV_KND_TP)))
        ord_slv_knd_tp             =	ctx.get(COL_ORD_SLV_KND_TP).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_EMBS_CD)))
        embs_cd                    =	ctx.get(COL_EMBS_CD).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_PTT_FLM_ADH_LOC_CD)))
        ord_ptt_flm_adh_loc_cd     =	ctx.get(COL_ORD_PTT_FLM_ADH_LOC_CD).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_LTH_MNG_CD)))
        ord_lth_mng_cd             =	ctx.get(COL_ORD_LTH_MNG_CD).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_SHT_LOD_MTH)))
        ord_sht_lod_mth            =	ctx.get(COL_ORD_SHT_LOD_MTH).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_TRST_PROC_YN)))
        trst_proc_yn               =	ctx.get(COL_TRST_PROC_YN).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_TAG_TP)))
        tag_tp                     =	ctx.get(COL_TAG_TP).toString(); 
    if(!DbCommonUtil.isNull(ctx.get(COL_CUS_CD)))
        cus_cd                     =	ctx.get(COL_CUS_CD).toString();  
    if(!DbCommonUtil.isNull(ctx.get(COL_ACT_CUS_CD)))
        act_cus_cd                 =	ctx.get(COL_ACT_CUS_CD).toString();    
    if(!DbCommonUtil.isNull(ctx.get(COL_FNL_CUS_CD)))
        fnl_cus_cd                 =	ctx.get(COL_FNL_CUS_CD).toString();    	
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_COIL_IDIA)))	
	    ord_coil_idia            =	ctx.get(COL_ORD_COIL_IDIA).toString();	
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_SUR_HND_CD)))	
    	ord_sur_hnd_cd            =	ctx.get(COL_ORD_SUR_HND_CD).toString();		
    if(!DbCommonUtil.isNull(ctx.get(COL_FLOW_CHL)))	
    	flow_chl                  =	ctx.get(COL_FLOW_CHL).toString();	
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_KND)))	
    	ord_knd                   =	ctx.get(COL_ORD_KND).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_USG_CD)))	
    	ord_usg_cd                =	ctx.get(COL_ORD_USG_CD).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_EDG_ASG_TP)))	
    	ord_edg_asg_tp            =	ctx.get(COL_ORD_EDG_ASG_TP).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_WGT_DCS_MTH_TP)))	
    	wgt_dcs_mth_tp            =	ctx.get(COL_WGT_DCS_MTH_TP).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_THK_MNG_CD)))	
    	ord_thk_mng_cd            =	ctx.get(COL_ORD_THK_MNG_CD).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_WTH_MNG_CD)))	
    	ord_wth_mng_cd            =	ctx.get(COL_ORD_WTH_MNG_CD).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_NAT_CD)))	
    	nat_cd                    =	ctx.get(COL_NAT_CD).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_ORD_TEM_CD)))	
    	ord_tem_cd                =	ctx.get(COL_ORD_TEM_CD).toString();
    if(!DbCommonUtil.isNull(ctx.get(COL_PAK_MSG_CD)))	
    	pak_msg_cd                =	ctx.get(COL_PAK_MSG_CD).toString();    
    

		
		HashMap codeChkMap =   new HashMap();
		
		//필수코드 항목
	    if(ActivityUtil.isValidData(prd_nm_cd)){
		    codeChkMap.put(COL_PRD_NM_CD                  , PARSEINFO_A161); //품명코드 미정의 코드 
	    }
	    if(ActivityUtil.isValidData(prd_shp)){
		    codeChkMap.put(COL_PRD_SHP                   , PARSEINFO_A461); //제품형태 미정의 코드 
	    }
	    if(ActivityUtil.isValidData(flow_chl)){
		    codeChkMap.put(COL_FLOW_CHL                  , PARSEINFO_A171); //유통경로 미정의 코드
	    }
	    if(ActivityUtil.isValidData(ord_knd)){
		    codeChkMap.put(COL_ORD_KND                   , PARSEINFO_A111); //주문종류 미정의 코드
	    }
	    if(ActivityUtil.isValidData(ord_usg_cd)){
		    codeChkMap.put(COL_ORD_USG_CD                , PARSEINFO_A891); //주문용도코드 미정의 코드 
	    }
//	    cus_cd를 db 값으로 가져와서 처리 - 2018.0312 JKJ
//	    if(ActivityUtil.isValidData(cus_cd)){
//		    codeChkMap.put(COL_CUS_CD                    , PARSEINFO_A121); //고객사코드 미정의 코드  
//	    }
	    if(ActivityUtil.isValidData(ord_edg_asg_tp)){
		    codeChkMap.put(COL_ORD_EDG_ASG_TP            , PARSEINFO_A471); //주문Edge지정구분 미정의 코드
	    }
	    if(ActivityUtil.isValidData(wgt_dcs_mth_tp)){
		    codeChkMap.put(COL_WGT_DCS_MTH_TP            , PARSEINFO_A421); //중량결정법구분 미정의 코드
	    }
	    if(ActivityUtil.isValidData(ord_thk_mng_cd)){
		    codeChkMap.put(COL_ORD_THK_MNG_CD            , PARSEINFO_A531); //주문두께관리코드 미정의 코드
	    }
	    if(ActivityUtil.isValidData(ord_wth_mng_cd)){
		    codeChkMap.put(COL_ORD_WTH_MNG_CD            , PARSEINFO_A561); //주문폭관리코드 미정의 코드
	    }
	    if(ActivityUtil.isValidData(nat_cd)){
		    codeChkMap.put(COL_NAT_CD                    , PARSEINFO_A131); //국가코드 미정의 코드 
	    }
	    if(ActivityUtil.isValidData(ord_tem_cd)){
		    codeChkMap.put(COL_ORD_TEM_CD                , PARSEINFO_A181); //영업팀코드 미정의 코드
	    }
        if(ActivityUtil.isValidData(pak_msg_cd)){
    	    codeChkMap.put(COL_PAK_MSG_CD                , PARSEINFO_A775); //포장메세지코드        	
        } 	    
	    	    
	   
	    //필수가 아닌 코드 항목 	    
	    if(ActivityUtil.isValidData(plnt_tp)){
		    codeChkMap.put(COL_PLNT_TP                  , PARSEINFO_A201); //플랜트구분 미정의 코드 
	    }
	    if(ActivityUtil.isValidData(ord_sur_hnd_cd)){
	        codeChkMap.put(COL_ORD_SUR_HND_CD           , PARSEINFO_A621); //주문표면처리코드 미정의 코드
	    }
        if(ActivityUtil.isValidData(ord_rou_cd)){
    	    codeChkMap.put(COL_ORD_ROU_CD               , PARSEINFO_A711); //주문조도코드 미정의 코드        	
        }
        if(ActivityUtil.isValidData(ord_coilg_mth)){
    	    codeChkMap.put(COL_ORD_COILG_MTH            , PARSEINFO_A751); //주문권취방법 미정의 코드        	
        }
        if(ActivityUtil.isValidData(ord_skp_deg)){
    	    codeChkMap.put(COL_ORD_SKP_DEG              , PARSEINFO_A741); //주문조질도 미정의 코드        	
        }
        if(ActivityUtil.isValidData(ord_thk_tp)){
    	    codeChkMap.put(COL_ORD_THK_TP               , PARSEINFO_A481); //주문두께구분 미정의 코드        	
        }
        if(ActivityUtil.isValidData(ord_slv_knd_tp)){
    	    codeChkMap.put(COL_ORD_SLV_KND_TP           , PARSEINFO_A761); //주문내경링종류구분 미정의 코드      	
        }
        if(ActivityUtil.isValidData(embs_cd)){
    	    codeChkMap.put(COL_EMBS_CD                  , PARSEINFO_A731); //EMBOSS무늬 미정의 코드         	
        }
        if(ActivityUtil.isValidData(ord_ptt_flm_adh_loc_cd)){
    	    codeChkMap.put(COL_ORD_PTT_FLM_ADH_LOC_CD   , PARSEINFO_A681); //주문보호필름부착위치코드 미정의 코드        	
        }
        if(ActivityUtil.isValidData(ord_lth_mng_cd)){
    	    codeChkMap.put(COL_ORD_LTH_MNG_CD           , PARSEINFO_A701); //주문길이관리코드 미정의 코드        	
        }
        if(ActivityUtil.isValidData(ord_sht_lod_mth)){
    	    codeChkMap.put(COL_ORD_SHT_LOD_MTH          , PARSEINFO_A791); //주문Sheet적재방법 미정의 코드        	
        }
        if(ActivityUtil.isValidData(trst_proc_yn)){
    	    codeChkMap.put(COL_TRST_PROC_YN             , PARSEINFO_A231); //위탁임가공여부 미정의 코드        	
        }
        if(ActivityUtil.isValidData(tag_tp)){
    	    codeChkMap.put(COL_TAG_TP                   , PARSEINFO_A931); //Tag유형 미정의 코드        	
        }	    
        if(ActivityUtil.isValidData(ord_coil_idia)){
    	    codeChkMap.put(COL_ORD_COIL_IDIA            , PARSEINFO_A774); //주문코일내경        	
        }
       
        
    	//고객사코드를 고객사코드 Master Code 체크 - 2018.0312 JKJ
  		if(ActivityUtil.isValidData(cus_cd))
  		{
  			Object bind_result = null;
  			PosRowSet	rowset6_1	=	ctx.getRowSet(bind_result);
  			//PosRow		row6		=	DbCommonUtil.rowOf(rowset6);
  			
  			PosGenericDao	dao	=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
  			String 			colValue[] 			= 	null;//컬럼값
  			PosParameter param = new PosParameter(); //MD View param
  			
  			colValue 		= new String[2];
  			colValue[0] = (String)ctx.get(COL_CUS_CD); //고객사코드	  
  	      			
  			//PosRowSet	rowset = null;


  	          param = new PosParameter();  //MD View param
  	          param.setWhereClauseParameter( 0, colValue[0] );


  	          
  		        try{
  		        	//결과값 잘 가져오는지 확인
  		        	rowset6_1 = dao.find( ACT_CUS_CD_SELECT , param );	//Master Code View.select			
  		        }catch(Exception e){
  		        	rowset6_1 = null;
  					logger.logError(e.getMessage());
  					setError(ctx	, logger , ERRMSG_A23
  						    , ERRCD_A93
  							, new String[]{ord_req_no, ord_req_ln, ERRCD_A23} , ERRMSG_CF68);//MS002007
  					//return PosBizControlConstants.FAILURE; 
  		        }
  		        if ( rowset6_1.count() == 1 )
  		        {
  		            //row6 = rowset6.next();
  		        }
  		        else if(rowset6_1.count() > 1){
  					setError(ctx	, logger , ERRMSG_A232 
  						    , ERRCD_A93
  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A232} , ERRMSG_CF68);//MS002007
  					//return PosBizControlConstants.FAILURE; 	
  			    }
  		        else{
  					setError(ctx	, logger , ERRMSG_A231 
  						    , ERRCD_A93
  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A231} , ERRMSG_CF68);//MS002007

  					//return PosBizControlConstants.FAILURE; 	
  			    }							
  			    //codeChkMap.put(COL_ACT_CUS_CD               , PARSEINFO_A211); //수요가코드 미정의 코드    	    
  		}
  		
        //수요가코드를 고객사코드 Master Code 체크
	  		if(ActivityUtil.isValidData(act_cus_cd))
	  		{
	  			Object bind_result = null;
	  			PosRowSet	rowset6	=	ctx.getRowSet(bind_result);
	  			//PosRow		row6		=	DbCommonUtil.rowOf(rowset6);
	  			
	  			PosGenericDao	dao	=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
	  			String 			colValue[] 			= 	null;//컬럼값
	  			PosParameter param = new PosParameter(); //MD View param
	  			
	  			colValue 		= new String[2];
	  			colValue[0] = (String)ctx.get(COL_ACT_CUS_CD); //수요가코드	  
	  	      			
	  			//PosRowSet	rowset = null;


	  	          param = new PosParameter();  //MD View param
	  	          param.setWhereClauseParameter( 0, colValue[0] );


	  	          
	  		        try{
	  		        	//결과값 잘 가져오는지 확인
	  		        	rowset6 = dao.find( ACT_CUS_CD_SELECT , param );	//Master Code View.select			
	  		        }catch(Exception e){
	  		        	rowset6 = null;
	  					logger.logError(e.getMessage());
	  					setError(ctx	, logger , ERRMSG_A21
	  						    , ERRCD_A93
	  							, new String[]{ord_req_no, ord_req_ln, ERRCD_A21} , ERRMSG_CF68);//MS002007
	  					//return PosBizControlConstants.FAILURE; 
	  		        }
	  		        if ( rowset6.count() == 1 )
	  		        {
	  		            //row6 = rowset6.next();
	  		        }
	  		        else if(rowset6.count() > 1){
	  					setError(ctx	, logger , ERRMSG_A212 
	  						    , ERRCD_A93
	  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A212} , ERRMSG_CF68);//MS002007
	  					//return PosBizControlConstants.FAILURE; 	
	  			    }
	  		        else{
	  					setError(ctx	, logger , ERRMSG_A211 
	  						    , ERRCD_A93
	  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A211} , ERRMSG_CF68);//MS002007

	  					//return PosBizControlConstants.FAILURE; 	
	  			    }							
	  			    //codeChkMap.put(COL_ACT_CUS_CD               , PARSEINFO_A211); //수요가코드 미정의 코드    	    
	  		}
	  		
	  	  //최종수요가코드를 고객사코드 Master Code 체크
	  		if(ActivityUtil.isValidData(fnl_cus_cd))
	  		{
	  			Object bind_result = null;
	  			PosRowSet	rowset7	=	ctx.getRowSet(bind_result);
	  			//PosRow		row7		=	DbCommonUtil.rowOf(rowset7);
	  			
	  			PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
	  			String 			colValue[] 			= 	null;//컬럼값
	  			PosParameter param = new PosParameter(); //MD View param
	  			
	  			colValue 		= new String[2];
	  			colValue[0] = (String)ctx.get(COL_FNL_CUS_CD); //수요가코드	  
	  	      			
	  			//PosRowSet	rowset = null;


	  	          param = new PosParameter();  //MD View param
	  	          param.setWhereClauseParameter( 0, colValue[0] );


	  	          
	  		        try{
	  		        	//결과값 잘 가져오는지 확인
	  		        	rowset7 = dao.find( FNL_CUS_CD_SELECT , param );	//Master Code View.select			
	  		        }catch(Exception e){
	  		        	rowset7 = null;
	  					logger.logError(e.getMessage());
	  					setError(ctx	, logger , ERRMSG_A22
	  						    , ERRCD_A93
	  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A22} , ERRMSG_CF68);//MS002007
	  					//return PosBizControlConstants.FAILURE; 
	  		        }
	  		        if ( rowset7.count() == 1 )
	  		        {
	  		            //row7 = rowset7.next();
	  		        }
	  		        else if(rowset7.count() > 1){
	  					setError(ctx	, logger , ERRMSG_A222
	  						    , ERRCD_A93
	  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A222} , ERRMSG_CF68);//MS002007
	  					//return PosBizControlConstants.FAILURE; 	
	  			    }
	  		        else{
	  					setError(ctx	, logger , ERRMSG_A221 
	  						    , ERRCD_A93
	  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A221} , ERRMSG_CF68);//MS002007

	  					//return PosBizControlConstants.FAILURE; 	
	  			    }							
	  			    //codeChkMap.put(COL_FNL_CUS_CD               , PARSEINFO_A221); //최종수요가코드 미정의 코드     	    
	  		} 
	         

	    
	    //제품형태별 주문포장방법코드 카테고리 정합성 체크
		if((ActivityUtil.isValidData(ord_pak_mth))&&(ActivityUtil.isValidData(prd_shp)))
		{
			Object bind_result = null;
			PosRowSet	rowset4	=	ctx.getRowSet(bind_result);
			//PosRow		row4		=	DbCommonUtil.rowOf(rowset4);
			
			PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
			String 			colValue[] 			= 	null;//컬럼값
			PosParameter param = new PosParameter(); //MD View param
			
			colValue 		= new String[2];
			colValue[0] = (String)ctx.get(COL_ORD_PAK_MTH); //주문포장방법
			colValue[1] = (String)ctx.get(COL_PRD_SHP);  //제품형태		  
	      			
			//PosRowSet	rowset = null;


	          param = new PosParameter();  //MD View param
	          param.setWhereClauseParameter( 0, colValue[1] );
	          param.setWhereClauseParameter( 0, colValue[0] );


	          
		        try{
		        	//결과값 잘 가져오는지 확인
		        	rowset4 = dao.find( ORD_PAK_MTH_SELECT, param );	//Master Code View.select			
		        }catch(Exception e){
		        	rowset4 = null;
					logger.logError(e.getMessage());
					setError(ctx	, logger , ERRMSG_A65
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A65} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 
		        }
		        if ( rowset4.count() == 1 )
		        {
		            //row4 = rowset4.next();
		        }
		        else if(rowset4.count() > 1){
					setError(ctx	, logger , ERRMSG_A652
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A652} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 	
			    }
		        else{
					setError(ctx	, logger , ERRMSG_A651
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A651} , ERRMSG_CF68);//MS002007

					//return PosBizControlConstants.FAILURE; 	
			    }							
			    //codeChkMap.put(COL_ORD_PAK_MTH              , PARSEINFO_A651); //주문포장방법 미정의 코드   	    
		}

	    

	    //품명별 주문Spangle구분코드 정합성 체크
		if((ActivityUtil.isValidData(ord_spnl_tp))&& (ActivityUtil.isValidData(prd_nm_cd)))
		{
			Object bind_result = null;
			PosRowSet	rowset5	=	ctx.getRowSet(bind_result);
			//PosRow		row5		=	DbCommonUtil.rowOf(rowset5);
			
			PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
			String 			colValue[] 			= 	null;//컬럼값
			PosParameter param = new PosParameter(); //MD View param
			
			colValue 		= new String[2];
			colValue[0] = (String)ctx.get(COL_ORD_SPNL_TP); //주문Spangle구분
			colValue[1] = (String)ctx.get(COL_PRD_NM_CD);  //품명		  
	      			
			//PosRowSet	rowset = null;


	          param = new PosParameter();  //MD View param
	          param.setWhereClauseParameter( 0, colValue[1] );
	          param.setWhereClauseParameter( 0, colValue[0] );


	          
		        try{
		        	//결과값 잘 가져오는지 확인
		        	rowset5 = dao.find( ORD_SPNL_TP_SELECT, param );	//Master Code View.select			
		        }catch(Exception e){
		        	rowset5 = null;
					logger.logError(e.getMessage());
					setError(ctx	, logger , ERRMSG_A72
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A72} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 
		        }
		        if ( rowset5.count() == 1 )
		        {
		            //row5 = rowset5.next();
		        }
		        else if(rowset5.count() > 1){
					setError(ctx	, logger , COL_ORD_SPNL_TP+ C10STR_COMMA + ERRMSG_A721
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A721} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 	
			    }
		        else{
					setError(ctx	, logger , COL_ORD_SPNL_TP+ C10STR_COMMA + ERRMSG_A72
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A72} , ERRMSG_CF68);//MS002007

					//return PosBizControlConstants.FAILURE; 	
			    }							
	    //codeChkMap.put(COL_ORD_SPNL_TP              , PARSEINFO_A721); //주문Spangle구분 미정의 코드        	           	
        }
		


        
	    //품명별 도금량지정 코드 정합성 체크
		if((ActivityUtil.isValidData(gw_asg_cd))&& (ActivityUtil.isValidData(prd_nm_cd)))
		{
			Object bind_result = null;
			PosRowSet	rowset3	=	ctx.getRowSet(bind_result);
			//PosRow		row3		=	DbCommonUtil.rowOf(rowset3);
			
			PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
			String 			colValue[] 			= 	null;//컬럼값
			PosParameter param = new PosParameter(); //MD View param
			
			colValue 		= new String[2];
			colValue[0] = (String)ctx.get(COL_GW_ASG_CD); //도금량지금코드
			colValue[1] = (String)ctx.get(COL_PRD_NM_CD);  //품명		  
	      			
			//PosRowSet	rowset = null;


	          param = new PosParameter();  //MD View param
	          param.setWhereClauseParameter( 0, colValue[1] );
	          param.setWhereClauseParameter( 0, colValue[0] );


	          
		        try{
		        	//결과값 잘 가져오는지 확인
		        	rowset3 = dao.find( GW_ASG_CD_SELECT, param );	//Master Code View.select			
		        }catch(Exception e){
		        	rowset3 = null;
					logger.logError(e.getMessage());
					setError(ctx	, logger , ERRMSG_A61
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A61} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 
		        }
		        if ( rowset3.count() == 1 )
		        {
		            //row3 = rowset3.next();
		        }
		        else if(rowset3.count() > 1){
					setError(ctx	, logger , ERRMSG_A611 
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A611} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE; 	
			    }
		        else{
					setError(ctx	, logger , ERRMSG_A61
						    , ERRCD_A93
								, new String[]{ord_req_no, ord_req_ln, ERRCD_A61} , ERRMSG_CF68);//MS002007

					//return PosBizControlConstants.FAILURE; 	
			    }							
	    //codeChkMap.put(COL_GW_ASG_CD                , PARSEINFO_A611); //도금량지정코드 미정의 코드          	    
		}		                       
       
		
		if(!codeChk(ctx, codeChkMap)){
			info	= true;
		}
		
		return info;
	}
	/**
	 * 생산가부요청 정보에 대해 마스터 데이터에서 오류정보를 점검하는 메소드이다.
	 * 
	 * @param context  PosContext
	 * @return Boolean 판별 결과 
	 */
	public Boolean ordMasterChk(PosContext context){
		
		
		PosContext ctx  = context;
//		PosRow	row		= posRow;
		
        ArrayList<Double> ord_mix_wth = new ArrayList<Double>(); //주문조합폭 최소값	
        double ord_slit_grp_cnt = 0;
        //double mix_wth = 0;  향후사용        
		
		String 		flow_chl                = C10STR_SPACE;
		String 		ord_knd                 = C10STR_SPACE;
		String 		act_cus_cd              = C10STR_SPACE;
		String 		fnl_cus_cd              = C10STR_SPACE;
	    String      spc_avr                 = C10STR_SPACE;
	    String      spc_yr                  = C10STR_SPACE;
	    String      ord_sz                  = C10STR_SPACE;
	    String      ord_exc_thk             = C10STR_SPACE;
	    String      ord_exc_wth             = C10STR_SPACE;
	    String      ord_sur_hnd_cd          = C10STR_SPACE;
	    String      ord_edg_asg_tp          = C10STR_SPACE;
	    String      wgt_dcs_mth_tp          = C10STR_SPACE;
	    String      ord_wgt_unt             = C10STR_SPACE;
	    String      ord_ln_wgt              = C10STR_SPACE;
	    String      ord_stdp_llv            = C10STR_SPACE;
	    String      ord_stdp_ulv            = C10STR_SPACE;
	    String      ord_pak_unt_wgt         = C10STR_SPACE;
	    String      ord_sml_pak_wgt         = C10STR_SPACE;
	    String      ord_unt_wgt             = C10STR_SPACE;
	    String      ord_pak_mth             = C10STR_SPACE;
	    String      ord_thk_mng_cd          = C10STR_SPACE;
	    String      ord_wth_mng_cd          = C10STR_SPACE;
	    String      nat_cd                  = C10STR_SPACE;
	    String      ord_rgs_prs_id          = C10STR_SPACE;
	    String      ord_tem_cd              = C10STR_SPACE;	
		String		ord_coilg_mth           = C10STR_SPACE;
		String		ord_slv_knd_tp          = C10STR_SPACE;
		String		ord_exc_lth             = C10STR_SPACE;
		String		ord_lth_mng_cd          = C10STR_SPACE;
		String		ord_sht_lod_mth         = C10STR_SPACE;
		String		ord_rou_cd              = C10STR_SPACE;
		String		ord_skp_deg             = C10STR_SPACE;
	    String      gw_asg_cd               = C10STR_SPACE;
	    String      ord_thk_tp              = C10STR_SPACE;
	    String      ord_spnl_tp             = C10STR_SPACE;
	    String      ccl_bom_no              = C10STR_SPACE;
	    String      embs_cd                 = C10STR_SPACE;
	    String      ord_ptt_flm_cd          = C10STR_SPACE;
	    String      ord_ptt_flm_wth         = C10STR_SPACE;
	    String      ord_ptt_flm_adh_loc_cd  = C10STR_SPACE;
		String 		cus_cd                  = C10STR_SPACE;
		String		ord_usg_cd              = C10STR_SPACE;
		String		prd_nm_cd               = C10STR_SPACE;
		String		prd_shp                 = C10STR_SPACE;
		String		ord_coil_idia           = C10STR_SPACE;
		String		ord_pak_lth_llv         = C10STR_SPACE;
		String		ord_pak_lth_ulv         = C10STR_SPACE;
		String		ord_coil_odia           = C10STR_SPACE;
		String		ord_sht_cnt             = C10STR_SPACE;
		String		ord_pak_sht_cnt         = C10STR_SPACE;
		String		ord_stdp_cnt_llv        = C10STR_SPACE;
		String		ord_stdp_cnt_ulv        = C10STR_SPACE;
		String		ord_org_plt_spc_avr     = C10STR_SPACE;
	    String      cus_bth_pap_no          = C10STR_SPACE;
	    String      cus_req_clr_nm          = C10STR_SPACE;
	    String      cus_req_dlv_dd          = C10STR_SPACE;
	    String      hue_cd_bak              = C10STR_SPACE;
	    String      hue_cd_frn              = C10STR_SPACE;
	    String      ord_dlv_alw_dif_llv     = C10STR_SPACE;
	    String      ord_dlv_alw_dif_ulv     = C10STR_SPACE;
	    String      ord_lth_tln_llv         = C10STR_SPACE;
	    String      ord_lth_tln_ulv         = C10STR_SPACE;
        String		ord_mix_wth1            = C10STR_SPACE;
	    String      ord_mix_wth2            = C10STR_SPACE;
	    String      ord_mix_wth3            = C10STR_SPACE;
	    String      ord_mix_wth4            = C10STR_SPACE;
	    String      ord_mix_wth5            = C10STR_SPACE;
	    String      ord_mix_wth6            = C10STR_SPACE;
	    String      ord_mix_wth7            = C10STR_SPACE;
	    String      ord_mix_wth8            = C10STR_SPACE;
	    String      ord_mix_wth9            = C10STR_SPACE;
	    String      ord_mix_wth10            = C10STR_SPACE;	    
	    String      ord_pak_unt_wgt_llv     = C10STR_SPACE;
	    String      ord_pak_unt_wgt_ulv     = C10STR_SPACE;
	    String      ord_rcp_dd              = C10STR_SPACE;
	    //String      ord_slit_grp_cnt        = C10STR_SPACE;
	    String      ord_sml_pak_mir         = C10STR_SPACE;
	    String      ord_thk_tln_llv         = C10STR_SPACE;
	    String      ord_thk_tln_ulv         = C10STR_SPACE;
	    String      ord_wth_tln_llv         = C10STR_SPACE;
	    String      ord_wth_tln_ulv         = C10STR_SPACE;
	    String      plnt_tp                 = C10STR_SPACE;
	    String      slit_max_wgt            = C10STR_SPACE;
	    String      tag_tp                  = C10STR_SPACE;
	    String      trst_proc_yn            = C10STR_SPACE;	    
	    String      pak_msg_cd              = C10STR_SPACE;  //항목추가 8/17
	    String      ccl_bom_hue_cd_frn      = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_bak      = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_sub      = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_frn_1cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_frn_2cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_frn_3cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_frn_4cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_bak_1cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_bak_2cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_bak_3cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크
	    String      ccl_bom_hue_cd_bak_4cot = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크    
	    String      ccl_bom_hue_cd_lmn       = C10STR_SPACE;  //항목추가 20160620 CCL BOM 칼라코드 체크    
	    int          ccl_bom_clr_use_n_cnt     = 0;  //항목추가 20160620 CCL BOM 칼라코드 체크    


		

		if (!DbCommonUtil.isNull(ctx.get(COL_FLOW_CHL)))
		     flow_chl                = ctx.get(COL_FLOW_CHL).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_KND)))		                     
		     ord_knd                 = ctx.get(COL_ORD_KND).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_ACT_CUS_CD)))		                      
		     act_cus_cd              = ctx.get(COL_ACT_CUS_CD).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_FNL_CUS_CD)))		                   
		     fnl_cus_cd              = ctx.get(COL_FNL_CUS_CD).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_SPC_AVR)))		                   
	         spc_avr                 = ctx.get(COL_SPC_AVR).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_SPC_YR)))                 	                        
	         spc_yr                  = ctx.get(COL_SPC_YR).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SZ)))	                         
	         ord_sz                  = ctx.get(COL_ORD_SZ).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_EXC_THK)))	                         
	         ord_exc_thk             = ctx.get(COL_ORD_EXC_THK).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_EXC_WTH)))	                    
	         ord_exc_wth             = ctx.get(COL_ORD_EXC_WTH).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SUR_HND_CD)))	                    
		     ord_sur_hnd_cd          = ctx.get(COL_ORD_SUR_HND_CD).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_EDG_ASG_TP)))	                 
		     ord_edg_asg_tp          = ctx.get(COL_ORD_EDG_ASG_TP).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_WGT_DCS_MTH_TP)))	                 
		     wgt_dcs_mth_tp          = ctx.get(COL_WGT_DCS_MTH_TP).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_WGT_UNT)))	                
		     ord_wgt_unt             = ctx.get(COL_ORD_WGT_UNT).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_LN_WGT)))	                   
		     ord_ln_wgt              = ctx.get(COL_ORD_LN_WGT).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_STDP_LLV)))	                     
		     ord_stdp_llv            = ctx.get(COL_ORD_STDP_LLV).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_STDP_ULV)))	                   
		     ord_stdp_ulv            = ctx.get(COL_ORD_STDP_ULV).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_UNT_WGT)))	                   
		     ord_pak_unt_wgt         = ctx.get(COL_ORD_PAK_UNT_WGT).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SML_PAK_WGT)))	               
		     ord_sml_pak_wgt         = ctx.get(COL_ORD_SML_PAK_WGT).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_UNT_WGT)))	                
		     ord_unt_wgt             = ctx.get(COL_ORD_UNT_WGT).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_MTH)))	                   
		     ord_pak_mth             = ctx.get(COL_ORD_PAK_MTH).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_THK_MNG_CD)))	                   
		     ord_thk_mng_cd          = ctx.get(COL_ORD_THK_MNG_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_WTH_MNG_CD)))	                
		     ord_wth_mng_cd          = ctx.get(COL_ORD_WTH_MNG_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_NAT_CD))) 	                
		     nat_cd                  = ctx.get(COL_NAT_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_RGS_PRS_ID))) 	                        
		     ord_rgs_prs_id          = ctx.get(COL_ORD_RGS_PRS_ID).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_TEM_CD)))	                 
		     ord_tem_cd              = ctx.get(COL_ORD_TEM_CD).toString();
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_COILG_MTH)))	                     
		     ord_coilg_mth           = ctx.get(COL_ORD_COILG_MTH).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SLV_KND_TP)))		               
			 ord_slv_knd_tp          = ctx.get(COL_ORD_SLV_KND_TP).toString(); 
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_EXC_LTH)))		              
			 ord_exc_lth             = ctx.get(COL_ORD_EXC_LTH).toString(); 
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_LTH_MNG_CD)))		                 
			 ord_lth_mng_cd          = ctx.get(COL_ORD_LTH_MNG_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SHT_LOD_MTH)))		              
			 ord_sht_lod_mth         = ctx.get(COL_ORD_SHT_LOD_MTH).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_ROU_CD)))		             
			 ord_rou_cd              = ctx.get(COL_ORD_ROU_CD).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SKP_DEG)))		                   
			 ord_skp_deg             = ctx.get(COL_ORD_SKP_DEG).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_GW_ASG_CD))) 		                  
			 gw_asg_cd               = ctx.get(COL_GW_ASG_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_THK_TP)))	                     
			 ord_thk_tp              = ctx.get(COL_ORD_THK_TP).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SPNL_TP)))	                    
			 ord_spnl_tp             = ctx.get(COL_ORD_SPNL_TP).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_CCL_BOM_NO)))	                   
			 ccl_bom_no              = ctx.get(COL_CCL_BOM_NO).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_EMBS_CD)))   	                    
			 embs_cd                 = ctx.get(COL_EMBS_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PTT_FLM_CD)))	                       
			 ord_ptt_flm_cd          = ctx.get(COL_ORD_PTT_FLM_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PTT_FLM_WTH))) 	                
			 ord_ptt_flm_wth         = ctx.get(COL_ORD_PTT_FLM_WTH).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PTT_FLM_ADH_LOC_CD)))	               
			 ord_ptt_flm_adh_loc_cd  = ctx.get(COL_ORD_PTT_FLM_ADH_LOC_CD).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_CUS_CD))) 	         
		     cus_cd                  = ctx.get(COL_CUS_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_USG_CD))) 		                      
		     ord_usg_cd              = ctx.get(COL_ORD_USG_CD).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_PRD_NM_CD))) 		                   
			 prd_nm_cd               = ctx.get(COL_PRD_NM_CD).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_PRD_SHP))) 		                   
		     prd_shp                 = ctx.get(COL_PRD_SHP).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_COIL_IDIA))) 		                     
		     ord_coil_idia           = ctx.get(COL_ORD_COIL_IDIA).toString(); 
	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_LTH_LLV)))		               
		     ord_pak_lth_llv         = ctx.get(COL_ORD_PAK_LTH_LLV).toString();
   	    if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_LTH_ULV))) 		              
		     ord_pak_lth_ulv         = ctx.get(COL_ORD_PAK_LTH_ULV).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_COIL_ODIA)))		             
		     ord_coil_odia           = ctx.get(COL_ORD_COIL_ODIA).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SHT_CNT)))		               
		     ord_sht_cnt             = ctx.get(COL_ORD_SHT_CNT).toString();
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_SHT_CNT)))		                  
		     ord_pak_sht_cnt         = ctx.get(COL_ORD_PAK_SHT_CNT).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_STDP_CNT_LLV)))		             
		     ord_stdp_cnt_llv        = ctx.get(COL_ORD_STDP_CNT_LLV).toString();  
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_STDP_CNT_ULV))) 		           
		     ord_stdp_cnt_ulv        = ctx.get(COL_ORD_STDP_CNT_ULV).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_ORG_PLT_SPC_AVR))) 		            
		     ord_org_plt_spc_avr     = ctx.get(COL_ORD_ORG_PLT_SPC_AVR).toString(); 
		
		if (!DbCommonUtil.isNull(ctx.get(COL_CUS_BTH_PAP_NO)))            
		     cus_bth_pap_no          = ctx.get(COL_CUS_BTH_PAP_NO).toString();      
		if (!DbCommonUtil.isNull(ctx.get(COL_CUS_REQ_CLR_NM)))            
		     cus_req_clr_nm          = ctx.get(COL_CUS_REQ_CLR_NM).toString();      
		if (!DbCommonUtil.isNull(ctx.get(COL_CUS_REQ_DLV_DD)))            
		     cus_req_dlv_dd          = ctx.get(COL_CUS_REQ_DLV_DD).toString();      
		if (!DbCommonUtil.isNull(ctx.get(COL_HUE_CD_BAK)))                
		    hue_cd_bak               = ctx.get(COL_HUE_CD_BAK).toString();          
		if (!DbCommonUtil.isNull(ctx.get(COL_HUE_CD_FRN)))                
		    hue_cd_frn               = ctx.get(COL_HUE_CD_FRN).toString();          
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_DLV_ALW_DIF_LLV)))       
		    ord_dlv_alw_dif_llv      = ctx.get(COL_ORD_DLV_ALW_DIF_LLV).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_DLV_ALW_DIF_ULV)))       
		    ord_dlv_alw_dif_ulv      = ctx.get(COL_ORD_DLV_ALW_DIF_ULV).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_LTH_TLN_LLV)))           
		    ord_lth_tln_llv          = ctx.get(COL_ORD_LTH_TLN_LLV).toString();     
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_LTH_TLN_ULV)))           
		    ord_lth_tln_ulv          = ctx.get(COL_ORD_LTH_TLN_ULV).toString();     
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH1))) 
        {
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH1 ).toString() ) );
		    ord_mix_wth1             = ctx.get(COL_ORD_MIX_WTH1).toString();        
        }			
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH2)))
		{
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH2 ).toString() ) );			
		    ord_mix_wth2             = ctx.get(COL_ORD_MIX_WTH2).toString();
		}
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH3)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH3 ).toString() ) );			
		    ord_mix_wth3             = ctx.get(COL_ORD_MIX_WTH3).toString();
		}    
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH4)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH4 ).toString() ) );			
		    ord_mix_wth4             = ctx.get(COL_ORD_MIX_WTH4).toString();
		}
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH5)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH5 ).toString() ) );			
		    ord_mix_wth5             = ctx.get(COL_ORD_MIX_WTH5).toString();
		}    
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH6)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH6 ).toString() ) );			
		    ord_mix_wth6             = ctx.get(COL_ORD_MIX_WTH6).toString();
		}
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH7)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH7 ).toString() ) );			
		    ord_mix_wth7             = ctx.get(COL_ORD_MIX_WTH7).toString();
		}
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH8)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH8 ).toString() ) );			
		    ord_mix_wth8             = ctx.get(COL_ORD_MIX_WTH8).toString();
		}
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH9)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH9 ).toString() ) );			
		    ord_mix_wth9             = ctx.get(COL_ORD_MIX_WTH9).toString();
		}
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_MIX_WTH10)))
		{	
            ord_mix_wth.add( Double.parseDouble( ctx.get( COL_ORD_MIX_WTH10 ).toString() ) );			
		    ord_mix_wth10             = ctx.get(COL_ORD_MIX_WTH10).toString();
		}		
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_UNT_WGT_LLV)))       
		    ord_pak_unt_wgt_llv      = ctx.get(COL_ORD_PAK_UNT_WGT_LLV).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_PAK_UNT_WGT_ULV)))       
		    ord_pak_unt_wgt_ulv      = ctx.get(COL_ORD_PAK_UNT_WGT_ULV).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_RCP_DD)))                
		    ord_rcp_dd               = ctx.get(COL_ORD_RCP_DD).toString();          
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SLIT_GRP_CNT)))
            ord_slit_grp_cnt = Double.parseDouble( ctx.get( COL_ORD_SLIT_GRP_CNT ).toString() );			
		    //ord_slit_grp_cnt         = ctx.get(COL_ORD_SLIT_GRP_CNT).toString();    
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_SML_PAK_MIR)))           
		    ord_sml_pak_mir          = ctx.get(COL_ORD_SML_PAK_MIR).toString();     
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_THK_TLN_LLV)))           
		    ord_thk_tln_llv          = ctx.get(COL_ORD_THK_TLN_LLV).toString();     
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_THK_TLN_ULV)))           
		    ord_thk_tln_ulv          = ctx.get(COL_ORD_THK_TLN_ULV).toString();     
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_WTH_TLN_LLV)))           
		    ord_wth_tln_llv          = ctx.get(COL_ORD_WTH_TLN_LLV).toString();     
		if (!DbCommonUtil.isNull(ctx.get(COL_ORD_WTH_TLN_ULV)))           
		    ord_wth_tln_ulv          = ctx.get(COL_ORD_WTH_TLN_ULV).toString();     
		if (!DbCommonUtil.isNull(ctx.get(COL_PLNT_TP)))                   
		    plnt_tp                  = ctx.get(COL_PLNT_TP).toString();             
		if (!DbCommonUtil.isNull(ctx.get(COL_SLIT_MAX_WGT)))              
		    slit_max_wgt             = ctx.get(COL_SLIT_MAX_WGT).toString();        
		if (!DbCommonUtil.isNull(ctx.get(COL_TAG_TP)))                    
		    tag_tp                   = ctx.get(COL_TAG_TP).toString();              
		if (!DbCommonUtil.isNull(ctx.get(COL_TRST_PROC_YN)))              
		    trst_proc_yn             = ctx.get(COL_TRST_PROC_YN).toString(); 
		if (!DbCommonUtil.isNull(ctx.get(COL_PAK_MSG_CD)))              
		    pak_msg_cd               = ctx.get(COL_PAK_MSG_CD).toString(); 	
		   

//각 항모별 판단기준 체크 셋팅
		//주문요청번호  
		String[]	key1	= new String[20];
		key1[0]	  = COL_ORD_REQ_NO;
		key1[1]   = ord_req_no;
		key1[2]	  = prd_nm_cd;           //품명
		key1[3]	  = prd_shp;             //제품형태
		key1[4]   = ord_slv_knd_tp;      //주문내경링종류구분
		key1[5]	  = ord_wth_mng_cd;      //주문폭관리코드
		key1[6]	  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key1[7]   = ord_ptt_flm_cd;       //주문보호필름상세코드
		//key1[8]   = embs_cd;              //EMBOSS무늬
		key1[8]   = ord_usg_cd;           //주문용도코드
		key1[9]   = ord_edg_asg_tp;       //주문Edge지정구분
		key1[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key1[11]  = gw_asg_cd;            //도금량지정코드
		key1[12]  = ord_spnl_tp;          //주문Spangle구분
		key1[13]  = ord_exc_thk;          //주문환산두께
		key1[14]  = ord_exc_wth;          //주문환산폭			
		key1[15]  = ord_pak_mth;          //주문포장방법
		key1[16]  = pak_msg_cd;           //포장메세지코드
		key1[17]  = ord_thk_mng_cd;       //두께관리코드
		key1[18]  = ord_knd;              //주문종류
		key1[19]  = fnl_cus_cd;           //최종수요가코드		
		
	//주문요청행번  
		String[]	key2	= new String[20];
		key2[0]	  = COL_ORD_REQ_LN;
		key2[1]   = ord_req_ln;
		key2[2]	  = prd_nm_cd;            //품명
		key2[3]	  = prd_shp;              //제품형태
		key2[4]   = ord_slv_knd_tp;       //주문내경링종류구분
		key2[5]	  = ord_wth_mng_cd;       //주문폭관리코드
		key2[6]	  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key2[7]   = ord_ptt_flm_cd;       //주문보호필름상세코드
		//key2[8]   = embs_cd;              //EMBOSS무늬
		key2[8]   = ord_usg_cd;           //주문용도코드
		key2[9]   = ord_edg_asg_tp;       //주문Edge지정구분
		key2[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key2[11]  = gw_asg_cd;            //도금량지정코드
		key2[12]  = ord_spnl_tp;          //주문Spangle구분
		key2[13]  = ord_exc_thk;          //주문환산두께
		key2[14]  = ord_exc_wth;          //주문환산폭			
		key2[15]  = ord_pak_mth;          //주문포장방법
		key2[16]  = pak_msg_cd;           //포장메세지코드
		key2[17]  = ord_thk_mng_cd;       //두께관리코드
		key2[18]  = ord_knd;              //주문종류
		key2[19]  = fnl_cus_cd;           //최종수요가코드				
		
	//품명  
		String[]	key3	= new String[20];
		key3[0]	  = COL_PRD_NM_CD;
		key3[1]   = prd_nm_cd;
		key3[2]	  = prd_nm_cd;            //품명
		key3[3]	  = prd_shp;              //제품형태
		key3[4]   = ord_slv_knd_tp;       //주문내경링종류구분
		key3[5]	  = ord_wth_mng_cd;       //주문폭관리코드
		key3[6]	  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key3[7]   = ord_ptt_flm_cd;       //주문보호필름상세코드
		//key3[8]   = embs_cd;              //EMBOSS무늬
		key3[8]   = ord_usg_cd;           //주문용도코드
		key3[9]   = ord_edg_asg_tp;       //주문Edge지정구분
		key3[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key3[11]  = gw_asg_cd;            //도금량지정코드
		key3[12]  = ord_spnl_tp;          //주문Spangle구분
		key3[13]  = ord_exc_thk;          //주문환산두께
		key3[14]  = ord_exc_wth;          //주문환산폭			
		key3[15]  = ord_pak_mth;          //주문포장방법
		key3[16]  = pak_msg_cd;           //포장메세지코드
		key3[17]  = ord_thk_mng_cd;       //두께관리코드
		key3[18]  = ord_knd;              //주문종류
		key3[19]  = fnl_cus_cd;           //최종수요가코드				

	//제품형태  
		String[]	key4	= new String[20];
		key4[0]	= COL_PRD_SHP;
		key4[1] = prd_shp;
		key4[2]	= prd_nm_cd;             //품명
		key4[3]	= prd_shp;               //제품형태
		key4[4] = ord_slv_knd_tp;        //주문내경링종류구분
		key4[5]	= ord_wth_mng_cd;        //주문폭관리코드
		key4[6]	= Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key4[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key4[8]  = embs_cd;               //EMBOSS무늬
		key4[8]   = ord_usg_cd;           //주문용도코드
		key4[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key4[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key4[11]  = gw_asg_cd;            //도금량지정코드
		key4[12]  = ord_spnl_tp;          //주문Spangle구분
		key4[13]  = ord_exc_thk;          //주문환산두께
		key4[14]  = ord_exc_wth;          //주문환산폭			
		key4[15]  = ord_pak_mth;          //주문포장방법
		key4[16]  = pak_msg_cd;           //포장메세지코드
		key4[17]  = ord_thk_mng_cd;       //두께관리코드
		key4[18]  = ord_knd;              //주문종류
		key4[19]  = fnl_cus_cd;           //최종수요가코드				

	//유통경로  
		String[]	key5	= new String[20];
		key5[0]	= COL_FLOW_CHL;
		key5[1] = flow_chl;
		key5[2]	= prd_nm_cd;              //품명
		key5[3]	= prd_shp;                //제품형태
		key5[4] = ord_slv_knd_tp;         //주문내경링종류구분
		key5[5]	= ord_wth_mng_cd;         //주문폭관리코드
		key5[6]	= Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key5[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key5[8]  = embs_cd;               //EMBOSS무늬
		key5[8]   = ord_usg_cd;           //주문용도코드
		key5[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key5[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key5[11]  = gw_asg_cd;            //도금량지정코드
		key5[12]  = ord_spnl_tp;          //주문Spangle구분
		key5[13]  = ord_exc_thk;          //주문환산두께
		key5[14]  = ord_exc_wth;          //주문환산폭			
		key5[15]  = ord_pak_mth;          //주문포장방법
		key5[16]  = pak_msg_cd;           //포장메세지코드
		key5[17]  = ord_thk_mng_cd;       //두께관리코드
		key5[18]  = ord_knd;              //주문종류
		key5[19]  = fnl_cus_cd;           //최종수요가코드				
		
	//주문종류  
		String[]	key6	= new String[20];
		key6[0]	= COL_ORD_KND;
		key6[1] = ord_knd;
		key6[2]	= prd_nm_cd;              //품명
		key6[3]	= prd_shp;                //제품형태
		key6[4] = ord_slv_knd_tp;         //주문내경링종류구분
		key6[5]	= ord_wth_mng_cd;         //주문폭관리코드
		key6[6]	= Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key6[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key6[8]  = embs_cd;               //EMBOSS무늬
		key6[8]   = ord_usg_cd;           //주문용도코드
		key6[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key6[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key6[11]  = gw_asg_cd;            //도금량지정코드
		key6[12]  = ord_spnl_tp;          //주문Spangle구분
		key6[13]  = ord_exc_thk;          //주문환산두께
		key6[14]  = ord_exc_wth;          //주문환산폭			
		key6[15]  = ord_pak_mth;          //주문포장방법
		key6[16]  = pak_msg_cd;           //포장메세지코드
		key6[17]  = ord_thk_mng_cd;       //두께관리코드
		key6[18]  = ord_knd;              //주문종류
		key6[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문용도코드  
		String[]	key7	= new String[20];
		key7[0]	= COL_ORD_USG_CD;
		key7[1] = ord_usg_cd;
		key7[2]	= prd_nm_cd;              //품명
		key7[3]	= prd_shp;                //제품형태
		key7[4] = ord_slv_knd_tp;         //주문내경링종류구분
		key7[5]	= ord_wth_mng_cd;         //주문폭관리코드
		key7[6]	= Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key7[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key7[8]  = embs_cd;               //EMBOSS무늬
		key7[8]   = ord_usg_cd;           //주문용도코드
		key7[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key7[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key7[11]  = gw_asg_cd;            //도금량지정코드
		key7[12]  = ord_spnl_tp;          //주문Spangle구분
		key7[13]  = ord_exc_thk;          //주문환산두께
		key7[14]  = ord_exc_wth;          //주문환산폭			
		key7[15]  = ord_pak_mth;          //주문포장방법
		key7[16]  = pak_msg_cd;           //포장메세지코드
		key7[17]  = ord_thk_mng_cd;       //두께관리코드
		key7[18]  = ord_knd;              //주문종류
		key7[19]  = fnl_cus_cd;           //최종수요가코드				

	//고객사코드  
		String[]	key8	= new String[20];
		key8[0]	= COL_CUS_CD;
		key8[1] = cus_cd;
		key8[2]	= prd_nm_cd;              //품명
		key8[3]	= prd_shp;                //제품형태
		key8[4] = ord_slv_knd_tp;         //주문내경링종류구분
		key8[5]	= ord_wth_mng_cd;         //주문폭관리코드
		key8[6]	= Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key8[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key8[8]  = embs_cd;               //EMBOSS무늬
		key8[8]   = ord_usg_cd;           //주문용도코드
		key8[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key8[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key8[11]  = gw_asg_cd;            //도금량지정코드
		key8[12]  = ord_spnl_tp;          //주문Spangle구분
		key8[13]  = ord_exc_thk;          //주문환산두께
		key8[14]  = ord_exc_wth;          //주문환산폭			
		key8[15]  = ord_pak_mth;          //주문포장방법
		key8[16]  = pak_msg_cd;           //포장메세지코드
		key8[17]  = ord_thk_mng_cd;       //두께관리코드
		key8[18]  = ord_knd;              //주문종류
		key8[19]  = fnl_cus_cd;           //최종수요가코드	
		

	//수요가코드  
		String[]	key9	= new String[20];
		key9[0]	= COL_ACT_CUS_CD;
		key9[1] = act_cus_cd;
		key9[2]	= prd_nm_cd;              //품명
		key9[3]	= prd_shp;                //제품형태
		key9[4] = ord_slv_knd_tp;         //주문내경링종류구분
		key9[5]	= ord_wth_mng_cd;         //주문폭관리코드
		key9[6]	= Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key9[7] = ord_ptt_flm_cd;         //주문보호필름상세코드
		//key9[8]  = embs_cd;               //EMBOSS무늬
		key9[8] = ord_usg_cd;           //주문용도코드
		key9[9] = ord_edg_asg_tp;        //주문Edge지정구분
		key9[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key9[11]  = gw_asg_cd;            //도금량지정코드
		key9[12]  = ord_spnl_tp;          //주문Spangle구분
		key9[13]  = ord_exc_thk;          //주문환산두께
		key9[14]  = ord_exc_wth;          //주문환산폭			
		key9[15]  = ord_pak_mth;          //주문포장방법
		key9[16]  = pak_msg_cd;           //포장메세지코드
		key9[17]  = ord_thk_mng_cd;       //두께관리코드
		key9[18]  = ord_knd;              //주문종류
		key9[19]  = fnl_cus_cd;           //최종수요가코드				

	//최종수요가코드  
		String[]	key10	= new String[20];
		key10[0]  =	COL_FNL_CUS_CD;
		key10[1]  = fnl_cus_cd;
		key10[2]  =	prd_nm_cd;             //품명
		key10[3]  = prd_shp;               //제품형태
		key10[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key10[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key10[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key10[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key10[8]  = embs_cd;               //EMBOSS무늬
		key10[8] = ord_usg_cd;           //주문용도코드
		key10[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key10[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key10[11]  = gw_asg_cd;            //도금량지정코드
		key10[12]  = ord_spnl_tp;          //주문Spangle구분
		key10[13]  = ord_exc_thk;          //주문환산두께
		key10[14]  = ord_exc_wth;          //주문환산폭			
		key10[15]  = ord_pak_mth;          //주문포장방법
		key10[16]  = pak_msg_cd;           //포장메세지코드
		key10[17]  = ord_thk_mng_cd;       //두께관리코드
		key10[18]  = ord_knd;              //주문종류
		key10[19]  = fnl_cus_cd;           //최종수요가코드				

	//규격약호  
		String[]	key11	= new String[20];
		key11[0]  =	COL_SPC_AVR;
		key11[1]  = spc_avr;
		key11[2]  =	prd_nm_cd;             //품명
		key11[3]  = prd_shp;               //제품형태
		key11[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key11[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key11[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key11[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key11[8]  = embs_cd;               //EMBOSS무늬
		key11[8] = ord_usg_cd;           //주문용도코드
		key11[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key11[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key11[11]  = gw_asg_cd;            //도금량지정코드
		key11[12]  = ord_spnl_tp;          //주문Spangle구분
		key11[13]  = ord_exc_thk;          //주문환산두께
		key11[14]  = ord_exc_wth;          //주문환산폭			
		key11[15]  = ord_pak_mth;          //주문포장방법
		key11[16]  = pak_msg_cd;           //포장메세지코드
		key11[17]  = ord_thk_mng_cd;       //두께관리코드
		key11[18]  = ord_knd;              //주문종류
		key11[19]  = fnl_cus_cd;           //최종수요가코드			

	//규격년도  
		String[]	key12	= new String[20];
		key12[0]  =	COL_SPC_YR;
		key12[1]  = spc_yr;
		key12[2]  =	prd_nm_cd;             //품명
		key12[3]  = prd_shp;               //제품형태
		key12[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key12[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key12[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key12[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key12[8]  = embs_cd;               //EMBOSS무늬
		key12[8] = ord_usg_cd;           //주문용도코드
		key12[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key12[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key12[11]  = gw_asg_cd;            //도금량지정코드
		key12[12]  = ord_spnl_tp;          //주문Spangle구분
		key12[13]  = ord_exc_thk;          //주문환산두께
		key12[14]  = ord_exc_wth;          //주문환산폭			
		key12[15]  = ord_pak_mth;          //주문포장방법
		key12[16]  = pak_msg_cd;           //포장메세지코드
		key12[17]  = ord_thk_mng_cd;       //두께관리코드
		key12[18]  = ord_knd;              //주문종류
		key12[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문생칫수 
		String[]	key13	= new String[20];
		key13[0]  =	COL_ORD_SZ;
		key13[1]  = ord_sz;
		key13[2]  =	prd_nm_cd;             //품명
		key13[3]  = prd_shp;               //제품형태
		key13[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key13[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key13[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key13[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key13[8]  = embs_cd;               //EMBOSS무늬
		key13[8] = ord_usg_cd;           //주문용도코드
		key13[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key13[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key13[11]  = gw_asg_cd;            //도금량지정코드
		key13[12]  = ord_spnl_tp;          //주문Spangle구분
		key13[13]  = ord_exc_thk;          //주문환산두께
		key13[14]  = ord_exc_wth;          //주문환산폭			
		key13[15]  = ord_pak_mth;          //주문포장방법
		key13[16]  = pak_msg_cd;           //포장메세지코드
		key13[17]  = ord_thk_mng_cd;       //두께관리코드
		key13[18]  = ord_knd;              //주문종류
		key13[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문환산두께 
		String[]	key14	= new String[20];
		key14[0]  =	COL_ORD_EXC_THK;
		key14[1]  = ord_exc_thk;
		key14[2]  =	prd_nm_cd;             //품명
		key14[3]  = prd_shp;               //제품형태
		key14[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key14[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key14[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key14[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key14[8]  = embs_cd;               //EMBOSS무늬
		key14[8] = ord_usg_cd;           //주문용도코드
		key14[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key14[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key14[11]  = gw_asg_cd;            //도금량지정코드
		key14[12]  = ord_spnl_tp;          //주문Spangle구분
		key14[13]  = ord_exc_thk;          //주문환산두께
		key14[14]  = ord_exc_wth;          //주문환산폭			
		key14[15]  = ord_pak_mth;          //주문포장방법
		key14[16]  = pak_msg_cd;           //포장메세지코드
		key14[17]  = ord_thk_mng_cd;       //두께관리코드
		key14[18]  = ord_knd;              //주문종류
		key14[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문환산폭 
		String[]	key15	= new String[20];
		key15[0]  =	COL_ORD_EXC_WTH;
		key15[1]  = ord_exc_wth;
		key15[2]  =	prd_nm_cd;             //품명
		key15[3]  = prd_shp;               //제품형태
		key15[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key15[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key15[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key15[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key15[8]  = embs_cd;               //EMBOSS무늬
		key15[8] = ord_usg_cd;           //주문용도코드
		key15[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key15[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key15[11]  = gw_asg_cd;            //도금량지정코드
		key15[12]  = ord_spnl_tp;          //주문Spangle구분
		key15[13]  = ord_exc_thk;          //주문환산두께
		key15[14]  = ord_exc_wth;          //주문환산폭			
		key15[15]  = ord_pak_mth;          //주문포장방법
		key15[16]  = pak_msg_cd;           //포장메세지코드
		key15[17]  = ord_thk_mng_cd;       //두께관리코드
		key15[18]  = ord_knd;              //주문종류
		key15[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문표면처리코드 
		String[]	key16	= new String[20];
		key16[0]  =	COL_ORD_SUR_HND_CD;
		key16[1]  = ord_sur_hnd_cd;
		key16[2]  =	prd_nm_cd;             //품명
		key16[3]  = prd_shp;               //제품형태
		key16[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key16[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key16[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key16[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key16[8]  = embs_cd;               //EMBOSS무늬
		key16[8] = ord_usg_cd;           //주문용도코드
		key16[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key16[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key16[11]  = gw_asg_cd;            //도금량지정코드
		key16[12]  = ord_spnl_tp;          //주문Spangle구분
		key16[13]  = ord_exc_thk;          //주문환산두께
		key16[14]  = ord_exc_wth;          //주문환산폭			
		key16[15]  = ord_pak_mth;          //주문포장방법
		key16[16]  = pak_msg_cd;           //포장메세지코드
		key16[17]  = ord_thk_mng_cd;       //두께관리코드
		key16[18]  = ord_knd;              //주문종류
		key16[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문Edge지정구분 
		String[]	key17	= new String[20];
		key17[0]  =	COL_ORD_EDG_ASG_TP;
		key17[1]  = ord_edg_asg_tp;
		key17[2]  =	prd_nm_cd;            //품명
		key17[3]  = prd_shp;              //제품형태
		key17[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key17[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key17[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key17[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key17[8]  = embs_cd;               //EMBOSS무늬
		key17[8] = ord_usg_cd;           //주문용도코드
		key17[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key17[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key17[11]  = gw_asg_cd;            //도금량지정코드
		key17[12]  = ord_spnl_tp;          //주문Spangle구분
		key17[13]  = ord_exc_thk;          //주문환산두께
		key17[14]  = ord_exc_wth;          //주문환산폭			
		key17[15]  = ord_pak_mth;          //주문포장방법
		key17[16]  = pak_msg_cd;           //포장메세지코드
		key17[17]  = ord_thk_mng_cd;       //두께관리코드
		key17[18]  = ord_knd;              //주문종류
		key17[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문두께구분 
		String[]	key18	= new String[20];
		key18[0]  =	COL_ORD_THK_TP;
		key18[1]  = ord_thk_tp;
		key18[2]  =	prd_nm_cd;             //품명
		key18[3]  = prd_shp;               //제품형태
		key18[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key18[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key18[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key18[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key18[8]  = embs_cd;               //EMBOSS무늬
		key18[8] = ord_usg_cd;           //주문용도코드
		key18[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key18[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key18[11]  = gw_asg_cd;            //도금량지정코드
		key18[12]  = ord_spnl_tp;          //주문Spangle구분
		key18[13]  = ord_exc_thk;          //주문환산두께
		key18[14]  = ord_exc_wth;          //주문환산폭			
		key18[15]  = ord_pak_mth;          //주문포장방법
		key18[16]  = pak_msg_cd;           //포장메세지코드
		key18[17]  = ord_thk_mng_cd;       //두께관리코드
		key18[18]  = ord_knd;              //주문종류
		key18[19]  = fnl_cus_cd;           //최종수요가코드			

	//중량결정법구분 
		String[]	key19	= new String[20];
		key19[0]  =	COL_WGT_DCS_MTH_TP;
		key19[1]  = wgt_dcs_mth_tp;
		key19[2]  =	prd_nm_cd;             //품명
		key19[3]  = prd_shp;               //제품형태
		key19[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key19[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key19[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key19[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key19[8]  = embs_cd;               //EMBOSS무늬
		key19[8] = ord_usg_cd;           //주문용도코드
		key19[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key19[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key19[11]  = gw_asg_cd;            //도금량지정코드
		key19[12]  = ord_spnl_tp;          //주문Spangle구분
		key19[13]  = ord_exc_thk;          //주문환산두께
		key19[14]  = ord_exc_wth;          //주문환산폭			
		key19[15]  = ord_pak_mth;          //주문포장방법
		key19[16]  = pak_msg_cd;           //포장메세지코드
		key19[17]  = ord_thk_mng_cd;       //두께관리코드
		key19[18]  = ord_knd;              //주문종류
		key19[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문중량단위 
		String[]	key20	= new String[20];
		key20[0]  =	COL_ORD_WGT_UNT;
		key20[1]  = ord_wgt_unt;
		key20[2]  =	prd_nm_cd;             //품명
		key20[3]  = prd_shp;               //제품형태
		key20[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key20[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key20[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key20[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key20[8]  = embs_cd;               //EMBOSS무늬
		key20[8] = ord_usg_cd;           //주문용도코드
		key20[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key20[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key20[11]  = gw_asg_cd;            //도금량지정코드
		key20[12]  = ord_spnl_tp;          //주문Spangle구분
		key20[13]  = ord_exc_thk;          //주문환산두께
		key20[14]  = ord_exc_wth;          //주문환산폭			
		key20[15]  = ord_pak_mth;          //주문포장방법
		key20[16]  = pak_msg_cd;           //포장메세지코드
		key20[17]  = ord_thk_mng_cd;       //두께관리코드
		key20[18]  = ord_knd;              //주문종류
		key20[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문행번중량 
		String[]	key21	= new String[20];
		key21[0]  =	COL_ORD_LN_WGT;
		key21[1]  = ord_ln_wgt;
		key21[2]  =	prd_nm_cd;             //품명
		key21[3]  = prd_shp;               //제품형태
		key21[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key21[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key21[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key21[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key21[8]  = embs_cd;               //EMBOSS무늬
		key21[8] = ord_usg_cd;           //주문용도코드
		key21[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key21[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key21[11]  = gw_asg_cd;            //도금량지정코드
		key21[12]  = ord_spnl_tp;          //주문Spangle구분
		key21[13]  = ord_exc_thk;          //주문환산두께
		key21[14]  = ord_exc_wth;          //주문환산폭			
		key21[15]  = ord_pak_mth;          //주문포장방법
		key21[16]  = pak_msg_cd;           //포장메세지코드
		key21[17]  = ord_thk_mng_cd;       //두께관리코드
		key21[18]  = ord_knd;              //주문종류
		key21[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문정포장하한값 
		String[]	key22	= new String[20];
		key22[0]  =	COL_ORD_STDP_LLV;
		key22[1]  = ord_stdp_llv;
		key22[2]  =	prd_nm_cd;             //품명
		key22[3]  = prd_shp;               //제품형태
		key22[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key22[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key22[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key22[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key22[8]  = embs_cd;               //EMBOSS무늬
		key22[8] = ord_usg_cd;           //주문용도코드
		key22[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key22[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key22[11]  = gw_asg_cd;            //도금량지정코드
		key22[12]  = ord_spnl_tp;          //주문Spangle구분
		key22[13]  = ord_exc_thk;          //주문환산두께
		key22[14]  = ord_exc_wth;          //주문환산폭			
		key22[15]  = ord_pak_mth;          //주문포장방법
		key22[16]  = pak_msg_cd;           //포장메세지코드
		key22[17]  = ord_thk_mng_cd;       //두께관리코드
		key22[18]  = ord_knd;              //주문종류
		key22[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문정포장상한값 
		String[]	key23	= new String[20];
		key23[0]  =	COL_ORD_STDP_ULV;
		key23[1]  = ord_stdp_ulv;
		key23[2]  =	prd_nm_cd;             //품명
		key23[3]  = prd_shp;               //제품형태
		key23[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key23[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key23[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key23[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key23[8]  = embs_cd;               //EMBOSS무늬
		key23[8] = ord_usg_cd;           //주문용도코드
		key23[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key23[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key23[11]  = gw_asg_cd;            //도금량지정코드
		key23[12]  = ord_spnl_tp;          //주문Spangle구분
		key23[13]  = ord_exc_thk;          //주문환산두께
		key23[14]  = ord_exc_wth;          //주문환산폭			
		key23[15]  = ord_pak_mth;          //주문포장방법
		key23[16]  = pak_msg_cd;           //포장메세지코드
		key23[17]  = ord_thk_mng_cd;       //두께관리코드
		key23[18]  = ord_knd;              //주문종류
		key23[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문포장당중량 
		String[]	key24	= new String[20];
		key24[0]  =	COL_ORD_PAK_UNT_WGT;
		key24[1]  = ord_pak_unt_wgt;
		key24[2]  =	prd_nm_cd;             //품명
		key24[3]  = prd_shp;               //제품형태
		key24[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key24[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key24[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key24[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key24[8]  = embs_cd;               //EMBOSS무늬
		key24[8] = ord_usg_cd;           //주문용도코드
		key24[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key24[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key24[11]  = gw_asg_cd;            //도금량지정코드
		key24[12]  = ord_spnl_tp;          //주문Spangle구분
		key24[13]  = ord_exc_thk;          //주문환산두께
		key24[14]  = ord_exc_wth;          //주문환산폭			
		key24[15]  = ord_pak_mth;          //주문포장방법
		key24[16]  = pak_msg_cd;           //포장메세지코드
		key24[17]  = ord_thk_mng_cd;       //두께관리코드
		key24[18]  = ord_knd;              //주문종류
		key24[19]  = fnl_cus_cd;           //최종수요가코드		

	//주문소포장중량 
		String[]	key25	= new String[20];
		key25[0]  =	COL_ORD_SML_PAK_WGT;
		key25[1]  = ord_sml_pak_wgt;
		key25[2]  =	prd_nm_cd;             //품명
		key25[3]  = prd_shp;               //제품형태
		key25[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key25[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key25[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key25[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key25[8]  = embs_cd;               //EMBOSS무늬
		key25[8] = ord_usg_cd;           //주문용도코드
		key25[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key25[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key25[11]  = gw_asg_cd;            //도금량지정코드
		key25[12]  = ord_spnl_tp;          //주문Spangle구분
		key25[13]  = ord_exc_thk;          //주문환산두께
		key25[14]  = ord_exc_wth;          //주문환산폭			
		key25[15]  = ord_pak_mth;          //주문포장방법
		key25[16]  = pak_msg_cd;           //포장메세지코드
		key25[17]  = ord_thk_mng_cd;       //두께관리코드
		key25[18]  = ord_knd;              //주문종류
		key25[19]  = fnl_cus_cd;           //최종수요가코드		

	//주문단위중량 
		String[]	key26	= new String[20];
		key26[0]  =	COL_ORD_UNT_WGT;
		key26[1]  = ord_unt_wgt;
		key26[2]  =	prd_nm_cd;             //품명
		key26[3]  = prd_shp;               //제품형태
		key26[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key26[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key26[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key26[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key26[8]  = embs_cd;               //EMBOSS무늬
		key26[8] = ord_usg_cd;           //주문용도코드
		key26[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key26[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key26[11]  = gw_asg_cd;            //도금량지정코드
		key26[12]  = ord_spnl_tp;          //주문Spangle구분
		key26[13]  = ord_exc_thk;          //주문환산두께
		key26[14]  = ord_exc_wth;          //주문환산폭			
		key26[15]  = ord_pak_mth;          //주문포장방법
		key26[16]  = pak_msg_cd;           //포장메세지코드
		key26[17]  = ord_thk_mng_cd;       //두께관리코드
		key26[18]  = ord_knd;              //주문종류
		key26[19]  = fnl_cus_cd;           //최종수요가코드		

	//ORD_PAK_MTH 
		String[]	key27	= new String[20];
		key27[0]  =	COL_ORD_PAK_MTH;
		key27[1]  = ord_pak_mth;
		key27[2]  =	prd_nm_cd;             //품명
		key27[3]  = prd_shp;               //제품형태
		key27[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key27[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key27[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key27[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key27[8]  = embs_cd;               //EMBOSS무늬
		key27[8] = ord_usg_cd;           //주문용도코드
		key27[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key27[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key27[11]  = gw_asg_cd;            //도금량지정코드
		key27[12]  = ord_spnl_tp;          //주문Spangle구분
		key27[13]  = ord_exc_thk;          //주문환산두께
		key27[14]  = ord_exc_wth;          //주문환산폭			
		key27[15]  = ord_pak_mth;          //주문포장방법
		key27[16]  = pak_msg_cd;           //포장메세지코드
		key27[17]  = ord_thk_mng_cd;       //두께관리코드
		key27[18]  = ord_knd;              //주문종류
		key27[19]  = fnl_cus_cd;           //최종수요가코드		

	//주문두께관리코드 
		String[]	key28	= new String[20];
		key28[0]  =	COL_ORD_THK_MNG_CD;
		key28[1]  = ord_thk_mng_cd;
		key28[2]  =	prd_nm_cd;             //품명
		key28[3]  = prd_shp;               //제품형태
		key28[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key28[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key28[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key28[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key28[8]  = embs_cd;               //EMBOSS무늬
		key28[8] = ord_usg_cd;           //주문용도코드
		key28[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key28[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key28[11]  = gw_asg_cd;            //도금량지정코드
		key28[12]  = ord_spnl_tp;          //주문Spangle구분
		key28[13]  = ord_exc_thk;          //주문환산두께
		key28[14]  = ord_exc_wth;          //주문환산폭			
		key28[15]  = ord_pak_mth;          //주문포장방법
		key28[16]  = pak_msg_cd;           //포장메세지코드
		key28[17]  = ord_thk_mng_cd;       //두께관리코드
		key28[18]  = ord_knd;              //주문종류
		key28[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문폭관리코드 
		String[]	key29	= new String[20];
		key29[0]  =	COL_ORD_WTH_MNG_CD;
		key29[1]  = ord_wth_mng_cd;
		key29[2]  =	prd_nm_cd;             //품명
		key29[3]  = prd_shp;               //제품형태
		key29[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key29[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key29[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key29[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key29[8]  = embs_cd;               //EMBOSS무늬
		key29[8] = ord_usg_cd;           //주문용도코드
		key29[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key29[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key29[11]  = gw_asg_cd;            //도금량지정코드
		key29[12]  = ord_spnl_tp;          //주문Spangle구분
		key29[13]  = ord_exc_thk;          //주문환산두께
		key29[14]  = ord_exc_wth;          //주문환산폭			
		key29[15]  = ord_pak_mth;          //주문포장방법
		key29[16]  = pak_msg_cd;           //포장메세지코드
		key29[17]  = ord_thk_mng_cd;       //두께관리코드
		key29[18]  = ord_knd;              //주문종류
		key29[19]  = fnl_cus_cd;           //최종수요가코드		

	//국가코드 
		String[]	key30	= new String[20];
		key30[0]  =	COL_NAT_CD;
		key30[1]  = nat_cd;
		key30[2]  =	prd_nm_cd;             //품명
		key30[3]  = prd_shp;               //제품형태
		key30[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key30[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key30[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key30[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key30[8]  = embs_cd;               //EMBOSS무늬
		key30[8] = ord_usg_cd;           //주문용도코드
		key30[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key30[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key30[11]  = gw_asg_cd;            //도금량지정코드
		key30[12]  = ord_spnl_tp;          //주문Spangle구분
		key30[13]  = ord_exc_thk;          //주문환산두께
		key30[14]  = ord_exc_wth;          //주문환산폭			
		key30[15]  = ord_pak_mth;          //주문포장방법
		key30[16]  = pak_msg_cd;           //포장메세지코드
		key30[17]  = ord_thk_mng_cd;       //두께관리코드
		key30[18]  = ord_knd;              //주문종류
		key30[19]  = fnl_cus_cd;           //최종수요가코드		

	//주문등록자 
		String[]	key31	= new String[20];
		key31[0]  =	COL_ORD_RGS_PRS_ID;
		key31[1]  = ord_rgs_prs_id;
		key31[2]  =	prd_nm_cd;             //품명
		key31[3]  = prd_shp;               //제품형태
		key31[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key31[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key31[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key31[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key31[8]  = embs_cd;               //EMBOSS무늬
		key31[8] = ord_usg_cd;           //주문용도코드
		key31[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key31[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key31[11]  = gw_asg_cd;            //도금량지정코드
		key31[12]  = ord_spnl_tp;          //주문Spangle구분
		key31[13]  = ord_exc_thk;          //주문환산두께
		key31[14]  = ord_exc_wth;          //주문환산폭			
		key31[15]  = ord_pak_mth;          //주문포장방법
		key31[16]  = pak_msg_cd;           //포장메세지코드
		key31[17]  = ord_thk_mng_cd;       //두께관리코드
		key31[18]  = ord_knd;              //주문종류
		key31[19]  = fnl_cus_cd;           //최종수요가코드			

	//영업팀코드 
		String[]	key32	= new String[20];
		key32[0]  =	COL_ORD_TEM_CD;
		key32[1]  = ord_tem_cd;
		key32[2]  =	prd_nm_cd;            //품명
		key32[3]  = prd_shp;              //제품형태
		key32[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key32[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key32[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key32[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		key32[8] = ord_usg_cd;           //주문용도코드
		//key32[8]  = embs_cd;               //EMBOSS무늬
		key32[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key32[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key32[11]  = gw_asg_cd;            //도금량지정코드
		key32[12]  = ord_spnl_tp;          //주문Spangle구분
		key32[13]  = ord_exc_thk;          //주문환산두께
		key32[14]  = ord_exc_wth;          //주문환산폭			
		key32[15]  = ord_pak_mth;          //주문포장방법
		key32[16]  = pak_msg_cd;           //포장메세지코드
		key32[17]  = ord_thk_mng_cd;       //두께관리코드
		key32[18]  = ord_knd;              //주문종류
		key32[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문내경링종류구분  
		String[]	key33	= new String[20];
		key33[0]  =	COL_ORD_SLV_KND_TP;
		key33[1]  = ord_slv_knd_tp;
		key33[2]  =	prd_nm_cd;            //품명
		key33[3]  = prd_shp;              //제품형태
		key33[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key33[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key33[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key33[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key33[8]  = embs_cd;               //EMBOSS무늬
		key33[8] = ord_usg_cd;           //주문용도코드
		key33[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key33[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key33[11]  = gw_asg_cd;            //도금량지정코드
		key33[12]  = ord_spnl_tp;          //주문Spangle구분
		key33[13]  = ord_exc_thk;          //주문환산두께
		key33[14]  = ord_exc_wth;          //주문환산폭			
		key33[15]  = ord_pak_mth;          //주문포장방법
		key33[16]  = pak_msg_cd;           //포장메세지코드
		key33[17]  = ord_thk_mng_cd;       //두께관리코드
		key33[18]  = ord_knd;              //주문종류
		key33[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문포장길이하한값
		String[]	key34	= new String[20];
		key34[0]  =	COL_ORD_PAK_LTH_LLV;
		key34[1]  = ord_pak_lth_llv;
		key34[2]  =	prd_nm_cd;             //품명
		key34[3]  = prd_shp;               //제품형태
		key34[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key34[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key34[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key34[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key34[8]  = embs_cd;               //EMBOSS무늬
		key34[8] = ord_usg_cd;           //주문용도코드
		key34[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key34[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key34[11]  = gw_asg_cd;            //도금량지정코드
		key34[12]  = ord_spnl_tp;          //주문Spangle구분
		key34[13]  = ord_exc_thk;          //주문환산두께
		key34[14]  = ord_exc_wth;          //주문환산폭			
		key34[15]  = ord_pak_mth;          //주문포장방법
		key34[16]  = pak_msg_cd;           //포장메세지코드
		key34[17]  = ord_thk_mng_cd;       //두께관리코드
		key34[18]  = ord_knd;              //주문종류
		key34[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문포장길이상한값
		String[]	key35	= new String[20];
		key35[0]  =	COL_ORD_PAK_LTH_ULV;
		key35[1]  = ord_pak_lth_ulv;
		key35[2]  =	prd_nm_cd;            //품명
		key35[3]  = prd_shp;              //제품형태
		key35[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key35[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key35[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key35[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key35[8]  = embs_cd;               //EMBOSS무늬
		key35[8] = ord_usg_cd;           //주문용도코드
		key35[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key35[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key35[11]  = gw_asg_cd;            //도금량지정코드
		key35[12]  = ord_spnl_tp;          //주문Spangle구분
		key35[13]  = ord_exc_thk;          //주문환산두께
		key35[14]  = ord_exc_wth;          //주문환산폭			
		key35[15]  = ord_pak_mth;          //주문포장방법
		key35[16]  = pak_msg_cd;           //포장메세지코드
		key35[17]  = ord_thk_mng_cd;       //두께관리코드
		key35[18]  = ord_knd;              //주문종류
		key35[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문코일내경
		String[]	key36	= new String[20];
		key36[0]  =	COL_ORD_COIL_IDIA;
		key36[1]  = ord_coil_idia;
		key36[2]  =	prd_nm_cd;             //품명
		key36[3]  = prd_shp;               //제품형태
		key36[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key36[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key36[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key36[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key36[8]  = embs_cd;               //EMBOSS무늬
		key36[8] = ord_usg_cd;           //주문용도코드
		key36[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key36[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key36[11]  = gw_asg_cd;            //도금량지정코드
		key36[12]  = ord_spnl_tp;          //주문Spangle구분
		key36[13]  = ord_exc_thk;          //주문환산두께
		key36[14]  = ord_exc_wth;          //주문환산폭			
		key36[15]  = ord_pak_mth;          //주문포장방법
		key36[16]  = pak_msg_cd;           //포장메세지코드
		key36[17]  = ord_thk_mng_cd;       //두께관리코드
		key36[18]  = ord_knd;              //주문종류
		key36[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문코일외경
		String[]	key37	= new String[20];
		key37[0]  =	COL_ORD_COIL_ODIA;
		key37[1]  = ord_coil_odia;
		key37[2]  =	prd_nm_cd;             //품명
		key37[3]  = prd_shp;               //제품형태
		key37[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key37[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key37[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key37[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key37[8]  = embs_cd;               //EMBOSS무늬
		key37[8] = ord_usg_cd;           //주문용도코드
		key37[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key37[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key37[11]  = gw_asg_cd;            //도금량지정코드
		key37[12]  = ord_spnl_tp;          //주문Spangle구분
		key37[13]  = ord_exc_thk;          //주문환산두께
		key37[14]  = ord_exc_wth;          //주문환산폭			
		key37[15]  = ord_pak_mth;          //주문포장방법
		key37[16]  = pak_msg_cd;           //포장메세지코드
		key37[17]  = ord_thk_mng_cd;       //두께관리코드
		key37[18]  = ord_knd;              //주문종류
		key37[19]  = fnl_cus_cd;           //최종수요가코드		

    //주문권취방법  
		String[]	key38	= new String[20];
		key38[0]  =	COL_ORD_COILG_MTH;
		key38[1]  =	ord_coilg_mth;
		key38[2]  =	prd_nm_cd;            //품명
		key38[3]  = prd_shp;              //제품형태
		key38[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key38[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key38[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key38[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key38[8]  = embs_cd;               //EMBOSS무늬
		key38[8] = ord_usg_cd;           //주문용도코드
		key38[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key38[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key38[11]  = gw_asg_cd;            //도금량지정코드
		key38[12]  = ord_spnl_tp;          //주문Spangle구분
		key38[13]  = ord_exc_thk;          //주문환산두께
		key38[14]  = ord_exc_wth;          //주문환산폭			
		key38[15]  = ord_pak_mth;          //주문포장방법
		key38[16]  = pak_msg_cd;           //포장메세지코드
		key38[17]  = ord_thk_mng_cd;       //두께관리코드
		key38[18]  = ord_knd;              //주문종류
		key38[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문환산길이
		String[]	key39	= new String[20];
		key39[0]  =	COL_ORD_EXC_LTH;
		key39[1]  =	ord_exc_lth;
		key39[2]  =	prd_nm_cd;             //품명
		key39[3]  = prd_shp;               //제품형태
		key39[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key39[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key39[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key39[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key39[8]  = embs_cd;               //EMBOSS무늬
		key39[8] = ord_usg_cd;           //주문용도코드
		key39[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key39[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key39[11]  = gw_asg_cd;            //도금량지정코드
		key39[12]  = ord_spnl_tp;          //주문Spangle구분
		key39[13]  = ord_exc_thk;          //주문환산두께
		key39[14]  = ord_exc_wth;          //주문환산폭			
		key39[15]  = ord_pak_mth;          //주문포장방법
		key39[16]  = pak_msg_cd;           //포장메세지코드
		key39[17]  = ord_thk_mng_cd;       //두께관리코드
		key39[18]  = ord_knd;              //주문종류
		key39[19]  = fnl_cus_cd;           //최종수요가코드		

	//주문길이관리코드  
		String[]	key40	= new String[20];
		key40[0]  =	COL_ORD_LTH_MNG_CD;
		key40[1]  = ord_lth_mng_cd;
		key40[2]  =	prd_nm_cd;            //품명
		key40[3]  = prd_shp;              //제품형태
		key40[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key40[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key40[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key40[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key40[8]  = embs_cd;               //EMBOSS무늬
		key40[8] = ord_usg_cd;           //주문용도코드
		key40[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key40[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key40[11]  = gw_asg_cd;            //도금량지정코드
		key40[12]  = ord_spnl_tp;          //주문Spangle구분
		key40[13]  = ord_exc_thk;          //주문환산두께
		key40[14]  = ord_exc_wth;          //주문환산폭			
		key40[15]  = ord_pak_mth;          //주문포장방법
		key40[16]  = pak_msg_cd;           //포장메세지코드
		key40[17]  = ord_thk_mng_cd;       //두께관리코드
		key40[18]  = ord_knd;              //주문종류
		key40[19]  = fnl_cus_cd;           //최종수요가코드		
	
	//주문Sheet적재방법  
		String[]	key41	= new String[20];
		key41[0]  =	COL_ORD_SHT_LOD_MTH;
		key41[1]  = ord_sht_lod_mth;
		key41[2]  =	prd_nm_cd;            //품명
		key41[3]  = prd_shp;              //제품형태
		key41[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key41[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key41[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key41[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key41[8]  = embs_cd;               //EMBOSS무늬
		key41[8] = ord_usg_cd;           //주문용도코드
		key41[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key41[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key41[11]  = gw_asg_cd;            //도금량지정코드
		key41[12]  = ord_spnl_tp;          //주문Spangle구분
		key41[13]  = ord_exc_thk;          //주문환산두께
		key41[14]  = ord_exc_wth;          //주문환산폭			
		key41[15]  = ord_pak_mth;          //주문포장방법
		key41[16]  = pak_msg_cd;           //포장메세지코드
		key41[17]  = ord_thk_mng_cd;       //두께관리코드
		key41[18]  = ord_knd;              //주문종류
		key41[19]  = fnl_cus_cd;           //최종수요가코드		

	//주문Sheet매수
		String[]	key42	= new String[20];
		key42[0] =	COL_ORD_SHT_CNT;
		key42[1] = 	ord_sht_cnt;
		key42[2] =	prd_nm_cd;             //품명
		key42[3] =  prd_shp;               //제품형태
		key42[4] = ord_slv_knd_tp;         //주문내경링종류구분
		key42[5] = ord_wth_mng_cd;         //주문폭관리코드
		key42[6] = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key42[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key42[8]  = embs_cd;               //EMBOSS무늬
		key42[8] = ord_usg_cd;           //주문용도코드
		key42[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key42[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key42[11]  = gw_asg_cd;            //도금량지정코드
		key42[12]  = ord_spnl_tp;          //주문Spangle구분
		key42[13]  = ord_exc_thk;          //주문환산두께
		key42[14]  = ord_exc_wth;          //주문환산폭			
		key42[15]  = ord_pak_mth;          //주문포장방법
		key42[16]  = pak_msg_cd;           //포장메세지코드
		key42[17]  = ord_thk_mng_cd;       //두께관리코드
		key42[18]  = ord_knd;              //주문종류
		key42[19]  = fnl_cus_cd;           //최종수요가코드		

	//주문포장Sheet매수
		String[]	key43	= new String[20];
		key43[0] =	COL_ORD_PAK_SHT_CNT;
		key43[1] = 	ord_pak_sht_cnt;
		key43[2] =	prd_nm_cd;             //품명
		key43[3] =  prd_shp;               //제품형태
		key43[4] = ord_slv_knd_tp;         //주문내경링종류구분
		key43[5] = ord_wth_mng_cd;         //주문폭관리코드
		key43[6] = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key43[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key43[8]  = embs_cd;               //EMBOSS무늬
		key43[8] = ord_usg_cd;           //주문용도코드
		key43[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key43[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key43[11]  = gw_asg_cd;            //도금량지정코드
		key43[12]  = ord_spnl_tp;          //주문Spangle구분
		key43[13]  = ord_exc_thk;          //주문환산두께
		key43[14]  = ord_exc_wth;          //주문환산폭			
		key43[15]  = ord_pak_mth;          //주문포장방법
		key43[16]  = pak_msg_cd;           //포장메세지코드
		key43[17]  = ord_thk_mng_cd;       //두께관리코드
		key43[18]  = ord_knd;              //주문종류
		key43[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문정포장매수하한값
		String[]	key44	= new String[20];
		key44[0] =	COL_ORD_STDP_CNT_LLV;
		key44[1] = 	ord_stdp_cnt_llv;
		key44[2] =	prd_nm_cd;            //품명
		key44[3] =  prd_shp;              //제품형태
		key44[4] = ord_slv_knd_tp;        //주문내경링종류구분
		key44[5] = ord_wth_mng_cd;        //주문폭관리코드
		key44[6] = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key44[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key44[8]  = embs_cd;               //EMBOSS무늬
		key44[8] = ord_usg_cd;           //주문용도코드
		key44[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key44[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key44[11]  = gw_asg_cd;            //도금량지정코드
		key44[12]  = ord_spnl_tp;          //주문Spangle구분
		key44[13]  = ord_exc_thk;          //주문환산두께
		key44[14]  = ord_exc_wth;          //주문환산폭			
		key44[15]  = ord_pak_mth;          //주문포장방법
		key44[16]  = pak_msg_cd;           //포장메세지코드
		key44[17]  = ord_thk_mng_cd;       //두께관리코드
		key44[18]  = ord_knd;              //주문종류
		key44[19]  = fnl_cus_cd;           //최종수요가코드			
		
	//주문정포장매수상한값
		String[]	key45	= new String[20];
		key45[0] =	COL_ORD_STDP_CNT_ULV;
		key45[1] = 	ord_stdp_cnt_ulv;
		key45[2] =	prd_nm_cd;            //품명
		key45[3] =  prd_shp;              //제품형태
		key45[4] = ord_slv_knd_tp;        //주문내경링종류구분
		key45[5] = ord_wth_mng_cd;        //주문폭관리코드
		key45[6] = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key45[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key45[8]  = embs_cd;               //EMBOSS무늬
		key45[8] = ord_usg_cd;           //주문용도코드
		key45[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key45[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key45[11]  = gw_asg_cd;            //도금량지정코드
		key45[12]  = ord_spnl_tp;          //주문Spangle구분
		key45[13]  = ord_exc_thk;          //주문환산두께
		key45[14]  = ord_exc_wth;          //주문환산폭			
		key45[15]  = ord_pak_mth;          //주문포장방법
		key45[16]  = pak_msg_cd;           //포장메세지코드
		key45[17]  = ord_thk_mng_cd;       //두께관리코드
		key45[18]  = ord_knd;              //주문종류
		key45[19]  = fnl_cus_cd;           //최종수요가코드		
	
	//도금량지정코드  
		String[]	key46	= new String[20];
		key46[0] =	COL_GW_ASG_CD;
		key46[1] = 	gw_asg_cd;
		key46[2] =	prd_nm_cd;            //품명
		key46[3] =  prd_shp;              //제품형태
		key46[4] = ord_slv_knd_tp;        //주문내경링종류구분
		key46[5] = ord_wth_mng_cd;        //주문폭관리코드
		key46[6] = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key46[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key46[8]  = embs_cd;               //EMBOSS무늬
		key46[8] = ord_usg_cd;           //주문용도코드
		key46[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key46[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key46[11]  = gw_asg_cd;            //도금량지정코드
		key46[12]  = ord_spnl_tp;          //주문Spangle구분
		key46[13]  = ord_exc_thk;          //주문환산두께
		key46[14]  = ord_exc_wth;          //주문환산폭			
		key46[15]  = ord_pak_mth;          //주문포장방법
		key46[16]  = pak_msg_cd;           //포장메세지코드
		key46[17]  = ord_thk_mng_cd;       //두께관리코드
		key46[18]  = ord_knd;              //주문종류
		key46[19]  = fnl_cus_cd;           //최종수요가코드			
		
	//CCLBOM번호  
		String[]	key47	= new String[20];
		key47[0] =	COL_CCL_BOM_NO;
		key47[1] = 	ccl_bom_no;
		key47[2] =	prd_nm_cd;            //품명
		key47[3] =  prd_shp;              //제품형태	
		key47[4] = ord_slv_knd_tp;        //주문내경링종류구분
		key47[5] = ord_wth_mng_cd;        //주문폭관리코드
		key47[6] = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key47[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key47[8]  = embs_cd;               //EMBOSS무늬
		key47[8] = ord_usg_cd;           //주문용도코드
		key47[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key47[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key47[11]  = gw_asg_cd;            //도금량지정코드
		key47[12]  = ord_spnl_tp;          //주문Spangle구분
		key47[13]  = ord_exc_thk;          //주문환산두께
		key47[14]  = ord_exc_wth;          //주문환산폭			
		key47[15]  = ord_pak_mth;          //주문포장방법
		key47[16]  = pak_msg_cd;           //포장메세지코드
		key47[17]  = ord_thk_mng_cd;       //두께관리코드
		key47[18]  = ord_knd;              //주문종류
		key47[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문원판규격약호  
		String[]	key48	= new String[20];
		key48[0] =	COL_ORD_ORG_PLT_SPC_AVR;
		key48[1] = 	ord_org_plt_spc_avr;
		key48[2] =	prd_nm_cd;            //품명
		key48[3] =  prd_shp;              //제품형태
		key48[4] = ord_slv_knd_tp;        //주문내경링종류구분
		key48[5] = ord_wth_mng_cd;        //주문폭관리코드
		key48[6] = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key48[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key48[8]  = embs_cd;               //EMBOSS무늬
		key48[8] = ord_usg_cd;           //주문용도코드
		key48[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key48[10]  = ord_sur_hnd_cd;       //주문표면처리코드
		key48[11]  = gw_asg_cd;            //도금량지정코드
		key48[12]  = ord_spnl_tp;          //주문Spangle구분
		key48[13]  = ord_exc_thk;          //주문환산두께
		key48[14]  = ord_exc_wth;          //주문환산폭			
		key48[15]  = ord_pak_mth;          //주문포장방법
		key48[16]  = pak_msg_cd;           //포장메세지코드
		key48[17]  = ord_thk_mng_cd;       //두께관리코드
		key48[18]  = ord_knd;              //주문종류
		key48[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문조도코드  
		String[]	key49	= new String[20];
		key49[0]  =	COL_ORD_ROU_CD;
		key49[1]  = ord_rou_cd;
		key49[2]  =	prd_nm_cd;            //품명
		key49[3]  = prd_shp;              //제품형태
		key49[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key49[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key49[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key49[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key49[8]  = embs_cd;               //EMBOSS무늬
		key49[8] = ord_usg_cd;           //주문용도코드
		key49[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key49[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key49[11] = gw_asg_cd;             //도금량지정코드
		key49[12] = ord_spnl_tp;           //주문Spangle구분
		key49[13]  = ord_exc_thk;          //주문환산두께
		key49[14]  = ord_exc_wth;          //주문환산폭			
		key49[15]  = ord_pak_mth;          //주문포장방법
		key49[16]  = pak_msg_cd;           //포장메세지코드
		key49[17]  = ord_thk_mng_cd;       //두께관리코드
		key49[18]  = ord_knd;              //주문종류
		key49[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문Spangle구분 
		String[]	key50	= new String[20];
		key50[0]  =	COL_ORD_SPNL_TP;
		key50[1]  = ord_spnl_tp;
		key50[2]  =	prd_nm_cd;             //품명
		key50[3]  = prd_shp;               //제품형태
		key50[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key50[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key50[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key50[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key50[8]  = embs_cd;               //EMBOSS무늬
		key50[8] = ord_usg_cd;           //주문용도코드
		key50[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key50[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key50[11] = gw_asg_cd;             //도금량지정코드
		key50[12] = ord_spnl_tp;           //주문Spangle구분
		key50[13]  = ord_exc_thk;          //주문환산두께
		key50[14]  = ord_exc_wth;          //주문환산폭			
		key50[15]  = ord_pak_mth;          //주문포장방법
		key50[16]  = pak_msg_cd;           //포장메세지코드
		key50[17]  = ord_thk_mng_cd;       //두께관리코드
		key50[18]  = ord_knd;              //주문종류
		key50[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문조질도  
		String[]	key51	= new String[20];
		key51[0]  =	COL_ORD_SKP_DEG;
		key51[1]  = 	ord_skp_deg;
		key51[2]  =	prd_nm_cd;             //품명
		key51[3]  =  prd_shp;              //제품형태
		key51[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key51[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key51[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key51[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key51[8]  = embs_cd;               //EMBOSS무늬
		key51[8] = ord_usg_cd;           //주문용도코드
		key51[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key51[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key51[11] = gw_asg_cd;             //도금량지정코드
		key51[12] = ord_spnl_tp;           //주문Spangle구분
		key51[13]  = ord_exc_thk;          //주문환산두께
		key51[14]  = ord_exc_wth;          //주문환산폭			
		key51[15]  = ord_pak_mth;          //주문포장방법
		key51[16]  = pak_msg_cd;           //포장메세지코드
		key51[17]  = ord_thk_mng_cd;       //두께관리코드
		key51[18]  = ord_knd;              //주문종류
		key51[19]  = fnl_cus_cd;           //최종수요가코드				

	//주문두께구분 
		String[]	key52	= new String[20];
		key52[0]  =	COL_ORD_THK_TP;
		key52[1]  = ord_thk_tp;
		key52[2]  =	prd_nm_cd;             //품명
		key52[3]  = prd_shp;               //제품형태
		key52[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key52[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key52[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key52[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key52[8]  = embs_cd;               //EMBOSS무늬
		key52[8] = ord_usg_cd;           //주문용도코드
		key52[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key52[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key52[11] = gw_asg_cd;             //도금량지정코드
		key52[12] = ord_spnl_tp;           //주문Spangle구분
		key52[13]  = ord_exc_thk;          //주문환산두께
		key52[14]  = ord_exc_wth;          //주문환산폭			
		key52[15]  = ord_pak_mth;          //주문포장방법
		key52[16]  = pak_msg_cd;           //포장메세지코드
		key52[17]  = ord_thk_mng_cd;       //두께관리코드
		key52[18]  = ord_knd;              //주문종류
		key52[19]  = fnl_cus_cd;           //최종수요가코드			

	//EMBOSS무늬
		String[]	key53	= new String[20];
		key53[0]  =	COL_EMBS_CD;
		key53[1]  = embs_cd; 
		key53[2]  =	prd_nm_cd;            //품명
		key53[3]  = prd_shp;              //제품형태
		key53[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key53[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key53[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key53[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key53[8]  = embs_cd;               //EMBOSS무늬
		key53[8] = ord_usg_cd;           //주문용도코드
		key53[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key53[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key53[11] = gw_asg_cd;             //도금량지정코드
		key53[12] = ord_spnl_tp;           //주문Spangle구분
		key53[13]  = ord_exc_thk;          //주문환산두께
		key53[14]  = ord_exc_wth;          //주문환산폭			
		key53[15]  = ord_pak_mth;          //주문포장방법
		key53[16]  = pak_msg_cd;           //포장메세지코드
		key53[17]  = ord_thk_mng_cd;       //두께관리코드
		key53[18]  = ord_knd;              //주문종류
		key53[19]  = fnl_cus_cd;           //최종수요가코드			

    //주문보호필름상세코드 
		String[]	key54	= new String[20];
		key54[0]  =	COL_ORD_PTT_FLM_CD;
		key54[1]  = ord_ptt_flm_cd; //운영시 필드명 변경 요망 ORD_PTT_FLM_DTL_CD 
		key54[2]  =	prd_nm_cd;             //품명
		key54[3]  = prd_shp;               //제품형태
		key54[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key54[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key54[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key54[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key54[8]  = embs_cd;               //EMBOSS무늬
		key54[8] = ord_usg_cd;           //주문용도코드
		key54[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key54[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key54[11] = gw_asg_cd;             //도금량지정코드
		key54[12] = ord_spnl_tp;    	   //주문Spangle구분
		key54[13]  = ord_exc_thk;          //주문환산두께
		key54[14]  = ord_exc_wth;          //주문환산폭			
		key54[15]  = ord_pak_mth;          //주문포장방법
		key54[16]  = pak_msg_cd;           //포장메세지코드
		key54[17]  = ord_thk_mng_cd;       //두께관리코드
		key54[18]  = ord_knd;              //주문종류
		key54[19]  = fnl_cus_cd;           //최종수요가코드			

    //주문보호필름폭
		String[]	key55	= new String[20];
		key55[0]  =	COL_ORD_PTT_FLM_WTH;
		key55[1]  = ord_ptt_flm_wth;
		key55[2]  =	prd_nm_cd;            //품명
		key55[3]  = prd_shp;              //제품형태	
		key55[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key55[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key55[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key55[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key55[8]  = embs_cd;               //EMBOSS무늬
		key55[8] = ord_usg_cd;           //주문용도코드
		key55[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key55[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key55[11] = gw_asg_cd;             //도금량지정코드
		key55[12] = ord_spnl_tp;           //주문Spangle구분
		key55[13]  = ord_exc_thk;          //주문환산두께
		key55[14]  = ord_exc_wth;          //주문환산폭			
		key55[15]  = ord_pak_mth;          //주문포장방법
		key55[16]  = pak_msg_cd;           //포장메세지코드
		key55[17]  = ord_thk_mng_cd;       //두께관리코드
		key55[18]  = ord_knd;              //주문종류
		key55[19]  = fnl_cus_cd;           //최종수요가코드			
	
	//주문보호필름부착위치코드
		String[]	key56	= new String[20];
		key56[0]  =	COL_ORD_PTT_FLM_ADH_LOC_CD;
		key56[1]  = ord_ptt_flm_adh_loc_cd;
		key56[2]  =	prd_nm_cd;             //품명
		key56[3]  = prd_shp;               //제품형태
		key56[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key56[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key56[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key56[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key56[8]  = embs_cd;               //EMBOSS무늬
		key56[8] = ord_usg_cd;           //주문용도코드
		key56[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key56[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key56[11] = gw_asg_cd;             //도금량지정코드
		key56[12] = ord_spnl_tp;           //주문Spangle구분
		key56[13]  = ord_exc_thk;          //주문환산두께
		key56[14]  = ord_exc_wth;          //주문환산폭			
		key56[15]  = ord_pak_mth;          //주문포장방법
		key56[16]  = pak_msg_cd;           //포장메세지코드
		key56[17]  = ord_thk_mng_cd;       //두께관리코드
		key56[18]  = ord_knd;              //주문종류
		key56[19]  = fnl_cus_cd;           //최종수요가코드			

		
	//고객사양번호
		String[]	key57	= new String[20];       
		key57[0]  =	COL_CUS_BTH_PAP_NO;	
		key57[1]  = cus_bth_pap_no;
		key57[2]  =	prd_nm_cd;             //품명       
		key57[3]  = prd_shp;               //제품형태
		key57[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key57[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key57[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key57[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key57[8]  = embs_cd;               //EMBOSS무늬
		key57[8] = ord_usg_cd;           //주문용도코드
		key57[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key57[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key57[11] = gw_asg_cd;             //도금량지정코드
		key57[12] = ord_spnl_tp;           //주문Spangle구분
		key57[13]  = ord_exc_thk;          //주문환산두께
		key57[14]  = ord_exc_wth;          //주문환산폭			
		key57[15]  = ord_pak_mth;          //주문포장방법
		key57[16]  = pak_msg_cd;           //포장메세지코드
		key57[17]  = ord_thk_mng_cd;       //두께관리코드
		key57[18]  = ord_knd;              //주문종류
		key57[19]  = fnl_cus_cd;           //최종수요가코드			

	//고객정의색상   
		String[]	key58	= new String[20];                
		key58[0]  =	COL_CUS_REQ_CLR_NM;	
		key58[1]  = cus_req_clr_nm; 
		key58[2]  =	prd_nm_cd;             //품명       
		key58[3]  = prd_shp;               //제품형태 
		key58[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key58[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key58[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key58[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key58[8]  = embs_cd;               //EMBOSS무늬
		key58[8] = ord_usg_cd;           //주문용도코드
		key58[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key58[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key58[11] = gw_asg_cd;             //도금량지정코드
		key58[12] = ord_spnl_tp;           //주문Spangle구분
		key58[13]  = ord_exc_thk;          //주문환산두께
		key58[14]  = ord_exc_wth;          //주문환산폭			
		key58[15]  = ord_pak_mth;          //주문포장방법
		key58[16]  = pak_msg_cd;           //포장메세지코드
		key58[17]  = ord_thk_mng_cd;       //두께관리코드
		key58[18]  = ord_knd;              //주문종류
		key58[19]  = fnl_cus_cd;           //최종수요가코드			

	//고객요청납기일	  
		String[]	key59	= new String[20];               
		key59[0]  =	COL_CUS_REQ_DLV_DD;	
		key59[1]  = cus_req_dlv_dd; 
		key59[2]  =	prd_nm_cd;             //품명       
		key59[3]  = prd_shp;               //제품형태 
		key59[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key59[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key59[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key59[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key59[8]  = embs_cd;               //EMBOSS무늬
		key59[8] = ord_usg_cd;           //주문용도코드
		key59[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key59[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key59[11] = gw_asg_cd;             //도금량지정코드
		key59[12] = ord_spnl_tp;           //주문Spangle구분
		key59[13]  = ord_exc_thk;          //주문환산두께
		key59[14]  = ord_exc_wth;          //주문환산폭			
		key59[15]  = ord_pak_mth;          //주문포장방법
		key59[16]  = pak_msg_cd;           //포장메세지코드
		key59[17]  = ord_thk_mng_cd;       //두께관리코드
		key59[18]  = ord_knd;              //주문종류
		key59[19]  = fnl_cus_cd;           //최종수요가코드			

	//색상코드후면  
		String[]	key60	= new String[20];               
		key60[0]  =	COL_HUE_CD_BAK;	
		key60[1]  = hue_cd_bak;
		key60[2]  =	prd_nm_cd;             //품명       
		key60[3]  = prd_shp;               //제품형태
		key60[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key60[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key60[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key60[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key60[8]  = embs_cd;               //EMBOSS무늬
		key60[8] = ord_usg_cd;           //주문용도코드
		key60[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key60[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key60[11] = gw_asg_cd;             //도금량지정코드
		key60[12] = ord_spnl_tp;           //주문Spangle구분
		key60[13]  = ord_exc_thk;          //주문환산두께
		key60[14]  = ord_exc_wth;          //주문환산폭			
		key60[15]  = ord_pak_mth;          //주문포장방법
		key60[16]  = pak_msg_cd;           //포장메세지코드
		key60[17]  = ord_thk_mng_cd;       //두께관리코드
		key60[18]  = ord_knd;              //주문종류
		key60[19]  = fnl_cus_cd;           //최종수요가코드			

	//색상코드전면
		String[]	key61	= new String[20];                        
		key61[0]  =	COL_HUE_CD_FRN;	
		key61[1]  = hue_cd_frn; 
		key61[2]  =	prd_nm_cd;             //품명       
		key61[3]  = prd_shp;               //제품형태 
		key61[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key61[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key61[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key61[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key61[8]  = embs_cd;               //EMBOSS무늬
		key61[8] = ord_usg_cd;           //주문용도코드
		key61[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key61[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key61[11] = gw_asg_cd;             //도금량지정코드
		key61[12] = ord_spnl_tp;           //주문Spangle구분
		key61[13]  = ord_exc_thk;          //주문환산두께
		key61[14]  = ord_exc_wth;          //주문환산폭			
		key61[15]  = ord_pak_mth;          //주문포장방법
		key61[16]  = pak_msg_cd;           //포장메세지코드
		key61[17]  = ord_thk_mng_cd;       //두께관리코드
		key61[18]  = ord_knd;              //주문종류
		key61[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문인도허용차하한값	  
		String[]	key62	= new String[20];                       
		key62[0]  =	COL_ORD_DLV_ALW_DIF_LLV;	
		key62[1]  = ord_dlv_alw_dif_llv;
		key62[2]  =	prd_nm_cd;             //품명       
		key62[3]  = prd_shp;               //제품형태
		key62[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key62[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key62[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key62[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key62[8]  = embs_cd;               //EMBOSS무늬
		key62[8] = ord_usg_cd;           //주문용도코드
		key62[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key62[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key62[11] = gw_asg_cd;             //도금량지정코드
		key62[12] = ord_spnl_tp;           //주문Spangle구분
		key62[13]  = ord_exc_thk;          //주문환산두께
		key62[14]  = ord_exc_wth;          //주문환산폭			
		key62[15]  = ord_pak_mth;          //주문포장방법
		key62[16]  = pak_msg_cd;           //포장메세지코드
		key62[17]  = ord_thk_mng_cd;       //두께관리코드
		key62[18]  = ord_knd;              //주문종류
		key62[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문인도허용차상한값	   
		String[]	key63	= new String[20];       
		key63[0]  =	COL_ORD_DLV_ALW_DIF_ULV;	
		key63[1]  = ord_dlv_alw_dif_ulv;
		key63[2]  =	prd_nm_cd;             //품명       
		key63[3]  = prd_shp;               //제품형태 
		key63[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key63[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key63[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key63[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key63[8]  = embs_cd;               //EMBOSS무늬
		key63[8] = ord_usg_cd;           //주문용도코드
		key63[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key63[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key63[11] = gw_asg_cd;             //도금량지정코드
		key63[12] = ord_spnl_tp;           //주문Spangle구분
		key63[13]  = ord_exc_thk;          //주문환산두께
		key63[14]  = ord_exc_wth;          //주문환산폭			
		key63[15]  = ord_pak_mth;          //주문포장방법
		key63[16]  = pak_msg_cd;           //포장메세지코드
		key63[17]  = ord_thk_mng_cd;       //두께관리코드
		key63[18]  = ord_knd;              //주문종류
		key63[19]  = fnl_cus_cd;           //최종수요가코드			
		 
	//주문길이공차하한값
		String[]	key64	= new String[20];       
		key64[0]  =	COL_ORD_LTH_TLN_LLV;	
		key64[1]  = ord_lth_tln_llv;
		key64[2]  =	prd_nm_cd;             //품명       
		key64[3]  = prd_shp;               //제품형태
		key64[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key64[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key64[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key64[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key64[8]  = embs_cd;               //EMBOSS무늬
		key64[8] = ord_usg_cd;           //주문용도코드
		key64[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key64[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key64[11] = gw_asg_cd;             //도금량지정코드
		key64[12] = ord_spnl_tp;           //주문Spangle구분
		key64[13]  = ord_exc_thk;          //주문환산두께
		key64[14]  = ord_exc_wth;          //주문환산폭			
		key64[15]  = ord_pak_mth;          //주문포장방법
		key64[16]  = pak_msg_cd;           //포장메세지코드
		key64[17]  = ord_thk_mng_cd;       //두께관리코드
		key64[18]  = ord_knd;              //주문종류
		key64[19]  = fnl_cus_cd;           //최종수요가코드			

	//주문길이공차상한값 
		String[]	key65	= new String[20];               
		key65[0]  =	COL_ORD_LTH_TLN_ULV;	
		key65[1]  = ord_lth_tln_ulv; 
		key65[2]  =	prd_nm_cd;             //품명       
		key65[3]  = prd_shp;               //제품형태
		key65[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key65[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key65[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key65[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key65[8]  = embs_cd;               //EMBOSS무늬
		key65[8] = ord_usg_cd;           //주문용도코드
		key65[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key65[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key65[11] = gw_asg_cd;             //도금량지정코드
		key65[12] = ord_spnl_tp;           //주문Spangle구분
		key65[13]  = ord_exc_thk;          //주문환산두께
		key65[14]  = ord_exc_wth;          //주문환산폭			
		key65[15]  = ord_pak_mth;          //주문포장방법
		key65[16]  = pak_msg_cd;           //포장메세지코드
		key65[17]  = ord_thk_mng_cd;       //두께관리코드
		key65[18]  = ord_knd;              //주문종류
		key65[19]  = fnl_cus_cd;           //최종수요가코드			
		 
	//주문조합폭1	 
		String[]	key66	= new String[20];              
		key66[0]  =	COL_ORD_MIX_WTH1;	
		key66[1]  = ord_mix_wth1;
		key66[2]  =	prd_nm_cd;            //품명       
		key66[3]  = prd_shp;              //제품형태 
		key66[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key66[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key66[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key66[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key66[8]  = embs_cd;               //EMBOSS무늬
		key66[8] = ord_usg_cd;           //주문용도코드
		key66[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key66[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key66[11] = gw_asg_cd;             //도금량지정코드
		key66[12] = ord_spnl_tp;           //주문Spangle구분
		key66[13]  = ord_exc_thk;          //주문환산두께
		key66[14]  = ord_exc_wth;          //주문환산폭			
		key66[15]  = ord_pak_mth;          //주문포장방법
		key66[16]  = pak_msg_cd;           //포장메세지코드
		key66[17]  = ord_thk_mng_cd;       //두께관리코드
		key66[18]  = ord_knd;              //주문종류
		key66[19]  = fnl_cus_cd;           //최종수요가코드			
		  
	//주문조합폭2	  
		String[]	key67	= new String[20];                    
		key67[0]  =	COL_ORD_MIX_WTH2;	
		key67[1]  = ord_mix_wth2;
		key67[2]  =	prd_nm_cd;            //품명       
		key67[3]  = prd_shp;              //제품형태 
		key67[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key67[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key67[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key67[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key67[8]  = embs_cd;               //EMBOSS무늬
		key67[8] = ord_usg_cd;           //주문용도코드
		key67[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key67[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key67[11] = gw_asg_cd;             //도금량지정코드
		key67[12] = ord_spnl_tp;           //주문Spangle구분
		key67[13]  = ord_exc_thk;          //주문환산두께
		key67[14]  = ord_exc_wth;          //주문환산폭			
		key67[15]  = ord_pak_mth;          //주문포장방법
		key67[16]  = pak_msg_cd;           //포장메세지코드
		key67[17]  = ord_thk_mng_cd;       //두께관리코드
		key67[18]  = ord_knd;              //주문종류
		key67[19]  = fnl_cus_cd;           //최종수요가코드			
		
	//주문조합폭3	  
		String[]	key68	= new String[20];                    
		key68[0]  =	COL_ORD_MIX_WTH3;	
		key68[1]  = ord_mix_wth3;
		key68[2]  =	prd_nm_cd;            //품명       
		key68[3]  = prd_shp;              //제품형태 
		key68[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key68[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key68[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key68[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key68[8]  = embs_cd;               //EMBOSS무늬
		key68[8] = ord_usg_cd;           //주문용도코드
		key68[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key68[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key68[11] = gw_asg_cd;             //도금량지정코드
		key68[12] = ord_spnl_tp;           //주문Spangle구분
		key68[13]  = ord_exc_thk;          //주문환산두께
		key68[14]  = ord_exc_wth;          //주문환산폭			
		key68[15]  = ord_pak_mth;          //주문포장방법
		key68[16]  = pak_msg_cd;           //포장메세지코드
		key68[17]  = ord_thk_mng_cd;       //두께관리코드
		key68[18]  = ord_knd;              //주문종류
		key68[19]  = fnl_cus_cd;           //최종수요가코드			
		  
	//주문조합폭4	  
		String[]	key69	= new String[20];                    
		key69[0]  =	COL_ORD_MIX_WTH4;	
		key69[1]  = ord_mix_wth4;
		key69[2]  =	prd_nm_cd;            //품명       
		key69[3]  = prd_shp;              //제품형태 
		key69[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key69[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key69[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key69[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key69[8]  = embs_cd;               //EMBOSS무늬
		key69[8] = ord_usg_cd;           //주문용도코드
		key69[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key69[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key69[11] = gw_asg_cd;             //도금량지정코드
		key69[12] = ord_spnl_tp;           //주문Spangle구분
		key69[13]  = ord_exc_thk;          //주문환산두께
		key69[14]  = ord_exc_wth;          //주문환산폭			
		key69[15]  = ord_pak_mth;          //주문포장방법
		key69[16]  = pak_msg_cd;           //포장메세지코드
		key69[17]  = ord_thk_mng_cd;       //두께관리코드
		key69[18]  = ord_knd;              //주문종류
		key69[19]  = fnl_cus_cd;           //최종수요가코드			
		  
	//주문조합폭5	  
		String[]	key70	= new String[20];                    
		key70[0]  =	COL_ORD_MIX_WTH5;	
		key70[1]  = ord_mix_wth5;
		key70[2]  =	prd_nm_cd;            //품명       
		key70[3]  = prd_shp;              //제품형태 
		key70[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key70[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key70[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key70[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key70[8]  = embs_cd;               //EMBOSS무늬
		key70[8] = ord_usg_cd;           //주문용도코드
		key70[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key70[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key70[11] = gw_asg_cd;             //도금량지정코드
		key70[12] = ord_spnl_tp;           //주문Spangle구분
		key70[13]  = ord_exc_thk;          //주문환산두께
		key70[14]  = ord_exc_wth;          //주문환산폭			
		key70[15]  = ord_pak_mth;          //주문포장방법
		key70[16]  = pak_msg_cd;           //포장메세지코드
		key70[17]  = ord_thk_mng_cd;       //두께관리코드
		key70[18]  = ord_knd;              //주문종류
		key70[19]  = fnl_cus_cd;           //최종수요가코드			
		  
	//주문조합폭6	  
		String[]	key71	= new String[20];                    
		key71[0]  =	COL_ORD_MIX_WTH6;	
		key71[1]  = ord_mix_wth6;
		key71[2]  =	prd_nm_cd;             //품명       
		key71[3]  = prd_shp;               //제품형태 
		key71[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key71[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key71[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key71[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key71[8]  = embs_cd;               //EMBOSS무늬
		key71[8] = ord_usg_cd;           //주문용도코드
		key71[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key71[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key71[11] = gw_asg_cd;             //도금량지정코드
		key71[12] = ord_spnl_tp;           //주문Spangle구분
		key71[13]  = ord_exc_thk;          //주문환산두께
		key71[14]  = ord_exc_wth;          //주문환산폭			
		key71[15]  = ord_pak_mth;          //주문포장방법
		key71[16]  = pak_msg_cd;           //포장메세지코드
		key71[17]  = ord_thk_mng_cd;       //두께관리코드
		key71[18]  = ord_knd;              //주문종류
		key71[19]  = fnl_cus_cd;           //최종수요가코드			
		  
	//주문조합폭7	  
		String[]	key72	= new String[20];                    
		key72[0]  =	COL_ORD_MIX_WTH7;	
		key72[1]  = ord_mix_wth7;
		key72[2]  =	prd_nm_cd;             //품명       
		key72[3]  = prd_shp;               //제품형태 
		key72[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key72[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key72[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수]
		key72[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key72[8]  = embs_cd;               //EMBOSS무늬
		key72[8] = ord_usg_cd;           //주문용도코드
		key72[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key72[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key72[11] = gw_asg_cd;             //도금량지정코드
		key72[12] = ord_spnl_tp;           //주문Spangle구분
		key72[13]  = ord_exc_thk;          //주문환산두께
		key72[14]  = ord_exc_wth;          //주문환산폭			
		key72[15]  = ord_pak_mth;          //주문포장방법
		key72[16]  = pak_msg_cd;           //포장메세지코드
		key72[17]  = ord_thk_mng_cd;       //두께관리코드
		key72[18]  = ord_knd;              //주문종류
		key72[19]  = fnl_cus_cd;           //최종수요가코드				
		  
	//주문조합폭8	  
		String[]	key73	= new String[20];                   
		key73[0]  =	COL_ORD_MIX_WTH8;	
		key73[1]  = ord_mix_wth8;
		key73[2]  =	prd_nm_cd;             //품명       
		key73[3]  = prd_shp;               //제품형태 	
		key73[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key73[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key73[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key73[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key73[8]  = embs_cd;               //EMBOSS무늬
		key73[8] = ord_usg_cd;           //주문용도코드
		key73[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key73[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key73[11] = gw_asg_cd;             //도금량지정코드
		key73[12] = ord_spnl_tp;           //주문Spangle구분
		key73[13]  = ord_exc_thk;          //주문환산두께
		key73[14]  = ord_exc_wth;          //주문환산폭			
		key73[15]  = ord_pak_mth;          //주문포장방법
		key73[16]  = pak_msg_cd;           //포장메세지코드
		key73[17]  = ord_thk_mng_cd;       //두께관리코드
		key73[18]  = ord_knd;              //주문종류
		key73[19]  = fnl_cus_cd;           //최종수요가코드				
		 
	//주문포장단중하한값	 
		String[]	key74	= new String[20];                   
		key74[0]  =	COL_ORD_PAK_UNT_WGT_LLV;	
		key74[1]  = ord_pak_unt_wgt_llv;
		key74[2]  =	prd_nm_cd;             //품명       
		key74[3]  = prd_shp;               //제품형태
		key74[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key74[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key74[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key74[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key74[8]  = embs_cd;               //EMBOSS무늬
		key74[8] = ord_usg_cd;           //주문용도코드
		key74[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key74[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key74[11] = gw_asg_cd;             //도금량지정코드
		key74[12] = ord_spnl_tp;           //주문Spangle구분
		key74[13]  = ord_exc_thk;          //주문환산두께
		key74[14]  = ord_exc_wth;          //주문환산폭			
		key74[15]  = ord_pak_mth;          //주문포장방법
		key74[16]  = pak_msg_cd;           //포장메세지코드
		key74[17]  = ord_thk_mng_cd;       //두께관리코드
		key74[18]  = ord_knd;              //주문종류
		key74[19]  = fnl_cus_cd;           //최종수요가코드				
		  
	//주문포장단중상한값	  
		String[]	key75	= new String[20];       
		key75[0]  =	COL_ORD_PAK_UNT_WGT_ULV;	
		key75[1]  = ord_pak_unt_wgt_ulv;
		key75[2]  =	prd_nm_cd;            //품명       
		key75[3]  = prd_shp;              //제품형태 
		key75[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key75[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key75[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key75[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key75[8]  = embs_cd;               //EMBOSS무늬
		key75[8] = ord_usg_cd;           //주문용도코드
		key75[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key75[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key75[11] = gw_asg_cd;             //도금량지정코드
		key75[12] = ord_spnl_tp;           //주문Spangle구분
		key75[13]  = ord_exc_thk;          //주문환산두께
		key75[14]  = ord_exc_wth;          //주문환산폭			
		key75[15]  = ord_pak_mth;          //주문포장방법
		key75[16]  = pak_msg_cd;           //포장메세지코드
		key75[17]  = ord_thk_mng_cd;       //두께관리코드
		key75[18]  = ord_knd;              //주문종류
		key75[19]  = fnl_cus_cd;           //최종수요가코드				
		  
	//주문접수일	  
		String[]	key76	= new String[20];       
		key76[0]  =	COL_ORD_RCP_DD;	
		key76[1]  = ord_rcp_dd; 
		key76[2]  =	prd_nm_cd;             //품명       
		key76[3]  = prd_shp;               //제품형태
		key76[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key76[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key76[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key76[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key76[8]  = embs_cd;               //EMBOSS무늬
		key76[8] = ord_usg_cd;           //주문용도코드
		key76[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key76[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key76[11] = gw_asg_cd;             //도금량지정코드
		key76[12] = ord_spnl_tp;           //주문Spangle구분
		key76[13]  = ord_exc_thk;          //주문환산두께
		key76[14]  = ord_exc_wth;          //주문환산폭			
		key76[15]  = ord_pak_mth;          //주문포장방법
		key76[16]  = pak_msg_cd;           //포장메세지코드
		key76[17]  = ord_thk_mng_cd;       //두께관리코드
		key76[18]  = ord_knd;              //주문종류
		key76[19]  = fnl_cus_cd;           //최종수요가코드			
		  
	//주문Slit조수	  
		String[]	key77	= new String[20];                       
		key77[0]  =	COL_ORD_SLIT_GRP_CNT;	
		key77[1]  = Double.toString(ord_slit_grp_cnt); //Double->toString 변환
		key77[2]  =	prd_nm_cd;             //품명       
		key77[3]  = prd_shp;               //제품형태
		key77[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key77[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key77[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key77[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key77[8]  = embs_cd;               //EMBOSS무늬
		key77[8] = ord_usg_cd;           //주문용도코드
		key77[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key77[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key77[11] = gw_asg_cd;             //도금량지정코드
		key77[12] = ord_spnl_tp;           //주문Spangle구분
		key77[13]  = ord_exc_thk;          //주문환산두께
		key77[14]  = ord_exc_wth;          //주문환산폭			
		key77[15]  = ord_pak_mth;          //주문포장방법
		key77[16]  = pak_msg_cd;           //포장메세지코드
		key77[17]  = ord_thk_mng_cd;       //두께관리코드
		key77[18]  = ord_knd;              //주문종류
		key77[19]  = fnl_cus_cd;           //최종수요가코드				
		 
	//주문소포장혼입율	 
		String[]	key78	= new String[20];            
		key78[0]  =	COL_ORD_SML_PAK_MIR;	
		key78[1]  = ord_sml_pak_mir;
		key78[2]  =	prd_nm_cd;            //품명       
		key78[3]  = prd_shp;              //제품형태
		key78[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key78[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key78[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수	
		key78[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key78[8]  = embs_cd;               //EMBOSS무늬
		key78[8] = ord_usg_cd;           //주문용도코드
		key78[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key78[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key78[11] = gw_asg_cd;             //도금량지정코드
		key78[12] = ord_spnl_tp;           //주문Spangle구분
		key78[13]  = ord_exc_thk;          //주문환산두께
		key78[14]  = ord_exc_wth;          //주문환산폭			
		key78[15]  = ord_pak_mth;          //주문포장방법
		key78[16]  = pak_msg_cd;           //포장메세지코드
		key78[17]  = ord_thk_mng_cd;       //두께관리코드
		key78[18]  = ord_knd;              //주문종류
		key78[19]  = fnl_cus_cd;           //최종수요가코드				
		   
	//주문두께공차하한값	   
		String[]	key79	= new String[20];               
		key79[0]  =	COL_ORD_THK_TLN_LLV;	
		key79[1]  = ord_thk_tln_llv;
		key79[2]  =	prd_nm_cd;            //품명       
		key79[3]  = prd_shp;              //제품형태
		key79[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key79[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key79[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key79[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key79[8]  = embs_cd;               //EMBOSS무늬
		key79[8] = ord_usg_cd;           //주문용도코드
		key79[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key79[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key79[11] = gw_asg_cd;             //도금량지정코드
		key79[12] = ord_spnl_tp;           //주문Spangle구분
		key79[13]  = ord_exc_thk;          //주문환산두께
		key79[14]  = ord_exc_wth;          //주문환산폭			
		key79[15]  = ord_pak_mth;          //주문포장방법
		key79[16]  = pak_msg_cd;           //포장메세지코드
		key79[17]  = ord_thk_mng_cd;       //두께관리코드
		key79[18]  = ord_knd;              //주문종류
		key79[19]  = fnl_cus_cd;           //최종수요가코드				
		  
	//주문두께공차상한값	  
		String[]	key80	= new String[20];               
		key80[0]  =	COL_ORD_THK_TLN_ULV;	
		key80[1]  = ord_thk_tln_ulv; 
		key80[2]  =	prd_nm_cd;             //품명       
		key80[3]  = prd_shp;               //제품형태 
		key80[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key80[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key80[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key80[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key80[8]  = embs_cd;               //EMBOSS무늬
		key80[8] = ord_usg_cd;           //주문용도코드
		key80[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key80[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key80[11] = gw_asg_cd;             //도금량지정코드
		key80[12] = ord_spnl_tp;           //주문Spangle구분
		key80[13]  = ord_exc_thk;          //주문환산두께
		key80[14]  = ord_exc_wth;          //주문환산폭			
		key80[15]  = ord_pak_mth;          //주문포장방법
		key80[16]  = pak_msg_cd;           //포장메세지코드
		key80[17]  = ord_thk_mng_cd;       //두께관리코드
		key80[18]  = ord_knd;              //주문종류
		key80[19]  = fnl_cus_cd;           //최종수요가코드	
		  
	//주문폭공차하한값	  
		String[]	key81	= new String[20];              
		key81[0]  =	COL_ORD_WTH_TLN_LLV;	
		key81[1]  = ord_wth_tln_llv; 
		key81[2]  =	prd_nm_cd;             //품명       
		key81[3]  = prd_shp;               //제품형태 
		key81[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key81[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key81[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key81[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key81[8]  = embs_cd;               //EMBOSS무늬
		key81[8] = ord_usg_cd;           //주문용도코드
		key81[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key81[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key81[11] = gw_asg_cd;             //도금량지정코드
		key81[12] = ord_spnl_tp;           //주문Spangle구분
		key81[13]  = ord_exc_thk;          //주문환산두께
		key81[14]  = ord_exc_wth;          //주문환산폭			
		key81[15]  = ord_pak_mth;          //주문포장방법
		key81[16]  = pak_msg_cd;           //포장메세지코드
		key81[17]  = ord_thk_mng_cd;       //두께관리코드
		key81[18]  = ord_knd;              //주문종류
		key81[19]  = fnl_cus_cd;           //최종수요가코드				
		 
	//주문폭공차상한값	 
		String[]	key82	= new String[20];              
		key82[0]  =	COL_ORD_WTH_TLN_ULV;	
		key82[1]  = ord_wth_tln_ulv;
		key82[2]  =	prd_nm_cd;            //품명       
		key82[3]  = prd_shp;              //제품형태
		key82[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key82[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key82[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key82[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key82[8]  = embs_cd;               //EMBOSS무늬
		key82[8] = ord_usg_cd;           //주문용도코드
		key82[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key82[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key82[11] = gw_asg_cd;             //도금량지정코드
		key82[12] = ord_spnl_tp;           //주문Spangle구분
		key82[13]  = ord_exc_thk;          //주문환산두께
		key82[14]  = ord_exc_wth;          //주문환산폭			
		key82[15]  = ord_pak_mth;          //주문포장방법
		key82[16]  = pak_msg_cd;           //포장메세지코드
		key82[17]  = ord_thk_mng_cd;       //두께관리코드
		key82[18]  = ord_knd;              //주문종류
		key82[19]  = fnl_cus_cd;           //최종수요가코드									
		  
	//플랜트구분	  
		String[]	key83	= new String[20];               
		key83[0]  =	COL_PLNT_TP;	
		key83[1]  = plnt_tp; 
		key83[2]  =	prd_nm_cd;            //품명       
		key83[3]  = prd_shp;              //제품형태 
		key83[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key83[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key83[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key83[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key83[8]  = embs_cd;               //EMBOSS무늬
		key83[8] = ord_usg_cd;           //주문용도코드
		key83[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key83[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key83[11] = gw_asg_cd;             //도금량지정코드
		key83[12] = ord_spnl_tp;           //주문Spangle구분
		key83[13]  = ord_exc_thk;          //주문환산두께
		key83[14]  = ord_exc_wth;          //주문환산폭			
		key83[15]  = ord_pak_mth;          //주문포장방법
		key83[16]  = pak_msg_cd;           //포장메세지코드
		key83[17]  = ord_thk_mng_cd;       //두께관리코드
		key83[18]  = ord_knd;              //주문종류
		key83[19]  = fnl_cus_cd;           //최종수요가코드				
		 
	//조당최대중량	 
		String[]	key84	= new String[20];                              
		key84[0]  =	COL_SLIT_MAX_WGT;	
		key84[1]  = slit_max_wgt; 
		key84[2]  =	prd_nm_cd;             //품명       
		key84[3]  = prd_shp;               //제품형태 
		key84[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key84[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key84[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key84[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key84[8]  = embs_cd;               //EMBOSS무늬
		key84[8] = ord_usg_cd;           //주문용도코드
		key84[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key84[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key84[11] = gw_asg_cd;             //도금량지정코드
		key84[12] = ord_spnl_tp;           //주문Spangle구분
		key84[13]  = ord_exc_thk;          //주문환산두께
		key84[14]  = ord_exc_wth;          //주문환산폭			
		key84[15]  = ord_pak_mth;          //주문포장방법
		key84[16]  = pak_msg_cd;           //포장메세지코드
		key84[17]  = ord_thk_mng_cd;       //두께관리코드
		key84[18]  = ord_knd;              //주문종류
		key84[19]  = fnl_cus_cd;           //최종수요가코드			
		
	//Tag유형	
		String[]	key85	= new String[20];                   
		key85[0]  =	COL_TAG_TP;	
		key85[1]  = tag_tp; 
		key85[2]  =	prd_nm_cd;             //품명       
		key85[3]  = prd_shp;               //제품형태
		key85[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key85[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key85[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key85[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key85[8]  = embs_cd;               //EMBOSS무늬
		key85[8] = ord_usg_cd;           //주문용도코드
		key85[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key85[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key85[11] = gw_asg_cd;             //도금량지정코드
		key85[12] = ord_spnl_tp;           //주문Spangle구분
		key85[13]  = ord_exc_thk;          //주문환산두께
		key85[14]  = ord_exc_wth;          //주문환산폭			
		key85[15]  = ord_pak_mth;          //주문포장방법
		key85[16]  = pak_msg_cd;           //포장메세지코드
		key85[17]  = ord_thk_mng_cd;       //두께관리코드
		key85[18]  = ord_knd;              //주문종류
		key85[19]  = fnl_cus_cd;           //최종수요가코드				
		
	//위탁임가공여부	
		String[]	key86	= new String[20];                               
		key86[0]  =	COL_TRST_PROC_YN;	
		key86[1]  = trst_proc_yn;
		key86[2]  =	prd_nm_cd;            //품명       
		key86[3]  = prd_shp;              //제품형태 	
		key86[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key86[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key86[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key86[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key86[8]  = embs_cd;               //EMBOSS무늬
		key86[8] = ord_usg_cd;           //주문용도코드
		key86[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key86[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key86[11] = gw_asg_cd;             //도금량지정코드
		key86[12] = ord_spnl_tp;           //주문Spangle구분
		key86[13]  = ord_exc_thk;          //주문환산두께
		key86[14]  = ord_exc_wth;          //주문환산폭			
		key86[15]  = ord_pak_mth;          //주문포장방법
		key86[16]  = pak_msg_cd;           //포장메세지코드
		key86[17]  = ord_thk_mng_cd;       //두께관리코드
		key86[18]  = ord_knd;              //주문종류
		key86[19]  = fnl_cus_cd;           //최종수요가코드				
		
	//주문조합폭9	  
		String[]	key87	= new String[20];                   
		key87[0]  =	COL_ORD_MIX_WTH9;	
		key87[1]  = ord_mix_wth9;
		key87[2]  =	prd_nm_cd;            //품명       
		key87[3]  = prd_shp;              //제품형태
		key87[4]  = ord_slv_knd_tp;       //주문내경링종류구분
		key87[5]  = ord_wth_mng_cd;       //주문폭관리코드
		key87[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key87[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key87[8]  = embs_cd;               //EMBOSS무늬
		key87[8] = ord_usg_cd;           //주문용도코드
		key87[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key87[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key87[11] = gw_asg_cd;             //도금량지정코드
		key87[12] = ord_spnl_tp;           //주문Spangle구분
		key87[13]  = ord_exc_thk;          //주문환산두께
		key87[14]  = ord_exc_wth;          //주문환산폭			
		key87[15]  = ord_pak_mth;          //주문포장방법
		key87[16]  = pak_msg_cd;           //포장메세지코드
		key87[17]  = ord_thk_mng_cd;       //두께관리코드
		key87[18]  = ord_knd;              //주문종류
		key87[19]  = fnl_cus_cd;           //최종수요가코드			
		
	//주문조합폭10	  
		String[]	key88	= new String[20];                   
		key88[0]  =	COL_ORD_MIX_WTH10;	
		key88[1]  = ord_mix_wth10;
		key88[2]  =	prd_nm_cd;             //품명       
		key88[3]  = prd_shp;               //제품형태  
		key88[4]  = ord_slv_knd_tp;        //주문내경링종류구분
		key88[5]  = ord_wth_mng_cd;        //주문폭관리코드
		key88[6]  = Double.toString(ord_slit_grp_cnt); //Double->toString//주문Slit조수
		key88[7]  = ord_ptt_flm_cd;        //주문보호필름상세코드
		//key88[8]  = embs_cd;               //EMBOSS무늬
		key88[8] = ord_usg_cd;           //주문용도코드
		key88[9]  = ord_edg_asg_tp;        //주문Edge지정구분
		key88[10] = ord_sur_hnd_cd;        //주문표면처리코드
		key88[11] = gw_asg_cd;             //도금량지정코드
		key88[12] = ord_spnl_tp;           //주문Spangle구분
		key88[13]  = ord_exc_thk;          //주문환산두께
		key88[14]  = ord_exc_wth;          //주문환산폭			
		key88[15]  = ord_pak_mth;          //주문포장방법
		key88[16]  = pak_msg_cd;           //포장메세지코드
		key88[17]  = ord_thk_mng_cd;       //두께관리코드
		key88[18]  = ord_knd;              //주문종류
		key88[19]  = fnl_cus_cd;           //최종수요가코드
		
		
		
		HashMap masterChkList =   new HashMap();
		
	      masterChkList.put (COL_ORD_REQ_NO               , key1);
	      masterChkList.put (COL_ORD_REQ_LN               , key2);
	      masterChkList.put (COL_PRD_NM_CD                , key3);
	      masterChkList.put (COL_PRD_SHP                  , key4);
	      masterChkList.put (COL_FLOW_CHL                 , key5);
	      masterChkList.put (COL_ORD_KND                  , key6);
	      masterChkList.put (COL_ORD_USG_CD               , key7);
	      masterChkList.put (COL_CUS_CD                   , key8);
	      masterChkList.put (COL_ACT_CUS_CD               , key9);
	      masterChkList.put (COL_FNL_CUS_CD               , key10);
	      masterChkList.put (COL_SPC_AVR                  , key11);
	      masterChkList.put (COL_SPC_YR                   , key12);
	      masterChkList.put (COL_ORD_SZ                   , key13);
	      masterChkList.put (COL_ORD_EXC_THK              , key14);
	      masterChkList.put (COL_ORD_EXC_WTH              , key15);
	      masterChkList.put (COL_ORD_SUR_HND_CD           , key16);
	      masterChkList.put (COL_ORD_EDG_ASG_TP           , key17);
	      masterChkList.put (COL_ORD_THK_TP               , key18);
	      masterChkList.put (COL_WGT_DCS_MTH_TP           , key19);
	      masterChkList.put (COL_ORD_WGT_UNT              , key20);
	      masterChkList.put (COL_ORD_LN_WGT               , key21);
	      masterChkList.put (COL_ORD_STDP_LLV             , key22);
	      masterChkList.put (COL_ORD_STDP_ULV             , key23);
	      masterChkList.put (COL_ORD_PAK_UNT_WGT          , key24);
	      masterChkList.put (COL_ORD_SML_PAK_WGT          , key25);
	      masterChkList.put (COL_ORD_UNT_WGT              , key26);
	      masterChkList.put (COL_ORD_PAK_MTH              , key27);
	      masterChkList.put (COL_ORD_THK_MNG_CD           , key28);
	      masterChkList.put (COL_ORD_WTH_MNG_CD           , key29);
	      masterChkList.put (COL_NAT_CD                   , key30);
	      masterChkList.put (COL_ORD_RGS_PRS_ID           , key31);
	      masterChkList.put (COL_ORD_TEM_CD               , key32);
		  masterChkList.put (COL_ORD_SLV_KND_TP           , key33);
		  masterChkList.put (COL_ORD_PAK_LTH_LLV          , key34);
	      masterChkList.put (COL_ORD_PAK_LTH_ULV          , key35);
		  masterChkList.put (COL_ORD_COIL_IDIA            , key36);
		  masterChkList.put (COL_ORD_COIL_ODIA            , key37);
		  masterChkList.put (COL_ORD_COILG_MTH            , key38);
		  masterChkList.put (COL_ORD_EXC_LTH              , key39);
		  masterChkList.put (COL_ORD_LTH_MNG_CD           , key40);
		  masterChkList.put (COL_ORD_SHT_LOD_MTH          , key41);
		  masterChkList.put (COL_ORD_SHT_CNT              , key42);
		  masterChkList.put (COL_ORD_PAK_SHT_CNT          , key43);
		  masterChkList.put (COL_ORD_STDP_CNT_LLV         , key44);
		  masterChkList.put (COL_ORD_STDP_CNT_ULV         , key45);
		  masterChkList.put (COL_GW_ASG_CD                , key46);
		  masterChkList.put (COL_CCL_BOM_NO               , key47);
		  masterChkList.put (COL_ORD_ORG_PLT_SPC_AVR      , key48);
	      masterChkList.put (COL_ORD_ROU_CD               , key49);
		  masterChkList.put (COL_ORD_SPNL_TP              , key50);
		  masterChkList.put (COL_ORD_SKP_DEG              , key51);
		  masterChkList.put (COL_ORD_THK_TP               , key52);
	      masterChkList.put (COL_EMBS_CD                  , key53);
		  masterChkList.put (COL_ORD_PTT_FLM_CD           , key54);
		  masterChkList.put (COL_ORD_PTT_FLM_WTH          , key55);
	      masterChkList.put (COL_ORD_PTT_FLM_ADH_LOC_CD   , key56);
	      
	      masterChkList.put (COL_CUS_BTH_PAP_NO           , key57);
	      masterChkList.put (COL_CUS_REQ_CLR_NM           , key58);
	      masterChkList.put (COL_CUS_REQ_DLV_DD           , key59);
	      masterChkList.put (COL_HUE_CD_BAK               , key60);
	      masterChkList.put (COL_HUE_CD_FRN               , key61);
	      masterChkList.put (COL_ORD_DLV_ALW_DIF_LLV      , key62);
	      masterChkList.put (COL_ORD_DLV_ALW_DIF_ULV      , key63);
	      masterChkList.put (COL_ORD_LTH_TLN_LLV          , key64);
	      masterChkList.put (COL_ORD_LTH_TLN_ULV          , key65);
	      masterChkList.put (COL_ORD_MIX_WTH1             , key66);
	      masterChkList.put (COL_ORD_MIX_WTH2             , key67);
	      masterChkList.put (COL_ORD_MIX_WTH3             , key68);
	      masterChkList.put (COL_ORD_MIX_WTH4             , key69);
	      masterChkList.put (COL_ORD_MIX_WTH5             , key70);
	      masterChkList.put (COL_ORD_MIX_WTH6             , key71);
	      masterChkList.put (COL_ORD_MIX_WTH7             , key72);
	      masterChkList.put (COL_ORD_MIX_WTH8             , key73);
	      masterChkList.put (COL_ORD_PAK_UNT_WGT_LLV      , key74);
	      masterChkList.put (COL_ORD_PAK_UNT_WGT_ULV      , key75);
	      masterChkList.put (COL_ORD_RCP_DD               , key76);
	      masterChkList.put (COL_ORD_SLIT_GRP_CNT         , key77);
	      masterChkList.put (COL_ORD_SML_PAK_MIR          , key78);
	      masterChkList.put (COL_ORD_THK_TLN_LLV          , key79);
	      masterChkList.put (COL_ORD_THK_TLN_ULV          , key80);
	      masterChkList.put (COL_ORD_WTH_TLN_LLV          , key81);
	      masterChkList.put (COL_ORD_WTH_TLN_ULV          , key82);
	      masterChkList.put (COL_PLNT_TP                  , key83);
	      masterChkList.put (COL_SLIT_MAX_WGT             , key84);
	      masterChkList.put (COL_TAG_TP                   , key85);
	      masterChkList.put (COL_TRST_PROC_YN             , key86);	
	      masterChkList.put (COL_ORD_MIX_WTH9             , key87);
	      masterChkList.put (COL_ORD_MIX_WTH10            , key88);	  

	      
		   //CCL-BOM Table 기준 Chk
		if(ActivityUtil.isValidData(ccl_bom_no)){		    
		    
	        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );
	        PosParameter param = new PosParameter(); // MD View param

	        PosRowSet rowset9 = null;
	        PosRow     row9 = null;
	        PosRowSet rowset10 = null;
	        PosRow     row10 = null;
	        
	        param = new PosParameter(); // MD View param
	        param.setWhereClauseParameter( 0, ccl_bom_no );

	        try
	        {
	            // 결과값 잘 가져오는지 확인
	            rowset9 = dao.find( SELECT_CCL_BOM, param ); // CCL-BOM 기준select
	        } catch ( Exception e )
	        {
	            rowset9 = null;
	            logger.logError( ERRMSG_A902 );
				setError(ctx	, logger , ERRMSG_A902
					    , ERRCD_A902
							, new String[]{ord_req_no, ord_req_ln, ERRCD_A902} , ERRMSG_CF68);//MS002007
	            //return false;
	        }

	        if ( rowset9.count() == 1 )
	        {
	        	row9 = rowset9.next();
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_FRN ) ) )
        			ccl_bom_hue_cd_frn = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_FRN ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_BAK ) ) )
        			ccl_bom_hue_cd_bak = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_BAK ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_SUB ) ) )
        			ccl_bom_hue_cd_sub = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_SUB) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_FRN_1COT ) ) )
        			ccl_bom_hue_cd_frn_1cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_FRN_1COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_FRN_2COT ) ) )
        			ccl_bom_hue_cd_frn_2cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_FRN_2COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_FRN_3COT ) ) )
        			ccl_bom_hue_cd_frn_3cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_FRN_3COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_FRN_4COT ) ) )
        			ccl_bom_hue_cd_frn_4cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_FRN_4COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_BAK_1COT ) ) )
        			ccl_bom_hue_cd_bak_1cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_BAK_1COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_BAK_2COT ) ) )
        			ccl_bom_hue_cd_bak_2cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_BAK_2COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_BAK_3COT ) ) ) 
        			ccl_bom_hue_cd_bak_3cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_BAK_3COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_BAK_4COT ) ) )
        			ccl_bom_hue_cd_bak_4cot = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_BAK_4COT ) );
        		if ( !DbCommonUtil.isNull( row9.getAttribute( COL_HUE_CD_LMN ) ) )
        			ccl_bom_hue_cd_lmn = DbCommonUtil.valueOf( row9.getAttribute( COL_HUE_CD_LMN) );
        		param = new PosParameter(); // MD View param
    	        param.setWhereClauseParameter( 0, ccl_bom_hue_cd_frn );
    	        param.setWhereClauseParameter( 1, ccl_bom_hue_cd_bak );
    	        param.setWhereClauseParameter( 2, ccl_bom_hue_cd_sub );
    	        param.setWhereClauseParameter( 3, ccl_bom_hue_cd_frn_1cot );
    	        param.setWhereClauseParameter( 4, ccl_bom_hue_cd_frn_2cot );
    	        param.setWhereClauseParameter( 5, ccl_bom_hue_cd_frn_3cot );
    	        param.setWhereClauseParameter( 6, ccl_bom_hue_cd_frn_4cot );
    	        param.setWhereClauseParameter( 7, ccl_bom_hue_cd_bak_1cot );
    	        param.setWhereClauseParameter( 8, ccl_bom_hue_cd_bak_2cot );
    	        param.setWhereClauseParameter( 9, ccl_bom_hue_cd_bak_3cot );
    	        param.setWhereClauseParameter(10, ccl_bom_hue_cd_bak_4cot );
    	        param.setWhereClauseParameter(11, ccl_bom_hue_cd_lmn );
    	        try
    	        {
    	            // 결과값 잘 가져오는지 확인
    	            rowset10 = dao.find( C102100CCL_BOM_CLR_USE_N, param ); // CCL-BOM에 대한 칼라코드 사용불가 개수 select
    	        } catch ( Exception e )
    	        {
    	            rowset10 = null;
    	            logger.logError( ERRMSG_A905 );
    				setError(ctx	, logger , ERRMSG_A905
    					    , ERRCD_A905
    							, new String[]{ord_req_no, ord_req_ln, ERRCD_A905} , ERRMSG_CF68);//MS002007
    	            //return false;
    	        }	            
    	        if ( rowset10.count() == 1 )
    	        {    
    	        	row10 = rowset10.next();
    	       		if ( !DbCommonUtil.isNull( row10.getAttribute( C10PN_CLR_USE_N_CNT ) ) )
    	       			ccl_bom_clr_use_n_cnt = Integer.parseInt( DbCommonUtil.valueOf( row10.getAttribute( C10PN_CLR_USE_N_CNT ) ) );
    	       		if ( ccl_bom_clr_use_n_cnt >= 1 )
    	       		{
        	            logger.logError( ERRMSG_A904 );
        				setError(ctx	, logger , ERRMSG_A904
        					    , ERRCD_A904
        							, new String[]{ord_req_no, ord_req_ln, ERRCD_A904} , ERRMSG_CF68);//MS002007
        	            //return false;
    	       		}
        	    } else
        	    {
    	            logger.logError( ERRMSG_A905 );
    				setError(ctx	, logger , ERRMSG_A905
    					    , ERRCD_A905
    							, new String[]{ord_req_no, ord_req_ln, ERRCD_A905} , ERRMSG_CF68);//MS002007
    	            //return false;
    	        }	            
        	    	
        		
	        } else if ( rowset9.count() > 1 )
	        {
				setError(ctx	, logger , ERRMSG_A903
					    , ERRCD_A903
							, new String[]{ord_req_no, ord_req_ln, ERRCD_A903} , ERRMSG_CF68);//MS002007
	            //return false;
	        } else
	        {
				setError(ctx	, logger , ERRMSG_A902
					    , ERRCD_A902
							, new String[]{ord_req_no, ord_req_ln, ERRCD_A902} , ERRMSG_CF68);//MS002007
	            //return false;
	        }
		}
		
		//보호필름상세코드가 NULL이면 에러체크하지 않음
		if(ActivityUtil.isValidData(ord_ptt_flm_cd)){ 
			
			 // 칼라물성(CLP_MPR)Table 기준 Chk
			if((ActivityUtil.isValidData(ccl_bom_no)) &&
			  ( prd_nm_cd.equals( PRD_NM_CD_1 ) || prd_nm_cd.equals( PRD_NM_CD_2 ) || 
			    prd_nm_cd.equals( PRD_NM_CD_3 ) || prd_nm_cd.equals( PRD_NM_CD_4 ) || 
			    prd_nm_cd.equals( PRD_NM_CD_5 ) || prd_nm_cd.equals( PRD_NM_CD_6 ) || 
			    prd_nm_cd.equals( PRD_NM_CD_7 ) || prd_nm_cd.equals( PRD_NM_CD_8 ) || prd_nm_cd.equals( PRD_NM_CD_9 ) ))
			{
	  			Object bind_result = null;
	  			PosRowSet	rowset8	=	ctx.getRowSet(bind_result);
	  			PosRow row8 = null;//
	
	  			//PosRow		row8		=	DbCommonUtil.rowOf(rowset8);
	  			
	  			PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
	  			String 			colValue[] 			= 	null;//컬럼값
	  			PosParameter param = new PosParameter(); //MD View param
	  			
	  			colValue 		= new String[3];
	  			colValue[0] = (String)ctx.get(COL_CCL_BOM_NO);  
	  			colValue[1] = (String)ctx.get(COL_FNL_CUS_CD); 
	  			colValue[2] = (String)ctx.get(COL_ORD_USG_CD); 
	
	  	      			
	  			//PosRowSet	rowset = null;
	
	
	  	          param = new PosParameter();  //MD View param
	  	          param.setWhereClauseParameter( 0, ccl_bom_no );
	  	          param.setWhereClauseParameter( 1, fnl_cus_cd );
	  	          param.setWhereClauseParameter( 2, ord_usg_cd );
	  	          param.setWhereClauseParameter( 3, fnl_cus_cd );
	  	          param.setWhereClauseParameter( 4, ord_usg_cd );
	  	          param.setWhereClauseParameter( 5, fnl_cus_cd );
	  	          param.setWhereClauseParameter( 6, ord_usg_cd );
	  	          param.setWhereClauseParameter( 7, ccl_bom_no );
	  	          param.setWhereClauseParameter( 8, fnl_cus_cd );
	  	          param.setWhereClauseParameter( 9, ord_usg_cd );
	  	          
	  		        try{
	  		        	//결과값 잘 가져오는지 확인
	  		        	rowset8 = dao.find( CLR_MPR_SELECT , param );	//Master Code View.select			
	  		        }catch(Exception e){
	  		        	rowset8 = null;
	  					logger.logError(e.getMessage());
	  					setError(ctx	, logger , ERRMSG_A663
	  						    , ERRCD_A93
	  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A663} , ERRMSG_CF68);//MS002007
	  					//return PosBizControlConstants.FAILURE; 
	  		        }
	  		        if ( rowset8.count() > 0 )
	  		        {
	  		        	//칼라물성&주문정보의 보호필름값 비교
	  		            row8 = rowset8.next();
	  		        	String result =  (String)row8.getAttribute( "PTT_FLM_DTL_CD" ) ;
	  		        	if(result==null){
	
	  		        		result="";
	  		        	}
	  		            if(!ord_ptt_flm_cd.equals(result)){
	
	  		            	setError(ctx   , logger  , ERRMSG_A665
	  		            			, ERRCD_A93
	  		            			   , new String[]{ord_req_no, ord_req_ln, ERRCD_A665}, ERRMSG_CF83);//MS002007
	  		            }
	  		            
	  			    }
	  		        else{
	  					setError(ctx	, logger , ERRMSG_A663
	  						    , ERRCD_A93
	  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A663} , ERRMSG_CF68);//MS002007
	
	  					//return PosBizControlConstants.FAILURE; 	
	  			    }	
						
			}
			 if((ActivityUtil.isValidData(ord_ptt_flm_cd)) &&
				 ( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_G ) || prd_nm_cd.equals( PRD_NM_CD_L ) || prd_nm_cd.equals( PRD_NM_CD_J ) ||
                   prd_nm_cd.equals( PRD_NM_CD_N ) || prd_nm_cd.equals( PRD_NM_CD_K ) || prd_nm_cd.equals( PRD_NM_CD_V ) || prd_nm_cd.equals( PRD_NM_CD_W )))
			 {							
				 
			  			Object bind_result = null;
			  			PosRowSet	rowset10	=	ctx.getRowSet(bind_result);
			  			//PosRow		row10		=	DbCommonUtil.rowOf(rowset10);
			  			
			  			PosGenericDao	dao					=	this.getDao(this.getProperty(PosServiceParamIF.DAO));
			  			String 			colValue[] 			= 	null;//컬럼값
			  			PosParameter param = new PosParameter(); //MD View param
			  			
			  			colValue 		= new String[2];
			  			colValue[0] = (String)ctx.get(COL_ORD_PTT_FLM_CD); //주문보호필름코드 
			  	      			
			  			//PosRowSet	rowset = null;
		
		
			  	          param = new PosParameter();  //MD View param
			  	          param.setWhereClauseParameter( 0, colValue[0] );
		
		
			  	          
			  		        try{
			  		        	//결과값 잘 가져오는지 확인
			  		        	rowset10 = dao.find( GAL_PTT_FLM_SELECT , param );	//Master Code View.select			
			  		        }catch(Exception e){
			  		        	rowset10 = null;
			  					logger.logError(e.getMessage());
			  					setError(ctx	, logger , ERRMSG_A66
			  						    , ERRCD_A93
			  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A66} , ERRMSG_CF68);//MS002007
			  					//return PosBizControlConstants.FAILURE; 
			  		        }
			  		        if ( rowset10.count() == 1 )
			  		        {
			  		            //row7 = rowset7.next();
			  		        }
			  		        else if(rowset10.count() > 1){
			  					setError(ctx	, logger , ERRMSG_A661
			  						    , ERRCD_A93
			  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A661} , ERRMSG_CF68);//MS002007
			  					//return PosBizControlConstants.FAILURE; 	
			  			    }
			  		        else{
			  					setError(ctx	, logger , ERRMSG_A66
			  						    , ERRCD_A93
			  								, new String[]{ord_req_no, ord_req_ln, ERRCD_A66} , ERRMSG_CF68);//MS002007
		
			  					//return PosBizControlConstants.FAILURE; 	
			  			    }
					 
			 }
		}

        //코일 외경 계산식 적용
//		if((ActivityUtil.isValidData(ord_exc_wth))&& (ActivityUtil.isValidData(ord_pak_unt_wgt_ulv)))
//		{	
//			if ( ord_slit_grp_cnt > 0 ) //주문Slit조수
//			{
//	            for ( int CNT = 0; CNT < ord_mix_wth.size(); CNT++ )
//	            {
//	                if ( ord_mix_wth.get( CNT ) > 0 )
//	                {
//	                    ord_slit_grp_cnt++;
//	                }
//	                if ( CNT == 0 )
//	                {
//	                    if ( ord_mix_wth.get( 0 ) > 0 )
//	                    {
//	                        mix_wth = ord_mix_wth.get( 0 );
//	                    }
//	                } else
//	                {
//	                    if ( ord_mix_wth.get( CNT ) > 0)
//	                    {
//	                    	if(mix_wth == 0)                    		
//	                    		mix_wth = ord_mix_wth.get( CNT );
//	                    	else if(mix_wth > ord_mix_wth.get( CNT ))
//	                    		mix_wth = ord_mix_wth.get( CNT );
//	                    }
//	                }
//	             }		    		    			
//					
//					ArrayList arrayTest = new ArrayList();
//					
//					String coilRmwWgt = DbCommonUtil.valueOf(ctx.get(COL_ORD_PAK_UNT_WGT_ULV )); //주문포장단중상한값 (중량)
//					String coilWth    = Double.toString(mix_wth); // 주문조합폭 최소값
//			        String coilIDia   = ORD_COIL_ID_508;//508표준코일내경			        
//					if(!DbCommonUtil.valueOf(ctx.get(COL_ORD_COIL_IDIA   )).equals(C10STR_SPACE) 
//							&& !DbCommonUtil.valueOf(ctx.get(COL_ORD_COIL_IDIA   )).equals(NUM0))								
//						coilIDia   = DbCommonUtil.valueOf(ctx.get(COL_ORD_COIL_IDIA   )); // 코일내경
//					
//		        
//			        arrayTest.add( new String[] {coilRmwWgt});
//			        arrayTest.add( new String[] {coilWth});
//			        arrayTest.add( new String[] {coilIDia});
					
					
			        // 중량계산식 = SQRT(중량*4*1000000/(24.279265*코일폭)+ 코일내경^2)
			        
//			        PosCalcVO calcVo = EasyAccess.getPosCalc(M47C0013, arrayTest);
//			        if(calcVo==null) {
//			            throw new PosException("코일외경[M47C0013] 계산에 실패하였습니다(코일중량[" + coilRmwWgt + "] 코일폭[" + coilWth + "] 코일내경[" + coilIDia + "])");
//			        }
//			      
//			    		        
//			        Object result = calcVo.getResultValue();
//			        String coilodia = C10STR_SPACE;
//			        if(!DbCommonUtil.isNull(result))
//			        	coilodia = result.toString();
//			        ctx.put( COL_ORD_COIL_ODIA, coilodia);
//			       
//			        logger.logInfo("코일의 외경을 구한다. >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			    	//	        logger.logInfo("입력받은 코일중량\t\t\t\t\t"        + coilRmwWgt);
			    	//	        logger.logInfo("입력받은 환산폭\t\t\t\t\t\t\t\t"        + coilWth);
			    	//	        logger.logInfo("입력받은 코일내경\t\t\t\t\t\t\t"        + coilIDia);
//			    		        logger.logInfo("코일외경[M47C0013] 결과\t\t\t\t"        + result);
			         
//			        if( Double.compare(Double.parseDouble(coilodia),(Double.parseDouble(coilWth)*2)) >  0)
//			        {
//			        
//			        	setError(ctx	, logger , (ERRMSG_A782+ C10STR_MINUS + coilodia)
//						    , ERRCD_A782
//								, new String[]{ord_req_no, ord_req_ln, ERRCD_A782} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE;
//			        }
//				
//		    }
//			else{
//					ArrayList arrayTest = new ArrayList();
//					
//					String coilRmwWgt = DbCommonUtil.valueOf(ctx.get(COL_ORD_PAK_UNT_WGT_ULV )); //주문포장단중상한값 (중량)
//					String coilWth    = DbCommonUtil.valueOf(ctx.get(COL_ORD_EXC_WTH   )); // 주문환산폭
//			        String coilIDia   = ORD_COIL_ID_508;//508표준코일내경		        
//					if(!DbCommonUtil.valueOf(ctx.get(COL_ORD_COIL_IDIA   )).equals(C10STR_SPACE) 
//							&& !DbCommonUtil.valueOf(ctx.get(COL_ORD_COIL_IDIA   )).equals(NUM0))
//						coilIDia   = DbCommonUtil.valueOf(ctx.get(COL_ORD_COIL_IDIA   )); // 코일내경
//	
//			        arrayTest.add( new String[] {coilRmwWgt});
//			        arrayTest.add( new String[] {coilWth});
//			        arrayTest.add( new String[] {coilIDia});
			        
			        // 중량계산식 = SQRT(중량*4*1000000/(24.279265*코일폭)+ 코일내경^2)
			        
//			        PosCalcVO calcVo = EasyAccess.getPosCalc(M47C0013, arrayTest);
//			        if(calcVo==null) {
//			            throw new PosException("코일외경[M47C0013] 계산에 실패하였습니다(코일중량[" + coilRmwWgt + "] 코일폭[" + coilWth + "] 코일내경[" + coilIDia + "])");
//			        }
//			      		    		        
//			        Object result = calcVo.getResultValue();
//			        String coilodia = C10STR_SPACE;
//			        if(!DbCommonUtil.isNull(result))
//			        	coilodia = result.toString();
//			        ctx.put(COL_ORD_COIL_ODIA, coilodia);
			       
//			        logger.logInfo("코일의 외경을 구한다. >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			    	//	        logger.logInfo("입력받은 코일중량\t\t\t\t\t"        + coilRmwWgt);
			    	//	        logger.logInfo("입력받은 환산폭\t\t\t\t\t\t\t\t"        + coilWth);
			    	//	        logger.logInfo("입력받은 코일내경\t\t\t\t\t\t\t"        + coilIDia);
//			    		        logger.logInfo("코일외경[M47C0013] 결과\t\t\t\t"        + result);
			         
//			        if( Double.compare(Double.parseDouble(coilodia),(Double.parseDouble(coilWth)*2)) >  0)
//			        {
//			        
//			        	setError(ctx	, logger , (ERRMSG_A782+ C10STR_MINUS + coilodia)
//						    , ERRCD_A782
//								, new String[]{ord_req_no, ord_req_ln, ERRCD_A782} , ERRMSG_CF68);//MS002007
//					//return PosBizControlConstants.FAILURE;
//			        }
//				
//			}
//	   }	
		
		//단중Min<=주문포장매수*단위중량<=단중Max Success
//		if((ActivityUtil.isValidData(prd_shp)) && (ActivityUtil.isValidData(ord_pak_unt_wgt_llv)) && (ActivityUtil.isValidData(ord_pak_sht_cnt)) &&
//		   (ActivityUtil.isValidData(ord_unt_wgt)) && (ActivityUtil.isValidData(ord_pak_unt_wgt_ulv)))
//		{
//		   if((Double.parseDouble(ord_pak_unt_wgt_llv) > 0)&& (Double.parseDouble(ord_pak_sht_cnt) > 0)
//				&& (Double.parseDouble(ord_unt_wgt) > 0)&& (Double.parseDouble(ord_pak_unt_wgt_ulv) > 0)&& prd_shp.equals( PRD_SHP_SHEET ))
//			{
//				String wgtllv    = DbCommonUtil.valueOf(ctx.get(COL_ORD_PAK_UNT_WGT_LLV )); //주문포장단중하한 (중량)
//				String wgtulv    = DbCommonUtil.valueOf(ctx.get(COL_ORD_PAK_UNT_WGT_ULV )); //주문포장단중상한 (중량)
//				String sheetCnt  = DbCommonUtil.valueOf(ctx.get(COL_ORD_PAK_SHT_CNT ));     //주문포장Sheet매수			
//				String untWgt    = DbCommonUtil.valueOf(ctx.get(COL_ORD_UNT_WGT   ));       //주문단위중량
//
//				
//	               if(((Double.parseDouble(sheetCnt) * Double.parseDouble(untWgt)) < Double.parseDouble(wgtllv)) ||
//	            	  ((Double.parseDouble(sheetCnt) * Double.parseDouble(untWgt)) > Double.parseDouble(wgtulv)))
//	 		        {
//	 			        
//			        	setError(ctx	, logger , ERRMSG_A783
//						    , ERRCD_A783
//								, new String[]{ord_req_no, ord_req_ln, ERRCD_A783} , ERRMSG_CF68);//MS002007
					//return PosBizControlConstants.FAILURE;
//			        }			
//				
//			}
		   
		   //단중Max - 단중Min < 2,000 Failure
//		   if((Double.parseDouble(ord_pak_unt_wgt_llv) > 0) && (Double.parseDouble(ord_pak_unt_wgt_ulv) > 0)&& prd_shp.equals( PRD_SHP_COIL ))
//			{
//				String wgtllv    = DbCommonUtil.valueOf(ctx.get(COL_ORD_PAK_UNT_WGT_LLV )); //주문포장단중하한 (중량)
//				String wgtulv    = DbCommonUtil.valueOf(ctx.get(COL_ORD_PAK_UNT_WGT_ULV )); //주문포장단중상한 (중량)
//				
//	               if((Double.parseDouble(wgtulv) - Double.parseDouble(wgtllv)) < 2000 )
//	 		        {
//	 			        
//			        	setError(ctx	, logger , ERRMSG_A784
//						    , ERRCD_A784
//								, new String[]{ord_req_no, ord_req_ln, ERRCD_A784} , ERRMSG_CF68);//MS002007
//					//return PosBizControlConstants.FAILURE;
//			        }			
//				
//			}
//		
//		}
		
		logger.logDebug("=== 1 ===");
				       
		Iterator masterChkIter 	= 	masterChkList.keySet().iterator(); // @Suppress Warning("rawtypes") or <?>

		logger.logDebug("=== 2 ===");
		String		columnName	= null;
		PosDecisionRuleVO result = null;
		//String  	prd_psl_yn	= null;
		String 		errmsg	= null;
		String 		qlt_dsn_err_cd	= null;
		String[] 	errParam 	= new String[2];
 					errParam[0] = ord_req_no;
					errParam[1] = ord_req_ln;
					
		while(masterChkIter.hasNext()){
			logger.logDebug("=== 3 ===");
			columnName	= (String)masterChkIter.next();
			logger.logDebug("columnName : "+columnName);
			result		= null;
			
			
			try{
				result	=	EasyAccess.getPosDecisionRuleLov( C10B2220, (String[])masterChkList.get(columnName), null );
				logger.logDebug("=== 4 ===");
				
	            if ( result.getRecordCount() > 0 )
	            {
	            	logger.logDebug("=== 5 ===");
	            	// 판단구조 에러여부 확인
	                while ( result.next() )
	                {
	                	qlt_dsn_err_cd	=	result.getRuleValueAt(C10STR_QLT_DSN_ERR_CD);
	    				errmsg	=	result.getRuleValueAt(C10STR_ErrMsg);

	    				logger.logDebug("에러코드 :" + errmsg);	    				
	    				errParam[1] = errmsg;               //errParam[2]
                        
	    				setError(ctx , logger ,errmsg , qlt_dsn_err_cd ,errParam , ERRMSG_CF68);//MS002007
	    				logger.logDebug("=== 6 ===");
	                }
	            }
	   
	            
			}catch(MasterDataException e){
				//setError(ctx , logger ,errmsg , qlt_dsn_err_cd ,errParam , ERRMSG_CF68);//MS002007	
				logger.logDebug("=== 7 ===");
			}


		}
		
		return false;
	}

	
	/**
	 * code가 존재하는지 확인하는 메소드이다. 
	 * 
	 * @param ctx - PosContext
	 * @param codeChkMap - 코드를 체그할 항목 Map
	 * @return Boolean 판별결과 
	 */
	public Boolean codeChk(PosContext ctx, HashMap codeChkMap){
		
		String 		codeID 	  = null;
		String[]	infoMsg	  = null;
		String		columName = null; 
		String		columnValue	 = null;
		Boolean		result 		 = null;
		
		String[] errParam = new String[3];
		errParam[0]	= ord_req_no;
		errParam[1]	= ord_req_ln;
		Iterator codeChkIter = codeChkMap.keySet().iterator();// @Suppress Warning("rawtypes") or <?>
		
		while(codeChkIter.hasNext()){
			codeID 	 = ((String)codeChkIter.next()).trim();
			infoMsg	 = ((String)codeChkMap.get(codeID)).split(C10STR_SLUSH);
			errParam[2]  = infoMsg[0];
			columName 	 = infoMsg[1];
//			columnValue	 = DbCommonUtil.valueOf(row.getAttribute(columName));
			if (!DbCommonUtil.isNull(ctx.get(columName)))	                    
				columnValue	 = ctx.get(columName).toString();
			
			logger.logDebug("=== 코드 체크 ===");
			logger.logDebug("코드명 : " + codeID);
			logger.logDebug("항목명 : " + columName);
			logger.logDebug("항목값 : " + columnValue);
			
			try{
	 			result		 =	EasyAccess.validateCodeValue(codeID, columnValue ,null);
	 			
	 			if(!result){
					setError(ctx, logger, infoMsg[2]+ ERRMSG_A130, infoMsg[0], errParam, ERRMSG_CF68);
					//return false; 
				}
			}catch (MasterDataException e) {
				setError(ctx, logger, infoMsg[2]+ ERRMSG_A201, infoMsg[0],errParam, ERRMSG_CF68);
				//return false; 
			}   	
		}
		
		return true;
	}
	/**
	 * 에러를 셋팅하는 메소드 : 전체 주문에러체크 항목의 에러 사항들을 ,로 구분하여 모두 ctx에 리턴한다.
	 * @param ctx - PosContext
	 * @param logger - PosLog
	 * @param errMsg - 에러 메세지
	 * @param errCode - 에러코드
	 */
	public void setError(PosContext ctx	, PosLog logger, String errMsg, String errCode
			,String[] errParam	, String errMsgCD){
			logger.logError(errMsg);
			//ctx.put(COL_INQRY_TOT_EXAM_RST_1, errMsg);
			ctx.put(C10STR_QLT_DSN_ERR_CD 	, ctx.get(C10STR_QLT_DSN_ERR_CD) + C10STR_COMMA + errCode);  //전체주문에러 ctx리턴
			//8-20 변경버전
			if(!DbCommonUtil.isNull(errMsg) || (String)errMsg != ""){
				if(DbCommonUtil.isNull((String)ctx.get(COL_XMSGS))|| ((String)ctx.get(COL_XMSGS)) =="" ){
					ctx.put(COL_XMSGS,(errMsg).replace("null", ""));	
				}
				else{
					ctx.put
					(COL_XMSGS,((String)ctx.get(COL_XMSGS)+ C10STR_COMMA + errMsg).replace("null", ""));	
				}
										
			}
//8-20 변경이전 버전						
//			if(DbCommonUtil.isNull(ctx.get(COL_XMSGS))){
//				logger.logDebug("1111"+ ctx.get(COL_XMSGS)+" ===");	
//				//ctx.put(COL_XMSGS,errMsg.replace("null", ""));
//			}else{
//				logger.logDebug("22222"+ ctx.get(COL_XMSGS)+" ===");	
//				ctx.put(COL_XMSGS,((String)ctx.get(COL_XMSGS)+ C10STR_COMMA + errMsg).replace("null", ""));
//				
//			}
	}

}

