<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0112.jsp
 Program name : 선행 업무프로세스(팝업)
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

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd 

DynaForm form = (DynaForm)request.getAttribute("form");

String st_bia_evl_sc = (String) form.get("st_bia_evl_sc");
if(st_bia_evl_sc==null) st_bia_evl_sc = "";

String hd_bsn_prss_c = (String) form.get("hd_bsn_prss_c");
if(hd_bsn_prss_c==null) hd_bsn_prss_c = "";

String number = (String) form.get("number");
if(number==null) number = "";

String chrg_brc = (String) form.get("chrg_brc");
if(chrg_brc==null) chrg_brc = "";

String prd_brc = (String) form.get("prd_brc");
if(prd_brc==null) prd_brc = "";

%>  
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			$("#winPrssEvl",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
  				{Header:"업무프로세스코드",		Type:"Text",	SaveName:"bsn_prss_c",			Hidden:true},
 				{Header:"업무프로세스",			Type:"Text",	SaveName:"bsn_prsnm",			MinWidth:150},
 				{Header:"부서명",			Type:"Text",	SaveName:"brnm",				MinWidth:150},
 				{Header:"사무소코드",			Type:"Text",	SaveName:"brc",					Hidden:true},
 				{Header:"업무프로세스코드1레벨",	Type:"Text",	SaveName:"bsn_prss_c_lv1",		Hidden:true},
 				{Header:"업무프로세스1레벨",		Type:"Text",	SaveName:"bsn_prsnm_lv1",		Hidden:true},
 				{Header:"업무프로세스코드2레벨",	Type:"Text",	SaveName:"bsn_prss_c_lv2",		Hidden:true},
 				{Header:"업무프로세스2레벨",		Type:"Text",	SaveName:"bsn_prsnm_lv2",		Hidden:true},
 				{Header:"업무프로세스코드3레벨",	Type:"Text",	SaveName:"bsn_prss_c_lv3",		Hidden:true},
 				{Header:"업무프로세스3레벨",		Type:"Text",	SaveName:"bsn_prsnm_lv3",		Hidden:true}
 			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			
			//필터표시
			mySheet.ShowFilterRow();  
			
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

			if(Row >= mySheet.GetDataFirstRow()){
				doAction("select");
			}
		}
		
		function mySheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

			if(NewRow >= mySheet.GetDataFirstRow()){
				$("#level").val(mySheet.GetCellValue(NewRow, "level"));
				$("#bsn_prss_c").val(mySheet.GetCellValue(NewRow, "bsn_prss_c"));
				$("#bsn_prsnm").val(mySheet.GetCellValue(NewRow, "bsn_prsnm"));
				$("#bsn_prss_c_lv1").val(mySheet.GetCellValue(NewRow, "bsn_prss_c_lv1"));
				$("#bsn_prsnm_lv1").val(mySheet.GetCellValue(NewRow, "bsn_prsnm_lv1"));
				$("#bsn_prss_c_lv2").val(mySheet.GetCellValue(NewRow, "bsn_prss_c_lv2"));
				$("#bsn_prsnm_lv2").val(mySheet.GetCellValue(NewRow, "bsn_prsnm_lv2"));
				$("#bsn_prss_c_lv3").val(mySheet.GetCellValue(NewRow, "bsn_prss_c_lv3"));
				$("#bsn_prsnm_lv3").val(mySheet.GetCellValue(NewRow, "bsn_prsnm_lv3"));
				$("#brc").val(mySheet.GetCellValue(NewRow, "brc"));
				
			}
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction("loadexcel");
			}
		}
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					$("#bsn_prsnm").val("");
					$("#bsn_prss_c").val("");
					
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("bcp");
					$("form[name=ormsForm] [name=process_id]").val("ORBC011202");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "select": 
					var parentRow = parent.mySheet.GetSelectRow();
					var com =  true;
					var bsn_prss_c = $("#bsn_prss_c").val();
					var hd_bsn_prss_c = $("#hd_bsn_prss_c").val();
					var chrg_brc = $("#chrg_brc").val();
					var brc = $("#brc").val();
					var number = $("#number").val();
					var row = mySheet.GetSelectRow();
					if($("#bsn_prss_c").val() == ""){
						alert("업무프로세스를 선택해 주십시오.");
						com = false;
						return;
					}
 					if(bsn_prss_c==hd_bsn_prss_c && brc==chrg_brc){
						alert("같은 평가대상을 선택 할 수 없습니다.");
						com = false;
						return;
						
					}
					//선,후행으로 선택되어있는지 확인
					for(var i=parent.mySheet.GetDataFirstRow(); i<=parent.mySheet.GetDataLastRow(); i++){
						if(number=="1"){
							//기존에 있던 선행 업무 삭제
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_lv1", "");
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_lv2", "");
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_lv3", "");
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_c", "");
								parent.mySheet.SetCellValue(parentRow, "prd_brc", "");
								
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm_lv1", "");
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm_lv2", "");
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm_lv3", "");
								parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm", "");
							//기존에 있던 후행 업무 삭제
							if(parent.mySheet.GetCellValue(i, "b_bsn_prss_c") == hd_bsn_prss_c && brc==chrg_brc){
								parent.mySheet.SetCellValue(i, "b_bsn_prss_lv1", "");
								parent.mySheet.SetCellValue(i, "b_bsn_prss_lv2", "");
								parent.mySheet.SetCellValue(i, "b_bsn_prss_lv3", "");
								parent.mySheet.SetCellValue(i, "b_bsn_prss_c", "");
								
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm_lv1", "");
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm_lv2", "");
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm_lv3", "");
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm", "");
								
							}
						}
						
					}					
					
					
					if(com){
						//선행업무 팝업시
						if(number=="1"){
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_c", $("#bsn_prss_c").val());
							parent.mySheet.SetCellValue(parentRow, "prd_brc", $("#brc").val());
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm", $("#bsn_prsnm").val());
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_lv1", $("#bsn_prss_lv1").val());
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm_lv1", $("#bsn_prsnm_lv1").val());
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_lv2", $("#bsn_prss_lv2").val());
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm_lv2", $("#bsn_prsnm_lv2").val());
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prss_lv3", $("#bsn_prss_lv3").val());
							parent.mySheet.SetCellValue(parentRow, "f_bsn_prsnm_lv3", $("#bsn_prsnm_lv3").val());
							
						}
						closePop();
					}
					
					
					break;
					
				case "init": //초기화
					var row = parent.mySheet.GetSelectRow();
					var number = $("#number").val();
					var hd_bsn_prss_c = $("#hd_bsn_prss_c").val();
					var prd_brc = $("#prd_brc").val();
					
					$("#bsn_prss_c").val("");
					$("#bsn_prsnm").val("");
					$("#bsn_prss_c_lv1").val("");
					$("#bsn_prsnm_lv1").val("");
					$("#bsn_prss_c_lv2").val("");
					$("#bsn_prsnm_lv2").val("");
					$("#bsn_prss_c_lv3").val("");
					$("#bsn_prsnm_lv3").val("");
					$("#brc").val("");
					
					//선행업무 팝업시
					if(number=="1"){
						parent.mySheet.SetCellValue(row, "f_bsn_prss_c", $("#bsn_prss_c").val());
						parent.mySheet.SetCellValue(row, "prd_brc", $("#brc").val());
						parent.mySheet.SetCellValue(row, "f_bsn_prsnm", $("#bsn_prsnm").val());
						parent.mySheet.SetCellValue(row, "f_bsn_prss_lv1", $("#bsn_prss_c_lv1").val());
						parent.mySheet.SetCellValue(row, "f_bsn_prsnm_lv1", $("#bsn_prsnm_lv1").val());
						parent.mySheet.SetCellValue(row, "f_bsn_prss_lv2", $("#bsn_prsnm_lv2").val());
						parent.mySheet.SetCellValue(row, "f_bsn_prsnm_lv2", $("#bsn_prsnm_lv2").val());
						parent.mySheet.SetCellValue(row, "f_bsn_prss_lv3", $("#bsn_prss_c_lv3").val());
						parent.mySheet.SetCellValue(row, "f_bsn_prsnm_lv3", $("#bsn_prsnm_lv3").val());
						
						for(var i=3; i<=parent.mySheet.GetDataLastRow(); i++){
							if(parent.mySheet.GetCellValue(i, "b_bsn_prss_c") == hd_bsn_prss_c && parent.mySheet.GetCellValue(i, "brc")==prd_brc){
								parent.mySheet.SetCellValue(i, "b_bsn_prss_c", $("#bsn_prss_c").val());
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm", $("#bsn_prsnm").val());
								parent.mySheet.SetCellValue(i, "b_bsn_prss_lv1", $("#bsn_prss_lv1").val());
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm_lv1", $("#bsn_prsnm_lv1").val());
								parent.mySheet.SetCellValue(i, "b_bsn_prss_lv2", $("#bsn_prss_lv2").val());
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm_lv2", $("#bsn_prsnm_lv2").val());
								parent.mySheet.SetCellValue(i, "b_bsn_prss_lv3", $("#bsn_prss_lv3").val());
								parent.mySheet.SetCellValue(i, "b_bsn_prsnm_lv3", $("#bsn_prsnm_lv3").val());
								
								break;
							}
						}
					}
					
					closePop();
					
					break;
			}
		}
		
		

		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
		}
		
		function mySheet_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert(msg);  // 저장 성공 메시지
		        doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}

		function goSavEnd(){
			closePop();
			doAction('search');
		}
		
	</script>

