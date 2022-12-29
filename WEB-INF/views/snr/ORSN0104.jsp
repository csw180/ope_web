<%--
/*---------------------------------------------------------------------------
 Program ID   : ORSN0104.jsp
 Program name : 시나리오 보고서 관리
 Description  : 
 Programer    : 고창호
 Date created : 2022.07.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
<%

/*
SNR_MENU_DSC
1 : ORM
2 : ORM팀장
*/

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();

DynaForm form = (DynaForm)request.getAttribute("form");

HashMap hMap2 = null;
if(vLst2.size()>0){
	hMap2 = (HashMap)vLst2.get(0);
}else{
	hMap2 = new HashMap();
}

Vector vSnroDczC = CommUtil.getCommonCode(request, "SNRO_DCZ_STSC");
if(vSnroDczC==null) vSnroDczC = new Vector();

String SnroDczC = "";
String SnroDczNm = "";
/*시나리오 결재 상태*/
for(int i=0;i<vSnroDczC.size();i++){
	HashMap hMap = (HashMap)vSnroDczC.get(i);
	if( i > 0 ){
		SnroDczC += "|";
		SnroDczNm += "|";
	}
	SnroDczC += (String)hMap.get("intgc");
	
	SnroDczNm += (String)hMap.get("intg_cnm");
}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>시나리오 보고서 관리(ORM전담)</title>
	<script>
		
		$(document).ready(function(){

		<%
			if(vLst2.size()>0){
		%>
					$('#span_snro_sc').html('<%=(String)hMap2.get("snro_sc")%>'.substring(0,4)+"-"+'<%=(String)hMap2.get("snro_sc")%>'.substring(4,6)+'회차'); //회차
					$('#span_efct_st_dt').html('<%=(String)hMap2.get("efct_st_dt")%>'); //수행시작일
					$('#span_efct_ed_dt').html('<%=(String)hMap2.get("efct_ed_dt")%>'); //수행종료일
		<%
			}
		%>	
		
			// ibsheet 초기화
			initIBSheet();
			
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			
			initData.Cols = [
			    {Header: "선택|선택", Type:"CheckBox",Width:40,Align:"Center",SaveName:"ischeck",MinWidth:40},
				{Header: "업무프로세스|Lv.1", Type:"Text",Width:200,Align:"Left",SaveName:"lv1_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "업무프로세스|Lv.2", Type:"Text",Width:200,Align:"Left",SaveName:"lv2_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "업무프로세스|Lv.3", Type:"Text",Width:200,Align:"Left",SaveName:"lv3_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "업무프로세스|Lv.4", Type:"Text",Width:200,Align:"Left",SaveName:"lv4_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "업무프로세스코드", Type:"Text",Width:200,Align:"Left",SaveName:"bsn_prss_c",MinWidth:100,Hidden:true},
				{Header: "회차", Type:"Text",Width:200,Align:"Left",SaveName:"snro_sc",MinWidth:100,Hidden:true},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|손실사건 발생건수\n(100만원 이상)", Type:"Int",Width:100,Align:"Center",SaveName:"lsoc_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|KRI Red발생 건수", Type:"Int",Width:100,Align:"Center",SaveName:"kri_ocu_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|RCSA 위험평가\nRed발생 건수", Type:"Int",Width:100,Align:"Center",SaveName:"ra_ocu_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|RCSA 통제평가\n'하'발생 건수", Type:"Int",Width:100,Align:"Center",SaveName:"ctev_ocu_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최종 위험\n점수 합계|최종 위험\n점수 합계", Type:"Float",Width:80,Align:"Center",SaveName:"ls_rsk_scr",MinWidth:100,Edit:false,Format:"#,##0.####"},
				{Header: "상태|상태",Type:"Combo",Width:100,Align:"Center",SaveName:"snro_dcz_stsc",MinWidth:100,ComboText:"<%=SnroDczNm%>", ComboCode:"<%=SnroDczC%>",Edit:0},
				{Header: "분석|분석",Type:"Html",Width:60,Align:"Center",SaveName:"btn_rg",MinWidth:60}, 
				{Header: "상태|상태", Type:"Status",Width:50,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:40,Edit:false,Hidden:true},
				{Header:"결재현황|결재현황",Type:"Html",Width:60,Align:"Center",SaveName:"DetailDcz",MinWidth:60 }
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetMergeSheet(eval("msHeaderOnly"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		
			doAction('search');
			
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
					if($('#sch_snro_sc').val() == ""){
						alert("평가 회차는 필수 입력항목 입니다.");
						return;
					}
				
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("snr");
					$("form[name=ormsForm] [name=process_id]").val("ORSN010402");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
					
				case "dcsRpsp":	//결재상신
					var f = document.ormsForm;
					
					if(mySheet.CheckedRows("ischeck") < 1)
					{
						alert("항목을 선택해주세요.");
						return;
					}
					
					//진행상태 체크 (게시완료된 기사가 있는경우 return)
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"&&mySheet.GetCellValue(i, "snro_dcz_stsc")!= "13"){				//이미요청된 사건 선택시 경고
								alert("작성완료 상태가 아닌 항목이 포함되어 있습니다.");
								return;
							}
						}
					
						$("#dcz_dc").val("14"); 
						$("#dcz_objr_emp_auth").val("'009'");
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
								$("#rpst_id").val(mySheet.GetCellValue(i,"bsn_prss_c"));
								$("#bas_pd").val(mySheet.GetCellValue(i,"snro_sc"));
							}
						schDczPopup(1);


										
					break;
				
				case "dczCmp":	//결재
					var f = document.ormsForm;
					
					if(mySheet.CheckedRows("ischeck") < 1)
					{
						alert("항목을 선택해주세요.");
						return;
					}
					
					//진행상태 체크 (게시완료된 기사가 있는경우 return)
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"&&mySheet.GetCellValue(i, "snro_dcz_stsc")!= "14"){				//이미요청된 사건 선택시 경고
								alert("결재상신 상태가 아닌 항목이 포함되어 있습니다.");
								return;
							}
						}
					
						$("#dcz_dc").val("15"); 
						$("#dcz_objr_emp_auth").val("'002'");
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
								$("#rpst_id").val(mySheet.GetCellValue(i,"bsn_prss_c"));
								$("#bas_pd").val(mySheet.GetCellValue(i,"snro_sc"));
							}
						schDczPopup(2);


										
					break;
				case "down2excel":
					setExcelFileName("시나리오 보고서 관리 목록.xlsx");
					setExcelDownCols("1|2|3|4|5|6|7|8|9|10|11");
					mySheet.Down2Excel(excel_params);
	
					break;
			}
		}
		
		
		function DczStatus(snro_sc,bsn_prss_c) {
			$("#rpst_id").val(bsn_prss_c);
			$("#bas_pd").val(snro_sc);
			schDczPopup(3);
		}
		
		// 시나리오 보고서
		function popORSN0105(snro_sc,bsn_prss_c){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="snr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORSN010501";
	        f.mode.value = "I"; //조회
	        f.snro_sc_p.value = snro_sc;
	        f.bsn_prss_c_p.value = bsn_prss_c;
	        f.target = "ifrORSN0105";
			f.submit();
		}
		
		
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function mySheet_OnSaveEnd(code, msg) {
			
		    if(code >= 0) {
		        alert("완료 되었습니다.");  // 저장 성공 메시지
		        $("#winDcz").hide();
		        doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#jsonData").val(JSON.stringify(mySheet.GetRowData(Row))); //선택된 Row jsonData
			}
			
			//입력 버튼 클릭
			if(mySheet.ColSaveName(Col) == "btn_rg"){
				$("#ifrORSN0105").attr("src","about:blank");
				$("#winORSN0105").show();
				
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popORSN0105(mySheet.GetCellValue(Row,"snro_sc"),mySheet.GetCellValue(Row,"bsn_prss_c")),1);
				return;
			}
		}
		
		<%-- 업무프로세스 시작 --%>			
		// 업무프로세스검색 완료
		var PRSS4_ONLY = true; 
		var CUR_BSN_PRSS_C = "";
		
		function prss_popup(){
			CUR_BSN_PRSS_C = $("#sch_bsn_prss_c").val();
			if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
			schPrssPopup();
		}
		
		function prssSearchEnd(bsn_prss_c, bsn_prsnm
							, bsn_prss_c_lv1, bsn_prsnm_lv1
							, bsn_prss_c_lv2, bsn_prsnm_lv2
							, bsn_prss_c_lv3, bsn_prsnm_lv3
							, biz_trry_c_lv1, biz_trry_cnm_lv1
							, biz_trry_c_lv2, biz_trry_cnm_lv2){
			$("#sch_bsn_prss_c").val(bsn_prss_c);
			$("#sch_prss_nm").val(bsn_prsnm);
			
			$("#winPrss").hide();
		}

		
		function mySheet_OnRowSearchEnd(Row) {
		
			mySheet.SetCellText(Row,"DetailDcz",'<button class="btn btn-xs btn-default" type="button" onclick="DczStatus(\''+mySheet.GetCellValue(Row,"snro_sc")+'\',\''+mySheet.GetCellValue(Row,"bsn_prss_c")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
			mySheet.SetCellText(Row,"btn_rg",'<button class="btn btn-xs btn-default" type="button" > <span class="txt">입력</span><i class="fa fa-caret-right ml5"></i></button>')
		}
		
		function prss_remove(){
			$("#sch_bsn_prss_c").val("");
			$("#sch_prss_nm").val("");
		}
		
		
		function doSave() {
			mySheet.DoSave(url, { Param : "method=Main&commkind=snr&process_id=ORSN010403&dcz_dc="+$("#dcz_dc").val()+"&sch_rtn_cntn="+$("#sch_rtn_cntn").val()+"&dcz_objr_eno="+$("#dcz_objr_eno").val(), Col : 0 });
		}		
		
		<%-- 업무프로세스 끝 --%>
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
			<input type="hidden" id="snro_sc" name="snro_sc" /> <!-- 평가회차 -->
			<!-- ORSN0105 보고서 팝업에서 사용 -->
			<input type="hidden" id="snro_sc_p" name="snro_sc_p" /> <!-- 평가회차 -->
			<input type="hidden" id="bsn_prss_c_p" name="bsn_prss_c_p" /> <!-- 프로세스 -->
			<input type="hidden" id="jsonData" name="jsonData" /> <!-- jsonData(String) -->
			<input type="hidden" id="mode" name="mode" /> <!-- 팝업 모드(I:저장, R:조회용) -->
			<input type="hidden" id="dcz_dc" name="dcz_dc" />
			<input type="hidden" id="snro_menu_dsc" name="snro_menu_dsc" value="<%=form.get("snr_menu_dsc")%>"/> <!-- 팝업 모드(I:저장, R:조회용) -->
			<input type="hidden" id="table_name" name="table_name" value="TB_OR_SH_RPTG_DCZ"/>
			<input type="hidden" id="dcz_code" name="stsc_column_name" value="SNRO_DCZ_STSC"/>
			<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="BSN_PRSS_C"/>
			<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
			<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="SNRO_SC"/>
			<input type="hidden" id="bas_pd" name="bas_pd" value=""/>
			<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
			<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
			<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
			<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
			
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가 회차</th>
									<td>
										<div class="select">
											<select name="sch_snro_sc" id="sch_snro_sc" class="form-control w100">
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("snro_sc")%>"><%=(String)hMap.get("snro_sc")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>업무프로세스</th>
									<td class="form-inline">
										<div class="input-group">											
											<input type="text" class="form-control w150" id="sch_prss_nm" name="sch_prss_nm" readonly/>
											<input type="hidden" id="sch_bsn_prss_c" name="sch_bsn_prss_c">
											<div class="input-group-btn">
												<button type="button" class="btn btn-default ico" onclick="prss_popup();">
													<i class="fa fa-search"></i><span class="blind">검색</span>
												</button>
											</div>
											<div class="input-group-btn">
												<button type="button" class="btn btn-default ico" onclick="prss_remove();">
													<i class="fa fa-times-circle"></i>
												</button>
											</div>
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
			<!-- //조회 -->


			<section class="box box-grid">
				<div class="box-header">
					<div class="area-term">
						<span class="tit">평가 일정 :</span>
						<span id="span_snro_sc" class="tag"></span>
						<strong id="span_efct_st_dt" class="em"></strong>
						<span class="div">~</span>
						<strong id="span_efct_ed_dt" class="em"></strong>
					</div>
					<div class="area-tool">
						<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h540">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
<%
if( form.get("snr_menu_dsc").equals("1") ){ //ORM담당자
 %>						
				<div class="box-footer">
					<div class="btn-wrap">
						<button class="btn btn-primary" type="button" onclick="doAction('dcsRpsp');"><span class="txt">결재상신</span></button>
					</div>
				</div>
<%
}
else
if( form.get("snr_menu_dsc").equals("2") ){ //ORM팀장
%>						
				<div class="box-footer">
					<div class="btn-wrap">
						<button class="btn btn-primary" type="button" onclick="doAction('dczCmp');"><span class="txt">결재</span></button>
					</div>
				</div>
<%
}
%>
			</section>
		
		</form>
		</div>
		<!-- content //-->
		
	</div>
	
	<!-- popup -->
	<div id="winORSN0105" class="popup modal">
		<iframe name="ifrORSN0105" id="ifrORSN0105" src="about:blank"></iframe>
	</div>
	<script>
		// 결재팝업 연동 - 결재요청
		function DczSearchEndSub(){
			doSave();
		}
		// 결재팝업 연동 - 결재
		function DczSearchEndCmp(){
			doSave();
		}
		// 결재팝업 연동 - 반려
		function DczSearchEndRtn(){
			doSave();
		}
		// 결재팝업 연동 - 회수
		function DczSearchEndCncl(){
			doCncl();
		}
	</script>
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
</body>
</html>