<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0110.jsp
 Program name : KRI - 전행 KRI 결과 모니터링 요약
 Description  : 
 Programer    : 정현식
 Date created : 2022.09.20
 ---------------------------------------------------------------------------*/
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
<%
DynaForm form = (DynaForm)request.getAttribute("form");
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KRI - 전행 KRI 결과 모니터링 요약</title>

	
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			
			setForm3(); //최근1년지표발생현황(지점,전행) 세팅
	
			// ibsheet 초기화
			initIBSheet();
			initIBSheet2();
			initIBSheet3();
		});
		
		// mySheet
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
		
			var initdata = {};
			var title = "평가년월 이전 6개월간 한도초과 발생 추이|";
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			//initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initdata.Cols = [
				{Header:"지표소관 부서 코드",Type:"Text"		,Width:40	,Align:"Center"	,SaveName:"brc"			,MinWidth:60,Edit:false,Hidden:false},
				{Header:"기준년월"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"bas_ym"		,MinWidth:60,Edit:false,Hidden:false},
						
				{ Header: "No.|No.",						Type: "",	SaveName: "num",			Align: "Center",	Width: 10,	MinWidth: 30 },
				{ Header: "지표 소관부서|지표 소관부서",				Type: "",	SaveName: "brnm",			Align: "Center",	Width: 10,	MinWidth: 100 },
				{ Header: "KRI-ID|KRI-ID",					Type: "",	SaveName: "oprk_rki_id",	Align: "Center",	Width: 10,	MinWidth: 80 },
				{ Header: "지표명|지표명",						Type: "",	SaveName: "oprk_rkinm",		Align: "Left",		Width: 10,	MinWidth: 200 },
				{ Header: "발생 건수|발생 건수",						Type: "",	SaveName: "kri_nvl",		Align: "Center",	Width: 10,	MinWidth: 60 },
				{ Header: "KRI 등급|KRI 등급",					Type: "",	SaveName: "kri_grdnm",		Align: "Center",	Width: 10,	MinWidth: 60 },
				{ Header: title + $("#kri_ev_06").val(),	Type: "",	SaveName: "kri_grdnm_06",	Align: "Center",	Width: 10,	MinWidth: 60 },
				{ Header: title + $("#kri_ev_05").val(),	Type: "",	SaveName: "kri_grdnm_05",	Align: "Center",	Width: 10,	MinWidth: 60 },
				{ Header: title + $("#kri_ev_04").val(),	Type: "",	SaveName: "kri_grdnm_04",	Align: "Center",	Width: 10,	MinWidth: 60 },
				{ Header: title + $("#kri_ev_03").val(),	Type: "",	SaveName: "kri_grdnm_03",	Align: "Center",	Width: 10,	MinWidth: 60 },
				{ Header: title + $("#kri_ev_02").val(),	Type: "",	SaveName: "kri_grdnm_02",	Align: "Center",	Width: 10,	MinWidth: 60 },
				{ Header: title + $("#kri_ev_01").val(),	Type: "",	SaveName: "kri_grdnm_01",	Align: "Center",	Width: 10,	MinWidth: 60 },
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
		}

		// mySheet2
		function initIBSheet2() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "순위",		Type: "",	SaveName: "b_rank",	Align: "Center",	Width: 10,	MinWidth: 40 },
				{ Header: "지점명",	Type: "",	SaveName: "brnm",	Align: "Left",		Width: 10,	MinWidth: 200 },
				{ Header: "RED 개수",	Type: "",	SaveName: "cnt",	Align: "Center",	Width: 10,	MinWidth: 80 },
			];
			IBS_InitSheet(mySheet2, initdata);
			mySheet2.SetSelectionMode(4);
		}

		// mySheet3
		function initIBSheet3() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "순위",		Type: "",	SaveName: "b_rank",		Align: "Center",	Width: 10,	MinWidth: 40 },
				{ Header: "지표명",	Type: "",	SaveName: "oprk_rkinm",	Align: "Left",		Width: 10,	MinWidth: 200 },
				{ Header: "발생 지점 수",	Type: "",	SaveName: "cnt",		Align: "Center",	Width: 10,	MinWidth: 80 },
			];
			IBS_InitSheet(mySheet3, initdata);
			mySheet3.SetSelectionMode(4);
		}		
	
		/*상단 조회(수정)조건 세팅*/
		function setForm1() {
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "kri");
			WP.setParameter("process_id", "ORKR011009"); //본부부서  KRI 평가결과
	
			WP.setForm(f);
	
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
	
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    { 
				  success: function(result){
					if(result != 'undefined' && result.rtnCode== '0'){
						var rList = result.DATA;
						
						$("#g_bas_ym0")	.text($("#sch_bas_ym").val().substring(0,4) + "-" + $("#sch_bas_ym").val().substring(4,6));
						$("#g_bas_ym1")	.text($("#sch_bas_ym").val().substring(0,4) + "-" + $("#sch_bas_ym").val().substring(4,6));
						$("#g_bas_ym2")	.text($("#sch_bas_ym").val().substring(0,4) + "-" + $("#sch_bas_ym").val().substring(4,6));
						$("#g_bas_ym3")	.text($("#sch_bas_ym").val().substring(0,4) + "-" + $("#sch_bas_ym").val().substring(4,6));
						
					  	if(rList.length > 0){
						  	
						  	$("#h_target_cnt")	.text(rList[0].h_target_cnt);
						  	$("#h_kri_cnt")		.text(rList[0].h_kri_cnt);
						  	$("#h_red_cnt")		.text(rList[0].h_red_cnt);
						  	$("#h_red_chg_cnt")	.text(rList[0].h_red_chg_cnt);
						  	$("#h_plan_cnt")	.text(rList[0].h_plan_cnt);
						  	$("#h_plan_chg_cnt").text(rList[0].h_plan_chg_cnt);
						  	
							// RED발생건수 증감
							if ( parseInt($("#h_red_chg_cnt").text()) > 0 ) {
								$("#h_red_chg_cnt").attr("class","num up");
							}
							else if (parseInt($("#h_red_chg_cnt").text()) == 0){
							
							}	
							else {
								$("#h_red_chg_cnt").attr("class","num down");
								$("#h_red_chg_cnt").text(Math.abs(parseInt($("#h_red_chg_cnt").text())));
							}	
													
							// 대응방안 증감
							if ( parseInt($("#h_plan_chg_cnt").text()) > 0 ) {
								$("#h_plan_chg_cnt").attr("class","num up");
							}	
							else if (parseInt($("#h_plan_chg_cnt").text()) == 0){
							
							}							
							else {
								$("#h_plan_chg_cnt").attr("class","num down");
								$("#h_plan_chg_cnt").text(Math.abs(parseInt($("#h_plan_chg_cnt").text())));
							}	
					  	}
					  } 
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);
		}
		
		/*최근1년지표발생값(등급) 세팅*/
		function setForm2() {
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "kri");
			WP.setParameter("process_id", "ORKR011010"); //영업점 KRI 평가결과
			
			WP.setForm(f);
	
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
	
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					if(result != 'undefined' && result.rtnCode== '0'){
						var rList = result.DATA;
					  	if(rList.length > 0){
						  	
						  	$("#b_target_cnt")	.text(rList[0].b_target_cnt);
						  	$("#b_kri_cnt")		.text(rList[0].b_kri_cnt);
						  	$("#b_red_cnt")		.text(rList[0].b_red_cnt);
						  	$("#b_red_chg_cnt")	.text(rList[0].b_red_chg_cnt);
						  	$("#b_plan_cnt")	.text(rList[0].b_plan_cnt);
						  	$("#b_plan_chg_cnt").text(rList[0].b_plan_chg_cnt);
						  	
							// RED발생건수 증감
							if ( parseInt($("#b_red_chg_cnt").text()) > 0 ) {
								$("#b_red_chg_cnt").attr("class","num up");
							}	
							else if (parseInt($("#b_red_chg_cnt").text()) == 0){
							
							}							
							else {
								$("#b_red_chg_cnt").attr("class","num down");
								$("#b_red_chg_cnt").text(Math.abs(parseInt($("#b_red_chg_cnt").text())));
							}	
													
							// 대응방안 증감
							if ( parseInt($("#b_plan_chg_cnt").text()) > 0 ) {
								$("#b_plan_chg_cnt").attr("class","num up");
							}	
							else if (parseInt($("#b_plan_chg_cnt").text()) == 0){
							
							}							
							else {
								$("#b_plan_chg_cnt").attr("class","num down");
								$("#b_plan_chg_cnt").text(Math.abs(parseInt($("#b_plan_chg_cnt").text())));
							}						  	
					  	}
					  } 
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);
		}
		
		/*본부부서 주요 KRI 발생내역 세팅*/
		function setForm3() {
			doAction('search');
		}
		
		/*영업점 RED 최대발생지점 ( TOP 10 ) 세팅*/
		function setForm4() {
		
			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("kri"); // kri
			$("form[name=ormsForm] [name=process_id]").val("ORKR011012"); //ORKR010102			
			mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
	
		}
		
		/*영업점 RED 최대발생 KRI ( TOP 10 ) 세팅*/
		function setForm5() {
		
			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("kri"); // kri
			$("form[name=ormsForm] [name=process_id]").val("ORKR011013"); //ORKR010102			
			mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
	
		}			
	
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction("loadexcel");
			}
		}
	
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					setForm1(); //상단 조회(수정)조건 세팅
					setForm2(); //최근1년지표발생값(등급) 세팅
					setForm4(); //영업점 RED 최대발생지점 ( TOP 10 )
					setForm5(); //영업점 RED 최대발생 KRI ( TOP 10 )
					
					lastMonth();
					
					$("#kri_ev_01").val(lastMonth(1));
					$("#kri_ev_02").val(lastMonth(2));
					$("#kri_ev_03").val(lastMonth(3));
					$("#kri_ev_04").val(lastMonth(4));
					$("#kri_ev_05").val(lastMonth(5));
					$("#kri_ev_06").val(lastMonth(6));
					
					mySheet.Reset();
					var initdata = {};
					initdata.Cfg = { MergeSheet: msHeaderOnly };				
					initdata.Cols = [
						{Header:"지표소관 부서 코드",Type:"Text"		,Width:40	,Align:"Center"	,SaveName:"brc"			,MinWidth:60,Edit:false,Hidden:false},
						{Header:"기준년월"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"bas_ym"		,MinWidth:60,Edit:false,Hidden:false},
									
						{ Header: "No.|No.",						Type: "",	SaveName: "num",			Align: "Center",	Width: 10,	MinWidth: 30 },
						{ Header: "지표 소관부서|지표 소관부서",				Type: "",	SaveName: "brnm",			Align: "Center",	Width: 10,	MinWidth: 100 },
						{ Header: "KRI-ID|KRI-ID",					Type: "",	SaveName: "oprk_rki_id",	Align: "Center",	Width: 10,	MinWidth: 80 },
						{ Header: "지표명|지표명",						Type: "",	SaveName: "oprk_rkinm",		Align: "Left",		Width: 10,	MinWidth: 200 },
						{ Header: "발생 건수|발생 건수",						Type: "",	SaveName: "kri_nvl",		Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "KRI 등급|KRI 등급",					Type: "",	SaveName: "kri_grdnm",		Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 6개월간 한도초과 발생 추이|"+$("#kri_ev_06").val(),	Type: "",	SaveName: "kri_grdnm_06",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 6개월간 한도초과 발생 추이|"+$("#kri_ev_05").val(),	Type: "",	SaveName: "kri_grdnm_05",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 6개월간 한도초과 발생 추이|"+$("#kri_ev_04").val(),	Type: "",	SaveName: "kri_grdnm_04",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 6개월간 한도초과 발생 추이|"+$("#kri_ev_03").val(),	Type: "",	SaveName: "kri_grdnm_03",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 6개월간 한도초과 발생 추이|"+$("#kri_ev_02").val(),	Type: "",	SaveName: "kri_grdnm_02",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 6개월간 한도초과 발생 추이|"+$("#kri_ev_01").val(),	Type: "",	SaveName: "kri_grdnm_01",	Align: "Center",	Width: 10,	MinWidth: 60 },
					];
								
					IBS_InitSheet(mySheet, initdata);
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR011011");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "ORKR3101":		//변경내용입력팝업
					$("#ifrORKR3101").attr("src","about:blank");
					$("#winORKR3101").show();
					
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(popORKR3101,1);
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					
					//setExcelDownCols("1|2|3|4");
					mySheet.Down2Excel(excel_params);
	
					break;
			}
		}
		
		function lastMonth(monthCnt) {
			var date = new Date($("#sch_bas_ym").val().substring(0,4) + "-" + $("#sch_bas_ym").val().substring(4,6) + "-01");
			date.setMonth(date.getMonth() - monthCnt);
			
			var check = date.getMonth() + 1;
			if(check < 10) {
				check = "0" + check;
			}
			else {
				check = "" + check;
			}
			return (date.getFullYear()+"").substring(2,4) + "." + check;
		}
	
		function popORKR3101(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR011501";
			f.target = "ifrORKR3101";
			f.submit();
		}
	
		function mySheet_OnSearchEnd(code, message) {
	
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			$("#pool_cnt").text(mySheet.RowCount());
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
	
		// 조직검색 완료
		function orgSearchEnd(brc, brnm){
			$("#brc").val(brc);
			$("#brcnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
		
		/*변경사유입력팝업*/
		function save(){
			var f = document.ormsForm;
			//alert(" 허용한도구분 --> " + f.kri_lmt_dsc.value);
			if ( f.kri_lmt_dsc.value == '01') { // 고정방식일 경우만 체크 
				if(f.sc1_max_trh.value.trim()==''){
					alert("1차한도기준을 입력하십시오.");
					f.sc1_max_trh.focus();
					return;
				}
				
				if(f.sc2_max_trh.value.trim()==''){
					alert("2차한도기준을 입력하십시오.");
					f.sc2_max_trh.focus();
					return;
				}
			}	
			if(!confirm("저장하시겠습니까?")) return;	
			//doAction('ORKR3101'); //변경내용입력팝업
			endORKR3101();
		}
	
		/*출력*/
		function print() {
			alert("개발 예정입니다.");
		}	
		
		/*Sheet 각종 처리*/
		function doDczProc(sAction) {
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			
			var Cnt = mySheet.GetTotalRows();
			
			
			switch(sAction) {
				
				case "save":  
					if(InputCheck(sAction) == false) return;
					
					$("#dcz_dc").val("03");
					$("#dcz_rmk_c").val("");
				    doSave();
					break;
			
				case "sub":  
					if(InputCheck(sAction) == false) return;
					
					$("#dcz_dc").val("04");
				    $("#dcz_objr_emp_auth").val("'004','006'");
				    $("#dcz_rmk_c").val("");
				    schDczPopup(1);
					break;
				
				case "dcz":  //결제
				
					if(InputCheck(sAction) == false) return;
					
					if($("#kri_menu_dsc").val()=='2')
					{
						$("#dcz_dc").val("13"); 
						$("#dcz_objr_emp_auth").val("'002'");
						$("#dcz_rmk_c").val("");
					}else if($("#kri_menu_dsc").val()=='3')
					{
						$("#dcz_dc").val("14"); 
						$("#dcz_objr_emp_auth").val("'009'");
						$("#dcz_rmk_c").val("");
					}else if($("#kri_menu_dsc").val()=='4')
					{
						$("#dcz_dc").val("15"); 
						$("#dcz_rmk_c").val("");
					}
					
					schDczPopup(2);
					//doSave();
					break;
					
				case "ret":  //반려
					if(InputCheck(sAction) == false) return;
					//$("#dcz_objr_emp_auth").val("'002'");
					$("#dcz_dc").val("03");
					$("#dcz_rmk_c").val("01");
					schDczPopup(2);
					//$("#winRetMod").show();
					doSave();
					break;
					
			}
		}	
		
		//입력값 체크
		function InputCheck(sAction) {
			
			$("#rpst_id").val("");
			var kri_menu_dsc = $("#kri_menu_dsc").val(); 
			var ret_yn ="N";
			if(sAction=="ret")
				{
				 ret_yn = "Y";
				} 
		     var ckcnt = "";
			 var Cnt = mySheet.GetTotalRows();
			 var rki_dcz_stsc = $("#rki_dcz_stsc").val();
			  
				  if($("#rpst_id").val()==""){
				  	$("#rpst_id").val(mySheet.GetCellValue(i,"oprk_rki_id"));
				  	$("#bas_pd").val(mySheet.GetCellValue(i,"bas_ym"));
				  }
				  			  
			 //for(var i = mySheet.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
			//		if(mySheet.GetCellValue(i, "ischeck")=="1"){				
			//			ckcnt++;
			//		}
			//} 
		    // if(ckcnt==0){
		    // 	alert("KRI를 선택해 주세요.");
		    // 	return false;
		    // }		
/*		     
			 for(var i=1;i<=Cnt;i++){
				 if( mySheet.GetCellValue(i,"ischeck") == "1" ){
				  if($("#rpst_id").val()==""){
				  	$("#rpst_id").val(mySheet.GetCellValue(i,"rki_id"));
				  	$("#bas_pd").val(mySheet.GetCellValue(i,"bas_ym"));
				  }
				if( kri_menu_dsc == 1 && sAction == "save"){
					 if( mySheet.GetCellValue(i,"rki_dcz_stsc") > "03" ){
						 alert("이미 결재 진행중인 항목이 존재 합니다. \n[KRI : "+mySheet.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }
				}else if(kri_menu_dsc == 1){
					if( mySheet.GetCellValue(i,"rki_dcz_stsc") > "03" ){
						 alert("이미 결재 진행중인 항목이 존재 합니다. \n[KRI : "+mySheet.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }
					if(!confirm("따로  저장하지 않을시 현재 기입한 수치로 결재가 상신됩니다. 진행하시겠습니까?")) return;
				}
				else if( kri_menu_dsc == 2){
					 if( mySheet.GetCellValue(i,"rki_dcz_stsc") < "04" ){
						 alert("상신 되지 않은 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }else if( mySheet.GetCellValue(i,"rki_dcz_stsc") > "04" ){
						 alert("이미 결재 완료한 항목이 존재 합니다. \n[KRI : "+mySheet.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }	 
				}
				else if( kri_menu_dsc == 3){
					 if( mySheet.GetCellValue(i,"rki_dcz_stsc") < "13" ){
						 alert("지점/팀 결재 완료 되지 않은 항목이 존재 합니다. \n[KRI : "+mySheet.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }else if( mySheet2.GetCellValue(i,"rki_dcz_stsc") > "13" ){
						 alert("이미 결재 완료한 항목이 존재 합니다. \n[KRI : "+mySheet.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }	 
				}
				else if( kri_menu_dsc == 4){
					 if( mySheet.GetCellValue(i,"rki_dcz_stsc") < "14" ){
						 alert("ORM확인 되지 않은 항목이 존재 합니다. \n[KRI : "+mySheet.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }else if( mySheet.GetCellValue(i,"rki_dcz_stsc") > "14" ){
						 alert("이미 결재 완료한 항목이 존재 합니다. \n[KRI : "+mySheet.GetCellValue(i,"rki_id")+"]");
						 return false;
					 }	 
				}	
				 
			 }
			 	
			}
*/			
			return true;
			 
		}		
		function doSave() {
			mySheet.DoSave(url, { Param : "method=Main&commkind=kri&process_id=ORKR011014&dcz_dc="+$("#dcz_dc").val()+"&dcz_rmk_c="+$("#dcz_rmk_c").val()+"&sch_rtn_cntn="+$("#sch_rtn_cntn").val()+"&dcz_objr_eno="+$("#dcz_objr_eno").val(), Col : 0 });
			
		}
		
		function mySheet_OnSaveEnd(code, msg) {
			alert(" 저장이 끝났다. --> " + code);
		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		    	$("#winDcz").hide();
		    	doAction('search');  
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}			
	</script>	

</head>
<body>
    <div class="container">
		<!-- page-header -->
		<%@ include file="../comm/header.jsp" %>
			<form name="ormsForm">
				<input type="hidden" id="path" 			name="path" />         <!-- 공통 필수 선언 -->
				<input type="hidden" id="process_id" 	name="process_id" />   <!-- 공통 필수 선언 -->
				<input type="hidden" id="commkind" 		name="commkind" />     <!-- 공통 필수 선언 -->
				<input type="hidden" id="method" 		name="method" />       <!-- 공통 필수 선언 -->
				<input type="text" 	 id="rki_id" 		name="rki_id" />
				
				<input type="hidden" id="kri_ev_01" 	name="kri_ev_01" />
				<input type="hidden" id="kri_ev_02" 	name="kri_ev_02" />
				<input type="hidden" id="kri_ev_03" 	name="kri_ev_03" />
				<input type="hidden" id="kri_ev_04" 	name="kri_ev_04" />
				<input type="hidden" id="kri_ev_05" 	name="kri_ev_05"/>
				<input type="hidden" id="kri_ev_06" 	name="kri_ev_06" />
				
				<input type="hidden" id="kri_menu_dsc" 	name="kri_menu_dsc" 	value="<%=form.get("kri_menu_dsc")%>" />				
				<input type="hidden" id="dcz_dc" 		name="dcz_dc" />
				<input type="hidden" id="table_name" 	name="table_name" 		value="TB_OR_KH_NVL_DCZ"/>
				<input type="hidden" id="dcz_code" 		name="stsc_column_name" value="RKI_DCZ_STSC"/>
				<input type="hidden" id="rpst_id_column" name="rpst_id_column" 	value="OPRK_RKI_ID"/>
				<input type="hidden" id="rpst_id" 		name="rpst_id" 			value=""/>
				<input type="hidden" id="bas_pd_column" name="bas_pd_column" 	value="BAS_YM"/>
				<input type="hidden" id="bas_pd" 		name="bas_pd" 			value=""/>
				<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
				<input type="hidden" id="sch_rtn_cntn" 	name="sch_rtn_cntn" 	value=""/>
				<input type="hidden" id="dcz_objr_eno" 	name="dcz_objr_eno" 	value=""/>
				<input type="hidden" id="dcz_rmk_c" 	name="dcz_rmk_c" 		value=""/>
				<input type="hidden" id="brc_yn" 		name="brc_yn" 			value="Y"/>
								
		<!-- content -->
		<div class="content">

			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th scope="row">평가년월</th>
									<td class="form-inline">
										<span class="select">
											<select class="form-control w120" id="sch_bas_ym" name="sch_bas_ym" >
	<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
	%>
												<option value="<%=(String)hMap.get("bas_ym")%>"><%=((String)hMap.get("bas_ym")).substring(0,4)%>-<%=((String)hMap.get("bas_ym")).substring(4,6)%></option>
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
				<div class="box-footer">					
					<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
				</div>
			</div>
			<!-- 조회 //-->
			
			
			<!-- 평가결과 -->
			<div class="row">
				<div class="col">
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">본부부서 KRI 평가결과</h2>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th scope="col">대상부서</th>
										<th scope="col">KRI 개수</th>
										<th scope="col" colspan="2">RED 발생 건수</th>
										<th scope="col" colspan="2">대응방안 작성 대상 지표 수</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td rowspan="2" id="h_target_cnt"><strong></strong>개</td>
										<td rowspan="2" id="h_kri_cnt"><strong></strong>개</td>
										<th scope="col" id="g_bas_ym0"></th>
										<th scope="col">증감</th>
										<th scope="col" id="g_bas_ym1"></th>
										<th scope="col">증감</th>
									</tr>
									<tr>
										<td id="h_red_cnt"><span></span>건</td>
										<td id="h_red_chg_cnt"><span class="num up"></span></td>
										<td id="h_plan_cnt"><span></span>건</td>
										<td id="h_plan_chg_cnt"><span class="num up"></span></td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
				</div>
				<div class="col">
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">영업점 KRI 평가결과</h2>
							<div class="area-tool">
								<button class="btn btn-xs btn-default" type="button" onclick="javascript:print();"><i class="fa fa-print"></i><span class="txt">PRINT</span></button>
							</div>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th scope="col">대상지점</th>
										<th scope="col">KRI 개수</th>
										<th scope="col" colspan="2">RED 발생 건수</th>
										<th scope="col" colspan="2">대응방안 작성 대상 지표 수</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td rowspan="2" id="b_target_cnt"><strong></strong>개</td>
										<td rowspan="2" id="b_kri_cnt"><strong>121</strong>개</td>
										<th scope="col" id="g_bas_ym2"></th>
										<th scope="col">증감</th>
										<th scope="col" id="g_bas_ym3"></th>
										<th scope="col">증감</th>
									</tr>
									<tr>
										<td id="b_red_cnt"><span>58</span>건</td>
										<td id="b_red_chg_cnt"><span class="num down">7</span></td>
										<td id="b_plan_cnt"><span>42</span>건</td>
										
									<!-- 	<div id="bcp_html"></div> -->
										
										<td id="b_plan_chg_cnt" ></td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
				</div>
			</div>
			<!-- 평가결과 //-->
				
			<!-- 본부부서 주요 KRI 발생 내역 -->
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">본부부서 주요 KRI 발생 내역(대응방안 작성 대상 지표)</h2>
				</div>
				<div class="wrap-grid h400">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
			<!-- 본부부서 주요 KRI 발생 내역 //-->

			<!-- 영업점 KRI 발생 현황 -->
			<article class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">영업점 KRI 발생 현황</h2>
				</div>
				<div class="row">
					<div class="col">
						<section class="box-grid">
							<div class="box-header">
								<h3 class="title">RED 최대 발생 지점 <span class="small">(TOP 10)</span></h3>
							</div>
							<div class="wrap-grid h300">
								<script> createIBSheet("mySheet2", "100%", "100%"); </script>
							</div>
						</section>
					</div>
					<div class="col">
						<section class="box-grid">
							<div class="box-header">
								<h3 class="title">RED 최대 발생 KRI <span class="small">(TOP 10)</span></h3>
							</div>
							<div class="wrap-grid h300">
								<script> createIBSheet("mySheet3", "100%", "100%"); </script>
							</div>
						</section>
					</div>
				</div>		
				<div class="box-footer">					
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onClick="doDczProc('sub');">결재요청</button>
					</div>
				</div>
			</article>
			<!-- 영업점 KRI 발생 현황 //-->
			</form>		
			
		</div>
		<!-- content //-->
		
	</div>	


	<script>
		$(function () {
			//initIBSheet();
			//initIBSheet2();
			//initIBSheet3();
		});

		// 결재팝업 연동 - 결재요청
		function DczSearchEndSub(){
			doSave();
		}
		// 결재팝업 연동 - 결재
		function DczSearchEndCmp(){
			doSave();
		}
		// 결재팝업 연동 - 반려
		function DczSearchEndRtn(){
			doDczProc('ret');
		}
		// 결재팝업 연동 - 회수
		function DczSearchEndCncl(){
			doCncl();
		}

	</script>

</body>
</html>