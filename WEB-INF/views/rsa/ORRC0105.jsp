<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0105.jsp
 Program name : RCSA 평가(일정)관리
 Description  : 화면정의서 RCSA-05
 Programer    : 박승윤
 Date created : 2022.07.14
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");

String rk_evl_prg_stsc = "";
String rk_evl_prg_stsc_nm = "";

for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
	if(rk_evl_prg_stsc==""){
		rk_evl_prg_stsc += (String)hMap.get("intgc");
		rk_evl_prg_stsc_nm += (String)hMap.get("intg_cnm");
	} else {
		rk_evl_prg_stsc += ("|" + (String)hMap.get("intgc")) ;
		rk_evl_prg_stsc_nm += ("|" + (String)hMap.get("intg_cnm"));
	}
}

//System.out.println("rk_evl_prg_stsc:"+rk_evl_prg_stsc);
//System.out.println("rk_evl_prg_stsc_nm:"+rk_evl_prg_stsc_nm);

SysDateDao dao = new SysDateDao(request);
String bas_dt = dao.getSysdate().substring(0,4); //yyyymmdd

int bas_year = Integer.parseInt(bas_dt);

bas_year = bas_year + 1;
%>


<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script>
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			initData.Cols = [
				{Header:"그룹내기관코드",Type:"Text",Width:0,Align:"Center",SaveName:"grp_org_c",MinWidth:0,Hidden:true,Edit:0},
				{Header:"기준년월(value)",Type:"Text",Width:60,Align:"Center",SaveName:"bas_ym",MinWidth:60,Edit:0,Hidden:true},
				{Header:"기준년월",Type:"Text",Width:60,Align:"Center",SaveName:"bas_ym_nm",MinWidth:60,Edit:0},
				{Header:"평가유형",Type:"Text",Width:100,Align:"Center",SaveName:"rk_evl_tpc",MinWidth:60,Edit:0,Hidden:true},
				{Header:"평가시작일",Type:"Text",Width:100,Align:"Center",SaveName:"rk_evl_st_dt",MinWidth:60,Format:"yyyy-MM-dd",Edit:0},
				{Header:"평가종료일",Type:"Text",Width:100,Align:"Center",SaveName:"rk_evl_ed_dt",MinWidth:60,Format:"yyyy-MM-dd",Edit:0},
				{Header:"등록/변경사유",Type:"Text",Width:200,Align:"Center",SaveName:"rk_evl_chg_rsn",MinWidth:60,Edit:0,Wrap:1,MultiLineText:1},
				{Header:"상태",Type:"Combo",Width:100,Align:"Center",SaveName:"rk_evl_prg_stsc",MinWidth:60,ComboText:"<%=rk_evl_prg_stsc_nm%>", ComboCode:"<%=rk_evl_prg_stsc%>",Edit:0},
			];
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			mySheet.FitColWidth();
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search');

			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#link_bas_yy").val(mySheet.GetCellValue(Row,"bas_ym").substr(0,4));
				$("#link_bas_ym_nm").val(mySheet.GetCellValue(Row,"bas_ym_nm"));
				$("#link_sc").val(mySheet.GetCellValue(Row,"bas_ym").substr(4,2));
				$("#link_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
				$("#link_rk_evl_tpc").val(mySheet.GetCellValue(Row,"rk_evl_tpc"));
				$("#link_rk_evl_st_dt").val(mySheet.GetCellValue(Row,"rk_evl_st_dt"));
				$("#link_rk_evl_ed_dt").val(mySheet.GetCellValue(Row,"rk_evl_ed_dt"));
				$("#link_rk_evl_chg_rsn").val(mySheet.GetCellValue(Row,"rk_evl_chg_rsn"));
				$("#link_rk_evl_prg_stsc").val(mySheet.GetCellValue(Row,"rk_evl_prg_stsc"));
				
				doAction('mod');
			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#link_bas_yy").val(mySheet.GetCellValue(Row,"bas_ym").substr(0,4));
				$("#link_bas_ym_nm").val(mySheet.GetCellValue(Row,"bas_ym_nm"));
				$("#link_sc").val(mySheet.GetCellValue(Row,"bas_ym").substr(4,2));
				$("#link_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
				$("#link_rk_evl_tpc").val(mySheet.GetCellValue(Row,"rk_evl_tpc"));
				$("#link_rk_evl_st_dt").val(mySheet.GetCellValue(Row,"rk_evl_st_dt"));
				$("#link_rk_evl_ed_dt").val(mySheet.GetCellValue(Row,"rk_evl_ed_dt"));
				$("#link_rk_evl_chg_rsn").val(mySheet.GetCellValue(Row,"rk_evl_chg_rsn"));
				$("#link_rk_evl_prg_stsc").val(mySheet.GetCellValue(Row,"rk_evl_prg_stsc"));
			}
		}
		
		function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		   if(KeyCode == 13) {
			 if(Row >= mySheet.GetDataFirstRow()){
				$("#link_bas_yy").val(mySheet.GetCellValue(Row,"bas_ym").substr(0,4));
				$("#link_bas_ym_nm").val(mySheet.GetCellValue(Row,"bas_ym_nm"));
				$("#link_sc").val(mySheet.GetCellValue(Row,"bas_ym").substr(4,2));
				$("#link_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
				$("#link_rk_evl_tpc").val(mySheet.GetCellValue(Row,"rk_evl_tpc"));
				$("#link_rk_evl_st_dt").val(mySheet.GetCellValue(Row,"rk_evl_st_dt"));
				$("#link_rk_evl_ed_dt").val(mySheet.GetCellValue(Row,"rk_evl_ed_dt"));
				$("#link_rk_evl_chg_rsn").val(mySheet.GetCellValue(Row,"rk_evl_chg_rsn"));
				$("#link_rk_evl_prg_stsc").val(mySheet.GetCellValue(Row,"rk_evl_prg_stsc"));
				
				doAction('mod');
			 }
		   }
	    }
		
		
		function addRisk(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="rsa";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORRC010601";
			f.target = "ifrRskAdd";
			f.submit();
		}
		
		function modRisk(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="rsa";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORRC010601";
			f.target = "ifrRskMod";
			f.submit();
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
					$("form[name=ormsForm] [name=process_id]").val("ORRC010502");

					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

					break;
				case "add":		//신규등록 팝업
					if( $("#bas_yy").val() == "" ){
						alert("일정을 등록할 시행년도를 선택하세요.");
						return;
					}
				
				/*
					var bas_year =<%=bas_year%> - 1;
					
					if( $("#bas_yy").val() < bas_year ){
						alert("일정을 등록할 시행년도를 선택하세요.");
						return;
					}
					*/
					
					$("#ifrRskAdd").attr("src","about:blank");
					$("#winRskAdd").addClass("block");
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(addRisk,1);
					
					break; 
				case "mod":		//수정 팝업
					if($("#link_bas_ym").val() == ""){
						alert("회차를 선택하세요.");
						return;
					}else{
						if($("#link_rk_evl_prg_stsc").val()=="03")
							{
							  $("#saveBtn").hide();
							}
						else
							{
							  $("#saveBtn").show();
							}
							
						$("#ifrRskMod").attr("src","about:blank");
						$("#winRskMod").addClass("block");
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modRisk,1);
						//modRisk();
					}
					break; 
				case "down2excel":
					
					setExcelDownCols("1|2|3|4|5|6");
					mySheet.Down2Excel(excel_params);

					break;

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
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert(msg);  // 저장 성공 메시지
		        doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}

		function goSavEnd(){
			$("#winRskAdd").removeClass("block");
			$("#winRskMod").removeClass("block");
			doAction('search');
		}
		

		
	</script>

