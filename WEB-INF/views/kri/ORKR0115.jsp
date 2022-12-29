<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0117.jsp
 Program name : 조치계획 작성
 Description  : 
 Programer    : 양진모
 Date created : 2020.07.30
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vLst = CommUtil.getCommonCode(request, "KRI_LMT_DSC");
if(vLst==null) vLst = new Vector();

Vector vActDtlLst= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vActDtlLst==null) vActDtlLst = new Vector();

System.out.println(vLst.size());
System.out.println(vActDtlLst.size());
		

HashMap hActDtlMap = null;
if(vActDtlLst.size()>0){
	hActDtlMap = (HashMap)vActDtlLst.get(0);
}else{
	hActDtlMap = new HashMap();
}

System.out.println((String)hActDtlMap.get("rkinm"));

String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");
String auth = "";


for(int i=0; i<auth_grp_id.length; i++){
	//System.out.println("auth_grp_id:"+auth_grp_id[i]);
	if(auth_grp_id[i].equals("003")){
		auth = "003";
		
		break;
	}
}

SysDateDao dao = new SysDateDao(request);

String dt = dao.getSysdate();//yyyymmdd

String today = dt.substring(0,4)+"-"+dt.substring(4,6);

DynaForm form = (DynaForm)request.getAttribute("form");
String hd_bas_ym = (String)form.get("hd_bas_ym");
String sch_rki_id = (String)form.get("sch_rki_id");
String hd_apl_brc = (String)form.get("hd_apl_brc");
String number = (String)form.get("number");

String act_dcz_stsc =(String)hActDtlMap.get("act_dcz_stsc");
if(act_dcz_stsc==null) act_dcz_stsc = "";

String hd_brc = (String)hs.get("brc");

String all_gubun = "1";
if(!hofc_bizo_dsc.equals("03") && !hofc_bizo_dsc.equals("04") && "전영업점".equals((String)hActDtlMap.get("apl_brnm"))){
	all_gubun = "2";
}

%>   
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<script>
	var act_dcz_stsc = "<%=act_dcz_stsc%>";
	var hd_brc = "<%=hd_brc%>";
	var hd_apl_brc = "<%=hd_apl_brc%>";
	
		$(document).ready(function(){

			
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			

			//placeholder_color();
			//placeholderMasking(); //20210226 원인분석 , 세부 조치결과에 placeholder 삽입
			
			
			
		});
		
		//var placeholder_masking = "\"예금주 성명\", \"계좌번호\"등의 개인정보는 마스킹 처리하여 입력부탁드립니다.\n예)김**, 301-****-****-11, 011-****-****-31 등"
		

		
		/*20210315 현업 요청에 의하여 PlaceHolder 에 색을 입히는 작업을 위해 placeholder_color 함수 생성 */
