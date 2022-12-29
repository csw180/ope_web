<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0115.jsp
 Program name : 외부손실사건 상세조회
 Description  : LDM-12
 Programer    : 이규탁
 Date created : 2022.08.12
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector lshpColMethCLst = CommUtil.getCommonCode(request, "COL_METHC");
if(lshpColMethCLst==null) lshpColMethCLst = new Vector();
Vector vLossDtlMap= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLossDtlMap==null) vLossDtlMap = new Vector();


HashMap hLossDtlMap = null;
if(vLossDtlMap.size()>0){
	hLossDtlMap = (HashMap)vLossDtlMap.get(0);
}else{
	hLossDtlMap = new HashMap();
}

String cas_tpnm = "";
String ifn_tpnm = "";
String hpn_tpnm = "";

if( !((String) hLossDtlMap.get("cas_tpnm_lv1")).equals("")&&!((String) hLossDtlMap.get("cas_tpnm")).equals("") ){
	cas_tpnm = (String) hLossDtlMap.get("cas_tpnm_lv1")+">"+(String) hLossDtlMap.get("cas_tpnm");
}else if( ((String) hLossDtlMap.get("cas_tpnm_lv1")).equals("")&&!((String) hLossDtlMap.get("cas_tpnm")).equals("") ){
	cas_tpnm = (String) hLossDtlMap.get("cas_tpnm");
}

if( !((String) hLossDtlMap.get("ifn_tpnm_lv1")).equals("")&&!((String) hLossDtlMap.get("ifn_tpnm")).equals("") ){
	ifn_tpnm = (String) hLossDtlMap.get("ifn_tpnm_lv1")+">"+(String) hLossDtlMap.get("ifn_tpnm");
}else if( ((String) hLossDtlMap.get("ifn_tpnm_lv1")).equals("")&&!((String) hLossDtlMap.get("ifn_tpnm")).equals("") ){
	ifn_tpnm = (String) hLossDtlMap.get("ifn_tpnm");
}

if( !((String) hLossDtlMap.get("hpn_tpnm_lv1")).equals("")&&!((String) hLossDtlMap.get("hpn_tpnm")).equals("") ){
	hpn_tpnm = (String) hLossDtlMap.get("hpn_tpnm_lv1")+">"+(String) hLossDtlMap.get("hpn_tpnm");
}else if( ((String) hLossDtlMap.get("hpn_tpnm_lv1")).equals("")&&!((String) hLossDtlMap.get("hpn_tpnm")).equals("") ){
	hpn_tpnm = (String) hLossDtlMap.get("hpn_tpnm");
}



