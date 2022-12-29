<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0107.jsp
 Program name : 평판지표 결과 입력 및 조회
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
HashMap hLst = null; 
for(int i=0; i<vLst.size(); i++) {
	if(vLst.size()>0){
		hLst = (HashMap)vLst.get(i);
	}
}
String bas_pd = new String((String)hLst.get("bas_ym"));

DynaForm form = (DynaForm)request.getAttribute("form");

String rep_menu_dsc = (String)form.get("rep_menu_dsc");
System.out.println(rep_menu_dsc);

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	    <%@ include file="../comm/library.jsp" %>
		<title>평판지표 평가관리</title>
		<script>
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet();				
				createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
				if(<%=rep_menu_dsc%>=='1') {
					$("#chk_auth").val('04');
				}else if(<%=rep_menu_dsc%>=='2'){
					$("#chk_auth").val('13');
				}
			});
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet2();
			});
			/*Sheet 기본 설정 */
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
			var initData = {};
			initData.Cfg = {FrozenCol:0,MergeSheet:msPrevColumnMerge,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"평가년월",Type:"Text",Width:300,Align:"Center",SaveName:"bas_ym",Wrap:1,MinWidth:60,Edit:0,Hidden:true},
				{Header:"ID",Type:"Text",Width:300,Align:"Center",SaveName:"rki_id",Wrap:1,MinWidth:60,Edit:0,Hidden:true},
				{Header:"주관 부서",Type:"Text",Width:300,Align:"Center",SaveName:"brnm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"입력 현황",Type:"Text",Width:120,Align:"Center",SaveName:"comp",Wrap:1,MinWidth:60,Edit:0},
				{Header:"대상 건수",Type:"AutoSum",Width:80,Align:"Center",SaveName:"cnt",Wrap:1,MinWidth:60,Edit:0},
				{Header:"완료 건수",Type:"AutoSum",Width:80,Align:"Center",SaveName:"inp_cnt",Wrap:1,MinWidth:60,Edit:0},
			];/*mySheet end*/
				
			
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
			mySheet.SetSumValue("brnm", "합계");
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			doAction('search');
			}
			
			function initIBSheet2() {
				//시트 초기화
				mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"선택",						Type:"CheckBox",Width:50,Align:"Center",SaveName:"ischeck",Wrap:1,MinWidth:20,Edit:1},
				{Header:"지표ID",					Type:"Text",Width:100,Align:"Center",SaveName:"rki_id",Wrap:1,MinWidth:70,Edit:0},
				{Header:"소관 부서",				Type:"Text",Width:150,Align:"Center",SaveName:"brnm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"리스크 지표명",			Type:"Text",Width:400,Align:"Left",SaveName:"rkinm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"추출방식",					Type:"Text",Width:80,Align:"Center",SaveName:"psb_yn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표값",					Type:"Text",Width:60,Align:"Center",SaveName:"rep_kri_nvl",Wrap:1,MinWidth:20,Edit:0},
				{Header:"결재상태",					Type:"Text",Width:80,Align:"Center",SaveName:"inp",Wrap:1,MinWidth:20,Edit:0},
				{Header:"반려내용",					Type:"Text",Width:200,Align:"btn-normal",SaveName:"rtn_cntn",MinWidth:20,Edit:1},				
				{Header:"기준년월",					Type:"Text",Width:100,Align:"Center",SaveName:"bas_ym",MinWidth:20,Edit:0, Hidden:true},				
				{Header:"상세정보",					Type:"Button",Width:80,Align:"Center",SaveName:"btn",Wrap:1,MinWidth:10,Edit:0},
				{Header:"상태코드",					Type:"Text",Width:80,Align:"Center",SaveName:"idvdc_val",Wrap:1,MinWidth:10,Edit:0, Hidden:true},
				{Header:"확인현황",Type:"Html",Width:40,Align:"Center",SaveName:"DetailDcz",MinWidth:60}	
				];/*mySheet end*/
				
			IBS_InitSheet(mySheet2,initData);
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search2');
			}
			
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			//시트 ContextMenu선택에 대한 이벤트
			function mySheet_OnSelectMenu(text,code){
				alert('onselectmenu!');
				if(text=="엑셀다운로드"){
					doAction("down2excel");	
				}else if(text=="엑셀업로드"){
					doAction("loadexcel");
				}
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				
			}
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				if(Row >= mySheet.GetDataFirstRow()){
					$("#sch_brnm").val(mySheet.GetCellValue(Row,"brnm"));
					doAction("search2");
				}
			}
			function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				if(Row >= mySheet2.GetDataFirstRow()){
					$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
					$("#sch_bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
					<%if(rep_menu_dsc.equals("1")){%>
						if(mySheet2.GetCellValue(Row,"psb_yn")=='수기'){
							doAction("mod");
						}else{
							doAction("mod1");
						}
					<%}else if(rep_menu_dsc.equals("2")){%>
						doAction("mod1");
					<%}%>
				}
			}
			function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert('onclick!');
					$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
					$("#sch_bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
					if(mySheet2.ColSaveName(Col) == "rep_kri_nvl"){
						if(mySheet2.GetCellValue(Row, "psb_yn")=="수기"){
							if(Row >= mySheet2.GetDataFirstRow()){
								<%if(rep_menu_dsc.equals("1")){%>
									doAction("mod");
								<%}%>
							}
						}
					}
					if(mySheet2.ColSaveName(Col) == "btn"  && mySheet2.GetCellValue(Row,"btn") != ""){
						if(Row >= mySheet2.GetDataFirstRow()){
							doAction("mod1");
						}
					}
			}
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("fam");
						$("form[name=ormsForm] [name=process_id]").val("ORFM010702");
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						$("#sch_brnm").val("");
						break;
					case "search2":  //데이터 조회	
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("fam");
						$("form[name=ormsForm] [name=process_id]").val("ORFM010703");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "sub":  //리스크담당자 상신 (03-> 04)
						if(InputCheck(sAction) == false) return;
					    $("#dcz_objr_emp_auth").val("'004','006'");
					    schDczPopup(1);
						break;
					
					case "dcz":  //결제
						if(InputCheck(sAction) == false) return;
						$("#dcz_objr_emp_auth").val("'002'");
						schDczPopup(2);
						//doSave();
						break;
						
					case "ret":  //반려
						if(InputCheck(sAction) == false) return;
						$("#dcz_rmk_c").val("01");
						schDczPopup(2);
						doSave();
						break;
					case "reload":  //조회데이터 리로드
						mySheet.RemoveAll();
						initIBSheet();
						break;
					case "down2excel":
						setExcelFileName("영업지수 잔액 정보");
						setExcelDownCols("0|1|2|3|4");
						mySheet.Down2Excel(excel_params);
						break;
					case "save1":      //저장할 데이터 추출
						if(!confirm("저장하시겠습니까?")) return;
					
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "fam");
						WP.setParameter("process_id", "ORFM010708");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						//alert(inputData);
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
						{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="S") {
									alert("저장되었습니다.");
									objCopy(result.Result.new_code);
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
						case "mod":
							if($("#rki_id").val() == ""){
								alert("선택해주세요.");
								return;
							}else{
								$("#ifrFamMod").attr("src","about:blank");
								$("#winFamMod").show();
								setTimeout(modFam,1);
							}
						break; 
						case "mod1":
							$("#ifrFamMod1").attr("src","about:blank");
							$("#winFamMod1").show();
							showLoadingWs(); // 프로그래스바 활성화
							setTimeout(modFam1,1);
							//modRisk();
						break; 
				}
			}
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					
				}
				
				//컬럼의 너비 조정
				mySheet.FitColWidth();
			}
			function mySheet2_OnSearchEnd(code, message) {
				
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "idvdc_val")=="01"){
							mySheet2.SetCellValue(i,"rep_kri_nvl", "미입력");
							mySheet2.SetCellFontColor(i, "rep_kri_nvl", gridColor.red);
							mySheet2.SetCellFontUnderline(i,"rep_kri_nvl",1);
							mySheet2.SetCellEditable(i,"ischeck",0);
						}else if(mySheet2.GetCellValue(i, "psb_yn")=="수기"){
							<%if(rep_menu_dsc.equals("1")){%>
								mySheet2.SetCellFontUnderline(i,"rep_kri_nvl",1);
							<%}%>
							
						}
					}
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "idvdc_val")=="01"){
							mySheet2.SetCellFontColor(i, "inp", gridColor.red);
							//mySheet2.SetCellBackColor(i, "bsn_prsnm", "#E2E2E2");
							}else if(mySheet2.GetCellValue(i,"idvdc_val")=="03") {
								<%if(rep_menu_dsc.equals("1")) { %>
									mySheet2.SetCellEditable(i,"ischeck",1);
								<%}else if(rep_menu_dsc.equals("2")) { %>
									mySheet2.SetCellEditable(i,"ischeck",0);
								<%} %>
							}else if(mySheet2.GetCellValue(i, "idvdc_val")=="04"){
								<%if(rep_menu_dsc.equals("1")) { %>
									mySheet2.SetCellEditable(i,"ischeck",0);
								<%}else if(rep_menu_dsc.equals("2")) { %>
									mySheet2.SetCellEditable(i,"ischeck",1);
								<%} %>
							}else if(mySheet2.GetCellValue(i, "idvdc_val")=="13"){
								<%if(rep_menu_dsc.equals("1")) { %>
									mySheet2.SetCellEditable(i,"ischeck",0);
								<%}else if(rep_menu_dsc.equals("2")) { %>
									mySheet2.SetCellEditable(i,"ischeck",0);
								<%} %>
							}
					}
				}
				
				//컬럼의 너비 조정
				mySheet2.FitColWidth();
			}
			function mySheet2_OnRowSearchEnd(Row) {
				mySheet2.SetCellText(Row,"DetailDcz",'<button class="btn btn-xs btn-default" type="button" onclick="DczStatus(\''+mySheet2.GetCellValue(Row,"rki_id")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
			}
			function DczStatus(rki_id) {
				$("#rpst_id").val(rki_id);
				schDczPopup(3);
			}
			function modFam(){ 
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="fam";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORFM010801";
				f.target = "ifrFamMod";
				f.submit();
			}
			function modFam1(){ 
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="fam";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORFM010901";
				f.target = "ifrFamMod1";
				f.submit();
			}
			
			function cmp_fam(){
				var f = document.ormsForm;
				var add_html = "";
				if(mySheet2.GetDataFirstRow()>=0){
					for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
						if(mySheet2.GetCellValue(j,"ischeck")==1){
							add_html += "<input type='hidden' name='sch_rki_id' value='" + mySheet2.GetCellValue(j,"rki_id") + "'>";

						}
					}
				}
			
				
				if(add_html==""){
					alert("결재할 평판지표를 선택하세요.");
					return;
				}

	            tmp_area.innerHTML = add_html;
				
				
				var f = document.ormsForm;
				if(!confirm("선택한 평판지표를 결재 하시겠습니까?")) return;
					
				
				
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "fam");
				WP.setParameter("process_id", "ORFM010704");
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//alert(inputData);
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
						  if(result != 'undefined' && result.rtnCode== 'S'){
							  alert(result.rtnMsg);
							  doAction('search2');
						  }
						  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  closeDczP();
						  doAction('search2');
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);			
			}
			function rtn_fam(){
				var f = document.ormsForm;
				var add_html = "";
				if(mySheet2.GetDataFirstRow()>=0){
					for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
						if(mySheet2.GetCellValue(j,"ischeck")==1){
							add_html += "<input type='hidden' name='sch_rki_id' value='" + mySheet2.GetCellValue(j,"rki_id") + "'>";
							/* add_html += "<input type='text' name='sch_rtn_cntn' value='" + mySheet2.GetCellValue(j,"rtn_cntn") + "'>"; */
						}
					}
				}

				//alert(add_html);			
				
				if(add_html==""){
					alert("반려 할 평판지표를 선택하세요.");
					return;
				}

	            tmp_area.innerHTML = add_html;
				
				
				var f = document.ormsForm;
				if(!confirm("선택한 평판지표를 반려 하시겠습니까?")) return;
					
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "fam");	
				WP.setParameter("process_id", "ORFM010705"); 
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//alert(inputData);
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
						  if(result != 'undefined' && result.rtnCode== 'S'){
							  alert(result.rtnMsg);
							  doAction('search2');
						  }
						  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  closeDczP();
						  doAction('search2');
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);			
			}
			function cncl_fam(){
				if(!confirm("확인요청을 취소하시겠습니까?")) return;
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "fam");
				WP.setParameter("process_id", "ORFM010706");
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//alert(inputData);
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
						  if(result != 'undefined' && result.rtnCode== 'S'){
							  alert(result.rtnMsg);
							  doAction('search2');
						  }
						  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  closeDczP();
						  doAction('search2');
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);			
			}
			function doDczProc(sAction) {
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var Cnt = mySheet.GetTotalRows();
				switch(sAction) {
					case "sub":  //상신 (03-> 04)
					    $("#dcz_objr_emp_auth").val("'004','006'");
					    dcz_popup(1);
						break;
					
					case "dcz":  //결제
						$("#dcz_objr_emp_auth").val("'002'");
						dcz_popup(2);
						break;
						
					case "ret":  //반려
						$("#dcz_objr_emp_auth").val("'002'");
						dcz_popup(2)
						break;
				}
			}
			function monthChange() {
				var selectYear = $("#sch_bas_y").val();
				var change=[];
<%
				for(int i=0; i<vLst.size(); i++) {
					HashMap hMap2 = (HashMap)vLst.get(i);
					String bas_ym2 = new String((String)hMap2.get("bas_ym"));
					String bas_y2 = bas_ym2.substring(0,4);
					String bas_m2 = bas_ym2.substring(4,6);
					%>
					if(selectYear==<%=bas_y2%>){
						if(<%=bas_m2%> < 10) change.push('0'+<%=bas_m2%>);
						else change.push(<%=bas_m2%>);
					}
					<%
				}
%>
				//alert(change.length);
				$('#sch_bas_m').empty();
				for(var count=0; count<change.length; count++){
					var option = $("<option>"+change[count]+"</option>");
					$('#sch_bas_m').append(option);
				}    
			}
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
				<input type="hidden" id="sch_brnm" name="sch_brnm"/>
				<input type="hidden" id="rki_id" name="rki_id"/>
				<input type="hidden" id="sch_bas_ym" name="sch_bas_ym"/>
				<input type="hidden" id="chk_auth" name="chk_auth"/>
				<input type="hidden" id="table_name" name="table_name" value="TB_OR_FH_NVL_DCZ"/>
				<input type="hidden" id="dcz_code" name="stsc_column_name" value="REP_RKI_DCZ_STSC"/>
				<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="REP_RKI_ID"/>
				<input type="hidden" id="rpst_id" name="rpst_id"/>
				<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
				<input type="hidden" id="bas_pd" name="bas_pd" value="<%=bas_pd%>"/>
				<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
				<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
				<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
				<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
				<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
				<div id="tmp_area"></div>
				
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>평가년월</th>
										<td>
											<select name="sch_bas_y" id="sch_bas_y" class="form-control w80" onchange="monthChange()">
