<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0126.jsp
 Program name : ADMIN > 코드관리 > 부서코드관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.12
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
	Vector vLst2 = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
// 			initData.Cfg = {MergeSheet:msHeaderOnly,DeferredVScroll:1 }; //좌측에 고정 컬럼의 수
			//initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1};
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
				{Header:"상태",				Type:"Status",		SaveName:"status",				Hidden:1},
				{Header:"삭제",				Type:"DelCheck",	SaveName:"del_check",			Hidden:1},
 				{Header:"부서명",				Type:"Text",		SaveName:"brnm",				Align:"Left",	Width:200,	TreeCol:1, Sort:0},
 				{Header:"부서코드",			Type:"Text",		SaveName:"brc", 				Align:"Center",	Width:100,	Hidden:1},
 				{Header:"레벨",				Type:"Text",		SaveName:"level",				Align:"Center",	Width:60,	Hidden:1},
 				{Header:"상위부서코드",			Type:"Text",		SaveName:"up_brc",				Align:"Center",	Width:80,	Hidden:1},
 				{Header:"상위부서명",			Type:"Text",		SaveName:"up_brnm",				Align:"Left",	Width:200,	Hidden:1},
 				{Header:"사용여부",			Type:"Text",		SaveName:"uyn",					Align:"Center",	Width:80,	Hidden:1},
 				{Header:"폐쇄여부",			Type:"Text",		SaveName:"br_lko_yn",			Hidden:1},
 				{Header:"시도구분",			Type:"Text",		SaveName:"rgn_nm",				Hidden:1},
 				{Header:"시도구분코드",			Type:"Text",		SaveName:"rgn_c",				Hidden:1},
 				{Header:"인사급여사무소형태",		Type:"Text",		SaveName:"hursal_br_form_nm",	Hidden:1},
 				{Header:"인사급여사무소형태코드",	Type:"Text",		SaveName:"hursal_br_form_c",	Hidden:1},
 				{Header:"최하위부서여부",		Type:"Text",		SaveName:"lwst_orgz_yn",		Hidden:1},
 				{Header:"RCSA부서여부",		Type:"Text",		SaveName:"rcsa_orgz_yn",		Hidden:1},
 				{Header:"KRI부서여부",			Type:"Text",		SaveName:"kri_orgz_yn",			Hidden:1},
 				{Header:"손실부서여부",			Type:"Text",		SaveName:"lss_orgz_yn",			Hidden:1},
 				{Header:"팀장결재여부",			Type:"Text",		SaveName:"temgr_dcz_yn",		Hidden:1},
 				{Header:"리스크풀 관련부서",		Type:"Text",		SaveName:"orgz_cfnm",			Hidden:1},
 				{Header:"리스크풀 관련부서코드",	Type:"Text",		SaveName:"orgz_cfc",			Hidden:1},
 				{Header:"본점영업점구분",		Type:"Text",		SaveName:"hofc_bizo_dsnm",		Hidden:1},
 				{Header:"본점영업점구분코드",		Type:"Text",		SaveName:"hofc_bizo_dsc",		Hidden:1},
 				{Header:"부서코드_OLD",		Type:"Text",		SaveName:"brc_old",				Hidden:1},
 				{Header:"업무사용여부",			Type:"Text",		SaveName:"bsn_uyn",				Hidden:1}
   			];
 			IBS_InitSheet(mySheet,initData);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			mySheet.ShowFilterRow();  
			mySheet.SetEditable(0); //수정불가
			mySheet.FitColWidth();
			mySheet.ShowTreeLevel(2, 1);
			mySheet.SetFocusAfterProcess(0);
			mySheet.SetActionMenu("엑셀 다운로드");
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//트리컬럼 체크박스 사용시 어미/자식 간의 연관 체크기능 사용
			//mySheet.SetTreeCheckActionMode(1); 
			
			//doAction('search');
			
		}
		
		$(document).ready(function() {
			doAction('search');
		});
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet_OnSelectMenu(text,code){
			if(text=="엑셀 다운로드"){
				doAction("down2excel");	
			}
		}
		
		function mySheet_OnRowSearchEnd (Row) {
			mySheet.SetCellValue(Row,"brc_old",mySheet.GetCellValue(Row,"brc"));
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
			}
		}
		
		function mySheet_OnClick(Row) { 
			if(Row >= mySheet.GetDataFirstRow()){
				
				sheetCopy(Row);
				
				$("#sel_brc").val(mySheet.GetCellValue(Row,"brc"));
				
				if(mySheet.GetCellValue(Row,"brc_old") == ""){
					$("#mode").val("I");
					mySheet.SetBlur();
					$("#brc").attr("disabled",false);
					$("#brc").focus();
				}else{
					$("#mode").val("U");
				}
				$("#select_row").val(Row);
				
				$("#brnm").attr("disabled",false);
				$("#uyn").attr("disabled",false);
				$("#hofc_bizo_dsc").attr("disabled",false);
				/*
				$("#rgn_c").attr("disabled",false);
				$("#hursal_br_form_c").attr("disabled",false);
				$("#br_lko_yn").attr("disabled",false);
				$("#lwst_orgz_yn").attr("disabled",false);
				$("#rcsa_orgz_yn").attr("disabled",false);
				$("#kri_orgz_yn").attr("disabled",false);
				$("#lss_orgz_yn").attr("disabled",false);
				$("#temgr_dcz_yn").attr("disabled",false);
				$("#orgz_cfc").attr("disabled",false);
				*/
			}
		}
		
		function sheetCopy(row){
			$("#brc").val(mySheet.GetCellValue(row,"brc"));
			$("#brnm").val(mySheet.GetCellValue(row,"brnm"));
			$("#up_brc").val(mySheet.GetCellValue(row,"up_brc"));
			$("#up_brnm").val(mySheet.GetCellValue(row,"up_brnm"));
			$("#level").val(mySheet.GetCellValue(row,"level"));
			$("#uyn").val(mySheet.GetCellValue(row,"uyn"));
			$("#hofc_bizo_dsc").val(mySheet.GetCellValue(row,"hofc_bizo_dsc"));
			/*
			$("#rgn_c").val(mySheet.GetCellValue(row,"rgn_c"));
			$("#hursal_br_form_c").val(mySheet.GetCellValue(row,"hursal_br_form_c"));
			$("#br_lko_yn").val(mySheet.GetCellValue(row,"br_lko_yn"));
			$("#lwst_orgz_yn").val(mySheet.GetCellValue(row,"lwst_orgz_yn"));
			$("#rcsa_orgz_yn").val(mySheet.GetCellValue(row,"rcsa_orgz_yn"));
			$("#kri_orgz_yn").val(mySheet.GetCellValue(row,"kri_orgz_yn"));
			$("#lss_orgz_yn").val(mySheet.GetCellValue(row,"lss_orgz_yn"));
			$("#temgr_dcz_yn").val(mySheet.GetCellValue(row,"temgr_dcz_yn"));
			$("#orgz_cfc").val(mySheet.GetCellValue(row,"orgz_cfc"));
			*/
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var select_brs = new Array();
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD012602");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "down2excel":
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "부서정보.xlsx",  SheetName : "Sheet1", DownTreeHide:"True", DownCols:"2|3|4|5|6|7"} ;

					//setExcelDownCols("1|2|3|4");
					mySheet.Down2Excel(params);

					break;
					
				case "insert":		//신규행 추가
					var srow = mySheet.GetSelectRow();
					
					if(srow < 0){
						alert("부서를 선택해 주세요.");
						return;
					}
					
					if(mySheet.GetCellText(srow,"brc") == ""){
						alert("상위 부서를 저장 후 추가하세요.");
						return ;
					}
					
					if(mySheet.GetRowExpanded(srow) == 0){
					    mySheet.SetRowExpanded(srow, 1);
					}
					
					var row = mySheet.DataInsert(srow+1, mySheet.GetRowLevel(srow)+1 ); 
					mySheet.SetCellValue(row,"up_brc", mySheet.GetCellText(srow,"brc"));
					mySheet.SetCellValue(row,"up_brnm", mySheet.GetCellText(srow,"brnm"));
					mySheet.SetCellValue(row,"level", Number(mySheet.GetCellText(srow,"level"))+1);
					mySheet.SetCellValue(row,"uyn", "Y");
					/*
					mySheet.SetCellValue(row,"br_lko_yn", "N");
					mySheet.SetCellValue(row,"lwst_orgz_yn", "Y");
					mySheet.SetCellValue(row,"rcsa_orgz_yn", "Y");
					mySheet.SetCellValue(row,"kri_orgz_yn", "Y");
					mySheet.SetCellValue(row,"lss_orgz_yn", "Y");
					mySheet.SetCellValue(row,"temgr_dcz_yn", "N");
					*/
					
					$("#mode").val("I");
					$("#select_row").val(row);
					
					mySheet_OnClick(row);
					break; 
				case "del":      //삭제
					var srow = mySheet.GetSelectRow();
					if(srow < 0) {
						alert("삭제할 부서를 선택하세요.");
						return;
					}
					
					if(mySheet.GetChildRows(srow) != ""){
						alert("하위 부서가 있으면 삭제가 불가능합니다.");
						return;
					}
					
					if(mySheet.GetCellValue(srow,"bsn_uyn") == "Y"){
						alert("RCSA, KRI에서 사용하고 있는 부서는 삭제가 불가능합니다.");
						return;
					}
					
					if(mySheet.GetCellValue(srow,"brc_old") == ""){
						mySheet.RowDelete(srow, 0);
						mySheet.SetSelectRow(-1);
						init();
					}else{
						
						if(!confirm("삭제하시겠습니까?")) return;
					
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "adm");
						WP.setParameter("process_id", "ORAD012605");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
						{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="S") {
									alert("삭제되었습니다.");
									mySheet.RowDelete(srow, 0);
									mySheet.SetSelectRow(-1);
									init();
								}else if(result!='undefined'){
									alert(result.rtnMsg);
								}else if(result=='undefined'){
									alert("처리할 수 없습니다.");
								}  
							},
						  
							complete: function(statusText,status){
								removeLoadingWs();
							},
						  
							error: function(rtnMsg){
								alert(JSON.stringify(rtnMsg));
							}
						});
					}
					
					break;
				case "save":      //저장할 데이터 추출
					
					/*
					select_brs = new Array();
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i,"status")=="I" || mySheet.GetCellValue(i,"status")=="U"){
							var obj = new Object();
							obj["brc"] = mySheet.GetCellValue(i,"brc") 
							obj["up_brc"] = mySheet.GetCellValue(i,"up_brc") 
							obj["brnm"] = mySheet.GetCellValue(i,"brnm") 
							select_brs.push(obj);
						}
					}
					*/
					
					var srow = mySheet.GetSelectRow();
					if(srow < 0) {
						alert("부서 목록에서 부서를 선택 후 수정 또는 추가해 주시기 바랍니다.");
						return;
					}
					
					if($("#brc").val() == ""){
						alert("부서코드를 입력해 주십시오.");
						$("#brc").focus();
						return;
					}
					
					if($("#brnm").val() == ""){
						alert("부서명을 입력해 주십시오.");
						$("#brnm").focus();
						return;
					}
					
					if($("#hofc_bizo_dsc").val() == ""){
						alert("부서구분을 선택해 주세요.");
						$("#hofc_bizo_dsc").focus();
						return;
					}
					
					if($("#hofc_bizo_dsc").val() == "01" && $("#level").val() != "1"){
						alert("부서구분-전사는 최상위 부서만 선택 가능합니다.");
						$("#hofc_bizo_dsc").focus();
						return;
					}
					
					if(!confirm("저장하시겠습니까?")) return;
					
					/*
					mySheet.SetCellValue(srow, "brc", $("#brc").val());
					mySheet.SetCellValue(srow, "brnm", $("#brnm").val());
					mySheet.SetCellValue(srow, "rgn_c", $("#rgn_c").val());
					mySheet.SetCellValue(srow, "hursal_br_form_c", $("#hursal_br_form_c").val());
					mySheet.SetCellValue(srow, "br_lko_yn", $("#br_lko_yn").val());
					mySheet.SetCellValue(srow, "uyn", $("#uyn").val());
					mySheet.SetCellValue(srow, "lwst_orgz_yn", $("#lwst_orgz_yn").val());
					mySheet.SetCellValue(srow, "rcsa_orgz_yn", $("#rcsa_orgz_yn").val());
					mySheet.SetCellValue(srow, "kri_orgz_yn", $("#kri_orgz_yn").val());
					mySheet.SetCellValue(srow, "lss_orgz_yn", $("#lss_orgz_yn").val());
					mySheet.SetCellValue(srow, "temgr_dcz_yn", $("#temgr_dcz_yn").val());
					mySheet.SetCellValue(srow, "orgz_cfc", $("#orgz_cfc").val());
					
					mySheet.DoSave(url + "?method=Main&commkind=adm&process_id=ORAD012603");
					*/
					
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					if($("#mode").val() == "I"){
						WP.setParameter("process_id", "ORAD012604");
					}else if($("#mode").val() == "U"){
						WP.setParameter("process_id", "ORAD012603");
					}else{
						return;
					}
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					//alert(inputData);
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("저장되었습니다.");
								if($("#mode").val() == "I"){
									$("#mode").val("U");
									mySheet.SetCellValue(srow,"brc_old",mySheet.GetCellValue(srow,"brc"));
									$("#sel_brc").val(mySheet.GetCellValue(srow,"brc"));
								}
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});					
					
					break;
				case "ref":		//초기화
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD012602");
					
					init();
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break; 
			}
		}

		function mySheet_OnSearchEnd(code, message) {
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			mySheet.FitColWidth();
			mySheet.ShowTreeLevel(2,1);
			
			$("#mode").val("");
			$("#select_row").val("");
			//br_select();
		}
		
		function br_select() {
			if(select_brs.length>0){
				var obj = select_brs.pop();
				if(obj["brc"] == ""){
					var st_idx = 0;
					for(var i =0;i<10;i++){
						var Row1 = mySheet.FindText("up_brc", obj["up_brc"], st_idx, -1, 0);
						if(Row1<0) break;
						if(mySheet.GetCellValue(Row1,"brnm") == obj["brnm"]){
							//mySheet.SelectCell(Row1,"mnnm");
							mySheet.SetSelectRow(Row1,1);
							break;
						}
						st_idx = Row1 + 1;
					}
				}else{
					var Row1 = mySheet.FindText("brc", obj.brc, 0, -1, 0);
					mySheet.SetSelectRow(Row1,1);
				}
			}
			if(select_brs.length>0) setTimeout(br_select,1)
		
		}
		
		function mySheet_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	//init();
		        //doAction("search");      
		    } else {
		    	alert("처리중 오류가 발생하였습니다.");
		    }
		}
		
		function init(){
			$("#brc").attr("disabled",true);
			$("#up_brc").attr("disabled",true);
			$("#up_brnm").attr("disabled",true);
			$("#brnm").attr("disabled",true);
			$("#level").attr("disabled",true);
			$("#uyn").attr("disabled",true);
			$("#hofc_bizo_dsc").attr("disabled",true);
			/*
			$("#rgn_c").attr("disabled",true);
			$("#hursal_br_form_c").attr("disabled",true);
			$("#br_lko_yn").attr("disabled",true);
			$("#lwst_orgz_yn").attr("disabled",true);
			$("#rcsa_orgz_yn").attr("disabled",true);
			$("#kri_orgz_yn").attr("disabled",true);
			$("#lss_orgz_yn").attr("disabled",true);
			$("#temgr_dcz_yn").attr("disabled",true);
			$("#orgz_cfc").attr("disabled",true);
			*/
			
			$("#brc").val("");
			$("#up_brc").val("");
			$("#up_brnm").val("");
			$("#brnm").val("");
			$("#level").val("");
			$("#uyn").val("Y");
			$("#hofc_bizo_dsc").val("");
			/*
			$("#rgn_c").val("");
			$("#hursal_br_form_c").val("");
			$("#br_lko_yn").val("N");
			$("#lwst_orgz_yn").val("N");
			$("#rcsa_orgz_yn").val("N");
			$("#kri_orgz_yn").val("N");
			$("#lss_orgz_yn").val("N");
			$("#temgr_dcz_yn").val("N");
			$("#orgz_cfc").val("");
			*/
			
			$("#mode").val("");
			$("#select_row").val("");
		}
		
		function onChange(sAction) {
			var sRow = mySheet.GetSelectRow();
			if(sRow < 0) return;
			
			mySheet.SetCellValue(sRow,sAction,$("#"+sAction+"").val());
		}
		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet.ShowTreeLevel(0,1);
			}
		}
	</script>

