<%--
/*---------------------------------------------------------------------------
 Program ID   : ORSN0101.jsp
 Program name : 시나리오 분석정보 관리
 Description  : 화면정의서 SCNR-0100
 Programer    : 고창호
 Date created : 2022.08.23
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
if(vLst3==null) vLst3 = new Vector();
 
HashMap hMap3 = null;
if(vLst3.size()>0){
	hMap3 = (HashMap)vLst3.get(0);
}else{
	hMap3 = new HashMap();
}

Vector vSnroEvlPrgC = CommUtil.getCommonCode(request, "SNRO_EVL_PRG_STSC");
if(vSnroEvlPrgC==null) vSnroEvlPrgC = new Vector();
String SnroEvlPrgC = "";
String SnroEvlPrgNm = "";
/*시나리오 일정 코드*/
for(int i=0;i<vSnroEvlPrgC.size();i++){
	HashMap hMap = (HashMap)vSnroEvlPrgC.get(i);
	if( i > 0 ){
		SnroEvlPrgC += "|";
		SnroEvlPrgNm += "|";
	}
	SnroEvlPrgC += (String)hMap.get("intgc");
	
	SnroEvlPrgNm += (String)hMap.get("intg_cnm");
}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>내부 자본량 측정 결과 조회</title>
	<script>
		
		$(document).ready(function(){

		<%
			if(vLst3.size()>0){
		%>
					$('#span_snro_sc').html('<%=(String)hMap3.get("snro_sc")%>'.substring(0,4)+"-"+'<%=(String)hMap3.get("snro_sc")%>'.substring(4,6)); //회차
					
					if('<%=(String)hMap3.get("efct_st_dt")%>' == "" || '<%=(String)hMap3.get("efct_ed_dt")%>' == ""){
						$('#span_reg').html("일정등록 필요");
					}else{
						$('#span_reg').html("일정등록 완료");
					}
					
		<%
			}
		%>	
			// ibsheet 초기화
			initIBSheet();
			
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			
			
			initData.Cols = [
				{Header:"회차",Type:"Text",Width:150,Align:"Center",SaveName:"snro_sc",MinWidth:100,Edit:false,Format:"####-##"},
				{Header:"수행시작일",Type:"Date",Width:150,Align:"Center",SaveName:"efct_st_dt",MinWidth:100,Edit:false},
				{Header:"수행종료일",Type:"Date",Width:150,Align:"Center",SaveName:"efct_ed_dt",MinWidth:100,Edit:false},
				{Header:"시나리오 보고서",Type:"Text",Width:150,Align:"Center",SaveName:"snro_evl_tit",MinWidth:150,Edit:false},
				{Header:"등록/변경사유",Type:"Text",Width:150,Align:"Center",SaveName:"snro_rsn",MinWidth:100,Edit:false},
				{Header:"상태",Type:"Combo",Width:80,Align:"Center",SaveName:"snro_evl_prg_stsc",MinWidth:60,ComboText:"<%=SnroEvlPrgNm%>", ComboCode:"<%=SnroEvlPrgC%>",Edit:0},
				{Header:"고위험 업무건수",Type:"Text",Width:150,Align:"Center",SaveName:"rskbsn_count",MinWidth:100,Edit:false},
				{Header:"고위험 업무등록",Type:"Button",Width:150,Align:"Center",SaveName:"btn_rg",MinWidth:100,Edit:true},
				{Header:"평가종료",Type:"Button",Width:150,Align:"Center",SaveName:"btn_cpl",MinWidth:100,Edit:true,Hidden:true}
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);

			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		
			doAction('search');
			
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
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("snr");
					$("form[name=ormsForm] [name=process_id]").val("ORSN010102");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "ORSN0103":		//중요위험 업무등록 팝업
					$("#ifrORSN0103").attr("src","about:blank");
					$("#winORSN0103").show();
					
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(popORSN0103,1);
					break;
				case "add":		//계열사 일정등록 팝업
					if($("#sch_bas_yy").val() == ""){
						alert("조회조건에 시행년도를 선택하세요.");
						return;
					}
					if($("#snro_sc").val() == ""){
						alert("평가회차 정보가 없습니다.");
						return;
					}
					$("#gubun").val("I")
				
					$("#ifrORSN0102").attr("src","about:blank");
					$("#winORSN0102").show();
					
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(popORSN0102_I,1);
					
					break; 
				case "mod":		//계열사 일정등록 팝업
					if($("#snro_sc").val() == ""){
						alert("평가회차 정보가 없습니다.");
						return;
					}
					$("#gubun").val("U")
				
					$("#ifrORSN0102").attr("src","about:blank");
					$("#winORSN0102").show();
					
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(popORSN0102_U,1);
					
					break; 	
				case "down2excel":
					setExcelFileName("시나리오 평가정보 목록");
					setExcelDownCols("0|1|2|3|4|5");
					mySheet.Down2Excel(excel_params);
	
					break;
			}
		}
		
		function popORSN0103(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="snr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORSN010301";
			f.target = "ifrORSN0103";
			f.submit();
		}
		
		function popORSN0102_I(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="snr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORSN010203";
			f.target = "ifrORSN0102";
			$("#gubun").val("I");
			f.submit();
		}
		
		function popORSN0102_U(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="snr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORSN010201";
			f.target = "ifrORSN0102";
			$("#gubun").val("U");
			f.submit();
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet_OnClick(1); //첫행 클릭
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#grp_org_c_p").val(mySheet.GetCellValue(Row,"grp_org_c_p")); /*그룹기관코드*/
				$("#snro_sc").val(mySheet.GetCellValue(Row,"snro_sc")); /*시나리오회차*/
				$("#snro_evl_prg_stscnm").val(mySheet.GetCellValue(Row,"snro_evl_prg_stscnm")); /*상태*/
				
				doAction('mod'); //계열사 일정등록
			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#grp_org_c_p").val(mySheet.GetCellValue(Row,"grp_org_c_p")); /*그룹기관코드*/
				$("#snro_sc").val(mySheet.GetCellValue(Row,"snro_sc")); /*시나리오회차*/
			}
			
			//중요위험 업무등록 - 등록 버튼 클릭
			if(mySheet.ColSaveName(Col) == "btn_rg" && mySheet.GetCellValue(Row,"btn_rg") != ""){
				
				var today = new Date();
				var yyyy = today.getFullYear();
				var mm = today.getMonth()+1;
				var dd = today.getDate();
				
				if(mm < 10){
					mm = "0" + mm;
				}
				
				if(dd < 10){
					dd = "0" + dd;
				}
				
				var to_date = yyyy + "" + mm + "" + dd;
				var efct_st_dt = mySheet.GetCellValue(Row,"efct_st_dt"); //수행시작일
				var efct_ed_dt = mySheet.GetCellValue(Row,"efct_ed_dt"); //수행종료일
				
				if(to_date<efct_st_dt || to_date>efct_ed_dt){
					alert("중요위험 업무등록은 수행기간 내에만 등록 수정이 가능합니다.");
					return;
				}
				
				doAction("ORSN0103"); //중요위험 업무등록 팝업호출
			}
			
			//평가종료 - 완료 버튼 클릭
			if(mySheet.ColSaveName(Col) == "btn_cpl"  && mySheet.GetCellValue(Row,"btn_cpl") != ""){
				if(mySheet.GetCellValue(Row,"snro_evl_prg_stsc") == "02"){
					if(!confirm("평가를 완료 하시겠습니까?")) return;
				}else{
					alert("상태가 평가중인 항목만 가능합니다.");
					return;
				}
				
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "snr");
				WP.setParameter("process_id", "FGORS10103");
				WP.setParameter("snro_sc", mySheet.GetCellValue(Row,"snro_sc")); //회차
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("완료 하였습니다.");
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result!='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
							doAction('search');
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
				});
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
			
			<input type="hidden" id="grp_org_c_p" name="grp_org_c_p" /> <!-- 그룹기관코드 -->
			<input type="hidden" id="snro_sc" name="snro_sc" /> <!-- 평가회차 -->
			
			<input type="hidden" id="gubun" name="gubun" /> <!-- 평가회차 -->
			
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>시행 년도</th>
									<td>
										<div class="select w100">
											<select name="sch_bas_yy" id="sch_bas_yy" class="form-control">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
