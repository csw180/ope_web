<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0113.jsp
 Program name : 부/팀별 BCP 계획서 조회
 Description  : 
 Programmer   : 김병현
 Date created : 2022.06.21
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, java.text.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList"); //평가회차 조회
if(vLst==null) vLst = new Vector();
Vector vLst2 = CommUtil.getCommonCode(request, "IPT_INF_FORM_C"); //중요정보형태코드 조회(공통코드)
if(vLst2==null) vLst2 = new Vector();

Vector vLst3 = CommUtil.getCommonCode(request, "BKUP_FORM_C"); //백업형태코드 조회(공통코드)
if(vLst3==null) vLst3 = new Vector();

Vector vLst4 = CommUtil.getCommonCode(request, "BKUP_FQC"); //백업주기코드 조회(공통코드)
if(vLst4==null) vLst4 = new Vector();

Vector vLst5 = CommUtil.getCommonCode(request, "RCVR_HMRS_DSC"); //복구인력구분코드 조회(공통코드)
if(vLst5==null) vLst5 = new Vector();

Vector vLst6 = CommUtil.getCommonCode(request, "BCP_MNG_BRC"); //BCP관리부서코드 조회(공통코드)
if(vLst6==null) vLst6 = new Vector();

HashMap hLstMap = null;
if(vLst6.size()>0){
	hLstMap = (HashMap)vLst6.get(0);
}else{
	hLstMap = new HashMap();
}

String bcp_mng_brc = (String) hLstMap.get("intg_cnm");

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd 

DynaForm form = (DynaForm)request.getAttribute("form");

//중요정보형태코드 ibsheet Combo 형태로 변환
String ipt_inf_form_c = "";
String ipt_inf_form_nm = "";

for(int i=0;i<vLst2.size();i++){
	HashMap hMap = (HashMap)vLst2.get(i);
	if(ipt_inf_form_c==""){
		ipt_inf_form_c += (String)hMap.get("intgc");
		ipt_inf_form_nm += (String)hMap.get("intg_cnm");
	}else{
		ipt_inf_form_c += ("|" + (String)hMap.get("intgc"));
		ipt_inf_form_nm += ("|" + (String)hMap.get("intg_cnm"));
	}
}

//백업형태코드 ibsheet Combo 형태로 변환
String bkup_form_c = "";
String bkup_form_nm = "";

for(int i=0; i<vLst3.size(); i++){
	HashMap hMap = (HashMap)vLst3.get(i);
	if(bkup_form_c==""){
		bkup_form_c += (String)hMap.get("intgc");
		bkup_form_nm += (String)hMap.get("intg_cnm");
	}else{
		bkup_form_c += ("|" + (String)hMap.get("intgc"));
		bkup_form_nm += ("|" + (String)hMap.get("intg_cnm"));
	}
}

//백업주기코드 ibsheet Combo 형태로 변환
String bkup_fqc = "";
String bkup_fqnm = "";
for(int i=0; i<vLst4.size(); i++){
	HashMap hMap = (HashMap)vLst4.get(i);
	if(bkup_fqc==""){
		bkup_fqc += (String)hMap.get("intgc");
		bkup_fqnm += (String)hMap.get("intg_cnm");
		
	}else{
		bkup_fqc += ("|" + (String)hMap.get("intgc"));
		bkup_fqnm += ("|" + (String)hMap.get("intg_cnm"));
	}
}

//복구인력구분코드 ibsheet Combo 형태로 변환
String rcvr_hmrs_dsc = "";
String rcvr_hmrs_nm = "";

