<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0203.jsp
 Program name : KRI > RI풀 관리 > RI조회(지주) > 수정
 Description  : 
 Programer    : 권성학
 Date created : 2021.06.25
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="org.json.simple.*,java.net.*" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Vector vRkiAttrLst = CommUtil.getCommonCode(request, "RKI_ATTR_C"); // 지표속성
	if(vRkiAttrLst==null) vRkiAttrLst = new Vector();
	Vector vColFqLst= CommUtil.getCommonCode(request, "COL_FQ"); // 수집주기코드
	if(vColFqLst==null) vColFqLst = new Vector();
	Vector vRptFqLst= CommUtil.getCommonCode(request, "RPT_FQ_DSC"); // 보고주기코드
	if(vRptFqLst==null) vRptFqLst = new Vector();
	Vector vRkiUntLst= CommUtil.getCommonCode(request, "RKI_UNT_C"); // 단위코드
	if(vRkiUntLst==null) vRkiUntLst = new Vector();
	Vector vRkiLvlLst= CommUtil.getCommonCode(request, "RKI_LVL_C"); // 지표수준
	if(vRkiLvlLst==null) vRkiLvlLst = new Vector();
	Vector vRkiInfoLst= CommUtil.getResultVector(request, "grp01", 0, "unit06", 0, "vList");	//공통리스크지표상세정보
	if(vRkiInfoLst==null) vRkiInfoLst = new Vector();
	
	HashMap hRkiMap = null;
	if(vRkiInfoLst.size()>0){
		hRkiMap = (HashMap)vRkiInfoLst.get(0);
	}else{
		hRkiMap = new HashMap();
	}
	
	Vector vComnRkiLst= CommUtil.getResultVector(request, "grp01", 0, "unit07", 0, "vList");	//계열사별공통KRI목록
	if(vComnRkiLst==null) vComnRkiLst = new Vector();
	
	JSONObject jsonObj = new JSONObject();
	JSONArray jsonlist = new JSONArray();
	
	HashMap<String, String> hRkiMppMap = new HashMap<String, String>();
	
	for(int i=0; i<vComnRkiLst.size(); i++){
		hRkiMppMap = (HashMap)vComnRkiLst.get(i);
		jsonlist.add(hRkiMppMap);
	}
	
	jsonObj.put("DATA", jsonlist);
	
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
			
		$(document).ready(function(){
			//$("#winRskMod",parent.document).show();
			// ibsheet 초기화
			parent.removeLoadingWs();
			initIBSheet1();
			initIBSheet2();
			
			$("#rki_attr_c").attr("disabled","true");
			$("#kri_yn").attr("disabled","true");
			$("#rki_lvl_c").attr("disabled","true");
		});
		
		/***************************************************************************************/
		/* 공통KRI(mySheet1) 처리                                                                                                                                       */
		/***************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData1 = {};
			
			initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
			initData1.Cols = [
				{Header:"상태",			Type:"Status",		SaveName:"status",			Hidden:true							},
				{Header:"선택",			Type:"CheckBox",	SaveName:"sel_check",		Width:60,	Align:"Center",	Edit:1	},
			    {Header:"계열사코드",		Type:"Text",		SaveName:"grp_org_c",		Hidden:true							},
			    {Header:"계열사명",		Type:"Text",		SaveName:"grp_orgnm",		Width:130,	Align:"Center",	Edit:0	},
			    {Header:"RI ID",		Type:"Text",		SaveName:"oprk_rki_id",		Width:100,	Align:"Center",	Edit:0	},
			    {Header:"공통RI ID",		Type:"Text",		SaveName:"comn_rki_id",		Width:100,	Align:"Center",	Edit:0	},
			    {Header:"지표명",			Type:"Text",		SaveName:"oprk_rkinm",		Width:350,	Align:"Left",	Edit:0	},
			    {Header:"KRI속성코드",		Type:"Text",		SaveName:"rki_attr_c",		Hidden:true							},
			    {Header:"KRI속성",		Type:"Text",		SaveName:"rki_attr_nm",		Width:130,	Align:"Center",	Edit:0	},
			];
			
			IBS_InitSheet(mySheet1,initData1);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(3);
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//최초 조회시 포커스를 감춘다.
			mySheet1.SetFocusAfterProcess(0);
			
			mySheet1.SetAutoRowHeight(1);
			
			//헤더기능 해제
			//mySheet1.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
	
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			mySheet1.LoadSearchData(<%=jsonObj%>);
		}
	
		/***************************************************************************************/
		/* 계열사별KRI(mySheet2) 처리                                                                                                                                       */
		/***************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet2() {
			//시트 초기화		
			mySheet2.Reset();
			
			var initData2 = {};
			
			initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
			initData2.Cols = [
				{Header:"상태",			Type:"Status",		SaveName:"status",			Hidden:true							},
				{Header:"선택",			Type:"CheckBox",	SaveName:"sel_check",		Width:60,	Align:"Center",	Edit:1	},
			    {Header:"계열사코드",		Type:"Text",		SaveName:"grp_org_c",		Hidden:true							},
			    {Header:"계열사명",			Type:"Text",		SaveName:"grp_orgnm",		Width:130,	Align:"Center",	Edit:0	},
			    {Header:"RI ID",		Type:"Text",		SaveName:"oprk_rki_id",		Width:100,	Align:"Center",	Edit:0	},
			    {Header:"지표명",			Type:"Text",		SaveName:"oprk_rkinm",		Width:350,	Align:"Left",	Edit:0	},
			    {Header:"KRI속성코드",		Type:"Text",		SaveName:"rki_attr_c",		Hidden:true							},
			    {Header:"KRI속성",		Type:"Text",		SaveName:"rki_attr_nm",		Width:130,	Align:"Center",	Edit:0	}
			];
			
			IBS_InitSheet(mySheet2,initData2);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(3);
			
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//최초 조회시 포커스를 감춘다.
			mySheet2.SetFocusAfterProcess(0);
			
			mySheet2.SetAutoRowHeight(1);
			
			//헤더기능 해제
			//mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
	
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet2);
		}
	
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {
	
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(mySheet1.GetDataFirstRow()>=0){
				}
			}
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		}
		
		function mySheet2_OnRowSearchEnd(row) {
			if (mySheet2.GetCellValue(row, "rki_attr_c") == "00"){
		    	mySheet2.SetCellEditable(row, "sel_check", 0);
			}
		}
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "insert":		//신규등록 팝업
					//추가처리;
					var row = mySheet1.DataInsert();
					mySheet1_OnChange(row,0,"");
	
					break; 
				case "delete":		//삭제 처리
					var srow = mySheet1.GetSelectRow();
				
					if(mySheet1.GetSelectRow() < 0){
						alert("삭제할 항목을 선택하세요.");
						return;
					}else{
						if(mySheet1.GetCellValue(srow,"ctl_cntn") == ""){
							mySheet1.RowDelete(mySheet1.GetSelectRow(), 0);	
						}else{
							mySheet1.RowDelete(mySheet1.GetSelectRow(), 1);
						}
					}
					
					break; 
				case "search2":
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR020202");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
	
					break;
				case "add":
					if(mySheet2.CheckedRows("sel_check") < 1){
						alert("하단 목록에서 추가할 항목을 선택해주세요.");
						return;
					}
					
					var sRow = mySheet2.FindCheckedRow("sel_check").split("|");
					
					for(var i=0;i<sRow.length;i++){
						if(mySheet2.GetCellValue(sRow[i],"rki_attr_c") == "00"){
							alert("KRI속성이 전계열사공통인 리스크지표는 등록할 수 없습니다.");
							return;
						}
					}
					
					//중복된 항목은 skip하기 위한 처리
					var cRow = "";
					for(var i=0;i<sRow.length;i++){
						var isok = true; //true면 cRow 변수에 하단그리드 체크된 Row번호 담기
						if(mySheet1.RowCount() > 0){
							for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
								if((mySheet1.GetCellValue(j,"grp_org_c") ==  mySheet2.GetCellValue(sRow[i],"grp_org_c"))
										&& (mySheet1.GetCellValue(j,"oprk_rki_id") ==  mySheet2.GetCellValue(sRow[i],"oprk_rki_id"))){
									isok = false;
									break;
								}
							}
						}else{
							isok = true;
						}
						if(isok) cRow = cRow + sRow[i] + "|";
					}
					
					if(cRow != ""){
						cRow = cRow.slice(0,-1); //마지막 "|" 없애기
						for(var i=0;i<cRow.split("|").length;i++){
							var iRow = mySheet1.DataInsert(999);
							mySheet1.SetCellValue(iRow,"grp_org_c", mySheet2.GetCellValue(cRow.split("|")[i],"grp_org_c"));
							mySheet1.SetCellValue(iRow,"grp_orgnm", mySheet2.GetCellValue(cRow.split("|")[i],"grp_orgnm"));
							mySheet1.SetCellValue(iRow,"oprk_rki_id", mySheet2.GetCellValue(cRow.split("|")[i],"oprk_rki_id"));
							mySheet1.SetCellValue(iRow,"comn_rki_id", $("#comn_rki_id").val());
							mySheet1.SetCellValue(iRow,"oprk_rkinm", mySheet2.GetCellValue(cRow.split("|")[i],"oprk_rkinm"));
							mySheet1.SetCellValue(iRow,"rki_attr_c", $("#rki_attr_c").val());
							mySheet1.SetCellValue(iRow,"rki_attr_nm", $("#rki_attr_c option:checked").text());
						}
					}
					
					mySheet2.CheckAll(1,0);
					mySheet2.SetSelectRow(-1);
					mySheet1.SetSelectRow(-1);
					
					break;
				case "minus":
					if(mySheet1.CheckedRows("sel_check") < 1){
						alert("상단 목록에서 제외할 항목을 선택해주세요.");
						return;
					}
					
					var sRow = mySheet1.FindCheckedRow("sel_check");			
					mySheet1.RowDelete(sRow);
					
					mySheet1.CheckAll(1,0);
					break;
					
				case "init":
					mySheet1.RemoveAll();
					mySheet1.LoadSearchData(<%=jsonObj%>);
					break;
			}
		}
	
		function save(){
			var f = document.ormsForm;
			var mpp_html = "";
	
			if(f.comn_rkinm.value == ""){
				alert("지표명을 입력해 주십시오.");
				f.comn_rkinm.focus();
				return;
			}
			
			if(f.rki_attr_c.value == ""){
				alert("KRI속성을 선택하십시오.");
				f.rki_attr_c.focus();
				return;
			}
	
			if(f.col_fq.value == ""){
				alert("수집주기를 선택하십시오.");
				f.col_fq.focus();
				return;
			}
			
			if(f.rki_unt_c.value == ""){
				alert("단위를 선택하십시오.");
				f.rki_unt_c.focus();
				return;
			}
			
			if(f.rki_lvl_c.value == ""){
				alert("지표수준을 선택하십시오.");
				f.rki_lvl_c.focus();
				return;
			}
			
			if(f.rki_obv_cntn.value == ""){
				alert("지표목적을 입력하십시오.");
				f.rki_obv_cntn.focus();
				return;
			}
			
			if(f.rki_def_cntn.value == ""){
				alert("지표정의를 입력하십시오.");
				f.rki_def_cntn.focus();
				return;
			}
			
			if(f.idx_fml_cntn.value == ""){
				alert("지표산식을 입력하십시오.");
				f.idx_fml_cntn.focus();
				return;
			}
			
			var grp_cnt = $("#sch_grp_org_c option").length-1;
			
			if(grp_cnt > mySheet1.RowCount()){
				/*  계열사별 1개씩 등록해야만 하는 요구사항 삭제됨
				alert("계열사별 공통KRI 등록이 필요합니다.");
				$("#sch_oprk_rki_id").focus();
				return;
				*/
			}else{
				for(var i=mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
					for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
						if(i != j && (mySheet1.GetCellValue(i,"grp_org_c") == mySheet1.GetCellValue(j,"grp_org_c"))){
							alert("계열사별로 1개의 리스크지표만 등록 가능합니다.");
							mySheet1.SetSelectRow(i);
							return;
						}
					}
				}	
			}
			
			if(mySheet1.GetDataFirstRow() > 0){
				for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
					mpp_html += "<input type='hidden' name='grp_org_c' value='" + mySheet1.GetCellValue(j,"grp_org_c") + "'>";
					mpp_html += "<input type='hidden' name='oprk_rki_id' value='" + mySheet1.GetCellValue(j,"oprk_rki_id") + "'>";
					mpp_html += "<input type='hidden' name='oprk_rkinm' value='" + mySheet1.GetCellValue(j,"oprk_rkinm") + "'>";
				}
			}
			mpp_area.innerHTML = mpp_html;
			
			if(!confirm("저장하시겠습니까?")) return;
	
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "kri");
			WP.setParameter("process_id", "ORKR020203");
			WP.setForm(f);
			
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert(result.rtnMsg);
							parent.doAction('search');
							closePop();
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction("search2");
				return true;
			}else{
				return true;
			}
		}
		
	</script>
