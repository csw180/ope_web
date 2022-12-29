<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0126.jsp
 Program name : 손실사건 리스크사례 연결등록
 Description  : 화면정의서 RCSA-17.1
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
Vector vFqLst = CommUtil.getCommonCode(request, "RPT_FQ_DSC");
if(vFqLst==null) vFqLst = new Vector();
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
%>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	
<script language="javascript">
		$(document).ready(function(){
			initIBSheet1();
			initIBSheet2();
			parent.removeLoadingWs();
			doAction("search");
			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("rsa");
			$("form[name=ormsForm] [name=process_id]").val("ORRC012603");
			mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		});

		// mySheet
		function initIBSheet1() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "선택|선택",						Type: "CheckBox",	SaveName: "ischeck",	Align: "Center",	Width: 10,	MinWidth: 30 ,Edit:1},
				{ Header: "리스크사례\nID|리스크사례\nID",		Type: "Text",		SaveName: "rkp_id",	Align: "Center",	Width: 10,	MinWidth: 70 ,Edit:0},
				{ Header: "평가부서|평가부서",					Type: "Text",		SaveName: "dept_brnm",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "팀|팀",						Type: "Text",		SaveName: "brnm",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "업무 프로세스|Lv1",				Type: "Text",		SaveName: "prssnm1",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "업무 프로세스|Lv2",				Type: "Text",		SaveName: "prssnm2",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "업무 프로세스|Lv3",				Type: "Text",		SaveName: "prssnm3",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "업무 프로세스|Lv4",				Type: "Text",		SaveName: "prssnm4",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "리스크 사례|리스크 사례",				Type: "Text",		SaveName: "rk_isc_cntn",	Align: "Left",		Width: 10,	MinWidth: 150 ,Edit:0},
				{ Header: "통제활동|통제활동",					Type: "Text",		SaveName: "cp_cntn",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "최초등록일|최초등록일",				Type: "Text",		SaveName: "reg_dt",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "최근변경일|최근변경일",				Type: "Text",		SaveName: "chg_dt",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "평가주기|평가주기",					Type: "Text",		SaveName: "rpt_fq_dscnm",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:0},
			];
			IBS_InitSheet(mySheet1, initdata);
			mySheet1.SetSelectionMode(4);
		}				

		// mySheet2
		function initIBSheet2() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "선택|선택",						Type: "CheckBox",	SaveName: "ischeck",	Align: "Center",	Width: 10,	MinWidth: 30 ,Edit:1},
				{ Header: "리스크사례\nID|리스크사례\nID",		Type: "Text",		SaveName: "rkp_id",	Align: "Center",	Width: 10,	MinWidth: 70 ,Edit:0},
				{ Header: "평가부서|평가부서",					Type: "Text",		SaveName: "dept_brnm",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "팀|팀",						Type: "Text",		SaveName: "brnm",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "업무 프로세스|Lv1",				Type: "Text",		SaveName: "prssnm1",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "업무 프로세스|Lv2",				Type: "Text",		SaveName: "prssnm2",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "업무 프로세스|Lv3",				Type: "Text",		SaveName: "prssnm3",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "업무 프로세스|Lv4",				Type: "Text",		SaveName: "prssnm4",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "리스크 사례|리스크 사례",				Type: "Text",		SaveName: "rk_isc_cntn",	Align: "Left",		Width: 10,	MinWidth: 150 ,Edit:0},
				{ Header: "통제활동|통제활동",					Type: "Text",		SaveName: "cp_cntn",	Align: "Left",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "최초등록일|최초등록일",				Type: "Text",		SaveName: "reg_dt",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "최근변경일|최근변경일",				Type: "Text",		SaveName: "chg_dt",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "평가주기|평가주기",					Type: "Text",		SaveName: "rpt_fq_dscnm",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:0},
			];
			IBS_InitSheet(mySheet2, initdata);
			mySheet2.SetSelectionMode(4);
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
			WP.setParameter("process_id", "ORRC012602");
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
					$("#sch_lshp_amnno").text(rList[0].lshp_amnno);
					$("#ocu_brnm").text(rList[0].ocu_brnm);
					$("#lss_tinm").text(rList[0].lss_tinm);
					$("#ocu_dt").text(rList[0].ocu_dt);
					$("#reg_dt").text(rList[0].reg_dt);
					$("#ttls_am").text(rList[0].ttls_am);
					$("#guls_am").text(rList[0].guls_am);

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
			$("form[name=ormsForm] [name=process_id]").val("ORRC010102");
			mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			


			break;
			
			    case "down2excel":
					
			      var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "손실-리스크사례 매핑 현황.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"0|1|3|5|7|9|10|11|12|13|14|15|16|18"} ;
				      mySheet.Down2Excel(params);

					break;

			}
		}
	
	function showcalendar(num){
		
			if(num==1)
			{
				$("#sch_reg_st_dt").val('');
				showCalendar('yyyy-MM-dd','sch_reg_st_dt');
			}
			else if(num==2)
			{
				$("#sch_reg_ed_dt").val('');
				showCalendar('yyyy-MM-dd','sch_reg_ed_dt');
			}
			else if(num==3)
			{
				$("#sch_chg_st_dt").val('');
				showCalendar('yyyy-MM-dd','sch_chg_st_dt');
			}
			else if(num==4)
			{
				$("#sch_chg_ed_dt").val('');
				showCalendar('yyyy-MM-dd','sch_chg_ed_dt');
			}
		
		}
		
		
