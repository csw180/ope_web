<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0121.jsp
 Program name : 공통 > 손실사건공통팝업
 Description  : 
 Programer    : 김남원
 Date created : 2022.04.15
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ include file="../comm/comUtil.jsp" %>
<%
SysDateDao dao = new SysDateDao(request);
String today = dao.getSysdate(); //오늘날짜(yyyymmdd)

DynaForm form = (DynaForm)request.getAttribute("form");
String role_id = (String)form.get("role_id"); //역할구분코드

//3개월전 계산
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
Calendar cal = Calendar.getInstance();
java.util.Date date = sdf.parse(today);
cal.setTime(date);
cal.add(Calendar.MONTH, -3);
cal.add(Calendar.HOUR, 24);
String before_3m = sdf.format(cal.getTime());

String default_st_dt = before_3m.substring(0,4)+"-"+before_3m.substring(4,6)+"-"+before_3m.substring(6,8);
String default_ed_dt = today.substring(0,4)+"-"+today.substring(4,6)+"-"+today.substring(6,8);

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector lshpFormCLst = CommUtil.getCommonCode(request, "LSHP_FORM_C");
if(lshpFormCLst==null) lshpFormCLst = new Vector();
Vector lshpStscLst = CommUtil.getCommonCode(request, "LSHP_STSC");
if(lshpStscLst==null) lshpStscLst = new Vector();

Vector lshpDczStsDscTempLst = null;
if("nml".equals(role_id) || "nmlld".equals(role_id)){ //보고부서, 보고부서장
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC_NML");
}else if("orm".equals(role_id) || "ormld".equals(role_id)){ //ORM, ORM부서장
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC_ORM");
}else if("admn".equals(role_id) ){ //사건관리부서
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC_ADM");
}else{ //hcorm 지주
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC");
}
if(lshpDczStsDscTempLst==null) lshpDczStsDscTempLst = new Vector();

Vector lshpDczStsDscLst = new Vector();
for(int i=0;i<lshpDczStsDscTempLst.size();i++){
	HashMap tempMap = (HashMap)lshpDczStsDscTempLst.get(i);
	String intg_cnm = (String)tempMap.get("intg_cnm");
	String intgc = (String)tempMap.get("intgc");
	/*
	if("nml".equals(role_id) || "nmlld".equals(role_id)){ //보고부서, 보고부서장
		if(!"01".equals(intgc) && !"02".equals(intgc) && !"04".equals(intgc) && !"05".equals(intgc) && !"06".equals(intgc) && !"12".equals(intgc)){
			continue;
		}
	}else if("admn".equals(role_id)){ //사건관리부서
		if(!"03".equals(intgc) && !"04".equals(intgc) && !"05".equals(intgc) && !"06".equals(intgc)){
			continue;
		}
	}
	*/
	
	boolean exist = false;
	for(int j=0;j<lshpDczStsDscLst.size();j++){
		HashMap dscMap = (HashMap)lshpDczStsDscLst.get(j);
		if(intg_cnm.equals((String)dscMap.get("intg_cnm"))){
			//dscMap.put("intgc",(String)dscMap.get("intgc") + ",'" + (String)tempMap.get("intgc")+"'");
			dscMap.put("intgc",(String)dscMap.get("intgc") + "," + (String)tempMap.get("intgc"));
			exist = true;
			break;
		}
	}
	if(!exist){
		tempMap.put("intgc",(String)tempMap.get("intgc"));
		lshpDczStsDscLst.add(tempMap.clone());
	}
}

