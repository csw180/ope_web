<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0139.jsp
 Program name : 패스워드변경
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
<script language="javascript">

	function changePassword(){
		var f = document.frm;
		
		
		if($("input[name=password]").val() == null || $("input[name=password]").val() == "" ){
			alert("패스워드를 입력하세요.");
			$("input[name=password]").focus();
			return;
		}
		
		if($("input[name=password]").val()!=$("input[name=repassword]").val()){
			alert("패스워드가 일치하지 않습니다.");
			$("input[name=password]").val("");
			$("input[name=repassword]").val("");
			$("input[name=password]").focus();
			
			return;
		}
	
		WP.clearParameters();
		WP.setForm(f); 
		var url = "<%=System.getProperty("contextpath")%>/changePassword.do";
		var inputData = WP.getParams();
		
		WP.load(url, inputData,{
			success: function(result){
				if(result!='undefined'){
					if(result.rtnCode=="0"){
						alert("저장되었습니다.");
					}else{
						alert(result.rtnMsg);
					}
				}else{
					alert("처리할 수 없습니다.");
				}
			},
			  
			complete: function(statusText,status) {
			},
			  
			error: function(rtnMsg) {
				alert(JSON.stringify(rtnMsg));
			}
		});
	
	}
	
</script>
	
</head>
	<body>
	<div class="container">
				<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>
			<form name="frm">
				<input type="hidden" id="path" name="path" />              
				<input type="hidden" id="process_id" name="process_id" />   
				<input type="hidden" id="commkind" name="commkind" />       
				<input type="hidden" id="method" name="method" />           
				<input type="hidden"  id="sch_jrdt_brc" name="sch_jrdt_brc" >
				<input type="hidden"  id="rki_id" name="rki_id" value="" >
				<input type="hidden"  id="hd_bsn_prss_c" name="hd_bsn_prss_c" value="" >
				
				<div id="tmp_area"></div>	
				<div id="rk_ctgr_c"></div>		
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th scope="row"><label for="input02" class="control-label">패스워드</label></th>
										<td>
											<input type="password" id="password" name="password" class="form-control w200 fl" placeholder="" value="" tabindex="1" />
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="input02" class="control-label">패스워드 확인</label></th>
										<td>
											<input type="password" id="repassword" name="repassword" class="form-control w200 fl" placeholder="" value=""  onKeyup="if(event.keyCode==13) changePassword();" tabindex="2"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div><!-- .wrap-search -->
					</div><!-- .box-body //-->
					<div class="box-footer">
							<button type="button" class="btn btn-primary search" onclick="javascript:changePassword();">저장</button>
					</div>
				</div><!-- .box-search //-->
				<!-- 조회 //-->
			</form>
	</body>
</html>