/*		
		$('#cas_dtl_cntn').click(function() {
			if($('#cft_plan_cntn').text()!="")
				$('#cft_plan_cntn').show();
			if($('#exe_rzt_cntn').text()!="")
				$('#exe_rzt_cntn').show();
		});
		
		$('#cft_plan_cntn').focusout(function() {
		});
		
		$('#exe_rzt_cntn').focusout(function() {
		});
		
		function placeholder_color()
		{	//PlaceHolder 초기화
			if($('#cas_dtl_cntn').text()=="" && $('#cft_plan_cntn').text()=="" &&  $('#exe_rzt_cntn').text()=="")
				{
					var place_Switch = 'Y'
					$('#cas_dtl_cntn').hide();
					$('#place_hidden_1').show();
					$('#cft_plan_cntn').hide();
					$('#place_hidden_2').show();
					$('#exe_rzt_cntn').hide();
					$('#place_hidden_3').show()
				}
			else if($('#cas_dtl_cntn').text()=="")
				{
					var place_Switch = 'Y'
					$('#cas_dtl_cntn').hide();
					$('#place_hidden_1').show(); 
				}
			else if($('#cft_plan_cntn').text()=="")
				{
					var place_Switch = 'Y'
					$('#cft_plan_cntn').hide();
					$('#place_hidden_2').show();
				}
			else if($('#exe_rzt_cntn').text()=="")
				{
					var place_Switch = 'Y'
					$('#exe_rzt_cntn').hide();
					$('#place_hidden_3').show();
				}
			else if($('#act_dcz_stsc').val()=="01"||$('#act_dcz_stsc').val()=="02")   //반려 및 임시저장일떄도 PlaceHolder 적용 가능하게 수정 -> 승인요청 해도 수정 가능하게 .....
				{
					var place_Switch = 'Y';
				}
			else
				{
					var place_Switch = 'N';
				}
			
			//place_Switch 'Y' 일떄만 작동 되게 함
			
			if(place_Switch =="Y")
			    {
					$(document).click(function(event)
					{
						//원인분석 PlaceHolder
						if((event.target.id == "cas_dtl_cntn"||event.target.id == "place_hidden_1"))
							{
								$('#place_hidden_1').hide();
								$('#cas_dtl_cntn').show();
								$('#cas_dtl_cntn').focus();
							}
						else if( $('#cas_dtl_cntn').text()=="")
							{
								$('#cas_dtl_cntn').hide();
								$('#place_hidden_1').show();
							}
						//대응방안 PlaceHolder
						if((event.target.id == "cft_plan_cntn"||event.target.id == "place_hidden_2"))
							{
								$('#place_hidden_2').hide();
								$('#cft_plan_cntn').show();
								$('#cft_plan_cntn').focus();
							}
						else if( $('#cft_plan_cntn').text()=="")
							{
								$('#cft_plan_cntn').hide();
								$('#place_hidden_2').show();
							}			
						// 조치결과 PlaceHolder
						if((event.target.id == "exe_rzt_cntn"||event.target.id == "place_hidden_3"))
							{
								$('#place_hidden_3').hide();
								$('#exe_rzt_cntn').show();
								$('#exe_rzt_cntn').focus();
							}
						else if( $('#exe_rzt_cntn').text()=="")
							{
								$('#exe_rzt_cntn').hide();
								$('#place_hidden_3').show();
							}	
					}); 
			    }
			
		}
*/		
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				
		
		var save_bf_req = false;
		function doAction(sAction){
			switch(sAction){
			case "search": //데이터조회

				
				break;
			case "save"://저장
				save_bf_req = false;
				var f = document.ormsForm;
				if($("textarea#cas_dtl_cntn").val()==""){
					alert("원인분석내용을 입력해 주세요");
					break;					
				}
				if($("textarea#cft_plan_cntn").val()==""){
					alert("조치계획을 입력해 주세요");
					break;					
				}
				
				$("#mode").val("U");
				save();
				
				/*
				if($("#act_dcz_stsc").val() == ""){
					save();
				}
				else if($("#act_dcz_stsc").val() == "01"||$("#act_dcz_stsc").val() == "02"){
					$("#mode").val("U");
					save();
				}
				else{
					alert("결재가 완료되었습니다.");
					return;
				}
				*/
				
				break;
			case "save_request":
				save_bf_req = true;
				var f = document.ormsForm;
				if($("textarea#cas_dtl_cntn").val()==""){
					alert("원인분석내용을 입력해 주세요");
					break;					
				}
				if($("textarea#cft_plan_cntn").val()==""){
					alert("조치계획을 입력해 주세요");
					break;					
				}
				if($("#act_dcz_stsc").val() == ""){
					save();
				}
				else if($("#act_dcz_stsc").val() == "01" || $("#act_dcz_stsc").val() == "02"){
					$("#mode").val("U");
					save();
				}
				else{
					alert("결재가 완료되었습니다.");
					return;
				}
				break;
			case "request":
				var f = document.ormsForm;

				$("#mode").val("Q");
				request();

				break;	
			case "dtlData":
				$("#ifrDtlData").attr("src","about:blank");
				$("#winDtlData").show();
				showLoadingWs(); // 프로그래스바 활성화
				setTimeout(dtlData,1);
				
				break;
			}
		} 
		
		function save(){
			var f = document.ormsForm;
			
			if(save_bf_req){
				if(!confirm("저장후 결재 하시겠습니까?")) return;
			}else{
				if(!confirm("저장 하시겠습니까?")) return;
			}
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "kri");
			WP.setParameter("process_id", "ORKR011104");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							if(save_bf_req){
								alert(result.rtnMsg);
								doAction("request");						
							}else{
								alert(result.rtnMsg);
							}
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
	<article class="popup modal block">
		<div class="p_frame w1100">
			<div class="p_head">
