<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0103.jsp
 Program name : 영업지수 매핑 가이드라인(팝업)
 Description  : MSR-04
 Programer    : 남수현
 Date created : 2021.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>영업지수 매핑 가이드라인</title>
		<script language="javascript">
		
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
	<body style="background-color:transparent">
	<form name="ormsForm" method="post">
    	<input type="hidden" id="path" name="path" value="/comm/excelfile"/>
    	<input type="hidden" id="filename" name="filename" value="영업지수 매핑 가이드라인"/>
   		<input type="hidden" id="kor_filename" name="kor_filename" value="영업지수 매핑 가이드라인"/>
	</form>
		<div id="" class="popup modal block">
				<div class="p_frame">
	
					<div class="p_head">
						<h3 class="title">영업지수 매핑 가이드라인</h3>
					</div>
	
	
					<div class="p_body">
						
						<div class="p_wrap">
	
							<div class="box box-grid">						
								<div class="wrap-table">
									<table>
										<colgroup>
											<col style="width: 130px;">
											<col style="width: 120px;">
											<col>
											<col>
										</colgroup>
										<thead>
											<tr>
												<th colspan="2">영업지수</th>
												<th>세칙 상 정의</th>
												<th>주요 세부 항목</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th rowspan="4">이자, 리스, 배당<br>(ILDC)</th>
												<th>이자수익자산</th>
												
												<td>
													모든 금융자산에서 발생하는 이자수익 및 기타이자수익<br>
													(금융리스와 운용리스에서 발생하는 이자수익과 리스자산에서 발생하는 수익 포함)
												</td>
												<td class="list-area">
													<ul class="ullist">
														<li>- 대출, 할부현금서비스 등 선지급금, 매도가능금융자산, 만기보유금융자산, 단기매매금융자산, 금융리스, 운용리스에서 발생하는 이자수익</li>
														<li>- 위험회피회계적용 파생상품에서 발생하는 이자수익</li>
														<li>- 기타이자수익</li>
														<li>- 리스자산에서 발생하는 수익</li>
													</ul>
												</td>
											</tr>
											<tr>
												<th>이자비용</th>
												<td>
													모든 금융부채에서 발생하는 이자비용 및 기타이자비용<br>
													(금융리스와 운용리스에서 발생하는 이자비용과 운용리스자산의 손실, 감가상각, 손상차손 포함)
												</td>
												<td>
													<ul class="ullist">
														<li>- 예수금, 채무증권, 금융리스, 운용리스에서 발생하는 이자비용</li>
														<li>- 위험회피회계적용 파생상품에서 발생하는 이자비용</li>
														<li>- 기타이자비용</li>
														<li>- 리스자산에서 발생하는 손실</li>
														<li>- 운용리스자산의 감가상각비 및 손상차손</li>
													</ul>
												</td>
											</tr>
											<tr>
												<th>이자수익</th>
												<td colspan="2">
													총 대출잔액, 선지급금, 금리부유가증권(국채 포함), 리스자산
												</td>
											</tr>
											<tr>
												<th>배당수익</th>
												<td colspan="2">
													연결대상이 아닌 지분 및 펀드투자에서 발생하는 배당수익<br>
													(연결제외대상 자회사, 관계기업, 공동기업에서 발생하는 배당수익 포함)
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr>
												<th rowspan="4">서비스<br>(SC)</th>
												<th>수수료수익</th>
												<td>
													자문 및 용역 제공으로 인한 수익<br>
													(금융서비스 아웃소싱 제공에 따른 수익 포함)
												</td>
												<td>
													<ul class="ullist">
														<li>- 증권(발행, 주관, 인수, 양도, 위탁매매)에서 발생하는 수수료 수익</li>
														<li>- 청산과 결제, 자산관리, 수탁, 신탁거래, 지급대행, 구조화금융, 자산유동화, 대출약정 및 보증, 해외거래에서 발생하는 수수료수익</li>
													</ul>
												</td>
											</tr>
											<tr>
												<th>수수료비용</th>
												<td>
													자문 및 용역 이용으로 인한 비용<br>
													(금융서비스 이용을 위해 지급한 아웃소싱 수수료는 포함하나, 수송, IT, 인력관리 등 비금융서비스 이용을 위해 지급한 아웃소싱 수수료는 포함하지 않음)
												</td>
												<td>
													<ul class="ullist">
														<li>- 청산과 결제, 수탁, 자산유동화, 대출약정 및 보증, 해외거래에서 발생하는 수수료비용</li>
													</ul>
												</td>
											</tr>
											<tr>
												<th>기타영업수익</th>
												<td>
													다른 항목에 포함되지 않으나 통상적인 은행 영업활동에서 발생하는 수익<br>
													(운용리스로 인한 수익은 제외)
												</td>
												<td>
													<ul class="ullist">
														<li>- 투자자산에서 발생하는 임대수익</li>
														<li>- 매각예정으로 분류하였으나 중단영업의 정의를 충족하지 않는 비유동자산(또는 처분자산집단)을 재측정하여 인식하는 평가이익</li>
													</ul>
												</td>
											</tr>
											<tr>
												<th>기타영업비용</th>
												<td>
													다른 항목에 포함되지 않으나 통상적인 은행 영업활동에서 발생하는 비용<br>
													(운용리스로 인한 비용은 제외)
												</td>
												<td>
													<ul class="ullist">
														<li>- 매각예정으로 분류하였으나 중단영업의 정의를 충족하지 않는 비유동자산(또는 처분자산집단)을 재측정하여 인식하는 평가손실</li>
														<li>- 운영 손실사건의 결과로 발생한 손실(벌금, 과징금, 합의금, 손상자산의 대체비용 등) 중 과거에 충당금·준비금으로 적립되지 않은 부분</li>
														<li>- 운영 손실사건에 대한 충당금·준비금 적립 관련 비용</li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr>
												<th rowspan="2">금융거래<br>(FC)</th>
												<th>트레이딩계정손익</th>
												<td colspan="2">
													<ul class="ullist">
														<li>- 트레이딩자산 및 부채(파생상품, 채무증권, 지분증권, 대출 및 선지급금, 매도포지션, 기타자산 및 부채)의 손익</li>
														<li>- 위험회피회계로 인한 손익</li>
														<li>- 외환차이로 인한 손익</li>
													</ul>
												</td>
											</tr>
											<tr>
												<th>은행계정손익</th>
												<td colspan="2">
													<ul class="ullist">
														<li>- 당기손익 - 공정가치측정금융자산 및 금융부채의 손익</li>
														<li>- 당기손익 - 공고정가치측정금융자산 및 금융부채가 아닌 금융자산 및 금융부채(대출, 선지급금, 매도가능자산, 만기보유자산, 상각후원가로 측정된 금융부채)의 실현손익</li>
														<li>- 위험회피회계로 인한 손익</li>
														<li>- 외환차이로 인한 손익</li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr>
												<th colspan="2">제외계정</th>
												<td colspan="2">
													<ul class="ullist">
														<li>- 보험 또는 재보험 영업으로 인한 수익과 비용</li>
														<li>- 보험료 지급분 및 보험·재보험 계약에 따라 수령한 보험금</li>
														<li>- 관리비(임금, 비금융서비스(예시 : 물류·수송·IT·인력관리) 이용에 따라 지급한 아웃소싱 수수료, 기타 관리비 (예시 : IT, 설비, 통신, 여행, 사무용품, 우편 비용) 포함)</li>
														<li>- 관리비 회수액(고객을 대신하여 지급한 금액(예시 : 고객에게 부과된 세금))에 대한 회수액 포함)</li>
														<li>- 부동산 및 고정자산의 비용(운영 손실사건의 결과로 발생한 비용은 제외)</li>
														<li>- 유형자산 및 무형자산의 감가상각비·상각비 (금융리스 및 운용리스 비용에 포함된 운용리스자산 관련 감가상각비는 제외)</li>
														<li>- 운영 손실사건 관련 충당금을 제외한 충당금 설정 및 환입 관련 손익(예시 : 연금, 약정, 보증 관련)</li>
														<li>- 상환청구권부 주식으로 인한 비용</li>
														<li>- 손상의 인식 및 환입 (예시 : 금융자산, 비금융자산, 자회사·관계기업 및 공동기업에 대한 투자)</li>
														<li>- 영업권 변동으로 인해 인식되는 손익</li>
														<li>- 법인세 (이연법인세 포함)</li>
													</ul>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
	
						</div>
					</div>
					
					<div class="p_foot">
						<div class="btn-wrap center">
							<button type="button" class="btn btn-default btn-close">닫기</button>
						</div>
					</div>
	
					<!-- <a href="/file/MR-03.xlsx" class="btn btn-xs btn-default pa t20 r60" type="button"><i class="ico xls"></i>엑셀 다운로드</a> -->
					<a class="btn btn-xs btn-default pa t20 r60" type="button" onclick="javascript:fileDown();"><i class="ico xls"></i>엑셀 다운로드</a>
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
</html>