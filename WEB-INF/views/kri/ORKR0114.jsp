<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0111.jsp
 Program name : 원인분석 및 조치결과 입력 현황 관리(담당자)
 Description  : 
 Programer    : 양진모
 Date created : 2020.08.10
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->

<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

DynaForm form = (DynaForm)request.getAttribute("form");
Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

Vector vLst2 = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();


String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(","); 

String auth = "";

for(int i=0; i<auth_grp_id.length; i++){
	//System.out.println("auth_grp_id:"+auth_grp_id[i]);
	if(auth_grp_id[i].equals("003")){
		auth = "003";
		
		break;
	}
}

String hofc_bizo = "";
if("02".equals(hofc_bizo_dsc)){
	hofc_bizo = "2";
}else{
	hofc_bizo = "";
}

String auth_orm = "N"; //ORM여부
String biz_hofc_yn = "N"; //영업본부여부

for(int i = 0; i<auth_grp_id.length ; i++){
	//001 : 시스템관리자, 002 : ORM전담, 004 : 손실사건관리자, 010 : ORM팀장
    if( "001".equals(auth_grp_id[i]) || "002".equals(auth_grp_id[i]) 
    		|| "004".equals(auth_grp_id[i]) || "010".equals(auth_grp_id[i])){
        auth_orm = "Y";
        break;
    }
}

if(hofc_bizo_dsc.equals("03") && orgz_cfc.equals("07")){
	biz_hofc_yn = "Y";
}

String under_group = "영업본부 및 하위조직 전체"; // 하위조직