%>
												<option value="<%=(String)hMap.get("bas_yy")%>"><%=(String)hMap.get("bas_yy")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>진행 상태</th>
									<td>
										<div class="select">
											<select name="sch_snro_evl_prg_stsc" id="sch_snro_evl_prg_stsc" class="form-control">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div>
			</form>
			<!-- //조회 -->
			
			<div class="box box-grid">
				<div class="box-header">
<% if("0".equals(stp_dsc)){ %>				
<!-- 은행은 지주평가일정 화면 출력되지않도록 설정 -->
<% }else{ %>
					<div class="area-term">
						<span class="tit">지주 평가 일정 :</span>
						<strong id="span_snro_sc" class="em"></strong>
						<span>회차</span>
						<span class="div">/</span>
						<strong id="span_comn_efct_st_dt" class="em"></strong>
						<span class="div">~</span>
						<strong id="span_comn_efct_ed_dt" class="em"></strong>
						<span id="span_reg" class="note small ml5"></span>
					</div>
<% } %>					
<% if("0".equals(stp_dsc)){ %>			
					<div class="area-tool">
						<button type="button" class="btn btn-default btn-xs" onclick="doAction('add');">
							<i class="fa fa-plus"></i><span class="txt">일정등록</span>
						</button>
					</div>
<% } %>					
				</div>
			
				<div class="wrap-grid h580">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</div>
			
		</div>
		<!-- content //-->
		
	</div>
	
	<!-- popup -->
	<div id="winORSN0103" class="popup modal">
		<iframe name="ifrORSN0103" id="ifrORSN0103" src="about:blank"></iframe>
	</div>
	
	<div id="winORSN0102" class="popup modal">
		<iframe name="ifrORSN0102" id="ifrORSN0102" src="about:blank"></iframe>
	</div>
</body>
</html>