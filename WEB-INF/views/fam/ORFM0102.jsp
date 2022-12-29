<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0102.jsp
 Program name : 평판리스크 지표 신규등록 팝업
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
DynaForm form = (DynaForm)request.getAttribute("form");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getCommonCode(request, "RPT_FQ_DSC"); // (TB_OR_OM_CODE)
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getCommonCode(request, "REP_TYP_DSCD"); // (TB_OR_OM_CODE)
if(vLst3==null) vLst3 = new Vector();
Vector vLst4= CommUtil.getCommonCode(request, "SUP_BRC"); // (TB_OR_OM_CODE)
if(vLst4==null) vLst4 = new Vector();
HashMap hMap = null;
if(vLst.size()>0){
	hMap = (HashMap)vLst.get(0);
}else{
	hMap = new HashMap();
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			initIBSheet();
		});
 		/* Sheet 기본 설정 */
		function initIBSheet() {
				//시트 초기화
				mySheet3.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"선택",						Type:"CheckBox",Width:100,Align:"Center",SaveName:"ischeck",Wrap:1,MinWidth:50,Edit:1},
				{Header:"지표ID",						Type:"Text",Width:100,Align:"Center",SaveName:"oprk_rki_id",Wrap:1,MinWidth:70,Edit:0,Hidden:true},
				{Header:"지표명",						Type:"Text",Width:200,Align:"Center",SaveName:"rki_nm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표산식",					Type:"Text",Width:400,Align:"Center",SaveName:"idx_fml_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"수집단위",					Type:"Text",Width:100,Align:"Center",SaveName:"col_fq_nm",Wrap:1,MinWidth:20,Edit:0},
				{Header:"주관부서",					Type:"Text",Width:100,Align:"Center",SaveName:"br_nm",Wrap:1,MinWidth:20,Edit:0},
				];
				
			IBS_InitSheet(mySheet3,initData);
			
			//필터표시
			//mySheet3.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet3.SetCountPosition(3);
			
			mySheet3.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:1});
			//mySheet3.SetAutoRowHeight(5);

			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet3.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet3);
			
			doAction('search');
				
			}
 		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		function mySheet3_OnSelectMenu(text,code){
			alert('onselectmenu!');
			if(text=="엑셀다운로드"){
				doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction("loadexcel");
			}
		}
		function mySheet3_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
			$("#kri_cnt").text(mySheet3.RowCount()); 
			//$(".p_body").scrollTop(0);
			
			//mySheet3.FitColWidth();
			parent.removeLoadingWs();
			
		}
		function delRelKri(){
			//체크된 행이 있는지 찾아본다.
			var rows = mySheet3.FindCheckedRow("ischeck");

			if(rows==""){
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				
				mySheet3.RowDelete(rows);
				
			}
			
			$("#kri_cnt").text(mySheet3.RowCount());
		}
		function mySheet3_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert('ondbclick!');
			
		}
		function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert('onclick!');
			
		}
		function doAction(sAction) {
			switch(sAction) {
				case "reload":  //조회데이터 리로드
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "del":      //삭제
					var srow = mySheet.GetSelectRow();
					
					if(srow < 0) {
						alert("삭제할 항목을 선택하세요.");
						return;
					}
					if(!confirm("삭제하시겠습니까?")) return;
					
					//업무프로세스 사용부서 조회
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "fam");
					WP.setParameter("process_id", "ORFM010103");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("삭제되었습니다.");
								//mySheet.RowDelete(srow, 0);
								mySheet.SetSelectRow(-1);
								init();
								doAction("search"); 
								
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
					break;	
				case "save":
					//alert(mySheet3.GetDataLastRow());
					if(mySheet3.GetDataLastRow()=='-1' && $("#sch_kri_yn").val()=='Y' ){
						alert('기존 KRI 여부가 Y인 경우 연관 KRI를 등록해야 합니다.')
						return;
					}
					if(!confirm("저장하시겠습니까?")) return;
					
					var f = document.ormsForm;
					var add_html = "";
					for(var j=mySheet3.GetDataFirstRow(); j<=mySheet3.GetDataLastRow(); j++){
						add_html += "<input type='hidden' name='sch_oprk_rki_id' value='" + mySheet3.GetCellValue(j,"oprk_rki_id") + "'>";
					}
					
					tmp_area.innerHTML = add_html;
					
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "fam");
					WP.setParameter("process_id", "ORFM010202");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					//alert(inputData);
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("저장되었습니다.");
								removeLoadingWs();
								parent.doAction('search');
								objCopy(result.Result.new_code);
							}else if(result!='undefined'){
								alert("저장되었습니다.")
								removeLoadingWs();
								parent.doAction('search');
							}else if(result=='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
					break;
			}
		}
		function delRelKri(){
			//체크된 행이 있는지 찾아본다.
			var rows = mySheet3.FindCheckedRow("ischeck");

			if(rows==""){
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				
				mySheet3.RowDelete(rows);
				
			}
			
			$("#kri_cnt").text(mySheet3.RowCount());
		}
		function hideSheet(){
			if($("#sch_kri_yn").val() == 'N') {
				$("#sheet_div").hide();
			}
			else{
				$("#sheet_div").show();
			}
		}

		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<article class="popup modal block" > 
		<div class="p_frame w1000"> 
			<div class="p_head">
				<h1 class="title">평판지표 신규 등록</h1>
			</div>
			<div class="p_body"> 
				<div class="p_wrap">  
					<form name="ormsForm" method="post">
						<input type="hidden" id="path" name="path" />             
						<input type="hidden" id="process_id" name="process_id" />  
						<input type="hidden" id="commkind" name="commkind" />       
						<input type="hidden" id="method" name="method" />   
						<input type="hidden" id="tmp_area" name="tmp_area" />            
						<div id="hdng_area"></div>  
						<div id="brcd_area"></div>
					
						<section class="box-grid">
							<div class="box-header">
								<h2 class="box-title">평판지표 등록</h2>
							</div>	
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 100px;">
										<col>
										<col style="width: 100px;">
										<col>
										<col style="width: 100px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>평판지표-ID</th>
											<td>
												<input type="text" class="form-control" id="sch_rki_id" name="sch_rki_id" value="<%=(String)hMap.get("rki_id")%>" disabled/>
											</td>																	
											<th>지표명</th>
											<td colspan="3">
												<input type="text" class="form-control" id="sch_rkinm" name="sch_rkinm" value="" placeholder="평판지표명을 입력해 주십시오" />
											</td>
										</tr>
										<tr>
											<th>유형 구분</th>
											<td>
														<select class="form-control"  id="sch_typnm" name="sch_typnm">
															<option value="" disabled selected>선택</option>
	<%
		for(int i=0;i<vLst3.size();i++){
			HashMap hMap3 = (HashMap)vLst3.get(i);
			if(((String)hMap3.get("intgc")).equals((String)hMap.get("rep_typ_dscd"))){
	%>
													   		<option value="<%=(String)hMap3.get("intgc")%>" selected><%=(String)hMap3.get("intg_cnm")%></option>
	<%
	
		}else{
	%>	
														    <option value="<%=(String)hMap3.get("intgc")%>"><%=(String)hMap3.get("intg_cnm")%></option>
	<%}
}
	%>
														</select>
												
											</td>	
											<th>주관 부서</th>
											<td colspan="3">
														<select class="form-control"  id="sch_sup_brc" name="sch_sup_brc">
															<option value="" disabled selected>선택</option>
	<%
		for(int i=0;i<vLst4.size();i++){
			HashMap hMap4 = (HashMap)vLst4.get(i);
			if(((String)hMap4.get("intgc")).equals((String)hMap.get("sup_brc"))){
	%>
													   		<option value="<%=(String)hMap4.get("intgc")%>" selected><%=(String)hMap4.get("intg_cnm")%></option>
													   		
	<%
	
		}else{
	%>	
														    <option value="<%=(String)hMap4.get("intgc")%>"><%=(String)hMap4.get("intg_cnm")%></option>
	<%}
}
	%>
														</select>
												
											</td>		
										</tr>
										<tr>
											<th>지표 산식</th>
											<td colspan="5">
												<textarea id="sch_fml_idx_cntn" name="sch_fml_idx_cntn" cols="20" rows="3" class="form-control textarea" placeholder="평판 지표 산식을 입력해 주십시오"></textarea>
											</td>
										</tr>
										<tr>
											<th>수집주기</th>
											<td>
														<select class="form-control"  id="sch_fq_dsc" name="sch_fq_dsc">
															<option value="" disabled selected>선택</option>
	<%
		for(int i=0;i<vLst2.size();i++){
			HashMap hMap2 = (HashMap)vLst2.get(i);
	%>
													   		<option value="<%=(String)hMap2.get("intgc")%>"><%=(String)hMap2.get("intg_cnm")%></option>
	<%
}
	%>
														</select>
												
											</td>																
												<th>지표 추출 방식</th>
											<td>
												<select class="form-control" id = "sch_psb_yn" name = "sch_psb_yn">
													<option value="" disabled selected>선택</option>
													<option value="Y">전산</option>
													<option value="N">수기</option>
												</select>
											</td>
											<th>기존 KRI 여부</th>
											<td>
												<select class="form-control" id="sch_kri_yn" name="sch_kri_yn" onchange="hideSheet()">
													<option value="" disabled selected>선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
							</div><!-- .wrap-table //-->
							<div  class="box box-grid" id="sheet_div" style="display:none">
								<div class="box-header">
									<h3 class="box-title" align="center" >연관 KRI 등록</h3>
									<div class="area-tool" style="float:right">
										<button type="button" class="btn btn-default btn-xs" id="add_btn" name="add_btn" onClick="kripool_popup()"><i class="fa fa-plus"></i><span class="txt">연관 KRI 등록</span></button>
										<button type="button" class="btn btn-default btn-xs" onclick="delRelKri()"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>

									</div>
								</div>
								<div class="wrap-grid h200">
									<script type="text/javascript"> createIBSheet("mySheet3", "100%", "100%"); </script>
								</div>
							</div>
						</section>
					</form>						
				</div><!-- .p_wrap //-->			  
			</div>    <!-- .p_body //-->
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onClick="javascript:doAction('save');">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div> 
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div> 
	</article>  
	<div id='winKri' class='popup modal'>
		<iframe id='ifrKri' src="about:blank" name='ifrKri' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
	</div>
		  
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 		  
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 팝업 --> 	
	<%@ include file="../comm/KriP.jsp" %> <!-- KRI 공통 팝업 -->	  
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winNewAccAdd",parent.document).hide();
		}
	</script>
	<script>
	var CUR_RKI_ID = "";
	
	function kripool_popup(){
		CUR_RKI_ID = $("#oprk_rki_id").val();
		schKriPopup();
	}
	function kriSearchEnd(oprk_rki_id, oprk_rkinm, idx_fml_cntn, col_fq_nm){
		mySheet3.DataInsert(-1);
		mySheet3.SetCellValue(mySheet3.RowCount(), "oprk_rki_id", oprk_rki_id);
		mySheet3.SetCellValue(mySheet3.RowCount(), "rki_nm", oprk_rkinm);
		mySheet3.SetCellValue(mySheet3.RowCount(), "idx_fml_cntn", idx_fml_cntn);
		mySheet3.SetCellValue(mySheet3.RowCount(), "col_fq_nm", col_fq_nm);

		$("#winKri").hide(); 
	}
		
	
	</script>
</body>	 	
</html>