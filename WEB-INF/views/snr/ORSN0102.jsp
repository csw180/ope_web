<%--
/*---------------------------------------------------------------------------
 Program ID   : ORSN0102.jsp
 Program name : 시나리오 분석 일정등록
 Description  : 화면정의서 SCNR-0101
 Programer    : 고창호
 Date created : 2022.08.23
 ---------------------------------------------------------------------------*/
--%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

HashMap hMap = null;
if(vLst.size()>0){
	hMap = (HashMap)vLst.get(0);
}else{
	hMap = new HashMap();
}

SysDateDao dao = new SysDateDao(request);
String sysdate = dao.getSysdate();
DynaForm form = (DynaForm)request.getAttribute("form");

String gubun = (String) form.get("gubun");

String snro_evl_tit = (String) form.get("snro_evl_tit");
if(snro_evl_tit==null) snro_evl_tit = "";
String efct_st_dt = (String) form.get("efct_st_dt");
if(efct_st_dt==null) efct_st_dt = "";
String efct_ed_dt = (String) form.get("efct_ed_dt");
if(efct_ed_dt==null) efct_ed_dt = "";

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>중요 위험 업무 등록</title>
	
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			$("#gubun").val(parent.$("#gubun").val()); //등록수정구분(I:등록 U:수정
<%
	if(vLst.size()>0){
%>
			$('#grp_org_c_p').val('<%=(String)hMap.get("grp_org_c")%>'); //그룹기관코드
			$('#snro_sc').val('<%=(String)hMap.get("snro_sc")%>'); //시나리오회차
			$('#snro_evl_tit').val('<%=(String)hMap.get("snro_evl_tit")%>'); //시나리오평가제목
			$('#efct_st_dt').val('<%=(String)hMap.get("efct_st_dt")%>'); //수행시작일자
			$('#efct_ed_dt').val('<%=(String)hMap.get("efct_ed_dt")%>'); //수행종료일자
			$('#lss_wval_rto').val('<%=(String)hMap.get("lss_wval_rto")%>'); //손실가중치비율
			$('#kri_wval_rto').val('<%=(String)hMap.get("kri_wval_rto")%>'); //KRI가중치비율
			$('#rcsa_wval_rto').val('<%=(String)hMap.get("rcsa_wval_rto")%>'); //RCSA가중치비율
			$('#ctev_wval_rto').val('<%=(String)hMap.get("ctev_wval_rto")%>'); //통제평가가중치비율
			$('#snro_evl_prg_stsc').val('<%=(String)hMap.get("snro_evl_prg_stsc")%>'); //시나리오평가진행상태코드
			$('#snro_rsn').val('<%=(String)hMap.get("snro_rsn")%>'); //등록변경사유내용

			/*수정 팝업에서 수정 가능 일자 체크하기 위해서*/
			$('#efct_st_dt_bf').val('<%=(String)hMap.get("efct_st_dt")%>'); //수행시작일자
			$('#efct_ed_dt_bf').val('<%=(String)hMap.get("efct_ed_dt")%>'); //수행종료일자			
<%
	}
