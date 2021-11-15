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
try {
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
				in.printStackTrace();
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

			// Making Screen Message For User 
			out.print("<userdata name=\"appMsg\">");
			out.print((String)ctx.get("appMsg")); 
			out.println("</userdata>");

			//List인 경우와 PosRowSet인 두 가지 경우에 대해 처리한다.
			if (result instanceof List){
				List rowSetList = (List)result;

				Map rowMap = null;
				int index = startNum;
				int rowSetSize = rowSetList.size();
				Object cellData = null;
				String str_row_id = "";
				
				if(rowSetList.size() > 0){
					for(int i = 0, listSize = rowSetList.size(); i < listSize; i++){
						rowMap = (Map)rowSetList.get(i);
						str_row_id = resultKey+"_"+index; //추가
						out.println(DhtmlxConstantsIF.ROW_STARTTAG.replaceAll("#rowid",resultKey+"_"+index));

						for(int j = 0 ; j < colOrder.length; j++) {
							cellData = rowMap.get(colOrder[j]);
							out.print("<cell ");
							if(colOrder[j].equals("FILE_ADD") && rowMap.get("FILE_ADD") != null && "Y".equals(rowMap.get("FILE_ADD").toString())){
								out.print(" title='파일보기' ");
							}else if(colOrder[j].equals("FILE_ADD") && (rowMap.get("FILE_ADD") == null || "N".equals(rowMap.get("FILE_ADD").toString()))){
								out.print(" title='파일추가' ");
							}else{
							  out.print(" ");
							}
							out.print(" ><![CDATA[");
							
							//이미지 처리 로직 추가
							if(colOrder[j].equals("FILE_ADD") && rowMap.get("FILE_ADD") != null && "Y".equals(rowMap.get("FILE_ADD").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/excel.gif' onClick='doFileUpload("+i+")' border=0></a>");
							}else if(colOrder[j].equals("FILE_ADD") && (rowMap.get("FILE_ADD") == null || "N".equals(rowMap.get("FILE_ADD").toString()))){
								out.print("<a><img src='./dhtmlx/codebase/imgs/add.gif' onClick='doFileUpload("+i+")' border=0></a>");
							}else if(colOrder[j].equals("IMAGE_YN") && "Y".equals(rowMap.get("IMAGE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("FILE_YN") && "Y".equals(rowMap.get("FILE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp1('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("DOC_YN") && "Y".equals(rowMap.get("DOC_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp2('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("OTH_YN") && "Y".equals(rowMap.get("OTH_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp3('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("WTY_ENG_YN") && "Y".equals(rowMap.get("WTY_ENG_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp4('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("WTY_KOR_YN") && "Y".equals(rowMap.get("WTY_KOR_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp5('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("DFILE_YN") && "Y".equals(rowMap.get("DFILE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp6('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("STD_YN") && "Y".equals(rowMap.get("STD_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp7('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("KIMG_YN") && "Y".equals(rowMap.get("KIMG_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp8('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("KFILE_YN") && "Y".equals(rowMap.get("KFILE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save.gif' onClick=\"doImgPopUp9('"+str_row_id+"')\" border=0></a>");	
							}else if(colOrder[j].equals("IMAGE_YN") && rowMap.get("IMAGE_YN") != null && !"Y".equals(rowMap.get("IMAGE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("FILE_YN") && rowMap.get("FILE_YN") != null && !"Y".equals(rowMap.get("FILE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp1('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("DOC_YN") && rowMap.get("DOC_YN") != null && !"Y".equals(rowMap.get("DOC_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp2('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("OTH_YN") && rowMap.get("OTH_YN") != null && !"Y".equals(rowMap.get("OTH_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp3('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("WTY_ENG_YN") && rowMap.get("WTY_ENG_YN") != null && !"Y".equals(rowMap.get("WTY_ENG_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp4('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("WTY_KOR_YN") && rowMap.get("WTY_KOR_YN") != null && !"Y".equals(rowMap.get("WTY_KOR_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp5('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("DFILE_YN") && rowMap.get("DFILE_YN") != null && !"Y".equals(rowMap.get("DFILE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp6('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("STD_YN") && rowMap.get("STD_YN") != null && !"Y".equals(rowMap.get("STD_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp7('"+str_row_id+"')\" border=0></a>");
							}else if(colOrder[j].equals("KIMG_YN") && rowMap.get("KIMG_YN") != null && !"Y".equals(rowMap.get("KIMG_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp8('"+str_row_id+"')\" border=0></a>"); //
							}else if(colOrder[j].equals("KFILE_YN") && rowMap.get("KFILE_YN") != null && !"Y".equals(rowMap.get("KFILE_YN").toString())){
								out.print("<a><img src='./dhtmlx/codebase/imgs/save_dis.gif' onClick=\"doImgPopUp9('"+str_row_id+"')\" border=0></a>"); ///	
							}else if(colOrder[j].equals("RMTL_IMG_NM") && rowMap.get("RMTL_IMG_NM") != null && !"Y".equals(rowMap.get("RMTL_IMG_NM").toString())) {
								out.print(""); 
						    }else if(colOrder[j].equals("DEL_IMG")){
								out.print("<a><img src='./dhtmlx/codebase/imgs/btn_clear.gif' onClick='doImgDel("+i+","+j+")' border=0></a>");							
							}else{
								if (cellData != null)										out.print(cellData); 
								else if (DhtmlxConstantsIF.CHK_TYPE.equals(colOrder[j]))	out.print("0"); 
								else if (DhtmlxConstantsIF.NUM_TYPE.equals(colOrder[j]))	out.print(index); 
								else							        					out.print(""); 
							}
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
out.println("<userdata name='blank-row-count'>"+blankRowCnt+"</userdata>");	
out.println(DhtmlxConstantsIF.ROWS_ENDTAG);
%>
