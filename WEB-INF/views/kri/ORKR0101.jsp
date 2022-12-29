<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0101.jsp
 Program name : KRI풀 관리
 Description  : 화면정의서 KRI-01
 Programer    : 정현식
 Date created : 2022.03.25
 ---------------------------------------------------------------------------*/
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%

Vector vLst2= CommUtil.getCommonCode(request, "RKI_LVL_C"); // 리스크지표수준코드
if(vLst2==null) vLst2 = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
<!-- 	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script> -->
	<script>
		
	// 화면초기 셋팅시 처리 부분
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		
			initData.Cols = [
//			 	{Header:"선택",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50},
				{Header:"지표 수준 코드"	,Type:"Text",Width:100	,Align:"Center"	,SaveName:"rki_lvl_c"	,Wrap:1,MinWidth:20,Edit:0,Hidden:true},
				{Header:"지표 수준"		,Type:"Text",Width:100	,Align:"Center"	,SaveName:"rki_lvl_nm"	,Wrap:1,MinWidth:20,Edit:0},
				{Header:"지표 소관부서"	,Type:"Text",Width:100	,Align:"Center"	,SaveName:"brnm"	,Wrap:1,MinWidth:20,Edit:0},
				{Header:"KRI-ID"	,Type:"Text",Width:100	,Align:"Center"	,SaveName:"rki_id"		,MinWidth:60,Edit:0},
				{Header:"지표명"		,Type:"Text",Width:250	,Align:"Left"	,SaveName:"rkinm"		,Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표목적"		,Type:"Text",Width:400	,Align:"Left"	,SaveName:"rki_obv_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표정의"		,Type:"Text",Width:400	,Align:"Left"	,SaveName:"rki_def_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표산식"		,Type:"Text",Width:400	,Align:"Left"	,SaveName:"idx_fml_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"단위"		,Type:"Text",Width:60	,Align:"Center"	,SaveName:"kri_unt_nm"	,Wrap:1,MinWidth:20,Edit:0},
				{Header:"수집주기"		,Type:"Text",Width:60	,Align:"Center"	,SaveName:"col_fq_nm"	,Wrap:1,MinWidth:20,Edit:0},
				{Header:"수집방법"		,Type:"Text",Width:100	,Align:"Center"	,SaveName:"com_col_psb_nm",Wrap:1,MinWidth:20,Edit:0},
				{Header:"평가 대상\n여부"	,Type:"Text",Width:60	,Align:"Center"	,SaveName:"kri_yn"		,MinWidth:20,Edit:0},				
			];
			
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search');
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			if(Row >= mySheet.GetDataFirstRow()){
				$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
				$("#rki_lvl_c").val(mySheet.GetCellValue(Row,"rki_lvl_c"));
				
				doAction("mod");

			}
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet.GetDataFirstRow()){
				$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
				$("#kri_yn").val(mySheet.GetCellValue(Row,"kri_yn"));
			}
		}
		
		
//  		function mySheet_OnLoadData(data) {
//  		    alert("데이터 로드를 시작합니다.");
//  		    return data.replace(/Y/gi, "여");		// replaceAll
//  		}
		
		function modKri(){ // RI 수정 처리
			
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR010201";
			f.target = "ifrKriMod";
			f.submit();

		}
		
		function addKri(){ // RI 등록 처리
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri"; //kri
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR010301"; // ORKR010301
			f.target = "ifrKriAdd";
			f.submit();
		}
		
 		function del_kri_pool(){ //RI 삭제 처리
			var f = document.ormsForm;
			var add_html = "";
			if(mySheet.GetDataFirstRow()>=0){
// 				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
// 					if(mySheet.GetCellValue(j,"ischeck")==1){
// 						add_html += "<input type='hidden' name='hd_rki_id' value='" + mySheet.GetCellValue(j,"rki_id") + "'>";
// 					}
// 				}
//				alert(" kri-id ====> " + $("#rki_id").val());
				if ( $("#rki_id").val() != "" ) {
					add_html += "<input type='hidden' name='hd_rki_id' value='" + $("#rki_id").val() + "'>";
				}
			}

//			alert(add_html);			
			if(add_html==""){
				alert("삭제할 RI을 선택하세요.");
				return;
			}

			if($("#kri_yn").val() == "Y") {
				alert("평가대상여부가 Y 인 건은 삭제할 수 없습니다.");
				return;
			}	

            tmp_area.innerHTML = add_html;
			
			var f = document.ormsForm;
			if(!confirm("선택한 리스크를 삭제 하시겠습니까?")) return;
				
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "kri"); //rsa 
			WP.setParameter("process_id", "ORKR010103");  //ORKR010103
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== 'S'){
						  alert(result.rtnMsg);
						  doAction('search');
					  }
					  
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);			
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
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri"); // kri
					$("form[name=ormsForm] [name=process_id]").val("ORKR010102"); //ORKR010102			
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					//$("#form_value").val(FormQueryStringEnc(document.ormsForm));
			
					break;
				case "add":		//신규등록 팝업
					//신규등록 팝업
					$("#ifrKriAdd").attr("src","about:blank");
					$("#winKriAdd").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(addKri,1);
					
					break; 
				case "mod":		//수정 팝업
					if($("#rki_id").val() == ""){
						alert("수정할 대상 RI를 선택 하세요.");
						return;
					}else{
						$("#ifrKriMod").attr("src","about:blank");
						$("#winKriMod").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modKri,1);
					}
					break; 
				case "del":		//삭제 처리   
					if($("#rki_id").val() == ""){
						alert("삭제대상 RI를 선택 하세요.");
						return;
					}else{
						del_kri_pool();
					}
					break; 
				case "down2excel":
					
					down2Excel();

					break;
			}
		}
		
		function down2Excel(){
			mySheet.Down2Excel({FileName:"kriPool",SheetDesign:1,TitleText:"\r\n\r\n",HiddenColumn:1,Merge:2,DownCols:'0|1|2|3|4|5|6|7|8|9|10|11'});
			
		}

		

		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			//$("#kbr_nm").trigger("focus");
		}
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		        doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}

		function goSavEnd(){
			closePop();
			doAction('search');
		}
		
