<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0107.jsp
 Program name : RA 평가 관리
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

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd 
String today = dt.substring(0,4)+"-"+dt.substring(4,6)+"-"+dt.substring(6,8);
String year = dt.substring(0,4);

String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");  

//제외사유코드 ibsheet Combo 형태로 변환
String ra_x_rsnc = "";
String ra_x_rsnm = "";

String chk_ra_dcz_stsc1 = "01";

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
DynaForm form = (DynaForm)request.getAttribute("form");

String ra_menu_dsc = (String)form.get("ra_menu_dsc");
System.out.println(ra_menu_dsc+"=--=-=-=-=-==--=-==-==-=-");

%>   
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			initIBSheet2();
		});
		
		
		/********************************************************* 
		BIA 평가 관리
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet2(){
			//시트초기화
			mySheet2.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"선택|선택",							Type:"CheckBox",	MinWidth:0,		Align:"Left",		SaveName:"ischeck",				Hidden:false},
				{Header:"RA회차|RA회차",						Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"ra_sc",				Hidden:true},
				{Header:"위험코드|위험코드",						Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"rsk_c",				Hidden:true},
				{Header:"위험대분류|위험대분류",					Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"f_pfrnm", 			Edit:0},
				{Header:"위험중분류|위험중분류",					Type:"Text",	MinWidth:70,	Align:"Left",		SaveName:"s_pfrnm", 			Edit:0},
				{Header:"위험요소|위험요소",						Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"rsk_pfrnm", 			Edit:0},
				{Header:"위험요소 관리팀|평가대상팀",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"brnm",			Edit:0},
				{Header:"위험요소 관리팀|평가자 사번",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"eno",			Edit:0, Hidden:true},
				{Header:"위험요소 관리팀|평가 담당자",					Type:"Text",	MinWidth:130,		Align:"Center",		SaveName:"chrg_empnm",			Edit:0},
				{Header:"BCP\n관리 대상|BCP\n관리 대상",			Type:"Combo",	MinWidth:30,	Align:"Center",		SaveName:"bcp_amn_obj_yn",		ComboText:"Y|N",			ComboCode:"Y|N"},
				{Header:"고유위험\n점수|고유위험\n점수",			Type:"Popup",	MinWidth:70,	Align:"Center",		SaveName:"natv_rsk_evl_scr",		Edit:0},//18
				{Header:"고유위험\n평가 등급|고유위험\n평가 등급",			Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"natv_rsk_grdnm", 	Edit:0},
				{Header:"위험통제현황/위험경감조치 조사|위험통제현황",	Type:"Popup",	MinWidth:70,	Align:"Left",		SaveName:"rsk_ctl_suv_cntn", 		ToolTip:true, Edit:0},
				{Header:"위험통제현황/위험경감조치|위험경감조치",			Type:"Popup",	MinWidth:70,	Align:"Left",		SaveName:"rsk_mtg_act_cntn",ToolTip:true, Edit:0},
				{Header:"잔여위험\n평가 점수\n입력|잔여위험\n평가 점수\n입력",	Type:"Float",	ZeroToReplaceChar:"-", MinWidth:50,	Align:"Center",		SaveName:"rm_rsk_evl_scr",	Format:"0.##0",	MaximumValue:9.9},
				{Header:"잔여위험\n평가 등급|잔여위험\n평가 등급",			Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"rm_rsk_grdnm", 	Edit:0},
				{Header:"잔여위험\n평가 등급코드|잔여위험\n평가 등급코드",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"rm_rsk_grd_c",		Hidden:true},
				{Header:"RA결재상태코드|RA결재상태코드",					Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"ra_dcz_stsc",		Hidden:true},
				{Header:"진행상태|진행상태",							Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status"}
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
			//mySheet2.PopupButtonImage(2, 10, "/image/ic_popup.gif"); 


			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
			doAction('search2');
			
		}	
		function mySheet2_OnPopupClick(Row,Col){
			/*위험통제현황*/
			if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="rsk_ctl_suv_cntn" && mySheet2.GetCellValue(Row, "bcp_amn_obj_yn")=="Y"){
				$("#hd_rsk_c").val(mySheet2.GetCellValue(Row, "rsk_c"));
				$("#hd_rsk_ctl_suv_cntn").val(mySheet2.GetCellValue(Row, "rsk_ctl_suv_cntn"));
				doAction('rskCtl');
			}
			/*위험경감조치*/
			if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="rsk_mtg_act_cntn" && mySheet2.GetCellValue(Row, "bcp_amn_obj_yn")=="Y"){
				$("#hd_rsk_c").val(mySheet2.GetCellValue(Row, "rsk_c"));
				$("#hd_rsk_mtg_act_cntn").val(mySheet2.GetCellValue(Row, "rsk_mtg_act_cntn"));
				doAction('rskMtg');
			}
			
			/*고유위험평가*/
			if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="natv_rsk_evl_scr" && mySheet2.GetCellValue(Row, "bcp_amn_obj_yn")=="Y" ){
				$("#hd_rsk_c").val(mySheet2.GetCellValue(Row, "rsk_c"));
				$("#hd_f_pfrnm").val(mySheet2.GetCellValue(Row, "f_pfrnm"));
				$("#hd_rsk_pfrnm").val(mySheet2.GetCellValue(Row, "rsk_pfrnm"));
				$("#hd_ra_dcz_stsc").val(mySheet2.GetCellValue(Row, "ra_dcz_stsc"));
				$("#hd_bcp_04_0").val(mySheet2.GetCellValue(Row,  "bzpl_acs_imp_yn"));
				$("#hd_bcp_04_1").val(mySheet2.GetCellValue(Row,  "hmrs_lss_yn"));
				$("#hd_bcp_04_2").val(mySheet2.GetCellValue(Row,  "ipt_resc_ipmt_yn"));
				$("#hd_bcp_04_3").val(mySheet2.GetCellValue(Row,  "sys_ug_imp_yn"));
				$("#hd_bcp_04_4").val(mySheet2.GetCellValue(Row,  "dofe_spt_ssp_yn"));
				
				doAction('evlScr');
			}

		}
		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType){
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			
			/*잔여위험평가점수*/
			if(mySheet2.GetCellValue(Row, "rm_rsk_evl_scr")==""){
				$("#hd_rm_rsk_evl_scr").val(mySheet2.GetCellValue(Row, "rm_rsk_evl_scr"));
				$("#hd_rsk_c").val(mySheet2.GetCellValue(Row, "rsk_c"));
			}
			//alert(Row);
			if(mySheet2.GetCellValue(Row, "ra_dcz_stsc")=="01"){
				if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="bzpl_acs_imp_ox" && mySheet2.GetCellValue(Row, Col)=="O"){
					mySheet2.SetCellValue(Row, "bzpl_acs_imp_yn", "N");
					mySheet2.SetCellValue(Row, Col, "X");
				}else if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="bzpl_acs_imp_ox" && mySheet2.GetCellValue(Row, Col)=="X"){
					mySheet2.SetCellValue(Row, "bzpl_acs_imp_yn", "Y");
					mySheet2.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="hmrs_lss_ox" && mySheet2.GetCellValue(Row, Col)=="O"){
					mySheet2.SetCellValue(Row, "hmrs_lss_yn", "N");
					mySheet2.SetCellValue(Row, Col, "X");
				}else if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="hmrs_lss_ox" && mySheet2.GetCellValue(Row, Col)=="X"){
					mySheet2.SetCellValue(Row, "hmrs_lss_yn", "Y");
					mySheet2.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="ipt_resc_ipmt_ox" && mySheet2.GetCellValue(Row, Col)=="O"){
					mySheet2.SetCellValue(Row, "ipt_resc_ipmt_yn", "N");
					mySheet2.SetCellValue(Row, Col, "X");
				}else if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="ipt_resc_ipmt_ox" && mySheet2.GetCellValue(Row, Col)=="X"){
					mySheet2.SetCellValue(Row, "ipt_resc_ipmt_yn", "Y");
					mySheet2.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="sys_ug_imp_ox" && mySheet2.GetCellValue(Row, Col)=="O"){
					mySheet2.SetCellValue(Row, "sys_ug_imp_yn", "N");
					mySheet2.SetCellValue(Row, Col, "X");
				}else if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="sys_ug_imp_ox" && mySheet2.GetCellValue(Row, Col)=="X"){
					mySheet2.SetCellValue(Row, "sys_ug_imp_yn", "Y");
					mySheet2.SetCellValue(Row, Col, "O");
				}
				
				if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="dofe_spt_ssp_ox" && mySheet2.GetCellValue(Row, Col)=="O"){
					mySheet2.SetCellValue(Row, "dofe_spt_ssp_yn", "N");
					mySheet2.SetCellValue(Row, Col, "X");
				}else if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="dofe_spt_ssp_ox" && mySheet2.GetCellValue(Row, Col)=="X"){
					mySheet2.SetCellValue(Row, "dofe_spt_ssp_yn", "Y");
					mySheet2.SetCellValue(Row, Col, "O");
				}
			}
		}
		
		function mySheet2_OnChange(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
			if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="ra_x_rsnc" && mySheet2.GetCellValue(Row, Col)=="04"){
				mySheet2.SetCellEditable(Row, "x_rsnctt", 1);
			}else if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="ra_x_rsnc" && mySheet2.GetCellValue(Row, Col)!="04"){
				mySheet2.SetCellEditable(Row, "x_rsnctt", 0);
				mySheet2.SetCellValue(Row, "x_rsnctt", "");
			}
			
			if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="bcp_amn_obj_yn" && mySheet2.GetCellValue(Row, Col)=="N"){
				mySheet2.SetCellEditable(Row, "ra_x_rsnc", 1);
				mySheet2.SetCellEditable(Row, "rm_rsk_evl_scr", 0);
				mySheet2.SetCellEditable(Row, "natv_rsk_evl_scr", 0);
				mySheet2.SetCellEditable(Row, "rsk_ctl_suv_cntn", 0);
				mySheet2.SetCellEditable(Row, "rsk_mtg_act_cntn", 0);
				
				//mySheet2.SetCellFont("FontUnderline", Row,"natv_rsk_evl_scr",Row,"rsk_mtg_act_cntn",false) ;
				//mySheet2.SetColProperty(Row, "natv_rsk_evl_scr", {PopupButton:0});
				//mySheet2.PopupButtonImage(2, 10, "/image/ic_popup.gif"); 
				mySheet2.SetCellValue(Row, "natv_rsk_evl_scr", "NA");
				mySheet2.SetCellValue(Row, "rsk_ctl_suv_cntn", "NA");
				mySheet2.SetCellValue(Row, "rsk_mtg_act_cntn", "NA");
				mySheet2.SetColProperty(Row, "natv_rsk_evl_scr", {ZeroToReplaceChar:"NA"});
				//mySheet2.SetCellValue(Row, "rm_rsk_evl_scr", "NA"); //Float에서는 적용안됨
				mySheet2.SetCellValue(Row, "rm_rsk_grdnm", "NA");
				
			}else if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="bcp_amn_obj_yn" && mySheet2.GetCellValue(Row, Col)=="Y"){
				mySheet2.SetCellValue(Row, "x_rsnctt", "");
				mySheet2.SetCellValue(Row, "ra_x_rsnc", "");
				mySheet2.SetCellEditable(Row, "x_rsnctt", 0);
				mySheet2.SetCellEditable(Row, "ra_x_rsnc", 0);
				mySheet2.SetCellEditable(Row, "rm_rsk_evl_scr", 1);
				mySheet2.SetCellEditable(Row, "natv_rsk_evl_scr", 1);
				mySheet2.SetCellEditable(Row, "rsk_ctl_suv_cntn", 1);
				mySheet2.SetCellEditable(Row, "rsk_mtg_act_cntn", 1);
				
				//mySheet2.SetColProperty(Row, "natv_rsk_evl_scr", {PopupButton:1});
				//mySheet2.SetCellFont("FontUnderline", Row,"natv_rsk_evl_scr",Row,"rsk_mtg_act_cntn",true) ;
				if(mySheet2.GetCellValue(Row, "natv_rsk_evl_scr")=="NA")
					mySheet2.SetCellValue(Row, "natv_rsk_evl_scr", "");
				if(mySheet2.GetCellValue(Row, "rsk_ctl_suv_cntn")=="NA")
					mySheet2.SetCellValue(Row, "rsk_ctl_suv_cntn", "");
				if(mySheet2.GetCellValue(Row, "rsk_mtg_act_cntn")=="NA")
					mySheet2.SetCellValue(Row, "rsk_mtg_act_cntn", "");
				mySheet2.SetColProperty(Row, "natv_rsk_evl_scr", {ZeroToReplaceChar:"-"});
				//mySheet2.SetColProperty(Row, Col, {ZeroToReplaceChar:"NA"});
				//mySheet2.SetCellValue(Row, "rm_rsk_evl_scr", "0");
				if(mySheet2.GetCellValue(Row, "rm_rsk_grdnm")=="NA")
					mySheet2.SetCellValue(Row, "rm_rsk_grdnm", "");

			}
			
			if(mySheet2.GetCellProperty(Row, Col, "SaveName")=="rm_rsk_evl_scr" && mySheet2.GetCellValue(Row, Col)!=""){
				if(mySheet2.GetCellValue(Row, "natv_rsk_evl_scr")!=""){
					if( parseFloat(mySheet2.GetCellValue(Row, "natv_rsk_evl_scr")) >= parseFloat(mySheet2.GetCellValue(Row, "rm_rsk_evl_scr")) ){
						$("#hd_rm_rsk_evl_scr").val(mySheet2.GetCellValue(Row, "rm_rsk_evl_scr"));
						$("#hd_rsk_c").val(mySheet2.GetCellValue(Row, "rsk_c"));
						//insertRskGrd();	
						var temp = parseFloat(mySheet2.GetCellValue(Row, "rm_rsk_evl_scr"));
						if(temp < 2.5) {
							mySheet2.SetCellValue(Row,"rm_rsk_grdnm","관심");
						}else if (2.5 <= temp < 5) {
							mySheet2.SetCellValue(Row,"rm_rsk_grdnm","주의");
						}else if (5 <= temp <7.5) {
							mySheet2.SetCellValue(Row,"rm_rsk_grdnm","경계");
						}else if (7.5 <= temp <10) {
							mySheet2.SetCellValue(Row,"rm_rsk_grdnm","심각");
						}
					}else{
						alert("잔류위험평가 점수가 고유위험평가 점수보다 클 수 없습니다.");
						mySheet2.SetCellValue(Row, "rm_rsk_evl_scr", "0");
					}
				}else{
					alert("고유위험평가를 완료 해주세요.");
				}
					
			}
		}
		
		function mySheet2_OnRowSearchEnd (Row) {
			var temp = parseFloat(mySheet2.GetCellValue(Row, "rm_rsk_evl_scr"));
			if(temp < 2.5) {
				mySheet2.SetCellValue(Row,"rm_rsk_grdnm","관심");
			}else if (2.5 <= temp < 5) {
				mySheet2.SetCellValue(Row,"rm_rsk_grdnm","주의");
			}else if (5 <= temp <7.5) {
				mySheet2.SetCellValue(Row,"rm_rsk_grdnm","경계");
			}else if (7.5 <= temp <10) {
				mySheet2.SetCellValue(Row,"rm_rsk_grdnm","심각");
			}
			var temp = parseFloat(mySheet2.GetCellValue(Row, "natv_rsk_evl_scr"));
			if(temp < 2.5) {
				mySheet2.SetCellValue(Row,"natv_rsk_grdnm","관심");
			}else if (2.5 <= temp < 5) {
				mySheet2.SetCellValue(Row,"natv_rsk_grdnm","주의");
			}else if (5 <= temp <7.5) {
				mySheet2.SetCellValue(Row,"natv_rsk_grdnm","경계");
			}else if (7.5 <= temp <10) {
				mySheet2.SetCellValue(Row,"natv_rsk_grdnm","심각");
			}
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/* Sheet 각종 처리 */
		function doAction(sAction){
			switch(sAction){
				case "search2": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010703");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
					
				case "rskCtl":
					
					showLoadingWs();
					$("#winRskCtl").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="bcp";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORBC010901";
					f.target = "ifrRskCtl";
					f.submit();						
					
					break;
					
				case "rskMtg":
					
					showLoadingWs();
					$("#winRskMtg").show();
					var f = document.ormsForm;
					f.method.value="Main";
					f.commkind.value="bcp";
					f.action="<%=System.getProperty("contextpath")%>/comMain.do";
					f.process_id.value="ORBC011001";
					f.target = "ifrRskMtg";
					f.submit();
					
					break;
					
				case "evlScr":
					
					//showLoadingWs();
					$("#winEvlScr").show();
					var f = document.ormsForm;
					f.method.value="Main";
					f.commkind.value="bcp";
					f.action="<%=System.getProperty("contextpath")%>/comMain.do";
					f.process_id.value="ORBC010801";
					f.target = "ifrEvlScr";
					f.submit();
					
					break;
					
				case "down2excel":
					var downCols = "1|2|3|4|5|11|12|13|14|15|16|17|18|19|20|21|22|23";
					
					var row = mySheet2.GetSelectRow();
					var ra_sc = mySheet2.GetCellValue(row, "ra_sc")
					
					var titleText = "평가회차 : "+ra_sc+" \r\n\r\n";
					var userMerge = "0,0,2,10";
					
					mySheet2.Down2Excel({FileName:"RA 평가", Merge:1, DownCols:downCols, TitleText:titleText, UserMerge:userMerge})
					
					break;	
					
				case "save":
					var com = true;
					var row = mySheet2.GetSelectRow();
					
					if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="01"&&com){
						$("#number").val("1");
						save();
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="02"){
						alert("이미 상신되었습니다.");
						
						return;
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="03"){
						alert("결재가 완료되었습니다.");
						
						return;
						
					}else{
						alert("잘못된 경로 입니다.");
						
						return;
					}
					
					break;
					
				case "report":
					var com = true;
					var row = mySheet2.GetSelectRow();
					
					if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="01"&&com){
						$("#number").val("2");
						save();
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="02"){
						alert("이미 상신되었습니다.");
						
						return;
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="03"){
						alert("결재가 완료되었습니다.");
						
						return;
						
					}else{
						alert("잘못된 경로 입니다.");
						
						return;
					}
					
					break;
					
				case "approval":
					var row = mySheet2.GetSelectRow();
					if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="02"){
						
						$("#number").val("1");
						app_ret();
						
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="01"){
						
						alert("아직 평가중 입니다.");
						
						return;
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="03"){
						
						alert("결재가 완료되었습니다.");
						
						return;
					}
					
					break;
					
				case "return":
					var row = mySheet2.GetSelectRow();
					if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="02"){
						
						$("#number").val("2");
						app_ret();
						
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="01"){
						
						alert("아직 평가중 입니다.");
						
						return;
					}else if(mySheet2.GetCellValue(row, "ra_dcz_stsc")=="01"){
						
						alert("결재가 완료되었습니다.");
						
						return;
					}
					
					break;
			}
		}
		//잔여위험등급
		<%-- function insertRskGrd(){
			var row = mySheet2.GetSelectRow();
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp"); 
			WP.setParameter("process_id", "ORBC010706");  
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
						   
						   mySheet2.SetCellValue(row, "rm_rsk_grd_c", rList[0].rm_rsk_grd_c);
						   mySheet2.SetCellValue(row, "rm_rsk_grdnm", rList[0].rm_rsk_grdnm);
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
		} --%>
		//신규등록
		function register(){
			var f = document.ormsForm;
			
			if(!confirm("등록하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC010704");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("등록하였습니다.");
							removeLoadingWs();
							select();
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
		function select(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp"); 
			WP.setParameter("process_id", "ORBC010702");  
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
						   var html="";
							
							$("form[name=ormsForm] [id=st_ra_sc]").html("");
							
							for(var i=0;i<rList.length;i++){
								html += '<option value="'+rList[i].ra_sc+'">'+rList[i].ra_tit+'</option>'
							}
							
							$("form[name=ormsForm] [id=st_ra_sc]").html(html);
						   
					  }
						  
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
					  doAction('search2');
					  
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);			
		}
		
		//상신
		function save(){
			var f = document.ormsForm;
			var html = "";
			var blank = "";
			var number = $("#number").val();
			
			if(mySheet2.GetDataFirstRow()>0){
				
				for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
					if(number==1){
						if(mySheet2.GetCellValue(j, "status")=="U"){
							html += "<input type='hidden' name='status' 			value='" 	+ mySheet2.GetCellValue(j,"status") 			+ "'>";
							html += "<input type='hidden' name='ra_sc' 				value='" 	+ mySheet2.GetCellValue(j,"ra_sc") 				+ "'>";
							html += "<input type='hidden' name='rsk_c' 				value='" 	+ mySheet2.GetCellValue(j,"rsk_c") 				+ "'>";
							html += "<input type='hidden' name='bzpl_acs_imp_yn' 	value='" 	+ mySheet2.GetCellValue(j,"bzpl_acs_imp_yn") 	+ "'>";
							html += "<input type='hidden' name='hmrs_lss_yn' 		value='" 	+ mySheet2.GetCellValue(j,"hmrs_lss_yn") 		+ "'>";
							html += "<input type='hidden' name='ipt_resc_ipmt_yn' 	value='" 	+ mySheet2.GetCellValue(j,"ipt_resc_ipmt_yn") 	+ "'>";
							html += "<input type='hidden' name='sys_ug_imp_yn' 		value='" 	+ mySheet2.GetCellValue(j,"sys_ug_imp_yn") 		+ "'>";
							html += "<input type='hidden' name='dofe_spt_ssp_yn' 	value='" 	+ mySheet2.GetCellValue(j,"dofe_spt_ssp_yn") 	+ "'>";
							html += "<input type='hidden' name='bcp_amn_obj_yn' 	value='" 	+ mySheet2.GetCellValue(j,"bcp_amn_obj_yn") 	+ "'>";
							html += "<input type='hidden' name='ra_x_rsnc' 			value='" 	+ mySheet2.GetCellValue(j,"ra_x_rsnc") 			+ "'>";
							html += "<input type='hidden' name='x_rsnctt' 			value='" 	+ mySheet2.GetCellValue(j,"x_rsnctt") 			+ "'>";
							if(mySheet2.GetCellValue(j, "natv_rsk_evl_scr")!="NA"){
								html += "<input type='hidden' name='natv_rsk_evl_scr' 	value='" 	+ mySheet2.GetCellValue(j,"natv_rsk_evl_scr") 	+ "'>";
							}else{
								html += "<input type='hidden' name='natv_rsk_evl_scr' 	value='" 	+ blank 	+ "'>";
							}
							
							if(mySheet2.GetCellValue(j, "rsk_ctl_suv_cntn")!="NA"){
								html += "<input type='hidden' name='rsk_ctl_suv_cntn' 	value='" 	+ mySheet2.GetCellValue(j,"rsk_ctl_suv_cntn") 	+ "'>";
							}else{
								html += "<input type='hidden' name='rsk_ctl_suv_cntn' 	value='" 	+ blank 	+ "'>";
							}
							
							if(mySheet2.GetCellValue(j, "rsk_mtg_act_cntn")!="NA"){
								html += "<input type='hidden' name='rsk_mtg_act_cntn' 	value='" 	+ mySheet2.GetCellValue(j,"rsk_mtg_act_cntn")	+ "'>";
							}else{
								html += "<input type='hidden' name='rsk_mtg_act_cntn' 	value='" 	+ blank	+ "'>";
							}
							
							if(mySheet2.GetCellValue(j, "rm_rsk_evl_scr")!="0.0"){
								html += "<input type='hidden' name='rm_rsk_evl_scr' 	value='" 	+ mySheet2.GetCellValue(j,"rm_rsk_evl_scr") 	+ "'>";
							}else{
								html += "<input type='hidden' name='rm_rsk_evl_scr' 	value='" 	+ blank 	+ "'>";
							}
							
							html += "<input type='hidden' name='rm_rsk_grd_c' 		value='" 	+ mySheet2.GetCellValue(j,"rm_rsk_grd_c") 		+ "'>";
						}
					}else if(number==2){
						html += "<input type='hidden' name='status' 			value='" 	+ mySheet2.GetCellValue(j,"status") 			+ "'>";
						html += "<input type='hidden' name='ra_sc' 				value='" 	+ mySheet2.GetCellValue(j,"ra_sc") 				+ "'>";
						html += "<input type='hidden' name='rsk_c' 				value='" 	+ mySheet2.GetCellValue(j,"rsk_c") 				+ "'>";
						html += "<input type='hidden' name='bzpl_acs_imp_yn' 	value='" 	+ mySheet2.GetCellValue(j,"bzpl_acs_imp_yn") 	+ "'>";
						html += "<input type='hidden' name='hmrs_lss_yn' 		value='" 	+ mySheet2.GetCellValue(j,"hmrs_lss_yn") 		+ "'>";
						html += "<input type='hidden' name='ipt_resc_ipmt_yn' 	value='" 	+ mySheet2.GetCellValue(j,"ipt_resc_ipmt_yn") 	+ "'>";
						html += "<input type='hidden' name='sys_ug_imp_yn' 		value='" 	+ mySheet2.GetCellValue(j,"sys_ug_imp_yn") 		+ "'>";
						html += "<input type='hidden' name='dofe_spt_ssp_yn' 	value='" 	+ mySheet2.GetCellValue(j,"dofe_spt_ssp_yn") 	+ "'>";
						html += "<input type='hidden' name='bcp_amn_obj_yn' 	value='" 	+ mySheet2.GetCellValue(j,"bcp_amn_obj_yn") 	+ "'>";
						html += "<input type='hidden' name='ra_x_rsnc' 			value='" 	+ mySheet2.GetCellValue(j,"ra_x_rsnc") 			+ "'>";
						html += "<input type='hidden' name='x_rsnctt' 			value='" 	+ mySheet2.GetCellValue(j,"x_rsnctt") 			+ "'>";
						if(mySheet2.GetCellValue(j, "natv_rsk_evl_scr")!="NA"){
							html += "<input type='hidden' name='natv_rsk_evl_scr' 	value='" 	+ mySheet2.GetCellValue(j,"natv_rsk_evl_scr") 	+ "'>";
						}else{
							html += "<input type='hidden' name='natv_rsk_evl_scr' 	value='" 	+ blank 	+ "'>";
						}
						
						if(mySheet2.GetCellValue(j, "rsk_ctl_suv_cntn")!="NA"){
							html += "<input type='hidden' name='rsk_ctl_suv_cntn' 	value='" 	+ mySheet2.GetCellValue(j,"rsk_ctl_suv_cntn") 	+ "'>";
						}else{
							html += "<input type='hidden' name='rsk_ctl_suv_cntn' 	value='" 	+ blank 	+ "'>";
						}
						
						if(mySheet2.GetCellValue(j, "rsk_mtg_act_cntn")!="NA"){
							html += "<input type='hidden' name='rsk_mtg_act_cntn' 	value='" 	+ mySheet2.GetCellValue(j,"rsk_mtg_act_cntn")	+ "'>";
						}else{
							html += "<input type='hidden' name='rsk_mtg_act_cntn' 	value='" 	+ blank	+ "'>";
						}
						
						if(mySheet2.GetCellValue(j, "rm_rsk_evl_scr")!="0.0"){
							html += "<input type='hidden' name='rm_rsk_evl_scr' 	value='" 	+ mySheet2.GetCellValue(j,"rm_rsk_evl_scr") 	+ "'>";
						}else{
							html += "<input type='hidden' name='rm_rsk_evl_scr' 	value='" 	+ blank 	+ "'>";
						}
						
						html += "<input type='hidden' name='rm_rsk_grd_c' 		value='" 	+ mySheet2.GetCellValue(j,"rm_rsk_grd_c") 		+ "'>";
					}
				}
			}
			
			bcp_html.innerHTML = html;
			
			if(number=="1"){
				if(!confirm("저장하시겠습니까?")) return;
			}else if(number=="2"){
				if(!confirm("상신하시겠습니까?")) return;
			}

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC010705");
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
		
		//결재 및 반려
		function app_ret(){
			var f = document.ormsForm;
			var number = $("#number").val();
			
			if(number=="1"){
				if(!confirm("결재하시겠습니까?")) return;
			}else if(number=="2"){
				if(!confirm("반려하시겠습니까?")) return;
			}

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC010707");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							if(number=="1"){
								alert("결재되었습니다.");
								removeLoadingWs();
								doAction('search2');
						        doAction('search');
							}else if(number=="2"){
								alert("반려되었습니다..");
								removeLoadingWs();
								doAction('search2');
						        doAction('search');
							}
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
		function mySheet2_OnSearchEnd(code, message){
			if(code != 0){
				alert("RA 평가 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			if(mySheet2.GetDataFirstRow()>0){
				for(var i=2; i<=mySheet2.GetDataLastRow(); i++){
					//업무중단 유발 시나리오
					if(mySheet2.GetCellValue(i, "bzpl_acs_imp_yn")=="Y"){
						mySheet2.SetCellValue(i, "bzpl_acs_imp_ox", "O");
					}else{
						mySheet2.SetCellValue(i, "bzpl_acs_imp_ox", "X");
					}
					if(mySheet2.GetCellValue(i, "hmrs_lss_yn")=="Y"){
						mySheet2.SetCellValue(i, "hmrs_lss_ox", "O");
					}else{
						mySheet2.SetCellValue(i, "hmrs_lss_ox", "X");
					}
					if(mySheet2.GetCellValue(i, "ipt_resc_ipmt_yn")=="Y"){
						mySheet2.SetCellValue(i, "ipt_resc_ipmt_ox", "O");
					}else{
						mySheet2.SetCellValue(i, "ipt_resc_ipmt_ox", "X");
					}
					if(mySheet2.GetCellValue(i, "sys_ug_imp_yn")=="Y"){
						mySheet2.SetCellValue(i, "sys_ug_imp_ox", "O");
					}else{
						mySheet2.SetCellValue(i, "sys_ug_imp_ox", "X");
					}
					if(mySheet2.GetCellValue(i, "dofe_spt_ssp_yn")=="Y"){
						mySheet2.SetCellValue(i, "dofe_spt_ssp_ox", "O");
					}else{
						mySheet2.SetCellValue(i, "dofe_spt_ssp_ox", "X");
					}
					
					if(mySheet2.GetCellValue(i, "ra_dcz_stsc")!="01"){
						/*
	 					if(mySheet2.GetCellValue(i, "natv_rsk_evl_scr")==""){
							mySheet2.SetCellValue(i, "natv_rsk_evl_scr", "NA");
						}
						if(mySheet2.GetCellValue(i, "rsk_ctl_suv_cntn")==""){
							mySheet2.SetCellValue(i, "rsk_ctl_suv_cntn", "NA");
						}
						if(mySheet2.GetCellValue(i, "rsk_mtg_act_cntn")==""){
							mySheet2.SetCellValue(i, "rsk_mtg_act_cntn", "NA");
						}
						*/
					}
					
					if(mySheet2.GetCellValue(i, "ra_x_rsnc")!="04"){
						mySheet2.SetCellEditable(i, "x_rsnctt", 0);
					}
					if(mySheet2.GetCellValue(i, "ra_dcz_stsc")!="01"){
						mySheet2.SetCellEditable(i, "bcp_amn_obj_yn", 0);
						mySheet2.SetCellEditable(i, "ra_x_rsnc", 0);
						mySheet2.SetCellEditable(i, "rm_rsk_evl_scr", 0);
						mySheet2.SetCellEditable(i, "rsk_ctl_suv_cntn", 0);
						mySheet2.SetCellEditable(i, "rsk_mtg_act_cntn", 0);
					}
					if(mySheet2.GetCellValue(i, "bcp_amn_obj_yn")=="Y"){
						mySheet2.SetCellEditable(i, "ra_x_rsnc", 0);
					}else if(mySheet2.GetCellValue(i, "bcp_amn_obj_yn")=="N"){
						mySheet2.SetCellEditable(i, "rm_rsk_evl_scr", 0);
					}
					
					mySheet2_OnChange(i,  mySheet2.SaveNameCol("bcp_amn_obj_yn")) ;
					
					mySheet2.SetCellValue(i, "status", "");
					
				}
			}
			
		}
		
		function mySheet2_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장하였습니다.");  // 저장 성공 메시지
		        doAction('search2');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        doAction('search2');
		    }
		}

		function dis(){
			if(chk_ra_dcz_stsc1 == '03'){
				document.getElementById('btn-wrap-right').style.visibility = 'hidden';
			}else{
				document.getElementById('btn-wrap-right').style.visibility = 'visible';
			}
		}

	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<div class="container">
		<!--.page header //-->
	<%@ include file="../comm/header.jsp" %>
	<!-- content -->
		<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="today" name="today" value="<%=today %>" />
				<input type="hidden" id="year" name="year" value="<%=year %>" />
				<input type="hidden" id="hd_rm_rsk_evl_scr" name="hd_rm_rsk_evl_scr" />
				<input type="hidden" id="hd_rsk_c" name="hd_rsk_c" />
				<input type="hidden" id="number" name="number" />
				<input type="hidden" id="hd_rsk_ctl_suv_cntn" name="hd_rsk_ctl_suv_cntn" />
				<input type="hidden" id="hd_rsk_mtg_act_cntn" name="hd_rsk_mtg_act_cntn" />
				<input type="hidden" id="hd_f_pfrnm" name="hd_f_pfrnm" />
				<input type="hidden" id="hd_rsk_pfrnm" name="hd_rsk_pfrnm" />
				<input type="hidden" id="hd_ra_dcz_stsc" name="hd_ra_dcz_stsc" />
				<input type="hidden" id="hd_bcp_04_0" name="hd_bcp_04_0" />
				<input type="hidden" id="hd_bcp_04_1" name="hd_bcp_04_1" />
				<input type="hidden" id="hd_bcp_04_2" name="hd_bcp_04_2" />
				<input type="hidden" id="hd_bcp_04_3" name="hd_bcp_04_3" />
				<input type="hidden" id="hd_bcp_04_4" name="hd_bcp_04_4" />
					<input type="hidden" id="chk_ra_dcz_stsc" name="chk_ra_dcz_stsc"/>
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
										<div class="select w150" id="ra_sc">
											<select name="st_ra_sc" id="st_ra_sc" class="form-control">
