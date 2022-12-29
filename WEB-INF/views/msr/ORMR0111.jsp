<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0111.jsp
 Program name : 자본량 산출 내역 조회및 모니터링
 Description  : MSR-14
 Programer    : 이규탁
 Date created : 2022.07.27
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vRgoLst= CommUtil.getCommonCode(request, "RGO_IN_DSC");
if(vRgoLst==null) vRgoLst = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>내부 자본량 측정 결과 조회</title>
	<script>
		
		$(document).ready(function(){
			
			// ibsheet 초기화
			initIBSheet();
			
		});
		
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var title = new Array();
			var year = $('#sch_bas_yy').val(); //년도
			var month = $('#sch_bas_qq').val(); //분기
			var date = new Date(year, month-1, 1);
			
			
			/*조회년월 기준 이전 10개 분기 title 생성*/
			
			for(var i=0; i<13; i++){
				title[i] = date.getFullYear() + " " + Math.ceil((date.getMonth()+1)/3) + "Q";
				date.setMonth(date.getMonth()-3);
				
			}
			
			var initData = {};
			
			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};

			var headers = [{Text:"법인|구분|"+title[12]+"|"+title[11]+"|"+title[10]+"|"+title[9]+"|"+title[8]+"|"+title[7]+"|"+title[6]+"|"+title[5]+"|"+title[4]+"|"+title[3]+"|"+title[2]+"|"+title[1]+"|"+title[0], Align:"Center"}];
			
			initData.Cols = [
				{Type:"Text",Width:150,Align:"Center",SaveName:"gubun",MinWidth:100,Edit:false, Hidden:true, ColMerge:1},
				{Type:"Text",Width:150,Align:"Center",SaveName:"intg_grp_cnm",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c1",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c2",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c3",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c4",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c5",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c6",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c7",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c8",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c9",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c10",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c11",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c12",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c13",MinWidth:100,Edit:false}
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);
			
			mySheet.InitHeaders(headers);
			mySheet.SetMergeSheet(eval("msPrevColumnMerge + msHeaderOnly"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정s
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			 //그리드 헤더값이 연도에 따라 바뀌기 때문에 여기서 하면 스크립트 오류
		}
		
		
		var chart1_category = new Array();
		var chart1_BIC = new Array();
		var chart1_LC = new Array();
		var chart1_ORC = new Array();
		
		function chartDraw_1(){
			myChart_1.RemoveAll();
			myChart_1.SetOptions(initChartType);
			myChart_1.SetOptions(msrMonitor_1, 1);
			myChart_1.SetSeriesOptions([
					{
						name : "ORC",
						data : [
							[chart1_category[0],	chart1_ORC[0]], 
							[chart1_category[1],	chart1_ORC[1]], 
							[chart1_category[2],	chart1_ORC[2]], 
							[chart1_category[3],	chart1_ORC[3]], 
							[chart1_category[4],	chart1_ORC[4]], 
							[chart1_category[5],	chart1_ORC[5]], 
							[chart1_category[6],	chart1_ORC[6]], 
							[chart1_category[7],	chart1_ORC[7]], 
							[chart1_category[8],	chart1_ORC[8]], 
							[chart1_category[9],	chart1_ORC[9]], 
							[chart1_category[10],	chart1_ORC[10]], 
							[chart1_category[11],	chart1_ORC[11]], 
							[chart1_category[12],	chart1_ORC[12]],
						],
					},
			], 1);
			myChart_1.SetXAxisOptions({
				Categories : chart1_category
			}, 1);
			
			myChart_1.Draw(); //what??
			chartTooltip1();
			
		}
		
		
		// Chart : 내부자본(자본량 산출 추이)
		
		var chart2_category = ["2019.1Q", "2019.2Q", "2019.3Q", "2019.4Q", "2020.1Q", "2020.2Q", "2020.3Q", "2020.4Q", "2021.1Q", "2021.2Q", "2021.3Q", "2021.4Q", "2022.1Q"];
		var chart2_BIC = [ 
			[ 11453776496, 13420493139, 14280989290, 14860791870, 16050585435, 17133746304, 18213931471, 10098937060, 10973192656, 11985523213, 13429496973, 15151479246, 16852766580 ],
			[ 21453776496, 23420493139, 24280989290, 24860791870, 26050585435, 27133746304, 28213931471, 20098937060, 20973192656, 21985523213, 23429496973, 25151479246, 26852766580 ],
			[ 31453776496, 33420493139, 34280989290, 34860791870, 36050585435, 37133746304, 38213931471, 30098937060, 30973192656, 31985523213, 33429496973, 35151479246, 36852766580 ]
		];
		var chart2_LC = [ 
			[ 1190799452, 1121922550, 1182090027, 11356739166, 11163058505, 1124289888, 11402138494, 11563631037, 11156248278, 11948955679, 11111624359, 11642801460, 11917021314 ],
			[ 2290799452, 2221922550, 2282090027, 22356739166, 22163058505, 2224289888, 22402138494, 22563631037, 22156248278, 22948955679, 22111624359, 22642801460, 22917021314 ],
			[ 3390799452, 3321922550, 3382090027, 33356739166, 33163058505, 3324289888, 33402138494, 33563631037, 33156248278, 33948955679, 33111624359, 33642801460, 33917021314 ]
		];
		var chart2_ORC = new Array();
			
		function chartDraw_2(){
			
			myChart_2.RemoveAll();
			myChart_2.SetOptions(initChartType);
			myChart_2.SetOptions(msrMonitor_1, 1);
			myChart_2.SetOptions(msrMonitor_2, 1);
			
			myChart_2.SetSeriesOptions([
					{
						name : "은행",
						data : [
							[chart2_category[0],	chart2_ORC[0][0]], 
							[chart2_category[1],	chart2_ORC[0][1]], 
							[chart2_category[2],	chart2_ORC[0][2]], 
							[chart2_category[3],	chart2_ORC[0][3]], 
							[chart2_category[4],	chart2_ORC[0][4]], 
							[chart2_category[5],	chart2_ORC[0][5]], 
							[chart2_category[6],	chart2_ORC[0][6]], 
							[chart2_category[7],	chart2_ORC[0][7]], 
							[chart2_category[8],	chart2_ORC[0][8]], 
							[chart2_category[9],	chart2_ORC[0][9]], 
							[chart2_category[10],	chart2_ORC[0][10]], 
							[chart2_category[11],	chart2_ORC[0][11]], 
							[chart2_category[12],	chart2_ORC[0][12]],
						],
					},
					{
						name : "미얀마",
						data : [
							[chart2_category[0],	0], 
							[chart2_category[1],	chart2_ORC[1][1]], 
							[chart2_category[2],	chart2_ORC[1][2]], 
							[chart2_category[3],	chart2_ORC[1][3]], 
							[chart2_category[4],	chart2_ORC[1][4]], 
							[chart2_category[5],	chart2_ORC[1][5]], 
							[chart2_category[6],	chart2_ORC[1][6]], 
							[chart2_category[7],	chart2_ORC[1][7]], 
							[chart2_category[8],	chart2_ORC[1][8]], 
							[chart2_category[9],	chart2_ORC[1][9]], 
							[chart2_category[10],	chart2_ORC[1][10]], 
							[chart2_category[11],	chart2_ORC[1][11]], 
							[chart2_category[12],	chart2_ORC[1][12]],
						],
					},
					{
						name : "그룹",
						data : [
							[chart2_category[0],	chart2_ORC[2][0]], 
							[chart2_category[1],	chart2_ORC[2][1]], 
							[chart2_category[2],	chart2_ORC[2][2]], 
							[chart2_category[3],	chart2_ORC[2][3]], 
							[chart2_category[4],	chart2_ORC[2][4]], 
							[chart2_category[5],	chart2_ORC[2][5]], 
							[chart2_category[6],	chart2_ORC[2][6]], 
							[chart2_category[7],	chart2_ORC[2][7]], 
							[chart2_category[8],	chart2_ORC[2][8]], 
							[chart2_category[9],	chart2_ORC[2][9]], 
							[chart2_category[10],	chart2_ORC[2][10]], 
							[chart2_category[11],	chart2_ORC[2][11]], 
							[chart2_category[12],	chart2_ORC[2][12]],
						],
					},
			], 1);
			
			myChart_2.SetXAxisOptions({
				Categories : chart2_category
			}, 1);
			console.log(chart2_ORC);
			myChart_2.Draw();
			chartTooltip2();
		}
		
		// Chart : 내부자본(당기 한도소진율)
		var chart3_category = ["은행", "미얀마", "그룹"];
		var chart3_1 = [0, 0, 0];
		var chart3_2 = [0, 0, 0];
		
		function chartDraw_3(){
			
			myChart_3.RemoveAll();
			myChart_3.SetOptions(initChartType);
			myChart_3.SetOptions(msrMonitor_3, 1);
			myChart_3.SetSeriesOptions([
					{
						name : "당 월 한도 소진율",
						data : [
 							[chart3_category[0],	chart3_1[0]], 
							[chart3_category[1],	chart3_1[1]], 
							[chart3_category[2],	chart3_1[2]],
						],
					},
					{
						name : "전 월 한도 소진율",
						data : [
 							[chart3_category[0],	chart3_2[0]],
							[chart3_category[1],	chart3_2[1]], 
							[chart3_category[2],	chart3_2[2]],
						],
					},
			], 1);
			
			myChart_3.SetXAxisOptions({
				Categories : chart3_category
			}, 1);
			
			
			myChart_3.Draw();
			
			for(var i=0; i<3; i++){
				var color = gridColor.primary;
				if( chart3_1[i] >= 85 && chart3_1[i] < 90 ){
					color = gridColor.yellow;
				}else if( chart3_1[i]  >= 90){
					color = gridColor.red;
				}
				$('.chart-msr-monitor3 .Hcharts-series:first-child rect').eq(i).css('fill', color);
			}
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
					var sch_bas_yy = $("#sch_bas_yy").val(); //조회년도
					var sch_bas_qq = $("#sch_bas_qq").val(); //조회분기(월)
					
					$("#sch_bas_ym").val(sch_bas_yy+""+sch_bas_qq); //조회년월 (YYYYMM)
					var rgo_in_dsc = $("#rgo_in_dsc").val();
					mySheet.RemoveAll();
					initIBSheet();
					rgo_change_func(rgo_in_dsc);
					
					//myChart2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt); 
					//myChartDraw2();
					break;
				case "chart":
					var rgo_in_dsc = $("#rgo_in_dsc").val();
					if(rgo_in_dsc == '1'){
						chartDraw_1();
					}else if(rgo_in_dsc == '2'){
					}
					break;
				case "help":	//신표준 측정값 산출가이드라인 팝업
					$("#winHelp").show();
					
					break;
				case "reload":  //조회데이터 리로드
				
/* 					mySheet.RemoveAll();
					myChart.RemoveAll();
					myChart1.RemoveAll();
					myChart2.RemoveAll();
					initIBSheet();
					myChartDraw();
					myChartDraw1();
					myChartDraw2(); */
					break;
				case "down2excel_1":
					setExcelFileName("내부 자본량 측정 결과 조회.xlsx");
					setExcelDownCols("1|2|3|4|5|6|7|8|9|10");
					mySheet.Down2Excel(excel_params);
	
					break;
				case "down2excel_2":
					setExcelFileName("내부 자본량 측정 결과 조회.xlsx");
					setExcelDownCols("0|1|2|3|4|5|6|7|8|9|10");
					mySheet.Down2Excel(excel_params);
	
					break;
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {
			var rgo_in_dsc = $("#rgo_in_dsc").val();
			var year = $('#sch_bas_yy').val(); //년도
			var month = $('#sch_bas_qq').val(); //분기
			var date = new Date(year, month-1, 1);
			var f = document.ormsForm;
			
			var title = new Array();
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(rgo_in_dsc == '1'){
					chart1_BIC = [ mySheet.GetCellValue(5,"c1"), mySheet.GetCellValue(5,"c2"), mySheet.GetCellValue(5,"c3"), mySheet.GetCellValue(5,"c4"), mySheet.GetCellValue(5,"c5"), mySheet.GetCellValue(5,"c6"), mySheet.GetCellValue(5,"c7"), mySheet.GetCellValue(5,"c8"), mySheet.GetCellValue(5,"c9"), mySheet.GetCellValue(5,"c10"), mySheet.GetCellValue(5,"c11"), mySheet.GetCellValue(5,"c12"), mySheet.GetCellValue(5,"c13") ];
					chart1_LC = [ mySheet.GetCellValue(6,"c1"), mySheet.GetCellValue(6,"c2"), mySheet.GetCellValue(6,"c3"), mySheet.GetCellValue(6,"c4"), mySheet.GetCellValue(6,"c5"), mySheet.GetCellValue(6,"c6"), mySheet.GetCellValue(6,"c7"), mySheet.GetCellValue(6,"c8"), mySheet.GetCellValue(6,"c9"), mySheet.GetCellValue(6,"c10"), mySheet.GetCellValue(6,"c11"), mySheet.GetCellValue(6,"c12"), mySheet.GetCellValue(6,"c13") ];
					chart1_ORC = [  mySheet.GetCellValue(8,"c1"), mySheet.GetCellValue(8,"c2"), mySheet.GetCellValue(8,"c3"), mySheet.GetCellValue(8,"c4"), mySheet.GetCellValue(8,"c5"), mySheet.GetCellValue(8,"c6"), mySheet.GetCellValue(8,"c7"), mySheet.GetCellValue(8,"c8"), mySheet.GetCellValue(8,"c9"), mySheet.GetCellValue(8,"c10"), mySheet.GetCellValue(8,"c11"), mySheet.GetCellValue(8,"c12"), mySheet.GetCellValue(8,"c13")];
					for(var i=0; i<13; i++){
						title[i] = date.getFullYear() + " " + Math.ceil((date.getMonth()+1)/3) + "Q";
						
						date.setMonth(date.getMonth()-3);
					}
					chart1_category = [title[12], title[11], title[10], title[9], title[8], title[7], title[6], title[5], title[4], title[3], title[2], title[1], title[0]];
				}else if(rgo_in_dsc == '2'){
					chart2_ORC = [  [mySheet.GetCellValue(1,"c1"), mySheet.GetCellValue(1,"c2"), mySheet.GetCellValue(1,"c3"), mySheet.GetCellValue(1,"c4"), mySheet.GetCellValue(1,"c5"), mySheet.GetCellValue(1,"c6"), mySheet.GetCellValue(1,"c7"), mySheet.GetCellValue(1,"c8"), mySheet.GetCellValue(1,"c9"), mySheet.GetCellValue(1,"c10"), mySheet.GetCellValue(1,"c11"), mySheet.GetCellValue(1,"c12"), mySheet.GetCellValue(1,"c13")]
									,[mySheet.GetCellValue(4,"c1"), mySheet.GetCellValue(4,"c2"), mySheet.GetCellValue(4,"c3"), mySheet.GetCellValue(4,"c4"), mySheet.GetCellValue(4,"c5"), mySheet.GetCellValue(4,"c6"), mySheet.GetCellValue(4,"c7"), mySheet.GetCellValue(4,"c8"), mySheet.GetCellValue(4,"c9"), mySheet.GetCellValue(4,"c10"), mySheet.GetCellValue(4,"c11"), mySheet.GetCellValue(4,"c12"), mySheet.GetCellValue(4,"c13")]
									,[mySheet.GetCellValue(7,"c1"), mySheet.GetCellValue(7,"c2"), mySheet.GetCellValue(7,"c3"), mySheet.GetCellValue(7,"c4"), mySheet.GetCellValue(7,"c5"), mySheet.GetCellValue(7,"c6"), mySheet.GetCellValue(7,"c7"), mySheet.GetCellValue(7,"c8"), mySheet.GetCellValue(7,"c9"), mySheet.GetCellValue(7,"c10"), mySheet.GetCellValue(7,"c11"), mySheet.GetCellValue(7,"c12"), mySheet.GetCellValue(7,"c13")]
					];
					for(var i=0; i<13; i++){
						title[i] = date.getFullYear() + " " + Math.ceil((date.getMonth()+1)/3) + "Q";
						
						date.setMonth(date.getMonth()-3);
					}
					chart2_category = [title[12], title[11], title[10], title[9], title[8], title[7], title[6], title[5], title[4], title[3], title[2], title[1], title[0]];
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR011104");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					
					WP.load(url, inputData,{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="0") {
								var rList = result.DATA;
								if(rList.length>0){
									for (var i = 0; i < rList.length; i++){
										chart2_LC[0][i] = rList[i].bnk_lc;	
										chart2_LC[1][i] = rList[i].myn_lc;
										chart2_LC[2][i] = rList[i].grp_lc;
									}
									for (var i = 0; i < rList.length; i++){
										chart2_BIC[0][i] = rList[i].bnk_bic;	
										chart2_BIC[1][i] = rList[i].myn_bic;
										chart2_BIC[2][i] = rList[i].grp_bic;
									}
								}
								chartDraw_2();
							}else if(result!='undefined' && result.rtnCode!="0"){
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
					
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR011105");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					
					WP.load(url, inputData,{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="0") {
								var rList = result.DATA;
								if(rList.length>0){
									for (var i = 0; i < rList.length; i++){
										chart3_2[i] = parseFloat(rList[i].lmt_rto);
									}
									chart3_1[0] = parseFloat(mySheet.GetCellValue(3,"c13"));
									chart3_1[1] = parseFloat(mySheet.GetCellValue(6,"c13"));
									chart3_1[2] = parseFloat(mySheet.GetCellValue(9,"c13"));
								}
								chartDraw_3();
							}else if(result!='undefined' && result.rtnCode!="0"){
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
				}
			}
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			doAction('chart');
		}
		
		function rgo_change_func(rgo_in_dsc){
			if(rgo_in_dsc == '1')
				{
					var opt = {};
					mySheet.SetColHidden(0,1);
					$("#rgo_in_dsc_1").css("display","block");
					$("#rgo_in_dsc_2").css("display","none");
					$("#btn_excel_1").css("display","block");
					$("#btn_excel_2").css("display","none");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011102");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				}
			else if(rgo_in_dsc == '2')
				{
					
					mySheet.SetColHidden(0,0);
					
					
					$("#rgo_in_dsc_1").css("display","none");
					$("#rgo_in_dsc_2").css("display","block");
					$("#btn_excel_1").css("display","none");
					$("#btn_excel_2").css("display","block");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011103");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				}
		}
		function chartTooltip1(){
			var $el = $('.chart-msr-monitor1');
			$el.find('.Hcharts-series rect').on('mouseover', function(){
				var i = $(this).index();
				var bic = chart1_BIC[i].toLocaleString('ko-kr');
				var lc = chart1_LC[i].toLocaleString('ko-kr');
				var orc = chart1_ORC[i].toLocaleString('ko-kr');
				
				var html = "<div class='tooltip-box'>";
					html += "	<div class='chart-tooltip-header'>"+ chart1_category[i] +"</div>";
					html += "	<p class='chart-tooltip'>BIC : <strong>"+ bic +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>LC  : <strong>"+ lc +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>ORC : <strong>"+ orc +"</strong><span class='suffix'>원</span></p>";
					html += "</div>";
					
				$el.find('.Hcharts-container > .Hcharts-tooltip').attr('data', 'chart');
				$el.find('.Hcharts-tooltip[data] .tooltip-box').remove();
				$el.find('.Hcharts-tooltip[data]').append(html);
			})
		}
		
		function chartTooltip2(){
			var $el = $('.chart-msr-monitor2');
			$el.find('.Hcharts-series rect').on('mouseover', function(){
				var i = $(this).index();
				var j = $(this).parents('.Hcharts-series').index() / 2;
  		 	 	var bic = chart2_BIC[j][i].toLocaleString('ko-kr');
				var lc = chart2_LC[j][i].toLocaleString('ko-kr');
				var orc = chart2_ORC[j][i].toLocaleString('ko-kr');
				
				var color = "";
				var name = "";
				
				if(j == 0){
					color = "cb";
					name = "은행";
				}else if(j == 1){
					color = "cy";
					name = "미얀마";
				}else{
					color = "cg";
					name = "그룹";
				}
				
				var html = "<div class='tooltip-box'>";
					html += "	<div class='chart-tooltip-header'>"+ chart2_category[i] +"</div>";
					html += "	<div class='chart-tooltip-header "+ color +"'>"+ name +"</div>";
					html += "	<p class='chart-tooltip'>BIC : <strong>"+ bic +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>LC  : <strong>"+ lc +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>ORC : <strong>"+ orc +"</strong><span class='suffix'>원</span></p>";
					html += "</div>";
					
				$el.find('.Hcharts-container > .Hcharts-tooltip').attr('data', 'chart');
				$el.find('.Hcharts-tooltip[data] .tooltip-box').remove();
				$el.find('.Hcharts-tooltip[data]').append(html);
				 
			});
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
									<th>분기</th>
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
									<th>측정방법</th>
									<td>
										<div class="select">
											<select name="rgo_in_dsc" id="rgo_in_dsc" class="form-control">
<%
	for(int i=0;i<vRgoLst.size();i++){
		HashMap hMap = (HashMap)vRgoLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
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
				

			<!-- IBSheet -->
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">자본량 산출 추이</h2>
					<div class="area-tool" id="btn_excel_1" style="display:none">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel_1');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
					<div class="area-tool" id="btn_excel_2" style="display:none">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel_2');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="wrap-grid h350">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
			<!-- IBSheet //-->
			
			<section class="box box-grid">
				<div id="rgo_in_dsc_1" style="display:block">
					<div class="box-header">
						<h2 class="box-title">규제자본 시각화 모니터링</h2>
					</div>
					<div class="wrap-chart chart-msr-monitor1 h300">
						<script> createIBChart("myChart_1", "100%", "100%"); </script>
					</div>
					
				</div>
				<div id="rgo_in_dsc_2" style="display:none">
					<div class="box-header">
						<h2 class="box-title">내부자본 시각화 모니터링 (추이 및 한도소진율)</h2>
					</div>
					<div class="row">
						<article class="col w70p">
							<div class="box-header">
								<h3 class="title">자본량 산출 추이</h3>
							</div>
							<div class="wrap-chart chart-msr-monitor2 h300">
								<script> createIBChart("myChart_2", "100%", "100%"); </script>
							</div>
						</article>
						<article class="col w30p">
							<div class="box-header">
								<h3 class="title"> 당기 한도소진율</h3>
							</div>
							<div class="wrap-chart chart-msr-monitor3 h300">
								<script> createIBChart("myChart_3", "100%", "100%"); </script>
							</div>
						</article>
					</div>
				</div>
			</section>
		</form>
		</div>
		<!-- content //-->
	</div>
	
	<!-- popup -->
	<div id="winHelp" class="popup modal">
		<iframe name="ifrHelp" id="ifrHelp" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/msr/ORMR0109"></iframe>
	</div>
</body>
</html>