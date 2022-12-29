<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0115.jsp
 Program name : 변경사유
 Description  : 
 Programer    : 양진모
 Date created : 2020.08.26
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>변경사유</title>
	<script>
	$(document).ready(function(){
		parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
		
		
	});
	
	function save(){
		var f = document.ormsForm;
		
		if(f.chg_cntn.value.trim()==''){
			alert("변경사유를 입력하십시오.");
			f.chg_cntn.focus();
			return;
		}
		
		if(!confirm("저장하시겠습니까?")) return;
		
		parent.$("#chg_cntn").val($("#chg_cntn").val());
		
		parent.endORKR3101();
	}
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<!-- 팝업 -->
	<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />	
	<div id="" class="popup modal block">
			<div class="p_frame w1000">
				<div class="p_head">
					<h3 class="title">변경사유</h3>
				</div>
				<div class="p_body">
					<div class="p_wrap">
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width:100px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>변경사유</th>
										<td>
											<textarea cols="100" rows="3" class="textarea" id="chg_cntn" name="chg_cntn"></textarea>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .p_wrap //-->	
				</div><!-- .p_body //-->
				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="javascript:save();">저장</button>
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>
				<button type="button" class="ico close  fix btn-close"><span class="blind">닫기</span></button>
			</div>
		<div class="dim p_close"></div>
	</div>
	</form>
	<!-- popup //-->
	
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				event.preventDefault();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				//$(".popup").hide();
			});
		});
			
		function closePop(){
			$("#winORKR3101",parent.document).hide();
		}
	</script>
</body>
</html>