function copyRkp(){
			ToSheet = mySheet2;
			FromSheet = mySheet1;
			//체크된 행이 있는지 찾아본다.
			var rows = FromSheet.FindCheckedRow("ischeck");
			//복사될 위치를 구한다.
			var ToRow = ToSheet.GetSelectRow();
			
			mySheet1.CheckAll("ischeck", 0);

			if(rows==""){
				//현재 포커스가 들어간 행을	이동시킨다.
				//var FromRow = FromSheet.GetSelectRow();
				//mySheet2_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow, 0,0, 0);
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				//체크된 행을 모두 복사.	
				var jsonArr = [];
				var rs = rows.split("|");
				
				//렌더링 일시 중지
				ToSheet.RenderSheet(false);
				
				//데이터 복사
				for(var i=0;i<rs.length;i++){
					var bAddFlag = true;
					
					for(var nCnt=mySheet2.GetDataFirstRow(); nCnt <= mySheet2.GetDataLastRow(); nCnt++){
						if( mySheet1.GetCellValue(rs[i],"rkp_id") == mySheet2.GetCellValue(nCnt,"rkp_id") ){
							bAddFlag = false;
							break;
						}
					}
					
					if( !bAddFlag )
						continue;
					
					var rowJson = FromSheet.GetRowData(rs[i]);
					ToSheet.SetRowData(ToRow+1, rowJson, {Add:1});
				}
				
				//렌더링 재가동
				ToSheet.RenderSheet(true);
				
				//원본 데이터 삭제
				//FromSheet.RowDelete(rows);
			}

		}
		
		function doSave() {
			
			mySheet2.CheckAll("ischeck", 1);
			mySheet2.DoSave(url, { Param : "method=Main&commkind=rsa&process_id=ORRC012604&lshp_amnno="+$("#lshp_amnno").val(), Col : 0 });
		}
		
		function removeRkp(){
			//체크된 행이 있는지 찾아본다.
			var rows = mySheet2.FindCheckedRow("ischeck");

			if(rows==""){
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				
				mySheet2.RowDelete(rows);
				
			}

		}
		
		function mySheet2_OnSaveEnd(code, msg) {
	    if(code >= 0) {
	    	parent.doAction('search');
			alert("저장 하였습니다.");
			$(".btn-close").trigger("click");
			$(".popup",parent.document).removeClass("block");  

	    } else {

	        alert(msg); // 저장 실패 메시지

	    }
	}


	</script>

