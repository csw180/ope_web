<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0106.jsp
 Program name : 평가일정 조회/수정
 Description  : 화면정의서 RCSA-05.1
 Programer    : 
 Date created : 2020.06.09
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vRkEvlTpcLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");

DynaForm form = (DynaForm)request.getAttribute("form");
//String rk_evl_chg_rsn_txt = new String(form.get("link_rk_evl_chg_rsn").getBytes("ISO8859_1"), "UTF-8");
//String rk_evl_chg_rsn_txt = new String(form.get("link_rk_evl_chg_rsn").getBytes("ISO8859_1"), "euc-kr");
ServletContext sctx = request.getSession(true).getServletContext();
String istest = sctx.getInitParameter("isTest");
String servergubun = sctx.getInitParameter("servergubun");

String rk_evl_chg_rsn_txt = form.get("link_rk_evl_chg_rsn");
String bas_ym_nm = form.get("link_bas_ym_nm");

/* if("2".equals(servergubun)){
	rk_evl_chg_rsn_txt = new String(rk_evl_chg_rsn_txt.getBytes("ISO8859_1"), "UTF-8");
} */
//rk_evl_chg_rsn_txt = new String(rk_evl_chg_rsn_txt.getBytes("ISO8859_1"), "UTF-8");
//bas_ym_nm = new String(bas_ym_nm.getBytes("ISO8859_1"), "UTF-8");
String link_rk_evl_st_dt = form.get("link_rk_evl_st_dt");
String link_rk_evl_ed_dt = form.get("link_rk_evl_ed_dt");
String link_bas_ym = form.get("link_bas_ym");

if (link_rk_evl_st_dt != null && !"".equals(link_rk_evl_st_dt)) 
	link_rk_evl_st_dt = link_rk_evl_st_dt.substring(0,4)+"-"+link_rk_evl_st_dt.substring(4,6)+"-"+link_rk_evl_st_dt.substring(6,8);

if (link_rk_evl_ed_dt != null && !"".equals(link_rk_evl_ed_dt))
	link_rk_evl_ed_dt = link_rk_evl_ed_dt.substring(0,4)+"-"+link_rk_evl_ed_dt.substring(4,6)+"-"+link_rk_evl_ed_dt.substring(6,8);

%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			//$("#winRskMod",parent.document).show();
			// ibsheet 초기화
			parent.removeLoadingWs();
			
			if("<%=form.get("link_rk_evl_prg_stsc")%>"=="02")
			    {
			     $("#evl_st_btn").hide();
			    }
			else if("<%=form.get("link_rk_evl_prg_stsc")%>"=="03")
				{
				 $("#evl_st_btn").hide();
			     $("#evl_ed_btn").hide();
				}
			
		});
		
		//평가완료
		function evlsuc(){

			var f = document.ormsForm;
		
			if(f.bas_ym.value==''){
				alert("시행년도를 입력하십시오.");
				f.bas_ym.focus();
				return;
			}
			
			
			if(f.datePicker.value==''){
				alert("평가시작일을 입력하십시오.");
				f.datePicker.focus();
				return;
			}
			
			if(f.datePicker2.value==''){
				alert("평가종료일 입력하십시오.");
				f.datePicker2.focus();
				return;
			}
			
			if(f.datePicker.value >= f.datePicker2.value){
				alert("평가시작일을 평가종료일 이전으로 설정해주시기 바랍니다.");
				f.datePicker.focus();
				return;
			}
			
			if(f.rk_evl_chg_rsn.value==''){
				alert("등록및변경사유를 입력하십시오.");
				f.rk_evl_chg_rsn.focus();
				return;
			}

			if(f.rk_evl_prg_stsc.value=='03'){
				alert("이미 평가완료된 일정입니다.");
				f.rk_evl_prg_stsc.focus();
				return;
			}
			
			if(!confirm("평가완료 하시겠습니까?")) return;
			f.datePicker.value = f.datePicker.value.replace(/-/g,"");
			f.datePicker2.value = f.datePicker2.value.replace(/-/g,"");
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORCO010604");
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
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						parent.goSavEnd();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
		
		
		//저장
		function save(){

			var f = document.ormsForm;
		
			if(f.bas_ym.value==''){
				alert("시행년도를 입력하십시오.");
				f.bas_ym.focus();
				return;
			}
			
			if(f.datePicker.value==''){
				alert("평가시작일을 입력하십시오.");
				f.datePicker.focus();
				return;
			}
			
			if(f.datePicker2.value==''){
				alert("평가종료일 입력하십시오.");
				f.datePicker2.focus();
				return;
			}
			
			if(f.datePicker.value >= f.datePicker2.value){
				alert("평가시작일을 평가종료일 이전으로 설정해주시기 바랍니다.");
				f.datePicker.focus();
				return;
			}
			
			if(f.rk_evl_chg_rsn.value==''){
				alert("등록및변경사유를 입력하십시오.");
				f.rk_evl_chg_rsn.focus();
				return;
			}
			
			
			if(f.rk_evl_prg_stsc.value=='03'){
				alert("평가완료된 건은 변경하실 수 없습니다.");
				f.rk_evl_prg_stsc.focus();
				return;
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			f.datePicker.value = f.datePicker.value.replace(/-/g,"");
			f.datePicker2.value = f.datePicker2.value.replace(/-/g,"");
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa");
			WP.setParameter("process_id", "ORRC010602");
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
							parent.$(".popup").removeClass("block");
							parent.doAction("search");
							
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
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
		
		//삭제
		function del(){

			var f = document.ormsForm;
			
			if(f.bas_ym.value==''){
				alert("회차를 입력하십시오.");
				f.bas_ym.focus();
				return;
			}
			
			if(f.rk_evl_prg_stsc.value=='02'){
				alert("평가진행중인 건은 삭제하실 수 없습니다.");
				f.rk_evl_prg_stsc.focus();
				return;
			}
			if(f.rk_evl_prg_stsc.value=='03'){
				alert("평가완료된 건은 삭제하실 수 없습니다.");
				f.rk_evl_prg_stsc.focus();
				return;
			}
			if(!confirm("삭제하시겠습니까?")) return;

			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "rsa1");
			WP.setParameter("process_id", "ORCO010606");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("삭제 되였습니다.");
						}else if(result!='undefined'){
							alert(result.rtnMsg);
						}else if(result!='undefined'){
							alert("처리할 수 없습니다.");
						}  
					},
				  
					complete: function(statusText,status){
						removeLoadingWs();
						parent.goSavEnd();
					},
				  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
			});
		}
	</script>

