<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0117.jsp
 Program name : ADMIN > 사용자/권한관리 > 메뉴권한관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.03
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
			initIBSheet1();
			createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
			//initIBSheet2();
			//initIBSheet3();
		});

		$(document).ready(function(){
			initIBSheet2();
			createIBSheet2(document.getElementById("mydiv3"),"mySheet3", "100%", "100%");
		});

		$(document).ready(function(){
			initIBSheet3();
		});
		
		/*Sheet1(권한) 기본 설정 */
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, DeferredVScroll:1, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
				{Header:"상태",		Type:"Status",		SaveName:"status",			Align:"Center",	Width:50,		MinWidth:20									},
				{Header:"삭제",		Type:"DelCheck",	SaveName:"del_check",		Align:"Center", Width:50,		MinWidth:20									},
 				{Header:"권한ID",		Type:"Text",		SaveName:"auth_grp_id",		Align:"Center",	Edit:0,			Width:80,	MinWidth:20						},
 				{Header:"권한",		Type:"Text",		SaveName:"auth_grpnm",		Align:"Left",	EditLen:50,		Width:350,	MinWidth:20						},
 				{Header:"권한설명",	Type:"Text",		SaveName:"auth_grp_expl",	Align:"Left",	EditLen:100,	Width:400,	MinWidth:20						},
 				{Header:"권한코드",	Type:"Text",		SaveName:"auth_c",			Align:"Left",	EditLen:1,		Width:50,	MinWidth:20,	Hidden:1		}
 			];
			IBS_InitSheet(mySheet1,initData);
			
			//mySheet1.SetEditable(0); //수정불가
			mySheet1.SetFocusAfterProcess(0);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet1.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet1.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			doAction('authSearch');
			
		}
		
		/*Sheet2(메뉴) 기본 설정 */
		function initIBSheet2() {
			mySheet2.Reset();
			
			var initData = {};
			
			initData.HeaderMode = {Sort:0};
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0, ChildPage:5, DeferredVScroll:1, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"메뉴ID",		Type:"Text",	SaveName:"menu_id",	Align:"Center",	Width:80,	MinWidth:20},
 				{Header:"메뉴명",		Type:"Text",	SaveName:"mnnm",	Align:"Left",	Width:420,	MinWidth:100,	TreeCol:1}
 			];
			IBS_InitSheet(mySheet2,initData);
			
			mySheet2.SetEditable(0); //수정불가
			mySheet2.FitColWidth();
			mySheet2.SetFocusAfterProcess(0);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet2.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet2.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet2);
			
			doAction('menuSearch');
			
		}
		
		/*Sheet3(권한별메뉴) 기본 설정 */
		function initIBSheet3() {
			mySheet3.Reset();
			
			var initData = {};
			
			initData.HeaderMode = {Sort:0};
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0, ChildPage:5, DeferredVScroll:1, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
				{Header:"메뉴ID",		Type:"Text",	SaveName:"menu_id",	Align:"Center",	Width:80,	MinWidth:20},
 				{Header:"메뉴명",		Type:"Text",	SaveName:"mnnm",	Align:"Left",	Width:420,	MinWidth:100,	TreeCol:1}
 			];
			IBS_InitSheet(mySheet3,initData);
			
			mySheet3.SetEditable(0); //수정불가
			mySheet3.FitColWidth();
			mySheet3.SetFocusAfterProcess(0);
			
			//필터표시
			//mySheet3.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet3.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet3.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet3.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet3);
			
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		//function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		function mySheet1_OnSelectCell(OldRow, OldCol, Row, Col,isDelete) {
			//if(Row >= mySheet1.GetDataFirstRow() && Col != 1){
			if(Row >= mySheet1.GetDataFirstRow()){
				
				if($("#sel_auth_grp_id").val() == mySheet1.GetCellValue(Row, "auth_grp_id")){
					return;
				}
				
				$("#sel_auth_grp_id").val(mySheet1.GetCellValue(Row, "auth_grp_id"));
				
				mySheet3.Reset();
				var initData = {};
				
				initData.HeaderMode = {Sort:0};
				initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0, ChildPage:5, DeferredVScroll:1, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
				initData.Cols = [
					{Header:"메뉴ID",	Type:"Text", SaveName:"menu_id",	Align:"Center", Width:80, MinWidth:20},
					{Header:"메뉴명",	Type:"Text", SaveName:"mnnm",		Align:"Left",	Width:420, MinWidth:100, TreeCol:1}
				];
				IBS_InitSheet(mySheet3,initData);
				
				mySheet3.SetEditable(0); //수정불가
				mySheet3.SetSelectionMode(4);
				mySheet3.FitColWidth();
				
				$("#auth_title").text("("+mySheet1.GetCellValue(Row, "auth_grpnm")+")");
				
				doAction("authMenuSearch");
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
					if(mySheet1.GetCellValue(i, "del_check")=="1"){
						mySheet1.SetCellFontColor(i, "auth_grpnm", "#FF0000");
						//mySheet1.SetCellBackColor(i, "auth_grpnm", "#E2E2E2");
						mySheet1.SetCellFontColor(i, "auth_grp_expl", "#FF0000");
						//mySheet1.SetCellBackColor(i, "auth_grp_expl", "#E2E2E2");
					}
				}
			}
			
			mySheet1.FitColWidth();
		}
		
		function mySheet1_OnSaveEnd(code, msg) {
			doAction("authSearch"); 
			if(code >= 0) {
		        doAction("authSearch"); 
		        initIBSheet3();
		        $("#sel_auth_grp_id").val("");
		    } else {
		    }
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
			
		}
		
		function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			mySheet2.FitColWidth();
		}
		
		function mySheet2_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		        doAction("empSearch");      
		    	alert("저장되었습니다");
		    } else {
		    }
		}
		
		function mySheet3_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
			mySheet3.FitColWidth();
		}
		
		function mySheet3_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		        doAction("empSearch");      
		    	alert("저장되었습니다.");
		    } else {
		    }
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "authSearch":  //권한 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011702");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "menuSearch":  //메뉴 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011704");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
					
				case "insert":  //신규행 추가
					var srow = mySheet1.GetSelectRow();
					
					mySheet1.DataInsert(0); 
					mySheet1.FitColWidth();
					break; 
					
				case "authMenuSearch":  //권한별메뉴조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011705");
					
					mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
					
				case "saveAuth":      //저장할 데이터 추출
				
					var sRow = mySheet1.FindStatusRow("U|I|D");
					var arrow = sRow.split(";");
					
					if(arrow == ""){
						alert("저장할 내역이 없습니다.");
						return;
					}
					
					for(var i=0; i<=arrow.length; i++){
						if((mySheet1.GetCellValue(arrow[i],"auth_grpnm") == "") && (mySheet1.GetCellValue(arrow[i],"status") != "D")){
							alert("권한을 입력해 주십시오.");
							mySheet1.SelectCell(arrow[i],"auth_grpnm","1");
							return;
						}
					}
					mySheet1.DoSave(url + "?method=Main&commkind=adm&process_id=ORAD011703");
					break;
					
				case "saveMenuAuth":      //저장할 데이터 추출
				
					if($("#sel_auth_grp_id").val() == ""){
						alert("권한을 선택해 주십시오.");
						return;
					}
				
					if(!confirm("저장하시겠습니까?")) return;
				
					var cnt = mySheet3.GetDataFirstRow();
					
					if(cnt != -1){
				
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD011706");
						
						mySheet3.DoAllSave(url, FormQueryStringEnc(document.ormsForm));
					}else{
						var f = document.ormsForm;

						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "adm");
						WP.setParameter("process_id", "ORAD011707");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						//alert(inputData);
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
							{
								success: function(result){
									if(result!='undefined' && result.rtnCode=="S") {
										alert("저장되었습니다.");
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
									alert(JSON.stringify(rtnMsg));
								}
						});
					}
					
					break;
			}
		}
		
		function copyObjCall(){
			
			var row = mySheet1.GetSelectRow();
			
			if(row <= 0 ){
				alert("상단 목록에서 권한을 선택하고 메뉴를 추가해 주십시오.");
				return;
			}
			
			if($("#sel_auth_grp_id").val() == ""){
				alert("권한을 저장한 후에 메뉴를 추가해 주십시오.");
				return;
			}
			
			var srow = mySheet2.GetSelectRow();
			
			if(srow < 0){
				alert("전체메뉴 목록에서 추가할 메뉴를 선택해 주십시오.");
				return;
			}
			
			showLoadingWs(); // 프로그래스바 활성화
			setTimeout(copyObj,100);
		}
		
		function copyObj(){
			
			var i=0;
			
			var srow = mySheet2.GetSelectRow();
			var tmpRows = mySheet2.GetChildRows(srow);
			
			var childRows = [];
			if( tmpRows != ""){
				childRows = tmpRows.split("|");
			}
			
			var parentRows = [];
			var row = mySheet2.GetParentRow(srow);
			for(i=0; i<10; i++){
				if(row < 0){
					break;	
				}else{
					parentRows.push(row);
				}
				row = mySheet2.GetParentRow(row);
			}
			
			var mnu_id = "", tgt_mnu_id = "";
			var trow = -1;
			
			//상위 메뉴 존재 체크 없으면 추가
			for(i=parentRows.length-1; i>=0; i--){
				
				//소스트리에서 상위메뉴id 취득
				mnu_id = mySheet2.GetCellValue(parentRows[i],"menu_id");
				
				//대상트리에서 추가하려는 메뉴의 상위메뉴가 존재하는지 확인
				var prow = getTgtExistRow(mnu_id);
				
				//상위메뉴 추가
				if(prow < 0){
					trow = mySheet3.DataInsert(trow+1, mySheet3.GetRowLevel(trow)+1 ); 
					mySheet3.SetCellValue(trow,"menu_id", mySheet2.GetCellValue(parentRows[i],"menu_id"));
					mySheet3.SetCellValue(trow,"mnnm", mySheet2.GetCellValue(parentRows[i],"mnnm"));
				}else{
					trow = prow;
				}
			}
			
			var tgt_row = getTgtExistRow(mySheet2.GetCellValue(srow,"menu_id"));
			
			if( tgt_row < 0){
			//선책한 메뉴 추가
				trow = mySheet3.DataInsert(trow+1, mySheet3.GetRowLevel(trow)+1 ); 
				mySheet3.SetCellValue(trow,"menu_id", mySheet2.GetCellValue(srow,"menu_id"));
				mySheet3.SetCellValue(trow,"mnnm", mySheet2.GetCellValue(srow,"mnnm"));
			}else{
				trow = tgt_row;
			}
			
			//하위 메뉴 추가
			for(i=0; i<childRows.length; i++){
				tgt_row = getTgtExistRow(mySheet2.GetCellValue(childRows[i],"menu_id"));
				if( tgt_row < 0){
					trow = mySheet3.DataInsert(trow+1, mySheet2.GetRowLevel(childRows[i]) ); 
					mySheet3.SetCellValue(trow,"menu_id", mySheet2.GetCellValue(childRows[i],"menu_id"));
					mySheet3.SetCellValue(trow,"mnnm", mySheet2.GetCellValue(childRows[i],"mnnm"));
				}else{
					trow = tgt_row;
				}
			}
			
			removeLoadingWs();
			mySheet3.FitColWidth();
		}
		
		// 소스의 메뉴가 대상tree에 존재하는지 체크 
		// 있으면 대상tree의 row, 없으면 -1 반환
		function getTgtExistRow(mnu_id){
			var row = -1;
			var tgt_mnu_id = "";
			for(var j=mySheet3.GetDataFirstRow(); j<=mySheet3.GetDataLastRow(); j++){
				tgt_mnu_id = mySheet3.GetCellValue(j,"menu_id");
				if(mnu_id==tgt_mnu_id){
					row = j;
					break;
				}
			}
			return row;
		}
		
		function removeObj(){

			var i=0;
			
			var srow = mySheet3.GetSelectRow();
			if(srow < 0){
				alert("삭제할 메뉴를 선택해 주십시오.");
				return;
			}
			var tmpRows = mySheet3.GetChildRows(srow);
			var childRows = tmpRows.split("|");
			
			//하위 메뉴 삭제
			mySheet3.RowDelete(tmpRows);
			mySheet3.RowDelete(srow);
			
			mySheet3.FitColWidth();
			
		}
		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet2.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet2.ShowTreeLevel(0,1);
			}
		}

	</script>
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<!-- content -->
		<div class="content">
			<form name="ormsForm" method="post">
                <input type="hidden" id="sel_auth_grp_id" name="sel_auth_grp_id" /> <!-- 선택한 권한ID -->
                <input type="hidden" id="path" name="path" />
                <input type="hidden" id="process_id" name="process_id" />
                <input type="hidden" id="commkind" name="commkind" />
                <input type="hidden" id="method" name="method" />
                <input type="hidden" id="sch_del_check" name="sch_del_check" />

				<div class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">권한</h2>		
						<div class="area-tool">
							<div class="btn-group">
								<button class="btn btn-default btn-xs" type="button" onclick="javascript:doAction('insert')"><i class="fa fa-plus"></i><span class="txt">권한추가</span></button>
								<button class="btn btn-default btn-xs" type="button" onclick="javascript:doAction('saveAuth')"><i class="fa fa-save"></i><span class="txt">권한저장</span></button>
							</div>
						</div>	
					</div>
					<div class="box-body">
						<div class="wrap-grid h250">
							<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
						</div>
					</div>
				</div>
	
	
				<div class="box box-grid">				
					<div class="box-header">
						<h2 class="box-title">권한별 메뉴 설정</h2>
					</div>
	
					<div class="row">
						<div class="col col-xs-6">
							<div class="box-grid">
								<div class="box-header">
									<h3 class="title">전체메뉴</h3>
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
								<!-- /.box-header -->
								<div class="box-body">
									<div id="mydiv2" class="wrap h250">
										<!-- <script> createIBSheet("mySheet2", "100%", "100%"); </script> -->
									</div>
								</div>
								<!-- /.box-body -->
							</div>	
						</div>
	
						<div class="col col-btn">
							<button type="button" class="btn btn-normal btn-sm" onclick="javascript:copyObjCall();"><span class="txt">추가</span><i class="fa fa-angle-right"></i></button>
							<button type="button" class="btn btn-normal btn-sm" onclick="javascript:removeObj();"><i class="fa fa-angle-left"></i><span class="txt">삭제</span></button>
						</div>
	
						<div class="col col-xs-6">
							<div class="box-grid">
								<div class="box-header">
									<h3 class="title">권한별 할당된 메뉴<span id="auth_title"></span></h3>
								</div><br>
								<div class="box-body">
									<div id="mydiv3" class="wrap-grid h250">
										<!-- <script> createIBSheet("mySheet3", "100%", "100%"); </script> -->
									</div>
								</div>
								<div class="box-footer">
									<div class="btn-wrap">
										<button type="button" class="btn btn-primary btn-sm" onclick="javascript:doAction('saveMenuAuth');">저장</button>
									</div>
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