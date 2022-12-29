<%--
/*---------------------------------------------------------------------------
 Program ID   : HpnInfP.jsp
 Program name : 사건유형 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.04
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeHpn(){
		$("#winHpn").hide();
	}
	
	var cnt=0;
	function openHpn(){
		var ifm = document.getElementById("ifrHpn");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winHpn").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openHpn,100);
		}
	}
	
	function schHpnPopup(){
		/*
		$("#ifrHpn").ready(function(){
			cnt=0;
			setTimeout(openHpn,100);
		});
		*/

		var f = document.hpnForm;
		f.path.value="/comm/ORCO0103";
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrHpn";
		f.submit();
	}

</script>
<form name="hpnForm">
	<input type="hidden" id="path" name="path" />
</form>
<div id='winHpn' class='popup modal' style="background-color:transparent">
	<iframe id='ifrHpn' src="about:blank" name='ifrHpn' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>