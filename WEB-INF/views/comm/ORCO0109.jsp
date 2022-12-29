<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0109.jsp
 Program name : 공통 > 리스크풀 조회(팝업)
 Description  : 
 Programer    : 권성학
 Date created : 2021.06.08
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			$("#winRp",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"업무프로세스|LV1",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"prssnm1"				},
				{Header:"업무프로세스|LV2",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"prssnm2"				},
				{Header:"업무프로세스| LV3",	Type:"Text",	Width:150,	Align:"Left",	SaveName:"prssnm3"				},
				{Header:"업무프로세스|LV4",		Type:"Text",	Width:200,	Align:"Left",	SaveName:"prssnm4"				},
				{Header:"원인 유형|LV1",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"casnm1"				},
				{Header:"원인 유형|LV2",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"casnm2"				},
				{Header:"원인 유형|LV3",		Type:"Text",	Width:200,	Align:"Left",	SaveName:"casnm3"				},
				{Header:"사건 유형|LV1",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"hpnnm1"				},
				{Header:"사건 유형|LV2",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"hpnnm2"				},
				{Header:"사건 유형|LV3",		Type:"Text",	Width:200,	Align:"Left",	SaveName:"hpnnm3"				},
				{Header:"영향 유형|LV1",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"ifnnm1"				},
				{Header:"영향 유형|LV2",		Type:"Text",	Width:150,	Align:"Left",	SaveName:"ifnnm2"				},
				{Header:"이머징리스크 유형|LV1",	Type:"Text",	Width:150,	Align:"Left",	SaveName:"emrknm1"				},
				{Header:"이머징리스크 유형|LV2",	Type:"Text",	Width:150,	Align:"Left",	SaveName:"emrknm2"				},
				{Header:"중요RP여부|중요RP여부",	Type:"Text",	Width:80,	Align:"Center",	SaveName:"krk_yn"				},
				{Header:"RP ID|RP ID",		Type:"Text",	Width:100,	Align:"Center",	SaveName:"rkp_id"				},
				{Header:"리스크 사례|리스크 사례",	Type:"Text",	Width:500,	Align:"Left",	SaveName:"rk_isc_cntn",	Wrap:1	},
			];
			
			IBS_InitSheet(mySheet,initData);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			mySheet.SetEditable(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//mySheet.SetAutoRowHeight(1);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//doAction('search');
			
		}
		
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				parent.rpSearchEnd($("#rkp_id").val(),$("#rk_isc_cntn").val());
			}
		}

		function mySheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

			if(NewRow >= mySheet.GetDataFirstRow()){
				$("#rkp_id").val(mySheet.GetCellValue(NewRow,"rkp_id"));
				$("#rk_isc_cntn").val(mySheet.GetCellValue(NewRow,"rk_isc_cntn"));
			}
		}

		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa1");
					$("form[name=ormsForm] [name=process_id]").val("ORRC010102");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "select": 
					if($("#rkp_id").val() == ""){
						alert("RP를 선택해 주십시오.");
						return;
					}
				
					parent.rpSearchEnd($("#rkp_id").val(),$("#rk_isc_cntn").val());
					break;
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				cur_click();
			}
		}
		
		function cur_click() {
			
			if(parent.CUR_rkp_id!=null && parent.CUR_rkp_id!=""){
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j, "rkp_id")==parent.CUR_rkp_id){
							mySheet.SetSelectRow(j);
							break;
						}
					}
				}
				
			}
		}
		
/* 		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction("search");
				return true;
			}else{
				return true;
			}
		} */
		
	</script>

