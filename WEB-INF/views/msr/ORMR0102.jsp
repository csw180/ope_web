<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0102.jsp
 Program name : 영업지수 매핑 신규등록(팝업)
 Description  : MSR-03
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

/* Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
if(vLst3==null) vLst3 = new Vector();
Vector vLst4= CommUtil.getResultVector(request, "grp01", 0, "unit04", 0, "vList");
if(vLst4==null) vLst4 = new Vector(); */

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector vLst= CommUtil.getCommonCode(request, "LV1_BIZ_IX_C");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getCommonCode(request, "LV2_BIZ_IX_C");
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getCommonCode(request, "ACC_TPC");
if(vLst3==null) vLst3 = new Vector();
Vector vLst4= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst4==null) vLst4 = new Vector();
Vector vLst5= CommUtil.getCommonCode(request, "FILL_YN_DSC");
if(vLst4==null) vLst4 = new Vector();


HashMap hAccSbjMap = null;
if(vLst4.size()>0){
	hAccSbjMap = (HashMap)vLst4.get(0);
}else{
	hAccSbjMap = new HashMap();
}
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>계정과목 신규 매핑 및 수정(공통)</title>
		<script language="javascript">
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
<%
	if(vLst4.size()>0){
%>
			$('#acc_sbj_cnm').val('<%=(String)hAccSbjMap.get("acc_sbj_cnm")%>'); //계정과목코드명
			$('#acc_sbjnm').val('<%=(String)hAccSbjMap.get("acc_sbjnm")%>'); //계정과목명
			$('#up_acc_sbj_cnm').val('<%=(String)hAccSbjMap.get("up_acc_sbj_cnm")%>'); //상위계정과목코드명
			$('#lvl_no').val('<%=(String)hAccSbjMap.get("lvl_no")%>'); //레벨번호
			//$('#lv1_biz_ix_c').val('<%=(String)hAccSbjMap.get("lv1_biz_ix_c")%>'); //1레벨영업지수코드
			$('#biz_ix_lv1_nm').val('<%=(String)hAccSbjMap.get("biz_ix_lv1_nm")%>'); //1레벨영업지수코드
			//$('#lv2_biz_ix_c').val('<%=(String)hAccSbjMap.get("lv2_biz_ix_c")%>'); //2레벨영업지수코드
			$('#biz_ix_lv2_nm').val('<%=(String)hAccSbjMap.get("biz_ix_lv2_nm")%>'); //2레벨영업지수코드
			$('#acc_tpc').val('<%=(String)hAccSbjMap.get("acc_tpc")%>'); //계정유형코드
			$('#fill_yn_dsc').val('<%=(String)hAccSbjMap.get("fill_yn_dsc")%>'); //상위/기표 여부
			$('#mpp_bas_cntn').val('<%=(String)hAccSbjMap.get("mpp_bas_cntn")%>'); //매핑근거
			$('#rev_opn_cntn').val('<%=(String)hAccSbjMap.get("rev_opn_cntn")%>'); //검토의견
			//$('#sbj_cntn').val('@%=(String)hAccSbjMap.get("sbj_cntn")%@'); //과목내용
			
<%
	}