</head>
<body class="" onkeyPress="return EnterkeyPass()">
	<div class="container">
		<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>
		<div class="content">
			<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="up_brc" name="up_brc" />
			<input type="hidden" id="mode" name="mode" />
			<input type="hidden" id="select_row" name="select_row" />
			<input type="hidden" id="sel_brc" name="sel_brc" />
			<div id="hdn_area"></div>
			<div class="row">
				<div class="col col-xs-5">
					<div class="box box-grid">
						<div class="box-header">
							<div class="area-tool">
								<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
							</div>
						</div>
						<div class="box-body">
							<div class="wrap-grid h550">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
						<div class="box-footer">
							<div class="btn-wrap">
								<%--
								<button type="button" class="btn btn-default btn-sm" onclick="javascript:brUploadPop()"><i class="fa fa-plus"></i><span class="txt">부서 전체 업로드</span></button>
								 --%>
								<button type="button" class="btn btn-default btn-sm" onclick="javascript:doAction('insert')"><i class="fa fa-plus"></i><span class="txt">하위 부서 추가</span></button>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-xs-7">
					<div class="box box-grid">
						<div class="box-header">
							<h3 class="box-title">부서 정보</h3>
						</div>
						<div class="box-body">
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width:160px">
										<col>
										<col style="width:160px">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th scorpe="row"><label class="" for="brc">부서코드</label></th>
											<td>
												<input type="text" class="form-control" id="brc" name="brc" value="" maxlength="6" onkeypress="inNumber()" onchange="javascript:onChange('brc');" disabled>
											</td>
											<th scorpe="row"><label class="" for="brnm">부서명</label></th>
											<td>
												<input type="text" class="form-control" id="brnm" name="brnm" value="" maxlength="20" onchange="javascript:onChange('brnm');" disabled>
											</td>
										</tr>
										<tr>
											<th scorpe="row"><label class="" for="up_brnm">상위부서명</label></th>
											<td>
												<input type="text" class="form-control" id="up_brnm" name="up_brnm" value="" disabled>
											</td>
											<th scorpe="row"><label class="" for="level">레벨</label></th>
											<td>
												<input type="text" class="form-control" id="level" name="level" value="" maxlength="1" numberonly disabled>
											</td>
											
										</tr>
										<tr>
											<th scorpe="row"><label class="" for="uyn">사용여부</label></th>
											<td>
												<span class="select">
													<select class="form-control" id="uyn" name="uyn" onchange="javascript:onChange('uyn');" disabled>
														<option value="Y" selected>사용</option>
														<option value="N">미사용</option>
													</select>
												</span>
											</td>
											<th scorpe="row"><label class="" for="uyn">부서구분</label></th>
											<td>
												<span class="select">
													<select class="form-control" id="hofc_bizo_dsc" name="hofc_bizo_dsc" onchange="javascript:onChange('hofc_bizo_dsc');" disabled>
														<option value="">선택</option>
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap2 = (HashMap)vLst2.get(i);
%>
														<option value="<%=(String)hMap2.get("intgc")%>"><%=(String)hMap2.get("intg_cnm")%></option>
