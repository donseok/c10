<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<%@ page language = "java" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.posdata.glue.context.PosContext" %>
<%@ page import = "com.posdata.glue.web.control.*" %>
<link rel="stylesheet" href="css/pub.css" type="text/css">

<jsp:useBean id="calendar" scope="page" class="com.posdata.glue.ui.tags.util.PosTagUtil"/>
<posglobalui:setResourceName name="server_calendar"/>
<%
	java.util.Calendar cal = java.util.Calendar.getInstance();
	int presentYear1 = cal.get(Calendar.YEAR);	
	int presentMonth1 = (cal.get(Calendar.MONTH))+1;
	int lnDay1 = cal.get(Calendar.DATE);
	
	String strPresentYear1=null, strPresentMonth1=null, strLnDay1=null;

	strPresentYear1 = String.valueOf(presentYear1);
	strPresentMonth1 = String.valueOf(presentMonth1);
	strLnDay1 = String.valueOf(lnDay1);
	if(strPresentMonth1.length() <2){
		strPresentMonth1 = "0"+presentMonth1;
	}
	if(strLnDay1.length() <2){
		strLnDay1 = "0"+lnDay1;
	}		

	String lsYear = request.getParameter("year");		
	if(lsYear==null || lsYear.equals("")){
		lsYear = strPresentYear1;
	}

	String lsMonth = request.getParameter("month");
	if(lsMonth==null || lsMonth.equals("")){
		lsMonth = strPresentMonth1;
	}
	
	String lsDay = request.getParameter("day");
	if(lsDay==null || lsDay.equals("")){
		lsDay = strLnDay1;
	}
	
	String strPresentDay = strPresentYear1+strPresentMonth1+strLnDay1;
	String reqPresentDay = lsYear+lsMonth+lsDay;
	
	String lsCmd = "";
	if(strPresentDay.equals(reqPresentDay)){
		lsCmd = "NU";
	}else{
		lsCmd = "GU";
	}
	
	boolean timeCheck = Boolean.valueOf(request.getParameter("timeCheck")).booleanValue();
	//String lsClass = request.getParameter("stor1");	// form name
	String lsClass = "opener.document.all";
	String lsMethod = request.getParameter("stor2");	// method name
	String gFormat = request.getParameter("gFormat");
	if(gFormat == null){
		gFormat = "YYYY-MM-DD";
	}	
	calendar.setCalendar(lsYear, lsMonth, lsDay, lsCmd, gFormat); 
    //Global Data Set up
    String resource = (String)pageContext.getAttribute(PosWebConstants.RESOURCE_FILE_NAME);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);
    String server_calendar_month="";
    String server_calendar_year="-";
    String server_calendar_day="Day";
    String server_calendar_mon="MON";
    String server_calendar_tue="TUE";
    String server_calendar_wed="WED";
    String server_calendar_thu="THU";
    String server_calendar_fri="FRI";
    String server_calendar_sat="SAT";
    String server_calendar_sun="SUN";
    String server_calendar_h="H";
    String server_calendar_m="M";
    String server_calendar_s="S";
    String server_calendar_displaytime="DisplayTime";
    String temp = PosContext.getResourceMessage(resource,"server_calendar_month",null,locale);
    if (temp != null) server_calendar_month=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_year",null,locale);
    if (temp != null) server_calendar_year=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_day",null,locale);
    if (temp != null) server_calendar_day=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_mon",null,locale);
    if (temp != null) server_calendar_mon=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_tue",null,locale);
    if (temp != null) server_calendar_tue=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_wed",null,locale);
    if (temp != null) server_calendar_wed=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_thu",null,locale);
    if (temp != null) server_calendar_thu=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_fri",null,locale);
    if (temp != null) server_calendar_fri=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_sat",null,locale);
    if (temp != null) server_calendar_sat=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_sun",null,locale);
    if (temp != null) server_calendar_sun=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_h",null,locale);
    if (temp != null) server_calendar_h=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_m",null,locale);
    if (temp != null) server_calendar_m=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_s",null,locale);
    if (temp != null) server_calendar_s=temp;
    temp = PosContext.getResourceMessage(resource,"server_calendar_displaytime",null,locale);
    if (temp != null) server_calendar_displaytime=temp;
        
