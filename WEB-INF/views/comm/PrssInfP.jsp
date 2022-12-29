<%--
/*---------------------------------------------------------------------------
 Program ID   : PrssInfP.jsp
 Program name : 업무프로세스 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.04
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closePrss(){
		$("#winPrss").hide();
	}
	
	var cnt=0;
	function openPrss(){
		var ifm = document.getElementById("ifrPrss");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winPrss").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openPrss,100);
		}
	}
	
	function schPrssPopup(){
		
		/*
		$("#ifrPrss").ready(function(){
			cnt=0;
			setTimeout(openPrss,100);
		});
		*/
	
		var f = document.prssForm;
		f.path.value="/comm/ORCO0101";
	    f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrPrss";
		f.submit();
	}

</script>
<form name="prssForm">
<input type="hidden" id="path" name="path" />
</form>
<div id='winPrss' class='popup modal'>
<iframe id='ifrPrss' src="about:blank" name='ifrPrss'></iframe>
</div>
