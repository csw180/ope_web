<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0114.jsp
 Program name : 외부 손실사건 조회
 Description  : LDM-11
 Programer    : 이규탁
 Date created : 2022.08.12
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector lshpColMethCLst = CommUtil.getCommonCode(request, "COL_METHC");
if(lshpColMethCLst==null) lshpColMethCLst = new Vector();


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	
	<script>
	$(document).ready(function(){
	
		// ibsheet 초기화
		initIBSheet();
		
		set_am_knd();
		set_dt_knd();
	});
		
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
		initData.Cols = [
			{Header:"",						Type:"CheckBox",SaveName:"ischeck",			MinWidth:50,		Align:"Left", 	Wrap:true},
			{Header:"관리번호|관리번호",			Type:"Text",	SaveName:"out_lshp_amnno",	MinWidth:100,		Align:"Center", Hidden:true,	Wrap:true,		Edit:0},
			{Header:"정보\n출처|정보\n출처",			Type:"Text",	SaveName:"col_metnm",		MinWidth:150,		Align:"Center", 	Wrap:true,		Edit:0},
			{Header:"발생\n법인|발생\n법인",	Type:"Text",	SaveName:"hpn_ocu_orgnm",	MinWidth:120,		Align:"Left", 	Wrap:true,		Edit:0},
			{Header:"손실사건제목|손실사건제목",			Type:"Text",	SaveName:"lss_tinm",		MinWidth:300,		Align:"Left", 	Wrap:true,		Edit:0},
			{Header:"제재대상|제재대상",			Type:"Text",	SaveName:"snt_actnm",		MinWidth:80,		Align:"Center", Hidden:true, 	Wrap:true,		Edit:0},
			{Header:"일자|사건발생\n일자",				Type:"Text",	SaveName:"ocu_dt",			MinWidth:90,		Align:"Center", 	Wrap:true,		Edit:0,Format:"yyyy-MM-dd"},
			{Header:"일자|사건발견\n일자",				Type:"Text",	SaveName:"dscv_dt",			MinWidth:90,		Align:"Center",		Wrap:true,		Edit:0,Format:"yyyy-MM-dd"},
			{Header:"일자|제재조치일",			Type:"Text",	SaveName:"snt_act_dt",	 	MinWidth:90,		Align:"Center", 	Wrap:true,		Edit:0,Format:"yyyy-MM-dd"},
			{Header:"일자|사건등록\n일자",				Type:"Text",	SaveName:"inpdt",			MinWidth:90,		Align:"Center", 	Wrap:true,		Edit:0,Format:"yyyy-MM-dd"},
			{Header:"금액|총손실",				Type:"Int",		SaveName:"ttls_am",			MinWidth:120,		Align:"Right", 	Wrap:true,		Edit:0},
			{Header:"금액|회수액",				Type:"Int",		SaveName:"tot_wdr_am",		MinWidth:120,		Align:"Right", 	Wrap:true,		Edit:0},
			{Header:"금액|순손실",				Type:"Int",		SaveName:"guls_am",			MinWidth:120,		Align:"Right", 	Wrap:true,		Edit:0},
			{Header:"관련\n리스크사례\n보유여부|관련\n리스크사례\n보유여부",			Type:"Text",				SaveName:"rkp_hld_yn",				MinWidth:60,	Align:"Center", 	Wrap:true,	Edit:0},
			{Header:"관련\n리스크사례\n코드|관련\n리스크사례\n코드",						Type:"Text",				SaveName:"oprk_rkp_id",				MinWidth:100,	Align:"Center", 	Wrap:true,	Edit:0},
			{Header:"관련\n리스크사례명|관련\n리스크사례명",						Type:"Text",				SaveName:"oprk_rkp_id",				MinWidth:100,	Align:"Center", 	Wrap:true,	Edit:0},
			{Header:"사건유형|LV1~LV4",	Type:"Text",	SaveName:"hpn_tpnm",		MinWidth:150,		Align:"Left", 	Wrap:true,		Edit:0},
			{Header:"원인유형|LV1~LV4",	Type:"Text",	SaveName:"cas_tpnm",		MinWidth:150,		Align:"Left", 	Wrap:true,		Edit:0},
			{Header:"영향유형|LV1~LV4",	Type:"Text",	SaveName:"ifn_tpnm",		MinWidth:150,		Align:"Left", 	Wrap:true,		Edit:0},
			{Header:"기관제재대상여부|기관제재대상여부",				Type:"Text",				SaveName:"org_snt_obj_yn",			MinWidth:100,	Align:"Left", 	Hidden:true},
			{Header:"임원제재대상여부|임원제재대상여부",				Type:"Text",				SaveName:"drtr_snt_obj_yn",			MinWidth:100,	Align:"Left", 	Hidden:true},
			{Header:"직원제재대상여부|직원제재대상여부",				Type:"Text",				SaveName:"emp_snt_obj_yn",			MinWidth:100,	Align:"Left", 	Hidden:true},
		];
		
		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		mySheet.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		//헤더기능 해제
		mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		doAction('search');
		
	}
	
	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		//alert(Row);
		if(Row >= mySheet.GetDataFirstRow()){
			$("#hd_out_lshp_amnno").val(mySheet.GetCellValue(Row,"out_lshp_amnno"));
			doAction('mod');
		}
	}
	
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		if(Row >= mySheet.GetDataFirstRow()){
			$("#hd_out_lshp_amnno").val(mySheet.GetCellValue(Row,"out_lshp_amnno"));
		}
	}
	
	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				
	/*Sheet 각종 처리*/
	function doAction(sAction) {
		switch(sAction) {
			case "search":  //데이터 조회
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("los");
				$("form[name=ormsForm] [name=process_id]").val("ORLS011402");
				
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
				
			case "add":		//신규등록 팝업
				showLoadingWs();
				//$("#ifrLossAdd").attr("src","about:blank");
				$("#winLossAdd").show();
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="los";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORLS011601";
				f.target = "ifrLossAdd";
				f.submit();
				
				break; 
				
			case "mod":		//수정 팝업
				if($("#hd_out_lshp_amnno").val() == ""){
					alert("대상 손실사건을 선택하세요.");
					return;
				}else{
					//$("#ifrLossMod").attr("src","about:blank");
					showLoadingWs();
					$("#winLossMod").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="los";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORLS011501";
					f.target = "ifrLossMod";
					f.submit();
				}
			
				break; 
				
			case "del":		//삭제 처리
				
				var checkRow = mySheet.FindCheckedRow("ischeck");
				
				if(checkRow == ""){
					alert("삭제할 손실사건을 선택해주세요.");
				}else{
					del();
				}
				break; 
				
			case "down2excel":
				var downCols = "out_lshp_amnno|col_metnm|hpn_ocu_orgnm|lss_tinm|snt_actnm|snt_act_dt|ocu_dt|dscv_dt"+
							   "inpdt|ttls_am|tot_wdr_am|guls_am|ifn_tpnm|hpn_tpnm|cas_tpnm|rkp_hld_yn|oprk_rkp_id";
				
				var titleText = "외부 손실사건";
				var userMerge = "0,0,2,14";
				
				mySheet.Down2Excel({FileName:"외부 손실사건", Merge:1, DownCols:downCols, TitleText:titleText, UserMerge:userMerge})
				
				break;
		}
	}

	
	function mySheet_OnSearchEnd(code, message) {

		if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			if(mySheet.GetDataFirstRow()>0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if( mySheet.GetCellValue(i, "org_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "drtr_snt_obj_yn")=="N" && mySheet.GetCellValue(i, "emp_snt_obj_yn")=="N" ){
						mySheet.SetCellValue(i, "snt_actnm", "기관");
					}else if( mySheet.GetCellValue(i, "org_snt_obj_yn")=="N" && mySheet.GetCellValue(i, "drtr_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "emp_snt_obj_yn")=="N" ){
						mySheet.SetCellValue(i, "snt_actnm", "임원");
					}else if( mySheet.GetCellValue(i, "org_snt_obj_yn")=="N" && mySheet.GetCellValue(i, "drtr_snt_obj_yn")=="N" && mySheet.GetCellValue(i, "emp_snt_obj_yn")=="Y" ){
						mySheet.SetCellValue(i, "snt_actnm", "직원");
					}else if( mySheet.GetCellValue(i, "org_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "drtr_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "emp_snt_obj_yn")=="N" ){
						mySheet.SetCellValue(i, "snt_actnm", "기관, 임원");
					}else if( mySheet.GetCellValue(i, "org_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "drtr_snt_obj_yn")=="N" && mySheet.GetCellValue(i, "emp_snt_obj_yn")=="Y" ){
						mySheet.SetCellValue(i, "snt_actnm", "기관, 직원");
					}else if( mySheet.GetCellValue(i, "org_snt_obj_yn")=="N" && mySheet.GetCellValue(i, "drtr_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "emp_snt_obj_yn")=="Y" ){
						mySheet.SetCellValue(i, "snt_actnm", "임원, 직원");
					}else if( mySheet.GetCellValue(i, "org_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "drtr_snt_obj_yn")=="Y" && mySheet.GetCellValue(i, "emp_snt_obj_yn")=="Y" ){
						mySheet.SetCellValue(i, "snt_actnm", "기관, 임원, 직원");
					}
					
				}
			}
			
			
		}
	}
	
	function mySheet_OnSaveEnd(code, msg) {

	    if(code >= 0) {
	        alert("완료 되었습니다.");  // 저장 성공 메시지
	        doAction("search");      
	    } else {
	        alert("실패했습니다."); // 저장 실패 메시지
	    }
	}
	
	function set_dt_knd(){
		if($("#st_dt_knd").val()==""){
			$("#txt_st_dt").val("");
			$("#txt_ed_dt").val("");
			document.getElementById('txt_st_dt_btn').disabled = true;
			document.getElementById('txt_ed_dt_btn').disabled = true;
		}else{
			document.getElementById('txt_st_dt_btn').disabled = false;
			document.getElementById('txt_ed_dt_btn').disabled = false;
		}
	}
	function set_am_knd(){
		if($("#st_am_knd").val()==""){
			$("#txt_st_am").val("");
			$("#txt_ed_am").val("");
			document.getElementById('txt_st_am').disabled = true;
			document.getElementById('txt_ed_am').disabled = true;
		}else{
			document.getElementById('txt_st_am').disabled = false;
			document.getElementById('txt_ed_am').disabled = false;
		}
	}
	
	function del(){
		
		var f = document.ormsForm;
		var html = "";
		
		
		if (!confirm("삭제하시겠습니까?")) return;
		
		for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
			if(mySheet.GetCellValue(i, "ischeck")=="1"){
				html += '<input type="hidden" id="out_lshp_amnno" name="out_lshp_amnno" value="'+mySheet.GetCellValue(i, "out_lshp_amnno")+'">'
			}
		}
			
		$("#loss_html").html(html);
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "los");
		WP.setParameter("process_id", "ORLS011403");
		WP.setForm(f);
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function (result) {
					alert("삭제되었습니다.");
					doAction("search");
				},

				complete: function (statusText, status) {
					removeLoadingWs();
				},

				error: function (rtnMsg) {
					alert(JSON.stringify(rtnMsg));
				}
			});
		
		
		
	}

		

		
	</script>
	
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<div class="content">
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="hd_out_lshp_amnno" name="hd_out_lshp_amnno" />
			<input type="hidden" class="form-control" id="grp_org_c" name="grp_org_c" value="<%=grp_org_c %>">
			<div id="loss_html"></div>
			
			
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tr>
								<th>손실사건 번호</th>
								<td>
									<input type="text" class="form-control w180" id="out_lshp_amnno" name="out_lshp_amnno">
								</td>
								<th>조회 일자</th>
								<td colspan="5" class="form-inline">
									<div class="select">
										<select class="form-control w120" id="st_dt_knd" name="st_dt_knd" onchange="set_dt_knd()">
											<option value="">전체</option>
											<option value="1">제재조치일</option>
											<option value="2">발생일자</option>
											<option value="3">발견일자</option>
											<option value="4">입력일자</option>
										</select>
									</div>
									<div class="input-group">
										<input type="text" class="form-control w100" id="txt_st_dt" name="txt_st_dt" readonly>
										<span class="input-group-btn">
											<button type="button" class="btn btn-default ico fl" id="txt_st_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');"  disabled>
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</div>  
									<div class="input-group">
										<div class="input-group-addon"> ~ </div>
										<input type="text" class="form-control w100" id="txt_ed_dt" name="txt_ed_dt" readonly>
										<span class="input-group-btn">
											<button type="button" class="btn btn-default ico fl" id="txt_ed_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');"  disabled>
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</div>
								</td>
								<th>원인유형</th>
								<td class="form-inline">
									<div class="input-group">
										<input type="text" class="form-control w90" id="cas_tpnm" name="cas_tpnm" readonly>
										<input type="hidden" id="cas_tpc" name="cas_tpc" />
										<span class="input-group-btn">
											<button class="btn btn-default ico search" type="button" onclick="cas_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
										</span>
									</div>
								</td>
								<th>관련리스크사례 보유여부</th>
								<td colspan="3" class="form-inline">
									<div class="select">
										<select class="form-control w120" id="st_rkp_hld_yn" name="st_rkp_hld_yn">
											<option value="">전체</option>
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<th>사건제목</th>
								<td>
									<input type="text" name="lss_tinm" id="lss_tinm" class="form-control w180">
								</td>
								<%-- <th>수집방법</th>
								<td>
									<div class="select">
										<select class="form-control w180" id="st_col_methc" name="st_col_methc" >
											<option value="">전체</option>
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
								</td> --%>
								<th>금액</th>
								<td colspan="5" class="form-inline">
									<span class="select">
										<select class="form-control w120" id="st_am_knd" name="st_am_knd" onchange="set_am_knd()">
											<option value="">전체</option>
											<option value="1">총손실금액</option>
											<option value="2">총회수금액</option>
											<option value="3">순손실금액</option>
										</select>
									</span>
									<div class="input-group">
										<input type="text" class="form-control text-right" style="width:80px;" id="txt_st_am" name="txt_st_am" disabled> 
										<span class="input-group-addon">백만원 </span>
										<span class="input-group-addon"> ~ </span>
										<input type="text" class="form-control text-right" style="width:80px;" id="txt_ed_am" name="txt_ed_am" disabled> 
										<span class="input-group-addon">백만원 </span>
									</div>
								</td>
								<th>사건유형</th>
								<td class="form-inline">
									<div class="input-group">
										<input type="text" class="form-control w90" id="hpn_tpnm" name="hpn_tpnm" readonly>
										<input type="hidden" id="hpn_tpc" name="hpn_tpc" />
										<span class="input-group-btn">
											<button class="btn btn-default ico search" type="button" onclick="hpn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span></button>
										</span>
									</div>
								</td>
							</tr>
							<tr>
								<th>사건발생 기관</th>
								<td>
									<div class="select">
										<input type="text" class="form-control w180" id="hpn_ocu_orgnm" name="hpn_ocu_orgnm">
									</div>
								</td>
								<th>제재대상</th>
								<td>
									<div class="select">
										<select name="st_snt_obj" id="st_snt_obj" class="form-control w120">
											<option value="">전체</option>
											<option value="1">기관</option>
											<option value="2">임원</option>
											<option value="3">직원</option>
											<option value="4">N/A</option>
										</select>
									</div>
								</td>
								<th>영향유형</th>
								<td colspan="3" class="form-inline">
									<div class="input-group">
										<input type="hidden" id="ifn_tpc" name="ifn_tpc" value="" />
										<input type="text" class="form-control w90" id="shw_ifn_tpnm" name="shw_ifn_tpnm" value="" readonly />
										<span class="input-group-btn">
											<button type="button" class="btn btn-default btn-sm ico" id="shw_ifn_tpnm_btn" onclick="ifn_popup();">
											<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</span>
									</div>
								</td>
							</tr>
						</table>
					</div><!-- .wrap-search -->
				</div><!-- .box-body //-->
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div>
			<!-- 조회 //-->
		</form>
			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<div class="btn-group">
							<button class="btn  btn-default btn-xs" type="button" onclick="javascript:doAction('add');"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
							<button class="btn btn-default btn-xs" type="button" onclick="javascript:doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
						</div>
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>

				<div class="box-body">
					<div class="wrap-grid h400">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
			</div>
		</div><!-- .content //-->
	</div><!-- .container //-->		



	<!-- popup -->
	<div id="winLossAdd" class="popup modal">
		<iframe name="ifrLossAdd" id="ifrLossAdd" src="about:blank"></iframe>
	</div>
	<div id="winLossMod" class="popup modal">
		<iframe name="ifrLossMod" id="ifrLossMod" src="about:blank"></iframe>
	</div>
	
	
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->

	<script>


	// 리스크풀검색 완료
	
	var CUR_RKP_ID = "";
	
	function rp_popup(){
		CUR_rkp_ID = $("#rkp_id").val();
		schRpPopup();
	}
	
	function rpSearchEnd(rkp_id, rk_isc_cntn){
		$("#rkp_id").val(rkp_id);
		$("#winRp").hide();
		//doAction('search');
	}
		
	// 손실사건유형검색 완료
	
	var HPN2_ONLY = true; 
	var CUR_HPN_TPC = "";
	
	function hpn_popup(){
		CUR_HPN_TPC = $("#hpn_tpc").val();
		if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
		schHpnPopup();
	}
	
	function hpnSearchEnd(hpn_tpc, hpn_tpnm){
		$("#hpn_tpc").val(hpn_tpc);
		$("#hpn_tpnm").val(hpn_tpnm);
		
		$("#winHpn").hide();
		//doAction('search');
	}

	// 원인유형검색 완료
	var CAS2_ONLY = true; 
	var CUR_CAS_TPC = "";
	
	function cas_popup(){
		CUR_CAS_TPC = $("#cas_tpc").val();
		schCasPopup();
	}
	
	function casSearchEnd(cas_tpc, cas_tpnm){
		$("#cas_tpc").val(cas_tpc);
		$("#cas_tpnm").val(cas_tpnm);
		
		$("#winCas").hide();
		//doAction('search');
	}

	// 영향유형검색 완료
	var IFN2_ONLY = true;
	var CUR_IFN_TPC = "";

	function ifn_popup() {
		CUR_IFN_TPC = $("#ifn_tpc").val();
		schIfnPopup();
	}

	function ifnSearchEnd(ifn_tpc, ifn_tpnm, ifn_tpc_lv1, ifn_tpnm_lv1) {
		$("#ifn_tpc").val(ifn_tpc);
		$("#shw_ifn_tpnm").val(ifn_tpnm);

		$("#winIfn").hide();
		//doAction('search');
	}
	
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