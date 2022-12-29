<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(System.getProperty("contextpath")==null){
		ServletContext ctx = request.getSession(true).getServletContext();
		String contextpath = ctx.getInitParameter("contextpath");
		if(contextpath==null) contextpath ="";
		System.setProperty("contextpath",contextpath);
	}

%>
