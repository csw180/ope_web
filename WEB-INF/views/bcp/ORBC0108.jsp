<%--
/*---------------------------------------------------------------------------
 Program ID   : ORBC0108.jsp
 Program name :고유위험평가
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

DynaForm form = (DynaForm)request.getAttribute("form");

String rsk_c = (String) form.get("hd_rsk_c");
if(rsk_c==null) rsk_c = "";
String ra_sc = (String) form.get("st_ra_sc");
if(ra_sc==null) ra_sc = "";
String f_pfrnm = (String) form.get("hd_f_pfrnm");

ServletContext sctx = request.getSession(true).getServletContext();
String istest = sctx.getInitParameter("isTest");
String servergubun = sctx.getInitParameter("servergubun");

if("2".equals(servergubun)){
	f_pfrnm = new String(f_pfrnm.getBytes("ISO8859_1"), "UTF-8");
}
if(f_pfrnm==null) f_pfrnm = "";
String rsk_pfrnm = (String) form.get("hd_rsk_pfrnm");
if("2".equals(servergubun)){
	rsk_pfrnm = new String(rsk_pfrnm.getBytes("ISO8859_1"), "UTF-8");
}
if(rsk_pfrnm==null) rsk_pfrnm = "";
String ra_dcz_stsc = (String) form.get("hd_ra_dcz_stsc");
if(ra_dcz_stsc==null) ra_dcz_stsc = "";

String hd_bcp_04_0 = (String) form.get("hd_bcp_04_0");
String hd_bcp_04_1 = (String) form.get("hd_bcp_04_1");
String hd_bcp_04_2 = (String) form.get("hd_bcp_04_2");
String hd_bcp_04_3 = (String) form.get("hd_bcp_04_3");
String hd_bcp_04_4 = (String) form.get("hd_bcp_04_4");


System.out.println(ra_dcz_stsc+"==================================================");
System.out.println(hd_bcp_04_0+"==================================================");
System.out.println(hd_bcp_04_1+"==================================================");
System.out.println(hd_bcp_04_2+"==================================================");
System.out.println(hd_bcp_04_3+"==================================================");
System.out.println(hd_bcp_04_4+"==================================================");

%>   
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs();
			
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp"); 
			WP.setParameter("process_id", "ORBC010803");  
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
						   var j = 0;
						   for(var i=0; i<5; i++){
							   $("#bcp_01_"+j).val(rList[i].natv_rsk_dtlc);
							   j++;
						   }
						   j = 0;
						   for(var i=5; i<10; i++){
							   $("#bcp_02_"+j).val(rList[i].natv_rsk_dtlc);
							   j++;
						   }
						   
						   $("#hd_bcp_01").val(rList[0].natv_rsk_hdng_c);
						   $("#hd_bcp_02").val(rList[5].natv_rsk_hdng_c);
					  }
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();
					  search();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);
			removeLoadingWs();
			
		});
		
		function search(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp"); 
			WP.setParameter("process_id", "ORBC010802");  
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						   var rList = result.DATA;
						  
						   if( $("#hd_bcp_01").val()==rList[0].natv_rsk_hdng_c ){
							   if($("#bcp_01_0").val()==rList[0].natv_rsk_dtlc ){
								   document.getElementById("bcp_01_0").checked = true;
							   }else if($("#bcp_01_1").val()==rList[0].natv_rsk_dtlc ){
								   document.getElementById("bcp_01_1").checked = true;
							   }else if($("#bcp_01_2").val()==rList[0].natv_rsk_dtlc ){
								   document.getElementById("bcp_01_2").checked = true;
							   }else if($("#bcp_01_3").val()==rList[0].natv_rsk_dtlc ){
								   document.getElementById("bcp_01_3").checked = true;
							   }else if($("#bcp_01_4").val()==rList[0].natv_rsk_dtlc ){
								   document.getElementById("bcp_01_4").checked = true;
							   }   
						   }
						   if( $("#hd_bcp_02").val()==rList[1].natv_rsk_hdng_c ){
							   if($("#bcp_02_0").val()==rList[1].natv_rsk_dtlc ){
								   document.getElementById("bcp_02_0").checked = true;
							   }else if($("#bcp_02_1").val()==rList[1].natv_rsk_dtlc ){
								   document.getElementById("bcp_02_1").checked = true;
							   }else if($("#bcp_02_2").val()==rList[1].natv_rsk_dtlc ){
								   document.getElementById("bcp_02_2").checked = true;
							   }else if($("#bcp_02_3").val()==rList[1].natv_rsk_dtlc ){
								   document.getElementById("bcp_02_3").checked = true;
							   }else if($("#bcp_02_4").val()==rList[1].natv_rsk_dtlc ){
								   document.getElementById("bcp_02_4").checked = true;
							   }
						   }
					  }
					  
				  },
				  complete: function(statusText,status){
					  removeLoadingWs();
					  sumScr();
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);
			removeLoadingWs();
			
		}
		
		function sumScr(){
			var com = true;
			
			if( $('input[name="bcp_01"]').is(":checked")==false ){
				com = false;
				return;
			}
			if($('input[name="bcp_02"]').is(":checked")==false){
				com = false;
				return;
			}
			if(com){
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "bcp"); 
				WP.setParameter("process_id", "ORBC010804");  
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
						  if(result != 'undefined' && result.rtnCode== '0'){
							  var rList = result.DATA;
							  $("#natv_rsk_evl_scr").text(rList[0].natv_rsk_evl_scr);
							  $("#evl_scr").val(rList[0].natv_rsk_evl_scr);
						  }
							  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  
						  
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);				
				
				
			}
		}
		
		function save_evl(){
			var f = document.ormsForm;
			$("#mode").val("1");
			
			var com = true;
			
			if( $('input[name="bcp_01"]').is(":checked")==false ){
				alert("발생가능성 항목을 선택해주세요.");
				com = false;
				return;
			}
			if($('input[name="bcp_02"]').is(":checked")==false){
				alert("재무적손실영향을 선택해주세요");
				com = false
				return;
			}
			
			if(com){
				if(!confirm("저장하시겠습니까?")) return;
				insert();
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "bcp");
				WP.setParameter("process_id", "ORBC010805");
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//alert(inputData);
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								removeLoadingWs();
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result!='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
							alert("저장되었습니다.");
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
				});	
			}
			
		}
		
		function insert(){
			var row = parent.mySheet2.GetSelectRow();
			
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp"); 
			WP.setParameter("process_id", "ORBC010804");  
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						  var rList = result.DATA;
						  $("#natv_rsk_evl_scr").text(rList[0].natv_rsk_evl_scr);
						  
						  parent.mySheet2.SetCellValue(row, "natv_rsk_evl_scr", rList[0].natv_rsk_evl_scr);
						  parent.mySheet2.SetCellValue(row, "rm_rsk_evl_scr", rList[0].natv_rsk_evl_scr);
						  
					  }
						  
				  },
				  
				  complete: function(statusText,status){
					  removeLoadingWs();

					  save_scr();
					  
					  
				  },
				  
				  error: function(rtnMsg){
					  alert(JSON.stringify(rtnMsg));
				  }
			    }
			);				
				
				
			
		} 		
		
		function save_scr(){
			var f = document.ormsForm;
			$("#mode").val("2");
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "bcp");
			WP.setParameter("process_id", "ORBC010805");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			//alert(inputData);
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("저장하였습니다.");
							removeLoadingWs();
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
			
	
		
		
	</script>
</head>
<body>
	<form name="ormsForm">
		<input type="hidden" id="path" name="path" />
		<input type="hidden" id="process_id" name="process_id" />
		<input type="hidden" id="commkind" name="commkind" />
		<input type="hidden" id="method" name="method" />
		<input type="hidden" id="today" name="today" value="<%=dt %>" />
		<input type="hidden" id="hd_rsk_c" name="hd_rsk_c" value="<%=rsk_c %>" />
		<input type="hidden" id="hd_ra_sc" name="hd_ra_sc" value="<%=ra_sc %>" />
		<input type="hidden" id="hd_ra_dcz_stsc" name="hd_ra_dcz_stsc" value="<%=ra_dcz_stsc %>" />
		<input type="hidden" id="hd_bcp_01" name="hd_bcp_01" />
		<input type="hidden" id="hd_bcp_02" name="hd_bcp_02" />
		<input type="hidden" id="evl_scr" name="evl_scr" />
		<input type="hidden" id="mode" name="mode" />
		<div id="bcp_html"></div>
	
	<div id="" class="popup modal block">
			<div class="p_frame w1100">

				<div class="p_head">
					<h3 class="title">고유위험평가</h3>
				</div>


				<div class="p_body">
					
					<div class="p_wrap">

						<div class="box box-grid">						
							<div class="box-body">
								<div class="wrap-table">
									<table>
										<colgroup>
											<col style="width: 100px;">
											<col style="width: 130px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th>위험요소</th>
												<td colspan="2">
													<%=f_pfrnm  %><i class="fa fa-angle-right ci pw5"></i><%=rsk_pfrnm %>
												</td>
											</tr>
											<tr>
												<th rowspan="3">위험 특성평가</th>
												<th class="light">발생 가능성</th>
												<td>
													<ul class="step-select" onchange="javascript:sumScr()">
														<li>
															<input type="radio" name="bcp_01" id="bcp_01_0">
															<label for="bcp_01_0">10년에 1회도 가능성 없음</label>
														</li>
														<li>
															<input type="radio" name="bcp_01" id="bcp_01_1" >
															<label for="bcp_01_1">5년에 최소 1회 발생 가능</label>
														</li>
														<li>
															<input type="radio" name="bcp_01" id="bcp_01_2" >
															<label for="bcp_01_2">1년에 최소 1회 발생 가능</label>
														</li>
														<li>
															<input type="radio" name="bcp_01" id="bcp_01_3" >
															<label for="bcp_01_3">1개월에 최소 1회 발생 가능</label>
														</li>
														<li>
															<input type="radio" name="bcp_01" id="bcp_01_4" >
															<label for="bcp_01_4">1주일에 최소 1회 발생 가능</label>
														</li>
													</ul>
												</td>
											</tr>
											<tr>
												<th class="light">예측 가능성</th>
												<td>
													<ul class="step-select">
														<!-- <li>
															<input type="radio" name="bcp_02" id="bcp_02_0" >
															<label for="bcp_02_0">예측 가능</label>
														</li>
														<li>
															<input type="radio" name="bcp_02" id="bcp_02_1" >
															<label for="bcp_02_1">예측 불가능</label>
														</li> -->
													</ul>
												</td>
											</tr>
											<tr>
												<th class="light">영향기간</th>
												<td>
													<ul class="step-select">
														<!-- <li>
															<input type="radio" name="bcp_03" id="bcp_03_0" >
															<label for="bcp_03_0">1일간 지속</label>
														</li>
														<li>
															<input type="radio" name="bcp_03" id="bcp_03_1" >
															<label for="bcp_03_1">1주일간 지속</label>
														</li>
														<li>
															<input type="radio" name="bcp_03" id="bcp_03_2" >
															<label for="bcp_03_2">1개월간 지속</label>
														</li> -->
													</ul>
												</td>
											</tr>
											<tr>
												<th rowspan="2">위험 영향평가</th>
												<th class="light">영향 유형</th>
												<td>
													<ul class="step-select">
														<!-- <li>
															<input type="checkbox" name="bcp_04" id="bcp_04_0">
															<label for="bcp_04_0">사업장 접근불가</label>
														</li>
														<li>
															<input type="checkbox" name="bcp_04" id="bcp_04_1">
															<label for="bcp_04_1">인력 손실 및 손상</label>
														</li>
														<li>
															<input type="checkbox" name="bcp_04" id="bcp_04_2">
															<label for="bcp_04_2">중요 자원 손상</label>
														</li>
														<li>
															<input type="checkbox" name="bcp_04" id="bcp_04_3" >
															<label for="bcp_04_3">시스템 사용불가</label>
														</li>
														<li>
															<input type="checkbox" name="bcp_04" id="bcp_04_4" >
															<label for="bcp_04_4">대내외 지원 중단</label>
														</li> -->
													</ul>
												</td>
											</tr>
											<tr>
												<th class="light">재무적 손실 영향<br>(최대금액)</th>
												<td>
													<ul class="step-select" onchange="javascript:sumScr()">
														<li>
															<input type="radio" name="bcp_02" id="bcp_02_0" >
															<label for="bcp_02_0">1억 미만 자산손실</label>
														</li>
														<li>
															<input type="radio" name="bcp_02" id="bcp_02_1" >
															<label for="bcp_02_1">1억 이상 10억 미만 자산손실</label>
														</li>
														<li>
															<input type="radio" name="bcp_02" id="bcp_02_2" >
															<label for="bcp_02_2">10억 이상 100억 미만 자산손실</label>
														</li>
														<li>
															<input type="radio" name="bcp_02" id="bcp_02_3" >
															<label for="bcp_02_3">100억 이상 5000억 미만 자산손실</label>
														</li>
														<li>
															<input type="radio" name="bcp_02" id="bcp_02_4" >
															<label for="bcp_02_4">5000억 이상 자산손실</label>
														</li>
													</ul>
												</td>
											</tr>
										</tbody>
									</table>

									<table class="mt5">
										<tr>
											<td class="center ph10">
													고유위험평가 점수 :<strong class="pl10 txt txt-lg cm"><span id="natv_rsk_evl_scr"></span></strong>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>

					</div>
					
				</div>


				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="javascript:save_evl();">저장</button>
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
			$("#winEvlScr",parent.document).hide();
		}
	</script>
</body>
</html>