<%
auth = "003"; // 테스트를 위해 추가 JHS
System.out.println("auth -->" + auth + "<---");
System.out.println("act_dcz_stsc -->" + act_dcz_stsc);
if(auth.equals("003") && (act_dcz_stsc.equals("") || act_dcz_stsc.equals("01"))){    
%>						
				<h1 class="title">대응방안 및 실행결과  입력</h1>
<%
}else{
%>
				<h1 class="title">대응방안 및 실행결과  조회</h1>
<%
}
%>							
			</div>	
			<div class="p_body" >	
				<div class="p_wrap">
					<form id="ormsForm" name="ormsForm">
						<input type="hidden" id="path" name="path" />
						<input type="hidden" id="process_id" name="process_id" />
						<input type="hidden" id="commkind" name="commkind" />
						<input type="hidden" id="method" name="method" />
						<input type="hidden" id="act_dcz_stsc" name="act_dcz_stsc" value="<%=act_dcz_stsc %>" />
						<input type="hidden" id="sch_rki_id" name="sch_rki_id" value="<%=sch_rki_id %>" />
						<input type="hidden" id="hd_bas_ym" name="hd_bas_ym" value="<%=hd_bas_ym %>"  />
						<input type="hidden" id="hd_apl_brc" name="hd_apl_brc" value="<%=hd_apl_brc %>"  />
						<input type="hidden" id="number" name="number" value="<%=number %>"  />
						<input type="hidden" id="mode" name="mode" value="" />
						<input type="hidden" id="sel_bas_ym" name="sel_bas_ym" value="" />
					
						<input type="hidden" id="sch2_bas_ym" name="sch2_bas_ym" value="<%=hd_bas_ym %>"  />
						<input type="hidden" id="rki_id" name="rki_id" value="<%=sch_rki_id %>"  />
						<input type="hidden" id="brc" name="brc" value="<%=hd_apl_brc %>"  />
						<input type="hidden" id="all_gubun" name="all_gubun" value="<%=all_gubun%>"  />
						<input type="hidden" id="auth" name="auth" value="<%=auth%>"  />

						<section class="box box-grid">

							<div class="wrap-table">
								<table>
									<colgroup>   
										<col style="width:100px" />
										<col  />
										<col style="width:100px" />
										<col  />
										<col style="width:100px" />
										<col  />
									</colgroup>
									<tbody>
										<tr>
											<th>지표명</th>
											<td colspan="3">
												<input type="text" class="form-control" id="rkinm" value="<%=(String)hActDtlMap.get("rkinm")%>" readonly />
											</td>
											<th>KRI ID</th>
											<td colspan="1">
												<input type="text" class="form-control" id="rki_id" value="<%=(String)hActDtlMap.get("rki_id")%>" readonly />
											</td>
											
										</tr>
										<tr>
											<th>평가년월</th>
											<td>
												<input type="text" class="form-control" id="bas_ym" value="<%=(String)hActDtlMap.get("bas_ym")%>" readonly />
											</td>
											<th>평가 조직</th>
											<td>	
												<input type="text" class="form-control" id="apl_brnm" value="<%=(String)hActDtlMap.get("apl_brnm")%>" readonly />
											</td>
											<th>지표값</th>
											<td>
												<input type="text" class="form-control" id="kri_nvl" value="<%=(String)hActDtlMap.get("kri_nvl")%>" readonly />
											</td>
										</tr>
										<tr>
											<th>KRI 등급</th>
											<td>
												<input type="text" class="form-control" id="kri_grdnm" value="<%=(String)hActDtlMap.get("kri_grdnm")%>" readonly />
											</td>
											<th>단위</th>
											<td>
												<input type="text" class="form-control" id="kri_unt_nm" value="<%=(String)hActDtlMap.get("rki_unt_nm")%>" readonly />
											</td>
											<th>KRI 속성</th>
											<td>
												<input type="text" class="form-control" id="rki_lvl_c" value="<%=(String)hActDtlMap.get("kri_lvlnm")%>" readonly />
											</td>
										</tr>
										<tr>
											<th>원인분석</th>
<% 
if(act_dcz_stsc.equals("02") || act_dcz_stsc.equals("03") || act_dcz_stsc.equals("04")){
%>
										
											<td colspan="5">
												<textarea id="cas_dtl_cntn" name="cas_dtl_cntn" class="form-control" readonly><%=StringUtil.htmlEscape((String)hActDtlMap.get("cas_dtl_cntn"),false,false)%></textarea>
											</td>	
<%
}else{
	if(hd_brc.equals(hd_apl_brc)){
%>		
											<td colspan="5">
												<textarea id="cas_dtl_cntn" name="cas_dtl_cntn" class="form-control"><%=StringUtil.htmlEscape((String)hActDtlMap.get("cas_dtl_cntn"),false,false)%></textarea>
												<div id="place_hidden_1" class="wrap-footnote ph5" style="display: none;">
													<div id="place_hidden_1"><span id="place_hidden_1" class="cm">"예금주 성명"</span>, <span id="place_hidden_1" class="cm">"계좌번호"</span>,<span id="place_hidden_1" class="cm">"카드번호"</span>등의 개인정보는 <span id="place_hidden_1" class="cm">마스킹</span> 처리하여 입력부탁드립니다.</div>
													<div id="place_hidden_1">예)김**, 301-****-****-11, 011-****-****-31, 94**-****-****-73 등</div>
												</div>
											</td>
<%
	}else{
		
%>
											<td colspan="5">
												<textarea id="cas_dtl_cntn" name="cas_dtl_cntn" class="form-control" readonly><%=StringUtil.htmlEscape((String)hActDtlMap.get("cas_dtl_cntn"),false,false)%></textarea>
											</td>
<%		
	}
}
%>
										</tr>	
										<tr>
											<th>대응방안</th>
