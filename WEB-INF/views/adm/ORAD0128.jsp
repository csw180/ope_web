<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0128.jsp
 Program name : ADMIN > 사용자/권한관리 > 사용자조회 > 사용자업로드(팝업)
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.21
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
			$("#winUserUpload",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:1, DeferredVScroll:1, MergeSheet:msHeaderOnly};
			initData.Cols = [
 				{Header:"부서코드",			Type:"Text",	SaveName:"brc",				Width:100,	Align:"Center"},
 				{Header:"부서",				Type:"Text",	SaveName:"brnm",			Width:200,	Align:"Center"},
 				{Header:"직급",				Type:"Text",	SaveName:"pzcnm",			Width:120,	Align:"Center"},
 				{Header:"직원번호",			Type:"Text",	SaveName:"eno",				Width:100,	Align:"Center"},
 				{Header:"성명",				Type:"Text",	SaveName:"enm",				Width:100,	Align:"Center"},
 				{Header:"전화번호",			Type:"Text",	SaveName:"tel_no",			Width:100,	Align:"Center"},
<%if("00".equals(grp_org_c)){%>
 				{Header:"그룹ORM전담\n(Y/N)",			Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_011"},
 				{Header:"그룹ORM팀장\n(Y/N)",			Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_012"},
<%}%>
 				{Header:"ORM전담\n(Y/N)",			Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_002"},
 				{Header:"ORM팀장\n(Y/N)",			Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_010"},
 				{Header:"부서ORM\n업무담당자\n(Y/N)",	Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_003"},
 				{Header:"부서장\n(Y/N)",				Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_006"},
 				{Header:"BCP전담\n(Y/N)",			Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_005"},
 				{Header:"BCP팀장\n(Y/N)",			Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_013"},
 				{Header:"부서BCP\n업무담당자\n(Y/N)",	Type:"Text",	Width:80,	Align:"Center",	SaveName:"auth_014"},
 				{Header:"업로드 결과",		Type:"Text",	SaveName:"upload_result",	Width:200,	Align:"Left"},
 				{Header:"err",				Type:"Text",	SaveName:"err_yn",				Hidden:1}
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
			
			//TODO : 샘플데이터 입력 (삭제해야됨)
			mySheet.DataInsert(0); 
			mySheet.SetCellValue(1,"eno","99990000");
			mySheet.SetCellValue(1,"enm","홍길동");
			mySheet.SetCellValue(1,"brc","007607");
			mySheet.SetCellValue(1,"brnm","IT리스크관리팀");
			mySheet.SetCellValue(1,"tel_no","02-1234-5678");
			mySheet.SetCellValue(1,"pzcnm","대리");
			
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
			
				case "down2excel":
					<%if("01".equals(grp_org_c)){%>
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "사용자엑셀업로드.xlsx",  SheetName : "Sheet1", DownCols:"0|1|2|3|4|5|6|7|8|9|10|11|12|13|14"};
					<%}else{%>
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "사용자엑셀업로드.xlsx",  SheetName : "Sheet1", DownCols:"0|1|2|3|4|5|8|9|10|11|12|13|14"};
					<%}%>
					
	
					mySheet.Down2Excel(params);
					mySheet.RemoveAll();
	
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
			//mySheet.FitColWidth();
			
		}
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장되었습니다.");  // 저장 성공 메시지
		        parent.doAction("search");
		        $("#winUserUpload",parent.document).hide();
		        
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
				if(mySheet.GetCellValue(i,"err_yn") != ""){
					alert("업로드 결과를 확인해서 수정 후 다시 저장해 주시기 바랍니다.");
					return;
				}
				
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("adm");
			$("form[name=ormsForm] [name=process_id]").val("ORAD012803");
			
			mySheet.DoAllSave(url, FormQueryStringEnc(document.ormsForm));
		}
		
		function mySheet_OnLoadExcel(result, code, msg) {
			
			var f = document.ormsForm;
			
			var grid_html = "";
			if(mySheet.GetDataFirstRow()>=0){
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					grid_html += "<input type='hidden' name='brc' value='" + mySheet.GetCellValue(j,"brc") + "'>";
					grid_html += "<input type='hidden' name='brnm' value='" + mySheet.GetCellValue(j,"brnm") + "'>";
					grid_html += "<input type='hidden' name='pzcnm' value='" + mySheet.GetCellValue(j,"pzcnm") + "'>";
					grid_html += "<input type='hidden' name='eno' value='" + mySheet.GetCellValue(j,"eno") + "'>";
					grid_html += "<input type='hidden' name='enm' value='" + mySheet.GetCellValue(j,"enm") + "'>";
					grid_html += "<input type='hidden' name='tel_no' value='" + mySheet.GetCellValue(j,"tel_no") + "'>";
					grid_html += "<input type='hidden' name='auth_011' value='" + mySheet.GetCellValue(j,"auth_011") + "'>";
					grid_html += "<input type='hidden' name='auth_012' value='" + mySheet.GetCellValue(j,"auth_012") + "'>";
					grid_html += "<input type='hidden' name='auth_002' value='" + mySheet.GetCellValue(j,"auth_002") + "'>";
					grid_html += "<input type='hidden' name='auth_010' value='" + mySheet.GetCellValue(j,"auth_010") + "'>";
					grid_html += "<input type='hidden' name='auth_003' value='" + mySheet.GetCellValue(j,"auth_003") + "'>";
					grid_html += "<input type='hidden' name='auth_006' value='" + mySheet.GetCellValue(j,"auth_006") + "'>";
					grid_html += "<input type='hidden' name='auth_005' value='" + mySheet.GetCellValue(j,"auth_005") + "'>";
					grid_html += "<input type='hidden' name='auth_013' value='" + mySheet.GetCellValue(j,"auth_013") + "'>";
					grid_html += "<input type='hidden' name='auth_014' value='" + mySheet.GetCellValue(j,"auth_014") + "'>";
				}
			}
			grid_area.innerHTML = grid_html;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "adm");
			WP.setParameter("process_id", "ORAD012801");
			WP.setForm(f);
			
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							getImsiEmpInfo();
						}else if(result!='undefined'){
							alert("임시 저장 오류");
							removeLoadingWs();
						}  
					},
				  
					complete: function(statusText,status){
						
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
			
		}
		
		function getImsiEmpInfo() {
			
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "adm");
			WP.setParameter("process_id", "ORAD012802");
			WP.setForm(f);
			
			var inputData = WP.getParams();
			
			//alert(inputData);
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="0") {
							mySheet.RemoveAll();
							mySheet.LoadSearchData("{DATA:["+JSON.stringify(result.DATA)+"]}");
						}else if(result!='undefined'){
							alert("결과 조회 오류");
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
	</script>

</head>
<body onkeyPress="return EnterkeyPass()"; style="background-color:transparent">
	<form name="ormsForm" method="post">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<div id="grid_area"></div>
	
	<!-- popup -->
	<!-- 팝업 -->
	<div id="" class="popup modal block">
		<div class="p_frame w1100">
			<div class="p_head">
				<h3 class="title">사용자 업로드</h3>
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
				$("#winUserUpload",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winUserUpload",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			closePop();
		});
	</script>	
</body>
</html>
