<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0109.jsp
 Program name : KRI 입력 결과 조회
 Description  : 
 Programer    : 양진모
 Date created : 2020.07.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			//리스크담당자가 아닌경우 해당부서 사무소코드 SET
			var brc = '<%=(String)hs.get("brc")%>';
			var brcnm = '<%=(String)hs.get("brnm")%>';
			
			/*
				권한그룹ID 
				[001, 002, 003] 이런식으로 넘어와서
				[ ] < 잘라낸뒤 배열에 담아서 사용 + 공백때문에 trim 까지 해야함..
			*/
			var auth_ids = '<%=hs.get("auth_ids")%>';
			var auth_grp_id = auth_ids.replace("[","").replace("]","").split(",");
			var liskYn = "N"; //리스크담당자여부
		    for(i = 0; i<auth_grp_id.length ; i++)
		    {
		    	console.log(auth_grp_id[i]);
		    	//001 : 시스템관리자, 002 : ORM전담, 003 : 부서운영리스크담당자
		        if( auth_grp_id[i].trim() == '001' || auth_grp_id[i].trim() == '002' || auth_grp_id[i].trim() == '010'){
		        	liskYn = 'Y';
		        }
		    }
			if(liskYn == "N"){
				alert("조회하는데 여기 들어오나");
				$('#sch_brc').val(brc);
				$('#sch_brcnm').val(brcnm);
				document.getElementById("div_sch_brc").style.visibility = "hidden";
			}
			
			// ibsheet 초기화
			initIBSheet1();
			createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
			
			doAction('search');
		});
		
		$(document).ready(function(){
			initIBSheet2();
		});
		
		
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly,SearchMode:smLazyLoad,Page:10,FrozenCol:0,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			
			initData.Headers  = [{Text:"선택|조직구분|KRI 발생 건수|KRI 발생 건수|KRI 발생 건수|KRI 발생 건수", Align:"Center"},
		 						 {Text:"선택|조직구분|합계|Red|Yellow|Green", Align:"Center"}
		 						];
			
			initData.Cols = [{Type:"Text"	,Width:50,Align:"Left"	,SaveName:"apply_brc"	,MinWidth:50,Hidden:true,Edit:0},
							 {Type:"Text"	,Width:90,Align:"Left",SaveName:"apply_brc_nm",TreeCol:1,MinWidth:150,Edit:0},
							 {Type:"Text"	,Width:50,Align:"Center",SaveName:"t_lv"		,MinWidth:0,Edit:0},
							 {Type:"Text"	,Width:50,Align:"Center",SaveName:"r_lv"		,MinWidth:0,Edit:0},
							 {Type:"Text"	,Width:50,Align:"Center",SaveName:"y_lv"		,MinWidth:0,Edit:0},
							 {Type:"Text"	,Width:50,Align:"Center",SaveName:"g_lv"		,MinWidth:0,Edit:0}
							];
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(0);
			//mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			mySheet.SetSumValue(1, "합계");
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			
			
		}
		
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData2 = {};
			
 			initData2.Cfg = {MergeSheet:msHeaderOnly,SearchMode:smLazyLoad,Page:10,FrozenCol:0,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 

			initData2.Headers  = [{Text:"기준년월|지표소관부서|KRI-ID|지표명|지표값|단위|KRI등급|허용한도|허용한도|허용한도||상세", 	Align:"Center"},
		 					      {Text:"기준년월|지표소관부서|KRI-ID|지표명|지표값|단위|KRI등급|방식|1차한도|2차한도||상세", 		Align:"Center"}
		 					    ];
			
			initData2.Cols = [
				 			 	{Type:"Text",	Width:30,	Align:"Left",	SaveName:"bas_ym",		MinWidth:50,Edit:0,Hidden:true},
				 			 	{Type:"Text",	Width:30,	Align:"Left",	SaveName:"brnm",		MinWidth:50,Edit:0,Hidden:false},
								{Type:"Text",	Width:30,	Align:"Center",	SaveName:"rki_id",		MinWidth:60,Edit:0},
								{Type:"Text",	Width:150,	Align:"Left",	SaveName:"rkinm",		MinWidth:60,Edit:0},
								{Type:"Float",	Width:60,	Align:"Center",	SaveName:"kri_nvl",		MinWidth:0, Edit:0, Format:"#,##0.###"},
								{Type:"Text",	Width:30,	Align:"Center",	SaveName:"rki_unt_c_nm",MinWidth:60,Edit:0},
								{Type:"Text",	Width:40,	Align:"Center",	SaveName:"kri_lvl_nm",	MinWidth:60,Edit:0},
								{Type:"Text",	Width:50,	Align:"Center",	SaveName:"kri_lmt_cnm",	MinWidth:60,Edit:0},
								{Type:"Float",	Width:50,	Align:"Center",	SaveName:"sc1_max_trh",	MinWidth:60,Edit:0, Format:"#,##0.###"},
								{Type:"Float",	Width:50,	Align:"Center",	SaveName:"sc2_max_trh",	MinWidth:60,Edit:0, Format:"#,##0.###"},
	 							{Type:"Text",	Width:20,	Align:"Center",	SaveName:"detail_rki_id",MinWidth:60,Edit:0,Hidden:true},
	 							{Type:"Html",	Width:20,	Align:"Center",	SaveName:"goORKR1601",	MinWidth:60,Edit:0}
				            ];
			
			IBS_InitSheet(mySheet2,initData2);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(0);
			//mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
			
			
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){	
				$("#brc").val(mySheet.GetCellValue(Row,"apply_brc"));
				
				if ( ormsForm.schGubun.value == "1") {
					$("#sch_apply_brc").val(ormsForm.sch_brc.value);
					ormsForm.schGubun.value = "";
				}
				else {
					$("#sch_apply_brc").val(mySheet.GetCellValue(Row,"apply_brc"));
				}	
				$("#brcnm").val(mySheet.GetCellValue(Row,"apply_brc_nm"));
/*				
				if(mySheet.GetCellValue(Row,"apply_brc") != "TOT"){
 					ormsForm.sch_apply_brc.value = mySheet.GetCellValue(Row,"apply_brc");
 				}else{
 					ormsForm.sch_apply_brc.value = "";
 				}
*/				
				ormsForm.bas_ym.value = "202112";/*$("#sch_bas_y").val()+""+$("#sch_bas_m").val(); */
                detail_serch_sheet2();
			}
		}
		
		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				if(mySheet2.ColSaveName(Col) != "goORKR1601"){
					$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
					$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
					$("#rkinm").val(mySheet2.GetCellValue(Row,"rkinm"));
					doAction('ORKR1601');
				}
				
			}
		}
		
		function mySheet2_OnRowSearchEnd(Row) {
			if(mySheet2.GetCellValue(Row,"detail_rki_id")!=""){
				mySheet2.SetCellText(Row,"goORKR1601",'<button class="btn btn-xs btn-default" type="button" onclick="goORKR1601(\''+mySheet2.GetCellValue(Row,"rki_id")+'\',\''+mySheet2.GetCellValue(Row,"bas_ym")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
			}
            // "#FF3300" // RED
            // #FFFF33 // YELLOW
            // #66CC00 //GREEN
			var v_kri_lvl=mySheet2.GetCellValue(Row,"kri_lvl");
			if (v_kri_lvl == "YELLOW") {
				var color = "YELLOW";
			} else if (v_kri_lvl == "RED") {
				var color = "RED";
			} else if (v_kri_lvl == "GREEN") {
				var color = "GREEN";
			} else {
				var color = "WHITE";
			}
            mySheet2.SetCellBackColor(Row, 5, color);  //셀배경 변경
		}
		
		function goORKR1601(rki_id, bas_ym) { 
			for(var Row = mySheet2.GetDataFirstRow(); Row<=mySheet2.GetDataLastRow(); Row++){
				if(mySheet2.GetCellValue(Row,"rki_id")==rki_id && mySheet2.GetCellValue(Row,"bas_ym")==bas_ym){
					$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
					$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
					$("#rkinm").val(mySheet2.GetCellValue(Row,"rkinm"));
					doAction('ORKR1601');
					break;
				}
			}
		}
		
		function mySheet2_OnSaveEnd(code, msg) {
	
		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		        doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
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
					ormsForm.schGubun.value = "1";
					
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri"); // kri
					$("form[name=ormsForm] [name=process_id]").val("ORKR011102"); //ORRC0302 ,  ORKR0102 ORKR0702
					
					/* ormsForm.sch_bas_ym.value = $("#sch_bas_y").val()+""+$("#sch_bas_m").val(); */
					
					if ( ormsForm.sch_bas_ym.value == "") {
						alert("평가년월을 선택하세요.");
						return;
					}					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "ORKR1601":      //상세조회
					$("#ifrORKR1601").attr("src","about:blank");
					$("#winORKR1601").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(popORKR1601,1);
					
					break; 
				case "down2excel":
					setExcelDownCols("1|2|3|4|5|6|7|8");
					mySheet2.Down2Excel(excel_params);

					break;
			}
		}
		
		function popORKR1601(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";

	        f.process_id.value="ORKR011201";
	        f.bas_ym.value=$('#sch_bas_ym').val();//$('#sch_bas_y').val()+""+$('#sch_bas_m').val();
			f.target = "ifrORKR1601";
			f.submit();
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet_OnClick(2); //첫행 클릭
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}

        function detail_serch_sheet2() {
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri"); // kri
				$("form[name=ormsForm] [name=process_id]").val("ORKR011103"); 	
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			   
		}

	    function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
		}
	    
	 	// 조직검색 완료
		function orgSearchEnd(brc, brnm){
			$("#sch_brc").val(brc);
			$("#sch_brcnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
	 	
	 	

		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet.ShowTreeLevel(0,1);
			}
		}
	</script>

