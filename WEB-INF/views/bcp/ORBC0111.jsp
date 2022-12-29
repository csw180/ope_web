<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0111.jsp
 Program name : RA 일정변경(팝업)
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

Vector vLst2 = CommUtil.getCommonCode(request, "RA_X_RSNC"); //제외사유 코드 조회(공통코드)
if(vLst2==null) vLst2 = new Vector();
String ra_x_rsnc = "";
String ra_x_rsnm = "";

for(int i=0; i<vLst2.size(); i++){
	HashMap hMap = (HashMap)vLst2.get(i);
	if(ra_x_rsnc==""){
		ra_x_rsnc += (String)hMap.get("intgc");
		ra_x_rsnm += (String)hMap.get("intg_cnm");
	}else{
		ra_x_rsnc += ("|" + (String)hMap.get("intgc"));
		ra_x_rsnm += ("|" + (String)hMap.get("intg_cnm"));
	}
}

Calendar cal = Calendar.getInstance();
/* 회차정보 미존재시 현재 년월을 사용하기 위해서 20210715 추가*/

HashMap hLstMap = null;
if(vLst.size()>0){
	hLstMap = (HashMap)vLst.get(0);
}else{
	hLstMap = new HashMap();
}
String bas_ym = (String)hLstMap.get("bas_ym");
String bas_yy = (String)hLstMap.get("ra_yy");


String year = "";

year = String.valueOf(cal.get(Calendar.YEAR));
/* 1년에 한번만 하는 평가로 cal 사용 해서 년도 get 20210716*/


System.out.println("year : "+year);

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd


String sdt = dt.substring(0,4)+"-"+dt.substring(4,6)+"-"+dt.substring(6,8);
int mm  = Integer.parseInt(dt.substring(4,6));
String dd = "";

switch(mm){
	case 1:
	case 3:
	case 5:
	case 7:
	case 8:
	case 10:
	case 12:
		dd = "31";
		break;
	case 2:
		dd = "28";
		break;
	case 4:	
	case 6:	
	case 9:	
	case 11:
		dd = "30";
		break;
		
}

