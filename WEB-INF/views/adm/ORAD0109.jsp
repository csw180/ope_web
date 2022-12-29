<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0109.jsp
 Program name : 운영리스크 평가일정 설정
 Description  : 화면정의서 ADM-01
 Programmer   : 박승윤
 Date created : 2022.08.11
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst2==null) vLst2 = new Vector();

HashMap hMap2 = null;
if(vLst2.size()>0){
	hMap2= (HashMap)vLst2.get(0);
}
String bas_mm = "";
bas_mm = (String)hMap2.get("bas_mm");
System.out.println("bas_mm = "+bas_mm + "월");

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	    <%@ include file="../comm/library.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>평가일정 설정</title>
		<script language="javascript">
			$(document).ready(function(){
				$("#bas_mm").val(<%=bas_mm%>);
				// ibsheet 초기화
				initIBSheet();
				initIBSheet2();
			});
			
			/*Sheet 기본 설정 */
			
			function initIBSheet() {
				//시트 초기화
				
			mySheet.Reset();
			var initData = {};
			initData.Cfg = {DataRowHeight:38,FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"영역"					,Type:"Text",MinHeight:50,Width:300,Align:"Center",SaveName:"area",Wrap:1,MinWidth:60,Edit:0},
				{Header:"1월"					,Type:"Text",Width:100,Align:"Center",SaveName:"jan",Wrap:1,MinWidth:60,Edit:0},
				{Header:"2월"					,Type:"Text",Width:100,Align:"Center",SaveName:"feb",Wrap:1,MinWidth:60,Edit:0},
				{Header:"3월"					,Type:"Text",Width:100,Align:"Center",SaveName:"mar",Wrap:1,MinWidth:60,Edit:0},
				{Header:"4월"					,Type:"Text",Width:100,Align:"Center",SaveName:"apr",Wrap:1,MinWidth:60,Edit:0},
				{Header:"5월"					,Type:"Text",Width:100,Align:"Center",SaveName:"may",Wrap:1,MinWidth:60,Edit:0},
				{Header:"6월"					,Type:"Text",Width:100,Align:"Center",SaveName:"jun",Wrap:1,MinWidth:60,Edit:0},
				{Header:"7월"					,Type:"Text",Width:100,Align:"Center",SaveName:"jul",Wrap:1,MinWidth:60,Edit:0},
				{Header:"8월"					,Type:"Text",Width:100,Align:"Center",SaveName:"aug",Wrap:1,MinWidth:60,Edit:0},
				{Header:"9월"					,Type:"Text",Width:100,Align:"Center",SaveName:"sep",Wrap:1,MinWidth:60,Edit:0},
				{Header:"10월"					,Type:"Text",Width:100,Align:"Center",SaveName:"oct",Wrap:1,MinWidth:60,Edit:0},
				{Header:"11월"					,Type:"Text",Width:100,Align:"Center",SaveName:"nov",Wrap:1,MinWidth:60,Edit:0},
				{Header:"12월"					,Type:"Text",Width:100,Align:"Center",SaveName:"dec",Wrap:1,MinWidth:60,Edit:0},
				
				];/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			//mySheet.SetSelectionMode(0);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search');
			}
			
			function initIBSheet2() {
				var initdata = {};
				initdata.Cfg = { MergeSheet: msHeaderOnly };
				initdata.Cols = [
					{ Header: "영역|영역",									Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 100, BackColor: gridColor.th_bg },
					{ Header: "해당월\n평가대상여부|해당월\n평가대상여부",			Type: "RadioCheck",	SaveName: "tgt_yn",	Align: "Center",	Width: 10,	MinWidth: 150 },
					{ Header: "계획일정|시작일",							Type: "Text",	SaveName: "st_dt",	Align: "Center",	Width: 10,	MinWidth: 150 },
					{ Header: "계획일정|마감일",							Type: "Text",	SaveName: "ed_dt",	Align: "Center",	Width: 10,	MinWidth: 80 },
					{ Header: "실제일정|시작일",							Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 80 },
					{ Header: "실제일정|마감일",							Type: "",	SaveName: "",	Align: "Center",	Width: 10,	MinWidth: 80 },
					{ Header: "진행현황|진행현황",							Type: "Text",	SaveName: "stsc",	Align: "Center",	Width: 10,	MinWidth: 60 },
				];
				IBS_InitSheet(mySheet2, initdata);
				mySheet2.SetSelectionMode(4);
				mySheet2.SetCountPosition(0);

				doAction('search2');
			}
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				if(Row >= mySheet.GetDataFirstRow()){
				}
			}
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert('onclick!');
				for(var i=1; i<mySheet.LastCol()+1;i++) {
					if(Row >= mySheet.GetDataFirstRow()) {
						if(mySheet.ColSaveName(Col)==mySheet.ColSaveName(0,i)) { //선택한 셀의 값
							if(Col==1) $("#bas_mm").val("01");
							else if(Col==2) $("#bas_mm").val("02");
							else if(Col==3) $("#bas_mm").val("03");
							else if(Col==4) $("#bas_mm").val("04");
							else if(Col==5) $("#bas_mm").val("05");
							else if(Col==6) $("#bas_mm").val("06");
							else if(Col==7) $("#bas_mm").val("07");
							else if(Col==8) $("#bas_mm").val("08");
							else if(Col==9) $("#bas_mm").val("09");
							else if(Col==10) $("#bas_mm").val("10");
							else if(Col==11) $("#bas_mm").val("11");
							else if(Col==12) $("#bas_mm").val("12");
							doAction("search2");
						}
					}
				}
			}
			function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				
			}
			function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert('onclick!');
				
			}
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD010902");
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "search2":  //데이터 조회	
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD010903");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "save":      //저장할 데이터 추출
						
						/*if($("#lv4_bsn_prsnm").val() == ""){
							alert("프로세스명을 입력해 주십시오.");
							$("#lv4_bsn_prsnm").focus();
							return;
						}*/
						if(!confirm("저장하시겠습니까?")) return;
					
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "adm");
						if($("#mode").val() == "I"){
							WP.setParameter("process_id", "ORAD010904");
						}else if($("#mode").val() == "U"){
							WP.setParameter("process_id", "ORAD010905");
						}else{
							return;
						}
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						//alert(inputData);
						showLoadingWs(); // 프로그래스바 활성화
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
							},
						  
							error: function(rtnMsg){
								alert(JSON.stringify(rtnMsg));
							}
						});
						break;
					
				}
			}
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "jan")=="0") mySheet.SetCellValue(i,"jan","●");
						else if(mySheet.GetCellValue(i, "jan")=="1") mySheet.SetCellValue(i,"jan","◐");
						else if(mySheet.GetCellValue(i, "jan")=="2") mySheet.SetCellValue(i,"jan","○");
						else if(mySheet.GetCellValue(i, "jan")=="3") mySheet.SetCellValue(i,"jan","-");
						if(mySheet.GetCellValue(i, "feb")=="0") mySheet.SetCellValue(i,"feb","●");
						else if(mySheet.GetCellValue(i, "feb")=="1") mySheet.SetCellValue(i,"feb","◐");
						else if(mySheet.GetCellValue(i, "feb")=="2") mySheet.SetCellValue(i,"feb","○");
						else if(mySheet.GetCellValue(i, "feb")=="3") mySheet.SetCellValue(i,"feb","-");
						if(mySheet.GetCellValue(i, "mar")=="0") mySheet.SetCellValue(i,"mar","●");
						else if(mySheet.GetCellValue(i, "mar")=="1") mySheet.SetCellValue(i,"mar","◐");
						else if(mySheet.GetCellValue(i, "mar")=="2") mySheet.SetCellValue(i,"mar","○");
						else if(mySheet.GetCellValue(i, "mar")=="3") mySheet.SetCellValue(i,"mar","-");
						if(mySheet.GetCellValue(i, "apr")=="0") mySheet.SetCellValue(i,"apr","●");
						else if(mySheet.GetCellValue(i, "apr")=="1") mySheet.SetCellValue(i,"apr","◐");
						else if(mySheet.GetCellValue(i, "apr")=="2") mySheet.SetCellValue(i,"apr","○");
						else if(mySheet.GetCellValue(i, "apr")=="3") mySheet.SetCellValue(i,"apr","-");
						if(mySheet.GetCellValue(i, "may")=="0") mySheet.SetCellValue(i,"may","●");
						else if(mySheet.GetCellValue(i, "may")=="1") mySheet.SetCellValue(i,"may","◐");
						else if(mySheet.GetCellValue(i, "may")=="2") mySheet.SetCellValue(i,"may","○");
						else if(mySheet.GetCellValue(i, "may")=="3") mySheet.SetCellValue(i,"may","-");
						if(mySheet.GetCellValue(i, "jun")=="0") mySheet.SetCellValue(i,"jun","●");
						else if(mySheet.GetCellValue(i, "jun")=="1") mySheet.SetCellValue(i,"jun","◐");
						else if(mySheet.GetCellValue(i, "jun")=="2") mySheet.SetCellValue(i,"jun","○");
						else if(mySheet.GetCellValue(i, "jun")=="3") mySheet.SetCellValue(i,"jun","-");
						if(mySheet.GetCellValue(i, "jul")=="0") mySheet.SetCellValue(i,"jul","●");
						else if(mySheet.GetCellValue(i, "jul")=="1") mySheet.SetCellValue(i,"jul","◐");
						else if(mySheet.GetCellValue(i, "jul")=="2") mySheet.SetCellValue(i,"jul","○");
						else if(mySheet.GetCellValue(i, "jul")=="3") mySheet.SetCellValue(i,"jul","-");
						if(mySheet.GetCellValue(i, "aug")=="0") mySheet.SetCellValue(i,"aug","●");
						else if(mySheet.GetCellValue(i, "aug")=="1") mySheet.SetCellValue(i,"aug","◐");
						else if(mySheet.GetCellValue(i, "aug")=="2") mySheet.SetCellValue(i,"aug","○");
						else if(mySheet.GetCellValue(i, "aug")=="3") mySheet.SetCellValue(i,"aug","-");
						if(mySheet.GetCellValue(i, "sep")=="0") mySheet.SetCellValue(i,"sep","●");
						else if(mySheet.GetCellValue(i, "sep")=="1") mySheet.SetCellValue(i,"sep","◐");
						else if(mySheet.GetCellValue(i, "sep")=="2") mySheet.SetCellValue(i,"sep","○");
						else if(mySheet.GetCellValue(i, "sep")=="3") mySheet.SetCellValue(i,"sep","-");
						if(mySheet.GetCellValue(i, "oct")=="0") mySheet.SetCellValue(i,"oct","●");
						else if(mySheet.GetCellValue(i, "oct")=="1") mySheet.SetCellValue(i,"oct","◐");
						else if(mySheet.GetCellValue(i, "oct")=="2") mySheet.SetCellValue(i,"oct","○");
						else if(mySheet.GetCellValue(i, "oct")=="3") mySheet.SetCellValue(i,"oct","-");
						if(mySheet.GetCellValue(i, "nov")=="0") mySheet.SetCellValue(i,"nov","●");
						else if(mySheet.GetCellValue(i, "nov")=="1") mySheet.SetCellValue(i,"nov","◐");
						else if(mySheet.GetCellValue(i, "nov")=="2") mySheet.SetCellValue(i,"nov","○");
						else if(mySheet.GetCellValue(i, "nov")=="3") mySheet.SetCellValue(i,"nov","-");
						if(mySheet.GetCellValue(i, "dec")=="0") mySheet.SetCellValue(i,"dec","●");
						else if(mySheet.GetCellValue(i, "dec")=="1") mySheet.SetCellValue(i,"dec","◐");
						else if(mySheet.GetCellValue(i, "dec")=="2") mySheet.SetCellValue(i,"dec","○");
						else if(mySheet.GetCellValue(i, "dec")=="3") mySheet.SetCellValue(i,"dec","-");
					}
					var y_val = $("#sch_bas_y").val();
					$("#c_bas_y").html('(평가연도 : <strong class="cm">'+y_val+"</strong>년)");
				}
				
				//컬럼의 너비 조정
				mySheet.FitColWidth();
			}
			function mySheet2_OnSearchEnd(code, message) {
				var m_val = $("#bas_mm").val();
				$("#c_bas_m").html('(대상 월 : <strong class="cm">'+m_val+'</strong>월)');
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
				}
				
				//컬럼의 너비 조정
				mySheet2.FitColWidth();
			}
		</script>
	</head>
	
	<body>
		<div class="container">
			<!-- page-header -->
			<%@ include file="../comm/header.jsp" %>
			<!--.page header //-->
			<!-- content -->
			<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="bas_mm" name="bas_mm" />
				<section>
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>평가연도</th>
										<td>
											<div class="select w80">
												<select name="sch_bas_y" id="sch_bas_y" class="form-control">
