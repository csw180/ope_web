<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0109.jsp
 Program name : 공통손실 상세조회 (팝업)
 Description  : LDM-07.2
 Programer    : 이규탁
 Date created : 2022.08.12
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@	page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page
	import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext"%>
<%@ include file="../comm/comUtil.jsp"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	SysDateDao dao = new SysDateDao(request);

	String dt = dao.getSysdate();//yyyymmdd

	HashMap hMapSession = (HashMap)request.getSession(true).getAttribute("infoH");

	DynaForm form = (DynaForm)request.getAttribute("form");
	String lshp_amnno = (String) form.get("lshp_amnno"); //손실사건관리번호
	String role_id = (String)form.get("role_id"); //역할구분코드
	
	//CommUtil.getCommonCode() -> 공통코드조회 메소드
	//unit01
	Vector vLsHurDeptCLst = CommUtil.getCommonCode(request, "LS_HUR_DEPT_C");
	if(vLsHurDeptCLst==null) vLsHurDeptCLst = new Vector();
	//unit02
	Vector vLshpFormLst = CommUtil.getCommonCode(request, "LSHP_FORM_C");
	if(vLshpFormLst==null) vLshpFormLst = new Vector(); 
	//unit03
	Vector vLshpStscLst = CommUtil.getCommonCode(request, "LSHP_STSC");
	if(vLshpStscLst==null) vLshpStscLst = new Vector();
	//unit04
	Vector vLshpDczStsDscLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC");
	if(vLshpDczStsDscLst==null) vLshpDczStsDscLst = new Vector();
	//unit06
	Vector vLssAcgAcccLst = CommUtil.getCommonCode(request, "LSS_ACG_ACCC");
	if(vLssAcgAcccLst==null) vLssAcgAcccLst = new Vector();
	//unit07
	Vector vLshpRztcLst= CommUtil.getCommonCode(request, "LSHP_RZT_C");
	if(vLshpRztcLst==null) vLshpRztcLst = new Vector();
	//unit08
	Vector vLsIsrKdcLst = CommUtil.getCommonCode(request, "LS_ISR_KDC");
	if(vLsIsrKdcLst==null) vLsIsrKdcLst = new Vector();
	//unit09
	Vector vLwsjdgDscLst = CommUtil.getCommonCode(request, "LWSJDG_DSC");
	if(vLwsjdgDscLst==null) vLwsjdgDscLst = new Vector();
	//unit10
	Vector vLwsRztCLst = CommUtil.getCommonCode(request, "LWS_RZT_C");
	if(vLwsRztCLst==null) vLwsRztCLst = new Vector();
	//unit11
	Vector vHpnOcuNatcdLst = CommUtil.getCommonCode(request, "HPN_OCU_NATCD");
	if(vHpnOcuNatcdLst==null) vHpnOcuNatcdLst = new Vector();
	//unit12
	Vector vLsSpfAmnDeptCLst = CommUtil.getCommonCode(request, "LS_SPF_AMN_DEPT_C");
	if(vLsSpfAmnDeptCLst==null) vLsSpfAmnDeptCLst = new Vector();
	//unit05
	Vector vLossDtlMap = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
	if(vLossDtlMap==null) vLossDtlMap = new Vector();


	HashMap hLossDtlMap = null;
	if(vLossDtlMap.size()>0){
		hLossDtlMap = (HashMap)vLossDtlMap.get(0);
	}else{
		hLossDtlMap = new HashMap();
	}

	String acg_accc = "";
	String acg_accnm = "";

	for(int i=0;i<vLssAcgAcccLst.size();i++){
		HashMap hp = (HashMap)vLssAcgAcccLst.get(i);
		if(acg_accc==""){
			acg_accc += (String)hp.get("intgc");
			acg_accnm += (String)hp.get("intg_cnm");
		}else{
			acg_accc += ("|" + (String)hp.get("intgc"));
			acg_accnm += ("|" + (String)hp.get("intg_cnm"));
		}
	}

	String ls_isr_kdc = "";
	String ls_isr_kdnm = "";

	for(int i=0;i<vLsIsrKdcLst.size();i++){
		HashMap hp = (HashMap)vLsIsrKdcLst.get(i);
		if(ls_isr_kdc==""){
			ls_isr_kdc += (String)hp.get("intgc");
			ls_isr_kdnm += (String)hp.get("intg_cnm");
		}else{
			ls_isr_kdc += ("|" + (String)hp.get("intgc"));
			ls_isr_kdnm += ("|" + (String)hp.get("intg_cnm"));
		}
	}

	String auth_ids = hs.get("auth_ids").toString();
	String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");  

%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<%@ include file="../comm/library.jsp"%>
<script>
			$(function() {	
				
			});
		</script>