<%
for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
%>
										   		<option value="<%=(String)hMap.get("ra_sc")%>"><%=(String)hMap.get("ra_sc")%></option>
<%
}
%>	
											</select>
										</div>
									</td>
									<th>BCP 관리대상</th>
									<td>
										<div class="select w80">
											<select name="st_bcp_amn_obj_yn" id="st_bcp_amn_obj_yn" class="form-control">
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
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search2');">조회</button>
				</div>
			</div>
			<!-- //조회 -->
			</form>


			<section class="box box-grid">

					<div class="box-header">
						<div class="area-tool">
							<button class="btn btn-default btn-xs" type="button" onclick="javascript:register();">
								<i class="fa fa-plus"></i><span class="txt">신규등록</span>
							</button>
						</div>
					</div>
				<!-- <div class="box-body">
					<div class="wrap-grid h200">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div> -->
			</section>


			<section class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button class="btn btn-normal btn-xs btn-help" type="button" onclick="openGuide();"><i class="fa fa-exclamation-circle"></i><span class="txt">Help</span></button>
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h350">
						<!-- 가이드 팝업 버튼 -->
						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-footer">
						<div class="btn-wrap right" id="btn-wrap-right">
						<button class="btn btn-primary" type="button" onclick="javascript:doAction('report');" ><span>상신</span></button>
						<button class="btn btn-primary" type="button" onclick="javascript:doAction('save');" ><span>저장</span></button>
					</div>
				</div>
			</section>

		</div>
		<!-- content //-->			
	</div><!-- .container //-->
	<!-- popup //-->
	<div id="winRskCtl" class="popup modal">
		<iframe name="ifrRskCtl" id="ifrRskCtl" src="about:blank"></iframe>	
	</div>	
	<div id="winRskMtg" class="popup modal">
		<iframe name="ifrRskMtg" id="ifrRskMtg" src="about:blank"></iframe>	
	</div>	
	<div id="winEvlScr" class="popup modal">
		<iframe name="ifrEvlScr" id="ifrEvlScr" src="about:blank"></iframe>	
	</div>	
	<iframe name="ifrDummy" id="ifrDummy" src="about:blank"></iframe>
	<!--  -->
	<div id="popupGuide" class="popup modal">
			<div class="p_frame w1100">

				<div class="p_head">
					<h3 class="title">고유위험평가 점수 산정기준 / 잔여위험등급</h3>
				</div>


				<div class="p_body">
					
					<div class="p_wrap">

						<div class="box box-grid">	
							<div class="row">
								<div class="col w70p">
									
									<div class="box-header">
											<h4 class="title md">고유 위험 점수 산정 기준</h4>
										</div>					
										<div class="box-body">
											<div class="wrap-table">
												<table>
													<colgroup>
														<col style="width: 80px;">
														<col>
														<col style="width: 80px;">
														<col style="width: 60px;">
													</colgroup>
													<thead>
														<tr>
															<th>구분</th>
															<th>선택</th>
															<th>영향도 구분</th>
															<th>점수</th>
														</tr>
													</thead>
													<tbody class="center">
														<tr>
															<td rowspan="5">발생 가능성 평가</td>
															<td>10년에 1회도 가능성 없음</td>
															<td>매우 낮음</td>
															<td>2</td>
														</tr>
														<tr>
															<td>5년에 최소 1회 발생 가능</td>
															<td>낮음</td>
															<td>4</td>
														</tr>
														<tr>
															<td>1년에 최소 1회 발생 가능</td>
															<td>보통</td>
															<td>6</td>
														</tr>
														<tr>
															<td>1개월에 최소 1회 발생 가능</td>
															<td>높음</td>
															<td>8</td>
														</tr>
														<tr>
															<td>1주일에 최소 1회 발생 가능</td>
															<td>매우 높음</td>
															<td>10</td>
														</tr>
														<tr>
															<td rowspan="5">영향도 평가</td>
															<td>1억 미만 자산손실</td>
															<td>매우 낮음</td>
															<td>2</td>
														</tr>
														<tr>
															<td>1억 이상 10억 미만 자산손실</td>
															<td>낮음</td>
															<td>4</td>
														</tr>
														<tr>
															<td>10억 이상 100억 미만 자산손실</td>
															<td>보통</td>
															<td>6</td>
														</tr>
														<tr>
															<td>100억 이상 5000억 미만 자산손실</td>
															<td>높음</td>
															<td>8</td>
														</tr>
														<tr>
															<td>5000억 이상 자산손실</td>
															<td>매우 높음</td>
															<td>10</td>
														</tr>
													</tbody>
													<tfoot>
														<tr>
															<td colspan="5" class="center ph5 bgm cw">
																<strong>[고유위험평가 점수] = 위험특성점수 + 영향평가점수</strong>
															</td>
														</tr>
													</tfoot>
												</table>
											</div>
										</div>
								</div>
								<div class="col w30p">
									<div class="box-header">
										<h5 class="box-title md">잔여위험 점수 산정기준</h5>
									</div>
									<div class="bgbl line ba p10">
										<p>평가자의 판단으로 고유위험 결과값에서 위험통제 및 경감조치 현황을 고려하여 위험점수 차감</p>
										<p class="mt5 txt txt-sm">[산식]</p>
										<p class="mt5 txt txt-sm">1.위험통제활동 존재 時</p>
										<p class="mt5 txt txt-sm">잔여위험 점수 = 고유위험점수 -1</p>
										<p class="mt5 txt txt-sm">2.위험경감조치 존재 時</p>
										<p class="mt5 txt txt-sm">잔여위험 점수 = 고유위험점수 -1</p>
										<p class="mt5 txt txt-sm">3.위험통제 및 경감조치 존재 時</p>
										<p class="mt5 txt txt-sm">잔여위험 점수 = 고유위험점수 -2</p>
									</div>
									
									<div class="box-header mt20">
										<h5 class="box-title md">잔여위험 등급 및 판단 기준</h5>
									</div>
									<div class="box-body">
										<div class="wrap-table">
											<table>
												<colgroup>
													<col style="width: 60px;">
													<col style="width: 60px;">
													<col>
												</colgroup>
												<tbody class="center">
													<tr>
														<th class="bgg cw">1단계</th>
														<td>관심</td>
														<td>0 ≤ 점수 ＜ 2.5</td>
													</tr>
													<tr>
														<th class="bgy cw">2단계</th>
														<td>주의</td>
														<td>2.5 ≤ 점수 ＜ 5</td>
													</tr>
													<tr>
														<th class="bgr cw">3단계</th>
														<td>경계</td>
														<td>5 ≤ 점수 ＜ 7.5</td>
													</tr>
													<tr>
														<th class="bgp cw">4단계</th>
														<td>심각</td>
														<td>7.5 ≤ 점수 ＜ 10</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>

					</div>
					
				</div>

				<button class="ico close fix btn-close" onclick="closeGuide();"><span class="blind">닫기</span></button>

			</div>
		<div class="dim p_close"></div>
	</div>

	<script>
		function openGuide(){
			$("#popupGuide").addClass('block');
		}
		function closeGuide(){
			$("#popupGuide").removeClass('block');
		}
	</script>
</body>
</html>