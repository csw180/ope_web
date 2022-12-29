<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0103.jsp
 Program name : BIA 평가(팀BCP담당자, 단위업무담당자, 팀장)
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

Vector vLst2 = CommUtil.getCommonCode(request, "MAX_PMSS_SSP_PRDC"); //최대허용중단기간(공통코드)
if(vLst2==null) vLst2 = new Vector();

Vector vLst3 = CommUtil.getCommonCode(request, "OBT_RCVR_PTM_C"); //목표복구시점(공통코드)
if(vLst3==null) vLst3 = new Vector();
DynaForm form = (DynaForm)request.getAttribute("form");

String bcp_menu_dsc = (String)form.get("bcp_menu_dsc");
System.out.println(bcp_menu_dsc);

//최대허용중단기간코드코드 ibsheet Combo 형태로 변환
String max_pmss_ssp_prdc = "";
String max_pmss_ssp_prdnm = "";

for(int i=0;i<vLst2.size();i++){
	HashMap hMap = (HashMap)vLst2.get(i);
	if("".equals(max_pmss_ssp_prdc)){
		max_pmss_ssp_prdc += (String)hMap.get("intgc");
		max_pmss_ssp_prdnm += (String)hMap.get("intg_cnm");
	}else{
		max_pmss_ssp_prdc += ("|" + (String)hMap.get("intgc"));
		max_pmss_ssp_prdnm += ("|" + (String)hMap.get("intg_cnm"));
	}
}


//목표복구시점코드 ibsheet Combo 형태로 변환
String obt_rcvr_ptm_c = "";
String obt_rcvr_ptmnm = "";

for(int i=0;i<vLst3.size();i++){
	HashMap hMap = (HashMap)vLst3.get(i);
	if(obt_rcvr_ptm_c==""){
		obt_rcvr_ptm_c += (String)hMap.get("intgc");
		obt_rcvr_ptmnm += (String)hMap.get("intg_cnm");
	}else{
		obt_rcvr_ptm_c += ("|" + (String)hMap.get("intgc"));
		obt_rcvr_ptmnm += ("|" + (String)hMap.get("intg_cnm"));
	}
}

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd 

