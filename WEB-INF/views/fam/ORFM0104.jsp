<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0104.jsp
 Program name : 평판지표 평가 관리
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();



%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	    <%@ include file="../comm/library.jsp" %>
		<title>평판지표 평가관리</title>
		<script>
			$(document).ready(function(){
				monthChange();
				// ibsheet 초기화
				initIBSheet();
				createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
			});
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet2();
			});
			/*Sheet 기본 설정 */
			
			function initIBSheet() {
				//시트 초기화
				
			mySheet.Reset();
			var initData = {};
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"평가년월"					,Type:"Text",Width:300,Align:"Center",SaveName:"bas_ym",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판지표 평가상태"			,Type:"Text",Width:300,Align:"Center",SaveName:"intg_idvd_cnm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판지표 평가대상건수"		,Type:"Text",Width:300,Align:"Center",SaveName:"cnt",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판지표 평가시작일"			,Type:"Text",Width:300,Align:"Center",SaveName:"rep_rki_st_dt",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판지표 평가완료일"			,Type:"Text",Width:300,Align:"Center",SaveName:"rep_rki_ed_dt",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판지표 입력 결과 확인"		,Type:"Button",Width:300,Align:"Center",SaveName:"btn",Wrap:1,MinWidth:60,Edit:0},
			];/*mySheet end*/

				
				IBS_InitSheet(mySheet,initData);
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				//mySheet.SetCountPosition(3);
				
				mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				doAction('search');
			}
			
			function initIBSheet2() {
				//시트 초기화
				mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msBaseColumnMerge + msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"선택|선택",								Type:"Text",Width:70,Align:"Center",SaveName:"rki_id2",Wrap:1,MinWidth:30,Edit:1,Hidden:true,ColMerge:1},
				{Header:"선택|선택",								Type:"CheckBox",Width:70,Align:"Center",SaveName:"ischeck",Wrap:1,MinWidth:30,Edit:1,Hidden:true},
				{Header:"평판지표ID|평판지표ID",					Type:"Text",Width:150,Align:"Center",SaveName:"rki_id",Wrap:1,MinWidth:40,Edit:0},
				{Header:"지표명|지표명",							Type:"Text",Width:300,Align:"Left",SaveName:"rkinm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표산식|지표산식",						Type:"Text",Width:450,Align:"Left",SaveName:"fml_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"기존KRI여부|여부",							Type:"Text",Width:100,Align:"Center",SaveName:"kri_yn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"기존KRI여부|지표명",						Type:"Text",Width:300,Align:"Left",SaveName:"oprk_rkinm",Wrap:1,MinWidth:150,Edit:0},
				{Header:"기존KRI여부|수집단위",						Type:"Text",Width:100,Align:"Center",SaveName:"col_fq_nm",Wrap:1,MinWidth:60,Edit:0,},
				{Header:"유형구분|유형구분",						Type:"Text",Width:150,Align:"Center",SaveName:"typnm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판지표\n추출방식|평판지표\n추출방식",			Type:"Text",Width:100,Align:"Center",SaveName:"psb_yn",Wrap:1,MinWidth:18,Edit:0},
				{Header:"수집주기|수집주기",						Type:"Text",Width:100,Align:"Center",SaveName:"fq_dsc",Wrap:1,MinWidth:18,Edit:0},
				{Header:"주관부서|주관부서",						Type:"Text",Width:150,Align:"Center",SaveName:"brnm",MinWidth:20,Edit:0},				
				{Header:"변경일자|변경일자",						Type:"Text",Width:100,Align:"Center",SaveName:"lschg_dtm",Wrap:1,MinWidth:20,Edit:0},
			];/*mySheet end*/
				
			IBS_InitSheet(mySheet2,initData);
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search2');
			}
			
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			//시트 ContextMenu선택에 대한 이벤트
			function mySheet_OnSelectMenu(text,code){
				alert('onselectmenu!');
				if(text=="엑셀다운로드"){
					doAction("down2excel");	
				}else if(text=="엑셀업로드"){
					doAction("loadexcel");
				}
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				if(Row >= mySheet.GetDataFirstRow()){
					//$("#rkp_id").val(mySheet.GetCellValue(Row,"rkp_id"));
					parent.window.BAS_YM_0008555 = mySheet.GetCellValue(Row, "bas_ym");
					parent.menuTrigger('0008555');
				}
			}
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert('onclick!');
				if(mySheet.ColSaveName(Col) == "btn"  && mySheet.GetCellValue(Row,"btn") != ""){
					if(Row >= mySheet.GetDataFirstRow()){
						parent.window.BAS_YM_0008555 = mySheet.GetCellValue(Row, "bas_ym");
						parent.menuTrigger('0008555');
					}
				}
			}
			function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				
			}
			function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert('onclick!');
				
			}
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("fam");
						$("form[name=ormsForm] [name=process_id]").val("ORFM010402");
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "search2":  //데이터 조회	
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("fam");
						$("form[name=ormsForm] [name=process_id]").val("ORFM010403");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet.RemoveAll();
						initIBSheet();
						break;
					case "down2excel":
						setExcelFileName("영업지수 잔액 정보");
						setExcelDownCols("0|1|2|3|4");
						mySheet.Down2Excel(excel_params);
						break;
					case "mod":
						if($("#rki_id").val() == ""){
							alert("선택해주세요.");
							return;
						}else{
							$("#ifrFamMod").attr("src","about:blank");
							$("#winFamMod").show();
							setTimeout(modFam,1);
						}
						break;
					
				}
			}
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					
				}
				
				//컬럼의 너비 조정
				mySheet.FitColWidth();
			}
			function mySheet2_OnSearchEnd(code, message) {
				
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					
				}
				
				//컬럼의 너비 조정
				mySheet2.FitColWidth();
			}
			
			function modFam(){ //일정수정
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="adm";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORAD010901";
				f.target = "ifrFamMod";
				f.submit();
			}
			function monthChange() {
				var selectYear = $("#sch_bas_y_a").val();
				var change=[];
<%
				for(int i=0; i<vLst.size(); i++) {
					HashMap hMap2 = (HashMap)vLst.get(i);
					String bas_ym2 = new String((String)hMap2.get("bas_ym"));
					String bas_y2 = bas_ym2.substring(0,4);
					String bas_m2 = bas_ym2.substring(4,6);
					%>
					if(selectYear==<%=bas_y2%>){
						if(<%=bas_m2%> < 10) change.push('0'+<%=bas_m2%>);
						else change.push(<%=bas_m2%>);
					}
					<%
				}
%>
				//alert(change.length);
				$('#sch_bas_m_a').empty();
				for(var count=0; count<change.length; count++){
					var option = $("<option>"+change[count]+"</option>");
					$('#sch_bas_m_a').append(option);
				}    
			}
			function monthChange2() {
				var selectYear = $("#sch_bas_y_b").val();
				var change=[];
<%
				for(int i=0; i<vLst.size(); i++) {
					HashMap hMap2 = (HashMap)vLst.get(i);
					String bas_ym2 = new String((String)hMap2.get("bas_ym"));
					String bas_y2 = bas_ym2.substring(0,4);
					String bas_m2 = bas_ym2.substring(4,6);
					%>
					if(selectYear==<%=bas_y2%>){
						if(<%=bas_m2%> < 10) change.push('0'+<%=bas_m2%>);
						else change.push(<%=bas_m2%>);
					}
					<%
				}
%>
				//alert(change.length);
				$('#sch_bas_m_b').empty();
				for(var count=0; count<change.length; count++){
					var option = $("<option>"+change[count]+"</option>");
					$('#sch_bas_m_b').append(option);
				}    
			}
		</script>
	</head>
	
	<body>
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
				<input type="hidden" id="sch_bas_y" name="sch_bas_y" />
				<input type="hidden" id="sch_bas_m" name="sch_bas_m" />
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>기간설정</th>
										<td class="form-inline">
											<select name="sch_bas_y_a" id="sch_bas_y_a" class="form-control w80" onchange="monthChange()">
