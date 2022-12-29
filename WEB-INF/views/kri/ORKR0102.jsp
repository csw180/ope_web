<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0102.jsp
 Program name : KRI 리스크지표 상세
 Description  : 화면정의서 KRI-01.2
 Programer    : 정현식
 Date created : 2022.06.03
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
DynaForm form = (DynaForm)request.getAttribute("form");

Vector vLst2= CommUtil.getCommonCode(request, "RKI_ATTR_C"); // 지표속성
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getCommonCode(request, "RKI_LVL_C"); // 지표수준
if(vLst3==null) vLst3 = new Vector();
Vector vLst4= CommUtil.getCommonCode(request, "RKI_UNT_C"); // 단위코드
if(vLst4==null) vLst4 = new Vector();
Vector vLst5= CommUtil.getCommonCode(request, "COL_FQ"); // 수집주기코드
if(vLst5==null) vLst5 = new Vector();
Vector vLst6= CommUtil.getCommonCode(request, "RPT_FQ_DSC"); // 보고주기코드
if(vLst6==null) vLst6 = new Vector();
Vector vLst7= CommUtil.getCommonCode(request, "KRI_LMT_DSC"); // KRI한도코드
if(vLst7==null) vLst7 = new Vector();
//Vector vLst8= CommUtil.getCommonCode(request, "GU_DRTN_RER_DSC"); // 순방향역방향지표유형코드
//if(vLst8==null) vLst8 = new Vector();
Vector vLst9= CommUtil.getCommonCode(request, "TEAM_CD"); // 팀코드
if(vLst9==null) vLst9 = new Vector();
Vector vKriPoolLst= CommUtil.getResultVector(request, "grp01", 0, "unit10", 0, "vList"); // 리스크지표 상세 조회
if(vKriPoolLst==null) vKriPoolLst = new Vector();
Vector vBrcLst= CommUtil.getResultVector(request, "grp01", 0, "unit15", 0, "vList"); // 관련리스크 사례
if(vBrcLst==null) vBrcLst = new Vector();

HashMap hKriPoolMap = null;
if(vKriPoolLst.size()>0){
	hKriPoolMap = (HashMap)vKriPoolLst.get(0);
}else{
	hKriPoolMap = new HashMap();
}

String brc_td = "";

//for(int i=0;i<vBrcLst.size();i++){
//	HashMap hp = (HashMap)vBrcLst.get(i);
//	brc_td += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+(String)hp.get("brnm")+"</span><input type='hidden' name='hd_apl_brc' value='" + (String)hp.get("brc") + "' /></button>";
//}

String xtr_cnd_sqls;
if ((String)hKriPoolMap.get("xtr_cnd_sqls") == null)
	xtr_cnd_sqls = "";
else 
	xtr_cnd_sqls = (String)hKriPoolMap.get("xtr_cnd_sqls");

