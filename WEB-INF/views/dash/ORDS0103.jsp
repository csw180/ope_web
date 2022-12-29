<%--
/*---------------------------------------------------------------------------
 Program ID   : ORDS0103.jsp
 Program name : 본부부서 메인화면
 Description  : 화면코드 DASH-03
 Programer    : 박승윤
 Date created : 2022.06.22
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList"); //RCSA
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList"); //KRI
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList"); //손실
if(vLst3==null) vLst3 = new Vector();
Vector vLst4= CommUtil.getResultVector(request, "grp01", 0, "unit04", 0, "vList"); //BIA
if(vLst4==null) vLst4 = new Vector();
Vector vLst5= CommUtil.getResultVector(request, "grp01", 0, "unit05", 0, "vList"); //부서 관리 지표 발생 현황
if(vLst5==null) vLst5 = new Vector();

String bia_yn = ""; //평가기간 체크(vLst4 값 있으면 Y)
HashMap hMap4 = null;
if(vLst4.size()>0){
	hMap4 = (HashMap)vLst4.get(0);
	bia_yn = "Y";
}else{
	bia_yn = "N";
}
String bia_c = "N"; //완료여부
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>계열사 ORM KRI조회</title>
	<script>
	$(function(){
		chartDraw_1();
		
		initIBSheet();
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
				name : "RED",
				data : [
					[category[0],	0], 
					[category[1],	3], 
					[category[2],	2], 
					[category[3],	5], 
					[category[4],	3], 
					[category[5],	7], 
				],
				color : gridColor.red,
			},
			{
				type : "line",
				name : "YELLOW",
				data : [
					[category[0],	2], 
					[category[1],	7], 
					[category[2],	4], 
					[category[3],	6], 
					[category[4],	8], 
					[category[5],	9], 
				],
				color : gridColor.yellow,
			},
		], 1);
		
		myChart_1.SetXAxisOptions({
			Categories : category
		}, 1);

		
		myChart_1.Draw();
	}
	
	

	// mySheet
	function initIBSheet() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "전월등급",	Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "당월등급",	Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "지표명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 150 },
			{ Header: "단위",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
		];
		IBS_InitSheet(mySheet, initdata);
		mySheet.SetSelectionMode(4);
		doAction('search');
	}	
	
	function doAction(sAction) {
		switch(sAction) {
			case "search": 
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("das");
				$("form[name=ormsForm] [name=process_id]").val("ORDS010302");
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
			<div class="row">
				<div class="col">
				
					<!-- 운영리스크 업무 처리 현황 -->
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">운영리스크 업무 처리 현황</h2>
						</div>
						<div class="risk-status-wrap">
							<article class="risk-status">
								<h3 class="title dash-title">
									RCSA
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
								<div class="status-area ing"><!-- [D] 기본상태 : 평가기간아님 or 해당없음 / ing : 미완료 / finish : 완료 -->
									<p class="date"><strong>23. 02</strong> 회</p>
									<p class="status">미완료</p>
								</div>
								<div class="risk-status-list-wrap">
									<table class="risk-status-table">
										<thead>
											<tr>
												<th></th>
												<th scope="col" title="상품개발팀"></th>
												<th scope="col" title="여신마케팅팀"></th>
												<th scope="col" title="수신마케팅팀"></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th scope="row">변경 사항 검토</th>
												<td class="finish">완료</td>
												<td class="finish">완료</td>
												<td class="finish">완료</td>
											</tr>
											<tr>
												<th scope="row">평가자 지정</th>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
											</tr>
											<tr>
												<th scope="row">평가 수행</th>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
											</tr>
											<tr>
												<th scope="row">결과 검토</th>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
											</tr>
											<tr>
												<th scope="row">대응방안 수립</th>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
											</tr>
											<tr>
												<th scope="row">대응방안 이행</th>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
											</tr>
										</tbody>
									</table>
								</div>
							</article>
							
							<article class="risk-status">
								<h3 class="title dash-title">
									KRI
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
								<div class="status-area finish">
									<p class="date"><strong>23. 02</strong> 회</p>
									<p class="status">완료</p>
								</div>
								<div class="risk-status-list-wrap">
									<table class="risk-status-table">
										<thead>
											<tr>
												<th></th>
												<th scope="col" title="상품개발팀"></th>
												<th scope="col" title="여신마케팅팀"></th>
												<th scope="col" title="수신마케팅팀"></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th scope="row">수기 지표 입력</th>
												<td class="finish">완료</td>
												<td class="finish">완료</td>
												<td class="finish">완료</td>
											</tr>
											<tr>
												<th scope="row">모니터링</th>
												<td class="ing">미완료</td>
												<td class="finish">완료</td>
												<td class="finish">완료</td>
											</tr>
											<tr>
												<th scope="row">대응 방안 검토</th>
												<td class="ing">미완료</td>
												<td class="ing">미완료</td>
												<td class="finish">완료</td>
											</tr>
										</tbody>
									</table>
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
							
							<article class="risk-status">
								<h3 class="title dash-title">
									BIA
								</h3>
<%if(bia_yn.equals("Y")){ %>
								<p class="period">평가 기간 : <strong><%=(String)hMap4.get("bia_evl_st_dt") %></strong> ~ <strong><%=(String)hMap4.get("bia_evl_ed_dt") %></strong></p>
<%} %>
								<div class="status-area">
<%if(bia_yn.equals("N")){ %>
									<p class="status">평가 기간 아님</p>
<%}else if (bia_yn.equals("Y")){ %>
									<p class="date"><strong><%=(String)hMap4.get("bia_yy")%></strong> 년</p>
	<%if(bia_c.equals("Y")){ %>
									<p class="status">완료</p>
	<%}else{%>
									<p class="status">미완료</p>
	 
	<%}
}%>
								</div>
								<div class="risk-status-list-wrap">
									<table class="risk-status-table" style="overflow-x:scroll">
										<thead>
											<tr>
												<th></th>
<%if (bia_yn.equals("Y")){ %>
	<%for(int i=0; i<vLst4.size(); i++) {
		hMap4 = (HashMap)vLst4.get(i);
		%>
												<th scope="col" title="<%=(String)hMap4.get("brnm")%>"></th>
												
	<%} %>
<%} %>
											</tr>
										</thead>
										<tbody>
<%if(bia_yn.equals("N")){ %>
											<tr>
												<th scope="row">평가자 지정</th>
												<td>평가 기간 아님</td>
											</tr>
											<tr>
												<th scope="row">평가 수행</th>
												<td>평가 기간 아님</td>
											</tr>
											<tr>
												<th scope="row">부서 결과 검토</th>
												<td>평가 기간 아님</td>
											</tr>
											<tr>
												<th scope="row">ORM 결과 검토</th>
												<td>평가 기간 아님</td>
											</tr>
											<tr>
												<th scope="row">BCP 결과 검토</th>
												<td>평가 기간 아님</td>
											</tr>
<%
}else if (bia_yn.equals("Y")){ 
%>
											<tr>
												<th scope="row">평가자 지정</th>
<%
for(int i=0; i<vLst4.size(); i++){
	hMap4 = (HashMap)vLst4.get(i);
	String bia_01 = new String((String)hMap4.get("bia_01"));
	if(bia_01.equals("Y")){
%>
											<td>완료</td>
<%}else if(bia_01.equals("N")){ %>
											<td style="color:red">미완료</td>
<%	}
}%>
											</tr>
											<tr>
												<th scope="row">평가 수행</th>
<%
for(int i=0; i<vLst4.size(); i++){
	hMap4 = (HashMap)vLst4.get(i);
	String bia_02 = new String((String)hMap4.get("bia_02"));
	if(bia_02.equals("Y")){
%>
											<td>완료</td>
<%}else if(bia_02.equals("N")){ %>
											<td style="color:red">미완료</td>
<%	}
}%>
											</tr>
											<tr>
												<th scope="row">부서 결과 검토</th>
<%
for(int i=0; i<vLst4.size(); i++){
	hMap4 = (HashMap)vLst4.get(i);
	String bia_03 = new String((String)hMap4.get("bia_03"));
	if(bia_03.equals("Y")){
%>
											<td>완료</td>
<%}else if(bia_03.equals("N")){ %>
											<td style="color:red">미완료</td>
<%	}
}%>
											</tr>
											<tr>
												<th scope="row">ORM 결과 검토</th>
<%
for(int i=0; i<vLst4.size(); i++){
	hMap4 = (HashMap)vLst4.get(i);
	String bia_04 = new String((String)hMap4.get("bia_04"));
	if(bia_04.equals("Y")){
%>
											<td>완료</td>
<%}else if(bia_04.equals("N")){ %>
											<td style="color:red">미완료</td>
<%	}
}%>
											</tr>
											<tr>
												<th scope="row">BCP 결과 검토</th>
<%
for(int i=0; i<vLst4.size(); i++){
	hMap4 = (HashMap)vLst4.get(i);
	String bia_05 = new String((String)hMap4.get("bia_05"));
	if(bia_05.equals("Y")){
%>
											<td>완료</td>
<%}else if(bia_05.equals("N")){ %>
											<td style="color:red">미완료</td>
<%	}
}%>
											</tr>
<%}%>
										</tbody>
									</table>
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
						
						<div class="box-dash h640">
							<p class="date"><strong>2023 - 06</strong> 기준</p>
						
							<!-- 부서 관리 지표 발생 현황 -->
							<article>
								<h3 class="title dash-title">
									부서 관리 지표 발생 현황
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
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
														<td>7</td>
													</tr>
													<tr>
														<td class="tb-grade-yellow">Y</td>
														<td>9</td>
													</tr>
													<tr>
														<td class="tb-grade-green">G</td>
														<td>15</td>
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
							<!-- 부서 관리 지표 발생 현황 //-->
							
							<!-- 당월 RED 등급 지표 -->
							<article class="">
								<h3 class="title dash-title">
									당월 RED 등급 지표
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
							<div class="wrap-grid h300">
								<script> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
							</article>
							<!-- 당월 RED 등급 지표 //-->
						</div>
					</section>
					<!-- 운영리스크 주요 정보 //-->
				
				</div>
			</div>

		</div>
			</form>
		</div>
		<!-- content //-->

</body>
</html>