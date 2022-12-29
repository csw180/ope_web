<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0109.jsp
 Program name : KRI 수기 데이터 입력
 Description  : 화면정의서 KRI-03
 Programer    : 정현식 ( 테스트 : 동대문금융센타 , 강수민 )
 Date created : 2022.08.19
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

DynaForm form = (DynaForm)request.getAttribute("form");
/*
	kri_menu_dsc 
  1 : 부서 담당자
  2 : 부서 팀장
  3 : 모니터링
*/

/*KRI결재진행단계*/
Vector vKriEvlDczStsc = CommUtil.getCommonCode(request, "RKI_DCZ_STSC");
if(vKriEvlDczStsc==null) vKriEvlDczStsc = new Vector();

String kriEvlDczStsc = "";
String kriEvlDczStnm = "";

for(int i=0;i<vKriEvlDczStsc.size();i++){
	HashMap hMap = (HashMap)vKriEvlDczStsc.get(i);
	if( i > 0 ){
		kriEvlDczStsc += "|";
		kriEvlDczStnm += "|";
	}
	kriEvlDczStsc += (String)hMap.get("intgc");
	
	kriEvlDczStnm += (String)hMap.get("intg_cnm");
}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>KRI 수기 데이터 입력</title>
	<script>
	
	$(document).ready(function(){
		//사무소코드
		var brc = '<%=(String)hs.get("brc")%>';
		

		
		// ibsheet 초기화
		initIBSheet1();
		createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
		
		if($("#kri_menu_dsc").val()=="1"||$("#kri_menu_dsc").val()=="2")
		{
				document.all.ormyn.style.display="none";
				$("#sch_brc").val(brc); //사무소코드
	    		$("#sch_brc_2").val(brc); //사무소코드
		}
		
		
		
		
		doAction('search');
	});
	
	$(document).ready(function(){
		initIBSheet2();
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet1() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData.Cols = [
			{Header:"부서정보"		,Type:"Text",Width:100	,Align:"Center"	,SaveName:"hofc_bizo_dsnm"	,MinWidth:60,Edit:false},
			{Header:"입력부서"		,Type:"Text",Width:100	,Align:"Center"	,SaveName:"brnm"			,MinWidth:60,Edit:false},
			{Header:"대상건수"		,Type:"Text",Width:60	,Align:"Center"	,SaveName:"cnt"				,MinWidth:60,Edit:false},
			{Header:"완료건수"		,Type:"Text",Width:60	,Align:"Center"	,SaveName:"inp_cnt"			,MinWidth:60,Edit:false},
			{Header:"완료비율"		,Type:"Text",Width:60	,Align:"Center"	,SaveName:"inp_pct"			,MinWidth:60,Edit:false},
			{Header:"결재완료현황"	,Type:"Text",Width:60	,Align:"Center"	,SaveName:"dcz_stsc"		,MinWidth:60,Edit:false},
			
			{Header:"기준년월"		,Type:"Text",Width:80	,Align:"Center"	,SaveName:"bas_ym"			,MinWidth:60,Edit:false,Hidden:true},
			{Header:"사무소코드"		,Type:"Text",Width:80	,Align:"Center"	,SaveName:"brc"				,MinWidth:60,Edit:false,Hidden:true}
		];
		
		
		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(3);
		//mySheet2.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		//컬럼의 너비 조정
		mySheet.FitColWidth();
		
		mySheet.SetSumValue(0, "합계");
	}
	
	function initIBSheet2() {
		//시트 초기화
		mySheet2.Reset();
		
		var initData2 = {};
		
		initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData2.Cols = [
			{Header:"상태"		,Type:"Status"	,Width:30	,Align:"Center"	,SaveName:"status"		,MinWidth:40,Edit:false,Hidden:true},
			{Header:"지표소관 부서 코드",Type:"Text"		,Width:40	,Align:"Center"	,SaveName:"brc"			,MinWidth:60,Edit:false,Hidden:true},
			{Header:"기준년월"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"bas_ym"		,MinWidth:60,Edit:false,Hidden:true},
			{Header:"입력여부"		,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"inpdt_yn"	,MinWidth:60,Edit:false,Hidden:true},
			{Header:"반려여부"		,Type:"Text"	,Width:30	,Align:"Center"	,SaveName:"rtn_yn"		,MinWidth:20,Edit:false,Hidden:true},
			{Header:"결재현황"		,Type:"Html"	,Width:40	,Align:"Center"	,SaveName:"DetailDcz"	,MinWidth:60,Hidden:true},
			
			{Header:"선택"		,Type:"CheckBox",Width:40	,Align:"Center"	,SaveName:"ischeck"		,MinWidth:40,Hidden:false},
			{Header:"지표 소관부서"	,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"brnm"		,MinWidth:60,Edit:false},
			{Header:"KRI-ID"	,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"rki_id"		,MinWidth:60,Edit:false},
			{Header:"지표명"		,Type:"Text"	,Width:60	,Align:"Left"	,SaveName:"rkinm"		,MinWidth:60,Edit:false},
			{Header:"지표목적"		,Type:"Text"	,Width:100	,Align:"Left"	,SaveName:"rki_obv_cntn",MinWidth:60,Edit:false},
			{Header:"지표정의"		,Type:"Text"	,Width:100	,Align:"Left"	,SaveName:"rki_def_cntn",MinWidth:60,Edit:false},
			{Header:"지표값"		,Type:"Float"	,Width:50	,Align:"Center"	,SaveName:"kri_nvl"		,MinWidth:60,Edit:true,Format:"#,##0.###"},
			{Header:"입력상태"		,Type:"Combo"	,Width:80	,Align:"Center"	,SaveName:"rki_dcz_stsc",MinWidth:60,ComboText:"<%=kriEvlDczStnm%>", ComboCode:"<%=kriEvlDczStsc%>",Edit:false},
			{Header:"상세정보"		,Type:"Html"	,Width:40	,Align:"Center"	,SaveName:"goORKR0201"	,MinWidth:60},
		];
		
		IBS_InitSheet(mySheet2,initData2);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(3);
		//mySheet2.SetCountPosition(3);
		mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet2.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		//컬럼의 너비 조정
		mySheet2.FitColWidth();
		if($("#kri_menu_dsc").val()!="1")
		{   mySheet2.SetColEditable("kri_nvl",0);	
		}
		if($("#kri_menu_dsc").val()=="3"){
			mySheet2.SetColHidden("ischeck",1);
		}
	}
	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	//시트 ContextMenu선택에 대한 이벤트
	function mySheet_OnSelectMenu(text,code){
		if(text=="엑셀다운로드"){
			doAction("down2excel");	
		}else if(text=="엑셀업로드"){
			doAction("loadexcel");
		}
	}
	
	/*Sheet 각종 처리*/
	function doDczProc(sAction) {
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		
		var Cnt = mySheet.GetTotalRows();
		
		
		switch(sAction) {
			
			case "save":  
				if(InputCheck(sAction) == false) return;
				
				$("#dcz_dc").val("03");
				$("#dcz_rmk_c").val("");
			    doSave();
				break;
		
			case "sub":  
				if(InputCheck(sAction) == false) return;
				
				$("#dcz_dc").val("04");
			    $("#dcz_objr_emp_auth").val("'004','006'");
			    $("#dcz_rmk_c").val("");
			    schDczPopup(1);
				break;
			
			case "dcz":  //결제
			
				if(InputCheck(sAction) == false) return;
				
				if($("#kri_menu_dsc").val()=='2')
				{
					$("#dcz_dc").val("13"); 
					$("#dcz_objr_emp_auth").val("'002'");
					$("#dcz_rmk_c").val("");
				}else if($("#kri_menu_dsc").val()=='3')
				{
					$("#dcz_dc").val("14"); 
					$("#dcz_objr_emp_auth").val("'009'");
					$("#dcz_rmk_c").val("");
				}else if($("#kri_menu_dsc").val()=='4')
				{
					$("#dcz_dc").val("15"); 
					$("#dcz_rmk_c").val("");
				}
				
				schDczPopup(2);
				//doSave();
				break;
				
			case "ret":  //반려
				if(InputCheck(sAction) == false) return;
				//$("#dcz_objr_emp_auth").val("'002'");
				$("#dcz_dc").val("03");
				$("#dcz_rmk_c").val("01");
				schDczPopup(2);
				//$("#winRetMod").show();
				doSave();
				break;
				
		}
	}
	
	//입력값 체크
	function InputCheck(sAction) {
		
		$("#rpst_id").val("");
		var kri_menu_dsc = $("#kri_menu_dsc").val(); 
		var ret_yn ="N";
		if(sAction=="ret")
			{
			 ret_yn = "Y";
			} 
	     var ckcnt = "";
		 var Cnt = mySheet2.GetTotalRows();
		 var rki_dcz_stsc = $("#rki_dcz_stsc").val();
		  
		 for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
				if(mySheet2.GetCellValue(i, "ischeck")=="1"){				
					ckcnt++;
				}
			} 
	     if(ckcnt==0){
	     	alert("KRI를 선택해 주세요.");
	     	return false;
	     }		
	     
		 for(var i=1;i<=Cnt;i++){
			 if( mySheet2.GetCellValue(i,"ischeck") == "1" ){
			  if($("#rpst_id").val()==""){
			  	$("#rpst_id").val(mySheet2.GetCellValue(i,"rki_id"));
			  	$("#bas_pd").val(mySheet2.GetCellValue(i,"bas_ym"));
			  }
			if( kri_menu_dsc == 1 && sAction == "save"){
				 if( mySheet2.GetCellValue(i,"rki_dcz_stsc") > "03" ){
					 alert("이미 결재 진행중인 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }
			}else if(kri_menu_dsc == 1){
				if( mySheet2.GetCellValue(i,"rki_dcz_stsc") > "03" ){
					 alert("이미 결재 진행중인 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }
				if(!confirm("따로  저장하지 않을시 현재 기입한 수치로 결재가 상신됩니다. 진행하시겠습니까?")) return;
			}
			else if( kri_menu_dsc == 2){
				 if( mySheet2.GetCellValue(i,"rki_dcz_stsc") < "04" ){
					 alert("상신 되지 않은 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }else if( mySheet2.GetCellValue(i,"rki_dcz_stsc") > "04" ){
					 alert("이미 결재 완료한 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }	 
			}
			else if( kri_menu_dsc == 3){
				 if( mySheet2.GetCellValue(i,"rki_dcz_stsc") < "13" ){
					 alert("지점/팀 결재 완료 되지 않은 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }else if( mySheet2.GetCellValue(i,"rki_dcz_stsc") > "13" ){
					 alert("이미 결재 완료한 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }	 
			}
			else if( kri_menu_dsc == 4){
				 if( mySheet2.GetCellValue(i,"rki_dcz_stsc") < "14" ){
					 alert("ORM확인 되지 않은 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }else if( mySheet2.GetCellValue(i,"rki_dcz_stsc") > "14" ){
					 alert("이미 결재 완료한 항목이 존재 합니다. \n[KRI : "+mySheet2.GetCellValue(i,"rki_id")+"]");
					 return false;
				 }	 
			}	
			 
		 }
		 	
		}
		return true;
		 
	}
	
	function zeroPadding(num){

		if(num.indexOf(".")==0)
			{
				return "0"+num;
			}
		else
			{
				return num;
			}
	}
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {
		switch(sAction) {
			case "search":  //데이터 조회
				//var opt = { CallBack : DoSearchEnd };
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR010902");
				
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
			case "reload":  //조회데이터 리로드
				mySheet.RemoveAll();
				initIBSheet();
				break;

			case "ORKR0201":      //신규
				$("#ifrORKR0201").attr("src","about:blank");
				$("#winORKR0201").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popORKR0201,1);
				
				break; 
				
			case "down2excel":
				
				setExcelDownCols("2|3|4|5|6|7|8");
				mySheet2.Down2Excel(excel_params);

				break;
		}
	}
	
	function popORKR0201(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORKR010201";
		f.target = "ifrORKR0201";
		f.submit();
	}
	
	function popORKR3001(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORKR011601";
		f.target = "ifrORKR3001";
		f.submit();
	}
	
	function endORKR0116(){
		$("#winORKR3001").hide();
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		mySheet2.DoAllSave(url + "?method=Main&commkind=kri&process_id=ORKR010904", FormQueryStringEnc(document.ormsForm));
	}
	
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		if(Row >= mySheet.GetDataFirstRow()){

			$("#sch_brc_2").val(mySheet.GetCellValue(Row,"brc")); //사무소코드
			
			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("kri");
			$("form[name=ormsForm] [name=process_id]").val("ORKR010903");			
			
			mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		}
	}
	
	function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		if(Row >= mySheet.GetDataFirstRow()){
			if(mySheet2.ColSaveName(Col) != "kri_nvl"){
				$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
				doAction('ORKR0201');
			}
			
		}
	}
	
	
	function mySheet_OnSearchEnd(code, message) {
		if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			//if(mySheet.GetDataFirstRow()>=0){ 
				mySheet_OnClick(1); //첫행 클릭
			//}	
		}
		
		//컬럼의 너비 조정
		mySheet.FitColWidth();
	}
	
	function mySheet2_OnSearchEnd(code, message) {
		if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			SetBaseInfo();
		}
		
		//컬럼의 너비 조정
		mySheet2.FitColWidth();
	}
	
	function SetBaseInfo() {

		var f = document.ormsForm;
			
		//if (part_orm == "Y" || auth_007 == "Y")
			
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "kri");
		WP.setParameter("process_id", "ORKR010905");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				  $("#cnt").text(rList[0].cnt);
				  $("#inp_cnt").text(rList[0].inp_cnt);
				  $("#inp_pct").text(zeroPadding(rList[0].inp_pct));
				  	
			  } else if(result!='undefined' && result.rtnCode!="0"){
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
		removeLoadingWs();
	}
	
	function mySheet2_OnRowSearchEnd(Row) {
		mySheet2.SetCellText(Row,"goORKR0201",'<button class="btn btn-xs btn-default" type="button" onclick="goORKR0201('+Row+')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
		mySheet2.SetCellValue(Row,"status","R");
		mySheet2.SetCellText(Row,"DetailDcz",'<button class="btn btn-xs btn-default" type="button" onclick="DczStatus(\''+mySheet2.GetCellValue(Row,"rki_id")+'\',\''+mySheet2.GetCellValue(Row,"bas_ym")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
	}
	
	function goORKR0201(Row) {
		$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
		doAction('ORKR0201');
	}
	
	function DczStatus(rki_id,bas_ym) {
		$("#rpst_id").val(rki_id);
		$("#bas_pd").val(bas_ym);
		schDczPopup(3);
	}
	
	function mySheet2_OnSaveEnd(code, msg) {
	    if(code >= 0) {
	    	alert(msg);  // 저장 성공 메시지
	    	$("#winDcz").hide();
	    	doAction('search');  
	    } else {
	        alert(msg); // 저장 실패 메시지
	    }
	}		
	
	<%--부서 시작 --%>
	var init_flag = false;
	function org_popup(){
		schOrgPopup("sch_brnm", "orgSearchEnd","0");
		if($("#sch_hd_brc_nm").val() == "" && init_flag){
			$("#ifrOrg").get(0).contentWindow.doAction("search");
		}
		init_flag = false;
	}
	// 부서검색 완료
	function orgSearchEnd(brc, brnm){
		$("#sch_brc").val(brc);
		$("#sch_brc_2").val(brc);
		$("#sch_brnm").val(brnm);
		$("#winBuseo").hide();
		//doAction('search');
	}	
	
	function doSave() {
		mySheet2.DoSave(url, { Param : "method=Main&commkind=kri&process_id=ORKR010904&dcz_dc="+$("#dcz_dc").val()+"&dcz_rmk_c="+$("#dcz_rmk_c").val()+"&sch_rtn_cntn="+$("#sch_rtn_cntn").val()+"&dcz_objr_eno="+$("#dcz_objr_eno").val(), Col : 0 });
		
	}
	</script>
	
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<div class="content">
		<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				
		
		    	<input type="hidden" id="sch_brc" name="sch_brc" /> 			<!-- 평가조직 코드 -->
				
				<input type="hidden" id="rki_id" name="rki_id" />
				<input type="hidden" id="sch_brc_2" name="sch_brc_2" />
				<input type="hidden" id="gubun" name="gubun" /> 				
				<input type="hidden" id="rtn_cntn_i" name="rtn_cntn_i" /> 		<!-- 반려내용 -->
				<input type="hidden" id="mod_yn" name="mod_yn" value="N" >
				<input type="hidden" id="comp" name="comp" value="" >		<!-- 입력현황 -->
				
				<input type="hidden" id="kri_menu_dsc" name="kri_menu_dsc" value="<%=form.get("kri_menu_dsc")%>" />
				
				<input type="hidden" id="dcz_dc" name="dcz_dc" />
				<input type="hidden" id="table_name" name="table_name" value="TB_OR_KH_NVL_DCZ"/>
				<input type="hidden" id="dcz_code" name="stsc_column_name" value="RKI_DCZ_STSC"/>
				<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="OPRK_RKI_ID"/>
				<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
				<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
				<input type="hidden" id="bas_pd" name="bas_pd" value=""/>
				<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
				<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
				<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
				<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
				<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
				
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가년월</th>
									<td class="form-inline">
										<span class="select">
											<select class="form-control w120" id="sch_bas_ym" name="sch_bas_ym" >
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("bas_ym")%>"><%=((String)hMap.get("bas_ym")).substring(0,4)%>-<%=((String)hMap.get("bas_ym")).substring(4,6)%></option>
<%
	}
%>	
											</select>
										</span>
									</td>
<%
if( !form.get("kri_menu_dsc").equals("1") && !form.get("kri_menu_dsc").equals("2")){ 
%>									
									<th>평가조직</th>
									<td>
										<div class="input-group" >	
											<input type="text" class="form-control w170" id="sch_brnm" name="sch_brnm"  onKeyPress="EnterkeySubmitOrg('sch_brnm', 'orgSearchEnd');" readonly   placeholder="전체" />
											<span class="input-group-btn">
												<button class="btn btn-default ico" type="button" onclick="schOrgPopup('sch_brnm', 'orgSearchEnd');">
													<i class="fa fa-search"></i><span class="blind">검색</span>	
												</button>
											</span>										
										</div>
									</td>	
<%
}
%>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
				</div>
			</div>
			
			</form>

			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">수기 데이터 입력 대상</h2>
				</div>
				<div class="box-header">
					<div class="area-term">
						<span class="tit">입력 대상 건수</span>
						<span class="em"><strong id="cnt">-</strong>건</span>
						<span class="div">/</span>
						<span class="tit">입력 완료 건수</span>
						<span class="em"><strong  id="inp_cnt">-</strong>건</span>
						<span class="em">(<strong id="inp_pct">-</strong>%)</span>
					</div>
					<div class="area-tool">
						<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				
				<div class="box-body">
					<div class="row ">
					    <div class="col pr20" id='ormyn'>
					        <div class="wrap-grid h510">
						         <script> createIBSheet("mySheet", "100%", "100%"); </script>
					        </div>
					    </div>
					    <div class="col pl0">
					        <div id="mydiv2" class="wrap-grid h510">
						         <!-- <script> createIBSheet("mySheet2", "100%", "100%"); </script> -->
					        </div>
					    </div>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
					<%
if( form.get("kri_menu_dsc").equals("1") ){ //부서담당자
 %>						
						<button type="button" class="btn btn-primary" onClick="doDczProc('save');">저장</button>
						<button type="button" class="btn btn-primary" onClick="doDczProc('sub');">상신</button>
<%
}
else
if( form.get("kri_menu_dsc").equals("2") ){ //팀
%>						
						<button type="button" class="btn btn-primary" onClick="doDczProc('dcz');">결재</button>
<%
}
%>
					</div>
				</div>
			</section>
		</div>
	</div>

	<!-- popup -->
	<div id="winORKR3001" class="popup modal">
		<iframe name="ifrORKR3001" id="ifrORKR3001" src="about:blank"></iframe>
	</div>
	<div id="winORKR0201" class="popup modal">
		<iframe name="ifrORKR0201" id="ifrORKR0201" src="about:blank"></iframe>
	</div>
	<script>
		// 결재팝업 연동 - 결재요청
		function DczSearchEndSub(){
			doSave();
		}
		// 결재팝업 연동 - 결재
		function DczSearchEndCmp(){
			doSave();
		}
		// 결재팝업 연동 - 반려
		function DczSearchEndRtn(){
			doDczProc('ret');
		}
		// 결재팝업 연동 - 회수
		function DczSearchEndCncl(){
			doCncl();
		}
	</script>
</body>
	
</html>