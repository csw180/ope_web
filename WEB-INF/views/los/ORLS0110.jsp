<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0110.jsp
 Program name : 공통손실등록 도움말(팝업)
 Description  : 
 Programer    : 김남원
 Date created : 2022.04.15
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, java.text.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd 


%>   
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs();
		});
		
		
	</script>
</head>
<body>
	<div id="" class="popup modal block">
			<div class="p_frame w900">

				<div class="p_head">
					<h3 class="title">도움말(공통손실사건 인식기준 및 사건유형 분류원칙)</h3>
				</div>


				<div class="p_body">					
					<div class="p_wrap">

						<section class="box">
							<h4 class="box-title md">공통손실사건 인식기준</h4>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 300px;">
										<col style="width: 90px;">
										<col style="width: 70px;">
										<col>
									</colgroup>
									<thead>
										<tr>
											<th>유형</th>
											<th>사건 연관성</th>
											<th>인식</th>
											<th>예시</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>실수에 의해 반복되는 손실사건</td>
											<td class="text-center">X</td>
											<td class="text-center">개별건</td>
											<td>동일 직원에 의한 실수, 착오 등으로 반복된 손실이 발생한 경우</td>
										</tr>
										<tr>
											<td rowspan="2">하나의 원인으로 인해 다양한 손실이 발생한 경우</td>
											<td class="text-center">O</td>
											<td class="text-center">단일건</td>
											<td>하나의 부정확한 정보로 인해, 가격이 잘못 책정된 복수의 거래가 성립한 경우</td>
										</tr>
										<tr>
											<td class="text-center">O</td>
											<td class="text-center">단일건</td>
											<td>환율고시를 잘못하여 전영업점에서 잘못 고시한 환율로 외국환을 매매하여 손실이 발생한 사건</td>
										</tr>
										<tr>
											<td rowspan="3">외관상 독립된 별개의 손실이나, 일련의 행동 계획에 의해 수행된 복수의 사건</td>
											<td class="text-center">O</td>
											<td class="text-center">단일건</td>
											<td>동일 내부직원이 같은 부점에서 장기간동안 여러 번의 횡령을 한 경우</td>
										</tr>
										<tr>
											<td class="text-center">O</td>
											<td class="text-center">단일건</td>
											<td>동일한 직원이 여러 부점을 거치면서 장기간동안 여러 차례 횡령한 사건</td>
										</tr>
										<tr>
											<td class="text-center">O</td>
											<td class="text-center">단일건</td>
											<td>선행손실을 감추기 위해서 연속적인 손실사건을 발생시키는 경우</td>
										</tr>
									</tbody>
								</table>
							</div>
						</section>

						<section class="box mt20">
							<h4 class="box-title md">공통손실 사건유형 분류원칙</h4>
							<div class="box bg line bt br bb bl p10">
								<ul class="ul">
									<li>
										특정 유형 판단이 애매한 경우 사건발생에 가장 중요한 영향을 미친 핵심요소(근원적 요인)를 찾아 단일사건으로 인식하고 분류한다.
										<ul class="ul dash">
											<li>가장 중요한 핵심요소(근원적 요인)은 행위자의 의도성 여부나 사건발생 관련 최초 원인제공행위 등을 감안하여 가장 적절한 유형으로 분류한다.</li>
										</ul>
									</li>
									<li>
										동일인(또는 동일 그룹)에 의한 복수의 사건은 목적의 동일성 및 사건간 연관성을 고려하여 다음과 같이 개별사건 또는 단일사건으로 인식·분류한다.
										<ul class="ul dash">
											<li>직원의 업무미숙, 비의도적인 실수 등에 의해 반복적으로 발생하는 사건은 각각 개별사건으로 인식하여 각 개별사건의 유형으로 분류한다.</li>
											<li>단일 원인에 의한 여러 건의 사건, 외관상 복수의 사건처럼 보이나 일련의 행동계획에 의해 발생한 사건은 단일사건으로 인식하여 분류한다.</li>
										</ul>
									</li>
								</ul>
							</div>
						</section>

					</div>					
				</div>


				<button class="ico close fix btn-close"><span class="blind">닫기</span></button>
			</div>

		<div class="dim p_close"></div>
	</div>
</body>
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
		});
	</script>
</html>