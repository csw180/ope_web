<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0121.jsp
 Program name : KRI > KRI 평가관리 > KRI 평가관리 > 평가일정관리 일정등록 팝업
 Description  : 
 Programer    : 남우현
 Date created : 2022.04.26
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	DynaForm form = (DynaForm)request.getAttribute("form");
	
	String addOrMod = (String) form.get("addOrMod");
	if(addOrMod==null) addOrMod = "";
	
	String p_bas_ym = (String) form.get("p_bas_ym");
	if(p_bas_ym==null) p_bas_ym = "";
	
	String p_mntr_st_dt = (String) form.get("p_mntr_st_dt");
	if(p_mntr_st_dt==null) p_mntr_st_dt = "";
	
	String p_mntr_ed_dt = (String) form.get("p_mntr_ed_dt");
	if(p_mntr_ed_dt==null) p_mntr_ed_dt = "";
	
	String hd_rki_prg_stsc = (String) form.get("hd_rki_prg_stsc");
	if(hd_rki_prg_stsc==null) hd_rki_prg_stsc = "";
	
	String p_rki_schd_nm = (String) form.get("p_rki_schd_nm");
	if(p_rki_schd_nm==null) p_rki_schd_nm = "";
	
	ServletContext sctx = request.getSession(true).getServletContext();
	String istest = sctx.getInitParameter("isTest");
	String servergubun = sctx.getInitParameter("servergubun");

	if("2".equals(servergubun)){
		p_rki_schd_nm = new String(p_rki_schd_nm.getBytes("ISO8859_1"), "UTF-8");
	}
	
	String efct_st_dt = "";
	String efct_ed_dt = "";
	
	Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList"); // 최대 bas_ym + 1
	if(vLst==null) vLst = new Vector();
	
	HashMap hMap = (HashMap)vLst.get(0);
	String max_bas_ym = (String)hMap.get("max_bas_ym");
	String mntr_dt = (String)hMap.get("mntr_dt");
	if("add".equals(addOrMod)){
		max_bas_ym = max_bas_ym.substring(0,4) + "-" + max_bas_ym.substring(4,6);
		efct_st_dt = mntr_dt + "-01";
		efct_ed_dt = mntr_dt + "-15";
		hd_rki_prg_stsc = "";
		p_rki_schd_nm = "";
	} else {
		max_bas_ym = p_bas_ym;
		efct_st_dt = p_mntr_st_dt.substring(0,4)+ "-" + p_mntr_st_dt.substring(4,6)+ "-" + p_mntr_st_dt.substring(6,8);
		efct_ed_dt = p_mntr_ed_dt.substring(0,4)+ "-" + p_mntr_ed_dt.substring(4,6)+ "-" + p_mntr_ed_dt.substring(6,8);
	}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>일정 등록</title>
	<script>
	$(document).ready(function(){
		parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
		
		initParam("<%=addOrMod %>");
		
	});
	
	function initParam(addOrMod) {
		var f = document.ormsForm;
		f.addOrMod.value = addOrMod;
		
		if(addOrMod == "mod"){
			f.bas_ym.value = "<%=max_bas_ym %>";
			f.efct_st_dt.value = "<%=efct_st_dt%>";
			f.efct_ed_dt.value = "<%=efct_ed_dt%>";
			f.rki_schd_nm.value = "<%=p_rki_schd_nm %>";
			f.hd_rki_prg_stsc.value = "<%=hd_rki_prg_stsc %>";
		}
	}
	
	function save(){
		var f = document.ormsForm;
		
		if(f.bas_ym.value == ""){
			alert("평가년월을 입력해 주십시오.");
			f.bas_ym.focus();
			return;
		}
		
		if(f.efct_st_dt.value == ""){
			alert("수행시작일을 입력해 주십시오.");
			f.efct_st_dt.focus();
			return;
		}
		
		if(f.efct_ed_dt.value == ""){
			alert("수행종료일을 입력해 주십시오.");
			f.efct_ed_dt.focus();
			return;
		}
		
		var stdt = f.efct_st_dt.value.replace(/-/gi,"");
		var eddt = f.efct_ed_dt.value.replace(/-/gi,"");
		
		if(stdt >= eddt){
			alert("수행시작일은 수행종료일 이후로 설정할 수 없습니다.");
			f.efct_st_dt.focus();
			return;
		}
		
		if(f.rki_schd_nm.value == ""){
			alert("KRI 평가 일정명을 입력해 주십시오.");
			f.rki_schd_nm.focus();
			return;
		}
		
		if(!confirm("저장하시겠습니까?")) return;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "kri");
		WP.setParameter("process_id", "ORKR010507");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		
		//alert(inputData);
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function(result){
					if(result!='undefined' && result.rtnCode=="S") {
						alert(result.rtnMsg);
						closePop();
						parent.doAction('search');
					}else if(result!='undefined' && result.rtnCode=="D"){
						alert(result.rtnMsg);
					}else if(result!='undefined'){
						alert(result.rtnMsg);
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
	
	function delSchedule(){
		var f = document.ormsForm;
		
		if(!confirm("삭제하시겠습니까?")) return;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "kri");
		WP.setParameter("process_id", "ORKR010508");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		
		//alert(inputData);
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
			{
				success: function(result){
					if(result!='undefined' && result.rtnCode=="S") {
						alert(result.rtnMsg);
					}else if(result!='undefined'){
						alert(result.rtnMsg);
					}  
				},
			  
				complete: function(statusText,status){
					removeLoadingWs();
					closePop();
					parent.doAction('search');
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
		<div class="p_frame w800">	
			<div class="p_head">			
				<h1 class="title">일정 등록</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
					<section class="box box-grid">
					<form name="ormsForm">
						<input type="hidden" id="addOrMod" name="addOrMod" />
						<input type="hidden" id="hd_rki_prg_stsc" name="hd_rki_prg_stsc" />
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 120px;">
									<col>
									<col style="width: 120px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th>평가년월</th>
										<td colspan="3" class="form-inline">
											<div class="input-group">
												<input type="text" name="bas_ym" id="bas_ym" class="form-control w100" readonly />
												<div class="input-group-btn">
													<%if(!"02".equals(hd_rki_prg_stsc) && !"03".equals(hd_rki_prg_stsc)){ %>
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM','bas_ym');">
														<i class="fa fa-calendar"></i>
													</button>
													<%} %>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>수행시작일</th>
										<td class="form-inline">
											<div class="input-group">
												<input type="text" id="efct_st_dt" name="efct_st_dt" class="form-control w100" readonly />
												<div class="input-group-btn">
													<%if(!"02".equals(hd_rki_prg_stsc) && !"03".equals(hd_rki_prg_stsc)){ %>
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','efct_st_dt');">
														<i class="fa fa-calendar"></i>
													</button>
													<%} %>
												</div>
											</div>
										</td>
										<th>수행종료일</th>
										<td class="form-inline">
											<div class="input-group">
												<input type="text" id="efct_ed_dt" name="efct_ed_dt" class="form-control w100" readonly />
												<div class="input-group-btn">
													<%if(!"03".equals(hd_rki_prg_stsc)){ %>
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','efct_ed_dt');">
														<i class="fa fa-calendar"></i>
													</button>
													<%} %>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>KRI 평가 일정명</th>
										<td colspan="3">
											<textarea name="rki_schd_nm" id="rki_schd_nm" class="form-control"></textarea>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						</form>
					</section>
				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<%if(!"03".equals(hd_rki_prg_stsc)){ %>
					<button type="button" class="btn btn-primary" onclick="save()">등록</button>
					<%} %>
					<%if("01".equals(hd_rki_prg_stsc)){ %>
					<button type="button" class="btn btn-primary" onclick="delSchedule()">삭제</button>
					<%} %>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
</body>

<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			$("#ifrAddSchedule",parent.document).attr("src","about:blank");
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").hide();
		});
	});
		
	function closePop(){
		$("#winAddSchedule",parent.document).hide();
		$("#ifrAddSchedule",parent.document).attr("src","about:blank");
	}
</script>
</html>