%>
		});
				
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		function save(){
			var f = document.ormsForm;

			var snro_evl_prg_stscnm = parent.$("#snro_evl_prg_stscnm").val(); //상태(평가완료, 평가진행중)
			
			if(f.snro_evl_prg_stsc.value.trim()=='03'){
				alert("이미 평가 완료된 회차 입니다.");
				return;
			}
			
			if(f.efct_st_dt.value.trim()==''){
				alert("수행시작일을 입력하십시오.");
				f.efct_st_dt.focus();
				return;
			}
			
			if(f.efct_ed_dt.value.trim()==''){
				alert("수행종료일을 입력하십시오.");
				f.efct_ed_dt.focus();
				return;
			}
			
			/*수행종료일자가 시작일보다 빠른경우 */
			if( f.efct_st_dt.value.trim() > f.efct_ed_dt.value.trim() ){
				alert("수행종료일은 시작일보다 빠를수 없습니다.");
				f.efct_ed_dt.focus();
				return;
			}
			
			
			var sum = Number(f.lss_wval_rto.value)+Number(f.kri_wval_rto.value)+Number(f.rcsa_wval_rto.value)+Number(f.ctev_wval_rto.value);
			
			if( sum != "100" ){
				alert("항목 별 가중치 합을 100으로 입력해주세요.\n가중치 합계 : ["+sum+"]");
				return;
			}
			
			/*등록,수정에 따른 수행시작,종료일 체크 start_20220427*/
			var gubun = $("#gubun").val();
			var today = '<%=sysdate%>'; //현재일자 (yyyymmdd)
			var efct_st_dt = replace(f.efct_st_dt.value.trim(),"-",""); //수행시작일
			var efct_ed_dt = replace(f.efct_ed_dt.value.trim(),"-",""); //수행종료일
			
			var efct_st_dt_bf = replace(f.efct_st_dt_bf.value.trim(),"-",""); //수행시작일(수정전)
			var efct_ed_dt_bf = replace(f.efct_ed_dt_bf.value.trim(),"-",""); //수행종료일(수정전)
			
			if(gubun == "I"){ //등록 체크
				if(today > efct_st_dt){
					alert("수행시작일을 현재일 이후로 입력하십시오.");
					f.efct_st_dt.focus();
					return;
				}
			}
			
/* 			if(gubun == "U"){ //수정 체크
				if(efct_st_dt_bf < efct_st_dt){
					alert("수행시작일은 현재 등록된 수행시작일 이후 일자로 등록할 수 없습니다.");
					f.efct_st_dt.focus();
					return;
				}
			
				if(efct_ed_dt_bf > efct_ed_dt){
					alert("수행종료일은 현재 등록된 수행종료일 이전 일자로 등록할 수 없습니다."); //위와 같은이유로..
					f.efct_ed_dt.focus();
					return;
				}
			} */	
			
			if(!confirm("저장하시겠습니까?")) return;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "snr");
			WP.setParameter("process_id", "ORSN010202");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							
							alert("저장 하였습니다.");
							$("#winORSN0102",parent.document).hide();
							parent.doAction("search"); //부모창 재조회
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
		

		
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<article class="popup modal block">
			<div class="p_frame w800">

				<div class="p_head">	
<%if(gubun.equals("I")){%>			
					<h1 class="title">계열사 일정등록</h1>			
<%}else{%>
					<h1 class="title">계열사 일정수정</h1>
<%} %>								
				</div>

				<div class="p_body">
					
					<div class="p_wrap">
						<form name="ormsForm">
						<input type="hidden" id="path" name="path" />
						<input type="hidden" id="process_id" name="process_id" />
						<input type="hidden" id="commkind" name="commkind" />
						<input type="hidden" id="method" name="method" />
						
						<input type="hidden" id="grp_org_c_p" name="grp_org_c_p" /> <!-- 그룹기관코드 -->
						<input type="hidden" id="snro_evl_prg_stsc" name="snro_evl_prg_stsc" /> <!-- 시나리오평가진행상태코드 -->
						
						<input type="hidden" id="gubun" name="gubun" value="<%=gubun%>"/> <!-- 구분자 -->
						
						<input type="hidden" id="efct_st_dt_bf" name="efct_st_dt_bf" /> <!-- 수행시작일(수정전) -->
						<input type="hidden" id="efct_ed_dt_bf" name="efct_ed_dt_bf" /> <!-- 수행종료일(수정전) -->						

						<section class="box box-grid">						
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 150px;">
										<col>
										<col style="width: 150px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>평가회차</th>
											<td><input type="text" name="snro_sc" id="snro_sc" class="form-control w80" value="" disabled></td>
<% if(stp_dsc.equals("0")){ %>
<!-- 계열사 자체에서 일정등록시(은행) 지주평가일정 출력하지않음 -->
<% }else{ %>
											<th>지주평가일정</th>
											<td><span id="comn_efct_st_dt"></span> ~ <span id="comn_efct_ed_dt"></span></td>
<% } %>									
										</tr>
										<tr>
											<th>수행시작일</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" id="efct_st_dt" name="efct_st_dt" class="form-control w100" readonly />
													<div class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','efct_st_dt');">
															<i class="fa fa-calendar"></i>
														</button>
													</div>
												</div>
											</td>
											<th>수행종료일</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" id="efct_ed_dt" name="efct_ed_dt" class="form-control w100" readonly />
													<div class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','efct_ed_dt');">
															<i class="fa fa-calendar"></i>
														</button>
													</div>
												</div>
											</td>
										</tr>
										<tr>
