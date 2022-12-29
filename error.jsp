<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, javax.servlet.ServletContext" %>
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

	boolean isTimeout = false;
	HashMap hs = (HashMap)request.getSession(true).getAttribute("infoH");
	if(hs == null)	isTimeout = true;
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>오류페이지</title>
	<link rel="stylesheet" href="<%=System.getProperty("contextpath")%>/styles/bootstrap.min.css">
	<link rel="stylesheet" href="<%=System.getProperty("contextpath")%>/styles/font-awesome.min.css">
	<link rel="stylesheet" href="<%=System.getProperty("contextpath")%>/styles/style.css">

	<script src="<%=System.getProperty("contextpath")%>/js/common.js"></script>
	<script>
		 /**
		 * home 화면으로 이동
		 */
		function goHome(){
			<%if(hs == null){%>
				window.open("about:blank", "_self").close();
			<%}else{%>
				location.target = "_self";
				location.href = "<%=System.getProperty("contextpath")%>/main.do";
				//alert(location);
			<%}%>
			return;
		}  
		 
		if("true" == "<%=isTimeout%>"){
			//alert("세션이 만료되어 자동로그아웃 되었습니다.");
			//location.href = "/index.jsp";
		}
	</script>
</head>
<body>
	<div class="container">
		<div class="error_page">
			<strong>오류 페이지 입니다.</strong>
			<p>관련부서로 문의 하시기 바랍니다.</p>
			<div class="btn-wrap">
				<!-- <a href="#" onclick="history.back();" class="btn btn-default w160"><span>이전화면으로 돌아가기</span></a> -->
				<a href="#" onclick="javascript:goHome();" class="btn btn-primary w160"><span>나가기</span></a>
			</div>
		</div>
	</div>
</body>
</html>