<%--
/*---------------------------------------------------------------------------
 Program ID   : AccConnP.jsp
 Program name : 계정연결 레이어
 Description  : 
 Programer    : 한성준
 Date created : 2020.07.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	function closeAccConn(){
		$("#winAccConn").hide();
	}
	
	function schAccConnPopup(sheetno){
		
		var f = document.accConnForm;
		f.sheetno.value=sheetno;
		f.method.value="Main";
        f.commkind.value="los";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORLS010501";
		f.target = "ifrAccConn";
		f.submit();
	}

</script>
<form name="accConnForm">
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="sheetno" name="sheetno" />
</form>
<div id='winAccConn' class='popup modal' style="background-color:transparent">
	<iframe id='ifrAccConn' src="about:blank" name='ifrAccConn' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
</div>