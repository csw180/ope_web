<%--
/*---------------------------------------------------------------------------
 Program ID   : LosmsrInfP.jsp
 Program name : 측정대상손실사건 조회 레이어
 Description  : 
 Programer    : 한성준
 Date created : 2020.07.22
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeLosmsr(){
		//$("#winBiz").hide();
		$("#winLosrmsr").hide();
	}
	
	var cnt=0;
	function openBiz(){
		//$("#winBuseo").show();
		var ifm = document.getElementById("ifrLosmsr");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winLosmsr").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openBiz,100);
		}
	}
	
	function schLosmsrPopup(){
		
		$("#ifrLosmsr").ready(function(){
			cnt=0;
			setTimeout(openBiz,100);
		});

		var f = document.LosmsrForm;
		f.path.value="/los/ORLS0119";
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrLosmsr";
		f.submit();
		//$("#winBiz").show();
	}

</script>
<form name="LosmsrForm">
	<input type="hidden" id="path" name="path" />
</form>
<div id='winLosmsr' class='popup modal' style="background-color:transparent">
	<iframe id='ifrLosmsr' src="about:blank" name='ifrLosmsr' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>