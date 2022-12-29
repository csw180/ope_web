<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0131.jsp
 Program name : ADMIN > 배치 > 배치작업관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.07.07
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
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
					{Header:"상태",Type:"Status",	SaveName:"status",Hidden:true,Width:30,Align:"Center",MinWidth:10},
					{Header:"선택",			Type:"CheckBox",	SaveName:"sel_check",			Width:60,	Align:"Center",	Edit:1	},
				    {Header:"그룹기관코드",		Type:"Text",		SaveName:"grp_org_c",			Hidden:true							},
				    {Header:"계열사",			Type:"Text",		SaveName:"grp_orgnm",			Width:150,	Align:"Center",	Edit:0	},
				    {Header:"배치작업ID",		Type:"Text",		SaveName:"btwk_id",				Width:120,	Align:"Center",	Edit:0	},
				    {Header:"배치작업명",		Type:"Text",		SaveName:"btwknm",				Width:240,	Align:"Left",	Edit:0	},
				    {Header:"실행주기",		Type:"Text",		SaveName:"btwk_exe_fq_dsnm",	Width:80,	Align:"Center",	Edit:0	},
				    {Header:"실행주기코드",		Type:"Text",		SaveName:"btwk_exe_fq_dsc",		Hidden:true							},
				    {Header:"실행경로",		Type:"Text",		SaveName:"bat_exe_pathnm",		Width:250,	Align:"Left",	Edit:0	},
				    {Header:"휴일실행여부",		Type:"Text",		SaveName:"hldy_wk_exe_dsnm",	Width:120,	Align:"Center",	Edit:0	},
				    {Header:"휴일실행코드",		Type:"Text",		SaveName:"hldy_wk_exe_dsc",		Hidden:true							},
				    {Header:"MFT ID",		Type:"Text",		SaveName:"mft_id",				Width:150,	Align:"Center",	Edit:0	},
				    {Header:"MFT 경로",		Type:"Text",		SaveName:"surc_fl_pathnm",		Width:250,	Align:"Left",	Edit:0	},
				    {Header:"MFT 파일명",		Type:"Text",		SaveName:"surc_flnm",			Width:140,	Align:"Left",	Edit:0	},
				    {Header:"실행 제외여부",		Type:"Text",		SaveName:"exe_x_yn",			Width:100,	Align:"Center",	Edit:0	}
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
						$("form[name=ormsForm] [name=process_id]").val("ORAD013102");
						
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;

					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "배치작업.xlsx", SheetName : "Sheet1", DownCols:"2|3|4|5|7|8|10|11|12|13"} ;

						mySheet.Down2Excel(params);

						break;
					case "add":		//신규등록 팝업
						$("#ifrBtwkSchdAdd").attr("src","about:blank");
						$("#winBtwkSchdAdd").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(addBtwkSchd,100);
						
						break; 
					case "mod":		//수정 팝업
						if($("#sel_btwk_id").val() == ""){
							alert("배치작업을 선택하세요.");
							return;
						}
					
						$("#ifrBtwkSchdMod").attr("src","about:blank");
						$("#winBtwkSchdMod").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modBtwkSchd,1);
						
						break;
					case "del":		//삭제
						if(mySheet.CheckedRows("sel_check") < 1){
							alert("삭제할 항목을 선택해주세요.");
							return;
						}
					
						if(!confirm("선택한 배치작업을 삭제 하시겠습니까?")) return;
						mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD013103",{Quest:0});
						break;
				}
			}
	
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다.");
				}
			}
			
			function mySheet_OnSaveEnd(code, msg) {
			    if(code >= 0) {
			    	alert("삭제되었습니다.");
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
			
			function addBtwkSchd(){
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="adm";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORAD013201";
				f.target = "ifrBtwkSchdAdd";
				f.submit();
			}
			
			function modBtwkSchd(){
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="adm";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORAD013301";
				f.target = "ifrBtwkSchdMod";
				f.submit();
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
				<input type="hidden" id="sel_grp_org_c" name="sel_grp_org_c" />
				<input type="hidden" id="sel_btwk_id" name="sel_btwk_id" />
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tr>
									<th>계열사</th>
									<td>
										<div class="select w150">
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
										<div class="select w120">
											<select class="form-control" id="sch_btwk_exe_fq_dsc" name="sch_btwk_exe_fq_dsc">
												<option value="">전체</option>
												<option value="1">일</option>
												<option value="2">월</option>
											</select>
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
										<input type="text" name="sch_btwknm" id="sch_btwknm" class="form-control w250" onkeypress="EnterkeySubmit();" maxlength="20">
									</td>
								</tr>
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
							<div class="btn-group">
								<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('add');"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
								<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
							</div>
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('mod');"><i class="fa fa-pencil"></i><span class="txt">상세조회</span></button>
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
		<div id="winBtwkSchdAdd" class="popup modal" style="background-color:transparent">
			<iframe name="ifrBtwkSchdAdd" id="ifrBtwkSchdAdd" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
		</div>
		<div id="winBtwkSchdMod" class="popup modal" style="background-color:transparent">
			<iframe name="ifrBtwkSchdMod" id="ifrBtwkSchdMod" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
		</div>
		<iframe name="ifrDummy" id="ifrDummy" src="about:blank" width="0" height="0" style="visibility:hidden;display:none"></iframe>
		
	</body>
</html>