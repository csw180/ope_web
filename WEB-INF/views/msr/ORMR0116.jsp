<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0116.jsp
 Program name : 측정 업무보고서
 Description  : MSR-19
 Programer    : 이규탁
 Date created : 2022.07.29
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
<%

DynaForm form = (DynaForm)request.getAttribute("form");
String role_id = (String)form.get("role_id");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
String bas_ym = CommUtil.getResultString(request, "grp01", "unit01", "bas_ym");
if(vLst==null) vLst = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
    
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>운영리스크 개별 위기상황분석 결과 조회</title>
	<script>
	
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet1();
			initIBSheet2();
			initIBSheet3();
			initIBSheet4();
			initIBSheet5();
			initIBSheet6();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};
			
			var headers = [{Text:"구분|항목|유형코드|레벨|상위/기표|COA계정코드|계정과목명|변경전|변경전|변경후|변경후|결제요청일(등록/변경)|반영일", Align:"Center"}
 	    	  			  ,{Text:"구분|항목|유형코드|레벨|상위/기표|COA계정코드|계정과목명|Lv.1|Lv.2|Lv.1|Lv.2|결제요청일(등록/변경)|반영일", Align:"Center"}];

			initData.Cols = [
				{Type:"Text",Width:100,Align:"Center",SaveName:"status",MinWidth:60,Edit:false},
				{Type:"Text",Width:100,Align:"Center",SaveName:"acc_tpcnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"acc_tpc",MinWidth:60,Edit:false, Hidden:true},
				{Type:"Text",Width:60,Align:"Center",SaveName:"lvl_no",MinWidth:60,Edit:false},
				{Type:"Text",Width:70,Align:"Center",SaveName:"fill_yn_dscnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:350,Align:"Left",SaveName:"acc_sbj_cnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:350,Align:"Left",SaveName:"acc_sbjnm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"bf_lv1_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"bf_lv2_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"af_lv1_biz_ix_nm",MinWidth:60,Edit:false},
				{Type:"Text",Width:150,Align:"Center",SaveName:"af_lv2_biz_ix_nm",MinWidth:60,Edit:false},
				//{Type:"Text",Width:100,Align:"Center",SaveName:"sbj_cntn",MinWidth:60,Edit:false},
				{Type:"Text",Width:120,Align:"Center",SaveName:"lschg_dtm",MinWidth:60,Edit:false},
				{Type:"Text",Width:100,Align:"Center",SaveName:"vld_ed_dt",MinWidth:60,Edit:false, Hidden:true}
				
			];
			
			IBS_InitSheet(mySheet1,initData);
			
			mySheet1.InitHeaders(headers);
			mySheet1.SetMergeSheet(eval("msHeaderOnly"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		
			
		}
		
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};

			initData.Cols = [
				{ Header: "산출기준",						Type: "Text",	SaveName: "rgo_in_dsnm",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:false},
				{ Header: "산출기준",						Type: "Text",	SaveName: "rgo_in_dsc",	Align: "Center",	Width: 10,	MinWidth: 50 ,Edit:false, Hidden: true},
				{ Header: "사건발생법인",					Type: "Text",	SaveName: "sbdr_cnm",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:false},
				{ Header: "사건발생법인",					Type: "Text",	SaveName: "sbdr_c",	Align: "Center",	Width: 10,	MinWidth: 150 ,Edit:false, Hidden: true},
				{ Header: "측정반영대상\n손실사건 건수",		Type: "Text",	SaveName: "cnt",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:false},
				{ Header: "총 손실금액 합계",				Type: "Int",	SaveName: "py_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "총 회수금액 합계",				Type: "Int",	SaveName: "rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "보험회수금액 합계",				Type: "Int",	SaveName: "isr_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "총비용",						Type: "Int",	SaveName: "cost_py_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "보험전 순손실금액 합계",			Type: "Int",	SaveName: "guls1_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "순손실금액 합계",					Type: "Int",	SaveName: "guls2_rv_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "연평균 순손실금액",				Type: "Int",	SaveName: "year_avg",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "LC",							Type: "Int",	SaveName: "lc_am",	Align: "Right",		Width: 10,	MinWidth: 100 ,Edit:false,Format:"#,###"},
				{ Header: "상세 손실사건 조회",				Type: "Html",	SaveName: "det_btn",	Align: "Center",	Width: 10,	MinWidth: 80 ,Edit:false, Hidden:true}
			];
			/*mySheet end*/
			
			
			IBS_InitSheet(mySheet2,initData);
	
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
			mySheet2.FitColWidth();
		
			
		}
		
		function initIBSheet3() {
			//시트 초기화
			mySheet3.Reset();
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};
			
			var headers = [{Text:"자본량 산출 구성 요소|자본량 산출 구성 요소|자본량 산출 구성 요소|산출값(규제)|산출값(내부 은행 별도)|산출값(내부 미얀마 별도)", Align:"Center"}];
			
			initData.Cols = [
				{ Header: "자본량 산출기준 구성 요소",	Type:"Text",Width:70,Align:"Center",	SaveName:"msr_elm_dscd",Edit:false, Hidden:true},
				{ Header: "자본량 산출기준 구성 요소",	Type: "Text",	SaveName: "gubun",		Align: "Center",		Edit:false,Width: 10,	MinWidth: 50},
				{ Header: "자본량 산출기준 구성 요소",	Type: "Text",	SaveName: "division",	Align: "Center",	Edit:false,Width: 10,	MinWidth: 200 },
				{ Header: "산출값 (규제)",			Type: "Text",	SaveName: "msr_am3",	Align: "Right",		Edit:false,Width: 10,	MinWidth: 100 , ColMerge: 0},
				{ Header: "산출값 (내부 은행 별도)",	Type: "Text",	SaveName: "msr_am2",	Align: "Right",		Edit:false,Width: 10,	MinWidth: 100 , ColMerge: 0},
				{ Header: "산출값 (내부 미얀마 별도)",	Type: "Text",	SaveName: "msr_am1",	Align: "Right",		Edit:false,Width: 10,	MinWidth: 100 , ColMerge: 0}
			];
			/*mySheet end*/

			IBS_InitSheet(mySheet3,initData);
			
			mySheet3.InitHeaders(headers);
			mySheet3.SetMergeSheet(eval("msHeaderOnly"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet3.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet3.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet3.FitColWidth();
		

			
		}
		
		function initIBSheet4() {
			//시트 초기화
			mySheet4.Reset();
			
			var year = $('#sch_bas_yy').val(); //년도
			var month = $('#sch_bas_qq').val(); //분기
			var date = new Date(year, month-1, 1);
			
			var title = new Array();
			/*조회년월 기준 이전 10개 분기 title 생성*/
			
			for(var i=0; i<13; i++){
				title[i] = date.getFullYear() + " " + Math.ceil((date.getMonth()+1)/3) + "Q";
				
				date.setMonth(date.getMonth()-3);
			}
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};

			var headers = [{Text:"법인|구분|"+title[12]+"|"+title[11]+"|"+title[10]+"|"+title[9]+"|"+title[8]+"|"+title[7]+"|"+title[6]+"|"+title[5]+"|"+title[4]+"|"+title[3]+"|"+title[2]+"|"+title[1]+"|"+title[0], Align:"Center"}];
			
			initData.Cols = [
				{Type:"Text",Width:150,Align:"Center",SaveName:"gubun",MinWidth:100,Edit:false, Hidden:true, ColMerge:1},
				{Type:"Text",Width:150,Align:"Center",SaveName:"intg_grp_cnm",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c1",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c2",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c3",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c4",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c5",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c6",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c7",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c8",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c9",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c10",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c11",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c12",MinWidth:100,Edit:false},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c13",MinWidth:100,Edit:false}
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet4,initData);
			
			mySheet4.InitHeaders(headers);
			mySheet4.SetMergeSheet(eval("msHeaderOnly"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet4.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet4.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet4.FitColWidth();
			//doAction('search'); //그리드 헤더값이 연도에 따라 바뀌기 때문에 여기서 하면 스크립트 오류
			
		}
		
		function initIBSheet5() {
			//시트 초기화
			mySheet5.Reset();
			
			var year = $('#sch_bas_yy').val(); //년도
			var month = $('#sch_bas_qq').val(); //분기
			var date = new Date(year, month-1, 1);
			
			var title = new Array();
			/*조회년월 기준 이전 10개 분기 title 생성*/
			
			for(var i=0; i<13; i++){
				title[i] = date.getFullYear() + " " + Math.ceil((date.getMonth()+1)/3) + "Q";
				
				date.setMonth(date.getMonth()-3);
			}
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData.HeaderMode = {Sort:0};

			var headers = [{Text:"법인|구분|"+title[12]+"|"+title[11]+"|"+title[10]+"|"+title[9]+"|"+title[8]+"|"+title[7]+"|"+title[6]+"|"+title[5]+"|"+title[4]+"|"+title[3]+"|"+title[2]+"|"+title[1]+"|"+title[0], Align:"Center"}];
			
			initData.Cols = [
				{Type:"Text",Width:150,Align:"Center",SaveName:"gubun",MinWidth:100,Edit:false, ColMerge:1},
				{Type:"Text",Width:150,Align:"Center",SaveName:"intg_grp_cnm",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c1",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c2",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c3",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c4",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c5",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c6",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c7",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c8",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c9",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c10",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c11",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c12",MinWidth:100,Edit:false, ColMerge:0},
				{Type:"Float",Width:150,Align:"Right",SaveName:"c13",MinWidth:100,Edit:false, ColMerge:0}
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet5,initData);
			
			mySheet5.InitHeaders(headers);
			mySheet5.SetMergeSheet(eval("msAll"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet5.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet5.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet5.FitColWidth();
			//doAction('search'); //그리드 헤더값이 연도에 따라 바뀌기 때문에 여기서 하면 스크립트 오류
			
		}
		
		function initIBSheet6() {
			//시트 초기화
			mySheet6.Reset();
			
			var initdata = {};
			initdata.Cfg = { MergeSheet: msAll };
			initdata.Cols = [
				{ Header: "기준|기준|기준",						Type: "Text",	SaveName: "base",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, ColMerge:0},
				{ Header: "구분|구분|구분",						Type: "Text",	SaveName: "gubun",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, ColMerge:0 },
				{ Header: "CASE|CASE|CASE",						Type: "Text",	SaveName: "coic_case_dsc",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, ColMerge:0 ,Hidden:1},
				{ Header: "은행|4Q 추정 값|BIC",				Type: "Int",	SaveName: "bic_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false, ColMerge:1 },
				{ Header: "은행|4Q 추정 값|LC",					Type: "Int",	SaveName: "lc_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:1},
				{ Header: "은행|한도 적용 값|BIC",				Type: "Int",	SaveName: "bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "은행|한도 적용 값|LC",				Type: "Int",	SaveName: "lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "은행|한도 적용 값|ILM",				Type: "Float",	SaveName: "ilm",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "은행|한도 적용 값|ORC 한도",			Type: "Int",	SaveName: "orc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|4Q 추정 값|BIC",				Type: "Int",	SaveName: "m_bic_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:1},
				{ Header: "미얀마|4Q 추정 값|LC",				Type: "Int",	SaveName: "m_lc_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:1},
				{ Header: "미얀마|한도 적용 값|BIC",			Type: "Int",	SaveName: "m_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|한도 적용 값|LC",				Type: "Int",	SaveName: "m_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|한도 적용 값|ILM",			Type: "Float",	SaveName: "m_ilm",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|한도 적용 값|ORC 한도",		Type: "Int",	SaveName: "m_orc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "그룹|그룹/nORC 한도|그룹/nORC 한도",	Type: "Int",	SaveName: "g_orc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "한도 채택|한도 채택|한도 채택",		Type: "CheckBox",	SaveName: "ischeck",	Align: "Center",	Width: 10,	MinWidth: 60 , ColMerge:0},
			];
			IBS_InitSheet(mySheet6, initdata);
			mySheet6.SetSelectionMode(4);
			mySheet6.SetCountPosition(0);
			
		}
		var chart1_category = new Array();
		var chart1_BIC = new Array();
		var chart1_LC = new Array();
		var chart1_ORC = new Array();
		var chart1_ORC_1 = new Array();
		function chartDraw_1(){
			myChart_1.RemoveAll();
			myChart_1.SetOptions(initChartType);
			myChart_1.SetOptions(msrMonitor_1, 1);
			/* for(var i = 0; i<13 ; i++){
				if(chart1_ORC[i].indexOf(',') != -1){
					chart1_ORC_1[i] = chart1_ORC[i].replace(/[^0-9]/g,"");
					chart1_ORC_1[i] = parseInt(chart1_ORC_1[i]);
				}
			} */
			myChart_1.SetSeriesOptions([
					{
						name : "ORC",
						data : [
							[chart1_category[0],	chart1_ORC[0]], 
							[chart1_category[1],	chart1_ORC[1]], 
							[chart1_category[2],	chart1_ORC[2]], 
							[chart1_category[3],	chart1_ORC[3]], 
							[chart1_category[4],	chart1_ORC[4]], 
							[chart1_category[5],	chart1_ORC[5]], 
							[chart1_category[6],	chart1_ORC[6]], 
							[chart1_category[7],	chart1_ORC[7]], 
							[chart1_category[8],	chart1_ORC[8]], 
							[chart1_category[9],	chart1_ORC[9]], 
							[chart1_category[10],	chart1_ORC[10]], 
							[chart1_category[11],	chart1_ORC[11]], 
							[chart1_category[12],	chart1_ORC[12]],
						],
					},
			], 1);
			myChart_1.SetXAxisOptions({
				Categories : chart1_category
			}, 1);
			
			myChart_1.Draw(); //what??
			chartTooltip1();
			
		}
		
		
		// Chart : 내부자본(자본량 산출 추이)
		
		var chart2_category = new Array();
		var chart2_BIC = [ 
			[ 11453776496, 13420493139, 14280989290, 14860791870, 16050585435, 17133746304, 18213931471, 10098937060, 10973192656, 11985523213, 13429496973, 15151479246, 16852766580 ],
			[ 21453776496, 23420493139, 24280989290, 24860791870, 26050585435, 27133746304, 28213931471, 20098937060, 20973192656, 21985523213, 23429496973, 25151479246, 26852766580 ],
			[ 31453776496, 33420493139, 34280989290, 34860791870, 36050585435, 37133746304, 38213931471, 30098937060, 30973192656, 31985523213, 33429496973, 35151479246, 36852766580 ]
		];
		var chart2_LC = [ 
			[ 1190799452, 1121922550, 1182090027, 11356739166, 11163058505, 1124289888, 11402138494, 11563631037, 11156248278, 11948955679, 11111624359, 11642801460, 11917021314 ],
			[ 2290799452, 2221922550, 2282090027, 22356739166, 22163058505, 2224289888, 22402138494, 22563631037, 22156248278, 22948955679, 22111624359, 22642801460, 22917021314 ],
			[ 3390799452, 3321922550, 3382090027, 33356739166, 33163058505, 3324289888, 33402138494, 33563631037, 33156248278, 33948955679, 33111624359, 33642801460, 33917021314 ]
		];
		var chart2_ORC = new Array();
			
		function chartDraw_2(){
			
			myChart_2.RemoveAll();
			myChart_2.SetOptions(initChartType);
			myChart_2.SetOptions(msrMonitor_1, 1);
			myChart_2.SetOptions(msrMonitor_2, 1);

			console.log(chart2_ORC);
			
			myChart_2.SetSeriesOptions([
					{
						name : "은행",
						data : [
							[chart2_category[0],	chart2_ORC[0][0]], 
							[chart2_category[1],	chart2_ORC[0][1]], 
							[chart2_category[2],	chart2_ORC[0][2]], 
							[chart2_category[3],	chart2_ORC[0][3]], 
							[chart2_category[4],	chart2_ORC[0][4]], 
							[chart2_category[5],	chart2_ORC[0][5]], 
							[chart2_category[6],	chart2_ORC[0][6]], 
							[chart2_category[7],	chart2_ORC[0][7]], 
							[chart2_category[8],	chart2_ORC[0][8]], 
							[chart2_category[9],	chart2_ORC[0][9]], 
							[chart2_category[10],	chart2_ORC[0][10]], 
							[chart2_category[11],	chart2_ORC[0][11]], 
							[chart2_category[12],	chart2_ORC[0][12]],
						],
					},
					{
						name : "미얀마",
						data : [
							[chart2_category[0],	0], 
							[chart2_category[1],	chart2_ORC[1][1]], 
							[chart2_category[2],	chart2_ORC[1][2]], 
							[chart2_category[3],	chart2_ORC[1][3]], 
							[chart2_category[4],	chart2_ORC[1][4]], 
							[chart2_category[5],	chart2_ORC[1][5]], 
							[chart2_category[6],	chart2_ORC[1][6]], 
							[chart2_category[7],	chart2_ORC[1][7]], 
							[chart2_category[8],	chart2_ORC[1][8]], 
							[chart2_category[9],	chart2_ORC[1][9]], 
							[chart2_category[10],	chart2_ORC[1][10]], 
							[chart2_category[11],	chart2_ORC[1][11]], 
							[chart2_category[12],	chart2_ORC[1][12]],
						],
					},
					{
						name : "그룹",
						data : [
							[chart2_category[0],	chart2_ORC[2][0]], 
							[chart2_category[1],	chart2_ORC[2][1]], 
							[chart2_category[2],	chart2_ORC[2][2]], 
							[chart2_category[3],	chart2_ORC[2][3]], 
							[chart2_category[4],	chart2_ORC[2][4]], 
							[chart2_category[5],	chart2_ORC[2][5]], 
							[chart2_category[6],	chart2_ORC[2][6]], 
							[chart2_category[7],	chart2_ORC[2][7]], 
							[chart2_category[8],	chart2_ORC[2][8]], 
							[chart2_category[9],	chart2_ORC[2][9]], 
							[chart2_category[10],	chart2_ORC[2][10]], 
							[chart2_category[11],	chart2_ORC[2][11]], 
							[chart2_category[12],	chart2_ORC[2][12]],
						],
					},
			], 1);
			
			myChart_2.SetXAxisOptions({
				Categories : chart2_category
			}, 1);
			console.log(chart2_ORC);
			myChart_2.Draw();
			chartTooltip2();
		}
		
		// Chart : 내부자본(당기 한도소진율)
		var chart3_category = ["은행", "미얀마", "그룹"];
			var chart3_1 = [74.77, 87.34, 93.74];
			var chart3_2 = [52.55, 82.55, 65.21];
		
		function chartDraw_3(){
			
			myChart_3.RemoveAll();
			myChart_3.SetOptions(initChartType);
			myChart_3.SetOptions(msrMonitor_3, 1);
			myChart_3.SetSeriesOptions([
					{
						name : "당 월 한도 소진율",
						data : [
 							[chart3_category[0],	chart3_1[0]], 
							[chart3_category[1],	chart3_1[1]], 
							[chart3_category[2],	chart3_1[2]],
						],
					},
					{
						name : "전 월 한도 소진율",
						data : [
 							[chart3_category[0],	chart3_2[0]],
							[chart3_category[1],	chart3_2[1]], 
							[chart3_category[2],	chart3_2[2]],
						],
					},
			], 1);
			
			myChart_3.SetXAxisOptions({
				Categories : chart3_category
			}, 1);
			
			
			myChart_3.Draw();
			
			for(var i=0; i<3; i++){
				var color = gridColor.primary;
				if( chart3_1[i] >= 85 && chart3_1[i] < 90 ){
					color = gridColor.yellow;
				}else if( chart3_1[i]  >= 90){
					color = gridColor.red;
				}
				$('.chart-msr-monitor3 .Hcharts-series:first-child rect').eq(i).css('fill', color);
			}
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		//시트 ContextMenu선택에 대한 이벤트
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search_orm":  //데이터 조회
					 if($('#sch_bas_yy').val() == "" || $('#sch_bas_yy').val() == null){
						alert("연도정보가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
					
					var bas_ym = $('#sch_bas_yy').val()+""+$('#sch_bas_qq').val(); //기준년월 (연도 + 분기)
					$('#sch_bas_ym').val(bas_ym);
				
					var opt = {};
					var role_id = $("#role_id").val();

					mySheet4.RemoveAll();
					mySheet5.RemoveAll();
					initIBSheet4();
					initIBSheet5();
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010503");
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010802");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010902");
					mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011102");
					mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011103");
					mySheet5.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR011210");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					
					WP.load(url, inputData,{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="0") {
								var rList = result.DATA;
								if(rList.length>0){
									$("#bic_buffer_sh").val(rList[0].mng_pln_rto);
									$("#bic_buffer_shm").val(rList[1].mng_pln_rto);
									$("#lc_buffer_sh").val(rList[0].lss_am);
									$("#lc_buffer_shm").val(rList[1].lss_am);
								}
							}else if(result!='undefined' && result.rtnCode!="0"){
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
					
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011211");
					mySheet6.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "search_ormld":
					save();
					break;
				case "apprvOrmld":
					
					break;
				case "rejectOrmld":
					
					break;
				case "help":
					$("#winHelp").show();
					break;
				case "reload":  //조회데이터 리로드
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					var qq = "";
					switch($('#sch_bas_qq').val()){
						case "03":
							qq= "1Q";
							break;
						case "06":
							qq= "2Q";
							break;
						case "09":
							qq= "3Q";
							break;
						case "12":
							qq= "4Q";
							break;
					}
						
					var bas_ym = $('#sch_bas_yy').val()+" "+qq; //기준년월 (연도 + 분기)
					mySheet1.Down2ExcelBuffer(true);
					mySheet1.Down2Excel({FileName:'측정 업무 보고서 '+bas_ym,SheetName:'계정과목 영업지수 매핑 신규 등록/수정 명세', DownCols:'0|1|3|4|5|6|7|8|9|10|11', Merge :1});
					mySheet2.Down2Excel({FileName:'측정 업무 보고서 '+bas_ym,SheetName:'손실요소 요약 명세', DownCols:'0|2|4|5|6|7|8|9|10|11|12', Merge :1});
					mySheet3.Down2Excel({FileName:'측정 업무 보고서 '+bas_ym,SheetName:'자본량 산출 결과', DownCols:'1|2|3|4|5', Merge :1});
					mySheet4.Down2Excel({FileName:'측정 업무 보고서 '+bas_ym,SheetName:'자본량 산출 추이-규제자본', DownCols:'1|2|3|4|5|6|7|8|9|10|11|12|13|14', Merge :1});
					mySheet5.Down2Excel({FileName:'측정 업무 보고서 '+bas_ym,SheetName:'자본량 산출 추이-내부자본', DownCols:'1|2|3|4|5|6|7|8|9|10|11|12|13|14', Merge :1});
					myChart.Down2Image({FileName:"측정 업무 보고서", Type:IBExportType.EXCEL, Width:800, Url:"../Chart/Down2Image.jsp"});
					mySheet1.Down2ExcelBuffer(false);
					break;
				case "chart1":
					chartDraw_1();
					break;
				case "chart2":
					chartDraw_2();
					chartDraw_3();
					break;
			}
		}

		function mySheet4_OnSearchEnd(code, message) {
			var year = $('#sch_bas_yy').val(); //년도
			var month = $('#sch_bas_qq').val(); //분기
			var date = new Date(year, month-1, 1);
			
			var title = new Array();
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				chart1_BIC = [ mySheet4.GetCellValue(5,"c1"), mySheet4.GetCellValue(5,"c2"), mySheet4.GetCellValue(5,"c3"), mySheet4.GetCellValue(5,"c4"), mySheet4.GetCellValue(5,"c5"), mySheet4.GetCellValue(5,"c6"), mySheet4.GetCellValue(5,"c7"), mySheet4.GetCellValue(5,"c8"), mySheet4.GetCellValue(5,"c9"), mySheet4.GetCellValue(5,"c10"), mySheet4.GetCellValue(5,"c11"), mySheet4.GetCellValue(5,"c12"), mySheet4.GetCellValue(5,"c13") ];
				chart1_LC = [ mySheet4.GetCellValue(6,"c1"), mySheet4.GetCellValue(6,"c2"), mySheet4.GetCellValue(6,"c3"), mySheet4.GetCellValue(6,"c4"), mySheet4.GetCellValue(6,"c5"), mySheet4.GetCellValue(6,"c6"), mySheet4.GetCellValue(6,"c7"), mySheet4.GetCellValue(6,"c8"), mySheet4.GetCellValue(6,"c9"), mySheet4.GetCellValue(6,"c10"), mySheet4.GetCellValue(6,"c11"), mySheet4.GetCellValue(6,"c12"), mySheet4.GetCellValue(6,"c13") ];
				chart1_ORC = [  mySheet4.GetCellValue(8,"c1"), mySheet4.GetCellValue(8,"c2"), mySheet4.GetCellValue(8,"c3"), mySheet4.GetCellValue(8,"c4"), mySheet4.GetCellValue(8,"c5"), mySheet4.GetCellValue(8,"c6"), mySheet4.GetCellValue(8,"c7"), mySheet4.GetCellValue(8,"c8"), mySheet4.GetCellValue(8,"c9"), mySheet4.GetCellValue(8,"c10"), mySheet4.GetCellValue(8,"c11"), mySheet4.GetCellValue(8,"c12"), mySheet4.GetCellValue(8,"c13")];
				for(var i=0; i<13; i++){
					title[i] = date.getFullYear() + " " + Math.ceil((date.getMonth()+1)/3) + "Q";
					
					date.setMonth(date.getMonth()-3);
				}
				chart1_category = [title[12], title[11], title[10], title[9], title[8], title[7], title[6], title[5], title[4], title[3], title[2], title[1], title[0]];
			}
			//컬럼의 너비 조정
			mySheet5.FitColWidth();
			doAction('chart1');
		}
		function mySheet5_OnSearchEnd(code, message) {
			var year = $('#sch_bas_yy').val(); //년도
			var month = $('#sch_bas_qq').val(); //분기
			var date = new Date(year, month-1, 1);
			var f = document.ormsForm;
			var title = new Array();
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
				chart2_ORC = [  [mySheet5.GetCellValue(1,"c1"), mySheet5.GetCellValue(1,"c2"), mySheet5.GetCellValue(1,"c3"), mySheet5.GetCellValue(1,"c4"), mySheet5.GetCellValue(1,"c5"), mySheet5.GetCellValue(1,"c6"), mySheet5.GetCellValue(1,"c7"), mySheet5.GetCellValue(1,"c8"), mySheet5.GetCellValue(1,"c9"), mySheet5.GetCellValue(1,"c10"), mySheet5.GetCellValue(1,"c11"), mySheet5.GetCellValue(1,"c12"), mySheet5.GetCellValue(1,"c13")]
								,[mySheet5.GetCellValue(4,"c1"), mySheet5.GetCellValue(4,"c2"), mySheet5.GetCellValue(4,"c3"), mySheet5.GetCellValue(4,"c4"), mySheet5.GetCellValue(4,"c5"), mySheet5.GetCellValue(4,"c6"), mySheet5.GetCellValue(4,"c7"), mySheet5.GetCellValue(4,"c8"), mySheet5.GetCellValue(4,"c9"), mySheet5.GetCellValue(4,"c10"), mySheet5.GetCellValue(4,"c11"), mySheet5.GetCellValue(4,"c12"), mySheet5.GetCellValue(4,"c13")]
								,[mySheet5.GetCellValue(7,"c1"), mySheet5.GetCellValue(7,"c2"), mySheet5.GetCellValue(7,"c3"), mySheet5.GetCellValue(7,"c4"), mySheet5.GetCellValue(7,"c5"), mySheet5.GetCellValue(7,"c6"), mySheet5.GetCellValue(7,"c7"), mySheet5.GetCellValue(7,"c8"), mySheet5.GetCellValue(7,"c9"), mySheet5.GetCellValue(7,"c10"), mySheet5.GetCellValue(7,"c11"), mySheet5.GetCellValue(7,"c12"), mySheet5.GetCellValue(7,"c13")]
				];
				for(var i=0; i<13; i++){
					title[i] = date.getFullYear() + " " + Math.ceil((date.getMonth()+1)/3) + "Q";
					
					date.setMonth(date.getMonth()-3);
				}
				
				chart2_category = [title[12], title[11], title[10], title[9], title[8], title[7], title[6], title[5], title[4], title[3], title[2], title[1], title[0]];
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "msr");
				WP.setParameter("process_id", "ORMR011104");
				WP.setForm(f);
				
				var inputData = WP.getParams();
				showLoadingWs(); // 프로그래스바 활성화
				
				WP.load(url, inputData,{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="0") {
							var rList = result.DATA;
							if(rList.length>0){
								for (var i = 0; i < rList.length; i++){
									chart2_LC[0][i] = rList[i].bnk_lc;	
									chart2_LC[1][i] = rList[i].myn_lc;
									chart2_LC[2][i] = rList[i].grp_lc;
								}
								for (var i = 0; i < rList.length; i++){
									chart2_BIC[0][i] = rList[i].bnk_bic;	
									chart2_BIC[1][i] = rList[i].myn_bic;
									chart2_BIC[2][i] = rList[i].grp_bic;
								}
							}
							chartDraw_2();
						}else if(result!='undefined' && result.rtnCode!="0"){
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
				
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "msr");
				WP.setParameter("process_id", "ORMR011105");
				WP.setForm(f);
				
				var inputData = WP.getParams();
				showLoadingWs(); // 프로그래스바 활성화
				
				WP.load(url, inputData,{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="0") {
							var rList = result.DATA;
							if(rList.length>0){
								for (var i = 0; i < rList.length; i++){
									chart3_2[i] = parseFloat(rList[i].lmt_rto);
								}
								chart3_1[0] = parseFloat(mySheet5.GetCellValue(3,"c13"));
								chart3_1[1] = parseFloat(mySheet5.GetCellValue(6,"c13"));
								chart3_1[2] = parseFloat(mySheet5.GetCellValue(9,"c13"));
							}
							chartDraw_3();
						}else if(result!='undefined' && result.rtnCode!="0"){
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
			}
			//컬럼의 너비 조정
			mySheet5.FitColWidth();
			doAction('chart2');
		}
		function mySheet6_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet6.SetCellValue(parseInt(mySheet6.GetCellValue(3,"coic_case_dsc"))+2,"ischeck",1);
				mySheet6.SetColEditable("ischeck", 0);
				alert
			}
		}
		function chartTooltip1(){
			var $el = $('.chart-msr-monitor1');
			$el.find('.Hcharts-series rect').on('mouseover', function(){ 
				var i = $(this).index();
				var bic = chart1_BIC[i].toLocaleString('ko-kr');
				var lc = chart1_LC[i].toLocaleString('ko-kr');
				var orc = chart1_ORC[i].toLocaleString('ko-kr');
				
				var html = "<div class='tooltip-box'>";
					html += "	<div class='chart-tooltip-header'>"+ chart1_category[i] +"</div>";
					html += "	<p class='chart-tooltip'>BIC : <strong>"+ bic +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>LC  : <strong>"+ lc +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>ORC : <strong>"+ orc +"</strong><span class='suffix'>원</span></p>";
					html += "</div>";
					
				$el.find('.Hcharts-container > .Hcharts-tooltip').attr('data', 'chart');
				$el.find('.Hcharts-tooltip[data] .tooltip-box').remove();
				$el.find('.Hcharts-tooltip[data]').append(html);
			})
		}
		
		function chartTooltip2(){
			var $el = $('.chart-msr-monitor2');
			$el.find('.Hcharts-series rect').on('mouseover', function(){
				var i = $(this).index();
				var j = $(this).parents('.Hcharts-series').index() / 2;
  		 	 	var bic = chart2_BIC[j][i].toLocaleString('ko-kr');
				var lc = chart2_LC[j][i].toLocaleString('ko-kr');
				var orc = chart2_ORC[j][i].toLocaleString('ko-kr');
				
				var color = "";
				var name = "";
				
				if(j == 0){
					color = "cb";
					name = "은행";
				}else if(j == 1){
					color = "cy";
					name = "미얀마";
				}else{
					color = "cg";
					name = "그룹";
				}
				
				var html = "<div class='tooltip-box'>";
					html += "	<div class='chart-tooltip-header'>"+ chart2_category[i] +"</div>";
					html += "	<div class='chart-tooltip-header "+ color +"'>"+ name +"</div>";
					html += "	<p class='chart-tooltip'>BIC : <strong>"+ bic +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>LC  : <strong>"+ lc +"</strong><span class='suffix'>원</span></p>";
					html += "	<p class='chart-tooltip'>ORC : <strong>"+ orc +"</strong><span class='suffix'>원</span></p>";
					html += "</div>";
					
				$el.find('.Hcharts-container > .Hcharts-tooltip').attr('data', 'chart');
				$el.find('.Hcharts-tooltip[data] .tooltip-box').remove();
				$el.find('.Hcharts-tooltip[data]').append(html);
				 
			});
		}
		
		function save(){
			var f = document.ormsForm;

			if(!confirm("결재 상신하시겠습니까?")) return;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "msr");
			WP.setParameter("process_id", "ORMR011602");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("결재 상신 하였습니다.");
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
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
		/*Sheet 각종 처리*/
		function doDczProc(sAction) {
			var bas_ym = $('#sch_bas_yy').val()+""+$('#sch_bas_qq').val(); //기준년월 (연도 + 분기)
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			
			var Cnt = mySheet1.GetTotalRows();
			
			
			switch(sAction) {
			
			
				case "sub":  //리스크담당자 상신 (03-> 04)
					if(InputCheck(sAction) == false) return;
					
					$("#dcz_dc").val("04");
				    $("#dcz_objr_emp_auth").val("'004','006'");
				    $('#bas_pd').val(bas_ym);
				    schDczPopup(1);
					break;
				
				case "dcz":  //결제
				
					if(InputCheck(sAction) == false) return;
					alert("@@@@@@@@@@@@@@");
					$("#dcz_dc").val("13"); 
					$("#dcz_objr_emp_auth").val("'002'");
					
					schDczPopup(2);
					//doSave();
					break;
					
				case "ret":  //반려
					if(InputCheck(sAction) == false) return;
					//$("#dcz_objr_emp_auth").val("'002'");
					$("#dcz_dc").val("02");
					$("#dcz_rmk_c").val("01");
					schDczPopup(2);
					//$("#winRetMod").show();
					doSave();
					break;
					
			}
		}
		function doSave() {
			var bas_ym = $('#sch_bas_yy').val()+""+$('#sch_bas_qq').val();
			mySheet3.DoSave(url, { Param : "method=Main&commkind=msr&process_id=ORMR011602&dcz_dc="+$("#dcz_dc").val()+"&sch_rtn_cntn="+bas_ym+"&dcz_objr_eno="+$("#dcz_objr_eno").val()+"&dcz_rmk_c="+$("#dcz_rmk_c").val(), Col : 0 });
		}
		function InputCheck(sAction) {
			
			$("#rpst_id").val("");
			var rcsa_menu_dsc = $("#role_id").val(); 
			var ret_yn ="N";
			var bas_ym = $('#sch_bas_yy').val()+""+$('#sch_bas_qq').val();
			if(sAction=="ret")
				{
				 ret_yn = "Y";
				}
			 var Cnt = mySheet1.GetTotalRows();
			 var rk_evl_dcz_stsc = $("#rk_evl_dcz_stsc").val();
		     
			 for(var i=1;i<=Cnt;i++){
				 if( mySheet1.GetCellValue(i,"ischeck") == "1" ){
				  if($("#rpst_id").val()==""){
				  	$("#rpst_id").val(bas_ym);
				  }
				  if( role_id == "orm"){
					 if( mySheet1.GetCellValue(i,"rk_evl_dcz_stsc") < "03" ){
						 alert("평가완료 되지않은 항목이 존재합니다. \n[리스크 프로파일 : "+mySheet1.GetCellValue(i,"rk_isc_cntn")+"]");
						 return false;
					 }
					 if(mySheet1.GetCellValue(i,"rk_evl_dcz_stsc") >= "13" ){
						 alert("팀장/지점장 최종결재를 완료하였습니다. \n운영리스크 담당자가 재평가를 요청하기 전에는 수정 불가 합니다.");
						 return false;
					 }
					 if(mySheet1.GetCellValue(i,"rk_evl_dcz_stsc") == "99" ){
						 alert("이미 종료된 회차 입니다.");
						 return false;
					 }
					 if( mySheet1.GetCellValue(i,"rk_evl_dcz_stsc") == "04" ){
						 alert("이미 상신 된 건 입니다. \n[리스크 프로파일 : "+mySheet1.GetCellValue(i,"rk_isc_cntn")+"]");
						 return false;
					 }
				  }			 
			 }
			 	
			}
			return true;
			 
		}
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
			<input type="hidden" id="role_id" name="role_id" value="<%=role_id %>" />		
			<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" /> 
			
			<input type="hidden" id="dcz_dc" name="dcz_dc" />
			<input type="hidden" id="table_name" name="table_name" value="TB_OR_GA_MSRRZT_DCZ"/>
			<input type="hidden" id="dcz_code" name="stsc_column_name" value="RK_EVL_DCZ_STSC"/>
			<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="BAS_YM"/>
			<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
			<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
			<input type="hidden" id="bas_pd" name="bas_pd" value="<%=bas_ym%>"/>
			<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
			<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
			<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
			<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
			<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
			
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>연도</th>
									<td>
										<div class="select w100">
											<select name="sch_bas_yy" id="sch_bas_yy" class="form-control">
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("bas_yy")%>"><%=(String)hMap.get("bas_yy")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>분기 선택</th>
									<td>
										<div class="select">
											<select name="sch_bas_qq" id="sch_bas_qq" class="form-control">
												<option value="03">1분기</option>
												<option value="06">2분기</option>
												<option value="09">3분기</option>
												<option value="12">4분기</option>
											</select>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
<%
					if(role_id.equals("orm")){
%>
						<button type="button" class="btn btn-primary search" onclick="doAction('search_orm');">조회</button>
<%
					}else if(role_id.equals("ormld")){
%>
						<button type="button" class="btn btn-primary search" onclick="doAction('search_orm');">조회</button>
<%
					}
%>					
					
				</div>
			</div>
			<!-- 조회 //-->
				
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">계정과목 영업지수 매핑 신규 등록/수정 명세</h2>
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
<%
					if(role_id.equals("orm")){
%>
						<button type="button" id="confirm_btn" class="btn btn-primary" onclick="doDczProc('sub');"><span class="txt">결재</span></button>
<%
					}else if(role_id.equals("ormld")){
%>
						<button type="button" id="apprv_btn" class="btn btn-primary" onclick="doDczProc('dcz');"><span class="txt">승인</span></button>
						<button type="button" id="reject_btn" class="btn btn-primary" onclick="doDczProc('ret');"><span class="txt">반려</span></button>
<%
					}
%>
					</div>
				</div>
				<div class="wrap-grid h250">
					<script> createIBSheet("mySheet1", "100%", "100%"); </script>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">손실요소 요약 명세</h2>
				</div>
				<div class="wrap-grid h250">
					<script> createIBSheet("mySheet2", "100%", "100%"); </script>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">자본량 산출 결과 <span class="small">(2022.1Q)</span></h2>
				</div>
				<div class="wrap-grid h400">
					<script> createIBSheet("mySheet3", "100%", "100%"); </script>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">자본량 산출 추이 - 규제자본</h2>
				</div>
				<div class="wrap-grid h250">
					<script> createIBSheet("mySheet4", "100%", "100%"); </script>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">규제자본 시각화 모니터링</h2>
				</div>
				<div class="wrap-chart chart-msr-monitor1 h260">
					<script> createIBChart("myChart_1", "100%", "100%"); </script>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">자본량 산출 추이 - 내부자본</h2>
				</div>
				<div class="wrap-grid h250">
					<script> createIBSheet("mySheet5", "100%", "100%"); </script>
				</div>
			</section>
			
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">내부자본 시각화 모니터링 (추이 및 한도소진율)</h2>
				</div>
				<div class="row">
					<article class="col w70p">
						<div class="box-header">
							<h3 class="title">자본량 산출 추이</h3>
						</div>
						<div class="wrap-chart chart-msr-monitor2 h220">
							<script> createIBChart("myChart_2", "100%", "100%"); </script>
						</div>
					</article>
					<article class="col w30p">
						<div class="box-header">
							<h3 class="title"> 당기 한도소진율</h3>
						</div>
						<div class="wrap-chart chart-msr-monitor3 h220">
							<script> createIBChart("myChart_3", "100%", "100%"); </script>
						</div>
					</article>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">내부자본 한도 설정</h2>
				</div>
				<div class="box-header">
					<h3 class="title">BIC 및 LC Buffer 적용</h3>
				</div>
				<div class="wrap-table">
					<table class="w800">
						<tbody class="center"> 
							<tr>
								<th rowspan="4">수기입력</th>
								<th scope="col" colspan="2">BIC Buffer (%)</th>
								<th rowspan="4">자동산출</th>
								<th scope="col" colspan="2">LC Buffer</th>
							</tr>
							<tr>
								<th scope="col" colspan="2">차기년도 목표 영업이익률</th>
								<th scope="col" colspan="2">Top 10 평균 내부손실사건 순손실금액<br>(최고/최저 제외)</th>
							</tr>
							<tr>
								<th scope="col">은행</th>
								<th scope="col">미얀마</th>
								<th scope="col">은행</th>
								<th scope="col">미얀마</th>
							</tr>
							<tr>
								<td class="right"><input type="text" class = "form-control w50" id="bic_buffer_sh" name="bic_buffer_sh" readonly/>%</td>
								<td class="right"><input type="text" class = "form-control w50" id="bic_buffer_shm" name="bic_buffer_shm" readonly/>%</td>
								<td class="right"><input type="text" class = "form-control w100" id="lc_buffer_sh" name="lc_buffer_sh" readonly/></td>
								<td class="right"><input type="text" class = "form-control w100" id="lc_buffer_shm" name="lc_buffer_shm" value="0" readonly/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="wrap-grid h250">
					<script> createIBSheet("mySheet6", "100%", "100%"); </script>
				</div>
			</section>
		</form>
		</div>
	</div>
	<script>
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