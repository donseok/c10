<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "com.posdata.glue.master.easyaccess.easymaster.EasyAccess" %>
<%@ page import = "com.posdata.glue.master.easyaccess.returnType.PosRuleVO" %>

<%
	//품명&도금량 코드를 부모페이지에서 받아온다.
	String prd_nm_cd = request.getParameter("PRD_NM_CD");
	String gw_asg_cd = request.getParameter("GW_ASG_CD");

	//EASYACCESS 에 넘길 파라메터는 배열로 넘긴다.
	String[] valList = {prd_nm_cd, gw_asg_cd};
	String wk_gw_tot_uvl = "";
	
	try{ 
		//MASTER 기준 데이터를 읽어온다.
		PosRuleVO result = EasyAccess.getPosRule("C10A1061", valList, null);
		
		if(result.getRecordCount() > 0){
			 wk_gw_tot_uvl = result.getRuleValueAt("WK_GW_TOT_ULV");     //부착량하한
			 response.getWriter().write(wk_gw_tot_uvl);
		}
	}catch(Exception e){
	    e.printStackTrace();
	}
%>