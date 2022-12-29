<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0101.jsp
 Program name : 평판지표 조회
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
//if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getCommonCode(request, "REP_TYP_DSCD"); // (TB_OR_OM_CODE)
if(vLst2==null) vLst2 = new Vector();
Vector vLst3= CommUtil.getCommonCode(request, "SUP_BRC"); // (TB_OR_OM_CODE)
if(vLst3==null) vLst3 = new Vector();

SysDateDao dao = new SysDateDao(request);
String sch_inq_bas_dt = dao.getSysdate();//yyyymmdd


%> 
<!DOCTYPE html>
<html lang="ko">
	<head>
	    <%@ include file="../comm/library.jsp" %>
		<title>평판지표 조회</title>
		<script>
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet();
				//notSame(); //bas_y 중복제거
			});
			
			
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msBaseColumnMerge + msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"선택|선택",							Type:"Text",Width:70,Align:"Center",SaveName:"rki_id2",Wrap:1,MinWidth:30,Edit:1,Hidden:true,ColMerge:1},
				{Header:"선택|선택",							Type:"CheckBox",Width:70,Align:"Center",SaveName:"ischeck",Wrap:1,MinWidth:30,Edit:1},
				{Header:"평판지표ID|평판지표ID",				Type:"Text",Width:120,Align:"Center",SaveName:"rki_id",Wrap:1,MinWidth:40,Edit:0},
				{Header:"지표명|지표명",						Type:"Text",Width:300,Align:"Left",SaveName:"rkinm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"지표산식|지표산식",					Type:"Text",Width:450,Align:"Left",SaveName:"fml_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"기존KRI여부|여부",						Type:"Text",Width:60,Align:"Center",SaveName:"kri_yn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"기존KRI여부|지표명",					Type:"Text",Width:300,Align:"Left",SaveName:"oprk_rkinm",Wrap:1,MinWidth:150,Edit:0},
				{Header:"기존KRI여부|수집단위",					Type:"Text",Width:80,Align:"Center",SaveName:"col_fq_nm",Wrap:1,MinWidth:60,Edit:0,},
				{Header:"유형구분|유형구분",					Type:"Text",Width:100,Align:"Center",SaveName:"typnm",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판지표\n추출방식|평판지표\n추출방식",Type:"Text",Width:100,Align:"Center",SaveName:"psb_yn",Wrap:1,MinWidth:18,Edit:0},
				{Header:"수집주기|수집주기",					Type:"Text",Width:80,Align:"Center",SaveName:"fq_dsc",Wrap:1,MinWidth:18,Edit:0},
				{Header:"주관부서|주관부서",					Type:"Text",Width:150,Align:"Center",SaveName:"brnm",MinWidth:20,Edit:0},				
				{Header:"변경일자|변경일자",					Type:"Text",Width:80,Align:"Center",SaveName:"lschg_dtm",Wrap:1,MinWidth:20,Edit:0},
			];
			
				
				
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:1});
			//mySheet.SetAutoRowHeight(5);

			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search');
				
			}
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			//시트 ContextMenu선택에 대한 이벤트
			function mySheet_OnSelectMenu(text,code){
				alert('onselectmenu!');
				if(text=="엑셀다운로드"){
					doAction("down2excel");	
				}else if(text=="엑셀업로드"){
					doAction("loadexcel");
				}
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				if(Row >= mySheet.GetDataFirstRow()){
					$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
					doAction("mod");
				}
			}
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert('onclick!');
				if(Row >= mySheet.GetDataFirstRow()){
					$("#rki_id").val(mySheet.GetCellValue(Row,"rki_id"));
				}
			}
			
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회	
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("fam");
						$("form[name=ormsForm] [name=process_id]").val("ORFM010102");
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet.RemoveAll();
						initIBSheet();
						break;
					case "del":      //삭제
						if($("#rki_id").val() == ""){
							alert("삭제대상 평판지표를 선택하세요.");
						}else{
							del_fam();
						}						
						break;
					case "down2excel":
						setExcelFileName("영업지수 잔액 정보");
						setExcelDownCols("2|3|4|5|6|7|8|9|10|11");
						mySheet.Down2Excel(excel_params);
						break;
					case "mod":
						if($("#rki_id").val() == ""){
							alert("선택해주세요.");
							return;
						}else{
							$("#ifrFamMod").attr("src","about:blank");
							$("#winFamMod").show();
							setTimeout(modFam,1);
						}
					break; 
					case "mod1":
						$("#ifrFamMod1").attr("src","about:blank");
						$("#winFamMod1").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modFam1,1);
						//modRisk();
					break; 
					
					
				}
			}
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					
				}
				
				//컬럼의 너비 조정
				mySheet.FitColWidth();
			}
			function modFam(){ //평판지표상세팝업(더블클릭)
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="fam";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORFM010301";
				f.target = "ifrFamMod";
				f.submit();
			}
			function modFam1(){ //신규등록팝업
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="fam";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORFM010201";
				f.target = "ifrFamMod1";
				f.submit();
			}
			function del_fam(){
				var f = document.ormsForm;
				var add_html = "";
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j,"ischeck")==1){
							add_html += "<input type='hidden' name='sch_rki_id' value='" + mySheet.GetCellValue(j,"rki_id") + "'>";
						}
					}
				}
				if(add_html==""){
					alert("삭제할 평판지표를 선택하세요.");
					return;
				}

	            tmp_area.innerHTML = add_html;
				
				
				var f = document.ormsForm;
				if(!confirm("선택한 평판지표을 삭제 하시겠습니까?")) return;
					
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "fam");
				WP.setParameter("process_id", "ORFM010103");  //ORFM010103
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
			
			function notSame() { //bas_y 중복제거
				var foundedinputs = [];
				$("select[name=sch_bas_y] option").each(function() {
					if($.inArray(this.value, foundedinputs) != -1) $(this).remove();
					foundedinputs.push(this.value);
				});
			}
