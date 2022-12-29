<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0116.jsp
 Program name : ADMIN > 사용자/권한관리 > 권한일괄등록
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.28
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	String orm_brc = "", bcp_brc = "", chk_yn = "";
	Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList"); //운영리스크관리부서
	for(int i=0; i<vLst.size(); i++){
		HashMap hMap = (HashMap)vLst.get(0);
		orm_brc = (String)hMap.get("intgc");
	}
	
	Vector vLst2 = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList"); //BCP관리부서
	for(int i=0; i<vLst.size(); i++){
		HashMap hMap = (HashMap)vLst2.get(0);
		bcp_brc = (String)hMap.get("intgc");
	}
	Vector vLst3 = CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
	for(int i=0; i<vLst.size(); i++){
		HashMap hMap = (HashMap)vLst3.get(0);
		chk_yn = (String)hMap.get("chk_yn");
	}
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet();
			createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");			
		});
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet2();
		});
		
		/*Sheet1 기본 설정 */
		function initIBSheet() {
			mySheet.Reset();
			
			var initData = {};
			//sizeNoHScroll
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, Sort:1,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"상위부서코드",		Type:"Text",	SaveName:"up_brc",		Hidden:true},
 				{Header:"부서코드",		Type:"Text",	SaveName:"brc",			Hidden:true},
 				{Header:"레벨",			Type:"Text",	SaveName:"level",		Hidden:true},
 				{Header:"조직도",			Type:"Text",	SaveName:"brnm",		TreeCol:1,	Width:580,	MinWidth:90}
 			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			mySheet.SetFocusAfterProcess(0);
			
			
			//필터표시
			mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('orgSearch');
		}
		/*Sheet2 기본 설정 */
		function initIBSheet2() {
			mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:3,MergeSheet:msHeaderOnly,HeaderCheck:0 }; //좌측에 고정 컬럼의 수
			initData.Cols = [
 				{Header:"구성원|직원개인번호",					Type:"Text",		SaveName:"eno",			Width:100,	Align:"Center",	Edit:0},
 				{Header:"구성원|성명",						Type:"Text",		SaveName:"empnm",		Width:100,	Align:"Center",	Edit:0},
 				{Header:"구성원|직위",						Type:"Text",		SaveName:"pzcnm",		Width:100,	Align:"Center",	Edit:0},
 				{Header:"권한|시스템관리자",					Type:"CheckBox",	SaveName:"auth_001",	Width:90,	Align:"Center",	Edit:1, Hidden:false},
 				{Header:"권한|ORM전담",					Type:"CheckBox",	SaveName:"auth_002",	Width:90,	Align:"Center",	Edit:1, Hidden:false},
 				{Header:"권한|ORM팀장",					Type:"CheckBox",	SaveName:"auth_009",	Width:90,	Align:"Center",	Edit:1, Hidden:false},
 				{Header:"권한|부서ORM업무담당자",				Type:"CheckBox",	SaveName:"auth_003",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"권한|본부부서 팀장",				Type:"CheckBox",	SaveName:"auth_004",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"권한|본부부서 부장",				Type:"CheckBox",	SaveName:"auth_005",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"권한|지점장(영업점)",				Type:"CheckBox",	SaveName:"auth_006",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"권한|일반사용자",					Type:"CheckBox",	SaveName:"auth_008",	Width:90,	Align:"Center",	Edit:1, Hidden:true},
 				{Header:"권한|BCP 관리부서 담당자",			Type:"CheckBox",	SaveName:"auth_010",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"권한|부서코드",					Type:"Text",		SaveName:"brc",			Width:90,	Align:"Center",	Edit:1 ,Hidden:true}
 			];
			IBS_InitSheet(mySheet2,initData);
			
			//mySheet2.SetEditable(0); //수정불가
			mySheet2.SetFocusAfterProcess(0);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			mySheet2.SetHeaderMode({ColResize:1,ColMode:0,HeaderCheck:0,Sort:1});
			
			mySheet2.FitColWidth();
			
		}
		

		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#sel_brc").val(mySheet.GetCellValue(Row, "brc"));
				
				
				if("<%=orm_brc%>" == $("#sel_brc").val()){
					$("#orm_br_yn").val("Y");
				}else{
					$("#orm_br_yn").val("N");
				}
				if("<%=bcp_brc%>" == $("#sel_brc").val()){
					$("#bcp_br_yn").val("Y");
				}else{
					$("#bcp_br_yn").val("N");
				}
				
				doAction("empSearch");
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {

			$("#sel_brc").val("");
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet.ShowTreeLevel(1,1);

			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			
			mySheet.SetFocusAfterProcess(0);
			if("<%=chk_yn%>" == "N") {
				mySheet2.SetColHidden("auth_001",1);
				mySheet2.SetColHidden("auth_002",1);
				mySheet2.SetColHidden("auth_009",1);
				
			}
			else if ("<%=chk_yn%>" == "Y") {
				mySheet2.SetColHidden("auth_001",0);
				mySheet2.SetColHidden("auth_002",0);
				mySheet2.SetColHidden("auth_009",0);
				
			}
		}
		
		function mySheet_OnChangeFilter(){
		}
		
		function mySheet_OnFilterEnd(RowCnt, FirstRow) {
			mySheet.ShowTreeLevel(-1,0);
			mySheet.SetFocusAfterProcess(0);
			mySheet.SetBlur(1);
			$("#filter_txt").focus();
			
		}
		
		function mySheet_OnAfterExpand(Row, Expand){
			mySheet.FitColWidth();
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
			
		}
		
		function mySheet2_OnRowSearchEnd (Row) {
		}
		
		function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
		}
		
		function mySheet2_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		        doAction("empSearch");      
		    	alert("저장되었습니다.");
		    } else {
		    	alert('저장실패');
		    }
		}
				
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "orgSearch":  //부서 조회
					//mySheet2.RemoveAll();
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011602");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "empSearch":  //직원 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011603");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
					
				case "save":      //저장할 데이터 추출
				
					if($("#sel_brc").val() == ""){
						alert("저장할 내역이 없습니다.");
						return;
					}
				
					if(mySheet2.RowCount() < 1){
						alert("저장할 내역이 없습니다.");
						return;
					}
					
					if(!confirm("저장하시겠습니까?")) return;
				
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011604");
					
					mySheet2.DoAllSave(url, FormQueryStringEnc(document.ormsForm));
					
					break;
				case "filter": //부서 선택
					mySheet2.RemoveAll();
					$("#sel_brc").val("");
				
					//mySheet.SetCellValue(mySheet.FindFilterRow(), "brnm","하노이지점");
					if($("#filter_txt").val()==""){
						mySheet.ClearFilterRow()
					}else{
						mySheet.SetFilterValue("brnm", $("#filter_txt").val(), 11);
					}
					break;
					
			}
		}

		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('filter');
				return true;
			}else{
				return true;
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
<body class="" onkeyPress="return EnterkeyPass()">
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<!-- content -->
		<div class="content">
			<form name="ormsForm" method="post">
            <input type="hidden" id="sel_brc" name="sel_brc" /> <!-- 선택한 부서 코드 -->
            <input type="hidden" id="path" name="path" />
            <input type="hidden" id="process_id" name="process_id" />
            <input type="hidden" id="commkind" name="commkind" />
            <input type="hidden" id="method" name="method" />
            <input type="hidden" id="orm_br_yn" name="orm_br_yn" />
            <input type="hidden" id="bcp_br_yn" name="bcp_br_yn" />
            <input type="hidden" id="check_yn" name="check_yn" />
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<td>
										<input type="text" class="form-control w200" id="filter_txt" name="filter_txt" value="" placeholder="부서명을 입력하세요" onkeypress="EnterkeySubmit();"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('filter');">조회</button>
				</div>
			</div>
			<div class="box box-grid">
				<div class="box-body">					
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
					<div class="row">
						<div class="col col-xs-4">
							<div class="wrap-grid h500" >
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
						<div class="col">
							<div id="mydiv2" class="wrap-grid h500">
	<!-- 						<script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script>
	 -->					</div>
						 </div>
 						</div>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="javascript:doAction('save')">
							<span class="txt">저장</span>
						</button>
					</div>
				</div>
			</div>
		</form>
		</div>
		<!-- content //-->
	</div>
</body>
</html>