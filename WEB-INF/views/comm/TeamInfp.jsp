<%--
/*---------------------------------------------------------------------------
 Program ID   : TeamInfp.jsp
 Program name : 팀 조회 레이어
 Description  : 
 Programmer    : 권성학
 Date created : 2021.05.04
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeTeam(){
		$("#winTeam").hide();
	}
	
	var cnt=0;
	function openTeam(){
		var ifm = document.getElementById("ifrTeam");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winTeam").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openTeam,100);
		}
	}
	
	function schTeamPopup(){
		
		/*
		$("#ifrEmrk").ready(function(){
			cnt=0;
			setTimeout(openEmrk,100);
		});
		*/
	
		var f = document.TeamForm;
		f.path.value="/comm/ORCO0113";
	    f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrTeam";
		f.submit();
	}

</script>
<form name="TeamForm">
<input type="hidden" id="path" name="path" />
</form>
<div id='winTeam' class='popup modal' style="background-color:transparent">
<iframe id='ifrTeam' src="about:blank" name='ifrTeam' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
