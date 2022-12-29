<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0106.jsp
 Program name : 손실형태 및 손실상태 도움말(팝업)
 Description  : LMD-06
 Programer    : 이규탁
 Date created : 2022.08.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
</head>
<body>
	<div id="" class="popup modal block">
		<div class="p_frame w1100">

			<div class="p_head">
				<h3 class="title">손실형태 분류기준</h3>
			</div>


			<div class="p_body">
				
				<div class="p_wrap">
					
					<div class="wrap-table">
						<table>
							<col style="width:120px;" />
							<col />
							<thead>
								<tr>
									<th>손실형태</th>
									<th>분류기준</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>재무적손실</th>
									<td>
										<ul class="ul dash">
											<li>운영리스크 관련 손실 중 금전적 손실을 수반하는 사건</li>
											<li>손실상태가 '손실계류중', '손실확정'인 경우 포함</li>
											<li>여신 관련 사건은 피해금액이 있는 경우 포함</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th>타이밍손실</th>
									<td>
										<ul class="ul dash">
											<li>이전 회계기간의 현금흐름 또는 재무제표에 영행을 미치는 운영리스크 손실사건으로 인해 당해 회계기간에 부정적인 경제적 영향을 수반하는 사건</li>
											<li>손실상태가 '손실계류중', '손실확정'인 경우 포함</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th>비재무적 손실</th>
									<td>
										<ul class="ul dash">
											<li>금전적 손실이 발생하지 않았지만, 은행에 부정적인 영향을 끼친 사건</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th>유사손실</th>
									<td>
										<ul class="ul dash">
											<li>당사에 운영리스크 손실을 가져오지는 않았지만, 손실이 될 수 있었던 사건</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th>미정</th>
									<td>
										<ul class="ul dash">
											<li>사건의 조사 및 심의 과정에 있는 상태</li>
											<li>운영리스크 손실 여부가 결정되기 전 단계이므로, 재무/비재무/유사손실로 구분할 수 없음</li>
											<li>손실상태가 '손실유보중'인 경우 포함</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th>관리대상외</th>
									<td>
										<ul class="ul dash">
											<li>운영리스크 손실이 아니거나, 운영리스크 손실이더라도 관리범위에 포함되지 않으므로, 손실형태를 구분치 않음</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- .wrap-table //-->


					<div class="box">
						<div class="box-header">
							<h5 class="title">&lt;손실형태 분류기준&gt;</h5>
						</div>
						<div class="box-body pw10">
							<img src="<%=System.getProperty("contextpath")%>/images/flowchart01.png" alt="손실형태 분류기준 Decision Tree" />
						</div>
					</div>
					
					<div class="box">
						<div class="box-header">
							<h5 class="title">&lt;타이밍손실 인식기준&gt;</h5>
						</div>
						<div class="box-body overflow pw10">
							<img src="<%=System.getProperty("contextpath")%>/images/flowchart02.png" alt="타이밍손실 인식기준 Decision Tree" class="fl" />
							<div class="wrap-footnote pa b20 r20 w45p">
								<div class="pb10">
									<sup class="footnote">1&#41;</sup>
									<h6 class="title md">부정적 영향 구분 기준</h6>
									<div class="wrap-table mb30">
										<table>
											<col style="width:120px;" />
											<col />
											<col />
											<thead>
												<tr>
													<th rowspan="2">영향 구분</th>
													<th colspan="2">전기오류수정의 회계처리 구분</th>
												</tr>
												<tr>
													<th>전기 재무제표 소급재작성</th>
													<th>당기 영업외손익으로 인식</th>
												</tr>
											</thead>
											<tbody>
												<tr class="cr">
													<th class="cr">부정적 영향</th>
													<td>전기이월결손금 발생</td>
													<td>전기오류수정손실 발생</td>
												</tr>
												<tr>
													<th>긍정적 영향</th>
													<td>전기이월이익잉여금 발생</td>
													<td>전기오류수정이익 발생</td>
												</tr>
											</tbody>
										</table>
									</div><!-- .wrap-table //-->
								</div>
								<div class="col">
									<sup class="footnote">2&#41;</sup><span>소송비용 포함 총손실 기준 2,500만원 이상을 의미</span>
								</div>
								
							</div><!-- .wrap-footnote //-->
						</div><!-- .box //-->
					</div>
				</div>
				
			</div>


			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-sm btn-close2">닫기</button>
				</div>
			</div><!-- .p_foot //-->
			<button type="button" class="ico close fix btn-close2"><span class="blind">닫기</span></button>
		</div>
	</div>
	<script>
			$(document).ready(function(){
	//				$('input[type="date"]').datepicker().attr('type','text');
				//닫기
				$(".btn-close2").click( function(event){
					parent.helpClose();
					event.preventDefault();
				});
			});
	</script>
</body>
</html>