<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0130.jsp
 Program name : 디지털/비대면 리스크 관리
 Description  : 화면정의서 RCSA-20
 Programer    : 박승윤
 Date created : 2022.08.17
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
<%
Vector vKrkSltBasLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vKrkSltBasLst==null) vKrkSltBasLst = new Vector();
Vector VRkpEvlScLst= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(VRkpEvlScLst==null) VRkpEvlScLst = new Vector();
DynaForm form = (DynaForm)request.getAttribute("form");
Vector vFqLst = CommUtil.getCommonCode(request, "RPT_FQ_DSC");
if(vFqLst==null) vFqLst = new Vector();

String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(","); 

String RkpTpc = "";
String RkpTpnm = "";


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<script>
		
		$(document).ready(function(){	
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "번호",			Type: "Text",	SaveName: "rpt_sqno",	Align: "Center",	Width: 10,	MinWidth: 40 ,Edit:0},
				{ Header: "보고서 구분",	Type: "Text",	SaveName: "rpt_dsnm",	Align: "Center",	Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "제목",			Type: "Text",	SaveName: "rpt_tinm",	Align: "Left",		Width: 10,	MinWidth: 400 ,Edit:0},
				{ Header: "상세",			Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:0},
				{ Header: "등록일",		Type: "Text",	SaveName: "reg_dt",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "첨부파일",		Type: "Button",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 200,	ClassName:"Text",Edit:0 }, 	// 첨부파일 1개 Type: Button 사용시
				//{ Header: "첨부파일",		Type: "HTML",	SaveName: "",	Align: "Left",		Width: 10,	MinWidth: 200}, 	// 첨부파일 여러개
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
		}
		
		function mySheet_OnRowSearchEnd (Row) {
			 if(mySheet.GetCellValue(Row,"evl_obj_yn")=="Y"){
				mySheet.SetCellFontColor(Row,"evl_obj_yn","GREEN");
			} else if(mySheet.GetCellValue(Row,"evl_obj_yn")=="N"){
				mySheet.SetCellFontColor(Row,"evl_obj_yn","RED");
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
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC013002");

					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "add":		//신규등록 팝업
					$("#mode").val("I");
					showLoadingWs();
					$("#winRpt").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="rsa";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORRC013101";
					f.target = "ifrRpt";
					f.submit();
					
					
					
					break;

				case "down2excel":
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "RCSA 중요리스크 선정.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"1|4|6|8|10|12|14|16|17|18|19|20|21"} ;
					mySheet.Down2Excel(params);

					break;

			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			if(Row >= mySheet.GetDataFirstRow()){
				if(Col != 0){
					if(mySheet.GetCellValue(Row,"ischeck") == "0"){
						mySheet.SetCellValue(Row,"ischeck","1");
					}else if(mySheet.GetCellValue(Row,"ischeck") == "1"){
						mySheet.SetCellValue(Row,"ischeck","0");
					}
				}
			}
		}
		
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet.FitColWidth();
			}
			//$("#kbr_nm").trigger("focus");
		}
		






		


		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction("search");
				return true;
			}else{
				return true;
			}
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
		<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>등록일자</th>
									<td class="form-inline">
										<div class="input-group">
											<input type="text" id="date01" class="form-control w90" value="2022-01-01" readonly>
											<span class="input-group-btn">
												<button class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd', 'date01')"><i class="fa fa-calendar"></i><span class="blind">날짜선택</span></button>
											</span>
										</div>
										<div class="input-group-addon"> ~ </div>
										<div class="input-group">
											<input type="text" id="date02" class="form-control w90" value="2022-01-01" readonly>
											<span class="input-group-btn">
												<button class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd', 'date02')"><i class="fa fa-calendar"></i><span class="blind">날짜선택</span></button>
											</span>
										</div>
									</td>
									<th>보고서구분</th>
									<td>
										<select name="" id="" class="form-control w120">
											<option value="">전체</option>
											<option value="">디지털리스크</option>
											<option value="">비대면리스크</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>보고서제목</th>
									<td colspan="3">
										<input type="text" name="" id="" class="form-control w100p">
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
			

			<section class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('add');"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
					</div>
				</div>
				<div class="wrap-grid h540">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
			</form>
		</div>
		<!-- content //-->
		
		<!-- [D] IBSheet 첨부파일 : 파일 다운로드 버튼 예시(첨부파일 여러개일 경우 사용)  -->
		<!-- [D] 버튼에 파일아이콘 이미지 표시 안될 경우 btnFileCss(); 함수 실행 -->
<!-- 		<button type="button" class="btn btn-file" title="directory/filename.xls" onclick=""><i class="ico"></i></button>
		<button type="button" class="btn btn-file" title="directory/filename.doc" onclick=""><i class="ico"></i></button -->>
		
	
	<div id="winRpt" class="popup modal">
		<iframe name="ifrRpt" id="ifrRpt" src="about:blank"></iframe>
	</div>

	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").addClass("block");
			});
			//닫기
			$(".btn-close").click( function(){
				$(".popup").removeClass("block");
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				//$(".popup").removeClass("block");
			});
		});
	</script>
</body>
</html>