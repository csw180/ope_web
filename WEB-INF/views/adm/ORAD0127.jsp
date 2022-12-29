<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0127.jsp
 Program name : ADMIN > 코드관리 > 부서코드관리 > 부서업로드(팝업)
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.14
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script language="javascript">
		
		$(document).ready(function(){
			$("#winBrUpload",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"부서코드",					Type:"Text",	SaveName:"brc",				Width:100,	Align:"Center"},
 				{Header:"부서명",						Type:"Text",	SaveName:"brnm",			Width:150,	Align:"Left"},
 				{Header:"상위부서코드",					Type:"Text",	SaveName:"up_brc",			Width:100,	Align:"Center"},
 				{Header:"운영리스크\n사용부서여부\n(Y/N)",	Type:"Text",	SaveName:"oprk_uyn",		Width:80,	Align:"Center"},
 				{Header:"운영리스크\n관리부서여부\n(Y/N)",	Type:"Text",	SaveName:"oprk_adm_yn",		Width:80,	Align:"Center"},
 				{Header:"BCP\n관리부서여부\n(Y/N)",		Type:"Text",	SaveName:"bcp_adm_yn",		Width:80,	Align:"Center"},
 				{Header:"업로드 결과",					Type:"Text",	SaveName:"upload_result",	Width:200,	Align:"Left"},
 				{Header:"본부영업점구분코드",				Type:"Text",	SaveName:"hofc_bizo_dsc",	Hidden:1},
 				{Header:"err",						Type:"Text",	SaveName:"err",				Hidden:1}
 			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			mySheet.SetActionMenu("엑셀다운로드|엑셀업로드");
			
			mySheet.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			mySheet.DataInsert(0); 
			mySheet.SetCellValue(1,"brc","0000");
			mySheet.SetCellValue(1,"brnm","<%=grp_orgnm%>");
			mySheet.SetCellValue(1,"oprk_adm_yn","Y");
			mySheet.SetCellValue(1,"bcp_adm_yn","Y");
			mySheet.SetCellValue(1,"hofc_bizo_dsc","01");
			
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
			
				case "down2excel":
					var params = { FileName : "부서엑셀업로드.xlsx",  SheetName : "Sheet1", DownCols:"0|1|2|3|4|5"} ;
	
					mySheet.Down2Excel(params);
	
					break;
				case "loadexcel":
	
					mySheet.LoadExcel({FileExt:"xlsx"});
	
					break;
			}
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 

		}
		
		function mySheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

		}
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction("loadexcel");
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			mySheet.FitColWidth();
			
		}
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장되었습니다.");  // 저장 성공 메시지
		        parent.doAction("search");
		        $("#winBrUpload",parent.document).hide();
		        
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}
		
		var ormcnt = 0; //운영리스크관리부서 수
		var bcpcnt = 0; //BCP관리부서 수
		
		function save(){
			if(mySheet.RowCount() < 1){
				alert("저장할 내역이 없습니다.");
				return;
			}
			
			for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
				if(mySheet.GetCellValue(i,"err") != ""){
					alert("업로드 결과를 확인해서 수정 후 다시 저장해 주시기 바랍니다.");
					return;
				}
				
				if(ormcnt < 1 || ormcnt > 1){
					alert("운영리스크 관리부서를 1개 등록해 주시기 바랍니다.");
					return;
				}
				
				if(bcpcnt < 1 || bcpcnt > 1){
					alert("BCP 관리부서를 1개 등록해 주시기 바랍니다.");
					return;
				}
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("adm");
			$("form[name=ormsForm] [name=process_id]").val("ORAD012701");
			
			mySheet.DoAllSave(url, FormQueryStringEnc(document.ormsForm));
		}
		
		function mySheet_OnLoadExcel(result, code, msg) {
			
			ormcnt = 0;
			bcpcnt = 0;
			
			for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
				
				if(mySheet.GetCellValue(i,"up_brc") == ""){
					mySheet.SetCellValue(i,"hofc_bizo_dsc", "01");
				}else{
					mySheet.SetCellValue(i,"hofc_bizo_dsc", "02");
				}
				
				if(mySheet.GetCellValue(i,"up_brc") != ""){
					var isupbrc = false; //상위부서코드존재여부
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if((i != j) && (mySheet.GetCellValue(i,"up_brc") == mySheet.GetCellValue(j,"brc"))){
							isupbrc = true;
						}
					}
					if(!isupbrc) {
						mySheet.SetCellValue(i,"upload_result","상위부서코드 미존재");
						mySheet.SetCellValue(i,"err","Y");
					}
				}
				
				if(mySheet.GetCellValue(i,"oprk_adm_yn") == "Y"){
					ormcnt = ormcnt + 1;
				}
				
				if(mySheet.GetCellValue(i,"bcp_adm_yn") == "Y"){
					bcpcnt = bcpcnt + 1;
				}
				
				if(mySheet.GetCellValue(i,"oprk_uyn") == ""){
					mySheet.SetCellValue(i,"oprk_uyn","N");
				}
				if(mySheet.GetCellValue(i,"oprk_adm_yn") == ""){
					mySheet.SetCellValue(i,"oprk_adm_yn","N");
				}
				if(mySheet.GetCellValue(i,"bcp_adm_yn") == ""){
					mySheet.SetCellValue(i,"bcp_adm_yn","N");
				}
				
				if((mySheet.GetCellValue(i,"oprk_uyn") != "Y") && (mySheet.GetCellValue(i,"oprk_uyn") != "N")){
					mySheet.SetCellValue(i,"oprk_uyn","운영리스크사용부서여부 Y/N으로 입력 필요");
					mySheet.SetCellValue(i,"err","Y");
				}
				
				if((mySheet.GetCellValue(i,"oprk_adm_yn") != "Y") && (mySheet.GetCellValue(i,"oprk_adm_yn") != "N")){
					mySheet.SetCellValue(i,"oprk_adm_yn","운영리스크관리부서여부 Y/N으로 입력 필요");
					mySheet.SetCellValue(i,"err","Y");
				}
				
				if((mySheet.GetCellValue(i,"bcp_adm_yn") != "Y") && (mySheet.GetCellValue(i,"bcp_adm_yn") != "N")){
					mySheet.SetCellValue(i,"bcp_adm_yn","BCP관리부서여부 Y/N으로 입력 필요");
					mySheet.SetCellValue(i,"err","Y");
				}
			}
		}
	</script>

</head>
<body onkeyPress="return EnterkeyPass()";  style="background-color:transparent">
	<form name="ormsForm" method="post">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	
	<!-- popup -->
	<!-- 팝업 -->
	<div id="" class="popup modal block">
		<div class="p_frame w900">
			<div class="p_head">
				<h3 class="title">부서 업로드</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-grid">
						<div class="box-header">
							<div class="area-tool">
							<span class="cr">※ 암호화 해제된 파일을 올려주시기 바랍니다. </span>
								<button type="button" class="btn btn-default btn-xs" onclick="doAction('loadexcel')"><i class="ico xls"></i>엑셀업로드</button>
								<button type="button" class="btn btn-default btn-xs" onclick="doAction('down2excel')"><i class="ico xls"></i>엑셀다운로드</button>
							</div>
						</div>
						<div class="box-body">
							<div class="wrap-grid h400">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap center">
					<button type="button" class="btn btn-primary" onclick="save()">저장</button>
					<button type="button" class="btn btn-default btn-close" onclick="closePop()">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<!-- popup //-->
	</form>	
	
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				$("#winBrUpload",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winBrUpload",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			closePop();
		});
	</script>	
</body>
</html>
