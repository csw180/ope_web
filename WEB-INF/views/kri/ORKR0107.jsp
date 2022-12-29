<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0105.jsp
 Program name : KRI평가관리
 Description  : 화면정의서 KRI-02
 Programer    : 정현식
 Date created : 2022.04.26
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>

<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ include file="../comm/comUtil.jsp" %>
<%
	SysDateDao dao = new SysDateDao(request);
	String sysdate = dao.getSysdate();
	//System.out.println("sysdate:"+sysdate);
	int iyear = Integer.parseInt(sysdate.substring(0,4));
	int imonth = Integer.parseInt(sysdate.substring(4,6));
	while(true){
		imonth --;
		if(imonth==0){
			iyear--;
			imonth=12;
		}
		if(imonth==3 || imonth==6 || imonth==9 || imonth==12){
			break;
		}
	}
	String st_bas_ym = ""+(iyear-1)+"-";
	String ed_bas_ym = ""+(iyear)+"-";
	if(imonth>9){
		st_bas_ym += imonth;
		ed_bas_ym += imonth;
	}else{
		st_bas_ym += ("0" + imonth);
		ed_bas_ym += ("0" + imonth);
	}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>KRI 평가관리</title>
	<script>
	/* 전역변수 */
	var addOrMod = "";
	
	$(document).ready(function(){		
		// ibsheet 초기화
		initIBSheet1();
		createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
	    
		/* doAction('search'); */
	});
	
	$(document).ready(function(){
		initIBSheet2();
	});
	
	
	/*Sheet 기본 설정 */
	function initIBSheet1() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData.Cols = [
			{Header:"상태"		,Type:"Status"	,Width:50	,Align:"Center"	,SaveName:"status"			,MinWidth:40,Edit:false ,HAlign:"Center",Hidden:true},
			{Header:"평가년월"		,Type:"Text"	,Width:100	,Align:"Center"	,SaveName:"bas_ym"			,MinWidth:60,Edit:false},
			{Header:"KRI평가상태"	,Type:"Text"	,Width:80	,Align:"Center"	,SaveName:"rki_prg_stsc_nm"	,MinWidth:60,Edit:false},
			{Header:"KRI평가대상건수",Type:"Text"		,Width:120	,Align:"Center"	,SaveName:"rkislt_cnt"		,MinWidth:60,Edit:false}, 
			{Header:"KRI평가시작일"	,Type:"Date"	,Width:100	,Align:"Center"	,SaveName:"mntr_st_dt"		,MinWidth:60,Edit:false},
			{Header:"KRI평가완료일"	,Type:"Date"	,Width:100	,Align:"Center"	,SaveName:"mntr_ed_dt"		,MinWidth:60,Edit:false},
			{Header:"KRI평가일정명"	,Type:"Text"	,Width:250	,Align:"Left"	,SaveName:"rki_schd_nm"		,MinWidth:60,Edit:false,Hidden:true},
// 			{Header:"평가완료",		Type:"Html",	MinWidth:80,		Align:"Center",		SaveName:"rki_evl_end",		Edit:0},
			{Header:"리스크지표진행상태코드",Type:"Text"	,Width:50	,Align:"Center"	,SaveName:"rki_prg_stsc"	,MinWidth:60,Edit:false,Hidden:true}
		];
		
		IBS_InitSheet(mySheet,initData);
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		mySheet.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		//mySheet2.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet2);
		
		//컬럼의 너비 조정
		mySheet.FitColWidth();
		
		doAction('search'); //자동 조회시 재무제표 영업지수 최근데이터 년월 set 한뒤 해야함 line.84 주석 제거
		
	}
	
	function initIBSheet2() {
		//시트 초기화
		mySheet2.Reset();
		
		var initData2 = {};
		
		initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData2.Cols = [
			{Header:"상태"		,Type:"Status"	,Width:0	,Align:"Center"	,SaveName:"status"		,MinWidth:0,Edit:false,Hidden:true,HAlign:"Center"},
			{Header:"평가년월"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"bas_ym"		,MinWidth:60,Edit:false,Hidden:true},
			{Header:"지표소관부서	"	,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"brnm"			,MinWidth:60,Edit:false},
			{Header:"KRI-ID"	,Type:"Text"	,Width:30	,Align:"Center"	,SaveName:"rki_id"		,MinWidth:60,Edit:false},
			{Header:"지표명"		,Type:"Text"	,Width:120	,Align:"Left"	,SaveName:"rkinm"		,MinWidth:60,Edit:false,Wrap:1},
			{Header:"지표목적"		,Type:"Text"	,Width:200	,Align:"Left"	,SaveName:"rki_obv_cntn",MinWidth:60,Edit:false,Wrap:1},
			{Header:"지표정의"		,Type:"Text"	,Width:200	,Align:"Left"	,SaveName:"rki_def_cntn",MinWidth:60,Edit:false,Wrap:1},
			{Header:"지표산식"		,Type:"Text"	,Width:200	,Align:"Left"	,SaveName:"idx_fml_cntn",MinWidth:60,Edit:false,Wrap:1,Hidden:true},
			{Header:"단위"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"kri_unt_nm"	,MinWidth:40,Edit:false},
			{Header:"수집주기"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"col_fq_nm"	,MinWidth:40,Edit:false},
			{Header:"전산수집\n여부"	,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"com_col_psb_yn",MinWidth:60,Edit:false},
			{Header:"수기 데이터\n입력 현황",Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"com_col_psb_input_yn",MinWidth:60,Edit:false},
			{Header:"평가 대상\n여부"	,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:""			,MinWidth:60,Edit:false},
 			{Header:"지표수준"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"rki_lvl_nm"	,MinWidth:40,Edit:false},
			{Header:"한도설정방식"	,Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"kri_lmt_nm"	,MinWidth:60,Edit:false},
// 			{Header:"KRI속성",Type:"Text",Width:60,Align:"Center",SaveName:"rki_attr_nm",MinWidth:60,Edit:false},
// 			{Header:"상세보기",Type:"Html",Width:30,Align:"Center",SaveName:"goORKR0201",MinWidth:60}
		];
		
		IBS_InitSheet(mySheet2,initData2);
		
		//필터표시
		//mySheet2.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단 )
		mySheet2.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		//mySheet.SetSelectionMode(4);
		mySheet2.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet2);
		
		//컬럼의 너비 조정
		mySheet2.FitColWidth();
		
		//doAction('search'); //자동 조회시 재무제표 영업지수 최근데이터 년월 set 한뒤 해야함 line.84 주석 제거
		
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
				//var opt = { CallBack : DoSearchEnd };
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR010702");
				
				$("form[name=ormsForm] [name=sch_st_bas_ym]").val(($("form[name=ormsForm] [name=st_bas_ym]").val()).replace("-",""));
				$("form[name=ormsForm] [name=sch_ed_bas_ym]").val(($("form[name=ormsForm] [name=ed_bas_ym]").val()).replace("-",""));
			
				if($("#sch_st_bas_ym").val() > $("#sch_ed_bas_ym").val()) {
					alert("조회 시작년월이 종료년월보다 이후 입니다. 확인바랍니다.");
					return;
				}
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
				
			case "pop_add":      // 일정등록 클릭시 일정추가 팝업창 호출
				//신규등록 팝업
				$("#ifrAddSchedule").attr("src","about:blank");
				$("#winAddSchedule").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(addSchedule,1);
				
				break;
				
			case "pop_mod":
				
				var srow = mySheet.GetSelectRow();
				
				if(srow < 0) {
					alert("평가일정을 선택해 주십시오.");
					return;
				}
				
				modSchedule(srow);
				
				break;
				
			case "ORKR010201":      //신규
				$("#ifrORKR0201").attr("src","about:blank");
				$("#winORKR0201").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popORKR0201,1);
				
				break; 
		}
	}
	
	function addSchedule(){ // 일정등록 처리
		addOrMod = "add";
		addOrModSchedule(addOrMod);
	}
	
	function popORKR0201(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORKR010201";
		f.target = "ifrORKR0201";
		f.submit();
	}
	
	function modSchedule(row){
		$("#ifrAddSchedule").attr("src","about:blank");
		$("#winAddSchedule").show();
		showLoadingWs(); // 프로그래스바 활성화
		
		addOrMod = "mod";
		
		if(row >= mySheet.GetDataFirstRow()){
			$("#p_bas_ym").val(mySheet.GetCellValue(row,"bas_ym"));
			$("#p_mntr_st_dt").val(mySheet.GetCellValue(row,"mntr_st_dt"));
			$("#p_mntr_ed_dt").val(mySheet.GetCellValue(row,"mntr_ed_dt"));
			$("#p_rki_schd_nm").val(mySheet.GetCellValue(row,"rki_schd_nm"));
			$("#hd_rki_prg_stsc").val(mySheet.GetCellValue(row,"rki_prg_stsc"));
		}
		
		addOrModSchedule(addOrMod);
	}
	
	function mySheet_OnSearchEnd(code, message) {
		if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			mySheet_OnClick(1); //첫행 클릭
		}
		
		if(mySheet.GetDataFirstRow()>0){
	    	for(var i=1; i<=mySheet.GetDataLastRow(); i++){
	    		if (mySheet.GetCellValue(i, "rki_prg_stsc") == "02") {
    				//mySheet.SetCellValue(i, "rki_evl_end", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:complete('+i+');">완료</button>');
	    	    }
	    	}
	    }
		
		//컬럼의 너비 조정
		mySheet.FitColWidth();
	}
	
	function mySheet_OnRowSearchEnd(row) {
	} 
	
	function mySheet2_OnSearchEnd(code, message) {
		if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}
		
		//컬럼의 너비 조정
		mySheet2.FitColWidth();
	}
	
	function mySheet2_OnRowSearchEnd(Row) {
// 		mySheet2.SetCellText(Row,"goORKR0201",'<button class="btn btn-xs btn-default" type="button" onclick="goORKR0201(\''+mySheet2.GetCellValue(Row,"rki_id")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
		mySheet2.SetCellValue(Row,"status","R");
	}
	
	function goORKR0201(rki_id) {
		$("#rki_id").val(rki_id);
		doAction('ORKR010201');
	}
	
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if(Row >= mySheet.GetDataFirstRow()){
			
			//if(mySheet.ColSaveName(Col) == "rki_evl_end") return;
				
			var opt = {};
			$("#hd_rki_prg_stsc").val(mySheet.GetCellValue(Row, "rki_prg_stsc"));
			$("#bas_ym").val(mySheet.GetCellValue(Row,"bas_ym")); //기준년월
			// 평가가 완료되면 풀월말정보를 조회한다.
			if(mySheet.GetCellValue(Row,"rki_prg_stsc") == "03"){
				$('#gubun').val("2"); //KRI_RI풀월말
			}else{
				$('#gubun').val("1"); //RI풀기본
			}
			
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("kri");
			$("form[name=ormsForm] [name=process_id]").val("ORKR010703");
			
			mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		}
	}
	
	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		
		//if(mySheet.ColSaveName(Col) == "rki_evl_end") return;
		
		modSchedule(Row);
			
	}
	
	function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row >= mySheet2.GetDataFirstRow()){
			$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
			$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
			doAction('ORKR010201');
		}
	}
	
	function addOrModSchedule(addOrMod){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri"; //kri
        f.addOrMod.value = addOrMod;
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORKR010706"; // ORKR010506
		f.target = "ifrAddSchedule";
		f.submit();
	}
	
	</script>
