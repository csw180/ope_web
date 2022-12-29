<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0105.jsp
 Program name : 계정과목 영업지수 매핑테이블 조회
 Description  : MSR-06
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
/* Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
if(vLst3==null) vLst3 = new Vector(); */

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector vLst= CommUtil.getCommonCode(request, "LV1_BIZ_IX_C");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getCommonCode(request, "LV2_BIZ_IX_C");
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getCommonCode(request, "ACC_TPC");
if(vLst3==null) vLst3 = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>계정과목 매핑 테이블 조회(공통)</title>
	<script>
		
		$(document).ready(function(){
			
			// 멀티셀렉스 체크박스 .mS01 BS/PL
			$(document).bind('click', function(e) {
				var $clicked = $(e.target);
				if (!$clicked.parents().hasClass("dropdown")) $(".dropdown.mS01 dd ul").hide();
			});
			
			$('#sch_acc_tpc_all').on('change', function() {
				var flag = false;
				if($('#sch_acc_tpc_all').is(":checked")) flag = true;
		<%
				for(int i=0;i<vLst3.size();i++){
					HashMap hMap = (HashMap)vLst3.get(i);
		%>
					$("form[name=ormsForm] [name=sch_acc_tpc]:eq(<%=i%>)").prop("checked",flag);
		<%
				}
		%>
			});
			

			$('.mS01 .mutliSelect input[type="checkbox"]').on('click', function() {

				var title = $(this).closest('.mS01 .mutliSelect').find('input[type="checkbox"]').val(),
				    title = $(this).val() + " ";
					
				$('.mS01 .multiSel').html("");
				var check_cnt = 0;
				for(var i=0;i<2;i++){
					if($("form[name=ormsForm] [name=sch_acc_tpc]:eq("+(i)+")").is(":checked")){
						check_cnt++;
						var html = '<span title="' + title + '">' + $("form[name=ormsForm] [name=sch_acc_tpc]:eq("+(i)+")").parent().children("label").html() + '</span>';
						$('.mS01 .multiSel').append(html);
					}
				}

				if(check_cnt==2){
					$('#sch_acc_tpc_all').prop("checked",true);
					$(".mS01 .multiSel").hide();
					$(".mS01 .hida").show();
				}else{
					$('#sch_acc_tpc_all').prop("checked",false);
					$(".mS01 .hida").hide();
					$(".mS01 .multiSel").show();
				}
			});

			// ibsheet 초기화
			initIBSheet();
			initIBSheet1();
			// 그룹계정 체크 변경시
			$('#sch_grp_acc_yn').change(function(){
				if(this.checked) $('#sch_grp_acc_yn').val("Y");
				else $('#sch_grp_acc_yn').val("");
			});
			
			// 은행자율계정 체크 변경시
			$('#sch_bnk_self_acc_yn').change(function(){
				if(this.checked) $('#sch_bnk_self_acc_yn').val("Y");
				else $('#sch_bnk_self_acc_yn').val("");
			});
			
			// 연결실계정 체크 변경시
			$('#sch_cnct_acc_yn').change(function(){
				if(this.checked) $('#sch_cnct_acc_yn').val("Y");
				else $('#sch_cnct_acc_yn').val("");
			});
			
			// 영업지수 Lv1 변경시
			$('#sch_lv1_biz_ix_c').change(function(){
				$('#sch_lv2_biz_ix_c option').remove();
				$('#sch_lv2_biz_ix_c').prepend("<option value=''>전체</option>");
				if($('#sch_lv1_biz_ix_c option:selected').val() == ""){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
	}
%>	
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "01"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("01")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>					
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "02"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("02")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "03"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("03")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "99"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("99")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}
			});
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};
			
			var headers = [{Text:"계정과목 정보|계정과목 정보|계정과목 정보|계정과목 정보|계정과목 정보|계정과목 정보|계정과목 정보|영업지수 정보|영업지수 정보|영업지수 정보|영업지수 정보", Align:"Center"}
 	    	  			  ,{Text:"BS/PL|계정과목코드|레벨|업로드레벨|계정과목명|상위계정코드|매핑 여부|영업지수코드|영업지수 Lv.1|영업지수 Lv.2", Align:"Center"}];

			initData.Cols = [
				{Type:"Text",Width:100,Align:"Center",SaveName:"acc_tpcnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"acc_sbj_cnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:60,Align:"Center",SaveName:"level",MinWidth:60,Edit:false},
				{Type:"Text",Width:70,Align:"Center",SaveName:"lvl_no",MinWidth:60,Edit:false},
				{Type:"Text",Width:350,Align:"Left",SaveName:"acc_sbjnm",MinWidth:60,Edit:false,TreeCol:1},
				//{Type:"Text",Width:100,Align:"Center",SaveName:"sbj_cntn",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"up_acc_sbj_cnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:100,Align:"Center",SaveName:"mapping_yn",MinWidth:60,Edit:false},
				{Type:"Text",Width:100,Align:"Center",SaveName:"biz_ix_c",MinWidth:60,Edit:false,Hidden:true},
				{Type:"Text",Width:150,Align:"Center",SaveName:"lv1_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"lv2_biz_ix_nm",MinWidth:60,Edit:false}
			];
			
			IBS_InitSheet(mySheet,initData);
			
			mySheet.InitHeaders(headers);
			mySheet.SetMergeSheet(eval("msAll"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
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
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};
			
			var headers = [{Text:"구분|항목|유형코드|레벨|상위/기표|COA계정코드|계정과목명|변경전|변경전|변경후|변경후|반영일|반영일", Align:"Center"}
 	    	  			  ,{Text:"구분|항목|유형코드|레벨|상위/기표|COA계정코드|계정과목명|Lv.1|Lv.2|Lv.1|Lv.2|반영일|반영일", Align:"Center"}];

			initData.Cols = [
				{Type:"Text",Width:100,Align:"Center",SaveName:"status",MinWidth:60,Edit:false},
				{Type:"Text",Width:100,Align:"Center",SaveName:"acc_tpcnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"acc_tpc",MinWidth:60,Edit:false, Hidden:true},
				{Type:"Text",Width:60,Align:"Center",SaveName:"lvl_no",MinWidth:60,Edit:false},
				{Type:"Text",Width:70,Align:"Center",SaveName:"fill_yn_dscnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:350,Align:"Left",SaveName:"acc_sbj_cnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:350,Align:"Left",SaveName:"acc_sbjnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"bf_lv1_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"bf_lv2_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"af_lv1_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"af_lv2_biz_ix_nm",MinWidth:60,Edit:false},
				//{Type:"Text",Width:100,Align:"Center",SaveName:"sbj_cntn",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"lschg_dtm",MinWidth:60,Edit:false},
				{Type:"Text",Width:100,Align:"Center",SaveName:"vld_ed_dt",MinWidth:60,Edit:false, Hidden:true}
				
			];
			
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
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#acc_sbj_cnm").val(mySheet.GetCellValue(Row,"acc_sbj_cnm")); //계정과목코드
				
				doAction('mod');
			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#acc_sbj_cnm").val(mySheet.GetCellValue(Row,"acc_sbj_cnm"));
			}
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
				$("#acc_sbj_cnm").val(mySheet.GetCellValue(Row,"acc_sbj_cnm")); //계정과목코드
				
				doAction('mod1');
			}
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
		
		function modORMR0102_search(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="msr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORMR010204";
			f.target = "ifrORMR0102";
			f.mode.value = "S"; 
			f.submit();
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
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					for(var i=0;i<5;i++){
						$("form[name=ormsForm] [name=sch_acc_tpc_"+(i+1)+"]").val("");
						if($("form[name=ormsForm] [name=sch_acc_tpc]:eq("+(i)+")").is(":checked")){
							$("form[name=ormsForm] [name=sch_acc_tpc_"+(i+1)+"]").val($("form[name=ormsForm] [name=sch_acc_tpc]:eq("+(i)+")").val());
						}
					}
			
					/* if($('#sch_acc_tpc_1').val() == "" && $('#sch_acc_tpc_2').val() == "" && $('#sch_acc_tpc_3').val() == "" && $('#sch_acc_tpc_4').val() == "" && $('#sch_acc_tpc_5').val() == ""){
						alert("BS/PL은 필수 입력항목 입니다.");
						return;
					} */
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010502");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "search1":
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010503");
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "mod":		//수정 팝업
					var srow = mySheet.GetSelectRow();
					if(srow == -1){
						alert("조회된 데이터가 없습니다.");
						return;
					}
					$('#acc_sbj_cnm').val(mySheet.GetCellValue(srow,"acc_sbj_cnm")); 
					
					if(mySheet.GetCellValue(srow,"acc_sbj_cnm") == ""){
						alert("대상 항목을 선택하세요.");
						return;
					}else{
						$("#ifrORMR0102").attr("src","about:blank");
						$("#winORMR0102").show();
						
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modORMR0102,1);
					}
					break;
				case "mod1":		//수정 팝업
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
						$("#winORMR0102").show();
						
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modORMR0102_search,1);
					}
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					initIBSheet1();
					break;
				case "down2excel":
					setExcelFileName("계정과목 매핑 테이블 조회");
					setExcelDownCols("0|1|2|3|4|5|6|8|9");
					mySheet.Down2Excel(excel_params);
	
					break;
				case "down2excel_2":
					setExcelFileName("영업지수매핑 등록/변경 이력");
					setExcelDownCols("0|1|3|4|5|6|7|8|9|10|11");
					mySheet1.Down2Excel(excel_params);
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
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
				return true;
			}else{
				return true;
			}
		}
		
	</script>
	
