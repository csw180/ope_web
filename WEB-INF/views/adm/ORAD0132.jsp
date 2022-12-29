<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0132.jsp
 Program name : ADMIN > 배치 > 배치작업관리 > 신규등록
 Description  : 
 Programer    : 권성학
 Date created : 2021.07.07
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Vector vBtwkExeFqLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");	//실행주기
	if(vBtwkExeFqLst==null) vBtwkExeFqLst = new Vector();
	Vector vHldyWkExeLst= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");	//휴일실행
	if(vHldyWkExeLst==null) vHldyWkExeLst = new Vector();
	Vector vRzvMrkLst= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");	//보류구분
	if(vRzvMrkLst==null) vRzvMrkLst = new Vector();
	
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../comm/library.jsp" %>
<script language="javascript">
		
	$(document).ready(function(){
		//$("#winRskMod",parent.document).show();
		// ibsheet 초기화
		parent.removeLoadingWs();
		initIBSheet1();
		initIBSheet2();
		
		$("#mft_id").attr("disabled",true);
		$("#surc_fl_pathnm").attr("disabled",true);
		$("#surc_flnm").attr("disabled",true);
		$("#wk_chk_fl_xcrnm").attr("disabled",true);
		$("#trgt_fl_pathnm").attr("disabled",true);
		$("#wk_sfile_xcrnm").attr("disabled",true);
		$("#fl_stb_hr").attr("disabled",true);
		$("#mft_id").val("");
		$("#surc_fl_pathnm").val("");
		$("#surc_flnm").val("");
		$("#wk_chk_fl_xcrnm").val("");
		$("#trgt_fl_pathnm").val("");
		$("#wk_sfile_xcrnm").val("");
		$("#fl_stb_hr").val("");
		
	});
	
	/***************************************************************************************/
	/* 선행배치(mySheet1) 처리                                                                                                                                       */
	/***************************************************************************************/
	/*Sheet 기본 설정 */
	function initIBSheet1() {
		//시트 초기화
		mySheet1.Reset();
		
		var initData1 = {};
		
		initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
		initData1.Cols = [
   			{Header:"상태",			Type:"Status",		SaveName:"status",				Hidden:true							},
   			{Header:"선택",			Type:"CheckBox",	SaveName:"sel_check",			Width:60,	Align:"Center",	Edit:1	},
   			{Header:"순번",			Type:"Seq",			SaveName:"seq",					Width:60,	Align:"Center",	Edit:0	},
   			{Header:"계열사코드",		Type:"Text",		SaveName:"grp_org_c",			Hidden:true							},
   			{Header:"계열사명",		Type:"Text",		SaveName:"grp_orgnm",			Width:150,	Align:"Center",	Edit:0	},
   		    {Header:"배치작업ID",		Type:"Text",		SaveName:"btwk_id",				Width:120,	Align:"Center",	Edit:0	},
   		    {Header:"배치작업명",		Type:"Text",		SaveName:"btwknm",				Width:250,	Align:"Left",	Edit:0	},
   		    {Header:"실행주기",		Type:"Text",		SaveName:"btwk_exe_fq_dsnm",	Width:100,	Align:"Center",	Edit:0	},
   		    {Header:"실행주기코드",		Type:"Text",		SaveName:"btwk_exe_fq_dsc",		Hidden:true							}
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
	}

	/***************************************************************************************/
	/* 동시작업불가배치(mySheet2) 처리                                                                                                                                       */
	/***************************************************************************************/
	/*Sheet 기본 설정 */
	function initIBSheet2() {
		//시트 초기화		
		mySheet2.Reset();
		
		var initData2 = {};
		
		initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
		initData2.Cols = [
			{Header:"상태",			Type:"Status",		SaveName:"status",				Hidden:true							},
			{Header:"선택",			Type:"CheckBox",	SaveName:"sel_check",			Width:60,	Align:"Center",	Edit:1	},
			{Header:"순번",			Type:"Seq",			SaveName:"seq",					Width:60,	Align:"Center",	Edit:0	},
		    {Header:"배치작업ID",		Type:"Text",		SaveName:"btwk_id",				Width:120,	Align:"Center",	Edit:0	},
		    {Header:"배치작업명",		Type:"Text",		SaveName:"btwknm",				Width:250,	Align:"Left",	Edit:0	},
		    {Header:"실행주기",		Type:"Text",		SaveName:"btwk_exe_fq_dsnm",	Width:100,	Align:"Center",	Edit:0	},
   		    {Header:"실행주기코드",		Type:"Text",		SaveName:"btwk_exe_fq_dsc",		Hidden:true							}
		];
		
		IBS_InitSheet(mySheet2,initData2);
		
		//필터표시
		//mySheet2.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		mySheet2.SetCountPosition(3);
		
		//컬럼의 너비 조정
		mySheet2.FitColWidth();
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet2.SetSelectionMode(4);
		
		//최초 조회시 포커스를 감춘다.
		mySheet2.SetFocusAfterProcess(0);
		
		mySheet2.SetAutoRowHeight(1);
		
		//헤더기능 해제
		//mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});

		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet2);
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
		}else{
			if(mySheet1.GetDataFirstRow()>=0){
			}
		}
		
		//컬럼의 너비 조정
		mySheet1.FitColWidth();
	}
	
	function mySheet2_OnRowSearchEnd(row) {
	}
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {
		switch(sAction) {
			case "insert":		//신규등록 팝업
				//추가처리;
				var row = mySheet1.DataInsert();
				mySheet1_OnChange(row,0,"");

				break; 
			case "add1":		//신규등록 팝업
				if($("#btwk_exe_fq_dsc").val() == ""){
					alert("실행주기를 선택해 주십시오.");
					$("#btwk_exe_fq_dsc").focus();
					return;
				}
			
				$("#ifrBtwkSel").attr("src","about:blank");
				$("#winBtwkSel").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popBtwkSel('1'),10);
				
				break; 
			case "add2":		//신규등록 팝업
			
				if(mySheet2.RowCount() >= 10){
					alert("동시작업불가배치작업은 10개까지만 등록 가능합니다.");
					return;
				}
			
				if($("#grp_org_c").val() == ""){
					alert("계열사를 선택해 주십시오.");
					$("#grp_org_c").focus();
					return;
				}
			
				if($("#btwk_exe_fq_dsc").val() == ""){
					alert("실행주기를 선택해 주십시오.");
					$("#btwk_exe_fq_dsc").focus();
					return;
				}
				
				$("#ifrBtwkSel").attr("src","about:blank");
				$("#winBtwkSel").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popBtwkSel('2'),10);
				
				break;
			case "del1":

				if(mySheet1.CheckedRows("sel_check") < 1){
					alert("삭제할 항목을 선택해 주세요.");
					return;
				}
				
				var sRow = mySheet1.FindCheckedRow("sel_check");
				
				mySheet1.RowDelete(sRow);
				mySheet1.SetSelectRow(-1);
				mySheet1.ReNumberSeq();
				
				break;
			case "del2":
				
				if(mySheet2.CheckedRows("sel_check") < 1){
					alert("삭제할 항목을 선택해 주세요.");
					return;
				}
				
				var sRow = mySheet2.FindCheckedRow("sel_check");
				
				mySheet2.RowDelete(sRow);
				mySheet2.SetSelectRow(-1);
				mySheet2.ReNumberSeq();
				
				break;
		}
	}
	
	function popBtwkSel(sheet){
		var f = document.ormsForm;
        f.path.value="/adm/ORAD0137";
        f.sheet.value = sheet;
        f.parent_grp_org_c.value = f.grp_org_c.value;
        f.parent_exe_fq.value = f.btwk_exe_fq_dsc.value;
        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrBtwkSel";
		f.submit();
	}

	function save(){
		var f = document.ormsForm;
		var grid_html = "";

		if(f.grp_org_c.value == ""){
			alert("계열사를 선택해 주십시오.");
			f.grp_org_c.focus();
			return;
		}
		
		if(f.btwk_id.value == ""){
			alert("배치작업ID를 입력해 주십시오.");
			f.btwk_id.focus();
			return;
		}

		if(f.btwknm.value == ""){
			alert("배치작업명을 입력해 주십시오.");
			f.btwknm.focus();
			return;
		}
		
		if(f.btwk_exe_fq_dsc.value == ""){
			alert("실행주기를 선택해 주십시오.");
			f.btwk_exe_fq_dsc.focus();
			return;
		}
		
		if(f.hldy_wk_exe_dsc.value == ""){
			alert("휴일실행구분을 선택하십시오.");
			f.hldy_wk_exe_dsc.focus();
			return;
		}
		
		if(f.mft_yn.value == ""){
			alert("MFT여부를 선택하십시오.");
			f.mft_yn.focus();
			return;
		}
		
		if(f.mft_yn.value == "Y"){
			if(f.mft_id.value == ""){
				alert("MFT ID를 입력하십시오.");
				f.mft_id.focus();
				return;
			}
			
			if(f.bat_exe_pathnm.value == ""){
				alert("배치실행경로를 입력하십시오.");
				f.bat_exe_pathnm.focus();
				return;
			}
			
			/*
			if(f.surc_fl_pathnm.value == ""){
				alert("MFT파일경로를 입력하십시오.");
				f.surc_fl_pathnm.focus();
				return;
			}
			*/
			
			if(f.surc_flnm.value == ""){
				alert("MFT파일명을 입력하십시오.");
				f.surc_flnm.focus();
				return;
			}
			
			if(f.wk_chk_fl_xcrnm.value == ""){
				alert("체크파일 확장자명을 입력하십시오.");
				f.wk_chk_fl_xcrnm.focus();
				return;
			}
			
			if(f.trgt_fl_pathnm.value == ""){
				alert("SAM파일경로명을 입력하십시오.");
				f.trgt_fl_pathnm.focus();
				return;
			}
			
			if(f.wk_sfile_xcrnm.value == ""){
				alert("SAM파일 확장자명을 입력하십시오.");
				f.wk_sfile_xcrnm.focus();
				return;
			}
			
			if(isNaN(f.fl_stb_hr.value)){
				alert("파일대기시간을 숫자로 입력하십시오.");
				f.fl_stb_hr.focus();
				return;
			}
		}
		
		if(f.rzv_dd.value != ""){
			if(f.rzv_mrk_c.value == ""){
				alert("보류조건을 선택해 주십시오.");
				f.rzv_mrk_c.focus();
				return;
			}
			
			if(f.rzv_dd.value > 31 || f.rzv_dd_value < 1){
				alert("보류일은 1~31 사이로 입력해 주시기 바랍니다.");
				f.rzv_dd.focus();
				return;
			}
		}
		
		if(mySheet1.GetDataFirstRow()>=0){
			for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
				grid_html += "<input type='hidden' name='prd_grp_org_c' value='" + mySheet1.GetCellValue(j,"grp_org_c") + "'>";
				grid_html += "<input type='hidden' name='prd_btwk_id' value='" + mySheet1.GetCellValue(j,"btwk_id") + "'>";
			}
		}
		if(mySheet2.GetDataFirstRow()>=0){
			for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
				grid_html += "<input type='hidden' name='imp_btwk_id"+mySheet2.GetCellValue(j,"seq")+"' value='" + mySheet2.GetCellValue(j,"btwk_id") + "'>";
			}
		}
		
		grid_area.innerHTML = grid_html;
		
		if(!confirm("저장하시겠습니까?")) return;

		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "adm");
		WP.setParameter("process_id", "ORAD013202");
		WP.setForm(f);
		
		var inputData = WP.getParams();
		
		//alert(inputData);
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function(result){
					if(result!='undefined' && result.rtnCode=="S") {
						alert("저장되었습니다.");
						parent.doAction('search');
						closePop();
					}else if(result!='undefined'){
						alert(result.rtnMsg);
					}else if(result!='undefined'){
						alert("처리할 수 없습니다.");
					}  
				},
			  
				complete: function(statusText,status){
					removeLoadingWs();
				},
			  
				error: function(rtnMsg){
					removeLoadingWs();
					alert(JSON.stringify(rtnMsg));
				}
		});
	}
	
	function openMft(){
		if($("#mft_yn").val() == "Y"){
			$("#mft_id").attr("disabled",false);
			$("#surc_fl_pathnm").attr("disabled",false);
			$("#surc_flnm").attr("disabled",false);
			$("#wk_chk_fl_xcrnm").attr("disabled",false);
			$("#trgt_fl_pathnm").attr("disabled",false);
			$("#wk_sfile_xcrnm").attr("disabled",false);
			$("#fl_stb_hr").attr("disabled",false);	
		}else{
			$("#mft_id").attr("disabled",true);
			$("#surc_fl_pathnm").attr("disabled",true);
			$("#surc_flnm").attr("disabled",true);
			$("#wk_chk_fl_xcrnm").attr("disabled",true);
			$("#trgt_fl_pathnm").attr("disabled",true);
			$("#wk_sfile_xcrnm").attr("disabled",true);
			$("#fl_stb_hr").attr("disabled",true);
			$("#mft_id").val("");
			$("#surc_fl_pathnm").val("");
			$("#surc_flnm").val("");
			$("#wk_chk_fl_xcrnm").val("");
			$("#trgt_fl_pathnm").val("");
			$("#wk_sfile_xcrnm").val("");
			$("#fl_stb_hr").val("");
		}
		
	}
	
	function closeBtwkSel(){
		$("#winBtwkSel").hide();
		$("#ifrBtwkSel").attr("src","about:blank");
	}
	
	function addPrdBtwk1(grp_org_c, grp_orgnm, btwk_id, btwknm, btwk_exe_fq_dsnm, btwk_exe_fq_dsc){
		var bAddFlag = true;
		
		for(var nCnt=mySheet1.GetDataFirstRow(); nCnt <= mySheet1.GetDataLastRow(); nCnt++){
			if( (mySheet1.GetCellValue(nCnt,"grp_org_c") == grp_org_c) && (mySheet1.GetCellValue(nCnt,"btwk_id") == btwk_id) ){
				bAddFlag = false;
				break;
			}
		}

		if( bAddFlag ){
			// 맨 마직막에 추가
			var row = mySheet1.DataInsert(999);

			mySheet1.SetCellValue(row, "grp_org_c", grp_org_c);
			mySheet1.SetCellValue(row, "grp_orgnm", grp_orgnm);
			mySheet1.SetCellValue(row, "btwk_id", btwk_id);
			mySheet1.SetCellValue(row, "btwknm", btwknm);
			mySheet1.SetCellValue(row, "btwk_exe_fq_dsnm", btwk_exe_fq_dsnm);
			mySheet1.SetCellValue(row, "btwk_exe_fq_dsc", btwk_exe_fq_dsc);
		}
		
		mySheet1.SetSelectRow(-1);
	}
	
	function addPrdBtwk2(btwk_id, btwknm, btwk_exe_fq_dsnm, btwk_exe_fq_dsc){
		
		if(mySheet2.RowCount() > 10){
			alert("동시작업불가배치작업은 10개까지만 등록 가능합니다.");
			return;
		}
		
		var bAddFlag = true;
		
		for(var nCnt=mySheet2.GetDataFirstRow(); nCnt <= mySheet2.GetDataLastRow(); nCnt++){
			if( mySheet2.GetCellValue(nCnt,"btwk_id") == btwk_id ){
				bAddFlag = false;
				break;
			}
		}

		if( bAddFlag ){
			// 맨 마직막에 추가
			var row = mySheet2.DataInsert(999);

			mySheet2.SetCellValue(row, "btwk_id", btwk_id);
			mySheet2.SetCellValue(row, "btwknm", btwknm);
			mySheet2.SetCellValue(row, "btwk_exe_fq_dsnm", btwk_exe_fq_dsnm);
			mySheet2.SetCellValue(row, "btwk_exe_fq_dsc", btwk_exe_fq_dsc);
		}
		
		mySheet2.SetSelectRow(-1);
	}
	
	function removeImpBtwk(){
		if(mySheet2.RowCount() > 0){
			alert("동시작업 불가 배치 목록을 삭제합니다.");
			mySheet2.RemoveAll();
		}
	}
	