<script>
			$(document).ready(function(){
				//$("#winRskMod",parent.document).show();
				// ibsheet 초기화
				initIBSheet1();
				initIBSheet2();
				initIBSheet3();
				initIBSheet4();
				initIBSheet5();
				initIBSheet6();
	
				ableByRole(parent.$("#role_id").val());
// 				chk_ham_xpc_am();	//손실형태 재무손실이면서 신용리스크일때 피해예상금액 사용
				
				parent.removeLoadingWs();
				
			});
			
			/***************************************************************************************/
			/* 손실발생금액(mySheet1) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet1() {
				//시트 초기화
				mySheet1.Reset();
				
				var initData1 = {};
				
 				initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData1.Cols = [
				    {Header:"No",			Type:"Seq",		SaveName:"rw_no",									Width:30,Align:"center"},
// 				    {Header:"계산",			Type:"Combo",	SaveName:"tt_yn",		Hidden:true,				Width:40,Align:"center", 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
				    {Header:"계정구분코드",		Type:"Text",	SaveName:"acc_dsc",		Hidden:true},
				    {Header:"손실금액일련번호",	Type:"Text",	SaveName:"lssam_sqno",	Hidden:true},
				    {Header:"상태",			Type:"Status",	SaveName:"status",		Hidden:true,				Width:30,Align:"center"},
				    {Header:"acc_sqno",		Type:"Text",	SaveName:"acc_sqno",	Hidden:true},
				    {Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",							Width:270,Align:"Left",	 					ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
				    {Header:"acc_brc",			Type:"Text",	SaveName:"acc_brc",			Hidden:true},
				    {Header:"crc_can_dsc",	Type:"Text",	SaveName:"crc_can_dsc",	Hidden:true},
				    {Header:"회계처리일",		Type:"Date",	SaveName:"acg_prc_dt",		Format:"yyyyMMdd",		Width:90,Align:"center"},
				    {Header:"금액",			Type:"Int",		SaveName:"lsoc_am",									Width:100,Align:"Right",AcceptKeys:"N"},
				    {Header:"거래내역",		Type:"Text",	SaveName:"tr_cntn",									Width:250,Align:"Left"},
				    {Header:"비고",			Type:"Text",	SaveName:"rmk_cntn",								Width:120,Align:"Left", EditLen:200},
				    {Header:"차대",			Type:"Combo",	SaveName:"rvpy_dsc",								Width:60, 											ComboText:"입금|지급", ComboCode:"1|2",PopupText:"입금|지급"},
				    {Header:"hpn_rc_dt",	Type:"Text",	SaveName:"hpn_rc_dt",	Hidden:true},
				    {Header:"acd_no",		Type:"Text",	SaveName:"acd_no",		Hidden:true},
				    {Header:"보험종류",		Type:"Combo",	SaveName:"ls_isr_kdc",	Hidden:true, Wrap:true,		Width:160,Align:"Left",	 				ComboText:"<%=ls_isr_kdnm%>",ComboCode:"<%=ls_isr_kdc%>",},
				    {Header:"lws_prg_cntn",	Type:"Text",	SaveName:"lws_prg_cntn",Hidden:true},
				    {Header:"lws_hpn_no",	Type:"Text",	SaveName:"lws_hpn_no",	Hidden:true},
				    {Header:"wdr_am_rcp_dt",Type:"Text",	SaveName:"wdr_am_rcp_dt",Hidden:true},
					{Header:"삭제",			Type:"Html",	SaveName:"del_btn",									Width:40,Align:"Center"}
				];
				
				
				IBS_InitSheet(mySheet1,initData1);
				
				//필터표시
				//mySheet1.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet1.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet1.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				mySheet1.InitComboNoMatchText(1,"",1);  
				//최초 조회시 포커스를 감춘다.
				mySheet1.SetFocusAfterProcess(0);
				
				mySheet1.SetAutoRowHeight(1);
				
				//헤더기능 해제
				mySheet1.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});

				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet1);
				//mySheet1.SetTheme("GM", "Main");
				doAction_mySheet1('search');
				
			}
			/***************************************************************************************/
			/* 보험회수금액(mySheet2) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet2() {
				//시트 초기화
				mySheet2.Reset();
				
				var initData2 = {};
				
 				initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData2.Cols = [

				    {Header:"No",			Type:"Seq",		SaveName:"rw_no",									Width:30,Align:"center"},
// 				    {Header:"계산",			Type:"Combo",	SaveName:"tt_yn",		Hidden:true,				Width:40,Align:"center", 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
				    {Header:"계정구분코드",		Type:"Text",	SaveName:"acc_dsc",		Hidden:true},
				    {Header:"손실금액일련번호",	Type:"Text",	SaveName:"lssam_sqno",	Hidden:true},
				    {Header:"상태",			Type:"Status",	SaveName:"status",		Hidden:true,				Width:30,Align:"center"},
				    {Header:"acc_sqno",		Type:"Text",	SaveName:"acc_sqno",	Hidden:true},
				    {Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",	Wrap:true,				Width:160,Align:"Left",	 				ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
				    {Header:"acc_brc",			Type:"Text",	SaveName:"acc_brc",			Hidden:true},
				    {Header:"crc_can_dsc",	Type:"Text",	SaveName:"crc_can_dsc",	Hidden:true},
				    {Header:"회계처리일",		Type:"Date",	SaveName:"acg_prc_dt",		Format:"yyyyMMdd",		Width:90,Align:"center"},
				    {Header:"금액",			Type:"Int",		SaveName:"lsoc_am",									Width:80,Align:"Right",AcceptKeys:"N"},
				    {Header:"거래내역",		Type:"Text",	SaveName:"tr_cntn",		Wrap:true,MultiLineText:true,Width:170,Align:"Left"},
				    {Header:"비고",			Type:"Text",	SaveName:"rmk_cntn",								Width:80,Align:"Left", EditLen:200},
				    {Header:"입금지급구분코드",	Type:"Text",	SaveName:"rvpy_dsc",	Hidden:true},
				    {Header:"사건접수일",		Type:"Date",	SaveName:"hpn_rc_dt",								Width:90,Align:"center"},
				    {Header:"사고번호",		Type:"Text",	SaveName:"acd_no",		Hidden:true,							Width:70,Align:"Left",},
				    {Header:"보험종류",		Type:"Combo",	SaveName:"ls_isr_kdc",	Wrap:true,					Width:160,Align:"Left",	 				ComboText:"<%=ls_isr_kdnm%>",ComboCode:"<%=ls_isr_kdc%>",},
				    {Header:"lws_prg_cntn",	Type:"Text",	SaveName:"lws_prg_cntn",Hidden:true},
				    {Header:"lws_hpn_no",	Type:"Text",	SaveName:"lws_hpn_no",	Hidden:true},
				    {Header:"보험금수령일",		Type:"Date",	SaveName:"wdr_am_rcp_dt",Hidden:true,		Format:"yyyyMMdd",		Width:90,Align:"center"},
					{Header:"삭제",			Type:"Html",	SaveName:"del_btn",									Width:40,Align:"Center"}
				   
				    ];
				
				
				IBS_InitSheet(mySheet2,initData2);
				
				//필터표시
				//mySheet2.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet2.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet2.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				mySheet2.InitComboNoMatchText(1,"",1);  
				//최초 조회시 포커스를 감춘다.
				mySheet2.SetFocusAfterProcess(0);
				
				mySheet2.SetAutoRowHeight(1);

				//헤더기능 해제
				mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet1);
				//mySheet1.SetTheme("GM", "Main");
				doAction_mySheet2('search');
				
			}
			/***************************************************************************************/
			/* 소송금액(mySheet3) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet3() {
				//시트 초기화
				mySheet3.Reset();
				
				var initData3 = {};
				
 				initData3.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData3.Cols = [

				    {Header:"No",			Type:"Seq",		SaveName:"rw_no",									Width:30,Align:"center"},
// 				    {Header:"계산",			Type:"Combo",	SaveName:"tt_yn",		Hidden:true,				Width:40,Align:"center", 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
				    {Header:"계정구분코드",		Type:"Text",	SaveName:"acc_dsc",		Hidden:true},
				    {Header:"손실금액일련번호",	Type:"Text",	SaveName:"lssam_sqno",	Hidden:true},
				    {Header:"상태",			Type:"Status",	SaveName:"status",		Hidden:true,				Width:30,Align:"center"},
				    {Header:"acc_sqno",		Type:"Text",	SaveName:"acc_sqno",	Hidden:true},
				    {Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",	Wrap:true,				Width:140,Align:"Left",					ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
				    {Header:"acc_brc",			Type:"Text",	SaveName:"acc_brc",			Hidden:true},
				    {Header:"crc_can_dsc",	Type:"Text",	SaveName:"crc_can_dsc",	Hidden:true},
				    {Header:"회계처리일",		Type:"Date",	SaveName:"acg_prc_dt",								Width:90,Align:"center",Format:"yyyyMMdd"},
				    {Header:"금액",			Type:"Int",		SaveName:"lsoc_am",									Width:80,Align:"Right",AcceptKeys:"N"},
				    {Header:"거래내역",		Type:"Text",	SaveName:"tr_cntn",			Wrap:true,				Width:150,Align:"Left"},
				    {Header:"비고",			Type:"Text",	SaveName:"rmk_cntn",								Width:70,Align:"Left", EditLen:200},
				    {Header:"차대",			Type:"Combo", 	SaveName:"rvpy_dsc", 								Width:60, 											ComboText:"입금|지급", ComboCode:"1|2",PopupText:"입금|지급"},
				    {Header:"hpn_rc_dt",	Type:"Text",	SaveName:"hpn_rc_dt",	Hidden:true},
				    {Header:"acd_no",		Type:"Text",	SaveName:"acd_no",		Hidden:true},
				    {Header:"보험종류",		Type:"Combo",	SaveName:"ls_isr_kdc",	Hidden:true, Wrap:true,		Width:160,Align:"Left",	 				ComboText:"<%=ls_isr_kdnm%>",ComboCode:"<%=ls_isr_kdc%>",},
				    {Header:"진행심",			Type:"Combo",	SaveName:"lws_prg_cntn",							Width:50, 											ComboText:"1심|2심|3심|종결", ComboCode:"1심|2심|3심|종결",PopupText:"1심|2심|3심|종결"},
				    {Header:"사건번호",		Type:"Text",	SaveName:"lws_hpn_no",								Width:100,Align:"Left"},
				    {Header:"회수금수령일",		Type:"Date",	SaveName:"wdr_am_rcp_dt",							Width:90,Align:"center",Format:"yyyyMMdd"},
					{Header:"삭제",			Type:"Html",	SaveName:"del_btn",									Width:40,Align:"Center"}
				    
				    ];
				
				
				IBS_InitSheet(mySheet3,initData3);
				
				//필터표시
				//mySheet3.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet3.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet3.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				mySheet3.InitComboNoMatchText(1,"",1);  
				//최초 조회시 포커스를 감춘다.
				mySheet3.SetFocusAfterProcess(0);
				
				mySheet3.SetAutoRowHeight(1);

				//헤더기능 해제
				mySheet3.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet3);
				//mySheet3.SetTheme("GM", "Main");
				doAction_mySheet3('search');
				
			}
			/***************************************************************************************/
			/* 손실발생금액(mySheet4) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet4() {
				//시트 초기화
				mySheet4.Reset();
				
				var initData4 = {};
				
 				initData4.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData4.Cols = [

				    {Header:"No",			Type:"Seq",		SaveName:"rw_no",									Width:30,Align:"center"},
// 				    {Header:"계산",			Type:"Combo",	SaveName:"tt_yn",		Hidden:true,				Width:40,Align:"center", 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
				    {Header:"계정구분코드",		Type:"Text",	SaveName:"acc_dsc",		Hidden:true},
				    {Header:"손실금액일련번호",	Type:"Text",	SaveName:"lssam_sqno",	Hidden:true},
				    {Header:"상태",			Type:"Status",	SaveName:"status",		Hidden:true,				Width:30,Align:"center"},
				    {Header:"acc_sqno",		Type:"Text",	SaveName:"acc_sqno",	Hidden:true},
				    {Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",							Width:210,Align:"Left", 				ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
				    {Header:"acc_brc",		Type:"Text",	SaveName:"acc_brc",		Hidden:true},
				    {Header:"crc_can_dsc",	Type:"Text",	SaveName:"crc_can_dsc",	Hidden:true},
				    {Header:"회계처리일",		Type:"Date",	SaveName:"acg_prc_dt",								Width:90,Align:"center",Format:"yyyyMMdd"},
				    {Header:"금액",			Type:"Int",		SaveName:"lsoc_am",									Width:80,Align:"Right",AcceptKeys:"N"},
				    {Header:"거래내역",		Type:"Text",	SaveName:"tr_cntn",		Wrap:true,					Width:210,Align:"Left"},
				    {Header:"비고",			Type:"Text",	SaveName:"rmk_cntn",								Width:90,Align:"Left", EditLen:200},
				    {Header:"차대",			Type:"Combo", 	SaveName:"rvpy_dsc", 								Width:60, 								ComboText:"입금|지급", ComboCode:"1|2",PopupText:"입금|지급"},
				    {Header:"hpn_rc_dt",	Type:"Text",	SaveName:"hpn_rc_dt",	Hidden:true},
				    {Header:"acd_no",		Type:"Text",	SaveName:"acd_no",		Hidden:true},
				    {Header:"보험종류",		Type:"Combo",	SaveName:"ls_isr_kdc",	Hidden:true, Wrap:true,		Width:160,Align:"Left",	 				ComboText:"<%=ls_isr_kdnm%>",ComboCode:"<%=ls_isr_kdc%>",},
				    {Header:"진행심",			Type:"Combo",	SaveName:"lws_prg_cntn",Hidden:true,				Width:50, 								ComboText:"1심|2심|3심|종결", ComboCode:"1심|2심|3심|종결",PopupText:"1심|2심|3심|종결"},
				    {Header:"사건번호",		Type:"Text",	SaveName:"lws_hpn_no",	Hidden:true,				Width:80,Align:"Left"},
				    {Header:"회수금수령일",		Type:"Date",	SaveName:"wdr_am_rcp_dt",							Width:90,Align:"center",Format:"yyyyMMdd"},
					{Header:"삭제",			Type:"Html",	SaveName:"del_btn",									Width:40,Align:"Center"}

				    ];
				
				
				IBS_InitSheet(mySheet4,initData4);
				
				//필터표시
				//mySheet4.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet4.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet4.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				mySheet4.InitComboNoMatchText(1,"",1);  
				//최초 조회시 포커스를 감춘다.
				mySheet4.SetFocusAfterProcess(0);
				
				mySheet4.SetAutoRowHeight(1);

				//헤더기능 해제
				mySheet4.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet4);
				//mySheet4.SetTheme("GM", "Main");
				doAction_mySheet4('search');
				
			}

			/***************************************************************************************/
			/* 공통손실기준(mySheet5) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet5() {
				//시트 초기화
				mySheet5.Reset();
				
				var initData5 = {};
				
 				initData5.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData5.Cols = [

				    {Header:"관리번호",		Type:"Text",	SaveName:"comn_lshp_amnno",			Width:30,		Align:"Left", 	Edit:0},
				    {Header:"사건제목",		Type:"Text",	SaveName:"lshp_tinm",			MinWidth:100,	Align:"Left", 	Edit:0},
				    {Header:"상태",			Type:"Status",	SaveName:"status",				Hidden:true,	Align:"center", Edit:0},
				    {Header:"기준",			Type:"Text",	SaveName:"standard",			Width:30,		Align:"center", Edit:0},
				    {Header:"기준관리번호",		Type:"Text",	SaveName:"standard_amnno",		Hidden:true,	Align:"center", Edit:0},

				    ];
				
				
				IBS_InitSheet(mySheet5,initData5);
				
				//필터표시
				//mySheet5.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet5.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet5.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				//최초 조회시 포커스를 감춘다.
				mySheet5.SetFocusAfterProcess(0);
				
				mySheet5.SetAutoRowHeight(1);

				//헤더기능 해제
				mySheet5.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet5);
				//mySheet5.SetTheme("GM", "Main");
				doAction_mySheet5('search');
				
				
			}
			
			/***************************************************************************************/
			/* 공통손실등록이전 개별손실사건 이력(mySheet6) 처리                                                                                                                                                                                       */
			/***************************************************************************************/
			/*Sheet 기본 설정 */
			function initIBSheet6() {
				//시트 초기화
				mySheet6.Reset();
				
				var initData6 = {};
				
 				initData6.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
				initData6.Cols = [

				    {Header:"공통손실등록일자",				Type:"Text",	SaveName:"fir_inp_dtm",		Width:60,		Align:"Left", 	Edit:0},
				    {Header:"등록이전 손실사건관리번호",		Type:"Text",	SaveName:"lshp_amnno",		Width:50,		Align:"Left", 	Edit:0},
				    {Header:"사건발생부서/영업점",			Type:"Text",	SaveName:"ocu_brc",			Hidden:true,	Align:"center", Edit:0},
				    {Header:"사건발생부서/영업점",			Type:"Text",	SaveName:"brnm",			Width:50,		Align:"Left", 	Edit:0},
				    {Header:"사건제목",					Type:"Text",	SaveName:"lshp_tinm",		Width:100,		Align:"Left", 	Edit:0},

				    ];
				
				
				IBS_InitSheet(mySheet6,initData6);
				
				//필터표시
				//mySheet6.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet6.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet6.SetSelectionMode(4);
				
				/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
				//최초 조회시 포커스를 감춘다.
				mySheet6.SetFocusAfterProcess(0);
				
				mySheet6.SetAutoRowHeight(1);

				//헤더기능 해제
				mySheet6.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet6);
				//mySheet6.SetTheme("GM", "Main");
				doAction_mySheet6('search');
				
				
			}
			
			function mySheet5_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert(Row);
				if(Row >= mySheet5.GetDataFirstRow()){
					$("#lshp_amnno").val(mySheet5.GetCellValue(Row,"comn_lshp_amnno"));
				}
			}	
			function mySheet6_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert(Row);
				if(Row >= mySheet6.GetDataFirstRow()){
					$("#lshp_amnno").val(mySheet6.GetCellValue(Row,"lshp_amnno"));
				}
			}
			function mySheet6_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert(Row);
				if(Row >= mySheet6.GetDataFirstRow()){
					$("#lshp_amnno").val(mySheet6.GetCellValue(Row,"lshp_amnno"));
					$("#role_id").val("nh");
					doAction_mySheet6('mod');
				}
			}
			
			function mySheet1_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("손실발생 금액조회 중에 오류가 발생하였습니다..");
				}else{
					for (var i = mySheet1.GetDataFirstRow(); i <= mySheet1.GetDataLastRow(); i++) {
						mySheet1.SetCellText(i, "del_btn", '<button type="button" class="btn btn-default btn-xs" onclick="del_btn1(' + i + ')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						mySheet1.SetCellValue(i, "status", "");
						if (mySheet1.GetCellValue(i, "acc_sqno") != "") {		//accsqno의 유무로 연결계정 판단 
							mySheet1.SetCellEditable(i, "lss_acg_accc", 0);
							mySheet1.SetCellEditable(i, "acg_prc_dt", 0);
							mySheet1.SetCellEditable(i, "lsoc_am", 0);
							mySheet1.SetCellEditable(i, "tr_cntn", 0);
							mySheet1.SetCellEditable(i, "rvpy_dsc", 0);
						}
					}	
					
					//role_id, lshp_dcz_sts_dsc 별 수정 및 삭제버튼 
					var lshp_dcz_sts_dsc = $("#lshp_dcz_sts_dsc").val();
					var role_id = parent.$("#role_id").val();
					if(role_id=="orm"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet1.SetEditable(0);
							mySheet1.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="nml"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet1.SetEditable(0);
							mySheet1.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="admn"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet1.SetEditable(0);
							mySheet1.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="ormld"){
						mySheet1.SetEditable(0);
						mySheet1.SetColHidden("del_btn", 1);
					}else if(role_id=="nmlld"){
						mySheet1.SetEditable(0);
						mySheet1.SetColHidden("del_btn", 1);
					}
					
					calLssAm();
				}
				
				
			}
			function mySheet2_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("보험회수 금액조회 중에 오류가 발생하였습니다..");
				}else{
					for (var i = mySheet2.GetDataFirstRow(); i <= mySheet2.GetDataLastRow(); i++) {
						mySheet2.SetCellText(i, "del_btn", '<button type="button" class="btn btn-default btn-xs" onclick="del_btn2(' + i + ')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						mySheet2.SetCellValue(i, "status", "");
						if (mySheet2.GetCellValue(i, "acc_sqno") != "") {
							mySheet2.SetCellEditable(i, "lss_acg_accc", 0);
							mySheet2.SetCellEditable(i, "acg_prc_dt", 0);
							mySheet2.SetCellEditable(i, "lsoc_am", 0);
							mySheet2.SetCellEditable(i, "tr_cntn", 0);
						}
					}			
					
					//role_id, lshp_dcz_sts_dsc 별 수정 및 삭제버튼 
					var lshp_dcz_sts_dsc = $("#lshp_dcz_sts_dsc").val();
					var role_id = parent.$("#role_id").val();
					if(role_id=="orm"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet2.SetEditable(0);
							mySheet2.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="nml"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet2.SetEditable(0);
							mySheet2.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="admn"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet2.SetEditable(0);
							mySheet2.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="ormld"){
						mySheet2.SetEditable(0);
						mySheet2.SetColHidden("del_btn", 1);
					}else if(role_id=="nmlld"){
						mySheet2.SetEditable(0);
						mySheet2.SetColHidden("del_btn", 1);
					}
					
					calIsrAm();
				}
			}
			function mySheet3_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("소송비용 및 소송회수 금액조회 중에 오류가 발생하였습니다..");
				}else{
					for (var i = mySheet3.GetDataFirstRow(); i <= mySheet3.GetDataLastRow(); i++) {
						mySheet3.SetCellText(i, "del_btn", '<button type="button" class="btn btn-default btn-xs" onclick="del_btn3(' + i + ')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						mySheet3.SetCellValue(i, "status", "");
						if (mySheet3.GetCellValue(i, "acc_sqno") != "") {
							mySheet3.SetCellEditable(i, "lss_acg_accc", 0);
							mySheet3.SetCellEditable(i, "acg_prc_dt", 0);
							mySheet3.SetCellEditable(i, "lsoc_am", 0);
							mySheet3.SetCellEditable(i, "tr_cntn", 0);
							mySheet3.SetCellEditable(i, "rvpy_dsc", 0);
						}
					}	
					
					//role_id, lshp_dcz_sts_dsc 별 수정 및 삭제버튼 
					var lshp_dcz_sts_dsc = $("#lshp_dcz_sts_dsc").val();
					var role_id = parent.$("#role_id").val();
					if(role_id=="orm"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet3.SetEditable(0);
							mySheet3.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="nml"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet3.SetEditable(0);
							mySheet3.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="admn"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet3.SetEditable(0);
							mySheet3.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="ormld"){
						mySheet3.SetEditable(0);
						mySheet3.SetColHidden("del_btn", 1);
					}else if(role_id=="nmlld"){
						mySheet3.SetEditable(0);
						mySheet3.SetColHidden("del_btn", 1);
					}					
					
					calLwsAm();
				}
			}
			function mySheet4_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("기타비용 및 기타회수 금액조회 중에 오류가 발생하였습니다..");
				}else{
					for (var i = mySheet4.GetDataFirstRow(); i <= mySheet4.GetDataLastRow(); i++) {
						mySheet4.SetCellText(i, "del_btn", '<button type="button" class="btn btn-default btn-xs" onclick="del_btn4(' + i + ')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						mySheet4.SetCellValue(i, "status", "");
						if (mySheet4.GetCellValue(i, "acc_sqno") != "") {
							mySheet4.SetCellEditable(i, "lss_acg_accc", 0);
							mySheet4.SetCellEditable(i, "acg_prc_dt", 0);
							mySheet4.SetCellEditable(i, "lsoc_am", 0);
							mySheet4.SetCellEditable(i, "tr_cntn", 0);
							mySheet4.SetCellEditable(i, "rvpy_dsc", 0);
						}
					}		
					
					//role_id, lshp_dcz_sts_dsc 별 수정 및 삭제버튼 
					var lshp_dcz_sts_dsc = $("#lshp_dcz_sts_dsc").val();
					var role_id = parent.$("#role_id").val();
					if(role_id=="orm"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet4.SetEditable(0);
							mySheet4.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="nml"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet4.SetEditable(0);
							mySheet4.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="admn"){
						if(lshp_dcz_sts_dsc=="05" || lshp_dcz_sts_dsc=="12"){
							mySheet4.SetEditable(0);
							mySheet4.SetColHidden("del_btn", 1);
						}
					}else if(role_id=="ormld"){
						mySheet4.SetEditable(0);
						mySheet4.SetColHidden("del_btn", 1);
					}else if(role_id=="nmlld"){
						mySheet4.SetEditable(0);
						mySheet4.SetColHidden("del_btn", 1);
					}					
					
					calEtcAm();
					
				}
			}
			function mySheet5_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					
					if(mySheet5.GetDataFirstRow()>0){
						for(var i=mySheet5.GetDataFirstRow(); i<=mySheet5.GetDataLastRow(); i++){
							if(mySheet5.GetCellValue(i, "comn_lshp_amnno")==mySheet5.GetCellValue(i, "standard_amnno")){
								mySheet5.SetCellValue(i, "standard", "기준");
							}
						}
					}
					
				}

			}
			function mySheet6_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					
				}

			}
			
			function mySheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
				//calLssAm();
			}
			function mySheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
				calIsrAm();
			}
			function mySheet3_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
				calLwsAm();
			}
			function mySheet4_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
				calEtcAm();
			}
			
			
			function del_btn1(Row) {
				var cur_row = '-1';
				for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
					if(mySheet1.GetCellValue(i, "rw_no")==Row){
						cur_row = i;
					}
				}
				if(mySheet1.GetCellValue(cur_row, "status")=="I"){
					mySheet1.RowDelete(cur_row);
				}else{
					mySheet1.SetCellValue(cur_row, "status", "D");
					mySheet1.SetRowHidden(cur_row,1);
				}
				calLssAm();
			}
			function del_btn2(Row) {
				var cur_row = '-1';
				for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
					if(mySheet2.GetCellValue(i, "rw_no")==Row){
						cur_row = i;
					}
				}
				if(mySheet2.GetCellValue(cur_row, "status")=="I"){
					mySheet2.RowDelete(cur_row);
				}else{
					mySheet2.SetCellValue(cur_row, "status", "D");
					mySheet2.SetRowHidden(cur_row,1);
				}
				calIsrAm();
			}
			function del_btn3(Row) {
				var cur_row = '-1';
				for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
					if(mySheet3.GetCellValue(i, "rw_no")==Row){
						cur_row = i;
					}
				}
				if(mySheet3.GetCellValue(cur_row, "status")=="I"){
					mySheet3.RowDelete(cur_row);
				}else{
					mySheet3.SetCellValue(cur_row, "status", "D");
					mySheet3.SetRowHidden(cur_row,1);
				}
				calLwsAm();
			}
			function del_btn4(Row) {
				var cur_row = '-1';
				for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
					if(mySheet4.GetCellValue(i, "rw_no")==Row){
						cur_row = i;
					}
				}
				if(mySheet4.GetCellValue(cur_row, "status")=="I"){
					mySheet4.RowDelete(cur_row);
				}else{
					mySheet4.SetCellValue(cur_row, "status", "D");
					mySheet4.SetRowHidden(cur_row,1);
				}
				calEtcAm();
			}
			
			//합계액 계산

			var lss_cst_am = 0; 
			var lss_wdr_am = 0; 
			var isr_wdr_am = 0; 
			var lws_cst_am = 0; 
			var lws_wdr_am = 0; 
			var etc_cst_am = 0; 
			var etc_wdr_am = 0; 
			
			var tot_lssam = 0;
			var tot_wdr_am = 0;
			var gu_lssam = 0;
			
			function calLssAm(){
				
				lss_cst_am = 0;
				lss_wdr_am = 0;
				if(mySheet1.GetDataLastRow() != "-1"){
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						if (typeof mySheet1.GetCellValue(i, "lsoc_am") === "number" && mySheet1.GetCellValue(i, "status") !== "D") {
							if(mySheet1.GetCellValue(i, "rvpy_dsc")=="1"){
								lss_wdr_am += parseInt(mySheet1.GetCellValue(i, "lsoc_am"));	
							}else if(mySheet1.GetCellValue(i, "rvpy_dsc")=="2"){
								lss_cst_am += parseInt(mySheet1.GetCellValue(i, "lsoc_am"));	
							}

						}else{
							
						}
					}
				}
				$("#lss_cst_am").val(lss_cst_am.toString());
				$("#shw_lss_cst_am").val(setFormatCurrency(lss_cst_am.toString(),","));
				$("#lss_wdr_am").val(lss_wdr_am.toString());
				$("#shw_lss_wdr_am").val(setFormatCurrency(lss_wdr_am.toString(),","));
				 calTotLssAm();
				 calTotWdrAm();
				 calGuLssAm();
			}
			function calIsrAm(){
				isr_wdr_am = 0;
				if(mySheet2.GetDataLastRow() != "-1"){
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if (typeof mySheet2.GetCellValue(i, "lsoc_am") === "number" && mySheet2.GetCellValue(i, "status") !== "D") {
							isr_wdr_am += parseInt(mySheet2.GetCellValue(i, "lsoc_am"));	
						}else{
							
						}
					}					
				}
				$("#isr_wdr_am").val(isr_wdr_am.toString());
				$("#shw_isr_wdr_am").val(setFormatCurrency(isr_wdr_am.toString(),","));
				calTotWdrAm();
				calGuLssAm()
			}
			function calLwsAm(){
				lws_cst_am=0;
				lws_wdr_am=0;
				if(mySheet3.GetDataLastRow() != "-1"){
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if (typeof mySheet3.GetCellValue(i, "lsoc_am") === "number" && mySheet3.GetCellValue(i, "status") !== "D") {
							if(mySheet3.GetCellValue(i, "rvpy_dsc")=="1"){
								lws_wdr_am += parseInt(mySheet3.GetCellValue(i, "lsoc_am"));	
							}else if(mySheet3.GetCellValue(i, "rvpy_dsc")=="2"){
								lws_cst_am += parseInt(mySheet3.GetCellValue(i, "lsoc_am"));	
							}
						}else{
							
						}
					}
				}
				$("#lws_cst_am").val(lws_cst_am.toString());
				$("#shw_lws_cst_am").val(setFormatCurrency(lws_cst_am.toString(),","));
				$("#lws_wdr_am").val(lws_wdr_am.toString());
				$("#shw_lws_wdr_am").val(setFormatCurrency(lws_wdr_am.toString(),","));
				 calTotLssAm();
				 calTotWdrAm();
				 calGuLssAm();
			}
			function calEtcAm(){
				etc_cst_am=0;
				etc_wdr_am=0;
				if(mySheet4.GetDataLastRow() != "-1"){
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if (typeof mySheet4.GetCellValue(i, "lsoc_am") === "number" && mySheet4.GetCellValue(i, "status") !== "D") {
							if(mySheet4.GetCellValue(i, "rvpy_dsc")=="1"){
								etc_wdr_am += parseInt(mySheet4.GetCellValue(i, "lsoc_am"));	
							}else if(mySheet4.GetCellValue(i, "rvpy_dsc")=="2"){
								etc_cst_am += parseInt(mySheet4.GetCellValue(i, "lsoc_am"));	
							}
						}else{
							
						}
					}
				}
				$("#etc_cst_am").val(etc_cst_am.toString());
				$("#shw_etc_cst_am").val(setFormatCurrency(etc_cst_am.toString(),","));
				$("#etc_wdr_am").val(etc_wdr_am.toString());
				$("#shw_etc_wdr_am").val(setFormatCurrency(etc_wdr_am.toString(),","));
				calTotLssAm();
				calTotWdrAm();
				calGuLssAm();
			}
			function calTotLssAm(){
				tot_lssam = lss_cst_am + lws_cst_am + etc_cst_am;
				
				$("#tot_lssam").val(tot_lssam.toString());
				$("#shw_tot_lssam").val(setFormatCurrency(tot_lssam.toString(),","));
			}
			function calTotWdrAm(){
				tot_wdr_am = lss_wdr_am + isr_wdr_am + lws_wdr_am + etc_wdr_am;
				
				$("#tot_wdr_am").val(tot_wdr_am.toString());
				$("#shw_tot_wdr_am").val(setFormatCurrency(tot_wdr_am.toString(),","));
			}
			function calGuLssAm(){
				gu_lssam = tot_lssam - tot_wdr_am;
				
				$("#gu_lssam").val(gu_lssam.toString());
				$("#shw_gu_lssam").val(setFormatCurrency(gu_lssam.toString(),","));
			}
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			/*Sheet 각종 처리*/
			function doAction_mySheet1(sAction) {
				switch(sAction) {
					case "search":  //손실금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS010202");
						mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet1.RemoveAll();
						initIBSheet1();
						break;
					case "insert":		//로우추가
						//추가처리;
						var row = mySheet1.DataInsert();
						var rw_no = mySheet1.GetCellText(row,"rw_no");
						mySheet1_OnChange(row,0,"");
						mySheet1.SetCellText(row,"acc_dsc","1");		
						mySheet1.SetCellText(row,"rvpy_dsc","1");		
						mySheet1.SetCellText(row,"del_btn",'<button type="button" class="btn btn-default btn-xs" onclick="del_btn1('+rw_no+')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						break; 
					case "delete":		//삭제 처리
						if(mySheet1.GetSelectRow() < 0){
							alert("삭제대상금액을 선택하세요.");
							return;
						}else{
							//삭제처리;
							mySheet1.RowDelete(mySheet1.GetSelectRow(), 1);
						}
						break; 
				}
			}
			function doAction_mySheet2(sAction) {
				switch(sAction) {
					case "search":  //보험금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS010203");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet2.RemoveAll();
						initIBSheet2();
						break;
					case "insert":		//로우추가
						//추가처리;
						var row = mySheet2.DataInsert();
						var rw_no = mySheet2.GetCellText(row,"rw_no");
						mySheet2_OnChange(row,0,"");
						mySheet2.SetCellText(row,"acc_dsc","2");
						mySheet2.SetCellText(row,"rvpy_dsc","2");
						mySheet2.SetCellText(row,"del_btn",'<button type="button" class="btn btn-default btn-xs" onclick="del_btn2('+rw_no+')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						break; 
					case "delete":		//삭제 처리
						if(mySheet2.GetSelectRow() < 0){
							alert("삭제대상금액을 선택하세요.");
							return;
						}else{
							//삭제처리;
							mySheet2.RowDelete(mySheet2.GetSelectRow(), 1);
						}
						break; 
				}
			}
			function doAction_mySheet3(sAction) {
				switch(sAction) {
					case "search":  //소송금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS010204");
						mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet3.RemoveAll();
						initIBSheet3();
						break;
					case "insert":		//로우추가
						//추가처리;
						var row = mySheet3.DataInsert();
						var rw_no = mySheet3.GetCellText(row,"rw_no");
						mySheet3_OnChange(row,0,"");
						mySheet3.SetCellText(row,"acc_dsc","3");		
						mySheet3.SetCellText(row,"del_btn",'<button type="button" class="btn btn-default btn-xs" onclick="del_btn3('+rw_no+')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						lws_yn_chk();
						break; 
					case "delete":		//삭제 처리
						if(mySheet3.GetSelectRow() < 0){
							alert("삭제대상금액을 선택하세요.");
							return;
						}else{
							//삭제처리;
							mySheet3.RowDelete(mySheet3.GetSelectRow(), 1);
						}
						lws_yn_chk();
						break; 
				}
			}
			function doAction_mySheet4(sAction) {
				switch(sAction) {
					case "search":  //기타금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS010205");
						mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet4.RemoveAll();
						initIBSheet4();
						break;
					case "insert":		//로우추가
						//추가처리;
						var row = mySheet4.DataInsert();
						var rw_no = mySheet4.GetCellText(row,"rw_no");
						mySheet4_OnChange(row,0,"");
						mySheet4.SetCellText(row,"acc_dsc","4");		
						mySheet4.SetCellText(row,"del_btn",'<button type="button" class="btn btn-default btn-xs" onclick="del_btn4('+rw_no+')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
						break; 
					case "delete":		//삭제 처리
						if(mySheet4.GetSelectRow() < 0){
							alert("삭제대상금액을 선택하세요.");
							return;
						}else{
							//삭제처리;
							mySheet4.RowDelete(mySheet4.GetSelectRow(), 1);
						}
						break; 
				}
			}
			function doAction_mySheet5(sAction) {
				switch(sAction) {
					case "search":  //기타금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS010902");
						mySheet5.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet5.RemoveAll();
						initIBSheet5();
						break;
					case "commDel":
						var com = true;
						var row = mySheet5.GetSelectRow();
						
						if(mySheet5.GetCellValue(row, "standard")=="기준"){
							alert("기준이된 손실사건은 해제할 수 업습니다.");
							com = false;
							return;
						}
						if(com){
							if(mySheet5.GetCellValue(row, "status")=="I"){
								if(!confirm("관리번호 : "+mySheet5.GetCellValue(row, "comn_lshp_amnno")+"를 해제하시겠습니까?"));							
								mySheet5.RowDelete(row);
								
							}else{
								commDel();
							}
							
						}
						
						break;
					case "commAdd":
						
						var html = "";				
						var role_id = "<%=role_id %>";
						$("#role_id").val(role_id);
						
						for(var i=mySheet5.GetDataFirstRow(); i<=mySheet5.GetDataLastRow(); i++){
							html += '<input type="hidden" id="lshp_amnno" name="lshp_amnno" value="'+mySheet5.GetCellValue(i, "comn_lshp_amnno")+'" >'
						}
						
						$("#loss_html").html(html);
						
						showLoadingWs();
						//$("#ifrLossSup").attr("src","about:blank");
						$("#winLossSup").show();
						var f = document.ormsForm;
						f.method.value="Main";
				        f.commkind.value="los";
				        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
				        f.process_id.value="ORLS012101";
						f.target = "ifrLossSup";
						f.submit();
						
						break;
				}
			}
			function doAction_mySheet6(sAction) {
				switch(sAction) {
					case "search":  //기타금액데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS010903");
						mySheet6.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet6.RemoveAll();
						initIBSheet6();
						break;
					case "mod":
						if($("#lshp_amnno").val() == ""){
							alert("대상 손실사건을 선택하세요.");
							return;
						}else{
							showLoadingWs();
							//$("#ifrLossMod").attr("src","about:blank");
							//$("#winLossMod").show();
							var f = document.ormsForm;
							f.method.value="Main";
					        f.commkind.value="los";
					        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
					        f.process_id.value="ORLS010201";
							f.target = "ifrLossMod";
							f.submit();
						}						
						break;
				}
			}

			function save(tmp){
				var f = document.ormsForm;
				
				var role_id = "<%=role_id %>";
				$("#role_id").val(role_id);

				if(parseInt(f.ocu_dt.value) > parseInt(f.dcv_dt.value)){
					alert("발생일자가 발견일자 보다 이후입니다.");
					return;
				}
				if(parseInt(f.dcv_dt.value) > parseInt(f.fir_inp_dt.value)){
					alert("발견일자가 입력일자 보다 이후입니다.");
					return;
				}
				if($('#gu_lssam').val()<0){
					alert("순손실금액이 음수가 될 수 없습니다.");
					return;
				}
				if(mySheet2.GetDataLastRow()==-1){	//보험청구여부 세팅
					$('#isr_rqs_yn').val('N');
				}else{
					$('#isr_rqs_yn').val('Y');
				}
				
				if($('#lshp_form_c').val()=='01' && $('#crrk_yn').val()=='Y' && $('#ham_xpc_am').val()==''){	//유형 : 재무손실 AND 신용리스크여부 : Y 일때는 피해예상금액 필수입력
					alert("피해예상금액을 입력해주세요.");
					return;					
				}
				if($('#lshp_form_c').val()=='01' && $('#crrk_yn').val()=='N' && ($('#tot_lssam').val()==''||$('#tot_lssam').val()==0) ){		//재무손실이며 신용리스크관련여부가 부일경우 총손실 금액 필요
					alert("재무손실이며 신용리스크 관련여부가 [부]일경우 총손실금액이 필요합니다.\n손실 금액을 입력해주세요");
					return;
				}
				
				var html = "";
				
				for(var i=mySheet5.GetDataFirstRow(); i<=mySheet5.GetDataLastRow(); i++){
					html += '<input type="hidden" id="hd_comn_lshp_amnno" name="hd_comn_lshp_amnno" value="'+ mySheet5.GetCellValue(i, "comn_lshp_amnno") +'">'
					
					if(mySheet5.GetCellValue(i, "standard")!=""){
						html += '<input type="hidden" id="standard" name="standard" value="'+ mySheet5.GetCellValue(i, "comn_lshp_amnno") +'">'
					}

					
					
				}
				$("#comn_html").html(html);
				
				
				if(tmp=="Y"){
					if(confirm("임시저장하시겠습니까?")){
						$("#s_lshp_dcz_sts_dsc").val('00');						
						var rtn = mySheet1.GetSaveData("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS010904",mySheet1.GetSaveString()+mySheet2.GetSaveString()+mySheet3.GetSaveString()+mySheet4.GetSaveString()+FormQueryStringEnc(document.ormsForm));
						saveEnd(JSON.parse(rtn).Result.Code);
					}
					return;
				}

				if(tmp=="N"){
					valid_by_role(parent.$("#role_id").val());	//20201015 if문밖에서 안으로 이동 - 임시저장일경우는 체크안함
					
					if($('#vld_chk_yn').val()=="N"){
						//alert("필수항목이 입력되지않아 등록 불가합니다.")
						if(confirm("필수항목이 입력되지 않았습니다. 저장하시겠습니까?")){
							$("#s_lshp_dcz_sts_dsc").val('04');							
							var rtn = mySheet1.GetSaveData("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS010904",mySheet1.GetSaveString()+mySheet2.GetSaveString()+mySheet3.GetSaveString()+mySheet4.GetSaveString()+FormQueryStringEnc(document.ormsForm));
							saveEnd(JSON.parse(rtn).Result.Code);
						}
						return;
					}
					if($('#vld_chk_yn').val()=="Y"){
						if(confirm("필수항목이 모두 입력되었습니다. 수정하시겠습니까?")){
							if(parent.$("#role_id").val()=='orm'){
// 								$("#lshp_dcz_sts_dsc").val('04');
								$("#s_lshp_dcz_sts_dsc").val('05');
							}
							var rtn = mySheet1.GetSaveData("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS010904",mySheet1.GetSaveString()+mySheet2.GetSaveString()+mySheet3.GetSaveString()+mySheet4.GetSaveString()+FormQueryStringEnc(document.ormsForm));
							saveEnd(JSON.parse(rtn).Result.Code);
						}
						return;
					}
				}
			}
			function saveEnd(code){
				if(code >= 0) {
			        alert("저장되었습니다.");  // 저장 성공 메시지
			        $(".popup",parent.document).hide();
			        parent.doAction("search"); 
			    } else {
			        alert("저장실패했습니다."); // 저장 실패 메시지
			    }
			}
			function connAcc(){
				$('#winAccConn').addClass('block');
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="los";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORLS010501";
				f.target = "ifrLossMod";
				f.submit();
			}

			function valid_by_role(role){
				$('#vld_chk_yn').val("N");
				if(role=='orm'){					//////////////////////////ORM필수항목
					if($('#ocu_up_brc').val()==""){
						alert("필수항목 발생지역을 입력하지않으셨습니다.");
						return;
					}
					if($('#ocu_brc').val()==""){
						alert("필수항목 발생부서를 입력하지않으셨습니다.");
						return;
					}
					if($('#rprr_eno').val()==""){
						alert("필수항목 보고자를 입력하지않으셨습니다.");
						return;
					}
					if($('#rpt_brc').val()==""){
						alert("필수항목 보고부서를 입력하지않으셨습니다.");
						return;
					}
					/* if($('#bnd_amn_brc').val()==""){
						alert("필수항목 채권관리부서를 입력하지않으셨습니다.");
						return;
					} */
					if($('#lshp_form_c').val()==""){
						alert("필수항목 손실형태를 입력하지않으셨습니다.");
						return;
					}
					if($('#lshp_stsc').val()==""){
						alert("필수항목 손실상태를 입력하지않으셨습니다.");
						return;
					}
					if($('#lws_yn').val()==''){
						alert("소송여부를 입력해주세요.");
						return;
					}
					if($('#lws_yn').val()=='Y'){	//소송여부가 Y인경우 소송심급, 소송종결여부, 소송결과, 사건번호 필수입력
						if($('#lwsjdg_dsc').val()==''){
							alert("소송심급을 입력해주세요.");
							return;
						}
						if($('#lws_tmnt_yn').val()==''){
							alert("소송종결여부를 입력해주세요.");
							return;
						}
						if($('#lws_rzt_c').val()==''){
							alert("소송결과를 입력해주세요.");
							return;
						}
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "lws_prg_cntn")==""){
							alert("필수항목 진행심을 입력하지않으셨습니다.");
							return;
						}
					}
					if($('#lshp_tinm').val()==""){
						alert("필수항목 손실사건 제목을 입력하지않으셨습니다.");
						return;
					}
					if($('#oprk_amn_dtl_cntn').val()==""){
						alert("필수항목 ORM 상세내용을 입력하지않으셨습니다.");
						return;
					}
					if($('#ocu_dt').val()==""){
						alert("필수항목 발생일자를 입력하지않으셨습니다.");
						return;
					}
					if($('#dcv_dt').val()==""){
						alert("필수항목 발견일자를 입력하지않으셨습니다.");
						return;
					}
					if($('#bsn_prss_c').val()==""){
						alert("필수항목 업무프로세스를 입력하지않으셨습니다.");
						return;
					}
					if($('#biz_trry_c').val()==""){
						alert("필수항목 영업영역을 입력하지않으셨습니다.");
						return;
					}
					if($('#hpn_tpc').val()==""){
						alert("필수항목 사건유형을 입력하지않으셨습니다.");
						return;
					}
					if($('#cas_tpc').val()==""){
						alert("필수항목 원인유형을 입력하지않으셨습니다.");
						return;
					}
// 					if($('#amn_brc').val()==""){
// 						alert("필수항목 사건관리부서를 입력하지않으셨습니다.");
// 						return;
// 					}
					if($('#jrdt_brc').val()==""){
						alert("필수항목 업무소관부서를 입력하지않으셨습니다.");
						return;
					}
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						if(mySheet1.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 손실발생금액-손실발생금액을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "hpn_rc_dt")==""){
							alert("필수항목 보험회수금액-사건접수일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 보험회수금액-보험회수금액을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						if(mySheet1.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 손실발생금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 보험회수금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 소송금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 기타금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "rvpy_dsc")=="1"&&mySheet4.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 기타금액-기타부대비용을 입력하지않으셨습니다.");
							return;
						}
					}
					if($('#mkrk_yn').val()==""){
						alert("필수항목 시장리스크 여부를 입력하지않으셨습니다.");
						return;
					}
					if($('#crrk_yn').val()==""){
						alert("필수항목 신용리스크 여부를 입력하지않으셨습니다.");
						return;
					}
					if($('#rwa_yn').val()==""){
						alert("필수항목 신용 RWA 반영 여부를 입력하지않으셨습니다.");
						return;
					}
					if($('#strk_yn').val()==""){
						alert("필수항목 전략리스크 여부를 입력하지않으셨습니다.");
						return;
					}
					if($('#fmrk_yn').val()==""){
						alert("필수항목 평판리스크 여부를 입력하지않으셨습니다.");
						return;
					}
					if($('#lgrk_yn').val()==""){
						alert("필수항목 법률리스크 여부를 입력하지않으셨습니다.");
						return;
					}
					$('#vld_chk_yn').val("Y");				//ORM validation 통과시			
				}else if(role=='ormld'){					//////////////////////////ORM팀장필수항목
				}else if(role=='nml'){						///////////////////////////발생부서필수항목
					if($('#ocu_brc').val()==""){
						alert("필수항목 발생부서를 입력하지않으셨습니다.");
						return;
					}
					if($('#rprr_eno').val()==""){
						alert("필수항목 보고자를 입력하지않으셨습니다.");
						return;
					}
					if($('#rpt_brc').val()==""){
						alert("필수항목 보고부서를 입력하지않으셨습니다.");
						return;
					}
					/* if($('#bnd_amn_brc').val()==""){
						alert("필수항목 채권관리부서를 입력하지않으셨습니다.");
						return;
					} */
					if($('#lshp_form_c').val()==""){
						alert("필수항목 손실형태를 입력하지않으셨습니다.");
						return;
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "lws_prg_cntn")==""){
							alert("필수항목 진행심을 입력하지않으셨습니다.");
							return;
						}
					}
					if($('#lshp_tinm').val()==""){
						alert("필수항목 손실사건 제목을 입력하지않으셨습니다.");
						return;
					}
					if($('#ocu_dept_dtl_cntn').val()==""){
						alert("필수항목 발생부서 상세내용을 입력하지않으셨습니다.");
						return;
					}
					if($('#ocu_dt').val()==""){
						alert("필수항목 발생일자를 입력하지않으셨습니다.");
						return;
					}
					if($('#dcv_dt').val()==""){
						alert("필수항목 발견일자를 입력하지않으셨습니다.");
						return;
					}
					if($('#fir_inp_dt').val()==""){
						alert("필수항목 입력일자를 입력하지않으셨습니다.");
						return;
					}
					if($('#bsn_prss_c').val()==""){
						alert("필수항목 업무프로세스를 입력하지않으셨습니다.");
						return;
					}
					if($('#biz_trry_c').val()==""){
						alert("필수항목 영업영역을 입력하지않으셨습니다.");
						return;
					}
					if($('#hpn_tpc').val()==""){
						alert("필수항목 사건유형을 입력하지않으셨습니다.");
						return;
					}
					if($('#cas_tpc').val()==""){
						alert("필수항목 원인유형을 입력하지않으셨습니다.");
						return;
					}
