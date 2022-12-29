<%--
/*---------------------------------------------------------------------------
 Program ID   : ORDS0107.jsp
 Program name : 개인지표
 Description  : 화면코드 DASH-07
 Programer    : 박승윤
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
	<title>계열사 ORM KRI조회</title>
	<script>
	$(function(){
		initIBSheet();
	})
	
	// mySheet
	function initIBSheet() {
		var initdata = {};
		initdata.Cfg = { MergeSheet: msHeaderOnly };
		initdata.Cols = [
			{ Header: "건수",		Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 },
			{ Header: "지표명",		Type: "",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 300 },
		];
		IBS_InitSheet(mySheet, initdata);
		mySheet.SetSelectionMode(4);
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

			<article class="popup modal block">
		<div class="p_frame w1000">	
			<div class="p_head">
				<h1 class="title">개인 지표 발생 정보</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				
					<section class="box box-grid">
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 160px;">
									<col>
									<col style="width: 120px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">사번</th>
										<td>SHGR014</td>
										<th scope="row">성명</th>
										<td>신짱구</td>
									</tr>
									<tr>
										<th scope="row">소관부서/지점</th>
										<td colspan="3">구리금융센터(영업점)</td>
									</tr>
									<tr>
										<th scope="row">당해 연도 누적발생지표 개수</th>
										<td colspan="3">12</td>
									</tr>
									<tr>
										<th scope="row">당해 연도 누적 최다발생지표</th>
										<td colspan="3">여신 승인 조건 미이행 건수 (개인사업자)</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 160px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">조회기준일</th>
										<td>2023.06.01</td>
									</tr>
									<tr>
										<th scope="row">당월 발생 지표 개수</th>
										<td>3건</td>
									</tr>
									<tr>
										<th scope="row">당월 최다 발생 지표</th>
										<td>여신 승인 조건 미이행 건수 (개인사업자)</td>
									</tr>
									<tr>
										<th scope="row">당월 전체 발생 지표</th>
										<td>
											<div class="wrap-grid h250">
												<script> createIBSheet("mySheet", "100%", "100%"); </script>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
				

				</div>						
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
			</form>
		</div>
		<!-- content //-->

</body>
</html>