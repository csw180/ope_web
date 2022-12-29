<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0107.jsp
 Program name : 영업지수(BIC) 잔액변동 조회
 Description  :	MSR-09
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
/* Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
if(vLst3==null) vLst3 = new Vector(); */

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector vLst= CommUtil.getCommonCode(request, "LV1_BIZ_IX_C");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getCommonCode(request, "LV2_BIZ_IX_C");
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst3==null) vLst3 = new Vector();
Vector vSbdrLst= CommUtil.getCommonCode(request, "SBDR_C");
if(vSbdrLst==null) vSbdrLst = new Vector();

Vector vRgoLst= CommUtil.getCommonCode(request, "RGO_IN_DSC");
if(vRgoLst==null) vRgoLst = new Vector();

%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>영업지수 잔액변동 조회(공통)</title>
	<script>
		
		$(document).ready(function(){
			$("#sel_sbdr_c").val('');
			$("#sbdr_c").val('00');
			// ibsheet 초기화
			initIBSheet();
			
			// 영업지수 Lv1 변경시
			$('#sch_lv1_biz_ix_c').change(function(){
				$('#sch_lv2_biz_ix_c option').remove();
				$('#sch_lv2_biz_ix_c').prepend("<option value=''>전체</option>");
				if($('#sch_lv1_biz_ix_c option:selected').val() == ""){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
	}
%>	
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "01"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("01")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>					
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "02"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("02")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "03"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("03")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}else if($('#sch_lv1_biz_ix_c option:selected').val() == "99"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("99")){
%>
					$('#sch_lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}
			});
			
			
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			mySheet2.Reset();
			
			var initData = {};
			var initData2 = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1,FrozenCol:0, MergeSheet:msBaseColumnMerge ,HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			
			var headers = [{Text:"영업지수 Lv.1|영업지수 Lv.1|영업지수 Lv.2|영업지수 Lv.2|전분기(연도)|당분기(연도)|변동금액|변동율(%)", Align:"Center"}];
			
			//ApproximateType = 1:반올림, 2:내림, 3:올림
			//Wrap = 자동 줄바꿈
			//ColMerge = 0:머지안함
			initData.Cols = [
				{Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"lv1_biz_ix_c"		,Edit:"False"	,Hidden:true 	},
				{Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"division"			,Edit:"False"	,ColMerge:1		},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"lv2_biz_ix_c"		,Edit:"False"	,Hidden:true 	},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"item"				,Edit:"False"					},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"msr_am2"			,Edit:"False"	,ColMerge:0},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"msr_am3"			,Edit:"False"	,ColMerge:0},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"change_am"	,Edit:"False"	,ColMerge:0},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"change_per"	,Edit:"False"	,ColMerge:0, Align:"Left"}
				
			];
			/*mySheet end*/
			
			/*mySheet2*/
			initData2.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			
			var headers2 = [{Text:"영업지수 Lv.1|영업지수 Lv.1|영업지수 Lv.2|영업지수 Lv.2|계정과목코드|계정과목명|전분기(연도)|당분기(연도)|변동금액|변동율(%)", Align:"Center"}];
			
			initData2.Cols = [
				{Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"lv1_biz_ix_c"		,Edit:"False"	,Hidden:true 	},
				{Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"division"			,Edit:"False"	,ColMerge:1		},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"lv2_biz_ix_c"		,Edit:"False"	,Hidden:true 	},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"item"				,Edit:"False"					},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"cnm1"				,Edit:"False"					},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"acc_sbjnm"				,Edit:"False"					},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"msr_am2"			,Edit:"False"	,ColMerge:0},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"msr_am3"			,Edit:"False"	,ColMerge:0},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"change_am"	,Edit:"False"	,ColMerge:0},
				{Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"change_per"	,Edit:"False"	,ColMerge:0, Align:"Left"}
				
			];
			/*mySheet2 end*/
			
			IBS_InitSheet(mySheet,initData);
			IBS_InitSheet(mySheet2,initData2);
			
			mySheet.InitHeaders(headers);
			
			mySheet2.InitHeaders(headers2);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			mySheet2.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			mySheet2.FitColWidth();
			
			
			/* mySheet.SetSumValue(0, "총계");
			mySheet.SetSumValue(5, 0); //변동율 초기값 세팅
			
			mySheet2.SetSumValue(0, "총계");
			mySheet2.SetSumValue(7, 0); //변동율 초기값 세팅 */
			
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
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#sch_lv1_biz_ix_c").val(mySheet.GetCellValue(Row,"lv1_biz_ix_c")); //영업지수코드
				$("#sch_lv2_biz_ix_c").val(mySheet.GetCellValue(Row,"lv2_biz_ix_c")); //영업지수코드
				
				doAction('search2'); //영업지수 잔액 변동 상세 조회(mySheet2)
			}
		}
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회 (mySheet)
					var sch_bas_yy = $("#sch_bas_yy").val(); //조회년도
					var sch_bas_qq = $("#sch_bas_qq").val(); //조회분기(월)
					/* if(sch_bas_qq == ''){
						sch_bas_yy =
					} */
					$("#sch_bas_ym").val(sch_bas_yy+""+sch_bas_qq); //조회년월 (YYYYMM)
					
					//조회 분기가 -(선택안함)인 경우 연도 변동 조회
					if(sch_bas_qq == ""){
						$("#sch_gubun").val("Y"); //연도
					}else{
						$("#sch_gubun").val("Q"); //분기
					}
					
					if($('#sch_bas_yy').val() == "" || $('#sch_bas_yy').val() == null){
						alert("연도정보가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
					
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010702");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					if($('#sch_lv2_biz_ix_c').val() != '' || $('#sch_lv1_biz_ix_c').val() != ''){
						doAction('search2');
						break;
					}
					break;
				case "search2":  //데이터 조회 (mySheet2)
					
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010703");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					setExcelFileName("영업지수 잔액 변동 요약 조회");
					setExcelDownCols("1|2|3|4|5|6");
					mySheet.Down2Excel(excel_params);
	
					break;
				case "down2excel2":
					setExcelFileName("영업지수 잔액 변동 상세 조회");
					setExcelDownCols("1|3|4|5|6|7");
					mySheet2.Down2Excel(excel_params);
	
					break;
			}
		}
	
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			/* 
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			
			var sch_bas_ym = $("#sch_bas_ym").val(); //조회년월
			if(sch_bas_ym.length == 4){ //연도
				// SetRangeText : {"변경값", 시작행, 시작열, 종료행, 종료열}
				mySheet.SetRangeText("전연도", 0, 2, 0, 2);
				mySheet.SetRangeText("당연도", 0, 3, 0, 3);
			}else{ //분기
				// SetRangeText : {"변경값", 시작행, 시작열, 종료행, 종료열}
				mySheet.SetRangeText("전분기", 0, 2, 0, 2);
				mySheet.SetRangeText("당분기", 0, 3, 0, 3);
			}
			
			var total_j = mySheet.GetSumValue(2)*1;
			var total_d = mySheet.GetSumValue(3)*1;
			var totalAvg = (total_d - total_j) / total_j * 100
			
			mySheet.SetSumValue(5, totalAvg.toFixed(2));
			
			mySheet_OnClick(1); //첫행 클릭 */
		}
		
		function mySheet2_OnSearchEnd(code, message) {
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			/* 
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
			
			var sch_bas_ym = $("#sch_bas_ym").val(); //조회년월
			if(sch_bas_ym.length == 4){ //연도
				// SetRangeText : {"변경값", 시작행, 시작열, 종료행, 종료열}
				mySheet2.SetRangeText("전연도", 0, 4, 0, 4);
				mySheet2.SetRangeText("당연도", 0, 5, 0, 5);
			}else{ //분기
				// SetRangeText : {"변경값", 시작행, 시작열, 종료행, 종료열}
				mySheet2.SetRangeText("전분기", 0, 4, 0, 4);
				mySheet2.SetRangeText("당분기", 0, 5, 0, 5);
			}
			
			var total_j = mySheet2.GetSumValue(4)*1;
			var total_d = mySheet2.GetSumValue(5)*1;
			var totalAvg = (total_d - total_j) / total_j * 100
			
			mySheet2.SetSumValue(7, totalAvg.toFixed(2)); */
		}
		
		function rgo_change_func(rgo_in_dsc){
			var rgo_in_dsc = $(rgo_in_dsc).val();
			if(rgo_in_dsc == '1')
				{
					$("#sel_sbdr_c").attr('disabled',true);
					$("#sel_sbdr_c").val('');
					$("#sbdr_c").val('00');
				}
			else if(rgo_in_dsc == '2')
				{
					$("#sel_sbdr_c").attr('disabled',false);
					$("#sel_sbdr_c").val('01');
					$("#sbdr_c").val('01');
				}
		}
		
		function sbdr_change_func(sel_sbdr_c){
			var sel_sbdr_c = $(sel_sbdr_c).val();
			if(sel_sbdr_c == '01')
				{
					$("#sbdr_c").val('01');
				}
			else if(sel_sbdr_c == '02')
			    {
			    	$("#sbdr_c").val('02');
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

			<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" /> <!-- 조회년월 (sch_bas_yy + sch_bas_qq) -->
			<input type="hidden" id="sch_bas_ym_cc" name="sch_bas_ym_cc" />
			<input type="hidden" id="sch_gubun" name="sch_gubun" /> <!-- 연도, 분기 조회구분 -->
			<input type="hidden" id="biz_ix_c" name="biz_ix_c" /> <!-- 영업지수코드 -->
			<input type="hidden" id="sbdr_c" name="sbdr_c" value="" />
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>연도 선택</th>
									<td>
										<div class="select w100">
											<select name="sch_bas_yy" id="sch_bas_yy" class="form-control">
<%
	for(int i=0;i<vLst3.size();i++){
		HashMap hMap = (HashMap)vLst3.get(i);
%>
												<option value="<%=(String)hMap.get("bas_yy")%>"><%=(String)hMap.get("bas_yy")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>분기 선택</th>
									<td>
										<div class="select">
											<select name="sch_bas_qq" id="sch_bas_qq" class="form-control">
												<option value="03">1분기</option>
												<option value="06">2분기</option>
												<option value="09">3분기</option>
												<option value="12">4분기</option>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th>측정방법</th>
									<td>
										<div class="select">
											<select name="rgo_in_dsc" id="rgo_in_dsc" class="form-control" onchange="rgo_change_func(this)">
<%
	for(int i=0;i<vRgoLst.size();i++){
		HashMap hMap = (HashMap)vRgoLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>발생 법인</th>
									<td>	
										<div class="select">
											<select name="sel_sbdr_c" id="sel_sbdr_c" class="form-control" onchange="sbdr_change_func(this)" disabled>
<%
	for(int i=0;i<vSbdrLst.size();i++){
		HashMap hMap = (HashMap)vSbdrLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th>영업지수 Lv.1</th>
									<td>
										<div class="select">
											<select name="sch_lv1_biz_ix_c" id="sch_lv1_biz_ix_c" class="form-control">
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
									<th>영업지수 Lv.2</th>
									<td>
										<div class="select">
											<select name="sch_lv2_biz_ix_c" id="sch_lv2_biz_ix_c" class="form-control">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
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
			<!-- //조회 -->


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">조회결과</h2>
					<div class="area-tool">						
						<button class="btn btn-default btn-xs" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h400">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
				<!-- <div class="box-footer">
					<div class="btn-wrap fr">
						<button class="btn btn-primary">
							<span class="txt">상세 조회</span>
						</button>
					</div>
				</div> -->
			</section>


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">영업지수 잔액 변동 상세 조회</h2>
					<div class="area-tool">						
						<button class="btn btn-default btn-xs" type="button" onclick="javascript:doAction('down2excel2');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h250">
						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div>
				</div>
			</section>
		
		</form>
		</div>
		<!-- content //-->
		
	</div>
	
</body>
</html>