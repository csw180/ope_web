<%@page import="com.shbank.orms.comm.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	boolean isTimeout = false;
	HashMap info = (HashMap)request.getSession(true).getAttribute("infoH");
	if(info == null)	isTimeout = true;
	String msg = (String)request.getAttribute("sMessage");
	if(msg==null) msg ="오류 페이지 입니다.";
	
	
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script language="javascript">
	 /**
	 * home 화면으로 이동
	 */
	function goHome(userType){
		//location.target = "_self";
		top.location.href = "/main.do";
		//alert(location);
		return;
	}
	
	if("true" == "<%=isTimeout%>"){
		//alert("세션이 만료되어 자동로그아웃 되었습니다.");
		top.location.href = "<%=System.getProperty("contextpath")%>/";
	}
	removeLoadingWs();
	parent.removeLoadingWs();
	</script>
</head>
<body>
	<div id="wrap" class="container">
		<div class="error_page">
			<strong><%=msg %></strong>
			<p>문의하실 내용이 있으시면<br />
				시스템관리자에게 문의하시기 바랍니다.</p>
			<div class="btn-wrap">
				<a href="#" onclick="history.back();" class="btn btn-default w160"><span>이전화면으로 돌아가기</span></a>
				<a href="#" onclick="javascript:goHome();" class="btn btn-primary w160"><span class="cw">메인으로 가기</span></a>
			</div>
		</div>
	</div>
</body>
</html>