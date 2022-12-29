<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0102.jsp
 Program name : BIA 일정등록(팝업)
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

Calendar cal = Calendar.getInstance();
/* 회차정보 미존재시 현재 년월을 사용하기 위해서 20210715 추가*/

HashMap hLstMap = null;
if(vLst.size()>0){
	hLstMap = (HashMap)vLst.get(0);
}else{
	hLstMap = new HashMap();
}
String bas_ym = (String)hLstMap.get("bas_ym");
String bas_yy = (String)hLstMap.get("bia_yy");


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
			initIBSheet2();
		});
		
		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"상태",		Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",					Edit:0, 	Hidden:true},
				{Header:"유형코드",	Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bcp_bsn_tpc",				Edit:0,		Wrap:true, Hidden:true},
				{Header:"유형명",		Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"bcp_bsn_tpnm",			Edit:0,		Wrap:true},
				{Header:"유형내용",	Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"bcp_bsn_tp_cntn",			Edit:0,		Wrap:true, MultiLineText: true},
				{Header:"가중치",		Type:"AutoSum",	MinWidth:30,	Align:"Left",		SaveName:"bsn_tp_wval_rto", 		Format:"#0.0\\%", 		MaximumValue:100}
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
		
		/* Sheet 기본 설정 */
		function initIBSheet2(){
			//시트초기화
			mySheet2.Reset();  
			     
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" }; // 좌측에 고정 컬럼의 수(FrozenCol)  
			initData.Cols = [
				{Header:"상태",		Type:"Status",	MinWidth:0,		Align:"Left",		SaveName:"status",					Edit:0, 	Hidden:true},
				{Header:"영향코드",	Type:"Text",	MinWidth:0,		Align:"Left",		SaveName:"bcp_ifn_dsc",				Edit:0, 	Hidden:true},
				{Header:"영향명",		Type:"Text",	MinWidth:50,	Align:"Left",		SaveName:"bcp_ifn_dsnm",			Edit:0,		Wrap:true},
				{Header:"영향내용",	Type:"Text",	MinWidth:100,	Align:"Left",		SaveName:"bcp_ifn_ds_cntn",			Edit:0,		Wrap:true,	MultiLineText:true},
				{Header:"가중치",		Type:"AutoSum",	MinWidth:30,	Align:"Left",		SaveName:"bsn_ssp_ifn_wval_rto", 	Format:"#0.0\\%", 		MaximumValue:100}
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
			
			doAction('search2');
			
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
					$("form[name=ormsForm] [name=process_id]").val("ORBC010202");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
				case "search2": //데이터 조회
					//var opt = {CallBack : DoSeachEnd};
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010203");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					break;
				case "save":
					var sdt = $("#bia_evl_st_dt").val();
					var edt = $("#bia_evl_ed_dt").val();
					var today = $("#today").val();
					sdt = sdt.replace(/-/gi, ''); 
					edt = edt.replace(/-/gi, ''); 
						
					if((sdt<edt) && (today<sdt)){
						if(mySheet.GetSumValue(4,"bsn_tp_wval_rto")==100 && mySheet2.GetSumValue(4,"bsn_ssp_ifn_wval_rto")==100){
							
							save();	
							
						}else{
							alert("가중치를 확인하여 주십시오.\n가중치는 총합 100%가 되어야 합니다.");
							return;
						}
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

			}
		}
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("BIA 평가 관리 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			mySheet.SetSumValue(2, "합계");
		}
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		        //doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        //doAction('search');
		    }
		}
		
		function mySheet2_OnSearchEnd(code, message){
			if(code != 0){
				alert("BIA 평가 관리 조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			mySheet2.SetSumValue(2, "합계");
		}
		
		function mySheet2_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		        //doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        //doAction('search');
		    }
		}
		
		function save(){
			var f = document.ormsForm;
			var html = "";
			
			if(mySheet.GetDataFirstRow()>=0){
				
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					html += "<input type='hidden' name='status' 			value='" 	+ mySheet.GetCellValue(j,"status") 								+ "'>";
					html += "<input type='hidden' name='bcp_bsn_tpc' 		value='" 	+ mySheet.GetCellValue(j,"bcp_bsn_tpc") 						+ "'>";
					html += "<input type='hidden' name='bcp_bsn_tpnm' 		value='" 	+ mySheet.GetCellValue(j,"bcp_bsn_tpnm") 						+ "'>";
					html += "<input type='hidden' name='bcp_bsn_tp_cntn' 	value='" 	+ mySheet.GetCellValue(j,"bcp_bsn_tp_cntn") 					+ "'>";
					html += "<input type='hidden' name='bsn_tp_wval_rto' 	value='" 	+ parseFloat(mySheet.GetCellValue(j,"bsn_tp_wval_rto"))/100 	+ "'>";
				}
			}
			
			if(mySheet2.GetDataFirstRow()>=0){
				for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
					html += "<input type='hidden' name='status2' 				value='" 	+ mySheet2.GetCellValue(j,"status") 								+ "'>";
					html += "<input type='hidden' name='bcp_ifn_dsc' 			value='" 	+ mySheet2.GetCellValue(j,"bcp_ifn_dsc") 							+ "'>";
					html += "<input type='hidden' name='bcp_ifn_dsnm' 			value='" 	+ mySheet2.GetCellValue(j,"bcp_ifn_dsnm") 							+ "'>";
					html += "<input type='hidden' name='bcp_ifn_ds_cntn' 		value='" 	+ mySheet2.GetCellValue(j,"bcp_ifn_ds_cntn") 						+ "'>";
					html += "<input type='hidden' name='bsn_ssp_ifn_wval_rto' 	value='" 	+ parseFloat(mySheet2.GetCellValue(j,"bsn_ssp_ifn_wval_rto"))/100 	+ "'>";
				}
			}
			
			bcp_html.innerHTML = html;
			
			if(!confirm("저장하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC010204");
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
							closePop();
							parent.doAction('search');
							parent.select();
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
		<input type="hidden" id="sch_bia_yy" name="sch_bia_yy" />
		
		<div id="bcp_html"></div>
	
	<div id="" class="popup modal block">
		<div class="p_frame w1100">

			<div class="p_head">
				<h3 class="title">BIA 평가 일정변경 및 AHP입력</h3>
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
											<input type="text" class="form-control w100" id="bia_evl_year" name="bia_evl_year" value="<%=(String)hLstMap.get("bia_yy")%>" readonly/>
										</td>
									</tr>							
									<tr>
										<th>수행시작일</th>
										<td>
											<div class="input-group w130">
												<input type="text" class="form-control" id="bia_evl_st_dt" name="bia_evl_st_dt" value="<%=(String)hLstMap.get("bia_evl_st_dt") %>" readonly/>
												<div class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','bia_evl_st_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</div>
											</div>
										</td>
										
										<th>수행종료일</th>
										<td>
											<div class="input-group w130">
												<input type="text" class="form-control" id="bia_evl_ed_dt" name="bia_evl_ed_dt" value="<%=(String) hLstMap.get("bia_evl_ed_dt") %>" readonly/>
												<div class="input-group-btn">
													<button type="button" class="btn btn-default ico" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','bia_evl_ed_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>등록 및 변경사유</th>
										<td colspan="3">
											<textarea id="bia_schd_upd_rsn" name="bia_schd_upd_rsn" class="textarea h100"><%=(String) hLstMap.get("bia_schd_upd_rsn") %></textarea>
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
										<h4 class="title">업무 유형 중요도</h4>
									</div>
									<div class="box-body">
										<div class="wrap-grid h300">
											<script> createIBSheet("mySheet", "100%", "100%"); </script>
										</div>
									</div>
								</div>
							</div>

							<div class="col">
								<div class="box box-grid">
									<div class="box-header">
										<h4 class="title">업무 중단 시 영향도</h4>
									</div>
									<div class="box-body">
										<div class="wrap-grid h300">
											<script> createIBSheet("mySheet2", "100%", "100%"); </script>
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
	
	<script>
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
			$("#winBiaAdd",parent.document).hide();
		}
	</script>
</body>
</html>