String mod_yn = (String) form.get("mod_yn");
if(mod_yn==null) mod_yn = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>


		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet();
			initIBSheet2();
			
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			viewXtr();
		});
		
		$("#brc_td").ready(function() {
			$("#brc_td").html("<%=brc_td%>");
		});
		
		  
 		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();  
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			initData.Cols = [
				{Header:"관련테이블명",	Type:"Text",	Width:00,	Align:"Center",	SaveName:"rel_tblnm",	MinWidth:0},
				{Header:"관리조직여부",	Type:"Text",	Width:00,	Align:"Center",	SaveName:"amn_orgz_yn",	MinWidth:0},
							
				{Header:"NO",		Type:"Text",	Width:00,	Align:"Center",	SaveName:"rk_hdng_no",	MinWidth:0},			                 
				{Header:"항목명",		Type:"Text",	Width:50,	Align:"Left",	SaveName:"clmn_loglnm",	MinWidth:20},
				{Header:"데이타형식",	Type:"Combo",	Width:120,	Align:"Center",	SaveName:"clmn_mrk_cfc",MinWidth:20,ComboCode:"1|2|3|4|5|6",ComboText:"VARCHAR|CHAR|금액|날짜|시간|날짜+시간"},
				{Header:"부점여부",		Type:"Text",	Width:100,	Align:"Center",	SaveName:"dept_cnf_yn",	MinWidth:20},
				{Header:"사번여부",		Type:"Text",	Width:100,	Align:"Center",	SaveName:"clmn_phnm",	MinWidth:20},
			];
			
			IBS_InitSheet(mySheet,initData);
			    
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			//mySheet.SetCountPosition(0);
			
			mySheet.FitColWidth();
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);

			doAction('search');
		}
		
		// mySheet2
		function initIBSheet2() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "리스크사례\nID|리스크사례\nID",	Type: "",	SaveName: "oprk_rkp_id",Align: "Center",	Width: 10,	MinWidth: 80 },
				{ Header: "지표\n소관부서|지표\n소관부서",		Type: "",	SaveName: "brnm",		Align: "Center",	Width: 10,	MinWidth: 100 },
				{ Header: "팀|팀",					Type: "",	SaveName: "team_nm",	Align: "Center",	Width: 10,	MinWidth: 100 },
				{ Header: "업무 프로세스|Lv1",			Type: "",	SaveName: "prssnm1",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "업무 프로세스|Lv2",			Type: "",	SaveName: "prssnm2",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "업무 프로세스|Lv3",			Type: "",	SaveName: "prssnm3",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "업무 프로세스|Lv4",			Type: "",	SaveName: "prssnm4",	Align: "Left",		Width: 10,	MinWidth: 150 },
				{ Header: "리스크 사례|리스크 사례",			Type: "",	SaveName: "rk_isc_cntn",Align: "Left",		Width: 10,	MinWidth: 100 },
				{ Header: "통제활동|통제활동",				Type: "",	SaveName: "cp_cntn",	Align: "Left",		Width: 10,	MinWidth: 100 },
			];
			IBS_InitSheet(mySheet2, initdata);
			mySheet2.SetSelectionMode(4);
		}		
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		function doAction(sAction){
			switch(sAction){
			case "search": //데이터조회
				// var opt = {CallBack : DoSearchEnd}
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR010202");
				
				
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
				break;
			case "save"://저장
				var f = document.ormsForm;
				save();

				break;
			case "insert": //리스크정보항목 추가
/*			
				if($("#rel_tblnm").val()==""){
					alert("테이블명을 입력하세요.");
					$("#rel_tblnm").focus();
					return;
				}
				if(mySheet.RowCount() == 10){
					alert("더이상 추가가 불가합니다.");
					$("#ctl_cnt").text(mySheet.RowCount());
					return;
				}else{
*/				
					mySheet.SetCellValue(mySheet.DataInsert(-1),"rel_tblnm",$("#rel_tblnm").val());
					$("#ctl_cnt").text(mySheet.RowCount());
/*					
				}
*/
				break; 
			case "delete": //리스크정보항목 삭제
				if(mySheet.GetSelectRow() < 0){
					alert("삭제대상통제를 선택하세요.");
					return;
				}else{
					//삭제처리;
					mySheet.RowDelete(mySheet.GetSelectRow(), 1);
					$("#ctl_cnt").text(mySheet.RowCount()); 
				}
				break; 
			case "mod":		//수정 팝업
					$("#ifrKriLmt").attr("src","about:blank");
					$("#winKriLmt").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(modKri,1);
				break; 
			}
		} 
		
		
		function doAction2(sAction){
			switch(sAction){
			case "search": //데이터조회
				// var opt = {CallBack : DoSearchEnd}
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR010203");
				
				
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
				break;
			}
		}
		
		function modKri(){ // RI 수정 처리
			
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        if ($("#h_rki_lvl_c").val() == "01" ) {
	        	f.process_id.value="ORKR010401";
	        }
	        else {
	        	f.process_id.value="ORKR010411";
	        }	
			f.target = "ifrKriLmt";
			f.submit();
		}
		
		
		function save(){
			var f = document.ormsForm;
			
			var hdng_html = "";
			if(mySheet.GetDataFirstRow()>=0){
				
				if($("#rel_tblnm").val()==""){
					alert("테이블명을 입력해주세요.");
					return;
				}
				
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					hdng_html += "<input type='hidden' name='status' 		value='" 	+ mySheet.GetCellValue(j,"status") 		+ "'>";
					hdng_html += "<input type='hidden' name='rk_hdng_no' 	value='" 	+ mySheet.GetCellValue(j,"rk_hdng_no") 	+ "'>";
					hdng_html += "<input type='hidden' name='rel_tblnm' 	value='" 	+ mySheet.GetCellValue(j,"rel_tblnm") 	+ "'>";
					hdng_html += "<input type='hidden' name='clmn_loglnm' 	value='" 	+ mySheet.GetCellValue(j,"clmn_loglnm") + "'>";
					hdng_html += "<input type='hidden' name='clmn_phnm' 	value='" 	+ mySheet.GetCellValue(j,"clmn_phnm") 	+ "'>";
					hdng_html += "<input type='hidden' name='clmn_mrk_cfc' 	value='" 	+ mySheet.GetCellValue(j,"clmn_mrk_cfc")+ "'>";
					hdng_html += "<input type='hidden' name='amn_orgz_yn' 	value='" 	+ mySheet.GetCellValue(j,"amn_orgz_yn") + "'>";
					hdng_html += "<input type='hidden' name='clmn_expl' 	value='" 	+ mySheet.GetCellValue(j,"clmn_expl") 	+ "'>";
				}
			}
			hdng_area.innerHTML = hdng_html;
			
			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "kri");
			WP.setParameter("process_id", "ORKR010204");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						closePop();
						parent.doAction('search');
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
		
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				doAction2("search");
			}
			mySheet.FitColWidth();
			$("#ctl_cnt").text(mySheet.RowCount());
			$("#h_rki_lvl_c").val($("#rki_lvl_c").val());
			//if ( $("#ctl_cnt").val() > 0 ) {
			//	alert(" rki_lvl_c ----> " + $("#rki_lvl_c").val());
			//}	
		}
		

		$("#fmrk_rel_yn").ready(function() {
			
			$("#fmrk_rel_yn").change(function() {
				var v_fmrk_rel_yn = $("#fmrk_rel_yn").val();
				if(v_fmrk_rel_yn == 'Y'){
					$("#fame_idx_attr_c").show();
					$("#fame_amn_acv").show();
					$("#bsn").hide();
				} else {
 					$("#fame_idx_attr_c").hide();
 					$("#fame_amn_acv").hide();
 					$("#bsn").show();
				}
			});
			$("#fmrk_rel_yn").trigger("change"); 			
 		});
