<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0120.jsp
 Program name : KRI > KRI 평가 > KRI 전산데이터 관리 > 데이터 변경 이력 조회
 Description  : 
 Programer    : 권성학
 Date created : 2021.12.20
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="org.json.simple.*,java.net.*" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	String sel_brc = request.getParameter("grd2_brc");
	String bas_ym = request.getParameter("grd2_bas_ym");
	String rki_id = request.getParameter("grd2_rki_id");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
			
		$(document).ready(function(){
			//$("#winRskMod",parent.document).show();
			// ibsheet 초기화
			parent.removeLoadingWs();
			initIBSheet1();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData1 = {};
			
			initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
			initData1.Cols = [
	   			{Header:"RI-ID",Type:"Text",Width:60,Align:"Center",SaveName:"oprk_rki_id",MinWidth:60,Edit:false},
				{Header:"기준년월",Type:"Text",Width:60,Align:"Center",SaveName:"bas_ym",MinWidth:60,Edit:false},
				{Header:"일련번호",Type:"Text",Width:60,Align:"Center",SaveName:"sqno",MinWidth:60,Edit:false},
				{Header:"변경자",Type:"Text",Width:60,Align:"Center",SaveName:"empnm",MinWidth:60,Edit:false},
				{Header:"변경일시",Type:"Text",Width:60,Align:"Center",SaveName:"chg_dtm",MinWidth:60,Edit:false},
				{Header:"변경전값",Type:"Text",Width:60,Align:"Center",SaveName:"fst_val",MinWidth:60,Edit:false}
			];
			
			IBS_InitSheet(mySheet1,initData1);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(3);
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//최초 조회시 포커스를 감춘다.
			mySheet1.SetFocusAfterProcess(0);
			
			mySheet1.SetAutoRowHeight(1);
			
			//헤더기능 해제
			//mySheet1.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
	
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			doAction("search");
			
		}
	
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {
	
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		}
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR012002");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);	
			}
		}
		
	</script>
</head>
<body>
	<div id="" class="popup modal block">
		<div class="p_frame w800">
			<form name="ormsForm" method="post">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="brc" name="brc" value="<%=sel_brc%>" />
			<input type="hidden" id="bas_ym" name="bas_ym" value="<%=bas_ym%>" />
			<input type="hidden" id="rki_id" name="rki_id" value="<%=rki_id%>" />
			<div class="p_head">
				<h3 class="title">KRI 데이터 변경 이력 조회</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-grid">
						<div class="box-body">
							<div class="wrap-grid h300">
								<script> createIBSheet("mySheet1", "100%", "100%"); </script>
							</div>
						</div>
					</div>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
			</form>
		</div>
		<div class="dim p_close"></div>
	</div>
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				parent.$("#ifrKriHis").attr("src","about:blank");
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winORKR2001",parent.document).hide();
			parent.$("#ifrKriHis").attr("src","about:blank");
		}
	</script>
</body>
</html>