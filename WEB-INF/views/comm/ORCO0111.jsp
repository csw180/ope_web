<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0111.jsp
 Program name : 공통 > KRI공통팝업
 Description  : 
 Programer    : 박승윤
 Date created : 2022.06.17
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst2==null) vLst2 = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
	
		/*Sheet1 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		
			initData.Cols = [
				{Header:"RI ID",Type:"Text",Width:50,Align:"Center",SaveName:"rki_id",MinWidth:60,Edit:0},
				{Header:"지표명",Type:"Text",Width:250,Align:"Left",SaveName:"rkinm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표목적",Type:"Text",Width:300,Align:"Left",SaveName:"rki_obv_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표정의",Type:"Text",Width:300,Align:"Left",SaveName:"rki_def_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표산식",Type:"Text",Width:300,Align:"Left",SaveName:"idx_fml_cntn",Wrap:1,MinWidth:50,Edit:0},
				{Header:"단위",Type:"Text",Width:60,Align:"Center",SaveName:"kri_unt_nm",Wrap:1,MinWidth:20,Edit:0},
				{Header:"수집주기",Type:"Text",Width:60,Align:"Center",SaveName:"col_fq_nm",Wrap:1,MinWidth:50,Edit:0},
				{Header:"KRI 여부",Type:"Text",Width:60,Align:"Center",SaveName:"kri_yn",MinWidth:50,Edit:0},				
				{Header:"KRI속성",Type:"Text",Width:60,Align:"Left",SaveName:"rki_attr_nm",Wrap:1,MinWidth:50,Edit:0},
			];
			
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//doAction('search');
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				parent.kriSearchEnd($("#oprk_rki_id").val(),$("#oprk_rkinm").val(),$("#idx_fml_cntn").val(),$("#col_fq_nm").val() );
			}
		}
		
		function mySheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

			if(NewRow >= mySheet.GetDataFirstRow()){
				$("#oprk_rki_id").val(mySheet.GetCellValue(NewRow,"rki_id"));
				$("#oprk_rkinm").val(mySheet.GetCellValue(NewRow,"rkinm"));
				$("#idx_fml_cntn").val(mySheet.GetCellValue(NewRow,"idx_fml_cntn"));
				$("#col_fq_nm").val(mySheet.GetCellValue(NewRow,"col_fq_nm"));
			}
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR010102");

					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "select": 
					if($("#oprk_rki_id").val() == ""){
						alert("RI를 선택해 주십시오.");
						return;
					}
				
					parent.kriSearchEnd($("#oprk_rki_id").val(),$("#oprk_rkinm").val());
					break;
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
		}
		
/* 		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction("search");
				return true;
			}else{
				return true;
			}
		} */
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
<form name="ormsForm">
<input type="hidden" id="path" name="path" />               <!-- 공통 필수 선언 -->
<input type="hidden" id="process_id" name="process_id" />   <!-- 공통 필수 선언 -->
<input type="hidden" id="commkind" name="commkind" />       <!-- 공통 필수 선언 -->
<input type="hidden" id="method" name="method" />           <!-- 공통 필수 선언 -->
<input type="hidden" id="sch_cdc_kri_yn" name="sch_cdc_kri_yn" >
<input type="hidden" id="sch_fmrk_rel_yn" name="sch_fmrk_rel_yn" >
<input type="hidden" id="oprk_rki_id" name="oprk_rki_id" value="" />
<input type="hidden" id="oprk_rkinm" name="oprk_rkinm" value="" />
<input type="hidden" id="idx_fml_cntn" name=idx_fml_cntn value="" />
<input type="hidden" id="col_fq_nm" name="col_fq_nm" value="" />
<div id="rk_ctgr_c"></div>
<article class="popup modal block" >
	<div class="p_frame w1100">
		<div class="p_head">
			<h1 class="title">KRI 등록</h1>
		</div>
		<div class="p_body">
			<div class="p_wrap">
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
												<input type="text" class="form-control w120" id="sch_jrdt_brnm" name="sch_jrdt_brnm" onKeyPress="org_popup();" onKeyUp="delTxt();">
												<input type="hidden" id="sch_jrdt_brc" name="sch_jrdt_brc" value=""/>
												<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="sch_rpt_brnm_btn" onclick="org_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
												</span>
											</div>
										</td>
										<th>KRI여부</th>
										<td>
											<select class="form-control w80" id="sch_kri_yn" name="sch_kri_yn" >
												<option value="">전체</option>
											    <option value="Y">Y</option>
											    <option value="N">N</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>KRI 속성</th>
										<td>
											<select class="form-control w120"  id="sch_rki_attr_c" name="sch_rki_attr_c">
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
											<input type="text" class="form-control w300" id="sch_rkinm" name="sch_rkinm" value="" placeholder="리스크 지표명을 입력하여 주십시오." onkeypress="EnterkeySubmit(doAction, 'search');">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .box-body //-->
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
					</div>
				</div>
				<!-- 조회 //-->
				
				<section class="box box-grid">
					<div class="wrap-grid h450">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</section>
				
			</div><!-- .p_wrap //-->	
		</div><!-- .p_body //-->

		<div class="p_foot">
			<div class="btn-wrap">
				<button type="button" class="btn btn-primary" onclick="doAction('select');">선택</button>
				<button type="button" class="btn btn-default btn-close">취소</button>
			</div>
		</div>
		<button type="button" class="ico close  fix btn-close"><span class="blind">닫기</span></button>
	</div>
	<div class="dim p_close"></div>
</article>
<!-- popup //-->
</form>
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
<script>
	


	$(document).ready(function(){
		
		$("#winKri",parent.document).show();
		
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		//닫기
		$(".btn-close").click( function(event){
			parent.closeKri();
			event.preventDefault();
		});
		
		// ibsheet 초기화
		initIBSheet1();
	});
	
	// 평가부서
	function org_popup(){
		init_flag = false;
		schOrgPopup("sch_jrdt_brnm", "orgSearchEnd","1");
		if($("#sch_jrdt_brnm").val() == "" && init_flag){
			$("#ifrOrg").get(0).contentWindow.doAction("search");
		}
		init_flag = false;
	}

	// 평가부서검색 완료
	function orgSearchEnd(brc, brnm){
		if(brc=="") init_flag = true;
		$("#sch_jrdt_brc").val(brc);
		$("#sch_jrdt_brnm").val(brnm);
		$("#winBuseo").hide();
		//doAction('search');
	}
	
	function delTxt(){
		if($("#sch_jrdt_brnm").val() == "") $("#sch_jrdt_brc").val("");
	}

	
	function closePop(){
			$("#winKri",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#oprk_rki_id").val("");
			$("#rk_isc_cntn").val("");
			
			closePop();
		});
	
</script>
</body>
</html>