// 					if($('#amn_brc').val()==""){
// 						alert("필수항목 사건관리부서를 입력하지않으셨습니다.");
// 						return;
// 					}
					if($('#lws_yn').val()==''){
						alert("소송여부를 입력해주세요.");
						return;
					}
					if($('#lws_yn').val()=='Y'){	//소송여부가 Y인경우 소송심급, 소송종결여부, 소송결과, 사건번호 필수입력
						if($('#lwsjdg_dsc').val()==''){
							alert("소송심급을 입력해주세요.");
							return;
						}
						if($('#lws_tmnt_yn').val()==''){
							alert("소송종결여부를 입력해주세요.");
							return;
						}
						if($('#lws_rzt_c').val()==''){
							alert("소송결과를 입력해주세요.");
							return;
						}
					}
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						if(mySheet1.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 손실발생금액을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						if(mySheet1.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 손실발생금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 보험회수금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 소송금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 기타금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "rvpy_dsc")=="1"&&mySheet4.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 기타금액-기타부대비용을 입력하지않으셨습니다.");
							return;
						}
					}
// 					$('#lshp_dcz_sts_dsc').val("12");		//발생부서 validation 통과시			
					$('#vld_chk_yn').val("Y");				//발생부서 validation 통과시			
				}else if(role=='admn'){						///////////////////////////유관부서필수항목
					if($('#ocu_up_brc').val()==""){
						alert("필수항목 발생지역을 입력하지않으셨습니다.");
						return;
					}
<%
	for(int i=0;i<vLsHurDeptCLst.size();i++){
		HashMap hMap = (HashMap)vLsHurDeptCLst.get(i);
		if ((brc).trim().equals((String)hMap.get("intgc"))) {		//인사부의 경우
%>
					if ($('#hur_amnno').val() == "") {
						alert("필수항목 인사부 관리번호를 입력하지않으셨습니다.");
	
						return;
					}
<%
		}
	}
%>
					if($('#ocu_up_brc').val()==""){
						alert("필수항목 발생지역을 입력하지않으셨습니다.");
						return;
					}
					if($('#ocu_brc').val()==""){
						alert("필수항목 발생부서를 입력하지않으셨습니다.");
						return;
					}
					if($('#rprr_eno').val()==""){
						alert("필수항목 보고자를 입력하지않으셨습니다.");
						return;
					}
					if($('#rpt_brc').val()==""){
						alert("필수항목 보고부서를 입력하지않으셨습니다.");
						return;
					}
					/* if($('#bnd_amn_brc').val()==""){
						alert("필수항목 채권관리부서를 입력하지않으셨습니다.");
						return;
					} */
					if($('#lshp_form_c').val()==""){
						alert("필수항목 손실형태를 입력하지않으셨습니다.");
						return;
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "lws_prg_cntn")==""){
							alert("필수항목 진행심을 입력하지않으셨습니다.");
							return;
						}
					}
					if($('#lshp_tinm').val()==""){
						alert("필수항목 손실사건 제목을 입력하지않으셨습니다.");
						return;
					}
					if($('#amn_dept_dtl_cntn').val()==""){
						alert("필수항목 관리부서 상세내용을 입력하지않으셨습니다.");
						return;
					}
					if($('#ocu_dt').val()==""){
						alert("필수항목 발생일자를 입력하지않으셨습니다.");
						return;
					}
					if($('#dcv_dt').val()==""){
						alert("필수항목 발견일자를 입력하지않으셨습니다.");
						return;
					}
					if($('#bsn_prss_c').val()==""){
						alert("필수항목 업무프로세스를 입력하지않으셨습니다.");
						return;
					}
					if($('#biz_trry_c').val()==""){
						alert("필수항목 영업영역을 입력하지않으셨습니다.");
						return;
					}
					if($('#hpn_tpc').val()==""){
						alert("필수항목 사건유형을 입력하지않으셨습니다.");
						return;
					}
					if($('#cas_tpc').val()==""){
						alert("필수항목 원인유형을 입력하지않으셨습니다.");
						return;
					}
					if($('#amn_brc').val()==""){
						alert("필수항목 사건관리부서를 입력하지않으셨습니다.");
						return;
					}
					if($('#jrdt_brc').val()==""){
						alert("필수항목 업무소관부서를 입력하지않으셨습니다.");
						return;
					}
					if($('#lws_yn').val()==''){
						alert("소송여부를 입력해주세요.");
						return;
					}
					if($('#lws_yn').val()=='Y'){	//소송여부가 Y인경우 소송심급, 소송종결여부, 소송결과, 사건번호 필수입력
						if($('#lwsjdg_dsc').val()==''){
							alert("소송심급을 입력해주세요.");
							return;
						}
						if($('#lws_tmnt_yn').val()==''){
							alert("소송종결여부를 입력해주세요.");
							return;
						}
						if($('#lws_rzt_c').val()==''){
							alert("소송결과를 입력해주세요.");
							return;
						}
					}
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						if(mySheet1.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 손실발생금액-손실발생금액을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 소송금액-소송금액을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "wdr_am_rcp_dt")==""){
							alert("필수항목 소송금액-회수금수령일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "tr_cntn")==""){
							alert("필수항목 기타금액-거래내역을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 기타금액-기타금액을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "wdr_am_rcp_dt")==""){
							alert("필수항목 기타금액-회수금수령일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						if(mySheet1.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 손실발생금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet2.GetDataFirstRow(); i<=mySheet2.GetDataLastRow(); i++){
						if(mySheet2.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 보험회수금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet3.GetDataFirstRow(); i<=mySheet3.GetDataLastRow(); i++){
						if(mySheet3.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 소송금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "acg_prc_dt")==""){
							alert("필수항목 기타금액-회계처리일을 입력하지않으셨습니다.");
							return;
						}
					}
					for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
						if(mySheet4.GetCellValue(i, "lsoc_am")==""){
							alert("필수항목 기타금액-기타비용을 입력하지않으셨습니다.");
							return;
						}
					}
// 					$('#lshp_dcz_sts_dsc').val("03");		//유관부서 validation 통과시			
					$('#vld_chk_yn').val("Y");				//유관부서 validation 통과시			
				}	
			}

			function ableByRole(role){
				var lshp_dcz_sts_dsc = $("#lshp_dcz_sts_dsc").val();
				if(role=='orm'){	
					if(lshp_dcz_sts_dsc!="05" || lshp_dcz_sts_dsc!="12"){	
						$("#grp_org_c").attr("disabled",true);								//손실사건 발생법인
						$("#ocu_brnm").attr("disabled",false);								//사건발생부서
						$("#ocu_brnm_btn").show();					//사건발생부서 버튼
						$("#ocu_up_brnm").attr("disabled",false);							//발생지역
						$("#ocu_up_brnm_btn").show();					//발생지역 버튼
						$("#hpn_ocu_natcd").attr("disabled",false);							//사건발생국가
						$("#shw_rprr_nm").attr("disabled",false);							//보고자
						$("#shw_rprr_nm_btn").show();					//보고자 버튼
						$("#rpt_brnm").attr("disabled",false);								//보고부서
						$("#rpt_brnm_btn").show();					//보고부서 버튼
						$("#bnd_amn_brnm").attr("disabled",false);							//채권관리부서
						$("#bnd_amn_brnm_btn").show();				//채권관리부서 버튼
						$("#amn_brnm").attr("disabled",false);								//사건관리부서
						$("#amn_brnm_btn").show();					//사건관리부서 버튼
						$("#isr_rqs_yn").attr("disabled",false);								
						$("#ocu_dt").attr("disabled",false);									//발생일자
						$("#ocu_dt_btn").show();						//발생일자 버튼
						$("#dcv_dt").attr("disabled",false);									//발견일자
						$("#dcv_dt_btn").show();						//발견일자 버튼
							$("#fir_inp_dt").attr("disabled",true);							//최조등록일자
							$("#lschg_dt").attr("disabled",true);							//최종변경일자
						$("#lshp_tinm").attr("disabled",false);								//손실사건제목
						$("#hur_amnno").attr("disabled",false);								//인사부관리번호
						$("#hur_amnno_tr").css("display","table-row");				//인사부관리번호 표시
						$("#ocu_dept_dtl_cntn_tr").css("display","table-row");		//보고부서상세내용 표시
						$("#amn_dept_dtl_cntn_tr").css("display","table-row");		//사건관리부서상세내용 표시
						$("#oprk_amn_dtl_cntn_tr").css("display","table-row");		//ORM상세내용 표시
	 					$("#ocu_dept_dtl_cntn").attr("disabled",false);						//보고부서상세내용
	 					$("#amn_dept_dtl_cntn").attr("disabled",false);						//사건관리부서상세내용
	 					$("#oprk_amn_dtl_cntn").attr("disabled",false);						//ORM상세내용
						$("#lsoc_chan_cntn").attr("disabled",false);							//손실발생채널
						$("#lshp_rel_wrsnm").attr("disabled",false);							//관련상품명
						$("#lws_yn").attr("disabled",false);									//소송여부
						$("#lss_am_conn_btn").show();					//손실비용/회수 계정연결
						$("#lss_am_mnl_btn").show();					//손실비용/회수 수기입력
						$("#isr_am_conn_btn").show();					//보험회수 계정연결
						$("#isr_am_mnl_btn").show();					//보험회수 수기입력
						$("#lws_am_conn_btn").show();					//소송비용/회수 계정연결
						$("#lws_am_mnl_btn").show();					//소송비용/회수 수기입력
						$("#etc_am_conn_btn").show();					//기타비용/회수 계정연결
						$("#etc_am_mnl_btn").show();					//기타비용/회수 수기입력
						$("#lshp_form_c").attr("disabled",false);							//손실형태
						$("#lshp_form_help_btn").css("display","inline-block");		//손실형태 도움말
						$("#lshp_stsc").attr("disabled",false);								//손실상태
						$("#shw_bsn_prss_nm_btn").show();				//업무프로세스 버튼
						$("#shw_hpn_tpnm_btn").show();				//사건유형 버튼
						$("#shw_cas_tpnm_btn").show();				//원인유형 버튼
						$("#shw_ifn_tpnm_btn").show();				//영향유형 버튼
						$("#shw_emrk_nm_btn").show();					//이머징리스크유형 버튼
						$("#mkrk_yn").attr("disabled",false);								//시장리스크 여부
						$("#crrk_yn").attr("disabled",false);								//신용리스크 여부
						$("#rwa_yn").attr("disabled",false);									//신용 RWA 반영 여부
						$("#strk_yn").attr("disabled",false);								//전략리스크 여부
						$("#fmrk_yn").attr("disabled",false);								//평판리스크 여부
						$("#lgrk_yn").attr("disabled",false);								//법률리스크 여부
					}
				}else if( role == 'ormld'){
					
					$("#hur_amnno_tr").css("display","table-row");						//인사부관리번호 표시
					$("#ocu_dept_dtl_cntn_tr").css("display","table-row");				//보고부서상세내용 표시
					$("#amn_dept_dtl_cntn_tr").css("display","table-row");				//관리부서상세내용 표시
					$("#oprk_amn_dtl_cntn_tr").css("display","table-row");				//ORM상세내용 표시
					
				}else if( role == 'nml'){
					if(lshp_dcz_sts_dsc=="00" || lshp_dcz_sts_dsc=="01" || lshp_dcz_sts_dsc=="06"){
						
						$("#lshp_tinm").attr("disabled",false);									//사건제목
						$("#ocu_dept_dtl_cntn").attr("disabled",false);							//보고부서상세내용
						$("#lsoc_chan_cntn").attr("disabled",false);								//손실발생채널
						$("#lshp_rel_wrsnm").attr("disabled",false);								//관련상품명
						$("#lws_yn").attr("disabled",false);										//소송여부
						$("#lshp_form_c").attr("disabled",false);								//손실형태
						$("#ocu_dept_dtl_cntn_tr").css("display","table-row"); 			//보고부서상세내용 표시
						$("#ocu_up_brnm_btn").show();						//발생지역 버튼
						$("#hpn_ocu_natcd").attr("disabled",false);								//사건발생국가
						$("#bnd_amn_brnm_btn").show();					//채권관리부서
						$("#ocu_dt_btn").show();							//발생일자
						$("#dcv_dt_btn").show();							//발견일자
						$("#lss_am_conn_btn").show();						//손실비용/회수 계정연결
						$("#lss_am_mnl_btn").show();						//손실비영/회수 수기입력
						$("#isr_am_conn_btn").show();						//보험회수 계정연결
						$("#isr_am_mnl_btn").show();						//보험회수 수기입력
						$("#lws_am_conn_btn").show();						//소송비용/회수 계정연결
						$("#lws_am_mnl_btn").show();						//소송비용/회수 수기입력
						$("#etc_am_conn_btn").show();						//기타비용/회수 계정연결
						$("#etc_am_mnl_btn").show();						//기타비용/회수 수기입력
						$("#shw_bsn_prss_nm_btn").show();					//업무프로세스 버튼
						$("#shw_hpn_tpnm_btn").show();					//사건유형 버튽
						$("#shw_cas_tpnm_btn").show();					//원인유형 버튼
						$("#shw_ifn_tpnm_btn").show();					//영향유형 버튼
						$("#shw_emrk_nm_btn").show();						//이머징리스크유형 버튼
						
					}
				}else if(role == 'nmlld'){
					$("#ocu_dept_dtl_cntn_tr").css("display","table-row");				//보고부서상세내용 표시
					
				}else if( role == 'admn'){
					if(lshp_dcz_sts_dsc=="00" || lshp_dcz_sts_dsc=="03" || lshp_dcz_sts_dsc=="06"){
						
						$("#lshp_tinm").attr("disabled",false);									//사건제목
						$("#amn_dept_dtl_cntn").attr("disabled",false);							//사건관리부서상세내용
						$("#lsoc_chan_cntn").attr("disabled",false);								//손실발생채널
						$("#lshp_rel_wrsnm").attr("disabled",false);								//관련상품명
						$("#lws_yn").attr("disabled",false);										//소송여부
						$("#lshp_form_c").attr("disabled",false);								//손실형태						
						$("#amn_brc").val("<%=(String)hMapSession.get("brc") %>");		//사건관리부서코드
						$("#amn_brnm").val("<%=(String)hMapSession.get("brnm") %>");	//사건관리부서명
						$("#amn_brnm_btn").show();						//사건관리부서 버튼
						$("#amn_dept_dtl_cntn_tr").css("display","table-row"); 			//관리부서상세내용 표시
						$("#hpn_ocu_natcd").attr("disabled",false);								//사건발생국가
						$("#ocu_dt_btn").show();							//발생일자
						$("#dcv_dt_btn").show();							//발견일자
						$("#lss_am_conn_btn").show();						//손실비용/회수 계정연결
						$("#lss_am_mnl_btn").show();						//손실비영/회수 수기입력
						$("#isr_am_conn_btn").show();						//보험회수 계정연결
						$("#isr_am_mnl_btn").show();						//보험회수 수기입력
						$("#lws_am_conn_btn").show();						//소송비용/회수 계정연결
						$("#lws_am_mnl_btn").show();						//소송비용/회수 수기입력
						$("#etc_am_conn_btn").show();						//기타비용/회수 계정연결
						$("#etc_am_mnl_btn").show();						//기타비용/회수 수기입력
						$("#shw_bsn_prss_nm_btn").show();					//업무프로세스 버튼
						$("#shw_hpn_tpnm_btn").show();					//사건유형 버튽
						$("#shw_cas_tpnm_btn").show();					//원인유형 버튼
						$("#shw_ifn_tpnm_btn").show();					//영향유형 버튼
						$("#shw_emrk_nm_btn").show();						//이머징리스크유형 버튼
<%
for(int i=0;i<vLsSpfAmnDeptCLst.size();i++){
	HashMap hMap = (HashMap)vLsSpfAmnDeptCLst.get(i);
	if ((brc).trim().equals((String)hMap.get("intgc"))) {		//부서 : 감사부,준법감시부,정보보호부는 선택이 가능
%>
						$("#ocu_brnm_btn").show();						//발생부서 버튼
						$("#ocu_up_brnm_btn").show();						//발생지역 버튼
<%
	}
}

for(int i=0;i<vLsHurDeptCLst.size();i++){
	HashMap hMap = (HashMap)vLsHurDeptCLst.get(i);
	if ((brc).trim().equals((String)hMap.get("intgc"))) {		//인사부의 경우
%>
						$("#hur_amnno_tr").css("display","table-row");					//인사부관리번호 표시
						$("#hur_amnno").attr("disabled",false);									//인사부관리번호
<%
	}
}
%>
						
						
						
					}
					
					
				}
				
				chk_lws_yn_chg();
				
			}
	
			function lws_yn_chk() {		//소송금액 발생시 관리정보항목의 소송여부 변경
				if (mySheet3.GetDataLastRow() > 0) {
					var row_yn = false;
					for (var i = mySheet3.GetDataFirstRow(); i <= mySheet3.GetDataLastRow(); i++) {
						if (mySheet3.GetCellValue(i, "status") != "D") {
							row_yn = true;
						}
					}
				}
				if (row_yn) {
					$('#lws_yn').val('Y');
					$('#lgrk_yn').val('Y');
				} else {
					$('#lws_yn').val('N');
				}
				chk_lws_yn_chg();
				return;
			}
		
			//계정연결확인시
			function addAccConn(acc_sqno, lss_acg_accc, crc_can_dsc, acg_prc_dt, am,
					tr_cntn, rvpy_dsc, brc, acc_dsc) {
				var mySheet;
				var sheetno;
				if (acc_dsc == "") {
					sheetno = accConnForm.sheetno.value;
				} else {
					sheetno = acc_dsc;
				}
				switch (sheetno) {
				case "1":
					mySheet = mySheet1;
					break;
				case "2":
					mySheet = mySheet2;
					break;
				case "3":
					mySheet = mySheet3;
					break;
				case "4":
					mySheet = mySheet4;
					break;
				}
				// 맨 마지막에 추가
				var row = mySheet.DataInsert(-1);
				// mySheet.RowCount();
				mySheet.SetCellValue(row, "acc_dsc", sheetno);
				mySheet.SetCellValue(row, "status", "I");
				mySheet.SetCellValue(row, "lss_acg_accc", lss_acg_accc);
				mySheet.SetCellValue(row, "acc_brc", brc);
				mySheet.SetCellValue(row, "acc_sqno", acc_sqno);
				mySheet.SetCellValue(row, "rvpy_dsc", rvpy_dsc);
				mySheet.SetCellValue(row, "crc_can_dsc", crc_can_dsc);
				mySheet.SetCellValue(row, "acg_prc_dt", acg_prc_dt);
				mySheet.SetCellValue(row, "lsoc_am", am);
				mySheet.SetCellValue(row, "tr_cntn", tr_cntn);
				mySheet.SetCellText(row, "del_btn",
						'<button type="button" class="btn btn-default btn-xs" onclick="del_btn'
								+ sheetno + '(' + row
								+ ')">삭제<i class="fa fa-caret-right"></i></button>'); //삭제버튼생성
				mySheet.SetCellEditable(row, "lss_acg_accc", 0);
				mySheet.SetCellEditable(row, "acg_prc_dt", 0);
				mySheet.SetCellEditable(row, "lsoc_am", 0);
				mySheet.SetCellEditable(row, "tr_cntn", 0);
				mySheet.SetCellEditable(row, "rvpy_dsc", 0);
				if (sheetno == 3) {
					lws_yn_chk();
				}
			}
			
			function search(){
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los"); 
				WP.setParameter("process_id", "ORLS010802");  
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
							if(result != 'undefined' && result.rtnCode== '0'){
								var rList = result.DATA;
								$("#ocu_brc").val(rList[0].ocu_brc);     								//사건발생부서코드(영업점)
								$("#ocu_brnm").val(rList[0].ocu_brnm);   								//사건발생부서명
								$("#ocu_up_brc").val(rList[0].ocu_up_brc);								//발생지역
								$("#ocu_up_brnm").val(rList[0].ocu_up_brnm);							//발생지역명
								$("#hpn_ocu_natcd").val(rList[0].hpn_ocu_natcd);						//사건발생국가
								
								$("#rprr_eno").val(rList[0].rprr_eno);									//보고자개인번호
								$("#shw_rprr_nm").val(rList[0].rprr_enm);								//보고자
								$("#rpt_brc").val(rList[0].rpt_brc);									//보고부서코드
								$("#rpt_brnm").val(rList[0].rpt_brnm);									//보고부서
								$("#bnd_amn_brc").val(rList[0].bnd_amn_brc);							//채권관리부서코드
								$("#bnd_amn_brnm").val(rList[0].bnd_amn_brnm);							//채권관리부서
								$("#amn_brc").val(rList[0].amn_brc);									//사건관리부서코드
								$("#amn_brnm").val(rList[0].amn_brnm);									//사건관리부서
								
								$("#ocu_dt").val(rList[0].ocu_dt);										//발생일자
								$("#dcv_dt").val(rList[0].dcv_dt);										//발견일자
								$("#fir_inp_dt").val(rList[0].fir_inp_dt);								//최초등록일자
								$("#lschg_dt").val(rList[0].lschg_dt);									//최종변경일자
								
								$("#hur_amnno").val(rList[0].hur_amnno);								//인사부관리번호
								$("#lshp_tinm").val(rList[0].lshp_tinm);								//사건제목
								$("#ocu_dept_dtl_cntn").val(rList[0].ocu_dept_dtl_cntn);				//보고부서상세내용
								$("#amn_dept_dtl_cntn").val(rList[0].amn_dept_dtl_cntn);				//관리부서상세내용
								$("#oprk_amn_dtl_cntn").val(rList[0].oprk_amn_dtl_cntn);				//ORM 상세내용
								$("#lsoc_chan_cntn").val(rList[0].lsoc_chan_cntn);						//손실발생채널
								$("#lshp_rel_wrsnm").val(rList[0].lshp_rel_wrsnm);						//관련상품명
								$("#lws_yn").val(rList[0].lws_yn);										//소송여부
								$("#lwsjdg_dsc").val(rList[0].lwsjdg_dsc);								//소송심급
								$("#lws_tmnt_yn").val(rList[0].lws_tmnt_yn);							//소송종결여부
								$("#lws_rzt_c").val(rList[0].lws_rzt_c);								//소송결과
								
								var bsn_prss_nm = "";
								var hpn_tpnm = "";
								var cas_tpnm = "";
								var ifn_tpnm = "";
								var emrk_nm = "";
								if(rList[0].bsn_prss_c_lv4!=""){
										bsn_prss_nm = rList[0].bsn_prsnm_lv1 +" > "+ rList[0].bsn_prsnm_lv2 +" > "+ rList[0].bsn_prsnm_lv3 +" > "+ rList[0].bsn_prsnm_lv4;
								}
								if( rList[0].hpn_tpc_lv3!=""){
									hpn_tpnm = rList[0].hpn_tpnm_lv1 +" > "+ rList[0].hpn_tpnm_lv2 +" > "+rList[0].hpn_tpnm_lv3
								}
								if(rList[0].cas_tpc_lv3!=""){
									cas_tpnm = rList[0].cas_tpnm_lv1 +" > "+ rList[0].cas_tpnm_lv2 +" > "+ rList[0].cas_tpnm_lv3
								}
								if(rList[0].ifn_tpc_lv2!=""){
									ifn_tpnm = rList[0].ifn_tpnm_lv1 +" > "+ rList[0].ifn_tpnm_lv2
								}
								if(rList[0].emrk_tpc_lv2!=""){
									emrk_nm = rList[0].emrk_tpnm_lv1 +" > "+ rList[0].emrk_tpnm_lv2
								}
								
								$("#lshp_form_c").val(rList[0].lshp_form_c);							//손실형태
								$("#lshp_stsc").val(rList[0].lshp_stsc);								//손실상태
								$("#bsn_prss_c").val(rList[0].bsn_prss_c_lv4);									//업무프로세스코드(lv4)
								$("#shw_bsn_prss_nm").val(bsn_prss_nm);									//업무프로세스명
								$("#hpn_tpc").val(rList[0].hpn_tpc_lv3);								//사건유형코드
								$("#shw_hpn_tpnm").val(hpn_tpnm);										//사건유형
								$("#cas_tpc").val(rList[0].cas_tpc_lv3);								//원인유형코드
								$("#shw_cas_tpnm").val(rList[0].cas_tpnm);								//원인유형
								$("#ifn_tpc").val(rList[0].ifn_tpc_lv2);								//영향유형코드
								$("#shw_ifn_tpnm").val(ifn_tpnm);										//영향유형
								$("#emrk_tpc").val(rList[0].emrk_tpc_lv2);								//이머징리스크유형코드
								$("#shw_emrk_nm").val(emrk_nm);											//이머징리스크유형
								
								$("#mkrk_yn").val(rList[0].mkrk_yn);									//시장리스크여부
								$("#crrk_yn").val(rList[0].crrk_yn);									//신용리스크여부
								$("#rwa_yn").val(rList[0].rwa_yn);										//신용RWA반영여부
								$("#strk_yn").val(rList[0].strk_yn);									//전략리스크여부
								$("#fmrk_yn").val(rList[0].fmrk_yn);									//평판리스크여부
								$("#lgrk_yn").val(rList[0].lgrk_yn);									//법률리스크여부
								
								for(var i=mySheet5.GetDataFirstRow(); i<=mySheet5.GetDataLastRow(); i++){
									if(mySheet5.GetCellValue(i,"standard")=="기준"){
										mySheet5.SetCellValue(i, "standard", "");
									}
								}
								var row = mySheet5.GetSelectRow();
								mySheet5.SetCellValue(row, "standard", "기준");
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
			
			//관리정보항목의 소송여부 변경시 하위항목(소송진행심급 등) 값 변경
			function chk_lws_yn_chg() {		//관리정보항목의 소송여부 변경시 하위항목(소송진행심급 등) 값 변경
				if ($('#lws_yn').val() == "Y") {
					$("#lwsjdg_dsc").attr("disabled",false);
					$("#lws_tmnt_yn").attr("disabled",false);
					$("#lws_rzt_c").attr("disabled",false);
				} else {
					$("#lwsjdg_dsc").val("");
					$("#lws_tmnt_yn").val("");
					$("#lws_rzt_c").val("");
			
					$("#lwsjdg_dsc").attr("disabled",true);
					$("#lws_tmnt_yn").attr("disabled",true);
					$("#lws_rzt_c").attr("disabled",true);
				}
			}
			
			function chk_sts() {				//사건수정전 상태확인()
				var f = document.ormsForm;
			
				var lshp_amnno = "<%=lshp_amnno %>"
				$("#lshp_amnno").val(lshp_amnno);
				
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los");
				WP.setParameter("process_id", "ORLS010209");
				WP.setForm(f);

				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function (result) {
							var rList = result.DATA;
							if (result != 'undefined') {
								$('#cur_lshp_dcz_sts_dsc').val(rList[0].lshp_dcz_sts_dsc);
								
								save("N");
							}
						},

						complete: function (statusText, status) {
						},

						error: function (rtnMsg) {
							alert("상태조회중 로딩중 에러발생");
						}
					});
			}
			function reprt(sts_dsc) {
				var f = document.ormsForm;
				
				if (!confirm("상신 하시겠습니까?")) return;
				valid_by_role(parent.$("#role_id").val());
				
				if($('#vld_chk_yn').val()=="N"){
					alert("필수입력사항이 입력되지 않았습니다.");
				}else{
					var role_id = "<%=role_id %>";
					var lshp_amnno = "<%=lshp_amnno %>"
					$("#role_id").val(role_id);
					$("#lshp_amnno").val(lshp_amnno);
					$("#s_lshp_dcz_sts_dsc").val(sts_dsc);
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "los");
					WP.setParameter("process_id", "ORLS010103");
					WP.setForm(f);
					var url = "<%=System.getProperty("contextpath")%>/comMain.do";
					var inputData = WP.getParams();

					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
						{
							success: function (result) {
								alert("상신 되었습니다.");
								$(".popup", parent.document).hide();
								parent.doAction("search");
							},

							complete: function (statusText, status) {
								removeLoadingWs();
							},

							error: function (rtnMsg) {
								alert(JSON.stringify(rtnMsg));
							}
						});
				}
			}
			function apprv() {
				var f = document.ormsForm;
				if (!confirm("승인 하시겠습니까?")) return;
				
				var role_id = "<%=role_id %>";
				var lshp_amnno = "<%=lshp_amnno %>"
				$("#role_id").val(role_id);
				$("#lshp_amnno").val(lshp_amnno);
				$("#rtn_yn").val('N');
				$("#s_lshp_dcz_sts_dsc").val('06');
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los");
				WP.setParameter("process_id", "ORLS010103");
				WP.setForm(f);
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();

				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function (result) {
							alert("승인 되었습니다.");
							$(".popup", parent.document).hide();
							parent.doAction("search");
						},

						complete: function (statusText, status) {
							removeLoadingWs();
						},

						error: function (rtnMsg) {
							alert(JSON.stringify(rtnMsg));
						}
					});
			}
			function rejct() {
				var f = document.ormsForm;
				if (!confirm("반려 하시겠습니까?")) return;

				var role_id = "<%=role_id %>";
				var lshp_amnno = "<%=lshp_amnno %>"
				$("#role_id").val(role_id);
				$("#lshp_amnno").val(lshp_amnno);
				$("#s_lshp_dcz_sts_dsc").val('04');
				$("#rtn_yn").val('Y');
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los");
				WP.setParameter("process_id", "ORLS010103");
				WP.setForm(f);
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();

				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function (result) {
							alert("반려 되었습니다.");
							$(".popup", parent.document).hide();
							parent.doAction("search");
						},

						complete: function (statusText, status) {
							removeLoadingWs();
						},

						error: function (rtnMsg) {
							alert(JSON.stringify(rtnMsg));
						}
					});
			}
			
			function commAllDel(){
				var f = document.ormsForm;
				var html = "";
				
				if (!confirm("전체해제 하시겠습니까?")) return;
				
				for(var i=mySheet5.GetDataFirstRow(); i<=mySheet5.GetDataLastRow(); i++){
					html += '<input type="hidden" id="hd_comn_lshp_amnno" name="hd_comn_lshp_amnno" value="'+mySheet5.GetCellValue(i, "comn_lshp_amnno")+'">'	
				}
				
				$("#comn_html").html(html);
				
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los");
				WP.setParameter("process_id", "ORLS010905");
				WP.setForm(f);
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();

				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function (result) {
							alert("해제 되었습니다.");
							$(".popup", parent.document).hide();
							parent.doAction("search");
						},

						complete: function (statusText, status) {
							removeLoadingWs();
						},

						error: function (rtnMsg) {
							alert(JSON.stringify(rtnMsg));
						}
					});
				
			}
			
			function commDel(){
				var f = document.ormsForm;
				var html = "";
				var row = mySheet5.GetSelectRow();
				
				if (!confirm("관리번호 : "+mySheet5.GetCellValue(row, "comn_lshp_amnno")+"를 해제 하시겠습니까?")) return;
				
				html += '<input type="hidden" id="hd_comn_lshp_amnno" name="hd_comn_lshp_amnno" value="'+mySheet5.GetCellValue(row, "comn_lshp_amnno")+'">'
				
				$("#comn_html").html(html);
				
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "los");
				WP.setParameter("process_id", "ORLS010906");
				WP.setForm(f);
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();

				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function (result) {
							alert("해제 되었습니다.");
							doAction_mySheet5("search");
							doAction_mySheet6("search");
						},

						complete: function (statusText, status) {
							removeLoadingWs();
						},

						error: function (rtnMsg) {
							alert(JSON.stringify(rtnMsg));
						}
					});
				
			}
	
