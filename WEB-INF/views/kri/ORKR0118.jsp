<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0118.jsp
 Program name : KRI > KRI 평가 > KRI 전산데이터 관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.12.09
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");

ArrayList list_bas_ym = new ArrayList();
if(vLst==null) vLst = new Vector();
for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
	
	list_bas_ym.add((String)hMap.get("bas_ym"));
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<script>
	
	$(document).ready(function(){
		//사무소코드
		var brc = '<%=(String)hs.get("brc")%>';
	    $("#sch_brc").val(brc); //사무소코드
		
		// ibsheet 초기화
		initIBSheet();
		
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
	    		$('#sch_bas_y').prepend("<option value='"+uni_list_bas_y[j]+"'>"+uni_list_bas_y[j]+"</option>");
	    		sch_month(uni_list_bas_y[j],'sch_bas_m'); //월조회
	    	}else{
	    		$('#sch_bas_y option:eq('+(j-1)+')').after("<option value='"+uni_list_bas_y[j]+"'>"+uni_list_bas_y[j]+"</option>");
	    	}
	    }
		
		doAction('search');
	});
	
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
	function sch_month(paramYear, v_form){ 
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
	
	/*기간(년)변경*/
	$("#sch_bas_y").ready(function() {
		
		$("#sch_bas_y").change(function() {
			var v_sch_bas_y = $("#sch_bas_y").val();
			sch_month(v_sch_bas_y,'sch_bas_m'); //월조회
		});		
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		mySheet2.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData.Cols = [
			{Header:"소관부서",Type:"Text",Width:120,Align:"Center",SaveName:"brnm",MinWidth:60,Edit:false},
			{Header:"대상건수",Type:"AutoSum",Width:60,Align:"Center",SaveName:"cnt",MinWidth:60,Edit:false},
			{Header:"입수완료여부",Type:"Text",Width:60,Align:"Center",SaveName:"inpdt_yn",MinWidth:60,Edit:false},
			{Header:"기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:0,Edit:false,Hidden:true},
			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:0,Edit:false,Hidden:true}
		];
		
		var initData2 = {};
		
		initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
		initData2.Cols = [
			{Header:"상태",Type:"Status",Width:30,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:30,Edit:false},
			{Header:"RI-ID",Type:"Text",Width:40,Align:"Center",SaveName:"rki_id",MinWidth:40,Edit:false},
			{Header:"리스크지표명",Type:"Text",Width:60,Align:"Left",SaveName:"rkinm",MinWidth:60,Edit:false},
			{Header:"리스크지표목적",Type:"Text",Width:100,Align:"Left",SaveName:"rki_obv_cntn",MinWidth:60,Edit:false},
			{Header:"리스크지표정의",Type:"Text",Width:100,Align:"Left",SaveName:"rki_def_cntn",MinWidth:60,Edit:false},
			{Header:"리스크지표값",Type:"Text",Width:50,Align:"Center",SaveName:"kri_nvl",MinWidth:50,Edit:true},
			{Header:"입수여부",Type:"Text",Width:40,Align:"Center",SaveName:"inpdt_yn",MinWidth:40,Edit:false},
			{Header:"RI상세정보",Type:"Html",Width:40,Align:"Center",SaveName:"goORKR0201",MinWidth:40},
			{Header:"데이터확인",Type:"Html",Width:40,Align:"Center",SaveName:"goORKR1901",MinWidth:40},
			{Header:"변경이력",Type:"Html",Width:40,Align:"Center",SaveName:"goORKR2001",MinWidth:40},
			{Header:"기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:0,Edit:false,Hidden:true},
			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:0,Edit:false,Hidden:true}
		];
		
		IBS_InitSheet(mySheet,initData);
		IBS_InitSheet(mySheet2,initData2);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(3);
		//mySheet2.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		mySheet2.SetSelectionMode(4);
		
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		//컬럼의 너비 조정
		mySheet.FitColWidth();
		mySheet2.FitColWidth();
		
		mySheet.SetSumValue(0, "합계");
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
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR011802");
				
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
			case "save":		//저장
				var f = document.ormsForm;
				mySheet2.DoSave(url + "?method=Main&commkind=kri&process_id=ORKR011804");
			
				break; 
			case "ORKR0201":      //신규
				$("#ifrKriMod").attr("src","about:blank");
				$("#winORKR0201").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popORKR0201,1);
				
				break; 
			case "ORKR1901":      //신규
				$("#ifrKriDtl").attr("src","about:blank");
				$("#winORKR1901").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popORKR1901,1);
				
				break;
			case "ORKR2001":      //신규
				$("#ifrKriHis").attr("src","about:blank");
				$("#winORKR2001").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(popORKR2001,1);
				
				break;
		}
	}
	
	function popORKR0201(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORKR010201";
		f.target = "ifrKriMod";
		f.submit();
	}
	
	function popORKR1901(){			
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
        f.process_id.value="ORKR011901";
		f.target = "ifrKriDtl";
		f.submit();
	}
	
	function popORKR2001(){
		var f = document.ormsForm;
		f.method.value="Main";
        f.commkind.value="kri";
        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR012001";
			f.target = "ifrKriHis";
			f.submit();
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#jrdt_brc").val(mySheet.GetCellValue(Row,"brc")); //사무소코드
				$("#brc").val(mySheet.GetCellValue(Row,"brc")); //사무소코드
				
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR011803");			
				
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			}
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet2.GetDataFirstRow()){
				$("#grd2_bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
				$("#grd2_brc").val(mySheet2.GetCellValue(Row,"brc"));
				$("#grd2_rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
			}
		}
		
		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				/*if(mySheet2.ColSaveName(Col) != "kri_nvl"){
					$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
					doAction('ORKR0201');
				}*/
				
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet_OnClick(1); //첫행 클릭
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function mySheet2_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet2.FitColWidth();
		}
		
		function mySheet2_OnRowSearchEnd(Row) {
			mySheet2.SetCellText(Row,"goORKR0201",'<button class="btn btn-xs btn-default" type="button" onclick="goORKR0201('+Row+')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
			mySheet2.SetCellValue(Row,"status","R");
			mySheet2.SetCellText(Row,"goORKR1901",'<button class="btn btn-xs btn-default" type="button" onclick="goORKR1901('+Row+')"> <span class="txt">확인</span><i class="fa fa-caret-right ml5"></i></button>')
			mySheet2.SetCellValue(Row,"status","R");
			mySheet2.SetCellText(Row,"goORKR2001",'<button class="btn btn-xs btn-default" type="button" onclick="goORKR2001('+Row+')"> <span class="txt">이력</span><i class="fa fa-caret-right ml5"></i></button>')
			mySheet2.SetCellValue(Row,"status","R")
		}
		
		function goORKR0201(Row) {
			$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
			doAction('ORKR0201');
		}
		
		function goORKR1901(Row) {
			$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
			
			if(mySheet2.GetCellValue(Row,"inpdt_yn") == "N"){
// 				alert("데이터가 존재하지 않습니다.");
// 				return;
			}
			doAction('ORKR1901');
		}
		
		function goORKR2001(Row) {
			$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
			
			doAction('ORKR2001');
		}
		
		function mySheet2_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		        //doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}		
		</script>
	
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<div class="content">
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="sch_brc" name="sch_brc" />
			<input type="hidden" id="rki_id" name="rki_id" />
			<input type="hidden" id="jrdt_brc" name="jrdt_brc" />
			<input type="hidden" id="brc" name="brc">
			<input type="hidden" id="grd2_bas_ym" name="grd2_bas_ym">
			<input type="hidden" id="grd2_rki_id" name="grd2_rki_id">
			<input type="hidden" id="grd2_brc" name="grd2_brc">
	
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가년월</th>
									<td class="form-inline">
										<span class="select">
											<select class="form-control w100" id="sch_bas_y" name="sch_bas_y"></select>
										</span>
										<span class="select">
											<select class="form-control w80" id="sch_bas_m" name="sch_bas_m"></select>
										</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- .wrap-search -->
				</div><!-- .box-body //-->
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- .box-search //-->
			</form>

			<div class="box box-grid">
				<div class="box-body">
					<div class="row ">
					    <div class="col col-xs-4">
					        <div class="wrap-grid h500">
						         <script> createIBSheet("mySheet", "100%", "100%"); </script>
					        </div>
					    </div>
					    <div class="col col-xs-8">
					        <div class="wrap-grid h500">
						         <script> createIBSheet("mySheet2", "100%", "100%"); </script>
					        </div>
					    </div>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button type="button" id="save" class="btn btn-primary" onclick="javascript:doAction('save')">저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- popup -->
	<div id="winORKR3001" class="popup modal">
		<iframe name="ifrORKR3001" id="ifrORKR3001" src="about:blank"></iframe>
	</div>
	<div id="winORKR0201" class="popup modal">
		<iframe name="ifrKriMod" id="ifrKriMod" src="about:blank"></iframe>
	</div>
	<div id="winORKR1901" class="popup modal">
		<iframe name="ifrKriDtl" id="ifrKriDtl" src="about:blank"></iframe>
	</div>
	<div id="winORKR2001" class="popup modal">
		<iframe name="ifrKriHis" id="ifrKriHis" src="about:blank"></iframe>
	</div>
</body>
</html>