</head>
<body>
	<div id="" class="popup modal block">
		<div class="p_frame w1100">
			<form name="ormsForm" method="post">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="mode" name="mode" value="U" />
			<div id="mpp_area"></div>
			<div class="p_head">
				<h3 class="title">공통 RI 상세조회(지주)</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="wrap-table">
						<table>
							<colgroup>
								<col style="width: 100px;">
								<col>
								<col style="width: 90px;">
								<col>
								<col style="width: 90px;">
								<col>
								<col style="width: 90px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th>공통RI-ID</th>
									<td>
										<input type="text" name="comn_rki_id" id="comn_rki_id" class="form-control" value="<%=(String)hRkiMap.get("comn_rki_id")%>" disabled>
									</td>
									<th>지표명</th>
									<td colspan="3">
										<input type="text" class="form-control" id="comn_rkinm" name="comn_rkinm" value="<%=(String)hRkiMap.get("comn_rkinm")%>" maxlength="100">
									</td>
									<th>KRI 속성</th>
									<td>
										<div class="select">
											<select class="form-control" name="rki_attr_c" id="rki_attr_c">
												<option value="">선택</option>
<%
		for(int i=0;i<vRkiAttrLst.size();i++){
			HashMap hMap1 = (HashMap)vRkiAttrLst.get(i);
			if(((String)hMap1.get("intgc")).equals((String)hRkiMap.get("rki_attr_c"))){
%>
												<option value="<%=(String)hMap1.get("intgc")%>" selected><%=(String)hMap1.get("intg_cnm")%></option>
<%		
			}else{
%>
												<option value="<%=(String)hMap1.get("intgc")%>"><%=(String)hMap1.get("intg_cnm")%></option>
<%
			}
		}
