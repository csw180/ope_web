<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0107.jsp
 Program name : 공통 > 부서 조회(팝업)
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
	
	ServletContext sctx = request.getSession(true).getServletContext();
	String istest = sctx.getInitParameter("isTest");
	String servergubun = sctx.getInitParameter("servergubun");
	
	String org_search_txt = form.get("org_search_txt");

	org_search_txt = new String(form.get("org_search_txt").getBytes("ISO8859_1"), "UTF-8");//텍스트 깨짐 방지
	String org_rtn_func = form.get("org_rtn_func");
	org_rtn_func = StringUtil.htmlEscape(org_rtn_func);
	String org_mode = form.get("org_mode");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			$("#winBuseo",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": sizeNoHScroll, "MouseHoverMode": 0, "DragMode":1, DeferredVScroll:1};
			initData.Cols = [
 				{Header:"상위부서코드",		Type:"Text",	SaveName:"up_brc",		Hidden:true},
 				{Header:"부서코드",		Type:"Text",	SaveName:"brc",			Hidden:true},
 				{Header:"레벨",			Type:"Text",	SaveName:"level",		Hidden:true},
 				{Header:"부서명",			Type:"Text",	SaveName:"brnm",		TreeCol:1,	Width:439,	MinWidth:150}
 			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			
			//필터표시
			mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			
			mySheet.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			//mySheet.HideFilterRow();
				
			doAction('search');
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				//parent.$("#kbr_nm").val(mySheet.GetCellValue(Row, "kbr_nm"));
				//parent.$("#sch_new_br_cd").val(mySheet.GetCellValue(Row, "new_br_cd"));
				
				var func = eval("parent.<%=org_rtn_func%>");
				func($("#sel_brc").val(), $("#sel_brnm").val());
			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#sel_brc").val(mySheet.GetCellValue(Row, "brc"));
				$("#sel_brnm").val(mySheet.GetCellValue(Row, "brnm"));
			}
		}
		
		function mySheet_OnSelectCell(OldRow, OldCol, Row, Col,isDelete) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#sel_brc").val(mySheet.GetCellValue(Row, "brc"));
				$("#sel_brnm").val(mySheet.GetCellValue(Row, "brnm"));
			}
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
					$("#sel_brc").val("");
					$("#sel_brnm").val("");
					
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					if(parent.ROLE_ID == undefined || parent.ROLE_ID == null || parent.ROLE_ID != "hcorm"){
						$("form[name=ormsForm] [name=process_id]").val("ORCO010702");
					}else{
						$("form[name=ormsForm] [name=sch_grp_org_c]").val($("#sch_grp_org_c",parent.document).val());
						$("form[name=ormsForm] [name=process_id]").val("ORCO010792");
					}
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					
					//setExcelDownCols("1|2|3|4");
					mySheet.Down2Excel(excel_params);

					break;
				case "filter": //부서 선택
					//mySheet.SetCellValue(mySheet.FindFilterRow(), "brnm","하노이지점");
					if($("#filter_txt").val()==""){
						mySheet.ClearFilterRow()
					}else{
						mySheet.SetFilterValue("brnm", $("#filter_txt").val(), 11);
					}
					break;
				case "select": //부서 선택
				
					if($("#sel_brc").val() == ""){
						alert("부서를 선택해 주십시오.");
						return;
					}
				
					var func = eval("parent.<%=org_rtn_func%>");
					
					func($("#sel_brc").val(), $("#sel_brnm").val());
					
					//parent.func($("#sel_brc").val(), $("#sel_brnm").val());
					
					break;
				case "init": //초기화
					
					$("#sel_brc").val("");
					$("#sel_brnm").val("");
					var func = eval("parent.<%=org_rtn_func%>");
					func($("#sel_brc").val(), $("#sel_brnm").val());
					
					//parent.func($("#sel_brc").val(), $("#sel_brnm").val());
					
					break;
			}
		}
		
		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet.ShowTreeLevel(-1);
				alert("test11");
			}else if(flag == 2){
				mySheet.ShowTreeLevel(0,1);
				alert("test2");
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet.FitColWidth();
				
				if($("#filter_txt").val() == ""){
					mySheet.ShowTreeLevel(1,1);
				}else{
					doAction('filter');
				}
			}
			
			mySheet.SetBlur();
			$("#filter_txt").focus();
			
		}
		
		function mySheet_OnChangeFilter(){
		}
		
		function mySheet_OnFilterEnd(RowCnt, FirstRow) {
			if(RowCnt>100){
				//mySheet.ShowTreeLevel(1,1);
				mySheet.ShowTreeLevel(-1,0);
			}else{				
				mySheet.ShowTreeLevel(-1,0);
			}
			mySheet.SetBlur();
			$("#filter_txt").focus();
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
<body onkeyPress="return EnterkeyPass()">
	<form name="ormsForm" method="post">
	<span id="check_list"></span>
	<input type="hidden" id="sel_brc" name="sel_brc" /> <!-- 선택한 부서 코드 -->
	<input type="hidden" id="sel_brnm" name="sel_brnm" /> <!-- 선택한 부서명 -->
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="rtn_func" name="rtn_func" />
	<input type="hidden" id="mode" name="mode" value="<%=org_mode%>"/>
	<input type="hidden" id="search_txt" name="search_txt" value=""/>
	<input type="hidden" id="sch_grp_org_c" name="sch_grp_org_c" /> <!-- 선택한그룹기관 코드 -->
	
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w500">
			<div class="p_head">
				<h1 class="title">부서 선택</h1>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<td>
												<input type="text" class="form-control w280" id="filter_txt" name="filter_txt" value="<%=org_search_txt%>" placeholder="부서명을 입력하세요" onkeypress="EnterkeySubmit(doAction, 'filter');"/>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="box-footer">
							<button type="button" class="btn btn-primary search auto" onclick="doAction('filter');">조회</button>
						</div>
					</div>
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
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-normal btn-close" onclick="doAction('init');">초기화</button>
					<button type="button" class="btn btn-primary" onclick="doAction('select');">선택</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
	</form>	
	
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				//$("#winBuseo",parent.document).hide();
				$("#winBuseo",parent.document).hide();
				event.preventDefault();
			});
			/*
			//열기
			$(".btn-open").click( function(){
				$(".popup",parent.document).show();
			});
			*/
		});
			
		function closePop(){
			//$("#ifrOrg",parent.document).attr("src","about:blank");
			//$("#winBuseo",parent.document).hide();
			$("#winBuseo",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#sel_brc").val("");
			$("#sel_brnm").val("");
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
