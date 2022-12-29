<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0105.jsp
 Program name : 일정추가..?
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
HashMap hMap = null;
if(vLst.size()>0){
	hMap = (HashMap)vLst.get(0);
}else{
	hMap = new HashMap();
}


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>


		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			// ibsheet 초기화
			myChartDraw();
		});
		
		
		function myChartDraw() //BAR
		{
			
			 myChart.SetTitleOptions({
				Text : "",
				Align:"center",
				VerticalAlign:"top",
				Style:{
					Color:"blue",
					FontWeight:'bold'
				}
			}); 
			 myChart.SetPlotOptions({
				Line: {
					//Cursor:"move",
					/* DataLabels : {
						Enabled:true,
						Style:{
						FontSize:'10px',
						FontWeight:'bold'
						},
						 Formatter:function(){
							 if(this.y == "1") return "GREEN";
							 else if(this.y == 2) return "YELLOW";
							 else if(this.y == 3) return "RED";
							 else return "king";
						   }
					} //차트 위에 값 설정 */
					
				}});
			 myChart.SetXAxisOptions({  //X축 속성
				  Categories:['2021 1분기말','2021 2분기말','2022 1분기말','2021 2분기말'],  
				  LineColor:"red",    
				  LineWidth:2, 
				  Labels:{
				   Enabled:true,
				   Align:"center",
				   //Rotation:10,   
				   Style:{
				     Color:"#8B0A50",
				     FontWeight:'bold',
				     FontSize:'15px'
				   }
				  },
				  Title:{
					  Enabled:true,
					  Text:'x축',
					  Style:{
						  FontSize:'20px',
						  Color:'black'
					  }
				  }
				});
			 
			 myChart.SetYAxisOptions({ 
				  LineColor:"red",    
				  LineWidth:2, 
				  Categories:['0','GREEN', 'YELLOW', 'RED'],
				  /* TickInterval:10,
				  MinorTickInterval:5,
				   Labels:{
				   Enabled:true,
				   Align:"center",
				   Rotation:270,   
				   Style:{
				     Color:"#daa520",
				     FontWeight:'bold',
				     FontSize:'15px'
				   }
				  }, */
				  Title:{
				   Enabled:true,
				    Text:'',
				    Style:{
				     FontSize:'20px',
				     Color:'green'
				    },
				    Margin:50,
				    Rotation:0
				  }
				});
			 myChart.SetSeriesOptions([{
				   Type:"line", Name : "추이",   
				   Data : [{Y:1}, {Y:3}, {Y:2}],  //1:GREEN, 2:YELLOW, 3:RED
				   DataLabels:{
			           Enabled:true,
			           Formatter:function(){
							 if(this.y == 1) return "GREEN";
							 else if(this.y == 2) return "YELLOW";
							 else if(this.y == 3) return "RED";
						   }
			        }
				}], 1);
			 
				myChart.Draw();
		}
		  
 		/* Sheet 기본 설정 */
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("fam"); // fam
					$("form[name=ormsForm] [name=process_id]").val("ORFM010104");			
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<div id="" class="popup modal block" > 
		<div class="p_frame w1000"> 
			<div class="p_body"> 
				<div class="p_wrap">  
					<form name="ormsForm" method="post">
						<input type="hidden" id="path" name="path" />             
						<input type="hidden" id="process_id" name="process_id" />  
						<input type="hidden" id="commkind" name="commkind" />       
						<input type="hidden" id="method" name="method" />                      
						<div id="hdng_area"></div>  
						<div id="brcd_area"></div>
					
						<div class="box box-grid">
							<div class="box-header">
								<h3 class="box-title">연별 종합리스크 추이</h3>
							</div>
							<div class="wrap-table" style="width:100%; float:left">
							<table>
								<tbody>
									<tr>
										<th class="ph10 center">기존년도</th>
										<td class="ph10 center"><span id="a2">22232</span></td>
										<th class="ph10 center">위험등급</th>
										<td class="ph10 center"><span id="a2">ㅁㅁㄴㅇ</span></td>
										<th class="ph10 center">리스크값</th>
										<td class="ph10 center"><span id="a2">2412</span></td>
									</tr>
									<tr>
										<th class="ph10 center">산출식</th>
										<td class="ph10 center" colspan="5"><span id="b2">ㄴㅂㅁㅁㄴ</span></td>
									</tr>
									<tr>
										<th class="ph10 center">평가기준</th>
										<td class="ph10 center" colspan="5"><span id="a2">ㄹㄴㄹㄴㄹㄴ</span></td>
									</tr>
								</tbody>
							</table>
							<div class="wrap-grid h250">
								<script type="text/javascript"> createIBChart("myChart","100%","100%"); </script>
							</div>
							</div>
						</div>
					</form>						
				</div><!-- .p_wrap //-->		
				<div class="box-body">
						<div class="wrap-grid scroll" style="height:520px;">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
						<!-- .wrap //-->
				</div>	  
			</div>    <!-- .p_body //-->
			<button class="ico close  fix btn-close"><span class="blind">닫기</span></button>
		</div>
		<div class="dim p_close"></div> 
	</div>  
	
	
		  
	<%@ include file="../comm/OrgInfMP.jsp" %> <!-- 부서 공통 팝업 -->
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 		  
	<%@ include file="../comm/RpInfP.jsp" %> <!-- 리스크풀 팝업 --> 		  
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(){
				$(".popup",parent.document).hide();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				//$(".popup").hide();
			});
		});
			
		function closePop(){
			$("#winNewAccAdd",parent.document).hide();
		}
	</script>
</body>	 	
</html>