%>	
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th>수집주기</th>
									<td>
										<div class="select">
											<select class="form-control" name="col_fq" id="col_fq">
												<option value="">선택</option>
<%
		for(int i=0;i<vColFqLst.size();i++){
			HashMap hMap2 = (HashMap)vColFqLst.get(i);
			if(((String)hMap2.get("intgc")).equals((String)hRkiMap.get("col_fq"))){
%>
												<option value="<%=(String)hMap2.get("intgc")%>" selected><%=(String)hMap2.get("intg_cnm")%></option>
<%		
			}else{
%>
												<option value="<%=(String)hMap2.get("intgc")%>"><%=(String)hMap2.get("intg_cnm")%></option>
<%
			}
		}
%>	
											</select>
										</div>
									</td>
									<th>단위</th>
									<td>
										<div class="select">
											<select class="form-control" name="rki_unt_c" id="rki_unt_c">
												<option value="">선택</option>
<%
		for(int i=0;i<vRkiUntLst.size();i++){
			HashMap hMap4 = (HashMap)vRkiUntLst.get(i);
			if(((String)hMap4.get("intgc")).equals((String)hRkiMap.get("rki_unt_c"))){
%>
												<option value="<%=(String)hMap4.get("intgc")%>" selected><%=(String)hMap4.get("intg_cnm")%></option>
<%		
			}else{
%>
												<option value="<%=(String)hMap4.get("intgc")%>"><%=(String)hMap4.get("intg_cnm")%></option>
<%
			}
		}