<%
	}
%>
													</select>
												</span>
											</td>
										</tr>
										<%-- 
										<tr>
											<th scorpe="row"><label class="" for="">시도구분코드</label></th>
											<td>
												<input type="text" class="form-control" id="rgn_c" name="rgn_c" value="" maxlength="4" numberonly disabled>
											</td>
											<th scorpe="row"><label class="" for="">인사급여사무소형태코드</label></th>
											<td>
												<input type="text" class="form-control" id="hursal_br_form_c" name="hursal_br_form_c" value="" maxlength="2" disabled>
											</td>
										</tr>
										<tr>
											<th scorpe="row"><label class="" for="br_lko_yn">부서폐쇄여부</label></th>
											<td>
												<span class="select">
													<select class="form-control" id="br_lko_yn" name="br_lko_yn" disabled>
														<option value="Y">폐쇄</option>
														<option value="N" selected>미폐쇄</option>
													</select>
												</span>
											</td>
											<th scorpe="row"><label class="" for="uyn">사용여부</label></th>
											<td>
												<span class="select">
													<select class="form-control" id="uyn" name="uyn" disabled>
														<option value="Y" selected>사용</option>
														<option value="N">미사용</option>
													</select>
												</span>
											</td>
										</tr>
										<tr>
											<th scorpe="row"><label class="" for="lwst_orgz_yn">최하위부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="lwst_orgz_yn" name="lwst_orgz_yn" disabled>
														<option value="Y">여</option>
														<option value="N" selected>부</option>
													</select>
												</span>
											</td>
											<th scorpe="row"><label class="" for="orgz_cfc">리스크풀 관련부서<br>(영업본부/영업점)</label></th>
											<td>
												<span class="select">
													<select class="form-control" id="orgz_cfc" name="orgz_cfc" disabled>
														<option value="">해당없음</option>
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
										</tr>
										<tr>
											<th scorpe="row"><label class="" for="rcsa_orgz_yn">RCSA부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="rcsa_orgz_yn" name="rcsa_orgz_yn" disabled>
														<option value="Y">여</option>
														<option value="N" selected>부</option>
													</select>
												</span>
											</td>
											<th scorpe="row"><label class="" for="kri_orgz_yn">KRI부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="kri_orgz_yn" name="kri_orgz_yn" disabled>
														<option value="Y">여</option>
														<option value="N" selected>부</option>
													</select>
												</span>
											</td>
										</tr>
										<tr>
											<th scorpe="row"><label class="" for="lss_orgz_yn">손실부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="lss_orgz_yn" name="lss_orgz_yn" disabled>
														<option value="Y">여</option>
														<option value="N" selected>부</option>
													</select>
												</span>
											</td>
											<th scorpe="row"><label class="" for="temgr_dcz_yn">팀장결재여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="temgr_dcz_yn" name="temgr_dcz_yn" disabled>
														<option value="Y">여</option>
														<option value="N" selected>부</option>
													</select>
												</span>
											</td>
										</tr>
										--%>
									</tbody>
								</table>
							</div>
						</div>
						<div class="box-footer">
							<div class="btn-wrap">
								<%--<button type="button" class="btn btn-normal" onclick="javascript:doAction('ref')">초기화</button>--%>
								<button type="button" id="btnSave" class="btn btn-primary" onclick="javascript:doAction('save')">
									<span class="txt">저장</span>
								</button>
								<button type="button" id="btnDel" class="btn btn-default" onclick="javascript:doAction('del')">
									<span class="txt">삭제</span>
								</button>
								
							</div>
						</div>
					</div>
				</div>
			</div><!-- .row //-->
				
			</form>
		</div>
	</div><!-- .container //-->
	<!-- popup //-->
	<div id='winBrUpload' class='popup modal' style="background-color:transparent">
		<iframe id='ifrBrUpload' src="about:blank" name='ifrBrUpload' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
	</div>
	<script>
		
		function closeBrPop(){
			$("#winBrUpload").hide();
		}
		
		function brUploadPop(){
			var f = document.ormsForm;
			f.path.value="/adm/ORAD0127";
	        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
			f.target = "ifrBrUpload";
			f.submit();
		}
		
	</script>
</body>
</html>