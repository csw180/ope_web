<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0104.jsp
 Program name : 계정과목 영업지수 매핑관리
 Description  : MSR-05
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>영업지수 잔액 조회(공통)</title>
	<script>
	
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet();
			initIBSheet1();
			initIBSheet2();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			/*mySheet*/
			initData.Cfg = {"DataRowMerge":1,"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};
			var headers = [{Text:"영업지수요소|영업지수요소|영업지수(BI)|영업지수(BI)|영업지수(BI)", Align:"Center"}, 
				{Text:"구분|항목|매핑건수|미매핑건수|합계", Align:"Center"}];
			
			initData.Cols = [
				{Type:"Text",Width:150,Align:"Center",SaveName:"biz_ix_lv1_nm",MinWidth:100,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"biz_ix_lv2_nm",MinWidth:100,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"cnt1",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Text",Width:150,Align:"Center",SaveName:"cnt2",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Text",Width:150,Align:"Center",SaveName:"cnt3",MinWidth:100,Edit:false}
				
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);
			


			mySheet.InitHeaders(headers);
			mySheet.SetMergeSheet(eval("msAll"));
			
			
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			mySheet.SetAutoSumPosition(1);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		
			doAction('search');
			
		}
		
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			
			var headers = [{Text:"구분|항목|레벨|상위/기표|CoA코드|계정과목명|변경전|변경전|변경후|변경후|저장일자(등록/변경)", Align:"Center"},
						   {Text:"구분|항목|레벨|상위/기표|CoA코드|계정과목명|Lv.1|Lv.2|Lv.1|Lv.2|저장일자(등록/변경)", Align:"Center"}];
			
			initData.Cols = [
				{Type:"Text",Width:100,Align:"Center",SaveName:"status",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"acc_tpcnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:60,Align:"Center",SaveName:"lvl_no",MinWidth:60,Edit:false},
				{Type:"Text",Width:70,Align:"Center",SaveName:"fill_yn_dscnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:350,Align:"Left",SaveName:"acc_sbj_cnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:350,Align:"Left",SaveName:"acc_sbjnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"bf_lv1_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"bf_lv2_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"af_lv1_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"af_lv2_biz_ix_nm",MinWidth:60,Edit:false},
				//{Type:"Text",Width:100,Align:"Center",SaveName:"sbj_cntn",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"lschg_dtm",MinWidth:60,Edit:false}	
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet1,initData);
			
			mySheet1.InitHeaders(headers);
			mySheet1.SetMergeSheet(eval("msHeaderOnly"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		
			doAction('search1');
			
		}
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.Cols = [
			 	{Header:"선택",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50,Edit:1},
				{Header:"기준년월",Type:"Text",Width:120,Align:"Center",SaveName:"bas_yy",MinWidth:60,Edit:0, ColMerge:0},
				{Header:"기준년월",Type:"Text",Width:120,Align:"Center",SaveName:"bas_mm",MinWidth:60,Edit:0, ColMerge:0},
				{Header:"파일명",Type:"Text",Width:680,Align:"Left",SaveName:"apflnm",MinWidth:150,Edit:0},
			];
			
			IBS_InitSheet(mySheet2,initData);
			//필터표시
			//mySheet1.ShowFilterRow();  
			//mySheet1.SetEditable(0);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			doAction('search2');
			//mySheet1.SetTheme("WHM", "ModernWhite");
			//mySheet1.SetTheme("GM", "Main");
		}
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction("loadexcel");
			}
		}
		
		function addORMR0103(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="msr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORMR010301";
			f.target = "ifrORMR0103";
			f.submit();
		}
		
		function modORMR0102(){
			var f = document.ormsForm;
			
			f.method.value="Main";
	        f.commkind.value="msr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORMR010201";
			f.target = "ifrORMR0102";
			f.mode.value = "U"; 
			f.submit();
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
				$("#acc_sbj_cnm").val(mySheet.GetCellValue(Row,"acc_sbj_cnm")); //계정과목코드
				
				doAction('mod');
			}
		}
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					/* if($('#sch_bas_yy').val() == "" || $('#sch_bas_yy').val() == null){
						alert("연도정보가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
					
					var bas_ym = $('#sch_bas_yy').val()+""+$('#sch_bas_qq').val(); */ //기준년월 (연도 + 분기)
				
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010402");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "search1":  //데이터 조회	
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010403");
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "search2":  //데이터 조회	
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010405");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "mod":		//수정 팝업
					
					var srow = mySheet1.GetSelectRow();
					if(srow == -1){
						alert("조회된 데이터가 없습니다.");
						return;
					}
					$('#acc_sbj_cnm').val(mySheet1.GetCellValue(srow,"acc_sbj_cnm")); 
					
					if(mySheet1.GetCellValue(srow,"acc_sbj_cnm") == ""){
						alert("대상 항목을 선택하세요.");
						return;
					}else{
						
						$("#ifrORMR0102").attr("src","about:blank");
						alert($("#ifrORMR0102").val());
						$("#winORMR0102").show();
						
						showLoadingWs(); // 프로그래스바 활성화
						
						setTimeout(modORMR0102,1);
						alert("@@@@@@@@@@");
					}
					break;
				case "save":
					var i = 0;
					var cnt = 0;
					if(mySheet2.GetDataFirstRow()>0){
						for(var i=mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
							if(mySheet2.GetCellValue(i, "ischeck")=="1"){
								$('#sch_bas_ym').val(mySheet2.GetCellValue(i,"bas_yy")+mySheet2.GetCellValue(i,"bas_mm"));
								cnt++;
							}
						}
					}
					<%-- //var f = document.ormsForm;

					if(!confirm("저장하시겠습니까?")) return;

					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR010407");

					WP.setForm(f);
					
					var url = "<%=System.getProperty("contextpath")%>/comMain.do";
					var inputData = WP.getParams();

								
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
						{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="S") {
									
									alert("저장 하였습니다.");
									doAction('search');
									doAction('search1');
									

								}else if(result!='undefined'){
									alert(result.rtnMsg);
								}else if(result!='undefined'){
									alert("처리할 수 없습니다.");
								}  
							},
						  
							complete: function(statusText,status){
								removeLoadingWs();
								//parent.goSavEnd();
							},
						  
							error: function(rtnMsg){
								alert(JSON.stringify(rtnMsg));
							}
					}); --%>
					
					break;
				case "final":
					save();
					break;
				case "help":
					$("#winHelp").show();
					break;
				case "reload":  //조회데이터 리로드
					mySheet.RemoveAll();
					initIBSheet();
					break;
					
				case "down2excel":
					mySheet1.Down2ExcelBuffer(true);
					mySheet1.Down2Excel({FileName:'영업지수등록/변경관리',SheetName:'계정과목 영업지수 매핑 신규 등록/수정 명세', DownCols:'0|1|2|3|4|5|6|7|8|9|10|11', Merge :1});
					mySheet.Down2Excel({FileName:'영업지수매핑현황 ',SheetName:'영업지수매핑현황', DownCols:'0|1|2|3|4', Merge :1});
					mySheet1.Down2ExcelBuffer(false);
					break;
			}
		}
	
		
		function mySheet_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		}
		
		function save(){
			
			var f = document.ormsForm;

			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "msr");
			WP.setParameter("process_id", "ORMR010406");

			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

						
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							
							alert("저장 하였습니다.");
							doAction('search');
							doAction('search1');
							

						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						//parent.goSavEnd();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
		function save_output(){
			var i = 0;
			var cnt = 0;
			if(mySheet2.GetDataFirstRow()>0){
				for(var i=mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
					if(mySheet2.GetCellValue(i, "ischeck")=="1"){
						$('#sch_bas_ym').val(mySheet2.GetCellValue(i,"bas_yy")+mySheet2.GetCellValue(i,"bas_mm"));
						cnt++;
					}
				}
				if(cnt != 1){
					alert("산출을 원하는 1개 분기를 선택해주세요.");
					return;
				}
			}
			var f = document.ormsForm;

			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "msr");
			WP.setParameter("process_id", "ORMR010407");

			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

						
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="X") {						
							alert("저장 하였습니다.");
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						//parent.goSavEnd();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
	</script>
	
</head>
<body>
	<div class="container">
		<!-- page-header -->
		<%@ include file="../comm/header.jsp" %>
		<!--.page header //-->
		<!-- content -->
		<div class="content">
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="mode" name="mode" value="" /> <!-- 신규수정 구분(I:신규 U:수정) -->
			<input type="hidden" id="acc_sbj_cnm" name="acc_sbj_cnm" value="" /> <!-- 계정과목코드 -->
			<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" />
			<input type="hidden" id="sch_lv1_biz_ix_c" name="sch_lv1_biz_ix_c" /> <!-- 20210720 컨설팅 협의후 조회조건 삭제 .pc에서 사용해서 빈값 넘김 -->
			<input type="hidden" id="sch_lv2_biz_ix_c" name="sch_lv2_biz_ix_c" />
			<!-- 조회 -->
			<div class="box box-grid">				
				<div class="box-header" align="right">
					<div class="btn-wrap">
						<button class="btn btn-normal btn-xs" type="button" onclick="javascript:doAction('help');"><i class="fa fa-exclamation-circle"></i><span class="blind">Help</span></button>
					</div>
				</div>

				<div class="row">
					<div class="col col-xs-4">
						<div class="box-header">
							<h2 class="box-title">영업지수 매핑현황</h2>
						</div>
						<div class="box-body">
							<div class="wrap-grid h700">
								<script> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>	
					</div>
					<div class="col col-xs-8">
						<div class="box-grid">
							<div class="box-header">
								<h2 class="box-title">영업지수 등록/변경 관리</h2>
								<div class="area-tool" align="right">
									<button class="btn btn-default" type="button" onclick="javascript:doAction('final');"><span class="txt">최종확정</span></button>
									<button class="btn btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
								</div>
							</div>
							<div class="box-body">
								<div class="wrap-grid h400">
									<script> createIBSheet("mySheet1", "100%", "100%");</script>
								</div>
							</div>
							<div class="box-header">
								<h2 class="box-title">산출값 계산</h2>
								<div class="area-tool" align="right">
								<button class="btn btn-default" type="button" onclick="javascript:save_output();"><span class="txt">저장</span></button>
								</div>
							</div>
							<div class="box-body">
								<div class="wrap-grid h300">
									<script> createIBSheet("mySheet2", "100%", "100%");</script>
								</div>
							</div>
						</div>
					</div>	
				</div>
			</div>
		</form>
	</div>
	<!-- content //-->
	<div id="winHelp" class="popup modal" style="background-color:transparent">
		<iframe name="ifrHelp" id="ifrHelp" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/msr/ORMR0103" width="100%" height="100%" frameborder="0" allowTransparency="true" ></iframe>
	</div>
	<div id="winORMR0102" class="popup modal">
		<iframe name="ifrORMR0102" id="ifrORMR0102" src="about:blank"></iframe>
	</div>
	</div>
</body>
</html>