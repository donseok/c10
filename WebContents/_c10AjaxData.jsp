<%@ page contentType="text/xml;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "java.util.*" %>
<%@page import = "com.posdata.glue.context.PosContext" %>
<%@page import = "com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF" %> 
<%@page import = "com.posdata.glue.dao.vo.*" %>
<%@page import = "com.posdata.glue.web.control.*" %>
<%@page import = "com.posdata.glue.util.log.PosLog" %>
<%

//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
String columnInfo = null;
out.println("<rows>");

try{
	PosContext ctx = (PosContext) request.getAttribute(PosWebConstants.CONTEXT);
	int startNum = 1;
	
	String resultKey = "xml-result";
	columnInfo = (String)ctx.get("column-info");
	String [] colOrder = columnInfo.split(",");
	
	
	if(resultKey != null && colOrder != null) {
		
		Object result = ctx.get(resultKey);
		
		if(result != null ){
			
			/* List인 경우와 PosRowSet인 두 가지 경우에 대해 처리한다. */
			if (result instanceof List){
				List rowSetList = (List)result;

				Map rowMap = null;
				int index = startNum;
				Object cellData = null;
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
			} else if(result instanceof String){
				out.println("<ROWS><ROW><CELL>" + result + "</CELL></ROW></ROWS>");
				
				
			} else {
				throw new Exception("This resultkey type can not support! Type:"+result);
			}			
		}
	} else if (resultKey == null) {
		throw new Exception("Context didn't have "+DhtmlxConstantsIF.XML_RESULT);
	} else {
		throw new Exception("Context didn't have "+DhtmlxConstantsIF.COLUMN_ORDER);
	}

	
	//String lov = (String)ctx.get("lov-result");
	
	//out.print(lov);
    //out.flush();
} catch (Exception e){
	e.printStackTrace();
}
out.println(DhtmlxConstantsIF.ROWS_ENDTAG);
%>