<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0134.jsp
 Program name : ADMIN > 배치 > 입수데이터 관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.07.07
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	SysDateDao dao = new SysDateDao(request);

	Calendar cal = Calendar.getInstance();
	cal.add(cal.DATE, -1);
	
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	String td_dt = dateFormatter.format(cal.getTime());

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		<script>
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet();
			});
			
			/*Sheet 기본 설정 */
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
				
				var initData = {};
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
				initData.Cols = [
					{Header:"상태",			Type:"Status",		SaveName:"status",				Hidden:true,Align:"Center",	Edit:0	},
					{Header:"선택",			Type:"CheckBox",	SaveName:"sel_check",			Width:60,	Align:"Center",	Edit:0	},
				    {Header:"그룹기관코드",		Type:"Text",		SaveName:"grp_org_c",			Hidden:true							},
				    {Header:"계열사",			Type:"Text",		SaveName:"grp_orgnm",			Width:150,	Align:"Center",	Edit:0	},
				    {Header:"배치작업ID",		Type:"Text",		SaveName:"btwk_id",				Width:120,	Align:"Center",	Edit:0	},
				    {Header:"배치작업명",		Type:"Text",		SaveName:"btwknm",				Width:240,	Align:"Left",	Edit:0	},
				    {Header:"실행주기",			Type:"Text",		SaveName:"btwk_exe_fq_dsc_nm",	Width:80,	Align:"Center",	Edit:0	},
				    {Header:"실행주기코드",		Type:"Text",		SaveName:"btwk_exe_fq_dsc",		Hidden:true							},
				    {Header:"MFTID",		Type:"Text",		SaveName:"mft_id",				Width:200,	Align:"Center",	Edit:0	},
				    {Header:"MFT 파일명",		Type:"Text",		SaveName:"surc_flnm",			Width:250,	Align:"Left",	Edit:0	},
				    {Header:"MFT파일",		Type:"Text",		SaveName:"file_exist_03_yn",	Width:80,	Align:"Center",	Edit:0	},
				    {Header:"수신파일",			Type:"Text",		SaveName:"file_exist_04_yn",	Width:80,	Align:"Center",	Edit:0	},
				    {Header:"자동/수동구분",		Type:"Text",		SaveName:"aut_mnu_dsc",			Width:140,	Align:"Center",	Edit:0	},
				    {Header:"시작일시",			Type:"Text",		SaveName:"st_dtm",				Width:140,	Align:"Center",	Edit:0	},
				    {Header:"종료일시",			Type:"Text",		SaveName:"ed_dtm",				Width:140,	Align:"Center",	Edit:0	},
				    {Header:"결과",			Type:"Text",		SaveName:"rzt_c",				Width:100,	Align:"Center",	Edit:0	},
				    {Header:"MFT파일존재체크일련번호",Type:"Text",		SaveName:"cmdl_exe_sqno_03",	Hidden:true							},
				    {Header:"수신파일존재체크일련번호",Type:"Text",		SaveName:"cmdl_exe_sqno_04",	Hidden:true							},
				    {Header:"기준일자",			Type:"Text",		SaveName:"bas_dt",				Hidden:true							}
				];
				IBS_InitSheet(mySheet,initData);
				
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet.SetCountPosition(3);
				
				mySheet.SetFocusAfterProcess(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				//mySheet.SetEditable(0);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				//헤더기능 해제
				//mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				
				doAction("search");
				
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
				if(Row >= mySheet.GetDataFirstRow()){
					$("#sel_btwk_id").val(mySheet.GetCellValue(Row,"btwk_id"));
					doAction('mod');
				}

			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				if(Row >= mySheet.GetDataFirstRow()){
					$("#sel_grp_org_c").val(mySheet.GetCellValue(Row,"grp_org_c"));
					$("#sel_btwk_id").val(mySheet.GetCellValue(Row,"btwk_id"));
				}
			}
			
			function mySheet_OnRowSearchEnd (Row) {
				
			}
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD013402");
						
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;

					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "입수데이터관리.xlsx", SheetName : "Sheet1", DownCols:"2|3|4|5|7|8|9|10|11|12|14"} ;

						mySheet.Down2Excel(params);

						break;
						
					case "execute":		//파일입수
						if(mySheet.CheckedRows("sel_check") < 1){
							alert("선택된 항목이 없습니다.");
							return;
						}
					
						if(!confirm("선택한 배치작업의 관련 파일을 입수 처리 하시겠습니까?")) return;
						//mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD013403", FormQueryStringEnc(document.ormsForm));
						mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD013403",{Quest:0});
						break;
				}
			}
	
			function mySheet_OnSearchEnd(code, message) {

				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다.");
					return;
				}
				if(mySheet.GetDataFirstRow()<0){
					return;
				}
				var min = 999999999999999;
				var max = 0;
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(mySheet.GetCellValue(j,"cmdl_exe_sqno_03") > max){
						max = mySheet.GetCellValue(j,"cmdl_exe_sqno_03");
					}
					if(mySheet.GetCellValue(j,"cmdl_exe_sqno_04") > max){
						max = mySheet.GetCellValue(j,"cmdl_exe_sqno_04");
					}
					if(mySheet.GetCellValue(j,"cmdl_exe_sqno_03") < min){
						min = mySheet.GetCellValue(j,"cmdl_exe_sqno_03");
					}
					if(mySheet.GetCellValue(j,"cmdl_exe_sqno_04") < min){
						min = mySheet.GetCellValue(j,"cmdl_exe_sqno_04");
					}
				}
				if(min <= max){
					$("form[name=ormsForm] [name=min_cmdl_exe_sqno]").val(min);
					$("form[name=ormsForm] [name=max_cmdl_exe_sqno]").val(max);
					retry_cnt = 0;
					setTimeout(checkRetry,1000);
				} 
				
			}

			var retry_cnt = 0;
			function checkRetry() {
				if(retry_cnt > 10){
					alert("파일체크 처리를 할 수 없습니다. 서버를 확인하시고 재조회 하세요.");
					return;
				}
				callORAD013404();
			}
			function callORAD013404() {
				
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("adm");
				$("form[name=ormsForm] [name=process_id]").val("ORAD013404");
	
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setForm(f);
	
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
	
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,{
					success: function(result){
						var rList = result.DATA;
						if(result!='undefined') {
							//alert("rList.length:"+rList.length)
							for(var i=0;i<rList.length;i++){
								if(rList[i].cmdl_dsc=="03" || rList[i].cmdl_dsc=="04"){
									for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
										if(rList[i].cmdl_exe_sqno==mySheet.GetCellValue(j,"cmdl_exe_sqno_03")){
											if(rList[i].cmdl_prc_stsc=="01" || rList[i].cmdl_prc_stsc=="02"){ 
												mySheet.SetCellValue(j, "file_exist_03_yn", "?");
											}else if(rList[i].cmdl_prc_stsc=="03" && rList[i].mft_fl_ext_yn != ""){
												mySheet.SetCellValue(j, "file_exist_03_yn", rList[i].mft_fl_ext_yn);
											}else{//error
												mySheet.SetCellValue(j, "file_exist_03_yn", "E");
											}
											
											if(rList[i].mft_fl_ext_yn == "Y"){
												mySheet.SetCellEditable(j,"sel_check",1);
											}else{
												mySheet.SetCellEditable(j,"sel_check",0);
											}
											break;
										}
										if(rList[i].cmdl_exe_sqno==mySheet.GetCellValue(j,"cmdl_exe_sqno_04")){
											if(rList[i].cmdl_prc_stsc=="01"|| rList[i].cmdl_prc_stsc=="02"){ 
												mySheet.SetCellValue(j, "file_exist_04_yn", "?");
											}else if(rList[i].cmdl_prc_stsc=="03" && rList[i].mft_fl_ext_yn != ""){
												mySheet.SetCellValue(j, "file_exist_04_yn", rList[i].mft_fl_ext_yn);
											}else{//error
												mySheet.SetCellValue(j, "file_exist_04_yn", "E");
											}
											break;
										}
									}
									mySheet.SetCellValue(j, "status", "");
								}
							}
							var flag =false;
							for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
								if(mySheet.GetCellValue(j,"file_exist_03_yn")=="?"){
									flag = true;
									break;
								}
								if(mySheet.GetCellValue(j,"file_exist_04_yn")=="?"){
									flag = true;
									break;
								}
							}
							if(flag){
								setTimeout(checkRetry,1000);
							}else{
								removeLoadingWs();
							}
						}else{
							removeLoadingWs();
						}
					},
	
					complete: function(statusText,status) {
						//removeLoadingWs();
					},
	
					error: function(rtnMsg) {
						alert(JSON.stringify(rtnMsg));
					}
				});
			}

			function mySheet_OnSaveEnd(code, msg) {
			    if(code >= 0) {
			    	alert("처리하였습니다.");
			    	doAction("search");
			    } else {
			    	alert("처리중 오류가 발생하였습니다.");
			    }
			}

			function EnterkeySubmit(){
				if(event.keyCode == 13){
					doAction("search");
					return true;
				}else{
					return true;
				}
			}
			
			
	</script>
	</head>
	<body>
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			<!-- content -->
			<div class="content">
				<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="min_cmdl_exe_sqno" name="min_cmdl_exe_sqno" />
				<input type="hidden" id="max_cmdl_exe_sqno" name="max_cmdl_exe_sqno" />
				
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>계열사</th>
										<td>
											<div class="input-group w150">
												<select name="sch_grp_org_c" id="sch_grp_org_c" class="form-control">
													<option value="">전체</option>
	<%
			for(int i=0;i<vAllGrpList.size();i++){
				HashMap hMap = (HashMap)vAllGrpList.get(i);
	%>
													<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
	<%
			}
	%>
												</select>										
											</div>
										</td>
										<th>실행주기</th>
										<td>
											<div class="select w150">
												<select class="form-control" id="sch_btwk_exe_fq_dsc" name="sch_btwk_exe_fq_dsc">
													<option value="">전체</option>
													<option value="1">일</option>
													<option value="2">월</option>
												</select>
											</div>
										</td>
										<th>기준일</th>
										<td class="form-inline">
											<div class="input-group">
												<input type="text" class="form-control w100" name="sch_btwk_bas_dt" id="sch_btwk_bas_dt" readonly value="<%=td_dt%>">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','sch_btwk_bas_dt');"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>배치작업ID</th>
										<td>
											<input type="text" name="sch_btwk_id" id="sch_btwk_id" class="form-control w150" onkeypress="EnterkeySubmit();" maxlength="20">
										</td>
										<th>배치작업명</th>
										<td>
											<input type="text" name="sch_btwknm" id="sch_btwknm" class="form-control w150" onkeypress="EnterkeySubmit();" maxlength="20">
										</td>
										<th>자동수동구분</th>
										<td>
											<div class="select w150">
												<select name="sch_btwk_exe_dsc" id="sch_btwk_exe_dsc" class="form-control">
													<option value="">전체</option>
													<option value="1">자동</option>
													<option value="2">수동</option>
												</select>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div><!-- .wrap-search -->
					</div><!-- .box-body //-->
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
					</div>
				</div>
				<!-- 조회 //-->
	
				<div class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('execute');"><i class="fa fa-pencil"></i><span class="txt">파일입수</span></button>
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
	
					<div class="box-body">
						<div class="wrap-grid h500">
							<script type="text/javascript">createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
				</div>
	
			</div>
			<!-- content //-->
		</div>	
	</body>
</html>