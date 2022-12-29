<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0123.jsp
 Program name : 외부손실사건(ORM) 상세조회
 Description  : 
 Programer    : 김남원
 Date created : 2022.04.15
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
		parent.removeLoadingWs();
	});

	
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

						<h4 class="box-title md">기본정보</h4>
						<div class="wrap-table mb20">
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
												<select name="st_col_methc" id="st_col_methc" onchange="etc_cntn()" class="form-control" disabled>
												
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
										<th>기타외부자료 비고</th>
										<td>
											<input type="text" name="etc_out_rmk_cntn" id="etc_out_rmk_cntn" class="form-control" value="<%=(String) hLossDtlMap.get("etc_out_rmk_cntn") %>" disabled>
										</td>
									</tr>
									<tr>
										<th>사건발생기관명</th>
										<td colspan="5">
											<input type="text" name="hpn_ocu_orgnm" id="hpn_ocu_orgnm" value="<%=(String) hLossDtlMap.get("hpn_ocu_orgnm") %>" class="form-control" disabled>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<h4 class="box-title md">사건 및 유형분류정보</h4>
						<div class="wrap-table mb20">
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
										<th>손실사건 관리번호</th>
										<td colspan="5">
											<input type="text" name="out_lshp_amnno" id="out_lshp_amnno" class="form-control w150" value="<%=(String) hLossDtlMap.get("out_lshp_amnno") %>" disabled>
											
										</td>
									</tr>
									<tr>
										<th>사건제목</th>
										<td colspan="5">
											<input type="text" name="lss_tinm" id="lss_tinm" class="form-control" value="<%=(String) hLossDtlMap.get("lss_tinm") %>" disabled>
										</td>
									</tr>
									<tr>
										<th>사건내용</th>
										<td colspan="5">
											<textarea name="lss_dtl_cntn" id="lss_dtl_cntn" class="textarea h80" disabled><%=StringUtil.htmlEscape((String) hLossDtlMap.get("lss_dtl_cntn"), false, false) %></textarea>
										</td>
									</tr>
									<tr>
										<th>제재대상</th>
										<td>
											<div class="input-group">
												<span class="input-group-addon">기관</span>
												<div class="select w100">
													<select name="st_org_snt_obj_yn" id="st_org_snt_obj_yn" class="form-control" disabled>
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
											<div class="input-group mt4">
												<span class="input-group-addon">임원</span>
												<div class="select w100">
													<select name="st_drtr_snt_obj_yn" id="st_drtr_snt_obj_yn" class="form-control" disabled>
														
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
											<div class="input-group mt4">
												<span class="input-group-addon">직원</span>
												<div class="select w100">
													<select name="st_emp_snt_obj_yn" id="st_emp_snt_obj_yn" class="form-control" disabled>
													
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
										<td colspan="3">
											<textarea name="snt_cntn" id="snt_cntn" class="textarea h100" disabled><%=StringUtil.htmlEscape((String) hLossDtlMap.get("snt_cntn"), false, false) %></textarea>
										</td>
									</tr>
									<tr>
										<th>제재조치일</th>
										<td colspan="5">
											<div class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="snt_act_dt" name="snt_act_dt" value="<%=(String) hLossDtlMap.get("snt_act_dt") %>" disabled>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>발생일자</th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="ocu_dt" name="ocu_dt" value="<%=(String) hLossDtlMap.get("ocu_dt") %>" disabled>
												</div>
											</div>
										</td>
										<th>발견일자</th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="dscv_dt" name="dscv_dt" value="<%=(String) hLossDtlMap.get("dscv_dt") %>" disabled>
												</div>
											</div>
										</td>
										<th>입력일자</th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="inpdt" name="inpdt" value="<%=(String) hLossDtlMap.get("inpdt") %>" disabled> 
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>원인유형</th>
										<td colspan="5">
											<div class="input-group w100p">
												<input type="text" class="form-control" id="cas_tpnm" name="cas_tpnm" value="<%=cas_tpnm %>" disabled>
												<input type="hidden" id="hd_cas_tpc" name="hd_cas_tpc" value="<%=(String) hLossDtlMap.get("cas_tpc") %>" />
											</div>
										</td>
									</tr>
									<tr>
										<th>사건유형</th>
										<td colspan="5">
											<div class="input-group w100p">
												<input type="text" class="form-control" id="hpn_tpnm" name="hpn_tpnm" value="<%=hpn_tpnm %>" disabled>
												<input type="hidden" id="hd_hpn_tpc" name="hd_hpn_tpc"  value="<%=(String) hLossDtlMap.get("hpn_tpc") %>" />
											</div>
										</td>
									</tr>
									<tr>
										<th>영향유형</th>
										<td colspan="5">
											<div class="input-group w100p">
												<input type="text" class="form-control" id="ifn_tpnm" name="ifn_tpnm" value="<%=ifn_tpnm %>" disabled />
												<input type="hidden" id="hd_ifn_tpc" name="hd_ifn_tpc" value="<%=(String) hLossDtlMap.get("ifn_tpc") %>" />
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<h4 class="box-title md">금액정보</h4>
						<div class="wrap-table mb20">
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
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" name="ttls_am" id="ttls_am" onchange="solve_am()" maxLength="18" value="<%=(String) hLossDtlMap.get("ttls_am") %>" class="form-control right w150" disabled>
													<span class="input-group-addon">원</span>
												</div>
											</div>
										</td>
										<th rowspan="3">비고</th>
										<td rowspan="3" colspan="3">
											<textarea name="rmk_cntn" id="rmk_cntn" class="textarea h110" disabled></textarea>
										</td>
									</tr>
									<tr>
										<th>총회수금액<i class="label label-texe cb">(B)</i></th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" name="tot_wdr_am" id="tot_wdr_am" onchange="solve_am()" maxLength="17" value="<%=(String) hLossDtlMap.get("tot_wdr_am") %>" class="form-control right w150" disabled>
													<span class="input-group-addon">원</span>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>순손실금액<i class="label label-texe cr">(A)</i>-<i class="label label-texe cb">(B)</i></th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" name="guls_am" id="guls_am" value="<%=(String) hLossDtlMap.get("guls_am") %>" class="form-control right w150" disabled>
													<span class="input-group-addon">원</span>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<h4 class="box-title md">관리정보</h4>
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
													<select name="st_rkp_hld_yn" id="st_rkp_hld_yn" class="form-control" disabled>
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
													<input type="text" class="form-control w100" id="rkp_id" name="rkp_id" onchange="rkp_yn()" value="<%=(String) hLossDtlMap.get("oprk_rkp_id") %>" disabled>
												</div>
												<input type="text" name="rk_isc_cntn" id="rk_isc_cntn" class="form-control w700" value="<%=(String) hLossDtlMap.get("rk_isc_cntn") %>" disabled>
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
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>


				<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
			</div>

		<div class="dim p_close"></div>
	</div>
	</form>
	
	
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
	});

</script>
</body>
</html>