for(int i=0; i<vLst5.size(); i++){
	HashMap hMap = (HashMap)vLst5.get(i);
	if(rcvr_hmrs_dsc==""){
		rcvr_hmrs_dsc += (String)hMap.get("intgc");
		rcvr_hmrs_nm += (String)hMap.get("intg_cnm");
	}else{
		rcvr_hmrs_dsc += ("|" + (String)hMap.get("intgc"));
		rcvr_hmrs_nm += ("|" + (String)hMap.get("intg_cnm"));
	}
}
String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(","); 
%>   
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs();
			initIBSheet();
			initIBSheet2();
			initIBSheet3();
			initIBSheet4();
			initIBSheet5();
			initIBSheet6();
			initIBSheet7();
			initIBSheet8();
			initIBSheet9();
			initIBSheet10();
			initIBSheet11();
			initIBSheet12();
			initIBSheet13();
			
	<%
			String bcp_yn = "N";
			for(int i=0;i<auth_grp_id.length;i++){
				if(auth_grp_id[i].trim().equals("005")){
					bcp_yn = "Y";
				}
			}
	%>
		});
		
		/********************************************************* 
		재해대응지원업무 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();  

			mySheet.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"LV1",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv1",		Edit:0},
				{Header:"LV2",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv2",		Edit:0},
				{Header:"LV3",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv3",		Edit:0},
				{Header:"LV4",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv4",		Edit:0},
				{Header:"대체사업장",	Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"brnm",		Edit:0}
			]
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		업무프로세스현황-개요 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet2(){
			//시트초기화
			mySheet2.Reset();  
		  mySheet2.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly+msFixedMerge,AutoFitColWidth:"init|search|resize"}; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"우선순위 구분",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"sort", ColMerge:1},
				{Header:"단위업무개수",		Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"obt_rcvr_hrnm", ColMerge:0},
				{Header:"단위업무개수",		Type:"AutoSum",	MinWidth:80,		Align:"Center",		SaveName:"cnt", ColMerge:0},
				{Header:"대체사업장",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"brnm", ColMerge:0}
			]
			
			IBS_InitSheet(mySheet2,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);
			
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			mySheet2.SetEditable(0);
			mySheet2.SetSumValue(0, "총계");
	
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		최우선재개 업무-목표복구3시간이내 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet3(){
			//시트초기화
			mySheet3.Reset();  
			mySheet3.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
	   			{Header:"LV1",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv1"},
	   			{Header:"LV2",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv2"},
	   			{Header:"LV3",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv3"},
	   			{Header:"LV4",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv4"},
	   			{Header:"대체사업장",	Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"brnm"}
			]
			
			IBS_InitSheet(mySheet3,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet3.SetCountPosition(3);
			
			mySheet3.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet3.SetSelectionMode(4);
			mySheet3.SetEditable(0);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		최우선재개 업무-목표복구1일이내 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet4(){
			//시트초기화
			mySheet4.Reset();  
			mySheet4.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
	   			{Header:"LV1",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv1"},
	   			{Header:"LV2",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv2"},
	   			{Header:"LV3",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv3"},
	   			{Header:"LV4",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv4"},
	   			{Header:"대체사업장",	Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"brnm"}
			]
			
			IBS_InitSheet(mySheet4,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet4.SetCountPosition(3);
			
			mySheet4.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet4.SetSelectionMode(4);
			mySheet4.SetEditable(0);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		최우선재개 업무-목표목구3일이내 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet5(){
			//시트초기화
			mySheet5.Reset();  
			mySheet5.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
	   			{Header:"LV1",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv1"},
	   			{Header:"LV2",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv2"},
	   			{Header:"LV3",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv3"},
	   			{Header:"LV4",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv4"},
	   			{Header:"대체사업장",	Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"brnm"}
			]
			
			IBS_InitSheet(mySheet5,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet5.SetCountPosition(3);
			
			mySheet5.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet5.SetSelectionMode(4);
			mySheet5.SetEditable(0);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		최우선재개 업무-목표목구1주일이내 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet6(){
			//시트초기화
			mySheet6.Reset();  
			mySheet6.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
	   			{Header:"LV1",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv1"},
	   			{Header:"LV2",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv2"},
	   			{Header:"LV3",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv3"},
	   			{Header:"LV4",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv4"},
	   			{Header:"대체사업장",	Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"brnm"}
			]
			
			IBS_InitSheet(mySheet6,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet6.SetCountPosition(3);
			
			mySheet6.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet6.SetSelectionMode(4);
			mySheet6.SetEditable(0);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		최우선재개 업무-목표목구1개월이내 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet7(){
			//시트초기화
			mySheet7.Reset();  
			mySheet7.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
	   			{Header:"LV1",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv1"},
	   			{Header:"LV2",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv2"},
	   			{Header:"LV3",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv3"},
	   			{Header:"LV4",		Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"bsn_prsnm_lv4"},
	   			{Header:"대체사업장",	Type:"Text",	MinWidth:80,		Align:"Left",		SaveName:"brnm"}
			]
			
			IBS_InitSheet(mySheet7,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet7.SetCountPosition(3);
			
			mySheet7.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet7.SetSelectionMode(4);
			mySheet7.SetEditable(0);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		업무재개시 필요자원 현황-중요정보 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet8(){
			//시트초기화
			mySheet8.Reset();  
			mySheet8.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"상태|상태",				Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status", 	Hidden:true},
				{Header:"일련번호|일련번호",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"dsqno", 	Hidden:true},
				{Header:"업무 프로세스|LV1",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv1",		Edit:0},
				{Header:"업무 프로세스|LV2",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv2",		Edit:0},
				{Header:"업무 프로세스|LV3",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv3",		Edit:0},
				{Header:"업무 프로세스|LV4",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv4",		Edit:0},
				{Header:"업무프로세스코드|업무프로세스코드",				Type:"Text",	MinWidth:0,			Align:"Left",		SaveName:"bsn_prss_c", 	Hidden:true},			
				{Header:"중요 정보|중요정보명",		Type:"Text",	MinWidth:150,	Align:"Left",		SaveName:"ipt_infnm"},
				{Header:"중요 정보|중요정보형태",		Type:"Combo",	MinWidth:100,	Align:"Left",		SaveName:"ipt_inf_form_c",	ComboText:"<%=ipt_inf_form_nm %>",	ComboCode:"<%=ipt_inf_form_c %>"},
				{Header:"중요 정보|현재\n저장위치",	Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"strg_locnm"},
				{Header:"중요 정보|백업유무",		Type:"Combo",	MinWidth:10,	Align:"Left",		SaveName:"bkup_yn",		ComboText:"Y|N",	ComboCode:"Y|N"},
				{Header:"중요 정보|백업형태",		Type:"Combo",	MinWidth:10,	Align:"Left",		SaveName:"bkup_form_c",	ComboText:"<%=bkup_form_nm %>",	ComboCode:"<%=bkup_form_c %>"},
				{Header:"중요 정보|백업주기",		Type:"Combo",	MinWidth:10,	Align:"Left",		SaveName:"bkup_fqc",	ComboText:"<%=bkup_fqnm %>",	ComboCode:"<%=bkup_fqc %>"},
				{Header:"중요 정보|소산장소",		Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"plcnm"}
			]
			
			IBS_InitSheet(mySheet8,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet8.SetCountPosition(3);
			
			mySheet8.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet8.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		업무재개시 필요자원 현황-복구담당자(정) 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet9(){
			//시트초기화
			mySheet9.Reset();  
			mySheet9.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"상태|상태",				Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",	Hidden:true},
				{Header:"일련번호|일련번호",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"dsqno", 	Hidden:true},
				{Header:"복구인력구분코드|복구인력구분코드",				Type:"Text",	MinWidth:0,			Align:"Left",		SaveName:"rcvr_hmrs_dsc", 	Hidden:true},
				{Header:"업무 프로세스|LV1",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv1",		Edit:0},
				{Header:"업무 프로세스|LV2",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv2",		Edit:0},
				{Header:"업무 프로세스|LV3",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv3",		Edit:0},
				{Header:"업무 프로세스|LV4",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv4",		Edit:0},
				{Header:"업무프로세스코드|업무프로세스코드",				Type:"Text",	MinWidth:0,			Align:"Left",		SaveName:"bsn_prss_c", 	Hidden:true},
				{Header:"관련 정보|개인번호",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"eno",		Hidden:true},
				{Header:"관련 정보|이름",			Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"chrg_empnm",	Edit:0},
				{Header:"관련 정보|직급",			Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"pzcnm",	Edit:0},
				{Header:"관련 정보|사무소코드",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"brc",		Hidden:true},
				{Header:"관련 정보|담당업무",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"chrg_bsnnm"},
				{Header:"관련 정보|휴대전화",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"mpno"},
				{Header:"관련 정보|E-mail(개인)",	Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"email_adr"},
				{Header:"관련 정보|자택주소",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"ohse_adr",	Wrap:true,	MultiLineText:true},
				{Header:"관련 정보|자택전화",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"ohse_telno"},
			]
			
			IBS_InitSheet(mySheet9,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet9.SetCountPosition(3);
			
			mySheet9.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet9.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		업무재개시 필요자원 현황-복구담당자(부) 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet10(){
			//시트초기화
			mySheet10.Reset();  
			mySheet10.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
	   			{Header:"상태|상태",				Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",	Hidden:true},
	   			{Header:"일련번호|일련번호",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"dsqno", 	Hidden:true},
	   			{Header:"복구인력구분코드|복구인력구분코드",				Type:"Text",	MinWidth:0,			Align:"Left",		SaveName:"rcvr_hmrs_dsc", 	Hidden:true},
	   			{Header:"업무 프로세스|LV1",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv1",		Edit:0},
	   			{Header:"업무 프로세스|LV2",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv2",		Edit:0},
	   			{Header:"업무 프로세스|LV3",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv3",		Edit:0},
	   			{Header:"업무 프로세스|LV4",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv4",		Edit:0},
	   			{Header:"업무프로세스코드|업무프로세스코드",				Type:"Text",	MinWidth:0,			Align:"Left",		SaveName:"bsn_prss_c", 	Hidden:true},
	   			{Header:"관련 정보|개인번호",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"eno",		Hidden:true},
	   			{Header:"관련 정보|이름",			Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"chrg_empnm",	Edit:0},
	   			{Header:"관련 정보|직급",			Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"pzcnm",	Edit:0},
	   			{Header:"관련 정보|사무소코드",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"brc",		Hidden:true},
	   			{Header:"관련 정보|담당업무",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"chrg_bsnnm"},
	   			{Header:"관련 정보|휴대전화",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"mpno"},
	   			{Header:"관련 정보|E-mail(개인)",	Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"email_adr"},
	   			{Header:"관련 정보|자택주소",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"ohse_adr",	Wrap:true,	MultiLineText:true}
			]
			
			IBS_InitSheet(mySheet10,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet10.SetCountPosition(3);
			
			mySheet10.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet10.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		업무재개시 필요자원 현황-이해관계자 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet11(){
			//시트초기화
			mySheet11.Reset();  
			mySheet11.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"상태|상태",				Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",Hidden:true},
				{Header:"일련번호|일련번호",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"dsqno", Hidden:true},
				{Header:"업무 프로세스|LV1",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv1",	Edit:0},
				{Header:"업무 프로세스|LV2",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv2",	Edit:0},
				{Header:"업무 프로세스|LV3",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv3",	Edit:0},
				{Header:"업무 프로세스|LV4",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv4",	Edit:0},
				{Header:"업무프로세스코드|업무프로세스코드",				Type:"Text",	MinWidth:0,			Align:"Left",		SaveName:"bsn_prss_c", 	Hidden:true},
				{Header:"관련 정보|외부기관\n업체명",	Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"conm"},
				{Header:"관련 정보|부서",			Type:"Text",	MinWidth:60,	Align:"Left",		SaveName:"deptnm"},
				{Header:"관련 정보|이름",			Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"chrg_empnm"},
				{Header:"관련 정보|직급",			Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"pzcnm"},
				{Header:"관련 정보|담당업무",		Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"chrg_bsnnm"},
				{Header:"관련 정보|휴대전화",		Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"mpno"},
				{Header:"관련 정보|E-mail",		Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"email_adr"},
				{Header:"관련 정보|회사 전화번호",		Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"offc_telno"}
			]
			
			IBS_InitSheet(mySheet11,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet11.SetCountPosition(3);
			
			mySheet11.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet11.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		업무재개시 필요자원 현황-특수사무/전산기기 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet12(){
			//시트초기화
			mySheet12.Reset();  
		mySheet12.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"상태|상태",				Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",Hidden:true},
				{Header:"일련번호|일련번호",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"dsqno", Hidden:true},
				{Header:"업무 프로세스|LV1",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv1",	Edit:0},
				{Header:"업무 프로세스|LV2",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv2",	Edit:0},
				{Header:"업무 프로세스|LV3",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv3",	Edit:0},
				{Header:"업무 프로세스|LV4",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"bsn_prsnm_lv4",	Edit:0},
				{Header:"업무프로세스코드|업무프로세스코드",				Type:"Text",	MinWidth:0,			Align:"Left",		SaveName:"bsn_prss_c", 	Hidden:true},
				{Header:"관련 정보|사무기기/용품 명",	Type:"Text",	MinWidth:150,	Align:"Left",		SaveName:"bzs_devcnm"},
				{Header:"관련 정보|수량",			Type:"Int",		MinWidth:50,	Align:"Center",		SaveName:"qt"},
				{Header:"관련 정보|사무용도",		Type:"Text",	MinWidth:300,	Align:"Left",		SaveName:"ug_uz_expl"}
			]
			
			IBS_InitSheet(mySheet12,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet12.SetCountPosition(3);
			
			mySheet12.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet12.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		/********************************************************* 
		비상연략망 목록
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet13(){
			//시트초기화
			mySheet13.Reset();  
			mySheet13.SetFocusAfterProcess(0);
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
	   			{Header:"사무소코드",	Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"brc", Hidden:true},
	   			{Header:"팀명",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"brnm"},
	   			{Header:"직급",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"pzcnm"},
	   			{Header:"개인번호",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"eno", Hidden:true},
	   			{Header:"이름",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"chrg_empnm"},
	   			{Header:"전화번호",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"offc_tel_cntn"}
			]
			
			IBS_InitSheet(mySheet13,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet13.SetCountPosition(3);
			
			mySheet13.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet13.SetSelectionMode(4);
			mySheet13.SetEditable(0);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/* Sheet 각종 처리 */
		function doAction(sAction){
			switch(sAction){
				case "search": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011310");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search2": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011302");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search3": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("#hd_obt_rcvr_hr_c").val("01");				
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011303");
					
					mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search4": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("#hd_obt_rcvr_hr_c").val("02");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011303");
					
					mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search5": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("#hd_obt_rcvr_hr_c").val("03");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011303");
					
					mySheet5.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search6": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("#hd_obt_rcvr_hr_c").val("04");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011303");
					
					mySheet6.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search7": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("#hd_obt_rcvr_hr_c").val("05");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011303");
					
					mySheet7.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search8": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};

					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011304");
					
					mySheet8.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search9": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("#hd_rcvr_hmrs_dsc").val("01");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011305");
					
					mySheet9.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search10": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("#hd_rcvr_hmrs_dsc").val("02");
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011305");
					
					mySheet10.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search11": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011306");
					
					mySheet11.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search12": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011307");
					
					mySheet12.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search13": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011308");
					
					mySheet13.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "down2Excel":
					var titleText = "■ 재해대응지원업무 목록 \r\n\r\n *재해대응지원업무는 위기상황 시 전사차원의 신속한 재해복구 및 복구지원업무를 말함";
					var titleText2 = "\r\n ■ 업무 프로세스 현황 \r\n\r\n ◎ 개요";
					var titleText3 = "\r\n ◎ 최우선재개 업무 - 목표복구시간 3시간 이내 업무";
					var titleText4 = "\r\n ◎ 최우선재개 업무 - 목표복구시간 1일 이내 업무";
					var titleText5 = "\r\n ◎ 우선재개 업무 - 목표복구시간 3일 이내 업무";
					var titleText6 = "\r\n ◎ 우선재개 업무 - 목표복구시간 1주일 이내 업무";
					var titleText7 = "\r\n ◎ 자체복구 업무 - 목표복구시간 1개월 이내 업무";
					var titleText8 = "■ 업무재개시 필요자원 현황 및 점검사항 \r\n\r\n ◎ 중요정보";
					var titleText9 = "\r\n ◎ 필요 요구인력-복구담당자 (정)";
					var titleText10 = "\r\n ◎ 필요 요구인력-복구담당자 (부)";
					var titleText11 = "\r\n ◎ 이해관계자";
					var titleText12 = "\r\n ◎ 특수사무/전산기기";
					var titleText13 = "■ 비상연락망 \r\n";
					
					mySheet.Down2ExcelBuffer(true);
					mySheet.Down2Excel({FileName:"BCP 계획서.xlsx",SheetName:'1.목적_2.업무현황',TitleText:titleText,Merge:2,TitleAlign:1,UserMerge:"2,0,1,5",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"0|1|2|3|4"});
					mySheet2.Down2Excel({TitleText:titleText2,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,5",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"0|1|2|3|4"});
					mySheet3.Down2Excel({TitleText:titleText3,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,5",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"0|1|2|3|4"});
					mySheet4.Down2Excel({TitleText:titleText4,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,5",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"0|1|2|3|4"});
					mySheet5.Down2Excel({TitleText:titleText5,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,5",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"0|1|2|3|4"});
					mySheet6.Down2Excel({TitleText:titleText6,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,5",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"0|1|2|3|4"});
					mySheet7.Down2Excel({TitleText:titleText7,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,5",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"0|1|2|3|4"});
					mySheet8.Down2Excel({TitleText:titleText8,Merge:2,SheetName:'3.필요자원',TitleAlign:1,UserMerge:"0,0,1,5 2,0,1,11",ExcelHeaderRowHeight:25,ExcelRowHeight:25,ExcelFontSize:10,DownCols:"2|3|4|5|7|8|9|10|11|12|13"});
					mySheet9.Down2Excel({TitleText:titleText9,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,11",ExcelHeaderRowHeight:25,ExcelRowHeight:25,ExcelFontSize:10,DownCols:"3|4|5|6||9|10|12|13|14|15|16"});
					mySheet10.Down2Excel({TitleText:titleText10,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,10",ExcelHeaderRowHeight:25,ExcelRowHeight:25,ExcelFontSize:10,DownCols:"3|4|5|6||9|10|12|13|14|15|16"});
					mySheet11.Down2Excel({TitleText:titleText11,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,12",ExcelHeaderRowHeight:25,ExcelRowHeight:25,ExcelFontSize:10,DownCols:"2|3|4|5|7|8|9|10|11|12|13|14"});
					mySheet12.Down2Excel({TitleText:titleText12,Merge:2,AppendPrevSheet:1,TitleAlign:1,UserMerge:"1,0,1,7",ExcelHeaderRowHeight:25,ExcelRowHeight:25,ExcelFontSize:10,DownCols:"2|3|4|5|7|8|9"});
					mySheet13.Down2Excel({TitleText:titleText13,Merge:2,SheetName:'APPENDIX',TitleAlign:1,UserMerge:"0,0,1,4",ExcelHeaderRowHeight:25,ExcelRowHeight:17,ExcelFontSize:10,DownCols:"1|2|4|5"});
					mySheet.Down2ExcelBuffer(false);
					
					
					break;
					
			}
		}	
		
		function search(){
			doAction("search");
	 		doAction("search2");
			doAction("search3");
			doAction("search4");
			doAction("search5");
			doAction("search6");
			doAction("search7");
			doAction("search8");
			doAction("search9");
			doAction("search10");
			doAction("search11");
			doAction("search12");
			doAction("search13");
		}
		
		function mySheet9_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			
			if(mySheet9.GetCellProperty(Row, Col, "SaveName")=="chrg_empnm" || mySheet9.GetCellProperty(Row, Col, "SaveName")=="oft"){
				emp_popup();
			}
		}
		function mySheet9_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			$("#hd_brc").val(mySheet9.GetCellValue(Row, "brc"));		
		}
		
		function mySheet10_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			
			if(mySheet10.GetCellProperty(Row, Col, "SaveName")=="chrg_empnm" || mySheet10.GetCellProperty(Row, Col, "SaveName")=="oft"){
				emp_popup();
			}
		}
		function mySheet10_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			$("#hd_brc").val(mySheet10.GetCellValue(Row, "brc"));		
		}
		
		
		function mySheet_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("재해대응지원업무 목록 조회중 에러가 발생했습니다..");
			}else{
			}
					
		}
		
		function mySheet2_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("업무프로세스현황-개요 목록 조회중 에러가 발생했습니다..");
			}else{
			}
			
		}
		
		function mySheet3_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("최우선재개 업무-목표복구3시간이내 목록 조회중 에러가 발생했습니다..");
			}else{
			}
		}
		
		function mySheet4_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("최우선재개 업무-목표복구1일이내 목록 조회중 에러가 발생했습니다..");
			}else{
			}
		}
		
		function mySheet5_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("최우선재개 업무-목표복구3일이내 목록 조회중 에러가 발생했습니다..");
			}else{
			}
		}
		
		function mySheet6_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("최우선재개 업무-목표복구1주일이내 목록 조회중 에러가 발생했습니다..");
			}else{
			}
		}
		
		function mySheet7_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("최우선재개 업무-목표복구1개월이내 목록 조회중 에러가 발생했습니다..");
			}else{
			}
		}
		function mySheet8_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("중요정보 목록 조회중 에러가 발생했습니다..");
			}else{
			}
					
		}
		
		function mySheet9_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("복구담당자(정) 목록 조회중 에러가 발생했습니다..");
			}else{
			}
					
		}
		
		function mySheet10_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("복구담당자(부) 목록 조회중 에러가 발생했습니다..");
			}else{
			}
					
		}
		
		function mySheet11_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("이행관계자 목록 조회중 에러가 발생했습니다..");
			}else{
			}
					
		}
		
		function mySheet12_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("특수사무/전자기기 목록 조회중 에러가 발생했습니다..");
			}else{
			}
					
		}
		
		function mySheet13_OnSearchEnd(code, message){
			
			if(code != 0){
				alert("비상연랑망 목록 조회중 에러가 발생했습니다..");
			}else{
			}
					
		}
		
		function save(){
			
			var f = document.ormsForm;
			var html = "";		
			
			/*중요정보*/
			if(mySheet8.GetDataFirstRow()>0){
				for(var i=mySheet8.GetDataFirstRow(); i<=mySheet8.GetDataLastRow(); i++){
					if(mySheet8.GetCellValue(i, "status")=="U"){
						html += "<input type='hidden' name='status' 		value='"	+mySheet8.GetCellValue(i, "status")			+"' >"
						html += "<input type='hidden' name='dsqno' 			value='"	+mySheet8.GetCellValue(i, "dsqno")			+"' >"
						html += "<input type='hidden' name='bsn_prss_c' 	value='"	+mySheet8.GetCellValue(i, "bsn_prss_c")		+"' >"
						html += "<input type='hidden' name='ipt_infnm' 		value='"	+mySheet8.GetCellValue(i, "ipt_infnm")		+"' >"
						html += "<input type='hidden' name='ipt_inf_form_c' value='"	+mySheet8.GetCellValue(i, "ipt_inf_form_c")	+"' >"
						html += "<input type='hidden' name='strg_locnm' 	value='"	+mySheet8.GetCellValue(i, "strg_locnm")		+"' >"
						html += "<input type='hidden' name='bkup_yn'		value='"	+mySheet8.GetCellValue(i, "bkup_yn")		+"' >"
						html += "<input type='hidden' name='bkup_form_c' 	value='"	+mySheet8.GetCellValue(i, "bkup_form_c")	+"' >"
						html += "<input type='hidden' name='bkup_fqc'		value='"	+mySheet8.GetCellValue(i, "bkup_fqc")		+"' >"
						html += "<input type='hidden' name='plcnm' 			value='"	+mySheet8.GetCellValue(i, "plcnm")			+"' >"
					}
				}
			}
			/*복구담당자(정)*/
			if(mySheet9.GetDataFirstRow()>0){
				for(var i=mySheet9.GetDataFirstRow(); i<=mySheet9.GetDataLastRow(); i++){
					if(mySheet9.GetCellValue(i, "status")=="U"){
						html += "<input type='hidden' name='status2' 		value='"	+mySheet9.GetCellValue(i, "status")			+"' >"
						html += "<input type='hidden' name='dsqno2' 		value='"	+mySheet9.GetCellValue(i, "dsqno")			+"' >"
						html += "<input type='hidden' name='bsn_prss_c2' 	value='"	+mySheet9.GetCellValue(i, "bsn_prss_c")		+"' >"
						html += "<input type='hidden' name='eno2' 			value='"	+mySheet9.GetCellValue(i, "eno")			+"' >"
						html += "<input type='hidden' name='brc2' 			value='"	+mySheet9.GetCellValue(i, "brc")			+"' >"
						html += "<input type='hidden' name='chrg_bsnnm2' 	value='"	+mySheet9.GetCellValue(i, "chrg_bsnnm")		+"' >"
						html += "<input type='hidden' name='mpno2' 			value='"	+mySheet9.GetCellValue(i, "mpno")			+"' >"
						html += "<input type='hidden' name='email_adr2'		value='"	+mySheet9.GetCellValue(i, "email_adr")		+"' >"
						html += "<input type='hidden' name='ohse_adr2' 		value='"	+mySheet9.GetCellValue(i, "ohse_adr")		+"' >"
						html += "<input type='hidden' name='ohse_telno2'	value='"	+mySheet9.GetCellValue(i, "ohse_telno")		+"' >"
						html += "<input type='hidden' name='rcvr_hmrs_dsc2'	value='"	+mySheet9.GetCellValue(i, "rcvr_hmrs_dsc")	+"' >"
					}
				}
			}
			/*복구담당자(부)*/
			if(mySheet10.GetDataFirstRow()>0){
				for(var i=mySheet10.GetDataFirstRow(); i<=mySheet10.GetDataLastRow(); i++){
					if(mySheet10.GetCellValue(i, "status")=="U"){
						html += "<input type='hidden' name='status3' 		value='"	+mySheet10.GetCellValue(i, "status")			+"' >"
						html += "<input type='hidden' name='dsqno3' 		value='"	+mySheet10.GetCellValue(i, "dsqno")				+"' >"
						html += "<input type='hidden' name='bsn_prss_c3' 	value='"	+mySheet10.GetCellValue(i, "bsn_prss_c")		+"' >"
						html += "<input type='hidden' name='eno3' 			value='"	+mySheet10.GetCellValue(i, "eno")				+"' >"
						html += "<input type='hidden' name='brc3' 			value='"	+mySheet10.GetCellValue(i, "brc")				+"' >"
						html += "<input type='hidden' name='chrg_bsnnm3' 	value='"	+mySheet10.GetCellValue(i, "chrg_bsnnm")		+"' >"					
						html += "<input type='hidden' name='mpno3' 			value='"	+mySheet10.GetCellValue(i, "mpno")				+"' >"
						html += "<input type='hidden' name='email_adr3' 	value='"	+mySheet10.GetCellValue(i, "email_adr")			+"' >"
						html += "<input type='hidden' name='ohse_adr3' 		value='"	+mySheet10.GetCellValue(i, "ohse_adr")			+"' >"
						html += "<input type='hidden' name='ohse_telno3' 	value='"	+mySheet10.GetCellValue(i, "ohse_telno")		+"' >"
						html += "<input type='hidden' name='rcvr_hmrs_dsc3' value='"	+mySheet10.GetCellValue(i, "rcvr_hmrs_dsc")		+"' >"
					}
				}
			}
			/*이해관계자*/
			if(mySheet11.GetDataFirstRow()>0){
				for(var i=mySheet11.GetDataFirstRow(); i<=mySheet11.GetDataLastRow(); i++){
					if(mySheet11.GetCellValue(i, "status")=="U"){
						html += "<input type='hidden' name='status4' 		value='"	+mySheet11.GetCellValue(i, "status")		+"' >"
						html += "<input type='hidden' name='dsqno4' 		value='"	+mySheet11.GetCellValue(i, "dsqno")			+"' >"
						html += "<input type='hidden' name='bsn_prss_c4'	value='"	+mySheet11.GetCellValue(i, "bsn_prss_c")	+"' >"
						html += "<input type='hidden' name='conm' 			value='"	+mySheet11.GetCellValue(i, "conm")			+"' >"
						html += "<input type='hidden' name='deptnm' 		value='"	+mySheet11.GetCellValue(i, "deptnm")		+"' >"
						html += "<input type='hidden' name='chrg_empnm' 	value='"	+mySheet11.GetCellValue(i, "chrg_empnm")	+"' >"
						html += "<input type='hidden' name='pzcnm' 			value='"	+mySheet11.GetCellValue(i, "pzcnm")			+"' >"
						html += "<input type='hidden' name='chrg_bsnnm' 	value='"	+mySheet11.GetCellValue(i, "chrg_bsnnm")	+"' >"
						html += "<input type='hidden' name='mpno' 			value='"	+mySheet11.GetCellValue(i, "mpno")			+"' >"
						html += "<input type='hidden' name='email_adr'		value='"	+mySheet11.GetCellValue(i, "email_adr")		+"' >"
						html += "<input type='hidden' name='offc_telno' 	value='"	+mySheet11.GetCellValue(i, "offc_telno")	+"' >"
					}
				}
			}
			/*특수사무/전자기기*/
			if(mySheet12.GetDataFirstRow()>0){
				for(var i=mySheet12.GetDataFirstRow(); i<=mySheet12.GetDataLastRow(); i++){
					if(mySheet12.GetCellValue(i, "status")=="U"){
						html += "<input type='hidden' name='status5' 		value='"	+mySheet12.GetCellValue(i, "status")		+"' >"
						html += "<input type='hidden' name='dsqno5' 		value='"	+mySheet12.GetCellValue(i, "dsqno")			+"' >"
						html += "<input type='hidden' name='bsn_prss_c5' 	value='"	+mySheet12.GetCellValue(i, "bsn_prss_c")	+"' >"
						html += "<input type='hidden' name='bzs_devcnm' 	value='"	+mySheet12.GetCellValue(i, "bzs_devcnm")	+"' >"
						html += "<input type='hidden' name='qt' 			value='"	+mySheet12.GetCellValue(i, "qt")			+"' >"
						html += "<input type='hidden' name='ug_uz_expl' 	value='"	+mySheet12.GetCellValue(i, "ug_uz_expl")	+"' >"
					}
				}
			}
			
			bcp_html.innerHTML = html;
			
			
			if(!confirm("저장하시겠습니까?")) return;
	
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC011309");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("저장하였습니다.");
							removeLoadingWs();
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						doAction("search8");
						doAction("search9");
						doAction("search10");
						doAction("search11");
						doAction("search12");
						removeLoadingWs();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});				
			
			
			
			
			
		}
	
	
	</script>