</script>

</head>
<body>
	<div id="" class="popup modal parent block">
		<div class="p_frame w1100">
			<div class="p_head">
				<h3 class="title md">공통손실 상세조회</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<h3 class="txt txt-sm mb10">
						기준정보로 설정할 손실사건을 선택해주세요.<br>
						(기준정보로 선택된 손실사건을 기준으로 손실사건 상세정보가 표시됩니다.)
					</h3>


					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-grid w750 h150">
								<script>createIBSheet("mySheet5", "100%","100%");</script>
							</div>
						</div>
<%
String lshp_dcz_sts_dsc = (String) hLossDtlMap.get("lshp_dcz_sts_dsc");
if(role_id.equals("orm")){
	if(lshp_dcz_sts_dsc.equals("04")||lshp_dcz_sts_dsc.equals("06")){
%>
						<div class="box-body">
							<div class="btn-wrap">
								<button class="btn btn-default btn-xs" type="button" onclick="javascript:doAction_mySheet5('commAdd');"><i class="fa fa-plus"></i><span class="txt">손실사건 추가</span></button>
								<button class="btn btn-default btn-xs mt2" type="button" onclick="javascript:doAction_mySheet5('commDel');"><i class="fa fa-minus"></i><span class="txt">공통손실 등록해제</span></button>
								<button class="btn btn-default btn-xs mt2" type="button" onclick="javascript:commAllDel();"><i class="fa fa-minus"></i><span class="txt">공통손실 등록 전체 해제</span></button>
							</div>
							<div class="btn-wrap mt10">
								<button class="btn btn-primary btn-xs" type="button" onclick="javascript:search();"><span class="txt">기준설정</span></button>
							</div>
						</div>
<%		
	}
}
%>						
						
					</div>					
					<form name="ormsForm" method="post">
						<div id="register"></div>
						<input type="hidden" id="path" name="path" /> 
						<input type="hidden" id="process_id" name="process_id" /> 
						<input type="hidden" id="commkind" name="commkind" /> 
						<input type="hidden" id="method" name="method" /> 
						<input type="hidden" id="mode" name="mode" value="U" /> 
						<input type="hidden" id="hd_lshp_amnno" name="hd_lshp_amnno" value="<%=lshp_amnno %>" />
						<input type="hidden" id="lshp_dcz_sts_dsc" name="lshp_dcz_sts_dsc" value="<%=(String)hLossDtlMap.get("lshp_dcz_sts_dsc") %>" /> 
						<input type="hidden" id="vld_chk_yn" name="vld_chk_yn" value="" />
						<input type="hidden" id="role_id" name="role_id" />
						<input type="hidden" id="lshp_amnno" name="lshp_amnno" />
						<input type="hidden" id="cur_lshp_dcz_sts_dsc" name="cur_lshp_dcz_sts_dsc" />
						<input type="hidden" id="s_lshp_dcz_sts_dsc" name="s_lshp_dcz_sts_dsc" />
						<div id="loss_html"></div>
						<div id="comn_html"></div>

						<h4 class="title md">조직정보</h4>
						<div class="wrap-table mb30">
							<table>
								<colgroup>
									<col style="width:150px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>손실사건 발생법인</th>
										<td>
											<div class="select">
												<select class="form-control" id="grp_org_c" name="grp_org_c" disabled>
													<option value="">선택</option>
			<%
					for(int i=0;i<vGrpList.size();i++){
						HashMap hMap = (HashMap)vGrpList.get(i);
						if(((String)hMap.get("grp_org_c")).equals((String)hLossDtlMap.get("grp_org_c"))){
			%>
													<option value="<%=(String)hMap.get("grp_org_c")%>" selected><%=(String)hMap.get("grp_orgnm")%></option>
			<%
						}else{
			%>
													<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
			<%
						}
					}
			%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>사건발생 부서(영업점)</th>
										<td>
											<input type="hidden" id="ocu_brc" name="ocu_brc" value="<%=(String)hLossDtlMap.get("ocu_brc")%>" />
											<input type="text" class="form-control w80p fl" id="ocu_brnm" name="ocu_brnm" value="<%=(String)hLossDtlMap.get("ocu_brnm")%>" disabled />
											<button type="button" class="btn btn-default btn-sm ico" id="ocu_brnm_btn" onclick="ocu_brc_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>발생지역</th>
										<td>
											<input type="hidden" id="ocu_up_brc" name="ocu_up_brc" value="<%=(String)hLossDtlMap.get("ocu_up_brc")%>" />
											<input type="text" class="form-control w80p fl" id="ocu_up_brnm" name="ocu_up_brnm" value="<%=(String)hLossDtlMap.get("ocu_up_brnm")%>" onKeyPress="EnterkeySubmitOrg();" disabled />
											<button type="button" class="btn btn-default btn-sm ico" id="ocu_up_brnm_btn" onclick="ocu_up_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>사건발생국가</th>
										<td>
											<div class="select">
												<select class="form-control" id="hpn_ocu_natcd" name="hpn_ocu_natcd" disabled>
													<option value="">선택</option>
			<%
					for(int i=0;i<vHpnOcuNatcdLst.size();i++){
						HashMap hMap = (HashMap)vHpnOcuNatcdLst.get(i);
						if(((String)hMap.get("intgc")).equals((String)hLossDtlMap.get("hpn_ocu_natcd"))){
			%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
			<%
						}else{
			%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
			<%
						}
					}
			%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>보고자</th>
										<td>
											<input type="hidden" id="rprr_eno" name="rprr_eno" value="<%=(String)hLossDtlMap.get("rprr_eno")%>" />
											<%
						if(((String)hLossDtlMap.get("rprr_enm")).isEmpty()){
			%>
											<input type="text" class="form-control w80p fl" id="shw_rprr_nm" name="shw_rprr_nm" value="" readonly>
											<%
						}else{
			%>
											<input type="text" class="form-control w80p fl" id="shw_rprr_nm" name="shw_rprr_nm" value="<%=(String)hLossDtlMap.get("rprr_enm")%> (<%=(String)hLossDtlMap.get("rprr_pzcnm")%> <%=(String)hLossDtlMap.get("rprr_eno")%>)" readonly>
											<%
						}
			%>
											<button type="button" class="btn btn-default btn-sm ico" id="shw_rprr_nm_btn" onclick="schEmpPopup('', 'empSearchEnd');" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>보고부서</th>
										<td>
											<input type="hidden" id="rpt_brc" name="rpt_brc" value="<%=(String)hLossDtlMap.get("rpt_brc")%>" />
											<input type="text" class="form-control w80p fl" id="rpt_brnm" name="rpt_brnm" value="<%=(String)hLossDtlMap.get("rpt_brnm")%>" disabled />
											<button type="button" class="btn btn-default btn-sm ico" id="rpt_brnm_btn" onclick="rpt_brc_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>

										</td>
									</tr>
									<tr>
										<th>채권관리부서</th>
										<td>
											<input type="hidden" id="bnd_amn_brc" name="bnd_amn_brc" value="<%=(String)hLossDtlMap.get("bnd_amn_brc")%>">
											<input type="text" class="form-control w80p fl" id="bnd_amn_brnm" name="bnd_amn_brnm" value="<%=(String)hLossDtlMap.get("bnd_amn_brnm")%>" disabled />
											<button type="button" class="btn btn-default btn-sm ico" id="bnd_amn_brnm_btn" onclick="bnd_amn_brc_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>사건관리부서</th>
										<td>
											<input type="hidden" id="amn_brc" name="amn_brc" value="<%=(String)hLossDtlMap.get("amn_brc")%>" />
											<input type="text" class="form-control w350 fl" id="amn_brnm" name="amn_brnm" value="<%=(String)hLossDtlMap.get("amn_brnm")%>" disabled />
											<button type="button" class="btn btn-default btn-sm ico" id="amn_brnm_btn" onclick="amn_brc_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
											<input type="hidden" class="form-control w350 fl" id="isr_rqs_yn" name="isr_rqs_yn" value="Y" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<h4 class="title md">일자정보</h4>
						<div class="wrap-table mb30">
							<table>
								<colgroup>
									<col style="width:150px" />
									<col />
								</colgroup>
								<tr>
									<th>발생일자</th>
									<td>
										<span class="date-group">
											<input type="text" id="ocu_dt" name="ocu_dt" value="<%=(String)hLossDtlMap.get("ocu_dt")%>" class="form-control w70p fl" disabled />
											<button type="button" class="btn btn-default ico fl" id="ocu_dt_btn" onclick="showCalendar('yyyyMMdd','ocu_dt');" style="display:none">
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</td>
								</tr>
								<tr>
									<th>발견일자</th>
									<td>
										<span class="date-group">
											<input type="text" id="dcv_dt" name="dcv_dt" value="<%=(String)hLossDtlMap.get("dcv_dt")%>" class="form-control w70p fl" disabled />
											<button type="button" class="btn btn-default ico fl" id="dcv_dt_btn" onclick="showCalendar('yyyyMMdd','dcv_dt');" style="display:none">
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</td>
								</tr>
								<tr>
									<th>최초등록일자</th>
									<td>
										<span class="date-group">
											<input type="text" id="fir_inp_dt" name="fir_inp_dt" value="<%=(String)hLossDtlMap.get("fir_inp_dt")%>" class="form-control w70p fl" readonly />
										</span>
									</td>
								</tr>
								<tr>
									<th>최종변경일자</th>
									<td>
										<span class="date-group">
											<input type="text" id="lschg_dt" name="lschg_dt" value="<%=(String)hLossDtlMap.get("lschg_dt")%>" class="form-control w70p fl" readonly />
										</span>
									</td>
								</tr>
							</table>
						</div>
						<h4 class="title md">관리정보</h4>
						<div class="wrap-table mb30">
							<table>
								<colgroup>
									<col style="width:150px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>손실사건 관리번호</th>
										<td>
											<input type="text" class="form-control" id="comn_lshp_amnno" name="comn_lshp_amnno" value="<%=(String)hLossDtlMap.get("lshp_amnno")%>" readonly />
										</td>
									</tr>
									<tr id="hur_amnno_tr" style="display:none">
										<th>인사부 관리번호</th>
										<td>
											<input type="text" class="form-control" id="hur_amnno" name="hur_amnno" value="<%=(String)hLossDtlMap.get("hur_amnno")%>" disabled />
										</td>
									</tr>
									<tr>
										<th>사건 제목</th>
										<td>
											<input type="text" class="form-control" id="lshp_tinm" name="lshp_tinm" value="<%=(String)hLossDtlMap.get("lshp_tinm")%>" disabled maxlength="200" />
										</td>
									</tr>
									<tr id="ocu_dept_dtl_cntn_tr" style="display:none">
										<th>보고부서 상세내용</th>
										<td>
											<textarea cols="100" rows="3" class="form-control textarea" id="ocu_dept_dtl_cntn" name="ocu_dept_dtl_cntn" disabled><%=StringUtil.htmlEscape((String)hLossDtlMap.get("ocu_dept_dtl_cntn"),false,false)%></textarea>
										</td>
									</tr>
									<tr id="amn_dept_dtl_cntn_tr" style="display:none">
										<th>관리부서 상세내용</th>
										<td>
											<textarea cols="100" rows="3" class="form-control textarea" id="amn_dept_dtl_cntn" name="amn_dept_dtl_cntn" disabled><%=StringUtil.htmlEscape((String)hLossDtlMap.get("amn_dept_dtl_cntn"),false,false)%></textarea>
										</td>
									</tr>
									<tr id="oprk_amn_dtl_cntn_tr" style="display:none">
										<th>ORM 상세내용</th>
										<td>
											<textarea cols="100" rows="3" class="form-control textarea" id="oprk_amn_dtl_cntn" name="oprk_amn_dtl_cntn" disabled><%=StringUtil.htmlEscape((String)hLossDtlMap.get("oprk_amn_dtl_cntn"),false,false)%></textarea>
										</td>
									</tr>
									<tr>
										<th>손실발생채널</th>
										<td>
											<input type="text" class="form-control" id="lsoc_chan_cntn" name="lsoc_chan_cntn" value="<%=(String)hLossDtlMap.get("lsoc_chan_cntn")%>" disabled />
										</td>
									</tr>
									<tr>
										<th>관련상품명</th>
										<td>
											<input type="text" class="form-control" id="lshp_rel_wrsnm" name="lshp_rel_wrsnm" value="<%=(String)hLossDtlMap.get("lshp_rel_wrsnm")%>" disabled />
										</td>
									</tr>
									<tr>
										<th>소송여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="lws_yn" name="lws_yn" onchange="chk_lws_yn_chg()" disabled>
		<%
					if(((String)hLossDtlMap.get("lws_yn")).equals("Y")){
		%>
													<option value="">선택</option>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
		<%
					}else if(((String)hLossDtlMap.get("lws_yn")).equals("N")){
		%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
		<%
					}else if(((String)hLossDtlMap.get("lws_yn")).equals("")){
		%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
		<%
					}
		
		%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>소송심급</th>
										<td>
											<div class="select">
												<select class="form-control" id="lwsjdg_dsc" name="lwsjdg_dsc" disabled>
													<option value="">선택</option>
		<%
				for(int i=0;i<vLwsjdgDscLst.size();i++){
					HashMap hMap = (HashMap)vLwsjdgDscLst.get(i);
					if(((String)hMap.get("intgc")).equals((String)hLossDtlMap.get("lwsjdg_dsc"))){
		%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}else{
		%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}
				}
		%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>소송종결여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="lws_tmnt_yn" name="lws_tmnt_yn" disabled>
		<%
					if(((String)hLossDtlMap.get("lws_tmnt_yn")).equals("Y")){
		%>
													<option value="">선택</option>
													<option value="Y" selected>종결</option>
													<option value="N">진행중</option>
		<%
					}else if(((String)hLossDtlMap.get("lws_tmnt_yn")).equals("N")){
		%>
													<option value="">선택</option>
													<option value="Y">종결</option>
													<option value="N" selected>진행중</option>
		<%
					}else if(((String)hLossDtlMap.get("lws_tmnt_yn")).equals("")){
		%>
													<option value="">선택</option>
													<option value="Y">종결</option>
													<option value="N">진행중</option>
		<%
					}
		
		%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>소송결과</th>
										<td>
											<select class="form-control w100p" id="lws_rzt_c" disabled>
												<option value="">선택</option>
		<%
				for(int i=0;i<vLwsRztCLst.size();i++){
					HashMap hMap = (HashMap)vLwsRztCLst.get(i);
					if(((String)hMap.get("intgc")).equals((String)hLossDtlMap.get("lws_rzt_c"))){
		%>
												<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}else{
		%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
		<%
					}
				}
		%>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div><!-- .wrap-table //-->

						<br />
						<!-- 재무정보 및 회계정보 -->
						<h4 class="title md">재무정보 및 회계정보</h4>
						<!-- 손실발생금 -->
						<div class="box box-grid bgkl line bt br bl p10">
							<div class="box-header md">
								<h5 class="box-title md ib pr10">손실비용 및 손실회수</h5>
								<div class="btn-wrap ib">
								<%if("Y".equals(no1_hcnt)){%>
									<button type="button" class="btn btn-xs btn-normal" id="lss_am_conn_btn" onclick="schAccConnPopup(1);" style="display:none"><span class="txt">계정연결</span></button>
								<%}%>
								</div>
								<div class="fr">
									<div class="form-group-sm ib fr">
										<label class="fl mt5 mr10"><i class="label label-texe cr">(A)</i>비용합계액</label>
										<input type="hidden" id="lss_cst_am" name="lss_cst_am" />
										<input type="text" class="form-control text-right w130 ib" id="shw_lss_cst_am" readonly /> 원
									</div>
									<div class="form-group-sm ib fr ml20">
										<label class="fl mt5 mr10"><i class="label label-texe cb">(가)</i>회수합계액</label>
										<input type="hidden" id="lss_wdr_am" name="lss_wdr_am" />
										<input type="text" class="form-control text-right w130 ib" id="shw_lss_wdr_am" readonly /> 원
									</div>
								</div>
							</div>
							<!-- /.box-header -->
							<div class="box-body">
								<div class="wrap-grid scroll h150">
									<script> createIBSheet("mySheet1", "100%", "100%"); </script>
								</div><!-- .wrap //-->
							</div><!-- .box-body //-->
							<div class="box-footer md right">
								<div class="btn-group mt5"><button type="button" class="btn btn-primary btn-sm " id="lss_am_mnl_btn" onclick="javascript:doAction_mySheet1('insert')" style="display:none">수기입력</button></div>
							</div><!-- .box-footer //-->
						</div>
						<!-- 손실발생금 //-->
						<!-- 보험회수 -->
						<div class="box box-grid line br bl p10">
							<div class="box-header md">
								<h5 class="box-title md ib pr10">보험회수</h5>
								<div class="btn-wrap ib">
								<%if("Y".equals(no1_hcnt)){%>
									<button type="button" class="btn btn-xs btn-normal" id="isr_am_conn_btn" onclick="schAccConnPopup(2);" style="display:none"><span class="txt">계정연결</span></button>
								<%}%>
								</div>
								<div class="form-group-sm ib fr">
									<label class="fl mt5 mr10"><i class="label label-texe cb">(나)</i>합계액</label>
									<input type="hidden" id="isr_wdr_am" name="isr_wdr_am" />
									<input type="text" class="form-control text-right w150 ib" id="shw_isr_wdr_am" readonly /> 원
								</div>
							</div>
							<!-- /.box-header -->
							<div class="box-body">
								<div class="wrap-grid scroll h150">
									<script> createIBSheet("mySheet2", "100%", "100%"); </script>
								</div><!-- .wrap //-->
							</div><!-- .box-body //-->
							<div class="box-footer md right">
								<div class="btn-group mt5"><button type="button" class="btn btn-primary btn-sm" id="isr_am_mnl_btn" onclick="javascript:doAction_mySheet2('insert')" style="display:none">수기입력</button></div>
							</div><!-- .box-footer //-->
						</div>
						<!-- 보험회수 //-->
						<!-- 소송비용 및 소송회수  -->
						<div class="box box-grid bgkl line br bl p10">
							<div class="box-header md">
								<h5 class="box-title md ib pr10">소송비용 및 소송회수</h5>
								<div class="btn-wrap ib">
								<%if("Y".equals(no1_hcnt)){%>
									<button type="button" class="btn btn-xs btn-normal" id="lws_am_conn_btn" onclick="schAccConnPopup(3);" style="display:none"><span class="txt">계정연결</span></button>
								<%}%>
								</div>
								<div class="fr">
									<div class="form-group-sm ib fl">
										<label class="fl mt5 mr10"><i class="label label-texe cr">(B)</i>비용합계액</label>
										<input type="hidden" id="lws_cst_am" name="lws_cst_am" />
										<input type="text" class="form-control text-right w130 ib" id="shw_lws_cst_am" readonly /> 원
									</div>
									<div class="form-group-sm ib fr ml20">
										<label class="fl mt5 mr10"><i class="label label-texe cb">(다)</i>회수합계액</label>
										<input type="hidden" id="lws_wdr_am" name="lws_wdr_am" />
										<input type="text" class="form-control text-right w130 ib" id="shw_lws_wdr_am" readonly /> 원
									</div>
								</div>
							</div>
							<!-- /.box-header -->
							<div class="box-body">
								<div class="wrap-grid scroll h150">
									<script> createIBSheet("mySheet3", "100%", "100%"); </script>
								</div><!-- .wrap //-->
							</div><!-- .box-body //-->
							<div class="box-footer md right">
								<div class="btn-group mt5"><button type="button" class="btn btn-primary btn-sm " id="lws_am_mnl_btn" onclick="javascript:doAction_mySheet3('insert')" style="display:none">수기입력</button></div>
							</div><!-- .box-footer //-->
						</div>
						<!-- 소송비용 및 소송회수  //-->
						<!-- 기타비용 및 기타회수  -->
						<div class="box box-grid line br bl p10">
							<div class="box-header md">
								<h5 class="box-title md ib pr10">기타비용 및 기타회수</h5>
								<div class="btn-wrap ib">
								<%if("Y".equals(no1_hcnt)){%>
									<button type="button" class="btn btn-xs btn-normal" id="etc_am_conn_btn" onclick="schAccConnPopup(4);" style="display:none"><span class="txt">계정연결</span></button>
								<%}%>
								</div>
								<div class="fr">
									<div class="form-group-sm ib fl">
										<label class="fl mt5 mr10"><i class="label label-texe cr">(C)</i>비용합계액</label>
										<input type="hidden" id="etc_cst_am" name="etc_cst_am" />
										<input type="text" class="form-control text-right w130 ib" id="shw_etc_cst_am" readonly /> 원
									</div>
									<div class="form-group-sm ib fr ml20">
										<label class="fl mt5 mr10"><i class="label label-texe cb">(라)</i>회수합계액</label>
										<input type="hidden" id="etc_wdr_am" name="etc_wdr_am" />
										<input type="text" class="form-control text-right w130 ib" id="shw_etc_wdr_am" readonly /> 원
									</div>
								</div>
							</div>
							<!-- /.box-header -->
							<div class="box-body">
								<div class="wrap-grid scroll h150">
									<script> createIBSheet("mySheet4", "100%", "100%"); </script>
								</div><!-- .wrap //-->
							</div><!-- .box-body //-->
							<div class="box-footer md right">
								<div class="btn-group mt5"><button type="button" class="btn btn-primary btn-sm " id="etc_am_mnl_btn" onclick="javascript:doAction_mySheet4('insert')" style="display:none">수기입력</button></div>
							</div><!-- .box-footer //-->
						</div>
						<!-- 기타비용 및 기타회수  //-->
						<!-- 총손실금액, 총회수금액 -->
						<div class="box box-grid  bgyl line ba p10 mb30 md">
							<div class="form-group mb5 right">
								<label class="ib mr10">총손실금액<span><i class="label label-texe cr">(A)</i> + <i class="label label-texe cr">(B)</i> + <i class="label label-texe cr">(C)</i></span></label>
								<input type="hidden" id="tot_lssam" name="tot_lssam" />
								<input type="text" class="form-control input text-right ib w150" id="shw_tot_lssam" readonly />원
							</div>
							<div class="form-group mb5 right ">
								<label class="ib mr10">총회수금액<i class="label label-texe cb">(가)</i> + <i class="label label-texe cb">(나)</i> + <i class="label label-texe cb">(다)</i> +
									<i class="label label-texe cb">(라)</i></label>
								<input type="hidden" id="tot_wdr_am" name="tot_wdr_am" />
								<input type="text" class="form-control input text-right ib w150" id="shw_tot_wdr_am" readonly />원
							</div>
							<div class="form-group right ">
								<label class="ib mr10">순손실금액</label>
								<input type="hidden" id="gu_lssam" name="gu_lssam" />
								<input type="text" class="form-control input text-right ib w150" id="shw_gu_lssam" readonly />원
							</div>
						</div>
						<!-- 총손실금액, 총회수금액 -->
						<!-- 재무정보 및 회계정보 -->
						<!-- 분석 정보 -->
						<h4 class="title md">분석정보</h4>
						<div class="wrap-table md">
							<table>
								<colgroup>
									<col style="width:150px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th><strong>손실형태</strong>
											<button type="button" class="btn btn-normal btn-xs btn-help" id="lshp_form_help_btn" onclick="$('#winHelp2').show();">
											<i class="fa fa-exclamation-circle"></i>
											<span class="blind">HELP</span></button>
										</th>
										<td>
											<div class="select">
												<select class="form-control" id="lshp_form_c" name="lshp_form_c" disabled>
													<option value="">선택</option>
			<%
					for(int i=0;i<vLshpFormLst.size();i++){
						HashMap hMap = (HashMap)vLshpFormLst.get(i);
						if(((String)hMap.get("intgc")).equals((String)hLossDtlMap.get("lshp_form_c"))){
			%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
			<%
						}else{
			%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
			<%
						}
					}
			%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th><strong>손실상태</strong>
											<button type="button" class="btn btn-normal btn-xs btn-help" id="lshp_form_help_btn" onclick="$('#winHelp3').show();">
											<i class="fa fa-exclamation-circle"></i>
											<span class="blind">HELP</span></button>
										</th>
										<td>
											<div class="select">
												<select class="form-control" id="lshp_stsc" name="lshp_stsc" disabled>
			<%
					for(int i=0;i<vLshpStscLst.size();i++){
						HashMap hMap = (HashMap)vLshpStscLst.get(i);
						if(((String)hMap.get("intgc")).equals((String)hLossDtlMap.get("lshp_stsc"))){
			%>
													<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
			<%
						}else{
			%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
			<%
						}
					}
			%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>업무프로세스</th>
										<td>
											<input type="hidden" id="bsn_prss_c" name="bsn_prss_c" value="<%=(String)hLossDtlMap.get("bsn_prss_c_lv4")%>" />
			<%
						if(((String)hLossDtlMap.get("bsn_prsnm_lv4")).isEmpty()){
			%>
											<input type="text" class="form-control w90p fl" id="shw_bsn_prss_nm" name="shw_bsn_prss_nm" value="" readonly />
			<%
						}else{
			%>
											<input type="text" class="form-control w90p fl" id="shw_bsn_prss_nm" name="shw_bsn_prss_nm" value="<%=(String)hLossDtlMap.get("bsn_prsnm_lv1")%> > <%=(String)hLossDtlMap.get("bsn_prsnm_lv2")%> > <%=(String)hLossDtlMap.get("bsn_prsnm_lv3")%> > <%=(String)hLossDtlMap.get("bsn_prsnm_lv4")%>" readonly />
			<%
						}
			%>
											<button type="button" class="btn btn-default btn-sm ico" id="shw_bsn_prss_nm_btn" onclick="prss_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>사건유형</th>
										<td>
											<input type="hidden" id="hpn_tpc" name="hpn_tpc" value="<%=(String)hLossDtlMap.get("hpn_tpc_lv3")%>" />
			<%
						if(((String)hLossDtlMap.get("hpn_tpnm_lv3")).isEmpty()){
			%>
											<input type="text" class="form-control w90p fl" id="shw_hpn_tpnm" name="shw_hpn_tpnm" value="" readonly />
			<%
						}else{
			%>
											<input type="text" class="form-control w90p fl" id="shw_hpn_tpnm" name="shw_hpn_tpnm" value="<%=(String)hLossDtlMap.get("hpn_tpnm_lv1")%> > <%=(String)hLossDtlMap.get("hpn_tpnm_lv2")%> > <%=(String)hLossDtlMap.get("hpn_tpnm_lv3")%>" readonly />
			<%
						}
			%>
											<button type="button" class="btn btn-default btn-sm ico" id="shw_hpn_tpnm_btn" onclick="hpn_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>원인유형</th>
										<td>
											<input type="hidden" id="cas_tpc" name="cas_tpc" value="<%=(String)hLossDtlMap.get("cas_tpc_lv3")%>" />
			<%
						if(((String)hLossDtlMap.get("cas_tpnm_lv3")).isEmpty()){
			%>
											<input type="text" class="form-control w90p fl" id="shw_cas_tpnm" name="shw_cas_tpnm" value="" readonly />
			<%
						}else{
			%>
											<input type="text" class="form-control w90p fl" id="shw_cas_tpnm" name="shw_cas_tpnm" value="<%=(String)hLossDtlMap.get("cas_tpnm_lv1")%> > <%=(String)hLossDtlMap.get("cas_tpnm_lv2")%> > <%=(String)hLossDtlMap.get("cas_tpnm_lv3")%>" readonly />
			<%
						}
			%>
											<button type="button" class="btn btn-default btn-sm ico" id="shw_cas_tpnm_btn" onclick="cas_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>영향유형</th>
										<td>
											<input type="hidden" id="ifn_tpc" name="ifn_tpc" value="<%=(String)hLossDtlMap.get("ifn_tpc_lv2")%>" />
		<%
					if(((String)hLossDtlMap.get("ifn_tpnm_lv2")).isEmpty()){
		%>
											<input type="text" class="form-control w90p fl" id="shw_ifn_tpnm" name="shw_ifn_tpnm" value="" readonly />
		<%
					}else{
		%>
											<input type="text" class="form-control w90p fl" id="shw_ifn_tpnm" name="shw_ifn_tpnm" value="<%=(String)hLossDtlMap.get("ifn_tpnm_lv1")%> > <%=(String)hLossDtlMap.get("ifn_tpnm_lv2")%>" readonly />
		<%
					}
		%>
											<button type="button" class="btn btn-default btn-sm ico" id="shw_ifn_tpnm_btn" onclick="ifn_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
									<tr>
										<th>이머징리스크유형</th>
										<td>
											<input type="hidden" id="emrk_tpc" name="emrk_tpc" value="<%=(String)hLossDtlMap.get("emrk_tpc_lv2")%>" />
		<%
					if(((String)hLossDtlMap.get("emrk_tpnm_lv2")).isEmpty()){
		%>
											<input type="text" class="form-control w90p fl" id="shw_emrk_nm" name="shw_emrk_nm" value="" readonly />
		<%
					}else{
		%>
											<input type="text" class="form-control w90p fl" id="shw_emrk_nm" name="shw_emrk_nm" value="<%=(String)hLossDtlMap.get("emrk_tpnm_lv1")%> > <%=(String)hLossDtlMap.get("emrk_tpnm_lv2")%>" readonly />
		<%
					}
		%>
											<button type="button" class="btn btn-default btn-sm ico" id="shw_emrk_nm_btn" onclick="emrk_popup();" style="display:none">
												<i class="fa fa-search"></i><span class="blind">검색</span>
											</button>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- 분석 정보 //-->
						<!-- 경계리스크 정보 -->
						<h4 class="title md">경계리스크 정보</h4>
						<div class="wrap-table mb30">
							<table>
								<colgroup>
									<col style="width:120px" />
									<col />
									<col style="width:120px" />
									<col />
									<col />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>시장리스크 여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="mkrk_yn" name="mkrk_yn" disabled>
			<%
						if(((String)hLossDtlMap.get("mkrk_yn")).equals("Y")){
			%>
													<option value="">선택</option>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
			<%
						}else if(((String)hLossDtlMap.get("mkrk_yn")).equals("N")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
			<%
						}else if(((String)hLossDtlMap.get("mkrk_yn")).equals("")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
			<%
						}
			
			%>
												</select>
											</div>
										</td>
										<th>신용리스크 여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="crrk_yn" name="crrk_yn" disabled>
			<%
						if(((String)hLossDtlMap.get("crrk_yn")).equals("Y")){
			%>
													<option value="">선택</option>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
			<%
						}else if(((String)hLossDtlMap.get("crrk_yn")).equals("N")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
			<%
						}else if(((String)hLossDtlMap.get("crrk_yn")).equals("")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
			<%
						}
			
			%>
												</select>
											</div>
										</td>
										<th>신용 RWA 반영 여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="rwa_yn" name="rwa_yn" disabled>
			<%
						if(((String)hLossDtlMap.get("rwa_yn")).equals("Y")){
			%>
													<option value="">선택</option>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
			<%
						}else if(((String)hLossDtlMap.get("rwa_yn")).equals("N")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
			<%
						}else if(((String)hLossDtlMap.get("rwa_yn")).equals("")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
			<%
						}
			
			%>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>전략리스크 여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="strk_yn" name="strk_yn" disabled>
			<%
						if(((String)hLossDtlMap.get("strk_yn")).equals("Y")){
			%>
													<option value="">선택</option>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
			<%
						}else if(((String)hLossDtlMap.get("strk_yn")).equals("N")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
			<%
						}else if(((String)hLossDtlMap.get("strk_yn")).equals("")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
			<%
						}
			
			%>
												</select>
											</div>
										</td>
										<th>평판리스크 여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="fmrk_yn" name="fmrk_yn" disabled>
			<%
						if(((String)hLossDtlMap.get("fmrk_yn")).equals("Y")){
			%>
													<option value="">선택</option>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
			<%
						}else if(((String)hLossDtlMap.get("fmrk_yn")).equals("N")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
			<%
						}else if(((String)hLossDtlMap.get("fmrk_yn")).equals("")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
			<%
						}
			
			%>
												</select>
											</div>
										</td>
										<th>법률리스크 여부</th>
										<td>
											<div class="select">
												<select class="form-control" id="lgrk_yn" name="lgrk_yn" disabled>
			<%
						if(((String)hLossDtlMap.get("lgrk_yn")).equals("Y")){
			%>
													<option value="">선택</option>
													<option value="Y" selected>Y</option>
													<option value="N">N</option>
			<%
						}else if(((String)hLossDtlMap.get("lgrk_yn")).equals("N")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N" selected>N</option>
			<%
						}else if(((String)hLossDtlMap.get("lgrk_yn")).equals("")){
			%>
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
			<%
						}
			
			%>
												</select>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- 경계리스크 정보 //-->
						<div class="box box-grid mt30">							
							<h5 class="box-title md">공통손실 등록이전 개별손실사건의 정보이력</h5>
							<div class="box-body">
								<div class="wrap-grid h150">
									<script> createIBSheet("mySheet6", "100%", "100%"); </script>
								</div>
							</div>
						</div>
						
					</form>
				</div>
				<!-- .p_wrap //-->
			</div>
			<!-- .p_body //-->
			<div class="p_foot">
				<div class="btn-wrap center">
