<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0109.jsp
 Program name : 리스크 평가
 Description  : 화면정의서 RCSA-08
 Programer    : 박승윤
 Date created : 2022.08.23
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
<%
String bas_ym = CommUtil.getResultString(request, "grp01", "unit00", "bas_ym");
Vector vVlrLst = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vVlrLst==null) vVlrLst = CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
if(vVlrLst==null) vVlrLst = new Vector();
DynaForm form = (DynaForm)request.getAttribute("form");
/*
	rcsa_menu_dsc 
  1 : 평가자
  2 : 부서 리스크담당자(취합자)
  3 : 부서장/지점장 (결재자)
*/

Vector vRkEvlGrdC = CommUtil.getCommonCode(request, "RK_EVL_GRD_C");
if(vRkEvlGrdC==null) vRkEvlGrdC = new Vector();

String rkEvlGrdC = "";
String rkEvlGrdNm = "";
/*리스크 평가 등급 코드*/
for(int i=0;i<vRkEvlGrdC.size();i++){
	HashMap hMap = (HashMap)vRkEvlGrdC.get(i);
	if( i > 0 ){
		rkEvlGrdC += "|";
		rkEvlGrdNm += "|";
	}
	rkEvlGrdC += (String)hMap.get("intgc");
	
	rkEvlGrdNm += (String)hMap.get("intg_cnm");
}
/*통제 평가 등급 코드*/
Vector vCtlDsgEvlC = CommUtil.getCommonCode(request, "CTL_DSG_EVL_C");
if(vCtlDsgEvlC==null) vCtlDsgEvlC = new Vector();

String rkCtlDsgEvlC = "";
String rkCtlDsgEvlNm = "";

for(int i=0;i<vCtlDsgEvlC.size();i++){
	HashMap hMap = (HashMap)vCtlDsgEvlC.get(i);
	if( i > 0 ){
		rkCtlDsgEvlC += "|";
		rkCtlDsgEvlNm += "|";
	}
	rkCtlDsgEvlC += (String)hMap.get("intgc");
	
	rkCtlDsgEvlNm += (String)hMap.get("intg_cnm");
}
/*리스크결재진행단계*/
Vector vRkEvlDczStsc = CommUtil.getCommonCode(request, "RK_EVL_DCZ_STSC");
if(vRkEvlDczStsc==null) vRkEvlDczStsc = new Vector();

String rkEvlDczStsc = "";
String rkEvlDczStnm = "";

for(int i=0;i<vRkEvlDczStsc.size();i++){
	HashMap hMap = (HashMap)vRkEvlDczStsc.get(i);
	if( i > 0 ){
		rkEvlDczStsc += "|";
		rkEvlDczStnm += "|";
	}
	rkEvlDczStsc += (String)hMap.get("intgc");
	
	rkEvlDczStnm += (String)hMap.get("intg_cnm");
}

/*잔여위험등급*/
Vector vRmnRskGrdC = CommUtil.getCommonCode(request, "RMN_RSK_GRD_C");
if(vRmnRskGrdC==null) vRmnRskGrdC = new Vector();

String rkRmnRskGrdC = "";
String rkRmnRskGrdNm = "";

for(int i=0;i<vRmnRskGrdC.size();i++){
	HashMap hMap = (HashMap)vRmnRskGrdC.get(i);
	if( i > 0 ){
		rkRmnRskGrdC += "|";
		rkRmnRskGrdNm += "|";
	}
	rkRmnRskGrdC += (String)hMap.get("intgc");
	
	rkRmnRskGrdNm += (String)hMap.get("intg_cnm");
}



