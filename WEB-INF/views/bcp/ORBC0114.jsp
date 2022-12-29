<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0114.jsp
 Program name : 재해대응지원업무
 Description  : 
 Programmer   : 김병현
 Date created : 2022.06.21
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, java.text.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
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
			
//			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"레벨",				Type:"Text",		SaveName:"level",				Align:"Center",	Hidden:true},
 				{Header:"업무프로세스",			Type:"Text",		SaveName:"bsn_prsnm",			Align:"Left",	Width:300,	TreeCol:1},
 				{Header:"업무프로세스코드",		Type:"Text",		SaveName:"bsn_prss_c",			Align:"Center",	Hidden:true},
 				{Header:"상위업무프로세스코드",	Type:"Text",		SaveName:"up_bsn_prss_c",		Align:"Center",	Hidden:true},
 				{Header:"LV1_업무프로세스코드",	Type:"Text",		SaveName:"lv1_bsn_prss_c",		Hidden:true},
 				{Header:"LV2_업무프로세스코드",	Type:"Text",		SaveName:"lv2_bsn_prss_c",		Hidden:true},
 				{Header:"LV3_업무프로세스코드",	Type:"Text",		SaveName:"lv3_bsn_prss_c",		Hidden:true},
 				{Header:"LV4_업무프로세스코드",	Type:"Text",		SaveName:"lv4_bsn_prss_c",		Hidden:true},
 				{Header:"LV1_업무프로세스명",	Type:"Text",		SaveName:"lv1_bsn_prsnm",		Hidden:true},
 				{Header:"LV2_업무프로세스명",	Type:"Text",		SaveName:"lv2_bsn_prsnm",		Hidden:true},
 				{Header:"LV3_업무프로세스명",	Type:"Text",		SaveName:"lv3_bsn_prsnm",		Hidden:true},
 				{Header:"LV4_업무프로세스명",	Type:"Text",		SaveName:"lv4_bsn_prsnm",		Hidden:true},
 				//{Header:"LV1_영문업무프로세스명",	Type:"Text",		SaveName:"lv1_eng_bsn_prsnm",	Hidden:true},
 				//{Header:"LV2_영문업무프로세스명",	Type:"Text",		SaveName:"lv2_eng_bsn_prsnm",	Hidden:true},
 				//{Header:"LV3_영문업무프로세스명",	Type:"Text",		SaveName:"lv3_eng_bsn_prsnm",	Hidden:true},
 				//{Header:"LV4_영문업무프로세스명",	Type:"Text",		SaveName:"lv4_eng_bsn_prsnm",	Hidden:true},
   			];
 			IBS_InitSheet(mySheet,initData);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			mySheet.SetFocusAfterProcess(0);
			
			mySheet.SetEditable(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			mySheet.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//트리컬럼 체크박스 사용시 어미/자식 간의 연관 체크기능 사용
			mySheet.SetTreeCheckActionMode(1); 
			
			//헤더기능 해제
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			doAction('search');
			
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011402");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "save":      //저장할 데이터 추출
				
					if($("#lv1_bsn_prsnm").val() == ""){
						alert("프로세스명을 입력해 주십시오.");
						$("#lv1_bsn_prsnm").focus();
						return;
					}
					else if($("#lv2_bsn_prsnm").val() == ""){
						alert("프로세스명을 입력해 주십시오.");
						$("#lv2_bsn_prsnm").focus();
						return;
					}
					else if($("#lv3_bsn_prsnm").val() == ""){
						alert("프로세스명을 입력해 주십시오.");
						$("#lv3_bsn_prsnm").focus();
						return;
					}
					else if($("#lv4_bsn_prsnm").val() == ""){
						alert("프로세스명을 입력해 주십시오.");
						$("#lv4_bsn_prsnm").focus();
						return;
					}
					/*
					if($("#lv4_eng_bsn_prsnm").val() == ""){
						alert("영문 프로세스명을 입력해 주십시오.");
						$("#lv4_eng_bsn_prsnm").focus();
						return;
					}
					*/
				
					if(!confirm("저장하시겠습니까?")) return;
				
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "bcp");
					if($("#mode").val() == "I"){
						WP.setParameter("process_id", "ORBC011404");
					}else if($("#mode").val() == "U"){
						WP.setParameter("process_id", "ORBC011405");
					}else{
						return;
					}
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
								doAction('search');
							}else if(result!='undefined'){
								alert(result.rtnMsg);
								alert(result.rtnCode);
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
				case "del":      //삭제
					var srow = mySheet.GetSelectRow();
					if(srow < 0) {
						alert("삭제할 항목을 선택하세요.");
						return;
					}
					
					/* if(mySheet.GetCellValue(srow,"level") != "4"){
						alert("4레벨 업무프로세스만 삭제가 가능합니다.");
						return;
					} */
					
					if(mySheet.GetCellValue(srow,"bsn_prss_c") == ""){
						mySheet.RowDelete(srow, 0);
						mySheet.SetSelectRow(-1);
						init();
					}else{
					
						if(!confirm("삭제하시겠습니까?")) return;
						
						//업무프로세스 사용부서 조회
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "bcp");
						WP.setParameter("process_id", "ORBC011406");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
						{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="S") {
									alert("삭제되었습니다.");
									mySheet.RowDelete(srow, 0);
									mySheet.SetSelectRow(-1);
									init();
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
					}
					
					break;
				case "insert":		//신규행 추가
					var srow = mySheet.GetSelectRow();
					//alert(mySheet.GetCellText(srow,"caus_id_srno"));
					
					if(srow < 0) {
						alert("항목을 선택해 주십시오.");
						return;
					}
					
					if(mySheet.GetCellText(srow,"level") != "3"){
						alert("4레벨만 신규로 등록 가능합니다.\n3레벨 항목을 선택하고 추가해 주시기 바랍니다.");
						return ;
					}
					
					var row = mySheet.DataInsert(srow+1, mySheet.GetRowLevel(srow)+1 ); 
					mySheet.SetCellValue(row,"lv1_bsn_prsnm", mySheet.GetCellText(srow,"lv1_bsn_prsnm"));
					mySheet.SetCellValue(row,"lv1_eng_bsn_prsnm", mySheet.GetCellText(srow,"lv1_eng_bsn_prsnm"));
					mySheet.SetCellValue(row,"lv1_bsn_prss_c", mySheet.GetCellText(srow,"lv1_bsn_prss_c"));
					mySheet.SetCellValue(row,"lv2_bsn_prsnm", mySheet.GetCellText(srow,"lv2_bsn_prsnm"));
					mySheet.SetCellValue(row,"lv2_eng_bsn_prsnm", mySheet.GetCellText(srow,"lv2_eng_bsn_prsnm"));
					mySheet.SetCellValue(row,"lv2_bsn_prss_c", mySheet.GetCellText(srow,"lv2_bsn_prss_c"));
					mySheet.SetCellValue(row,"lv3_bsn_prsnm", mySheet.GetCellText(srow,"lv3_bsn_prsnm"));
					mySheet.SetCellValue(row,"lv3_eng_bsn_prsnm", mySheet.GetCellText(srow,"lv3_eng_bsn_prsnm"));
					mySheet.SetCellValue(row,"lv3_bsn_prss_c", mySheet.GetCellText(srow,"lv3_bsn_prss_c"));
					mySheet.SetCellValue(row,"up_bsn_prss_c", mySheet.GetCellText(srow,"bsn_prss_c"));
					mySheet.SetCellValue(row,"level", Number(mySheet.GetCellText(srow,"level"))+1);
					
					mySheet_OnClick(row);
					
					break; 
				case "down2excel":
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "업무프로세스코드.xlsx",  SheetName : "Sheet1", DownTreeHide:"True", DownCols:"0|1|2|3"} ;

					mySheet.Down2Excel(params);
					break;
			}
		}
		
		function mySheet_OnAfterExpand(Row, Expand){
			mySheet.FitColWidth();
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
			
			mySheet.ShowTreeLevel(1,1);
			
		}
		
		function mySheet_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	init();
		        doAction("search");      
		    }
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				init();
				
				$("#lv1_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv1_bsn_prsnm"));
				//$("#lv1_eng_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv1_eng_bsn_prsnm"));
				$("#lv1_bsn_prss_c").val(mySheet.GetCellValue(Row,"lv1_bsn_prss_c"));
				$("#lv2_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv2_bsn_prsnm"));
				//$("#lv2_eng_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv2_eng_bsn_prsnm"));
				$("#lv2_bsn_prss_c").val(mySheet.GetCellValue(Row,"lv2_bsn_prss_c"));
				$("#lv3_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv3_bsn_prsnm"));
				//$("#lv3_eng_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv3_eng_bsn_prsnm"));
				$("#lv3_bsn_prss_c").val(mySheet.GetCellValue(Row,"lv3_bsn_prss_c"));
				$("#lv4_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv4_bsn_prsnm"));
				//$("#lv4_eng_bsn_prsnm").val(mySheet.GetCellValue(Row,"lv4_eng_bsn_prsnm"));
				$("#lv4_bsn_prss_c").val(mySheet.GetCellValue(Row,"lv4_bsn_prss_c"));
				
				$("#sel_bsn_prss_c").val(mySheet.GetCellValue(Row,"bsn_prss_c"));
				$("#sel_level").val(mySheet.GetCellValue(Row,"level"));
				
				if($("#sel_level").val() == "1"){
					$("#btnDel").attr("disabled",false);
					$("#btnSave").attr("disabled",false);
					$("#lv1_bsn_prsnm").attr("disabled",true);
					$("#lv2_bsn_prsnm").attr("disabled",true);
					$("#lv3_bsn_prsnm").attr("disabled",true);
					$("#lv4_bsn_prsnm").attr("disabled",true);
					//$("#lv4_eng_bsn_prsnm").attr("disabled",false);
					$("#btnDeptSch").attr("disabled",true);
					
					if(mySheet.GetCellValue(Row,"bsn_prss_c") == ""){
						$("#mode").val("I");
						mySheet.SetBlur();
						$("#lv4_bsn_prsnm").focus();
					}else{
						$("#mode").val("U");
						
						//업무프로세스 사용부서 조회
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "bcp");
						WP.setParameter("process_id", "ORBC011403");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
							{
								success: function(result){
									removeLoadingWs();
									var rList = result.DATA;
									if(result!='undefined') {
										var html = "";
										var code_html = "";
										for(var i=0;i<rList.length;i++){
											//html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+rList[i].brnm+"</span></button>";
											code_html += "<input type='hidden' name='brc' value='" + rList[i].brc + "' />";
											if(rList[i].uyn == 'Y') {
												$("#delCheck").val("0");
											}
										}
										$("#brcd_area").html(code_html);
										$("#brc_td").html(html);
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
				}
				else if($("#sel_level").val() == "2"){
					$("#btnDel").attr("disabled",false);
					$("#btnSave").attr("disabled",false);
					$("#lv1_bsn_prsnm").attr("disabled",true);
					$("#lv2_bsn_prsnm").attr("disabled",true);
					$("#lv3_bsn_prsnm").attr("disabled",true);
					$("#lv4_bsn_prsnm").attr("disabled",true);
					//$("#lv4_eng_bsn_prsnm").attr("disabled",false);
					$("#btnDeptSch").attr("disabled",true);
					
					if(mySheet.GetCellValue(Row,"bsn_prss_c") == ""){
						$("#mode").val("I");
						mySheet.SetBlur();
						$("#lv4_bsn_prsnm").focus();
					}else{
						$("#mode").val("U");
						
						//업무프로세스 사용부서 조회
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "bcp");
						WP.setParameter("process_id", "ORBC011403");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
							{
								success: function(result){
									removeLoadingWs();
									var rList = result.DATA;
									if(result!='undefined') {
										var html = "";
										var code_html = "";
										for(var i=0;i<rList.length;i++){
											//html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+rList[i].brnm+"</span></button>";
											code_html += "<input type='hidden' name='brc' value='" + rList[i].brc + "' />";
										}
										$("#brcd_area").html(code_html);
										$("#brc_td").html(html);
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
				}
				else if($("#sel_level").val() == "3"){
					$("#btnDel").attr("disabled",false);
					$("#btnSave").attr("disabled",false);
					$("#lv1_bsn_prsnm").attr("disabled",true);
					$("#lv2_bsn_prsnm").attr("disabled",true);
					$("#lv3_bsn_prsnm").attr("disabled",true);
					$("#lv4_bsn_prsnm").attr("disabled",true);
					//$("#lv4_eng_bsn_prsnm").attr("disabled",false);
					$("#btnDeptSch").attr("disabled",true);
					
					if(mySheet.GetCellValue(Row,"bsn_prss_c") == ""){
						$("#mode").val("I");
						mySheet.SetBlur();
						$("#lv4_bsn_prsnm").focus();
					}else{
						$("#mode").val("U");
						
						//업무프로세스 사용부서 조회
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "bcp");
						WP.setParameter("process_id", "ORBC011403");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
							{
								success: function(result){
									removeLoadingWs();
									var rList = result.DATA;
									if(result!='undefined') {
										var html = "";
										var code_html = "";
										for(var i=0;i<rList.length;i++){
											//html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+rList[i].brnm+"</span></button>";
											code_html += "<input type='hidden' name='brc' value='" + rList[i].brc + "' />";
										}
										$("#brcd_area").html(code_html);
										$("#brc_td").html(html);
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
				}
				else if($("#sel_level").val() == "4"){
					$("#btnDel").attr("disabled",false);
					$("#btnSave").attr("disabled",false);
					$("#lv1_bsn_prsnm").attr("disabled",true);
					$("#lv2_bsn_prsnm").attr("disabled",true);
					$("#lv3_bsn_prsnm").attr("disabled",true);
					$("#lv4_bsn_prsnm").attr("disabled",false);
					//$("#lv4_eng_bsn_prsnm").attr("disabled",false);
					$("#btnDeptSch").attr("disabled",false);
					
					if(mySheet.GetCellValue(Row,"bsn_prss_c") == ""){
						$("#mode").val("I");
						mySheet.SetBlur();
						$("#lv4_bsn_prsnm").focus();
					}else{
						$("#mode").val("U");
						
						//업무프로세스 사용부서 조회
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "bcp");
						WP.setParameter("process_id", "ORBC011403");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
							{
								success: function(result){
									removeLoadingWs();
									var rList = result.DATA;
									if(result!='undefined') {
										var html = "";
										var code_html = "";
										for(var i=0;i<rList.length;i++){
											html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+rList[i].brnm+"</span></button>";
											code_html += "<input type='hidden' name='brc' value='" + rList[i].brc + "' />";
										}
										$("#brcd_area").html(code_html);
										$("#brc_td").html(html);
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
				}else{
					$("#btnDel").attr("disabled",true);
					$("#btnSave").attr("disabled",true);
					$("#lv1_bsn_prsnm").attr("disabled",true);
					$("#lv2_bsn_prsnm").attr("disabled",true);
					$("#lv3_bsn_prsnm").attr("disabled",true);
					$("#lv4_bsn_prsnm").attr("disabled",true);
					//$("#lv4_eng_bsn_prsnm").attr("disabled",false);
					$("#btnDeptSch").attr("disabled",true);
					$("#mode").val("");
				}
								
			}
		}
		
		function init(){
			$("#lv1_bsn_prsnm").val("");
	    	$("#lv1_eng_bsn_prsnm").val("");
	    	$("#lv1_bsn_prss_c").val("");
	    	$("#lv2_bsn_prsnm").val("");
	    	$("#lv2_eng_bsn_prsnm").val("");
	    	$("#lv2_bsn_prss_c").val("");
	    	$("#lv3_bsn_prsnm").val("");
	    	$("#lv3_eng_bsn_prsnm").val("");
	    	$("#lv3_bsn_prss_c").val("");
	    	$("#lv4_bsn_prsnm").val("");
	    	$("#lv4_eng_bsn_prsnm").val("");
	    	$("#lv4_bsn_prss_c").val("");
	    	$("#brcd_area").html("");
	    	$("#brc_td").html("");
	    	$("#sel_bsn_prss_c").val("");
	    	$("#sel_level").val("");
	    	$("#mode").val("");
	    	
	    	$("#btnDel").attr("disabled",true);
			$("#btnSave").attr("disabled",true);
			$("#lv4_bsn_prsnm").attr("disabled",true);
			$("#lv4_eng_bsn_prsnm").attr("disabled",true);
			$("#btnDeptSch").attr("disabled",true);
		}
		
		function objCopy(new_code){
			var srow = mySheet.GetSelectRow();
			
			mySheet.SetCellText(srow, "lv4_bsn_prsnm", $("#lv4_bsn_prsnm").val());
			mySheet.SetCellText(srow, "lv4_eng_bsn_prsnm", $("#lv4_eng_bsn_prsnm").val());
			mySheet.SetCellText(srow, "bsn_prsnm", $("#lv4_bsn_prsnm").val());
			if($("#mode").val() == "I"){
				mySheet.SetCellValue(srow, "lv4_bsn_prss_c", new_code);
				$("#lv4_bsn_prss_c").val(new_code);
				$("#sel_bsn_prss_c").val(new_code);
				mySheet.SetCellValue(srow, "bsn_prss_c", new_code);
				$("#mode").val("U");
			}
		}
		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet.ShowTreeLevel(0,1);
			}
		}
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
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
			<input type="hidden" id="sel_bsn_prss_c" name="sel_bsn_prss_c" />
			<input type="hidden" id="sel_level" name="sel_level" />
			<input type="hidden" id="brcd_area" name="brcd_area" />
			<input type="hidden" id="mode" name="mode" />
			<input type="hidden" id="delCheck" name="delCheck" />
			<div id="hdn_area"></div>
			<div class="box box-grid">
				<div class="row">
					<div class="col w40p">
						<div class="box-header">
							<h2 class="box-title">업무 프로세스 코드</h2>
							<div class="area-tool">
								<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction('down2excel')">
									<i class="ico xls"></i>
									<span class="txt">엑셀 다운로드</span>
								</button>
							</div>
						</div>
						<div>
						<table>
							<tr>
								<td>
								    <button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('1');"><i class="fa fa-plus"></i><span class="txt">모두 펼치기</span></button>
									<button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('2');"><i class="fa fa-minus"></i><span class="txt">모두 접기</span></button>
								</td>
							</tr>
						</table>
					</div>
						<div class="box-body">
							<div class="wrap-grid h500">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
						<div class="box-footer">
							<div class="btn-wrap text-right">
								<button type="button" class="btn btn-default btn-sm" onclick="javascript:doAction('insert')"><i class="fa fa-plus"></i><span class="txt">하위 업무프로세스 추가</span></button>
							</div>
						</div>
					</div>

					<div class="col w60p">
						<div class="box-header">
							<h2 class="box-title">업무 프로세스 코드 정보</h2>
						</div>
						<div class="box-body">
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 100px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th rowspan="2">프로세스 Lv.1</th>
											<td class="form-inline">
												<input type="text" name="lv1_bsn_prsnm" id="lv1_bsn_prsnm" class="form-control w49p" disabled>
												<!-- <input type="text" name="lv1_eng_bsn_prsnm" id="lv1_eng_bsn_prsnm" class="form-control w49p" disabled> -->
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" name="lv1_bsn_prss_c" id="lv1_bsn_prss_c" class="form-control w200" disabled>
											</td>
										</tr>
										<tr>
											<th rowspan="2">프로세스 Lv.2</th>
											<td class="form-inline">
												<input type="text" name="lv2_bsn_prsnm" id="lv2_bsn_prsnm" class="form-control w49p" disabled>
												<!-- <input type="text" name="lv2_eng_bsn_prsnm" id="lv2_eng_bsn_prsnm" class="form-control w49p" disabled> -->
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" name="lv2_bsn_prss_c" id="lv2_bsn_prss_c" class="form-control w200" disabled>
											</td>
										</tr>
										<tr>
											<th rowspan="2">프로세스 Lv.3</th>
											<td class="form-inline">
												<input type="text" name="lv3_bsn_prsnm" id="lv3_bsn_prsnm" class="form-control w49p" disabled>
												<!-- <input type="text" name="lv3_eng_bsn_prsnm" id="lv3_eng_bsn_prsnm" class="form-control w49p" disabled> -->
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" name="lv3_bsn_prss_c" id="lv3_bsn_prss_c" class="form-control w200" disabled>
											</td>
										</tr>
										<tr>
											<th rowspan="2">프로세스 Lv.4</th>
											<td>
												<div class="form-inline">
													<input type="text" name="lv4_bsn_prsnm" id="lv4_bsn_prsnm" class="form-control w49p" maxlength="100" disabled>
													<!-- <input type="text" name="lv4_eng_bsn_prsnm" id="lv4_eng_bsn_prsnm" class="form-control w49p" disabled> -->
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" name="lv4_bsn_prss_c" id="lv4_bsn_prss_c" class="form-control w200" disabled>
											</td>
										</tr>
										<tr>
											<th>사용부서</th>
											<td>
												<div class="form-inline">
													<span class="input-group-btn vaT">
														<button class="btn btn-default ico search" type="button" id="btnDeptSch" onclick="org_popup();" disabled>
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button>
													</span>
													<div id="brc_td" class="ib w90p"></div>
												</div>	
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="box-footer">
							<div class="btn-wrap">
								<button type="button" id="btnSave" class="btn btn-primary" disabled onclick="javascript:doAction('save')">
									<span class="txt">저장</span>
								</button>
								<button type="button" id="btnDel" class="btn btn-default" disabled onclick="javascript:doAction('del')">
									<span class="txt">삭제</span>
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			</form>
		</div>
		<!-- content //-->
		
	</div>
	<!-- popup -->
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서멀티 공통 팝업 -->
	<script>		
		function org_popup(){
			var brcs = new Array();
			$("input[name=brc]").each(function(idx){
				brcs.push($(this).val());
			});
			var bizo_tpcs = new Array();
			$("input[name=bizo_tpc]").each(function(idx){
				bizo_tpcs.push($(this).val());
			});
			
			schOrgMPopup(brcs, bizo_tpcs, "orgSearchEnd","0");//처리모드(0:전체,1:본부부서,2:본부부서+영업점유형 )
		}
		
		function orgSearchEnd(brc, brnm, bizo_tpc, bizo_tpc_nm){
			var html = "";
			var code_html = "";
			for(var i=0;i<brc.length;i++){
				html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+brnm[i]+"</span></button>";
				code_html += "<input type='hidden' name='brc' value='" + brc[i] + "' />";
			}
			for(var i=0;i<bizo_tpc.length;i++){
				html += "<button type='button' class='btn btn-sm btn-default'><span class='txt'>"+bizo_tpc_nm[i]+"</span></button>";
				code_html += "<input type='hidden' name='bizo_tpc' value='" + bizo_tpc[i] + "' />";
			}
		
			$("#brcd_area").html(code_html);
			$("#brc_td").html(html);
			$("#winBuseoM").hide();
			//doAction('search');
		}
		
	</script>	
</body>
</html>