<%
if( role_id.equals("orm") ){
	if(lshp_dcz_sts_dsc.equals("04")){
%>
					<button type="button" class="btn btn-primary main-btn" onclick="javascript:reprt('05')">결재상신</button>
<%		
	}
	if(lshp_dcz_sts_dsc.equals("04")||lshp_dcz_sts_dsc.equals("06")){
%>
					<button type="button" class="btn btn-primary" onclick="javascript:chk_sts()">저장</button>
<%		
	}
}else if(role_id.equals("ormld")){
	if(lshp_dcz_sts_dsc.equals("05")){
%>		
					<button type="button" class="btn btn-primary main-btn" onclick="apprv()">승인</button>
					<button type="button" class="btn btn-primary main-btn" onclick="rejct()">반려</button>
<%		
	}
}
%>
			
					<button type="button" class="btn btn-default btn-close">닫기</button>
					
				</div>
			</div>
			<!-- .p_foot //-->
			<button type="button" class="btn btn-normal btn-xs btn-help fix" onclick="$('#winHelp1').show();">
				<i class="fa fa-exclamation-circle"></i><span class="ml5">HELP</span>
			</button>
			<button type="button" class="ico close  fix btn-close">
				<span class="blind">닫기</span>
			</button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<!-- popup //-->
	<%@ include file="../comm/OrgInfP.jsp"%>
	<!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp"%>
	<!-- 업무프로세스 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp"%>
	<!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp"%>
	<!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/EmrkInfP.jsp"%>
	<!-- 이머징리스크유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp"%>
	<!-- 영향유형 공통 팝업 -->
	<%-- <%@ include file="../comm/AccConnP.jsp"%> --%>
	<!-- 계정연결 공통 팝업 -->
	<%@ include file="../comm/OrgEmpInfP.jsp"%>
	<!-- 부서별직원 공통 팝업 -->

	<div id="winHelp1" class="popup modal" style="background-color:transparent">
		<iframe name="ifrHelp1" id="ifrHelp1" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/los/ORLS0110" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true"></iframe>
	</div>
	<div id="winHelp2" class="popup modal" style="background-color:transparent">
		<iframe name="ifrHelp2" id="ifrHelp2" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/los/ORLS0106" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true"></iframe>
	</div>
	<div id="winHelp3" class="popup modal" style="background-color:transparent">
		<iframe name="ifrHelp3" id="ifrHelp3" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/los/ORLS0107" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true"></iframe>
	</div>
	<div id="winLossMod" class="popup modal"  style="background-color:transparent">
		<iframe name="ifrLossMod" id="ifrLossMod" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
	</div>
	<div id="winLossSup" class="popup modal"  style="background-color:transparent">
		<iframe name="ifrLossSup" id="ifrLossSup" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
	</div>



