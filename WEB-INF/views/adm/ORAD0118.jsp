<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0118.jsp
 Program name : ADMIN > 사용자/권한관리 > 사용자로그조회
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.18
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ include file="../comm/comUtil.jsp" %>
<%
	SysDateDao dao = new SysDateDao(request);
	String today = dao.getSysdate(); //오늘날짜(yyyymmdd)
	String st_dt = today.substring(0,4)+"-"+today.substring(4,6)+"-"+today.substring(6,8);
	String ed_dt = today.substring(0,4)+"-"+today.substring(4,6)+"-"+today.substring(6,8);
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
			
			initData.Cfg = {"SearchMode":smLazyLoad, MergeSheet:msHeaderOnly, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
				{Header:"부서코드|부서코드",	Type:"Text",	Width:70,	Align:"Center",	SaveName:"brc",			Hidden:1	},
				{Header:"소속부점|부서",		Type:"Text",	Width:150,	Align:"Center",	SaveName:"brnm",		Hidden:0	},
				{Header:"소속부점|팀",		Type:"Text",	Width:150,	Align:"Center",	SaveName:"brnm_t",		Hidden:0	},
				{Header:"직원번호|직원번호",	Type:"Text",	Width:100,	Align:"Center",	SaveName:"optr_eno",	Hidden:0	},
				{Header:"성명|성명",		Type:"Text",	Width:100,	Align:"Center",	SaveName:"optr_enm",	Hidden:0	},
				{Header:"직위|직위",		Type:"Text",	Width:60,	Align:"Center",	SaveName:"pzcnm",		Hidden:0	},
				{Header:"화면|ID",		Type:"Text",	Width:150,	Align:"Center",	SaveName:"menu_id",		Hidden:0	},
				{Header:"화면|화면명",		Type:"Text",	Width:150,	Align:"Center",	SaveName:"mnnm",		Hidden:0	},
				{Header:"서비스명|서비스명",	Type:"Text",	Width:120,	Align:"Center",	SaveName:"svcid",		Hidden:0	},
				{Header:"구분|구분",		Type:"Text",	Width:50,	Align:"Center",	SaveName:"svcds",		Hidden:0	},
				{Header:"접속정보(IP)|접속정보(IP)",	Type:"Text",	Width:150,	Align:"Center",	SaveName:"ipadr",		Hidden:0	},
				{Header:"조작일시|조작일시",	Type:"Date",	Width:150,	Align:"Center",	SaveName:"opr_dtm",		Hidden:0,	Format:"yyyy-MM-dd HH:mm:ss"	}
			];
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			mySheet.SetEditable(0); //수정불가
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			mySheet.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			doAction('search');
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
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
					$("form[name=ormsForm] [name=process_id]").val("ORAD011802");
					ormsForm.sch_st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
					ormsForm.sch_ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "down2excel":
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "사용자로그조회.xlsx",  SheetName : "Sheet1", DownTreeHide:"True"} ;

					//setExcelDownCols("1|2|3|4");
					mySheet.Down2Excel(params);

					break;
			}
		}

		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
		}
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
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
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>조작일시</th>
									<td>
										<div class="form-inline">
											<div class="input-group">
												<input type="hidden" id="sch_st_dt" name="sch_st_dt">
												<input type="text" id="txt_st_dt" name="txt_st_dt" class="form-control w100" value="<%=st_dt%>" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
											<div class="input-group">
												<div class="input-group-addon"> ~ </div>
												<input type="hidden" id="sch_ed_dt" name="sch_ed_dt">
												<input type="text" id="txt_ed_dt" name="txt_ed_dt" class="form-control w100" value="<%=ed_dt%>" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</div>
									</td>
									<th>부서</th>
									<td>
										<div class="input-group w150">
											<input type="hidden" id="sch_brc" name="sch_brc" value=""/>
											<input type="text" class="form-control" id="sch_brnm" name="sch_brnm" value="" onKeyPress="EnterkeySubmitOrg('sch_brnm', 'orgSearchEnd');" onKeyUp="delTxt();">
											<span class="input-group-btn">
												<button type="button" class="btn btn-default ico search" id="sch_brnm_btn" onclick="schOrgPopup('sch_brnm', 'orgSearchEnd');">
													<i class="fa fa-search"></i><span class="blind">검색</span>
												</button>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th>사용자명</th>
									<td>
										<input type="text" id="sch_usrnm" name="sch_usernm" class="form-control w250" onkeypress="EnterkeySubmit();">
									</td>
									<th>화면 ID</th>
									<td>
										<input type="text" id="sch_menu_id" name="sch_menu_id" class="form-control w250" onkeypress="EnterkeySubmit();">
									</td>
									<th>화면명</th>
									<td>
										<input type="text" id="sch_mnnm" name="sch_mnnm" class="form-control w250" onkeypress="EnterkeySubmit();">
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
			</form>
			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h450">
						<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
			</div>
		</div>
		<!-- content //-->
	</div>	
</body>
<!-- popup -->
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->

<script>
	// 부서검색 완료
	function orgSearchEnd(brc, brnm){
		$("#sch_brc").val(brc);
		$("#sch_brnm").val(brnm);
		$("#winBuseo").hide();
		doAction('search');
	}
	
	function delTxt(){
		if($("#sch_brnm").val() == "") $("#sch_brc").val("");
	}
		
</script>
</html>