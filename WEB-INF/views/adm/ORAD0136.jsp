<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0136.jsp
 Program name : ADMIN > 코드관리 > 휴일관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.07.06
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	String auth_ids = hs.get("auth_ids").toString();
	String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");  
	
	String aadm_yn = "N";
	for(int k=0;k<auth_grp_id.length;k++){
		if("001".equals(auth_grp_id[k]) || "002".equals(auth_grp_id[k])){
			aadm_yn = "Y";
		}
	}
	
	SysDateDao dao = new SysDateDao(request);
	String today = dao.getSysdate(); //오늘날짜(yyyymmdd)
	String ed_dt = today.substring(0,4)+"-"+today.substring(4,6)+"-"+today.substring(6,8);
%>
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
			mySheet.Reset();
			
			var initData1 = {};
			
			initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",MenuFilter:0 }; //좌측에 고정 컬럼의 수
			initData1.Cols = [
				{Header:"일자",			Type:"Text",	SaveName:"hldy_dt",				Hidden:false,	Width:300,	Align:"Center",	Format:"yyyy-MM-dd"	},
			    {Header:"휴일구분",		Type:"Text",	SaveName:"oprk_dow_dsnm",		Hidden:false,	Width:400,	Align:"Center"						},
			    {Header:"휴일구분코드",		Type:"Text",	SaveName:"oprk_dow_dsc",		Hidden:false,	Width:100,	Align:"Center"						}
 			];
			
			IBS_InitSheet(mySheet,initData1);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			mySheet.SetEditable(0); //수정불가
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//최초 조회시 포커스를 감춘다.
			mySheet.SetFocusAfterProcess(0);
			
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});

			doAction('search');
			
		}
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";

		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD013602");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
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
		        //alert("완료.");  // 저장 성공 메시지
		        doAction("search");      
		    } else {
		        alert("처리 중 오류가 발행했습니다."); // 저장 실패 메시지
		    }
		}
		
		function mySheet_OnRowSearchEnd (Row) {
			if(mySheet.GetCellValue(Row,"oprk_dow_dsc") == "1"){
				mySheet.SetRowFontColor(Row,"#FF0000");
			}else if(mySheet.GetCellValue(Row,"oprk_dow_dsc") == "2"){
				mySheet.SetRowFontColor(Row,"#2699FB");
			}
		}
		
		function fileDown(){
			
			/*
			var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "휴일.xlsx",  SheetName : "Sheet1", DownTreeHide:"True", DownCols:"0|2"} ;

			mySheet.Down2Excel(params);
			*/
			var f = document.tempform;
			f.action = "<%=System.getProperty("contextpath")%>/Jsp.do";
			f.target = "ifrHid";
			f.submit();
		}
		
		function uploadFile(){
			
			document.ormsForm.apply_dt_txt.value = document.ormsForm.apply_dt.value.replace(/-/gi,"");
			
			mySheet.LoadExcel({FileExt:"xlsx",ColumnMapping:'1||2'});

		}
		
		function mySheet_OnLoadExcel(result, code, msg) {
			
			//mySheet.RemoveAll();
			
			var f = document.ormsForm;
			
			var grid_html = "";
			if(mySheet.GetDataFirstRow()>=0){
				for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
					if(($("#apply_dt_txt").val() <= mySheet.GetCellValue(j,"hldy_dt")) && (mySheet.GetCellValue(j,"hldy_dt") != "")){
						grid_html += "<input type='hidden' name='hldy_dt' value='" + mySheet.GetCellValue(j,"hldy_dt") + "'>";
						grid_html += "<input type='hidden' name='oprk_dow_dsc' value='" + mySheet.GetCellValue(j,"oprk_dow_dsc") + "'>";
					}
				}
			}
			grid_area.innerHTML = grid_html;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "adm");
			WP.setParameter("process_id", "ORAD013603");
			WP.setForm(f);
			
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			{
				success: function(result){
					if(result!='undefined' && result.rtnCode=="S") {
						doAction('search');
					}else if(result!='undefined'){
						alert("처리중 오류가 발생했습니다.");
					}  
				},
			  
				complete: function(statusText,status){
					removeLoadingWs();
				},
			  
				error: function(rtnMsg){
					alert(JSON.stringify(rtnMsg));
				}
			});
			
		}
		
	</script>
	</head>
	<body onkeyPress="return EnterkeyPass()">
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
	
			<!-- content -->
			<div class="content">
				<form name="tempform" method="post">
			    	<input type="hidden" id="path" name="path" value="/comm/excelfile"/>
			   		<input type="hidden" id="filename" name="filename" value="holiday"/>
				</form>
				<form name="ormsForm" method="post">
	            <input type="hidden" id="path" name="path" />
	            <input type="hidden" id="process_id" name="process_id" />
	            <input type="hidden" id="commkind" name="commkind" />
	            <input type="hidden" id="method" name="method" />
	            <input type="hidden" id="apply_dt_txt" name="apply_dt_txt" />
	            <div id="grid_area"></div>
	
				<div class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="form-inline">
								<span class="cr mr10">※ 암호화 해제된 파일을 올려주시기 바랍니다.</span>
								<strong class="txt txt-sm">반영기준일</strong>
								<div class="input-group">
									<input type="text" class="form-control w100" name="apply_dt" id="apply_dt" readonly value="<%=ed_dt%>">
									<span class="input-group-btn">
										<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','apply_dt');"><i class="fa fa-calendar"></i></button>
									</span>
								</div>
								<button type="button" class="btn btn-xs btn-default" onclick="uploadFile()"><i class="ico xls"></i><span class="txt">엑셀 업로드</span></button>
								<button type="button" class="btn btn-xs btn-default" onclick="javascript:fileDown();"><i class="fa fa-download"></i>템플릿 다운로드</button>
							</div>
						</div>
					</div>
					<div class="box-body">
						<div class="wrap-grid h450">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
				</div>
				</form>
			</div>
			<!-- content //-->
		</div>
	</body>
	<iframe name="ifrHid" id="ifrHid" src="about:blank" width="0" height="0" scrolling="no" frameborder="0" style="visibility:hidden;display:none"></iframe>
</html>