<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0104.jsp
 Program name : ADMIN > 코드관리 > 영향유형코드
 Description  : 
 Programer    : 박승윤	
 Date created : 2022.06.16
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
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize"};
			initData.Cols = [
 				{Header:"레벨",				Type:"Text",		SaveName:"level",				Align:"Center",	Width:30,	Hidden:true},
 				{Header:"영향유형",			Type:"Text",		SaveName:"ifn_tpnm",			Align:"Left",	Width:120,	TreeCol:1},
 				{Header:"영향유형코드",			Type:"Text",		SaveName:"ifn_tpc",				Align:"Center",	Width:40,	Hidden:true},
 				{Header:"상위영향유형코드",		Type:"Text",		SaveName:"up_ifn_tpc",			Align:"Center",	Width:40,	Hidden:true},
 				{Header:"LV0_영향유형코드",		Type:"Text",		SaveName:"lv0_ifn_tpc",			Hidden:true},
 				{Header:"LV1_영향유형코드",		Type:"Text",		SaveName:"lv1_ifn_tpc",			Hidden:true},
 				{Header:"LV2_영향유형코드",		Type:"Text",		SaveName:"lv2_ifn_tpc",			Hidden:true},
 				{Header:"LV0_영향유형명",		Type:"Text",		SaveName:"lv0_ifn_tpnm",		Hidden:true},
 				{Header:"LV1_영향유형명",		Type:"Text",		SaveName:"lv1_ifn_tpnm",		Hidden:true},
 				{Header:"LV2_영향유형명",		Type:"Text",		SaveName:"lv2_ifn_tpnm",		Hidden:true},
 				{Header:"LV0_영문영향유형명",	Type:"Text",		SaveName:"lv0_eng_ifn_tpnm",	Hidden:true},
 				{Header:"LV1_영문영향유형명",	Type:"Text",		SaveName:"lv1_eng_ifn_tpnm",	Hidden:true},
 				{Header:"LV2_영문영향유형명",	Type:"Text",		SaveName:"lv2_eng_ifn_tpnm",	Hidden:true},
 				{Header:"영향유형설명",			Type:"Text",		SaveName:"ifn_tp_cntn",			Align:"Left",	Width:150,		Hidden:true},
 				{Header:"영문영향유형설명",		Type:"Text",		SaveName:"eng_ifn_tp_cntn",		Align:"Left",	Width:150,		Hidden:true},
 				{Header:"타업무사용여부",		Type:"Text",		SaveName:"uyn",					Hidden:true}
   			];
 			IBS_InitSheet(mySheet,initData);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			mySheet.SetFocusAfterProcess(0);
			
			mySheet.SetEditable(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			mySheet.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//트리컬럼 체크박스 사용시 어미/자식 간의 연관 체크기능 사용
			mySheet.SetTreeCheckActionMode(1); 
			
			//헤더기능 해제
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			//doAction('search');
			
		}
		
		$(document).ready(function() {
			doAction('search');
		});
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD010402");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "save":      //저장할 데이터 추출
				
					if($("#mode").val() == ""){
						alert("저장할 내역이 없습니다.");
						return;
					}
				
					if($("#mode").val() == "U" && $("#sel_ifn_tpc").val() == ""){
						alert("저장할 내역이 없습니다.");
						return;
					}
				
					if($("#sel_level").val() == "1"){
						if($("#lv1_ifn_tpnm").val() == ""){
							alert("영향유형명을 입력해 주십시오.");
							$("#lv1_ifn_tpnm").focus();
							return;
						}
						
						/*
						if($("#lv1_eng_ifn_tpnm").val() == ""){
							alert("영문영향유형명을 입력해 주십시오.");
							$("#lv1_eng_ifn_tpnm").focus();
							return;
						}
						*/
						
						$("#ifn_tpnm").val($("#lv1_ifn_tpnm").val());
						$("#eng_ifn_tpnm").val($("#lv1_eng_ifn_tpnm").val());
					}else if($("#sel_level").val() == "2"){
						if($("#lv2_ifn_tpnm").val() == ""){
							alert("영향유형명을 입력해 주십시오.");
							$("#lv2_ifn_tpnm").focus();
							return;
						}
						
						/*
						if($("#lv2_eng_ifn_tpnm").val() == ""){
							alert("영문영향유형명을 입력해 주십시오.");
							$("#lv2_eng_ifn_tpnm").focus();
							return;
						}
						*/
						
						$("#ifn_tpnm").val($("#lv2_ifn_tpnm").val());
						$("#eng_ifn_tpnm").val($("#lv2_eng_ifn_tpnm").val());
					}
				
					if(!confirm("저장하시겠습니까?")) return;
				
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					if($("#mode").val() == "I"){
						WP.setParameter("process_id", "ORAD010404");
					}else if($("#mode").val() == "U"){
						WP.setParameter("process_id", "ORAD010403");
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
								objCopy(result.Result.new_code);
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
				case "del":      //삭제
					var srow = mySheet.GetSelectRow();
				
					if(srow < 0) {
						alert("삭제할 항목을 선택하세요.");
						return;
					}
					
					var childRows = mySheet.GetChildRows(srow);
					if(childRows != ""){
						alert("하위 항목이 존재하는 영향유형은 삭제가 불가능합니다.");
						return;
					}
					
					if(mySheet.GetCellValue(srow,"uyn") == "Y"){
						alert("RCSA, KRI, 손실사건등에서 사용중인 영향유형은 삭제가 불가능합니다.");
						return;
					}
					
					if(mySheet.GetCellValue(srow,"ifn_tpc") == ""){
						mySheet.RowDelete(srow, 0);
						mySheet.SetSelectRow(-1);
						init();
					}else{
						
						if(!confirm("삭제하시겠습니까?")) return;
					
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "adm");
						WP.setParameter("process_id", "ORAD010405");
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
				case "insert":		//신규행 추가
					var srow = mySheet.GetSelectRow();
					//alert(mySheet.GetCellText(srow,"caus_id_srno"));
					
					if(srow < 0) {
						alert("항목을 선택해 주십시오.");
						return;
					}
					
					if(mySheet.GetCellValue(srow,"level") >= 2){
						alert("2레벨까지만 등록 가능합니다.");
						return;
					}

					if(mySheet.GetRowExpanded(srow) == 0){
					    mySheet.SetRowExpanded(srow, 1);
					}
					
					var row = mySheet.DataInsert(srow+1, mySheet.GetRowLevel(srow)+1 ); 
					mySheet.SetCellValue(row,"lv0_ifn_tpnm", mySheet.GetCellText(srow,"lv0_ifn_tpnm"));
					mySheet.SetCellValue(row,"lv0_eng_ifn_tpnm", mySheet.GetCellText(srow,"lv0_eng_ifn_tpnm"));
					mySheet.SetCellValue(row,"lv0_ifn_tpc", mySheet.GetCellText(srow,"lv0_ifn_tpc"));
					mySheet.SetCellValue(row,"lv1_ifn_tpnm", mySheet.GetCellText(srow,"lv1_ifn_tpnm"));
					mySheet.SetCellValue(row,"lv1_eng_ifn_tpnm", mySheet.GetCellText(srow,"lv1_eng_ifn_tpnm"));
					mySheet.SetCellValue(row,"lv1_ifn_tpc", mySheet.GetCellText(srow,"lv1_ifn_tpc"));
					mySheet.SetCellValue(row,"lv2_ifn_tpnm", mySheet.GetCellText(srow,"lv2_ifn_tpnm"));
					mySheet.SetCellValue(row,"lv2_eng_ifn_tpnm", mySheet.GetCellText(srow,"lv2_eng_ifn_tpnm"));
					mySheet.SetCellValue(row,"lv2_ifn_tpc", mySheet.GetCellText(srow,"lv2_ifn_tpc"));
					mySheet.SetCellValue(row,"up_ifn_tpc", mySheet.GetCellText(srow,"ifn_tpc"));
					mySheet.SetCellValue(row,"level", Number(mySheet.GetCellText(srow,"level"))+1);
					
					mySheet_OnClick(row);
					
					break; 
				case "down2excel":
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "영향유형코드.xlsx",  SheetName : "Sheet1", DownTreeHide:"True", DownCols:"0|1|2|3|13|14"} ;

					mySheet.Down2Excel(params);
					break;
			}
		}
		
		function mySheet_OnAfterExpand(Row, Expand){
			mySheet.FitColWidth();
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				init();
				mySheet.ShowTreeLevel(1,1);
			}
		}
		
		function mySheet_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		        doAction("search");      
		    }
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				init();
				
				$("#lv0_ifn_tpnm").val(mySheet.GetCellValue(Row,"lv0_ifn_tpnm"));
				$("#lv0_eng_ifn_tpnm").val(mySheet.GetCellValue(Row,"lv0_eng_ifn_tpnm"));
				$("#lv0_ifn_tpc").val(mySheet.GetCellValue(Row,"lv0_ifn_tpc"));
				$("#lv1_ifn_tpnm").val(mySheet.GetCellValue(Row,"lv1_ifn_tpnm"));
				$("#lv1_eng_ifn_tpnm").val(mySheet.GetCellValue(Row,"lv1_eng_ifn_tpnm"));
				$("#lv1_ifn_tpc").val(mySheet.GetCellValue(Row,"lv1_ifn_tpc"));
				$("#lv2_ifn_tpnm").val(mySheet.GetCellValue(Row,"lv2_ifn_tpnm"));
				$("#lv2_eng_ifn_tpnm").val(mySheet.GetCellValue(Row,"lv2_eng_ifn_tpnm"));
				$("#lv2_ifn_tpc").val(mySheet.GetCellValue(Row,"lv2_ifn_tpc"));
				$("#ifn_tp_cntn").val(mySheet.GetCellValue(Row,"ifn_tp_cntn"));
				$("#eng_ifn_tp_cntn").val(mySheet.GetCellValue(Row,"eng_ifn_tp_cntn"));
				
				$("#sel_ifn_tpc").val(mySheet.GetCellValue(Row,"ifn_tpc"));
				$("#sel_up_ifn_tpc").val(mySheet.GetCellValue(Row,"up_ifn_tpc"));
				$("#sel_level").val(mySheet.GetCellValue(Row,"level"));
				
				if(mySheet.GetCellValue(Row,"ifn_tpc") == ""){
					$("#mode").val("I");
				}else{
					$("#mode").val("U");
				}
				
				if($("#sel_level").val() == "1"){
					$("#lv1_ifn_tpnm").attr("disabled",false);
					$("#lv1_eng_ifn_tpnm").attr("disabled",false);
					if($("#mode").val() == "I"){
						mySheet.SetBlur();
						$("#lv1_ifn_tpnm").focus();
					}
				}else if($("#sel_level").val() == "2"){
					$("#lv2_ifn_tpnm").attr("disabled",false);
					$("#lv2_eng_ifn_tpnm").attr("disabled",false);
					$("#ifn_tp_cntn").attr("disabled",false);
					$("#eng_ifn_tp_cntn").attr("disabled",false);
					if($("#mode").val() == "I"){
						mySheet.SetBlur();
						$("#lv2_ifn_tpnm").focus();
					}
				}
			}
		}
		
		function init(){
			$("#lv1_ifn_tpnm").val("");
	    	$("#lv1_eng_ifn_tpnm").val("");
	    	$("#lv1_ifn_tpc").val("");
	    	$("#lv2_ifn_tpnm").val("");
	    	$("#lv2_eng_ifn_tpnm").val("");
	    	$("#lv2_ifn_tpc").val("");
	    	$("#ifn_tp_cntn").val("");
	    	$("#eng_ifn_tp_cntn").val("");
	    	$("#sel_ifn_tpc").val("");
	    	$("#sel_up_ifn_tpc").val("");
	    	$("#sel_level").val("");
	    	$("#mode").val("");
	    	$("#ifn_tpnm").val("");
	    	$("#eng_ifn_tpnm").val("");
	    	
	    	$("#lv1_ifn_tpnm").attr("disabled",true);
			$("#lv1_eng_ifn_tpnm").attr("disabled",true);
			$("#lv2_ifn_tpnm").attr("disabled",true);
			$("#lv2_eng_ifn_tpnm").attr("disabled",true);
			$("#ifn_tp_cntn").attr("disabled",true);
			$("#eng_ifn_tp_cntn").attr("disabled",true);
		}
		
		function objCopy(new_code){
			var srow = mySheet.GetSelectRow();
			var childRows = mySheet.GetChildRows(srow).split("|");
			
			mySheet.SetCellValue(srow, "ifn_tpnm", $("#ifn_tpnm").val());
			if($("#sel_level").val() == "1"){
				mySheet.SetCellValue(srow, "lv1_ifn_tpnm", $("#ifn_tpnm").val());
				mySheet.SetCellValue(srow, "lv1_eng_ifn_tpnm", $("#eng_ifn_tpnm").val());
				if($("#mode").val() == "I"){
					mySheet.SetCellValue(srow, "lv1_ifn_tpc", new_code);
					$("#lv1_ifn_tpc").val(new_code);
				}else{
					for(var i=0; i<=childRows.length; i++){
						mySheet.SetCellValue(childRows[i],"lv1_ifn_tpnm",$("#ifn_tpnm").val());
						mySheet.SetCellValue(childRows[i],"lv1_eng_ifn_tpnm",$("#eng_ifn_tpnm").val());
					}
				}
			}else if($("#sel_level").val() == "2"){
				mySheet.SetCellValue(srow, "lv2_ifn_tpnm", $("#ifn_tpnm").val());
				mySheet.SetCellValue(srow, "lv2_eng_ifn_tpnm", $("#eng_ifn_tpnm").val());
				mySheet.SetCellValue(srow, "ifn_tp_cntn", $("#ifn_tp_cntn").val());
				mySheet.SetCellValue(srow, "eng_ifn_tp_cntn", $("#eng_ifn_tp_cntn").val());
				if($("#mode").val() == "I"){
					mySheet.SetCellValue(srow, "lv2_ifn_tpc", new_code);
					$("#lv2_ifn_tpc").val(new_code);
				}
			}
			
			if($("#mode").val() == "I"){
				mySheet.SetCellValue(srow, "ifn_tpc", new_code);
				mySheet.SetCellValue(srow, "uyn", "N");
				$("#sel_ifn_tpc").val(new_code);
				$("#mode").val("U");
			}
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
<body class="">
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
			<input type="hidden" id="sel_ifn_tpc" name="sel_ifn_tpc" />
			<input type="hidden" id="sel_level" name="sel_level" />
			<input type="hidden" id="sel_up_ifn_tpc" name="sel_up_ifn_tpc" />
			<input type="hidden" id="mode" name="mode" />
			<input type="hidden" id="ifn_tpnm" name="ifn_tpnm" />
			<input type="hidden" id="eng_ifn_tpnm" name="eng_ifn_tpnm" />
			<div class="box box-grid">
				<div class="row">
					<div class="col w40p">
						<div class="box-header">
							<h2 class="box-title">영향유형 트리</h2>
							<div class="area-tool">
								<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction('down2excel')">
									<i class="ico xls"></i>
									<span class="txt">엑셀 다운로드</span>
								</button>
							</div>
						</div>
						<div>
						<table>
							<tr>
								<td>
								    <button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('1');"><i class="fa fa-plus"></i><span class="txt">모두 펼치기</span></button>
									<button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('2');"><i class="fa fa-minus"></i><span class="txt">모두 접기</span></button>
								</td>
							</tr>
						</table>
					</div>
						<div class="box-body">
							<div class="wrap-grid h500">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
						<div class="box-footer">
							<div class="btn-wrap">
								<button type="button" class="btn btn-default btn-sm" onclick="javascript:doAction('insert')"><i class="fa fa-plus"></i><span class="txt">하위 영향유형 추가</span></button>
							</div>
						</div>
					</div>

					<div class="col w60p">
						<div class="box-header">
							<h2 class="box-title">영향유형 정보</h2>
						</div>
						<div class="box-body">
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 100px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th rowspan="2">영향유형 Lv.1</th>
											<td>
												<div class="form-inline">
													<input type="text" name="lv1_ifn_tpnm" id="lv1_ifn_tpnm" class="form-control w49p" disabled>
													<input type="text" name="lv1_eng_ifn_tpnm" id="lv1_eng_ifn_tpnm" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" name="lv1_ifn_tpc" id="lv1_ifn_tpc" class="form-control w200" disabled>
											</td>
										</tr>
										<tr>
											<th rowspan="2">영향유형 Lv.2</th>
											<td>
												<div class="form-inline">
													<input type="text" name="lv2_ifn_tpnm" id="lv2_ifn_tpnm" class="form-control w49p" disabled>
													<input type="text" name="lv2_eng_ifn_tpnm" id="lv2_eng_ifn_tpnm" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" name="lv2_ifn_tpc" id="lv2_ifn_tpc" class="form-control w200" disabled>
											</td>
										</tr>
										<tr>
											<th>설명<br>(한글 / 영문)</th>
											<td>
												<textarea name="ifn_tp_cntn" id="ifn_tp_cntn" class="textarea h120" disabled></textarea>	
												<textarea name="eng_ifn_tp_cntn" id="eng_ifn_tp_cntn" class="textarea h120" disabled></textarea>	
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="box-footer">
							<div class="btn-wrap">
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
			</div>
			</form>
		</div>
		<!-- content //-->
		
	</div>
</body>
</html>