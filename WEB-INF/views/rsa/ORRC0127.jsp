<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0127.jsp
 Program name : 손실사건-리스크사례 매핑현황 조회
 Description  : 화면정의서 RCSA-18
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
Vector vLst2= CommUtil.getCommonCode(request, "RKI_LVL_C"); // 리스크지표수준코드
if(vLst2==null) vLst2 = new Vector();

Vector vuntLst = CommUtil.getCommonCode(request, "RKI_UNT_C");
if(vuntLst==null) vuntLst = new Vector();

String untC = "";
String untNm = "";
for(int i=0;i<vuntLst.size();i++){
	HashMap hMap = (HashMap)vuntLst.get(i);
	if( i > 0 ){
		untC += "|";
		untNm += "|";
	}
	untC += (String)hMap.get("intgc");
	
	untNm += (String)hMap.get("intg_cnm");
}

Vector vrptFqLst = CommUtil.getCommonCode(request, "RPT_FQ_DSC");
if(vrptFqLst==null) vrptFqLst = new Vector();

String rptC = "";
String rptNm = "";
for(int i=0;i<vrptFqLst.size();i++){
	HashMap hMap = (HashMap)vrptFqLst.get(i);
	if( i > 0 ){
		rptC += "|";
		rptNm += "|";
	}
	rptC += (String)hMap.get("intgc");
	
	rptNm += (String)hMap.get("intg_cnm");
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
				{ Header: "평가부서|부서",					Type: "Text",	SaveName: "dept_brnm",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:0},
				{ Header: "평가부서|팀",						Type: "Text",	SaveName: "brnm",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:0},
				{ Header: "KRI ID|KRI ID",				Type: "Text",	SaveName: "oprk_rki_id",	Align: "Center",	Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "지표명|지표명",					Type: "Text",	SaveName: "oprk_rki_nm",	Align: "Left",		Width: 10,	MinWidth: 200 ,Edit:0},
				{ Header: "지표 목적|지표 목적",					Type: "Text",	SaveName: "rki_obv_cntn",	Align: "Left",		Width: 10,	MinWidth: 200 ,Edit:0},
				{ Header: "지표산식|지표산식",					Type: "Text",	SaveName: "rki_def_cntn",	Align: "Left",		Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "단위|단위",						Type: "Combo",	SaveName: "rki_unt_c",ComboText:"<%=untNm%>", ComboCode:"<%=untC%>"	,Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "수집주기|수집주기",					Type: "Combo",	SaveName: "rki_fq_dsc",ComboText:"<%=rptNm%>", ComboCode:"<%=rptC%>",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "전산KRI\n여부|전산KRI\n여부",		Type: "Text",	SaveName: "com_col_psb_yn",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "평가대상\n여부|평가대상\n여부",			Type: "Text",	SaveName: "kri_yn",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "연관\n리스크사례건수|연관\n리스크사례건수",	Type: "Text",	SaveName: "rel_cnt",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0 ,Hidden:true},
				{ Header: "연관\n리스크사례|연관\n리스크사례",		Type: "Html",	SaveName: "rel_cnt_pop",	Align: "Center",	Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "KRI\n상세보기|KRI\n상세보기",		Type: "Html",	SaveName: "kripop",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:0},
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
			WP.setParameter("process_id", "ORRC012702");
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
			removeLoadingWs();
 
			
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC012703");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

					break;
			
			    case "down2excel":
					
			      var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "KRI-리스크사례 매핑 현황.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"0|1|3|5|7|9|10|11|12|13|14|15|16|18"} ;
				      mySheet.Down2Excel(params);

					break;
					
				case "mod":		//수정 팝업
					showLoadingWs();
					$("#winKriMod").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="kri";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORKR010201";
					f.target = "ifrKriMod";
					f.submit();
					
					break;
			}
		}

	
	function mySheet_OnRowSearchEnd(Row) {
		mySheet.SetCellText(Row,"kripop",'<button class="btn btn-xs btn-default" type="button" onclick="kripop(\''+mySheet.GetCellValue(Row,"oprk_rki_id")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>');
		mySheet.SetCellText(Row,"rel_cnt_pop",'<u onclick="relPop(\''+mySheet.GetCellValue(Row,"oprk_rki_id")+'\')">'+mySheet.GetCellValue(Row,"rel_cnt")+'</u>');
		if(mySheet.GetCellValue(Row,"rel_cnt")=="연결필요"){
			 mySheet.SetCellFontColor(Row,"rel_cnt_pop","RED") ;
		}
	}
	function kripop(rki_id) {
		$("#rki_id").val(rki_id);
		doAction('mod');
	}
	function relPop(rki_id) {
		$("#rki_id").val(rki_id);
		$("#ifrRelKri").attr("src","about:blank");
		$("#winRelKri").show();
		showLoadingWs(); // 프로그래스바 활성화
		setTimeout(relkri,1);
	}
	
	function relkri(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC012801";
		f.target = "ifrRelKri";
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
			<input type="hidden" id="rki_id" name="rki_id"/>
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가부서</th>
										<td class="form-inline">											
											<div class="input-group">
											<input type="text" class="form-control w120" id="sch_jrdt_brnm" name="sch_jrdt_brnm" onKeyPress="EnterkeySubmitOrg('sch_jrdt_brnm', 'orgSearchEnd');" onKeyUp="delTxt();">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico search" onclick="schOrgPopup('sch_jrdt_brnm', 'orgSearchEnd');"><i class="fa fa-search"></i><span class="blind">부서 선택</span></button>
												</span>
											</div>
										</td>
										<th>평가 대상 여부</th>
										<td>
											<select class="form-control w100" id="sch_kri_yn" name="sch_kri_yn" >
												<option value="">전체</option>
											    <option value="Y">Y</option>
											    <option value="N">N</option>
											</select>
										</td>
										<th>전산여부</th>
										<td>
											<select class="form-control w100" id="sch_com_col_psb_yn" name="sch_com_col_psb_yn" >
												<option value="">전체</option>
											    <option value="Y">Y</option>
											    <option value="N">N</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>지표수준</th>
										<td>
											<select class="form-control w150"  id="sch_rki_lvl_c" name="sch_rki_lvl_c">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
%>
										   		<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>	
											</select>
										</td>
										<th>지표명</th>
										<td>
											<input type="text" class="form-control w200" id="sch_rkinm" name="sch_rkinm" value="" placeholder="지표명을 입력하여 주십시오" onkeypress="EnterkeySubmit(doAction, 'search');">
										</td>
									<th>리스크사례연결여부</th>
									<td>
										<select name="" id="" class="form-control w100">
											<option value="">전체</option>
											<option value="">연결완료</option>
											<option value="">미연결</option>
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
			</div>
			<!-- 조회 //-->
			

			<section class="box box-grid">
				<div class="box-header">
					<div class="area-term">
						<span class="tit">전체 : </span>
						<span class="em" ><strong id="tot_cnt_kri"></strong>건</span>
						<span class="div">/</span>
						<span class="tit" >연결완료 : </span>
						<span class="em"><strong id="tot_cmp_kri">5,097</strong>건</span>
						<span class="div">/</span>
						<span class="tit" >미연결 : </span>
						<span class="em"><strong id="tot_ncmp_kri">3</strong>건</span>
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
	<div id="winRelKri" class="popup modal">
		<iframe name="ifrRelKri" id="ifrRelKri" src="about:blank"></iframe>
	</div>
		
	</div>	
	<div id="winKriMod" class="popup modal">
		<iframe name="ifrKriMod" id="ifrKriMod" src="about:blank"></iframe>
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