</head>
<body class="">
	<!-- iframe 영역 -->
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" 			name="path" />
				<input type="hidden" id="process_id" 	name="process_id" />
				<input type="hidden" id="commkind" 		name="commkind" />
				<input type="hidden" id="method" 		name="method" />
				<input type="hidden" id="bas_ym" 		name="bas_ym" /> 	<!-- 평가년월 --> 
				<input type="hidden" id="gubun" 		name="gubun" /> 	<!-- 조회구분(1:RI풀기본 2:KRI_RI풀월말) -->
				<input type="hidden" id="rki_id" 		name="rki_id" /> 	<!-- 리스크지표ID -->
				<input type="hidden" id="hd_rki_prg_stsc" name="hd_rki_prg_stsc" >
				<input type="hidden" id="mod_yn" 		name="mod_yn" 		value="N" >
				<input type="hidden" id="addOrMod" 		name="addOrMod" 	value="" >
				<input type="hidden" id="p_bas_ym" 		name="p_bas_ym" 	value="" >
				<input type="hidden" id="p_mntr_st_dt" 	name="p_mntr_st_dt" value="" >
				<input type="hidden" id="p_mntr_ed_dt" 	name="p_mntr_ed_dt" value="" >
				<input type="hidden" id="p_rki_schd_nm" name="p_rki_schd_nm"value="" >
				<input type="hidden" id="sch_st_bas_ym" name="sch_st_bas_ym" />
				<input type="hidden" id="sch_ed_bas_ym" name="sch_ed_bas_ym" />		
				
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>기간설정</th>
									<td class="form-inline">
										<div class="input-group">
											<input class="form-control w80" id="st_bas_ym" name="st_bas_ym" type="text" value="<%=st_bas_ym%>">
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM','st_bas_ym');">
													<i class="fa fa-calendar"></i><span class="blind">날짜 입력</span>
												</button>
											</span>
										</div>
										<span class="txt">~</span>
										<div class="input-group">
											<input class="form-control w80" id="ed_bas_ym" name="ed_bas_ym" type="text" value="<%=ed_bas_ym%>">
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM','ed_bas_ym');">
													<i class="fa fa-calendar"></i><span class="blind">날짜 입력</span>
												</button>
											</span>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
				</div>
			</div>
			<!-- //조회 -->
									
			<%--<div class="box">
			
				<div class="box-header">
					<h3 class="box-title">KRI 평가 일정 관리</h3>
				</div>

				 <div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>기간설정</th>
										<td class="form-inline">
											<span class="select">
												<select class="form-control w120" id="sch_bas_ym" name="sch_bas_ym" >
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
											   		<option value="<%=(String)hMap.get("bas_ym")%>"><%=((String)hMap.get("bas_ym")).substring(0,4)%>-<%=((String)hMap.get("bas_ym")).substring(4,6)%></option>
