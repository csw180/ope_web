<%--
/*---------------------------------------------------------------------------
 Program ID   : fileUpload.jsp
 Program name : File Upload
 Description  : 
 Programer    : 이상봉
 Date created : 2021.08.11
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, com.shbank.orms.comm.util.*, java.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../comm/library.jsp" %>
<script>

	function upload() {
		var f = document.uploadform;
		WP.clearParameters();
		
		var url = "<%=System.getProperty("contextpath")%>/fileup.do";
        var inputData = new FormData(f);
		
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.formdataload(url, inputData,{
			success: function(result){
				if(result!='undefined' && result.rtnCode=="0"){
					alert("파일 전송에 성공 하였습니다.\n파일이름:"+result.file_nm+"\n"+"일시"+result.get_date);
					down_load(result.file_nm,result.sv_file_full_path);
				} else if(result!='undefined' && result.rtnCode!="0"){
					alert(result.rtnMsg);
				}
			},
			  
			complete: function(statusText,status) {
				removeLoadingWs();
			},
			  
			error: function(rtnMsg){
				alert(JSON.stringify(rtnMsg));
			}
		});
	}
	
	function down_load(sfile,sv_file_full_path){
		var f = document.nanform;
		f.file_nm.value = sfile;
		f.sv_file_full_path.value = sv_file_full_path;

		f.action="<%=System.getProperty("contextpath")%>/Jsp.do?path=/comm/downUploadFile";
		f.target="ifrHid";
		f.submit();
	}
</script>
	
</head>
	<body>
		<div class="container">
			<!-- page-header -->
			<%@ include file="../comm/header.jsp" %>
			<!--.page header //-->
			<!-- content -->
			<div class="content">
			<form name="uploadform" method="post" enctype="multipart/form-data">
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>파일업로드</th>
										<td>
											<div class="select w100">
												<input type="file" id="fileList1" name="fileList1" style="font-size:12px; width:600px; height:25px;" />
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<div  style="font-size:12px; width:100%;color:red;" >
												<span>파일확장자를 xlsx로 변경후 업로드해 주세요.</span>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="javascript:upload();">변환</button>
					</div>
				</div>
			</form>
			<form name="nanform" method="post">
				<input type="hidden" name="file_nm" id="file_nm" value="" />
				<input type="hidden" name="sv_file_full_path" id="sv_file_full_path" value="" />
			</form>	
			</div>
		</div>
		
		<iframe name="ifrHid" frameborder="0" width="0" height="0" scrolling="no"></iframe>
	</body>
</html>