<%		String temp="";
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			if(bas_y.equals(temp)) continue; 
			else{
%>
												<option value="<%=bas_y%>" selected><%=bas_y%></option>
<%
			}
			temp = bas_y;
		}
%>


											</select>
											<select name="sch_bas_m" id="sch_bas_m" class="form-control w60">
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			String bas_m = bas_ym.substring(4,6);
			if(temp.equals(bas_y)){
%>
												<option value="<%=bas_m%>" selected><%=bas_m%></option>
<% 
			}
		}
%>
													
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="doAction('search'); doAction('search2');">조회</button>
					</div>
				</div>
				
				<section class="box box-grid">
					<div class="row">
						<div class="col w450">
							<div class="wrap-grid h580" >
								<script> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
						<div class="col">
							<div id="mydiv2" class="wrap-grid h580">
	<!-- 						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
	 -->					</div>
						 </div>
					</div>
					<div class="box-footer">
						<div class="btn-wrap">
<%if(rep_menu_dsc.equals("1")){ %>
								<button type="button" class="btn btn-primary" onclick="doDczProc('sub');" >상신</button>
<%}else if(rep_menu_dsc.equals("2")){ %>
								<button type="button" class="btn btn-primary" onclick="doDczProc('dcz');" >결재</button>
								<button type="button" class="btn btn-primary" onclick="doDczProc('ret');" >반려</button>
<%} %>
						</div>
	                </div>
				</section>
			</form>
			</div>
			<!-- content //-->
			
		</div>
		
		<div id="winFamMod" class="popup modal">
			<iframe name="ifrFamMod" id="ifrFamMod" src="about:blank"></iframe>
		</div>
		<div id="winFamMod1" class="popup modal">
			<iframe name="ifrFamMod1" id="ifrFamMod1" src="about:blank"></iframe>
		</div>
		<!-- popup -->
		<%@ include file="../comm/OrgInfP.jsp" %>
		<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 
		<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
		
		<script>
		<%-- 결재 시작 --%>			
		//결재 팝업 호출
		function dcz_popup(auth){
			var cnt=0;
			var temp=null;
			for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
				if(mySheet2.GetCellValue(j,"ischeck")==1){
					cnt++;
					temp = mySheet2.GetCellValue(j,"rki_id");
				}
			}
			if(cnt == 1) {
				$("#rpst_id").val(temp);
			}
			else if(cnt == 0) {
				alert('하나 이상의 항목을 선택해주세요.');
				$("#rpst_id").val(null);
				return;
			}else{
				$("#rpst_id").val(temp);
			}
			schDczPopup(auth);
		}

		// 결재팝업 연동 - 결재요청
		function DczSearchEndSub(){
			cmp_fam();
		}
		// 결재팝업 연동 - 결재
		function DczSearchEndCmp(){
			cmp_fam();
		}
		// 결재팝업 연동 - 반려
		function DczSearchEndRtn(){
			rtn_fam();
		}
		function DczSearchEndCncl(){
			cncl_fam();
		}
		<%-- 결재 끝 --%>
		</script>
	</body>
</html>