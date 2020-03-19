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
    String[] columnInfLstName = "주문번호,주문행번,품질설계상태코드,플랜트구분,품명코드,제품형태,유통경로,주문종류,주문제품등급,주문용도코드,고객사코드,수요가코드,최종수요가코드,고객사양서번호,규격기관,규격약호,규격년도,규격명,규격FullName,주문생칫수,주문환산두께,주문환산폭,주문환산길이,고객요청납기일,주문예정납기일,주문납기시작일,주문납기종료일,도금량지정코드,CCLBOM번호,색상코드전면,색상코드후면,주문원판규격약호,주문조도코드,주문Spangle구분,주문권취방법,주문표면처리코드,주문조질도,주문Edge지정구분,주문두께구분,주문비중,중량결정법구분,주문내경링종류구분,EMBOSS무늬,주문보호필름상세코드,주문보호필름폭,주문보호필름부착위치코드,주문중량단위,주문행번중량,주문Sheet매수,주문포장Sheet매수,주문포장단중하한값,주문포장단중상한값,주문인도허용차하한값,주문인도허용차상한값,주문포장길이하한값,주문포장길이상한값,주문정포장하한값,주문정포장상한값,주문정포장매수하한값,주문정포장매수상한값,주문포장당매수,주문포장당중량,주문소포장중량,주문소포장혼입율,주문단위중량,주문포장방법,주문코일내경,주문코일외경,주문두께공차하한값,주문두께공차상한값,주문폭공차하한값,주문폭공차상한값,주문길이공차하한값,주문길이공차상한값,도막두께전면Total,도막두께후면Total,수지구분전면,수지구분후면,광택도코드전면,광택도코드후면,코팅방식,고객요청압연두께,주문두께관리코드,주문폭관리코드,주문길이관리코드,고객정의색상,긴급재구분,주문접수일,주문Sheet적재방법,주문Slit조수,주문조합폭1,주문조합폭2,주문조합폭3,주문조합폭4,주문조합폭5,주문조합폭6,주문조합폭7,주문조합폭8,조당최대중량,위탁임가공여부,Tag유형,국가코드,주문특기사항,Tag제품명,TagPO번호,Tag도착지,TagSIZE,Tag규격약호,Tag부착량기호,Tag색상전면,Tag색상후면,Tag특수마킹형태,원자재선호도,Back마킹,주문수정일,주문확정일,주문등록자,영업팀코드,MaterialCode,ClassCode,SubClassCode,품질설계완료일시,품질설계지시일시,품질설계자ID,재질코드,원자재코드,원자재등급,냉연제조표준번호,통과공정번호,인수도규격,주문종결구분,주문종결일,주문종결자,품질설계확정일시,품질설계확정자ID,품질재설계일시,품질재설계자ID,품질설계에러여부,품질설계유무,품질설계확정구분,원자재코드1,원자재코드2,냉연제조표준번호1,냉연제조표준번호2,주문취소원인코드,주문종료및취소사유,두께보정단위,제품두께계산적용코드,외관검사기준코드,TagPO번호2,계약선적월,서비스카드발행여부,포장메세지코드,영업그룹코드,주문조합폭9,주문조합폭10,보호필름미부착폭WS,보호필름미부착폭DS,TagPartNo,MO전환주문여부,톤당길이,주문반송구분,주문반송자,주문반송일시,주문반송원인,소재생산주문여부,포장재중량,품질설계텍스트,자동확정구분여부,자동확정검증여부,자동확정검증일자,자동확정검증자,설계보류여부,길이관리제품여부,길이관리제품FROM,길이관리제품TO,보론첨가유무,주문반복여부,주문반복번호,주문반복행번,주문복사금지,반제품포장방법".split(",");
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