<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0101.jsp
 Program name : 개별 재무제표 매핑관리
 Description  : MSR-02
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	SysDateDao dao = new SysDateDao(request);
	String sysdate = dao.getSysdate();
	//System.out.println("sysdate:"+sysdate);
	int iyear = Integer.parseInt(sysdate.substring(0,4));
	int imonth = Integer.parseInt(sysdate.substring(4,6));
	while(true){
		imonth --;
		if(imonth==0){
			iyear--;
			imonth=12;
		}
		if(imonth==3 || imonth==6 || imonth==9 || imonth==12){
			break;
		}
	}
	String st_bas_ym = ""+(iyear-1)+"-";
	String ed_bas_ym = ""+(iyear)+"-";
	if(imonth>9){
		st_bas_ym += imonth;
		ed_bas_ym += imonth;
	}else{
		st_bas_ym += ("0" + imonth);
		ed_bas_ym += ("0" + imonth);
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>개별 재무제표 매핑관리</title>
	<script>
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet1();
			initIBSheet2();
			initIBSheet3();
			initIBSheet4();
		});
		
		/*************************************************************************************************/
		/* mySheet1 관련 처리                                                                                                                                                                                                                       */
		/*************************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.Cols = [
			 	{Header:"삭제",Type:"DelCheck",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50,Edit:1},
				{Header:"기준년월",Type:"Text",Width:120,Align:"Center",SaveName:"bas_ym",MinWidth:60,Edit:0,Format:"yyyy-MM"},
				{Header:"파일명",Type:"Text",Width:680,Align:"Left",SaveName:"apflnm",MinWidth:150,Edit:0},
				{Header:"등록자",Type:"Text",Width:0,Align:"Center",SaveName:"rg_eno",MinWidth:0, Hidden:true},
				{Header:"등록일",Type:"Date",Width:120,Align:"Center",SaveName:"rg_dt",MinWidth:60,Edit:0},
				{Header:"상태",Type:"Html",Width:120,Align:"Center",SaveName:"rg_ynnm",MinWidth:60,Edit:0},
				{Header:"입력결과조회",Type:"Html",Width:123,Align:"Center",SaveName:"result_search",MinWidth:60,Edit:0},
				{Header:"업로드일련번호",Type:"Text",Width:50,Align:"Center",HAlign:"Center",SaveName:"upload_sqno",MinWidth:40,Edit:false, Hidden:true},
				{Header:"상태",Type:"Status",Width:50,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:40,Edit:false, Hidden:true}
			];
			
			IBS_InitSheet(mySheet1,initData);
			//필터표시
			//mySheet1.ShowFilterRow();  
			//mySheet1.SetEditable(0);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet1);
			
			mySheet1_doAction('search');
			//mySheet1.SetTheme("WHM", "ModernWhite");
			//mySheet1.SetTheme("GM", "Main");
		}
		
		function mySheet1_OnRowSearchEnd (Row) {
			if(mySheet1.GetCellValue(Row,"apflnm")==""){
				/* mySheet1.SetCellText(Row,"status",'<span class="status label label-danger">미등록</span>'); */
				mySheet1.SetRowEditable(Row, false); //등록 안된경우 삭제체크 제어불가
			}else{
				/* mySheet1.SetCellText(Row,"status",'<span class="status label label-default">등록완료</span>'); */
				mySheet1.SetCellText(Row,"result_search",'<button class="btn btn-xs btn-default" type="button" onclick="mySheet1_result_search('+mySheet1.GetCellValue(Row,"bas_ym")+')"><span class="txt mr10">상세보기&nbsp;&nbsp;</span><i class="fa fa-angle-right"></i></button>');
				mySheet1.SetCellValue(Row,"status","R");
			}
		}
		
		function getRow(sheet,key,value) {
			for(var j=sheet.GetDataFirstRow(); j<=sheet.GetDataLastRow(); j++){
				if(sheet.GetCellValue(j,key)==value){
					return j;
				}
			}
		}
		
		function mySheet1_result_search(bas_ym){
			var Row = getRow(mySheet1,"bas_ym",bas_ym);
			$("#bas_ym").val(mySheet1.GetCellValue(Row,"bas_ym"));
			$("#upload_sqno").val(mySheet1.GetCellValue(Row,"upload_sqno")); //업로드일련번호
			mySheet2_doAction('search');
			mySheet3_doAction('search');
			mySheet4_doAction('search');
		}
		
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 

		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet1.GetDataFirstRow()){
				$("#bas_ym").val(mySheet1.GetCellValue(Row,"bas_ym"));
			}
		}

		function mySheet1_OnChange(Row,col,value){
			if(Row >= mySheet1.GetDataFirstRow()){
				$("#bas_ym").val(mySheet1.GetCellValue(Row,"bas_ym"));
			}
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet1_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				mySheet1_doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				mySheet1_doAction("loadexcel");
			}
		}
		
		/*Sheet 각종 처리*/
		function mySheet1_doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010102");
					$("form[name=ormsForm] [name=sch_st_bas_ym]").val(($("form[name=ormsForm] [name=st_bas_ym]").val()).replace("-",""));
					$("form[name=ormsForm] [name=sch_ed_bas_ym]").val(($("form[name=ormsForm] [name=ed_bas_ym]").val()).replace("-",""));
