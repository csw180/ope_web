<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0111.jsp
 Program name : 최근 손실사건 상세 보기
 Description  : 화면정의서 RCSA-08.2.1
 Programer    : 박승윤
 Date created : 2022.09.16
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
String rk_isc_cntn = form.get("link_rk_isc_cntn");
//rk_isc_cntn = new String(rk_isc_cntn.getBytes("ISO8859_1"), "UTF-8");

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	<%@ include file="../comm/library.jsp" %>
	<script language="javascript">
		
	$(document).ready(function(){
		
		parent.removeLoadingWs();
		$("#rk_isc_cntn").text("<%=rk_isc_cntn%>");
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
			{Header:"사건 관리 번호|사건 관리 번호",Type:"Text",Width:100,Align:"Center",SaveName:"lshp_amnno",MinWidth:100,Edit:0},
			{Header:"사건 관리 부서|사건 관리 부서",Type:"Text",Width:200,Align:"Center",SaveName:"brnm",MinWidth:200,Edit:0},
			{Header:"사건 제목|사건 제목",Type:"Text",Width:200,Align:"Center",SaveName:"lss_tinm",MinWidth:200,Edit:0},
			{Header:"일자|발생일자",Type:"Text",Width:200,Align:"Center",SaveName:"ocu_dt",MinWidth:200,Edit:0},
			{Header:"일자|등록일자",Type:"Text",Width:200,Align:"Center",SaveName:"fir_inp_dtm",MinWidth:200,Edit:0},
			{Header:"금액 (단위: 원)|총손실",Type:"Float",Width:200,Align:"Center",Format:"#,##0.###",SaveName:"ttls_am",MinWidth:200,Edit:0},
			{Header:"금액 (단위: 원)|순손실",Type:"Float",Width:200,Align:"Center",Format:"#,##0.###",SaveName:"guls_am",MinWidth:200,Edit:0},
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
					$("form[name=ormsForm] [name=process_id]").val("ORRC011102");

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
<body>
	<form name="ormsForm" method="post">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="rkp_id" name="rkp_id" value="<%=form.get("rkp_id")%>" />
		<div id="" class="popup modal block">
			<div class="p_frame w1500">
	
				<div class="p_head">
					<h3 class="title">최근손실사건(3개년)</h3>
				</div>
	
				<div class="p_body">
					<div class="p_wrap">
	
					<div class="wrap-table">
							<table>
								<thead>
									<th scope="col">리스크 사례</th>
								</thead>
								<tbody>
									<tr>
										<td id = "rk_isc_cntn">										
										</td>
									</tr>
								</tbody>
							</table>
					</div>
	
						<div class="box box-grid mt20">
<!-- 							<div class="box-header">
								<div class="area-tool">
									<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>	
								</div>
							</div> -->
							<div class="box-body">
								<div class="wrap-grid h300">
									<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
								</div>
							</div>
						</div>
	
					</div>
				</div>
	
				<div class="p_foot">
					<div class="btn-wrap center">
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>
				<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
	
			</div>
			<div class="dim p_close"></div>
		</div>
	</form>
</body>	
<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(){
			$(".popup",parent.document).hide();
		});
	});
</script>
</html>