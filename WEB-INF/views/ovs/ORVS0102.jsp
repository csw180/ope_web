<%--
/*---------------------------------------------------------------------------
 Program ID   : ORVS010201.jsp
 Program name : 해외법인 운영리스크 월보고
 Description  : 화면정의서 ORMS-0101
 Programer    : 고창호
 Date created : 2022.08.08
 ---------------------------------------------------------------------------*/

--%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

/*해외보고서명 default 세팅*/
Vector vOvrsRptTit = CommUtil.getCommonCode(request, "OVRS_RPT_TIT");
if(vOvrsRptTit==null) vOvrsRptTit = new Vector();
String OvrsRptTit = "";
for(int i=0;i<vOvrsRptTit.size();i++){
	HashMap hMapTit = (HashMap)vOvrsRptTit.get(0);
	OvrsRptTit = (String)hMapTit.get("intg_cnm");
}

/*해외보고서 규제기준*/
Vector vOvrsRegStad = CommUtil.getCommonCode(request, "OVRS_REG_STAD");
if(vOvrsRegStad==null) vOvrsRegStad = new Vector();
String rglt_mnm_cpt_amt = "";
String rglt_slf_cpt_rt = "";
String rglt_irrt_hglm = "";
String rglt_ln_lmt_amt = "";
for(int i=0;i<vOvrsRegStad.size();i++){
	HashMap hMapStad = (HashMap)vOvrsRegStad.get(i);
	if("rglt_mnm_cpt_amt".equals((String)hMapStad.get("intgc"))){
		rglt_mnm_cpt_amt = (String)hMapStad.get("intg_cnm");
	}else if("rglt_slf_cpt_rt".equals((String)hMapStad.get("intgc"))){
		rglt_slf_cpt_rt = (String)hMapStad.get("intg_cnm");
	}else if("rglt_irrt_hglm".equals((String)hMapStad.get("intgc"))){
		rglt_irrt_hglm = (String)hMapStad.get("intg_cnm");
	}else if("rglt_ln_lmt_amt".equals((String)hMapStad.get("intgc"))){
		rglt_ln_lmt_amt = (String)hMapStad.get("intg_cnm");
	}
}





DynaForm form = (DynaForm)request.getAttribute("form");
String bas_yy = "";

String link_mode = form.get("mode");
String popBas_ym = form.get("popBas_ym");
if(popBas_ym == ""){
 popBas_ym ="999999";
 }


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>해외법인운영리스크 월 보고</title>
	
	<script>
	
	$(document).ready(function(){

	// ibsheet 초기화
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화

			$("#bas_yy").on('change',function(){
				basMadd() 	
			});
			if("U"=="<%=link_mode%>")
			{
				
					$("#bas_yy").val("<%=popBas_ym.substring(0,4)%>").prop("selected",true);
					basMadd();
				
					$("#bas_mm").val("<%=popBas_ym.substring(4,6)%>").prop("selected",true);
					DoSearch();
					
	
			}
			
		});
	
	
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
	/*Sheet 각종 처리*/
	  function doAction(sAction) {
		switch(sAction) {

			case "save":      //저장할 데이터 추출
			
			
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "ovr");
				WP.setParameter("process_id", "ORVS010204");
				WP.setForm(f);
				
				var inputData = WP.getParams();
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				{
					success: function(result){
						alert("저장완료");
						hide()
						doAction('DoSearch');
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
				});
				break;

				}
	}  
	
	