%>
<html>
<head><title>Calendar</title>
<script language="JavaScript"> 
    var dateFormat = "<%=gFormat%>";
	function calendarEnd(jcals) { 
		if(document.form1.timeCheck.checked){
            <%=lsClass%>.<%=lsMethod%>.value = checkdate(jcals);	
        }
        else{
            <%=lsClass%>.<%=lsMethod%>.value= jcals;
        }
		top.close(); 				
	} 
    
    function checkdate(jcals)
    {   
        var dateString ='';
        var dateSplit = jcals.split('-');
        
        if(dateFormat == '')
        {
            dateStringMonth = jcals;  
            dateStringHour = dateStringMonth + " " +document.form1.hh_sel.options[document.form1.hh_sel.selectedIndex].value;
            dateStringMinute = dateStringHour + ":" +document.form1.mi_sel.options[document.form1.mi_sel.selectedIndex].value;
            dateString = dateStringMinute + ":" +document.form1.ss_sel.options[document.form1.ss_sel.selectedIndex].value;	
        }
        if(dateFormat.indexOf("YYYY") >= 0)
        {
            dateString = dateSplit[0];
        }
        if(dateFormat.indexOf("MM") >= 0)
        {
            dateString = dateString + "-" +dateSplit[1];
        }
        if(dateFormat.indexOf("DD") >= 0)
        {
            dateString = dateString + "-" +dateSplit[2];
        }  
        if(dateFormat.indexOf("HH") >= 0)
        {
            dateString = dateString + " " +document.form1.hh_sel.options[document.form1.hh_sel.selectedIndex].value;
        }
        if(dateFormat.indexOf("mm") >= 0)
        {
            dateString = dateString + ":" +document.form1.mi_sel.options[document.form1.mi_sel.selectedIndex].value;
        }  
        if(dateFormat.indexOf("SS") >= 0)
        {
            dateString = dateString + ":" +document.form1.ss_sel.options[document.form1.ss_sel.selectedIndex].value;	
        }   
        return dateString;
    }

	function timeShow(){
		if(document.form1.timeCheck.checked){
			document.all.message.style.display="";
		}else{
			document.all.message.style.display="none";
		}
	}
	function checkTime(){
		if(<%=timeCheck%>){ 
			document.form1.timeCheck.click();
		}
	}	
</script>
</head>

<body link="#4D4D4D" vlink="#4D4D4D" alink="#4D4D4D" text="#990066" onLoad="checkTime()">
<TABLE WIDTH='100%' BORDER=0 CELLSPACING=0 CELLPADDING=0>
  <TR  ALIGN=center>
		<TD colspan='4'>
			<div><FONT FACE='arial' SIZE=3><B><%=calendar.getYear()%><%=server_calendar_year%> <%=calendar.getMonth()%><%=server_calendar_month%></B></FONT></div><P>
		</td>		
	</tr>
	<TR>
		<TD ALIGN=center>
			<a href="server_calendar_global.jsp?<%=calendar.getBeforeYear()%>&stor1=<%=lsClass%>&stor2=<%=lsMethod%>&timeCheck=<%=timeCheck%>&gFormat=<%=gFormat%>">
			<IMG SRC='img/gm0014img.gif' BORDER=0></A>
		</TD>
		<TD ALIGN=center>
			<a href="server_calendar_global.jsp?<%=calendar.getBeforeMonth()%>&stor1=<%=lsClass%>&stor2=<%=lsMethod%>&timeCheck=<%=timeCheck%>&gFormat=<%=gFormat%>">
			<IMG SRC='img/gm0015img.gif' BORDER=0></A>
		</TD>
		<TD ALIGN=center>
			<a href="server_calendar_global.jsp?<%=calendar.getAfterMonth()%>&stor1=<%=lsClass%>&stor2=<%=lsMethod%>&timeCheck=<%=timeCheck%>&gFormat=<%=gFormat%>">
			<IMG SRC='img/gm0016img.gif' BORDER=0></A>
		</TD>
		<TD ALIGN=center>
			<a href="server_calendar_global.jsp?<%=calendar.getAfterYear()%>&stor1=<%=lsClass%>&stor2=<%=lsMethod%>&timeCheck=<%=timeCheck%>&gFormat=<%=gFormat%>">
			<IMG SRC='img/gm0017img.gif' BORDER=0></A>
		</TD>
	</TR>
