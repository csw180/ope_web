<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0110.jsp
 Program name : 공통 > 손실사건공통팝업
 Description  : 
 Programer    : 권성학
 Date created : 2020.06.30
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@page import="com.shbank.orms.comm.SysDateDao"%>

<%
SysDateDao dao = new SysDateDao(request);
String today = dao.getSysdate(); //오늘날짜(yyyymmdd)

//3개월전 계산
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
Calendar cal = Calendar.getInstance();
java.util.Date date = sdf.parse(today);
System.out.println(today);
cal.setTime(date);
cal.add(Calendar.MONTH, -3);
cal.add(Calendar.HOUR, 24);
String before_3m = sdf.format(cal.getTime());

String default_st_dt = before_3m.substring(0,4)+"-"+before_3m.substring(4,6)+"-"+before_3m.substring(6,8);
String default_ed_dt = today.substring(0,4)+"-"+today.substring(4,6)+"-"+today.substring(6,8);

Vector lshpFormCLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
Vector lshpStscLst= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
//Vector lshpDczStsDscOrmLst= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
//Vector lshpDczStsDscNmlLst= CommUtil.getResultVector(request, "grp01", 0, "unit04", 0, "vList");

//String role_id = "orm"; //역할구분코드
String role_id = ""; //역할구분코드
Vector lshpDczStsDscTempLst = null;
if("nml".equals(role_id) || "nmlld".equals(role_id) || "admn".equals(role_id)){ //보고부서, 보고부서장, 사건관리부서
	lshpDczStsDscTempLst= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
}else{ //기타
	lshpDczStsDscTempLst= CommUtil.getResultVector(request, "grp01", 0, "unit04", 0, "vList");
}
//System.out.println("lshpDczStsDscTempLst:\n"+lshpDczStsDscTempLst.toString());

Vector lshpDczStsDscLst = new Vector();
for(int i=0;i<lshpDczStsDscTempLst.size();i++){
	HashMap tempMap = (HashMap)lshpDczStsDscTempLst.get(i);
	String intg_cnm = (String)tempMap.get("intg_cnm");
	String intgc = (String)tempMap.get("intgc");
	if("nml".equals(role_id) || "nmlld".equals(role_id)){ //보고부서, 보고부서장
		if(!"01".equals(intgc) && !"02".equals(intgc) && !"04".equals(intgc) && !"05".equals(intgc) && !"06".equals(intgc) && !"12".equals(intgc)){
			continue;
		}
	}else if("admn".equals(role_id)){ //사건관리부서
		if(!"03".equals(intgc) && !"04".equals(intgc) && !"05".equals(intgc) && !"06".equals(intgc)){
			continue;
		}
	}
	
	boolean exist = false;
	for(int j=0;j<lshpDczStsDscLst.size();j++){
		HashMap dscMap = (HashMap)lshpDczStsDscLst.get(j);
		if(intg_cnm.equals((String)dscMap.get("intg_cnm"))){
			dscMap.put("intgc",(String)dscMap.get("intgc") + ",'" + (String)tempMap.get("intgc")+"'");
			exist = true;
			break;
		}
	}
	if(!exist){
		tempMap.put("intgc","'"+(String)tempMap.get("intgc")+"'");
		lshpDczStsDscLst.add(tempMap.clone());
	}
}

//System.out.println("lshpDczStsDscLst:\n"+lshpDczStsDscLst.toString());



Vector lshpLst= CommUtil.getResultVector(request, "grp01", 0, "unit05", 0, "vList");