%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script>

	
	$(document).ready(function(){
		// ibsheet 초기화
		initIBSheet();
		if($("#rcsa_menu_dsc").val()=="1"){
			$("#evl_eno").val("<%=userid%>").prop("selected",true);
			$("#evl_eno").attr("disabled","disabled");
		}
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
						{Header:"선택",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50,Edit:1},				
		    			{Header:"그룹내기관코드",Type:"Text",Width:0,Align:"Center",SaveName:"grp_org_c",MinWidth:60, Hidden:true},
		    			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:60, Hidden:true},
		    			{Header:"리스크사례ID",Type:"Text",Width:0,Align:"Center",SaveName:"rkp_id",MinWidth:60,Edit:0},
						{Header:"리스크평가기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:60, Hidden:true},
						{Header:"평가부서",Type:"Text",Width:100,Align:"Center",SaveName:"dept_brnm",MinWidth:100,Edit:0},
						{Header:"팀",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV1",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm1",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV2",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm2",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV3",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm3",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV4",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm4",MinWidth:100,Edit:0},
		    			{Header:"리스크 사례",Type:"Text",Width:100,Align:"Left",SaveName:"rk_isc_cntn",MinWidth:60,Edit:0},
						{Header:"통제활동",Type:"Text",Width:300,Align:"Left",SaveName:"cp_cntn",MinWidth:200,Edit:0},
						{Header:"위험\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_grd_c",MinWidth:60,ComboText:"<%=rkEvlGrdNm%>", ComboCode:"<%=rkEvlGrdC%>",Edit:0},
						{Header:"통제\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"ctev_grd_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
						{Header:"잔여위험\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rmn_rsk_grd_c",MinWidth:60,ComboText:"<%=rkRmnRskGrdNm%>", ComboCode:"<%=rkRmnRskGrdC%>",Edit:0},
						{Header:"평가\n상태",Type:"Text",Width:0,Align:"Center",SaveName:"evl_stsc",MinWidth:60,Edit:0},
						{Header:"평가자개인번호",Type:"Text",Width:0,Align:"Center",SaveName:"vlr_eno",MinWidth:60, Hidden:true},
						{Header:"평가자",Type:"Text",Width:100,Align:"Center",SaveName:"vlr_nm",MinWidth:100,Edit:0,MultiLineText:1},
						{Header:"재평가\n대상여부",Type:"Text",Width:100,Align:"Center",SaveName:"reevl_yn",MinWidth:100,Edit:0},
						{Header:"결재요청\n여부",Type:"Text",Width:100,Align:"Center",SaveName:"dcz_rq_yn",MinWidth:100,Edit:0},
						{Header:"결재 완료\n여부",Type:"Text",Width:100,Align:"Center",SaveName:"dcz_yn",MinWidth:100,Edit:0},		
						{Header:"확인현황",Type:"Html",Width:40,Align:"Center",SaveName:"DetailDcz",MinWidth:60},		
		    			{Header:"반송사유",Type:"Text",Width:60,Align:"Left",SaveName:"rtn_cntn",MinWidth:100,Edit:0, Hidden:true}, 				
						{Header:"결재\n진행단계",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_dcz_stsc",MinWidth:60,ComboText:"<%=rkEvlDczStnm%>", ComboCode:"<%=rkEvlDczStsc%>",Edit:0, Hidden:true}
		];

		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		mySheet.FitColWidth();
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		doAction('search');

		
	}
	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {

		switch(sAction) {
			case "search":  //데이터 조회
				DoSearch();
	
				break;
	
			case "mod":		//평가 팝업
				if($("#bas_ym").val() == ""){
					alert("회차를 선택하세요.");
					return;
				}else{
					
					$("#ifrRskMod").attr("src","about:blank");
					$("#winRskMod").addClass("block");
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(modRisk,1);
					//modRisk();
				}
				break; 

			case "down2excel":
				
				var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "RCSA리스크평가.xlsx",SheetName : "Sheet1", Merge:1,Mode:2,DownCols:"3|5|6|7|8|9|10|11|12|13|14|15|16|18|19|20"} ;
				mySheet.Down2Excel(params);
	
				break;
	
		}
	}
	
	function DczStatus(rkp_id) {
		$("#rpst_id").val(rkp_id);
		schDczPopup(3);
	}
	
	function DoSearch() {

		var f = document.ormsForm;
			
		//if (part_orm == "Y" || auth_007 == "Y")
			
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC010902");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				  $("#info_bas_ym").val(rList[0].bas_ym_nm);
				  $("#info_evl_cnt").val(rList[0].evl_cnt+" 건");
				  $("#info_evl_cpl_cnt").val(rList[0].evl_cpl_cnt+" 건");
				  $("#info_evl_rate").val(rList[0].evl_rate+" %");
				  $("#info_evl_date").val(rList[0].evl_date);
				  $("#info_evl_cpl_yn").val(rList[0].all_evl_cpl_yn);

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
		
		var opt = {};
		$("form[name=ormsForm] [name=method]").val("Main");
		$("form[name=ormsForm] [name=commkind]").val("rsa");
		$("form[name=ormsForm] [name=process_id]").val("ORRC010903");

		mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

	}
	
	function mySheet_OnSearchEnd(code, message) {

	    if(code == 0) {
	    	mySheet.FitColWidth();
	    	if($("#rcsa_menu_dsc").val()=='1'){
	    	mySheet.SetColHidden("ischeck",true);
	    	};
	        //조회 후 작업 수행
	    	if(mySheet.GetDataFirstRow()>=0){
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(mySheet.GetCellValue(j,"evl_stsc") == "미평가"){
						mySheet.SetCellFontColor(j,"evl_stsc","#FF0000");			
					}
				}
		    }
		} else {
	
		        alert("조회 중에 오류가 발생하였습니다..");
		        
	
		}

	}
	 
	// 업무프로세스검색 완료
	var PRSS4_ONLY = false; 
	var CUR_BSN_PRSS_C = "";
	 
	function prss_popup(){
		//$("#bsn_prss_c").val("");
		//$("#bsn_prss_nm").val("");
		CUR_BSN_PRSS_C = $("#bsn_prss_c").val();
		if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
		schPrssPopup();
	}

	// 업무프로세스검색 완료
	function prssSearchEnd(bsn_prss_c, bsn_prsnm
						, bsn_prss_c_lv1, bsn_prsnm_lv1
						, bsn_prss_c_lv2, bsn_prsnm_lv2
						, bsn_prss_c_lv3, bsn_prsnm_lv3
						, biz_trry_c_lv1, biz_trry_cnm_lv1
						, biz_trry_c_lv2, biz_trry_cnm_lv2){
		
		if (bsn_prss_c.substr(2,2) == "00")
			bsn_prss_c = bsn_prss_c.substr(0,2);
		else if (bsn_prss_c.substr(4,2) == "00")
			bsn_prss_c = bsn_prss_c.substr(0,4);
		else if (bsn_prss_c.substr(6,2) == "00")
			bsn_prss_c = bsn_prss_c.substr(0,6);
		
		$("#bsn_prss_c").val(bsn_prss_c);
		$("#bsn_prss_nm").val(bsn_prsnm);
		
		$("#winPrss").hide();
		//doAction('search');
	}
	

	
	/*Sheet 각종 처리*/
	function doDczProc(sAction) {
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		
		var Cnt = mySheet.GetTotalRows();
		
		
		switch(sAction) {
		
		
			case "sub":  //리스크담당자 상신 (03-> 04)
				if(InputCheck(sAction) == false) return;
				
				$("#dcz_dc").val("04");
			    $("#dcz_objr_emp_auth").val("'004','006'");
			    schDczPopup(1);
				break;
			
			case "dcz":  //결제
			
				if(InputCheck(sAction) == false) return;
				$("#dcz_dc").val("13"); 
				$("#dcz_objr_emp_auth").val("'002'");
				schDczPopup(2);
				//doSave();
				break;
				
			case "ret":  //반려
				if(InputCheck(sAction) == false) return;
				//$("#dcz_objr_emp_auth").val("'002'");
				$("#dcz_dc").val("02");
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
		var rcsa_menu_dsc = $("#rcsa_menu_dsc").val(); 
		var ret_yn ="N";
		if(sAction=="ret")
			{
			 ret_yn = "Y";
			}
	     var ckcnt = "";
		 var Cnt = mySheet.GetTotalRows();
		 var rk_evl_dcz_stsc = $("#rk_evl_dcz_stsc").val();
		  
		 for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
				if(mySheet.GetCellValue(i, "ischeck")=="1"){				
					ckcnt++;
				}
			} 
	     if(ckcnt==0){
	     	alert("결재대상을 선택해 주세요.");
	     	return false;
	     }		
	     
		 for(var i=1;i<=Cnt;i++){
			 if( mySheet.GetCellValue(i,"ischeck") == "1" ){
			  if($("#rpst_id").val()==""){
			  	$("#rpst_id").val(mySheet.GetCellValue(i,"rkp_id"));
			  }
			  if( rcsa_menu_dsc == 2){
				 if( mySheet.GetCellValue(i,"rk_evl_dcz_stsc") < "03" ){
					 alert("평가완료 되지않은 항목이 존재합니다. \n[리스크 프로파일 : "+mySheet.GetCellValue(i,"rk_isc_cntn")+"]");
					 return false;
				 }
				 if(mySheet.GetCellValue(i,"rk_evl_dcz_stsc") >= "13" ){
					 alert("팀장/지점장 최종결재를 완료하였습니다. \n운영리스크 담당자가 재평가를 요청하기 전에는 수정 불가 합니다.");
					 return false;
				 }
				 if(mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "99" ){
					 alert("이미 종료된 회차 입니다.");
					 return false;
				 }
				 if( mySheet.GetCellValue(i,"rk_evl_dcz_stsc") == "04" ){
					 alert("이미 상신 된 건 입니다. \n[리스크 프로파일 : "+mySheet.GetCellValue(i,"rk_isc_cntn")+"]");
					 return false;
				 }
				}
				 if( rcsa_menu_dsc == 3){
						 
			 	}	
			 
		 }
		 	
		}
		return true;
		 
	}
	
	function doSave() {
		mySheet.DoSave(url, { Param : "method=Main&commkind=rsa&process_id=ORRC010904&dcz_dc="+$("#dcz_dc").val()+"&sch_rtn_cntn="+$("#sch_rtn_cntn").val()+"&dcz_objr_eno="+$("#dcz_objr_eno").val()+"&dcz_rmk_c="+$("#dcz_rmk_c").val(), Col : 0 });
		
	}
	
	
	function RetrunSave() {
		$("#winRetMod").removeClass("block");
		doSave();
		
	}
	
	function mySheet_OnSaveEnd(code, msg) {
	    if(code >= 0) {
	    	alert("완료되었습니다.")
	    	$("#winDcz").hide();
	    	doAction('search');      

	    } else {

	        alert(msg); // 저장 실패 메시지

	    }
	}

	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		
		var rk_evl_dcz_stsc = $("#rk_evl_dcz_stsc").val();
		//alert(rk_evl_dcz_stsc);
		if(Row >= mySheet.GetDataFirstRow())
		{
			if(rk_evl_dcz_stsc == "03" && mySheet.GetCellValue(Row,"rk_evl_dcz_stsc")=="03")
				{
					$("#link_brc").val(mySheet.GetCellValue(Row,"brc"));
					$("#link_rkp_id").val(mySheet.GetCellValue(Row,"rkp_id"));
					$("#link_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
					$("#vlr_eno").val(mySheet.GetCellValue(Row,"vlr_eno"));
					$("#link_rk_evl_dcz_stsc").val(mySheet.GetCellValue(Row,"rk_evl_dcz_stsc"));
						
		
					$("#ifrRskEvl").attr("src","about:blank");
					$("#winRskEvl").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(RiskEvl,1);
				}
			else 
				{	
					$("#link_brc").val(mySheet.GetCellValue(Row,"brc"));
					$("#link_rkp_id").val(mySheet.GetCellValue(Row,"rkp_id"));
					$("#link_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
					$("#vlr_eno").val(mySheet.GetCellValue(Row,"vlr_eno"));
					$("#link_rk_evl_dcz_stsc").val(mySheet.GetCellValue(Row,"rk_evl_dcz_stsc"));
					$("#ifrRskEvl").attr("src","about:blank");
					$("#winRskEvl").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(RiskEvl,1);
				}
		}
	}
	
	function mySheet_OnRowSearchEnd(Row) {
		mySheet.SetCellText(Row,"DetailDcz",'<button class="btn btn-xs btn-default" type="button" onclick="DczStatus(\''+mySheet.GetCellValue(Row,"rkp_id")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
	}
	
	
	function RiskEvl(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC011001";
		f.target = "ifrRskEvl";
		f.submit();
	}
	
	function doNonEvl(){

		var f = document.ormsForm;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC010904");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				  if( rList.length > 0 ){
					
					$("#link_bas_ym").val($("#bas_ym").val());
					
					$("#ifrNonEvl").attr("src","about:blank");
					$("#winNonEvl").addClass("block");
					
					showLoadingWs(); // 프로그래스바 활성화
					
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="rsa"
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORRC011601";
					f.target = "ifrNonEvl";
					f.submit();
				  }
				  else
				  {
					  doSave();
				  }


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
	
	function closeRskGrd(){
		$("#winRskMat").hide();
		$("#winRskMod").hide();
	}
	</script>
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		
		<div class="content">
			<!-- .search-area 검색영역 -->
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="rcsa_menu_dsc" name="rcsa_menu_dsc" value="<%=form.get("rcsa_menu_dsc")%>" />
				<input type="hidden" id="vlr_eno" name="vlr_eno" value="<%=form.get("vlr_eno")%>" />
				<input type="hidden" id="dcz_dc" name="dcz_dc" />
				<input type="hidden" id="link_brc" name="link_brc" />
				<input type="hidden" id="link_rkp_id" name="link_rkp_id" />
				<input type="hidden" id="link_bas_ym" name="link_bas_ym" />
				<input type="hidden" id="link_rk_evl_dcz_stsc" name="link_rk_evl_dcz_stsc" />
				<input type="hidden" id="brc" name="brc" value="<%=brc %>"/>
				<input type="hidden" id="bas_ym" name="bas_ym" value="<%=bas_ym%>" />
				<input type="hidden" id="table_name" name="table_name" value="TB_OR_RH_EVL_DCZ"/>
				<input type="hidden" id="dcz_code" name="stsc_column_name" value="RK_EVL_DCZ_STSC"/>
				<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="OPRK_RKP_ID"/>
				<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
				<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
				<input type="hidden" id="bas_pd" name="bas_pd" value="<%=bas_ym%>"/>
				<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
				<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
				<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
				<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
				<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
				<input type="hidden" id="dcz_brc" name="dcz_brc" value="<%=brc%>"/>
				
			<div class="box box-grid">			
				<div class="wrap-table">
					<table>
						<colgroup>
							<col style="width: 100px">
							<col />
							<col style="width: 120px">
							<col />
							<col style="width: 120px">
							<col />
							<col style="width: 100px">
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">평가기준년월</th>
								<td><input type="text" id="info_bas_ym" name="info_bas_ym" class="form-control" value='0 차' readonly></td>
								<th scope="row">평가대상 건수</th>
								<td><input type="text" id="info_evl_cnt" name="info_evl_cnt" class="form-control" value='0 건' readonly></td>
								<th scope="row">평가건수</th>
								<td><input type="text" id="info_evl_cpl_cnt" name="info_evl_cpl_cnt" class="form-control" value='0 건' readonly></td>
								<th scope="row">평가완료비율</th>
								<td><input type="text" id="info_evl_rate" name="info_evl_rate" class="form-control" value='0 %' readonly></td>
							</tr>
							<tr>
								<th scope="row">평가기간</th>
								<td colspan="3"><input type="text" id="info_evl_date" name="info_evl_date" class="form-control" value='' readonly></td>
								<th scope="row">전체 평가완료 여부</th>
								<td colspan="3"><input type="text" id="info_evl_cpl_yn" name="info_evl_cpl_yn" class="form-control" value='' readonly></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- 진행 현황 정보 출력 //-->
			<!-- .search-area 검색영역 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>업무 프로세스</th>
									<td class="form-inline">
										<div class="input-group">
										  <input type="hidden" id="bsn_prss_c" name="bsn_prss_c">
										  <input class="form-control w200" type="text" id="bsn_prss_nm" name="bsn_prss_nm" readonly placeholder="전체">
										  <span class="input-group-btn">
											<button class="btn btn-default ico search" type="button"  onclick="prss_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
										  </span>
										</div>
									</td>
									<th>평가자</th>
									<td>
										<div class="select">
											<select class="form-control w200" id="evl_eno" name="evl_eno">
												<option value="">전체</option>
<%

for(int i=0;i<vVlrLst.size();i++){
	HashMap hMap = (HashMap)vVlrLst.get(i);
	if( hMap.get("vlr_eno").equals("") ){
		break;
	}
%>
												<option value="<%=(String)hMap.get("vlr_eno")%>"><%=(String)hMap.get("vlr_enpnm")%></option>
<%
}
%>
											</select>
										</div>
									</td>
									<th>평가상태</th>
									<td>
										<div class="select">
											<select class="form-control w200" id="sc_evl_stsc" name="sc_evl_stsc">
												<option value="">전체</option>
												<option value="1">미평가</option>
												<option value="2">재평가</option>
												<option value="3">평가완료</option>
											</select>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div>
			</form>
			
			

			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-normal btn-xs" onclick="openGuide();"><i class="fa fa-exclamation-circle"></i><span class="txt">평가상태 도움말</span></button>
						<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h380">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
					<%
if( form.get("rcsa_menu_dsc").equals("2") ){ //리스크담당자
 %>						
						<button type="button" class="btn btn-primary" onClick="doDczProc('sub');">상신</button>
<%
}
else
if( form.get("rcsa_menu_dsc").equals("3") ){ //부서장
%>						
						<button type="button" class="btn btn-primary" onClick="doDczProc('dcz');">결재</button>
						<!-- <button type="button" class="btn btn-normal" onClick="doDczProc('ret');">반려</button> -->
<%
}
%>
					</div>
				</div>
			</div>
		</div>
	</div>

		<!-- popup //-->
	<div id="winRetMod" class="popup modal">
		<div class="p_frame w400">
			<div class="p_head">
				<h3 class="title">반려 사유</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">				
					<div class="wrap-table">
						<table>
							<colgroup>
								<col style="width: 100px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th>반려 사유</th>		
									<td>
										<!-- <textarea class="textarea" id="rtn_cntn" name="rtn_cntn" maxlength="255"></textarea> -->
									</td>
								</tr>
							</tbody>
		
						</table>
					</div>
				</div>
			</div>
				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" class="btn btn-normal" onclick="RetrunSave();">반려</button>
						<button type="button" class="btn btn-default btn-close">취소</button>
					</div>
				</div>
		</div>

	</div>
	<div id="winNonEvl" class="popup modal">
		<iframe name="ifrNonEvl" id="ifrNonEvl" src="about:blank"></iframe>
	</div>
	<div id="winRskEvl" class="popup modal">
		<iframe name="ifrRskEvl" id="ifrRskEvl" src="about:blank"></iframe>
	</div>
	<!-- popup -->
	<div id="popupGuide" class="popup modal">
			<div class="p_frame w800">

				<div class="p_head">
					<h3 class="title">평가상태 도움말</h3>
				</div>

				<div class="p_body">
					<div class="p_wrap">
						<div class="wrap-table">		
							<table>
								<colgroup>
									<col style="width: 120px;">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th scope="col">상태</th>
										<th scope="col">상태설명</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th>미평가</th>
										<td>평가자가 리스크 평가내용을 입력하지 않은 상태</td>
									</tr>
									<tr>
										<th>재평가</th>
										<td>ORM 검토대기 상태에서 ORM부서에서 재평가 요청 시 "재평가" 상태로 변경되며,<br>미완료와 동일하게 리스크 평가 재입력 후 결재상신 필요</td>
									</tr>
									<tr>
										<th>평가완료</th>
										<td>평가자가 리스크 평가를 완료 한 상태</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<button class="ico close fix btn-close" onclick="closeGuide();"><span class="blind">닫기</span></button>

			</div>
		<div class="dim p_close"></div>
	</div>
	<!-- popup // -->

	<script>
	
		function openGuide(){
			$('#popupGuide').addClass('block');
		}
		function closeGuide(){
			$('#popupGuide').removeClass('block');
		}
			
		function closePop(){
			$("#winNonEvl").hide();
			$("#winRskEvl").hide();
			$("#winBuseo").hide();
		}
		
		// 부점검색 완료
		function buseoSearchEnd(kbr_nm, new_br_cd){
			$("#kbr_nm").val(kbr_nm);
			$("#sch_new_br_cd").val(new_br_cd);
			closeBuseo();
			//doAction('search');
		}
		
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(){
				$(".popup").hide();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				//$(".popup").hide();
			});
		});
		
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