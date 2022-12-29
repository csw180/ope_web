<%--
/*---------------------------------------------------------------------------
 Program ID   : ORDS0101.jsp
 Program name : 영업점 메인화면
 Description  : 화면코드 DASH-05
 Programer    : 박승윤
 Date created : 2022.06.22
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>계열사 ORM KRI조회</title>
	<script>
	$(function(){
		chartDraw_1();
		
		initIBSheet1();
		initIBSheet2();
	})
	
	
	// 부서 관리 지표 발생 현황
	function chartDraw_1(){
		myChart_1.RemoveAll();
		myChart_1.SetOptions(initChartType);

		myChart_1.SetOptions({
			ToolTip : {
				valueSuffix : " 건",
			}
		}, 1);
		
		var category = ["23.01", "23.02", "23.03", "23.04", "23.05", "23.06"];

		myChart_1.SetSeriesOptions([
			{
				type : "line",
				name : "구리금융센터 RED 등급",
				data : [
					[category[0],	0], 
					[category[1],	2], 
					[category[2],	1], 
					[category[3],	3], 
					[category[4],	3], 
					[category[5],	5], 
				],
				color : gridColor.red,
			},
			{
				type : "line",
				name : "전 영업점 평균",
				data : [
					[category[0],	2.2], 
					[category[1],	2], 
					[category[2],	2.6], 
					[category[3],	1.9], 
					[category[4],	1.6], 
					[category[5],	3], 
				],
				color : gridColor.gray,
			},
		], 1);
		
		myChart_1.SetXAxisOptions({
			Categories : category
		}, 1);

		
		myChart_1.Draw();
	}
	
	// mySheet1
	function initIBSheet1() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "사번",			Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 60 },
			{ Header: "성명",			Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 60 },
			{ Header: "발생지표개수",	Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 80 },
			{ Header: "최다발생지표",	Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 200 },
		];
		IBS_InitSheet(mySheet1, initdata);
		mySheet1.SetSelectionMode(4);
		doAction('search1');
	}	
	// mySheet2
	function initIBSheet2() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "업무",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "전월등급",	Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "당월등급",	Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "지표명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 300 },
			{ Header: "단위",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
		];
		IBS_InitSheet(mySheet2, initdata);
		mySheet2.SetSelectionMode(4);
		doAction('search2');
	}	
	function doAction(sAction) {
		switch(sAction) {
			case "search1": 
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010502");
				mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				break;
			case "search2": 
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010503");
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				break;
		}
	}

	</script>
</head>
<body>
	<div class="container">
		<!-- page-header -->
		<%@ include file="../comm/header.jsp" %>
		<!--.page header //-->
	<form name="ormsForm">
		<input type="hidden" id="path" name="path" />
		<input type="hidden" id="process_id" name="process_id" />
		<input type="hidden" id="commkind" name="commkind" />
		<input type="hidden" id="method" name="method" />
		
		<input type="hidden" id="bas_ym" name="bas_ym" /> <!-- 기준년월 -->
		<input type="hidden" id="lv1_bsn_prss_c" name="lv1_bsn_prss_c" /> <!-- 1레벨 업무프로세스코드 -->

			<!-- content -->
		<div class="content">

			<div class="row">
				<div class="col w300">
				
					<!-- 운영리스크 업무 처리 현황 -->
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">운영리스크 업무 처리 현황</h2>
						</div>
						<div class="risk-status-wrap branch">
							<article class="risk-status">
								<h3 class="title dash-title">
									RCSA
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
								<div class="status-area finish"><!-- [D] 기본상태 : 평가기간아님 or 해당없음 / ing : 미완료 / finish : 완료 -->
									<p class="date"><strong>23. 02</strong> 회</p>
									<p class="status">완료</p>
								</div>
								<div class="risk-status-list-wrap">
									<ul class="risk-status-list">
										<li>
											<p class="subject">변경 사항 검토</p>
											<p class="finish">완료</p>
										</li>
										<li>
											<p class="subject">평가자 지정</p>
											<p class="finish">완료</p>
										</li>
										<li>
											<p class="subject">평가 수행</p>
											<p class="finish">완료</p>
										</li>
										<li>
											<p class="subject">결과 검토</p>
											<p class="finish">완료</p>
										</li>
										<li>
											<p class="subject">대응방안 수립</p>
											<p class="finish">완료</p>
										</li>
										<li>
											<p class="subject">대응방안 이행</p>
											<p class="finish">완료</p>
										</li>
									</ul>
								</div>
							</article>
							
							<article class="risk-status">
								<h3 class="title dash-title">
									손실
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
								<div class="status-area finish">
									<p class="date"><strong>23. 06</strong> 월</p>
									<p class="status">완료</p>
								</div>
								<div class="risk-status-list-wrap">
									<ul class="risk-status-list">
										<li>
											<p class="subject">사건 정보 입력</p>
											<p class="finish">완료</p>
										</li>
										<li>
											<p class="subject">G/L 계정 모니터링</p>
											<p class="finish">완료</p>
										</li>
									</ul>
								</div>
							</article>
							
						</div>
					</section>
					<!-- 운영리스크 업무 처리 현황 //-->
					
				</div>	
				<div class="col">
				
					<!-- 운영리스크 주요 정보 -->
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">운영리스크 주요 정보</h2>
						</div>
						
						<div class="row">
							<div class="col w30p">
								
								<!-- 전 영업점 지표 발생 현황 -->
								<article class="box-dash h310">
									<h3 class="title dash-title">
										전 영업점 지표 발생 현황
										<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
									</h3>
									<dl class="risk-status-rank">
										<dt>전체 영업점 내 순위</dt>
										<dd>25</dd>
										<dd>132</dd>
									</dl>
									<div class="wrap-table">
										<table class="risk-rank-table">
											<colgroup>
												<col style="width: 40px;">
												<col style="width: 40px;">
												<col>
												<col style="width: 40px;">
												<col style="width: 40px;">
											</colgroup>
											<thead>
												<tr>
													<th scope="col" colspan="2">순위</th>
													<th scope="col">지점명</th>
													<th scope="col" class="tb-grade-red">R</th>
													<th scope="col" class="tb-grade-yellow">Y</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr>
													<td rowspan="3">상위<br>지점</td>
													<td>1</td>
													<td class="left">동대문 금융센터</td>
													<td>0</td>
													<td>0</td>
												</tr>
												<tr>
													<td>2</td>
													<td class="left">마포금융센터</td>
													<td>0</td>
													<td>2</td>
												</tr>
												<tr>
													<td>3</td>
													<td class="left">종로5가역 지점</td>
													<td>1</td>
													<td>4</td>
												</tr>
											</tbody>
											<tfoot class="center">
												<tr>
													<td>우리<br>지점</td>
													<td>25</td>
													<td class="left">구리금융센터</td>
													<td>4</td>
													<td>42</td>
												</tr>
											</tfoot>
										</table>
									</div>
								</article>
								<!-- 전 영업점 지표 발생 현황 //-->
								
								<!-- 개인별 지표 발생 현황 -->
								<article class="box-dash h320">
									<h3 class="title dash-title">
										개인별 지표 발생 현황
										<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
									</h3>
									<div class="wrap-grid h250 mt5">
										<script> createIBSheet("mySheet1", "100%", "100%"); </script>
									</div>
								</article>
								<!-- 개인별 지표 발생 현황 //-->
								
							</div>
							<div class="col w70p">
								<div class="box-dash h640">
								
									<!-- 지표 발생 현황 -->
									<article>
										<h3 class="title dash-title">
											구리금융센터 지표 발생 현황
											<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
										</h3>
										<p class="date"><strong>2023 - 06</strong> 기준</p>
										<div class="row">
											<div class="col w200">
												<div class="wrap-table">
													<table class="risk-info-table">
														<thead>
															<tr>
																<th scope="col">등급</th>
																<th scope="col">발생현황</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td class="tb-grade-red">R</td>
																<td>5</td>
															</tr>
															<tr>
																<td class="tb-grade-yellow">Y</td>
																<td>42</td>
															</tr>
															<tr>
																<td class="tb-grade-green">G</td>
																<td>164</td>
															</tr>
														</tbody>
														<tfoot>
															<tr>
																<td>계</td>
																<td>31</td>
															</tr>
														</tfoot>
													</table>
												</div>
											</div>
											<div class="col">
												<div class="wrap-chart h240">
													<script>
														createIBChart("myChart_1", "100%", "100%");
													</script>
												</div>
											</div>
										</div>
									</article>
									<!-- 지표 발생 현황 //-->
									
									<!-- 당월 RED 등급 지표 -->
									<article class="">
										<h3 class="title dash-title">
											구리금융센터 당월 RED 등급 지표
											<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
										</h3>
										<ul class="dash-tab"> 	
											<li>
												<button type="button" class="btn-tab active" onclick="">종합</button>
											</li>
											<li>
												<button type="button" class="btn-tab" onclick="">여신</button>
											</li>
											<li>
												<button type="button" class="btn-tab" onclick="">수신</button>
											</li>
											<li>
												<button type="button" class="btn-tab" onclick="">외환</button>
											</li>
											<li>
												<button type="button" class="btn-tab" onclick="">카드</button>
											</li>
											<li>
												<button type="button" class="btn-tab" onclick="">방카</button>
											</li>
											<li>
												<button type="button" class="btn-tab" onclick="">온라인</button>
											</li>
											<li>
												<button type="button" class="btn-tab" onclick="">기타</button>
											</li>
										</ul>
										<div class="wrap-grid h250">
											<script> createIBSheet("mySheet2", "100%", "100%"); </script>
										</div>
									</article>
									<!-- 당월 RED 등급 지표 //-->
								</div>
							</div>
						</div>
					</section>
					<!-- 운영리스크 주요 정보 //-->
				
				</div>
			</div>

		</div>
		<!-- content //-->
			</form>
		</div>
		<!-- content //-->

</body>
</html>