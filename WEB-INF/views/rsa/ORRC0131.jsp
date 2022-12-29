<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0131.jsp
 Program name : 디지털/비대면 리스크 보고서
 Description  : 화면정의서 RCSA-20.1
 Programer    : 박승윤
 Date created : 2022.08.17
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/library.jsp" %>

<%
%>
<!DOCTYPE html>
<html lang="ko-kr">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RCSA - 디지털/비대면리스크 보고서</title>
	<script src="<%=System.getProperty("contextpath")%>/ibupload/bin/js/ibuploadinfo.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/ibupload/bin/js/ibupload.js"></script>	
	<script>
	$(document).ready(function(){
			parent.removeLoadingWs();
			// ibupload
			$("#myUpload").IBUpload(initUploadConfig);
			ibUploadData();

			// 파일추가
			$("#addItem").click(function() {
				$("#myUpload").IBUpload("add", {
					callback: function() {
						alert('add 메소드 직후 콜백함수 호출입니다.');
					}
				});
			});

			// 삭제
			$("#deleteItem").click(function() {
				$("#myUpload").IBUpload("delete");
			});

			// 업로드
			$("#uploadItem").click(function() {
				 var files = $('#myUpload').IBUpload('addFiles');
				 if (files == "[]") {
				 	alert("업로드할 파일이 없습니다.");
				 	return;
				 }
			//	alert("제품에 대한 단순 예제이기에 서버가 구축되어 있지 않으므로 업로드가 진행되지 않습니다.");
				$("#myUpload").IBUpload("upload");
			});

			// 다운로드
			$("#downloadItem").click(function() {
				var fileList = $('#myUpload').IBUpload('fileList');
				for (i = fileList.length - 1; i >= 0; i--) {
					if ($('#myUpload').IBUpload('selectedIndex', {
							index: i
						}) == true && gallery.event_add.data.filter(function(e) {
							return e.name == fileList[i].name && e.url == fileList[i].url;
						}).length > 0) {
						alert("업로드의 기본 파일들은 단순 예제로 다운로드 되지 않습니다. '파일 추가'로 추가된 파일만 업로드/다운로드 가능합니다.");
						return;
					}
				}
				$("#myUpload").IBUpload("download");
			});
		});
		
		// ibupload
		// ajax 사용시 success에서 $("#myUpload").IBUpload(this.data); 를 사용(this.data는 Object로 불러오면 된다)
		function ibUploadData(){
			// 파일조회
			$.ajax({
				url: "./publish_Sh/_guide/ibupload_data.json",
				dataType: "json",
				success: function(data) {
					$("#myUpload").IBUpload("files", data);
				}
			});
		}

		$.ajax({
			url: './demo/js/upload/ibupload_data.json',
			dataType: "json",
			success: function(data) {
				gallery.event_add.data = data;
				$("#myUpload").IBUpload("files", data);
			}
		});
		
		
		function dosave() {
			var f = document.ormsForm;
			
			if(f.rpt_tinm.value ==''){
				alert("제목을 입력해 주세요");
				return;
			}
			
			if(f.rpt_cntn.value ==''){
				alert("내용을 입력해 주세요");
				return;
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC013103");

			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

						
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							parent.doAction('search');
							alert("저장 하였습니다.");
							$(".btn-close").trigger("click");
							$(".popup",parent.document).removeClass("block");

						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						//parent.goSavEnd();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
	}
	</script>
</head>
<body>
	
	<!-- popup -->
	<article class="popup modal block">
		<div class="p_frame w1000">	
			<div class="p_head">
				<h1 class="title">디지털/비대면리스크 보고서</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
					<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					<section class="box box-grid">
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 100px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th>보고서 구분</th>
										<td>
											<select name="sch_rpt_dsc" id="sch_rpt_dsc" class="form-control w150">
												<option value="1">디지털리스크</option>
												<option value="2">비대면리스크</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>보고서 제목<em class="needs"></em></th>
										<td>
											<input type="text" name="rpt_tinm" id="rpt_tinm" class="form-control" placeholder="보고서 제목을 입력하세요. (예: 2022년 1회차 비대면리스크 Checklist 점검결과)">
										</td>
									</tr>
									<tr>
										<th>보고서 내용<em class="needs"></em></th>
										<td>
											<textarea name="rpt_cntn" id="rpt_cntn" class="form-control" placeholder="보고서 내용을 입력하세요. (예: 본건 당행 신규 비대면서비스 런칭에 따른 운영리스크 점검결과임)"></textarea>
										</td>
									</tr>
									<tr>
										<th>첨부파일</th>
										<td>										
											<button type="button" id="addItem" class="btn btn-default btn-sm ico"><i class="fa fa-plus"></i><span class="blind">파일 추가</span></button>
											<button type="button" id="btnSheetDelete" class="btn btn-default btn-sm ico"><i class="fa fa-minus"></i><span class="blind">파일 삭제</span></button>
											<button type="button" id="downloadItem" class="btn btn-primary btn-sm ico"><i class="fa fa-download"></i><span class="blind">다운로드</span></button>
											<div class="ibupload-wrap">
												<div id="myUpload"></div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					
					</section>
				  </form>
				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="dosave();">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->


 	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});
	</script>

</body>
</html>