</TABLE>

<TABLE ALIGN='CENTER' BORDER=0 CELLSPACING=1 CELLPADDING=2 BGCOLOR="#FFFFFF">
	<TR>
		<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#FFB0B3'>
			<FONT SIZE='2' FACE COLOR='#D80309'>&nbsp;<%=server_calendar_sun%>&nbsp;</FONT>
		</TD>
		<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'>
			<FONT SIZE='2' FACE='arial' COLOR='#715F44'>&nbsp;<%=server_calendar_mon%>&nbsp;</FONT>
		</TD>
		<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'>
			<FONT SIZE='2' FACE='arial' COLOR='#715F44'>&nbsp;<%=server_calendar_tue%>&nbsp;</FONT>
		</TD>
		<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'>
			<FONT SIZE='2' FACE='arial' COLOR='#715F44'>&nbsp;<%=server_calendar_wed%>&nbsp;</FONT>
		</TD>
		<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'>
			<FONT SIZE='2' FACE='arial' COLOR='#715F44'>&nbsp;<%=server_calendar_thu%>&nbsp;</FONT>
		</TD>
		<TD WIDTH='14%' ALIGN='CENTER' BGCOLOR='#E2E0D8'>
			<FONT SIZE='2' FACE='arial' COLOR='#715F44'>&nbsp;<%=server_calendar_fri%>&nbsp;</FONT>
		</TD>
		<TD WIDTH='16%' ALIGN='CENTER' BGCOLOR='#E2E0D8'>
			<FONT SIZE='2' FACE='arial' COLOR='#715F44'>&nbsp;<%=server_calendar_sat%>&nbsp;</FONT>
		</TD>
	</TR>
	<tr align="center"> 
    <td  colspan="7"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr align="center" height="25"> 
<%
	int lnWeek = 0;
	String buffer[][] = calendar.getString();
	int lnDay = Integer.parseInt(lsDay);
	if(lsCmd.charAt(0) == 'N')
	lnDay = Integer.parseInt(calendar.getDay());
	for(int ii=0; ii<42; ii++) {
		if((ii!=0) && ((ii%7) == 0)) {
%>
          </tr>
          <tr>
             <td height="1" colspan="7" background="img/gm0018img.gif"></td>
          </tr>
          <tr align="center" height="25">
<%
		}
		if(buffer[ii][1] == null) {
%>
            <td width="40">&nbsp;</td>
<%
		}
		else {
			lnWeek = ii%7;
			if(	(Integer.parseInt(buffer[ii][0]) == lnDay) &&
				(lnWeek != 0) && (lnWeek != 6) ) { // ����
%>
              <td bgcolor="#efefef" onMouseOver=this.style.backgroundColor="white" onMouseOut=this.style.backgroundColor="#efefef" width="40"><a href="javascript:calendarEnd('<%=buffer[ii][1]%>')"><FONT COLOR='#FF686C' SIZE='2' FACE='arial'><%=buffer[ii][0]%></FONT></a></td>
<%
			}
			else if(lnWeek == 0) {	// �Ͽ���
%>
              <td onMouseOver=this.style.backgroundColor="#efefef" onMouseOut=this.style.backgroundColor="white" width="40"><a href="javascript:calendarEnd('<%=buffer[ii][1]%>')"><font color="#CC3333" SIZE='2' FACE='arial'><%=buffer[ii][0]=buffer[ii][0]%></font></a></td>
<%
			}
			else if(lnWeek == 6) {	// �����
%>
               <td onMouseOver=this.style.backgroundColor="#efefef" onMouseOut=this.style.backgroundColor="white" width="40"><a href="javascript:calendarEnd('<%=buffer[ii][1]%>')"><font color="#003D79" SIZE='2' FACE='arial'><%=buffer[ii][0]=buffer[ii][0]%></font></a></td>
<%
			}
			else {
%>
          		 <td onMouseOver=this.style.backgroundColor="#efefef" onMouseOut=this.style.backgroundColor="white" width="40"><a href="javascript:calendarEnd('<%=buffer[ii][1]%>')"><font SIZE='2' FACE='arial'><%=buffer[ii][0]%></font></a></td>
<%
			}
		}
	}
