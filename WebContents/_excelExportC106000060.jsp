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
    String[] columnInfLstName = "CCLBOM번호,CCLBOM사용여부,코팅방식,칼라표면처리코드,PrintPatternCode,색상코드전면,색상코드후면,색상코드SUB,색상코드Chemical,도막두께전면Total,도막두께후면Total,광택도코드전면,광택도코드후면,수지구분전면,수지구분후면,상세색상명,수지구분전면1Coat,수지구분전면2Coat,수지구분전면3Coat,수지구분전면4Coat,수지구분후면1Coat,수지구분후면2Coat,수지구분후면3Coat,수지구분후면4Coat,수지구분Lamina,색상코드전면1Coat,색상코드전면2Coat,색상코드전면3Coat,색상코드전면4Coat,색상코드후면1Coat,색상코드후면2Coat,색상코드후면3Coat,색상코드후면4Coat,색상코드Lamina,도막두께전면1Coat,도막두께전면2Coat,도막두께전면3Coat,도막두께전면4Coat,도막두께후면1Coat,도막두께후면2Coat,도막두께후면3Coat,도막두께후면4Coat,도막두께Lamina,광택도코드전면1Coat,광택도코드전면2Coat,광택도코드전면3Coat,광택도코드전면4Coat,광택도코드후면1Coat,광택도코드후면2Coat,광택도코드후면3Coat,광택도코드후면4Coat,광택도코드Lamina,광택도전면1Coat하한값,광택도전면1Coat상한값,광택도전면2Coat하한값,광택도전면2Coat상한값,광택도전면3Coat하한값,광택도전면3Coat상한값,광택도전면4Coat하한값,광택도전면4Coat상한값,광택도후면1Coat하한값,광택도후면1Coat상한값,광택도후면2Coat하한값,광택도후면2Coat상한값,광택도후면3Coat하한값,광택도후면3Coat상한값,광택도후면4Coat하한값,광택도후면4Coat상한값,광택도Lamina하한값,광택도Lamina상한값,작업점도전면1Coat,작업점도전면2Coat,작업점도전면3Coat,작업점도전면4Coat,작업점도후면1Coat,작업점도후면2Coat,작업점도후면3Coat,작업점도후면4Coat,PMT전면1Coat,PMT전면2Coat,PMT전면3Coat,PMT전면4Coat,PMT후면1Coat,PMT후면2Coat,PMT후면3Coat,PMT후면4Coat,PMTLamina,신나코드전면1Coat,신나코드전면2Coat,신나코드전면3Coat,신나코드전면4Coat,신나코드후면1Coat,신나코드후면2Coat,신나코드후면3Coat,신나코드후면4Coat,용제비중전면1Coat,용제비중전면2Coat,용제비중전면3Coat,용제비중전면4Coat,용제비중후면1Coat,용제비중후면2Coat,용제비중후면3Coat,용제비중후면4Coat,도료비중전면1Coat,도료비중전면2Coat,도료비중전면3Coat,도료비중전면4Coat,도료비중후면1Coat,도료비중후면2Coat,도료비중후면3Coat,도료비중후면4Coat,고형분전면1Coat,고형분전면2Coat,고형분전면3Coat,고형분전면4Coat,고형분후면1Coat,고형분후면2Coat,고형분후면3Coat,고형분후면4Coat,도료원단위전면1Coat,도료원단위전면2Coat,도료원단위전면3Coat,도료원단위전면4Coat,도료원단위후면1Coat,도료원단위후면2Coat,도료원단위후면3Coat,도료원단위후면4Coat,도료원단위Lamina,보호필름상세코드,보호필름광택코드,보호필름두께코드,보호필름재질코드,보호필름SUS점착력코드,보호필름제품점착력코드,Lamina유형,Lamina접착제코드(1C),Lamina접착제신나코드(1C),Lamina접착제코드(2C),Lamina접착제신나코드(2C),Lamina필름두께코드,Lamina필름폭코드,PrintRollNo전면1도,PrintRollNo전면2도,PrintRollNo전면3도,PrintRollNo전면4도,PrintInkCode전면1도,PrintInkCode전면2도,PrintInkCode전면3도,PrintInkCode전면4도,PrintRollPatternCode전면1도,PrintRollPatternCode전면2도,PrintRollPatternCode전면3도,PrintRollPatternCode전면4도,Print원단위전면1도,Print원단위전면2도,Print원단위전면3도,Print원단위전면4도,Print용도코드,아농코드,아농원단위,럭스틸브랜드코드,주공정코드,대체공정코드1,대체공정코드2,대체공정코드3,무독성구분,재단선유무,품질설계확정구분,Lamina접착제원단위(1C),Lamina접착제원단위(2C),UniTexRollNo,UniTexPatternCode,PickUpRollNo,PrintRollNo후면1도,PrintRollNo후면2도,PrintRollNo후면3도,PrintRollNo후면4도,PrintInkCode후면1도,PrintInkCode후면2도,PrintInkCode후면3도,PrintInkCode후면4도,PrintRollPatternCode후면1도,PrintRollPatternCode후면2도,PrintRollPatternCode후면3도,PrintRollPatternCode후면4도,Print원단위후면1도,Print원단위후면2도,Print원단위후면3도,Print원단위후면4도,CCLBOM보증여부,핀트종류,불연속패턴및폭관리코드, ImprintingRollNo,ImprintingRollNo후면,고객사코드,주문용도코드,보호필름상세코드,색차전면하한값,색차전면상한값,색차후면하한값,색차후면상한값,물성기준연필경도전면,물성기준연필경도후면,물성기준MEK전면,물성기준MEK후면,칼라Bending전면기준코드,칼라Bending시험전면평점,칼라Bending후면기준코드,칼라Bending시험후면평점,보호필름점착력하한,보호필름점착력상한,CCL공정품질메시지,UniGlassFilm코드,구보호필름코드,등록자,등록일시,수정자,수정일시".split(",");
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