%>   
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<script>
	
		var auth_orm = 'N'; //ORM여부
		var auth_007 = 'N'; //팀장여부
		var part_orm = 'N'; //부서ORM여부
		
		$(document).ready(function(){
			var auth_ids = '<%=hs.get("auth_ids")%>';
			var auth_grp_id = auth_ids.replace("[","").replace("]","").split(",");
			
console.log("auth_ids : " +  auth_ids);
// 		    for(i = 0; i<auth_grp_id.length ; i++)
// 		    {
// 		    	console.log("직위 : " +  auth_grp_id[i].trim());
// 		    	//001 : 시스템관리자
// 		        if( auth_grp_id[i].trim() == '0001' || auth_grp_id[i].trim() == '002' ){
// 		            auth_orm = 'Y';
		            
// 		            $("#apprReq").hide(); //결재요청
// 		            $("#rtn").hide(); //반려
// 		            $("#appr").hide(); //결재
// 		        }else if(auth_grp_id[i].trim() == '006' || auth_grp_id[i].trim() == '010'){ //부서장 or ORM부서장
// 		        	auth_007 = 'Y';
		        
// 		        	if(auth_grp_id[i].trim() == '010'){
// 		        		auth_orm = 'Y';
// 		        	}
// 		        } else if (auth_grp_id[i].trim() == '003') {
// 		        	part_orm = 'Y';
// 		        }
// 		    }
		    
// 			if(auth_007 == 'Y'){
// 	            $("#apprReq").hide(); //상신
// 			}else {
// 	            $("#rtn").hide(); //반려
// 	            $("#appr").hide(); //결재
// 			}

			
			//ibsheet 초기화
			initIBSheet();	
		
		});
		
		
		
		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();  
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			initData.Cols = [
			 	{Header:"상태"		,Type:"Status"	,Width:50	,Align:"Center"	,SaveName:"status"		,MinWidth:20,Hidden:true},
				{Header:"적용사무소코드"	,Type:"Text"	,Width:0	,Align:"Left"	,SaveName:"apl_brc"		,MinWidth:0,Hidden:true},
				{Header:"조치결재상태코드"	,Type:"Text"	,Width:0	,Align:"Center"	,SaveName:"act_dcz_stsc",MinWidth:0,Hidden:true},
				{Header:"최초 작성일"	,Type:"Text"	,Width:90	,Align:"Center"	,SaveName:"drup_dt"		,MinWidth:20,Edit:0,Format:"yyyy-MM-dd",Hidden:true},
				{Header:"원인 상세 내용"	,Type:"Text"	,Width:205	,Align:"Left"	,SaveName:"cas_dtl_cntn",MinWidth:60,Edit:0,Hidden:true},
				{Header:"대응방안내용"	,Type:"Text"	,Width:250	,Align:"Left"	,SaveName:"cft_plan_cntn",MinWidth:60,Edit:0,Hidden:true},
				{Header:"실행결과내용"	,Type:"Text"	,Width:250	,Align:"Left"	,SaveName:"exe_rzt_cntn",Wrap:1,MinWidth:20,Edit:0,Hidden:true},
				{Header:"반려사유"		,Type:"Text"	,Width:250	,Align:"Left"	,SaveName:"rtn_cntn"	,Wrap:1,MultiLineText:1,MinWidth:20,Edit:0,EditLen:255,Hidden:true},
			 	
				{Header:"선택"		,Type:"CheckBox",Width:50	,Align:"Center"	,SaveName:"ischeck"		,MinWidth:50,Edit:1},
				{Header:"평가회차"		,Type:"Text"	,Width:0	,Align:"Center"	,SaveName:"bas_ym"		,MinWidth:0},
				{Header:"지표소관 부서"	,Type:"Text"	,Width:120	,Align:"Center"	,SaveName:"jrdt_brnm"	,Wrap:1,MinWidth:20,Edit:0,Hidden:false},
				{Header:"KRI-ID"	,Type:"Text"	,Width:70	,Align:"Center"	,SaveName:"rki_id"		,MinWidth:20,Edit:0},
				{Header:"지표명"		,Type:"Text"	,Width:250	,Align:"Left"	,SaveName:"rkinm"		,Wrap:1,MinWidth:20,Edit:0},
				{Header:"전월 등급"		,Type:"Text"	,Width:80	,Align:"Center"	,SaveName:"snd_grdnm"	,MinWidth:60,Edit:0},
				{Header:"당월 등급"		,Type:"Text"	,Width:80	,Align:"Center"	,SaveName:"kri_grdnm"	,MinWidth:60,Edit:0},
				{Header:"당월 지표값"	,Type:"Text"	,Width:80	,Align:"Center"	,SaveName:"kri_nvl"		,MinWidth:60,Edit:0},
				{Header:"단위"		,Type:"Text"	,Width:80	,Align:"Center"	,SaveName:"rki_unt_nm"	,MinWidth:60,Edit:0},
				{Header:"진행상태"		,Type:"Text"	,Width:80	,Align:"Center"	,SaveName:"inp_sts"		,MinWidth:20,Edit:0},
				{Header:"결재상태"		,Type:"Text"	,Width:70	,Align:"Center"	,SaveName:"app_rej"		,MinWidth:20,Edit:0},
				{Header:"대응방안 수립기한"	,Type:"Text"	,Width:70	,Align:"Center"	,SaveName:"act_ed_dt"	,MinWidth:20,Edit:0},
				{Header:"대응방안입력"	,Type:"HTML"	,Width:150	,Align:"Center"	,SaveName:"input"		,Wrap:1,MultiLineText:1,MinWidth:20,Edit:0},
			]; 
			
			IBS_InitSheet(mySheet,initData);
			    
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			//mySheet.SetCountPosition(0);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);

			doAction('search');
		}
		
		function mySheet_OnRowSearchEnd (Row) {
			<% 
			if(auth.equals("003")){
			%>			
			if(mySheet.GetCellValue(Row,"act_dcz_stsc")=="" || mySheet.GetCellValue(Row,"act_dcz_stsc")=="01"){
				mySheet.SetCellText(Row,"input",'<button class="btn btn-xs btn-default" type="button" onclick="update('+Row+')"><span class="txt mr10">대응방안&nbsp;입력&nbsp;&nbsp;</span><i class="fa fa-angle-right"></i></button>');
			}else{
				mySheet.SetCellText(Row,"input",'<button class="btn btn-xs btn-default" type="button" onclick="update('+Row+')"><span class="txt mr10">대응방안&nbsp;조회&nbsp;&nbsp;</span><i class="fa fa-angle-right"></i></button>');
			}
			<%
			}else{
			%>
			mySheet.SetCellText(Row,"input",'<button class="btn btn-xs btn-default" type="button" onclick="update('+Row+')"><span class="txt mr10">대응방안&nbsp;조회&nbsp;&nbsp;</span><i class="fa fa-angle-right"></i></button>');
			<%
			}
			%>							
		}
		
		function update(Row){
			$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
			
				$("#sch_rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
				$("#hd_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
				//if($("#hd_apl_brc").val() == ''){
					$("#hd_apl_brc").val(mySheet.GetCellValue(Row,"apl_brc"));
				//}
				$("#number").val("2");
				
				doAction('actDtl');

		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
				$("#apl_brc").val(mySheet.GetCellValue(Row,"apl_brc"));
			}
		}

		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			if(Row >= mySheet.GetDataFirstRow()){
				update(Row);
			}
		}
		
		function dtlAct(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR011501";
			f.target = "ifrActDtl";
			f.submit();
		}
		
		
		function apprReqFc(){ 
			var f = document.ormsForm;
				
			var hdng_html = "";
			var com = true;
			var cnt = 0;
			if(mySheet.GetDataFirstRow()>=0){
					
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(mySheet.GetCellValue(j, "ischeck")=="1" && mySheet.GetCellValue(j, "act_dcz_stsc")=="01"){
						hdng_html += "<input type='hidden' name='status' value='" + mySheet.GetCellValue(j,"status") + "'>";
						hdng_html += "<input type='hidden' name='s_rki_id' value='" + mySheet.GetCellValue(j,"rki_id") + "'>";
						hdng_html += "<input type='hidden' name='apl_brc' value='" + mySheet.GetCellValue(j,"apl_brc") + "'>";
						hdng_html += "<input type='hidden' name='s_bas_ym' value='" + mySheet.GetCellValue(j,"bas_ym") + "'>";
						hdng_html += "<input type='hidden' name='ischeck' value='" + mySheet.GetCellValue(j,"ischeck") + "'>";
						hdng_html += "<input type='hidden' name='rtn_cntn' value='" + mySheet.GetCellValue(j,"rtn_cntn") + "'>";
						
						cnt++;
					}else if(mySheet.GetCellValue(j, "ischeck")=="1" && mySheet.GetCellValue(j, "act_dcz_stsc")==""){
						hdng_html += "<input type='hidden' name='status' value='" + mySheet.GetCellValue(j,"status") + "'>";
						hdng_html += "<input type='hidden' name='s_rki_id' value='" + mySheet.GetCellValue(j,"rki_id") + "'>";
						hdng_html += "<input type='hidden' name='apl_brc' value='" + mySheet.GetCellValue(j,"apl_brc") + "'>";
						hdng_html += "<input type='hidden' name='s_bas_ym' value='" + mySheet.GetCellValue(j,"bas_ym") + "'>";
						hdng_html += "<input type='hidden' name='ischeck' value='" + mySheet.GetCellValue(j,"ischeck") + "'>";
						hdng_html += "<input type='hidden' name='rtn_cntn' value='" + mySheet.GetCellValue(j,"rtn_cntn") + "'>";
						
						cnt++;
					}else if(mySheet.GetCellValue(j, "ischeck")=="1" && mySheet.GetCellValue(j, "act_dcz_stsc")!="01"){
						com = false;
						alert("결재요청 대상이 아닌 리스크지표가 있습니다.");
						
						return;
					}
				}
			}
			hdng_area.innerHTML = hdng_html;
			if(cnt==0){
				com = false;
				alert("리스크지표를 선택해주세요");
				
				return;
			}
				$("#mode").val("Q");
				$("#dcz_dc").val("04");
			    $("#dcz_objr_emp_auth").val("'004','006'");
			    $("#dcz_rmk_c").val("");
			    schDczPopup(1);
			    