</head>
<body onkeyPress="return EnterkeyPass()">
	<div class="container">
		<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />               <!-- 공통 필수 선언 -->
			<input type="hidden" id="process_id" name="process_id" />   <!-- 공통 필수 선언 -->
			<input type="hidden" id="commkind" name="commkind" />       <!-- 공통 필수 선언 -->
			<input type="hidden" id="method" name="method" />           <!-- 공통 필수 선언 -->
		  	<!-- <input type="hidden" id="sch_bas_ym" name="sch_bas_ym" > -->
		  	<input type="hidden" id="sch_apply_brc" name="sch_apply_brc" >
		  	
		  	<input type="hidden" id="rki_id" name="rki_id" />
		  	<input type="hidden" id="bas_ym" name="bas_ym" value="202112"/> <!-- 평가년월 -->
		  	
		  	<input type="hidden" id="brc" name="brc" /> <!-- 사무소코드 -->
			<input type="hidden" id="brcnm" name="brcnm" /> <!-- 사무소명 -->
			<input type="hidden" id="rkinm" name="rkinm" /> <!-- 지표명 -->
			<input type="hidden" id="schGubun" name="schGubun" /> <!-- 조회구분 (1:조회버튼, 2:그리드클릭) -->

			<!-- 조회 영역 한줄인 경우 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tr>
								<th>평가부서</th>
								<td>
									<div class="input-group">
										<input type="hidden" class="form-control" id="sch_brc" name="sch_brc" value="">
										<input type="text" class="form-control" id="sch_brcnm" name="sch_brcnm" value="" readonly="readonly">
										<div class="input-group-btn" id="div_sch_brc" style="visibility: visible;">
											<button type="button" class="btn btn-default ico fl" onclick="schOrgPopup('sch_brcnm', 'orgSearchEnd');">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</div>
									</div>
								</td>
								<th>평가년월</th>
								<td class="form-inline">
									<select class="form-control w120" id="sch_bas_ym" name="sch_bas_ym" >
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
										<option value="<%=(String)hMap.get("bas_ym")%>"><%=((String)hMap.get("bas_ym")).substring(0,4)%>-<%=((String)hMap.get("bas_ym")).substring(4,6)%></option>