<% 
if(act_dcz_stsc.equals("02") || act_dcz_stsc.equals("03") || act_dcz_stsc.equals("04")){
%>											
											<td colspan="5">
												<textarea id="cft_plan_cntn" name="cft_plan_cntn" class="form-control" readonly ><%=StringUtil.htmlEscape((String)hActDtlMap.get("cft_plan_cntn"),false,false)%></textarea>
											</td>
<%
}else{
	if(hd_brc.equals(hd_apl_brc)){
%>
											<td colspan="5">
												<textarea id="cft_plan_cntn" name="cft_plan_cntn" class="form-control" ><%=StringUtil.htmlEscape((String)hActDtlMap.get("cft_plan_cntn"),false,false)%></textarea>
												
												<div id="place_hidden_2" class="wrap-footnote ph5" style="display: none;">
													<div id="place_hidden_2"><span id="place_hidden_2" class="cm">"예금주 성명"</span>, <span id="place_hidden_2" class="cm">"계좌번호"</span>,<span id="place_hidden_2" class="cm">"카드번호"</span>등의 개인정보는 <span id="place_hidden_2" class="cm">마스킹</span> 처리하여 입력부탁드립니다.</div>
													<div id="place_hidden_2">예)김**, 301-****-****-11, 011-****-****-31, 94**-****-****-73 등</div>
												</div>
											</td>
<%
	}else{
%>
											<td colspan="5">
												<textarea id="cft_plan_cntn" name="cft_plan_cntn" class="form-control"  ><%=StringUtil.htmlEscape((String)hActDtlMap.get("cft_plan_cntn"),false,false)%></textarea>
											</td>
<%
	}
}
%>											
										</tr>
										<tr>
											<th>실행결과</th>
<% 
if(act_dcz_stsc.equals("02") || act_dcz_stsc.equals("03") || act_dcz_stsc.equals("04")){
%>											
											<td colspan="5">
												<textarea id="exe_rzt_cntn" name="exe_rzt_cntn" cols="20" rows="5" class="form-control" readonly ><%=StringUtil.htmlEscape((String)hActDtlMap.get("exe_rzt_cntn"),false,false)%></textarea>
											</td>
<%
}else{
	if(hd_brc.equals(hd_apl_brc)){
%>
											<td colspan="5">
												<textarea id="exe_rzt_cntn" name="exe_rzt_cntn" class="form-control" ><%=StringUtil.htmlEscape((String)hActDtlMap.get("exe_rzt_cntn"),false,false)%></textarea>
												
												<div id="place_hidden_3" class="wrap-footnote ph5" style="display: none;">
													<div id="place_hidden_3"><span id="place_hidden_3" class="cm">"예금주 성명"</span>, <span id="place_hidden_3" class="cm">"계좌번호"</span>,<span id="place_hidden_3" class="cm">"카드번호"</span>등의 개인정보는 <span id="place_hidden_3" class="cm">마스킹</span> 처리하여 입력부탁드립니다.</div>
													<div id="place_hidden_3">예)김**, 301-****-****-11, 011-****-****-31, 94**-****-****-73 등</div>
												</div>
											</td>
<%
	}else{
%>
											<td colspan="5">
												<textarea id="exe_rzt_cntn" name="exe_rzt_cntn" class="form-control" readonly ><%=StringUtil.htmlEscape((String)hActDtlMap.get("exe_rzt_cntn"),false,false)%></textarea>
											</td>
<%
	}
}
%>											
										</tr>
									</tbody>
								</table>
							</div>
						</section>
						<section class="box box-grid" style="display:none;">
							<div class="wrap-grid h200">
							</div>
						</section>
					</form>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
<% 
if(auth.equals("003") && (act_dcz_stsc.equals("") || act_dcz_stsc.equals("01"))){
%>						
					<button class="btn btn-default" type="button" onclick="doAction('save');">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
<%
}else{
%>
					<button type="button" class="btn btn-default btn-close">닫기</button>
<%
}
%>							
				</div>
			</div>
			<button type="button" class="ico close  fix btn-close"><span class="blind">닫기</span></button>
				
		</div>

		<div class="dim p_close"></div>
	</article>
	
	<div id="winDtlData" class="popup modal">
		<iframe name="ifrDtlData" id="ifrDtlData" src="about:blank"></iframe>	
	</div>
	
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
		$("#winActDtl",parent.document).hide();
	}
	function dtlClose(){
		$("#winDtlData").hide();
	}
	</script>
</body>
</html>