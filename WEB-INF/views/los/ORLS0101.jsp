<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0101.jsp
 Program name : 손실사건 조회 및 등록
 Description  : LDM-01
 Programer    : 이규탁
 Date created : 2022.08.08
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%

DynaForm form = (DynaForm)request.getAttribute("form");
String role_id = (String)form.get("role_id"); //역할구분코드

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector lshpFormCLst = CommUtil.getCommonCode(request, "LSHP_FORM_C");
if(lshpFormCLst==null) lshpFormCLst = new Vector();
Vector lshpStscLst = CommUtil.getCommonCode(request, "LSHP_STSC");
if(lshpStscLst==null) lshpStscLst = new Vector();

Vector lshpDczStsDscTempLst = null;
if("nml".equals(role_id) || "nmlld".equals(role_id)){ //보고부서, 보고부서장
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC_NML");
}else if("orm".equals(role_id) || "ormld".equals(role_id)){ //ORM, ORM부서장
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC_ORM");
}else if("admn".equals(role_id) ){ //사건관리부서
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC_ADM");
}else{ //hcorm 
	lshpDczStsDscTempLst = CommUtil.getCommonCode(request, "LSHP_DCZ_STS_DSC");
}
if(lshpDczStsDscTempLst==null) lshpDczStsDscTempLst = new Vector();

Vector lshpDczStsDscLst = new Vector();
for(int i=0;i<lshpDczStsDscTempLst.size();i++){
	HashMap tempMap = (HashMap)lshpDczStsDscTempLst.get(i);
	String intg_cnm = (String)tempMap.get("intg_cnm");
	String intgc = (String)tempMap.get("intgc");
	
	boolean exist = false;
	for(int j=0;j<lshpDczStsDscLst.size();j++){
		HashMap dscMap = (HashMap)lshpDczStsDscLst.get(j);
		if(intg_cnm.equals((String)dscMap.get("intg_cnm"))){
			dscMap.put("intgc",(String)dscMap.get("intgc") + "','" + (String)tempMap.get("intgc")); //승인진행단계에서 따옴표 없앰
			exist = true;
			break;
		}
	}
	if(!exist){
		//tempMap.put("intgc","'"+(String)tempMap.get("intgc")+"'");
		tempMap.put("intgc",(String)tempMap.get("intgc")); //승인진행단계에서 따옴표 없앰
		lshpDczStsDscLst.add(tempMap.clone());
	}
}
System.out.println("lshpDczStsDscLst:\n"+lshpDczStsDscLst.toString());
HashMap hMapSession = (HashMap)request.getSession(true).getAttribute("infoH");

