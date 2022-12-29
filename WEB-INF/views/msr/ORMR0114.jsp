<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0114.jsp
 Program name : 운영리스크 개별 위기상황분석 결과 조회
 Description  : MSR-17
 Programer    : 이규탁
 Date created : 2022.07.29
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>운영리스크 개별 위기상황분석 결과 조회</title>
	<script>
		$(function () {
			initIBSheet();
			initIBSheet2();
			
			chartDraw();
		});
	
		// mySheet
		function initIBSheet() {
			var initdata = {};
			initdata.Cfg = { };
			initdata.Cols = [
				{ Header: "구분|구분",					Type: "Text",	SaveName: "gubun",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:false},
				{ Header: "시점|시점",					Type: "Text",	SaveName: "bas_ym",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:false},
				{ Header: "영업지수요소|BI",			Type: "Int",	SaveName: "bi",	Align: "Right",		Width: 10,	MinWidth: 100 ,Format:"#,###" ,Edit:false},
				{ Header: "영업지수요소|BIC",			Type: "Int",	SaveName: "bic",	Align: "Right",		Width: 10,	MinWidth: 100 ,Format:"#,###" ,Edit:false},
				{ Header: "영업지수요소|증감률",		Type: "Float",	SaveName: "bic_ch",	Align: "Center",	Width: 10,	MinWidth: 60 ,	Format : "#,##0.00" ,Edit:false},
				{ Header: "손실요소|연평균손실금액",	Type: "Int",	SaveName: "year_avg_lc",	Align: "Right",		Width: 10,	MinWidth: 100 ,Format:"#,###" ,Edit:false},
				{ Header: "손실요소|LC",				Type: "Int",	SaveName: "lc",	Align: "Right",		Width: 10,	MinWidth: 100 ,Format:"#,###" ,Edit:false},
				{ Header: "손실요소|증감률",				Type: "Float",	SaveName: "lc_ch",	Align: "Center",	Width: 10,	MinWidth: 60 ,	Format : "#,##0.00" ,Edit:false},
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
			mySheet.SetCountPosition(0);
			mySheet.SetMergeSheet(eval("msHeaderOnly"));
		}
	
		// mySheet2
		function initIBSheet2() {
			var initdata = {};
			initdata.Cfg = {};
			initdata.Cols = [
				{ Header: "시뮬레이션 조건|시뮬레이션 조건",	Type: "Text",	SaveName: "sim1",	Align: "Center",	Width: 10,	MinWidth: 60 ,ColMerge: 1 ,Edit:false},
				{ Header: "시뮬레이션 조건|시뮬레이션 조건",	Type: "Text",	SaveName: "sim2",	Align: "Center",	Width: 10,	MinWidth: 40 ,ColMerge: 1 ,Edit:false},
				{ Header: "구분|현재",			Type: "Text",	SaveName: "gubun1",	Align: "Right",		Width: 10,	MinWidth: 50 ,ColMerge: 0},
				{ Header: "구분|현재",			Type: "Text",	SaveName: "gubun2",	Align: "Right",		Width: 10,	MinWidth: 80 ,ColMerge: 0},
				{ Header: "BIC|",							Type: "Int",	SaveName: "bic",	Align: "Right",		Width: 10,	MinWidth: 100 ,ColMerge: 0,Edit:false, ColMerge:0},
				{ Header: "LC|",								Type: "Int",	SaveName: "lc",	Align: "Right",		Width: 10,	MinWidth: 100 ,ColMerge: 0,Edit:false, ColMerge:0},
				{ Header: "ILM|",							Type: "Float",	SaveName: "ilm",	Align: "Right",		Width: 10,	MinWidth: 60 ,ColMerge: 0,Edit:false, ColMerge:0},
				{ Header: "ORC|",							Type: "Int",	SaveName: "orc",	Align: "Right",		Width: 10,	MinWidth: 100 ,ColMerge: 0,Edit:false, ColMerge:0},
				{ Header: "Op.RWA|",						Type: "Int",	SaveName: "rwa",	Align: "Right",		Width: 10,	MinWidth: 100 ,ColMerge: 0,Edit:false, ColMerge:0},
				{ Header: "△ ORC\n(금액)|",		Type: "Int",	SaveName: "orc1",	Align: "Right",		Width: 10,	MinWidth: 100 ,ColMerge: 0,Edit:false, Format:"#,###", ColMerge:0},
				{ Header: "△ ORC\n(비율)|",		Type: "Float",	SaveName: "orc2",	Align: "Right",		Width: 10,	MinWidth: 60 ,ColMerge: 0,Edit:false, ColMerge:0},
			];
			IBS_InitSheet(mySheet2, initdata);
			mySheet2.SetSelectionMode(4);
			mySheet2.SetCountPosition(0);
			mySheet2.SetRowMerge(1,0);
			
			mySheet2.SetRowMerge(3,0);

			mySheet2.SetRowMerge(4,0);
			mySheet2.SetRowMerge(5,0);
			mySheet2.SetMergeSheet(eval("msAll"));
			mySheet2.SetMergeCell(1,2,1,2);
		}
		
		
		// myChart
	
		var chart_category = ["현재", "주의", "경계", "심각", "Simulation"];
		var chart_bic = new Array();
		var chart_lc = new Array();
		var chart_orc = new Array();
		var chart_ilm = new Array();
		
		function chartDraw(){
			myChart.RemoveAll();
			myChart.SetOptions(initChartType);
			myChart.SetOptions(chartSecY, 1);
	
			myChart.SetSeriesOptions([
				{
					name : "BIC",
					Type : "column",
					data : [
						[chart_category[0],	chart_bic[0] ],
						[chart_category[1],	chart_bic[1] ],
						[chart_category[2],	chart_bic[2] ],
						[chart_category[3],	chart_bic[3] ],
						[chart_category[4],	chart_bic[4] ],
					]
				},
				{
					name : "LC",
					Type : "column",
					data : [
						[chart_category[0],	chart_lc[0] ],
						[chart_category[1],	chart_lc[1] ],
						[chart_category[2],	chart_lc[2] ],
						[chart_category[3],	chart_lc[3] ],
						[chart_category[4],	chart_lc[4] ],
					]
				},
				{
					name : "ORC",
					Type : "column",
					data : [
						[chart_category[0],	chart_orc[0] ],
						[chart_category[1],	chart_orc[1] ],
						[chart_category[2],	chart_orc[2] ],
						[chart_category[3],	chart_orc[3] ],
						[chart_category[4],	chart_orc[4] ],
					]
				},
				{
					name : "ILM",
					Type : "line",
					data : [
						[chart_category[0],	chart_ilm[0] ],
						[chart_category[1],	chart_ilm[1] ],
						[chart_category[2],	chart_ilm[2] ],
						[chart_category[3],	chart_ilm[3] ],
						[chart_category[4],	chart_ilm[4] ],
					],
					YAxis: 1
				},
				
			], 1);
			myChart.SetXAxisOptions({Categories : chart_category}, 1);
			
			myChart.Draw();
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
					 if($('#sch_bas_yy').val() == "" || $('#sch_bas_yy').val() == null){
						alert("연도정보가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
					
					var bas_ym = $('#sch_bas_yy').val()+""+$('#sch_bas_qq').val(); //기준년월 (연도 + 분기)
					$("#sch_bas_ym").val(bas_ym);
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011402");
					
/* 					mySheet.RemoveAll();
					mySheet1.RemoveAll();
					myChart1.RemoveAll();
					initIBSheet();
					initIBSheet1();
					myChartDraw1(); */
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011403");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "save":
					break;
				case "help":
					$("#winHelp").show();
					break;
				case "chart":
						chartDraw();
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					setExcelFileName("영업지수 잔액 정보");
					setExcelDownCols("0|1|2|3|4|5|6|7|8|9|10");
					mySheet.Down2Excel(excel_params);
					break;
			}
		}
		var min_bic = new Array();
		var max_lc = new Array();
		var time= "";
		function mySheet_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{	
				mySheet.SetCellValue(mySheet.GetDataLastRow(),"gubun","T");
				min_bic[0] = mySheet.GetCellValue(mySheet.GetDataLastRow(),"bic_ch"); 
				max_lc[0] = mySheet.GetCellValue(mySheet.GetDataLastRow(),"lc_ch"); 
				for (i=mySheet.GetDataLastRow()-2 ; i>0 ;i-- ){
					mySheet.SetCellValue(mySheet.GetDataLastRow() - i,"gubun","T - " + i);
					min_bic[i] = mySheet.GetCellValue(mySheet.GetDataLastRow() - i,"bic_ch"); 
					max_lc[i] = mySheet.GetCellValue(mySheet.GetDataLastRow() - i,"lc_ch"); 
					
				}	
				time = mySheet.GetCellValue(mySheet.GetDataLastRow(),"bas_ym");
			}
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		function mySheet2_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{	
				//
				
				mySheet2.SetCellValue(1,"gubun1","현재("+time+" 기준)");
				mySheet2.SetCellValue(1,"gubun2","현재("+time+" 기준)");
				mySheet2.SetCellValue(3,2,Math.min(...min_bic));
				mySheet2.SetCellValue(4,2,Math.min(...min_bic)*1.5);
				mySheet2.SetCellValue(5,2,Math.min(...min_bic)*2);
				
				mySheet2.SetCellValue(3,3,Math.max(...max_lc));
				mySheet2.SetCellValue(4,3,Math.max(...max_lc)*1.5);
				mySheet2.SetCellValue(5,3,Math.max(...max_lc)*2);
				
				mySheet2.SetCellValue(1,4,mySheet.GetCellValue(mySheet.GetDataLastRow(),"bic"));
				mySheet2.SetCellValue(1,5,mySheet.GetCellValue(mySheet.GetDataLastRow(),"lc"));
				
				var bic = mySheet2.GetCellValue(1,4);
				var lc = mySheet2.GetCellValue(1,5);
				
				//현재시점
				mySheet2.SetCellValue(1,"ilm",Math.log(Math.exp(1) - 1 + Math.pow(lc/bic,0.8)));
				mySheet2.SetCellValue(1,"orc",parseInt(mySheet2.GetCellValue(1,"ilm")*bic));
				mySheet2.SetCellValue(1,"rwa",parseInt(mySheet2.GetCellValue(1,"orc")*12.5));
				//BIC
				mySheet2.SetCellValue(3,"bic",bic*(1+(mySheet2.GetCellValue(3,"gubun1")/100)));
				mySheet2.SetCellValue(4,"bic",bic*(1+(mySheet2.GetCellValue(4,"gubun1")/100)));
				mySheet2.SetCellValue(5,"bic",bic*(1+(mySheet2.GetCellValue(5,"gubun1")/100)));
				//LC
				mySheet2.SetCellValue(3,"lc",lc*(1+(mySheet2.GetCellValue(3,"gubun2")/100)));
				mySheet2.SetCellValue(4,"lc",lc*(1+(mySheet2.GetCellValue(4,"gubun2")/100)));
				mySheet2.SetCellValue(5,"lc",lc*(1+(mySheet2.GetCellValue(5,"gubun2")/100)));
				
				
				var bic_1lv = mySheet2.GetCellValue(3,"bic");
				var lc_1lv = mySheet2.GetCellValue(3,"lc");
				var bic_2lv = mySheet2.GetCellValue(4,"bic");
				var lc_2lv = mySheet2.GetCellValue(4,"lc");
				var bic_3lv = mySheet2.GetCellValue(5,"bic");
				var lc_3lv = mySheet2.GetCellValue(5,"lc");
				//주의
				mySheet2.SetCellValue(3,"ilm",Math.log(Math.exp(1) - 1 + Math.pow(lc_1lv/bic_1lv,0.8)));
				mySheet2.SetCellValue(3,"orc",mySheet2.GetCellValue(3,"ilm")*bic);
				mySheet2.SetCellValue(3,"rwa",mySheet2.GetCellValue(3,"orc")*12.5);
				mySheet2.SetCellValue(3,"orc1",mySheet2.GetCellValue(3,"rwa")-mySheet2.GetCellValue(1,"rwa"));
				mySheet2.SetCellValue(3,"orc2",((mySheet2.GetCellValue(3,"rwa")-mySheet2.GetCellValue(1,"rwa"))/mySheet2.GetCellValue(1,"rwa"))*100);
				
				//경계
				mySheet2.SetCellValue(4,"ilm",Math.log(Math.exp(1) - 1 + Math.pow(lc_2lv/bic_2lv,0.8)));
				mySheet2.SetCellValue(4,"orc",mySheet2.GetCellValue(4,"ilm")*bic);
				mySheet2.SetCellValue(4,"rwa",mySheet2.GetCellValue(4,"orc")*12.5);
				mySheet2.SetCellValue(4,"orc1",mySheet2.GetCellValue(4,"rwa")-mySheet2.GetCellValue(1,"rwa"));
				mySheet2.SetCellValue(4,"orc2",((mySheet2.GetCellValue(4,"rwa")-mySheet2.GetCellValue(1,"rwa"))/mySheet2.GetCellValue(1,"rwa"))*100);
				
				//심각
				mySheet2.SetCellValue(5,"ilm",Math.log(Math.exp(1) - 1 + Math.pow(lc_3lv/bic_3lv,0.8)));
				mySheet2.SetCellValue(5,"orc",parseInt(mySheet2.GetCellValue(5,"ilm")*bic));
				mySheet2.SetCellValue(5,"rwa",mySheet2.GetCellValue(5,"orc")*12.5);
				mySheet2.SetCellValue(5,"orc1",mySheet2.GetCellValue(5,"rwa")-mySheet2.GetCellValue(1,"rwa"));
				mySheet2.SetCellValue(5,"orc2",((mySheet2.GetCellValue(5,"rwa")-mySheet2.GetCellValue(1,"rwa"))/mySheet2.GetCellValue(1,"rwa"))*100);
				
				for(var i=3; i<=5; i++){
					mySheet2.InitCellProperty(i,"ilm",{Type:"Float", Format : "#,##0.0000"})
					mySheet2.InitCellProperty(i,"orc2",{Type:"Float", Format : "#,##0.00"})
				}
					
				chart_bic[0] = parseInt(mySheet2.GetCellValue(1,"bic"));
				chart_lc[0] = parseInt(mySheet2.GetCellValue(1,"lc"));
				chart_ilm[0] = parseFloat(mySheet2.GetCellValue(1,"ilm"));
				chart_orc[0] = parseInt(mySheet2.GetCellValue(1,"orc"));
				
				chart_bic[1] = parseInt(mySheet2.GetCellValue(3,"bic"));
				chart_lc[1] = parseInt(mySheet2.GetCellValue(3,"lc"));
				chart_ilm[1] = parseFloat(mySheet2.GetCellValue(3,"ilm"));
				chart_orc[1] = parseInt(mySheet2.GetCellValue(3,"orc"));
				
				chart_bic[2] = parseInt(mySheet2.GetCellValue(4,"bic"));
				chart_lc[2] = parseInt(mySheet2.GetCellValue(4,"lc"));
				chart_ilm[2] = parseFloat(mySheet2.GetCellValue(4,"ilm"));
				chart_orc[2] = parseInt(mySheet2.GetCellValue(4,"orc"));
				
				chart_bic[3] = parseInt(mySheet2.GetCellValue(5,"bic"));
				chart_lc[3] = parseInt(mySheet2.GetCellValue(5,"lc"));
				chart_ilm[3] = parseFloat(mySheet2.GetCellValue(5,"ilm"));
				chart_orc[3] = parseInt(mySheet2.GetCellValue(5,"orc"));
				
				chart_bic[4] = 0;
				chart_lc[4] = 0;
				chart_ilm[4] = 0;
				chart_orc[4] = 0;
				
				mySheet2.SetRowEditable(1,0);
				mySheet2.SetRowEditable(2,0);
				mySheet2.SetRowEditable(3,0);
				mySheet2.SetRowEditable(4,0);
				mySheet2.SetRowEditable(5,0);
				mySheet2.SetMergeCell(1,2,1,2);
			}
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			doAction('chart');
		}
		
		function mySheet2_OnKeyUp(Row,Col,KeyCode,Shift){
			if(Shift == 0){
				if(KeyCode ==13){
					//mySheet2.SetCellValue(Row,"bic",);
					//Simulation
					var bic = mySheet2.GetCellValue(1,4);
					var lc = mySheet2.GetCellValue(1,5);
					
					mySheet2.SetCellValue(6,"bic",bic*(1+(mySheet2.GetCellValue(6,"gubun1")/100)));
					mySheet2.SetCellValue(6,"lc",lc*(1+(mySheet2.GetCellValue(6,"gubun2")/100)));
					
					var bic_sim = mySheet2.GetCellValue(6,"bic");
					var lc_sim = mySheet2.GetCellValue(6,"lc");
					
					mySheet2.SetCellValue(6,"ilm",Math.log(Math.exp(1) - 1 + Math.pow(lc_sim/bic_sim,0.8)));
					mySheet2.SetCellValue(6,"orc",mySheet2.GetCellValue(6,"ilm")*bic);
					mySheet2.SetCellValue(6,"rwa",mySheet2.GetCellValue(6,"orc")*12.5);
					mySheet2.SetCellValue(6,"orc1",mySheet2.GetCellValue(6,"rwa")-mySheet2.GetCellValue(1,"rwa"));
					mySheet2.SetCellValue(6,"orc2",((mySheet2.GetCellValue(6,"rwa")-mySheet2.GetCellValue(1,"rwa"))/mySheet2.GetCellValue(1,"rwa"))*100);
					
					mySheet2.InitCellProperty(6,"ilm",{Type:"Float", Format : "#,##0.0000"})
					mySheet2.InitCellProperty(6,"orc2",{Type:"Float", Format : "#,##0.00"})
					
					chart_bic[0] = parseInt(mySheet2.GetCellValue(1,"bic"));
					chart_lc[0] = parseInt(mySheet2.GetCellValue(1,"lc"));
					chart_ilm[0] = parseFloat(mySheet2.GetCellValue(1,"ilm"));
					chart_orc[0] = parseInt(mySheet2.GetCellValue(1,"orc"));
					
					chart_bic[1] = parseInt(mySheet2.GetCellValue(3,"bic"));
					chart_lc[1] = parseInt(mySheet2.GetCellValue(3,"lc"));
					chart_ilm[1] = parseFloat(mySheet2.GetCellValue(3,"ilm"));
					chart_orc[1] = parseInt(mySheet2.GetCellValue(3,"orc"));
					
					chart_bic[2] = parseInt(mySheet2.GetCellValue(4,"bic"));
					chart_lc[2] = parseInt(mySheet2.GetCellValue(4,"lc"));
					chart_ilm[2] = parseFloat(mySheet2.GetCellValue(4,"ilm"));
					chart_orc[2] = parseInt(mySheet2.GetCellValue(4,"orc"));
					
					chart_bic[3] = parseInt(mySheet2.GetCellValue(5,"bic"));
					chart_lc[3] = parseInt(mySheet2.GetCellValue(5,"lc"));
					chart_ilm[3] = parseFloat(mySheet2.GetCellValue(5,"ilm"));
					chart_orc[3] = parseInt(mySheet2.GetCellValue(5,"orc"));
					
					chart_bic[4] = parseInt(mySheet2.GetCellValue(6,"bic"));
					chart_lc[4] = parseInt(mySheet2.GetCellValue(6,"lc"));
					chart_ilm[4] = parseFloat(mySheet2.GetCellValue(6,"ilm"));
					chart_orc[4] = parseInt(mySheet2.GetCellValue(6,"orc"));
				}
			}
			doAction('chart');
		}
		
		function modalGuide_open(){
			document.getElementById('modalGuide').classList.add('block');
		}
		function modalGuide_close(){
			document.getElementById('modalGuide').classList.remove('block');
		}
	</script>
	
</head>
<body>
	<div class="container">
		<!-- page-header -->
		<%@ include file="../comm/header.jsp" %>
		<!--.page header //-->
		<!-- content -->
		<div class="content">
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			
			<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" /> <!-- 기준년월 -->
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>연도</th>
									<td>
										<div class="select w100">
											<select name="sch_bas_yy" id="sch_bas_yy" class="form-control">
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("bas_yy")%>"><%=(String)hMap.get("bas_yy")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>분기 선택</th>
									<td>
										<div class="select">
											<select name="sch_bas_qq" id="sch_bas_qq" class="form-control">
												<option value="03">1분기</option>
												<option value="06">2분기</option>
												<option value="09">3분기</option>
												<option value="12">4분기</option>
											</select>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">			
					<button type="button" class="btn btn-default btn-xs" onclick="modalGuide_open();"><i class="fa fa-question-circle"></i><span class="txt">Help</span></button>
					<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
				</div>
			</div>
			<!-- 조회 //-->
				
				
			<div class="row">
				<div class="col">
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">BIC 및 LC 증감률</h2>
						</div>
						<div class="wrap-grid h580">
							<script> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>
				</div>
				<div class="col">
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">위기단계 별 적용계수 설정 및 위기단계 별 Op.RWA 산출</h2>
							<div class="area-tool">
								<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
							</div>
						</div>
						<div class="wrap-grid h270">
							<script> createIBSheet("mySheet2", "100%", "100%"); </script>
						</div>
					</section>
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">위기상황 別 측정요소 변동 추이</h2>
						</div>
						<div class="wrap-chart h260">
							<script> createIBChart("myChart", "100%", "100%"); </script>
						</div>
					</section>
				</div>
			</div>
		</form>
		</div>
		<!-- content //-->
		
	
	</div>
	<!-- tip -->
	<article id="modalGuide" class="popup modal">
		<div class="p_frame w1000">	
			<div class="p_head">
				<h1 class="title">운영리스크 개별 위기상황분석 가이드라인</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				
				
					<section class="box box-grid">	
						<div class="box-header">
							<h2 class="box-title">위기상황 분석 시 ORC 산출모형의 특성 및 고려사항</h2>
						</div>					
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 80px;">
									<col>
									<col style="width: 410px;">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">모형 개요</th>
										<td colspan="2">
											<div class="msr-guide-summary">
												<div class="guide1">ORC<p class="add">(운영위험 자본량)</p></div>
												<div class="code">=</div>
												<dl class="guide2 type1">
													<dt class="summary">BIC<span class="add">(영업지수요소)</span></dt>
													<dd>
														<p class="math"><strong class="fsi">BI</strong> = <strong class="fsi">ILDC</strong> + <strong class="light fsi">SC</strong> + <strong class="light fsi">FC</strong></p>
														<p class="math"><strong class="fsi">BIC</strong> = <strong class="fsi">BI</strong> x <strong class="fsi">α</strong> (BI계수)</p>
													</dd>
												</dl>
												<div class="code">&times;</div>
												<dl class="guide2 type2">
													<dt class="summary">ILM<span class="add">(내부손실승수)</span></dt>
													<dd class="math">
														<strong class="fsi">ILM</strong> = <strong>ln</strong>
														<div class="bracket">
															<strong>exp(1)</strong> - <strong>1</strong> + <span class="round frac"><strong class="fsi num">LC</strong><strong class="fsi num">BIC</strong></span><strong class="math-up">0.8</strong>
														</div>
													</dd>
												</dl>
												<div class="guide3">
													<p>※ ORC 산출 시, BIC와 LC가 변수로 산출됨</p>
													<p>&rarr; 예외적 위기 상황을 BIC 및 LC의 증감으로 정의</p>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row">고려사항</th>
										<td>
											<ul class="ullist">
												<li>1) <strong>영업지수요소와 손실요소</strong>는 모두 <strong>운영위험자본량과 양(+)의 상관관계</strong>를 가짐</li>
												<li>2) <strong>위기상황</strong>(실물경제위축)에 따라 <strong>영업지수요소는 감소</strong>하고, <strong>손실요소는 증가</strong>함을 가정 &rarr; [Back-up 위기상황 정의] 참고</li>
												<li>3) 영업지수 및 손실요소와 운영위험자본량의 상관관계
													<ul class="ullist">
														<li>① 영업지수 &darr; ∝ 운영위험자본량 &darr;</li>
														<li>② 손실요소 &uarr; ∝ 운영위험자본량 &uarr;</li>
														<li>&rarr; 위기상황 시, 영업지수 및 손실요소와 운영위험 자본량의 상관관계로 인하여 운영위험자본량의 변화의 <span class="cr">상쇄 효과 존재</span></li>
													</ul>
												</li>
												<li>&rarr; 단, 영업지수와 손실요소가 <strong><span class="cr">유사한 비율</span>로 변동 시 영업지수 감소에 의한 자본량 감소폭</strong>이 <strong>손실요소 증가로 인한 자본량 증가폭</strong>보다 크기 때문에 <strong>운영위험자본량의 감소효과가 발생함</strong></li>
												<li>4) 변동폭은 현재시점 포함 21개 분기의 증감량 산출 후, <span class="cr">BIC의 최대감소율</span>과 <span class="cr">LC의 최대 증가율</span>을 위기상황 <span class="cr">주의단계 적용 계수</span>로 설정함</li>
											</ul>
										</td>
										<td>
											<img src="<%=System.getProperty("contextpath")%>/imgs/contents/msr_guide_chart.svg" class="msr_guide_chartimg" alt="동일비율 BIc 감소, LC 증가 vs ORC 감소 추이">
											<div class="wrap-footnote">
												<ul class="ullist">
													<li>※ 수협은행의 실제 Raw Data를 사용하였으며, 상세내역은 '수협은행_ORM_측정_위기상황분석(Stress Test) Excel 파일 참조</li>
												</ul>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>

					<section class="box box-grid">						
						<div class="box-header">		
							<h2 class="box-title">위기상황 정의 방안</h2>
						</div>
						<div class="msr-guide-process">
							<p class="process-area"></p>
							<p class="chart-area"></p>
						</div>
						<article class="box box-grid">
							<div class="box-header">
								<h3 class="title">위기상황 분석 시 ORC 산출모형의 특성 및 고려사항</h3>
							</div>					
							<div class="wrap-table">
								<table>
									<thead>
										<tr>
											<th scope="col" class="w180">Case 분류</th>
											<th scope="col">설명</th>
										</tr>
									</thead>
									<tbody class="left">
										<tr>
											<th scope="row" class="cy"><strong>BIC 감소 &amp; LC 감소</strong></th>
											<td class="cy">영업부진 및 사업규모 축소로 영업이익 감소 및 손실사건 규모도 축소</td>
										</tr>
										<tr>
											<th scope="row" class="cy"><strong>BIC 감소 &amp; LC 변화 미미</strong></th>
											<td class="cy">영업부진 및 사업규모 축소로 영업이익은 줄어들었으나, 적극적 통제활동 부재로 손실사건 개선 없음</td>
										</tr>
										<tr>
											<th scope="row" class="tb-grade-red"><strong>BIC 감소 &amp; LC 증가</strong></th>
											<td class="tb-grade-red">영업부진 및 사업규모 축소로 영업이익이 줄어들었으나, 통제활동 부실로 손실사건 증가</td>
										</tr>
										<tr>
											<th scope="row" class="cb"><strong>BIC 변화미미 &amp; LC 감소</strong></th>
											<td class="cb">사업의 정체로 영업이익의 개선이 없으나, 통제활동의 강화로 손실사건 축소</td>
										</tr>
										<tr>
											<th scope="row" class="cb"><strong>BIC 변화미미 &amp; LC 변화미미</strong></th>
											<td class="cb">사업의 정체로 영업이익의 개선이 없으나, 적극적 통제활동의 부재로 손실사건 개선 없음</td>
										</tr>
										<tr>
											<th scope="row" class="cb"><strong>BIC 변화미미 &amp; LC 증가</strong></th>
											<td class="cb">사업의 정체로 영업이익의 개선이 없으나, 통제활동 부실로 손실사건 증가</td>
										</tr>
										<tr>
											<th scope="row"><strong>BIC 증가 &amp; LC 감소</strong></th>
											<td>영업 강화로 사업규모 확대 및 영업이익이 개선되고, 통제활동의 강화로 손실사건 축소</td>
										</tr>
										<tr>
											<th scope="row"><strong>BIC 증가 &amp; LC 변화미미</strong></th>
											<td>영업 강화로 사업규모 확대 및 영업이익이 개선되었으나, 적절한 통제활동으로 손실사건 증가 없음</td>
										</tr>
										<tr>
											<th scope="row"><strong>BIC 증가 &amp; LC 증가</strong></th>
											<td>영업 강화로 사업규모 확대 및 영업이익이 개선되었으나, 적극적 통제활동 부재로 손실사건 규모도 증가</td>
										</tr>
									</tbody>
								</table>
							</div>
						</article>
					</section>

				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-close" onclick="modalGuide_close();">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close" onclick="modalGuide_close();"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
		
	<!-- tip //-->	
	<script>
		$("input:text[numberOnly]").on("keyup", function(){
			$(this).val($(this).val().replace(/[^0-9.-]/g,""));
		});
	</script>
</body>
</html>