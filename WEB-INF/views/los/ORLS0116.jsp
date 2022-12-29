<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0116.jsp
 Program name : 외부손실사건 신규등록
 Description  : 
 Programer    : 김남원
 Date created : 2022.04.15
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");


/* Vector lshpColMethCLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(lshpColMethCLst==null) lshpColMethCLst = new Vector(); */
//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector lshpColMethCLst = CommUtil.getCommonCode(request, "COL_METHC");
if(lshpColMethCLst==null) lshpColMethCLst = new Vector();

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd 

String today = dt.substring(0,4)+"-"+dt.substring(4,6)+"-"+dt.substring(6,8);

%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script language="javascript">
	$(document).ready(function(){
		//$("#winRskMod",parent.document).show();
		parent.removeLoadingWs();
	});
	
	function solve_am(){
		var ttls_am = $("#ttls_am").val();
		var tot_wdr_am = $("#tot_wdr_am").val();
		var guls_am = 0;
		
		guls_am = ttls_am - tot_wdr_am;
		
		$("#guls_am").val(guls_am);
		
	}
	
	function rkp_yn(){
		if($("#rkp_id").val()!=""){
			$("#st_rkp_hld_yn").val("Y");
		}
	}
	
	function etc_cntn(){
		var etc = $("#st_col_methc").val();
		
		if(etc=="03"){
			document.getElementById('etc_out_rmk_cntn').disabled = false;
		}else{
			document.getElementById('etc_out_rmk_cntn').disabled = true;
			$("#etc_out_rmk_cntn").val("");
		}
	}
	
	function save(){
		var f = document.ormsForm;
		var com = true;
		var col_methc = $("#st_col_methc").val();
		var etc_cntn = $("#etc_out_rmk_cntn").val();
		
		if(col_methc==""){
			alert("수집방법을 선택해주세요.");
			com = false;
			return;
		}
		if(col_methc=="03" && etc_cntn==""){
			alert("기타외부자료내용을 입력해주세요.");
			com = false;
			return;
		}
		if($("#hpn_ocu_orgnm").val()==""){
			alert("사건발생기관명을 입력해주세요.");
			com = false;
			return;
		}
		if($("#lss_tinm").val()==""){
			alert("사건제목을 입력해주세요.");
			com = false;
			return;
		}
		if($("#lss_dtl_cntn").val()==""){
			alert("사건내용을 입력해주세요.");
			com = false;
			return;
		}
		if($("#dscv_dt").val()==""){
			alert("발견일자를 선택해주세요.");
			com = false;
			return;
		}
/* 		if($("#snt_act_dt").val()==""){
			alert("제재조치일을 선택해주세요.");
			com = false;
			return;
		} */
		if($("#inpdt").val()==""){
			alert("입력일자를 선택해주세요.");
			com = false;
			return;
		}
/*		if($("#ocu_dt").val()==""){
			alert("발생일자를 선택해주세요.");
			com = false;
			return;
		}
 		if($("#ttls_am").val()=="0"){
			alert("총손실금액을 입력해주세요.");
			com = false;
			return;
		} */
		if($("#snt_act_dt").val() < $("#ocu_dt").val()){
			alert("제재조치일은 발생일자보다 커야합니다.");
			com = false;
			return;
		}
		if($("#dscv_dt").val() < $("#ocu_dt").val()){
			alert("발견일자는 발생일자보다 커야합니다.");
			com = false;
			return;
		}
		if($("#inpdt").val() < $("#ocu_dt").val()){
			alert("입력일자는 발생일자보다 커야합니다.");
			com = false;
			return;
		}
		if($("#inpdt").val() < $("#snt_act_dt").val()){
			alert("입력일자는 제재조치일보다 커야합니다.");
			com = false;
			return;
		}
		if($("#inpdt").val() < $("#dscv_dt").val()){
			alert("입력일자는 발견일자보다 커야합니다.");
			com = false;
			return;
		}
		
		if(com){
			if (!confirm("저장하시겠습니까?")) return;
				
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "los");
			WP.setParameter("process_id", "ORLS011602");
			WP.setForm(f);
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
	
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function (result) {
						alert("저장되었습니다.");
						removeLoadingWs();
						closePop();
						parent.doAction("search");
					},
	
					complete: function (statusText, status) {
						
					},
	
					error: function (rtnMsg) {
						alert(JSON.stringify(rtnMsg));
					}
				});
		}
		
		
	}
	
	</script>

