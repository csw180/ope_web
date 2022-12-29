<%--
/*---------------------------------------------------------------------------
 Program ID   : RpInfP.jsp
 Program name : 리스크풀 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.06.08
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeRp(){
		//$("#winRp").hide();
		$("#winRp").hide();
	}
	
	var cnt=0;
	function openRp(){
		var ifm = document.getElementById("ifrRp");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winRp").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openRp,100);
		}
	}
	
	function schRpPopup(){
		/*
		$("#ifrRp").ready(function(){
			cnt=0;
			setTimeout(openRp,100);
		});
		*/
		
		var f = document.rpForm;
		f.method.value="Main";
        f.commkind.value="com";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORCO010901";
		f.target = "ifrRp";
		f.submit();
	}

</script>
<form name="rpForm">
<input type="hidden" id="path" name="path" />
<input type="hidden" id="method" name="method" />
<input type="hidden" id="commkind" name="commkind" />
<input type="hidden" id="process_id" name="process_id" />
</form>
<div id='winRp' class='popup modal' style="background-color:transparent">
<iframe id='ifrRp' src="about:blank" name='ifrRp' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
