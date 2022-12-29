<%--
/*---------------------------------------------------------------------------
 Program ID   : EmpInfP.jsp
 Program name : 공통 > 직원 조회 레이어
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.11
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeEmp(){
		//$("#winEmp").hide();
		$("#winEmp").hide();
	}
	
	var cnt=0;
	function openEmp(){
		//$("#winBuseo").show();
		var ifm = document.getElementById("ifrEmp");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winEmp").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openEmp,100);
		}
	}
	
	function schEmpPopup(brc, func){
		/*
		$("#ifrEmp").ready(function(){
			cnt=0;
			setTimeout(openEmp,100);
		});
		*/

		var f = document.empForm;
		f.path.value="/comm/ORCO0112";
        f.emp_rtn_func.value=func;
        f.brc.value=brc;
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrEmp";
		f.submit();

	}
</script>
<form name="empForm">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="emp_rtn_func" name="emp_rtn_func" />
	<input type="hidden" id="brc" name="brc" />
</form>
<div id='winEmp' class='popup modal' style="background-color:transparent">
	<iframe id='ifrEmp' src="about:blank" name='ifrEmp' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>