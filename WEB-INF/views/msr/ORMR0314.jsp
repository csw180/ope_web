<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0314.jsp
 Program name : 내부자본한도설정
 Description  : 
 Programer    : 
 Date created : 2022.05.23
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			$("#sch_bas_yy").change(function() {
				if($("#sch_bas_yy option:selected").data("saveyn")=="Y"){
					$("#new_load_yn").prop("checked",false);
					$("#new_load_yn").attr("disabled",false);
				}else{
					$("#new_load_yn").prop("checked",true);
					$("#new_load_yn").attr("disabled",true);
				}
				if($("#sch_bas_yy").val()!="") $("#search_btn").trigger("click");
			});
			
			$("#sch_sbdr_c").change(function() {
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "msr");
				WP.setParameter("process_id", "ORMR031402");
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				showLoadingWs(); // 프로그래스바 활성화
				
				WP.load(url, inputData,{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="0") {
							var rList = result.DATA;
							var html="";
							for(var i=0;i<rList.length;i++){
								html += "<option data-saveyn='"+rList[i].save_yn+"' data-uploadsqno='"+rList[i].upload_sqno+"' value='"+rList[i].bas_yy+"'>"+rList[i].bas_yy+"</option>";
							}
							$("#sch_bas_yy").html(html);
							$("#sch_bas_yy").trigger("change");

						}else if(result!='undefined' && result.rtnCode!="0"){
							alert(result.rtnMsg);
						}
					},
					  
					complete: function(statusText,status) {
						removeLoadingWs();
					},
					  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
				});
			});
			
			$("#sch_rgo_in_dsc").change(function() {
				var html = "";
				if($("#sch_rgo_in_dsc").val()=="1"){ //규제자본
					html += "<option value='00'></option>";
					$("#sch_sbdr_c").attr("disabled",true);
				}else{
				<%-- <%
					for(int i=0;i<vLst1.size();i++){
						HashMap hMap = (HashMap)vLst1.get(i);
				%>
					html += "<option value='<%=(String)hMap.get("intgc")%>'><%=(String)hMap.get("intg_cnm")%></option>";
				<%
					}
				%>
					$("#sch_sbdr_c").attr("disabled",false); --%>
				}
				$("#sch_sbdr_c").html(html);
				$("#sch_sbdr_c").trigger("change");
			});
			
			$("#sch_rgo_in_dsc").trigger("change");

		});
		
		
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet1();
			createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
			//initIBSheet2();
			//initIBSheet3();
		});

		$(document).ready(function(){
			initIBSheet2();
			//$("#search_btn").trigger("click");
		});
		
		/*Sheet1(권한) 기본 설정 */
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "MergeSheet": msHeaderOnly, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, DeferredVScroll:1, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"구분|구분",							Type:"Text",						SaveName:"gubun_nm",	Align:"Center",	Edit:0,	Width:100,	MinWidth:50							},
 				{Header:"Case1|BIC & LC ' + 99%",			Type:"Float",	Format : "#,##0",	SaveName:"case1",		Align:"Right",	Edit:0,	Width:250,	MinWidth:125						},
 				{Header:"Case2|BIC & LC ' + 95%",			Type:"Float",	Format : "#,##0",	SaveName:"case2",		Align:"Right",	Edit:0,	Width:250,	MinWidth:125						},
 				{Header:"Case3|BIC & LC ' + 99% + Buffer",	Type:"Float",	Format : "#,##0",	SaveName:"case3",		Align:"Right",	Edit:0,	Width:250,	MinWidth:125						},
 				{Header:"Case4|BIC & LC ' + 95% + Buffer",	Type:"Float",	Format : "#,##0",	SaveName:"case4",		Align:"Right",	Edit:0,	Width:250,	MinWidth:125						},
 				{Header:"구분코드",							Type:"Text",						SaveName:"gubun",		Align:"Left",	Edit:0,	Width:50,	MinWidth:125,	Hidden:1		}
 			];
			IBS_InitSheet(mySheet1,initData);
			
			//mySheet1.SetEditable(0); //수정불가
			mySheet1.SetFocusAfterProcess(0);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);

            //컬럼의 너비 조정
			mySheet1.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			//sCenterName 셀의 경우 개행처리 허용 및 ColSpan 설정

			mySheet1.ShowFooterRow(
				{"gubun_nm": "한도채택", 
				 "case1": "<input onChange='cblmtChange(this);' type='checkbox' id='lmt_case1' >","case1#Type": "Html","case1#Align": "Center",
				 "case2": "<input onChange='cblmtChange(this);' type='checkbox' id='lmt_case2' >","case2#Type": "Html","case2#Align": "Center",
				 "case3": "<input onChange='cblmtChange(this);' type='checkbox' id='lmt_case3' >","case3#Type": "Html","case3#Align": "Center",
				 "case4": "<input onChange='cblmtChange(this);' type='checkbox' id='lmt_case4' >","case4#Type": "Html","case4#Align": "Center" });
			
			
			//doAction('lmtSearch');
			
		}
		
		function cblmtChange(obj) {
			if ($(obj).is(':checked')) {
				var id = $(obj).attr("id");
				if(id!="lmt_case1"){
					$("#lmt_case1").prop("checked",false);
					$("#simu_case1").prop("checked",false);
				}else{
					$("#simu_case1").prop("checked",true);
					myChartDraw(1);
				}
				if(id!="lmt_case2"){
					$("#lmt_case2").prop("checked",false);
					$("#simu_case2").prop("checked",false);
				}else{
					$("#simu_case2").prop("checked",true);
					myChartDraw(2);
				}
				if(id!="lmt_case3"){
					$("#lmt_case3").prop("checked",false);
					$("#simu_case3").prop("checked",false);
				}else{
					$("#simu_case3").prop("checked",true);
					myChartDraw(3);
				}
				if(id!="lmt_case4"){
					$("#lmt_case4").prop("checked",false);
					$("#simu_case4").prop("checked",false);
				}else{
					$("#simu_case4").prop("checked",true);
					myChartDraw(4);
				}
			}
		}
		
		
		/*Sheet2(메뉴) 기본 설정 */
		function initIBSheet2() {
			mySheet2.Reset();
			
			var initData = {};
			
			initData.HeaderMode = {Sort:0};
			initData.Cfg = {"SearchMode":smLazyLoad, "MergeSheet": msPrevColumnMerge+msHeaderOnly, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0, ChildPage:5, DeferredVScroll:1, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"구분|구분",		Type:"Text",	SaveName:"gubun_nm1",	Align:"Center",	Edit:0,	Width:50,	MinWidth:50							},
  				{Header:"구분|구분",		Type:"Text",	SaveName:"gubun_nm2",	Align:"Center",	Edit:0,	Width:50,	MinWidth:50							},
 				{Header:"Case1|Case11", 			Type:"Float",	Format : "#,##0",	SaveName:"case1",		Align:"Right",	Edit:0,	Width:150,	MinWidth:125						},
 				{Header:"Case2|Case21",			Type:"Float",	Format : "#,##0",	SaveName:"case2",		Align:"Right",	Edit:0,	Width:150,	MinWidth:125						},
 				{Header:"Case3|Case31",	Type:"Float",	Format : "#,##0",	SaveName:"case3",		Align:"Right",	Edit:0,	Width:150,	MinWidth:125						},
 				{Header:"Case4|Case41",	Type:"Float",	Format : "#,##0",	SaveName:"case4",		Align:"Right",	Edit:0,	Width:150,	MinWidth:125						},
 				{Header:"구분코드",	Type:"Text",	SaveName:"gubun",		Align:"Left",	Edit:0,	Width:120,	MinWidth:125,	Hidden:1		}
 			];
			IBS_InitSheet(mySheet2,initData);
			
			mySheet2.SetEditable(0); //수정불가
			mySheet2.FitColWidth();
			mySheet2.SetFocusAfterProcess(0);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet2.FitColWidth();
			
			mySheet2.SetHtmlHeaderValue(1, 2, "<input disabled type='checkbox' id='simu_case1' >",0);
			mySheet2.SetHtmlHeaderValue(1, 3, "<input disabled type='checkbox' id='simu_case2' >",0);
			mySheet2.SetHtmlHeaderValue(1, 4, "<input disabled type='checkbox' id='simu_case3' >",0);
			mySheet2.SetHtmlHeaderValue(1, 5, "<input disabled type='checkbox' id='simu_case4' >",0);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet2);
			
			//doAction('simuSearch');
			
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		//function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		function mySheet1_OnSelectCell(OldRow, OldCol, Row, Col,isDelete) {
			//if(Row >= mySheet1.GetDataFirstRow() && Col != 1){
			if(Row >= mySheet1.GetDataFirstRow()){
				
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
				return;
			}else{
				
			}
			
			if(mySheet1.GetDataFirstRow()>=0){
				for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
					if(mySheet1.GetCellValue(j,"gubun") == "04"){
						var info = {Type:"Float",	Format : "#,##0.00" };

						mySheet1.InitCellProperty(j, "case1", info);
						mySheet1.InitCellProperty(j, "case2", info);
						mySheet1.InitCellProperty(j, "case3", info);
						mySheet1.InitCellProperty(j, "case4", info);
					}
				}
			}
			
			$("#sv_bas_yy").val($("#sch_bas_yy").val());
			$("#upload_sqno").val($("#sch_bas_yy option:selected").data("uploadsqno"));
			$("#sv_rgo_in_dsc").val($("#sch_rgo_in_dsc").val());
			$("#sv_sbdr_c").val($("#sch_sbdr_c").val());
			$("#sv_mng_pln_rto").val($("#mng_pln_rto").val());
			$("#sv_lss_am").val($("#lss_am").val());

			mySheet1.FitColWidth();
			if($("#new_load_yn").prop("checked")){
				$("#lmt_case1").attr("disabled",false);
				$("#lmt_case2").attr("disabled",false);
				$("#lmt_case3").attr("disabled",false);
				$("#lmt_case4").attr("disabled",false);
				doAction('simuSearch');
			}else{
				$("#lmt_case1").attr("disabled",true);
				$("#lmt_case2").attr("disabled",true);
				$("#lmt_case3").attr("disabled",true);
				$("#lmt_case4").attr("disabled",true);
				doAction('svsimuSearch');
			}
		}
		
		
		
		function mySheet1_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	search();
		        
		    } else {
		    }
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
			
		}
		
		function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}

			if(mySheet2.GetDataFirstRow()>=0){
				for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
					if(mySheet2.GetCellValue(j,"gubun") == "12" 
						|| mySheet2.GetCellValue(j,"gubun") == "22"
						|| mySheet2.GetCellValue(j,"gubun") == "32"
						|| mySheet2.GetCellValue(j,"gubun") == "42"){
						var info = {Type:"Float",	Format : "#,##0.00" };

						mySheet2.InitCellProperty(j, "case1", info);
						mySheet2.InitCellProperty(j, "case2", info);
						mySheet2.InitCellProperty(j, "case3", info);
						mySheet2.InitCellProperty(j, "case4", info);
					}
				}
			}
			
			mySheet2.FitColWidth();

			if($("#new_load_yn").prop("checked")){
			}else{
				doAction('svSearch2');
			}
			//myChartDraw();
		}
		
	
		function mySheet2_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	alert("저장되었습니다");
		    } else {
		    }
		}
		
		
		function search() {
			$("#mng_pln_rto").val("");
			$("#lss_am").val("");
			if($("#new_load_yn").prop("checked")){
				$("#mng_pln_rto").prop("readonly",false);
				$("#lss_am").prop("readonly",false);
				$("#save_btn").attr("disabled",false);
				$("#lmt_search_btn").attr("disabled",false);
				doAction('lmtSearch');
			}else{
				$("#mng_pln_rto").prop("readonly",true);
				$("#lss_am").prop("readonly",true);
				$("#save_btn").attr("disabled",true);
				$("#lmt_search_btn").attr("disabled",true);
				doAction('svSearch1');
			}
											
		}
		
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "lmtSearch":  //내부자본한도설정 조회

					if($("#sch_bas_yy").val() == null || $("#sch_bas_yy").val() == ""){
						alert("조회 대상 년도가 없습니다.");
						return;
					}
				
					if($("#mng_pln_rto").val() != "" && isNaN($("#mng_pln_rto").val())){
						alert("경영계획은 숫자로 입력해야 합니다.");
						return;
					}
				
					if($("#mng_pln_rto").val() != "" && parseFloat($("#mng_pln_rto").val())< 0){
						alert("경영계획은 plus값으로 입력해야 합니다.");
						return;
					}
				
					if($("#lss_am").val() != "" && isNaN($("#lss_am").val())){
						alert("손실금액은 숫자로 입력해야 합니다.");
						return;
					}
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR031404");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "svSearch1":  //내부자본한도설정 조회

					if($("#sch_bas_yy").val() == null || $("#sch_bas_yy").val() == ""){
						alert("조회 대상 년도가 없습니다.");
						return;
					}
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR031408");

					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "svSearch2":  //내부자본한도설정 조회

					if($("#sch_bas_yy").val() == null || $("#sch_bas_yy").val() == ""){
						alert("조회 대상 년도가 없습니다.");
						return;
					}
				
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR031407");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					
					WP.load(url, inputData,{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="0") {
								var rList = result.DATA;
								if(rList.length>0){
									$("#mng_pln_rto").val(rList[0].mng_pln_rto);
									$("#lss_am").val(rList[0].lss_am);
									$("#lmt_case1").prop("checked",false);
									$("#lmt_case2").prop("checked",false);
									$("#lmt_case3").prop("checked",false);
									$("#lmt_case4").prop("checked",false);

									if(rList[0].coic_case_dsc=="01"){
										$("#lmt_case1").prop("checked",true);
										cblmtChange($("#lmt_case1"));
									}else if(rList[0].coic_case_dsc=="02"){
										$("#lmt_case2").prop("checked",true);
										cblmtChange($("#lmt_case2"));
									}else if(rList[0].coic_case_dsc=="03"){
										$("#lmt_case3").prop("checked",true);
										cblmtChange($("#lmt_case3"));
									}else if(rList[0].coic_case_dsc=="04"){
										$("#lmt_case4").prop("checked",true);
										cblmtChange($("#lmt_case4"));
									}
									
								}
	
							}else if(result!='undefined' && result.rtnCode!="0"){
								alert(result.rtnMsg);
							}
						},
						  
						complete: function(statusText,status) {
							removeLoadingWs();
						},
						  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
			
					break;
				case "simuSearch":  //내부자본 한도 소진율 시뮬레이션 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR031405");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "svsimuSearch":  //내부자본 한도 소진율 시뮬레이션 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR031409");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
					
				case "save":      //저장처리					
					if($("#lmt_case1").prop("checked")){
						$("#coic_case_dsc").val("01");
					}else if($("#lmt_case2").prop("checked")){
						$("#coic_case_dsc").val("02");
					}else if($("#lmt_case3").prop("checked")){
						$("#coic_case_dsc").val("03");
					}else if($("#lmt_case4").prop("checked")){
						$("#coic_case_dsc").val("04");
					}else{
						alert("케이스를 선택하세요.");
						return;
					}
					
					

					if(!confirm("저장하시겠습니까?")) return;
						
					html = "";
					for(var i=0;i<4;i++){
						//내부자본 한도 설정
						html += "<input type='hidden' id='case_dsc' name='case_dsc' value='" + "0" + (i+1) + "' />";	//케이스구분코드
						html += "<input type='hidden' id='est_buix_am' name='est_buix_am' value='" + mySheet1.GetCellValue(2,"case" + (i+1)) +"' />";	//추정영업지수요소금액
						html += "<input type='hidden' id='buix_lmt_am' name='buix_lmt_am' value='" + mySheet1.GetCellValue(3,"case" + (i+1)) + "' />";	//영업지수요소한도금액
						html += "<input type='hidden' id='lsx_lmt_am' name='lsx_lmt_am' value='" + mySheet1.GetCellValue(4,"case" + (i+1)) + "' />";	//손실요소한도금액
						html += "<input type='hidden' id='in_lss_mltplr_val' name='in_lss_mltplr_val' value='" + mySheet1.GetCellValue(5,"case" + (i+1)) + "' />";	//내부손실승수값
						html += "<input type='hidden' id='tot_ned_ownfds_lmt_am' name='tot_ned_ownfds_lmt_am' value='" + mySheet1.GetCellValue(6,"case" + (i+1)) + "' />";	//총소요자기자본한도금액
						//내부자본 한도 소진율
						/* for(var j=0;j<4;j++){
							html += "<input type='hidden' id='rt_case_dsc' name='rt_case_dsc' value='" + "0" + (i+1) + "' />";	//소진율케이스구분코드
							html += "<input type='hidden' id='bas_mm' name='bas_mm' value='" + (((j+1)*3 >9)?(j+1)*3:"0"+(j+1)*3) + "' />";	//기준월
							html += "<input type='hidden' id='tot_ned_ownfds' name='tot_ned_ownfds' value='" + mySheet2.GetCellValue(j*2+2,"case" + (i+1)) + "' />";	//총소요자기자본
							html += "<input type='hidden' id='lmt_rto' name='lmt_rto' value='" + mySheet2.GetCellValue(j*2+3,"case" + (i+1)) + "' />";	//소진율
						} */
					}
					
					//alert(html)
					$("#sv_area").html(html);

					
					/* var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR031406");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("저장되었습니다.");
								$("#sch_bas_yy option:selected").data("saveyn","Y")
								search();
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
					}); */
				
					break;
					
			}
		}
		
	</script>
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<!-- content -->
		<div class="content">
			<div class="box">
				<form name="ormsForm" method="post">
                <input type="hidden" id="path" name="path" />
                <input type="hidden" id="process_id" name="process_id" />
                <input type="hidden" id="commkind" name="commkind" />
                <input type="hidden" id="method" name="method" />
                <input type="hidden" id="sv_bas_yy" name="sv_bas_yy" />
                <input type="hidden" id="upload_sqno" name="upload_sqno" />
                <input type="hidden" id="sv_rgo_in_dsc" name="sv_rgo_in_dsc" />
                <input type="hidden" id="sv_sbdr_c" name="sv_sbdr_c" />
                <input type="hidden" id="sv_mng_pln_rto" name="sv_mng_pln_rto" />
                <input type="hidden" id="sv_lss_am" name="sv_lss_am" />
                <input type="hidden" id="coic_case_dsc" name="coic_case_dsc" />
                
                <div id="sv_area"></div>
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>기준 연도</th>
										<td>
											<div class="select w100">
												<select name="sch_bas_yy" id="sch_bas_yy" class="form-control">
												</select>
											</div>
											<span class="checkbox-custom">
												<input type="checkbox" class="form-control" id="new_load_yn" name="new_load_yn" checked>
												<label for="new_load_yn"><i></i><span>새로 가져오기</span></label>
											</span>
										</td>
										<th>자본량 기준</th>
										<td>
											<div class="select w150">
												<select name="sch_rgo_in_dsc" id="sch_rgo_in_dsc" class="form-control">
	<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
	%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
		}
	%>
												</select>
											</div>
										</td>
										<th>법인 선택</th>
										<td>
											<div class="select w150">
												<select name="sch_sbdr_c" id="sch_sbdr_c" class="form-control">
												</select>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .box-body //-->
					<div class="box-footer">
						<button id="search_btn" type="button" class="btn btn-primary search" onclick="javascript:search()">조회</button>
					</div>
				</div>
				<!-- 조회 //-->

				<div class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">내부자본한도설정</h2>		
						<div class="area-tool">
							<div class="btn-group">
								<button id="save_btn" class="btn btn-default btn-xs" type="button" onclick="javascript:doAction('save')"><i class="fa fa-save"></i><span class="txt">저장</span></button>
							</div>
						</div>	
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
										<th>수기조정</th>
										<td>
											<table>
												<colgroup>
													<col style="width: 100px;">
													<col>
													<col style="width: 100px;">
													<col>
													<col>
												</colgroup>
												<tbody>
													<tr>
														<th>경영계획</th>
														<td>
															<div class="select w200">
																<input type="text" name="mng_pln_rto" id="mng_pln_rto" class="form-control right w200" value=""  >
															</div>
															<span>%</span>
														</td>
														<th>손실금액</th>
														<td>
															<div class="select w200">
																<input type="text" name="lss_am" id="lss_am" class="form-control right w200" value="" >
															</div>
														</td>
														<td>
															<div class="btn-group">
																<button id="lmt_search_btn" type="button" class="btn btn-primary btn-sm" onclick="javascript:doAction('lmtSearch');">Buffer적용</button>
															</div>
														</td>
													</tr>
												</tbody>
											</table>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="box box-grid">
					<div class="box-body">
						<div class="wrap-grid h260">
							<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
						</div>
					</div>
				</div>
	
				<div class="box box-grid">				
					<div class="box-header">
						<h2 class="box-title">내부자본 한도 소진율 시뮬레이션</h2>
					</div>
						<div class="pa r0 t0"><span class="txt txt-sm">(단위 : 원)</span></div>
	
					<div class="row">
						<div class="col col-xs-6">
							<div class="box-grid">
								<!-- /.box-header -->
								<div class="box-body">
									<div id="mydiv2" class="wrap h320">
										<!-- <script> createIBSheet("mySheet2", "100%", "100%"); </script> -->
									</div>
								</div>
								<!-- /.box-body -->
							</div>	
						</div>
	
						<div class="col col-xs-6">
							<div class="box-grid">
								<div class="wrap-grid chart h320" id="div_myChart">
									<script>
										createIBChart("myChart", "100%", "100%"); 
									</script>	
								</div>
							</div>
						</div>
					</div>
				</div>
				</form>
			</div>
		</div>
		<!-- content //-->
	</div>
</body>
</html>