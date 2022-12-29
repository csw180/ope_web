<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0107.jsp
 Program name : 내부손실사건 등록도움말
 Description  : 
 Programer    : 김남원
 Date created : 2022.04.15
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
					<h3 class="title">손실상태 분류기준</h3>
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
										<th>손실유보중</th>
										<td>
											<ul class="ul dash">
												<li>사건의 조사, 심의과정에 있는 상태</li>
												<li>재무적 영향이 있을 것으로 예상되지만, 회계기표(가지급금 처리 포함)가 이루어 지지 않은 상태를 포함</li>
												<li>손실사건의 처리 경과에 따라 손실상태가 '손실계류중', '손실확정', '관리대상외'로 재분류될 수 있는 경우</li>
											</ul>
										</td>
									</tr>
									<tr>
										<th>손실계류중</th>
										<td>
											<ul class="ul dash">
												<li>운영리스크 손실발생에 따라 손실이 기표(가지급 포함)된 상태</li>
												<li>손실이 아직 확정되지 않아 손실금액이 변동될 수 있는 경우</li>
												<li>전부패소 또는 일부패소로 판결된 진행소송의 경우(최종심에서 전부패소 또는 일부패소 판결에 의한 손실확정 전까지의 상태)</li>
											</ul>
										</td>
									</tr>
									<tr>
										<th>손실확정</th>
										<td>
											<ul class="ul dash">
												<li>손실사건의 조사, 심의(인사위원회 의결 등), 소송, 합의, 회수과정이 완료되어 사건의 처리가 종결되고, 총계정원장에 재무적 손실이 반영된 경우</li>
											</ul>
										</td>
									</tr>
									<tr>
										<th>관리대상외</th>
										<td>
											<ul class="ul dash">
												<li>사건처리 결과 최종적으로 운영리스크 손실이 아닌 경우</li>
												<li>총계정원장상 손실이 기표되지 않은 운영리스크 사건으로, 금전적 손실이 없거나 산정이 불가능한 결과를 가져온 경우(비재무사건)</li>
												<li>사건은 발생하였으나, 효과적이고 적절한 내부통제 작동 또는 행운으로 인해 직접적인 손실이 발생하지 않은 사건(유사손실)</li>
												<li>손실계류중이던 소송의 최종심의에서 전부 승소한 경우(비운영리스크 손실)</li>
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
					</div>
					
				</div>

			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-sm btn-close2">닫기</button>
				</div>
			</div><!-- .p_foot //-->
			<button type="button" class="ico close fix btn-close2"><span class="blind">닫기</span></button>
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