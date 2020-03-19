<%@ page contentType="text/xml;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@page import = "java.util.*" %> 
<%@page import = "java.sql.Types" %> 
<%@page import = "com.posdata.glue.context.PosContext" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %> 
<%@page import = "com.posdata.glue.web.control.*" %> 
<%@page import = "com.posdata.glue.util.log.PosLog" %>

<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 
<%
String columnInfo = request.getParameter("column-info")	!=null ? request.getParameter("column-info") : "";
String columnName = request.getParameter("column-name")	!=null ? request.getParameter("column-name") : "";
String blankRowCnt = request.getParameter("blank-row-count") !=null ? request.getParameter("blank-row-count") : "0";
try
{   
	out.println("<rows>");
	out.println("<head>");
	out.println("<beforeInit>");
	out.println("<call command='setImagePath'><param>dhtmlx/codebase/imgs/</param></call>");
	out.println("<call command='setSkin'><param>dhx_skyblue</param></call>");
	out.println("<call command='enableSmartRendering'><param>true</param></call>");
	out.println("<call command='setAwaitedRowHeight'><param>22</param></call>");
	out.println("</beforeInit>");

	int rowCnt = Integer.parseInt(blankRowCnt);
	int width = 0;
	if(columnInfo != null) {
		String[] colCodeOrder = columnInfo.split(","); 
		String[] colNameOrder = columnName.split(","); 
		for(int j = 0 ; j < colCodeOrder.length; j++) {
			if(colNameOrder[j].toString() == null || "".equals(colNameOrder[j].toString())){
				if( j == 0){
					width = 15;
				}else if( j == 1 || j == 2 || j == 3 || j == 4 || j == 6 || j == 7){
					width = 8;
				}else if(j == 5){
					width = 20;
				}else{
					width = 13;
				}
				out.println("<column id='"+colCodeOrder[j]+"' sort='sort_str_custom' align='center' width='"+width+"' type='ro'>"+colCodeOrder[j]+"</column>");	
			}else{
				width = colNameOrder[j].toString().getBytes().length;
				out.println("<column id='"+colCodeOrder[j]+"' sort='sort_str_custom' align='center' width='"+width+"' type='ro'>"+colNameOrder[j]+"</column>");			
			}
		}
		out.println("<settings>");
		out.println("<colwidth>%</colwidth>");
		out.println("</settings>");
		out.println("</head>");
		out.println("<userdata name='column-info'>"+columnInfo+"</userdata>");
		out.println("<userdata name='blank-row-count'>"+blankRowCnt+"</userdata>");
		System.out.println("rowCnt==>"+rowCnt);
		for(int k = 0; k < rowCnt; k++) {
			out.println("<row id=\""+k+"\">");
			for(int t = 0; t < colCodeOrder.length; t++) {
				out.print("<cell type=\"ro\">");
				out.print("</cell>");
			}
			out.println("</row>");
		}
	}
}catch (Exception e){
	e.printStackTrace();
}
	out.println("</rows>");
%>