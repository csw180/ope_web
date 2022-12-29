<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0110.jsp
 Program name : 소관 업무프로세스 관리
 Description  : 
 Programmer   : 김병현
 Date created : 2022.07.07
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	String orm_brc = "", bcp_brc = "";
	Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList"); //운영리스크관리부서
	for(int i=0; i<vLst.size(); i++){
		HashMap hMap = (HashMap)vLst.get(0);
		orm_brc = (String)hMap.get("intgc");
	}
	
	Vector vLst2 = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList"); //BCP관리부서
	for(int i=0; i<vLst.size(); i++){
		HashMap hMap = (HashMap)vLst2.get(0);
		bcp_brc = (String)hMap.get("intgc");
	}

	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet1();
			initIBSheet2();
			initIBSheet3();
			initIBSheet4();
		});
		
		/*Sheet1 기본 설정 */
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData = {};
			//sizeNoHScroll
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, Sort:1,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"상위부서코드",			Type:"Text",	SaveName:"up_brc",			Hidden:true},
 				{Header:"레벨",				Type:"Text",	SaveName:"level",			Hidden:true},
 				{Header:"부서코드",			Type:"Text",	SaveName:"brc",				Hidden:true},
 				{Header:"차수",				Type:"Text",	SaveName:"lvl_no",			Hidden:true},
 				{Header:"사무소폐쇄여부",		Type:"Text",	SaveName:"br_lko_yn",		Hidden:true},
 				{Header:"지역코드",			Type:"Text",	SaveName:"rgn_c",			Hidden:true},
 				{Header:"본부영업점구분코드",		Type:"Text",	SaveName:"hofc_bizo_dsc",	Hidden:true},
 				{Header:"운영리스크조직여부",		Type:"Text",	SaveName:"uyn",				Hidden:true},
 				{Header:"최하위조직여부",		Type:"Text",	SaveName:"lwst_orgz_yn",	Hidden:true},
 				{Header:"팀장결재여부",			Type:"Text",	SaveName:"temgr_dcz_yn",	Hidden:true},
 				{Header:"부서명",				Type:"Text",	SaveName:"brnm",			TreeCol:1,	Width:580,	MinWidth:90}
 			];
			IBS_InitSheet(mySheet1,initData);
			
			mySheet1.SetEditable(0); //수정불가
			mySheet1.SetFocusAfterProcess(0);
			
			
			//필터표시
			mySheet1.ShowFilterRow();  
			
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
			
			doAction('orgSearch');
			
		}
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"부서|NO|NO",									Type:"Seq",		MinWidth:30,Align:"Center",SaveName:"status",},
			 	{Header:"부서|NO|NO",									Type:"CheckBox",	MinWidth:15,Align:"Center",SaveName:"ischeck"},
			 	{Header:"부서|LV1|Code",								Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv1_bsn_prss_c", Edit:false, Wrap:true},
				{Header:"리스크관리본부|LV1|프로세스",						Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv1_bsn_prsnm",Edit:false, Wrap:true},
				{Header:"리스크관리본부|LV2|Code",						Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv2_bsn_prss_c" ,Edit:false, Wrap:true},			
				{Header:"팀|LV2|프로세스",								Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv2_bsn_prsnm", Edit:false, Wrap:true},
				{Header:"팀|LV3|Code",								Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv3_bsn_prss_c",Edit:false, Wrap:true},
				{Header:"리스크관리팀|LV3|프로세스",						Type:"Text",			MinWidth:150,Align:"Center",SaveName:"lv3_bsn_prsnm", Edit:false, Wrap:true},
				{Header:"리스크관리팀|LV4|Code",						Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv4_bsn_prss_c", Edit:false, Wrap:true},
				{Header:"리스크관리팀|LV4|프로세스",						Type:"Text",	MinWidth:150,Align:"Center",SaveName:"lv4_bsn_prsnm",Edit:false, Wrap:true},		
				{Header:"프로세스",									Type:"Text",	MinWidth:150,Align:"Center",SaveName:"bsn_prss_c",Edit:false, Wrap:true, Hidden:true}		
			];
			IBS_InitSheet(mySheet2,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			$("#shw_btn").attr("disabled",true);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//헤더기능 해제
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			//doAction('search');
			doAction('brc_prss_Search');
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		function initIBSheet3() {
			//시트 초기화
			mySheet3.Reset();
			
			var initData = {};
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"NO|NO",								Type:"Seq",		MinWidth:30,Align:"Center",SaveName:"num",},
				{Header:"LV1|Code",								Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv1_bsn_prss_c", Edit:false, Wrap:true},
				{Header:"LV1|프로세스",							Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv1_bsn_prsnm",Edit:false, Wrap:true},
				{Header:"LV2|Code",								Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv2_bsn_prss_c" ,Edit:false, Wrap:true},			
				{Header:"LV2|프로세스",							Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv2_bsn_prsnm", Edit:false, Wrap:true},
				{Header:"LV3|Code",								Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv3_bsn_prss_c",Edit:false, Wrap:true},
				{Header:"LV3|프로세스",							Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv3_bsn_prsnm", Edit:false, Wrap:true},
				{Header:"LV4|Code",								Type:"Text",		MinWidth:150,Align:"Center",SaveName:"lv4_bsn_prss_c", Edit:false, Wrap:true},
				{Header:"LV4|프로세스",							Type:"Text",	MinWidth:150,Align:"Center",SaveName:"lv4_bsn_prsnm",Edit:false, Wrap:true},		
				{Header:"프로세스",								Type:"Text",	MinWidth:150,Align:"Center",SaveName:"bsn_prss_c",Edit:false, Wrap:true, Hidden:true}		
			];
			IBS_InitSheet(mySheet3,initData);
			mySheet3.SetEditable(0); //수정불가
			mySheet3.SetFocusAfterProcess(0);

			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet3.SetCountPosition(0);
			mySheet3.ShowFilterRow();
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet3.SetSelectionMode(4);
			$("#shw_btn").attr("disabled",true);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//헤더기능 해제
			mySheet3.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			//doAction('search');
			doAction('prssSearch');
		}
		
		function initIBSheet4() {
			mySheet4.Reset();
			
			var initData = {};
			//sizeNoHScroll
			initData.Cfg = {"SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, MergeSheet:msHeaderOnly, Sort:1,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"No|No",					Type:"Seq",		Align:"center", SaveName:"num"		},
 				{Header:"소관부서|부서",				Type:"Text",	Align:"center",	SaveName:"brnm",	MinWidth:90},
 				{Header:"소관부서|팀",					Type:"Text",	Align:"center",	SaveName:"team_cnm",	MinWidth:90},
 				{Header:"코드",						Type:"Text",	Align:"center",	SaveName:"brc",	Hidden:true}
 			];
			IBS_InitSheet(mySheet4,initData);
			
			mySheet4.SetEditable(0); //수정불가
			mySheet4.SetFocusAfterProcess(0);  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet4.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet4.SetSelectionMode(4);
            
            //컬럼의 너비 조정
			mySheet4.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			doAction('prss_brc_Search');
			
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet1.GetDataFirstRow()){
				$("#brc").val(mySheet1.GetCellValue(Row,"brc"));
				$("#sch_brc").val(mySheet1.GetCellValue(Row,"brc"));
				$("#brnm").val(mySheet1.GetCellValue(Row,"brnm"));
				$("#up_brc").val(mySheet1.GetCellValue(Row,"up_brc"));
				$("#lvl_no").val(mySheet1.GetCellValue(Row,"lvl_no"));
				$("#br_lko_yn").val(mySheet1.GetCellValue(Row,"br_lko_yn"));
				$("#rgn_c").val(mySheet1.GetCellValue(Row,"rgn_c"));
				$("#hofc_bizo_dsc").val(mySheet1.GetCellValue(Row,"hofc_bizo_dsc"));
				$("#uyn").val(mySheet1.GetCellValue(Row,"uyn"));
				$("#lwst_orgz_yn").val(mySheet1.GetCellValue(Row,"lwst_orgz_yn"));
				$("#temgr_dcz_yn").val(mySheet1.GetCellValue(Row,"temgr_dcz_yn"));
				$("#sel_level").val(mySheet1.GetCellValue(Row,"level"));
				if($("#lwst_orgz_yn").val() == "Y") {
					$("#uyn").attr("disabled",false);
				}
				else $("#uyn").attr("disabled",true);

				
				if("<%=orm_brc%>" == $("#sel_brc").val()){
					$("#orm_br_yn").val("Y");
				}else{
					$("#orm_br_yn").val("N");
				}
				if("<%=bcp_brc%>" == $("#sel_brc").val()){
					$("#bcp_br_yn").val("Y");
				}else{
					$("#bcp_br_yn").val("N");
				}
			doAction('brc_prss_Search');
			}
		}
		
		function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet3.GetDataFirstRow()){
				$("#sch_bsn_prss_c").val(mySheet3.GetCellValue(Row,"bsn_prss_c"));
				doAction('prss_brc_Search');		
			}
		}
		function mySheet4_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet4.GetDataFirstRow()){
				$("#sch_team_cd").val(mySheet4.GetCellValue(Row,"brc"));
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet1.ShowTreeLevel(1,1);
			}
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
			
			mySheet1.SetFocusAfterProcess(0);
			
		}
		
		function mySheet1_OnChangeFilter(){
		}
		
		function mySheet1_OnFilterEnd(RowCnt, FirstRow) {
			mySheet1.ShowTreeLevel(-1,0);
			mySheet1.SetFocusAfterProcess(0);
			mySheet1.SetBlur(1);
			$("#filter_txt").focus();
			
		}
		
		function mySheet1_OnAfterExpand(Row, Expand){
			mySheet1.FitColWidth();
		}
		
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "orgSearch":  //부서 조회
					$("#sel_brc").val("");
					$("#sch_uyn").val("");
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011002");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					//mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt2);
					break;
				case "prssSearch":  //프로세스 조회
					$("#sel_brc").val("");
					$("#sch_uyn").val("");
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011003");
					
					mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "add_prss":		//업무프로세스 신규등록 팝업
					$("#ifrPrssMod").attr("src","about:blank");
					$("#winPrssMod").show();
					showLoadingWs();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="adm";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORAD011101";
			        f.target = "ifrPrssMod";
					f.submit();
					break;
				case "add_org":		//프로세스 소관부서 신규등록 팝업
					if($("#sch_bsn_prss_c").val() == ""){
						alert('업무프로세스를 선택해주세요.');
						return;
					}
					$("#ifrOrgMod").attr("src","about:blank");
					$("#winOrgMod").show();
					showLoadingWs();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="adm";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORAD011201";
			        f.target = "ifrOrgMod";
					f.submit();
					break;
				case "save":      //저장할 데이터 추출
				
					$("#sch_uyn").val($("#uyn").val());
				
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					WP.setParameter("process_id", "ORAD011004");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							alert("저장완료");
							doAction('orgSearch');
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
					break;
				case "del_prss":		//삭제 처리
					del_prss();
					break;
				case "del_org":		//삭제 처리
					del_org();
					break;
				case "filter": //부서 선택
					
					mySheet2.RemoveAll();
					$("#sel_brc").val("");
				
					//mySheet.SetCellValue(mySheet.FindFilterRow(), "brnm","하노이지점");
					if($("#filter_txt").val()==""){
						mySheet1.ClearFilterRow()
					}else{
						mySheet1.SetFilterValue("brnm", $("#filter_txt").val(), 11);
					}
					break;
				case "brc_prss_Search":  //업무프로세스 > 소관부서 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011004");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "prss_brc_Search":  //업무프로세스 > 소관부서 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD011005");
					
					mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
					
			}
		}
		function del_prss(){
			var f = document.ormsForm;
			var add_html = "";
			if(mySheet2.GetDataFirstRow()>=0){
				for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
					if(mySheet2.GetCellValue(j,"ischeck")==1){
						add_html += "<input type='hidden' name='sch_bsn_prss_c' value='" + mySheet2.GetCellValue(j,"bsn_prss_c") + "'>";
					}
				}
			}
			if(add_html==""){
				alert("삭제할 프로세스를 선택하세요.");
				return;
			}

            tmp_area.innerHTML = add_html;
			
			var f = document.ormsForm;
			if(!confirm("선택한 프로세스를 삭제 하시겠습니까?")) return;
				
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "adm");
			WP.setParameter("process_id", "ORAD011006");
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
						  doAction('brc_prss_Search');
					  }
					  
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);			
		}
		function del_org(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "adm");
			WP.setParameter("process_id", "ORAD011007");
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
						  doAction('prss_brc_Search');
					  }
					  
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);			
		}

		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('filter');
				return true;
			}else{
				return true;
			}
		}
		function mySheet1_showAllTree(flag){
			if(flag == 1){
				mySheet1.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet1.ShowTreeLevel(0,1);
			}
		}
		
		
	</script>
