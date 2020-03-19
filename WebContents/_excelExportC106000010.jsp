<%@ page contentType="application/vnd.ms-excel;charset=utf-8" %>
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
 * @LastModifyDate: 20121205
 * @LastModifier  : 김종화
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
    String[] columnInfLstName = "의뢰번호,접수번호,고객요청색상,수지Text,수지분석요망,시편송부여부,도막두께,샘플광,광택도코드,사용용도,영업담당자,고객사,사용지역,품명,품명구분,영업요청일,영업승인일,비고,도료업체,도료업체명,수지구분,시편개발의뢰일,시편개발예정일,시편개발완료일,시편개발송부일,시편송부정보,승인여부,색상코드,CCLBOM번호,CCLBOM등록일,색구분,색구분명,유사색상진행여부,설계담당,비고,셈플담당자,담당자연락처".split(",");
    
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