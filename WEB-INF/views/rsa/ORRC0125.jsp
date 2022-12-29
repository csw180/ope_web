<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0125.jsp
 Program name : 손실사건-리스크사례 매핑현황 조회
 Description  : 화면정의서 RCSA-17
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
Vector lshpFormCLst = CommUtil.getCommonCode(request, "LSHP_FORM_C");
if(lshpFormCLst==null) lshpFormCLst = new Vector();

Vector lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC");
if(lshpDczStsDscTempLst==null) lshpDczStsDscTempLst = new Vector();

String lshpC = "";
String lshpNm = "";
for(int i=0;i<lshpDczStsDscTempLst.size();i++){
	HashMap hMap = (HashMap)lshpDczStsDscTempLst.get(i);
	if( i > 0 ){
		lshpC += "|";
		lshpNm += "|";
	}
	lshpC += (String)hMap.get("intgc");
	
	lshpNm += (String)hMap.get("intg_cnm");
}

%>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	
<script language="javascript">
		$(document).ready(function(){
			initIBSheet();
			doAction("search");
		});

		// mySheet
		function initIBSheet() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "사건번호|사건번호",										Type: "Text",	SaveName: "lshp_amnno",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "발생부서|발생부서",										Type: "Text",	SaveName: "ocu_brnm",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:0},
				{ Header: "사건제목|사건제목",										Type: "Text",	SaveName: "lss_tinm",	Align: "Left",		Width: 10,	MinWidth: 200 ,Edit:0},
				{ Header: "일자|발생일자",										Type: "Text",	SaveName: "ocu_dt",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "일자|등록일자",										Type: "Text",	SaveName: "reg_dt",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "금액|총손실금액",										Type: "Text",	SaveName: "ttls_am",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "금액|순손실금액",										Type: "Text",	SaveName: "guls_am",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "손실사건 등록\n결재 진행단계|손실사건 등록\n결재 진행단계",				Type: "Combo",	SaveName: "lshp_dcz_sts_dsc",ComboText:"<%=lshpNm%>", ComboCode:"<%=lshpC%>",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "연관\n리스크사례건수|연관\n리스크사례건수",						Type: "Text",	SaveName: "rel_cnt",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0 ,Hidden:true},
				{ Header: "연관\n리스크사례|연관\n리스크사례",							Type: "Html",	SaveName: "rel_cnt_pop",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "손실사건\n상세보기|손실사건\n상세보기",						Type: "Html",	SaveName: "lsspop",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:0},
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
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
			WP.setParameter("process_id", "ORRC012502");
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
 
			
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC012503");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

					break;
			
			    case "down2excel":
					
			      var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "손실-리스크사례 매핑 현황.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"0|1|3|5|7|9|10|11|12|13|14|15|16|18"} ;
				      mySheet.Down2Excel(params);

					break;
					
				case "mod":		//수정 팝업
					showLoadingWs();
					$("#winLossMod").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="los";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORLS010201";
					f.target = "ifrLossMod";
					f.submit();
					
					break;
			}
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
	
	function mySheet_OnRowSearchEnd(Row) {
		mySheet.SetCellText(Row,"lsspop",'<button class="btn btn-xs btn-default" type="button" onclick="lsspop(\''+mySheet.GetCellValue(Row,"lshp_amnno")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>');
		mySheet.SetCellText(Row,"rel_cnt_pop",'<u onclick="relPop('+mySheet.GetCellValue(Row,"lshp_amnno")+')">'+mySheet.GetCellValue(Row,"rel_cnt")+'</u>');
		if(mySheet.GetCellValue(Row,"rel_cnt")=="연결필요"){
			 mySheet.SetCellFontColor(Row,"rel_cnt_pop","RED") ;
		}
	}
	function lsspop(lshp_amnno) {
		$("#lshp_amnno").val(lshp_amnno);
		doAction('mod');
	}
	function relPop(lshp_amnno) {
		$("#lshp_amnno").val(lshp_amnno);
		$("#ifrRelLss").attr("src","about:blank");
		$("#winRelLss").show();
		showLoadingWs(); // 프로그래스바 활성화
		setTimeout(rellss,1);
	}
	
	function rellss(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC012601";
		f.target = "ifrRelLss";
		f.submit();
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
			<input type="hidden" id="lshp_amnno" name="lshp_amnno"/>
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>손실 사건 번호</th>
									<td>
										<input type="text" id="sch_lshp_amnno" name="sch_lshp_amnno" class="form-control w130" value="">
									</td>
									<th>일자</th>
									<td class="form-inline">
										<select class="form-control w120" id="dt_knd" name="dt_knd" onchange="set_dt_knd()">
												<option value="">전체</option>
												<option value="oc">사건발생일자</option>
												<option value="dc">사건발견일자</option>
												<option value="rg">사건등록일자</option>
												<option value="rg">사건종료일자</option>
												<option value="fa">최초회계처리일자</option>
												<option value="lc">최종변경일자</option>
										</select>
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
									</td>
									<th>손실 형태</th>
									<td>
										<select name="lshp_form_c" id="lshp_form_c" class="form-control w120">
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
									</td>
									<th>결재 진행단계<button class="btn-tip tipOpen" type="button" tip="tip"><span class="blind">Help</span></button></th>
									<td>
										<select name="" id="" class="form-control w120">
											<option value="">선택</option>
<%
			for(int i=0;i<lshpDczStsDscTempLst.size();i++){
				HashMap hMap = (HashMap)lshpDczStsDscTempLst.get(i);
%>
														<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
			}	
%>
										</select>
									</td>
								</tr>
								<tr>
									<th>발생 부서</th>
									<td class="form-inline">											
										<div class="input-group">
											<input type="hidden" id="ocu_brc" name="ocu_brc"/> 
											<input type="text" class="form-control w100" id="ocu_brnm" name="ocu_brnm" onKeyPress="EnterkeySubmitOrg('ocu_brnm', 'ocuOrgSearchEnd');" readonly>
											<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="ocu_brnm_btn" onclick="schOrgPopup('ocu_brnm', 'ocuOrgSearchEnd');"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
									<th>금액</th>
									<td class="form-inline">
										<select class="form-control w120" id="am_knd" name="am_knd" onchange="set_am_knd()">
											<option value="">선택</option>
											<option value="tl">총손실금액</option>
											<option value="bi">보험회수전순손실액</option>
											<option value="gl">순손실금액</option>
										</select>
										<div class="input-group">
												<input type="hidden" id="st_am" name="st_am"/> 
												<input type="text" class="form-control text-right" style="width:80px;" id="txt_st_am" name="txt_st_am" disabled> 
												<span class="input-group-addon">원 </span>
												<span class="input-group-addon"> ~ </span>
												<input type="hidden" id="ed_am" name="ed_am" />
												<input type="text" class="form-control text-right" style="width:80px;" id="txt_ed_am" name="txt_ed_am" disabled> 
												<span class="input-group-addon">원 </span>
										</div>
									</td>
									<th>손실 상태</th>
									<td>
										<select name="" id="" class="form-control w120">
											<option value="">선택</option>
											<option value=""></option>
										</select>
									</td>
									<th>리스크사례 연결여부</th>
									<td>
										<select name="sch_rel_yn" id="sch_rel_yn" class="form-control w120">
											<option value="">전체</option>
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>유관 부서</th>
									<td class="form-inline">											
										<div class="input-group">
											<input type="text" name="" id="" class="form-control w100" readonly>
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico search" onclick=""><i class="fa fa-search"></i><span class="blind">부서 선택</span></button>
											</span>
										</div>
									</td>
									<th>손실 사건 제목</th>
									<td>
										<input type="text" name="sch_lshp_tinm" id="sch_lshp_tinm" class="form-control w400">
									</td>
									<th>소송 발생 여부</th>
									<td>
										<select name="sch_law_yn" id="sch_law_yn" class="form-control w120">
											<option value="">전체</option>
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">					
					<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
				</div>
				
				<!-- tip -->
				<aside id="tip" class="tip-wrap">
					<article class="tip-inner">
						
						<table class="table-tip">
							<colgroup>
								<col style="width: 100px;">
								<col>
							</colgroup>
						<thead>
							<tr>
								<th scope="col">결재진행단계</th>
								<th scope="col">설명</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row">미작성</th>
								<td>대응방안을 작성하지 않은 상태</td>
							</tr>
							<tr>
								<th scope="row">작성중</th>
								<td>대응방안을 작성(저장)하였으나 부점장에게 결재 요청하지 않은 상태</td>
							</tr>
							<tr>
								<th scope="row">부점장 결재 중</th>
								<td>팀ORM담당자가 부점장에게 결재를 결재 요청하고 부점장이 결재를 완료하지 않은 상태</td>
							</tr>
							<tr>
								<th scope="row">ORM전담 결재 중</th>
								<td>부점장이 결재를 완료하고 ORM 전담 앞 결재를 결재 요청한 상태</td>
							</tr>
							<tr>
								<th scope="row">ORM팀장 결재 중</th>
								<td>ORM 전담이 결재를 완료하고 ORM 팀장 앞 결재를 결재 요청한 상태</td>
							</tr>
							<tr>
								<th scope="row">반려</th>
								<td>부점장/ORM전담/ORM팀장이 반려한 상태</td>
							</tr>
							<tr>
								<th scope="row">승인</th>
								<td>ORM 팀장이 결재하여 최종 승인한 상태</td>
							</tr>
						</tbody>
						</table>
					</article>
				</aside>
				<!-- tip //-->
			</div>
			<!-- 조회 //-->
			

			<section class="box box-grid">
				<div class="box-header">
					<div class="area-term">
						<span class="tit">전체 : </span>
						<span class="em" ><strong id="tot_cnt_lss"></strong>건</span>
						<span class="div">/</span>
						<span class="tit" >연결완료 : </span>
						<span class="em"><strong id="tot_cmp_lss">5,097</strong>건</span>
						<span class="div">/</span>
						<span class="tit" >미연결 : </span>
						<span class="em"><strong id="tot_ncmp_lss">3</strong>건</span>
					</div>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="wrap-grid h450">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
			</form>
		</div>
		<!-- content //-->
	<div id="winRelLss" class="popup modal">
		<iframe name="ifrRelLss" id="ifrRelLss" src="about:blank"></iframe>
	</div>
		
	</div>	
	<div id="winLossMod" class="popup modal">
		<iframe name="ifrLossMod" id="ifrLossMod" src="about:blank"></iframe>
	</div>
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	<%@ include file="../comm/EmrkInfP.jsp" %> <!-- 이머징리스크유형 공통 팝업 -->
	<script>
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
		// 발생부서 완료
		function ocuOrgSearchEnd(brc, brnm){
			$("#ocu_brc").val(brc);
			$("#ocu_brnm").val(brnm);
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
		

		// 원인유형검색 완료
		var CAS3_ONLY = true; 
		var CUR_CAS_TPC = "";
		
		function cas_popup(){
			CUR_CAS_TPC = $("#cas_tpc").val();
			schCasPopup();
		}
		
		function casSearchEnd(cas_tpc, cas_tpnm
							, cas_tpc_lv1, cas_tpnm_lv1
							, cas_tpc_lv2, cas_tpnm_lv2){
			$("#cas_tpc").val(cas_tpc);
			$("#cas_tpnm").val(cas_tpnm);
			
			$("#winCas").hide();
			//doAction('search');
		}
		
		function cas_remove(){
			$("#cas_tpc").val("");
			$("#cas_tpnm").val("");
		}

		
		// 영향유형검색 완료
		var IFN2_ONLY = true;
		var CUR_IFN_TPC = "";

		function ifn_popup() {
			CUR_IFN_TPC = $("#ifn_tpc").val();
			if (ifrIfn.cur_click != null) ifrIfn.cur_click();
			schIfnPopup();
		}

		function ifnSearchEnd(ifn_tpc, ifn_tpnm, ifn_tpc_lv1, ifn_tpnm_lv1) {
			$("#ifn_tpc").val(ifn_tpc);
			$("#shw_ifn_tpnm").val(ifn_tpnm);

			$("#winIfn").hide();
			//doAction('search');
		}
		
		// 이머징리스크유형검색 완료
		var EMRK2_ONLY = true;
		var CUR_EMRK_TPC = "";
	
		function emrk_popup() {
			CUR_EMRK_TPC = $("#emrk_tpc").val();
			schEmrkPopup();
		}
	
		function emrkSearchEnd(emrk_tpc, emrk_tpnm, emrk_tpc_lv1, emrk_tpnm_lv1) {
			$("#emrk_tpc").val(emrk_tpc);
			$("#shw_emrk_tpnm").val(emrk_tpnm_lv1 + " > " + emrk_tpnm);
	
			$("#winEmrk").hide();
			//doAction('search');
		}
	
		function emrk_remove() {
			$("#emrk_tpc").val("");
			$("#shw_emrk_nm").val("");
		}
		// 측정대상손실사건조회 완료
		
		//var BIZ2_ONLY = true; 
		//var CUR_BIZ_TPC = "";
		$(document).ready(function(){
			
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
			
	</script>



</body>
</html>