<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0135.jsp
 Program name : ADMIN > 배치 > 시스템관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.07.09
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		<script>
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet1();
				initIBSheet2();
				reqDatafree();
				
			});

			function reqDatafree() {
				
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("adm");
				$("form[name=ormsForm] [name=process_id]").val("ORAD013503");
	
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setForm(f);
	
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
	
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,{
					success: function(result){
						var rList = result.DATA;
						if(result!='undefined') {
							if(rList.length>0){
								if(rList[0].min_cmdl_exe_sqno != null && rList[0].min_cmdl_exe_sqno != ""){
									$("form[name=ormsForm] [name=min_cmdl_exe_sqno]").val(rList[0].min_cmdl_exe_sqno);
									$("form[name=ormsForm] [name=max_cmdl_exe_sqno]").val(rList[0].max_cmdl_exe_sqno);
									retry_cnt = 0;
									setTimeout(checkRetry,1000);
								}else{
									removeLoadingWs();
								}
							}else{
								removeLoadingWs();
							}
						}else{
							removeLoadingWs();
						}
					},
	
					complete: function(statusText,status) {
						//removeLoadingWs();
					},
	
					error: function(rtnMsg) {
						alert(JSON.stringify(rtnMsg));
					}
				});
			}

			var retry_cnt = 0;
			function checkRetry() {
				if(retry_cnt > 10){
					alert("데이터용량 조회 처리를 할 수 없습니다. 서버를 확인하시고 재조회 하세요.");
					return;
				}
				callORAD013404();
			}
			function callORAD013404() {
				
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("adm");
				$("form[name=ormsForm] [name=process_id]").val("ORAD013404");
	
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setForm(f);
	
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
	
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,{
					success: function(result){
						var rList = result.DATA;
						if(result!='undefined') {
							//alert("rList.length:"+rList.length);
							if(rList.length>0){
								if(rList[0].cmdl_prc_stsc=="01" || rList[0].cmdl_prc_stsc=="02"){ 
									setTimeout(checkRetry,1000);
								}else{
									$("form[name=ormsForm] [name=datafree]").val(rList[0].cmdl_prcrzt_cntn);
									removeLoadingWs();
								}
							}else{
								removeLoadingWs();
							}
						}else{
							removeLoadingWs();
						}
					},
	
					complete: function(statusText,status) {
						//removeLoadingWs();
					},
	
					error: function(rtnMsg) {
						alert(JSON.stringify(rtnMsg));
					}
				});
			}

			function initIBSheet1() {
				//시트 초기화
				mySheet1.Reset();
				
				var initData = {};
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
				initData.Cols = [
				    {Header:"테이블스페이스명",	Type:"Text",	SaveName:"tablespace_name",			Width:150,	Align:"Center"},
				    {Header:"총할당량(Gb)",		Type:"Float",	Format:"0.#", SaveName:"total_size",			Width:80,	Align:"Right"},
				    {Header:"총사용량(Gb)",		Type:"Float",	Format:"0.#", SaveName:"used_size",				Width:80,	Align:"Right"},
				    {Header:"여유량(Gb)",		Type:"Float",	Format:"0.#", SaveName:"free_size",				Width:80,	Align:"Right"},
				    {Header:"사용률(%)",		Type:"Float",	Format:"0.#", SaveName:"use_rate",				Width:80,	Align:"Right"}
				];
				IBS_InitSheet(mySheet1,initData);
				
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet1.SetCountPosition(3);
				
				mySheet1.SetFocusAfterProcess(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet1.SetSelectionMode(4);
				
				mySheet1.SetEditable(0);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				//헤더기능 해제
				//mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				
				doAction("search");
				
			}
			
			function initIBSheet2() {
				//시트 초기화
				mySheet2.Reset();
				
				var initData = {};
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
				initData.Cols = [
					{Header:"테이블스페이스명",	Type:"Text",	SaveName:"tablespace_name",			Width:120,	Align:"Center"},
					{Header:"테이블명",			Type:"Text",	SaveName:"table_name",				Width:120,	Align:"Center"},
					{Header:"COMMENTS",		Type:"Text",	SaveName:"comments",				Width:240,	Align:"Center"},
					{Header:"파티션(MAX)",		Type:"Text",	SaveName:"partition_name_max",		Width:100,	Align:"Center"},
					{Header:"파티션(MIN)",		Type:"Text",	SaveName:"partition_name_min",		Width:100,	Align:"Center"},
					{Header:"파티션명",			Type:"Text",	SaveName:"partition_name",			Width:100,	Align:"Center"},
					{Header:"타입",			Type:"Text",	SaveName:"type",					Width:120,	Align:"Center"}
				];
				IBS_InitSheet(mySheet2,initData);
				
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet2.SetCountPosition(3);
				
				mySheet2.SetFocusAfterProcess(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet2.SetSelectionMode(4);
				
				mySheet2.SetEditable(0);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				//헤더기능 해제
				//mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				
				doAction("search2");
				
			}
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD013502");
						
						mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;
					case "search2":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD013504");
						
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;
				}
			}
	
			function mySheet1_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다.");
				}
			}
			
			function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				if(Row >= mySheet.GetDataFirstRow()){
				}
			}
			
	</script>
	</head>
	<body>
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			<!-- content -->
			<div class="content">
				<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="min_cmdl_exe_sqno" name="min_cmdl_exe_sqno" />
				<input type="hidden" id="max_cmdl_exe_sqno" name="max_cmdl_exe_sqno" />
				<div class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">테이블스페이스 용량 조회</h2>
					</div>
					<div class="box-body">
						<div class="wrap-grid h200">
							<script type="text/javascript">createIBSheet("mySheet1", "100%", "100%"); </script>
						</div>
					</div>
				</div>
				<div class="box box-grid mt30">
					<div class="box-header">
						<h2 class="box-title">테이블스페이스 파티션 조회</h2>
					</div>
					<div class="box-body">
						<div class="wrap-grid h200">
							<script type="text/javascript">createIBSheet("mySheet2", "100%", "100%"); </script>
						</div>
					</div>
				</div>
				<div class="box box-grid mt30">
					<div class="box-header">
						<h2 class="box-title">파일 시스템 용량 조회</h2>
					</div>
					<div class="box-body">
						<div class="wrap-grid h150">
							<textarea name="datafree" id="datafree" class="textarea h100" readonly></textarea>
						</div>
					</div>
				</div>
			</div>
			<!-- content //-->
		</div>
	</body>
</html>