</head>
<body onkeyPress="return EnterkeyPass()">
	<!-- iframe 영역 -->
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<div class="content">
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			
			<input type="hidden" id="mode" name="mode" value="" /> <!-- 신규수정 구분(I:신규 U:수정) -->
			<input type="hidden" id="acc_sbj_cnm" name="acc_sbj_cnm" value="" /> <!-- 계정과목코드 -->
			
			<input type="hidden" id="sch_acc_tpc_1" name="sch_acc_tpc_1" value="" />
			<input type="hidden" id="sch_acc_tpc_2" name="sch_acc_tpc_2" value="" />
			<input type="hidden" id="sch_acc_tpc_3" name="sch_acc_tpc_3" value="" />
			<input type="hidden" id="sch_acc_tpc_4" name="sch_acc_tpc_4" value="" />
			<input type="hidden" id="sch_acc_tpc_5" name="sch_acc_tpc_5" value="" />
			
			<!-- 조회 -->
			<div class="box box-search">	
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>BS/PL</th>
									<td>
											<span class="select">
												<select class="form-control" id="st_acc_tpc" name="st_acc_tpc">
													<option value="" selected="selected">전체</option>
<%
		for(int i=0;i<vLst3.size();i++){
			HashMap hMap = (HashMap)vLst3.get(i);
%>													
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
		}