</head>
<body>
	<form name="ormsForm" method="post">
	<span id="check_list"></span>
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />

	<div id="brc_area">
	</div>
	<!-- popup -->
		<div id="" class="popup block">
		
			<div class="">
			<input type="hidden"   id="bas_ym" name="bas_ym" value=<%=form.get("link_bas_ym")%> />
			<input type="hidden"   id="rk_evl_prg_stsc" name="rk_evl_prg_stsc" value=<%=form.get("link_rk_evl_prg_stsc")%> />
				<div class="p_wrap">
					<div class="wrap-table">
						<table>
							<colgroup>
								<col style="width:110px" />
								<col  />
								<col style="width:110px" />
								<col  />
							</colgroup>
							<tbody>
								<tr>
									<th>시행년도</th>
									<td>

										<input type="text" class="form-control" id="bas_yy" name="bas_yy" value=<%=form.get("link_bas_yy")%> readonly />
									</td>
									<th>기준년월</th>
									<td><input type="text" class="form-control" id="bas_ym_nm" name="bas_ym_nm" value=<%=StringUtil.htmlEscape(bas_ym_nm,false,true)%> readonly /></td>
								</tr>
								<tr>
									<th>평가시작일</th>
									<td>
										<div class="input-group w130">
											<input type="text" id="datePicker" name="rk_evl_st_dt" class="form-control" value=<%=link_rk_evl_st_dt%> readonly>
											<span class="input-group-btn" id="evl_st_btn">
	                                       		<button class="btn btn-default ico" type="button" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','datePicker');"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
											</span>
										</div>
									</td>
									<th>평가종료일</th>
									<td>
										<div class="input-group w130">
											<input type="text" id="datePicker2" name="rk_evl_ed_dt" class="form-control" value=<%=link_rk_evl_ed_dt%> readonly>
											<span class="input-group-btn" id="evl_ed_btn">
												<button class="btn btn-default ico" type="button" id="calendarButton" onclick="showCalendar('yyyy-MM-dd','datePicker2');"><i class="fa fa-calendar"></i><span class="blind">날짜 입력</span></button>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th>등록 <br>및 변경 사유</th>
									<td colspan="3">
										<textarea class="form-control" id="rk_evl_chg_rsn" name="rk_evl_chg_rsn"><%=StringUtil.htmlEscape(rk_evl_chg_rsn_txt,false,false)%></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div><!-- .p_wrap //-->	
			</div><!-- .p_body //-->
		<!-- popup //-->
		</div>
	</form>		
	
</body>
</html>