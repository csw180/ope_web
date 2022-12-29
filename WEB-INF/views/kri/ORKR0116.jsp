<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0114.jsp
 Program name : KRI 월별보고서 
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
				{Header:"적용부서",Type:"Text",Width:100,Align:"Left",SaveName:"apl_brnm",Wrap:1,MinWidth:80,Edit:0,Hidden:false},
				{Header:"적용사무소코드",Type:"Text",Width:0,Align:"Left",SaveName:"apl_brc",MinWidth:0,Hidden:true},
				{Header:"온라인사무소코드",Type:"Text",Width:0,Align:"Left",SaveName:"onl_c",MinWidth:0,Hidden:true},
				{Header:"RI-ID",Type:"Text",Width:70,Align:"Center",SaveName:"rki_id",MinWidth:20,Edit:0},
				{Header:"리스크지표명",Type:"Text",Width:250,Align:"Left",SaveName:"rkinm",Wrap:1,MinWidth:20,Edit:0},
				{Header:"전월 등급",Type:"Text",Width:80,Align:"Center",SaveName:"snd_grdnm",MinWidth:60,Edit:0},
				{Header:"KRI 등급",Type:"Text",Width:80,Align:"Center",SaveName:"kri_grdnm",MinWidth:60,Edit:0},
				{Header:"단위",Type:"Text",Width:80,Align:"Center",SaveName:"rki_unt_nm",MinWidth:60,Edit:0},
				{Header:"입력상태",Type:"Text",Width:80,Align:"Center",SaveName:"inp_sts",MinWidth:60,Edit:0},
				{Header:"최초 작성일",Type:"Text",Width:90,Align:"Center",SaveName:"drup_dt",MinWidth:80,Edit:0},
				{Header:"결재상태",Type:"Text",Width:70,Align:"Center",SaveName:"app_rej",MinWidth:60,Edit:0},
				{Header:"원인 상세 내용",Type:"Text",Width:205,Align:"Center",SaveName:"cas_dtl_cntn",MinWidth:60,Edit:0},
				{Header:"대응방안내용",Type:"Text",Width:150,Align:"Center",SaveName:"cft_plan_cntn",MinWidth:60,Edit:0},
				{Header:"실행결과내용",Type:"Text",Width:250,Align:"Left",SaveName:"cas_anss_cntn",Wrap:1,MinWidth:20,Edit:0},
				{Header:"세부 조치결과",Type:"Text",Width:250,Align:"Left",SaveName:"act_cntn",Wrap:1,MinWidth:20,Edit:0},
				{Header:"반려사유",Type:"Text",Width:250,Align:"Left",SaveName:"rtn_cntn",Wrap:1,MultiLineText:1,MinWidth:20,Hidden:true},
				{Header:"기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:0,Hidden:true},
				{Header:"조치결재상태코드",Type:"Text",Width:0,Align:"Center",SaveName:"act_dcz_stsc",MinWidth:0},
				{Header:"대응방안내용",Type:"Text",Width:150,Align:"Center",SaveName:"snd_plan_cntn",MinWidth:60,Hidden:true}
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
		
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		}
		
		
		
		function mySheet_OnRowSearchEnd (Row) {
			mySheet.SetCellText(Row,"input",'<button class="btn btn-xs btn-default" type="button" onclick="update('+Row+')"><span class="txt mr10">대응방안&nbsp;입력&nbsp;&nbsp;</span><i class="fa fa-angle-right"></i></button>')
			}
		
		function update(Row){
			$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
			
				$("#sch_rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
				$("#hd_bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
				if($("#hd_apl_brc").val() == ''){
				$("#hd_apl_brc").val(mySheet.GetCellValue(Row,"apl_brc"));
				}
				$("#number").val("2");
				
				doAction('actDtl');
 	    
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
				$("form[name=ormsForm] [name=process_id]").val("ORKR011602");
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
			var cnt4=0, cnt5=0, cnt6=0, cnt7=0;
			var allCnt = mySheet.GetDataLastRow();
			
			if(mySheet.GetDataFirstRow()>=0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if (mySheet.GetCellValue(i,"kri_grdnm") == "RED")
						cnt1 = cnt1 + 1;
					else if (mySheet.GetCellValue(i,"kri_grdnm") == "YELLOW")
						cnt2 = cnt2 + 1;
					else if (mySheet.GetCellValue(i,"kri_grdnm") == "GREEN")
						cnt3 = cnt3 + 1;
					
					if (mySheet.GetCellValue(i,"snd_grdnm") == "RED")
						cnt4 = cnt4 + 1;
					else if (mySheet.GetCellValue(i,"snd_grdnm") == "YELLOW")
						cnt5 = cnt5 + 1;
					
					if (mySheet.GetCellValue(i,"cft_plan_cntn") != "")
						cnt6 = cnt6 + 1;
					
					if (mySheet.GetCellValue(i,"snd_plan_cntn") != "")
						cnt7 = cnt7 + 1;
				}
			}
			
			$("#red_cnt").text(cnt1);
			$("#red_div").text(cnt1/allCnt);
			$("#yellow_cnt").text(cnt2);
			$("#yellow_div").text(cnt2/allCnt);
			$("#green_cnt").text(cnt3);
			$("#green_div").text(cnt3/allCnt);
			
			$("#yellow_cnt2").text(cnt2);
			$("#red_cnt2").text(cnt1);
			
			$("#sec_red_cnt").text(cnt4);
			$("#sec_yellow_cnt").text(cnt5);
			$("#plan_cnt").text(cnt6);
			$("#sec_plan_cnt").text(cnt7);
						
			$("#red_cre").text(cnt4 - cnt1);
			$("#yellow_cre").text(cnt5 - cnt2);
			$("#plan_cre").text(cnt6 - cnt7);
			
			if (cnt4 != 0)
				$("#red_cdiv").text((cnt1-cnt4)/cnt4);
			else 
				$("#red_cdiv").text(0);
			
			if (cnt5 != 0)
				$("#yellow_cdiv").text((cnt2-cnt5)/cnt5);
			else 
				$("#yellow_cdiv").text(0);
			
			if (cnt7 != 0)
				$("#plan_cdiv").text((cnt6-cnt7)/cnt7);
			else 
				$("#plan_cdiv").text(0);
			
			
			// 대응방안 입력대상건이 아닌 경우 그리드에서 제외
			for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
				if(mySheet.GetCellValue(i,"act_dcz_stsc") == "") {
					mySheet.RowDelete(i);
				}
			}
			
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
			}
			else
			{
			%>		
				mySheet.Down2Excel({FileName:'ACT_PLN_PSTT_AMN.xlsx',SheetName:'Sheet1',SheetDesign:1,HiddenColumn:0,Merge:2,NumberTypeToText:1,DownCols:'0|3|4|5|6|7|8|9|10|13|14|15'});
		    <%	
			}
			%>	
			
			
		}
		
		function downloadData(rki_id,bas_ym,apl_brc,apl_brnm){	
			if(apl_brnm == "전영업점"){
				$("#sch2_bas_ym").val(bas_ym);
				$("#rki_id").val(rki_id);
				$("#brc").val(apl_brc);
				$("#all_gubun").val("2");
				
				
			}else{
				$("#sch2_bas_ym").val(bas_ym);
				$("#rki_id").val(rki_id);
				$("#brc").val(apl_brc);
				$("#all_gubun").val("1");
				
			}
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
										</tr>
									</tbody>
								</table>
							</div><!-- .wrap-search -->
						</div><!-- .box-body //-->
						<div class="box-footer">
							<button type="button" class="btn btn-primary btn search" onclick="javascript:doAction('search');">조회</button>
						</div>
					</div><!-- .box-search //-->
			<div class="row">
				<div class="col">
					<div class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">핵심리스크지표 허용한도 초과 현황</h2>
						</div>
						<div class="box-body">
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width:150px;">
										<col>
										<col>
										<col>
									</colgroup>
									<thead>
										<tr>
											<th>구분</th>
											<th>전월</th>
											<th>당월</th>
											<th>증감</th>
											<th>증감율</th>
										</tr>
									</thead>
									<tbody class="center">
										<tr>
											<th>RED</th>
											<td id="sec_red_cnt"></td>
											<td id="red_cnt2"></td>
											<td id="red_cre"></td>
											<td id="red_cdiv"></td>
										</tr>
										<tr>
											<th>YELLOW</th>
											<td id="sec_yellow_cnt"></td>
											<td id="yellow_cnt2"></td>
											<td id="yellow_cre"></td>
											<td id="yellow_cdiv"></td>
										</tr>
										<tr>
											<th>대응방안 입력대상</th>
											<td id="sec_plan_cnt"></td>
											<td id="plan_cnt"></td>
											<td id="plan_cre"></td>
											<td id="plan_cdiv"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>

				<div class="col">
					<div class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">KRI 등급 현황</h2>
						</div>
						<div class="box-body">
							<div class="wrap-table">
								<table>
									<thead>
										<tr>
											<th></th>
											<th>건수</th>
											<th>비율</th>
										</tr>
									</thead>
									<tbody class="center">
										<tr>
											<th>GREEN</th>
											<td id="green_cnt"></td>
											<td id="green_div"></td>
										</tr>
										<tr>
											<th>YELLOW</th>
											<td id="yellow_cnt"></td>
											<td id="yellow_div"></td>
										</tr>
										<tr>
											<th>RED</th>
											<td id="red_cnt"></td>
											<td id="red_div"></td>
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
					<h3 class="box-title">원인분석 및 세부 조치결과 입력 조회 및 승인여부</h3>
				</div><!-- .box-header //-->
				<div class="box-body">
					<div class="wrap-grid" style="height:370px;">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
					<!-- .wrap //-->
				</div>
			</div><!-- /.box -->
				<!-- 조회 결과 //-->
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
	
	<script>
		function orgSearchEnd(brc, brnm ){
			$("#hd_apl_brc").val(brc);
			$("#sch_apl_brnm").val(brnm);
			sv_hd_apl_brc = $("#hd_apl_brc").val();
			$("#winBuseo").hide();
			//doAction('search');
		}
	</script>
</body>
</html>