%>
        </tr>
		</table>
    </td>
  </tr>
	<TR>
	<TD WIDTH='14%' COLSPAN="7" ALIGN="CENTER">
	<%	 
	  Calendar rightNow = Calendar.getInstance();

	  int hh = rightNow.get(Calendar.HOUR_OF_DAY);
	  int mi = rightNow.get(Calendar.MINUTE);
	%>
<form name="form1">	  
  <div align=center id="message" style="display:none">   
  <select name="hh_sel" style='border-width:1px; background-color:#5b90bf; border-color:#404040;font:12px;color:white; text-align: left;'>
  <%
  for(int i=0; i<24; i++){
    if(hh == i){
		if(i<10){
	%>
	<option selected value="0<%=i%>">
	<%
		}
		else{
	%>
		  <option selected value="<%=i%>">
	<%
		}
	}else{
		if(i<10) {
	%>
		  <option value="0<%=i%>">
	<%
		}else {
	%>
		  <option value="<%=i%>">
	<%
		}
	}
	if(i<10) {
	%>
		 0<%=i%></option>
	<%
	}else {
	%>
		 <%=i%> </option>
	<% 
	}
  }
  %>
  </select> <%=server_calendar_h%>
  
  <select name="mi_sel" style='border-width:1px; background-color:#5b90bf; border-color:#404040;font:12px;color:white; text-align: left;'>
  <%
  for(int i=0; i<60; i++){
    if(mi == i){
		if(i<10) {
	%>
		  <option selected value="0<%=i%>">
	<%
		}else {
	%>
		  <option selected value="<%=i%>">
	<%
		}
	}else{
		if(i<10) {
	%>
		  <option value="0<%=i%>">
	<%
		}else {
	%>
		  <option value="<%=i%>">
	<%
		}
	}
	if(i<10){
	%>
		 0<%=i%>  </option>
	<%
	}else {
	%>
		 <%=i%> </option>
	<%
	}
  }
	%>
  </select> <%=server_calendar_m%>
  
   <select name="ss_sel" style='border-width:1px; background-color:#5b90bf; border-color:#404040;font:12px;color:white; text-align: left;'>
   <option selected value="00">00</option>
  <%
  for(int i=1; i<60; i++){
	  if(i<10){
  %>	
		  <option value="0<%=i%>"> 0<%=i%>  </option>
  <%	
	  }else{
  %>	
		  <option value="<%=i%>"> <%=i%>  </option>
  <%	
	  }	
  }
  %>
  </select> <%=server_calendar_s%>
  
  </div> 
  <input type="Checkbox" name="timeCheck" onClick="timeShow()"><%=server_calendar_displaytime%>
</form>
</TD>
  </table>
</TD>
</TR>
</table>
</body>
</html>