</head>
<body>
	<div class="container">
		<!--.page header //-->
		<%@ include file="../comm/header.jsp" %>
		<!--.page header //-->
		<!-- content -->
		<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="hd_rcvr_hmrs_dsc" name="hd_rcvr_hmrs_dsc" />
				<input type="hidden" id="hd_obt_rcvr_hr_c" name="hd_obt_rcvr_hr_c" />
				<input type="hidden" id="hd_brc" name="hd_brc" />
				<div id="bcp_html"></div>

			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가년도</th>
									<td>
										<div class="select w100">
											<select class="form-control" id="st_bia_evl_sc" name="st_bia_evl_sc" >
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
										   		<option value="<%=(String)hMap.get("bia_evl_sc")%>"><%=(String)hMap.get("evl_sc")%></option>
<%
	}
%>															
											</select>
										</div>
									</td>
									<th>평가팀</th>
									<td>
										<div class="input-group w200">
<%
if("Y".equals(bcp_yn)){
%>
											<input type="text" class="form-control" id="sch_brnm" name="sch_brnm" value=""  onKeyPress="EnterkeySubmitOrg('sch_brnm', 'orgSearchEnd');" disabled />
											<input type="hidden" id="sch_brc" name="sch_brc" value="" />
											<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"  onclick="schOrgPopup('sch_brnm', 'orgSearchEnd');">
												<i class="fa fa-search"></i><span class="blind">검색</span>	
												</button>
											</span>
<%	
}else{
%>
											<input type="text" class="form-control" id="sch_brnm" name="sch_brnm" value="<%=brnm %>"/>
											<input type="hidden" id="sch_brc" name="sch_brc" value="<%=brc %>" />
<%
}
%>									

												
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:search();">조회</button>
				</div>
			</div>
			<!-- //조회 -->


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">Part 1. 부/팀별 BCP 계획서의 목적 및 범위</h2>
					<div class="area-tool">
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2Excel');"><i class="fa fa-print"></i><span class="txt">인쇄</span></button>
					</div>
				</div>
				<div class="box-body">
					<div class="teamBCP-summary">본 팀별 업무재개계획(Business Continuity Plan of Dept., 이하 '팀별 BCP')은 <br><strong>"해당회사"</strong>(이하 '당사')에 심각한 재해 또는 사건으로 인해 최우선재개업무 마비상황 발생시 또는 발생가능성이 높은 경우 신속히 각팀의 해당업무를 재개 및 복구시키는 것을 목적으로 함.</div>
					<ul class="teamBCP">
						<li>
							<p class="name">RTO 1그룹</p>
							<p class="term">대상 : <strong>RTO 3시간, 1영업일</strong></p>
							<div class="detail">
								각 부서별 대체사업장 이동대상자, 대체사업장 필요 자원 조사
								<br>&rarr; 재해 시 대체사업장 즉각 이동 후 업무 복구
							</div>
						</li>
						<li>
							<p class="name">RTO 2그룹</p>
							<p class="term">대상 : <strong>RTO 3영업일, 1주일</strong></p>
							<div class="detail">
								RTO별 필요 회복기일에 따라 해당 일자까지 사업장 복구 미진시 대체사업장 추가 이동
								<br>&rarr; 이후 필요 자원 구비는 상황발생 후 3영업일 내 미복구시 해당 시점 BCP 담당부서에서 수립
							</div>
						</li>
						<li>
							<p class="name">RTO 3그룹</p>
							<p class="term">대상 : <strong>RTO 1개월이내</strong></p>
							<div class="detail">해당 그룹은 자원조사 대상이 아님</div>
						</li>
					</ul>
				</div>
			</section>


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">Part 2. 업무 프로세스 현황</h2>
				</div>
				<div class="box-header">
					<h3 class="box-title md">2.1. 재해대응지원업무 목록</h3>
					<div class="area-tool"><strong class="txt txt-sm ca">* 재해대응지원업무는 위기상황 시 전사차원의 신속한 재해복구 및 복구지원업무를 말함</strong></div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h3 class="box-title md">2.2. 업무 프로세스 현황</h3>
					<h4 class="box-title sm">개요</h4>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div>
					<div class="mt10">
						<ol class="ullist txt txt-xs ca">
							<li>1) 재해발생시 대체사업장 즉시 이동</li>
							<li>2) 재해발생시 RTO 기간 대기 후 대기 중 수립 계획에 따른 선별적 이동</li>
						</ol>
					</div>
				</div>

				<div class="box-header mt20">
					<h4 class="title">최우선재개 업무 - 목표복구시간 3시간 이내 업무</h4>
				</div>
				<div class="box-body">
					<div class="wrap-grid h150">
						<script> createIBSheet("mySheet3", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h4 class="title">최우선재개 업무 - 목표복구시간 1일 이내 업무</h4>
				</div>
				<div class="box-body">
					<div class="wrap-grid h150">
						<script> createIBSheet("mySheet4", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h4 class="title">우선재개 업무 - 목표복구시간 3일 이내 업무</h4>
				</div>
				<div class="box-body">
					<div class="wrap-grid h150">
						<script> createIBSheet("mySheet5", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h4 class="title">우선재개 업무 - 목표복구시간 1주일 이내 업무</h4>
				</div>
				<div class="box-body">
					<div class="wrap-grid h150">
						<script> createIBSheet("mySheet6", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h4 class="title">자체복구 업무 - 목표복구시간 1개월 이내 업무</h4>
				</div>
				<div class="box-body">
					<div class="wrap-grid h150">
						<script> createIBSheet("mySheet7", "100%", "100%"); </script>
					</div>
				</div>
			</section>


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">Part 3. 업무재개시 필요자원 현황 및 점검사항</h2>
				</div>
				<div class="box-header">
					<h3 class="title">중요정보</h3>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet8", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h3 class="title">필요 요구인력 - 복구담당자(정)</h3>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet9", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h3 class="title">필요 요구인력 - 복구담당자(부)</h3>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet10", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h3 class="title">이해관계자</h3>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet11", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h3 class="title">특수사무/전산기기</h3>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet12", "100%", "100%"); </script>
					</div>
				</div>

				<div class="box-header mt20">
					<h3 class="title">업무재개시 점검사항</h3>
				</div>
				<div class="box-body">
					<div class="wrap-table">
						<table>
							<colgroup>
								<col style="width: 150px;">
								<col style="width: 250px;">
								<col>
								<col style="width: 150px;">
							</colgroup>
							<thead>
								<tr>
									<th>구분</th>
									<th>점검항목(업무)</th>
									<th>점검내용(수행내용)</th>
									<th>점검 및 조치여부</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>중요정보</th>
									<th class="light">업무에 필요한 중요정보 및 기록은 모두 있는가?</th>
									<td>
										<ul class="ul dash">
											<li>업무 수행에 필요한 중요 정보 및 기록 존재여부 확인</li>
											<li>중요 정보 및 기록이 소실된 경우 상황실에 통지 및 지시에 따름</li>
										</ul>
									</td>
									<td></td>
								</tr>
								<tr>
									<th rowspan="2">필요 요구인력</th>
									<th class="light">업무를 수행할 담당자에 문제가 없는가?</th>
									<td>
										<ul class="ul dash">
											<li>업무수행 담당 정담당자, 부담당자 모두 부재 시, 1차적으로 본부장이 대체인력을 지정하여 상황실에 보고</li>
											<li>본부장 또는 본부 전원 부재 시, 상황실에서 인사 DB를 통해 적격자 대체 지정 운영</li>
										</ul>
									</td>
									<td></td>
								</tr>
								<tr>
									<th class="light">전결체계 수정이 필요한가?</th>
									<td>
										<ul class="ul dash">
											<li>전결체계 수정 필요여부 확인(예: 해당 본부장 부재 등)</li>
											<li>업무수행 담당자 대결, 직속 상위권자의 전결 또는 대결 요청 등 전결체계 변경 필요 시 상황실에 요청</li>
										</ul>
									</td>
									<td></td>
								</tr>
								<tr>
									<th rowspan="2">협력 외부기관/<br>업체 정보</th>
									<th class="light">외부 이해관계자 의사소통 원칙 및 방안을 확인하였는가?</th>
									<td>
										<ul class="ul dash">
											<li>상황실로부터 외부 이해관계자에 대한 의사소통 원칙 및 방안을 확인하고 자료 수령</li>
											<li>필요시, 팀별 이해관계자 공지 방안 등에 대해서는 상황실과 협의하여 결정</li>
										</ul>
									</td>
									<td></td>
								</tr>
								<tr>
									<th class="light">외부 이해관계자에게 주요 전달사항 등을 통지하였는가?</th>
									<td>
										<ul class="ul dash">
											<li>업무수행 관련 외부 협력기관/업체에 변경사항 통지</li>
											<li>변경사항 통지후 통지완료 여부를 상황실에 통지</li>
										</ul>
									</td>
									<td></td>
								</tr>
								<tr>
									<th rowspan="2">특수사무/전산기기</th>
									<th class="light">업무재개에 필요한 해당기기가 비치되어 있는가?</th>
									<td>
										<ul class="ul dash">
											<li>업무 재개 시 필수적으로 사용해야 할 특수사무/전산기기 대체사업장 구비 목록 확인</li>
											<li>인증서, ID, 패스워드 등 특수사무/전산기기의 원할한 작동을 위한 관련 정보 확인</li>
										</ul>
									</td>
									<td></td>
								</tr>
								<tr>
									<th class="light">정상작동여부</th>
									<td>
										<ul class="ul dash">
											<li>특수 사무/전산기기의 스펙, 작동방법, 정상작동 여부 확인 작동 불가능시 해당 특수 사무/전산기기 담당자에게 연락 및 조치</li>
										</ul>
									</td>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</section>


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">Part 4. 비상연락망</h2>
				</div>
				<div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet13", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button class="btn btn-primary" type="button" onclick="javascript:save();">
							<span class="txt">저장</span>
						</button>
					</div>
				</div>
			</section>
			</form>	
		</div>
		<!-- content //-->
	</div>	

	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/EmpInfP.jsp" %> <!-- 직원 공통 팝업 -->
	
	<script>
		<%--부서 시작 --%>
		var init_flag = false;
		function org_popup(){
			schOrgPopup("sch_brnm", "orgSearchEnd","0");
			if($("#sch_hd_brc_nm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		// 부서검색 완료
		function orgSearchEnd(brc, brnm){
			$("#sch_brc").val(brc);
			$("#sch_brnm").val(brnm);
			$("#winBuseo").hide();
			//doAction('search');
		}
		
		<%-- 직원 시작 --%>		
		function emp_popup(){
			var hd_brc = $("#hd_brc").val();
			schEmpPopup(hd_brc,"empSearchEnd");
			//$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
		}
		// 직원검색 완료
		function empSearchEnd(eno, empnm, brnm, oft){
			var row = mySheet9.GetSelectRow();
			mySheet9.SetCellValue(row, "eno", eno);
			mySheet9.SetCellValue(row, "chrg_empnm", empnm);
			mySheet9.SetCellValue(row, "oft", oft);
	
			$("#winEmp").hide();
			//doAction('search');
		}	
		function emp_popup2(){
			var hd_brc = $("#hd_brc").val();
			schEmpPopup(hd_brc,"empSearchEnd2");
			//$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
		}
		// 직원검색 완료
		function empSearchEnd2(eno, empnm, brnm, oft){
			var row = mySheet10.GetSelectRow();
			mySheet10.SetCellValue(row, "eno", eno);
			mySheet10.SetCellValue(row, "chrg_empnm", empnm);
			mySheet10.SetCellValue(row, "oft", oft);
	
			$("#winEmp").hide();
			//doAction('search');
		}	
	</script>
</body>

</html>