</script>
</head>
<body style="background-color:transparent">
	<div id="" class="popup modal block">
		<div class="p_frame w1100">
			<form name="ormsForm" method="post">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="mode" name="mode" value="I" />
			<input type="hidden" id="sheet" name="sheet" />
			<input type="hidden" id="parent_grp_org_c" name="parent_grp_org_c" />
			<input type="hidden" id="parent_exe_fq" name="parent_exe_fq" />
			<div id="grid_area"></div>
			<div class="p_head">
				<h3 class="title">배치작업 신규등록</h3>
			</div>
			<div class="p_body">
				
				<div class="p_wrap">

					<div class="box box-grid">						
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 120px;">
									<col>
									<col style="width: 120px;">
									<col>
									<col style="width: 120px;">
									<col>
									<col style="width: 125px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th>계열사</th>
										<td>
											<div class="select">
												<select name="grp_org_c" id="grp_org_c" class="form-control" onchange="removeImpBtwk();">
													<option value="">선택</option>
<%
		for(int i=0;i<vAllGrpList.size();i++){
			HashMap hMap3 = (HashMap)vAllGrpList.get(i);
%>
												<option value="<%=(String)hMap3.get("grp_org_c")%>"><%=(String)hMap3.get("grp_orgnm")%></option>
<%
		}
