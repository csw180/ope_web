<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0113.jsp
 Program name : 원인분석 및 조치결과 입력 현황 관리(ORM)
 Description  : 
 Programer    : 양진모
 Date created : 2020.08.10
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

Vector vLst2 = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();


String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(","); 

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
		$(document).ready(function(){
			
			var auth_ids = '<%=hs.get("auth_ids")%>';
			var auth_grp_id = auth_ids.replace("[","").replace("]","").split(",");
			
			var auth_orm = 'N'; //ORM여부
			var auth_007 = 'N'; //팀장여부
			var part_orm = 'N'; //부서ORM여부
			
		    for(i = 0; i<auth_grp_id.length ; i++)
		    {
		    	console.log("직위 : " +  auth_grp_id[i].trim());
		    	//001 : 시스템관리자
		        if( auth_grp_id[i].trim() == '001' || auth_grp_id[i].trim() == '002' ){
		            auth_orm = 'Y';
		            
		            $("#sign").hide(); //결재
		            $("#retn").hide(); //반려
		            $("#done").hide(); //완료
		        }else if(auth_grp_id[i].trim() == '006' || auth_grp_id[i].trim() == '010'){ //부서장 or ORM부서장
		        	auth_007 = 'Y';
		        
		        	if(auth_grp_id[i].trim() == '010'){
		        		auth_orm = 'Y';
		        	}
		        } else if (auth_grp_id[i].trim() == '003') {
		        	part_orm = 'Y';
		        }
		    }
		    	
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
				{Header:"적용부서"		,Type:"Text",Width:100	,Align:"Left"	,SaveName:"apl_brnm"	,Wrap:1,MinWidth:20,Edit:0,Hidden:true},
				{Header:"적용사무소코드"	,Type:"Text",Width:0	,Align:"Left"	,SaveName:"apl_brc"		,MinWidth:0,Hidden:true},
				{Header:"온라인사무소코드"	,Type:"Text",Width:0	,Align:"Left"	,SaveName:"onl_c"		,MinWidth:0,Hidden:true},
				
				{Header:"평가회차"		,Type:"Text",Width:70	,Align:"Center"	,SaveName:"bas_ym"		,MinWidth:20,Edit:0},
				{Header:"지표소관\n부서"	,Type:"Text",Width:70	,Align:"Center"	,SaveName:"brnm"		,MinWidth:100,Edit:0},
				{Header:"KRI-ID"	,Type:"Text",Width:70	,Align:"Center"	,SaveName:"rki_id"		,MinWidth:100,Edit:0},
				{Header:"지표명"		,Type:"Text",Width:250	,Align:"Left"	,SaveName:"rkinm"		,Wrap:1,MinWidth:200,Edit:0},
				
				{Header:"해당회차\n지표값"	,Type:"Text",Width:80	,Align:"Center"	,SaveName:"kri_nvl"		,MinWidth:60,Edit:0},
				{Header:"단위"		,Type:"Text",Width:80	,Align:"Center"	,SaveName:"rki_unt_nm"	,MinWidth:60,Edit:0},
				{Header:"원인 상세"		,Type:"Text",Width:205	,Align:"Left"	,SaveName:"cas_dtl_cntn",MinWidth:180,Edit:0},
				{Header:"대응방안\n이행 현황"	,Type:"Text",Width:150	,Align:"Left"	,SaveName:"cft_plan_cntn",MinWidth:180,Edit:0},
				{Header:"실행 결과\n결재 상태"	,Type:"Text",Width:250	,Align:"Left"	,SaveName:"exe_rzt_cntn",Wrap:1,MinWidth:180,Edit:0},
				{Header:"반려사유"		,Type:"Text",Width:250	,Align:"Left"	,SaveName:"rtn_cntn"	,Wrap:1,MultiLineText:1,MinWidth:180,Edit:0,EditLen:255},
				{Header:"이행완료일"		,Type:"Text",Width:0	,Align:"Center"	,SaveName:"act_cpl_dt"	,MinWidth:80},
				{Header:"최근결제일"		,Type:"Text",Width:90	,Align:"Center"	,SaveName:""			,MinWidth:80,Edit:0},
				{Header:"이행기일"		,Type:"Text",Width:90	,Align:"Center"	,SaveName:""			,MinWidth:80,Edit:0},
				{Header:"상세"		,Type:"Html",Width:90	,Align:"Center"	,SaveName:"Detail"		,MinWidth:20,Edit:0},
				
				{Header:"입력상태"		,Type:"Text",Width:80	,Align:"Center"	,SaveName:"inp_sts"		,MinWidth:20,Edit:0,Hidden:true},
				{Header:"결재상태"		,Type:"Text",Width:70	,Align:"Center"	,SaveName:"app_rej"		,MinWidth:20,Edit:0,Hidden:true},
				{Header:"조치결재상태코드"	,Type:"Text",Width:0	,Align:"Center"	,SaveName:"act_dcz_stsc",MinWidth:0,Hidden:true}
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
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);

			doAction('search');
		}
		
		function hidden_onl_c(){
			
			<%
			if("Y".equals(biz_hofc_yn)){
			%>
				if(document.querySelector('select#hd_apl_brc option:checked').text == '<%=under_group%>')
				{
					mySheet.SetColHidden("onl_c",0);
					//alert(document.getElementById("hd_hofc_bizo_menu_yn").value);
				} else {
					mySheet.SetColHidden("onl_c",1);
				}
			<%
			}
			%>	
		}
		
		function mySheet_OnRowSearchEnd(Row) {

			mySheet.SetCellText(Row,"Detail",'<button class="btn btn-xs btn-default" type="button" onclick="DetailStatus(\''+mySheet.GetCellValue(Row,"rki_id")+'\',\''+mySheet.GetCellValue(Row,"bas_ym")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
		}
		
		function DczStatus(rki_id,bas_ym) {
			$("#rpst_id").val(rki_id);
			$("#bas_pd").val(bas_ym);
			schDczPopup(3);
		}		
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		/*
 			var f = document.ormsForm;
 					$("#sch_rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
 					$("#hd_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
 					$("#hd_apl_brc").val(mySheet.GetCellValue(Row,"apl_brc"));

			doAction('actDtl');
		*/	
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet.GetDataFirstRow()){
				$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
				$("#apl_brc").val(mySheet.GetCellValue(Row,"apl_brc"));
			}
		}
		
		function dtlAct(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR011701";
			f.target = "ifrActDtl";
			f.submit();
		}
		
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		function doAction(sAction){
			switch(sAction){
			case "search": //데이터조회
				// var opt = {CallBack : DoSearchEnd}
				var opt = {};
				$("#hd_hofc_bizo_menu_yn").val("N"); //기본 N 초기화
				<%
				if("Y".equals(biz_hofc_yn)){
				%>
					if(document.querySelector('select#hd_apl_brc option:checked').text == '<%=under_group%>')
					{
						$("#hd_hofc_bizo_menu_yn").val("Y");
						//alert(document.getElementById("hd_hofc_bizo_menu_yn").value);
					}
					else
					{
						$("#hd_hofc_bizo_menu_yn").val("N");
						//alert(document.getElementById("hd_hofc_bizo_menu_yn").value);
					}
				<%
				}
				%>
				hidden_onl_c();
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR011902");
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
			}
		}
		
		
		function act_Kri(){
			
			var cnt1=0, cnt2=0, cnt3=0;
			
			if(mySheet.GetDataFirstRow()>=0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					cnt1 = cnt1 + 1;
					if(mySheet.GetCellValue(i,"inp_sts") == "미입력" || mySheet.GetCellValue(i,"inp_sts") == "입력중"){
						cnt2 = cnt2 + 1;	
					}else if(mySheet.GetCellValue(i,"inp_sts") == "완료"|| mySheet.GetCellValue(i,"inp_sts") == "승인중"){
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
				mySheet.Down2Excel({FileName:'ACT_PLN_PSTT_AMN.xlsx',SheetName:'Sheet1',SheetDesign:1,HiddenColumn:0,Merge:2,NumberTypeToText:1,DownCols:'0|2|3|4|5|6|7|8|9|10|13|14|15'});
			<%
			} else {
			%>		
				mySheet.Down2Excel({FileName:'ACT_PLN_PSTT_AMN.xlsx',SheetName:'Sheet1',SheetDesign:1,HiddenColumn:0,Merge:2,NumberTypeToText:1,DownCols:'0|3|4|5|6|7|8|9|10|13|14|15'});
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
		
		
	</script>
</head>
<body>
	<div class="container">
	<!-- Content Header (Page header) -->
	<%@ include file="../comm/header.jsp" %>
		<div class="content">
			<form id="ormsForm" name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="act_dcz_stsc" name="act_dcz_stsc" value="" />
				<input type="hidden" id="sch_rki_id" name="sch_rki_id" value="" />
				<input type="hidden" id="rki_prg_stsc" name="rki_prg_stsc" value="" />
				<input type="hidden" id="hd_bas_ym" name="hd_bas_ym" value="" />
				<input type="hidden" id="number" name="number" value="" />
				<input type="hidden" id="hd_hofc_bizo_menu_yn" name="hd_hofc_bizo_menu_yn" value="" />
				<input type="hidden" id="hofc_bizo_dsc" name="hofc_bizo_dsc" value="<%=hofc_bizo_dsc%>" />
				
				<!--20210303 상세데이터 다운로드 버튼을 그리드에 추가하기 위하여 추가-->
				<input type="hidden" id="sch2_bas_ym" name="sch2_bas_ym" value=""  />
				<input type="hidden" id="rki_id" name="rki_id" value=""  />
				<input type="hidden" id="brc" name="brc" value=""  />
				<input type="hidden" id="all_gubun" name="all_gubun" value=""> 
				<!--20210303 상세데이터 다운로드 버튼을 그리드에 추가하기 위하여 추가-->
				
				
					<!-- 조회 -->
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<th>지표명</th>
											<td>
												<input type="text" id="sch_rkinm" class="form-control w180" value="" placeholder="지표명을 입력해 주십시오." onkeypress="EnterkeySubmit(doAction, 'search');">
											</td>

											<th scope="row">평가 조직</th>
											<td class="form-inline">											
<%
		if("Y".equals(auth_orm)){
		
%>
												<div class="input-group">
													<input type="text" class="form-control w120" name=sch_apl_brnm id="sch_apl_brnm" onKeyPress="EnterkeySubmitOrg('sch_apl_brnm', 'orgSearchEnd');" disabled />
													<input type="hidden" id="hd_apl_brc" name="hd_apl_brc" value=""/>
													<div class="input-group-btn">
														<button type="button" class="btn btn-default ico search"  onclick="schOrgPopup('sch_apl_brnm', 'orgSearchEnd');">
															<i class="fa fa-search"></i><span class="blind">조직 선택</span>
														</button>
													</div>
												</div>
<%
		}else {
			if("Y".equals(biz_hofc_yn)){
%>
												<span class="select">
													<select class="form-control w220" id="hd_apl_brc" name="hd_apl_brc">
														<!--  <option value="<%=(String)hs.get("brc") %>"><%=(String)hs.get("brnm")%></option>  -->
														<option value="<%=(String)hs.get("brc")%>"><%=under_group%></option>
<%				
				for(int j=0; j<vLst2.size(); j++){
					HashMap hMap2 = (HashMap)vLst2.get(j);
%>
														<option value="<%=(String)hMap2.get("brc")%>"><%=(String)hMap2.get("brnm")%></option>
<%					
				}
%>
													</select>
												</span>	
<%
			}else{
%>
												<input type="text" class="form-control w120" name="sch_apl_brnm" id="sch_apl_brnm" value="<%=(String)hs.get("brnm") %>" readonly />
												<input type="hidden" class="form-control" id="hd_apl_brc" name="hd_apl_brc"  value="<%=(String)hs.get("brc") %>" readonly />	
<%
			}
		}
%>	
											</td>
																						
											
											<th>이행현황</th>
											<td>
												<select class="form-control w100">
													<option value="">전체</option>
													<option value="">미이행</option>
													<option value="">이행완료</option>
												</select>
											</td>
										</tr>
										<tr>
											<th>기간 설정</th>
											<td colspan="5" class="form-inline">
												<div class="input-group">
													<input type="text" id="from_bas_ym" class="form-control w90" value="2022-01" readonly>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM', 'from_bas_ym')"><i class="fa fa-calendar"></i><span class="blind">날짜선택</span></button>
													</span>
												</div>
												<div class="input-group-addon"> ~ </div>
												<div class="input-group">
													<input type="text" id="to_bas_ym" class="form-control w90" value="2022-01" readonly>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM', 'to_bas_ym')"><i class="fa fa-calendar"></i><span class="blind">날짜선택</span></button>
													</span>
												</div>
											</td>
										</tr>									
									</tbody>
								</table>
							</div><!-- .wrap-search -->
						</div><!-- .box-body //-->
						<div class="box-footer">
							<div class="btn-wrap">
								<button type="button" class="btn btn-primary btn search" onclick="javascript:doAction('search');">조회</button>
							</div>
						</div>
					</div><!-- .box-search //-->
				
					<div class="box box-grid">
						<div class="box-header ">
							<h2 class="box-title">대응방안 및 실행결과 이력조회</h2>
						</div>
						<div class="box-body">
							<div class="wrap-grid h540">
								<script> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
					</div>
					
				</form>
		</div><!-- .content //-->
	</div><!-- .container //-->	
	<!-- popup //-->
	<div id="winActDtl" class="popup modal">
		<iframe name="ifrActDtl" id="ifrActDtl" src="about:blank"></iframe>	
	</div>
	<div id="winActDtl2" class="popup modal">
		<iframe name="ifrActDtl2" id="ifrActDtl2" src="about:blank"></iframe>	
	</div>
	<%@ include file="../comm/OrgInfP.jsp" %> 
	<script>
	<!-- 부서 공통 팝업 -->
		var init_flag = false
		function org_popup(){
			schOrgPopup("sch_apl_brnm", "orgSearchEnd","0");
			if($("#sch_hd_brc_nm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		function orgSearchEnd(brc, brnm ){
			$("#hd_apl_brc").val(brc);
			$("#sch_apl_brnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
	</script>
</body>
</html>