</head>
<body class="" onkeyPress="return EnterkeyPass()">
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<!-- content -->
		<div class="content">
			<form name="ormsForm" method="post">
            <input type="hidden" id="sel_brc" name="sel_brc" /> <!-- 선택한 부서 코드 -->
            <input type="hidden" id="path" name="path" />
            <input type="hidden" id="process_id" name="process_id" />
            <input type="hidden" id="commkind" name="commkind" />
            <input type="hidden" id="method" name="method" />
            <input type="hidden" id="orm_br_yn" name="orm_br_yn" />
            <input type="hidden" id="bcp_br_yn" name="bcp_br_yn" />
            <input type="hidden" id="check_yn" name="check_yn" />
            <input type="hidden" id="sch_uyn" name="sch_uyn" />
            <input type="hidden" id="sel_level" name="sel_level" />
            <input type="hidden" id="sch_brc" name="sch_brc" />
            <input type="hidden" id="tmp_area" name="tmp_area" />
            <input type="hidden" id="sch_bsn_prss_c" name="sch_bsn_prss_c" />
            <input type="hidden" id="sch_team_cd" name="sch_team_cd" />
			<div class="wrap">
				<ul class="nav nav-tabs t1"> 	
					<li class="active"><a data-toggle="tab" href="#menu1">부서별</a></li>
					<li><a data-toggle="tab" href="#menu2">프로세스별</a></li>
				  </ul>
					 <div class="tab-content  mt20">
						 <div id="menu1" class="tab-pane fade in active">
						 	<div class="box box-grid">
								<div class="box-body">					
									<div class="row">
										<div class="col w30p">
											<div class="box-header">
												<h2 class="box-title">소관부서(팀)</h2>
											</div>
											<div class="box">
												<div class="box-body">
													<div class="wrap h500">
													<table>
														<tr>
															<td>
															    <button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet1_showAllTree('1');"><i class="fa fa-plus"></i><span class="txt">모두 펼치기</span></button>
																<button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet1_showAllTree('2');"><i class="fa fa-minus"></i><span class="txt">모두 접기</span></button>
															</td>
														</tr>
													</table>
														 <script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
													</div>
												</div>
											</div>
										</div>
										<div class="col w70p">
										<div class="box-header">
											<h2 class="box-title">업무 프로세스 목록</h2>
											<div class="area-tool">
												<div class="btn-wrap">
													<div class="btn-group">
														<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('add_prss')"><i class="fa fa-plus"></i><span class="txt">업무프로세스 추가</span></button>
														<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('del_prss');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
													</div>
												</div>
											</div>
										</div>
										<div class="box">
												<div class="box-body">
													<div class="wrap h500">
														 <script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script>
													</div>
												</div>
											</div>
									</div>
									</div>
								</div>
								<div class="box-footer">
									<div class="btn-wrap">
										<button type="button" class="btn btn-primary" onclick="javascript:doAction('save')">
											<span class="txt">저장</span>
										</button>
									</div>
								</div>
							</div>
						 </div>
						<div id="menu2" class="tab-pane fade">
							<div class="box box-grid">
								<div class="box-body">					
									<div class="row">
										<div class="col w70p">
										<div class="box-header">
											<h2 class="box-title">업무 프로세스 정보</h2>	
										</div>
										<div class="box">
												<div class="box-body">
													<div class="wrap h500">
														 <script type="text/javascript"> createIBSheet("mySheet3", "100%", "100%"); </script>
													</div>
												</div>
											</div>
										</div>
										<div class="col w30p">
											<div class="box-header">
												<h2 class="box-title">소관부서(팀)</h2>
												<div class="area-tool">
												<div class="btn-wrap">
													<div class="btn-group">
														<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('add_org')"><i class="fa fa-plus"></i><span class="txt">소관부서추가</span></button>
														<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('del_org');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
													</div>
												</div>
											</div>
											</div>
											<div class="box">
												<div class="box-body">
													<div class="wrap h500">
														 <script type="text/javascript"> createIBSheet("mySheet4", "100%", "100%"); </script>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="box-footer">
									<div class="btn-wrap">
										<button type="button" class="btn btn-primary" onclick="javascript:doAction('save')">
											<span class="txt">저장</span>
										</button>
									</div>
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
		<div id="winPrssMod" class="popup modal"> <!-- 업무프로세스 추가 -->
			<iframe name="ifrPrssMod" id="ifrPrssMod" src="about:blank"></iframe>
		</div>
		<div id="winOrgMod" class="popup modal"> <!-- 소관부서 업무프로세스 추가 -->
			<iframe name="ifrOrgMod" id="ifrOrgMod" src="about:blank"></iframe>
		</div>
</body>
</html>