%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<%@ include file="../comm/library.jsp" %>
<script>
	$(document).ready(function(){
		//$("#winRskMod",parent.document).show();
		parent.removeLoadingWs();
		
		etc_cntn();
		
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
	
	function mod(){
		
		var f = document.ormsForm;
		
		if (!confirm("수정하시겠습니까?")) return;
			
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "los");
		WP.setParameter("process_id", "ORLS011502");
		WP.setForm(f);
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();

		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function (result) {
					alert("수정되었습니다.");
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
					<h3 class="title">외부 손실사건 상세보기</h3>
				</div>


				<div class="p_body">					
					<div class="p_wrap">
						<div class="box box-header">
							<h4 class="box-title md20">▶기본정보</h4>
						</div>
						<div class="box box-search">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<th>외부손실 수집방법</th>
											<td>
												<div class="select">
													<select name="st_col_methc" id="st_col_methc" onchange="etc_cntn()" class="form-control">
													
	<%
	String col_methc = (String) hLossDtlMap.get("col_methc");
	for(int i=0;i<lshpColMethCLst.size();i++){
		HashMap hMap = (HashMap)lshpColMethCLst.get(i);
		if(((String)hMap.get("intgc")).equals(col_methc)){
	%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
	<%					
		}else{
	%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%					
		}
	}
	%>
														
													</select>
												</div>
											</td>
											<th>사건발생기관명</th>
											<td>
												<input type="text" name="hpn_ocu_orgnm" id="hpn_ocu_orgnm" value="<%=(String) hLossDtlMap.get("hpn_ocu_orgnm") %>" class="form-control">
											</td>
											<th>비고</th>
											<td>
												<input type="text" name="etc_out_rmk_cntn" id="etc_out_rmk_cntn" class="form-control" value="<%=(String) hLossDtlMap.get("etc_out_rmk_cntn") %>">
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="box box-header">
							<h4 class="box-title md20">▶사건 및 유형분류정보</h4>
						</div>
						<div class="box box-search">
							<div class="wrap-search mb20">
								<table>
									<tbody>
										<tr>
											<th>손실 사건 번호</th>
											<td>
												<input type="text" name="out_lshp_amnno" id="out_lshp_amnno" class="form-control" value="<%=(String) hLossDtlMap.get("out_lshp_amnno") %>" disabled>
												
											</td>
											<th>손실 사건 내용</th>
											<td rowspan="2" colspan="5">
												<textarea name="lss_dtl_cntn" id="lss_dtl_cntn" class="textarea h80"><%=StringUtil.htmlEscape((String) hLossDtlMap.get("lss_dtl_cntn"), false, false) %></textarea>
											</td>
										</tr>
										<tr>
											<th>손실 사건 제목</th>
											<td colspan = "2">
												<input type="text" name="lss_tinm" id="lss_tinm" class="form-control" value="<%=(String) hLossDtlMap.get("lss_tinm") %>">
											</td>
										</tr>
										<tr>
											<th>사건 발생 일자</th>
											<td>
												<div class="form-inline">
													<div class="input-group">
														<input type="text" class="form-control w100" id="ocu_dt" name="ocu_dt" value="<%=(String) hLossDtlMap.get("ocu_dt") %>" readonly>
														<span class="input-group-btn">
															<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','ocu_dt');"><i class="fa fa-calendar"></i></button>
														</span>
													</div>
												</div>
											</td>
											<th>사건 발견 일자</th>
											<td>
												<div class="form-inline">
													<div class="input-group">
														<input type="text" class="form-control w100" id="dscv_dt" name="dscv_dt" value="<%=(String) hLossDtlMap.get("dscv_dt") %>" readonly>
														<span class="input-group-btn">
															<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','dscv_dt');"><i class="fa fa-calendar"></i></button>
														</span>
													</div>
												</div>
											</td>
											<th>사건 등록 일자</th>
											<td>
												<div class="form-inline">
													<div class="input-group">
														<input type="text" class="form-control w100" id="inpdt" name="inpdt" value="<%=(String) hLossDtlMap.get("inpdt") %>" readonly> 
														<span class="input-group-btn">
															<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','inpdt');"><i class="fa fa-calendar"></i></button>
														</span>													
													</div>
												</div>
											</td>
										</tr>
										
									</tbody>
								</table>
							</div>
						</div>
						<div class = "box box-search">
							<div class = "wrap-search">
								<table>
									<tr>
										<th>제재대상</th>
										<td>
											<div class="input-group">
												<span class="input-group-addon">기관</span>
												<div class="select w100">
													<select name="st_org_snt_obj_yn" id="st_org_snt_obj_yn" class="form-control" >
<%
if( ((String) hLossDtlMap.get("org_snt_obj_yn")).equals("Y") ){
%>													
														<option value="Y" selected>Y</option>
														<option value="N">N</option>
<%
}else{
%>
														<option value="Y">Y</option>
														<option value="N" selected>N</option>
<%	
}
%>
													</select>
												</div>
											</div>
											<div class="input-group">
												<span class="input-group-addon">임원</span>
												<div class="select w100">
													<select name="st_drtr_snt_obj_yn" id="st_drtr_snt_obj_yn" class="form-control">
														
<%
if( ((String) hLossDtlMap.get("drtr_snt_obj_yn")).equals("Y") ){
%>													
														<option value="Y" selected>Y</option>
														<option value="N">N</option>
<%
}else{
%>
														<option value="Y">Y</option>
														<option value="N" selected>N</option>
<%	
}
%>
														
													</select>
												</div>
											</div>
											<div class="input-group">
												<span class="input-group-addon">직원</span>
												<div class="select w100">
													<select name="st_emp_snt_obj_yn" id="st_emp_snt_obj_yn" class="form-control">
													
<%
if( ((String) hLossDtlMap.get("emp_snt_obj_yn")).equals("Y") ){
%>													
														<option value="Y" selected>Y</option>
														<option value="N">N</option>
<%
}else{
%>
														<option value="Y">Y</option>
														<option value="N" selected>N</option>
<%	
}
%>
														
													</select>
												</div>
											</div>
										</td>
										<th>제재내용</th>
										<td>
											<textarea name="snt_cntn" id="snt_cntn" class="textarea" ><%=StringUtil.htmlEscape((String) hLossDtlMap.get("snt_cntn"), false, false) %></textarea>
										</td>
									</tr>
									<tr>
										<th>제재조치일</th>
										<td >
											<div class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control" id="snt_act_dt" name="snt_act_dt" value="<%=(String) hLossDtlMap.get("snt_act_dt") %>" readonly>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','snt_act_dt');"><i class="fa fa-calendar"></i></button>
													</span>
												</div>
											</div>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="box box-header">
							<h4 class="box-title md20">▶금액정보</h4>
						</div>
						<div class="box box-search">
							<div class="wrap-search">
								<table>
									<colgroup>
										<col style="width: 130px;">
										<col>
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
											<td>
												<div class="form-inline">
													<div class="input-group">
														<input type="text" name="ttls_am" id="ttls_am" onchange="solve_am()" maxLength="18" value="<%=(String) hLossDtlMap.get("ttls_am") %>" class="form-control right">
														<span class="input-group-addon">원</span>
													</div>
												</div>
											</td>
											<th>총회수금액<i class="label label-texe cb">(B)</i></th>
											<td>
												<div class="form-inline">
													<div class="input-group">
														<input type="text" name="tot_wdr_am" id="tot_wdr_am" onchange="solve_am()" maxLength="17" value="<%=(String) hLossDtlMap.get("tot_wdr_am") %>" class="form-control right">
														<span class="input-group-addon">원</span>
													</div>
												</div>
											</td>
											<th>순손실금액<i class="label label-texe cr">(A)</i>-<i class="label label-texe cb">(B)</i></th>
											<td>
												<div class="form-inline">
													<div class="input-group">
														<input type="text" name="guls_am" id="guls_am" value="<%=(String) hLossDtlMap.get("guls_am") %>" class="form-control right" disabled>
														<span class="input-group-addon">원</span>
													</div>
												</div>
											</td>
											<th>비고</th>
											<td>
												<textarea name="rmk_cntn" id="rmk_cntn" class="textarea"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="box box-header">
							<h4 class="box-title md20">▶관리정보</h4>
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
										<td>
											<div class="form-inline">
												<div class="select w80">
													<select name="st_rkp_hld_yn" id="st_rkp_hld_yn" class="form-control">
<%
if( ((String) hLossDtlMap.get("rkp_hld_yn")).equals("Y") ){
%>
														<option value="Y" selected>Y</option>
														<option value="N">N</option>

<%	
}else{
%>
														<option value="Y">Y</option>
														<option value="N" selected>N</option>
<%	
}
%>														
														
													</select>
												</div>
												<span class="txt txt-xs">* 외부 손실사건과 관련된 RP가 없는 경우, 외부손실사건 등록 전 신규 RP생성 후 관련 RP 정보를 입력해야 합니다.</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>관련 RP코드/RP명</th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="rkp_id" name="rkp_id" onchange="rkp_yn()" value="<%=(String) hLossDtlMap.get("oprk_rkp_id") %>" readonly>
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="rp_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
													</span>
												</div>
												<input type="text" name="rk_isc_cntn" id="rk_isc_cntn" class="form-control w700" value="<%=(String) hLossDtlMap.get("rk_isc_cntn") %>" readonly>
											</div>
										</td>
									</tr>
									<tr>
										<th>원인유형</th>
										<td >
											<div class="input-group w100p">
												<input type="text" class="form-control" id="cas_tpnm" name="cas_tpnm" value="<%=cas_tpnm %>" readonly>
												<input type="hidden" id="hd_cas_tpc" name="hd_cas_tpc" value="<%=(String) hLossDtlMap.get("cas_tpc") %>" />
												<span class="input-group-btn">
													<button class="btn btn-default ico search" type="button" onclick="cas_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>사건유형</th>
										<td>
											<div class="input-group w100p">
												<input type="text" class="form-control" id="hpn_tpnm" name="hpn_tpnm" value="<%=hpn_tpnm %>" readonly>
												<input type="hidden" id="hd_hpn_tpc" name="hd_hpn_tpc"  value="<%=(String) hLossDtlMap.get("hpn_tpc") %>" />
												<span class="input-group-btn">
													<button class="btn btn-default ico search" type="button" onclick="hpn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span></button>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>영향유형</th>
										<td>
											<div class="input-group w100p">
												<input type="text" class="form-control" id="ifn_tpnm" name="ifn_tpnm" value="<%=ifn_tpnm %>" readonly />
												<input type="hidden" id="hd_ifn_tpc" name="hd_ifn_tpc" value="<%=(String) hLossDtlMap.get("ifn_tpc") %>" />
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
				</div>

				<div class="p_foot">
					<div class="btn-wrap center">
						<button type="button" onclick="javascript:mod();" class="btn btn-primary">저장</button>
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
			parent.$("#ifrLossMod").attr("src","about:blank");
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
		$("#winLossMod",parent.document).hide();
	}

</script>
</body>
</html>