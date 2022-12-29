<%--
/*---------------------------------------------------------------------------
 Program ID   : errorPage.jsp
 Program name : 에러화면
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	HashMap infoH = (HashMap)request.getSession(true).getAttribute("infoH");
	System.out.println("infoH:"+infoH);
	String msg = (String)request.getAttribute("sMessage");
	if(msg==null) msg ="";
	//String userid = (String)request.getSession(true).getAttribute("mb_id");
	//String userid = "";
	//if(infoH!=null) userid = (String)infoH.get("mb_id");
	//if(infoH==null || userid==null || userid.equals("")){
	//	userid=StringUtil.objtoStr(request.getParameter( "mbId"));
	//}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script language="javascript">
	if("<%=msg%>"!="") alert("<%=msg%>");
	top.location.href = "<%=System.getProperty("contextpath")%>/Jsp.do?path=login_proc";
</script>
</head>
<body class="login">
</body>
</html>