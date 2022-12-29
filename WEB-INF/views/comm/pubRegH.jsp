<%--
/*---------------------------------------------------------------------------
 Program ID   : pubRegH.jsp
 Program name : 게시판 처리결과화면
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext"%>
<%
	String pub_dscd="";
	DynaForm form = (DynaForm)request.getAttribute("form");
	pub_dscd = StringUtil.objtoStr(form.get("pub_dscd"));
%>
<!DOCTYPE html>
<html>
	<head>
	<script language="javascript">
	<!--
	alert("처리를 완료 하였습니다.");
	var f = parent.document.nanform;
	/*
	f.target = "_self";
	f.action="<%=System.getProperty("contextpath")%>/Jsp.do?path=/pub/pubList&pub_dscd=<%=pub_dscd %>";
	f.submit();
	*/
	parent.location.href="<%=System.getProperty("contextpath")%>/Jsp.do?path=/adm/pubList&pub_dscd=<%=pub_dscd %>";
	//-->
	</script>
</head>
</html>