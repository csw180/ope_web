<%--
/*---------------------------------------------------------------------------
 Program ID   : OrgEmpInfP.jsp
 Program name : 공통 > 부서별 직원 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeBuseoEmp(){
		$("#winBuseoEmp").hide();
	}
	
	function schOrgEmpPopup(func,mode){
		var f = document.orgEmpForm;
		f.path.value="/comm/ORCO0106";
		f.search_mode.value=mode;
        f.rtn_func.value=func;
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrOrgEmp";
		f.submit();

	}

</script>
<form name="orgEmpForm">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="rtn_func" name="rtn_func" />
	<input type="hidden" id="search_mode" name="search_mode" />
</form>
<div id='winBuseoEmp' class='popup modal' style="background-color:transparent">
	<iframe id='ifrOrgEmp' src="about:blank" name='ifrOrgEmp' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
