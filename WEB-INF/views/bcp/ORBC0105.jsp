<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0105.jsp
 Program name : BIA 평가(ORM 전담팀 담당자, ORM 전담팀장, BCP전담팀, BCP전담팀장)
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

Vector vLst2 = CommUtil.getCommonCode(request, "OBT_RCVR_HR_C"); //목표복구시간(공통코드)
if(vLst2==null) vLst2 = new Vector();

DynaForm form = (DynaForm)request.getAttribute("form");
String bcp_menu_dsc = (String)form.get("bcp_menu_dsc");
System.out.println(bcp_menu_dsc);

//목표복구시간코드코드 ibsheet Combo 형태로 변환
String obt_rcvr_hr_c = "";
String obt_rcvr_hr_nm = "";

int check_rto = 0;

for(int i=0;i<vLst2.size();i++){
	HashMap hMap = (HashMap)vLst2.get(i);
	if(obt_rcvr_hr_c==""){
		obt_rcvr_hr_c += (String)hMap.get("intgc");
		obt_rcvr_hr_nm += (String)hMap.get("intg_cnm");
	}else{
		obt_rcvr_hr_c += ("|" + (String)hMap.get("intgc"));
		obt_rcvr_hr_nm += ("|" + (String)hMap.get("intg_cnm"));
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
							   		'<strong class="cm txt txt-sm">'+bia_yy+'회차 </strong>' +
							   		'<strong>'+rList[0].bia_evl_st_dt+' ~ '+rList[0].bia_evl_ed_dt+' </strong>'
							   		
							   		;
								
						   $("#evl_sc").html(html);
						   
						   html2 += "<input type='hidden' id='bia_evl_prg_stsc' 	name='bia_evl_prg_stsc' value='"+rList[0].bia_evl_prg_stsc+"'>"
						   html2 += "<input type='hidden' id='bia_yy' 			name='bia_yy' 		value='"+rList[0].bia_yy+"'>"
						   html2 += "<input type='hidden' id='bia_evl_st_dt' 			name='bia_evl_st_dt' 		value='"+rList[0].bia_evl_st_dt+"'>"
						   html2 += "<input type='hidden' id='bia_evl_ed_dt' 			name='bia_evl_ed_dt' 		value='"+rList[0].bia_evl_ed_dt+"'>"
							  
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
			
			initData.Cfg = {FrozenCol:0, MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"선택|선택",							Type:"CheckBox",	MinWidth:50,		Align:"Left",		SaveName:"ischeck",				Edit:1},
				{Header:"Status|Status",						Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",				Edit:0, Hidden:true},
				{Header:"평가회차|평가년월",							Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bas_ym",			Edit:0, Hidden:true},
				{Header:"평가회차|평가회차",							Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bia_yy",			Edit:0, Hidden:true},
				{Header:"BIA평가진행상태코드|BIA평가진행상태코드",	Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bia_evl_prg_stsc",	Edit:0, Hidden:true},
				{Header:"평가대상팀|평가대상팀",							Type:"Text",	MinWidth:150,	Align:"Center",		SaveName:"brnm",				Edit:0},//3
				{Header:"평가부서코드|평가부서코드",					Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"chrg_brc",			Edit:0, Hidden:true},
				{Header:"설문대상|단위업무 담당자",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"chrg_empnm",			Edit:0},
				{Header:"설문대상|평가자 사번",					Type:"Text",	MinWidth:80,		Align:"Center",		SaveName:"eno",			Edit:0, Hidden:true},
				{Header:"업무프로세스코드|업무프로세스코드",					Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bsn_prss_c",			Edit:0, Hidden:true},
				{Header:"평가부서코드|평가부서코드",						Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"brc",					Edit:0, Hidden:true},
				{Header:"평가\n부서|평가\n부서",						Type:"Text",	MinWidth:150,	Align:"Center",		SaveName:"brnm",				Edit:0},
				{Header:"업무프로세스|LV1",						Type:"Text",	MinWidth:120,	Align:"Left",		SaveName:"bsn_prsnm_lv1",		Edit:0,	Wrap:true},
				{Header:"업무프로세스코드|업무프로세스코드",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bsn_prss_lv1",		Edit:0, Hidden:true},
				{Header:"업무프로세스|LV2",						Type:"Text",	MinWidth:120,	Align:"Left",		SaveName:"bsn_prsnm_lv2",		Edit:0,	Wrap:true},
				{Header:"업무프로세스코드|업무프로세스코드",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bsn_prss_lv2",		Edit:0, Hidden:true},
				{Header:"업무프로세스|LV3",						Type:"Text",	MinWidth:120,	Align:"Left",		SaveName:"bsn_prsnm_lv3",		Edit:0,	Wrap:true},
				{Header:"업무프로세스코드|업무프로세스코드",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bsn_prss_lv3",		Edit:0, Hidden:true},
				{Header:"업무프로세스|LV4",						Type:"Text",	MinWidth:250,	Align:"Left",		SaveName:"bsn_prsnm_lv4",		Edit:0,	Wrap:true},
				{Header:"업무프로세스코드|업무프로세스코드",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bsn_prss_c",			Edit:0, Hidden:true},//12
				{Header:"업무 유형 중요도 평가1|대고객\n서비스\n업무",	Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"bsn_coic_yn1",		Edit:0, Hidden:true},
				{Header:"업무 유형 중요도 평가2|대고객\n서비스\n지원 업무",			Type:"Text",	MinWidth:10,		Align:"Center",					SaveName:"bsn_coic_yn2", Edit:0, Hidden:true},
				{Header:"업무 유형 중요도 평가3|트레이딩\n및\n자산운용\n업무",		Type:"Text",	MinWidth:10,		Align:"Center",					SaveName:"bsn_coic_yn3", Edit:0, Hidden:true},
				{Header:"업무 유형 중요도 평가4|기획 및\n관리 업무",		Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"bsn_coic_yn4",		Edit:0, Hidden:true},
				{Header:"업무 유형 중요도 평가5|인프라\n관리 업무",		Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"bsn_coic_yn5",		Edit:0, Hidden:true},
				{Header:"업무 유형 중요도 평가|대고객\n서비스\n업무",	Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"bsn_coic_ox1",		Edit:0},//18
				{Header:"업무 유형 중요도 평가|대고객\n서비스\n지원 업무",				Type:"Text",	MinWidth:10,		Align:"Center",					SaveName:"bsn_coic_ox2", Edit:0},
				{Header:"업무 유형 중요도 평가|트레이딩\n및\n자산운용\n업무",		Type:"Text",	MinWidth:10,		Align:"Center",					SaveName:"bsn_coic_ox3", Edit:0},
				{Header:"업무 유형 중요도 평가|기획 및\n관리 업무",		Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"bsn_coic_ox4",		Edit:0},
				{Header:"업무 유형 중요도 평가|인프라\n관리 업무",		Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"bsn_coic_ox5",		Edit:0},
				{Header:"업무\n유형\n중요도|업무\n유형\n중요도",	Type:"Float",	MinWidth:50,	Align:"Center",		SaveName:"bsn_tp_iptd_val",		Edit:0, Format:"0.###"},//23
				{Header:"업무 중단시 영향도 평가1|대고객\n서비스\n저하",Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_yn1",		Edit:0, Hidden:true},
				{Header:"업무 중단시 영향도 평가2|연계업무\n수행실패",	Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_yn2",		Edit:0, Hidden:true},
				{Header:"업무 중단시 영향도 평가3|회사평판\n저하",			Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_yn3",		Edit:0, Hidden:true},
				{Header:"업무 중단시 영향도 평가4|재무적\n손실",			Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_yn4",		Edit:0, Hidden:true},
				{Header:"업무 중단시 영향도 평가5|감독기관\n제재",			Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_yn5",		Edit:0, Hidden:true},
				{Header:"업무 중단시 영향도 평가|대고객\n서비스\n저하",	Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_ox1",		Edit:0},//29
				{Header:"업무 중단시 영향도 평가|연계업무\n수행실패",		Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_ox2",		Edit:0},
				{Header:"업무 중단시 영향도 평가|회사평판\n저하",			Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_ox3",		Edit:0},
				{Header:"업무 중단시 영향도 평가|재무적\n손실",			Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_ox4",		Edit:0},
				{Header:"업무 중단시 영향도 평가|감독기관\n제재",			Type:"Text",	MinWidth:10,	Align:"Center",		SaveName:"ifn_coic_ox5",		Edit:0},
				{Header:"업무\n중단\n영향도|업무\n중단\n영향도",	Type:"Float",	MinWidth:50,	Align:"Center",		SaveName:"bsn_ssp_ifn_val",		Edit:0, Format:"#0.###"},
				{Header:"전체\n중요도\n점수|전체\n중요도\n점수",	Type:"Float",	MinWidth:50,	Align:"Center",		SaveName:"tot_sum",				Edit:0, Format:"#0.###"},
				{Header:"우선\n순위|우선\n순위",					Type:"Text",	MinWidth:40,	Align:"Center",		SaveName:"all_rank",			Edit:0},
				{Header:"설문 완료\n여부|설문 완료\n여부",			Type:"Text",	MinWidth:80,	Align:"Left",		SaveName:"qsn_rg_yn",			Edit:0, Hidden:true},
				{Header:"최대 허용\n중단기간\n(MAO)|최대 허용\n중단기간\n(MAO)",Type:"Text",	MinWidth:80,		Align:"Left",					SaveName:"max_pmss_ssp_nm",	Edit:0},
				{Header:"목표\n복구시점\n(RPO)|목표\n복구시점\n(RPO)",		Type:"Text",	MinWidth:120,		Align:"Left",					SaveName:"obt_rcvr_ptm_nm",	Edit:0},//39
				{Header:"최대허용중단기간코드|최대허용중단기간코드",		Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"max_pmss_ssp_prdc",	Edit:0, Hidden:true},
				{Header:"목표복구시점코드|목표복구시점코드",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"obt_rcvr_ptm_c",		Edit:0, Hidden:true},
				{Header:"목표복구시간(RTO)|목표복구시간(RTO)",						Type:"Combo",	MinWidth:120,	Align:"Center",		SaveName:"fir_obt_rcvr_hr_c", 	ComboText:"<%=obt_rcvr_hr_nm %>", ComboCode:"<%=obt_rcvr_hr_c %>",Edit:0},
				{Header:"필요 복구\n자원 조사|필요 복구\n자원 조사",	Type:"Html",	MinWidth:60,	Align:"Center",		SaveName:"bia_evl",				Edit:0},//60
				{Header:"조정RTO|조정RTO",			Type:"Combo",	MinWidth:120,	Align:"Center",		SaveName:"obt_rcvr_hr_c", 		ComboText:"<%=obt_rcvr_hr_nm %>", ComboCode:"<%=obt_rcvr_hr_c %>"},
				{Header:"BIA평가진행상태|BIA평가진행상태",					Type:"Text",	MinWidth:100,		Align:"Left",		SaveName:"bia_evl_prg",	Edit:0},
				{Header:"BIA평가진행상태코드|BIA평가진행상태코드",			Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bia_evl_prg_stsc",	Edit:0, Hidden:true}
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
			
			doAction('search');
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			if( (mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm_lv1")||(mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm_lv2")||(mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm_lv3")||(mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm") ){
				prssEvl();
			}
			
			
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			
			$("#hd_bsn_prss_c").val(mySheet.GetCellValue(Row, "bsn_prss_c"));
			$("#chrg_brc").val(mySheet.GetCellValue(Row, "chrg_brc"));
			$("#prd_brc").val(mySheet.GetCellValue(Row, "prd_brc"));

/*			
			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="bia_evl"){
				if(mySheet.GetCellValue(Row, "max_pmss_ssp_prdc")=="01" || mySheet.GetCellValue(Row, "max_pmss_ssp_prdc")=="02"){
					biaEvl();
				}
				
			}
*/			
			if( (mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm_lv1")||(mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm_lv2")||(mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm_lv3")||(mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm") ){
				$("#number").val("1");
			}
			
			
		}
		
		function mySheet_OnChange(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
 			if( parseInt(mySheet.GetCellValue(Row, "max_pmss_ssp_prdc")) < parseInt(mySheet.GetCellValue(Row, "obt_rcvr_hr_c")) ){
 				check_rto = check_rto+1;
 				//alert("최종 RTO는 최종허용중단기간(MAO)보다 같거나 작아야 합니다.");
 				mySheet.SetCellValue(Row, "obt_rcvr_hr_c", "");

 				if(check_rto == 1){
 					alert("최종 RTO는 최종허용중단기간(MTPD)보다 같거나 작아야 합니다.");
 				}
 			}
 			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="f_bsn_prsnm"){
 				prdcBsn();
 			}
 			
 			if(mySheet.GetCellProperty(Row, Col, "SaveName")=="obt_rcvr_hr_c"){
 				regRto();
 			}
 				
			
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
					$("form[name=ormsForm] [name=process_id]").val("ORBC010502");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					search();
					
					break;
				case "down2excel":
					var downCols = "3|4|5|6|7|8|9|10|11|12|18|19|20|21|22|23|29|30|31|32|33|34|35|36|37|38|39|42|43|44|45|46|47|48|49|51|52|53|54|55|56|57|58";
					
					var bia_yy = $("#bia_yy").val();
					var bia_evl_st_dt = $("#bia_evl_st_dt").val();
					var bia_evl_ed_dt = $("#bia_evl_ed_dt").val();
					
					var titleText = "평가일정 : "+bia_yy+"회차 "+bia_evl_st_dt+" ~ "+bia_evl_ed_dt+"\r\n\r\n";
					var userMerge = "0,0,2,15";
					
					mySheet.Down2Excel({FileName:"BIA 평가.xlsx", Merge:1, DownCols:downCols, TitleText:titleText, UserMerge:userMerge})
					
					break;
			}
		}
		
		function prdcBsn(){
			var row = mySheet.GetSelectRow();
			var f_bsn_prss_c = mySheet.GetCellValue(row, "f_bsn_prss_c");
			
			var bsn_prss_lv1 = mySheet.GetCellValue(row, "bsn_prss_lv1");
			var bsn_prss_lv2 = mySheet.GetCellValue(row, "bsn_prss_lv2");
			var bsn_prss_lv3 = mySheet.GetCellValue(row, "bsn_prss_lv3");
			var bsn_prss_c = mySheet.GetCellValue(row, "bsn_prss_c");
			var bsn_prsnm_lv1 = mySheet.GetCellValue(row, "bsn_prsnm_lv1");
			var bsn_prsnm_lv2 = mySheet.GetCellValue(row, "bsn_prsnm_lv2");
			var bsn_prsnm_lv3 = mySheet.GetCellValue(row, "bsn_prsnm_lv3");
			var bsn_prsnm_lv4 = mySheet.GetCellValue(row, "bsn_prsnm_lv4");
			var prd_brc = mySheet.GetCellValue(row, "prd_brc");
			
			
			for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
				
				if(mySheet.GetCellValue(i, "bsn_prss_c")==f_bsn_prss_c && mySheet.GetCellValue(i, "chrg_brc")==prd_brc){
					
					mySheet.SetCellValue(i, "b_bsn_prss_lv1", bsn_prss_lv1);
					mySheet.SetCellValue(i, "b_bsn_prss_lv2", bsn_prss_lv2);
					mySheet.SetCellValue(i, "b_bsn_prss_lv3", bsn_prss_lv3);
					mySheet.SetCellValue(i, "b_bsn_prss_c", bsn_prss_c);
					mySheet.SetCellValue(i, "b_bsn_prsnm_lv1", bsn_prsnm_lv1);
					mySheet.SetCellValue(i, "b_bsn_prsnm_lv2", bsn_prsnm_lv2);
					mySheet.SetCellValue(i, "b_bsn_prsnm_lv3", bsn_prsnm_lv3);
					mySheet.SetCellValue(i, "b_bsn_prsnm", bsn_prsnm_lv4);
					
					mySheet.SetCellValue(row, "obt_rcvr_hr_c", mySheet.GetCellValue(i, "obt_rcvr_hr_c"));
					
				}
			}
			
		}
		
		function regRto(){
			var row = mySheet.GetSelectRow();
			var blank = "";
			var number = 0;
			
			if(mySheet.GetCellValue(row, "f_bsn_prss_c")!=blank){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i, "bsn_prss_c")==mySheet.GetCellValue(row, "f_bsn_prss_c")){
						number = i;
						
						break;
					}
				}
				
				if( parseInt(mySheet.GetCellValue(row, "obt_rcvr_hr_c")) < parseInt(mySheet.GetCellValue(number, "obt_rcvr_hr_c")) ){
					alert("선행 업무프로세스의 RTO 미만의 기간을 입력 할 수 없습니다.");
					mySheet.SetCellValue(row, "obt_rcvr_hr_c", mySheet.GetCellValue(number, "obt_rcvr_hr_c"));
					
					return;
				}
				
				
			}
			
			if(mySheet.GetCellValue(row, "b_bsn_prss_c")!=blank){
				for(var i=3; i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i, "bsn_prss_c")==mySheet.GetCellValue(row, "b_bsn_prss_c")){
						number = i;
						
						break;
					}
				}
				
				if( parseInt(mySheet.GetCellValue(number, "obt_rcvr_hr_c")) < mySheet.GetCellValue(row, "obt_rcvr_hr_c") ){
					alert("후행 업무프로세스의 RTO 초과하는 기간을 입력 할 수 없습니다.");
					mySheet.SetCellValue(row, "obt_rcvr_hr_c", mySheet.GetCellValue(number, "obt_rcvr_hr_c"));
					
					return;
				}
			}
			
			
			
		}
		
		function search(){
			check_rto = 0;
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
						   bia_yy = bia_yy.substring(5)
						   
						   html +=	'평가일정 : ' +
							   		'<strong class="cm txt txt-sm">'+bia_yy+'회차 </strong>' +
							   		'<strong>'+rList[0].bia_evl_st_dt+' ~ '+rList[0].bia_evl_ed_dt+' </strong>'
							   		
							   		;
								
						   $("#evl_sc").html(html);
						   
						  html2 += "<input type='hidden' id='bia_evl_prg_stsc' 		name='bia_evl_prg_stsc' value='"+rList[0].bia_evl_prg_stsc+"'>"
						  html2 += "<input type='hidden' id='bia_yy' 			name='bia_yy' 		value='"+rList[0].bia_yy+"'>"
						  html2 += "<input type='hidden' id='bia_evl_st_dt' 			name='bia_evl_st_dt' 		value='"+rList[0].bia_evl_st_dt+"'>"
						  html2 += "<input type='hidden' id='bia_evl_ed_dt' 			name='bia_evl_ed_dt' 		value='"+rList[0].bia_evl_ed_dt+"'>"
						  
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
		}
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("BIA 평가(평가부서) 조회 중에 오류가 발생하였습니다..");
			}else{
				$("#bas_ym").val(mySheet.GetCellValue(mySheet.GetDataLastRow(), "bas_ym"));
			}
			
			
			if(mySheet.GetDataFirstRow()>0){
				//prssSort();
				
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					var sum1 = mySheet.GetCellValue(i, "bsn_tp_iptd_val");
					var sum2 = mySheet.GetCellValue(i, "bsn_ssp_ifn_val");
					if($("#bcp_menu_dsc").val()=="2"||$("#bcp_menu_dsc").val()=="3"||$("#bcp_menu_dsc").val()=="4"){
						mySheet.SetCellEditable(i,"obt_rcvr_hr_c",0);
					}
					
					//업무 유형 중요도 평가
					if(mySheet.GetCellValue(i, "bsn_coic_yn1")=="Y"){
						mySheet.SetCellValue(i, "bsn_coic_ox1", "O");
					}else{
						mySheet.SetCellValue(i, "bsn_coic_ox1", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn2")=="Y"){
						mySheet.SetCellValue(i, "bsn_coic_ox2", "O");
					}else{
						mySheet.SetCellValue(i, "bsn_coic_ox2", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn3")=="Y"){
						mySheet.SetCellValue(i, "bsn_coic_ox3", "O");
					}else{
						mySheet.SetCellValue(i, "bsn_coic_ox3", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn4")=="Y"){
						mySheet.SetCellValue(i, "bsn_coic_ox4", "O");
					}else{
						mySheet.SetCellValue(i, "bsn_coic_ox4", "X");
					}
					if(mySheet.GetCellValue(i, "bsn_coic_yn5")=="Y"){
						mySheet.SetCellValue(i, "bsn_coic_ox5", "O");
					}else{
						mySheet.SetCellValue(i, "bsn_coic_ox5", "X");
					}
					//업무 중단시 영향도 평가
					if(mySheet.GetCellValue(i, "ifn_coic_yn1")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox1", "O");
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox1", "X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn2")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox2", "O");
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox2", "X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn3")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox3", "O");
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox3", "X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn4")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox4", "O");
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox4", "X");
					}
					if(mySheet.GetCellValue(i, "ifn_coic_yn5")=="Y"){
						mySheet.SetCellValue(i, "ifn_coic_ox5", "O");
					}else{
						mySheet.SetCellValue(i, "ifn_coic_ox5", "X");
					}

					//전체중요도점수
					mySheet.SetCellValue(i, "tot_sum", (sum1+sum2));
					
					if(mySheet.GetCellValue(i, "max_pmss_ssp_prdc")=="01" || mySheet.GetCellValue(i, "max_pmss_ssp_prdc")=="02"){
						//mySheet.SetCellValue(i, "bia_evl", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:biaEvl('+i+');">조사</button>');
						mySheet.SetCellValue(i, "bia_evl", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:biaEvl('+i+');">조회</button>');
					}
					
					
					/* mySheet.SetCellValue(i, "status", ""); */
					
					//최종RTO
					if(mySheet.GetCellValue(i, "obt_rcvr_hr_c")==""){
						mySheet.SetCellValue(i, "obt_rcvr_hr_c", mySheet.GetCellValue(i, "max_pmss_ssp_prdc"));
					}
					
					//후행 업무프로세스 표시
					if(mySheet.GetCellValue(i, "f_bsn_prss_c")!=""){
						
						var f_bsn_prss_c = mySheet.GetCellValue(i, "f_bsn_prss_c");
						var prd_brc = mySheet.GetCellValue(i, "prd_brc")
						var bsn_prss_lv1 = mySheet.GetCellValue(i, "bsn_prss_lv1");
						var bsn_prss_lv2 = mySheet.GetCellValue(i, "bsn_prss_lv2");
						var bsn_prss_lv3 = mySheet.GetCellValue(i, "bsn_prss_lv3");
						var bsn_prss_c = mySheet.GetCellValue(i, "bsn_prss_c");
						var bsn_prsnm_lv1 = mySheet.GetCellValue(i, "bsn_prsnm_lv1");
						var bsn_prsnm_lv2 = mySheet.GetCellValue(i, "bsn_prsnm_lv2");
						var bsn_prsnm_lv3 = mySheet.GetCellValue(i, "bsn_prsnm_lv3");
						var bsn_prsnm_lv4 = mySheet.GetCellValue(i, "bsn_prsnm_lv4");
						
						for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
							
							if(mySheet.GetCellValue(j, "bsn_prss_c")==f_bsn_prss_c &&mySheet.GetCellValue(j, "chrg_brc")==prd_brc){
																
								mySheet.SetCellValue(j, "b_bsn_prss_lv1", bsn_prss_lv1);
								mySheet.SetCellValue(j, "b_bsn_prss_lv2", bsn_prss_lv2);
								mySheet.SetCellValue(j, "b_bsn_prss_lv3", bsn_prss_lv3);
								mySheet.SetCellValue(j, "b_bsn_prss_c", bsn_prss_c);
								mySheet.SetCellValue(j, "b_bsn_prsnm_lv1", bsn_prsnm_lv1);
								mySheet.SetCellValue(j, "b_bsn_prsnm_lv2", bsn_prsnm_lv2);
								mySheet.SetCellValue(j, "b_bsn_prsnm_lv3", bsn_prsnm_lv3);
								mySheet.SetCellValue(j, "b_bsn_prsnm", bsn_prsnm_lv4);
								
								break;
							}
							
						}
						
					}
				}
				
			}
			
			var bia_evl_prg_stsc = $("#bia_evl_prg_stsc").val();
			if(bia_evl_prg_stsc=="03"){
				mySheet.SetEditalbe(0);
			}
			
			
		}
		
		function biaEvl(Row){
			
			$("#bia_evl_prg_stsc").val(mySheet.GetCellValue(Row, "bia_evl_prg_stsc"));
			$("#st_bia_yy").val(mySheet.GetCellValue(Row, "bia_yy"));
			$("#hd_bsn_prss_c").val(mySheet.GetCellValue(Row, "bsn_prss_c"));
			$("#chrg_brc").val(mySheet.GetCellValue(Row, "chrg_brc"));
			
			showLoadingWs();	
			//$("#ifrBiaEvl").attr("src","about:blank");
			$("#winBiaEvl").show();
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="bcp";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORBC010601";
			f.target = "ifrBiaEvl";
			f.submit();	
			
		}
		
		function prssEvl(){
			
			//$("#ifrPrssEvl").attr("src","about:blank");
 			$("#winPrssEvl").show();
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="bcp";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORBC011201";
			f.target = "ifrPrssEvl";
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
			if($("#bcp_menu_dsc").val()=="1"){ //orm전담결재중
				$("#sch_bia_evl_prg_stsc").val("05");
			}else if($("#bcp_menu_dsc").val()=="2"){ //orm팀장결재중
				$("#sch_bia_evl_prg_stsc").val("06");
			}else if($("#bcp_menu_dsc").val()=="3"){ //안전관리팀 결재중
				$("#sch_bia_evl_prg_stsc").val("07");
			}else if($("#bcp_menu_dsc").val()=="4"){ //안전관리팀장 결재중
				$("#sch_bia_evl_prg_stsc").val("08");
			}
			var com = true;
			var bia_evl_ed_dt = $("#bia_evl_ed_dt").val();
			bia_evl_ed_dt = bia_evl_ed_dt.replace(/-/gi, '');
			var today = $("#today").val();
			if(mySheet.GetDataFirstRow()>0){
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i,"ischeck")==1){
						if($("#bcp_menu_dsc").val()=="1" && mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="04"){
							alert("진행상태가 ORM전담 결재중인 항목만 결재가 가능합니다.");
							com = false;
							return;
						}
						if($("#bcp_menu_dsc").val()=="2" && mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="05"){
							alert("진행상태가 ORM팀장 결재중인 항목만 결재가 가능합니다.");
							com = false;
							return;
						}
						if($("#bcp_menu_dsc").val()=="3" && mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="06"){
							alert("진행상태가 안전관리팀 결재중인 항목만 결재가 가능합니다.");
							com = false;
							return;
						}
						if($("#bcp_menu_dsc").val()=="4" && mySheet.GetCellValue(i, "bia_evl_prg_stsc")!="07"){
							alert("진행상태가 안전관리팀장 결재중인 항목만 결재가 가능합니다.");
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
			var com = true;
			var bia_evl_prg_stsc = $("#bia_evl_prg_stsc").val();
			var chk = 0;
			var qsn_rg_yn = "";
			
			if(mySheet.GetDataFirstRow()>0){
				
				for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					
					if(mySheet.GetCellValue(i, "obt_rcvr_hr_c") == ""){
						chk++;
					}
					if(mySheet.GetCellValue(i, "qsn_rg_yn")=="N"){
						
						$("#qsn_rg_yn").val("N");
						
					}
					
				}
				
				if(mySheet.GetCellValue(i, "f_bsn_prss_c")!=""){
					mySheet.SetCellValue(i, "status", "U");
				}
				
				qsn_rg_yn = $("#qsn_rg_yn").val();
				
				if(com){
					if(chk=="0"||qsn_rg_yn=="Y"){
						alert("BIA 평가관리 화면으로 이동하여  완료 버튼을 클릭하십시오.");
						mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=bcp&process_id=ORBC010503&qsn_rg_yn=Y&st_bia_yy="+$("#st_bia_yy").val());
					}else{
						mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=bcp&process_id=ORBC010503&qsn_rg_yn=N&st_bia_yy="+$("#st_bia_yy").val());
					}
					
					
				}
				
			}
			
			
		}
		
		function prssSort(){
			if(mySheet.GetDataFirstRow()>0){
				
				var i = mySheet.GetDataFirstRow();
				var j = mySheet.GetDataLastRow();
				var com = "Y";
				while(i<=j){
					var f_bsn_prss_c = mySheet.GetCellValue(i, "f_bsn_prss_c");
					var prd_brc = mySheet.GetCellValue(i, "prd_brc");
					if(com=="Y"){
						for(var z=mySheet.GetDataFirstRow(); z<=mySheet.GetDataLastRow(); z++){
							if( mySheet.GetCellValue(z, "bsn_prss_c")==f_bsn_prss_c && mySheet.GetCellValue(z, "chrg_brc")==prd_brc && z!=i ){
								mySheet.DataMove(i, z);
								com = "N";
								break;
							}else{
								com = "Y";
							}
							
						}
					}else{
						for(var z=(i+1); z<=mySheet.GetDataLastRow(); z++){
							if( mySheet.GetCellValue(z, "bsn_prss_c")==f_bsn_prss_c && mySheet.GetCellValue(z, "chrg_brc")==prd_brc){
								mySheet.DataMove(i, z);
								com = "N";
								break;
							}else{
								com = "Y";
							}
							
						}
					}
					
					if(com=="Y"){
						i++	
					}else{
						i = i;
					}
				}
			}
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
				<input type="hidden" id="today" name="today" value="<%=dt %>" />
				<input type="hidden" id="hd_bsn_prss_c" name="hd_bsn_prss_c" />
				<input type="hidden" id="number" name="number" />
				<input type="hidden" id="chrg_brc" name="chrg_brc" />
				<input type="hidden" id="prd_brc" name="prd_brc" />
				<input type="hidden" id="qsn_rg_yn" name="qsn_rg_yn" value="Y" />
				<input type="hidden" id="bcp_menu_dsc" name="bcp_menu_dsc" />
				<input type="hidden" id="bas_ym" name="bas_ym" />
				<input type="hidden" id="sch_bia_evl_prg_stsc" name="sch_bia_evl_prg_stsc" />
				<input type="hidden" id="tmp_area" name="tmp_area" />
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
									<td class="form-inline">
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
								<tr>
									<th>평가부서</th>
									<td colspan="5" class="form-inline">
										<div class="input-group w150">
											<input type="text" class="form-control" id="sch_brnm" name="sch_brnm"  onKeyPress="EnterkeySubmitOrg('sch_brnm', 'orgSearchEnd');" disabled />
											<input type="hidden" id="sch_brc" name="sch_brc" />
											<span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"  onclick="schOrgPopup('sch_brnm', 'orgSearchEnd');">
												<i class="fa fa-search"></i><span class="blind">검색</span>	
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
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- //조회 -->
			</form>
			
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="title" id="evl_sc">
						평가일정 :
						<strong class="cm txt txt-sm">00회차</strong> 
						<strong>2021-02-15 ~ 2021-02-27</strong>
					</h2>
					<div class="area-tool">
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:prssSort();" style="display:none">
							<i class="fa fa-sort-amount-desc"></i>
							<span class="txt">프로세스 순 정렬</span>
						</button>
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h550">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="dcz_popup(1);">
							<span class="txt">결재</span>
						</button>
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
	<div id="winPrssEvl" class="popup modal">
		<iframe name="ifrPrssEvl" id="ifrPrssEvl" src="about:blank"></iframe>	
	</div>		
	<iframe name="ifrDummy" id="ifrDummy" src="about:blank"></iframe>
	
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->		
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
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