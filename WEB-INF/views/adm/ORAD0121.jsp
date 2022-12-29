<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0121.jsp
 Program name : ADMIN > 사용자/권한관리 > 서비스 권한 조회
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.06
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
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"search|init|resize" }; //좌측에 고정 컬럼의 수
				initData.Cols = [
				 	{Header:"상태",Type:"Status",Width:50,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:40,Edit:false},
					{Header:"삭제",Type:"DelCheck",Width:50,Align:"Center",SaveName:"del_check",MinWidth:40},		    
				    {Header:"그룹코드",Type:"Text",Width:150,Align:"Left",SaveName:"grp_org_c",MinWidth:60, Hidden:true, Edit:false, Wrap:true},				    
				    {Header:"권한그룹명",Type:"Combo",Width:200,Align:"Left",SaveName:"auth_grp_id",MinWidth:110,Edit:false,ComboText:"|<%=auth_grp_id_nm%>",ComboCode:"|<%=auth_grp_id%>"},
					{Header:"서비스ID",Type:"Text",Width:200,Align:"Left",SaveName:"svcid",MinWidth:40, Edit:false},
				    {Header:"권한그룹명(신)",Type:"Combo",Width:200,Align:"Left",SaveName:"new_auth_grp_id",MinWidth:110,ComboText:"<%=auth_grp_id_nm%>",ComboCode:"<%=auth_grp_id%>"},
					{Header:"서비스ID(신)",Type:"Text",Width:200,Align:"Left",SaveName:"new_svcid",MinWidth:40, Wrap:true}
				];
				IBS_InitSheet(mySheet,initData);
				
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet.SetCountPosition(3);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				mySheet.SetFocusAfterProcess(0);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				//헤더기능 해제
				mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				
				//doAction('search');
				
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert(Row);
			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			}
			
			function mySheet_OnRowSearchEnd (Row) {
				mySheet.SetCellValue(Row,"new_auth_grp_id",mySheet.GetCellValue(Row,"auth_grp_id"));
				mySheet.SetCellValue(Row,"new_svcid",mySheet.GetCellValue(Row,"svcid"));
				mySheet.SetCellValue(Row,"status","");
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
						$("form[name=ormsForm] [name=process_id]").val("ORAD012102");

						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;

					case "add":
						var row = mySheet.DataInsert(0);
						mySheet.SetCellValue(row,"grp_org_c","<%=grp_org_c%>");
						break;
						
					case "save":	//저장
						var sRow = mySheet.FindStatusRow("U|I|D");
						var arrow = sRow.split(";");
						
						if(arrow == ""){
							alert("저장할 내역이 없습니다.");
							return;
						}
						
						for(var i=0; i<=arrow.length; i++){
							if(mySheet.GetCellValue(arrow[i],"new_svcid") == ""){
								alert("서비스ID를 입력해 주십시오.");
								mySheet.SelectCell(arrow[i],"new_svcid","1");
								return;
							}
						}
						mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD012103");
						break;
					
					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "서비스권한.xlsx", SheetName : "Sheet1", DownTreeHide:"True", DownCols:"3|4"} ;

						mySheet.Down2Excel(params);

						break;
						
				}
			}
	
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
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

		</script>
		
	</head>
	<body onkeyPress="return EnterkeyPass()">
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th scope="row">권한그룹</th>
										<td>
											<span class="select">
												<select class="form-control w220" id="auth_grp_id" name="auth_grp_id" >
													<option value="">전체</option>
	<%
			for(int i=0;i<lshpFormCLst.size();i++){
				HashMap hMap = (HashMap)lshpFormCLst.get(i);
	%>
													<option value="<%=(String)hMap.get("auth_grp_id")%>"><%=(String)hMap.get("auth_grp_id_nm")%></option>
	<%
			}
	%>
												</select>
											</span>
										</td>
										<th scope="row">서비스ID</th>
										<td>
											<input type="text" class="form-control" id="svcid" name="svcid" placeholder="" onkeypress="EnterkeySubmit();">
										</td>
									</tr>	
								</tbody>
							</table>
						</div><!-- .box-search -->
					</div><!-- .box-body //-->						
					<div class="box-footer">						
						<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
					</div>							
				</div><!-- .box-search //-->
				</form>
				<!-- 조회 //-->
				<div class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="btn-group">
								<button class="btn btn-default btn-xs" type="button" onClick="javascript:doAction('add');"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
							</div>
							<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="box-body">
						<div class="wrap-grid h500">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
					<div class="box-footer">
						<div class="btn-wrap">
							<button class="btn btn-primary" type="button" onclick="javascript:doAction('save')"><span class="txt">저장</span></button>
						</div>
					</div>
				</div>
			</div><!-- .content //-->
		</div><!-- .container //-->		
	<!-- popup -->
	</body>
</html>