%>
												</select>
											</div>
										</td>
										<th>배치작업ID</th>
										<td>
											<input type="text" name="btwk_id" id="btwk_id" class="form-control" maxlength="19">
										</td>
										<th>배치작업명</th>
										<td colspan="3">
											<input type="text" name="btwknm" id="btwknm" class="form-control" maxlength="50">
										</td>
									</tr>
									<tr>
										<th>실행주기</th>
										<td>
											<div class="select">
												<select name="btwk_exe_fq_dsc" id="btwk_exe_fq_dsc" class="form-control" onchange="removeImpBtwk();">
													<option value="">선택</option>
<%
		for(int i=0;i<vBtwkExeFqLst.size();i++){
			HashMap hMap1 = (HashMap)vBtwkExeFqLst.get(i);
%>
												<option value="<%=(String)hMap1.get("intgc")%>"><%=(String)hMap1.get("intg_cnm")%></option>
<%
		}
%>	
												</select>
											</div>
										</td>
										<th>휴일실행구분</th>
										<td>
											<div class="select">
												<select name="hldy_wk_exe_dsc" id="hldy_wk_exe_dsc" class="form-control">
													<option value="">선택</option>
<%
		for(int i=0;i<vHldyWkExeLst.size();i++){
			HashMap hMap3 = (HashMap)vHldyWkExeLst.get(i);
%>
												<option value="<%=(String)hMap3.get("intgc")%>"><%=(String)hMap3.get("intg_cnm")%></option>
<%
		}
