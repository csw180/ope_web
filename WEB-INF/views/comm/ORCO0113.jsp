<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0113.jsp
 Program name : 공통 > 팀 유형(팝업)
 Description  : 
 Programmer    : 권성학
 Date created : 2021.05.04
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
			$("#winTeam",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": sizeNoHScroll, "MouseHoverMode": 0, "DragMode":1};
			initData.Cols = [
 				{Header:"상위팀코드",				Type:"Text",	SaveName:"up_idvdc_val",		Hidden:true},
 				{Header:"팀코드",					Type:"Text",	SaveName:"idvdc_val",		Hidden:true},
 				{Header:"레벨",					Type:"Text",	SaveName:"level",			Hidden:true},
 				{Header:"팀명",					Type:"Text",	SaveName:"intg_idvd_cnm",		TreeCol:1,	Width:440,	MinWidth:150},
 				{Header:"팀코드1레벨",				Type:"Text",	SaveName:"idvdc_val_lv1",	Hidden:true},
 				{Header:"팀명1레벨",				Type:"Text",	SaveName:"intg_idvd_cnm_lv1",	Hidden:true},
			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			
			//필터표시
			mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(0);
			
			mySheet.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search');
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				
				/* if(parent.TEAM_ONLY != null && parent.TEAM_ONLY && $("#level").val() != "2" ){
					alert("2레벨을 선택하세요.");
					return;
				} */
				
				parent.teamSearchEnd(
					$("#idvdc_val").val(), $("#intg_idvd_cnm").val()
						,$("#idvdc_val_lv1").val(), $("#intg_idvd_cnm_lv1").val()
				);
				
			}
		}
		
		function mySheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

			if(NewRow >= mySheet.GetDataFirstRow()){
				$("#level").val(mySheet.GetCellValue(NewRow, "level"));
				$("#idvdc_val").val(mySheet.GetCellValue(NewRow, "idvdc_val"));
				$("#intg_idvd_cnm").val(mySheet.GetCellValue(NewRow, "intg_idvd_cnm"));
				$("#idvdc_val_lv1").val(mySheet.GetCellValue(NewRow, "idvdc_val_lv1"));
				$("#intg_idvd_cnm_lv1").val(mySheet.GetCellValue(NewRow, "intg_idvd_cnm_lv1"));
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
					$("#intg_idvd_cnm").val("");
					$("#idvdc_val").val("");
					
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					$("form[name=ormsForm] [name=process_id]").val("ORCO011302");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "select": 
					if($("#idvdc_val").val() == ""){
						alert("팀을 선택해 주십시오.");
						return;
					}
				
					/* if(parent.TEAM_ONLY != null && parent.TEAM_ONLY && $("#level").val() != "2" ){
						alert("2레벨을 선택하세요.");
						return;
					} */
					parent.teamSearchEnd(
						$("#idvdc_val").val(), $("#intg_idvd_cnm").val()
							,$("#idvdc_val_lv1").val(), $("#intg_idvd_cnm_lv1").val()
					);
					
					break;
				case "filter": //팀 선택
					//mySheet.SetCellValue(mySheet.FindFilterRow(), "brnm","하노이지점");
					if($("#filter_txt").val()==""){
						mySheet.ClearFilterRow()
					}else{
						mySheet.SetFilterValue("intg_idvd_cnm", $("#filter_txt").val(), 11);
					}
					break;
				case "init": //초기화
					
					$("#idvdc_val").val("");
					$("#intg_idvd_cnm").val("");
					$("#idvdc_val_lv1").val("");
					$("#intg_idvd_cnm_lv1").val("");
					
					parent.teamSearchEnd(
						$("#idvdc_val").val(), $("#intg_idvd_cnm").val()
							,$("#idvdc_val_lv1").val(), $("#intg_idvd_cnm_lv1").val()
					);
					
					break;
			}
		}

		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				doAction('filter');
			}
			cur_click();
			//$("#search_txt").trigger("focus");
			
			mySheet.FitColWidth();
// 			mySheet.ShowTreeLevel(1,1);
		}
		
		function cur_click() {
			
			if(parent.CUR_TEAM_TPC!=null && parent.CUR_TEAM_TPC!=""){
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j, "idvdc_val")==parent.CUR_TEAM_TPC){
							mySheet.SetSelectRow(j);
							break
						}
					}
				}
				
			}else{
				mySheet.ShowTreeLevel(1,1);
			}
		}
/* 		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('filter');
				return true;
			}else{
				return true;
			}
		} */
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
	<input type="hidden" id="intg_idvd_cnm" name="intg_idvd_cnm" /> <!-- 선택한 이머징리스크유형명 -->
	<input type="hidden" id="idvdc_val" name="idvdc_val" /> <!-- 선택한 이머징리스크유형코드 -->
	<input type="hidden" id="level" name="level" /> <!-- 선택한 level -->
	<input type="hidden" id="intg_idvd_cnm_lv1" name="intg_idvd_cnm_lv1" /> <!-- 선택한 이머징리스크유형명lv1 -->
	<input type="hidden" id="idvdc_val_lv1" name="idvdc_val_lv1" /> <!-- 선택한 이머징리스크유형코드lv1 -->
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="rtn_emrk_c" name="rtn_emrk_c" />
	<input type="hidden" id="rtn_emrk_nm" name="rtn_emrk_nm" />
	<input type="hidden" id="rtn_func" name="rtn_func" />
	
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w500">
			<div class="p_head">
				<h1 class="title">팀 선택</h1>
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
												<input type="text" class="form-control w280" id="filter_txt" name="filter_txt" value="" placeholder="팀명을 입력하세요" onkeypress="EnterkeySubmit(doAction, 'filter');"/>
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
							<script> createIBSheet("mySheet", "100%", "100%"); </script>
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
			$(".btn-close").click( function(event){
				$("#winTeam",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winTeam",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#idvdc_val").val("");
			$("#intg_idvd_cnm").val("");
			closePop();
		});
	</script>	
</body>
</html>
