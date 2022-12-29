<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0108.jsp
 Program name : 공통 > 부서 조회-멀티선택(팝업)
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	DynaForm form = (DynaForm)request.getAttribute("form");
	String[] brcs = form.gets("brcs");
	if(brcs==null){
		brcs = new String[0];
	}
	String[] bizo_tpcs = form.gets("bizo_tpcs");
	if(bizo_tpcs==null){
		bizo_tpcs = new String[0];
	}
	String org_rtn_func = form.get("org_rtn_func");
	org_rtn_func = StringUtil.htmlEscape(org_rtn_func);
	String org_mode = form.get("org_mode");
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		//var isSearch =false;
		$(document).ready(function(){
			$("#winBuseoM",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {MergeSheet:msHeaderOnly, DeferredVScroll:1,ChildPage:5};
			initData.Cols = [
 			 	{Header:"",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50 ,Edit:1},
 				{Header:"상위부서코드",	Type:"Text",	SaveName:"up_brc",		Hidden:true},
 				{Header:"부서코드",	Type:"Text",	SaveName:"brc",			Hidden:true},
 				{Header:"유형구분",	Type:"Text",	SaveName:"orgz_cfc",	Hidden:true},
 				{Header:"레벨",		Type:"Text",	SaveName:"level",		Hidden:true},
 				{Header:"부서명",		Type:"Text",	SaveName:"brnm",		TreeCol:1,	Width:389,	MinWidth:150 ,Edit:0}
 			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(1); //수정
			
			//필터표시
			mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(3);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			//isSearch =false;
			doAction('search');
			
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
					$("#sel_brc").val("");
					$("#sel_brnm").val("");
					
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					$("form[name=ormsForm] [name=process_id]").val("ORCO010802");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					
					//setExcelDownCols("1|2|3|4");
					mySheet.Down2Excel(excel_params);

					break;
				case "select": //부서 선택
					var brcs = new Array();
					var brnms = new Array();
					var bizo_tpcs = new Array();
					var bizo_tpc_nms = new Array();
					if(mySheet.GetDataFirstRow()>=0){
						for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
							if(mySheet.GetCellValue(j,"ischeck")){
								if(mySheet.GetCellValue(j,"orgz_cfc")=="99"){
									bizo_tpcs.push(mySheet.GetCellValue(j,"brc"));
									bizo_tpc_nms.push(mySheet.GetCellValue(j,"brnm"));
								}else{
									brcs.push(mySheet.GetCellValue(j,"brc"));
									brnms.push(mySheet.GetCellValue(j,"brnm"));
								}
							}
						}
					}
				
					var func = eval("parent.<%=org_rtn_func%>");
					
					func(brcs, brnms, bizo_tpcs, bizo_tpc_nms);
					
					break;
			}
		}

		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중 오류가 발생하였습니다..");
			}else{
				
			}
			setCheckProc();
			
			mySheet.FitColWidth();
			mySheet.ShowTreeLevel(-1,0);
		}
		
		var brc_arr = [
<%
for(int i=0;i<brcs.length;i++){
	System.out.println("i:"+i);
	if(i==0){
%>
						"<%=brcs[i]%>"
<%
	}else{
%>
						,"<%=brcs[i]%>"
<%
	}
}
%>		               
		               ];
		var bizo_tpc_arr = [
<%
for(int i=0;i<bizo_tpcs.length;i++){
	if(i==0){
%>
						"<%=bizo_tpcs[i]%>"
<%
	}else{
%>
						,"<%=bizo_tpcs[i]%>"
<%
	}
}
%>		               
		               ];
		
		function setCheckProc() {
			if(mySheet.GetDataFirstRow()>=0){
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					mySheet.SetCellValue(j,"ischeck",0);
					for(var k=0; k<=brc_arr.length; k++){
						if(mySheet.GetCellValue(j,"brc")==brc_arr[k]){
							mySheet.SetCellValue(j,"ischeck",1);
						}
					}
					for(var k=0; k<=bizo_tpc_arr.length; k++){
						if(mySheet.GetCellValue(j,"brc")==bizo_tpc_arr[k]){
							mySheet.SetCellValue(j,"ischeck",1);
						}
					}
				}
			}
		}
		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet.ShowTreeLevel(0,1);
			}
		}
	</script>

</head>
<body onkeyPress="return EnterkeyPass()">
	<form name="ormsForm" method="post">
	<span id="check_list"></span>
	<input type="hidden" id="sel_brc" name="sel_brc" /> <!-- 선택한 부서 코드 -->
	<input type="hidden" id="sel_brnm" name="sel_brnm" /> <!-- 선택한 부서명 -->
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="rtn_func" name="rtn_func" />
	<input type="hidden" id="search_txt" name="search_txt" value=""/>
	<input type="hidden" id="mode" name="mode" value="<%=org_mode%>"/>
	
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w500">
			<div class="p_head">
				<h1 class="title">부서 선택</h1>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<section class="box box-grid">
						<div class="box-header">
							<div class="area-tool">
								<div class="grid-tree-btn">
								    <button type="button" class="btn btn-xs" title="모두 펼치기" onClick="mySheet_showAllTree('1');"><i class="fa fa-plus-circle"></i></button>
									<button type="button" class="btn btn-xs" title="모두 접기" onClick="mySheet_showAllTree('2');"><i class="fa fa-minus-circle"></i></button>
								</div>
							</div>
						</div>
						<div class="wrap-grid h450">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap center">
					<button type="button" class="btn btn-primary" onclick="doAction('select');">선택</button>
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
	</form>	
	
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				//$("#winBuseoM",parent.document).hide();
				$("#winBuseoM",parent.document).hide();
				event.preventDefault();
			});
			/*
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				//$(".popup").hide();
			});
			*/
		});
			
		function closePop(){
			//$("#winBuseoM",parent.document).hide();
			$("#winBuseoM",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#sel_brc").val("");
			$("#sel_brnm").val("");
			closePop();
		});
		
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
				return true;
			}else{
				return true;
			}
		}
		
	</script>	
</body>
</html>
