<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0124.jsp
 Program name : 손실/KRI 매핑현황 조회
 Description  : 화면정의서 RCSA-16
 Programer    : 박승윤
 Date created : 2022.09.26
 ---------------------------------------------------------------------------*/
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/library.jsp" %>

<%

response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");
DynaForm form = (DynaForm)request.getAttribute("form");
String today_date = CommUtil.getResultString(request, "grp01", "unit01", "today_date");


%>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	
<script language="javascript">
		$(document).ready(function(){
			initIBSheet();
		});

		// mySheet
		function initIBSheet() {
			var initdata = {};
			initdata.Cfg = {FrozenCol:0,Sort:1,MergeSheet:msBaseColumnMerge + msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{ Header: "구분|구분",						Type: "Text",	SaveName: "hofc_bizo_dsnm",	Align: "Center",	Width: 10,	MinWidth: 80 , ColMerge:1,Edit:0},
				{ Header: "업무프로세스|Lv1",					Type: "Text",	SaveName: "prssnm1",	Align: "Left",		Width: 10,	MinWidth: 150, ColMerge:1,Edit:0 },
				{ Header: "업무프로세스|Lv2",					Type: "Text",	SaveName: "prssnm2",	Align: "Left",		Width: 10,	MinWidth: 150, ColMerge:1,Edit:0 },
				{ Header: "RCSA 개수|RCSA 개수",			Type: "Text",	SaveName: "rkp_cnt",	Align: "Center",	Width: 10,	MinWidth: 50, ColMerge:0,Edit:0 },
				{ Header: "연결 손실사건 건수|연결 손실사건 건수",		Type: "Text",	SaveName: "lss_cnt",	Align: "Center",	Width: 10,	MinWidth: 50 , ColMerge:0,Edit:0},
				{ Header: "연관 KRI 개수|연관 KRI 개수",			Type: "Text",	SaveName: "kri_cnt",	Align: "Center",	Width: 10,	MinWidth: 50, ColMerge:0,Edit:0 },
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
			doAction("search");
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {

			switch(sAction) {
			
			case "search":  //데이터 조회
					
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012402");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

					  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					 var rList = result.DATA;  
					if(rList.length>0){                                  
					$("#tot_cnt_lss").text(rList[0].tot_cnt_lss);
					$("#tot_cmp_lss").text(rList[0].tot_cmp_lss);
					$("#tot_ncmp_lss").text(rList[0].tot_ncmp_lss);
					$("#avg_lss_cnt").text(rList[0].avg_lss_cnt);

					}
					
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
 
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012403");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

					  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					 var rList = result.DATA;  
					if(rList.length>0){                                  
					$("#tot_cnt_kri").text(rList[0].tot_cnt_kri);
					$("#tot_cmp_kri").text(rList[0].tot_cmp_kri);
					$("#tot_ncmp_kri").text(rList[0].tot_ncmp_kri);
					$("#avg_kri_cnt").text(rList[0].avg_kri_cnt);

					}
					
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
					
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC012404");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

					break;
			
			    case "down2excel":
					
			      var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "손실/KRI 매핑현황 조회.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"0|1|3|5|7|9|10|11|12|13|14|15|16|18"} ;
				      mySheet.Down2Excel(params);

					break;
			
			}
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
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>기준일</th>
									<td>
										<input type="text" id="today_date" class="form-control w100" value="<%=today_date%>" readonly>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">					
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search')">조회</button>
				</div>
			</div>
			<!-- 조회 //-->
			

			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">손실사건-리스크사례 연결현황 요약</h2>
				</div>
				<div class="wrap-table">
					<table>
						<thead>
							<tr>
								<th scope="col">총 손실사건 건수</th>
								<th scope="col">리스크사례 연결 완료 손실사건 건수</th>
								<th scope="col">리스크사례 미연결 손실사건 건수</th>
								<th scope="col">손실사건 당 평균 리스크사례 개수</th>
							</tr>
						</thead>
						<tbody class="center">
							<tr>
								<td>
									<strong id="tot_cnt_lss"></strong>건
								</td>
								<td>
									<strong id="tot_cmp_lss"></strong>건
								</td>
								<td>
									<strong id="tot_ncmp_lss"></strong>건
									<div class="td-btn-wrap">
										<button type="button" class="btn btn-more" onclick="javascript:parent.menuTrigger('0002502');"><span class="txt">상세</span></button>
									</div>
								</td>
								<td>
									<strong id="avg_lss_cnt"></strong>개
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>

			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">KRI-리스크사례 연결현황 요약</h2>
				</div>
				<div class="wrap-table">
					<table>
						<thead>
							<tr>
								<th scope="col">총 KRI 지표 수</th>
								<th scope="col">리스크사례 연결 완료 KRI 개수</th>
								<th scope="col">리스크사례 미연결 KRI 개수</th>
								<th scope="col">KRI 지표 당 평균 리스크사례 개수</th>
							</tr>
						</thead>
						<tbody class="center">
							<tr>
								<td>
									<strong id="tot_cnt_kri">140</strong>건
								</td>
								<td>
									<strong id="tot_cmp_kri">139</strong>건
								</td>
								<td>
									<strong id="tot_ncmp_kri">1</strong>개
									<div class="td-btn-wrap">
										<button type="button" class="btn btn-more" onclick="javascript:parent.menuTrigger('0002503');"><span class="txt">상세</span></button>
									</div>
								</td>
								<td>
									<strong id="avg_kri_cnt"></strong>개
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>

			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">업무프로세스(Lv2)별 운영리스크 정보 요약</h2>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="wrap-grid h340">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
			</form>
		</div>
		<!-- content //-->
		
	</div>	




</body>
</html>