%>
											</select>
										</div>
									</td>
									<th>KRI여부</th>
									<td>
										<div class="select">
											<select class="form-control" id="kri_yn" name="kri_yn">
												<option value="Y" selected>Y</option>
												<option value="N">N</option>
											</select>
										</div>
									</td>
									<th>지표수준</th>
									<td>
										<div class="select">
											<select class="form-control" name="rki_lvl_c" id="rki_lvl_c">
												<option value="">선택</option>
<%
		for(int i=0;i<vRkiLvlLst.size();i++){
			HashMap hMap5 = (HashMap)vRkiLvlLst.get(i);
			if(((String)hMap5.get("intgc")).equals((String)hRkiMap.get("rki_lvl_c"))){
%>
												<option value="<%=(String)hMap5.get("intgc")%>" selected><%=(String)hMap5.get("intg_cnm")%></option>
<%		
			}else{
%>
												<option value="<%=(String)hMap5.get("intgc")%>"><%=(String)hMap5.get("intg_cnm")%></option>
<%
			}
		}
%>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th>지표목적</th>
									<td colspan="7">
										<input type="text" name="rki_obv_cntn" id="rki_obv_cntn" class="form-control" maxlength="1000" value="<%=(String)hRkiMap.get("rki_obv_cntn")%>">
									</td>
								</tr>
								<tr>
									<th>지표정의</th>
									<td colspan="7">
										<textarea name="rki_def_cntn" id="rki_def_cntn" class="textarea h100" maxlength="500"><%=StringUtil.htmlEscape((String)hRkiMap.get("rki_def_cntn"),false,false)%></textarea>
									</td>
								</tr>
								<tr>
									<th>지표산식</th>
									<td colspan="7">
										<textarea name="idx_fml_cntn" id="idx_fml_cntn" class="textarea h100" maxlength="500"><%=StringUtil.htmlEscape((String)hRkiMap.get("idx_fml_cntn"),false,false)%></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="box box-grid">
						<div class="box-header">
							<h4 class="title md">계열사 별 공통 KRI 목록</h4>
						</div>
						<div class="box-body">
							<div class="wrap-grid h200">
								<script> createIBSheet("mySheet1", "100%", "100%"); </script>
							</div>
						</div>
						<div class="btn-wrap">
							<button type="button" class="btn btn-normal btn-xs" onclick="doAction('init')">
								<i class="fa fa-mail-reply"></i>
								<span class="txt">초기화</span>
							</button>
							<button type="button" class="btn btn-primary btn-xs" onclick="doAction('add')">
								<i class="fa fa-chevron-up"></i>
								<span class="txt">등록</span>
							</button>
							<button type="button" class="btn btn-default btn-xs" onclick="doAction('minus')">
								<i class="fa fa-chevron-down"></i>
								<span class="txt">제외</span>
							</button>
						</div>
						<div class="box-header">
							<h4 class="title">계열사 별 공통 KRI 등록하기</h4>
							<div class="area-tool">
								<div class="wrap-search ib">
									<table>
										<tr>
											<th>계열사명</th>
											<td>
												<div class="select w150">
													<select class="form-control" name="sch_grp_org_c" id="sch_grp_org_c">
														<option value="">전체</option>
