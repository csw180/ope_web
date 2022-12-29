<%--
/*---------------------------------------------------------------------------
 Program ID   : ORDS0101.jsp
 Program name : ORM 메인화면
 Description  : 화면코드 DASH-01
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
Vector vLst5= CommUtil.getResultVector(request, "grp01", 0, "unit05", 0, "vList"); //누적 손실 금액
if(vLst5==null) vLst5 = new Vector();
Vector vLst6= CommUtil.getResultVector(request, "grp01", 0, "unit06", 0, "vList"); //규제 자본 산출 결과
if(vLst6==null) vLst6 = new Vector();
Vector vLst7= CommUtil.getResultVector(request, "grp01", 0, "unit07", 0, "vList"); //내부 자본 산출 결과
if(vLst7==null) vLst7 = new Vector();
Vector vLst8= CommUtil.getResultVector(request, "grp01", 0, "unit08", 0, "vList"); //일정
if(vLst8==null) vLst8 = new Vector();

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

String bia_yn = ""; //평가기간 체크(vLst4 값 있으면 Y)
HashMap hMap4 = null;
if(vLst4.size()>0){
	hMap4 = (HashMap)vLst4.get(0);
	bia_yn = "Y";
}else{
	hMap4 = new HashMap();
	bia_yn = "N";
}
Integer bia_all_cnt = Integer.parseInt((String)hMap4.get("bia_all_cnt"));
Integer bia_01_cnt = bia_all_cnt - Integer.parseInt((String)hMap4.get("bia_01_cnt"));
Integer bia_02_cnt = bia_all_cnt - Integer.parseInt((String)hMap4.get("bia_02_cnt"));
Integer bia_03_cnt = bia_all_cnt - Integer.parseInt((String)hMap4.get("bia_03_cnt"));
Integer bia_04_cnt = bia_all_cnt - Integer.parseInt((String)hMap4.get("bia_04_cnt"));
Integer bia_05_cnt = bia_all_cnt - Integer.parseInt((String)hMap4.get("bia_05_cnt"));

String bia_c = "N"; //완료여부
if(bia_05_cnt == bia_all_cnt) {
	bia_c = "Y";
}
System.out.println(bia_yn);





HashMap hMap8 = null;
if(vLst8.size()>0){
	hMap8 = (HashMap)vLst8.get(0);
}else{
	hMap8 = new HashMap();
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>ORM 메인화면</title>
	<script>
	$(document).ready(function(){
		chartDraw_1();
		chartDraw_2();
		chartDraw_3();
		chartDraw_4();
	});
	
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

			<div class="row">
				<div class="col w45p">
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
									<ul class="risk-status-list">
										<li>
											<p class="subject">평가자 지정</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd class="ing">(100/132)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">평가 수행</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd class="ing">(100/132)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">부서 결과 검토</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd class="ing">(100/132)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">ORM 결과 검토</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd class="ing">(100/132)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">대응방안 수립</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd class="ing">(100/132)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">대응방안 이행</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd class="ing">(100/132)</dd>
											</dl>
										</li>
									</ul>
								</div>
							</article>
							
							<article class="risk-status">
								<h3 class="title dash-title">
									KRI
									<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
								</h3>
								<div class="status-area ing">
									<p class="date"><strong>23. 02</strong> 회</p>
									<p class="status">미완료</p>
								</div>
								<div class="risk-status-list-wrap">
									<ul class="risk-status-list">
										<li>
											<p class="subject">수기 지표 입력</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(24/24)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">부서 결과 검토</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">대응 방안 검토</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd class="ing">(23/24)</dd>
											</dl>
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
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(24/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd>(132/132)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">G/L 계정 모니터링</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(24/24)</dd>
												<dt class="branch"><span class="text">영업점</span></dt>
												<dd>(132/132)</dd>
											</dl>
										</li>
									</ul>
								</div>
							</article>
							
							<article class="risk-status">
								<h3 class="title dash-title">
									BIA
								</h3>
								<p class="period">평가 기간 : <strong><%=(String)hMap8.get("bia_evl_st_dt") %></strong> ~ <strong><%=(String)hMap8.get("bia_evl_ed_dt") %></strong></p>
								<div class="status-area">
<%if(bia_yn.equals("N")){ %>
									<p class="status">평가 기간 아님</p>
<%}else if (bia_yn.equals("Y")){ %>
									<p class="date"><strong><%=(String)hMap8.get("bia_yy")%></strong> 년</p>
	<%if(bia_c.equals("Y")){ %>
									<p class="status">완료</p>
	<%}else{%>
									<p class="status">미완료</p>
	 
	<%}
}%>
								</div>
								<div class="risk-status-list-wrap">
									<ul class="risk-status-list">
<%if(bia_yn.equals("N")){ %>
										<li>
											<p class="subject">평가자 지정</p>
											<p class="no">평가 기간 아님</p>
										</li>
										<li>
											<p class="subject">평가 수행</p>
											<p class="no">평가 기간 아님</p>
										</li>
										<li>
											<p class="subject">부서 결과 검토</p>
											<p class="no">평가 기간 아님</p>
										</li>
										<li>
											<p class="subject">ORM 결과 검토</p>
											<p class="no">평가 기간 아님</p>
										</li>
										<li>
											<p class="subject">BCP 결과 검토</p>
											<p class="no">평가 기간 아님</p>
										</li>
<%}else if (bia_yn.equals("Y")){ %>
										<li>
											<p class="subject">평가자 지정</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(<%=bia_01_cnt%>/<%=bia_all_cnt%>)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">평가 수행</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(<%=bia_02_cnt%>/<%=bia_all_cnt%>)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">부서 결과 검토</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(<%=bia_03_cnt%>/<%=bia_all_cnt%>)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">ORM 결과 검토</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(<%=bia_04_cnt%>/<%=bia_all_cnt%>)</dd>
											</dl>
										</li>
										<li>
											<p class="subject">BCP 결과 검토</p>
											<dl>
												<dt class="main"><span class="text">본부</span></dt>
												<dd>(<%=bia_05_cnt%>/<%=bia_all_cnt%>)</dd>
											</dl>
										</li>
<%} %>
									</ul>
								</div>
							</article>
						</div>
					</section>
					<!-- 운영리스크 업무 처리 현황 //-->
					
				</div>	
				<div class="col w55p">
				
					<!-- 운영리스크 주요 정보 -->
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">운영리스크 주요 정보</h2>
						</div>
						
						<div class="row">
							<div class="col">
								<!-- 누적 손실 금액 -->
								<article class="box-dash h640">
									<h3 class="title dash-title">
										누적 손실 금액
										<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
									</h3>
									<p class="date"><strong>2023 - 06</strong> 기준</p>
									<p class="period">집계 기간 : <strong>2004-06-02</strong> ~ <strong>2023-06-01</strong></p>
									<div class="wrap-chart risk-info-chart h270">
										<div class="risk-info-chart-title">
											<p class="title1">781,313,090</p>
											<p class="title2">단위 : 원</p>
										</div>
										<script>
											createIBChart("myChart_1", "100%", "100%");
										</script>
									</div>
									<div class="wrap-chart h250">
										<script>
											createIBChart("myChart_2", "100%", "100%");
										</script>
									</div>
								</article>
								<!-- 누적 손실 금액 //-->
							</div>
							
							<div class="col">
								<!-- 규제 자본 산출 결과 -->
								<article class="box-dash h320">
									<h3 class="title dash-title">
										규제 자본 산출 결과 <span class="small">(Op. RWA)</span>
										<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
									</h3>
									<p class="date"><strong>2023-2분기</strong> 기준</p>
									<div class="wrap-chart das-repcep-chart h250">
										<script>
											createIBChart("myChart_3", "100%", "100%");
										</script>
									</div>
								</article>
								<!-- 규제 자본 산출 결과 //-->
								
								<!-- 내부 자본 산출 결과 -->
								<article class="box-dash h310">
									<h3 class="title dash-title">
										내부 자본 산출 결과
										<button type="button" class="btn-dash-more" title="상세보기" onclick=""><span class="blind">상세보기</span></button>
									</h3>
									<p class="date"><strong>2023-2분기</strong> 기준</p>
									<div class="wrap-chart h200">
										<script>
											createIBChart("myChart_4", "100%", "100%");
										</script>
									</div>
									<div class="wrap-table">
										<table>
											<tbody class="center">
												<tr>
													<th class="w120">운영위험 자본량</th>
													<td><strong>765.5</strong>억원</td>
												</tr>
											</tbody>
										</table>
									</div>
								</article>
								<!-- 내부 자본 산출 결과 //-->
							</div>
						</div>
					</section>
					<!-- 운영리스크 주요 정보 //-->
				</div>
			</div>
			</form>
		</div>
		<!-- content //-->
</body>
</html>