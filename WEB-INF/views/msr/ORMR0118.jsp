<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0118.jsp
 Program name : 내부 자본량 연간 한도 및 소진율 관련 가이드라인
 Description  : 
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>내부 자본량 연간 한도 및 소진율 관련 가이드라인</title>
	<script>
	
	$(document).ready(function(){
		parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
	});
	
	function fileDown(){
		var f = document.ormsForm;
		f.action = "<%=System.getProperty("contextpath")%>/Jsp.do";
		f.target = "ifrHid";
		f.submit();
		
	}
	</script>
</head>
<body>
<form name="ormsForm" method="post">
   	<input type="hidden" id="path" name="path" value="/comm/excelfile"/>
  		<input type="hidden" id="kor_filename" name="kor_filename" value="내부 자본량 연간 한도 및 소진율 관련 가이드라인"/>
</form>
	<div id="" class="popup modal block">
	<article class="p_frame w1100">
		<div class="p_head">
			<h3 class="title">내부 자본량 연간 한도 및 소진율 관련 가이드라인</h3>
		</div>
		<div class="p_body">
			<div class="p_wrap">

				<div class="box box-grid">
					<h4 class="title">한도 소진율 가이드라인</h4>
					<div class="wrap-table">
						<table>
							<colgroup>
								<col style="width: 150px;">
								<col>
							</colgroup>
							<thead>
								<tr>
									<th>구분</th>
									<th>내용</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>내부자본 한도<br>소진율 공식</th>
									<td class="center">
										<div class="form-inline p5">
											<div>당해년도 N분기末 기준 내부자본 한도소진율</div>
											<div class="w40">=</div>
											<div>
												<p>당해년도 N분기末 기준 Op.RWA <sup class="txt txt-xs">(발생)</sup></p>
												<p class="line bt bcb mt5 mb5"></p>
												<p class="ph5 pw10 bgm cw">전년도 4분기末 기준 운영RWA 한도값<span class="txt txt-xs">(한도)</span></p>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th>내부자본 한도<br>소진율 조치사항</th>
									<td class="p0">
										<table class="intable">
											<colgroup>
												<col style="width: 170px;">
												<col>
											</colgroup>
											<thead>
												<tr>
													<th>구분</th>
													<th>조치사항</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th>한도 소진율 95% 초과</th>
													<td>
														<ul class="ul t1">
															<li>운영리스크량 증가 원인 분석 및 관리대책 수립</li>
														</ul>
													</td>
												</tr>
												<tr>
													<th>한도초과</th>
													<td>
														<ul class="ul t1">
															<li>旣 조치사항 및 추가 허용한도 관리 대책을 수립·이행 후, 그 조치 결과를 지주 회사 리스크관리부서에 보고</li>
														</ul>
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<div class="box box-grid">
					<h4 class="title md">한도값 설정 가이드라인</h4>
					<div class="wrap-table">
						<table>
							<colgroup>
								<col style="width: 150px;">
								<col>
								<col style="width: 100px;">
								<col>
								<col style="width: 100px;">
								<col style="width: 100px;">
							</colgroup>
							<thead>
								<tr>
									<th>상황</th>
									<th>영업지수</th>
									<th>영업지수요소</th>
									<th>손실요소</th>
									<th>내부손실승수</th>
									<th>한도값</th>
								</tr>
							</thead>
							<tbody class="center">
								<tr>
									<th><strong>정상상황<br>( <i class="fsi">+n%</i> )</strong></th>
									<td>
										영업지수<sub class="txt txt-xs">전년도 4분기 기준</sub> X (1+<i class="fsi">n%</i>)
									</td>
									<td><strong>BIC<sub class="txt txt-xs">n</sub></strong></td>
									<td rowspan="5">
										<div class="ib">
											<p>
												기준 시점으로 10년 이내 손실사건 中<br>
												총손실금액 100만원<span class="cr">*</span> 이상 건<br>
												[손실계류중/손실확정]
											</p>
											<p class="mt20 txt txt-sm"><span class="cr">*</span> 손실사건 수집 최소 금액 기준</p>
										</p>
									</td>										
									<td rowspan="5"><strong>ILM</strong></td>
									<td><strong>Op.RWA<sub class="txt txt-xs">n</sub></strong></td>
								</tr>
								<tr>
									<th><strong>경기둔화<br>( <i class="fsi">+s%</i> )</strong></th>
									<td>
										영업지수<sub class="txt txt-xs">전년도 4분기 기준</sub> X (1+<i class="fsi">s%</i>)
									</td>
									<td><strong>BIC<sub class="txt txt-xs">s</sub></strong></td>
									<td><strong>Op.RWA<sub class="txt txt-xs">s</sub></strong></td>
								</tr>
								<tr>
									<th><strong>경기침체<br>( <i class="fsi">+d%</i> )</strong></th>
									<td>
										영업지수<sub class="txt txt-xs">전년도 4분기 기준</sub> X (1+<i class="fsi">d%</i>)
									</td>
									<td><strong>BIC<sub class="txt txt-xs">d</sub></strong></td>
									<td><strong>Op.RWA<sub class="txt txt-xs">d</sub></strong></td>
								</tr>
								<tr>
									<th><strong>역사적<br>( <i class="fsi">+c%</i> )</strong></th>
									<td>
										영업지수<sub class="txt txt-xs">전년도 4분기 기준</sub> X (1+<i class="fsi">c%</i>)
									</td>
									<td><strong>BIC<sub class="txt txt-xs">c</sub></strong></td>
									<td><strong>Op.RWA<sub class="txt txt-xs">c</sub></strong></td>
								</tr>
								<tr>
									<th><strong>공황<br>( <i class="fsi">+p%</i> )</strong></th>
									<td>
										영업지수<sub class="txt txt-xs">전년도 4분기 기준</sub> X (1+<i class="fsi">p%</i>)
									</td>
									<td><strong>BIC<sub class="txt txt-xs">p</sub></strong></td>
									<td><strong>Op.RWA<sub class="txt txt-xs">p</sub></strong></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				

			</div>
		</div>
		
		<div class="p_foot">
			<div class="btn-wrap">
				<button type="button" class="btn btn-default btn-close">닫기</button>
			</div>
		</div>
		
		<!-- <a href="/file/MR-18.xlsx" class="btn btn-xs btn-default pa t20 r60" type="button"><i class="ico xls"></i>엑셀 다운로드</a> -->
		<a class="btn btn-xs btn-default btn-help fix" type="button" onclick="javascript:fileDown();"><i class="ico xls"></i>엑셀 다운로드</a>
		<button class="ico close fix btn-close" onclick="closeHelp();"><span class="blind">닫기</span></button>

	</article>
	<div class="dim p_close"></div>
	</div>
	
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				event.preventDefault();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				//$(".popup").hide();
			});
		});
			
		function closePop(){
			$("#winNewAccAdd",parent.document).hide();
		}
	</script>
	<iframe name="ifrHid" id="ifrmHid" src="about:blank" width="0" height="0" scrolling="no" frameborder="0"></iframe>
</body>
</html>