<%--
/*---------------------------------------------------------------------------
 Program ID   : OrgInfMP.jsp
 Program name : 부서 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.11
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeBuseo(){
		//$("#winBuseoM").hide();
		$("#winBuseoM").hide();
	}

	/*
	var cnt=0;
	function openBuseoM(){
		//$("#winBuseo").show();
		var ifm = document.getElementById("ifrOrgM");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winBuseoM").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openBuseoM,100);
		}
	}
	*/

	function schOrgMPopup(brcs, bizo_tpcs, func, mode){
		
		var f = document.orgmForm;

		var org_mode = mode;
		if(org_mode==null || org_mode==undefined || org_mode==""){
			org_mode = "0";
		}
		
		var brcs_html = "";
		for(var i=0; i<brcs.length;i++){
			brcs_html += "<input type='hidden' name='brcs' value='" + brcs[i] + "'>";
		}
		
		$("#brcs_area").html(brcs_html);

		var bizo_tpcs_html = "";
		for(var i=0; i<bizo_tpcs.length;i++){
			bizo_tpcs_html += "<input type='hidden' name='bizo_tpcs' value='" + bizo_tpcs[i] + "'>";
		}
		//alert(bizo_tpcs_html)

		$("#bizo_tpcs_area").html(bizo_tpcs_html);

		/*
		$("#ifrOrgM").ready(function(){
			cnt=0;
			setTimeout(openBuseoM,100);
			//$("#winBuseo").show();
		});
		*/
		f.path.value="/comm/ORCO0108";
        f.org_rtn_func.value=func;
        f.org_mode.value=org_mode;
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrOrgM";
		f.submit();

	}
</script>
<form name="orgmForm">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="org_rtn_func" name="org_rtn_func" />
	<input type="hidden" id="org_mode" name="org_mode" />
	<div id="brcs_area"></div>
	<div id="bizo_tpcs_area"></div>
</form>
<div id='winBuseoM' class='popup modal' style="background-color:transparent">
	<iframe id='ifrOrgM' src="about:blank" name='ifrOrgM' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