</head>
<body onkeyPress="return EnterkeyPass()">
	<article class="popup modal block">
		<div class="p_frame w1100">

			<div class="p_head">
				<h1 class="title">RP선택</h1>
			</div>
			<div class="p_body">
				<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				
				<input type="hidden" id="rkp_id" name="rkp_id" value="" />
				<input type="hidden" id="rk_isc_cntn" name="rk_isc_cntn" value="" />
				
				<input type="hidden" id="sch_hd_bsn_prss_c" name="sch_hd_bsn_prss_c" />
				<input type="hidden" id="sch_hd_hpn_tpc" name="sch_hd_hpn_tpc" value="" />
				<input type="hidden" id="sch_hd_cas_tpc" name="sch_hd_cas_tpc" value="" />
				<input type="hidden" id="sch_hd_ifn_tpc" name="sch_hd_ifn_tpc" value="" />
				<input type="hidden" id="sch_hd_emrk_tpc" name="sch_hd_emrk_tpc" value="" />
				<div class="p_wrap">

					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<th>업무프로세스</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w120" id="sch_hd_bsn_prss_c_nm" name="sch_hd_bsn_prss_c_nm" readonly>
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="prss_popup();">
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button>
													</span>
												</div>	
											</td>
											<th>원인유형</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w120" id="sch_hd_cas_tpc_nm" name="sch_hd_cas_tpc_nm" readonly>
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="cas_popup();">
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button>
													</span>
												</div>	
											</td>
											<th>사건유형</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w120" id="sch_hd_hpn_tpc_nm" name="sch_hd_hpn_tpc_nm" readonly>
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="hpn_popup();">
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button>
													</span>
												</div>	
											</td>
										</tr>
										<tr>
											<th>영향유형</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w120" id="sch_hd_ifn_tpc_nm" name="sch_hd_ifn_tpc_nm" readonly>
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="ifn_popup();">
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button>
													</span>
												</div>	
											</td>
											<th>이머징리스크유형</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w120" id="sch_hd_emrk_tpc_nm" name="sch_hd_emrk_tpc_nm" readonly>
													<span class="input-group-btn">
														<button class="btn btn-default ico search" type="button" onclick="emrk_popup();">
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button>
													</span>
												</div>	
											</td>
											<th>RP 유형</th>
											<td>
												<select class="form-control w150" id="sch_st_rkp_tpc" name="sch_st_rkp_tpc" >
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
											</td>
										</tr>
										<tr>
											<th>리스크 사례</th>
											<td colspan="5">
												<input type="text" name="sch_rk_isc_cntn" id="sch_rk_isc_cntn" class="form-control" onkeypress="EnterkeySubmit(doAction, 'search');">
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="box-footer">
							<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
						</div>
					</div>
					
					<section class="box box-grid">
						<div class="wrap-grid h330">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>

				</div>
				</form>
			</div>

			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="doAction('select');">선택</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
			<button class="ico close fix btn-close"><span class="blind">닫기</span></button>

		</div>
		<div class="dim p_close"></div>
	</article>
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/EmrkInfP.jsp" %> <!-- 이머징리스크유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	<script>
	
		// 업무프로세스검색 완료
		var PRSS4_ONLY = false; 
		var CUR_BSN_PRSS_C = "";
		
		function prss_popup(){
			CUR_BSN_PRSS_C = $("#sch_hd_bsn_prss_c").val();
			if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
			schPrssPopup();
		}

		function prssSearchEnd(bsn_prss_c, bsn_prsnm
								, bsn_prss_c_lv1, bsn_prsnm_lv1
								, bsn_prss_c_lv2, bsn_prsnm_lv2
								, bsn_prss_c_lv3, bsn_prsnm_lv3
								, biz_trry_c_lv1, biz_trry_cnm_lv1
								, biz_trry_c_lv2, biz_trry_cnm_lv2){
			
			if (bsn_prss_c.substr(2,2) == "00")
				bsn_prss_c = bsn_prss_c.substr(0,2);
			else if (bsn_prss_c.substr(4,2) == "00")
				bsn_prss_c = bsn_prss_c.substr(0,4);
			else if (bsn_prss_c.substr(6,2) == "00")
				bsn_prss_c = bsn_prss_c.substr(0,6);
				
				
			$("#sch_hd_bsn_prss_c").val(bsn_prss_c);
			$("#sch_hd_bsn_prss_c_nm").val(bsn_prsnm);
			
			$("#winPrss").hide();
		}
		
		// 손실사건유형검색 완료
		var HPN3_ONLY = false; 
		var CUR_HPN_TPC = "";
		
		function hpn_popup(){
			CUR_HPN_TPC = $("#sch_hd_hpn_tpc").val();
			if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
			schHpnPopup();
		}
		
		function hpnSearchEnd(hpn_tpc, hpn_tpnm
							, hpn_tpc_lv1, hpn_tpnm_lv1
							, hpn_tpc_lv2, hpn_tpnm_lv2){

			if (hpn_tpc.substr(2,2) == "00")
				hpn_tpc = hpn_tpc.substr(0,2);
			else if (hpn_tpc.substr(4,2) == "00")
				hpn_tpc = hpn_tpc.substr(0,4);
			
			$("#sch_hd_hpn_tpc").val(hpn_tpc);
			$("#sch_hd_hpn_tpc_nm").val(hpn_tpnm);
			
			$("#winHpn").hide();
		}
		
		// 원인유형검색 완료
		var CAS3_ONLY = false; 
		var CUR_CAS_TPC = "";
		
		function cas_popup(){
			CUR_CAS_TPC = $("#sch_hd_cas_tpc").val();
			schCasPopup();
		}
		
		function casSearchEnd(cas_tpc, cas_tpnm
							, cas_tpc_lv1, cas_tpnm_lv1
							, cas_tpc_lv2, cas_tpnm_lv2){

			if (cas_tpc.substr(2,2) == "00")
				cas_tpc = cas_tpc.substr(0,2);
			else if (cas_tpc.substr(4,2) == "00")
				cas_tpc = cas_tpc.substr(0,4);
			
			$("#sch_hd_cas_tpc").val(cas_tpc);
			$("#sch_hd_cas_tpc_nm").val(cas_tpnm);
			
			$("#winCas").hide();
		}
		
		$(document).ready(function(){
			$(".btn-close").click( function(event){
				//$("#winRp",parent.document).hide();
				$("#winRp",parent.document).hide();
				event.preventDefault();
			});
		});

		// 영향유형검색 완료
		var IFN2_ONLY = false; 
		var CUR_IFN_TPC = "";
		
		function ifn_popup(){
			CUR_IFN_TPC = $("#sch_hd_ifn_tpc").val();
			schIfnPopup();
		}
		
		function ifnSearchEnd(ifn_tpc, ifn_tpnm
							, ifn_tpc_lv1, ifn_tpnm_lv1
							, ifn_tpc_lv2, ifn_tpnm_lv2){

			if (ifn_tpc.substr(2,2) == "00")
				ifn_tpc = ifn_tpc.substr(0,2);
			
			$("#sch_hd_ifn_tpc").val(ifn_tpc);
			$("#sch_hd_ifn_tpc_nm").val(ifn_tpnm);
			
			$("#winIfn").hide();
		}
	
		// 이머징리스크유형검색 완료
		var EMRK2_ONLY = false; 
		var CUR_EMRK_TPC = "";
		
		function emrk_popup(){
			CUR_EMRK_TPC = $("#sch_emrk_c").val();
			schEmrkPopup();
		}
		
		function emrkSearchEnd(emrk_tpc, emrk_tpnm
							, emrk_tpc_lv1, emrk_tpnm_lv1){

			if (emrk_tpc.substr(2,2) == "00")
				emrk_tpc = emrk_tpc.substr(0,2);
			
			$("#sch_hd_emrk_tpc").val(emrk_tpc);
			$("#sch_hd_emrk_tpc_nm").val(emrk_tpnm);
			
			$("#winEmrk").hide();
		}
		
		function closePop(){
			//$("#winRp",parent.document).hide();
			$("#winRp",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#rkp_id").val("");
			$("#rk_isc_cntn").val("");
			
			closePop();
		});
		
	</script>
</body>
</html>
