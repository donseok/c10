<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.security.util.PosCipher" %><%
/*
 *Change history
 *@LastModifyDate : 20100609
 *@LastModifier   : 황유진
 *@LastVersion    : 1.0
 *    2010-06-09    황유진
 */
    String value = request.getParameter("srcValue");
    String result = PosCipher.encrypt(value);
    response.setContentType("text/xml");
    out.println("<response>");
    out.println("<result>" + result + "</result>");
    out.println("</response>");
%>