// 			if(com){
// 				if(!confirm("결재요청하시겠습니까?")) return;
	
// 				$("#mode").val("Q");
				
// 				$("#method").val("Main");
// 				$("#commkind").val("kri");
// 				$("#process_id").val("ORKR011403");
				
// 				WP.setForm(f);
				
// 				var url = "<=System.getProperty("contextpath")%>/comMain.do"; --%>
// 				var inputData = WP.getParams();
				
// 	//			alert(inputData);
// 				showLoadingWs(); // 프로그래스바 활성화
// 				WP.load(url, inputData,
// 					{
// 						success: function(result){
// 							if(result!='undefined' && result.rtnCode=="S") {
// 								alert(result.rtnMsg);
// 							}else if(result!='undefined'){
// 								alert(result.rtnMsg);
// 							}  
// 						},
					  
// 						complete: function(statusText,status){
// 							removeLoadingWs();
// 							doAction('search');
// 						},
					  
// 						error: function(rtnMsg){
// 							alert(JSON.stringify(rtnMsg));
// 						}
// 				});
// 			}
		}
		
		function apprFc(){ 
			var f = document.ormsForm;
				
			var hdng_html = "";
			var com = true;
			var cnt = 0;
			if(mySheet.GetDataFirstRow()>=0){
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(mySheet.GetCellValue(j, "ischeck")=="1" && mySheet.GetCellValue(j, "act_dcz_stsc")=="02"){
						hdng_html += "<input type='hidden' name='status' value='" + mySheet.GetCellValue(j,"status") + "'>";
						hdng_html += "<input type='hidden' name='s_rki_id' value='" + mySheet.GetCellValue(j,"rki_id") + "'>";
						hdng_html += "<input type='hidden' name='apl_brc' value='" + mySheet.GetCellValue(j,"apl_brc") + "'>";
						hdng_html += "<input type='hidden' name='s_bas_ym' value='" + mySheet.GetCellValue(j,"bas_ym") + "'>";
						hdng_html += "<input type='hidden' name='ischeck' value='" + mySheet.GetCellValue(j,"ischeck") + "'>";
						hdng_html += "<input type='hidden' name='rtn_cntn' value='" + mySheet.GetCellValue(j,"rtn_cntn") + "'>";
						
						cnt++;
					}else if(mySheet.GetCellValue(j, "ischeck")=="1" && mySheet.GetCellValue(j, "act_dcz_stsc")!="02"){
						com = false;
						alert("결재 대상이 아닌 리스크지표가 있습니다.");
						
						return;
					}
				}
			}
			hdng_area.innerHTML = hdng_html;
			if(cnt==0){
				com = false;
				alert("리스크지표를 선택해주세요");
				
				return;
			}
			
				$("#dcz_dc").val("04");
			    $("#dcz_objr_emp_auth").val("'004','006'");
			    $("#dcz_rmk_c").val("");
			    schDczPopup(1);
				
							
			
