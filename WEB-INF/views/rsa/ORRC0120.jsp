<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0120.jsp
 Program name : 대응방안 수립 관리
 Description  : 화면정의서 RCSA-14
 Programer    : 박승윤
 Date created : 2022.09.26
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/library.jsp" %>
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
<%

/*
	rcsa_menu_dsc 
  1 : ORM
  2 : 부서 리스크담당자
  3 : 부서장/지점장 (결재자)
  4 : 일반사용자
  5 : ORM팀장
*/
DynaForm form = (DynaForm)request.getAttribute("form");
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

Vector vActDeczLst = CommUtil.getCommonCode(request, "RCSA_ACT_DCZ_STSC");
if(vActDeczLst==null) vActDeczLst = new Vector();

String init_brc = "";
String init_brnm = "";

if( !form.get("rcsa_menu_dsc").equals("1")&&!form.get("rcsa_menu_dsc").equals("5") ){
	init_brc = brc;
	init_brnm = brnm;
}


%>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RCSA - 대응방안 수립 관리</title>
</head>
<body>
    <div class="container">
	<%@ include file="../comm/header.jsp" %>



		<!-- content -->
		<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="rcsa_menu_dsc" name="rcsa_menu_dsc" value="<%=form.get("rcsa_menu_dsc")%>" />
				<input type="hidden" id="link_rcsa_act_dcz_stsc" name="link_rcsa_act_dcz_stsc" value="" />
				<input type="hidden" id="dcz_dc" name="dcz_dc" />
		    	<input type="hidden" id="sch_hd_brc" name="sch_hd_brc" value="<%=init_brc%>"/>
		    	<input type="hidden" id="link_bsn_prss_c" name="link_bsn_prss_c" value=""/>
		    	<input type="hidden" id="link_bas_ym" name="link_bas_ym" value=""/>
		    	<input type="hidden" id="link_brc" name="link_brc" value=""/>
				<input type="hidden" id="table_name" name="table_name" value="TB_OR_RH_ACT_DCZ"/>
				<input type="hidden" id="dcz_code" name="stsc_column_name" value="RCSA_ACT_DCZ_STSC"/>
				<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="BSN_PRSS_C"/>
				<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
				<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
				<input type="hidden" id="bas_pd" name="bas_pd" value=""/>
				<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
				<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
				<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
				<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
				<input type="hidden" id="dcz_brc" name="dcz_brc" value=""/>
				<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
				
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가 기준년월</th>
									<td>
										<select name="sch_bas_ym" id="sch_bas_ym" class="form-control w100">
<%
	if (vLst != null)
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
%>
													<option value="<%=(String)hMap.get("bas_ym")%>"><%=(String)hMap.get("bas_ym")%></option>
<%
		}
%>
										</select>
									</td>
									<th>평가조직</th>
										<td>
											<div class="input-group">
												<input type="text" class="form-control w150" id="sch_hd_brc_nm" name="sch_hd_brc_nm" readonly value="<%=init_brnm%>"  placeholder="부서선택"/>
<%
if(form.get("rcsa_menu_dsc").equals("1")||form.get("rcsa_menu_dsc").equals("5") ){
%>
												<span class="input-group-btn">
													<button class="btn btn-default ico" type="button"  onclick="org_popup1();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											  	</span>
<%
}
%>
											</div>
										</td>
								</tr>
								<tr>
									<th>진행 상태<button class="btn-tip tipOpen" type="button" tip="tip"><span class="blind">Help</span></button></th>
									<td colspan="3">
										<select name="sch_act_dcz" id="sch_act_dcz" class="form-control w150">
											<option value="">전체</option>
<%
		for(int i=0;i<vActDeczLst.size();i++){
			HashMap hMap = (HashMap)vActDeczLst.get(i);
						if(Integer.parseInt((String)hMap.get("intgc"))<=15){
%>														
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
			}
		}
