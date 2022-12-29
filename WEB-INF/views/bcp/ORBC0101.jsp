<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0101.jsp
 Program name : BIA 평가 관리
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

Vector vLst = CommUtil.getCommonCode(request, "BIA_EVL_PRG_STSC"); //통합코드 조회 
if(vLst==null) vLst = new Vector();
Vector vLst_ra = CommUtil.getCommonCode(request, "RA_EVL_PRG_STSC"); //통합코드 조회 
if(vLst_ra==null) vLst_ra = new Vector();
Vector vLst2 = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList"); //평가년도 조회
if(vLst2==null) vLst2 = new Vector();

DynaForm form = (DynaForm)request.getAttribute("form");

String bcp_menu_dsc = (String)form.get("bcp_menu_dsc");
System.out.println(bcp_menu_dsc);

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd 

%>   
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			$("#bcp_menu_dsc").val(<%=bcp_menu_dsc%>);
			//ibsheet 초기화
			if($("#bcp_menu_dsc").val()=='1') {
				initIBSheet();
			}else if($("#bcp_menu_dsc").val()=='2') {
				initIBSheet2();
			}
		});
		
		/********************************************************* 
		BIA 평가 관리
		*********************************************************/
		/* Sheet 기본 설정 */
		function initIBSheet(){
			//시트초기화
			mySheet.Reset();

			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"평가년도",		Type:"Text",	Width:150,		 	MinWidth:50,		Align:"Center",		SaveName:"bia_yy",			Edit:0},
				{Header:"수행시작일",		Type:"Text",	Width:150,		 MinWidth:80,		Align:"Center",		SaveName:"bia_evl_st_dt",		Edit:0},
				{Header:"수행종료일",		Type:"Text",	Width:150,		 MinWidth:80,		Align:"Center",		SaveName:"bia_evl_ed_dt",		Edit:0},
				{Header:"등록/변경사유",	Type:"Text",	Width:400,			MinWidth:160,		Align:"Left",		SaveName:"bia_schd_upd_rsn",		Edit:0},
				{Header:"상태",			Type:"Text",	Width:150,		 MinWidth:80,		Align:"Center",		SaveName:"bia_evl_prg",		Edit:0},
				{Header:"상태코드",		Type:"Text",	Width:260,		 	MinWidth:80,		Align:"Left",		SaveName:"bia_evl_prg_stsc",Edit:0, Hidden:true},
				{Header:"평가종료",		Type:"Html",	Width:150,		 	MinWidth:80,		Align:"Center",		SaveName:"bia_evl_end",		Edit:0},
				{Header:"status",		Type:"Status",	Width:200,		 MinWidth:50,		Align:"Left",		SaveName:"status",			Edit:0, Hidden:true}
			]
			
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			//mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			
			doAction('search');
		}
		function initIBSheet2(){
			//시트초기화
			mySheet2.Reset();

			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"평가년도",		Type:"Text",	Width:150,		 	MinWidth:50,		Align:"Center",		SaveName:"ra_yy",			Edit:0},
				{Header:"수행시작일",		Type:"Text",	Width:150,		 MinWidth:80,		Align:"Center",		SaveName:"ra_evl_st_dt",		Edit:0},
				{Header:"수행종료일",		Type:"Text",	Width:150,		 MinWidth:80,		Align:"Center",		SaveName:"ra_evl_ed_dt",		Edit:0},
				{Header:"등록/변경사유",	Type:"Text",	Width:400,			MinWidth:160,		Align:"Left",		SaveName:"ra_schd_upd_rsn",		Edit:0},
				{Header:"상태",			Type:"Text",	Width:150,		 MinWidth:80,		Align:"Center",		SaveName:"ra_evl_prg",		Edit:0},
				{Header:"상태코드",		Type:"Text",	Width:260,		 	MinWidth:80,		Align:"Left",		SaveName:"ra_evl_prg_stsc",Edit:0, Hidden:true},
				{Header:"평가종료",		Type:"Html",	Width:150,		 	MinWidth:80,		Align:"Center",		SaveName:"ra_evl_end",		Edit:0},
				{Header:"status",		Type:"Status",	Width:200,		 MinWidth:50,		Align:"Left",		SaveName:"status",			Edit:0, Hidden:true}
			]
			
			IBS_InitSheet(mySheet2,initData);
			
			//필터표시
			//nySheet.ShowFilterRow();
			
			//건수 표시줄 표시위치(0: 표시하지않음, 1: 좌측상단, 2: 우측상단, 3: 촤측하단, 4: 우측하단)
			mySheet2.SetCountPosition(3);
			
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			//mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0,ColMove:0});
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번을 GetSelectionRows() 함수이용확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMene(mySheet);
			doAction('search2');
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			var today = $("#today").val();
			var bia_evl_st_dt = "";
			if(Row >= mySheet.GetDataFirstRow()){
				
				bia_evl_st_dt = mySheet.GetCellValue(Row,"bia_evl_st_dt");
				bia_evl_st_dt = bia_evl_st_dt.replace(/-/gi,'');
				//alert("수정가능");
				
				//$("#st_bia_yy").val(mySheet.GetCellValue(Row,"bia_yy"));
				//alert($("#st_bia_yy").val());
				doAction("add");
			}
		}
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet.GetDataFirstRow()){
				$("#sch_bia_yy").val(mySheet.GetCellValue(Row,"bia_yy"));
			}
		}
		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
			var today = $("#today").val();
			var ra_evl_st_dt = "";
			if(Row >= mySheet2.GetDataFirstRow()){
				
				ra_evl_st_dt = mySheet2.GetCellValue(Row,"ra_evl_st_dt");
				ra_evl_st_dt = ra_evl_st_dt.replace(/-/gi,'');
				//alert("수정가능");
				
				//$("#st_bia_yy").val(mySheet.GetCellValue(Row,"bia_yy"));
				//alert($("#st_bia_yy").val());
				doAction("add2");
			
			}
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			//alert(Row);
			if(Row >= mySheet2.GetDataFirstRow()){
				$("#sch_ra_yy").val(mySheet2.GetCellValue(Row,"ra_yy"));
			}
		}
		
		function mySheet_OnChange(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
		}
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/* Sheet 각종 처리 */
		function doAction(sAction){
			switch(sAction){
				case "search": //bia데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010102");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "search2": //ra데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC010105");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
 				case "add":
					showLoadingWs();
					//$("#ifrBiaAdd").attr("src","about:blank");
					$("#winBiaAdd").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="bcp";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORBC010201";
					f.target = "ifrBiaAdd";
					f.submit();	
					break;
 				case "add2":
 					showLoadingWs();
					$("#winRaAdd").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="bcp";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORBC011101";
					f.target = "ifrRaAdd";
					f.submit();	
 					break;

			}
		}
		
		function mySheet_OnSearchEnd(code, message){
			if(code != 0){
				alert("BIA 평가 관리 조회 중에 오류가 발생하였습니다..");
			}else{
			}
			
		    
		    if(mySheet.GetDataFirstRow()>0){
		    	for(var i=1; i<=mySheet.GetDataLastRow(); i++){
	    			mySheet.SetCellValue(i, "bia_evl_end", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:complete('+i+');">완료</button>');
	    			mySheet.SetCellValue(i, "status", "");
		    	}
		    }
		}
		function mySheet2_OnSearchEnd(code, message){
			if(code != 0){
				alert("RA 평가 관리 조회 중에 오류가 발생하였습니다..");
			}else{
			}
		    if(mySheet2.GetDataFirstRow()>0){
		    	for(var i=1; i<=mySheet2.GetDataLastRow(); i++){
	    			mySheet2.SetCellValue(i, "ra_evl_end", '<button type="button" class="btn btn-default btn-xs" onclick="javascript:complete('+i+');">완료</button>');
	    			mySheet2.SetCellValue(i, "status", "");
		    	}
		    }
		}
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		        doAction('search');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        doAction('search');
		    }
		}
		function mySheet2_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		    	alert(msg);  // 저장 성공 메시지
		        doAction('search2');
		    } else {
		        alert(msg); // 저장 실패 메시지
		        doAction('search2');
		    }
		}
		
		function complete(row){
			mySheet.SetCellValue(row, "status", "U");
			mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=bcp&process_id=ORBC010103");
		}
		function complete2(row){
			mySheet2.SetCellValue(row, "status", "U");
			mySheet2.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=bcp&process_id=ORBC010106");
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
				<input type="hidden" id="today" name="today" value="<%=dt %>" />
				<input type="hidden" id="sch_bia_yy" name="sch_bia_yy" />		
				<input type="hidden" id="sch_ra_yy" name="sch_ra_yy" />		
				<input type="hidden" id="bcp_menu_dsc" name="bcp_menu_dsc" />		
<%if(bcp_menu_dsc.equals("1")){ %>
			<!-- 조회 BIA-->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가년도</th>
									<td>
										<div class="select w150">
											<select class="form-control" id="st_bia_yy" name="st_bia_yy" >
												<option value="">전체</option>
<%
for(int i=0;i<vLst2.size();i++){
	HashMap hMap = (HashMap)vLst2.get(i);

%>
										   		<option value="<%=(String)hMap.get("bia_yy")%>"><%=(String)hMap.get("bia_yy")%></option>
<%
}
%>															
											</select>
										</div>
									</td>
									<th>진행상태</th>
									<td>
										<div class="select w150">
											<select class="form-control" id="st_bia_evl_prg" name="st_bia_evl_prg" >
												<option value="">전체</option>
<%
for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
%>
										   		<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
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
			<!-- //조회 BIA-->
<%}else if(bcp_menu_dsc.equals("2")){ %>
			<!-- 조회 RA-->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>평가년도</th>
									<td>
										<div class="select w150">
											<select class="form-control" id="st_ra_yy" name="st_ra_yy" >
												<option value="">전체</option>
<%
for(int i=0;i<vLst2.size();i++){
	HashMap hMap = (HashMap)vLst2.get(i);

%>
										   		<option value="<%=(String)hMap.get("ra_yy")%>"><%=(String)hMap.get("ra_yy")%></option>
<%
}
%>															
											</select>
										</div>
									</td>
									<th>진행상태</th>
									<td>
										<div class="select w150">
											<select class="form-control" id="st_ra_evl_prg" name="st_ra_evl_prg" >
												<option value="">전체</option>
<%
for(int i=0;i<vLst_ra.size();i++){
	HashMap hMap = (HashMap)vLst_ra.get(i);
%>
										   		<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
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
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search2');">조회</button>
				</div>
			</div>
			<!-- //조회 RA-->
<%} %>
			</form>
<%if(bcp_menu_dsc.equals("1")){ %>
			<section class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button  type="button" class="btn btn-default btn-xs"  onclick="javascript:doAction('add');">
							<i class="fa fa-plus"></i><span class="txt">일정변경 및 AHP등록</span>
						</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h550">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
			</section>
<%}else if(bcp_menu_dsc.equals("2")){ %>
			<section class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button  type="button" class="btn btn-default btn-xs"  onclick="javascript:doAction('add2');">
							<i class="fa fa-plus"></i><span class="txt">일정변경 및 관리대상 위험</span>
						</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h550">
						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div>
				</div>
			</section>
<%} %>
		</div>
		<!-- content //-->			
	</div><!-- .container //-->
	
	<!-- popup //-->
	<div id="winBiaAdd" class="popup modal">
		<iframe name="ifrBiaAdd" id="ifrBiaAdd" src="about:blank"></iframe>	
	</div>	
	<div id="winRaAdd" class="popup modal">
		<iframe name="ifrRaAdd" id="ifrRaAdd" src="about:blank"></iframe>	
	</div>	
	<iframe name="ifrDummy" id="ifrDummy" src="about:blank"></iframe>
</body>
	
</html>