// 			if(com){
// 				if(!confirm("승인하시겠습니까?")) return;
	
// 				$("#mode").val("A");
// 				$("#method").val("Main");
// 				$("#commkind").val("kri");
// 				$("#process_id").val("ORKR011403");
	
// 				WP.setForm(f);
				
// 				var url = <=System.getProperty("contextpath")%>/comMain.do"; 
// 				var inputData = WP.getParams();
				
// 				//alert(inputData);
// 				showLoadingWs(); // 프로그래스바 활성화
// 				WP.load(url, inputData,
// 					{
// 						success: function(result){
// 							if(result!='undefined' && result.rtnCode=="S") {
// 								alert(result.rtnMsg);
// 							}else if(result!='undefined'){
// 								alert(result.rtnMsg);
// 								doAction('search');
// 							}  
// 						},
					  
// 						complete: function(statusText,status){
// 							removeLoadingWs();
// 							doAction('search');
// 						},
					  
// 						error: function(rtnMsg){
// 							alert(JSON.stringify(rtnMsg));
// 						}
// 				});
// 			}
			
		}
		
		function rtnMod() {
			$("#winRetMod").show();
		}
		
		function rtnFc(){ 
			var f = document.ormsForm;
				
			var hdng_html = "";
			var com = true;
			var cnt = 0;
			if(mySheet.GetDataFirstRow()>=0){
					
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(mySheet.GetCellValue(j, "ischeck")=="1" && mySheet.GetCellValue(j, "act_dcz_stsc")=="02"){
						hdng_html += "<input type='hidden' name='status' value='" + mySheet.GetCellValue(j,"status") + "'>";
						hdng_html += "<input type='hidden' name='s_rki_id' value='" + mySheet.GetCellValue(j,"rki_id") + "'>";
						hdng_html += "<input type='hidden' name='apl_brc' value='" + mySheet.GetCellValue(j,"apl_brc") + "'>";
						hdng_html += "<input type='hidden' name='s_bas_ym' value='" + mySheet.GetCellValue(j,"bas_ym") + "'>";
						hdng_html += "<input type='hidden' name='ischeck' value='" + mySheet.GetCellValue(j,"ischeck") + "'>";
						hdng_html += "<input type='hidden' name='rtn_cntn' value='" + $("#rtn_cntn").val() + "'>";
						
						cnt++;
					}else if(mySheet.GetCellValue(j, "ischeck")=="1" && mySheet.GetCellValue(j, "act_dcz_stsc")!="02"){
						com = false;
						alert("결재 대상이 아닌 리스크지표가 있습니다.");
						
						return;
					}
				}
			}
			hdng_area.innerHTML = hdng_html;
			if(cnt==0){
				com = false;
				alert("리스크지표를 선택해주세요");
				
				return;
			}
			if(com){
				if(!confirm("반려하시겠습니까?")) return;
	
				$("#mode").val("R");
				$("#method").val("Main");
				$("#commkind").val("kri");
				$("#process_id").val("ORKR011403");
	
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert(result.rtnMsg);
							}else if(result!='undefined'){
								alert(result.rtnMsg);
								doAction('search');
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
							$("#winRetMod").hide();
							doAction('search');
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
				});
			}
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		function doAction(sAction){
			switch(sAction){
			case "search": //데이터조회
				// var opt = {CallBack : DoSearchEnd}
				var opt = {};
			
				$("#hd_apl_brc").val("<%=brc%>");
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR011402");
				document.getElementById("hd_bas_ym").value = $("#bas_ym").val();
				
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
				break;	
			case "actDtl":
				if($("#rki_id").val() == ""){
					alert("대상 리스크를 선택하세요.");
					return;
				}else{
					
					$("#ifrActDtl").attr("src","about:blank");
					$("#winActDtl").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(dtlAct,1);
					//modRisk();
				}
				break;
				
			case "down2excel":
				
				down2Excel();

				break;				
			}
		}
		
		
		function act_Kri(){
			
			var cnt1=0, cnt2=0, cnt3=0;
			
			if(mySheet.GetDataFirstRow()>=0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					cnt1 = cnt1 + 1;
					if(mySheet.GetCellValue(i,"inp_sts") == "미입력" || mySheet.GetCellValue(i,"inp_sts") == "입력중"){
						cnt2 = cnt2 + 1;	
					}else if(mySheet.GetCellValue(i,"inp_sts") == "완료"|| mySheet.GetCellValue(i,"inp_sts") == "승인중"|| mySheet.GetCellValue(i,"inp_sts") == "ORM승인중"){
						cnt3 = cnt3 + 1;
					}
				}
			}
			
			$("#red_sum").text(cnt1);
			$("#red_icom").text(cnt2);
			$("#red_com").text(cnt3);
			
			
		} 
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("조회 중에 오류가 발생하였습니다..");
			}

			if(mySheet.GetDataFirstRow()>=0){
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(mySheet.GetCellValue(j,"act_dcz_stsc") == "02"){
						mySheet.SetCellText(j,"inp_sts","승인중");
						mySheet.SetCellText(j,"number","1");
					}else if(mySheet.GetCellValue(j,"act_dcz_stsc") == "03"){
						mySheet.SetCellText(j,"inp_sts","ORM승인중");
					}else if(mySheet.GetCellValue(j,"act_dcz_stsc") == "04"){
						mySheet.SetCellText(j,"inp_sts","완료");
					}else{
						if(mySheet.GetCellValue(j,"drup_dt") == ""){
							mySheet.SetCellText(j,"inp_sts","미입력");
						}else{
							mySheet.SetCellText(j,"inp_sts","입력중");
						}
					}
					
					if(mySheet.GetCellValue(j,"act_dcz_stsc") == "01"){
						if(mySheet.GetCellValue(j,"rtn_cntn") != ""){
							mySheet.SetCellText(j,"app_rej","반려");
						}else{
							mySheet.SetCellText(j,"app_rej","");
						}
					}else if(mySheet.GetCellValue(j,"act_dcz_stsc") == "02"){
						mySheet.SetCellText(j,"app_rej","승인요청");  //orm :결재대기  , 부서 :결재요청
					}else if(mySheet.GetCellValue(j,"act_dcz_stsc") == "03"){
						mySheet.SetCellText(j,"app_rej","승인");
					}else if(mySheet.GetCellValue(j,"act_dcz_stsc") == "04"){
						mySheet.SetCellText(j,"app_rej","완료");
					}
					
					if(mySheet.GetCellValue(j,"rki_unt") == "비율"){
						mySheet.SetCellText(j,"kri_nvl",mySheet.GetCellValue(j,"kri_nvl")+"%");
					}
					
					if(mySheet.GetCellValue(j,"act_dcz_stsc") == "02"){
						mySheet.SetCellText(j,"number","1");			
					}else{
						mySheet.SetCellText(j,"number","");
					}
				}
		    }
			act_Kri();
		}
		
		function down2Excel(){
			var f = document.ormsForm;
			
			<%
			if("Y".equals(biz_hofc_yn)){
			%>
				mySheet.Down2Excel({FileName:'ACT_PLN_PSTT_AMN.xlsx',SheetName:'Sheet1',SheetDesign:1,HiddenColumn:0,Merge:2,NumberTypeToText:1,DownCols:'9|10|11|12|13|14|15|16|17|18|19|20'});
			<%
			} else {
			%>		
				mySheet.Down2Excel({FileName:'ACT_PLN_PSTT_AMN.xlsx',SheetName:'Sheet1',SheetDesign:1,HiddenColumn:0,Merge:2,NumberTypeToText:1,DownCols:'9|10|11|12|13|14|15|16|17|18|19|20'});
		    <%	
			}
			%>	
			
			
		}
		
		function downloadData(rki_id,bas_ym,apl_brc,apl_brnm){	
			$("#sch2_bas_ym").val(bas_ym);
			$("#rki_id").val(rki_id);
			$("#brc").val(apl_brc);
			$("#all_gubun").val("1");
				
 			showLoadingWs(); // 프로그래스바 활성화
			//$.fileDownload("/actPlanReportExcel.orms", {
			$.fileDownload("/kriDetailExcel.orms", {
				httpMethod : "POST",
				data : $("#ormsForm").serialize(),
				successCallback : function(){
					  removeLoadingWs();
					
				},
				failCallback : function(msg){
					  removeLoadingWs();
					  alert(msg);
					
				}
			}); 
		}
		
		function doSave() {
			mySheet.DoSave(url, { Param : "method=Main&commkind=kri&process_id=ORKR011403&dcz_dc="+$("#dcz_dc").val()+"&dcz_rmk_c="+$("#dcz_rmk_c").val()+"&sch_rtn_cntn="+$("#sch_rtn_cntn").val()+"&dcz_objr_eno="+$("#dcz_objr_eno").val()+"&mode=Q", Col : 0 });
			
		}
					
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		    	$("#winDcz").hide();
		    	doAction('search');  
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}		
/*  		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
				return true;
			}else{
				return true;
			}
		} */
		
		
	</script>
