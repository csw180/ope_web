<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0110.jsp
 Program name : 신표준 측정값 산출가이드라인
 Description  : MSR-13
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
	<title>신표준 측정값 산출가이드라인</title>
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
   		<input type="hidden" id="kor_filename" name="kor_filename" value="新표준 측정값 산출 가이드라인"/>
	</form>
	<div id="" class="popup modal block">
		<div class="p_frame w900">

			<div class="p_head">
				<h3 class="title">新표준 측정값 산출 가이드라인</h3>
			</div>


			<div class="p_body">
				
				<div class="p_wrap">

					<div class="box box-grid">	
						<h4 class="title">영업지수(BI) 산출 방법</h4>					
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th>영업지수(BI) 구성항목</th>
										<th>영업지수(BI) 구성항목 산출 방법</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>ILDC</th>
										<td class="center">
											Min [ | 이자수익 - 이자비용 | , 이자수익자산 × 0.0225 ] + 배당수익
										</td>
									</tr>
									<tr>
										<th>SC</th>
										<td class="center">
											Max [ 기타영업수익, 기타영업비용 ] + Max [ 수수료수익, 수수료비용 ]
										</td>
									</tr>
									<tr>
										<th>FC</th>
										<td class="center">
											| 트레이딩계정손익 | + | 은행계정손익 |
										</td>
									</tr>
									<tr>
										<td colspan="2" class="center bg">
											<strong>
												영업지수(BI) = ILDC + SC + FC
											</strong>
										</td>
									</tr>
								</tbody>
							</table> 
						</div>
					</div>

					

					<div class="box box-grid">	
						<h4 class="title">영업지수요소(BIC) 산출 방법</h4>					
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col>
									<col style="width: 80px;">
								</colgroup>
								<thead>
									<tr>
										<th>Bucket</th>
										<th>영업지수(BI) 범위</th>
										<th>계수 (α)</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>1</th>
										<td>0원 이상 ~ 1.4조원 미만</td>
										<td class="center">12%</td>
									</tr>
									<tr>
										<th>2</th>
										<td>1.4조원 이상 ~ 42조원</td>
										<td class="center">15%</td>
									</tr>
									<tr>
										<th>3</th>
										<td>42조원 이상</td>
										<td class="center">18%</td>
									</tr>
									<tr>
										<td colspan="3" class="center bg">
											<strong>
												영업지수(BI) 범위에 따른 계수 (α)를 곱함
											</strong>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					

					<div class="box box-grid">	
						<h4 class="title">ILM, ORC, Op.RWA 산출 방법</h4>					
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th>구분</th>
										<th>산출 방법</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>ILM</th>
										<td>ln [ exp(1) - 1 + (LC/BIC)<sup>0.8</sup> ]</td>
									</tr>
									<tr>
										<th>ORC</th>
										<td>BIC × ILM</td>
									</tr>
									<tr>
										<th>Op.RWA</th>
										<td>ORC × 12.5</td>
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

			<!-- <a href="/file/MR-09.xlsx" class="btn btn-xs btn-default pa t20 r60" type="button"><i class="ico xls"></i>엑셀 다운로드</a> -->
			<a class="btn btn-xs btn-default btn-help fix" type="button" onclick="javascript:fileDown();"><i class="ico xls"></i><span class="txt">엑셀 다운로드</span></a>
			<button class="ico close fix btn-close"><span class="blind">닫기</span></button>

		</div>
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
	<iframe name="ifrHid" id="ifrmHid" src="about:blank"></iframe>
</body>
</html>