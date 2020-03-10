<%@ page contentType="application/pdf" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.posdata.glue.util.log.PosLog" %>
<%@ page import="com.posdata.glue.util.log.PosLogFactory" %>
<%@ page import="java.sql.Connection" %>

<%
  PosLog logger = PosLogFactory.getLogger("report_list.jsp");
  DataSource ds = null;
  Connection con = null;
  try{
		out.clear();
		out = pageContext.pushBody(); 
		ds = (DataSource)PosContext.getBeanFactory().getBeanObject("dataSource");
		String keyValue			= (request.getParameter("keyValue") == null)	   ? "":request.getParameter("keyValue");
		String keyName      	= (request.getParameter("keyName") == null)	       ? "":request.getParameter("keyName");
		String reportFileName	= (request.getParameter("reportFileName") == null) ? "":request.getParameter("reportFileName");
		

		logger.logInfo("reportFileName => "+reportFileName);
		logger.logInfo("keyValue=>" + keyValue);
		String [] arrKeyValue   = keyValue.split("[$]");
	    String [] arrKeyName 	= keyName.split(",");

		String reportFilePath = application.getRealPath("/") + File.separator + reportFileName;
		List jasperPrintList  = new ArrayList();
		
		logger.logInfo("reportFilePath => "+reportFilePath);
		logger.logInfo("arrKeyValue.length => "+arrKeyValue.length);
		logger.logInfo("arrSubTitle.length => "+arrKeyName.length);
		
		con = ds.getConnection();
		
		JasperPrint print = null;
		Map map = new HashMap();
		for(int i=0; arrKeyValue.length>i; i++){

					
					map.put(arrKeyName[i] ,arrKeyValue[i]);
					
					logger.logInfo("arrKeyName  => " + arrKeyName[i]);
					logger.logInfo("arrKeyValue => " + arrKeyValue[i]);


				}
		
		print = JasperFillManager.fillReport(reportFilePath, map,con);
		jasperPrintList.add(print);
		
		JRPdfExporter exporter = new JRPdfExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, response.getOutputStream());
		exporter.setParameter(JRPdfExporterParameter.IS_CREATING_BATCH_MODE_BOOKMARKS, Boolean.TRUE);

		exporter.exportReport();

   }catch(Exception ex){
	   logger.logInfo("ex.getMessage() => "+ex.getMessage());
   }finally{
		try{
			if(con != null){
				con.close(); 
                logger.logInfo("con.close()");	
	      		 
            }
	   }catch(Exception dsEx){
			logger.logInfo("dsEx.getMessage() => "+dsEx.getMessage());
	   }
	}
%>