<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0107.jsp
 Program name : ADMIN > 코드관리 > 공통코드관리
 Description  : 
 Programer    : 박승윤
 Date created : 2022.06.16
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		<script>
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet1();
				createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
				//initIBSheet2();
				//initIBSheet3();
			});
			
			$(document).ready(function(){
				initIBSheet2();
				createIBSheet2(document.getElementById("mydiv3"),"mySheet3", "0px", "0px");
			});
			
			$(document).ready(function(){
				initIBSheet3();
				$("#mydiv3").hide();
			});
			
			/***************************************************************************************/
			/* 코드메인(mySheet1) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet1() {
				//시트 초기화
				mySheet1.Reset();
				
				var initData1 = {};
				
				initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData1.Cols = [
				    {Header:"상태",				Type:"Status",		SaveName:"status",			Width:50,	Align:"center"				},
	 				{Header:"삭제",				Type:"DelCheck",	SaveName:"del_check",		Width:70,	Align:"Center"				},
			    	{Header:"코드구분",			Type:"Text",		SaveName:"intg_grp_c",		Hidden:true								},
				    {Header:"코드구분명",			Type:"Text",		SaveName:"intg_grp_cnm",	Hidden:true								},
				    {Header:"코드구분명(한글)",		Type:"Text",		SaveName:"intg_cnm",		Width:250,	Align:"Left",	EditLen:50	},
				    {Header:"코드구분(영문)",		Type:"Text",		SaveName:"intgc_new",		Width:250,	Align:"Left",	EditLen:40	},
				    {Header:"코드구분(영문)_ori",	Type:"Text",		SaveName:"intgc",			Hidden:true								},
				    {Header:"만기일",				Type:"Text",		SaveName:"due_dt",			Hidden:true								},
				    {Header:"비고",				Type:"Text",		SaveName:"rmk_cntn",		Hidden:true								},
				    {Header:"정렬순서",			Type:"Int",			SaveName:"sort_sq",			Width:60,	Align:"Center",	EditLen:5	}
				];
				
				
				IBS_InitSheet(mySheet1,initData1);
				
				//필터표시
				//mySheet1.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet1.SetCountPosition(3);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet1.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				mySheet1.InitComboNoMatchText(1,"",1);  
				//최초 조회시 포커스를 감춘다.
				mySheet1.SetFocusAfterProcess(0);
				
				mySheet1.SetAutoRowHeight(1);
				
				//mySheet1.SetEditable(0);
	
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet1);
				//mySheet1.SetTheme("GM", "Main");
				
				doAction_mySheet1('search');
			}
			/***************************************************************************************/
			/* 코드상세(mySheet2) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet2() {
				//시트 초기화
				mySheet2.Reset();
				
				var initData2 = {};
				
				initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData2.Cols = [
				    {Header:"상태",		Type:"Status",		SaveName:"status",			Align:"Center",	Width:30						},
	 				{Header:"삭제",		Type:"DelCheck",	SaveName:"del_check",		Align:"Center", Width:40						},
			    	{Header:"코드구분",	Type:"Text",		SaveName:"intg_grp_c",		Align:"Center",	Width:100,	Edit:false			},
				    {Header:"코드구분명",	Type:"Text",		SaveName:"intg_grp_cnm",	Align:"Center",	Width:100,	Edit:false			},
				    {Header:"코드",		Type:"Text",		SaveName:"intgc_new",		Align:"Center",	Width:70,	EditLen:50			},
				    {Header:"코드_ori",	Type:"Text",		SaveName:"intgc",			Align:"Left",	Width:0,	Hidden:true			},
				    {Header:"코드명",		Type:"Text",		SaveName:"intg_cnm",		Align:"Left",	Width:100,	EditLen:150			},
				    {Header:"만기일",		Type:"Date",		SaveName:"due_dt",			Align:"Center",	Width:60,	Format:"yyyy-MM-dd"	},
				    {Header:"비고",		Type:"Text",		SaveName:"rmk_cntn",		Align:"Left",	Width:80,	EditLen:100			},
				    {Header:"정렬순서",	Type:"Int",			SaveName:"sort_sq",			Align:"Center",	Width:50,	EditLen:5			}
			    ];
				
				
				IBS_InitSheet(mySheet2,initData2);
				
				//필터표시
				//mySheet2.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet2.SetCountPosition(3);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet2.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				mySheet2.InitComboNoMatchText(1,"",1);  
				//최초 조회시 포커스를 감춘다.
				mySheet2.SetFocusAfterProcess(0);
				
				mySheet2.SetAutoRowHeight(1);
				
				//mySheet2.SetEditable(0);
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet1);
				//mySheet1.SetTheme("GM", "Main");
				
				//doAction_mySheet2('search');
			}
			
			/***************************************************************************************/
			/* 코드엑셀다운(mySheet3) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet3() {
				//시트 초기화
				mySheet3.Reset();
				
				var initData3 = {};
				
				initData3.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData3.Cols = [
			    	{Header:"코드구분",	Type:"Text",		SaveName:"intg_grp_c",		Align:"Left",	Width:150	},
				    {Header:"코드구분명",	Type:"Text",		SaveName:"intg_grp_cnm",	Align:"Left",	Width:250	},
				    {Header:"코드",		Type:"Text",		SaveName:"intgc",			Align:"Left",	Width:120	},
				    {Header:"코드명",		Type:"Text",		SaveName:"intg_cnm",		Align:"Left",	Width:250	},
				    {Header:"만기일",		Type:"Date",		SaveName:"due_dt",			Align:"Center",	Width:90,	Format:"yyyy-MM-dd"	},
				    {Header:"비고",		Type:"Text",		SaveName:"rmk_cntn",		Align:"Left",	Width:100	},
				    {Header:"정렬순서",	Type:"Int",			SaveName:"sort_sq",			Align:"Center",	Width:90	}
				];
				
				IBS_InitSheet(mySheet3,initData3);
				
				//필터표시
				//mySheet3.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet3.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet3.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				mySheet3.InitComboNoMatchText(1,"",1);  
				//최초 조회시 포커스를 감춘다.
				mySheet3.SetFocusAfterProcess(0);
				
				mySheet3.SetAutoRowHeight(1);
				
				//mySheet3.SetEditable(0);
	
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet3);
				//mySheet3.SetTheme("GM", "Main");
				
				doAction_mySheet3('search');
			}
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			/*Sheet 각종 처리*/
			function doAction_mySheet1(sAction) {
				switch(sAction) {
					case "search":  //손실금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD010702");
						$("form[name=ormsForm] [name=intg_grp_c]").val("0000");
						$("form[name=ormsForm] [name=intg_grp_cnm]").val($("#sch_intg_grp_cnm").val());
						mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "insert":		//로우추가
						//추가처리;
						var row = mySheet1.DataInsert(-1);
						mySheet1.SetCellValue(row,"due_dt","99991231");
						mySheet1.SetCellValue(row,"sort_sq",parseInt(mySheet1.GetCellValue(mySheet1.GetDataLastRow()-1, "sort_sq"))+10);
						if(mySheet1.GetCellValue(mySheet1.GetSelectRow(), "status") != "I"){
							$('#btn_grp_2').css({
								"display" : "block"
							});
						}else{
							$('#btn_grp_2').css({
								"display" : "none"
							});
						}
						mySheet1.SelectCell(row,"intg_cnm","1");
						mySheet2.RemoveAll();
						break; 
					case "save":		//저장 처리
						for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
							
							if(mySheet1.GetCellValue(i,"status") != "D"){
								if(mySheet1.GetCellValue(i,"intg_cnm") == ""){
									alert("코드구분명(한글)을 입력해 주십시오.");
									mySheet1.SelectCell(i,"intg_cnm","1");
									return;
								}
								
								if(mySheet1.GetCellValue(i,"intgc_new") == ""){
									alert("코드구분(영문)을 입력해 주십시오.");
									mySheet1.SelectCell(i,"intgc_new","1");
									return;
								}
								
								if(mySheet1.GetCellValue(i, "status")=="I"){
									
									mySheet1.SetCellValue(i, "intg_grp_c","0000");
									mySheet1.SetCellValue(i, "intg_grp_cnm",mySheet1.GetCellValue(i, "intg_cnm"));
								}
								
								for(var j = mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
									if(i != j && mySheet1.GetCellValue(i, "intgc_new") == mySheet1.GetCellValue(j, "intgc_new")){
										alert("동일한 코드구분이 있습니다. 코드구분을 변경해주세요");
										mySheet1.SelectCell(i, "intgc_new");
										return;
									}
									
									if(i != j && mySheet1.GetCellValue(i, "sort_sq") == mySheet1.GetCellValue(j, "sort_sq")){
										alert("중복된 정렬순서가 존재합니다.");
										mySheet1.SelectCell(i, "sort_sq");
										return;
									}
								}
							}
						}
					
						/*
						if($("input:checkbox[name=allApplyCk1]").is(":checked") == true){	
							mySheet1.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD010703&all_apply_yn=Y",{Quest:0});
						}else{
							mySheet1.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD010703&all_apply_yn=N",{Quest:0});
						}
						*/
						
						mySheet1.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD010703&all_apply_yn=N",{Quest:0});
						
						break;
					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "공통코드정보.xlsx",  SheetName : "Sheet1", DownTreeHide:"True", DownCols:"4|5|7"} ;

						mySheet1.Down2Excel(params);
						break;
				}
			}

			function doAction_mySheet2(sAction) {
				switch(sAction) {
					case "search":  //보험금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD010702");
						$("form[name=ormsForm] [name=intg_grp_c]").val(mySheet1.GetCellValue(mySheet1.GetSelectRow(), "intgc"));
						$("form[name=ormsForm] [name=intg_grp_cnm]").val("");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "insert":		//로우추가
						//추가처리;
						if(mySheet1.GetSelectRow() == -1){
							alert("좌측의 메인통합코드를 먼저 선택하세요.");
							return;
						}
						if(mySheet1.GetCellValue(mySheet1.GetSelectRow(), "status") == "I"){
							alert("메인통합코드를 저장한 후 수행할 수 있습니다.");
							return;
						}
						var row = mySheet2.DataInsert(-1);
						mySheet2.SetCellValue(row,"intg_grp_c",mySheet1.GetCellValue(mySheet1.GetSelectRow(), "intgc"));				
						mySheet2.SetCellValue(row,"intg_grp_cnm",mySheet1.GetCellValue(mySheet1.GetSelectRow(), "intg_cnm"));
						if(mySheet2.GetDataLastRow()==1){
							mySheet2.SetCellValue(row,"sort_sq",10);				
						}else{
							mySheet2.SetCellValue(row,"sort_sq",parseInt(mySheet2.GetCellValue(mySheet2.GetDataLastRow()-1, "sort_sq"))+10);				
						}
						mySheet2.SetCellValue(row,"due_dt","99991231");
						mySheet2.SelectCell(row,"intgc_new","1");
						break; 
					case "save":		//저장 처리
						if(mySheet1.GetSelectRow() == -1){
							alert("좌측의 메인통합코드를 먼저 선택하세요.");
							return;
						}
						if(mySheet1.GetCellValue(mySheet1.GetSelectRow(), "status") == "I"){
							alert("메인통합코드를 저장한 후 수행할 수 있습니다.");
							return;
						}
						for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
							if(mySheet2.GetCellValue(i, "intgc_new") == ""){
								alert("상세 코드를 입력해 주십시오.");
								mySheet2.SelectCell(i, "intgc_new", 1);
								return;
							}
							if(mySheet2.GetCellValue(i, "intg_cnm") == ""){
								alert("상세 코드명을 입력해 주십시오.");
								mySheet2.SelectCell(i, "intg_cnm", 1);
								return;
							}
							for(var j = mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
								if((i != j) && (mySheet2.GetCellValue(i, "intgc_new") == mySheet2.GetCellValue(j, "intgc_new"))){
									alert("중복된 상세코드를 확인해 주시기 바랍니다.");
									return;
								}
							}
						}
						
						/*
						if($("input:checkbox[name=allApplyCk2]").is(":checked") == true){	
							mySheet2.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD010703&all_apply_yn=Y",{Quest:0});
						}else{
							mySheet2.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD010703&all_apply_yn=N",{Quest:0});
						}
						*/
						
						mySheet2.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD010703&all_apply_yn=N",{Quest:0});
						
						break; 
				}
			}
			
			function doAction_mySheet3(sAction) {
				switch(sAction) {
					case "search":  //손실금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD010702");
						$("form[name=ormsForm] [name=intg_grp_c]").val("");
						$("form[name=ormsForm] [name=intg_grp_cnm]").val("");
						mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "공통코드정보.xlsx",  SheetName : "Sheet1", DownTreeHide:"True"} ;

						mySheet3.Down2Excel(params);
						break;
				}
			}
			
			function mySheet1_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("코드메인조회 중에 오류가 발생하였습니다.");
				}else{
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						mySheet1.SetCellValue(i, "intgc_new", mySheet1.GetCellValue(i, "intgc"));
						mySheet1.SetCellValue(i, "status", "");
					}
					//doAction_mySheet2("search");
				}
			}
			
			function mySheet2_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("코드상세조회 중에 오류가 발생하였습니다.");
				}else{
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						mySheet2.SetCellValue(i, "intgc_new", mySheet2.GetCellValue(i, "intgc")); 
						mySheet2.SetCellValue(i, "status", "");
					}
				}
			}
			
			function mySheet3_OnSearchEnd(code, message) {
				if(code != 0) {
				}else{
				}
			}
			
			function mySheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
			}
			
			function mySheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
			}
			
			function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
				if(mySheet1.GetCellValue(mySheet1.GetSelectRow(), "status") != "I"){
					$('#btn_grp_2').css({
						"display" : "block"
					});
					doAction_mySheet2('search');
				}else{
					mySheet2.RemoveAll();
					$('#btn_grp_2').css({
						"display" : "none"
					});
				}
				
			}
			
			function mySheet1_OnSaveEnd(code, msg) {
			    if(code >= 0) {
			    	alert("저장되었습니다.");
			    	doAction_mySheet1("search");
			    	mySheet2.RemoveAll();
			    	$('#btn_grp_2').css({
						"display" : "none"
					});
			    	$("#intg_grp_c").val("");
			    	$("#intg_grp_cnm").val("");
			    	
			    } else {
			    	alert("처리중 오류가 발생하였습니다.");
			    }
			}
			
			function mySheet2_OnSaveEnd(code, msg) {
			    if(code >= 0) {
			    	alert("저장되었습니다.");
			    	doAction_mySheet2("search");      
			    } else {
			    	alert("처리중 오류가 발생하였습니다.");
			    }
			}
			
			function EnterkeySubmit(){
				if(event.keyCode == 13){
					doAction_mySheet1("search");
					return true;
				}else{
					return true;
				}
			}

		</script>
	</head>
	<body class="">
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			<div class="content">
				<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="intg_grp_c" name="intg_grp_c" />
				<input type="hidden" id="intg_grp_cnm" name="intg_grp_cnm" />
				
				<div class="row">
					<div class="col col-xs-5">
						<div class="box box-grid">
							<div class="box-header">
								<div class="form-inline">
									<label for="sch_intg_grp_cnm" class="pr10">코드구분명</label>
									<input class="form-control w150" id="sch_intg_grp_cnm" type="text" value="" onkeypress="EnterkeySubmit();">
									<button type="button" class="btn btn-primary btn-sm" onclick="doAction_mySheet1('search')">조회</button>
								</div>
								<div class="area-tool">
									<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction_mySheet3('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
								</div>
							</div>
							<div class="box-body">
								<div class="wrap-grid h550">
									<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
								</div><!-- .wrap //-->
							</div><!-- .box-body //-->
							<div class="box-footer">
								<div class="btn-wrap">
								<%--
									<%if("00".equals(grp_org_c)){ %>
									<span class="checkbox-custom">
										<input type="checkbox" name="allApplyCk1" id="allApplyCk1" checked>
										<label for="allApplyCk1"><i></i><span>계열사일괄적용</span></label>
									</span>
									<%} %>
								--%>
									<button type="button" class="btn btn-default" onclick="javascript:doAction_mySheet1('insert')">추가</button>
									<button type="button" class="btn btn-primary" onclick="javascript:doAction_mySheet1('save')">저장</button>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-xs-7">
						<div class="box box-grid">
							<div class="box-header"></div>
							<div class="box-body">
								<div id="mydiv2" class="wrap-grid h550">
									<!-- <script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script> -->
								</div><!-- .wrap //-->
							</div><!-- .box-body //-->
							<div class="box-footer" id="btn_grp_2" style="display : none;">
								<div class="btn-wrap">
								<%-- 								
									<%if("00".equals(grp_org_c)){ %>
									<span class="checkbox-custom">
										<input type="checkbox" name="allApplyCk2" id="allApplyCk2" checked>
										<label for="allApplyCk2"><i></i><span>계열사일괄적용</span></label>
									</span>
									<%} %>
								--%>
									<button type="button" class="btn btn-default" onclick="javascript:doAction_mySheet2('insert')">추가</button>
									<button type="button" class="btn btn-primary" onclick="javascript:doAction_mySheet2('save')">저장</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="mydiv3" style="display:none">
					<!-- <script type="text/javascript"> createIBSheet("mySheet3", "0px", "0px"); </script> -->
				</div>
				</form>
			</div><!-- .content //-->
		</div><!-- .container //-->	
	</body>
</html>