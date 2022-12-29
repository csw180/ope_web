<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0112.jsp
 Program name : 공통 > 직원 조회(팝업)
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.11
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
DynaForm form = (DynaForm)request.getAttribute("form");
String emp_rtn_func = form.get("emp_rtn_func");
String sel_brc = form.get("brc");
%>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			$("#winEmp",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData.Cols = [
 				{Header:"부서코드",	Type:"Text",	SaveName:"brc",		Hidden:true},
 				{Header:"부서명",		Type:"Text",	SaveName:"brnm",	Width:200,		MinWidth:50, Align:"Center"},
 				{Header:"직급",		Type:"Text",	SaveName:"pzcnm",	Width:120,		MinWidth:50, Align:"Center"},
 				{Header:"직원명",		Type:"Text",	SaveName:"empnm",	Width:130,		MinWidth:50, Align:"Center"},
 				{Header:"직원번호",	Type:"Text",	SaveName:"eno",		Width:90,		MinWidth:50, Align:"Center"}
 			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);

			doAction('search');
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				//alert($("#emp_no").val() + ":" + $("#emp_nm").val());
				//parent.empSearchEnd($("#emp_no").val(), $("#emp_nm").val());
				$("#emp_no").val(mySheet.GetCellValue(Row, "eno"));
				$("#emp_nm").val(mySheet.GetCellValue(Row, "empnm"));
				$("#br_nm").val(mySheet.GetCellValue(Row, "brnm"));
				$("#pzcnm").val(mySheet.GetCellValue(Row, "pzcnm"));
				
				doAction('select');
			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#emp_no").val(mySheet.GetCellValue(Row, "eno"));
				$("#emp_nm").val(mySheet.GetCellValue(Row, "empnm"));
				$("#br_nm").val(mySheet.GetCellValue(Row, "brnm"));
				$("#pzcnm").val(mySheet.GetCellValue(Row, "pzcnm"));
			}
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					$("#emp_nm").val("");
					$("#emp_no").val("");
					$("#br_nm").val("");
					$("#pzcnm").val("");
					
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					$("form[name=ormsForm] [name=process_id]").val("ORCO011202");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "select": 
					if($("#emp_no").val() == ""){
						alert("직원을 선택해 주십시오.");
						return;
					}
					
					var func = eval("parent."+$("#emp_rtn_func").val());
				
					func($("#emp_no").val(), $("#emp_nm").val(), $("#br_nm").val(), $("#pzcnm").val());
					
					break;
			}
		}

		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			mySheet.FitColWidth();
		}

		
	</script>

</head>
<body onkeyPress="return EnterkeyPass()">
	<form name="ormsForm" method="post">
	<input type="hidden" id="brc" name="brc" value="<%=StringUtil.htmlEscape(sel_brc)%>"/> <!-- 검색대상 부서 코드 -->
	<input type="hidden" id="emp_nm" name="emp_nm" /> <!-- 선택한 직원명 -->
	<input type="hidden" id="emp_no" name="emp_no" /> <!-- 선택한 직원번호 -->
	<input type="hidden" id="br_nm" name="br_nm" /> <!-- 선택한 부서명 -->
	<input type="hidden" id="pzcnm" name="pzcnm" /> <!-- 선택한 직명 -->
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="emp_rtn_func" name="emp_rtn_func" value="<%=StringUtil.htmlEscape(emp_rtn_func)%>"/>
	
	<!-- popup -->
	<article class="popup modal block" >
		<div class="p_frame w600">
			<div class="p_head">
				<h1 class="title">직원 선택</h1>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<section class="box box-grid">
						<div class="wrap-grid h350">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>
				</div><!-- p_wrap //-->
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="doAction('select');">선택</button>
					<button type="button" class="btn btn-default btn-pclose">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
	</form>	
	
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				//$("#winEmp",parent.document).hide();
				$("#winEmp",parent.document).hide();
				event.preventDefault();
			});
			/*
			//열기
			$(".btn-open").click( function(){
				$(".popup",parent.document).show();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				$(".popup",parent.document).hide();
			});
			*/
		});
			
		function closePop(){
			//$("#ifrOrg",parent.document).attr("src","about:blank");
			//$("#winEmp",parent.document).hide();
			$("#winEmp",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#brc").val("");
			$("#emp_no").val("");
			$("#emp_nm").val("");
			$("#br_nm").val("");
			$("#pzcnm").val("");
			closePop();
		});
		
	</script>	
</body>
</html>
