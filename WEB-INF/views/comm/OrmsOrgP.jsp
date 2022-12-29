<%--
/*---------------------------------------------------------------------------
 Program ID   : OrmsOrgP.jsp
 Program name : 운영리스크 조직 팝업
 Description  : 
 Programer    : 
 Date created : 2020.03.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*, java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

HashMap hMapSession = (HashMap)request.getSession(true).getAttribute("infoH");

DynaForm form = (DynaForm)request.getAttribute("form");
String kbr_nm = (String)form.get("org_search_kbr_nm");

%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	
	<script language="javascript">
		
		/*Sheet 기본 설정 */
		function LoadPage() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": sizeNoHScroll, "MouseHoverMode": 0, "DragMode":1};
			initData.Cols = [
 				{Header:"신부점코드",		Type:"Text",	SaveName:"new_br_cd",		Hidden:true},
 				{Header:"상위신부점코드",	Type:"Text",	SaveName:"higrk_new_br_cd",	Hidden:true},
 				{Header:"부점명",			Type:"Text",	SaveName:"kbr_nm",			TreeCol:1,	Width:300,		MinWidth:150},
 				{Header:"부점코드",		Type:"Text",	SaveName:"org_cd",			Width:80,	Align:"Center",	MinWidth:60},
 				{Header:"본부영업점구분",	Type:"Text",	SaveName:"hq_br_dsnm",		Width:100,	Align:"Center",	MinWidth:40},
 				{Header:"부점종류",		Type:"Text",	SaveName:"hq_br_kdnm",		Width:100,	Align:"Center",	MinWidth:40},
 				{Header:"폐쇄여부",		Type:"Text",	SaveName:"shut_yn",			Hidden:true},
 				{Header:"개점일자",		Type:"Text",	SaveName:"br_opn_dt",		Width:80,	Format:"Ymd",	Align:"Center",	MinWidth:65},
 				{Header:"폐점일자",		Type:"Text",	SaveName:"shut_bsdt",		Width:80,	Format:"Ymd",	Align:"Center",	MinWidth:65}
 			];
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetEditable(0); //수정불가
			mySheet.SetSelectionMode(4); //행단위 선택
			
			//if($("#sel_new_br_cd").val() != "")
			//	doAction('search');
			
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=treeDeptComm";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search": //데이터 조회
					$("#sel_new_br_cd").val("");
					$("#sel_kbr_nm").val("");
					showLoadingWs();
					mySheet.DoSearch(url, "&search_txt=" + $("#search_txt").val());
					break;
				case "select": //조직 선택
					if($("#sel_new_br_cd").val() == ""){
						alert("조직을 선택해 주십시오.");
						return;
					}
				
					parent.buseoSearchEnd($("#sel_kbr_nm").val(), $("#sel_new_br_cd").val());
				
					//parent.$("#kbr_nm").val($("#sel_kbr_nm").val());
					//parent.$("#new_br_cd").val($("#sel_new_br_cd").val());
					//
					//parent.doAction("search");
					//
					//parent.closeBuseo();
					
					break;
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {
			removeLoadingWs();
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//$("#search_txt").focus(function(){
			//	$("#search_txt").attr("disabled",false);
			//});
			//$("#search_txt").trigger("click");
			//$("#search_txt").focus();
		}
		
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				$("#sel_new_br_cd").val(mySheet.GetCellValue(Row, "new_br_cd"));
				$("#sel_kbr_nm").val(mySheet.GetCellValue(Row, "kbr_nm"));
			}
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet.GetDataFirstRow()){
				parent.$("#kbr_nm").val(mySheet.GetCellValue(Row, "kbr_nm"));
				parent.$("#sch_new_br_cd").val(mySheet.GetCellValue(Row, "new_br_cd"));
				
				parent.buseoSearchEnd($("#sel_kbr_nm").val(), $("#sel_new_br_cd").val());
				
				//$("#sel_new_br_cd").val("");
				//$("#sel_kbr_nm").val("");
				
				//parent.doAction("search");
				
				//parent.closeBuseo();
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
<body onLoad="LoadPage()">
	<form name="ormsForm" method="post">
	<input type="hidden" id="sel_new_br_cd" name="sel_new_br_cd" /> <!-- 선틱한 조직 코드 -->
	<input type="hidden" id="sel_kbr_nm" name="sel_kbr_nm" /> <!-- 선택한 조직명 -->
	<!-- popup -->
	<div id="" class="popup block">
		<div class="p_wrap">
			<section class="box search-area case01">
				<div class="box-body">
					<div class="wrap-search">
						<table class="table">
							<colgroup>
								<col style="width:150px" />
								<col />
							</colgroup>
							<tr>
								<th scope="row"><label for="input01" class="control-label">부점명 또는 코드</label></th>
								<td>
									<input type="text" class="form-control w300" id="search_txt" name="search_txt" placeholder="부점코드 또는 부점명을 입력하세요" onkeypress="EnterkeySubmit();"/>
								</td>
							</tr>
							
							<!-- /.form-group -->
						</table>
					</div><!-- .wrap-search -->
				</div><!-- .box-body //--> 
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</section>
			<section class="mt20 ">
				<div class="wrap">
					<div class="box grid">
						<div class="box-header">
							<h3 class="box-title">검색결과</h3>
						</div>
						<!-- /.box-header -->
						<div class="box-body h250">
						<div>
							<table>
								<tr>
									<td>
									    <button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('1');"><i class="fa fa-plus"></i><span class="txt">모두 펼치기</span></button>
										<button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('2');"><i class="fa fa-minus"></i><span class="txt">모두 접기</span></button>
									</td>
								</tr>
							</table>
						</div>
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							<!-- .wrap //-->
						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->
					
				</div>
				<div class="btn-wrap center">
					<button type="button" class="btn btn-primary" onclick="javascript:doAction('select');">선택</button>
<!-- 					<button type="button" class="btn btn-primary btn-close">닫기</button> -->
					<button type="button" class="btn btn-default btn-close">취소</button>
				</div>
			</section>
			
		</div><!-- p_wrap //-->
	</div>
	<!-- popup //-->
				
	</form>			
	
	<script>
		$(document).ready(function(){
	
			//취소
			$(".btn-close").click( function(event){
				$("#sel_new_br_cd").val("");
				$("#sel_kbr_nm").val("");
				
				parent.closeBuseo();
				event.preventDefault();
			});
		
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