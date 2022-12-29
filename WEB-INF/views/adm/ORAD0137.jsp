<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0137.jsp
 Program name : ADMIN > 배치 > 배치작업관리 > 신규등록/상세조회 > 배치작업선택 팝업
 Description  : 
 Programer    : 권성학
 Date created : 2021.07.07
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	/*
	String sheet = request.getParameter("sheet");
	String parent_grp_org_c = request.getParameter("parent_grp_org_c");
	String parent_exe_fq = request.getParameter("parent_exe_fq");
	*/
	DynaForm form = (DynaForm)request.getAttribute("form");
	String sheet = form.get("sheet");
	String parent_grp_org_c = form.get("parent_grp_org_c");
	String parent_exe_fq = form.get("parent_exe_fq");
	
	
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs();
			
			if($("#sheet").val() == "2"){
				$("#sch_grp_org_c").val($("#parent_grp_org_c").val());
				$("#sch_grp_org_c").attr("disabled",true);
			}else{
				$("#sch_grp_org_c").val("");
				$("#sch_grp_org_c").attr("disabled",false);
			}
			
			$("#sch_btwk_exe_fq_dsc").val($("#parent_exe_fq").val());
			$("#sch_btwk_exe_fq_dsc").attr("disabled",true);
			
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, ChildPage:5,DeferredVScroll:1};
			initData.Cols = [
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
				
			}

		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				if(Col != 0){
					if(mySheet.GetCellValue(Row,"sel_check") == "0"){
						mySheet.SetCellValue(Row,"sel_check","1");
					}else if(mySheet.GetCellValue(Row,"sel_check") == "1"){
						mySheet.SetCellValue(Row,"sel_check","0");
					}
				}
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

			}
		}

		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다.");
			}
		}
		
		function mySheet_OnSaveEnd(code, msg) {
		    if(code >= 0) {
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
		
		function btwkSel(){
			var rows = mySheet.FindCheckedRow("sel_check");
			
			if(rows==""){
				alert("선택된 항목이 없습니다.");
				return;
			}else{
				var rs = rows.split("|");
				if($("#sheet").val() == "2"){
					for(var i=0;i<rs.length;i++){
						if(mySheet.GetCellValue(rs[i],"grp_org_c") != $("#parent_grp_org_c").val()){
							alert("배치작업과 동일한 계열사만 등록 가능합니다.");
							return;
						}
					}
				}
				
				for(var i=0;i<rs.length;i++){
					if($("#sheet").val() == "1"){
						parent.addPrdBtwk1(mySheet.GetCellValue(rs[i],"grp_org_c") 
								, mySheet.GetCellValue(rs[i],"grp_orgnm")
								, mySheet.GetCellValue(rs[i],"btwk_id")
								, mySheet.GetCellValue(rs[i],"btwknm")
								, mySheet.GetCellValue(rs[i],"btwk_exe_fq_dsnm")
								, mySheet.GetCellValue(rs[i],"btwk_exe_fq_dsc")
						);
					}else if($("#sheet").val() == "2"){
						if(parent.mySheet2.RowCount() >= 10){
							alert("동시작업불가배치작업은 10개까지만 등록 가능합니다.");
							return;
						}
						parent.addPrdBtwk2(mySheet.GetCellValue(rs[i],"btwk_id")
								, mySheet.GetCellValue(rs[i],"btwknm")
								, mySheet.GetCellValue(rs[i],"btwk_exe_fq_dsnm")
								, mySheet.GetCellValue(rs[i],"btwk_exe_fq_dsc")
						);
					}
				}
				
			}
			parent.closeBtwkSel();
		}

	</script>
</head>
<body style="background-color:transparent">
	<div id="" class="popup modal block">
		<div class="p_frame w1100">

			<div class="p_head">
				<h3 class="title">배치작업관리</h3>
			</div>
			<div class="p_body">
				<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="sheet" name="sheet" value="<%=sheet%>"/>
				<input type="hidden" id="parent_grp_org_c" name="parent_grp_org_c" value="<%=parent_grp_org_c%>"/>
				<input type="hidden" id="parent_exe_fq" name="parent_exe_fq" value="<%=parent_exe_fq%>"/>
				<div class="p_wrap">
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
														<option value="<%=(String)hMap.get("grp_org_c")%>" selected><%=(String)hMap.get("grp_orgnm")%></option>
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
									</tbody>
								</table>
							</div>
						</div>
						<div class="box-footer">
							<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
						</div>
					</div>
		
		
					<div class="box box-grid">
						<div class="box-body">
							<div class="wrap-grid h400">
								<script type="text/javascript">createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
					</div>
				</div>
				</form>
			</div>
			<div class="p_foot">
				<div class="btn-wrap center">
					<button type="button" class="btn btn-primary" onclick="javascript:btwkSel();">선택</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>

			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				parent.$("#ifrBtwkSel").attr("src","about:blank");
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winBtwkSel",parent.document).hide();
			parent.$("#ifrBtwkSel").attr("src","about:blank");
		}
	</script>
</body>
</html>