%>
			//신규수정 구분(I:신규 U:수정 R:연결)
			/* if(parent.ormsForm.mode.value == "I"){
				$('#mode').val("I");
				$('#acc_sbj_cnm').val($('#acc_sbj_cnm',parent.document).val());
				$('#acc_sbjnm').val($('#acc_sbjnm',parent.document).val());
				$('#acc_sbj_cnm').attr('readonly', false);
			}else if(parent.ormsForm.mode.value == "R"){
				$('#mode').val("I");
				$('#acc_sbj_cnm').val($('#acc_sbj_cnm',parent.document).val());
				$('#acc_sbjnm').val($('#acc_sbjnm',parent.document).val());
				$('#acc_sbj_cnm').attr('readonly', true);
			}else 
			 */
			if(parent.ormsForm.mode.value == "U"){
				$('#mode').val("U");
				$('#acc_sbj_cnm').attr('readonly', true);
			}else if(parent.ormsForm.mode.value == "R"){ //ORMR0112 (재무제표 계정과목 관리) 에서 호출
				$('#mode').val("I");
				$('#acc_sbj_cnm').val($('#acc_sbj_cnm',parent.document).val());
				$('#acc_sbjnm').val($('#acc_sbjnm',parent.document).val());
				$('#lvl_no').val($('#lvl_no',parent.document).val());
				$('#up_acc_sbj_cnm').val($('#up_acc_sbj_cnm',parent.document).val());
				
				$('#biz_ix_lv1_nm').val($('#biz_ix_lv1_nm',parent.document).val());
				$('#biz_ix_lv2_nm').val($('#biz_ix_lv2_nm',parent.document).val());
				
				$('#acc_tpc').val($('#acc_tpc',parent.document).val());
				//$('#sbj_cntn').val($('#sbj_cntn',parent.document).val());
				$('#fill_yn_dsc').val($('#acc_tpc',parent.document).val());
				
				$('#rev_opn_cntn').val($('#rev_opn_cntn',parent.document).val());
				$('#acc_sbj_cnm').attr('readonly', true);
			}else if(parent.ormsForm.mode.value == "S"){
				$('#mode').val("S");
				$('#acc_sbj_cnm').attr('readonly', true);
				$('#acc_sbjnm').attr('readonly', true);
				$('#lvl_no').attr('readonly', true);
				$('#up_acc_sbj_cnm').attr('readonly', true);
				$('#biz_ix_lv1_nm').attr('readonly', true);
				$('#biz_ix_lv2_nm').attr('readonly', true);
				$('#acc_tpc').attr('readonly', true);
				$('#fill_yn_dsc').attr('readonly', true);
				$('#mpp_bas_cntn').attr('readonly', true);
				$('#rev_opn_cntn').attr('readonly', true);
				document.getElementById('btn_save').disabled = true;
			}
			
			// 영업지수 Lv1 변경시
			$('#lv1_biz_ix_c').change(function(){
				$('#lv2_biz_ix_c option').remove();
				$('#lv2_biz_ix_c').prepend("<option value=''>전체</option>");
				if($('#lv1_biz_ix_c option:selected').val() == ""){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
%>
					$('#lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
	}
%>	
				}else if($('#lv1_biz_ix_c option:selected').val() == "01"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("01")){
%>
					$('#lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>					
				}else if($('#lv1_biz_ix_c option:selected').val() == "02"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("02")){
%>
					$('#lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}else if($('#lv1_biz_ix_c option:selected').val() == "03"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("03")){
%>
					$('#lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}else if($('#lv1_biz_ix_c option:selected').val() == "99"){
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
		if(((String)hMap.get("intgc")).substring(0,2).equals("99")){
%>
					$('#lv2_biz_ix_c option:eq(0)').after("<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>");
<%
		}
	}
%>
				}
			});
		});
		
		function doAction(sAction) {
			switch(sAction) {
				case "help":	//영업지수 변동내역조회 팝업
					$("#winHelp").show();
					
					break;
			}
		}
		
		function addORMR0103(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="msr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORMR010301";
			f.target = "ifrORMR0103";
			f.submit();
		}
		
		function save(){
			var f = document.ormsForm;
			
			if(f.acc_sbj_cnm.value.trim()==''){
				alert("계정과목코드를 입력하십시오.");
				f.acc_sbj_cnm.focus();
				return;
			}
			
			if(f.up_acc_sbj_cnm.value.trim()==''){
				alert("상위계정과목코드를 입력하십시오.");
				f.up_acc_sbj_cnm.focus();
				return;
			}
			
			if(f.acc_sbjnm.value.trim()==''){
				alert("계정과목명을 입력하십시오.");
				f.acc_sbjnm.focus();
				return;
			}
			
			if(f.udt_rsn_cntn ==''){
				alert("매핑근거를 입력하십시오.");
				f.udt_rsn_cntn.focus();
				return;
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "msr");
			WP.setParameter("process_id", "ORMR010202");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("저장 하였습니다.");
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
	<body onkeyPress="return EnterkeyPass()";  style="background-color:transparent">
	<form name="ormsForm">
		<input type="hidden" id="path" name="path" />
		<input type="hidden" id="process_id" name="process_id" />
		<input type="hidden" id="commkind" name="commkind" />
		<input type="hidden" id="method" name="method" />
		
		<input type="hidden" id="mode" name="mode" /> <!-- 신규수정 구분(I:신규 U:수정) -->
		
		<div id="" class="popup modal block">
				<div class="p_frame w1200 h550">
	
					<div class="p_head">
						<h3 class="title">계정과목 신규 매핑 및 수정</h3>
					</div>
	
	
					<div class="p_body">
						
						<div class="p_wrap">
	
							<div class="box box-grid">						
								<div class="box-header">		
									<h4 class="title md">연결 계정과목 정보</h4>
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
												<th>계정과목코드</th>
												<td><input type="text" class="form-control" id="acc_sbj_cnm" name="acc_sbj_cnm" readonly="readonly"/></td>
												<th>계정과목명</th>
												<td><input type="text" class="form-control" id="acc_sbjnm" name="acc_sbjnm" /></td>
												<th>계정 유형</th>
												<td>
													<span class="select">
														<select class="form-control" id="acc_tpc" name="acc_tpc">
															<option value="">전체</option>
<%
		for(int i=0;i<vLst3.size();i++){
			HashMap hMap = (HashMap)vLst3.get(i);
%>
															<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
		}
%>
														</select>
													</span>
												</td>
											</tr>
											<tr>
												<th>계정 Level</th>
												<td><input type="text" class="form-control" id="lvl_no" name="lvl_no" /></td>
												<th>상위계정코드</th>
												<td><input type="text" class="form-control" id="up_acc_sbj_cnm" name="up_acc_sbj_cnm" /></td>
												<!-- 
												<th>과목</th>
												<td><input type="text" class="form-control" id="sbj_cntn" name="sbj_cntn" /></td>
												 -->
												<th>상위/기표계정</th>
												<td>
													<span class="select">
														<select class="form-control" id="fill_yn_dsc" name="fill_yn_dsc">
<%
		for(int i=0;i<vLst5.size();i++){
			HashMap hMap = (HashMap)vLst5.get(i);
%>
															<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
		}
%>
														</select>
													</span>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
	
							<div class="box box-grid mt20">						
								<div class="box-header">		
									<h4 class="title md">
										영업지수 정보
										<button type="button" class="btn btn-normal btn-xs btn-help ml10" onclick="javascript:doAction('help');"><i class="fa fa-exclamation-circle"></i><span class="ml5">HELP</span></button>
									</h4>
								</div>
								<div class="wrap-table">
									<table>
										<colgroup>
											<col style="width: 150px;">
											<col>
											<col>
											<col style="width: 150px;">
											<col>
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th>영업지수 Lv.1</th>
												<td>
													<div class="select ">
														<select class="form-control" id="lv1_biz_ix_c" name="lv1_biz_ix_c">
															<option value="">전체</option>
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
%>
															<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
		}