<%
		String temp = "";
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			if(bas_y.equals(temp)) continue; 
			else{
%>
												<option value="<%=bas_y%>"><%=bas_y%></option>
<%			}
			temp = bas_y;
		}
%>

											</select>
											<select name="sch_bas_m_a" id="sch_bas_m_a" class="form-control w60">
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			String bas_m = bas_ym.substring(4,6);
			if(temp.equals(bas_y)){
%>
												<option value="<%=bas_m%>"><%=bas_m%></option>
<% 
			}
		}
%>												
											</select>
											~
											<select name="sch_bas_y_b" id="sch_bas_y_b" class="form-control w80" onchange="monthChange2()">
<%		temp="";
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			if(bas_y.equals(temp)) continue; 
			else{
%>
												<option value="<%=bas_y%>" selected><%=bas_y%></option>
<%
			}
			temp = bas_y;
		}
%>

											</select>
											<select name="sch_bas_m_b" id="sch_bas_m_b" class="form-control w60">
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			String bas_m = bas_ym.substring(4,6);
			if(temp.equals(bas_y)){
%>
												<option value="<%=bas_m%>" selected><%=bas_m%></option>
<% 
			}
		}
%>
													
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
					</div>
				</div>
				<section class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="btn-group">
								<button type="button" class="btn btn-xs btn-default" onClick="doAction('mod');"><i class="fa fa-pencil"></i><span class="txt">수정</span></button>
							</div>
						</div>
					</div>
					<div class="wrap-grid h180">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</section>
				<section class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">평판지표 평가대상 목록 조회</h2>
					</div>
					<div id="mydiv2" class="wrap-grid h350">
						<!-- <script> createIBSheet("mySheet2", "100%", "100%"); </script> -->
					</div>
				</section>
			</form>
			</div>
			<!-- content //-->
			
		</div>
		<div id="winFamMod" class="popup modal">
			<iframe name="ifrFamMod" id="ifrFamMod" src="about:blank"></iframe>
		</div>
		<!-- popup -->
		<%@ include file="../comm/OrgInfP.jsp" %>
		<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 
		
	</body>
</html>