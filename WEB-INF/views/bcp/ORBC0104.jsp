<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0104.jsp
 Program name : 영업영향분석(BIA) 설문(팝업)
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


Vector vLst = CommUtil.getCommonCode(request, "IPT_INF_FORM_C"); //중요정보형태코드 조회(공통코드)
if(vLst==null) vLst = new Vector();

Vector vLst2 = CommUtil.getCommonCode(request, "BKUP_FORM_C"); //백업형태코드 조회(공통코드)
if(vLst2==null) vLst2 = new Vector();

Vector vLst3 = CommUtil.getCommonCode(request, "BKUP_FQC"); //백업주기코드 조회(공통코드)
if(vLst3==null) vLst3 = new Vector();

Vector vLst4 = CommUtil.getCommonCode(request, "RCVR_HMRS_DSC"); //복구인력구분코드 조회(공통코드)
if(vLst4==null) vLst4 = new Vector();

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd

String year = dt.substring(0,4);

String chrg_brc = hs.get("brc").toString();
String chrg_brnm = hs.get("brnm").toString();

DynaForm form = (DynaForm)request.getAttribute("form");

String bia_evl_sc = "";
String bia_evl_prg_stsc = "";
String hd_bsn_prss_c = "";
String max_pmss_ssp_prdc = "";
String bia_evl_ed_dt = "";
String bia_yy = "";

bia_evl_sc = (String) form.get("st_bia_evl_sc");
if(bia_evl_sc==null) bia_evl_sc = "";

bia_yy = (String) form.get("bas_yy");
if(bia_yy==null) bia_yy = "";

bia_evl_prg_stsc = (String) form.get("bia_evl_prg_stsc");
if(bia_evl_prg_stsc==null) bia_evl_prg_stsc = "";

hd_bsn_prss_c = (String) form.get("hd_bsn_prss_c");
if(hd_bsn_prss_c==null) hd_bsn_prss_c = "";

max_pmss_ssp_prdc = (String) form.get("max_pmss_ssp_prdc");
if(max_pmss_ssp_prdc==null) max_pmss_ssp_prdc = "";

bia_evl_ed_dt = (String) form.get("bia_evl_ed_dt").replaceAll("-","");
if(bia_evl_ed_dt==null) bia_evl_ed_dt = "";


//중요정보형태코드 ibsheet Combo 형태로 변환
String ipt_inf_form_c = "";
String ipt_inf_form_nm = "";

for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
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