</body>
<script>
$(document).ready(function () {
	//열기
	// 		$(".btn-open").click( function(){
	// 			$(".popup").show();
	// 		});
	//닫기
	$(".btn-close").click( function(event) {
		$(".popup", parent.document).hide();
		parent.$("#ifrCommMod").attr("src","about:blank");
		event.preventDefault();
	});
});

var init_flag = false;




// 발생지역검색 완료
function ocu_up_popup() {
	schOrgPopup("ocu_up_brnm", "ocuUpSearchEnd");
	if ($("#ocu_up_brnm").val() == "" && init_flag) {
		$("#ifrOrg").get(0).contentWindow.doAction("search");
	}
	init_flag = false;
}
function ocuUpSearchEnd(brc, brnm) {
	if (brc == "") init_flag = true;
	$("#ocu_up_brc").val(brc);
	$("#ocu_up_brnm").val(brnm);
	$("#winBuseo").hide();
	//doAction('search');
}

// 발생부서검색 완료
function ocu_brc_popup() {
	init_flag = false;
	schOrgPopup("ocu_brnm", "ocuBrcSearchEnd");
	if ($("#ocu_brnm").val() == "" && init_flag) {
		$("#ifrOrg").get(0).contentWindow.doAction("search");
	}
	init_flag = false;
}
function ocuBrcSearchEnd(brc, brnm) {

	//doAction('search');

	set_ocu_up_brc();
}

