<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
  <head>
    <title>UNIONSTEEL MES Enterprise Portal</title>
    <script language="JavaScript">
		var width = screen.width; //팝업창 넓이 
        var height = screen.height; //팝업창 높이 
		window.resizeTo(width,height);
		window.moveTo(0,0);
	</script>
  </head>   
  <frameset rows="*,0" frameborder="no">
    <frame name="parentFrame" noresize src = "./portal.jsp"  marginwidth="0" marginheight="0" scrolling="yes" frameborder="no">
    <frame name="nullFrame" noresize src = "" marginwidth="0" marginheight="0" scrolling="no" frameborder="no">
  </frameset> 
</html>