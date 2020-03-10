<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>

<%
/*
 * @FileName      : ExcelExport
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20120830
 * @LastModifier  : ±èÁ¤Áø
 * @LastVersion   : 1.0
 *    2012-08-30   ±èÁ¤Áø
 *        1.0      ÃÖÃÊ »ý¼º
 */
	System.out.println("jsp ------------------------------------------------");
    PosContext ctx=(PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale=(Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String fileName = (((String)ctx.get("ServiceName")).split("-"))[0] + ".xls";
    
    response.setHeader("Content-Disposition", "attachment;filename="+fileName);
    out.clearBuffer();

%>
<html>
<head>
<title></title>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">

  <table border=1>
    <%
    PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("xml-result") : null;
    PosRow row = null;
    String[] columnInfLst = ((String)ctx.get("column-info")).split(",");
    %>
    
    <tr>
<%    	
    	for(int i =0; i < columnInfLst.length; i++)
    	{
%>

		<td>
			<%=columnInfLst[i]%>	
		</td>
    		
<%    		
    	}
%>    			
    </tr>

<%
    if( rowSet!=null ){
        int rowCnt = 0;
    
        
        while(rowSet.hasNext())
        {
        	
        	
        	
        	row = rowSet.next();
        	
%>
    <tr>
<%
		for(int i = 0; i < columnInfLst.length; i++)
		{
			
			String temp = "";
			Object obj = row.getAttribute(columnInfLst[i])==null?null:row.getAttribute(columnInfLst[i]);
			if(obj != null)
			{
				
				if ( obj instanceof BigDecimal)
				{
					temp = String.valueOf(obj);
								
					
				}
				else
				{
					temp = (String)row.getAttribute(columnInfLst[i]);
				}
			}
%>
    	<td style="mso-number-format:'\@'"><%=temp%></td>
<%
		}
%>
    
    </tr>
<%
            rowCnt++;
        }
    }
    
%>
  </table>
 
</body>
</html>