/* 			function EnterkeySubmit(){
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
			<!-- page-header -->
			<%@ include file="../comm/header.jsp" %>
			<!--.page header //-->
			<!-- content -->
			<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="rki_id" name="rki_id" value="" >
				<!-- 조회 -->
				<div id="tmp_area"></div>	
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
						
							<table>
								<tbody>
									<tr>
										<th>주관부서</th>
										<td>
											<select class="form-control w120"  id="sch_sup_brc" name="sch_sup_brc">
												<option value="">전체</option>
<%
	for(int i=0;i<vLst3.size();i++){
		HashMap hMap = (HashMap)vLst3.get(i);
%>
										   		<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>	
											</select>
										</td>
										<th>기존 KRI 여부</th>
										<td>
											<select class="form-control w80" id="sch_kri_yn" name="sch_kri_yn" >
												<option value="">전체</option>
											    <option value="Y">Y</option>
											    <option value="N">N</option>
											</select>
										</td>
										<th>전산여부</th>
										<td>
											<select class="form-control w80" id="sch_psb_yn" name="sch_psb_yn" >
												<option value="">전체</option>
											    <option value="Y">전산</option>
											    <option value="N">수기</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>지표유형</th>
										<td>
											<select class="form-control w120"  id="sch_typ_dscd" name="sch_typ_dscd">
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
											<input type="text" class="form-control w300" id="sch_rkinm" name="sch_rkinm" value="" placeholder="지표명을 입력하여 주십시오." onkeypress="EnterkeySubmit(doAction,'search');">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
					</div>
				</div>
				<!-- //조회 -->
	
	
				<section class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="btn-group">
								<button type="button" class="btn btn-default btn-xs" id="add_btn" name="add_btn" onclick="doAction('mod1')"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
								<button type="button" class="btn btn-default btn-xs" onclick="doAction('mod');"><i class="fa fa-pencil"></i><span class="txt">변경</span></button>
								<button type="button" class="btn btn-default btn-xs" onclick="doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
							</div>
							<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="wrap-grid h540">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</section>
			</form>
			</div>
			<!-- content //-->
		</div>
		<!-- popup -->
		<div id="winFamMod" class="popup modal">
			<iframe name="ifrFamMod" id="ifrFamMod" src="about:blank"></iframe>
		</div>
		<div id="winFamMod1" class="popup modal">
			<iframe name="ifrFamMod1" id="ifrFamMod1" src="about:blank"></iframe>
		</div>
		<%@ include file="../comm/OrgInfP.jsp" %>
		<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 
		
	</body>
</html>