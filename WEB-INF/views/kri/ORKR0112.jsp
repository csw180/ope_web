<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0110.jsp
 Program name : KRI 입력 결과 상세 조회
 Description  : 
 Programer    : 양진모
 Date created : 2020.08.19
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");


ArrayList list_bas_ym = new ArrayList();
for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
	
	list_bas_ym.add((String)hMap.get("bas_ym"));
}

DynaForm form = (DynaForm)request.getAttribute("form");
String bas_ym = (String)form.get("bas_ym");
if(bas_ym == null) bas_ym ="";
String rki_id = (String)form.get("rki_id");
if(rki_id == null) rki_id ="";


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<title>KRI 허용한도 관리 상세</title>
	<script>
	$(document).ready(function(){
		parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
		
		//평가년월, 지표명, 적용사무소 세팅
		var f = document.ormsForm;
		var basYm = "<%=bas_ym%>";
		f.bas_ym.value = "<%=bas_ym%>";
		f.rki_id.value = "<%=rki_id%>";
		f.brc.value = parent.$("#brc").val();
		f.brcnm.value = parent.$("#brcnm").val();
		f.rkinm.value = parent.$("#rkinm").val();
		
		/*최근1년KRI발생현황(등급) 년월 표시*/
		var sch_bas_y = basYm.substring(0,4);
		var sch_bas_m = basYm.substring(4,6);
		var bas_ym = {};
		var bas_y = {};
		var bas_m = {};
		
		if(sch_bas_y != ""){
			bas_y[0] = sch_bas_y;
			bas_m[0] = sch_bas_m;
			
			bas_ym[0] = sch_bas_y+"."+sch_bas_m;
			
			for(var i=1; i<12; i++){
				if(bas_m[i-1]<2){
					bas_y[i] = bas_y[i-1] - 1;
					bas_m[i] = "12";
				}else{
					bas_y[i] = bas_y[i-1];
					bas_m[i] = bas_m[i-1] - 1;
				}
				if(bas_m[i] > 9){
					bas_ym[i] = bas_y[i]+"."+bas_m[i];
				}else{
					bas_ym[i] = bas_y[i]+".0"+bas_m[i];
				}
			}
			
			for(var i=0; i<12; i++){
				bas_ym[i] = bas_ym[i].substring(2,7);
			}
		}
		
		document.getElementById("bas_ym1").innerHTML = bas_ym[0];
		document.getElementById("bas_ym2").innerHTML = bas_ym[1];
		document.getElementById("bas_ym3").innerHTML = bas_ym[2];
		document.getElementById("bas_ym4").innerHTML = bas_ym[3];
		document.getElementById("bas_ym5").innerHTML = bas_ym[4];
		document.getElementById("bas_ym6").innerHTML = bas_ym[5];
		document.getElementById("bas_ym7").innerHTML = bas_ym[6];
		document.getElementById("bas_ym8").innerHTML = bas_ym[7];
		document.getElementById("bas_ym9").innerHTML = bas_ym[8];
		document.getElementById("bas_ym10").innerHTML = bas_ym[9];
		document.getElementById("bas_ym11").innerHTML = bas_ym[10];
		document.getElementById("bas_ym12").innerHTML = bas_ym[11];
		 
		//저장버튼 제어
    	if($("#edit_yn").val() == "Y"){
    		$("#save").show(); //저장버튼 숨김
		}else{
			$("#save").hide(); //저장버튼 표기
		}
		
		doAction("searchForm");
		//setForm1(); //당월발생현황
		//setForm2(); //최근1년KRI발생현황(등급)
		
		// 평가일정 기준년월
	    var list_bas_ym = new Array();
	    list_bas_ym = <%=list_bas_ym%>;
	    
	    var list_bas_y = new Array();
	    var str_list_bas_ym = "";
	    for(var i=0; i<list_bas_ym.length; i++){
	    	str_list_bas_ym = list_bas_ym[i]+"";
	    	list_bas_y.push(str_list_bas_ym.substring(0,4));
	    }
	    
	    var uni_list_bas_y = unique(list_bas_y); //조회년 중복제거
	    
	    for(var j=0; j<uni_list_bas_y.length; j++){
	    	if(j == 0){
	    		$('#sch_bas_y_from').prepend("<option value='"+uni_list_bas_y[j]+"'>"+uni_list_bas_y[j]+"</option>");
	    		$('#sch_bas_y_to').prepend("<option value='"+uni_list_bas_y[j]+"'>"+uni_list_bas_y[j]+"</option>");
	    		sch_month(uni_list_bas_y[j],'sch_bas_m_from','from'); //월조회
	    		sch_month(uni_list_bas_y[j],'sch_bas_m_to','to'); //월조회
	    	}else{
	    		$('#sch_bas_y_from option:eq('+(j-1)+')').after("<option value='"+uni_list_bas_y[j]+"'>"+uni_list_bas_y[j]+"</option>");
	    		$('#sch_bas_y_to option:eq('+(j-1)+')').after("<option value='"+uni_list_bas_y[j]+"'>"+uni_list_bas_y[j]+"</option>");
	    	}
	    }
		
		// ibsheet 초기화
		initIBSheet();
		initIBSheet2();
	});
	
	/*당월발생현황 세팅*/
	function setForm1() {
		var f = document.ormsForm;
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "kri");
		WP.setParameter("process_id", "ORKR011002"); //당월발생현황
		
		WP.setForm(f);

		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();

		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
		    {
			  success: function(result){
				  if(result != 'undefined' && result.rtnCode== 'S'){
					var rList = result.DATA;
					if(rList.length > 0){
			    		document.getElementById("kri_nvl").innerHTML = rList[0].kri_nvl;
			    		document.getElementById("kri_grdnm").innerHTML = rList[0].kri_grdnm;
			    		document.getElementById("kri_lmt_dsc_nm").innerHTML = rList[0].kri_lmt_dsc_nm;
			    		document.getElementById("kri_avl").innerHTML = rList[0].kri_avl;
			    		document.getElementById("sc1_max_trh").innerHTML = rList[0].sc1_max_trh;
			    		document.getElementById("sc2_max_trh").innerHTML = rList[0].sc2_max_trh;
			    		document.getElementById("ryr1_avl").innerHTML = rList[0].ryr1_avl;
				  	}
				  }  
					setTimeout(setForm2,1);
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
	
	/*최근1년KRI발생현황(등급)*/
	function setForm2() {
		var f = document.ormsForm;
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "kri");
		WP.setParameter("process_id", "ORKR011003"); //최근1년KRI발생현황(등급)
		
		WP.setForm(f);

		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();

		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
		    {
			  success: function(result){
				  if(result != 'undefined' && result.rtnCode== 'S'){
					var rList = result.DATA;
					if(rList.length > 0){
						document.getElementById("kri_nvl12").innerHTML = rList[0].kri_nvl12;
						document.getElementById("kri_nvl11").innerHTML = rList[0].kri_nvl11;
						document.getElementById("kri_nvl10").innerHTML = rList[0].kri_nvl10;
						document.getElementById("kri_nvl9").innerHTML = rList[0].kri_nvl9;
						document.getElementById("kri_nvl8").innerHTML = rList[0].kri_nvl8;
						document.getElementById("kri_nvl7").innerHTML = rList[0].kri_nvl7;
						document.getElementById("kri_nvl6").innerHTML = rList[0].kri_nvl6;
						document.getElementById("kri_nvl5").innerHTML = rList[0].kri_nvl5;
						document.getElementById("kri_nvl4").innerHTML = rList[0].kri_nvl4;
						document.getElementById("kri_nvl3").innerHTML = rList[0].kri_nvl3;
						document.getElementById("kri_nvl2").innerHTML = rList[0].kri_nvl2;
						document.getElementById("kri_nvl1").innerHTML = rList[0].kri_nvl1;
						document.getElementById("ryr1_avl2").innerHTML = rList[0].ryr1_avl;
				  	}
				  }
				  /* $("#btn_search").trigger("click"); */
				  doAction('search');
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
	
	/*배열 중복제거*/
	function unique(paramList){
		var arrCheckVal = new Array();
		var chk = true;
		
		for(var i=0; i<paramList.length; i++){
			//중복유무 초기화
			chk = true;
			
			//중복체크
			//값을 담은 배열을 전체 반복하면서 담을 데이터와 담겨진 데이터를 비교
			for(value in arrCheckVal){
				//중복유무를 체크하여 값을 담을지 말지 결정
				if(arrCheckVal[value] == paramList[i]){
					chk = false;
				}
			}
			
			if(chk){
				arrCheckVal.push(paramList[i]);
			}
		}
		
		return arrCheckVal; 
	}
	
	/*조회년도 변경시 월 조회*/
	function sch_month(paramYear, v_form, v_FromToGubun){ 
		// 평가일정 기준년월
	    var list_bas_ym = new Array();
	    list_bas_ym = <%=list_bas_ym%>;
	    
	    var list_month = new Array();
	    var str_list_bas_ym = "";
	    for(var i=0; i<list_bas_ym.length; i++){
	    	str_list_bas_ym = list_bas_ym[i]+"";
	    	if(str_list_bas_ym.substring(0,4) == paramYear){
	    		list_month.push(str_list_bas_ym.substring(4,6));
	    	}
	    }
	    
	    //조회조건 월값 SET
	    $('#'+v_form+' option').remove();
	    for(var j=0; j<list_month.length; j++){
	    	if(j == 0){
	    		$('#'+v_form).prepend("<option value='"+list_month[j]+"'>"+list_month[j]+"</option>");
	    	}else{
	    		$('#'+v_form+' option:eq('+(j-1)+')').after("<option value='"+list_month[j]+"'>"+list_month[j]+"</option>");
	    	}
	    }
	    
	    return;
	}
	
	/*기간(년)변경_FROM*/
	$("#sch_bas_y_from").ready(function() {
		
		$("#sch_bas_y_from").change(function() {
			var v_sch_bas_y_from = $("#sch_bas_y_from").val();
			sch_month(v_sch_bas_y_from,'sch_bas_m_from','from'); //월조회
		});		
	});
	
	/*기간(년)변경_TO*/
	$("#sch_bas_y_to").ready(function() {
		
		$("#sch_bas_y_to").change(function() {
			var v_sch_bas_y_to = $("#sch_bas_y_to").val();
			sch_month(v_sch_bas_y_to,'sch_bas_m_to','to'); //월조회
		});		
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"기준년월",Type:"Text",Width:170,Align:"Center",SaveName:"bas_ym",MinWidth:60,Edit:false},
			{Header:"KRI 발생 건수",Type:"Text",Width:170,Align:"Center",SaveName:"kri_nvl",MinWidth:60,Edit:false}
		];
		
		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		//컬럼의 너비 조정
		//mySheet.FitColWidth();
		
		//doAction('search');
		doAction('search2');
	}
	
	/*Sheet2 기본 설정 */
	function initIBSheet2() {
		//시트 초기화
		mySheet2.Reset();
		
		var initData2 = {};
		
		initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
		initData2.Cols = [
			{Header:"COL1",Type:"Text",Width:60,Align:"Center",SaveName:"col1",MinWidth:60,Edit:false},
			{Header:"COL2",Type:"Text",Width:60,Align:"Center",SaveName:"col2",MinWidth:60,Edit:false},
			{Header:"COL3",Type:"Text",Width:60,Align:"Center",SaveName:"col3",MinWidth:60,Edit:false},
			{Header:"COL4",Type:"Text",Width:60,Align:"Center",SaveName:"col4",MinWidth:60,Edit:false},
			{Header:"COL5",Type:"Text",Width:60,Align:"Center",SaveName:"col5",MinWidth:60,Edit:false},
			{Header:"COL6",Type:"Text",Width:60,Align:"Center",SaveName:"col6",MinWidth:60,Edit:false},
			{Header:"COL7",Type:"Text",Width:60,Align:"Center",SaveName:"col7",MinWidth:60,Edit:false},
			{Header:"COL8",Type:"Text",Width:60,Align:"Center",SaveName:"col8",MinWidth:60,Edit:false},
			{Header:"COL9",Type:"Text",Width:60,Align:"Center",SaveName:"col9",MinWidth:60,Edit:false},
			{Header:"COL10",Type:"Text",Width:60,Align:"Center",SaveName:"col10",MinWidth:60,Edit:false}
		];
		
		IBS_InitSheet(mySheet2,initData2);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		mySheet2.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet2.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		//컬럼의 너비 조정
		//mySheet.FitColWidth();
		mySheet2.FitColWidth();
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
				case "searchForm":  //데이터 조회
					setForm1(); //당월발생현황
					//setForm2(); //최근1년KRI발생현황(등급)
					break;
				case "search":  //데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR011004");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);			
				case "search2":  //데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR011004");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;				
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
// 					mySheet.Down2ExcelBuffer(true);
// 					setExcelDownCols("0|1");
// 					mySheet.Down2Excel(excel_params);
/*
					setExcelDownCols("0|1|2|3|4|5|6|7|8|9");
					mySheet2.Down2Excel(excel_params);
					*/
// 					mySheet.Down2ExcelBuffer(false);

					excel_down();
					break;
			}
		}
		
		function excel_down(){
			showLoadingWs(); // 프로그래스바 활성화
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

		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(mySheet.RowCount() > 0){
					mySheet_OnClick(1);
				}
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(mySheet2.GetCellValue(1,"col1") == -1){
					$("#pool_cnt2").text("0");
					return;
				}
				
				mySheet2.SetCellValue(0,"col1",mySheet2.GetCellValue(1,"col1"));
				mySheet2.SetCellValue(0,"col2",mySheet2.GetCellValue(1,"col2"));
				mySheet2.SetCellValue(0,"col3",mySheet2.GetCellValue(1,"col3"));
				mySheet2.SetCellValue(0,"col4",mySheet2.GetCellValue(1,"col4"));
				mySheet2.SetCellValue(0,"col5",mySheet2.GetCellValue(1,"col5"));
				mySheet2.SetCellValue(0,"col6",mySheet2.GetCellValue(1,"col6"));
				mySheet2.SetCellValue(0,"col7",mySheet2.GetCellValue(1,"col7"));
				mySheet2.SetCellValue(0,"col8",mySheet2.GetCellValue(1,"col8"));
				mySheet2.SetCellValue(0,"col9",mySheet2.GetCellValue(1,"col9"));
				mySheet2.SetCellValue(0,"col10",mySheet2.GetCellValue(1,"col10"));

				for(var i=0; i<10; i++){
					if(mySheet2.GetCellValue(1,"col"+(i+1)) == ""){
						mySheet2.SetColHidden([{Col:"col"+(i+1), Hidden:true}]);	
					}
				}

				$("#pool_cnt2").text((mySheet2.RowCount()));

				mySheet2.FitColWidth();
				
				//mySheet2.SetRowHidden(1,true);
				mySheet2.RowDelete(1,0);
			}
			
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			if(Row >= mySheet.GetDataFirstRow()){
				initIBSheet2();
				
				$('#sch2_bas_ym').val(mySheet.GetCellValue(Row,"bas_ym")); //기준년월
				
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR011005");
				
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			}
		}
		
		// 조직검색 완료
		function orgSearchEnd(brc, brnm){
			$("#brc").val(brc);
			$("#brcnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
		
 		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('searchForm');
				return true;
			}else{
				return true;
			}
		}
		</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<!-- 팝업 -->	
	<article class="popup modal block">
			<div class="p_frame w1100">
				<div class="p_head">
					<h1 class="title">KRI 입력 결과 상세 조회</h1>
				</div>
				<div class="p_body">
					<div class="p_wrap">
						<form name="ormsForm" id="ormsForm">
							<input type="hidden" id="path" name="path" />
							<input type="hidden" id="process_id" name="process_id" />
							<input type="hidden" id="commkind" name="commkind" />
							<input type="hidden" id="method" name="method" />
				
							<input type="hidden" id="rki_id" name="rki_id" /> <!-- KRI한도내역 -->
							<input type="hidden" id="all_gubun" name="all_gubun" /> <!-- 전행구분 -->
							
							<input type="hidden" id="sch2_bas_ym" name="sch2_bas_ym" /> <!-- 기준년월 -->
							<input type="hidden" id="hofc_bizo_dsc" name="hofc_bizo_dsc" value="<%=hofc_bizo_dsc%>" />
							<!-- 조회 -->
							<div class="box box-search">
								<div class="box-body">
									<div class="wrap-search">
										<table>
											<tbody>
												<tr>
													<th>평가년월</th>
													<td>
														<input type="text" class="form-control w100" id="bas_ym" name="bas_ym" readonly="readonly" value="" />
													</td>
													<th>지표명</th>
													<td>
														<input type="text" class="form-control w200" id="rkinm" name="rkinm" readonly="readonly" value=""  onkeypress="EnterkeySubmit();">
													</td>
													<th>적용부서</label></th>
													<td class="form-inline">
														<div class="input-group">
															<input type="hidden" class="form-control" id="brc" name="brc" value=""> <!-- 000026 : 전행 -->
															<input type="text" class="form-control w120" id="brcnm" name="brcnm" value="" readonly="readonly">
															<div class="input-group-btn">
																<button type="button" class="btn btn-default ico fl" onclick="schOrgPopup('brcnm', 'orgSearchEnd');">
																	<i class="fa fa-search"></i><span class="blind">검색</span>
																</button>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div><!-- .wrap-search -->
								</div><!-- .box-body //-->
								<div class="box-footer">
									<button type="button" class="btn btn-primary search" onClick="javascript:doAction('searchForm');">조회</button>
								</div>
							</div><!-- .box-search //-->
							<!-- 조회 //-->
							
									
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">KRI 평가 결과</h2>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width:100px" />
									<col>
								</colgroup>
								<tbody class="center">
									<tr>
										<th rowspan="2">당월 발생 현황</th>
										<th>KRI 지표 값</th>
										<th>KRI 등급</th>
										<th>허용한도 방식</th>
										<th>이동평균값</th>
										<th>1차한도(Yellow)</th>
										<th>2차한도(Red)</th>
										<th>전행평균</th>
									</tr>
									<tr>
										<td id="kri_nvl"></td>
										<td id="kri_grdnm"></td>
										<td id="kri_lmt_dsc_nm"></td>
										<td id="kri_avl"></td>
										<td id="sc1_max_trh"></td>
										<td id="sc2_max_trh"></td>
										<td id="ryr1_avl"></td>
									</tr>
								</tbody>
							</table>
							<table>
								<colgroup>
									<col style="width: 100px;">
									<col>
								</colgroup>
								<tbody class="center">
									<tr>
										<th rowspan="2">최근1년 KRI<br>발생 현황(등급)</th>
										<th id="bas_ym12"></th>
										<th id="bas_ym11"></th>
										<th id="bas_ym10"></th>
										<th id="bas_ym9"></th>
										<th id="bas_ym8"></th>
										<th id="bas_ym7"></th>
										<th id="bas_ym6"></th>
										<th id="bas_ym5"></th>
										<th id="bas_ym4"></th>
										<th id="bas_ym3"></th>
										<th id="bas_ym2"></th>
										<th id="bas_ym1"></th>
										<th colspan="2">1년 평균 값</th>
									</tr>
									<tr>
										<td id="kri_nvl12"></td>
										<td id="kri_nvl11"></td>
										<td id="kri_nvl10"></td>
										<td id="kri_nvl9"></td>
										<td id="kri_nvl8"></td>
										<td id="kri_nvl7"></td>
										<td id="kri_nvl6"></td>
										<td id="kri_nvl5"></td>
										<td id="kri_nvl4"></td>
										<td id="kri_nvl3"></td>
										<td id="kri_nvl2"></td>
										<td id="kri_nvl1"></td>
										<td colspan="2" id="ryr1_avl2"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
						
						<!-- 
						조회
							<div class="box box-search">
								<div class="box-body">
									<div class="wrap-search">
										<table>
											<tbody>
												<tr>
													<th scope="row"><label for="input03" class="control-label">기간설정</label></th>
													<td>
														<span class="select">
															<select class="form-control w100" id="sch_bas_y_from" name="sch_bas_y_from"></select>
														</span>
													</td>
													<td>
														<span class="select">
															<select class="form-control w80" id="sch_bas_m_from" name="sch_bas_m_from"></select>
														</span>
													</td>
													<td>
														 <span class="input-group-addon ib mr10"> ~ </span> 
													</td>
													<td>
														<span class="select">
															<select class="form-control w100" id="sch_bas_y_to" name="sch_bas_y_to"></select>
														</span>
													</td>
													<td>
														<span class="select">
															<select class="form-control w80" id="sch_bas_m_to" name="sch_bas_m_to"></select>
														</span>
													</td>
												</tr>
											</tbody>
										</table>
									</div>.wrap-search
								</div>.box-body //
								<div class="box-footer">
									<button id="btn_search" type="button" class="btn btn-primary search" onClick="javascript:doAction('search');">조회</button>
								</div>
							</div>.box-search //
							조회 //
							 -->
						</form>	
						
						<section class="box box-grid">  
							<div class="box-header">
								<div class="area-tool">
									<div class="area-term">
										<span class="em"><strong id="pool_cnt2">0</strong>건</span>
									</div>
								</div>
							</div>
							<div class="row">
							    <div class="col w30p">
							        <div class="wrap-grid h250">
								         <script> createIBSheet("mySheet", "100%", "100%"); </script>
							        </div>
							    </div>
							    <div class="col w70p">
							        <div class="wrap-grid h250">
								         <script> createIBSheet("mySheet2", "100%", "100%"); </script>
							        </div>
							    </div>
							</div>
						</section>
						
					</div><!-- .p_wrap //-->
				</div><!-- .p_body //-->
				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>
				<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
			</div>
		<div class="dim p_close"></div>
	</article>
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
				//$(".popup",parent.document).hide();
				$("#winORKR1601",parent.document).hide();
				event.preventDefault();
			});
		});
	</script>
</body>
</html>