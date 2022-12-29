<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0101.jsp
 Program name : 리스크풀 조회/관리
 Description  : 화면정의서 RCSA-02
 Programer    : 박승윤	
 Date created : 2022.06.16
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vFqLst = CommUtil.getCommonCode(request, "RPT_FQ_DSC");
if(vFqLst==null) vFqLst = new Vector();
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
			
			initData.Cfg = {MergeSheet:msHeaderOnly,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			initData.Cols = [
			 	{Header:"선택",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50,Edit:1},
				{Header:"리스크사례 ID",Type:"Text",Width:120,Align:"Center",SaveName:"rkp_id",MinWidth:60,Edit:0},
				{Header:"평가부서",Type:"Text",Width:160,Align:"Center",SaveName:"dept_brnm",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"팀",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:60,Edit:0},
				{Header:"업무프로세스 LV1",Type:"Text",Width:150,Align:"Left",SaveName:"prssnm1",MinWidth:60,Edit:0},
				{Header:"업무프로세스 LV2",Type:"Text",Width:150,Align:"Left",SaveName:"prssnm2",MinWidth:60,Edit:0},
				{Header:"업무프로세스 LV3",Type:"Text",Width:150,Align:"Left",SaveName:"prssnm3",MinWidth:60,Edit:0},
				{Header:"업무프로세스 LV4",Type:"Text",Width:200,Align:"Left",SaveName:"prssnm4",MinWidth:60,Edit:0},
				{Header:"업무프로세스코드",Type:"Text",Width:0,Align:"Center",SaveName:"prss",MinWidth:0, Hidden:true},
				{Header:"손실사건 유형 LV1",Type:"Text",Width:150,Align:"Left",SaveName:"hpnnm1",MinWidth:60,Edit:0, Hidden:true},
				{Header:"손실사건 유형 LV2",Type:"Text",Width:150,Align:"Left",SaveName:"hpnnm2",MinWidth:60,Edit:0, Hidden:true},
				{Header:"손실사건 유형 LV3",Type:"Text",Width:200,Align:"Left",SaveName:"hpnnm3",MinWidth:60,Edit:0, Hidden:true},
				{Header:"손실사건 유형 코드 LV3",Type:"Text",Width:0,Align:"Center",SaveName:"hpn_tpc_lv3",MinWidth:0, Hidden:true},
				{Header:"RP 유형",Type:"Text",Width:100,Align:"Left",SaveName:"rkp_tpc_nm",MinWidth:60,Edit:0, Hidden:true},
				{Header:"리스크 사례",Type:"Text",Width:500,Align:"Left",SaveName:"rk_isc_cntn",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"통제활동",Type:"Text",Width:500,Align:"Left",SaveName:"cp_cntn",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"최초등록일",Type:"Text",Width:20,Align:"Left",SaveName:"reg_dt",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"최근변경일",Type:"Text",Width:20,Align:"Left",SaveName:"chg_dt",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"평가주기",Type:"Text",Width:20,Align:"Center",SaveName:"rpt_fq_dscnm",MinWidth:60,Wrap:1,MultiLineText:1,Edit:0},
				{Header:"수정",Type:"Html",Width:60,Align:"Center",SaveName:"update",MinWidth:60,Edit:0}
			];
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//mySheet.SetEditable(0);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			//mySheet.SetSelectionMode(4);
			
			//mySheet.SetAutoRowHeight(1);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search');
			//mySheet.SetTheme("WHM", "ModernWhite");
			//mySheet.SetTheme("GM", "Main");
		}

		
		function mySheet_OnRowSearchEnd (Row) {
			mySheet.SetCellText(Row,"update",'<button class="btn btn-xs btn-default" type="button" onclick="update('+Row+')"><span class="txt">수정</span><i class="fa fa-angle-right"></i></button>')
		}
		
		function update(Row){
			$("#rkp_id").val(mySheet.GetCellValue(Row,"rkp_id"));
			doAction('mod');
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			if(Row >= mySheet.GetDataFirstRow()){
				//alert(mySheet.GetCellValue(Row,"rkp_id"));
				$("#rkp_id").val(mySheet.GetCellValue(Row,"rkp_id"));
				doAction('mod');
				//$("#winRskMod").show();
				//modRisk();
			}
		}

		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet.GetDataFirstRow()){
				$("#rkp_id").val(mySheet.GetCellValue(Row,"rkp_id"));
			}
		}
		
		function addRisk(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="rsa";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORRC010201";
			f.target = "ifrRskAdd";
			f.submit();

		}
		
		function modRisk(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="rsa";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORRC010301";
			f.target = "ifrRskMod";
			f.submit();
		}

		function delRisk(){
			var f = document.ormsForm;
			var del_html = "";
			if(mySheet.GetDataFirstRow()>=0){
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(mySheet.GetCellValue(j,"ischeck")==1){
						del_html += "<input type='hidden' name='del_rkp_id' value='" + mySheet.GetCellValue(j,"rkp_id") + "'>";
					}
				}
			}
			
			//alert(del_html)
			
			if(del_html==""){
				alert("삭제할 리스크를 선택하세요.");
				return;
			}
			del_area.innerHTML = del_html;
			
			if(!confirm("선택한 리스크를 삭제 하시겠습니까?")) return;
				
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC010103");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			  {
				  success: function(result){
					  alert("삭제되었습니다.");
					  doAction("search");
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			});
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
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC010102");
/*					
					var f = document.ormsForm;
			        f.action=url;
					f.target = "_self";
					f.submit();
*/					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "save":      //저장할 데이터 추출
				/*
					//var str = mySheet.GetSaveString();
					var parameter = FormQueryStringEnc(document.ormsForm);
					//alert(parameter);
					var opt = {Param:parameter, Quest:1};
					//alert(mySheet.GetSaveString());
					//mySheet.DoAllSave(url + "&process_id=saveOrmsSchedule",parameter);
					var rtnData = mySheet.GetSaveData(url + "&process_id=saveOrmsSchedule",parameter);
					//alert(mySheet.LoadSaveData(rtnData);

					var data = $.parseJSON(rtnData);
					alert(data.rtnMsg);
					if(data.rtnCode=='0'){
						doAction("search");
					}
				*/	
					break;
				case "selbrc":		//조직선택 팝업
					$("#winRskAdd").show();
					addRisk();
						
					break; 
				case "add":		//신규등록 팝업
					$("#ifrRskAdd").attr("src","about:blank");
					$("#winRskAdd").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(addRisk,1);
					
					break; 
				case "mod":		//수정 팝업
					if($("#rkp_id").val() == ""){
						alert("대상 리스크를 선택하세요.");
						return;
					}else{
						
						$("#ifrRskMod").attr("src","about:blank");
						$("#winRskMod").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modRisk,1);
						//modRisk();
					}
					break; 
				case "del":		//삭제 처리
					delRisk();
					break; 
				case "down2excel":
					
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "리스크풀.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"1|2|3|4|5|6|7|14|15|16|17|18"} ;
					mySheet.Down2Excel(params);
					
					break;
			}
		}

		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			if(mySheet.RowCount() > 0){
				$("#pool_cnt").text(setFormatCurrency((mySheet.RowCount()).toString(),","));
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
<body onkeyPress="return EnterkeyPass()">
	<div class="container">
		<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>

		<div class="content">
			<form id="ormsForm" name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="rkp_id" name="rkp_id" value="" />
				<input type="hidden" id="sch_hd_bsn_prss_c" name="sch_hd_bsn_prss_c" />
				<input type="hidden" id="sch_hd_hpn_tpc" name="sch_hd_hpn_tpc" value="" />
				<input type="hidden" id="sch_hd_cas_tpc" name="sch_hd_cas_tpc" value="" />
				<input type="hidden" id="sch_hd_ifn_tpc" name="sch_hd_ifn_tpc" value="" />
				<input type="hidden" id="sch_hd_emrk_tpc" name="sch_hd_emrk_tpc" value="" />
				<div id="del_area"></div>
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th scope="row"><label for="sch_hd_bsn_prss_c_nm" class="control-label">업무프로세스</label></th>
										<td>
											<div class="input-group w200">											
												<input type="text" class="form-control" id="sch_hd_bsn_prss_c_nm" name="sch_hd_bsn_prss_c_nm"  value=""  placeholder="전체" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="prss_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>
											</div>
										</td>
										<th scope="row"><label for="sch_hd_cas_tpc_nm" class="control-label">원인유형</label></th>
										<td>
											<div class="input-group w200">	
												<input type="text" class="form-control"  id="sch_hd_cas_tpc_nm" name="sch_hd_cas_tpc_nm" readonly value=""  placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="cas_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_hd_hpn_tpc_nm" class="control-label">사건유형</label></th>
										<td>
											<div class="input-group w200">	
												<input type="text" class="form-control"  id="sch_hd_hpn_tpc_nm" name="sch_hd_hpn_tpc_nm" readonly value=""  placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="hpn_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_reg_dt" class="control-label">등록일자</label></th>
										<td>
											<div class="input-group">
												<input type="text" class="form-control w100" id="sch_reg_st_dt" name="sch_reg_st_dt" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_reg_st_dt_btn" name="sch_reg_st_dt_btn" onclick="showcalendar(1);"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
											<div class="input-group">
												<div class="input-group-addon"> ~ </div>
												<input type="text" class="form-control w100" id="sch_reg_ed_dt" name="sch_reg_ed_dt" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="sch_reg_ed_dt_btn" name="sch_reg_ed_dt_btn" onclick="showcalendar(2);"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</td>		
									</tr>
									<tr>
										<th scope="row"><label for="sch_hd_ifn_tpc_nm" class="control-label">영향유형</label></th>
										<td>
											<div class="input-group w200">	
												<input type="text" class="form-control"  id="sch_hd_ifn_tpc_nm" name="sch_hd_ifn_tpc_nm" readonly value=""  placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico fl" onclick="ifn_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_hd_emrk_tpc_nm" class="control-label">이머징리스크유형</label></th>
										<td>
											<div class="input-group w200">	
												<input type="text" class="form-control" id="sch_hd_emrk_tpc_nm" name="sch_hd_emrk_tpc_nm" readonly value="" placeholder="전체">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="emrk_popup();">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_st_rkp_tpc" class="control-label">평가대상</label></th>
										<td>
											<span class="select">
												<select class="form-control" id="sch_st_rkp_tpc" name="sch_st_rkp_tpc" >
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
										<th scope="row"><label for="sch_brnm" class="control-label">평가부서/팀</label></th>
										<td>
											<div class="input-group w200">
												<input type="hidden" id="sch_brc" name="sch_brc" value=""/>	
												<input type="text" class="form-control" id="sch_brnm" name="sch_brnm"  onKeyPress="EnterkeySubmitOrg('sch_brnm', 'orgSearchEnd');" readonly   placeholder="전체" />
												<span class="input-group-btn">
													<button class="btn btn-default ico" type="button" onclick="schOrgPopup('sch_brnm', 'orgSearchEnd');">
													<i class="fa fa-search"></i><span class="blind">검색</span>	
													</button>
												</span>										
											</div>
										</td>
										<th scope="row"><label for="sch_krp_id" class="control-label">리스크 사례 ID</label></th>
										<td>
											<input type="text" class="form-control" id="sch_rkp_id" name="sch_rkp_id" onkeypress="EnterkeySubmit();">
										</td>
										<th scope="row"><label for="" class="control-label">리스크 사례</label></th>
										<td>
											<input type="text" class="form-control" id="sch_rk_isc_cntn" name="sch_rk_isc_cntn" onkeypress="EnterkeySubmit();">
										</td>
										<th scope="row"><label for="sch_rkp_fq" class="control-label">평가주기</label></th>
										<td>
											<span class="select">
												<select class="form-control" id="sch_rkp_fq" name="sch_rkp_fq" >
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
										<th scope="row"><label for="sch_krk_yn" class="control-label">중요리스크 여부</label></th>
										<td>
											<span class="select">
												<select class="form-control" id="sch_krk_yn" name="sch_krk_yn" >
													<option value="">전체</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
											</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div><!-- .wrap-search -->
					</div><!-- .box-body //-->
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onClick="javascript:doAction('search');">조회</button>
					</div>
				</div><!-- .box-search //-->
				<!-- 조회 //-->
			</form>
			<div class="box box-grid mt30">
				<div class="box-header">
					<h3 class="box-title">조회결과</h3>
					<div class="area-tool">
						<div class="btn-group">
							<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('add');"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
							<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
						</div>
						<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<!-- /.box-header -->
				<div class="box-body">
					<div class="wrap-grid h450">
						<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
					</div><!-- .wrap //-->
				</div><!-- .box-body //-->
			</div><!-- .box //-->
		</div><!-- .content //-->
	</div><!-- .container //-->		
	<!-- popup -->
	<div id="winRskAdd" class="popup modal">
		<iframe name="ifrRskAdd" id="ifrRskAdd" src="about:blank"></iframe>
	</div>
	<div id="winRskAdd2" class="popup modal" >
		<iframe name="ifrRskAdd2" id="ifrRskAdd2" src="about:blank"></iframe>
	</div>
	<div id="winRskMod" class="popup modal">
		<iframe name="ifrRskMod" id="ifrRskMod" src="about:blank"></iframe>
	</div>
	<div id="winRskMod2" class="popup modal">
		<iframe name="ifrRskMod2" id="ifrRskMod2" src="about:blank"></iframe>
	</div>
	<iframe name="ifrDummy" id="ifrDummy" src="about:blank" width="0" height="0" ></iframe>
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
</body>
</html>