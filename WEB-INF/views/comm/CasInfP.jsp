<%--
/*---------------------------------------------------------------------------
 Program ID   : CasInfP.jsp
 Program name : 원인유형 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.04
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeCas(){
		$("#winCas").hide();
	}
	
	var cnt=0;
	function openCas(){
		var ifm = document.getElementById("ifrCas");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winCas").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openCas,100);
		}
	}
	
	function schCasPopup(){
		
		/*
		$("#ifrCas").ready(function(){
			cnt=0;
			setTimeout(openCas,100);
		});
		*/
	
		var f = document.casForm;
		f.path.value="/comm/ORCO0102";
	    f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrCas";
		f.submit();
	}

</script>
<form name="casForm">
<input type="hidden" id="path" name="path" />
</form>
<div id='winCas' class='popup modal' style="background-color:transparent">
<iframe id='ifrCas' src="about:blank" name='ifrCas' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
