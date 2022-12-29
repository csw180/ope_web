<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0138.jsp
 Program name : ADMIN > 사용자/권한관리 > 권한변경
 Description  : 
 Programer    : 권성학
 Date created : 2021.07.09
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
			initIBSheet1();
		});
		
		/*Sheet1 기본 설정 */
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly, HeaderCheck:0, ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
 				{Header:"부서명",				Type:"Text",		SaveName:"brnm",		Width:200,	Align:"Center",	Edit:0},
 				{Header:"개인번호",			Type:"Text",		SaveName:"eno",			Width:130,	Align:"Center",	Edit:0},
 				{Header:"직책",				Type:"Text",		SaveName:"oft",			Width:130,	Align:"Center",	Edit:0},
 				{Header:"직원명",				Type:"Text",		SaveName:"empnm",		Width:150,	Align:"Center",	Edit:0},
 				{Header:"ORM업무담당자",		Type:"CheckBox",	SaveName:"auth_003",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"BCP업무담당자",		Type:"CheckBox",	SaveName:"auth_014",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"부서장",				Type:"CheckBox",	SaveName:"auth_006",	Width:90,	Align:"Center",	Edit:1},
 				{Header:"부서코드",			Type:"Text",		SaveName:"brc",			Hidden:true}
 			];
			IBS_InitSheet(mySheet1,initData);
			
			//mySheet1.SetEditable(0); //수정불가
			mySheet1.SetFocusAfterProcess(0);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			mySheet1.SetHeaderMode({ColResize:1,ColMode:0,HeaderCheck:0,Sort:1});
			
			mySheet1.FitColWidth();
			
			doAction("search");
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //직원 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD013802");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
					
				case "save":      //저장할 데이터 추출
				
					var cnt_003 = 0;
					var cnt_006 = 0;
					var cnt_014 = 0;
					for(var i = mySheet1.GetDataFirstRow(); i<=mySheet1.GetDataLastRow(); i++){
						
						if(mySheet1.GetCellValue(i,"auth_003") == "1"){
							cnt_003 = cnt_003 + 1;
						}
						
						if(mySheet1.GetCellValue(i,"auth_006") == "1"){
							cnt_006 = cnt_006 + 1;
						}
						
						if(mySheet1.GetCellValue(i,"auth_014") == "1"){
							cnt_014 = cnt_014 + 1;
						}
					}
					
					if(cnt_003 < 1){
						alert("ORM업무담당자를 1명 지정해 주십시오.");
						return;
					}else if(cnt_003 > 1){
						alert("ORM업무담당자는 1명만 지정 가능합니다.");
						return;
					}
					
					if(cnt_014 < 1){
						alert("BCP업무담당자를 1명 지정해 주십시오.");
						return;
					}else if(cnt_014 > 1){
						alert("BCP업무담당자는 1명만 지정 가능합니다.");
						return;
					}
					
					if(cnt_006 < 1){
						alert("부서장을 1명 지정해 주십시오.");
						return;
					}else if(cnt_006 > 1){
						alert("부서장은 1명만 지정 가능합니다.");
						return;
					}
					
					if(!confirm("저장하시겠습니까?")) return;
				
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD013803");
					
					mySheet1.DoAllSave(url, FormQueryStringEnc(document.ormsForm));
					
					break;
					
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet1.FitColWidth();
		}
		
		function mySheet1_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		        doAction("search");      
		    	alert("저장되었습니다.");
		    } else {
		    }
		}

	</script>
</head>
<body class="" onkeyPress="return EnterkeyPass()">
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<!-- content -->
		<div class="content">
			<form name="ormsForm" method="post">
            <input type="hidden" id="path" name="path" />
            <input type="hidden" id="process_id" name="process_id" />
            <input type="hidden" id="commkind" name="commkind" />
            <input type="hidden" id="method" name="method" />
			<div class="box box-grid">
				<div class="box-body">					
					<div class="wrap-grid h550">
						<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
					</div>
				</div>
				<div class="box-footer">
					<div class="btn-wrap right">
						<button type="button" class="btn btn-primary" onclick="javascript:doAction('save')">
							<span class="txt">저장</span>
						</button>
					</div>
				</div>
			</div>

		</div>
		<!-- content //-->
	</div>
</body>
</html>