/*		
        $("#rki_lvl_c").ready(function() {
			
			$("#rki_lvl_c").change(function() {
				var v_rki_lvl_c = $("#rki_lvl_c").val();
				if(v_rki_lvl_c == '' || v_rki_lvl_c == '02'||v_rki_lvl_c == '05' ){
					$("#brnm").hide();
					$("#hd_apl_brc").val("");
				} else {
					$("#brnm").show();
				}
			});
			$("#rki_lvl_c").trigger("change"); 			
 		});
*/		
        $("#rel_tblnm").ready(function() {
			
			$("#rel_tblnm").change(function() {
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						mySheet.SetCellValue(j,"rel_tblnm",$("#rel_tblnm").val());
					}
				}
			});
			$("#rel_tblnm").trigger("change"); 			
 		});

	</script>
	
</head>
<body onkeyPress="return EnterkeyPass()">
	<article class="popup modal block" > 
		<div class="p_frame w1200"> 
			<div class="p_head">
				<h1 class="title">리스크 지표 상세</h1>
			</div> 
			<div class="p_body"> 
				<div class="p_wrap">  
					<form name="ormsForm" method="post">
						<input type="hidden" id="path" 			name="path" />             
						<input type="hidden" id="process_id" 	name="process_id" />  
						<input type="hidden" id="commkind" 		name="commkind" />       
						<input type="hidden" id="method" 		name="method" />            
						<input type="hidden" id="mod_yn" 		name="mod_yn" value="<%=mod_yn %>" />     
						<input type="hidden" id="h_rki_lvl_c" 	name="h_rki_lvl_c" />       
						<input type="text" 	 id="hd_apl_brc" 	name="hd_apl_brc" value="<%=(String)hKriPoolMap.get("hd_apl_brc")%>"/>       
						   
						<div id="hdng_area"></div>  
						<div id="brcd_area"></div>
					
						<section class="box-grid">

							<div class="box-header">
								<h2 class="box-title">리스크지표 상세 조회</h2>
								<div class="area-tool">
									<button type="button" class="btn btn-xs btn-default" onClick="doAction('mod');"><i class="fa fa-pencil"></i><span class="txt">한도변경</span></button>
								</div>
							</div>	
							<div class="wrap-table">
								<table>
									<tbody>
										<tr>
											<th>KRI - ID</th>
											<td>
												<input type="text" class="form-control" id="rki_id" name="rki_id" value="<%=(String)hKriPoolMap.get("rki_id")%>" readonly />
											</td>																	
											<th>지표명</th>
											<td colspan="3">
												<input type="text" class="form-control" id="rkinm" name="rkinm" value="<%=(String)hKriPoolMap.get("rkinm")%>" />
											</td>
										</tr>
										<tr>
											<th>지표 수준</th>
											<td colspan="5">
												<select class="form-control w150" id="rki_lvl_c" name="rki_lvl_c" > 
		<%
				for(int i=0;i<vLst3.size();i++){
					HashMap hMap = (HashMap)vLst3.get(i);
				//	System.out.println("rk_ctgr_c :"+(String)hMap.get("rk_ctgr_c")+", rk_ctgr_c_up:"+(String)hkriPoolMap.get("rk_ctgr_c_up"));
					if(((String)hMap.get("intgc")).equals((String)hKriPoolMap.get("rki_lvl_c"))){
		%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}else{
		%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}
				}
		%>
												</select>
											</td>

										</tr>
										<tr>
											<th>지표 목적</th>
											<td colspan="2">
												<textarea id="rki_obv_cntn" name="rki_obv_cntn" class="form-control"><%=StringUtil.htmlEscape((String)hKriPoolMap.get("rki_obv_cntn"),false,false)%></textarea>
											</td>
											
											<th>지표 정의</th>
											<td colspan="2">
												<textarea id="rki_def_cntn" name="rki_def_cntn" class="form-control"><%=StringUtil.htmlEscape((String)hKriPoolMap.get("rki_def_cntn"),false,false)%></textarea>
											</td>
										</tr>
										<tr>
											<th>지표 산식</th>
											<td colspan="5">
												<textarea id="rki_fml_cntn" name="rki_fml_cntn" class="form-control"><%=StringUtil.htmlEscape((String)hKriPoolMap.get("rki_fml_cntn"),false,false)%></textarea>
											</td>
										</tr>
										<tr>
											<th>단위</th>
											<td>
												<select class="form-control" id="rki_unt_c" name="rki_unt_c" >
		<%
				for(int i=0;i<vLst4.size();i++){
					HashMap hMap = (HashMap)vLst4.get(i);
				//	System.out.println("rk_ctgr_c :"+(String)hMap.get("rk_ctgr_c")+", rk_ctgr_c_up:"+(String)hkriPoolMap.get("rk_ctgr_c_up"));
					if(((String)hMap.get("intgc")).equals((String)hKriPoolMap.get("rki_unt_c"))){
		%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}else{
		%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}
				}
		%>
												</select>
											</td>
											<th>한도</th>
											<td colspan="3">
												<select class="form-control w140" id="kri_lmt_dsc" name="kri_lmt_dsc" onchange="doAction('mod')">
		
		<%
				for(int i=0;i<vLst7.size();i++){
					HashMap hMap = (HashMap)vLst7.get(i);
					if(((String)hMap.get("intgc")).equals((String)hKriPoolMap.get("kri_lmt_dsc"))){
		%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}else{
		%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}
				}
		%>
												</select>
											</td>
										</tr>
										<tr>
											<th>수집주기</th>
											<td>
												<select class="form-control" id="col_fq" name="col_fq" >
		<%
				for(int i=0;i<vLst5.size();i++){
					HashMap hMap = (HashMap)vLst5.get(i);
				//	System.out.println("rk_ctgr_c :"+(String)hMap.get("rk_ctgr_c")+", rk_ctgr_c_up:"+(String)hkriPoolMap.get("rk_ctgr_c_up"));
					if(((String)hMap.get("intgc")).equals((String)hKriPoolMap.get("col_fq"))){
		%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}else{
		%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}
				}
		%>
												</select>
											</td>
											
											<th>수집방법</th>
											<td>
												<select class="form-control" id="com_col_psb_yn" name="com_col_psb_yn" onchange="viewXtr();">
		<%
				for(int i=0;i<vKriPoolLst.size();i++){
					HashMap hMap = (HashMap)vKriPoolLst.get(i);
						if(((String)hMap.get("com_col_psb_yn")).equals("Y")){
		%>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
		<%
					}else{
		%>
													<option value="N" selected>N</option>
													<option value="Y">Y</option>
		<%
					}
				}
		%>
												</select>
											</td>
											<th>개인화 KRI 여부</th>
											<td>
												<select class="form-control" id="psn_kri_yn" name="psn_kri_yn" onchange="viewXtr();">
		<%
				for(int i=0;i<vKriPoolLst.size();i++){
					HashMap hMap = (HashMap)vKriPoolLst.get(i);
						if(((String)hMap.get("psn_kri_yn")).equals("Y")){
		%>
														<option value="Y" selected>Y</option>
														<option value="N">N</option>
		<%
					}else{
		%>
														<option value="N" selected>N</option>
														<option value="Y">Y</option>
		<%
					}
				}
		%>
												</select>
											</td>
										</tr>
										<tr>									
											<th>평가대상 여부</th>
											<td>
												<select class="form-control" id="kri_yn" name="kri_yn" >
		<%
				for(int i=0;i<vKriPoolLst.size();i++){
					HashMap hMap = (HashMap)vKriPoolLst.get(i);
						if(((String)hMap.get("kri_yn")).equals("Y")){
		%>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
		<%
					}else{
		%>
													<option value="N" selected>N</option>
													<option value="Y">Y</option>
		<%
					}
				}
		%>
												</select>
											</td>
											<th >평가 조직</th>
											<td colspan="3">
												<div class="input-group">
													<input type="text" name="brc_td" id="brc_td" class="form-control" readonly value="<%=(String)hKriPoolMap.get("brc_td")%>">
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico fl" onclick="org_popup();">
															<i class="fa fa-search"></i><span class="blind">조직 선택</span>
														</button>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th>지표 정보 항목</th>
											<td colspan="5">
												<div class="box-header">
													<div class="area-tool">
														<div class="btn-group">
															<button type="button" class="btn btn-default btn-xs" onclick="doAction('insert')"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
															<button type="button" class="btn btn-default btn-xs" onclick="doAction('delete')"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
														</div>
													</div>
												</div>
												<div class="wrap-grid h200">
													<script>createIBSheet("mySheet", "100%", "100%");</script>
												</div>
											</td>
										</tr>
										<tr>
											<th>연관 리스크 사례</th>
											<td colspan="5">
												<div class="wrap-grid h250">
													<script>createIBSheet("mySheet2", "100%", "100%");</script>
												</div>
											</td>
										</tr>										
									</tbody>
								</table>
							</div><!-- .wrap-table //-->
						</section>
						<div class="wrap-footnote">
							<p class="cr">※ 신규 리스크 지표의 전산화를 위해서는 지표 정보 항목 수기 입력 이외에 별도의 IT 부서와의 협의 필요</p>
						</div>
					</form>						
				</div><!-- .p_wrap //-->			  
			</div>    <!-- .p_body //-->
			<div class="p_foot">
				<div class="btn-wrap">
