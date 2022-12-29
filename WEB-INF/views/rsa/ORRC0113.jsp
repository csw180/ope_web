<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0116.jsp
 Program name : 비합리적평가 경고 팝업
 Description  : 
 Programer    : 
 Date created : 2020.07.06
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");
DynaForm form = (DynaForm)request.getAttribute("form");

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	<%@ include file="../comm/library.jsp" %>
	<script language="javascript">
		
	$(document).ready(function(){
		
		parent.removeLoadingWs();
		
		// ibsheet 초기화
		initIBSheet();

	});
		
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"평가자",Type:"Text",Width:100,Align:"Center",SaveName:"vlr_ennm",MinWidth:120,Edit:0},
			{Header:"평가항목",Type:"Text",Width:100,Align:"Center",SaveName:"evl_cnt",MinWidth:100,Edit:0},
			{Header:"비합리적 평가 예상 항목수",Type:"Text",Width:200,Align:"Center",SaveName:"non_evl_cnt",MinWidth:200,Edit:0}
		];

		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		mySheet.FitColWidth();
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		doAction('search');

		
	}


	
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":		//저장
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC011602");

					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;

			}
		}

		function mySheet_OnSearchEnd(code, message) {

		    if(code == 0) {
		    	mySheet.FitColWidth();
		        //조회 후 작업 수행
		
			} else {
		
			        alert("조회 중에 오류가 발생하였습니다..");
			        
		
			}

		}
	</script>
	</head>
<body onkeyPress="return EnterkeyPass()";  style="background-color:transparent">
	<form name="ormsForm" method="post">
	<span id="check_list"></span>
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="rk_evl_sc" name="rk_evl_sc" value="<%=form.get("link_rk_evl_sc")%>" />
	<input type="hidden" id="brc" name="brc" value="<%=form.get("brc")%>" />
	
		<!-- 팝업 -->
		<div id="" class="popup modal block">
				<div class="p_frame w500 h450">
					<div class="p_head">
						<h3 class="title md">비합리적 평가 정보 알림</h3>
					</div>
					<div class="p_body">
						<div class="p_wrap">

							<h4 class="title md center w320">아래 평가자의 비합리적 평가가 예상됩니다.</h4>
							<div class="box wrap-table th_bg th_c td_c t1 center">
								<div class="wrap-grid h100">
										<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
								</div>								
							</div>
							<div class="alert alert-warning mt20 center w450">
								비합리적 평가는 RCSA 분석결과를 왜곡시킬 수 있으니<br />재평가를 검토해 주시기 바랍니다.<br />
								<strong>재평가 필요시</strong>, 취소버튼을 누르시고<br />해당 평가자에게 다시 평가를 수행하도록 지시바랍니다.
							</div>
							<div class="message mgs-info center w450">비합리적 평가를 무시하고 지금의 평가결과를 상신하시겠습니까?</div>
						</div><!-- .p_wrap //-->	
					</div><!-- .p_body //-->
					<div class="p_foot">
						<div class="btn-wrap right">
							<button type="button" class="btn btn-primary fl" onclick="javascript:$('.popup',parent.document).removeClass('block');parent.doSave();">상신</button>
							<button type="button" class="btn btn-default btn-close">취소</button>
						</div>
					</div>
					<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
				</div>
			<div class="dim p_close"></div>
		</div>
	</form>		
	
			<!-- .content-wrapper // -->
		
		<!-- popup //-->
	</body>
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(){
			$(".popup",parent.document).removeClass("block");
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});

		</script>
</html>