<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0121.jsp
 Program name : 대응방안 등록 및 조회
 Description  : 화면정의서 RCSA-14.3
 Programer    : 박승윤
 Date created : 2022.09.26
 ---------------------------------------------------------------------------*/
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/library.jsp" %>

<%

/*
	rcsa_menu_dsc 
  1 : ORM
  2 : 부서 리스크담당자
  3 : 부서장/지점장 (결재자)
  4 : 일반사용자
  5 : ORM팀장
*/
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");
DynaForm form = (DynaForm)request.getAttribute("form");
Vector vBaseInfo= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vBaseInfo==null) vBaseInfo = new Vector();

 
String bef_bas_ym = CommUtil.getResultString(request, "grp01", 0, "unit02", 0, "bef_bas_ym");
String bas_ym = form.get("link_bas_ym");


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
<html lang="ko-kr">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RCSA - 대응방안 등록 및 조회</title>
</head>
<script language="javascript">
$(document).ready(function(){
		
			if($("#rcsa_menu_dsc").val()=='2' && $("#rcsa_act_dcz_stsc").val()<='03')
			{
				$("#save_btn").hide();
				$("#calendarButton1").show();
				$("#calendarButton2").show();
				$("#cas_dtl_cntn").attr("readonly",false);
				$("#cft_plan_cntn").attr("readonly",false);
			}
		// ibsheet 초기화
		initIBSheet1();
		initIBSheet2();
		parent.removeLoadingWs();
		DoSearch();
		//doAction('search');
	});


		// mySheet1
		function initIBSheet1() {
			var initdata = {};
			
			initdata.Cfg = {FrozenCol:0,Sort:1,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" };
			initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{ Header: "당기 (<%=bas_ym%>)|No|No",					Type: "Text",	SaveName: "no",	Align: "Center",	Width: 10,	MinWidth: 30,Edit:0 },
				{ Header: "당기 (<%=bas_ym%>)|위험평가|리스크 사례",			Type: "Text",	SaveName: "rk_isc_cntn",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|위험평가|영향평가(재무)",			Type:"Combo",Width:80,Align:"Center",SaveName:"ifn_evl_c",MinWidth:60,ComboText:"매우낮음|낮음|보통|높음|매우높음", ComboCode:"1|2|3|4|5",Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|위험평가|영향평가(비재무)",		Type:"Combo",Width:80,Align:"Center",SaveName:"nifn_evl_c",MinWidth:60,ComboText:"매우낮음|낮음|보통|높음|매우높음", ComboCode:"1|2|3|4|5",Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|위험평가|빈도평가",				Type:"Combo",Width:80,Align:"Center",SaveName:"frq_evl_c",MinWidth:60,ComboText:"매우낮음|낮음|보통|높음|매우높음", ComboCode:"1|2|3|4|5",Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|위험평가|위험등급",				Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_grd_c",MinWidth:60,ComboText:"<%=rkEvlGrdNm%>", ComboCode:"<%=rkEvlGrdC%>",Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|통제평가|통제활동",				Type: "Text",	SaveName: "rk_cp_cntn",	Align: "Center",	Width: 10,	MinWidth: 100,Edit:0 },
				{ Header: "당기 (<%=bas_ym%>)|통제평가|설계평가",				Type:"Combo",Width:80,Align:"Center",SaveName:"ctl_dsg_evl_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|통제평가|운영평가",				Type:"Combo",Width:80,Align:"Center",SaveName:"ctl_mngm_evl_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|통제평가|통제등급",				Type:"Combo",Width:80,Align:"Center",SaveName:"ctev_grd_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
				{ Header: "당기 (<%=bas_ym%>)|잔여위험\n등급|잔여위험\n등급",	Type:"Combo",Width:80,Align:"Center",SaveName:"rmn_rsk_grd_c",MinWidth:60,ComboText:"<%=rkRmnRskGrdNm%>", ComboCode:"<%=rkRmnRskGrdC%>",Edit:0}
			];
			IBS_InitSheet(mySheet1, initdata);
			mySheet1.SetSelectionMode(4);
		}				

		// mySheet2
		function initIBSheet2() {
			var initdata = {};
			initdata.Cfg = {FrozenCol:0,Sort:1,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" };
			initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{ Header: "전기 (<%=bef_bas_ym%>)|No|No",					Type: "Text",	SaveName: "no",	Align: "Center",	Width: 10,	MinWidth: 30 },
				{ Header: "전기 (<%=bef_bas_ym%>)|위험평가|리스크 사례",			Type: "Text",	SaveName: "rk_isc_cntn",	Align: "Center",	Width: 10,	MinWidth: 150 },
				{ Header: "전기 (<%=bef_bas_ym%>)|위험평가|영향평가(재무)",			Type:"Combo",Width:80,Align:"Center",SaveName:"ifn_evl_c",MinWidth:60,ComboText:"매우낮음|낮음|보통|높음|매우높음", ComboCode:"1|2|3|4|5",Edit:0},
				{ Header: "전기 (<%=bef_bas_ym%>)|위험평가|영향평가(비재무)",		Type:"Combo",Width:80,Align:"Center",SaveName:"nifn_evl_c",MinWidth:60,ComboText:"매우낮음|낮음|보통|높음|매우높음", ComboCode:"1|2|3|4|5",Edit:0},
				{ Header: "전기 (<%=bef_bas_ym%>)|위험평가|빈도평가",				Type:"Combo",Width:80,Align:"Center",SaveName:"frq_evl_c",MinWidth:60,ComboText:"매우낮음|낮음|보통|높음|매우높음", ComboCode:"1|2|3|4|5",Edit:0},
				{ Header: "전기 (<%=bef_bas_ym%>)|위험평가|위험등급",				Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_grd_c",MinWidth:60,ComboText:"<%=rkEvlGrdNm%>", ComboCode:"<%=rkEvlGrdC%>",Edit:0},
				{ Header: "전기 (<%=bef_bas_ym%>)|통제평가|통제활동",				Type: "Text",	SaveName: "rk_cp_cntn",	Align: "Center",	Width: 10,	MinWidth: 100 },
				{ Header: "전기 (<%=bef_bas_ym%>)|통제평가|설계평가",				Type:"Combo",Width:80,Align:"Center",SaveName:"ctl_dsg_evl_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
				{ Header: "전기 (<%=bef_bas_ym%>)|통제평가|운영평가",				Type:"Combo",Width:80,Align:"Center",SaveName:"ctl_mngm_evl_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
				{ Header: "전기 (<%=bef_bas_ym%>)|통제평가|통제등급",				Type:"Combo",Width:80,Align:"Center",SaveName:"ctev_grd_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
				{ Header: "전기 (<%=bef_bas_ym%>)|잔여위험\n등급|잔여위험\n등급",	Type:"Combo",Width:80,Align:"Center",SaveName:"rmn_rsk_grd_c",MinWidth:60,ComboText:"<%=rkRmnRskGrdNm%>", ComboCode:"<%=rkRmnRskGrdC%>",Edit:0}
			];
			IBS_InitSheet(mySheet2, initdata);
			mySheet2.SetSelectionMode(4);
		}

function DoSearch() {
			
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012003");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

					  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					 var rList = result.DATA;  
					if(rList.length>0){                                  
					$("#evl_brnm").text(rList[0].sheet_brnm);
					$("#prssnm1").text(rList[0].prssnm1);
					$("#prssnm2").text(rList[0].prssnm2);
					$("#prssnm3").text(rList[0].prssnm3);
					$("#prssnm4").text(rList[0].prssnm4);

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
			
		var opt = {};
		$("form[name=ormsForm] [name=method]").val("Main");
		$("form[name=ormsForm] [name=commkind]").val("rsa");
		$("form[name=ormsForm] [name=process_id]").val("ORRC012102");

		mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
	
		var opt2 = {};
		$("form[name=ormsForm] [name=method]").val("Main");
		$("form[name=ormsForm] [name=commkind]").val("rsa");
		$("form[name=ormsForm] [name=process_id]").val("ORRC012103");

		mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt2);
		
		DoSearch2();
		DoSearch3();
		DoSearch4();
		}


function DoSearch2() {
			
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012104");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

					  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					 var rList = result.DATA;  
					if(rList.length>0){                                  

					$("#cas_dtl_cntn").text(rList[0].cas_dtl_cntn);
					$("#cft_plan_cntn").text(rList[0].cft_plan_cntn);
					
					if(rList[0].act_st_dt!=""){
					$("#act_st_dt").val(rList[0].act_st_dt);
					}
					if(rList[0].act_ed_dt!=""){
					$("#act_ed_dt").val(rList[0].act_ed_dt);
					}
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
function DoSearch3() {
			
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012106");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					 var rList = result.DATA;  
					if(rList.length>0){                                  

					$("#rk_evl_grd_c").text(rList[0].rk_evl_grd_c);
					$("#ctev_grd_c").text(rList[0].ctev_grd_c);
					$("#rmn_rsk_grd_c").text(rList[0].rmn_rsk_grd_c);

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
		
function DoSearch4() {
			
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012107");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					 var rList = result.DATA;  
					if(rList.length>0){                                  

					$("#bef_rk_evl_grd_c").text(rList[0].rk_evl_grd_c);
					$("#bef_ctev_grd_c").text(rList[0].ctev_grd_c);
					$("#bef_rmn_rsk_grd_c").text(rList[0].rmn_rsk_grd_c);

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

function save(sAction){
			
			var f = document.ormsForm;
		
			f.act_st_dt.value =  f.act_st_dt.value.replace(/-/g,"");
			f.act_ed_dt.value =  f.act_ed_dt.value.replace(/-/g,"");
			
			if( f.act_st_dt.value == ''){
				alert("수립일을 입력해 주세요")
				return;
			}
			
			if( f.act_ed_dt.value == ''){
				alert("대응방안 이행 완료 기일을 입력해 주세요")
				return;
			}
			
			if( f.cas_dtl_cntn.value == ''){
				alert("원인분석을 입력해 주세요")
				return;
			}
			
			if( f.cft_plan_cntn.value == ''){
				alert("대응방안을 입력해 주세요")
				return;
			}
			
			if(f.act_st_dt.value >= f.act_ed_dt.value){
				alert("이행 완료 기일은  수립일 보다 커야 합니다.")
				return;
			}		
			
			if(InputCheck(sAction) == false) return;
			
			
			
			if(sAction == "save")
			{	
				if(!confirm("저장하시겠습니까?")) return;
				doSave();
			}
			else if($("#rcsa_menu_dsc").val() =="2")
			{	
				schDczPopup(1);
			}
			else
			{	
				schDczPopup(2);
			}
		}

//입력값 체크
	function InputCheck(sAction) {
		
		var rcsa_menu_dsc = $("#rcsa_menu_dsc").val(); 
		var rcsa_act_dcz_stsc = $("#rcsa_act_dcz_stsc").val(); 

			
			if( rcsa_menu_dsc == 2){
				 if( rcsa_act_dcz_stsc > "03" ){
					 alert("이미 결재 요청 완료한 건 입니다.");
					 return false;
				 }
				if(sAction == "sub")
				{
					$("#dcz_dc").val("04");
			    	$("#dcz_objr_emp_auth").val("'004','006'");
			    }else
			    {
			   		 $("#dcz_dc").val("03");
			    }
			}
			else if( rcsa_menu_dsc == 3){
			 	if( rcsa_act_dcz_stsc > "04" ){
					 alert("이미 결재 완료한 건 입니다.");
					 return false;
				}else if(rcsa_act_dcz_stsc < "04")
				{
					 alert("결재요청 되지 않았습니다.");
					 return false;
				}
				$("#dcz_dc").val("13");
			    $("#dcz_objr_emp_auth").val("'002'");	 
			}
			else if( rcsa_menu_dsc == 1){
			 	if( rcsa_act_dcz_stsc > "13" ){
					 alert("이미 결재 완료한 건 입니다.");
					 return false;
				}else if(rcsa_act_dcz_stsc < "13")
				{
					 alert("팀/지점 장 결재 완료 되지 않았습니다.");
					 return false;
				}
				$("#dcz_dc").val("14");
			    $("#dcz_objr_emp_auth").val("'009'");	 	 
			}
			else if( rcsa_menu_dsc == 5){
			 	if( rcsa_act_dcz_stsc > "14" ){
					 alert("이미 결재 완료한 건 입니다.");
					 return false;
				}else if(rcsa_act_dcz_stsc < "14")
				{
					 alert("ORM 결재 완료 되지 않았습니다.");
					 return false;
				}
				$("#dcz_dc").val("15");
			}	
			 
		return true;
	}
	
	function doSave() {
			var f = document.ormsForm;
			
			f.act_st_dt.value =  f.act_st_dt.value.replace(/-/g,"");
			f.act_ed_dt.value =  f.act_ed_dt.value.replace(/-/g,"");
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC012105");

			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

						
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							parent.doAction('search');
							alert("저장 하였습니다.");
							$(".btn-close").trigger("click");
							$(".popup",parent.document).removeClass("block");

						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						//parent.goSavEnd();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
	}
	
function pop_help(){

			$("#ifrHelp").attr("src","about:blank");
			$("#winHelp").show();
			showLoadingWs(); // 프로그래스바 활성화
			setTimeout(modHelp,1);
}

function modHelp(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="rsa";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORRC012101_guide";
		f.target = "ifrHelp";
		f.submit();
	}
  
</script>

<body>
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w1000"> 
			<div class="p_head">
				<h1 class="title">대응방안 등록 및 조회</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
					<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					<input type="hidden" id="rcsa_menu_dsc" name="rcsa_menu_dsc" value="<%=form.get("rcsa_menu_dsc")%>" />
					<input type="hidden" id="rcsa_act_dcz_stsc" name="rcsa_act_dcz_stsc" value="<%=form.get("link_rcsa_act_dcz_stsc")%>" />
					<input type="hidden" id="dcz_dc" name="dcz_dc" />
			    	<input type="hidden" id="sch_hd_brc" name="sch_hd_brc" value="<%=form.get("link_brc")%>"/>
			    	<input type="hidden" id="sch_bsn_prss_c" name="sch_bsn_prss_c" value="<%=form.get("link_bsn_prss_c")%>"/>
			    	<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" value="<%=form.get("link_bas_ym")%>"/>
			    	<input type="hidden" id="bef_bas_ym" name="bef_bas_ym" value="<%=bef_bas_ym%>"/>
					<input type="hidden" id="table_name" name="table_name" value="TB_OR_RH_ACT_DCZ"/>
					<input type="hidden" id="dcz_code" name="stsc_column_name" value="RCSA_ACT_DCZ_STSC"/>
					<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="BSN_PRSS_C"/>
					<input type="hidden" id="rpst_id" name="rpst_id" value="<%=form.get("link_bsn_prss_c")%>"/>
					<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
					<input type="hidden" id="bas_pd" name="bas_pd" value="<%=form.get("link_bas_ym")%>"/>
					<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
					<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
					<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
					<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
					<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
					<input type="hidden" id="dcz_brc" name="dcz_brc" value="<%=form.get("link_brc")%>"/>
					<section class="box-grid">
						<div class="box-header">
							<div class="area-term">
								<span class="tit">평가 일정 :</span>
								<%
								for(int i=0;i<vBaseInfo.size();i++){
									HashMap hMap = (HashMap)vBaseInfo.get(i);
								%>
								<strong class="em" id="info_bas_ym"><%=(String)hMap.get("info_bas_ym")%></strong>
								<span class="em" id="info_evl_dt" ><%=(String)hMap.get("info_evl_dt")%></span>
								<%
								}
								%>
							</div>
						</div>
					</section>
					
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">1. 프로세스 정보</h2>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<tr>
										<th scope="col" >평가 부서</th>
										<th scope="col" >업무 프로세스 Lv1</th>
										<th scope="col" >업무 프로세스 Lv2</th>
										<th scope="col" >업무 프로세스 Lv3</th>
										<th scope="col" >업무 프로세스 Lv4</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td id="evl_brnm">AA부</td>
										<td id="prssnm1">수익사업</td>
										<td id="prssnm2">소매금융</td>
										<td id="prssnm3">개인수신</td>
										<td id="prssnm4">예금신규</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
					
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">2. 평가 결과</h2>
						</div>
						<article class="box-grid">
							<div class="box-header">
								<h3 class="title">2.1. 프로세스 기준 평가 등급</h3>
								<div class="area-tool">
									<button type="button" class="btn btn-default btn-xs" onclick="pop_help();"><i class="fa fa-exclamation-circle"></i><span class="txt">HELP</span></button>
								</div>
							</div>
							<div class="wrap-table">
								<table>
									<thead>
										<tr>
											<th scope="col" colspan="3">당기 (<%=bas_ym %>)</th>
											<th scope="col" colspan="3">전기 (<%=bef_bas_ym %>)</th>
										</tr>
										<tr>
											<th scope="col">위험등급</th>
											<th scope="col">통제등급</th>
											<th scope="col">잔여위험</th>
											<th scope="col">위험등급</th>
											<th scope="col">통제등급</th>
											<th scope="col">잔여위험</th>
										</tr>
									</thead>
									<tbody class="center">
										<tr>
											<td id="rk_evl_grd_c"></td>
											<td id="ctev_grd_c"></td>
											<td id="rmn_rsk_grd_c"></td>
											<td id="bef_rk_evl_grd_c"></td>
											<td id="bef_ctev_grd_c"></td>
											<td id="bef_rmn_rsk_grd_c"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</article>
						<article class="box box-grid">
							<div class="box-header">
								<h3 class="title">2.2. 리스크 사례별 평가 등급</h3>
							</div>
							<div class="wrap-grid h300">
								<script> createIBSheet("mySheet1", "100%", "100%"); </script>
							</div>
							<div class="wrap-grid h300">
								<script> createIBSheet("mySheet2", "100%", "100%"); </script>
							</div>
						</article>
					</section>
				
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">3. 대응방안 수립</h2>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">원인 분석</th>
										<td>
											<textarea id="cas_dtl_cntn" name="cas_dtl_cntn" class="form-control" placeholder="고위험 업무 프로세스로 평가된 원인 분석 내용을 기술하시오." readonly></textarea>
										</td>
									</tr>
									<tr>
										<th scope="row">대응방안</th>
										<td>
											<textarea id="cft_plan_cntn" name="cft_plan_cntn" class="form-control" placeholder="위험 경감 또는 통제 강화를 위한 대응방안을 기술하시오." readonly></textarea>
										</td>
									</tr>
									<tr>
										<th scope="row">대응방안 수립일</th>
										<td class="form-inline">
											<div class="input-group">
											<%
											for(int i=0;i<vBaseInfo.size();i++){
												HashMap hMap = (HashMap)vBaseInfo.get(i);
											%>
												<input type="text" id="act_st_dt" name="act_st_dt" class="form-control w90" value="<%=(String)hMap.get("act_st_dt")%>" readonly>
											<%
											}
											%>
												
												<span class="input-group-btn">
													<button class="btn btn-default ico" type="button" id="calendarButton1" onclick="showCalendar('yyyy-MM-dd','act_st_dt');" style="display:none"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row">대응방안 이행 완료 기일</th>
										<td class="form-inline">
											<div class="input-group">								
											<%
											for(int i=0;i<vBaseInfo.size();i++){
												HashMap hMap = (HashMap)vBaseInfo.get(i);
											%>
												<input type="text" id="act_ed_dt" name="act_ed_dt" class="form-control w90" value="<%=(String)hMap.get("act_ed_dt")%>" readonly>
											<%
											}
											%>	<span class="input-group-btn">
													<button class="btn btn-default ico" type="button" id="calendarButton2" onclick="showCalendar('yyyy-MM-dd','act_ed_dt');" style="display:none"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
												</span>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
					</form>
				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
				<%
if( form.get("rcsa_menu_dsc").equals("2") ){ 
 %>	
 					<button type="button" class="btn btn-normal" onclick="javascript:save('save');">임시저장</button>
					<button type="button" class="btn btn-primary" onclick="javascript:save('sub');">결재요청</button>
<%
}
else if( form.get("rcsa_menu_dsc").equals("4") ){ //일반사용자
%>
<%
}
else if( !form.get("rcsa_menu_dsc").equals("2") ){ 
%>
							<button type="button" class="btn btn-primary" onclick="javascript:save();">결재</button>
<%
}
%>

					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="btn btn-default btn-xs btn-fix" onclick=""><i class="fa fa-print"></i><span class="txt">PRINT</span></button>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	
	</article>
	<!-- popup //-->
	<div id="winHelp" class="popup modal">
		<iframe name="ifrHelp" id="ifrHelp" src="about:blank"></iframe>
	</div>

<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
	

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
	doSave();
}
// 결재팝업 연동 - 회수
function DczSearchEndCncl(){
	doCncl();
		} 
</script>

</body>
</html>