for(int i=0; i<vLst2.size(); i++){
	HashMap hMap = (HashMap)vLst2.get(i);
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

for(int i=0; i<vLst3.size(); i++){
	HashMap hMap = (HashMap)vLst3.get(i);
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

for(int i=0; i<vLst4.size(); i++){
	HashMap hMap = (HashMap)vLst4.get(i);
	if(rcvr_hmrs_dsc==""){
		rcvr_hmrs_dsc += (String)hMap.get("intgc");
		rcvr_hmrs_nm += (String)hMap.get("intg_cnm");
	}else{
		rcvr_hmrs_dsc += ("|" + (String)hMap.get("intgc"));
		rcvr_hmrs_nm += ("|" + (String)hMap.get("intg_cnm"));
	}
}

System.out.println(rcvr_hmrs_dsc+rcvr_hmrs_dsc+"----------------------------------------");
%>    
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs();
			
			//ibsheet 초기화
			initIBSheet();
			initIBSheet2();
			initIBSheet3();
			initIBSheet4();
			//initIBSheet5();
			<%
			if(bia_evl_prg_stsc.equals("02") && dt.compareTo(bia_evl_ed_dt)<=0){
			%>
			$(".btn-pm").show();
			<%
			}else{
			%>
			//$(".btn-pm").hide();
			<%
			}
			%>
		});
		
		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
 				{Header:"중요 정보 조사|상태|상태",				Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status", 	Hidden:true},
 				{Header:"중요 정보 조사|삭제|삭제",				Type:"DelCheck",Width:30,		Align:"Left",		SaveName:"delchk"},
 				{Header:"중요 정보 조사|일련번호|일련번호",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"dsqno", 	Hidden:true},
 				{Header:"중요 정보 조사|중요정보명|중요정보명",			Type:"Text",	MinWidth:250,	Align:"Left",		SaveName:"ipt_infnm"},
				{Header:"중요 정보 조사|중요정보형태|중요정보형태",		Type:"Combo",	MinWidth:100,	Align:"Left",		SaveName:"ipt_inf_form_c",	ComboText:"<%=ipt_inf_form_nm %>",	ComboCode:"<%=ipt_inf_form_c %>"},
				{Header:"중요 정보 조사|현재\n저장위치|현재\n저장위치",	Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"strg_locnm"},
				{Header:"중요 정보 조사|백업|유무",				Type:"Combo",	MinWidth:10,	Align:"Left",		SaveName:"bkup_yn",		ComboText:"Y|N",	ComboCode:"Y|N"},
				{Header:"중요 정보 조사|백업|형태",				Type:"Combo",	MinWidth:10,	Align:"Left",		SaveName:"bkup_form_c",	ComboText:"<%=bkup_form_nm %>",	ComboCode:"<%=bkup_form_c %>"},
				{Header:"중요 정보 조사|백업|주기",				Type:"Combo",	MinWidth:10,	Align:"Left",		SaveName:"bkup_fqc",	ComboText:"<%=bkup_fqnm %>",	ComboCode:"<%=bkup_fqc %>"},
				{Header:"중요 정보 조사|소산장소|소산장소",			Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"plcnm"}
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
			<%
			if(bia_evl_prg_stsc.equals("02") && dt.compareTo(bia_evl_ed_dt)<=0){
			%>
			<%
			}else{
			%>
			mySheet.SetEditable(0);
			mySheet.SetColHidden("delchk", 1);
			<%
			}
			%>
			
			doAction('search');
			
		}
		
		/* Sheet 기본 설정 */
		function initIBSheet2(){
			//시트초기화
			mySheet2.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"필요 요구인력 조사|상태|상태",			Type:"Status",	Width:0,	Align:"Left",		SaveName:"status",	Hidden:true},
				{Header:"필요 요구인력 조사|삭제|삭제",			Type:"DelCheck",Width:15,	Align:"Left",		SaveName:"delchk"},
				{Header:"필요 요구인력 조사|일련번호|일련번호",		Type:"Text",	Width:0,	Align:"Left",		SaveName:"dsqno", 	Hidden:true},
				{Header:"필요 요구인력 조사|구분|구분",			Type:"Combo",	Width:60,	Align:"Left",		SaveName:"rcvr_hmrs_dsc",	ComboText:"<%=rcvr_hmrs_nm %>",	ComboCode:"<%=rcvr_hmrs_dsc %>"},
				{Header:"필요 요구인력 조사|부서코드|부서코드",		Type:"Text",	Width:0,	Align:"Left",		SaveName:"brc",		Hidden:true},
				{Header:"필요 요구인력 조사|부서|부서",			Type:"Text",	Width:50,	Align:"Left",		SaveName:"brnm",	Edit:0},
				{Header:"필요 요구인력 조사|개인번호|개인번호",		Type:"Text",	Width:0,	Align:"Left",		SaveName:"eno",		Hidden:true},
				{Header:"필요 요구인력 조사|이름|이름",			Type:"Text",	Width:30,	Align:"Left",		SaveName:"chrg_empnm",	Edit:0},
				{Header:"필요 요구인력 조사|직급|직급",			Type:"Text",	Width:30,	Align:"Left",		SaveName:"pzcnm",	Edit:0},
				{Header:"필요 요구인력 조사|담당업무|담당업무",					Type:"Text",	Width:60,	Align:"Left",		SaveName:"chrg_bsnnm"},
				{Header:"필요 요구인력 조사|개인정보 및 비상연락망|휴대전화",			Type:"Text",	Width:50,	Align:"Left",		SaveName:"mpno"},
				{Header:"필요 요구인력 조사|개인정보 및 비상연락망|E-mail(개인)",	Type:"Text",	Width:50,	Align:"Left",		SaveName:"email_adr"},
				{Header:"필요 요구인력 조사|개인정보 및 비상연락망|자택주소",			Type:"Text",	Width:70,	Align:"Left",		SaveName:"ohse_adr",	Wrap:true,	MultiLineText:true},
				{Header:"필요 요구인력 조사|개인정보 및 비상연락망|자택전화",			Type:"Text",	Width:50,	Align:"Left",		SaveName:"ohse_telno"}
			]
			IBS_InitSheet(mySheet2,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet2.SetCountPosition(3);
			
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			<%
			if(bia_evl_prg_stsc.equals("02") && dt.compareTo(bia_evl_ed_dt)<=0){
			%>
			<%
			}else{
			%>
			mySheet2.SetEditable(0);
			mySheet2.SetColHidden("delchk", 1);
			<%
			}
			%>

			
			doAction('search2');
			
		}
		
		/* Sheet 기본 설정 */
		function initIBSheet3(){
			//시트초기화
			mySheet3.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"이해관계자 조사|상태|상태",					Type:"Status",	Width:0,	Align:"Left",		SaveName:"status",Hidden:true},
				{Header:"이해관계자 조사|일련번호|일련번호",				Type:"Text",	Width:0,	Align:"Left",		SaveName:"dsqno", Hidden:true},
				{Header:"이해관계자 조사|삭제|삭제",					Type:"DelCheck",Width:15,	Align:"Left",		SaveName:"delchk"},
				{Header:"이해관계자 조사|외부기관\n업체명|외부기관\n업체명",	Type:"Text",	Width:80,	Align:"Left",		SaveName:"conm"},
				{Header:"이해관계자 조사|부서|부서",					Type:"Text",	Width:50,	Align:"Left",		SaveName:"deptnm"},
				{Header:"이해관계자 조사|이름|이름",					Type:"Text",	Width:40,	Align:"Left",		SaveName:"chrg_empnm"},
				{Header:"이해관계자 조사|직급|직급",					Type:"Text",	Width:20,	Align:"Left",		SaveName:"pzcnm"},
				{Header:"이해관계자 조사|담당업무|담당업무",				Type:"Text",	Width:40,	Align:"Left",		SaveName:"chrg_bsnnm"},
				{Header:"이해관계자 조사|개인정보 및 비상연락망|휴대전화",	Type:"Text",	Width:50,	Align:"Left",		SaveName:"mpno"},
				{Header:"이해관계자 조사|개인정보 및 비상연락망|E-mail",	Type:"Text",	Width:50,	Align:"Left",		SaveName:"email_adr"},
				{Header:"이해관계자 조사|개인정보 및 비상연락망|회사 전화번호",Type:"Text",	Width:50,	Align:"Left",		SaveName:"offc_telno"}
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
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			<%
			if(bia_evl_prg_stsc.equals("02") && dt.compareTo(bia_evl_ed_dt)<=0){
			%>
			<%
			}else{
			%>
			mySheet3.SetEditable(0);
			mySheet3.SetColHidden("delchk", 1);
			<%
			}
			%>
			
			doAction('search3');
			
		}
		
		/* Sheet 기본 설정 */
		function initIBSheet4(){
			//시트초기화
			mySheet4.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"필요 사무기기 조사|상태",		Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",Hidden:true},
				{Header:"필요 사무기기 조사|일련번호",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"dsqno", Hidden:true},
				{Header:"필요 사무기기 조사|삭제",		Type:"DelCheck",Width:30,		Align:"Left",		SaveName:"delchk"},
				{Header:"필요 사무기기 조사|사무기기/용품 명",	Type:"Text",	MinWidth:300,	Align:"Left",		SaveName:"bzs_devcnm"},
				{Header:"필요 사무기기 조사|수량",		Type:"Int",		MinWidth:20,	Align:"Left",		SaveName:"qt"},
				{Header:"필요 사무기기 조사|사무용도",		Type:"Text",	MinWidth:550,	Align:"Left",		SaveName:"ug_uz_expl"}
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
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			<%
			if(bia_evl_prg_stsc.equals("02") && dt.compareTo(bia_evl_ed_dt)<=0){
			%>
			<%
			}else{
			%>
			mySheet4.SetEditable(0);
			mySheet4.SetColHidden("delchk", 1);
			<%
			}
			%>
			
			doAction('search4');
			
		}		
		
		/* Sheet 기본 설정 */
		function initIBSheet5(){
			//시트초기화
			mySheet5.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"평가 부서코드|평가 부서코드",		Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"brc", Hidden:true},
				{Header:"평가 부서|평가 부서",			Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"brnm"},
				{Header:"업무프로세스|LV1",				Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"bsn_prsnm_lv1"},
				{Header:"업무프로세스|LV2",				Type:"Text",	MinWidth:120,	Align:"Left",		SaveName:"bsn_prsnm_lv2"},
				{Header:"업무프로세스|LV3",				Type:"Text",	MinWidth:120,	Align:"Left",		SaveName:"bsn_prsnm_lv3"},
				{Header:"업무프로세스|LV4",				Type:"Text",	MinWidth:200,	Align:"Left",		SaveName:"bsn_prsnm_lv4"},
				{Header:"업무프로세스코드|업무프로세스코드",	Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bsn_prss_c", Hidden:true},
				{Header:"최대허용중단기간|MAO",			Type:"Text",	MinWidth:50,	Align:"Center",		SaveName:"max_pmss_ssp_prdnm"},
				{Header:"필요복구자원\n조사대상|필요복구자원\n조사대상",		Type:"Text",	MinWidth:50,		Align:"Center",		SaveName:"qsn_obj"},
				{Header:"필요복구자원\n조사완료여부|필요복구자원\n조사완료여부",	Type:"Text",	MinWidth:50,		Align:"Center",		SaveName:"qsn_com_yn"},
				{Header:"설문등록여부|설문등록여부",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"qsn_rg_yn", Hidden:true}
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
			
			//doAction('search5');
			
		}		
		
		var SearchEnd = false;
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/* Sheet 각종 처리 */
		function doAction(sAction){
			switch(sAction){
				case "search": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010402");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search2": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010403");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search3": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010404");
					
					mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "search4": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010405");
					
					mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
				/* case "search5":
					
					SearchEnd = false;
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010406");
					
					mySheet5.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);					
					break; */
					
				case "insert1": //중요정보조사 insert
					mySheet.DataInsert(-1);
					
					break;
				case "delete1": //중요정보조사 delete
					var row = mySheet.GetSelectRow();
					
					if(mySheet.GetCellValue(row, "dsqno")==""){
						mySheet.RowDelete();
					}else{
						alert("새로 추가된 행이 없습니다.");
						return;
					}
					
					break;
				case "insert2": //필요요구인력 조사 insert
					var row = mySheet2.DataInsert(-1);
				
					mySheet2.SetCellValue(row, "brc", $("#chrg_brc").val());
					mySheet2.SetCellValue(row, "brnm", $("#chrg_brnm").val());
					
					break;
				case "delete2": //필요요구인력 조사 delete
					var row = mySheet2.GetSelectRow();
					
					if(mySheet2.GetCellValue(row, "dsqno")==""){
						mySheet2.RowDelete();
					}else{
						alert("새로 추가된 행이 없습니다.");
						return;
					}
					
					break;
				case "insert3": //이해관계자 조사 insert
					mySheet3.DataInsert(-1);
					
					break;
				case "delete3": //이해관계자 조사 delete
					var row = mySheet3.GetSelectRow();
					
					if(mySheet3.GetCellValue(row, "dsqno")==""){
						mySheet3.RowDelete();
					}else{
						alert("새로 추가된 행이 없습니다.");
						return;
					}
					
					break;
				case "insert4": //필요사무기기 조사 insert
					mySheet4.DataInsert(-1);
					
					break;
				case "delete4": //필요사무기기 조사 delete
					var row = mySheet4.GetSelectRow();
					
					if(mySheet4.GetCellValue(row, "dsqno")==""){
						mySheet4.RowDelete();
					}else{
						alert("새로 추가된 행이 없습니다.");
						return;
					}
					
					break;
					
				case "save":
					if(mySheet.GetDataFirstRow()>0||mySheet2.GetDataFirstRow()>0||mySheet3.GetDataFirstRow()>0||mySheet4.GetDataFirstRow()>0){
						save();
					}else{
						alert("저장 내역이 없습니다.");
						return;
					}
						
					
					break;

			}
		}
		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			
			if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="chrg_empnm" || mySheet2.GetCellProperty(Row, Col, "SaveName")=="brnm" || mySheet2.GetCellProperty(Row, Col, "SaveName")=="oft"){
				emp_popup();
			}
		}
		//function mySheet5_OnClick(Row, Col, Value, CellX, Celly, CellW, CellH, rowType){
		function mySheet5_OnSelectCell(OldRow, OldCol, Row, Col,isDelete) {
			if(Row < mySheet5.GetDataFirstRow()) return;
			if(!SearchEnd){
				mySheet5.SetSelectRow(-1);
				return;
			}
			if(mySheet5.GetCellValue(Row, "qsn_obj")=="대상"){
				$("#hd_bsn_prss_c").val(mySheet5.GetCellValue(Row, "bsn_prss_c"));
				doAction("search");
				doAction("search2");
				doAction("search3");
				doAction("search4");
				//setTimeout(function(){$(".p_body").scrollTop(0);},1000);

				
			}else{
				alert("필요복구자원 조사대상이 아닙니다.");
				mySheet5.SetSelectRow(OldRow);
			}
		}
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("중요정보 조사 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			var bia_evl_prg_stsc = $("#bia_evl_prg_stsc").val();
			if(bia_evl_prg_stsc!="01"){
				mySheet.SetEditable(0);
			}
			$(".p_body").scrollTop(0);
		}
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장하였습니다.");  // 저장 성공 메시지
		        //doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        //doAction('search');
		    }
		}
		
		function mySheet2_OnSearchEnd(code, message){
			if(code != 0){
				alert("필요 요구인력 조사 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			var bia_evl_prg_stsc = $("#bia_evl_prg_stsc").val();
			if(bia_evl_prg_stsc!="01"){
				mySheet2.SetEditable(0);
			}
			$(".p_body").scrollTop(0);
		}
		
		function mySheet2_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장하였습니다.");  // 저장 성공 메시지
		        //doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        //doAction('search');
		    }

		}

		function mySheet3_OnSearchEnd(code, message){
			if(code != 0){
				alert("이해관계자 조사 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			var bia_evl_prg_stsc = $("#bia_evl_prg_stsc").val();
			if(bia_evl_prg_stsc!="01"){
				mySheet3.SetEditable(0);
			}
			$(".p_body").scrollTop(0);
		}
		
		function mySheet3_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장하였습니다.");  // 저장 성공 메시지
		        //doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        //doAction('search');
		    }
		}
		
		function mySheet4_OnSearchEnd(code, message){
			if(code != 0){
				alert("필요 사무기기 조사 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			var bia_evl_prg_stsc = $("#bia_evl_prg_stsc").val();
			if(bia_evl_prg_stsc!="01"){
				mySheet4.SetEditable(0);
			}
			$(".p_body").scrollTop(0);
		}
		
		function mySheet4_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장하였습니다.");  // 저장 성공 메시지
		        //doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        //doAction('search');
		    }
		}			
		
		function mySheet5_OnSearchEnd(code, message){
			if(code != 0){
				alert("필요 사무기기 조사 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			if(mySheet5.GetDataFirstRow()>0){
				var bsn_prss_c = $("#hd_bsn_prss_c").val();
				var max_pmss_ssp_prdc = $("#max_pmss_ssp_prdc").val();
				
				for(var i=mySheet5.GetDataFirstRow(); i<=mySheet5.GetDataLastRow(); i++){
					
					if(bsn_prss_c==mySheet5.GetCellValue(i, "bsn_prss_c") && max_pmss_ssp_prdc==""){
						//mySheet5.SetSelectRow(i);
					}else if(bsn_prss_c==mySheet5.GetCellValue(i, "bsn_prss_c") && max_pmss_ssp_prdc!=""){
						if(max_pmss_ssp_prdc=="01"){
							//mySheet5.SetSelectRow(i);
							mySheet5.SetCellValue(i, "max_pmss_ssp_prdnm", "3시간");
						}else if(max_pmss_ssp_prdc=="02"){
							//mySheet5.SetSelectRow(i);
							mySheet5.SetCellValue(i, "max_pmss_prdnm", "1영업일");
						}
					}
					
					if(mySheet5.GetCellValue(i, "max_pmss_ssp_prdnm")=="3시간" || mySheet5.GetCellValue(i, "max_pmss_ssp_prdnm")=="1영업일"){
						mySheet5.SetCellValue(i, "qsn_obj", "대상");
						
						if(mySheet5.GetCellValue(i, "qsn_rg_yn")=="Y"){
							mySheet5.SetCellValue(i, "qsn_com_yn", "완료");
						}else{
							mySheet5.SetCellValue(i, "qsn_com_yn", "미완료");
						}
					}
					
				}
				for(var i=mySheet5.GetDataFirstRow(); i<=mySheet5.GetDataLastRow(); i++){
					
					if(bsn_prss_c==mySheet5.GetCellValue(i, "bsn_prss_c")){
						//alert(bsn_prss_c)
						SearchEnd = true;
						mySheet5.SetSelectRow(i);
						break;
					}
					
				}
			}
			
			tooltip();
			
			$(".p_body").scrollTop(0);
		}
		
		function tooltip(){
			var tooltip = "[도움말 내용] <br>"+
						  "해당 업무 프로세스에 필요한 중요정보(사무기기 및 기본 컴퓨터 시스템 外) <br>"+
						  "(예시 : 업무 메뉴얼, 암호키, 관련 중요서류)를 작성";
			var tooltip2 = "[도움말 내용] <br>"+
						   "해당 업무프로세스의 복구담당자(정)(부)의 정보를 입력 <br>"+
						   "(선정기준 : 팀/실/본부 내 대부분 업무를 다룰수 있는 인력으로 선정, 대체사업장으로 이동하는 인력임으로 팀별로 인원 최소화 필요)";
			var tooltip3 = "[도움말 내용] <br>"+
						   "해당 업무프로세스가 중단되었을 시 알려야 하는 해당 업무와 관련되 이해관계자 정보를 조사";
			var tooltip4 = "[도움말 내용] <br>"+
						   "해당 업무프로세스에 필요한 중요정보(기본 컴퓨터 시스템 外) <br>"+
						   "(예시 : (블룸버그 단말기, MACPC, FAX, CHECK 단말기 등 )를 작성하며, 나누어 사용 가능한 경우 0.5대, 0.2대 등으로 작성가능)";
						   
			mySheet.SetToolTipText(0, "delchk", tooltip);
			mySheet2.SetToolTipText(0, "delchk", tooltip2);
			mySheet3.SetToolTipText(0, "delchk", tooltip3);
			mySheet4.SetToolTipText(0, "delchk", tooltip4);
			
		}
		
		function save(){
			var f = document.ormsForm;
			var html = "";
			
			if(mySheet.GetDataFirstRow()>=0){
				
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					html += "<input type='hidden' name='status' 		value='" 	+ mySheet.GetCellValue(j,"status") 			+ "'>";
					html += "<input type='hidden' name='dsqno' 			value='" 	+ mySheet.GetCellValue(j,"dsqno") 			+ "'>";
					html += "<input type='hidden' name='ipt_infnm' 		value='" 	+ mySheet.GetCellValue(j,"ipt_infnm") 		+ "'>";
					html += "<input type='hidden' name='ipt_inf_form_c' value='" 	+ mySheet.GetCellValue(j,"ipt_inf_form_c") 	+ "'>";
					html += "<input type='hidden' name='strg_locnm' 	value='" 	+ mySheet.GetCellValue(j,"strg_locnm") 		+ "'>";
					html += "<input type='hidden' name='bkup_yn' 		value='" 	+ mySheet.GetCellValue(j,"bkup_yn") 		+ "'>";
					html += "<input type='hidden' name='bkup_form_c' 	value='" 	+ mySheet.GetCellValue(j,"bkup_form_c") 	+ "'>";
					html += "<input type='hidden' name='bkup_fqc' 		value='" 	+ mySheet.GetCellValue(j,"bkup_fqc") 		+ "'>";
					html += "<input type='hidden' name='plcnm' 			value='" 	+ mySheet.GetCellValue(j,"plcnm") 			+ "'>";
				}
			}
			
 			if(mySheet2.GetDataFirstRow()>=0){
				for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
					html += "<input type='hidden' name='status2' 		value='" 	+ mySheet2.GetCellValue(j,"status") 		+ "'>";
					html += "<input type='hidden' name='dsqno2' 		value='" 	+ mySheet2.GetCellValue(j,"dsqno") 			+ "'>";
					html += "<input type='hidden' name='rcvr_hmrs_dsc' 	value='" 	+ mySheet2.GetCellValue(j,"rcvr_hmrs_dsc") 	+ "'>";
					html += "<input type='hidden' name='brc' 			value='" 	+ mySheet2.GetCellValue(j,"brc") 			+ "'>";
					html += "<input type='hidden' name='eno' 			value='" 	+ mySheet2.GetCellValue(j,"eno") 			+ "'>";
					html += "<input type='hidden' name='chrg_bsnnm' 	value='" 	+ mySheet2.GetCellValue(j,"chrg_bsnnm") 	+ "'>";
					html += "<input type='hidden' name='mpno' 			value='" 	+ mySheet2.GetCellValue(j,"mpno") 			+ "'>";
					html += "<input type='hidden' name='email_adr' 		value='" 	+ mySheet2.GetCellValue(j,"email_adr") 		+ "'>";
					html += "<input type='hidden' name='ohse_adr' 		value='" 	+ mySheet2.GetCellValue(j,"ohse_adr") 		+ "'>";
					html += "<input type='hidden' name='ohse_telno' 	value='" 	+ mySheet2.GetCellValue(j,"ohse_telno") 	+ "'>";
				}
			}
			
			if(mySheet3.GetDataFirstRow()>=0){
				for(var j=mySheet3.GetDataFirstRow(); j<=mySheet3.GetDataLastRow(); j++){
					
					html += "<input type='hidden' name='status3' 		value='" 	+ mySheet3.GetCellValue(j,"status") 		+ "'>";
					html += "<input type='hidden' name='dsqno3' 		value='" 	+ mySheet3.GetCellValue(j,"dsqno") 			+ "'>";
					html += "<input type='hidden' name='conm' 			value='" 	+ mySheet3.GetCellValue(j,"conm") 			+ "'>";
					html += "<input type='hidden' name='deptnm' 		value='" 	+ mySheet3.GetCellValue(j,"deptnm") 		+ "'>";
					html += "<input type='hidden' name='chrg_empnm' 	value='" 	+ mySheet3.GetCellValue(j,"chrg_empnm") 	+ "'>";
					html += "<input type='hidden' name='pzcnm' 			value='" 	+ mySheet3.GetCellValue(j,"pzcnm") 			+ "'>";
					html += "<input type='hidden' name='chrg_bsnnm' 	value='" 	+ mySheet3.GetCellValue(j,"chrg_bsnnm") 	+ "'>";
					html += "<input type='hidden' name='mpno' 			value='" 	+ mySheet3.GetCellValue(j,"mpno") 			+ "'>";
					html += "<input type='hidden' name='email_adr' 		value='" 	+ mySheet3.GetCellValue(j,"email_adr") 		+ "'>";
					html += "<input type='hidden' name='offc_telno' 	value='" 	+ mySheet3.GetCellValue(j,"offc_telno") 	+ "'>";
				}
			}
			
			if(mySheet4.GetDataFirstRow()>=0){
				for(var j=mySheet4.GetDataFirstRow(); j<=mySheet4.GetDataLastRow(); j++){
					html += "<input type='hidden' name='status4' 		value='" 	+ mySheet4.GetCellValue(j,"status") 		+ "'>";
					html += "<input type='hidden' name='dsqno4' 		value='" 	+ mySheet4.GetCellValue(j,"dsqno") 			+ "'>";
					html += "<input type='hidden' name='bzs_devcnm' 	value='" 	+ mySheet4.GetCellValue(j,"bzs_devcnm") 	+ "'>";
					html += "<input type='hidden' name='qt' 			value='" 	+ mySheet4.GetCellValue(j,"qt") 			+ "'>";
					html += "<input type='hidden' name='ug_uz_expl' 	value='" 	+ mySheet4.GetCellValue(j,"ug_uz_expl") 	+ "'>";
				}
			}
			
			
			bcp_html.innerHTML = html;
			alert(html);
			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC010407");
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
							doAction("search");
							doAction("search2");
							doAction("search3");
							doAction("search4");
							//doAction("search5");
							
							removeLoadingWs();
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result=='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});			
		}
		
		function next_chk(){
			
			var com = true;
			
			if(mySheet.GetDataFirstRow()>0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i, "status")=="I" || mySheet.GetCellValue(i, "status")=="D" || mySheet.GetCellValue(i, "status")=="U"){
						alert("중요정보 조사 중 저장 대상이 있습니다. 저장을 먼저 해주세요.");
						save();
						com = false;
						return;
					}
				}
			}
			if(mySheet2.GetDataFirstRow()>0){
				for(var i=mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
					if(mySheet2.GetCellValue(i, "status")=="I" || mySheet2.GetCellValue(i, "status")=="D" || mySheet2.GetCellValue(i, "status")=="U"){
						alert("필요요구인력 조사 중 저장 대상이 있습니다. 저장을 먼저 해주세요.");
						save();
						com = false;
						return;
					}
						
				}
			}
			if(mySheet3.GetDataFirstRow()>0){
				for(var i=mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
					if(mySheet3.GetCellValue(i, "status")=="I" || mySheet3.GetCellValue(i, "status")=="D" || mySheet3.GetCellValue(i, "status")=="U"){
						alert("이해관계자 조사 중 저장 대상이 있습니다. 저장을 먼저 해주세요.");
						com = false;
						return;
					}
				}
			}
			if(mySheet4.GetDataFirstRow()>0){
				for(var i=mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
					if(mySheet4.GetCellValue(i, "status")=="I" || mySheet4.GetCellValue(i, "status")=="D" || mySheet4.GetCellValue(i, "status")=="U"){
						alert("필요 사무긱 조사 중 저장 대상이 있습니다. 저장을 먼저 해주세요.");
						save();
						com = false;
						return;
					}
				}
			}
			
			if(com){
				next();
			}
			
			
			
			
			
			
		}
		
		function next(){
			var row = parseInt(mySheet5.GetSelectRow())+1;
			var com = true;
			
			if(row>parseInt(mySheet5.GetDataLastRow())){
				row = mySheet5.GetDataFirstRow();
			}
			mySheet5.SetSelectRow(row);
			
			if(mySheet5.GetCellValue(row, "max_pmss_ssp_prdnm")=="3시간" || mySheet5.GetCellValue(row, "max_pmss_ssp_prdnm")=="1영업일"){
				doAction("search");
				doAction("search2");
				doAction("search3");
				doAction("search4");
			}else{
				alert("대상이 아닙니다.");
			}
			
				
		}
		
		
		
	</script>
