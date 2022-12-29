<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0115.jsp
 Program name : ADMIN > 사용자/권한관리 > 사용자조회
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.20
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	Vector lshpFormCLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
	if(lshpFormCLst==null) lshpFormCLst = new Vector();
	
	String auth_grp_id = "";
	String auth_grp_id_nm = "";
	
	for(int i=0;i<lshpFormCLst.size();i++){
		HashMap hp = (HashMap)lshpFormCLst.get(i);
		if(auth_grp_id==""){
			auth_grp_id += (String)hp.get("auth_grp_id");
			auth_grp_id_nm += (String)hp.get("auth_grp_id_nm");
		}else{
			auth_grp_id += ("|" + (String)hp.get("auth_grp_id"));
			auth_grp_id_nm += ("|" + (String)hp.get("auth_grp_id_nm"));
		}
	}
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
				//initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:1, ChildPage:5,DeferredVScroll:1,MergeSheet:msHeaderOnly};
				initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, DeferredVScroll:1, MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
				initData.Cols = [
					{Header:"상태|상태",								Type:"Status",		Width:60,	Align:"Center",	SaveName:"status",		Edit:0									},
					{Header:"삭제|삭제",								Type:"DelCheck",	Width:60,	Align:"Center",	SaveName:"del_check",	Edit:1,HeaderCheck:0					},	
				    {Header:"운영리스크\n부서코드|운영리스크\n부서코드",		Type:"Text",		Width:90,	Align:"Center",	SaveName:"brc",			Edit:0									},
				 	{Header:"운영리스크\n부서|운영리스크\n부서",			Type:"Popup",		Width:180,	Align:"Center",	SaveName:"brnm",		Edit:1									},
				 	{Header:"인터페이스\n부서코드|인터페이스\n부서코드",		Type:"Text",		Width:90,	Align:"Center",	SaveName:"tms_brc",		Edit:0									},
				 	{Header:"인터페이스\n부서|인터페이스\n부서",			Type:"Text",		Width:180,	Align:"Center",	SaveName:"tms_brnm",	Edit:0									},
					{Header:"직급|직급",								Type:"Text",		Width:100,	Align:"Center",	SaveName:"pzcnm",		Edit:1, EditLen:25						},		    
					{Header:"직급코드\n(정렬순서)|직급코드\n(정렬순서)",		Type:"Text",		Width:100,	Align:"Center",	SaveName:"pzcc",		Edit:1, EditLen:8						},		    
					{Header:"직명\n(정렬순서)|직명\n(정렬순서)",			Type:"Text",		Width:100,	Align:"Center",	SaveName:"oft",			Edit:1, EditLen:20						},		    
					{Header:"직명코드\n(정렬순서)|직명코드\n(정렬순서)",		Type:"Text",		Width:100,	Align:"Center",	SaveName:"oft_c",		Edit:1, EditLen:8						},		    
				    {Header:"직원번호|직원번호",							Type:"Text",		Width:90,	Align:"Center",	SaveName:"eno",			Edit:1, EditLen:8						},
				    {Header:"성명|성명",								Type:"Text",		Width:100,	Align:"Center",	SaveName:"empnm",		Edit:1, EditLen:25						},
				    {Header:"전화번호|전화번호",							Type:"Text",		Width:120,	Align:"Center",	SaveName:"tel_no",		Edit:1, EditLen:40						},
				    {Header:"권한|권한",								Type:"Text",		Width:150,	Align:"Left",	SaveName:"auth_nm",		Edit:0									},
<%--
<%if("00".equals(grp_org_c)){%>
	 				{Header:"권한|그룹ORM전담",			Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_011",	Edit:1, HeaderCheck:0					},
	 				{Header:"권한|그룹ORM팀장",			Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_012",	Edit:1, HeaderCheck:0					},
<%}%>
					{Header:"권한|ORM전담",			Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_002",	Edit:1, HeaderCheck:0					},
	 				{Header:"권한|ORM팀장",			Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_010",	Edit:1, HeaderCheck:0					},
	 				{Header:"권한|부서ORM\n업무담당자",	Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_003",	Edit:1, HeaderCheck:0					},
// 	 				{Header:"권한|손실사건담당자",		Type:"CheckBox",	Width:90,	Align:"Center",	SaveName:"auth_004",	Edit:1, HeaderCheck:0					},
	 				{Header:"권한|부서장",				Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_006",	Edit:1, HeaderCheck:0					},
// 	 				{Header:"권한|일반사용자",			Type:"CheckBox",	Width:90,	Align:"Center",	SaveName:"auth_008",	Edit:1, HeaderCheck:0					},
	 				{Header:"권한|BCP전담",			Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_005",	Edit:1, HeaderCheck:0					},
	 				{Header:"권한|BCP팀장",			Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_013",	Edit:1, HeaderCheck:0					},
	 				{Header:"권한|부서BCP\n업무담당자",	Type:"CheckBox",	Width:80,	Align:"Center",	SaveName:"auth_014",	Edit:1, HeaderCheck:0					},
--%>
				    {Header:"최종접속일시|최종접속일시",					Type:"Date",		Width:120,	Align:"Center",	SaveName:"ls_conn_dtm",	Edit:0,	Format:"yyyy-MM-dd HH:mm:ss"	},
				    {Header:"변경전부서코드|변경전부서코드",				Type:"Text",		Width:0,	Align:"Center",	SaveName:"bf_brc",		Edit:0,	Hidden:1						}
				];
				IBS_InitSheet(mySheet,initData);
				
				//mySheet.SetEditable(0); //수정불가
				
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet.SetCountPosition(3);
				
				mySheet.SetFocusAfterProcess(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				/*
				mySheet.SetToolTipText(1,"auth_011","농협금융지주 운영리스크관리자");
				mySheet.SetToolTipText(1,"auth_012","농협금융지주 운영리스크관리자의 결재권자-전 직원중 1명");
				mySheet.SetToolTipText(1,"auth_002","운영리스크관리자");
				mySheet.SetToolTipText(1,"auth_010","운영리스크관리자의 결재권자-전 직원중 1명");
				mySheet.SetToolTipText(1,"auth_003","부서 운영리스크 담당자-부서별로 1명");
				mySheet.SetToolTipText(1,"auth_006","부서 운영리스크 담당자의 결재권자-부서별로 1명");
				mySheet.SetToolTipText(1,"auth_005","BCP관리자");
				mySheet.SetToolTipText(1,"auth_013","BCP관리자의 결재권자-전 직원중 1명");
				mySheet.SetToolTipText(1,"auth_014","부서 BCP 담당자-부서별로 1명");
				*/
				
				doAction("search");
				
			}
			
			//Popup,PopupEdit 컬럼에 팝업 버튼 클릭시 호출 이벤트
			function mySheet_OnPopupClick(Row,Col){
				$("#brc").val(mySheet.GetCellValue(Row,"brc"));
				$("#brnm").val(mySheet.GetCellValue(Row,"brnm"));
				$("#row").val(Row);
				
				schOrgPopup('dummy','orgSelectEnd');
			}
			
			function orgSelectEnd(brc, brnm){
				$("#brc").val(brc);
				$("#brnm").val(brnm);
				mySheet.SetCellValue($("#row").val(),"brc",brc);
				mySheet.SetCellValue($("#row").val(),"brnm",brnm);
				$("#winBuseo").hide();
				//doAction('search');
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				if(Row >= mySheet.GetDataFirstRow()){
					$("#row").val(Row);
					$("#brc").val(mySheet.GetCellValue(Row,"brc"));
					$("#brnm").val(mySheet.GetCellValue(Row,"brnm"));
				}
			}
			
			function mySheet_OnRowSearchEnd (Row) {
				mySheet.SetCellValue(Row,"bf_brc",mySheet.GetCellValue(Row,"brc"));
				mySheet.SetCellEditable(Row,"eno",0);
				mySheet.SetCellValue(Row,"status","");
			}
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD011502");

						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;

					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "사용자정보.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"2|3|4|5|6|7|8|9|10|11|12|13|14"} ;
						mySheet.Down2Excel(params);

						break;
					case "add":
						var row = mySheet.DataInsert(0);
						break;	
					case "save":
						var sRow = mySheet.FindStatusRow("U|I|D");
						var arrow = sRow.split(";");
						
						if(arrow == ""){
							alert("저장할 내역이 없습니다.");
							return;
						}
						
						for(var i=0; i<=arrow.length; i++){
							if(mySheet.GetCellValue(arrow[i],"status") != "D"){
								if(mySheet.GetCellValue(arrow[i],"brc") == ""){
									alert("부서를 선택해 주십시오.");
									mySheet_OnPopupClick(arrow[i],"brnm");
									return;
								}
								if(mySheet.GetCellValue(arrow[i],"pzcnm") == ""){
									alert("직급을 입력해 주십시오.");
									mySheet.SelectCell(arrow[i],"pzcnm","1");
									return;
								}
								if(mySheet.GetCellValue(arrow[i],"oft") == ""){
									alert("직명을 입력해 주십시오.");
									mySheet.SelectCell(arrow[i],"oft","1");
									return;
								}
								if(mySheet.GetCellValue(arrow[i],"eno") == ""){
									alert("직원번호를 입력해 주십시오.");
									mySheet.SelectCell(arrow[i],"eno","1");
									return;
								}
								if(mySheet.GetCellValue(arrow[i],"empnm") == ""){
									alert("성명을 입력해 주십시오.");
									mySheet.SelectCell(arrow[i],"empnm","1");
									return;
								}
								
								if(mySheet.GetCellValue(arrow[i],"status") == "U"){
									if(mySheet.GetCellValue(arrow[i],"brc") != mySheet.GetCellValue(arrow[i],"bf_brc")){
										alert("부서 변경시 변경전 부서의 권한이 모두 삭제됩니다.");
									}
								}
							}
						}
						
						mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD011503");
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
			        alert("저장되었습니다.");  // 저장 성공 메시지
			        doAction("search");      
			    } else {
			    	if(msg!=""){
			    		alert(msg);
			    	}else{
				        alert("처리중 오류가 발생하였습니다."); // 저장 실패 메시지
			    	}
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
			
			function userUploadPop(){
				var f = document.ormsForm;
				f.path.value="/adm/ORAD0128";
		        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
				f.target = "ifrUserUpload";
				f.submit();

			}

	</script>
		
	</head>
	<body onkeyPress="return EnterkeyPass()">
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			<!-- content -->
			<div class="content">
				<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="brc" name="brc" />
				<input type="hidden" id="brnm" name="brnm" />
				<input type="hidden" id="row" name="row" />
				<input type="hidden" id="dummy" name="dummy" />
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>부서</th>
										<td>
											<div class="input-group w150">
												<input type="hidden" id="sch_brc" name="sch_brc" />
												<input type="text" class="form-control" id="sch_brnm" name="sch_brnm" onKeyPress="EnterkeySubmitOrg('sch_brnm', 'orgSearchEnd');" onKeyUp="delTxt();">
												<span class="input-group-btn">
													<button class="btn btn-default ico search" type="button" onclick="schOrgPopup('sch_brnm', 'orgSearchEnd');">
														<i class="fa fa-search"></i><span class="blind">검색</span>
													</button>
												</span>
											</div>
										</td>
										<th>권한</th>
										<td>
											<div class="select w170">
												<select class="form-control" id="auth_grp_id" name="auth_grp_id">
													<option value="">전체</option>
		<%
				for(int i=0;i<lshpFormCLst.size();i++){
					HashMap hMap = (HashMap)lshpFormCLst.get(i);
					if(!"008".equals((String)hMap.get("auth_grp_id"))){
		%>
														<option value="<%=(String)hMap.get("auth_grp_id")%>"><%=(String)hMap.get("auth_grp_id_nm")%></option>
		<%
					}
				}
		%>
												</select>
											</div>
										</td>
										<th>사용자명</th>
										<td>
											<div class="input-group w150">
												<input type="text" class="form-control" id="empnm" name="empnm" onkeypress="EnterkeySubmit();">
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
				<div class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="btn-group">
								<%--
								<button type="button" class="btn btn-default btn-xs" onclick="javascript:userUploadPop()">
									<i class="fa fa-plus"></i>
									<span class="txt">사용자 전체 업로드</span>
								</button>
								 --%>
								<button type="button" class="btn btn-default btn-xs" onClick="javascript:doAction('add');">
									<i class="fa fa-plus"></i>
									<span class="txt">신규등록</span>
								</button>
							</div>
							<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="box-body">
						<div class="wrap-grid h450">
							<script type="text/javascript">createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
					<div class="box-footer">
						<div class="btn-wrap">
<!-- 							<button type="button" class="btn btn-default btn-sm" onclick="javascript:userUploadPop()"><i class="fa fa-plus"></i><span class="txt">사용자 전체 업로드</span></button> -->
							<button type="button" class="btn btn-primary" onclick="javascript:doAction('save')"><span class="txt">저장</span></button>
						</div>
					</div>
				</div>
				</form>
			</div>
			<!-- content //-->
			
		</div>	
	<!-- popup -->
	</body>
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	<div id='winUserUpload' class='popup modal' style="background-color:transparent">
		<iframe id='ifrUserUpload' src="about:blank" name='ifrUserUpload' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
	</div>
	<div id='winUserInsert' class='popup modal' style="background-color:transparent">
		<iframe id='ifrUserInsert' src="about:blank" name='ifrUserInsert' frameborder='no' scrolling='no' valign='middle' align='center' width='100%' height='100%' allowTransparency="true"></iframe>
	</div>
</html>