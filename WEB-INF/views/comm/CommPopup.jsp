<%--
/*---------------------------------------------------------------------------
 Program ID   : CommPopup.jsp
 Program name : 공통팝업
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.03
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>

</head>
<body >
			<div class="container">
				<!-- Content Header (Page header) -->
	<%@ include file="../comm/header.jsp" %>
				<form name="ormsForm">
					<!-- 조회 영역 한줄인 경우 -->
					<section class="box search-area case01">
						<div class="box-body">
							<div class="wrap-search">
								<table class="table">
									<colgroup>
										<col style="width: 150px" />
										<col style="width: 200px" />
										<col style="width: 200px" />
										<col style="width: 80px" />
										<col style="width: 5px" />
										<col style="width: 150px" />
										<col style="width: 200px" />
										<col style="width: 200px" />
										<col style="width: 80px" />
									</colgroup>
									<tr>
										<th scope="row"><label for="input03" class="control-label">부서</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_brnm1" name="sch_brnm1" onKeyPress="EnterkeySubmitOrg('sch_brnm1', 'orgSearchEnd1');"></td>
										<td><input type="text" class="form-control w150 fl" id="sch_brc1" name="sch_brc1"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="schOrgPopup('sch_brnm1', 'orgSearchEnd1');">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="org_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">부서-멀티</label></th>
										<td id="brc_td"></td>
										<td id="brcd_area"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="org_popup2();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="org_remove2()">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
										<td colspan="4"></td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">부서별직원조회</label></th>
										<td><input type="text" class="form-control w150 fl" id="emp_nm" name="emp_nm"></td>
										<td><input type="text" class="form-control w150 fl" id="emp_no" name="emp_no"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="orgEmpPopup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="orgEmp_remove()">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
										<td colspan="4"></td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">직원</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_empnm" name="sch_empnm" maxlength="20"></td>
										<td><input type="text" class="form-control w150 fl" id="sch_eno" name="sch_eno"><input type="text" class="form-control w150 fl" id="sch_oft" name="sch_oft"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="emp_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="emp_remove()">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
										<td colspan="4"></td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">업무프로세스</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_prss_nm" name="sch_prss_nm"/></td>
										<td><input type="text" class="form-control w150 fl" id="sch_prss_c" name="sch_prss_c" ></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="prss_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="prss_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">원인</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_cas_nm" name="sch_cas_nm"></td>
										<td><input type="text" class="form-control w150 fl" id="sch_cas_c" name="sch_cas_c"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="cas_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="cas_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">사건</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_hpn_nm" name="sch_hpn_nm"></td>
										<td><input type="text" class="form-control w150 fl" id="sch_hpn_c" name="sch_hpn_c"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="hpn_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="hpn_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">영향</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_ifn_nm" name="sch_ifn_nm"></td>
										<td><input type="text" class="form-control w150 fl" id="sch_ifn_c" name="sch_ifn_c"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="ifn_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="ifn_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">이머징리스크</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_emrk_nm" name="sch_emrk_nm"></td>
										<td><input type="text" class="form-control w150 fl" id="sch_emrk_c" name="sch_emrk_c"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="emrk_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="emrk_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">RP선택</label></th>
										<td><input type="text" class="form-control w150 fl" id="oprk_rkp_id" name="oprk_rkp_id"></td>
										<td>
											<textarea name="rk_isc_cntn" id="rk_isc_cntn" class="textarea h50"></textarea>	
										</td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="riskpool_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico" onclick="riskpool_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
										<td colspan="4"></td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">KRI선택</label></th>
										<td><input type="text" class="form-control w150 fl" id="oprk_rki_id" name="oprk_rki_id"></td>
										<td>
											<textarea name="oprk_rkinm" id="oprk_rkinm" class="textarea h50"></textarea>	
										</td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="kripool_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico" onclick="kripool_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
										<td colspan="4"></td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">손실선택</label></th>
										<td><input type="text" class="form-control w150 fl" id="lshp_amnno" name="lshp_amnno"></td>
										<td>
											<textarea name="lss_tinm" id="lss_tinm" class="textarea h50"></textarea>	
										</td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="loss_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico" onclick="loss_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
										<td colspan="4"></td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">팀</label></th>
										<td><input type="text" class="form-control w150 fl" id="sch_idvdc_val" name="sch_idvdc_val"></td>
										<td><input type="text" class="form-control w150 fl" id="sch_intg_idvd_cnm" name="sch_intg_idvd_cnm"></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="team_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="team_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input03" class="control-label">결재</label></th>
										<td><input type="text" class="form-control w150 fl" id="" name=""></td>
										<td><input type="text" class="form-control w150 fl" id="" name=""></td>
										<td>
											<button type="button" class="btn btn-default ico fl" onclick="dcz_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<button type="button" class="btn btn-default ico fl" onclick="dcz_remove();">
												<i class="fa fa-times-circle"></i>
											</button>
										</td>
									</tr>
								</table>
							</div><!-- .wrap-search -->
						</div><!-- .box-body //--> 
					</section>
					<!-- 조회 영역 한줄인 경우 //-->
				</form>
			</div>
			<!-- /.container -->		
		
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서멀티 공통 팝업 -->
	<%@ include file="../comm/OrgEmpInfP.jsp" %> <!-- 부서별직원 공통 팝업 -->
	<%@ include file="../comm/EmpInfP.jsp" %> <!-- 직원 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/EmrkInfP.jsp" %> <!-- 이머징리스크유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 공통 팝업 -->
	<%@ include file="../comm/KriP.jsp" %> <!-- KRI 공통 팝업 -->
	<%@ include file="../comm/LossP.jsp" %> <!-- 손실 공통 팝업 -->
	<%@ include file="../comm/TeamInfp.jsp" %> <!-- 팀 공통 팝업 -->
	<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
	
	<script>
		
	
<%--부서 시작 --%>
		var init_flag = false;
		function org_popup1(){
			schOrgPopup("sch_brnm1", "orgSearchEnd1","0");
			if($("#sch_hd_brc_nm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		// 부서검색 완료
		function orgSearchEnd1(brc, brnm){
			$("#sch_brc1").val(brc);
			$("#sch_brnm1").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
		
		function org_remove(){
			$("#sch_brc1").val("");
			$("#sch_brnm1").val("");
		}
<%--부서 끝 --%>		

<%--부서-멀티 시작 --%>
	function org_popup2(){
		var brcs = new Array();
		$("input[name=brc]").each(function(idx){
			brcs.push($(this).val());
		});
		var bizo_tpcs = new Array();
		$("input[name=bizo_tpc]").each(function(idx){
			bizo_tpcs.push($(this).val());
		});
		schOrgMPopup(brcs, bizo_tpcs, "orgSearchEnd2","0");//처리모드(0:전체,1:본부부서,2:본부부서+영업점유형 )
	}
	
	function orgSearchEnd2(brc, brnm, bizo_tpc, bizo_tpc_nm){
		var html = "";
		var code_html = "";
		for(var i=0;i<brc.length;i++){
			html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+brnm[i]+"</span></button>";
			code_html += "<input type='hidden' name='brc' value='" + brc[i] + "' />";
		}
		for(var i=0;i<bizo_tpc.length;i++){
			html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+bizo_tpc_nm[i]+"</span></button>";
			code_html += "<input type='hidden' name='bizo_tpc' value='" + bizo_tpc[i] + "' />";
		}
	
		$("#brcd_area").html(code_html);
		$("#brc_td").html(html);
		$("#winBuseoM").hide();
		//doAction('search');
	}
	
	function org_remove2(){
		$("#brcd_area").text("");
		$("#brc_td").html("");
	}
<%--부서-멀티 끝 --%>

<%--부서별직원 시작 --%>
	//부서별직원조회 팝업 호출
	function orgEmpPopup(){
		schOrgEmpPopup("orgEmpSearchEnd");
		//$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
	}
	
	// 부서별직원검색 완료
	function orgEmpSearchEnd(eno, enm){
		$("#emp_no").val(eno);
		$("#emp_nm").val(enm);
		closeBuseoEmp();
		//$("#winBuseoEmp").hide();
		//doAction('search');
	}
	
	function orgEmp_remove(){
		$("#emp_no").val("");
		$("#emp_nm").val("");
	}
<%-- 부서별직원 끝 --%>		
		
<%-- 직원 시작 --%>		
	function emp_popup(){
		schEmpPopup("<%=brc%>","empSearchEnd");
		//$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
	}
	// 직원검색 완료
	function empSearchEnd(eno, empnm, brnm, oft){
		$("#sch_eno").val(eno);
		$("#sch_empnm").val(empnm);
		$("#sch_oft").val(oft);
		$("#winEmp").hide();
		//doAction('search');
	}
	
	function emp_remove(){
		$("#sch_eno").val("");
		$("#sch_empnm").val("");
		$("#sch_oft").val("");
	}
<%-- 직원 끝 --%>
		
<%-- 업무프로세스 시작 --%>			
	// 업무프로세스검색 완료
	var PRSS4_ONLY = true; 
	var CUR_BSN_PRSS_C = "";
	
	function prss_popup(){
		CUR_BSN_PRSS_C = $("#sch_prss_c").val();
		if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
		schPrssPopup();
	}
	
	function prssSearchEnd(bsn_prss_c, bsn_prsnm
						, bsn_prss_c_lv1, bsn_prsnm_lv1
						, bsn_prss_c_lv2, bsn_prsnm_lv2
						, bsn_prss_c_lv3, bsn_prsnm_lv3){
		$("#sch_prss_c").val(bsn_prss_c);
		$("#sch_prss_nm").val(bsn_prsnm);
		
		$("#winPrss").hide();
	}
	
	function prss_remove(){
		$("#sch_prss_c").val("");
		$("#sch_prss_nm").val("");
	}
<%-- 업무프로세스 끝 --%>

<%-- 사건유형 시작 --%>
	// 사건유형검색 완료
	var HPN3_ONLY = true; 
	var CUR_HPN_TPC = "";
	
	function hpn_popup(){
		CUR_HPN_TPC = $("#sch_hpn_c").val();
		if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
		schHpnPopup();
	}
	
	function hpnSearchEnd(hpn_tpc, hpn_tpnm
						, hpn_tpc_lv1, hpn_tpnm_lv1
						, hpn_tpc_lv2, hpn_tpnm_lv2){
		$("#sch_hpn_c").val(hpn_tpc);
		$("#sch_hpn_nm").val(hpn_tpnm);
		
		$("#winHpn").hide();
		//doAction('search');
	}
	
	function hpn_remove(){
		$("#sch_hpn_c").val("");
		$("#sch_hpn_nm").val("");
	}
<%-- 사건유형 끝 --%>
		
<%-- 원인유형 시작 --%>
	// 원인유형검색 완료
	var CAS3_ONLY = true; 
	var CUR_CAS_TPC = "";
	
	function cas_popup(){
		CUR_CAS_TPC = $("#sch_cas_c").val();
		schCasPopup();
	}
	
	function casSearchEnd(cas_tpc, cas_tpnm
						, cas_tpc_lv1, cas_tpnm_lv1
						, cas_tpc_lv2, cas_tpnm_lv2){
		$("#sch_cas_c").val(cas_tpc);
		$("#sch_cas_nm").val(cas_tpnm);
		
		$("#winCas").hide();
		//doAction('search');
	}
	
	function cas_remove(){
		$("#sch_cas_c").val("");
		$("#sch_cas_nm").val("");
	}
<%-- 원인유형 끝 --%>

<%-- 영향유형 시작 --%>
	// 영향유형검색 완료
	var IFN2_ONLY = true; 
	var CUR_IFN_TPC = "";
	
	function ifn_popup(){
		CUR_IFN_TPC = $("#sch_ifn_c").val();
		schIfnPopup();
	}
	
	function ifnSearchEnd(ifn_tpc, ifn_tpnm
						, ifn_tpc_lv1, ifn_tpnm_lv1
						, ifn_tpc_lv2, ifn_tpnm_lv2){
		$("#sch_ifn_c").val(ifn_tpc);
		$("#sch_ifn_nm").val(ifn_tpnm);
		
		$("#winIfn").hide();
		//doAction('search');
	}
	
	function ifn_remove(){
		$("#sch_ifn_c").val("");
		$("#sch_ifn_nm").val("");
	}
<%-- 영향유형 끝 --%>
	
<%-- 이머징리스크유형 시작 --%>
	// 이머징리스크유형검색 완료
	var EMRK2_ONLY = true; 
	var CUR_EMRK_TPC = "";
	
	function emrk_popup(){
		CUR_EMRK_TPC = $("#sch_emrk_c").val();
		schEmrkPopup();
	}
	
	function emrkSearchEnd(emrk_tpc, emrk_tpnm
						, emrk_tpc_lv1, emrk_tpnm_lv1){
		$("#sch_emrk_c").val(emrk_tpc);
		$("#sch_emrk_nm").val(emrk_tpnm);
		
		$("#winEmrk").hide();
		//doAction('search');
	}
	
	function emrk_remove(){
		$("#sch_emrk_c").val("");
		$("#sch_emrk_nm").val("");
	}
<%-- 이머징리스크유형 끝 --%>

<%-- 리스크풀 시작 --%>
	// 리스크풀 검색 완료
	var CUR_RKP_ID = "";
	
	function riskpool_popup(){
		CUR_RKP_ID = $("#oprk_rkp_id").val();
		schRpPopup();
	}
	
	function rpSearchEnd(oprk_rkp_id, rk_isc_cntn){
		$("#oprk_rkp_id").val(oprk_rkp_id);
		$("#rk_isc_cntn").val(rk_isc_cntn);
		
		$("#winRp").hide();
	}
	
	function riskpool_remove(){
		$("#oprk_rkp_id").val("");
		$("#rk_isc_cntn").val("");
	}
<%-- 리스크풀 끝 --%>

<%-- KRI 시작 --%>
	// 리스크풀 검색 완료
	var CUR_RKI_ID = "";
	
	function kripool_popup(){
		CUR_RKI_ID = $("#oprk_rki_id").val();
		schKriPopup();
	}
	
	function kriSearchEnd(oprk_rki_id, oprk_rkinm){
		$("#oprk_rki_id").val(oprk_rki_id);
		$("#oprk_rkinm").val(oprk_rkinm);
		
		$("#winKri").hide();
	}
	
	function kripool_remove(){
		$("#oprk_rki_id").val("");
		$("#oprk_rkinm").val("");
	}
<%-- KRI 끝 --%>

<%-- 손실 시작 --%>
	// 리스크풀 검색 완료
	var CUR_LOSS_ID = "";
	
	function loss_popup(){
		CUR_LOSS_ID = $("#lshp_amnno").val();
		schLossPopup();
	}
	
	function lossSearchEnd(lshp_amnno, lss_tinm){
		$("#lshp_amnno").val(lshp_amnno);
		$("#lss_tinm").val(lss_tinm);
		
		$("#winLoss").hide();
	}
	
	function loss_remove(){
		$("#lshp_amnno").val("");
		$("#lss_tinm").val("");
	}
<%-- 손실 끝 --%>

<%-- 팀 조회 시작 --%>
		// 팀 검색 완료
		var TEAM_ONLY = true; 
		var CUR_TEAM_TPC = "";
		
		function team_popup(){
			CUR_EMRK_TPC = $("#sch_idvdc_val").val();
			schTeamPopup();
		}
		
		function teamSearchEnd(idvdc_val, intg_idvd_cnm
							, idvdc_val_lv1, intg_idvd_cnm_lv1){
			$("#sch_idvdc_val").val(idvdc_val);
			$("#sch_intg_idvd_cnm").val(intg_idvd_cnm);
			
			$("#winTeam").hide();
			//doAction('search');
		}
		
		function team_remove(){
			$("#sch_idvdc_val").val("");
			$("#sch_intg_idvd_cnm").val("");
		}
<%-- 팀 조회 끝 --%>

<%-- 결재 시작 --%>			
		//결재 팝업 호출
		function dcz_popup(auth){
			var cnt=0;
			var temp=null;
			for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
				if(mySheet2.GetCellValue(j,"ischeck")==1){
					cnt++;
					temp = mySheet2.GetCellValue(j,"rki_id");
				}
			}
			if(cnt == 1) {
				$("#dcz_rki_id").val(temp);
			}
			else if(cnt == 0) {
				alert('하나 이상의 항목을 선택해주세요.');
				$("#dcz_rki_id").val(null);
				return;
			}else{
				$("#dcz_rki_id").val(null);
			}
			schDczPopup(auth);
		}

		// 결재검색 완료
		function DczSearchEndCmp(){
			doAction('cmp');
			closeDczP();
		}
		function DczSearchEndRtn(){
			doAction('rtn');
			closeDczP();
		}
		<%-- 결재 끝 --%>
	</script>
</body>
</html>