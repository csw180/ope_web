<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0105.jsp
 Program name : KRI 허용한도 관리 상세(영업점)
 Description  : 화면정의서 KRI-01.2.2.1
 Programer    : 정현식
 Date created : 2022.06.03
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
DynaForm form = (DynaForm)request.getAttribute("form");

Vector vLst= CommUtil.getCommonCode(request, "KRI_LMT_DSC"); // 지표속성


if(vLst==null) vLst = new Vector();

String rki_id = (String)form.get("rki_id");
if(rki_id == null) rki_id ="";
String edit_yn = (String)form.get("edit_yn");
if(edit_yn == null) edit_yn ="";
String mod_yn = (String)form.get("mod_yn");
if(mod_yn==null) mod_yn = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>KRI 허용한도 관리 상세(영업점)</title>
	<script>
	$(document).ready(function(){
		parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
		
		//평가년월, 지표명, 적용사무소 세팅
		var f = document.ormsForm;
		f.rki_id.value = "<%=rki_id%>";
		
		
		setForm1(); //상단 조회(수정)조건 세팅
		//setForm2(); //최근1년지표발생값(등급) 세팅
		//setForm3(); //최근1년지표발생현황(지점,전행) 세팅

		// ibsheet 초기화
		initIBSheet();
	});
	
	$(document).ready(function(){
		initIBSheet2();
	});	
	
	// 허용한도구분 변경
		$("#kri_lmt_dsc").ready(function() {
			$("#kri_lmt_dsc").change(function() {
				var all_gubun = $("#all_gubun").val(); //전행구분
				var gu_drtn_rer_dsc = $("#gu_drtn_rer_dsc").val(); //순방향역방향구분코드
				var ryr1_avl = $("#ryr1_avl").val(); //최근1년평균
				var ryr1_sdva = $("#ryr1_sdva").val(); //최근1년표준편차
				var bfyy_avl = $("#bfyy_avl").val(); //전년도평균
				var bfyy_sdva = $("#bfyy_sdva").val(); //전년도표준편차
				
				var sc1_max_trh = ""; //1차한도
				var sc2_max_trh = ""; //2차한도
				
				if(all_gubun == "1"){ //사무소별
					if($("#kri_lmt_dsc").val() == "03"){ //이동평균
						if(gu_drtn_rer_dsc == "1"){ //정방향
		 					sc1_max_trh = Number(ryr1_avl)+Number(ryr1_sdva)*2;
		 					sc2_max_trh = Number(ryr1_avl)+Number(ryr1_sdva)*3;
		 				}else{ //역방향
		 					sc1_max_trh = Number(ryr1_avl)-Number(ryr1_sdva)*2;
		 					sc2_max_trh = Number(ryr1_avl)-Number(ryr1_sdva)*3;
		 				}
	 				}else if($("#kri_lmt_dsc").val() == "04"){ //전년평균
	 					if(gu_drtn_rer_dsc == "1"){ //정방향
		 					sc1_max_trh = Number(bfyy_avl)+Number(bfyy_sdva)*2;
		 					sc2_max_trh = Number(bfyy_avl)+Number(bfyy_sdva)*3;
		 				}else{ //역방향
		 					sc1_max_trh = Number(bfyy_avl)-Number(bfyy_sdva)*2;
		 					sc2_max_trh = Number(bfyy_avl)-Number(bfyy_sdva)*3;
		 				}

	 				}
					$("#sc1_max_trh").val(sc1_max_trh);
 				$("#sc2_max_trh").val(sc2_max_trh);
				}else{ //전행
					$("#sc1_max_trh").val("");
					$("#sc2_max_trh").val("");
				}
			});
			if($("#kri_lmt_dsc").val() != "01"){
			$("#sc1_max_trh").attr("disabled",true);
			$("#sc2_max_trh").attr("disabled",true);
			}
			
		});
	
	/*상단 조회(수정)조건 세팅*/
	function setForm1() {
		var f = document.ormsForm;
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "kri");
		WP.setParameter("process_id", "ORKR010412"); //KRI허용한도관리상세조회1

		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();

		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
		    {
			  success: function(result){
				  if(result != 'undefined' && result.rtnCode== '0'){
					var rList = result.DATA;
				  	if(rList.length > 0){
					  	f.rkinm.value = rList[0].rkinm; //지표명
					  	f.rkinm.value = rList[0].rkinm; //지표수준
				  		f.kri_lmt_dsc.value = rList[0].kri_lmt_dsc; //허용한도구분
				  		//1미만인 경우 앞에 0 붙혀주기 (안쓸시 .23 이런식으로 나옴)
				  		if(rList[0].fix_sc1_lmt_val.substring(0,1)=="."){
				  			f.sc1_max_trh.value = "0"+rList[0].fix_sc1_lmt_val; //1차한도기준
				  	    }else{
							f.sc1_max_trh.value = rList[0].fix_sc1_lmt_val; //1차한도기준
				  	    }
				  		
				  		if(rList[0].fix_sc2_lmt_val.substring(0,1)=="."){
							f.sc2_max_trh.value = "0"+rList[0].fix_sc2_lmt_val; //2차한도기준
				  	    }else{
							f.sc2_max_trh.value = rList[0].fix_sc2_lmt_val; //2차한도기준
				  	    }
						
						f.chg_dt.value = rList[0].chg_dt; //최종변경일
						f.rki_lvl_nm.value = rList[0].rki_lvl_nm; //지표수준
						// 영업점에서는 허용한도 구분 셀렉트 박스 수정 못함.
						$("kri_lmt_dsc").attr("disabled","disabled");
						// 고정방식일 경우만  수정버튼 활성화
						if ( f.kri_lmt_dsc.value == "01") {
							$("#save").removeAttr("disabled");
						}
						else {
							$("#save").attr("disabled","disabled");
						}
				  	}
				  } 
				  lmtCtl();
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
	
	
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		headers = [{Text:"변경일자|변경 내역|변경 내역|변경 내역|한도 변경 내용 상세", Align:"Center"}
 		          ,{Text:"변경일자|한도 구분|1차한도|2차한도|한도 변경 내용 상세",  Align:"Center"}];
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData.Cols = [
			{Type:"Text",Width:50,Align:"Center",SaveName:"bas_ym"			,MinWidth:60,Edit:false},
			{Type:"Text",Width:50,Align:"Center",SaveName:"kri_lmt_dsc_nm"	,MinWidth:60,Edit:false},
			{Type:"Text",Width:50,Align:"Center",SaveName:"sc1_max_trh"		,MinWidth:60,Edit:false},
			{Type:"Text",Width:50,Align:"Center",SaveName:"sc2_max_trh"		,MinWidth:60,Edit:false},
			{Type:"Text",Width:150,Align:"Left" ,SaveName:"lmt_chg_cntn"	,MinWidth:60,Edit:false},
		];
		
		IBS_InitSheet(mySheet,initData);
		
		mySheet.InitHeaders(headers);
		mySheet.SetMergeSheet(eval("msHeaderOnly"));
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		//컬럼의 너비 조정
		mySheet.FitColWidth();
		
		doAction('search');
	}
	
	function initIBSheet2() {
		//시트 초기화
		mySheet2.Reset();
		
		var initData2 = {};
		
		initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData2.Cols = [
			{Header:"rki_id"	,Type:"Text"	,Width:0	,Align:"Center"	,SaveName:"oprk_rki_id"	,MinWidth:0	,Edit:false,Hidden:true,HAlign:"Center"},
			{Header:"지점코드"		,Type:"Text"	,Width:0	,Align:"Center"	,SaveName:"brc"			,MinWidth:0	,Edit:false,Hidden:true,HAlign:"Center"},
			{Header:"KRI-ID"	,Type:"Text"	,Width:30	,Align:"Center"	,SaveName:"rki_id"		,MinWidth:60,Edit:false,Hidden:true},
			{Header:"지점명"		,Type:"Text"	,Width:120	,Align:"Left"	,SaveName:"brnm"		,MinWidth:60,Edit:false,Wrap:1},
			{Header:"1차 한도"		,Type:"Text"	,Width:200	,Align:"Center"	,SaveName:"sc1_lmt_val"	,MinWidth:60,Edit:false,Wrap:1},
			{Header:"2차 한도"		,Type:"Text"	,Width:200	,Align:"Center"	,SaveName:"sq2_lmt_val"	,MinWidth:60,Edit:false,Wrap:1},
		];
		
		IBS_InitSheet(mySheet2,initData2);
		
		//필터표시
		//mySheet2.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단 )
		mySheet2.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		//mySheet.SetSelectionMode(4);
		//mySheet2.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet2);
		
		//컬럼의 너비 조정
		mySheet2.FitColWidth();
		
		doAction('search2'); //자동 조회시 재무제표 영업지수 최근데이터 년월 set 한뒤 해야함 line.84 주석 제거
		
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
				setForm1(); //상단 조회(수정)조건 세팅
				//setForm2(); //최근1년지표발생값(등급) 세팅
				//setForm3(); //최근1년지표발생현황(지점,전행) 세팅
			
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR010415");
				// 허용한도 변경이력 조회
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
				
			case "search2":  //영업점별 허용한도 조회
				setForm1(); //상단 조회(수정)조건 세팅
				//setForm2(); //최근1년지표발생값(등급) 세팅
				//setForm3(); //최근1년지표발생현황(지점,전행) 세팅
			
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR010413");
				
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
								
			case "ORKR3101":		//변경내용입력팝업
				$("#ifrORKR3101").attr("src","about:blank");
				$("#winORKR3101").show();
				
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popORKR3101,1);
				break;
			case "reload":  //조회데이터 리로드
			
				mySheet.RemoveAll();
				initIBSheet();
				break;
			case "down2excel":
				
				//setExcelDownCols("1|2|3|4");
				mySheet.Down2Excel(excel_params);
				break;
			case "mod":		//수정 팝업
					$("#ifrKriLmt").attr("src","about:blank");
					$("#winKriLmt").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(modKri,1);
				break; 				
		}
	}
	
	function modKri(){ // RI 수정 처리
		
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
       	f.process_id.value="ORKR010421";
		f.target = "ifrKriLmt";
		f.submit();
	}
			
	function popORKR3101(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORKR011501";
		f.target = "ifrORKR3101";
		f.submit();
	}

	function mySheet_OnSearchEnd(code, message) {

		if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			
		}
		$("#pool_cnt").text(mySheet.RowCount());
		
		//컬럼의 너비 조정
		mySheet.FitColWidth();
	}
	
	// 조직검색 완료
	function orgSearchEnd(brc, brnm){
		$("#brc").val(brc);
		$("#brcnm").val(brnm);
		$("#winBuseo").hide();
		//doAction('search');
	}
	
	/*변경사유입력팝업*/
	function save(){
		var f = document.ormsForm;
		//alert(" 허용한도구분 --> " + f.kri_lmt_dsc.value);
		if ( f.kri_lmt_dsc.value == '01') { // 고정방식일 경우만 체크 
			if(f.sc1_max_trh.value.trim()==''){
				alert("1차한도기준을 입력하십시오.");
				f.sc1_max_trh.focus();
				return;
			}
			
			if(f.sc2_max_trh.value.trim()==''){
				alert("2차한도기준을 입력하십시오.");
				f.sc2_max_trh.focus();
				return;
			}
			
			if(f.chg_cntn.value.trim()==''){
				alert("변경내용상세를 입력하세요.");
				f.chg_cntn.focus();
				return;
			}			
		}	
		if(!confirm("저장하시겠습니까?")) return;	
		//doAction('ORKR3101'); //변경내용입력팝업
		endORKR3101();
	}
	
	function endORKR3101(){
		$("#winORKR3101").hide();
		
		var f = document.ormsForm;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "kri");
		WP.setParameter("process_id", "ORKR010416");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function(result){
					if(result!='undefined' && result.rtnCode=="S") {
						alert(result.rtnMsg);
						setForm1(); //상단 조회(수정)조건 세팅
						//setForm2(); //최근1년지표발생값(등급) 세팅
						//setForm3(); //최근1년지표발생현황(지점,전행) 세팅
						doAction('search');
					}else if(result!='undefined'){
						alert(result.rtnMsg);
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
	
	function lmtCtl() {
		var item = document.getElementById("kri_lmt_dsc");
		var itemID = item.options[item.selectedIndex].value;
		if (itemID == "01") {
			$("#sc1_max_trh").attr("disabled",false);
			$("#sc2_max_trh").attr("disabled",false);
		} else {
			$("#sc1_max_trh").attr("disabled",true);
			$("#sc2_max_trh").attr("disabled",true);
		}
	} 
	
	function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		//alert(Row);
		if(Row >= mySheet2.GetDataFirstRow()){
			//alert("oprk_rki_id -->" + mySheet2.GetCellValue(Row,"oprk_rki_id"));
			$("#rki_id").val(mySheet2.GetCellValue(Row,"oprk_rki_id"));
			$("#brc").val(mySheet2.GetCellValue(Row,"brc"));
			$("#brnm").val(mySheet2.GetCellValue(Row,"brnm"));
			
			doAction("mod");

		}
	}	
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<!-- 팝업 -->	
	<article class="popup modal block">
		<div class="p_frame w1100">
			<div class="p_head">
				<h1 class="title">KRI 허용한도 관리 상세(영업점)</h1>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<form name="ormsForm">
						<input type="hidden" id="path" name="path" />
						<input type="hidden" id="process_id" name="process_id" />
						<input type="hidden" id="commkind" name="commkind" />
						<input type="hidden" id="method" name="method" />
						
						<input type="hidden" id="rki_id" name="rki_id" /> <!-- KRI한도내역 -->
						<input type="hidden" id="brc" 	 name="brc" /> 	  <!-- 영업점코드 -->
						<input type="hidden" id="brnm" 	 name="brnm" />   <!-- 영업점명 -->
						<!-- input type="hidden" id="chg_cntn" name="chg_cntn" /--> <!-- 변경사유 (ORKR3101) -->
							
						<input type="hidden" id="gu_drtn_rer_dsc" name="gu_drtn_rer_dsc" /> <!-- 순방향역방향구분코드 -->
						<input type="hidden" id="ryr1_avl" name="ryr1_avl" /> <!-- 최근1년평균 -->
						<input type="hidden" id="ryr1_sdva" name="ryr1_sdva" /> <!-- 최근1년표준편차 -->
						<input type="hidden" id="bfyy_avl" name="bfyy_avl" /> <!-- 전년도평균 -->
						<input type="hidden" id="bfyy_sdva" name="bfyy_sdva" /> <!-- 전년도표준편차 -->
							
						<section class="box box-grid">
							<div class="wrap-table">
								<table>
									<tbody>
										<tr>
											<th>지표명</th>
											<td colspan="5">
												<input type="text" class="form-control" id="rkinm" name="rkinm" readonly="readonly" value="">
											</td>
											<th>지표수준</th>
											<td>
												<input type="text" class="form-control" id="rki_lvl_nm" name="rki_lvl_nm" readonly="readonly" value="">
											</td>												
										</tr>
										<tr>
											<th>허용한도구분</th>
											<td>
												<select  disabled class="form-control" id="kri_lmt_dsc" name="kri_lmt_dsc" onchange="lmtCtl();">
		<%
				for(int i=0;i<vLst.size();i++){
					HashMap hMap = (HashMap)vLst.get(i);
		%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
		<%
				}
		%>
												</select>
											</td>
											<th>1차한도기준</th>
											<td>
												<input type="number" class="form-control" id="sc1_max_trh" name="sc1_max_trh" value="">
											</td>
											<th>2차한도기준</th>
											<td>
												<input type="number" class="form-control" id="sc2_max_trh" name="sc2_max_trh" value="">
											</td>
											<th>최종변경일</th>
											<td>
												<input type="text" class="form-control" id="chg_dt" name="chg_dt" readonly="readonly" value="">
											</td>
										</tr>
										<tr>
											<th>변경내용상세</th>
											<td colspan="7">
												<textarea id="chg_cntn" name="chg_cntn"class="form-control" placeholder="변경 내용 상세 내용을 입력해 주십시오."></textarea>
											</td>
										</tr>											
									</tbody>
								</table>
							</div>
						</section>
					</form>
						
			 		<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">KRI 허용한도 변경이력<span class="small">(최근 10건)</span></h2>
						</div>
						<div class="wrap-grid h250">
							<script> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>
						
			 		<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">영업점 별 허용한도</h2>
						</div>
						<div class="wrap-grid h250">
							<script> createIBSheet("mySheet2", "100%", "100%"); </script>
						</div>
					</section>
					
			 	</div><!-- .p_wrap //-->
			</div><!-- .p_body //-->
			<div class="p_foot">
				<div class="btn-wrap">
<%
if("".equals(mod_yn)){
%> 
					<button type="button" id="save" class="btn btn-primary" onclick="save();" disabled>수정</button>
<%
}
%>						
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
	<!-- popup -->
	<div id="winORKR3101" class="popup modal">
		<iframe name="ifrORKR3101" id="ifrORKR3101" src="about:blank"></iframe>
	</div>
		<div id="winKriLmt" class="popup modal">
		<iframe name="ifrKriLmt" id="ifrKriLmt" src="about:blank"></iframe>
	</div>
	<!-- popup //-->
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	
	<script>
		$(document).ready(function(){
			
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
			//	$("#winORKR1101",parent.document).hide();
				event.preventDefault();
			});
		});
	</script>
</body>
</html>