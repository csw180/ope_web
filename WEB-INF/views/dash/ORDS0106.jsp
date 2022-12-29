<%--
/*---------------------------------------------------------------------------
 Program ID   : ORDS0106.jsp
 Program name : 영업점 KRI
 Description  : 화면코드 DASH-01
 Programmer    : 박승윤
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
	<title>영업점 KRI조회</title>
	<script>
	$(function(){
		initIBSheet();
		chartDraw_1();
		chartDraw_2();
		chartDraw_3();
		chartDraw_4();
	})
	
	// 누적 손실 금액 - 원형차트
	function chartDraw_1(){
		myChart_1.RemoveAll();
		myChart_1.SetOptions(initChartType);
		myChart_1.SetOptions(dasLosChart, 1);
		
		myChart_1.SetSeriesOptions([
			{
				data : [
					["소매금융",		289085843],
					["손실사건 제목",	150333154],
					["손실사건 제목2",	1225126051]
				]
			}
		], 1);
		myChart_1.Draw();
	}
	
	
	
	// 누적 손실 금액 - 라인차트
	function chartDraw_2(){
		myChart_2.RemoveAll();
		myChart_2.SetOptions(initChartType);
		myChart_2.SetOptions(chartSecY, 1);
		
		var category = ["2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022"];

		myChart_2.SetSeriesOptions([
			{
				type : "area",
				name : "누적 손실 금액",
				data : [
					[category[0],	10], 
					[category[1],	30], 
					[category[2],	5], 
					[category[3],	22], 
					[category[4],	43], 
					[category[5],	50], 
					[category[6],	60], 
					[category[7],	15], 
					[category[8],	30], 
					[category[9],	40],
				],
				color : gridColor.blue,
				FillColor : gridColor.blue_bg,
				ToolTip : {
					valueSuffix : " 억원",
				}
			},
			{
				type : "line",
				name : "손실 발생 건 수",
				data : [
					[category[0],	68], 
					[category[1],	57], 
					[category[2],	112], 
					[category[3],	78], 
					[category[4],	55], 
					[category[5],	80], 
					[category[6],	100], 
					[category[7],	180], 
					[category[8],	98], 
					[category[9],	150],
				],
				color : gridColor.gray,
				yAxis : 1,
				ToolTip : {
					valueSuffix : " 건",
				}
			},
		], 1);
		
		myChart_2.SetXAxisOptions({
			Categories : category
		}, 1);

		
		myChart_2.Draw();
	}
	
	
	
	// 규제 자본 산출 결과
	function chartDraw_3(){
		myChart_3.RemoveAll();
		myChart_3.SetOptions(initChartType);
		myChart_3.SetOptions(dasRepcapChart, 1);
		
		var category = ["2022.3Q", "2022.4Q", "2023.1Q", "2023.2Q"];

		myChart_3.SetSeriesOptions([
			{
				name : category[0],
				data : [
					[category[0],	8215],
					[category[1],	7437], 
					[category[2],	7653], 
					[category[3],	8289], 
				],
				DataLabels : {
					Enabled:true,
					Formatter:function(){
					    return this.y;
					}
				},
			},
		], 1);

		
		myChart_3.SetXAxisOptions({
			Categories : category
		}, 1);
		
		myChart_3.Draw();
	}
	
	
	
	// 내부 자본 산출 결과
	function chartDraw_4(){
		myChart_4.RemoveAll();
		myChart_4.SetOptions(initChartType);
		myChart_4.SetOptions(dasIntcapChart, 1);
		
		var category = ["전월한도소진율", "당월한도소진율", "총 한도"];

		myChart_4.SetSeriesOptions([
			{
				name : category[2],
				data : [
					[category[2],	100],
				],
				DataLabels : {
					Enabled:true,
					Formatter:function(){
					    return "총 한도";
					}
				},
			},
			{
				name : category[1],
				data : [
					[category[1],	77.1], 
				],
			},
			{
				name : category[0],
				data : [
					[category[0],	68.2], 
				],
			},
		], 1);
		
		myChart_4.SetXAxisOptions({
			Categories : category
		}, 1);
		
		myChart_4.Draw();
	}
	
	function initIBSheet() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "지표명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 200 },
			{ Header: "단위",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
		];
		IBS_InitSheet(mySheet, initdata);
		mySheet.SetSelectionMode(4);
		doAction('search');
	}	
	function doAction(sAction) {
		switch(sAction) {
			case "search": //관리지표발생현황
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010602");
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
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

			<div class="content">
		
		
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">KRI 현황</h2>
				</div>
				
				<div class="row">
					<div class="col w30p">
					
						<!-- 관리 지표 발생 현황 -->
						<article class="box-dash h660">
							<div class="box-header">
								<h3 class="title dash-title">
									관리 지표 발생 현황
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
							</div>
							<ul class="dash-tab"> 	
								<li>
									<button type="button" class="btn-tab red" onclick="">RED : <span>87</span></button>
								</li>
								<li>
									<button type="button" class="btn-tab yellow active" onclick="">YELLOW : <span>280</span></button>
								</li>
								<li>
									<button type="button" class="btn-tab green" onclick="">GREEN : <span>663</span></button>
								</li>
							</ul>
							<div class="wrap-grid h550">
								<script> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</article>
						<!-- 관리 지표 발생 현황 //-->
					</div>
					<div class="col w70p">
					
						<!-- 지표 발생 정보 -->
						<article class="box-dash h660">
							<div class="box-header">
								<h3 class="title dash-title">
									지표 발생 정보
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
							</div>
							<p class="date"><strong>2023 - 06</strong> 기준</p>
							<div class="box-header">
								<div>
									<div class="wrap-search ib">
										<table>
											<tbody>
												<tr>
													<th>지표명</th>
													<td>
														<input type="text" name="" id="" class="form-control w400" value="만기 경과 예적금 담보 여신 미회수 건 수" readonly>
													</td>
													<th>지표코드</th>
													<td>
														<input type="text" name="" id="" class="form-control w80" value="K00XX" readonly>
													</td>
													<th>기준일</th>
													<td>
														<select name="" id="" class="form-control w130">
															<option value="">23. 06-01 (목)</option>
														</select>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="box row">
								<div class="col w40p">
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col">업무영역</th>
													<th scope="col" class="w80">단위</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr style="height: 66px;">
													<td>여신</td>
													<td>건수</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="col w60p">
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col" colspan="2">등급</th>
													<th scope="col" colspan="3">발생추이</th>
												</tr>
												<tr>
													<th scope="col">전월</th>
													<th scope="col">당월</th>
													<th scope="col">전월</th>
													<th scope="col">당월</th>
													<th scope="col">6개월평균</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr>
													<td class="tb-grade-yellow">YELLOW</td>
													<td class="tb-grade-yellow">YELLOW</td>
													<td>9</td>
													<td>7</td>
													<td>7.21</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="row">
								<section class="col">
									<div class="box-header">
										<h4 class="box-title sm">전년 동월 대비 발생 추이 / 등급 비교</h4>
									</div>
									<div class="wrap-chart h330">
										<script>
											createIBChart("myChart_1", "100%", "100%");
										</script>
									</div>
									<div id="kriGrade" class="kri-month-wrap">
										<dl class="kri-month">
											<dt>2022</dt>
											<dd class="green">1</dd>
											<dd class="green">2</dd>
											<dd class="green">3</dd>
											<dd class="yellow">4</dd>
											<dd class="yellow">5</dd>
											<dd class="yellow">6</dd>
											<dd class="yellow">7</dd>
											<dd class="green">8</dd>
											<dd class="green">9</dd>
											<dd class="green">10</dd>
											<dd class="green">11</dd>
											<dd class="green">12</dd>
										</dl>
										<dl class="kri-month">
											<dt>2023</dt>
											<dd class="green">1</dd>
											<dd class="green">2</dd>
											<dd class="green">3</dd>
											<dd class="yellow">4</dd>
											<dd class="yellow">5</dd>
											<dd class="red">6</dd>
											<dd>7</dd>
											<dd>8</dd>
											<dd>9</dd>
											<dd>10</dd>
											<dd>11</dd>
											<dd>12</dd>
										</dl>
									</div>
								</section>
								<section class="col">
									<div class="box-header">
										<h4 class="box-title sm">전영업점 발생 현황</h4>
									</div>
									<div class="row kri-all-chart-branch">
										<div class="col">
											<div class="wrap-chart h300">
												<div class="kri-all-chart-detail">
													<p class="subject">전월 (2023.05)</p>
													<p class="total"><strong>20</strong>건</p>
												</div>
												<script>
													createIBChart("myChart_2", "100%", "100%");
												</script>
											</div>
										</div>
										<div class="col">
											<div class="wrap-chart h300">
												<div class="kri-all-chart-detail">
													<p class="subject">당월 (2023.05)</p>
													<p class="total"><strong>87</strong>건</p>
												</div>
												<script>
													createIBChart("myChart_3", "100%", "100%");
												</script>
											</div>
										</div>
									</div>
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col">전 월 비중</th>
													<th scope="col" class='tb-grade-yellow'>당 월 비중</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr style="height: 43px;">
													<td><strong>34</strong> %</td>
													<td><strong>8</strong> %</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
							</div>
						</article>
						<!-- 지표 발생 정보 //-->
					</div>
				</div>
			</section>
		</div>
			</form>
		</div>
		<!-- content //-->

</body>
</html>