%>
												</select>
											</div>
										</td>
										<th>MFT여부</th>
										<td>
											<div class="select">
												<select name="mft_yn" id="mft_yn" class="form-control" onchange="openMft();">
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
											</div>
										</td>
										<th>MFT ID</th>
										<td>
											<input type="text" name="mft_id" id="mft_id" class="form-control" maxlength="20">
										</td>
									</tr>
									<tr>
										<th>기준일구분</th>
										<td>
											<div class="select">
												<select name="btwk_basdt_dsc" id="btwk_basdt_dsc" class="form-control" >
													<option value="9">없음</option>
													<option value="1">YYYYMMDD</option>
													<option value="2">YYYYMM</option>
													<option value="3">YYMMDD</option>
													<option value="4">YYMM</option>
												</select>
											</div>
										</td>
										<th>파일입수방식</th>
										<td>
											<div class="select">
												<select name="tms_fl_path_dsc" id="tms_fl_path_dsc" class="form-control" >
													<option value="">사용안함</option>
													<option value="1">MFT</option>
													<option value="2">SAM</option>
												</select>
											</div>
										</td>
										<td colspan="4">
										</td>
									</tr>
									<tr>
										<th>배치실행경로</th>
										<td colspan="7">
											<input type="text" name="bat_exe_pathnm" id="bat_exe_pathnm" class="form-control" maxlength="100">
										</td>
									</tr>
									<tr>
										<th>MFT파일경로</th>
										<td colspan="7">
											<input type="text" name="surc_fl_pathnm" id="surc_fl_pathnm" class="form-control" maxlength="100">
										</td>
									</tr>
									<tr>
										<th>MFT파일명</th>
										<td colspan="5">
											<input type="text" name="surc_flnm" id="surc_flnm" class="form-control" maxlength="100">
										</td>
										<th>체크파일 확장자명</th>
										<td>
											<input type="text" name="wk_chk_fl_xcrnm" id="wk_chk_fl_xcrnm" class="form-control" maxlength="3">
										</td>
									</tr>
									<tr>
										<th>SAM파일경로</th>
										<td colspan="5">
											<input type="text" name="trgt_fl_pathnm" id="trgt_fl_pathnm" class="form-control" maxlength="100">
										</td>
										<th>SAM파일 확장자명</th>
										<td>
											<input type="text" name="wk_sfile_xcrnm" id="wk_sfile_xcrnm" class="form-control" maxlength="3">
										</td>
									</tr>
									<tr>
										<th>파일대기시간(초)</th>
										<td>
											<input type="text" name="fl_stb_hr" id="fl_stb_hr" class="form-control w100 right" maxlength="10" onkeypress="inNumber()">
										</td>
										<th>보류일(DD)</th>
										<td>
											<input type="text" name="rzv_dd" id="rzv_dd" class="form-control right" maxlength="2" onkeypress="inNumber()">
										</td>
										<th>보류조건</th>
										<td colspan="3">
											<div class="select w100">
												<select name="rzv_mrk_c" id="rzv_mrk_c" class="form-control">
													<option value="">선택</option>
