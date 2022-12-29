<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0112.jsp
 Program name : 평판자본량 상세
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%

DynaForm form = (DynaForm)request.getAttribute("form");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getCommonCode(request, "RPT_FQ_DSC"); // (TB_OR_OM_CODE)
if(vLst2==null) vLst2 = new Vector();
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
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			
		});
 		/* Sheet 기본 설정 */
 		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<article class="popup modal block" > 
		<div class="p_frame w1000"> 
			<div class="p_head">
				<h1 class="title">평판자본량 정보 조회</h1>
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
						
						<section class="box-grid">
						
							<div class="box-header">
								<h2 class="box-title">평판리스크 내부 자본량 정보 상세</h2>
							</div>	
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 150px;">
										<col>
										<col style="width: 150px;">
										<col>
										<col style="width: 150px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">기준년월</th>
										<td colspan="5">
											<input class="form-control w70"  id="" name="" value="<%=(String)hMap.get("bas_ym")%>" disabled/>
										</td>		
										</tr>
										<tr>
											<th>평판지수 산출시점</th>
											<td>
												<input type="text" class="form-control" id="sch_bas_ym" name="sch_bas_ym" value=<%=(String)hMap.get("bas_ym_a") %> disabled/>
											</td>																	
											<th>당분기 평판지수 결과 값</th>
											<td>
												<input type="text" class="form-control" id="rep_idx" name="rep_idx" value="<%=(String)hMap.get("rep_idx") %>" disabled/>
											</td>
											<th>전분기 평판지수 결과 값</th>
											<td>
												<input type="text" class="form-control" id="bef_rep_idx" name="bef_rep_idx" value="<%=(String)hMap.get("bef_rep_idx") %>" disabled/>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="box-header">
								<div class="area-tool">
									<span>(단위 억원)</span>
								</div>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 150px;">
										<col style="width: 80px;">
										<col style="width: 80px;">
										<col>
										<col style="width: 80px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th rowspan="3">핵심예금감소<br>(이탈율)금액</th>
											<th>소매</th>
											<th class="light">원화</th>
											<td>
												<input type="number" class="form-control right" id="sch_ret_dec_am" name="sch_ret_dec_am" value="<%=(String)hMap.get("ret_dec_am") %>" disabled placeholder="입력 필요"/>
											</td>
											<th class="light">외화</th>
											<td>
												<input type="number" class="form-control right" id="sch_ret_dec_fgn_am" name="sch_ret_dec_fgn_am" value="<%=(String)hMap.get("ret_dec_fgn_am") %>" disabled placeholder="입력 필요"/>
											</td>
										</tr>
										<tr>
											<th>도매</th>
											<th class="light">원화</th>
											<td>
												<input type="number" class="form-control right" id="sch_cmp_dec_am" name="sch_cmp_dec_am" value="<%=(String)hMap.get("cmp_dec_am") %>" disabled placeholder="입력 필요"/>
											</td>
											<th class="light">외화</th>
											<td>
												<input type="number" class="form-control right" id="sch_cmp_dec_fgn_am" name="sch_cmp_dec_fgn_am" value="<%=(String)hMap.get("cmp_dec_fgn_am") %>" disabled placeholder="입력 필요"/>
											</td>
										</tr>
										<tr>
											<th>기타 등</th>
											<th class="light">원화</th>
											<td>
												<input type="number" class="form-control right" id="sch_rp_dec_am" name="sch_rp_dec_am" value="<%=(String)hMap.get("rp_dec_am") %>" disabled placeholder="입력 필요"/>
											</td>
											<th class="light">외화</th>
											<td>
												<input type="number" class="form-control right" id="sch_rp_dec_fgn_am" name="sch_rp_dec_fgn_am" value="<%=(String)hMap.get("rp_dec_fgn_am") %>" disabled placeholder="입력 필요"/>
											</td>
										</tr>
										<tr>
											<th colspan="2">합계 금액</th>
											<th class="light">원화(합계)</th>
											<td>
												<input type="number" class="form-control right" id="" name="" value="<%=(String)hMap.get("sum_am") %>" disabled/>
											</td>
											<th class="light">외화(합계)</th>
											<td>
												<input type="number" class="form-control right" id="" name="" value="<%=(String)hMap.get("sum_fgn_am") %>" disabled/>
											</td>
										</tr>
										<tr>
											<th colspan="2">순이자마진(NM)</th>
											<th>원화(%)</th>
											<td>
												<input type="number" class="form-control right" id="sch_dpln_spd_rt" name="sch_dpln_spd_rt" value="<%=(String)hMap.get("dpln_spd_rt") %>" disabled placeholder="입력 필요"/>
											</td>
											<th>외화(%)</th>
											<td>
												<input type="number" step="0.01" class="form-control right" id="sch_dpln_spd_fgn_rt" name="sch_dpln_spd_fgn_rt" value="<%=(String)hMap.get("dpln_spd_fgn_rt") %>" disabled placeholder="입력 필요"/>
											</td>
										</tr>
										<tr>
											<th colspan="2">이자손익감소 예상액</th>
											<th>원화</th>
											<td>
												<input type="number" class="form-control right" id="sch_inls_fct_am" name="sch_inls_fct_am" value="<%=(String)hMap.get("inls_fct_am") %>" disabled/>
											</td>
											<th>외화</th>
											<td>
												<input type="number" class="form-control right" id="sch_inls_fct_fgn_am" name="sch_inls_fct_fgn_am" value="<%=(String)hMap.get("inls_fct_fgn_am") %>" disabled/>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 310px;">
										<col>
										<col style="width: 310px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>평판 index증감율<br>(당분기평판지수-전분기평판지수)÷전분기평판지수</th>
											<td>
												<input type="number" class="form-control" id="" name="" value="<%=(String)hMap.get("idx_rate") %>" disabled/>
											</td>
											<th>평판리스크 자본량<br>[이자손익감소예상액x(1-평판index증감율)]</th>
											<td>
												<input type="number" class="form-control" id="" name="" value="<%=(String)hMap.get("rep_m") %>" disabled/>
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
					<button type="button" class="btn btn-primary" onClick="doAction('save');">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div> 
			<button class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div> 
	</article>  
		  
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 		  
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 팝업 --> 		  
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(){
				$(".popup",parent.document).hide();
			});
		});
			
		function closePop(){
			$("#winNewAccAdd",parent.document).hide();
		}
	</script>
</body>	 	
</html>