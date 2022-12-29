<%--
/*---------------------------------------------------------------------------
 Program ID   : ORDS0102.jsp
 Program name : ORM KRI
 Description  : 화면코드 DASH-02
 Programer    : 박승윤
 Date created : 2022.06.22
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList"); //본부부서 차트
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList"); //영업점 차트
if(vLst2==null) vLst2 = new Vector();

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

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>계열사 ORM KRI조회</title>
	<script>
	$(function(){
		chartDraw_1(chart_grade_1);
		chartDraw_2(chart_grade_2);

		initIBSheet1();
		initIBSheet2();
		initIBSheet3();
		initIBSheet4();
	})
	
	// 차트 색상 지정
	var chart_grade_1 = gridColor.red;
	var chart_grade_2 = gridColor.yellow;
	
	
	// 본부부서
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
	
	
	
	// 영업점
	function chartDraw_2(color){
		myChart_2.RemoveAll();
		myChart_2.SetOptions(initChartType);
		myChart_2.SetOptions(dasKriLine, 1);
		
		var category = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"];

		myChart_2.SetSeriesOptions([
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
		
		myChart_2.SetXAxisOptions({
			Categories : category
		}, 1);

		
		myChart_2.Draw();
	}
	
	
	function myChart_1_OnPointClick(Index, X, Y) {
		//alert(Index + "번째 그래프의 " + X + "번 값은 " + Y + "입니다.");
		viewKriGrade("kriGrade1", Index, X);
	}
	
	function myChart_2_OnPointClick(Index, X, Y) {
		//alert(Index + "번째 그래프의 " + X + "번 값은 " + Y + "입니다.");
		viewKriGrade("kriGrade2", Index, X);
	}


	
	
	// mySheet1
	function initIBSheet1() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "지표명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 150 },
			{ Header: "단위",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
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
			{ Header: "순위",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 40 },
			{ Header: "본부명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 150 },
			{ Header: "R",			Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "Y",			Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
		];
		IBS_InitSheet(mySheet2, initdata);
		mySheet2.SetSelectionMode(4);
		doAction('search2');
	}		
	
	
	// mySheet3
	function initIBSheet3() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "영역",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "지표명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 150 },
			{ Header: "단위",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
		];
		IBS_InitSheet(mySheet3, initdata);
		mySheet3.SetSelectionMode(4);
		doAction('search3');
	}			
	

	// mySheet4
	function initIBSheet4() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "순위",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 40 },
			{ Header: "본부명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 150 },
			{ Header: "R",			Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "Y",			Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
		];
		IBS_InitSheet(mySheet4, initdata);
		mySheet4.SetSelectionMode(4);
		doAction('search4');
	}
	
	function doAction(sAction) {
		switch(sAction) {
			case "search1": 
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010202");
				mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				break;
			case "search2": 
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010203");
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				break;
			case "search3": 
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010204");
				mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				break;
			case "search4": 
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010205");
				mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
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
			<!-- 운영리스크 업무 처리 현황 -->
				<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">KRI 현황</h2>
				</div>
				
				
				<!-- 본부부서 관리 지표 발생 현황 -->
				<article class="box-dash h320">
					<div class="box-header">
						<h3 class="title dash-title">
							본부부서 관리 지표 발생 현황
							<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
						</h3>
					</div>
					<div class="row">
						<section class="col kri-status-wrap">
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
							<div class="wrap-grid h200">
								<script> createIBSheet("mySheet1", "100%", "100%"); </script>
							</div>
						</section>
						<section class="col">
							<div class="box-header">
								<h4 class="box-title sm">전년 동월 대비 발생 추이 / 등급 비교</h4>
							</div>
							<div class="wrap-chart h170">
								<script>
									createIBChart("myChart_1", "100%", "100%");
								</script>
							</div>
							<div id="kriGrade1" class="kri-month-wrap">
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
							<div class="wrap-grid h250">
								<script> createIBSheet("mySheet2", "100%", "100%"); </script>
							</div>
						</section>
					</div>
				</article>
				<!-- 본부부서 관리 지표 발생 현황 //-->
				<!-- 영업점 관리 지표 발생 현황 -->
				<article class="box-dash h320">
					<div class="box-header">
						<h3 class="title dash-title">
							영업점 관리 지표 발생 현황
							<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
						</h3>
					</div>
					<div class="row">
						<section class="col kri-status-wrap">
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
							<div class="wrap-grid h200">
								<script> createIBSheet("mySheet3", "100%", "100%"); </script>
							</div>
						</section>
						<section class="col">
							<div class="box-header">
								<h4 class="box-title sm">전년 동월 대비 발생 추이 / 등급 비교</h4>
							</div>
							<div class="wrap-chart h170">
								<script>
									createIBChart("myChart_2", "100%", "100%");
								</script>
							</div>
							<div id="kriGrade2" class="kri-month-wrap">
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
									<dd class="yellow">6</dd>
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
							<div class="wrap-grid h250">
								<script> createIBSheet("mySheet4", "100%", "100%"); </script>
							</div>
						</section>
					</div>
				</article>
				<!-- 영업점 관리 지표 발생 현황 //-->
			</section>
			<!-- 운영리스크 주요 정보 //-->
			</form>
		</div>
		<!-- content //-->

</body>
</html>