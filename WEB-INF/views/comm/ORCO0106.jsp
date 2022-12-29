<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0106.jsp
 Program name : 공통 > 부서별 직원 조회(팝업)
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
DynaForm form = (DynaForm)request.getAttribute("form");
String rtn_func = form.get("rtn_func");
String search_mode = form.get("search_mode");
rtn_func = StringUtil.htmlEscape(rtn_func);
search_mode = StringUtil.htmlEscape(search_mode);
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			$("#winBuseoEmp",parent.document).show();
			// ibsheet 초기화
			initIBSheet1();
			createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
			//initIBSheet2();
		});
		
		$(document).ready(function(){
			initIBSheet2();
		});
		
		/*Sheet1 기본 설정 */
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": sizeNoHScroll, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1};
			initData.Cols = [
 				{Header:"상위부서코드",				Type:"Text",	SaveName:"up_brc",			Hidden:true},
 				{Header:"부서코드",					Type:"Text",	SaveName:"brc",				Hidden:true},
 				{Header:"레벨",					Type:"Text",	SaveName:"level",			Hidden:true},
 				{Header:"부서명",					Type:"Text",	SaveName:"brnm",			TreeCol:1,	Width:580,	MinWidth:150},
 				{Header:"본부부서/영업점 구분 코드",		Type:"Text",	SaveName:"hofc_bizo_dsc",	Hidden:true}
 			];
			IBS_InitSheet(mySheet1,initData);
			
			mySheet1.SetEditable(0); //수정불가
			mySheet1.SetFocusAfterProcess(0);
			
			
			//필터표시
			mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet1.FitColWidth();
			//mySheet1.SetActionMenu("필터On|*-|필터 Off", "_ibShowFilter||_ibHideFilter");


			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			doAction('orgSearch');
			
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet1.GetDataFirstRow()){
				$("#sel_brc").val(mySheet1.GetCellValue(Row, "brc"));
				$("#sel_hofc_bizo_dsc").val(mySheet1.GetCellValue(Row, "hofc_bizo_dsc"));

				doAction("empSearch");
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
			mySheet1.ShowTreeLevel(1,1);
			
			mySheet1.SetBlur();
			$("#filter_txt").focus();
		}
		
		function mySheet1_OnChangeFilter(){
		}
		
		function mySheet1_OnFilterEnd(RowCnt, FirstRow) {
			if(RowCnt>100){
				//mySheet1.ShowTreeLevel(1,1);
				mySheet1.ShowTreeLevel(-1,0);
			}else{				
				mySheet1.ShowTreeLevel(-1,0);
			}
			
			mySheet1.SetBlur();
			$("#filter_txt").focus();
			
		}
		
		/*Sheet2 기본 설정 */
		function initIBSheet2() {
			mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"부장",			Type:"Html",		SaveName:"mng_director",	Width:40,		MinWidth:50, Align:"Center",	Edit:0},
				{Header:"팀장",			Type:"Html",		SaveName:"mng_team",		Width:40,		MinWidth:50, Align:"Center",	Edit:0},
 				{Header:"지점장",			Type:"Html",		SaveName:"mng_br",			Width:40,		MinWidth:50, Align:"Center",	Edit:0},
				{Header:"담당자",			Type:"Html",		SaveName:"ope_bip",			Width:40,		MinWidth:50, Align:"Center",	Edit:0},
				{Header:"개인번호",			Type:"Text",		SaveName:"eno",				Width:80,		MinWidth:50, Align:"Center",	Edit:0},
 				{Header:"부서명",			Type:"Text",		SaveName:"brnm",			Width:100,		MinWidth:50, Align:"Center",	Edit:0},
 				{Header:"팀",			Type:"Text",		SaveName:"team_cnm",		Width:100,		MinWidth:50, Align:"Center",	Edit:0},
 				{Header:"직급",			Type:"Text",		SaveName:"pzcnm",			Width:80,		MinWidth:50, Align:"Center",	Edit:0 , Hidden:true},
 				{Header:"직위",			Type:"Text",		SaveName:"oft",				Width:80,		MinWidth:50, Align:"Center",	Edit:0},
 				{Header:"직원명",			Type:"Text",		SaveName:"empnm",			Width:100,		MinWidth:50, Align:"Center",	Edit:0},
 				{Header:"부서코드",			Type:"Text",		SaveName:"brc",				Hidden:true}
 			];
			IBS_InitSheet(mySheet2,initData);
			
			//mySheet2.SetEditable(0); //수정불가
			mySheet2.SetFocusAfterProcess(0);
			
			//필터표시
			mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);

			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet2.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet2);
			
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			if(Row >= mySheet2.GetDataFirstRow()){
				$("#sel_eno").val(mySheet2.GetCellValue(Row, "eno"));
				$("#sel_enm").val(mySheet2.GetCellValue(Row, "empnm"));
			}
		}
		
		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet2.GetDataFirstRow()){
				$("#sel_eno").val(mySheet2.GetCellValue(Row, "eno"));
				$("#sel_enm").val(mySheet2.GetCellValue(Row, "empnm"));
				
				doAction('select');
			}
		}
		
		function mySheet2_OnRowSearchEnd (Row) {
			/* 부서 ORM 업무담당자 : OPE_BIC */
			if(mySheet2.GetCellValue(Row,"ope_bip") == "1"){
				mySheet2.SetCellText(Row,"ope_bip",'<input type="checkbox" checked disabled/>');
			}else{
				mySheet2.SetCellText(Row,"ope_bip",'<input type="checkbox" disabled/>');
			}
			/* 부서팀장 */
			if(mySheet2.GetCellValue(Row,"mng_team") == "1"){
				mySheet2.SetCellText(Row,"mng_team",'<input type="checkbox" checked disabled/>');
			}else{
				mySheet2.SetCellText(Row,"mng_team",'<input type="checkbox" disabled/>');
			}
			/* 부장 */
			if(mySheet2.GetCellValue(Row,"mng_director") == "1"){
				mySheet2.SetCellText(Row,"mng_director",'<input type="checkbox" checked disabled/>');
			}else{
				mySheet2.SetCellText(Row,"mng_director",'<input type="checkbox" disabled/>');
			}
			/* 지점장 */
			if(mySheet2.GetCellValue(Row,"mng_br") == "1"){
				mySheet2.SetCellText(Row,"mng_br",'<input type="checkbox" checked disabled/>');
			}else{
				mySheet2.SetCellText(Row,"mng_br",'<input type="checkbox" disabled/>');
			}
			/* 영업점 ,본부 여부 */
			if($("#sel_hofc_bizo_dsc").val()=="02")/*본부*/{
				mySheet2.SetColHidden("mng_team",0);
				mySheet2.SetColHidden("mng_director",0);
				mySheet2.SetColHidden("mng_br",1);
				mySheet2.SetColHidden("team_cnm",0);
			}else if($("#sel_hofc_bizo_dsc").val()=="03")/*영업점*/{
				mySheet2.SetColHidden("mng_team",1);
				mySheet2.SetColHidden("mng_director",1);
				mySheet2.SetColHidden("mng_br",0);
				mySheet2.SetColHidden("team_cnm",1);
			}
		}
		
		function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "orgSearch":  //부서 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					$("form[name=ormsForm] [name=process_id]").val("ORCO010602");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
					
				case "empSearch":  //직원 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					$("form[name=ormsForm] [name=process_id]").val("ORCO010603");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
					
				case "filter": //부서 선택
					if($("#filter_txt").val()==""){
						mySheet1.ClearFilterRow()
					}else{
						mySheet1.SetFilterValue("brnm", $("#filter_txt").val(), 11);
					}
					break;
					
				case "select": //부서 선택
					
					if($("#sel_eno").val() == ""){
						alert("직원을 선택해 주십시오.");
						return;
					}
				
					var func = eval("parent.<%=rtn_func%>");
					
					func($("#sel_eno").val(), $("#sel_enm").val());
					
					//parent.func($("#sel_brc").val(), $("#sel_brnm").val());
					
					break;
			}
		}
		
		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet1.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet1.ShowTreeLevel(0,1);
			}
		}
		
	</script>
    <style>
        #DIV_mySheet1{width:100% !important;}
        #DIV_mySheet2{width:100% !important;}
    </style>