<%
	}
%>	
									</select>
								</td>

							</tr>

						</table>

						
					</div><!-- .wrap-search -->
						
				</div><!-- .box-body //--> 
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
				</div>
			</div>
			<!-- 조회 영역 한줄인 경우 //-->
		</form>
		<div class="box box-grid">
			<div class="row">
			    <div class="col w30p">
					<div class="box-header">
						<h2 class="box-title">전행 KRI 결과 모니터링</h2>
						<div class="area-tool">
							<div class="grid-tree-btn">
							    <button type="button" class="btn btn-xs" title="모두 펼치기" onClick="mySheet_showAllTree('1')"><i class="fa fa-plus-circle"></i></button>
								<button type="button" class="btn btn-xs" title="모두 접기" onClick="mySheet_showAllTree('2')"><i class="fa fa-minus-circle"></i></button>
							</div>
						</div>
					</div>
			        <div class="wrap-grid h580">
				         <script> createIBSheet("mySheet", "100%", "100%"); </script>
			        </div>
			    </div>
			    <div class="col w70p">
					<div class="box-header">
<!-- 						<div class="area-tool">
							<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div> -->
					</div>
			        <div id="mydiv2" class="wrap-grid h580">
				         <!-- <script> createIBSheet("mySheet2", "100%", "100%"); </script> -->
			        </div>
			    </div>
			</div>
		</div><!-- .box //-->
		<!-- simulation 상세대이터 조회 //-->
		<!-- /.box -->
		<!-- /.content -->
	</div>
	<!-- /.container -->
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->	
	<!-- popup -->
	<div id="winORKR1601" class="popup modal">
		<iframe name="ifrORKR1601" id="ifrORKR1601" src="about:blank"></iframe>
	</div>
</body>
</html>