<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0110.jsp
 Program name : 리스크 자가진단
 Description  : 화면정의서 RCSA-08.2
 Programer    : 박승윤
 Date created : 2022.08.24
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
<%@ include file="../comm/library.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");
DynaForm form = (DynaForm)request.getAttribute("form");
Vector vBrc= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vBrc==null) vBrc = new Vector();
Vector vPrss= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vPrss==null) vPrss = new Vector();


%>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RCSA - 리스크 자가 진단</title>

	<script language="javascript">

	$(document).ready(function(){
		//$("#winRskMod",parent.document).addClass("block");
		// ibsheet 초기화
		initIBSheet1();
		initIBSheet2();
		parent.removeLoadingWs();
		
		$("input[name='evl_ifn_a']").change(function(){
			var evl_ifn = $("input[name='evl_ifn_a']:checked").val();
			$("#ifn_evl_c").val(evl_ifn);
			if($("input[name='evl_ifn_b']:checked").val()<=evl_ifn){$("#evl_ifn").val(evl_ifn)}
			else($("#evl_ifn").val($("input[name='evl_ifn_b']:checked").val()));
			GetRskEvlGrdc($("#evl_ifn").val(),$("#evl_frq").val());
		})
		$("input[name='evl_ifn_b']").change(function(){
			var evl_ifn = $("input[name='evl_ifn_b']:checked").val();
			$("#nifn_evl_c").val(evl_ifn);
			if($("input[name='evl_ifn_a']:checked").val()<=evl_ifn){$("#evl_ifn").val(evl_ifn)}
			else($("#evl_ifn").val($("input[name='evl_ifn_a']:checked").val()));
			GetRskEvlGrdc($("#evl_ifn").val(),$("#evl_frq").val());
		})
		$("input[name='evl_frq']").change(function(){
			var evl_frq = $("input[name='evl_frq']:checked").val();
			$("#evl_frq").val(evl_frq);
			GetRskEvlGrdc($("#evl_ifn").val(),$("#evl_frq").val());
		})
		$("input[name='evl_ctl-a']").change(function(){
			var evl_ctl = $("input[name='evl_ctl-a']:checked").val();
			$("#ctl_dsg_evl_c").val(evl_ctl);
			if($("input[name='evl_ctl-b']:checked").val()<=evl_ctl){$("#ctev_grd_c").val(evl_ctl)}
			else($("#ctev_grd_c").val($("input[name='evl_ctl-b']:checked").val()));
			CtlOperEvlSel($("#ctev_grd_c").val());
		})
		$("input[name='evl_ctl-b']").change(function(){
			var evl_ctl = $("input[name='evl_ctl-b']:checked").val();
			$("#ctl_mngm_evl_c").val(evl_ctl);
			if($("input[name='evl_ctl-a']:checked").val()<=evl_ctl){$("#ctev_grd_c").val(evl_ctl)}
			else($("#ctev_grd_c").val($("input[name='evl_ctl-a']:checked").val()));
			CtlOperEvlSel($("#ctev_grd_c").val());
		})
		
		doAction('search');
		getGrdMatrix();
	});


		
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			
			//시트 초기화
			mySheet1.Reset();
			
			var initData = {};
			

			initData.Cfg = {FrozenCol:0,Sort:1,MergeSheet:msBaseColumnMerge + msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",ScrollOverSheet:1,SizeMode:1 }; 
			initData.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
			initData.Cols = [
				{Header:"구분|등급"				,Type:"Text"	,Width:20	,Align:"Center"	,SaveName:"rk_grd_sqno"	   ,Edit:false			},
				{Header:"구분|수준"				,Type:"Text"	,Width:50	,Align:"Center"	,SaveName:"rk_grd_nm" 	   ,Edit:false			},
				{Header:"재무적평가|금액구간"		,Type:"Text"	,Width:50	,Align:"Center"	,SaveName:"am_range"	   ,Edit:false },
				{Header:"비재무적평가|내용"		,Type:"Text"	,Width:20	,Align:"Center"	,SaveName:"code_cntn"	   ,Edit:false , ColMerge:1  },
				{Header:"비재무적평가|내용"		,Type:"Text"	,Width:100	,Align:"Center"	,SaveName:"nfna_cntn"	   ,Edit:false , ColMerge:1 , Wrap:1  },
				{Header:"비재무적평가|중단 영향"		,Type:"Text"	,Width:50	,Align:"Center"	,SaveName:"nfna_ibi_cntn"  ,Edit:false   },
				{Header:"PARTITION_ROW"		,Type:"Text"	,Width:100	,Align:"Center"	,SaveName:"partition_row"  , Hidden:true	}
			];

			
			IBS_InitSheet(mySheet1,initData);
			
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(0);
			
			mySheet1.FitColWidth();
			
		}
		
		/*Sheet 기본 설정 */
		function initIBSheet2() {
			
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};
			

			initData.Cfg = {FrozenCol:0,Sort:1,MergeSheet:msBaseColumnMerge + msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",ScrollOverSheet:1,SizeMode:1 }; 
			initData.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
			initData.Cols = [
				{Header:"등급"				,Type:"Text"	,Width:20	,Align:"Center"	,SaveName:"frq_grdc"	   ,Edit:false },
				{Header:"수준"				,Type:"Text"	,Width:50	,Align:"Center"	,SaveName:"frq_grdnm" 	   ,Edit:false },
				{Header:"손실 발생 예상 빈도"		,Type:"Text"	,Width:50	,Align:"Center"	,SaveName:"avg_frq_cntn"	   ,Edit:false },
				{Header:"연 평균 발생 횟수"			,Type:"Text"	,Width:20	,Align:"Center"	,SaveName:"avg_fqcn"	   ,Edit:false }
			];

			
			IBS_InitSheet(mySheet2,initData);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(0);
			
			mySheet2.FitColWidth();
			
		}
		

		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/*Sheet 각종 처리*/
		function doAction(sAction) {

			switch(sAction) {
				case "search":		//조회
					DoSearch();
					DoSearch1(); //위험등급기준 조회
					DoSearch2(); //손실및kri조회
					break;
				case "save":		//저장
					$("#evl_cpl_yn").val("Y");
					save();
					break;
				case "temp":		//임시저장
					$("#evl_cpl_yn").val("N");
					save();
					break; 
			}
		}

		var ctl_cnt = 0;
		
		function DoSearch() {
			
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC011002");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

					  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;                                    
					$("#ifn_evl_c").val(rList[0].ifn_evl_c);
					$("#nifn_evl_c").val(rList[0].nifn_evl_c);
					$("#evl_frq").val(rList[0].evl_frq);
					$("#evl_ifn").val(rList[0].evl_ifn);
					$("#rk_evl_grd_c").val(rList[0].rk_evl_grd_c);
					$("#ctl_dsg_evl_c").val(rList[0].ctl_dsg_evl_c);
					$("#ctl_mngm_evl_c").val(rList[0].ctl_mngm_evl_c);
					$("#ctev_grd_c").val(rList[0].ctev_grd_c);
					$("#rmn_rsk_grd_c").val(rList[0].rmn_rsk_grd_c);
					$("#rk_isc_cntn").text(rList[0].rk_isc_cntn);
					$("#rk_cp_cntn").text(rList[0].rk_cp_cntn);
					$("#link_rk_isc_cntn").val(rList[0].rk_isc_cntn);
					GetRskEvlGrdc($("#evl_ifn").val(),$("#evl_frq").val());
					CtlOperEvlSel($("#ctev_grd_c").val());
					$('#evl_ifn_a-'+rList[0].ifn_evl_c).prop('checked',true);
					$('#evl_ifn_b-'+rList[0].nifn_evl_c).prop('checked',true);
					$('#evl_frq-'+rList[0].evl_frq).prop('checked',true);
					$('#evl_ctl-a-'+rList[0].ctl_dsg_evl_c).prop('checked',true);
					$('#evl_ctl-b-'+rList[0].ctl_mngm_evl_c).prop('checked',true);
					if($('#rk_evl_dcz_stsc').val() >=03 || $('#rcsa_menu_dsc').val() !='1'){
						$("#saveBtn").attr("disabled",true);
						$("#tmpBtn").attr("disabled",true);
						$('input[name="evl_ctl-a"]').each(function(){
							$(this).prop('disabled',true);
						});
						$('input[name="evl_ctl-b"]').each(function(){
							$(this).prop('disabled',true);
						});
						$('input[name="evl_ifn_b"]').each(function(){
							$(this).prop('disabled',true);
						});
						$('input[name="evl_ifn_a"]').each(function(){
							$(this).prop('disabled',true);
						});
						$('input[name="evl_frq"]').each(function(){
							$(this).prop('disabled',true);
						});
						$(".evl_ctl-a").attr("disabled",true);
						$(".evl_ctl-b").attr("disabled",true);
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
		
		function DoSearch2() {
			
			var f = document.ormsForm;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC011005");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화
			
			
			WP.load(url, inputData,{
				success: function(result){

					  
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
					  var rList = result.DATA;                                    
					$("#rel_lshp").text(rList[0].lss_cnt);
					$("#rel_kri").text(rList[0].kri_cnt);
					
					
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
		
		function save(){
			
			var f = document.ormsForm;
		
			
			if( f.brc.value == ''){
				alert("프로그램 오류발생!! 창을 닫고 평가를 다시 진행하시기 바랍니다.");
				return;
			}
			
			if( f.rkp_id.value == ''){
				alert("프로그램 오류발생!! 창을 닫고 평가를 다시 진행하시기 바랍니다.");
				return;
			}			
			
			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC011007");

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
							
							if($("#evl_cpl_yn").val()=="Y"){
								$(".btn-close").trigger("click");
							}
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
		


		//리스크평가등급산정(영향평가코드(재무/비재무),빈도평가코드) 수협은행
		function GetRskEvlGrdc(ifn_evl_c,frq_evl_c){
			
			var RskEvlGrdc;

			if( frq_evl_c == "1" ){
				
				if( ifn_evl_c == "5"|| ifn_evl_c == "4" ){
					RskEvlGrdc = "2"; //yellow
				}
				else {
					RskEvlGrdc = "1"; //green
				}
			}
			else if( frq_evl_c == "2" ){
				
				if( ifn_evl_c == "5"|| ifn_evl_c == "4"|| ifn_evl_c == "3" ){
					RskEvlGrdc = "2"; //yellow
				}
				else {
					RskEvlGrdc = "1"; //green
				}
			}
			else if( frq_evl_c == "3" ){
				
				if( ifn_evl_c == "5"|| ifn_evl_c == "4" ){
					RskEvlGrdc = "3"; //RED
				}
				else if( ifn_evl_c == "3"|| ifn_evl_c == "2" ) {
					RskEvlGrdc = "2"; //YELLOW
				}
				else {
					RskEvlGrdc = "1"; //GREEN
				}
			}
			else if( frq_evl_c == "4" ){
				
				if( ifn_evl_c == "5"|| ifn_evl_c == "4" ){
					RskEvlGrdc = "3"; //RED
				}
				else if( ifn_evl_c == "3"|| ifn_evl_c == "2" ) {
					RskEvlGrdc = "2"; //YELLOW
				}
				else {
					RskEvlGrdc = "1"; //GREEN
				}
			}
			else if( frq_evl_c == "5" ){
				
				if( ifn_evl_c == "5"|| ifn_evl_c == "4"|| ifn_evl_c == "3" ){
					RskEvlGrdc = "3"; //RED
				}
				else {
					RskEvlGrdc = "2"; //YELLOW
				}
			}
			else{
				RskEvlGrdc = "0"; //white
			}
			
			$("#rk_evl_grd_c").val(RskEvlGrdc);
			
			if(RskEvlGrdc == "0"){
				$("#RskEvlGrdc").attr("class","white");
				$("#RskEvlGrdc").text("WHITE");
				$("#rk_evl_grd_c").val("0");
			}
			else if(RskEvlGrdc == "1"){
				$("#RskEvlGrdc").attr("class","green");
				$("#RskEvlGrdc").text("GREEN");
				$("#rk_evl_grd_c").val("1");
			}
			else if(RskEvlGrdc == "2"){
				$("#RskEvlGrdc").attr("class","yellow");
				$("#RskEvlGrdc").text("YELLOW");
				$("#rk_evl_grd_c").val("2");
			}
			else if(RskEvlGrdc == "3"){
				$("#RskEvlGrdc").attr("class","red");
				$("#RskEvlGrdc").text("RED");
				$("#rk_evl_grd_c").val("3");
			}
			RmnRskGrdc($("#rk_evl_grd_c").val(),$("#ctev_grd_c").val());
			return RskEvlGrdc;
		}
		
		//통제평가등급선택:상/중/하 중 제일 낮은등급으로 측정 (수협은행)
		function CtlOperEvlSel(CtelEvlGrdc){

			if(CtelEvlGrdc == "1"){
				$("#CtlEvlGrdc").attr("class","green");
				$("#CtlEvlGrdc").text("상");
			}
			else if(CtelEvlGrdc == "2"){
				$("#CtlEvlGrdc").attr("class","yellow");
				$("#CtlEvlGrdc").text("중");
			}
			else if(CtelEvlGrdc == "3"){
				$("#CtlEvlGrdc").attr("class","red");
				$("#CtlEvlGrdc").text("하");
			}
			RmnRskGrdc($("#rk_evl_grd_c").val(),$("#ctev_grd_c").val());
			return CtelEvlGrdc;
		}
		
		//잔여위험등급계산
		function RmnRskGrdc(RskEvlGrdc,CtelEvlGrdc){
			var rmn_rsk_grd_c = parseInt(RskEvlGrdc) * parseInt(CtelEvlGrdc);
			if(rmn_rsk_grd_c <= 3){
				$("#RmnRskGrdc").attr("class","green");
				$("#RmnRskGrdc").text("GREEN");
				$("#rmn_rsk_grd_c").val(1);
				$("#rmnNum").text(rmn_rsk_grd_c);
				$("#ctlNum").text(CtelEvlGrdc);
				$("#rskNum").text(RskEvlGrdc);
			}
			else if(rmn_rsk_grd_c <= 6){
				$("#RmnRskGrdc").attr("class","yellow");
				$("#RmnRskGrdc").text("YELLOW");
				$("#rmn_rsk_grd_c").val(2);
				$("#rmnNum").text(rmn_rsk_grd_c);
				$("#ctlNum").text(CtelEvlGrdc);
				$("#rskNum").text(RskEvlGrdc);
			}
			else if(rmn_rsk_grd_c <= 9){
				$("#RmnRskGrdc").attr("class","red");
				$("#RmnRskGrdc").text("RED");
				$("#rmn_rsk_grd_c").val(3);
				$("#rmnNum").text(rmn_rsk_grd_c);
				$("#ctlNum").text(CtelEvlGrdc);
				$("#rskNum").text(RskEvlGrdc);
			}
			return rmn_rsk_grd_c;
		}
		
		
		function DoSearch1() {
			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("rsa");
			$("form[name=ormsForm] [name=process_id]").val("ORRC011003");
			mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("rsa");
			$("form[name=ormsForm] [name=process_id]").val("ORRC011004");
			mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		}
		
		
 		function mySheet2_OnSearchEnd(code, message) {
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}

			
			for(var i=mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
				mySheet2.SetCellValue(i,"avg_fqcn",zeroPadding(mySheet2.GetCellValue(i,"avg_fqcn"))+"");
			}
		} 
		
		function ToRelRki(num){
		  if(num==1){
		  		$("#ifrRelLss").attr("src","about:blank");
				$("#winRelLss").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(RelLss,1);
		  }else if(num==2){
		  		$("#ifrRelKri").attr("src","about:blank");
				$("#winRelKri").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(RelKri,1);
		  }
		}
		
		function RelLss(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="rsa";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORRC011101";
			f.target = "ifrRelLss";
			f.submit();
		}
		
		function RelKri(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="rsa";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORRC011201";
			f.target = "ifrRelKri";
			f.submit();
		}
		
		function getGrdMatrix(){
			var f = document.ormsForm;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC011006");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			showLoadingWs(); // 프로그래스바 활성화

			WP.load(url, inputData,{
				success: function(result){
					
												
				  if(result!='undefined' && result.rtnCode=="0") 
				  {
						var rList = result.DATA;
						var html="";

						html += "<table>";
						html += "<colgroup>";
						html += "<col />";
						html += "<col />";
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

						$("#matrix").html(html);
	
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
	
		function closeRskGrd(){
			$("#winRskMat").hide();
			$("#winRskSel").hide();
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
		
	</script>
</head>
<body>
	
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w1500">	
			<div class="p_head">
				<h1 class="title">리스크 자가 진단</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				  <form name="ormsForm" method="post">
				  	<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
				  	<input type="hidden" id="rkp_id" name="rkp_id" value="<%=form.get("link_rkp_id")%>" />
				  	<input type="hidden" id="bas_ym" name="bas_ym" value="<%=form.get("link_bas_ym")%>" />
				  	<input type="hidden" id="rcsa_menu_dsc" name="rcsa_menu_dsc" value="<%=form.get("rcsa_menu_dsc")%>" />
				  	<input type="hidden" id="brc" name="brc" value="<%=form.get("link_brc")%>" />
				  	<input type="hidden" id="rk_evl_dcz_stsc" name="rk_evl_dcz_stsc" value="<%=form.get("link_rk_evl_dcz_stsc")%>" />
				  	<input type="hidden" id="evl_ifn" name="evl_ifn" value="" /> <!-- 영향평가계산용 -->
				  	<input type="hidden" id="evl_frq" name="evl_frq" value="" /> <!-- 빈도평가계산용 -->
				  	<input type="hidden" id="ifn_evl_c" name="ifn_evl_c" value="" /> <!-- 영향평가코드(재무) -->
				  	<input type="hidden" id="nifn_evl_c" name="nifn_evl_c" value="" /> <!-- 영향평가코드(비재무) -->
				  	<input type="hidden" id="frq_evl_c" name="frq_evl_c" value="" /> <!-- 빈도평가코드 -->
				  	<input type="hidden" id="rk_evl_grd_c" name="rk_evl_grd_c" value="" /> <!-- 리스크평가등급코드 -->
				  	<input type="hidden" id="ctl_dsg_evl_c" name="ctl_dsg_evl_c" value="" /> <!-- 통제설계평가코드 -->
				  	<input type="hidden" id="ctl_mngm_evl_c" name="ctl_mngm_evl_c" value="" /> <!-- 통제운영평가코드 -->
				  	<input type="hidden" id="ctev_grd_c" name="ctev_grd_c" value="" /> <!-- 통제평가등급코드 -->
				  	<input type="hidden" id="rmn_rsk_grd_c" name="rmn_rsk_grd_c" value="" /> <!-- 잔여위험등급코드 -->
				  	<input type="hidden" id="evl_cpl_yn" name="evl_cpl_yn" value="" /> <!-- 평가완료여부 -->
				  	<input type="hidden" id="link_rk_isc_cntn" name="link_rk_isc_cntn" value="" /> <!-- 팝업용 리스크 사례 -->

					<section class="box box-grid">
						<div class="wrap-table">
							<table>					
								<colgroup>
									<col style="width: 120px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">평가 조직</th>
										<td>
											<ul class="dep-list" id="dep-list">
											<%
											for(int i=0;i<vBrc.size();i++){
												HashMap hMap = (HashMap)vBrc.get(i);
											%>
												<li><%=(String)hMap.get("brnm")%></li>
												 
											<%
													}
											%>
											</ul>
										</td>
									</tr>
									<tr>
										<th scope="row">업무 프로세스</th>
										<td>
											<ul class="dep-list">
											<%
											for(int i=0;i<vPrss.size();i++){
												HashMap hMap = (HashMap)vPrss.get(i);
											%>
												<li><%=(String)hMap.get("bsn_prsnm")%></li>
												 
											<%
													}
											%>
											</ul>
										</td>
									</tr>
								</tbody>
							</table>
							<table>
								<thead>
									<th scope="col">리스크 사례</th>
								</thead>
								<tbody>
									<tr>
										<td id="rk_isc_cntn">											
										</td>
									</tr>
								</tbody>
							</table>
							<table>
								<thead>
									<tr>
										<th scope="col">최근 손실사건 (3개년)</th>
										<th scope="col">관련 KRI 지표 (1개년)</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td>
											<strong id="rel_lshp"></strong>건
											<div class="td-btn-wrap">
												<button type="button" class="btn btn-more" onclick="ToRelRki(1)"><span class="txt">상세조회</span></button>
											</div>
										</td>
										<td>
											<strong id="rel_kri"></strong>건
											<div class="td-btn-wrap">
												<button type="button" class="btn btn-more" onclick="ToRelRki(2)"><span class="txt">상세조회</span></button>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>

					<!-- 위험평가 -->
					<div class="box rcsa-wrap">
						<div class="box-header">
							<h2 class="box-title">위험평가</h2>
						</div>
						<article class="row">
							<div class="col">
								<div class="box-header">
									<h3 class="title">[위험등급기준]</h3>
								</div>
								<section class="box-grid">
									<h4 class="evl-title">영향</h4>
									<div class="wrap-table" id="mydiv1">
									<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
<!-- 										<table>
											<colgroup>
												<col style="width: 60px;">
												<col style="width: 80px;">
												<col style="width: 120px;">
												<col>
												<col style="width: 130px;">
											</colgroup>
											<thead>
												<tr>
													<th scope="col" colspan="2">구분</th>
													<th scope="col">재무적 평가</th>
													<th scope="col" colspan="2">비재무적 평가</th>
												</tr>
												<tr>
													<th scope="col" class="w60">등급</th>
													<th scope="col" class="w80">수준</th>
													<th scope="col">금액 구간</th>
													<th scope="col">내용</th>
													<th scope="col" class="w140">중단 영향</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr>
													<th scope="row">1</th>
													<td>매우 낮음</td>
													<td>2,500만원 미만</td>
													<td class="left">[고객] ...,<br>[직급] ...</td>
													<td>30분 이내 지연</td>
												</tr>
												<tr>
													<th scope="row">2</th>
													<td>낮음</td>
													<td>2,500만원 이상 <br>~ 3억원 미만</td>
													<td class="left">[고객] ...,<br>[직급] ...</td>
													<td>3시간 이내 지연</td>
												</tr>
												<tr>
													<th scope="row">3</th>
													<td>보통</td>
													<td>3억원 이상 <br>~ 10억원 미만</td>
													<td class="left">[고객] ...,<br>[직급] ...</td>
													<td>1일 이내 지연</td>
												</tr>
												<tr>
													<th scope="row">4</th>
													<td>높음</td>
													<td>10억원 이상 <br>~ 300억원 미만</td>
													<td class="left">[고객] ...,<br>[직급] ...</td>
													<td>3일간 중단<br>(사내분규 발생)</td>
												</tr>
												<tr>
													<th scope="row">5</th>
													<td>매우 높음</td>
													<td>300억원 미만</td>
													<td class="left">[고객] ...,<br>[직급] ...</td>
													<td>1주일 중단<br>(사내분규 발생)</td>
												</tr>
											</tbody>
										</table>
 -->									</div>
								</section>
								<section class="box box-grid">
									<h4 class="evl-title">빈도</h4>
									<div class="wrap-table" id="mydiv2">
 									<script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script>
										<!-- <table>
											<thead>
												<tr>
													<th scope="col" class="w60">등급</th>
													<th scope="col" class="w80">수준</th>
													<th scope="col">손실 발생 예상 빈도</th>
													<th scope="col" class="w130">연 평균 발생 횟수</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr>
													<th scope="row">1</th>
													<td>매우 낮음</td>
													<td>10년에 1회 발생</td>
													<td>0.1회</td>
												</tr>
												<tr>
													<th scope="row">2</th>
													<td>낮음</td>
													<td>5년에 1회 발생</td>
													<td>0.2회</td>
												</tr>
												<tr>
													<th scope="row">3</th>
													<td>보통</td>
													<td>1년에 1회 발생</td>
													<td>1회</td>
												</tr>
												<tr>
													<th scope="row">4</th>
													<td>높음</td>
													<td>1달에 1회 발생</td>
													<td>10회</td>
												</tr>
												<tr>
													<th scope="row">5</th>
													<td>매우 높음</td>
													<td>1주일에 1회 발생</td>
													<td>50회</td>
												</tr>
											</tbody>
										</table> -->
									</div>
								</section>
							</div>
							<div class="col">
								<div class="box-header">
									<h3 class="title">위험 평가</h3>
								</div>
								<section class="rcsa-item">
									<h4 class="evl-title">영향 평가 (재무)</h4>
									<ul class="evl">
										<li>
											<input type="radio" name="evl_ifn_a" id="evl_ifn_a-1" value = '1' checked>
											<label for="evl_ifn_a-1">
												<strong>1등급</strong>
												<p>매우 낮음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ifn_a" id="evl_ifn_a-2" value = '2'>
											<label for="evl_ifn_a-2">
												<strong>2등급</strong>
												<p>낮음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ifn_a" id="evl_ifn_a-3" value = '3'>
											<label for="evl_ifn_a-3">
												<strong>3등급</strong>
												<p>보통</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ifn_a" id="evl_ifn_a-4" value = '4'>
											<label for="evl_ifn_a-4">
												<strong>4등급</strong>
												<p>높음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ifn_a" id="evl_ifn_a-5" value = '5'>
											<label for="evl_ifn_a-5">
												<strong>5등급</strong>
												<p>매우 높음</p>
											</label>
										</li>
									</ul>
								</section>									
								<section class="rcsa-item">
									<h4 class="evl-title">영향 평가 (비재무)</h4>
									<ul class="evl">
										<li>
											<input type="radio" name="evl_ifn_b" id="evl_ifn_b-1" value = '1' checked>
											<label for="evl_ifn_b-1">
												<strong>1등급</strong>
												<p>매우 낮음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ifn_b" id="evl_ifn_b-2" value = '2'>
											<label for="evl_ifn_b-2">
												<strong>2등급</strong>
												<p>낮음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ifn_b" id="evl_ifn_b-3" value = '3'>
											<label for="evl_ifn_b-3">
												<strong>3등급</strong>
												<p>보통</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ifn_b" id="evl_ifn_b-4" value = '4'>
											<label for="evl_ifn_b-4">
												<strong>4등급</strong>
												<p>높음</p>
											</label>
										</li>
										<li class="on">
											<input type="radio" name="evl_ifn_b" id="evl_ifn_b-5" value = '5'>
											<label for="evl_ifn_b-5">
												<strong>5등급</strong>
												<p>매우 높음</p>
											</label>
										</li>
									</ul>
								</section>	
								<section class="rcsa-item">
									<h4 class="evl-title">빈도 평가</h4>
									<ul class="evl">
										<li>
											<input type="radio" name="evl_frq" id="evl_frq-1" value = '1' checked>
											<label for="evl_frq-1">
												<strong>1등급</strong>
												<p>매우 낮음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_frq" id="evl_frq-2" value = '2'>
											<label for="evl_frq-2">
												<strong>2등급</strong>
												<p>낮음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_frq" id="evl_frq-3" value = '3'>
											<label for="evl_frq-3">
												<strong>3등급</strong>
												<p>보통</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_frq" id="evl_frq-4" value = '4'>
											<label for="evl_frq-4">
												<strong>4등급</strong>
												<p>높음</p>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_frq" id="evl_frq-5" value = '5'>
											<label for="evl_frq-5">
												<strong>5등급</strong>
												<p>매우 높음</p>
											</label>
										</li>
									</ul>
								</section>
								<div id = "matrix" class="wrap-table in_bdr th_bg th_c td_r lr_none t1">
									
								</div>										
							</div>
						</article>
						
						<section class="risk-grade-wrap">
							<dl class="risk-grade">
								<dt>위험 등급</dt>
								<dd class="green" id ="RskEvlGrdc">GREEN</dd>
							</dl>
						</section>
					</div>
					<!-- 위험평가 //-->


					<!-- 통제평가 -->
					<div class="box rcsa-wrap">
						<div class="box-header">
							<h2 class="box-title">통제평가</h2>
						</div>
						<div class="wrap-table">
							<table>
								<thead>
									<th scope="col">통제 방안</th>
								</thead>
								<tbody>
									<tr>
										<td id = "rk_cp_cntn">
											고객 정부의 변경 시 변경 요청서를 접수하여 고객의 요청 내용과 전산 투입 내용을 대사하여 처리하고 있음
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<article class="row">
							<div class="col">
								<div class="box-header">
									<h3 class="title">[통제평가기준]</h3>
								</div>
								<section class="box-grid">
									<h4 class="evl-title">설계평가</h4>
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col" class="w80">수준</th>
													<th scope="col">평가 기준</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th scope="row">상</th>
													<td>현재 통제 활동만으로 해당 위험을 통제하기에 충분함</td>
												</tr>
												<tr>
													<th scope="row">중</th>
													<td>기존 통제의 개선이 필요함</td>
												</tr>
												<tr>
													<th scope="row">하</th>
													<td>해당 위험을 통제하기에 부족하며, 신규 통제의 설계가 필요함</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
								<section class="box box-grid">
									<h4 class="evl-title">운영평가</h4>
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col" class="w80">수준</th>
													<th scope="col">평가 기준</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th scope="row">상</th>
													<td>설계된 통제를 반드시 준수하고 있음</td>
												</tr>
												<tr>
													<th scope="row">중</th>
													<td>설계된 통제를 대체로 준수하고 있음</td>
												</tr>
												<tr>
													<th scope="row">하</th>
													<td>설계된 통제를 거의 준수하지 않음</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
							</div>
							<div class="col">
								<div class="box-header">
									<h3 class="title">통제 평가</h3>
								</div>
								<section class="rcsa-item">
									<h4 class="evl-title">설계 평가</h4>
									<ul class="evl">
										<li>
											<input type="radio" name="evl_ctl-a" id="evl_ctl-a-1" value = '1' checked>
											<label for="evl_ctl-a-1">
												<strong>상</strong>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ctl-a" id="evl_ctl-a-2" value = '2'>
											<label for="evl_ctl-a-2">
												<strong>중</strong>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ctl-a" id="evl_ctl-a-3" value = '3'>
											<label for="evl_ctl-a-3">
												<strong>하</strong>
											</label>
										</li>
									</ul>
								</section>									
								<section class="rcsa-item">
									<h4 class="evl-title">운영 평가</h4>
									<ul class="evl">
										<li>
											<input type="radio" name="evl_ctl-b" id="evl_ctl-b-1" value = '1' checked>
											<label for="evl_ctl-b-1">
												<strong>상</strong>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ctl-b" id="evl_ctl-b-2" value = '2'>
											<label for="evl_ctl-b-2">
												<strong>중</strong>
											</label>
										</li>
										<li>
											<input type="radio" name="evl_ctl-b" id="evl_ctl-b-3" value = '3'>
											<label for="evl_ctl-b-3">
												<strong>하</strong>
											</label>
										</li>
									</ul>
								</section>									
							</div>
						</article>
						
						<section class="risk-grade-wrap">
							<dl class="risk-grade">
								<dt>통제 등급</dt>
								<dd class="green" id = "CtlEvlGrdc">상</dd>
							</dl>
						</section>
					</div>
					<!-- 통제평가 //-->

					<!-- 잔여위험 등급 -->
					<div class="box rcsa-wrap">
						<div class="box-header">
							<h2 class="box-title">잔여위험 등급</h2>
						</div>
						<article class="row">
							<div class="col">
								<div class="box-header">
									<h3 class="title">[잔여위험 등급 산출]</h3>
								</div>
								<section class="box-grid">
									<h4 class="evl-title">리스크 사례별</h4>
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col" class="w80">리스크 사례</th>
													<th scope="col">산출식</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr>
													<th scope="row">A</th>
													<td>위험등급 환산점수 * 통제등급 환산점수 = 잔여위험 점수</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
								<section class="box box-grid">
									<h4 class="evl-title">프로세스 별</h4>
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col" class="w80">리스크 사례</th>
													<th scope="col">산출식</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr>
													<th scope="row">A</th>
													<td>&sum;(개별잔여위험점수) / N</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
								<section class="box box-grid">
									<h4 class="evl-title">리스크 사례별</h4>
									<div class="wrap-table">
										<table>
											<thead>
												<tr>
													<th scope="col" class="w100">잔여위험 등급</th>
													<th scope="col">산출식</th>
												</tr>
											</thead>
											<tbody class="center">
												<tr>
													<th scope="row">GREEN</th>
													<td>최종점수 &le; 3</td>
												</tr>
												<tr>
													<th scope="row">YELLOW</th>
													<td>3 &lt; 최종점수 &le; 6</td>
												</tr>
												<tr>
													<th scope="row">RED</th>
													<td>6 &lt; 최종점수 &le; 9</td>
												</tr>
											</tbody>
										</table>
									</div>
								</section>
							</div>
							<div class="col">
								<section class="risk-grade-wrap">
									<div class="risk-grade-all">
										<dl>
											<dt>위험등급 환산 점수</dt>
											<dd id = "rskNum">1</dd>
										</dl>
										<dl>
											<dt>통제등급 환산 점수</dt>
											<dd id = "ctlNum" >1</dd>
										</dl>
										<dl>
											<dt>잔여위험 점수</dt>
											<dd id = "rmnNum">1</dd>
										</dl>
									</div>
									<dl class="risk-grade">
										<dt>잔여위험 등급</dt>
										<dd class="green" id = "RmnRskGrdc">GREEN</dd>
									</dl>
								</section>
							</div>
						</article>
					</div>
					<!-- 잔여위험 등급 //-->
				  </form>
				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-normal" id='tmpBtn' onclick="javascript:doAction('temp');">임시저장</button>
					<button type="button" class="btn btn-primary" id='saveBtn' onclick="javascript:doAction('save');">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
	
	<div id="winRelLss" class="popup modal">
		<iframe name="ifrRelLss" id="ifrRelLss" src="about:blank"></iframe>
	</div>
	<div id="winRelKri" class="popup modal">
		<iframe name="ifrRelKri" id="ifrRelKri" src="about:blank"></iframe>
	</div>
	
	<script>
	   //닫기
	   $(".btn-close").click( function(event){
	   	$("#winRskEvl",parent.document).hide();
	   	event.preventDefault();
	   });
	</script>

</body>
</html>