</head>
<body>
    <!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w1200">	
			<div class="p_head">
				<h1 class="title">손실사건-리스크사례 연결등록</h1>
			</div>
			<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="lshp_amnno" name="lshp_amnno" value="<%=form.get("lshp_amnno")%>"/>
			<input type="hidden" id="rkp_id" name="rkp_id" value="" />
			<input type="hidden" id="sch_hd_bsn_prss_c" name="sch_hd_bsn_prss_c" />
			<input type="hidden" id="sch_hd_hpn_tpc" name="sch_hd_hpn_tpc" value="" />
			<input type="hidden" id="sch_hd_cas_tpc" name="sch_hd_cas_tpc" value="" />
			<input type="hidden" id="sch_hd_ifn_tpc" name="sch_hd_ifn_tpc" value="" />
			<input type="hidden" id="sch_hd_emrk_tpc" name="sch_hd_emrk_tpc" value="" />
			<div class="p_body">						
				<div class="p_wrap">
					
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">손실사건 개요</h2>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 100px;">
									<col style="width: 130px;">
									<col>
									<col style="width: 100px;">
									<col style="width: 100px;">
									<col style="width: 120px;">
									<col style="width: 120px;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col" rowspan="2">사건번호</th>
										<th scope="col" rowspan="2">발생부서</th>
										<th scope="col" rowspan="2">사건제목</th>
										<th scope="col" colspan="2">일자</th>
										<th scope="col" colspan="2">금액</th>
									</tr>
									<tr>
										<th scope="col">발생일자</th>
										<th scope="col">등록일자</th>
										<th scope="col">총손실금액</th>
										<th scope="col">순손실금액</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td id="sch_lshp_amnno"></td>
										<td id="ocu_brnm"></td>
										<td id="lss_tinm" class="left"></td>
										<td id="ocu_dt"></td>
										<td id="reg_dt"></td>
										<td id="ttls_am"></td>
										<td id="guls_am"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
					
					<section class="box">
						<div class="box-header">
							<h2 class="box-title">리스크사례 연결</h2>
						</div>

						<!-- 조회 -->
						<div class="box-search">
							<div class="box-body">
								<div class="wrap-search">
									<table>
										<tbody>
									<tr>
										<th scope="row"><label for="sch_hd_bsn_prss_c_nm" class="control-label">업무프로세스</label></th>
										<td class="form-inline"> 
											<div class="input-group">											
												<input type="text" class="form-control w90" id="sch_hd_bsn_prss_c_nm" name="sch_hd_bsn_prss_c_nm"  value=""  placeholder="전체" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="prss_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>
											</div>
										</td>
										<th scope="row"><label for="sch_hd_cas_tpc_nm" class="control-label">원인유형</label></th>
										<td class="form-inline">
											<div class="input-group">	
												<input type="text" class="form-control w90"  id="sch_hd_cas_tpc_nm" name="sch_hd_cas_tpc_nm" readonly value=""  placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="cas_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_hd_hpn_tpc_nm" class="control-label">사건유형</label></th>
										<td class="form-inline">
											<div class="input-group">	
												<input type="text" class="form-control w90"  id="sch_hd_hpn_tpc_nm" name="sch_hd_hpn_tpc_nm" readonly value=""  placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="hpn_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_reg_dt" class="control-label">등록일자</label></th>
										<td class="form-inline">
											<div class="input-group">
												<input type="text" class="form-control w90" id="sch_reg_st_dt" name="sch_reg_st_dt" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_reg_st_dt_btn" name="sch_reg_st_dt_btn" onclick="showcalendar(1);"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
											<div class="input-group">
											<div class="input-group-addon"> ~ </div>
												<input type="text" class="form-control w90" id="sch_reg_ed_dt" name="sch_reg_ed_dt" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_reg_ed_dt_btn" name="sch_reg_ed_dt_btn" onclick="showcalendar(2);"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</td>		
									</tr>
									<tr>
										<th scope="row"><label for="sch_hd_ifn_tpc_nm" class="control-label">영향유형</label></th>
										<td class="form-inline">
											<div class="input-group">	
												<input type="text" class="form-control w90"  id="sch_hd_ifn_tpc_nm" name="sch_hd_ifn_tpc_nm" readonly value=""  placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico fl" onclick="ifn_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_hd_emrk_tpc_nm" class="control-label">이머징리스크유형</label></th>
										<td class="form-inline">
											<div class="input-group">	
												<input type="text" class="form-control w90" id="sch_hd_emrk_tpc_nm" name="sch_hd_emrk_tpc_nm" readonly value="" placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="emrk_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_st_rkp_tpc" class="control-label">평가대상</label></th>
										<td class="form-inline">
											<span class="select">
												<select class="form-control w90" id="sch_st_rkp_tpc" name="sch_st_rkp_tpc" >
													<option value="">전체</option>
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
		}