// 채권관리부서검색 완료
function bndAmnBrcSearchEnd(brc, brnm) {
	$("#bnd_amn_brc").val(brc);
	$("#bnd_amn_brnm").val(brnm);
	$("#winBuseo").hide();
	//doAction('search');
}
function bnd_amn_brc_popup() {
	init_flag = false;
	schOrgPopup("bnd_amn_brnm", "bndAmnBrcSearchEnd");
	if ($("#bnd_amn_brnm").val() == "" && init_flag) {
		$("#ifrOrg").get(0).contentWindow.doAction("search");
	}
	init_flag = false;
}
// 보고부서검색 완료
function rpt_brc_popup() {
	init_flag = false;
	schOrgPopup("rpt_brnm", "rptBrcSearchEnd");
	if ($("#rpt_brnm").val() == "" && init_flag) {
		$("#ifrOrg").get(0).contentWindow.doAction("search");
	}
	init_flag = false;
}
function rptBrcSearchEnd(brc, brnm) {
	$("#rpt_brc").val(brc);
	$("#rpt_brnm").val(brnm);
	$("#winBuseo").hide();
	//doAction('search');
}
// 사건관리부서검색 완료
function amn_brc_popup() {
	init_flag = false;
	schOrgPopup("amn_brnm", "amnBrcSearchEnd");
	if ($("#amn_brnm").val() == "" && init_flag) {
		$("#ifrOrg").get(0).contentWindow.doAction("search");
	}
	init_flag = false;
}
function amnBrcSearchEnd(brc, brnm) {
	$("#amn_brc").val(brc);
	$("#amn_brnm").val(brnm);
	$("#winBuseo").hide();
	//doAction('search');
}