<%
if("".equals(mod_yn)){
%>
					<button type="button" class="btn btn-primary" onClick="doAction('save');">저장</button>
<%	
}
%>				
				 
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div> 
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div> 
	</article>  
	
	<div id="winKriLmt" class="popup modal">
		<iframe name="ifrKriLmt" id="ifrKriLmt" src="about:blank"></iframe>
	</div>
		  
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 		  
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 팝업 --> 		  
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			$("#ifrORKR0201",parent.document).attr("src","about:blank");
			event.preventDefault();
		});
	});
		
	function closePop(){
		$("#winKriMod",parent.document).hide();
		$("#ifrORKR0201",parent.document).attr("src","about:blank");
	}

	function org_popup(){
		var brcs = new Array();
		$("input[name=hd_apl_brc]").each(function(idx){
			brcs.push($(this).val());
		});
		var bizo_tpcs = new Array();
		$("input[name=bizo_tpc]").each(function(idx){
			bizo_tpcs.push($(this).val());
		});
		
//		schOrgMPopup(brcs, bizo_tpcs, "orgSearchEnd","0");// 처리모드(0:전체,1:RCSA 본부부서,2:RCSA 본부부서+영업점유형,3:RCSA 전체,4:KRI 전체,5:손실 전체, 6:RCSA 해외점, 7:KRI 본부부서, 8:KRI 해외점, 9:KRI 본부부서+해외점)
		schOrgPopup('brc_td', "orgSearchEnd","0");// 처리모드(0:전체,1:RCSA 본부부서,2:RCSA 본부부서+영업점유형,3:RCSA 전체,4:KRI 전체,5:손실 전체, 6:RCSA 해외점, 7:KRI 본부부서, 8:KRI 해외점, 9:KRI 본부부서+해외점)
	}
	

	function org_rcsaPop(){
		CUR_rkp_ID = $("#rel_rkp").val();
		schRpPopup();
	}
	
	function rpSearchEnd(rkp_id, rk_isc_cntn){
		$("#rel_rkp").val(rkp_id);
		$("#rel_rkp_cntn").val(rk_isc_cntn);
		$("#winRp").hide();
		//doAction('search');
	}

	// 부서검색 완료
	function orgSearchEnd(brc, brnm, bizo_tpc, bizo_tpc_nm){
		var html = "";
		var code_html = "";
		
//		if (brc.length > 1)
//			if ($("select[name=rki_attr_c]").val() != '99') {
//				alert("속성이 공통인 경우 하나이상의 부서를 선택할 수 없습니다. ");
//				return;
		
//		for(var i=0;i<brc.length;i++){
//			html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+brnm[i]+"</span></button>";
//			code_html += "<input type='hidden' name='hd_apl_brc' value='" + brc[i] + "' />";
//		}

		$("#brc_td").val(brnm);
		$("#hd_jrdt_brc").val(brc);		
		$("#hd_apl_brc").val(brc);
		

		$("#brcd_area").html(code_html);
		//$("#brc_td").html(html);
		
		$("#winBuseo").hide();
		//doAction('search');
	}
	
	function viewXtr() {
		var item = document.getElementById("com_col_psb_yn");
		var itemID = item.options[item.selectedIndex].value;
		if (itemID == "Y")
			$("#xtr").show();
		else if (itemID == "N")
			$("#xtr").hide();
			
	}

	</script>
	<%@ include file="../comm/OrgInfP.jsp" %>
</body>	 	
</html>