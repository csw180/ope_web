<%--
/*---------------------------------------------------------------------------
 Program ID   : DczP.jsp
 Program name : 공통 > 결재 팝업 레이어
 Description  : 
 Programmer : 권성학
 Date created : 2021.05.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeDczP(){
		$("#winDcz").hide();
	}
	
	function schDczPopup(func){
		var f = document.dczForm;
		f.path.value="/comm/ORCO0114";
        f.rtn_func.value=func;
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrDcz";
		f.submit();
	}

</script>
<form name="dczForm">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="rtn_func" name="rtn_func" />
</form>
<div id='winDcz' class='popup modal' style="background-color:transparent">
	<iframe id='ifrDcz' src="about:blank" name='ifrDcz' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>