//데이터 불러오기//	
	function DoSearch() {
			
			if("I"=="<%=link_mode%>")return;
						
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "ovs");
			WP.setParameter("process_id", "ORVS010202");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){
					 if(result!='undefined' && result.rtnCode=="0") 
					  {
						  var rList = result.DATA;
						  if(rList != ""){
						  
						  $("#rpt_tit").val(rList[0].rpt_tit);
						  }else{
						  $("#rpt_tit").val("");
						  }
							
					  } else if(result.rtnCode!="0"){
							alert(result.rtnMsg);
					  }
					  

					if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rslt_slf_cpt_rt").val(rList[0].rslt_slf_cpt_rt);
					  }else{
					  $("#rslt_slf_cpt_rt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rslt_mnm_cpt_amt").val(rList[0].rslt_mnm_cpt_amt);
					  }else{
					  $("#rslt_mnm_cpt_amt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				 
				  // Y,N 체크 
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rslt_irrt_hglm").val(rList[0].rslt_irrt_hglm);
					  }else{
					  $("#rslt_irrt_hglm").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
			  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rslt_ln_lmt").val(rList[0].rslt_ln_lmt);
					  }else{
					  $("#rslt_ln_lmt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
	
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rglt_ln_lmt_amt").val(rList[0].rglt_ln_lmt_amt);
					  }else{
					  $("#rglt_ln_lmt_amt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rglt_mnm_cpt_amt").val(rList[0].rglt_mnm_cpt_amt);
					  }else{
					  $("#rglt_mnm_cpt_amt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rglt_slf_cpt_rt").val(rList[0].rglt_slf_cpt_rt);
					  }else{
					  $("#rglt_slf_cpt_rt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rglt_irrt_hglm").val(rList[0].rglt_irrt_hglm);
					  }else{
					  $("#rglt_irrt_hglm").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#lss_occ_cnt").val(rList[0].lss_occ_cnt);
					  }else{
					  $("#lss_occ_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#lss_occ_am").val(rList[0].lss_occ_am);
					  }else{
					  $("#lss_occ_am").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rcsa_prss_cnt").val(rList[0].rcsa_prss_cnt);
					  }else{
					  $("#rcsa_prss_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rcsa_rkp_cnt").val(rList[0].rcsa_rkp_cnt);
					  }else{
					  $("#rcsa_rkp_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#rcsa_evl_cnt").val(rList[0].rcsa_evl_cnt);
					  }else{
					  $("#rcsa_evl_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
	
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#kri_red_cnt").val(rList[0].kri_red_cnt);
					  }else{
					  $("#kri_red_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#kri_yellow_cnt").val(rList[0].kri_yellow_cnt);
					  }else{
					  $("#kri_yellow_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#kri_green_cnt").val(rList[0].kri_green_cnt);
					  }else{
					  $("#kri_green_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bcp_cntn").val(rList[0].bcp_cntn);
					  }else{
					  $("#bcp_cntn").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#snr_cntn").val(rList[0].snr_cntn);
					  }else{
					  $("#snr_cntn").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#snr_cntn").val(rList[0].snr_cntn);
					  }else{
					  $("#snr_cntn").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
  
				},
				  
				complete: function(statusText,status) {
					removeLoadingWs();
					calOvs();
				},
				  
				error: function(rtnMsg){
					alert(JSON.stringify(rtnMsg));
					
				}
			});
			removeLoadingWs();


//전분기 데이터 불러오기//	
		if("I"=="<%=link_mode%>")return;
					
		var f = document.ormsForm;
		
		
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "ovs");
		WP.setParameter("process_id", "ORVS010203");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
	
	WP.load(url, inputData,{
			success: function(result){
				 if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_lss_occ_cnt").val(rList[0].lss_occ_cnt);
					 
					  }else{
					  $("#bef_lss_occ_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				 
				 if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_lss_occ_am").val(rList[0].lss_occ_am);
					  }else{
					  $("#bef_lss_occ_am").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_rcsa_prss_cnt").val(rList[0].rcsa_prss_cnt);
					  }else{
					  $("#bef_rcsa_prss_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				 
				 if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_rcsa_rkp_cnt").val(rList[0].rcsa_rkp_cnt);
					  }else{
					  $("#bef_rcsa_rkp_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				 
				 if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_rcsa_evl_cnt").val(rList[0].rcsa_evl_cnt);
					  }else{
					  $("#bef_rcsa_evl_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				 
				 if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_kri_red_cnt").val(rList[0].kri_red_cnt);
					  }else{
					  $("#bef_kri_red_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				 
				 if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_kri_yellow_cnt").val(rList[0].kri_yellow_cnt);
					  }else{
					  $("#bef_kri_yellow_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  }
				 if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;
					  if(rList != ""){
					  
					  $("#bef_kri_green_cnt").val(rList[0].kri_green_cnt);
					  }else{
					  $("#bef_kri_green_cnt").val("");
					  }
						
				  } else if(result.rtnCode!="0"){
						alert(result.rtnMsg);
				  } 
			},
			  
			complete: function(statusText,status) {
				calOvs();
				removeLoadingWs();
			},
			  
			error: function(rtnMsg){
				alert(JSON.stringify(rtnMsg));
			}
		});

		removeLoadingWs();
		
		
		
		
	}


	
	function basMadd(){
		$("#bas_mm option").remove();
				$("#bas_mm").append("<option value=''>선택</option>");
 				<%
				for(int i=0;i<vLst.size();i++){
					HashMap hMap = (HashMap)vLst.get(i);							
				%>
					if($("#bas_yy option:selected").val()=="<%=(String)hMap.get("bas_ym").toString().substring(0, 4)%>"){
						var bas_mm = "<%=(String)hMap.get("bas_ym").toString().substring(4, 6)%>"
						$("#bas_mm").append("<option value='"+bas_mm+"'>"+bas_mm+"</option>")
						}
				<%
				}
				%>
	}
	
	
	function onChange(sAction) {
		var vLst = mySheet.GetSelectRow();
		if(vLst < 0) return;
		
		mySheet.SetCellValue(vLst,sAction,$("#"+sAction+"").val());
		
	}

	function calOvs() {


		var tot_kri = (parseInt($("#kri_red_cnt").val())+parseInt($("#kri_yellow_cnt").val())+parseInt($("#kri_green_cnt").val()));
		$("#tot_kri").val(tot_kri)
		
		var bef_tot_kri = (parseInt($("#bef_kri_red_cnt").val())+parseInt($("#bef_kri_yellow_cnt").val())+parseInt($("#bef_kri_green_cnt").val()));
		$("#bef_tot_kri").val(bef_tot_kri)
	
		var conKriRed = (parseInt($("#kri_red_cnt").val())-parseInt($("#bef_kri_red_cnt").val()));
		$("#conKriRed").val(conKriRed)
	
		var conKriYel = (parseInt($("#kri_yellow_cnt").val())-parseInt($("#bef_kri_yellow_cnt").val()));
		$("#conKriYel").val(conKriYel)
	
		var conKriGre = (parseInt($("#kri_green_cnt").val())-parseInt($("#bef_kri_green_cnt").val()));
		$("#conKriGre").val(conKriGre)
	
		var cont_kri = (parseInt($("#tot_kri").val())-parseInt($("#bef_tot_kri").val()));
		$("#cont_kri").val(cont_kri)
	
	
		var conLssOcc = (parseInt($("#lss_occ_cnt").val())-parseInt($("#bef_lss_occ_cnt").val()));
		$("#conLssOcc").val(conLssOcc)
		
	
		var conLssAm = (parseInt($("#lss_occ_am").val())-parseInt($("#bef_lss_occ_am").val()));
		$("#conLssAm").val(conLssAm)
		
	
		var conRcsaPrss = (parseInt($("#rcsa_prss_cnt").val())-parseInt($("#bef_rcsa_prss_cnt").val()));
		$("#conRcsaPrss").val(conRcsaPrss)
		
	
		var conRcsaRkp = (parseInt($("#rcsa_rkp_cnt").val())-parseInt($("#bef_rcsa_rkp_cnt").val()));
		$("#conRcsaRkp").val(conRcsaRkp)

		var conRcsaEvl = (parseInt($("#rcsa_evl_cnt").val())-parseInt($("#bef_rcsa_evl_cnt").val()));
		$("#conRcsaEvl").val(conRcsaEvl)
		
	}
	

	function EnterkeySubmit(){
		if(event.keyCode == 13){
			doAction('filter');
			return true;
		}else{
			return true;
		}
	}
	
	
	function Bas_ym_select(){
		$("#bas_mm").remove();
		
	}
	
	function save(){
		
		var f = document.ormsForm;

		if(!confirm("저장하시겠습니까?")) return
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "ovs");
		WP.setParameter("process_id", "ORVS010204");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function(result){
					if(result!='undefined' && result.rtnCode=="S") {
						alert("저장 하였습니다.");
						$(".btn-close").click();
						parent.doAction("search"); //부모창 재조회
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
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
			
	<article class="popup modal block">
		<div class="p_frame w1000">
		
			<div class="p_head">
				<h2 class="title">해외법인 운영리스크 월보고</h2>
			</div>
			<div class="p_body">
				
				<div class="p_wrap">
					<form name="ormsForm" method="post">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					<input type="hidden" id="bas_ym" name="bas_ym" /> <!-- 평가회차 -->
					<input type="hidden" id="gubun" name="gubun" value=""/> <!-- 구분자 -->
					<input type="hidden" id="mode" name="mode" value="<%=link_mode%>"/> <!-- I/U -->
					<input type="hidden" id="dcz_dc" name="dcz_dc" value="13" /> <!-- 결재구분코드 -->
<!--보고년도/보고서명 시작 -->	
						<section class="box box-grid">
							<div class="wrap-table">
								
								<table>
									<colgroup>
										<col style="width: 120px">
										<col style="width: 210px;">
										<col style="width: 120px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>보고년월</th>		
											<td class="form-inline">					
												<select name="bas_yy" id="bas_yy" class="form-control w100">
													<option value="">선택</option>	
									<%

							for(int i=0;i<vLst.size();i++){
								HashMap hMap = (HashMap)vLst.get(i);
								if(!bas_yy.equals((String)hMap.get("bas_ym").toString().substring(0, 4)))
										{
								 		bas_yy = (String)hMap.get("bas_ym").toString().substring(0, 4);
								 																
									%>
													<option value="<%=bas_yy%>"><%=bas_yy%></option>
									<%
										}
									}
									%>											
												</select>
												<select name="bas_mm" id="bas_mm" class="form-control w100" onchange="DoSearch()" >
													<option value="">선택</option>
												</select>
											</td>
									
											<th>보고서명</th>
											<td><input type="text" class="form-control w400" name="rpt_tit" id="rpt_tit" value="<%=OvrsRptTit%>"></td>										</tr>
									</tbody>
								</table>
								
							
							</div>
						</section>
<!--보고년도/보고서명 끝 -->								
				
				
				
							
							
<!-- 1.현지규제준수현황 시작 -->								
						<section class="box box-grid">
							<div class="box-header">
								<h2 class='box-title'>1. 현지 규제 준수 현황</h2>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 120px;">
										<col>
									</colgroup>
									<thead>
										<tr>
										 	<th>구분</th>
											<th>최소자본금</th>
											<th>자기자본비율</th>
											<th>이자율상한</th>
											<th>1인당대출한도</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>점검결과</th>
											<td><input type="text" class="form-control" name="rslt_mnm_cpt_amt" id="rslt_mnm_cpt_amt"></td>
											<td><input type="text" class="form-control" name="rslt_slf_cpt_rt" id="rslt_slf_cpt_rt"></td>
											<td>
												<span class="select">																	
												<select class="form-control w80" name="rslt_irrt_hglm" id="rslt_irrt_hglm" >
														<option value="Y">Y</option>
														<option value="N">N</option>
												</select>
												</span>
											</td>
											<td>
												<select class="form-control w80" name="rslt_ln_lmt" id="rslt_ln_lmt">
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
											</td>
										</tr>
										<tr>
											<th>규제기준</th>	
											<td><input type="text" class="form-control" name="rglt_mnm_cpt_amt" id="rglt_mnm_cpt_amt" value="<%=rglt_mnm_cpt_amt%>"></td>
											<td><input type="text" class="form-control" name="rglt_slf_cpt_rt" id="rglt_slf_cpt_rt" value="<%=rglt_slf_cpt_rt%>"></td>
											<td><input type="text" class="form-control" name="rglt_irrt_hglm" id="rglt_irrt_hglm" value="<%=rglt_irrt_hglm%>"></td>
											<td><input type="text" class="form-control" name="rglt_ln_lmt_amt" id="rglt_ln_lmt_amt" value="<%=rglt_ln_lmt_amt%>"></td>
										</tr>
									</tbody> 	
																				
								</table>
							</div>
						</section>
<!-- 1.현지규제준수현황 끝 -->
<!-- 2.손실사건 시작 -->						
						<section class="box box-grid" style="width: 533px;">
							<div class="box-header">
								<h2 class='box-title'>2. 손실사건</h2>
								<div class="area-tool">
									<span>(단위: 건, 원)</span>
								</div>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 120px;">
										<col>
									</colgroup>
									<thead>
										<tr>
											<th scope="col">구분</th>
											<th scope="col">발생 건수</th>
											<th scope="col">발생 금액</th>
										</tr>
									</thead>
									<tbody class="right">
										<tr>
											<th>당월</th>
											<td><input type="number" class="form-control right" name="lss_occ_cnt" id="lss_occ_cnt" onchange="calOvs()"></td>
											<td><input type="number" class="form-control right" name="lss_occ_am" id="lss_occ_am" onchange="calOvs()"></td>
										</tr>
										
										<tr>
											<th>전월</th>
											<td><input type="number" class="form-control right" name="bef_lss_occ_cnt" id="bef_lss_occ_cnt" disabled/></td>
											<td><input type="number" class="form-control right" name="bef_lss_occ_am" id="bef_lss_occ_am" disabled/></td>
										</tr>
										
										<tr>
											<th>전월대비</th>
											<td><input type="number" class="form-control right" name="conLssOcc" id="conLssOcc" value="" disabled/></td>
											<td><input type="number" class="form-control right" name="tot_kri" id="conLssAm" value="" disabled/></td>
										</tr>
									
									</tbody> 	
													
								</table>
							</div>
							<div class="wrap-footnote">
								<ul class="ul dash">
									<li>상세내역은 별첨 “Loss Event Registry” 시트 참고</li>
								</ul>
							</div>
						</section>
<!-- 2.손실사건 끝 -->		
<!-- 3.RCSA수행결과 시작 -->							
							<section class="box box-grid" style="width: 740px;">
								<div class="box-header">
									<h2 class='box-title'>3. RCSA 수행 결과</h2>
									<div class="area-tool">
										<span>(단위: 건)</span>
									</div>
								</div>
								<div class="wrap-table">
									<table>
										<colgroup>
											<col style="width: 120px;">
											<col>
										</colgroup>
										<thead>
											<tr>
												<th scope="col">구분</th>
												<th scope="col">전체 프로세스 수</th>
												<th scope="col">전체 RCSA 수</th>
												<th scope="col">평가 건수</th>
											</tr>
										</thead>
										<tbody class="right">
											<tr>
												<th>당분기</th>
												<td><input type="number" class="form-control right" name="rcsa_prss_cnt" id="rcsa_prss_cnt" onchange="calOvs()"></td>
												<td><input type="number" class="form-control right" name="rcsa_rkp_cnt" id="rcsa_rkp_cnt" onchange="calOvs()"></td>
												<td><input type="number" class="form-control right" name="rcsa_evl_cnt" id="rcsa_evl_cnt" onchange="calOvs()"></td>
											
											</tr>
											
											<tr>
												<th>전분기</th>
												<td><input type="number" class="form-control right" name="bef_rcsa_prss_cnt" id="bef_rcsa_prss_cnt" disabled/></td>
												<td><input type="number" class="form-control " name="bef_rcsa_rkp_cnt" id="bef_rcsa_rkp_cnt" disabled/></td>
												<td><input type="number" class="form-control right" name="bef_rcsa_evl_cnt" id="bef_rcsa_evl_cnt" disabled/></td>
												
											</tr>
											
											<tr>
												<th>전분기대비</th>
												<td><input type="number" class="form-control right" name="conRcsaPrss" id="conRcsaPrss" value="" disabled/></td>
												<td><input type="number" class="form-control right" name="conRcsaRkp" id="conRcsaRkp" value="" disabled/></td>
												<td><input type="number" class="form-control right" name="conRcsaEvl" id="conRcsaEvl" value="" disabled/></td>
												
											</tr>
										
										</tbody> 	
														
									</table>
								</div>
									
							</section>
<!-- 3.RCSA수행결과 끝 -->






<!-- 4.KRI발생건수 시작 -->	
						<section class="box box-grid">
							<div class="box-header">
								<h2 class='box-title'>4. KRI 발생 건수</h2>
								<div class="area-tool">
									<span>(단위: 건)</span>
								</div>
							</div>			
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 120px;">
										<col>
									</colgroup>
									<thead>
										<tr>
											<th scope="col" rowspan="2">구분</th>
											<th scope="col" rowspan="2">당월 발생 건수</th>
											<th scope="col" colspan="3"></th>
										</tr>
										<tr>
											<th scope="col" class="tb-grade-red">RED</th>
											<th scope="col" class="tb-grade-yellow">YELLOW</th>
											<th scope="col" class="tb-grade-green">GREEN</th>
										</tr>
									</thead>
									<tbody class="right">
										<tr>
											<th>당분기</th>
											<td><input type="number" class="form-control right" name="tot_kri" id="tot_kri" value="" disabled/></td>
											<td><input type="number" class="form-control right" name="kri_red_cnt" id="kri_red_cnt" onchange="calOvs()"></td>
											<td><input type="number" class="form-control right" name="kri_yellow_cnt" id="kri_yellow_cnt" onchange="calOvs()" ></td>
											<td><input type="number" class="form-control right" name="kri_green_cnt" id="kri_green_cnt" onchange="calOvs()"></td>
										</tr>
										
										<tr>
											<th>전분기</th>
											<td><input type="number" class="form-control" name="bef_tot_kri" id="bef_tot_kri" value="" disabled/></td>
											<td><input type="number" class="form-control right" name="bef_kri_red_cnt" id="bef_kri_red_cnt" disabled/></td>
											<td><input type="number" class="form-control right" name="bef_kri_yellow_cnt" id="bef_kri_yellow_cnt" disabled/></td>
											<td><input type="number" class="form-control " name="bef_kri_green_cnt" id="bef_kri_green_cnt" disabled/></td>
										</tr>
										
										<tr>
											<th>전분기대비</th>
											<td><input type="number" class="form-control right" name="cont_kri" id="cont_kri"  disabled/></td>															
											<td><input type="number" class="form-control right" name="conKriRed" id="conKriRed" disabled/></td>
											<td><input type="number" class="form-control right" name="conKriYel" id="conKriYel" disabled/></td>
											<td><input type="number" class="form-control right" name="conKriGre" id="conKriGre" disabled/></td>
											
										</tr>
									</tbody> 	
								</table>
							</div>
							<div class="wrap-footnote">
								<ul class="ul dash">
									<li>상세내역은 별첨 “KRI Assessment” 시트 참고</li>
								</ul>
							</div>
						</section>
<!-- 4.KRI발생건수 끝 -->							

	
		

<!-- 5.BCP 시작 -->			
						<section class="box box-grid">
							<div class="box-header">
								<h2 class='box-title'>5. BCP</h2>
							</div>
							<div class="box-body">
								<textarea name="bcp_cntn" id="bcp_cntn" class="form-control" maxlength="660" placeholder="BCP 관련 내용 기재 (해당사항 있을 시)"></textarea>
							</div>
						</section>		
<!-- 5.BCP 끝 -->




<!-- 6.시나리오 시작 -->		
						<section class="box box-grid">
							<div class="box-header">
								<h2 class='box-title'>6. 기타사항/시나리오</h2>
							</div>
							<div class="box-body">
								<textarea name="snr_cntn" id="snr_cntn" class="form-control" maxlength="660" placeholder="내외부 운영리스크 관련 금융사고 및 감독기관 제재 발생 시 또는 시나리오 관리 사항 기재"></textarea>
							</div>
						</section>						
<!-- 6.시나리오 끝 -->		
				
				
				
<!-- ※ 파일첨부 -->
						<section class="box box-grid">
							<div class="box-header">
								<h2 class='box-title'>※ 파일첨부</h2>
								<div class="area-tool">
									<div class="btn-group">
										<button type="button" class="btn btn-default btn-xs"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
										<button type="button" class="btn btn-default btn-xs"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
									</div>
								</div>
							</div>
							<div class="ibupload-wrap">
								<div id="myUpload"></div>
							</div>
						</section>
<!-- ※ 파일첨부 //-->
			
					</form>
				</div>
			</div>

			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="save();">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>

			<button type="button" class="btn btn-default btn-xs btn-fix" onclick=""><i class="fa fa-print"></i><span class="txt">Print</span></button>	
			<button class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</article>
			
	
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->

	<script>
	$(document).ready(function(){
		
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			parent.$("#ifrORVS0101").attr("src","about:blank");
			event.preventDefault();
		});
		
	});
		
	function closePop(){
		$("#winNewAccAdd",parent.document).hide();
	}
	</script>
</body>
</html>