HashMap hMapSession = (HashMap)request.getSession(true).getAttribute("infoH");


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<%@ include file="../comm/comUtil.jsp" %>
		
	<script>
		$(document).ready(function(){
			$("#winLoss",parent.document).show();
			parent.removeLoadingWs();
			
			// ibsheet 초기화
			initIBSheet1();
			initIBSheet2();
			
			// 멀티셀렉스 체크박스 .mS01 손실상태
			$(".dropdown.mS01 dt a").on('click', function() {
			  $(".dropdown.mS01 dd ul").slideToggle('fast');
			});

			$(".dropdown.mS01 dd ul li a").on('click', function() {
			  $(".dropdown.mS01 dd ul").hide();
			});

			function getSelectedValue(id) {
			  return $("#" + id).find("dt a span.value").html();
			}

			$(document).bind('click', function(e) {
			  var $clicked = $(e.target);
			  if (!$clicked.parents().hasClass("dropdown")) $(".dropdown.mS01 dd ul").hide();
			});

			$('.mS01 .mutliSelect input[type="checkbox"]').on('click', function() {

			  var title = $(this).closest('.mS01 .mutliSelect').find('input[type="checkbox"]').val(),
				title = $(this).val() + ",";

			  if ($(this).is(':checked')) {
				var html = '<span title="' + title + '">' + title + '</span>';
				$('.mS01 .multiSel').append(html);
				$(".mS01 .hida").hide();
			  } else {
				$('span[title="' + title + '"]').remove();
				var ret = $(".mS01 .hida");
				$('.dropdown.mS01 dt a').append(ret);

			  }
			});
		
			// 멀티셀렉스 체크박스 .mS02 경계리스크
			$(".dropdown.mS02 dt a").on('click', function() {
			  $(".dropdown.mS02 dd ul").slideToggle('fast');
			});

			$(".dropdown.mS02 dd ul li a").on('click', function() {
			  $(".dropdown.mS02 dd ul").hide();
			});

			function getSelectedValue(id) {
			  return $("#" + id).find("dt a span.value").html();
			}

			$(document).bind('click', function(e) {
			  var $clicked = $(e.target);
			  if (!$clicked.parents().hasClass("dropdown")) $(".dropdown.mS02 dd ul").hide();
			});

			$('.mS02 .mutliSelect input[type="checkbox"]').on('click', function() {

			  var title = $(this).closest('.mS02 .mutliSelect').find('input[type="checkbox"]').val(),
				//title = $(this).val() + ",";
				title = $(this).val() + " ";

			  if ($(this).is(':checked')) {
				var html = '<span title="' + title + '">' + title + '</span>';
				$('.mS02 .multiSel').append(html);
				$(".mS02 .hida").hide();
			  } else {
				$('span[title="' + title + '"]').remove();
				var ret = $(".mS02 .hida");
				$('.dropdown.mS02 dt a').append(ret);

			  }
			});

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
		
		var init_flag = false;
		function ocuorg_popup(){
			schOrgPopup("sch_ocu_brc", "ocuOrgSearchEnd");
			if($("#sch_ocu_brnm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		
		// 발생사무소검색 완료
		function ocuOrgSearchEnd(brc, brnm){
			$("#sch_ocu_brc").val(brc);
			$("#sch_ocu_brnm").val(brnm);
			$("#winBuseo").hide();
		}
		
		function amnorg_popup(){
			schOrgPopup("sch_amn_brnm", "amnOrgSearchEnd");
			if($("#sch_amn_brnm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		
		// 관리부서검색 완료
		function amnOrgSearchEnd(brc, brnm){
			$("#sch_amn_brc").val(brc);
			$("#sch_amn_brnm").val(brnm);
			$("#winBuseo").hide();
		}
			
		function amndelTxt(){
			if($("#sch_amn_brnm").val() == "") $("#sch_amn_brc").val("");
		}
		
		function rptorg_popup(){
			schOrgPopup("sch_rpt_brnm", "rptOrgSearchEnd");
			if($("#sch_rpt_brnm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		
		// 보고부서검색 완료
		function rptOrgSearchEnd(brc, brnm){
			$("#sch_rpt_brc").val(brc);
			$("#sch_rpt_brnm").val(brnm);
			$("#winBuseo").hide();
		}
			
		function rptdelTxt(){
			if($("#sch_rpt_brnm").val() == "") $("#sch_rpt_brc").val("");
		}
		
		// 손실사건유형검색 완료
		
		var HPN3_ONLY = true; 
		var CUR_HPN_TPC = "";
		
		function hpn_popup(){
			CUR_HPN_TPC = $("#hpn_tpc_lv3").val();
			if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
			schHpnPopup();
		}
		
		function hpnSearchEnd(hpn_tpc, hpn_tpnm){
			$("#sch_hpn_tpc").val(hpn_tpc);
			$("#sch_hpn_tpnm").val(hpn_tpnm);
			
			$("#winHpn").hide();
			//doAction('search');
		}
		
		// 영업영역검색 완료
		
		var BIZ2_ONLY = true; 
		var CUR_BIZ_TPC = "";
		
		function biz_popup(){
			CUR_BIZ_TPC = $("#biz_trry_c").val();
			if(ifrBiz.cur_click!=null) ifrBiz.cur_click();
			schBizPopup();
		}
		
		function bizSearchEnd(biz_trry_c, biz_trry_cnm,biz_trry_c_lv1,biz_trry_cnm_lv1){
			$("#sch_biz_trry_c").val(biz_trry_c);
			$("#sch_biz_trry_cnm").val(biz_trry_cnm);
			
			$("#winBiz").hide();
			//doAction('search');
		}
			

		// 원인유형검색 완료
		var CAS3_ONLY = true; 
		var CUR_CAS_TPC = "";
		
		function cas_popup(){
			CUR_CAS_TPC = $("#cas_tpc_lv3").val();
			if(ifrCas.cur_click!=null) ifrCas.cur_click();
			schCasPopup();
		}
		
		function casSearchEnd(cas_tpc, cas_tpnm){
			$("#sch_cas_tpc").val(cas_tpc);
			$("#sch_cas_tpnm").val(cas_tpnm);
			
			$("#winCas").hide();
			//doAction('search');
		}

		// 영향유형검색 완료
		var IFN2_ONLY = true; 
		var CUR_IFN_TPC = "";
		
		function ifn_popup(){
			CUR_IFN_TPC = $("#ifn_tpc_lv2").val();
			if(ifrIfn.cur_click!=null) ifrIfn.cur_click();
			schIfnPopup();
		}
		
		function ifnSearchEnd(ifn_tpc, ifn_tpnm, ifn_tpc_lv1, ifn_tpnm_lv1){
			$("#sch_ifn_tpc").val(ifn_tpc);
			$("#sch_ifn_tpnm").val(ifn_tpnm);
			
			$("#winIfn").hide();
			//doAction('search');
		}
		
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:2,MergeSheet:msHeaderOnly,DeferredVScroll:1,AutoFitColWidth:"init|search" }; 
			initData.Cols = [
				{Header:"",				Type:"CheckBox",	Width:70,		Align:"Left",	SaveName:"ischeck"},
				{Header:"관리번호",			Type:"Text",		MinWidth:80,	Align:"Left",	SaveName:"lshp_amnno",			Edit:false, 	Wrap:true},
				{Header:"공통손실개수",		Type:"Text",		MinWidth:80,	Align:"Left",	SaveName:"comn_amnno_cnt",		Hidden:true,	Wrap:true},
				{Header:"사건발생부서",		Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"ocu_brnm",			Edit:false, 	Wrap:true},
				{Header:"보고부서",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"rpt_brnm",			Edit:false, 	Wrap:true},
				{Header:"사건관리부서",		Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"amn_brnm",			Edit:false, 	Wrap:true},
				{Header:"사건제목",			Type:"Text",		MinWidth:350,	Align:"Left",	SaveName:"lshp_tinm",			Edit:false, 	Wrap:true, EditLen:200},
				{Header:"발생일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"ocu_dt",				Edit:false, 	Wrap:true},
				{Header:"발견일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"dcv_dt",				Edit:false,		Wrap:true},
				{Header:"입력일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"rgs_dt",				Edit:false, 	Wrap:true},
				{Header:"최초회계일자",		Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"fir_acg_prc_dt",		Edit:false, 	Wrap:true},
				{Header:"총손실금액",		Type:"Int",			MinWidth:100,	Align:"Right",	SaveName:"tot_lssam",			Edit:false, 	Wrap:true},
				{Header:"보험회수전순손실금액",	Type:"Int",			MinWidth:140,	Align:"Right",	SaveName:"bf_isr_wdr_guls_am",	Edit:false, 	Wrap:true},
				{Header:"순손실금액",		Type:"Int",			MinWidth:100,	Align:"Right",	SaveName:"gu_lssam",			Edit:false, 	Wrap:true},
				{Header:"보험청구여부",		Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"isr_rqs_yn",			Edit:false, 	Wrap:true},
				{Header:"신용리스크",		Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"crrk_yn",				Edit:false,		Wrap:true},
				{Header:"시장리스크",		Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"mkrk_yn",				Edit:false, 	Wrap:true},
				{Header:"법률리스크",		Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"lgrk_yn",				Edit:false, 	Wrap:true},
				{Header:"전략리스크",		Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"strk_yn",				Edit:false, 	Wrap:true},
				{Header:"평판리스크",		Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"fmrk_yn",				Edit:false, 	Wrap:true},
				{Header:"원인유형",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"cas_tpnm_lv3",		Edit:false, 	Wrap:true},
				{Header:"사건유형",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"hpn_tpnm_lv3",		Edit:false, 	Wrap:true},
				{Header:"손실형태",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"lshp_form_cnm",		Edit:false, 	Wrap:true},
				{Header:"손실상태",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"lshp_stscnm",			Edit:false, 	Wrap:true},
				{Header:"진행단계",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"lshp_dcz_stscnm",		Edit:false, 	Wrap:true}
			];
			IBS_InitSheet(mySheet1,initData);
			
			//필터표시
			//mySheet1.ShowFilterRow();  

			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			//doAction('search');
			
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			if(Row >= mySheet1.GetDataFirstRow()){
				
			}
		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
			
		/*Sheet 기본 설정 */
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:2,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search" }; 
			initData.Cols = [
				{Header:"",					Type:"CheckBox",	Width:70,		Align:"Left",	SaveName:"ischeck"},
				{Header:"관리번호",			Type:"Text",		MinWidth:80,	Align:"Left",	SaveName:"lshp_amnno",			Edit:false, 	Wrap:true},
				{Header:"공통손실개수",			Type:"Text",		MinWidth:80,	Align:"Left",	SaveName:"comn_amnno_cnt",		Hidden:true,	Wrap:true},
				{Header:"사건발생부서",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"ocu_brnm",			Edit:false, 	Wrap:true},
				{Header:"보고부서",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"rpt_brnm",			Edit:false, 	Wrap:true},
				{Header:"사건관리부서",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"amn_brnm",			Edit:false, 	Wrap:true},
				{Header:"사건제목",			Type:"Text",		MinWidth:350,	Align:"Left",	SaveName:"lshp_tinm",			Edit:false, 	Wrap:true, EditLen:200},
				{Header:"발생일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"ocu_dt",				Edit:false, 	Wrap:true},
				{Header:"발견일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"dcv_dt",				Edit:false,		Wrap:true},
				{Header:"입력일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"rgs_dt",				Edit:false, 	Wrap:true},
				{Header:"최초회계일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"fir_acg_prc_dt",		Edit:false, 	Wrap:true},
				{Header:"총손실금액",			Type:"Int",			MinWidth:100,	Align:"Right",	SaveName:"tot_lssam",			Edit:false, 	Wrap:true},
				{Header:"보험회수전순손실금액",	Type:"Int",			MinWidth:140,	Align:"Right",	SaveName:"bf_isr_wdr_guls_am",	Edit:false, 	Wrap:true},
				{Header:"순손실금액",			Type:"Int",			MinWidth:100,	Align:"Right",	SaveName:"gu_lssam",			Edit:false, 	Wrap:true},
				{Header:"보험청구여부",			Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"isr_rqs_yn",			Edit:false, 	Wrap:true},
				{Header:"신용리스크",			Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"crrk_yn",				Edit:false,		Wrap:true},
				{Header:"시장리스크",			Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"mkrk_yn",				Edit:false, 	Wrap:true},
				{Header:"법률리스크",			Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"lgrk_yn",				Edit:false, 	Wrap:true},
				{Header:"전략리스크",			Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"strk_yn",				Edit:false, 	Wrap:true},
				{Header:"평판리스크",			Type:"Text",		MinWidth:80,	Align:"Center",	SaveName:"fmrk_yn",				Edit:false, 	Wrap:true},
				{Header:"원인유형",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"cas_tpnm_lv3",		Edit:false, 	Wrap:true},
				{Header:"사건유형",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"hpn_tpnm_lv3",		Edit:false, 	Wrap:true},
				{Header:"손실형태",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"lshp_form_cnm",		Edit:false, 	Wrap:true},
				{Header:"손실상태",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"lshp_stscnm",			Edit:false, 	Wrap:true},
				{Header:"진행단계",			Type:"Text",		MinWidth:100,	Align:"Left",	SaveName:"lshp_dcz_stscnm",		Edit:false, 	Wrap:true}
			];
			
			IBS_InitSheet(mySheet2,initData);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			var idx = 1;
			var data ;
<%
			if(lshpLst!=null){
				for(int i=0;i<lshpLst.size();i++){
					HashMap lshpMap = (HashMap)lshpLst.get(i);
%>
					data = {
						ischeck : 0,        
						lshp_amnno : "<%=(String)lshpMap.get("lshp_amnno")%>",			
						comn_amnno_cnt : "<%=(String)lshpMap.get("comn_amnno_cnt")%>",	
						ocu_brnm : "<%=(String)lshpMap.get("ocu_brnm")%>",		
						rpt_brnm : "<%=(String)lshpMap.get("rpt_brnm")%>",			
						amn_brnm : "<%=(String)lshpMap.get("amn_brnm")%>",		
						lshp_tinm : "<%=(String)lshpMap.get("lshp_tinm")%>",			
						ocu_dt : "<%=(String)lshpMap.get("ocu_dt")%>",				
						dcv_dt : "<%=(String)lshpMap.get("dcv_dt")%>",				
						rgs_dt : "<%=(String)lshpMap.get("fir_inp_dt")%>",				
						fir_acg_prc_dt : "<%=(String)lshpMap.get("fir_acg_prc_dt")%>",	
						tot_lssam : "<%=(String)lshpMap.get("tot_lssam")%>",		
						bf_isr_wdr_guls_am : "<%=(String)lshpMap.get("bf_isr_wdr_guls_am")%>",	
						gu_lssam : "<%=(String)lshpMap.get("gu_lssam")%>",		
						isr_rqs_yn : "<%=(String)lshpMap.get("isr_rqs_yn")%>",		
						crrk_yn : "<%=(String)lshpMap.get("crrk_yn")%>",			
						mkrk_yn : "<%=(String)lshpMap.get("mkrk_yn")%>",			
						lgrk_yn : "<%=(String)lshpMap.get("lgrk_yn")%>",			
						strk_yn : "<%=(String)lshpMap.get("strk_yn")%>",			
						fmrk_yn : "<%=(String)lshpMap.get("fmrk_yn")%>",			
						cas_tpnm_lv3 : "<%=(String)lshpMap.get("cas_tpnm_lv3")%>",		
						hpn_tpnm_lv3 : "<%=(String)lshpMap.get("hpn_tpnm_lv3")%>",		
						lshp_form_cnm : "<%=(String)lshpMap.get("lshp_form_cnm")%>",		
						lshp_stscnm : "<%=(String)lshpMap.get("lshp_stscnm")%>",			
						lshp_dcz_stscnm : "<%=(String)lshpMap.get("lshp_dcz_stscnm")%>" 		
					};
					mySheet2.SetRowData(idx++, data, {Add:1});
<%
				}
			}
%>
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
					$("form[name=ormsForm] [name=commkind]").val("los");
					$("form[name=ormsForm] [name=process_id]").val("ORLS10102");
					
					$("#sch_grp_org_c").val("<%=grp_org_c%>");
					
					ormsForm.sch_st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
					ormsForm.sch_ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");
					if(ormsForm.txt_st_am.value!=""){
						ormsForm.sch_st_am.value = ormsForm.txt_st_am.value * 10000;
					}
					if(ormsForm.txt_ed_am.value!=""){
						ormsForm.sch_ed_am.value = ormsForm.txt_ed_am.value * 10000;
					}

					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
			}
		}

		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
		}
		
		function copyLoss(){
			ToSheet = mySheet2;
			FromSheet = mySheet1;
			//체크된 행이 있는지 찾아본다.
			var rows = FromSheet.FindCheckedRow("ischeck");
			//복사될 위치를 구한다.
			var ToRow = ToSheet.GetSelectRow();
			
			mySheet1.CheckAll("ischeck", 0);

			if(rows==""){
				//현재 포커스가 들어간 행을	이동시킨다.
				//var FromRow = FromSheet.GetSelectRow();
				//mySheet2_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow, 0,0, 0);
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				//체크된 행을 모두 복사.	
				var jsonArr = [];
				var rs = rows.split("|");
				
				//렌더링 일시 중지
				ToSheet.RenderSheet(false);
				
				//데이터 복사
				for(var i=0;i<rs.length;i++){
					var bAddFlag = true;
					
					for(var nCnt=mySheet2.GetDataFirstRow(); nCnt <= mySheet2.GetDataLastRow(); nCnt++){
						if( mySheet1.GetCellValue(rs[i],"lshp_amnno") == mySheet2.GetCellValue(nCnt,"lshp_amnno") ){
							bAddFlag = false;
							break;
						}
					}
					
					if( !bAddFlag )
						continue;
					
					var rowJson = FromSheet.GetRowData(rs[i]);
					ToSheet.SetRowData(ToRow+1, rowJson, {Add:1});
				}
				
				//렌더링 재가동
				ToSheet.RenderSheet(true);
				
				//원본 데이터 삭제
				//FromSheet.RowDelete(rows);
			}
			
			$("#relLossCnt").val(mySheet2.RowCount());
		}
		
		function removeLoss(){
			//체크된 행이 있는지 찾아본다.
			var rows = mySheet2.FindCheckedRow("ischeck");

			if(rows==""){
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				
				mySheet2.RowDelete(rows);
				
			}
			
			$("#relLossCnt").val(mySheet2.RowCount());
		}
			
		function relLossSave(){
			var dataRows = mySheet2.GetDataLastRow();
			
			if(dataRows > 0){
				
				//렌더링 일시 중지
				mySheet2.RenderSheet(false);
				
				for(var row = mySheet2.GetDataFirstRow(); row <= mySheet2.GetDataLastRow(); row++){
					parent.addRelLoss(mySheet2.GetCellValue(row,"lshp_amnno"), mySheet2.GetCellValue(row,"ocu_dt"), mySheet2.GetCellText(row,"tot_lssam"), mySheet2.GetCellValue(row,"lshp_tinm"));
				}
				
				//렌더링 재가동
				mySheet2.RenderSheet(true);
				
				parent.$("#loss_cnt").text(parent.mySheet2.RowCount()); 
				parent.closeLoss();
			}else{
				alert("저장할 항목이 없습니다.");
				return;
			}
		}
		
		function set_dt_knd(){
			if($("#sch_dt_knd").val()==""){
				$("#sch_st_dt").val("");
				$("#txt_st_dt").val("");
				$("#sch_ed_dt").val("");
				$("#txt_ed_dt").val("");
				document.getElementById('txt_st_dt_btn').disabled = true;
				document.getElementById('txt_ed_dt_btn').disabled = true;
			}else{
				document.getElementById('txt_st_dt_btn').disabled = false;
				document.getElementById('txt_ed_dt_btn').disabled = false;
			}
		}
		function set_am_knd(){
			if($("#sch_am_knd").val()==""){
				$("#sch_st_am").val("");
				$("#txt_st_am").val("");
				$("#sch_ed_am").val("");
				$("#txt_ed_am").val("");
				document.getElementById('txt_st_am').disabled = true;
				document.getElementById('txt_ed_am').disabled = true;
			}else{
				document.getElementById('txt_st_am').disabled = false;
				document.getElementById('txt_ed_am').disabled = false;
			}
		}
			
	</script>
		
</head>
<body onkeyPress="return EnterkeyPass()">
		<article class="popup modal block" >
			<div class="p_frame w1200">
				<div class="p_head">
					<h1 class="title">연관 손실사건 등록</h1>
				</div>
				<div class="p_body">
					<div class="p_wrap">
				<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					<input type="hidden" id="sch_grp_org_c" name="sch_grp_org_c" />
					<input type="hidden" id="role_id" name="role_id" value="<%=role_id %>" />
					
					<!-- 조회 -->
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<tr>
										<th>사건 관리번호</th>
										<td><input type="text" class="form-control w220" id="sch_lshp_amnno" name="sch_lshp_amnno" ></td>
										<th>일자</th>
										<td colspan="5">
											<div class="form-inline">
												<div class="select ">
													<select class="form-control w100" id="sch_dt_knd" name="sch_dt_knd" onchange="set_dt_knd()">
															<option value="">전체</option>
															<option value="oc">발생일자</option>
															<option value="dc">발견일자</option>
															<option value="rg">최초등록일자</option>
															<option value="fa">최초회계처리일자</option>
															<option value="lc">최종변경일자</option>
													</select>
												</div>
												<div class="input-group">
													<input type="hidden" id="sch_st_dt" name="sch_st_dt">
													<input type="text" class="form-control w100" id="txt_st_dt" name="txt_st_dt" disabled>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" id="txt_st_dt_btn" name="txt_st_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');" disabled><i class="fa fa-calendar"></i></button>
													</span>
												</div>
												<div class="input-group">
													<div class="input-group-addon"> ~ </div>
													<input type="hidden" id="sch_ed_dt" name="sch_ed_dt">
													<input type="text" class="form-control w100" id="txt_ed_dt" name="txt_ed_dt" disabled>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" id="txt_ed_dt_btn" name="txt_ed_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');" disabled><i class="fa fa-calendar"></i></button>
													</span>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>보고부서</th>
										<td>
											<div class="input-group w150">
												<input type="text" class="form-control" id="sch_rpt_brnm" name="sch_rpt_brnm" onKeyPress="rptorg_popup();" onKeyUp="rptdelTxt();">
												<input type="hidden" id="sch_rpt_brc" name="sch_rpt_brc" value=""/>
												<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="sch_rpt_brnm_btn" onclick="rptorg_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
										<th>금액</th>
										<td colspan="5">
											<div class="form-inline">
												<span class="select ib w100">
													<select class="form-control w100p" id="sch_am_knd" name="sch_am_knd" onchange="set_am_knd()">
															<option value="">선택</option>
															<option value="tl">총손실금액</option>
															<option value="bi">보험회수전순손실액</option>
															<option value="gl">순손실금액</option>
													</select>
												</span>
												<div class="input-group">
													<input type="hidden" id="sch_st_am" name="sch_st_am"/> 
													<input type="number" class="form-control text-right" style="width:80px;" id="txt_st_am" name="txt_st_am" disabled> 
													<span class="input-group-addon">백만원 </span>
													<span class="input-group-addon"> ~ </span>
													<input type="hidden" id="sch_ed_am" name="sch_ed_am" />
													<input type="number" class="form-control text-right" style="width:80px;" id="txt_ed_am" name="txt_ed_am" disabled> 
													<span class="input-group-addon">백만원 </span>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>사건관리 부서</th>
										<td>
											<div class="input-group w150">
												<input type="hidden" id="sch_amn_brc" name="sch_amn_brc"/> 
												<input type="text" class="form-control" id="sch_amn_brnm" name="sch_amn_brnm" onKeyPress="amnorg_popup();" onKeyUp="amndelTxt();">
												<span class="input-group-btn">
													<button class="btn btn-default ico search" type="button" id="sch_amn_brnm_btn" onclick="amnorg_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
										<th>사건제목</th>
										<td>
											<input type="text" class="form-control w100" id="sch_lshp_tinm" name="sch_lshp_tinm" placeholder="">
										</td>
										<th>경계리스크</th>
										<td>
											<dl class="dropdown dMSC w100"> 
												<dt class="select"><a href="#"> <span class="hida">선택</span> <p class="multiSel"></p></a></dt>
												<dd>
													<div class="mutliSelect">
														<ul>
															<li><input type="checkbox" id="crrk_yn" name="crrk_yn" value="신용"><label for="crrk_yn">신용</label></li>
															<li><input type="checkbox" id="mkrk_yn" name="mkrk_yn" value="시장"><label for="mkrk_yn">시장</label></li>
															<li><input type="checkbox" id="lgrk_yn" name="lgrk_yn" value="법률"><label for="lgrk_yn">법률</label></li>
															<li><input type="checkbox" id="strk_yn" name="strk_yn" value="전략"><label for="strk_yn">전략</label></li>
															<li><input type="checkbox" id="fmrk_yn" name="fmrk_yn" value="평판"><label for="fmrk_yn">평판</label></li>
														</ul>
													</div>
												</dd>
											</dl>
										</td>
										<th>승인 진행단계</th>
										<td>
											<div class="form-inline">
												<div class="select">
													<select class="form-control w100" id="sch_lshp_dcz_sts_dsc" name="sch_lshp_dcz_sts_dsc">
															<option value="">선택</option>
	<%
			//if(role_id.equals("orm") || role_id.equals("ormld")){
				for(int i=0;i<lshpDczStsDscLst.size();i++){
					HashMap hMap = (HashMap)lshpDczStsDscLst.get(i);
					//if( !("01".equals((String)hMap.get("intgc"))||"03".equals((String)hMap.get("intgc"))||"04".equals((String)hMap.get("intgc"))||"12".equals((String)hMap.get("intgc")) ) ){		//02일때 03,04함께조회 //01일때 12함께조회
	%>
															<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
		
					//}
				}	
			//}
	%>
													</select>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>사건발생 법인</th>
										<td>
											<select class="form-control w220" id="sch_grp_org_c" name="sch_grp_org_c" disabled>
												<option value="">전체</option>
<%
			for(int i=0;i<vGrpList.size();i++){
				HashMap hMap = (HashMap)vGrpList.get(i);
				if(((String)hMap.get("grp_org_c")).equals(grp_org_c)){
%>
												<option value="<%=(String)hMap.get("grp_org_c")%>" selected><%=(String)hMap.get("grp_orgnm")%></option>
<%					
				}else{
%>
												<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
<%					
				}
%>
<%
			}
%>
											</select>
										</td>
										<th>사건유형</th>
										<td>
											<div class="input-group w120">
												<input type="text" class="form-control" id="sch_hpn_tpnm" name="sch_hpn_tpnm" readonly>
												<input type="hidden" id="sch_hpn_tpc" name="sch_hpn_tpc" />
												<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" onclick="hpn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
										<th>손실형태</th>
										<td>
											<div class="select w120">
												<select class="form-control w100p" id="sch_lshp_form_c" name="sch_lshp_form_c" >
													<option value="">전체</option>
	<%
				if(lshpFormCLst.size()>0){
					for(int i=0;i<lshpFormCLst.size();i++){
						HashMap hMap = (HashMap)lshpFormCLst.get(i);
	%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
					}
				}	
	%>
												</select>
											</div>
										</td>
										<th>원인유형</th>
										<td>
											<div class="input-group w120">
												<input type="text" class="form-control" id="sch_cas_tpnm" name="sch_cas_tpnm" readonly>
												<input type="hidden" id="sch_cas_tpc" name="sch_cas_tpc" />
												<span class="input-group-btn">
													<button class="btn btn-default ico search" type="button" onclick="cas_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>보험청구여부</th>
										<td>
											<div class="select w120">
												<select class="form-control" id="sch_isr_rqs_yn" name="sch_isr_rqs_yn">
													<option value="">전체</option>
													<option value="y">Y</option>
													<option value="n">N</option>
												</select>
											</div>
										</td>
										<th>손실상태</th>
										<td>
											<div class="select w120">
												<select class="form-control w100p" id="sch_lshp_stsc" name="sch_lshp_stsc" >
													<option value="">전체</option>
	<%
				if(lshpStscLst.size()>0){
					for(int i=0;i<lshpStscLst.size();i++){
						HashMap hMap = (HashMap)lshpStscLst.get(i);
	%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
					}
				}	
	%>
												</select>
											</div>
										</td>
										<th>영향유형</th>
										<td>
											<div class="input-group w120">
												<input type="text" class="form-control" id="sch_ifn_tpnm" name="sch_ifn_tpnm" readonly>
												<input type="hidden" id="sch_ifn_tpc" name="sch_ifn_tpc" />
												<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" onclick="ifn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
									</tr>
								</table>
							</div><!-- .wrap-search -->
						</div><!-- .box-body //-->
						<div class="box-footer w150">
							<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
						</div>
					</div>
				</form>
					<!-- 조회 //-->
				<section class="box box-grid">
					<div class="wrap-grid h230">
						<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
					</div>
				</section><!-- .box //-->
				<div class="btn-wrap mt20 center">
					<button class="btn btn-normal btn-sm" type="button" onclick="copyLoss();"><i class="fa fa-angle-down"></i><span class="txt">추가</span></button>
					<button class="btn btn-normal btn-sm" type="button" onclick="removeLoss();"><i class="fa fa-angle-up"></i><span class="txt">삭제</span></button>
				</div>
				<section class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="form-inline"><input class="form-control w60 right" id="relLossCnt" type="text" value="0"><span> 개</span></div>
						</div>
					</div>
					<div class="wrap-grid h230">
						<script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div>
				</section><!-- .box //-->
			</div><!-- .p_wrap //-->	
		</div><!-- .p_body //-->
		<div class="p_foot">
			<div class="btn-wrap">
				<button type="button" class="btn btn-primary" onclick="relLossSave();">적용</button>
				<button type="button" class="btn btn-default btn-close">닫기</button>
			</div>
		</div>
		<button type="button" class="ico close  fix btn-close"><span class="blind">닫기</span></button>
	</div>
</article>
	<!-- popup //-->
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	
</body>
</html>