<% if(gubun.equals("I")){ %>						
											<th>시나리오 평가제목</th>
											<td colspan="3">
												<input type="text" name="snro_evl_tit" id="snro_evl_tit" class="form-control" value="" placeholder="예) 2022년 제1회 시나리오 분석 보고서">
												<input type="hidden" name="snro_rsn" id="snro_rsn" class="form-control" value="">
											</td>
<% }else{ %>
											<th>등록 및 변경사유</th>
											<td colspan="3">
												<textarea name="snro_rsn" id="snro_rsn" class="textarea h80"></textarea>
												<input type="hidden" name="snro_evl_tit" id="snro_evl_tit" class="form-control" value="<%=gubun%>">
											</td>
<% } %>
										</tr>
									</tbody>
								</table>
							</div>
						</section>

						<section class="box box-grid">						
							<div class="box-header">		
								<h1 class="box-title">항목 별 가중치</h1>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 150px;">
										<col>
										<col style="width: 100px;">
									</colgroup>
									<tbody>
										<tr>
											<th>손실사건 발생 건수</th>
											<td>치근 1년간 100만원 이상의 손실사건 발생 건수</td>
											<td class="center">
												<div class="input-group">
<% if(stp_dsc.equals("0")||stp_dsc.equals("1")){ %>
													<input type="text" name="lss_wval_rto" id="lss_wval_rto" class="form-control right">
<% }else{ %>
													<input type="text" name="lss_wval_rto" id="lss_wval_rto" class="form-control right" readonly>
<% } %>												
													<span class="input-group-addon">%</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>KRI</th>
											<td>최근 1년간 전사단위 KRI의 RED등급이 발생한 횟수<br>(12개월 발생횟수 합산)</td>
											<td class="center">
												<div class="input-group">
<% if(stp_dsc.equals("0")||stp_dsc.equals("1")){ %>
													<input type="text" name="kri_wval_rto" id="kri_wval_rto" class="form-control right">
<% }else{ %>
													<input type="text" name="kri_wval_rto" id="kri_wval_rto" class="form-control right" readonly>
<% } %>																								
													<span class="input-group-addon">%</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>RCSA 위험평가</th>
											<td>최근 1년간 전사단위 위험평가의 RED등급이 발생한 횟수<br>(연간 시행한 평가횟수 합산)</td>
											<td class="center">
												<div class="input-group">
<% if(stp_dsc.equals("0")||stp_dsc.equals("1")){ %>
													<input type="text" name="rcsa_wval_rto" id="rcsa_wval_rto" class="form-control right">
<% }else{ %>
													<input type="text" name="rcsa_wval_rto" id="rcsa_wval_rto" class="form-control right" readonly>
<% } %>												
													<span class="input-group-addon">%</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>RCSA 통제평가</th>
											<td>최근 1년간 전사단위 통제평가의 RED등급이 발생한 횟수<br>(연간 시행한 평가횟수 합산)</td>
											<td class="center">
												<div class="input-group">
<% if(stp_dsc.equals("0")||stp_dsc.equals("1")){ %>
													<input type="text" name="ctev_wval_rto" id="ctev_wval_rto" class="form-control right">
<% }else{ %>
													<input type="text" name="ctev_wval_rto" id="ctev_wval_rto" class="form-control right" readonly>
<% } %>																	
													<span class="input-group-addon">%</span>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</section>
						
						</form>
					</div>
					
				</div>


				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="save();">저장</button>
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>

				<button class="ico close fix btn-close"><span class="blind">닫기</span></button>

			</div>
		<div class="dim p_close"></div>
	</article>
	
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->

	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(){
				$(".popup",parent.document).hide();
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
</body>
</html>