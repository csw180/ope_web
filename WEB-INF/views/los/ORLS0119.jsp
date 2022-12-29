<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0119.jsp
 Program name : 측정대상손실사건조회(팝업)
 Description  : 
 Programer    : 한성준
 Date created : 2021.03.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
int min_year = 2013;
int max_year = 2021;
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			
		});
		
		function doAction(sAction) {
			switch(sAction) {
				case "select": 
					if($("#st_yy").val()==""||$("#ed_yy").val()==""){
						alert("년도를 선택하세요");
					}else{
						parent.losmsrSearchEnd(
							$("#st_dt").val(), $("#ed_dt").val()
						);
					}
					break;
			}	
		}
		
		function set_dt(){
			$("#st_dt").val($("#st_yy").val()+$("#st_md").val());
			$("#ed_dt").val($("#ed_yy").val()+$("#ed_md").val());
		}
	</script>

</head>
<body onkeyPress="return EnterkeyPass()";  style="background-color:transparent">
	<form name="ormsForm" method="post">
	<span id="check_list"></span>
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	
	<!-- popup -->
	<div id="" class="popup modal block" >
		<div class="p_frame w600">
			<div class="p_head">
				<h3 class="title md">측정대상손실사건조회</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box-body h50">
						<div class="wrap-grid">
								<table style="margin-top:25px">
									<colgroup>
										<col width="100" />
										<col width="30" />
										<col width="80" />
										<col width="30" />
										<col width="10" />
										<col width="100" />
										<col width="30" />
										<col width="80" />
										<col width="30" />
										<col />
									</colgroup>
									<tr>
										<td colspan="5" class="form-inline">
											<input type="text" id="st_dt" name="st_dt" class="form-control w70p fl" style="display:none"/>
										</td>
										<td colspan="4" class=" form-inline">
											<input type="text" id="ed_dt" name="ed_dt" class="form-control w70p fl" style="display:none"/>
										</td>
									</tr>
									<tr>
										<td>		
											<select class="form-control w100p" id="st_yy" name="st_yy" onchange="set_dt()">
												<option value="">선택</option>
<%
for(int i=min_year;i<max_year+1;i++){
%>
												<option value="<%=i %>"><%=i %></option>
<%		
}
%>
											</select>
										</td>
										<td>	
											<span class="input-group-addon ib mr10">년</span>
										</td>
										<td>	
											<select class="form-control w100p" id="st_md" name="st_md" onchange="set_dt()">
												<option value="-01-01">전체</option>
												<option value="-01-01">1</option>
												<option value="-04-01">2</option>
												<option value="-07-01">3</option>
												<option value="-09-01">4</option>
											</select>
										</td>
										<td>	
											<span class="input-group-addon ib mr10">분기</span>
										</td>
										<td>
											<span class="input-group-addon ib mr10"> ~ </span>
										</td>
										<td>	
											<select class="form-control w100p" id="ed_yy" name="ed_yy" onchange="set_dt()">
												<option value="">선택</option>
<%
for(int i=min_year;i<max_year+1;i++){
%>
												<option value="<%=i %>"><%=i %></option>
<%		
}
%>
											</select>
										</td>
										<td>	
											<span class="input-group-addon ib mr10">년</span>
										</td>
										<td>
											<select class="form-control w100p" id="ed_md" name="ed_md" onchange="set_dt()">
												<option value="-12-31">전체</option>
												<option value="-03-31">1</option>
												<option value="-06-30">2</option>
												<option value="-09-30">3</option>
												<option value="-12-31">4</option>
											</select>
										</td>
										<td>	
											<span class="input-group-addon ib mr10">분기</span>
										</td>
									</tr>
								</table>	
						</div><!-- .wrap-grid //-->
					</div>
					<!-- /.box-body -->
				</div><!-- p_wrap //-->
			</div>
			<div class="p_foot">
				<div class="btn-wrap center">
							<button type="button" class="btn btn-primary" onclick="javascript:doAction('select');">선택</button>
							<button type="button" class="btn btn-default btn-pclose">취소</button>
				</div>
			</div>
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<!-- popup //-->
	</form>	
	
	<script>
		
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				$("#winLosmsr",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winLosmsr",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#st_dt").val("");
			$("#txt_st_dt").val("");
			$("#ed_dt").val("");
			$("#txt_ed_dt").val("");
			
			closePop();
		});
		
		
	</script>	
</body>
</html>
