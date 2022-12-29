<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0103.jsp
 Program name : 내부손실사건 신규등록(팝업)
 Description  : LDM-03
 Programer    : 이규탁
 Date created : 2022.08.08
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@	page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext"%>
<%@ include file="../comm/comUtil.jsp"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	SysDateDao dao = new SysDateDao(request);

	String dt = dao.getSysdate();//yyyymmdd

	HashMap hMapSession = (HashMap) request.getSession(true).getAttribute("infoH");

	String auth_ids = hs.get("auth_ids").toString();
	String[] auth_grp_id = auth_ids.replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "")
			.split(",");
	
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
	//unit05
	Vector vLssAcgAcccLst = CommUtil.getCommonCode(request, "LSS_ACG_ACCC");
	if(vLssAcgAcccLst==null) vLssAcgAcccLst = new Vector();
	//unit06
	Vector vOcuUp = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
	if(vOcuUp==null) vOcuUp = new Vector();
	//unit07
	Vector vLsIsrKdcLst = CommUtil.getCommonCode(request, "LS_ISR_KDC");
	if(vLsIsrKdcLst==null) vLsIsrKdcLst = new Vector();
	//unit08
	Vector vLwsjdgDscLst = CommUtil.getCommonCode(request, "LWSJDG_DSC");
	if(vLwsjdgDscLst==null) vLwsjdgDscLst = new Vector();
	//unit09
	Vector vLwsRztCLst = CommUtil.getCommonCode(request, "LWS_RZT_C");
	if(vLwsRztCLst==null) vLwsRztCLst = new Vector();
	//unit10
	Vector vHpnOcuNatcdLst = CommUtil.getCommonCode(request, "HPN_OCU_NATCD");
	if(vHpnOcuNatcdLst==null) vHpnOcuNatcdLst = new Vector();
	//unit11
	Vector vLsSpfAmnDeptCLst = CommUtil.getCommonCode(request, "LS_SPF_AMN_DEPT_C");
	if(vLsSpfAmnDeptCLst==null) vLsSpfAmnDeptCLst = new Vector();

	HashMap hMapOcuUp = null;
	if (vOcuUp.size() > 0) {
		hMapOcuUp = (HashMap) vOcuUp.get(0);
	} else {
		hMapOcuUp = new HashMap();
	}

	String acg_accc = "";
	String acg_accnm = "";

	for (int i = 0; i < vLssAcgAcccLst.size(); i++) {
		HashMap hp = (HashMap) vLssAcgAcccLst.get(i);
		if (acg_accc == "") {
			acg_accc += (String) hp.get("intgc");
			acg_accnm += (String) hp.get("intg_cnm");
		} else {
			acg_accc += ("|" + (String) hp.get("intgc"));
			acg_accnm += ("|" + (String) hp.get("intg_cnm"));
		}
	}

	String ls_isr_kdc = "";
	String ls_isr_kdnm = "";

	for (int i = 0; i < vLsIsrKdcLst.size(); i++) {
		HashMap hp = (HashMap) vLsIsrKdcLst.get(i);
		if (ls_isr_kdc == "") {
			ls_isr_kdc += (String) hp.get("intgc");
			ls_isr_kdnm += (String) hp.get("intg_cnm");
		} else {
			ls_isr_kdc += ("|" + (String) hp.get("intgc"));
			ls_isr_kdnm += ("|" + (String) hp.get("intg_cnm"));
		}
	}

	DynaForm form = (DynaForm) request.getAttribute("form");
	String[] acc_sqno;
	String[] lss_acg_accc;
	String[] crc_can_dsc;
	String[] acg_prc_dt;
	String[] am;
	String[] tr_cntn;
	String[] rvpy_dsc;
	String[] acc_brc;
	String[] ocu_brc;
	String[] acc_dsc;
	
	String role_id = (String)form.get("role_id"); //역할구분코드
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp"%>
	<script>
		$(document).ready(function(){
			//$("#winRskMod",parent.document).show();
			// ibsheet 초기화
			initIBSheet1();
			initIBSheet2();
			initIBSheet3();
			initIBSheet4();
			initIBSheet5();
					
		//*계정연결확인시(GL화면에서 등록시)*//
<%if (form.gets("acc_sqno") != null) {
					acc_sqno = (String[]) form.gets("acc_sqno");
					lss_acg_accc = (String[]) form.gets("lss_acg_accc");
					crc_can_dsc = (String[]) form.gets("crc_can_dsc");
					acg_prc_dt = (String[]) form.gets("acg_prc_dt");
					am = (String[]) form.gets("am");
					tr_cntn = (String[]) form.gets("tr_cntn");
					rvpy_dsc = (String[]) form.gets("rvpy_dsc");
					acc_brc = (String[]) form.gets("acc_brc");
					ocu_brc = (String[]) form.gets("ocu_brc");
					acc_dsc = (String[]) form.gets("acc_dsc");%>
			var mySheet;
			var sheetno;
			var row;
	<%for (int i = 0; i < acc_sqno.length; i++) {%>
				sheetno	= "<%=(String) acc_dsc[i]%>";		
				switch(sheetno) {
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
				row = mySheet.DataInsert(-1);
				// mySheet.RowCount();
				mySheet.SetCellValue(row, "acc_dsc", sheetno);
				mySheet.SetCellValue(row, "status", "I");
				mySheet.SetCellValue(row, "lss_acg_accc", "<%=lss_acg_accc[i]%>");
				mySheet.SetCellValue(row, "acc_brc", "<%=acc_brc[i]%>");
				mySheet.SetCellValue(row, "acc_sqno", "<%=acc_sqno[i]%>");
				mySheet.SetCellValue(row, "rvpy_dsc", "<%=rvpy_dsc[i]%>");
				mySheet.SetCellValue(row, "crc_can_dsc", "<%=crc_can_dsc[i]%>");
				mySheet.SetCellValue(row, "acg_prc_dt", "<%=acg_prc_dt[i]%>");
				mySheet.SetCellValue(row, "lsoc_am", "<%=am[i]%>");
				mySheet.SetCellValue(row, "tr_cntn", "<%=new String(tr_cntn[i].getBytes("ISO8859_1"), "UTF-8")%>");
				mySheet.SetCellText(row,"del_btn",'<button type="button" class="btn btn-default btn-xs" onclick="del_btn'+sheetno+'('+row+')">삭제<i class="fa fa-caret-right"></i></button>');		//삭제버튼생성
				mySheet.SetCellEditable(row,"lss_acg_accc",0);
				mySheet.SetCellEditable(row,"acg_prc_dt",0);
				mySheet.SetCellEditable(row,"lsoc_am",0);
				mySheet.SetCellEditable(row,"tr_cntn",0);
				mySheet.SetCellEditable(row,"rvpy_dsc",0);
	<%}%>				
<%}%>				
		
					ableByRole(parent.$("#role_id").val());
// 					chk_ham_xpc_am();	//손실형태 재무손실이면서 신용리스크일때 피해예상금액 사용
					
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
					
// 				initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
						initData1.Cols = [
							{ Header: "No", 		Type: "Seq", SaveName: "rw_no", MinWidth: 30, Align: "center" },
							//				    {Header:"계산",			Type:"Combo",	SaveName:"tt_yn",									Width:40,Align:"center",MinWidth:15, 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
							{ Header: "회계처리일자", 	Type: "Date", 	SaveName: "acg_prc_dt", 				MinWidth: 90, Format: "yyyyMMdd", Align: "center"},
							{ Header: "계정구분코드", 	Type: "Text", 	SaveName: "acc_dsc", 	Hidden: true },
							{ Header: "손실금액일련번호",Type: "Text", 	SaveName: "lssam_sqno", Hidden: true },
							{ Header: "상태", 		Type: "Status", SaveName: "status", 	Hidden: true, 	MinWidth: 30, Align: "center"},
							{ Header: "acc_sqno", 	Type: "Text", 	SaveName: "acc_sqno", 	Hidden: true },
							{ Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",							Width:270,Align:"Left",	 					ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
							{ Header: "손실 회계 계정 코드", 		Type: "Text", SaveName: "lss_acg_accc", 	MinWidth: 30, Align: "center"},
							{ Header: "전표 번호", 		Type: "Text", SaveName: "tr_sqno", 	 			MinWidth: 30, Align: "center"},
							{ Header: "통화", 		Type: "Text", SaveName: "lsoc_curc", 	 				MinWidth: 30, Align: "center"},
							{ Header: "acc_brc", 	Type: "Text", 	SaveName: "acc_brc", 	Hidden: true },
							{ Header: "crc_can_dsc",Type: "Text", 	SaveName: "crc_can_dsc",Hidden: true },
							{ Header: "금액", 		Type: "Int", 	SaveName: "lsoc_am", 					MinWidth: 100, Align: "Right", AcceptKeys: "N" },
							{ Header: "거래내역", 		Type: "Text", 	SaveName: "tr_cntn", 					MinWidth: 250, Align: "Left"},
							{ Header: "비고", 		Type: "Text", 	SaveName: "rmk_cntn", 	Hidden: true,	MinWidth: 120, Align: "Left",EditLen: 200 },
							{ Header: "차대", 		Type: "Combo", 	SaveName: "rvpy_dsc", 	Hidden: true,	MinWidth: 60, ComboText: "입금|지급", ComboCode: "1|2", PopupText: "입금|지급" },
							{ Header: "hpn_rc_dt", 	Type: "Text", 	SaveName: "hpn_rc_dt", 	Hidden: true },
							{ Header: "acd_no", 	Type: "Text", 	SaveName: "acd_no", 	Hidden: true },
							{ Header: "보험종류", 		Type: "Text", 	SaveName: "ls_isr_kdc", Hidden: true, 	MinWidth: 160, Align: "Left"},
							{ Header: "lws_prg_cntn",Type: "Text", 	SaveName: "lws_prg_cntn",Hidden: true },
							{ Header: "lws_hpn_no", Type: "Text", 	SaveName: "lws_hpn_no", Hidden: true },
							{ Header: "wdr_am_rcp_dt",Type: "Text", SaveName: "wdr_am_rcp_dt",Hidden: true },
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
					
				}
				/***************************************************************************************/
				/* 보험회수금액(mySheet2) 처리                                                                                                                                                                                       */
				/***************************************************************************************/
				/*Sheet 기본 설정 */
				function initIBSheet2() {
					//시트 초기화
					mySheet2.Reset();
					
					var initData2 = {};
					
// 					initData2.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
					initData2.Cols = [
	
						{ Header: "No", 		Type: "Seq", 	SaveName: "rw_no", 					MinWidth: 30, Align: "center"},
						// 				    { Header:"계산",			Type:"Combo",	SaveName:"tt_yn",									Width:40,Align:"center",MinWidth:15, 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
						{ Header: "회계처리일자", 	Type: "Date", 	SaveName: "acg_prc_dt", 				Format: "yyyyMMdd", MinWidth: 90, Align: "center" },
						{ Header: "계정구분코드", 	Type: "Text", 	SaveName: "acc_dsc", 	Hidden: true },
						{ Header: "손실금액일련번호",Type: "Text", 	SaveName: "lssam_sqno", Hidden: true },
						{ Header: "상태", 		Type: "Status", SaveName: "status", 	Hidden: true, 	MinWidth: 30, Align: "center"},
						{ Header: "acc_sqno", 	Type: "Text", 	SaveName: "acc_sqno", 	Hidden: true },
						 {Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",							Width:270,Align:"Left",	 					ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
						{ Header: "손실 회계 계정 코드", 		Type: "Text", SaveName: "lss_acg_accc", 	MinWidth: 30, Align: "center"},
						{ Header: "전표 번호", 		Type: "Text", SaveName: "tr_sqno", 	 			MinWidth: 30, Align: "center"},
						{ Header: "통화", 		Type: "Text", SaveName: "lsoc_curc", 	 				MinWidth: 30, Align: "center"},
						{ Header: "acc_brc", 	Type: "Text", 	SaveName: "acc_brc", 	Hidden: true },
						{ Header: "crc_can_dsc",Type: "Text", 	SaveName: "crc_can_dsc",Hidden: true },
						{ Header: "금액", 		Type: "Int", 	SaveName: "lsoc_am", 					MinWidth: 80, Align: "Right", AcceptKeys: "N" },
						{ Header: "거래내역", 		Type: "Text", 	SaveName: "tr_cntn", 					Wrap: true, MultiLineText: true, MinWidth: 170, Align: "Left"},
						{ Header: "비고", 		Type: "Text", 	SaveName: "rmk_cntn", 	Hidden: true,	MinWidth: 80, Align: "Left", EditLen: 200 },
						{ Header: "입금지급구분코드",Type: "Text", 	SaveName: "rvpy_dsc", 	Hidden: true },
						{ Header: "사건접수일", 	Type: "Date", 	SaveName: "hpn_rc_dt", 	Hidden: true, 	Format: "yyyyMMdd", MinWidth: 90, Align: "center" },
						{ Header: "사고번호", 		Type: "Text", 	SaveName: "acd_no", 	Hidden: true, 	MinWidth: 70, Align: "Left", },
						{ Header: "보험종류", 		Type: "Combo", 	SaveName: "ls_isr_kdc", 				Wrap: true, MinWidth: 160, Align: "Left", ComboText: "<%=ls_isr_kdnm%>", ComboCode: "<%=ls_isr_kdc%>" },
						{ Header: "lws_prg_cntn",Type: "Text", 	SaveName: "lws_prg_cntn",Hidden: true },
						{ Header: "lws_hpn_no", Type: "Text", 	SaveName: "lws_hpn_no", Hidden: true },
						{ Header: "보험금수령일", 	Type: "Date", 	SaveName: "wdr_am_rcp_dt",Hidden: true, Format: "yyyyMMdd", MinWidth: 90, Align: "center" },
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
					
				}
				/***************************************************************************************/
				/* 소송금액(mySheet3) 처리                                                                                                                                                                                       */
				/***************************************************************************************/
				/*Sheet 기본 설정 */
				function initIBSheet3() {
					//시트 초기화
					mySheet3.Reset();
					
					var initData3 = {};
					
// 					initData3.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
					initData3.Cols = [
	
						{ Header: "No", 		Type: "Seq", 	SaveName: "rw_no", 						MinWidth: 30, Align: "center" },
						// 				    {Header:"계산",			Type:"Combo",	SaveName:"tt_yn",									Width:40,Align:"center",MinWidth:15, 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
						{ Header: "회계처리일자", 	Type: "Date", 	SaveName: "acg_prc_dt", 				MinWidth: 90, Align: "center", Format: "yyyyMMdd" },
						{ Header: "계정구분코드", 	Type: "Text", 	SaveName: "acc_dsc", 	Hidden: true },
						{ Header: "손실금액일련번호",Type: "Text", 	SaveName: "lssam_sqno", Hidden: true },
						{ Header: "상태", 		Type: "Status", SaveName: "status", 	Hidden: true, 	MinWidth: 30, Align: "center" },
						{ Header: "acc_sqno", 	Type: "Text", 	SaveName: "acc_sqno", 	Hidden: true },
						 {Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",							Width:270,Align:"Left",	 					ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
						{ Header: "손실 회계 계정 코드", 		Type: "Text", SaveName: "lss_acg_accc", 	MinWidth: 30, Align: "center"},
						{ Header: "전표 번호", 		Type: "Text", SaveName: "tr_sqno", 	 			MinWidth: 30, Align: "center"},
						{ Header: "통화", 		Type: "Text", SaveName: "lsoc_curc", 	 				MinWidth: 30, Align: "center"},
						{ Header: "acc_brc", 	Type: "Text", 	SaveName: "acc_brc", 	Hidden: true },
						{ Header: "crc_can_dsc",Type: "Text", 	SaveName: "crc_can_dsc",Hidden: true },
						{ Header: "금액", 		Type: "Int", 	SaveName: "lsoc_am", 					MinWidth: 80, Align: "Right", AcceptKeys: "N" },
						{ Header: "거래내역", 		Type: "Text", 	SaveName: "tr_cntn", 					MinWidth: 150, Wrap: true, Align: "Left" },
						{ Header: "비고", 		Type: "Text", 	SaveName: "rmk_cntn", 	Hidden: true,	MinWidth: 70, Align: "Left", EditLen: 200 },
						{ Header: "사건번호", 		Type: "Text", 	SaveName: "lws_hpn_no", 				MinWidth: 100, Align: "Left" },
						{ Header: "진행심", 		Type: "Text", 	SaveName: "lws_prg_cntn", 				MinWidth: 50, Align: "Left" },
						{ Header: "차대", 		Type: "Combo", 	SaveName: "rvpy_dsc", 					MinWidth: 60, ComboText: "입금|지급", ComboCode: "1|2", PopupText: "입금|지급" },
						{ Header: "hpn_rc_dt", 	Type: "Text", 	SaveName: "hpn_rc_dt", 	Hidden: true },
						{ Header: "acd_no", 	Type: "Text", 	SaveName: "acd_no", 	Hidden: true },
						{ Header: "보험종류", 		Type: "Text", 	SaveName: "ls_isr_kdc", Hidden: true, 	MinWidth: 160, Align: "Left" },
						{ Header: "회수금수령일", 	Type: "Date", 	SaveName: "wdr_am_rcp_dt", Hidden: true, 				MinWidth: 90, Align: "center", Format: "yyyyMMdd" },
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
					
				}
				/***************************************************************************************/
				/* 손실발생금액(mySheet4) 처리                                                                                                                                                                                       */
				/***************************************************************************************/
				/*Sheet 기본 설정 */
				function initIBSheet4() {
					//시트 초기화
					mySheet4.Reset();
					
					var initData4 = {};
					
// 					initData4.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
					initData4.Cols = [
	
						{ Header: "No", 		Type: "Seq", 	SaveName: "rw_no", 						MinWidth: 30, Align: "center" },
						// 				    {Header:"계산",			Type:"Combo",	SaveName:"tt_yn",									Width:40,Align:"center",MinWidth:15, 					ComboText:"Y|N", ComboCode:"Y|N",PopupText:"Y|N"},
						{ Header: "계정구분코드", 	Type: "Text", 	SaveName: "acc_dsc", 	Hidden: true },
						{ Header: "손실금액일련번호",Type: "Text", 	SaveName: "lssam_sqno", Hidden: true },
						{ Header: "상태", 		Type: "Status", SaveName: "status", 	Hidden: true, 	MinWidth: 30, Align: "center" },
						{ Header: "acc_sqno", 	Type: "Text", 	SaveName: "acc_sqno", 	Hidden: true },
						{ Header: "회계처리일", 	Type: "Date", 	SaveName: "acg_prc_dt", 				MinWidth: 90, Align: "center", Format: "yyyyMMdd" },
						 {Header:"계정과목명",		Type:"Combo",	SaveName:"lss_acg_accc",							Width:270,Align:"Left",	 					ComboText:"<%=acg_accnm%>",ComboCode:"<%=acg_accc%>",},
						{ Header: "손실 회계 계정 코드", 		Type: "Text", SaveName: "lss_acg_accc", 	MinWidth: 30, Align: "center"},
						{ Header: "전표 번호", 		Type: "Text", SaveName: "tr_sqno", 	 			MinWidth: 30, Align: "center"},
						{ Header: "통화", 		Type: "Text", SaveName: "lsoc_curc", 	 				MinWidth: 30, Align: "center"},
						{ Header: "acc_brc", 	Type: "Text", 	SaveName: "acc_brc", 	Hidden: true },
						{ Header: "crc_can_dsc",Type: "Text", 	SaveName: "crc_can_dsc",Hidden: true },
						{ Header: "금액", 		Type: "Int", 	SaveName: "lsoc_am", 					MinWidth: 80, Align: "Right", AcceptKeys: "N" },
						{ Header: "거래내역", 		Type: "Text", 	SaveName: "tr_cntn", 					Wrap: true, MinWidth: 210, Align: "Left" },
						{ Header: "비고", 		Type: "Text", 	SaveName: "rmk_cntn", 	Hidden: true,	MinWidth: 90, Align: "Left", EditLen: 200 },
						{ Header: "차대", 		Type: "Combo", 	SaveName: "rvpy_dsc", 					MinWidth: 60, ComboText: "입금|지급", ComboCode: "1|2", PopupText: "입금|지급" },
						{ Header: "hpn_rc_dt", 	Type: "Text", 	SaveName: "hpn_rc_dt", 	Hidden: true },
						{ Header: "acd_no", 	Type: "Text", 	SaveName: "acd_no", 	Hidden: true },
						{ Header: "보험종류", 		Type: "Text", 	SaveName: "ls_isr_kdc", Hidden: true, 	MinWidth: 160, Align: "Left"},
						{ Header: "진행심", 		Type: "Combo", 	SaveName: "lws_prg_cntn",Hidden: true, 	MinWidth: 50, ComboText: "1심|2심|3심|종결", ComboCode: "1심|2심|3심|종결", PopupText: "1심|2심|3심|종결" },
						{ Header: "사건번호", 		Type: "Text", 	SaveName: "lws_hpn_no", Hidden: true, 	MinWidth: 80, Align: "Left" },
						{ Header: "회수금수령일", 	Type: "Date", 	SaveName: "wdr_am_rcp_dt", 	Hidden: true,			MinWidth: 90, Align: "center", Format: "yyyyMMdd" },
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
					
				}
				
				/***************************************************************************************/
				/*  분석 정보                                                                                                                                                                                       */
				/***************************************************************************************/
				/*Sheet 기본 설정 */
				function initIBSheet5() {
					//시트 초기화
					mySheet5.Reset();

					var initData5 = {};

					initData5.Cfg = { FrozenCol: 0, MergeSheet: msHeaderOnly, AutoFitColWidth: "init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
					initData5.Cols = [
						{ Header: "grp_org_c", 		Type: "Seq", 	SaveName: "grp_org_c", 	Hidden:true,		MinWidth: 30, Align: "center"},
						{ Header: "BRC", 		Type: "Seq", 	SaveName: "brc", 			Hidden:true, 		MinWidth: 30, Align: "center"},
						{ Header: "리스크사례ID", 		Type: "Seq", 	SaveName: "rkp_id", 						MinWidth: 30, Align: "center"},
						{ Header: "평가부서", 	Type: "Text", 	SaveName: "dept_brnm", 								MinWidth: 50 },
						{ Header: "팀", 	Type: "Text", 	SaveName: "brnm", 										MinWidth: 50 },
						{ Header: "업무프로세스LV1", 	Type: "Text", 	SaveName: "prssnm1", 						MinWidth: 50 },
						{ Header: "업무프로세스LV2", 	Type: "Text", 	SaveName: "prssnm2", 						MinWidth: 50 },
						{ Header: "업무프로세스LV3", 	Type: "Text", 	SaveName: "prssnm3", 						MinWidth: 50 },
						{ Header: "업무프로세스LV4", 	Type: "Text", 	SaveName: "prssnm4", 						MinWidth: 50 },
						{ Header: "리스크사례", 	Type: "Text", 	SaveName: "rk_isc_cntn", 						MinWidth: 50 },
						{ Header: "통제활동", 	Type: "Text", 	SaveName: "c1", 									MinWidth: 50 },
						{ Header: "최초등록일", 		Type: "Date", 	SaveName: "reg_dt", 						MinWidth: 50 },
						{ Header: "최근변경일", 		Type: "Date", 	SaveName: "chg_dt", 						MinWidth: 50 }
					];


					IBS_InitSheet(mySheet5, initData5);

					//필터표시
					//mySheet5.ShowFilterRow();  

					//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
					mySheet5.SetCountPosition(0);

					// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
					// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
					// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
					mySheet5.SetSelectionMode(4);

					/*********** 콤보에 없는 아이템이 들어와도 보여준다 *************************/
					mySheet5.InitComboNoMatchText(1, "", 1);
					//최초 조회시 포커스를 감춘다.
					mySheet5.SetFocusAfterProcess(0);

					mySheet5.SetAutoRowHeight(1);

					mySheet5.SetEditable(0);
					//헤더기능 해제
					mySheet5.SetHeaderMode({ ColResize: 0, ColMode: 0, HeaderCheck: 0, Sort: 0 });
					//마우스 우측 버튼 메뉴 설정
					//setRMouseMenu(mySheet5);
					//mySheet6.SetTheme("GM", "Main");

					doAction_mySheet5('search');
				}
				
				function mySheet1_OnSearchEnd(code, message) {
					if(code != 0) {
						alert("손실발생 금액조회 중에 오류가 발생하였습니다..");
					}else{
						calLssAm();
					}
				}
				function mySheet2_OnSearchEnd(code, message) {
					if(code != 0) {
						alert("보험회수 금액조회 중에 오류가 발생하였습니다..");
					}else{
						calIsrAm();
					}
				}
				function mySheet3_OnSearchEnd(code, message) {
					if(code != 0) {
						alert("소송비용 및 소송회수 금액조회 중에 오류가 발생하였습니다..");
					}else{
						calLwsAm();
					}
				}
				function mySheet4_OnSearchEnd(code, message) {
					if(code != 0) {
						alert("기타비용 및 기타회수 금액조회 중에 오류가 발생하였습니다..");
					}else{
						calEtcAm();
					}
				}
				
				function mySheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
					calLssAm();
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
					//alert(Row);
					//if(!confirm("해당금액을 삭제하시겠습니까?"))return;
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
					//alert(Row);
					//if(!confirm("해당금액을 삭제하시겠습니까?"))return;
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
					//alert(Row);
					//if(!confirm("해당금액을 삭제하시겠습니까?"))return;
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
					//alert(Row);
					//if(!confirm("해당금액을 삭제하시겠습니까?"))return;
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
				var lws_lg_am = 0;
				var tot_lssam = 0;
				var tot_wdr_am = 0;
				var gu_lssam = 0;
				
				function calLssAm(){
					lss_cst_am = 0;
					lss_wdr_am = 0;
					if(mySheet1.GetDataLastRow() != "-1"){
						for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
							// 						if(typeof mySheet1.GetCellValue(i, "lsoc_am")==="number" && mySheet1.GetCellValue(i, "status")!=="D" && mySheet1.GetCellValue(i, "tt_yn")=="Y"){
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
							// 						if(typeof mySheet2.GetCellValue(i, "lsoc_am")==="number" && mySheet2.GetCellValue(i, "status")!=="D" && mySheet2.GetCellValue(i, "tt_yn")=="Y"){
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
							// 						if(typeof mySheet3.GetCellValue(i, "lsoc_am")==="number" && mySheet3.GetCellValue(i, "status")!=="D" && mySheet3.GetCellValue(i, "tt_yn")=="Y"){
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
					 calTotAm();
					 calGuLssAm();
				}
				function calEtcAm(){
					etc_cst_am=0;
					etc_wdr_am=0;
					if(mySheet4.GetDataLastRow() != "-1"){
						for(var i = mySheet4.GetDataFirstRow(); i<=mySheet4.GetDataLastRow(); i++){
							// 						if(typeof mySheet4.GetCellValue(i, "lsoc_am")==="number" && mySheet4.GetCellValue(i, "status")!=="D" && mySheet4.GetCellValue(i, "tt_yn")=="Y"){
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
					calTotAm();
					calGuLssAm();
				}
				function calTotLssAm(){
					lws_lg_am = $('#lws_lg_am').val();
					if(lws_lg_am == "")lws_lg_am= 0;
					tot_lssam = lss_cst_am + lws_cst_am + etc_cst_am + parseInt(lws_lg_am);

					
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
				function calTotAm() {
					lws_lg_am = $('#lws_lg_am').val();
					if(lws_lg_am == "")lws_lg_am= 0;
					tot_am = lws_cst_am + etc_cst_am + parseInt(lws_lg_am);

					$("#tot_am").val(tot_am.toString());
					$("#shw_tot_am").val(setFormatCurrency(tot_am.toString(), ","));
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
							mySheet1.SetCellText(row,"rvpy_dsc","2");		
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
							mySheet2.SetCellText(row,"rvpy_dsc","1");
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
					switch (sAction) {
						case "search":  //기타금액데이터 조회
							var opt = {};
							$("form[name=ormsForm] [name=method]").val("Main");
							$("form[name=ormsForm] [name=commkind]").val("los");
							$("form[name=ormsForm] [name=process_id]").val("ORLS010304");
							mySheet5.DoSearch(url, FormQueryStringEnc(document.ormsForm), opt);
							break;
						case "reload":  //조회데이터 리로드
							mySheet5.RemoveAll();
							initIBSheet5();
							break;
					}
				}
				function save(tmp){
					var f = document.ormsForm;
					
					if (parseInt($('#ocu_dt').val()) > parseInt($('#dcv_dt').val())) {
						alert("발생일자가 발견일자 보다 이후입니다.");
						$('#ocu_dt').focus();
						return;
					}
					if (parseInt($('#dcv_dt').val()) > parseInt($('#fir_inp_dt').val())) {
						alert("발견일자가 입력일자 보다 이후입니다.");
						$('#dcv_dt').focus();
						return;
					}
					if ($('#gu_lssam').val() < 0) {
						alert("순손실금액이 음수가 될 수 없습니다.");
						$('#gu_lssam').focus();
						return;
					}
	
					if(mySheet2.GetDataLastRow()==-1){	//보험청구여부 세팅
						$('#isr_rqs_yn').val('N');
					}else{
						$('#isr_rqs_yn').val('Y');
					}
					
					/*
					if($('#lshp_form_c').val()=='01' && $('#crrk_yn').val()=='Y' && $('#ham_xpc_am').val()==''){	//유형 : 재무손실 AND 신용리스크여부 : Y 일때는 피해예상금액 필수입력
						alert("피해예상금액을 입력해주세요.");
						return;					
					}
					*/
					
					if ($('#lshp_form_c').val() == '01' && $('#crrk_yn').val() == 'N' && ($('#tot_lssam').val() == '' || $('#tot_lssam').val() == 0)) {		//재무손실이며 신용리스크관련여부가 부일경우 총손실 금액 필요
						alert("재무손실이며 신용리스크 관련여부가 [부]일경우 총손실금액이 필요합니다.\n손실 금액을 입력해주세요");
						$('#shw_lss_cst_am').focus();
						return;
					}
					
					if ($('#lshp_tinm').val() == "") {
						alert("필수항목 손실사건 제목을 입력하지않으셨습니다.");
						$('#lshp_tinm').focus();
						return;
					}
					
					if(tmp=="Y"){
						/*
						if(confirm("임시저장하시겠습니까?")){
							var rtn = mySheet1.GetSaveData("<%=System.getProperty("contextpath")%>comMain.do?method=Main&commkind=los&process_id=ORLS010302",mySheet1.GetSaveString()+mySheet2.GetSaveString()+mySheet3.GetSaveString()+mySheet4.GetSaveString()+FormQueryStringEnc(document.ormsForm));
							saveEnd(JSON.parse(rtn).Result.Code);
						}
						return;
						*/
					}
	
					if(tmp=="N"){
						if(confirm("등록하시겠습니까?")){
							if(parent.$("#role_id").val()=='orm'){
								$("#lshp_dcz_sts_dsc").val('04');
								
								var rtn = mySheet1.GetSaveData("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS010302",mySheet1.GetSaveString()+mySheet2.GetSaveString()+mySheet3.GetSaveString()+mySheet4.GetSaveString()+FormQueryStringEnc(document.ormsForm));
								saveEnd(JSON.parse(rtn).Result.Code);
							}else if(parent.$("#role_id").val()=='admn'){ //admn의 경우는 없음
								$("#lshp_dcz_sts_dsc").val('07');
								
								var rtn = mySheet1.GetSaveData("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS010302",mySheet1.GetSaveString()+mySheet2.GetSaveString()+mySheet3.GetSaveString()+mySheet4.GetSaveString()+FormQueryStringEnc(document.ormsForm));
								saveEnd(JSON.parse(rtn).Result.Code);
							}else{
								$("#lshp_dcz_sts_dsc").val('01');
								
								var rtn = mySheet1.GetSaveData("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS010302",mySheet1.GetSaveString()+mySheet2.GetSaveString()+mySheet3.GetSaveString()+mySheet4.GetSaveString()+FormQueryStringEnc(document.ormsForm));
								saveEnd(JSON.parse(rtn).Result.Code);
							}
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
	
				function ableByRole(role){
					if(role=='orm'){	
							$("#grp_org_c").attr("disabled",true);
						$("#ocu_brnm").attr("disabled",false);
						$("#ocu_brnm_btn").show();
						$("#ocu_up_brnm").attr("disabled",false);
						$("#ocu_up_brnm_btn").show();
						$("#hpn_ocu_natcd").attr("disabled",false);
						$("#shw_rprr_nm").attr("disabled",false);
						$("#shw_rprr_nm_btn").show();
						$("#rpt_brnm").attr("disabled",false);
						$("#rpt_brnm_btn").show();
						$("#bnd_amn_brnm").attr("disabled",false);
						$("#bnd_amn_brnm_btn").show();
						$("#amn_brnm").attr("disabled",false);
						$("#amn_brnm_btn").show();
						$("#isr_rqs_yn").attr("disabled",false);			
						$("#ocu_dt").attr("disabled",false);
						$("#ocu_dt_btn").show();
						$("#dcv_dt").attr("disabled",false);
						$("#dcv_dt_btn").show();
						$("#fir_inp_dt").attr("disabled",true);
						$("#lschg_dt").attr("disabled",true);
						$("#lshp_amnno").attr("disabled",false);
						$("#hur_amnno").attr("disabled",false);
						$("#lshp_tinm").attr("disabled",false);
						$("#lsoc_chan_cntn").attr("disabled",false);
						$("#lshp_rel_wrsnm").attr("disabled",false);
						$("#grp_lshp_amnno").attr("disabled",false);
						$("#lws_yn").attr("disabled",false);
						$("#lss_am_conn_btn").show();
						$("#lss_am_mnl_btn").show();
						$("#shw_lss_cst_am").attr("disabled",true);
						$("#shw_lss_wdr_am").attr("disabled",true);
						$("#isr_am_conn_btn").show();
						$("#isr_am_mnl_btn").show();
						$("#shw_isr_wdr_am").attr("disabled",true);
						$("#lws_am_conn_btn").show();
						$("#lws_am_mnl_btn").show();
						$("#shw_lws_cst_am").attr("disabled",true);
						$("#shw_lws_wdr_am").attr("disabled",true);
						$("#etc_am_conn_btn").show();
						$("#etc_am_mnl_btn").show();
						$("#shw_etc_cst_am").attr("disabled",true);
						$("#shw_etc_wdr_am").attr("disabled",true);
						$("#shw_tot_lssam").attr("disabled",true);
						$("#shw_tot_wdr_am").attr("disabled",true);
						$("#shw_gu_lssam").attr("disabled",true);
						$("#shw_gu_lssam").attr("disabled",true);
						$("#lshp_form_c").attr("disabled",false);
						$("#lshp_form_help_btn").css("display","inline-block");
						$("#lshp_stsc").attr("disabled",false);
						$("#shw_bsn_prss_nm").attr("disabled",false);
						$("#shw_bsn_prss_nm_btn").show();
						$("#shw_hpn_tpnm").attr("disabled",false);
						$("#shw_hpn_tpnm_btn").show();
						$("#shw_cas_tpnm").attr("disabled",false);
						$("#shw_cas_tpnm_btn").show();
						$("#shw_ifn_tpnm").attr("disabled",false);
						$("#shw_ifn_tpnm_btn").show();
						$("#shw_emrk_nm").attr("disabled",false);
						$("#shw_emrk_nm_btn").show();
						$("#mkrk_yn").attr("disabled",false);
						$("#crrk_yn").attr("disabled",false);
						$("#rwa_yn").attr("disabled",false);
						$("#strk_yn").attr("disabled",false);
						$("#fmrk_yn").attr("disabled",false);
						$("#lgrk_yn").attr("disabled",false);
					}else if(role=='ormld'){
						$("#grp_org_c").attr("disabled",true);
						$("#ocu_brnm").attr("disabled",false);
						$("#ocu_brnm_btn").show();
						$("#ocu_up_brnm").attr("disabled",false);
						$("#ocu_up_brnm_btn").show();
						$("#hpn_ocu_natcd").attr("disabled",false);
						$("#shw_rprr_nm").attr("disabled",false);
						$("#shw_rprr_nm_btn").show();
						$("#rpt_brnm").attr("disabled",false);
						$("#rpt_brnm_btn").show();
						$("#bnd_amn_brnm").attr("disabled",false);
						$("#bnd_amn_brnm_btn").show();
						$("#amn_brnm").attr("disabled",false);
						$("#amn_brnm_btn").show();
						$("#isr_rqs_yn").attr("disabled",false);			
						$("#ocu_dt").attr("disabled",false);
						$("#ocu_dt_btn").show();
						$("#dcv_dt").attr("disabled",false);
						$("#dcv_dt_btn").show();
						$("#fir_inp_dt").attr("disabled",true);
						$("#lschg_dt").attr("disabled",true);
						$("#lshp_amnno").attr("disabled",false);
						$("#hur_amnno").attr("disabled",false);
						$("#lshp_tinm").attr("disabled",false);
						$("#ocu_dept_dtl_cntn_tr").css("display","table-row");
						$("#ocu_dept_dtl_cntn").attr("disabled",false);
						$("#amn_dept_dtl_cntn_tr").css("display","table-row");
						$("#amn_dept_dtl_cntn").attr("disabled",false);
						$("#oprk_amn_dtl_cntn_tr").css("display","table-row");
						$("#oprk_amn_dtl_cntn").attr("disabled",false);
						$("#lsoc_chan_cntn").attr("disabled",false);
						$("#lshp_rel_wrsnm").attr("disabled",false);
						$("#grp_lshp_amnno").attr("disabled",false);
						$("#lws_yn").attr("disabled",false);
						$("#lss_am_conn_btn").show();
						$("#lss_am_mnl_btn").show();
						$("#shw_lss_cst_am").attr("disabled",true);
						$("#shw_lss_wdr_am").attr("disabled",true);
						$("#isr_am_conn_btn").show();
						$("#isr_am_mnl_btn").show();
						$("#shw_isr_wdr_am").attr("disabled",true);
						$("#lws_am_conn_btn").show();
						$("#lws_am_mnl_btn").show();
						$("#shw_lws_cst_am").attr("disabled",true);
						$("#shw_lws_wdr_am").attr("disabled",true);
						$("#etc_am_conn_btn").show();
						$("#etc_am_mnl_btn").show();
						$("#shw_etc_cst_am").attr("disabled",true);
						$("#shw_etc_wdr_am").attr("disabled",true);
						$("#shw_tot_lssam").attr("disabled",true);
						$("#shw_tot_wdr_am").attr("disabled",true);
						$("#shw_gu_lssam").attr("disabled",true);
						$("#shw_gu_lssam").attr("disabled",true);
						$("#lshp_form_c").attr("disabled",false);
						$("#lshp_form_help_btn").css("display","inline-block");
						$("#lshp_stsc").attr("disabled",false);
						$("#shw_bsn_prss_nm").attr("disabled",false);
						$("#shw_bsn_prss_nm_btn").show();
						$("#shw_hpn_tpnm").attr("disabled",false);
						$("#shw_hpn_tpnm_btn").show();
						$("#shw_cas_tpnm").attr("disabled",false);
						$("#shw_cas_tpnm_btn").show();
						$("#shw_ifn_tpnm").attr("disabled",false);
						$("#shw_ifn_tpnm_btn").show();
						$("#shw_emrk_nm").attr("disabled",false);
						$("#shw_emrk_nm_btn").show();
						$("#mkrk_yn").attr("disabled",false);
						$("#crrk_yn").attr("disabled",false);
						$("#rwa_yn").attr("disabled",false);
						$("#strk_yn").attr("disabled",false);
						$("#fmrk_yn").attr("disabled",false);
						$("#lgrk_yn").attr("disabled",false);
					}else if(role=='nml'||role=='nmlld'){		//발생부서사용자
						
							$("#grp_org_c").attr("disabled",true);
							$("#ocu_brnm").attr("disabled",true);
							$("#ocu_brnm_btn").show();
						$("#ocu_up_brnm").attr("disabled",false);
						$("#ocu_up_brnm_btn").show();
						$("#hpn_ocu_natcd").attr("disabled",false);
							$("#shw_rprr_nm").attr("disabled",true);
							$("#shw_rprr_nm_btn").hide();
							$("#rpt_brnm").attr("disabled",true);
							$("#rpt_brnm_btn").hide();
						$("#bnd_amn_brnm").attr("disabled",false);
						$("#bnd_amn_brnm_btn").show();
							$("#amn_brnm").attr("disabled",true);
							$("#amn_brnm_btn").hide();
						$("#isr_rqs_yn").attr("disabled",false);			
						$("#ocu_dt").attr("disabled",false);
						$("#ocu_dt_btn").show();
						$("#dcv_dt").attr("disabled",false);
						$("#dcv_dt_btn").show();
							$("#fir_inp_dt").attr("disabled",true);
							$("#lschg_dt").attr("disabled",true);
						$("#lshp_amnno").attr("disabled",false);
							$("#hur_amnno").attr("disabled",true);
						$("#lshp_tinm").attr("disabled",false);
						$("#ocu_dept_dtl_cntn_tr").css("display","table-row");
						$("#ocu_dept_dtl_cntn").attr("disabled",false);
							$("#amn_dept_dtl_cntn_tr").hide();
							$("#amn_dept_dtl_cntn").attr("disabled",true);
							$("#oprk_amn_dtl_cntn_tr").hide();
							$("#oprk_amn_dtl_cntn").attr("disabled",true);
						$("#lsoc_chan_cntn").attr("disabled",false);
						$("#lshp_rel_wrsnm").attr("disabled",false);
							$("#grp_lshp_amnno").attr("disabled",true);
						$("#lws_yn").attr("disabled",false);
						$("#lss_am_conn_btn").show();
						$("#lss_am_mnl_btn").show();
							$("#shw_lss_cst_am").attr("disabled",true);
							$("#shw_lss_wdr_am").attr("disabled",true);
						$("#isr_am_conn_btn").show();
						$("#isr_am_mnl_btn").show();
							$("#shw_isr_wdr_am").attr("disabled",true);
						$("#lws_am_conn_btn").show();
						$("#lws_am_mnl_btn").show();
							$("#shw_lws_cst_am").attr("disabled",true);
							$("#shw_lws_wdr_am").attr("disabled",true);
						$("#etc_am_conn_btn").show();
						$("#etc_am_mnl_btn").show();
							$("#shw_etc_cst_am").attr("disabled",true);
							$("#shw_etc_wdr_am").attr("disabled",true);
							$("#shw_tot_lssam").attr("disabled",true);
							$("#shw_tot_wdr_am").attr("disabled",true);
							$("#shw_gu_lssam").attr("disabled",true);
							$("#shw_gu_lssam").attr("disabled",true);
						$("#lshp_form_c").attr("disabled",true);
						$("#lshp_form_help_btn").css("display","inline-block");
							$("#lshp_stsc").attr("disabled",true);
						$("#shw_bsn_prss_nm").attr("disabled",false);
						$("#shw_bsn_prss_nm_btn").show();
						$("#shw_hpn_tpnm").attr("disabled",false);
						$("#shw_hpn_tpnm_btn").show();
						$("#shw_cas_tpnm").attr("disabled",false);
						$("#shw_cas_tpnm_btn").show();
						$("#shw_ifn_tpnm").attr("disabled",false);
						$("#shw_ifn_tpnm_btn").show();
						$("#shw_emrk_nm").attr("disabled",false);
						$("#shw_emrk_nm_btn").show();
							$("#mkrk_yn").attr("disabled",true);
							$("#crrk_yn").attr("disabled",true);
							$("#rwa_yn").attr("disabled",true);
							$("#strk_yn").attr("disabled",true);
							$("#fmrk_yn").attr("disabled",true);
							$("#lgrk_yn").attr("disabled",true);
					}else if(role=='admn'){		//유관부서사용자
							$("#grp_org_c").attr("disabled",true);
<%
for(int i=0;i<vLsSpfAmnDeptCLst.size();i++){
		HashMap hMap = (HashMap)vLsSpfAmnDeptCLst.get(i);
		if ((brc).trim().equals((String)hMap.get("intgc"))) {		//부서 : 감사부,준법감시부,정보보호부는 선택이 가능
%>
						$("#ocu_brnm").attr("disabled",false);
						$("#ocu_brnm_btn").show();
						$("#ocu_up_brnm").attr("disabled",false);
						$("#ocu_up_brnm_btn").show();
<%
	}
}
%>
						$("#hpn_ocu_natcd").attr("disabled",false);
							$("#shw_rprr_nm").attr("disabled",true);
							$("#shw_rprr_nm_btn").hide();
							$("#rpt_brnm").attr("disabled",true);
							$("#rpt_brnm_btn").hide();
							$("#amn_brc'").val("<%=(String) hMapSession.get("brc")%>");
							$("#amn_brnm'").val("<%=(String) hMapSession.get("brnm")%>");
				$("#amn_brnm").attr("disabled",true);
				$("#amn_brnm_btn").hide();
				$("#amn_brnm").attr("disabled",false);
				$("#amn_brnm_btn").show();
				$("#isr_rqs_yn").attr("disabled",false);
				$("#ocu_dt").attr("disabled",false);
				$("#ocu_dt_btn").show();
				$("#dcv_dt").attr("disabled",false);
				$("#dcv_dt_btn").show();
				$("#fir_inp_dt").attr("disabled",true);
				$("#lschg_dt").attr("disabled",true);
				$("#lshp_amnno").attr("disabled",false);
<%
for(int i=0;i<vLsHurDeptCLst.size();i++){
		HashMap hMap = (HashMap)vLsHurDeptCLst.get(i);
		if ((brc).trim().equals((String)hMap.get("intgc"))) {		//인사부의 경우
%>
				$("#hur_amnno").attr("disabled",false);	
<%
	}
}
%>
		$("#lshp_tinm").attr("disabled",false);
				$("#ocu_dept_dtl_cntn_tr").hide();
				$("#ocu_dept_dtl_cntn").attr("disabled",true);
				$("#amn_dept_dtl_cntn_tr").css("display","table-row");
				$("#amn_dept_dtl_cntn").attr("disabled",false);
				$("#oprk_amn_dtl_cntn_tr").hide();
				$("#oprk_amn_dtl_cntn").attr("disabled",true);
				$("#lsoc_chan_cntn").attr("disabled",false);
				$("#lshp_rel_wrsnm").attr("disabled",false);
				$("#grp_lshp_amnno").attr("disabled",true);
				$("#lws_yn").attr("disabled",false);
				$("#lss_am_conn_btn").show();
				$("#lss_am_mnl_btn").show();
				$("#shw_lss_cst_am").attr("disabled",true);
				$("#shw_lss_wdr_am").attr("disabled",true);
				$("#isr_am_conn_btn").show();
				$("#isr_am_mnl_btn").show();
				$("#shw_isr_wdr_am").attr("disabled",true);
				$("#lws_am_conn_btn").show();
				$("#lws_am_mnl_btn").show();
				$("#shw_lws_cst_am").attr("disabled",true);
				$("#shw_lws_wdr_am").attr("disabled",true);
				$("#etc_am_conn_btn").show();
				$("#etc_am_mnl_btn").show();
				$("#shw_etc_cst_am").attr("disabled",true);
				$("#shw_etc_wdr_am").attr("disabled",true);
				$("#shw_tot_lssam").attr("disabled",true);
				$("#shw_tot_wdr_am").attr("disabled",true);
				$("#shw_gu_lssam").attr("disabled",true);
				$("#shw_gu_lssam").attr("disabled",true);
				$("#lshp_form_c").attr("disabled",true);
				$("#lshp_form_help_btn").css("display","inline-block");
				$("#lshp_stsc").attr("disabled",true);
				$("#shw_bsn_prss_nm").attr("disabled",false);
				$("#shw_bsn_prss_nm_btn").show();
				$("#shw_hpn_tpnm").attr("disabled",false);
				$("#shw_hpn_tpnm_btn").show();
				$("#shw_cas_tpnm").attr("disabled",false);
				$("#shw_cas_tpnm_btn").show();
				$("#shw_ifn_tpnm").attr("disabled",false);
				$("#shw_ifn_tpnm_btn").show();
				$("#shw_emrk_nm").attr("disabled",false);
				$("#shw_emrk_nm_btn").show();
				$("#mkrk_yn").attr("disabled",true);
				$("#crrk_yn").attr("disabled",true);
				$("#rwa_yn").attr("disabled",true);
				$("#strk_yn").attr("disabled",true);
				$("#fmrk_yn").attr("disabled",true);
				$("#lgrk_yn").attr("disabled",true);
			}
		}
		function chk_lws_yn_chg() {		//관리정보항목의 소송여부 변경시 하위항목(소송진행심급 등) 값 변경
			if ($('#lws_yn').val() == "Y") {
				$("#lwsjdg_dsc").attr("disabled",false);
				$("#lws_tmnt_yn").attr("disabled",false);
				$("#lws_rzt_c").attr("disabled",false);
				$("#lws_hp_no").attr("disabled",false);
				$("#lws_lg_am").attr("disabled",false);
				$("#lws_curt_nm").attr("disabled",false);
			} else {
				$("#lwsjdg_dsc").val("");
				$("#lws_tmnt_yn").val("");
				$("#lws_rzt_c").val("");
				$("#lws_hp_no").val("");
				$("#lws_lg_am").val("");
				$("#lws_curt_nm").val("");
		
				$("#lwsjdg_dsc").attr("disabled",true);
				$("#lws_tmnt_yn").attr("disabled",true);
				$("#lws_rzt_c").attr("disabled",true);
				$("#lws_hp_no").attr("disabled",true);
				$("#lws_lg_am").attr("disabled",true);
				$("#lws_curt_nm").attr("disabled",true);
			}
		}
		function chk_rwa_yn_chg(){
			if ($('#rwa_yn').val() == "Y") {
				
				$("#rwa_unq_no").attr("disabled",false);
			} else {
				$("#rwa_unq_no").val("");
			
				$("#rwa_unq_no").attr("disabled",true);
			}
		}
		function lws_yn_chk() {		//소송금액 발생시 관리정보항목의 소송여부 변경
			if (mySheet3.GetDataFirstRow() > 0) {
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
		function fileDown(){
			var f = document.tempform;
			f.action = "<%=System.getProperty("contextpath")%>/Jsp.do";
			f.target = "ifrHid";
			f.submit();
		}
	</script>

</head>
<body>
	<div class="popup modal block">
		<form name="tempform" method="post">
	    	<input type="hidden" id="path" name="path" value="/comm/excelfile"/>
	   		<!-- <input type="hidden" id="filename" name="filename" value="개별재무제표_XXXX년 XQ_감독목적"/>-->
	   		<input type="hidden" id="filename" name="filename" value="내부_손실사건_입력도움말"/>
	   		<input type="hidden" id="kor_filename" name="kor_filename" value="내부_손실사건_입력도움말"/>
		</form>
		<div class="p_frame w1000">
			<div class="p_head">
				<h3 class="title">내부 손실사건 등록 팝업</h3>
				<button class="btn btn-default btn-xs" onclick="javascript:fileDown();">
					<i class="fa fa-download"></i>
					<span class="txt">손실사건 입력 도움말 다운로드</span>
				</button>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<form name="ormsForm" method="post">
						<div id="register"></div>
						<input type="hidden" id="path" name="path" /> 
						<input type="hidden" id="process_id" name="process_id" /> 
						<input type="hidden" id="commkind" name="commkind" /> 
						<input type="hidden" id="method" name="method" /> 
						<input type="hidden" id="mode" name="mode" value="U" /> 
						<input type="hidden" id="lshp_dcz_sts_dsc" name="lshp_dcz_sts_dsc" value="01" /> 
						<input type="hidden" id="vld_chk_yn" name="vld_chk_yn" value="" />
						
						<h4 class="title">조직정보</h4>
						<div class="box box-search mt0">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<th>발생법인</th>
											<td>
												<select class="form-control" id="grp_org_c" name="grp_org_c" disabled>
													<option value="">전체</option>
<%
for (int i = 0; i < vGrpList.size(); i++) {
	HashMap hMap = (HashMap) vGrpList.get(i);
	if(grp_org_c.equals((String)hMap.get("grp_org_c"))){
%>
													<option value="<%=(String) hMap.get("grp_org_c")%>" selected><%=(String) hMap.get("grp_orgnm")%></option>
<%
	}else{
%>
													<option value="<%=(String) hMap.get("grp_org_c")%>"><%=(String) hMap.get("grp_orgnm")%></option>
<%			
	}
}
%>
												</select>
											</td>
											<th>보고부서</th>
											<td>
												<input type="hidden" id="rpt_brc" name="rpt_brc" value="<%=brc%>" /> 
												<input type="text" class="form-control" id="rpt_brnm" name="rpt_brnm" value="<%=brnm%>" readonly />
											</td>
											<th>사건발생부점</th>
											<td>
												<input type="hidden" id="ocu_brc" name="ocu_brc"/>
												<input type="text" class="form-control w80p fl" id="ocu_brnm" name="ocu_brnm" readonly />
												<button type="button" class="btn btn-default btn-sm ico" id="ocu_brnm_btn" onclick="ocu_brc_popup();">
													<i class="fa fa-search"></i><span class="blind">검색</span>
												</button>
											</td>
										</tr>
										<tr>
											<th>사건관리부서</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="hidden" id="amn_brc" name="amn_brc" value="" /> 
													<input type="text" class="form-control" id="amn_brnm" name="amn_brnm" value=""  readonly/>
													<input type="hidden" id="isr_rqs_yn" name="isr_rqs_yn" value="Y" />
													<div class="input-group-btn">
														<button type="button" id="amn_brnm_btn" class="btn btn-default btn-sm ico" onclick="amn_brc_popup();">
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button> 
													</div>
												</div>
											</td>
											<th>채권관리부서</th>
											<td class="form-inline">
												<div class="input-group">
													<input type="hidden" id="bnd_amn_brc" name="bnd_amn_brc" value="" readonly> 
													<input type="text" class="form-control" id="bnd_amn_brnm" name="bnd_amn_brnm" value=""  readonly/>
													<div class="input-group-btn">
														<button type="button" class="btn btn-default btn-sm ico" id="bnd_amn_brnm_btn" name="bnd_amn_brnm_btn" onclick="bnd_amn_brc_popup();">
															<i class="fa fa-search"></i><span class="blind">검색</span>
														</button>
													</div>
												</div>
											</td>
											<th>등록인</th>
											<td>
												<input type="hidden" id="rprr_eno" name="rprr_eno" value="<%=(String) hMapSession.get("userid")%>" readonly />
												<input type="text" class="form-control" id="shw_rprr_nm" name="shw_rprr_nm" value="<%=empnm %>" readonly maxlength="20" />
												<!-- 
												<button type="button" class="btn btn-default btn-sm ico" id="shw_rprr_nm_btn" onclick="orgEmpPopup();">
													<i class="fa fa-search"></i><span class="blind">검색</span>
												</button> -->
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						
						<h4 class="title">일자정보</h4>
						<div class="box box-search">
							<div class="wrap-search">
								<table>
									<colgroup>
										<col style="width: 150px" />
										<col />
									</colgroup>
									<tr>
										<th>사건발생일자</th>
										<td class="form-inline">
											<div class="input-group">
												<input type="text" id="ocu_dt" name="ocu_dt" value="" class="form-control w100"  maxlength="8" readonly />
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="ocu_dt_btn" name="ocu_dt_btn" onclick="showCalendar('yyyyMMdd','ocu_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</span>
											</div>
										</td>
										<th>사건발견일자</th>
										<td class="form-inline">
											<div class="input-group">
												<input type="text" id="dcv_dt" name="dcv_dt" value="" class="form-control w100"  maxlength="8" readonly />
												<div class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="dcv_dt_btn" name="dcv_dt_btn" onclick="showCalendar('yyyyMMdd','dcv_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</div>
											</div>
										</td>
										<th>사건등록일자</th>
										<td>
											<input type="text" id="fir_inp_dt" name="fir_inp_dt" class="form-control w100" value="<%=dt%>" readonly />
										</td>
										<th>최종변경일자</th>
										<td>
											<input type="text" id="lschg_dt" name="lschg_dt" class="form-control w100" value="<%=dt%>" readonly />
										</td>
								</table>
							</div>
						</div>
						
						<h4 class="title">관리정보</h4>
						<div class="box box-search">
							<div class="wrap-search">
								<table>
									<colgroup>
										<col style="width:150px" />
										<col style="width:150px"/>
										<col style="width:150px"/>
										<col style="width:150px"/>
										<col style="width:150px"/>
										<col style="width:150px"/>
										<col style="width:150px"/>
										<col style="width:150px"/>
									</colgroup>
									<tbody>
										<tr>
											<th>손실사건 관리번호</th>
											<td>
												<input class="form-control" id="lshp_amnno" name="lshp_amnno" value="" readonly/>
											</td>
											<th>손실 사건 제목</th>
											<td colspan="5">
												<input type="text" class="form-control" id="lshp_tinm" name="lshp_tinm" value="" maxlength="200" />
											</td>
										</tr>
										<tr>
											<th>공통 손실 사건번호</th>
											<td>
												<input type="text" class="form-control" id="grp_lshp_amnno" name="grp_lshp_amnno" value="" />
											</td>
											<th>손실 사건 내용</th>
										</tr>
										<tr>
											<th>인사부 관리번호</th>
											<td>
												<input type="text" class="form-control" id="hur_amnno" name="hur_amnno" value=""/>
											</td>
											<td rowspan="3" colspan="6">
												<textarea cols="100" class="textarea" id="ocu_dept_dtl_cntn" name="ocu_dept_dtl_cntn"></textarea>
											</td>
										</tr>
										<tr id="ocu_dept_dtl_cntn_tr">
											<th>관련상품명</th>
											<td>
												<input type="text" class="form-control" id="lshp_rel_wrsnm" name="lshp_rel_wrsnm" value="" />
											</td>
										</tr>
										<tr id="amn_dept_dtl_cntn_tr">
											
										</tr>
										<tr id="oprk_amn_dtl_cntn_tr">
											
										</tr>
										<tr>
											<th>보험 청구 여부</th>
											<td>
												<input type="text" class="form-control" id="isr_rqs_yn" name="isr_rqs_yn" value=""/>
											</td>
										</tr>
										
										<tr>
											<th>소송여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="lws_yn" name="lws_yn"	onchange="chk_lws_yn_chg()">
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
											<th>소송사건번호</th>
											<td>
												<input type="text" class="form-control" id="lws_hp_no" name="lws_hp_no" disabled/>
											</td>
											<th>소송 가액</th>
											<td>
												<input type="text" class="form-control" id="lws_lg_am" name="lws_lg_am" onchange='javascript:calTotLssAm();' onkeyup='this.value=this.value.replace(/[^a-zA-Z-_0-9]/g,"");' disabled/>
											</td>
											<th>관할 법원</th>
											<td>
												<input type="text" class="form-control" id="lws_curt_nm" name="lws_curt_nm" disabled/>
											</td>
										</tr>
										<tr>
											<th>소송심급</th>
											<td>
												<div class="select">
													<select class="form-control" id="lwsjdg_dsc" name="lwsjdg_dsc" disabled>
														<option value="">선택</option>
														<%
															for (int i = 0; i < vLwsjdgDscLst.size(); i++) {
																HashMap hMap = (HashMap) vLwsjdgDscLst.get(i);
														%>
														<option value="<%=(String) hMap.get("intgc")%>"><%=(String) hMap.get("intg_cnm")%></option>
														<%
															}
														%>
													</select>
												</div>
											</td>
											<th>소송종결여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="lws_tmnt_yn" name="lws_tmnt_yn" disabled>
														<option value="">선택</option>
														<option value="Y">종결</option>
														<option value="N">진행중</option>
													</select>
												</div>
											</td>
											<th>소송결과</th>
											<td>
												<select class="form-control w100p" id="lws_rzt_c" name="lws_rzt_c" disabled>
													<option value="">선택</option>
													<%
														for (int i = 0; i < vLwsRztCLst.size(); i++) {
															HashMap hMap = (HashMap) vLwsRztCLst.get(i);
													%>
													<option value="<%=(String) hMap.get("intgc")%>"><%=(String) hMap.get("intg_cnm")%></option>
													<%
														}
													%>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- .wrap-table //-->

						
						<!-- 재무정보 및 회계정보 -->
						<div class="box box-grid">
							<div class="box-header">
								<h4 class="title">재무정보 및 회계정보</h4>
							</div>
							<!-- 손실발생금 -->
							<div class="bgkl line bt br bl p10">
								<div class="box-header">
									<h5 class="box-title md">손실발생 비용</h5>
									<div class="btn-wrap ib">
									<%if("Y".equals(no1_hcnt)){%>
										<button type="button" class="btn btn-xs btn-normal" id="lss_am_conn_btn" onclick="schAccConnPopup(1);"><span class="txt">계정연결</span>
</button>
									<%}%>
									</div>
									<div class="fr">
										<div class="form-group-sm ib fr">
											<label class="fl mr10"><i class="label label-texe cr">(A)</i>합계액</label> 
											<input type="hidden" id="lss_cst_am" name="lss_cst_am" />
											<input type="text" class="form-control text-right w130 ib" id="shw_lss_cst_am" readonly /> 원
										</div>
										<div class="form-group-sm ib fr ml20" style="display:none">
											<label class="fl mr10"><i class="label label-texe cb">(가)</i>회수합계액</label> 
											<input type="hidden" id="lss_wdr_am" name="lss_wdr_am" />
											<input type="text" class="form-control text-right w130 ib" id="shw_lss_wdr_am" readonly /> 원
										</div>
									</div>
								</div>
								<!-- /.box-header -->
								<div class="box-body">
									<div class="wrap-grid h150">
										<script>createIBSheet("mySheet1", "100%", "100%");</script>
									</div>
									<!-- .wrap //-->
								</div>
								<!-- .box-body //-->
								<div class="box-footer right">
								<div class="btn-group mt5">
								<button type="button" class="btn btn-default btn-xs" id="lss_am_mnl_btn" onclick="javascript:doAction_mySheet1('insert')" style="display:none"><i class="fa fa-plus"></i>수기입력</button>
								</div>
								<button type="button" class="btn btn-primary btn-sm" id="lss_am_conn_btn" onclick="schAccConnPopup(1);"><span class="txt">계정연결</span></button>
							</div>
								<!-- .box-footer //-->
							</div>
							<!-- 손실발생금 //-->
							<!-- 보험회수 -->
							<div class="line br bl p10">
								<div class="box-header">
									<h5 class="box-title md">보험회수</h5>
									<div class="btn-wrap ib">
									<%if("Y".equals(no1_hcnt)){%>
										<button type="button" class="btn btn-xs btn-normal" id="isr_am_conn_btn" onclick="schAccConnPopup(2);">
											<span class="txt">계정연결</span>
										</button>
									<%}%>
									</div>
									<div class="form-group-sm ib fr">
										<label class="fl mr10"><i class="label label-texe cb">(가)</i>합계액</label> 
										<input type="hidden" id="isr_wdr_am" name="isr_wdr_am" /> 
										<input type="text" class="form-control text-right w150 ib" id="shw_isr_wdr_am" readonly /> 원
									</div>
								</div>
								<!-- /.box-header -->
								<div class="box-body">
									<div class="wrap-grid h150">
										<script>createIBSheet("mySheet2", "100%", "100%");</script>
									</div>
									<!-- .wrap //-->
								</div>
								<!-- .box-body //-->
								<div class="box-footer right">
									<div class="btn-group mt5">
										<button type="button" class="btn btn-default btn-xs" id="isr_am_mnl_btn" onclick="javascript:doAction_mySheet2('insert')" style="display:none"><i class="fa fa-plus"></i>수기입력</button>
									</div>
										<button type="button" class="btn btn-primary btn-sm" id="isr_am_conn_btn" onclick="schAccConnPopup(2);"><span class="txt">계정연결</span></button>
								</div>
								<!-- .box-footer //-->
							</div>
							<!-- 보험회수 //-->
							<!-- 소송비용 및 소송회수  -->
							<div class="bgkl line br bl p10">
								<div class="box-header">
									<h5 class="box-title md">소송비용 및 소송회수</h5>
									<div class="btn-wrap ib">
									<%if("Y".equals(no1_hcnt)){%>
										<button type="button" class="btn btn-xs btn-normal" id="lws_am_conn_btn" onclick="schAccConnPopup(3);">
											<span class="txt">계정연결</span>
										</button>
									<%}%>
									</div>
									<div class="fr">
										<div class="form-group-sm ib fl">
											<label class="fl mr10"><i class="label label-texe cr">(B)</i>비용합계액</label> 
											<input type="hidden" id="lws_cst_am" name="lws_cst_am" /> 
											<input type="text" class="form-control text-right w130 ib" id="shw_lws_cst_am" readonly /> 원
										</div>
										<div class="form-group-sm ib fr ml20">
											<label class="fl mr10"><i class="label label-texe cb">(나)</i>회수합계액</label> 
											<input type="hidden" id="lws_wdr_am" name="lws_wdr_am" /> 
											<input type="text" class="form-control text-right w130 ib" id="shw_lws_wdr_am" readonly /> 원
										</div>
									</div>
								</div>
								<!-- /.box-header -->
								<div class="box-body">
									<div class="wrap-grid h150">
										<script>createIBSheet("mySheet3", "100%", "100%");</script>
									</div>
									<!-- .wrap //-->
								</div>
								<!-- .box-body //-->
								<div class="box-footer right">
									<div class="btn-group mt5">
										<button type="button" class="btn btn-default btn-xs" id="lws_am_mnl_btn" onclick="javascript:doAction_mySheet3('insert')" style="display:none"><i class="fa fa-plus"></i>수기입력</button>
									</div>
										<button type="button" class="btn btn-primary btn-sm" id="lws_am_conn_btn" onclick="schAccConnPopup(3);" ><span class="txt">계정연결</span></button>
								</div>
								<!-- .box-footer //-->
							</div>
							<!-- 소송비용 및 소송회수  //-->
							<!-- 기타비용 및 기타회수  -->
							<div class="line br bl p10">
								<div class="box-header">
									<h5 class="box-title md">기타비용 및 기타회수</h5>
									<div class="btn-wrap ib">
									<%if("Y".equals(no1_hcnt)){%>
										<button type="button" class="btn btn-xs btn-normal" id="etc_am_conn_btn" onclick="schAccConnPopup(4);">
											<span class="txt">계정연결</span>
										</button>
									<%}%>
									</div>
									<div class="fr">
										<div class="form-group-sm ib fl">
											<label class="fl mr10"><i class="label label-texe cr">(C)</i>비용합계액</label> 
											<input type="hidden" id="etc_cst_am" name="etc_cst_am" /> 
											<input type="text" class="form-control text-right w130 ib" id="shw_etc_cst_am" readonly /> 원
										</div>
										<div class="form-group-sm ib fr ml20">
											<label class="fl mr10"><i class="label label-texe cb">(다)</i>회수합계액</label> 
											<input type="hidden" id="etc_wdr_am" name="etc_wdr_am" /> 
											<input type="text" class="form-control text-right w130 ib" id="shw_etc_wdr_am" readonly /> 원
										</div>
									</div>
								</div>
								<!-- /.box-header -->
								<div class="box-body">
									<div class="wrap-grid h150">
										<script>createIBSheet("mySheet4", "100%", "100%");</script>
									</div>
									<%-- .wrap --%>
								</div>
								<%-- .box-body --%>
								<div class="box-footer right">
									<div class="btn-group mt5">
										<button type="button" class="btn btn-default btn-xs" id="etc_am_mnl_btn" onclick="javascript:doAction_mySheet4('insert')" style="display:none"><i class="fa fa-plus"></i>수기입력</button>
									</div>
										<button type="button" class="btn btn-primary btn-sm" id="etc_am_conn_btn" onclick="schAccConnPopup(4);" ><span class="txt">계정연결</span></button>
								</div>
								<%-- .box-footer --%>
							</div>
							<%-- 기타비용 및 기타회수  --%>
							<%-- 총손실금액, 총회수금액 --%>
							<div class="bgyl line ba p10 md">
								<div class="form-group mb5 right">
									<label class="ib mr10">총손실금액
										<span>
											<i class="label label-texe cr">(A)</i> + <i class="label label-texe cr">(B)</i> + <i class="label label-texe cr">(C)</i>
										</span>
									</label> 
									<input type="hidden" id="tot_lssam" name="tot_lssam" /> 
									<input type="text" class="form-control input text-right ib w150" id="shw_tot_lssam" readonly /> 원
								</div>
								<div class="form-group mb5 right ">
									<label class="ib mr10">총회수금액
										<i class="label label-texe cb">(가)</i> + <i class="label label-texe cb">(나)</i> + <i class="label label-texe cb">(다)</i> + <i class="label label-texe cb">(라)</i></label> 
										<input type="hidden" id="tot_wdr_am" name="tot_wdr_am" /> 
										<input type="text" class="form-control input text-right ib w150" id="shw_tot_wdr_am" readonly /> 원
								</div>
								<div class="form-group right" style="display:none">
									<label class="ib mr10">총 비용<i class="label label-texe cb">(가)</i> + <i
											class="label label-texe cb">(나)</i> + <i class="label label-texe cb">(다)</i> +
										<i class="label label-texe cb">(라)</i></label>
									<input type="hidden" id="tot_am" name="tot_am" />
									<input type="text" class="form-control input text-right ib w150" id="shw_tot_am"
										readonly />원
								</div>
								<div class="form-group right mb0">
									<label class="ib mr10">순손실금액</label> 
									<input type="hidden" id="gu_lssam" name="gu_lssam" /> 
									<input type="text" class="form-control input text-right ib w150" id="shw_gu_lssam" readonly /> 원
								</div>
							</div>
							<%-- 총손실금액, 총회수금액 --%>
						</div>
						<%-- 재무정보 및 회계정보 --%>
						
						<%-- 분석 정보 --%>
						<h4 class="title">분석정보</h4>
						<div class="box box-search">
							<div class="wrap-search">
								<table>
									<colgroup>
										<col style="width: 150px" />
										<col style="width: 300px"/>
										<col style="width: 150px" />
										<col style="width: 300px"/>
									</colgroup>
									<tbody>
										<tr>
											<th><strong>손실형태</strong>
												<button type="button" class="btn btn-normal btn-xs btn-help" id="lshp_form_help_btn" onclick="$('#winHelp2').show();">
													<i class="fa fa-exclamation-circle"></i><span class="blind">HELP</span>
												</button>
											</th>
											<td>
												<div class="select">
													<select class="form-control" id="lshp_form_c" name="lshp_form_c">
														<option value="">선택</option>
														<%
															for (int i = 0; i < vLshpFormLst.size(); i++) {
																HashMap hMap = (HashMap) vLshpFormLst.get(i);
														%>
														<option value="<%=(String) hMap.get("intgc")%>"><%=(String) hMap.get("intg_cnm")%></option>
														<%
															}
														%>
													</select>
												</div>
											</td>
											<th><strong>손실상태</strong>
												<button type="button" class="btn btn-normal btn-xs btn-help" id="lshp_form_help_btn" onclick="$('#winHelp3').show();">
												<i class="fa fa-exclamation-circle"></i>
												<span class="blind">HELP</span></button>
											</th>
											<td>
												<div class="select">
													<select class="form-control" id="lshp_stsc" name="lshp_stsc">
														<option value="">선택</option>
														<%
															for (int i = 0; i < vLshpStscLst.size(); i++) {
																HashMap hMap = (HashMap) vLshpStscLst.get(i);
														%>
														<option value="<%=(String) hMap.get("intgc")%>"><%=(String) hMap.get("intg_cnm")%></option>
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
						</div>
						<div class="box-body">
							<div class="wrap-grid scroll h150">
								<script> createIBSheet("mySheet5", "100%", "100%"); </script>
							</div><!-- .wrap //-->
						</div><!-- .box-body //-->
						<!-- 분석 정보 //-->
						
						<!-- 경계리스크 정보 -->
						<h4 class="title md">경계리스크 정보</h4>
						<div class="box box-search mb30">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<th>신용리스크 여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="crrk_yn" name="crrk_yn">
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
											<th>신용 RWA 반영 여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="rwa_yn" name="rwa_yn" onchange="chk_rwa_yn_chg()">
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
											<th>신용 RWA반영 확인 고유번호</th>
										<td><input type="text" class="form-control" id="rwa_unq_no" name="rwa_unq_no" disabled/></td>
										</tr>
										<tr>
											<th>시장리스크 여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="mkrk_yn" name="mkrk_yn">
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
											<th>전략리스크 여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="strk_yn" name="strk_yn">
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
											<th>평판리스크 여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="fmrk_yn" name="fmrk_yn">
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
											<th>법률리스크 여부</th>
											<td>
												<div class="select">
													<select class="form-control" id="lgrk_yn" name="lgrk_yn">
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- 경계리스크 정보 //-->
					</form>
				</div>
				<!-- .p_wrap //-->
			</div>
			<!-- .p_body //-->
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="javascript:save('N')">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<!-- .p_foot //-->
			<!-- <button type="button" class="btn btn-normal btn-xs btn-help fix" onclick="$('#winHelp1').show();">
				<i class="fa fa-exclamation-circle"></i><span class="txt">HELP</span>
			</button> -->
			<button type="button" class="ico close fix btn-close">
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
	<%@ include file="../comm/AccConnP.jsp"%>
	<!-- 계정연결 공통 팝업 -->
	<%@ include file="../comm/OrgEmpInfP.jsp"%>
	<!-- 부서별직원 공통 팝업 -->

	<div id="winHelp1" class="popup modal">
		<iframe name="ifrHelp1" id="ifrHelp1" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/los/ORLS0104"></iframe>
	</div>
	<div id="winHelp2" class="popup modal">
		<iframe name="ifrHelp2" id="ifrHelp2" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/los/ORLS0106"></iframe>
	</div>
	<div id="winHelp3" class="popup modal">
		<iframe name="ifrHelp3" id="ifrHelp3" src="<%=System.getProperty("contextpath")%>/Jsp.do?path=/los/ORLS0107"></iframe>
	</div>



	<script>
		$(document).ready(function() {
			//열기
			$(".btn-open").click(function() {
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click(function() {
				$(".popup", parent.document).hide();
				parent.$("#ifrLossAdd").attr("src","about:blank");
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
			if (brc == "")
				init_flag = true;
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
	
			var f = document.ormsForm;
	
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "los");
			WP.setParameter("process_id", "ORLS010303");
	
			$("#ocu_brc").val(brc);
			$("#ocu_brnm").val(brnm);
			WP.setForm(f);
	
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
	
			//alert(inputData);
			//showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData, {
				success : function(result) {
					var rList = result.DATA;
					if (result != 'undefined') {
	
						$("#ocu_up_brc").val(rList[0].ocu_up_brc);
						$("#ocu_up_brnm").val(rList[0].ocu_up_brnm);
	
						$("#winBuseo").hide();
					}
				},
	
				complete : function(statusText, status) {
				},
	
				error : function(rtnMsg) {
					alert("영업영역,업무소관부서 로딩중 에러발생");
				}
			});
	
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
		// 채권관리부서검색 완료
		function bnd_amn_brc_popup() {
			schOrgPopup("bnd_amn_brnm", "bndAmnBrcSearchEnd");
			if ($("#bnd_amn_brnm").val() == "" && init_flag) {
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		function bndAmnBrcSearchEnd(brc, brnm) {
			$("#bnd_amn_brc").val(brc);
			$("#bnd_amn_brnm").val(brnm);
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
			if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
			schPrssPopup();
		}
	
		function prssSearchEnd(bsn_prss_c, bsn_prsnm
				, bsn_prss_c_lv1, bsn_prsnm_lv1
				, bsn_prss_c_lv2, bsn_prsnm_lv2
				, bsn_prss_c_lv3, bsn_prsnm_lv3){
			$("#bsn_prss_c").val(bsn_prss_c);
			$("#shw_bsn_prss_nm").val(
					bsn_prsnm_lv1 + " > " + bsn_prsnm_lv2 + " > " + bsn_prsnm_lv3
							+ " > " + bsn_prsnm);
	
			$("#winPrss").hide();
	
			function prss_remove(){
				$("#bsn_prss_c").val("");
				$("#shw_bsn_prss_nm").val("");
			}
			
		}
	
		// 손실사건유형검색 완료
		var HPN3_ONLY = true;
		var CUR_HPN_TPC = "";
	
		function hpn_popup() {
			CUR_HPN_TPC = $("#hpn_tpc").val();
			if (ifrHpn.cur_click != null)
				ifrHpn.cur_click();
			schHpnPopup();
		}
	
		function hpnSearchEnd(hpn_tpc, hpn_tpnm, hpn_tpc_lv1, hpn_tpnm_lv1,
				hpn_tpc_lv2, hpn_tpnm_lv2) {
			$("#hpn_tpc").val(hpn_tpc);
			$("#shw_hpn_tpnm").val(
					hpn_tpnm_lv1 + " > " + hpn_tpnm_lv2 + " > " + hpn_tpnm);
	
			$("#winHpn").hide();
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
	
		// 원인유형검색 완료
		var CAS3_ONLY = true;
		var CUR_CAS_TPC = "";
	
		function cas_popup() {
			CUR_CAS_TPC = $("#cas_tpc").val();
			if (ifrCas.cur_click != null)
				ifrCas.cur_click();
			schCasPopup();
		}
	
		function casSearchEnd(cas_tpc, cas_tpnm, cas_tpc_lv1, cas_tpnm_lv1,
				cas_tpc_lv2, cas_tpnm_lv2) {
			$("#cas_tpc").val(cas_tpc);
			$("#shw_cas_tpnm").val(
					cas_tpnm_lv1 + " > " + cas_tpnm_lv2 + " > " + cas_tpnm);
	
			$("#winCas").hide();
			//doAction('search');
		}
	
		// 영향유형검색 완료
		var IFN2_ONLY = true;
		var CUR_IFN_TPC = "";
	
		function ifn_popup() {
			CUR_IFN_TPC = $("#ifn_tpc").val();
			if (ifrIfn.cur_click != null)
				ifrIfn.cur_click();
			schIfnPopup();
		}
	
		function ifnSearchEnd(ifn_tpc, ifn_tpnm, ifn_tpc_lv1, ifn_tpnm_lv1) {
			$("#ifn_tpc").val(ifn_tpc);
			$("#shw_ifn_tpnm").val(ifn_tpnm_lv1 + " > " + ifn_tpnm);
	
			$("#winIfn").hide();
			//doAction('search');
		}
	
		//보고자 부서별직원조회 팝업 호출
		function orgEmpPopup() {
			schOrgEmpPopup("orgEmpSearchEnd");
			$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
		}
	
		//보고자 부서별직원검색 완료
		function orgEmpSearchEnd(eno, enm) {
			$("#rprr_eno").val(eno);
			$("#shw_rprr_nm").val(enm);
			$("#winBuseoEmp").hide();
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
</body>
</html>