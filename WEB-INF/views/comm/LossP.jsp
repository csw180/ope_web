<%--
/*---------------------------------------------------------------------------
 Program ID   : LossP.jsp
 Program name : 손실사건 조회 레이어
 Description  : 
 Programer    : 박승윤
 Date created : 2022.06.17
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeLoss(){
		//$("#winLoss").hide();
		$("#winLoss").hide();
	}
	
	var cnt=0;
	function openLoss(){
		var ifm = document.getElementById("ifrLoss");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winLoss").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openLoss,100);
		}
	}
	
	function schLossPopup(){


/* 		$("#ifrLoss").ready(function(){
			cnt=0;
			setTimeout(openLoss,100);
		}); */

		var f = document.lossForm;
		f.method.value="Main";
        f.commkind.value="com";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORCO011001";
		f.target = "ifrLoss";
		f.submit();
	}

</script>
<form name="lossForm">
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="path" name="path" />
</form>
<div id='winLoss' class='popup modal' style="background-color:transparent">
	<iframe id='ifrLoss' src="about:blank" name='ifrLoss' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>