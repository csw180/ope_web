<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0103.jsp
 Program name : 공통 > 사건유형(팝업)
 Description  : 
 Programer    : 권성학
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
			$("#winHpn",parent.document).show();
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
 				{Header:"상위사건유형코드",	Type:"Text",	SaveName:"up_hpn_tpc",		Hidden:true},
 				{Header:"사건유형코드",		Type:"Text",	SaveName:"hpn_tpc",			Hidden:true},
 				{Header:"레벨",			Type:"Text",	SaveName:"level",			Hidden:true},
 				{Header:"사건유형",		Type:"Text",	SaveName:"hpn_tpnm",		TreeCol:1,	Width:440,	MinWidth:150},
 				{Header:"사건유형코드1레벨",	Type:"Text",	SaveName:"hpn_tpc_lv1",		Hidden:true},
 				{Header:"사건유형명1레벨",	Type:"Text",	SaveName:"hpn_tpnm_lv1",	Hidden:true},
 				{Header:"사건유형코드2레벨",	Type:"Text",	SaveName:"hpn_tpc_lv2",		Hidden:true},
 				{Header:"사건유형명2레벨",	Type:"Text",	SaveName:"hpn_tpnm_lv2",	Hidden:true}
			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
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
				
				if(parent.HPN3_ONLY != null && parent.HPN3_ONLY && $("#level").val() != "3" ){
					alert("3레벨을 선택하세요.");
					return;
				}
				
				parent.hpnSearchEnd(
					$("#hpn_tpc").val(), $("#hpn_tpnm").val()
						,$("#hpn_tpc_lv1").val(), $("#hpn_tpnm_lv1").val()
						,$("#hpn_tpc_lv2").val(), $("#hpn_tpnm_lv2").val()
				);
				
			}
		}
		
		function mySheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

			if(NewRow >= mySheet.GetDataFirstRow()){
				$("#level").val(mySheet.GetCellValue(NewRow, "level"));
				$("#hpn_tpc").val(mySheet.GetCellValue(NewRow, "hpn_tpc"));
				$("#hpn_tpnm").val(mySheet.GetCellValue(NewRow, "hpn_tpnm"));
				$("#hpn_tpc_lv1").val(mySheet.GetCellValue(NewRow, "hpn_tpc_lv1"));
				$("#hpn_tpnm_lv1").val(mySheet.GetCellValue(NewRow, "hpn_tpnm_lv1"));
				$("#hpn_tpc_lv2").val(mySheet.GetCellValue(NewRow, "hpn_tpc_lv2"));
				$("#hpn_tpnm_lv2").val(mySheet.GetCellValue(NewRow, "hpn_tpnm_lv2"));
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
					$("#hpn_tpnm").val("");
					$("#hpn_tpc").val("");
					
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					if(parent.ROLE_ID == undefined || parent.ROLE_ID == null || parent.ROLE_ID != "hcorm"){
						$("form[name=ormsForm] [name=process_id]").val("ORCO010302");
					}else{
						$("form[name=ormsForm] [name=sch_grp_org_c]").val($("#sch_grp_org_c",parent.document).val());
						$("form[name=ormsForm] [name=process_id]").val("ORCO010392");
					}
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "select": 
					if($("#hpn_tpc").val() == ""){
						alert("사건유형을 선택해 주십시오.");
						return;
					}
				
					if(parent.HPN3_ONLY != null && parent.HPN3_ONLY && $("#level").val() != "3" ){
						alert("3레벨을 선택하세요.");
						return;
					}
					parent.hpnSearchEnd(
						$("#hpn_tpc").val(), $("#hpn_tpnm").val()
							,$("#hpn_tpc_lv1").val(), $("#hpn_tpnm_lv1").val()
							,$("#hpn_tpc_lv2").val(), $("#hpn_tpnm_lv2").val()
					);
					
					break;
					
				case "init": //초기화
					
					$("#hpn_tpc").val("");
					$("#hpn_tpnm").val("");
					$("#hpn_tpc_lv1").val("");
					$("#hpn_tpnm_lv1").val("");
					$("#hpn_tpc_lv2").val("");
					$("#hpn_tpnm_lv2").val("");
					
					parent.hpnSearchEnd(
						$("#hpn_tpc").val(), $("#hpn_tpnm").val()
							,$("#hpn_tpc_lv1").val(), $("#hpn_tpnm_lv1").val()
							,$("#hpn_tpc_lv2").val(), $("#hpn_tpnm_lv2").val()
					);
					
					break;
			}
		}

		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			cur_click();
			
			mySheet.FitColWidth();
// 			mySheet.ShowTreeLevel(1,1);
		}
		
		function cur_click() {
			
			if(parent.CUR_HPN_TPC!=null && parent.CUR_HPN_TPC!=""){
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j, "hpn_tpc")==parent.CUR_HPN_TPC){
							mySheet.SetSelectRow(j);
							break
						}
					}
				}
				
			}else{
				mySheet.ShowTreeLevel(1,1);
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
<body onkeyPress="return EnterkeyPass()">
	<form name="ormsForm" method="post">
	<span id="check_list"></span>
	<input type="hidden" id="hpn_tpnm" name="hpn_tpnm" /> <!-- 선택한 사건유형명 -->
	<input type="hidden" id="hpn_tpc" name="hpn_tpc" /> <!-- 선택한 사건유형코드 -->
	<input type="hidden" id="level" name="level" /> <!-- 선택한 level -->
	<input type="hidden" id="hpn_tpnm_lv1" name="hpn_tpnm_lv1" /> <!-- 선택한 사건유형명lv1 -->
	<input type="hidden" id="hpn_tpc_lv1" name="hpn_tpc_lv1" /> <!-- 선택한 사건유형코드lv1 -->
	<input type="hidden" id="hpn_tpnm_lv2" name="hpn_tpnm_lv2" /> <!-- 선택한 사건유형명lv2 -->
	<input type="hidden" id="hpn_tpc_lv2" name="hpn_tpc_lv2" /> <!-- 선택한 사건유형코드lv2 -->
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="rtn_hpn_c" name="rtn_hpn_c" />
	<input type="hidden" id="rtn_hpn_nm" name="rtn_hpn_nm" />
	<input type="hidden" id="rtn_func" name="rtn_func" />
	<input type="hidden" id="sch_grp_org_c" name="sch_grp_org_c" /> <!-- 선택한그룹기관 코드 -->
	
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w500">
			<div class="p_head">
				<h1 class="title">사건유형 선택</h1>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<section class="box box-grid">
						<div class="box-header">
							<div class="area-tool">
								<div class="grid-tree-btn">
								    <button type="button" class="btn btn-xs" title="모두 펼치기" onClick="mySheet_showAllTree('1');"><i class="fa fa-plus-circle"></i></button>
									<button type="button" class="btn btn-xs" title="모두 접기" onClick="mySheet_showAllTree('2');"><i class="fa fa-minus-circle"></i></button>
								</div>
							</div>
						</div>
						<div class="wrap-grid h450">
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
			$(".btn-close").click( function(event){
				$("#winHpn",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winHpn",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#hpn_tpc").val("");
			$("#hpn_tpnm").val("");
			closePop();
		});
	</script>	
</body>
</html>
