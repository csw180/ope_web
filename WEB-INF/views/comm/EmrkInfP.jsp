<%--
/*---------------------------------------------------------------------------
 Program ID   : EmrkInfP.jsp
 Program name : 이머징리스크유형 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.04
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeEmrk(){
		$("#winEmrk").hide();
	}
	
	var cnt=0;
	function openEmrk(){
		var ifm = document.getElementById("ifrEmrk");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winEmrk").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openEmrk,100);
		}
	}
	
	function schEmrkPopup(){
		
		/*
		$("#ifrEmrk").ready(function(){
			cnt=0;
			setTimeout(openEmrk,100);
		});
		*/
	
		var f = document.emrkForm;
		f.path.value="/comm/ORCO0104";
	    f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrEmrk";
		f.submit();
	}

</script>
<form name="emrkForm">
<input type="hidden" id="path" name="path" />
</form>
<div id='winEmrk' class='popup modal' style="background-color:transparent">
<iframe id='ifrEmrk' src="about:blank" name='ifrEmrk' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
