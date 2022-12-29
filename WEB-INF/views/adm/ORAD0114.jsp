<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0114.jsp
 Program name : ADMIN > 사용자/권한관리 > 조직코드
 Description  : 
 Programmer   : 김병현
 Date created : 2022.07.07
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	String orm_brc = "", bcp_brc = "";
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

	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet1();
		});
		
		/*Sheet1 기본 설정 */
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData = {};
			//sizeNoHScroll
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, Sort:1,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"상위부서코드",			Type:"Text",	SaveName:"up_brc",			Hidden:true},
 				{Header:"레벨",				Type:"Text",	SaveName:"level",			Hidden:true},
 				{Header:"부서코드",			Type:"Text",	SaveName:"brc",				Hidden:true},
 				{Header:"차수",				Type:"Text",	SaveName:"lvl_no",			Hidden:true},
 				{Header:"사무소폐쇄여부",		Type:"Text",	SaveName:"br_lko_yn",		Hidden:true},
 				{Header:"지역코드",			Type:"Text",	SaveName:"rgn_c",			Hidden:true},
 				{Header:"본부영업점구분코드",		Type:"Text",	SaveName:"hofc_bizo_dsc",	Hidden:true},
 				{Header:"운영리스크조직여부",		Type:"Text",	SaveName:"uyn",				Hidden:true},
 				{Header:"최하위조직여부",		Type:"Text",	SaveName:"lwst_orgz_yn",	Hidden:true},
 				{Header:"팀장결재여부",			Type:"Text",	SaveName:"temgr_dcz_yn",	Hidden:true},
 				{Header:"부서명",				Type:"Text",	SaveName:"brnm",			TreeCol:1,	Width:580,	MinWidth:90}
 			];
			IBS_InitSheet(mySheet1,initData);
			
			mySheet1.SetEditable(0); //수정불가
			mySheet1.SetFocusAfterProcess(0);
			
			
			//필터표시
			mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet1.FitColWidth();
			
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
				$("#brc").val(mySheet1.GetCellValue(Row,"brc"));
				$("#brnm").val(mySheet1.GetCellValue(Row,"brnm"));
				$("#up_brc").val(mySheet1.GetCellValue(Row,"up_brc"));
				$("#lvl_no").val(mySheet1.GetCellValue(Row,"lvl_no"));
				$("#br_lko_yn").val(mySheet1.GetCellValue(Row,"br_lko_yn"));
				$("#rgn_c").val(mySheet1.GetCellValue(Row,"rgn_c"));
				$("#hofc_bizo_dsc").val(mySheet1.GetCellValue(Row,"hofc_bizo_dsc"));
				$("#uyn").val(mySheet1.GetCellValue(Row,"uyn"));
				$("#lwst_orgz_yn").val(mySheet1.GetCellValue(Row,"lwst_orgz_yn"));
				$("#temgr_dcz_yn").val(mySheet1.GetCellValue(Row,"temgr_dcz_yn"));
				if($("#lwst_orgz_yn").val() == "Y") {
					$("#uyn").attr("disabled",false);
				}
				else $("#uyn").attr("disabled",true);

				
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
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet1.ShowTreeLevel(1,1);
			}
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
			
			mySheet1.SetFocusAfterProcess(0);
			
		}
		
		function mySheet1_OnChangeFilter(){
		}
		
		function mySheet1_OnFilterEnd(RowCnt, FirstRow) {
			mySheet1.ShowTreeLevel(-1,0);
			mySheet1.SetFocusAfterProcess(0);
			mySheet1.SetBlur(1);
			$("#filter_txt").focus();
			
		}
		
		function mySheet1_OnAfterExpand(Row, Expand){
			mySheet1.FitColWidth();
		}
		
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "orgSearch":  //부서 조회
					$("#sel_brc").val("");
					$("#sch_uyn").val("");
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011402");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
				
				case "save":      //저장할 데이터 추출
					$("#sch_uyn").val($("#uyn").val());
				
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					WP.setParameter("process_id", "ORAD011404");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							alert("저장완료");
							doAction('orgSearch');
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
					break;
					
				case "filter": //부서 선택
					
					mySheet2.RemoveAll();
					$("#sel_brc").val("");
				
					//mySheet.SetCellValue(mySheet.FindFilterRow(), "brnm","하노이지점");
					if($("#filter_txt").val()==""){
						mySheet1.ClearFilterRow()
					}else{
						mySheet1.SetFilterValue("brnm", $("#filter_txt").val(), 11);
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
				mySheet1.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet1.ShowTreeLevel(0,1);
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
            <input type="hidden" id="sch_uyn" name="sch_uyn" />
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
					<div class="row">
						<div class="col w40p">
							<div class="box">
								<div class="box-body">
									<div class="wrap h500">
										 <script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
									</div>
								</div>
							</div>
						</div>
						<div class="col w60p">
						<div class="box-header">
							<h2 class="box-title">조직 코드 정보</h2>
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
											<th rowspan="1">사무소코드</th>
											<td>
												<div class="form-inline">
													<input type="text" name="brc" id="brc" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">사무소명</th>
											<td>
												<div class="form-inline">
													<input type="text" name="brnm" id="brnm" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">상위사무소코드</th>
											<td>
												<div class="form-inline">
													<input type="text" name="up_brc" id="up_brc" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">차수</th>
											<td>
												<div class="form-inline">
													<input type="text" name="lvl_no" id="lvl_no" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">사무소폐쇄여부</th>
											<td>
												<div class="form-inline">
													<input type="text" name="br_lko_yn" id="br_lko_yn" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">지역코드</th>
											<td>
												<div class="form-inline">
													<input type="text" name="rgn_c" id="rgn_c" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">최하위조직여부</th>
											<td>
												<div class="form-inline">
													<input type="text" name="lwst_orgz_yn" id="lwst_orgz_yn" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">팀장결재여부</th>
											<td>
												<div class="form-inline">
													<input type="text" name="temgr_dcz_yn" id="temgr_dcz_yn" class="form-control w49p" disabled>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="1">운영리스크조직여부</th>
											<td>
												<div class="select w170">
													<select class="form-control w49p" name="uyn" id="uyn" >
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
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