<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0114.jsp
 Program name : 진행현황
 Description  : 화면정의서 RCSA-09
 Programer    : 박승윤
 Date created : 2022.09.01
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
<%

Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
DynaForm form = (DynaForm)request.getAttribute("form");

/*
	rcsa_menu_dsc 
  1 : 진행현황(전부서)
  2 : 진행현황   --본부부서 OR 영업점
*/  

%>





<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script>
	
	$(document).ready(function(){


		$("#brnm").keypress(org_popup);
		$("#brnm").keyup(delTxt);
		// ibsheet 초기화
		initIBSheet1();
		
		initIBSheet2();
		
		
		if($("#rcsa_menu_dsc").val()=="2"){
			$("#sch_brc").val("<%=brc%>");
			$("#brnm").val("<%=brnm%>");
			$("#org_pop_btn").css("display","none");
			if(<%=hofc_bizo_dsc%>=="03")
				{
					$("#sheet1").css("display","none");
					$("#sheet2").attr("class","col w100p");
				}
		}else {
			$("#org_pop_btn").show();
		}
		
		doSearch();
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet1() {
		//시트 초기화
		mySheet1.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"No",Type:"Text",Width:30,Align:"Center",SaveName:"num",MinWidth:20,Edit:0},
			{Header:"상위사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"up_brc",MinWidth:60, Hidden:true},
			{Header:"상위조직",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:50,Edit:0},
			{Header:"평가\n지정율",Type:"Text",Width:50,Align:"Center",SaveName:"evl_slt_rat",MinWidth:50,Edit:0},
			{Header:"평가진행\n비율",Type:"Text",Width:50,Align:"Center",SaveName:"evl_prg_rat",MinWidth:50,Edit:0},
			{Header:"평가완료\n여부",Type:"Text",Width:40,Align:"Center",SaveName:"evl_cpl_yn",MinWidth:30,Edit:0},
			{Header:"부서결재완료\n여부",Type:"Text",Width:40,Align:"Center",SaveName:"brc_cpl_yn",MinWidth:30,Edit:0},
			{Header:"최종결재완료\n여부",Type:"Text",Width:40,Align:"Center",SaveName:"dcz_cpl_yn",MinWidth:30,Edit:0}
		];

		IBS_InitSheet(mySheet1,initData);
		
		//필터표시
		//mySheet1.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet1.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet1.SetSelectionMode(4);
		
		mySheet1.FitColWidth();		
	}
	
	/*Sheet 기본 설정 */
	function initIBSheet2() {
		//시트 초기화
		mySheet2.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
   			{Header:"No",Type:"Text",Width:50,Align:"Center",SaveName:"num",MinWidth:50,Edit:0},
   			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:60, Hidden:true},
   			{Header:"평가조직",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:100,Edit:0},
   			{Header:"평가\n지정율",Type:"Text",Width:50,Align:"Center",SaveName:"evl_slt_rat",MinWidth:50,Edit:0},
   			{Header:"평가\n진행비율",Type:"Text",Width:50,Align:"Center",SaveName:"evl_prg_rat",MinWidth:50,Edit:0},
   			{Header:"평가\n완료여부",Type:"Text",Width:40,Align:"Center",SaveName:"evl_cpl_yn",MinWidth:20,Edit:0},
   			{Header:"평가\n완료일자",Type:"Text",Width:60,Align:"Center",SaveName:"evl_cpl_dt",MinWidth:60,Format:"yyyy-MM-dd",Edit:0},
   			{Header:"팀/지점결재완료\n여부",Type:"Text",Width:60,Align:"Center",SaveName:"brc_cpl_yn",MinWidth:20,Edit:0},
			{Header:"최종결재완료\n여부",Type:"Text",Width:50,Align:"Center",SaveName:"dcz_cpl_yn",MinWidth:20,Edit:0},
   			{Header:"개인번호",Type:"Text",Width:0,Align:"Center",SaveName:"eno",MinWidth:60, Hidden:true},
   			{Header:"직명",Type:"Text",Width:60,Align:"Center",SaveName:"oftnm",MinWidth:60,Edit:0},
   			{Header:"담당자",Type:"Text",Width:70,Align:"Center",SaveName:"enpnm",MinWidth:70,Edit:0},
   			{Header:"전화번호",Type:"Text",Width:80,Align:"Center",SaveName:"telno",MinWidth:80,Edit:0, EditLen:14}
		]; 

		IBS_InitSheet(mySheet2,initData);
		
		//필터표시
		//mySheet2.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet2.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet2.SetSelectionMode(4);
		
		mySheet2.FitColWidth();	
		
		doAction("search");
	}
	
	function doSearch() {
		var f = document.ormsForm;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC011404");
		WP.setForm(f);
		
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		
		WP.load(url, inputData,{
			success: function(result){

			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				if (rList.length > 0) {
				  $("#bas_ym").val(rList[0].bas_ym);
				  $("#bas_ym_nm").text(rList[0].bas_ym_nm);
				  $("#evl_date").text(rList[0].evl_date);
				  $("#cpl_rat").text((zeroPadding(rList[0].evl_rate)+"%"));
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
		
		

	}
	
	
	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {

		switch(sAction) {
			case "search":  //데이터 조회

				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("rsa");
				$("form[name=ormsForm] [name=process_id]").val("ORRC011402");

				$("#st_dt").val($("#st_dt").val().replace(/\-/g,""));
				$("#ed_dt").val($("#ed_dt").val().replace(/\-/g,""));

				mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				mySheet2.RemoveAll();
				break;

			case "down2excel":
				
				var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "RCSA평가진행현황.xlsx", SheetName : "Sheet1", Merge:1} ;
				mySheet2.Down2Excel(params);

				break;

		}
	}	    	

	

	function mySheet2_OnRowSearchEnd (Row) {
		if(mySheet2.GetCellValue(Row,"brc")== $("#sch_brc").val()){
		 mySheet2.SelectCell(Row, "brc")
	  }
	}
	
	function mySheet1_OnRowSearchEnd (Row) {
		 mySheet1.SetCellValue(Row, "evl_slt_rat",zeroPadding(mySheet1.GetCellValue(Row,"evl_slt_rat")));
		 mySheet1.SetCellValue(Row, "evl_prg_rat",zeroPadding(mySheet1.GetCellValue(Row,"evl_prg_rat")));
	}
		

	function mySheet1_OnSearchEnd(code, message) {

	    if(code == 0) {
	        //조회 후 작업 수행
	    	mySheet1.FitColWidth();
		} else {
	
			alert("조회 중에 오류가 발생하였습니다..");
		}

	}

	function mySheet2_OnSearchEnd(code, message) {

	    if(code == 0) {
	        //조회 후 작업 수행
	    	mySheet2.FitColWidth();
	    	
	    	if(mySheet2.GetDataFirstRow()>=0){
				for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
					if(mySheet2.GetCellValue(j,"brc")== $("#sch_brc").val()){
				 		mySheet2.SelectCell(j, "brc")
	  				}	
				}
		    }
	    	
	    	
		} else {
	
			alert("조회 중에 오류가 발생하였습니다..");
		}

	}
	
	//function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
	function mySheet1_OnSelectCell(oRow, oCol, Row, Col, isDelete) { 
		if(Row == oRow) return;
		
		if(Row >= mySheet1.GetDataFirstRow()){
			
			$("#up_brc").val(mySheet1.GetCellValue(Row,"up_brc"));

			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("rsa");
			$("form[name=ormsForm] [name=process_id]").val("ORRC011403");
			mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		}
	}
	
	function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		
		if(Row >= mySheet2.GetDataFirstRow()){
			
			$("#link_brc").val(mySheet2.GetCellValue(Row,"brc"));
			$("#link_brnm").val(mySheet2.GetCellValue(Row,"brnm"));
			$("#ifrRskEvl").attr("src","about:blank");
			$("#winRskEvl").show();
			showLoadingWs(); // 프로그래스바 활성화
			setTimeout(RiskEvl,1);
		}
	}
	
	function RiskEvl(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC011501";
		f.target = "ifrRskEvl";
		f.submit();
	}
	
	var init_flag = false;
	
	function org_popup(){
//		if (auth_orm == 'Y')
//		{
			schOrgPopup("brnm", "orgSearchEnd");
			if($("#brnm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
//		}
	}
	
	// 부서검색 완료
	function orgSearchEnd(brc, brnm){
		if(brc=="") init_flag = true;
		$("#sch_brc").val(brc);
		$("#brnm").val(brnm);
		$("#winBuseo").hide();
		doAction('search');
	}
	
	function delTxt(){
		if($("#brnm").val() == "") $("#brc").val("");
	}
	function zeroPadding(num){

		if(num.indexOf(".")==0)
			{
				return "0"+num;
			}
		else
			{
				return num;
			}
	}
	
	</script>
</head>
<body class="">
	<!-- iframe 영역 -->
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		
		<div class="content">
			<!-- .search-area 검색영역 -->
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />				
				<input type="hidden" id="up_brc" name="up_brc" />
				<input type="hidden" id="link_brc" name="link_brc" />
				<input type="hidden" id="link_brnm" name="link_brnm" />
				<input type="hidden" id="bas_ym" name="bas_ym" />
				<input type="hidden" id="rcsa_menu_dsc" name="rcsa_menu_dsc" value="<%=form.get("rcsa_menu_dsc")%>" />
				<input type="hidden" id="hofc_bizo_dsc" name="hofc_bizo_dsc" value="<%=form.get("hofc_bizo_dsc")%>" />
				<input type="hidden" id="auth_c" name="auth_c" value=<%= form.get("auth_c") %>/>

			<!-- .search-area 검색영역 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>

							<tbody>
								<tr>
									<th scope="row">부서</th>
									<td class="form-inline">
										<div class="input-group">
											<input type="hidden" id="sch_brc" name="sch_brc" readonly>
											<input type="text" class="form-control w140" id="brnm" name="brnm" readonly>
											<span class="input-group-btn">
												<button class="btn btn-default ico" id="org_pop_btn" type="button"  onclick="javascript:org_popup();" style="display:none"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
									<th scope="row">진행상태</th>
									<td>
										<div class="select">
											<select class="form-control" id="rk_evl_dcz_stsc" name="rk_evl_dcz_stsc">
												<option value="">전체</option>
												<option value="Y">평가완료</option>
												<option value="N">평가미완료</option>
											</select>
										</div>
									</td>
									<th scope="row">완료일자</th>
									<td colspan="3">
										<div class="form-inline">
											<div class="input-group">
												<input class="form-control w100" type="text" id="st_dt" name="st_dt" >
												<span class="input-group-btn">
													<button class="btn btn-default ico" type="button" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','st_dt');"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
												</span>
											</div>
											<div class="input-group">
												<div class="input-group-addon"> ~ </div>
												<input class="form-control w100" type="text" id="ed_dt" name="ed_dt" >
												<span class="input-group-btn">
													<button class="btn btn-default ico" type="button" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','ed_dt');"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
												</span>
											</div>
										</div>
									</td>	
								</tr>
							</tbody>
						</table>
					</div>
				</div>					
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- .search-area //-->

			
			<div class="box box-grid">
				<div class="box-header">
					<div class="ib">
						<span class="txt txt-sm ca">평가기준년월 </span>
						<strong id="bas_ym_nm" class="cs">2021-00차</strong> 
						<span class="txt txt-sm ca"> / 평가기간 </span>
						<strong id="evl_date" class="cs">2021-00-00 ~ 2021-00-00</strong>
						<span class="txt txt-sm ca"> / 완료비율 </span>
						<strong id="cpl_rat" class="cs">0</strong>
					</div>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body row">
					<div class="col w40p" id = "sheet1">
						<div class="wrap-grid h550">
								<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
						</div>
					</div>
					<div class="col w60p" id = "sheet2">
						<div class="wrap-grid h550">
								<script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script>
						</div>
					</div>
				</div>
			</div>
			
			</form>
		</div><!-- .content //-->
	</div><!-- .container //-->
		
		
	<!-- popup //-->
	<div id="winRskEvl" class="popup modal"  style="background-color:transparent">
		<iframe name="ifrRskEvl" id="ifrRskEvl" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
	</div>
		<!-- popup //-->
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup").hide();
			$(".popup",parent.document).hide();
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});
		
	function closePop(){
		$("#winNonEvl").hide();
		$("#winRskEvl").hide();
		$("#winBuseo").hide();
	}
	// 부점검색 완료
	function buseoSearchEnd(kbr_nm, new_br_cd){
		$("#kbr_nm").val(kbr_nm);
		$("#sch_new_br_cd").val(new_br_cd);
		closeBuseo();
		//doAction('search');
	}
	</script>
</body>
</html>