/*					
					var f = document.doForm;
			        f.action=url;
					f.target = "_self";
					f.submit();
*/					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet1.RemoveAll();
					initIBSheet();
					break;
				case "del":		//삭제 처리
					//mySheet1_delRisk();
					var f = document.ormsForm;
					
					var sRow = mySheet1.FindStatusRow("D"); //삭제
					var arrow = sRow.split(";");
					
					if(arrow == ""){
						alert("선택된 항목이 없습니다.");
						return;
					}
					
					mySheet1.DoSave(url + "?method=Main&commkind=msr&process_id=ORMR010104");
					break; 
				case "down2excel":
					
					//setExcelDownCols("1|2|3|4");
					mySheet1.Down2Excel(excel_params);

					break;
			}
		}

		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			$("#pool_cnt").text(mySheet1.RowCount()); 
			//$("#kbr_nm").trigger("focus");
		}

		function mySheet1_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장되었습니다.");  // 저장 성공 메시지
		        mySheet1_doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}

		/*************************************************************************************************/
		/* mySheet2 관련 처리                                                                                                                                                                                                                       */
		/*************************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.Cols = [
			 	{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:0,Hidden:true},
				{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"acc_tpc",MinWidth:0,Hidden:true},
			 	{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"up_acc_sbj_cnm",MinWidth:0,Hidden:true},
			 	{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"biz_ix_lv1_nm",MinWidth:0,Hidden:true},
			 	{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"biz_ix_lv2_nm",MinWidth:0,Hidden:true},
				{Header:"BS/PL구분",Type:"Text",Width:100,Align:"Center",SaveName:"acc_tpc_nm",MinWidth:60,Edit:0},
				{Header:"입력구분",Type:"Text",Width:120,Align:"Center",SaveName:"hd_inp_dsnm",MinWidth:60,Edit:0},
				{Header:"기표여부",Type:"Text",Width:120,Align:"Center",SaveName:"acc_dsnm",MinWidth:60,Edit:0},
				{Header:"번호",Type:"Text",Width:100,Align:"Center",SaveName:"acc_sqno",MinWidth:60,Edit:0},
				{Header:"레벨",Type:"Text",Width:100,Align:"Center",SaveName:"lvl_no",MinWidth:60,Edit:0},
				{Header:"상위계정과목코드",Type:"Text",Width:120,Align:"Center",SaveName:"up_acc_sbj_cnm",MinWidth:60,Edit:0,Hidden:true},
				{Header:"계정과목코드",Type:"Text",Width:120,Align:"Center",SaveName:"acc_sbj_cnm",MinWidth:60,Edit:0},
				{Header:"계정과목명",Type:"Text",Width:400,Align:"Left",SaveName:"acc_sbjnm",MinWidth:150,Edit:0},
				{Header:"연결기준금액",Type:"Int",Width:150,Align:"Right",SaveName:"acc_am1",MinWidth:60,Edit:0,Format:"#,##0"},
				{Header:"수협은행금액",Type:"Int",Width:150,Align:"Right",SaveName:"acc_am2",MinWidth:60,Edit:0,Format:"#,##0"},
				{Header:"수협MFI미얀마금액",Type:"Int",Width:150,Align:"Right",SaveName:"acc_am3",MinWidth:60,Edit:0,Format:"#,##0"},
				{Header:"영업지수등록",Type:"Html",Width:123,Align:"Center",SaveName:"bi_reg",MinWidth:60,Edit:0}
			];
			
			IBS_InitSheet(mySheet2,initData);
			//필터표시
			//mySheet2.ShowFilterRow();  
			//mySheet2.SetEditable(0);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet2);
			
			//mySheet2_doAction('search');
			//mySheet2.SetTheme("WHM", "ModernWhite");
			//mySheet2.SetTheme("GM", "Main");
		}
		
		function mySheet2_OnRowSearchEnd (Row) {
			mySheet2.SetCellText(Row,"bi_reg",'<button class="btn btn-xs btn-default" type="button" onclick="mySheet2_bi_reg(\''+mySheet2.GetCellValue(Row,"acc_sbj_cnm")+'\')"><span class="txt mr10">영업지수등록&nbsp;&nbsp;</span><i class="fa fa-angle-right"></i></button>');
		}
		
		function mySheet2_bi_reg(acc_sbj_cnm){
			var Row = getRow(mySheet2,"acc_sbj_cnm",acc_sbj_cnm);
			$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
			$("#acc_sbj_cnm").val(mySheet2.GetCellValue(Row,"acc_sbj_cnm")); //계정과목코드
			$("#acc_sbjnm").val(mySheet2.GetCellValue(Row,"acc_sbjnm")); //계정과목명
			$("#lvl_no").val(mySheet2.GetCellValue(Row,"lvl_no")); //레벨
			$("#up_acc_sbj_cnm").val(mySheet2.GetCellValue(Row,"up_acc_sbj_cnm")); //상위계정과목코드
			$("#biz_ix_lv1_nm").val(mySheet2.GetCellValue(Row,"biz_ix_lv1_nm")); //상위계정과목코드
			$("#biz_ix_lv2_nm").val(mySheet2.GetCellValue(Row,"biz_ix_lv2_nm")); //상위계정과목코드
			$("#acc_tpc").val(mySheet2.GetCellValue(Row,"acc_tpc")); //계정유형코드
			
			
			//$("#sbj_cntn").val(mySheet2.GetCellValue(Row,"sbj_cntn")); //과목내용
			
			
			$("#winORMR0102").show();
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="msr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORMR010201";
			f.target = "ifrORMR0102";
			f.mode.value = "R"; 
			f.submit();
			//영업지수등록팝업
		}
		
		/* function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			if(Row >= mySheet2.GetDataFirstRow()){
				//alert(mySheet2.GetCellValue(Row,"rkp_id"));
				$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
				$("#acc_sbj_cnm").val(mySheet2.GetCellValue(Row,"acc_sbj_cnm"));
				//$("#winRskMod").show();
				//modRisk();
			}
		}
		
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet2.GetDataFirstRow()){
				$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
				$("#acc_sbj_cnm").val(mySheet2.GetCellValue(Row,"acc_sbj_cnm"));
			}
		} */
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet2_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				mySheet2_doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				mySheet2_doAction("loadexcel");
			}
		}
		
		/*Sheet 각종 처리*/
		function mySheet2_doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010103");
					$("form[name=ormsForm] [name=acc_tpc]").val("");
					$("form[name=ormsForm] [name=mapping_yn]").val("N");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet2.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					//사용안함
					//setExcelFileName("측정대상 계정과목 영업지수 미매핑 목록");
					//setExcelDownCols("2|3|4|5|6|7|8");
					//mySheet2.Down2Excel(excel_params);

					break;
			}
		}

		function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			//$("#pool_cnt").text(mySheet2.RowCount()); 
		}

		/*************************************************************************************************/
		/* mySheet3 관련 처리                                                                                                                                                                                                                       */
		/*************************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet3() {
			//시트 초기화
			mySheet3.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.Cols = [
			 			 	{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:0,Hidden:true},
							{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"acc_tpc",MinWidth:0,Hidden:true},
							{Header:"계정구분",Type:"Text",Width:120,Align:"Center",SaveName:"acc_dsnm",MinWidth:60,Edit:0},
							{Header:"번호",Type:"Text",Width:100,Align:"Center",SaveName:"acc_sqno",MinWidth:60,Edit:0},
							{Header:"레벨",Type:"Text",Width:100,Align:"Center",SaveName:"lvl_no",MinWidth:60,Edit:0},
							{Header:"입력구분",Type:"Text",Width:120,Align:"Center",SaveName:"hd_inp_dsnm",MinWidth:60,Edit:0},
							{Header:"계정과목코드",Type:"Text",Width:120,Align:"Center",SaveName:"acc_sbj_cnm",MinWidth:60,Edit:0},
							{Header:"계정과목명",Type:"Text",Width:400,Align:"Left",SaveName:"acc_sbjnm",MinWidth:150,Edit:0},
							{Header:"연결기준금액",Type:"Int",Width:120,Align:"Right",SaveName:"acc_am1",MinWidth:60,Edit:0,Format:"#,##0"},
							{Header:"수협은행금액",Type:"Int",Width:120,Align:"Right",SaveName:"acc_am2",MinWidth:60,Edit:0,Format:"#,##0"},
							{Header:"수협MFI미얀마금액",Type:"Int",Width:120,Align:"Right",SaveName:"acc_am3",MinWidth:60,Edit:0,Format:"#,##0"}
			];
			
			IBS_InitSheet(mySheet3,initData);
			//필터표시
			//mySheet3.ShowFilterRow();  
			//mySheet3.SetEditable(0);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet3.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet3.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet3);
			
			//mySheet3_doAction('search');
			//mySheet3.SetTheme("WHM", "ModernWhite");
			//mySheet3.SetTheme("GM", "Main");
		}
		
		/* function mySheet3_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			if(Row >= mySheet3.GetDataFirstRow()){
				$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
				$("#acc_sbj_cnm").val(mySheet2.GetCellValue(Row,"acc_sbj_cnm"));
			}
		}
		
		
		function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet3.GetDataFirstRow()){
				$("#bas_ym").val(mySheet2.GetCellValue(Row,"bas_ym"));
				$("#acc_sbj_cnm").val(mySheet2.GetCellValue(Row,"acc_sbj_cnm"));
			}
		} */
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet3_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				mySheet3_doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				mySheet3_doAction("loadexcel");
			}
		}
		
		/*Sheet 각종 처리*/
		function mySheet3_doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010103");
					$("form[name=ormsForm] [name=acc_tpc]").val("01");//BS
					$("form[name=ormsForm] [name=mapping_yn]").val("Y");
					mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet3.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					//setExcelFileName("개별재무제표 입력결과(BS).xlsx");
					//setExcelDownCols("2|3|4|5|6|7|8");
					var excel_params  = "";
					excel_params = {FileName:"개별재무제표 입력결과(BS).xlsx", Merge:"1", DownCols:"2|3|4|5|6|7|8|9|10"};
					mySheet3.Down2Excel(excel_params);

					break;
			}
		}

		function mySheet3_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			$("#pool_cnt").text(mySheet3.RowCount()); 
			//$("#kbr_nm").trigger("focus");
		}

		/*************************************************************************************************/
		/* mySheet4 관련 처리                                                                                                                                                                                                                       */
		/*************************************************************************************************/
		/*Sheet 기본 설정 */
		function initIBSheet4() {
			//시트 초기화
			mySheet4.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"search|init|resize" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				 			 	{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:0,Hidden:true},
								{Header:"",Type:"Text",Width:0,Align:"Center",SaveName:"acc_tpc",MinWidth:0,Hidden:true},
								{Header:"계정구분",Type:"Text",Width:120,Align:"Center",SaveName:"acc_dsnm",MinWidth:60,Edit:0},
								{Header:"번호",Type:"Text",Width:100,Align:"Center",SaveName:"acc_sqno",MinWidth:60,Edit:0},
								{Header:"레벨",Type:"Text",Width:100,Align:"Center",SaveName:"lvl_no",MinWidth:60,Edit:0},
								{Header:"입력구분",Type:"Text",Width:120,Align:"Center",SaveName:"hd_inp_dsnm",MinWidth:60,Edit:0},
								{Header:"계정과목코드",Type:"Text",Width:120,Align:"Center",SaveName:"acc_sbj_cnm",MinWidth:60,Edit:0},
								{Header:"계정과목명",Type:"Text",Width:400,Align:"Left",SaveName:"acc_sbjnm",MinWidth:150,Edit:0},
								{Header:"연결기준금액",Type:"Int",Width:120,Align:"Right",SaveName:"acc_am1",MinWidth:60,Edit:0,Format:"#,##0"},
								{Header:"은행개별금액",Type:"Int",Width:120,Align:"Right",SaveName:"acc_am2",MinWidth:60,Edit:0,Format:"#,##0"},
								{Header:"수협MFI미얀마금액",Type:"Int",Width:120,Align:"Right",SaveName:"acc_am3",MinWidth:60,Edit:0,Format:"#,##0"}
			];
			
			IBS_InitSheet(mySheet4,initData);
			//필터표시
			//mySheet4.ShowFilterRow();  
			//mySheet4.SetEditable(0);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet4.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet4.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet4);
			
			//mySheet4_doAction('search');
			//mySheet4.SetTheme("WHM", "ModernWhite");
			//mySheet4.SetTheme("GM", "Main");
		}

		//시트 ContextMenu선택에 대한 이벤트
		function mySheet4_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				mySheet4_doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				mySheet4_doAction("loadexcel");
			}
		}
		
		/*Sheet 각종 처리*/
		function mySheet4_doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010103");
					$("form[name=ormsForm] [name=acc_tpc]").val("02");//PL
					$("form[name=ormsForm] [name=mapping_yn]").val("Y");
					mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "down2excel":
					//setExcelFileName("개별재무제표 입력결과(PL).xlsx");
					//setExcelDownCols("2|3|4|5|6|7|8");
					var excel_params  = "";
					excel_params = {FileName:"개별재무제표 입력결과(PL).xlsx", Merge:"1", DownCols:"2|3|4|5|6|7|8|9|10"};
					mySheet4.Down2Excel(excel_params);

					break;
			}
		}

		/*************************************************************************************************/
		/* 기타 처리                                                                                                                                                                                                                       */
		/*************************************************************************************************/
		$("#fileList1").ready(function() {
			$("#fileList1").change(function() {
				if($("#fileList1").val()=="") return;
				var f = document.uploadform;
				WP.clearParameters();
				
				var furl = "<%=System.getProperty("contextpath")%>/fsupload.do";
		        var inputData = new FormData(f);
		        var fileList = $("#fileList1").val();

				showLoadingWs(); // 프로그래스바 활성화
				WP.formdataload(furl, inputData,{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S"){
							alert("파일 전송에 성공 하였습니다.\n파일이름:"+result.file_name+"\n"+"기준년월:"+result.bas_ym.substring(0,4)+"-"+result.bas_ym.substring(4,6));
							
							//등록 후 등록파일 정보로 재조회
							$("#st_bas_ym").val(result.bas_ym.substring(0,4)+"-"+result.bas_ym.substring(4,6));
							$("#ed_bas_ym").val(result.bas_ym.substring(0,4)+"-"+result.bas_ym.substring(4,6));
							mySheet1_doAction('search');
						} else if(result!='undefined' && result.rtnCode!="S"){
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
			});
		});
		
		function down2Excel(){
			//myChart1.Down2Image({FileName:"ChartImage", Type:IBExportType.PNG, Width:835, Url:"<%=System.getProperty("contextpath")%>/Jsp.do?path=/rsa/ORRC2105"});
			var f = document.ormsForm;

			
			showLoadingWs(); // 프로그래스바 활성화
			$.fileDownload("/excelxWrite.do", {
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
		
		function uploadFile(){
			$("#fileList1").val("");
			$("#fileList1").trigger("click");
		}
		
		function excel_down(){
			//for(var i =0; i<$(".nav-tabs").children("li").length;i++){
			//for(var tag_li in $(".nav-tabs").children("li")){
			//	if(tag_li.hasClass("active")) 
			//}
			
			if($($(".nav-tabs").children("li")[0]).hasClass("active")) mySheet3_doAction('down2excel'); //BS
			else mySheet4_doAction('down2excel'); //BS
		}
			
		function fileDown(){
			var f = document.tempform;
			f.action = "<%=System.getProperty("contextpath")%>/Jsp.do";
			f.target = "ifrHid";
			f.submit();
			
		}
		
	</script>
	
</head>
<body onkeyPress="return EnterkeyPass()";>
	<!-- iframe 영역 -->
	<div class="container">
		<%@ include file="../comm/header.jsp" %>

		<!-- content -->
		<div class="content">
			<form name="tempform" method="post">
		    	<input type="hidden" id="path" name="path" value="/comm/excelfile"/>
		   		<!-- <input type="hidden" id="filename" name="filename" value="개별재무제표_XXXX년 XQ_감독목적"/>-->
		   		<input type="hidden" id="filename" name="filename" value="SEP_0000Y_0Q"/>
		   		<input type="hidden" id="kor_filename" name="kor_filename" value="SEP_0000Y_0Q"/>
			</form>
			<form name="uploadform" method="post" enctype="multipart/form-data">
				<input type="file" id="fileList1" name="fileList1" style="display:none;" />
			</form>
			<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			
			<input type="hidden" id="bas_ym" name="bas_ym" value="" />
			<input type="hidden" id="acc_tpc" name="acc_tpc" value="" />
			<input type="hidden" id="mapping_yn" name="mapping_yn" value="" />
			<input type="hidden" id="upload_sqno" name="upload_sqno" value="" />
			
			<input type="hidden" id="mode" name="mode" /> <!-- 신규수정 구분(I:신규 U:수정) -->
			<input type="hidden" id="acc_sbj_cnm" name="acc_sbj_cnm" value="" />
			<input type="hidden" id="acc_sbjnm" name="acc_sbjnm" value="" />
			<input type="hidden" id="lvl_no" name="lvl_no" value="" />
			<input type="hidden" id="up_acc_sbj_cnm" name="up_acc_sbj_cnm" value="" />
			<input type="hidden" id="biz_ix_lv1_nm" name="biz_ix_lv1_nm" value="" />
			<input type="hidden" id="biz_ix_lv2_nm" name="biz_ix_lv2_nm" value="" />
			
			<!-- <input type="hidden" id="sbj_cntn" name="sbj_cntn" value="" /> -->
			
			<input type="hidden" id="sch_st_bas_ym" name="sch_st_bas_ym" />
			<input type="hidden" id="sch_ed_bas_ym" name="sch_ed_bas_ym" />
			
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>기준 년월</th>
									<td class="form-inline">
										<div class="input-group">
											<input class="form-control w80" id="st_bas_ym" name="st_bas_ym" type="text" value="<%=st_bas_ym%>">
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM','st_bas_ym');">
													<i class="fa fa-calendar"></i><span class="blind">날짜 입력</span>
												</button>
											</span>
										</div>
										<span class="txt">~</span>
										<div class="input-group">
											<input class="form-control w80" id="ed_bas_ym" name="ed_bas_ym" type="text" value="<%=ed_bas_ym%>">
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM','ed_bas_ym');">
													<i class="fa fa-calendar"></i><span class="blind">날짜 입력</span>
												</button>
											</span>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="mySheet1_doAction('search');">조회</button>
				</div>
			</div>
			<!-- //조회 -->
			
			</form>
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">개별 재무제표 매핑 관리</h2>
					<div class="area-tool">
						<span class="mr5">[템플릿 다운로드]버튼을 클릭하여 템플릿을 다운받아, 감독목적 F/S를 템플릿 양식에 따라 붙여넣어 주세요.</span>
						<button class="btn btn-default btn-xs" onclick="javascript:fileDown();">
							<i class="fa fa-download"></i>
							<span class="txt">템플릿 다운로드</span>
						</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h150">
						<script> createIBSheet("mySheet1", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button class="btn btn-primary btn-sm" type="button" onclick="uploadFile()"><i class="fa fa-upload"></i><span class="txt">등록(업로드)</span></button>
						<button class="btn btn-default btn-sm" type="button" onclick="mySheet1_doAction('del')"><i class="fa fa-minus"></i><span class="txt">등록 삭제</span></button>
					</div>
				</div>
			</section>

			<section class="box">
				<div class="box-header">
					<h3 class="box-title">계정과목 영업지수 간 미매핑 목록</h3>
					<div class="box-title md">(영업지수 등록 필요)</div>
				</div><!-- .box-header //-->
				
				<div class="box-body">
					<div class="wrap-grid h150">
						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div><!-- .wrap //-->
				</div><!-- .box-body //-->
				
			</section>

			<section class="box">
				<div class="box-header">
					<ul class="nav nav-tabs"> 	
						<li class="active"><a data-toggle="tab" href="#menu1">감독 BS</a></li>
						<li><a data-toggle="tab" href="#menu2">감독 PL</a></li>
					</ul>
					<div class="area-tool">
						<span class="btn-wrap">
							<button class="btn btn-xs btn-default" type="button"  onclick="excel_down()"><i class="ico xls"></i>엑셀 다운로드</button>
						</span>
					</div>
				</div>
				<div class="box-body">
					<div class="tab-content mt0">
						<div class="box-header">
							<div class="title">개별재무제표 입력결과</div>
						</div>
						<div id="menu1" class="tab-pane fade in active">
							<div class="box box-grid">
								<div class="box-body">
									<div class="wrap-grid h240">
										<script> createIBSheet("mySheet3", "100%", "100%"); </script>
									</div><!-- .wrap //-->
								</div><!-- .box-body //-->
							</div><!-- .box //-->
						</div><!-- .tab-pane //-->
						<div id="menu2" class="tab-pane fade">
							<div class="box box-grid">
								<div class="box-body">
									<div class="wrap-grid h240">
										<script> createIBSheet("mySheet4", "100%", "100%"); </script>
									</div><!-- .wrap //-->
								</div><!-- .box-body //-->
							</div><!-- .box //-->
						</div><!-- .tab-pane //-->
					</div><!-- .tab-content //-->
				</div><!-- .box-body //-->
			</section><!-- .box //-->
			
		</div>
		<!-- content //-->

	</div><!-- .container //-->	
	<!-- popup -->
	<div id="winORMR0102" class="popup modal">
		<iframe name="ifrORMR0102" id="ifrORMR0102" src="about:blank" ></iframe>
	</div>
	<iframe name="ifrHid" id="ifrmHid" src="about:blank"></iframe>
</body>
</html>