%>
												</select>
											</span>
										</td>
										<th scope="row"><label for="sch_chg_dt" class="control-label">변경일자</label></th>
										<td class="form-inline">
											<div class="input-group">
												<input type="text" class="form-control w90" id="sch_chg_st_dt" name="sch_chg_st_dt" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_chg_st_dt_btn" name="sch_chg_st_dt_btn" onclick="showcalendar(3);" ><i class="fa fa-calendar"></i></button>
												</span>
											</div>
											<div class="input-group">
												<div class="input-group-addon"> ~ </div>
												<input type="text" class="form-control w90" id="sch_chg_ed_dt" name="sch_chg_ed_dt" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_chg_ed_dt_btn" name="sch_chg_ed_dt_btn" onclick="showcalendar(4);" ><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</td>																			
									</tr>
									<tr>
										<th scope="row"><label for="sch_brnm" class="control-label">평가부서/팀</label></th>
										<td class="form-inline">
											<div class="input-group">
												<input type="hidden" id="sch_brc" name="sch_brc" value=""/>	
												<input type="text" class="form-control w90" id="sch_brnm" name="sch_brnm"  onKeyPress="EnterkeySubmitOrg('sch_brnm', 'orgSearchEnd');" readonly   placeholder="전체" />
												<span class="input-group-btn">
													<button class="btn btn-default ico" type="button" onclick="schOrgPopup('sch_brnm', 'orgSearchEnd');">
													<i class="fa fa-search"></i><span class="blind">검색</span>	
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_krp_id" class="control-label">리스크 사례 ID</label></th>
										<td>
											<input type="text" class="form-control w120" id="sch_rkp_id" name="sch_rkp_id" onkeypress="EnterkeySubmit();">
										</td>
										<th scope="row"><label for="" class="control-label">리스크 사례</label></th>
										<td>
											<input type="text" class="form-control w120" id="sch_rk_isc_cntn" name="sch_rk_isc_cntn" onkeypress="EnterkeySubmit();">
										</td>
										<th scope="row"><label for="sch_rkp_fq" class="control-label">평가주기</label></th>
										<td>
											<span class="select">
												<select class="form-control w120" id="sch_rkp_fq" name="sch_rkp_fq" >
													<option value="">전체</option>
