<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0118.jsp
 Program name : 결과보고서(부서별)
 Description  : 화면정의서 RCSA-13
 Programer    : 박승윤
 Date created : 2022.09.26
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
HashMap hMap2 = (HashMap)request.getSession(true).getAttribute("infoH");

String init_brc = "";
String init_brnm = "";

if(!"Y".equals(adm_yn)){
	init_brc = (String)hMap2.get("brc");
	init_brnm = (String)hMap2.get("brnm");
}


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
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<script>

	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	$(document).ready(function(){
		// ibsheet 초기화
		bas_mm_chg();
		initIBSheet1();
		initIBSheet2();
		initIBSheet3();
	 	getGrdMatrix(); 
	});
	
	function initIBSheet1() {
	
		mySheet1.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"리스크 사례 목록",Type:"Text",Width:705,Align:"Left",SaveName:"rk_isc_cntn",MinWidth:60},
			{Header:"리스크사례ID",Type:"Text",Width:0,Align:"Center",SaveName:"rkp_id",MinWidth:60,Edit:0},
			{Header:"위험 등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_grd_c",MinWidth:60,ComboText:"<%=rkEvlGrdNm%>", ComboCode:"<%=rkEvlGrdC%>",Edit:0},
			{Header:"통제 등급",Type:"Combo",Width:80,Align:"Center",SaveName:"ctev_grd_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
			{Header:"잔여위험 등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rmn_rsk_grd_c",MinWidth:60,ComboText:"<%=rkRmnRskGrdNm%>", ComboCode:"<%=rkRmnRskGrdC%>",Edit:0},
	   ];
        
        IBS_InitSheet(mySheet1,initData);
        mySheet1.SetEditable(0);
       // mySheet1.InitHeaders(headers);
      //필터표시
		//mySheet1.ShowFilterRow();  
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet1.SetCountPosition(0);
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet1.SetSelectionMode(4);	
		//mySheet1_doAction('search');
    }
    
	var row = "";
	function mySheet1_doAction(str){
		switch(str){
			case 'search':
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("rsa");
				$("form[name=ormsForm] [name=process_id]").val("ORRC011804");
				mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
			break;
		}
		
	}
    
    function mySheet1_OnSearchEnd(code,msg) {
    	if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			//chartDraw(); //차트
		}
    }

	function initIBSheet2() {
		
		mySheet2.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"프로세스 목록|Lv.1",Type:"Text",Width:100,Align:"Left",SaveName:"sheet2_prssnm1",MinWidth:100,Edit:0},
			{Header:"프로세스 목록|Lv.2",Type:"Text",Width:100,Align:"Left",SaveName:"sheet2_prssnm2",MinWidth:100,Edit:0},
			{Header:"프로세스 목록|Lv.3",Type:"Text",Width:100,Align:"Left",SaveName:"sheet2_prssnm3",MinWidth:100,Edit:0},
			{Header:"프로세스 목록|Lv.4",Type:"Text",Width:100,Align:"Left",SaveName:"sheet2_prssnm4",MinWidth:100,Edit:0},
			{Header:"위험 등급|위험 등급",Type:"Text",Width:80,Align:"Center",SaveName:"sheet2_rk_evl_grd_c",MinWidth:60,ComboText:"<%=rkEvlGrdNm%>", ComboCode:"<%=rkEvlGrdC%>",Edit:0},
			{Header:"통제 등급|통제 등급",Type:"Text",Width:80,Align:"Center",SaveName:"sheet2_ctev_grd_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
			{Header:"잔여위험 등급|잔여위험 등급",Type:"Text",Width:80,Align:"Center",SaveName:"sheet2_rmn_rsk_grd_c",MinWidth:60,ComboText:"<%=rkRmnRskGrdNm%>", ComboCode:"<%=rkRmnRskGrdC%>",Edit:0},
			 ];
        
        IBS_InitSheet(mySheet2,initData);
        mySheet2.SetEditable(0);
       // mySheet2.InitHeaders(headers);
      //필터표시
		//mySheet2.ShowFilterRow();  
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet2.SetCountPosition(0);
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet2.SetSelectionMode(4);	
		//mySheet2_doAction('search');
    }
    
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	function mySheet2_doAction(str){
		switch(str){
			case 'search':
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("rsa");
				$("form[name=ormsForm] [name=process_id]").val("ORRC011805");
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
			break;
		}
		
	}
    
    function mySheet2_OnSearchEnd(code,msg) {
    	if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			//chartDraw(); //차트
		}
    }

	function initIBSheet3() {
		
		mySheet3.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"업무프로세스 Lv3|업무프로세스 Lv3",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_prssnm3",MinWidth:100,Edit:0},
			{Header:"위험등급|GREEN",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_green_cnt",MinWidth:60},
			{Header:"위험등급|YELLOW",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_yellow_cnt",MinWidth:60},
			{Header:"위험등급|RED",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_red_cnt",MinWidth:60},
			{Header:"통제등급|상",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_ctev_high_cnt",MinWidth:60},
			{Header:"통제등급|중",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_ctev_mid_cnt",MinWidth:60},
			{Header:"통제등급|하",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_ctev_low_cnt",MinWidth:60},
			{Header:"잔여 위험 등급|GREEN",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_rmn_rsk_green_cnt",MinWidth:60},
			{Header:"잔여 위험 등급|YELLOW",Type:"Text",Width:100,Align:"Left",SaveName:"sheet3_rmn_rsk_yellow_cnt",MinWidth:60},
			{Header:"잔여 위험 등급|RED",Type:"Text",Width:150,Align:"Left",SaveName:"sheet3_rmn_rsk_red_cnt",MinWidth:60}
        ];
        
        IBS_InitSheet(mySheet3,initData);
        mySheet3.SetEditable(0);
        //mySheet3.InitHeaders(headers);
      //필터표시
		//mySheet3.ShowFilterRow();  
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet3.SetCountPosition(0);
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet3.SetSelectionMode(4);	
		//mySheet3_doAction('search');
    }
    
	var row = "";
	function mySheet3_doAction(str){
		switch(str){
			case 'search':
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("rsa");
				$("form[name=ormsForm] [name=process_id]").val("ORRC011806");
				mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt); 
				
			break;
		}
		
	}
    
    function mySheet3_OnSearchEnd(code,msg) {
    	if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			//chartDraw(); //차트
		}
    }
    
	function search(){
		if($("#sch_hd_brc").val()==""){
			alert("부서를 선택하세요.");
			return;
		}
		$("#info_bas_ym").val($("#sch_bas_yy").val()+$("#sch_bas_mm").val());
		$("#info_bas_ym").text($("#sch_bas_yy").val()+$("#sch_bas_mm").val());
		$("#info_brnm").text($("#sch_hd_brc_nm").val());
		$("#brnm").text($("#sch_hd_brc_nm").val());
		getEvlInfo();
		
		mySheet1_doAction('search');
		mySheet2_doAction('search');
		mySheet3_doAction('search');
	} 
	
	
	
	function down2Excel(){
		var f = document.ormsForm;
		
        f.action="<%=System.getProperty("contextpath")%>/rsaReportExcel.do";
		f.target = "_self";
		f.submit();
		
	}


	$("#sch_bas_yy").ready(function() {
		
		$("#sch_bas_yy").change(function() {
			bas_mm_chg();
		});
		$("#sch_bas_mm").trigger("change");
		
	});

	function bas_mm_chg(){
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC011802");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			WP.load(url, inputData,{
				success: function(result){
//						alert(result.rtnCode);
					
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
						var rList = result.DATA;
						var html="";
						for(var i=0;i<rList.length;i++){
							html += '<option value="'+rList[i].bas_mm+'">'+rList[i].bas_mm+'</option>';						
						}
						$("#sch_bas_mm").html(html);

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

	function getEvlInfo(){
		var f = document.ormsForm;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC011803");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
					var rList = result.DATA;
					/*val*/
					$("#green_cnt").val(rList[0].green_cnt);
					$("#yellow_cnt").val(rList[0].yellow_cnt);
					$("#red_cnt").val(rList[0].red_cnt);
					$("#ctev_high_cnt").val(rList[0].ctev_high_cnt);
					$("#ctev_mid_cnt").val(rList[0].ctev_mid_cnt);
					$("#ctev_low_cnt").val(rList[0].ctev_low_cnt);
					$("#rmn_rsk_green_cnt").val(rList[0].rmn_rsk_green_cnt);
					$("#rmn_rsk_yellow_cnt").val(rList[0].rmn_rsk_yellow_cnt);
					$("#rmn_rsk_red_cnt").val(rList[0].rmn_rsk_red_cnt);
					
					$("#tot_cnt").val(parseInt(rList[0].green_cnt)+parseInt(rList[0].yellow_cnt)+parseInt(rList[0].red_cnt));
					$("#ctev_tot_cnt").val(parseInt(rList[0].ctev_high_cnt)+parseInt(rList[0].ctev_mid_cnt)+parseInt(rList[0].ctev_low_cnt));
					$("#rmn_rsk_tot_cnt").val(parseInt(rList[0].rmn_rsk_green_cnt)+parseInt(rList[0].rmn_rsk_yellow_cnt)+parseInt(rList[0].rmn_rsk_red_cnt));
					
					$("#rbf_green_cnt").val(rList[0].rbf_green_cnt);
					$("#rbf_yellow_cnt").val(rList[0].rbf_yellow_cnt);
					$("#rbf_red_cnt").val(rList[0].rbf_red_cnt);
					$("#rbf_ctev_high_cnt").val(rList[0].rbf_ctev_high_cnt);
					$("#rbf_ctev_mid_cnt").val(rList[0].rbf_ctev_mid_cnt);
					$("#rbf_ctev_low_cnt").val(rList[0].rbf_ctev_low_cnt);
					$("#rbf_rmn_rsk_green_cnt").val(rList[0].rbf_rmn_rsk_green_cnt);
					$("#rbf_rmn_rsk_yellow_cnt").val(rList[0].rbf_rmn_rsk_yellow_cnt);
					$("#rbf_rmn_rsk_red_cnt").val(rList[0].rbf_rmn_rsk_red_cnt);
					
					$("#rbf_tot_cnt").val(parseInt(rList[0].rbf_green_cnt)+parseInt(rList[0].rbf_yellow_cnt)+parseInt(rList[0].rbf_red_cnt));
					$("#rbf_ctev_tot_cnt").val(parseInt(rList[0].rbf_ctev_high_cnt)+parseInt(rList[0].rbf_ctev_mid_cnt)+parseInt(rList[0].rbf_ctev_low_cnt));
					$("#rbf_rmn_rsk_tot_cnt").val(parseInt(rList[0].rbf_rmn_rsk_green_cnt)+parseInt(rList[0].rbf_rmn_rsk_yellow_cnt)+parseInt(rList[0].rbf_rmn_rsk_red_cnt));
					
					$("#stat_brc_emp_cnt").val(rList[0].vlr_eno_cnt);
					$("#stat_brc_rsk_cnt").val(rList[0].all_cnt);
					
					
					<%if(hofc_bizo_dsc.equals("02")){%>
					$("#stat_tot_rsk_cnt").val(rList[0].bizo_02_evl_cnt);
					$("#stat_tot_emp_cnt").val(rList[0].bizo_02_vlr_eno_cnt);
					<%}else if (hofc_bizo_dsc.equals("03")){%>
					$("#stat_tot_rsk_cnt").val(rList[0].bizo_03_evl_cnt);
					$("#stat_tot_emp_cnt").val(rList[0].bizo_03_vlr_eno_cnt);
					<%}%>
					
					
					/*text*/
					$("#green_cnt").text(rList[0].green_cnt);
					$("#yellow_cnt").text(rList[0].yellow_cnt);
					$("#red_cnt").text(rList[0].red_cnt);
					
					$("#ctev_high_cnt").text(rList[0].ctev_high_cnt);
					$("#ctev_mid_cnt").text(rList[0].ctev_mid_cnt);
					$("#ctev_low_cnt").text(rList[0].ctev_low_cnt);
					
					$("#rmn_rsk_green_cnt").text(rList[0].rmn_rsk_green_cnt);
					$("#rmn_rsk_yellow_cnt").text(rList[0].rmn_rsk_yellow_cnt);
					$("#rmn_rsk_red_cnt").text(rList[0].rmn_rsk_red_cnt);
					
					$("#tot_cnt").text(parseInt(rList[0].green_cnt)+parseInt(rList[0].yellow_cnt)+parseInt(rList[0].red_cnt));
					$("#ctev_tot_cnt").text(parseInt(rList[0].ctev_high_cnt)+parseInt(rList[0].ctev_mid_cnt)+parseInt(rList[0].ctev_low_cnt));
					$("#rmn_rsk_tot_cnt").text(parseInt(rList[0].rmn_rsk_green_cnt)+parseInt(rList[0].rmn_rsk_yellow_cnt)+parseInt(rList[0].rmn_rsk_red_cnt));
					
					$("#rbf_green_cnt").text(rList[0].rbf_green_cnt);
					$("#rbf_yellow_cnt").text(rList[0].rbf_yellow_cnt);
					$("#rbf_red_cnt").text(rList[0].rbf_red_cnt);
					$("#rbf_ctev_high_cnt").text(rList[0].rbf_ctev_high_cnt);
					$("#rbf_ctev_mid_cnt").text(rList[0].rbf_ctev_mid_cnt);
					$("#rbf_ctev_low_cnt").text(rList[0].rbf_ctev_low_cnt);
					$("#rbf_rmn_rsk_green_cnt").text(rList[0].rbf_rmn_rsk_green_cnt);
					$("#rbf_rmn_rsk_yellow_cnt").text(rList[0].rbf_rmn_rsk_yellow_cnt);
					$("#rbf_rmn_rsk_red_cnt").text(rList[0].rbf_rmn_rsk_red_cnt);
					
					$("#rbf_tot_cnt").text(parseInt(rList[0].rbf_green_cnt)+parseInt(rList[0].rbf_yellow_cnt)+parseInt(rList[0].rbf_red_cnt));
					$("#rbf_ctev_tot_cnt").text(parseInt(rList[0].rbf_ctev_high_cnt)+parseInt(rList[0].rbf_ctev_mid_cnt)+parseInt(rList[0].rbf_ctev_low_cnt));
					$("#rbf_rmn_rsk_tot_cnt").text(parseInt(rList[0].rbf_rmn_rsk_green_cnt)+parseInt(rList[0].rbf_rmn_rsk_yellow_cnt)+parseInt(rList[0].rbf_rmn_rsk_red_cnt));
					
					$("#stat_brc_emp_cnt").text(rList[0].vlr_eno_cnt);
					$("#stat_brc_rsk_cnt").text(rList[0].all_cnt);
					

					<%if(hofc_bizo_dsc.equals("02")){%>
					$("#stat_tot_rsk_cnt").text(rList[0].bizo_02_evl_cnt);
					$("#stat_tot_emp_cnt").text(rList[0].bizo_02_vlr_eno_cnt);
					<%}else if (hofc_bizo_dsc.equals("03")){%>
					$("#stat_tot_rsk_cnt").text(rList[0].bizo_03_evl_cnt);
					$("#stat_tot_emp_cnt").text(rList[0].bizo_03_vlr_eno_cnt);
					<%}%>
					
					
					if(rList[0].all_cnt==0)
						{
							$("#green_ratio").val("0");
							$("#yellow_ratio").val("0");
							$("#red_ratio").val("0");
							$("#tot_ratio").val("0");
							
							$("#ctev_high_ratio").val("0");
							$("#ctev_mid_ratio").val("0");
							$("#ctev_low_ratio").val("0");
							$("#ctev_tot_ratio").val("0");
							
							$("#rmn_rsk_green_ratio").val("0");
							$("#rmn_rsk_yellow_ratio").val("0");
							$("#rmn_rsk_red_ratio").val("0");
							$("#rmn_rsk_tot_ratio").val("0");
							
							$("#green_ratio").text("0%");
							$("#yellow_ratio").text("0%");
							$("#red_ratio").text("0%");
							$("#tot_ratio").text("0%");
							
							$("#ctev_high_ratio").text("0%");
							$("#ctev_mid_ratio").text("0%");
							$("#ctev_low_ratio").text("0%");
							$("#ctev_tot_ratio").text("0%");
							
							$("#rmn_rsk_green_ratio").text("0%");
							$("#rmn_rsk_yellow_ratio").text("0%");
							$("#rmn_rsk_red_ratio").text("0%");
							$("#rmn_rsk_tot_ratio").text("0%");
						}
					else
					{		/*val*/
							$("#green_ratio").val(roundToTwo(parseInt($("#green_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#yellow_ratio").val(roundToTwo(parseInt($("#yellow_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#red_ratio").val(roundToTwo(parseInt($("#red_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							
							$("#ctev_low_ratio").val(roundToTwo(parseInt($("#ctev_low_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#ctev_mid_ratio").val(roundToTwo(parseInt($("#ctev_mid_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#ctev_high_ratio").val(roundToTwo(parseInt($("#ctev_high_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							
							$("#rmn_rsk_green_ratio").val(roundToTwo(parseInt($("#rmn_rsk_green_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#rmn_rsk_yellow_ratio").val(roundToTwo(parseInt($("#rmn_rsk_yellow_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#rmn_rsk_red_ratio").val(roundToTwo(parseInt($("#rmn_rsk_red_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							
							$("#tot_ratio").val(roundToTwo(parseInt($("#tot_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#ctev_tot_ratio").val(roundToTwo(parseInt($("#tot_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							$("#rmn_rsk_tot_ratio").val(roundToTwo(parseInt($("#tot_cnt").val())/parseInt(rList[0].all_cnt) * 100));
							/*text*/
							$("#green_ratio").text(roundToTwo(parseInt($("#green_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#yellow_ratio").text(roundToTwo(parseInt($("#yellow_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#red_ratio").text(roundToTwo(parseInt($("#red_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							
							$("#ctev_low_ratio").text(roundToTwo(parseInt($("#ctev_low_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#ctev_mid_ratio").text(roundToTwo(parseInt($("#ctev_mid_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#ctev_high_ratio").text(roundToTwo(parseInt($("#ctev_high_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							
							$("#rmn_rsk_green_ratio").text(roundToTwo(parseInt($("#rmn_rsk_green_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#rmn_rsk_yellow_ratio").text(roundToTwo(parseInt($("#rmn_rsk_yellow_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#rmn_rsk_red_ratio").text(roundToTwo(parseInt($("#rmn_rsk_red_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							
							$("#tot_ratio").text(roundToTwo(parseInt($("#tot_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#ctev_tot_ratio").text(roundToTwo(parseInt($("#tot_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							$("#rmn_rsk_tot_ratio").text(roundToTwo(parseInt($("#tot_cnt").text())/parseInt(rList[0].all_cnt) * 100));
							
					}
					
					/*직전회차*/
					if(rList[0].rbf_all_cnt==0)
						{
							$("#rbf_green_ratio").val("0");
							$("#rbf_yellow_ratio").val("0");
							$("#rbf_red_ratio").val("0");
							$("#rbf_tot_ratio").val("0");
							
							$("#rbf_ctev_high_ratio").val("0");
							$("#rbf_ctev_mid_ratio").val("0");
							$("#rbf_ctev_low_ratio").val("0");
							$("#rbf_ctev_tot_ratio").val("0");
							
							$("#rbf_rmn_rsk_green_ratio").val("0");
							$("#rbf_rmn_rsk_yellow_ratio").val("0");
							$("#rbf_rmn_rsk_red_ratio").val("0");
							$("#rbf_rmn_rsk_tot_ratio").val("0");
							
							$("#rbf_green_ratio").text("0%");
							$("#rbf_yellow_ratio").text("0%");
							$("#rbf_red_ratio").text("0%");
							$("#rbf_tot_ratio").text("0%");
							
							$("#rbf_ctev_high_ratio").text("0%");
							$("#rbf_ctev_mid_ratio").text("0%");
							$("#rbf_ctev_low_ratio").text("0%");
							$("#rbf_ctev_tot_ratio").text("0%");
							
							$("#rbf_rmn_rsk_green_ratio").text("0%");
							$("#rbf_rmn_rsk_yellow_ratio").text("0%");
							$("#rbf_rmn_rsk_red_ratio").text("0%");
							$("#rbf_rmn_rsk_tot_ratio").text("0%");
						}
					else
					{		
							/*val*/
							$("#rbf_green_ratio").val(roundToTwo(parseInt($("#rbf_green_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_yellow_ratio").val(roundToTwo(parseInt($("#rbf_yellow_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_red_ratio").val(roundToTwo(parseInt($("#rbf_red_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							
							$("#rbf_ctev_low_ratio").val(roundToTwo(parseInt($("#rbf_ctev_low_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_ctev_mid_ratio").val(roundToTwo(parseInt($("#rbf_ctev_mid_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_ctev_high_ratio").val(roundToTwo(parseInt($("#rbf_ctev_high_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							
							$("#rbf_rmn_rsk_green_ratio").val(roundToTwo(parseInt($("#rbf_rmn_rsk_green_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_rmn_rsk_yellow_ratio").val(roundToTwo(parseInt($("#rbf_rmn_rsk_yellow_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_rmn_rsk_red_ratio").val(roundToTwo(parseInt($("#rbf_rmn_rsk_red_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							
							$("#rbf_tot_ratio").val(roundToTwo(parseInt($("#rbf_tot_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_ctev_tot_ratio").val(roundToTwo(parseInt($("#rbf_tot_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_rmn_rsk_tot_ratio").val(roundToTwo(parseInt($("#rbf_tot_cnt").val())/parseInt(rList[0].rbf_all_cnt) * 100));
							/*text*/
							$("#rbf_green_ratio").text(roundToTwo(parseInt($("#rbf_green_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_yellow_ratio").text(roundToTwo(parseInt($("#rbf_yellow_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_red_ratio").text(roundToTwo(parseInt($("#rbf_red_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							
							$("#rbf_ctev_low_ratio").text(roundToTwo(parseInt($("#rbf_ctev_low_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_ctev_mid_ratio").text(roundToTwo(parseInt($("#rbf_ctev_mid_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_ctev_high_ratio").text(roundToTwo(parseInt($("#rbf_ctev_high_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							
							$("#rbf_rmn_rsk_green_ratio").text(roundToTwo(parseInt($("#rbf_rmn_rsk_green_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_rmn_rsk_yellow_ratio").text(roundToTwo(parseInt($("#rbf_rmn_rsk_yellow_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_rmn_rsk_red_ratio").text(roundToTwo(parseInt($("#rbf_rmn_rsk_red_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							
							$("#rbf_tot_ratio").text(roundToTwo(parseInt($("#rbf_tot_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_ctev_tot_ratio").text(roundToTwo(parseInt($("#rbf_tot_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							$("#rbf_rmn_rsk_tot_ratio").text(roundToTwo(parseInt($("#rbf_tot_cnt").text())/parseInt(rList[0].rbf_all_cnt) * 100));
							
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
	}
	
	function roundToTwo(num) {
		return +(Math.round(num + "e+2") + "e-2")+"%";
	}

	function getGrdMatrix(){
		var f = document.ormsForm;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC011006");  // 환산손실조회
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
//					alert(result.rtnCode);
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
					var rList = result.DATA;
								
					var html="";
					html += "<table class='w850'>";
					html += "<colgroup>";
					html += "<col style='width:160px' />";
					html += "<col style='width:160px' />";
					html += "<col style='width:80px' />";
					html += "<col style='width:80px' />";
					html += "<col style='width:80px' />";
					html += "<col style='width:80px' />";
					html += "<col style='width:80px' />";
					html += "</colgroup>";
					html += "<thead>";
					html += "<tr>";
					html += "	<th scope='row' class='vm'>연 평균<br />손실금액</th>";
					html += "	<th>영향등급</th>";
					html += "	<th colspan='5'>연간 환산 손실 계산 금액(단위:억원)</th>";
					html += "</tr>";
					html += "</thead>";
					html += "<tbody>";
					for(var i=0;i<rList.length-2;i++){
						
						html += "<tr>";
						html += "	<th scope='row'><span class='ib w40 right'>"+zeroPadding(setFormatCurrency(rList[i].average_amt,","))+"</span></th>";
						html += "		<th>"+rList[i].fna_ifn_c+"</th>";
						for(var j=1;j<=5;j++){
							if(rList[i].average_amt * rList[rList.length-1]["frq"+j] >= 155){
								html += "		<td class='bgr cw'><span class='ib w65 right'>"+zeroPadding(setFormatCurrency(rList[i]["frq"+j],","))+"</span></td>";
							}else if(rList[i].average_amt * rList[rList.length-1]["frq"+j] > 1.25){
								html += "		<td class='bgy cw'><span class='ib w65 right'>"+zeroPadding(setFormatCurrency(rList[i]["frq"+j],","))+"</span></td>";
							}else if(rList[i].average_amt * rList[rList.length-1]["frq"+j] <= 1.25){
								html += "		<td class='bgg cw'><span class='ib w65 right'>"+zeroPadding(setFormatCurrency(rList[i]["frq"+j],","))+"</span></td>";
							}else{
								html += "		<td><span class='ib w65 right'>"+zeroPadding(setFormatCurrency(rList[i]["frq"+j],","))+"</span></td>";
							}
						}
						
						html += "</tr>";
						
					}
					html += "</tbody>";
					html += "<tfoot class='center'>";
					for(var i=rList.length-2;i<rList.length;i++){
						html += "<tr>";
						html += "<th colspan='2' class='light'>"+rList[i].fna_ifn_c+"</th>";
						html += "<td>"+zeroPadding(rList[i].frq1)+"</td>";
						html += "<td>"+zeroPadding(rList[i].frq2)+"</td>";
						html += "<td>"+zeroPadding(rList[i].frq3)+"</td>";
						html += "<td>"+zeroPadding(rList[i].frq4)+"</td>";
						html += "<td>"+zeroPadding(rList[i].frq5)+"</td>";
						html += "</tr>";
					}
					html += "</tfoot>";
					html += "</table>";
					$("#table_data").html(html);

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
	}

	</script>

</head>
<body onkeyPress="return EnterkeyPass()";>
	<div class="container">
		<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>

		<div class="content">
			<form name="ormsForm" method="post">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="sch_hd_brc" name="sch_hd_brc" value="<%=init_brc%>"/>
				<input type="hidden" id="svg1" name="svg1" value="" />
				<input type="hidden" id="svg2" name="svg2" value="" />
				<input type="hidden" id="svg3" name="svg3" value="" />
				<input type="hidden" id="svg4" name="svg4" value="" />
				<input type="hidden" id="up_brnm" name="up_brnm" value="" />
				
				<div id="del_area"></div>
				<!-- 조회 -->
				<!-- .search-area 검색영역 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>  
								<tbody>
									<tr> 
										<th>기준년월</th>
										<td class="form-inline">
											<span class="select">
												<select class="form-control" id="sch_bas_yy" name="sch_bas_yy" >
<%
	if (vLst != null)
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
%>
													<option value="<%=(String)hMap.get("year")%>"><%=(String)hMap.get("year")%>년</option>
<%
		}
%>
												</select>
											</span>
											<span class="select">
												<select class="form-control" id="sch_bas_mm" name="sch_bas_mm" >
												</select>
											</span>
										</td>
										<th>평가조직</th>
										<td>
											<div class="input-group">
												<input type="text" class="form-control w150" id="sch_hd_brc_nm" name="sch_hd_brc_nm" readonly value="<%=init_brnm%>"  placeholder="부서선택"/>
<%
if("Y".equals(adm_yn)){
%>
												<span class="input-group-btn">
													<button class="btn btn-default ico" type="button"  onclick="org_popup1();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											  	</span>
<%
}
%>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .box-body //-->
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onClick="javascript:search();">조회</button>
					</div>
				</div><!-- .search-area //-->
			</form>
			<!-- Main content -->
			<div class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">평가정보</h2>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="javascript:down2Excel();"><i class="ico xls"></i>엑셀 다운로드</button>
					</div> 
				</div>
				<div class="box-body">
					<div class="wrap-table">
						<table class="w500">
							<colgroup>
								<col style="width: 150px;">
								<col>
							</colgroup>
							<tbody class="center">
								<tr>
									<th>기준년월</th>
									<th>평가조직</th>
								</tr>
								<tr>
									<td id="info_bas_ym">&nbsp;</td>
									<td id="info_brnm">&nbsp;</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			
			<div class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">평가현황</h2>
				</div>
				<div class="box-body row">
					<div class="col">
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th colspan="4"  id="brnm"></th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th>평가자수</th>
										<td id="stat_brc_emp_cnt" class="right"></td>
										<th>평가항목</th>
										<td id="stat_brc_rsk_cnt" class="right"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
<%
if(!"Y".equals(adm_yn)){
%>
					<div class="col">
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<%if(hofc_bizo_dsc.equals("02")){ %>
										<th colspan="4">본부부서전체</th>
										<%}else if(hofc_bizo_dsc.equals("03")){ %>
										<th colspan="4">영업점 전체</th>
										<%} %>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<th>평가자수</th>
										<td id="stat_tot_emp_cnt" class="right"></td>
										<th>평가항목</th>
										<td id="stat_tot_rsk_cnt" class="right"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
<%} %>
				</div>
			</div>

			<div class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">평가 결과 분포</h2>
				</div>
				<div class="box-body">
					<div class="row">
						<div class="col">
							<div class="wrap-table">
								<table>
									<thead>
										<tr>
											<th colspan="5" >위험 등급</th>
										</tr>
										<tr>
											<th scope="row">등급</th>
											<th scope="row">개수</th>
											<th scope="row">비율</th>
											<th scope="row">직전평가 개수</th>
											<th scope="row">직전평가 비율</th>
										</tr>
									</thead>
									<tbody class="center">
										<tr>
											<th scope="row">GREEN</th>
											<td id="green_cnt" class="right"></td>
											<td id="green_ratio" class="right"></td>
											<td id="rbf_green_cnt" class="right"></td>
											<td id="rbf_green_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">YELLOW</th>
											<td id="yellow_cnt" class="right"></td>
											<td id="yellow_ratio" class="right"></td>
											<td id="rbf_yellow_cnt" class="right"></td>
											<td id="rbf_yellow_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">RED</th>
											<td id="red_cnt" class="right"></td>
											<td id="red_ratio" class="right"></td>
											<td id="rbf_red_cnt" class="right"></td>
											<td id="rbf_red_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">계</th>
											<td id="tot_cnt" class="right"></td>
											<td id="tot_ratio" class="right"></td>
											<td id="rbf_tot_cnt" class="right"></td>
											<td id="rbf_tot_ratio" class="right"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="col">
							<div class="wrap-table">
								<table>
									<thead>
										<tr>
											<th colspan="5" >통제 등급</th>
										</tr>
										<tr>
											<th scope="row">등급</th>
											<th scope="row">개수</th>
											<th scope="row">비율</th>
											<th scope="row">직전평가 개수</th>
											<th scope="row">직전평가 비율</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th scope="row">상</th>
											<td id="ctev_high_cnt" class="right"></td>
											<td id="ctev_high_ratio" class="right"></td>
											<td id="rbf_ctev_high_cnt" class="right"></td>
											<td id="rbf_ctev_high_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">중</th>
											<td id="ctev_mid_cnt" class="right"></td>
											<td id="ctev_mid_ratio" class="right"></td>
											<td id="rbf_ctev_mid_cnt" class="right"></td>
											<td id="rbf_ctev_mid_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">하</th>
											<td id="ctev_low_cnt" class="right"></td>
											<td id="ctev_low_ratio" class="right"></td>
											<td id="rbf_ctev_low_cnt" class="right"></td>
											<td id="rbf_ctev_low_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">계</th>
											<td id="ctev_tot_cnt" class="right"></td>
											<td id="ctev_tot_ratio" class="right"></td>
											<td id="rbf_ctev_tot_cnt" class="right"></td>
											<td id="rbf_ctev_tot_ratio" class="right"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="col">
							<div class="wrap-table">
								<table>
									<thead>
										<tr>
											<th colspan="5" >잔여위험 등급</th>
										</tr>
										<tr>
											<th scope="row">등급</th>
											<th scope="row">개수</th>
											<th scope="row">비율</th>
											<th scope="row">직전평가 개수</th>
											<th scope="row">직전평가 비율</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th scope="row">GREEN</th>
											<td id="rmn_rsk_green_cnt" class="right"></td>
											<td id="rmn_rsk_green_ratio" class="right"></td>
											<td id="rbf_rmn_rsk_green_cnt" class="right"></td>
											<td id="rbf_rmn_rsk_green_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">YELLOW</th>
											<td id="rmn_rsk_yellow_cnt" class="right"></td>
											<td id="rmn_rsk_yellow_ratio" class="right"></td>
											<td id="rbf_rmn_rsk_yellow_cnt" class="right"></td>
											<td id="rbf_rmn_rsk_yellow_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">RED</th>
											<td id="rmn_rsk_red_cnt" class="right"></td>
											<td id="rmn_rsk_red_ratio" class="right"></td>
											<td id="rbf_rmn_rsk_red_cnt" class="right"></td>
											<td id="rbf_rmn_rsk_red_ratio" class="right"></td>
										</tr>
										<tr>
											<th scope="row">계</th>
											<td id="rmn_rsk_tot_cnt" class="right"></td>
											<td id="rmn_rsk_tot_ratio" class="right"></td>
											<td id="rbf_rmn_rsk_tot_cnt" class="right"></td>
											<td id="rbf_rmn_rsk_tot_ratio" class="right"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">잔여 위험 RED발생 리스크 사례</h2>
				</div>
				<div class="box-body">
					<div class="wrap-grid h300">
						<script> createIBSheet("mySheet1", "100%", "100%"); </script>
					</div>
				</div>
			</div>

			<div class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">고위험 업무 프로세스 (잔여 위험  Red 발생 업무 프로세스)</h2>
				</div>
				<div class="box-body">
					<div class="wrap-grid h300">
						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div>
				</div>
			</div>

			<div class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">업무 프로세스 Lv3별 RCSA결과</h2>
				</div>
				<div class="box-body">
					<div class="wrap-grid h300">
						<script> createIBSheet("mySheet3", "100%", "100%"); </script>
					</div>
				</div>
			</div>

			<div class="box box-grid">
				<div class="box-header">
					<h2 class="title">&lt;참고 : 리스크등급 선정 Matrix&gt;</h2>
				</div>
				<div class="box-body">   
					<div class="wrap-table">
						<div id="table_data"></div>
					</div>
				</div><!-- .box-body //-->
			</div><!-- .box //-->
		</div><!-- .container //-->
	</div><!-- .container //-->
	<!-- popup //-->
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<script>
	
	
		var init_flag = false;
		function org_popup1(){
			schOrgPopup("sch_hd_brc_nm", "orgSearchEnd1");
			if($("#sch_hd_brc_nm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}

		// 부서검색 완료
		function orgSearchEnd1(brc, brnm){
			if(brc=="") init_flag = true;
			$("#sch_hd_brc").val(brc);
			$("#sch_hd_brc_nm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
		
	</script>
</body>
<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});
</script>
</html>