// 업무프로세스검색 완료
var PRSS4_ONLY = true;
var CUR_BSN_PRSS_C = "";

function prss_popup() {
	CUR_BSN_PRSS_C = $("#bsn_prss_c").val();
	if (ifrPrss.cur_click != null) ifrPrss.cur_click();
	schPrssPopup();
}

function prssSearchEnd(bsn_prss_c, bsn_prsnm
	, bsn_prss_c_lv1, bsn_prsnm_lv1
	, bsn_prss_c_lv2, bsn_prsnm_lv2
	, bsn_prss_c_lv3, bsn_prsnm_lv3
	, biz_trry_c_lv1, biz_trry_cnm_lv1
	, biz_trry_c_lv2, biz_trry_cnm_lv2) {
	$("#bsn_prss_c").val(bsn_prss_c);
	$("#shw_bsn_prss_nm").val(bsn_prsnm_lv1 + " > " + bsn_prsnm_lv2 + " > " + bsn_prsnm_lv3 + " > " + bsn_prsnm);


	$("#winPrss").hide();
}

function prss_remove() {
	$("#prss_c").val("");
	$("#prss_nm").val("");
}

// 손실사건유형검색 완료
var HPN3_ONLY = true;
var CUR_HPN_TPC = "";

function hpn_popup() {
	CUR_HPN_TPC = $("#hpn_tpc").val();
	if (ifrHpn.cur_click != null) ifrHpn.cur_click();
	schHpnPopup();
}

function hpnSearchEnd(hpn_tpc, hpn_tpnm, hpn_tpc_lv1, hpn_tpnm_lv1, hpn_tpc_lv2, hpn_tpnm_lv2) {
	$("#hpn_tpc").val(hpn_tpc);
	$("#shw_hpn_tpnm").val(hpn_tpnm_lv1 + " > " + hpn_tpnm_lv2 + " > " + hpn_tpnm);

	$("#winHpn").hide();
	//doAction('search');
}

// 이머징리스크유형검색 완료
var EMRK2_ONLY = true;
var CUR_EMRK_TPC = "";

function emrk_popup() {
	CUR_EMRK_TPC = $("#emrk_c").val();
	schEmrkPopup();
}

function emrkSearchEnd(emrk_tpc, emrk_tpnm, emrk_tpc_lv1, emrk_tpnm_lv1) {
	$("#emrk_c").val(emrk_tpc);
	$("#shw_emrk_nm").val(emrk_tpnm_lv1 + " > " + emrk_tpnm);

	$("#winEmrk").hide();
	//doAction('search');
}

function emrk_remove() {
	$("#emrk_c").val("");
	$("#shw_emrk_nm").val("");
}


// 원인유형검색 완료
var CAS3_ONLY = true;
var CUR_CAS_TPC = "";

function cas_popup() {
	CUR_CAS_TPC = $("#cas_tpc").val();
	if (ifrCas.cur_click != null) ifrCas.cur_click();
	schCasPopup();
}

function casSearchEnd(cas_tpc, cas_tpnm, cas_tpc_lv1, cas_tpnm_lv1, cas_tpc_lv2, cas_tpnm_lv2) {
	$("#cas_tpc").val(cas_tpc);
	$("#shw_cas_tpnm").val(cas_tpnm_lv1 + " > " + cas_tpnm_lv2 + " > " + cas_tpnm);

	$("#winCas").hide();
	//doAction('search');
}

// 영향유형검색 완료
var IFN2_ONLY = true;
var CUR_IFN_TPC = "";

function ifn_popup() {
	CUR_IFN_TPC = $("#ifn_tpc").val();
	if (ifrIfn.cur_click != null) ifrIfn.cur_click();
	schIfnPopup();
}

function ifnSearchEnd(ifn_tpc, ifn_tpnm, ifn_tpc_lv1, ifn_tpnm_lv1) {
	$("#ifn_tpc").val(ifn_tpc);
	$("#shw_ifn_tpnm").val(ifn_tpnm_lv1 + " > " + ifn_tpnm);

	$("#winIfn").hide();
	//doAction('search');
}

// 이머징리스크유형검색 완료
var EMRK2_ONLY = true;
var CUR_EMRK_TPC = "";

function emrk_popup() {
	CUR_EMRK_TPC = $("#emrk_tpc").val();
	schEmrkPopup();
}

function emrkSearchEnd(emrk_tpc, emrk_tpnm, emrk_tpc_lv1, emrk_tpnm_lv1) {
	$("#emrk_tpc").val(emrk_tpc);
	$("#shw_emrk_nm").val(emrk_tpnm_lv1 + " > " + emrk_tpnm);

	$("#winEmrk").hide();
	//doAction('search');
}

function emrk_remove() {
	$("#emrk_tpc").val("");
	$("#shw_emrk_nm").val("");
}

// 보고자검색 완료
function empSearchEnd(eno, empnm) {
	$("#rprr_eno").val(eno);
	$("#shw_rprr_nm").val(empnm);

	$("#winEmp").hide();
	//doAction('search');
}

	function helpClose() {
		$("#winHelp1").hide();
		$("#winHelp2").hide();
		$("#winHelp3").hide();
	}
	function accConnClose() {
		$("#winAccConn").hide();
	}
</script>
</html>