<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0113.jsp
 Program name : KRI - KRI 평가 결과 조회
 Description  : 
 Programer    : 정현식
 Date created : 2022.09.20
 ---------------------------------------------------------------------------*/
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->	

<%
DynaForm form = (DynaForm)request.getAttribute("form");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
%>

<!DOCTYPE html>
<html lang="ko-kr">
<head>
	<%@ include file="../comm/library.jsp" %>

	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			
			// ibsheet 초기화
			initIBSheet();
		});
	
		function initIBSheet() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
					{ Header: "지표 소관부서|지표 소관부서",								Type: "",	SaveName: "brnm",			Align: "Center",	Width: 10,	MinWidth: 150 },
					{ Header: "KRI-ID|KRI-ID",									Type: "",	SaveName: "oprk_rki_id",	Align: "Center",	Width: 10,	MinWidth: 80 },
					{ Header: "지표명|지표명",										Type: "",	SaveName: "oprk_rkinm",		Align: "Left",		Width: 10,	MinWidth: 200 },
					{ Header: "평가년월 기준 발생 건수|전월대비\n증감율",						Type: "",	SaveName: "kri_chg_pnt",	Align: "Center",	Width: 10,	MinWidth: 60 },
					
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_12").val(),	Type: "",	SaveName: "kri_grdnm_12",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_11").val(),	Type: "",	SaveName: "kri_grdnm_11",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_10").val(),	Type: "",	SaveName: "kri_grdnm_10",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_09").val(),	Type: "",	SaveName: "kri_grdnm_09",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_08").val(),	Type: "",	SaveName: "kri_grdnm_08",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_07").val(),	Type: "",	SaveName: "kri_grdnm_07",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_06").val(),	Type: "",	SaveName: "kri_grdnm_06",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_05").val(),	Type: "",	SaveName: "kri_grdnm_05",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_04").val(),	Type: "",	SaveName: "kri_grdnm_04",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_03").val(),	Type: "",	SaveName: "kri_grdnm_03",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_02").val(),	Type: "",	SaveName: "kri_grdnm_02",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_01").val(),	Type: "",	SaveName: "kri_grdnm_01",	Align: "Center",	Width: 10,	MinWidth: 60 },
					{ Header: "KRI 등급|KRI 등급",									Type: "",	SaveName: "kri_grdnm",		Align: "Center",	Width: 10,	MinWidth: 60 },
					
					{ Header: "상세정보|상세정보",										Type: "Html",SaveName: "Detail",		Align: "Center",	Width: 10,	MinWidth: 60 },
					
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
		}
			
		/*상단 조회(수정)조건 세팅*/
		function setForm1() {
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "kri");
			WP.setParameter("process_id", "ORKR011302"); //본부부서  KRI 평가결과
	
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
						  	
						  	$("#h_bef_red_cnt")		.text(rList[0].h_bef_red_cnt); 		// RED 전월
						  	$("#h_red_cnt")			.text(rList[0].h_red_cnt);			// RED 당월
						  	$("#h_red_chg_cnt")		.text(rList[0].h_red_chg_cnt);		// RED 증감
						  	$("#h_red_chg_pnt")		.text(rList[0].h_red_chg_pnt+" %");	// RED 증감율
						  	
						  	$("#h_bef_yellow_cnt")	.text(rList[0].h_yellow_cnt);		// YELLOW 전월
						  	$("#h_yellow_cnt")		.text(rList[0].h_yellow_cnt);		// YELLOW 당월
						  	$("#h_yellow_chg_cnt")	.text(rList[0].h_yellow_chg_cnt);	// YELLOW 증감
						  	$("#h_yellow_chg_pnt")	.text(rList[0].h_yellow_chg_pnt+" %");	// YELLOW 증감율
						  	
						  	$("#h_bef_plan_cnt")	.text(rList[0].h_plan_cnt);			// 대응방안 전월
						  	$("#h_plan_cnt")		.text(rList[0].h_plan_cnt);			// 대응방안 당월
						  	$("#h_plan_chg_cnt")	.text(rList[0].h_plan_chg_cnt);		// 대응방안 증감
						  	$("#h_plan_chg_pnt")	.text(rList[0].h_plan_chg_pnt+" %");// 대응방안 증감율
						  	
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
							
							// YELLOW발생건수 증감
							if ( parseInt($("#h_yellow_chg_cnt").text()) > 0 ) {
								$("#h_yellow_chg_cnt").attr("class","num up");
							}
							else if (parseInt($("#h_yellow_chg_cnt").text()) == 0){
							
							}	
							else {
								$("#h_yellow_chg_cnt").attr("class","num down");
								$("#h_yellow_chg_cnt").text(Math.abs(parseInt($("#h_yellow_chg_cnt").text())));
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
			WP.setParameter("process_id", "ORKR011303"); //영업점 KRI 평가결과
			
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
						  	
						  	$("#h_red_g_cnt")		.text(rList[0].h_red_g_cnt);
						  	$("#h_yellow_g_cnt")	.text(rList[0].h_yellow_g_cnt);
						  	$("#h_plan_g_cnt")		.text(rList[0].h_plan_g_cnt);
						  	
						  	$("#h_red_cnt_pnt")		.text(rList[0].h_red_cnt_pnt+" %");
						  	$("#h_yellow_cnt_pnt")	.text(rList[0].h_yellow_cnt_pnt+" %");
						  	$("#h_plan_cnt_pnt")	.text(rList[0].h_plan_cnt_pnt+" %");
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
					initIBSheet();
					
					if ( $("#sch_brc").val() == "" ) {
						alert(" 평가조직을 선택하세요.");
						break;
					}	
					setForm1(); //핵심리스크지표 허용한도 초과현황
					setForm2(); //KRI 등급 현황
					
					lastMonth();
					
					$("#kri_ev_01").val(lastMonth(1));
					$("#kri_ev_02").val(lastMonth(2));
					$("#kri_ev_03").val(lastMonth(3));
					$("#kri_ev_04").val(lastMonth(4));
					$("#kri_ev_05").val(lastMonth(5));
					$("#kri_ev_06").val(lastMonth(6));
					
					$("#kri_ev_07").val(lastMonth(7));
					$("#kri_ev_08").val(lastMonth(8));
					$("#kri_ev_09").val(lastMonth(9));
					$("#kri_ev_10").val(lastMonth(10));
					$("#kri_ev_11").val(lastMonth(11));
					$("#kri_ev_12").val(lastMonth(12));	
					
					mySheet.Reset();
					var initdata = {};
					initdata.Cfg = { MergeSheet: msHeaderOnly };				
					initdata.Cols = [
						{ Header: "지표 소관부서|지표 소관부서",								Type: "",	SaveName: "brnm",			Align: "Center",	Width: 10,	MinWidth: 150 },
						{ Header: "KRI-ID|KRI-ID",									Type: "",	SaveName: "oprk_rki_id",	Align: "Center",	Width: 10,	MinWidth: 80 },
						{ Header: "지표명|지표명",										Type: "",	SaveName: "oprk_rkinm",		Align: "Left",		Width: 10,	MinWidth: 200 },
						{ Header: "평가년월 기준 발생 건수|전월대비\n증감율",						Type: "",	SaveName: "kri_chg_pnt",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_12").val(),	Type: "",	SaveName: "kri_grdnm_12",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_11").val(),	Type: "",	SaveName: "kri_grdnm_11",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_10").val(),	Type: "",	SaveName: "kri_grdnm_10",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_09").val(),	Type: "",	SaveName: "kri_grdnm_09",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_08").val(),	Type: "",	SaveName: "kri_grdnm_08",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_07").val(),	Type: "",	SaveName: "kri_grdnm_07",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_06").val(),	Type: "",	SaveName: "kri_grdnm_06",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_05").val(),	Type: "",	SaveName: "kri_grdnm_05",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_04").val(),	Type: "",	SaveName: "kri_grdnm_04",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_03").val(),	Type: "",	SaveName: "kri_grdnm_03",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_02").val(),	Type: "",	SaveName: "kri_grdnm_02",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "평가년월 이전 1년간 한도초과 발생 추이|"+$("#kri_ev_01").val(),	Type: "",	SaveName: "kri_grdnm_01",	Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "KRI 등급|KRI 등급",									Type: "",	SaveName: "kri_grdnm",		Align: "Center",	Width: 10,	MinWidth: 60 },
						{ Header: "상세정보|상세정보",										Type: "",	SaveName: "Detail",			Align: "Center",	Width: 10,	MinWidth: 60 },
						
					];
								
					IBS_InitSheet(mySheet, initdata);
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR011304");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
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
	
		function mySheet_OnSearchEnd(code, message) {
	
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			$("#pool_cnt").text(mySheet.RowCount());
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function mySheet_OnRowSearchEnd(Row) {

			mySheet.SetCellText(Row,"Detail",'<button class="btn btn-xs btn-default" type="button" onclick="DetailStatus(\''+mySheet.GetCellValue(Row,"rki_id")+'\',\''+mySheet.GetCellValue(Row,"bas_ym")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
		}
		
		function DetailStatus(rki_id,bas_ym) {
			$("#rpst_id").val(rki_id);
			$("#bas_pd").val(bas_ym);
			schDczPopup(3);
		}				
		
		// 조직검색 완료
		function orgSearchEnd(brc, brnm){
			$("#brc").val(brc);
			$("#brcnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}

	
	 	// 조직검색 완료
		function orgSearchEnd(brc, brnm){
			$("#sch_brc").val(brc);
			$("#sch_brcnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}	
		
		/*출력*/
		function print() {
			alert("개발 예정입니다.");
		}	
	</script>	    
</head>

<body>
    <div class="container">
		<%@ include file="../comm/header.jsp" %>
		
		<form name="ormsForm">
			<input type="hidden" id="path" 			name="path" />      <!-- 공통 필수 선언 -->
			<input type="hidden" id="process_id" 	name="process_id" /><!-- 공통 필수 선언 -->
			<input type="hidden" id="commkind" 		name="commkind" />  <!-- 공통 필수 선언 -->
			<input type="hidden" id="method"	 	name="method" />    <!-- 공통 필수 선언 -->
			<input type="text" 	 id="rki_id" 		name="rki_id" />
			<input type="text" 	 id="brc" 			name="brc" />		<!-- 사무소코드 -->
			<input type="text" 	 id="brcnm" 		name="brcnm" /> 	<!-- 사무소명 -->				
			
			<input type="hidden" 	 id="kri_ev_01" name="kri_ev_01" />
			<input type="hidden" 	 id="kri_ev_02" name="kri_ev_02" />
			<input type="hidden" 	 id="kri_ev_03" name="kri_ev_03" />
			<input type="hidden" 	 id="kri_ev_04" name="kri_ev_04" />
			<input type="hidden" 	 id="kri_ev_05" name="kri_ev_05" />
			<input type="hidden" 	 id="kri_ev_06" name="kri_ev_06" />
			<input type="hidden" 	 id="kri_ev_07" name="kri_ev_07" />
			<input type="hidden" 	 id="kri_ev_08" name="kri_ev_08" />
			<input type="hidden" 	 id="kri_ev_09" name="kri_ev_09" />
			<input type="hidden" 	 id="kri_ev_10" name="kri_ev_10" />
			<input type="hidden" 	 id="kri_ev_11" name="kri_ev_11" />
			<input type="hidden" 	 id="kri_ev_12" name="kri_ev_12" />				
				
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
									<th>평가 조직</th>
									<td class="form-inline">
										<div class="input-group">
											<input type="hidden" class="form-control" id="sch_brc" name="sch_brc" value="">
											<input type="text" class="form-control" id="sch_brcnm" name="sch_brcnm" value="" readonly="readonly">
											<div class="input-group-btn" id="div_sch_brc" style="visibility: visible;">
												<button type="button" class="btn btn-default ico fl" onclick="schOrgPopup('sch_brcnm', 'orgSearchEnd');">
													<i class="fa fa-search"></i><span class="blind">검색</span>
												</button>
											</div>
										</div>
									</td>	
									
									<th class="form-inline">지표명</th>
									<td><div class="input-group">
										<input type="text" name="" id="" class="form-control w200" placeholder="지표명을 입력해 주십시오.">
										<div class="input-group-btn" id="div_sch_brc" style="visibility: visible;">
											<button type="button" class="btn btn-default ico fl" onclick="schOrgPopup('sch_brcnm', 'orgSearchEnd');">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</div>	
										</div>									
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
			
			
			<!-- 현황 -->
			<div class="row">
				<div class="col">
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">핵심리스크지표 허용한도 초과 현황</h2>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th scope="col" class="w180">구분</th>
										<th scope="col">전월</th>
										<th scope="col">당월</th>
										<th scope="col">증감</th>
										<th scope="col">증감율</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th>RED</th>
										<td id="h_bef_red_cnt"></td>
										<td id="h_red_cnt"></td>
										<td id="h_red_chg_cnt"><span class="num up"></span></td>
										<td id="h_red_chg_pnt"><span></span>%</td>
									</tr>
									<tr>
										<th>YELLOW</th>
										<td id="h_bef_yellow_cnt"></td>
										<td id="h_yellow_cnt"></td>
										<td id="h_yellow_chg_cnt"><span class="num down"></span></td>
										<td id="h_yellow_chg_pnt"><span></span>%</td>
									</tr>
									<tr>
										<th>대응방안 입력대상</th>
										<td id="h_bef_plan_cnt"></td>
										<td id="h_plan_cnt"></td>
										<td id="h_plan_chg_cnt"><span class="num down"></span></td>
										<td id="h_plan_chg_pnt"><span></span>%</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
				</div>
				<div class="col">
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">KRI 등급 현황</h2>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
							
									<tr>
										<th scope="col" class="w180"></th>
										<th scope="col">건수</th>
										<th scope="col">비율</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th>RED</th>
										<td id="h_red_g_cnt"></td>
										<td id="h_red_cnt_pnt"><span></span>%</td>
									</tr>
									<tr>
										<th>YELLOW</th>
										<td id="h_yellow_g_cnt"></td>
										<td id="h_yellow_cnt_pnt"><span></span>%</td>
									</tr>
									<tr>
										<th>대응방안 입력대상</th>
										<td id="h_plan_g_cnt"></td>
										<td id="h_plan_cnt_pnt"><span></span>%</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
				</div>
			</div>
			<!-- 현황 //-->
				

			<!-- KRI 평가 결과 추이 -->
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">KRI 평가 결과 추이</h2>
					<div class="area-tool">
						<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="wrap-grid h400">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
			<!-- KRI 평가 결과 추이 //-->
		</div>
		</form>		
		<!-- content //-->
	</div>	
</body>
</html>