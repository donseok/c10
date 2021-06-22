<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@page import="java.io.BufferedInputStream" %>
<%@page import="java.io.FileOutputStream" %>
<%@page import="java.io.IOException" %>
<%@page import="java.text.DateFormat" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Calendar" %>
<%@page import="java.util.Date" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCellStyle" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFont" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@page import="org.apache.poi.ss.usermodel.BorderStyle" %>
<%@page import="org.apache.poi.ss.usermodel.CellStyle" %>
<%@page import="org.apache.poi.ss.usermodel.Font" %>

<%
	// 파일 이름 설정
  String fileNm = new String(request.getParameter("FILENM").getBytes("8859_1"), "utf-8");
  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
  Calendar c1 = Calendar.getInstance();
  String yyyymmdd = sdf.format(c1.getTime());
  String fileName = fileNm +"_"+ yyyymmdd +".xls";
  fileName = URLEncoder.encode(fileName,"UTF-8"); // UTF-8로 인코딩

  // 다운로드 되는 파일명 설정
  //response.setContentType("ms-vnd/excel");
  //response.setContentType("application/ms-excel; charset=UTF-8");
  //response.setCharacterEncoding("UTF-8");
  response.reset();
  response.setContentType("application/vnd.ms-excel");
  response.setHeader("Content-Description", "JSP Generated Data");   
  response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

  PosContext ctx=(PosContext)request.getAttribute(PosWebConstants.CONTEXT);
  PosRowSet rowSet = ctx!=null ? (PosRowSet)ctx.get("xml-result") : null;
  PosRow row = null;

  String[] columnInfLstName = "Roll코드,등록순서,구분,보유라인,세부위치,패턴명,사용가능,규격(외주mm),규격(Φ mm),생산가능폭(mm),핀트,용도,상세용도,제작업체,이미지,대표색상,사용량(m),CCL BOM,최근사용일자,미사용일수,입고일자,사용시작일자,사용종료일자,폐기일자,비고,등록자,등록일,수정자,수정일".split(",");
  String[] columnInfLst = ((String)ctx.get("column-info")).split(",");

  HSSFWorkbook workbook = new HSSFWorkbook();

  //HSSFCellStyle style = workbook.createCellStyle();
  //style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
  //style.setBottomBorderColor(HSSFColor.BLACK.index);
  //style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
  //style.setLeftBorderColor(HSSFColor.GREEN.index);
  //style.setBorderRight(HSSFCellStyle.BORDER_THIN);
  //style.setRightBorderColor(HSSFColor.BLUE.index);
  //style.setBorderTop(HSSFCellStyle.BORDER_MEDIUM_DASHED);
  //style.setTopBorderColor(HSSFColor.BLACK.index);

  //create a new Excel sheet1
  HSSFSheet sheet1 = workbook.createSheet("등록Roll");
  HSSFRow exRow1 = sheet1.createRow(0);

  HSSFCell cell1;

  for(int i =0; i < columnInfLstName.length; i++)
  {
    cell1 = exRow1.createCell(i);
    //cell1.setCellStyle(style);
    cell1.setCellValue(columnInfLstName[i]);
  }

  //create a new Excel sheet2
  HSSFSheet sheet2 = workbook.createSheet("폐기Roll");
  HSSFRow exRow2 = sheet2.createRow(0);

  HSSFCell cell2;

  for(int i =0; i < columnInfLstName.length; i++)
  {
    cell2 = exRow2.createCell(i);
    //cell2.setCellStyle(style);
    cell2.setCellValue(columnInfLstName[i]);
  }

  // 실제 내용은 넣어 준다
  if( rowSet!=null ){

    int sht1RowCnt = 1;
    int sht2RowCnt = 1;

    while(rowSet.hasNext())
    {
      row = rowSet.next();

      String rollDisDd = (String)row.getAttribute("ROLL_DIS_DD");

      if (rollDisDd == null || rollDisDd.equals("") )
      {
        exRow1 = sheet1.createRow(sht1RowCnt);
        sht1RowCnt++;
      } else {
        exRow2 = sheet2.createRow(sht2RowCnt);
        sht2RowCnt++;
      }

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

        if (rollDisDd == null || rollDisDd.equals("") )
        {
          cell1 = exRow1.createCell(i);
          cell1.setCellValue(temp);
        } else {
          cell2 = exRow2.createCell(i);
          cell2.setCellValue(temp);
        }
      }
    }
  }

  OutputStream xlsOut = response.getOutputStream();
  workbook.write(xlsOut);
  if (xlsOut != null) xlsOut.close();
%>