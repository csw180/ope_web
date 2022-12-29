<%--
/*---------------------------------------------------------------------------
 Program ID   : KriP.jsp
 Program name : KRI 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2020.06.30
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeKri(){
		//$("#winKri").hide();
		$("#winKri").hide();
	}
	
	var cnt=0;
	function openKri(){
		var ifm = document.getElementById("ifrKri");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winKri").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openKri,100);
		}
	}
	
	function schKriPopup(){
		
		/* $("#ifrKri").ready(function(){
			cnt=0;
			setTimeout(openKri,100);
		}); */

		var f = document.kriForm;
		f.method.value="Main";
        f.commkind.value="com";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORCO011101";
		f.target = "ifrKri";
		f.submit();
	}

</script>
<form name="kriForm">
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="path" name="path" />
</form>
<div id='winKri' class='popup modal' style="background-color:transparent">
	<iframe id='ifrKri' src="about:blank" name='ifrKri' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>