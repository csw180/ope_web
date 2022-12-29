<%--
/*---------------------------------------------------------------------------
 Program ID   : OrgInfP.jsp
 Program name : 부서 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeBuseo(){
		$("#winBuseo").hide();
	}

	/*
	var cnt=0;
	function openBuseo(){
		//$("#winBuseo").show();
		var ifm = document.getElementById("ifrOrg");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winBuseo").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openBuseo,10);
		}
	}
	*/
	
	function schOrgPopup(brnm, func, mode){
		var org_mode = mode;
		if(org_mode==null || org_mode==undefined || org_mode==""){
			org_mode = "0";
		}
		
		//setTimeout(openBuseo,1);
		/*
		$("#ifrOrg").ready(function(){
			cnt=0;
			setTimeout(openBuseo,10);
			//$("#winBuseo").show();
		});
		*/
		var f = document.orgForm;
		f.path.value="/comm/ORCO0107";
        f.org_search_txt.value=$("#"+brnm).val();
        f.org_rtn_func.value=func;
        f.org_mode.value=org_mode;
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrOrg";
		f.submit();

	}

</script>
<form name="orgForm">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="org_search_txt" name="org_search_txt" />
	<input type="hidden" id="org_rtn_func" name="org_rtn_func" />
	<input type="hidden" id="org_mode" name="org_mode" />
</form>
<div id='winBuseo' class='popup modal'>
	<iframe id='ifrOrg' src="about:blank" name='ifrOrg'></iframe>
</div>
