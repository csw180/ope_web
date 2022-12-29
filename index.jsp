<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	if(System.getProperty("contextpath")==null){
		ServletContext ctx = request.getSession(true).getServletContext();
		String contextpath = ctx.getInitParameter("contextpath");
		if(contextpath==null) contextpath ="";
		System.setProperty("contextpath",contextpath);
	}

	%>
	<html>
	<head>
	<title>INDEX</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<script language="javascript">
		  location.href = "<%=System.getProperty("contextpath")%>/login.jsp";
	</script> 
	<body>
	</body>
	</html>
