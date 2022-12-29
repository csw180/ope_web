<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0109.jsp
 Program name :	분기별 자본량 산출 결과조회
 Description  : MSR-12
 Programer    : 이규탁
 Date created : 2022.07.27
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>측정대상 손실사건 조회(공통)</title>
	<script>
		
		$(document).ready(function(){

			// ibsheet 초기화
			initIBSheet();
			
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1,  MergeSheet:msAll, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};
			
			var headers = [{Text:"자본량 산출 구성 요소|자본량 산출 구성 요소|자본량 산출 구성 요소|산출값(규제)|산출값(내부 은행 별도)|산출값(내부 미얀마 별도)", Align:"Center"}];
			mySheet.SetCountPosition(0);
			initData.Cols = [
				{ Header: "자본량 산출기준 구성 요소",	Type:"Text",Width:70,Align:"Center",	SaveName:"msr_elm_dscd",Edit:false, Hidden:true},
				{ Header: "자본량 산출기준 구성 요소",	Type: "Text",	SaveName: "gubun",		Align: "Center",		Edit:false,Width: 10,	MinWidth: 50},
				{ Header: "자본량 산출기준 구성 요소",	Type: "Text",	SaveName: "division",	Align: "Center",	Edit:false,Width: 10,	MinWidth: 200 },
				{ Header: "산출값 (규제)",			Type: "Text",	SaveName: "msr_am3",	Align: "Right",		Edit:false,Width: 10,	MinWidth: 100 , ColMerge: 0},
				{ Header: "산출값 (내부 은행 별도)",	Type: "Text",	SaveName: "msr_am2",	Align: "Right",		Edit:false,Width: 10,	MinWidth: 100 , ColMerge: 0},
				{ Header: "산출값 (내부 미얀마 별도)",	Type: "Text",	SaveName: "msr_am1",	Align: "Right",		Edit:false,Width: 10,	MinWidth: 100 , ColMerge: 0}
			];
			/*mySheet end*/

			IBS_InitSheet(mySheet,initData);
			
			mySheet.InitHeaders(headers);

			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			

			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			mySheet.SetCellBackColor(1, 0, "#FFDEAD");
			
			
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
					var sch_bas_yy = $("#sch_bas_yy").val(); //조회년도
					var sch_bas_qq = $("#sch_bas_qq").val(); //조회분기(월)
					$("#sch_bas_ym").val(sch_bas_yy+""+sch_bas_qq); //조회년월 (YYYYMM)
					
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010902");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					setExcelFileName("자본량 산출 결과 조회.xlsx");
					setExcelDownCols("1|2|3|4|5");
					mySheet.Down2Excel(excel_params);
	
					break;
				case "help":		//영업지수 변동내역조회 팝업
					$("#ifrHelp").attr("src","about:blank");
					$("#winHelp").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(modHelp,1);
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
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
				return true;
			}else{
				return true;
			}
		}
		function modalGuide_open(){
			document.getElementById('modalGuide').classList.add('block');
		}
		function modalGuide_close(){
			document.getElementById('modalGuide').classList.remove('block');
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

			<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" /> <!-- 기준년월 -->
			
			<input type="hidden" id="sch_lshp_stsc1" name="sch_lshp_stsc1" /> <!-- 손실상태 -->
			<input type="hidden" id="sch_lshp_stsc2" name="sch_lshp_stsc2" />
			<input type="hidden" id="sch_lshp_stsc3" name="sch_lshp_stsc3" />
			<input type="hidden" id="sch_lshp_stsc4" name="sch_lshp_stsc4" />
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
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
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
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button type="button" class="btn btn-default btn-xs" onclick="modalGuide_open();"><i class="fa fa-question-circle"></i><span class="txt">Help</span></button>
						<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
					</div>
				</div>
			</div>
			<!-- //조회 -->


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">요약 정보</h2>
					<div class="area-tool">
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h900">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
			</section>
		</form>
		</div>
		<!-- content //-->
	</div>
	
	<!-- popup -->
	<article id="modalGuide" class="popup modal">
		<div class="p_frame w1000">	
			<div class="p_head">
				<h3 class="title">신표준방법 측정 산출 가이드라인</h3>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				
				
					<div class="row">
						<div class="col w300">
							<ul class="msr-guide-step">
								<li>
									<p class="cont">영업지수(BI) Mapping</p>
									<p class="add">※ <strong>신규 계정과목 매핑</strong>여부 확인</p>
								</li>
								<li>
									<p class="cont">영업지수요소(BIC) 산출</p>
									<p class="add">※ 요소별 <strong>금액 모니터링</strong></p>
								</li>
								<li>
									<p class="cont">손실요소(LC)를 활용한<br>손실승수(ILM) 산출</p>
									<p class="add">※ 10년 손실금액 반영에 대한<strong>정합성 검증</strong></p>
								</li>
								<li>
									<p class="cont">자본량(ORC) 및<br>위험가중자산(RWA) 산출</p>
									<p class="add">※ 규제자본 및 내부자본에 따른<strong>한도 설정</strong></p>
								</li>
							</ul>
						</div>
						
						<div class="col">
							<div class="wrap-table">
								<table>
									<tbody>
										<tr>
											<th scope="row" class="w100">영업지수요소<br>(BIC)</th>
											<td>
												<p class="math"><strong class="fsi">BI</strong> = <strong class="cm fsi">ILDC</strong> + <strong class="ca fsi">SC</strong> + <strong class="ci fsi">FC</strong></p>
												<ul class="ph2 pl25">
													<li><strong class="cm fsi">ILDC</strong> = <strong class="fsi">Min</strong>(|이자수익 - 이자비용|<em class="sup">*</em>, (이자수익자산<em class="sup">*</em> &times; <strong>2.25</strong>%)) + <strong>배당수익</strong><em class="sup">*</em></li>
													<li><strong class="ca fsi">SC</strong> = <strong class="fsi">Min</strong>(수수료수익<em class="sup">*</em>, 수수료비용<em class="sup">*</em>) + <strong class="fsi">Max</strong>(기타영업이익<em class="sup">*</em>, 기타영업비용<em class="sup">*</em>)</li>
													<li><strong class="ci fsi">FC</strong> = |이자수익<em class="sup">*</em>| - |트레이딩계정손익<em class="sup">*</em>|</li>
													<li class="txt txt-xs cr">* : 3개년 평균</li>
												</ul>
												<p class="math"><strong class="fsi">BIC</strong> = <strong class="fsi">BI</strong> + α(BI 계수)</p>
												<div class="ph5 pl20 pr10">
													<table class="intable">
														<thead>
															<tr>
																<th scope="col" class="w60">구분</th>
																<th scope="col">구간</th>
																<th scope="col" class="w80">BI 계수</th>
															</tr>
														</thead>
														<tbody class="center">
															<tr>
																<td>1</td>
																<td>1.4조원 이하</td>
																<td>12%</td>
															</tr>
															<tr>
																<td>2</td>
																<td>1.4조원 초과 42조원 이하</td>
																<td>15%</td>
															</tr>
															<tr>
																<td>3</td>
																<td>42조원 초과</td>
																<td>18%</td>
															</tr>
														</tbody>
													</table>
												</div>
												<div class="wrap-footnote pl20">
													<p class="txt txt-xs ca">※ BI계수는 BI산출금액에 따라 구간별 적용</p>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row">내부손실승수<br>(ILM)</th>
											<td>
												<div class="math">
													<strong class="fsi">ILM</strong> = <strong>ln</strong>
													<div class="bracket">
														<strong>exp(1)</strong> - <strong>1</strong> + <span class="round frac"><strong class="fsi num">LC</strong><strong class="fsi num">BIC</strong></span><strong class="math-up">0.8</strong>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row">자본량<br>(ORC)</th>
											<td>
												<p><strong class="fsi">ORC</strong> = <strong class="fsi">BIC</strong> + <strong class="fsi">ILM</strong></p>
											</td>
										</tr>
										<tr>
											<th scope="row">위험가중자산<br>OpRWA</th>
											<td>
												<p><strong class="fsi">OpRWA</strong> = <strong class="fsi">ORC</strong> &times; <strong>12.5</strong></p>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="alert alert-warning">
								<ul class="ul dash">
									<li>설립 또는 편입 <strong>3년 미만</strong>인 자회사는 <strong>설립 또는 편입시점을 기준</strong>으로 1년 단위로 재무제표를 구성하며, 1년 미만으로 구성된 재무제표의 <strong>손익계산서(PL)는 연환산(12/n)하여 영업지수를 산출</strong>함</li>
									<li>설립일 기준 10년 미만(편입일 무관) 자회사의 손실요소는 <strong>해당기간의 연평균 손실금액 X 15</strong>로 산출함</li>
								</ul>
							</div>
						</div>	
					</div>
				


				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-close" onclick="modalGuide_close();">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close" onclick="modalGuide_close();"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- tip //-->
	
	<script>
		$("input:text[numberOnly]").on("keyup", function(){
			$(this).val($(this).val().replace(/[^0-9.-]/g,""));
		});
	</script>
</body>
</html>