<%
	}
%>	
												</select>
											</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
					</div>
				</div>
			</div> --%>
			<section class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<!-- button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('pop_add');"><i class="fa fa-pencil"></i><span class="txt">일정등록</span></button-->
						<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('pop_mod');"><i class="fa fa-pencil"></i><span class="txt">일정변경</span></button>
					</div>
				</div>				
				<div class="wrap-grid h200">
					<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">KRI 평가 대상 목록 조회</h2>
					<!--  
					<div class="area-tool">
						<button class="btn btn-default btn-xs" type="button" onclick="javascript:doAction('save2');" id="savebtn"><i class="fa fa-save"></i><span class="txt">저장</span></button>
					</div>
					-->
				</div><!-- .box-header //-->
				<div id="mydiv2" class="wrap-grid h320">
					<!-- <script> createIBSheet("mySheet2", "100%", "100%"); </script> -->
				</div>
			</section>
		</form>	
		</div>
	</div>
	<!-- popup -->
	<div id="winORKR0201" class="popup modal">
		<iframe name="ifrORKR0201" id="ifrORKR0201" src="about:blank"></iframe>
	</div>
	<div id="winAddSchedule" class="popup modal">
		<iframe name="ifrAddSchedule" id="ifrAddSchedule" src="about:blank"></iframe>
	</div>
</body>
	
</html>