</head>
<body>
	<form name="ormsForm">
		<input type="hidden" id="path" name="path" />
		<input type="hidden" id="process_id" name="process_id" />
		<input type="hidden" id="commkind" name="commkind" />
		<input type="hidden" id="method" name="method" />
		<input type="hidden" id="today" name="today" value="<%=dt %>" />
		<input type="hidden" id="hd_bia_yy" name="hd_bia_yy" value="<%=bia_yy %>" />
		<input type="hidden" id="bia_evl_prg_stsc" name="bia_evl_prg_stsc" value="<%=bia_evl_prg_stsc %>" />
		<input type="hidden" id="hd_bsn_prss_c" name="hd_bsn_prss_c" value="<%=hd_bsn_prss_c %>" />
		<input type="hidden" id="chrg_brc" name="chrg_brc" value="<%=chrg_brc %>" />
		<input type="hidden" id="chrg_brnm" name="chrg_brnm" value="<%=chrg_brnm %>" />
		<input type="hidden" id="max_pmss_ssp_prdc" name="max_pmss_ssp_prdc" value="<%=max_pmss_ssp_prdc %>" />
		
		<div id="bcp_html"></div>
		
	<div id="" class="popup modal block">
			<div class="p_frame w1100">

				<div class="p_head">
					<h3 class="title">필요복구자원조사</h3>
				</div>


				<div class="p_body">
					
					<div class="p_wrap">

						<!-- <h4 class="title md">BIA 결과 요약</h4>

						<div class="box box-grid mb30">						
							<div class="box-body">
								<div class="wrap-grid h200">
									<script type="text/javascript"> createIBSheet("mySheet5", "100%", "100%"); </script>
								</div>
							</div>
						</div>	 -->					

						<h4 class="title">핵심업무 필요복구자원 조사</h4>

						<div class="box box-grid">						
							<div class="box-header">	
								<div class="area-tool">
									<div class="btn-group btn-pm">
										<button class="btn btn-primary btn-xs" type="button" onclick="javascript:doAction('insert1');"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
										<button class="btn btn-normal btn-xs" type="button" onclick="javascript:doAction('delete1');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
									</div>
								</div>	
							</div>
							<div class="box-body">
								<div class="wrap-grid h200">
									<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
								</div>
							</div>
						</div>

						<div class="box box-grid">						
							<div class="box-header">	
								<div class="area-tool">
									<div class="btn-group btn-pm">
										<button class="btn btn-primary btn-xs" type="button" onclick="javascript:doAction('insert2');"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
										<button class="btn btn-normal btn-xs" type="button"  onclick="javascript:doAction('delete2');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
									</div>
								</div>	
							</div>
							<div class="box-body">
								<div class="wrap-grid h200">
									<script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script>
								</div>
							</div>
						</div>

						<div class="box box-grid">						
							<div class="box-header">	
								<div class="area-tool">
									<div class="btn-group btn-pm">
										<button class="btn btn-primary btn-xs" type="button" onclick="javascript:doAction('insert3');"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
										<button class="btn btn-normal btn-xs" type="button" onclick="javascript:doAction('delete3');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
									</div>
								</div>	
							</div>
							<div class="box-body">
								<div class="wrap-grid h200">
									<script type="text/javascript"> createIBSheet("mySheet3", "100%", "100%"); </script>
								</div>
							</div>
						</div>

						<div class="box box-grid">						
							<div class="box-header">	
								<div class="area-tool">
									<div class="btn-group btn-pm">
										<button class="btn btn-primary btn-xs" type="button" onclick="javascript:doAction('insert4');"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
										<button class="btn btn-normal btn-xs" type="button" onclick="javascript:doAction('delete4');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
									</div>
								</div>	
							</div>
							<div class="box-body">
								<div class="wrap-grid h200">
									<script type="text/javascript"> createIBSheet("mySheet4", "100%", "100%"); </script>
								</div>
							</div>
						</div>

					</div>
					
				</div>


				<div class="p_foot">
					<div class="btn-wrap">