<%
		for(int i=0;i<vGrpList.size();i++){
			HashMap hMap = (HashMap)vGrpList.get(i);
%>
														<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
<%
		}
%>
													</select>
												</div>
											</td>
											<th>RI-ID</th>
											<td>
												<input type="text" name="sch_oprk_rki_id" id="sch_oprk_rki_id" class="form-control w80" maxlength="5" onkeypress="EnterkeySubmit();">
											</td>
											<th>지표명</th>
											<td>
												<input type="text" name="sch_oprk_rkinm" id="sch_oprk_rkinm" class="form-control w200" maxlength="100" onkeypress="EnterkeySubmit();">
											</td>
										</tr>
									</table>
								</div>
								<button type="button" class="btn btn-primary btn-sm" onclick="javascript:doAction('search2');">
									<span class="txt">조회</span>
								</button>
							</div>
						</div>
						<div class="box-body">
							<div class="wrap-grid h200">
								<script> createIBSheet("mySheet2", "100%", "100%"); </script>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="javascript:save();">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
			</form>
		</div>
		<div class="dim p_close"></div>
	</div>
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				parent.$("#ifrRkiMod").attr("src","about:blank");
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winRkiMod",parent.document).hide();
			parent.$("#ifrRkiMod").attr("src","about:blank");
		}
	</script>
</body>
</html>