<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0109.jsp
 Program name : 평판지표 결과 상세
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
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회	
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("fam");
					$("form[name=ormsForm] [name=process_id]").val("ORFM010801");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "reload":  //조회데이터 리로드
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "del":      //삭제
					var srow = mySheet.GetSelectRow();
					
					if(srow < 0) {
						alert("삭제할 항목을 선택하세요.");
						return;
					}
					if(!confirm("삭제하시겠습니까?")) return;
					
					//업무프로세스 사용부서 조회
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "fam");
					WP.setParameter("process_id", "ORFM010801");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("삭제되었습니다.");
								//mySheet.RowDelete(srow, 0);
								mySheet.SetSelectRow(-1);
								init();
								doAction("search"); 
								
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
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
					break;	
				case "save":
					if(!confirm("저장하시겠습니까?")) return;
					
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "fam");
					WP.setParameter("process_id", "ORFM010802");
					WP.setForm(f);
					
					var url = "<%=System.getProperty("contextpath")%>/comMain.do";
					var inputData = WP.getParams();
					
					//alert(inputData);
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("저장되었습니다.");
								objCopy(result.Result.new_code);
							}else if(result!='undefined'){
								alert("저장되었습니다.");
							}else if(result=='undefined'){
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
					break;
				case "edit":
					$("#sch_rkinm").attr("disabled",false);
					$("#sch_typnm").attr("disabled",false);
					$("#sch_brnm").attr("disabled",false);
					$("#sch_fml_cntn").attr("disabled",false);
					$("#sch_fq_dsc").attr("disabled",false);
					$("#sch_psb_yn").attr("disabled",false);
					break;
			}
		}
		

		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<article class="popup modal block" > 
		<div class="p_frame w1000"> 
			<div class="p_head">
				<h1 class="title">평판지표 결과 상세</h1>
			</div>
			<div class="p_body"> 
				<div class="p_wrap">  
					<form name="ormsForm" method="post">
						<input type="hidden" id="path" name="path" />             
						<input type="hidden" id="process_id" name="process_id" />  
						<input type="hidden" id="commkind" name="commkind" />       
						<input type="hidden" id="method" name="method" />         
						<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" value="<%=(String)hMap.get("bas_ym")%>"/>            
						<div id="hdng_area"></div>  
						<div id="brcd_area"></div>
						
						<section class="box-grid">
							<div class="box-header">
								<h2 class="box-title">평판지표 상세 조회</h2>
							</div>	
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 120px;">
										<col>
										<col style="width: 120px;">
										<col>
										<col style="width: 120px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>평판지표-ID</th>
											<td>
												<input type="text" class="form-control" id="sch_rki_id" name="sch_rki_id" value="<%=(String)hMap.get("rki_id")%>" disabled/>
											</td>																	
											<th>지표명</th>
											<td colspan="3">
												<input type="text" class="form-control" id="sch_rkinm" name="sch_rkinm" value="<%=(String)hMap.get("rkinm")%>" disabled/>
											</td>
										</tr>
										<tr>
											<th>유형 구분</th>
											<td>
												 <input type="text" class="form-control" id="sch_typnm" name="sch_typnm" value="<%=(String)hMap.get("typnm")%>" disabled/>
											</td>
											<th>주관 부서</th>
											<td colspan="3">
												 <input type="text" class="form-control" id="sch_brnm" name="sch_brnm" value="<%=(String)hMap.get("brnm")%>" disabled/>
											</td>
										</tr>
										<tr>
											<th>지표 산식</th>
											<td colspan="5">
												<textarea id="sch_fml_cntn" name="sch_fml_cntn" class="form-control" disabled><%=StringUtil.htmlEscape((String)hMap.get("fml_cntn"),false,false) %></textarea>
											</td>
										</tr>
										<tr>
											<th>수집주기</th>
											<td>
<%
for(int i=0;i<vLst2.size();i++){
HashMap hMap2 = (HashMap)vLst2.get(i);
if(((String)hMap2.get("intgc")).equals((String)hMap.get("fq_dsc"))){ 
%>
												 <input type="text" class="form-control" id="" name="" value="<%=(String)hMap2.get("intg_cnm")%>" disabled/>
<% 
	}
}
%>
											</td>				
											<th>지표 추출 방식</th>
											<td>
												 <input type="text" class="form-control" id="" name="" value="<%=(String)hMap.get("psb_yn") %>" disabled/>
											</td>
											<th>기존 KRI 여부</th>
											<td>
												<input type="text" class="form-control" id="" name="" value="N" disabled/>
											</td>
										</tr>
									</tbody>
								</table>
							</div><!-- .wrap-table //-->
						</section>
						<section class="box box-grid">
							<div class="box-header">
								<h2 class="box-title" >연관 KRI 결과 값 및 평판지표 산출과정</h2>
							</div>
							<div class="wrap-table">
								<table>
									<thead>
										<tr>
											<th colspan="2" rowspan="2">지표명</th>
											<th rowspan="2">수집주기</th>
											<th colspan="6">6개월 KRI 결과 값</th>
											<th rowspan="2">평판리스크 <br>지표 결과 값</th>
										</tr>
										<tr>
											<th><%=(String)hMap.get("bas_ym_5")%></th>
											<th><%=(String)hMap.get("bas_ym_4")%></th>
											<th><%=(String)hMap.get("bas_ym_3")%></th>
											<th><%=(String)hMap.get("bas_ym_2")%></th>
											<th><%=(String)hMap.get("bas_ym_1")%></th>
											<th><%=(String)hMap.get("bas_ym_0")%></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td colspan="2">
												<input type="text" class="form-control" id="" name="" value="<%=(String)hMap.get("rkinm")%>" disabled/>
											</td>
											<td>
<%
for(int i=0;i<vLst2.size();i++){
HashMap hMap2 = (HashMap)vLst2.get(i);
if(((String)hMap2.get("intgc")).equals((String)hMap.get("fq_dsc"))){ 
%>
												<input type="text" class="form-control" id="" name="" value="<%=(String)hMap2.get("intg_cnm")%>" disabled/>
<% } 
}
%>
											</td>
											<td>
												<input type="text" class="form-control right" id="" name="" value="<%=(String)hMap.get("rep_kri_nvl_5")%>" disabled/>
											</td>
											<td>
												<input type="text" class="form-control right" id="" name="" value="<%=(String)hMap.get("rep_kri_nvl_4")%>" disabled/>
											</td>
											<td>
												<input type="text" class="form-control right" id="" name="" value="<%=(String)hMap.get("rep_kri_nvl_3")%>" disabled/>
											</td>
											<td>
												<input type="text" class="form-control right" id="" name="" value="<%=(String)hMap.get("rep_kri_nvl_2")%>" disabled/>
											</td>
											<td>
												<input type="text" class="form-control right" id="" name="" value="<%=(String)hMap.get("rep_kri_nvl_1")%>" disabled/>
											</td>
											<td>
												<input type="text" class="form-control right" id="" name="" value="<%=(String)hMap.get("rep_kri_nvl_0")%>" disabled/>
											</td>
											<td>
												<input type="text" class="form-control right" id="" name="" value="<%=(String)hMap.get("rep_kri_nvl_0")%>" disabled/>
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
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div> 
	</article>  
		  
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 		  
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 팝업 --> 		  
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