<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext,com.shbank.orms.comm.util.StringUtil" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	HashMap infoH = (HashMap)request.getSession(true).getAttribute("infoH");
	System.out.println("infoH:"+infoH);
	//String userid = (String)request.getSession(true).getAttribute("mb_id");
	//String userid = (String)infoH.get("mb_id");
%>
<%
	String msg = StringUtil.objtoStr(request.getAttribute( "msg"));	
%>
	
<!DOCTYPE html>
<HTML lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="refresh" content="3; url=http://tensalt.co.kr"></meta>

<body>
<%=msg%>
</br>홈페이지로 이동합니다.
</body>
</HTML>