%>										    <option value="C">수립완료</option>
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
			
			<!-- tip -->
			<aside id="tip" class="tip-wrap wrap-l">
				<article class="tip-inner">					
					<table class="table-tip w550">
						<colgroup>
							<col style="width: 50px;">
							<col style="width: 150px;">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">진행 상태</th>
								<th scope="col">설명</th>
							</tr>
						</thead>
						<tbody class="center">
							<tr>
								<td>미작성</td>
								<td class="left">대응방안을 작성하지 않은 상태</td>
							</tr>
							<tr>
								<td>작성중</td>
								<td class="left">대응방안을 작성(저장)하였으나 부점장에게 결재 요청하지 않은 상태</td>
							</tr>
							<tr>
								<td>부점장 결재 중</td>
								<td class="left">팀ORM담당자가 부점장에게 결재를 결재 요청하고 부점장이 결재를 완료하지 않은 상태</td>
							</tr>
							<tr>
								<td>ORM전담 결재 중</td>
								<td class="left">부점장이 결재를 완료하고 ORM 전담 앞 결재를 결재 요청한 상태</td>
							</tr>
							<tr>
								<td>ORM팀장 결재 중</td>
								<td class="left">ORM 전담이 결재를 완료하고 ORM 팀장 앞 결재를 결재 요청한 상태</td>
							</tr>
							<tr>
								<td>반려</td>
								<td class="left">부점장/ORM전담/ORM팀장이 반려한 상태</td>
							</tr>
							<tr>
								<td>승인</td>
								<td class="left">ORM 팀장이 결재하여 최종 승인한 상태</td>
							</tr>
						</tbody>
					</table>
				</article>
			</aside>
			<!-- tip //-->
			<!-- 조회 //-->
			

			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">대응방안 수립일정</h2>
					<div class="area-tool">
						<button type="button" class="btn btn-default btn-xs" id="save_btn" onclick="javascript:save();" style="display:none"><i class="fa fa-pencil"></i><span class="txt">수정</span></button>
					</div>
				</div>
				<div class="wrap-table">
					<table>
						<thead>
							<tr>
								<th scope="col" rowspan="2">평가 기준년월</th>
								<th scope="col" rowspan="2">대상 건수</th>
								<th scope="col" rowspan="2">대응방안 수립 미완료 건수</th>
								<th scope="col" rowspan="2">대응방안 수립 건수</th>
								<th scope="col" colspan="2">수립일정</th>
							</tr>
							<tr>
								<th scope="col">수립시작일</th>
								<th scope="col">수립마감기한</th>
							</tr>
						</thead>
						<tbody class="center">
							<tr>
								<td id="info_bas_ym"></td>
								<td id="act_cnt"></td>
								<td id="non_act_cnt"><strong></strong>건</td>
								<td id="cpl_act_cnt"><strong></strong>건</td>
								<td>
									<div class="input-group w130">
										<input type="text" id="rk_act_st_dt" name="rk_act_st_dt" class="form-control" value="" readonly>
										<span class="input-group-btn" id="act_evl_st_btn">
	                                      		<button class="btn btn-default ico" type="button" id="calendarButton1" onclick="showCalendar('yyyy-MM-dd','rk_act_st_dt');" style="display:none"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
										</span>
									</div>
								</td>
								<td>
									<div class="input-group w130">
										<input type="text" id="rk_act_ed_dt" name="rk_act_ed_dt" class="form-control" value="" readonly>
										<span class="input-group-btn" id="act_evl_ed_btn">
											<button class="btn btn-default ico" type="button" id="calendarButton2" onclick="showCalendar('yyyy-MM-dd','rk_act_ed_dt');" style="display:none"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
											</span>
										</div>
									</td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>

			<section class="box box-grid">
				<div class="box-header">
					<div class="area-term"><i class="fa fa-info-circle"></i> 대응방안 수립 대상 업무 프로세스란 2회 연속 (당/전 분기) RCSA 평가 결과 프로세스 기준 잔여 위험 RED 등급 발생한 업무 프로세스임</div>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="wrap-grid h370">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
		  </form>
		</div>
		<!-- content //-->
		
		
	</div>	
	<div id="winRskEvl" class="popup modal">
		<iframe name="ifrRskEvl" id="ifrRskEvl" src="about:blank"></iframe>
	</div>

	<script>
		$(function () {
			initIBSheet();
			if($("#rcsa_menu_dsc").val()=='1')
			{
				$("#save_btn").show();
				$("#calendarButton1").show();
				$("#calendarButton2").show();
			}
		});

		// mySheet
		function initIBSheet() {
			var initdata = {};
			initdata.Cfg = {FrozenCol:0,Sort:1,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" };
			initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{ Header: "평가 기준년월|평가 기준년월",			Edit:false	,Type: "Text",	SaveName: "sheet_bas_ym",	Align: "Center",	Width: 10,	MinWidth: 80 },
				{ Header: "평가 조직|사무소코드",				Edit:false	,Type: "Text",	SaveName: "sheet_brc",	Align: "Center",	Width: 10,	MinWidth: 150 ,Hidden:true},
				{ Header: "평가 조직|평가 조직",					Edit:false  ,Type: "Text",	SaveName: "sheet_brnm",	Align: "Center",	Width: 10,	MinWidth: 150 },
				{ Header: "업무 프로세스|코드",					Edit:false	,Type: "Text",	SaveName: "bsn_prss_c",	Align: "Left",		Width: 10,	MinWidth: 150 ,Hidden:true},
				{ Header: "업무 프로세스|Lv.1",				Edit:false	,Type: "Text",	SaveName: "prssnm1",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "업무 프로세스|Lv.2",				Edit:false	,Type: "Text",	SaveName: "prssnm2",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "업무 프로세스|Lv.3",				Edit:false	,Type: "Text",	SaveName: "prssnm3",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "업무 프로세스|Lv.4",				Edit:false	,Type: "Text",	SaveName: "prssnm4",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "진행 상태|진행 상태 코드",				Edit:false	,Type: "Text",	SaveName: "rcsa_act_dcz_stsc",	Align: "Center",	Width: 10,	MinWidth: 100 ,Hidden:true},
				{ Header: "진행 상태|진행 상태",					Edit:false  ,Type: "Text",	SaveName: "rcsa_act_dcz_stsnm",	Align: "Center",	Width: 10,	MinWidth: 100 },
				{ Header: "결재 상세|결재 상세",					Edit:false  ,Type: "Html",	SaveName: "DetailDcz",	Align: "Center",	Width: 10,	MinWidth: 80 },
				{ Header: "대응방안\n수립 기한|대응방안\n수립 기한",	Edit:false	,Type: "Text",	SaveName: "rk_act_ed_dt",	Align: "Center",	Width: 10,	MinWidth: 80 },
				{ Header: "대응방안\n등록/조회|대응방안\n등록/조회",	Edit:false	,Type: "Html",	SaveName: "RegAct",	Align: "Center",	Width: 10,	MinWidth: 60 },
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
			doAction('search');
		}
		
		
		var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {

		switch(sAction) {
			case "search":  //데이터 조회
				DoSearch();
	
				break;
	
			case "mod":		//평가 팝업
				if($("#bas_ym").val() == ""){
					alert("회차를 선택하세요.");
					return;
				}else{
					
					$("#ifrRskMod").attr("src","about:blank");
					$("#winRskMod").addClass("block");
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(modRisk,1);
					//modRisk();
				}
				break; 

			case "down2excel":
				
				var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "RCSA대응방안 수립 관리.xlsx",SheetName : "Sheet1", Merge:1,Mode:2,DownCols:"0|2|4|5|6|7|9|11"} ;
				mySheet.Down2Excel(params);
	
				break;
	
		}
	}
	
	function DoSearch() {

		var f = document.ormsForm;
			
		//if (part_orm == "Y" || auth_007 == "Y")
			
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC012002");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				  $("#info_bas_ym").text('');
				  $("#act_cnt").text('');
				  $("#non_act_cnt").text('');
				  $("#cpl_act_cnt").text('');
				  $("#rk_act_st_dt").val('');
				  $("#rk_act_ed_dt").val('');
				  
				  if(rList.length > 0){
				  $("#info_bas_ym").text(rList[0].info_bas_ym);
				  $("#act_cnt").text(rList[0].act_cnt);
				  $("#non_act_cnt").text(rList[0].non_act_cnt);
				  $("#cpl_act_cnt").text(rList[0].cpl_act_cnt);
				  $("#rk_act_st_dt").val(rList[0].rk_act_st_dt);
				  $("#rk_act_ed_dt").val(rList[0].rk_act_ed_dt);
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
		
		var opt = {};
		$("form[name=ormsForm] [name=method]").val("Main");
		$("form[name=ormsForm] [name=commkind]").val("rsa");
		$("form[name=ormsForm] [name=process_id]").val("ORRC012003");

		mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

	}
	
	function save(){
			
			var f = document.ormsForm;
		
			f.rk_act_st_dt.value =  f.rk_act_st_dt.value.replace(/-/g,"");
			f.rk_act_ed_dt.value =  f.rk_act_ed_dt.value.replace(/-/g,"");
			
			if( f.rk_act_st_dt.value == ''){
				alert("수립시작일을 입력해 주세요")
				return;
			}
			
			if( f.rk_act_ed_dt.value == ''){
				alert("수립마감기한을 입력해 주세요")
				return;
			}
			
			if(f.rk_act_st_dt.value >= f.rk_act_ed_dt.value){
				alert("수림마감기한은 수립시작일 보다 커야 합니다.")
				return;
			}		
			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012004");

			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

						
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {

							alert("저장 하였습니다.");
							doAction('search');

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
	
	function mySheet_OnRowSearchEnd(Row) {
		mySheet.SetCellText(Row,"DetailDcz",'<button class="btn btn-xs btn-default" type="button" onclick="DczStatus(\''+mySheet.GetCellValue(Row,"bsn_prss_c")+'\',\''+mySheet.GetCellValue(Row,"sheet_bas_ym")+'\',\''+mySheet.GetCellValue(Row,"sheet_brc")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
		mySheet.SetCellText(Row,"RegAct",'<button class="btn btn-xs btn-default" type="button" onclick="RegBtn(\''+mySheet.GetCellValue(Row,"bsn_prss_c")+'\',\''+mySheet.GetCellValue(Row,"sheet_bas_ym")+'\',\''+mySheet.GetCellValue(Row,"sheet_brc")+'\',\''+mySheet.GetCellValue(Row,"rcsa_act_dcz_stsc")+'\')"> <span class="txt">등록/조회</span><i class="fa fa-caret-right ml5"></i></button>')
	}
	function DczStatus(bsn_prss_c,bas_ym,brc) {
		$("#rpst_id").val(bsn_prss_c);
		$("#bas_pd").val(bas_ym);
		$("#dcz_brc").val(brc);
		schDczPopup(3);
	}	
	function ActEvl(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC012101";
		f.target = "ifrRskEvl";
		f.submit();
	}
	function RegBtn(bsn_prss_c,bas_ym,brc,rcsa_act_dcz_stsc){
	    $("#link_bsn_prss_c").val(bsn_prss_c);
	    $("#link_bas_ym").val(bas_ym);
	    $("#link_brc").val(brc);
	    $("#link_rcsa_act_dcz_stsc").val(rcsa_act_dcz_stsc);
		$("#ifrRskEvl").attr("src","about:blank");
		$("#winRskEvl").show();
		showLoadingWs(); // 프로그래스바 활성화
		setTimeout(ActEvl,1);
	}
	function closePop(){
			$("#winRskEvl").hide();
			$("#winBuseo").hide();
	}
		
	</script>
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<script>
	
	
		var init_flag = false;
		function org_popup1(){
			schOrgPopup("sch_hd_brc_nm", "orgSearchEnd1");
			if($("#sch_hd_brc_nm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}

		// 부서검색 완료
		function orgSearchEnd1(brc, brnm){
			if(brc=="") init_flag = true;
			$("#sch_hd_brc").val(brc);
			$("#sch_hd_brc_nm").val(brnm);
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