String edt = dt.substring(0,4)+"-"+dt.substring(4,6)+"-"+dd;

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
		});
		
		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"상태|상태",							Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",				Hidden:false},
				{Header:"기준년|기준년",						Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bas_ym",				Hidden:true},
				{Header:"위험코드|위험코드",						Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"rsk_c",				Hidden:true},
				{Header:"위험대분류|위험대분류",					Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"f_pfrnm", 			Edit:0},
				{Header:"위험중분류|위험중분류",					Type:"Text",	MinWidth:70,	Align:"Left",		SaveName:"s_pfrnm", 			Edit:0},
				{Header:"위험명|위험명",						Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"rsk_pfrnm", 			Edit:0},
				{Header:"업무중단 유발 시나리오|사업장\n접근 불가",	Type:"Text",	Width:50,	Align:"Center",		SaveName:"bzpl_acs_imp_yn", 		Hidden:true},
				{Header:"업무중단 유발 시나리오|인력손실 및\n손상",	Type:"Text",	Width:50,	Align:"Center",		SaveName:"hmrs_lss_yn", 			Hidden:true},
				{Header:"업무중단 유발 시나리오|중요자원\n손상",		Type:"Text",	Width:50,	Align:"Center",		SaveName:"ipt_resc_ipmt_yn", 		Hidden:true},
				{Header:"업무중단 유발 시나리오|시스템\n사용불가",		Type:"Text",	Width:50,	Align:"Center",		SaveName:"sys_ug_imp_yn", 			Hidden:true},
				{Header:"업무중단 유발 시나리오|대내외\n지원 중단",	Type:"Text",	Width:50,	Align:"Center",		SaveName:"dofe_spt_ssp_yn", 		Hidden:true},
				{Header:"업무중단 유발 시나리오|사업장\n접근 불가",	Type:"Text",	Width:50,	Align:"Center",		SaveName:"bzpl_acs_imp_ox", 		Edit:0},//11
				{Header:"업무중단 유발 시나리오|인력손실 및\n손상",	Type:"Text",	Width:50,	Align:"Center",		SaveName:"hmrs_lss_ox", 			Edit:0},
				{Header:"업무중단 유발 시나리오|중요자원\n손상",		Type:"Text",	Width:50,	Align:"Center",		SaveName:"ipt_resc_ipmt_ox", 		Edit:0},
				{Header:"업무중단 유발 시나리오|시스템\n사용불가",		Type:"Text",	Width:50,	Align:"Center",		SaveName:"sys_ug_imp_ox", 			Edit:0},
				{Header:"업무중단 유발 시나리오|대내외\n지원 중단",	Type:"Text",	Width:50,	Align:"Center",		SaveName:"dofe_spt_ssp_ox", 		Edit:0},
				{Header:"BCP\n관리 대상|BCP\n관리 대상",			Type:"Combo",	MinWidth:30,	Align:"Center",		SaveName:"bcp_amn_obj_yn",		ComboText:"Y|N",			ComboCode:"Y|N"},
				{Header:"제외 사유|제외 사유",					Type:"Combo",	MinWidth:100,	Align:"Left",		SaveName:"ra_x_rsnc",			ComboText:"<%=ra_x_rsnm %>",ComboCode:"<%=ra_x_rsnc %>"},
				{Header:"제외 사유내용|제외 사유내용",				Type:"Text",	MinWidth:70,	Align:"Left",		SaveName:"x_rsnctt", Hidden:true,	Edit:0},
				{Header:"RA결재상태코드|RA결재상태코드",					Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"ra_dcz_stsc",		Hidden:true},
				{Header:"위험요소 관리팀|평가대상팀",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"brnm",			Edit:0},
				{Header:"위험요소 관리팀|평가자 사번",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"eno",			Edit:0, Hidden:true},
				{Header:"위험요소 관리팀|평가 담당자",					Type:"Html",	MinWidth:130,		Align:"Center",		SaveName:"chrg_empnm_s",			Edit:0},
				{Header:"위험요소 관리팀|평가 담당자",					Type:"Text",	MinWidth:130,		Align:"Center",		SaveName:"chrg_empnm",			Edit:0, Hidden:true}
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
			//mySheet.PopupButtonImage(2, 10, "/image/ic_popup.gif"); 


			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
			doAction('search');
			
		}
		
		/* Sheet 기본 설정 */
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/* Sheet 각종 처리 */
		function doAction(sAction){
			switch(sAction){
				case "search": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011102");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "save":
					var sdt = $("#ra_evl_st_dt").val();
					var edt = $("#ra_evl_ed_dt").val();
					var today = $("#today").val();
					sdt = sdt.replace(/-/gi, ''); 
					edt = edt.replace(/-/gi, ''); 
						
					if((sdt<edt) && (today<sdt)){
						save();
					}else if((edt<sdt) && (today<sdt)){
						alert("수행종료일이 시작일 보다 빠를 수 없습니다.");
						return;
						
					}else if((sdt<edt) && (sdt<=today)){
						alert("수행시작일이 당일 혹은 지난일 신청은 불가능 합니다.");
						return;
					}else{
						alert("잘못된 접근 입니다.");
						return;
					}
					break;
				case "save1": //팀bcp담당자-평가담당자 지정
					
					var f = document.ormsForm;
					if(!confirm("담당자를 저장하시겠습니까?")) return; 
					
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "bcp");
					WP.setParameter("process_id", "ORBC011106");
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
		function save(){
			var f = document.ormsForm;
			var html = "";
			var blank = "";
			
			if(mySheet.GetDataFirstRow()>0){
				
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j, "status")=="U"){
							html += "<input type='hidden' name='status' 			value='" 	+ mySheet.GetCellValue(j,"status") 			+ "'>";
							html += "<input type='hidden' name='ra_sc' 				value='" 	+ mySheet.GetCellValue(j,"ra_sc") 				+ "'>";
							html += "<input type='hidden' name='rsk_c' 				value='" 	+ mySheet.GetCellValue(j,"rsk_c") 				+ "'>";
							html += "<input type='hidden' name='bzpl_acs_imp_yn' 	value='" 	+ mySheet.GetCellValue(j,"bzpl_acs_imp_yn") 	+ "'>";
							html += "<input type='hidden' name='hmrs_lss_yn' 		value='" 	+ mySheet.GetCellValue(j,"hmrs_lss_yn") 		+ "'>";
							html += "<input type='hidden' name='ipt_resc_ipmt_yn' 	value='" 	+ mySheet.GetCellValue(j,"ipt_resc_ipmt_yn") 	+ "'>";
							html += "<input type='hidden' name='sys_ug_imp_yn' 		value='" 	+ mySheet.GetCellValue(j,"sys_ug_imp_yn") 		+ "'>";
							html += "<input type='hidden' name='dofe_spt_ssp_yn' 	value='" 	+ mySheet.GetCellValue(j,"dofe_spt_ssp_yn") 	+ "'>";
							html += "<input type='hidden' name='bcp_amn_obj_yn' 	value='" 	+ mySheet.GetCellValue(j,"bcp_amn_obj_yn") 	+ "'>";
							html += "<input type='hidden' name='ra_x_rsnc' 			value='" 	+ mySheet.GetCellValue(j,"ra_x_rsnc") 			+ "'>";
							html += "<input type='hidden' name='x_rsnctt' 			value='" 	+ mySheet.GetCellValue(j,"x_rsnctt") 			+ "'>";
							if(mySheet.GetCellValue(j, "natv_rsk_evl_scr")!="NA"){
								html += "<input type='hidden' name='natv_rsk_evl_scr' 	value='" 	+ mySheet.GetCellValue(j,"natv_rsk_evl_scr") 	+ "'>";
							}else{
								html += "<input type='hidden' name='natv_rsk_evl_scr' 	value='" 	+ blank 	+ "'>";
							}
							
							if(mySheet.GetCellValue(j, "rsk_ctl_suv_cntn")!="NA"){
								html += "<input type='hidden' name='rsk_ctl_suv_cntn' 	value='" 	+ mySheet.GetCellValue(j,"rsk_ctl_suv_cntn") 	+ "'>";
							}else{
								html += "<input type='hidden' name='rsk_ctl_suv_cntn' 	value='" 	+ blank 	+ "'>";
							}
							
							if(mySheet.GetCellValue(j, "rsk_mtg_act_cntn")!="NA"){
								html += "<input type='hidden' name='rsk_mtg_act_cntn' 	value='" 	+ mySheet.GetCellValue(j,"rsk_mtg_act_cntn")	+ "'>";
							}else{
								html += "<input type='hidden' name='rsk_mtg_act_cntn' 	value='" 	+ blank	+ "'>";
							}
							
							if(mySheet.GetCellValue(j, "rm_rsk_evl_scr")!="0.0"){
								html += "<input type='hidden' name='rm_rsk_evl_scr' 	value='" 	+ mySheet.GetCellValue(j,"rm_rsk_evl_scr") 	+ "'>";
							}else{
								html += "<input type='hidden' name='rm_rsk_evl_scr' 	value='" 	+ blank 	+ "'>";
							}
							
							html += "<input type='hidden' name='rm_rsk_grd_c' 		value='" 	+ mySheet.GetCellValue(j,"rm_rsk_grd_c") 		+ "'>";
						}
					}
				}
			
			bcp_html.innerHTML = html;
			if(!confirm("저장하시겠습니까?")) return;
			

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC011104");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("처리되었습니다.");
							removeLoadingWs();
							doAction('search2');
					        doAction('search');
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						//closePop();
						//parent.doAction('search');
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});				
		}
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("RA 평가 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			if(mySheet.GetDataFirstRow()>0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					//업무중단 유발 시나리오
					if(mySheet.GetCellValue(i, "bzpl_acs_imp_yn")=="Y"){
						mySheet.SetCellValue(i, "bzpl_acs_imp_ox", "O");
					}else{
						mySheet.SetCellValue(i, "bzpl_acs_imp_ox", "X");
					}
					if(mySheet.GetCellValue(i, "hmrs_lss_yn")=="Y"){
						mySheet.SetCellValue(i, "hmrs_lss_ox", "O");
					}else{
						mySheet.SetCellValue(i, "hmrs_lss_ox", "X");
					}
					if(mySheet.GetCellValue(i, "ipt_resc_ipmt_yn")=="Y"){
						mySheet.SetCellValue(i, "ipt_resc_ipmt_ox", "O");
					}else{
						mySheet.SetCellValue(i, "ipt_resc_ipmt_ox", "X");
					}
					if(mySheet.GetCellValue(i, "sys_ug_imp_yn")=="Y"){
						mySheet.SetCellValue(i, "sys_ug_imp_ox", "O");
					}else{
						mySheet.SetCellValue(i, "sys_ug_imp_ox", "X");
					}
					if(mySheet.GetCellValue(i, "dofe_spt_ssp_yn")=="Y"){
						mySheet.SetCellValue(i, "dofe_spt_ssp_ox", "O");
					}else{
						mySheet.SetCellValue(i, "dofe_spt_ssp_ox", "X");
					}
					
					if(mySheet.GetCellValue(i, "ra_dcz_stsc")!="01"){
						/*
	 					if(mySheet.GetCellValue(i, "natv_rsk_evl_scr")==""){
							mySheet.SetCellValue(i, "natv_rsk_evl_scr", "NA");
						}
						if(mySheet.GetCellValue(i, "rsk_ctl_suv_cntn")==""){
							mySheet.SetCellValue(i, "rsk_ctl_suv_cntn", "NA");
						}
						if(mySheet.GetCellValue(i, "rsk_mtg_act_cntn")==""){
							mySheet.SetCellValue(i, "rsk_mtg_act_cntn", "NA");
						}
						*/
					}
					
					if(mySheet.GetCellValue(i, "ra_x_rsnc")!="04"){
						mySheet.SetCellEditable(i, "x_rsnctt", 0);
					}
					if(mySheet.GetCellValue(i, "ra_dcz_stsc")!="01"){
						mySheet.SetCellEditable(i, "bcp_amn_obj_yn", 0);
						mySheet.SetCellEditable(i, "ra_x_rsnc", 0);
						mySheet.SetCellEditable(i, "rm_rsk_evl_scr", 0);
						mySheet.SetCellEditable(i, "rsk_ctl_suv_cntn", 0);
						mySheet.SetCellEditable(i, "rsk_mtg_act_cntn", 0);
					}
					if(mySheet.GetCellValue(i, "bcp_amn_obj_yn")=="Y"){
						mySheet.SetCellEditable(i, "ra_x_rsnc", 0);
					}else if(mySheet.GetCellValue(i, "bcp_amn_obj_yn")=="N"){
						mySheet.SetCellEditable(i, "rm_rsk_evl_scr", 0);
					}
					
					mySheet_OnChange(i,  mySheet.SaveNameCol("bcp_amn_obj_yn")) ;
					
					mySheet.SetCellValue(i, "status", "");
					
					mySheet.SetCellValue(i, "chrg_empnm_s", '<div class="input-group w100"><input type="text" id="chrg_empnm'+i+'" class="form-control" name="chrg_empnm" disabled ><span class="input-group-btn"><button class="btn btn-default ico search" type="button" onclick="orgEmpPopup('+i+');"><i class="fa fa-search"></i><span class="blind"></span></button></span></div>');
					$('#chrg_empnm'+i).val(mySheet.GetCellValue(i,"chrg_empnm"));
				}
			}
			
		}
		
		function mySheet_OnPopupClick(Row,Col){
			/*위험통제현황*/
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="rsk_ctl_suv_cntn" && mySheet.GetCellValue(Row, "bcp_amn_obj_yn")=="Y"){
				$("#hd_rsk_c").val(mySheet.GetCellValue(Row, "rsk_c"));
				$("#hd_rsk_ctl_suv_cntn").val(mySheet.GetCellValue(Row, "rsk_ctl_suv_cntn"));
				doAction('rskCtl');
			}
			/*위험경감조치*/
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="rsk_mtg_act_cntn" && mySheet.GetCellValue(Row, "bcp_amn_obj_yn")=="Y"){
				$("#hd_rsk_c").val(mySheet.GetCellValue(Row, "rsk_c"));
				$("#hd_rsk_mtg_act_cntn").val(mySheet.GetCellValue(Row, "rsk_mtg_act_cntn"));
				doAction('rskMtg');
			}
			
			/*고유위험평가*/
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="natv_rsk_evl_scr" && mySheet.GetCellValue(Row, "bcp_amn_obj_yn")=="Y" ){
				$("#hd_rsk_c").val(mySheet.GetCellValue(Row, "rsk_c"));
				$("#hd_f_pfrnm").val(mySheet.GetCellValue(Row, "f_pfrnm"));
				$("#hd_rsk_pfrnm").val(mySheet.GetCellValue(Row, "rsk_pfrnm"));
				$("#hd_ra_dcz_stsc").val(mySheet.GetCellValue(Row, "ra_dcz_stsc"));
				$("#hd_bcp_04_0").val(mySheet.GetCellValue(Row,  "bzpl_acs_imp_yn"));
				$("#hd_bcp_04_1").val(mySheet.GetCellValue(Row,  "hmrs_lss_yn"));
				$("#hd_bcp_04_2").val(mySheet.GetCellValue(Row,  "ipt_resc_ipmt_yn"));
				$("#hd_bcp_04_3").val(mySheet.GetCellValue(Row,  "sys_ug_imp_yn"));
				$("#hd_bcp_04_4").val(mySheet.GetCellValue(Row,  "dofe_spt_ssp_yn"));
				
				doAction('evlScr');
			}

		}
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType){
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			
			/*잔여위험평가점수*/
			if(mySheet.GetCellValue(Row, "rm_rsk_evl_scr")==""){
				$("#hd_rm_rsk_evl_scr").val(mySheet.GetCellValue(Row, "rm_rsk_evl_scr"));
				$("#hd_rsk_c").val(mySheet.GetCellValue(Row, "rsk_c"));
			}
			//alert(Row);
			if(mySheet.GetCellValue(Row, "ra_dcz_stsc")=="01"){
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bzpl_acs_imp_ox" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "bzpl_acs_imp_yn", "N");
					mySheet.SetCellValue(Row, Col, "X");
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bzpl_acs_imp_ox" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "bzpl_acs_imp_yn", "Y");
					mySheet.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="hmrs_lss_ox" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "hmrs_lss_yn", "N");
					mySheet.SetCellValue(Row, Col, "X");
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="hmrs_lss_ox" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "hmrs_lss_yn", "Y");
					mySheet.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ipt_resc_ipmt_ox" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "ipt_resc_ipmt_yn", "N");
					mySheet.SetCellValue(Row, Col, "X");
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ipt_resc_ipmt_ox" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "ipt_resc_ipmt_yn", "Y");
					mySheet.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="sys_ug_imp_ox" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "sys_ug_imp_yn", "N");
					mySheet.SetCellValue(Row, Col, "X");
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="sys_ug_imp_ox" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "sys_ug_imp_yn", "Y");
					mySheet.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="dofe_spt_ssp_ox" && mySheet.GetCellValue(Row, Col)=="O"){
					mySheet.SetCellValue(Row, "dofe_spt_ssp_yn", "N");
					mySheet.SetCellValue(Row, Col, "X");
				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="dofe_spt_ssp_ox" && mySheet.GetCellValue(Row, Col)=="X"){
					mySheet.SetCellValue(Row, "dofe_spt_ssp_yn", "Y");
					mySheet.SetCellValue(Row, Col, "O");
				}
			}
		}
		
		function mySheet_OnChange(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ra_x_rsnc" && mySheet.GetCellValue(Row, Col)=="04"){
				mySheet.SetCellEditable(Row, "x_rsnctt", 1);
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="ra_x_rsnc" && mySheet.GetCellValue(Row, Col)!="04"){
				mySheet.SetCellEditable(Row, "x_rsnctt", 0);
				mySheet.SetCellValue(Row, "x_rsnctt", "");
			}
			
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bcp_amn_obj_yn" && mySheet.GetCellValue(Row, Col)=="N"){
				mySheet.SetCellEditable(Row, "ra_x_rsnc", 1);
				mySheet.SetCellEditable(Row, "rm_rsk_evl_scr", 0);
				mySheet.SetCellEditable(Row, "natv_rsk_evl_scr", 0);
				mySheet.SetCellEditable(Row, "rsk_ctl_suv_cntn", 0);
				mySheet.SetCellEditable(Row, "rsk_mtg_act_cntn", 0);
				
				//mySheet.SetCellFont("FontUnderline", Row,"natv_rsk_evl_scr",Row,"rsk_mtg_act_cntn",false) ;
				//mySheet.SetColProperty(Row, "natv_rsk_evl_scr", {PopupButton:0});
				//mySheet.PopupButtonImage(2, 10, "/image/ic_popup.gif"); 
				mySheet.SetCellValue(Row, "natv_rsk_evl_scr", "NA");
				mySheet.SetCellValue(Row, "rsk_ctl_suv_cntn", "NA");
				mySheet.SetCellValue(Row, "rsk_mtg_act_cntn", "NA");
				mySheet.SetColProperty(Row, "natv_rsk_evl_scr", {ZeroToReplaceChar:"NA"});
				//mySheet.SetCellValue(Row, "rm_rsk_evl_scr", "NA"); //Float에서는 적용않됨
				mySheet.SetCellValue(Row, "rm_rsk_grdnm", "NA");
				
			}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bcp_amn_obj_yn" && mySheet.GetCellValue(Row, Col)=="Y"){
				mySheet.SetCellValue(Row, "x_rsnctt", "");
				mySheet.SetCellValue(Row, "ra_x_rsnc", "");
				mySheet.SetCellEditable(Row, "x_rsnctt", 0);
				mySheet.SetCellEditable(Row, "ra_x_rsnc", 0);
				mySheet.SetCellEditable(Row, "rm_rsk_evl_scr", 1);
				mySheet.SetCellEditable(Row, "natv_rsk_evl_scr", 1);
				mySheet.SetCellEditable(Row, "rsk_ctl_suv_cntn", 1);
				mySheet.SetCellEditable(Row, "rsk_mtg_act_cntn", 1);
				
				//mySheet.SetColProperty(Row, "natv_rsk_evl_scr", {PopupButton:1});
				//mySheet.SetCellFont("FontUnderline", Row,"natv_rsk_evl_scr",Row,"rsk_mtg_act_cntn",true) ;
				if(mySheet.GetCellValue(Row, "natv_rsk_evl_scr")=="NA")
					mySheet.SetCellValue(Row, "natv_rsk_evl_scr", "");
				if(mySheet.GetCellValue(Row, "rsk_ctl_suv_cntn")=="NA")
					mySheet.SetCellValue(Row, "rsk_ctl_suv_cntn", "");
				if(mySheet.GetCellValue(Row, "rsk_mtg_act_cntn")=="NA")
					mySheet.SetCellValue(Row, "rsk_mtg_act_cntn", "");
				mySheet.SetColProperty(Row, "natv_rsk_evl_scr", {ZeroToReplaceChar:"-"});
				//mySheet.SetColProperty(Row, Col, {ZeroToReplaceChar:"NA"});
				//mySheet.SetCellValue(Row, "rm_rsk_evl_scr", "0");
				if(mySheet.GetCellValue(Row, "rm_rsk_grdnm")=="NA")
					mySheet.SetCellValue(Row, "rm_rsk_grdnm", "");

			}
			
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="rm_rsk_evl_scr" && mySheet.GetCellValue(Row, Col)!=""){
				if(mySheet.GetCellValue(Row, "natv_rsk_evl_scr")!=""){
					if( parseFloat(mySheet.GetCellValue(Row, "natv_rsk_evl_scr")) >= parseFloat(mySheet.GetCellValue(Row, "rm_rsk_evl_scr")) ){
						$("#hd_rm_rsk_evl_scr").val(mySheet.GetCellValue(Row, "rm_rsk_evl_scr"));
						$("#hd_rsk_c").val(mySheet.GetCellValue(Row, "rsk_c"));
						insertRskGrd();	
					}else{
						alert("잔류위험평가 점수가 고유위험평가 점수보다 클 수 없습니다.");
						mySheet.SetCellValue(Row, "rm_rsk_evl_scr", "0");
					}
				}else{
					alert("고유위험평가를 완료 해주세요.");
				}
					
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
		<input type="hidden" id="bas_ym" name="bas_ym" value="<%=bas_ym %>" />
		<input type="hidden" id="bas_yy" name="bas_yy" value="<%=bas_yy %>" />
		<input type="hidden" id="sch_ra_yy" name="sch_ra_yy" />
		<input type="hidden" id="sel_index" name="sel_index" />				
		<input type="hidden" id="sch_vlr_eno" name="sch_vlr_eno" />
		<input type="hidden" id="sch_rsk_c" name="sch_rsk_c" />
		<input type="hidden" id="sch_bas_ym" name="sch_bas_ym" />
		
		
		<div id="bcp_html"></div>
	
	<div id="" class="popup modal block">
		<div class="p_frame w1100">

			<div class="p_head">
				<h3 class="title">RA 일정등록 및 BCP 대상 위험 식별</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-grid">						
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col>
									<col style="width: 150px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th>평가년도</th>
										<td>
											<input type="text" class="form-control w100" id="ra_evl_year" name="ra_evl_year" value="<%=(String)hLstMap.get("ra_yy")%>" readonly/>
										</td>
									</tr>							
									<tr>
										<th>수행시작일</th>
										<td>
											<div class="input-group w130">
												<input type="text" class="form-control" id="ra_evl_st_dt" name="ra_evl_st_dt" value="<%=(String)hLstMap.get("ra_evl_st_dt") %>" readonly/>
												<div class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','ra_evl_st_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</div>
											</div>
										</td>
										
										<th>수행종료일</th>
										<td>
											<div class="input-group w130">
												<input type="text" class="form-control" id="ra_evl_ed_dt" name="ra_evl_ed_dt" value="<%=(String) hLstMap.get("ra_evl_ed_dt") %>" readonly/>
												<div class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','ra_evl_ed_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>등록 및 변경사유</th>
										<td colspan="3">
											<textarea id="ra_schd_upd_rsn" name="ra_schd_upd_rsn" class="textarea h100"><%=(String) hLstMap.get("ra_schd_upd_rsn") %></textarea>
										</td>
									</tr>																
								</tbody>
							</table>
						</div>
					</div>
					<div class="box">
						<div class="row">

							<div class="col">
								<div class="box box-grid">
									<div class="box-header">
										<h4 class="title">BCP 관리대상 위험요소</h4>
									</div>
									<div class="box-body">
										<div class="wrap-grid h300">
											<script> createIBSheet("mySheet", "100%", "100%"); </script>
										</div>
									</div>
								</div>
							</div>

						</div>
					</div>

				</div>
				
			</div>


			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="javascript:doAction('save');">등록</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>

			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>

		</div>
		<div class="dim p_close"></div>
	</div>
	</form>
	<%@ include file="../comm/OrgEmpInfP.jsp" %> <!-- 부서별직원 공통 팝업 -->
	<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
	<script>
	//부서별직원조회 팝업 호출
	function orgEmpPopup(sel_index){
		$("#sel_index").val(sel_index);
		schOrgEmpPopup("orgEmpSearchEnd");
		//$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
	}
	
	// 부서별직원검색 완료
	function orgEmpSearchEnd(eno, enm){
		var sel_index = $("#sel_index").val();
		//mySheet.SetCellText(sel_index, "vlr_eno", eno);
		//$("#chrg_empnm"+sel_index).val(enm);
		closeBuseoEmp();
		
		$('#sch_vlr_eno').val(eno);
		$('#sch_rsk_c').val(mySheet.GetCellValue(sel_index,"rsk_c"));
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
		function closePop(){
			$("#winRaAdd",parent.document).hide();
		}
	</script>
</body>
</html>