</head>
<body onkeyPress="return EnterkeyPass()">
	<form name="ormsForm" method="post">
		<input type="hidden" id="path" name="path" />
		<input type="hidden" id="process_id" name="process_id" />
		<input type="hidden" id="commkind" name="commkind" />
		<input type="hidden" id="method" name="method" />
		<input type="hidden" id="bsn_prsnm" name="bsn_prsnm" /> 
		<input type="hidden" id="bsn_prss_c" name="bsn_prss_c" />
		<input type="hidden" id="bsn_prsnm_lv1" name="bsn_prsnm_lv1" /> 
		<input type="hidden" id="bsn_prss_c_lv1" name="bsn_prss_c_lv1" />
		<input type="hidden" id="bsn_prsnm_lv2" name="bsn_prsnm_lv2" /> 
		<input type="hidden" id="bsn_prss_c_lv2" name="bsn_prss_c_lv2" />
		<input type="hidden" id="bsn_prsnm_lv3" name="bsn_prsnm_lv3" /> 
		<input type="hidden" id="bsn_prss_c_lv3" name="bsn_prss_c_lv3" />
		<input type="hidden" id="st_bia_evl_sc" name="st_bia_evl_sc" value="<%=st_bia_evl_sc %>" />
		<input type="hidden" id="hd_bsn_prss_c" name="hd_bsn_prss_c" value="<%=hd_bsn_prss_c %>" />
		<input type="hidden" id="number" name="number" value="<%=number %>" />
		<input type="hidden" id="brc" name="brc" />
		<input type="hidden" id="chrg_brc" name="chrg_brc" value="<%=chrg_brc %>" />
		<input type="hidden" id="prd_brc" name="prd_brc" value="<%=prd_brc %>" />
		
	<div id="" class="popup modal block">
		<div class="p_frame w500">
			<div class="p_head">
				<h3 class="title">업무프로세스 선택</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-grid">
						<div class="wrap-grid h450">
							<script> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-normal btn-close" onclick="javascript:doAction('init');">초기화</button>
					<button type="button" class="btn btn-primary" onclick="javascript:doAction('select');">선택</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<!-- popup //-->
	</form>	
	
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				$("#winPrssEvl",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winPrssEvl",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#bsn_prss_c").val("");
			$("#bsn_prsnm").val("");
			closePop();
		});
	</script>	
</body>
</html>
