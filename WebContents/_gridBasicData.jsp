<%@ page contentType="text/xml;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@page import = "java.util.*" %> 
<%@page import = "java.sql.Types" %> 
<%@page import = "com.posdata.glue.context.PosContext" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %> 
<%@page import = "com.posdata.glue.web.control.*" %> 
<%@page import = "com.posdata.glue.util.log.PosLog" %>

<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 

<%
//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
String columnInfo = null;
String blankRowCntParam = null;
int blankRowCnt = 0;
Throwable error = null;
PosContext ctx = null;
try
{
    ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    if (ctx == null) {
		out.println("<rows>");
		String service = request.getParameter("ServiceName");
		String message = "Context is null, because Service ["+service+"] did not execute or has a problem!";     
		throw new Exception(message);
	}

	String posStart = request.getParameter(DhtmlxConstantsIF.START_POINT);
	String totalRows = (String)ctx.get(DhtmlxConstantsIF.TOTAL_ROW_COUNT);
	int startNum = 1;
	if(totalRows == null) {
		out.println("<rows>");
	} else {
		String rowsHeader = DhtmlxConstantsIF.ROWS_STARTTAG.replaceAll("#total",totalRows);
		if (posStart == null) posStart = "0";
			rowsHeader = rowsHeader.replaceAll("#pos",posStart);
			out.println(rowsHeader);   
			try{
				startNum = Integer.parseInt(posStart)+1;
			}catch (Exception in) {	
		}
	}
	String resultKey = "xml-result";
	columnInfo = ctx.get("column-info") != null ?  (String) ctx.get("column-info") : "";
	String [] colOrder = columnInfo.split(",");
	String []blkRowCnt = (String [])ctx.get("blank-row-count");
	blankRowCntParam = (blkRowCnt != null && !blkRowCnt[0].equals("null") && !blkRowCnt[0].equals("")) ? blkRowCnt[0] : "0";
    blankRowCnt = Integer.parseInt(blankRowCntParam);
	if(resultKey != null && colOrder != null) {
		Object result = ctx.get(resultKey);
		if(result != null ){

			/* Making Screen Message For User */
			out.print("<userdata name=\"appMsg\">");

			out.print(ctx.get("appMsg") != null ? ctx.get("appMsg") : ""); 
			out.println("</userdata>");
			/* List인 경우와 PosRowSet인 두 가지 경우에 대해 처리한다. */
			if (result instanceof List){
				List rowSetList = (List)result;

				Map rowMap = null;
				int index = startNum;
				int rowSetSize = rowSetList.size();
				Object cellData = null;
				if(rowSetList.size() > 0){
					for(int i = 0, listSize = rowSetList.size(); i < listSize; i++){
						rowMap = (Map)rowSetList.get(i);
						out.println(DhtmlxConstantsIF.ROW_STARTTAG.replaceAll("#rowid",resultKey+"_"+index));						
						for(int j = 0 ; j < colOrder.length; j++) {
							cellData = rowMap.get(colOrder[j]);
							
							out.print(DhtmlxConstantsIF.CELL_STARTTAG);

							if (cellData != null)										out.print(cellData); 
							else if (DhtmlxConstantsIF.CHK_TYPE.equals(colOrder[j]))	out.print("0"); 
							else if (DhtmlxConstantsIF.NUM_TYPE.equals(colOrder[j]))	out.print(index); 
							else							        					out.print(""); 

							out.println(DhtmlxConstantsIF.CELL_ENDTAG);
						}
						
						
						out.println(DhtmlxConstantsIF.ROW_ENDTAG);
						index++;
						if(index > 100 && index%100 == 0) out.flush();
					}
					for(int k = rowSetSize; k < blankRowCnt; k++) {
 						out.println("<row id=\""+k+"\">");
						for(int t = 0; t < colOrder.length; t++) {
							out.print("<cell type=\"ro\">");
							out.print("</cell>");
						}
						out.println("</row>");
					}
				}else{
					for(int k = 0 ; k < blankRowCnt; k++) {
 						out.println("<row id=\""+k+"\">");
						for(int t = 0; t < colOrder.length; t++) {
							out.print("<cell type=\"ro\">");
							out.print("</cell>");
						}
						out.println("</row>");
					}				
				}
			} else if(result instanceof String){
				out.println(result);
				
			} else {
				throw new Exception("This resultkey type can not support! Type:"+result);
			}
		} else {
			throw new Exception("Context didn't have a result with this key "+resultKey);
		}
	} else if (resultKey == null) {
		throw new Exception("Context didn't have "+DhtmlxConstantsIF.XML_RESULT);
	} else {
		throw new Exception("Context didn't have "+DhtmlxConstantsIF.COLUMN_ORDER);
	}
}catch (Exception e){
	e.printStackTrace();
	error = ctx.getException();
	if(error != null) {
		columnInfo = request.getParameter("column-info") != null ?  request.getParameter("column-info") : "";
		blankRowCntParam = request.getParameter("blank-row-count") != null ?  request.getParameter("blank-row-count") : "";
		blankRowCnt = Integer.parseInt(blankRowCntParam);
		out.println("<rows>");
		out.print(DhtmlxConstantsIF.ERROR_STARTTAG);
		out.print("<![CDATA["+error.getMessage()+"]]>");
		out.println(DhtmlxConstantsIF.ERROR_ENDTAG);
		out.println("<userdata name='column-info'>"+columnInfo+"</userdata>");	
		out.println("<userdata name='blank-row-count'>"+blankRowCnt+"</userdata>");	
		out.println(DhtmlxConstantsIF.ROWS_ENDTAG); 
	} 
} 
out.println("<userdata name='column-info'>"+columnInfo+"</userdata>");	
out.println("<userdata name='blank-row-count'>"+blankRowCnt+"</userdata>");	
out.println(DhtmlxConstantsIF.ROWS_ENDTAG);
%>