</head>
<body onkeyPress="return EnterkeyPass()">
	<form name="ormsForm" method="post">
    <input type="hidden" id="sel_brc" name="sel_brc" /> <!-- 선택한 부서코드-->
    <input type="hidden" id="sel_eno" name="sel_eno" /> <!-- 선택한 사원번호-->
    <input type="hidden" id="sel_hofc_bizo_dsc" name="sel_hofc_bizo_dsc" /> <!-- 선택한 영업점/본부부서 구분 코드 -->
    <input type="hidden" id="sel_enm" name="sel_enm" /> <!-- 선택한 사원명-->
    <input type="hidden" id="path" name="path" />
    <input type="hidden" id="process_id" name="process_id" />
    <input type="hidden" id="commkind" name="commkind" />
    <input type="hidden" id="method" name="method" />
    <input type="hidden" id="rtn_func" name="rtn_func" />
    <input type="hidden" id="search_mode" name="search_mode" value="<%=search_mode%>" />
    
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w1000 ">
			<div class="p_head">
				<h1 class="title">부서직원 선택</h1>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<colgroup>
										<col>
									</colgroup>
									<tbody>
										<tr>
											<td>
												<input type="text" class="form-control w280" id="filter_txt" name="filter_txt" value="" placeholder="부서명을 입력하세요" onkeypress="EnterkeySubmit(doAction, 'filter');">
											</td>
											<td>
												<button type="button" class="btn btn-primary search" onclick="javascript:doAction('filter');">조회</button>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					
					<div class="box row">
						<div class="col w30p">							
							<section class="box box-grid">
								<div class="box-header">
									<div class="area-tool">
										<div class="grid-tree-btn">
										    <button type="button" class="btn btn-xs" title="모두 펼치기" onClick="mySheet_showAllTree('1');"><i class="fa fa-plus-circle"></i></button>
											<button type="button" class="btn btn-xs" title="모두 접기" onClick="mySheet_showAllTree('2');"><i class="fa fa-minus-circle"></i></button>
										</div>
									</div>
								</div>
								<div class="wrap-grid h350">
									<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
								</div>
							</section>
						</div>
						<div class="col w70p">					
							<section class="box box-grid">
								<div class="box-header"></div>
								<div class="wrap-grid h350" id="mydiv2">
									<!-- <script type="text/javascript">createIBSheet("mySheet2", "100%", "100%");</script> -->
								</div>
							</section>
						</div>
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="doAction('select');">선택</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>

		</div>
		<div class="dim p_close"></div>
	</article>
	</form>
	
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				$("#winBuseoEmp",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			//$("#ifrOrg",parent.document).attr("src","about:blank");
			$("#winBuseoEmp",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#sel_brc").val("");
			$("#sel_eno").val("");
			$("#sel_enm").val("");
			closePop();
		});
		
/* 		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('filter');
				return true;
			}else{
				return true;
			}
		} */
		
	</script>	
</body>
</html>