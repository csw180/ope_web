<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0102.jsp
 Program name : 리스크풀관리 신규
 Description  : 화면정의서 RCSA-02.7
 Programer    : 박승윤
 Date created : 2022.06.17
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");
DynaForm form = (DynaForm)request.getAttribute("form");

Vector vRkpTpcLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vRkpTpcLst==null) vRkpTpcLst = new Vector();
Vector vTeamLst= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vTeamLst==null) vTeamLst = new Vector();
Vector vCtlTpcLst= CommUtil.getResultVector(request, "grp01", 0, "unit05", 0, "vList");
if(vCtlTpcLst==null) vCtlTpcLst = new Vector();

String rk_ctl_tpc = "";
String ctl_nm = "";
for(int i=0;i<vCtlTpcLst.size();i++){
	HashMap hp = (HashMap)vCtlTpcLst.get(i);
	if(rk_ctl_tpc==""){
		rk_ctl_tpc += (String)hp.get("rk_ctl_tpc");
		ctl_nm += (String)hp.get("ctl_nm");
	}else{
		rk_ctl_tpc += ("|" + (String)hp.get("rk_ctl_tpc"));
		ctl_nm += ("|" + (String)hp.get("ctl_nm"));
	}
}



System.out.println("rk_ctl_tpc:"+rk_ctl_tpc);
System.out.println("ctl_nm:"+ctl_nm);

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>팝업: 리스크풀 수정 팝업</title>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			//$("#winRskMod",parent.document).show();
			// ibsheet 초기화
			parent.removeLoadingWs();	
			initIBSheet1();
			initIBSheet2();
			initIBSheet3();
		});
		



		/***************************************************************************************/
		/* 통제(mySheet1) 처리                                                                                                                                                                                       */
		/***************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData1 = {};
			
			initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData1.Cols = [
			    //{Header:"통제유형코드1레벨",Type:"Text",Width:0,Align:"Center",SaveName:"rk_ctl_tpc_lv1",MinWidth:0, Hidden:true},
			    //{Header:"Lv1",Type:"Text",Width:"200",Align:"Left",SaveName:"ctl_nm_lv1",MinWidth:110},
			    {Header:"Lv1",Type:"Combo",Width:140,Align:"Left",SaveName:"rk_ctl_tpc_lv1",MinWidth:110,ComboText:"<%=ctl_nm%>",ComboCode:"<%=rk_ctl_tpc%>"},
			    //{Header:"통제유형코드2레벨",Type:"Text",Width:0,Align:"Center",SaveName:"rk_ctl_tpc_lv2",MinWidth:0, Hidden:true},
			    //{Header:"Lv2",Type:"Text",Width:"200",Align:"Left",SaveName:"ctl_nm_lv2",MinWidth:110},
			    {Header:"Lv2",Type:"Combo",Width:200,Align:"Left",SaveName:"rk_ctl_tpc_lv2",MinWidth:110},
				{Header:"통제내용",Type:"Text",Width:560,Align:"Left",SaveName:"ctl_cntn",MinWidth:260,Wrap:1,EditLen:800,MultiLineText:1}
			];
			
			IBS_InitSheet(mySheet1,initData1);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet1.SetCountPosition(0);
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
			mySheet1.InitComboNoMatchText(1,"",1);  
			//최초 조회시 포커스를 감춘다.
			mySheet1.SetFocusAfterProcess(0);
			
			mySheet1.SetAutoRowHeight(1);

			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			//mySheet1.SetTheme("GM", "Main");
			
//			doAction_mySheet1('search');
		}
		

		
		function mySheet1_OnChange(row,col,value){
			//대분류 컬럼 변경시 중분류 컬럼의 값을 변경한다.
			if(mySheet1.ColSaveName(col)=="rk_ctl_tpc_lv1"){
				var info = mySheet1.GetSearchData("<%=System.getProperty("contextpath")%>/comMain.do","method=Main&commkind=rsa&process_id=ORRC010206&up_rk_ctl_tpc="+mySheet1.GetCellValue(row,"rk_ctl_tpc_lv1"));
				
				//IE9이상에서 정상 동작하고 구 브라우져인 경우에는 json.org 에서 배포하는 json2.js 파일을 링크걸어야 합니다.
				var j = JSON.parse(info);
				mySheet1.CellComboItem(row,"rk_ctl_tpc_lv2",j);

				//첫번째의 값을 세팅해 준다.
				var arr = j.ComboText.split("|");
				if(arr.length>0){
					mySheet1.SetCellText(row,"rk_ctl_tpc_lv2",arr[0]);
				}
			}
				
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		}

		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet1.GetDataFirstRow()){
			}
		}
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet1_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction_mySheet1("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction_mySheet1("loadexcel");
			}
		}
		
		function mySheet1_setSecondCombo(nr){
			try{
				//중분류의 code 값을 확인
				var status = mySheet1.GetCellValue(nr,"sStatus");
				//var v = mySheet1.GetCellText(nr,"rk_ctl_tpc_lv2");
				var v = mySheet1.GetCellValue(nr,"rk_ctl_tpc_lv2");
				var info = mySheet1.GetSearchData("<%=System.getProperty("contextpath")%>/comMain.do","method=Main&commkind=rsa&process_id=ORRC010206&up_rk_ctl_tpc="+mySheet1.GetCellValue(nr,"rk_ctl_tpc_lv1"));
				var j = JSON.parse(info);
				mySheet1.CellComboItem(nr,"rk_ctl_tpc_lv2",j);
				
				//원래의 값을 세팅해 준다.
				//mySheet1.SetCellText(nr,"rk_ctl_tpc_lv2",v);
				mySheet1.SetCellValue(nr,"rk_ctl_tpc_lv2",v);
				if(status=="R"){
					mySheet1.SetCellValue(nr,"sStatus","R");
				}
			}catch(e){
				alert(e.message);
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(mySheet1.GetDataFirstRow()>=0){
					for(var i=mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						//alert(""+mySheet1.GetDataFirstRow()+":"+mySheet1.GetDataLastRow());
						mySheet1_setSecondCombo(i);
					}
				}
			}
			$("#ctl_cnt").text(mySheet1.RowCount());
			//$(".p_body").scrollTop(cur_pos);

			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/*Sheet 각종 처리*/
		function doAction_mySheet1(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC010203");
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
					mySheet1.RemoveAll();
					initIBSheet();
					break;
				case "insert":		//신규등록 팝업
					//추가처리;
					var row = mySheet1.DataInsert();
					mySheet1_OnChange(row,0,"");
					$("#ctl_cnt").text(mySheet1.RowCount()); 

					break; 
				case "delete":		//삭제 처리
					if(mySheet1.GetSelectRow() < 0){
						alert("삭제대상통제를 선택하세요.");
						return;
					}else{
						//삭제처리;
						mySheet1.RowDelete(mySheet1.GetSelectRow(), 1);
						$("#ctl_cnt").text(mySheet1.RowCount()); 
					}
					break; 
				case "down2excel":
					
					//setExcelDownCols("1|2|3|4");
					mySheet1.Down2Excel(excel_params);

					break;
			}
		}

		/***************************************************************************************/
		/* 손실사건 목록 조회(mySheet2) 처리                                                                                                                                                                                       */
		/***************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData2 = {};
			
			initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData2.Cols = [
				{Header:"선택",Type:"CheckBox",Width:70,Align:"Left",SaveName:"ischeck",MinWidth:50},
			    {Header:"손실사건관리번호",Type:"Text",Width:0,Align:"Center",SaveName:"lshp_amnno",MinWidth:0, Hidden:true},
			    {Header:"발생일자",Type:"Date",Width:95,Align:"Center",SaveName:"ocu_dt",MinWidth:60,Edit:0},
			    {Header:"총손실금액",Type:"Text",Width:120,Align:"Right",SaveName:"tot_lssam",MinWidth:60,Edit:0},
				{Header:"손실사건제목",Type:"Text",Width:500,Align:"Left",SaveName:"lshp_tinm",MinWidth:110,Edit:0, EditLen:200}
			];
			
			IBS_InitSheet(mySheet2,initData2);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//mySheet2.SetEditable(0);

			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//mySheet2.FitColWidth();
			
			//최초 조회시 포커스를 감춘다.
			//mySheet2.SetFocusAfterProcess(0);

			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
		//	doAction_mySheet2('search');
			
			//alert($(".p_body").scrollTop());			
		}
		
		//행을 선택시 잽싸게 중분류에 들어갈 값을 가져다 세팅한다.
		function mySheet2_OnSelectCell(or,oc,nr,nc){
		}

		function mySheet2_OnChange(row,col,value){
		}

		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet2.GetDataFirstRow()){
			}
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet2.GetDataFirstRow()){
			}
		}
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet2_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction_mySheet2("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction_mySheet2("loadexcel");
			}
		}
		
		function mySheet2_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
			$("#loss_cnt").text(mySheet2.RowCount()); 
			
			for(var nCnt=mySheet2.GetDataFirstRow(); nCnt <= mySheet2.GetDataLastRow(); nCnt++){
				var totLssam = "0";
				console.log(mySheet2.GetCellValue(nCnt,"tot_lssam"));
				if(mySheet2.GetCellValue(nCnt,"tot_lssam") != "0" && mySheet2.GetCellValue(nCnt,"tot_lssam") != null){
					totLssam = setFormatCurrency(mySheet2.GetCellValue(nCnt,"tot_lssam"),",");
				}
				mySheet2.SetCellValue(nCnt,"tot_lssam",totLssam);
			}
			//$(".p_body").scrollTop(cur_pos);
			
			//mySheet2.FitColWidth();
		}

		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/*Sheet 각종 처리*/
		function doAction_mySheet2(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC010204");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet2.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					
					//setExcelDownCols("1|2|3|4");
					mySheet2.Down2Excel(excel_params);

					break;
			}
		}

		/***************************************************************************************/
		/* KRI 목록 조회(mySheet2) 처리                                                                                                                                                                                       */
		/***************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet3() {
			//시트 초기화
			mySheet3.Reset();
			
			var initData3 = {};
			
			initData3.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
			initData3.Cols = [
				{Header:"선택",Type:"CheckBox",Width:70,Align:"Left",SaveName:"ischeck",MinWidth:50},
			    {Header:"리스크지표ID",Type:"Text",SaveName:"rki_id", Hidden:true},
			    {Header:"리스크지표명",Type:"Text",Width:300,Align:"Left",SaveName:"rki_nm",MinWidth:60,Edit:0},
				{Header:"리스크지표목적내용",Type:"Text",Width:400,Align:"Left",SaveName:"rki_obv_cntn",MinWidth:110,Edit:0}
			];
			
			IBS_InitSheet(mySheet3,initData3);
			
			//필터표시
			//mySheet3.ShowFilterRow(); 
			
			//mySheet3.SetEditable(0);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet3.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet3.SetSelectionMode(4);
			
			//mySheet3.FitColWidth();
			
			//최초 조회시 포커스를 감춘다.
			//mySheet3.SetFocusAfterProcess(0);

			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet3);
			
		//	doAction_mySheet3('search');
			
		}
		
		//행을 선택시 잽싸게 중분류에 들어갈 값을 가져다 세팅한다.
		function mySheet3_OnSelectCell(or,oc,nr,nc){
		}

		function mySheet3_OnChange(row,col,value){
		}

		function mySheet3_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet3.GetDataFirstRow()){
			}
		}
		
		function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet3.GetDataFirstRow()){
			}
		}
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet3_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction_mySheet3("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction_mySheet3("loadexcel");
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

		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/*Sheet 각종 처리*/
		function doAction_mySheet3(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC010205");
					mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet3.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					
					//setExcelDownCols("1|2|3|4");
					mySheet3.Down2Excel(excel_params);

					break;
			}
		}

		function update(){
		}
		
		function save(){
			
			var f = document.ormsForm;
			var ctl_html = "";
			

			if(f.prss.value==''){
				alert("업무프로세스를 선택하십시오.");
				f.prssnm1.focus();
				return;
			}

			if(f.hpn.value==''){
				alert("손실사건유형을 선택 하십시요.");
				f.hpnnm1.focus();
				return;
			}
			
			if(f.cas.value==''){
				alert("원인유형을 선택 하십시요.");
				f.casnm1.focus();
				return;
			}
			
			if(f.ifn.value==''){
				alert("손실영향유형을 선택 하십시요.");
				f.ifnnm1.focus();
				return;
			}
			
			if(mySheet1.GetDataFirstRow()>=0){
				for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){

					for(var k=j+1; k<=mySheet1.GetDataLastRow(); k++){
						if(mySheet1.GetCellValue(j,"rk_ctl_tpc_lv2")==mySheet1.GetCellValue(k,"rk_ctl_tpc_lv2")){
							alert("중복 지정한 통제가 있습니다.");
							return;
						}
					}
					if(mySheet1.GetCellValue(j,"ctl_cntn") == ""){
						alert("통제내용을 입력해 주십시오.");
						mySheet1.SelectCell(j,"ctl_cntn",1);
						return;
					}
				}
				for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
					ctl_html += "<input type='hidden' name='rk_ctl_tpc_lv2' value='" + mySheet1.GetCellValue(j,"rk_ctl_tpc_lv2") + "'>";
					ctl_html += "<input type='hidden' name='ctl_cntn' value='" + mySheet1.GetCellValue(j,"ctl_cntn") + "'>";
				}
			}
			ctl_area.innerHTML = ctl_html;
			
			var loss_html = "";
			if(mySheet2.GetDataFirstRow()>=0){
				for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
					loss_html += "<input type='hidden' name='lshp_amnno' value='" + mySheet2.GetCellValue(j,"lshp_amnno") + "'>";
				}
			}
			loss_area.innerHTML = loss_html;
			
			var kri_html = "";
			if(mySheet3.GetDataFirstRow()>=0){
				for(var j=mySheet3.GetDataFirstRow(); j<=mySheet3.GetDataLastRow(); j++){
					kri_html += "<input type='hidden' name='rki_id' value='" + mySheet3.GetCellValue(j,"rki_id") + "'>";
				}
			}
			kri_area.innerHTML = kri_html;
			
			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC010202");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			console.log(inputData);
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("저장되었습니다.");
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
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
		
		function prss_change(){
		}
		
		
	</script>

