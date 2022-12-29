<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.*, javax.servlet.ServletContext" %>
<%@ include file="comm/comUtil.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	request.getSession(true).setAttribute("infoH", null );
	request.getSession(true).setAttribute("grp_org_c", null );
	request.getSession(true).setAttribute("login_type", null );
	request.getSession(true).setAttribute("ip_addr", null );
	request.getSession(true).setAttribute("userid", null );
	request.getSession(true).setAttribute("puser", null );
	request.getSession(true).setAttribute("puserid", null );
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>수협 ORMS System Login</title>
<link rel="shortcut icon" href="<%=System.getProperty("contextpath")%>/imgs/favicon.ico" type="image/x-icon">
<OBJECT ID="NEXESS_API" CLASSID="CLSID:D4F62B67-8BA3-4A8D-94F6-777A015DB612" width=0 height=0></OBJECT>
<%@ include file="comm/library.jsp" %>
<script>
	$(document).ready(function(event) {
	    $('form[name=frm]').submit(function(event){
	        event.preventDefault();
	        //add stuff here
	    });
		var f = document.frm;
		WP.clearParameters();
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/getOrggrp.do";
		var inputData = WP.getParams();
		
		//showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function(result){
					//removeLoadingWs();
					var rList = result.DATA;
					if(result!='undefined') {
						var html = "";
						if(rList.length==1){
							html += '<input type="hidden" id="grp_org_c" name="grp_org_c" value="' + rList[0].grp_org_c + '">';
							html += '<input type="text" id="grp_orgnm" name="grp_orgnm" class="input" value="' + rList[0].grp_orgnm + '">';
							$("title").text(rList[0].grp_orgnm+" ORMS System Login");
						}else{
							html += '<select class="form-control" id="grp_org_c" name="grp_org_c">';
							for(var i=0;i<rList.length;i++){
								html += '<option value="' + rList[i].grp_org_c + '">' + rList[i].grp_orgnm + '</option>';
							}
							html += '</select>';
						}
						//alert(html);
						$("#div_orggrp").html(html);
					}
				},
			
			  
				complete: function(statusText,status){
					//removeLoadingWs();
				},
			  
				error: function(rtnMsg){
					alert(JSON.stringify(rtnMsg));
				}
		});
	    
	    
	});

	function strtProcess(){
		var f = document.frm;
      try {
 	  	f.passwd.value = NEXESS_API.getHash2(f.inpasswd.value);
      } catch(e) {
   	  	f.passwd.value = f.inpasswd.value;
      }

		WP.clearParameters();
		WP.setForm(f);

		var url = "<%=System.getProperty("contextpath")%>/login.do";
		var inputData = WP.getParams();

		WP.load(url, inputData,{
			success: function(result){
				if(result!='undefined'){
					if(result.message=="success"){
						setTimeout(function(){
							var f = document.frm;
							f.action = "<%=System.getProperty("contextpath")%>/main.do";
							f.target = "_self";
							f.submit();
						},1);
					}else{
						alert(result.message);
					}
				}else{
					alert("처리할 수 없습니다.");
				}
			},

			complete: function(statusText,status) {
			},

			error: function(rtnMsg) {
				alert(JSON.stringify(rtnMsg));
			}
		});

	}

</script>
</head>
<body class="login">
<form name="frm" method="post" >
<!-- <input type="hidden" name="grp_org_c" value="01" /> -->
<input type="hidden" name="login_type" value="0">
<input type="hidden" name="passwd" value="">
	<div id="login">
		<div class="l_wrap">
			<div class="l_banner">
			</div>
			<div class="l_form">
				<div class="lf_wrap">
					<div class="l_logo">
						<span class="blind">수협중앙회</span>
					</div>
					<h1 class="l_title">
						<strong>운영리스크 관리 시스템</strong>
						<span class="">Operational Risk Management System</span>
					</h1>
					<div class="form">
						<h2 class="title blind">LOGIN</h2>
						<div class="f_wrap">
							<div class="f_field">
								<div class="ff_title">
									<label for="grp_org_c">계열사</label>
								</div>
								<div id="div_orggrp" class="select">
								</div>
							</div>
						</div>
						<div class="f_wrap">
							<div class="f_field">
								<div class="ff_title">
									<label for="lf_id">Username</label>
								</div>
								<div class="ff_wrap">
									<input type="text" id="userid" name="userid" class="input" placeholder="" value="" tabindex="1" />
								</div>
							</div>
						</div>
						<div class="f_wrap">
							<div class="f_field">
								<div class="ff_title">
									<label for="lf_password">Password</label>
								</div>
								<div class="ff_wrap">
									<input type="password" id="inpasswd" name="inpasswd" autocomplete="on" class="input" placeholder="" value=""  onKeyup="if(event.keyCode==13) strtProcess();" tabindex="2"/>
								</div>
							</div>
						</div>
						<div class="btn_wrap">
							<button type="submit" class="btn btn-primary w100p" onClick="strtProcess();" tabindex="3">Login</button>
						</div>
					</div>
					<div class="info">* Contact your system administrator for ID and Password.</div>
					<div style="color:red" align="center">오늘 , 담주 데이터 정비 및 일부 개발로 인하여 접속이 끊길 수도 있습니다!</div>
					<div style="color:red" align="center">필요하신 페이지나 데이터 있으시면 말씀해 주세요</div>
					<div class="l_copyright">
						<p><span>&copy; 2022 <mark>수협중앙회</mark></span> <span class="lc_ver">All rights reserved</span></p>
					</div>
				</div>
			</div>
		</div><!-- .wrap //-->
	</div>
</form>
</body>
</html>