<%
		for(int i=0;i<vFqLst.size();i++){
			HashMap hMap = (HashMap)vFqLst.get(i);
%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
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

						<article class="box box-grid">
							<div class="wrap-grid h250">
								<script> createIBSheet("mySheet1", "100%", "100%"); </script>
							</div>
							<div class="wrap-btn">
								<button type="button" class="btn btn-primary btn-sm" onclick="copyRkp();"><span class="txt">연결</span><i class="fa fa-angle-down"></i></button>
								<button type="button" class="btn btn-normal btn-sm" onclick="removeRkp();"><span class="txt">연결해제</span><i class="fa fa-angle-up"></i></button>
							</div>
							<div class="wrap-grid h250">
								<script> createIBSheet("mySheet2", "100%", "100%"); </script>
							</div>
						</article>
					</section>

				</div>						
			</div>
			</form>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="doSave();">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/EmrkInfP.jsp" %> <!-- 이머징리스크유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	<script>
	
	
		// 업무프로세스검색 완료
		var PRSS4_ONLY = false; 
		var CUR_BSN_PRSS_C = "";
		
		function prss_popup(){
			CUR_BSN_PRSS_C = $("#sch_hd_bsn_prss_c").val();
			if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
			schPrssPopup();
		}
		

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
				
				
			$("#sch_hd_bsn_prss_c").val(bsn_prss_c);
			$("#sch_hd_bsn_prss_c_nm").val(bsn_prsnm);
			
			$("#winPrss").hide();
		}
		
		// 손실사건유형검색 완료
		var HPN3_ONLY = false; 
		var CUR_HPN_TPC = "";
		
		function hpn_popup(){
			CUR_HPN_TPC = $("#sch_hd_hpn_tpc").val();
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
			
			$("#sch_hd_hpn_tpc").val(hpn_tpc);
			$("#sch_hd_hpn_tpc_nm").val(hpn_tpnm);
			
			$("#winHpn").hide();
			//doAction('search');
		}
		
		// 원인유형검색 완료
		var CAS3_ONLY = false; 
		var CUR_CAS_TPC = "";
		
		function cas_popup(){
			CUR_CAS_TPC = $("#sch_hd_cas_tpc").val();
			schCasPopup();
		}
		
		function casSearchEnd(cas_tpc, cas_tpnm
							, cas_tpc_lv1, cas_tpnm_lv1
							, cas_tpc_lv2, cas_tpnm_lv2){
			
			if (cas_tpc.substr(2,2) == "00")
				cas_tpc = cas_tpc.substr(0,2);
			else if (cas_tpc.substr(4,2) == "00")
				cas_tpc = cas_tpc.substr(0,4);
			
			$("#sch_hd_cas_tpc").val(cas_tpc);
			$("#sch_hd_cas_tpc_nm").val(cas_tpnm);
			
			$("#winCas").hide();
			//doAction('search');
		}
		
		function cas_remove(){
			$("#sch_hd_cas_tpc").val("");
			$("#sch_hd_cas_tpc_nm").val("");
		}
		
		// 영향유형검색 완료
		var IFN2_ONLY = false; 
		var CUR_IFN_TPC = "";
		
		function ifn_popup(){
			CUR_IFN_TPC = $("#sch_hd_ifn_tpc").val();
			schIfnPopup();
		}
		
		function ifnSearchEnd(ifn_tpc, ifn_tpnm
							, ifn_tpc_lv1, ifn_tpnm_lv1
							, ifn_tpc_lv2, ifn_tpnm_lv2){
			
			if (ifn_tpc.substr(2,2) == "00")
				ifn_tpc = ifn_tpc.substr(0,2);
			
			$("#sch_hd_ifn_tpc").val(ifn_tpc);
			$("#sch_hd_ifn_tpc_nm").val(ifn_tpnm);
			
			$("#winIfn").hide();
			//doAction('search');
		}
		
		function ifn_remove(){
			$("#sch_hd_ifn_tpc").val("");
			$("#sch_hd_ifn_tpc_nm").val("");
		}
		
		// 이머징리스크유형검색 완료
		var EMRK2_ONLY = false; 
		var CUR_EMRK_TPC = "";
		
		function emrk_popup(){
			CUR_EMRK_TPC = $("#sch_hd_emrk_tpc").val();
			schEmrkPopup();
		}
		
		function emrkSearchEnd(emrk_tpc, emrk_tpnm
							, emrk_tpc_lv1, emrk_tpnm_lv1){
			
			if (emrk_tpc.substr(2,2) == "00")
				emrk_tpc = emrk_tpc.substr(0,2);
			
			$("#sch_hd_emrk_tpc").val(emrk_tpc);
			$("#sch_hd_emrk_tpc_nm").val(emrk_tpnm);
			
			$("#winEmrk").hide();
			//doAction('search');
		}
		
		function emrk_remove(){
			$("#sch_hd_emrk_tpc").val("");
			$("#sch_hd_emrk_tpc_nm").val("");
		}
		
		<%--부서 시작 --%>
		var init_flag = false;
		function org_popup(){
			schOrgPopup("sch_brnm", "orgSearchEnd","0");
			if($("#sch_hd_brc_nm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		// 부서검색 완료
		function orgSearchEnd(brc, brnm){
			$("#sch_brc").val(brc);
			$("#sch_brnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
	</script>
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});
	

</script>
</body>
</html>