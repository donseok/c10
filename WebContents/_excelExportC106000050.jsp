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
 * @LastModifyDate: 20160317
 * @LastModifier  : 이돈석
 * @LastVersion   : 1.0
 *    2012-12-05   김종화
 *        1.0      최초 생성
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
    String[] columnInfLstName = "사용여부,칼라코드,칼라코드명,부재료구분코드,부재료구분,수지타입,수지타입명,광택도코드,광택도명,광택도하한값,광택도상한값,실광택값,작업점도,도막두께,PRINTINKTYPE,PRINTINKTYPE명,고형분,도료비중,용재비중,신나코드,도료원단위,PMT,L,A,B,표준색상명,LAMINA유형,LAMINA유형명,LAMINA접착제코드(1C),LAMINA접착제신나코드(1C),LAMINA접착제코드(2C),LAMINA접착제신나코드(2C),LAMINA필름두께코드,LAMINA필름두께명,보호필름광택코드,보호필름광택도명,보호필름두께코드,보호필름두께명,보호필름재질코드,보호필름재질명,보호필름SUS점착력코드,보호필름SUS점착력명,제품점착력코드,제품점착력명,비고,등록자,등록일,수정자,수정일,통합컬러코드,구칼라부자재코드,구수지타입,구광택도코드,구도막두께,도료업체사용여부,도료업체코드,도료업체명,고형분,도료비중,용재비중,도료원단위".split(",");
    String[] columnInfLst = ((String)ctx.get("column-info")).split(",");
    %>
    <bold> 
    <tr >
<%    	
    	for(int i =0; i < columnInfLstName.length; i++)
    	{
%>

		<td >
			<%=columnInfLstName[i]%>	
		</td>
    		
<%    		
    	}
%>    			
    </tr>
	</bold>
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