<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="com.shbank.orms.comm.MainDao"%>
<%@ page language="java"%> 
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.initech.provider.crypto.InitechProvider"%>
<%@page import="com.initech.provider.crypto.Provider"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.util.List"%>
<%@page import="com.initech.eam.nls.TicketV3"%>

<%@ include file="cutCarriageReturn.jsp" %>
<%
	if(System.getProperty("contextpath")==null){
		ServletContext ctx = request.getSession(true).getServletContext();
		String contextpath = ctx.getInitParameter("contextpath");
		if(contextpath==null) contextpath ="";
		System.setProperty("contextpath",contextpath);
	}

	List res = null;
	String userid = "";
	String toa = "";
	String login_type = "";
	
	try {
		
		
		String ticket = (String) request.getParameter("ticket");
		System.out.println("*================== ticket1 = "+ticket);
		String savedNonce = (String) session.getAttribute("nexess.nls.resession.nonce");
		
		if (ticket != null) {
			ticket = URLDecoder.decode(ticket);
		}
		System.out.println("*================== ticket2 = "+ticket);
		
		int firstIndex        = ticket.indexOf("&&");
		int secondeIndex      = ticket.lastIndexOf("&&");
		String encNonce       = ticket.substring(0, firstIndex);
		String encSKIPAndTime = ticket.substring(firstIndex + 2, secondeIndex);
		String encIDAndTOA    = ticket.substring(secondeIndex + 2);
		
		
		String decNonce = null;
		try {
			decNonce = cutCarriageReturn(TicketV3.decryptNonce(encSKIPAndTime, encNonce));
		} catch (Exception e) {
			System.out.println("티켓검증 실패!! [decNonce]");				
		} catch (Error e) {
			System.out.println("티켓검증 실패!! [decNonce]");				
		}
	
		if (decNonce.equals(savedNonce)) {		
			res = TicketV3.readIDAndTOA(encSKIPAndTime, encIDAndTOA);
			userid = (String) res.get(0);
			toa = (String) res.get(1);    /* 2: 인증서 로그인, 3: ID/pw로그인 */
			login_type = "sso";
		}else{
			System.out.println("티켓검증 실패!! [decNonce not equals savedNonce]");				
		}
	} catch (Exception e) {
		System.out.println("티켓검증 실패!!");			
		e.printStackTrace();
	} catch (Error e) {
		System.out.println("티켓검증 실패!!");			
		e.printStackTrace();
	}
	
	String herf_path = "/error.jsp";// Jsp.do?path=login_proc : 
	
	if(userid != null && !userid.equals("")&& login_type.equals("sso")){
		request.getSession(true).setAttribute("login_type", "sso" );
	}else{
		final String TEST_MODE = "isTest";
		final String TIER2 = "2";
		final String HTTP_SERV = "httpserv";
		final String TMAX = "0";
		final String HTTP = "1";
		final String JDBC = "2";
		final String CONN_NAME = "tpFGTE01";
		String test_mode = "";
		
		ServletContext ctx = request.getSession(true).getServletContext();
		String http_serv = ctx.getInitParameter(HTTP_SERV);
		if(http_serv==null) http_serv = ""; 
		//String istest = ctx.getInitParameter(TEST_MODE);
			test_mode = ctx.getInitParameter(TEST_MODE);
		//String cryptkey = ctx.getInitParameter(CRYPTKEY);
		if(test_mode==null){
			test_mode = TMAX;
		}
		
		MainDao mainDao = new MainDao();
		Vector grpList = mainDao.getGrpList("", request, "S");
		
		for(int i=0;i<grpList.size();i++){
			HashMap hMap = (HashMap)grpList.get(i);
			
			String no2_hcnt = (String)hMap.get("no2_hcnt");
			if(no2_hcnt !=null && !no2_hcnt.equals("")){
				herf_path = "/Jsp.do?path=login_proc";
				break;
			}
			
		}
		
	}

%>
    <script src="<%=System.getProperty("contextpath")%>/js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=System.getProperty("contextpath")%>/js/wp.js"></script>
<script>
function goSubmit(){
	//alert("<%=userid%>");
	if("<%=userid%>" != "") {
		//document.frm.submit();
		var f = document.frm;
		WP.clearParameters();
		WP.setForm(f); 
		
		var url = "<%=System.getProperty("contextpath")%>/login.do";
		var inputData = WP.getParams();
		
		//alert(inputData);
		
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
						  document.location.href = '<%=System.getProperty("contextpath")%><%=herf_path%>';
					}
				}else{
//					alert("처리할 수 없습니다.");
					  alert('통합로그인이 되지 않았습니다.');
					  document.location.href = '<%=System.getProperty("contextpath")%><%=herf_path%>';
				}
			},
			  
			complete: function(statusText,status) {
			},
			  
			error: function(rtnMsg) {
				alert(JSON.stringify(rtnMsg));
			}
		});
	}else{
		//alert("SSO ticket 검증 실패 하였습니다.");
		document.location.href = '<%=System.getProperty("contextpath")%><%=herf_path%>';
	}
}
</script>

<html>
<body bgcolor="#FFFFFF" text="#000000" onLoad="javascript:goSubmit();">
<form name="frm" action="/login.do" method="post">
<input type="hidden" name="grp_org_c" value="" />
<input type="hidden" name="userid" value="<%=userid%>">
<input type="hidden" name="login_type" value="1">
</form>
</body>
</html>