String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");  
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<script>
	$(document).ready(function(){
		document.getElementById('shw_btn').disabled = true;
		$(function() {	
			set_by_role($("#role_id").val());
		});//ready end	

		// ibsheet 초기화
		initIBSheet();
		document.getElementById('shw_btn').disabled = false;
	
	});

	<%
	if("hcorm".equals(role_id)){
	%>
	var ROLE_ID = "hcorm";
	$("#grp_org_c").ready(function() {
		
		$("#grp_org_c").change(function() {
			//보고 부서
			$("#rpt_brc").val("");
			$("#rpt_brnm").val(""); 
			//사건관리 부서
			$("#amn_brc").val("");
			$("#amn_brnm").val(""); 
			//발생 부서
			$("#ocu_brc").val("");
			$("#ocu_brnm").val(""); 
			//사건유형
			$("#hpn_tpc").val("");
			$("#hpn_tpnm").val("");
			//원인유형
			$("#cas_tpc").val("");
			$("#cas_tpnm").val("");
			//영향유형
			$("#ifn_tpc").val(""); 
			$("#shw_ifn_tpnm").val("");
			//이머징리스크유형
			$("#emrk_tpc").val(""); 
			$("#emrk_tpc_tpnm").val("");
			//승인 진행단계
			$("#lshp_dcz_sts_dsc").val(""); 

			if($("#grp_org_c").val()==""){ //전체
				$("#rpt_brnm").attr("disabled",true);
				$("#rpt_brnm_btn").attr("disabled",true);
				$("#amn_brnm").attr("disabled",true);
				$("#amn_brnm_btn").attr("disabled",true);
				$("#ocu_brnm").attr("disabled",true);
				$("#ocu_brnm_btn").attr("disabled",true);
				$("#hpn_tpnm").attr("disabled",true);
				$("#hpn_tpnm_btn").attr("disabled",true);
				$("#cas_tpnm").attr("disabled",true);
				$("#cas_tpnm_btn").attr("disabled",true);
				$("#shw_ifn_tpnm").attr("disabled",true);
				$("#shw_ifn_tpnm_btn").attr("disabled",true);
				$("#lshp_dcz_sts_dsc").attr("disabled",true);
				//$("#shw_btn").attr("disabled",true);
			}else{
				$("#rpt_brnm").attr("disabled",false);
				$("#rpt_brnm_btn").attr("disabled",false);
				$("#amn_brnm").attr("disabled",false);
				$("#amn_brnm_btn").attr("disabled",false);
				$("#ocu_brnm").attr("disabled",false);
				$("#ocu_brnm_btn").attr("disabled",false);
				$("#hpn_tpnm").attr("disabled",false);
				$("#hpn_tpnm_btn").attr("disabled",false);
				$("#cas_tpnm").attr("disabled",false);
				$("#cas_tpnm_btn").attr("disabled",false);
				$("#shw_ifn_tpnm").attr("disabled",false);
				$("#shw_ifn_tpnm_btn").attr("disabled",false);
				$("#lshp_dcz_sts_dsc").attr("disabled",false);
				$("#shw_btn").attr("disabled",false);
			}
		});
		$("#grp_org_c").trigger("change");
		
	});
	<%
	}
	%>
		
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
		initData.Cols = [
			{Header:"상태|상태",							Type:"Status",		MinWidth:30,Align:"Center",SaveName:"status", Hidden:true},
		 	{Header:"선택|선택",									Type:"CheckBox",	MinWidth:15,Align:"Left",SaveName:"ischeck"},
			{Header:"그룹기관코드|그룹기관코드",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"grp_org_c",Hidden:true, Edit:false, Wrap:true},
			{Header:"손실\n사건\n번호|손실\n사건\n번호",						Type:"Text",		MinWidth:50,Align:"Center",SaveName:"lshp_amnno",Edit:false, Wrap:true},
			{Header:"사건발생법인|사건발생법인",				Type:"Text",		MinWidth:150,Align:"Center",SaveName:"grp_orgnm",Hidden:true ,Edit:false, Wrap:true},			
			{Header:"발생부서코드|발생부서코드",				Type:"Text",		MinWidth:150,Align:"Center",SaveName:"ocu_brc",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건발생부서/\n영업점|사건발생부서/\n영업점",	Type:"Text",		MinWidth:150,Align:"Center",SaveName:"ocu_brnm",Edit:false, Wrap:true},
			{Header:"보고자개인번호|보고자개인번호",			Type:"Text",			MinWidth:150,Align:"Left",SaveName:"rprr_eno",Hidden:true, Edit:false, Wrap:true},
			{Header:"보고부서코드|보고부서코드",				Type:"Text",		MinWidth:150,Align:"Left",SaveName:"rpt_brc",Hidden:true, Edit:false, Wrap:true},
			{Header:"보고부서|보고부서",						Type:"Text",	MinWidth:150,Align:"Center",SaveName:"rpt_brnm",Edit:false, Wrap:true},
			{Header:"채권관리부서코드|채권관리부서코드",			Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bnd_amn_brc",Hidden:true, Edit:false, Wrap:true},
			{Header:"채권관리부서|채권관리부서",				Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bnd_amn_brnm",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건관리부서코드|사건관리부서코드",			Type:"Text",		MinWidth:150,Align:"Left",SaveName:"amn_brc",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건관리부서|사건관리부서",				Type:"Text",		MinWidth:150,Align:"Center",SaveName:"amn_brnm",Edit:false, Wrap:true},
			{Header:"사건제목|사건제목",						Type:"Text",		MinWidth:350,Align:"Left",SaveName:"lshp_tinm",Edit:false, Wrap:true, EditLen:200},
			{Header:"사건내용|사건내용",						Type:"Text",		MinWidth:350,Align:"Left",SaveName:"ocu_dept_dtl_cntn",Hidden:true, Edit:false, Wrap:true, EditLen:200},
			{Header:"사건내용|관리부서",						Type:"Text",		MinWidth:350,Align:"Left",SaveName:"amn_dept_dtl_cntn",Hidden:true, Edit:false, Wrap:true, EditLen:200},
			{Header:"사건내용|ORM",						Type:"Text",		MinWidth:350,Align:"Left",SaveName:"oprk_amn_dtl_cntn",Hidden:true, Edit:false, Wrap:true, EditLen:200},
			{Header:"일자|사건발생\n일자",							Type:"Text",		MinWidth:80,Align:"Center",SaveName:"ocu_dt",Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
			{Header:"일자|사건발견\n일자",							Type:"Text",		MinWidth:80,Align:"Center",SaveName:"dcv_dt",Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
			{Header:"일자|사건등록\n일자",						Type:"Text",		MinWidth:80,Align:"Center",SaveName:"fir_inp_dt",Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
			{Header:"일자|사건종료\n일자",						Type:"Text",		MinWidth:80,Align:"Center",SaveName:"end_dt",Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
			{Header:"일자|최초회계\n처리\n일자",						Type:"Text",		MinWidth:80,Align:"Center",SaveName:"fir_acg_prc_dt",Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
			{Header:"일자|최종변경\n일자",						Type:"Text",		MinWidth:80,Align:"Center",SaveName:"lschg_dt",Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
			{Header:"보험청구여부|보험청구여부",				Type:"Text",		MinWidth:80,Align:"Center",SaveName:"isr_rqs_yn",Edit:false, Wrap:true},
			{Header:"인사관리번호|인사관리번호",				Type:"Text",		MinWidth:100,Align:"Left",SaveName:"hur_amnno",Hidden:true, Edit:false, Wrap:true},
			{Header:"금액|피해예상",						Type:"Int",			MinWidth:100,Align:"Right",SaveName:"oprk_ham_xpc_am",Hidden:true, Edit:false, Wrap:true},
			{Header:"금액|손실비용",						Type:"Int",			MinWidth:100,Align:"Right",SaveName:"lss_cst_am",Hidden:true, Edit:false, Wrap:true},
			{Header:"금액|소송비용",						Type:"Int",			MinWidth:100,Align:"Right",SaveName:"lws_cst_am",Hidden:true, Edit:false, Wrap:true},
			{Header:"금액|소송회수",						Type:"Int",			MinWidth:100,Align:"Right",SaveName:"lws_wdr_am",Hidden:true, Edit:false, Wrap:true},
			{Header:"금액|기타비용",						Type:"Int",			MinWidth:100,Align:"Right",SaveName:"etc_cst_am",Hidden:true, Edit:false, Wrap:true},
			{Header:"금액|기타회수",						Type:"Int",			MinWidth:100,Align:"Right",SaveName:"oprk_etc_wdr_am",Hidden:true, Edit:false, Wrap:true},
			{Header:"금액|총손실금액",							Type:"Int",			MinWidth:100,Align:"Right",SaveName:"tot_lssam",Edit:false, Wrap:true},
			{Header:"금액|총회수금액",							Type:"Int",			MinWidth:100,Align:"Right",SaveName:"tot_wdr_am",Edit:false, Wrap:true},
			{Header:"금액|보험회수금액",							Type:"Int",			MinWidth:100,Align:"Right",SaveName:"oprk_isr_wdr_am",Edit:false, Wrap:true},
			{Header:"금액|총비용",							Type:"Int",			MinWidth:100,Align:"Right",SaveName:"tot_am",Edit:false, Wrap:true},
			{Header:"금액|보험전순손실금액",						Type:"Int",			MinWidth:100,Align:"Right",SaveName:"bf_isr_wdr_guls_am",Edit:false, Wrap:true},
			{Header:"금액|순손실금액",							Type:"Int",			MinWidth:100,Align:"Right",SaveName:"gu_lssam",Edit:false, Wrap:true},
			{Header:"소송발생여부|소송발생여부",						Type:"Text",		MinWidth:80,Align:"Center",SaveName:"lws_yn",Hidden:false, Edit:false, Wrap:true},
			{Header:"경계리스크|RWA",						Type:"Text",		MinWidth:30,Align:"Center",SaveName:"rwa_yn",Hidden:true, Edit:false, Wrap:true},
			{Header:"경계리스크|신용RWA확인 고유번호",						Type:"Text",		MinWidth:30,Align:"Center",SaveName:"rwa_unq_no",Hidden:true, Edit:false, Wrap:true},
			{Header:"경계리스크|신용",						Type:"Text",		MinWidth:30,Align:"Center",SaveName:"crrk_yn",Hidden:true,Edit:false, Wrap:true},
			{Header:"경계리스크|시장",						Type:"Text",		MinWidth:30,Align:"Center",SaveName:"mkrk_yn",Hidden:true,Edit:false, Wrap:true},
			{Header:"경계리스크|법률",						Type:"Text",		MinWidth:30,Align:"Center",SaveName:"lgrk_yn",Hidden:true,Edit:false, Wrap:true},
			{Header:"경계리스크|전략",						Type:"Text",		MinWidth:30,Align:"Center",SaveName:"strk_yn",Hidden:true,Edit:false, Wrap:true},
			{Header:"경계리스크|평판",						Type:"Text",		MinWidth:30,Align:"Center",SaveName:"fmrk_yn",Hidden:true,Edit:false, Wrap:true},
			{Header:"업무프로세스코드|LV1",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prss_c_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"업무프로세스명|LV1",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prsnm_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"업무프로세스코드|LV2",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prss_c_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"업무프로세스명|LV2",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prsnm_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"업무프로세스코드|LV3",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prss_c_lv3",Hidden:true, Edit:false, Wrap:true},
			{Header:"업무프로세스명|LV3",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prsnm_lv3",Hidden:true, Edit:false, Wrap:true},
			{Header:"업무프로세스코드|LV4",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prss_c_lv4",Hidden:true, Edit:false, Wrap:true},
			{Header:"업무프로세스명|LV4",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"bsn_prsnm_lv4",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건유형코드|LV1",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"hpn_tpc_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건유형|LV1",						Type:"Text",		MinWidth:100,Align:"Left",SaveName:"hpn_tpnm_lv1",Hidden:true, Edit:false, Wrap:true},//57
			{Header:"사건유형코드|LV2",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"hpn_tpc_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건유형|LV2",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"hpn_tpnm_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건유형코드|LV3",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"hpn_tpc_lv3",Hidden:true, Edit:false, Wrap:true},
			{Header:"사건유형|LV3",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"hpn_tpnm_lv3",Hidden:true, Edit:false, Wrap:true},
			{Header:"원인유형코드|LV1",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"cas_tpc_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"원인유형|LV1",						Type:"Text",		MinWidth:100,Align:"Left",SaveName:"cas_tpnm_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"원인유형코드|LV2",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"cas_tpc_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"원인유형|LV2",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"cas_tpnm_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"원인유형코드|LV3",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"cas_tpc_lv3",Hidden:true, Edit:false, Wrap:true},
			{Header:"원인유형|LV3",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"cas_tpnm_lv3",Hidden:true, Edit:false, Wrap:true},
			{Header:"영향유형코드|LV1",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"ifn_tpc_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"영향유형|LV1",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"ifn_tpnm_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"영향유형코드|LV2",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"ifn_tpc_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"영향유형|LV2",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"ifn_tpnm_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"이머징리스크코드|LV1",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"emrk_tpc_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"이머징리스크코드|LV2",						Type:"Text",		MinWidth:60,Align:"Left",SaveName:"emrk_tpc_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"이머징리스크|LV1",						Type:"Text",		MinWidth:100,Align:"Left",SaveName:"emrk_tpnm_lv1",Hidden:true, Edit:false, Wrap:true},
			{Header:"이머징리스크|LV2",						Type:"Text",		MinWidth:200,Align:"Left",SaveName:"emrk_tpnm_lv2",Hidden:true, Edit:false, Wrap:true},
			{Header:"손실형태코드|손실형태코드",				Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lshp_form_c",Hidden:true, Edit:false, Wrap:true},
			{Header:"손실형태|손실형태",						Type:"Text",		MinWidth:100,Align:"Center",SaveName:"lshp_form_cnm",Hidden:true,Edit:false, Wrap:true},
			{Header:"손실상태코드|손실상태코드",				Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lshp_stsc",Hidden:true, Edit:false, Wrap:true},
			{Header:"손실상태|손실상태",						Type:"Text",		MinWidth:100,Align:"Center",SaveName:"lshp_stscnm",Hidden:true,Edit:false, Wrap:true},
			{Header:"진행단계코드|진행단계코드",				Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lshp_dcz_sts_dsc",Hidden:true, Edit:false, Wrap:true},
			{Header:"진행단계|진행단계",						Type:"Text",		MinWidth:100,Align:"Center",SaveName:"lshp_dcz_stscnm",Hidden:true,Edit:false, Wrap:true},
			{Header:"손실발생채널내용|손실발생채널내용",			Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lsoc_chan_cntn",Hidden:true, Edit:false, Wrap:true},
			{Header:"손실사건관련상품명|손실사건관련상품명",		Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lshp_rel_wrsnm",Hidden:true, Edit:false, Wrap:true},
			{Header:"공통손실사건관리번호|공통손실사건관리번호",	Type:"Text",		MinWidth:150,Align:"Left",SaveName:"conm_lshp_amnno",Hidden:true, Edit:false, Wrap:true},
			
			{Header:"소송정보|소송심급구분코드",				Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lwsjdg_dsc",Hidden:true, Edit:false, Wrap:true},
			{Header:"소송정보|소송심",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lwsjdg_dscnm",Hidden:true, Edit:false, Wrap:true},
			{Header:"소송정보|소송종결여부",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lws_tmnt_yn",Hidden:true, Edit:false, Wrap:true},
			{Header:"소송정보|소송결과코드",					Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lws_rzt_c",Hidden:true, Edit:false, Wrap:true},
			{Header:"소송정보|소송결과",						Type:"Text",		MinWidth:150,Align:"Left",SaveName:"lws_rzt_cnm",Hidden:true, Edit:false, Wrap:true},
			{Header:"공통손실개수|공통손실개수",				Type:"Text",		MinWidth:80,Align:"Left",SaveName:"comn_amnno_cnt",Hidden:true, Edit:false, Wrap:true},
			{Header:"최근사건관리부서코드|최근사건관리부서코드",		Type:"Text",		MinWidth:80,Align:"Left",SaveName:"max_amn_brc",Hidden:true, Edit:false, Wrap:true},
			{Header:"보고자명|보고자명",		Type:"Text",		MinWidth:80,Align:"Left",SaveName:"rprr_enm",Hidden:true, Edit:false, Wrap:true},
			{Header:"최종회계처리일|최종회계처리일",		Type:"Text",		MinWidth:80,Align:"Left",SaveName:"lst_acg_prc_dt",Hidden:true, Edit:false, Wrap:true},
			{Header:"최초손실계정코드|최초손실계정코드",		Type:"Text",		MinWidth:80,Align:"Left",SaveName:"fir_lss_acg_accc",Hidden:true, Edit:false, Wrap:true}			
		];
		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		mySheet.SetCountPosition(3);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		$("#shw_btn").attr("disabled",true);
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
		//헤더기능 해제
		mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
		
		//doAction('search');
		
	}
	
	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		if(mySheet.GetDataFirstRow()<0) return;
		if(Row >= mySheet.GetDataFirstRow()){
			$("#lshp_amnno").val(mySheet.GetCellValue(Row,"lshp_amnno"));
			$("#comn_amnno_cnt").val(mySheet.GetCellValue(Row,"comn_amnno_cnt"));
			doAction('mod');
			
		}
	}
	
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		//alert(Row);
		if(Row >= mySheet.GetDataFirstRow()){
			$("#lshp_amnno").val(mySheet.GetCellValue(Row,"lshp_amnno"));
			$("#comn_amnno_cnt").val(mySheet.GetCellValue(Row,"comn_amnno_cnt"));
		}
	}
	
	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				
	var hofc_bizo_dsc = <%=hofc_bizo_dsc%>;
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {
		switch(sAction) {
			case "search":  //데이터 조회
				//var opt = { CallBack : DoSearchEnd };
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("los");
				$("form[name=ormsForm] [name=process_id]").val("ORLS010102");
				
				if($("#losmsr_yn").val()=="n"){	//측정대상손실사건조회시엔 st_dt에 있는값으로 조회
					ormsForm.st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
					ormsForm.ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");
				}
				
				if(ormsForm.txt_st_am.value!=""){
					ormsForm.st_am.value = ormsForm.txt_st_am.value;
				}else{
					ormsForm.st_am.value = "";
				}
				if(ormsForm.txt_ed_am.value!=""){
					ormsForm.ed_am.value = ormsForm.txt_ed_am.value;
				}else{
					ormsForm.ed_am.value = "";
				}
			
				
				
				if($("#crrk_yn").is(":checked")){ormsForm.sch_crrk_yn.value = "Y"}else{ormsForm.sch_crrk_yn.value = ""}
				if($("#mkrk_yn").is(":checked")){ormsForm.sch_mkrk_yn.value = "Y"}else{ormsForm.sch_mkrk_yn.value = ""}
				if($("#lgrk_yn").is(":checked")){ormsForm.sch_lgrk_yn.value = "Y"}else{ormsForm.sch_lgrk_yn.value = ""}
				if($("#strk_yn").is(":checked")){ormsForm.sch_strk_yn.value = "Y"}else{ormsForm.sch_strk_yn.value = ""}
				if($("#fmrk_yn").is(":checked")){ormsForm.sch_fmrk_yn.value = "Y"}else{ormsForm.sch_fmrk_yn.value = ""}
				
				
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
			case "add":		//신규등록 팝업
				showLoadingWs();
				//$("#ifrLossAdd").attr("src","about:blank");
				$("#winLossAdd").show();
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="los";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORLS010301";
				f.target = "ifrLossAdd";
				f.submit();
				break; 
			case "mod":		//수정 팝업
				if($("#lshp_amnno").val() == "" || $("#comn_amnno_cnt").val() == ""){
					alert("대상 손실사건을 선택하세요.");
					return;
				}else if($("#comn_amnno_cnt").val()!="1"){
					showLoadingWs();
					$("#winCommMod").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="los";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORLS010901";
					f.target = "ifrCommMod";
					f.submit();
				}else if($("#comn_amnno_cnt").val()=="1"){
					showLoadingWs();
					//$("#ifrLossMod").attr("src","about:blank");
					$("#winLossMod").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="los";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORLS010201";
					f.target = "ifrLossMod";
					f.submit();
				}
				break; 
			case "del":		//삭제 처리
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							cnt++;
						}
					}
				}
				if(cnt==0){
					alert("삭제대상 사건을 선택하세요.");
					
					return;
				}else{
					if(!confirm("선택한 손실사건을 삭제 하시겠습니까?")) return;
					mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS010104",{Quest:0});
				}
				break; 
			case "reportOrm":		//상신 처리
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							if(mySheet.GetCellValue(i, "rpt_brc") == ""){
								alert("보고부서가 입력하지 않았습니다.");
								return;
							}if(mySheet.GetCellValue(i, "amn_brc") == ""){
								alert("사건관리부서가 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "bnd_amn_brc") == ""){
								alert("채권관리부서가 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "lshp_tinm") == ""){
								alert("사건제목을 입력하지 않았습니다.");
								return;
							} else if(mySheet.GetCellValue(i, "ocu_dept_dtl_cntn") == ""){
								alert("사건내용을 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "hur_amnno") == ""){
								alert("인사부관리번호를 입력하지 않았습니다.");
								return;
							} else if(mySheet.GetCellValue(i, "tot_lssam") == "0"){
								alert("총손실금액을 입력하지 않았습니다.");
								return; hur_amnno
							}else if(mySheet.GetCellValue(i, "ocu_dt") == ""){
								alert("발생일자를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "dcv_dt") == ""){
								alert("발견일자를 입력하지 않았습니다.");
								return;
							}/* else if(mySheet.GetCellValue(i, "cas_tpc_lv3") == ""){
								alert("원인유형을 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "hpn_tpc_lv3") == ""){
								alert("사건유형을 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "ifn_tpc_lv2") == ""){
								alert("영향유형을 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "emrk_tpc_lv2") == ""){
								alert("이머징리스크유형을 입력하지 않았습니다.");
								return;
							} */else if(mySheet.GetCellValue(i, "lshp_form_c") == ""){
								alert("손실형태를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "lshp_stsc") == ""){
								alert("손실상태를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "rwa_yn") == ""){
								alert("신용RWA 여부를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "rwa_yn") == "Y" && mySheet.GetCellValue(i, "rwa_unq_no") == ""){
								alert("신용RWA확인 고유 번호를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "crrk_yn") == ""){
								alert("신용리스크여부를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "mkrk_yn") == ""){
								alert("시장리스크여부를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "lgrk_yn") == ""){
								alert("법률리스크여부를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "strk_yn") == ""){
								alert("전략리스크여부를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "fmrk_yn") == ""){
								alert("평판리스크여부를 입력하지 않았습니다.");
								return;
							}
							else{
								cnt++;
							}
						}
					}
				}
				if(cnt==0){
					alert("상신대상 사건을 선택하세요.");
					
					return;
				}else{
					$("#number").val("1");
					app_rej();
				}	
				break; 
			case "rejectOrmld":		//반려 처리
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							cnt++;
						}
					}
				}
				if(cnt==0){
					alert("반려대상 사건을 선택하세요.");
					
					return;
				}else{
					$("#number").val("2");
					app_rej();
				}	
				break; 
			case "apprvOrmld":		//승인 처리
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							cnt++;
						}
					}
				}
				if(cnt==0){
					alert("승인대상 사건을 선택하세요.");
					
					return;
				}else{
					$("#number").val("1");
					app_rej();
				}
				break; 
			case "reportNml":		//등록부서결재상신(일반) 처리
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							if(mySheet.GetCellValue(i, "rpt_brc") == ""){
								alert("보고부서가 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "bnd_amn_brc") == ""){
								alert("채권관리부서가 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "lshp_tinm") == ""){
								alert("사건제목을 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "ocu_dept_dtl_cntn") == ""){
								alert("사건내용을 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "tot_lssam") == "0"){
								alert("총손실금액을 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "ocu_dt") == ""){
								alert("발생일자를 입력하지 않았습니다.");
								return;
							}else if(mySheet.GetCellValue(i, "dcv_dt") == ""){
								alert("발견일자를 입력하지 않았습니다.");
								return;
							}
							else{
								cnt++;
							}
						}
					}
				}
				if(cnt==0){
					alert("승인대상 사건을 선택하세요.");
					
					return;
				}else{
					$("#number").val("1");
					app_rej();
				}
				break; 						
			case "rejectNmlld":		
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							cnt++;
						}
					}
				}
				if(cnt==0){
					alert("반려대상 사건을 선택하세요.");
					
					return;
				}else{
					$("#number").val("2");
					app_rej();
				}
				break; 
			case "apprvNmlld":		//등록부서장 승인 처리 2020-09-28추가
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							cnt++;
						}
					}
				}
				if(cnt==0){
					alert("승인대상 사건을 선택하세요.");
					
					return;
				}else{
					$("#number").val("1");
					app_rej();
				}					
				break; 
			case "reportAdmn":		//등록완료(관리부서) 처리
				var cnt = 0;
				if(mySheet.GetDataFirstRow()>0){
					for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							cnt++;
						}
					}
				}
				if(cnt==0){
					alert("등록완료대상 사건을 선택하세요.");
					
					return;
				}else{
					$("#number").val("1");
					app_rej();
				}		
				break; 
			case "down2excel":
				var role_id = $("#role_id").val();
				var excel_params  = "";
				if(role_id=="orm"||role_id=="ormld"){
					excel_params = {FileName:"손실사건조회.xlsx", Merge:"1", DownCols:"3|6|9|13|14|18|19|20|21|22|23|24|32|33|34|35|36|37|38|39|41|42|75|77|79"}
				}else if(role_id=="admn"){
					excel_params = {FileName:"손실사건조회.xlsx", Merge:"1", DownCols:"3|6|9|13|14|18|19|20|21|22|23|24|32|33|34|35|36|37|38"}
				}else if(role_id=="nml"||role_id=="nmlld"){
					excel_params = {FileName:"손실사건조회.xlsx", Merge:"1", DownCols:"3|6|9|13|14|18|19|20|21|22|23|24|32|33|34|35|36|37|38"}
				}
				mySheet.Down2Excel(excel_params);

				break;
		}
	}
	
	function app_rej(){
		var f = document.ormsForm;
		var com = true;
		var html = "";
		var number = $("#number").val();
		var role_id = $("#role_id").val();
		
		if(mySheet.GetDataFirstRow()>0){
			alert(mySheet.GetDataFirstRow());
			for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
				if(role_id=="ormld"){
					if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")=="05"){
						if(number=="1"){
							html += "<input type='hidden' id='status' name='status' value='"+mySheet.GetCellValue(i, "status")+"' >";
							html += "<input type='hidden' id='hd_lshp_amnno' name='hd_lshp_amnno' value='"+mySheet.GetCellValue(i, "lshp_amnno")+"' >";
							html += "<input type='hidden' id='hd_lshp_dcz_sts_dsc' name='hd_lshp_dcz_sts_dsc' value='06' >";
							html += "<input type='hidden' id='hd_rtn_yn' name='hd_rtn_yn' value='N' >";
						}else{
							html += "<input type='hidden' id='status' name='status' value='"+mySheet.GetCellValue(i, "status")+"' >";
							html += "<input type='hidden' id='hd_lshp_amnno' name='hd_lshp_amnno' value='"+mySheet.GetCellValue(i, "lshp_amnno")+"' >";
							html += "<input type='hidden' id='hd_lshp_dcz_sts_dsc' name='hd_lshp_dcz_sts_dsc' value='04' >";
							html += "<input type='hidden' id='hd_rtn_yn' name='hd_rtn_yn' value='Y' >";
						}
					}else  if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")!="05"){
						com = false;
						alert("승인대상이 아닌(상신완료 상태가 아닌) 사건이 있습니다.");
						
						return;
					}
				}else if(role_id=="orm"){
					if(mySheet.GetCellValue(i, "ischeck")=="1" && (mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")=="04" ) ){
						html += "<input type='hidden' id='status' name='status' value='"+mySheet.GetCellValue(i, "status")+"' >";
						html += "<input type='hidden' id='hd_lshp_amnno' name='hd_lshp_amnno' value='"+mySheet.GetCellValue(i, "lshp_amnno")+"' >";
						html += "<input type='hidden' id='hd_lshp_dcz_sts_dsc' name='hd_lshp_dcz_sts_dsc' value='05' >";
					}else if(mySheet.GetCellValue(i, "ischeck")=="1" && (mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")=="04")){
						com = false;
						alert("검토중이 아닌 사건이 있습니다.");
						
						return;
					}
				}else if(role_id=="nml"){
					if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")=="01"){
						html += "<input type='hidden' id='status' name='status' value='"+mySheet.GetCellValue(i, "status")+"' >";
						html += "<input type='hidden' id='hd_lshp_amnno' name='hd_lshp_amnno' value='"+mySheet.GetCellValue(i, "lshp_amnno")+"' >";
						html += "<input type='hidden' id='hd_lshp_dcz_sts_dsc' name='hd_lshp_dcz_sts_dsc' value='02' >";
					}else if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")!="01"){
						com = false;
						alert("승인대상이 아닌 사건이 있습니다."); 
						
						return;
					}
				}else if(role_id=="nmlld"){
					if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")=="02"){
						if(number=="1"){
							html += "<input type='hidden' id='status' name='status' value='"+mySheet.GetCellValue(i, "status")+"' >";
							html += "<input type='hidden' id='hd_lshp_amnno' name='hd_lshp_amnno' value='"+mySheet.GetCellValue(i, "lshp_amnno")+"' >";
							html += "<input type='hidden' id='hd_lshp_dcz_sts_dsc' name='hd_lshp_dcz_sts_dsc' value='03' >";
							html += "<input type='hidden' id='hd_rtn_yn' name='hd_rtn_yn' value='N' >";
						}else{
							html += "<input type='hidden' id='status' name='status' value='"+mySheet.GetCellValue(i, "status")+"' >";
							html += "<input type='hidden' id='hd_lshp_amnno' name='hd_lshp_amnno' value='"+mySheet.GetCellValue(i, "lshp_amnno")+"' >";
							html += "<input type='hidden' id='hd_lshp_dcz_sts_dsc' name='hd_lshp_dcz_sts_dsc' value='01' >";
							html += "<input type='hidden' id='hd_rtn_yn' name='hd_rtn_yn' value='Y' >";
						}
					}else  if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")!="02"){
						com = false;
						alert("승인대상이 아닌(상신완료 상태가 아닌) 사건이 있습니다.");
						
						return;
					}
				}else if(role_id=="admn"){
					if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")=="07"){
						html += "<input type='hidden' id='status' name='status' value='"+mySheet.GetCellValue(i, "status")+"' >";
						html += "<input type='hidden' id='hd_lshp_amnno' name='hd_lshp_amnno' value='"+mySheet.GetCellValue(i, "lshp_amnno")+"' >";
						html += "<input type='hidden' id='hd_lshp_dcz_sts_dsc' name='hd_lshp_dcz_sts_dsc' value='08' >";
					}else if(mySheet.GetCellValue(i, "ischeck")=="1" && mySheet.GetCellValue(i, "lshp_dcz_sts_dsc")!="07"){
						com = false;
						alert("승인대상이 아닌 사건이 있습니다."); 
						
						return;
					}
				}
			}
		}
		
		loss_html.innerHTML = html;
		
		if(com){
			if(!confirm("저장하시겠습니까?")) return;

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
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("완료 되었습니다.");
							doAction("search");
							
							removeLoadingWs();
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
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
	}
	
	function commAdd(){
		var reg_ready = true;
		var html = "";
		var count = 0;
		
		for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
			if(mySheet.GetCellValue(i, "ischeck")=="1"){
				if(mySheet.GetCellValue(i, "comn_amnno_cnt")!="1"){
					alert((i-1)+"행은 이미 공통손실로 등록 되어있습니다.");
					
					reg_ready = false;
					
					return;
				}
				
			}
		}
		
		for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
			if(mySheet.GetCellValue(i, "ischeck")=="1"){
				html += "<input type='hidden' id='hd_lshp_amnno' 	name='hd_lshp_amnno' 	value='"+mySheet.GetCellValue(i, "lshp_amnno")+"'>";			//사건관리번호
				html += "<input type='hidden' id='hd_lshp_tinm' 	name='hd_lshp_tinm' 	value='"+mySheet.GetCellValue(i, "lshp_tinm")+"'>";				//사건제목
				html += "<input type='hidden' id='shw_tot_lssam' 	name='shw_tot_lssam' 	value='"+mySheet.GetCellValue(i, "tot_lssam")+"'>";
				html += "<input type='hidden' id='shw_lss_cst_am' 	name='shw_lss_cst_am' 	value='"+mySheet.GetCellValue(i, "lss_cst_am")+"'>";
				html += "<input type='hidden' id='shw_oprk_isr_wdr_am' 	name='shw_oprk_isr_wdr_am' 	value='"+mySheet.GetCellValue(i, "oprk_isr_wdr_am")+"'>";
				html += "<input type='hidden' id='shw_lws_cst_am' 	name='shw_lws_cst_am' 	value='"+mySheet.GetCellValue(i, "lws_cst_am")+"'>";
				html += "<input type='hidden' id='shw_lws_wdr_am' 	name='shw_lws_wdr_am' 	value='"+mySheet.GetCellValue(i, "lws_wdr_am")+"'>";
				html += "<input type='hidden' id='shw_etc_cst_am' 	name='shw_etc_cst_am' 	value='"+mySheet.GetCellValue(i, "etc_cst_am")+"'>";
				html += "<input type='hidden' id='shw_oprk_etc_wdr_am' 	name='shw_oprk_etc_wdr_am' 	value='"+mySheet.GetCellValue(i, "oprk_etc_wdr_am")+"'>";
				html += "<input type='hidden' id='shw_tot_wdr_am' 	name='shw_tot_wdr_am' 	value='"+mySheet.GetCellValue(i, "tot_wdr_am")+"'>";
				html += "<input type='hidden' id='shw_gu_lssam' 	name='shw_gu_lssam' 	value='"+mySheet.GetCellValue(i, "gu_lssam")+"'>";
				count++
			}
		}
		
		$("form[name=ormsForm] [id=register]").html(html);
		if($("#hd_lshp_amnno").val()==null){
			alert("손실사건을 선택해주세요.");
			reg_ready = false;
			return;
		}
		
		if(count==1){
			alert("손실사건을 2개이상 선택해주세요.");
			reg_ready = false;
			return;
		}
		
		if(reg_ready){
			showLoadingWs();
			//$("#ifrLossAdd").attr("src","about:blank");
			$("#winCommAdd").show();
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="los";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORLS010801";
			f.target = "ifrCommAdd";
			f.submit();
		}
	}			

	
	function mySheet_OnSearchEnd(code, message) {

		if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}else{
			if($("#losmsr_yn").val()=="y"){		//측정대상손실사건 조회 후엔 일자, 측정대상손실사건yn 원위치
				$("#st_dt").val("");
				$("#ed_dt").val("");
				$("#losmsr_yn").val("n");
			}
		}
	}
	
	function mySheet_OnSaveEnd(code, msg) {

	    if(code >= 0) {
	        alert("완료 되었습니다.");  // 저장 성공 메시지
	        doAction("search");      
	    } else {
	        alert("실패했습니다."); // 저장 실패 메시지
	    }
	}

	function set_by_role(role){ //권한별 조회조건 선택
		if(role=='orm' || role=='ormld'){
			document.getElementById('rpt_brnm').disabled = false;	
			document.getElementById('rpt_brnm_btn').disabled = false;
			document.getElementById('obj_tr_orm').style.display = 'table-row';
			document.getElementById('obj_tr1_orm').style.display = 'table-row';
			//document.getElementById('obj_tr2_orm').style.display = 'table-row';
			//document.getElementById('obj_tr3_orm').style.display = 'table-row';
			document.getElementById('obj_tr4_orm').style.display = 'table-row';
			document.getElementById('obj_tr5_orm').style.display = 'table-row';
			mySheet.SetColHidden([
				{Col: 39, Hidden:0},
			    {Col: 41, Hidden:0},
			    {Col: 42, Hidden:0},
			    //{Col: 54, Hidden:0},
			    //{Col: 60, Hidden:0},
			    //{Col: 66, Hidden:0},
			    //{Col: 70, Hidden:0},
			    {Col: 75, Hidden:0},
			    {Col: 77, Hidden:0},
			    {Col: 79, Hidden:0},
			]);
		}else if(role=='nml'){
			document.getElementById('rpt_brc').value = '<%=(String)hMapSession.get("brc") %>';	
			document.getElementById('rpt_brnm').value = '<%=(String)hMapSession.get("brnm") %>';	
		}else if(role=='nmlld'){
			document.getElementById('rpt_brc').value = '<%=(String)hMapSession.get("brc") %>';	
			document.getElementById('rpt_brnm').value = '<%=(String)hMapSession.get("brnm") %>';	
		}else if(role=='admn'){
			document.getElementById('rpt_brnm').disabled = false;	
			document.getElementById('rpt_brnm_btn').disabled = false;
			document.getElementById('amn_brnm').disabled = true;	
			document.getElementById('amn_brnm_btn').disabled = true;
			document.getElementById('amn_brc').value = '<%=(String)hMapSession.get("brc") %>';	
			document.getElementById('amn_brnm').value = '<%=(String)hMapSession.get("brnm") %>';	
		}
	}

	function set_dt_knd(){
		if($("#dt_knd").val()==""){
			$("#st_dt").val("");
			$("#txt_st_dt").val("");
			$("#ed_dt").val("");
			$("#txt_ed_dt").val("");
			document.getElementById('txt_st_dt_btn').disabled = true;
			document.getElementById('txt_ed_dt_btn').disabled = true;
		}else{
			document.getElementById('txt_st_dt_btn').disabled = false;
			document.getElementById('txt_ed_dt_btn').disabled = false;
		}
	}
	function set_am_knd(){
		if($("#am_knd").val()==""){
			$("#st_am").val("");
			$("#txt_st_am").val("");
			$("#ed_am").val("");
			$("#txt_ed_am").val("");
			document.getElementById('txt_st_am').disabled = true;
			document.getElementById('txt_ed_am').disabled = true;
		}else{
			document.getElementById('txt_st_am').disabled = false;
			document.getElementById('txt_ed_am').disabled = false;
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
				<input type="hidden" id="lshp_amnno" name="lshp_amnno"/>
				<input type="hidden" id="comn_amnno_cnt" name="comn_amnno_cnt" />
				<input type="hidden" id="role_id" name="role_id" value="<%=role_id %>" />
				<input type="hidden" id="s_lshp_dcz_sts_dsc" name="s_lshp_dcz_sts_dsc" value="" />
				<input type="hidden" id="number" name="number" />
				
				
				<input type="hidden" id="reg_brc" name="reg_brc" value="<%=(String)hMapSession.get("brc")%>" />    <!-- 등록시 설정되는 brc -->
				<input type="hidden" id="reg_brnm" name="reg_brnm" value="<%=(String)hMapSession.get("brnm")%>" />    <!-- 등록시 설정되는 brc -->
				<input type="hidden" id="losmsr_yn" name="losmsr_yn" value="n" />    <!-- 측정대상손실사건yn -->

				<input type="hidden" id="sch_crrk_yn" name="sch_crrk_yn" value="" />   
				<input type="hidden" id="sch_mkrk_yn" name="sch_mkrk_yn" value="" />   
				<input type="hidden" id="sch_lgrk_yn" name="sch_lgrk_yn" value="" />   
				<input type="hidden" id="sch_strk_yn" name="sch_strk_yn" value="" />   
				<input type="hidden" id="sch_fmrk_yn" name="sch_fmrk_yn" value="" />   
				
				<div id="register"></div>
				<div id="loss_html"></div>
				
				<!-- 조회_일반발생부서 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tr>
									<th>손실 사건 번호</th>
									<td><input type="text" class="form-control w150" id="sch_lshp_amnno" name="sch_lshp_amnno"></td>
									<th>조회일자</th>
									<td colspan="5">
										<div class="form-inline">
											<div class="select ">
												<select class="form-control w100" id="dt_knd" name="dt_knd" onchange="set_dt_knd()">
														<option value="">전체</option>
														<option value="oc">사건발생일자</option>
														<option value="dc">사건발견일자</option>
														<option value="rg">사건등록일자</option>
														<option value="rg">사건종료일자</option>
														<option value="fa">최초회계처리일자</option>
														<option value="lc">최종변경일자</option>
												</select>
											</div>
											<div class="input-group">
												<input type="hidden" id="st_dt" name="st_dt">
												<input type="text" class="form-control w100" id="txt_st_dt" name="txt_st_dt" disabled>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="txt_st_dt_btn" name="txt_st_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');" disabled><i class="fa fa-calendar"></i></button>
												</span>
											</div>
											<div class="input-group">
												<div class="input-group-addon"> ~ </div>
												<input type="hidden" id="ed_dt" name="ed_dt">
												<input type="text" class="form-control w100" id="txt_ed_dt" name="txt_ed_dt" disabled>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="txt_ed_dt_btn" name="txt_ed_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');" disabled><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th>결재 진행단계</th>
									<td>
										<div class="form-inline">
											<div class="select">
												<select class="form-control w100" id="sch_lshp_dcz_sts_dsc" name="sch_lshp_dcz_sts_dsc">
														<option value="">선택</option>
<%
			for(int i=0;i<lshpDczStsDscLst.size();i++){
				HashMap hMap = (HashMap)lshpDczStsDscLst.get(i);
%>
														<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
			}	
%>
												</select>
											</div>
											<button class="btn-tip tipOpen" type="button" tip="tip_all"><span class="blind">Help</span></button>
										</div>
									</td>
									<th>금액</th>
									<td colspan="3">
										<div class="form-inline">
											<span class="select w100">
												<select class="form-control w100p" id="am_knd" name="am_knd" onchange="set_am_knd()">
														<option value="">선택</option>
														<option value="tl">총손실금액</option>
														<option value="bi">보험회수전순손실액</option>
														<option value="gl">순손실금액</option>
												</select>
											</span>
											<div class="input-group">
												<input type="hidden" id="st_am" name="st_am"/> 
												<input type="text" class="form-control text-right" style="width:80px;" id="txt_st_am" name="txt_st_am" disabled> 
												<span class="input-group-addon">원 </span>
												<span class="input-group-addon"> ~ </span>
												<input type="hidden" id="ed_am" name="ed_am" />
												<input type="text" class="form-control text-right" style="width:80px;" id="txt_ed_am" name="txt_ed_am" disabled> 
												<span class="input-group-addon">원 </span>
											</div>
										</div>
									</td>
									
								</tr>
								<tr id="obj_tr_orm" name="obj_tr_orm" style="display:none">
									<th>보고 부서</th>
									<td>
										<div class="input-group w150">
											<input type="hidden" id="rpt_brc" name="rpt_brc"/> 
											<input type="text" class="form-control" id="rpt_brnm" name="rpt_brnm" onKeyPress="EnterkeySubmitOrg('rpt_brnm', 'rptOrgSearchEnd');">
											<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="rpt_brnm_btn" onclick="schOrgPopup('rpt_brnm', 'rptOrgSearchEnd');"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
									<th>발생 부서</th>
									<td>
										<div class="input-group w150">
											<input type="hidden" id="ocu_brc" name="ocu_brc"/> 
											<input type="text" class="form-control" id="ocu_brnm" name="ocu_brnm" onKeyPress="EnterkeySubmitOrg('ocu_brnm', 'ocuOrgSearchEnd');">
											<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="ocu_brnm_btn" onclick="schOrgPopup('ocu_brnm', 'ocuOrgSearchEnd');"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>	
								</tr>
								<tr id="obj_tr1_orm" name="obj_tr1_orm" style="display:none">
									<th>사건관리 부서(부/팀)</th>
									<td>
										<div class="input-group w150">
											<input type="hidden" id="amn_brc" name="amn_brc"/> 
											<input type="text" class="form-control" id="amn_brnm" name="amn_brnm" onKeyPress="EnterkeySubmitOrg('amn_brnm', 'amnOrgSearchEnd');">
											<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="amn_brnm_btn" onclick="schOrgPopup('amn_brnm', 'amnOrgSearchEnd');"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
									<th>발생 법인</th>
									<td>
										<div class="form-inline">
											<select class="form-control w150" id="grp_org_c" name="grp_org_c">
											<option value="">전체</option>
<%
		for(int i=0;i<vGrpList.size();i++){
			HashMap hMap = (HashMap)vGrpList.get(i);
			if(((String)hMap.get("grp_org_c")).equals(grp_org_c)){
%>
											<option value="<%=(String)hMap.get("grp_org_c")%>" selected><%=(String)hMap.get("grp_orgnm")%></option>
<%					
			}else{
%>
											<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
<%					
			}
%>
<%
		}
%>
											</select>
										</div>
									</td>	
								</tr>
								<tr id="obj_tr2_orm" name="obj_tr2_orm" style="display:none">
									<th>사건유형</th>
									<td>
										<div class="input-group w120">
											<input type="text" class="form-control" id="hpn_tpnm" name="hpn_tpnm" readonly>
											<input type="hidden" id="hpn_tpc" name="hpn_tpc" />
											<span class="input-group-btn">
											<button class="btn btn-default ico search" type="button" id="hpn_tpnm_btn" onclick="hpn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
									<th>원인유형</th>
									<td>
										<div class="input-group w120">
											<input type="text" class="form-control" id="cas_tpnm" name="cas_tpnm" readonly>
											<input type="hidden" id="cas_tpc" name="cas_tpc" />
											<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button" id="cas_tpnm_btn" onclick="cas_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
								</tr>
								<tr id="obj_tr3_orm" name="obj_tr3_orm" style="display:none">
									<th>영향유형</th>
									<td>
										<div class="input-group w120">
											<input type="hidden" id="ifn_tpc" name="ifn_tpc" value="" />
											<input type="text" class="form-control" id="shw_ifn_tpnm" name="shw_ifn_tpnm" value="" readonly />
											<span class="input-group-btn">
												<button type="button" class="btn btn-default btn-sm ico" id="shw_ifn_tpnm_btn" onclick="ifn_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
												</button>
											</span>
										</div>
									</td>
									<th>이머징리스크유형</th>
									<td>
										<div class="input-group w120">
											<input type="hidden" id="emrk_tpc" name="emrk_tpc" value="" />
											<input type="text" class="form-control" id="shw_emrk_tpnm" name="shw_emrk_tpnm" value="" readonly />
											<span class="input-group-btn">
												<button type="button" class="btn btn-default btn-sm ico" id="shw_ifn_tpnm_btn" onclick="emrk_popup();">
												<i class="fa fa-search"></i><span class="blind">검색</span>
												</button>
											</span>
										</div>
									</td>
								</tr>								
								<tr id="obj_tr4_orm" name="obj_tr4_orm" style="display:none">
									<th>손실형태</th>
									<td>
										<div class="select w120">
											<select class="form-control w100p" id="lshp_form_c" name="lshp_form_c" >
												<option value="">전체</option>
<%
			if(lshpFormCLst.size()>0){
				for(int i=0;i<lshpFormCLst.size();i++){
					HashMap hMap = (HashMap)lshpFormCLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
				}
			}	
%>
											</select>
										</div>
									</td>
									<th>손실상태</th>
									<td>
										<div class="select w120">
											<select class="form-control w100p" id="lshp_stsc" name="lshp_stsc" >
												<option value="">전체</option>
<%
			if(lshpStscLst.size()>0){
				for(int i=0;i<lshpStscLst.size();i++){
					HashMap hMap = (HashMap)lshpStscLst.get(i);
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
								<tr id="obj_tr5_orm" name="obj_tr5_orm" style="display:none">
									<th>경계리스크</th>
									<td>
										<dl class="dropdown dMSC w200"> 
											<dt class="select"><a href="#none"> <span class="hida">선택</span> <p class="multiSel"></p></a></dt>
											<dd>
												<div class="mutliSelect">
													<ul>
														<li><input type="checkbox" name="mul-all" id="mul-all" value="" data-name="mul"><label for="mul-all">전체선택</label></li>
														<li><input type="checkbox" name="mul" id="crrk_yn" value="" ><label for="crrk_yn">신용</label></li>
														<li><input type="checkbox" name="mul" id="mkrk_yn" value="" ><label for="mkrk_yn">시장</label></li>
														<li><input type="checkbox" name="mul" id="strk_yn" value="" ><label for="strk_yn">전략</label></li>
														<li><input type="checkbox" name="mul" id="lgrk_yn" value="" ><label for="lgrk_yn">법률</label></li>
														<li><input type="checkbox" name="mul" id="fmrk_yn" value="" ><label for="fmrk_yn">평판</label></li>
													</ul>
												</div>
											</dd>
										</dl>
									</td>
								</tr>
								<tr>
									<th>사건제목</th>
									<td colspan="4">
										<input type="text" class="form-control w600" id="sch_lshp_tinm" name="sch_lshp_tinm" placeholder="">
									</td>
								</tr>
							</table>
						</div><!-- .wrap-search -->
					</div><!-- .box-body //-->
					<div class="box-footer w150">
						
							<button type="button" class="btn btn-primary search" id="shw_btn" onclick="javascript:doAction('search');">조회</button>
					</div>
				</div>
				<!-- 조회 //-->
			</form>

			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<div class="btn-wrap">
<%
			if(role_id.equals("nml")){
%>
							<div class="btn-group">
								<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('add')"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
								<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('mod')"><i class="fa fa-plus"></i><span class="txt">수정</span></button>
								<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
							</div>
<%
			}else if(role_id.equals("orm")||role_id.equals("ormld")){
%>
							<div class="btn-group">
<%
				if(role_id.equals("orm")||role_id.equals("ormld")){
%>
								<button type="button" class="btn btn-xs btn-primary" onclick="javascript:commAdd();"><span class="txt">공통손실등록</span></button>
								<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('add')"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
								<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('mod')"><i class="fa fa-plus"></i><span class="txt">수정</span></button>
								<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>								
<%
				}
%>
								<!-- <button type="button" class="btn btn-xs btn-default" onclick="losmsr_popup();"><span class="txt">측정대상손실사건조회</span></button> -->
							</div>
<%
			}else if(role_id.equals("admn")){
%>
								<button type="button" class="btn btn-xs btn-default" onClick="javascript:doAction('mod')"><i class="fa fa-plus"></i><span class="txt">수정</span></button>
<%
			}
%>
							<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>						
					</div>
				</div>
				<div class="box-body">
<%
			if(role_id.equals("orm")||role_id.equals("ormld")){
%>
					<div class="wrap-grid h350" id="ibsheet_div">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
<% 
			}else if(role_id.equals("nml")||role_id.equals("nmlld")||role_id.equals("admn")){
%>
					<div class="wrap-grid h450" id="ibsheet_div">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
<%				
			}else{
%>
					<div class="wrap-grid h450" id="ibsheet_div">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
<%				
			}
%>
						
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
<%
			if(role_id.equals("orm")){
%>
						<button type="button" class="btn btn-primary" onclick="doAction('reportOrm')">결재</button>
<%
			}else if(role_id.equals("ormld")){
%>
						<button type="button" class="btn btn-primary" onclick="doAction('apprvOrmld')">승인</button>
						<button type="button" class="btn btn-normal" onclick="doAction('rejectOrmld')">반려</button>
<%
			}else if(role_id.equals("nml")){
%>
						<button type="button" class="btn btn-primary" onclick="doAction('reportNml')">결재</button>
<%
			}else if(role_id.equals("nmlld")){
%>
						<button type="button" class="btn btn-primary" onclick="doAction('apprvNmlld')">승인</button>
						<button type="button" class="btn btn-normal" onclick="doAction('rejectNmlld')">반려</button>
<%
			}else if(role_id.equals("admn")){
%>
						<button type="button" class="btn btn-primary" onclick="doAction('reportAdmn')">등록완료</button>
<%
			}
%>					</div>
				</div>
			</div>

		</div>
		<!-- content //-->
	</div>
	<!-- popup -->
	<div id="tip_all" class="tip-wrap">
		<article class="tip-inner" style="width: 600px;">
			
			<table class="table-tip">
				<colgroup>
					<col style="width: 40px;">
					<col style="width: 120px;">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="col">순서</th>
						<th scope="col">결재진행단계</th>
						<th scope="col">설명</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>1</td>
						<td>등록중</td>
						<td style="text-align: left;">손실사건 발생 시, 보고부점에서 신규 손실사건을 입력하고 저장하였으나 결재 요청하지 않은 상태</td>
					</tr>
					<tr>
						<td>2</td>
						<td>팀장/부서장 결재중</td>
						<td style="text-align: left;">팀장/부서장 앞 결재 요청하였으나 결재 완료하지 않은 상태</td>
					</tr>
					<tr>
						<td>3</td>
						<td>등록완료</td>
						<td style="text-align: left;">팀장/부서장 앞 결재 요청된 손실사건이 결재 완료되어 ORM 부서로 전달된 상태</td>
					</tr>
					<tr>
						<td>4</td>
						<td>ORM검토중</td>
						<td style="text-align: left;">ORM전담이 취합된 손실사건 확인 및 추가의견을 입력하고 저장하였으나 결재 요청하지 않은 상태 / ORM전담이 신규 손실사건 등을 입력하고 저장하였으나 결재 요청하지 않은 상태</td>
					</tr>
					<tr>
						<td>5</td>
						<td>ORM승인완료</td>
						<td style="text-align: left;">ORM 팀장이 승인한 상태</td>
					</tr>
					<tr>
						<td>6</td>
						<td>ORM반려</td>
						<td style="text-align: left;">ORM 팀장이 반려 요청한 상태</td>
					</tr>
					<tr>
						<td>7</td>
						<td>사건관리부서 검토중</td>
						<td style="text-align: left;">ORM승인완료된 손실사건에 대해 유관부서의 검토 및 손실사건 수집항목 추가입력이 필요하여 ORM으로부터 지정된 사건관리부서로 내용 검토 및 보완이 요청되고 지정된 관리부서에서 해당 손실사건 내용을 검토중인 상태</td>
					</tr>
					<tr>
						<td>8</td>
						<td>사건관리부서 등록완료</td>
						<td style="text-align: left;">ORM부서가 지정한 사건관리부서에서 손실사건 내용 입력이 완료된 상태</td>
					</tr>
				</tbody>
			</table>
		</article>
	</div>
	
	<div id="winLossAdd" class="popup modal">
		<iframe name="ifrLossAdd" id="ifrLossAdd" src="about:blank"></iframe>
	</div>
	<div id="winCommAdd" class="popup modal">
		<iframe name="ifrCommAdd" id="ifrCommAdd" src="about:blank"></iframe>
	</div>
	<div id="winLossMod" class="popup modal">
		<iframe name="ifrLossMod" id="ifrLossMod" src="about:blank"></iframe>
	</div>
	<div id="winCommMod" class="popup modal">
		<iframe name="ifrCommMod" id="ifrCommMod" src="about:blank"></iframe>
	</div>
	<div id="winLossMsr" class="popup modal">
		<iframe name="ifrLossMsr" id="ifrLossMsr" src="about:blank"></iframe>
	</div>
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->
	<%@ include file="../comm/CasInfP.jsp" %> <!-- 원인유형 공통 팝업 -->
	<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
	<%@ include file="../comm/EmrkInfP.jsp" %> <!-- 이머징리스크유형 공통 팝업 -->
	<%-- <%@ include file="../comm/LosmsrInfP.jsp" %> --%> <!-- 측정대상 손실사건 공통 팝업 -->
	<!-- popup //-->
	
	<script>
		// 보고부서검색 완료
		function rptOrgSearchEnd(brc, brnm){
			$("#rpt_brc").val(brc);
			$("#rpt_brnm").val(brnm);
			$("#winBuseo").hide();
		}
		// 관리부서검색 완료
		function amnOrgSearchEnd(brc, brnm){
			$("#amn_brc").val(brc);
			$("#amn_brnm").val(brnm);
			$("#winBuseo").hide();
		}
		// 발생부서 완료
		function ocuOrgSearchEnd(brc, brnm){
			$("#ocu_brc").val(brc);
			$("#ocu_brnm").val(brnm);
			$("#winBuseo").hide();
		}
			
		// 손실사건유형검색 완료
		
		var HPN3_ONLY = true; 
		var CUR_HPN_TPC = "";
		
		function hpn_popup(){
			CUR_HPN_TPC = $("#hpn_tpc_lv3").val();
			if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
			schHpnPopup();
		}
		
		function hpnSearchEnd(hpn_tpc, hpn_tpnm){
			$("#hpn_tpc").val(hpn_tpc);
			$("#hpn_tpnm").val(hpn_tpnm);
			
			$("#winHpn").hide();
			//doAction('search');
		}
		

		// 원인유형검색 완료
		var CAS3_ONLY = true; 
		var CUR_CAS_TPC = "";
		
		function cas_popup(){
			CUR_CAS_TPC = $("#cas_tpc").val();
			schCasPopup();
		}
		
		function casSearchEnd(cas_tpc, cas_tpnm
							, cas_tpc_lv1, cas_tpnm_lv1
							, cas_tpc_lv2, cas_tpnm_lv2){
			$("#cas_tpc").val(cas_tpc);
			$("#cas_tpnm").val(cas_tpnm);
			
			$("#winCas").hide();
			//doAction('search');
		}
		
		function cas_remove(){
			$("#cas_tpc").val("");
			$("#cas_tpnm").val("");
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
			$("#shw_ifn_tpnm").val(ifn_tpnm);

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
			$("#shw_emrk_tpnm").val(emrk_tpnm_lv1 + " > " + emrk_tpnm);
	
			$("#winEmrk").hide();
			//doAction('search');
		}
	
		function emrk_remove() {
			$("#emrk_tpc").val("");
			$("#shw_emrk_nm").val("");
		}
		// 측정대상손실사건조회 완료
		
		//var BIZ2_ONLY = true; 
		//var CUR_BIZ_TPC = "";
		
		function losmsr_popup(){
			parent.menuTrigger('0006503');
		}
		
		function losmsrSearchEnd(st_dt, ed_dt){
			$("#lshp_amnno").val("");
			$("#dt_knd").val("");
			$("#st_dt").val(st_dt);
			$("#ed_dt").val(ed_dt);
			$("#lshp_form_c").val("");
			$("#rpt_brc").val("");
			$("#rpt_brnm").val("");
			$("#am_knd").val("");
			$("#txt_st_am").val("");
			$("#st_am").val("");
			$("#ed_am").val("");
			$("#ed_am").val("");
			$("#amn_brnm").val("");
			$("#amn_brc").val("");
			$("#lshp_tinm").val("");
			$("#sch_mkrk_yn").val("");
			$("#sch_crrk_yn").val("");
			$("#sch_lgrk_yn").val("");
			$("#sch_strk_yn").val("");
			$("#sch_fmrk_yn").val("");
			$("#lshp_dcz_sts_dsc").val("");
			$("#isr_rqs_yn").val("");
			$("#cas_tpnm").val("");
			$("#cas_tpc").val("");
			$("#hpn_tpnm").val("");
			$("#hpn_tpc").val("");
			$("#losmsr_yn").val("y");
			
			$("#winLosmsr").hide();
			doAction('search');
		}
			

		$(document).ready(function(){
			
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				event.preventDefault();
			});

		});
			
	</script>
</body>
</html>