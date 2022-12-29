<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0121_guide.jsp
 Program name : 대응방안 산출식
 Description  : 화면정의서 RCSA-14 / 별첨
 Programer    : 박승윤
 Date created : 2022.09.26
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/library.jsp" %>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RCSA - 프로세스 기준 평가등급 산출식</title>
</head>
<body>
	
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w1000">	
			<div class="p_head">
				<h1 class="title">프로세스 기준 평가등급 산출식</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				
					<!-- 프로세스 위험등급 -->
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">프로세스 위험등급</h2>
						</div>
						<div class="rcsa-guide-summary top">
							<p>위험등급 <span class="cg">Green</span>, <span class="cy">Yellow</span>, <span class="cr">Red</span>의 환산점수를 각각 1, 2, 3로 <span class="cr">정의하여 프로세스 내 개별리스크사례의 위험등급의 평균점수</span>를 산정함</p>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 30px;">
									<col style="width: 200px;">
									<col style="width: 150px;">
									<col style="width: 150px;">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th scope="col" rowspan="2" colspan="2">Lv.4 프로세스</th>
										<th scope="col" colspan="3">위험평가 결과</th>
									</tr>
									<tr>
										<th scope="col">위험등급</th>
										<th scope="col">환산점수</th>
										<th scope="col">평균점수</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td rowspan="3"><i class="rcsa-guide-level"></i></td>
										<th>리스크사례1</th>
										<td class="tb-grade-green">G</td>
										<td class="cg">1</td>
										<td rowspan="3">
											<div class="rcsa-guide-sum">
												<div class="count">
													<div class="divided">
														<p class="top">(3+2+1)</p> 
														<p class="bottom">3</p> 
													</div>
													<p class="same">=</p>
													<div class="total">2</div>
												</div>
												<p class="arrow arrow1"></p>
											</div>
										</td>
									</tr>
									<tr>
										<th>리스크사례2</th>
										<td class="tb-grade-yellow">Y</td>
										<td class="cy">2</td>
									</tr>
									<tr>
										<th>리스크사례3</th>
										<td class="tb-grade-red">R</td>
										<td class="cr">3</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="rcsa-guide-summary">
							<p><strong>평균점수별 위험등급 구간에 따라</strong> 프로세스 기준 최종 위험등급을 산정함</p>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th scope="col" class="w230">위험등급</th>
										<th scope="col" class="tb-grade-green">Green</th>
										<th scope="col" class="tb-grade-yellow">Yellow</th>
										<th scope="col" class="tb-grade-red">Red</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th scope="row">점수구간</th>
										<td>1 &le; 평균점수&le; 1.66</td>
										<td>1.66 &lt; 평균점수 &le; 2.33</td>
										<td>2.33 &lt; 평균점수 &le; 3</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="rcsa-guide-arrow"></div>
						<section class="risk-grade-wrap">
							<dl class="risk-grade">
								<dt>Lv.4 프로세스 기준 최종 위험등급</dt>
								<dd class="yellow">YELLOW</dd>
							</dl>
						</section>
					</section>
					<!-- 프로세스 위험등급 //-->
				
					<!-- 프로세스 통제등급 -->
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">프로세스 통제등급</h2>
						</div>
						<div class="rcsa-guide-summary top">
							<p>통제등급 <span class="cg">상</span>, <span class="cy">중</span>, <span class="cr">하</span>의 환산점수를 각각 1, 2, 3로 <span class="cr">정의하여 프로세스 내 개별 통제활동의 통제등급의 평균점수</span>를 산정함</p>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 30px;">
									<col style="width: 200px;">
									<col style="width: 150px;">
									<col style="width: 150px;">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th scope="col" rowspan="2" colspan="2">Lv.4 프로세스</th>
										<th scope="col" colspan="3">위험평가 결과</th>
									</tr>
									<tr>
										<th scope="col">통제등급</th>
										<th scope="col">환산점수</th>
										<th scope="col">평균점수</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td rowspan="3"><i class="rcsa-guide-level"></i></td>
										<th>통제활동1</th>
										<td class="tb-grade-green">상</td>
										<td class="cg">1</td>
										<td rowspan="3">
											<div class="rcsa-guide-sum">
												<div class="count">
													<div class="divided">
														<p class="top">(1+2+1)</p> 
														<p class="bottom">3</p> 
													</div>
													<p class="same">=</p>
													<div class="total">1.33</div>
												</div>
												<p class="arrow arrow2"></p>
											</div>
										</td>
									</tr>
									<tr>
										<th>통제활동2</th>
										<td class="tb-grade-yellow">중</td>
										<td class="cy">2</td>
									</tr>
									<tr>
										<th>통제활동3</th>
										<td class="tb-grade-green">상</td>
										<td class="cg">1</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="rcsa-guide-summary">
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th scope="col" class="w230">위험등급</th>
										<th scope="col" class="tb-grade-green">상</th>
										<th scope="col" class="tb-grade-yellow">중</th>
										<th scope="col" class="tb-grade-red">하</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th scope="row">점수구간</th>
										<td>1 &le; 평균점수&le; 1.66</td>
										<td>1.66 &lt; 평균점수 &le; 2.33</td>
										<td>2.33 &lt; 평균점수 &le; 3</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="rcsa-guide-arrow"></div>
						<section class="risk-grade-wrap">
							<dl class="risk-grade">
								<dt>Lv.4 프로세스 기준 최종 통제등급</dt>
								<dd class="green">상</dd>
							</dl>
						</section>
					</section>
					<!-- 프로세스 통제등급 //-->
				
					<!-- 프로세스별 잔여 위험 등급 산출 -->
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">프로세스별 잔여 위험 등급 산출</h2>
						</div>
						<div class="rcsa-guide-summary top">
							<p>프로세스에 포함된 하위 <span class="cr">개별 리스크사례와 통제활동의 점수를 곱한 값의 평균</span>을 활용하여 잔여위험 등급을 산정함</p>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 30px;">
									<col style="width: 200px;">
									<col style="width: 130px;">
									<col style="width: 130px;">
									<col style="width: 130px;">
									<col style="width: 130px;">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th scope="col" rowspan="2" colspan="2">Lv.4 프로세스</th>
										<th scope="col" colspan="4">최종평가 결과</th>
										<th scope="col" rowspan="2">잔여위험 점수</th>
									</tr>
									<tr>
										<th scope="col">위험등급</th>
										<th scope="col">환산점수</th>
										<th scope="col">통제등급</th>
										<th scope="col">환산점수</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td rowspan="3"><i class="rcsa-guide-level level2"></i></td>
										<th>리스크사례1</th>
										<td class="tb-grade-red">R</td>
										<td class="cr">3</td>
										<td class="tb-grade-green">상</td>
										<td class="cg">1</td>
										<td><strong>3 &times; 1 = 3</strong></td>
									</tr>
									<tr>
										<th>리스크사례2</th>
										<td class="tb-grade-yellow">Y</td>
										<td class="cy">2</td>
										<td class="tb-grade-yellow">중</td>
										<td class="cy">2</td>
										<td><strong>2 &times; 2 = 4</strong></td>
									</tr>
									<tr>
										<th>리스크사례3</th>
										<td class="tb-grade-green">G</td>
										<td class="cg">1</td>
										<td class="tb-grade-yellow">중</td>
										<td class="cy">2</td>
										<td><strong>1 &times; 2 = 2</strong></td>
									</tr>
								</tbody>
							</table>
							<div class="rcsa-guide-result">
								<p class="eval">평균값 : 3</p>
							</div>
						</div>
						<div class="rcsa-guide-summary">
							<p>잔여위험 등급구간에 의거 <span class="cr">최종 잔여위험등급을 산출</span>함</p>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th scope="col" class="w230">잔여위험등급</th>
										<th scope="col" class="tb-grade-green">Green</th>
										<th scope="col" class="tb-grade-yellow">Yellow</th>
										<th scope="col" class="tb-grade-red">Red</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th scope="row">점수구간</th>
										<td>최종점수&le; 3</td>
										<td>3 &lt; 최종점수 &le; 6</td>
										<td>6 &lt; 최종점수 &le; 9</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="rcsa-guide-arrow"></div>
						<section class="risk-grade-wrap">
							<dl class="risk-grade">
								<dt>Lv.4 프로세스 기준 최종 잔여위험등급</dt>
								<dd class="green">G</dd>
							</dl>
						</section>
					</section>	
					<!-- 프로세스별 잔여 위험 등급 산출 //-->

				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
	<script>
		$(document).ready(function(){
		parent.removeLoadingWs();
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});
	</script>
	
</body>
</html>