</head>
<body>
	<!-- 팝업 -->
	<div class="popup modal block" >
		<div class="p_frame w1100">
			<div class="p_head">
				<h1 class="title">리스크풀 신규등록</h1>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<form name="ormsForm" method="post">
						<input type="hidden" id="path" name="path" />
						<input type="hidden" id="process_id" name="process_id" />
						<input type="hidden" id="commkind" name="commkind" />
						<input type="hidden" id="method" name="method" />
						<input type="hidden" id="mode" name="mode" value="I" />
						<input type="hidden" id="prss" name="prss" value="" />
						<input type="hidden" id="emrk" name="emrk" value="" />
						<input type="hidden" id="cas" name="cas" value="" />
						<input type="hidden" id="hpn" name="hpn" value="" />
						<input type="hidden" id="ifn" name="ifn" value="" />
						<input type="hidden" id="rkp_tpc" name="rkp_tpc" value="" />
						<input type="hidden" id="apl_aflco_dsc" name="apl_aflco_dsc" value="" />
						<input type="hidden" id="brc" name="brc" value="" />
						<input type="hidden" id="team_cd" name="team_cd" value="" />
						<div id="ctl_area"></div>
						<div id="loss_area"></div>
						<div id="kri_area"></div>
						<div id="brcd_area"></div>
						<div class="row">
							<div class="col">
								<section class="box box-grid">
									<div class="box-header">
										<h2 class="box-title">업무프로세스</h2>
									</div>
									<div class="wrap-table">
										<table>
											<colgroup>
												<col style="width: 100px;">
												<col>
											</colgroup>
											<tbody>
												<tr>
													<th>대분류</th>
													<td>
														<div class="input-group">
															<input type="text" class="form-control" id="prssnm1" value=""  readonly>
															<span class="input-group-btn">
																<button type="button" class="btn btn-default ico" onclick="prss_popup();">
																	<i class="fa fa-search"></i><span class="blind">검색</span>
																</button>
															</span>
														</div>
													</td>
												</tr>
												<tr>
													<th>중분류</th>
													<td>
														<input type="text" class="form-control" id="prssnm2" value=""  readonly>
													</td>
												</tr>
												<tr>
													<th>단위업무</th>
													<td>
														<input type="text" class="form-control" id="prssnm3" value=""  readonly>
													</td>
												</tr>
												<tr>
													<th>세부업무</th>
													<td>
														<input type="text" class="form-control" id="prssnm4" value=""  readonly>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
								<section class="box box-grid">
									<div class="box-header">
										<h2 class="box-title">이머징리스크 유형</h2>
									</div>
									<div class="wrap-table">
										<table>
											<colgroup>
												<col style="width: 100px;">
												<col>
											</colgroup>
											<tbody>
												<tr>
													<th>Lv.1</th>
													<td>
														<div class="input-group">
															<input type="text" class="form-control" id="emrknm1" value=""  readonly>
															<span class="input-group-btn">
																<button type="button" class="btn btn-default ico fl" onclick="emrk_popup();">
																	<i class="fa fa-search"></i><span class="blind">검색</span>
																</button>
															</span>
														</div>
													</td>
												</tr>
												<tr>
													<th>Lv.2</th>
													<td>
														<input type="text" class="form-control" id="emrknm2" value=""  readonly>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
								<section class="box box-grid">
									<div class="box-header">
										<h2 class="box-title">영향유형</h2>
									</div>
									<div class="wrap-table">
										<table>
											<colgroup>
												<col style="width:100px;">
												<col>
											</colgroup>
											<tbody>
												<tr>
													<th>Lv 1</th>
													<td>
														<div class="input-group">
															<input type="text" class="form-control" id="ifnnm1" value=""  readonly>
															<span class="input-group-btn">
																<button type="button" class="btn btn-default ico" onclick="ifn_popup();">
																	<i class="fa fa-search"></i><span class="blind">검색</span>
																</button>
															</span>
														</div>
													</td>
												</tr>
												<tr>
													<th>Lv 2</th>
													<td>
														<input type="text" class="form-control" id="ifnnm2" value=""  readonly>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
							</div>
							<div class="col">
								<section class="box box-grid">
									<div class="box-header">
										<h2 class="box-title">원인유형</h2>
									</div>
									<div class="wrap-table">
										<table>
											<colgroup>
												<col style="width:100px;">
												<col>
											</colgroup>
											<tbody>
												<tr>
													<th>Lv 1</th>
													<td>
														<div class="input-group">
															<input type="text" class="form-control" id="casnm1" value=""  readonly>
															<span class="input-group-btn">
																<button type="button" class="btn btn-default ico" onclick="cas_popup();">
																	<i class="fa fa-search"></i><span class="blind">검색</span>
																</button>
															</span>
														</div>
													</td>
												</tr>
												<tr>
													<th>Lv 2</th>
													<td>
														<input type="text" class="form-control" id="casnm2" value=""  readonly>
													</td>
												</tr>
												<tr>
													<th>Lv 3</th>
													<td>
														<input type="text" class="form-control" id="casnm3" value=""  readonly>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
								<section class="box box-grid">
									<div class="box-header">
										<h2 class="box-title">사건유형</h2>
									</div>
									<div class="wrap-table">
										<table>
											<colgroup>
												<col style="width:100px;">
												<col>
											</colgroup>
											<tbody>
												<tr>
													<th>Lv 1</th>
													<td>
														<div class="input-group">
															<input type="text" class="form-control" id="hpnnm1" value=""  readonly>
															<span class="input-group-btn">
																<button type="button" class="btn btn-default ico" onclick="hpn_popup();">
																	<i class="fa fa-search"></i><span class="blind">검색</span>
																</button>
															</span>
														</div>
													</td>
												</tr>
												<tr>
													<th>Lv 2</th>
													<td>
														<input type="text" class="form-control" id="hpnnm2" value=""  readonly>
													</td>
												</tr>
												<tr>
													<th>Lv 3</th>
													<td>
														<input type="text" class="form-control" id="hpnnm3" value=""  readonly>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
								<section class="box box-grid">
									<div class="box-header">
										<h2 class="box-title">평가부서/팀</h2>
									</div>
									<div class="wrap-table">
										<table>
											<colgroup>
												<col style="width: 100px;">
												<col>
											</colgroup>
											<tbody>
												<tr>
													<th>부서</th>
													<td>
															<input type="text" class="form-control" id="brnm" value=""  readonly>										
													</td>
												</tr>
												<tr id="team_chg" hidden>
													<th>팀</th>
													<td>
														<div class="input-group">
															<input type="text" class="form-control" id="target_evl_team" value=""  readonly>
															<span class="input-group-btn">
																<button type="button" class="btn btn-default ico" onclick="team_popup();">
																	<i class="fa fa-search"></i><span class="blind">검색</span>
																</button>
															</span>															
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
							</div>
						</div>
						<section class="box box-grid">
							<div class="box-header">
								<h2 class="box-title">리스크 사례</h2>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 100px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>RP ID</th>
											<td>
												<input type="text" class="form-control" id="rkp_id" name="rkp_id" value=""  readonly>
											</td>
										</tr>
										<tr>
											<th>내용</th>
											<td>
												<textarea id="rk_isc_cntn" name="rk_isc_cntn" cols="100" rows="5" class="form-control textarea" ></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</section>
						<section class="box box-grid">
							<div class="box-header">
								<h2 class="box-title">통제</h2>
								<div class="area-tool">
									<div class="btn-group">
										<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction_mySheet1('insert')"><i class="fa fa-plus"></i><span class="blind">추가</span></button>
										<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction_mySheet1('delete')"><i class="fa fa-minus"></i><span class="blind">삭제</span></button>
									</div>
								</div>
							</div>
							<div class="box-body">
								<div class="wrap-grid  h250">
									<script type="text/javascript"> createIBSheet("mySheet1", "100%", "240px"); </script>
								</div><!-- .wrap-grid //-->
							</div>
						</section>
						<div class="box grid">
							<div class="row">
								<section class="col">
									<div class="box-header">
										<h2 class="box-title">손실사건</h2>
										<div class="area-tool">
											<button type="button" class="btn btn-xs btn-default" onClick="schLossPopup()"><i class="fa fa-plus"></i><span class="txt">연관 손실사건 등록</span></button>
											<button type="button" class="btn btn-xs btn-default" onClick="delRelLoss()"><span class="txt">삭제</span></button>
										</div>
									</div>
									<div class="box-body">
										<div class="wrap-grid h250">
											<script> createIBSheet("mySheet2", "100%", "100%"); </script>
										</div>
									</div>
								</section>
								<section class="col">
									<div class="box-header">
										<h2 class="box-title">KRI</h2>
										<div class="area-tool">
											<button type="button" class="btn btn-xs btn-default" onClick="schKriPopup()"><i class="fa fa-plus"></i><span class="txt">연관 KRI 등록</span></button>
											<button type="button" class="btn btn-xs btn-default" onClick="delRelKri()"><span class="txt">삭제</span></button>
										</div>
									</div>
									<div class="wrap-grid h250">
										<script> createIBSheet("mySheet3", "100%", "100%"); </script>
									</div>
								</section>
							</div>
						</div><!-- .box.grid //-->
					</form>
				</div><!-- .p_wrap //-->	
			</div><!-- .p_body //-->	
			<div class="p_foot">
				<div class="btn-wrap center">
					<button type="button" class="btn btn-primary" onclick="javascript:save();">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<div id='winLoss' class='popup modal' style="background-color:transparent">
		<iframe id='ifrLoss' src="about:blank" name='ifrLoss' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
	</div>
	<div id='winKri' class='popup modal'>
		<iframe id='ifrKri' src="about:blank" name='ifrKri' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
	</div>
	
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	<%@ include file="../comm/EmrkInfP.jsp" %> <!-- 이머징리스크유형 공통 팝업 -->
	<%@ include file="../comm/TeamInfp.jsp" %> <!-- 팀 공통 팝업 -->
	<script>
	
		// 업무프로세스검색 완료
		var PRSS4_ONLY = true; 
		var CUR_BSN_PRSS_C = "";
		
		function prss_popup(){
			CUR_BSN_PRSS_C = $("#prss").val();
			if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
			schPrssPopup();
		}
		

		function prssSearchEnd(bsn_prss_c, bsn_prsnm
								, bsn_prss_c_lv1, bsn_prsnm_lv1
								, bsn_prss_c_lv2, bsn_prsnm_lv2
								, bsn_prss_c_lv3, bsn_prsnm_lv3
								, biz_trry_c_lv1, biz_trry_cnm_lv1
								, biz_trry_c_lv2, biz_trry_cnm_lv2){
			$("#prss").val(bsn_prss_c);
			$("#prssnm4").val(bsn_prsnm);
			$("#prssnm1").val(bsn_prsnm_lv1);
			$("#prssnm2").val(bsn_prsnm_lv2);
			$("#prssnm3").val(bsn_prsnm_lv3);
			
			if(bsn_prss_c.charAt(0)=="B")
			{
				$("#team_chg").hide();
				$("#brnm").val("영업점");
				$("#brc").val("");
				$("#team_cd").val("");
				$("#target_evl_team").val("");
				$("#rkp_tpc").val("03");
				$("#apl_aflco_dsc").val("03");
			}else if(bsn_prss_c.charAt(0)=="H" && $("#brc").val()=="")
			{
				$("#team_chg").show();
				$("#brnm").val("");
				$("#brc").val("");
				$("#team_cd").val("");
				$("#target_evl_team").val("");
				$("#rkp_tpc").val("02");				
				$("#apl_aflco_dsc").val("02");				
			}
			
			$("#winPrss").hide();
		}
		
		// 손실사건유형검색 완료
		var HPN3_ONLY = true; 
		var CUR_HPN_TPC = "";
		
		function hpn_popup(){
			CUR_HPN_TPC = $("#tpc").val();
			if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
			schHpnPopup();
		}
		
		function hpnSearchEnd(hpn_tpc, hpn_tpnm, hpn_tpc_lv1, hpn_tpnm_lv1, hpn_tpc_lv2, hpn_tpnm_lv2){
			$("#hpn").val(hpn_tpc);
			$("#hpnnm3").val(hpn_tpnm);
			$("#hpnnm1").val(hpn_tpnm_lv1);
			$("#hpnnm2").val(hpn_tpnm_lv2);
			
			$("#winHpn").hide();
			//doAction('search');
		}
		
		// 원인유형검색 완료
		var CAS3_ONLY = true; 
		var CUR_CAS_TPC = "";
		
		function cas_popup(){
			CUR_CAS_TPC = $("#cas").val();
			if(ifrCas.cur_click!=null) ifrCas.cur_click();
			schCasPopup();
		}
		
		function casSearchEnd(cas_tpc, cas_tpnm, cas_tpc_lv1, cas_tpnm_lv1, cas_tpc_lv2, cas_tpnm_lv2){
			$("#cas").val(cas_tpc);
			$("#casnm3").val(cas_tpnm);
			$("#casnm1").val(cas_tpnm_lv1);
			$("#casnm2").val(cas_tpnm_lv2);
			
			$("#winCas").hide();
			//doAction('search');
		}
		
		// 영향유형검색 완료
		var IFN2_ONLY = true; 
		var CUR_IFN_TPC = "";
		
		function ifn_popup(){
			CUR_IFN_TPC = $("#ifn").val();
			if(ifrIfn.cur_click!=null) ifrIfn.cur_click();
			schIfnPopup();
		}
		
		function ifnSearchEnd(ifn_tpc, ifn_tpnm, ifn_tpc_lv1, ifn_tpnm_lv1){
			$("#ifn").val(ifn_tpc);
			$("#ifnnm2").val(ifn_tpnm);
			$("#ifnnm1").val(ifn_tpnm_lv1);
			
			$("#winIfn").hide();
			//doAction('search');
		}
		
		// 이머징리스크유형검색 완료
		var EMRK2_ONLY = true; 
		var CUR_EMRK_TPC = "";
		
		function emrk_popup(){
			CUR_EMRK_TPC = $("#emrk").val();
			schEmrkPopup();
		}
		
		function emrkSearchEnd(emrk_tpc, emrk_tpnm
							, emrk_tpc_lv1, emrk_tpnm_lv1){
			
			$("#emrk").val(emrk_tpc);
			$("#emrknm2").val(emrk_tpnm);
			$("#emrknm1").val(emrk_tpnm_lv1);
			
			$("#winEmrk").hide();
			//doAction('search');
		}
		
		
		function addRelLoss(lshp_amnno, ocu_dt, tot_lssam, lshp_tinm){
			var bAddFlag = true;
			
			for(var nCnt=mySheet2.GetDataFirstRow(); nCnt <= mySheet2.GetDataLastRow(); nCnt++){
				if( mySheet2.GetCellValue(nCnt,"lshp_amnno") == lshp_amnno ){
					bAddFlag = false;
					break;
				}
			}

			if( bAddFlag ){
				// 맨 마직막에 추가
				var row = mySheet2.DataInsert(999);

				mySheet2.SetCellValue(row, "lshp_amnno", lshp_amnno);
				mySheet2.SetCellValue(row, "ocu_dt", ocu_dt);
				mySheet2.SetCellValue(row, "tot_lssam", tot_lssam);
				mySheet2.SetCellValue(row, "lshp_tinm", lshp_tinm);
			}
		}
		
		function addRelKri(rki_id, rki_nm, rki_obv_cntn){
			var bAddFlag = true;
			
			for(var nCnt=mySheet3.GetDataFirstRow(); nCnt <= mySheet3.GetDataLastRow(); nCnt++){
				if( mySheet3.GetCellValue(nCnt,"rki_id") == rki_id ){
					bAddFlag = false;
					break;
				}
			}

			if( bAddFlag ){
				// 맨 마직막에 추가
				var row = mySheet3.DataInsert(999);

				mySheet3.SetCellValue(row, "rki_id", rki_id);
				mySheet3.SetCellValue(row, "rki_nm", rki_nm);
				mySheet3.SetCellValue(row, "rki_obv_cntn", rki_obv_cntn);
			}
		}
		
		function delRelLoss(){
			//체크된 행이 있는지 찾아본다.
			var rows = mySheet2.FindCheckedRow("ischeck");

			if(rows==""){
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				
				mySheet2.RowDelete(rows);
				
			}
			$("#loss_cnt").text(mySheet2.RowCount());
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
	</script>
	<script>
	$(document).ready(function(){
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			parent.$("#ifrRskAdd").attr("src","about:blank");
			event.preventDefault();
		});
		/*
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").hide();
		});
		*/
	});
		
	function closeLoss(){
		//$("#winLoss").hide();
		$("#winLoss").hide();
	}
	
	var cnt=0;
	function openLoss(){
		var ifm = document.getElementById("ifrLoss");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winLoss").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openLoss,100);
		}
	}
	
	function schLossPopup(){
		showLoadingWs(); // 프로그래스바 활성화
		
		$("#ifrLoss").ready(function(){
			cnt=0;
			setTimeout(openLoss,100);
		});

		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC010401";
		f.target = "ifrLoss";
		f.submit();
	}
	
	function closeKri(){
		//$("#winKri").hide();
		$("#winKri").hide();
	}
	
	var cnt=0;
	function openKri(){
		var ifm = document.getElementById("ifrKri");
		if(ifm.contentDocument.readyState == "complete"){
			$("#winKri").show();
		}else{
			if(cnt>1000){
				return;
			}
			cnt++;
			setTimeout(openKri,100);
		}
	}
	
	function schKriPopup(){
	//	showLoadingWs(); // 프로그래스바 활성화
		
		$("#ifrKri").ready(function(){
			cnt=0;
			setTimeout(openKri,100);
		});

		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC010501";
		f.target = "ifrKri";
		f.submit();
	}
