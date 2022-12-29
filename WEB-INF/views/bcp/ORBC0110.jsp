<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0110.jsp
 Program name : 취약점 입력
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

ServletContext sctx = request.getSession(true).getServletContext();
String istest = sctx.getInitParameter("isTest");
String servergubun = sctx.getInitParameter("servergubun");
DynaForm form = (DynaForm)request.getAttribute("form");

String rsk_c = (String) form.get("hd_rsk_c");
if(rsk_c==null) rsk_c = "";
String ra_sc = (String) form.get("st_ra_sc");
if(ra_sc==null) ra_sc = "";

String rsk_mtg_act_cntn = (String) form.get("hd_rsk_mtg_act_cntn");
if("2".equals(servergubun)){
	rsk_mtg_act_cntn = new String(rsk_mtg_act_cntn.getBytes("ISO8859_1"), "UTF-8");
}

String chk_ra_dcz_stsc = (String) form.get("chk_ra_dcz_stsc");
if(ra_sc==null) chk_ra_dcz_stsc = "";

if(rsk_mtg_act_cntn.equals("입력")) rsk_mtg_act_cntn = "";

%>   
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs();
		});
		
		function insert(){
			var row = parent.mySheet2.GetSelectRow();
			
			parent.mySheet2.SetCellValue(row, "rsk_mtg_act_cntn", $("#rsk_mtg_act_cntn").val());
			
			save();
		}
		
		function save(){
			var f = document.ormsForm;
			
			if(!confirm("저장하시겠습니까?")) return;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC011002");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("저장되었습니다.");
							parent.doAction('search2');
							removeLoadingWs();
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						
						closePop()
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});	
			
		}		
		
		
		
		
	</script>
</head>
<body>
	<form name="ormsForm">
		<input type="hidden" id="path" name="path" />
		<input type="hidden" id="process_id" name="process_id" />
		<input type="hidden" id="commkind" name="commkind" />
		<input type="hidden" id="method" name="method" />
		<input type="hidden" id="today" name="today" value="<%=dt %>" />
		<input type="hidden" id="hd_ra_sc" name="hd_ra_sc" value="<%=ra_sc %>" />
		<input type="hidden" id="hd_rsk_c" name="hd_rsk_c" value="<%=rsk_c %>" />		

		<input type="hidden" id="chk_ra_dcz_stsc" name="chk_ra_dcz_stsc" value="<%=chk_ra_dcz_stsc %>" />

	<div id="" class="popup modal block">
			<div class="p_frame w800">

				<div class="p_head">
					<h3 class="title">위험경감조치 입력</h3>
				</div>


				<div class="p_body">
					
					<div class="p_wrap">

						<div class="box box-grid">						
							<div class="box-body">
								<div class="wrap-table">
									<table>
										<colgroup>
											<col style="width: 150px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th>취약점</th>
												<td>
													<textarea name="rsk_mtg_act_cntn" id="rsk_mtg_act_cntn" class="textarea h200"><%=rsk_mtg_act_cntn %></textarea>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>

					</div>
					
				</div>


				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="javascript:insert();">저장</button>
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>

				<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>

			</div>
		<div class="dim p_close"></div>
	</div>
	</form>
	
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
		});
		function closePop(){
			$("#winRskMtg",parent.document).hide();
		}
	</script>
</body>
</html>