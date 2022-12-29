<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0106.jsp
 Program name : 일정 수정 팝업
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
HashMap hMap = null;
if(vLst.size()>0){
	hMap = (HashMap)vLst.get(0);
}else{
	hMap = new HashMap();
}


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			// ibsheet 초기화
		});
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("fam"); // fam
					$("form[name=ormsForm] [name=process_id]").val("ORFM010104");			
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<article class="popup modal block" > 
		<div class="p_frame w800"> 
			<div class="p_head">
				<h1 class="title">일정 수정</h1>
			</div>
			<div class="p_body"> 
				<div class="p_wrap">  
					<form name="ormsForm" method="post">
						<input type="hidden" id="path" name="path" />             
						<input type="hidden" id="process_id" name="process_id" />  
						<input type="hidden" id="commkind" name="commkind" />       
						<input type="hidden" id="method" name="method" />                      
						<div id="hdng_area"></div>  
						<div id="brcd_area"></div>
					
						<section class="box box-grid">
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 120px;">
										<col>
										<col style="width: 120px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>시행년도</th>
											<td>
												<input type="text" id="" name="" class="form-control">
											</td>
											<th>회차</th>
											<td>
												<input type="text" id="" name="" class="form-control">
											</td>
										</tr>
										<tr>
											<th>평가제목</th>
											<td colspan="3">
												<input type="text" id="" name="" class="form-control" placeholder="평가제목을 입력해 주십시오.">
											</td>
										</tr>
										<tr>
											<th>평가시작일</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" id="date01" class="form-control w90" value="" readonly>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd', 'date01')"><i class="fa fa-calendar"></i><span class="blind">날짜선택</span></button>
													</span>
												</div>
											</td>
											<th>평가종료일</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" id="date02" name="efct_ed_dt" class="form-control w100" readonly />
													<div class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','date02');"><i class="fa fa-calendar"></i><span class="blind">날짜선택</span></button>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th>등록 및 변경 사유</th>
											<td colspan="3">
												<textarea name="" id="" class="form-control" placeholder="변경 사유를 입력하여 주십시오."></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</section>
					</form>						
				</div><!-- .p_wrap //-->		
			</div>    <!-- .p_body //-->
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div> 
	</article>  
	
	
		  
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 		  
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 팝업 --> 		  
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winNewAccAdd",parent.document).hide();
		}
	</script>
</body>	 	
</html>