%>   
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			var bcp_menu_dsc = <%=bcp_menu_dsc%>;
			$("#bcp_menu_dsc").val(bcp_menu_dsc);
			//ibsheet 초기화
			initIBSheet();
		});

 		$("#st_bia_yy").ready(function() {
 			
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp"); 
			WP.setParameter("process_id", "ORBC010102");  
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
						   var html = "";
						   var html2 ="";
						   var bia_yy = rList[0].bia_yy
						   bia_yy = bia_yy.substring(5);
						   
						   html +=	'평가일정 : ' +
							   		'<strong>'+rList[0].bia_evl_st_dt+' ~ '+rList[0].bia_evl_ed_dt+' </strong>' +
							   		'<span class="ph2 tag t1 txt txt-sm" id="bia_evl_prg"></span>'
							   		
							   		;
								
						   html2 += "<input type='hidden' id='bia_evl_ed_dt' 	name='bia_evl_ed_dt' 	value='"+rList[0].bia_evl_ed_dt+"'>"
							  
						   $("#stsc").html(html2);
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
		});
		
		/********************************************************* 
		BIA 평가 관리
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, FrozenCol:0, MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"선택|번호",							Type:"Seq",	MinWidth:50,		Align:"Left",		SaveName:"num",				Hidden:true},
				{Header:"선택|선택",							Type:"CheckBox",	MinWidth:50,		Align:"Left",		SaveName:"ischeck",				Edit:1},
				{Header:"평가대상팀|평가대상팀",							Type:"Text",	MinWidth:150,	Align:"Center",		SaveName:"brnm",				Edit:0},//3
				{Header:"Status|Status",							Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",				Edit:0, Hidden:true},
				{Header:"평가회차|평가년월",								Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bas_ym",			Edit:0, Hidden:true},
				{Header:"평가회차|평가회차",								Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bia_yy",			Edit:0, Hidden:true},
				{Header:"평가회차|평가종료일",								Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bia_evl_ed_dt",			Edit:0, Hidden:true},
				{Header:"업무프로세스|LV1",					Type:"Text",	MinWidth:150,	Align:"Left",		SaveName:"bsn_prsnm_lv1",			Edit:0,	Wrap:true},
				{Header:"업무프로세스|LV2",					Type:"Text",	MinWidth:150,	Align:"Left",		SaveName:"bsn_prsnm_lv2",			Edit:0,	Wrap:true},
				{Header:"업무프로세스|LV3",					Type:"Text",	MinWidth:150,	Align:"Left",		SaveName:"bsn_prsnm_lv3",			Edit:0,	Wrap:true},
				{Header:"업무프로세스|LV4",					Type:"Text",	MinWidth:150,	Align:"Left",		SaveName:"bsn_prsnm_lv4",			Edit:0,	Wrap:true},
				{Header:"설문대상|평가자 사번",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"eno",			Edit:0, Hidden:true},
				{Header:"설문대상|단위업무 담당자",					Type:"Html",	MinWidth:130,		Align:"Center",		SaveName:"chrg_empnm_s",			Edit:0},
				{Header:"설문대상|단위업무 담당자",					Type:"Text",	MinWidth:130,		Align:"Center",		SaveName:"chrg_empnm",			Edit:0, Hidden:true},
				{Header:"업무프로세스코드|업무프로세스코드",					Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bsn_prss_c",			Edit:0, Hidden:true},
				{Header:"BIA평가진행상태코드|BIA평가진행상태코드",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bia_evl_prg_stsc",	Edit:0, Hidden:true},
				{Header:"BIA평가진행상태|BIA평가진행상태",					Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"",	Edit:0, Hidden:true},
				{Header:"평가부서코드|평가부서코드",						Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"brc",					Edit:0, Hidden:true},
				{Header:"평가\n부서|평가\n부서",						Type:"Text",	MinWidth:150,	Align:"Center",		SaveName:"brnm",				Edit:0, Hidden:true},
				{Header:"유형가중치1|유형가중치1",					Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_tp_wval_rto1",			Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"유형가중치2|유형가중치2",					Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_tp_wval_rto2",			Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"유형가중치3|유형가중치3",					Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_tp_wval_rto3",			Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"유형가중치4|유형가중치4",					Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_tp_wval_rto4",			Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"유형가중치5|유형가중치5",					Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_tp_wval_rto5",			Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"중단시영향가중치1|중단시영향가중치1",			Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_ssp_ifn_wval_rto1",		Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"중단시영향가중치2|중단시영향가중치2",			Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_ssp_ifn_wval_rto2",		Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"중단시영향가중치3|중단시영향가중치3",			Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_ssp_ifn_wval_rto3",		Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"중단시영향가중치4|중단시영향가중치4",			Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_ssp_ifn_wval_rto4",		Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"중단시영향가중치5|중단시영향가중치5",			Type:"Float",	MinWidth:0,		Align:"Left",		SaveName:"bsn_ssp_ifn_wval_rto5",		Edit:0, Hidden:true, Format:"#0.###"},
				{Header:"업무 유형 중요도 평가|대고객\n서비스\n업무",			Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_yn1",	Hidden:true},
				{Header:"업무 유형 중요도 평가|대고객\n서비스\n지원 업무",		Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_yn2",	Hidden:true},
				{Header:"업무 유형 중요도 평가|트레이딩\n및\n자산운용\n업무",	Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_yn3",	Hidden:true},
				{Header:"업무 유형 중요도 평가|기획 및\n관리 업무",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_yn4",	Hidden:true},
				{Header:"업무 유형 중요도 평가|인프라\n관리 업무",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_yn5",	Hidden:true},
				{Header:"count|count",									Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"count",			Hidden:true	},
				{Header:"count2|count2",								Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"count2",			Hidden:true	},
				{Header:"업무 유형 중요도 평가|대고객\n서비스\n업무",			Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_ox1",	Edit:0},
				{Header:"업무 유형 중요도 평가|대고객\n서비스\n지원 업무",		Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_ox2",	Edit:0},
				{Header:"업무 유형 중요도 평가|트레이딩\n및\n자산운용\n업무",	Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_ox3",	Edit:0},
				{Header:"업무 유형 중요도 평가|기획 및\n관리 업무",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_ox4",	Edit:0},
				{Header:"업무 유형 중요도 평가|인프라\n관리 업무",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"bsn_coic_ox5",	Edit:0},
				{Header:"업무\n유형\n중요도|업무\n유형\n중요도",			Type:"Float",	MinWidth:50,		Align:"Center",		SaveName:"bsn_tp_iptd_val",	Edit:0, Format:"0.###"},
				{Header:"업무 중단시 영향도 평가|대고객\n서비스\n저하",			Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_yn1",	Hidden:true},
				{Header:"업무 중단시 영향도 평가|연계업무\n수행실패",			Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_yn2",	Hidden:true},
				{Header:"업무 중단시 영향도 평가|회사평판\n저하",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_yn3",	Hidden:true},
				{Header:"업무 중단시 영향도 평가|재무적\n손실",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_yn4",	Hidden:true},
				{Header:"업무 중단시 영향도 평가|감독기관\n제재",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_yn5",	Hidden:true},
				{Header:"업무 중단시 영향도 평가|대고객\n서비스\n저하",			Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_ox1",	Edit:0},
				{Header:"업무 중단시 영향도 평가|연계업무\n수행실패",			Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_ox2",	Edit:0},
				{Header:"업무 중단시 영향도 평가|회사평판\n저하",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_ox3",	Edit:0},
				{Header:"업무 중단시 영향도 평가|재무적\n손실",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_ox4",	Edit:0},
				{Header:"업무 중단시 영향도 평가|감독기관\n제재",				Type:"Text",	MinWidth:10,		Align:"Center",		SaveName:"ifn_coic_ox5",	Edit:0},
				{Header:"업무\n중단\n영향도|업무\n중단\n영향도",			Type:"Float",	MinWidth:50,		Align:"Center",		SaveName:"bsn_ssp_ifn_val",	Edit:0, Format:"#0.###"},
				{Header:"전체\n중요도\n점수|전체\n중요도\n점수",			Type:"Float",	MinWidth:50,		Align:"Center",		SaveName:"tot_sum",	Edit:0, Format:"#0.###"},
				{Header:"우선\n순위|우선\n순위",							Type:"Text",	MinWidth:40,		Align:"Center",		SaveName:"all_rank",	Edit:0},
				{Header:"최대 허용\n중단기간\n(MAO)|최대 허용\n중단기간\n(MAO)",Type:"Combo",	MinWidth:80,		Align:"Center",		SaveName:"max_pmss_ssp_prdc", 	ComboText:"<%=max_pmss_ssp_prdnm%>",ComboCode:"<%=max_pmss_ssp_prdc%>"},
				{Header:"목표\n복구시점\n(RPO)|목표\n복구시점\n(RPO)",		Type:"Combo",	MinWidth:120,		Align:"Center",		SaveName:"obt_rcvr_ptm_c", 		ComboText:"<%=obt_rcvr_ptmnm%>",	ComboCode:"<%=obt_rcvr_ptm_c%>"},
				{Header:"필요 복구\n자원 조사|필요 복구\n자원 조사",			Type:"Html",	MinWidth:80,		Align:"Center",		SaveName:"bia_evl",				Edit:0},
				{Header:"설문 완료\n여부|설문 완료\n여부",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"qsn_rg_yn",			Edit:0, Hidden:true},
				{Header:"진행상태|진행상태",								Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"bia_evl_prg",			Edit:0}
			]
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			mySheet.SetHeaderMode({ColResize:1,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			search();
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			
			$("#hd_bsn_prss_c").val(mySheet.GetCellValue(Row, "bsn_prss_c"));
/*			
			if(mySheet.GetCellValue(Row, "max_pmss_ssp_prdc")=="01" || mySheet.GetCellValue(Row, "max_pmss_ssp_prdc")=="02"){
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bia_evl"){
					//$("#bia_evl_prg_stsc").val(mySheet.GetCellValue(Row, "bia_evl_prg_stsc"));
					biaEvl(Row);
					return;
				}
			}
*/			

			var count = parseInt(mySheet.GetCellValue(Row, "count"));
			var count2 = parseInt(mySheet.GetCellValue(Row, "count2"));
			var bia_evl_ed_dt = mySheet.GetCellValue(Row,"bia_evl_ed_dt");
			$("#bia_evl_ed_dt").val(bia_evl_ed_dt);
			var today = $("#today").val();
			if(mySheet.GetCellValue(Row, "bia_evl_prg_stsc")=="02" && parseInt(today) <= parseInt(bia_evl_ed_dt)&& $("#bcp_menu_dsc").val() == "2"){
				//유형중요도
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox1" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "bsn_coic_yn1", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count", (count-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox1" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "bsn_coic_yn1", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count", (count+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox2" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "bsn_coic_yn2", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count", (count-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox2" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "bsn_coic_yn2", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count", (count+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox3" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "bsn_coic_yn3", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count", (count-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox3" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "bsn_coic_yn3", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count", (count+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox4" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "bsn_coic_yn4", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count", (count-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox4" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "bsn_coic_yn4", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count", (count+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox5" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "bsn_coic_yn5", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count", (count-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_ox5" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "bsn_coic_yn5", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count", (count+1));
				}
				
				//중단시영향도
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox1" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "ifn_coic_yn1", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count2", (count2-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox1" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "ifn_coic_yn1", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count2", (count2+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox2" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "ifn_coic_yn2", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count2", (count2-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox2" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "ifn_coic_yn2", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count2", (count2+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox3" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "ifn_coic_yn3", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count2", (count2-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox3" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "ifn_coic_yn3", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count2", (count2+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox4" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "ifn_coic_yn4", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count2", (count2-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox4" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "ifn_coic_yn4", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count2", (count2+1));
				}
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox5" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "ifn_coic_yn5", "N");
					mySheet.SetCellValue(Row, Col, "X");
					mySheet.SetCellValue(Row, "count2", (count2-1));
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_ox5" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "ifn_coic_yn5", "Y");
					mySheet.SetCellValue(Row, Col, "O");
					mySheet.SetCellValue(Row, "count2", (count2+1));
				}
				
			}
		}
		
		function mySheet_OnChange(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			var sum1 = mySheet.GetCellValue(Row, "bsn_tp_iptd_val");
			var sum2 = mySheet.GetCellValue(Row, "bsn_ssp_ifn_val");
			var tot_sum = mySheet.GetCellValue(Row, "tot_sum");
			
			//유형중요도
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn1" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto1"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto1")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn1" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto1"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto1")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn2" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto2"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto2")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn2" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto2"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto2")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn3" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto3"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto3")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn3" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto3"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto3")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn4" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto4"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto4")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn4" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto4"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto4")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn5" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto5"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto5")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bsn_coic_yn5" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_tp_iptd_val", (sum1-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto5"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_tp_wval_rto5")));
			}
			
			//중단시영향도
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn1" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto1"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto1")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn1" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto1"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto1")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn2" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto2"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto2")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn2" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto2"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto2")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn3" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto3"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto3")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn3" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto3"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto3")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn4" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto4"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto4")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn4" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto4"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto4")));
			}
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn5" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto5"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum+parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto5")));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ifn_coic_yn5" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellValue(Row, "bsn_ssp_ifn_val", (sum2-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto5"))).toFixed(3));
				mySheet.SetCellValue(Row, "tot_sum", tot_sum-parseFloat(mySheet.GetCellValue(Row, "bsn_ssp_ifn_wval_rto5")));
			}
			
			
			
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="max_pmss_ssp_prdc" && (mySheet.GetCellValue(Row, Col)=="01"||mySheet.GetCellValue(Row, Col)=="02")){
				mySheet.SetCellValue(Row, "bia_evl", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:biaEvl('+Row+');">입력</button>');
				$("#max_pmss_ssp_prdc").val(mySheet.GetCellValue(Row, "max_pmss_ssp_prdc"));
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="max_pmss_ssp_prdc" && (mySheet.GetCellValue(Row, Col)!="01"||mySheet.GetCellValue(Row, Col)!="02")){
				mySheet.SetCellValue(Row, "bia_evl", " ");
			}
			
			
			
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/* Sheet 각종 처리 */
		function doAction(sAction){
			switch(sAction){
				case "search": //데이터 조회
					$("#bas_yy").val($("#st_bia_yy").val());
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010302");

					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

					break;
				case "save1": //팀bcp담당자-평가담당자 지정
				
					var f = document.ormsForm;
					/* var add_html = "";
					var add_html2 = "";
					if(mySheet.GetDataFirstRow()>=0){
						for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
							if(mySheet.GetCellValue(j,"ischeck")==1){
								add_html += "<input type='hidden' name='bsn_prss_c' value='" + mySheet.GetCellValue(j,"bsn_prss_c") + "'>";
								add_html2 += "<input type='hidden' name='vlr_eno' value='" + mySheet.GetCellValue(j,"vlr_eno") + "'>";
							}
						}
					}
					alert(add_html);
					if(add_html=="") {
						alert("선택해주세요.");
						return;
					}
		            tmp_area.innerHTML = add_html+add_html2;
		            */
					if(!confirm("담당자를 저장하시겠습니까?")) return; 
					
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "bcp");
					WP.setParameter("process_id", "ORBC010304");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					//alert(inputData);
					//showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("저장되었습니다.");
								objCopy(result.Result.new_code);
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
							doAction("search");
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
					break;
			}
		}
		
		function search(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");  
			WP.setParameter("process_id", "ORBC010102"); 
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
						   var html = "";
						   var html2 = ""; 
						   var bia_yy = rList[0].bia_yy
						   bia_yy = bia_yy.substring(5);
						   
						   html +=	'평가일정 : ' +
							   		'<strong>'+rList[0].bia_evl_st_dt+' ~ '+rList[0].bia_evl_ed_dt+' </strong>' +
							   		'<span class="ph2 tag t1 txt txt-sm" id="bia_evl_prg"></span>'
							   		
							   		;
								
						  html2 += "<input type='hidden' id='bia_evl_ed_dt' 	name='bia_evl_ed_dt' 	value='"+rList[0].bia_evl_ed_dt+"'>"
						  
						  $("#stsc").html(html2);
						  
					  }
						  
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
					  doAction("search");
					  
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);			
		}
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("BIA 평가(평가부서) 조회 중에 오류가 발생하였습니다..");
			}else{
				if($("#bcp_menu_dsc").val()=='1') {
					mySheet.SetColHidden("ischeck",1);
				}
				$("#bas_ym").val(mySheet.GetCellValue(mySheet.GetDataLastRow(), "bas_ym"));
			}
			if(mySheet.GetDataFirstRow()>0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					$("#bia_evl_ed_dt").val(mySheet.GetCellValue(i,"bia_evl_ed_dt"));
					var sum1 = 0;
					var sum2 = 0;
					var count = 0;
					var count2 = 0;
					//유형중요도
					if(mySheet.GetCellValue(i,"bsn_coic_yn1")=="Y"){
						mySheet.SetCellValue(i,"bsn_coic_ox1", "O");
						sum1 += parseFloat(mySheet.GetCellValue(i, "bsn_tp_wval_rto1"));
						count++
					}else{
						mySheet.SetCellValue(i,"bsn_coic_ox1", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn2")=="Y"){
						mySheet.SetCellValue(i,"bsn_coic_ox2", "O");
						sum1 += parseFloat(mySheet.GetCellValue(i, "bsn_tp_wval_rto2"));
						count++
					}else{
						mySheet.SetCellValue(i,"bsn_coic_ox2", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn3")=="Y"){
						mySheet.SetCellValue(i,"bsn_coic_ox3", "O");
						sum1 += parseFloat(mySheet.GetCellValue(i, "bsn_tp_wval_rto3"));
						count++
					}else{
						mySheet.SetCellValue(i,"bsn_coic_ox3", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn4")=="Y"){
						mySheet.SetCellValue(i,"bsn_coic_ox4", "O");
						sum1 += parseFloat(mySheet.GetCellValue(i, "bsn_tp_wval_rto4"));
						count++
					}else{
						mySheet.SetCellValue(i,"bsn_coic_ox4", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn5")=="Y"){
						mySheet.SetCellValue(i,"bsn_coic_ox5", "O");
						sum1 += parseFloat(mySheet.GetCellValue(i, "bsn_tp_wval_rto5"));
						count++
					}else{
						mySheet.SetCellValue(i,"bsn_coic_ox5", "X");
					}
					mySheet.SetCellValue(i, "bsn_tp_iptd_val", sum1.toFixed(3));
					mySheet.SetCellValue(i, "count", count);
					
					//중단시영향도
					if(mySheet.GetCellValue(i, "ifn_coic_yn1")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox1","O");
						sum2 += parseFloat(mySheet.GetCellValue(i, "bsn_ssp_ifn_wval_rto1"));
						count2++
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox1","X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn2")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox2","O");
						sum2 += parseFloat(mySheet.GetCellValue(i, "bsn_ssp_ifn_wval_rto2"));
						count2++
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox2","X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn3")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox3","O");
						sum2 += parseFloat(mySheet.GetCellValue(i, "bsn_ssp_ifn_wval_rto3"));
						count2++
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox3","X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn4")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox4","O");
						sum2 += parseFloat(mySheet.GetCellValue(i, "bsn_ssp_ifn_wval_rto4"));
						count2++
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox4","X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn5")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox5","O");
						sum2 += parseFloat(mySheet.GetCellValue(i, "bsn_ssp_ifn_wval_rto5"));
						count2++
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox5","X");
					}
					mySheet.SetCellValue(i, "bsn_ssp_ifn_val", sum2.toFixed(3));
					mySheet.SetCellValue(i, "count2", count2);
					
					//전체중요도점수
					mySheet.SetCellValue(i, "tot_sum", (sum1+sum2));
					//평가완료일 경우 전체 Editable
					var bia_evl_ed_dt = $("#bia_evl_ed_dt").val();
					bia_evl_ed_dt = bia_evl_ed_dt.replace(/-/gi, '');
					var today = $("#today").val();
					
					//필요복구자원조사
					if(mySheet.GetCellValue(i, "max_pmss_ssp_prdc")=="01" || mySheet.GetCellValue(i, "max_pmss_ssp_prdc")=="02"){
						if(mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="02" || parseInt(today) > parseInt(bia_evl_ed_dt)){
							mySheet.SetCellValue(i, "bia_evl", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:biaEvl('+i+');">조회</button>');
						}else{
							mySheet.SetCellValue(i, "bia_evl", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:biaEvl('+i+');">입력</button>');
						}
					}

					if(mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="02" || parseInt(today) > parseInt(bia_evl_ed_dt)){
						mySheet.SetColEditable("max_pmss_ssp_prdc", 0);
						mySheet.SetColEditable("obt_rcvr_ptm_c", 0);
					}else{
						mySheet.SetColEditable("max_pmss_ssp_prdc", 1);
						mySheet.SetColEditable("obt_rcvr_ptm_c", 1);
					}
					mySheet.SetCellValue(i, "chrg_empnm_s", '<div class="input-group w100"><input type="text" id="chrg_empnm'+i+'" class="form-control" name="chrg_empnm" disabled ><span class="input-group-btn"><button class="btn btn-default ico search" type="button" onclick="orgEmpPopup('+i+');"><i class="fa fa-search"></i><span class="blind"></span></button></span></div>');
					$('#chrg_empnm'+i).val(mySheet.GetCellValue(i,"chrg_empnm"));
				}
				
				$("#bia_evl_prg").text(mySheet.GetCellValue(mySheet.GetDataFirstRow(), "bia_evl_prg"));
			}
			
			tooltip();
			tooltip2();
			tooltip3();
		}
		
		function biaEvl(Row){
			
			$("#bia_evl_prg_stsc").val(mySheet.GetCellValue(Row, "bia_evl_prg_stsc"));
			$("#st_bia_yy").val(mySheet.GetCellValue(Row, "bia_yy"));
			$("#hd_bsn_prss_c").val(mySheet.GetCellValue(Row, "bsn_prss_c"));
			$("#max_pmss_ssp_prdc").val(mySheet.GetCellValue(Row, "max_pmss_ssp_prdc"));
			
			
			showLoadingWs();	
			//$("#ifrLossAdd").attr("src","about:blank");
			$("#winBiaEvl").show();
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="bcp";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORBC010401";
			f.target = "ifrBiaEvl";
			f.submit();
			
		}
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장하였습니다.");  // 저장 성공 메시지
		        doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        doAction('search');
		    }
		}
		
		function evlCom(){
			if($("#bcp_menu_dsc").val()=="1"){
				$("#sch_bia_evl_prg_stsc").val("03");
			}else if($("#bcp_menu_dsc").val()=="3"){
				$("#sch_bia_evl_prg_stsc").val("04");
			}
			var com = true;
			var bia_evl_ed_dt = $("#bia_evl_ed_dt").val();
			bia_evl_ed_dt = bia_evl_ed_dt.replace(/-/gi, '');
			var today = $("#today").val();
			
			if(mySheet.GetDataFirstRow()>0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i,"ischeck")==1){
						if(mySheet.GetCellValue(i, "max_pmss_ssp_prdc")==""){
							alert("최대 허용 중단기간을 선택해주세요.");
							com = false;
							return;
						}
						if(mySheet.GetCellValue(i, "obt_rcvr_ptm_c")==""){
							alert("목표 복구시점을 선택해주세요.");
							com = false;
							return;
						}
						if($("#bcp_menu_dsc").val()=="1" && mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="02"){
							alert("진행상태를 확인해주세요.");
							com = false;
							return;
						}
						if($("#bcp_menu_dsc").val()=="3" && mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="03"){
							alert("진행상태가 팀장 결재중인 항목만 결재가 가능합니다.");
							com = false;
							return;
						}
						if(mySheet.GetCellValue(i, "count")>"1"){
							alert((i-1)+"행의 업무 유형 중요도 평가를 중복 선택하셨습니다.");
							com = false;
							return;
						}
						if(mySheet.GetCellValue(i, "count2")>"1"){
							alert((i-1)+"행의 업무 중단시 영향도 평가를 중복 선택하셨습니다.");
							com = false;
							return;
						}
						if(mySheet.GetCellValue(i, "count")=="0"){
							alert((i-1)+"행의 업무 유형 중요도 평가를 선택해주세요.");
							com = false;
							return;
						}
						if(mySheet.GetCellValue(i, "count2")=="0"){
							alert((i-1)+"행의 업무 중단시 영향도 평가를 선택해주세요.");
							com = false;
							return;
						}
					}
				}
				
				if(com){
					if( parseInt(today) <= parseInt(bia_evl_ed_dt) ){
						var f = document.ormsForm;
						var add_html = "";
						if(mySheet.GetDataFirstRow()>=0){
							for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
								if(mySheet.GetCellValue(j,"ischeck")==1){
									add_html += "<input type='hidden' name='bsn_prss_c' value='" + mySheet.GetCellValue(j,"bsn_prss_c") + "'>";
									$("#bas_ym").val(mySheet.GetCellValue(j, "bas_ym"));
								}
							}
						}

						alert(add_html);			
						
						if(add_html==""){
							alert("결재할 항목을 선택하세요.");
							return;
						}

			            tmp_area.innerHTML = add_html;
						var f = document.ormsForm;
						if(!confirm("선택한 항목을 결재 하시겠습니까?")) return;
						
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "bcp");
						WP.setParameter("process_id", "ORBC010305");
						WP.setForm(f);
						
						var url = "<%=System.getProperty("contextpath")%>/comMain.do";
						var inputData = WP.getParams();
						
						//alert(inputData);
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
						    {
							  success: function(result){
								  if(result != 'undefined' && result.rtnCode== 'S'){
									  alert(result.rtnMsg);
									  doAction('search');
								  }
								  
							  },
							  
							  complete: function(statusText,status){
								  removeLoadingWs();
								  doAction('search');
							  },
							  
							  error: function(rtnMsg){
								  alert(JSON.stringify(rtnMsg));
							  }
						    }
						);	
					}else{
						alert("평가일정 외에는 평가 할 수 없습니다.");
					}
				}
			}
		}
		
		function save(){
			var bia_evl_ed_dt = $("#bia_evl_ed_dt").val();
			bia_evl_ed_dt = bia_evl_ed_dt.replace(/-/gi, '');
			var today = $("#today").val();
			
			for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
				if(mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="02"){
					alert("이미 평가완료 되었습니다.");
					return;
				}
				if(mySheet.GetCellValue(i, "count")!="1"){
					alert((i-1)+"행의 업무 유형 중요도 평가를 중복 선택하셨습니다.");
					return;
				}
				if(mySheet.GetCellValue(i, "count2")!="1"){
					alert((i-1)+"행의 업무 중단시 영향도 평가를 중복 선택하셨습니다.");
					return;
				}
			}
			
			if( parseInt(today) <= parseInt(bia_evl_ed_dt) ){
				mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=bcp&process_id=ORBC010303&mode=1");
			}else{
				alert("평가일정 외에는 평가 할 수 없습니다.");
			}
		}
		
		
		function tooltip(){
			
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");  
			WP.setParameter("process_id", "ORBC010202"); 
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
							
							var tooltip = "[도움말 내용] <br>"+
										  rList[0].bcp_bsn_tpnm+" : "+rList[0].bcp_bsn_tp_cntn+"<br>"+
										  rList[1].bcp_bsn_tpnm+" : "+rList[1].bcp_bsn_tp_cntn+"<br>"+
										  rList[2].bcp_bsn_tpnm+" : "+rList[2].bcp_bsn_tp_cntn+"<br>"+
										  rList[3].bcp_bsn_tpnm+" : "+rList[3].bcp_bsn_tp_cntn+"<br>"+
										  rList[4].bcp_bsn_tpnm+" : "+rList[4].bcp_bsn_tp_cntn;
							
							
							mySheet.SetToolTipText(0, "bsn_coic_ox1", tooltip);
							mySheet.SetToolTipText(1, "bsn_coic_ox1", tooltip);
							mySheet.SetToolTipText(1, "bsn_coic_ox2", tooltip);
							mySheet.SetToolTipText(1, "bsn_coic_ox3", tooltip);
							mySheet.SetToolTipText(1, "bsn_coic_ox4", tooltip);
							mySheet.SetToolTipText(1, "bsn_coic_ox5", tooltip);
						   
					  }
						  
				  },
				  
				  complete: function(statusText,status){
					  
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);	
		}
		
		function tooltip2(){
			
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");  
			WP.setParameter("process_id", "ORBC010203"); 
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
							
							var tooltip = "[도움말 내용] <br>"+
										  rList[0].bcp_ifn_dsnm+" : "+rList[0].bcp_ifn_ds_cntn+"<br>"+
										  rList[1].bcp_ifn_dsnm+" : "+rList[1].bcp_ifn_ds_cntn+"<br>"+
										  rList[2].bcp_ifn_dsnm+" : "+rList[2].bcp_ifn_ds_cntn+"<br>"+
										  rList[3].bcp_ifn_dsnm+" : "+rList[3].bcp_ifn_ds_cntn+"<br>"+
										  rList[4].bcp_ifn_dsnm+" : "+rList[4].bcp_ifn_ds_cntn;
							
							
							mySheet.SetToolTipText(0, "ifn_coic_ox1", tooltip);
							mySheet.SetToolTipText(1, "ifn_coic_ox1", tooltip);
							mySheet.SetToolTipText(1, "ifn_coic_ox2", tooltip);
							mySheet.SetToolTipText(1, "ifn_coic_ox3", tooltip);
							mySheet.SetToolTipText(1, "ifn_coic_ox4", tooltip);
							mySheet.SetToolTipText(1, "ifn_coic_ox5", tooltip);
						   
					  }
						  
				  },
				  
				  complete: function(statusText,status){
					  
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);	
		}
		
		function tooltip3(){
			var tooltip = "[도움말 내용] <br>"+
						  "해당 업무프로세스가 중단되었을 경우 <br> 담당자의 관점으로 최대 중단허용 가능한 주관적 기좐을 선택";
			var tooltip2 = "[도움말 내용] <br>"+
						   "해당업무에 필요한 칠수정보가 있는 경우 <br> 해당 중요정보가 백업되야 하는 시점을 선택";
						   
			mySheet.SetToolTipText(0, "max_pmss_ssp_prdc", tooltip);
			mySheet.SetToolTipText(0, "obt_rcvr_ptm_c", tooltip2);
		}
		
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<div class="container">
		<!--.page header //-->
	<%@ include file="../comm/header.jsp" %>
		<div class="content"><!-- content -->
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="bcp_menu_dsc" name="bcp_menu_dsc" />
				<input type="hidden" id="today" name="today" value="<%=dt %>" />
				<input type="hidden" id="hd_bsn_prss_c" name="hd_bsn_prss_c" />
				<input type="hidden" id="max_pmss_ssp_prdc" name="max_pmss_ssp_prdc" />
				<input type="hidden" id="mode" name="mode" />
				<input type="hidden" id="bia_evl_prg_stsc" name="bia_evl_prg_stsc" />
				<input type="hidden" id="sch_bia_evl_prg_stsc" name="sch_bia_evl_prg_stsc" />
				<input type="hidden" id="sel_index" name="sel_index" />
				<input type="hidden" id="sch_vlr_eno" name="sch_vlr_eno" />
				<input type="hidden" id="sch_bsn_prss_c" name="sch_bsn_prss_c" />
				<input type="hidden" id="tmp_area" name="tmp_area" />
				<input type="hidden" id="add_html" name="add_html" />
				<input type="hidden" id="bas_ym" name="bas_ym" />
				<input type="hidden" id="bas_yy" name="bas_yy" />
				
				<div id="stsc"></div>
				
			<div class="box box-search"><!-- 조회 -->
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가회차</th>
									<td>
										<div class="select w100">
											<select class="form-control" id="st_bia_yy" name="st_bia_yy" >
