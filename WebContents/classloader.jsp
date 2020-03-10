<%@ page contentType="text/html;charset=UTF-8"%>

<html>
<head>
<title>Nextree Classloader Information</title>
<style type="text/css">
.c_title{
    font-size:20px;
}

.th_classinfo{
    text-align:left;
    color:#fff;
    background-color:#000;
}
.td_classinfo{
    text-align:left;
    background-color:#ccc;
}

.th_classloader{
    width:700px;
    text-align:left;
    color:#fff;
    background-color:#000;
}
</style>
</head>
<body>
<p>
<table border=1>
<tr><th class="th_classloader">System Properties</th></tr>
<%
    Properties properties = System.getProperties();
    Set set = properties.keySet();
    Iterator iterator = set.iterator();
    while(iterator.hasNext()){
     String name = (String)iterator.next();
%>
<tr><td><%=name%></td><td><%=System.getProperty(name)%></td></tr>
<% } %>
</table>
</p>
</body>
</html>
