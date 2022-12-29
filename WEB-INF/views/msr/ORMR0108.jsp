<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0108.jsp
 Program name : 손실요소(LC) 산출
 Description  : MSR-10
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>측정대상 손실사건 조회(공통)</title>
	<script>
		
		$(document).ready(function(){
			
			// 멀티셀렉스 체크박스 .mS01 손실상태
			$(document).bind('click', function(e) {
				var $clicked = $(e.target);
				if (!$clicked.parents().hasClass("dropdown")) $(".dropdown.mS01 dd ul").hide();
			});
			
			$('#sch_lshp_stsc_all').on('change', function() {
				var flag = false;
				if($('#sch_lshp_stsc_all').is(":checked")) flag = true;

				for(var i=0;i<4;i++){
					$("form[name=ormsForm] [name=sch_lshp_stsc]:eq("+i+")").prop("checked",flag);
				}

			});
			
			$('.mS01 .mutliSelect input[type="checkbox"]').on('click', function() {

				var title = $(this).closest('.mS01 .mutliSelect').find('input[type="checkbox"]').val(),
				    title = $(this).val() + " ";
					
				$('.mS01 .multiSel').html("");
				var check_cnt = 0;
				for(var i=0;i<4;i++){
					if($("form[name=ormsForm] [name=sch_lshp_stsc]:eq("+(i)+")").is(":checked")){
						check_cnt++;
						var html = '<span title="' + title + '">' + $("form[name=ormsForm] [name=sch_lshp_stsc]:eq("+(i)+")").parent().children("label").html() + '</span>';
						$('.mS01 .multiSel').append(html);
					}
				}

				if(check_cnt==4){
					$('#sch_lshp_stsc_all').prop("checked",true);
					$(".mS01 .multiSel").hide();
					$(".mS01 .hida").show();
				}else{
					$('#sch_lshp_stsc_all').prop("checked",false);
					$(".mS01 .hida").hide();
					$(".mS01 .multiSel").show();
				}
				
				/* if ($(this).is(':checked')) {
					$(".mS01 .hida").hide();
				} else {
					var ret = $(".mS01 .hida");
					$('.dropdown.mS01 dt a').append(ret);
				} */
			});

			// ibsheet 초기화
			initIBSheet();
			initIBSheet2();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			var initdata = {};
			initdata.Cfg = { "SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5};
			initdata.Cols = [
				{ Header: "산출기준",						Type: "Text",	SaveName: "rgo_in_dsnm",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:false},
				{ Header: "산출기준",						Type: "Text",	SaveName: "rgo_in_dsc",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:false, Hidden: true},
				{ Header: "사건발생법인",					Type: "Text",	SaveName: "sbdr_cnm",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:false},
				{ Header: "사건발생법인",					Type: "Text",	SaveName: "sbdr_c",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:false, Hidden: true},
				{ Header: "측정반영대상\n손실사건 건수",		Type: "Text",	SaveName: "cnt",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:false},
				{ Header: "총 손실금액 합계",				Type: "Int",	SaveName: "py_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "총 회수금액 합계",				Type: "Int",	SaveName: "rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "보험회수금액 합계",				Type: "Int",	SaveName: "isr_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "총비용",						Type: "Int",	SaveName: "cost_py_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "보험전 순손실금액 합계",			Type: "Int",	SaveName: "guls1_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "순손실금액 합계",					Type: "Int",	SaveName: "guls2_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "연평균 순손실금액",				Type: "Int",	SaveName: "year_avg",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "LC",							Type: "Int",	SaveName: "lc_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "상세 손실사건 조회",				Type: "Html",	SaveName: "det_btn",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:false}
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetCountPosition(0);
			mySheet.SetSelectionMode(4);
		}

		// mySheet2
		function initIBSheet2() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "손실사건\n관리번호",	Type: "Text",	SaveName: "lshp_amnno",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:false},
				{ Header: "사건발생법인",		Type: "Text",	SaveName: "sbdr_c",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:false, Hidden: true},
				{ Header: "사건발생법인",		Type: "Text",	SaveName: "sbdr_cnm",Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:false},
				{ Header: "발생부점",			Type: "Text",	SaveName: "ocu_brc",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:false},
				{ Header: "손실상태",			Type: "Text",	SaveName: "lshp_stsc",	Align: "Center",	Width: 10,	MinWidth: 80,Edit:false , Hidden: true},
				{ Header: "손실상태",			Type: "Text",	SaveName: "lshp_stsnm",	Align: "Center",	Width: 10,	MinWidth: 80,Edit:false },
				{ Header: "손실사건명",			Type: "Text",	SaveName: "lss_tinm",	Align: "Left",		Width: 10,	MinWidth: 200 ,Edit:false},
				{ Header: "최초회계처리일자",	Type: "Text",	SaveName: "acg_prc_dt",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:false},
				{ Header: "최종변경일자",		Type: "Text",	SaveName: "lschg_dtm",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:false  ,Format:"Ymd"},
				{ Header: "총손실금액",			Type: "Int",	SaveName: "py_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false ,Format:"#,###"},
				{ Header: "총회수금액",			Type: "Int",	SaveName: "rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false ,Format:"#,###"},
				{ Header: "보험회수금액",		Type: "Int",	SaveName: "isr_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false ,Format:"#,###"},
				{ Header: "총비용",				Type: "Int",	SaveName: "cost_py_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false ,Format:"#,###"},
				{ Header: "보험전순손실금액",	Type: "Int",	SaveName: "guls1_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false ,Format:"#,###"},
				{ Header: "순손실금액",			Type: "Int",	SaveName: "guls2_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false ,Format:"#,###"},
			];
			IBS_InitSheet(mySheet2, initdata);
			mySheet2.SetSelectionMode(4);
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
					var sch_bas_yy = $("#sch_bas_yy").val(); //조회년도
					var sch_bas_qq = $("#sch_bas_qq").val(); //조회분기(월)
					$("#sch_bas_ym").val(sch_bas_yy+""+sch_bas_qq); //조회년월 (YYYYMM)
					
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010802");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					/* $("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010803");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt); */
			
					break;
				case "search_det":
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010803");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "save":
					save();
					break;
					
				case "down2excel":
					setExcelFileName("손실사건 상세 정보.xlsx");
					setExcelDownCols("0|2|3|5|6|7|8|9|10|11|12|13");
					mySheet2.Down2Excel(excel_params);
	
					break;
			}
		}
		function save(){
			
			var f = document.ormsForm;
			var sch_bas_yy = $("#sch_bas_yy").val(); //조회년도
			var sch_bas_qq = $("#sch_bas_qq").val(); //조회분기(월)
			$("#sch_bas_ym").val(sch_bas_yy+""+sch_bas_qq); //조회년월 (YYYYMM)
			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "msr");
			WP.setParameter("process_id", "ORMR010804");

			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

						
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("저장 하였습니다.");
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						//parent.goSavEnd();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
		
		function mySheet_OnRowSearchEnd (Row) {
			mySheet.SetCellText(Row,"det_btn",'<button class="btn btn-xs btn-default" type="button" onclick="mySheet_result_search('+mySheet.GetCellValue(Row,"sbdr_c")+')"<span class="txt mr10">상세조회</span><i class="fa fa-angle-right"></i></button>');
		}
		function mySheet_result_search(sbdr_c){
			var Row = getRow(mySheet,"sbdr_c",sbdr_c);
			$("#sch_sbdr_c").val(mySheet.GetCellValue(Row,"sbdr_c")); //사건발생법인
			$("#sch_rgo_in_dsc").val(mySheet.GetCellValue(Row,"rgo_in_dsc")); //산출기준
			doAction('search_det');
		}
		function getRow(sheet,key,value) {
			for(var j=sheet.GetDataFirstRow(); j<=sheet.GetDataLastRow(); j++){
				if(sheet.GetCellValue(j,key)==value){
					return j;
				}
			}
		}
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
				return true;
			}else{
				return true;
			}
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
			
			<input type="hidden" id="sch_lshp_stsc1" name="sch_lshp_stsc1" /> <!-- 손실상태 -->
			<input type="hidden" id="sch_lshp_stsc2" name="sch_lshp_stsc2" />
			<input type="hidden" id="sch_lshp_stsc3" name="sch_lshp_stsc3" />
			<input type="hidden" id="sch_lshp_stsc4" name="sch_lshp_stsc4" />
			<input type="hidden" id="sch_sbdr_c" name="sch_sbdr_c" />
			<input type="hidden" id="sch_rgo_in_dsc" name="sch_rgo_in_dsc" />
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>연도 선택</th>
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
					<div class="btn-wrap">
						<button type="button" class="btn btn-default btn-xs" onclick="modalGuide_open();"><i class="fa fa-question-circle"></i><span class="txt">Help</span></button>
					</div>
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div>
			<!-- //조회 -->


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">요약정보</h2>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('save')"><i class="fa fa-save"></i><span class="txt">산출값저장</span></button>
					</div>
				</div>
				<div class="wrap-grid h210">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">상세정보</h2>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="wrap-grid h320">
					<script> createIBSheet("mySheet2", "100%", "100%"); </script>
				</div>
			</section>
		</form>
		</div>
		<!-- content //-->
	</div>
	
	<!-- tip -->
	<article id="modalGuide" class="popup modal">
		<div class="p_frame w600">	
			<div class="p_head">
				<h3 class="title">손실요소(LC) 산출 가이드라인</h3>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				
					<section class="box box-grid">
						<div class="box-header">
							<h4 class="box-title">측정반영대상 손실사건 기준</h4>
						</div>
						<div class="wrap-table">
							<table>
								<tbody class="center">
									<tr>
										<th class="w120">순손실금액</th>
										<td>규제자본 : 2,500만원 이상<br>내부자본 : 100만원 이상</td>
									</tr>
									<tr>
										<th>신용RWA반영여부</th>
										<td>N</td>
									</tr>
									<tr>
										<th>손실형태</th>
										<td>재무손실</td>
									</tr>
									<tr>
										<th>손실상태</th>
										<td>손실 확정, 계류손실</td>
									</tr>
									<tr>
										<th>기준시점</th>
										<td>최초회계처리일자 기준 10년 이내</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
				
					<section class="box box-grid">
						<div class="box-header">
							<h4 class="box-title">LC 산식</h4>
						</div>
						<div class="alert alert-warning">
							<ul class="ullist">
								<li>
									<div class="math">
										<strong>LC</strong> = <strong>∑</strong> 측정반영대상 순손실금액 &divide; <strong>10</strong> &times; <strong>15</strong>
									</div>
								</li>
								<li>※ 단, 2022년 3Q 시점까지는 10년 연평균이 아닌 분기평균금액으로 적용한다.</li>
							</ul>
						</div>
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