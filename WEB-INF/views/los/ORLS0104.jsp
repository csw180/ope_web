<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0104.jsp
 Program name : 손실사건 수집항목 도움말(팝업)
 Description  : LDM-06
 Programer    : 이규탁
 Date created : 2022.08.08
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
				<h3 class="title"><i class="fa fa-exclamation-circle"></i><span class="txt">HELP</span></h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="wrap-table">
						<table class="txt txt-sm">
							<colgroup>								
								<col style="width: 50px;" />
								<col style="width: 80px;" />
								<col style="width: 140px;" />
								<col />
								<col style="width: 95px;" />
								<col style="width: 75px;"/>
								<col style="width: 75px;"/>
								<col style="width: 75px;"/>
							</colgroup>
							<thead>
								<tr>
									<th rowspan="2">항목<br />번호</th>
									<th rowspan="2">정보구분</th>
									<th rowspan="2">수집항목명</th>
									<th rowspan="2">항목설명</th>
									<th rowspan="2">필수입력항목여부<br />(필수/선택적)</th>
									<th colspan="3">R&amp;R (○:최초 입력, △ : 수정/보완)</th>
								</tr>
								<tr>
									<th>사건발생<br />부서/영업점</th>
									<th>사건관리<br />(본사)부서</th>
									<th>리스크<br />관리팀(ORM)</th>
								</tr>
							</thead>
							<tbody class="center">
								<tr>
									<td>1</td>
									<td>조직정보</td>
									<td>손실사건 발생법인</td>
									<td class="left">손실사건 발생법인</td>
									<td>필수</td>
									<td colspan="3">시스템 자동입력</td>
								</tr>
								<tr>
									<td>2</td>
									<td>조직정보</td>
									<td>발생부서</td>
									<td class="left">사건이 발생한 부서 혹은 영업점</td>
									<td>필수</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>3</td>
									<td>조직정보</td>
									<td>발생지역</td>
									<td class="left">
										발생 부서의 상위 조직을 의미<br>
										(예. 영업점의 상위 조직)					
									</td>
									<td>선택적</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>4</td>
									<td>조직정보</td>
									<td>사건발생국가</td>
									<td class="left">
										손실사건이 해외에서 발생한 경우 해당 발생국가명<br>
										(해외현지법인 또는 부서가 아니더라도 입력가능)
									</td>
									<td>선택적</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>5</td>
									<td>조직정보</td>
									<td>보고자</td>
									<td class="left">
										손실사건을 최초보고(ORMS등록)하는 직원 성명<br>
										(로그인중인 사용자의 소속부서로 시스템 자동입력)
									</td>
									<td>필수</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>6</td>
									<td>조직정보</td>
									<td>보고부서</td>
									<td class="left">
										손실사건을 최초보고(ORMS등록) 하는 임직원이 속한 부서(영업점)명<br>
										(로그인중인 사용자의 소속부서로 시스템 자동입력)
									</td>
									<td>필수</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>7</td>
									<td>조직정보</td>
									<td>채권관리부서</td>
									<td class="left">
										채권회수가 필요한 손실사건의 경우 해당 채권회수 업무를 담당하는 부서명<br>
										(예시)<br>
										- 부당이익금반환청구소송: (준법지원부서)법무팀<br>
										- 소송진행전까지의 부도채권회수: 영업점, 여신관리단 등 해당 여신사후관리 부서<br>
										- 부도채권회수를 위한 소송진행 이후: (준법지원부서)법무팀
										
									</td>
									<td>선택적</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>8</td>
									<td>조직정보</td>
									<td>사건관리부서</td>
									<td class="left">
										손실사건의 처리를 담당하는 부서(감사/준법지원/인사 등 본사부서를 의미하며, 1개의 손실사건에 다수의 사건관리부서 지정 가능)<br>
										손실R&R인터뷰를 통해 각 계열사별로 지정된 손실사건 관리부서<br>
										- 내외부 사취, 내규 및 법규 위반 관련 관리부서: 감사부서(예. 지주 - 감사기획팀) , 준법지원부서(예. 지주 - 준법지원팀), 인사담당부서(예. 지주 - 인사전략팀)<br>
										- 소송 관련 관리부서: 소송담당부서(예. 생명보험, 손해보험 - 준법감시팀)<br>
										- 세무 관련 관리부서: 세무담당부서(예. 자산운용 - 재무회계팀)<br>
										- 동산/시설물 등 파손 관련 관리부서: 총무담당부서(예. 생명보험 - 총무팀)<br>
										- 안전사고 관련 관리부서: 안전관리부서 (예. 지주, 캐피탈 - 경영지원팀)<br>
										- 전산장애 관련 관리부서: IT담당부서 (예. 저축은행 - IT지원부)<br>
										- 개인정보유출 관련 관리부서: 정보보호담당부서 (예. 투자증권 - 정보보호부)<br>
										- 민원 관련 관리부서: 민원담당부서 (예. 지주,생명, 캐피탈 - 소비자보호팀)<br>
										- 보험 관련 관리부서: 보험담당부서 (예. 리츠운용 - 경영전략부)<br>
										* 리스크관리 총괄부서: 운영리스크관리팀(리스크관리팀)<br>
										사건관리부서 지정 예시 : <br>
										내부감사 결과 발견된 횡령사건에 대해 감사부서는 인사부에 징계를 요구하고, 징계위원회 소집 결과 형사고발을 의결한 경우 → 감사/인사/법무 3개 부서를 사건관리부서로 지정
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>9</td>
									<td>일자정보</td>
									<td>발생일자</td>
									<td class="left">
										사건 발생일(사건이 여러 날짜에 걸쳐서 발생한 경우, 최초 발생일)<br>
										예시 : <br>
										‘21.03 ~ ‘21.06 까지 동일 직원이 3개월 간격으로 각 1억원씩 5회에 걸쳐 총 5억원을 횡령한 사실을 ‘22. 08에 발견 → ‘21.03을 발생일로 입력
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>10</td>
									<td>일자정보</td>
									<td>발견일자</td>
									<td class="left">
										사건 발견일<br>
										예시:<br>
										‘21.03 ~ ‘21.06 까지 동일 직원이 3개월 간격으로 각 1억원씩 5회에 걸쳐 총 5억원을 횡령한 사실을 ‘22. 08에 발견 → ‘22.08로 발견일자 입력
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>11</td>
									<td>일자정보</td>
									<td>최초등록일자</td>
									<td class="left">
										손실사건 데이터 최초 입력(등록)일<br>
										(시스템 자동입력)
									</td>
									<td>필수</td>
									<td colspan="3">시스템 자동입력</td>
								</tr>
								<tr>
									<td>12</td>
									<td>일자정보</td>
									<td>최종변경일자</td>
									<td class="left">손실사건 데이터 최종 변경일(시스템 자동입력)</td>
									<td>필수</td>
									<td colspan="3">시스템 자동입력</td>
								</tr>
								<tr>
									<td>13</td>
									<td>관리정보</td>
									<td>손실사건 관리번호</td>
									<td class="left">손실사건 일련번호(시스템 자동입력)</td>
									<td>필수</td>
									<td colspan="3">시스템 자동입력</td>
								</tr>
								<tr>
									<td>14</td>
									<td>관리정보</td>
									<td>인사부관리번호</td>
									<td class="left">
										인사부서에서 부여한 사건관리번호
									</td>
									<td>선택적</td>  
									<td>&nbsp;</td>
									<td>○</td>
									<td>△</td>
								</tr>
								<tr>
									<td>15</td>
									<td>관리정보</td>
									<td>사건제목</td>
									<td class="text-left">
										손실사건을 요약한 제목
									</td>
									<td>필수</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>16</td>
									<td>관리정보</td>
									<td>사건상세내용</td>
									<td class="left">
										발생사건에 대한 일시, 원인, 상품, 발견경위, 손실금액, 취해진 조치내역 내용을 6하 원칙에 의거 구체적으로 기술<br>
										조치내역 예시 :<br>
										- 당사가 피해를 입은 경우<br>
											→ 내부 징계, 고소/고발 등의 조치 내역을 입력<br> 
										- 당사가 피해를 입힌 경우<br>
											→ 보상, 변상, 대리인(변호사, 노무사 등) 선임 등 조치 내역을 입력	
									</td>
									<td>필수</td>  
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>17</td>
									<td>관리정보</td>
									<td>손실발생채널</td>
									<td class="left">
										손실이발생한 채널 <br>
										예시 :<br>
										영업점 창구, 인터넷뱅킹
									</td>
									<td>선택적</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>18</td>
									<td>관리정보</td>
									<td>관련상품명</td>
									<td class="left">발생한 손실사건과 관련된 상품</td>
									<td>선택적</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>19</td>
									<td>관리정보</td>
									<td>동일손실사건번호</td>
									<td class=left>개별건으로 등록되어 있으나, 동일 사건으로 인식해야 하는 경우 연결을 통해 단일건으로 인식</td>
									<td>선택적</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
								<tr>
									<td>20</td>
									<td>관리정보</td>
									<td>소송여부</td>
									<td class="left">Y,N로 구분</td>
									<td>필수</td>
									<td>○</td>
									<td>△<br>(준법지원부서)</td>
									<td>&nbsp;</td>
								</tr>
								<tr class="line bt">
									<td>21</td>
									<td>관리정보</td>
									<td>소송진행심급</td>
									<td class="left">1,2,3 심으로 구분</td>
									<td>필수<br>(단, '소송여부 = Y' 인 경우에만 필수)</td>
									<td>○</td>
									<td>△<br>(준법지원부서)</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>22</td>
									<td>관리정보</td>
									<td>소송종결여부</td>
									<td class="left">진행중/종결 중 선택</td>
									<td>필수<br>(단, '소송여부 = Y' 인 경우에만 필수)</td>
									<td>○</td>
									<td>△<br>(준법지원부서)</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>23</td>
									<td>관리정보</td>
									<td>소송결과</td>
									<td class="left">'전부승소', '일부승소', '전부패소', '취하', '기각', '화해권고', '조정', '파기'로 구분(8가지중 택1)</td>
									<td>필수<br>(단, '소송여부 = Y' 인 경우에만 필수)</td>
									<td>○</td>
									<td>△<br>(준법지원부서)</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>24</td>
									<td>재무 및 회계정보</td>
									<td>손실발생금액</td>
									<td class="left">해당 사건으로 발생한 손실금액<br>(여신관리에서 부실채권 발생 경우 손실예상금액 입력)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>25</td>
									<td>재무 및 회계정보</td>
									<td>최초회계처리일</td>
									<td class="left">회계상 손실사건 관련 계정과목이 최초 기표된 일자<br>(가지급금 등 가계정 포함)</td>
									<td>필수</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>26</td>
									<td>재무 및 회계정보</td>
									<td>최종회계처리일</td>
									<td class="left">회계상 손실사건 관련 계정과목이 최종 기표된 일자<br>(가계정 → 결산조정분개 후 본계정 전환 포함)</td>
									<td>필수</td>
									<td colspan="3">별도 입력 필요 없이 화면에서 확인 가능</td>
								</tr>
								<tr>
									<td>27</td>
									<td>재무 및 회계정보</td>
									<td>최초손실계정코드</td>
									<td class="left">회계상 최초 기표된 손실사건 관련 계정과목코드(가지급금 등 가계정 포함)</td>
									<td>필수</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>28</td>
									<td>재무 및 회계정보</td>
									<td>최종회계처리계정코드</td>
									<td class="left">
										회게상 최초 기표된 손실사건 관련 계정과목코드(가계정 → 결산조정분개 후 본계정 전환 포함)
									</td>
									<td>해당(필수)</td>
									<td colspan="3">별도 입력 필요 없이 화면에서 확인 가능</td>
								</tr>
								<tr>
									<td>29</td>
									<td>재무 및 회계정보</td>
									<td>보험회수금액</td>
									<td class="left">보험사로부터 수령한 보험금 총액</td>
									<td>필수<br>(보험 기청구 건일시 필수 입력)</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>30</td>
									<td>재무 및 회계정보</td>
									<td>사건접수일</td>
									<td class="left">가입중인 보험사에 손실사건을 접수한(보험처리를 신청한) 일자</td>
									<td>필수<br>(보험 기청구 건일시 필수 입력)</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr class="line bt">
									<td>31</td>
									<td>사고번호</td>
									<td>원인유형3</td>
									<td class="left">보험사에서 해당 손실사건에 부여한 사고번호<br>
									<br>
									*원인유형 구분체계를 기존 LV2 에서 LV3로 확장함에 따른 항목 추가</td>
									<td>필수<br>(보험 기청구 건일시 필수 입력)</td>
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>32</td>
									<td>재무 및 회계정보</td>
									<td>보험금수령일</td>
									<td class="left">보험사로부터의 보험금 수령(입금) 일자</td>
									<td>필수<br>(보험 기청구 건일시 필수 입력)</td>  
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>33</td>
									<td>재무 및 회계정보</td>
									<td>보험종류</td>
									<td class="left">
										보험금을 신청한 당사 가입중 보험상품의 종류<br>
										예시 : <br>
										신원보증보험, 현금도난보험, 개인정보유출배상책임보험, 국외부서가입보험, 전자금융거래배상책임보험, 금융기관종합보험, 임원배상책임보험, 재산종합보험(화재보험)
									</td>
									<td>필수<br>(보험 기청구 건일시 필수 입력)</td>  
									<td>○</td>
									<td>&nbsp;</td>
									<td>△</td>
								</tr>
								<tr>
									<td>34</td>
									<td>재무 및 회계정보</td>
									<td>소송회수금액</td>
									<td class="left">
										확정심 승소 결과 판결문상 명시된 당사 회수(승소)금액<br>
										*소송의 경우 그 특성상 판결문상 명시된 회수금액을 향후 당사 수령금액과 동일금액으로 가정하고 실제 당사에 입금된 금액정보를 수집하지 아니함
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△<br>(준법지원부서)</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>35</td>
									<td>재무 및 회계정보</td>
									<td>소송회수금수령일</td>
									<td class="left">
										소송 상대방으로부터의 회수금(승소금 등) 수령(입금) 일자<br>
										예시 :<br>
										소가중 판결에 의해 인정된 승소금, 법률자문비용 및 행정비용 등의 환급 총액
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>36</td>
									<td>재무 및 회계정보</td>
									<td>소송부대비용</td>
									<td class="left">
										손실사건 관련 소송진행을 위해 발생한 법적 비용 <br>
										예시 :<br>
										소송진행을 위해 법률대리인에게 지급된 자문비용(착수금/성공보수 등) 및 법원 행정비용(인지대/송달료 등)
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△<br>(준법지원부서)</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>37</td>
									<td>재무 및 회계정보</td>
									<td>기타부대비용</td>
									<td class="left">
										손실사건과 직접적으로 관련해 발생한 기타 비용으로 소송관련 비용외 소요된 기타 비용<br>
										예시 : 소송으로 진행되지 않았으나(=법률대리인을 선임하지 않은건), 외부 자문을 위해 지급된 변호사, 노무사, 감평사, 손해사정인 등의 자문 수수료 비용 등
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>38</td>
									<td>재무 및 회계정보</td>
									<td>기타회수내역</td>
									<td class="left">
										보험 및 소송 이외의 회수금이 발생할 경우 해당 회수 내역<br>
										예시 :<br>
										내부직원, 외부 제3자로부터의 변상금, 상환금 등<br>
										*여신관리부변상금 관련항목은 여신관리부 필수입력항목임<br>
										(계열사 조직체계에 따라 관리부서 명칭은 다를 수 있음)
									</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>39</td>
									<td>재무 및 회계정보</td>
									<td>기타회수금액</td>
									<td class="left">기타방법을 통해 회수된 금액</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>40</td>
									<td>재무 및 회계정보</td>
									<td>기타회수금수령일</td>
									<td class="left">기타회수금 수령(입금) 일자</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>&nbsp;</td>
								</tr>
								<tr class="line bt">
									<td>41</td>
									<td>재무 및 회계정보</td>
									<td>총손실금액</td>
									<td class="left">
										총손실금액 = 손실발생금액 + 소송부대비용 + 기타부대비용<br>(시스템 자동계산)
									</td>
									<td>필수</td>
									<td colspan="3">시스템 자동계산</td>
								</tr>
								<tr>
									<td>42</td>
									<td>재무 및 회계정보</td>
									<td>총회수금액</td>
									<td class="left">총회수금액 = 보험회수금액 + 소송회수금액 + 기타회수금액</td>
									<td>필수</td>
									<td colspan="3">시스템 자동계산</td>
								</tr>
								<tr>
									<td>43</td>
									<td>재무 및 회계정보</td>
									<td>순손실금액</td>
									<td class="left">순손실금액 = 총손실금액 - 보험회수금액 - 소송회수금액 - 기타회수금액<br>
									<td>필수</td>
									<td colspan="3">시스템 자동계산</td>
								</tr>
								<tr>
									<td>44</td>
									<td>분석정보</td>
									<td>손실형태</td>
									<td class="left">‘재무손실', '타이밍손실', '비재무손실', '유사손실',   '미정‘, '관리대상외'로 구분(6가지중 택1)</td>
									<td>필수</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
								<tr>
									<td>45</td>
									<td>분석정보</td>
									<td>손실상태</td>
									<td class="left">‘유보손실', '계류중손실', '손실확정', '관리대상외'로 구분(4가지중 택1)</td>
									<td>필수</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>

								</tr>
								<tr>
									<td>46</td>
									<td>분석정보</td>
									<td>업무프로세스 LV1</td>
									<td class="left">손실이 발생한 Level 1(대분류) 업무 프로세스</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>47</td>
									<td>분석정보</td>
									<td>업무프로세스 LV2</td>
									<td class="left">손실이 발생한 Level 2(중분류) 업무 프로세스</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>48</td>
									<td>분석정보</td>
									<td>업무프로세스 LV3</td>
									<td class="left">손실이 발생한 Level 3(단위업무) 업무 프로세스</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>49</td>
									<td>분석정보</td>
									<td>업무프로세스 LV4</td>
									<td class="left">손실이 발생한 Level 4(세부업무) 업무 프로세스</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>50</td>
									<td>분석정보</td>
									<td>사건유형 LV1</td>
									<td class="left">Basel의 손실사건유형 LV1(7가지중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr class="line bt">
									<td>51</td>
									<td>분석정보</td>
									<td>사건유형 LV2</td>
									<td class="left">Basel의 손실사건유형 LV2<br>(LV1 선택시 표시되는 하위 항목중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>52</td>
									<td>분석정보</td>
									<td>사건유형 LV3</td>
									<td class="left">NH 자체정의 손실사건유형 LV3<br>(LV2 선택시 표시되는 하위 항목중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>53</td>
									<td>분석정보</td>
									<td>원인유형 LV1</td>
									<td class="left">정의된 사건원인유형 LV1(4가지중 택1)<br>
										<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>54</td>
									<td>분석정보</td>
									<td>원인유형 LV2</td>
									<td class="left">정의된 사건원인유형LV2<br>(LV1 선택시 표시되는 하위 항목중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>55</td>
									<td>분석정보</td>
									<td>원인유형 LV3</td>
									<td class="text-left">정의된 사건원인유형LV3<br>(LV2 선택시 표시되는 하위 항목중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>56</td>
									<td>분석정보</td>
									<td>영향유형 LV1</td>
									<td class="left">정의된 영향유형 LV1(3가지중 택1)<br>(영향유형 = 손실결과(NH농협은행에서는 '손실결과'로 표기))</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>57</td>
									<td>분석정보</td>
									<td>영향유형 LV2</td>
									<td class="left">NH자체정의 영향유형 LV2<br>(LV1 선택시 표시되는 하위 항목중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>58</td>
									<td>분석정보</td>
									<td>이머징리스크유형 LV1</td>
									<td class="text-left">ORX 손실사건유형 LV1(10가지중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>59</td>
									<td>분석정보</td>
									<td>이머징리스크유형 LV2</td>
									<td class="left">ORX 손실사건유형 LV2(LV1 선택시 표시되는 하위 항목중 택1)</td>
									<td>필수</td>
									<td>○</td>
									<td>△</td>
									<td>△</td>
								</tr>
								<tr>
									<td>60</td>
									<td>경계리스크정보</td>
									<td>시장리스크여부</td>
									<td class="left">
										등록 중인 손실사건의 시장리스크 해당 여부를 구분하여 입력<br>
										(금리, 주가, 환율 등 시장가격의 변동으로 인하여 금융회사의 자산 가치에 따른 손실 발생 위험)
									</td>
									<td></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
								<tr>
									<td>61</td>
									<td>경계리스크정보</td>
									<td>신용리스크여부</td>
									<td class="left">
										등록 중인 손실사건의 신용리스크 해당 여부를 구분하여 입력<br>
										(거래상대방의 경영상태 악화, 신용도 하락 또는 채무 불이행 등으로 인한 손실 발생 위험)
									</td>
									<td></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
								<tr>
									<td>62</td>
									<td>경계리스크정보</td>
									<td>신용RWA 반영여부</td>
									<td class="left">
										등록 중인 손실사건의 신용RWA반영 해당 여부를 구분하여 입력<br>
										(신용+운영리스크중 신용위험가중자산 산출에 반영되지 않은 손실사건 구분 목적)
									</td>
									<td></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
								<tr class="line bt">
									<td>63</td>
									<td>경계리스크정보</td>
									<td>전략리스크여부</td>
									<td class="left">
										등록 중인 손실사건의 전략리스크 해당 여부를 구분하여 입력<br>
										(부적절한 경영의사결정 및 실행과 경영환경변화에 적절히 대응하지 못함에 따라 금융기관의 순익 또는 자본에 부정적 영향을 줄 수 있는 손실 발생 위험)
									</td>
									<td></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
								<tr>
									<td>64</td>
									<td>경계리스크정보</td>
									<td>평판리스크여부</td>
									<td class="left">
										등록 중인 손실사건의 평판리스크 해당 여부를 구분하여 입력<br>
										(금융기관에 대한 고객/거래상대방/주주 및 규제 당국의 부정적 인식에 따라 당사의 순익 또는 자본에 부정적 영향을 줄 수 있는 손실 발생 위험)
									</td>
									<td></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
								<tr>
									<td>65</td>
									<td>경계리스크정보</td>
									<td>법률리스크여부</td>
									<td class="left">
										등록 중인 손실사건의 법률리스크 해당 여부를 구분하여 입력<br>
										(기업이 경영활동 과정에서 법규나 규제를 위반에 발생하는 재무적 또는 비재무적 손실 발생 위험)
									</td>
									<td></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>○</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="wrap-table mt20">
						<table class="txt txt-sm">
							<thead>
								<tr>
									<th colspan="3">손실사건 관리 구분</th>
									<th colspan="9" class="bgi">지주 및 자회사 손실사건 관리부서</th>
								</tr>
								<tr>
									<th class="light">구분</th>
									<th class="light">사건유형</th>
									<th class="light">관리부서</th>
									<th class="bgb">지주</th>
									<th class="bgb">생명</th>
									<th class="bgb">손해보험</th>
									<th class="bgb">투자증권</th>
									<th class="bgb">자산운용</th>
									<th class="bgb">캐피탈</th>
									<th class="bgb">저축은행</th>
									<th class="bgb">리츠운용</th>
									<th class="bgb">벤처투자</th>
								</tr>
							</thead>
							<tbody class="center">
								<tr>
									<th rowspan="11">손실사건<br>관리부서</th>
									<th rowspan="3" class="light">내&middot;외부 사취,<br>내규 및 법규 위반</th>
									<th class="light">감사부서</th>
									<td>감사기획팀</td>
									<td>감사팀</td>
									<td>감사실</td>
									<td>감사총괄팀/본사감사팀/지점감사팀</td>
									<td>감사팀</td>
									<td>감사팀</td>
									<td>감사실</td>
									<td>리스크관리팀</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th class="light">준법지원부서</th>
									<td>준법지원팀</td>
									<td>준법감시팀</td>
									<td>준법감시팀</td>
									<td>컴플라이언스부</td>
									<td>준법감시팀</td>
									<td>준법지원팀</td>
									<td>준법지원부</td>
									<td>리스크관리팀</td>
									<td>준법감시인</td>
								</tr>
								<tr>
									<th class="light">인사담당부서</th>
									<td>인사전략팀</td>
									<td>인사팀</td>
									<td>경영지원팀</td>
									<td>인사부</td>
									<td>인사팀</td>
									<td>경영지원팀</td>
									<td>인사총무팀</td>
									<td>경영전략부</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th class="light">소송</th>
									<th class="light">소송담당부서</th>
									<td>준법지원팀</td>
									<td>준법감시팀</td>
									<td>준법감시팀</td>
									<td>법무지원부</td>
									<td>준법감시팀</td>
									<td>여신관리팀</td>
									<td>준법지원부</td>
									<td>리스크관리팀</td>
									<td>준법감시인</td>
								</tr>
								<tr>
									<th class="light">세무</th>
									<th class="light">세무담당부서</th>
									<td>재무회계팀</td>
									<td>회계팀</td>
									<td>재무심사팀</td>
									<td>재무관리부</td>
									<td>재무회계팀</td>
									<td>재무팀</td>
									<td>경영기획팀</td>
									<td>경영지원팀</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th class="light">동산/시설물 등 파손</th>
									<th class="light">총무담당부서</th>
									<td>경영지원팀</td>
									<td>총무팀</td>
									<td>경영지원팀</td>
									<td>경영지원부</td>
									<td>경영지원팀</td>
									<td>경영지원팀</td>
									<td>인사총무팀</td>
									<td>경영전략부</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th class="light">안전사고</th>
									<th class="light">안전관리부서</th>
									<td>경영지원팀</td>
									<td>총무팀</td>
									<td>경영지원팀</td>
									<td>금융소비자보호부</td>
									<td>준법감시팀</td>
									<td>경영지원팀</td>
									<td>인사총무팀</td>
									<td>경영전략부</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th class="light">전산장애</th>
									<th class="light">IT담당부서</th>
									<td>ICT혁신팀</td>
									<td>IT기획팀</td>
									<td>IT지원팀</td>
									<td>IT기획부</td>
									<td>IT팀</td>
									<td>IT개선팀</td>
									<td>IT지원부</td>
									<td>경영전략부</td>
									<td>N/A</td>
								</tr>
								<tr>
									<th class="light">개인정보유출</th>
									<th class="light">정보보호담당부서</th>
									<td>소비자보호팀</td>
									<td>준법감시팀</td>
									<td>준법감시팀</td>
									<td>정보보호부</td>
									<td>준법감시팀</td>
									<td>소비자보호팀</td>
									<td>준법지원부</td>
									<td>리스크관리팀</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th class="light">민원</th>
									<th class="light">민원담당부서</th>
									<td>소비자보호팀</td>
									<td>소비자보호팀</td>
									<td>소비자보호실</td>
									<td>금융소비자보호부</td>
									<td>리테일CS팀</td>
									<td>소비자보호팀</td>
									<td>준법지원부</td>
									<td>리스크관리팀</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th class="light">ALL</th>
									<th class="light">보험담당부서</th>
									<td>인사전략팀</td>
									<td>총무팀, 인사팀</td>
									<td>경영지원팀</td>
									<td>인사지원부</td>
									<td>경영지원팀</td>
									<td>경영지원팀</td>
									<td>인사총무팀</td>
									<td>경영전략부</td>
									<td>경영지원본부</td>
								</tr>
								<tr>
									<th>리스크관리<br>총괄부서</th>
									<th class="light">ALL</th>
									<th class="light">운영리스크관리팀</th>
									<td>리스크관리팀</td>
									<td>리스크관리팀</td>
									<td>리스크관리팀</td>
									<td>리스크관리부</td>
									<td>리스크관리팀</td>
									<td>리스크관리팀</td>
									<td>리스크관리부</td>
									<td>리스크관리팀</td>
									<td>경영지원본부</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div><!-- .p_wrap //-->
			</div><!-- .p_body //-->
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-sm btn-close2">닫기</button>
				</div>
			</div><!-- .p_foot //-->
<!-- 				<button class="ico close fix btn-close2"><span class="blind">닫기</span></button> -->
		</div><!-- .p_frame //-->
	</div><!-- .popup //-->
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