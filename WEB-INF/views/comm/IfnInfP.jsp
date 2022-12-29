<%--
/*---------------------------------------------------------------------------
 Program ID   : IfnInfP.jsp
 Program name : 영향유형 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.04
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
function closeIfn(){
	$("#winIfn").hide();
}

var cnt=0;
function openIfn(){
	var ifm = document.getElementById("ifrIfn");
	if(ifm.contentDocument.readyState == "complete"){
		$("#winIfn").show();
	}else{
		if(cnt>1000){
			return;
		}
		cnt++;
		setTimeout(openIfn,100);
	}
}

function schIfnPopup(){
	
	/*
	$("#ifrIfn").ready(function(){
		cnt=0;
		setTimeout(openIfn,100);
	});
	*/

	var f = document.ifnForm;
	f.path.value="/comm/ORCO0105";
    f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
	f.target = "ifrIfn";
	f.submit();
}

</script>
<form name="ifnForm">
<input type="hidden" id="path" name="path" />
</form>
<div id='winIfn' class='popup modal' style="background-color:transparent">
<iframe id='ifrIfn' src="about:blank" name='ifrIfn' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