%>													
												</select>
											</span>										
									</td>
									<th>매핑 여부</th>
									<td>
										<span class="select">
											<select class="form-control" id="sch_mapping_yn" name="sch_mapping_yn">
												<option value="A" selected="selected">전체</option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</span>
									</td>
								</tr>
								<tr>
									<th>영업지수 Lv.1</th>
									<td>
										<span class="select">
											<select class="form-control w200" id="sch_lv1_biz_ix_c" name="sch_lv1_biz_ix_c">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</span>
									</td>
									<th>영업지수 Lv.2</th>
									<td>
										<span class="select">
											<select class="form-control w200" id="sch_lv2_biz_ix_c" name="sch_lv2_biz_ix_c">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</span>
									</td>
								</tr>
								<tr>
									<th>계정과목코드</th>
									<td>
										<input type="text" class="form-control" id="sch_acc_sbj_cnm" name="sch_acc_sbj_cnm" placeholder="검색어 입력" onkeypress="EnterkeySubmit();">
									</td>
									<th>계정과목명</th>
									<td>
										<input type="text" class="form-control" id="sch_acc_sbjnm" name="sch_acc_sbjnm" placeholder="검색어 입력" onkeypress="EnterkeySubmit();">
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- .wrap-search -->
				</div><!-- .box-body //-->
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- .box-search //-->
			</form>
			
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">조회결과</h2>
					<div class="area-tool">
						<span>계정과목 매핑 수정이 필요한 경우 테이블 내 계정과목을 더블클릭하거나, 계정과목을 선택하여 [수정]버튼을 클릭해주세요.</span>
						<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction('mod');">
							<i class="fa fa-pencil"></i><span class="txt">수정</span>
						</button>
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h300">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-header">
					<h2 class="box-title">영업지수매핑 등록/변경 이력</h2>
					<div class="area-tool">
					<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel_2');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h250">
						<script> createIBSheet("mySheet1", "100%", "100%"); </script>
					</div>
				</div>
			</section>
		</div><!-- .content //-->
	</div><!-- .container //-->	
	<!-- popup -->
	<div id="winORMR0102" class="popup modal">
		<iframe name="ifrORMR0102" id="ifrORMR0102" src="about:blank"></iframe>
	</div>
</body>
	
</html>