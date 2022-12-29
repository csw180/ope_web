<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0129.jsp
 Program name : 중요리스크 선정목록 관리
 Description  : 화면정의서 RCSA-19
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
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"}; 
			initData.Cols = [
			 	{Header:"평가대상|평가대상",Type:"Text",Width:60,Align:"Center",SaveName:"hofc_bizo_dsnm",MinWidth:60,Edit:0},
				{Header:"리스크사례 ID|리스크사례 ID",Type:"Text",Width:120,Align:"Center",SaveName:"rkp_id",MinWidth:60,Edit:0},
				{Header:"업무프로세스|업무프로세스 LV1",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm1",MinWidth:50,Edit:0},
				{Header:"업무프로세스|업무프로세스 LV2",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm2",MinWidth:50,Edit:0},
				{Header:"업무프로세스|업무프로세스 LV3",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm3",MinWidth:50,Edit:0},
				{Header:"업무프로세스|업무프로세스 LV4",Type:"Text",Width:200,Align:"Left",SaveName:"prssnm4",MinWidth:50,Edit:0},
				{Header:"업무프로세스코드",Type:"Text",Width:0,Align:"Center",SaveName:"prss",MinWidth:0, Hidden:true},
				{Header:"리스크 사례|리스크 사례",Type:"Text",Width:200,Align:"Left",SaveName:"rk_isc_cntn",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"통제활동|통제활동",Type:"Text",Width:200,Align:"Left",SaveName:"cp_cntn",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"중요리스크\n여부|중요리스크\n여부",Type:"Text",Width:20,Align:"Center",SaveName:"krk_yn",MinWidth:60,Wrap:1,Edit:0},
				{Header:"중요리스크 선정사유|3년 이내 손실사건 발생",Type:"Text",Width:20,Align:"Center",SaveName:"krk_slt_bascd03",MinWidth:60,Wrap:1,Edit:0},
				{Header:"중요리스크 선정사유|1년이내 RCSA RED 등급 발생",Type:"Text",Width:20,Align:"Center",SaveName:"krk_slt_bascd04",MinWidth:60,Wrap:1,Edit:0},
				{Header:"중요리스크 선정사유|1년이내 연관 KRI RED 등급 발생",Type:"Text",Width:20,Align:"Center",SaveName:"krk_slt_bascd05",MinWidth:60,Wrap:1,Edit:0},
				{Header:"중요리스크 선정사유|1년이내 신규등록 리스크 사례",Type:"Text",Width:20,Align:"Center",SaveName:"krk_slt_bascd08",MinWidth:60,Wrap:1,Edit:0},
				{Header:"최초등록일|최초등록일",Type:"Text",Width:20,Align:"Left",SaveName:"reg_dt",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"최근변경일|최근변경일",Type:"Text",Width:20,Align:"Left",SaveName:"chg_dt",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				
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
			
			doAction('search');

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
					$("form[name=ormsForm] [name=process_id]").val("ORRC012902");

					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					
					
					
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
		
		function doDczProc(sAction) {

			switch(sAction) {
				case "evl":  //평가대상등록
					$("#input_ds").val("1"); //입력구분 1:평가대상등록
					doSave();
					break;
				case "exc":  //평가대상제외
					$("#input_ds").val("2"); //입력구분 2:평가대상제외
					doSave();
					break;
/* 				case "sub":  //상신 
					$("#input_ds").val("3"); //입력구분 3:상신
					$("#dcz_dc").val("02");
					$("#rtn_cntn").val("");
					var flag = false;
					var msg = "상신하시겠습니까?\n";
					if(!confirm(msg)) return;
					doAllSave();
					break;
				case "dcz":  //결재
					if(!confirm("결재하시겠습니까?")) return;

				$("#input_ds").val("4"); //입력구분 4:결재
					$("#dcz_dc").val("03");
					$("#rtn_cntn").val("");
					// 현재 결재의 경우 전체 다 결재한다. 선택만 결재 하려면 doSave() 로 변경한다. 
					doAllSave();
					break;
				case "ret":  //반려
					$("#input_ds").val("5"); //입력구분 5:반려
					$("#dcz_dc").val("01");
					$("#winRetMod").addClass("block");
					break;
 */
			}
		}

		function doSave() {
			
			if(mySheet.CheckedRows("ischeck") < 1)
			{
				alert("변경할 항목을 선택해주세요.");
				return;
			}
			if($("#rk_evl_prg_stsc").val()!="01")
			{
				alert("해당 기준년월이 '평가예정' 상태가 아닙니다.\n상태를 변경할 수 없습니다.");
			}else if($("#rk_evl_prg_stsc").val()=="01") 
			{
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
				mySheet.DoSave(url, { Param : "method=Main&commkind=rsa&process_id=ORRC012903&bas_ym="+$("#bas_ym").val()+"&input_ds="+$("#input_ds").val(), Col : 0 });
			}
		}
		
		function RetrunSave() {
			$("#winRetMod").removeClass("block");
			// 현재 반려의 경우 전체 다 반려한다. 선택만 반려 하려면 doSave() 로 변경한다. 
			doAllSave();
			
		}
		
		function mySheet_OnSaveEnd(code, msg) {
			
		    if(code >= 0) {
		        doAction("search"); 
		        alert("저장 되었습니다.")     
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}

		 

		function goSavEnd(){
			closePop();
			doAction('search');
		}
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction("search");
				return true;
			}else{
				return true;
			}
		}
		
		var init_flag = false;
		function org_popup1(){

			schOrgPopup("sch_brnm", "orgSearchEnd1");
			if($("#sch_brnm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;

		}
		
		// 부서검색 완료
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
		
		// 손실사건유형검색 완료
		var HPN3_ONLY = false; 
		var CUR_HPN_TPC = "";
		
		function hpn_popup(){
			CUR_HPN_TPC = $("#hpn_tpc").val();
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
			
			$("#hpn_tpc").val(hpn_tpc);
			$("#hpn_tpc_nm").val(hpn_tpnm);
			
			$("#winHpn").hide();
			//doAction('search');
		}
		
		// 업무프로세스검색 완료
		var PRSS4_ONLY = false; 
		var CUR_BSN_PRSS_C = "";
		
		function prss_popup(){
			CUR_BSN_PRSS_C = $("#bsn_prss_c").val();
			if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
			schPrssPopup();
		}

		// 업무프로세스검색 완료
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
			
			$("#bsn_prss_c").val(bsn_prss_c);
			$("#bsn_prss_nm").val(bsn_prsnm);
			
			$("#winPrss").hide();
			//doAction('search');
		}
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction("search");
				return true;
			}else{
				return true;
			}
		}
		
		function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		   if(KeyCode == 13) {
			 if(Row >= mySheet.GetDataFirstRow()){
			   if( mySheet.GetCellText(Row,"ischeck")==0)
			   	 {
			     	mySheet.SetCellText(Row,"ischeck",1);
			     }
			   else if ( mySheet.GetCellText(Row,"ischeck")==1)
			   	 {
			     	mySheet.SetCellText(Row,"ischeck",0);
			     }
			 }
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
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								
								<tr>
									<th scope="row"><label for="sch_krk_yn" class="control-label">중요리스크</label></th>
									<td>
										<span class="select">
											<select class="form-control" id="sch_krk_yn" name="sch_krk_yn" onkeypress="EnterkeySubmit();" >
												<option value="">전체</option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</span>
									</td>
									<th>업무프로세스</th>
									<td>
										<div class="input-group">
											<input type="hidden" id="bsn_prss_c" name="bsn_prss_c">
											<input type="text" class="form-control" id="bsn_prss_nm" name="bsn_prss_nm" readonly placeholder="전체" onkeypress="EnterkeySubmit();">
										  	<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"  onclick="prss_popup();" ><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
									<th scope="row"><label for="sch_reg_dt" class="control-label">등록일자</label></th>
										<td>
											<div class="input-group">
												<input type="text" class="form-control w100" id="sch_reg_st_dt" name="sch_reg_st_dt" readonly >
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_reg_st_dt_btn" name="sch_reg_st_dt_btn" onclick="showcalendar(1);"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
											<div class="input-group">
												<div class="input-group-addon"> ~ </div>
												<input type="text" class="form-control w100" id="sch_reg_ed_dt" name="sch_reg_ed_dt" readonly >
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_reg_ed_dt_btn" name="sch_reg_ed_dt_btn" onclick="showcalendar(2);"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</td>
								</tr>
								<tr>
									<th scope="row"><label for="sch_krk_cntn" class="control-label">선정사유</label></th>
									<td>
										<span class="select">
											<select class="form-control w200" id="sch_krk_cntn" name="sch_krk_cntn" onkeypress="EnterkeySubmit();" >
												<option value="">전체</option>
<%
	for(int i=0;i<vKrkSltBasLst.size();i++){
		HashMap hMap = (HashMap)vKrkSltBasLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</span>
									</td>
									<th>리스크 사례 ID</th>
									<td>
										<input type="text" class="form-control" id="rpk_id" name="rpk_id" onkeypress="EnterkeySubmit();">
									</td>

									<th scope="row"><label for="sch_chg_dt" class="control-label">변경일자</label></th>
									<td>
										<div class="input-group">
											<input type="text" class="form-control w100" id="sch_chg_st_dt" name="sch_chg_st_dt" readonly>
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico" id="sch_chg_st_dt_btn" name="sch_chg_st_dt_btn" onclick="showcalendar(3);" ><i class="fa fa-calendar"></i></button>
											</span>
										</div>
										<div class="input-group">
											<div class="input-group-addon"> ~ </div>
											<input type="text" class="form-control w100" id="sch_chg_ed_dt" name="sch_chg_ed_dt" readonly>
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico" id="sch_chg_ed_dt_btn" name="sch_chg_ed_dt_btn" onclick="showcalendar(4);" ><i class="fa fa-calendar"></i></button>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th>평가대상</th>
									<td>
										<span class="select">
											<select class="form-control" id="sch_hofc_bizo_dsc" name="sch_hofc_bizo_dsc" onkeypress="EnterkeySubmit();">
												<option value="">전체</option>
												<option value="02">본부부서</option>
												<option value="03">영업점</option>
											</select>
										</span>
									</td>
									<th>리스크 사례</th>
									<td>
										<input type="text" class="form-control" id="rk_isc_cntn" name="rk_isc_cntn" onkeypress="EnterkeySubmit();">
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div><!-- .box-body //-->
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- .search-area //-->
		</form>
			
			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls">1</i><span class="txt">엑셀 다운로드</span></button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h380">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
			</div>
<!-- 			 <div class="box">
				<p class="ph2">1.<span class="cm">'평가대상등록'</span>한 리스크만 평가대상으로 선정 됩니다. 반드시  <span class="cm">'평가대상등록'</span> 해주시기 바랍니다.</p>   
				<p class="ph2">2.<span class="cm">'평가일정관리'</span>메뉴에서  <span class="cm">'평가시작일'</span>을 설정하면 해당 일에 평가데이터를 생성합니다. 반드시 평가시작일을 설정해 주시기 바랍니다.</p>
			</div> -->
		</div><!-- .content //-->
	</div><!-- .container //-->
	<!-- .content-wrapper // -->
		
	<div id="winRetMod" class="popup modal">
		<div class="p_frame w600">
			<div class="p_head">
				<h3 class="title">반려 사유</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-grid">
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 100px;">
									<col>
								</colgroup>
								<tbody>									
									<tr>
										<th>반려 사유</th>
										<td>
											<textarea class="textarea" id="rtn_cntn" name="rtn_cntn" maxlength="255"></textarea>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-normal" onclick="RetrunSave();">반려</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
		</div>
		<div class="dim p_close"></div>
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