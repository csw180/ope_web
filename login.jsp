<%@page import="com.shbank.orms.comm.MainDao"%>
<%/**************************************************************************/
/* 파일이름   : login.jsp                                                   */
/* 최근변경일 : 2020-09-23                                                  */
/**************************************************************************/%>
<%@ page language="java"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@page import="com.rathontech.sso.sp.agent.web.WebAgent"%>
<%@page import="com.rathontech.sso.sp.config.Env"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<!DOCTYPE html>
<%
	request.getSession(true).setAttribute("login_type", "sso" );
    // SSO 서버에서 Return Message를 SsoReturnValue 라는 Request Parameter로 보낸다.
    // 이것을 받았을 때의 적절한 처리는 직접 구현한다.
    // 아래는 alert으로 메시지를 보여주고 Agent 연동 페이지로 이동하여 SSO Agent를 다시 호출하게 해 놓았다.
    String errMsg = request.getParameter("SsoReturnValue");

	System.out.println("errMsg == " + errMsg);
	
	if(System.getProperty("contextpath")==null){
		ServletContext ctx = request.getSession(true).getServletContext();
		String contextpath = ctx.getInitParameter("contextpath");
		if(contextpath==null) contextpath ="";
		System.setProperty("contextpath",contextpath);
	}
	
    if (StringUtils.isNotEmpty(errMsg)) {
%>

		<script type="text/javascript">
			//alert('통합로그인이 되지 않았습니다.');
			<%-- document.location.href = '<%=System.getProperty("contextpath")%>/Jsp.do?path=login_proc'; --%>
			//SSO_checker();
			alert('<%=errMsg%>');
			window.close();
		</script>
        
<%
        return;
    }

    WebAgent agent = new WebAgent();
    //SSO 로그인에 필요한 Parameter가 없는 경우 생성을 위하여
    //로그인 페이지에서도 Agent를 호출해준다.
    agent.requestAuthentication(request, response);
    
	//Agent의 Env에서 아래의 값을 제공한다.
    // SSO_LOGIN_URL - SSO 로그인 주소
    // SSO_LOGOUT_URL - SSO 로그아웃 주소
    // DEFAULT_SESSION_USERID - SSO 기본 사용자ID세션 키값(RathonSSO_USER_ID
    
%>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>수협 운영리스크 관리시스템</title>
	<link rel="shortcut icon" href="/orms/imgs/favicon.ico" type="image/x-icon">
</head>
<body onLoad="SSO_checker();">

<!-- 미사용 SSO OBJECT -->
<!-- 	<script>
		  document.write("<OBJECT ID=\"NEXESS_API\" CLASSID=\"CLSID:D4F62B67-8BA3-4A8D-94F6-777A015DB612\" width=0 height=0></OBJECT>");
	</script>  -->

    <script src="<%=System.getProperty("contextpath")%>/js/jquery.min.js"></script>
    <script src="<%=System.getProperty("contextpath")%>/js/wp.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/common.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/NexessDemonFunc.js"></script> <!-- 수협 SSO 로그인 JS -->
	<script>
	
// 	/*TGATE 로그인 아이디를 가져온다.*/
//	function GetTgateID(responseData)
//	{
//		/*TGATE 아이디 사용시 아래 input 태그에 추가*/
//		$("#tgate_id").val(responseData.msg);
//	} 
	
	/*SSO 로그인 아이디를 가져온다*/
	function GetSSOID(responseData)
	{				

		var result = -1;
		var f = document.frm;
		var userid = ""
		
		var retMsg = responseData.msg;
	    //alert(responseData.resultCode+"|"+responseData.status+"|"+responseData.msg); 
		if(retMsg == ""||retMsg == "error")
		{
			$("#userid").val("");
		}else{
			
			$("#userid").val(retMsg);
		}
		
		userid = $("#userid").val();
		
		//인증되어 있지 않으면 로그인 폼을 생성한다.
	    if (userid == "") {
	    	
			alert('통합로그인이 되지 않았습니다.');
			document.location.href = '<%=System.getProperty("contextpath")%>/Jsp.do?path=login_proc';
			//window.close();  
	    } else {
			//인증되어 있는 경우 아래 내용을 보여준다.
			WP.clearParameters();
			WP.setForm(f); 
			
			var url = "<%=System.getProperty("contextpath")%>/login.do";
			var inputData = WP.getParams();
			
			WP.load(url, inputData,{
				success: function(result){
					if(result!='undefined'){
						if(result.message=="success"){
							var f = document.frm;
							f.action = "<%=System.getProperty("contextpath")%>/main.do";
  							f.target = "_self";
  							f.submit();
  						}else{
  							alert(result.message);
  						}
  					}else{
  						alert('통합로그인이 되지 않았습니다.');
  						<%-- document.location.href = '<%=System.getProperty("contextpath")%>/Jsp.do?path=login_proc'; --%>
  						window.close();  
					}
				},
					  
				complete: function(statusText,status) {
				},
					  
				error: function(rtnMsg) {
					alert(JSON.stringify(rtnMsg));
				}
			});
	    }
		
	}
	
	function SSO_checker() {
		/* Nexess_GetADLoginUser(GetTgateID); */
		Nexess_GetLoginID(GetSSOID);
	}

	



	
	</script>
	<form name="frm" action="<%=System.getProperty("contextpath")%>/login.do" method="post">
		<input type="hidden" name="grp_org_c" value="01" />
<%-- 		<input type="hidden" name="userid" value="<%=(String) session.getAttribute(Env.DEFAULT_SESSION_USERID)%>"> --%>
 		<input type="hidden" name="userid" id="userid" value="">
		<input type="hidden" name="login_type" value="1">
	</form>
</body>
</html>