</head>
<body>
	<div class="container">
	<!-- Content Header (Page header) -->
	<%@ include file="../comm/header.jsp" %>
		<div class="content">
			<form id="ormsForm" name="ormsForm">
				<input type="hidden" id="path" 			name="path" />
				<input type="hidden" id="process_id" 	name="process_id" />
				<input type="hidden" id="commkind" 		name="commkind" />
				<input type="hidden" id="method" 		name="method" />
				<input type="hidden" id="act_dcz_stsc" 	name="act_dcz_stsc" 	value="" />
				<input type="hidden" id="sch_rki_id" 	name="sch_rki_id" 		value="" />
				<input type="hidden" id="rki_prg_stsc" 	name="rki_prg_stsc" 	value="" />
				<input type="hidden" id="hd_bas_ym" 	name="hd_bas_ym" 		value="" />
				<input type="hidden" id="number" 		name="number" 			value="" />
				<input type="hidden" id="hd_hofc_bizo_menu_yn" name="hd_hofc_bizo_menu_yn" value="" />
				<input type="hidden" id="hofc_bizo_dsc" name="hofc_bizo_dsc" 	value="<%=hofc_bizo_dsc%>" />
				<input type="hidden" id="sch2_bas_ym" 	name="sch2_bas_ym" 		value=""  />
				<input type="hidden" id="rki_id" 		name="rki_id" 			value=""  />
				<input type="hidden" id="brc" 			name="brc" 				value=""  />
				<input type="hidden" id="all_gubun" 	name="all_gubun" 		value="">
				<input type="hidden" id="mode" 			name="mode" 			value=""> <!--Q : 결재요청, A : 결재, R : 반송 -->
				<input type="hidden" id="hd_apl_brc" 	name="hd_apl_brc" 		value=""  />  
				
				<input type="hidden" id="kri_menu_dsc" 	name="kri_menu_dsc" 	value="<%=form.get("kri_menu_dsc")%>" />
				<input type="hidden" id="dcz_dc" 		name="dcz_dc" />
				<input type="hidden" id="table_name" 	name="table_name" 		value="TB_OR_KH_ACT_DCZ"/>
				<input type="hidden" id="dcz_code" 		name="stsc_column_name" value="ACT_DCZ_STSC"/>
				<input type="hidden" id="rpst_id_column" name="rpst_id_column" 	value="OPRK_RKI_ID"/>
				<input type="hidden" id="rpst_id" 		name="rpst_id" 			value=""/>
				<input type="hidden" id="bas_pd_column" name="bas_pd_column" 	value="BAS_YM"/>
				<input type="hidden" id="bas_pd" 		name="bas_pd" 			value=""/>
				<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
				<input type="hidden" id="sch_rtn_cntn" 	name="sch_rtn_cntn" 	value=""/>
				<input type="hidden" id="dcz_objr_eno" 	name="dcz_objr_eno" 	value=""/>
				<input type="hidden" id="dcz_rmk_c" 	name="dcz_rmk_c" 		value=""/>
				<input type="hidden" id="brc_yn" 		name="brc_yn" 			value="Y"/>
								
				<div id="hdng_area"></div>
				
					<!-- 조회 -->
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<th>지표명</th>
											<td>
												<input type="text" id="sch_rkinm" name="sch_rkinm" class="form-control w180" value=""  onkeypress="EnterkeySubmit(doAction, 'search');"/>
											</td>
											<th>평가년월</th>
											<td>
												<select class="form-control w120" id="bas_ym" name="bas_ym" >
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
										   			<option value="<%=(String)hMap.get("bas_ym")%>"><%=(String)hMap.get("bas_ym")%></option>