%>
														</select>
													</div>
												</td>
												<td>
													<input type="text" class="form-control" id="biz_ix_lv1_nm" name="biz_ix_lv1_nm" readonly/>
												</td>
												<th>영업지수 Lv.2</th>
												<td>
													<div class="select ">
														<select class="form-control" id="lv2_biz_ix_c" name="lv2_biz_ix_c">
															<option value="">전체</option>
<%
		for(int i=0;i<vLst2.size();i++){
			HashMap hMap = (HashMap)vLst2.get(i);
%>
															<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
		}
%>
														</select>
													</div>
												</td>
												<td>
													<input type="text" class="form-control" id="biz_ix_lv2_nm" name="biz_ix_lv2_nm" readonly />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="box box-grid mt20">						
								<div class="box-header">		
									<h4 class="title md">
										영업지수 매핑 등록/수정 근거사유
									</h4>
								</div>
								<div class="wrap-table">
									<table>
										<colgroup>
											<col style="width: 150px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th>매핑근거</th>
												<td>
													<input type="text" class="form-control" id="mpp_bas_cntn" name="mpp_bas_cntn" />
												</td>
												
											</tr>
											<tr>
												<th>유관부서 검토의견</th>
												<td>
													<input type="text" class="form-control" id="rev_opn_cntn" name="rev_opn_cntn" />
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
							<button id="btn_save" name="btn_save" type="button" class="btn btn-primary" onclick="javascript:save();">저장</button>
							<button type="button" class="btn btn-default btn-close">취소</button>
						</div>
					</div>
	
					<button class="ico close fix btn-close" ><span class="blind">닫기</span></button>
	
				</div>
			<div class="dim p_close"></div>
		</div>
	</form>
	<!-- popup -->
	<div id="winHelp" class="popup modal" style="background-color:transparent">
		<iframe name="ifrHelp" id="ifrHelp" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/msr/ORMR0103" width="100%" height="100%" frameborder="0" allowTransparency="true" ></iframe>
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
			
/* 		function closePop(){
			$("#winNewAccAdd",parent.document).hide();
		}
 */	</script>
</html>