<%
		String temp = "";
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			if(bas_y.equals(temp)) continue; 
			else{
%>
													<option value="<%=bas_y%>" selected><%=bas_y%></option>
<%			}
			temp = bas_y;
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
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
					</div>
				</div>
				</section>
				<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">연기준 평가현황 조회 <span class="small" id="c_bas_y">(평가연도 : <strong class="cm"></strong>년)</span></h2>
					<div class="area-tool">
						<div class="area-term">
							<span class="tit">구분 : </span>
							<strong>-</strong>
							<span>일정미수립</span>
							<span class="div">/</span>
							<strong>○</strong>
							<span>미평가</span>
							<span class="div">/</span>
							<strong>◐</strong>
							<span>평가진행중</span>
							<span class="div">/</span>
							<strong>●</strong>
							<span>평가완료</span>
						</div>
					</div>
				</div>
				<div class="wrap-grid h230">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
			</section>
				
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">월별 평가일정 수립/조회 <span class="small" id="c_bas_m">(대상월 : <strong class="cm"></strong>월)</span></h2>
					<div class="area-tool">
						<button type="button" class="btn btn-default btn-xs btn-help"><i class="fa fa-exclamation-circle"></i><span class="txt">'실제일정'이란?</span></button>
						<button type="button" class="btn btn-default btn-xs"><i class="fa fa-pencil"></i><span class="txt">수정</span></button>
					</div>
				</div>
				<div class="wrap-grid h240">
					<script> createIBSheet("mySheet2", "100%", "100%"); </script>
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick=""><span class="txt">저장</span></button>
						<button type="button" class="btn btn-normal" onclick=""><span class="txt">삭제</span></button>
					</div>
				</div>
			</section>
			</form>
			</div>
			<!-- content //-->
			
		</div>
		<div id="winFamMod" class="popup modal">
			<iframe name="ifrFamMod" id="ifrFamMod" src="about:blank"></iframe>
		</div>
		<!-- popup -->
		<%@ include file="../comm/OrgInfP.jsp" %>
		<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 
		
	</body>
</html>