<%
	}
%>	
												</select>
											</td>
											<th>결재상태</th>
											<td>
												<select class="form-control w120" id="st_dcz_stsc" name="st_dcz_stsc" >
													<option value="">전체</option>
													<option value="1">작성중</option>
													<option value="2">승인중</option>
													<option value="3">승인완료</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
							</div><!-- .wrap-search -->
						</div><!-- .box-body //-->
						<div class="box-footer">
							<div class="btn-wrap">
								<button type="button" class="btn btn-primary btn search" onclick="doAction('search');">조회</button>
							</div>
						</div>
					</div><!-- .box-search //-->
				
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">대응방안 입력현황</h2>
						</div>
						<div class="box-body">
							<div class="wrap-table">
								<table>
									<tbody class="center">
										<tr>
											<th scope="col">합계 건수</th>
											<th scope="col">조치계획 미완료 건</th>
											<th scope="col">조치계획 결재완료 건</th>
										</tr>
										<tr>
											<td id="red_sum"></td>
											<td id="red_icom"></td>
											<td id="red_com"></td>
										</tr>
									</tbody>
								</table>						
							</div>
						</div>
					</section>
				
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">원인분석 및 세부 조치결과 입력 조회 및 승인여부</h2>
						</div>
						<div class="box-header">
							<div class="area-term"><i class="fa fa-info-circle"></i> 대응방안 수립 대상 KRI란 3회 연속 KRI 평가 결과가 RED 값인 지표</div>
							<div class="area-tool">
								<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
							</div>
						</div>							
						
						<div class="wrap-grid h380">
							<script> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
						<div class="box-footer">
							<div class="btn-wrap">
								<button type="button" class="btn btn-primary btn" id="apprReq" onclick="apprReqFc();">결재요청</button>
								<button type="button" class="btn btn-primary btn" id="appr" onclick="apprFc();">결재</button>
								<button type="button" class="btn btn-normal btn" id="rtn" onclick="rtnMod();">반송</button>
							</div>
						</div>
					</section>
				</form>
		</div><!-- .content //-->
	</div><!-- .container //-->	
	<!-- popup //-->
	<article id="winRetMod" class="popup modal">
		<div class="p_frame w600">
			<div class="p_head">
				<h3 class="title">반려 사유</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<section class="box box-grid">
						<div class="wrap-table">
							<table>
								<tbody>
									<tr>
										<th>반려 사유</th>
			
										<td colspan="3">
											<textarea class="form-control" id="rtn_cntn" maxlength="255"></textarea>
										</td>
									</tr>
								</tbody>
			
							</table>
						</div>
					</section>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					
					<button type="button" class="btn btn-normal" onclick="rtnFc();">반려</button>
					
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
	</article>
	<div id="winActDtl" class="popup modal">
		<iframe name="ifrActDtl" id="ifrActDtl" src="about:blank"></iframe>	
	</div>
	<div id="winActDtl2" class="popup modal">
		<iframe name="ifrActDtl2" id="ifrActDtl2" src="about:blank"></iframe>	
	</div>
	
	
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup").hide();
			 doAction("search");
			 event.preventDefault();
		});
	});
	
		function orgSearchEnd(brc, brnm ){
			$("#hd_apl_brc").val(brc);
			$("#sch_apl_brnm").val(brnm);
			sv_hd_apl_brc = $("#hd_apl_brc").val();
			$("#winBuseo").hide();
			//doAction('search');
		}
		
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