</head>
<body>
	<form name="ormsForm">
		<input type="hidden" id="path" name="path" />
		<input type="hidden" id="process_id" name="process_id" />
		<input type="hidden" id="commkind" name="commkind" />
		<input type="hidden" id="method" name="method" />
	<div id="" class="popup modal block">
			<div class="p_frame w1100">

				<div class="p_head">
					<h3 class="title">외부 손실사건 신규등록</h3>
				</div>


				<div class="p_body">					
					<div class="p_wrap">

						<div class="box">
							<div class="box-header">
								<h4 class="box-title">기본정보</h4>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 130px;">
										<col>
										<col style="width: 130px;">
										<col>
										<col style="width: 130px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>외부손실 수집방법</th>
											<td colspan="3">
												<div class="select">
													<select name="st_col_methc" id="st_col_methc" onchange="etc_cntn()" class="form-control">
														<option value="" selected>전체</option>
	<%
	for(int i=0;i<lshpColMethCLst.size();i++){
		HashMap hMap = (HashMap)lshpColMethCLst.get(i);
	%>
														<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%					
	}
	%>												
													</select>
												</div>
											</td>
											<th>기타외부자료 비고</th>
											<td>
												<input type="text" name="etc_out_rmk_cntn" id="etc_out_rmk_cntn" class="form-control" disabled>
											</td>
										</tr>
										<tr>
											<th>사건발생기관명</th>
											<td colspan="5">
												<input type="text" name="hpn_ocu_orgnm" id="hpn_ocu_orgnm" class="form-control">
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

						<div class="box">
							<div class="box-header">
								<h4 class="box-title">사건 및 유형분류정보</h4>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 130px;">
										<col>
										<col style="width: 130px;">
										<col>
										<col style="width: 130px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>사건제목</th>
											<td colspan="5">
												<input type="text" name="lss_tinm" id="lss_tinm" class="form-control">
											</td>
										</tr>
										<tr>
											<th>사건내용</th>
											<td colspan="5">
												<textarea name="lss_dtl_cntn" id="lss_dtl_cntn" class="textarea h80"></textarea>
											</td>
										</tr>
										<tr>
											<th>제재대상</th>
											<td>
												<div class="input-group">
													<span class="input-group-addon">기관</span>
													<div class="select w100">
														<select name="st_org_snt_obj_yn" id="st_org_snt_obj_yn" class="form-control">
															<option value="Y">Y</option>
															<option value="N" selected>N</option>
														</select>
													</div>
												</div>
												<div class="input-group mt4">
													<span class="input-group-addon">임원</span>
													<div class="select w100">
														<select name="st_drtr_snt_obj_yn" id="st_drtr_snt_obj_yn" class="form-control">
															<option value="Y">Y</option>
															<option value="N" selected>N</option>
														</select>
													</div>
												</div>
												<div class="input-group mt4">
													<span class="input-group-addon">직원</span>
													<div class="select w100">
														<select name="st_emp_snt_obj_yn" id="st_emp_snt_obj_yn" class="form-control">
															<option value="Y">Y</option>
															<option value="N" selected>N</option>
														</select>
													</div>
												</div>
											</td>
											<th>제재내용</th>
											<td colspan="3">
												<textarea name="snt_cntn" id="snt_cntn" class="textarea h100"></textarea>
											</td>
										</tr>
										<tr>
											<th>제재조치일</th>
											<td colspan="5" class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="snt_act_dt" name="snt_act_dt" readonly>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','snt_act_dt');"><i class="fa fa-calendar"></i></button>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>발생일자</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="ocu_dt" name="ocu_dt" readonly>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','ocu_dt');"><i class="fa fa-calendar"></i></button>
													</span>
												</div>
											</td>
											<th>발견일자</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="dscv_dt" name="dscv_dt" readonly>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','dscv_dt');"><i class="fa fa-calendar"></i></button>
													</span>
												</div>
											</td>
											<th>입력일자</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="inpdt" name="inpdt" value="<%=today %>" readonly> 
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','inpdt');"><i class="fa fa-calendar"></i></button>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>원인유형</th>
											<td colspan="5">
												<div class="input-group w100p">
													<input type="text" class="form-control w100p" id="cas_tpnm" name="cas_tpnm">
													<input type="hidden" id="hd_cas_tpc" name="hd_cas_tpc" />
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="cas_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>사건유형</th>
											<td colspan="5">
												<div class="input-group w100p">
													<input type="text" class="form-control" id="hpn_tpnm" name="hpn_tpnm"  readonly>
													<input type="hidden" id="hd_hpn_tpc" name="hd_hpn_tpc" />
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="hpn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span></button>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>영향유형</th>
											<td colspan="5">
												<div class="input-group w100p">
													<input type="text" class="form-control" id="ifn_tpnm" name="ifn_tpnm" readonly />
													<input type="hidden" id="hd_ifn_tpc" name="hd_ifn_tpc" />
													<span class="input-group-btn">
														<button type="button" class="btn btn-default btn-sm ico" onclick="ifn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span></button>
													</span>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

						<div class="box">
							<div class="box-header">
								<h4 class="box-title">금액정보</h4>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 130px;">
										<col>
										<col style="width: 130px;">
										<col>
										<col style="width: 130px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>총손실금액<i class="label label-texe cr">(A)</i></th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" name="ttls_am" id="ttls_am" onchange="solve_am()" maxLength="18" value="0" class="form-control right w150">
													<span class="input-group-addon">원</span>
												</div>
											</td>
											<th rowspan="3">비고</th>
											<td rowspan="3" colspan="3">
												<textarea name="rmk_cntn" id="rmk_cntn" class="textarea h110"></textarea>
											</td>
										</tr>
										<tr>
											<th>총회수금액<i class="label label-texe cb">(B)</i></th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" name="tot_wdr_am" id="tot_wdr_am" onchange="solve_am()" maxLength="17" value="0" class="form-control right w150">
													<span class="input-group-addon">원</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>순손실금액<i class="label label-texe cr">(A)</i>-<i class="label label-texe cb">(B)</i></th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" name="guls_am" id="guls_am" value="0" class="form-control right w150" disabled>
													<span class="input-group-addon">원</span>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

						<div class="box box-grid">
							<div class="box-header">
								<h4 class="box-title">관리정보</h4>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 130px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>관련RP보유여부 <span class="cr">*</span></th>
											<td class="form-inline">
												<div class="select">
													<select name="st_rkp_hld_yn" id="st_rkp_hld_yn" class="form-control w80">
														<option value="Y">Y</option>
														<option value="N" selected>N</option>
													</select>
												</div>
												<span class="txt txt-xs">* 외부 손실사건과 관련된 RP가 없는 경우, 외부손실사건 등록 전 신규 RP생성 후 관련 RP 정보를 입력해야 합니다.</span>
											</td>
										</tr>
										<tr>
											<th>관련 RP코드/RP명</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="rkp_id" name="rkp_id" onchange="rkp_yn()" readonly>
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="rp_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
													</span>
												</div>
												<input type="text" name="rk_isc_cntn" id="rk_isc_cntn" class="form-control w700" readonly>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

					</div>					
				</div>

				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" onclick="javascript:save();" class="btn btn-primary">저장</button>
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>


				<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
			</div>

		<div class="dim p_close"></div>
	</div>
	</form>
	
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			parent.$("#ifrLossAdd").attr("src","about:blank");
			event.preventDefault();
		});
	});
	
	// 리스크풀검색 완료
	
	var CUR_RKP_ID = "";
	
	function rp_popup(){
		CUR_rkp_ID = $("#rkp_id").val();
		schRpPopup();
	}
	
	function rpSearchEnd(rkp_id, rk_isc_cntn){
		$("#rkp_id").val(rkp_id);
		$("#rk_isc_cntn").val(rk_isc_cntn);
		$("#winRp").hide();
		//doAction('search');
	}
		
	// 손실사건유형검색 완료
	
	var HPN2_ONLY = true; 
	var CUR_HPN_TPC = "";
	
	function hpn_popup(){
		CUR_HPN_TPC = $("#hd_hpn_tpc").val();
		if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
		schHpnPopup();
	}
	
	function hpnSearchEnd(hpn_tpc, hpn_tpnm , hpn_tpc_lv1, hpn_tpnm_lv1 , hpn_tpc_lv2, hpn_tpnm_lv2){
		$("#hd_hpn_tpc").val(hpn_tpc_lv2);
		$("#hpn_tpnm").val(hpn_tpnm_lv1+">"+hpn_tpnm_lv2);
		
		$("#winHpn").hide();
		//doAction('search');
	}
	
	// 원인유형검색 완료
	var CAS2_ONLY = true; 
	var CUR_CAS_TPC = "";
	
	function cas_popup(){
		CUR_CAS_TPC = $("#hd_cas_tpc").val();
		schCasPopup();
	}
	
	function casSearchEnd(cas_tpc, cas_tpnm , cas_tpc_lv1, cas_tpnm_lv1 , cas_tpc_lv2, cas_tpnm_lv2){
		$("#hd_cas_tpc").val(cas_tpc_lv2);
		$("#cas_tpnm").val(cas_tpnm_lv1+">"+cas_tpnm_lv2);
		
		$("#winCas").hide();
		//doAction('search');
	}
	
	// 영향유형검색 완료
	var IFN2_ONLY = true;
	var CUR_IFN_TPC = "";
	
	function ifn_popup() {
		CUR_IFN_TPC = $("#hd_ifn_tpc").val();
		schIfnPopup();
	}
	
	function ifnSearchEnd(ifn_tpc, ifn_tpnm, ifn_tpc_lv1, ifn_tpnm_lv1) {
		$("#hd_ifn_tpc").val(ifn_tpc_lv1);
		$("#ifn_tpnm").val(ifn_tpnm_lv1+">"+ifn_tpnm);
	
		$("#winIfn").hide();
		//doAction('search');
	}
	
	function closePop(){
		$("#winLossAdd",parent.document).hide();
	}
	</script>
</body>
</html>