<%
		for(int i=0;i<vRzvMrkLst.size();i++){
			HashMap hMap2 = (HashMap)vRzvMrkLst.get(i);
%>
													<option value="<%=(String)hMap2.get("intgc")%>"><%=(String)hMap2.get("intg_cnm")%></option>
<%
		}
%>	
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>전월휴일보류여부</th>
										<td colspan="3">
											<div class="select">
												<select name="bmm_hldy_rzv_yn" id="bmm_hldy_rzv_yn" class="form-control w100">
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
												</select>
											</div>
										</td>
										<th>실행제외여부</th>
										<td colspan="3">
											<div class="select">
												<select name="exe_x_yn" id="exe_x_yn" class="form-control w100">
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
												</select>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div class="box box-grid mt20">
						<div class="box-header">
							<h4 class="title md">선행배치작업</h4>
							<div class="area-tool">
								<div class="btn-group">										
									<button type="button" class="btn btn-xs btn-default" onclick="doAction('add1')"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
									<button type="button" class="btn btn-xs btn-default" onclick="doAction('del1')"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
								</div>
							</div>
						</div>
						<div class="box-body">
							<div class="wrap-grid h250">
								<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
							</div>
						</div>
					</div>

					<div class="box box-grid mt20">
						<div class="box-header">
							<h4 class="title md">동시작업불가배치작업</h4>
							<div class="area-tool">
								<div class="btn-group">										
									<button type="button" class="btn btn-xs btn-default" onclick="doAction('add2')"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
									<button type="button" class="btn btn-xs btn-default" onclick="doAction('del2')"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
								</div>
							</div>
						</div>
						<div class="box-body">
							<div class="wrap-grid h250">
								<script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script>
							</div>
						</div>
					</div>

				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap center">
					<button type="button" class="btn btn-primary" onclick="save();">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>

			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
			</form>
		</div>
		<div class="dim p_close"></div>
	</div>
	<div id="winBtwkSel" class="popup modal" style="background-color:transparent">
		<iframe name="ifrBtwkSel" id="ifrBtwkSel" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
	</div>
	<iframe name="ifrDummy" id="ifrDummy" src="about:blank" width="0" height="0" style="visibility:hidden;display:none"></iframe>
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				parent.$("#ifrBtwkSchdAdd").attr("src","about:blank");
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winBtwkSchdAdd",parent.document).hide();
			parent.$("#ifrBtwkSchdAdd").attr("src","about:blank");
		}
	</script>
</body>
</html>