<%
if(bia_evl_prg_stsc.equals("02") && dt.compareTo(bia_evl_ed_dt)<=0){
%>
						<button type="button" class="btn btn-primary" onclick="javascript:doAction('save');">저장</button>
						<button type="button" class="btn btn-primary" onclick="javascript:next_chk();">다음</button>
						<button type="button" class="btn btn-default btn-close">닫기</button>
<%	
}else{
%>
						<button type="button" class="btn btn-default btn-close">닫기</button>
<%	
}
%>					
					</div>
				</div>

				<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>

			</div>
		<div class="dim p_close"></div>
	</div>
	</form>
	
	<%@ include file="../comm/EmpInfP.jsp" %> <!-- 직원 공통 팝업 -->
	
	<script>
		<%-- 직원 시작 --%>		
		function emp_popup(){
			schEmpPopup("<%=chrg_brc%>","empSearchEnd");
			//$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
		}
		// 직원검색 완료
		function empSearchEnd(eno, empnm, brnm, pzcnm){
			var row = mySheet2.GetSelectRow();
			mySheet2.SetCellValue(row, "eno", eno);
			mySheet2.SetCellValue(row, "chrg_empnm", empnm);
			mySheet2.SetCellValue(row, "pzcnm", pzcnm);
	
			$("#winEmp").hide();
			//doAction('search');
		}
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				parent.$("#ifrBiaEvl").attr("src","about:blank");
				event.preventDefault();
			});
		});
		function closePop(){
			$("#winBiaEvl",parent.document).hide();
		}
	</script>
</body>
</html>