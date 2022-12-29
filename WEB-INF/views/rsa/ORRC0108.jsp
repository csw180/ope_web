<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0108.jsp
 Program name : 평가자 지정
 Description  : 화면정의서 RCSA-07
 Programer    : 박승윤
 Date created : 2022.08.18
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
<%
Vector vVlrLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vVlrLst==null) vVlrLst = new Vector();
DynaForm form = (DynaForm)request.getAttribute("form");

/*리스크결재진행단계*/
Vector vRkEvlDczStsc = CommUtil.getCommonCode(request, "RK_EVL_DCZ_STSC");
if(vRkEvlDczStsc==null) vRkEvlDczStsc = new Vector();

String rkEvlDczStsc = "";
String rkEvlDczStnm = "";

for(int i=0;i<vRkEvlDczStsc.size();i++){
	HashMap hMap = (HashMap)vRkEvlDczStsc.get(i);
	if( i > 0 ){
		rkEvlDczStsc += "|";
		rkEvlDczStnm += "|";
	}
	rkEvlDczStsc += (String)hMap.get("intgc");
	
	rkEvlDczStnm += (String)hMap.get("intg_cnm");
}

%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script>
	
	$(document).ready(function(){
	
		// ibsheet 초기화
		initIBSheet();
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"선택",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50,Edit:1},
			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:60, Hidden:true},
			{Header:"리스크사례\nID",Type:"Text",Width:0,Align:"Center",SaveName:"rkp_id",MinWidth:60,Edit:0},
			{Header:"리스크평가기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:60, Hidden:true},
			{Header:"평가부서",Type:"Text",Width:100,Align:"Center",SaveName:"dept_brnm",MinWidth:100,Edit:0},
			{Header:"팀/지점",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:100,Edit:0},
			{Header:"업무 프로세스\nLV1",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm1",MinWidth:100,Edit:0},
			{Header:"업무 프로세스\nLV2",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm2",MinWidth:100,Edit:0},
			{Header:"업무 프로세스\nLV3",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm3",MinWidth:100,Edit:0},
			{Header:"업무 프로세스\nLV4",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm4",MinWidth:100,Edit:0},
			{Header:"리스크 사례",Type:"Text",Width:300,Align:"Left",SaveName:"rk_isc_cntn",MinWidth:200,Edit:0},
			{Header:"통제활동",Type:"Text",Width:300,Align:"Left",SaveName:"cp_cntn",MinWidth:200,Edit:0},
			{Header:"평가지정\n이행여부",Type:"Text",Width:80,Align:"Center",SaveName:"evl_app_yn",MinWidth:60,Edit:0},
			{Header:"평가대상\n여부",Type:"Combo",Width:80,Align:"Center",SaveName:"evl_obj_yn",MinWidth:60, ComboText:"대상|제외", ComboCode:"Y|N",Edit:0},
			{Header:"평가자개인번호",Type:"Text",Width:0,Align:"Center",SaveName:"vlr_eno",MinWidth:60, Hidden:true},
			{Header:"평가자",Type:"Text",Width:100,Align:"Center",SaveName:"vlr_nm",MinWidth:100,Edit:0,MultiLineText:1},
			{Header:"재평가대상여부",Type:"Text",Width:100,Align:"Center",SaveName:"reevl_yn",MinWidth:100,Edit:0,MultiLineText:1,Hidden:true},
			{Header:"결재\n진행단계",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_dcz_stsc",MinWidth:60,ComboText:"<%=rkEvlDczStnm%>", ComboCode:"<%=rkEvlDczStsc%>",Edit:0, Hidden:true}
		];

		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		mySheet.SetAutoRowHeight(0);
		mySheet.SetDataRowHeight(88);
		
		mySheet.FitColWidth();
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		doAction('search');

		
	}

	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {

		switch(sAction) {
			case "search":  //데이터 조회

				DoSearch();
				break;

			case "down2excel":
				
				var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "RCSA평가자지정.xlsx", SheetName : "Sheet1", Merge:1,Mode:-1} ;
				mySheet.Down2Excel(params);
				

				break;

		}
	}
	
	function DoSearch() {

		var f = document.ormsForm;

		if( f.brc.value == ''){
			alert("조직을 입력하세요.");
			return;
		}
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC010802");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;

				  $("#evl_obj_cnt").text(rList[0].evl_obj_cnt);
				  $("#evl_dcz_pct").text(rList[0].evl_dcz_pct);

			  } else if(result!='undefined' && result.rtnCode!="0"){
					alert(result.rtnMsg);
				}
			  
			},
			  
			complete: function(statusText,status) {
				removeLoadingWs();
			},
			  
			error: function(rtnMsg){
				alert(JSON.stringify(rtnMsg));
				
			}
		});
		removeLoadingWs();
		
		var opt = {};
		$("form[name=ormsForm] [name=method]").val("Main");
		$("form[name=ormsForm] [name=commkind]").val("rsa");
		$("form[name=ormsForm] [name=process_id]").val("ORRC010803");

		mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

	}
	function mySheet_OnSearchEnd(code, message) {

	    if(code == 0) {
	    	mySheet.FitColWidth();
	        //조회 후 작업 수행
	        change_text_color();
			
	
		} else {
	
		        alert("조회 중에 오류가 발생하였습니다..");
		}

	}
	
	function change_text_color()
	{

		if($("#evl_dcz_pct").html() == "100%")
		{	
			$("#evl_dcz_pct").css("color","green");
		}
		else
		{
			$("#evl_dcz_pct").css("color","red");
		}
	}
	
	// 업무프로세스검색 완료
	var PRSS4_ONLY = false; 
	var CUR_BSN_PRSS_C = "";
	
	function prss_popup(){
		CUR_BSN_PRSS_C = $("#bsn_prss_c").val();
		if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
		schPrssPopup();
	}

	// 업무프로세스검색 완료
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
		
		//alert(bsn_prss_c);
		
		$("#bsn_prss_c").val(bsn_prss_c);
		$("#bsn_prss_nm").val(bsn_prsnm);
		
		$("#winPrss").hide();
		//doAction('search');
	}
	
	/*Sheet 각종 처리*/
	function doDczProc(sAction) {
		
		<%-- var hofc_bizo_dsc = <%=hofc_bizo_dsc%>; --%>
		if(InputCheck(sAction) == false) return;
		switch(sAction) {
			case "evl":  //평가자지정
				$("#input_ds").val("1"); //입력구분 1:평가자지정
				$("#dcz_dc").val("02");
				$("#rtn_cntn").val("");
				$("#winVlrlst").show();
				break;
			case "exc":  //평가제외
				$("#input_ds").val("2"); //입력구분 2:평가제외
				$("#dcz_dc").val("02");
				$("#rtn_cntn").val("");
				doSave();
				break;
/* 			case "sub":  //상신 (21:평가 -> 23:취합)
				$("#input_ds").val("3"); //입력구분 3:상신
				$("#dcz_dc").val("15");
				$("#rtn_cntn").val("");
				doSave();
				break; */
		}
	}
	//입력값 체크
	function InputCheck(sAction) {


		<%-- var hofc_bizo_dsc = <%=hofc_bizo_dsc%>; --%>
		
		var Cnt = mySheet.GetTotalRows();
		var rk_evl_dcz_stsc = $("#hide_rk_evl_dcz_stsc").val();
		
		var check_cnt = 0;
		 
		for(var i=1;i<=Cnt;i++){
		
			if( mySheet.GetCellValue(i,"ischeck") == "1" ){
				 if((mySheet.GetCellValue(i,"vlr_nm") != "") && sAction == "evl" && mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "20" ){
					 	var confirmflag = confirm("[RI_ID:"+mySheet.GetCellValue(i,"rkp_id")+"]\n평가자 지정  완료된 건 입니다.\n평가자를 변경할 경우 결재 초기화 됩니다.\n평가자를 변경하시겠습니까 ?");
			 			
			 			if(confirmflag){
			 				//확인 버튼 클릭 
			 				
			 				return true
			 			}else{
			 				//취소 버튼 클릭
			 				return false
			 			}
		 		 }else if((mySheet.GetCellValue(i,"vlr_nm") != "") && sAction == "evl" && (mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "30"||mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "40" )){
						
					 	var confirmflag = confirm("[RI_ID:"+mySheet.GetCellValue(i,"rkp_id")+"]\n평가  완료된 건 입니다.\n평가자를 변경할 경우 결재 초기화 됩니다.\n평가자를 변경하시겠습니까 ?");
			 			
			 			if(confirmflag){
			 				//확인 버튼 클릭 
			 				
			 				return true
			 			}else{
			 				//취소 버튼 클릭
			 				return false
			 			}
		 		 }else if((mySheet.GetCellValue(i,"vlr_nm") != "") && sAction == "evl" && mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "50" ){
						
					 	var confirmflag = confirm("[RI_ID:"+mySheet.GetCellValue(i,"rkp_id")+"]\n 팀장/지점장 결제 완료된 리스크 입니다.\n평가자를 변경할 경우 결재 초기화 됩니다.\n평가자를 변경하시겠습니까 ?");
			 			
			 			if(confirmflag){
			 				//확인 버튼 클릭 
			 				return true
			 			}else{
			 				//취소 버튼 클릭
			 				return false
			 			}
		 		 }else if((mySheet.GetCellValue(i,"vlr_nm") != "") && sAction == "evl" && mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "60" ){
						
					 	alert("마감된 리스크 입니다. 평가자 변경 불가 합니다.")
			 			
			 			return false
			 			}
				 if((mySheet.GetCellValue(i,"vlr_nm") != "") && sAction == "exc"){
						
					 	var confirmflag = confirm("[RI_ID:"+mySheet.GetCellValue(i,"rkp_id")+"]\n평가자 지정  완료된 건 입니다.\n평가제외 할 경우 결재 초기화 됩니다.\n평가제외 하시겠습니까 ?");
			 			
			 			if(confirmflag){
			 				//확인 버튼 클릭 
			 				
			 				return true
			 			}else{
			 				//취소 버튼 클릭
			 				return false
			 			}
		 		 }
				 /*
				 if( rk_evl_dcz_stsc == 13 && (mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "19" || mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "21"||mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "26")||mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "30"){
					 alert("이미 결제완료된 건은 처리할 수 없습니다.[line:"+i+"]");
					 return false;
				 }
				 
				 if( rk_evl_dcz_stsc == 15 && mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "13" ){
					 alert("미상신된 건은 처리할 수 없습니다.[line:"+i+"]");
					 return false;
				 }
				 
				 if( rk_evl_dcz_stsc == 15 && (mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "19" || mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "21"||mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "26")||mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "30"  ){
					 alert("이미 결제완료된 건은 처리할 수 없습니다.[line:"+i+"]");
					 return false;
				 }
				 
				 if(hofc_bizo_dsc == "2")
					 {
						 if( rk_evl_dcz_stsc == 19 && (mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "13" || mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "15") )
							{
							 alert("팀장결제 완료 전 입니다.[line:"+i+"]");
							 return false;
					 		}
						 
					 }
				 else
					 {
					 	if( rk_evl_dcz_stsc == 19 && (mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "13"))
							{
							 alert("미상신 건은 처리할 수 없습니다.[line:"+i+"]");
							 return false;
				 			}
					 }
				 
				 
				 if( rk_evl_dcz_stsc == 19 && (mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "21" || mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "26") ){
					 alert("평가완료된 건은 처리할 수 없습니다.[line:"+i+"]");
					 return false;
				 }
				 if( rk_evl_dcz_stsc == 19 && mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "30" ){
					 alert("평가완료된 건은 처리할 수 없습니다.[line:"+i+"]");
					 return false;
				 }*/
				 check_cnt++;
			}				 
		}
		if(check_cnt==0){
			alert("처리할 항목을 선택하세요");
			return false;
		}

		 return true;
	}
	
	function doSave() {
		
		
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		mySheet.DoSave(url, { Param : "method=Main&commkind=rsa&process_id=ORRC010804&dcz_dc="+$("#dcz_dc").val()+"&rtn_cntn="+$("#rtn_cntn").val()+"&input_ds="+$("#input_ds").val()+"&vlr_eno1="+$("#vlr_eno1").val(), Col : 0 });
		
		$("#vlr_eno1").val(""); /*vlr_eno1 초기화 */
		$("#rtn_cntn").val("");

		
	}
	
	function VlrSave() {
		$("#winVlrlst").hide();
		radio_to_eno();
		if($("#vlr_eno1").val()=="")
		{
			alert("평가자를 선택하여 주세요.")
		}else{
			doSave();
		}
	}
	
	function radio_to_eno() {
		var selected_eno = $('input:radio[name="vlr_eno_select"]:checked').val();
		$("#vlr_eno1").val(selected_eno);
	}
	
	function RetrunSave() {
		$("#winRetMod").hide();
		doSave();
		
	}
	
	function mySheet_OnSaveEnd(code, msg) {
	    if(code >= 0) {
	    	alert("저장되었습니다.");
	    	doAction('search');
	    } else {
	    	alert(msg); // 저장 실패 메시지
	    }
	}

	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		if(Row >= mySheet.GetDataFirstRow()){
			$("#rkp_id").val(mySheet.GetCellValue(Row,"rkp_id"));
			$("#ifrRskMod").attr("src","about:blank");
			$("#winRskMod").show();
			showLoadingWs(); // 프로그래스바 활성화
			setTimeout(RiskSearch,1);
			//showLoadingWs(); // 프로그래스바 활성화

		}
	}
	
	function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		   if(KeyCode == 13) {
			 if(Row >= mySheet.GetDataFirstRow()){
			   if( mySheet.GetCellText(Row,"ischeck")==0)
			   	 {
			     	mySheet.SetCellText(Row,"ischeck",1);
			     }
			   else if ( mySheet.GetCellText(Row,"ischeck")==1)
			   	 {
			     	mySheet.SetCellText(Row,"ischeck",0);
			     }
			 }
		   }
	    }
	
	
	function RiskSearch(){
		var f = document.ormsForm;
		f.method.value="Main";
	    f.commkind.value="rsa";
	    f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	    f.process_id.value="ORRC010301";
		f.target = "ifrRskMod";
		f.submit();
	}
	

	
	var init_flag = false;
	function org_popup(){
		schOrgPopup("brnm", "orgSearchEnd");
		if($("#brnm").val() == "" && init_flag){
			$("#ifrOrg").get(0).contentWindow.doAction("search");
		}
		init_flag = false;
	}
	
	// 부서검색 완료
	function orgSearchEnd(brc, brnm){
		if(brc=="") init_flag = true;
		$("#brc").val(brc);
		$("#brnm").val(brnm);
		$("#winBuseo").hide();
		//doAction('search');
	}
	
	// 손실사건유형검색 완료
	var HPN3_ONLY = false; 
	var CUR_HPN_TPC = "";
	
	function hpn_popup(){
		CUR_HPN_TPC = $("#hpn_tpc").val();
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
		
		$("#hpn_tpc").val(hpn_tpc);
		$("#hpn_tpc_nm").val(hpn_tpnm);
		
		$("#winHpn").hide();
		//doAction('search');
	}
	
	</script>
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		
		
		<div class="content">
			<!-- .search-area 검색영역 -->
		<form id="ormsForm" name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="hide_rk_evl_dcz_stsc" name="hide_rk_evl_dcz_stsc" value="<%=form.get("rk_evl_dcz_stsc")%>" />
				<input type="hidden" id="dcz_dc" name="dcz_dc" />
				<input type="hidden" id="input_ds" name="input_ds" />
				<input type="hidden" id="rkp_id" name="rkp_id" />
				<input type="hidden" id="mode" name="mode" value="X" />
				<input type="hidden" id="updateYn" name="updateYn" value="N" />
				<input type="hidden" id="vlr_eno1" name="vlr_eno1" value="" />
				<input type="hidden" id="bas_ym" name="bas_ym" value="" />
				<input type="hidden" id="rk_evl_dcz_stsc" name="rk_evl_dcz_stsc" value="" />

			<!-- .search-area 검색영역 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>조직</th>
									<td>
										<input type="hidden" id="brc" name="brc" value="<%=brc %>" />
										<input type="text" class="form-control w140" id="brnm" name="brnm" value="<%=brnm %>" readonly/> 
										<!-- 
										<button type="button" class="btn btn-default ico fl" id="btn" onclick="org_popup();" >
											<i class="fa fa-search"></i><span class="blind">검색</span>
										</button> -->
									</td>
									<th>업무 프로세스</th>
									<td>
										<div class="input-group">
										  <input type="hidden" id="bsn_prss_c" name="bsn_prss_c">
										  <input class="form-control w150" type="text" id="bsn_prss_nm" name="bsn_prss_nm" readonly placeholder="전체">
										  <span class="input-group-btn">
											<button class="btn btn-default ico search" type="button"  onclick="prss_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
										  </span>
										</div>
									</td>
									<!-- <th>사건유형</th>
									<td>
										<div class="input-group">
											<input type="hidden" id="hpn_tpc" name="hpn_tpc">
											<input type="text" class="form-control w150" id="hpn_tpc_nm" name="hpn_tpc_nm" readonly placeholder="전체">
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico" onclick="hpn_popup();">
													<i class="fa fa-search"></i><span class="blind">검색</span>
												</button>
											</span>
										</div>
									</td> -->
								</tr>
								<tr>
									<th>평가지정 이행여부</th>
									<td>
										<div class="select">
											<select class="form-control" id="evl_app_yn" name="evl_app_yn">
												<option value="">전체</option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</div>
									</td>
									<!-- <th><label for="" >평가대상 여부</th>
									<td>
										<div class="select">
											<select class="form-control" id="evl_obj_yn" name="evl_obj_yn">
												<option value="">전체</option>
												<option value="Y">대상</option>
												<option value="N">제외</option>
											</select>
										</div>
									</td> -->
									<!-- 
									<th scope="row"><label for="" >결재 완료여부</label></th>
									<td>
										<div class="select">
											<select class="form-control" id="rk_evl_dcz_stsc" name="rk_evl_dcz_stsc">
												<option value="">전체</option>
												<option value="13">미상신</option>
												<option value="15">결재대기</option>
												<option value="21">결재완료</option>
											</select>
										</div>
									</td>
									 -->
								</tr>
							</tbody>
						</table>
					</div>
				</div><!-- .box-body //-->
				
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- .search-area //-->

			<div class="box box-grid">
				<div class="box-header">
					<div class="ib">
						<span class="txt txt-sm ca">평가대상 </span><strong id="evl_obj_cnt" class="cb">0</strong>건 / 
						<!-- <span class="txt txt-sm ca">평가제외 </span><strong id="evl_exc_cnt" class="cs">0</strong>건 / -->
						<!-- <span class="txt txt-sm ca">평가풀 </span><strong id="evl_prg_cnt" class="cs">0</strong>건 / -->
						<span class="txt txt-sm ca">평가자지정률 </span><strong id="evl_dcz_pct" ></strong>
					</div>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h450">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div><!-- .box-body //-->
				<div class="box-footer">
					<div class="btn-wrap">						
						<!-- <span class="txt txt-sm mr10" ><strong class="cr">* 평가제외 상태에서 평가자를 지정하면 평가대상으로 상태가 변경됩니다.</strong></span> -->
						<button type="button" id="eval" class="btn btn-default" onClick="doDczProc('evl');">평가자지정</button>
						<!-- <button type="button" id="expt" class="btn btn-normal" onClick="doDczProc('exc');">평가제외</button> -->
						<!-- 
						<button type="button" id="reqt" class="btn btn-primary" onClick="doDczProc('sub');">상신</button>
						<button type="button" id="sign" class="btn btn-primary" onClick="doDczProc('dcz');">결재</button>
						<button type="button" id="retn" class="btn btn-default" onClick="doDczProc('ret');">반려</button>
						 -->
					</div>
				</div><!-- .box-footer //-->
			</div><!-- .box //-->
			</form>
		</div><!-- .content //-->
	</div><!-- .container //-->
			<!-- popup //-->
	<div id="winRskEvl" class="popup modal">
		<iframe name="ifrRskEvl" id="ifrRskEvl" src="about:blank"></iframe>
	</div>
	<div id="winRskMod" class="popup modal">
		<iframe name="ifrRskMod" id="ifrRskMod" src="about:blank"></iframe>
	</div>
	<div id="winRetMod" class="popup modal">
		<div class="p_frame w600">
			<div class="p_head">
				<h3 class="title">반려 사유</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="wrap-table">
						<table>
							<colgroup>
								<col style="width: 100px;">
								<col>
							</colgroup>
							<tbody>						
								<tr>
									<th>반려 사유</th>
									<td>
										<textarea class="textarea" id="rtn_cntn" name="rtn_cntn" maxlength="255"></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-normal" onclick="RetrunSave();">반려</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
		</div>
		<div class="dim p_close"></div>
	</div>

	<div id="winVlrlst" class="popup modal">
		<div class="p_frame w1100">
			<div class="p_head">
				<h3 class="title md">평가자지정</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="wrap-table">
						<table style="height:40px">
							<tbody>
								<tr>
									<th style="text-align:center;">소속부서</th>
									<%HashMap h2Map = (HashMap)vVlrLst.get(1);%>
									<td style="text-align:center;"><%=(String)h2Map.get("vlr_up_brnm")%></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="wrap-table" style="overflow:auto">
						<!-- 라디오 박스 (평가자 지정부분) 20210416 -->
						<table style="text-align:center;">
								<th style="text-align:center;">선택</th>
								<th style="text-align:center;">팀 부서</th>
								<th style="text-align:center;">직명</th>
								<th style="text-align:center;">성명</th>
								<th style="text-align:center;">개인번호</th>
									<!-- 테이블 데이터 생성 -->
									<%
										for(int i=0;i<vVlrLst.size();i++)
											{
												HashMap hMap = (HashMap)vVlrLst.get(i);
									%>			<tr>
													<td style="text-align:center;"><input type="radio" name="vlr_eno_select" value="<%=(String)hMap.get("vlr_eno")%>"></input></td>
													<td style="text-align:center;"><%=(String)hMap.get("vlr_brnm")%></td>
													<td style="text-align:center;"><%=(String)hMap.get("vlr_oft")%></td>
													<td style="text-align:center;"><%=(String)hMap.get("vlr_enpnm")%></td>
													<td style="text-align:center;"><%=(String)hMap.get("vlr_eno")%></td>
												</tr>
									<%
											}
									%>
						</table>	
						<!--  <input type="TEXT" id="vlr_eno_select" name="vlr_eno_select" value="" />	 -->
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">					
					<button type="button" class="btn btn-primary" onclick="VlrSave();">저장</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").addClass("block");
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(){
				$("#rtn_cntn").val("");
				$(".popup").removeClass("block");
				$(".popup").hide();
				
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				//$(".popup").hide();
			});
		});
			
		// 부점검색 완료
		function buseoSearchEnd(kbr_nm, new_br_cd){
			$("#kbr_nm").val(kbr_nm);
			$("#sch_new_br_cd").val(new_br_cd);
			closeBuseo();
			//doAction('search');
		}
	</script>
</body>
</html>