<%-- 팀 조회 시작 --%>
		// 팀 검색 완료
		var TEAM_ONLY = true; 
		var CUR_TEAM_TPC = "";
		
		function team_popup(){
			CUR_TEAM_TPC = $("#sch_idvdc_val").val();
			schTeamPopup();
		}
		
		function teamSearchEnd(idvdc_val, intg_idvd_cnm
							, idvdc_val_lv1, intg_idvd_cnm_lv1){
			$("#team_cd").val(idvdc_val);
			<%
			for(int i=0;i<vTeamLst.size();i++){
			HashMap teamhp = (HashMap)vTeamLst.get(i);
			%>
				if(idvdc_val == "<%=(String)teamhp.get("team_cd")%>"){
					$("#brc").val("<%=(String)teamhp.get("brc")%>");
					$("#brnm").val("<%=(String)teamhp.get("brnm")%>");
				} 
			<%
			}
			%>
			if(intg_idvd_cnm.includes('-'))
			{
				var intgArray = intg_idvd_cnm.split('-');
				$("#target_evl_team").val(intgArray[1]);
			}else if(intg_idvd_cnm.includes('_'))
			{
				var intgArray = intg_idvd_cnm.split('_');
				$("#target_evl_team").val(intgArray[1]);
			}else
			{
				$("#target_evl_team").val(intg_idvd_cnm);
			}
			
			
			$("#winTeam").hide();
			//doAction('search');
		}
		
		function team_remove(){
			$("#sch_idvdc_val").val("");
			$("#sch_intg_idvd_cnm").val("");
		}
<%-- 팀 조회 끝 --%>
	</script>
</body>
</html>