<%
for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
%>
										   		<option value="<%=(String)hMap.get("bia_yy")%>"><%=(String)hMap.get("bia_yy")%></option>
<%
}
%>															
											</select>
										</div>
									</td>
									<th>업무프로세스</th>
									<td>
										<div class="input-group w200">
											<input type="text" class="form-control" id="sch_prss_nm" name="sch_prss_nm" disabled />
											<input type="hidden" id="sch_prss_c" name="sch_prss_c" >
											<span class="input-group-btn">
											<button class="btn btn-default ico search" type="button" onclick="prss_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											</span>
										</div>
									</td>
									<th>설문입력여부</th>
									<td>
										<div class="select w80">
											<select class="form-control" id="st_qsn_rg_yn" name="st_qsn_rg_yn">
												<option value="">전체</option>
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
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:search();">조회</button>
				</div>
			</div><!-- //조회 -->
			</form>
			
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="title">
						평가일정 :
						<strong>2021-02-15 ~ 2021-02-27</strong>
						<span class="ph2 tag t1 txt txt-sm">진행중</span>
					</h2>
				</div>
				<div class="box-body">
					<div class="wrap-grid h550">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<%if(bcp_menu_dsc.equals("1")||bcp_menu_dsc.equals("3")) {%>
						<button type="button" class="btn btn-primary" onclick="dcz_popup(1);">
							<span class="txt">결재</span>
						</button>
						<%}else if(bcp_menu_dsc.equals("2")) {%>
						<button type="button" class="btn btn-primary" onclick="javascript:save();">
							<span class="txt">저장</span>
						</button>
						<%} %>
					</div>
				</div>
			</section>
		</div>
		<!-- content //-->
		
	</div><!-- .container //-->
	<!-- popup //-->
	<div id="winBiaEvl" class="popup modal">
		<iframe name="ifrBiaEvl" id="ifrBiaEvl" src="about:blank"></iframe>	
	</div>	
	<iframe name="ifrDummy" id="ifrDummy" src="about:blank"></iframe>
	
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
	<%@ include file="../comm/OrgEmpInfP.jsp" %> <!-- 부서별직원 공통 팝업 -->
	<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
		
	<script>
	// 업무프로세스검색 완료
	var PRSS4_ONLY = true; 
	var CUR_BSN_PRSS_C = "";
	
	function prss_popup(){
		CUR_BSN_PRSS_C = $("#sch_prss_c").val();
		if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
		schPrssPopup();
	}
	
	function prssSearchEnd(bsn_prss_c, bsn_prsnm
						, bsn_prss_c_lv1, bsn_prsnm_lv1
						, bsn_prss_c_lv2, bsn_prsnm_lv2
						, bsn_prss_c_lv3, bsn_prsnm_lv3
						, biz_trry_c_lv1, biz_trry_cnm_lv1
						, biz_trry_c_lv2, biz_trry_cnm_lv2){
		$("#sch_prss_c").val(bsn_prss_c);
		$("#sch_prss_nm").val(bsn_prsnm);
		
		$("#winPrss").hide();
	}		
	//부서별직원조회 팝업 호출
	function orgEmpPopup(sel_index){
		$("#sel_index").val(sel_index);
		if($("#bcp_menu_dsc").val() == '1'){
		}else{
			alert('bcp업무 담당자만 담당자 지정이 가능합니다.');	
			return;
		}
		schOrgEmpPopup("orgEmpSearchEnd", 1);
		//$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
	}
	
	// 부서별직원검색 완료
	function orgEmpSearchEnd(eno, enm){
		var sel_index = $("#sel_index").val();
		//mySheet.SetCellText(sel_index, "vlr_eno", eno);
		//$("#chrg_empnm"+sel_index).val(enm);
		closeBuseoEmp();
		
		$('#sch_vlr_eno').val(eno);
		$('#sch_bsn_prss_c').val(mySheet.GetCellValue(sel_index,"bsn_prss_c"));
		doAction('save1');
		doAction('search');
		//$("#winBuseoEmp").hide();
		//doAction('search');
	}
	
	function orgEmp_remove(){
		$("#emp_no").val("");
		$("#emp_nm").val("");
	}
<%-- 부서별직원 끝 --%>		
		
<%-- 결재 시작 --%>			
//결재 팝업 호출
function dcz_popup(auth){
	var cnt=0;
	var temp=null;
	for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
		if(mySheet.GetCellValue(j,"ischeck")==1){
			cnt++;
			temp = mySheet.GetCellValue(j,"bsn_prss_c");
		}
	}
	if(cnt == 1) {
		$("#bsn_prss_c").val(temp);
	}
	else if(cnt == 0) {
		alert('하나 이상의 항목을 선택해주세요.');
		$("#bsn_prss_c").val(null);
		return;
	}else{
		$("#bsn_prss_c").val(null);
	}
	schDczPopup(auth);
}

// 결재검색 완료
function DczSearchEndCmp(){
	javascript:evlCom();
	closeDczP();
}
function DczSearchEndRtn(){
	doAction('rtn');
	closeDczP();
}
<%-- 결재 끝 --%>
	</script>
</body>
</html>