/*  		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
				return true;
			}else{
				return true;
			}
		} */
 		
 		// 부서검색 완료
		function orgSearchEnd(brc, brnm){
			$("#sch_jrdt_brc").val(brc);
			$("#sch_jrdt_brnm").val(brnm);
			$("#winBuseo").hide();
			doAction('search');
		}
		
		function delTxt(){
			if($("#sch_jrdt_brnm").val() == "") $("#sch_jrdt_brc").val("");
		}
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<div class="container">
				<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>
			<form name="ormsForm">
				<input type="hidden" id="path" 			name="path" />              
				<input type="hidden" id="process_id" 	name="process_id" />   
				<input type="hidden" id="commkind" 		name="commkind" />       
				<input type="hidden" id="method" 		name="method" />           
				<input type="hidden" id="sch_jrdt_brc" 	name="sch_jrdt_brc" >
				<input type="hidden" id="rki_id" 		name="rki_id" 			value="" >
				<input type="hidden" id="hd_bsn_prss_c" name="hd_bsn_prss_c" 	value="" >
				<input type="hidden" id="kri_yn" 		name="kri_yn" 			value="" >
				<input type="hidden" id="rki_lvl_c" 	name="rki_lvl_c" 		value="" >
				
				<div id="tmp_area"></div>	
				<div id="rk_ctgr_c"></div>		
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>지표 소관부서</th>
										<td class="form-inline">											
											<div class="input-group">
											<input type="text" class="form-control w120" id="sch_jrdt_brnm" name="sch_jrdt_brnm" onKeyPress="EnterkeySubmitOrg('sch_jrdt_brnm', 'orgSearchEnd');" onKeyUp="delTxt();">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico search" onclick="schOrgPopup('sch_jrdt_brnm', 'orgSearchEnd');"><i class="fa fa-search"></i><span class="blind">부서 선택</span></button>
												</span>
											</div>
										</td>
										<th>평가 대상 여부</th>
										<td>
											<select class="form-control w80" id="sch_kri_yn" name="sch_kri_yn" >
												<option value="">전체</option>
											    <option value="Y">Y</option>
											    <option value="N">N</option>
											</select>
										</td>
										<th>전산여부</th>
										<td>
											<select class="form-control w80" id="sch_com_col_psb_yn" name="sch_com_col_psb_yn" >
												<option value="">전체</option>
											    <option value="Y">Y</option>
											    <option value="N">N</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>지표수준</th>
										<td>
											<select class="form-control w120"  id="sch_rki_lvl_c" name="sch_rki_lvl_c">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst2.size();i++){
		HashMap hMap = (HashMap)vLst2.get(i);
%>
										   		<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>	
											</select>
										</td>
										<th>지표명</th>
										<td colspan="3">
											<input type="text" class="form-control w300" id="sch_rkinm" name="sch_rkinm" value="" placeholder="지표명을 입력하여 주십시오" onkeypress="EnterkeySubmit(doAction, 'search');">
										</td>
									</tr>
								</tbody>
							</table>
						</div><!-- .wrap-search -->
					</div><!-- .box-body //-->
					<div class="box-footer">
							<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
					</div>
				</div><!-- .box-search //-->
				<!-- 조회 //-->
			</form>
			<!-- Main content -->
				<section class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="btn-group">
								<button type="button" class="btn btn-xs btn-default" onClick="doAction('add');"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
								<button type="button" class="btn btn-xs btn-default" onClick="doAction('mod');"><i class="fa fa-pencil"></i><span class="txt">변경</span></button>
								<button type="button" class="btn btn-xs btn-default" onClick="doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
							</div>
							<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="wrap-grid h540">
						<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</section>
				
 		</div><!-- /.container -->		
	<!-- popup -->
	<div id="winKriAdd" class="popup modal" >
		<iframe name="ifrKriAdd" id="ifrKriAdd" src="about:blank"></iframe>
	</div>
	
	<div id="winKriMod" class="popup modal">
		<iframe name="ifrKriMod" id="ifrKriMod" src="about:blank"></iframe>
	</div>
	
	<%@ include file="../comm/OrgInfP.jsp" %>
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 	
</body>
</html>