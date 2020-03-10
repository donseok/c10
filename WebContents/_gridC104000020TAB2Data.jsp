<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@page import = "java.util.*" %> 
<%@page import = "java.sql.Types" %> 
<%@page import = "com.posdata.glue.context.PosContext" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %> 
<%@page import = "com.posdata.glue.web.control.*" %> 
<%@page import = "com.posdata.glue.util.log.PosLog" %>

<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 

<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
String columnInfo = null;
try
{
	PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    
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
	columnInfo = (String )ctx.get("column-info");
	String [] colOrder = columnInfo.split(",");

	if(resultKey != null && colOrder != null) {
		Object result = ctx.get(resultKey);
		if(result != null ){

			/* Making Screen Message For User */
			out.print("<userdata name=\"appMsg\">");
			out.print((String)ctx.get("appMsg")); 
			out.println("</userdata>");

			/* List인 경우와 PosRowSet인 두 가지 경우에 대해 처리한다. */
			if (result instanceof List){
				List rowSetList = (List)result;

				Map rowMap = null;
				Map LastrowMap = null;
				int index = startNum;
				Object mo_no = "";
				Object mo_no2 ="";
				Object cellData = null;
				Object LastcellData = null;
				for(int i = 0, listSize = rowSetList.size(); i < listSize; i++){
					rowMap = (Map)rowSetList.get(i);
					LastrowMap = (Map)rowSetList.get(listSize-1);
					out.println(DhtmlxConstantsIF.ROW_STARTTAG.replaceAll("#rowid",resultKey+"_"+index));
					
					for(int j = 0 ; j < colOrder.length; j++) {
						cellData = rowMap.get(colOrder[j]);
						//out.print(DhtmlxConstantsIF.CELL_STARTTAG);
						out.print("<cell ");
						//보증사양과 고객/규격사양이 다를경우 빨강으로 표시
						if(i < 2 && j > 0)
						{
							LastcellData = LastrowMap.get(colOrder[j]);
							if(!cellData.equals( LastcellData ))
							{
								out.print(" bgColor='#FF6666' "); 
							}
						}
		
						out.print(" ><![CDATA[");						
						
						if (cellData != null){
							out.print(cellData); 
						}
						else if (DhtmlxConstantsIF.CHK_TYPE.equals(colOrder[j])){
							out.print("0");
						}
						else if (DhtmlxConstantsIF.NUM_TYPE.equals(colOrder[j])){	
							out.print(index);
						}
						else{
							out.print("");
						}

						out.println(DhtmlxConstantsIF.CELL_ENDTAG);
					}
					
					
					out.println(DhtmlxConstantsIF.ROW_ENDTAG);
					index++;
					if(index > 100 && index%100 == 0) out.flush();
				}
			} else if(result instanceof String){
				out.println("<ROWS><ROW><CELL>" + result + "</CELL></ROW></ROWS>");
				
				
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
	
	Throwable error = ctx.getException();
	if(error != null) {

		out.print(DhtmlxConstantsIF.ERROR_STARTTAG);
		out.print("<![CDATA["+error.getMessage()+"]]>");
		out.println(DhtmlxConstantsIF.ERROR_ENDTAG);
	}
}catch (Exception e){
	e.printStackTrace();
	out.print(DhtmlxConstantsIF.ERROR_STARTTAG);
	out.print("<![CDATA["+e.getMessage()+"]]>");
	out.println(DhtmlxConstantsIF.ERROR_ENDTAG);
}

out.println("<userdata name='column-info'>"+columnInfo+"</userdata>");	
out.println(DhtmlxConstantsIF.ROWS_ENDTAG);
%>