HashMap hMapSession = (HashMap)request.getSession(true).getAttribute("infoH");
String[] lshp_amnno = (String[]) form.gets("lshp_amnno");
String comn_lshp_amnno = "";
if(form.get("comn_lshp_amnno")!=null){
	comn_lshp_amnno = (String) form.get("comn_lshp_amnno");
}

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		
		<script>
			$(document).ready(function(){
				
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
				// dim (반투명 ) 영역 클릭시 팝업 닫기 
				$('.popup >.dim').click(function () {  
					$(".popup",parent.document).hide();
				});
			});
		
			// 보고부서검색 완료
			function rptOrgSearchEnd(brc, brnm){
				$("#rpt_brc").val(brc);
				$("#rpt_brnm").val(brnm);
				$("#winBuseo").hide();
			}
			// 관리부서검색 완료
			function amnOrgSearchEnd(brc, brnm){
				$("#amn_brc").val(brc);
				$("#amn_brnm").val(brnm);
				$("#winBuseo").hide();
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
				$("#hpn_tpc").val(hpn_tpc);
				$("#hpn_tpnm").val(hpn_tpnm);
				
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
				$("#biz_trry_c").val(biz_trry_c);
				$("#biz_trry_cnm").val(biz_trry_cnm);
				
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
				$("#cas_tpc").val(cas_tpc);
				$("#cas_tpnm").val(cas_tpnm);
				
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
				$("#ifn_tpc_lv2").val(ifn_tpc);
				$("#ifn_tpnm_lv2").val(ifn_tpnm);
				$("#ifn_tpc_lv1").val(ifn_tpc_lv1);
				$("#ifn_tpnm_lv1").val(ifn_tpnm_lv1);
				
				$("#winIfn").hide();
				//doAction('search');
			}
			
			
			
			/*Sheet 기본 설정 */
			function initIBSheet1() {
				//시트 초기화
				mySheet1.Reset();
				
				var initData = {};
				
				initData.Cfg = {FrozenCol:2,MergeSheet:msHeaderOnly,DeferredVScroll:1 };
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
				IBS_InitSheet(mySheet1,initData);
				
				//필터표시
				//mySheet1.ShowFilterRow();  

				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet1.SetCountPosition(0);
				
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
				
				initData.Cfg = {FrozenCol:2,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
				initData.Cols = [
					{Header:"",					Type:"CheckBox",	Width:70,		Align:"Left",	SaveName:"ischeck"},
					{Header:"관리번호",			Type:"Text",		MinWidth:80,	Align:"Left",	SaveName:"lshp_amnno",			Edit:false, 	Wrap:true},
					{Header:"사건발생부서",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"ocu_brnm",			Edit:false, 	Wrap:true},
					{Header:"공통손실개수",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"comn_amnno_cnt",		Hidden:true, 	Wrap:true},
					{Header:"보고부서",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"rpt_brnm",			Edit:false, 	Wrap:true},
					{Header:"사건관리부서",			Type:"Text",		MinWidth:150,	Align:"Left",	SaveName:"amn_brnm",			Edit:false, 	Wrap:true},
					{Header:"사건제목",			Type:"Text",		MinWidth:350,	Align:"Left",	SaveName:"lshp_tinm",			Edit:false, 	Wrap:true, EditLen:200},
					{Header:"발생일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"ocu_dt",				Edit:false, 	Wrap:true},
					{Header:"발견일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"dcv_dt",				Edit:false,		Wrap:true},
					{Header:"입력일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"rgs_dt",				Edit:false, 	Wrap:true},
					{Header:"최초회계일자",			Type:"Date",		MinWidth:80,	Align:"Left",	SaveName:"fir_acg_prc_dt",		Edit:false, 	Wrap:true},
					{Header:"총손실금액",			Type:"Int",			MinWidth:100,	Align:"Right",	SaveName:"tot_lssam",			Edit:false, 	Wrap:true},
					{Header:"보험회수전순손실금액",	Type:"Int",			MinWidth:120,	Align:"Right",	SaveName:"bf_isr_wdr_guls_am",	Edit:false, 	Wrap:true},
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
				mySheet2.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet2.SetSelectionMode(4);
				
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
						$("form[name=ormsForm] [name=process_id]").val("ORLS010102");
						ormsForm.st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
						ormsForm.ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");
						if(ormsForm.txt_st_am.value!=""){
							ormsForm.st_am.value = ormsForm.txt_st_am.value * 10000;
						}
						if(ormsForm.txt_ed_am.value!=""){
							ormsForm.ed_am.value = ormsForm.txt_ed_am.value * 10000;
						}

						
						mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;
				}
			}
	
			
			function mySheet1_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					if(mySheet1.GetDataFirstRow()>0){
						for(var i=mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
<%
							for(int j=0; j<lshp_amnno.length; j++){ 
%>
								if(mySheet1.GetCellValue(i, "lshp_amnno")=="<%=lshp_amnno[j]%>"){
									mySheet1.RowDelete(i);
								}
<%
							}
%>
						}
					}
				}
			}
			
			function copyLoss(){
				var com = true;
				ToSheet = mySheet2;
				FromSheet = mySheet1;
				//체크된 행이 있는지 찾아본다.
				var rows = FromSheet.FindCheckedRow("ischeck");
				//복사될 위치를 구한다.
				var ToRow = ToSheet.GetSelectRow();
				
				
				
				for(var i=mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
					if(mySheet1.GetCellValue(i, "ischeck")=="1" && mySheet1.GetCellValue(i, "comn_amnno_cnt")!="1"){
						alert("공통손실로 등록된 손실사건은 추가할 수 없습니다.");
						com = false;
						mySheet1.SetCellValue(i, "ischeck", "0");
						
						return;
					}
				}
				if(rows==""){
					//현재 포커스가 들어간 행을	이동시킨다.
					alert("선택된 항목이 없습니다.");
					com = false;
					
					return;
				}
				
				if(com){
					
					
					mySheet1.CheckAll("ischeck", 0);
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
					
					$("#relLossCnt").val(mySheet2.RowCount());
				}
				
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
			
			function addComm(){
				var row = "";
				var amnnoArray = [];
				var html = "";
				
				if(mySheet2.GetDataFirstRow()>0){
					for(var i=mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "lshp_amnno")=="<%=comn_lshp_amnno %>"){  
							alert("공통손실을 추가할 수 없습니다.");
							
							return;
						}else{
							row = parent.mySheet5.DataInsert(-1);
							parent.mySheet5.SetCellValue(row, "comn_lshp_amnno", mySheet2.GetCellValue(i, "lshp_amnno"));
							parent.mySheet5.SetCellValue(row, "lshp_tinm", mySheet2.GetCellValue(i, "lshp_tinm"));
							
							amnnoArray.push(mySheet2.GetCellValue(i, "lshp_amnno"));
						}
					}
				}
				
				html += '<input type="hidden" id="hd_lshp_amnno" name="hd_lshp_amnno" value="'+amnnoArray+'">'
				$("form[name=ormsForm] [id=loss_html]").html(html);
				
				
				lossAm1();

				
				
				
			}
			function lossAm1(){
				
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los"); 
				WP.setParameter("process_id", "ORLS010202");  
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
							if(result != 'undefined' && result.rtnCode== '0'){
								var rList = result.DATA;
								
							  	if(rList.length>0){
							  		var row = parent.mySheet1.DataInsert(-1);
							  		for(var i=0; i<rList.length; i++){
							  			parent.mySheet1.SetCellValue(row, "acc_dsc", rList[i].acc_dsc);
							  			parent.mySheet1.SetCellValue(row, "lss_acg_accc", rList[i].lss_acg_accc);
							  			parent.mySheet1.SetCellValue(row, "acg_prc_dt", rList[i].acg_prc_dt);
							  			parent.mySheet1.SetCellValue(row, "lsoc_am", rList[i].lsoc_am);
							  			parent.mySheet1.SetCellValue(row, "tr_cntn", rList[i].tr_cntn);
							  			parent.mySheet1.SetCellValue(row, "rvpy_dsc", rList[i].rvpy_dsc);
							  		}
							  	}
							  
							  
							  
							}
							  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
							lossAm2();
							
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);
				
			}	
			function lossAm2(){
				
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los"); 
				WP.setParameter("process_id", "ORLS010203");  
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
							if(result != 'undefined' && result.rtnCode== '0'){
								var rList = result.DATA;
								
							  	if(rList.length>0){
							  		var row = parent.mySheet2.DataInsert(-1);
							  		for(var i=0; i<rList.length; i++){
							  			parent.mySheet2.SetCellValue(row, "acc_dsc", rList[i].acc_dsc);
							  			parent.mySheet2.SetCellValue(row, "lss_acg_accc", rList[i].lss_acg_accc);
							  			parent.mySheet2.SetCellValue(row, "acg_prc_dt", rList[i].acg_prc_dt);
							  			parent.mySheet2.SetCellValue(row, "lsoc_am", rList[i].lsoc_am);
							  			parent.mySheet2.SetCellValue(row, "tr_cntn", rList[i].tr_cntn);
							  			parent.mySheet2.SetCellValue(row, "rvpy_dsc", rList[i].rvpy_dsc);
							  			parent.mySheet2.SetCellValue(row, "hpn_rc_dt", rList[i].hpn_rc_dt);
							  			parent.mySheet2.SetCellValue(row, "ls_isr_kdc", rList[i].ls_isr_kdc);
							  		}
							  	}
							  
							  
							  
							}
							  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  lossAm3();
						
						  
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);
				
			}	
			function lossAm3(){
				
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los"); 
				WP.setParameter("process_id", "ORLS010204");  
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
							if(result != 'undefined' && result.rtnCode== '0'){
								var rList = result.DATA;
								
							  	if(rList.length>0){
							  		var row = parent.mySheet3.DataInsert(-1);
							  		for(var i=0; i<rList.length; i++){
							  			parent.mySheet3.SetCellValue(row, "acc_dsc", rList[i].acc_dsc);
							  			parent.mySheet3.SetCellValue(row, "lss_acg_accc", rList[i].lss_acg_accc);
							  			parent.mySheet3.SetCellValue(row, "acg_prc_dt", rList[i].acg_prc_dt);
							  			parent.mySheet3.SetCellValue(row, "lsoc_am", rList[i].lsoc_am);
							  			parent.mySheet3.SetCellValue(row, "tr_cntn", rList[i].tr_cntn);
							  			parent.mySheet3.SetCellValue(row, "rvpy_dsc", rList[i].rvpy_dsc);
							  			parent.mySheet3.SetCellValue(row, "lws_prg_cntn", rList[i].lws_prg_cntn);
							  			parent.mySheet3.SetCellValue(row, "lws_hpn_no", rList[i].lws_hpn_no);
							  			parent.mySheet3.SetCellValue(row, "wdr_am_rcp_dt", rList[i].wdr_am_rcp_dt);
							  		}
							  	}
							  
							  
							  
							}
							  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  lossAm4();
						  
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);
				
			}	
			function lossAm4(){
				
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los"); 
				WP.setParameter("process_id", "ORLS010205");  
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
							if(result != 'undefined' && result.rtnCode== '0'){
								var rList = result.DATA;
								
							  	if(rList.length>0){
							  		var row = parent.mySheet4.DataInsert(-1);
							  		for(var i=0; i<rList.length; i++){
							  			parent.mySheet4.SetCellValue(row, "acc_dsc", rList[i].acc_dsc);
							  			parent.mySheet4.SetCellValue(row, "lss_acg_accc", rList[i].lss_acg_accc);
							  			parent.mySheet4.SetCellValue(row, "acg_prc_dt", rList[i].acg_prc_dt);
							  			parent.mySheet4.SetCellValue(row, "lsoc_am", rList[i].lsoc_am);
							  			parent.mySheet4.SetCellValue(row, "tr_cntn", rList[i].tr_cntn);
							  			parent.mySheet4.SetCellValue(row, "rvpy_dsc", rList[i].rvpy_dsc);
							  			parent.mySheet4.SetCellValue(row, "wdr_am_rcp_dt", rList[i].wdr_am_rcp_dt);
							  		}
							  	}
							  
							  
							  
							}
							  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  $(".popup",parent.document).hide();
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);
				
			}	
			
			
			function set_dt_knd(){
				if($("#dt_knd").val()==""){
					$("#st_dt").val("");
					$("#txt_st_dt").val("");
					$("#ed_dt").val("");
					$("#txt_ed_dt").val("");
					document.getElementById('txt_st_dt_btn').disabled = true;
					document.getElementById('txt_ed_dt_btn').disabled = true;
				}else{
					document.getElementById('txt_st_dt_btn').disabled = false;
					document.getElementById('txt_ed_dt_btn').disabled = false;
				}
			}
			function set_am_knd(){
				if($("#am_knd").val()==""){
					$("#st_am").val("");
					$("#txt_st_am").val("");
					$("#ed_am").val("");
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
	<body onkeyPress="return EnterkeyPass()" style="background-color:transparent">
		<div id="" class="popup modal block" >
			<div class="p_frame w1000">
				<div class="p_head">
					<h3 class="title md">손실사건 추가</h3>
				</div>
				<div class="p_body">
					<div class="p_wrap">
				<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					<div id="loss_html"></div>
					
					<!-- 조회 -->
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<tr>
										<th>사건 관리번호</th>
										<td><input type="text" class="form-control w220" id="lshp_amnno" name="lshp_amnno" ></td>
										<th>일자</th>
										<td colspan="5">
											<div class="form-inline">
												<div class="select ">
													<select class="form-control w100" id="dt_knd" name="dt_knd" onchange="set_dt_knd()">
															<option value="">전체</option>
															<option value="oc">발생일자</option>
															<option value="dc">발견일자</option>
															<option value="rg">최초등록일자</option>
															<option value="fa">최초회계처리일자</option>
															<option value="lc">최종변경일자</option>
													</select>
												</div>
												<div class="input-group">
													<input type="hidden" id="st_dt" name="st_dt">
													<input type="text" class="form-control w100" id="txt_st_dt" name="txt_st_dt" disabled>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" id="txt_st_dt_btn" name="txt_st_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');" disabled><i class="fa fa-calendar"></i></button>
													</span>
												</div>
												<div class="input-group">
													<div class="input-group-addon"> ~ </div>
													<input type="hidden" id="ed_dt" name="ed_dt">
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
												<input type="text" class="form-control" id="rpt_brnm" name="rpt_brnm" onKeyPress="EnterkeySubmitOrg('rpt_brnm', 'rptOrgSearchEnd');">
												<input type="hidden" id="rpt_brc" name="rpt_brc" value=""/>
												<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="rpt_brnm_btn" onclick="schOrgPopup('rpt_brnm', 'rptOrgSearchEnd','5');"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
										<th>금액</th>
										<td colspan="5">
											<div class="form-inline">
												<span class="select ib w100">
													<select class="form-control w100p" id="am_knd" name="am_knd" onchange="set_am_knd()">
															<option value="">선택</option>
															<option value="tl">총손실금액</option>
															<option value="bi">보험회수전순손실액</option>
															<option value="gl">순손실금액</option>
													</select>
												</span>
												<div class="input-group">
													<input type="hidden" id="st_am" name="st_am"/> 
													<input type="number" class="form-control text-right" style="width:80px;" id="txt_st_am" name="txt_st_am" disabled> 
													<span class="input-group-addon">백만원 </span>
													<span class="input-group-addon"> ~ </span>
													<input type="hidden" id="ed_am" name="ed_am" />
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
												<input type="hidden" id="amn_brc" name="amn_brc"/> 
												<input type="text" class="form-control" id="amn_brnm" name="amn_brnm" onKeyPress="EnterkeySubmitOrg('amn_brnm', 'amnOrgSearchEnd');">
												<span class="input-group-btn">
													<button class="btn btn-default ico search" type="button" id="amn_brnm_btn" onclick="schOrgPopup('amn_brnm', 'amnOrgSearchEnd');"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
										<th>사건제목</th>
										<td>
											<input type="text" class="form-control w100" id="lshp_tinm" name="lshp_tinm" placeholder="">
										</td>
										<th>경계리스크</th>
										<td>
											<dl class="dropdown dMSC w100"> 
												<dt class="select"><a href="#"> <span class="hida">선택</span> <p class="multiSel"></p></a></dt>
												<dd>
													<div class="mutliSelect">
														<ul>
															<li><input type="checkbox" id="crrk_yn" name="crrk_yn" value="신용"><label for="mulChk-1">신용</label></li>
															<li><input type="checkbox" id="mkrk_yn" name="mkrk_yn" value="시장"><label for="mulChk-2">시장</label></li>
															<li><input type="checkbox" id="lgrk_yn" name="lgrk_yn" value="법률"><label for="mulChk-3">법률</label></li>
															<li><input type="checkbox" id="strk_yn" name="strk_yn" value="전략"><label for="mulChk-4">전략</label></li>
															<li><input type="checkbox" id="fmrk_yn" name="fmrk_yn" value="평판"><label for="mulChk-5">평판</label></li>
														</ul>
													</div>
												</dd>
											</dl>
										</td>
										<th>승인 진행단계</th>
										<td>
											<div class="form-inline">
												<div class="select">
													<select class="form-control w100" id="lshp_dcz_sts_dsc" name="lshp_dcz_sts_dsc">
															<option value="">선택</option>
	<%
				for(int i=0;i<lshpDczStsDscLst.size();i++){
					HashMap hMap = (HashMap)lshpDczStsDscLst.get(i);	%>
															<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
				}
	%>
													</select>
												</div>
											</div>
										</td>
									</tr>
									<tr  id="obj_tr1_orm" name="obj_tr1_orm" style="display:none">
										<th>사건발생 법인</th>
										<td>
											<select class="form-control w220" id="grp_org_c" name="grp_org_c" disabled>
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
												<input type="text" class="form-control" id="hpn_tpnm" name="hpn_tpnm" readonly>
												<input type="hidden" id="hpn_tpc" name="hpn_tpc" />
												<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" onclick="hpn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
										<th>손실형태</th>
										<td>
											<div class="select w120">
												<select class="form-control w100p" id="lshp_form_c" name="lshp_form_c" >
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
												<input type="text" class="form-control" id="cas_tpnm" name="cas_tpnm" readonly>
												<input type="hidden" id="cas_tpc" name="cas_tpc" />
												<span class="input-group-btn">
													<button class="btn btn-default ico search" type="button" onclick="cas_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
									</tr>
									<tr id="obj_tr2_orm" name="obj_tr2_orm" style="display:none">
										<th>보험청구여부</th>
										<td>
											<div class="select w120">
												<select class="form-control" id="isr_rqs_yn" name="isr_rqs_yn">
													<option value="">전체</option>
													<option value="y">Y</option>
													<option value="n">N</option>
												</select>
											</div>
										</td>
										<th>손실상태</th>
										<td>
											<div class="select w120">
												<select class="form-control w100p" id="lshp_stsc" name="lshp_stsc" >
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
												<input type="text" class="form-control" value="전체">
												<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
									</tr>
								</table>
							</div><!-- .wrap-search -->
						</div><!-- .box-body //-->
						<div class="box-footer w150">
							<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
						</div>
					</div>
				</form>
					<!-- 조회 //-->
				<div class="box box-grid">
					<div class="box-body">
						<div class="wrap-grid scroll h230">
							<script> createIBSheet("mySheet1", "100%", "100%"); </script>
						</div><!-- .wrap //-->
					</div><!-- .box-body //-->
				</div><!-- .box //-->
				<div class="btn-wrap mt30 center">
					<button class="btn btn-normal btn-sm" type="button" onclick="javascript:copyLoss();"><i class="fa fa-angle-down"></i><span class="txt">추가</span></button>
					<button class="btn btn-normal btn-sm" type="button" onclick="javascript:removeLoss();"><i class="fa fa-angle-up"></i><span class="txt">삭제</span></button>
				</div>
				<div class="box box-grid">
					<div class="box-header fr" style="margin-bottom:5px;">
						<div class="input-group ib w80 fr"><input class="form-control text-right w60p fl" id="relLossCnt" type="text" value="0"><span class="input-group-addon ib mt10">개</span></div>
					</div>
					<div class="box-body">
						<div class="wrap-grid scroll h230">
							<script> createIBSheet("mySheet2", "100%", "100%"); </script>
						</div><!-- .wrap //-->
					</div><!-- .box-body //-->
				</div><!-- .box //-->
			</div><!-- .p_wrap //-->	
		</div><!-- .p_body //-->
		<div class="p_foot">
			<div class="btn-wrap center">
				<button type="button" class="btn btn-primary" onclick="javascript:addComm();">추가</button>
				<button type="button" class="btn btn-default btn-close">닫기</button>
			</div>
		</div>
		<button type="button" class="ico close  fix btn-close"><span class="blind">닫기</span></button>
	</div>
</div>
<!-- popup //-->
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	

	</body>
	<script>
		$(document).ready(function () {
			//열기
			// 		$(".btn-open").click( function(){
			// 			$(".popup").show();
			// 		});
			//닫기
			$(".btn-close").click( function(event) {
				$(".popup", parent.document).hide();
				event.preventDefault();
			});
		});
	</script>
</html>