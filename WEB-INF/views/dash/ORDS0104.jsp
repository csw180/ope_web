<%--
/*---------------------------------------------------------------------------
 Program ID   : ORDS0104.jsp
 Program name : 본부부서 KRI
 Description  : 화면코드 DASH-04
 Programer    : 박승윤
 Date created : 2022.06.22
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList"); //지표발생정보
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList"); //전년동월대비발생추이
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList"); //전행발생현황
if(vLst3==null) vLst3 = new Vector();

HashMap hMap = null;
if(vLst.size()>0){
	hMap = (HashMap)vLst.get(0);
}else{
	hMap = new HashMap();
}
HashMap hMap2 = null;
if(vLst2.size()>0){
	hMap2 = (HashMap)vLst2.get(0);
}else{
	hMap2 = new HashMap();
}
HashMap hMap3 = null;
if(vLst3.size()>0){
	hMap3 = (HashMap)vLst3.get(0);
}else{
	hMap3 = new HashMap();
}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>계열사 ORM KRI조회</title>
	<script>
	$(function(){
		chartDraw_1(chart_grade);
		chartDraw_2(chart_grade);

		initIBSheet();
	})
	
	// 차트 색상 지정
	var chart_grade = gridColor.red;
	
	
	// 전년 동월 대비 발생 추이 / 등급 비교
	function chartDraw_1(color){
		myChart_1.RemoveAll();
		myChart_1.SetOptions(initChartType);
		myChart_1.SetOptions(dasKriLine, 1);
		
		var category = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"];

		myChart_1.SetSeriesOptions([
			{
				name : "2022",
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
					[category[10],	38],
					[category[11],	25],
				],
				color : gridColor.gray,
			},
			{
				name : "2023",
				data : [
					[category[0],	68], 
					[category[1],	57], 
					[category[2],	112], 
					[category[3],	78], 
					[category[4],	55], 
					[category[5],	80], 
				],
				color : color,
			},
		], 1);
		
		myChart_1.SetXAxisOptions({
			Categories : category
		}, 1);
		
		myChart_1.Draw();
	}
	
	
	
	
	// 전행 발생 현황
	var data_chart_2 = [
		["구리금융센터",	3,	"yellow"],
		["강남금융센터",	1,	"red"],
		["반포금융센터",	2,	"green"],
		["신촌금융센터",	4,	"yellow"],
		["종로금융센터",	5,	"green"],
	];
	
	function chartDraw_2(color){
		myChart_2.RemoveAll();
		myChart_2.SetOptions(initChartType);
		myChart_2.SetOptions(dasKriPie, 1);
		myChart_2.SetOptions({
			ToolTip : {
				BorderColor : color
			}
		}, 1);
		
		myChart_2.SetSeriesOptions([
			{
				data : data_chart_2
			}
		], 1);
		
		kriAllChartColor(color);
		
		myChart_2.Draw();
	}
	
	
	function myChart_1_OnPointClick(Index, X, Y) {
		//alert(Index + "번째 그래프의 " + X + "번 값은 " + Y + "입니다.");
		viewKriGrade("kriGrade", Index, X);
	}
	
	function myChart_2_OnPointClick(Index, X, Y) {
		//alert(Index + "번째 그래프의 " + X + "번 값은 " + Y + "입니다.");
		document.getElementById('kri_all_name').innerText = data_chart_2[X][0];
		document.getElementById('kri_all_cnt').innerText = data_chart_2[X][1];
		document.getElementById('kri_all_grade').innerText = data_chart_2[X][2].toUpperCase();
		document.getElementById('kri_all_grade').className = "tb-grade-" + data_chart_2[X][2];
	}


	
	
	// mySheet
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
				$("form[name=ormsForm] [name=process_id]").val("ORDS010402");
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
									<button type="button" class="btn-tab red active" onclick="">RED : <span>87</span></button>
								</li>
								<li>
									<button type="button" class="btn-tab yellow" onclick="">YELLOW : <span>280</span></button>
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
														<input type="text" name="" id="" class="form-control w400" value="휴면 계좌 출금 건 수" readonly>
													</td>
													<th>지표코드</th>
													<td>
														<input type="text" name="" id="" class="form-control w80" value="K00XX" readonly>
													</td>
													<th>기준월</th>
													<td>
														<select name="" id="" class="form-control w100">
															<option value="">23-06</option>
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
													<th scope="col">관리부서</th>
													<th scope="col" class="w80">단위</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr style="height: 66px;">
													<td>수신마케팅팀</td>
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
													<td class="tb-grade-red">RED</td>
													<td>9</td>
													<td>13</td>
													<td>6.17</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="row">
								<section class="col w60p">
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
								<section class="col w40p">
									<div class="box-header">
										<h4 class="box-title sm">전행 발생 현황</h4>
									</div>
									<div class="wrap-chart kri-all-chart h300">
										<script>
											createIBChart("myChart_2", "100%", "100%");
										</script>
									</div>
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col">발생 부점</th>
													<th scope="col" class="w90">발생 건 수</th>
													<th scope="col" class="w130">부점 內 지표 등급</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr style="height: 43px;">
													<td id="kri_all_name">-</td>
													<td><strong id="kri_all_cnt">-</strong> 건</td>
													<td id="kri_all_grade">-</td>
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
		<!-- content //-->
			</form>
		</div>
		<!-- content //-->

</body>
</html>