</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		
		<div class="content">
			<!-- .search-area 검색영역 -->
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />

				<input type="hidden" id="link_bas_ym" name="link_bas_ym" value="" />
				<input type="hidden" id="link_bas_ym_nm" name="link_bas_ym_nm" value="" />
				<input type="hidden" id="link_bas_yy" name="link_bas_yy" value="" />
				<input type="hidden" id="link_sc" name="link_sc" value="" />
				<input type="hidden" id="link_rk_evl_tpc" name="link_rk_evl_tpc" value="" />
				<input type="hidden" id="link_rk_evl_st_dt" name="link_rk_evl_st_dt" value="" />
				<input type="hidden" id="link_rk_evl_ed_dt" name="link_rk_evl_ed_dt" value="" />
				<input type="hidden" id="link_rk_evl_chg_rsn" name="link_rk_evl_chg_rsn" value="" />
				<input type="hidden" id="link_rk_evl_prg_stsc" name="link_rk_evl_prg_stsc" value="" />

			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th scope="row">시행년도</th>
									<td>
										<div class="select">
											<select class="form-control w80" id="bas_yy" name="bas_yy" >
												<option value="">전체</option>
<%
for(int i=2022;i<=bas_year;i++){
%>
												<option value=<%=i%>><%=i%></option>

<%
}
%>
											</select>
										</div>
									</td>
									<th scope="row">진행상태</th>
									<td>
										<div class="select">
											<select class="form-control w100" id="rk_evl_prg_stsc" name="rk_evl_prg_stsc" >
												<option value="">전체</option>
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>" > 
												<%=(String)hMap.get("intg_cnm")%>
												</option>
												 
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
				</div><!-- .box-body //-->
				<div class="box-footer">
					<!--	<button type="button" class="btn btn-xs btn-default"  onClick="javascript:doAction('add');"><i class="fa fa-plus"></i><span class="txt">일정등록</span></button> -->
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- .search-area //-->
		</form>
			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-default btn-xs" onClick="javascript:doAction('mod')"><i class="fa fa-plus"></i><span class="txt">일정변경</span></button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h500">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div><!-- .box-body //-->
			</div><!-- .box //-->
		</div><!-- .content //-->
	</div><!-- .container //-->	
	<!-- .content-wrapper // -->
		
	<div id="winRskAdd" class="popup modal">
		<div class="p_frame w800">
 			<div class="p_head">
				<h3 class="title">일정 등록</h3>
			</div>
			<div class="p_body">
				<iframe name="ifrRskAdd" id="ifrRskAdd" src="about:blank" class="h300"></iframe>
			</div>
					<div class="p_foot">
						<div class="btn-wrap right">
							<button type="button" class="btn btn-primary" onclick="javascript:ifrRskAdd.save();">저장</button>
							<button type="button" class="btn btn-default btn-close">닫기</button>
						</div>
					</div>
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>

	</div>
	<!-- popup //-->
		
	<div id="winRskMod" class="popup modal">
		<div class="p_frame w600">
 			<div class="p_head">
				<h3 class="title">일정 수정</h3>
			</div>
			<div class="p_body">
				<iframe name="ifrRskMod" id="ifrRskMod" src="about:blank" class="h220"></iframe>
			</div>
				<div class="p_foot">
					<div class="btn-wrap right">
						<!-- <button type="button" class="btn btn-primary fl" onclick="javascript:ifrRskMod.evlsuc();">평가완료</button> -->
						<button type="button" class="btn btn-primary" id="saveBtn" onclick="javascript:ifrRskMod.save();">저장</button>
						<!-- <button type="button" class="btn btn-normal" onclick="javascript:ifrRskMod.del();">삭제</button> -->
						<button type="button" class="btn btn-default btn-close" onclick="javascript:goSavEnd();">닫기</button>
					</div>
				</div>
			<button type="button" class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</div>
		<!-- popup //-->
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup").removeClass("block");
			 doAction("search");
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});
		
	function closePop(){
		$("#winRskAdd").removeClass("block");
		$("#winRskMod").removeClass("block");
		$("#winBuseo").removeClass("block");
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